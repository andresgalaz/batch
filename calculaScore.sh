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
elif [ "$WSAPI_AMBIENTE" = "PROD" ] ; then
	BASE_DATOS=score
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
cd /home/ubuntu/app_score/migraObservations
# MIGRA_OBS se usa solo para identificarlo detrno de los procesos de UNIX
# no tiene uso dentro del proceso.js
node proceso.js MIGRA_OBS

# Calcula fuerza G
echo Inicio Calcula fuerza G $(date)
mysql  --table -v -v -v  --user=snapcar --password=oycobe --database=$BASE_DATOS --table << EOF
call prMigraValorG( DATE(NOW()) - INTERVAL 1 MONTH );
EOF

echo Fin proceso $(date)
echo
