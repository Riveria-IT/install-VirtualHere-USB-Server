# 💻 Install VirtualHere USB Server (Ubuntu/Debian x86_64)

Dieses Script installiert den **VirtualHere USB Server** auf einem normalen Ubuntu- oder Debian-System mit **Intel/AMD CPU** (x86_64).  
Ideal für dedizierte USB-Weiterleitungsgeräte – zum Beispiel für Moonlight, Remote-Gaming oder Headless-Server.

---

## ✅ Features

- Automatische Installation des VirtualHere USB Servers (`vhusbdx86_64`)
- Einrichtung als systemd-Dienst (läuft beim Booten automatisch)
- Für alle gängigen Ubuntu/Debian-Versionen auf x86_64
- Unterstützt USB-Geräte wie Lenkräder, Mikrofone, Drucker usw.

---

## 🖥️ Voraussetzungen

- Ubuntu / Debian mit x86_64 Architektur (Intel oder AMD CPU)
- Netzwerkverbindung
- Angeschlossene USB-Geräte (z. B. Logitech G27)
- Zielgerät mit installiertem [VirtualHere USB Client](https://www.virtualhere.com/usb_client_software)

---

## 🚀 Installation

Führe folgenden Befehl im Terminal aus:

```bash
wget -O virtualhere-setup.sh https://raw.githubusercontent.com/Riveria-IT/install-VirtualHere-USB-Server/main/virtualhere-USB-server-setup-x86_64.sh && chmod +x virtualhere-setup.sh && ./virtualhere-setup.sh
