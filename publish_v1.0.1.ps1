# publish_v1.0.4.ps1
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Publishing Animated Multi Dropdown v1.0.4" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Verify version
Write-Host "Step 1: Verifying version..." -ForegroundColor Yellow
$version = (Select-String -Path "pubspec.yaml" -Pattern "version: \d+\.\d+\.\d+").Line
Write-Host "  Current version: $version" -ForegroundColor White

# Step 2: Clean
Write-Host "`nStep 2: Cleaning project..." -ForegroundColor Yellow
flutter clean
Remove-Item pubspec.lock -ErrorAction SilentlyContinue
Remove-Item -Recurse .dart_tool -ErrorAction SilentlyContinue

# Step 3: Get dependencies
Write-Host "`nStep 3: Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Step 4: Run analysis
Write-Host "`nStep 4: Running analysis..." -ForegroundColor Yellow
$analysis = flutter analyze
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Analysis failed! Please fix issues." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Analysis passed!" -ForegroundColor Green

# Step 5: Run tests
Write-Host "`nStep 5: Running tests..." -ForegroundColor Yellow
flutter test
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Tests failed! Please fix issues." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Tests passed!" -ForegroundColor Green

# Step 6: Check for outdated packages
Write-Host "`nStep 6: Checking outdated packages..." -ForegroundColor Yellow
flutter pub outdated

# Step 7: Dry run
Write-Host "`nStep 7: Dry run..." -ForegroundColor Yellow
flutter pub publish --dry-run

# Step 8: Publish
Write-Host "`nStep 8: Publishing..." -ForegroundColor Yellow
$confirmation = Read-Host "Ready to publish v1.0.4? (y/n)"
if ($confirmation -eq 'y') {
    flutter pub publish
    Write-Host "`n========================================" -ForegroundColor Green
    Write-Host "✅ Published successfully!" -ForegroundColor Green
    Write-Host "📦 Package: animated_multi_dropdown v1.0.4" -ForegroundColor Cyan
    Write-Host "🔗 Visit: https://pub.dev/packages/animated_multi_dropdown" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "❌ Publishing cancelled." -ForegroundColor Yellow
}