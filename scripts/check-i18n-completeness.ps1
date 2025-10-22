# i18n Completeness Checker for Brivida App
# This script compares en.json (reference) with other language files
# and reports missing translation keys

Write-Host "Brivida i18n Completeness Checker" -ForegroundColor Cyan
Write-Host "=" * 50

# Function to recursively extract all keys from a JSON object
function Get-AllJsonKeys {
    param(
        [PSCustomObject]$JsonObject,
        [string]$Prefix = ""
    )
    
    $keys = @()
    
    foreach ($property in $JsonObject.PSObject.Properties) {
        $currentKey = if ($Prefix) { "$Prefix.$($property.Name)" } else { $property.Name }
        $keys += $currentKey
        
        if ($property.Value -is [PSCustomObject]) {
            $keys += Get-AllJsonKeys -JsonObject $property.Value -Prefix $currentKey
        }
    }
    
    return $keys
}

$referenceFile = "assets\i18n\en.json"
$languageFiles = @("assets\i18n\de.json", "assets\i18n\es.json", "assets\i18n\fr.json", "assets\i18n\pt.json")

# Check if reference file exists
if (-not (Test-Path $referenceFile)) {
    Write-Error "Reference file not found: $referenceFile"
    exit 1
}

# Load reference file (English)
Write-Host "Loading reference file: $referenceFile" -ForegroundColor Green
$referenceContent = Get-Content $referenceFile -Raw -Encoding UTF8
$referenceJson = $referenceContent | ConvertFrom-Json
$referenceKeys = Get-AllJsonKeys -JsonObject $referenceJson | Sort-Object

Write-Host "   Found $($referenceKeys.Count) keys in reference file" -ForegroundColor Gray

$results = @()
$totalMissing = 0

# Check each language file
foreach ($langFile in $languageFiles) {
    if (-not (Test-Path $langFile)) {
        Write-Warning "Language file not found: $langFile"
        continue
    }
    
    $langName = [System.IO.Path]::GetFileNameWithoutExtension($langFile)
    Write-Host ""
    Write-Host "Checking $langName..." -ForegroundColor Yellow
    
    $langContent = Get-Content $langFile -Raw -Encoding UTF8
    $langJson = $langContent | ConvertFrom-Json
    $langKeys = Get-AllJsonKeys -JsonObject $langJson | Sort-Object
    
    $missingKeys = $referenceKeys | Where-Object { $_ -notin $langKeys }
    $extraKeys = $langKeys | Where-Object { $_ -notin $referenceKeys }
    
    $completeness = [math]::Round((($referenceKeys.Count - $missingKeys.Count) / $referenceKeys.Count) * 100, 1)
    
    Write-Host "   Completeness: $completeness% ($($referenceKeys.Count - $missingKeys.Count)/$($referenceKeys.Count))" -ForegroundColor Green
    
    if ($missingKeys.Count -gt 0) {
    Write-Host "   Missing $($missingKeys.Count) keys:" -ForegroundColor Red
        $missingKeys | ForEach-Object { Write-Host "      - $_" -ForegroundColor Red }
        $totalMissing += $missingKeys.Count
    } else {
    Write-Host "   All keys present!" -ForegroundColor Green
    }
    
    if ($extraKeys.Count -gt 0) {
    Write-Host "   Extra $($extraKeys.Count) keys (not in reference):" -ForegroundColor Blue
        $extraKeys | ForEach-Object { Write-Host "      + $_" -ForegroundColor Blue }
    }
    
    $results += @{
        Language = $langName
        File = $langFile
        Completeness = $completeness
        TotalKeys = $langKeys.Count
        MissingKeys = $missingKeys
        ExtraKeys = $extraKeys
        MissingCount = $missingKeys.Count
        ExtraCount = $extraKeys.Count
    }
}

# Summary
Write-Host ""
Write-Host "=" * 50
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "=" * 50

$results | ForEach-Object {
    $status = if ($_.Completeness -ge 95) { "OK" } elseif ($_.Completeness -ge 80) { "WARN" } else { "FAIL" }
    $missingText = "$($_.MissingCount) missing"
    $extraText = "$($_.ExtraCount) extra"
    Write-Host "$status $($_.Language): $($_.Completeness)% complete ($missingText, $extraText)"
}

Write-Host ""
Write-Host "Total missing translations across all languages: $totalMissing" -ForegroundColor Red

Write-Host ""
Write-Host "Check complete." -ForegroundColor Green