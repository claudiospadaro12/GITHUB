#!/usr/bin/env python3
"""Riga corta che scarica (pin + sha256 + marcatore + parser) ZIP_RISULTATI_SPEZZATI.ps1 e lo esegue sul PC di backtest.
Uso: python3 gen_riga_zip_wim.py <PIN40> <SHA256 dello script>"""
import sys, os
PIN, SHA = sys.argv[1], sys.argv[2].upper()
os.chdir(os.path.dirname(os.path.abspath(__file__)))
t = ("& { if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('QUESTA RIGA GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. Qui la macchina si chiama: ' + $env:COMPUTERNAME + '. Sul VPS non si lancia.') }; $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; [Threading.Thread]::CurrentThread.CurrentCulture=[Globalization.CultureInfo]::InvariantCulture; "
 "$PIN='" + PIN + "'; if($PIN -notmatch '^[0-9a-f]{40}$' -or $PIN -match '^0{40}$'){ throw 'PIN non valido: non si lancia.' }; "
 "Write-Host 'BERSAGLIO: finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ. Spezza la cartella piu recente Desktop\\ABTG_RISULTATI\\ANNO80K_WIM_PACCHETTO_* in PIU zip piccoli (limite 10 MB ciascuno, per poterli caricare in chat) e li scrive in una cartella NUOVA Desktop\\ABTG_RISULTATI\\ZIP_DA_MANDARE_<data>, poi la apre e li EVIDENZIA tutti. LEGGE soltanto i file dei risultati: non li sposta, non li cancella, non li modifica. NON apre MT5, NON chiude processi, NON tocca il VPS, il reale 10105439, ne altri terminali. Oltre ai zip scrive solo la copia dello script in abtg_zip_wim nel profilo utente. Lanciala quando la riga dei test ha FINITO (o dopo averla fermata): mentre il tester lavora alcuni file sono in uso.' -ForegroundColor Yellow; "
 "$W=Join-Path $env:USERPROFILE 'abtg_zip_wim'; New-Item -ItemType Directory -Force -Path $W | Out-Null; $S=Join-Path $W 'ZIP_RISULTATI_SPEZZATI.ps1'; Remove-Item -LiteralPath $S -Force -ErrorAction SilentlyContinue; "
 "$u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/'+$PIN+'/backtest_pipeline/righe/ZIP_RISULTATI_SPEZZATI.ps1?cb='+[Guid]::NewGuid().ToString('N'); $wc=New-Object Net.WebClient; $b=$wc.DownloadData($u); $sha=New-Object Security.Cryptography.SHA256Managed; $h=[BitConverter]::ToString($sha.ComputeHash($b)).Replace('-',''); "
 "if($h -ne '" + SHA + "'){ Write-Host ('IMPRONTA DIVERSA (' + $h + '): copia vecchia o cache di GitHub. Mi fermo, non creo niente.') -ForegroundColor Red; return }; "
 "$t=[Text.Encoding]::ASCII.GetString($b); if(-not ($t | Select-String -SimpleMatch -Quiet -Pattern 'MARCATORE_ZIP_RISULTATI_SPEZZATI_v1')){ Write-Host 'Marcatore ASSENTE nello script scaricato: mi fermo.' -ForegroundColor Red; return }; "
 "Set-Content -LiteralPath $S -Value $t -Encoding ASCII -NoNewline; $h2=(Get-FileHash -LiteralPath $S -Algorithm SHA256).Hash; if($h2 -ne '" + SHA + "'){ Write-Host ('Il file scritto sul disco ha un altra impronta (' + $h2 + '): mi fermo.') -ForegroundColor Red; return }; "
 "$pe=$null; $pt=$null; [void][System.Management.Automation.Language.Parser]::ParseFile($S,[ref]$pt,[ref]$pe); if($null -ne $pe -and @($pe).Count -gt 0){ Write-Host ('SINTASSI: lo script NON compila su questo PowerShell (' + @($pe).Count + ' errori). Il primo: ' + @($pe)[0].Message + ' (riga ' + @($pe)[0].Extent.StartLineNumber + '). Non lo lancio.') -ForegroundColor Red; return }; "
 "Write-Host ('pc  : ' + $env:COMPUTERNAME) -ForegroundColor Green; Write-Host ('pin : ' + $PIN) -ForegroundColor Green; Write-Host ('impronta script: ' + $h.Substring(0,8) + ' OK (ZIP_RISULTATI_SPEZZATI.ps1 v1), marcatore OK, sintassi 0 errori') -ForegroundColor Green; "
 "$ErrorActionPreference='Continue'; & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $S; $rc=$LASTEXITCODE; Write-Host ('ZIP SPEZZATI rc ' + $rc + '   (0 = zip creati e cartella aperta; 1 = non creati: il messaggio rosso qui sopra dice perche)') -ForegroundColor Cyan }")
assert all(ord(c) < 128 for c in t)
open('righe/RIGA_ZIP_RISULTATI_WIM.txt', 'w', encoding='ascii').write(t)
print(len(t))
