# choc-eula
"**E**verything **U**pdates **L**ike, **A**utomatically!"

# Description
choc-eula aims to be a wrapper for Chocolatey which helps automate updates of, as well as new deployments of, [Chocolatey](https://chocolatey.org/) packages.  

# Install
Currently, this assumes that Chocolatey is installed.  

Keep both choc-eula.ps1 and choc-eula.json in the same directory.  The suggested location is "c:\Powershell" but this can be anywhere you see fit.

# Configuration and operation
Use the -configure parameter to add or remove [Chocolatey packages](https://chocolatey.org/packages) to the list.  

`choc-eula.ps1 -configure`

A sample list is included, you can modify as desired.

Keep the PS1 script and JSON file together and back the .json file up - this is your personal, living configuration which will hopefully survive multiple PC builds.  You can continue to make changes to this for the duration of your use of choc-eula, and the usefulness will grow with with the file.

Whenever you want to update or install your apps, simply run choc-eula.ps1 from an administrative Powershell prompt.  
`choc-eula.ps1`
This will automatically accept EULAs and proceed with upgrades of all apps in your configuration without additional confirmation.

This is also suitable for installing as a Scheduled Task in Windows, doing so will make sure that all your packages are always up to date. 

