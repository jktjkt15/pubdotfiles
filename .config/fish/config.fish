if status is-interactive
    set -U fish_greeting
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showupstream verbose
    set -Ux EDITOR ~/build/nvim-linux-x86_64/bin/nvim
    set -g GPG_TTY (tty)
    set -gx ATUIN_NOBIND true
    set -Ux FZF_DEFAULT_OPTS "--color fg:#D8DEE9,hl:#A3BE8C,fg+:#D8DEE9,bg+:#353b45,hl+:#A3BE8C,pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B"

    set -e LS_COLORS #(vivid generate ~/.config/vivid/jayzone.yml)
    set -Ux LS_COLORS "" #(vivid generate ~/.config/vivid/jayzone.yml)
    # set -Ux EZA_COLORS="da=2;34:ur=34:uw=95:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36:xx=95:"
    set -Ux EZA_CONFIG_DIR ~/.config/eza

    set -Ux ELECTRON_OZONE_PLATFORM_HINT wayland

    fish_add_path ~/build/nvim-linux-x86_64/bin/
    fish_add_path ~/.ghcup/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.dotnet/tools
    fish_add_path ~/.duckdb/cli/latest/

    set fzf_fd_opts --hidden
    fzf_configure_bindings --directory=\cf
    fish_vi_key_bindings

    alias ls='eza --color=auto --icons'
    alias ll='eza -l --color=auto --icons'
    alias la='eza -la --color=auto --icons'
    alias lt='eza --tree'

    function fish_title
        set -q argv[1]; or set argv fish
        # Looks like ~/d/fish: git log
        # or /e/apt: fish
        set prefix ""
        if set -q SSH_TTY
            echo "(SSH) "
        end
        echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv
    end

    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    alias grep='grep --color=auto'
    alias v='nvim'
    alias cat='bat --color=always'
    alias fre='source ~/.config/fish/config.fish'
    alias ev='nvim ~/.config/fish/config.fish'
    # alias y='yazi'
    alias ng="nvim -c 'G' -c 'on'"
    alias ce='export EDITOR=nvim && crontab -e'
    alias t="trash"
    alias tp="trash put"
    alias pu='sudo pacman -Syu --needed'
    alias yu='yay -Syu --needed'
    # alias k='kubectl'
    alias p='~/repos/scripts/run.fish'
    alias j='just'
    alias jj='just --list | tail -n +2 | fzf --cycle | xargs -I{} just {}'
    alias s='pet exec'
    # alias sa=''
    alias gm='cd ~/Music/'
    alias gc='cd ~/.config'
    alias gh='cd ~/'
    alias gs='cd ~/repos/scripts/'
    alias gr='cd ~/repos/'

    function mcd
        mkdir -p $argv[1]
        cd $argv[1]
    end

    function gcd
        git clone $argv[1] $argv[2]
        cd $argv[2]
    end

    function ts
        touch $argv[1]
        chmod +x $argv[1]
        echo "#! /usr/bin/env bash" >$argv[1]
    end

    # eval "$(ssh-agent -c)" >/dev/null
    fish_ssh_agent
    zoxide init fish | source
    atuin init fish | source
    starship init fish | source
    ~/.local/share/env/.env.fish
    eval (opam env --switch=default)

    # bind \ch _atuin_search
    # bind -M insert \ch _atuin_search
    # bind \cs 'pet exec'
    # bind -M insert \cs 'pet exec'
end
