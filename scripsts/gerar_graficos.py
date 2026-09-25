import matplotlib.pyplot as plt
import numpy as np

protocolos = ['BGP', 'OSPF', 'RIPv2']

# 1. Tamanho da Tabela de Encaminhamento (Kernel vs BIRD)
rotas_kernel = [14, 18, 10]
rotas_bird = [19, 12, 5]

x = np.arange(len(protocolos))
width = 0.35

fig, ax = plt.subplots(figsize=(8, 5))
ax.bar(x - width/2, rotas_kernel, width, label='Rotas Kernel (Linux)', color='#2b5c8f')
ax.bar(x + width/2, rotas_bird, width, label='Rotas BIRD', color='#46a36c')

ax.set_ylabel('Quantidade de Rotas')
ax.set_title('Tamanho da Tabela de Encaminhamento no Router R1')
ax.set_xticks(x)
ax.set_xticklabels(protocolos)
ax.legend()
ax.grid(axis='y', linestyle='--', alpha=0.7)

plt.tight_layout()
plt.savefig('/home/laura/trabalho_redes/capturas/tamanho_tabelas.png', dpi=300)
plt.close()

# 2. Overhead de Tráfego de Controlo (Pacotes e Bytes em Repouso ~30s)
pacotes = [6, 18, 6]
bytes_totais = [489, 1584, 912]

fig, ax1 = plt.subplots(figsize=(8, 5))

color = '#d95f02'
ax1.set_xlabel('Protocolo')
ax1.set_ylabel('Pacotes de Controlo', color=color)
bars = ax1.bar(x - width/2, pacotes, width, color=color, label='Pacotes')
ax1.tick_params(axis='y', labelcolor=color)

ax2 = ax1.twinx()
color = '#7570b3'
ax2.set_ylabel('Volume de Dados (Bytes)', color=color)
lines = ax2.bar(x + width/2, bytes_totais, width, color=color, label='Bytes')
ax2.tick_params(axis='y', labelcolor=color)

plt.title('Overhead de Controlo em Repouso no Nó R3 (~30 segundos)')
ax1.set_xticks(x)
ax1.set_xticklabels(protocolos)
ax1.grid(axis='y', linestyle='--', alpha=0.5)

plt.tight_layout()
plt.savefig('/home/laura/trabalho_redes/capturas/overhead_controle.png', dpi=300)
plt.close()

print("Gráficos gerados com sucesso na pasta capturas!")
