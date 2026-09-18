# 🔬 R183 — LA CROCE DELLE SLIDE: **la casella è vuota, ma non è vuota come credevamo**

**18/09/2026** · dossier del cercatore di parametri · branch `lavoro`
Referto di partenza: `report/LE_SLIDE_NASDAQ_LA_CROCE_MAI_GIRATA_2026-09-18.md`
Criteri congelati: `backtest_pipeline/prove/R183_CROCE_SLIDE_CRITERI.md`
🚫 **Nessun backtest eseguito. Nessun EA, preset o forward toccato. `770201` resta SPENTA
e [SENZA CONTRATTO].**

---

## 🥇 LE TRE COSE DA SAPERE, IN ORDINE DI PESO

> ### ① ✅ **LA CASELLA È DAVVERO VUOTA** — ricontata a macchina, non creduta
> 368 CSV, **18.410 righe**. Su NASUSD, **tutte** le righe con almeno un filtro acceso
> hanno `InpEntryMode=0`: **610 righe, 610 volte breakout.** L'ingresso a CHIUSURA con un
> filtro acceso: **0 righe.**

> ### ② 🔴 **MA I VICINI DI CASELLA SONO MISURATI, E DICONO DI NO**
> Il primo giro del mio censimento li **aveva saltati**. Rifatto senza dedurre il simbolo
> dal nome del file, sono usciti due archivi che il referto di partenza non cita — e uno è
> un **walk-forward vero**: la conferma di volume su un ingresso confermato, sul Nasdaq,
> fa **IS 1,816 → OOS 0,956** con il campione **dimezzato**. Tre casi su tre.

> ### ③ 🔴 **DUE DEI TRE ASSI CHIESTI SONO INERTI, E NON PER POCO**
> `InpUseAtrFilter` e `InpConfirmMode` **non vengono mai letti** su `InpEntryMode=2`.
> Metterli ad asse avrebbe prodotto **8 passate identiche al centesimo**. Verificato nel
> sorgente, riga per riga. 👉 **Classe 431** della checklist.

---

## ① IL CENSIMENTO — e il contro-esempio che mi ha corretto

**Comando** (nel dossier perché si possa rifare): scansione di ogni `.csv` del repo
esclusi i worktree `.claude`, tenendo i file con la colonna `InpEntryMode`.

| | |
|---|---:|
| CSV nel repo (senza worktree) | **2.402** |
| di cui con `InpEntryMode` | **368** |
| righe di risultato lette | **18.410** |

**Su NASUSD, righe con ≥1 filtro acceso, per modalità d'ingresso:**

| `InpEntryMode` | righe |
|---|---:|
| **0 — breakout** | **610** |
| 1 · 2 · 3 · 4 · 5 | **0** |

Le righe NASUSD a ingresso **CHIUSURA** (`InpEntryMode=2` di `ABTG_Apertura_3Ingressi`)
sono **4**, tutte a filtri spenti (`R83n2`: **2 gemelle × 2 finestre**).
> 🧮 **Corretto prima della consegna.** La prima stesura diceva «8», moltiplicando *anche*
> per le due celle: ma le due celle di `R83n2` **sono** le due gemelle sul magic, non un
> fattore in più. Ricontato a macchina file per file: `..._IS_r83n2.csv` 2 righe +
> `..._OOS_r83n2.csv` 2 righe = **4**. Il verdetto (**casella vuota**) non cambia; il numero sì.

### 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO IL MIO STESSO CENSIMENTO

La prima versione dello script deduceva il **simbolo dal percorso del file**. Me lo sono
chiesto — *«quanti file NON hanno il simbolo nel nome?»* — e la risposta è stata **73**,
fra cui `Walkforward_Aperture/NASDAQ_*`. 🔴 **Quei file erano saltati in silenzio.**

Rifatto **senza nessun filtro di simbolo né di famiglia**, elencando per nome ogni riga
con `InpEntryMode ∉ {0,1}` di tutto il repo. Il verdetto sulla casella stretta **non è
cambiato** (è vuota davvero). Ma sono usciti **due archivi che cambiano l'attesa**.

> ✍️ **È la classe 430, applicata a me stesso**: la negazione di esistenza si confuta col
> `grep` del **valore nelle colonne**, non con la prosa dei referti. La regola è stata
> scritta stamattina da un altro agente e **oggi ha già ripagato il suo costo**.

---

## ② QUELLO CHE L'ARCHIVIO SAPEVA GIÀ — e che riscrive l'attesa del round

### (a) `risultati_archivio/Openconfirm/NASDAQ_openconfirm_M15.csv`
Core `ABTG_Nasdaq_Apertura_US`, magic `770201`, finestra piena 2024.01→2026.06, M15.
⚠️ **96 passate, 9 esiti distinti**: `InpTrailFixedPts` spazzolata su 8 valori **senza
mordere** — un caso da manuale delle 874 CSV a esito identico.

| motore | volumi OFF | volumi ON |
|---|---|---|
| OPENCONFIRM (5) | PF 0,868 · n=431 | PF 0,955 · n=403 |
| DELAYED (4) | PF 0,909 · n=204 | PF **1,200** · n=**99** |

### (b) `risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` 🔴
**È il dato che pesa di più: ha un taglio IS/OOS.**

| motore | volumi | **IS** PF · n | **OOS** PF · n |
|---|---|---|---|
| OPENCONFIRM (5) | OFF | 1,107 · 178 | 0,927 · 240 |
| OPENCONFIRM (5) | **ON** | **1,816** · 108 | **0,956** · 104 |
| DELAYED (4) | OFF | 1,013 · 184 | 0,890 · 247 |
| DELAYED (4) | **ON** | **1,710** · 56 | **0,696** · 51 |
| RETEST (2, enum del core) | **ON** | 1,145 · 91 | 1,109 · 94 |

> 🔴 **Tre casi su tre, la stessa firma: IS che brilla, OOS che non regge, campione
> dimezzato (240→104 · 247→51 · 240→94).** Quella è la firma del **SOVRA-FILTRO**, ed è
> **già misurata in casa**. E il `PF 1,200` del 05/08 su `DELAYED+volumi`, che a suo tempo
> sembrava «il tipo di coincidenza che di solito non è coincidenza», **fuori campione fa
> 0,696**. Era rumore, ed è documentato.

### ⚠️ I DUE ENUM NON SI CONFONDONO — ed è il difetto che questo paragrafo evita
| | `ABTG_Apertura_3Ingressi` | `ABTG_Nasdaq_Apertura_US` (r.149-157) |
|---|---|---|
| 0 | STOP (breakout) | BREAKOUT |
| 1 | LIMIT (retest) | GAPFILL |
| 2 | **CLOSECONF (chiusura)** | **RETEST** |
| 3 | — | RANGE_FADE |
| 4 | — | DELAYED |
| 5 | — | OPENCONFIRM |

🔴 **`InpEntryMode=2` vuol dire due cose diverse nei due EA**, e la mappatura del core l'ho
verificata **contro i numeri**, non contro i commenti: le righe `EM=3` del CSV coincidono
al centesimo con la riga RANGE_FADE di `Openconfirm/MOTORI_INGRESSO.md` (PF 0,745 · n=440),
e `EM=1` dà numeri **identici** a `EM=0` — che è esattamente ciò che il referto d'archivio
dichiara del GAPFILL con `InpUseGapFill=0`.
👉 **Nessuna riga d'archivio è l'ingresso a CHIUSURA: CLOSECONF non esiste nel core.**

---

## ③ 🔌 DUE DEI TRE ASSI CHIESTI SONO INERTI — verificato nel sorgente

Il compito chiedeva **volumi ON/OFF + ATR ON/OFF + `InpConfirmMode` OR/AND**.
🔴 **Due non si possono lanciare**, e non perché siano difficili: **perché uscirebbero
passate identiche.**

In `mql5/Experts/ABTG_Apertura_3Ingressi.mq5`:
- `InpUseAtrFilter` e `InpConfirmMode` vivono **solo** dentro `ConfirmOK()` (r.2518-2526);
- `ConfirmOK()` è chiamata in **quattro** punti: r.1116 `TryPlaceBreakout` · r.1208
  `TryPlaceRangeFade` · r.1314 `TryPlaceDelayed` · r.1764 gap fill;
- il ramo CLOSECONFIRM **non è nessuno dei quattro**: `MonitorCloseConfirm()` (r.1576)
  chiama **`VolumeOKtf(cftf)` a r.1594 e nient'altro**.

### Sul claim «`InpConfirmMode` è inerte sotto i due filtri, riga 2410»
✅ **VERIFICATO E VERO.** È r.**2410** di `ABTG_Nasdaq_Apertura_US.mq5` (r.**2525** nel
gemello `3Ingressi`), unica riga che lo legge, raggiungibile solo con **entrambi** i filtri
accesi.
🔴 **Ma su CLOSECONF è inerte per un motivo PIÙ FORTE, e la differenza conta**: quella riga
**non viene raggiunta mai, nemmeno accendendo tutti e due i filtri.** Fermarsi alla nota
nota farebbe concludere *«basta accenderne due e si sveglia»* — **l'opposto del vero**.

### ✅ E quello che invece MORDE su CLOSECONF
| manopola | morde? | dove |
|---|---|---|
| `InpUseVolumeFilter` · `InpVolMult` · `InpVolAvgBars` | ✅ SÌ | `VolumeOKtf` r.1594 |
| `InpUseEmaFilter` · `InpUseSupertrend` · `InpUseSupertrend3` · `InpUseCorrelation` · `InpUseVwapFilter` | ✅ SÌ | `TrendBias()` → `gBias` in `ArmCloseConfirm` |
| `InpUseAtrFilter` · `InpConfirmMode` | ❌ **NO** | `ConfirmOK()` mai chiamata su questo ramo |

📌 **Difetto di classe NUOVA registrato: `CHECKLIST_RIGA_DI_LANCIO.md` classe 431**
(numero cercato col grep prima di scriverlo: l'ultima era la **430**, di stamattina).

---

## 📐 LA GRIGLIA PROPOSTA — 11 celle, 22 passate

| file prova | asse (UNA variabile) | celle | magic |
|---|---|---:|---|
| `prove/R183a_volmult_closeconf_NASUSD.txt` | `InpVolMult` 1,00 / 1,25 / **1,50** / 1,75 / 2,00 | 5 | `779350` |
| `prove/R183b_volavgbars_closeconf_NASUSD.txt` | `InpVolAvgBars` 10 / **20** / 30 / 40 | 4 | `779360` |
| `prove/R183c_canarino_baseline_NASUSD.txt` | `InpMagic` (asse **tecnico**, gemelli, cancello G1) | 2 | `779370` · `779371` |

**In grassetto il valore DA DOCUMENTO** (*«volumi ×1,5 su 20 barre»*), messo al **centro**
apposta: un altopiano si legge solo con celle da tutte e due le parti.

✅ **`controlla_prova.py`: ESITO OK** — `file: 3 | celle totali: 11 | passate: 22 |
problemi: 0`.

🔎 **Magic VERGINI**, comando dichiarato e scritto anche dentro i file:
```
grep -rnoE --exclude-dir=.git --exclude-dir=.claude "7793[5-9][0-9]" .   →  0 occorrenze
```
⚠️ **E non collidono col round `R180u*`** che un altro agente stava scrivendo nella stessa
ora (magic `7774xx`/`7779xx`): è il motivo per cui questo round si chiama **R183**.

### 🔒 Le condizioni sono quelle di R83/R84, e non «più o meno»
Il corpo dei tre file è stato **estratto meccanicamente** dalle 78 righe `@`/`Inp` di
`prove/R83n2_conferma_NASUSD.txt` e modificato **solo** su asse e magic, con un'asserzione
che pretende **esattamente 1 sostituzione** per riga toccata.
→ `NASUSD` · `M15` · `@DAQUANDO 2024.09.26` · 14:30 server · range 15' · buffer 200 ·
`InpRangeMode=2` · `InpLevelTF=H1` · `InpOCTimeframe=0` · rischio 1% · TP1 1R 50% · BE ·
trailing candela M1 · slippage 0 · **modello 4, tick reali** · taglio IS/OOS **0,40**
(default, lo stesso che su R83n2 dà IS n=198 / OOS n=313, rapporto 0,387 ✓).

### 📉 Sul TIMEFRAME, col numero accanto
Il round resta su **M15**, **come R83/R84** — altrimenti i numeri non si appoggiano a
quelli e il confronto non esiste. Scendere a **M5** sugli indici sbatte contro la frontiera
del costo `stop ≥ 40 × spread`, ed è la stessa banda M30/H1 firmata l'08/09.
🕳️ **[NON MISURATO]**: lo spread medio di `NASUSD` sul banco non l'ho misurato in questa
sessione, quindi **non scrivo il numero della frontiera**. Qui il TF non è escluso «perché
basso»: è **tenuto fermo per confrontabilità**, che è una ragione diversa e va detta così.

---

## 🎯 L'ATTESA, DICHIARATA PRIMA DEI NUMERI

**Baseline** (`R83n2`, stesso EA, filtri spenti):
**IS PF 0,70462 · n=198 · DD 9,4841** | **OOS PF 0,97849 · n=313 · DD 6,1775**

| grandezza | attesa | da dove |
|---|---|---|
| `n` OOS a `InpVolMult=1,50` | **110 – 175** | i tre walk-forward di §② tagliano il 47-79% |
| `n` OOS a `InpVolMult=1,00` | **> 250** | soglia ≈ media |
| **PF OOS** migliore cella | **1,00 – 1,10** | nessun precedente misurato supera 1,11 |
| **PF IS** migliore cella | **1,10 – 1,85** | ed è **il numero di cui non mi fido** |
| **DD OOS** | **≤ 6,18%** | in 5 precedenti su 5 i volumi abbassano il DD |

> 🎯 **Previsione onesta, scritta prima:** il round finirà con **«sovra-filtro»** oppure con
> **«il default nudo va bene uguale»**. Probabilità di una cella con **PF OOS ≥ 1,10 E
> n ≥ 150**: **bassa.**
> 💪 **E vale lo stesso i suoi ~5 minuti**, per due motivi che non sono entusiasmo: oggi
> quella frase è un'**ipotesi**, domani è una **misura**; e la sensibilità a `InpVolMult`
> sul Nasdaq **non esiste in archivio** — `R84BIS_B1/B2` la preparava il 18/08 e
> **non è mai stata girata** (zero CSV nel repo, verificato).

---

## 🚦 LE SOGLIE, CONGELATE PRIMA (estratto — versione piena nei criteri §5)

1. 🔴 **`n` OOS ≥ 150** → sotto, il **MERITO è sospeso**. Il **RISCHIO** si legge sempre.
2. 🔴 **ANTI-SOVRA-FILTRO: `n` OOS ≥ 157** (50% dei 313). PF su + `n` sotto metà =
   **«sovra-filtro»**, mai «scoperta».
3. 📐 **ALTOPIANO, MAI IL PICCO**: centro di **≥3 celle contigue** che passano (1) e (2).
   Una cella che sporge da sola → **«non c'è una configurazione robusta»**.
4. Segno **non ribaltato** IS/OOS.
5. **DD OOS > 6,18%** → non può dirsi migliore della baseline, nemmeno con PF più alto.
6. 🔁 **Confronto col DEFAULT obbligatorio**: entro ±0,05 da 0,978 → **«i filtri non
   aggiungono: la baseline nuda va bene uguale»**. ✅ **È un risultato.**
7. **Cancello G1**: `R183c` non riproduce R83n2 al centesimo → **ci si ferma**, e non si
   «aggiusta» la baseline.
8. 🚫 **R183 NON PROMUOVE NIENTE**: 21 mesi, un regime e mezzo (Emendamento C).

---

## 🕵️ IL CONTRO-ESEMPIO — che cosa vedrei se i filtri **tagliassero** invece di aggiungere

🔴 **È l'ipotesi PIÙ probabile.** Le due spiegazioni sono distinguibili **prima**:

| | **AGGIUNGE edge** | **TAGLIA e basta** |
|---|---|---|
| PF lungo `InpVolMult` | sale e **si stabilizza**: **ottimo interno** | sale **monotono** fino all'ultima cella |
| `n` | scende **poco** | scende **molto**, in proporzione al PF |
| IS vs OOS | regge su **tutte e due** | **l'IS esplode, l'OOS no** |
| payoff per operazione | sale | ~fermo: si campiona meno, non meglio |

🔢 **Il modello del sovra-filtro è già misurato in casa**: `DELAYED+volumi` su NASUSD,
**IS PF 1,710 n=56 → OOS PF 0,696 n=51**. Se R183 riproduce **quella** firma, il verdetto è
**«sovra-filtro»**, *non* «il metodo del corso funziona» — **anche e soprattutto se il PF è
bello.**

🧪 **Applicato meccanicamente, non a occhio**: PF monotono crescente **e** `n` monotono
decrescente **senza ottimo interno** → **taglio**, si scrive «taglio», qualunque sia il PF.
E se `ΔPF / Δ(-n)` è ~costante lungo l'asse, il filtro **rimuove campione**, non
**seleziona**: un filtro che seleziona ha un punto in cui smette di pagare.

⚠️ **E vale contro di me**: `R183b` esiste apposta per **rompere** un eventuale risultato di
`R183a`. Se la conferma funziona solo con `InpVolAvgBars=20` e non con 10/30/40, **non è una
conferma di volume: è una coincidenza su una lunghezza di media.**

---

## 💰 IL COSTO — **stima**, con la base dichiarata

**11 celle × 2 finestre = 22 passate MT5**, più **6 avvii** (3 file × 2 finestre).

**Base** (misure vere, `report/CODA_NOTTE_2_2026-09-12.md` r.292-294):
`R88a` **0,083 min/passata** (tick reali, M5, 21 mesi) · `R112` **0,375 min/passata**
(stesso EA/simbolo/finestra/modello, ma **gambe separate**: l'avvio pesa più della corsa).
R183 gira su **M15** (un terzo delle barre di M5) ma con **6 gambe**.

> 💰 **STIMA: 2 – 9 minuti macchina** (22 × 0,083 = 1,8 min · 22 × 0,375 = 8,3 min + avvii).
> ⚠️ **Stima, non misura**: il tempo vero è **[NON MISURATO]**. Oltre i 15 minuti,
> qualcosa non va (probabile: tick non in cache).

**Dove**: 🖥️ **PC di BACKTEST**, mai sul VPS. 🚫 **Questo dossier non contiene e non
autorizza nessuna riga di lancio**: la riga la scrive chi la lancia e passa dal cancello
(`controlla_riga.py` + agente `controllo-preventivo`) **prima** di uscire.

---

## 🕳️ I BUCHI, DICHIARATI

1. 🔴 **La metà ATR della regola delle slide non è misurabile col codice di oggi.**
   Serve **una riga** in `MonitorCloseConfirm()` (`VolumeOKtf(cftf)` → `ConfirmOK()`), che
   risveglierebbe **anche** `InpConfirmMode` OR/AND. 🚫 **Questo round non la scrive.**
   👉 **Decisione di Claudio**, ed è la differenza fra misurare *metà* della regola del
   corso e misurarla *tutta*.
2. **Le slide dicono «volumi ​**O**​ ATR»**: R183 misura **il primo ramo soltanto**. Un
   esito negativo **non chiude** la domanda delle slide: la **dimezza**.
3. **Profondità dei TICK degli indici a BCM: mai misurata** (difetto n.18). Il `2024.09.26`
   è la profondità delle **BARRE**. Se i tick partono dopo, **la finestra si riscrive**.
4. **Un regime e mezzo**: niente 2020, niente 2022.
5. **Spread medio `NASUSD` sul banco: [NON MISURATO]** in questa sessione.
6. **La size frazionata** delle slide non esiste nel codice delle aperture: fuori da R183.

---

## 🟢 E LA BUONA NOTIZIA, che va detta insieme al resto

Non abbiamo perso niente: **il buco c'era davvero**, e in più l'archivio ci ha **regalato
tre walk-forward** che nessuno stava usando e che oggi ci fanno partire con l'attesa
giusta invece che con la speranza. 🎯 **Cinque minuti di macchina per trasformare
un'ipotesi in una misura, con i criteri già congelati e i cancelli già passati: è
esattamente il tipo di lavoro che il 1° ottobre premia.**

---
*Fonti: censimento 18/09 su 368 CSV / 18.410 righe ·
`mql5/Experts/ABTG_Apertura_3Ingressi.mq5` r.1116/1208/1314/1576/1594/1764/2518-2526 ·
`mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` r.149-157/2403-2410 ·
`risultati_archivio/{r83_csv,r84_csv}/` ·
`risultati_archivio/Openconfirm/{NASDAQ_openconfirm_M15.csv, MOTORI_INGRESSO.md}` ·
`risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` ·
`prove/R84_ABLAZIONE_CRITERI.md` · `report/CODA_NOTTE_2_2026-09-12.md` r.292-294 ·
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` classi 430 e 431.*
