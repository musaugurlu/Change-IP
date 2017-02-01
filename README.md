# Change-IP

Changes your current Ip Address without going to adapter settings, tons of clicks and filling out all the ips.
There is also no need to remove existing IP from powershell if you use powershell `New-NetIPAddress` command to change your IP.


## Installation

### Option 1
* Downoad Change-IP.psm1 and move it to your desired path.
* Import the module the powershell
> `Import-Module your\path\to\Change-IP.psm1`

### option 2
 * Use powershell command `Install-Module -Name Change-IP`
 * or, If you just want to save it a folder an import it, use this `Save-Module -Name Change-IP -Path <path>`

## Requiremet

You need to know your Interface Index. you may find it by this command
`Get-NetIPAddress | select ipaddress,interfaceindex`

## Usage
`*` -> Required

* `Change-IP [your interface index]* [new ip]* [Subnet Length Prefix] [Address family] [Gateway IP] [DNS IPs]`
* `Change-IP 12 10.1.10.11`
* `Change-IP -NetIfIndex 12 -NewIP 10.1.10.1`
* `Change-IP 12 10.1.10.11 24`
* `Change-IP -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -AddrFamily IPv4`
* `Change-Ip -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -GatewayIP $null -DNSIPs $null`
* `Change-Ip -NetIfIndex 10 -NewIP 192.168.1.25 -SubnetLength 23 -GatewayIP 192.168.1.1 -DNSIPs 192.168.1.2,192.168.1.3`

`NOT: You need to run powershell with Administrative priviliges to change IP and use this module. Otherwise, it will throw 'Access Denied' error.`