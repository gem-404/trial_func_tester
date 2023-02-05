#!/bin/bash

# Will git add files; git commit and git push.
# Caveat... Must check if any of the files in the git add contains a .py extension,
# and if it does, run it through pylint. Only add the file if it has a pylint score of 10.00/10.00
#
# Of course it should leave out the file, and add others, commit them and push 'em.
# Then it should ask me to make the necessary changes to the python files.

# Check for python files in all the arguments given.

files=("$@")

num_of_elems=${#files[@]}

message=${files[-1]} # alternatively, you can get the last value of the array by using -> message=${files[@]: -1}

# unset files[$num_of_elems-1]

unset files[${#files[@]}-1]

linter_failed_files=()

# Check the linter_failed_files if it has any files to be corrected.
failed_files_checker() {

    num_of_failed_elems=${#linter_failed_files[@]}
    lint_command=`pylint $file | rev | grep ":" | rev`

    if [ $num_of_failed_elems -gt 0 ]; then

        for file in "${linter_failed_files[*]}"; do

            echo "********************** $file **********************"
            echo "Here is what to change in the $file file" 
            echo $lint_command | head -n $(($(lint_command | wc -l) -1))
            echo
            echo tail -1 $lint_command
            echo
            echo "********************** $file **********************"
            echo

        done
    fi
}


# Check the rating of a python file using pylint
pylinter() {
    pylint_val=`pylint $1 | grep "rated" | cut -d "." -f 1 | grep -o '[0-9]*'`

    if [ $pylint_val -lt 10 ]; then
        return 1
    else
        return 0
    fi
}

# echo last message now is ${files[@]: -1}
pyfiles() {

    count=0
    # go through the files array
    for file in "${files[@]}"; do

        let count="$count+1"

        echo $file

        ext="${file##*.}"

        if [ "$ext" == "py" ]; then

            # Check the linter's rating...
            if ! pylinter $file; then
                # unset the file from the rest of the files
                unset files[$count]
                # add it in another array, say failed python files
                linter_failed_files+=($file)
            fi

        fi

    done

}

# git add, commit, and push.
gadp() {

    pyfiles
    failed_files_checker
    echo "git add ${files[*]}; git commit -m $message; git push" # One can also use ${files[@]}

}

