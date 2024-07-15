#!/bin/bash
    function get_interfaces {
        interfaces=$(sudo iwconfig 2>/dev/null| grep -E 'IEEE 802.11|unassociated'  | awk '{print $1}')
        echo "$interfaces"
    }
    get_interfaces

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

    #adapter mode change to monitor    
    function change_adapter_mode {
        sudo airmon-ng check kill
        sudo airmon-ng start "$adapter"
    }
    change_adapter_mode

    #available networks scan
    function get_networks {
        output_file="scan/$adapter-scan"
        sudo airodump-ng --output-format csv -w $output_file $adapter
        sleep 1
        latest_scan=$(ls -lt scan | head -n 2 | tail -n 1 | awk '{print $9}')
        mapfile -t network_list < <(sudo awk -F, '$1 && $4 && $6 && $14 {print $1, $4, $6, $14}' "scan/$latest_scan")

        echo "---------------"
        echo "---------------"
        echo "please choose a network from the list"
        echo "---------------"
        echo "---------------"
        count=1
        for i in "${!network_list[@]}"; do
            if (( i + 1 > 2 )); then
                echo "$((count))) ${network_list[$i]}"
                ((count++))
            fi
        done
    }
    get_networks

