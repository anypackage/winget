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
				if ($package.Source) {
					# If source information is provided, construct a source object for inclusion in the results
					$location = $sources | Where-Object Name -EQ $package.Source | Select-Object -ExpandProperty Arg
					$source = [PackageSourceInfo]::new($package.Source, $location, $true, $Request.ProviderInfo)
				} else {
					$source = $null
				}

				if ($package.Version) {
					$package = [PackageInfo]::new($package.ID, $package.Version, $source, $Request.ProviderInfo)
				} else {
					$package = [PackageInfo]::new($package.ID, $null, $source, $Request.ProviderInfo)
				}

				$Request.WritePackage($package)
			}
		}
	}
}