#!/bin/sh
# lazy, I know...
service rsyslog start
service xinetd start

${PREFIX:-/usr/local/docker}/bin/docker-entrypoint.sh /usr/sbin/cupsd -f
