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

create_question(){
    question_id="$1"
    question_text="$2"
    question_path="${BASE_DIR}questions/${question_id}"

    if [ ! -f "$question_path" ]; then
        touch "$question_path"
        echo "$question_text" >> "$question_path"
    fi
}

############################
###### Main Execution ######
############################

initialize_directories

if [ "$1" == "create" ]; then
    create_question "$2" "$3"
fi
