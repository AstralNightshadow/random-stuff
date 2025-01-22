#!/bin/bash

#OS info stuff

#some stuff to do things in order
function osinfo {
    getinputos
    decisionos || return 1
}

#menu for OS stuff
function getinputos {
    echo ""
    echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    echo "█  OS Information  █"
    echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    echo "#####################"
    echo "# Possible actions: #"
    echo "#####################"
    echo " q - Quit"
    echo "00 - Exit to main menu"
    echo "01 - OS information"
    echo "02 - IP-adress"
    echo "03 - Memory usage"
    echo "04 - Disk usage"
    echo "05 - CPU usage"
    echo "06 - Running processes"
    echo "07 - Internet connectivity (ping)"
    echo "08 - Internet connectivity (http)"
    echo "09 - Speedtest (needs to be installed first)"
    echo "10 - Current logged on User"
    echo "11 - Uptime"
    echo "12 - Temperature (limited use on VMs)"
    echo "13 - Latest boots and logins"
    echo "14 - Timezone information"
    echo "15 - List USB devices"
    echo "16 - Real-time System usage (q to exit)"
    echo "17 - IP routing table"
    echo "18 - ARP tabel"
    echo "19 - I/O statistics"
    echo "20 - Hostname and status"
    echo "00 - Exit to main menu"
    echo " q - Quit"
    echo ""
    read -p "Input your desired number: " inputst
}

#all decision for OS info
function decisionos {
    if [[ "$inputst" == "q" || "$inputst" == "exit" ]]
    then
        quit
    fi
    
    test='^[0-9]+$'
    if ! [[ $inputst =~ $test ]]
    then
        echo "Error: Input invalid, please try again."
        return
    fi
    
    input=$((10#$inputst))
    if [[ $input == 0 || "$input" == "00" ]]
    then
        return 1
    elif [[ $input == 1 ]]
    then
        cat /proc/version
    elif [[ $input == 2 ]]
    then
        ifconfig eth0 | grep 'inet '
    elif [[ $input == 3 ]]
    then
        free -h
        echo ""
        read -s -p "For more details press 1: " details
        if [[ "$details" == "1" || "$details" == "01" ]]
        then
            echo ""
            vmstat -s -S M
        fi
    elif [[ $input == 4 ]]
    then
        df -h | awk 'NR==1 || / \/$/'
    elif [[ $input == 5 ]]
    then
        iostat
    elif [[ $input == 6 ]]
    then
        ps
        echo ""
        read -n 1 -s -p "For all processes press 1: " details
        if [[ "$details" == "1" || "$details" == "01" ]]
        then
            echo ""
            ps -aux
        fi
    elif [[ $input == 7 ]]
    then
        ping -c 4 8.8.8.8
    elif [[ $input == 8 ]]
    then
        if [[ $(curl -s -L https://www.bbw.ch | grep 'alt="BBW Logo"') != "" ]]
        then
            echo "successfully reached the internet."
            echo ""
            read -n 1 -s -p "For more details press 1: " details
            if [[ "$details" == "1" || "$details" == "01" ]]
            then
                echo ""
                curl -L https://www.bbw.ch | grep 'alt="BBW Logo"'
            fi
        else
            echo "Internet couldn't be reached"
            echo ""
            read -n 1 -s -p "For more details press 1: " details
            if [[ "$details" == "1" || "$details" == "01" ]]
            then
                echo ""
                curl -L https://www.bbw.ch | grep 'alt="BBW Logo"'
            fi
        fi
    elif [[ $input == 9 ]]
    then
        echo ""
        echo "Testing the internet connection:"
        {
            speedtest-cli
            } || {
            install-speedtest &&
            echo "Testing the internet connection:" &&
            echo "" &&
            speedtest-cli
            } || {
            echo "";
            echo "Installation failed."
        }
    elif [[ $input == 10 ]]
    then
        who
        echo ""
        read -n 1 -s -p "For all logins press 1: " details
        if [[ "$details" == "1" || "$details" == "01" ]]
        then
            echo ""
            who -a
        fi
    elif [[ $input == 11 ]]
    then
        uptime
    elif [[ $input == 12 ]]
    then
        sensors
    elif [[ $input == 13 ]]
    then
        last
    elif [[ $input == 14 ]]
    then
        timedatectl
    elif [[ $input == 15 ]]
    then
        lsusb
    elif [[ $input == 16 ]]
    then
        top
        return
    elif [[ $input == 17 ]]
    then
        ip route
    elif [[ $input == 18 ]]
    then
        arp
    elif [[ $input == 19 ]]
    then
        iostat --human
    elif [[ $input == 20 ]]
    then
        hostnamectl
        echo ""
        read -n 1 -s -p "For more information about the status (q to quit, space to scroll) press 1: " details
        if [[ "$details" == "1" || "$details" == "01" ]]
        then
            echo ""
            systemctl status
        fi
    elif [[ $input == 69 ]]
    then
        echo "It is a nice number but unfortunately:"
        echo "Error: Input invalid, please try again."
        return
    else
        echo "Error: Input invalid, please try again."
        return
    fi
    echo
    read -n 1 -s -p "Press any key to continue..."
}

#Installing speedtest-cli
function install-speedtest {
    echo ""
    echo "Speedtest-cli has not been detected."
    read -n 1 -p "Do you wish to install speedtest-cli using sudo rights? (Y/N)" consent
    if [[ $consent == "Y" || $consent == "y" ]]
    then
        {
            echo "" &&
            sudo apt install speedtest-cli &&
            echo "" &&
            echo "Successfully installed the tool." &&
            echo "" &&
            return
            } || {
            echo "";
            echo "An Error has occured, returning.";
            echo "";
            return 1
        }
    elif [[ $consent == "N" || $consent == "n" ]]
    then
        echo ""
        echo ""
        echo "Operation Canceled, returning."
        return 1
    else
        echo "Error invalid input, returning."
        return 1
    fi
}


#Folder management stuff

#some stuff to do things in order
function managefolder {
    getinputfolder
    decisionfolder || return 1
}

#menu for folder stuff
function getinputfolder {
    echo ""
    echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    echo "█  Folder Management  █"
    echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    echo "#####################"
    echo "# Possible actions: #"
    echo "#####################"
    echo "01 - List content of a directory"
    echo "02 - Create Folder"
    echo "03 - Delete Folder"
    echo "04 - Delete Files"
    echo "00 - Exit to main menu"
    echo " q - Quit"
    echo ""
    read -p "Input your desired number: " folderinputst
}

function decisionfolder {
    if [[ "$folderinputst" == "q" || "$folderinputst" == "exit" ]]
    then
        quit
    fi
    
    test='^[0-9]+$'
    if ! [[ $folderinputst =~ $test ]]
    then
        echo "Error: Input invalid, please try again."
        return
    fi
    
    folderinput=$((10#$folderinputst))
    if [[ $folderinput == 0 || "$folderinput" == "00" ]]
    then
        return 1
    elif [[ $folderinput == 1 ]]
    then
        echo ""
        read -p "Input a directory to read out: " folderlsloc
        echo ""
        ls $folderlsloc
    elif [[ $folderinput == 2 ]]
    then
        echo ""
        read -n 1 -s -p "To add subfolder functionality press 1: " subfolder
        echo ""
        read -p "Input the folder path: " foldermkloc
        if [[ "$subfolder" == "1" || "$subfolder" == "01" ]]
        then
            echo ""
            {
                mkdir -p $foldermkloc &&
                echo "Successfully created folder"
                } || {
                echo "";
                echo "An Error has occured, please check the formating, and try again."
            }
        else
            echo ""
            {
                mkdir $foldermkloc &&
                echo "Successfully created folder"
                } || {
                echo "";
                echo "An Error has occured, please check the formating, and try again."
            }
        fi
    elif [[ $folderinput == 3 ]]
    then
        echo ""
        read -p "Input the folder path: " folderrmloc
        echo ""
        read -n 1 -p "To also files and subfolders press 1: " purge
        if [[ "$purge" == "1" || "$purge" == "01" ]]
        then
            echo ""
            {
                rm -r $folderrmloc &&
                echo "Successfully deleted folder"
                } || {
                echo "";
                echo "An Error has occured, please check the formating, and try again."
            }
        else
            echo ""
            {
                rmdir $foldermkloc &&
                echo "Successfully deleted folder"
                } || {
                echo "";
                echo "An Error has occured, please check the formating, and try again."
            }
        fi
    elif [[ $folderinput == 4 ]]
    then
        echo ""
        read -p "Input the file path: " filermloc
        echo ""
        {
            rm $filermloc &&
            echo "Successfully deleted file"
            } || {
            echo "";
            echo "An Error has occured, please check the formating, and try again."
        }
    elif [[ $folderinput == 69 ]]
    then
        echo "It is a nice number but unfortunately:"
        echo "Error: Input invalid, please try again."
        return
    else
        echo "Error: Input invalid, please try again."
        return
    fi
    echo ""
    read -n 1 -s -p "Press any key to continue..."
}


#User management stuff

#some stuff to do things in order
function manageuser {
    getinputuser
    decisionuser || return 1
}

#menu for folder stuff
function getinputuser {
    echo ""
    echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    echo "█  User Management  █"
    echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    echo "#####################"
    echo "# Possible actions: #"
    echo "#####################"
    echo "01 - Create User"
    echo "02 - Change password of User"
    echo "03 - Delete User"
    echo "04 - Show current User"
    echo "05 - Show logins and boots"
    echo "06 - Show all Users"
    echo "00 - Exit to main menu"
    echo " q - Quit"
    echo ""
    read -p "Input your desired number: " userinputst
}

function decisionuser {
    if [[ "$userinputst" == "q" || "$userinputst" == "exit" ]]
    then
        quit
    fi
    
    test='^[0-9]+$'
    if ! [[ $userinputst =~ $test ]]
    then
        echo "Error: Input invalid, please try again."
        return
    fi
    
    userinput=$((10#$userinputst))
    if [[ $userinput == 0 || "$userinput" == "00" ]]
    then
        return 1
    elif [[ $userinput == 1 ]]
    then
        echo ""
        read -p "Input the username: " crtusr
        echo ""
        {
            sudo useradd &&
            sudo passwd "$crtusr" &&
            echo "" &&
            echo "Successfully created $crtusr"
            } || {
            echo ""
            echo "An Error has occured."
        }
    elif [[ $userinput == 2 ]]
    then
        echo ""
        read -p "Input the username: " passchng
        if [[ "$passchng" == "root" ]]
        then
            echo ""
            echo "#####################################################"
            echo "#                      Warning                      #"
            echo "#####################################################"
            echo "#                                                   #"
            echo "# You are trying to change the password of Root!    #"
            echo "# This Action will break your system!               #"
            echo "# If you still wish to do it, then do it manually.  #"
            echo "#                                                   #"
            echo "#####################################################"
            echo ""
        else
            sudo passwd "$passchng" || echo "" && echo "An Error has occured."
        fi
    elif [[ $userinput == 3 ]]
    then
        echo ""
        read -p "Input the username: " deluser
        echo ""
        read -n 1 -p "To also delete Home directory and stop all running processes press 1: " murder
        if [[ "$deluser" == "root" ]]
        then
            echo ""
            echo "#####################################################"
            echo "#                      Warning                      #"
            echo "#####################################################"
            echo "#                                                   #"
            echo "# You are trying to delete the Root account!        #"
            echo "# Deleting the root account will break your system! #"
            echo "# If you still wish to delete root do it manually.  #"
            echo "#                                                   #"
            echo "#####################################################"
            echo ""
        elif [[ "$murder" == "1" || "$murder" == "01" ]]
        then
            echo ""
            {
                sudo userdel -r -f "$deluser" &&
                echo "Successfully deleted user"
                } || {
                echo "";
                echo "An Error has occured, please try again."
            }
        else
            echo ""
            {
                sudo userdel "$deluser" &&
                echo "Successfully deleted user"
                } || {
                echo "";
                echo "An Error has occured, please try again."
            }
        fi
    elif [[ $userinput == 4 ]]
    then
        who
        echo ""
        read -n 1 -s -p "For all logged in users press 1: " details
        if [[ "$details" == "1" || "$details" == "01" ]]
        then
            echo ""
            who -a
        fi
    elif [[ $userinput == 5 ]]
    then
        last
    elif [[ $userinput == 6 ]]
    then
        cut -d: -f1 /etc/passwd
    elif [[ $userinput == 69 ]]
    then
        echo "It is a nice number but unfortunately:"
        echo "Error: Input invalid, please try again."
        return
    else
        echo "Error: Input invalid, please try again."
        return
    fi
    echo ""
    read -n 1 -s -p "Press any key to continue..."
}



#Main menu
function main_menu {
    echo ""
    echo "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    echo "█  Main Menu  █"
    echo "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    echo "#####################"
    echo "# Possible actions: #"
    echo "#####################"
    echo "What do you wish to do?"
    echo ""
    echo "01 - Get OS information"
    echo "02 - Manage Folders"
    echo "03 - Manage Users"
    echo "00 - Exit"
    echo " q - Quit"
    echo ""
    read -p "Input your desired number: " maininputst
    
    
    if [[ "$maininputst" == "q" || "$maininputst" == "exit" ]]
    then
        quit
    fi
    
    test='^[0-9]+$'
    if ! [[ $maininputst =~ $test ]]
    then
        echo "Error: Input invalid, please try again."
        return
    fi
    
    maininput=$((10#$maininputst))
    if [[ $maininput == 0 || "$maininput" == "00" ]]
    then
        return 1
    elif [[ $maininput == 1 ]]
    then
        while :
        do
            osinfo || break
        done
    elif [[ $maininput == 2 ]]
    then
        while :
        do
            managefolder || break
        done
    elif [[ $maininput == 3 ]]
    then
        while :
        do
            manageuser || break
        done
    elif [[ $maininput == 69 ]]
    then
        echo "It is a nice number but unfortunately:"
        echo "Error: Input invalid, please try again."
        return
    else
        echo "Error: Input invalid, please try again."
        return
    fi
    echo ""
}

#quit the programm
function quit {
    echo ""
    echo "Thanks for using this thing!"
    echo "Have a nice day/night (if it's night, maybe go to sleep)"
    exit
}


echo ""
echo "################################"
echo "# Welcome to my little project #"
echo "################################"
echo ""
echo "Originally this was supposed to be way shorter and simpler, especially in the OS section."
echo "Buuut then I got bored and it kinda went way out of Hand from there..."
echo ""
echo "Anyway, enjoy!"
echo ""
read -n 1 -s -p "Press any key to start..."

while :
do
    main_menu || quit
done