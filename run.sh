#!/bin/bash

# TODO: set workdir to $HOME & clone repo

# Package removal from base server install
toDelete=(
	"yast2" "patterns-yast-yast2_basis" "patterns-yast-yast2_server" # xdg-su doesn't work
	"firewalld" # Overkill for home users (search for "ufw" below)
	"dos2unix" # Who the fuck uses this shit
	"vim" # Still don't know how to exit
	"adobe-sourcecodepro-fonts" # Not my personal choice
	# "systemd" # Waiting for the systemd2 release
)

# Install from OpenSUSE TW repos
toInstall=(
	# "ufw" # Uncomment if no router + enable it on scripts below
	"opi" "git" # "kernel-longterm"
	"fwupd" "cpupower" "Mesa" "Mesa-dri" "Mesa-gallium" "tzselect"
	"alacritty" "fish" "starship" "atuin"
	"greetd" "gtkgreet" "cage"
	"xdg-utils" "xdg-user-dirs"
	"playerctl" "brightnessctl" "upower" "btop" "gdu" "fzf" "eza" "fastfetch"
	"hyprland" "hyprland-qtutils" "hyprcursor" "hyprpaper" "hyprlock" "hypridle"
	"xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk"
	"qt6-wayland" "xwayland" "wayland-utils"
	"unzip" "wl-clipboard" "udiskie"
	"pipewire" "pipewire-tools" "pipewire-alsa" "alsa-utils" "pipewire-pulseaudio" "wireplumber"
	"fcitx5" "fcitx5-mozc" "fcitx5-configtool-qt6" # u probably don't want mozc
	"SwayNotificationCenter" "fuzzel" "nwg-bar" "kdeconnect-kde" "kwalletd6" "eww"
	"pavucontrol" "bluez" "blueman" "pantheon-agent-polkit"
	"symbols-only-nerd-fonts" "unicode-emoji"
	"inter-fonts" "jetbrains-mono-fonts" "google-noto-sans-jp-fonts"
	"nwg-look" "kvantum-qt6" "kvantum-manager" "qt6ct"
	"libreoffice-calc" "libreoffice-writer" "libreoffice-gtk3"

	"git-cola" "docker" "docker-compose"
	"pnpm" "rustup" "python3"

	"thunar" "mpv" "grim" "slurp" "swappy"

	# For whatever reasons, this is an "essential asset"
	"hyprland-wallpapers"
)

# From OBS/External repos, via OPI
toInstallOpi=(
	# "anydesk"
	"codecs"
	"vscode"
)

# From flathub repo, system-wide instalations
toInstallFlatpak=(
	"com.github.tchx84.Flatseal"
	"app.zen_browser.zen"
	"md.obsidian.Obsidian"
	"org.ferdium.Ferdium"
	"io.dbeaver.DBeaverCommunity"
	"io.dbeaver.DBeaverCommunity.Client.pgsql"
)

# To run post-installation
PostInstallScripts()
{
	# Clear the screen
	printf "\033c"

	# Clone dotfiles & remove local repo
	git clone https://github.com/lukacerr/dotfiles.git && rm -rf dotfiles/.git
	cp -rfv dotfiles/. $HOME && rm -rf dotfiles
	sudo cp -rfv onRoot/. / && rm -rf onRoot

	# Disable SSH, comment if needed
	sudo systemctl disable sshd

	# Hostname config
	sudo hostnamectl set-hostname $USER-pc

	# Setup default dirs
	xdg-user-dirs-update --force

	# Enable greetd
	sudo systemctl enable greetd

	# Apply new grub2 config
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg

	# Terminal config
	sudo chsh -s $(which fish) luka
	starship preset no-nerd-font -o ~/.config/starship.toml

	# Enable ufw firewall, uncomment if installed
	# sudo ufw default deny incoming
	# sudo ufw default allow outgoing
	# sudo ufw enable

	# Mark force-push.sh as executable
	sudo chmod +x force-push.sh

	# Set Zen Browser as default
	xdg-settings set default-web-browser app.zen_browser.zen.desktop
	xdg-mime default app.zen_browser.zen.desktop x-scheme-handler/https x-scheme-handler/http

	# Add user to groups
	sudo usermod -aG systemd-journal $USER
	sudo usermod -aG docker $USER

	# Enforce GTK theming
	nwg-look -a
	gsettings set org.gnome.desktop.interface gtk-theme HyprLuka-Colloid
	gsettings set org.gnome.desktop.interface icon-theme HyprLuka-Papirus
	gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
	gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans JP 10'
	gsettings set org.gnome.desktop.interface font-name 'Inter 11'
	gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 11'
	gsettings set org.gnome.nautilus.desktop font 'Inter 11'

	# Rust/PNPM development set-up c:
	rustup default stable
	pnpm env use --global lts

	# NOPASSWD:ALL rule for current user
	echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/nopasswd"
	# Change from TTY to graphical target
	sudo systemctl set-default graphical.target

	# Enjoy :)
	sudo reboot
}

# # # # # # # # # # # # # # # # # # # # # # # #
# YOU PROBABLY DON'T WANT TO TOUCH FROM HERE? #
# # # # # # # # # # # # # # # # # # # # # # # #

sudo zypper refresh -f

# Deleting desired packages from base installation
for i in "${toDelete[@]}"
do
	sudo zypper rm -y -u --force-resolution --details "$i"
done

# Enabling flatpak + flathub support
sudo zypper in -y -l -f flatpak flatpak-remote-flathub

# Installing desired packages
for i in "${toInstall[@]}"
do
	sudo zypper in -y -l -f \
		--replacefiles --force-resolution \
		--no-recommends --allow-vendor-change --details "$i"
done

for i in "${toInstallOpi[@]}"
do
	sudo opi -n "$i"
done

for i in "${toInstallFlatpak[@]}"
do
	sudo flatpak install -y --reinstall --or-update --no-related -v --app "$i"
done

# Cleanup & ensure updates
sudo zypper clean --all
sudo zypper dup --remove-orphaned -l -y --no-recommends --force-resolution --no-allow-vendor-change
# FIXME: Flatkpak crashes?
# sudo flatpak uninstall --unused -y
# sudo flatpak update -y
# sudo flatpak repair

# FIXME: Firmware updates
# sudo fwupdmgr refresh > /dev/null
# sudo fwupdmgr update

# Run post install script
PostInstallScripts

# Made by Luka Cerrutti (@lukacerr at most social media)
