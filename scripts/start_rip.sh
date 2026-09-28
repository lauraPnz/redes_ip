#!/usr/bin/env bash
DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "Iniciando daemons BIRD (RIPv2)..."
for r in r1 r2 r3 r4 r5; do
    sudo ip netns exec $r bird -c "$DIR/rip/$r.conf" -s /tmp/bird-$r.ctl -P /tmp/bird-$r.pid
done
echo "RIPv2 ativo em todos os roteadores!"
