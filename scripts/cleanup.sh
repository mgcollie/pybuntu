apt clean -y
apt autoclean -y
apt autoremove --purge -y
rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /etc/systemd