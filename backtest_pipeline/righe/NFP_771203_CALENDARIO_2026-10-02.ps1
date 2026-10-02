# =====================================================================
#  MARCATORE_NFP_771203_CALENDARIO_v1
#
#  NFP di venerdi 02/10/2026: riarma il calendario della sedia PostNews
#  USDJPY 771203 sul DEMO piccolo 50503392 (C:\Program Files\BCM Markets
#  MT5 Terminal, profilo ORO, chart42). Gira SOLO sul VPS VMI3047753 e
#  SOLO il 2026-10-02 (data locale).
#
#  SCRIVE: un solo file dati,
#    %APPDATA%\MetaQuotes\Terminal\Common\Files\abtg_news_live_2026-09-04.csv
#  (quello che la 771203 legge DAVVERO: InpNewsFile nel suo .chr, sonda
#  CODA_08 del 02/10 03:30), aggiungendo in coda, se mancano, le righe
#    2026.10.02 12:30;High;USD;Unemployment Rate
#    2026.10.02 12:30;High;USD;Nonfarm Payrolls
#  con lo stesso BOM e la stessa fine riga del file. Prima: copia .bak
#  accanto. Se il file non c e, lo CREA (header + 2 righe) e lo dice.
#  Piu' un referto .txt sul Desktop.
#
#  SI FERMA PRIMA DI SCRIVERE se: macchina diversa; data diversa; Common
#  assente; la cartella dati 215D85D7... non e' del piccolo; il profilo
#  attivo non ha UNA sola 771203; la 771203 legge un altro file / altro
#  titolo / altra valuta; un altro grafico in un profilo ATTIVO di
#  QUALUNQUE terminale nomina lo stesso file; il file ha byte non ASCII
#  o una prima riga diversa dall header.
#
#  NON TOCCA: terminali, processi, EA, preset, .chr (solo LETTI), Guardian.
#  NON rilegge l EA: il calendario di oggi e' gia in memoria (vuoto); la
#  reinizializzazione (F7 -> OK sul grafico) resta A MANO.
#  Common\Files e' condivisa da tutti i terminali MT5 dell utente.
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
$rep=Join-Path $dk ('NFP_771203_CALENDARIO_' + $stamp + '.txt')
$rd={ param($p) $b=$null; try { $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite); $b=New-Object byte[] $fs.Length; [void]$fs.Read($b,0,$b.Length); $fs.Close() } catch { return '' }; if($null -eq $b -or $b.Length -lt 2){ return '' }; if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }; $z=0; $n=[math]::Min(400,$b.Length); for($i=1;$i -lt $n;$i+=2){ if($b[$i] -eq 0){ $z++ } }; if($z -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }; return [Text.Encoding]::UTF8.GetString($b) }
$fld={ param($t,$k) $m=[regex]::Match($t,'(?m)^[ \t]*' + [regex]::Escape($k) + '[ \t]*=[ \t]*([^\r\n]*)'); if($m.Success){ $m.Groups[1].Value.Trim() } else { '' } }
$show={ param($p,$tag) $bb=[IO.File]::ReadAllBytes($p); $tx=[Text.Encoding]::ASCII.GetString($bb); $ls=@($tx -split "`r?`n" | Where-Object { $_.Trim() -ne '' }); & $say ($tag + ': ' + $bb.Length + ' byte | righe non vuote ' + $ls.Count + ' | SHA256 ' + (Get-FileHash -LiteralPath $p -Algorithm SHA256).Hash) 'Cyan'; foreach($x in @($ls | Select-Object -Last 5)){ & $say ('      | ' + $x) 'Gray' } }
$rc=0
try {
  & $say 'MARCATORE_NFP_771203_CALENDARIO_v1 (script)' 'DarkGray'
  & $say 'BERSAGLIO: finestra PowerShell sul VPS VMI3047753. Scrive UN solo file dati: %APPDATA%\MetaQuotes\Terminal\Common\Files\abtg_news_live_2026-09-04.csv (+ la sua copia .bak accanto + un referto .txt sul Desktop). Common\Files e CONDIVISA da TUTTI i terminali MT5 di questo utente sul VPS: la riga verifica (sola lettura dei .chr) che quel nome lo legga SOLO la sedia 771203 del piccolo 50503392.' 'Yellow'
  & $say 'NON TOCCA: terminali, processi, EA, preset, .chr, Guardian. NON TOCCATI per nome: FTMO trial 1514806751 (C:\FTMO), REALE 10105439 (C:\BCM_Reale), piccolo 50503392 (C:\Program Files\BCM Markets MT5 Terminal: solo LETTI i suoi .chr), 100k 50504263 (... -V3), manuale 50503635 (C:\MT5_MANUALE), banco 50504400 (C:\MT5_Backtest), Pepperstone, Tickmill. Nessuna rete.' 'Yellow'
  $oggi=(Get-Date).ToString('yyyy-MM-dd',$IC); if($oggi -ne '2026-10-02'){ throw ('questa riga vale SOLO il 2026-10-02 (data locale del VPS: ' + $oggi + '). Niente scritto.') }
  $ora=(Get-Date).ToString('HH:mm',$IC); & $say ('ora locale VPS (italiana): ' + $ora + '  | la sedia arma alle 14:45 italiane = 13:45 server BCM') 'Gray'; if((Get-Date).TimeOfDay -ge [TimeSpan]'14:40:00'){ & $say 'ATTENZIONE: sono passate le 14:40 italiane: anche scrivendo il file, la barra delle 13:45 server e quasi certamente persa (EA da reinizializzare prima). Scrivere ora non fa danni ma probabilmente non serve.' 'Red' }
  $root=Join-Path (Join-Path $env:APPDATA 'MetaQuotes') 'Terminal'; $com=Join-Path (Join-Path $root 'Common') 'Files'
  if(-not (Test-Path -LiteralPath $com -PathType Container)){ throw ('cartella Common\Files NON trovata: ' + $com + '. Niente scritto.') }; & $say ('Common\Files trovata: ' + $com) 'Green'
  $tgt='abtg_news_live_2026-09-04.csv'; $hdr='Data Ora;Impatto;Valuta;Titolo'; $rows=@('2026.10.02 12:30;High;USD;Unemployment Rate','2026.10.02 12:30;High;USD;Nonfarm Payrolls'); $f=Join-Path $com $tgt
  & $say '--- 1. SOLA LETTURA: la sedia 771203 sul piccolo 50503392 (cartella dati 215D85D767A1C39E22D242C8114BF9F5) ---' 'White'
  $pdd=Join-Path $root '215D85D767A1C39E22D242C8114BF9F5'; $org=((& $rd (Join-Path $pdd 'origin.txt')) -replace '[^\x20-\x7E]','').Trim(); & $say ('origin.txt: ' + $org) 'Gray'; if($org -notlike '*BCM Markets MT5 Terminal' ){ throw ('la cartella dati 215D85D7... non risulta del terminale C:\Program Files\BCM Markets MT5 Terminal (origin: ' + $org + '). Niente scritto.') }
  $pl=& $fld (& $rd (Join-Path (Join-Path $pdd 'config') 'common.ini')) 'ProfileLast'; & $say ('profilo attivo del piccolo (config\common.ini ProfileLast): ' + $pl) 'Gray'; if(-not $pl){ throw 'profilo attivo del piccolo NON determinato. Niente scritto.' }
  $pdir=Join-Path (Join-Path (Join-Path (Join-Path $pdd 'MQL5') 'Profiles') 'Charts') $pl; $hit=@(Get-ChildItem -LiteralPath $pdir -Filter '*.chr' -File -ErrorAction SilentlyContinue | Where-Object { (& $fld (& $rd $_.FullName) 'InpMagic') -eq '771203' })
  if($hit.Count -ne 1){ throw ('nel profilo attivo ' + $pl + ' del piccolo trovo ' + $hit.Count + ' grafici con InpMagic=771203 (atteso 1). Niente scritto.') }
  $ct=& $rd $hit[0].FullName; $nf=& $fld $ct 'InpNewsFile'; $nc=& $fld $ct 'InpNewsCommon'; $nr=& $fld $ct 'InpRestrictToNews'; $nt=& $fld $ct 'InpNewsTitleMatch'; $ny=& $fld $ct 'InpNewsCurrencies'; $ni=& $fld $ct 'InpNewsMinImpact'; $rk=& $fld $ct 'InpRiskPercent'; & $say ('771203 in ' + $pl + '\' + $hit[0].Name + ' (salvato ' + $hit[0].LastWriteTime.ToString('yyyy-MM-dd HH:mm',$IC) + '): InpNewsFile=' + $nf + ' | InpNewsCommon=' + $nc + ' | InpRestrictToNews=' + $nr + ' | InpNewsTitleMatch=' + $nt + ' | InpNewsCurrencies=' + $ny + ' | InpNewsMinImpact=' + $ni + ' | InpRiskPercent=' + $rk + ' (NON toccato)') 'Gray'
  if($nf -ne $tgt -or $nc -ne 'true' -or $nt -ne 'Unemployment Rate' -or $ny -ne 'USD' -or $ni -ne '3'){ throw ('la 771203 NON legge ' + $tgt + ' in Common con TitleMatch Unemployment Rate / USD / impatto 3, come atteso dalla foto del 02/10 03:30. Niente scritto: mandami questo output.') }; & $say 'OK: la 771203 legge proprio quel file, da Common\Files (InpNewsCommon=true).' 'Green'
  & $say '--- 2. SOLA LETTURA: chi altro, su TUTTE le cartelle dati del VPS, nomina quel file ---' 'White'; $altri=0
  foreach($d in @(Get-ChildItem -LiteralPath $root -Directory | Where-Object { $_.Name -ne 'Common' })){ $o2=((& $rd (Join-Path $d.FullName 'origin.txt')) -replace '[^\x20-\x7E]','').Trim(); $p2=& $fld (& $rd (Join-Path (Join-Path $d.FullName 'config') 'common.ini')) 'ProfileLast'; $cr=Join-Path (Join-Path (Join-Path $d.FullName 'MQL5') 'Profiles') 'Charts'; if(-not (Test-Path -LiteralPath $cr)){ continue }; foreach($c in @(Get-ChildItem -LiteralPath $cr -Recurse -Filter '*.chr' -File -ErrorAction SilentlyContinue)){ if($c.FullName -eq $hit[0].FullName){ continue }; $tt=& $rd $c.FullName; if($tt.IndexOf($tgt,[StringComparison]::OrdinalIgnoreCase) -lt 0){ continue }; $pn=$c.Directory.Name; $att=((-not $p2) -or ($pn -eq $p2)); & $say ('   ' + $(if($att){'ATTIVO '}else{'residuo'}) + '  ' + $o2 + '  [' + $d.Name + ']  ' + $pn + '\' + $c.Name + '  magic ' + (& $fld $tt 'InpMagic')) $(if($att){'Red'}else{'DarkYellow'}); if($att){ $altri++ } } }
  if($altri -gt 0){ throw ('' + $altri + ' altri grafici in un profilo ATTIVO (o di profilo non determinato) nominano ' + $tgt + ': la riga potrebbe armare anche loro. Niente scritto: mandami questo output.') }; & $say 'OK: nessun altro grafico in un profilo attivo nomina quel file (i residui, se elencati sopra, non sono caricati).' 'Green'
  & $say '--- 3. IL FILE ---' 'White'; $esiste=Test-Path -LiteralPath $f -PathType Leaf
  if($esiste){ & $show $f 'PRIMA' } else { & $say ('PRIMA: il file NON esiste in Common\Files. Se lo creo, l EA lo trova in Common al prossimo avvio (Common ha la precedenza sulla sandbox MQL5\Files del terminale, che quindi NON serve toccare).') 'DarkYellow' }
  $scritto=$false; $nb=$null
  if($esiste){ $ob=[IO.File]::ReadAllBytes($f); $bom=($ob.Length -ge 3 -and $ob[0] -eq 0xEF -and $ob[1] -eq 0xBB -and $ob[2] -eq 0xBF); $off=$(if($bom){3}else{0}); for($i=$off;$i -lt $ob.Length;$i++){ if($ob[$i] -eq 0 -or $ob[$i] -gt 127){ throw ('il file contiene byte non ASCII (posizione ' + $i + '): formato inatteso, non lo riscrivo. Niente scritto.') } }; $tx=[Text.Encoding]::ASCII.GetString($ob,$off,$ob.Length-$off); $eol=$(if($tx.Contains("`r`n")){"`r`n"}elseif($tx.Contains("`n")){"`n"}else{"`r`n"}); $ln=@($tx -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }); & $say ('formato: BOM ' + $(if($bom){'SI'}else{'no'}) + ' | fine riga ' + $(if($eol -eq "`r`n"){'CRLF'}else{'LF'}) + ' | righe non vuote ' + $ln.Count) 'Gray'; if($ln.Count -gt 0 -and $ln[0] -ne $hdr){ throw ('prima riga inattesa: [' + $ln[0] + '] (attesa: ' + $hdr + '). Niente scritto.') }; $miss=@($rows | Where-Object { $ln -cnotcontains $_ }); if($miss.Count -eq 0){ & $say 'NIENTE DA FARE: le due righe del 2026.10.02 ci sono gia (riga idempotente). File NON modificato, nessun backup.' 'Green' } else { $bk=$f + '.PRIMA_NFP_' + $stamp + '.bak'; Copy-Item -LiteralPath $f -Destination $bk; if((Get-FileHash -LiteralPath $bk -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $f -Algorithm SHA256).Hash){ throw 'backup NON identico all originale. Niente scritto.' }; & $say ('backup: ' + $bk) 'Green'; $new=$tx; if($ln.Count -eq 0){ $new=$hdr + $eol } elseif(-not $new.EndsWith("`n")){ $new=$new + $eol }; foreach($r in $miss){ $new=$new + $r + $eol }; $nb=[Text.Encoding]::ASCII.GetBytes($new); if($bom){ $nb=[byte[]](@([byte]0xEF,[byte]0xBB,[byte]0xBF) + $nb) }; [IO.File]::WriteAllBytes($f,[byte[]]$nb); $scritto=$true; & $say ('AGGIUNTE ' + $miss.Count + ' righe in coda (stesso BOM, stessa fine riga, righe esistenti intatte): ' + ($miss -join ' + ')) 'Green' } }
  if(-not $esiste){ $new=$hdr + "`r`n" + ($rows -join "`r`n") + "`r`n"; $nb=[Text.Encoding]::ASCII.GetBytes($new); [IO.File]::WriteAllBytes($f,[byte[]]$nb); $scritto=$true; & $say 'CREAZIONE: il file non c era, creato con intestazione + le due righe (ASCII, CRLF, senza BOM).' 'DarkYellow' }
  & $show $f 'DOPO '
  if($scritto){ $ab=[IO.File]::ReadAllBytes($f); if([Convert]::ToBase64String($ab) -ne [Convert]::ToBase64String([byte[]]$nb)){ throw 'il file riletto NON coincide con quello scritto. Ripristina dal .bak e mandami questo output.' } }
  $at=[Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($f)); $ev=0; $ut=0; foreach($x in @($at -split "`r?`n")){ $c4=$x.Trim().Split(';'); if($c4.Count -lt 4){ continue }; $c0=$c4[0].Trim(); if($c0 -notmatch '^\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}$'){ continue }; $ev++; if($c0.StartsWith('2026.10.02') -and $c4[1].Trim() -eq 'High' -and 'USD'.Contains($c4[2].Trim()) -and $c4[2].Trim() -ne '' -and $c4[3].Contains('Unemployment Rate')){ $ut++ } }
  & $say ('lettura come l EA: righe-evento ' + $ev + ' | UTILI per la 771203 OGGI (High, USD, titolo contiene Unemployment Rate, data 2026.10.02): ' + $ut) $(if($ut -ge 1){'Green'}else{'Red'}); if($ut -lt 1){ throw 'dopo la scrittura NON c e una riga utile per oggi. Mandami questo output.' }
  & $say '--- 4. ADESSO A MANO (la riga NON lo fa) ---' 'White'
  & $say 'L EA ha GIA caricato il calendario di oggi (vuoto) alla mezzanotte server e NON lo rilegge fino a domani: va REINIZIALIZZATO. Terminale MT5 50503392 = cartella C:\Program Files\BCM Markets MT5 Terminal (NON -V3, NON C:\BCM_Reale, NON C:\FTMO), profilo ORO, grafico USDJPY M5 con ABTG_PostNews magic 771203: tasto F7 sul grafico -> OK senza cambiare niente. Entro le 14:40 italiane.' 'Yellow'
  & $say 'In Esperti (ora LOCALE italiana) deve comparire, con l orario di adesso: [PostNews][NEWS] letto da Common\Files | righe N | UTILI per questo preset 1 ... | dal 2026.10.02 al 2026.10.02. Se quella riga NON compare dopo F7-OK: cambia il grafico a M1 e rimettilo a M5 (anche questo reinizializza), e ricontrolla.' 'Yellow'
  & $say 'Alle 14:45 italiane NON deve comparire [PostNews] nessuna notizia nel CSV oggi: niente ordini. Devono comparire BUY STOP @ ... e/o SELL STOP @ ... (o: prezzo gia sopra/sotto il range).' 'Yellow'
  & $say 'Terminali aperti adesso (SOLA LETTURA, per riconoscere la finestra senza indovinare):' 'White'; $tp=(Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize | Out-String -Width 250).Trim(); & $say $tp 'Gray'
} catch { $rc=1; & $say ('FERMO: ' + $_.Exception.Message) 'Red' } finally { try { if($Pin){ [void]$L.Insert(0,('pin dello script: ' + $Pin)) }; [IO.File]::WriteAllLines($rep,[string[]]$L.ToArray(),(New-Object Text.ASCIIEncoding)); Write-Host ('Referto sul Desktop: ' + $rep) -ForegroundColor Cyan } catch { Write-Host ('referto sul Desktop NON scritto: ' + $_.Exception.Message) -ForegroundColor Red } }
exit $rc
