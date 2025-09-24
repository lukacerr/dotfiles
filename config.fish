function fish_greeting
	fastfetch -l none \
		-s "Title:OS:Kernel:Uptime:Packages:Shell:WMTheme:CPU:GPU:Memory:Swap:Disk:Battery:PowerAdapter" \
		--size-binary-prefix SI
end

alias shutdown='sudo shutdown'
alias reboot='sudo reboot'
alias pacman='paru'
alias yay='paru'
alias nano='nano -/ -l'
alias zed='zeditor'
alias lg='lazygit'
alias ld='lazydocker'
alias lsq='lazysql'
alias dc='docker compose'

if status is-interactive
	starship init fish | source
end

function fzf_search_history
    if test -z "$fish_private_mode"
        builtin history merge
    end

    set -f commands_selected (
      builtin history -z -t"%m月%d日 %H時%M分%S秒 │ " |
      fzf --scheme=history --read0 \
      	# --preview="string replace --regex '^.*? │ ' '' -- {} | fish_indent --ansi" \
	      # --preview-window="down:1" \
      	-q (commandline) -i --height=10% |
      string replace --regex -- "^.*? │ " ''
    )

    if test $status -eq 0
      commandline --replace -- $commands_selected
    end

    commandline --function repaint
end

bind \cr fzf_search_history
# FIXME: bind \e\[A fzf_search_history

function spf
    set -gx SPF_LAST_DIR "$HOME/.local/state/superfile/lastdir"
    command spf $(pwd)
   if test -f "$SPF_LAST_DIR"
        source "$SPF_LAST_DIR"
        rm -f -- "$SPF_LAST_DIR" > /dev/null
    end
end
