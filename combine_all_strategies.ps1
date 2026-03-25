# combine_all_strategies_fixed.ps1
# This script combines ALL strategy code into ONE file - FIXED VERSION

param(
    [string]$OutputFile = ".\all_strategies_complete.dart"
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Combining ALL Animation Strategies into ONE File" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

# Set base path
$basePath = "E:\Dharmesh flutter\plugin\animated_multi_dropdown\lib\src\strategies"

# Check if path exists
if (!(Test-Path $basePath)) {
    Write-Host "Error: Path not found: $basePath" -ForegroundColor Red
    exit 1
}

# Get all strategy files
$strategyFiles = Get-ChildItem -Path $basePath -Filter "*_strategy.dart" -Recurse

Write-Host "`nFound $($strategyFiles.Count) strategy files" -ForegroundColor Green

# Create combined content
$combinedContent = New-Object System.Collections.ArrayList

# ==================== HEADER ====================
$combinedContent.Add("// ============================================================") | Out-Null
$combinedContent.Add("// COMPLETE ANIMATION STRATEGIES") | Out-Null
$combinedContent.Add("// Generated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')") | Out-Null
$combinedContent.Add("// Total Strategies: $($strategyFiles.Count)") | Out-Null
$combinedContent.Add("// ============================================================") | Out-Null
$combinedContent.Add("") | Out-Null
$combinedContent.Add("library animated_multi_dropdown;") | Out-Null
$combinedContent.Add("") | Out-Null
$combinedContent.Add("import 'package:flutter/material.dart';") | Out-Null
$combinedContent.Add("import 'package:flutter/services.dart';") | Out-Null
$combinedContent.Add("import '../models/multi_dropdown_config.dart';") | Out-Null
$combinedContent.Add("import '../models/selection_mode.dart';") | Out-Null
$combinedContent.Add("import '../utils/color_utils.dart';") | Out-Null
$combinedContent.Add("import '../widgets/custom_text.dart';") | Out-Null
$combinedContent.Add("import '../widgets/indicator.dart';") | Out-Null
$combinedContent.Add("import 'multi_dropdown_animation_strategy.dart';") | Out-Null
$combinedContent.Add("") | Out-Null
$combinedContent.Add("// ============================================================") | Out-Null
$combinedContent.Add("// BASE STRATEGY") | Out-Null
$combinedContent.Add("// ============================================================") | Out-Null
$combinedContent.Add("") | Out-Null

# First add base_drop_down_strategy.dart
$baseFile = Get-ChildItem -Path $basePath -Filter "base_drop_down_strategy.dart" -Recurse
if ($baseFile) {
    $baseContent = Get-Content $baseFile.FullName -Raw
    # Remove imports that are already in header
    $baseContent = $baseContent -replace "import 'package:flutter/material.dart';", ""
    $baseContent = $baseContent -replace "import 'package:flutter/services.dart';", ""
    $baseContent = $baseContent -replace "import '../models/multi_dropdown_config.dart';", ""
    $baseContent = $baseContent -replace "import '../models/selection_mode.dart';", ""
    $baseContent = $baseContent -replace "import '../utils/color_utils.dart';", ""
    $baseContent = $baseContent -replace "import '../widgets/custom_text.dart';", ""
    $baseContent = $baseContent -replace "import '../widgets/indicator.dart';", ""
    $baseContent = $baseContent -replace "import 'multi_dropdown_animation_strategy.dart';", ""
    $combinedContent.Add($baseContent) | Out-Null
    $combinedContent.Add("") | Out-Null
    $combinedContent.Add("") | Out-Null
    Write-Host "Added base strategy" -ForegroundColor Gray
}

# Add multi_dropdown_animation_strategy.dart
$interfaceFile = Get-ChildItem -Path $basePath -Filter "multi_dropdown_animation_strategy.dart" -Recurse
if ($interfaceFile) {
    $interfaceContent = Get-Content $interfaceFile.FullName -Raw
    $interfaceContent = $interfaceContent -replace "import 'package:flutter/material.dart';", ""
    $interfaceContent = $interfaceContent -replace "import '../models/multi_dropdown_config.dart';", ""
    $combinedContent.Add($interfaceContent) | Out-Null
    $combinedContent.Add("") | Out-Null
    $combinedContent.Add("") | Out-Null
    Write-Host "Added animation strategy interface" -ForegroundColor Gray
}

# Add all individual strategies
$strategies = @()
$strategyFiles | ForEach-Object {
    $name = $_.BaseName -replace '_strategy.dart', ''
    if ($name -ne "base_drop_down" -and $name -ne "multi_dropdown_animation") {
        $strategies += $_
    }
}

$counter = 1
foreach ($file in $strategies | Sort-Object Name) {
    $strategyName = $file.BaseName -replace '_strategy.dart', ''
    $displayName = ($strategyName -replace '_', ' ') -replace '^\w', {$_.ToUpper()}

    Write-Host "  [$counter/$($strategies.Count)] Adding: $($file.Name)" -ForegroundColor Yellow

    $combinedContent.Add("// ============================================================") | Out-Null
    $combinedContent.Add("// $displayName STRATEGY") | Out-Null
    $combinedContent.Add("// File: $($file.Name)") | Out-Null
    $combinedContent.Add("// ============================================================") | Out-Null
    $combinedContent.Add("") | Out-Null

    $content = Get-Content $file.FullName -Raw

    # Remove any imports from individual strategy files
    $content = $content -replace "import 'package:flutter/material.dart';", ""
    $content = $content -replace "import 'package:flutter/services.dart';", ""
    $content = $content -replace "import '../models/multi_dropdown_config.dart';", ""
    $content = $content -replace "import '../models/selection_mode.dart';", ""
    $content = $content -replace "import '../utils/color_utils.dart';", ""
    $content = $content -replace "import '../widgets/custom_text.dart';", ""
    $content = $content -replace "import '../widgets/indicator.dart';", ""
    $content = $content -replace "import 'multi_dropdown_animation_strategy.dart';", ""
    $content = $content -replace "import 'base_drop_down_strategy.dart';", ""

    $combinedContent.Add($content) | Out-Null
    $combinedContent.Add("") | Out-Null
    $combinedContent.Add("") | Out-Null

    $counter++
}

# Add footer with usage guide
$combinedContent.Add("// ============================================================") | Out-Null
$combinedContent.Add("// USAGE GUIDE") | Out-Null
$combinedContent.Add("// ============================================================") | Out-Null
$combinedContent.Add("/*") | Out-Null
$combinedContent.Add("How to use these strategies:") | Out-Null
$combinedContent.Add("") | Out-Null
$combinedContent.Add("1. Single Selection with specific strategy:") | Out-Null
$combinedContent.Add("   SimpleDropdownFactory.single(") | Out-Null
$combinedContent.Add("     items: myItems,") | Out-Null
$combinedContent.Add("     value: selectedValue,") | Out-Null
$combinedContent.Add("     onChanged: (value) => setState(() => selectedValue = value),") | Out-Null
$combinedContent.Add("     itemBuilder: (item) => Text(item),") | Out-Null
$combinedContent.Add("     animationType: DropdownAnimationType.glass, // Change this") | Out-Null
$combinedContent.Add("   );") | Out-Null
$combinedContent.Add("") | Out-Null
$combinedContent.Add("2. Multiple Selection with specific strategy:") | Out-Null
$combinedContent.Add("   SimpleDropdownFactory.multiple(") | Out-Null
$combinedContent.Add("     items: myItems,") | Out-Null
$combinedContent.Add("     value: selectedValues,") | Out-Null
$combinedContent.Add("     onChanged: (values) => setState(() => selectedValues = values),") | Out-Null
$combinedContent.Add("     itemBuilder: (item) => Text(item),") | Out-Null
$combinedContent.Add("     animationType: DropdownAnimationType.liquid,") | Out-Null
$combinedContent.Add("   );") | Out-Null
$combinedContent.Add("") | Out-Null
$combinedContent.Add("3. Available Animation Types ($($strategies.Count) total):") | Out-Null
$combinedContent.Add("   - glass") | Out-Null
$combinedContent.Add("   - liquid") | Out-Null
$combinedContent.Add("   - neon") | Out-Null
$combinedContent.Add("   - bouncy3d") | Out-Null
$combinedContent.Add("   - cyberpunk") | Out-Null
$combinedContent.Add("   - and more...") | Out-Null
$combinedContent.Add("") | Out-Null
$combinedContent.Add("4. Create custom strategy by extending BaseDropDownStrategy:") | Out-Null
$combinedContent.Add("   class MyCustomStrategy<T> extends BaseDropDownStrategy<T> {") | Out-Null
$combinedContent.Add("     @override") | Out-Null
$combinedContent.Add("     Widget buildDropdown({...}) {") | Out-Null
$combinedContent.Add("       // Your custom animation logic") | Out-Null
$combinedContent.Add("     }") | Out-Null
$combinedContent.Add("   }") | Out-Null
$combinedContent.Add("*/") | Out-Null
$combinedContent.Add("") | Out-Null

# Save the combined file
$combinedContent -join "`r`n" | Out-File -FilePath $OutputFile -Encoding UTF8

Write-Host ""
Write-Host "SUCCESS! ALL STRATEGIES COMBINED INTO ONE FILE!" -ForegroundColor Green
Write-Host "   File: $OutputFile" -ForegroundColor Yellow

if (Test-Path $OutputFile) {
    $fileSize = [math]::Round((Get-Item $OutputFile).Length / 1KB, 2)
    Write-Host "   Size: $fileSize KB" -ForegroundColor Cyan
    Write-Host "   Strategies: $($strategies.Count) + 2 base files" -ForegroundColor Cyan
}

# Create a summary file
$summaryFile = $OutputFile -replace '\.dart$', '_summary.txt'
$summary = @"
================================================================================
ANIMATION STRATEGIES - COMPLETE SUMMARY
================================================================================

Total Strategies: $($strategies.Count)
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

Strategy List:
--------------------------------------------------------------------------------
"@

$idx = 1
foreach ($file in $strategies | Sort-Object Name) {
    $name = $file.BaseName -replace '_strategy.dart', ''
    $displayName = ($name -replace '_', ' ') -replace '^\w', {$_.ToUpper()}
    $summary += "$($idx.ToString().PadLeft(3)): $displayName ($name)`r`n"
    $idx++
}

$summary += @"
--------------------------------------------------------------------------------

File Information:
- Complete File: $OutputFile

Usage Example:
--------------------------------------------------------------------------------
SimpleDropdownFactory.single(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  animationType: DropdownAnimationType.glass, // Change this to any strategy above
);
"@

$summary | Out-File -FilePath $summaryFile -Encoding UTF8
Write-Host "   Summary file: $summaryFile" -ForegroundColor Gray

Write-Host ""
Write-Host "COMPLETE! All strategies in one file!" -ForegroundColor Green
Write-Host ""
Write-Host "To view the file:" -ForegroundColor Cyan
Write-Host "  code $OutputFile" -ForegroundColor White
Write-Host "  notepad $OutputFile" -ForegroundColor White