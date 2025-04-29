Import-Module DhcpServer

$dhcpServer = "Your Windows Server Hostname"	# DHCP server computer name

# Set output encoding (valid in PowerShell 5.1 and later)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

try {
    $scopes = Get-DhcpServerv4Scope -ComputerName $dhcpServer
    $scopeStats = Get-DhcpServerv4ScopeStatistics -ComputerName $dhcpServer

    if (-not $scopeStats) {
        throw "There is no DHCP scope."
    }

    Write-Output "<prtg>"

    foreach ($stat in $scopeStats) {
        $scopeId = $stat.ScopeId.ToString()
        $free = $stat.Free

        # Scope Name Matching
        $matchingScope = $scopes | Where-Object { $_.ScopeId -eq $stat.ScopeId }
        $scopeName = if ($matchingScope) { $matchingScope.Name } else { "No name" }

        Write-Output "  <result>"
        Write-Output "    <channel>$scopeName ($scopeId) Free</channel>"
        Write-Output "    <value>$free</value>"
        Write-Output "    <unit>Custom</unit>"
        Write-Output "    <customunit>EA</customunit>"
        Write-Output "    <limitmode>1</limitmode>"		# Lower limit for warning notifications (adjust to desired value)
        Write-Output "    <limitminwarning>20</limitminwarning>"		# Lower limit for down notification (adjust to desired value)
        Write-Output "    <limitminerror>10</limitminerror>"
        Write-Output "  </result>"
    }

    Write-Output "</prtg>"
}
catch {
    Write-Output "<prtg>"
    Write-Output "  <error>1</error>"
    Write-Output "  <text>Script error: $_</text>"
    Write-Output "</prtg>"
}
