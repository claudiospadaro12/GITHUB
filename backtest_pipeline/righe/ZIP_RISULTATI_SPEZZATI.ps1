# ZIP_RISULTATI_SPEZZATI.ps1 -- MARCATORE_ZIP_RISULTATI_SPEZZATI_v1
# Spezza una cartella di risultati del tester (Desktop\ABTG_RISULTATI\<cartella>) in PIU zip piccoli, ognuno sotto un limite di dimensione (default 10 MB),
# cosi si possono caricare in chat senza che il file sia troppo grande. Poi apre Esplora risorse sulla cartella dei zip e li EVIDENZIA tutti.
# Gira SOLO sul PC di backtest DESKTOP-H4D7CAJ. Legge i file dei risultati (NON li sposta, NON li cancella, NON li modifica). Scrive SOLO i nuovi zip in una cartella NUOVA
# Desktop\ABTG_RISULTATI\ZIP_DA_MANDARE_<data>. NON apre MT5, NON chiude processi, NON scarica niente. ASCII puro.
param(
  [string]$Cartella = '',
  [int]$MaxMB = 10
)
$ErrorActionPreference = 'Continue'
$IC = [Globalization.CultureInfo]::InvariantCulture
[Threading.Thread]::CurrentThread.CurrentCulture = $IC
if ($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ') { Write-Host ('QUESTO SCRIPT GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME) -ForegroundColor Red; exit 1 }
if ($MaxMB -lt 2 -or $MaxMB -gt 40) { Write-Host '-MaxMB deve stare fra 2 e 40.' -ForegroundColor Red; exit 1 }
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$dsk = [Environment]::GetFolderPath('Desktop')
$rad = Join-Path $dsk 'ABTG_RISULTATI'
if (-not (Test-Path -LiteralPath $rad)) { Write-Host ('NON ESISTE ' + $rad + ': nessun risultato da zippare.') -ForegroundColor Red; exit 1 }
if ($Cartella -eq '') {
  $c = @(Get-ChildItem -LiteralPath $rad -Directory -ErrorAction SilentlyContinue | Where-Object { ($_.Name -like 'ANNO80K_WIM_PACCHETTO_*') -or ($_.Name -like 'ANNO80K_BTC_FTMO_*') -or ($_.Name -like 'ANNO80K_REAPER_FAKEOUT_*') } | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
  if ($c.Count -lt 1) { Write-Host ('Nessuna cartella ANNO80K_WIM_PACCHETTO_* o ANNO80K_BTC_FTMO_* o ANNO80K_REAPER_FAKEOUT_* sotto ' + $rad + '. Passa -Cartella con il percorso.') -ForegroundColor Red; exit 1 }
  $src = $c[0].FullName
} else { $src = [IO.Path]::GetFullPath($Cartella).TrimEnd('\') }
if (-not $src.StartsWith($rad + '\', [StringComparison]::OrdinalIgnoreCase)) { Write-Host ('La cartella ' + $src + ' NON sta sotto ' + $rad + ': non la tocco.') -ForegroundColor Red; exit 1 }
if (-not (Test-Path -LiteralPath $src)) { Write-Host ('NON ESISTE ' + $src) -ForegroundColor Red; exit 1 }
$srcNome = Split-Path -Leaf $src
Write-Host ('Cartella dei risultati: ' + $src) -ForegroundColor Cyan
$limite = [int64]$MaxMB * 1024 * 1024
$stamp = (Get-Date).ToString('yyyyMMdd_HHmmss', $IC)
$out = Join-Path $rad ('ZIP_DA_MANDARE_' + $stamp)
New-Item -ItemType Directory -Force -Path $out | Out-Null
$tutti = @(Get-ChildItem -LiteralPath $src -Recurse -File -ErrorAction SilentlyContinue)
# v1.1: gli zip DENTRO le cartelle dei risultati sono la copia che il tester fa dello stesso contenuto (e Windows li tratta come cartelle, non si copiano): li salto, altrimenti ogni cosa pesa due volte
$lista = @($tutti | Where-Object { $_.Extension -ne '.zip' })
$nZipInterni = $tutti.Count - $lista.Count
if ($nZipInterni -gt 0) { Write-Host ('Zip gia presenti DENTRO la cartella e saltati (duplicano il contenuto): ' + $nZipInterni) -ForegroundColor Yellow }
if ($lista.Count -lt 1) { Write-Host 'La cartella dei risultati e vuota: niente da zippare.' -ForegroundColor Red; exit 1 }
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
[void]$ind.Add('INDICE DEI ZIP (' + $srcNome + ', limite ' + $MaxMB + ' MB, creato ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $IC) + ')')
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
exit 0
