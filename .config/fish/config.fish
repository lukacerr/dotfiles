function fish_greeting 
end

alias shutdown='sudo shutdown now'
alias reboot='sudo reboot'

alias in='sudo zypper in'
alias fin='flatpak install flathub'
alias inn='sudo zypper in --no-recommends'
alias uni='sudo zypper rm --clean-deps'

alias jctl="journalctl -p 3 -xb"
alias sjctl="sudo journalctl -p 3 -xb"
alias grubup="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"

alias ls='eza --color=always --group-directories-first --icons -a -a'
alias untar='tar -zxvf '

alias e=nano
alias neofetch=fastfetch
alias pn=pnpm
alias code="/usr/bin/code --password-store=\"kwallet5\" --enable-wayland-ime --enable-features=UseOzonePlatform --ozone-platform=wayland"

function cleanup
    echo -e "\n--- FLATPAK REPAIRING ---\n"
    flatpak repair
    flatpak uninstall --unused
    echo -e "\n--- ZYPPER RM --UNNEEDED ---\n"
    # sudo zypper rm --clean-deps $(sudo zypper packages --unneeded | awk '/^i/ {print $5}')
    sudo zypper clean --all
    sudo zypper refresh
end

function up
	cleanup
    echo -e "\nRPM (ZYPPER) DUP"
    sudo zypper dup --no-recommends
    echo -e "\nFLATPAK UPDATE"
    flatpak update
    echo -e "\nFIRMWARE (fwupdmgr) UPDATE\n"
    sudo fwupdmgr refresh > /dev/null
    sudo fwupdmgr update
	echo -e 'CLEANUP'
end

function se
    set -l query (string join " " $argv)
    echo -e "\n--- FLATPAK RESULTS ---\n"
    flatpak search $query
    echo -e "\n--- ZYPPER RESULTS ---\n"
    zypper search $query
end

atuin init fish | source
starship init fish | source


function spf
    set -gx SPF_LAST_DIR "$HOME/.local/state/superfile/lastdir"

    command spf $(pwd)

   if test -f "$SPF_LAST_DIR"
        source "$SPF_LAST_DIR"
        rm -f -- "$SPF_LAST_DIR" > /dev/null
    end
end

# pnpm
set -gx PNPM_HOME "/home/luka/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
