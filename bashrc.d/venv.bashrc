HELP="
venv: venv [-c [-py <version>]|-a|-l|-r] [envName] 
  Manage python virtual environment with \`python -m venv'.

  Options:
    -c, --create        create a new virtual environment with specified name.
    -py                 if the -c option is supplied, specify python version,
                        default is \`3' (python3 provide by system PATH).
    -a, --activate      activate a specific virtual environment.
    -l, --list          list all exist virtual environment.
    -r, --remove        remove a specific virtual environment.
"

function errmsg()
{
    case "$1:$2" in

        "-syntax:unknown")
            >&2 echo "Unknown option: $3"
            return 1
        ;;

        "-invalid:envname")
            >&2 echo "Unknown venv: $3"
            return 2
        ;;

        "-syntax:pyver")
            >&2 echo "You must provide num for python version"
            return 3
        ;;

    esac
}


function install_venv()
{
    if [[ ! $(lsb_release -i) =~ .*"Ubuntu".* ]]; then
        echo "failed !"
        return 1
    fi
    
    while true;
    do
        read -p "Do you want to install it now? [yes/no]: " yn
        case $yn in
            "Y"|"y"|"Yes"|"yes")
                sudo apt install python3-venv -y
                return 0
            ;;
            "N"|"n"|"No"|"no")
                return 1
            ;;
        esac
    done
}


function venv()
{
    local PYVER=3
    local PYVENVS="$HOME/.venv"
    local EnvName="$2"

    case "$1" in

        "-a"|"--activate")
            source "$PYVENVS/$2/bin/activate" 2> /dev/null || \
            errmsg -invalid envname "$2"
        ;;

        "-c"|"--create")
            if [[ "$2" == "-py" ]]; then
                PYVER="$3"
                EnvName="$4"
            fi
            if [[ ! "$PYVER" =~ ^([2-3].[0-9]|[2-3])$ ]]; then
                errmsg -syntax pyver
            fi
            if  [[ "$EnvName" =~ ^(\*|"")$ ]]; then
                errmsg -invalid envname "$2"
            fi
            python$PYVER -m venv --copies "$PYVENVS/$EnvName" || install_venv
        ;;

        "-l"|"--list")
            printf "\n"
            ls -w 1 "$PYVENVS"
            printf "\n"
        ;;

        "-r"|"--remove")
            if [[ "$2" =~ ^(\*|"")$ ]]; then
                errmsg -invalid envname "$2"
            fi
            if [ ! -d "$PYVENVS/$EnvName" ]; then
                errmsg -invalid envname "$EnvName"
                rm -rf "$PYVENVS/$2" || errmsg -invalid envname "$2"
                echo /dev/null
            fi
        ;;

        "-h"|"--help")
            echo "$HELP"
        ;;

        *)
            errmsg -syntax unknown "$1"
        ;;
        
    esac
}


export -f venv

