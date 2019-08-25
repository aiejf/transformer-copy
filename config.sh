#!/usr/bin/env bash

device=0
if [ $# -ge 1 ]; then
    device=$1
fi

exp=''
if [ $# -ge 2 ]; then
    exp=$2
fi

# DATA='data' # input dir
# DATA_ART='data_art' # artificial data dir
# OUT='out' # output dir
# CORPUS=$DATA/train_1b.tgt  # monolingual corpus for generate artificial data
DATA='data_ja'
DATA_ART='data_ja_art'
OUT='out_ja'
CORPUS_NAME='bccwj1k.tgt'
TRAIN_PREF='lang8_unidic.train'
VALID_PREF='lang8_unidic.dev'

CORPUS=$DATA/$CORPUS_NAME
TRAIN_PREF=$DATA/$TRAIN_PREF
VALID_PREF=$DATA/$VALID_PREF

mkdir $DATA_ART

DATA_BIN=$OUT/data_bin
DATA_RAW=$OUT/data_raw
mkdir -p $DATA_BIN
mkdir -p $DATA_RAW

MODELS=$OUT/models$exp
RESULT=$OUT/result$exp
mkdir -p $MODELS
mkdir -p $RESULT
