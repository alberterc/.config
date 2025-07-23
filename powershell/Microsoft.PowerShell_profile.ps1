# Run command with elevated user
function sudo(
    [string]$command,
    [string]$path,
    [switch]$help
) {
    process {
        if ($help) {
            $helpStr = @"
$($PSStyle.Foreground.Yellow)Overview:
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)sudo$($PSStyle.BoldOff)$($PSStyle.Reset) - Launch a new terminal or run a command with elevated user.
       $($PSStyle.Foreground.Green)[-command <command>]$($PSStyle.Reset)
           Set the command to run when opening the new terminal.
       $($PSStyle.Foreground.Green)[-path <absolute-path>]$($PSStyle.Reset)
           Set the location of the new terminal.

$($PSStyle.Foreground.Yellow)Examples:
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)sudo$($PSStyle.BoldOff) $($PSStyle.Foreground.Green)-command $($PSStyle.Foreground.Cyan)"ls -Hidden"$($PSStyle.Reset)
       Launches a new terminal with elevated user then run "ls -Hidden".
       The same can be achieved with 'sudo "ls -Hidden"'. This command can
       still be run without double or single quotes if there are no spaces
       present.
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)sudo$($PSStyle.BoldOff) $($PSStyle.Foreground.Green)-path $($PSStyle.Foreground.Cyan)"C:\path\to\file"$($PSStyle.Reset)
       Launches a new terminal with elevated user inside C:\path\to\file.
       The path needs to be an absolute path and use double or single quotes if
       spaces are present. Running 'sudo' without '-path' launches a new terminal
       in the same directory where the 'sudo' command was ran from.
"@
            Write-Host $helpStr
            _endDoc
            break
        }
        $currPath = Get-Location
        if ($command) {
            $argList = $command -join ' '
            if ($path) {
                Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -WorkingDirectory $path -Command $argList"
            }
            else {
                Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -WorkingDirectory $currPath -Command $argList"
            }
        }
        else {
            if ($path) {
                Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -WorkingDirectory $path"
            }
            else {
                Start-Process wt -Verb runAs -ArgumentList "pwsh.exe -NoExit -WorkingDirectory $currPath"
            }
        }
    }
}

# Get the definition of a command
function which(
    [string]$name,
    [switch]$help
) {
    process {
        if (-not $help -and -not $name) {
            Write-Host "$($PSStyle.Foreground.Yellow)Unknown command. Use 'which -help'.$($PSStyle.Reset)"
            break
        }

        if ($help) {
            $helpStr = @"
$($PSStyle.Foreground.Yellow)Overview:
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)which$($PSStyle.BoldOff)$($PSStyle.Reset) - Show the definition or path of a command.
       $($PSStyle.Foreground.Green)<name>$($PSStyle.Reset)
           The name of the command.

$($PSStyle.Foreground.Yellow)Examples:
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)which$($PSStyle.BoldOff) $($PSStyle.Foreground.Cyan)git$($PSStyle.Reset)
       Returns the absolute path where git.exe is installed.
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)which$($PSStyle.BoldOff) $($PSStyle.Foreground.Cyan)which$($PSStyle.Reset)
       Returns the function of 'which' from this profile.
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)which$($PSStyle.BoldOff) $($PSStyle.Foreground.Cyan)ls$($PSStyle.Reset)
       Returns the command which 'ls' is aliased from.
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)which$($PSStyle.BoldOff) $($PSStyle.Foreground.Cyan)Get-ChildItem$($PSStyle.Reset)
       Returns the available parameters for 'Get-ChildItem'.
"@
            Write-Host $helpStr
            _endDoc
            break
        }

        if ($name) {
            Get-Command $name | Select-Object -ExpandProperty Definition
            break
        }
    }
}

# Fuzzy find files and open in Neovim (nvim open)
function nvop(
    [switch]$help
) {
    process {
        if ($help) {
            $helpStr = @"
$($PSStyle.Foreground.Yellow)Overview:
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)nvop$($PSStyle.BoldOff)$($PSStyle.Reset) - Fuzzy find files and open in Neovim (nvim open -> nvop).

$($PSStyle.Foreground.Yellow)Requirements:
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)rg$($PSStyle.BoldOff), $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)fzf$($PSStyle.BoldOff), $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)bat$($PSStyle.BoldOff)
"@
            Write-Host $helpStr
            _endDoc
            break
        }

        if (-not (_exists rg, fzf, bat)) {
            _endDoc
            return
        }
        $file = rg --files | fzf --preview "bat --color=always --style=numbers {}" --preview-window=right:60%:wrap --border --height=90% --header="Open File in Neovim:"
        if ($file -and (Test-Path $file)) {
            nvim $file
        }
        else {
            Write-Host "No file selected or file doesn't exist." -ForegroundColor Yellow
        }
    }
}

# Profile functions
function profile(
    [switch]$reload,
    [switch]$help,
    [switch]$update
) {
    begin {
        if (-not $reload) {
            $beginStr = @"
$($PSStyle.Foreground.Yellow)Using $PROFILE as profile.
$($PSStyle.Foreground.Yellow)Overview:
   $($PSStyle.Bold)profile$($PSStyle.BoldOff) $($PSStyle.Foreground.Green)[-help | -reload | -update]
       $($PSStyle.Foreground.Green)[-help]$($PSStyle.Reset)
           Display help for this profile.
       $($PSStyle.Foreground.Green)[-reload]$($PSStyle.Reset)
           Reload this profile.
       $($PSStyle.Foreground.Green)[-update]$($PSStyle.Reset)
           Check update for this profile.
"@
            Write-Host $beginStr
        }
    }

    process {
        # Reload profile
        if ($reload) {
            & $PROFILE
            Write-Host "$PROFILE has been reloaded." -ForegroundColor Cyan
            break
        }

        # Display help for profile
        if ($help) {
            $str = @"
`n$($PSStyle.Foreground.Yellow)Available commands in this profile:$($PSStyle.Reset)
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)sudo$($PSStyle.BoldOff)$($PSStyle.Reset) - Launch a new terminal or run a command with elevated user. See 'sudo -help' for more info.
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)which$($PSStyle.BoldOff)$($PSStyle.Reset) - Show the definition or path of a command. See 'which -help' for more info.
   $($PSStyle.Foreground.Yellow)$($PSStyle.Bold)nvop$($PSStyle.BoldOff)$($PSStyle.Reset) - Fuzzy Search and open a file in Neovim.
"@
            Write-Host $str
            break
        }

        # Check for profile update
        if ($update) {
            try {
                $url = "https://raw.githubusercontent.com/alberterc/.config/refs/heads/main/powershell/Microsoft.PowerShell_profile.ps1"
                $prevHash = Get-FileHash $PROFILE
                Invoke-RestMethod $url -OutFile "$env:temp/Microsoft.PowerShell_profile.ps1"
                $newHash = Get-FileHash "$env:temp/Microsoft.PowerShell_profile.ps1"
                if ($newHash.Hash -ne $prevHash.hash) {
                    Copy-Item -Path "$env:temp/Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
                    Write-Host "Profile has been updated. Please restart your shell to reflect changes." -ForegroundColor Yellow
                }
                else {
                    Write-Host "Profile is already up to date." -ForegroundColor Yellow
                }
            }
            catch {
                Write-Error "Failed to check for $PROFILE update: $_."
            }
            finally {
                Remove-Item "$env:temp/Microsoft.PowerShell_profile.ps1" -ErrorAction SilentlyContinue
            }
            break
        }
    }

    end {
        if (-not $reload) {
            _endDoc
        }
    }
}

# Show that a command is part of this profile in its documentation
function _endDoc {
    $str = @"

$($PSStyle.Foreground.Yellow)This command is part of a powershell profile.
Use 'profile -help' for more info.$($PSStyle.Reset)
"@
    Write-Host $str
}

# Check commands exists/installed
function _exists(
    [Parameter(Mandatory = $true)]
    [string[]]$commands
) {
    process {
        foreach ($cmd in $commands) {
            if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
                Write-Host "$($PSStyle.Foreground.Red)Missing required command(s): $cmd.$($PSStyle.Reset)"
                return $false
            }
        }
        return $true
    }
}

Write-Host "$($PSStyle.Foreground.Yellow)Currently using a powershell profile.$($PSStyle.Reset)"
Write-Host "$($PSStyle.Foreground.Yellow)Use 'profile -help' for more info.$($PSStyle.Reset)"