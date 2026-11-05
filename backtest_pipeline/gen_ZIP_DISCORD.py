#!/usr/bin/env python3
"""Genera righe/ZIP_DISCORD_SPEZZATI.ps1 da righe/ZIP_RISULTATI_SPEZZATI.ps1: stessa spezzatura in zip piccoli, ma la sorgente e Download\\DISCORD_* (file e cartelle degli ultimi 8 giorni)."""
import os, hashlib
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = open('righe/ZIP_RISULTATI_SPEZZATI.ps1', encoding='ascii').read()
i = t.index("$dsk = [Environment]::GetFolderPath('Desktop')")
j = t.index("# ordine: prima i file essenziali")
head = """# ZIP_DISCORD_SPEZZATI.ps1 -- MARCATORE_ZIP_DISCORD_SPEZZATI_v1
# Raccoglie i file e le cartelle chiamati DISCORD_* che stanno in Download (ultimi 8 giorni: il riassunto della scansione settimanale di Discord e gli allegati scaricati a mano da Claudio)
# e li spezza in PIU zip piccoli (limite 10 MB ciascuno) in una cartella NUOVA Desktop\\ABTG_RISULTATI\\ZIP_DISCORD_<data>, poi la apre e li EVIDENZIA tutti.
# NON sposta, NON cancella e NON modifica i file di Download. ESCLUDE dai zip i file eseguibili (.exe .bat .cmd .scr .js .vbs .msi .lnk .ps1 .com .jar .dll) e li elenca nell'indice.
# NON scarica niente, NON apre MT5, NON chiude processi. Il registro dell'ultimo giro sta in %USERPROFILE%\\abtg_zip_discord\\ultimo_giro.txt. Gira SOLO sul PC DESKTOP-H4D7CAJ. ASCII puro.
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
"""
t = t[:i] + head.split("$dsk = [Environment]::GetFolderPath('Desktop')")[0] + "$dsk = [Environment]::GetFolderPath('Desktop')" + head.split("$dsk = [Environment]::GetFolderPath('Desktop')")[1] + t[j:]
# intestazione e parametri originali: rimossi
k = t.index("$dsk = [Environment]::GetFolderPath('Desktop')")
# la parte prima del $dsk nel head e gia nel head: ricostruisco pulito
t2 = head + t[t.index("# ordine: prima i file essenziali"):]
t2 = t2.replace("[void]$ind.Add('INDICE DEI ZIP (' + $srcNome + ',", "[void]$ind.Add('INDICE DEI ZIP DISCORD (' + $srcNome + ',")
assert t2.count("exit 0") >= 1
last = t2.rindex("exit 0")
t2 = t2[:last] + "if ($esclusi.Count -gt 0) { Add-Content -LiteralPath (Join-Path $out '00_INDICE.txt') -Value ('ESCLUSI (eseguibili): ' + (($esclusi | ForEach-Object { $_.Name }) -join '; ')) -Encoding ASCII }\ntry { Stop-Transcript | Out-Null } catch { }\n" + t2[last:]
assert all(ord(c) < 128 for c in t2)
open('righe/ZIP_DISCORD_SPEZZATI.ps1', 'w', encoding='ascii', newline='').write(t2)
print('ok', len(t2), hashlib.sha256(t2.encode('ascii')).hexdigest().upper())
