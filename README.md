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

## Como Reproduzir os Ambientes e Coletar Métricas
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
