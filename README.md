# Trabalho Prático: Roteamento Dinâmico (BGP, OSPF e RIPv2)

Implementação, configuração e análise comparativa de protocolos de encaminhamento dinâmico sobre topologia em anel/malha utilizando **Linux Network Namespaces** (`ip netns`) e **BIRD 2**.

## 1. Arquitetura da Solução

O ambiente foi desenvolvido sobre o kernel Linux utilizando recursos nativos de virtualização e o daemon de roteamento **BIRD (v2.x)**:
* **Linux Network Namespaces (`ip netns`):** Cada roteador (R1 a R5) opera dentro de um namespace de rede isolado com as suas próprias tabelas de encaminhamento (FIB), interfaces e pilha TCP/IP independente.
* **Enlaces Virtuais (`veth pairs`):** A comunicação entre os nós é efetuada por pares de interfaces virtuais conectadas ponto a ponto, simulando cabos físicos diretos em memória.
* **Redes Locais de Clientes (Interfaces `dummy`):** Foram criadas interfaces do tipo `dummy` (`lan`) em cada nó para emular LANs de clientes conectadas aos roteadores. Uma interface `dummy` permanece sempre no estado `UP`, garantindo que os daemons de roteamento anunciem os prefixos sem necessidade de instanciar nós ou máquinas virtuais adicionais.
* **Sockets de Controle Independentes:** Cada roteador possui um socket Unix dedicado em `/tmp/bird-rX.ctl`, permitindo interações e consultas pontuais via utilitário `birdc`.

## 2. Topologia Física e Lógica

A rede é composta por 5 roteadores dispostos em malha parcial, garantindo caminhos redundantes e ausência de pontos únicos de falha[cite: 6, 25].

### Plano de Endereçamento IP

#### Enlaces Ponto a Ponto (`/30`)
As interconexões diretas entre os roteadores utilizam a gama `10.0.XY.0/30`, onde $X$ e $Y$ representam os nós conectados:
* **R1 $\leftrightarrow$ R2:** `10.0.12.0/30` (`eth_r2` em R1: `10.0.12.1`, `eth_r1` em R2: `10.0.12.2`)
* **R1 $\leftrightarrow$ R3:** `10.0.13.0/30` (`eth_r3` em R1: `10.0.13.1`, `eth_r1` em R3: `10.0.13.2`)
* **R2 $\leftrightarrow$ R4:** `10.0.24.0/30` (`eth_r4` em R2: `10.0.24.1`, `eth_r2` em R4: `10.0.24.2`)
* **R3 $\leftrightarrow$ R4:** `10.0.34.0/30` (`eth_r4` em R3: `10.0.34.1`, `eth_r3` em R4: `10.0.34.2`)
* **R3 $\leftrightarrow$ R5:** `10.0.35.0/30` (`eth_r5` em R3: `10.0.35.1`, `eth_r3` em R5: `10.0.35.2`)
* **R4 $\leftrightarrow$ R5:** `10.0.45.0/30` (`eth_r5` em R4: `10.0.45.1`, `eth_r4` em R5: `10.0.45.2`)

#### Redes de Acesso / LANs (`/24`)
* **LAN R1:** `192.168.10.1/24`
* **LAN R2:** `192.168.20.1/24`
* **LAN R3:** `192.168.30.1/24`
* **LAN R4:** `192.168.40.1/24`
* **LAN R5:** `192.168.50.1/24`

### Organização Lógica dos Protocolos
* **BGP:** Segmentado em 3 Sistemas Autónomos. **AS 100** (R1 e R3 com iBGP), **AS 200** (R2 e R4 com iBGP) e **AS 300** (R5 com eBGP em direção a R3 e R4).
* **OSPFv2:** Domínio único na **Área 0 (Backbone)**. As interfaces `veth` operam no modo ponto a ponto com custo fixo e as interfaces `lan` são configuradas como `stub` para anunciar a sub-rede sem enviar pacotes de sinalização.
* **RIPv2:** Domínio plano trocando atualizações por multicast (`224.0.0.9`, UDP 520) com métrica de saltos.

## Protocolos Avaliados
1. **BGP:** Roteamento entre 3 AS (AS 100: R1, R3; AS 200: R2, R4; AS 300: R5).
2. **OSPFv2:** Protocolo Link-State em área única (Área 0 Backbone).
3. **RIPv2:** Protocolo Distance-Vector baseado em contagem de saltos.

## Como Reproduzir os Ambientes e Coletar Métricas
# pré-requisitos 
```bash
sudo apt-get update
sudo apt-get install -y bird2 tcpdump traceroute python3 python3-matplotlib iproute2
```bash
# 1. Configurar a topologia física e lógica
sudo ./scripts/setup_topology.sh

# 2. Execução individual com medição automatizada:
# BGP:
./scripts/start_bgp.sh; sleep 30; sudo ./scripts/medir.sh bgp; ./scripts/stop.sh

# OSPF:
sudo ./scripts/setup_topology.sh
./scripts/start_ospf.sh; sleep 30; sudo ./scripts/medir.sh ospf; ./scripts/stop.sh

# RIPv2:
sudo ./scripts/setup_topology.sh
./scripts/start_rip.sh; sleep 30; sudo ./scripts/medir.sh rip; ./scripts/stop.sh

# 3. Gerar os gráficos comparativos das métricas
python3 scripts/gerar_graficos.py
