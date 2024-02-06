if status is-interactive
    set -U fish_greeting
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_showupstream verbose
    set -g EDITOR nvim

    fish_add_path ~/.local/share/bob/nvim-bin
    fish_add_path ~/.ghcup/bin

    set fzf_fd_opts --hidden
    fzf_configure_bindings --directory=\cf

    alias ls='exa --color=auto --icons'
    alias ll='exa -l --color=auto --icons'
    alias la='exa -la --color=auto --icons'
    alias lt='exa --tree'
    alias grep='grep --color=auto'
    alias v='nvim'
    #alias vim='nvim'
    alias cat='bat --color=always'
    alias fre='source ~/.config/fish/config.fish'
    alias ev='nvim ~/.config/fish/config.fish'
    alias gs='git status'
    alias ge='cd ~/repos'
    alias y='yazi'

    starship init fish | source
end
