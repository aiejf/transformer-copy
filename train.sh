#!/usr/bin/env bash
source ./config.sh

mkdir $MODELS
pretrained_model=./out/models/models_pretrain_bccwj_char/checkpoint5.pt
# pretrained_model=./out/models/models_pretrain_bccwj_clean_unidic/checkpoint5.pt

CUDA_VISIBLE_DEVICES=$device python train.py $DATA_BIN \
  --save-dir $MODELS \
  --seed 4321 \
  --max-epoch 30 \
  --batch-size 8 \
  --max-tokens 3000 \
  --train-subset train \
  --valid-subset valid \
  --arch transformer \
  --lr-scheduler triangular \
  --max-lr 0.004 --lr-period-updates 73328 \
  --clip-norm 2 --lr 0.001 \
  --lr-shrink 0.95 --shrink-min \
  --dropout 0.2 --relu-dropout 0.2 \
  --attention-dropout 0.2 --copy-attention-dropout 0.2 \
  --encoder-embed-dim 512 --decoder-embed-dim 512 \
  --max-target-positions 1024 --max-source-positions 1024 \
  --encoder-ffn-embed-dim 4096 --decoder-ffn-embed-dim 4096 \
  --encoder-attention-heads 8 --decoder-attention-heads 8 \
  --copy-attention-heads 1 \
  --no-progress-bar \
  --log-interval 1000 \
  --share-all-embeddings \
  --copy-attention \
  --copy-attention-heads 1 \
  --weight-decay 0.0 \
  --no-ema \
  --positive-label-weight 1.2 \
  --token-labeling-loss-weight 0.1 \
  --token-labeling-positive-label-weight 1.2 \
  | tee $OUT/log/log$exp.out

  # --pretrained-model $pretrained_model \
  # --token-labeling-loss-weight 0.1 \
  # --token-labeling-positive-label-weight 3 \

python /lab/ogawa/scripts/slack/send_slack_message.py -m "Finish trainig: ${exp}"

