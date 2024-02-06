cd ~

sudo pacman -Syu --needed git bob fish yadm base-devel unzip npm starship

yadm clone -f https://github.com/jktjkt15/pubdotfiles

mkdir -p ~/.config
cd ~/.config
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S --needed cifs-utils dmenu dotnet-sdk exa fd freerdp fuzzel fzf git-delta github-cli hyprland hyprpaper inetutils jq lastpass-cli lxappearance mako man-db neofetch noto-fonts noto-fonts-emoji openfortivpn otf-font-awesome python-pip ripgrep tealdeer ttf-cascadia-mono-nerd waybar wget wireplumber wl-clipboard xfce4-settings yq

yay -Syu --needed brave-bin discord elixir expressvpn firefox slack-desktop spotify vlc wezterm remmina-git dracula-gtk-theme dracula-icons-git cli-visualizer roon-tui spotify-tui swaylock-effects-git

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher update