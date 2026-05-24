# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# ZSH_THEME="amuse"    # 换行，有小图标
# ZSH_THEME="gallifrey"  # 不换行，纯文本, 含设备名
# ZSH_THEME="lambda"  # 不换行，纯文本, 无设备名
# ZSH_THEME="apple"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(
# 	git
# 	z
#  	zsh-autosuggestions
#  	zsh-syntax-highlighting
# )

# source $ZSH/oh-my-zsh.sh

# custom by byron
# for skim keybind
# source $ZSH/skim/completion.zsh 
# source $ZSH/skim/key-bindings.zsh 
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# clash meta proxy
# export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
export HOMEBREW_HTTPS_PROXY=http://127.0.0.1:7897
export HOMEBREW_HTTP_PROXY=http://127.0.0.1:7897

# rust
export PATH="$HOME/.cargo/bin:$PATH"
#export RUSTUP_DIST_SERVER="https://rsproxy.cn"
#export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"



# llvm
#export PATH="/usr/local/opt/llvm/bin:$PATH"
#export LDFLAGS="-L/usr/local/opt/llvm/lib"
#export CPPFLAGS="-I/usr/local/opt/llvm/include"
#export PATH="/usr/local/sbin:$PATH"

#source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#alias ssh-888="ssh -o ServerAliveInterval=3 root@103.197.6.182"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

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

# skim
alias skim='sk --ansi --regex -i -c "rg --color=always --line-number '{q}'"'

alias nv='nvim'

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
export EDITOR=neovim
export VISUAL=neovim


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

fastfetch
