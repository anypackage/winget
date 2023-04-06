@{
	RootModule = 'AnyPackage.WinGet.psm1'
	ModuleVersion = '0.0.6'
	CompatiblePSEditions = @('Desktop', 'Core')
	GUID = '47e987f7-7d96-4e7b-853e-182ee6e396ae'
	Author = 'Ethan Bergstrom'
	Copyright = '(c) 2023 Ethan Bergstrom. All rights reserved.'
	Description = 'AnyPackage provider that facilitates installing WinGet packages from any compatible repository.'
	PowerShellVersion = '5.1'
	FunctionsToExport = @()
	CmdletsToExport = @()
	AliasesToExport = @()
	RequiredModules = @(
		@{
			ModuleName = 'AnyPackage'
			ModuleVersion = '0.5.1'
		},
		@{
			ModuleName = 'Cobalt'
			ModuleVersion = '0.1.0'
		}
	)
	PrivateData = @{
		AnyPackage = @{
			Providers = 'WinGet'
		}
		PSData = @{
			Tags = @('AnyPackage','Provider','WinGet','Windows')
			LicenseUri = 'https://github.com/AnyPackage/AnyPackage.WinGet/blob/main/LICENSE'
			ProjectUri = 'https://github.com/AnyPackage/AnyPackage.WinGet'
			ReleaseNotes = 'Please see https://github.com/AnyPackage/AnyPackage.WinGet/blob/main/CHANGELOG.md for release notes'
		}
	}
    HelpInfoURI = 'https://go.anypackage.dev/help'
}
