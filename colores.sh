#"/bin/bash

#COLORES
BLANCO="\e[38m"
AZUL="\e[34m"
VERDE="\e[32m"
ROJO="\e[31m"
AMARILLO="\e[33m"
RESET="\e[0m"
verde='\033[38;5;148m'
bar="----------------------------------------"

#ESTILOS DE TEXTO


#FUENTES

#VARIABLES
numero="0"
opcion="ACTIVAR WS-EPR"

display_header() {
echo -e $bar
echo -e  "${VERDE}       MENU ADM WS-EPRO By @HellBoyVps         ${RESET}"
echo -e $bar
}

#MENU PRINCIPAL
menu_principal() {
	echo -e "${BLANCO}[1] ${VERDE} ACTIVAR WS-EPRO ${RESET}"
	echo -e "${BLANCO}[2] ${VERDE} MODIFICAR PUERTO ${RESET}"
	echo -e "${ROJO}[3] ${AZUL} DESACTIVAR WS-EPRO ${RESET}"
    echo -e "${AMARILLO}[4] ${AZUL} SALIR DEL PANEL ${RESET}"
	echo -e  $bar
	read -p "Ingre una opcion: " option

	case $option in 
		1) activar_ws-epro ;;
		2) mod_port ;;
		3) desactivate ;;
		4) exit ;;
		*)echo -e "${ROJO} Ingrese una opcion valida..." ;;
	esac
    echo -e $bar
	echo -e "${ROJO} Enter para continuar "
	read -r Enter
	menu_principal
}

#ACTIVADOR WS-EPRO
activar_ws-epro() {
	echo -e "${AMARILLO}>>>>INSTALANDO WS-EPRO<<<<<${RESET}"
	sleep 0.5

	 # Download and install ws-epro
download_and_install "https://docs.google.com/uc?export=download&id=1IbwfNpKpa1JzvXsDT-WgNpp5nWrklisG" "/usr/local/bin/ws-epro"

    # Download and install ws-epro service
download_and_install "https://docs.google.com/uc?export=download&id=10hGKYNZUMHdr4y-ZxMr0wKQpj9zSQRkZ" "/etc/systemd/system/ws-epro.service"

    # Download and install ws-epro port script
download_and_install "https://docs.google.com/uc?export=download&id=1h9QvOnXScplGTnfpbJ7KJDn4CDkwUKWa" "/usr/bin/ws-port"

    # Set port configurations
    read -p " ✓ PUERTO PARA PHYTON : " wsopenssh
    read -p " ✓ PUERTO LOCAL (ssh|ssl|openvpn): " openssh

    WS_DIR="/usr/local/etc/ws-epro"
    [ -d "$WS_DIR" ] && rm -rf "$WS_DIR"
    sleep 0.3
    mkdir -p "$WS_DIR"

    # Create configuration file
    cat <<EOF > "$WS_DIR/config.yml"
# verbose level 0=info, 1=verbose, 2=very verbose
verbose: 0
listen:
##openssh
- target_host: 127.0.0.1
##portopenssh
  target_port: $openssh
##wsopenssh
  listen_port: $wsopenssh
EOF

    chmod +x "$WS_DIR/config.yml"

    # Enable and start ws-epro service
    systemctl enable ws-epro
    systemctl start ws-epro

    sleep 0.3
    display_header
    echo
    echo -e "${YELLOW}          INSTALACION COMPLETADA (By JORGE ACEVEDO) ${RESET}"
    echo -e "${YELLOW}          PUERTOS ACTIVADOS: ${RESET}"
    echo -e "${YELLOW}          ╔═══════════════════════╗${RESET}"
    echo -e "${YELLOW}             Puerto Local SSH: ${GREEN}$openssh${RESET}"
    echo -e "${YELLOW}             Puerto Phyton: ${GREEN}$wsopenssh${RESET}"
    echo -e "${YELLOW}          ╚═══════════════════════╝${RESET}"
}

# Function to download and install a file
download_and_install() {
    local download_url=$1
    local install_path=$2

    wget -q --show-progress --load-cookies /tmp/cookies.txt "$download_url" -O "$install_path" && rm -rf /tmp/cookies.txt
    chmod +x "$install_path"
}
# Function to modify WS-EPRO port
mod_port() {
    ws-port
    echo -ne "\nPresione Enter para continuar"
    read -r enter
}

# Function to deactivate WS-EPRO
desactivate() {
    pkill -f ws-epro
    WS_DIR="/usr/local/etc/ws-epro"
    [ -d "$WS_DIR" ] && rm -rf "$WS_DIR"
    msg -bar
    echo -e "${AMARILLO}.  >>> CONFIGURACION WS-EPRO DESACTIVADA <<< ${RESET}"
    echo -e $bar
    read -r enter
}

#LA EJECUCION PRINCIPAL DEL MENU Y EL SCRIPT COMIENZAN ACTIVAR
menu_principal