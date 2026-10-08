# Trial FTMO 1514806751 -- sblocco del Guardian: misura e procedura (08/10/2026)

Decisione di Claudio (08/10): _"SBLOCCHIAMO IL GUARDIAN E SE USCIAMO PAZIENZA"_.
Questo file NON e' stato mandato a Claudio e su `C:\FTMO` non e' stato toccato niente.
**Il valore del nuovo pavimento (`InpTotalDDPct`) e' una FIRMA di Claudio** (parametro di
rischio): qui c'e' la tavola per sceglierlo, non la scelta.

Fonti lette (non ipotizzate):
- binario in campo = **`CLAU12_Guardian` v1.12**, cioe' il sorgente `ABTG_Guardian.mq5` al pin
  **`d884f7e1`** (498 righe), rinominato il 20/09 (`report/RINOMINA_CLAU12_2026-09-20.md`).
  Prova: `CODA_06_quale_codice_gira_20261008_033005.log` r.216 (`CLAU12_Guardian.mq5 1.12 499
  righe, compilato 2026-09-20 16:58`) + `SCHIERA_FTMO.ps1` r.182 (pin `d884f7e1`, v1.12) +
  il grafico ha **16 input** (`CODA_08_preset_dai_chr_20261008_033005.log` r.2346-2361), che
  sono esattamente quelli della v1.12. **NON e' la HEAD (v1.14, 899 righe, 19 input)**: i numeri di
  riga di questo file si riferiscono alla v1.12 (`git show d884f7e1:mql5/Experts/ABTG_Guardian.mq5`).
  La logica toccata qui (OnInit r.268-326, OnTimer r.364-437) e' identica a quella di HEAD
  r.531-781: cambia solo la numerazione.
- input del Guardian sul grafico (letti dal `.chr`, 07/10 23:01): `InpStartBalance=160000.0`
  `InpDailyLossPct=4.5` `InpTotalDDPct=9.3` `InpDDMode=0` `InpDailyResetHour=1`
  `InpDailyPausePct=3.5` `InpMaxOpenRiskPct=4.0` `InpAction=0` `InpCloseAllMagics=true`.
- stato: `CODA_09_giornale_operativo_20261008_033005.log` r.57/64 -- 07/10 22:50
  `eq=145083.71 dayLoss=0.00% totDD=9.32% rischioAperto=0.00% stato=FAILED pausa=ON cap=off`.
- include in campo `ABTG_PausaGuardian.mqh` al pin `26a18566` (v1.20): stessi nomi di GV e stessa
  logica di pausa della HEAD (verificato con `git show`).

---

## 1. Le GlobalVariable: nomi esatti, chi le legge, quali vanno via

Nomi costruiti in `OnInit` (v1.12 r.270-281) con `acc = 1514806751`. Il nome NON dipende dal nome
del file (`CLAU12_` non c'entra): e' scritto nel codice.

| GV (nome esatto) | cosa tiene | valore atteso oggi | chi la legge | azione |
|---|---|---|---|---|
| `ABTG_GUARD_1514806751_FAILED` | latch "challenge fallita" | `1` | **solo il Guardian** | **CANCELLARE** (passo 3) |
| `ABTG_PAUSA_GIORNO_1514806751` | pausa nuovi ingressi (timestamp di accensione) | numero a 10 cifre, `17...` | **le sedie** (include) e il Guardian | **CANCELLARE** (passo 4) |
| `ABTG_PAUSA_FINO_1514806751` | scadenza della pausa | circa `ora + 30 giorni` (~`1.794e9`) | le sedie e il Guardian | **CANCELLARE** (passo 4) |
| `ABTG_GUARD_1514806751_BLOCKDAY_V2` | blocco giornaliero d'emergenza | `0` | solo il Guardian | **NON toccare** (se NON e' 0: fermarsi e mandarmela) |
| `ABTG_GUARD_1514806751_START_V2` | ancora del DD totale | `160000` | solo il Guardian | NON toccare |
| `ABTG_GUARD_1514806751_PEAK_V2` | picco equity (serve solo al trailing) | >= 160000, non misurato | solo il Guardian | NON toccare |
| `ABTG_GUARD_1514806751_DAYKEY_V2` | chiave del giorno prop | `2026280` (08/10, dopo l'01:00 server) | solo il Guardian | NON toccare |
| `ABTG_GUARD_1514806751_DAYSTART_V2` | equity a inizio giornata | ~`145083.71` | solo il Guardian | NON toccare |
| `ABTG_CAP_RISCHIO_1514806751` | cap C1 | `0` | le sedie | NON toccare |
| `ABTG_RISCHIO_APERTO_1514806751` | rischio aperto (informativo) | `0` | pannelli | NON toccare |
| `ABTG_GUARDIAN_BATTITO_1514806751` | battito (si aggiorna ogni secondo) | timestamp di adesso | le sedie | NON toccare |

**Chi tiene ferme le sedie, letto dal codice:**
- le sedie **non leggono FAILED**. Leggono la **pausa** (`ABTG_PausaAttiva_Calc`, include r.99-102:
  pausa attiva se `PAUSA_GIORNO > 0` e `ora < PAUSA_FINO`);
- il Guardian, finche' FAILED vale 1: **(a)** ogni secondo `FlattenAll()` se c'e' anche una sola
  posizione o pendente, di qualunque magic (r.423-425); **(b)** ogni secondo
  `SetPausa(TimeCurrent()+30*86400)` (r.436), che **rinnova** la scadenza a ogni giro. Il blocco e'
  quindi **senza scadenza** (classe 796): i "30 giorni" sono la rete se il Guardian muore, non una durata.
- il reset del giorno prop (01:00 server FTMO, r.375-381) azzera la pausa, ma nello stesso giro r.436
  la riaccende finche' FAILED c'e'. E' cosi' che la pausa e' rimasta ON il 07/10 e oggi.

**Se si cancella FAILED SENZA alzare `InpTotalDDPct`:** al giro dopo (<= 1 s) `totalDD = 160000 -
145083.71 = 14916.29 >= 14880` (9,3%) -> `breachTotal && !failed` (r.407) -> **`FlattenAll()` + FAILED
di nuovo a 1** + riga `!!! DD TOTALE SFONDATO`. Oggi non ci sono posizioni, quindi il danno e' nullo,
ma il gesto e' inutile. Se si cancellasse invece la PAUSA lasciando FAILED, il Guardian la riscrive
entro un secondo (r.436); e se in quel secondo una sedia aprisse, la posizione verrebbe chiusa subito
da r.425 (costo: spread + commissione, per niente).

**Quindi l'ordine giusto e' uno solo:**
1. **prima** alzare `InpTotalDDPct` sul Guardian gia' attaccato (Proprieta' -> Input -> OK);
2. **poi** cancellare `..._FAILED`;
3. **poi** cancellare `ABTG_PAUSA_GIORNO_...` e `ABTG_PAUSA_FINO_...`.

**Cosa fa `OnInit` alla reinizializzazione (cambio input, v1.12 r.268-326):** ricostruisce i nomi;
`gStart = InpStartBalance = 160000` (r.294) e riscrive `START_V2`; rilegge il picco da `PEAK_V2`;
**non** azzera la pausa (lo fa solo se la chiave del giorno e' cambiata, r.304); azzera solo `GV_CAP`
(r.314); **non tocca FAILED**; stampa `[GUARDIAN] avviato. ...` (r.318) e chiama subito `OnTimer()`.
In quel primo giro FAILED vale ancora 1: il Guardian ripassa da r.423 (nessuna posizione: non fa
niente) e da r.436 (rinnova la pausa). Per questo la reinizializzazione **da sola non sblocca niente**,
ed e' sicura come primo passo.

**`InpStartBalance` resta `160000`.** E' l'ancora del DD statico, la stessa base del muro FTMO
(144.000 = 160.000 - 10%). Se fosse messo all'equity attuale (145.083,71), il pavimento al 9,9%
scenderebbe a 130.720: **14.000 EUR sotto il muro FTMO**, cioe' nessuna rete. A `0` prenderebbe
`START_V2` (=160000, r.295): stesso numero ma implicito -- non cambiarlo.
Restano invariati anche `InpDDMode=0` (statico, come FTMO) e `InpAction=0`.

**Due scorciatoie che NON sbloccano (e tolgono la rete):**
- **staccare il Guardian dal grafico**: `PAUSA_FINO` resta a ~ora+30 giorni e le sedie la leggono
  anche senza battito (`ABTG_PausaAttiva_Calc` non guarda il battito): **restano ferme**, e il conto
  resta senza pavimento;
- **`InpAction=1` (solo allarme)**: r.436 riaccende la pausa indipendentemente da `InpAction`, quindi
  le sedie **restano ferme**; in piu' il Guardian smette di chiudere. Peggio su tutti e due i fronti.

**E una trappola da non pestare: il preset del repo NON va caricato.**
`mql5/Presets/ABTG_Guardian_FTMO_2Step.set` r.74 porta **`InpStartBalance=80000`** (la vecchia
challenge `541452707`). Caricato col pulsante "Carica" sul trial: `gStart=80000`, `totalDD = 80000 -
145083 < 0` -> **il Guardian non scatterebbe mai piu'**. Si cambia **un solo campo** sul Guardian gia'
attaccato, non si carica nessun file.

---

## 2. Tavola dei pavimenti (la scelta e' di Claudio)

Equity 145.083,71 · muro FTMO 144.000 (10% di 160.000) · distanza totale 1.083,71.
Pavimento del Guardian = `160000 x (1 - p/100)`; il Guardian chiude tutto e rimette FAILED quando
l'**equity** (flottante compreso, r.367/398) tocca il pavimento.

| `InpTotalDDPct` | pavimento EUR | cuscino pavimento -> muro FTMO | spazio equity -> pavimento (= perdita massima prima del nuovo FAILED) | in punti GER40 a 47,78 lotti | a 12,08 lotti |
|---:|---:|---:|---:|---:|---:|
| 9,3 (oggi) | 145.120 | 1.120 | **-36,29** (gia' sfondato) | -- | -- |
| 9,4 | 144.960 | 960 | 123,71 | 2,6 | 10,2 |
| 9,5 | 144.800 | 800 | 283,71 | 5,9 | 23,5 |
| 9,6 | 144.640 | 640 | 443,71 | 9,3 | 36,7 |
| 9,7 | 144.480 | 480 | 603,71 | 12,6 | 50,0 |
| 9,8 | 144.320 | 320 | 763,71 | 16,0 | 63,2 |
| 9,9 | 144.160 | 160 | 923,71 | 19,3 | 76,5 |

(Controllo: le due colonne di margine sommano sempre a 1.083,71. I lotti 47,78 e 12,08 sono quelli
veri delle due sedie DAX del 01/10 nell'estratto `ReportHistory_trial_1514806751_2026-10-08.xlsx`;
GER40.cash = 1 EUR per punto per lotto.)

**Numeri misurati che servono a scegliere (non sono una raccomandazione):**
- **lo scavalco del Guardian e' gia' stato misurato una volta, il 06/10**: la chiusura di USDCHF alle
  11:07:52 e' un ordine a mercato **senza** tag `[sl]`/`[tp]` e senza commento (estratto, sezione
  Ordini) -- coerente con `FlattenAll` [INFERITO: anche un EA puo' chiudere a mercato]. L'equity e'
  finita a 145.083,71 contro un pavimento di 145.120: **36,29 EUR oltre**, su 5,06 lotti forex in un
  momento calmo. Un campione solo.
- slittamento degli stop veri sul trial: GER40 1,16 / 0,41 / 0,38 punti (= 55 / 5 / 7 EUR ai lotti di
  quelle posizioni); US30 **11,22 punti** su 6,43 lotti (~72 USD).
- con le sedie al 2,00% (preset in campo) uno stop pieno vale ~3.000-3.300 EUR: **qualunque valore
  della tavola fa del Guardian lo stop effettivo di ogni operazione**. A 9,4 lo spazio (123,71) e'
  dell'ordine di spread + commissione + uno slittamento: e' "sbloccare per rifallire al primo
  ingresso". A 9,9 il cuscino verso il muro (160) e' piu' grande di ogni slittamento misurato finora
  (massimo 72 USD), ma un gap o una news lo possono superare: lo scavalco su gap e' [NON MISURATO].
- `InpMaxOpenRiskPct=4.0` lascia entrare **due** posizioni al 2% insieme: `FlattenAll` le chiude in
  sequenza e gli slittamenti si sommano.

**Usare un solo decimale** (9.4 ... 9.9). La riga di verifica (`DD=%.1f%%`, r.318) e il pannello
(`limite %.1f%%`) stampano un decimale: con 9.85 leggeresti `9.9%` e la verifica mentirebbe.
`10.0` (o piu') = pavimento sul muro o sotto: **nessun cuscino**, e' il caso da evitare.

---

## 3. Rischi della procedura su un terminale vivo

- **Versione**: il binario in campo e' la v1.12 per versione dichiarata, conteggio righe (499 contro
  498 del pin: differenza di conteggio del finale) e numero di input (16). **[NON VERIFICATO]**: lo
  SHA del `.mq5` in campo contro il pin, e che il `.ex5` attaccato sia stato compilato da quel `.mq5`.
  Nel Navigatore di `C:\FTMO` ci sono **due** Guardian compilati (`ABTG_Guardian`, 28/09 07:44, e
  `CLAU12_Guardian`, 20/09 16:58, entrambi v1.12): sul grafico c'e' `CLAU12_Guardian`. **Non si
  trascina niente dal Navigatore**: due Guardian sullo stesso conto scriverebbero le stesse GV.
- **Sedie sul trial** (profilo `Default`, notte 08/10 03:30, `CODA_01` r.48-57): `770202` Dow,
  `770260` Nasdaq, `770511` SuperWave, `770411` MaxMin DAX short, `770105` DAX Apertura EU (tutte al
  2,0%), `770621` ORB Dow (0,3%), `772720` Bulge AUDNZD; piu' `CLAU12_Guardian`, `ABTG_TradeExporter`,
  `ABTG_SpreadLogger` che non tradano. **Tutte e sette le sedie hanno `InpUsaGuardian=true`** nel
  `.chr` e sorgente con lettura del Guardian (`CODA_06`, colonna GUARD=SI). **`ABTG_EMA200`
  (`771531`) NON e' attaccata sul trial**, e le copie installate qui (553 righe) leggono il Guardian:
  il difetto del 12/09 riguardava il binario di 486 righe sul piccolo `50503392`. Prova empirica
  che la pausa morde: il Bulge apriva piu' volte al giorno fino al 06/10 10:00 e **dopo le 11:07:52
  del 06/10 non c'e' nessun ordine** fino all'estratto delle 08:17 dell'08/10. Lo stato e' quello
  delle 03:30 dell'08/10: cambi fatti dopo non sono visti.
- **Riavvio / reload**: cambiare gli input del Guardian reinizializza **solo il Guardian**; le sedie
  non si ricaricano e il terminale non si riavvia. Le GV stanno nel terminale e sopravvivono.
  [NON VERIFICATO] se un crash del terminale subito dopo la cancellazione possa rileggere da disco una
  FAILED vecchia: sarebbe un errore nel verso SICURO (di nuovo bloccato), da ricontrollare col pannello.
- **Dal momento in cui spariscono le due GV di pausa, le sedie possono aprire**: e' quello il momento
  in cui il trial si riarma. [NON VERIFICATO per sedia] se un EA che durante la pausa ha fatto avanzare
  la sua macchina a stati mandi subito un ordine su un livello calcolato prima.
- **Le GV di altri conti sono nella stessa finestra**: le GlobalVariable sono del TERMINALE, non del
  conto, e su `C:\FTMO` ha girato anche la vecchia challenge `541452707`. Nella finestra F3 e'
  probabile vedere anche `ABTG_GUARD_541452707_...`: **non si toccano**. Si cancella solo cio' che
  contiene `1514806751`, e solo i tre nomi della tavola.
- **Sessione Windows**: tutta la flotta gira sotto `VMI3047753\Administrator` (classe 115-ter): le
  finestre MT5 si vedono solo da quella sessione.

---

## 4. LA PROCEDURA PER CLAUDIO (da mandare SOLO dopo che ha scelto il valore)

> **Bersaglio di tutta la procedura: il terminale MT5 FTMO, conto `1514806751`, programma
> `C:\FTMO\terminal64.exe`, sul VPS `VMI3047753`, sessione `Administrator`.**
> **NON si toccano**, in nessun passo: `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`) ·
> `50504263` (`C:\Program Files\BCM Markets MT5 Terminal -V3`) · **`10105439` REALE (`C:\BCM_Reale`)** ·
> `50504400` (`C:\MT5_Backtest`) · `50503635` (`C:\MT5_MANUALE`) · Pepperstone
> (`C:\Program Files\Pepperstone MetaTrader 5`) · Tickmill (`C:\Program Files\Tickmill Europe MT5 Terminal`).
> Nessuno script da scaricare, nessun file da copiare, nessun preset da caricare.

### Passo 0 -- quale finestra e' quella giusta
**Bersaglio: finestra PowerShell sul VPS** (sola lettura: non tocca nessun terminale).
```
Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize -Wrap
```
Cerca la riga con **Path = `C:\FTMO\terminal64.exe`** e **titolo che contiene `1514806751`**.
**Se il titolo non porta `1514806751`, o se il percorso non e' `C:\FTMO`, FERMATI e mandami la
schermata.** Annota l'Id: e' la finestra su cui lavori.

### Passo 1 -- SOLO GUARDARE (non cambiare niente)
**Bersaglio: terminale MT5 `1514806751` (`C:\FTMO`)**, azione a mano. Non tocca nessun altro terminale.
1. Porta in primo piano la finestra dell'Id del passo 0. Nella barra del titolo deve leggersi `1514806751`.
2. Apri il grafico **NZDJPY,M1**: in alto a sinistra c'e' il pannello `=== ABTG GUARDIAN ===`.
   Deve dire `Stato: CHALLENGE FALLITA (DD totale)` e `Saldo iniziale: 160000.00`.
3. Premi **F3** (Strumenti -> Variabili globali). Allarga la colonna del nome e ordina per nome.
4. **Fai UNA schermata** con: pannello del Guardian + finestra F3 completa + pulsante Algo Trading.
5. **Chiudi la finestra F3 SENZA modificare niente. Mandami la schermata e ASPETTA la mia conferma.**
   Se in F3 vedi nomi con `10105439`, `50504263` o `50503392`: sei sul terminale sbagliato, fermati.

### Passo 2 -- alzare il pavimento (solo dopo la mia conferma)
**Bersaglio: terminale MT5 `1514806751` (`C:\FTMO`), grafico NZDJPY,M1, EA `CLAU12_Guardian`.**
Non tocca le altre sedie.
0. **Spegni Algo Trading** su QUESTO terminale (pulsante in alto, diventa rosso). Le sedie restano
   attaccate ma non possono aprire mentre lavori (regola della classe 1002: gli input legati al conto
   si cambiano con Algo Trading spento). Si riaccende al passo 4.
1. Sul grafico **NZDJPY,M1** tasto destro -> **Expert Advisors -> Proprieta'** (oppure F7 **dentro il
   terminale** con quel grafico selezionato; NON in MetaEditor, dove F7 compila).
2. Scheda **Input**: cambia **SOLO `InpTotalDDPct`**, da `9.3` a **`<VALORE FIRMATO DA CLAUDIO>`**
   (un decimale, col punto). **Non toccare `InpDailyLossPct`** (e' la riga accanto), non toccare
   `InpStartBalance` (deve restare `160000.0`), **non premere "Carica"**, non toccare la scheda Comune.
3. **OK**.
4. Nella scheda **Esperti** in basso deve comparire, letterale:
   `[GUARDIAN] avviato. Saldo iniziale=160000.00  DailyLoss=4.5%  DD=<VALORE>% (statico)  Azione=CHIUDI+BLOCCA`
   **Se `Saldo iniziale` non e' 160000.00 o `DD` non e' il valore scelto: FERMATI e mandami la schermata.**
   A questo punto il pannello dice ancora `CHALLENGE FALLITA`: e' giusto, FAILED si toglie al passo 3.

### Passo 3 -- togliere il latch FAILED
**Bersaglio: terminale MT5 `1514806751` (`C:\FTMO`), finestra F3.**
1. **F3** -> seleziona **esattamente** `ABTG_GUARD_1514806751_FAILED` -> **Elimina**.
2. Chiudi F3 e riaprila: quella riga non deve esserci piu'.
3. Entro un secondo il pannello deve dire **`Stato: OK - operativo`**.
   **Se in Esperti compare `!!! DD TOTALE SFONDATO`, FERMATI e mandami la schermata** (vuol dire che il
   passo 2 non ha preso).

### Passo 4 -- togliere la pausa e riaccendere Algo Trading (da qui le sedie possono aprire)
**Bersaglio: terminale MT5 `1514806751` (`C:\FTMO`), finestra F3.**
1. **F3** -> elimina **`ABTG_PAUSA_GIORNO_1514806751`**, poi **`ABTG_PAUSA_FINO_1514806751`**.
2. **Nient'altro**: non `START_V2`, non `PEAK_V2`, non `DAYKEY_V2`, non `DAYSTART_V2`, non
   `BLOCKDAY_V2`, non il `BATTITO`, e **niente che contenga `541452707`** o un altro numero di conto.
3. Chiudi e riapri F3: le due righe non ci sono piu'. Il pannello deve dire
   **`Pausa morbida (3.5%): libera`**.
4. Nella scheda Esperti, dopo l'ora della cancellazione, **NON** deve comparire
   `* PAUSA NUOVI INGRESSI attiva: challenge fallita` (se compare, FAILED era ancora vivo: classe 131).
5. **Riaccendi Algo Trading**: il pulsante deve essere **VERDE**. Da questo istante le sedie possono
   aprire (e' il momento in cui il trial si riarma).
6. Salva il profilo (menu File -> Profili -> salva sul profilo `Default`) [NON VERIFICATO: etichetta
   esatta del menu], cosi' un riavvio non ricarica `9.3` dal `.chr` (aggravante della classe 1002).
   Se lo ricaricasse, il Guardian rimetterebbe FAILED al primo secondo: verso SICURO, ma il trial
   resterebbe fermo senza che nessuno lo sappia.
7. **Schermata finale**: pannello + F3 + coda della scheda Esperti + pulsante Algo Trading. Mandamela.

Controlli indipendenti: entro 5 minuti la riga periodica del Guardian deve dire `stato=OK pausa=off`;
la notte, `CODA_09` la rilegge dal giornale e `CODA_08` rilegge dal `.chr` il nuovo `InpTotalDDPct`
(se `CODA_08` dice ancora `9.3`, il profilo non e' stato salvato).

---

## NON COPERTO (e perche')
- **Etichette esatte della finestra F3** (nome del pulsante Elimina, filtro, ordinamento) sulla build
  installata in `C:\FTMO`: non leggibili dal repo. La procedura chiede di chiudere e riaprire F3
  dopo ogni cancellazione per vedere il fatto, non per fidarsi dell'interfaccia.
- **SHA del `.mq5`/`.ex5` in campo** contro il pin `d884f7e1`: non nelle sonde notturne. Versione,
  righe e numero di input combaciano.
- **Valore attuale di `PEAK_V2` e `BLOCKDAY_V2`**: si leggono al passo 1.
- **Scavalco della chiusura del Guardian su gap/news** e slittamento di `FlattenAll` con due posizioni
  aperte: un solo campione (36,29 EUR, forex, 06/10).
- **Che cosa considera FTMO al tocco del 10%** (equity al tick o altro): non verificato qui.
- **Stato del campo dopo le 03:30 dell'08/10**: le sonde sono notturne.
- **Cosa fa ciascuna sedia se prova a mandare un ordine nei minuti con Algo Trading spento** (passi
  2-4): riceve un rifiuto; se lo tratta come "giornata gia' operata" perde quel setup. Non letto EA per EA.
