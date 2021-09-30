# Get-VM "elk-logstash" | Get-VMNetworkAdapter | Add-VMNetworkAdapter -SwitchName "NATSwitch"
Stop-VM "elk-logstash"
Get-VM "elk-logstash" | Add-VMNetworkAdapter -Name "NATnetz" -SwitchName "NATSwitch" 
Start-VM "elk-logstash"