# 🥇 SEDIA ORO SOLO LONG su FTMO — il pacchetto in BOZZA, cosa manca e in che ordine (27/09/2026)

**Stato: BOZZA. Niente in campo, niente firmato, nessuna riga di lancio scritta.** Questo documento
esiste perche', se R268 (tick reali) e R268d (22 anni) passano, l'unica cosa che deve mancare e' la
firma di Claudio — non un preset da scrivere in fretta la sera prima.

Fonti: `report/REFERTO_ROUND_CORTI_B_2026-09-27.md` §5 (PASS `f67693c4`) · `report/STRESS_ORO_LONG_2026-09-27.md`
(PASS `e6b62787`) · `backtest_pipeline/prove/R260a_oro_770402_solo_long.txt` (la cella, PASS `fbf1f05f`) ·
`report/AUTOPSIA_PERSI_2026-09-27.md` §B · `mql5/Presets/FTMO/ABTG_MaxMinNotte_ORO_770402_FTMO.set` (preset a due lati) ·
`backtest_pipeline/righe/RINOMINA_CLAU12.ps1`, `RICOMPILA_CLAU12_TRAILFIX.ps1` + `_LEGGIMI.md` ·
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260927_033003.log` e `CODA_06_quale_codice_gira_20260927_033003.log` ·
`report/SEDIA_SHORT_DOW_FTMO_2026-09-26.md` (modello di pacchetto) · `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md` e `_25.md` ·
`report/MAIL_FTMO_TRE_DOMANDE_2026-09-27.md`.

---

## ⓪ 🎯 IN UNA RIGA

La cella R260a (oro `ABTG_MaxMinNotte`, XAUUSD H2, box 23:00-04:59 BCM, **solo long**) ha **PF 1,336 su 279 posizioni,
DD equity 4,52% a 0,5%** su 2020-2026 OHLC M1, stress dei costi PASS. Per farne una sedia FTMO mancano, in quest'ordine:
**(a)** R268/R268d letti · **(b)** l'EA compilato su `C:\FTMO` (oggi NON c'e') · **(c)** il preset sul VPS con una riga da cancello ·
**(d)** l'attacco a mano su un grafico XAUUSD nuovo · **(e)** l'aritmetica del Guardian con una sedia in piu' · **(f)** due
risposte FTMO (una chiusa, una aperta). **Tre di queste sono firme di Claudio** (taglia, magic e compilazione su un conto
vivo). Il preset in bozza: `mql5/Presets/FTMO/BOZZA_CLAU12_MaxMinNotte_ORO_LONG_FTMO.set`
(SHA256 `e5bcabd52df9e6eefbee176e7eda7d5a582186feadd263c111b974a0de727a81`, ASCII puro, 53 input nell'ordine del sorgente).

---

## ① 🖥️ IL BERSAGLIO — detto prima di ogni cosa

- 🪟 **Terminale MT5 FTMO `541452707`**, cartella programma **`C:\FTMO`**, cartella dati `46C9F8E9FF0C747B2B5E09BCC13D5237`
  (hash usato da `RICOMPILA_CLAU12_TRAILFIX.ps1` e `RIGA_PRESET_SHORT_DOW_FTMO.txt`).
- **NON toccati, per nome**: piccolo `50503392` (`BCM Markets MT5 Terminal`, dove vive la `770402` a due lati), 100k `50504263`
  (`... -V3`), REALE `10105439` (`C:\BCM_Reale`), banco `50504400` (`C:\MT5_Backtest`, spento per firma del 21/09), manuale
  `50503635` (`C:\MT5_MANUALE`), Pepperstone, Tickmill.
- Riconoscimento della finestra, sola lettura, in 🖥️ **finestra PowerShell sul VPS `VMI3047753`** (non tocca niente:
  stampa PID, titolo e cartella di ogni MT5 aperto). Il blocco giusto ha `541452707` nel titolo e `Path` che comincia
  con `C:\FTMO`; se non c'e', ci si ferma.

```powershell
Get-Process terminal64 | Select Id, MainWindowTitle, Path | Format-List
```

---

## ② 📋 COSA SERVE, IN ORDINE — chi lo fa, cosa e' firma

| # | cosa | chi | firma? | stato oggi |
|---|---|---|---|---|
| (a) | R268 (tick) e R268d (22 anni) **letti con esito** | PC di backtest `DESKTOP-H4D7CAJ` + lettura mia | no | 🔴 in coda, non girati |
| (b) | `CLAU12_MaxMinNotte.mq5` **compilato su `C:\FTMO`** | riga nuova (cancello) + Claudio la lancia nel weekend | 🖊️ **si'** (binario nuovo su conto vivo) | 🔴 l'EA non c'e' |
| (c) | **preset sul VPS** con una riga modello `RIGA_PRESET_SHORT_DOW` | riga nuova (cancello) + Claudio | no (ma la riga passa dal cancello) | ⚪ non scritta |
| (d) | **attacco a mano** su grafico XAUUSD nuovo, profilo salvato | ✋ Claudio dentro MT5 | no | ⚪ |
| (e) | **aritmetica Guardian** con una sedia in piu' a 0,5% | calcolo qui sotto | 🖊️ la **taglia** e' firma | 🟠 fatto a 0,5% di banco |
| (f) | **FTMO**: posizioni opposte stesso conto (chiusa) · gap trading (aperta) · **cross-account con il piccolo** | risposta FTMO + decisione di Claudio | 🖊️ **si'** (il piccolo) | 🔴 **BLOCCO prima dell'attacco** (§⑧.4) |

**Nessuna taglia e' proposta in questo documento.** Il `0.50` nel preset e' il rischio di banco di R260a.

---

## ③ (a) R268 e R268d — cosa devono dire, e cosa NON possono dire

I quattro file (`backtest_pipeline/prove/R268a..d`, commit `aee08fa8`, magic `797201-797254`, tutti `InpAllowShort=false`,
rischio 0,5 — R268c: asse 0,5/1,0/1,5/2,0 —, deposito 100000) sono scritti con criteri congelati PRIMA dei numeri (testa par. 7). Si leggono in quest'ordine:

1. **R268b** (OHLC, finestra dei tick 2024.07.05→2026.06.30) = **G0 del banco**: per-trade `797202` contro `795301` ristretto,
   **119 deal esatti**, struttura, lotto e soldi. **ROSSO = R268 NON si legge** (ne' r, ne' R268d).
2. **R268a** (tick reali, stessa finestra): lo scarto **r = DD_tick / DD_OHLC** del solo long. Il merito a tick e' SOSPESO per
   costruzione (n ~92 < 150): R268a da' il **rischio**, non il merito.
3. **R268c** (tick, asse rischio 0,5/1,0/1,5/2,0): la curva DD(taglia) MISURATA a tick su 2 anni, un solo regime (toro
   dell'oro). Parte solo se R268a e' durato <= 5 minuti. Nessuna cella si promuove (R4).
4. **R268d** (OHLC, **2004.06.11→2026.06.30**): il DD del solo long **sulla finestra del contratto** (`CONTRATTI_SEDIE.md`
   r.95: 10,0% a 0,5% sui 22 anni, straddle, geometria R17 = altra configurazione). G0d: il tratto 2020-2026 deve ridare
   le 375 righe di `795301`.

**Cosa resta aperto anche a R268 VERDE** (testa par. 11): profondita' e densita' dei tick XAUUSD [NON VERIFICATE], spread
in memoria delle corse OHLC [NON PINNATO, classe 394], commissione FTMO su XAUUSD [NON MISURATA], orologio dell'oro
[INFERITO = forex], slippage e requote veri di FTMO. **E il "PASS" di R268 non e' una taglia**: e' il numero su cui Claudio
firma (R193b A3/C4: *"la taglia si decide sulla finestra PEGGIORE"*).

---

## ④ (b) L'EA su `C:\FTMO` — la DIFF che servirebbe, SENZA toccare gli script

### ④.1 Il fatto
`CODA_06` del 27/09 (r.179-239, cartella `46C9F8E9...`, programma `C:\FTMO`): **56 `.mq5`**, fra cui i sette `CLAU12_*`
(`.ex5` del 20/09 16:58) e **nessun `ABTG_MaxMinNotte.mq5` ne' `CLAU12_MaxMinNotte.mq5`**. `RINOMINA_CLAU12.ps1` r.129-135
rinomina **7 file** (6 sedie + Guardian): questo motore non c'e'. Quindi la sedia oggi **non ha un binario** sul conto.

### ④.2 L'impronta del sorgente a HEAD, calcolata come la calcola lo script
La tavola `$RINOMINE` non usa `Get-FileHash`: usa lo **SCHELETRO** (`Scheletro` r.198-212: CRLF→LF, via i byte non ASCII
stampabili, tolte le righe vuote in coda, SHA256 del testo ASCII, `Righe = (split "\n").Count`). L'ho rifatto in Python e
**provato sul contro-esempio**: due file gia' in tavola (`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` @`5fc0bc31` →
`619 / B4A56E08...`, `ABTG_Guardian.mq5` @`d884f7e1` → `498 / A457F2CD...`) **tornano al byte** con la tavola. Solo dopo ho
misurato il nostro:

| file | commit | Righe (scheletro) | Sha (scheletro) | SHA256 dei byte |
|---|---|---:|---|---|
| `mql5/Experts/ABTG_MaxMinNotte.mq5` | HEAD `9b838084` **= pin `7d0da9f9`** (diff vuoto; `7d0da9f94ae7ae5834a1664d46738ebb87ada2e1`, 03/09/2026, v1.11) | **918** | `32C692ADD267DD4FA9C500281C2427F5306B1F961AFD1315E867D4B6D717146D` | `9346f16a4caad4cf18ee9b772caf06a497b3c6727e0d0b65250e377e75bfae80` |

(`CODA_06` lo riporta con **919** righe sul banco `50504400` (cartella `04C7A32B`, v1.11, compilato il 21/09): e' il
conteggio del log, non lo scheletro; stesso file. 🔴 **E sul piccolo `50503392` (cartella `215D85D7`) la `770402` VIVA gira un
`ABTG_MaxMinNotte.mq5` v1.10 di 540 righe, GUARD=no, compilato il 06/08/2026**: i 2 trade forward del piccolo vengono da
quel binario, non dal v1.11 del banco. Stesso caso della `EMA200` del 12/09.)

### ④.3 La DIFF — scritta qui, NON applicata (gli script non si toccano senza firma)
**`SCHIERA_FTMO.ps1` r.175-186, tavola `$SORGENTI`**, ottava riga da aggiungere DOPO `ABTG_Guardian.mq5`:
`Nome='ABTG_MaxMinNotte.mq5'; Sedia='770421 MaxMin ORO long   XAUUSD H2'; Cartella='Experts'; RepoDir='mql5/Experts';
Pin='7d0da9f94ae7ae5834a1664d46738ebb87ada2e1'; Righe=918; Sha='32C692ADD267DD4FA9C500281C2427F5306B1F961AFD1315E867D4B6D717146D'`

**`RINOMINA_CLAU12.ps1` r.129-135, tavola `$RINOMINE`**, ottava riga:
`Vecchio='ABTG_MaxMinNotte.mq5'; Nuovo='CLAU12_MaxMinNotte.mq5'; Sedia='770421 MaxMin ORO long   XAUUSD H2'; Righe=918;
Sha='32C692ADD267DD4FA9C500281C2427F5306B1F961AFD1315E867D4B6D717146D'`

🔴 **Ma la DIFF da sola non basta, e va detto**: quei due script sono nati per lo schieramento del 20/09 e presumono un
terminale senza sedie vive; `RICOMPILA_CLAU12_TRAILFIX.ps1` compila SOLO i suoi tre `CLAU12_*` d'apertura e pretende in
campo l'impronta del pin `9fca63d9`. Per l'oro serve **una riga nuova** (copia del `.mq5` al pin → rinomina → F7), modellata
su `RICOMPILA` lettera per lettera: **a)** guardia macchina `VMI3047753`; **b)** cartella dati per hash + `origin.txt = C:\FTMO`
+ conto `541452707` nel giornale; **c)** giorno = sabato/domenica; **d)** `metaeditor64` chiuso (lezione del 22/08); **e)**
sorgente scaricato al pin con SHA256 dei byte confrontato in memoria; **f)** stato del disco: `ABTG_MaxMinNotte.mq5`,
`CLAU12_MaxMinNotte.mq5` e i loro `.ex5` **NON devono esistere** in `MQL5\Experts` di `46C9F8E9...` — se uno c'e', STOP (e' un
binario NUOVO, non una ricompilazione: niente sovrascritture; per lo stesso motivo il backup **h)** di `RICOMPILA` qui non ha
niente da copiare, e va detto nella riga); **g)** include `ABTG_PausaGuardian.mqh` **misurato e
non toccato** = v1.20 pin `26a18566` (398 righe, scheletro `D179846B`), la stessa che ha compilato i binari in campo il
20/09; **i)** copia del sorgente al pin come `CLAU12_MaxMinNotte.mq5`, SHA256 **riletto dal disco**; **j)**
`C:\FTMO\metaeditor64.exe /compile:<mq5> /inc:<MQL5> /log:<log>`, log UTF-16, **"0 errors" obbligatorio**, `.ex5` con data DOPO
l'avvio (classe 270); **k)** scheletro del file copiato stampato (atteso **918 / `32C692AD...146D`**); **l)** Desktop del VPS + zip;
**m)** istruzione finale: scheda Esperti di `C:\FTMO`, e **nessun grafico da toccare** (l'attacco e' il passo (d), separato).

**Il vincolo del weekend, riletto per l'oro**: `RICOMPILA` r.361-365 si ferma in feriale perche' le sedie d'apertura
possono avere posizioni. Qui il binario e' **NUOVO** (nessun grafico lo usa: `CODA_01` 27/09, 9 sedie su `C:\FTMO`,
**nessuna su XAUUSD**), quindi la compilazione non ricarica niente. Il weekend resta comunque la finestra giusta: il
terminale e' acceso, MetaEditor non compete con le sedie d'apertura, e la regola dei terminali multipli vuole un'azione
sola per volta.

🟠 **[NON VERIFICATA]**: la compilazione di `ABTG_MaxMinNotte.mq5` @`7d0da9f9` (03/09) contro l'include v1.20 (19/08).
La chiamata dell'EA e' `ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_MaxMinNotte")` (r.346, due argomenti) e la firma v1.20
r.282 accetta due argomenti: la forma c'e', il `0 errors` no — lo dice solo MetaEditor.

---

## ⑤ (c) Il preset sul VPS — i pezzi della riga, NON la riga

La riga si scrive **dopo** (a) e (b) e **dopo** la firma di taglia e magic, sul modello di
`backtest_pipeline/righe/RIGA_PRESET_SHORT_DOW_FTMO.txt` (PASS del 26/09). I suoi pezzi, per nome:

1. **guardia macchina**: `$env:COMPUTERNAME -eq 'VMI3047753'`, altrimenti `throw` senza scaricare;
2. **bersaglio stampato in testa** con l'elenco di cio' che NON tocca (i nove grafici vivi, gli altri sei terminali);
3. **cartella dati certificata** in tre modi: hash `46C9F8E9FF0C747B2B5E09BCC13D5237` + `origin.txt` = `C:\FTMO` + conto
   `541452707` **nei 10 giornali piu' recenti** di `logs\`;
4. **download dal pin** (`raw.githubusercontent.com/.../<pin>/mql5/Presets/FTMO/<nome>.set`) del file **senza** il
   prefisso `BOZZA_` — cioe' il file che nascera' dalla firma, non questo;
5. **marcatore** nel file scaricato (qui: `MARCATORE_BOZZA_ORO_LONG_FTMO_v2`; nel file firmato sara' un marcatore
   senza la parola BOZZA) e **SHA256** confrontato con quello scritto nella riga;
6. **righe chiave presenti**, verificate una per una: `InpMagic=<firmato>`, `InpAllowLong=true`, `InpAllowShort=false`,
   `InpRiskPercent=<firmata>`, `InpBoxStartHour=1`, `InpBoxEndHour=6`, `InpPlaceHour=9`, `InpEntryCutoffHour=10`,
   `InpEntryCutoffMin=30`, `InpCloseHour=19`, `InpCloseMin=30`, `InpOneTradePerDay=true`, `InpUsaGuardian=true`;
7. **non sovrascrivere**: se in `MQL5\Presets` c'e' gia' un file con quel nome e SHA diverso → copia nello zip e `throw`;
   SHA uguale → "gia' presente", nessuna scrittura;
8. **rilettura dal disco** dopo la copia (SHA atteso), `REFERTO.txt` + zip sul Desktop, `ESITO:` in coda.

E prima di consegnarla: `python3 backtest_pipeline/controlla_riga.py --oggetto riga <file>` rc 0 + agente `controllo-preventivo`.

---

## ⑥ (d) L'attacco a mano — ✋ dentro il terminale FTMO `541452707` (`C:\FTMO`)

- **Grafico**: `CODA_01` 27/09 dice che su `C:\FTMO` il profilo attivo `Default` ha 9 grafici (`GER40.cash` x2, `US30.cash`
  x3, `US100.cash`, `NZDJPY` Guardian, `NZDUSD` TradeExporter, `US500.cash` SpreadLogger) e **nessun `XAUUSD`**: il simbolo su
  FTMO si chiama proprio `XAUUSD` (PREVOLO 20/09: 2 decimali, lotto min 0,01, contract 100, stops level 0, spread 47 punti
  alle 17:08). Quindi **File → Nuovo grafico → `XAUUSD`**, timeframe **H2** (il TF del banco; l'EA non legge il periodo del
  grafico — zero `_Period`/`PERIOD_CURRENT` nel sorgente — quindi e' una scelta di coerenza, non di logica).
- **EA**: dal Navigatore, `CLAU12_MaxMinNotte` sul grafico **nuovo**. Non c'e' rischio di sostituire una sedia viva
  (nessun XAUUSD esiste), ma la regola resta: mai trascinare su un grafico che ha gia' un EA.
- **Input → Carica** il `.set` firmato. Nella lista: `InpMagic` = quello firmato, `InpAllowShort` = false,
  `InpRiskPercent` = quella firmata, `InpBoxStartHour` 1, `InpPlaceHour` 9, `InpEntryCutoffHour` 10 / 30, `InpCloseHour` 19 / 30.
- **Comune**: "Consenti trading algoritmico" → OK. **Algo Trading** in alto gia' verde: **non premerlo**.
- ⏰ **QUANDO**: 🔴 **non fra le 09:00 e le 19:30 FTMO** (08:00-18:30 italiane). Letto nel codice, **seguendo la macchina a
  stati fino al tick DOPO** (classe 866): un EA appena attaccato parte in `MMP_WAIT` e, se `nowMin >= 09:00` e oggi non ha
  operato (r.274-290), **piazza il buy stop subito** sul box della notte. Poi dipende dall'ora:
  - **fra le 09:00 e le 10:30 FTMO** 🔴: il pendente vive davvero fino al cutoff delle 10:30 (r.256-262) — e' un **ingresso in
    ritardo** che il banco non ha mai visto (il banco piazza alle 09:00 in punto). **Questa e' la finestra pericolosa.**
  - **fra le 10:30 e le 19:30 FTMO** 🟠: al tick successivo la fase e' `MMP_PLACED`, niente posizione, `nowMin >= 10:30` → il
    cutoff **cancella** il pendente. Vive **un tick**: scatta solo se quel tick stesso lo attraversa. Rischio piccolo ma non
    zero, e nel giornale compare un `BUY STOP` + una cancellazione che confonderebbero la lettura del primo giorno.
  - **dopo le 19:30 o prima delle 09:00 FTMO, o nel weekend** 🟢: `EndOfDay` (r.487-492) oppure attesa del `09:00` — nessun
    ordine. Finestra buona: **weekend** (l'oro riapre la domenica sera = lunedi' ~01:00 FTMO, il box di lunedi' si calcola da
    li'), oppure un feriale **dopo le 19:30 FTMO**.
- **Verifica** (scheda Esperti, ora del PC = italiana): `avviato su XAUUSD. Box server 01:00-06:59, piazzo 09:00, flat 19:30.`
  (r.224) + l'autotest v1.11 in OnInit; faccina 🙂; nel Diario `loaded successfully` senza `removed`.
- 🔴 **Il profilo va SALVATO** (`File → Profili → Salva profilo`, stesso nome `Default`): **classe 822** — la `770105`
  attaccata il 25/09 alle 20:47 **non compariva** in `CODA_01` del 26/09 perche' il `.chr` si scrive solo salvando il profilo,
  e `CODA_09` scarta proprio le righe `avviato`/`CONFIG IN USO` che proverebbero l'attacco. Senza il salvataggio, la notte
  dopo la sonda dira' "non c'e'" e avra' ragione a meta'.
- **Rollback**: `Expert Advisors → Rimuovi` sul grafico nuovo. Togliere l'EA **non cancella** un buy stop pendente (scade da
  solo entro 90') ne' una posizione (resta con SL/TP sul server, senza parziali/trailing/flat 19:30): si fa quando la sedia
  non ha niente di vivo.

---

## ⑦ (e) Il Guardian con una sedia in piu' — solo numeri, a 0,5% di BANCO

**Guardian in campo** (`mql5/Presets/ABTG_Guardian_FTMO_2Step.set`, chart06 di `C:\FTMO`): `InpStartBalance=80000` · pausa
giornaliera **3,5%** (2.800 €) · emergenza giornaliera **4,5%** (3.600 €) · emergenza totale **9,3%** (72.560 €) · **cap C1
4,00%** dell'**equity**, rischio misurato ingresso→SL (`InpRiskMode=0`), **solo sulle posizioni aperte** (include v1.20 r.27:
un pendente gia' piazzato scatta lo stesso). Letto nel Guardian **in campo** (`CLAU12_Guardian` v1.12 = `ABTG_Guardian.mq5` al
pin `d884f7e1`, scheletro 498 / `A457F2CD...`, `CODA_06` 27/09): dichiarazione r.78, somma `OpenRiskPct` r.171-199 (posizioni,
non ordini; `OrderCalcProfit` dal prezzo d'**apertura** allo SL), confronto **`riskPct >= InpMaxOpenRiskPct`** r.444. Lato EA
(include v1.20 `ABTG_GuardiaIngresso` r.282-319 + nucleo `ABTG_CapAttivo_Calc` r.114-119): l'EA legge **solo la bandiera** al momento del piazzamento (`TryPlace` r.346).
🔴 **Il rischio del NUOVO ordine NON viene sommato**: la domanda che il cap fa e' *"le posizioni gia' aperte valgono gia'
>= 4,00% dell'equity?"*, non *"aperte + nuova > 4,00%?"*. La taglia di ogni sedia e' % del **saldo**
all'ordine (`LotByRisk` r.733). Saldo di riferimento **75.090,72 €** [MISURATO, MetriX 26/09 09:15, `SEDIA_SHORT_DOW` §⑤].

| taglia | uno stop | | 
|---|---:|---|
| 0,5% (oro, banco) | **375,45 €** | |
| 2,0% (le altre sette) | 1.501,81 € | |

**Quante posizioni lascia passare il cap 4,00**, con tutte le altre a 2,00 e l'oro a 0,50 [DERIVATO dal codice qui sopra]:
- 🟢 **La sequenza della mattina non fa rifiutare la `770101`.** Oro pieno alle 09:00 (0,5) → la `770411` alle 09:59 vede
  **0,5 < 4,00** → entra → la `770101` vede **0,5 + 2,0 = 2,5 < 4,00** (se la `770411` e' gia' posizione; altrimenti 0,5) →
  **entra** → **4,50% in campo, tre posizioni**. L'ipotesi *"la terza al 2% viene rifiutata perche' 0,5 + 2 + 2 = 4,5 > 4,00"*
  e' **falsa**: somma il rischio della nuova, e il cap non lo fa.
- 🔴 **Quando invece l'oro FA rifiutare una sedia al 2%**: quando le posizioni gia' aperte SENZA l'oro valgono **X in
  [3,50% ; 4,00%)**. Esempio gia' scritto (`SEDIA_SHORT_DOW` §⑤.2): `771531` a due gambe ~1,98% + una sedia al 2,00% = **~3,98% <
  4,00** → senza oro la terza al 2% **entra** (→ ~5,98%); **con l'oro pieno** → 4,48% ≥ 4,00 → **rifiutata**. L'oro quindi lavora
  nei due versi: **aggiunge 0,5%** quando X < 3,50, **toglie una sedia al 2%** quando 3,50 ≤ X < 4,00. Quale delle due capiti,
  e quante volte, **[NON MISURATO]**.
- 🟠 `{2,0 ; 2,0}` **sta esattamente sul bordo** del `>=`, e il bordo non si decide coi valori nominali (classe 865): il lotto e'
  arrotondato **per difetto** (`LotByRisk` r.757 `MathFloor`: rischio vero ≤ 2,00% del saldo), lo slippage di un ordine
  **stop** lo spinge **sopra**, e il denominatore e' l'**equity** (P/L flottante nei due versi). Quindi *"la terza e' rifiutata"*
  e' **[NON DETERMINABILE a tavolino]**: con i numeri gia' derivati il 26/09 (~3,98%, `SEDIA_SHORT_DOW` §⑤.2) la terza **entra**.
- `{0,5 ; 2,0 ; 2,0}` allo stop = **3.379,08 €** = sotto l'emergenza giornaliera (3.600 €, margine **220,92 €**) ma **sopra
  la pausa** (2.800 €) e **sopra l'emergenza totale** vista dal saldo di oggi (**2.530,72 €** ai 72.560 €): gia' due stop
  al 2% (3.003,63 €) la superano (`SEDIA_SHORT_DOW` §⑤.1); l'oro aggiunge 375,45 € allo stesso esito, non lo crea.
- Con la `771531` che tiene una posizione dal weekend (~0,98%, ~735 €): `0,98 + 0,5 = 1,48 < 4,00` → la prima al 2% entra →
  `3,48 < 4,00` → **entra anche la seconda al 2%** → **~5,48%** in campo (senza l'oro: `0,98 + 2 = 2,98` → entra → ~4,98%).
  Qui l'oro **aggiunge**, non toglie.
- 🔴 **E se il cap rifiuta proprio l'oro alle 09:00** (posizioni H1 del Dow gia' ≥ 4,00%): `TryPlace` ritorna `false` (r.346),
  la fase **resta `MMP_WAIT`** e l'EA **riprova a ogni tick** (r.274-290), e il cutoff delle 10:30 vale solo in `MMP_PLACED`
  (r.258). Se il cap si libera **prima delle 10:30** (una posizione chiude, o va a pareggio dopo la prima parziale: con
  `InpRiskMode=0` il rischio dal prezzo d'apertura allo SL a pareggio vale zero), **il buy stop parte in ritardo** — un
  ingresso che il banco non ha mai misurato (nel tester il Guardian non c'e': fail-open). Dopo le 10:30 parte e il cutoff lo
  cancella al tick dopo. Frequenza **[NON MISURATA]**; e' lo stesso ramo della `770411`, che condivide la macchina a stati.

**L'ora d'armo, e la sovrapposizione [NON MISURATA]**: l'oro piazza il buy stop alle **09:00 FTMO** (08:00 IT), quando le sedie
d'apertura non hanno ancora armato; la `770411` (MaxMin DAX short) arma alle **09:59 FTMO** (`InpPlaceHour=9`, `InpPlaceMin=59`
nel suo preset FTMO = 08:59 IT); la `770101` (DAX Apertura long) alle **10:00 FTMO** (`InpSessionHour=10`). Tre sedie che
armano in **un'ora**, tutte con pendenti: il cap C1 le vede solo quando diventano posizioni; le due H1 sul Dow (`771531`,
`770511`) possono entrare a qualunque ora, oro compreso. Quante mattine l'oro e il DAX
scattano insieme, e in che verso, **nessun per-trade lo dice** (il per-trade dell'oro e quelli del DAX vengono da corse
separate): la sovrapposizione e' **[NON MISURATA]**, e il Monte Carlo dallo stato di oggi (`mc_challenge_ftmo_stato.py`)
non conosce l'oro.

**Frequenza**: 279 posizioni in 6,5 anni = **~3,6 al mese** (~0,12 per giorno di calendario, ~0,17 per giorno di borsa a
252/anno): la sedia da sola sta sotto il pavimento 1,00/giorno; il pavimento si misura per famiglia (firma 07/09).

---

## ⑧ (f) FTMO — cosa e' chiuso, cosa e' aperto, e il vincolo che pesa di piu'

1. ✅ **Posizioni opposte sullo STESSO conto: permesse per iscritto** (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md` r.7 e r.16:
   *"We allow hedging within the same trading account"*). Un long oro accanto a uno short DAX o Dow sul `541452707` non e'
   un problema di regolamento.
2. 🟠 **Gap trading: [DOMANDA APERTA 27/09]** (`report/MAIL_FTMO_TRE_DOMANDE_2026-09-27.md`, punto 2, risposta `[IN ATTESA]`).
   Per l'oro pesa meno che per il DAX [INFERITO]: la pausa giornaliera del metallo su FTMO e' **[NON MISURATA]** (su BCM
   ~1 ora), e il box 01:00-06:59 con piazzamento alle 09:00 sta lontano dalle chiusure; il lunedi' il buy stop arriva ore
   dopo la riapertura della domenica sera (quante, dipende dall'orario FTMO dell'oro, [NON MISURATO]). E "shortly after a
   market reopens" non ha ancora una definizione scritta da FTMO.
3. 🟠 **Straddle (punto 3 della stessa mail)**: **non riguarda questa sedia** — solo long = un solo buy stop, nessun OCO.
4. 🔴 **CROSS-ACCOUNT, ed e' il punto che decide**: FTMO il 25/09 (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` r.6) scrive che il
   divieto di esposizione opposta su un altro conto vale **anche per i demo e per altri broker**. Sul piccolo `50503392`
   (`CODA_01` 27/09, profilo `ORO`, 25 sedie) sono VIVE **quattro sedie oro**: `ABTG_MaxMinNotte XAUUSD M15 magic 770402
   rischio 0,5 L+S` (chart29), `PunteLarry XAUUSD 772343` (solo long), `EMA200_Ottimizzato XAUUSD 971501` (L+S),
   `SupertrendReversal_Ottimizzato XAUUSD 970901` (L+S); su Tickmill `Gold_Ichimoku_TK_ATR_EA XAUUSD M5 250604` (lati non
   letti dalla sonda: `-`); 🔴 **e sul manuale `50503635` (`C:\MT5_MANUALE`) `ABTG_ScalperDirezionale (4) XAUUSD M1 magic 779901`**
   (lati `-`), che il 25/09 non c'era (`SOSPENSIONE` r.83: *"zero sedie"*). **Zero sedie oro** nel profilo attivo di: 100k
   `50504263` (2 sedie, nessuna oro), REALE `10105439` (ORB EURAUD, Guardian, SlippageLogger), Pepperstone (0), banco `50504400`
   (0), FTMO `541452707` (9, nessuna XAUUSD). Di queste, quelle che possono stare **short** mentre il long FTMO e' aperto sono
   **cinque**: `770402`, `971501`, `970901` (L+S dal `.chr`) e `250604`, `779901` (lati ignoti = si trattano come L+S). La
   `772343` e' **solo long** = stesso verso (*"copying ... in the same direction is generally allowed"*, r.18-20). Due buchi
   dichiarati: **(i)** il **PC di backtest `DESKTOP-H4D7CAJ` e' loggato sullo stesso `50503392`** e le sue sedie la sonda notturna
   non le vede (`SOSPENSIONE` r.82, gia' successo il 14/08); **(ii)** FTMO conta anche gli strumenti **correlati** e non da'
   una lista (r.14-16): l'oro contro le sedie USD del piccolo (`BreakingBand`/`GapFill` EURUSD, GBPUSD, AUDUSD; `PostNews`
   USDJPY...) e' **[INFERITO, NON MISURATO]**. La
   sospensione del 25/09 (`SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` r.80) ha spento gli **indici** e ha scritto: *"le sedie
   oro/forex del piccolo restano accese. FTMO non ha sedie su quei simboli"*. **Il giorno in cui FTMO avra' una sedia oro
   quella frase smette di essere vera**: uno short della `770402` a due lati sul piccolo, aperto mentre il long FTMO e' in
   campo, e' la fattispecie letterale. Cosa fare delle sedie oro del piccolo, di Tickmill e del manuale **e' una firma di
   Claudio**, e 🔴 **e' un BLOCCO: senza, l'attacco (d) non si fa** — non una nota da leggere dopo.

---

## ⑨ ⚪ COSA RESTA NON VERIFICATO — per nome

- R268/R268d: **non letti**. Il DD del solo long a tick e sui 22 anni: **[NON MISURATO]**.
- Compilazione `ABTG_MaxMinNotte.mq5` @`7d0da9f9` contro include v1.20 `26a18566`: **[NON VERIFICATA]**.
- `InpMaxSpread=150` (contro 0 del banco): effetto **[NON MISURATO]**; commissione e slippage FTMO su XAUUSD: **[NON MISURATI]**.
- Orologio dell'oro: **[INFERITO]** = forex. 🔴 **Il preset SCADE il 24/10/2026**: BCM e' **UTC+1 fisso** (`OROLOGIO_BCM_2026-09-24`),
  FTMO passa a UTC+2 → il delta diventa **+1**, non resta +2 (la nota del preset a due lati, *"se cambiano nello stesso giorno il
  delta resta +2"*, e' del 20/09, **prima** di quella misura: superata). Se FTMO seguisse il DST americano, +2 fino al 01/11 e
  poi +1. E la cella R260a d'inverno **mescola due orologi** (BCM UTC+0 fino a dic-2024, UTC+1 dopo): quale ora FTMO replichi
  "il backtest" d'inverno **non e' deciso** — e cade nella stessa decisione di Claudio del 25/10 (CLAUDE.md, orologio BCM).
- 🟠 **Invariante della sedia**: `SelPos()` (r.772) usa `PositionSelect(_Symbol)`, che in hedging prende **la prima posizione
  XAUUSD del conto qualunque sia il magic**. Oggi su `541452707` non ce n'e' nessuna, quindi e' innocuo; **il giorno in cui su
  quel conto entra una seconda sedia XAUUSD (o un trade a mano sull'oro), cutoff, flat 19:30 e gestione leggono la posizione
  sbagliata**. Va scritto nel pacchetto firmato come condizione, non scoperto dopo.
- Magic `770421`: vergine su disco, su tutti i rami, nella storia git e in `CODA_01` al 27/09; **sul giornale del conto FTMO
  [NON VERIFICATO]** (non leggibile da qui). La scelta resta di Claudio.
- Sovrapposizione oro / `770411` / `770101` nella stessa ora: **[NON MISURATA]**; Monte Carlo senza l'oro.
- Taglia: **nessuna proposta**. 0,50 = banco. La tabella DD(taglia) a due formule (referto B §1.5) e' [DERIVATA] e OHLC.
- Gap trading FTMO: **[DOMANDA APERTA]**. Cross-account con le sedie oro del piccolo e di Tickmill: **decisione di Claudio**.
- La `770402` sul piccolo gira un binario v1.10 (540 righe, GUARD=no, 06/08): i suoi 2 trade forward **non sono del v1.11**.
- Gli stop nella sessione USA (52%, 1 su 7 da un dato USD): la manopola `InpCloseHour=13` BCM e' **R269a, in coda**; questo
  preset porta il flat delle 19:30 FTMO (17:30 BCM) come R260a, cioe' **la cella misurata, non quella "curata"**.

---

## ⑩ 📎 FONTI E IMPRONTE
- Preset BOZZA: `mql5/Presets/FTMO/BOZZA_CLAU12_MaxMinNotte_ORO_LONG_FTMO.set` — SHA256
  `e5bcabd52df9e6eefbee176e7eda7d5a582186feadd263c111b974a0de727a81`, 243 righe, marcatore `MARCATORE_BOZZA_ORO_LONG_FTMO_v2`
  (v1 al commit `8023d58e`; v2 = solo commenti dopo il cancello strato 2, valori identici), 53 input, ASCII puro, corpo generato da
  script dall'ordine degli input del sorgente e dai pin di R260a (diff contro R260a: 10 righe + `InpNewsCurrencies` assente in R260a = default `""`; contro il preset a due lati: 5).
  Diff rifatti a script dal cancello strato 2: identici.
- Sorgente: `mql5/Experts/ABTG_MaxMinNotte.mq5` HEAD `9b838084` = `7d0da9f9`, 918 righe, scheletro `32C692AD...146D`.
- Preset a due lati: `mql5/Presets/FTMO/ABTG_MaxMinNotte_ORO_770402_FTMO.set` (magic 770402, 2,00, MaxSpread 150).
- Guardian FTMO: `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` r.124 `InpMaxOpenRiskPct=4.00`.
- `CODA_01` / `CODA_06` del 27/09 03:30; `RINOMINA_CLAU12.ps1` r.129-135 e r.198-212; `RICOMPILA_CLAU12_TRAILFIX.ps1`
  r.1-110 e r.340-396; `SCHIERA_FTMO.ps1` r.175-186.
