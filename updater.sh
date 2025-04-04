#!/bin/bash

echo '           ___
          |_|_|
          |_|_|              _____
          |_|_|     ____    |*_*_*|
 _______   _\__\___/ __ \____|_|_   _______
/ ____  |=|      \  <_+>  /      |=|  ____ \
~|    |\|=|======\\______//======|=|/|    |~
 |_   |    \      |      |      /    |    |
  \==-|     \     |update|     /     |----|~~/
  |   |      |    |      |    |      |____/~/
  |   |       \____\____/____/      /    / /
  |   |         {----------}       /____/ /
  |___|        /~~~~~~~~~~~~\     |_/~|_|/
   \_/        |/~~~~~||~~~~~\|     /__|\
   | |         |    ||||    |     (/|| \)
   | |        /     |  |     \       \\
   |_|        |     |  |     |
              |_____|  |_____|
              (_____)  (_____)
              |     |  |     |
              |     |  |     |
              |/~~~\|  |/~~~\|
              /|___|\  /|___|\
             <_______><_______> '


# Ścieżka do pliku logów
LOG_FILE="/var/log/system_update_$(date '+%Y-%m-%d_%H-%M-%S').log"

# Funkcja logowania
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Funkcja obsługi błędów
handle_error() {
    log "BŁĄD: $1"
    exit 1
}

# Sprawdzenie uprawnień
if [ "$EUID" -ne 0 ]; then
    handle_error "Uruchom skrypt jako root lub przez sudo."
fi

# Aktualizacja listy pakietów apt
log "Aktualizacja listy pakietów apt."
apt update || handle_error "Nie udało się wykonać apt update."

# Sprawdzenie dostępnych aktualizacji apt
log "Sprawdzanie dostępnych aktualizacji apt."
apt list --upgradable | grep -v '^[[:blank:]]' | column -t
UPGRADE_COUNT=$(apt list --upgradable 2>/dev/null | grep -c "upgradable from")

# Aktualizacja flatpak
log "Aktualizacja pakietów flatpak."
flatpak update -y || handle_error "Nie udało się zaktualizować pakietów flatpak."

# Aktualizacja snap
log "Aktualizacja pakietów snap."
snap refresh || handle_error "Nie udało się zaktualizować pakietów snap."

# Wyświetlanie dostępnych aktualizacji apt
if [ "$UPGRADE_COUNT" -gt 0 ]; then
    log "Dostępnych aktualizacji apt: $UPGRADE_COUNT"

    read -p "Czy chcesz zobaczyć szczegółową listę aktualizacji? (Y/N): " details
    if [[ "${details^^}" == "Y" ]]; then
        apt list --upgradable | grep -v '^[[:blank:]]' | column -t
    fi

    read -p "Czy chcesz zaktualizować wszystkie pakiety apt? (Y/N): " update_all

    if [[ "${update_all^^}" == "Y" ]]; then
        log "Rozpoczynanie aktualizacji pakietów apt."
        apt upgrade -y || handle_error "Wystąpił problem podczas aktualizacji apt."
    else
        log "Aktualizacja anulowana przez użytkownika."
        exit 0
    fi
else
    log "Brak dostępnych aktualizacji apt."
fi

# Sprawdzenie konfliktów i zależności
log "Sprawdzanie konfliktów i zależności."
apt -f install -y || handle_error "Znaleziono nierozwiązane konflikty lub problemy z zależnościami."

# Pytanie o restart systemu
read -p "Czy zrestartować system, aby zastosować zmiany? (Y/N/P): " reboot_choice

case "${reboot_choice^^}" in
    Y)
        log "Restartowanie systemu."
        reboot
        ;;
    P)
        log "Wyłączanie systemu."
        poweroff
        ;;
    *)
        log "Restart anulowany przez użytkownika."
        ;;
esac
