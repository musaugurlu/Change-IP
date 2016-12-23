function Change-IP {
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
Change-Ip -NetIfIndex 12 -NewIP 10.1.10.1
.EXAMPLE
Change-Ip -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -AddrFamily IPv4
.EXAMPLE
Change-Ip 12 10.1.10.11
.EXAMPLE
Change-Ip 12 10.1.10.11 24
.EXAMPLE
Change-Ip -NetIfIndex 12 -NewIP 10.1.10.1 -SubnetLength 24 -GatewayIP $null -DNSIPs $null
.EXAMPLE
Change-Ip -NetIfIndex 10 -NewIP 192.168.1.25 -SubnetLength 23 -GatewayIP 192.168.1.1 -DNSIPs 192.168.1.2,192.168.1.3
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
		[byte]
		$SubnetLength,

		[ValidateSet("IPv4", "IPv6")]
		[string]
		$AddrFamily = "IPv4",

		[string]
		$GatewayIP,

		[string[]]
		$DNSIPs
    )

	$currentip = (Get-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily).IPAddress

	$DHCPState = (Get-NetIPInterface -AddressFamily $AddrFamily -InterfaceIndex $NetIfIndex).Dhcp

	if([string]::IsNullOrEmpty($SubnetLength)) {
		$SubnetPrefixLength = (Get-NetIPAddress -InterfaceIndex 11 -AddressFamily $AddrFamily).PrefixLength
	} else {
		$SubnetPrefixLength = $SubnetLength
	}
	
	if($DHCPState -eq "Disabled") {
		Remove-NetIPAddress -InterfaceIndex $NetIfIndex -IPAddress $currentip -Confirm:$false
	}

	if($PSBoundParameters.ContainsKey("GatewayIP")) {
		New-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily -IPAddress $NewIP -PrefixLength $SubnetPrefixLength -DefaultGateway $GatewayIP -Confirm:$false		
	} else {
		New-NetIPAddress -InterfaceIndex $NetIfIndex -AddressFamily $AddrFamily -IPAddress $NewIP -PrefixLength $SubnetPrefixLength -DefaultGateway -Confirm:$false		
	}

	if($PSBoundParameters.ContainsKey("DNSIPs") {
		Set-DnsClientServerAddress -InterfaceIndex $NetIfIndex -ServerAddresses $DNSIPs
	}
}