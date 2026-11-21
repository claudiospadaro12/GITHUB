# MARCATORE_ESTRAI_SET_VOL_M15_v1
# SOLA LETTURA sul Library pack (non lo modifica). Estrae 15 set (.set) dal Library pack (zip ridotto o originale) e li mette in UN piccolo zip sul Desktop
# (UBS_LIBPACK_VOL_M15.zip, nomi piatti), verificando lo SHA256 di ognuno. Non apre MT5, non usa la rete, non tocca conti/VPS/reale.
$ErrorActionPreference='Stop'
$INV=[Globalization.CultureInfo]::InvariantCulture
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$SEL=@(
  @('9637033_Till_UBS-US30-M15-U3V12','runs/lib-col-20261113-202655/candidates/9637033_Till_UBS-US30-M15-U3V12.set','217978CC461086EDC7FC1CAF1812CD06BBE2BF78B9EF2DC080195777642A597E'),
  @('UBS-US30-M15-U3V08','runs/lib-col-20261113-202655/candidates/UBS-US30-M15-U3V08.set','83DA2FD2B51AEAC05058A2DD1283AC4E2A9C2DEEAA91630D2C24043C9B3181E4'),
  @('US30_VOL_M15_a','runs/lib-col-20261114-073511/candidates/US30_VOL_M15_a.set','E160C78950A0702DFE6568D84A8A7673B60EB484CE951E4554F13F07BD0595A9'),
  @('US30_VOL_M15_b','runs/lib-col-20261114-073511/candidates/US30_VOL_M15_b.set','E5F8F1BF6B21AD37A31356240EBAA836100BAF5C09F44505AD2FEF45B6C2336E'),
  @('US30_VOL_M15_c','runs/lib-col-20261114-073511/candidates/US30_VOL_M15_c.set','757366285F705F6872611BCC7A0A81ED7149092097031972584253742BFADED2'),
  @('US30_VOL_M15_g','runs/lib-col-20261114-073511/candidates/US30_VOL_M15_g.set','9C10FE5C66468E7AEA0923A96C25BB3DA8BDC5FC42B879E7A9EF26224FA5D107'),
  @('UBS-US500-M15-U5W10','runs/lib-col-20261113-202655/candidates/UBS-US500-M15-U5W10.set','07A02384370602C920F3BF8531B154B9D478F682967EC8C36107E57D283CD14D'),
  @('VolUS500_a','runs/lib-col-20261114-073511/candidates/VolUS500_a.set','621E58089901360777FAD28FA5B83D75D906E27B2E786F56E0CDFDC369E30DC5'),
  @('VolUS500_c','runs/lib-col-20261114-073511/candidates/VolUS500_c.set','6149DE08C32E1121857CD7DC67360DE5569576468181DD83774168CF2B337710'),
  @('VolUS500_g','runs/lib-col-20261114-073511/candidates/VolUS500_g.set','AB882B178B641D0D5C51D4EFDF50E4108B2973B611DE9599CAFF5A9F1979083B'),
  @('NAS_VOL_M15_A','runs/lib-col-20261114-073511/candidates/NAS_VOL_M15_A.set','483BED71E47DC299F14BA003EE7010537C9EBA2505261E57B14DD6926EC17A74'),
  @('NAS_VOL_M15_B','runs/lib-col-20261114-073511/candidates/NAS_VOL_M15_B.set','31F073D4FDF008F05B36FABA16C8E42154BB6CB3A2602D04663C6F3681A3C9BF'),
  @('NAS_VOL_M15_C','runs/lib-col-20261114-073511/candidates/NAS_VOL_M15_C.set','7788864547E477E5EA43C2856139D7FFB769FC2140EE4F5B0343C332BA38A820'),
  @('NAS_VOL_M15_D','runs/lib-col-20261114-073511/candidates/NAS_VOL_M15_D.set','CA20D255E11524556573E9E3124D16FA32372CA4DECA6C5C2E1B9AD9C603E9C0'),
  @('NAS_VOL_M15_E','runs/lib-col-20261114-073511/candidates/NAS_VOL_M15_E.set','7EC304CB2DA2FC1B069FE68DEFD65561A963799BD37A70BF07BB14650C81CF5A')
)
$cerca=@([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Downloads'),(Join-Path $env:USERPROFILE 'Documents'),'C:\ABTG_RISULTATI')
$z=@()
foreach($d in $cerca){ if(Test-Path -LiteralPath $d){ $z += @(Get-ChildItem -LiteralPath $d -Recurse -Depth 3 -File -Filter *.zip -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)library.?pack' }) } }
$z=@($z | Sort-Object Length)
if($z.Count -eq 0){ Write-Host 'NON TROVO lo zip del Library pack (nome con "library pack") in Desktop, Download, Documenti, C:\ABTG_RISULTATI.' -ForegroundColor Red; return }
$desk=[Environment]::GetFolderPath('Desktop')
$out=Join-Path $desk 'UBS_LIBPACK_VOL_M15.zip'
$fatto=$false
foreach($f in $z){
  $za=[IO.Compression.ZipFile]::OpenRead($f.FullName)
  try {
    $ok=$true
    foreach($q in $SEL){ if(-not ($za.Entries | Where-Object { $_.FullName -eq $q[1] })){ $ok=$false; break } }
    if(-not $ok){ Write-Host ('  saltato (mancano set): ' + $f.FullName); continue }
    if(Test-Path -LiteralPath $out){ Remove-Item -LiteralPath $out -Force }
    $zo=[IO.Compression.ZipFile]::Open($out,[IO.Compression.ZipArchiveMode]::Create)
    try {
      foreach($q in $SEL){
        $e=$za.GetEntry($q[1]); $ms=New-Object IO.MemoryStream; $si=$e.Open(); try { $si.CopyTo($ms) } finally { $si.Dispose() }
        $b=$ms.ToArray(); $ms.Dispose()
        $sha=[BitConverter]::ToString([Security.Cryptography.SHA256]::Create().ComputeHash($b)).Replace('-','')
        if($sha -ne $q[2]){ throw ('SHA256 diverso per ' + $q[0] + ': ' + $sha + ' atteso ' + $q[2]) }
        $ne=$zo.CreateEntry(($q[0] + '.set'),[IO.Compression.CompressionLevel]::Optimal); $so=$ne.Open(); $so.Write($b,0,$b.Length); $so.Dispose()
        Write-Host ('  ok ' + $q[0] + '.set (' + $b.Length + ' byte)')
      }
    } finally { $zo.Dispose() }
    Write-Host ('Sorgente: ' + $f.FullName) -ForegroundColor Green
    $fatto=$true; break
  } finally { $za.Dispose() }
}
if(-not $fatto){ Write-Host 'Nessuno zip trovato contiene tutti i set attesi.' -ForegroundColor Red; return }
Write-Host ''
Write-Host ('File prodotto (uno solo): ' + $out + '  (' + (Get-Item -LiteralPath $out).Length + ' byte). NON serve allegarlo: lo usa la riga di test.') -ForegroundColor Green
Write-Host ('>>> ZIP DEI 15 SET PRONTO SUL DESKTOP: ' + $out + ' <<<') -ForegroundColor Black -BackgroundColor Yellow
Start-Process explorer.exe -ArgumentList ('/select,"' + $out + '"')
