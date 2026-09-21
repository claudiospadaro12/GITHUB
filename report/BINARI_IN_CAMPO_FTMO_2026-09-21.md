# 🔎 I BINARI CHE STANNO OPERANDO SU `C:\FTMO` SONO QUELLI CHE CREDIAMO?
### La riga di SOLA LETTURA, passata dal doppio cancello — 21/09/2026

> 🛑 **Questo documento NON e' una misura: e' lo strumento per farla.** Qui dentro non
> c'e' nessun numero sui binari FTMO, perche' **la riga non e' ancora stata eseguita**.
> Quando torna l'output, i numeri si scrivono **sotto**, in un blocco datato.

---

## ① PERCHE' — la domanda, e perche' non e' teorica

`CLAUDE.md` riporta il fatto misurato il **12/09**: il sorgente di `ABTG_EMA200` a HEAD
aveva **690 righe** e la guardia del Guardian a r.381, ma il binario **in campo** sul
piccolo era `344a11b` del **04/08**: **486 righe, ZERO occorrenze di `InpUsaGuardian`**.
🔴 **Un `.ex5` vecchio ignora IN SILENZIO le chiavi del preset che non conosce**: il
preset diceva `InpUsaGuardian=true` e non succedeva niente.

Oggi tutti e sei i preset FTMO portano `InpUsaGuardian=true` (verificato).
**Ma nessuno ha mai guardato i binari su `C:\FTMO`.** La challenge e' **pagata e viva**.

## ② L'ATTESA, dichiarata PRIMA dei numeri
1. In `MQL5\Experts` ci sono **7 `.ex5`** nostri: i sei della rosa (`770101` `770411`
   `770202` `771531` `770511` `770260`) piu' `ABTG_Guardian`.
2. **Ogni `.ex5` ha data 19 o 20/09/2026** (compilazione della serata di schieramento).
   🔴 Un `.ex5` datato **agosto** e' il difetto del 12/09 che si ripete.
3. **Nessun `.mq5` e' piu' recente del suo `.ex5`** (sorgente aggiornato e mai ricompilato).
4. Nella **scheda Esperti** di oggi compaiono righe del Guardian.
5. La cartella dati risolta ha hash **`46C9F8E9FF0C747B2B5E09BCC13D5237`** (`report/STASERA.md`).

👉 Se anche una sola cade, **quello che abbiamo misurato sui sorgenti descrive un'altra flotta**.

## ③ LA RIGA

> ### 🖥️ BERSAGLIO: **finestra PowerShell sul VPS `VMI3047753`**
> Nessun MT5 da aprire, nessuna finestra MT5 da riconoscere: la riga **legge dei file e basta**.
>
> 🔴 **COSA NON TOCCA.** Sul VPS convivono **sette** cartelle dati. La riga legge **solo**
> la cartella dati del terminale **`541452707` (`C:\FTMO`)**, e **non apre, non avvia,
> non chiude e non scrive** niente di: il piccolo `50503392`, il 100k `50504263`, il
> **REALE `10105439`**, il banco `50504400`, Pepperstone, Tickmill.
>
> ✋ **E non tocca nemmeno il terminale FTMO**: non lo avvia, non lo chiude, non gli
> cambia un file. Legge `origin.txt`, i `.ex5`/`.mq5`, i `.log` e i `.chr`. **Si puo'
> incollare a mercato aperto, con le sei sedie che operano.**
>
> 🛡️ Incollata su **un'altra macchina** muore alla prima istruzione con `VIETATO` e non
> stampa altro (provato, §⑤).

```powershell
& { if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $ErrorActionPreference='Continue'; $INV=[Globalization.CultureInfo]::InvariantCulture; $BERS='C:\FTMO'; $ATTESA='46C9F8E9FF0C747B2B5E09BCC13D5237'; Write-Host ''; Write-Host ('=== BINARI IN CAMPO SU ' + $BERS + ' -- SOLA LETTURA -- ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss',$INV) + ' ora Windows del VPS ===') -ForegroundColor Cyan; Write-Host '    questa riga LEGGE e basta: nessun processo avviato o chiuso, nessun file scritto, nessun MT5 aperto.'; $root=''; if($env:APPDATA){ $root=Join-Path $env:APPDATA 'MetaQuotes\Terminal' }; $cand=@(); if($root -eq '' -or -not (Test-Path -LiteralPath $root)){ Write-Host ('NON ESISTE la radice delle cartelle dati [' + $root + '] -- questa riga gira come utente ' + $env:USERNAME) -ForegroundColor Yellow } else { Write-Host ''; Write-Host '--- TUTTE le cartelle dati viste da questo utente (hash e origin.txt) ---' -ForegroundColor Cyan; foreach($d in (Get-ChildItem -LiteralPath $root -Directory | Sort-Object Name)){ $o=Join-Path $d.FullName 'origin.txt'; if(Test-Path -LiteralPath $o){ $t=((Get-Content -LiteralPath $o -Raw) -replace '[^\u0020-\u007E]','').Trim() } else { $t='(nessun origin.txt)' }; $seg=''; if($t -eq $BERS){ $seg='   <== BERSAGLIO'; $cand+=$d.FullName }; Write-Host ('   ' + $d.Name + '   ' + $t + $seg) }; } $portab=$BERS + '\MQL5\Experts'; if(Test-Path -LiteralPath $portab){ Write-Host ('   PORTABLE: esiste anche ' + $portab + ' dentro la cartella programma: il terminale puo essere in modalita portable') -ForegroundColor Yellow; $cand+=$BERS }; Write-Host ''; if($cand.Count -eq 0){ Write-Host ('NESSUNA cartella dati ha origin.txt uguale a ' + $BERS + '. Non proseguo: senza certificato non so di chi sono i binari. Leggere la tabella qui sopra a mano.') -ForegroundColor Yellow } else { if($cand.Count -gt 1){ Write-Host ('ATTENZIONE: ' + $cand.Count + ' cartelle candidate. Le elenco tutte e leggo la PRIMA.') -ForegroundColor Yellow; foreach($x in $cand){ Write-Host ('   candidata: ' + $x) } }; $D=$cand[0]; $h=Split-Path $D -Leaf; Write-Host ('CARTELLA DATI LETTA: ' + $D) -ForegroundColor Green; Write-Host ('   hash: ' + $h + '    atteso (report/STASERA.md): ' + $ATTESA + '    ' + $(if($h -eq $ATTESA){'COMBACIA'}else{'NON COMBACIA -- da leggere a mano prima di credere al resto'})); $ex=Join-Path $D 'MQL5\Experts'; Write-Host ''; Write-Host ('--- 1. I BINARI: ogni .ex5 in MQL5\Experts (primo livello) ---') -ForegroundColor Cyan; if(-not (Test-Path -LiteralPath $ex)){ Write-Host ('   NON ESISTE: ' + $ex) -ForegroundColor Yellow } else { $bin=@(Get-ChildItem -LiteralPath $ex -Filter '*.ex5' | Sort-Object Name); Write-Host ('   trovati ' + $bin.Count + ' file .ex5'); foreach($f in $bin){ $src=Join-Path $ex ($f.BaseName + '.mq5'); $nota='mq5 ASSENTE accanto al binario'; if(Test-Path -LiteralPath $src){ $fm=Get-Item -LiteralPath $src; $nota='mq5 ' + $fm.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) + '  ' + $fm.Length.ToString($INV) + ' byte'; if($fm.LastWriteTime -gt $f.LastWriteTime){ $nota=$nota + '   <<< SORGENTE PIU RECENTE DEL BINARIO: AGGIORNATO E MAI RICOMPILATO' } }; Write-Host ('   ' + $f.Name.PadRight(48) + $f.Length.ToString($INV).PadLeft(9) + ' byte   ex5 ' + $f.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) + '   ' + $nota) }; $orfani=@(Get-ChildItem -LiteralPath $ex -Filter '*.mq5' | Where-Object { -not (Test-Path -LiteralPath (Join-Path $ex ($_.BaseName + '.ex5'))) } | Sort-Object Name); if($orfani.Count -gt 0){ Write-Host ('   SORGENTI SENZA BINARIO (copiati e MAI compilati): ' + (($orfani | ForEach-Object { $_.Name }) -join ', ')) -ForegroundColor Yellow } else { Write-Host '   sorgenti senza binario: nessuno' }; $sotto=@(Get-ChildItem -LiteralPath $ex -Filter '*.ex5' -Recurse | Where-Object { $_.DirectoryName -ne $ex }); Write-Host ('   nelle sottocartelle di Experts ci sono altri ' + $sotto.Count + ' .ex5 (esempi MT5): non elencati, non nostri') }; $inc=Join-Path $D 'MQL5\Include\ABTG_PausaGuardian.mqh'; if(Test-Path -LiteralPath $inc){ $fi=Get-Item -LiteralPath $inc; Write-Host ('   include ABTG_PausaGuardian.mqh   ' + $fi.Length.ToString($INV) + ' byte   ' + $fi.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV)) } else { Write-Host '   include ABTG_PausaGuardian.mqh: ASSENTE in MQL5\Include' -ForegroundColor Yellow }; Write-Host ''; Write-Host '--- 2. I GIORNALI: [dati]\logs = Giornale del terminale, [dati]\MQL5\Logs = scheda Esperti (e li che stampano gli EA) ---' -ForegroundColor Cyan; $pat='guardian|pausa|cap rischio|cluster'; foreach($lg in @((Join-Path $D 'logs'),(Join-Path $D 'MQL5\Logs'))){ if(-not (Test-Path -LiteralPath $lg)){ Write-Host ('   NON ESISTE: ' + $lg) -ForegroundColor Yellow; continue }; $lf=@(Get-ChildItem -LiteralPath $lg -Filter '*.log' | Sort-Object LastWriteTime); if($lf.Count -eq 0){ Write-Host ('   nessun .log in ' + $lg) -ForegroundColor Yellow; continue }; $ul=$lf[-1]; Write-Host ('   FILE: ' + $ul.FullName + '   ' + $ul.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) + '   (il piu recente dei ' + $lf.Count + ' presenti)') -ForegroundColor Green; $tutte=@(Get-Content -LiteralPath $ul.FullName); $hit=@($tutte | Select-String -Pattern $pat); Write-Host ('   righe totali: ' + $tutte.Count + '    righe che nominano guardian/pausa/cap rischio/cluster: ' + $hit.Count + '   (cercate in TUTTO il file, non solo in coda: il Guardian stampa al momento in cui viene attaccato)'); if($hit.Count -eq 0){ Write-Host '   NESSUNA RIGA: su questo file il Guardian non ha scritto niente.' -ForegroundColor Yellow } else { foreach($r in ($hit | Select-Object -First 12)){ Write-Host ('   | ' + $r.Line.Trim()) }; if($hit.Count -gt 12){ Write-Host ('   | ... ' + ($hit.Count - 12) + ' righe in mezzo saltate, ecco le ultime 12 ...'); foreach($r in ($hit | Select-Object -Last 12)){ Write-Host ('   | ' + $r.Line.Trim()) } } }; Write-Host '   ultime 10 righe del file, per contesto:'; foreach($r in (Get-Content -LiteralPath $ul.FullName -Tail 10)){ Write-Host ('   . ' + $r.Trim()) } }; Write-Host ''; Write-Host '--- 3. GLI EA NOMINATI DENTRO I .chr DEI PROFILI (lettura dei file, nessun MT5 toccato) ---' -ForegroundColor Cyan; $pc=Join-Path $D 'MQL5\Profiles\Charts'; if(-not (Test-Path -LiteralPath $pc)){ Write-Host ('   NON ESISTE: ' + $pc) -ForegroundColor Yellow } else { $chr=@(Get-ChildItem -LiteralPath $pc -Filter '*.chr' -Recurse | Sort-Object LastWriteTime); Write-Host ('   trovati ' + $chr.Count + ' file .chr. Il piu recente e il profilo in uso.'); foreach($c in $chr){ $nomi=@(); foreach($enc in @('Unicode','Default')){ $txt=(Get-Content -LiteralPath $c.FullName -Raw -Encoding $enc); $nomi+=@($txt | Select-String -Pattern 'ABTG_[A-Za-z0-9_]+' -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Value }) }; $nomi=@($nomi | Sort-Object -Unique); Write-Host ('   ' + ((Split-Path $c.DirectoryName -Leaf) + '\' + $c.Name).PadRight(34) + ' ' + $c.LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) + '   ' + $(if($nomi.Count -eq 0){'nessun nome ABTG leggibile in questo .chr'}else{($nomi -join ', ')})) } }; Write-Host ''; Write-Host '=== FINE. Niente e stato scritto, niente e stato avviato, niente e stato chiuso. ===' -ForegroundColor Cyan } }
```

## ④ CHE COSA STAMPA
| § | cosa | come risponde alla domanda |
|---|---|---|
| **0** | **tutte** le cartelle dati con il loro `origin.txt`, e quale e' il bersaglio | il bersaglio si sceglie **per nome** (`origin.txt == C:\FTMO`), mai per esclusione (classe 180) |
| **0-bis** | hash risolto **contro** l'atteso `46C9F8E9…` | se non combacia, tutto il resto va letto a mano |
| **1** | ogni `.ex5`: **nome, byte, data**; accanto il suo `.mq5` con data e byte | e' il confronto che dice **agosto o settembre** |
| **1-b** | marcatore `SORGENTE PIU RECENTE DEL BINARIO` | sorgente aggiornato e **mai ricompilato** |
| **1-c** | `.mq5` **senza** `.ex5` | copiato e **mai compilato**: un F7 saltato |
| **1-d** | `ABTG_PausaGuardian.mqh` in `MQL5\Include` | senza l'include la pausa B1 non esiste |
| **2** | **i due giornali**, con nome file e righe totali | vedi §⑤: **e' qui che la specifica sbagliava** |
| **3** | i nomi `ABTG_*` letti **dentro i `.chr`** dei profili, con la data | gli EA attaccati, **senza aprire MT5** |

## ⑤ I DUE CONTRO-ESEMPI — misurati, non argomentati
La specifica ricevuta chiedeva: *«dal giornale di oggi (`<cartella dati>\logs\*.log`,
**ultime ~60 righe**) … se non compare nessuna riga, e' il segnale che cercavamo»*.

🔴 **Eseguita alla lettera, quella specifica avrebbe risposto ZERO su un albero dove il
Guardian STA GIRANDO** — cioe' avrebbe prodotto proprio il segnale che cercava.
Banco: albero dati finto con Guardian acceso, due righe `GUARDIAN` vere.

| # | perimetro / finestra | righe trovate | perche' |
|---|---|---|---|
| **1** | solo `<dati>\logs` (Giornale del terminale) | **0** | il `Print()` di un EA finisce in `<dati>\MQL5\Logs` (scheda **Esperti**), non nel Giornale |
| **1** | `<dati>\MQL5\Logs` | **2** | ✅ |
| **2** | ultime **60** righe della scheda Esperti (202 righe) | **0** | il Guardian stampa **quando viene attaccato**: quelle righe stanno in **cima** |
| **2** | **tutto** il file | **2** | ✅ |

👉 Correzioni applicate nella riga: **si leggono TUTTI E DUE i giornali** e **si cerca in
tutto il file**; a essere accorciato e' l'**output** (prime 12 + ultime 12 delle righe
trovate, col **totale** dichiarato), non la porzione di file letta.
Sono le **classi 545 e 546**, scritte in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

## ⑥ IL DOPPIO CANCELLO
- 🤖 **Strato 1**, `python3 backtest_pipeline/controlla_riga.py --riga backtest_pipeline/righe/RIGA_BINARI_FTMO_DA_MANDARE.txt`
  -> **USCITA 0**, 3 PASSATI, **0 rilievi**, **0 bloccanti**, e la frase che serviva:
  *«riga di SOLA LETTURA locale (lista bianca)»* + *«macchina DICHIARATA e inchiodata dalla riga: VMI3047753»*.
- 🧪 **Eseguita davvero** sotto `pwsh`, tre volte:
  1. **macchina sbagliata** (`DESKTOP-H4D7CAJ`) -> muore alla prima istruzione, **niente altro a schermo**;
  2. **macchina giusta, percorsi inesistenti** -> nessun errore rosso, stampa la conclusione onesta *«NESSUNA cartella dati … non proseguo»*;
  3. **macchina giusta, albero dati finto completo** -> tutte e otto le sezioni corrette, compreso il marcatore *MAI RICOMPILATO* e l'orfano *mai compilato* piantati apposta.
- 🧠 **Strato 2** (giudizio): §⑤ e' il suo esito.

## ⑦ NON COPERTO — e va detto
1. ❌ **La riga non e' ancora girata sul VPS.** Nessun numero vero sui binari FTMO esiste oggi.
2. ❌ **Byte e data NON dicono da quale commit e' stato compilato un `.ex5`.** Dicono
   *quando* e *quanto grande*. Per legare un binario a un commit serve la data del `.mq5`
   accanto **e** il suo conteggio righe: la riga stampa la data e i byte del `.mq5`, **non
   il numero di righe**. Se una data risultasse sospetta, la misura successiva e' un
   conteggio righe del `.mq5` (sempre in sola lettura).
3. ❌ **I `.chr` dicono quali EA sono NOMINATI nel profilo salvato, non quali sono
   attaccati ADESSO**: MT5 riscrive i `.chr` alla chiusura o al cambio profilo. La data
   del file e' stampata proprio per questo. La verita' viva e' la faccina 🙂 sul grafico.
4. ❌ **`config\terminal.ini` non viene letto** (spesso scritto solo all'uscita): il
   profilo in uso si deduce dal `.chr` piu' recente, che e' un indizio, non un fatto.
5. ❌ **Il caso PORTABLE e' segnalato ma non seguito**: se `C:\FTMO\MQL5\Experts` esiste,
   la riga lo dice e aggiunge quel percorso alle candidate, ma non sa dire da sola quale
   dei due sia quello vivo.
6. ❌ **`AutoTrading` acceso/spento non e' leggibile da file**: resta un controllo a vista.
