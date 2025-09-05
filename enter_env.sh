#!/bin/bash

D_PATH="docker/.env"
if [ ! -e "$D_PATH" ]; then
    bash .utils/gen_env.sh
fi

bash .utils/select_display.sh