# Get-VM "elk-kibana" | Get-VMNetworkAdapter | Add-VMNetworkAdapter -SwitchName "NATSwitch"
Stop-VM "elk-kibana"
Get-VM "elk-kibana" | Add-VMNetworkAdapter -Name "NATnetz" -SwitchName "NATSwitch" 
Start-VM "elk-kibana"