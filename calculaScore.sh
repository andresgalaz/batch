#!/bin/sh
if [ "$1" ] ; then
	WSAPI_AMBIENTE="$1"
	export WSAPI_AMBIENTE
fi
if [ ! "$WSAPI_AMBIENTE" ] ; then
	echo "No existe variable de ambiente WSAPI_AMBIENTE"
	exit 1
fi
if [ "$WSAPI_AMBIENTE" = "DESA" ] ; then
	BASE_DATOS=score_desa
elif [ "$WSAPI_AMBIENTE" = "TEST" ] ; then
	BASE_DATOS=score
	DIR_PROCESO=/home/ubuntu/migraObservations
	PASSWORD=snapcar
elif [ "$WSAPI_AMBIENTE" = "PROD" ] ; then
	BASE_DATOS=score
	DIR_PROCESO=/home/ubuntu/app_score/migraObservations
	PASSWORD=oycobe
else
	echo "Ambiente WSAPI_AMBIENTE=$WSAPI_AMBIENTE, desconocido"
	exit 1
fi

if ps -fe | grep -v grep | grep node | grep MIGRA_OBS ; then
	echo "El proceso ya está corriendo"
	exit 1
fi

echo '-----------------------------'
echo "| WSAPI_AMBIENTE = $WSAPI_AMBIENTE"
echo '-----------------------------'
echo
echo '-----------------------------'
echo '|  Migra procesos' $(date)
echo '-----------------------------'
cd $DIR_PROCESO
# MIGRA_OBS se usa solo para identificarlo dentro de los procesos de UNIX
# no tiene uso dentro del proceso.js
node proceso.js MIGRA_OBS

echo Migra Utlima Sincronización y Cálcula Fuerza G $(date),  WSAPI_AMBIENTE = $WSAPI_AMBIENTE
# mysql -v -v -v --user=snapcar --password=$PASSWORD --database=$BASE_DATOS --table << EOF_SQL
mysql --login-path=batchlocal -v -v -v --database=$BASE_DATOS --table << EOF_SQL
call prMigraUltimaSincro();
call prMigraValorG( DATE(NOW()) - INTERVAL 1 MONTH );
EOF_SQL

echo Fin proceso $(date),  WSAPI_AMBIENTE = $WSAPI_AMBIENTE
echo
