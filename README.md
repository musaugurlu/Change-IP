# Change-IP

Changes your current Ip Address without going to adapter settings, tons of clicks and filling out all the ips.
There is also no need to remove existing IP from powershell if you use powershell `New-NetIPAddress` command to change your IP.

## UPDATE
The command name has been changed to ` Set-IPADDress ` to remove 

## Installation

### Option 1
- Download project as a zip file
- Unzip it to `ProgramFiles\WindowsPowerShell\Modules` folder. (you may open this folder from powershell with this command:  `Invoke-Item $env:ProgramFiles\WindowsPowerShell\Modules`)
- Rename it from `Change-IP-master` to `Change-IP`
- run `Get-Module -ListAvailable` command and make sure the modue is there.

### Option 2
* Downoad Change-IP.psm1 and move it to your desired path.
* Import the module to powershell
> `Import-Module your\path\to\Change-IP.psm1`

### Option 3
 * Use powershell command `Install-Module -Name Change-IP`
 * or, If you just want to save it in a folder and import it, use this `Save-Module -Name Change-IP -Path <path>`

## Requiremet
* You will need to "Run Powershell as Administrator" to change the IP, so to use this module.
* You need to know your Interface Index. You may find it with this command
`Get-NetIPAddress | select ipaddress,interfaceindex`

## Usage
`*` -> Required

* `Set-IPAddress [your interface index]* [new ip]* [Subnet Length Prefix] [Address family] [Gateway IP] [DNS IPs]`
* `Set-IPAddress 12 10.1.10.11`
* `Set-IPAddress -NetIfIndex 12 -NewIP 10.1.10.1`
* `Set-IPAddress 12 10.1.10.11 24`
* `Set-IPAddress -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -AddrFamily IPv4`
* `Set-IPAddress -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -GatewayIP $null -DNSIPs $null`
* `Set-IPAddress -NetIfIndex 10 -NewIP 192.168.1.25 -SubnetLength 23 -GatewayIP 192.168.1.1 -DNSIPs 192.168.1.2,192.168.1.3`

## Note
You will need elevated account to change computer IP address. So will you to use this module as well.

Below is no longer applicaple since the name of the function has been changed from `Change-IP` to `Set-IPAddress`. 

<del> Powershell gives the warning below when the module is imported because the name in the function "Change" is not an approved verb by Powershell. I could use  the verb "Switch" (and the function would be "Switch-IP") but I didn't do it on purpose. I thought Microsoft or someone else may make an official cmdlet with the same name and I would need to change it again.</del>

<del>  Warning: 
`WARNING: The names of some imported commands from the module 'Change-IP' include unapproved verbs that might make them less discoverable. To find the commands with unapproved verbs, run the Import-Module command again with the Verbose parameter. For a list of approved verbs, type Get-Verb.`</del>

<del>You may </del>
* <del>suppress the warning by adding `-DisableNameChecking` to import cmdlet like `Import-Module "path\to\Module" -DisableNameChecking` </del>
* <del>or, you may change the function name from `Change-IP` to `Switch-IP` or to any of the approved verb inside the module file. </del>