#!/bin/sh
if [ "$1" ] ; then
	WSAPI_AMBIENTE="$1"
	export WSAPI_AMBIENTE
fi
if [ ! "$WSAPI_AMBIENTE" ] ; then
	echo "No existe variable de ambiente WSAPI_AMBIENTE"
	exit 1
fi
echo '-----------------------------'
echo "| WSAPI_AMBIENTE = $WSAPI_AMBIENTE"
echo '-----------------------------'
echo
echo '-----------------------------'
echo '|  Migra procesos'
echo '-----------------------------'
cd /home/ubuntu/migraObservations
node proceso.js
echo '-----------------------------'
echo '|  Calcula Puntaje Mes'
echo '-----------------------------'
FECHA=$(date +'%Y-%m-%d')
mysql  --user=snapcar --password=snapcar --database=score --table << EOF
call calculaScoreMes('$FECHA');
call calculaScoreMesConductor('$FECHA');
call calculaScoreMesViaje('$FECHA');
EOF
