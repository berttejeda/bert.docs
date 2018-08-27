#!/usr/bin/env bash
usage=""" $0 --source <path/to/markdown.md,path/to/markdown2.md,includes/*> --output <path/to/file.html> --template <path/to/template.html> --watch <file1,file2,*.ext1,*.ext2,etc>
"""
if [[ $# == 0 ]];then
	echo -e "${usage}"
	exit
fi
PREFIX="eval"
DEFAULT_TEMPLATE=_template/templates/default.html
DEFAULT_HEADER=_common/templates/header.html
DEFAULT_CSS=_common/templates/default.css
t=1
while (( "$#" )); do
    if [[ "$1" =~ --source|-s ]]; then source=$(echo "${2}" | tr ',' ' ');fi    
    if [[ "$1" =~ --output|-o ]]; then output=$2;fi    
    if [[ "$1" =~ --help|-h ]]; then echo -e "${usage}";fi    
    if [[ "$1" =~ --template|-t ]]; then template=$2;fi    
    if [[ "$1" =~ --template|-t ]]; then template=$2;fi    
    if [[ "$1" =~ --ppvars|-p ]]; then ppvars+="${2} -D ";fi    
    if [[ "$1" =~ --vars|-V ]]; then vars+="${2} -V ";fi    
    if [[ "$1" =~ --metavars|-m ]]; then metavars+="${2} --metadata ";fi    
    if [[ "$1" =~ --dir|-d ]]; then dir=$2;fi    
    if [[ "$1" =~ --watch|-w ]]; then 
		if [[ "${2}" =~ .*, ]];then 
			options_stdin=${2}
			for pattern in ${options_stdin//,/ };do 
				watch_patterns+="'${pattern}',"
			done
			watch_patterns=" -name ${watch_patterns//,/ -o -name }"
			watch_patterns="${watch_patterns: :-9}" # strip the trailing -o -name # TOFIX: this ain't good
		else 
			watch_patterns=" -name ${2}"
		fi
	fi
    if [[ "$1" =~ .*--wait.* ]]; then t=$2;fi
    if [[ "$1" =~ .*--dry.* ]]; then PREFIX=echo;fi
    shift
done

# Build pre-processor commands
pp_commands="pp "
if [[ $ppvars ]];then
	pp_commands+="-D ${ppvars: :-3} "
fi
pp_commands+="${source} "

# Build pandoc commands
output_file=${output-${source%.*}.html}
pandoc_commands="pandoc "
pandoc_commands+="-o '${output_file}' "
pandoc_commands+="-c '${css-${DEFAULT_CSS}}' "
pandoc_commands+="-H '${header-${DEFAULT_HEADER}}' "
pandoc_commands+="--template ${template-${DEFAULT_TEMPLATE}} "
# for include in includes/*;do
#     include_file=${include#*/}
#     include_name=${include_file//${include_file: -3}/}
#     pandoc_commands+="--metadata body_${include_name}='$(pandoc ${include})' "
# done
if [[ $vars ]];then
	pandoc_commands+="-V ${vars: :-3} "
fi
if [[ $metavars ]];then
	pandoc_commands+="--metadata ${metavars: :-11} "
fi
pandoc_commands+="--self-contained "
pandoc_commands+=" --standalone "

if [[ -n $watch_patterns ]];then
	echo "Issuing initial build"
	# Invoke markdown pre-processor & pipe to pandoc
	$PREFIX "${pp_commands} | ${pandoc_commands}"
	echo "Done. Initial output file is ${output_file}."
	echo "Monitoring for file changes as per ${watch_patterns}"
	while true;do 
		find_result=$(eval "find "${dir}" -newermt '${t} seconds ago' \( ${watch_patterns} \)")
		if [[ -n "${find_result}" ]];then 
			echo "Detected modification in ${find_result}"
			echo "Issuing rebuild"
			$PREFIX "${pp_commands} | ${pandoc_commands}"
			echo "Done. Output file is ${output_file}"
		else 
			echo "No modifications detected ... waiting ${t} second(s)"
		fi
		sleep 1
	done
else
	echo "Issuing build"
	$PREFIX "${pp_commands} | ${pandoc_commands}"
	echo "Done. Output file is ${output_file}"
fi
