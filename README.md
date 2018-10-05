# choc-eula
"**E**verything **U**pdates **L**ike, **A**utomatically!"

# Description
choc-eula aims to be a wrapper for Chocolatey which helps automate updates of, as well as new deployments of, [Chocolatey](https://chocolatey.org/) packages.  

# Install
Currently, this assumes that Chocolatey is [installed](https://chocolatey.org/install).  Having met that requirement, download the files from this repository, keeping both choc-eula.ps1 and choc-eula.json in the same directory.  The suggested location is "c:\Powershell" but this can be anywhere you see fit.

The choc-eula.json file included in this repository is a sample, you can modify as desired.  Using the `-configfile` parameter in combination with any other parameters, you can also use a custom list - you can keep as many as you want!


# Configuration and operation
Use the `-add` and `-delete` parameters to add or remove [Chocolatey packages](https://chocolatey.org/packages) to the list.  

You can check the current list of packages with:
  `choc-eula.ps1 -showconfig`

Whenever you want to update or install your apps, simply run choc-eula.ps1 from an elevated Powershell prompt.  

  `choc-eula.ps1`

This will automatically accept EULAs and proceed with upgrades of all apps in your configuration without additional confirmation.

This is also suitable for installing as a Scheduled Task in Windows, doing so will make sure that all your packages are always up to date. 

For full instructions including examples, please refer to the `get-help` documentation available from the console.  

`get-help .\choc-eula.ps1`


