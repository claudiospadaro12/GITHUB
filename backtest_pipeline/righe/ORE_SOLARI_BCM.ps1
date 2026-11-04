# =====================================================================
#  MARCATORE_ORE_SOLARI_BCM_v1
#  COSA FA: sposta di +1 ora gli orari (ora SERVER) di dieci grafici ABTG del
#  terminale BCM demo 50503392 (C:\Program Files\BCM Markets MT5 Terminal),
#  per l'ORA SOLARE (server BCM = ora italiana; regola in CLAUDE.md, 04/11/2026).
#  Senza -Applica: PROVA, SOLA LETTURA (mostra cosa cambierebbe).
#  Con -Applica: modifica gli input nel blocco <expert> dei file .chr del profilo
#  attivo, SOLO se il valore attuale e quello ESTIVO atteso; fa prima il backup
#  sul Desktop; rilegge e verifica; rifiuta di partire se il terminale e AVVIATO.
#  NON tocca il 100k (-V3), il reale, ne nessun altro terminale. NON invia ordini.
#  LIMITE: non provato su PowerShell prima di questa data (niente pwsh nel cloud):
#  per questo c'e la PROVA e il backup. Ripristino: copiare i .chr dal backup.
#  D'ESTATE (fine marzo 2027): rifare con i valori inversi (colonna vecchio/nuovo).
# =====================================================================
param([switch]$Applica)
$APPLICA=[bool]$Applica;
if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO sul VPS VMI3047753. Macchina attuale: ' + $env:COMPUTERNAME) };
$ErrorActionPreference='Stop';
$INST='C:\Program Files\BCM Markets MT5 Terminal';
if($APPLICA){ Write-Host 'ORE SOLARI - MODALITA APPLICA: modifica gli orari (ora server) nei file .chr del profilo attivo del terminale BCM demo 50503392 (SOLO quello: ne il 100k -V3 ne il reale). Fa prima il backup sul Desktop. Rifiuta di partire se il terminale e AVVIATO.' -ForegroundColor Yellow } else { Write-Host 'ORE SOLARI - MODALITA PROVA (SOLA LETTURA): mostra cosa cambierebbe. Non scrive niente.' -ForegroundColor Cyan };
$CAMBI=@(@('ABTG_EasyTrend','CHFJPY',@{InpHourStart=@('8','9');InpHourEnd=@('18','19')}),@('ABTG_EasyTrend','GBPUSD',@{InpHourStart=@('8','9');InpHourEnd=@('18','19')}),@('ABTG_MaxMinNotte','XAUUSD',@{InpBoxStartHour=@('23','0');InpBoxEndHour=@('4','5');InpPlaceHour=@('7','8');InpEntryCutoffHour=@('8','9');InpCloseHour=@('17','18')}),@('ABTG_PostNews','USDJPY',@{InpActionHour=@('14','15');InpExpiryHour=@('17','18')}),@('ABTG_PostNews','EURJPY',@{InpActionHour=@('15','16');InpExpiryHour=@('18','19')}),@('ABTG_PostNews','EURUSD',@{InpActionHour=@('19','20');InpExpiryHour=@('20','21')}),@('ABTG_ORB_Ottimizzato','XAGUSD',@{InpRangeStartHour=@('14','15');InpRangeEndHour=@('14','15');InpEndHour=@('21','22')}),@('ABTG_Dow_Apertura_US','U30USD',@{InpSessionHour=@('14','15');InpCloseHour=@('17','18')}),@('ABTG_ORB_Ottimizzato','U30USD',@{InpRangeStartHour=@('14','15');InpRangeEndHour=@('14','15');InpEndHour=@('21','22')}),@('ABTG_Nasdaq_Apertura_US','NASUSD',@{InpSessionHour=@('14','15');InpCloseHour=@('20','21')}));
function Leggi($p){ $b=[IO.File]::ReadAllBytes($p); if($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ return [Text.Encoding]::Unicode.GetString($b,2,$b.Length-2) }; return [Text.Encoding]::UTF8.GetString($b) };
$DATI=''; $rad=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; foreach($d in Get-ChildItem -LiteralPath $rad -Directory){ $o=Join-Path $d.FullName 'origin.txt'; if(Test-Path -LiteralPath $o){ $tx=((Leggi $o) -replace '[^\x20-\x7E]','').Trim(); if($tx -eq $INST){ $DATI=$d.FullName } } };
if($DATI -eq ''){ throw 'cartella dati del terminale BCM non trovata (origin.txt)' };
Write-Host ('cartella dati: ' + $DATI);
$run=@(Get-Process -Name terminal64 -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith($INST + '\') });
if($run.Count -gt 0){ if($APPLICA){ throw 'Il terminale BCM e AVVIATO: chiudilo (File > Esci, aspetta che sparisca da Gestione attivita) e rilancia la riga.' } else { Write-Host 'NB: il terminale e avviato (in PROVA non importa; per APPLICARE va chiuso).' -ForegroundColor Yellow } };
$ini=Leggi (Join-Path $DATI 'config\common.ini'); $pl='Default'; $m=[regex]::Match($ini,'(?im)^ProfileLast[ \t]*=[ \t]*(.*?)[ \t]*$'); if($m.Success -and $m.Groups[1].Value.Length -gt 0){ $pl=$m.Groups[1].Value.Trim() };
$cd=Join-Path $DATI ('MQL5\Profiles\Charts\' + $pl); if(-not (Test-Path -LiteralPath $cd)){ throw ('profilo non trovato: ' + $cd) };
Write-Host ('profilo attivo: ' + $pl);
$BK=Join-Path ([Environment]::GetFolderPath('Desktop')) ('BACKUP_CHR_ESTATE_' + (Get-Date -Format 'yyyyMMdd_HHmm'));
$nMod=0; $nGia=0; $nDiv=0; $nSkip=0; $nTrov=0;
foreach($f in Get-ChildItem -LiteralPath $cd -Filter 'chart*.chr' -File){
$b=[IO.File]::ReadAllBytes($f.FullName); if(-not ($b.Length -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254)){ continue };
$t=Leggi $f.FullName; $e=[regex]::Match($t,'(?s)<expert>(.*?)</expert>'); if(-not $e.Success){ continue };
$g=$e.Groups[1]; $blk=$g.Value; $nm=[regex]::Match($blk,'(?im)^[ \t]*name[ \t]*=[ \t]*(.*?)[ \t]*$').Groups[1].Value.Trim(); $sy=[regex]::Match($t,'(?im)^[ \t]*symbol[ \t]*=[ \t]*(\S+)').Groups[1].Value;
$cam=$null; foreach($c in $CAMBI){ if($c[0] -eq $nm -and $c[1] -eq $sy){ $cam=$c[2] } }; if($null -eq $cam){ continue };
$nTrov++; $blk2=$blk; $dif=@(); $mod=$false;
foreach($k in $cam.Keys){ $old=$cam[$k][0]; $new=$cam[$k][1]; $re=[regex]::new('(?m)^(' + $k + '=)([^\r\n]*)'); $mm=$re.Matches($blk2);
if($mm.Count -ne 1){ $nSkip++; $dif += ($k + ': NON TROVATO (' + $mm.Count + ' occorrenze), non tocco'); continue };
$cur=$mm[0].Groups[2].Value.Trim();
if($cur -eq $new){ $nGia++; $dif += ($k + ': gia ' + $new); continue };
if($cur -ne $old){ $nDiv++; $dif += ($k + ': valore ' + $cur + ' diverso da quello estivo atteso ' + $old + ', NON tocco'); continue };
$blk2=$re.Replace($blk2,('${1}' + $new),1); $mod=$true; $dif += ($k + ': ' + $old + ' -> ' + $new) };
Write-Host ('  ' + $nm + '  ' + $sy + '  [' + $f.Name + ']  ' + ($dif -join ' | '));
if($mod -and $APPLICA){ if(-not (Test-Path -LiteralPath $BK)){ New-Item -ItemType Directory -Path $BK | Out-Null }; Copy-Item -LiteralPath $f.FullName -Destination (Join-Path $BK $f.Name);
$t2=$t.Substring(0,$g.Index) + $blk2 + $t.Substring($g.Index + $g.Length); $nb=[Text.Encoding]::Unicode.GetPreamble() + [Text.Encoding]::Unicode.GetBytes($t2); [IO.File]::WriteAllBytes($f.FullName,$nb);
$ver=Leggi $f.FullName; if($ver -ne $t2){ throw ('VERIFICA FALLITA su ' + $f.Name + ': ripristina dal backup ' + $BK) }; $nMod++; Write-Host '     scritto e riletto: OK' -ForegroundColor Green } elseif($mod){ $nMod++ } };
Write-Host '';
Write-Host ('grafici della tabella trovati: ' + $nTrov + '   modifiche (o da fare): ' + $nMod + '   gia a ora solare: ' + $nGia + '   valori diversi dall atteso (NON toccati): ' + $nDiv + '   non trovati: ' + $nSkip);
if($APPLICA){ Write-Host ('Backup dei .chr originali: ' + $BK) -ForegroundColor Green; Write-Host 'ORA: riavvia il terminale BCM e controlla che le sedie ripartano. Stanotte CODA_13 (03:30) rilegge i file: deve dire OK.' -ForegroundColor Green } else { Write-Host 'Per applicare davvero: chiudi il terminale BCM e lancia la riga APPLICA.' -ForegroundColor Cyan }
