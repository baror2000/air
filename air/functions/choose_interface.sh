$!/bin/bash
    #adapter selection
    function choose_interface {
        interfaces=($(get_interfaces))
        if [ ${#interfaces[@]} -eq 0 ]; then
            read -p "No wireless interfaces found. please connect an adapter and input R when ready to reload. Press any other key to exit:   " reload
            if [[ $reload == [rR] ]]; then
                get_interfaces
                choose_interface
            else
            exit 1
            fi
        
        elif [ ${#interfaces[@]} -eq 1 ]; then
            adapter=($interfaces);
        
        else echo "Choose a wireless interface:  "
            for i in "${#interfaces[@]}"; do
                echo "$((i + 1))) ${interfaces[$i]}"
            done

        read -p "Enter yout choice [1-${#interfaces[@]}]:   " adapter 

            if [[ "$adapter" -gt 1 && "$adapter" -le ${#interfaces[@]} ]]; then
                adapter=${interfaces[$((adapter -1))]}
            else
                read -p "Invalid choise. Please enter R to try again or any key to exit    " reload
                if $reload -eq [rR]; then get_interfaces; else exit 1; fi;
            fi    
        fi
    }
    choose_interface