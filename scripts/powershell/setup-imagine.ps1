#!/usr/bin/env pwsh
# Setup solution design artifacts and scan for customer artifacts

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output "Usage: ./setup-imagine.ps1 [-Json] [-Help]"
    Write-Output "  -Json     Output results in JSON format"
    Write-Output "  -Help     Show this help message"
    exit 0
}

# Load common functions
. "$PSScriptRoot/common.ps1"

# Get repository root
$repoRoot = Get-RepoRoot

# Define paths
$artifactsDir = Join-Path $repoRoot 'solution-artifacts'
$outputFile = Join-Path $repoRoot 'solution-design.md'

# Create artifacts directory if it doesn't exist
New-Item -ItemType Directory -Path $artifactsDir -Force | Out-Null

# Scan for artifact files
$artifactFiles = @()
if (Test-Path $artifactsDir) {
    # Find all supported file types
    $extensions = @('*.pdf', '*.docx', '*.doc', '*.txt', '*.md', '*.png', '*.jpg', '*.jpeg')
    $artifactFiles = Get-ChildItem -Path $artifactsDir -File -Include $extensions | 
        Sort-Object Name | 
        ForEach-Object { $_.FullName }
}

# Determine output filename (check for existing versions)
if (Test-Path $outputFile) {
    $version = 2
    while (Test-Path (Join-Path $repoRoot "solution-design-v$version.md")) {
        $version++
    }
    $outputFile = Join-Path $repoRoot "solution-design-v$version.md"
}

# Output results
if ($Json) {
    $result = [PSCustomObject]@{
        REPO_ROOT = $repoRoot
        ARTIFACTS_DIR = $artifactsDir
        ARTIFACT_FILES = @($artifactFiles)
        OUTPUT_FILE = $outputFile
        ARTIFACT_COUNT = $artifactFiles.Count
    }
    $result | ConvertTo-Json -Compress
} else {
    Write-Output "REPO_ROOT: $repoRoot"
    Write-Output "ARTIFACTS_DIR: $artifactsDir"
    Write-Output "ARTIFACT_FILES:"
    if ($artifactFiles.Count -eq 0) {
        Write-Output "  (none found)"
    } else {
        foreach ($file in $artifactFiles) {
            Write-Output "  - $file"
        }
    }
    Write-Output "OUTPUT_FILE: $outputFile"
    Write-Output "ARTIFACT_COUNT: $($artifactFiles.Count)"
}
