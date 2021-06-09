#!/bin/bash

#
# efoのRDFファイルをロードする
#


# プロパティ
WORK_DIR=/work
DATA_DIR=/data
FORCE_CONVERT=0

# オプション解析
while getopts fP: OPT
  do
   case $OPT in
     f)  FORCE_CONVERT=1
   ;;
   esac
  done
shift  $(($OPTIND - 1))


cd ${WORK_DIR}
# versionの確認
version=`curl -L "http://www.ebi.ac.uk/ols/api/ontologies/efo" | jq '.config | .version'`
file_url=`curl -L "http://www.ebi.ac.uk/ols/api/ontologies/efo" | jq '.config | .id' | sed "s/\"//g"` 


# 前回ファイルのバージョンが記載されたファイルが存在する場合
if [ -e efo.txt ] && [ $FORCE_CONVERT -eq 0 ] ; then 
  before_version=`cat efo.txt`
  # versionの更新がなければ、その旨を出力し正常終了する
  if [ "${before_version}" = "${version}" ]; then 
    echo "RDF is already up to date"
    exit 0
  # versionに更新があればダウンロードする
  else
    cd ${DATA_DIR}
    wget -nc ${file_url}
    chmod 777 $(ls) 
    echo "${version}" > ${WORK_DIR}/efo.txt
    chmod 777 ${WORK_DIR}/efo.txt
  fi
# 前回ファイルがない場合(初回実行の場合)
else 
  
  # ファイルをダウンロードする
  cd ${DATA_DIR}
  wget -nc ${file_url}
  chmod 777 $(ls)
  echo "${version}" > ${WORK_DIR}/efo.txt
  chmod 777 ${WORK_DIR}/efo.txt
fi




