$ISOFile = "C:\Temp\WindowsServer2022.iso"
$newImageDir = New-Item -Path 'C:\Temp\newimage' -ItemType Directory
$ISOMounted = Mount-DiskImage -ImagePath $ISOFile -StorageType ISO -PassThru
$ISODriveLetter = ($ISOMounted | Get-Volume).DriveLetter
Copy-Item -Path ($ISODriveLetter +":\*") -Destination C:\Temp\newimage -Recurse
dism /Split-Image /ImageFile:C:\Temp\newimage\sources\install.wim /SWMFile:C:\Temp\newimage\sources\install.swm /FileSize:4096
Get-Disk | Where BusType -eq "USB"
# 1 or 2 etc... 
$USBDrive = Get-Disk | Where Number -eq 2
$USBDrive | Clear-Disk -RemoveData -Confirm:$true -PassThru
$USBDrive | Set-Disk -PartitionStyle GPT
$Volume = $USBDrive | New-Partition -Size 8GB -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel WS2022
Copy-Item -Path C:\Temp\newimage\* -Destination ($Volume.DriveLetter + ":\") -Recurse -Exclude install.wim
Dismount-DiskImage -ImagePath $ISOFile
