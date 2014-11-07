#!/bin/bash

# Michael Garate mg3626

############################
######## Constants #########
############################

BASE_DIR="$HOME/.question/"
USERS_PATH="/home/unixtool/data/question/users"

############################
######## Functions #########
############################

# create base directories if they do not yet exist
initialize_directories(){
    if [ ! -d "$BASE_DIR" ]; then
        echo "initializing directories..."
        mkdir "$BASE_DIR"
        cd "$BASE_DIR"
        mkdir questions
        mkdir answers
        mkdir votes
    fi
}

# returns 1 if invalid, 0 if valid
is_valid_question_or_answer(){
    text=$1

    # if the question with all spaces removed is empty
    if [ -z "${text//}" ]; then
        return 1
    fi

    # if the question contains ====
    if [[ ${text} == *====* ]]; then
        return 1
    fi

    return 0
}

# store a question as a file
# if a question already exists, exit with error
create_question(){
    if [ -f "$question_path" ]; then
        echo "Error: Question already exists." >&2
        exit 1
    fi

    if ! is_valid_question_or_answer "$question_text"; then
        echo "Error: Invalid question." >&2
        exit 1
    fi

    touch "$question_path"
    echo "$question_text" > "$question_path"
}

create_answer(){
    answer_path_without_file="${BASE_DIR}answers/${question_subdirectory}"
    answer_path="${answer_path_without_file}/${answer_name}"

    if ! is_valid_question_or_answer "$answer_text" ; then
        echo "Error: Invalid answer" >&2
        exit 1
    fi

    if [ -f "$answer_path" ]; then
        echo "Error: Answer already exists." >&2
        exit 1
    fi
    
    mkdir -p "$answer_path_without_file"

    touch "$answer_path"
    echo "$answer_text" > "$answer_path"
}

list_user_questions(){
    user=$1
    questions_path=/home/"${user}"/.question/questions/

    if [[ -e "$questions_path" ]] && [ -x "$questions_path" ]; then
        for question in /home/"$user"/.question/questions/*; do
            question=$(basename "$question")
            echo "${user}/${question}"
        done
    fi
}

list_questions(){
    if [ ! -z "$user" ]; then
        list_user_questions "$user"
        exit 0
    fi

    for user in $(cat "$USERS_PATH"); do
        list_user_questions "$user"
    done
    
    exit 0
}

vote_on_question_or_answer(){
    vote_direction="$1"
    question_id="$2"
    answer_id="$3"

    question_id_without_username=$(echo "${question_id}" | cut -d "/" -f2)
    username=$(echo "${question_id}" | cut -d "/" -f1)

    vote_path="${BASE_DIR}votes/${username}"

    if [ -z "$question_id" ]; then
        echo "Please supply a question id when voting." >&2
        exit 1
    fi


    if [ ! -d "$vote_path" ]; then
        mkdir "${vote_path}"
    fi

    if [ ! -z "$answer_id" ]; then
        vote_direction="${vote_direction} ${answer_id}"
    fi
    
    echo "${vote_direction}" >> "${vote_path}/${question_id_without_username}"

}

echo_votes_for_question_or_answer(){
    question_id="$1"
    answer_id="$2"

    if [ -z "$answer_id" ]; then
        answer_id="";
    fi
    
    votes_tmp_file="${BASE_DIR}.votes_tmp"
    touch "$votes_tmp_file"

    for user in $(cat "$USERS_PATH"); do
        vote_path="/home/${user}/.question/votes/${question_id}"

        if [ -f "$vote_path" ]; then
            vote_direction=$(awk -v answer_id="$answer_id" '
                BEGIN{ 
                    vote_direction=""
                 }{
                    if (answer_id == ""){
                        if ($2 ==""){
                            vote_direction=$1
                        }
                    } else {
                        if ($2 == answer_id){
                            vote_direction=$1
                        }
                    }
                }
                END {
                    print vote_direction
                }
                ' "$vote_path")

            if [ ! "$vote_direction" == "" ]; then
                echo "$vote_direction" >> "$votes_tmp_file"
            fi
        fi

    done

    vote_count=$(awk '
        {
            votes[$1] += 1
        }
        END {
            total = votes["up"] - votes["down"]
            print total
        }
    ' "$votes_tmp_file") 

    if [ -z "$answer_id" ]
    then
        echo "$vote_count"
    else
        echo "${vote_count} ${answer_id}"
    fi

    rm "$votes_tmp_file"

}

view_question(){
    question_id=$1
    question_user=$(echo "$question_id" | cut -d "/" -f1)
    question_id_without_username=$(echo "$question_id" | cut -d "/" -f2)

    question_path="/home/${question_user}/.question/questions/${question_id_without_username}"

    if [ ! -f "$question_path" ]; then
        echo "no such question: ${question_id}" >&2
        exit 1
    fi

    echo_votes_for_question_or_answer "$question_id"

    cat "$question_path"


    for answer_user in $(cat "$USERS_PATH"); do
        answer_dir="/home/${answer_user}/.question/answers/${question_id}/"

        if [ -d "$answer_dir" ]; then

            for answer_path in "${answer_dir}"*; do
                answer_id=$(basename "$answer_path")
                answer_id="${answer_user}/${answer_id}"

                echo "===="

                echo_votes_for_question_or_answer "$question_id" "$answer_id"
                cat "$answer_path"
            done
        fi
    done
}

############################
###### Main Execution ######
############################

initialize_directories

# create a question
if [ "$1" == "create" ]; then
    question_id="$2"
    question_text="$3"
    question_path="${BASE_DIR}questions/${question_id}"

    if [ -z "$question_text" ]; then
        read -p "Enter question: " question_text
    fi

    create_question
    exit 0
fi

# answer a question
if [ "$1" == "answer" ]; then
    question_subdirectory=$2
    answer_name=$3
    answer_text=$4

    if [ -z "$answer_text" ]; then
        read -p "Enter answer: " answer
    fi

    create_answer
    exit 0
fi

# list all questions or all questions for a particular user
if [ "$1" == "list" ]; then
    user=$2
    list_questions
    exit 0
fi

# vote on a question or answer
if [ "$1" == "vote" ]; then
    vote_on_question_or_answer $2 $3 $4
    exit 0
fi

if [ "$1" == "view" ]; then
    for arg in "$@"
    do
        if [ ! "$arg" == "$1" ]; then
            view_question "$arg"
        fi
    done
    exit 0
fi

## reset command for debugging 
if [ "$1" == "reset" ]; then
    rm -rf "$BASE_DIR"
    exit 0
fi


echo -e "Please provide arguments in the format: \n\tquestion option [args]" >&2
exit 1
