sudo pacman -Syu --needed --noconfirm bob fish base-devel unzip npm starship

bob install nightly
bob use nightly

mkdir -p ~/.config
cd ~/.config
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S --needed --noconfirm cifs-utils dmenu dotnet-sdk exa fd freerdp fuzzel fzf git-delta github-cli hyprland hyprpaper inetutils jq lastpass-cli lxappearance mako man-db neofetch noto-fonts noto-fonts-emoji openfortivpn otf-font-awesome python-pip ripgrep tealdeer ttf-cascadia-mono-nerd waybar wget wireplumber wl-clipboard xfce4-settings yq

yay -Syu --needed --answerclean None --answerdiff None --cleanafter --removemake --answerupgrade brave-bin discord elixir expressvpn firefox slack-desktop spotify vlc wezterm remmina-git dracula-gtk-theme dracula-icons-git cli-visualizer roon-tui spotify-tui swaylock-effects-git

echo '' >> ~/.bashrc
echo 'fish' >> ~/.bashrc
source ~/.bashrc
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
fisher update
