$files=$PSScriptRoot
$ErrorActionPreference="Stop"

#View File Owner
#View Running tasks spot
#Generating user report
#autousers -no password for main user

#MainMenu
function mainMenu{

$menuOption = read-host "`n~~~Main Menu~~~`n`n1. Firewall`n2. Malware`n3. Drives`n4. Security Policy`n5. Users`n6. Files`n7. Features and Services`n8. Hashes and Stuff`n9. Auto`nAdditional Commands: clear,exit`n`nYour Selection"

switch($menuOption){
0{$command=read-host "Enter your Command";Invoke-Expression $command}#Enter custom command
1{firewallMenu;mainMenu}
2{malwareMenu;mainMenu}
3{driveMenu;mainMenu}
4{secPol;mainMenu}
5{userMenu;mainMenu}
6{fileMenu;mainMenu}
7{featMenu;mainMenu}
8{extrMenu;mainMenu}
9{auto;mainMenu}
10{tasks}
clear{clear;mainMenu}
exit{removeGenedFiles;exit}
default{clear;write-warning "'$menuOption' is not a valid option`n`n";mainMenu}}}


#Firewall
function firewallMenu{
	$firewallStartStatus=Get-NetFirewallProfile -Profile Domain,Public,Private|findstr Enabled|findstr True
	if($firewallStartStatus.length -eq 3){
		$firewallOption=read-host "`n`n1. Firewall - Enabled (Select to Disable)`n2. Advanced Firewall Settings`n`nYour Selection"
		switch($firewallOption){
			0{clear;mainMenu}
			1{disableBaseFirewall}
			2{setAdvFirewall}
			defualt{echo `n;write-warning "'$firewallOption' is not a valid option`n`n";firewallMenu}
		}
	}else{
		$firewallOption=read-host "`n`n1. Firewall - Disabled (Select to Enable)`n2. Advanced Firewall Settings`n`nYour Selection"
		switch($firewallOption){
			0{clear;mainMenu}
			1{enableBaseFirewall}
			2{setAdvFirewall}
			defualt{echo `n;write-warning "'$firewallOption' is not a valid option`n`n";firewallMenu}
		}
	}
}
function enableBaseFirewall{
	try{	
		Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -erroraction stop
		echo "Firewall Enabled"
	}catch{
		write-host "Failed Enabling Firewall:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
	}
function disableBaseFirewall{
	$choices  = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice("","Are You Sure You Want To Disable the Firewall", $choices, 1)
	if ($decision -eq 0) {
		try{
   			Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False -erroraction stop
			echo "Firewall Disabled"
		}catch{
			write-host "Failed Disabling Firewall:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
		}
	} else {
   		 firewallMenu
	}
}
function setAdvFirewall{
	echo "Coming Soon"
}


#Malware
function malwareMenu{
	$malwareOption=read-host "`n`n1. Malwarebytes Anti Malware`n2. Malwarebytes Rootkit scan`n3. Install Both`n`nYour Selection"
	switch($malwareOption){
		0{clear;mainMenu}
		1{malwareScan}
		2{rootkitScan}
		3{malwareScan;rootkitScan}
		defualt{echo `n;write-warning "'$malwareOption' is not a valid option`n`n";malwareMenu}
	}
}
function rootkitScan{
	try{
		$rootkit=start-job -scriptblock {invoke-expression 'cmd /c powershell Invoke-WebRequest -OutFile RootKitScan.exe https://data-cdn.mbamupdates.com/web/mbar-1.10.3.1001.exe';invoke-expression 'cmd /c RootKitScan.exe'}
		echo "Rootkit Scanner Downloading...."
	}catch{
		write-host "Failed Running malware scan:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function malwareScan{
	try{
		$scan=start-job -scriptblock {invoke-expression 'cmd /c powershell Invoke-WebRequest -OutFile MalwareBytesScan.exe https://downloads.malwarebytes.com/file/mb3';invoke-expression 'cmd /c MalwareBytesScan.exe'}
		echo "Malware Scanner Downloading...."
	}catch{
		write-host "Failed Running malware scan:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}


#Drives
function driveMenu{
	try{
		$d=Get-WMIObject -Query "Select * FROM Win32_Share Where Type=0"|select -expand Name
	}catch{
		write-host "Failed loading drives:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
	if ($d -eq $null){
		$drives=" None"
	}else{
		$drives=""
	}
	foreach($a in $d){$drives=$drives+" "+$a}
	$driveOption=read-host "`n`nShared Drives:$drives`n`n1. Remove all Shared Drives`n2. Create Shared Drive`n`nYour Selection"
	switch($driveOption){
		0{clear;mainMenu}
		1{removeSharedDrives}
		2{createSharedDrive}
		h{helpSharedDrive}
		defualt{echo `n;write-warning "'$malwareOption' is not a valid option`n`n";driveMenu}
	}
}
function removeSharedDrives{
	try{
		$d=Get-WMIObject -Query "Select * FROM Win32_Share Where Type=0"|select -expand Name -erroraction stop
	}catch{
		write-host "Failed loading drives:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
	try{
		foreach($a in $d){net share $a /Delete -erroraction stop}
		echo "Removing Drives: $d"
	}catch{
		write-host "Failed Deleting drives:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function createSharedDrive{
	$drive=read-host "`nDrive or file location Ex(F:/, F:/Folder)"
	try{
		net share $drive /grant:everyone,FULL -erroraction stop
		echo "Created Shared Drive $drive"
	}catch{
		write-host "Failed Creating Shared Drive:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function helpSharedDrive{
	write-host "`nMicrosoft Docs: https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh750728(v=ws.11)`n`nAnother Link: https://www.windows-commandline.com/list-create-delete-network-shares/`n"
}
	

#Security Policy
function secPol{
	try{
                write-host "`nConfiguring Security Policy:"
		secedit.exe /configure /db secedit.sdb /cfg "$files\CyberLocalSecurityPolicy$os.inf"
                echo "Security Policy Has been Updated`n"
                $obj = New-Object -ComObject wscript.shell;
                $obj.SendKeys("~")
                auditpol /clear
                #sleep -ms 1000
                auditpol /set /category:* /success:enabled
                echo "Advanced Audits Have Been Congifured`n"
		#autoupdates
                write-host "Enabling Auto-Updates:"
		invoke-expression 'cmd /c reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\WindowsUpdates\Auto Update" /v "AUOptions" /t REG_DWORD /d 0 /f'
		
                #ctrl alt del
		#invoke-expression 'cmd /c reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\WindowsNT\CurrentVersion\Winlogon" /v "DisableCAD" /t REG_DWORD /d 0 /f'
		
	}catch{
		write-host "Failed configuring Security Policy:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}


#Files
function fileMenu{
	$fileOption=read-host "`n`n1. Scan for a File Type`n2. Delete a File Type`n3. Find Specific File Location `n4. Delete File at Location `n5. Mass File Scan`n`nYour Selection"
	switch($fileOption){
		0{clear;mainMenu}
		1{scanExt}
		2{rmExt}
		3{specFile}
		4{rmSpecFile}
		5{scanAll}
		defualt{echo `n;write-warning "'$fileOption' is not a valid option`n`n";fileMenu}
	}
}
function scanExt{
	$extType=read-host "`n`nWhat file extension do you want to scan for Ex(mp3)"
	try{
		$scanjob=start-job -scriptblock{Get-ChildItem -Path C:\ -Filter *.$using:extType -recurse -erroraction silentlycontinue -force | %{$_.FullName}|Out-File -FilePath "$using:files\Temp Files\'$using:extType'.txt";notepad "$using:files\Temp Files\'$using:extType'.txt"}
		
	}catch{
			write-error "Failed scanning for Files:`n$_"
	}
}
function rmExt{
	$extType=read-host "`n`nWhat file extension do you want to Delete Ex(mp3)"
	rmingExt($extType)
}
function rmingExt($fileType){
	try{
		write-host "Finding $fileType Files to Delete"
		Get-ChildItem C:\ -recurse *$fileType -erroraction silentlycontinue| foreach { Remove-Item -Path $_.FullName -erroraction stop
		write-host "Deleted: $_"}
	}catch{
		write-host "Editing File Permissions to Try Again"
		$path=($_.ToString() -split " ")[3]
		$path=$path.substring(0,$path.length-1)
		$NewAcl = Get-Acl -Path $path
		$identity = "BUILTIN\Administrators"
		$fileSystemRights = "FullControl"
		$type = "Allow"
		$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
		$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
		$NewAcl.SetAccessRule($fileSystemAccessRule)
		Set-Acl -Path $path -AclObject $NewAcl
		try{
			Remove-Item -Path $path -erroraction stop
		}catch{
			write-error "Failed deleting $path`:`n$_"
		}
		rmingExt($fileType)
	}
}
function specFile{
	$file=read-host "`n`nWhat file name do you want to search for"
	try{
		$scanjob=start-job -scriptblock{Get-ChildItem -Path C:\ -Filter $using:file -recurse -erroraction silentlycontinue -force | %{$_.FullName}|write-host $_.FullName}
		
	}catch{
			write-error "Failed scanning for Files:`n$_"
	}
}
function rmSpecFile{
	$file=read-host "`n`nWhat file do you want Deleted"
	try{
		write-host "Finding $fileType Files to Delete"
		Get-ChildItem C:\ -recurse *$fileType -erroraction silentlycontinue| foreach { Remove-Item -Path $_.FullName -erroraction stop
		write-host "Deleted: $_"}
	}catch{
		write-host "Editing File Permissions to Try Again"
		$path=($_.ToString() -split " ")[3]
		$path=$path.substring(0,$path.length-1)
		$NewAcl = Get-Acl -Path $path
		$identity = "BUILTIN\Administrators"
		$fileSystemRights = "FullControl"
		$type = "Allow"
		$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
		$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
		$NewAcl.SetAccessRule($fileSystemAccessRule)
		Set-Acl -Path $path -AclObject $NewAcl
		try{
			Remove-Item -Path $path -erroraction stop
		}catch{
			write-error "Failed deleting $path`:`n$_"
		}
	}
}

function scanAll{
        try{
	$godList="ac3", "m4p", "ogg", "vqf", "wav", "mp4", "mpeg4", "gif", "png", "bmp", "jpg", "jpeg","asf", "wma", "wmv", "wm", "asx", "wax", "wvx", "wmx", "wpl", "dvr-ms", "wmd", "avi", "mpg", "mpeg", "m1v", "mp2", "mp3", "mpampe", "m3u", "mid", "midi", "rmi", "aif", "aifc", "aiff", "au", "snd", "wav", "cda", "ivf", "wmz", "wms", "mov", "m4a", "mp4", "m4v", "mp4v", "3g2", "3gp2", "3gp", "3gpp","aac", "adt", "adts", "m2ts", "flac", "heic", "txt", "pdf", "7z", "zip", "gz", "iso", "img", "jar", "bz2", "dfg", "dxf", "wpd", "html", "docx", "htm", "dng", "ico"
	echo "Scanning for files in backgroud"
	$alljob=start-job -scriptblock{
		foreach($a in $using:godList){
			Get-ChildItem -Path C:\ -Filter *.$a -recurse -erroraction silentlycontinue -force | %{$_.FullName}|Out-File -FilePath "$using:files\Temp Files\'$a'.txt"
		}
	}
	start-sleep 2
	$godList="mp4","mp3","mov","gif","jpg","png","txt","mpg","mpeg","jpeg"
	$openalljob=start-job -scriptblock{
		foreach($a in $using:godList){
			if ((Get-Content "$using:files\Temp Files\'$a'.txt" -erroraction silentlycontinue) -ne $null){
			notepad "$using:files\Temp Files\'$a'.txt"
			}
		}
	}
        }catch{
            write-host "Failed Scanning Files:`n"$PSItem.Exception.Message -ForegroundColor Red -BackgroundColor Black
        }
}


#Features and Services
function featMenu{
	$featOption=read-host "`n`n1. Disable Weak Features ie(ftp)`n2. Kill Suspicious Services`n`nYour Selection"
	switch($featOption){
		0{clear;mainMenu}
		1{disFeatures}
		2{killServices}
		defualt{echo `n;write-warning "'$featOption' is not a valid option`n`n";featMenu}
	}
}
function disFeatures{
	try{
		$disjob=start-job -scriptblock{
			$disableList="IIS-WebServerRole","IIS-FTPServer","IIS-FTPSvc","SMB1Protocol-Deprecation","SMB1Protocol","SMB1Protocol-Client","SMB1Protocol-Server","SmbDirect","TelnetClient","TFTP","MicrosoftWindowsPowerShellV2","MicrosoftWindowsPowerShellV2Root","MediaPlayback","Internet-Explorer-Optional-amd64","WCF-TCP-PortSharing45"
			foreach($item in $disableList){disable-windowsoptionalfeature -online -featureName $item -norestart -erroraction stop}
		}

		echo "Disabling Features"
	}catch{
		write-host "Failed disabling Features:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}


function killServices{
	echo "Coming Soon"
}

#Users
function userMenu{
	try{
	$guest=get-localuser Guest|findstr True
	$admin=get-localuser Administrator|findstr True
	}catch{
	}
	if($guest -eq $null -and $admin -eq $null){
		$userOption=read-host "`n`n1. Guest and Admin - Disabled(Select to Enable)`n2. Edit Users`n3. Alter Permisions/Groups`n`nYour Selection"
		switch($userOption){
			0{clear;mainMenu}
			1{enPreMade;userMenu}
			2{usEdMenu;userMenu}
			3{permMenu;userMenu}
			defualt{echo `n;write-warning "'$userOption' is not a valid option`n`n";userMenu}
		}
	}else{
		$userOption=read-host "`n`n1. Guest and Admin - Enabled(Select to Disable)`n2. Edit Users`n3. Alter Permisions/Groups`n`nYour Selection"
		switch($userOption){
			0{clear;mainMenu}
			1{disPreMade;userMenu}
			2{usEdMenu;userMenu}
			3{permMenu;userMenu}
			defualt{echo `n;write-warning "'$userOption' is not a valid option`n`n";userMenu}
		}
	}
}
#Guest and Admin
function disPreMade{
	try{
		get-localuser Guest|disable-localuser -erroraction stop
		get-localuser Administrator|disable-localuser -erroraction stop
		echo "Guest and Admin Accounts Disabled"
	}catch{
		write-host "Failed disabling Guest and Admin accounts:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function enPreMade{
	$choices  = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice("","Are You Sure You Want To Enable the Guest and Admin Accounts?", $choices, 1)
	if ($decision -eq 0) {
		try{
   			get-localuser Guest|enable-localuser -erroraction stop
			get-localuser Administrator|enable-localuser -erroraction stop
			echo "Guest and Admin Accounts Enabled"
		}catch{
			write-host "Failed enabling Guest and Admin accounts:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
		}
	} else {
   		 userMenu
	}
}
#User Editing Menu
function usEdMenu{
	$usEdOption=read-host "`n`n1. New User`n2. New Admin`n3. Delete User`n4. List all Users`n5. Change User Password`n6.Make User change password Next Login`n`nYour Selection"
	switch($usEdOption){
		0{clear;userMenu}
		1{newUser}
		2{newAdmin}
		3{rmUser}
		4{listAllUsers}
		5{newUserPass}
		6{passExpire}
		defualt{echo `n;write-warning "'$usEdOption' is not a valid option`n`n";usEdMenu}
	}

}
function newUser{
	$Username=read-host "New username"
	$Password=read-host "New Password"
	try{
		New-LocalUser $Username -Password (ConvertTo-SecureString -AsPlainText $Password -Force)
		Add-LocalGroupMember -Group "Users" -Member $Username -erroraction stop
		echo "User Account Created"
	}catch{
		write-host "Failed Creating $Username's Account:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function newAdmin{
	$Username=read-host "New username"
	$Password=read-host "New Password"
	try{
		New-LocalUser $Username -Password (ConvertTo-SecureString -AsPlainText $Password -Force) -erroraction stop
		Add-LocalGroupMember -Group "Administrators" -Member $Username -erroraction stop
		echo "Admin Account Created"
	}catch{
		write-host "Failed Creating $Username's Account:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function rmUser{
	$Username=read-host "Username to delete"
	$choices  = '&Yes', '&No'
	$decision = $Host.UI.PromptForChoice("","Are You Sure You Want To Delete $Username's Account?", $choices, 1)
	if ($decision -eq 0) {
		try{
   			remove-localuser -name $Username -erroraction stop
			echo "$Username Removed"
		}catch{
			write-host "Failed Removing $Username's Account:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
		}
	} else {
   		 userMenu
	}

}
function newUserPassA($Username){
try{
		Set-LocalUser -Name $Username -Password (ConvertTo-SecureString -AsPlainText Cyb3rPatr!0t$ -Force)
		echo "$Username's Password Has Been Changed"
	}catch{
		write-host "Failed Changing $Username's Password:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function newUserPass{
	$Username=read-host "Username to Change Password"
	$Password=read-host "Password to Change To"
	try{
		Set-LocalUser -Name $Username -Password (ConvertTo-SecureString -AsPlainText $Password -Force)
		echo "$Username's Password Has Been Changed"
	}catch{
		write-host "Failed Changing $Username's Password:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function listAllUsers{
	try{
	$accounts=get-localuser
	$ActiveUsers=new-object collections.generic.list[string]
	$ActiveAdmins=new-object collections.generic.list[string]
	$AdgroupObj=[ADSI]"WinNT://localhost/Administrators,group"
	$AdminsObj=@($AdgroupObj.psbase.Invoke("Members"))
	$Admins=($AdminsObj|foreach{$_.GetType.Invoke().InvokeMember("Name",'GetProperty',$null,$_,$null)})
	$UsgroupObj=[ADSI]"WinNT://localhost/Users,group"
	$UsersObj=@($UsgroupObj.psbase.Invoke("Members"))
	$Users=($UsersObj|foreach{$_.GetType.Invoke().InvokeMember("Name",'GetProperty',$null,$_,$null)})
	$GugroupObj=[ADSI]"WinNT://localhost/Guests,group"
	$GuestsObj=@($GugroupObj.psbase.Invoke("Members"))
	$Guests=($GuestsObj|foreach{$_.GetType.Invoke().InvokeMember("Name",'GetProperty',$null,$_,$null)})
	$TroubledMembers=new-object collections.generic.list[string]
	}catch{
		write-host "Failed Collecting Users:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
	$x=0
	while($x -lt $accounts.length){
	try{
	$cur=(Get-WMIObject -ClassName Win32_ComputerSystem).Username
	if(!($cur -contains $accounts.name[$x])){
		if($Admins -contains $accounts.name[$x]){
			$ActiveAdmins.add($accounts.name[$x]+"`r`n")
			#Cyb3rPatr!0t$
			newUserPassA($accounts.name[$x])
			passExpireU($accounts.name[$x])}
		elseif($Users -contains $accounts.name[$x]){
			$ActiveUsers.add($accounts.name[$x]+"`r`n")
			newUserPassA($accounts.name[$x])
			passExpireU($accounts.name[$x])}
		elseif($Guests -contains $accounts.name[$x]){
			$ActiveUsers.add($accounts.name[$x]+"`r`n")}}
	}catch{$TroubledMembers.add($accounts.name[$x])};$x=$x+1}
	echo "If guest and admin appear, they may not be active still (The Roberto's are your friends, Do Not Edit Them)`r`n`r`nADMINS:`r`n$ActiveAdmins`r`nUsers:`r`n$ActiveUsers"|Out-File -FilePath "$files\Temp Files\allUsers.txt"

	notepad "$files\Temp Files\allUsers.txt"
	write-host "All passwords have been set to expire on next login, and all passwords have been set to Cyb3rPatr!0t$"
}
function passExpireU($Username){
	$user=[ADSI]"WinNT://localhost/$Username"
	$user.passwordExpired=1
	$user.setinfo()
}
function passExpire{
	$Username=read-host "Username to Set Password to Expired"
	$user=[ADSI]"WinNT://localhost/$Username"
	$user.passwordExpired=1
	$user.setinfo()
}
#Permision Editing Menu
function permMenu{
	$permOption=read-host "`n`n1. Give Administrator Permissions`n2. Remove Administrator Permissions`n3. List Members of a Group`n4. Create a Group`n5. Assign a user to a Group`n6. Remove a user from a Group`n7. View all groups`n`nYour Selection"
	switch($permOption){
		0{clear;userMenu}
		1{toAdmin}
		2{toUser}
		3{viewAllGroupMembers}
		4{makeCustom}
		5{toCustom}
		6{fromCustom}
		7{listAllGroups}
		defualt{echo `nwrite-warning "'$permOption' is not a valid option`n`n";permMenu}
	}

}
function toAdmin{
	$Username=read-host "Username"
	try{
		Remove-LocalGroupMember -Group "Users" -Member $Username -erroraction stop
		Add-LocalGroupMember -Group "Administrators" -Member $Username -erroraction stop
		echo "$Username, User is now an Admin"
	}catch{
		write-host "Failed Changing Permisions:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function toUser{
	$Username=read-host "Username"
	try{
		Remove-LocalGroupMember -Group "Administrators" -Member $Username -erroraction stop
		Add-LocalGroupMember -Group "Users" -Member $Username -erroraction stop
		echo "$Username, Admin is now a User"
	}catch{
		write-host "Failed Changing Permisions:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function viewAllGroupMembers{
	$Groupname=read-host "Group Name"
	try{
		Get-LocalGroupMember -name $Groupname|format-table -property Name -erroraction stop
	}catch{
		write-host "Failed Getting Groups:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function listAllGroups{
	try{
		get-localgroup|format-table -property Name -erroraction stop
	}catch{
		write-host "Failed Getting Groups:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function makeCustom{
	$Groupname=read-host "New Group Name"
	try{
		Remove-LocalGroupMember -Group "Administrators" -Member $Username -erroraction stop
		Add-LocalGroup -Name $Groupname -erroraction stop
		echo "$Groupname Created"
	}catch{
		write-host "Failed Creating Group:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function toCustom{
	$Username=read-host "Username"
	$Groupname=read-host "Group Name"
	try{
		Add-LocalGroupMember -Group $Groupname -Member $Username -erroraction stop
		echo "$Username is now a $Groupname member"
	}catch{
		write-host "Failed Changing Permisions:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function fromCustom{
	$Username=read-host "Username"
	$Groupname=read-host "Group Name"
	try{
		Remove-LocalGroupMember -Group $Groupname -Member $Username -erroraction stop
		echo "$Username is no longer a $Groupname member"
	}catch{
		write-host "Failed Changing Permisions:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
function listAllGroupMembers{
	$Groupname=read-host "Group Name"
	try{
		Get-LocalGroup -Name $Groupname -erroraction stop
		
	}catch{
		write-host "Failed Getting Group:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}


#Extra Menu
function extrMenu{
	$extrOption=read-host "`n`n1. Get File Hash`n2. NMAP IT`n3. `n4. `n5. `n6. view All group members `n`nYour Selection"
	switch($extrOption){
		0{clear;userMenu}
		1{fileHash}
		2{nmap}
		3{}
		4{}
		5{}
		6{viewAllGroupMembers}
		defualt{echo `nwrite-warning "'$extrOption' is not a valid option`n`n";extrMenu}
	}
	
}
function fileHash{
	$fileLocation=read-host "`nEnter the file location of desired hash file"
	$hashtype=read-host "`nWhat hash algorithm do you want to use ex'md5'"
	try{
		$hash=get-filehash -algorithm $hashtype $fileLocation|select -expand Hash -ErrorAction STOP
		Set-Clipboard -value $hash
		write-host "Hash copied to clipboard:`n$hash"
	}catch{	
		write-host "Failed Fetching $hashtype for $fileLocation`:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}

}
function nmap{
	try{
                echo "Downloading Nmap in Background"
                $downloadjob=start-job -scriptblock {Invoke-WebRequest -OutFile nmap.exe https://nmap.org/dist/nmap-7.92-setup.exe;start nmap.exe}
		echo "Scan with nmap"
		echo "nmap -script vuln"
	}catch{
		write-host "Failed Nmap execution:`n"$PSItem.Exception.Message -ForegroundColor RED -BackgroundColor Black
	}
}
#Auto
function auto{
	#rootkitScan
	#malwareScan
	#start-stop 1
	enableBaseFirewall
	setAdvFirewall
	#start-stop 1
	#scanning=scanAll
	#wait-job scanning[-1]
	removeSharedDrives
	secPol
	disFeatures
	#killServices
	
}



function removeGenedFiles{
	echo "Always have good housekeeping"
	try{
		Remove-Item "$files\Temp Files" -Force -Recurse -erroraction STOP
		New-Item -ItemType directory -Path "$files\Temp Files" -erroraction STOP
	}catch{
		write-host "Failed Cleaning up Generated Files:`n"$PSItem.Exception.Message -ForegroundColor RED -backgroundcolor black
	}
	start-sleep 1
}
function tasks{
	get-job
}
function reboot{
	Restart-computer -Force -Confirm:$false
}

function welcome{
	echo "Windows $os Cyber Script"
	#$PSScriptRoot
	#$PScommandPath
	write-warning "This script can damage a computer.`nBe mindful of what you do"
	echo "`n"
	write-warning "FORENSICS FILES FIRST!!!"
	mainMenu
}

If(-NOT([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")){
start-process "powershell.exe" -argument "-executionpolicy remotesigned","-noexit","-file `"$PScommandPath`"" -verb runas
start-sleep 1
exit
}
clear
$filepath=$PSScriptRoot
try{get-childitem "$filepath\Temp Files"
}catch{
mkdir "$filepath\Temp Files"
}
clear
$os=(Get-WmiObject -class Win32_OperatingSystem).Caption
if ($os -split " " -contains 'Server'){$os='Server'}
if ($os -split " " -contains '10'){$os='10'}
$host.ui.RawUI.WindowTitle="Windows $os Cyber Script - Cyb3rPatr!0t$"
welcome

#write-host "Failed Creating $Username's Account:`n"$PSItem.Exception.Message -ForegroundColor RED
#for($i=1;$i -le 100;$i++){Write-Progress -Activity "Search in Progress" -Status "$i% Completed"}
