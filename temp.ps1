
# else
# {
#     Write-Host "Web Application is already present under IIS Website $websiteName"
    
#     $oldPhysicalPath=$manager.Sites["Default Web Site"].Applications["/$serviceName"].VirtualDirectories[0].PhysicalPath
#     if ($servicePath -ne $oldPhysicalPath) {
        
#         Write-Host "Taking backup for existing application version at path $servicePath"
#         # TODO: Write logic to take backup
        
#         Write-Host "Updating Web Application Physical Path to point to new Path '$servicePath'"
#         $manager.Sites["Default Web Site"].Applications["/$serviceName"].VirtualDirectories[0].PhysicalPath = $servicePath            
#     }
# }

# Remove old application directory. This throws exception.
# if ($servicePath -ne $oldPhysicalPath) {
#     Remove-Item -Path $oldPhysicalPath -Recurse -Force
# }

#Stop-WebAppPool -Name "DefaultAppPool"
#New-Item -ItemType File -Name "App_Offline.htm" -Path $servicePath

#Start-WebAppPool -Name "DefaultAppPool"
#Remove-Item -Path "$servicePath/App_Offline.htm"

