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

    if [ -z "answer" ]; then
        read -p "Enter answer: " answer
    fi

    create_answer
    exit 0
fi

## reset command for debugging 
if [ "$1" == "reset" ]; then
    rm -rf "$BASE_DIR"
    exit 0
fi
