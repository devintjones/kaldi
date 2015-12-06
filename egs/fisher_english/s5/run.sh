#!/bin/bash

# It's best to run the commands in this one by one.

. cmd.sh
. path.sh
mfccdir=`pwd`/mfcc
set -e


# Next we'll use fMLLR and train with SAT (i.e. on 
# fMLLR features)



steps/train_sat.sh  --cmd "$train_cmd" \
  10000 300000 data/train data/lang exp/tri4a_ali  exp/tri5a || exit 1;

(
  utils/mkgraph.sh data/lang_test exp/tri5a exp/tri5a/graph
  steps/decode_fmllr.sh --nj 25 --cmd "$decode_cmd" --config conf/decode.config \
    exp/tri5a/graph data/dev exp/tri5a/decode_dev
)&

# this will help find issues with the lexicon.
# steps/cleanup/debug_lexicon.sh --nj 300 --cmd "$train_cmd" data/train_100k data/lang exp/tri5a data/local/dict/lexicon.txt exp/debug_lexicon_100k


# The step below won't run by default; it demonstrates a data-cleaning method.
# It doesn't seem to help in this setup; maybe the data was clean enough already.
# local/run_data_cleaning.sh

## The following is the best current neural net recipe.
# local/online/run_nnet2_multisplice.sh

# ## The following is an older recipe without multi-splice.
# # local/online/run_nnet2.sh


# ## The following is another older nnet recipe, on top of fMLLR features.
# # local/run_nnet2.sh
#

