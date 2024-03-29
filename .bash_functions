#!/usr/bin/env bash

# dirm is a directory manager which allows you to quickly navagate your filesystem.
#+add adds a new alias and path to a file

# some difficulties are: 
# checking if an alias already exists then updating the value.
# allowing aliases and paths to contain space (or any other metacharacter)

dirm() {
	local ALIAS=""
	local _PATH=""
	if [ ! -f $HOME/.dirm ]; then
		touch $HOME/.dirm
		echo 'created ~/.dirm'
	fi
	# first check which command is being used
	#+ commands are: goto, print, add, del, all, update
	case "$1" in
		--help)
			echo dirm args:
			echo add: add a new alias or path
			echo all: prints all paths, accepts an optional regex
			echo del: delete an alias
		   	echo goto: goto path associated with an alias 	
			echo path: prints the path with the alias
			echo update: update the path associated with an alias
			;;
		add)
			if [ $# -eq 3 ]; then
				_PATH="$3"
			elif [ $# -eq 2 ]; then
				_PATH=$(pwd)
			else
				echo "dirm add requires one or two arguments in the form:" >&2
				echo "dirm add <alias> [<path>...]" >&2
				return 
			fi
			ALIAS="$2"
			# search ~/.dirm to see if the argument exists in the file
			#+if it does, do nothing
			#+if not, append alias with path to file
			local IS_THERE=""
			IS_THERE=$(awk -v alias="${ALIAS}" 'match($1,"^" alias "$" )' $HOME/.dirm)
			if [ -z "${IS_THERE}" ]; then
				echo "${ALIAS} ${_PATH}" >> $HOME/.dirm
			else
				echo "${ALIAS} already assigned ${_PATH}, use 'update' command to reassign" >&2
			fi
			;;
		all)
			if [ $# -eq 1 ]; then
				cat $HOME/.dirm
			elif [ $# -eq 2 ]; then
				awk -v rx="$2" '$1 ~ rx' $HOME/.dirm
			else
				echo "dirm all requires zero or one argument(s) in the form of:" >&2
				echo "dirm all [<regex>]"
				return 1
			fi
			;;
		del)
			if [ $# -lt 2 ]; then
				echo "dirm del requires one or more arguments in the form of:" >&2
				echo "dirm del <alias1 [<alias2>...]>" >&2
				return
			fi
			# if the alias exists remove it, else nothing
			while [ ${2+"x"} ]
			do
				ALIAS="$2"
				sed -ni "/^${ALIAS} .*/!p" $HOME/.dirm
				shift
			done
			;;
		goto)
			if [ $# -ne 2 ]; then
				echo "dirm goto requires exactly one argument in the form of:" >&2
				echo "dirm goto <alias>" >&2
				return
			fi
			# find alias in file, get the line number, 
			# use line number to get the path.
			# cd to the path.
			ALIAS="$2"
			_PATH=$(awk -v alias="^${ALIAS}$" '$1 ~ alias{print $0; exit}' $HOME/.dirm)
			_PATH=$(cut -d' ' -f1 --complement <<< "$_PATH")
			if [ -n "${_PATH}" ]; then
				cd "${_PATH}"
				clear
			else
				echo "$ALIAS not found, add it with:" >&2
				echo "dirm add $ALIAS <path>" >&2
			fi
			;;
		path)
			if [ $# -ne 2 ]; then
				echo "dirm path takes requires one argument in the form of:" >&2
				echo "dirm path <alias>" >&2
				return
			fi
			ALIAS="$2"
			_PATH=""
			# print the path associated with the alias if one exists
			_PATH=$(awk -v alias="${ALIAS}" 'match($1, "^" alias "$")' $HOME/.dirm)
			echo $(cut -d' ' -f1 --complement <<< ${_PATH})
			;;
		update)
			if [ $# -eq 2 ]; then
				_PATH="$(pwd)"
			elif [ $# -eq 3 ]; then
				_PATH="$3"
			else 
				echo "dirm update requires 1 or 2 arguments in the form of:" >&2
				echo "dirm update <alias> [<path>]" >&2
				return
			fi
			# update an alias if one exists, else apppend
			ALIAS="$2"
			# remove line containing alias
			sed -ni "/^${ALIAS} .*$/!p" $HOME/.dirm
			echo "${ALIAS} ${_PATH}" >> $HOME/.dirm
			;;
		*)
			echo "$1: invalid argument for dirm"
			return 1
			;;
	esac
}
# this function compiles a c++ program using g++.  it is really just an alias for g++ [opt...] {file}.cpp -o {file}
cmp() {
	for arg;
	do
		case $arg in
			*.cpp)
				local executable_name="${arg%.cpp}"
				local file_name="${arg}"
			;;
			*)
				local -a args+=("${arg}")
		esac
	done
	local args+=("${file_name}" -o "${executable_name}")
	g++ "${args[@]}"
}

open_with() {
	xdg-mime query default $(xdg-mime query filetype ${1})	
}
for_each_in_dir() {
	[ ${1+x} ] || { echo "no args"; set -- "${@:1:1}" "xdg-open"; }
	for each in *
	do
		"$@" "$each"
	done
}
# alias for find [...] -regextype posix-extended [...]
efind() {
	for ((i=1;i<=$#;++i))
	do
		if [[ "${!i}" =~ ^-i?regex$ ]]
		then
			set -- "${@:1:i-1}" "-regextype" "posix-extended" "${@:i}"
			break
		fi
	done
	find "${@}"
}

# this is a copy-and-past from stack overflow written by user SebMa
Sudo() {
	local firstArg=$1
	if [ $(type -t $firstArg) = function ]
	then
			shift && command sudo bash -c "$(declare -f $firstArg);$firstArg $*"
	elif [ $(type -t $firstArg) = alias ]
	then
			alias sudo='\sudo '
			eval "sudo $@"
	else
			command sudo "$@"
	fi
}

goodnight_brain() {
	while [[ "$yorn" != "yes" || "$yorn" != "no" ]]
	do
		read -p 'do I have to go to bed? ' yorn
		yorn=${yorn,,}
		if [[ ${yorn} == yes ]]
		then
			echo "ok... :-("
			sleep 1
			shutdown now
		elif [[ ${yorn} == no ]]
		then
			echo 'thanks for letting me stay up with you guys!!'
			return 0
		else
			echo "${yorn} is not part of my vocabulary" 
		fi
	done

}
# sets up my tmux session the way I like for c++ projects, but only does so if a .session file is present in the given directory
cmux() {
	if [[ $# -ne 1 || ! -d "$@" ]]
	then
		>&2 echo 'invalid argument'
		return 1
	fi
	local last=$(pwd)
	cd "$@"
	local is_session_in_dir=0
	for each in *
	do
		if [[ "$each" =~ .*session$ ]]
		then
			local vim_session=$each
			local is_session_in_dir=1
			break
		fi
	done
	if [ "$is_session_in_dir" -eq 0 ]
	then
		>&2 echo "no vim session in $@"
		cd $last
		return 1
	fi
	wmctrl -r ':ACTIVE:' -b add,maximized_vert,maximized_horz
	local session=${vim_session##*/}
	local session=${session%.*}
	tmux new-session -d -s $session
	local window=0
	tmux rename-window -t session
	tmux send-keys -t $session:$window 'tmux split-window -v' C-m 'tmux resize-pane -D 10' C-m 'sleep 1' C-m 'clear' C-m 'vim -S '$vim_session C-m
	tmux attach-session -t $session
}
Q() {
	$@ &> /dev/null &	
}
get_newest() {
	stat -c "%z %n" * | sort | tail -${1-"1"} | head -1 | cut -d' ' -f4-
}
backup_files() {
	# make an option -q for quiet, which does not prompt or read from stdin
	local QUIET_FLAG="OFF"
	local PATTERN='*'
	while [[ ${#@} -gt 0 ]]
	do
		case $1 in
			-q)
				local QUIET_FLAG="ON" # if quiet_flag set, do not prompt
				;;
			*)
				PATTERN="${1}"
				;;
		esac
		shift
	done
	for each in *
	do 
		if [[ -e ".${each}.backup" && ${QUIET_FLAG} == "OFF" && "${each}" == ${PATTERN} ]]
		then
			read -rp "would you like to overwrite the preexisting file .${each}.backup? (Y/n) " answer
			answer=${answer,,}
			while [[ $answer != 'y' && $answer != 'n' ]]
			do
				echo please enter either 'y' or 'n'
				read -rp "would you like to overwrite the preexisting file .${each}.backup? (Y/n) " answer
				answer=${answer,,}
			done
		fi
		if [[ ${answer-'y'} == 'y' && ${each} == ${PATTERN} ]]
		then
			cp "${each}" ".${each}.backup"
		fi
	done

}
# modify this to be more verbose and give warnings about how many files [and bytes] are being overridden.
restore_files() {
	# allow user the use the same -q flag as above,
	# also use -f flag to only restore certain files,
	# use -p flag to allow user to use a pattern on which files to update.
	local PATTERN=".*.backup"
	while [[ ${#@} -eq 1 ]] 
	do
		PATTERN=${1}
		shift
	done
	for each in .*.backup
	do 
		tmp="${each%.*}";
		if [[ "${tmp#.}" = "$PATTERN"  ]]
		then
			cp -i "${each}" "${tmp#.}"
		fi

	done	
}
vercomp() {
	local v1=( ${1//./ } )
	local v2=( ${2//./ } )
	local max_len=${#v1[@]}
	if [[ $max_len -lt ${#v2[@]} ]]
	then
		max_len=${#2}
	fi
	for i in $( seq 0 $((max_len - 1)) )
	do
		if [[ -z v1[$i] ]]
		then
			v1[$i]=0
		fi
		if [[ -z ${v2[$i]} ]]
		then
			v2[$i]=0
		fi
		if [[ ! ${v1[$i]} =~ ^[0-9]+$ ]]
		then
			echo >&2 ${1} is not a valid version 
			return 1
		fi
		if [[ ! ${v2[$i]} =~ ^[0-9]+$ ]]
		then
			echo >&2 ${2} is not a valid version
			return 1
		fi
		if [[ ${v1[$i]} -gt ${v2[$i]} ]]
		then
			echo 1
			return 0
		elif [[ ${v1[$i]} -lt ${v2[$i]} ]]
		then
			echo -1
			return 0
		fi
	done
	echo 0
	return 0
}
are_you_hot() {
	res="$(core_temp | tr --squeeze ' ' | cut -d' ' -f3 | cut -c 2-3 )"
	max=0
	for each in ${res[@]} 
	do
		if [[ $each -gt $max ]]
		then
			max=$each
		fi
	done
	if [[ $max -lt 60 ]]
	then
		echo "Im chill bro"
	elif [[ $max -lt 80 ]]
	then
		echo "Im a bit hot"
	else
		echo 'Im schvitzing here!'
	fi
}

Alias() {
	if [[ $# -lt 2 ]]
	then
		echo This simple function adds an alias to and then sources ~/.bash_aliases
		echo At least two arguments are required
		echo Alias "<aliasName> <commandName>" [--optional -args -to -command]
		echo ex. Alias ll ls -l
		return
	fi
	echo "" >> ~/.bash_aliases
	echo "alias $1='""${@:2}""'" >> ~/.local_bash_aliases
	. ~/.bash_aliases
}
