set -e

function setupuserdir {
    user=$1
    class=$2

    echo $user $class

    useradd -m $user
    adduser $user $class
    
    user_home=/home/$user
    user_public=$user_home/public

    chmod 0700 $user_home
    setfacl -m group:$class:--x $user_home
    setfacl -m user:staff:--x $user_home
    setfacl -m user:master:--x $user_home

    mkdir $user_public
    chown $user:$user $user_public
    setfacl -m group:$class:--x $user_public
    setfacl -d -m group:$class:r-x $user_public
    setfacl -m group:staff:r-x $user_public
    setfacl -d -m group:staff:rwx $user_public
    setfacl -d -m user:master:rwx $user_public
    
}

function setupclass {
    class=$1
    start=$2
    end=$3

    echo $class $start $end

    groupadd $class

    for user in `seq $start $end`; do
	setupuserdir $user $class
    done
}

adduser master
addgroup staff

setupclass 1e 424201 424215
setupclass 2e 424401 424415
setupclass 3e 424601 424615 
