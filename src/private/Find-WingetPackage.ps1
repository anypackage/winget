function Find-WingetPackage {
	param (
		[Parameter()]
		[PackageRequest]
		$Request = $Request
	)

	$DefaultPackageSource = 'winget'

	[array]$RegisteredPackageSources = Cobalt\Get-WingetSource

	$selectedSource = $(
		if ($Request.Source) {
			# Finding the matched package sources from the registered ones
			if ($RegisteredPackageSources.Name -eq $Request.Source) {
				# Found the matched registered source
				$Request.Source
			} else {
				throw 'The specified source is not registered with the package provider.'
			}
		} else {
			# User did not specify a source. Now what?
			if ($RegisteredPackageSources.Count -eq 1) {
				# If no source name is specified and only one source is available, use that source
				$RegisteredPackageSources[0].Name
			} elseif ($RegisteredPackageSources.Name -eq $DefaultPackageSource) {
				# If multiple sources are avaiable but none specified, use the default package source if present
				$DefaultPackageSource
			} else {
				# If the default assumed source is not present and no source specified, we can't guess what the user wants - throw an exception
				throw 'Multiple non-default sources are defined, but no source was specified. Source could not be determined.'
			}
		}
	)

	$WingetParams = @{
		ID = $Request.Name
		Source = $selectedSource
		Exact = $true
	}

	# Filter results by any name and version requirements
	# The final results must be grouped by package name, showing the highest available version for install, to make the results easier to consume
	Cobalt\Find-WinGetPackage @WinGetParams | Where-Object {$Request.IsMatch($_.ID)} | ForEach-Object {
		$candidate = $_

		# Perform an additional query to get all available versions, and create a package object for each version
		$version = Cobalt\Get-WinGetPackageInfo -ID $candidate.ID -Versions -Source $selectedSource | 
						Where-Object {-Not $Request.Version -Or (([NuGet.Versioning.VersionRange]$Request.Version).Satisfies($_))} |
							Sort-Object -Descending | Select-Object -First 1

		# Winget doesn't return source information when source is specified, so we have to construct a fresh object here with the source information included
		$candidate | Select-Object -Property ID,@{
			Name = 'Version'
			Expression = {$version}
		},@{
			Name = 'Source'
			Expression = {$selectedSource}
		}
	}
}
