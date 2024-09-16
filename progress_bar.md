# How to create progressbar in shell

[https://www.baeldung.com/linux/command-line-progress-bar]

##S Script

```bash
!/bin/bash

bar_size=40
bar_char_done="#"
bar_char_todo="-"
bar_percentage_scale=2

function show_progress {
    current="$1"
    total="$2"

    # calculate the progress in percentage 
    percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    # The number of done and todo characters
    done=$(bc <<< "scale=0; $bar_size * $percent / 100" )
    todo=$(bc <<< "scale=0; $bar_size - $done" )

    # build the done and todo sub-bars
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    # output the bar
    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"

    if [ $total -eq $current ]; then
        echo -e "\nDONE"
    fi
}
```

## Usage

```bash
$ cat heavy_work.sh
#!/bin/bash

source progress_bar.sh

tasks_in_total=37
for current_task in $(seq $tasks_in_total) 
    do
    sleep 0.2 #simulate the task running
    show_progress $current_task $tasks_in_total
done
```

some customization
```bash
#!/bin/bash

source progress_bar.sh

# bar customization
bar_size=70
bar_char_done="|"
bar_char_todo=" "
bar_percentage_scale=4

tasks_in_total=37
for current_task in $(seq $tasks_in_total) 
```

[https://www.geeksforgeeks.org/bc-command-linux-examples/]
