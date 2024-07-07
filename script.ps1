Add-Type -AssemblyName System.Windows.Forms

$Urls = "https://aka.ms/vs/17/release/vc_redist.x64.exe","https://aka.ms/vs/17/release/vc_redist.x86.exe","https://download.microsoft.com/download/1/7/1/1718CCC4-6315-4D8E-9543-8E28A4E18C4C/dxwebsetup.exe","https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.tr.exe"

Write-Output "Lütfen indirme dizini seçin"

# Dizin seçme iletişim kutusunu oluşturma
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Dizin seçin"

# Kullanıcıdan dizin seçmesini isteme
$result = $folderBrowser.ShowDialog()

$selectedPath = ""

# Eğer kullanıcı OK düğmesine bastıysa
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # Seçilen dizinin yolunu al
    $selectedPath = $folderBrowser.SelectedPath
} else {
    return
}

$Count = 0

foreach ($url in $Urls) {
    $FileName = [System.IO.Path]::GetFileName($url)

    $input =  Read-Host "$FileName i indirmek istermisiniz? Yes yada boş bırakın"
    $Count++
    if ($input -eq "Yes") {
        Write-Output "Dosya indiriliyor"

        $DestinationPath = Join-Path -Path $selectedPath -ChildPath $FileName

        # Dosyayı indir
        Invoke-WebRequest -Uri $url -OutFile $DestinationPath

        # İndirilen dosyayı kur
        if ($Count -lt 3) {
          Start-Process -FilePath $DestinationPath -ArgumentList "/install", "/passive", "/norestart" -Wait
        } elseif ($Count -eq 3) {
          Start-Process -FilePath $DestinationPath -Wait
        } elseif ($Count -eq 4) {
          Start-Process -FilePath $DestinationPath
        }

    } elseif ($input -eq "No") {
        Continue
    } else {
        Continue
    }
}

Write-Output "İşlem tamamlandı."
