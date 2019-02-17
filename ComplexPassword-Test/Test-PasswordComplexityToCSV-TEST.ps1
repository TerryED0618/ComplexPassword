Import-Module ComplexPassword -Force

Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-Test.csv -ExecutionSource TEST -OutFileNameTag Default
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-Test.csv -MinLength 8 -MinCategory 3 -ExecutionSource TEST -OutFileNameTag L8C3
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-Test.csv -MinLength 15  -ExecutionSource TEST -OutFileNameTag L15
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-Test.csv -MinCategory 5 -ExecutionSource TEST -OutFileNameTag C5
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-Test.csv -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1  -ExecutionSource TEST -OutFileNameTag U1l1S1O1
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-Test.csv -ExcludeCharacter '~,'  -ExecutionSource TEST -OutFileNameTag 'X~,'
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-TEST-DisplayName.csv -DisplayNamePropertyName FriendlyName -MinLength 8 -MinCategory 3 -ExecutionSource TEST -OutFileNameTag DNPN
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-TEST-Password.csv -PasswordPropertyName Credential -MinLength 8 -MinCategory 3 -ExecutionSource TEST -OutFileNameTag PWPN
Test-PasswordComplexityToCSV -Path .\Test-PasswordComplexityToCSV-TEST-UserName.csv -UserNamePropertyName AccountName -MinLength 8 -MinCategory 3 -ExecutionSource TEST -OutFileNameTag UNPN