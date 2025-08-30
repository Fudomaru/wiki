---
title: Deployment
description: Simple scripts used to automate the deployment and updating of this digital Dojo.
---

# MkDocs Auto-Deploy Script (Powershell)

## Overview
Automates committing and deploying changes to my Digital Dojo.  
I build this as a first step to understanding and using a real CI/CD for this project. 
For that I needed to solve going to every command by hand.  
But I didn't want to start using any fancy tool for this simple task. So I decided to make this simple script to automate it.  

## Functional Breakdown

Here I am going to break down what I put into this script: 

### 1. Location  

I wanted this to be portable and usable without much of a hustle.
So I put the script right into the repo of this page.  
This way I can always use it as long as I pulled the repo to work on it. 
I needed to make sure it runs from the right place: the rood of my repo.  
To get this location in Powershell I used the following:  

``` 
$ScriptPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$WikiRoot = Join-Path $ScriptPath ".." | Resolve-Path
Set-Location $WikiRoot 
```

---

### 2. Git Commit Comment

To actually use git commit I have to have a comment of what I am commiting.  
I wanted to solve this by using an argument I can just put in after the script to make it feel like a real command.  
That wasn't good enough. When I tried it and it worked, I thought it would be enough. 
But even the second try I just forgot about the comment. So I needed a fallback method.  
And what better option then just let the script ask the user for the Commit Message. That would look like that: 

```
if ($args.Length -gt 0 -and -not [string]::IsNullOrWhiteSpace($args[0])) {
$message = $args[0]
} else {
$message = Read-Host "Enter commit message"
}
```

---

### 3. Git Operations  

This is actually the most straight forward. Just the git commands I normally use by hand. But I did not want to make it quite as easy for myself. So I tried myself with some error catching and outputting what was successful and what failed. All in all I just used a simple try catch with an output of what was currently running when it failed ($_). This gives always gives me a good idea of where the error happend, and let me look at the right thing to try to figure out what went wrong. Also I put the $message variable I got in the previouse part as the commit message.  

```
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
}
catch {
    $errorMessage = "An error occurred at $(Get-Date): $_"
    Write-Host $errorMessage
}
```

### 4. GitHup Pages

Here I used MkDocs own command gh-deploy. 
This command pretty much handels everything I need for me. 
First it builds the actual site. 
That would be the same as running `mkdocs build`. 
Then it pushes this build to a seperate branch in my repo. 
This way I do not have to have the build site in my main branch, 
and just tell GitHub to use the seperate branch to deploy from. 
This works like a charme, without a lot of hassle so far. 
I put this right after my git operations.  

```
mkdocs gh-deploy
    if ($?) {
        Write-Host "Deployment successful"
    } else {
        Write-Host "Deployment failed"
    }
```

## Future Ideas

- Building in local logging to get more information and maintain everything cleanly for building a full CI/CD. 

- Timestemping inside the commit message and log output. 
