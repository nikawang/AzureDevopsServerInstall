$username = "qijige.info\zhawadministrator" 
$domainname = "qijige.info"
$password = ConvertTo-SecureString "!@#QWEqwe123" -AsPlainText -Force 
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password) 
add-computer -domainname $domainname -credential $psCred -restart -force 
