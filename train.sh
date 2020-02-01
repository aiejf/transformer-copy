#!/usr/bin/env bash
source ./config.sh
set -u

# memory watch
memory_watch_running=`ps aux|grep ogawa|grep memory_watch.sh|grep -v color|grep -v grep`
if [ -z "$memory_watch_running" ]; then
  sh /lab/ogawa/scripts/server/memory_watch.sh &
  mpid=$!
  echo "| pid of memory_watch: ${mpid}"
else
  mpid=0
  echo "| memory_watch.sh is running"
fi


mkdir $MODELS
pretrained_model=./out/models/models_pretrain_ja_bccwj_clean_char_2_9times/checkpoint9.pt
CUDA_VISIBLE_DEVICES=$device python train.py $DATA_BIN \
  --save-dir $MODELS \
  --seed 4321 \
  --max-epoch 50 \
  --batch-size 128 \
  --max-tokens 5800 \
  --train-subset train \
  --valid-subset valid \
  --arch transformer \
  --lr-scheduler triangular \
  --max-lr 0.004 --lr-period-updates 73328 \
  --clip-norm 2 --lr 0.001 \
  --lr-shrink 0.95 --shrink-min \
  --dropout 0.2 --relu-dropout 0.2 \
  --attention-dropout 0.2 \
  --encoder-embed-dim 512 --decoder-embed-dim 512 \
  --max-target-positions 1024 --max-source-positions 1024 \
  --encoder-ffn-embed-dim 4096 --decoder-ffn-embed-dim 4096 \
  --encoder-attention-heads 8 --decoder-attention-heads 8 \
  --copy-attention \
  --copy-attention-heads 1 \
  --copy-attention-dropout 0.2 \
  --no-progress-bar \
  --log-interval 1000 \
  --share-all-embeddings \
  --weight-decay 0.0 \
  --no-ema \
  --positive-label-weight 1.2 \
  --pretrained-model $pretrained_model \
  | tee $OUT/log/log$exp.out

  # --pretrained-model $pretrained_model \

if [ $? -gt 0 ]; then
  # send error message
  python /lab/ogawa/scripts/slack/send_slack_message.py -m "Error!! training: ${exp} ($HOSTNAME)"
else
  # send finish message
  python /lab/ogawa/scripts/slack/send_slack_message.py -m "Finish training: ${exp} ($HOSTNAME)"
fi

if [ $mpid -ne 0 ]; then
  kill -9 $mpid
fi

