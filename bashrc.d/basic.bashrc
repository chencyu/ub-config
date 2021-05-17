# ChenCYu's customize
# export LANG=zh_TW.UTF-8

BASHROOT=$(realpath "$(dirname "$BASH_SOURCE")")

# 漂亮的Prompt
# 要用單引號 '' 才能使用 \$
# \e[色碼對m 顏色文字 \e[m
export PS1='\e[0;31m(\D{%Y.%m.%d})(\@)\e[m\e[0;34m[BASH]\e[m\n\e[0;32m\u@\h\e[m:[\e[0;34m\w\e[m] \$\n>> '
export PS2='>> ' # 多行提示符號

# 讓py/python都直接使用python3，比較方便
# 讓pip直接使用pip3，比較方便
alias py=python3
alias python=python3
alias pip=pip3

# 真正實現clear效果
alias cls='printf "\033c"'


# 切換超級使用者權限時的偏好
alias sudo='sudo '             # 空格的用途是告訴bash去檢查sudo後面接著的命令是否也是別名(alias)
alias su='sudo -Es'


# 載入其他設定檔
source "$BASHROOT/path.bashrc"
source "$BASHROOT/venv.bashrc"

