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
    local ERRTYPE="$1"
    local ERRNAME="$2"
    local ERRITEM="$3"

    case "$ERRTYPE:$ERRNAME" in

        "-syntax:unknown")
            >&2 echo "Unknown option: $ERRITEM"
            return 1
        ;;

        "-invalid:envname")
            >&2 echo "Unknown venv: $ERRITEM"
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
    local OPTION="$1"
    local EnvName="$2"

    case "$OPTION" in

        "-a"|"--activate")
            source "$PYVENVS/$EnvName/bin/activate" 2> /dev/null || \
            errmsg -invalid envname "$EnvName"
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
                errmsg -invalid envname "$EnvName"
            fi
            python$PYVER -m venv --copies "$PYVENVS/$EnvName" || install_venv && python$PYVER -m venv --copies "$PYVENVS/$EnvName"
        ;;

        "-l"|"--list")
            printf "\n"
            ls -w 1 "$PYVENVS"
            printf "\n"
        ;;

        "-r"|"--remove")
            if [[ "$EnvName" =~ ^(\*|"")$ ]]; then
                errmsg -invalid envname "$EnvName"
            fi
            if [ ! -d "$PYVENVS/$EnvName" ]; then
                errmsg -invalid envname "$EnvName"
                rm -rf "$PYVENVS/$EnvName" || errmsg -invalid envname "$EnvName"
            fi
        ;;

        "-h"|"--help")
            echo "$HELP"
        ;;

        *)
            errmsg -syntax unknown "$OPTION"
        ;;
        
    esac
}


export -f venv

