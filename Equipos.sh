
#!/bin/sh

#Autor: Rubén S.G.
#Fecha: 05/10/2013
#descripción: Muestra los equipos que estan conectados a la red, mediante la ip.

clear #limpiamos la pantalla



#Colores de el sistema Bash
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

fin='\e[0m';
# finde colores


if [ -a "/home/$USER/.tmp/" ] && [ -d "/home/$USER/.tmp/" ]
	then
		echo -e "\n"
	else
		mkdir ~/.tmp
		echo -e "\nCreado directorio Temporal \n"
fi


if [ -e "/home/$USER/.tmp/temip.tmp" ] && [ -f "/home/$USER/.tmp/temip.tmp" ]  #si el fichero existe y si es un archivo.
	then
		rm /home/$USER/.tmp/temip.tmp #borramos el archivo
		echo "borrado archivo tempi.tmp temporal"
	else
		ifconfig | grep "inet *.*.*.*" > ~/.tmp/temip.tmp #creamos el archivo.
		tuip=`cat -A ~/.tmp/temip.tmp | tr -s " " "\n" | head -19c |tr "inet" " "`
		ip=`cat -A ~/.tmp/temip.tmp | tr -s " " "\n" | head -16c |tr "inet" " "` #obtenemos la ip de difusión, ya que sabemos fijo que termina en 255.
		rm ~/.tmp/temip.tmp
fi

#Comprovamos que exista el fichero
if [ -a "/home/$USER/.tmp/temip.tmp" ] && [ -f "~/home/$USER/.tmp/temip.tmp" ]
	then
	rm ~/.tmp/ping.tmp
else
	touch ~/.tmp/ping.tmp #creo un archivo vacio.
fi

#Obtenemos las tarjetas de red conectadas al equipo.
if [ -a "/home/$USER/.tmp/tarjetas.tmp" ] &&[ -f "/home/$USER/.tmp/tarjetas.tmp" ]
	then
	rm /home/$USER/.tmp/tarjetas.tmp
	ifconfig |tr " " ":" | cut -d: -f1 | tr "\n" " " | tr "\n" "\a" | tr "%" "\b" | unexpand -a > ~/.tmp/tarjetas.tmp
else
	ifconfig |tr " " ":" | cut -d: -f1 | tr "\n" " " | tr "\n" "\a" | tr "%" "\b" | unexpand -a > ~/.tmp/tarjetas.tmp
fi

#Hacemos un  ping a toda la red
for (( contar=1; contar<=254 ; contar++ )) #creamos un bucle que recorre todas las ip's de la red.
	do
		ping -c 1 $ip$contar >> ~/.tmp/ping.tmp & #realizamos in ping a cada maquina
done


if [ -a "/home/$USER/.tmp/temip.tmp" ] && [ -f "/home/$USER/.tmp/temip.tmp" ]
	then
		rm ~/.tmp/pingf.tmp
	else
		cat ~/.tmp/ping.tmp |grep "ttl=" > ~/.tmp/pingf.tmp 
fi



if [ -a "/home/$USER/.tmp/pingf.tmp" ] && [ -f "/home/$USER/.tmp/pingf.tmp" ]
	then
		rm ~/.tmp/ping.tmp
		if [ -a "/home/$USER/.tmp/soloip.tmp" ] && [ -f "/home/$USER/.tmp/soloip.tmp" ]
			then
				rm ~/.tmp/soloip.tmp
				touch ~/.tmp/soloip.tmp
		fi
		cat -A ~/.tmp/pingf.tmp | tr -s " " ":" | cut -d: -f4 >> ~/.tmp/soloip.tmp
		rm ~/.tmp/pingf.tmp
fi

catidaequipos=`wc -l ~/.tmp/soloip.tmp | cut -d" " -f1`


echo -e "Tarjetas de Red: "$BRed`cat ~/.tmp/tarjetas.tmp`$fin"\n"
echo -e "\nTu Ip es :"$BRed$tuip$fin"\n";
echo -e "Equipos en la Red: "$URed$catidaequipos$fin"\n";
cat ~/.tmp/soloip.tmp
echo -e "\n";
