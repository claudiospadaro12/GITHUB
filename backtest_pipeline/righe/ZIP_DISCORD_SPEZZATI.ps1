# ZIP_DISCORD_SPEZZATI.ps1 -- MARCATORE_ZIP_DISCORD_SPEZZATI_v1
# Raccoglie i file e le cartelle chiamati DISCORD_* che stanno in Download (ultimi 8 giorni: il riassunto della scansione settimanale di Discord e gli allegati scaricati a mano da Claudio)
# e li spezza in PIU zip piccoli (limite 10 MB ciascuno) in una cartella NUOVA Desktop\ABTG_RISULTATI\ZIP_DISCORD_<data>, poi la apre e li EVIDENZIA tutti.
# NON sposta, NON cancella e NON modifica i file di Download. ESCLUDE dai zip i file eseguibili (.exe .bat .cmd .scr .js .vbs .msi .lnk .ps1 .com .jar .dll) e li elenca nell'indice.
# NON scarica niente, NON apre MT5, NON chiude processi. Il registro dell'ultimo giro sta in %USERPROFILE%\abtg_zip_discord\ultimo_giro.txt. Gira SOLO sul PC DESKTOP-H4D7CAJ. ASCII puro.
param(
  [int]$MaxMB = 10,
  [int]$GiorniIndietro = 8
)
$ErrorActionPreference = 'Continue'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture = $IC
if ($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ') { Write-Host ('QUESTO SCRIPT GIRA SOLO SUL PC DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME) -ForegroundColor Red; exit 1 }
if ($MaxMB -lt 2 -or $MaxMB -gt 40) { Write-Host '-MaxMB deve stare fra 2 e 40.' -ForegroundColor Red; exit 1 }
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$LogDir = Join-Path $env:USERPROFILE 'abtg_zip_discord'
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
try { Start-Transcript -Path (Join-Path $LogDir 'ultimo_giro.txt') -Force | Out-Null } catch { }
$dsk = [Environment]::GetFolderPath('Desktop')
$rad = Join-Path $dsk 'ABTG_RISULTATI'
New-Item -ItemType Directory -Force -Path $rad | Out-Null
$src = Join-Path $env:USERPROFILE 'Downloads'
if (-not (Test-Path -LiteralPath $src)) { Write-Host ('NON ESISTE ' + $src) -ForegroundColor Red; try { Stop-Transcript | Out-Null } catch { }; exit 1 }
$srcNome = 'Download'
$limite = [int64]$MaxMB * 1024 * 1024
$stamp = (Get-Date).ToString('yyyyMMdd_HHmmss', $IC)
$da = (Get-Date).AddDays(-$GiorniIndietro)
$voci0 = @(Get-ChildItem -LiteralPath $src -Force -ErrorAction SilentlyContinue | Where-Object { ($_.Name -like 'DISCORD_*') -and ($_.LastWriteTime -gt $da) })
if ($voci0.Count -lt 1) { Write-Host ('Nessun file o cartella DISCORD_* in ' + $src + ' degli ultimi ' + $GiorniIndietro + ' giorni: niente da zippare.') -ForegroundColor Yellow; try { Stop-Transcript | Out-Null } catch { }; exit 0 }
$tutti = @()
foreach ($it in $voci0) { if ($it.PSIsContainer) { $tutti += @(Get-ChildItem -LiteralPath $it.FullName -Recurse -File -Force -ErrorAction SilentlyContinue) } else { $tutti += @($it) } }
$peric = @('.exe', '.bat', '.cmd', '.scr', '.js', '.vbs', '.msi', '.lnk', '.ps1', '.com', '.jar', '.dll')
$lista = @($tutti | Where-Object { $peric -notcontains $_.Extension.ToLower() })
$esclusi = @($tutti | Where-Object { $peric -contains $_.Extension.ToLower() })
if ($esclusi.Count -gt 0) { Write-Host ('File eseguibili ESCLUSI dai zip (' + $esclusi.Count + '): ' + (($esclusi | Select-Object -First 10 | ForEach-Object { $_.Name }) -join '; ')) -ForegroundColor Yellow }
if ($lista.Count -lt 1) { Write-Host 'Nessun file da zippare (solo eseguibili o cartelle vuote).' -ForegroundColor Yellow; try { Stop-Transcript | Out-Null } catch { }; exit 0 }
$out = Join-Path $rad ('ZIP_DISCORD_' + $stamp)
New-Item -ItemType Directory -Force -Path $out | Out-Null
$tot = 0; foreach ($f in $lista) { $tot += $f.Length }
Write-Host ('File trovati: ' + $lista.Count + ', ' + [math]::Round($tot / 1MB, 1) + ' MB non compressi. Limite per zip: ' + $MaxMB + ' MB.') -ForegroundColor Cyan
# ordine: prima i file essenziali (referto, manifest, ini, report), poi i giornali (log): cosi i primi zip bastano per leggere i numeri
$voci = New-Object System.Collections.ArrayList
foreach ($f in $lista) {
  $rel = $srcNome + '\' + $f.FullName.Substring($src.Length + 1)
  $cl = 0
  if ($rel -match '\\log\\') { $cl = 1 }
  [void]$voci.Add([pscustomobject]@{ Full = $f.FullName; Rel = $rel; Len = $f.Length; Cl = $cl })
}
$voci = @($voci | Sort-Object Cl, Rel)
function FaiZip($gruppo, $dest) {
  if (Test-Path -LiteralPath $dest) { Remove-Item -LiteralPath $dest -Force }
  $zip = [IO.Compression.ZipFile]::Open($dest, [IO.Compression.ZipArchiveMode]::Create)
  $saltati = 0
  try {
    foreach ($v in $gruppo) {
      try { [void][IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $v.Full, $v.Rel.Replace('\', '/'), [IO.Compression.CompressionLevel]::Optimal) } catch { $saltati = $saltati + 1; Write-Host ('   file NON letto (in uso?): ' + $v.Rel) -ForegroundColor Yellow }
    }
  } finally { $zip.Dispose() }
  return $saltati
}
$script:nZip = 0
$script:fatti = New-Object System.Collections.ArrayList
$script:oltre = 0
function Impacchetta($gruppo) {
  if ($gruppo.Count -lt 1) { return }
  $script:nZip = $script:nZip + 1
  $nome = 'WIM_' + $script:nZip.ToString('00') + '.zip'
  $dest = Join-Path $out $nome
  $sk = FaiZip $gruppo $dest
  $dim = (Get-Item -LiteralPath $dest).Length
  if ($dim -gt $limite -and $gruppo.Count -gt 1) {
    # troppo grande: lo rifaccio in due meta
    Remove-Item -LiteralPath $dest -Force
    $script:nZip = $script:nZip - 1
    $m = [int][math]::Floor($gruppo.Count / 2)
    Impacchetta @($gruppo[0..($m - 1)])
    Impacchetta @($gruppo[$m..($gruppo.Count - 1)])
    return
  }
  if ($dim -gt $limite) { $script:oltre = $script:oltre + 1; Write-Host ('   ATTENZIONE: ' + $nome + ' ha UN solo file e pesa ' + [math]::Round($dim / 1MB, 1) + ' MB, oltre il limite: non si puo spezzare ancora.') -ForegroundColor Red }
  $h = (Get-FileHash -LiteralPath $dest -Algorithm SHA256).Hash
  [void]$script:fatti.Add([pscustomobject]@{ Nome = $nome; Dim = $dim; File = $gruppo.Count; Sha = $h; Saltati = $sk })
  Write-Host ('   ' + $nome + '  ' + [math]::Round($dim / 1MB, 2) + ' MB  ' + $gruppo.Count + ' file') -ForegroundColor Green
}
# impacchettamento goloso con stima 0.25 della dimensione per i testi (il controllo vero e fatto dopo, sul zip scritto)
$cur = New-Object System.Collections.ArrayList
$stima = 0.0
$soglia = [double]$limite * 0.8
foreach ($v in $voci) {
  $p = [double]$v.Len * 0.25
  if ($v.Rel -match '\.(png|zip|gif|jpg)$') { $p = [double]$v.Len }
  if (($stima + $p) -gt $soglia -and $cur.Count -gt 0) { Impacchetta @($cur.ToArray()); $cur = New-Object System.Collections.ArrayList; $stima = 0.0 }
  [void]$cur.Add($v); $stima += $p
}
if ($cur.Count -gt 0) { Impacchetta @($cur.ToArray()) }
$ind = New-Object System.Collections.ArrayList
[void]$ind.Add('INDICE DEI ZIP DISCORD (' + $srcNome + ', limite ' + $MaxMB + ' MB, creato ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $IC) + ')')
foreach ($z in $script:fatti) { [void]$ind.Add($z.Nome + ';' + $z.Dim + ' byte;' + $z.File + ' file;SHA256 ' + $z.Sha + ';file non letti ' + $z.Saltati) }
Set-Content -LiteralPath (Join-Path $out '00_INDICE.txt') -Value $ind -Encoding ASCII
Write-Host ''
Write-Host ('ZIP CREATI: ' + $script:fatti.Count + ' (+ 00_INDICE.txt) in ' + $out) -ForegroundColor Green
if ($script:oltre -gt 0) { Write-Host ('ATTENZIONE: ' + $script:oltre + ' zip sono oltre il limite perche contengono un solo file molto grande.') -ForegroundColor Red }
Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow
Write-Host '###   >>>   QUESTI SONO GLI ZIP DA MANDARE A CLAUDE   <<<   ###' -ForegroundColor Black -BackgroundColor Yellow
Write-Host ('###   cartella: ' + $out) -ForegroundColor Black -BackgroundColor Yellow
Write-Host '#########################################################' -ForegroundColor Black -BackgroundColor Yellow
# apre la cartella e SELEZIONA tutti gli zip (Shell.Application SelectItem); se non riesce, evidenzia almeno il primo
$ok = $false
try {
  $sh = New-Object -ComObject Shell.Application
  $sh.Open($out)
  Start-Sleep -Seconds 3
  $url = 'file:///' + $out.Replace('\', '/').Replace(' ', '%20')
  $w = $null
  foreach ($x in @($sh.Windows())) { try { if ($x.LocationURL -and ([Uri]::UnescapeDataString($x.LocationURL).TrimEnd('/') -ieq [Uri]::UnescapeDataString($url).TrimEnd('/'))) { $w = $x } } catch { } }
  if ($null -ne $w) {
    $primo = $true
    foreach ($z in $script:fatti) {
      $it = $w.Document.Folder.ParseName($z.Nome)
      if ($null -ne $it) { if ($primo) { $w.Document.SelectItem($it, 17); $primo = $false } else { $w.Document.SelectItem($it, 1) } }
    }
    $ok = (-not $primo)
  }
} catch { $ok = $false }
if (-not $ok -and $script:fatti.Count -gt 0) {
  try { Start-Process -FilePath 'explorer.exe' -ArgumentList ('/select,' + [char]34 + (Join-Path $out $script:fatti[0].Nome) + [char]34) } catch { }
  Write-Host 'Non sono riuscito a selezionarli tutti: ho evidenziato il primo. Nella cartella premi Ctrl+A per selezionarli tutti.' -ForegroundColor Yellow
}
if ($esclusi.Count -gt 0) { Add-Content -LiteralPath (Join-Path $out '00_INDICE.txt') -Value ('ESCLUSI (eseguibili): ' + (($esclusi | ForEach-Object { $_.Name }) -join '; ')) -Encoding ASCII }
try { Stop-Transcript | Out-Null } catch { }
exit 0
