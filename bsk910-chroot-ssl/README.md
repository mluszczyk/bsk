Rozwiązanie zadania chroot/SSL z BSK
====================================

Michał Łuszczyk, 2016

Docker
------

Docker instaluje serwer HTTP razem z obsługą SSL-a, kluczem i certyfikatami.
Można użyć poniższych poleceń:

    docker build -t bsk/apache .
    docker run -p 80:80 -p 443:443 --name bsk-apache bsk/apache

Testowanie
----------

Do testowania został przygotowany specjalny skrypt `test_curl.sh`.

Aby przetestować konfiguracje należy dodać plik cacert.pem do przeglądarki.

Najłatwiej użyć przeglądarki curl. Oto wywołania z różnymi opcjami, przy założeniu
że vsolabxx.mimuw.edu.pl oraz bsklabxx.mimuw.edu.pl wskazują na hosta dockera.

	$ ./test_curl.sh 
	+ curl https://bsklabxx.mimuw.edu.pl
	curl: (60) SSL certificate problem: Invalid certificate chain
	[ukryty output]
	+ curl https://bsklabxx.mimuw.edu.pl --cacert cacert.pem
	bsk apache
	+ curl https://vsolabxx.mimuw.edu.pl --cacert cacert.pem
	curl: (51) SSL: certificate verification failed (result: 5)


Zmiana certyfikatów
-------------------

Aby wygenerować nowe certyfikaty można użyć skryptu `change_certs.sh`.
