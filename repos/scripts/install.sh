sudo pacman -Syu --needed --noconfirm bob fish base-devel unzip npm starship

bob install nightly
bob use nightly

mkdir -p ~/.config
cd ~/.config
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S --needed --noconfirm cifs-utils dmenu dotnet-sdk exa fd freerdp fuzzel fzf git-delta github-cli hyprland hyprpaper inetutils jq lastpass-cli lxappearance mako man-db neofetch noto-fonts noto-fonts-emoji openfortivpn otf-font-awesome python-pip ripgrep tealdeer ttf-cascadia-mono-nerd waybar wget wireplumber wl-clipboard xfce4-settings yq slurp grim cronie terraform wtype ufw ffmpegthumbnailer poppler zoxide parallel cava

groupadd -f input
usermod -a -G input $USER

yay -Syu --needed --answerclean None --answerdiff None --cleanafter --removemake --answerupgrade brave-bin discord elixir expressvpn firefox slack-desktop spotify vlc wezterm remmina-git dracula-gtk-theme dracula-icons-git cli-visualizer swaylock-effects-git powershell azure-cli

chsh -s /bin/fish
# run the following in fish
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update

# static address
# nmcli con mod eth0 ipv4.addresses "172.17.1.222/24"
# nmcli con mod eth0 ipv4.gateway "172.17.0.1"
# nmcli con mod eth0 ipv4.dns "DNS1 DNS2"
# nmcli con mod eth0 ipv4.method manual
# nmcli con mod eth0 connection.autoconnect yes

#sudo ufw enable
#    To                         Action      From
#      --                         ------      ----
# [ 1] Anywhere                   ALLOW IN    PHONE STATIC IP 
# [ 2] ROONARCPORT/tcp                  ALLOW IN    Anywhere

sudo systemctl enable --now ufw.service

cargo install spotify_player --features lyric-finder,image,notify,daemon

#
# [Unit]
# Description=Spotify daemon
#
# [Service]
# Type=simple
# #Group=
# ExecStart=/home/USER/.cargo/bin/spotify_player
# Restart=on-failure
# StandardOutput=file:%h/log_file
#
# [Install]
# WantedBy=default.target

# systemctl --user enable --now jayspd.service

stack install git-mediate
