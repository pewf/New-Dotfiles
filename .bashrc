#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#export LANG=en_US.UTF-8

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# download iso command
alias download-isos='google-chrome-stable https://tb.rg-adguard.net/index.php?sid=74a7cf51-12ed-19f5-2885-3b48ad9ee67b'

WINEPREFIX=$HOME/.local/share/grapejuice/wineprefix

# neofetch

############################
#        FISH SHELL        #
############################

# fish

###########################
#        STARSHIP         #
###########################

eval "$(starship init bash)"

###################
# POWERLINE SHELL #
###################

# function _update_ps1() {
#     PS1=$(powerline-shell $?)
# }
#
# if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
#     PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
# fi


## TWEAKS ###############################################################################

#############################
# Cutefish DE Terminal Blur #
#############################

# xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id `xdotool search --class urxvt` || true
