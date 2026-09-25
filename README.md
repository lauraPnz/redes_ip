# Trabalho Prático: Roteamento Dinâmico (BGP, OSPF e RIPv2)

Implementação, configuração e análise comparativa de protocolos de encaminhamento dinâmico sobre topologia em anel/malha utilizando **Linux Network Namespaces** (`ip netns`) e **BIRD 2**.

## Topologia
- 5 routers virtuais (R1 a R5).
- Enlaces ponto-a-ponto `/30`.
- LANs de acesso `/24` associadas a cada router.

## Protocolos Avaliados
1. **BGP:** Roteamento entre 3 AS (AS 100: R1, R3; AS 200: R2, R4; AS 300: R5).
2. **OSPFv2:** Protocolo Link-State em área única (Área 0 Backbone).
3. **RIPv2:** Protocolo Distance-Vector baseado em contagem de saltos.

## Como Reproduzir os Ambientes
```bash
# 1. Subir a topologia
sudo ./scripsts/setup_topology.sh

# 2. Iniciar um protocolo pretendido (ex: BGP)
./scripsts/start_bgp.sh

# 3. Validar conectividade
sudo ip netns exec r1 ping -c 3 192.168.50.1

# 4. Parar o protocolo
./scripsts/stop_bgp.sh
