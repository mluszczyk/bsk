Available commands
==================

vagrant ssh server -c "/vagrant/setup_server.sh"
vagrant ssh client -c "/vagrant/setup_client.sh"
vagrant ssh client -c "/vagrant/add_cert.sh cert_name first_name last_name email"
vagrant ssh server -c "/vagrant/run_server.sh"
vagrant ssh client -c "/vagrant/run_client.sh ip cert_name"
vagrant ssh server -c "/vagrant/revoke_cert.sh cert_name"

Testing commands
================

vagrant ssh server -c "nc -l 1234"
vagrant ssh client -c "nc 10.0.0.1 1234 -vvv"
