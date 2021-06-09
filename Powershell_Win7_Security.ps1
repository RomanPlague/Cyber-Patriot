$location="P:\Cyber Files\Scripts"

Add-Type -AssemblyName System.Windows.Forms
#Main Form
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Font = "Comic Sans MS,8.25"
$mainForm.Text = "Choosing Your Operating System"
$mainForm.ForeColor = "White"
$mainForm.BackColor = "DarkBlue"
$mainForm.Width = 500
$mainForm.Height = 550
$mainForm.WindowState=0

#Main Form Direction
$formOneDirections = New-Object System.Windows.Forms.Label
$formOneDirections.Font = "Microsoft Sans Serif,20"
$formOneDirections.Location = "100,25"
$formOneDirections.Size = "325,75"
$formOneDirections.Text = "Choose The Operating System You Are Running"
$mainForm.Controls.Add($formOneDirections)

#Temp Clear Button
$TempClearButton = New-Object System.Windows.Forms.Button
$TempClearButton.Location = "420,485"
$TempClearButton.Size = "55,25"
$TempClearButton.ForeColor = "Black"
$TempClearButton.BackColor = "White"
$TempClearButton.Font = "Microsoft Sans Serif,12"
$TempClearButton.Text = "Clear"
$TempClearButton.Add_Click({
	Remove-Item "P:\Cyber Files\Scripts\Temp Files" -Force -Recurse -ErrorAction SilentlyContinue
	New-Item -ItemType directory -Path "P:\Cyber Files\Scripts\Temp Files"
	})
$mainForm.Controls.Add($TempClearButton)

#Windows 7 Button
$windowsSevenButton = New-Object System.Windows.Forms.Button
$windowsSevenButton.Location = "175,125"
$windowsSevenButton.Size = "150,50"
$windowsSevenButton.ForeColor = "Blue"
$windowsSevenButton.BackColor = "White"
$windowsSevenButton.Font = "Microsoft Sans Serif,12"
$windowsSevenButton.Text = "Windows 7"
$windowsSevenButton.Add_Click({
	$mainForm.WindowState=1
	$sevenForm.ShowDialog()
	$mainForm.close()
	})
$mainForm.Controls.Add($windowsSevenButton)

#Windows 7 Form
$sevenForm = New-Object System.Windows.Forms.Form
$sevenForm.Font = "Microsoft Sans Serif,8.25"
$sevenForm.Text = "Computer Security Script(Win 7)"
$sevenForm.ForeColor = "White"
$sevenForm.BackColor = "DarkBlue"
$sevenForm.Width = 717
$sevenForm.Height = 600
$sevenForm.WindowState=0

#Enable Firewall Button 
$firewallButton = New-Object System.Windows.Forms.Button
$firewallButton.Location = "35,25"
$firewallButton.Size = "75,50"
$firewallButton.ForeColor = "Blue"
$firewallButton.BackColor = "White"
$firewallButton.Text = "Enable Firewall"
$firewallButton.Add_Click({
	start-process "$location\Win 7\Firewall.bat"
	$outputTextBox.AppendText("
Firewall: Enabled
		")
	})
$sevenForm.Controls.Add($firewallButton)

#New User Button
$NewUserButton = New-Object System.Windows.Forms.Button
$NewUserButton.Location = "35,100"
$NewUserButton.Size  = "75,50"
$NewUserButton.ForeColor = "Blue"
$NewUserButton.BackColor = "White"
$NewUserButton.Text = "Create A User"
$NewUserButton.Add_Click({
	$NewUserForm.ShowDialog()
	
})
$sevenForm.Controls.Add($NewUserButton)

#New User Form
$NewUserForm = New-Object System.Windows.Forms.Form
$NewUserForm.Font = "Microsoft Sans Serif,8.25"
$NewUserForm.Text = "Creating A New User"
$NewUserForm.ForeColor = "Black"
$NewUserForm.BackColor = "White"
$NewUserForm.Width = 300
$NewUserForm.Height = 200

#New User Username Text Box
$NewUsernameTextBox = New-Object System.Windows.Forms.TextBox
$NewUsernameTextBox.Location = "30,30"
$NewUsernameTextBox.Size = "100,20"
$NewUsernameTextBox.Text = "Username"
$NewUserForm.Controls.Add($NewUsernameTextBox)


$NewUsernameTextBox.Add_LostFocus({
	if($NewUsernameTextBox.Text -eq ""){
	$NewUsernameTextBox.Text ="Username"
	}

})

#New User Password Text Box
$NewPasswordTextBox = New-Object System.Windows.Forms.TextBox
$NewPasswordTextBox.Location = "160,30"
$NewPasswordTextBox.Size = "100,20"
$NewPasswordTextBox.Text="Password"
$NewUserForm.Controls.Add($NewPasswordTextBox)

$NewPasswordTextBox.Add_GotFocus({
	if($NewPasswordTextBox.Text -eq "Password"){
	$NewPasswordTextBox.Text =""
	}

})

$NewPasswordTextBox.Add_LostFocus({
	if($NewPasswordTextBox.Text -eq ""){
	$NewPasswordTextBox.Text ="Password"
	}

})

#Create On New User Form Button
$createUserButton = New-Object System.Windows.Forms.Button
$createUserButton.Location = "35,100"
$createUserButton.Size  = "75,50"
$createUserButton.ForeColor = "Blue"
$createUserButton.BackColor = "White"
$createUserButton.Text = "Create"
$createUserButton.Add_Click({
	$Username=$NewUsernameTextBox.Text
	$Password=$NewPasswordTextBox.Text
	if (!$TwoNamesBox.Checked -and !$AdminBox.Checked){
		start-process "$location\Win 7\Create_New_User.bat" "$Username", $Password -Wait
		$outputTextBox.AppendText("
User Created:
Username: '$Username'
Password: '$Password'
		")
	}
	if ($TwoNamesBox.Checked -and !$AdminBox.Checked){
		start-process "$location\Win 7\Create_New_User_2_Names.bat" "$Username", $Password -Wait
		$outputTextBox.AppendText("
User Created:
Username: '$Username'
Password: '$Password'
		")
	}
	if ($AdminBox.Checked -and !$TwoNamesBox.Checked){
		start-process "$location\Win 7\Create_New_User.bat" "$Username", $Password -Wait
		start-process "$location\Win 7\Make_Account_Admin.bat" "$Username" -Wait
		$outputTextBox.AppendText("
Admin Created:
Username: '$Username'
Password: '$Password'
		")
	}
	if ($TwoNamesBox.Checked -and $AdminBox.Checked){
		start-process "$location\Win 7\Create_New_User_2_Names.bat" "$Username", $Password -Wait
		start-process "$location\Win 7\Make_Account_Admin_2_Names.bat" "$Username" -Wait
		$outputTextBox.AppendText("
Admin Created:
Username: '$Username'
Password: '$Password'
		")
	}
	$NewUserForm.close()
})
$NewUserForm.Controls.Add($createUserButton)

#Cancel User Form Button
$CancelUserButton = New-Object System.Windows.Forms.Button
$CancelUserButton.Location="165,100"
$CancelUserButton.Size  = "75,50"
$CancelUserButton.ForeColor = "Red"
$CancelUserButton.BackColor = "White"
$CancelUserButton.Text = "Cancel"
$CancelUserButton.Add_Click({
	$NewUserForm.close()
})
$NewUserForm.Controls.Add($CancelUserButton)

#Check if new Account has 2 names
$TwoNamesBox=New-Object System.Windows.Forms.Checkbox
$TwoNamesBox.Location="30,30"
$TwoNamesBox.Size="100,100"
$TwoNamesBox.Text="For A User With 2 Names"
$NewUserForm.Controls.Add($TwoNamesBox)

#Check if new Account Needs to be Admin
$AdminBox=New-Object System.Windows.Forms.Checkbox
$AdminBox.Location="160,30"
$AdminBox.Size="100,100"
$AdminBox.Text="For An Admin Account"
$NewUserForm.Controls.Add($AdminBox)


#Enable CtrlAltDel On Boot Button 
$CtrlAltDelButton = New-Object System.Windows.Forms.Button
$CtrlAltDelButton.Location = "35,175"
$CtrlAltDelButton.Size = "75,50"
$CtrlAltDelButton.ForeColor = "Blue"
$CtrlAltDelButton.BackColor = "White"
$CtrlAltDelButton.Text = "Enable Ctrl Alt Del On Boot"
$CtrlAltDelButton.Add_Click({
	start-process "$location\Win 7\CtrlAltDel_On_Launch.bat"
	$outputTextBox.AppendText("
CtrlAltDel: Enabled
		")
	})
$sevenForm.Controls.Add($CtrlAltDelButton)

#Delete User Button
$DelUserButton = New-Object System.Windows.Forms.Button
$DelUserButton.Location = "35,250"
$DelUserButton.Size  = "75,50"
$DelUserButton.ForeColor = "Blue"
$DelUserButton.BackColor = "White"
$DelUserButton.Text = "Delete A User"
$DelUserButton.Add_Click({
	$DelUserForm.ShowDialog()
	
})
$sevenForm.Controls.Add($DelUserButton)

#Delete User Form
$DelUserForm = New-Object System.Windows.Forms.Form
$DelUserForm.Font = "Microsoft Sans Serif,8.25"
$DelUserForm.Text = "Deleting A User"
$DelUserForm.ForeColor = "Black"
$DelUserForm.BackColor = "White"
$DelUserForm.Width = 300
$DelUserForm.Height = 200

#Delete User Text Box
$DelUsernameTextBox = New-Object System.Windows.Forms.TextBox
$DelUsernameTextBox.Location = "30,30"
$DelUsernameTextBox.Size = "100,20"
$DelUsernameTextBox.Text = "Username"
$DelUserForm.Controls.Add($DelUsernameTextBox)


$DelUsernameTextBox.Add_LostFocus({
	if($DelUsernameTextBox.Text -eq ""){
	$DelUsernameTextBox.Text ="Username"
	}

})

#Check if new Account has 2 names
$TwoNamesBoxDel=New-Object System.Windows.Forms.Checkbox
$TwoNamesBoxDel.Location="30,50"
$TwoNamesBoxDel.Size="100,50"
$TwoNamesBoxDel.Text="For A User With 2 Names"
$DelUserForm.Controls.Add($TwoNamesBoxDel)

#Delete User Form Button
$DeleteUserButton = New-Object System.Windows.Forms.Button
$DeleteUserButton.Location = "35,100"
$DeleteUserButton.Size  = "75,50"
$DeleteUserButton.ForeColor = "Blue"
$DeleteUserButton.BackColor = "White"
$DeleteUserButton.Text = "Delete"
$DeleteUserButton.Add_Click({
	$Username=$DelUsernameTextBox.Text
	if (!$TwoNamesBoxDel.Checked){
		start-process "$location\Win 7\Remove_User.bat" "$Username" -Wait
	}
	if ($TwoNamesBoxDel.Checked){
		start-process "$location\Win 7\Remove_User_2_Names.bat" "$Username" -Wait
	}
	$outputTextBox.AppendText("
User Deleted:
Username: '$Username'
")
	$DelUserForm.close()
})

$DelUserForm.Controls.Add($DeleteUserButton)

#Cancel Delete User Form Button
$CancelUserButton = New-Object System.Windows.Forms.Button
$CancelUserButton.Location="165,100"
$CancelUserButton.Size  = "75,50"
$CancelUserButton.ForeColor = "Red"
$CancelUserButton.BackColor = "White"
$CancelUserButton.Text = "Cancel"
$CancelUserButton.Add_Click({
	$DelUserForm.close()
})
$DelUserForm.Controls.Add($CancelUserButton)

#Output Box For User List Update Button
$UserListUpdate = New-Object System.Windows.Forms.Button
$UserListUpdate.Location = "530,510"
$UserListUpdate.Size = "150,40"
$UserListUpdate.ForeColor = "Blue"
$UserListUpdate.BackColor = "White"
$UserListUpdate.Text = "View Accounts"
$UserListUpdate.Add_Click({
	Remove-Item "P:\Cyber Files\Scripts\Temp Files\users1.txt","P:\Cyber Files\Scripts\Temp Files\users.txt"
	start-process "$location\Win 7\All_Users.bat"  -Wait
	Select-String 'Alias name','are prevented','command comp','have complete','members','-----','NT AU' "$location\Temp Files\users.txt" -notmatch | % {$_.Line} | set-content "$location\Temp Files\users1.txt"
	$UserList = Get-Content -path "$location\Temp Files\users1.txt"
		$outputTextBox.AppendText("
$UserList
		")
	})
$sevenForm.controls.Add($UserListUpdate)

#Change User Permisions
$ChangePermButton = New-Object System.Windows.Forms.Button
$ChangePermButton.Location = "35,325"
$ChangePermButton.Size  = "75,50"
$ChangePermButton.ForeColor = "Blue"
$ChangePermButton.BackColor = "White"
$ChangePermButton.Text = "Change User Permisions"
$ChangePermButton.Add_Click({
	$ChangePermForm.ShowDialog()
	
})
$sevenForm.Controls.Add($ChangePermButton)

#Change User Permision Form
$ChangePermForm = New-Object System.Windows.Forms.Form
$ChangePermForm.Font = "Microsoft Sans Serif,8.25"
$ChangePermForm.Text = "Changing User Permisions"
$ChangePermForm.ForeColor = "Black"
$ChangePermForm.BackColor = "White"
$ChangePermForm.Width = 300
$ChangePermForm.Height = 200

#Change User Permision Text Box
$ChangePermUsernameTextBox = New-Object System.Windows.Forms.TextBox
$ChangePermUsernameTextBox.Location = "30,30"
$ChangePermUsernameTextBox.Size = "100,20"
$ChangePermUsernameTextBox.Text = "Username"
$ChangePermForm.Controls.Add($ChangePermUsernameTextBox)


$ChangePermUsernameTextBox.Add_LostFocus({
	if($ChangePermUsernameTextBox.Text -eq ""){
	$ChangePermUsernameTextBox.Text ="Username"
	}

})

#Change Account To Admin
$ToAdminBox=New-Object System.Windows.Forms.Checkbox
$ToAdminBox.Location="30,50"
$ToAdminBox.Size="100,50"
$ToAdminBox.Text="To Admin"
$ChangePermForm.Controls.Add($ToAdminBox)

#Change Account To User
$ToUserBox=New-Object System.Windows.Forms.Checkbox
$ToUserBox.Location="160,62"
$ToUserBox.Size="100,25"
$ToUserBox.Text="To User"
$ChangePermForm.Controls.Add($ToUserBox)

#Account has 2 names
$TwoNamesBox=New-Object System.Windows.Forms.Checkbox
$TwoNamesBox.Location="160,30"
$TwoNamesBox.Size="100,25"
$TwoNamesBox.Text="User With 2 Names"
$ChangePermForm.Controls.Add($TwoNamesBox)

#Change User Form Button
$ChangeUserButton = New-Object System.Windows.Forms.Button
$ChangeUserButton.Location = "35,100"
$ChangeUserButton.Size  = "75,50"
$ChangeUserButton.ForeColor = "Blue"
$ChangeUserButton.BackColor = "White"
$ChangeUserButton.Text = "Change"
$ChangeUserButton.Add_Click({
	$Username=$ChangePermUsernameTextBox.Text
	if ($ToUserBox.Checked){
		start-process "$location\Win 7\Make_Account_User.bat" "$Username" -Wait
		$outputTextBox.AppendText("
User Made User:
Username: '$Username'
")
	}
	if ($ToAdminBox.Checked){
		start-process "$location\Win 7\Make_Account_Admin.bat" "$Username" -Wait
		$outputTextBox.AppendText("
User Made Admin:
Username: '$Username'
")
	}
	if ($ToUserBox.Checked -and $TwoNamesBox){
		start-process "$location\Win 7\Make_Account_User_2_Names.bat" "$Username" -Wait
		$outputTextBox.AppendText("
User Made User:
Username: '$Username'
")
	}
	if ($ToAdminBox.Checked -and $TwoNamesBox){
		start-process "$location\Win 7\Make_Account_Admin_2_Names.bat" "$Username" -Wait
		$outputTextBox.AppendText("
User Made Admin:
Username: '$Username'
")
	}
	
	$ChangePermForm.close()
})

$ChangePermForm.Controls.Add($ChangeUserButton)

#Cancel Perm Change Form Button
$ChangePermButton = New-Object System.Windows.Forms.Button
$ChangePermButton.Location="165,100"
$ChangePermButton.Size  = "75,50"
$ChangePermButton.ForeColor = "Red"
$ChangePermButton.BackColor = "White"
$ChangePermButton.Text = "Cancel"
$ChangePermButton.Add_Click({
	$ChangePermForm.close()
})
$ChangePermForm.Controls.Add($ChangePermButton)

#Change User Password Button
$ChangeUserButton = New-Object System.Windows.Forms.Button
$ChangeUserButton.Location = "35,400"
$ChangeUserButton.Size  = "75,50"
$ChangeUserButton.ForeColor = "Blue"
$ChangeUserButton.BackColor = "White"
$ChangeUserButton.Text = "Change User Password"
$ChangeUserButton.Add_Click({
	$ChangeUserForm.ShowDialog()
	
})
$sevenForm.Controls.Add($ChangeUserButton)

#Change User Password Form
$ChangeUserForm = New-Object System.Windows.Forms.Form
$ChangeUserForm.Font = "Microsoft Sans Serif,8.25"
$ChangeUserForm.Text = "Changing a User Password"
$ChangeUserForm.ForeColor = "Black"
$ChangeUserForm.BackColor = "White"
$ChangeUserForm.Width = 300
$ChangeUserForm.Height = 200

#Change User Password Username Text Box
$NewPasswordUsernameTextBox = New-Object System.Windows.Forms.TextBox
$NewPasswordUsernameTextBox.Location = "30,30"
$NewPasswordUsernameTextBox.Size = "100,20"
$NewPasswordUsernameTextBox.Text = "Username"
$ChangeUserForm.Controls.Add($NewPasswordUsernameTextBox)

$NewPasswordTextBox.Add_GotFocus({
	if($NewPasswordTextBox.Text -eq "Username"){
	$NewPasswordTextBox.Text =""
	}
})

$NewPasswordTextBox.Add_LostFocus({
	if($NewPasswordTextBox.Text -eq ""){
	$NewPasswordTextBox.Text ="Username"
	}

})

#Change User Password Text Box
$NewPasswordTextBox = New-Object System.Windows.Forms.TextBox
$NewPasswordTextBox.Location = "160,30"
$NewPasswordTextBox.Size = "100,20"
$NewPasswordTextBox.Text = "Password"
$ChangeUserForm.Controls.Add($NewPasswordTextBox)

$NewPasswordTextBox.Add_GotFocus({
	if($NewPasswordTextBox.Text -eq "Password"){
	$NewPasswordTextBox.Text =""
	}
})

$NewPasswordTextBox.Add_LostFocus({
	if($NewPasswordTextBox.Text -eq ""){
	$NewPasswordTextBox.Text ="Password"
	}

})

#Create Button New Pass Form
$SavePassButton = New-Object System.Windows.Forms.Button
$SavePassButton.Location = "35,100"
$SavePassButton.Size  = "75,50"
$SavePassButton.ForeColor = "Blue"
$SavePassButton.BackColor = "White"
$SavePassButton.Text = "Save"
$SavePassButton.Add_Click({
	$Password=$NewPasswordTextBox.Text
	if (!$TwoNamesBox.Checked){
		start-process "$location\Win 7\Password_Change.bat" "$Username", $Password -Wait
		$outputTextBox.AppendText("
Password Changed:
Username: '$Username'
Password: '$Password'
		")
	}
	if ($TwoNamesBox.Checked){
		start-process "$location\Win 7\Password_Change_2_Names.bat" "$Username", $Password -Wait
		$outputTextBox.AppendText("
Password Changed:
Username: '$Username'
Password: '$Password'
		")
	}
	$ChangeUserForm.close()
})
$ChangeUserForm.Controls.Add($SavePassButton)

#Cancel User Form Button
$CancelUserButton = New-Object System.Windows.Forms.Button
$CancelUserButton.Location="165,100"
$CancelUserButton.Size  = "75,50"
$CancelUserButton.ForeColor = "Red"
$CancelUserButton.BackColor = "White"
$CancelUserButton.Text = "Cancel"
$CancelUserButton.Add_Click({
	$ChangeUserForm.close()
})
$ChangeUserForm.Controls.Add($CancelUserButton)

#Check If Account has 2 names
$TwoNamesBox=New-Object System.Windows.Forms.Checkbox
$TwoNamesBox.Location="30,30"
$TwoNamesBox.Size="100,100"
$TwoNamesBox.Text="For A User With 2 Names"
$ChangeUserForm.Controls.Add($TwoNamesBox)

#Disable Guest Button 
$DisableGuestButton = New-Object System.Windows.Forms.Button
$DisableGuestButton.Location = "35,475"
$DisableGuestButton.Size = "75,50"
$DisableGuestButton.ForeColor = "Blue"
$DisableGuestButton.BackColor = "White"
$DisableGuestButton.Text = "Disable Guest"
$DisableGuestButton.Add_Click({
	start-process "$location\Win 7\Disable_Guest.bat"
	$outputTextBox.AppendText("
Guest: Disabled
Admin: Disabled
		")
	})
$sevenForm.Controls.Add($DisableGuestButton)

#Disable C Drive Sharing Button 
$DisableCShareButton = New-Object System.Windows.Forms.Button
$DisableCShareButton.Location = "145,25"
$DisableCShareButton.Size = "75,50"
$DisableCShareButton.ForeColor = "Blue"
$DisableCShareButton.BackColor = "White"
$DisableCShareButton.Text = "Disable C Sharing"
$DisableCShareButton.Add_Click({
	start-process "$location\Win 7\Disable_C_Drive_Share.bat"
	$outputTextBox.AppendText("
C Drive Sharing: Disabled
		")
	})
$sevenForm.Controls.Add($DisableCShareButton)

#Disable FTP Services Button 
$DisableFTPButton = New-Object System.Windows.Forms.Button
$DisableFTPButton.Location = "145,100"
$DisableFTPButton.Size = "75,50"
$DisableFTPButton.ForeColor = "Blue"
$DisableFTPButton.BackColor = "White"
$DisableFTPButton.Text = "Disable FTP Services"
$DisableFTPButton.Add_Click({
	start-process "$location\Win 7\Disable_FTP.bat"
	$outputTextBox.AppendText("
FTP Services: Disabled
		")
	})
$sevenForm.Controls.Add($DisableFTPButton)

#Enable Auto Update Button 
$EnableAutoUpButton = New-Object System.Windows.Forms.Button
$EnableAutoUpButton.Location = "145,175"
$EnableAutoUpButton.Size = "75,50"
$EnableAutoUpButton.ForeColor = "Blue"
$EnableAutoUpButton.BackColor = "White"
$EnableAutoUpButton.Text = "Enable Auto Updates"
$EnableAutoUpButton.Add_Click({
	start-process "$location\Win 7\Enable_Auto_Update.bat"
	$outputTextBox.AppendText("
Auto Update: Enabled
		")
	})
$sevenForm.Controls.Add($EnableAutoUpButton)

#File Find Button
$FileFindButton = New-Object System.Windows.Forms.Button
$FileFindButton.Location = "145,250"
$FileFindButton.Size = "75,50"
$FileFindButton.ForeColor = "Blue"
$FileFindButton.BackColor = "White"
$FileFindButton.Text = "Find Files"
$FileFindButton.Add_Click({
	$FindFileForm.ShowDialog()
	})
$sevenForm.Controls.Add($FileFindButton)

#Find File Form
$FindFileForm = New-Object System.Windows.Forms.Form
$FindFileForm.Font = "Microsoft Sans Serif,8.25"
$FindFileForm.Text = "Deleting A User"
$FindFileForm.ForeColor = "Black"
$FindFileForm.BackColor = "White"
$FindFileForm.Width = 300
$FindFileForm.Height = 200

#Find File Label (To Long to Put In Box)
$FileFindLabel = New-Object System.Windows.Forms.Label
$FileFindLabel.Font = "Comic Sans MS,10"
$FileFindLabel.Location = "30,10"
$FileFindLabel.Size = "135,20"
$FileFindLabel.Text = "Extension (.ext)"
$FindFileForm.Controls.Add($FileFindLabel)

#Find FileText Box
$FindFileTextBox = New-Object System.Windows.Forms.TextBox
$FindFileTextBox.Location = "30,30"
$FindFileTextBox.Size = "100,20"
$FindFileTextBox.Text = ""
$FindFileForm.Controls.Add($FindFileTextBox)

#Check if Files Are To Be Deleted
$DelFilesBox=New-Object System.Windows.Forms.Checkbox
$DelFilesBox.Location="30,50"
$DelFilesBox.Size="100,50"
$DelFilesBox.Text="Delete Files On Find"
$FindFileForm.Controls.Add($DelFilesBox)

#Find Files Form Button
$FindFilesButton = New-Object System.Windows.Forms.Button
$FindFilesButton.Location = "35,100"
$FindFilesButton.Size  = "75,50"
$FindFilesButton.ForeColor = "Blue"
$FindFilesButton.BackColor = "White"
$FindFilesButton.Text = "Find"
$FindFilesButton.Add_Click({
	$File=$FindFileTextBox.Text
	if (!$DelFilesBox.Checked){
		start-process "$location\Win 7\File_Find_Ext.bat" "$File" -Wait
		$outputTextBox.AppendText("
Extension Type: $File
")
	start-sleep -seconds 2
	notepad "$location\Temp Files\'$File'_Ext.txt"
	$FindFileForm.close()
	}
	if ($DelFilesBox.Checked){
		start-process "$location\Win 7\File_Find_Ext_Del.bat" "$File" -Wait
		$outputTextBox.AppendText("
Deleting Extension Type: $File
")
	start-sleep -seconds 2
	notepad "$location\Temp Files\'$File'_Ext_Del.txt"
	$FindFileForm.close()
	}
})
$FindFileForm.Controls.Add($FindFilesButton)

#Cancel Delete User Form Button
$CancelUserButton = New-Object System.Windows.Forms.Button
$CancelUserButton.Location="165,100"
$CancelUserButton.Size  = "75,50"
$CancelUserButton.ForeColor = "Red"
$CancelUserButton.BackColor = "White"
$CancelUserButton.Text = "Cancel"
$CancelUserButton.Add_Click({
	$FindFileForm.close()
})
$FindFileForm.Controls.Add($CancelUserButton)

#Password Complexities Button 
$PassCompButton = New-Object System.Windows.Forms.Button
$PassCompButton.Location = "145,325"
$PassCompButton.Size = "75,50"
$PassCompButton.ForeColor = "Blue"
$PassCompButton.BackColor = "White"
$PassCompButton.Text = "Update Local Security Policy"
$PassCompButton.Add_Click({
	start-process "$location\Win 7\Update_Local_Security_Policy.bat"
	$outputTextBox.AppendText("
Password Complexity:
Max Password Age: 90
Min Password Age: 30
Min Password Length: 8
		")
	})
$sevenForm.Controls.Add($PassCompButton)

#Output Box
$outputTextBox = New-Object System.Windows.Forms.TextBox
$outputTextBox.Multiline = $true
$outputTextBox.Width = 200
$outputTextBox.Height = 500
$outputTextBox.Location = "500,1" 
$outputTextBox.ForeColor = "Black"
$outputTextBox.ReadOnly=$True
$outputTextBox.Scrollbars="Vertical"
$outputTextBox.Font = "Microsoft Sans Serif, 10"
$outputTextBox.Text = "Status:
"
$sevenForm.controls.Add($outputTextBox)

[void] $mainForm.ShowDialog()