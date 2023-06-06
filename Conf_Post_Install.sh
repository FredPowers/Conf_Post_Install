#!/bin/bash


#.NOTES
#	NAME:	Conf_Post_Install.sh
#   VERSION : 1.0  15/01/2023
#	AUTHOR:	Frédéric Puren

# Script testé sur Debian 11.6

# Script pour configurer Debian 11 après l'installation,
	# changer le nom
	# Configurer l'IP
	# Déclarer les bons dépots
	# En faire un serveur DHCP, un serveur DNS, un serveur Web ou un routeur.
	# Installer et configurer Ansible
	# Installer GLPI
	# 



## pour le partage de dossier dans VmWare
## si le partage de dossier n'apparait pas dans /mnt/hgfs
## lancer la commande suivante : vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000
# Si vous etes dans le dossier hgfs, le quitter puis y revenir, le dossier partagé devrait maintenant y apparaitre
# Si la commande vmhgfs-fuse remonte une erreur il faut installer open-vm-tools ( apt install open-vm-tools )

######################## choix repertoire ###########################
#read -p "entrer le nom du dossier recherché :"
#read -p nom_fic
#echo
#echo -e "$vert liste des repertoires disponibles avec le nom$noir $orange $nom_fic $noir :"
#echo
#find / -type d -name "$nom_fic" 2>/dev/null | tee tempo
#echo
#read -p "Merci de choisir parmis l'un des chemins ci-dessus, ex : tapez \"1\" pour choisir la premiere ligne : " rep
#chemin=$(cat tempo|head -"$rep"|tail -1)
#####################################################################

############## Début Script #####################


# [CODE ERREUR]
# exit 0 --> erreur d'installation
# exit 1 --> utilisateur non root
# exit 4 --> Source de dépot injoignable, la configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné


if_erreur() {

	if [ $? -eq 0 ]
	then
		echo "L'installation s'est déroulée avec succès"
	else
		echo "Une erreur s'est produite lors de l'installation, le script va s'arreter"
		echo
		echo "Veuillez consulter le fichier de log dans /var/log/Conf_Post_Install.log"
		echo
		read -n1 -r -p "Appuyer sur entrée..."
		exit 0
	fi
}





script() {

########### variables des couleurs

orange='\033[33m'
magenta='\033[35m'
vert='\033[32m'
bleu='\033[36m'
bleu_fonce='\033[34m'
rouge='\033[31m'
normal='\033[0m'
#########################################


################# Debut du script ###################

# Vérifier si l'utilisateur est root ou non
if [[ $EUID -ne 0 ]]
then
	echo
	echo -e ""$rouge"Ce script doit être exécuté en tant que root$normal"
	echo
	exit 1
fi


while :
do
	echo
	echo
	date=$(date)
	echo "###############################################################################"
	echo "#                            $date                                            #"
	echo "###############################################################################"
	echo
	echo
	
	# Vérification du réseau
	# Voir pour vérifier la connectivité internet

	if apt list --installed | grep ^bc/stable
	then
		1>/dev/null
	else
		apt install bc -y
	fi
	echo

	version=$(cat /etc/debian_version)

	echo -e "verion de debian installée : $vert$version$normal"
	echo
	if (( $(echo "$version < 11" | bc -l) ))
	then
		echo -e ""$orange"la version de debian qui exécute ce script est antérieur à celle où celui-ci a été testé$normal"
		echo "Voulez-vous continuer ? [O/N]"
		read -p "" -r reponse

		while [[ $reponse != "O" && $reponse != "o" && $reponse != "N" && $reponse != "n" ]]
		do
			echo
			echo "erreur de frappe, veuillez recommencer"
			echo
			echo -e ""$orange"la version de debian qui exécute ce script est antérieur à celle où celui-ci a été testé$normal"
			echo "Voulez-vous continuer ? [O/N]"
			read -p "" -r reponse
		done
		if [[ $reponse == "N" || "$reponse" = "n" ]]
		then
			exit 0
		fi
	fi
	echo
	echo "Configuration Post installation Debian 11"
	echo "_________________________________________"
	echo
	echo
	echo -e ""$bleu"1  : Nom d'hôte"
	echo -e 	   "2  : Configuration IP de l'hôte"
	echo -e 	   "3  : Ajouter les dépots bullseye main contrib"
	echo -e 	   "4  : Verifier si un proxy est configuré"
	echo -e 	   "5  : Activer le routage"
	echo -e 	   "6  : Configurer un serveur DHCP"
	echo -e 	   "7  : Configurer un serveur DNS"
	echo -e 	   "8  : Configurer un serveur LAMP"
	echo -e 	   "9  : Installation Centreon"
	echo -e 	   "10 : Installation Docker"
	echo -e 	   "11 : Ajouter un repertoire à la variable d'environnement \$PATH"
	echo -e 	   "12 : Intégrer un hôte au domaine"
	echo -e 	   "13 : Installation GLPI"
	echo -e 	   "14 : Intérroger une base de donnée mariadb"
	echo -e 	   "15 : Configuration Rsyslog (serveur & client)$normal"
	#echo -e "10 : Installation de logiciels$normal"
	echo -e ""$rouge"q : quitter$normal"
	echo
	echo "veuillez choisir :"

	read optionmenu
			case $optionmenu in

########1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-1-
		1)
			while :
			do
				echo -e ""$bleu"1 : Affichage nom d'hôte"
				echo -e "2 : Modifier le nom d'hôte$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in

				1)	
					echo -e "$bleu-------------------------------$normal"
					echo -e "$bleu     Nom de la machine         $normal"
					echo -e "$bleu-------------------------------$normal"
					nom=$(hostname --fqdn)
					echo "Nom : $nom"

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;

				2)
					echo -e "$bleu-----------------------------------------$normal"
					echo -e "$bleu      Modifier le nom de la machine      $normal"
					echo -e "$bleu-----------------------------------------$normal"	

					echo
					Nom_Hosts=$(grep "127.0.1.1" /etc/hosts | awk '{print $2}')

					echo -n "Entrer le Nouveau nom de la machine:"
					read Nom

					sed -i 's/'$Nom_Hosts'/'$Nom'/' /etc/hosts

					echo "$Nom" > /etc/hostname

					read -n1 -r -p "Appuyer sur entrée pour redémarrer la machine..."

					shutdown -r now
					;;

				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;

########2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-2-
		2)
			while :
			do
				echo -e ""$bleu"1 : Affichage configuration IP de la machine"
				echo -e "2 : Configuration Ethernet en Statique (serveur)"
				echo -e "3 : Configuration Ethernet en DHCP (serveur)"
				echo -e "4 : Configuration Ethernet en Statique (Client)"
				echo -e "5 : Configuration Ethernet en DHCP (Client)"
				echo -e "6 : Renouveler l'IP auprès du serveur DHCP (Client)$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in


				1)
					echo -e "$bleu--------------------------------------------------$normal"
					echo -e "$bleu     Affichage configuration IP de la machine        $normal"
					echo -e "$bleu--------------------------------------------------$normal"
					echo
					echo -e ""$vert"adresse IP & Masque$normal"
					ip a | grep "inet" | grep "brd" | awk -F"inet" 'NR==1{split($2,a," ");print a[1]}'
					echo ""  
					echo -e ""$vert"Passerelle$normal"
					ip route | grep "default" | awk -F"via" 'NR==1{split($2,a," ");print a[1]}'
					echo
					echo -e ""$vert"adresse DNS$normal"
					cat /etc/resolv.conf | awk '{print $2,$4,$6,$8,$10,$12}'
					echo

					sleep 3

					Passerelle=$(ip route | grep "default" | awk -F"via" 'NR==1{split($2,a," ");print a[1]}')

					echo -e ""$orange"Ping vers la passerelle$normal"

					echo begin ping
					if ping -c 1 $Passerelle | grep Unreachable;
					then echo -e ""$rouge"La passerelle $Passerelle n'est pas joignable$normal";
					else echo -e ""$vert"La passerelle $Passerelle est joignable$normal";
					fi
					#echo "confirmation"
					#ping -c4 $Passerelle

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				2)

					echo -e "$bleu-----------------------------------------------------$normal"
					echo -e "$bleu     Configuration Ethernet en Statique (serveur)     $normal"
					echo -e "$bleu-----------------------------------------------------$normal"

					echo
					echo -e "Interfaces présentes :"
					echo ""
					ip a | grep -E 'UP|DOWN' | grep -v LOOPBACK | awk '{print $2}'

					echo

					echo -n "Nom de l'interface Ethernet: "
					read interface
					echo -n "Adresse IP: "
					read ip
					echo -n "Masque: "
					read masque
					echo -n "Passerelle: "
					read passerelle
					echo -n "Serveur DNS: "
					read dns

					chemin_interfaces=/etc/network/interfaces


					if [ -a $chemin_interfaces ]
					then

						# on part du principe où la configuration de l'interface réseau est en dhcp à la premire installtaion de Debian
						# et que le fichier contiendra ensuite '## Configuration de 'interface' en mode statique' au lieu de '# The primary network interface'
						if grep "# The primary network interface" $chemin_interfaces
						then
							chaine=$(grep "# The primary network interface" $chemin_interfaces)
							numero_ligne=$(grep -n "$chaine" $chemin_interfaces | cut -d: -f1)
							num2=2
							numero_ligne2=$(($numero_ligne + $num2))

							## Suppression des lignes de conf interface dans /etc/network/interfaces
							sed -i "$numero_ligne,$numero_ligne2 d" $chemin_interfaces
							sleep 2

							## écriture des paramètres dans le fichier de configuration
							echo "
## Configuration de $interface en mode Statique
auto $interface
iface $interface inet static
	address $ip
	netmask $masque
	gateway $passerelle" >> $chemin_interfaces

								## On envoie également le DNS dans le resolv.conf

								echo "nameserver $dns" > /etc/resolv.conf

								read -n1 -r -p "Appuyer sur entrée pour continuer..."

						else
							chaine=$(grep "## Configuration de $interface" $chemin_interfaces)

							numero_ligne=$(grep -n "$chaine" $chemin_interfaces | cut -d: -f1)
							num5=5
							numero_ligne5=$(($numero_ligne + $num5))

							## Suppression des lignes de conf interface dans /etc/network/interfaces

							sed -i "$numero_ligne,$numero_ligne5 d" $chemin_interfaces

							sleep 2

							## écriture des paramètres dans le fichier de configuration

							echo "
## Configuration de $interface en mode Statique
auto $interface
iface $interface inet static
	address $ip
	netmask $masque
	gateway $passerelle" >> $chemin_interfaces

							## On envoie également le DNS dans le resolv.conf

							echo "nameserver $dns" > /etc/resolv.conf

							read -n1 -r -p "Appuyer sur entrée pour continuer..."
						fi
						
					else
						echo " 
## Configuration de "$interface" en mode Statique
auto $interface
iface $interface inet static
	address $ip
	netmask $masque
	gateway $passerelle" > $chemin_interfaces

							## On envoie également le DNS dans le resolv.conf
							echo "nameserver $dns" > /etc/resolv.conf

					fi


					sleep 2
					## On affiche le fichier créé (ou modifié)
					echo -e "$orange----------------------------------------$normal"
					echo -e "$orange Vérification du fichier $chemin_interfaces$normal"
					echo
					cat $chemin_interfaces
					echo -e "$orange----------------------------------------$normal"
					echo
					echo -e "$orange Verification du fichier /etc/resolv.conf :$normal"
					echo
					cat /etc/resolv.conf
					echo -e "$orange-----------------------------------------$normal"
					echo
					sleep 2
					ip link set dev $interface down
					sleep 1
					ip link set dev $interface up
					sleep 2
					systemctl restart networking.service

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				3)

					echo -e "$bleu--------------------------------------------------$normal"
					echo -e "$bleu     Configuration Ethernet en DHCP (serveur)     $normal"
					echo -e "$bleu--------------------------------------------------$normal"

					echo
					echo -e "Interfaces présentes : "
					echo
					ip a | grep -E 'UP|DOWN' | grep -v LOOPBACK | awk '{print $2}'

					echo

					echo -n "Nom de l'interface Ethernet: "
					read interface

					chemin_interfaces=/etc/network/interfaces


					if grep $interface $chemin_interfaces

					then

						chaine=$(grep "## Configuration de $interface" $chemin_interfaces)

						numero_ligne=$(grep -n "$chaine" $chemin_interfaces | cut -d: -f1)
						num5=5
						numero_ligne5=$(($numero_ligne + $num5))

						## Suppression des lignes de conf interface dans /etc/network/interfaces

						sed -i "$numero_ligne,$numero_ligne5 d" $chemin_interfaces

						sleep 2

						## écriture des paramètres dans le fichier de configuration

						echo "

## Configuration de $interface en mode DHCP
auto $interface
iface $interface inet dhcp" >> $chemin_interfaces

						read -n1 -r -p "Appuyer sur entrée pour continuer..."

						
					else
						
						echo " 

## Configuration de "$interface" en mode DHCP
auto $interface
iface $interface inet dhcp" >> $chemin_interfaces

					fi


					sleep 2
					## On affiche le fichier créé (ou modifié)
					echo -e "$orange Vérification du fichier $chemin_interfaces$normal"
					echo
					cat $chemin_interfaces
					echo -e "$orange----------------------------------------$normal"
					echo
					echo -e "$orange Verification du fichier /etc/resolv.conf :$normal"
					echo
					cat /etc/resolv.conf
					echo -e "$orange-------------------------------------$normal"
					echo
					sleep 1
					ip link set dev $interface down
					sleep 2
					ip link set dev $interface up
					sleep 2
					systemctl restart networking.service

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;



				4)


					echo -e "$bleu------------------------------------------------------$normal"
					echo -e "$bleu      Configuration Ethernet en Statique (Client)        $normal"
					echo -e "$bleu------------------------------------------------------$normal"

					nmcli connection show --active

					echo

					echo -n "Nom de l'interface (DEVICE) : " 
					read interface

					echo -n "Nom de la connexion (NAME): "
					read Nom_Connexion

					echo -n "adresse IP et masque (ex : 192.168.1.1/24): "
					read IP

					echo -n "Passerelle: "
					read passerelle

					echo -n "dns: "
					read dns


					
					#nmcli device modify "$interface" ipv4.method manual ipv4.addresses $IP
					nmcli connection modify "$Nom_Connexion" ipv4.method manual ipv4.addresses $IP ipv4.gateway $passerelle ipv4.dns $dns
					sleep 1
					ip link set dev $interface down
					sleep 1
					ip link set dev $interface up
					sleep 1
					systemctl restart NetworkManager

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				5)

					echo -e "$bleu--------------------------------------------------$normal"
					echo -e "$bleu      Configuration Ethernet en DHCP (Client)     $normal"
					echo -e "$bleu--------------------------------------------------$normal"

					echo
					nmcli connection show --active
					echo

					echo -n "Nom de l'interface (DEVICE):"
					read interface

					echo -n "Nom de la connexion (NAME): "
					read Nom_Connexion

					nmcli connection modify "$Nom_Connexion" ipv4.method auto
					sleep 1
					ip link set dev $interface down
					sleep 1
					ip link set dev $interface up
					sleep 1
					systemctl restart NetworkManager

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				6)

					echo -e "$bleu----------------------------------------------------------$normal"
					echo -e "$bleu      Renouveler l'IP auprès du serveur DHCP (Client)     $normal"
					echo -e "$bleu----------------------------------------------------------$normal"

					echo

					nmcli connection show

					echo

					echo -n "Nom de l'interface:"
					read interface


					dhclient -r $interface
						
					dhclient $interface
						
						
					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;

				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour continuer..."
					clear
					;;
				esac
			done
			;;

########3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-3-
		3)
			echo -e "$bleu---------------------------------------------------$normal"
			echo -e "$bleu      Ajouter les dépots bullseye main contrib     $normal"
			echo -e "$bleu---------------------------------------------------$normal"
			echo

			if [ -a /etc/apt/sources.list ]
			then
				sed -i 's/^/#/' /etc/apt/sources.list
				sleep 1
				echo "
deb http://deb.debian.org/debian bullseye main contrib
deb http://deb.debian.org/debian/ bullseye-updates main contrib
deb http://security.debian.org/debian-security bullseye-security main contrib" >> /etc/apt/sources.list

			else
				echo "
deb http://deb.debian.org/debian bullseye main contrib
deb http://deb.debian.org/debian/ bullseye-updates main contrib
deb http://security.debian.org/debian-security bullseye-security main contrib" > /etc/apt/sources.list

			fi

			less /etc/apt/sources.list
			clear
			;;

########4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-4-
		4)
			while :
			do
				echo -e ""$bleu"1 : Verification du proxy"
				echo -e "2 : Configurer un proxy"
				echo -e "3 : Suppression de la Configuration proxy$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"

				read optionmenu
				case $optionmenu in


				1)

					echo -e "$bleu----------------------------$normal"
					echo -e "$bleu      Verifier le proxy     $normal"
					echo -e "$bleu----------------------------$normal"

					if [ -a /etc/apt/apt.conf.d/80proxy ]
					then
						echo -e ""$vert"Le fichier /etc/apt/apt.conf.d/80proxy est présent$normal"
						echo -e ""$vert"--------------------------------------------------$normal"
						echo 
						less /etc/apt/apt.conf.d/80proxy
					else
						echo -e ""$rouge"Le proxy n'est pas actif$normal"
					fi

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."
					clear
					;;

				2)

					echo -e "$bleu------------------------------$normal"
					echo -e "$bleu      Configurer un proxy     $normal"
					echo -e "$bleu------------------------------$normal"
					echo 
					echo "entrez l'IP:port du serveur proxy, ex : 10.10.10.10:8080"
					echo -n ""
					read ip_proxy
					echo -e "
Acquire::http::proxy \"http://$ip_proxy/\";
Acquire::https::proxy \"https://$ip_proxy/\";
Acquire::ftp::proxy \"ftp://$ip_proxy/\";

# Si l'authentification est recquise configurer comme suit :
# Acquire::http::proxy \"http://<username>:<password>@<proxy>:<port>/\";
# Acquire::https::proxy \"https://<username>:<password>@<proxy>:<port>/\";
# Acquire::ftp::proxy \"ftp://<username>:<password>@<proxy>:<port>/\";" > /etc/apt/apt.conf.d/80proxy
					echo 
					echo -e ""$orange"-------------------------- configuration terminée ---------------------------------$normal"
					echo 
					echo -e ""$orange"-------------- Affichage du fichier créé -------------------$normal"
					echo 
					less /etc/apt/apt.conf.d/80proxy
					sleep 2
					if [ -a /etc/apt/apt.conf.d/80proxy ]
					then
						echo "Le fichier /etc/apt/apt.conf.d/80proxy est toujours présent"
						less /etc/apt/apt.conf.d/80proxy
					else
						echo -e ""$vert"Le fichier /etc/apt/apt.conf.d/80proxy a bien été supprimé$normal"
					fi
					clear
					;;

				3)
					echo -e "$bleu------------------------------------------------$normal"
					echo -e "$bleu      Suppression de la Configuration proxy     $normal"
					echo -e "$bleu------------------------------------------------$normal"
					echo 
					echo -e ""$orange"suppression du fichier /etc/apt/apt.conf.d/80proxy$normal"
					echo 
					rm /etc/apt/apt.conf.d/80proxy
					read -n1 -r -p "Appuyer sur entrée pour continuer..."
					clear
					;;

				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour continuer..."
					clear
					;;
				esac
			done
					;;

########5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-5-
		5)

			echo -e "$bleu-------------------------------$normal"
			echo -e "$bleu       Activer le routage      $normal"
			echo -e "$bleu-------------------------------$normal"

			sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

			sysctl -p

			echo

			read -n1 -r -p "Appuyer sur entrée pour continuer..."

			clear

			;;

########6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-6-
		6)

			while :
			do
				echo -e ""$bleu"1 : Verification du serveur DHCP"
				echo -e "2 : Configuration d'un serveur DHCP principal"
				echo -e "3 : Configuration d'un serveur DHCP secondaire"
				echo -e "4 : Configuration du FailOver - serveur DHCP principal"
				echo -e "5 : Configuration du FailOver - serveur DHCP secondaire"
				echo -e "6 : Configuration d'un relais DHCP"
				echo -e "7 : Journal des logs du service isc-dhcp-server (50 dernières lignes)$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in



				1)
					echo -e "$bleu-------------------------------------$normal"
					echo -e "$bleu      Verification du serveur DHCP       $normal"
					echo -e "$bleu-------------------------------------$normal"

					echo
					echo -e ""$orange"Vérification du package isc-dhcp-server$normal"
					echo -e ""$orange"---------------------------------------$normal"
					if (apt list --installed | grep isc-dhcp-server)
					then
						echo -e ""$vert"isc-dhcp-server est installé$normal"
						echo
						echo
					else
						echo -e ""$rouge"isc-dhcp-server n'est pas installé$normal"
						echo
						echo
					fi

					echo -e ""$orange"Fichiers de configuration isc-dhcp-server$normal"
					echo -e ""$orange"-----------------------------------------$normal"
					echo
					if [ -a /etc/default/isc-dhcp-server ]
					then
						echo -e ""$vert"Le fichier /etc/default/isc-dhcp-server est présent :$normal"
						echo 
						read -n1 -r -p "Appuyer sur entrée pour ouvrir le fichier..."
						less /etc/default/isc-dhcp-server
						echo 
					else
						echo -e ""$rouge"Le fichier /etc/default/isc-dhcp-server n'existe pas$normal"
						echo 
					fi

					if [ -a /etc/dhcp/dhcpd.conf ]
					then
						echo -e ""$vert"Le fichier /etc/dhcp/dhcpd.conf est présent :$normal"
						echo 
						read -n1 -r -p "Appuyer sur entrée pour ouvrir le fichier..."

						less /etc/dhcp/dhcpd.conf
						echo 
						echo -e ""$vert"Vérification du status du service DHCP :$normal"
						echo -e ""$vert"--------------------------------------$normal"
						systemctl status isc-dhcp-server.service
					else
						echo -e ""$rouge"Le fichier /etc/dhcp/dhcpd.conf n'existe pas$normal"
						echo 
					fi

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				2)
					echo -e "$bleu---------------------------------------------------$normal"
					echo -e "$bleu      Configuration d'un serveur DHCP principal    $normal"
					echo -e "$bleu---------------------------------------------------$normal"


					if (apt list --installed | grep isc-dhcp-server)
					then
						echo
						echo ""$orange"isc-dhcp-server est déjà installé$normal"

					else
						echo "installation avec apt install isc-dhcp-server"

						if apt install isc-dhcp-server -y | grep -E "Erreur|Impossible"
						then
							echo 
							echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
							echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

							exit 4
						else
							if_erreur
						fi

						echo -e ""$orange"------------------------ Installation terminée -------------------------$normal"
						sleep 2
					fi

					echo
					echo -e ""$vert"------------ Interfaces réseaux présentes ------------$normal"

					ip a | grep UP | grep -v LOOPBACK | awk '{print $2}'
					echo -e ""$vert"------------------------------------------------------$normal"

					echo

					echo -n "merci de rentrer le nom de l'interface reseau qui va recevoir les requetes DHCPDISCOVER : "
					read int


					#sed -i 's/"#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/"DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/g' /etc/default/isc-dhcp-server 
					sleep 1
					sed -i 's/INTERFACESv4=""/INTERFACESv4="'$int'"/g' /etc/default/isc-dhcp-server
					sleep 1



					echo "#### configuration de l'etendue ####"

					echo -n "IP du reseau : "
					read IP_Reseau
					echo -n "Masque du reseau : "
					read masque
					echo -n "Premiere adresse IP de l'etendue : "
					read Adresse_1
					echo -n "Derniere adresse IP de l'etendue : "
					read Adresse_2
					echo -n "Passerelle : "
					read passerelle
					echo -n "Serveur(s) DNS, séparés d'un espace si 2 adresses IP renseignées : "
					read dns dns2

					sed -i 's/option domain-name \"example.org\";/#option domain-name \"example.org\";/g' /etc/dhcp/dhcpd.conf
					sed -i 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/default-lease-time 600;/#default-lease-time 600;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/max-lease-time 7200;/#max-lease-time 7200;/g' /etc/dhcp/dhcpd.conf

					if [ -z $dns2 ]
					then
						echo "option domain-name-servers $dns; # DNS" >> /etc/dhcp/dhcpd.conf 
					else
						echo "option domain-name-servers $dns, $dns2; # DNS" >> /etc/dhcp/dhcpd.conf 
					fi

					echo "
default-lease-time 86400; # Bail de 24H
max-lease-time 172800; # Bail maxi de 48H

ddns-update-style none;

authoritative;
log-facility local7;

# Déclaration d'un réseau
subnet $IP_Reseau netmask $masque {
		range                   $Adresse_1 $Adresse_2; # Plage IP
		option routers          $passerelle; # Passerelle
}" >> /etc/dhcp/dhcpd.conf

					sleep 2

					echo "#### redemarrage du service ####"
					systemctl restart isc-dhcp-server.service

					echo "#### ajout du service au demarrage de la machine ####"
					systemctl enable isc-dhcp-server.service

					sleep 3

					echo "#### Verification du service ####"
					systemctl status isc-dhcp-server.service

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				3)
					echo -e "$bleu-----------------------------------------------------$normal"
					echo -e "$bleu      Configuration d'un serveur DHCP secondaire     $normal"
					echo -e "$bleu-----------------------------------------------------$normal"
					echo 

					if (apt list --installed | grep isc-dhcp-server)
					then
						echo
						echo ""$orange"isc-dhcp-server est déjà installé$normal"

					else
						echo "installation avec apt install isc-dhcp-server"

						if apt install isc-dhcp-server -y | grep -E "Erreur|Impossible"
						then
							echo 
							echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
							echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

							exit 4
						else
							if_erreur
						fi

						echo -e ""$orange"------------------------ Installation terminée -------------------------$normal"
						sleep 2
					fi

					echo
					echo -e ""$vert"------------ Interfaces réseaux présentes ------------$normal"

					ip a | grep UP | grep -v LOOPBACK | awk '{print $2}'
					echo -e ""$vert"------------------------------------------------------$normal"

					echo

					echo -n "merci de rentrer le nom de l'interface reseau qui va recevoir les requetes DHCPDISCOVER : "
					read int


					#sed -i 's/"#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/"DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/g' /etc/default/isc-dhcp-server 
					sleep 1
					sed -i 's/INTERFACESv4=""/INTERFACESv4="'$int'"/g' /etc/default/isc-dhcp-server
					sleep 1



					echo "#### configuration de l'etendue ####"

					echo -n "IP du reseau : "
					read IP_Reseau
					echo -n "Masque du reseau : "
					read masque
					echo -n "Premiere adresse IP de l'etendue : "
					read Adresse_1
					echo -n "Derniere adresse IP de l'etendue : "
					read Adresse_2
					echo -n "Passerelle : "
					read passerelle
					echo -n "Serveur(s) DNS, séparés d'un espace si 2 adresses IP renseignées : "
					read dns dns2

					sed -i 's/option domain-name \"example.org\";/#option domain-name \"example.org\";/g' /etc/dhcp/dhcpd.conf
					sed -i 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/default-lease-time 600;/#default-lease-time 600;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/max-lease-time 7200;/#max-lease-time 7200;/g' /etc/dhcp/dhcpd.conf

					if [ -z $dns2 ]
					then
						echo "option domain-name-servers $dns; # DNS" >> /etc/dhcp/dhcpd.conf 
					else
						echo "option domain-name-servers $dns, $dns2; # DNS" >> /etc/dhcp/dhcpd.conf 
					fi


					echo "
default-lease-time 1800;
max-lease-time 3600;

ddns-update-style none;
					
not authoritative;
min-secs 5;
					
subnet $IP_reseau netmask $masque {
		range $Adresse_1 $Adresse_2;
		option routers $passerelle;
}" >> /etc/dhcp/dhcpd.conf

					echo 
					echo -e ""$orange"---------------------------- Fin de la configuration ---------------------------$normal"
					echo 
					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					sleep 2

					echo "#### redemarrage du service ####"
					systemctl restart isc-dhcp-server.service

					echo "#### ajout du service au demarrage de la machine ####"
					systemctl enable isc-dhcp-server.service

					sleep 3

					echo "#### Verification du service ####"
					systemctl status isc-dhcp-server.service

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				4)
					echo -e "$bleu-------------------------------------------------------------$normal"
					echo -e "$bleu      Configuration du FailOver - serveur DHCP principal     $normal"
					echo -e "$bleu-------------------------------------------------------------$normal"
					echo 

					if (apt list --installed | grep isc-dhcp-server)
					then
						echo
						echo ""$orange"isc-dhcp-server est déjà installé$normal"

					else
						echo "installation avec apt install isc-dhcp-server"

						if apt install isc-dhcp-server -y | grep -E "Erreur|Impossible"
						then
							echo 
							echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
							echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

							exit 4
						else
							if_erreur
						fi

						echo -e ""$orange"------------------------ Installation terminée -------------------------$normal"
						sleep 2
					fi

					echo
					echo -e ""$vert"------------ Interfaces réseaux présentes ------------$normal"

					ip a | grep UP | grep -v LOOPBACK | awk '{print $2}'
					echo -e ""$vert"------------------------------------------------------$normal"

					echo

					echo -n "merci de rentrer le nom de l'interface reseau qui va recevoir les requetes DHCPDISCOVER : "
					read int


					#sed -i 's/"#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/"DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/g' /etc/default/isc-dhcp-server 
					sleep 1
					sed -i 's/INTERFACESv4=""/INTERFACESv4="'$int'"/g' /etc/default/isc-dhcp-server
					sleep 1


					echo 
					echo "#### début de configuration ####"
					echo
					echo -n "nom du Failover : "
					read nom
					echo -n "IP du serveur DHCP master : "
					read ip_master
					echo -n "IP du serveur DHCP secondaire : "
					read ip_slave
					echo -n "IP du reseau : "
					read ip_reseau
					echo -n "Masque du reseau : "
					read masque
					echo -n "Premiere adresse IP de l'etendue : "
					read Adresse_1
					echo -n "Derniere adresse IP de l'etendue : "
					read Adresse_2
					echo -n "Passerelle : "
					read passerelle
					echo -n "Serveur(s) DNS, séparés d'un \";\" si 2 adresses IP renseignées : "
					read dns


					sed -i 's/option domain-name \"example.org\";/#option domain-name \"example.org\";/g' /etc/dhcp/dhcpd.conf
					sed -i 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/default-lease-time 600;/#default-lease-time 600;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/max-lease-time 7200;/#max-lease-time 7200;/g' /etc/dhcp/dhcpd.conf


					echo -e "
authoritative;

# Paramétrage du failover du DHCP principal
failover peer \"$nom\" {
	primary; # Déclare ce serveur comme master.
	address $ip_master;       # Adresse du serveur master.
	port 520;  # Port d'écoute du serveur master.

	peer address $ip_slave; # Adresse du serveur slave.
	peer port 520;     # Port d'écoute du serveur slave.

	max-response-delay 60;	 # Temps de non réponse en secondes.
	max-unacked-updates 10;	 # Nbr de massages d'information de Maj avt l'envoi d'un accusé de reception
	load balance max seconds 3;

	mclt 3600;	 # délai pdt lequel un serveur peut renouveler un bail obtenu auprès de l'autre serveur
	split 255;	 # Répartition des plages d'adresses.
}

# Paramétrage de la configuration à distribuer aux postes clients
subnet $ip_reseau netmask $masque {
	option domain-name-servers $dns;  # serveur DNS
	option routers $passerelle;        # Passerelle par défaut
	default-lease-time 21600;         # Bail de 6 heures par défaut
	max-lease-time 36000;         # Bail pouvant aller jusqu'à 10 heures
	pool {
		failover peer \"$nom\";
		range $Adresse_1 $Adresse_2;    # Plage d'adresses IP

	}
}" >> /etc/dhcp/dhcpd.conf

					echo 
					echo -e ""$orange"---------------------------- Fin de la configuration ---------------------------$normal"
					echo 
					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					echo "#### redemarrage du service ####"
					systemctl restart isc-dhcp-server.service

					echo "#### ajout du service au demarrage de la machine ####"
					systemctl enable isc-dhcp-server.service

					sleep 3

					echo "#### Verification du service ####"
					systemctl status isc-dhcp-server.service

					echo
					clear

					;;

				5)
					echo -e "$bleu-------------------------------------------------------------$normal"
					echo -e "$bleu      Configuration du FailOver - serveur DHCP secondaire    $normal"
					echo -e "$bleu-------------------------------------------------------------$normal"
					echo 

					if (apt list --installed | grep isc-dhcp-server)
					then
						echo
						echo ""$orange"isc-dhcp-server est déjà installé$normal"

					else
						echo "installation avec apt install isc-dhcp-server"
						
						if apt install isc-dhcp-server -y | grep -E "Erreur|Impossible"
						then
							echo 
							echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
							echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

							exit 4
						else
							if_erreur
						fi

						echo -e ""$orange"------------------------ Installation terminée -------------------------$normal"
						sleep 2
					fi

					echo
					echo -e ""$vert"------------ Interfaces réseaux présentes ------------$normal"

					ip a | grep UP | grep -v LOOPBACK | awk '{print $2}'
					echo -e ""$vert"------------------------------------------------------$normal"

					echo

					echo -n "merci de rentrer le nom de l'interface reseau qui va recevoir les requetes DHCPDISCOVER : "
					read int


					#sed -i 's/"#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/"DHCPDv4_CONF=/etc/dhcp/dhcpd.conf"/g' /etc/default/isc-dhcp-server 
					sleep 1
					sed -i 's/INTERFACESv4=""/INTERFACESv4="'$int'"/g' /etc/default/isc-dhcp-server
					sleep 1



					echo "#### début de configuration ####"
					echo
					echo -n "nom du Failover : "
					read nom
					echo -n "IP du serveur DHCP master : "
					read ip_master
					echo -n "IP du serveur DHCP secondaire : "
					read ip_slave
					echo -n "IP du reseau : "
					read ip_reseau
					echo -n "Masque du reseau : "
					read masque
					echo -n "Premiere adresse IP de l'etendue : "
					read Adresse_1
					echo -n "Derniere adresse IP de l'etendue : "
					read Adresse_2
					echo -n "Passerelle : "
					read passerelle
					echo -n "Serveur(s) DNS, séparés d'un \";\" si 2 adresses IP renseignées : "
					read dns

					sed -i 's/option domain-name \"example.org\";/#option domain-name \"example.org\";/g' /etc/dhcp/dhcpd.conf
					sed -i 's/option domain-name-servers ns1.example.org, ns2.example.org;/#option domain-name-servers ns1.example.org, ns2.example.org;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/default-lease-time 600;/#default-lease-time 600;/g' /etc/dhcp/dhcpd.conf
					sed -i 's/max-lease-time 7200;/#max-lease-time 7200;/g' /etc/dhcp/dhcpd.conf


					echo -e "
# Paramétrage du failover du DHCP Slave
failover peer \"$nom\" {
	secondary;	 # Déclare ce serveur comme slave.

	address $ip_slave;	 # Adresse du serveur slave.
	port 520;	 # Port d'écoute du serveur slave.

	peer address $ip_master;	 # Adresse du serveur master.
	peer port 520;	 # Port d'écoute du serveur master.

	max-response-delay 60;	 # Temps de non réponse en secondes.
	max-unacked-updates 10;	 # Nombre de mises à jour avant de déclarer le pair en échec
	load balance max seconds 3; 	# Durée max avant de décharger la requête vers le pair
}

# Paramétrage de la configuration à distribuer aux postes clients
subnet $ip_reseau netmask $masque {
	option routers $passerelle;        # Passerelle par défaut
	option domain-name-servers $dns;   # serveur DNS
	default-lease-time 21600;         # Bail de 6 heures par défaut
	max-lease-time 36000;         # Bail pouvant aller jusqu'à 10 heures
	pool {
		failover peer \"$nom\";                # Indique la configuration du failover
		range $Adresse_1 $Adresse_2;    # Plage d'adresses IP

	}
}" >> /etc/dhcp/dhcpd.conf

					echo 
					echo -e ""$orange"---------------------------- Fin de la configuration ---------------------------$normal"
					echo 
					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					echo "#### redemarrage du service ####"
					systemctl restart isc-dhcp-server.service

					echo "#### ajout du service au demarrage de la machine ####"
					systemctl enable isc-dhcp-server.service

					sleep 3

					echo "#### Verification du service ####"
					systemctl status isc-dhcp-server.service

					echo
					clear
					;;


				6)
					echo -e "$bleu----------------------------------------$normal"
					echo -e "$bleu      Configuration d'un relais DHCP     $normal"
					echo -e "$bleu----------------------------------------$normal"

					echo
					echo -e ""$orange"Vérification du package isc-dhcp-relay$normal"
					echo -e ""$orange"-----------------------------$normal"
					if (apt list --installed | grep isc-dhcp-relay/stable)
					then
						echo -e ""$vert"isc-dhcp-relay est installé$normal"
						echo
						echo -e ""$orange"Vérification du fichier /etc/default/isc-dhcp-relay$normal"
						echo 
						less /etc/default/isc-dhcp-relay
						echo 

					else
						echo -e ""$rouge"isc-dhcp-relay n'est pas installé$normal"
						echo
						echo -e ""$orange"Installation du package isc-dhcp-relay$normal"
						echo -e ""$orange"--------------------------------------$normal"
						echo 
						echo "Pendant l'installation du paquet une fenêtre de configuration va s'ouvrir, laissez vide et appuyez sur <entrée> pour chaque champs"
						echo
						read -n1 -r -p "Appuyer sur entrée pour continuer..."
						if apt install isc-dhcp-relay -y | grep -E "Erreur|Impossible"
						then
							echo 
							echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
							echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

							exit 4
						else
							if_erreur
						fi

						echo -e ""$orange"Configuration du fichier /etc/default/isc-dhcp-relay$normal"
						echo -e ""$orange"----------------------------------------------------$normal"
						echo 
						echo -e ""$vert"------------ Interfaces réseaux présentes ------------$normal"

						ip a | grep UP | grep -v LOOPBACK | awk '{print $2}'
						echo -e ""$vert"------------------------------------------------------$normal"
						echo
						echo "entrer le nom de l'interface reseau qui relaiera les requetes DHCPDISCOVER :"
						echo "séparez d'un espace si plusieurs interfaces"
						echo -n ""
						read int
						echo 
						echo "entrer l'IP du serveur DHCP :"
						echo -n ""
						read ip

						
						echo 
						sed -i 's/SERVERS=""/SERVERS="'$ip'"/g' /etc/default/isc-dhcp-relay
						sed -i 's/INTERFACES=""/INTERFACE="'$int'"/g' /etc/default/isc-dhcp-relay
						echo 
						echo 
						echo -e ""$orange"---------------------------- Fin de la configuration ---------------------------$normal"
						echo 
						read -n1 -r -p "Appuyer sur entrée pour continuer..."
						clear
					fi
					;;


				7)
					journalctl -u isc-dhcp-server | tail -50
					;;


				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;

########7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-7-
		7)

			while :
			do
				echo -e ""$bleu"1 : Verification la configuration du serveur DNS"
				echo -e "2 : Installation serveur DNS resolveur"
				echo -e "3 : Installation serveur DNS hebergeur"
				echo -e "4 : Configuration d'un redirecteur conditionnel"
				echo -e "5 : Déclarer ce serveur en tant que serveur DNS secondaire$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in


				1)

					echo -e "$bleu----------------------------------------------------------$normal"
					echo -e "$bleu      Vérification de la configuration du serveur DNS     $normal"
					echo -e "$bleu----------------------------------------------------------$normal"

					echo
					echo -e ""$orange"Vérification du package bind9$normal"
					echo -e ""$orange"-----------------------------$normal"
					if (apt list --installed | grep bind9/stable)
					then
						echo -e ""$vert"bind9 est installé$normal"
						bind9=$(echo -e ""$vert"bind9 est installé$normal")
						echo
						echo
					else
						echo -e ""$rouge"bind9 n'est pas installé$normal"
						bind9=$(echo -e ""$rouge"bind9 n'est pas installé$normal")
						echo
						echo
					fi

					echo -e ""$orange"Vérification des fichiers de configuration bind9$normal"
					echo -e ""$orange"------------------------------------------------$normal"
					echo
					if [ -a /etc/bind/named.conf ]
					then
						echo -e ""$vert"Le fichier /etc/bind/named.conf ( DNS resolveur) ) est présent$normal"
						named_conf=$(echo -e ""$vert"Le fichier /etc/bind/named.conf ( DNS resolveur) ) est présent$normal")
						echo 
						read -n1 -r -p "Appuyer sur entrée pour ouvrir le fichier..."
						less /etc/bind/named.conf
						echo 
					else
						echo -e ""$rouge"Le fichier /etc/bind/named.conf ( DNS resolveur ) n'existe pas$normal"
						named_conf=$(echo -e ""$rouge"Le fichier /etc/bind/named.conf ( DNS resolveur ) n'existe pas$normal")
						echo 
					fi

					if [ -a /etc/bind/named.conf.options ]
					then
						echo -e ""$vert"Le fichier /etc/bind/named.conf.options ( DNS resolveur ) est présent$normal"
						named_conf_options=$(echo -e ""$vert"Le fichier /etc/bind/named.conf.options ( DNS resolveur ) est présent$normal")
						echo 
						read -n1 -r -p "Appuyer sur entrée pour ouvrir le fichier..."

						less /etc/bind/named.conf.options
						echo 
					else
						echo -e ""$rouge"Le fichier /etc/bind/named.conf.options ( DNS resolveur ) n'existe pas$normal"
						named_conf_options=$(echo -e ""$rouge"Le fichier /etc/bind/named.conf.options ( DNS resolveur ) n'existe pas$normal")
						echo 
					fi

					if [ -a /etc/bind/named.conf.local ]
					then
						echo -e ""$vert"Le fichier /etc/bind/named.conf.local ( DNS hebergeur ) est présent$normal"
						named_conf_local=$(echo -e ""$vert"Le fichier /etc/bind/named.conf.local ( DNS hebergeur ) est présent$normal")
						echo 
						read -n1 -r -p "Appuyer sur entrée pour ouvrir le fichier..."

						less /etc/bind/named.conf.local
						echo 
					else
						echo -e ""$rouge"Le fichier /etc/bind/named.conf.local ( DNS hebergeur ) n'existe pas$normal"
						named_conf_local=$(echo -e ""$rouge"Le fichier /etc/bind/named.conf.local ( DNS hebergeur ) n'existe pas$normal")
						echo 
					fi

					if [ -a /var/cache/bind ]
					then
						echo -e ""$vert"Le dossier /var/cache/bind est présent$normal"
						cache_bind=$(echo -e ""$vert"Le dossier /var/cache/bind est présent :$normal")
						echo 
						echo "Fichiers contenus dans le dossier /var/cache/bind"
						# Vérifier si des fichiers de zone direct et inverse sont présents
						ls /var/cache/bind
						echo 
					else
						echo -e ""$rouge"Le dossier /var/cache/bind n'existe pas$normal"
						cache_bind=$(echo -e ""$rouge"Le dossier /var/cache/bind n'existe pas$normal")
						echo 
					fi			

					if (apt list --installed | grep bind9/stable)
					then
						echo
						echo -e ""$vert"Vérification du status du service DNS$normal"
						echo -e ""$vert"-------------------------------------$normal"
						systemctl status bind9.service
						echo -e ""$orange"-------------------------------------------------------------$normal"

					fi

					echo 
					echo "---- Récapitulatif ----"
					echo
					echo $bind9
					echo $named_conf
					echo $named_conf_options
					echo $named_conf_local
					echo $cache_bind
					echo
					echo "Fichiers de zones contenus dans /var/cache/bind :"
					echo "-----------------------------------------------"
					ls /var/cache/bind/db.*
					echo
					echo "-----------------------"

					echo 
					echo 
					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear
					;;


				2)
		
					echo -e "$bleu---------------------------------------------$normal"
					echo -e "$bleu      Installation serveur DNS resolveur      $normal"
					echo -e "$bleu---------------------------------------------$normal"
					echo
					echo -e ""$vert"Vérification de l'installation de bind9$normal"
					if (apt list --installed | grep bind9/stable)
					then
						echo
						echo "bind9 est déjà installé"

					else
						echo "installation avec apt install bind9"

						if apt install bind9 | grep -E "Erreur|Impossible"
						then
							echo 
							echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
							echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

							exit 4
						else
							if_erreur
						fi

						sleep 2
					fi

					echo
					echo "entrer l'adresse ou les adresses IP du redirecteur (forwarder)"
					echo -n "utilisez '; ' pour les séparer si il y en a plusieurs ( exemple 8.8.8.8; 55.33.22.11 ) : "
					read redirecteur
					echo
					echo "entrez le/les reseaux/CIDR concerné(s)" 
					echo -n "utilisez '; ' pour les séparer si il y en a plusieurs ( exemple 172.18.19.0/24; 192.168.15.0/24 ): "
					read reseau

					echo -e ""$vert"Configuration fichier /etc/bind/named.conf$normal"
					echo "
// rsxclts = réseaux des postes clients
acl rsxclts { $reseau; };" >> /etc/bind/named.conf
					echo 
					echo "Le fichier /etc/bind/named.conf a été configuré"

					sleep 1

					# Redirecteur Inconditionnel
					# On décommente et on remplace l'IP du forwarder des 3 lignes suivantes :
					# //forwarders {
					# //  	0.0.0.0;
					#// };
					sed -i 's/\/\/ forwarders/forwarders/g' /etc/bind/named.conf.options
					sed -i 's/\/\/ 	0.0.0.0;/'$redirecteur';/g' /etc/bind/named.conf.options
					sed -i 's/\/\/ };/};/g' /etc/bind/named.conf.options

					sleep 1

					# On supprime la ligne dnssec-validation auto;
					chaine2=$(grep "dnssec-validation auto;" /etc/bind/named.conf.options)
					num_li_dnssec=$(grep -n "$chaine2" /etc/bind/named.conf.options | cut -d: -f1)
					sed -i ''$num_li_dnssec'd' /etc/bind/named.conf.options

					sleep 1

					# on place le texte voulu à la suite de la ligne listen-on-v6 { any; };
					chaine=$(grep "listen-on-v6 { any; };" /etc/bind/named.conf.options)
					numero_ligne=$(grep -n "$chaine" /etc/bind/named.conf.options | cut -d: -f1)

					ligne0=$(($numero_ligne + 1))
					ligne1=$(($numero_ligne + 2))
					ligne2=$(($numero_ligne + 3))
					ligne3=$(($numero_ligne + 4))
					ligne4=$(($numero_ligne + 5))
					ligne5=$(($numero_ligne + 6))
					ligne6=$(($numero_ligne + 7))
					ligne7=$(($numero_ligne + 8))
					ligne8=$(($numero_ligne + 9))
					ligne9=$(($numero_ligne + 10))
					ligne10=$(($numero_ligne + 11))
					ligne11=$(($numero_ligne + 12))
					ligne12=$(($numero_ligne + 13))



					sed -i ''$ligne0'i\\t' /etc/bind/named.conf.options
					sed -i ''$ligne1'i\\t//communication DNSSEC désactivée' /etc/bind/named.conf.options
					sed -i ''$ligne2'i\\tdnssec-enable no;' /etc/bind/named.conf.options
					sed -i ''$ligne3'i\\tdnssec-validation no;' /etc/bind/named.conf.options
					sed -i ''$ligne4'i\\t' /etc/bind/named.conf.options
					sed -i ''$ligne5'i\\t//information version' /etc/bind/named.conf.options
					sed -i ''$ligne6'i\\tversion none;' /etc/bind/named.conf.options
					sed -i ''$ligne7'i\\t' /etc/bind/named.conf.options
					sed -i ''$ligne8'i\\t//restriction des hotes auxquels réponds le serveur' /etc/bind/named.conf.options
					sed -i ''$ligne9'i\\tallow-query { rsxclts; };' /etc/bind/named.conf.options
					sed -i ''$ligne10'i\\t//restriction des hotes autorisés à adrésser des requetes récursives au serveur' /etc/bind/named.conf.options
					sed -i ''$ligne11'i\\tallow-recursion { rsxclts; };' /etc/bind/named.conf.options
					sed -i ''$ligne12'i\\t' /etc/bind/named.conf.options
			
					sleep 2

					systemctl restart bind9

					sleep 1

					named-checkconf

					echo

					read -n1 -r -p "Appuyer sur entrée pour continuer..."

					clear

					;;

				3)

					echo -e "$bleu---------------------------------------------$normal"
					echo -e "$bleu      Installation serveur DNS hebergeur     $normal"
					echo -e "$bleu---------------------------------------------$normal"
					echo 
					echo -e ""$vert"Vérification de l'installation de bind9$normal"
					if (apt list --installed | grep bind9/stable)
					then
						echo
						echo "bind9 est déjà installé"

					else
						echo "installation avec apt install bind9"
						if apt install bind9 -y | grep -E "Erreur|Impossible"
						then
							echo 
							echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
							echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

							exit 4
						else
							if_erreur
						fi

						sleep 2
					fi

					echo
					echo "entrer le nom FQDN du domaine (nom de la zone direct)"
					echo "ex, avec un nom de domaine ici.local Le nom du fichier de configuration de la zone directe sera db.ici.local :"
					echo -n ""
					read zone_directe
					echo 
					echo "entrer uniquement les octets de la partie réseau"
					echo "(ex : pour le réseau 192.168.10.0/24, entrez 192.168.10, le nom du fichier de configuration de la zone inverse sera db.192.168.10.inv"
					echo "et la zone inverse sera 10.168.192.in-addr.arpa"
					echo -n ""
					read zone_inverse
					echo 
					echo -n "entrer l'IP du serveur DNS secondaire, laissez vide si il n'y en a pas : "
					read dns_secondaire
					echo 
					echo 
					

					# Création du fichier de configuration de la zone direct dans /var/cache/bind
					host=$(hostname)
					echo -e "
; fichier de zone du domaine $zone_directe

\$ORIGIN "$zone_directe".
\$TTL 86400

@		SOA		"$host"."$zone_directe". hostmaster."$zone_directe". (
					1	; serial
					86400	; refresh 1 day 
					7200	; retry 2 hours 
					3600000 ; expire
					3600 )	; negative TTL
@		NS		"$host"."$zone_directe".

; exemple
;nom1   A	172.15.20.4
;alias	CNAME	nom1."$host"."$zone_directe". " > /var/cache/bind/db.$zone_directe

					# Création du fichier de configuration de la zone direct dans /var/cache/bind
					echo -n "entrer l'IP du réseau/CIDR : "
					read IP_Reseau

					echo -e "
; zone inverse pour le réseau $IP_Reseau

\$TTL 86400

@		SOA		"$host"."$zone_directe". (
					1	; serial
					86400	; refresh 1 day 
					7200 	; retry 2 hours 
					3600000	; expire
					3600 )	; negative TTL

@		NS 		"$host"."$zone_directe".

; exemple

;1	PTR 	srv1."$zone_directe".
;15	PTR 	test."$zone_directe". " > /var/cache/bind/db."$zone_inverse".inv

				
					# Création du fichier de configuration des zones dans /etc/bind/named.conf.local
					if [ -z $dns_secondaire ]
					then
						echo -e "
# zone directe
zone \"$zone_directe\" {
		type master;
		file "/var/cache/bind/db.$zone_directe";
}; 

#zone inverse
zone \""$zone_inverse".in-addr.arpa\" {
		type master;
		file "/var/cache/bind/db."$zone_inverse".inv";
};" >>  /etc/bind/named.conf.local

					else
						echo -e "
# zone directe
zone \"$zone_directe\" {
		type master;
		file "/var/cache/bind/db.$zone_directe";
		allow-transfer { $dns_secondaire; }; # IP du serveur dns secondaire
}; 

#zone zone inverse
zone \""$zone_inverse".in-addr.arpa\" {
		type master;
		file "/var/cache/bind/db."$zone_inverse".inv";
		allow-transfer { $dns_secondaire; }; # IP du serveur dns secondaire
};" >>  /etc/bind/named.conf.local

					fi

					echo -e ""$orange"------------------------- Fin de l'installation --------------------------$normal"

					echo 

					echo -e ""$orange"Vérification de la configuration$normal"
					echo -e ""$orange"--------------------------------$normal"
					echo "named-checkconf :"
					named-checkconf
					echo -e ""$orange"------------------------------------------------------------------------------$normal"
					echo "named-checkzone - zone directe :"
					named-checkzone $zone_directe /var/cache/bind/db.$zone_directe
					echo 
					echo "named-checkzone - zone inverse :"
					named-checkzone $zone_directe /var/cache/bind/db."$zone_inverse".inv
					echo

					;;

				4)
					echo -e "$bleu------------------------------------------------------$normal"
					echo -e "$bleu      Configuration d'un redirecteur conditionnel     $normal"
					echo -e "$bleu------------------------------------------------------$normal"
					echo 
					echo -n "entrer le nom de la zone qui est concerné :"
					echo -n ""
					read zone
					echo 
					echo -n "entrer l'IP du serveur qui réolvera les noms d'hôte de cette zone :"
					echo -n ""
					read redirecteur_conditionnel
					echo 
					echo "
zone $zone {
	type forard;
	forwrd only;
	forwarders { $redirecteur_conditionnel; };" >> /etc/bind/named.conf.local

					;;

				5)
					echo -e "$bleu-----------------------------------------------------------------$normal"
					echo -e "$bleu      Déclarer ce serveur en tant que serveur DNS secondaire     $normal"
					echo -e "$bleu-----------------------------------------------------------------$normal"
					echo

					echo "entrer l'IP du serveur DNS primaire"
					echo -n ""
					rean ip
					echo 
					echo "entrez le nom de la zone directe du serveur DNS primaire"
					echo "Le nom du fichier de zone sera le même que celui du serveur DNS primaire"
					echo -n ""
					read zone_directe
					echo 
					echo "Entrer le nom de la zone inverse sans le .in-addr.arpa qui a été renseigné sur le serveur DNS primaire"
					echo "(ex : pour le réseau 192.168.10.0/24, entrez 192.168.10, le nom du fichier de configuration de la zone inverse sera db.192.168.10.inv"
					echo "et la zone inverse sera 10.168.192.in-addr.arpa"
					echo -n ""
					read zone_inverse
					echo 
					echo -e "
zone \"$zone_directe\" {
	type slave;
	masters { $ip; };
	file "/var/cache/bind/db.$zone_directe";
	allow-query { any; };
};

zone \""$zone_inverse".in-addr.arpa {
	type slave;
	masters { $ip; };
	file "/var/cache/bind/db."$zone_inverse".inv";
	allow-query { any; };
};" >> /etc/bind/named.conf.local

					;;
					
				
				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;

########8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-8-
		8)
			while :
			do
				echo -e ""$bleu"1 : Vérification serveur LAMP"
				echo -e "2 : Configuration serveur LAMP"
				echo -e "3 : Pré-configuration d'un site web"
				echo -e "4 : Générer un certificat pour la connexion https"
				echo -e "5 : Générer un certificat pki Mircosoft$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in



				1)
					echo -e "$bleu------------------------------------$normal"
					echo -e "$bleu      Vérification serveur LAMP     $normal"
					echo -e "$bleu------------------------------------$normal"
					echo
					if (apt list --installed | grep apache2/stable)
					then
						echo
						echo -e ""$vert"apache est installé$normal"

					else
						echo
						echo -e ""$rouge"Apache n'est pas installé$normal"
					fi

					if (apt list --installed | grep php/stable)
					then
						echo
						echo -e ""$vert"PHP est installé$normal"

					else
						echo
						echo -e ""$rouge"PHP n'est pas installé$normal"
					fi

					if (apt list --installed | grep mariadb-server/stable)
					then
						echo
						echo -e ""$vert"MariaDB est installé$normal"

					else
						echo
						echo -e ""$rouge"MariaDB n'est pas installé$normal"
					fi
					echo 
					read -n1 -r -p "Appuyer sur entrée pour continuer"
					clear
					;;

				2)
					echo -e "$bleu-------------------------------------$normal"
					echo -e "$bleu      Installation serveur LAMP      $normal"
					echo -e "$bleu-------------------------------------$normal"
					echo
					echo -e ""$orange"Installtion et configuration apache2$normal"
					echo -e ""$orange"------------------------------------$normal"
					echo
					if (apt list --installed | grep apache2/stable)
					then
						echo
						echo "apache2 est déjà installé"

					else
						echo "installation avec apt install apache2"
						apt install apache2 -y
					
						if_erreur

					

						echo -e ""$orange"--------------------- Installation terminée ------------------$normal"
						echo 
						
						# Lancement d'apache au démarrage de Debian
						systemctl enable apache2

						# ----- activation de modules apache avec a2enmod
						# module 'rewrite' pour la réécriture d'url
						a2enmod rewrite

						# module 'deflate' pour la gestion de la compression pour utiliser la mise en cache des pages sur le site
						a2enmod deflate

						# module 'headers' afin de pouvoir agir sur les en-têtes HTTP
						a2enmod headers

						# module 'ssl' pour gérer les certificats SSL (pour HTTPS)
						a2enmod ssl

						systemctl restart apache2
					fi

					sleep 2
				
					echo 
					echo -e ""$orange"Installtion de PHP$normal"
					echo -e ""$orange"------------------$normal"
					echo
					
					liste_apt=( "php" "php-common" "php-mysql" "php-zip" "php-gd" "php-mbstring" "php-curl" "php-xml" "php-pear" "php-bcmath" )

					for pkg in ${liste_apt[@]}
					do
						if (apt list --installed | grep $pkg/stable 1>/dev/null)
						then
							echo
							echo "$pkg est déjà installé"
						else
							apt install -y $pkg

							if_erreur

							echo 
							echo -e ""$orange"--------------------- Installation de $pkg terminée ------------------$normal"
							sleep 2	 
						fi
					done


						# création d'un fichier afin de tester & consulter la configuration apache et PHP
						# accessible via http://<IP du serveur LAMP>/phpinfo.php
						# à rendre inconsultable une fois la configuration vérifiée
						echo "
<?php
phpinfo();
?>" > /var/www/html/phpinfo.php

					echo -e ""$orange"Installation et configuration de MariaDB$normal"
					echo -e ""$orange"---------------------------------------$normal"
					echo
					if (apt list --installed | grep mariadb-server/stable)
					then
						echo
						echo "mariadb est déjà installé"

					else
						echo "installation avec apt install mariadb-server"
						apt install -y mariadb-server
						
						if_erreur


						echo -e ""$orange"--------------------- Installation terminée ------------------$normal"
						echo
						echo
						echo 
						echo -e ""$orange"------------ Configuration de la sécurité mariaDB ------------$normal"
						echo 

						# mariadb-secure-installation : script contenu dans l'installation pour sécuriser un minimum MariaDB
							# définir un mot de passe pour le compte "root" de MariaDB
							# empêcher les connexions distantes sur votre instance à l'aide du compte "root"
							# empêcher les connexions anonymes et supprimer la base de test.
									# Switch to unix_socket authentication [Y/n] n
									# Change the root password? [Y/n] n
									# Remove anonymous users? [Y/n] y
									# Disallow root login remotely? [Y/n] y
									# Remove test database and access to it? [Y/n] y
									# Reload privilege tables now? [Y/n] y
						mariadb-secure-installation

						sleep 1

						systemctl restart mariadb
					fi
					;;


				3)

					echo -e "$bleu---------------------------------$normal"
					echo -e "$bleu      Configurer un site web     $normal"
					echo -e "$bleu---------------------------------$normal"
					echo

					echo "entrer le nom du site, format FQDN, exemple : monsite.domaine.fr"
					echo "Le nom du dossier dans /var/www/ sera 001-monsite.domaine.fr"
					echo "le chiffre 001 sera incrémenté pour chaque site créé :"
					echo -n ""
					read nom
					echo 
					

					nb=$(ls /var/www/ | wc -l)
					a=$(echo "${#nb}")

					if [ $a == 1 ]
					then
						b="00$nb"

					elif [ $a == 2 ]
					then
						b="0$nb"
					fi

					mkdir /var/www/"$b"-"$nom"

					sleep 1

					echo -e "<!doctype html>
<html lang=\"fr\">
<head>
  <meta charset=\"utf-8\">
  <title>Titre de la page</title>
</head>
<body>
  ...
  Site test "$b"-$nom
  ...
</body>
</html>" > /var/www/"$b"-"$nom"/index.html

					sleep 1
					echo
					echo
				
					echo "1 : http"
					echo "2 : https"
					echo
					echo "veuillez choisir :"


					read optionmenu
					case $optionmenu in


						1)
		
							echo -e "<VirtualHost *:80> 
	DocumentRoot /var/www/"$b"-"$nom"
	ServerName "$nom" 
</VirtualHost>" > /etc/apache2/sites-available/"$b"-"$nom".conf
						;;



						2)

							echo -e "<VirtualHost *:443>
	DocumentRoot /var/www/"$b"-"$nom"
	ServerName "$nom"
	<directory /var/www/"$b"-"$nom">
		Options Indexes FollowSymLinks
	</directory>
	SSLEngine on 
	SSLCertificateKeyFile /etc/ssl/private/"$nom".key 
	SSLCertificateFile /etc/ssl/certs-auto/"$nom".cert 
	SSLProtocol all -SSLv3
</VirtualHost>" > /etc/apache2/sites-available/"$b"-"$nom".conf
						;;
						
						*)
							echo "erreur de frappe"
							read -n1 -r -p "Appuyer sur entrée pour recommencer"
							clear
							;;
					esac


					sleep 1

					# Activation du site
					a2ensite "$b"-"$nom".conf

					sleep 1

					apache2ctl graceful

					;;


				4)

					echo -e "$bleu--------------------------------------------$normal"
					echo -e "$bleu      Générer un certificat auto-signé      $normal"
					echo -e "$bleu--------------------------------------------$normal"
					echo
					# Le Certificat auto-signé sert de test pour l'authentification https.
					# Il faut préférer par la suite mettre en place un certificat basé sur une authorité de certification
					
					# Création de l'arborescence de stockage des certificats
					mkdir /etc/ssl/certs/java
					mkdir /etc/ssl/{certs-auto,reqs}


					echo "entrer le nom du site, format FQDN, exemple : monsite.domaine.fr"
					echo -n ""
					read nom
					echo
					# Création de la clé privé 
					openssl genrsa -out /etc/ssl/private/"$nom".key 2048

					# Création de la demande de signature
					openssl req -new -key /etc/ssl/private/"$nom".key -out /etc/ssl/reqs/"$nom".csr -sha256

					# Création du certificat auto-signé
					openssl x509 -req -days 36500 -in /etc/ssl/reqs/"$nom".csr -signkey /etc/ssl/private/"$nom".key -out /etc/ssl/certs-auto/"$nom".cert -sha256
	
					# Activation du module ssl
					a2enmod ssl

					apache2ctl graceful
					;;

				5)
					echo -e "$bleu-----------------------------------------------$normal"
					echo -e "$bleu      Générer un certificat pki Mircosoft      $normal"
					echo -e "$bleu-----------------------------------------------$normal"
					echo
					# controle du certiricat via le serveur AD Windows Serveur ou le rôle AD CS (service de certificat Active Directory - pki) est installé
					mkdir /etc/ssl/pki
					mkdir /etc/ssl/pki/{CA,Private,Reqs,Certificate}

					echo "entrer le nom du site, format FQDN, exemple : monsite.domaine.fr"
					echo -n ""
					read nom
					echo

					# Création de la clé privé 
					openssl genrsa -out /etc/ssl/pki/Private/"$nom".key 2048

					# Création de la demande de certificat
					openssl req -new -sha256 -key /etc/ssl/pki/Private/"$nom".key -out /etc/ssl/pki/Reqs/"$nom".csr

					# Deamnde de certificat a copier dans le navigateur du client (http://ServerAD.domaine.tld/certsrv)
					cat /etc/ssl/pki/Reqs/"$nom".csr

					;;


				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;



		9)

			while :
			do
				echo -e ""$bleu"1 : Installation Centreon"
				echo -e "2 : Configuration de l'agent SNMP sur les machines à superviser"
				echo -e "3 : Configuration de l'agent NRPE sur les machines à superviser"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in

				1)
					echo -e "$bleu-----------------------------------$normal"
					echo -e "$bleu      Installation de Centreon     $normal"
					echo -e "$bleu-----------------------------------$normal"
					echo
					
					# Source : https://docs.centreon.com/fr/docs/installation/installation-of-a-central-server/using-packages/

					# désactivation du pare-feu le temps de l'installation

					if systemctl is-active --quiet firewalld
					then
						systemctl stop firewalld
						systemctl disable firewalld
						a=1
					else
						a=0
					fi
						

					# Installation des dépôts

					# les dépendances
					if apt update -y | grep -E "Erreur|Impossible"
					then
						echo 
						echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
						echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

						exit 4
					fi



					apt install lsb-release ca-certificates apt-transport-https software-properties-common wget gnupg2

					if_erreur


					# Installer le dépôt Sury APT pour PHP 8.1
					echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list

					if_erreur

					# Importer la clé du dépôt
					wget -O- https://packages.sury.org/php/apt.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/php.gpg  > /dev/null 2>&1

					if_erreur

					apt update

					# Installation de MariaDB 10.5
					curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --os-type=debian --os-version=11 --mariadb-server-version="mariadb-10.5"
					
					if_erreur

					# installation du paquet centreon-release, qui fournira le fichier du dépôt pour l'installation de centreon
					echo "deb https://apt.centreon.com/repository/22.10/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/centreon.list

					if_erreur

					# Importer la clé deu dépôt
					wget -O- https://apt-key.centreon.com | gpg --dearmor | tee /etc/apt/trusted.gpg.d/centreon.gpg > /dev/null 2>&1
					
					if_erreur


					########## INSTALLATION & CONFIGURATION CENTREON ############

					# Installation avec base de donnée locale
					apt update
					apt install -y centreon

					if_erreur

					systemctl daemon-reload
					systemctl restart mariadb

					# Configuration
					# Définir le fuseau horaire de PHP

					# A FAIRE : Editez le fichier /etc/php/8.1/mods-available/centreon.ini et contrôlez le fuseau horaire.
					# Après avoir enregistré le fichier, redémarrez le service PHP-FPM avec systemctl restart php8.1-fpm
					# systemctl restart php8.1-fpm

					# Démarrage des services au démarrage du système
					systemctl enable php8.1-fpm apache2 centreon cbd centengine gorgoned centreontrapd snmpd snmptrapd

					# Configurer MariaDb pour le démarrage avec le système
					systemctl enable mariadb
					systemctl restart mariadb

					# Sécuriser la base de données
					mysql_secure_installation
					# Répondez oui à toutes les questions, sauf à "Disallow root login remotely ?".
					# Il est obligatoire de définir un mot de passe pour l'utilisateur root de la base de données. Ce mot de passe vous sera demandé pendant l'installation web.

					# Démarrez le serveur Apache
					systemctl start apache2

					# Pour terminer l'installation
					# Se connecter à l'interface web via http://<IP>/centreon et suivre les étapes
					# Source installation Web : https://docs.centreon.com/fr/docs/installation/web-and-post-installation/#web-installation

					# Réactivation du par-feu
					if [ $a = 1 ]
					then
						systemctl start firewalld
						systemctl enable firewalld
					fi

					read -n1 -r -p "Appuyer sur entrée pour terminer"
					clear
					;;


				2)

					echo -e "$bleu---------------------------------------$normal"
					echo -e "$bleu      Configuration du service SNMP    $normal"
					echo -e "$bleu---------------------------------------$normal"
					echo 

					liste_apt=( "snmp" "snmpd" )

					for pkg in ${liste_apt[@]}
						do
							if (apt list --installed | grep $pkg)
							then
								echo
								echo -e ""$orange"$pkg est déjà installé$normal"
								sleep 2

							else
								echo "installation avec apt install $pkg"
								
								if apt install $pkg -y | grep -E "Erreur|Impossible"
								then
									echo 
									echo -e ""$orange"Les dépots pour l'installation ne sont pas joignables$normal"
									echo -e ""$orange"La configuration réseau est incorrect ou le fichier /etc/apt/sources.list est erroné$normal"

									exit 4
								else
									if_erreur
								fi

								echo -e ""$orange"------------------------ Installation de $pkg terminée -------------------------$normal"
								sleep 2
							fi
						done

						sleep 1

						cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.save

						if [ -f /etc/snmp/snmpd.conf.save ]
						then

							echo "entrer le nom de la communauté"
							read -p "" community
							
							echo -e "
agentAddress udp:161

# map the community name \"public\" into a \"security name\"
#               sec.name        	Source          Community
com2sec         masecurite          default         $community

# map the security name sniper name into a group name
#               groupname       	SecurityModel           SecurityName
group           mongroupsecurite    v2c                     masecurite

# Create a view for us to let the grouyp have rights to :
#               Name           incl/excl               subtree         mask(optional)
view            nom            included                .0.3.6.1.4.1.2021.4
view            nom            included                .1.3.6.1.4.1.2021.10
view            nom            included                .1.3.6.1.2.1.25.3
view            nom            included                .1.3.6.1.2.1.25.2.1
view            nom            included                .1.3.6.1.2.1.25.2.3

# Grant the group read-only access to the mavue view
#               group   			context 	sec.model       sec.level       prefix  read    write   notif
access          mongroupsecurite    \"\"      	any     		noauth    		exact   truc    none    none" > /etc/snmp/snmpd.conf
						fi

					echo
					read -n1 -r -p "Appuyer sur entrée pour continuer"
					clear
					;;


				3)
					# Source : https://docs.centreon.com/fr/pp/integrations/plugin-packs/procedures/operatingsystems-linux-nrpe3/
					# Ajout de l'utilisateur centreon-engine user
					useradd --create-home centreon-engine
					# Installation de gpg
					apt install gpg
					# Ajout du dépôt Centreon
					wget -qO- https://apt-key.centreon.com | gpg --dearmor > /etc/apt/trusted.gpg.d/centreon.gpg
					echo "deb https://apt.centreon.com/repository/22.10/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/centreon.list
					apt update
					# Installation de centreon-nrpe3-daemon
					apt install centreon-nrpe3-daemon centreon-plugin-operatingsystems-linux-local
					# Création du répertoire pour le cache du plugin
					mkdir -p /var/lib/centreon/centplugins/
					chown centreon-engine: /var/lib/centreon/centplugins/

					##Configuration de NRPE
					##Pour que le(s) poller(s) puisse(nt) superviser les hôtes, il est nécessaire d'adapter le paramètre allowed_hosts dans le fichier /etc/nrpe/centreon-nrpe3.cfg :

					##[...]
					## ALLOWED HOST ADDRESSES
					## This is an optional comma-delimited list of IP address or hostnames
					## that are allowed to talk to the NRPE daemon. Network addresses with a bit mask
					## (i.e. 192.168.1.0/24) are also supported. Hostname wildcards are not currently
					## supported.
					#allowed_hosts=127.0.0.1,::1
					#[...]

					systemctl restart centreon-nrpe3.service
					;;


				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;



		10)

			# dépendances nécessaires au bon fonctionnement de Docker
			apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common

			# ajouter le dépôt officiel de Docker à notre machine Debian afin de pouvoir récupérer les sources
			# récupération de la clé GPG qui nous permettra de valider les paquets récupérés depuis le dépôt Docker
			curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
			
			# ajout du dépôt Docker à la liste des sources de notre machine
			echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

			# mise à jour du cache des paquets pour prendre en compte les paquets de ce nouveau dépôt
			apt update -y

			# Installation de Docker
			apt install docker-ce docker-ce-cli containerd.io

			# Démarrer docker au démmarrage de la machine
			systemctl enable docker

			# Vérification du status du service docker
			systemctl status docker

			;;




########9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-9-
		11)

			while :
			do
				echo
				echo -e ""$bleu"1 : Pour l'utilisateur root"
				echo -e "2 : pour les autres utilisateurs$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in



				1)
			
					echo -e "$bleu----------------------------------$normal"
					echo -e "$bleu      Pour l'utilisateur root     $normal"
					echo -e "$bleu----------------------------------$normal"
					echo
					# pour l'utilisateur root
					echo -e "entrer le chemin complet du repertoire à ajouter sans \"/\" au début"
					echo "exemple : root/dossier"
					echo -n ""
					read rep
					echo -e "

export PATH=\"$PATH:/$rep\"" >> /root/.bashrc
					sleep 2
					# appliquer la modification sans redémarrer l'hôte
					. /root/.bashrc
					echo 
					echo -e ""$orange"------------- modification effectuée -------------$normal"
					echo
					read -n1 -r -p "Appuyer sur entrée pour continuer"
					clear
					;;

				2)
					echo -e "$bleu-----------------------------------$normal"
					echo -e "$bleu      Pour un autre utilisateur    $normal"
					echo -e "$bleu-----------------------------------$normal"
					echo
					# pour un autre utilisateur
					# lister les utilisateurs

					echo "utilisateurs présents :"
					echo "---------------------"
					echo
					user=$(getent passwd {1000..2000})
					a=1
					liste=()

					for line in $user
					do
						nom=$(echo $line | awk -F":" {'print $1'})

						echo "$a - $nom"
						
						((a=a+1))
						liste=("${liste[@]}" "$nom")

					done
					echo
					echo "entrer le chiffre correpondant à l'utilisateur choisi :"
					read -p "" chiffre


					((indice=$chiffre-1))

					login=${liste[$indice]}

					echo -e "entrer le chemin complet du repertoire à ajouter, sans \"/\" au début"
					echo "exemple : home/user/dossier"
					read -p "" rep

					echo -e "

export PATH=\"$PATH:/$rep\"" >> /home/$login/.bashrc
					sleep 2
					# appliquer la modification sans redémarrer l'hôte
					. /home/$login/.bashrc
					echo 
					echo -e ""$orange"------------- modification effectuée -------------$normal"
					echo
					read -n1 -r -p "Appuyer sur entrée pour continuer"
					clear
					;;

				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;

########10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-10-
		12)
			while :
			do
				echo -e ""$bleu"1 : Intégrer l'hôte au domaine"
				echo -e "2 : Sortir l'hôte du domaine$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in



				1)

					echo -e "$bleu--------------------------------------$normal"
					echo -e "$bleu      Intégrer l'hôte au domaine      $normal"
					echo -e "$bleu--------------------------------------$normal"
					echo

					apt install realmd sssd sssd-tools adcli krb5-user packagekit samba-common samba-common-bin samba-libs #resolvconf

					if_erreur

					if grep -v "session optional pam_mkhomedir.so" /etc/pam.d/common-session
					then
						echo "session optional pam_mkhomedir.so skel=/etc/skel umask=077" >> /etc/pam.d/common-session
					fi

					echo 
					echo "entrer le nom du domaine"
					echo -n ""
					read nom_domaine
					echo 
					echo
					echo "entrer le nom d'un compte autorisé à intégrer des hôtes au domaine"
					echo -n ""
					read admin
					echo
					# Vérification du domaine
					echo -e ""$vert"Vérification que le domaine est potentiellement joignable$normal"
					echo -e ""$vert"---------------------------------------------------------$normal"
					echo

					realm discover $nom_domaine
					echo

					if realm discover $nom_domaine |& grep "realm: No such realm found:"
					then
						echo
						echo -e ""$rouge"Le domaine n'est pas joignable$normal"
						echo
						echo "Le problème peut venir :"
						echo "	- d'une faute dans le nom de domaine"
						echo "	- d'une mauvaise connexion entre l'hôte et le controleur de domaine"
						echo "	- Le DNS est mal configuré sur l'hôte, vérifier le fichier /etc/resolv.conf"
						echo
						read -n1 -r -p "Appuyer sur entrée pour relancer le script"
						clear
						script
					else
						if realm join $nom_domaine -U $admin |& grep "realm: Already joined to this domain"
						then
							echo -e ""$orange"L'hôte est déjà intégré au domaine $nom_domaine$normal"
							echo
							read -n1 -r -p "Appuyer sur entrée pour relancer le script"
							clear
							script
						else
							echo
							echo -e ""$vert"Intégration au domaine $nom_domaine réussie$normal"
							echo
						fi
						echo
						echo -e ""$orange"Vérification post intégration$normal"
						echo -e ""$orange"-----------------------------$normal"
						echo
						if id $nom_domaine\\$admin |& grep "inexistant"
						then
							echo -e ""$rouge"Erreur lors de l'intégration au domaine $nom_domaine$normal"
							echo
						else
							echo -e ""$vert"Intégration au domaine $nom_domaine effectué$normal"
							echo
							read -n1 -r -p "Appuyer sur entrée pour redémarrer l'hôte"
							reboot
						fi
					fi

					;;

				2)

					echo -e "$bleu------------------------------------$normal"
					echo -e "$bleu      Sortir l'hôte du domaine      $normal"
					echo -e "$bleu------------------------------------$normal"
					echo
					echo 
					echo "entrer le nom du domaine"
					echo -n ""
					read nom_domaine
					echo 
					echo
					echo "entrer le nom d'un compte autorisé à sortir des hôtes du domaine"
					echo -n ""
					read admin
					echo
					a=$nom_domaine | awk -F"." '{print $1}'

					if id $nom_domaine\\$admin |& grep "inexistant"
					then
						echo "L'hôte n'est pas sur le domaine $nom_domaine"	 
					else
						realm leave $nom_domaine -U $a\\$admin
						echo
						read -n1 -r -p "Appuyer sur entrée pour redémarrer"
						reboot
					fi
					;;


				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;


########11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-11-
		13)
			echo -e "$bleu-------------------------------$normal"
			echo -e "$bleu      Installation de GLPI     $normal"
			echo -e "$bleu-------------------------------$normal"
			echo
			echo -e ""$orange"Installtion et configuration apache2$normal"
					echo -e ""$orange"------------------------------------$normal"
					echo
					if (apt list --installed | grep apache2/stable)
					then
						echo
						echo "apache2 est déjà installé"

					else
						echo "installation avec apt install apache2"
						apt install apache2 -y
					
						if_erreur
					

						echo -e ""$orange"--------------------- Installation terminée ------------------$normal"
					fi

						echo 
						# Lancement d'apache au démarrage de Debian
						systemctl enable apache2

						# ----- activation de modules apache avec a2enmod
						# module 'rewrite' pour la réécriture d'url
						a2enmod rewrite

						# module 'deflate' pour la gestion de la compression pour utiliser la mise en cache des pages sur le site
						a2enmod deflate

						# module 'headers' afin de pouvoir agir sur les en-têtes HTTP
						a2enmod headers

						# module 'ssl' pour gérer les certificats SSL (pour HTTPS)
						a2enmod ssl

						systemctl restart apache2

					sleep 2
				
					echo 
					echo -e ""$orange"Installtion de PHP$normal"
					echo -e ""$orange"------------------$normal"
					echo
					if (apt list --installed | grep php/stable)
					then
						echo
						echo "php est déjà installé"

					else
						echo "installation avec apt install php"
						apt install -y php php-mbstring php-curl php-gd php-mysql php-imap php-ldap php-xml php-apcu-bc php-xmlrpc php-cas php-intl php-zip php-bz2
					
						if_erreur

						echo -e ""$orange"--------------------- Installation terminée ------------------$normal"

					fi
						echo
						# création d'un fichier afin de tester & consulter la configuration apache et PHP
						# accessible via http://<IP du serveur LAMP>/phpinfo.php
						# à rendre inconsultable une fois la configuration vérifiée
						echo "
<?php
phpinfo();
?>" > /var/www/html/phpinfo.php
					

					echo -e ""$orange"Installation et configuration de MariaDB$normal"
					echo -e ""$orange"---------------------------------------$normal"
					echo
					if (apt list --installed | grep mariadb-server/stable)
					then
						echo
						echo "mariadb est déjà installé"

					else
						echo "installation avec apt install mariadb-server"
						apt install -y mariadb-server
				
						if_erreur

						echo -e ""$orange"--------------------- Installation terminée ------------------$normal"

						echo
						echo
						echo 
						echo -e ""$orange"------------ Configuration de la sécurité mariaDB ------------$normal"
						echo 

						# mariadb-secure-installation : script contenu dans l'installation pour sécuriser un minimum MariaDB
							# définir un mot de passe pour le compte "root" de MariaDB
							# empêcher les connexions distantes sur votre instance à l'aide du compte "root"
							# empêcher les connexions anonymes et supprimer la base de test.
									# Switch to unix_socket authentication [Y/n] n
									# Change the root password? [Y/n] n
									# Remove anonymous users? [Y/n] y
									# Disallow root login remotely? [Y/n] y
									# Remove test database and access to it? [Y/n] y
									# Reload privilege tables now? [Y/n] y
						mariadb-secure-installation

						sleep 1

						echo -e ""$orange"# Entrer le user root et son MDP pour mariadb : "
						echo
						read -p "# root_User : " -r root_USER
						read -p "# root_Pass : " -s root_PASS
						echo "##################################"
						echo
						echo -e ""$vert"Le nom de la base de donnée pour GLPI sera 'glpidb'$normal"
						echo
						echo 
						echo -e ""$vert"# Le nom de l'utilisateur glpi sera glpi_user$normal"
						echo 
						echo -e "Entrer le mot de passe désiré pour l'utilisateur 'glpi_user' : "
						echo
						read -p "# glpi_user_Pass : " -s glpi_user_PASS
						echo "##################################"
						echo 
						echo 
						echo -e ""$vert"CREATE DATABASE glpidb$normal"
						echo "CREATE DATABASE glpidb;" | mariadb -sN -u $root_USER -p$root_PASS
						echo 
						sleep 1
						echo -e ""$vert"CREATE USER 'glpi_user@localhost' IDENTIFIED BY$normal"
						echo "CREATE USER 'glpi_user'@'localhost' IDENTIFIED BY '$glpi_user_PASS';" | mariadb -sN -u $root_USER -p$root_PASS
						sleep 1
						echo 
						echo -e ""$vert"GRANT ALL PRIVILEGES ON glpidb.* to 'glpi_user'@'localhost'$normal"
						echo "GRANT ALL PRIVILEGES ON glpidb.* to 'glpi_user'@'localhost';" | mariadb -sN -u $root_USER -p$root_PASS
						sleep 1
						echo 
						echo -e ""$vert"FLUSH PRIVILEGES$normal"
						echo "FLUSH PRIVILEGES;" | mariadb -sN -u "$root_USER" -p"$root_PASS"
						sleep 1

						systemctl restart mariadb
					fi	

					# Installation de GLPI

					apt install curl -y

					cd /var/www/html

					# Récupération de la dernière version ###############################################################
					repo="glpi-project/glpi"  # Remplacez par le nom d'utilisateur et le nom du référentiel appropriés
					api_url="https://api.github.com/repos/$repo/releases/latest"

					# Effectuer une requête GET à l'API GitHub pour récupérer les informations de la dernière version
					response=$(curl -sSL "$api_url")

					# Extraire la version à partir de la réponse JSON
					latest_version=$(echo "$response" | grep -o '"tag_name": "[^"]*' | grep -o '[^"]*$')

					#####################################################################################################

					wget https://github.com/glpi-project/glpi/releases/download/$latest_version/glpi-"$latest_version".tgz
					#https://github.com/glpi-project/glpi/archive/refs/heads/10.0/bugfixes.zip
					tar -xf glpi-"$latest_version".tgz

					chown -R www-data /var/www/html/glpi

					read -n1 -r -p "Appuyer sur entrée pour continuer"
					;;
		

########13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-13-
		14)
			echo -e "$bleu-------------------------------------------------$normal"
			echo -e "$bleu      Intérroger une base de donnée mariadb      $normal"
			echo -e "$bleu-------------------------------------------------$normal"
			echo



			echo "# Entrer le user et le MDP pour mariadb : "
			echo
			read -p "# User : " -r DBUSER
			read -p "# Pass : " -s DBPASS
			echo "##################################"
			echo
			echo 
			echo -e ""$vert"utilisateurs mariadb présents :$normal"
			echo -e ""$vert"-----------------------------$normal"
			echo
			echo "SELECT user, Host FROM user;" | mariadb -sN -u "$DBUSER" -p"$DBPASS" mysql
			echo 
			echo 
			echo -e ""$vert"Base de données présentes :$normal"
			echo -e ""$vert"-------------------------$normal"
			echo
			echo "show databases;" | mariadb -sN -u "$DBUSER" -p"$DBPASS"
			echo
			echo "----------------------------------------------------------------"
			echo
			echo
			read -p "Voulez-vous consulter une base de données ? [o/n] : " -r reponse_base
			echo
			echo
			while [[ $reponse_base != "O" && $reponse_base != "o" && $reponse_base != "N" && $reponse_base != "n" ]]
				do
					echo "Merci de répondre par 'o' ou 'n'"
					echo 
					read -p "Voulez-vous consulter une base de données ? [o/n] : " -r reponse_base
					echo
				done


			if [ $reponse_base = "o" -o $reponse_base = "O" ]
			then
				echo "# Entrer le nom de la base de données pour afficher ses tables : "
				read -p "# Database : " -r DBNAME
				echo
				echo -e ""$vert"Tables présente dans la base $DBNAME$normal"
				echo -e ""$vert"------------------------------------$normal"
				echo
				echo "show tables;" | mariadb -sN -u "$DBUSER" -p"$DBPASS" "$DBNAME"
				echo
				echo 
				read -p "Voulez-vous consulter une table de cette base de données ? [o/n] : " -r reponse_table
				echo

				while [[ $reponse_table != "O" && $reponse_table != "o" && $reponse_table != "N" && $reponse_table != "n" ]]
				do
					echo "Merci de répondre par 'o' ou 'n'"
					echo 
					read -p "Voulez-vous consulter une table de cette base de données ? [o/n] : " -r reponse_table
					echo
				done

				if [ $reponse_table = "o" -o $reponse_table = "O" ]
				then
					read -p "# Entrer le nom de la table à consulter : " -r nom_table
					echo 
					echo "SELECT * FROM "$nom_table";" | mariadb -sN -u "$DBUSER" -p"$DBPASS" "$DBNAME"
					echo 
					read -n1 -r -p "Appuyer sur entrée pour continuer"
				fi
			fi

			echo 
			read -n1 -r -p "FIN du script"
			;;

####################################################################################
		15)

			while :
			do
				echo -e ""$bleu"1 : Configurer un serveur Syslog"
				echo -e "2 : Paramétrer un client pour la centralisation des logs vers le serveur$normal"
				echo -e ""$rouge"q : quitter$normal"
				echo
				echo "veuillez choisir :"


				read optionmenu
				case $optionmenu in



				1)
					echo -e "$bleu---------------------------------------$normal"
					echo -e "$bleu      Configurer un serveur syslog     $normal"
					echo -e "$bleu---------------------------------------$normal"
					echo
					echo
					echo -e ""$orange"Installation et configuration de Rsyslog$normal"
							echo -e ""$orange"---------------------------------------$normal"
							echo
							if (apt list --installed | grep rsyslog/stable)
							then
								echo
								echo "rsyslog est déjà installé"

							else
								echo "installation avec apt install rsyslog"
								apt install -y rsyslog
							
								if_erreur

								echo -e ""$orange"--------------------- Installation de rsyslog terminée ------------------$normal"
							fi

							sed -i 's/#module(load="imudp")/module(load="imudp")/g' /etc/rsyslog.conf
							sed -i 's/#input(type="imudp" port="514")/input(type="imudp" port="514")/g' /etc/rsyslog.conf

							systemctl restart rsyslog

							echo -e ""orange"Vérification de l'écoute du port 514 UDP"
							echo -e ""orange"----------------------------------------$normal"
							echo
							netstat -npul
							echo

							read -n1 -r -p "Appuyer sur entrée pour continuer..."

							clear
							;;

				2)
					echo -e "$bleu--------------------------------------------------------------------------------------"
					echo -e "$bleu|      Paramétrer un client pour la centralisation des logs vers le serveur syslog   |"
					echo -e "$bleu--------------------------------------------------------------------------------------$normal"
					echo
					echo
					echo -n "Adresse IP du serveur Syslog : "
					read ip_serveur
					echo
					echo
					echo -e ""$orange"Installation et configuration de Rsyslog$normal"
							echo -e ""$orange"---------------------------------------$normal"
							echo
							if (apt list --installed | grep rsyslog/stable)
							then
								echo
								echo "rsyslog est déjà installé"

							else
								echo "installation avec apt install rsyslog"
								apt install -y rsyslog
							
								if_erreur

								echo -e ""$orange"--------------------- Installation de rsyslog terminée ------------------$normal"
							fi

					echo "
*.* @$ip_serveur:514" >> /etc/rsyslog.conf
					echo
					echo
					echo -e ""$orange"--------------------- La configuration est terminée ------------------$normal"
					echo
					echo
							;;


				[qQ])
					clear
					script
					;;


				*)
					echo "erreur de frappe"
					read -n1 -r -p "Appuyer sur entrée pour recommencer"
					clear
					;;
				esac
			done
			;;


####################################################################################
		#13)
			#echo -e "$bleu---------------------------------$normal"
			#echo -e "$bleu      Installation logiciels     $normal"
			#echo -e "$bleu---------------------------------$normal"
			#echo
			# téléchargement des packages "secours" en local 
			#apt download isc-dhcp-server isc-dhcp-relay bind9 tree vim

			# Installation des packages
			#apt install tree vim nmap -y
			#;;

####################################################################################

		[qQ])
			clear
			exit
			;;


		*)
			echo "erreur de frappe"
			read -n1 -r -p "Appuyer sur entrée pour recommencer"
			clear
			;;
			esac

	done
}

script |& tee -a /var/log/Conf_Post_Install.log

#################### Fin Script ###################