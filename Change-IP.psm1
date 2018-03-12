#Requires -RunAsAdministrator

function Set-IPAddress {
<#
.SYNOPSIS
Changes your current Ip Address
.DESCRIPTION
The cmdlet changes your ip address to new ip given without clicks on gui or need of removeving NetIppAddress
.PARAMETER NetIfIndex
Index number of the Adapter you want to change the Ip of
.PARAMETER NewIP
Your New Ip Address. For Now, This cmdlet supports only ipv4
.PARAMETER Subnetlength
Subnet Prefix Length for your new IP. (e.g. 24 for 255.255.255.0, 23 for 255.255.254.0, 22 for 255.255.252.0, ...)
Default value is your current Subnet prefix length
.PARAMETER AddrFamily
Ip Address Family. Either IPv4 or IPv6
Default value is IPv4
.PARAMETER GatewayIP
Sets gateway address
.PARAMETER DNSIPs
Sets DNS Server addresses
.EXAMPLE
Set-IPAddress -NetIfIndex 12 -NewIP 10.1.10.1
.EXAMPLE
Set-IPAddress -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -AddrFamily IPv4
.EXAMPLE
Set-IPAddress 12 10.1.10.11
.EXAMPLE
Set-IPAddress 12 10.1.10.11 24
.EXAMPLE
Set-IPAddress -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -GatewayIP $null -DNSIPs $null
.EXAMPLE
Set-IPAddress -NetIfIndex 10 -NewIP 192.168.1.25 -SubnetLength 23 -GatewayIP 192.168.1.1 -DNSIPs 192.168.1.2,192.168.1.3
#>

	[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position= 0)]
        [int]
        $NetIfIndex,

        [Parameter(Mandatory=$true, Position= 1)]
        [string]
        $NewIP,

		[Parameter(position = 2)]
		[string]
		$SubnetLength,

		[ValidateSet("IPv4", "IPv6")]
		[string]
		$AddrFamily = "IPv4",

		[string]
		$GatewayIP,

		[string[]]
		$DNSIPs
    )

	#Get Current IP which is needed to remove old IP first
	$currentip = (Get-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily).IPAddress

	#Get DHCP State.
	$DHCPState = (Get-NetIPInterface -AddressFamily $AddrFamily -InterfaceIndex $NetIfIndex).Dhcp
	
	#If Subnetprefix not provided, Use the current one
	if([string]::IsNullOrEmpty($SubnetLength)) {
		$SubnetPrefixLength = (Get-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily).PrefixLength
	} else {
		$SubnetPrefixLength = $SubnetLength
	}
	
	#If DHCP State is disabled, remove the old static IP. if not, no need to remove it.
	if($DHCPState -eq "Disabled") {
		Remove-NetIPAddress -InterfaceIndex $NetIfIndex -IPAddress $currentip -Confirm:$false
	}
	

	#if Gateway address provided, set Default Gateway. if not, system will use the old one
	if($PSBoundParameters.ContainsKey("GatewayIP")) {
				
		$CurrentGatewayIP = (Get-NetRoute -InterfaceIndex $NetIfIndex -EA SilentlyContinue | Where-Object {($_.DestinationPrefix -like "0.0.0.0/0")}).NextHop
		
		#Remove Default Gateway if exist
		if($CurrentGatewayIP -notlike "") {
			Remove-NetRoute -InterfaceIndex $NetIfIndex -Confirm:$false
		}
		#if given Gateway IP is $null, don't set Gateway ip(already removed). if not $null, then set given Gateway IP as Gateway
		if($GatewayIP -like $null) {
			New-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily -IPAddress $NewIP -PrefixLength $SubnetPrefixLength -Confirm:$false
		} else {
			New-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily -IPAddress $NewIP -PrefixLength $SubnetPrefixLength -DefaultGateway $GatewayIP -Confirm:$false
		}
				
	} else {
		New-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily -IPAddress $NewIP -PrefixLength $SubnetPrefixLength -Confirm:$false
	}

	#If DNS Addresses provided, set them up
	if($PSBoundParameters.ContainsKey("DNSIPs")) {

		#if given DNS address is $null, then remove DNS addresses. if not, set them up
		if($DNSIPs -eq $null) {
			Set-DnsClientServerAddress -InterfaceIndex $NetIfIndex -ResetServerAddresses
		} else {
			Set-DnsClientServerAddress -InterfaceIndex $NetIfIndex -ServerAddresses $DNSIPs
		}
	}
}