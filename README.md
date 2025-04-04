🛠️ Ultimate Linux Updater – APT, Flatpak, Snap + Logging & Auto-Reboot
Author: Lukasz Szymulanski
Version: 2.0
License: MIT

🧠 What is this?
This is a complete update automation tool for Ubuntu/Linux systems. It performs:

✅ APT package list refresh and upgrade

✅ Flatpak updates

✅ Snap refresh

✅ Logging to /var/log/system_update_YYYY-MM-DD_HH-MM-SS.log

✅ Optional system reboot or shutdown

✅ Error handling, logging, and interactive confirmation prompts

All updates in one go – clean, logged, and under your control.

📦 Features
📦 Handles APT, Flatpak, and Snap packages

📜 Logs every step to a timestamped log file in /var/log/

🔐 Root check for secure execution

🧠 Intelligent error handler

🔄 Reboot or shutdown prompt after updates

👀 Optional review of upgradable packages before applying

🚀 Usage

```chmod +x system-updater.sh```

```sudo ./system-updater.sh```

🔐 Requirements
Ubuntu/Debian-based system

flatpak and snap installed

Run as sudo or root

💡 Pro Tips
Add to /usr/local/bin for system-wide use:

```sudo cp system-updater.sh /usr/local/bin/update-all```

```sudo chmod +x /usr/local/bin/update-all```

```sudo update-all```
