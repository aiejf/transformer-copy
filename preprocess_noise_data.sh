#!/usr/bin/env bash
source ./config.sh

set -e
set -x

# set copy params
copy_params='--copy-ext-dict'

# set common params between train/test
common_params='--source-lang src --target-lang tgt
--padding-factor 1
--srcdict ./dicts/dict.src.txt
--joined-dictionary
'

for epoch in {1..9}; do
    echo $epoch

    trainpref=${DATA_ART}/${CORPUS_NAME}_$epoch
    validpref=${DATA}/valid
    destdir=$OUT/data_bin_art/data_bin_art_$epoch

    # preprocess train/valid
    python preprocess.py \
    $common_params \
    $copy_params \
    --trainpref $trainpref \
    --validpref $validpref \
    --destdir $destdir \
    --output-format binary \
    --alignfile $trainpref.forward
    # | tee $destdir.log

done
