#!/bin/bash

find_char_position() {
    local str="$1"
    local char="$2"
    local pos=-1
    
    for (( i=0; i<${#str}; i++ )); do
        if [[ "${str:$i:1}" == "$char" ]]; then
            pos=$i
            break
        fi
    done
    
    echo $pos
}

encrypt_char() {
    local char="$1"
    local keychar="$2"
    local alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local shift=$(find_char_position "$alphabet" "$keychar")
    if [ $shift -gt 0 ]; then
        echo "$char" | tr "${alphabet}" "$(echo ${alphabet} | cut -b$((shift+1))-${#alphabet})$(echo ${alphabet} | cut -b1-$shift)"
    else
        echo "$char"
    fi
}

encrypt() {
    local plaintext="$1"
    local key="$2"
    local encrypted=""
    for (( i=0; i<${#plaintext}; i++ )); do
        local char="${plaintext:$i:1}"
        local keychar="${key:$((i % ${#key})):1}"
        encrypted+=$(encrypt_char "$char" "$keychar")
    done
    echo "$encrypted"
}

# Verificación de argumentos
if [ $# -ne 2 ]; then
    echo "Uso: $0 '<texto_plano>' '<clave>'"
    exit 1
fi

plaintext="$1"
key="$2"
encrypted=$(encrypt "$plaintext" "$key")
echo "Texto plano: $plaintext"
echo "Clave: $key"
echo "Texto cifrado: $encrypted"