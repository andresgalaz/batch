#!/bin/sh
#     ----------------------------------------
#     |  Inicializa tScoreDia para hoy       |
#     |  Este proceso debe correr al iniciar |
#     |  el día solo una vez.                |
#     ----------------------------------------
# Autor: Andrés Galaz
# Fecha: 13/12/2016
# 

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
	PASSWORD=snapcar
elif [ "$WSAPI_AMBIENTE" = "PROD" ] ; then
	BASE_DATOS=score
	PASSWORD=oycobe
else
	echo "Ambiente WSAPI_AMBIENTE=$WSAPI_AMBIENTE, desconocido"
	exit 1
fi

FECHA=$(date +'%Y-%m-%d')
echo Inicio diario $FECHA,  WSAPI_AMBIENTE = $WSAPI_AMBIENTE
# mysql  --user=snapcar --password=$PASSWORD --database=$BASE_DATOS --table << EOF
mysql  --login-path=batchlocal --database=$BASE_DATOS --table << EOF
call prCalculaScoreDiaInicio('$FECHA');
EOF
