#!/bin/bash
#Cyb3rPatr!0t$
if [ "$EUID" -ne 0 ] ;
	then echo "Run as Root"
	exit
fi

apt update -y
apt upgrade -y
clear
#Functions
#users   ---   removes unecessary users and secures passwords
#passPolicy   ---   sets password policy
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
read INPUT

start(){
	users
	passPolicy
	sysctlConf
	hackingTools
	firewallConfig
	secureLamp
	malwareScan
	listServices
	mediaFiles
}

users(){
	apt install python3-pip -y
	pip3 install beautifulsoup4
	clear
	pass="Cyb3rPatr!0t$"
	echo "# All user passwords have been updated to: "$pass
	printf "\n"
	for i in $(ls /home); do chpasswd <<< "$i:$pass"; done
	
	echo "# URL of ReadMe:"
	read url
	python3 rmUsers.py $url
	sed -i 's/NOPASSWD://' /etc/sudoers
	sleep 3
}

passPolicy(){
	apt install libpam-pwquality -y
	#Expiration Date
	sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS\t90/' /etc/login.defs
	sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS\t10/' /etc/login.defs
	sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE\t7/' /etc/login.defs
	sed -i 's/^FAILLOG_ENAB.*/FAILLOG_ENAB\tyes/' /etc/login.defs
	sed -i 's/^LOG_UNKFAIL_ENAB.*/LOG_UNKFAIL_ENAB\tyes/' /etc/login.defs
	sed -i 's/^SYSLOG_SU_ENAB.*/SYSLOG_SU_ENAB\tyes/' /etc/login.defs
	sed -i 's/^SYSLOG_SG_ENAB.*/SYSLOG_SG_ENAB\tyes/' /etc/login.defs
	sed -i 's/^LOGIN_RETRIES.*/LOGIN_RETRIES\t3/' /etc/login.defs

	echo "# /etc/login.defs has been updated"
	echo "Max days set to: 90, Min days: 10, Warn age: 7."
	#Password Policy

	tallyExists=$(grep pam_tally2.so /etc/pam.d/common-auth|wc -l)
	if [ "$tallyExists" -eq 0 ] ; then
		sed -i 's/pam_deny.so.*/pam_deny.so\nauth\trequired\tpam_tally2.so\tdeny=3 unlock_time=900 onerr=fail audit even_deny_root silent/' /etc/pam.d/common-auth
	else
		sed -i 's/pam_tally2.so.*/pam_tally2.so\tdeny=3 unlock_time=900 onerr=fail audit even_deny_root silent/' /etc/pam.d/common-auth
	fi


	sed -i 's/pam_pwquality.so.*/pam_pwquality.so retry=3 minlen=12 diFok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 reject_username enforce_for_root/' /etc/pam.d/common-password
	
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
	sleep 2

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

	echo "# $1 has been edited, remove autologin by hand not sure if necesary"


}

sysctlConf(){
	bash -c 'echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.conf.all.accept_source_route=0" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.tcp_max_syn_backlog = 2048" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.tcp_synack_retries = 2" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.tcp_syn_retries = 5" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv6.conf.default.disable_ipv6" >> /etc/sysctl.conf'
	bash -c 'echo "net.ipv6.conf.lo.disable_ipv6" >> /etc/sysctl.conf'
	sysctl -p

}

hackingTools(){
	apt autoremove --purge john netcat hydra aircrack-ng nmap -y
	echo "# Hacking tools should be removed"

}

firewallConfig(){
	apt install ufw iptables -y
	ufw disabled
	ufw deny all
	ufw enabled
	echo "Firewall configuration.."
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 23 -j DROP         #Block Telnet
	echo "Blocked Telnet!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 2049 -j DROP       #Block NFS
	echo "Blocked NFS!"
	iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 2049 -j DROP       #Block NFS
	echo "Blocked NFS!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 6000:6009 -j DROP  #Block X-Windows
	echo "Blocked X-Windows!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 7100 -j DROP       #Block X-Windows font server
	echo "Blocked X-Windows font server!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 515 -j DROP        #Block printer port
	echo "Blocked printer port!"
	iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 515 -j DROP        #Block printer port
	echo "Blocked printer port!"
	iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 111 -j DROP        #Block Sun rpc/NFS
	echo "Blocked Sun RPC/NFS!"
	iptables -A INPUT -p udp -s 0/0 -d 0/0 --dport 111 -j DROP        #Block Sun rpc/NFS
	echo "Blocked Sun RPC/NFS!"
	iptables -A INPUT -p all -s localhost  -i eth0 -j DROP            #Deny outside packets from internet which claim to be from your loopback interface.
    echo "Blocked fake loopback packets!\n"
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
		sudo bash -c 'echo "ServerTokens Prod" >> /etc/apache2/conf-enabled/security.conf'
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
	useradd apache -p 'Cyb3rPatr!0t$'
	userCheck=$(grep User /etc/apache2/apache2.conf|wc -l)
	if [ "$userCheck" -eq 0 ] ; then
		sudo bash -c 'echo "User apache" >> /etc/apache2/apache2.conf'
		sudo bash -c 'echo "Group apache" >> /etc/apache2/apache2.conf'
	else
		sed -i 's/^User.*/User apache/' /etc/apache2/apache2.conf
		sed -i 's/^Group.*/Group apache/' /etc/apache2/apache2.conf
	fi
	#https://geekflare.com/10-best-practices-to-secure-and-harden-your-apache-web-server/
	apt install mod_security
	service httpd restart
}

secureSQL(){
	echo "Not Yet"
}

securePHP(){
	echo "Not Yet"
}

secureLamp(){
	if [ -f /etc/apache2/conf-enabled/security.conf ] ;then
		secureApache
	fi
	secureSQL
	securePHP
}

listServices(){
	dpkg -l | grep -E 'ftp|samba|snmp|nfs|ssh|apache'
	echo
	echo "Stop with 'sudo service {service_name} stop'"
	echo "Remove with 'sudo apt autoremove --purge {service_name}"
	echo
}

mediaFiles(){
	find / -iname '*.mp3' -print 2>/dev/null
	echo
	find / -iname '*.mp4' -print 2>/dev/null
	echo
	find / -iname 'password*.txt' -print 2>/dev/null
	
}

malwareScan(){
	echo "Installing Anti-Malware Software"
	#split depending on what needs user help
	apt install -V -y clamav chkrootkit rkhunter hardinfo lynis
	echo "We gonna run in a sec"
	echo "Running chkrootkit"
	chkrootkit > ~/Desktop/ScriptOutputs/chkrootkit.txt
	vi ~/Desktop/ScriptOutputs/chkrootkit.txt
	echo "Running clamscan"
	clamscan -i -r / > ~/Desktop/ScriptOutputs/clamscan.txt
	vi ~/Desktop/ScriptOutputs/clamscan.txt
	echo "Running hardinfo"
	hardinfo -r -f html > ~/Desktop/ScriptOutputs/hardinfo.html
	firefox ~/Desktop/ScriptOutputs/hardinfo.html
	#lynis -c > ~/Desktop/ScriptOutputs/lynis.txt
	#sudo rkhunter &> ~/Desktop/ScriptOutputs/rkhunter.txt
}

start
