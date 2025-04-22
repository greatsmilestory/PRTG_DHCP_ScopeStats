Import-Module DhcpServer

$dhcpServer = "Your Windows Server Hostname" # DHCP server computer name

try {
    $scopes = Get-DhcpServerv4ScopeStatistics -ComputerName $dhcpServer

    if (-not $scopes) {
        throw "No DHCP scopes found"
    }

    Write-Host "<prtg>"

    foreach ($scope in $scopes) {
        $scopeId = $scope.ScopeId.ToString()
        $free = $scope.Free

        Write-Host "  <result>"
        Write-Host "    <channel>Scope $scopeId Free</channel>"
        Write-Host "    <value>$free</value>"
        Write-Host "    <unit>Custom</unit>"
        Write-Host "    <customunit>EA</customunit>"
        Write-Host "    <limitmode>1</limitmode>"	# Lower limit for warning notifications (adjust to desired value)
        Write-Host "    <limitminwarning>10</limitminwarning>"	# Lower limit for down notification (adjust to desired value)
        Write-Host "    <limitminerror>5</limitminerror>"
        Write-Host "  </result>"
    }

    Write-Host "</prtg>"
}
catch {
    Write-Host "<prtg>"
    Write-Host "  <error>1</error>"
    Write-Host "  <text>Script error: $_</text>"
    Write-Host "</prtg>"
}
