APPEND_PATH=".
:$HOME/.app/scripts
"





APPEND_PATH=$(tr -d $'\n' <<< "$APPEND_PATH")

# 僅在未添加PATH時才做添加動作
if [[ ! -v _ORIGINAL_PATH  ]]; then
    export _ORIGINAL_PATH="$PATH"
    export PATH="$APPEND_PATH:$PATH"
fi
