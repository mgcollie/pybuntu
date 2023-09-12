#!/usr/bin/env bash
groupadd -r $NOMACHINE_USER -g 433 \
&& useradd -u 431 -r -g $NOMACHINE_USER -d /home/$NOMACHINE_USER -s /bin/bash -c "$NOMACHINE_USER" $NOMACHINE_USER \
&& adduser $NOMACHINE_USER sudo \
&& mkdir /home/$NOMACHINE_USER \
&& chown -R $NOMACHINE_USER:$NOMACHINE_USER /home/$NOMACHINE_USER \
&& echo $NOMACHINE_USER':'$PASSWORD | chpasswd \
&& mkdir /home/$NOMACHINE_USER/Desktop \
&& cp /launchers/* /home/$NOMACHINE_USER/Desktop \
&& chown -R $NOMACHINE_USER:$NOMACHINE_USER /home/$NOMACHINE_USER/Desktop \
&& chmod -R +x /home/$NOMACHINE_USER/Desktop \
&& export XDG_RUNTIME_DIR=/home/$NOMACHINE_USER \
&& /etc/NX/nxserver --startup --virtualgl
tail -f /usr/NX/var/log/nxserver.log
