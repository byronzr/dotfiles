# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	z
 	zsh-autosuggestions
 	zsh-syntax-highlighting
)



# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# clash meta proxy
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
# export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
# export HOMEBREW_HTTPS_PROXY=http://127.0.0.1:7897
# export HOMEBREW_HTTP_PROXY=http://127.0.0.1:7897

# rust
export PATH="$HOME/.cargo/bin:$PATH"
#export RUSTUP_DIST_SERVER="https://rsproxy.cn"
#export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"


# imagemagick-full
export PATH=/opt/homebrew/opt/imagemagick-full/bin:$PATH

# ffmpeg-full
export PATH=/opt/homebrew/opt/ffmpeg-full/bin:$PATH

# llvm
#export PATH="/usr/local/opt/llvm/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/llvm/lib"
#export CPPFLAGS="-I/usr/local/opt/llvm/include"
#export PATH="/usr/local/sbin:$PATH"

#alias ssh-888="ssh -o ServerAliveInterval=3 root@103.197.6.182"
#alias ssh-888="ssh -o ServerAliveInterval=3 root@103.197.6.182 -p 22222"

# function y() {
# 	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
# 	yazi "$@" --cwd-file="$tmp"
# 	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
# 		builtin cd -- "$cwd"
# 	fi
# 	rm -f -- "$tmp"
# }

if [ "$(command -v eza)" ]; then
    unalias -m 'll'
	unalias -m 'lll'
    unalias -m 'l'
    unalias -m 'la'
    unalias -m 'ls'
	unalias -m 'lt'
    alias ls='eza  -G --color never --icons -s type -H -h -F --git'
    alias ll='eza  -l --color always --icons -s type -H -h -F --git'
	alias lll='eza  -l --color always --icons -s type -H -h -F --git --total-size'
	alias lt='eza -l --color always --icons -s type -H -h -F --git-ignore --tree'
	alias la='eza  -l --color always --icons -s type -H -h -F --git -a'
fi

if [ "$(command -v bat)" ]; then
  unalias -m 'cat'
  alias cat='bat --theme="TwoDark"'
fi


alias cre='RUST_BACKTRACE=full cargo run --example'
alias cr='RUST_BACKTRACE=full cargo run'
alias nv='nvim'

# custom by byron
# for skim keybind
# source $ZSH/skim/completion.zsh 
# source $ZSH/skim/key-bindings.zsh 
# User configuration
# skim
alias skim='sk --ansi --regex -i -c "rg --color=always --line-number '{q}'"'

# {2} => line number
# {1} => file name
# no-heading 不知道什么时候加的。。。。天啊
# skim 也更风搞了个q我的天啊。
alias skk='sk --ansi -i -c "rg --no-heading --line-number --color=always -F '{q}'" --delimiter : --preview="bat --color=always --style=numbers --highlight-line {2} --line-range {2}::30 {1}"'
#alias skk='sk --ansi -i -c "rg --no-heading --line-number --color=never -F '{q}'" --delimiter : --preview="bat --color=always --style=numbers --highlight-line {2} --line-range {2}::30 {1}"'

# zsh:no matches found
setopt no_nomatch

# Autoload -U promptinit; promptinit
# prompt pure

# bindkey 是 zsh 的按键绑定工具，用来把“按键序列”绑定到 ZLE（Zsh Line Editor）的“widget”（编辑动作），从而定制命令行的编辑、补全菜单操作等行为。
# -e:  emacs mode
# -v:  vi mode
bindkey -e
export EDITOR=nvim
export VISUAL=nvim


# Created by `pipx` on 2025-12-08 04:14:02
export PATH="$PATH:/Users/byronzr/.local/bin"

eval "$(starship init zsh)"
if [ -n "$ZSH_VERSION" ]; then
   autoload -Uz compinit
   compinit
fi
source ~/.config/skim/completion.zsh
source ~/.config/skim/key-bindings.zsh

# brew install zoxide
eval "$(zoxide init zsh)"

# brew install zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ignore case-sensitive 
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

fastfetch
