#!/bin/bash
echo "Parando instâncias do BIRD..."
sudo killall bird 2>/dev/null
sudo rm -f /tmp/bird-*.ctl /tmp/bird-*.pid
echo "Instâncias paradas."
