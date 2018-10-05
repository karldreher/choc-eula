<#

.SYNOPSIS
choc-eula is a management system for Chocolatey for users who don't need a lot of customization but want to stay current with apps installed on their computers.

.DESCRIPTION
choc-eula consists of two parts; this script, and a config file (in JSON format).  This script also requires Chocolatey - please install that prior to running this tool for the first time.  


There are 3 main functions of choc-eula:  Update, Add, and Delete.

Update will initiate a "choco upgrade" for all apps in a given config file.  These must be valid applications in the Chocolatey catalog.  
This is done by supplying no parameters (to use a config file in the same directory as the script), or you can optionally supply the "-showconfig" parameter to specify an alternate config file.  
Updating requires elevation while other parameters do not.  

You can maintain any number of config files - this is a great way to provision specific apps on a new machine.  


Add and Delete are initiated by the "-add" and "-delete" parameters.  Again, these will use a file called "choc-eula.json" in the same directory as the script, unless the "-configfile" parameter is provided.
These are the two main ways you can manage your configuration files.
Although Add and Delete do not require elevation, you need to have access to write to the config file when using these functions.

You can also show the current configuration of any config file by using the "-showconfig" parameter.  After observing the current list of apps, you can then add or delete files by running the script again with the appropriate parameters.  



.EXAMPLE
.\choc-eula.ps1 

Run without parameters, this will update all apps specified in the ".\choc-eula.json" file in the same directory as the script.  

Note: this requires elevation.

.EXAMPLE
.\choc-eula.ps1 -showconfig -configfile c:\path\to\config.json

This command demonstrates showing the config of a specified configfile.  

.EXAMPLE
.\choc-eula.ps1 -configfile c:\path\to\config.json -add chocolatey

This command adds "chocolatey" to the list of apps to update in the config file "c:\path\to\config.json".

.EXAMPLE
.\choc-eula.ps1 -configfile c:\path\to\config.json -delete 7zip

This command would delete 7zip from the list of apps to update in the config file "c:\path\to\config.json".

.EXAMPLE
.\choc-eula.ps1 -configfile c:\path\to\config.json

This demonstrates updating all apps in the config file "c:\path\to\config.json".  

Note: this requires elevation.

.NOTES
choc-eula is not affilliated with Chocolatey.  

.LINK
https://github.com/karldreher/choc-eula

https://chocolatey.org

#>
Param(
    [Parameter(Mandatory=$False,
    HelpMessage= "path to alternate config file, otherwise default is choc-eula.json in script directory.  Syntax: c:\path\to\file.json"
    )]
    $configfile="$PSScriptRoot\choc-eula.json",

    [Parameter(Mandatory=$False, 
    HelpMessage= "Displays current configuration."
    )]
    [switch]$showconfig,

    [Parameter(Mandatory=$False, 
    HelpMessage= "Delete a value.  Syntax: -delete <package>"
    )]
    $delete,

    [Parameter(Mandatory=$False, 
    HelpMessage= "Add a value.  Syntax: -add <package>"
    )]
    $add

)


$apps = get-content $configfile | ConvertFrom-Json

function add_entry($entry) {
    $list = @()
    foreach ($i in $apps.app){
        
        $object = New-Object -TypeName PSObject
        Add-Member -InputObject $object -MemberType NoteProperty -Name app -Value $i
        
        $list += $object
        }

    $object = New-Object -TypeName PSObject
    Add-Member -InputObject $object -MemberType NoteProperty -Name app -Value $entry 
    $list += $object

    $list | ConvertTo-Json | out-file $configfile

}


function delete_entry($entry) {
    $list = @()
    foreach ($i in $apps.app){

        $object = New-Object -TypeName PSObject
        Add-Member -InputObject $object -MemberType NoteProperty -Name app -Value $i
        
        if ($i -ne $entry){$list += $object}
        
        }

    $list | ConvertTo-Json | out-file $configfile
    
}


function show_config {
    $apps = gc $configfile | ConvertFrom-Json
    write-host "The following apps are configured to update or install with choc-eula:  "
    write-host "-------------------"
    $apps.app
    write-host "-------------------"
    write-host ""
}




function update {
        choco upgrade (($apps.app) -join ";") -y
}



#showconfig takes precedence here, intentionally.  Not possible to add, delete, or show config at the same time.  
#similarly update will only occur if all parameters are omitted.  All options are mutually exclusive.

if($PSBoundParameters.ContainsKey("showconfig")){
    show_config
}

elseif($PSBoundParameters.ContainsKey("delete")){
    write-host "Deleting entry" `"$delete`"
    delete_entry($delete)
    show_config
}

elseif($PSBoundParameters.ContainsKey("add")){
    write-host "Adding entry" `"$add`"
    add_entry($add)
    show_config
}

if ($PSBoundParameters.Count -eq 0){
    update
}

#this is starting to get a little much, but ok for now.  
if ($PSBoundParameters.Count -eq 1 -and $PSBoundParameters.ContainsKey("configfile")){
    update
}
