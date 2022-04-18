#!/bin/bash
#Cyb3rPatr!0t!!
if [ "$EUID" -ne 0 ] ;
	then echo "Run as Root"
	exit
fi

##Cronjobs
#check to make sure sudo su command asks for password
#check runlevels
#Look for any repeating UID or GID
#Make sure no programs have a /bin/sh or /bin/bash
#Only root should have a UID and GID of 0

##CONFIGURE AUDITD
#add dpkg --purge or apt purge
#change umask to 027 /etc/login.defs
#protect single user mode
#password protect grub
#fail2ban
#https://cisofy.com/controls/NETW-2705/

clear
#Functions
#users   ---   removes unecessary users and secures passwords
#passPolicy   ---   sets password policy
#autoUpdates  ---   configure update sources and install
#sysctlConf   ---   protects networking
#hackingTools   ---   removes hacking tools
#firewallConfig   ---   blocks ports using iptables
#listServices
#mediaFiles
#secureLamp
#malwareScan


echo "# Ubuntu Security"
echo "## DO THE FORENCICS QUESTIONS"
echo "## READ THE SCENARIO"
if [ ! -d ~/Desktop/ScriptOutputs ] ;then
	mkdir ~/Desktop/ScriptOutputs
fi
if [ -d ~/Desktop/ScriptOutputs/log ] ;then
	: > ~/Desktop/ScriptOutputs/log
fi

printf "\n# 'n' to not update device, enter for anything else: "
read choice

start(){
	autoUpdates
	users
	passPolicy
	sysctlConf
	hackingTools
	firewallConfig
	secureSSH
	firefoxConfig
	secureLamp
	#malwareScan
	listServices
	mediaFiles
	printf "\n## Remove Files That are not supposed to be on the device\n"
	printf "\n## REREAD README:\n\tadd users\n\trecheck services\n\tconfigure services\n\tAdobe Flash Plugin (Shockwave Flash)\n\tFirefox PLUGINS\n"
}

users(){
	printf "\n### User Configurations:\n"
        printf "# Changing User Passwords\n"
	pass="Cyb3rPatr!0t!!"
	for i in $(ls /home); do chpasswd <<< "$i:$pass" &>> ~/Desktop/ScriptOutputs/log; done && {
		printf "# All user passwords have been updated to: $pass \nand been put in your clipboard\n"
		printf "$pass" | xsel -b
	} || printf "# Password change to fail\n"
	sed -i 's/NOPASSWD://' /etc/sudoers
	chmod 640 /etc/shadow
	passwd -l root
	printf "#Starting user edits, this will take a moment\n"
	printf "### Users - python pip & beautifulsoup install\n" >> ~/Desktop/ScriptOutputs/log
	apt install python3-pip -y &>> ~/Desktop/ScriptOutputs/log && {
		python3 -m pip install beautifulsoup4 &>> ~/Desktop/ScriptOutputs/log && {
			printf "\n# URL of ReadMe: "
			read url
			printf "# Changing User Permisions, this will take a moment\n"
			python3 rmUsers.py $url && printf "# Users have been edited\n" || printf "##ERROR running python script, DO MANUALLY\n"
		}
	} || {
		killall apt-get
		killall apt
		rm /var/lib/apt/lists/lock
		rm /var/cache/apt/archives/lock
		rm /var/lib/dpkg/lock
		printf "### Users RETRY - python pip & beautifulsoup install\n" >> ~/Desktop/ScriptOutputs/log
		apt install python3-pip -y &>> ~/Desktop/ScriptOutputs/log && {
			python3 -m pip install beautifulsoup4 &>> ~/Desktop/ScriptOutputs/log && {
				printf "\n# URL of ReadMe: "
				read url
				printf "# Changing User Permisions, this will take a moment\n"
				python3 rmUsers.py $url && printf "# Users have been edited\n" || printf "##ERROR running python script, DO MANUALLY\n"
			}
		} || printf "##ERROR editing users, DO MANUALLY\n"
	}	
	sleep 3
}

passPolicy(){
	printf "\n## Password Policy Configurations:\n"
	printf "\n\n### PassPolicy - libpam-pwquality install\n" >> ~/Desktop/ScriptOutputs/log
	apt install libpam-pwquality -y &>> ~/Desktop/ScriptOutputs/log && {
	#Expiration Date
	sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t15/' /etc/login.defs
	sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t8/' /etc/login.defs
	sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE\t7/' /etc/login.defs
	sed -i 's/^FAILLOG_ENAB.*/FAILLOG_ENAB\tyes/' /etc/login.defs
	sed -i 's/^LOG_UNKFAIL_ENAB.*/LOG_UNKFAIL_ENAB\tyes/' /etc/login.defs
	sed -i 's/^SYSLOG_SU_ENAB.*/SYSLOG_SU_ENAB\tyes/' /etc/login.defs
	sed -i 's/^SYSLOG_SG_ENAB.*/SYSLOG_SG_ENAB\tyes/' /etc/login.defs
	sed -i 's/^LOGIN_RETRIES.*/LOGIN_RETRIES\t\t3/' /etc/login.defs

	echo "# /etc/login.defs has been updated:"
	echo "Max days set to: 15, Min days: 8, Warn age: 7\n"
	#Password Policy

	tallyExists=$(grep pam_tally2.so /etc/pam.d/common-auth|wc -l)
	if [ "$tallyExists" -eq 0 ] ; then
		sed -i 's/pam_deny.so.*/pam_deny.so\nauth\trequired\tpam_tally2.so\tdeny=3 unlock_time=900 onerr=fail audit even_deny_root silent/' /etc/pam.d/common-auth
	else
		sed -i 's/pam_tally2.so.*/pam_tally2.so\tdeny=3 unlock_time=900 onerr=fail audit even_deny_root silent/' /etc/pam.d/common-auth
	fi


	sed -i 's/pam_pwquality.so.*/pam_pwquality.so retry=3 minlen=14 diFok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 reject_username enforce_for_root/' /etc/pam.d/common-password
	
	historyExists=$(grep pam_pwhistory.so /etc/pam.d/common-password|wc -l)
	if [ "$historyExists" -eq 0 ] ; then
		sed -i 's/ocredit=-1.*/ocredit=-1\npassword\trequisite\tpam_pwhistory.so use_authok remember=10 enforce_for_root/' /etc/pam.d/common-password
	else
		sed -i 's/pam_pwhistory.so.*/pam_pwhistory.so use_authok remember=10 enforce_for_root/' /etc/pam.d/common-password
	fi

	sed -i 's/pam_unix.so.*/pam_unix.so obscure use_authtok try_first_pass sha512 shadow/' /etc/pam.d/common-password

	echo "# /etc/pam.d/common-password & common-auth have been updated"
	
	if [ -d /etc/lightdm/lightdm.conf.d ] ; then
		echo lightdm.conf.d
		lightdm /etc/lightdm/lightdm.conf.d/50-myconfing.conf
	elif [ -d /etc/lightdm ] ; then
		echo lightdm.conf
		lightdm /etc/lightdm/lightdm.conf
	fi
	} || {
		printf "##ERROR editing password policy, DO MANUALLY:
install libpam-pwquality
/etc/login.defs
/etc/pam.d/common-auth - pam_tally2.so\tdeny=3 unlock_time=900 onerr=fail audit even_deny_root silent
/etc/pam.d/common-password - ocredit=-1.*/ocredit=-1\npassword\trequisite\tpam_pwhistory.so use_authok remember=10 enforce_for_root\n
\tpam_unix.so obscure use_authtok try_first_pass sha512 shadow\n"
	}
	sleep 2

}

autoUpdates(){
        #sources
	securityExists=$(grep "bionic-security universe restricted main" /etc/apt/sources.list|wc -l)
	if [ "$securityExists" -eq 0 ] ; then
		sed -i -e '$adeb http://security.ubuntu.com/ubuntu/ bionic-security universe restricted main multiverse' /etc/apt/sources.list
		sed -i -e '$adeb http://us.archive.ubuntu.com/ubuntu/ bionic-updates universe restricted main multiverse' /etc/apt/sources.list
		sed -i -e '$adeb http://us.archive.ubuntu.com/ubuntu/ bionic-backports universe restricted main multiverse' /etc/apt/sources.list
	fi
        #install
	sed -i 's/"[0-9]"/"1"/' /etc/apt/apt.conf.d/20auto-upgrades

	printf '## Auto Updates have been configured\n'
        sleep 2
	printf "Updating System\n"
	printf "### UPDATES\n" >> ~/Desktop/ScriptOutputs/log
	printf "Updating repositories\n"
	apt update &>> ~/Desktop/ScriptOutputs/log
	printf "Run 'sudo apt upgrade' later if needed"
	printf "Upgrading system\n"
	apt upgrade -y &>> ~/Desktop/ScriptOutputs/log
	printf "Removing unused dependancies\n"
	apt autoremove &>> ~/Desktop/ScriptOutputs/log
}

lightdm(){
	echo "$1"
	if ! [ -f "$1" ] ; then
		touch "$1"
		sudo bash -c "echo '[Seat:*]' >> $1"
	fi
		
	allowGuest=$(grep allow-guest "$1"|wc -l)
	if [ "$allowGuest" -eq 0 ] ; then
		sudo bash -c "echo 'allow-guest=false' >> $1"
	else
		sed -i 's/allow-guest.*/allow-guest=false/' "$1"
	fi

	hideUsers=$(grep greeter-hide-users "$1"|wc -l)
	if [ "$hideUsers" -eq 0 ] ; then
		sudo bash -c "echo 'greeter-hide-users=true' >>$1"
	else
		sed -i 's/greeter-hide-users.*/greeter-hide-users=true/' "$1"
	fi

	manualLogin=$(grep greeter-show-manual-login "$1"|wc -l)
	if [ "$manualLogin" -eq 0 ] ; then
		sudo bash -c "echo 'greeter-show-manual-logins=true' >> $1"
	else
		sed -i 's/greeter-show-manual-login.*/greeter-show-manual-login=true/' "$1"
	fi

	printf "# $1 has been edited, remove autologin by hand not sure if necesary\n"

	sleep 2
}

sysctlConf(){
	printf "\n## Configuring IP protocols\n"
	bash -c 'echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.conf.all.accept_source_route = 0" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.tcp_max_syn_backlog = 2048" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.tcp_synack_retries = 2" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.tcp_syn_retries = 5" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf' &&
	bash -c 'echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf' &&
	sysctl -p &>> ~/Desktop/ScriptOutputs/log &&
	printf "# IP protocols configured\n" || printf "###ERROR configuring IP protocols\n"
	sleep 2

}

hackingTools(){
	printf "\n# Searching for hacking tools:\nJTR, Netcat, Hydra, Aircrack-ng, Nmap\n"
	printf "\n\n### Removing hacking tools\n" >> ~/Desktop/ScriptOutputs/log
	apt autoremove --purge john netcat hydra aircrack-ng nmap wireshark -y &>> ~/Desktop/ScriptOutputs/log && {
		printf "# If present, hacking tools have been removed be removed\n"
	} || {
		printf "##ERROR trying to remove hacking tools\n"
	}
}

firewallConfig(){
	printf "\n\n### FirewallConfig - intall iptabes & ufw\n" >> ~/Desktop/ScriptOutputs/log
	printf "\n\n## Firewall Configuration\n"
	apt install ufw iptables -y &>> ~/Desktop/ScriptOutputs/log && {
	ufw disable &>> ~/Desktop/ScriptOutputs/log
	ufw default deny incoming &>> ~/Desktop/ScriptOutputs/log
	ufw enable &>> ~/Desktop/ScriptOutputs/log
	echo "# Configuring Firewall"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 23 -j DROP         #Block Telnet
	#echo "Blocked Telnet!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 2049 -j DROP       #Block NFS
	#echo "Blocked NFS!"
	iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 2049 -j DROP       #Block NFS
	#echo "Blocked NFS!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 6000:6009 -j DROP  #Block X-Windows
	#echo "Blocked X-Windows!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 7100 -j DROP       #Block X-Windows font server
	#echo "Blocked X-Windows font server!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 515 -j DROP        #Block printer port
	#echo "Blocked printer port!"
	iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 515 -j DROP        #Block printer port
	#echo "Blocked printer port!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 111 -j DROP        #Block Sun rpc/NFS
	iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 111 -j DROP        #Block Sun rpc/NFS
	#echo "Blocked Sun RPC/NFS!"
	iptables -A INPUT -p all -s localhost  -i eth0 -j DROP            #Deny outside packets from internet which claim to be from your loopback interface.
	#echo "Blocked fake loopback packets!"
	printf "## Firewall configured\n"
	} || {
		printf "##ERROR configuring firewall\n"
	}
	sleep 2
}

secureApache(){
	serversign=$(grep ServerSignature /etc/apache2/conf-enabled/security.conf|wc -l)
	if [ "$serversign" -eq 0 ] ; then
		sudo bash -c 'echo "ServerSignature Off" >> /etc/apache2/conf-enabled/security.conf'
	else
		sed -i 's/^ServerSignature.*/ServerSignature Off/' /etc/apache2/conf-enabled/security.conf
	fi

	serversign=$(grep ServerSignature /etc/apache2/apache2.conf|wc -l)
	if [ "$serversign" -eq 0 ] ; then
		sudo bash -c 'echo "ServerSignature Off" >> /etc/apache2/apache2.conf'
	else
		sed -i 's/^ServerSignature.*/ServerSignature Off/' /etc/apache2/apache2.conf
	fi


	servertoken=$(grep ServerTokens /etc/apache2/conf-enabled/security.conf|wc -l)
	if [ "$serversign" -eq 0 ] ; then
		sudo bash -c 'echo "ServerTokens Prod" >> /etc/apache2/conf-enabled/security.conf'
	else
		sed -i 's/^ServerTokens.*/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf
	fi

	servertoken=$(grep ServerTokens /etc/apache2/conf-enabled/security.conf|wc -l)
	if [ "$serversign" -eq 0 ] ; then
		sudo bash -c 'echo "ServerTokens Prod" >> /etc/apaFusRoDah!!1che2/conf-enabled/security.conf'
	else
		sed -i 's/^ServerTokens.*/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf
	fi

	timeout=$(grep Timeout /etc/apache2/apache2.conf|wc -l)
	if [ "$timeout" -eq 0 ] ; then
		sudo bash -c 'echo "Timeout 45" >> /etc/apache2/apache2.conf'
	else
		sed -i 's/^Timeout.*/Timeout 45/' /etc/apache2/apache2.conf
	fi

	traceEnable=$(grep TraceEnable /etc/apache2/conf-enabled/security.conf|wc -l) 
	if [ "$traceEnable" -eq 0 ] ; then
		sudo bash -c 'echo "TraceEnable Off" >> /etc/apache2/conf-enabled/security.conf'
	else
		sed -i 's/^TraceEnable.*/TraceEnable Off/' /etc/apache2/conf-enabled/security.conf
	fi

	directoryScooting=$(grep "<Directory />" /etc/apache2/apache2.conf|wc -l)
	if [ "$directoryScooting" -eq 0 ] ; then
		sudo bash -c 'echo "<Directory />" >> /etc/apache2/apache2.conf'
		sudo bash -c 'echo "	Order Deny,Allow" >> /etc/apache2/apache2.conf'
		sudo bash -c 'echo "	Dent from all" >> /etc/apache2/apache2.conf'
		sudo bash -c 'echo "	Options -Indexes" >> /etc/apache2/apache2.conf'
		sudo bash -c 'echo "	AlloOverride None" >> /etc/apache2/apache2.conf'
	fi
		


	#new user thing
	useradd apache -p 'Cyb3rPatr!0t!!'
	userCheck=$(grep User /etc/apache2/apache2.conf|wc -l)
	if [ "$userCheck" -eq 0 ] ; then
		sudo bash -c 'echo "User apache" >> /etc/apache2/apache2.conf'
		sudo bash -c 'echo "Group apache" >> /etc/apache2/apache2.conf'
	else
		sed -i 's/^User.*/User apache/' /etc/apache2/apachFusRoDah!!1e2.conf
		sed -i 's/^Group.*/Group apache/' /etc/apache2/apache2.conf
	fi
	#https://geekflare.com/10-best-practices-to-secure-and-harden-your-apache-web-server/
	apt install mod_security
	service httpd restart
}

secureSSH(){
	printf "\n\n###SSH Configuration" >> ~/Desktop/ScriptOutputs/log
	apt install --only-upgrade openssh-server &>> ~/Desktop/ScriptOutputs/log && printf "# OpenSSH Updated\n"
	sed -i 's/.*Port .*/Port 6969/' /etc/ssh/sshd_config
	sed -i 's/.*AddressFamily .*/AddressFamily inet/' /etc/ssh/sshd_config
	sed -i 's/.*ListenAddress .*/ListenAddress 192.168.0.32/' /etc/ssh/sshd_config
	sed -i 's/.*LogLevel .*/LogLevel VERBOSE/' /etc/ssh/sshd_config
	sed -i 's/.*LoginGraceTime.*/LoginGraceTime 1m/' /etc/ssh/sshd_config
	sed -i 's/.*PermitRootLogin yes.*/PermitRootLogin no/' /etc/ssh/sshd_config
	sed -i 's/.*MaxAuthTries .*/MaxAuthTries 3/' /etc/ssh/sshd_config
	sed -i 's/.*MaxSessions .*/MaxSessions 2/' /etc/ssh/sshd_config
	sed -i 's/.*IgnoreRhosts .*/IgnoreRhosts yes/' /etc/ssh/sshd_config
	sed -i 's/.*PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
	sed -i 's/.*PermitEmptyPasswords .*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
	sed -i 's/.*X11Forwarding .*/X11Forwarding no/' /etc/ssh/sshd_config
	sed -i 's/.*ClientAliveInterval .*/ClientAliveInterval 45/' /etc/ssh/sshd_config
	sed -i 's/.*ClientAliveCountMax .*/ClientAliveCountMax 3/' /etc/ssh/sshd_config
	sed -i 's/.*AllowTcpForwarding .*/AllowTcpForwarding no/' /etc/ssh/sshd_config
	
	
	service sshd restart
	printf '## SSH Configured\nRestrict users who can ssh:\tAllowUsers username username2\n'
	printf '# Maybe disable sftp under /etc/ssh/sshd_config\n'
	sleep 2

}

secureSQL(){
	echo "SQL Not Yet"
}

securePHP(){
	echo "PHP Not Yet"
}

secureLamp(){
	if [ -f /etc/apache2/conf-enabled/security.conf ] ;then
		secureApache
	fi
	secureSQL
	securePHP
}

listServices(){
	printf "\n# Searching Packages"
	dpkg -l | grep --color=always -E 'ftp|samba|snmp|nfs|ssh|apache'
	printf "\n"
	echo "Stop with 'sudo service {service_name} stop'"
	echo "Remove with 'sudo apt autoremove --purge {service_name}'"
	printf "\n"
	#USEr input for what they want to remove
}

mediaFiles(){
	find / -iname '*.mp3' -print 2>/dev/null
	printf "\n"
	find / -iname '*.mp4' -print 2>/dev/null
	printf "\n"
	find / -iname 'password*.txt' -print 2>/dev/null
	#USEr input for what they want to remove
}

firefoxConfig(){
	printf "\n\n### Firefox update\n" >> ~/Desktop/ScriptOutputs/log
	printf "# Updating Firefox\n"
	apt install --only-upgrade firefox &>> ~/Desktop/ScriptOutputs/log && printf "# Firefox Updated\n"
	printf "# Configure firefox preferences"
	sleep 2
	$(firefox -preferences) &> /dev/null &
}

malwareScan(){
	printf "Installing Anti-Malware Software, please wait\n"
	#update openssh before install and no prompt pops
	printf "### Installing antimalware" >> ~/Desktop/ScriptOutputs/log
	apt install -y chkrootkit clamav rkhunter hardinfo lynis &>> ~/Desktop/ScriptOutputs/log

	printf "# Running clamscan"
	clamscan -i -r / > ~/Desktop/ScriptOutputs/clamscan.txt
	gedit ~/Desktop/ScriptOutputs/clamscan.txt

	printf "# Running chkrootkit\n"
	chkrootkit 2> ~/Desktop/ScriptOutputs/log 1> ~/Desktop/ScriptOutputs/chkrootkit.txt
	gedit ~/Desktop/ScriptOutputs/chkrootkit.txt
	
	echo "Running hardinfo"
	hardinfo -r -f html > ~/Desktop/ScriptOutputs/hardinfo.html
	firefox ~/Desktop/ScriptOutputs/hardinfo.html

	#lynis -c > ~/Desktop/ScriptOutputs/lynis.txt
	#sudo rkhunter &> ~/Desktop/ScriptOutputs/rkhunter.txt
}

start

