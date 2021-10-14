icon=$(( ( RANDOM % 5 )  + 1 ))
case $icon in
    1)
    SEP_ICON=
    ;;
    2)
    SEP_ICON=
    ;;
    3)
    SEP_ICON=ﰉ
    ;;
    4)
    SEP_ICON=
    ;;
    5)
    SEP_ICON=
    ;;
esac

PROMPT="%B%F{78}%n%f%b %F{132}$SEP_ICON%f %F{74}%(3~|.../%2~|%~)%f \$(if [ \$? -ne 0 ]; then echo \"❌ \"; fi)%F{132}%f "

#######################################
# zsh-syntax-highlighting configuration

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[builtin]='fg=173,bold'
ZSH_HIGHLIGHT_STYLES[aliases]='fg=173,bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=173,bold'
