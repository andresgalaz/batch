#!/bin/sh
echo
echo
echo '--------------'
echo 'Migra procesos'
echo '--------------'
cd /home/ubuntu/migraObservations
node proceso.js
echo '-------------------'
echo 'Calcula Puntaje Mes'
echo '-------------------'
FECHA=$(date +'%Y-%m-%d')
mysql  --user=snapcar --password=snapcar --database=score --table << EOF
call calculaScoreMes('$FECHA');
call calculaScoreMesConductor('$FECHA');
call calculaScoreMesViaje('$FECHA');
EOF
