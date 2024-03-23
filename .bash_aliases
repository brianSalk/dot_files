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
alias Gr='git rm --cached'
alias open_sudoers='sudo visudo /etc/sudoers'
alias OFF='shutdown now'
alias LS='cls;ls'
alias CD='dirm goto'
alias DF='df -h | head -3 | tail -1 | tr -s " "  | cut -d" " -f4'
alias g++='g++ -std=c++20'
alias SL='sl | lolcat'
alias print_path='awk -v RS=":" '1' <<< $PATH'
alias DU="2> /dev/null sudo du / -h | tail -1 |cut -d' ' -f 1"
alias core_temp="sensors | awk '/^Core [0-9]:.*/'"
alias Jn='jupyter notebook'
alias Sr='streamlit run'
alias vi='nvim'
# the following code allows you to have local aliases that are not recorded by version control, these aliases might be specific to one computer
LOCAL_A=~/.local_bash_aliases
if [ -f ${LOCAL_A} ]
then
	. ${LOCAL_A}
else
	touch ${LOCAL_A}
fi
