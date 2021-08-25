alias ll='ls -l'
alias l='ls -p'
alias la='ls -a'
alias update='sudo apt-get update'
alias instl='sudo apt-get install'
alias search='apt-cache search'
alias cls='clear'
alias lal='ls -la'
alias Ga='git add'
alias Gc='git commit'
alias Gs='git status'
alias Gi='git init'
alias Gpom='git push origin main'
alias Gpo='git push origin'
alias Gp='git push'
alias Gf='git fetch'
alias Gunstage='git rm -rf --cached'
alias open_sudoers='sudo visudo /etc/sudoers'
alias OFF='shutdown now'
alias LS='cls;ls'
alias CD='dirm goto'
alias g++='g++ -std=c++20'
alias SL='sl | lolcat'
alias print_path='awk -v RS=":" '1' <<< $PATH'

# the following code allows you to have local aliases that are not recorded by version control, these aliases might be specific to one computer
LOCAL_A=~/.local_bash_aliases
if [ -f ${LOCAL_A} ]
then
	. ${LOCAL_A}
fi
