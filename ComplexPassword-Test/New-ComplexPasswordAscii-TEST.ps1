Import-Module ComplexPassword -Force

New-ComplexPasswordAscii -ExecutionSource TEST -OutFileNameTag Default
New-ComplexPasswordAscii -NumPassword 10 -MinLength 8 -MinCategory 3 -Verbose -ExecutionSource TEST -OutFileNameTag Verbose
New-ComplexPasswordAscii -NumPassword 10 -MinLength 8 -MinCategory 3 -Debug -ExecutionSource TEST -OutFileNameTag Debug
New-ComplexPasswordAscii -NumPassword 100 -MinLength 8 -MinCategory 3 -ExecutionSource TEST -OutFileNameTag Num100Len8Cat3
New-ComplexPasswordAscii -NumPassword 100 -MinLength 15 -ExecutionSource TEST -OutFileNameTag Num100Len15
New-ComplexPasswordAscii -NumPassword 100 -MinLength 15 -MinCategory 4 -ExecutionSource TEST -OutFileNameTag Num100Len15Cat4
New-ComplexPasswordAscii -NumPassword 100 -MinLength 15 -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -ExecutionSource TEST -OutFileNameTag Num100Len15U1L1N1S1
New-ComplexPasswordAscii -PasswordPropertyName Credential -NumPassword 10 -MinLength 8 -MinCategory 3 -ExecutionSource TEST -OutFileNameTag PWPN

