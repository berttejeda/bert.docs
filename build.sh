#!/usr/bin/env bash

# Declare defaults
PREFIX="eval"
DEFAULT_TEMPLATE=_template/templates/default.html
DEFAULT_HEADER=_common/templates/header.html
DEFAULT_CSS=_common/templates/default.css
t=1
help(){
    #
    # Display Help/Usage
    #
    echo -e "Usage: ${0}"
    for param in "${!params[@]}";do
        echo "param: ${param}, help: ${params[${param}]}"
    done
    exit
}
# Declare accepted parameters
declare -A params=(
["--source|-s$"]="[some/markdown/file.md,some/other/markdown/file2.md,includes/*]"
["--output|-o$"]="[some/output/file.html]"
["--template|-t$"]="[some/template/file.html]"
["--ppvars|-p$"]="[some_preprocess_var=somevalue]"
["--help|-h$"]="display usage and exit"
["--vars|-V$"]="[some_pandoc_var=somevalue]"
["--metavars|-m$"]="[some_pandoc_meta_var=somevalue]"
["--watchdir|-d$"]="[somedir]"
["--watch|-w$"]="[somefile1.md,somefile2.html,*.txt,*.md,*.js,*.etc]"
["--interval|-i$"]="[t>0]"
["--dry"]="Dry Run"
)
# Display help if no args
if [[ $# -lt 1 ]];then help;fi
# Parse arguments
while (( "$#" )); do
    for param in "${!params[@]}";do
        if [[ "$1" =~ $param ]]; then
            var=${param//-/}
            var=${var%|*}
            if [[ $var ]];then
                declare ${var%|*}+="${2} "
            else
                eval "${var%|*}=${2}"
            fi
        fi
    done
shift
done
# Display help if applicable
if [[ -n $help ]];then help;fi
# DRY RUN LOGIC
if [[ -n $dry ]];then 
    PREFIX=echo
fi

# Parse file watcher patterns
if [[ -n $watch ]];then
    if [[ "${watch}" =~ .*, ]];then 
        for pattern in ${watch//,/ };do
            watch_patterns+="'${pattern}',"
        done
        watch_patterns=" -name ${watch_patterns//,/ -o -name }"
        watch_patterns="${watch_patterns: :-9}" # strip the trailing -o -name # TOFIX: this ain't good
    else 
        watch_patterns=" -name ${watch}"
    fi
fi
# Build pre-processor commands
pp_commands="pp "
if [[ -n $ppvars ]];then
    ppvars=${ppvars// / -D }
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
if [[ $vars ]];then
    pandoc_commands+="-V ${vars: :-3} "
fi
if [[ $metavars ]];then
    pandoc_commands+="--metadata ${metavars: :-11} "
fi
pandoc_commands+="--self-contained "
pandoc_commands+=" --standalone "
# Build output file
if [[ -n $watch_patterns ]];then
    echo "Issuing initial build"
    # Invoke markdown pre-processor & pipe to pandoc
    $PREFIX "${pp_commands} | ${pandoc_commands}"
    find_command="find "${watchdir}" -newermt '${t} seconds ago' \( ${watch_patterns} \)"
    echo "Done. Initial output file is ${output_file}."
    echo "Monitoring for file changes as per ${find_command}"
    if [[ $PREFIX == 'eval' ]];then
        while true;do 
            find_result=$(eval "${find_command}")
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
    fi
else
    echo "Issuing build"
    $PREFIX "${pp_commands} | ${pandoc_commands}"
    echo "Done. Output file is ${output_file}"
fi