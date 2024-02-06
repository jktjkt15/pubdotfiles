# After archinstall:

```bash 
sudo pacman -Syu --needed --noconfirm git yadm
yadm clone -f https://github.com/jktjkt15/pubdotfiles
yadm checkout ~

chmod +x repos/scripts/install.sh

repos/scripts/install.sh
``` 
