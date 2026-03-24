# publish_v1.0.1.ps1
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Publishing Animated Multi Dropdown v1.0.1" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Clean
Write-Host "Step 1: Cleaning project..." -ForegroundColor Yellow
flutter clean
Remove-Item pubspec.lock -ErrorAction SilentlyContinue
Remove-Item -Recurse .dart_tool -ErrorAction SilentlyContinue

# Step 2: Get dependencies
Write-Host "`nStep 2: Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Step 3: Run analysis
Write-Host "`nStep 3: Running analysis..." -ForegroundColor Yellow
$analysis = flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Host "Analysis failed! Please fix issues." -ForegroundColor Red
    exit 1
}
Write-Host "Analysis passed!" -ForegroundColor Green

# Step 4: Run tests
Write-Host "`nStep 4: Running tests..." -ForegroundColor Yellow
flutter test
if ($LASTEXITCODE -ne 0) {
    Write-Host "Tests failed! Please fix issues." -ForegroundColor Red
    exit 1
}
Write-Host "Tests passed!" -ForegroundColor Green

# Step 5: Dry run
Write-Host "`nStep 5: Dry run..." -ForegroundColor Yellow
flutter pub publish --dry-run

# Step 6: Publish
Write-Host "`nStep 6: Publishing..." -ForegroundColor Yellow
$confirmation = Read-Host "Ready to publish v1.0.1? (y/n)"
if ($confirmation -eq 'y') {
    flutter pub publish
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "Published successfully!" -ForegroundColor Green
    Write-Host "Visit: https://pub.dev/packages/animated_multi_dropdown" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "Publishing cancelled." -ForegroundColor Yellow
}