sudo-tid() {
	if ! (sed -n 2p /etc/pam.d/sudo | grep -q "tid")
	then
		sudo sed -i -e "2s/^/auth	   sufficient	  pam_tid.so\n/" /etc/pam.d/sudo
	else
		echo "TouchID already enabled for sudoing"
		return 1
	fi
}
