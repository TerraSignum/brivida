# PowerShell Script to fix Freezed 3.0 migration issues

$modelFiles = @(
    "lib\core\models\admin.dart",
    "lib\core\models\analytics.dart", 
    "lib\core\models\calendar_event.dart",
    "lib\core\models\chat.dart",
    "lib\core\models\dispute.dart",
    "lib\core\models\document.dart",
    "lib\core\models\lead.dart",
    "lib\core\models\legal.dart",
    "lib\core\models\live_location.dart",
    "lib\core\models\notification.dart",
    "lib\core\models\payout.dart",
    "lib\core\models\review.dart"
)

foreach ($file in $modelFiles) {
    if (Test-Path $file) {
        Write-Host "Fixing $file..."
        $content = Get-Content $file -Raw
        $content = $content -replace '@freezed\r?\nclass\s+(\w+)\s+with', '@freezed${NewLine}abstract class $1 with'
        Set-Content $file -Value $content -NoNewline
        Write-Host "Fixed $file"
    } else {
        Write-Host "File not found: $file"
    }
}

Write-Host "All Freezed models have been updated for 3.0 compatibility!"