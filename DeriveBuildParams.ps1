function Derive-BranchLifecycle
{
    param([string] $branchName, [string] $branchNameLong)

    if ($branchNameLong -match '^refs\/heads\/.*$') 
    {
        $branchNameLong = $branchNameLong -replace "refs/heads/", "";
    }
    elseif ($branchNameLong -match '^refs\/pull\/\d{1,50}\/merge$') 
    {
        $branchNameLong = $branchNameLong -replace "refs/heads/", "";
        $branchNameLong = $branchNameLong -replace "/merge", "";
    }

    $extension = $branchNameLong -replace "[\W_]", "-";
    $extension = $extension -replace "\-+", "-";
    $extension = $extension.ToLowerInvariant();

    if ($branchName -eq "master")
    {
        return "Release";
    }
    elseif ($branchName.ToLower().StartsWith("hotfix-"))
    {
        return "Release";
    }
    elseif ($extension.Contains("pull-"))
    {
        $extension = $extension.Replace("refs-","");
        $extension = $extension.Replace("-merge","");
    }

    return $extension;
}

function Derive-LifeCycle
{
    param([string] $extension)

    if ($extension -eq "Release")
    {
        return "Release"
    }

    return "PreRelease";
}

function Derive-BranchSuffix
{
    param([string] $extension)

    if ($extension -eq "Release")
    {
        return ""
    } else 
    {
        $BranchSuffix = "-" + $extension
        return $BranchSuffix[0..40] -join ""
    }
}

 & {
    $BranchLifecycle = Derive-BranchLifecycle $(Build.SourceBranchName) $(Build.SourceBranch)
    $LifeCycle = Derive-LifeCycle $ChannelName
    $BranchSuffix = Derive-BranchSuffix $ChannelName


    Write-Host "
                ░░░░░░░░▄▄▄███░░░░░░░░░░░░░░░░░░░░
                ░░░▄▄██████████░░░░░░░░░░░░░░░░░░░
                ░███████████████░░░░░░░░░░░░░░░░░░
                ░▀███████████████░░░░░▄▄▄░░░░░░░░░
                ░░░███████████████▄███▀▀▀░░░░░░░░░
                ░░░░███████████████▄▄░░░░░░░░░░░░░
                ░░░░▄████████▀▀▄▄▄▄▄░▀░░░░░░░░░░░░
                ▄███████▀█▄▀█▄░░█░▀▀▀░█░░▄▄░░░░░░░
                ▀▀░░░██▄█▄░░▀█░░▄███████▄█▀░░░▄░░░
                ░░░░░█░█▀▄▄▀▄▀░█▀▀▀█▀▄▄▀░░░░░░▄░▄█
                ░░░░░█░█░░▀▀▄▄█▀░█▀▀░░█░░░░░░░▀██░
                ░░░░░▀█▄░░░░░░░░░░░░░▄▀░░░░░░▄██░░
                ░░░░░░▀█▄▄░░░░░░░░▄▄█░░░░░░▄▀░░█░░
                ░░░░░░░░░▀███▀▀████▄██▄▄░░▄▀░░░░░░
                ░░░░░░░░░░░█▄▀██▀██▀▄█▄░▀▀░░░░░░░░
                ░░░░░░░░░░░██░▀█▄█░█▀░▀▄░░░░░░░░░░
                ░░░░░░░░░░█░█▄░░▀█▄▄▄░░█░░░░░░░░░░
                ░░░░░░░░░░█▀██▀▀▀▀░█▄░░░░░░░░░░░░░
                ░░░░░░░░░░░░▀░░░░░░░░░░░▀░░░░░░░░░
                Your Parameters are served"

    # Printing out useful Parameters
    Write-Host "----------------------------------------------------"

    Write-Host "----------------------------------------------------"
    Write-Host "Derived Build Parameters"
    Write-Host "----------------------------------------------------"
    Write-Host "Project: $(Build.DefinitionName)";
    Write-Host "Branch Name Full: $(Build.SourceBranch)";
    Write-Host "Branch Name: $(Build.SourceBranchName)";
    Write-Host "Build Number: $(Build.BuildNumber)";

    Write-Host "----------------------------------------------------"
    Write-Host "Helpful Parameters"
    Write-Host "----------------------------------------------------"
    Write-Host "BranchLifecycle: $BranchLifecycle";
    Write-Host "LifeCycle: $LifeCycle";
    Write-Host "BranchSuffix: $BranchSuffix";

    Write-Host "----------------------------------------------------"
    Write-Host "----------------------------------------------------"

    # Settings the VSTS Variables       
    Write-Host "##vso[task.setvariable variable=BranchLifecycle]$BranchLifecycle"
    Write-Host "##vso[task.setvariable variable=LifeCycle]$LifeCycle"
    Write-Host "##vso[task.setvariable variable=BranchSuffix]$BranchSuffix"

    return 0;
}