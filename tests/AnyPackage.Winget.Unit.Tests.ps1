[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Justification='PSSA does not understand Pester scopes well')]
param()

BeforeAll {
	$AnyPackageProvider = 'AnyPackage.Winget'
	Import-Module $AnyPackageProvider -Force
}

Describe 'basic package search operations' {
	Context 'without additional arguments' {
		BeforeAll {
			$package = 'CPUID.HWMonitor'
		}

		It 'gets a list of latest installed packages' {
			Get-Package | Where-Object {$_.Name -like 'Microsoft.DesktopAppInstaller*'} | Should -Not -BeNullOrEmpty
		}
		It 'searches for the latest version of a package' {
			Find-Package -Name $package | Where-Object {$_.Name -contains $package} | Should -Not -BeNullOrEmpty
		}
		It 'searches for all versions of a package' {
			Find-Package -Name $package -Version '[0,]' | Where-Object {$_.Name -contains $package} | Should -Not -BeNullOrEmpty
		}
	}
}

Describe 'pipeline-based package installation and uninstallation' {
	Context 'without additional arguments' {
		BeforeAll {
			$package = 'CPUID.HWMonitor'
		}

		It 'searches for and silently installs the latest version of a package' {
			Find-Package -Name $package | Install-Package -PassThru | Where-Object {$_.Name -contains $package} | Should -Not -BeNullOrEmpty
		}
		It 'detects and silently uninstalls the locally installed package just installed' {
			Get-Package -Name $package | Uninstall-Package -PassThru | Where-Object {$_.Name -contains $package} | Should -Not -BeNullOrEmpty
		}
	}
}

Describe 'multi-source support' {
	BeforeAll {
		$altSource = 'AltWinGetSource'
		$altLocation = 'https://cdn.winget.microsoft.com/cache'
		$package = 'CPUID.HWMonitor'

		Unregister-PackageSource -Name $altSource -ErrorAction SilentlyContinue
	}
	AfterAll {
		Unregister-PackageSource -Name $altSource -ErrorAction SilentlyContinue
		# Apparently this is required to repair the corruption introduced with adding and removing an alias source
		winget source reset --force
	}

	It 'registers an alternative package source' {
		Register-PackageSource -Name $altSource -Location $altLocation -Provider Winget -PassThru | Where-Object {$_.Name -eq $altSource} | Should -Not -BeNullOrEmpty
		Get-PackageSource | Where-Object {$_.Name -eq $altSource} | Should -Not -BeNullOrEmpty
	}
	It 'searches for and installs the latest version of a package from an alternate source' {
		Find-Package -Name $package -source $altSource | Install-Package -PassThru | Where-Object {$_.Name -contains $package} | Should -Not -BeNullOrEmpty
	}
	It 'detects and uninstalls a package installed from an alternate source' {
		Get-Package -Name $package | Uninstall-Package -PassThru | Where-Object {$_.Name -contains $package} | Should -Not -BeNullOrEmpty
	}
	It 'unregisters an alternative package source' {
		Unregister-PackageSource -Name $altSource -PassThru | Where-Object {$_.Name -eq $altSource} | Should -Not -BeNullOrEmpty
		Get-PackageSource | Where-Object {$_.Name -eq $altSource} | Should -BeNullOrEmpty
	}
}

Describe 'version filters' {
	BeforeAll {
		$package = 'CPUID.HWMonitor'
		# Keep at least one version back, to test the 'latest' feature
		$version = '1.44'
	}
	AfterAll {
		Uninstall-Package -Name $package -ErrorAction SilentlyContinue
	}

	Context 'required version' {
		It 'searches for and silently installs a specific package version' {
			Find-Package -Name $package -Version "[$version]" | Install-Package -PassThru | Where-Object {$_.Name -contains $package -And $_.Version -eq $version} | Should -Not -BeNullOrEmpty
		}
		It 'detects and silently uninstalls a specific package version' {
			Get-Package -Name $package -Version "[$version]" | UnInstall-Package -PassThru | Where-Object {$_.Name -contains $package -And $_.Version -eq $version} | Should -Not -BeNullOrEmpty
		}
	}

	Context 'minimum version' {
		It 'searches for and silently installs a minimum package version' {
			Find-Package -Name $package -Version "[$version,]" | Install-Package -PassThru | Where-Object {$_.Name -contains $package -And $_.Version -ge $version} | Should -Not -BeNullOrEmpty
		}
		It 'detects and silently uninstalls a minimum package version' {
			Get-Package -Name $package -Version "[$version,]" | UnInstall-Package -PassThru | Where-Object {$_.Name -contains $package -And $_.Version -ge $version} | Should -Not -BeNullOrEmpty
		}
	}

	Context 'maximum version' {
		It 'searches for and silently installs a maximum package version' {
			Find-Package -Name $package -Version "[,$version]" | Install-Package -PassThru | Where-Object {$_.Name -contains $package -And $_.Version -le $version} | Should -Not -BeNullOrEmpty
		}
		It 'detects and silently uninstalls a maximum package version' {
			Get-Package -Name $package -Version "[,$version]" | UnInstall-Package -PassThru | Where-Object {$_.Name -contains $package -And $_.Version -le $version} | Should -Not -BeNullOrEmpty
		}
	}
}

Describe "error handling" {
	Context 'ambiguous sources' {
		BeforeAll {
			$package = 'CPUID.HWMonitor'
			$defaultSource = 'winget'
			$WingetSource = Get-PackageSource -name $defaultSource | Select-Object -ExpandProperty Location
			Get-PackageSource | Unregister-PackageSource
			@('test1','test2') | Register-PackageSource -Location $WingetSource -Provider Winget
		}

		It 'refuses to find packages when the specified source does not exist' {
			{Find-Package -Name $package -Source $defaultSource -ErrorAction Stop} | Should -Throw 'The specified source is not registered with the package provider.'
		}

		It 'refuses to install packages when the specified source does not exist' {
			{Install-Package -Name $package -Source $defaultSource -ErrorAction Stop} | Should -Throw 'The specified source is not registered with the package provider.'
		}

		It 'refuses to find packages when multiple custom sources are defined and no source specified' {
			{Find-Package -Name $package -ErrorAction Stop} | Should -Throw 'Multiple non-default sources are defined, but no source was specified. Source could not be determined.'
		}

		It 'refuses to install packages when multiple custom sources are defined and no source specified' {
			{Install-Package -Name $package -ErrorAction Stop} | Should -Throw 'Multiple non-default sources are defined, but no source was specified. Source could not be determined.'
		}

		AfterAll {
			Get-PackageSource | Unregister-PackageSource
			Register-PackageSource -Name $defaultSource -Location $WingetSource -Provider Winget
		}
	}
}
