#!/bin/bash
if [ ! -f /.root_pw_set ]; then
	/root_pw_set.sh
fi

exec /usr/sbin/sshd -D
