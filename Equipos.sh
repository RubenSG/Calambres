#!/bin/sh

#Autor: Rubén S.G.
#Fecha: 05/10/2013
#descripción: Muestra los equipos que estan conectados a la red, mediante la ip.

if [ -a "~/.tmp" ] && [ -d"~/.tmp" ]
	then
	mkdir ~/.tmp
else
		if [ -a "~/.tmp/temip.tmp" ] && [ -f "~/.tmp/temip.tmp" ]  #si el fichero existe y si es un archivo.
			then
			rm ~/.tmp/temip.tmp #borramos el archivo
		else
				ifconfig | grep "broadcast *.*.*.*" > ~/.tmp/temip.tmp #creamos el archivo.
				ip=`cat -A ~/.tmp/temip.tmp | tr -s " " "\n" | tail -15c | head -c 10 |tr "%" " "` #obtenemos la ip de difusión, ya que sabemos fijo que termina en 255.
				rm ~/.tmp/temip.tmp
			fi
fi
#Comprovamos que exista el fichero
if [ -a "~/.tmp/temip.tmp" ] && [ -f "~/.tmp/temip.tmp" ]
	then
	rm ~/.tmp/ping.tmp
else
touch ~/.tmp/ping.tmp
fi

for (( contar=1; contar<254 ; contar++ )) #creamos un bucle que recorre todas las ip's de la red.
do
	ping -c 1 $ip$contar >> ~/.tmp/ping.tmp & #realizamos in ping a cada maquina

done

if [ -a "~/.tmp/temip.tmp" ] && [ -f "~/.tmp/temip.tmp" ]
	then
	rm ~/.tmp/pingf.tmp
else
cat ~/.tmp/ping.tmp |grep "ttl=" > ~/.tmp/pingf.tmp
rm ~/.tmp/ping.tmp
fi
cat ~/.tmp/pingf.tmp
