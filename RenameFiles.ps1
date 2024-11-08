function Get-UserInput($prompt, $default) {
    $input = Read-Host "$prompt [$default]"
    if ([string]::IsNullOrWhiteSpace($input)) {
        return $default
    }
    return $input
}

$inputFolder = Read-Host "Enter the input folder path"
$tvSeries = Get-UserInput "Enter TV series name" "My Show"
$resolution = Get-UserInput "Enter resolution" "1080p"
$type = Get-UserInput "Enter type" "WEB-DL"
$source = Get-UserInput "Enter source (e.g., Amazon, abbreviate as AMZN)" "AMZN"
$audio = Get-UserInput "Enter audio format (e.g., DDP 2.0)" "DDP 2.0"

if (-not (Test-Path $inputFolder)) {
    Write-Error "Input folder does not exist."
    exit
}

Get-ChildItem $inputFolder -File | ForEach-Object {
    $oldName = $_.Name
    
    if ($oldName -match "S(\d+)E(\d+)") {
        $season = $matches[1]
        $episode = $matches[2]
        
        $newName = "{0}.S{1}E{2}.{3}.{4}.{5}.{6}-NAME{7}" -f `
            ($tvSeries -replace "\s+", "."), `
            $season, `
            $episode, `
            $resolution, `
            $source, `
            $type, `
            ($audio -replace "\s+", "."), `
            $_.Extension

        $newPath = Join-Path $_.Directory.FullName $newName
        Rename-Item $_.FullName $newPath -Force
        
        Write-Host "Renamed: $oldName -> $newName"
    }
    else {
        Write-Warning "Skipped $oldName: Could not extract season and episode information."
    }
}

Write-Host "File renaming complete."
