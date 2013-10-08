#!/bin/sh

#Autor: Rubén S.G.
#Fecha: 05/10/2013
#descripción: Muestra los equipos que estan conectados a la red, mediante la ip.

clear #limpiamos la pantalla


if [ -a "/home/$USER/.tmp/" ] && [ -d "/home/$USER/.tmp/" ]
	then
		echo -e "\n"
	else
		mkdir ~/.tmp
		echo -e "\n Creado directorio Temporal \n"
fi


if [ -e "/home/$USER/.tmp/temip.tmp" ] && [ -f "/home/$USER/.tmp/temip.tmp" ]  #si el fichero existe y si es un archivo.
	then
		rm /home/$USER/.tmp/temip.tmp #borramos el archivo
		echo "borrado archivo tempi.tmp temporal"
	else
		ifconfig | grep "inet *.*.*.*" > ~/.tmp/temip.tmp #creamos el archivo.
		tuip=`cat -A ~/.tmp/temip.tmp | tr -s " " "\n" | head -19c |tr "inet" " "`
		ip=`cat -A ~/.tmp/temip.tmp | tr -s " " "\n" | head -16c |tr "inet" " "` #obtenemos la ip, ya que sabemos fijo que termina en 255.
		rm ~/.tmp/temip.tmp
fi

#Comprovamos que exista el fichero
if [ -a "/home/$USER/.tmp/temip.tmp" ] && [ -f "~/home/$USER/.tmp/temip.tmp" ]
	then
	rm ~/.tmp/ping.tmp
else
	touch ~/.tmp/ping.tmp #creo un archivo vacio.
fi

for (( contar=1; contar<254 ; contar++ )) #creamos un bucle que recorre todas las ip's de la red.
	do
		ping -c 1 $ip$contar >> ~/.tmp/ping.tmp & #realizamos in ping a cada maquina
done


if [ -a "/home/$USER/.tmp/temip.tmp" ] && [ -f "/home/$USER/.tmp/temip.tmp" ]
	then
		rm ~/.tmp/pingf.tmp
	else
		cat ~/.tmp/ping.tmp |grep "ttl=" > ~/.tmp/pingf.tmp
		rm ~/.tmp/ping.tmp
fi

echo -e "Tu Ip es: $tuip \n\n"

cat ~/.tmp/pingf.tmp
