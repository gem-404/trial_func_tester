gadp() {

    # First check how many args are provided before the quotation marks begin
    # first_args=`cut -d" -f1`

    if [[ -f $1 ]]; then

        ext=`ls $1 | rev | cut -d "." -f 1 | rev`


        if [[ "$ext" == "py" ]]; then

            pylint_val=`pylint $1 | grep "rated" | cut -d "." -f 1 | grep -o '[0-9]*'`

            if [[ $pylint_val -lt 10 ]]; then
                echo "Failed to push python code, has a pylint score of $pylint_val "

                echo "Here are your mistakes"
                echo
                pylint $1 | rev | grep ":" | rev
                echo
            else
                git add "$1" && git commit -m "$2" -m "$3" && git push
            fi
        else 
            git add "$1" && git commit -m "$2" -m "$3" && git push
        fi

    # elif [[ -d $1 ]]; then
    #
    #     for file in $exts; do
    #
    #         ext=`ls $file | rev | cut -d "." -f 1 | rev`
    #
    #
    #         if [[ "$ext" == "py" ]]; then
    #
    #             pylint_val=`pylint $file | grep "rated" | cut -d "." -f 1 | grep -o '[0-9]*'`
    #
    #             if [[ $pylint_val -lt 10 ]]; then
    #                 echo "Failed to push python code, has a pylint score of $pylint_val "
    #
    #                 echo "Here are your mistakes"
    #                 echo
    #                 pylint $1 | rev | grep ":" | rev | grep -v "d"
    #                 echo
    #             fi
    #
    #         fi
    #
    #     done
    #
    # else
    #
    #     echo "Argument provided is neither a file here or a directory, fix it!"
    #
    fi
    #
    
}

fumbo(){
    if [[ -d $1 ]]; then

        for file in `ls $1`; do

            ext=`ls $file | rev | cut -d "." -f 1 | rev`

            if [ "$ext" == "py" ]; then

                pylint_val=`pylint $file | grep "rated" | cut -d "." -f 1 | grep -o '[0-9]*'`

                if [ $pylint_val -lt 10 ]; then
                    echo "$file has a rating of $pylint_val, fix it!"
                    break
                fi
            else
                git add "$1" && git commit -m "$2" -m "$3" && git push
            fi
        done;

    fi

}
