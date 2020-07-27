#!/usr/bin/env bash
SCRIPT=install
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Add file to manage (name or filepath needed)
function app-add {
    local dfilepath=$(get-dfilepath $1)
    if [[ -f $1 ]]; then
        # copy to the .dln file
        cp $1 $dfilepath 
    else
        # create new dfile and open it in default editor
        touch $dfilepath
        "${EDITOR:-vim}" $dfilepath
    fi
    
    # installation
    install $(eval echo $1)

    # create path at paths.txt
    echo $1 >> "$dir/paths.txt" 
}

function install {
    local dfilepath=$(get-dfilepath $1)

    # Symlink the files
    ln -sf $dfilepath $1 
}

function install-all {
    # loop the paths.txt file
    while read path; do
      install $(eval echo $path)
    done < "$dir/paths.txt"
}

function get-dfilepath {
    local dname=''
    # if just the name of the file was given
    if [[ $(dirname $1) = . ]]; then
        local dname=$1
    else
        local dname=$(basename $1)
    fi
    # Get name without .(the first character)
    local dname="${dname:1}"

    # Create dotfile path
    echo "$dir/$dname.dln"
}

function get-filepath {
    local filepath=$1
    # if just the name of the file was given
    if [[ $(dirname $1) = . ]]; then
        local filepath="\$HOME/$1"
    fi

    echo $filepath
}

# Message to display for usage and help.
function usage
{
    local txt=(
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  add [filepath] Adds dotfile to manage it."
""
"Options:"
"  --help, -h     Print help."
"  --all, -a  Install all the paths added."
    )

    printf "%s\n" "${txt[@]}"
}

# Message to display when bad usage.
function badUsage {
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help"
    )

    [[ $message ]] && printf "$message\n"

    printf "%s\n" "${txt[@]}"
}

# Options list
while (( $# ))
do
    case "$1" in
        
        --help | -h)
            usage
            exit 0
        ;;

        --all | -a)
            install-all
            exit 0
        ;;

        #command         \
        #| othercommand  \
        #| add)
        add)
            command=$1
            shift
            app-add $(get-filepath $1)
            exit 0
        ;;

        *)
            badUsage "Option/command not recongnized"
            exit 1
        ;;

    esac
done

badUsage
exit 1 
