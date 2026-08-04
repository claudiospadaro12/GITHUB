# 🎯 CACCIA AL MOTORE GIUSTO — APERTURE M5 (Nasdaq **e** DAX = priorità appaiate; Dow bonus)

> **Impegno (Claudio, 02/08):** trovare il motore d'ingresso giusto per le aperture **Nasdaq M5 E DAX M5** (girerà ognuno in demo accanto al nativo, magic diverso). _"Dobbiamo farcela. È troppo importante. Lavoriamoci finché non troviamo la nostra strada."_
> ⚠️ NB carattere diverso: **Nasdaq = direzionale** (breakout/RETEST) · **DAX = whipsaw** (probabile RANGE-FADE o entrata ritardata). Stesso menu di motori, ma il vincitore può essere diverso per i due.
> Metodo: **sistematico, sui numeri (tick reali)**. Si prova un motore alla volta, si misura, si tiene traccia qui. Non si molla finché non clear-a la barra o i numeri non chiudono onestamente la questione.

## 🎚️ LA BARRA DA SUPERARE (tick reali M5)
- **PF ≥ ~1,3** su campione decente (non pochi trade) · **DD accettabile** · **% pass positivi alta** (robustezza) · gestione parziale+BE+trailing.
- Baseline da battere: **Nasdaq STOP = 0,82** (morto) · Dow STOP = 1,30 (col fix gestione).

## 🧰 MENU DEI MOTORI D'INGRESSO (da testare uno alla volta)
| # | Motore | Idea | Stato |
|---|---|---|---|
| 1 | **STOP breakout** | rompe il range → entra oltre (stop) | ❌ Nasdaq 0,88 · DAX 0,77 · Dow 1,30 (solo Dow vivo) |
| 2 | **RETEST** (limit) | rompe → rientra sul livello → limit | ❌ **BOCCIATO 02/08**: peggiora Dow (1,30→0,94), Nasdaq 0,73 (DD 27%), DAX 0,79. Selezione avversa (falsi break) |
| 3 | **RANGE-FADE** | fada gli estremi del range (vendi max, compra min) | ❌ **BOCCIATO 02/08 sul DAX**: PFmed 0,73, 0/136 pass sopra PF 1 (max 0,94), DD mediano 23,5% (quasi doppio degli altri). Il peggiore dei tre. Su Nasdaq/Dow non ancora girato |
| 4 | **ENTRATA RITARDATA/CONFERMATA** | entra dopo 15-30 min, quando la direzione è scelta | 🔄 **IMPLEMENTATO 02/08** (`InpEntryMode=DELAYED`, `InpDelayMinutes`, `InpDelayDirMode`). Entra **a MERCATO** → niente stop da inseguire = niente slippage di rottura. Test: `confronto_ritardata.ps1` |
| 5 | **GAP-FILL** | se apre in gap, opera verso la chiusura prec. | ⬜ già nel codice (InpEntryMode=GAPFILL), da testare |
| 6 | **FIRST-CANDLE follow** | segui la direzione della 1ª candela M5/M15 | 🔄 **IMPLEMENTATO 02/08** come sotto-modo del #4: `InpDelayDirMode=2` (direzione del corpo della candela di apertura). Nella griglia del test #4 |
| 7 | ~~ORB~~ | — | ➡️ **NON è un motore di questo EA: è una STRATEGIA A SÉ** (Emiliano: *"l'ORB è un'altra strategia che noi abbiamo"*), con un suo EA (`ABTG_ORB`). Spostato su `docs/piani_abtg/ORB_SCHEDA.md` |

## 🚨 SCOPERTA 02/08 — ABBIAMO TESTATO IL MOTORE **NUDO**, non il metodo di Emiliano
Controllo colonna per colonna dei CSV dei 3 test (400+ pass, breakout/retest/fade su DAX): **ogni filtro era SPENTO in tutti i pass**.

| Parametro | Nei nostri test | Emiliano (live 20/07 + trascrizioni apr–mag) |
|---|---|---|
| `InpUseVwapFilter` | **0** | acceso — VWAP M15 come spartiacque |
| `InpUseVolumeFilter` | **0** | **volume +50% sulla rottura** ("se mi apre sotto l'orb **e c'è un incremento dei volumi**, io lì lo shorto") |
| `InpUseEmaFilter` | **0** | medie **9/21 orientate** ("è una caratteristica importante avere le medie rivolte verso l'alto") |
| `InpUseSupertrend` | **0** | Supertrend 3.5 su D1 |
| `InpRangeMode` | **0** = range di apertura | anche **max/min della NOTTE** ("prendo i minimi da notte e prendo 10 punti") |
| `InpBufferPoints` | 100–400 = **1–4 punti indice** | **10 punti indice** (= 1000) |
| `InpRangeMinutes` | griglia 5–60 | **15 fisso** (prima candela M15), operativo **dalle 09:15 IT** |

**Conseguenza:** i verdetti (a) e (b) qui sotto restano validi — ma valgono per lo **scheletro** dei motori, non per il metodo di Emiliano. Il livello dei filtri (passo 5 della logica di caccia) **non è mai stato acceso in un backtest**.

I 5 pilastri di Emiliano sull'apertura DAX: (1) ORB prima candela 15 min · (2) max/min della notte + del giorno prima · (3) volume in aumento sulla rottura · (4) VWAP M15 + medie 9/21 · (5) ingresso sul **retest**, mai in corsa, con conferma multi-TF.

### 📑 SLIDE ARRIVATE (02/08) → analisi completa in `docs/live_emiliano/ANALISI_SLIDE_APERTURE.md`
Il PDF del corso («La Magia delle Aperture», ABTG, 41 pp.) dice **testuale**:
> *"**Entra subito dopo la chiusura della candela di breakout, non durante.**"* — e in checklist: *"Candela di rottura **chiusa** oltre il livello tecnico? Breakout confermato da **volumi** e price action? **ATR** conferma volatilità adeguata?"*

**Abbiamo testato l'esatto opposto**: ordini STOP riempiti *durante* la rottura, senza conferma di chiusura, senza volumi, senza ATR. Il metodo del corso **è** l'ingresso confermato = il motore `DELAYED` implementato ieri.

Due correzioni di rotta che ne derivano:
- **Nasdaq/Dow:** lo scheletro del nostro EA è **fedele** alle slide (ordini su max/min della **candela H1 precedente**, SL sui massimi precedenti, OCO, parziale+BE, trailing sulla base della candela M1). Manca solo il **livello dei filtri** (volumi/ATR/VWAP/correlazione SPX) e l'ingresso a size divisa.
- **DAX:** le slide europee **non prescrivono affatto un ORB**. Prescrivono livelli D1/W1/MN (Larry Williams), correlazione **225JPY → SPXUSD → D30EUR**, **Supertrend ×3 (2.5/3.0/3.5) tutti e tre concordi**, medie 89/100/200/14, Bollinger M15. Emiliano nelle live: *"l'ORB è **un'altra strategia** che noi abbiamo"*. → **stiamo testando bene la strategia sbagliata sul DAX.**

## 🔧 FILTRI DA SOVRAPPORRE (su ogni motore, uno alla volta)
- **VWAP di sessione** (Emiliano) — `InpUseVwapFilter` già opt-in.
- **Volume rottura** (Emiliano) — `InpUseVolumeFilter` già opt-in.
- **Ampiezza range** (min/max punti) — già presente (InpMinRangePts/MaxRangePts).
- **Ora specifica** (sotto-finestra dell'apertura più profittevole).
- **Direzione/bias** (solo long? solo short? filtro trend H1/H4?).
- **Volatilità/ADR** (opera solo se il range è nella banda giusta).

## 📋 REGISTRO PROVE (si aggiorna a ogni test)
| Data | Simbolo | Motore | Filtri | PF med | DD% | Trade | Esito |
|---|---|---|---|---|---|---|---|
| 02/08 | U30USD (Dow) | STOP | H4+fix gest. | 1,30 | 7,9 | 348 | 🟢 unico vivo (conto pers.) |
| 02/08 | U30USD (Dow) | RETEST | — | 0,94 | 11,0 | 452 | ❌ peggiora lo STOP |
| 02/08 | D30EUR (DAX) | STOP | — | 0,77 | 7,2 | 440 | ❌ morto (whipsaw) |
| 02/08 | D30EUR (DAX) | RETEST | — | 0,79 | 7,5 | 436 | ❌ morto |
| 02/08 | NASUSD | STOP | — | 0,88 | 14,5 | 328 | ❌ morto |
| 02/08 | NASUSD | RETEST | — | 0,73 | 26,9 | 455 | ❌ morto (DD 27%) |
| 02/08 | D30EUR (DAX) | **RANGE-FADE** | — | **0,73** | **23,5** | 440 | ❌ **il peggiore dei tre** (0 pass su 136 sopra PF 1, max 0,94; DD quasi doppio) |
| 02/08 | NASUSD | **STOP + CONFIG DOCUMENTI** | volumi+ATR+H4+corr+news, livelli H1 | **1,11–1,52** | 6,0–8,5 | **72** | 🟢 **SI RIBALTA** (era 0,88): 4/4 configurazioni sopra 1. ⚠️ campione sottile |
| 02/08 | U30USD (Dow) | **STOP + CONFIG DOCUMENTI** | idem | **1,11–1,21** | 11–13,8 | 106 | 🟡 **peggiora** il nudo (1,30) e alza il DD (7,9→13,5) |
| 02/08 | U30USD (Dow) | **RITARDATA + CONFIG DOC.** | idem | **0,66** | 8,3 | 116 | ❌ **morto**: 29 configurazioni distinte, TUTTE sotto 1 (max 0,98) |

### 🔑 VERDETTO 02/08 (a): famiglia BREAKOUT (stop+limit) ELIMINATA per DAX/Nasdaq apertura.
Solo **Dow STOP 1,30** sopravvive (conto personale). Il RETEST è selezione avversa (falsi break).

### 🔑 VERDETTO 02/08 (b): RANGE-FADE BOCCIATO sul DAX — l'ipotesi "whipsaw" è smentita.
Il fade doveva essere la risposta al DAX ballerino: è invece il **peggiore dei tre motori**. PFmed 0,73, **nessuna combo su 136 raggiunge PF 1** (massimo 0,94, −5.532 €) e il **DD mediano raddoppia** (23,5% contro 12,6–13,0%). Fadare l'estremo nei giorni in cui il DAX parte davvero = mettersi davanti al treno.
Trade ~440 in tutti e tre i motori → non è campione sottile né problema di fill: è **assenza di edge, misurata tre volte in tre modi opposti**.
Dettaglio: `backtest_pipeline/risultati_archivio/DAX_Apertura/ANALISI_MOTORI_DAX_M5.md` (+ i 3 CSV).
**Prossimo e quasi ultimo: entrata ritardata (#4).** Poi restano solo ORB-15 (#7) e gap-fill (#5).

### 🔑 VERDETTO 02/08 (c): sono i FILTRI, non il motore. Il Nasdaq si ribalta.
I tre motori bocciati erano stati testati **a filtri tutti spenti** — cioè non come li prescrivono i documenti. Rimesso il piano com'è scritto (livelli H1, volumi +50%, ATR ≥ media, trend H4, correlazione SPXUSD, filtro news, risk 2%):
- **NASUSD: da 0,88 a 1,11–1,52**, DD 6,0–8,5%, tutte e 4 le configurazioni sopra 1. **Primo segnale positivo vero sulle aperture.**
- **U30USD (Dow): peggiora.** 1,30 nudo → 1,11–1,21, e il DD sale da 7,9% a 13,5%. I filtri danneggiano il Dow.
- **Ingresso RITARDATO: morto** (29 configurazioni distinte, tutte sotto 1, max 0,98) → **le slide Nasdaq (ordini STOP) battono il PDF** ("entra dopo la chiusura della candela"). Conflitto fra le fonti risolto sui numeri.

⚠️ **Due riserve, entrambe serie:**
1. **Campione sottile**: 72 trade sul Nasdaq, sotto la soglia di ~80 che ci eravamo dati. Promettente ≠ validato.
2. **La griglia era quasi tutta finta**: 136 pass per **4 risultati distinti**. Con `InpRangeMode=2` il parametro `InpRangeMinutes` non fa nulla, e sul motore US il trailing è "base candela M1" quindi `InpTrailFixedPts` non fa nulla — ma MT5 li spazzolava lo stesso, ereditati da un'ottimizzazione precedente (il `.ini` non li inchiodava). ~97% del tempo di backtest sprecato a ricalcolare la stessa cosa.
**Corretto il 02/08**: la griglia `-Doc` ora inchioda i parametri inerti e spazzola quelli che mordono — **buffer 25→200 passo 25**, **InpVolMult 1,2/1,5/1,8**, **InpAtrFilterMult 0,8/1,0/1,2** (72 combinazioni vere).
_Nota: il PF decresce in modo monotòno al crescere del buffer su entrambi i simboli (miglior valore al minimo, 100) → comportamento coerente, non un picco isolato. Per questo la nuova griglia scende fino a 25._

### 🚨 VERDETTO 02/08 (d): i due run DAX `-Doc` sono DA BUTTARE (errore di configurazione mio)
| Run | PFmed | PFmax | trade | **perdita lorda per trade** |
|---|---|---|---|---|
| DAX doc_brk | 0,76 | 2,12 | 63 | **30 €** |
| DAX doc_delay | 0,81 | **142,63** (!) | 124 | **0,22 €** |
| _riferimento: DAX nudo_ | — | — | 429–440 | _75–106 €_ |
| _riferimento: US -Doc_ | — | — | 71–106 | _239–424 €_ |

Un PF di 142 su 88 trade con **19 € di perdite lorde totali** non è una strategia: è una divisione per quasi-zero. Causa: nella configurazione `-Doc` avevo lasciato `InpSLMode = SL_RANGE`, cioè **stop sul bordo opposto del range**. Con i livelli **D1** il bordo opposto è l'**intera giornata precedente** → stop enorme → lotto schiacciato al minimo → P&L insignificante.

I documenti dicono un'altra cosa: *"Stop Loss sempre vicino al punto di breakout utilizzando ATR, **5-10 punti** sotto/sopra la linea di breakout"*. Era il punto **#21** dell'audit, segnato "⚠️ da tarare" e poi non tarato.

**Corretto**: `-Doc` ora usa `InpSLMode=ATR` (mult 1,5), floor 500 punti = 5 punti indice, e `InpSkipIfTight=0` (sotto il floor **allarga** lo stop invece di saltare il trade, per non tagliare il campione).
**I run DAX vanno rifatti.** I run US **non** sono affetti (rischio per trade in linea o superiore al baseline): il risultato Nasdaq resta valido, con la sua riserva separata dei 72 trade.

### 🚨 SCOPERTA 03/08 — il PIANO UFFICIALE ABTG dà numeri che le slide non avevano
Arrivati i PDF `Piano_Trading__NASDAQ__ABTG` e `Piano_Trading__MAXMIN_ABTG` (in `docs/piani_abtg/`). Contengono le regole **quantificate**, e su due punti **non abbiamo mai testato quello che il piano prescrive**:

| Regola del piano ufficiale | Cosa abbiamo testato | Scarto |
|---|---|---|
| Canale = **MAX/MIN dei 15 minuti PRE-apertura** (15:25–15:30 CET) | max/min della **candela H1 precedente** | strategia diversa — `RangeMode=PREV` + `PrevWindowMin=15` **mai provato**, ed è già nel codice |
| Ordini pendenti a **+7 / +10 punti** dal livello | buffer **0,25 – 2 punti** indice | **3,5–40× più stretto**: entriamo su ogni falso break |
| Stop loss a **5 punti** | floor 5 punti indice | ✅ combacia |
| Break-even a **+30 punti** | stop in pari a **1R (~5 punti)** | spostiamo in pari **6× prima** → tagliamo i runner |
| RR minimo **1:2** | 1R + trailing | da allineare |
| Non entrare con **ostacolo tecnico entro 10–15 punti** | non implementato | la regola che evita gli ingressi destinati a sbattere |
| **«NON SI ADOTTA con bassi volumi o bassa volatilità»** | ✅ misurato: **i volumi contano, l'ATR no** | il piano aveva ragione a metà |

🔑 **Nota che combacia:** il filtro volumi che funziona legge la candela M5 **15:25–15:30** — cioè **esattamente la finestra del canale di riferimento del piano**. Non sembra un caso: l'informazione sta nella **pre-apertura**.

**Conseguenza operativa:** prima di dichiarare morto qualunque motore, va rifatto il test con **canale pre-apertura 15 min + buffer 7–10 punti**. È la configurazione del piano, e non l'abbiamo mai girata.

### ⭐ SCOPERTA 03/08 (2) — il ToolKit ORB America: 4 scarti su 4
`ToolKit_05_ORB_Apertura_America.pdf` è l'unico materiale ABTG con una **specifica chiusa**. E prescrive l'opposto di quello che abbiamo testato:

| Il ToolKit dice | Noi | Nota |
|---|---|---|
| range **30 minuti** | 15 min o candela H1 | il documento definisce il range 5 min *"sconsigliato"*, 30 min *"CONSIGLIATO"* |
| ingresso alla **CHIUSURA** della candela oltre il livello | ordini STOP riempiti **durante** | è l'**errore comune #1** del documento |
| filtro **EMA 9/21 su M5** + prezzo dalla parte giusta di entrambe | EMA **1/50 su H4** | TF e periodi diversi; la condizione sul prezzo non esiste nel codice |
| stop **mai spostato**, TP fisso 1:2 | parziale + BE + trailing | è l'**errore comune #3**: *"si imposta UNA volta e non si tocca più"* |

⚠️ **L'ingresso ritardato bocciato a 0,66 NON era questo**: decideva a un orario fisso (15/30/45 min), non *quando una candela chiude oltre il livello*, e girava senza EMA 9/21 e col range sbagliato. **Quella bocciatura non vale per l'ORB del ToolKit.**

Da scrivere: (1) motore "ingresso su chiusura confermata" con filtro sul corpo della candela; (2) condizione "prezzo dalla parte giusta di ENTRAMBE le medie" + caso neutro. Tutto il resto è già configurabile.

## 🧪 PROSSIMO TEST: L'ABLAZIONE DEI FILTRI (Nasdaq)
Il piano ha ribaltato il Nasdaq ma con 72 trade. Prima di crederci bisogna sapere **quale filtro porta l'edge e quale sta solo tagliando il campione**. La scala accende un filtro alla volta:

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/ablazione_nasdaq.ps1" | iex
```
1. soli **livelli H1** (nessun filtro) → 2. **+volumi** → 3. **+ATR** → 4. **+trend H4** → 5. **+correlazione** → 6. **+news** (piano completo)

**Come si legge:**
| Cosa vedi | Cosa significa |
|---|---|
| PF sale, trade calano poco | filtro **buono**, si tiene |
| PF fermo, trade crollano | filtro **inutile**, si toglie |
| PF sale ma trade crollano | ⚠️ è **selezione, non edge** — con pochi trade il PF non è un dato |

Il gradino 1 è il più importante: dice se l'edge viene già dai **livelli delle slide** (max/min candela H1 precedente) invece che dal range di apertura M5 che avevamo sempre usato. Se è così, la scoperta vera non sono i filtri ma **dove si guardano i livelli**.

## ▶️ IL TEST PRONTO ADESSO (PC di backtest, MT5 CHIUSO)
**ENTRATA RITARDATA / FIRST-CANDLE (motori #4 e #6)** — DAX + Dow + Nasdaq a tick reali:

```powershell
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/confronto_ritardata.ps1" | iex
```
Gira da solo la griglia **attesa 15/30/45 min × direzione break/mid/candela** (9 combo per simbolo).
Cartelle prodotte sul Desktop: `risultati_APERT_DAX_M5_delay_realtick` e `risultati_APERT_US_M5_delay_realtick` → zippa e caricamele.

_(Il fade su Nasdaq/Dow — `confronto_fade.ps1` — resta lanciabile, ma dopo il risultato DAX è a bassa priorità: servirebbe a chiudere formalmente il motore #3, non perché ci si aspetti un edge.)_

## 🧠 MENTALITÀ / CRITERIO DECISIONALE (continuare vs raffinare vs parcheggiare)
_Ottimismo rigoroso: si insiste finché ci sono ipotesi fondate; ci si ferma quando i numeri, ripetuti, dicono no. Ci si innamora del PROCESSO, non della strategia._

| Risultato tick reali | Cosa vuol dire | Cosa facciamo |
|---|---|---|
| **PF ≥ ~1,3** robusto | edge vero | tieni → raffina → demo/forward |
| **PF ~1,0-1,3** (pareggio) | il nucleo ha qualcosa | **RAFFINA con piccoli accorgimenti** (filtri: ora/VWAP/volume/ADR; SL-TP) — è il caso migliore per migliorare |
| **PF < ~0,9** su più varianti | rotto alla base | nessun accorgimento lo salva → **cambia motore** |
| **tutti i motori×filtri esauriti e nessuno ≥1,0** | l'apertura M5 non ha edge robusto | **PARCHEGGIA le aperture M5** (conto personale, nice-to-have) e concentra le forze sul **PROP H1** (dove l'edge c'è già). NON è arrendersi = è allocazione. |

_NB: una cosa che funziona c'è già — **Dow STOP 1,30** (conto personale). Non si parte da zero._

## 🧭 LOGICA DI CACCIA (come decidiamo il prossimo passo)
1. ~~Il RETEST batte lo STOP?~~ → **no, bocciato 02/08**.
2. ~~**RANGE-FADE** per il whipsaw~~ → **no, bocciato 02/08 sul DAX: il peggiore dei tre.**
3. Prova **ENTRATA RITARDATA / FIRST-CANDLE** (salta il rumore dei primi minuti) — implementato, ⬅️ **è il prossimo**.
4. Se anche questa fallisce → **ORB-15** (#7, `-RangeMin 15`) e **GAP-FILL** (#5) sono gli ultimi della famiglia.
5. Su ognuno, aggiungi **1 filtro alla volta** (VWAP → volume → ora → ADR) e rimisura.
6. Ogni risultato → riga nel registro sopra. **Si tiene solo ciò che regge i tick reali.**

> ⚠️ **Punto di onestà — CORRETTO il 02/08 dopo le slide.** Avevo scritto che se la ritardata fallisce si chiude la questione DAX. **Era prematuro.** I 3 motori bocciati sono stati testati **a filtri spenti** e, sul DAX, con una strategia (ORB) che il piano europeo non prescrive nemmeno. Quello che è morto è lo **scheletro nudo**, non il metodo del corso. Prima di chiudere vanno girati i test della lista sopra — a partire dalla ritardata **con volumi+ATR accesi**, che è ciò che il PDF prescrive testualmente. Se falliscono *quelli*, allora sì: si chiude sui numeri, ed è un risultato.
> Se nessun motore supera la barra su Nasdaq/DAX, il verdetto onesto è: **l'apertura M5 su quei due non ha edge** e resta solo il Dow STOP 1,30 per il conto personale. Chiudere la questione sui numeri è un risultato, non una sconfitta.

## ✅ Nota
- Il motore trovato girerà **in demo accanto al nativo** (magic diverso), come da regola.
- Vale anche per DAX (whipsaw → probabile range-fade) e Dow (già a 1,30).
- Priorità dichiarata: **Nasdaq**.
