$username = "{domainName}\{userName}" 
$domainname = "{domainName}"
$password = ConvertTo-SecureString "{password}" -AsPlainText -Force 
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password) 
add-computer -domainname $domainname -credential $psCred -restart -force 
