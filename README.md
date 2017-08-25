# choc-eula
"Everything Updates Like, Automatically!"

# Description
choc-eula, although simple, aims to be a wrapper for Chocolatey which helps automate updates of as well as deployments to new machines.  

# Install
Currently, this assumes that Chocolatey is installed.  

Keep both choc-eula.ps1 and choc-eula.json in the same directory.  The suggested location is "c:\Powershell" but this can be anywhere you see fit.

# Configuration
Edit choc-eula.json and add the name of a [Chocolatey package](https://chocolatey.org/packages) to the list (one per line, comma separated - json syntax).  Keep both files together and back the .json file up - this is a living configuration which will hopefully survive multiple PC builds.  

This is also suitable for installing as a Scheduled Task in Windows, doing so will make sure that all your packages are always up to date. 

