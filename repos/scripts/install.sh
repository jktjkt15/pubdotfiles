sudo pacman -Syu --needed --noconfirm bob fish base-devel unzip npm starship

bob install nightly
bob use nightly

mkdir -p ~/.config
cd ~/.config
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S --needed --noconfirm cifs-utils dmenu dotnet-sdk eza fd freerdp fuzzel fzf git-delta github-cli hyprland hyprpaper inetutils jq lastpass-cli lxappearance mako man-db neofetch noto-fonts noto-fonts-emoji openfortivpn otf-font-awesome python-pip ripgrep tealdeer ttf-cascadia-mono-nerd waybar wget wireplumber wl-clipboard xfce4-settings yq slurp grim cronie terraform wtype ufw ffmpegthumbnailer poppler zoxide parallel cava unarchiver timew sudo bluez bluez-utils ttf-sarasa-gothic docker docker-compose whois

groupadd -f input
usermod -a -G input $USER

yay -Syu --needed --answerclean None --answerdiff None --cleanafter --removemake --answerupgrade expressvpn remmina-git dracula-gtk-theme dracula-icons-git swaylock-effects-git powershell-bin jqp-bin


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


sudo pacman -S --needed rust
cargo install spotify_player --features lyric-finder,image,notify,daemon
cargo install trashy

go install github.com/jesseduffield/lazydocker@latest

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


sudo pacman -Syu --needed act aria2 bitwarden-cli bat bluez bluez-utils bottom cifs-utils cronie docker docker-compose dotnet-sdk eza fd freerdp fuzzel fzf gimp git-delta github-cli gnustep-base gnustep-make grim heimdall hyprland hyprpaper jq kitty linux-headers lynx mako man-db mkcert neofetch net-tools nfs-utils noto-fonts noto-fonts-emoji ntp obs-studio openfortivpn otf-font-awesome poppler ripgrep rsync signal-desktop slurp sshfs starship tealdeer ttf-cascadia-mono-nerd ttf-sarasa-gothic ufw unarchiver v4l2loopback-dkms vivid watchexec waybar wget whois wl-clipboard xfce4-settings xh yarn yazi yq zoxide

sudo pacman --needed abduco atuin pipewire-pulse

# systemctl --user enable --now pipewire pipewire-pulse wireplumber bluetooth.service

yay -Syu xdg-desktop-portal-hyperland-git tera jqp-bin bluetuith tree-sitter-cli pet-git

sudo systemctl enable --now ufw.service
sudo ufw enable

# curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
# cd ~/.config/fish
# yadm restore fish_plugins
# fisher update

# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# stack install git-mediate

