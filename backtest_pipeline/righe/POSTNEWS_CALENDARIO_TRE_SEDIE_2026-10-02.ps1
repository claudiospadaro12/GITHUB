# =====================================================================
#  MARCATORE_POSTNEWS_CALENDARIO_TRE_SEDIE_v1
#
#  Crea il calendario DEDICATO alle tre sedie PostNews del DEMO piccolo
#  50503392 (C:\Program Files\BCM Markets MT5 Terminal, profilo ORO):
#    771201 ECB  EURJPY   (legge title 'ECB',               valuta EUR)
#    771202 FOMC EURUSD   (legge title 'FOMC',              valuta USD)
#    771203 NFP  USDJPY   (legge title 'Unemployment Rate', valuta USD)
#
#  SCRIVE: UN solo file dati, NUOVO e di nessun altro:
#    %APPDATA%\MetaQuotes\Terminal\Common\Files\abtg_postnews_calendario.csv
#  (+ la sua copia .bak se esisteva gia' e cambia + un referto .txt sul
#  Desktop). Sei eventi, date verificate su fonti pubbliche:
#    FOMC 2026-10-28 e 2026-12-09 | ECB 2026-10-29 e 2026-12-17
#    NFP  2026-11-06 e 2026-12-04
#
#  PERCHE' UN FILE NUOVO e non abtg_news.csv: abtg_news.csv e' letto da
#  altre 15 sedie (BreakingBand, PTE, ORB, Dow/Nasdaq/DAX Apertura...) fra
#  cui sedie sul conto REALE. Aggiungere li' FOMC/ECB cambierebbe il
#  comportamento di quelle sedie: non e' compito di questa riga.
#
#  NON FA NIENTE DA SOLA: le tre sedie leggono il file nuovo solo dopo
#  che Claudio cambia InpNewsFile con F7 sul grafico (a mano, vedi
#  report/POSTNEWS_TRE_SEDIE_2026-10-02.md). L'EA ricarica il calendario
#  da solo a ogni cambio giorno.
#
#  NON TOCCA: terminali, processi, EA, preset, .chr (solo LETTI), Guardian,
#  abtg_news.csv, abtg_news_live_2026-09-04.csv, nessun'altra sedia.
#
#  ASCII PURO (PS 5.1 legge i .ps1 come ANSI). Nessuna rete.
# =====================================================================
param([string]$Pin='')
if($env:COMPUTERNAME -ne 'VMI3047753'){ Write-Host ('VIETATO: questo script gira SOLO sul VPS VMI3047753 (NON sul PC di backtest DESKTOP-H4D7CAJ). Macchina attuale: ' + $env:COMPUTERNAME + '. Niente letto, niente scritto.') -ForegroundColor Red; exit 2 }
$ErrorActionPreference='Stop'
$IC=[Globalization.CultureInfo]::InvariantCulture
$L=New-Object System.Collections.ArrayList
$say={ param($s,$c) if(-not $c){ $c='Gray' }; Write-Host $s -ForegroundColor $c; [void]$L.Add([string]$s) }
$stamp=(Get-Date).ToString('yyyy-MM-dd_HHmmss',$IC)
$dk=[Environment]::GetFolderPath('Desktop'); if(-not $dk){ $dk=Join-Path $env:USERPROFILE 'Desktop' }
$rep=Join-Path $dk ('POSTNEWS_CALENDARIO_' + $stamp + '.txt')
$rd={ param($p) $b=$null; try { $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite); $b=New-Object byte[] $fs.Length; [void]$fs.Read($b,0,$b.Length); $fs.Close() } catch { return '' }; if($null -eq $b -or $b.Length -lt 2){ return '' }; if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }; $z=0; $n=[math]::Min(400,$b.Length); for($i=1;$i -lt $n;$i+=2){ if($b[$i] -eq 0){ $z++ } }; if($z -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }; return [Text.Encoding]::UTF8.GetString($b) }
$fld={ param($t,$k) $m=[regex]::Match($t,'(?m)^[ \t]*' + [regex]::Escape($k) + '[ \t]*=[ \t]*([^\r\n]*)'); if($m.Success){ $m.Groups[1].Value.Trim() } else { '' } }
$rc=0
try {
  & $say 'MARCATORE_POSTNEWS_CALENDARIO_TRE_SEDIE_v1 (script)' 'DarkGray'
  & $say 'BERSAGLIO: finestra PowerShell sul VPS VMI3047753. Scrive UN solo file dati NUOVO: %APPDATA%\MetaQuotes\Terminal\Common\Files\abtg_postnews_calendario.csv (+ referto .txt sul Desktop). Lo leggeranno SOLO le tre sedie PostNews 771201 / 771202 / 771203 del DEMO piccolo 50503392, e solo dopo il tuo F7 a mano.' 'Yellow'
  & $say 'NON TOCCA: terminali, processi, EA, preset, .chr, Guardian, abtg_news.csv, abtg_news_live_2026-09-04.csv. NON TOCCATI per nome: FTMO trial 1514806751 (C:\FTMO), REALE 10105439 (C:\BCM_Reale), piccolo 50503392 (solo LETTO), 100k 50504263 (... -V3), manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill. Nessuna rete.' 'Yellow'
  $root=Join-Path (Join-Path $env:APPDATA 'MetaQuotes') 'Terminal'; $com=Join-Path (Join-Path $root 'Common') 'Files'
  if(-not (Test-Path -LiteralPath $com -PathType Container)){ throw ('cartella Common\Files NON trovata: ' + $com + '. Niente scritto.') }; & $say ('Common\Files trovata: ' + $com) 'Green'
  $tgt='abtg_postnews_calendario.csv'; $f=Join-Path $com $tgt
  $hdr='Data Ora;Impatto;Valuta;Titolo'
  $rows=@('2026.10.28 18:00;High;USD;FOMC Statement / Federal Funds Rate','2026.10.29 13:15;High;EUR;ECB Main Refinancing Rate','2026.11.06 13:30;High;USD;Unemployment Rate','2026.12.04 13:30;High;USD;Unemployment Rate','2026.12.09 19:00;High;USD;FOMC Statement / Federal Funds Rate','2026.12.17 13:15;High;EUR;ECB Main Refinancing Rate')
  & $say '--- 1. SOLA LETTURA: le tre sedie sul piccolo 50503392 (cartella dati 215D85D767A1C39E22D242C8114BF9F5) ---' 'White'
  $pdd=Join-Path $root '215D85D767A1C39E22D242C8114BF9F5'; $org=((& $rd (Join-Path $pdd 'origin.txt')) -replace '[^\x20-\x7E]','').Trim(); & $say ('origin.txt: ' + $org) 'Gray'; if($org -notlike '*BCM Markets MT5 Terminal' ){ throw ('la cartella dati 215D85D7... non risulta del terminale C:\Program Files\BCM Markets MT5 Terminal (origin: ' + $org + '). Niente scritto.') }
  $pl=& $fld (& $rd (Join-Path (Join-Path $pdd 'config') 'common.ini')) 'ProfileLast'; if(-not $pl){ throw 'profilo attivo del piccolo NON determinato. Niente scritto.' }; & $say ('profilo attivo del piccolo: ' + $pl) 'Gray'
  $pdir=Join-Path (Join-Path (Join-Path (Join-Path $pdd 'MQL5') 'Profiles') 'Charts') $pl
  foreach($mg in @('771201','771202','771203')){ $hit=@(Get-ChildItem -LiteralPath $pdir -Filter '*.chr' -File -ErrorAction SilentlyContinue | Where-Object { (& $fld (& $rd $_.FullName) 'InpMagic') -eq $mg }); if($hit.Count -ne 1){ throw ('nel profilo attivo ' + $pl + ' del piccolo trovo ' + $hit.Count + ' grafici con InpMagic=' + $mg + ' (atteso 1). Niente scritto.') }; $ct=& $rd $hit[0].FullName; & $say ('   ' + $mg + ' [' + $hit[0].Name + ']: InpNewsFile=' + (& $fld $ct 'InpNewsFile') + ' | Titolo=' + (& $fld $ct 'InpNewsTitleMatch') + ' | Valuta=' + (& $fld $ct 'InpNewsCurrencies') + ' | Azione=' + (& $fld $ct 'InpActionHour') + ':' + (& $fld $ct 'InpActionMin') + ' | Scadenza=' + (& $fld $ct 'InpExpiryHour') + ':' + (& $fld $ct 'InpExpiryMin') + ' | Rischio=' + (& $fld $ct 'InpRiskPercent') + ' (NON toccato)') 'Gray' }
  & $say '--- 2. SOLA LETTURA: il nome nuovo non deve essere gia di nessuno ---' 'White'; $gia=0
  foreach($d in @(Get-ChildItem -LiteralPath $root -Directory | Where-Object { $_.Name -ne 'Common' })){ $cr=Join-Path (Join-Path (Join-Path $d.FullName 'MQL5') 'Profiles') 'Charts'; if(-not (Test-Path -LiteralPath $cr)){ continue }; foreach($c in @(Get-ChildItem -LiteralPath $cr -Recurse -Filter '*.chr' -File -ErrorAction SilentlyContinue)){ if((& $rd $c.FullName).IndexOf($tgt,[StringComparison]::OrdinalIgnoreCase) -ge 0){ $gia++; & $say ('   NOMINATO GIA da: ' + $c.FullName) 'Red' } } }
  if($gia -gt 0){ throw ('' + $gia + ' grafici nominano gia ' + $tgt + ': nome non libero. Niente scritto.') }; & $say 'OK: nessun grafico di nessun terminale nomina quel file (e un nome nuovo).' 'Green'
  & $say '--- 3. IL FILE ---' 'White'
  $new=$hdr + "`r`n" + ($rows -join "`r`n") + "`r`n"; $nb=[Text.Encoding]::ASCII.GetBytes($new)
  $esiste=Test-Path -LiteralPath $f -PathType Leaf
  if($esiste){ $ob=[IO.File]::ReadAllBytes($f); if([Convert]::ToBase64String($ob) -eq [Convert]::ToBase64String($nb)){ & $say 'NIENTE DA FARE: il file c e gia ed e identico a quello atteso (riga idempotente).' 'Green' } else { $bk=$f + '.PRIMA_' + $stamp + '.bak'; Copy-Item -LiteralPath $f -Destination $bk; if((Get-FileHash -LiteralPath $bk -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $f -Algorithm SHA256).Hash){ throw 'backup NON identico all originale. Niente scritto.' }; & $say ('il file esisteva ed era diverso: backup ' + $bk) 'DarkYellow'; [IO.File]::WriteAllBytes($f,[byte[]]$nb); & $say 'file riscritto.' 'Green' } }
  else { [IO.File]::WriteAllBytes($f,[byte[]]$nb); & $say 'CREATO il file (ASCII, CRLF, senza BOM).' 'Green' }
  $ab=[IO.File]::ReadAllBytes($f); if([Convert]::ToBase64String($ab) -ne [Convert]::ToBase64String($nb)){ throw 'il file riletto NON coincide con quello scritto. Mandami questo output.' }
  & $say ('DOPO: ' + $ab.Length + ' byte | SHA256 ' + (Get-FileHash -LiteralPath $f -Algorithm SHA256).Hash) 'Cyan'
  $at=[Text.Encoding]::ASCII.GetString($ab); $tot=0; $fo=0; $ec=0; $nf=0; foreach($x in @($at -split "`r?`n")){ $q=$x.Trim().Split(';'); if($q.Count -lt 4){ continue }; if($q[0].Trim() -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}$'){ continue }; $tot++; & $say ('      | ' + $x.Trim()) 'Gray'; if($q[1].Trim() -eq 'High' -and $q[2].Trim() -eq 'USD' -and $q[3].Contains('FOMC')){ $fo++ }; if($q[1].Trim() -eq 'High' -and $q[2].Trim() -eq 'EUR' -and $q[3].Contains('ECB')){ $ec++ }; if($q[1].Trim() -eq 'High' -and $q[2].Trim() -eq 'USD' -and $q[3].Contains('Unemployment Rate')){ $nf++ } }
  & $say ('lettura come l EA: righe-evento ' + $tot + ' | UTILI 771202 (FOMC/USD): ' + $fo + ' | 771201 (ECB/EUR): ' + $ec + ' | 771203 (Unemployment Rate/USD): ' + $nf) $(if($tot -eq 6 -and $fo -eq 2 -and $ec -eq 2 -and $nf -eq 2){'Green'}else{'Red'}); if(-not ($tot -eq 6 -and $fo -eq 2 -and $ec -eq 2 -and $nf -eq 2)){ throw 'conteggio righe/utili diverso dall atteso (6 / 2 / 2 / 2). Mandami questo output.' }
  & $say 'FATTO LATO FILE. Le tre sedie NON lo leggono ancora: serve il tuo F7 sui tre grafici del piccolo 50503392 (vedi report/POSTNEWS_TRE_SEDIE_2026-10-02.md). Prima del tuo F7 restano mute, come ora.' 'Yellow'
  & $say 'Terminali aperti adesso (SOLA LETTURA, per riconoscere la finestra senza indovinare):' 'White'; $tp=(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 250).Trim(); & $say $tp 'Gray'
} catch { $rc=1; & $say ('FERMO: ' + $_.Exception.Message) 'Red' } finally { try { if($Pin){ [void]$L.Insert(0,('pin dello script: ' + $Pin)) }; [IO.File]::WriteAllLines($rep,[string[]]$L.ToArray(),(New-Object Text.ASCIIEncoding)); Write-Host ('Referto sul Desktop: ' + $rep) -ForegroundColor Cyan } catch { Write-Host ('referto sul Desktop NON scritto: ' + $_.Exception.Message) -ForegroundColor Red } }
exit $rc
