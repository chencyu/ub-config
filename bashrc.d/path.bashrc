APPEND_PATH=".
:$HOME/.app/scripts
"

APPEND_PATH=$(tr -d $'\n' <<< "$APPEND_PATH")

# 僅在未添加PATH時才做添加動作
if [[ ! -v _ORIGINAL_PATH  ]]; then
    # 把原始的PATH作為預設值設給 _ORIGINAL_PATH
    export _ORIGINAL_PATH="${_ORIGINAL_PATH:=$PATH}"
    export PATH="$APPEND_PATH:$PATH"
fi
