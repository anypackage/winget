function Get-WingetPackage {
	param (
		[Parameter()]
		[PackageRequest]
		$Request = $Request
	)

	# Filter results by any name and version requirements
	# We apply additional package name filtering when using wildcards to make Winget's wildcard behavior more PowerShell-esque
	Cobalt\Get-WingetPackage |
		Where-Object {$Request.IsMatch($_.ID)} |
			Where-Object {-Not $Request.Version -Or (([NuGet.Versioning.VersionRange]$Request.Version).Satisfies($_.Version))}
}
