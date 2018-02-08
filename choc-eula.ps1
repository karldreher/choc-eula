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
    foreach ($i in $apps.app){

        choco upgrade $i -y
    }
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
    write-host "Adding entry" `"$delete`"
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
