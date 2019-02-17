Function ConvertTo-AsciiDescription {
	<#
		.SYNOPSIS
			Convert a one or more strings to a US ASCII character decription.  

		.DESCRIPTION
			Convert a one or more strings to a US ASCII character decription using ICAO (NATO) phonetic alphabet and Unicode 8859-1:1998(en) (ISO Latin 1) entity names.  

		.PARAMETER InputObject String
			Specifies one or more strings to be described.  

		.PARAMETER Delimiter String
			Specifies one or more characters placed between the descriptive character strings. The default is space (" ").
			
		.EXAMPLE
			ConvertTo-AsciiDescription '~!@#$%^&*()_+'

			tilde exclamation-mark commercial-at number-sign dollar-sign percent-sign circumflex-accent ampersand asterisk left-parenthesis right-parenthesis low-line plus-sign
			
		.EXAMPLE
			ConvertTo-AsciiDescription 'Testing, testing, 1, 2, 3.', 'The quick brown fox'
			
			TANGO echo sierra tango india november golf comma space tango echo sierra tango india november golf comma space one comma space two comma space three full-stop
			TANGO hotel echo space quebec uniform india charlie kilo space bravo romeo oscar whiskey november space foxtrot oscar x-ray
		
		.EXAMPLE
			ConvertTo-AsciiDescription 'Testing, testing, 1, 2, 3.', 'The quick brown fox' -Delimiter '_'
			
			TANGO_echo_sierra_tango_india_november_golf_comma_space_tango_echo_sierra_tango_india_november_golf_comma_space_one_comma_space_two_comma_space_three_full-stop
			TANGO_hotel_echo_space_quebec_uniform_india_charlie_kilo_space_bravo_romeo_oscar_whiskey_november_space_foxtrot_oscar_x-ray
		
		.NOTE
			Author: Terry E Dow
			Creation Date: 2019-02-14
			Last Modified: 2019-02-16

			Reference:
				NATO phonetic alphabet, International Radiotelephony Spelling Alphabet (1957), International Civil Aviation Organization (ICAO) Phonetic Alphabet, International Telecommunication Union (ITU) Phonetic Alphabet https://www.icao.int/Pages/AlphabetRadiotelephony.aspx
				ISO (the International Organization for Standardization) and IEC (the International Electrotechnical Commission) 8859-1:1998(en) https://www.unicode.org/charts/PDF/U0000.pdf https://www.iso.org/obp/ui/#iso:std:iso-iec:8859:-1:en

	#>
	[CmdletBinding(
		SupportsShouldProcess = $TRUE # Enable support for -WhatIf by invoked destructive cmdlets.
	)]
	#[System.Diagnostics.DebuggerHidden()]
	Param(

		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String[]] $InObject = '',
				
		[Parameter(
		ValueFromPipeline=$TRUE,
		ValueFromPipelineByPropertyName=$TRUE )]
		[String] $Delimiter = ' '
		
	)
	
	Begin {

		#Requires -version 3
		Set-StrictMode -Version Latest

		# Build description of US-ASCII characters by mixing ISO-8859-1 (ISO Latin 1) entity names and ICAO (NATO) phonetic names.
		$USAsciiDescription = New-Object -TypeName System.Collections.Hashtable # Support case sensitive keys.
		$USAsciiDescription.Add( ' ', 'Space' ) # 32 # ISO-8859-1 (ISO Latin 1) Character Encoding
		$USAsciiDescription.Add( '!', 'Exclamation-Mark' ) # 33
		$USAsciiDescription.Add( '"', 'Quotation-Mark' ) # 34
		$USAsciiDescription.Add( '#', 'Number-Sign' ) # 35
		$USAsciiDescription.Add( '$', 'Dollar-Sign' ) # 36
		$USAsciiDescription.Add( '%', 'Percent-Sign' ) # 37
		$USAsciiDescription.Add( '&', 'Ampersand' ) # 38
		$USAsciiDescription.Add( "'", 'Apostrophe' ) # 39
		$USAsciiDescription.Add( '(', 'Left-Parenthesis' ) # 40
		$USAsciiDescription.Add( ')', 'Right-Parenthesis' ) # 41
		$USAsciiDescription.Add( '*', 'Asterisk' ) # 42
		$USAsciiDescription.Add( '+', 'Plus-Sign' ) # 43
		$USAsciiDescription.Add( ',', 'Comma' ) # 44
		$USAsciiDescription.Add( '-', 'Hyphen-Minus' ) # 45
		$USAsciiDescription.Add( '.', 'Full-Stop' ) # 46
		$USAsciiDescription.Add( '/', 'Solidus' ) # 47
		$USAsciiDescription.Add( '0', 'Zero' ) # 48 # NATO (ICAO) Phonetic Alphabet
		$USAsciiDescription.Add( '1', 'One' ) # 49
		$USAsciiDescription.Add( '2', 'Two' ) # 50
		$USAsciiDescription.Add( '3', 'Three' ) # 51
		$USAsciiDescription.Add( '4', 'Four' ) # 52
		$USAsciiDescription.Add( '5', 'Five' ) # 53
		$USAsciiDescription.Add( '6', 'Six' ) # 54
		$USAsciiDescription.Add( '7', 'Seven' ) # 55
		$USAsciiDescription.Add( '8', 'Eight' ) # 56
		$USAsciiDescription.Add( '9', 'Nine' ) # 57
		$USAsciiDescription.Add( ':', 'Colon' ) # 58 # ISO-8859-1 (ISO Latin 1) Character Encoding
		$USAsciiDescription.Add( ';', 'Semicolon' ) # 59
		$USAsciiDescription.Add( '<', 'Less-Than-Sign' ) # 60
		$USAsciiDescription.Add( '=', 'Equals-Sign' ) # 61
		$USAsciiDescription.Add( '>', 'Greater-Than-Sign' ) # 62
		$USAsciiDescription.Add( '?', 'Question-Mark' ) # 63
		$USAsciiDescription.Add( '@', 'Commercial-At' ) # 64
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
		$USAsciiDescription.Add( '[', 'Left-Square-Bracket' ) # 91 # ISO-8859-1 (ISO Latin 1) Character Encoding
		$USAsciiDescription.Add( '\', 'Reverse-Solidus' ) # 92
		$USAsciiDescription.Add( ']', 'Right-Square-Bracket' ) # 93
		$USAsciiDescription.Add( '^', 'Circumflex-Accent' ) # 94
		$USAsciiDescription.Add( '_', 'Low-Line' ) # 95
		$USAsciiDescription.Add( '`', 'Grave-Accent' ) # 96
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
		$USAsciiDescription.Add( '{', 'Left-Curly-Brace' ) # 123 # ISO-8859-1 (ISO Latin 1) Character Encoding
		$USAsciiDescription.Add( '|', 'Vertical-Line' ) # 124
		$USAsciiDescription.Add( '}', 'Right-Curly-Brace' ) # 125
		$USAsciiDescription.Add( '~', 'Tilde' ) # 126
		
	}
	
	Process {
		
		$InObject |
			ForEach-Object {
			
				# Convert InObject string to US ASCII descriptive string.
				$description = ''
				For ( $index = 0; $index -LT $PSItem.Length; $index++ ) {
					$character = $PSItem.Substring($index,1);
					If ( $USAsciiDescription.ContainsKey( $character ) ) {
						$description = (( $description, $USAsciiDescription[ $character ] ) -Join $Delimiter).Trim($Delimiter)
					} Else {
						$description = (( $description, '?' ) -Join $Delimiter).Trim($Delimiter)
					}
				}
				
				Write-Output $description	
			}
	} 
	
	End {
	}
	
}