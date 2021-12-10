HELP="
 _________________________________________________________
| [Venv - Easy way to use Python venv]                    |
|---------------------------------------------------------|
|  venv  <operation>        <Py_ver>           <envName>  |
|           create       -py <3.7/3.8 ...>       newEnv   |
|           upgrade      -py <3.7/3.8 ...>        myEnv   |
|           remove                                myEnv   |
|            list                                         |
|          activate                               myEnv   |
|             -h                                          |
|  ex.                                                    |
|      venv create -py 3.7 newEnvName                     |
|      venv remove myEnvName                              |
|_________________________________________________________|
"

function errmsg()
{
    case "$1:$2" in

        "-syntax:pyver")
            >&2 echo "You must provide num for python version"
        ;;

        "-syntax:unknown")
            >&2 echo "Unknown option: $3"
        ;;

        "-wrongitem:envname")
            >&2 echo "Unknown venv: $3"
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
    local PYVENVS="$HOME/.Envs"
    local EnvName="$2"

    case "$1" in

        "-a"|"--activate")
            source "$PYVENVS/$2/bin/activate" 2> /dev/null || \
            errmsg -wrongitem envname "$2"
        ;;

        "-c"|"--create")
            if [[ "$2" == "-py" ]]; then
                PYVER="$3"
                EnvName="$4"
            fi
            if [[ ! "$PYVER" =~ ^([2-3].[0-9]|[2-3])$ ]]; then
                errmsg -syntax pyver
                return 1
            fi
            if  [[ "$EnvName" =~ ^(\*|"")$ ]]; then
                errmsg
            fi
            python$PYVER -m venv --copies "$PYVENVS/$EnvName" || install_venv
        ;;

        "-l"|"--list")
            printf "\n"
            ls -w 1 "$PYVENVS"
            printf "\n"
        ;;

        "-r"|"--remove")
            if [[ ! "$2" =~ ^(\*|"")$ ]]; then
                rm -rf "$PYVENVS/$2"
            fi
        ;;

        "-h"|"--help")
            echo "$HELP"
        ;;

        *)
            errmsg -syntax unknown "$1"
            return 1
        ;;
        
    esac
}


export -f venv

