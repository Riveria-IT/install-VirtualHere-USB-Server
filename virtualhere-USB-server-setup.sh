#!/bin/bash

echo "🚀 Starte Installation des VirtualHere USB Servers für x86_64..."

# System updaten
sudo apt update && sudo apt upgrade -y

# 🔍 Prüfen, ob VirtualHere bereits installiert ist
if systemctl list-units --all | grep -q vhusbd || \
   [[ -f "/usr/sbin/vhusbd" ]] || \
   [[ -f "/usr/sbin/vhusbdx86_64" ]] || \
   [[ -f "/etc/systemd/system/vhusbd.service" ]] || \
   [[ -f "/usr/sbin/config.ini" ]]; then

  echo "⚠️ Es wurde eine bestehende Installation erkannt."

  read -p "🧼 Möchtest du eine saubere Neuinstallation durchführen? (j/N): " CONFIRM
  if [[ "$CONFIRM" == [jJ] ]]; then
    echo "🧽 Entferne alte Installation..."

    sudo systemctl stop vhusbd 2>/dev/null
    sudo systemctl disable vhusbd 2>/dev/null
    sudo rm -f /etc/systemd/system/vhusbd.service
    sudo rm -f /usr/sbin/vhusbd
    sudo rm -f /usr/sbin/vhusbdx86_64
    sudo rm -f /usr/sbin/config.ini
    sudo systemctl daemon-reload

    echo "✅ Alte Installation erfolgreich entfernt."
  else
    echo "❌ Abgebrochen. Bitte entferne alte Installation manuell."
    exit 1
  fi
fi

# 🔤 Nach dem Servernamen fragen
read -p "🧩 Bitte gib den Namen deines USB-Servers ein (z. B. G27-Host): " SERVERNAME

# 📥 VirtualHere USB Server herunterladen und einrichten
wget https://www.virtualhere.com/sites/default/files/usbserver/vhusbdx86_64 -O vhusbd
chmod +x vhusbd
sudo mv vhusbd /usr/sbin/vhusbd

# 📝 Konfigurationsdatei anlegen
echo "🔧 Erstelle Konfigurationsdatei mit Namen \"$SERVERNAME\"..."
echo "ServerName=$SERVERNAME" | sudo tee /usr/sbin/config.ini > /dev/null

# ⚙️ systemd-Dienst erstellen
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

# 🔄 Dienst aktivieren und starten
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable vhusbd
sudo systemctl start vhusbd

# ✅ Fertigmeldung
echo ""
echo "✅ VirtualHere USB Server wurde erfolgreich installiert und gestartet!"
echo "📡 Servername: $SERVERNAME"
echo ""
echo "🔍 Status prüfen mit:"
echo "   sudo systemctl status vhusbd"
