# running as guest
# assume we have configured sudo
# Michał Łuszczyk, ml360314

set -x
set -e

function prepareapt() {
    sudo apt-get update
    sudo apt-get install sshfs
}

function prepareguestaccount() {
    sudo useradd -m guest
    sudo passwd guest
}

# Klucze i konfiguracja klienta.
function setupclient() {
    # Stwórz guestowi parę kluczy SSH, klucz prywatny chroniony hasłem. 
    ssh-keygen -f ~/.ssh/id_rsa_students

    # Umieść klucz publiczny na komputerze students.
    cat <<'EOF' > ~/.ssh/config
    Host students.mimuw.edu.pl
        User ml360314
        IdentityFile ~/.ssh/id_rsa_students
EOF

    # Skonfiguruj klienta ssh tak, aby Twój login na students był używany jako
    # domyślna nazwa użytkownika, gdy guest łączy się ze students, oraz aby
    # używany był odpowiedni klucz.
    ssh-copy-id -i ~/.ssh/id_rsa_students students.mimuw.edu.pl 
}

# Skonfiguruj serwer SSH
function setupssh() {
    sudo install -m 0644 -o root -g root sshd_config /etc/ssh/sshd_config
    sudo service ssh restart
}

# Kopiowanie i montowanie
function setupmounts() {
    mkdir -p ~/Obrazy
    sshfs students.mimuw.edu.pl:/home/students/inf/PUBLIC/BSK/Obrazy ~/Obrazy
    mkdir ~/BSK
    rsync -avz students.mimuw.edu.pl:/home/students/inf/PUBLIC/BSK ~/BSK/
}

prepareapt
prepareguestaccount
setupclient
setupssh
setupmounts

