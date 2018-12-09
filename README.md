#   Sanatize files via PowerShell

##  Remove ".TXT" file name extension from files with a nested extensions.  For example rename BATCH.CMD.TXT to BATCH.CMD or SCRIPT.PS1.TXT to SCRIPT.PS1.

##  Remove *.TXT extension for any file name with a nested extension ending with '.TXT'
### Get-ChildItem -Path *.*.TXT -File -Recurse | ForEach-Object { Rename-Item -Path $PSItem.VersionInfo.FileName -NewName ( $PSItem.VersionInfo.FileName -Replace '\.TXT$', '' ) -PassThru }

##  Add *.TXT extention for all script files (*.PS1, *.CMD, *.BAT)
### Get-ChildItem *.PS*1,*.CMD,*.BAT -Exclude *.TXT -File -Recurse | ForEach-Object { Rename-Item -Path $PSItem.VersionInfo.FileName -NewName "$($PSItem.VersionInfo.FileName).TXT" -PassThru }

## Unblock all files marked remote.  
### Get-ChildItem -File -Recurse | ForEach-Object { Try { (Get-Item $PSItem.VersionInfo.FileName -Stream 'Zone.Identifier' -ErrorAction Stop).FileName; Unblock-File $PSItem.VersionInfo.FileName } Catch { } }


