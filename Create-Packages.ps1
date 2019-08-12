<#
.SYNOPSIS
    Packages a build of GitHub for Unity
.DESCRIPTION
    Packages a build of GitHub for Unity
#>

[CmdletBinding()]

Param(
    [string]
    $Version,
    [switch]
    $Trace = $false
)

Set-StrictMode -Version Latest
if ($Trace) {
    Set-PSDebug -Trace 1
}

. $PSScriptRoot\scripts\helpers.ps1 | out-null

$artifactDir="$rootDirectory\artifacts"
$tmpDir="$rootDirectory\tmp"
$packageDir="$rootDirectory\build\packages"
$srcDir="$rootDirectory\src"
$originalSrcDir="$srcDir\git-for-unity\src"
$packagingScriptsDir="$srcDir\git-for-unity\packaging\create-unity-packages"

$pkgName="com.unity.git.api"
$pkgSrcDir="$packageDir\$pkgName"
$extrasDir="$originalSrcDir\extras\$pkgName"
$ignorefile="$originalSrcDir\$pkgName\.npmignore"
$baseInstall="Packages\$pkgName"

Run-Command -Fatal { & $packagingScriptsDir\run.ps1 $pkgSrcDir $tmpDir $pkgName $Version $extrasDir $ignorefile $baseInstall -Skip }

$pkgName="com.github.ui"
$pkgSrcDir="$packageDir\$pkgName"
$extrasDir="$srcDir\extras\$pkgName"
$ignorefile="$srcDir\$pkgName\.npmignore"
$baseInstall="Packages\$pkgName"

Run-Command -Fatal { & $packagingScriptsDir\run.ps1 $pkgSrcDir $tmpDir $pkgName $Version $extrasDir $ignorefile $baseInstall -Skip }

$pkgName="github-for-unity-source-package"
$pkgSrcDir="$tmpDir\unitypackage"

Run-Command -Fatal { & $packagingScriptsDir\zip.ps1 $pkgSrcDir $artifactDir $pkgName $Version -Unity }

$pkgName="github-for-unity-net20"
$pkgSrcDir="$rootDirectory\unity\GHfU-net35\Assets"
$baseInstall="Assets"

Run-Command -Fatal { & $packagingScriptsDir\run.ps1 $pkgSrcDir $artifactDir $pkgName $Version -BaseInstall $baseInstall -SkipPackman }

$pkgName="github-for-unity-net471"
$pkgSrcDir="$rootDirectory\unity\GHfU-net471\Assets"
$baseInstall="Assets"

Run-Command -Fatal { & $packagingScriptsDir\run.ps1 $pkgSrcDir $artifactDir $pkgName $Version -BaseInstall $baseInstall -SkipPackman }

$pkgName="github-for-unity-binary-package"
$pkgSrcDir="$rootDirectory\unity\GHfU-net471\Assets\Plugins\GitHub\Editor"
$baseInstall="Packages\com.github.ui"

Run-Command -Fatal { & $packagingScriptsDir\run.ps1 $pkgSrcDir $artifactDir $pkgName $Version -BaseInstall $baseInstall -SkipPackman }

Run-Command -Quiet { Remove-Item "$tmpDir" -Recurse -Force }
