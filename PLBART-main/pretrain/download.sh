#!/usr/bin/env bash

#############################################
#   Download PLBART CodeXGLUE checkpoints   #
#############################################

FILE=plbart_finetuned.pt

https://drive.google.com/file/d/1CWkLfJGoXKUkwDcF_IERvHnCELx7_pMF/view?usp=share_link

if [[ ! -f "$FILE" ]]; then
    fileid="1CWkLfJGoXKUkwDcF_IERvHnCELx7_pMF"
    curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" >/dev/null
    curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$(awk '/download/ {print $NF}' ./cookie)&id=${fileid}" -o ${FILE}
    rm ./cookie
fi

#############################################
#        Download PLBART checkpoints        #
#############################################

FILE=plbart_base.pt
if [[ ! -f "$FILE" ]]; then
    fileid="19OLKx0YY0yVorzZa-caFW0-hALVvX7gt"
    curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" >/dev/null
    curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$(awk '/download/ {print $NF}' ./cookie)&id=${fileid}" -o ${FILE}
    rm ./cookie
fi

#############################################
#     Download PLBART-large checkpoints     #
#############################################

#FILE=plbart_large.pt
#if [[ ! -f "$FILE" ]]; then
#    fileid="11SeXOOJCnXvJsF93hQcwXl7GqzmbfC_w"
#    curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" >/dev/null
#    curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$(awk '/download/ {print $NF}' ./cookie)&id=${fileid}" -o ${FILE}
#    rm ./cookie
#fi

#############################################
#     Download PLBART-CSNet checkpoints     #
#############################################

#FILE=checkpoint_356_100000.pt
#if [[ ! -f "$FILE" ]]; then
#    fileid="1Jmmow7g4JFw-xgJxL8jYhuWR2tb3uxQr"
#    curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" >/dev/null
#    curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$(awk '/download/ {print $NF}' ./cookie)&id=${fileid}" -o ${FILE}
#    rm ./cookie
#fi
