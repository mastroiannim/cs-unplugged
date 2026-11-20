#!/bin/bash
set -e

echo "1. Avvio del server di esecuzione JOBE..."
docker run -d -p 4000:80 --name jobe --restart unless-stopped trampgeek/jobeinabox:latest

echo "2. Configurazione dell'indirizzo JOBE in CS Unplugged..."
# Punta la chiamata interna di jobe_proxy al container JOBE locale
find csunplugged -type f -name "*.py" -exec sed -i 's|https://canterbury.ac.nz|http://docker.internal|g' {} +

echo "3. Avvio e inizializzazione di CS Unplugged..."
chmod +x ./dev
./dev start
./dev update

echo "Ambiente pronto!"
