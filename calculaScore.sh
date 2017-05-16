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

echo '-----------------------------'
echo "| WSAPI_AMBIENTE = $WSAPI_AMBIENTE"
echo '-----------------------------'
echo
echo '-----------------------------'
echo '|  Migra procesos'
echo '-----------------------------'
cd /home/ubuntu/app_score/migraObservations
node proceso.js
#
# Ya no hace falta correr este procesos dado que se ejecutan en proceso.js
# usando el procedmiento prMigraEventos
#
# echo '-----------------------------'
# echo '|  Calcula Puntaje Mes'
# echo '-----------------------------'
# FECHA=$(date +'%Y-%m-%d')
# mysql  --user=snapcar --password=snapcar --database=$BASE_DATOS --table << EOF
# call calculaScoreMes('$FECHA');
# call calculaScoreMesConductor('$FECHA');
# call calculaScoreMesViaje('$FECHA');
# EOF
