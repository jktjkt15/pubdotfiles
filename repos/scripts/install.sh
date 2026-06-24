sudo pacman -Syu --needed --noconfirm git fish base-devel unzip starship

mkdir -p ~/.config
cd ~/.config
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

sudo pacman -S --needed --noconfirm cifs-utils dotnet-sdk eza fd fzf git-delta github-cli hyprland hyprpaper inetutils jq lxappearance mako man-db noto-fonts noto-fonts-emoji otf-font-awesome ripgrep tealdeer ttf-cascadia-mono-nerd waybar wget wireplumber wl-clipboard xfce4-settings yq slurp grim cronie wtype ufw ffmpegthumbnailer poppler zoxide parallel cava unarchiver sudo docker docker-compose whois pacman-contrib rust go odin pipewire-pulse

groupadd -f input
usermod -a -G input $USER

yay -Syu --needed --answerclean None --answerdiff None --cleanafter --removemake --answerupgrade dracula-gtk-theme dracula-icons-git xdg-desktop-portal-hyperland-git floorp-bin

cargo install trashy

sudo pacman -Syu --needed aria2 bat bottom cifs-utils cronie docker docker-compose dotnet-sdk eza fd freerdp fuzzel fzf gimp git-delta github-cli gnustep-base gnustep-make grim hyprland hyprpaper jq kitty linux-headers mako man-db ntp obs-studio otf-font-awesome poppler ripgrep rsync signal-desktop slurp sshfs starship tealdeer ttf-cascadia-mono-nerd unarchiver v4l2loopback-dkms vivid waybar wget whois wl-clipboard xfce4-settings xh yarn yazi zoxide 

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
cd ~/.config/fish
yadm restore fish_plugins
fisher update

# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# stack install git-mediate

# https://gitlab.com/kyb/fish_ssh_agent
