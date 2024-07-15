$!/bin/bash
    #adapter selection
    function get_interfaces {
        interfaces=$(sudo iwconfig 2>/dev/null| grep -E 'IEEE 802.11|unassociated'  | awk '{print $1}')
        echo "$interfaces"
    }
    get_interfaces