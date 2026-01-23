param(
	[Parameter(Mandatory=$true)]
	[string]$IP,
	[switch]$g)

if (-not (Test-Path $IP)) {
	Write-Error "Not found: $IP"
    exit 1
}

if ($g) {
	$ft = "\*.gif"
}
else {
	$ft = "\*"
}

#$filepath = read-host "What directory would you like to use?"
$ImgPath = ls -path ($IP + $ft) | get-random

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
