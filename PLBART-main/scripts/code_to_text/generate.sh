#!/usr/bin/env bash

export PYTHONIOENCODING=utf-8
CURRENT_DIR=$(pwd)
HOME_DIR=$(realpath ../..)

while getopts ":h" option; do
    case $option in
    h | *) # display help
        echo
        echo "Syntax: bash run.sh GPU_ID SRC_LANG"
        echo
        echo "SRC_LANG  Language choices: [java, python, go, javascript, php, ruby]"
        echo
        exit
        ;;
    esac
done

GPU=$1
SOURCE=$2
MODEL_SIZE=${3:-base}
CHECKPOINT_NAME=$4
SPLIT=$5

TARGET=ru_XX
PATH_2_DATA=${HOME_DIR}/data/codeXglue/code-to-text/${SOURCE}

ARCH=mbart_base
PRETRAINED_MODEL_NAME=plbart_${MODEL_SIZE}.pt
PRETRAIN=${HOME_DIR}/pretrain/${PRETRAINED_MODEL_NAME}
SPM_MODEL=${HOME_DIR}/sentencepiece/sentencepiece.bpe.model
langs=java,python,ru_XX

SAVE_DIR=${CURRENT_DIR}/${MODEL_SIZE}_${SOURCE}_${TARGET}
mkdir -p ${SAVE_DIR}

if [[ "$SOURCE" =~ ^(ruby|javascript|go|php)$ ]]; then
    USER_DIR="--user-dir ${HOME_DIR}/source"
    TASK=translation_without_lang_token
else
    USER_DIR=""
    TASK=translation_from_pretrained_bart
fi

export CUDA_VISIBLE_DEVICES=$GPU

function generate() {

    model=${SAVE_DIR}/${CHECKPOINT_NAME}
    FILE_PREF=${SAVE_DIR}/output_${CHECKPOINT_NAME}_${SPLIT}
    RESULT_FILE=${SAVE_DIR}/result_${CHECKPOINT_NAME}_${SPLIT}.txt
    GROUND_TRUTH_PATH=$PATH_2_DATA/${SPLIT}.jsonl

    fairseq-generate $PATH_2_DATA/data-bin $USER_DIR \
        --path $model \
        --task $TASK \
        --gen-subset ${SPLIT} \
        -t $TARGET -s $SOURCE \
        --sacrebleu \
        --remove-bpe 'sentencepiece' \
        --batch-size 64 \
        --langs $langs \
        --beam 10 >$FILE_PREF

    cat $FILE_PREF | grep -P "^H" | sort -V | cut -f 3- | sed 's/\[${TARGET}\]//g' >$FILE_PREF.hyp
    python ${HOME_DIR}/evaluation/nl_eval.py \
        --references  $GROUND_TRUTH_PATH  \
        --predictions $FILE_PREF.hyp \
        --json_refs 2>&1 | tee ${RESULT_FILE}

}

generate