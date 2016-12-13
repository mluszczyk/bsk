#!/bin/bash

set -xe

curl https://bsklabxx.mimuw.edu.pl && exit 1
curl https://bsklabxx.mimuw.edu.pl --cacert cacert.pem
curl https://vsolabxx.mimuw.edu.pl --cacert cacert.pem && exit 1

echo "Passed!"

