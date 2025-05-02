
# This is supposed to update the git repo and deploy the new version. 

# First I want to make sure I run the script at the right location.
$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$WikiRoot = Join-Path $ScriptPath ".." | Resolve-Path
Set-Location $WikiRoot 

# Adding the possiblity to put the commit message as an argument.
if ($args.Length -gt 0 -and -not [string]::IsNullOrWhiteSpace($args[0])) {
    $message = $args[0]
} else {
    $message = Read-Host "Enter commit message"
}

# Performing git commands and trying to catch possible errors. 
try {
    git add .
    git commit -m "$message"
    if ($?) {
        Write-Host "Commit successful"
    } else {
        Write-Host "Commit failed"
    }

    git push
    if ($?) {
        Write-Host "Push successful"
    } else {
        Write-Host "Push failed"
    }

    # Deploy with MkDocs
    mkdocs gh-deploy
    if ($?) {
        Write-Host "Deployment successful"
    } else {
        Write-Host "Deployment failed"
    }
}
catch {
    $errorMessage = "An error occurred at $(Get-Date): $_"
    Write-Host $errorMessage
}