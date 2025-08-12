if status is-interactive
    set -U fish_greeting
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showupstream verbose
    set -Ux EDITOR ~/.local/share/bob/nightly/bin/nvim
    set -g GPG_TTY (tty)
    set -gx ATUIN_NOBIND true
    set -Ux FZF_DEFAULT_OPTS "--color=fg:#f2f3f3,hl:#ffb65b,fg+:#f2f3f3,bg+:#353b45,hl+:#ffb65b,info:#61afef,prompt:#5a84e5,pointer:#f3f383,marker:#62ea76,spinner:#8c62e0,header:#353b45"
    set -Ux LS_COLORS (vivid generate ~/.config/vivid/jayzone.yml)

    fish_add_path ~/.local/share/bob/nvim-bin
    fish_add_path ~/.ghcup/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.local/bin
    fish_add_path ~/.dotnet/tools

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
    alias gs='git status'
    alias ge='cd ~/repos/work/'
    # alias y='yazi'
    alias ng="nvim -c 'G' -c 'on'"
    alias s='spotify_player'
    alias sp='spotify_player playback'
    alias ce='export EDITOR=nvim && crontab -e'
    alias t="trash"
    alias tp="trash put"
    alias pu='sudo pacman -Syu --needed'
    alias yu='yay -Syu --needed'
    alias k='kubectl'
    alias p='~/repos/scripts/run.fish'

    function mcd
        mkdir -p $argv[1]
        cd $argv[1]
    end

    eval "$(ssh-agent -c)" >/dev/null
    zoxide init fish | source
    atuin init fish | source
    starship init fish | source
    ~/.local/share/env/.env.fish

    bind \ch _atuin_search
    bind -M insert \ch _atuin_search
    bind \cs 'pet exec'
    bind -M insert \cs 'pet exec'
end
