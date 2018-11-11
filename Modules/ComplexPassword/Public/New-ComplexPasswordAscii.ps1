Function New-ComplexPasswordAscii {
	<#
		.SYNOPSIS
			Generate new complex password.

		.DESCRIPTION
			Generate new complex US ASCII (printable lower ASCII 32..126 decimal) password.  There are 5 character categories: uppercase, lowercase, numbers, special characters, and Unicode Letter_Other.  This solution only supports the first 4, and does not support Unicode.  The valid values for the paramter -MaxCategory is 0 to 4.
			The complexity of the password generated are based on the parameters
				-NumLength 1
				-MinUpper 0
				-MinLower 0
				-MinNumber 0
				-MinSpecial 0
				and
				-MinCategory 0
				
			Use the -Min<CharCategory> parameters (-MinUpper, -MinLower, -MinNumber, -MinSpecial) to define the minimum required password complexity.
			Alternatively, you can use the -MinCategory and this solution will pick random character categories.
			After the Min<Category>/MinCategory specifications have been met, randaom characters from any of the 4 character categories are used for the remainder of the password length.
			If the both are used together, and if -MinCategory is larger than the values of -Min<CharCategory> combined, then this solution will pick the balance randomly from the remaining unspecified -Min<CharCategory> parameters.
			If -MinLength is less than -MaxCategory or the values of -Min<CharCategory> combined, -MaxLength is extended.
			
			Use -Verbose and the password will be written to the console (Write-Verbose).
			
			-NumLength increases the password complexity more than increases in -MaxCategory.  A value of 15 or larger is recommended.
			
			For Windows's default domain password policy with complexity enabled use the following parameters: -MinLength 8 -MinCategory 3.  Your domain's -MinLength may be larger.

		.OUTPUTS
			One output file is generated by default in a subfolder called '.\Reports\'.  The output file name is in the format of: <date/time/timezone stamp>-<msExchOrganizationContainer>-<ScriptName>.CSV.
			If parameter -Debug or -Verbose is specified, then a second file, a PowerShell transcript (*.TXT), is created with the same name and in the same location.

			Two columns are created 'NewPassword' and 'NewPasswordDescription'.  NewPassword column contains the randomly generate US-ASCII passwords, NewPasswordDescription column contains the password description.  For example:
			> .\New-ComplexPasswordAscii.ps1 -MinLength 4 -MinCategory 4
			
			file: .\Reports\<date/time/timezone stamp>-<msExchOrganizationContainer>-<ScriptName>.CSV
			"NewPassword","NewPasswordDescription"
			"=3vD","equals-sign_three_victor_DELTA"

		.PARAMETER NumPassword Int
			The number of random complex passwords to generate.  The default is one.

		.PARAMETER MinLength Int
			The minimum password character length required to be compliant.  The default is one.

		.PARAMETER MinUppercase Int
			The minimum number of upppercase letters required to be compliant.  The default is zero.

		.PARAMETER MinLowercase Int
			The minimum number of lowercase letters required to be compliant.  The default is zero.

		.PARAMETER MinNumber Int
			The minimum number of number characters required to be compliant.  The default is zero.

		.PARAMETER MinSpecial Int
			The minimum number of special characters required to be compliant.  The default is zero.

		.PARAMETER MinCategory Int
			The minimum number of character categories (upper/lower/number/special) required to be compliant.  The maxiumum value is 4.  The default is zero.
			
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
				
		.PARAMETER Delimiter Char
			Specifies the delimiter that separates the property values in the CSV file. The default is a comma (,). Enter a character, such as a colon (:). To specify a semicolon (;), enclose it in quotation marks.

			If you specify a character other than the actual string delimiter in the file, Import-Csv cannot create objects from the CSV strings. Instead, it returns the strings.

		.PARAMETER Encoding String
			Specifies the type of character encoding that was used in the CSV file. Valid values are Unicode, UTF7, UTF8, ASCII, UTF32, BigEndianUnicode, Default, and OEM. The default is ASCII.

			This parameter is introduced in Windows PowerShell 3.0.

		.PARAMETER Header String[]
			Specifies an alternate column header row for the imported file. The column header determines the names of the properties of the object that Import-Csv creates.

			Enter a comma-separated list of the column headers. Enclose each item in quotation marks (single or double). Do not enclose the header string in quotation marks. If you enter fewer column headers than there are columns, the remaining columns will have no header. If you enter more headers than there are columns, the extra headers are ignored.

			When using the Header parameter, delete the original header row from the CSV file. Otherwise, Import-Csv creates an extra object from the items in the header row.

		.PARAMETER Path String[]
			Specifies the path to the CSV file to import. You can also pipe a path to Import-Csv.

		.PARAMETER UseCulture SwitchParameter
			Use the list separator for the current culture as the item delimiter. The default is a comma (,).

			To find the list separator for a culture, use the following command: (Get-Culture).TextInfo.ListSeparator. If you specify a character other than the delimiter used in the CSV strings, ConvertFrom-CSV cannot create objects from the CSV strings. Instead, it returns the strings.

		.PARAMETER LiteralPath String[]
			Specifies the path to the CSV file to import. Unlike Path, the value of the LiteralPath parameter is used exactly as it is typed. No characters are interpreted as wildcards. If the path includes escape characters, enclose it in single quotation marks. Single quotation marks tell Windows PowerShell not to interpret any characters as escape sequences.
			
		.EXAMPLE
			New-ComplexPasswordAscii -OutFileNameTag Default
			
		.EXAMPLE
			New-ComplexPasswordAscii -NumPassword 10 -MinLength 8 -OutFileNameTag Num10Verbose -Verbose
			
		.EXAMPLE
			New-ComplexPasswordAscii -NumPassword 100 -MinLength 8 -MinCategory 3 -OutFileNameTag Num100Len6Cat3
			
		.EXAMPLE
			New-ComplexPasswordAscii -NumPassword 100 -MinLength 15 -OutFileNameTag Num100Len15
			
		.EXAMPLE
			New-ComplexPasswordAscii -NumPassword 100 -MinLength 15 -MinCategory 4 -OutFileNameTag Num100Len15Cat4
			
		.EXAMPLE
			New-ComplexPasswordAscii -NumPassword 100 -MinLength 15 -MinUppercase 1 -MinLowercase 1 -MinNumber 1 -MinSpecial 1 -OutFileNameTag Num100Len15u1L1N1S1

		.NOTE
			Author: Terry E Dow
			Creation Date: 2018-08-01
			Last Modified: 2018-09-19

			Reference:
				Password must meet complexity requirements https://docs.microsoft.com/en-us/windows/security/threat-protection/security-policy-settings/password-must-meet-complexity-requirements
				Selecting Secure Passwords https://msdn.microsoft.com/en-us/library/cc875839.aspx?f=255&MSPPError=-2147217396

	#>
	[CmdletBinding(
		SupportsShouldProcess = $TRUE # Enable support for -WhatIf by invoked destructive cmdlets.
	)]
	#[System.Diagnostics.DebuggerHidden()]
	Param(

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $NumPassword = 1,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Int] $MinLength = 1,

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
		[ValidateRange(0,4)]
		[Int] $MinCategory = 0,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String] $ExcludeCharacter = '',


		[Parameter(
		ValueFromPipeline=$TRUE,
		Position=2)]
		[Char] $Delimiter = $NULL,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String] $Encoding = $NULL,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String[]] $Header = $NULL,

		[Parameter(
		ValueFromPipeline=$TRUE,
		Position=1)]
		[String[]] $Path = '.\Test-PasswordComplexityFromCSV.csv',

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[Switch] $UseCulture = $NULL,

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String[]] $LiteralPath = $NULL,

	#region Script Header

		[Parameter( HelpMessage='Specify the script''s execution environment source.  Must be either ''ComputerName'', ''DomainName'', ''msExchOrganizationName'' or an arbitrary string. Defaults is msExchOrganizationName.' ) ]
			[String] $ExecutionSource = $NULL,

		[Parameter( HelpMessage='Optional string added to the end of the output file name.' ) ]
			[String] $OutFileNameTag = $NULL,

		[Parameter( HelpMessage='Specify where to write the output file.' ) ]
			[String] $OutFolderPath = '.\Reports',

		[Parameter( HelpMessage='When enabled, only unhealthy items are reported.' ) ]
			[Switch] $AlertOnly = $FALSE,

		[Parameter( HelpMessage='Optionally specify the address from which the mail is sent.' ) ]
			[String] $MailFrom = $NULL,

		[Parameter( HelpMessage='Optioanlly specify the addresses to which the mail is sent.' ) ]
			[String[]] $MailTo = $NULL,

		[Parameter( HelpMessage='Optionally specify the name of the SMTP server that sends the mail message.' ) ]
			[String] $MailServer = $NULL,

		[Parameter( HelpMessage='If the mail message attachment is over this size compress (zip) it.' ) ]
			[Int] $CompressAttachmentLargerThan = 5MB
	)

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

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Collect script execution metrics.
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	$scriptStartTime = Get-Date
	Write-Verbose "`$scriptStartTime:,$($scriptStartTime.ToString('s'))"

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Include external functions.
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	#. .\New-OutFilePathBase.ps1

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Define internal functions.
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8


	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Build output and log file path name.
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	$outFilePathBase = New-OutFilePathBase -OutFolderPath $OutFolderPath -ExecutionSource $ExecutionSource -OutFileNameTag $OutFileNameTag

	$outFilePathName = "$($outFilePathBase.Value).csv"
	Write-Debug "`$outFilePathName: $outFilePathName"
	$logFilePathName = "$($outFilePathBase.Value).log"
	Write-Debug "`$logFilePathName: $logFilePathName"

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Optionally start or restart PowerShell transcript.
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	If ( $Debug -Or $Verbose ) {
		Try {
			Start-Transcript -Path $logFilePathName -WhatIf:$FALSE
		} Catch {
			Stop-Transcript
			Start-Transcript -Path $logFilePathName -WhatIf:$FALSE
		}
	}

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Define constants
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	# Build description of US-ASCII characters by mixing ISO-8859-1 entity names and ICAO (NATO) phonetic names.
	$USAsciiDescription = New-Object -TypeName System.Collections.Hashtable # Support case sensitive keys.
	$USAsciiDescription.Add( ' ', 'space' ) # 32 # ISO-8859-1 (ISO Latin 1) Character Encoding
	$USAsciiDescription.Add( '!', 'exclamation-mark' ) # 33
	$USAsciiDescription.Add( '"', 'quotation-mark' ) # 34
	$USAsciiDescription.Add( '#', 'number-sign' ) # 35
	$USAsciiDescription.Add( '$', 'dollar-sign' ) # 36
	$USAsciiDescription.Add( '%', 'percent-sign' ) # 37
	$USAsciiDescription.Add( '&', 'ampersand' ) # 38
	$USAsciiDescription.Add( "'", 'apostrophe' ) # 39
	$USAsciiDescription.Add( '(', 'left-parenthesis' ) # 40
	$USAsciiDescription.Add( ')', 'right-parenthesis' ) # 41
	$USAsciiDescription.Add( '*', 'asterisk' ) # 42
	$USAsciiDescription.Add( '+', 'plus-sign' ) # 43
	$USAsciiDescription.Add( ',', 'comma' ) # 44
	$USAsciiDescription.Add( '-', 'hyphen' ) # 45
	$USAsciiDescription.Add( '.', 'period' ) # 46
	$USAsciiDescription.Add( '/', 'solidus' ) # 47
	$USAsciiDescription.Add( '0', 'zero' ) # 48 # NATO (ICAO) Phonetic Alphabet
	$USAsciiDescription.Add( '1', 'one' ) # 49
	$USAsciiDescription.Add( '2', 'two' ) # 50
	$USAsciiDescription.Add( '3', 'three' ) # 51
	$USAsciiDescription.Add( '4', 'four' ) # 52
	$USAsciiDescription.Add( '5', 'five' ) # 53
	$USAsciiDescription.Add( '6', 'six' ) # 54
	$USAsciiDescription.Add( '7', 'seven' ) # 55
	$USAsciiDescription.Add( '8', 'eight' ) # 56
	$USAsciiDescription.Add( '9', 'nine' ) # 57
	$USAsciiDescription.Add( ':', 'colon' ) # 58 # ISO-8859-1 (ISO Latin 1) Character Encoding
	$USAsciiDescription.Add( ';', 'semi-colon' ) # 59
	$USAsciiDescription.Add( '<', 'less-than' ) # 60
	$USAsciiDescription.Add( '=', 'equals-sign' ) # 61
	$USAsciiDescription.Add( '>', 'greater-than' ) # 62
	$USAsciiDescription.Add( '?', 'question-mark' ) # 63
	$USAsciiDescription.Add( '@', 'commercial-at-sign' ) # 64
	$USAsciiDescription.Add( 'A', 'ALPHA' ) # 65 # NATO (ICAO) Phonetic Alphabet
	$USAsciiDescription.Add( 'B', 'BRAVO' ) # 66
	$USAsciiDescription.Add( 'C', 'CHARLIE' ) # 67
	$USAsciiDescription.Add( 'D', 'DELTA' ) # 68
	$USAsciiDescription.Add( 'E', 'ECHO' ) # 89
	$USAsciiDescription.Add( 'F', 'FOXTROT' ) # 70
	$USAsciiDescription.Add( 'G', 'GOLF' ) # 71
	$USAsciiDescription.Add( 'H', 'HOTEL' ) # 72
	$USAsciiDescription.Add( 'I', 'INDIA' ) # 73
	$USAsciiDescription.Add( 'J', 'JULIET' ) # 74
	$USAsciiDescription.Add( 'K', 'KILO' ) # 75
	$USAsciiDescription.Add( 'L', 'LIMA' ) # 76
	$USAsciiDescription.Add( 'M', 'MIKE' ) # 77
	$USAsciiDescription.Add( 'N', 'NOVEMBER' ) # 78
	$USAsciiDescription.Add( 'O', 'OSCAR' ) # 79
	$USAsciiDescription.Add( 'P', 'PAPA' ) # 80
	$USAsciiDescription.Add( 'Q', 'QUEBEC' ) # 81
	$USAsciiDescription.Add( 'R', 'ROMEO' ) # 82
	$USAsciiDescription.Add( 'S', 'SIERRA' ) # 83
	$USAsciiDescription.Add( 'T', 'TANGO' ) # 84
	$USAsciiDescription.Add( 'U', 'UNIFORM' ) # 85
	$USAsciiDescription.Add( 'V', 'VICTOR' ) # 86
	$USAsciiDescription.Add( 'W', 'WHISKEY' ) # 87
	$USAsciiDescription.Add( 'X', 'X-RAY' ) # 88
	$USAsciiDescription.Add( 'Y', 'YANKEE' ) # 89
	$USAsciiDescription.Add( 'Z', 'ZULU' ) # 90
	$USAsciiDescription.Add( '[', 'left-square-bracket' ) # 91 # ISO-8859-1 (ISO Latin 1) Character Encoding
	$USAsciiDescription.Add( '\', 'reverse-solidus' ) # 92
	$USAsciiDescription.Add( ']', 'right-square-bracket' ) # 93
	$USAsciiDescription.Add( '^', 'caret' ) # 94
	$USAsciiDescription.Add( '_', 'horizontal-bar' ) # 95
	$USAsciiDescription.Add( '`', 'reverse-apostrophe' ) # 96
	$USAsciiDescription.Add( 'a', 'alpha' ) # 97 # NATO (ICAO) Phonetic Alphabet
	$USAsciiDescription.Add( 'b', 'bravo' ) # 98
	$USAsciiDescription.Add( 'c', 'charlie' ) # 99
	$USAsciiDescription.Add( 'd', 'delta' ) # 100
	$USAsciiDescription.Add( 'e', 'echo' ) # 101
	$USAsciiDescription.Add( 'f', 'foxtrot' ) # 102
	$USAsciiDescription.Add( 'g', 'golf' ) # 103
	$USAsciiDescription.Add( 'h', 'hotel' ) # 104
	$USAsciiDescription.Add( 'i', 'india' ) # 105
	$USAsciiDescription.Add( 'j', 'juliet' ) # 106
	$USAsciiDescription.Add( 'k', 'kilo' ) # 107
	$USAsciiDescription.Add( 'l', 'lima' ) # 108
	$USAsciiDescription.Add( 'm', 'mike' ) # 109
	$USAsciiDescription.Add( 'n', 'november' ) # 110
	$USAsciiDescription.Add( 'o', 'oscar' ) # 111
	$USAsciiDescription.Add( 'p', 'papa' ) # 112
	$USAsciiDescription.Add( 'q', 'quebec' ) # 113
	$USAsciiDescription.Add( 'r', 'romeo' ) # 114
	$USAsciiDescription.Add( 's', 'sierra' ) # 115
	$USAsciiDescription.Add( 't', 'tango' ) # 116
	$USAsciiDescription.Add( 'u', 'uniform' ) # 117
	$USAsciiDescription.Add( 'v', 'victor' ) # 118
	$USAsciiDescription.Add( 'w', 'whiskey' ) # 119
	$USAsciiDescription.Add( 'x', 'x-ray' ) # 120
	$USAsciiDescription.Add( 'y', 'yankee' ) # 121
	$USAsciiDescription.Add( 'z', 'zulu' ) # 122
	$USAsciiDescription.Add( '{', 'left-curly-brace' ) # 123 # ISO-8859-1 (ISO Latin 1) Character Encoding
	$USAsciiDescription.Add( '|', 'vertical-bar' ) # 124
	$USAsciiDescription.Add( '}', 'right-curly-brace' ) # 125
	$USAsciiDescription.Add( '~', 'tilde' ) # 126

	#endregion Script Header

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Collect report information
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	# Validate parameters
	$MinLength = [MATH]::Max( $MinLength, $MinCategory )
	$MinLength = [MATH]::Max( $MinLength, $MinUppercase + $MinLowercase + $MinNumber + $MinSpecial )

	# Create a hash table to splat Import-CSV parameters.
	#$importCsvParameters = @{}
	#If ( $Delimiter ) { $importCsvParameters.Delimiter = $Delimiter }
	#If ( $Encoding ) { $importCsvParameters.Encoding = $Encoding }
	#If ( $Header ) { $importCsvParameters.Header = $Header }
	#If ( $Path ) { $importCsvParameters.Path = $Path }
	#If ( $UseCulture ) { $importCsvParameters.UseCulture = $UseCulture }
	#If ( $LiteralPath ) { $importCsvParameters.LiteralPath = $LiteralPath }
	#If ( $Debug ) {
	#	ForEach ( $key In $importCsvParameters.Keys ) {
	#		Write-Debug "`$importCsvParameters[$key]`:,$($importCsvParameters[$key])"
	#	}
	#}

	# Create a hash table to splat Export-CSV parameters.
	$exportCsvParameters = @{}
	$exportCsvParameters.Path = $outFilePathName
	$exportCsvParameters.NoTypeInformation = $TRUE
	$exportCsvParameters.WhatIf = $FALSE
	If ( $Debug ) {
		ForEach ( $key In $exportCsvParameters.Keys ) {
			Write-Debug "`$exportCsvParameters[$key]`:,$($exportCsvParameters[$key])"
		}
	}

	# Build character categories.
	$CharCategories = @{
		'Upper' = [Char]'A'..[Char]'Z';
		'Lower' = [Char]'a'..[Char]'z';
		'Number' = [Char]'0'..[Char]'9';
		'Special' =  [Char]'!'..[Char]'/' + [Char]':'..[Char]'@' + [Char]'['..[Char]'`' + [Char]'{'..[Char]'~' }
	If ( $Debug ) {
		ForEach ( $key In $CharCategories.Keys ) {
			Write-Debug "`$CharCategories[$key]`:,$([Char[]]$CharCategories[$key])"
		}
	}

	# Remove excluded characters from each category.
	$charCategoriesKeys = [String[]] $CharCategories.Keys
	ForEach ( $charCategoryKey In $charCategoriesKeys ) {
		For ( $excludeCharacterIndex=0; $excludeCharacterIndex -LT $ExcludeCharacter.Length; $excludeCharacterIndex++ ) {
			# If an excluded character matches...
			If ( ([Char[]] $CharCategories[$charCategoryKey]) -CMatch $ExcludeCharacter[$excludeCharacterIndex] ) { # Case sensitive match
			
				# ...replace them with $NULL, then join into a new char array.
				$CharCategories[$charCategoryKey] = ( ( [Char[]] $CharCategories[$charCategoryKey] -CReplace $ExcludeCharacter[$excludeCharacterIndex], $NULL | ForEach-Object { If ( $PSItem ) { $PSItem } } ) -Join $NULL ).ToCharArray()
				Write-Debug "`$CharCategories[$charCategoryKey] '$($ExcludeCharacter[$excludeCharacterIndex])' excluded:,$([Char[]]$CharCategories[$charCategoryKey])"
			}
		}
	}
	If ( $Debug ) {
		ForEach ( $key In $CharCategories.Keys ) {
			Write-Debug "`$CharCategories[$key] included:,$([Char[]]$CharCategories[$key])"
		}
	}

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# For each password requested
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	1..$NumPassword |
		ForEach-Object {

			# Begin password with minimum number specified of each character category.
			$password = ''
			
			# If -MinCategory is specified, and an insufficient number of -Min<Category> are specified,
			# then, per password, pick random unspecified categories and have them set to a minimum of 1,
			# without modifying original -Min<Category> specifications.
			$minUppercaseTemp = $MinUppercase
			$minLowercaseTemp = $MinLowercase
			$minNumberTemp = $MinNumber
			$minSpecialTemp = $MinSpecial
					
			If ( $MinCategory ) {
				
				# Get specified category count.
				$allSpecifiedCount = [Int] [Bool] $minUppercaseTemp +
					[Int] [Bool] $minLowercaseTemp +
					[Int] [Bool] $minNumberTemp +
					[Int] [Bool] $minSpecialTemp
				Write-Debug "`$allSpecifiedCount:,$allSpecifiedCount"
					
				# If insufficient minimum number of categories specified.
				If ( $allSpecifiedCount -LT $MinCategory ) {
					
					# Build table of set of specifications.
					$allSpecified  = @{ 'Upper' = $minUppercaseTemp; 'Lower' = $minLowercaseTemp; 'Number' = $minNumberTemp; 'Special' = $minSpecialTemp }
					If ( $Debug ) {
						ForEach ( $key In $allSpecified.Keys ) {
							Write-Debug "`$allSpecified[$key]`:,$($allSpecified[$key])"
						}
					}

					# Get list of parameters not specified.
					$unspecified = $allSpecified.Keys | Where-Object { $allSpecified[$PSItem] -LE 0 }
					Write-Debug "`$unspecified:,$unspecified"
					
					# Get random top few unspecified that need to be modified.
					$modSpecified = (Get-Random -InputObject $unspecified -Count ($MinCategory - $allSpecifiedCount))
					Write-Debug "`$modSpecified:,$modSpecified"

					# Modify $min<category>Temp as needed for this password only.
					Switch ( $modSpecified ) {
						'Upper' { $minUppercaseTemp = 1; Write-Debug "`$minUppercaseTemp:,$minUppercaseTemp" }
						'Lower' { $minLowercaseTemp = 1; Write-Debug "`$minLowercaseTemp:,$minLowercaseTemp" }
						'Number' { $minNumberTemp = 1; Write-Debug "`$minNumberTemp:,$minNumberTemp" }
						'Special' { $minSpecialTemp = 1; Write-Debug "`$minSpecialTemp:,$minSpecialTemp" }
					}
				}
			}
			
			# For each character category add the minimum count specified.
			For ( $counter = 0; $counter -LT $minUppercaseTemp; $counter++ ) {
				$password += [Char] (Get-Random -InputObject $CharCategories.Upper)
			}
			For ( $counter = 0; $counter -LT $minLowercaseTemp; $counter++ ) {
				$password += [Char] (Get-Random -InputObject $CharCategories.Lower)
			}
			For ( $counter = 0; $counter -LT $minNumberTemp; $counter++ ) {
				$password += [Char] (Get-Random -InputObject $CharCategories.Number)
			}
			For ( $counter = 0; $counter -LT $minSpecialTemp; $counter++ ) {
				$password += [Char] (Get-Random -InputObject $CharCategories.Special)
			}
			
			# Fill in the remaining length with random categories.
			For ( $counter = $password.Length; $counter -LT $MinLength; $counter++ ) {
				$password += [Char[]] (Get-Random -InputObject $CharCategories.(Get-Random -InputObject @($CharCategories.Keys) ))
			}
			Write-Debug "`$password padded:,$password"

			# Randomize the character order.
			$password = ( [Char[]] $password | Sort-Object {Get-Random} ) -Join $NULL
			Write-Debug "`$password shuffled:,$password"
			
			# Get descriptive version of password.
			$passwordDescription = ''
			For ( $index = 0; $index -LT $password.Length; $index++ ) {
				$passwordDescription = (( $passwordDescription, $USAsciiDescription[ $password.Substring($index,1) ] ) -Join '_').Trim('_')
			}
			Write-Debug "`$passwordDescription:,$passwordDescription"
			
			If ( $Debug ) {
				
				# Create a hash table to splat Test-PasswordComplexity parameters.
				$testPasswordComplexityParameters = @{}
				$testPasswordComplexityParameters.Password = $password
				If ( $MinLength ) { $testPasswordComplexityParameters.MinLength = $MinLength }
				If ( $MinUppercase ) { $testPasswordComplexityParameters.MinUppercase = $MinUppercase }
				If ( $MinLowercase ) { $testPasswordComplexityParameters.MinLowercase = $MinLowercase }
				If ( $MinNumber ) { $testPasswordComplexityParameters.MinNumber = $MinNumber }
				If ( $MinSpecial ) { $testPasswordComplexityParameters.MinSpecial = $MinSpecial }
				#If ( $MinOther ) { $testPasswordComplexityParameters.MinOther = $MinOther }
				If ( $MinCategory ) { $testPasswordComplexityParameters.MinCategory = $MinCategory }
				If ( $ExcludeCharacter ) { $testPasswordComplexityParameters.ExcludeCharacter = $ExcludeCharacter }
				If ( $Debug ) {
					ForEach ( $key In $testPasswordComplexityParameters.Keys ) {
						Write-Debug "`$testPasswordComplexityParameters[$key]`:,$($testPasswordComplexityParameters[$key])"
					}
				}
				$testResult = Test-PasswordComplexity @testPasswordComplexityParameters
				
				# Collect metrics with debug.
				$report = New-Object PSObject |
					Select-Object -Property @{ Name='NewPassword'; Expression={$password} }, @{ Name='NewPasswordDescription'; Expression={$passwordDescription} }, @{ Name='IsCompliant'; Expression={ $testResult.isCompliant } }, @{ Name='Status'; Expression={ $testResult.status } }
					
			} Else {
			
				# Collect metrics.
				$report = New-Object PSObject |
					Select-Object -Property @{ Name='NewPassword'; Expression={$password} }, @{ Name='NewPasswordDescription'; Expression={$passwordDescription} }
					
			}

			# Write results.
			Write-Verbose $report.NewPassword
			Write-Output $report

		} |
		Export-CSV @exportCsvParameters

	#region Script Footer

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Optionally mail report.
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	If ( (Test-Path -PathType Leaf -Path $outFilePathName) -And $MailFrom -And $MailTo -And $MailServer ) {

		# Determine subject line report/alert mode.
		If ( $AlertOnly ) {
			$reportType = 'Alert'
		} Else {
			$reportType = 'Report'
		}

		$messageSubject = "New Complex Password $reportType for $($outFilePathBase.ExecutionSourceName) on $((Get-Date).ToString('s'))"

		# If the out file is larger then a specified limit (message size limit), then create a compressed (zipped) copy.
		Write-Debug "$outFilePathName.Length:,$((Get-ChildItem -LiteralPath $outFilePathName).Length)"
		If ( $CompressAttachmentLargerThan -LT (Get-ChildItem -LiteralPath $outFilePathName).Length ) {

			$outZipFilePathName = "$outFilePathName.zip"
			Write-Debug "`$outZipFilePathName:,$outZipFilePathName"

			# Create a temporary empty zip file.
			Set-Content -Path $outZipFilePathName -Value ( "PK" + [Char]5 + [Char]6 + ("$([Char]0)" * 18) ) -Force -WhatIf:$FALSE

			# Wait for the zip file to appear in the parent folder.
			While ( -Not (Test-Path -PathType Leaf -Path $outZipFilePathName) ) {
				Write-Debug "Waiting for:,$outZipFilePathName"
				Start-Sleep -Milliseconds 20
			}

			# Wait for the zip file to be written by detecting that the file size is not zero.
			While ( -Not (Get-ChildItem -LiteralPath $outZipFilePathName).Length ) {
				Write-Debug "Waiting for ($outZipFilePathName\$($outFilePathBase.FileName).csv).Length:,$((Get-ChildItem -LiteralPath $outZipFilePathName).Length)"
				Start-Sleep -Milliseconds 20
			}

			# Bind to the zip file as a folder.
			$outZipFile = (New-Object -ComObject Shell.Application).NameSpace( $outZipFilePathName )

			# Copy out file into Zip file.
			$outZipFile.CopyHere( $outFilePathName )

			# Wait for the compressed file to be appear in the zip file.
			While ( -Not $outZipFile.ParseName("$($outFilePathBase.FileName).csv") ) {
				Write-Debug "Waiting for:,$outZipFilePathName\$($outFilePathBase.FileName).csv"
				Start-Sleep -Milliseconds 20
			}

			# Wait for the compressed file to be written into the zip file by detecting that the file size is not zero.
			While ( -Not ($outZipFile.ParseName("$($outFilePathBase.FileName).csv")).Size ) {
				Write-Debug "Waiting for ($outZipFilePathName\$($outFilePathBase.FileName).csv).Size:,$($($outZipFile.ParseName($($outFilePathBase.FileName).csv)).Size)"
				Start-Sleep -Milliseconds 20
			}

			# Send the report.
			Send-MailMessage `
				-From $MailFrom `
				-To $MailTo `
				-SmtpServer $MailServer `
				-Subject $messageSubject `
				-Body 'See attached zipped Excel (CSV) spreadsheet.' `
				-Attachments $outZipFilePathName

			# Remove the temporary zip file.
			Remove-Item -LiteralPath $outZipFilePathName

		} Else {

			# Send the report.
			Send-MailMessage `
				-From $MailFrom `
				-To $MailTo `
				-SmtpServer $MailServer `
				-Subject $messageSubject `
				-Body 'See attached Excel (CSV) spreadsheet.' `
				-Attachments $outFilePathName
		}
	}

	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
	# Optionally write script execution metrics and stop the Powershell transcript.
	#---+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

	$scriptEndTime = Get-Date
	Write-Verbose "`$scriptEndTime:,$($scriptEndTime.ToString('s'))"
	$scriptElapsedTime =  $scriptEndTime - $scriptStartTime
	Write-Verbose "`$scriptElapsedTime:,$scriptElapsedTime"
	If ( $Debug -Or $Verbose ) {
		Stop-Transcript
	}
	#endregion Script Footer
}