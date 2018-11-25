Import-Module ComplexPassword -Force

 Describe 'Test-PasswordComplexity-Length' {

    $result = Test-PasswordComplexity -MinLength 0 -Password ''
    It ',Length 0 should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinLength 1 -Password '1'
    It 'a,Length 1 should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinLength 7 -Password '12345678'
    It '12345678,Length greater than min should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }
	
	$result = Test-PasswordComplexity -MinLength 8 -Password '12345678'
    It '12345678,Length equal to min should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinLength 9 -Password '12345678'
    It '12345678,Length less than min should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
}

Describe 'Test-PasswordComplexity-Categories' {

    $result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'ABCDEF' 
    It 'ABCDEF,Uppercase with require 1 of all categories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	$result = Test-PasswordComplexity -MinUppercase 1 -Password 'ABCDEF' 
    It 'ABCDEF,Uppercase with require 1 uppercase should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'abcdef' 
    It 'abcdef,Lowercase with require 1 of all categories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	$result = Test-PasswordComplexity -MinLowercase 1 -Password 'abcdef' 
    It 'abcdef,Lowercase with require 1 lowercase should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password '123456' 
    It '123456,Number character with require 1 of all categories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	$result = Test-PasswordComplexity -MinNumber 1 -Password '123456' 
    It '123456,Number character with require 1 number character should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }
	
	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password '!@#$%^' 
    It '!@#$%^,Special character with require 1 of all categories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	$result = Test-PasswordComplexity -MinSpecial 1 -Password '!@#$%^' 
    It '!@#$%^,Special character with require 1 special character should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'ͰЀԱႠⰀⲀ' 
    It 'ͰЀԱႠⰀⲀ,Unicode: Letter uppercase with require 1 of all categories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	$result = Test-PasswordComplexity -MinUppercase 1 -Password 'ͰЀԱႠⰀⲀ' 
    It 'ͰЀԱႠⰀⲀ,Unicode: Letter uppercase with require 1 uppercase should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'ͱϣаաᏸⰰⴀﬓ' 
    It 'ͱϣаաᏸⰰⴀﬓ,Unicode: Letter lowercase with require 1 of all categories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	$result = Test-PasswordComplexity -MinLowercase 1 -Password 'ͱϣаաᏸⰰⴀﬓ' 
    It 'ͱϣаաᏸⰰⴀﬓ,Unicode: Letter lowercase with require 1 lowercase letter should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'ܐאؠݐހ' 
    It 'ܐאؠݐހ,Unicode: Letter other with require 1 of all categories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	$result = Test-PasswordComplexity -MinOther 1 -Password 'ܐאؠݐހ' 
    It 'ܐאؠݐހ,Unicode: Letter other with require 1 letter other should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'ABCdef123!@#ܐאؠ' 
    It 'ABCdef123!@#ܐאؠ,All categories with require 1 of all categories should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'def123!@#ܐאؠ' 
    It 'def123!@#ܐאؠ,No uppercase with require 1 of all but uppercase letter should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }
	$result = Test-PasswordComplexity -MinUppercase 1 -Password 'def123!@#ܐאؠ' 
    It 'def123!@#ܐאؠ,No uppercase with require 1 uppercase letter should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
	$result = Test-PasswordComplexity -MinUppercase 1 -MinNumber 1 -MinSpecial 1 -MinOther 1 -Password 'ABC123!@#ܐאؠ' 
    It 'ABC123!@#ܐאؠ,No lowercase with require 1 of all but lowercase letter should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }
	$result = Test-PasswordComplexity -MinLowercase 1 -Password 'ABC123!@#ܐאؠ' 
    It 'ABC123!@#ܐאؠ,No uppercase with require 1 lowercase letter should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinSpecial 1 -MinOther 1 -Password 'ABCdef!@#ܐאؠ' 
    It 'ABC123!@#ܐאؠ,No number with require 1 of all but number character should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }
	$result = Test-PasswordComplexity -MinNumber 1 -Password 'ABCdef!@#ܐאؠ' 
    It 'ABC123!@#ܐאؠ,No number with require 1 number character should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinOther 1 -Password 'ABCdef123ܐאؠ' 
    It 'ABCdef123ܐאؠ,No special character with require 1 of all but special character should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }
	$result = Test-PasswordComplexity -MinSpecial 1 -Password 'ABCdef123ܐאؠ' 
    It 'ABCdef123ܐאؠ,No special character other with require 1 special character should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -Password 'ABCdef123!@#' 
    It 'ABCdef123!@#,No letter other with require 1 of all but letter other should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }
	$result = Test-PasswordComplexity -MinOther 1 -Password 'ABCdef123!@#' 
    It 'ABCdef123!@#,No letter other other with require 1 letter other should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

}


Describe 'Test-PasswordComplexity-Space' {

    $result = Test-PasswordComplexity -MinLength 2 -Password '   '
    It '"   " all spaces with require length less than min should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -MinUppercase 1 -MinLowercase 1 -MinOther 1 -Password '   '
    It '"   " all spaces with require all letter catagories should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
	$result = Test-PasswordComplexity -MinNumber 1 -Password '   '
    It '"   " all spaces with require number character should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -MinSpecial 1 -Password '   '
    It '"   " all spaces with require special character should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
}

Describe 'Test-PasswordComplexity-ExcludeCharacter' {

    $result = Test-PasswordComplexity -Password 'ABCdef123~!,' -ExcludeCharacter '~,'
    It 'ABCdef123~!,Special character with "~" and "," should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
}

Describe 'Test-PasswordComplexity-UserName' {

	# 
	$result = Test-PasswordComplexity -UserName 'Usr' -Password 'aUsra' 
    It 'Usr,aUsra,User name too short should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	# 
	$result = Test-PasswordComplexity -UserName 'User' -Password 'aUsera' 
    It 'User,aUsera,User name same case should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	# 
	$result = Test-PasswordComplexity -UserName 'user' -Password 'aUsera' 
    It 'user,aUsera,User name uppercase should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	# 
	$result = Test-PasswordComplexity -UserName 'User' -Password 'ausera' 
    It 'User,ausera,User name lowercase should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
}

Describe 'Test-PasswordComplexity-DisplayName' {

    $result = Test-PasswordComplexity -DisplayName 'abc' -Password 'ABCdef123!@#' 
    It 'abc,ABCdef123!@#,Display name too short should return $TRUE' {
        $result.IsCompliant | Should Be $TRUE
    }

	$result = Test-PasswordComplexity -DisplayName 'Name' -Password 'aNamea' 
    It 'Name,aNamea,Display name same case should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -DisplayName 'name' -Password 'aNamea' 
    It 'name,aNamea,Display name uppercase should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -DisplayName 'Name' -Password 'anamea' 
    It 'Name,anamea,Display name lowercase should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -DisplayName 'First Last' -Password 'aFirsta' 
    It 'First Last,aFirsta,Display name split space should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -DisplayName 'First#Last' -Password 'aFirsta' 
    It 'First#Last,aFirsta,Display name split number sign should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -DisplayName 'First,Last' -Password 'aFirsta' 
    It '"First,Last",aFirsta,Dispay name split comma should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }

	$result = Test-PasswordComplexity -DisplayName 'First-Last' -Password 'aFirsta' 
    It 'First-Last,aFirsta,Display name split minus should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
	$result = Test-PasswordComplexity -DisplayName 'First.Last' -Password 'aFirsta' 
    It 'First.Last,aFirsta,Display name split period should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
	$result = Test-PasswordComplexity -DisplayName 'First_Last' -Password 'aFirsta' 
    It 'First_Last,aFirsta,Display name split underscore should return $FALSE' {
        $result.IsCompliant | Should Be $FALSE
    }
	
}

#Describe 'Test-PasswordComplexity-UseActiveDirectory' {
#}