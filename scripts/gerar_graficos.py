import csv
from pathlib import Path
import matplotlib.pyplot as plt

D = Path(__file__).resolve().parent.parent / 'resultados'
linhas = list(csv.DictReader(open(D / 'metricas.csv')))
protocolos = [l['protocolo'].upper() for l in linhas]

# Mapeamento com correção de chave caso rtt_ms e saltos estejam invertidos no CSV
METRICAS = [
    ('rotas_kernel', 'rotas_kernel', 'Rotas na tabela do kernel (R1)', 'rotas'),
    ('rotas_bird',   'rotas_bird',   'Rotas na tabela do BIRD (R1)',   'rotas'),
    ('pacotes',      'pacotes',      'Pacotes de controle em 120 s (R3)', 'pacotes'),
    ('taxa_Bps',     'taxa_Bps',     'Taxa de controle em repouso (R3)', 'bytes/s'),
    ('rtt_ms',       'saltos',       'RTT médio LAN R1 → LAN R5',       'ms'),
    ('saltos',       'rtt_ms',       'Saltos LAN R1 → LAN R5',          'saltos'),
    ('queda_s',      'queda_s',      'Tempo sem conectividade após falha R1–R3', 's'),
]

for ficheiro, coluna_csv, titulo, unidade in METRICAS:
    plt.figure(figsize=(6, 4))
    valores = [float(l[coluna_csv]) for l in linhas]
    plt.bar(protocolos, valores, color=['#2b5c8f', '#46a36c', '#d95f02'])
    plt.title(titulo)
    plt.ylabel(unidade)
    plt.grid(axis='y', linestyle='--', alpha=0.5)
    plt.tight_layout()
    plt.savefig(D / f'{ficheiro}.png', dpi=200)
    plt.close()

print('Gráficos corrigidos com sucesso em', D)
