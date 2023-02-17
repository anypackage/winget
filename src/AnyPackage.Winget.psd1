@{
	RootModule = 'AnyPackage.Winget.psm1'
	ModuleVersion = '0.0.1'
	CompatiblePSEditions = @('Desktop', 'Core')
	GUID = '47e987f7-7d96-4e7b-853e-182ee6e396ae'
	Author = 'Ethan Bergstrom'
	Copyright = '(c) 2023 Ethan Bergstrom. All rights reserved.'
	Description = 'AnyPackage provider that facilitates installing Winget packages from any compatible repository.'
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
			ReleaseNotes = 'Please see https://github.com/AnyPackage/AnyPackage.Winget/blob/main/CHANGELOG.md for release notes'
		}
	}
    HelpInfoURI = 'https://go.anypackage.dev/help'
}
