#!/usr/bin/env bash
source ./config.sh

data_epoch=9
DATA_BIN=$OUT/data_bin_art/data_bin_art
CUDA_VISIBLE_DEVICES=$device python train.py ${DATA_BIN}_${data_epoch} \
--save-dir $MODELS \
--max-epoch $data_epoch \
--batch-size 4 \
--max-tokens 3000 \
--train-subset train \
--valid-subset valid \
--arch transformer \
--clip-norm 2 --lr 0.002 --min-lr 1e-4 --lr-shrink 0.999 --validate-interval 10 \
--dropout 0.2 --relu-dropout 0.2 --attention-dropout 0.2 --copy-attention-dropout 0.2 \
--encoder-embed-dim 512 --decoder-embed-dim 512 \
--max-target-positions 1024 --max-source-positions 1024 \
--encoder-ffn-embed-dim 4096 --decoder-ffn-embed-dim 4096 \
--encoder-attention-heads 8 --decoder-attention-heads 8 \
--copy-attention-heads 1 \
--share-all-embeddings \
--no-progress-bar \
--log-interval 1000 \
--positive-label-weight 1.3 \
--no-ema \
--save-interval-updates 100000 \
--skip-invalid-size-inputs-valid-test \
--copy-attention --copy-attention-heads 1 | tee $OUT/log$exp${data_epoch}.out
# > $OUT/log$exp${data_epoch}.out 2>&1 &
