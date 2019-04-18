# Windows has system variables -- check them out from Command Prompt by typing 'Set'
# PowerShell can change location to "env:" and see the same environment variables
Set-Location -Path "env:"
Dir  ## Check out all those environment variables! Pay attention to Path, SystemDrive

## PS: Isn't it cool to be able to access variables like a Drive Path?
Get-PSDrive     ## This lists all accessible drives, including environment variables and registry hives like CurrentUser, LocalMachine
## In fact, can even change location to an Organizational Unit, and thus run commands directly in Active Directory!
## Set-Location 'AD:\ou=Sales,dc=my,dc=com'

# Change Directory to Registry -- Current User
Set-Location -Path "HKCU:"

# Change Path to User Environment variables
cd .\Environment

# View all variables (2 ways)
Get-Item .
Get-ItemProperty .

if ((Get-ItemProperty -Path "HKCU:\Environment") -match "Path") {write-host "yes"} else {write-host "no"}

# View Path variable (2 ways)
Get-ItemProperty . | Select Path
Get-ItemPropertyValue -Name Path     ## This way returns a string!

# Compare Path, see if it has what we want!
$cPath = Get-ItemPropertyValue -Name Path
$cPath -like "*SolidWorks*" ## Returns True if 'SolidWorks' anywhere within Path!

# Add desired path to existing Path (assuming comparison was False... add If statement to confirm!)
$cPath += ";C:\SolidWorks\"           ## started with ; otherwise would mess up existing Path

# What if no C: Drive? Then the systemdrive variable would point to another drive!

$cPath += "$env:SystemDrive\SolidWorks\"         ## will be c: for most systems
## How did I know to use $env:SystemDrive notation? Searched online... https://wingleungchan.blogspot.com/2013/06/systemdrive-in-powershell.html helped!

$cPath          ## See the current value of your modified Path variable... before making changes back!

# Change Path variable
Set-ItemProperty -Path 'HKCU\Environment' -Name Path -Value $cPath
