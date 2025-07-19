#!/bin/bash

echo "🚀 Installiere VirtualHere USB Server für x86_64..."

# Prüfen ob VirtualHere bereits läuft
if systemctl list-units --type=service --all | grep -q vhusbd.service; then
    echo "⚠️ VirtualHere scheint bereits installiert zu sein."

    read -p "🧼 Möchtest du eine saubere Neuinstallation durchführen? (j/N): " CONFIRM
    if [[ "$CONFIRM" =~ ^[Jj]$ ]]; then
        echo "🧹 Entferne bestehenden VirtualHere-Dienst und Dateien..."

        sudo systemctl stop vhusbd
        sudo systemctl disable vhusbd
        sudo rm -f /etc/systemd/system/vhusbd.service
        sudo rm -f /usr/sbin/vhusbd
        sudo rm -f /usr/sbin/config.ini

        sudo systemctl daemon-reload
        echo "✅ Alte Installation entfernt."
    else
        echo "❌ Abgebrochen – bestehende Installation bleibt erhalten."
        exit 0
    fi
fi

# System aktualisieren
sudo apt update && sudo apt upgrade -y

# Servernamen abfragen
read -p "🧩 Bitte gib den Namen deines USB-Servers ein (z. B. G27-Host): " SERVERNAME

# VirtualHere Server herunterladen
wget https://www.virtualhere.com/sites/default/files/usbserver/vhusbdx86_64 -O vhusbd
chmod +x vhusbd
sudo mv vhusbd /usr/sbin/vhusbd

# Konfigurationsdatei mit ServerName erstellen
echo "🔧 Erstelle /usr/sbin/config.ini mit deinem Namen \"$SERVERNAME\"..."
echo "ServerName=$SERVERNAME" | sudo tee /usr/sbin/config.ini > /dev/null

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

# Status anzeigen
echo ""
echo "✅ VirtualHere USB Server läuft jetzt auf deinem Linux-System (x86_64)!"
echo "📡 Servername: $SERVERNAME"
echo ""
echo "🔍 Status prüfen mit:"
echo "   sudo systemctl status vhusbd"
