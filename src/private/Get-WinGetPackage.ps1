function Get-WinGetPackage {
	param (
		[Parameter()]
		[PackageRequest]
		$Request = $Request
	)

	# Filter results by any name and version requirements
	# We apply additional package name filtering when using wildcards to make WinGet's wildcard behavior more PowerShell-esque
	Cobalt\Get-WinGetPackage |
		Where-Object {$Request.IsMatch($_.ID)} |
			Where-Object {-Not $Request.Version -Or $Request.Version.Satisfies($_.Version)}
}
