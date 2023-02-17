using module AnyPackage
using namespace AnyPackage.Provider

# Current script path
[string]$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope Script).Value.MyCommand.Definition -Parent

# Dot sourcing private script files
Get-ChildItem $ScriptPath/private -Recurse -Filter '*.ps1' -File | ForEach-Object {
	. $_.FullName
}

[PackageProvider("Winget")]
class WingetProvider : PackageProvider, IGetSource, ISetSource, IGetPackage, IFindPackage, IInstallPackage, IUninstallPackage {
	WingetProvider() : base('070f2b8f-c7db-4566-9296-2f7cc9146bf0') { }

	[void] GetSource([SourceRequest] $Request) {
		Cobalt\Get-WingetSource | Where-Object {$_.Name -Like $Request.Name} | ForEach-Object {
			$Request.WriteSource($_.Name, $_.Arg, $true)
		}
	}

	[void] RegisterSource([SourceRequest] $Request) {
		Cobalt\Register-WingetSource -Name $Request.Name -Argument $Request.Location
		# Winget doesn't return anything after source operations, so we make up our own output object
		$Request.WriteSource($Request.Name, $Request.Location.TrimEnd("\"), $Request.Trusted)
	}

	[void] UnregisterSource([SourceRequest] $Request) {
		Cobalt\Unregister-WingetSource -Name $Request.Name
		# Winget doesn't return anything after source operations, so we make up our own output object
		$Request.WriteSource($Request.Name, '')
	}

	[void] SetSource([SourceRequest] $Request) {
		$this.RegisterSource($Request)
	}

	[void] GetPackage([PackageRequest] $Request) {
		Get-WingetPackage | Write-Package
	}

	[void] FindPackage([PackageRequest] $Request) {
		Find-WingetPackage | Write-Package
	}

	[void] InstallPackage([PackageRequest] $Request) {
		# Run the package request first through Find-WingetPackage to determine which source to use, and filter by any version requirements
		Find-WingetPackage | Cobalt\Install-WingetPackage | Write-Package
	}

	[void] UninstallPackage([PackageRequest] $Request) {
		# Run the package request first through Get-WingetPackage to filter by any version requirements and save it off for later use
		$result = Get-WingetPackage
		Cobalt\Uninstall-WingetPackage $result.ID
		
		# Winget doesn't return any output on successful uninstallation, so we have to make up a new object to satisfy AnyPackage
		Write-Package $result
	}
}

[PackageProviderManager]::RegisterProvider([WingetProvider], $MyInvocation.MyCommand.ScriptBlock.Module)

