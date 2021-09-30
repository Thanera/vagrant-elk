# Get-VM "elk-elasticsearch" | Get-VMNetworkAdapter | Add-VMNetworkAdapter -SwitchName "NATSwitch"
Stop-VM "elk-elasticsearch"
Get-VM "elk-elasticsearch" | Add-VMNetworkAdapter -Name "NATnetz" -SwitchName "NATSwitch" 
Start-VM "elk-elasticsearch"