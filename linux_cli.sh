#!/bin/bash

#task5
create_directory() {
    if mkdir -p "$1"; then
        echo "Vytvoren adresar $1"
    else
        echo "Doslo k chybe"
    fi
}

create_link_v2() {
    local TYPE="$1"
    local SOURCE="$2"
    local TARGET="$3"

    
    if [ ! -e "$SOURCE" ]; then
        echo "Chyba: Zdroj linku '$SOURCE' neexistuje."
        return 1 
    fi

    
    if [ -e "$TARGET" ]; then
        echo "Chyba: Cílová cesta pro link '$TARGET' již existuje."
        return 1 
    fi

    
    if [ "$TYPE" = "soft" ]; then
        if ln -s "$SOURCE" "$TARGET"; then
            echo "Soft link z '$SOURCE' do '$TARGET' byl úspěšně vytvořen."
        else
            echo "Chyba při vytváření soft linku z '$SOURCE' do '$TARGET'."
            return 1
        fi
    elif [ "$TYPE" = "hard" ]; then
        if ln "$SOURCE" "$TARGET"; then
            echo "Hard link z '$SOURCE' do '$TARGET' byl úspěšně vytvořen."
        else
            echo "Chyba při vytváření hard linku z '$SOURCE' do '$TARGET'."
            return 1
        fi
    else
        echo "Chyba: Neznámý typ linku '$TYPE'. Použijte 'soft' nebo 'hard'."
        return 1
    fi

    return 0 
}

info_user_system() {
    echo "Informace o uživateli"
    id -u
    id -un
    hostname
    date
}

list_upgrade() {
    echo "List balíčků, které mají update: "
    apt list --upgradable
}

update_upgrade() {
   echo "Update/Upgrade balíčků"
   sudo apt update && sudo apt upgrade 
}

LOG_TO_FILE=false
LOG_FILE="./log_file.txt"

log() {
    if $LOG_TO_FILE; then
        echo "$1" >> "$LOG_FILE"
    else
        echo "$1"
    fi
}

print_help() {
    cat << EOF

Zkratky:
    -h                      Zobrazí tuto nápovědu a ukončí skript.
    -m PATH                 Vytvoří zadaný adresář a jeho rodičovskou strukturu.                  
    -l TYPE SOURCE TARGET   Vytvoří soft nebo hard link.
    -i                      Zobrazí základní informace o uživateli a systému.
    -u                      Vylistuje balíčky, které mají dostupnou aktualizaci.
    -g                      Provede update a upgrade systémových balíčků.
    -o                      Přesměruje veškerý výstup skriptu (log) do zadaného souboru.
    -a                      Vypíše pouze IP adresy v systému.
EOF
}

while getopts "am:l:iugo:h" opt; do
    case $opt in
        a)
            echo "IPv4 adresy:"
            ip -4 addr show | awk '/inet / {print $2 " (" $NF ")"}'
            echo "IPv6 adresy:"
            ip -6 addr show | awk '/inet6 / {print $2 " (" $NF ")"}'
            exit 0
            ;;
        m)
            create_directory "$OPTARG"
            exit 0 
            ;; 
        l)
            
            create_link "$OPTARG" "$2" "$3"
            exit 0
            ;;
        i)
            info_user_system 
            exit 0
            ;;
        u)
            list_upgrade 
            exit 0
            ;;
        g) 
            update_upgrade
            exit 0
            ;;
        o)
            LOG_TO_FILE=true
            LOG_FILE="$OPTARG"
        
            touch "$LOG_FILE" || { echo "Chyba: Nelze vytvořit log soubor: $LOG_FILE. Zkontrolujte oprávnění." >&2; exit 1; }
            log "Logování přesměrováno do souboru: $LOG_FILE"
        
            exit 0
            ;;
        h)
            print_help
            exit 0
            ;;
        *) 
            echo "Neco se pokazilo. Použijte -h pro napovedu."
            exit 1
            ;;
    esac
done
if [ "$1" = "processinfo" ]; then
    echo "PID aktuálního procesu: $$"
    echo "PID jeho rodiče: $PPID"
    echo "Priorita procesu: $(ps -o pri= -p $$)"
    echo "Celkový počet procesů v aktuálním systému: $(ps -e | wc -l)"
    exit 0
fi
if [ $OPTIND -eq 1 ]; then
    # Všechny výpisy pouze pokud nebyl zadán žádný parametr
    echo "Používaný shell: $SHELL"
    echo "Aktuální uživatel: $USER"
    echo "OS:"
    cat /etc/os-release
    sudo mkdir -p /usr/adresar/podadresar/posledniadresar/
    sudo touch /usr/adresar/podadresar/posledniadresar/soubor.txt
    echo "Ahoj ze sveta Linux" > soubor.txt
    sudo sh -c 'echo "Ahoj ze sveta Linux" > /usr/adresar/podadresar/posledniadresar/soubor.txt'
    ln -s /usr/adresar/podadresar/posledniadresar/soubor.txt /tmp/softLink
    echo "Soft link byl vytvořen v /tmp/softLink."
    cp /usr/adresar/podadresar/posledniadresar/soubor.txt /tmp/
    echo "Soubor soubor.txt byl nakopírován do /tmp/."
    echo "UID a GID aktuálního uživatele:"
    id
    sudo chmod o=r /usr/adresar/podadresar/posledniadresar/soubor.txt
    echo "Práva souboru soubor.txt byla změněna na read only pro ostatní uživatele."
    chmod u+x,go-rwx /tmp/softLink
    echo "Práva soft linku /tmp/softLink byla změněna (execute pro vlastníka, žádná pro ostatní a skupinu)."

    # task6
    echo "Informace o síťových rozhraních:"
    echo "IPv4 adresy:"
    ip -4 addr show | awk '/inet / {print $2 " (" $NF ")"}'
    echo "IPv6 adresy:"
    ip -6 addr show | awk '/inet6 / {print $2 " (" $NF ")"}'
    echo "MAC adresy:"
    ip link show | awk '/link\/ether/ {print $2 " (" $NF ")"}'

    # task7
    echo "PID aktuálního procesu: $$"
    echo "PID jeho rodiče: $PPID"
    echo "Priorita procesu: $(ps -o pri= -p $$)"
    echo "Celkový počet procesů v aktuálním systému: $(ps -e | wc -l)"

    # task8
    echo "docker ps"
    echo "docker stop <docker_name> && docker rm <docker_name>"
    echo "docker images"
    echo "docker rmi <docker_image>"
fi