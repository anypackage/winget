function Write-Package {
	param (
		[Parameter(ValueFromPipeline)]
		[object[]]
		$InputObject,

		[Parameter()]
		[PackageRequest]
		$Request = $Request
	)

	begin {
		$sources = Cobalt\Get-WinGetSource
	}

	process {
		foreach ($package in $InputObject) {
			if ($package.ID) {
				if (-not $package.Version) {
					$Request.WriteVerbose("Package '$($package.ID)' does not have a version, changing to 0.")
					$package.Version = '0'
				}

				if ($package.Source) {
					# If source information is provided, construct a source object for inclusion in the results
					$source = $Request.NewSourceInfo($package.Source,($sources | Where-Object Name -EQ $package.Source | Select-Object -ExpandProperty Arg),$true)
					$Request.WritePackage($package.ID, $package.Version, '', $source)
				} else {
					$Request.WritePackage($package.ID, $package.Version)
				}
			}
		}
	}
}