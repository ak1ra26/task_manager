#!/bin/bash

# Path to the tasks file
TASK_FILE="$HOME/.cache/tasks.txt"
VERBOSE=false
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Usage information function
function usage {
    echo "Usage: $0 [-h|--help] [-v|--verbose] [-f|--file <task_file>]"
    echo "Options:"
    echo "  -h, --help              Display this usage information"
    echo "  -v, --verbose           Enable verbose output"
    echo "  -f, --file <task_file>  Path to the task file (default: $TASK_FILE)"
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) usage; exit 0;;
        -v|--verbose) VERBOSE=true; shift ;;
        -f|--file) TASK_FILE="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Verbose output function
function verbose {
    if [ "$VERBOSE" = true ]; then
        echo "$@"
    fi
}

# check if the task file exists, create it if it doesn't
verbose "Checking if tasks file exists"
if [ ! -f "$TASK_FILE" ]; then
    echo "Task file not found. Do you want to create it? (y/n)"
    read create_file
    if [ "$create_file" = "y" ]; then
        touch "$TASK_FILE"
        verbose "Task file created"
    else
        echo "Exiting script."
        exit 1
    fi
    else
    verbose "$(echo -e "${GREEN}OK${NC}")"
fi

# Function to clear the screen
function clear_screen {
    if [ "$VERBOSE" = true ]; then
        echo "Clearing screen is disabled in verbose mode."
    else
        clear
    fi
}

# Display the list of tasks
function display_tasks {
    verbose "Displaying tasks"
    echo "Tasks:"
    if [ -s "$TASK_FILE" ]; then
        cat -n "$TASK_FILE"
    else
        echo "No tasks yet"
    fi
}

# Add a new task to the list
function add_task {
    verbose "Adding new task"
    read -p "Enter task (q to return to main menu): " task
    if [[ "$task" = "q" || "$task" = "й" ]]; then
        return
    fi
#     echo "$(date '+%Y-%m-%d %H:%M') $task" >> "$TASK_FILE" # if it is necessary to keep track of the task addition time.
    echo "$task" >> "$TASK_FILE"
    echo "Task added."
}

# Edit an existing task
function edit_task {
    verbose "Editing a task"
    read -p "Enter the number of the task to edit (q to return to main menu): " task_num
    if [[ "$task_num" = "q" || "$task" = "й" ]]; then
        return
    fi
    if [ "$(wc -l < "$TASK_FILE")" -lt "$task_num" ]; then
        echo -e "${RED}Invalid task number.${NC}"
        return
    fi

    # create a temporary file for editing the task
    tmp_file=$(mktemp)
    sed -n "${task_num}p" "$TASK_FILE" > "$tmp_file"

    # open the temporary file in nano for editing
    nano "$tmp_file"

    # check if the task contains multiple lines
    if [ "$(cat "$tmp_file" | wc -l)" -gt 1 ]; then
        clear_screen
        echo -e "${RED}The edited task contains multiple lines:${NC}"
        cat "$tmp_file"
        echo -e "${RED}Changes not saved.${NC}"
    else
        # replace the task in the original file with the edited task from the temporary file
        edited_task=$(cat "$tmp_file")
        sed -i "${task_num}s/.*/$edited_task/" "$TASK_FILE"
        clear_screen
        display_tasks
        echo -e "\nTask edited."
    fi

    # remove the temporary file
    rm "$tmp_file"
}

# Remove a task from the list
function delete_task {
    verbose "Deleting a task"
    read -p "Enter the number of the task to delete (q to return to main menu): " task_num
    if [[ "$task_num" = "q" || "$task_num" = "й" ]]; then
        return
    fi
    if [ "$(wc -l < "$TASK_FILE")" -lt "$task_num" ]; then
        echo -e "${RED}Invalid task number.${NC}"
        return
    fi
    sed -n "${task_num}p" "$TASK_FILE" | awk '{print "\033[0;31m"$0"\033[0m"}'
    read -p "Are you sure you want to delete this task? (y/n): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        sed -i "${task_num}d" "$TASK_FILE"
        clear_screen
        display_tasks
        echo -e "\nTask deleted."
    else
        clear_screen
        display_tasks
    fi
}

# Main loop
while true; do
    printf "What do you want to do? (${RED}d${NC}isplay, ${RED}a${NC}dd, ${RED}e${NC}dit, ${RED}r${NC}emove, ${RED}q${NC} - exit): "
    read choice
    clear_screen
    case $choice in
        d|в)
            display_tasks;;
        a|ф)
            add_task;;
        e|у)
            display_tasks
            edit_task;;
        r|к)
            display_tasks
            delete_task;;
        q|й)
            break;;
        *)
            echo -e "${RED}Invalid choice.${NC}";;
    esac
done
