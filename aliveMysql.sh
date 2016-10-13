#!/bin/sh

# Se posiciona en la ruta donde está la SHELL
RUTA=`dirname "$0"`
if [ $RUTA != "." ] ; then
    cd $RUTA
fi

ERR=tmpFile.txt
curl 'http://localhost:8080/wappCar/do/bsh/aliveMysql' --data 'prm_dataSource=snapcar' >> batch_aliveMysql.log 2>$ERR
(
	echo 
	cat $ERR
	echo '=================================================================='
) >> batch_aliveMysql.log
rm $ERR
