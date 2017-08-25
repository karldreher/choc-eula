Param(
    [Parameter(Mandatory=$False, 
    HelpMessage= "Format: c:\path\to\file.csv."
    )]
    [switch]$configure

)

$apps = gc $PSScriptRoot\choc-eula.json | ConvertFrom-Json


function add_entry($entry) {
    $list = @()
    foreach ($i in $apps.apps){
        
        $object = New-Object -TypeName PSObject
        Add-Member -InputObject $object -MemberType NoteProperty -Name apps -Value $i
        
        $list += $object
        }

    $object = New-Object -TypeName PSObject
    Add-Member -InputObject $object -MemberType NoteProperty -Name apps -Value $entry 
    $list += $object

    $list | ConvertTo-Json | out-file $PSScriptRoot\choc-eula.json

}


function delete_entry($entry) {
    $list = @()
    foreach ($i in $apps.apps){

        $object = New-Object -TypeName PSObject
        Add-Member -InputObject $object -MemberType NoteProperty -Name apps -Value $i
        
        if ($i -ne $entry){$list += $object}
        
        }

    $list | ConvertTo-Json | out-file $PSScriptRoot\choc-eula.json

}


function show_config {
    $apps = gc $PSScriptRoot\choc-eula.json | ConvertFrom-Json
    write-host "The following apps are configured to update or isntall with choc-eula:  "
    write-host "-------------------"
    $apps.apps
    write-host "-------------------"
    write-host ""
}


function configure{
    
    

    while ($exit -ne $True){
        show_config
        $input = read-host "What do you want to do next?  Type ADD, DELETE, or EXIT"
        
        Switch($input){
            "add"{
            $entry = read-host "Enter the name of the package you want to add"
            add_entry($entry)
            }

            "delete"{
            $entry = read-host "Enter the name of the package you want to delete, as it appears above"
            delete_entry($entry)
            }

            "exit"{$exit = $True}


        }
        
    }
}



function update {
    foreach ($i in $apps.apps){

        choco upgrade $i -y
    }
}




if ($configure.ispresent){
    configure
    }

else {
    update
    }