# Fix NewLine markers
$files = Get-ChildItem -Path "lib\core\models\*.dart" -Exclude "*.freezed.dart","*.g.dart"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $content = $content -replace '\$\{NewLine\}', "`n"
    Set-Content $file.FullName -Value $content -NoNewline
    Write-Host "Fixed: $($file.Name)"
}