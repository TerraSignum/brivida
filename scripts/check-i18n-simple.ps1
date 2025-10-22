# i18n Completeness Checker for Brivida App
Write-Host "Brivida i18n Completeness Checker" -ForegroundColor Cyan

function Get-AllJsonKeys {
    param($JsonObject, $Prefix = "")
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

Write-Host "Loading reference file: $referenceFile" -ForegroundColor Green
$referenceContent = Get-Content $referenceFile -Raw -Encoding UTF8
$referenceJson = $referenceContent | ConvertFrom-Json
$referenceKeys = Get-AllJsonKeys -JsonObject $referenceJson | Sort-Object
Write-Host "Found $($referenceKeys.Count) keys in reference file"

$totalMissing = 0

foreach ($langFile in $languageFiles) {
    $langName = [System.IO.Path]::GetFileNameWithoutExtension($langFile)
    Write-Host ""
    Write-Host "Checking $langName..." -ForegroundColor Yellow
    
    $langContent = Get-Content $langFile -Raw -Encoding UTF8
    $langJson = $langContent | ConvertFrom-Json
    $langKeys = Get-AllJsonKeys -JsonObject $langJson | Sort-Object
    
    $missingKeys = $referenceKeys | Where-Object { $_ -notin $langKeys }
    $completeness = [math]::Round((($referenceKeys.Count - $missingKeys.Count) / $referenceKeys.Count) * 100, 1)
    
    Write-Host "   Completeness: $completeness% ($($referenceKeys.Count - $missingKeys.Count)/$($referenceKeys.Count))"
    
    if ($missingKeys.Count -gt 0) {
        Write-Host "   Missing $($missingKeys.Count) keys:" -ForegroundColor Red
        $missingKeys | ForEach-Object { Write-Host "      - $_" -ForegroundColor Red }
        $totalMissing += $missingKeys.Count
    } else {
        Write-Host "   All keys present!" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "SUMMARY:" -ForegroundColor Cyan
Write-Host "Total missing translations: $totalMissing" -ForegroundColor Red
Write-Host "Check complete!" -ForegroundColor Green