function Write-Package {
	param (
		[Parameter(ValueFromPipeline)]
		[object[]]
		$InputObject,

		[Parameter()]
		[PackageRequest]
		$Request = $Request
	)

	process {
		foreach ($package in $InputObject) {
			if ($package.ID -and $package.Version) {
				# Winget can sometimes return packages without version information, which AnyPackage doesn't like
				if ($package.Source) {
					# If source information is provided, construct a source object for inclusion in the results
					$source = $Request.NewSourceInfo($package.Source,(Cobalt\Get-WingetSource | Where-Object Name -EQ $package.Source | Select-Object -ExpandProperty Arg),$true)
					$Request.WritePackage($package.ID, $package.Version, '', $source)
				} else {
					$Request.WritePackage($package.ID, $package.Version)
				}
			}
		}
	}
}