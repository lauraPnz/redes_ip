#!/usr/bin/env bash
echo "Parando instâncias do BIRD..."
sudo killall bird 2>/dev/null || true
sudo rm -f /tmp/bird-*.ctl /tmp/bird-*.pid
echo "Instâncias paradas e sockets limpos."
