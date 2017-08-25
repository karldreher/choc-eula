$apps = gc .\choc-eula.json | ConvertFrom-Json

foreach ($i in $apps.apps){
    choco upgrade $i -y

    
}