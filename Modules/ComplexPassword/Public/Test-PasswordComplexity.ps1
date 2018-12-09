Function Test-PasswordComplexity {
	<#
		.SYNOPSIS
			Test password complexity.

		.DESCRIPTION
			Test password complexity with optional support from Active Directory.  The characteristic of the complexity requirements are controlled using the 'Min*' parameters.  
			
			Supports ASCII/ANSI and Unicode characters. The space character is included when testing the password's length, but does not counted as any of the five character categories.  

			For Windows's default domain password policy with complexity enabled use the following parameters: -MinLength 8 -MinCategory 3

		.PARAMETER Password String
			Required password string to be test.  
			
		.PARAMETER UserName String
			The UserName value, if present and over 3 characters in length, is tested to not be contained within the password value (case insensitive).
		
		.PARAMETER DisplayName String
			The DisplayName value, if present, is parsed and tested so that no components over 3 characters in length are contained within the password value (case insensitive). DisplayName is parsed by the following characters:
				tabs '`t'
				space ' '
				number or pound sign '#'
				comma ','
				minus sign, dash or hyphen '-'
				period '.'
				underscore '_'
				
		.PARAMETER MinLength Int
			The minimum password character length required to be compliant.  The default is zero.

		.PARAMETER MaxLength Int
			The maximum password character length allowed to be compliant.  The default of zero indicates not to check for maximum length.

		.PARAMETER MinUppercase Int
			The minimum number of upppercase letters (an uppercase letter that has a lowercase variant) required to be compliant.  The default is zero.

		.PARAMETER MinLowercase Int
			The minimum number of lowercase letters (a lowercase letter that has an uppercase variant) required to be compliant.  The default is zero.

		.PARAMETER MinNumber Int
			The minimum number of number characters required to be compliant.  The default is zero.

		.PARAMETER MinSpecial Int
			The minimum number of special characters required to be compliant.  The default is zero.

		.PARAMETER MinOther Int
			The minimum number of Unicode other letter (a letter or ideograph that does not have lowercase and uppercase variants) required to be compliant.  The default is zero.  

		.PARAMETER MinCategory Int
			The minimum number of character categories (upper/lower/number/special) required to be compliant.  The maxiumum value is 5.  The default is zero.
					
		.PARAMETER ExcludeCharacter String
			One or more characters to be excluded from being generated.  The default is $NULL, no excluded characters.
				% percent-sign - Enviroment variable substitution
				& ampersand - Inline command separator
				+ plus-sign - Excel macro prefix
				, comma - Comma Separated Value file delimiter
				< less-than - Redirect input
				= equals-sign - Excel macro prefix
				> greater-than - Redirect output
				^ caret - Escape character
				| vertical-bar - Pipe output to next command's input
				0Oo zero OSCAR oscar - ambiguous
				1Il one INDIA lima - ambiguous
				-_ hyphen horizontal-bar - ambiguous
				'` apostrophe reverse-apostrophe - ambiguous
			-ExcludeCharacter "IOlo01'`%&+,<=>^|-_"
			
		.PARAMETER UseActiveDirectory Switch
			Default is not to use Active Directory.  If enabled:
			* Uses executing workstation's Active Directory domain
			* Gets the default domain password policy
			* Overwrites -MinLength and -MinCategory  -MaxLength if either are weaker
			* If supplied, gets the user properties SamAccountName and DisplayName from Active Directory, using them instead of the parameters UserName and DisplayName values.
			
			No attempt to validate the password against Active Directory objects is made.
			
		.OUTPUTS
			A PSObject with two properties:
				IsCompliant Boolean
					has a TRUE or FALSE value.

				Status String
					is either empty, or has a combined list of all non-compliance.

		.EXAMPLE

		.NOTE
			Author: Terry E Dow
			Creation Date: 2018-11-07
			Last Updated: 2018-12-08

			Reference:
				Password must meet complexity requirements https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/password-must-meet-complexity-requirements
				Selecting Secure Passwords https://msdn.microsoft.com/en-us/library/cc875839.aspx?f=255&MSPPError=-2147217396
				Character Classes in Regular Expressions https://docs.microsoft.com/en-us/dotnet/standard/base-types/character-classes-in-regular-expressions#SupportedUnicodeGeneralCategories
				Unicode Regular Expressions http://www.unicode.org/reports/tr18/
				Unicode Regular Expressions https://www.regular-expressions.info/unicode.html#prop
				Unicode Characters in the 'Letter, Other' Category http://www.fileformat.info/info/unicode/category/Lo/list.htm
	#>
	[CmdletBinding(
		SupportsShouldProcess = $TRUE # Enable support for -WhatIf by invoked destructive cmdlets.
	)]
	#[System.Diagnostics.DebuggerHidden()]
	Param(

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]	
		[String] $Password = '',
		
		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String] $UserName = '',
	
		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String] $DisplayName = '',
	
		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MinLength = 0,
	
		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MaxLength = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MinUppercase = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MinLowercase = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MinNumber = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MinSpecial = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MinOther = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[ValidateRange(0,5)]
		[Int] $MinCategory = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String] $ExcludeCharacter = '',

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Switch] $UseActiveDirectory = $NULL
		
	)

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	Begin {
		#Requires -version 3
		Set-StrictMode -Version Latest

		# Detect cmdlet common parameters.
		$cmdletBoundParameters = $PSCmdlet.MyInvocation.BoundParameters
		$Debug = If ( $cmdletBoundParameters.ContainsKey('Debug') ) { $cmdletBoundParameters['Debug'] } Else { $FALSE }
		# Replace default -Debug preference from 'Inquire' to 'Continue'.
		If ( $DebugPreference -Eq 'Inquire' ) { $DebugPreference = 'Continue' }
		$Verbose = If ( $cmdletBoundParameters.ContainsKey('Verbose') ) { $cmdletBoundParameters['Verbose'] } Else { $FALSE }
		$WhatIf = If ( $cmdletBoundParameters.ContainsKey('WhatIf') ) { $cmdletBoundParameters['WhatIf'] } Else { $FALSE }
		Remove-Variable -Name cmdletBoundParameters -WhatIf:$FALSE

		# Optionally get Active Directory domain's default password policy.
		If ( $UseActiveDirectory ) {
			$verbosePreferenceCurrent = $VerbosePreference
			If ( $VerbosePreference -NE 'SilentlyContinue' ) { $VerbosePreference = 'SilentlyContinue' }
			Import-Module ActiveDirectory -ErrorAction SilentlyContinue
			If ( $VerbosePreference -NE $verbosePreferenceCurrent ) { $VerbosePreference = $verbosePreferenceCurrent }

			Try {
				$domainPasswordPolicy = Get-ADDefaultDomainPasswordPolicy -ErrorAction SilentlyContinue
				Write-Debug "`$domainPasswordPolicy.MinPasswordLength:,$($domainPasswordPolicy.MinPasswordLength)"
				Write-Debug "`$domainPasswordPolicy.ComplexityEnabled:,$($domainPasswordPolicy.ComplexityEnabled)"
			} Catch {
				$domainPasswordPolicy = $NULL
				Write-Debug "`$domainPasswordPolicy:,`$NULL"
			}

			# Overwrite complexity parameters if weaker than domain's.
			If ( $domainPasswordPolicy ) {
				$MinLength = [Math]::Max( $MinLength, $domainPasswordPolicy.MinPasswordLength )
			} 
			Write-Debug "`$MinLength:,$MinLength"
			
			# If not specified, overwrite MaxLength with Active Directory current forest schema's password maximum length.
			If ( -Not $MaxLength ) { 
				# User-Password attribute Range-Upper default is 128.  User-Password https://docs.microsoft.com/en-us/windows/desktop/ADSchema/a-userpassword
				Try {
					$MaxLength = [DirectoryServices.ActiveDirectory.ActiveDirectorySchema]::GetCurrentSchema().FindProperty( 'userPassword' ).RangeUpper
				} Catch {
					$MaxLength = 128
				}
			}
            Write-Debug "`$MaxLength:,$MaxLength"

			If ( $domainPasswordPolicy -AND $domainPasswordPolicy.ComplexityEnabled ) {
				$MinCategory = [Math]::Max( $MinCategory, 3 ) 
			}
			Write-Debug "`$MinCategory:,$MinCategory"
		}
	}
	
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	Process {
		
		# Initialize metrics.
		$isCompliant = $TRUE
		$status = ''
		
		Write-Debug "`n`$Password:,$Password"
		
		If ( $UseActiveDirectory -And $UserName ) {
			# Try to get user properties from Active Directory.
			Try {
				$user = Get-ADUser -Identity $UserName -Property sAMAccountName,displayName -ErrorAction Stop
				$UserName = $user.sAMAccountName
				$DisplayName = $user.displayName
			} Catch {
				$status = (( $status, " UserName '$UserName' not found" ) -Join ';').Trim(';')
			}
		}
		Write-Debug "`$UserName:,$UserName"
		Write-Debug "`$DisplayName:,$DisplayName"
		
		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
		# Test password length.
		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

		If ( $MinLength -And ( $Password.Length -LT $MinLength ) ) {
			$isCompliant = $FALSE
			$status = (( $status, " length '$($Password.Length)' less than min length '$MinLength'" ) -Join ';').Trim(';')
		}

		If ( $MaxLength -And ( $MaxLength -LT $Password.Length ) ) {
			$isCompliant = $FALSE
			$status = (( $status, " length '$($Password.Length)' greater than max length '$MaxLength'" ) -Join ';').Trim(';')
		}

		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
		# Test if password contains UserName.
		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

		# If UserName is longer than 3 characters, is it contained in the password?
		If ( ($UserName) -And 3 -LT $UserName.Length -And $Password -Like "*$UserName*" ) { # Case insensitive
			$isCompliant = $FALSE
			$status = (( $status, " contains UserName '$UserName'" ) -Join ';').Trim(';')
		}

		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
		# Test if password contains DisplayName components.
		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

		# If the parsed DisplayName components are longer than 3 characters, are they contained in the password?
		$DisplayName.Split( "`t #,-._" ) | # commas, periods, dashes or hyphens, underscores, spaces, pound signs, and tabs.
			ForEach-Object {
				Write-Debug "`tDisplayName component:,$PSItem"
				If ( 3 -LT $PSItem.Length -And $Password -Like "*$PSItem*" ) { # Case insensitive
					$isCompliant = $FALSE
					$status = (( $status, " contains DisplayName component '$PSItem'" ) -Join ';').Trim(';')
				}
			}

		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
		# Get password's five character category counts.
		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

		$upperCount = [RegEx]::Matches( $Password, '[A-Z|\p{Lu}]' ).Count # Include Unicode Uppercase_Letter: an uppercase letter that has a lowercase variant.
		Write-Debug "`$upperCount:,$upperCount"
		If ( $MinUppercase -And ( $upperCount -LT $MinUppercase ) ) {
			$isCompliant = $FALSE
			$status = (( $status, " uppercase character count '$upperCount' less than '$MinUppercase'" ) -Join ';').Trim(';')
		}

		$lowerCount = [RegEx]::Matches( $Password, '[a-z|\p{Ll}]' ).Count # Include Unicode Lowercase_Letter: a lowercase letter that has an uppercase variant.
		Write-Debug "`$lowerCount:,$lowerCount"
		If ( $MinLowercase -And ( $lowerCount -LT $MinLowercase ) ) {
			$isCompliant = $FALSE
			$status = (( $status, " lowercase character count '$lowerCount' less than '$MinLowercase'" ) -Join ';').Trim(';')
		}

		$numberCount = [RegEx]::Matches( $Password, '[\d]' ).Count
		Write-Debug "`$numberCount:,$numberCount"
		If ( $MinNumber -And ( $numberCount -LT $MinNumber ) ) {
			$isCompliant = $FALSE
			$status = (( $status, " number character count '$numberCount' less than '$MinNumber'" ) -Join ';').Trim(';')
		}

		$specialCount = [RegEx]::Matches( $Password, '[^A-Z|a-z|\p{L}|\d|\s]' ).Count # Exclude space character
		Write-Debug "`$specialCount:,$specialCount"
		If ( $MinSpecial -And ( $specialCount -LT $MinSpecial ) ) {
			$isCompliant = $FALSE
			$status = (( $status, " special character count '$specialCount' less than '$MinSpecial'" ) -Join ';').Trim(';')
		}

		$otherCount = [RegEx]::Matches( $Password, '[\p{Lo}]' ).Count # Include Unicode Other_Letter: a letter or ideograph that does not have lowercase and uppercase variants.
		Write-Debug "`$otherCount:,$otherCount"
		If ( $MinOther -And ( $otherCount -LT $MinOther ) ) {
			$isCompliant = $FALSE
			$status = (( $status, " other character count '$otherCount' less than '$MinOther'" ) -Join ';').Trim(';')
		}

		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
		# Test character category count (complexity/entropy).
		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

		$categoryCount = [Int] [Bool] $upperCount +
			[Int] [Bool] $lowerCount +
			[Int] [Bool] $numberCount +
			[Int] [Bool] $specialCount +
			[Int] [Bool] $otherCount
		Write-Debug "`$categoryCount:,$categoryCount"
		If ( $MinCategory -And $categoryCount -LT $MinCategory ) {
			$isCompliant = $FALSE
			$status = (( $status, " character category count '$categoryCount' less than '$MinCategory'" ) -Join ';').Trim(';')
		}

		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
		# Test for excluded characters.
		#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

		For ( $excludeCharacterIndex=0; $excludeCharacterIndex -LT $ExcludeCharacter.Length; $excludeCharacterIndex++ ) {
			If ( $password -Match $ExcludeCharacter[$excludeCharacterIndex] ) {
				$isCompliant = $FALSE
				$status = (( $status, " contains excluded character '$($ExcludeCharacter[$excludeCharacterIndex])'" ) -Join ';').Trim(';')
			}
		}

		# Write result.
		Write-Output ( [PSCustomObject] @{ IsCompliant=$isCompliant; Status=$status.Trim(' ') } )
	} 
		
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	End {
	}

}
