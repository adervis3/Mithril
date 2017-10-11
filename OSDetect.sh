#!/bin/sh


##############################
#                            #
# Operating System Detection #
#                            #
##############################


rel="\"rhel fedora\""
case $(uname) in
    Linux)
        case $(awk -F= '/ID_LIKE=/{print $2}' /etc/*release) in
        #awk '{print$9}' /proc/version
            debian)
                echo "Debian"
                OS="Debian";;
            $rel)
                echo "Redhat"
                OS="Rhel";;
            archlinux)
                echo "Arch"
                OS="Arch";;
            *)
                echo "Other GNU/Linux Distro"
                OS="Other"
        esac;;
    *)
        echo "Only GNU/Linux"
        #exit 1
esac
