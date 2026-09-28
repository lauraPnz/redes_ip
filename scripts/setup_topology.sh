#!/usr/bin/env bash

# Ativa roteamento IP no host
sudo sysctl -w net.ipv4.ip_forward=1 > /dev/null

echo "[1/4] Limpando namespaces anteriores se existirem..."
for r in r1 r2 r3 r4 r5; do
    sudo ip netns del $r 2>/dev/null
done

echo "[2/4] Criando os 5 roteadores (R1 a R5)..."
for r in r1 r2 r3 r4 r5; do
    sudo ip netns add $r
    sudo ip netns exec $r sysctl -w net.ipv4.ip_forward=1 > /dev/null
    sudo ip netns exec $r ip link set lo up
done

# Funcao auxiliar para interligar roteadores
connect_p2p() {
    local n1=$1; local if1=$2; local ip1=$3
    local n2=$4; local if2=$5; local ip2=$6

    sudo ip link add $if1 type veth peer name $if2
    sudo ip link set $if1 netns $n1
    sudo ip link set $if2 netns $n2

    sudo ip netns exec $n1 ip addr add $ip1 dev $if1
    sudo ip netns exec $n1 ip link set $if1 up

    sudo ip netns exec $n2 ip addr add $ip2 dev $if2
    sudo ip netns exec $n2 ip link set $if2 up
}

echo "[3/4] Conectando links ponto-a-ponto entre os roteadores..."
# AS 100 <-> AS 200
connect_p2p r1 eth_r2 10.0.12.1/30 r2 eth_r1 10.0.12.2/30
connect_p2p r3 eth_r4 10.0.34.1/30 r4 eth_r3 10.0.34.2/30

# Links internos (iBGP/IGP)
connect_p2p r1 eth_r3 10.0.13.1/30 r3 eth_r1 10.0.13.2/30
connect_p2p r2 eth_r4 10.0.24.1/30 r4 eth_r2 10.0.24.2/30

# AS 100/200 <-> AS 300
connect_p2p r3 eth_r5 10.0.35.1/30 r5 eth_r3 10.0.35.2/30
connect_p2p r4 eth_r5 10.0.45.1/30 r5 eth_r4 10.0.45.2/30

echo "[4/4] Configurando as redes de acesso (LANs)..."
declare -A lans=( ["r1"]="192.168.10.1/24" ["r2"]="192.168.20.1/24" ["r3"]="192.168.30.1/24" ["r4"]="192.168.40.1/24" ["r5"]="192.168.50.1/24" )

for r in "${!lans[@]}"; do
    sudo ip netns exec $r ip link add name lan type dummy
    sudo ip netns exec $r ip addr add ${lans[$r]} dev lan
    sudo ip netns exec $r ip link set lan up
done

echo "Topologia criada e ativa com sucesso!"
