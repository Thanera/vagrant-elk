#Pfadvaiablen
$ChocoPath = ""
$VagrantPath = "C:\"

#Abfrage ob Chocolatey installiert ist
if ( !Test-Path -Path $ChocoPath ) {
    Write-Host -ForegroundColor "Chocolatey wird installiert"
    #Requires -RunAsAdministrator
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

#Abfrage nach Vagrant und evtl installation
if ( !Test-Path -Path $VagrantPath ) {


}

# Erstellen eines Externen Switches (Name für den Adapter und verzweigung ob vorhanden hinzufügen!)
# mit "Get-NetAdapter" können die Werte abgerufen werden

New-VMSwitch -name ExternalSwitch  -NetAdapterName Ethernet -AllowManagementOS $true