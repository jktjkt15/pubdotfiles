if status is-interactive
    set -U fish_greeting
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showupstream verbose
    set -g EDITOR nvim

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

    fish_add_path ~/.local/share/bob/nvim-bin
    fish_add_path ~/.ghcup/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.local/bin

    set fzf_fd_opts --hidden
    fzf_configure_bindings --directory=\cf
    fish_vi_key_bindings

    alias ls='eza --color=auto --icons'
    alias ll='eza -l --color=auto --icons'
    alias la='eza -la --color=auto --icons'
    alias lt='eza --tree'
    alias grep='grep --color=auto'
    alias v='nvim'
    #alias vim='nvim'
    alias cat='bat --color=always'
    alias fre='source ~/.config/fish/config.fish'
    alias ev='nvim ~/.config/fish/config.fish'
    alias gs='git status'
    alias ge='cd ~/repos'
    alias y='yazi'
    alias ng="nvim -c 'G' -c 'on'"
    alias s="spotify_player"
    alias sp="spotify_player playback"
    alias t="trash"
    alias tp="trash put"
    alias ce="export EDITOR=nvim && crontab -e"

    eval "$(ssh-agent -c)" >/dev/null
    zoxide init fish | source
    starship init fish | source
end
