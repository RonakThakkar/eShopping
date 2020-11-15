param ($serviceName,$servicePackagePath)

$servicePackageFileName=[System.IO.Path]::GetFileName($servicePackagePath)
$servicePackageNameWithVersion=[System.IO.Path]::GetFileNameWithoutExtension($servicePackagePath)
$servicePath="$Env:SystemDrive\inetpub\wwwroot\$servicePackageNameWithVersion"

# Install IIS Web Server
Write-Host " "
Write-Host "=================================================================================================================================================="
Write-Host "WebApplication/Service '$serviceName' with Artifact $servicePackageNameWithVersion - Deployment Started."

if ((Get-WindowsFeature Web-Server).InstallState -ne "Installed") {
    Install-WindowsFeature Web-Server
} else {
    Write-Host "IIS Web Server is already installed on these server"
}

# Download & Install Hosting Bundle for Windows (This includes ASP.NET Core Runtime) (If not installed)
# The .NET Core Hosting bundle is an installer for the .NET Core Runtime and the ASP.NET Core Module. The bundle allows ASP.NET Core apps to run with IIS.
# https://gallery.technet.microsoft.com/How-to-determine-ASPNET-512379b5
# https://blog.codeinside.eu/2019/08/31/check-installed-version-for-aspnetcore-on-windows-iis-with-powershell/

$DotNetCoreVersion="3.1.10"
$DotNetCoreHostingBundleFileName="dotnet-hosting-$DotNetCoreVersion-win.exe"
$DotNetCoreHostingBundleUrl="https://download.visualstudio.microsoft.com/download/pr/7e35ac45-bb15-450a-946c-fe6ea287f854/a37cfb0987e21097c7969dda482cebd3/$DotNetCoreHostingBundleFileName"

$DotNETCoreUpdatesPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Updates\.NET Core"
if(Test-Path $DotNETCoreUpdatesPath)
{
    $DotNetCoreItems = Get-Item -ErrorAction Stop -Path $DotNETCoreUpdatesPath

    $NotInstalled = $True
    $DotNetCoreItems.GetSubKeyNames() | Where { $_ -Match "Microsoft .NET Core $DotNetCoreVersion - Windows Server Hosting" } | ForEach-Object {
        $NotInstalled = $False
        Write-Host "The host has '$_' already installed"
    }
} else {
    $NotInstalled = $True
}

If ($NotInstalled) { 
    # Download
    Write-Host "Installing .NET Core Hosting Bundle $DotNetCoreVersion Including ASP.NET Core Module for IIS"
    Invoke-WebRequest $DotNetCoreHostingBundleUrl -OutFile ./Downloads/$DotNetCoreHostingBundleFileName

    # Install
    $process = Start-Process -FilePath ./Downloads/dotnet-hosting-3.1.10-win.exe -ArgumentList "/silent" -Wait -PassThru
    $process.ExitCode

    # Add .NET Core to environment path.
    $env:Path = $env:Path + "C:\Program Files\dotnet\;"

    # Remove
    Remove-Item -Path ./Downloads/$DotNetCoreHostingBundleFileName -Force
}

# Remove existing web application and application directory.
$websiteName="Default Web Site"
$manager = Get-IISServerManager

if ($null -ne $(Get-WebApplication -Site $websiteName -Name $serviceName))
{
    $oldPhysicalPath=$manager.Sites["Default Web Site"].Applications["/$serviceName"].VirtualDirectories[0].PhysicalPath
    
    # Stop Application Pool. This is to prevent file in use by Application Pool.
    Write-Host "Stopping DefaultAppPool Applocation Pool"
    Stop-WebAppPool -Name "DefaultAppPool"
    $currentRetry = 0;
    $success = $false;
    do{
        $status = Get-WebAppPoolState -name "DefaultAppPool"
        if ($status.value -eq "Stopped"){
                $success = $true;
            }
            Start-Sleep -s 5
            $currentRetry = $currentRetry + 1;
        }
    while (!$success -and $currentRetry -le 4)
    Write-Host "DefaultAppPool Applocation Pool Stopped = " $success

    # Delete Existing Application Directory.
    if([System.IO.Directory]::Exists($oldPhysicalPath))
    {
        Remove-Item -Path $oldPhysicalPath -Recurse -Force
        Write-Host "Deleted Application Directory $oldPhysicalPath"
    }

    # Start Application Pool
    Write-Host "Starting DefaultAppPool Application Pool"
    
    Start-WebAppPool -Name "DefaultAppPool"
    
    $currentRetry = 0;
    $success = $false;
    do{
        $status = Get-WebAppPoolState -name "DefaultAppPool"
        if ($status.value -eq "Started"){
                $success = $true;
            }
            Start-Sleep -s 5
            $currentRetry = $currentRetry + 1;
        }
    while (!$success -and $currentRetry -le 4)
    Write-Host "DefaultAppPool Application Pool Started = " $success

    # $app = $manager.Sites["Default Web Site"].Applications["/$serviceName"];
    # $manager.Sites["Default Web Site"].Applications.Remove($app)
    # $manager.CommitChanges()
}

## Create Application Directory for new deployment
if(![System.IO.Directory]::Exists($servicePath))
{
    Write-Host "Creating Application Directory"
    New-Item -ItemType Directory -Name $servicePackageNameWithVersion -Path $Env:SystemDrive\inetpub\wwwroot
} else {
    Write-Host "Application Directory already exists at '$servicePath' "
}

## Create IIS Application / Updated physical path in case of new deployment
if ($null -eq $(Get-WebApplication -Site $websiteName -Name $serviceName))
{
    Write-Host "Creating Web Application $serviceName under IIS Website $websiteName"
    $manager.Sites["Default Web Site"].Applications.Add("/$serviceName", $servicePath)
}
else {
    $manager.Sites["Default Web Site"].Applications["/$serviceName"].VirtualDirectories[0].PhysicalPath = $servicePath
}
$manager.CommitChanges()

## Deploy Web Application / New version
Write-Host "Downloading package files from Location - '$servicePackagePath'"
$downloadFilePath="./Downloads/$servicePackageFileName"
if([System.IO.Directory]::Exists($downloadFilePath))
{
    Remove-Item -Path $downloadFilePath -Force
}
Invoke-WebRequest $servicePackagePath -OutFile $downloadFilePath
Write-Host "Deploying package files to application directory - '$servicePath'"

Expand-Archive -LiteralPath $downloadFilePath -DestinationPath $servicePath -Force

# Stop Application Pool
Start-WebAppPool -Name "DefaultAppPool"

Write-Host "WebApplication/Service '$serviceName' with Artifact $servicePackageNameWithVersion - Deployment Completed."
Write-Host "=================================================================================================================================================="

# Reference Links
# https://stackoverflow.com/questions/37120790/how-to-ensure-iis-website-is-completely-stopped-in-powershell
# https://octopus.com/blog/iis-powershell
# https://docs.microsoft.com/en-us/iis/manage/scripting/how-to-use-microsoftwebadministration
# https://forums.asp.net/t/2129787.aspx?Delete+Web+Site+and+Content+programmatically
# https://blog.danskingdom.com/powershell-functions-to-convert-remove-and-delete-iis-web-applications/
# https://stackoverflow.com/questions/16732784/how-to-write-a-powershell-script-to-release-file-if-used-by-any-other-process
# https://help.octopus.com/t/during-a-deployment-is-it-important-to-stop-both-iis-site-and-app-pool/24439/3