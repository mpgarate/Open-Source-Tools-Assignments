#!/bin/bash

############################
######## Constants #########
############################

BASE_DIR="$HOME/.question/"

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

# store a question as a file
# if a question already exists, exit with error
create_question(){
    question_id="$1"
    question_text="$2"
    question_path="${BASE_DIR}questions/${question_id}"

    if [ ! -f "$question_path" ]
    then
        touch "$question_path"
        echo "$question_text" >> "$question_path"
    else
        echo "Error: Question already exists." >&2
        exit 1
    fi
}

# returns 1 if invalid, 0 if valid
is_valid_question(){
    question_text="$1"

    # if the question with all spaces removed is empty
    if [ -z "${question_text//}"]; then
        return 1
    fi

    # if the question contains ====
    if [[ ${question_text} == *====* ]]; then
        return 1
    fi

    return 0
}

############################
###### Main Execution ######
############################

initialize_directories


if [ "$1" == "create" ]; then
    question_text=$3
    if [ -z "$question_text" ]; then
        read -p "Enter question: " question_text
    fi
    create_question "$2" "$question_text"
fi
