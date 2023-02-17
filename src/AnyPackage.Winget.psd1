@{
	RootModule = 'AnyPackage.Winget.psm1'
	ModuleVersion = '0.0.1'
	CompatiblePSEditions = @('Desktop', 'Core')
	GUID = '070f2b8f-c7db-4566-9296-2f7cc9146bf0'
	Author = 'Ethan Bergstrom'
	Copyright = '(c) 2023 Ethan Bergstrom. All rights reserved.'
	Description = 'AnyPackage provider that facilitates installing Winget packages from any NuGet repository.'
	PowerShellVersion = '5.1'
	FunctionsToExport = @()
	CmdletsToExport = @()
	AliasesToExport = @()
	RequiredModules = @(
		@{
			ModuleName = 'AnyPackage'
			ModuleVersion = '0.1.0'
		},
		@{
			ModuleName = 'Cobalt'
			ModuleVersion = '0.1.0'
		}
	)
	PrivateData = @{
		PSData = @{
			Tags = @('AnyPackage','Provider','Winget','Windows')
			LicenseUri = 'https://github.com/AnyPackage/AnyPackage.Winget/blob/main/LICENSE'
			ProjectUri = 'https://github.com/AnyPackage/AnyPackage.Winget'
			ReleaseNotes = 'This is a PowerShell AnyPackage provider. It is a wrapper on top of Winget.
			It discovers Winget packages from https://www.Winget.org and other NuGet repos.'
		}
	}
}
