#do you hate Windows Photos too?
#use this script and let Powershell load it's own image viewer

param(
	[Parameter(Mandatory=$true)]
	[string]$IP)

if ($IsWindows) {
	continue
}
else {
	Write-Host "This program is only for Windows systems"
	sleep 3; exit
}

if (-not (Test-Path $IP)) {
	Write-Error "Not found: $IP"
    exit 1
}

#$filepath = read-host "What directory would you like to use?"
$ImgPath = ls -path ($IP + "\*") | get-random

add-type -assemblyname system.windows.forms
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(800, 600)
$Form.StartPosition = 'CenterScreen'

$Image = [System.Drawing.Image]::FromFile($ImgPath)

$PictureBox = New-Object System.Windows.Forms.PictureBox
$PictureBox.Image = $Image
$PictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$PictureBox.Dock = [System.Windows.Forms.DockStyle]::Fill

$Form.Controls.Add($PictureBox)
$Form.ShowDialog()

$Image.Dispose()
$Form.Dispose()


