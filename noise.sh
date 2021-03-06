#!/usr/bin/env bash
source ./config.sh

set -e
set -x

mkdir -p $DATA_ART
corpus=$DATA/${PRETRAIN_CORPUS}.tgt

# generate data with noise
python noise.py -c $corpus -o $DATA_ART -e 1 -s 9182
python noise.py -c $corpus -o $DATA_ART -e 2 -s 78834
python noise.py -c $corpus -o $DATA_ART -e 3 -s 5101
python noise.py -c $corpus -o $DATA_ART -e 4 -s 33302
python noise.py -c $corpus -o $DATA_ART -e 5 -s 781
python noise.py -c $corpus -o $DATA_ART -e 6 -s 1092
python noise.py -c $corpus -o $DATA_ART -e 7 -s 10688
python noise.py -c $corpus -o $DATA_ART -e 8 -s 50245
python noise.py -c $corpus -o $DATA_ART -e 9 -s 71187

python /lab/ogawa/scripts/slack/send_slack_message.py -m "Finish noising: ${PRETRAIN_CORPUS}"
