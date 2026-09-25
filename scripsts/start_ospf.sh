#!/bin/bash
echo "Iniciando daemons BIRD (OSPF)..."
for r in r1 r2 r3 r4 r5; do
    sudo ip netns exec $r bird -c /home/laura/trabalho_redes/ospf/$r.conf -s /tmp/bird-$r.ctl -P /tmp/bird-$r.pid
done
echo "OSPF ativo em todos os roteadores!"
