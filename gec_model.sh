#!/usr/bin/env bash
set -e
set -u

if [ $# -ne 3 ]; then
  echo "usage: python generate.sh <device> <exp> <result>" 1>&2
  exit 1
fi

DEVICE=$1
EXP=$2
RESULT=$3

# TEST_PREF='naist_clean_char'
TEST_PREF='lang8_char.dev'

EPOCH='_last'
MODEL_PATH="out/models/models${EXP}/checkpoint${EPOCH}.pt"
OPTION_FILE='option_files/exp.txt'
TEST_DATA="data/${TEST_PREF}.src"
DATA_RAW="out/data_raw/naist_clean_char"
SAVE_DIR="out/results/result${EXP}/${TEST_PREF}/${RESULT}"
SAVE_FILE="output${EPOCH}.char.txt"
OUTPUT_M2_FILE="m2score${EPOCH}.char.txt"
KENLM_DATA='/lab/ogawa/tools/kenlm/data/bccwj_clean2_char/bccwj_clean2_char.4gram.binary'
KENLM_WEIGHT=0.0

mkdir -p $SAVE_DIR


CUDA_VISIBLE_DEVICES=$DEVICE python gec_model.py \
  --model-path $MODEL_PATH \
  --data-raw $DATA_RAW \
  --option-file $OPTION_FILE \
  --test-data $TEST_DATA \
  --save-dir $SAVE_DIR \
  --save-file $SAVE_FILE \
  --kenlm-data $KENLM_DATA \
  --kenlm-weight $KENLM_WEIGHT

echo "| calc M2score"
python2 ./gec_scripts/m2scorer/m2scorer -v ${SAVE_DIR}/${SAVE_FILE} data/${TEST_PREF}.m2 > ${SAVE_DIR}/${OUTPUT_M2_FILE}
tail -n 3 ${SAVE_DIR}/${OUTPUT_M2_FILE}

python /lab/ogawa/scripts/slack/send_slack_message.py -m "[${HOSTNAME}] Finish gec_model"
