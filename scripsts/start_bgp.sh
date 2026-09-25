#!/bin/bash
echo "Iniciando daemons BIRD (BGP)..."
for r in r1 r2 r3 r4 r5; do
    sudo ip netns exec $r bird -c /home/laura/trabalho_redes/bgp/$r.conf -s /tmp/bird-$r.ctl -P /tmp/bird-$r.pid
done
echo "BGP iniciado em todos os roteadores!"
