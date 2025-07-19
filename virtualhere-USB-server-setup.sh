#!/bin/bash

echo "🚀 Installiere VirtualHere USB Server für x86_64..."

# System updaten
sudo apt update && sudo apt upgrade -y

# VirtualHere USB Server (x86_64) herunterladen
wget https://www.virtualhere.com/sites/default/files/usbserver/vhusbdx86_64 -O vhusbd
chmod +x vhusbd
sudo mv vhusbd /usr/sbin/vhusbd

# systemd-Dienst erstellen
echo "🛠️ Erstelle systemd-Dienst..."
sudo bash -c 'cat > /etc/systemd/system/vhusbd.service <<EOF
[Unit]
Description=VirtualHere USB Server (x86_64)
After=network.target

[Service]
ExecStart=/usr/sbin/vhusbd
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

# Dienst aktivieren und starten
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable vhusbd
sudo systemctl start vhusbd

echo "✅ VirtualHere USB Server läuft jetzt auf deinem Linux-System (x86_64)!"
