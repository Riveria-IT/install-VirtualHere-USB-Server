#!/bin/bash

echo "🚀 Installiere VirtualHere USB Server..."

# System updaten
sudo apt update && sudo apt upgrade -y

# VirtualHere USB Server herunterladen und ausführbar machen
wget https://www.virtualhere.com/sites/default/files/usbserver/vhusbdarm -O vhusbdarm
chmod +x vhusbdarm
sudo mv vhusbdarm /usr/sbin/vhusbdarm

# systemd Dienst einrichten
echo "🛠️ Erstelle systemd-Dienst..."
sudo bash -c 'cat > /etc/systemd/system/vhusbd.service <<EOF
[Unit]
Description=VirtualHere USB Server
After=network.target

[Service]
ExecStart=/usr/sbin/vhusbdarm
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'

# Dienst aktivieren und starten
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable vhusbd
sudo systemctl start vhusbd

echo "✅ VirtualHere USB Server läuft jetzt auf dem Raspberry Pi!"
