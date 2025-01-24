#!/bin/bash

# source proxy.sh
if [ -z "$https_proxy" ]; then
    export http_proxy="127.0.0.1:7890"
    export https_proxy="127.0.0.1:7890"
    echo "Proxy enabled"
else
    unset http_proxy
    unset https_proxy
    echo "Proxy disabled"
fi
