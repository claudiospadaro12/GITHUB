
---

## 21/09/2026 — SEI ROUND SULLE TRE APERTURE (primo giorno di challenge FTMO)

Tutti sul **PC di backtest** `DESKTOP-H4D7CAJ` (firma di Claudio del 21/09: i round
non girano piu' sul VPS finche' una challenge e' viva), tick reali, banco 80.000.
🔵 **Nessuna manopola toccata in campo.** Le sedie hanno operato tutto il giorno
senza che nessuno ci mettesse mano.

| round | sedia | asse | esito | verdetto |
|---|---|---|---|---|
| **R196a** | `770260` Nasdaq | `InpMinRangePts` 0 / 7200 | GIRATO | 🟠 il pavimento compra DD e paga in frequenza (n −27/−33%). PF discordante. **Firma di Claudio**, non data |
| **R197A** | `770202` Dow | `InpEntryMode` breakout / retest | GIRATO | 🟢 **retest confermato**: costa il 15-20% degli ingressi e li ripaga. Col breakout l'IS va in perdita |
| **R197B** | `770202` Dow | `InpRetestOffsetPts` 0..600 | GIRATO | 🟢 **400 confermato** = centro altopiano + miglior DD OOS. La profondita' non costa ingressi |
| **R198** | `770260` Nasdaq | `InpRetestOffsetPts` 0..600 | GIRATO | 🔴 **lo 0 in campo e' l'unica cella positiva OOS.** IS e OOS opposti; la cella 600 fa DD OOS 26,1% |
| **R199A** | `770260` Nasdaq | `InpBEatR` 0..1,5 | GIRATO, 🕰️ **VERDETTO SCADUTO** | 🟢 `0,5` domina la cella viva **DI ALLORA**. 🔴 Il 21/09 alle 20:22 (`496408a9`) la firma ha acceso la parziale: quella configurazione non esiste piu'. Le 4 celle cadono **fuori dal dominio nuovo** (`0 < x < 0,5`, tetto `gBETk`). **Classe 577** |
| **R199B** | `770260` Nasdaq | `InpTP1_ClosePct` 0..75 | GIRATO | 🟢 **l'unica manopola di otto che dice SI**: `50` firmato e **in campo** dal 21/09 sera. Cella viva di oggi: IS 1,22116 · DD 7,3069 · n 135 — OOS 1,21546 · DD 7,8576 · n 172 |
| **R209a** | `770260` Nasdaq | `InpBEatR` 0..0,5 (passo 0,125) | ✅ **GATATO, da girare** | riempie il **dominio mai misurato** aperto dalla firma del 21/09. Ancora di regressione: la cella `0` deve riprodurre la riga `ClosePct=50` di R199B. Bersaglio: **PC di backtest** |
| R200b | `770260` Nasdaq | `InpTrailStartR` | 🛑 **RITIRATO** | la risposta era gia' in archivio (`..._OOS_r24.csv`): il DD sale in 5 righe su 5. E r.2224 dice `<= 0`: **0 e' il pavimento dell'asse** |

### In coda, gatati e non ancora girati
`R209a` (`InpBEatR` dentro `0-0,5`, Nasdaq — scritto il **22/09**).

🔴 **I sette che qui erano elencati come "in coda" (`R200c`, `R172d`, `R201a`, `R199b`,
`R200a`, `R200d`/`R200e`) SONO TUTTI GIRATI** fra le 21:05 e le 23:27 del 21/09. Il
registro era stato scritto a meta' giornata — **classe 576: lo stato di un round si legge
dall'archivio, non dal registro.**

### 🕰️ Riaperti dalla firma del 21/09 sera (parziale al 50% in campo sulla `770260`)
La firma tocca la **gestione dell'uscita**, quindi riapre i round sull'**uscita** e NON
quelli sull'**ingresso** (che scelgono quali operazioni esistono, e quelle non cambiano):
- 🔴 **riaperti davvero**: `R199A` (`InpBEatR` — dominio ristretto, vedi sopra → `R209a`) ·
  `R200b` (`InpTrailStartR`, ritirato su archivio a parziale SPENTA: dopo la parziale
  `InitialSL` r.2294 ripiega sull'ATR, quindi `profR` cambia denominatore) ·
  `R200c`/`R200a`/`R200e` (`InpTrailMode`/`InpTrailTF`/`InpTrailFixedPts`: il trailing ora
  gestisce **meta' posizione** partendo da uno stop gia' a pari — e' un altro mestiere);
- 🟢 **NON riaperti**: `R196a` (`InpMinRangePts`) e `R198` (`InpRetestOffsetPts`) — sono
  filtri d'**ingresso**, e l'insieme delle operazioni non cambia. R197/R198 avevano gia'
  misurato che *il DD si muove con l'uscita, non con l'ingresso*. Le loro classifiche
  furono decise con margini larghi (R198: lo `0` e' **l'unica** cella positiva OOS), quindi
  sopra il pavimento di rumore: **non si rifanno.**

### Cosa hanno prodotto, oltre ai verdetti
- 🔴 **Il no-op di `InpBreakevenAtTP1`**: incatenato a `InpTP1_ClosePct > 0`, in
  **16 file**. Sulla `770260` (`ClosePct=0`) e' **attivo**: quel flag non si puo'
  accendere. Prova in `risultati_prove/gestione_20260909/` — 36/36 righe identiche
  a parziale spenta, 15/36 diverse a parziale accesa.
- 🔴 **`InpTrailMode` e' la leva piu' grande mai misurata sul DD di questo EA**:
  stesse operazioni, stesso PF, DD da 17,65% a 7,17% (cella d'archivio, PF<1: vale
  lo span, non il livello). E' il prossimo round.
- 📌 Classi nuove in checklist: **538** (la riga su piu' righe fisiche: il `throw`
  non ferma le successive) · **539** · **540** (`-ArgumentList` non cita: uno spazio
  spezza il comando) · **541** · **542** · **543** · **544**.

---

## 🟠 R244 — GIRATO il 24/09: il cutoff NON allarga il corto di MaxMinNotte D30EUR (NON un morto)
- Ancora C=12 riprodotta alla cifra (101 / 1,40859; 157 / 0,74387), monotonia OK, **k = 1,42 misurato** dal per-trade (C=17).
- Corto: max **~105 posizioni** (C=17) < 150 -> merito sospeso. **PF marginale 12->17 = 0,588 su 48 deal** (indizio WHIPSAW: i riempimenti tardivi perdono). Il PF sale accorciando il cutoff, ma C<=10 sta sotto 50 posizioni.
- Lungo: PF 0,55-0,91 in ogni cella. DD corto 1,3-2,4% @0,65%.
- **Cosa manca al certificato**: asse `InpPlaceHour`, altri simboli, **TF (mai cambiato)**. Referto: `report/REFERTO_R244_2026-09-24.md`.

## 🟢 R245 — GIRATO il 24/09: altopiano `InpEmaSlow` 160-260, CENTRO 200 (aperto a destra)
- 6/6 rc 0, motore = pin, 28 min. **G0 GIALLO**: n identico in 32/32 ancore, PF/DD in deriva (lotto, r.2045) -> lettura SOLO interna.
- Cella al centro (200, TP 0,50): IS PF **1,252** n 154 DD 7,10% · OOS PF **1,489** n 197 DD 6,86% @1%. 140 cade solo su n IS 147. H1 (altopiano) confermata.
- Lati: si scambiano fra IS e OOS; allarme corto 2/6, non scatta. Coerenza e+f=b: OOS esatta, IS residuo 5-14 crescente con l'EMA (seme).
- Restano: DD a 2% ~14% [DERIVATO], costo 40x AL PELO, sovrapposizione con 770202 [NON MISURATA]. Referto: `report/REFERTO_R245_2026-09-24.md`.

## ⏳ R245 — il BORDO di `InpEmaSlow` sul breakout di apertura Dow (`ABTG_Nasdaq_Apertura_US`, U30USD M5) — PRONTO, NON ANCORA GIRATO (24/09/2026)
- Domanda: nell'archivio il blocco buono sta su EmaSlow 160/180/200 e **200 e' il bordo della griglia**: senza l'altro lato non c'e' un centro. R245 misura **140..260** (7 celle) x 4 TP + lati separati: **6 file, 42 celle, 84 passate**, magic 765241-765246, `-Deposito 10000` (banco d'archivio).
- Cancello G0 prima di tutto: le **32 celle d'ancora** 140-200 devono riprodurre l'archivio (n identico, PF +-0,0005). La riga controlla con **SHA256 dopo ogni job** che EA e include compilati siano quelli del pin `f489a621` (classe 166).
- 🟠 **Il costo e' AL PELO, e va detto accanto a qualunque numero**: stop mediano 123,75 idx = **41,25x** a spread 3,00; **212 giornate su 446 (47,5%)** sotto 40x (ricontato su `Studio_U30USD.csv`).
- File prova: PASS dello strato 2 dopo due correzioni (asse esteso anche a sinistra, esiti elencati per intero). Riga `backtest_pipeline/righe/RIGA_R245_DOW_EMASLOW.txt`: PASS dopo una correzione, **poi riaperta**: il controllo 166 era un fail-open (classe 753, variabile `$att` riusata), chiuso con `$sha166` e contro-esempio eseguito; ri-cancello: **PASS** (24/09 pomeriggio, harness eseguito: EA alterato -> DIVERSO).
- 🟢 **Pronte con PASS dello strato 2 (24/09)**: righe `RIGA_R243_SUPREV_ANCORADOW.txt` (pin `7e255a82`), `RIGA_R244_MAXMIN_RIEMPIMENTO.txt` (pin `223dc654`, raccoglie il PERTRADE per k), `RIGA_PASSATA_STOP_SUPREV.txt` (ripinnata `7e255a82`). 🟢 `RIGA_R214EF_COSTTOCOST.txt` (pin `529fefa0`): **PASS dello strato 2** (24/09 pomeriggio) su EA, file prova e riga. La colonna **Peggior Giornata FTMO %** usa l'orologio BCM a calendario (IT-1 con ora legale UE fino al cambio, poi UTC+1 fisso da `20250101`, dentro la forchetta misurata 27/12/2024-02/02/2025: al massimo 22 giorni di mercato ambigui). Il verdetto sul muro FTMO si legge da li'; quello del Guardian dalla colonna vecchia.
- ⚠️ Da annotare nel referto: il par. 10 di R245a (al pin) porta la stima vecchia del tempo (~10 min); **quella giusta e' 20-26 min, tetto 37-51**: stesso EA, stessa macchina, un solo agente.

---

## 🪦❌ R242 — `ABTG_MaxMinNotte` D30EUR M15, il box del GIORNO PRECEDENTE (24/09/2026)

**NON SI SCRIVE NESSUN MORTO.** Delle cinque caselle del certificato (09/09) ne manca
**una, la stessa sui due lati**: 🔴 **il TF non è mai stato cambiato** — M15 qui e in tutto
l'archivio `MaxMinNotte`. Verdetto corretto: **`NON ANCORA MISURATO SU ALTRI TF`**.

Tick reali, deposito 100.000, rischio 0,65%, 2024.09.26→2026.06.30, asse
`InpBoxStartHour` 0-18 passo 3 (box da 24h a 6h). Referto: `report/REFERTO_R242_2026-09-24.md`.
CSV: `backtest_pipeline/risultati_archivio/R242/`.

| lato | PF (min-max) | n | DD% | soglia congelata | esito |
|---|---|---|---|---|---|
| **LONG** | 0,732 - **0,941** | 134-188 | 4,14-6,34 | 3 contigue PF≥1,10, n≥150 | 🔴 **0 celle sopra 1,00.** Merito **leggibile** (5/7 con n≥150) e **negativo** |
| **SHORT** | 1,019 - **1,469** | 96-130 | **1,43**-5,63 | 3 contigue PF≥1,38, n≥150 | 🟠 **NON MISURATO**: run contigua **2** celle invece di 3, e **7/7 sotto n=150** |

### Il numero che chiude la domanda del round (lato long)
| | stop | × spread | PF |
|---|---:|---:|---:|
| archivio, cella appaiata | 38,7 idx | 22,8× | 0,7302 |
| R242 H=0 | ~272,5 idx | ~160× | **0,73216** |

👉 **Stop allargato 7 volte, PF mosso di +0,002** contro i +0,057 che prediceva la sola
rimozione del pedaggio. **Il costo non era la spiegazione del negativo del long**, e non lo
era nemmeno in parte misurabile. Questa è una casella **chiusa**, non sospesa.

### Perché lo SHORT torna in coda all'imbuto e non in archivio
È fermo su un numero **MANCANTE** (campione), non su uno **BRUTTO**: le due celle sopra
soglia lo sono su una soglia **alzata apposta** da 1,29 a 1,38 per escludere il pedaggio,
tutte e sette le celle sono in profitto, e **ogni cella dei due lati sta sotto il cancello
del 10% di DD**.
✏️ **CORRETTO IL 24/09**: qui c'era scritto che la via più corta era **allungare la finestra a
~4 anni**. 🔴 **È MORTA**: BCM su `D30EUR` parte dal **2024.09.26** ed è `COMPLETO` — il broker
non ha di più (misurato tre volte, `report/STORICO_MT5BACKTEST_ESITO_2026-09-08.md` r.38-40).
Fino a oggi si guadagnerebbe il **+14,3%**, che non basta.
👉 **La via vera è il TASSO DI RIEMPIMENTO** (`InpOneTradePerDay` mette un tetto di 1 al giorno, e
lo short riempie il 22-30% delle giornate): è il round **R244**, in preparazione.
🔴 **E serve per TUTTI E DUE I LATI, non solo lo short**: la colonna `Trades` conta **deal**, non
posizioni (`InpTP1Pct=50`), quindi in posizioni **nessuna cella di nessun lato** arriva a 150.
Vedi la correzione in testa a `report/REFERTO_R242_2026-09-24.md`.

### Cosa ha prodotto, oltre al verdetto
- 🔴 **Il controllo del pavimento è SCATTATO su tutti e due i lati** (monotonia di `n` rotta
  fra H=15 e H=18: long 188→134, short 130→110). `InpMinBoxPts=6800` morde all'estremo dei
  box stretti **almeno 2,3-2,7×** più del 3,9% modellato.
- 🔴 **Il modello di trasporto di `n` sovrastima in modo sistematico**: **14 celle su 14**
  sotto la previsione, e **7 su 7** dello short **fuori dalla banda dichiarata** (111-343).
  Va corretto prima di riusarlo per dimensionare un round.
- 🔴 **Il "DD atteso" era etichettato `[DERIVATO]` ma non era una previsione controllata**:
  riscalava una cella d'archivio con un altro `InpAtrSLmult` e un'altra scadenza.
  Sovrastimato 2,2-3,4×. Etichetta giusta: `[ANCORA DEBOLE]`.
- 📌 Classi nuove in checklist dal cancello su questa riga: **722** · **723** · **724** ·
  **725** · **726**.
