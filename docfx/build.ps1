#!/usr/bin/env pwsh

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

./main/docfx/report-matrix.ps1 -BaseDir "./main" -ReportFile "./main/docfx/matrix.md"

docfx build ./main/docfx/docfx.json --warningsAsErrors $args

# Copy the created site to the pnpcoredocs folder (= clone of the gh-pages branch)
#Remove-Item ./gh-pages/*/* -Recurse -Force
copy-item -Force -Recurse ./main/docfx/_site/* -Destination "./gh-pages"
