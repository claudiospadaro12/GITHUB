# REGISTRO TEST EA — DAX / Nasdaq / Oro
_Documento vivo: aggiornato ad ogni nuovo backtest. Pensato anche per condividere i parametri con Emiliano e farsi consigliare._

## Contesto fisso (per tutti i test)
- **Conto:** DEMO BCM Markets 50503392, tipo **HEDGING**. Server **BCM = ora italiana − 1** (DAX apre 08:00 server, Nasdaq 14:30 server).
- **Periodo backtest:** 01.01.2024 → 30.06.2026 (2,5 anni).
- **Deposito:** 10.000 €. **Rischio per trade:** 1% (per confronto pulito; in live si alza dopo forward).
- **Modelli:** *OHLC 1-min* = screen veloce (affidabile su H1/H4, ottimista su M5/breakout intraday). *Real tick* = verità (obbligatorio per validare).
- **Criterio ottimizzazione:** Recovery Factor.
- **Regola:** gli `_Ottimizzato` girano in parallelo agli originali (magic diversi). NIENTE hedging/martingala.

🔴 **CORRETTO IL 22-23/09/2026 — LA RIGA «2,5 ANNI» QUI SOPRA E' FALSA SUGLI INDICI.**
Lo storico BCM degli indici **parte dal 2024.09.26**, non dal 2024.01.01: la finestra vera
e' di **21 mesi**, non 30. Misura: `risultati_archivio/misura_tick/REFERTO_MISURA_TICK_U30USD.txt`.
👉 Ogni riga di questo registro etichettata «2024.01» su un indice va letta come
**2024.09.26 → 2026.06.30**. Non e' un dettaglio di forma: l'etichetta sbagliata ha
prodotto la frase *«IS di 18 mesi»* per finestre che di mesi ne hanno **9,15**.

---

## 0) 📏 COME SI LEGGE QUESTO REGISTRO — le tre colonne che mancavano a tutti (aggiunto il 22-23/09/2026)

**Nasce da un difetto di metodo misurato il 22/09**: la classifica dei candidati mescolava
numeri OHLC e numeri a tick, e separandoli il censimento del 09/09 **perde 3 dei suoi primi
12 posti**. Da qui in avanti nessun numero di questo registro sta da solo.

### 📊 (1) IL **MODELLO** VA ACCANTO AL PF, SEMPRE
- `Modello 1` / `OHLC 1-min` = **screening**. `Modello 4` / `tick reali` = **verdetto**.
- 🔴 **Il fattore misurato in casa e' 1,71-1,85 IN ECCESSO**, e sono due misure indipendenti
  sulla stessa famiglia: `ABTG_DAX_Live5m` D30EUR OOS **1,46853 OHLC → 0,85701 tick**
  (fattore **1,714**) e `ABTG_DAX_Live5m_v2` D30EUR OOS **1,71088 → 0,92490** (fattore
  **1,850**, cella cancello `1500/4000`, `risultati_prove/ABTG_DAX_Live5m_v2/ABTG_DAX_Live5m_v2_D30EUR_OOS{,_ohlc}.csv`). Fonti: `risultati_prove/ABTG_DAX_Live5m/ABTG_DAX_Live5m_D30EUR_OOS{,_ohlc}.csv`.
  Sul Nasdaq lo scarto arriva a **2,25** (`ABTG_Nasdaq_Live5m_NASUSD_OOS{,_ohlc}.csv`:
  2,16249 → 0,96265).
- ➡️ **Un PF OHLC non boccia e non promuove.** L'unica eccezione gia' agli atti (r.2543): uno
  **zero** OHLC su un campione largo vale come chiusura, perche' l'errore e' ottimista e un
  modello ottimista che non trova niente non sta nascondendo un edge.

### ⚖️ (2) OGNI **DD** PORTA ACCANTO IL SUO `InpRiskPercent`
- **Il campo FTMO gira al 2,00%.** Il fattore misurato in casa fra 1% e 2% e' **1,956-1,990**.
- 🔴 Un DD scritto senza il rischio **non e' confrontabile col muro del 10%**. Esempio vivo:
  `dow_walkforward_OOS.csv` fa **8,70% @ 1,00%** = **17,0-17,3% alla taglia di campo**, cioe'
  **sopra il muro** — lo stesso numero, letto giusto, cambia verdetto.

### ✅ (3) IL **CERTIFICATO DI MORTE** (regola del 09/09) IN CINQUE CASELLE
Un candidato **non si archivia come MORTO** se manca anche una di queste:
**①** un **PF** misurato · **②** un **n** e un **DD** · **③** la **gestione dell'uscita**
messa ad asse almeno una volta · **④** i **simboli gemelli** provati · **⑤** il **TF**
cambiato almeno una volta.
- 🔴 **Il punto ⑤ pesa come gli altri quattro insieme** (direttiva di Claudio del 22/09:
  *«DA PROVARE IN + TF MI RACCOMANDO, OGNI STRATEGIA»*). Se manca, il verdetto e'
  **⚪ NON ANCORA MISURATO** con scritto **COSA MANCA** — mai 🔴 morto.
- 📌 **Il punto ⑤ si scrive ELENCANDO I TF PER NOME** (*«solo M5»*, *«M5 e M15»*), mai un
  si/no. E **il TF che conta e' quello che entra nei numeri**, non sempre quello del grafico:
  su parecchi motori la manopola che morde e' `InpLevelTF`, `InpTriggerTF`, `InpTrailTF`,
  `InpMgmtTF`, `InpExecTF` o la larghezza della finestra d'ingresso.
- 🟢 **E dove una manopola di TF NON ESISTE nel codice** (timeframe cablati), il punto ⑤ e'
  **NON APPLICABILE, con le righe del sorgente citate** — non «mancante».

### 🌍 (4) LO STORICO ESTERNO — *«ABBIAMO SCARICATO LO STORICO DA ALTRI SITI SIA SU ORO CHE SU INDICI»* (Claudio, 23/09/2026)
🔴 **Ovunque questo registro scriva «prova di regime non possibile / storico troppo corto»,
quella frase e' VERA sugli INDICI BCM e FALSA su FOREX e ORO.** Vanno distinte, altrimenti
il registro dichiara impossibile una misura che si puo' fare domani.
Mappa completa (non duplicata qui): `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`.

| famiglia | storico esterno | cancello ZERO (soglia **0,05%** di differenza media) | fonte |
|---|---|---|---|
| **FOREX** `EURUSD_EXT` `GBPUSD_EXT` `USDJPY_EXT` `EURJPY_EXT` `AUDJPY_EXT` `CHFJPY_EXT` `GBPCAD_EXT` | 🟢 **SI — promossi dal 14-15/08/2026** | **0,0041-0,0090%** · copertura **99,5-99,6%** · shift **+5h** su 8 su 8 | `risultati_archivio/REFERTO_IMPORT_6_SIMBOLI.md` |
| **ORO** `XAUUSD_EXT` | 🟢 **SI — promosso il 15/08/2026** | **0,0110%** (cinque volte sotto la soglia) · copertura **99,2%** | id. |
| **ORO su disco** (M1) | 🟢 **SI** — **4.884.366 barre M1**, **2006-03-19 → 2020-05-14**, 0 righe scartate, 0 OHLC incoerenti; piu' gli zip 2021→2026 | — | `risultati_prove/SONDA_FADE_ORO_2006_2020.txt` r.27 · `report/ORO_FADE_0930_LA_MISURA_2026-09-22.md` |
| **INDICI** `NASUSD_EXT` | 🟠 **IN FRIGO** — **5.233.590 barre M1 dal 2010.11.14** (~16 anni) ma diff media **0,0756% > 0,05%** | 🔴 `DIFFERENZE FEED APPREZZABILI` | `risultati_archivio/STORICO_INDICI_20260826_2334/ABTG_ImportEsterno_referto.csv` |
| **INDICI** `SPXUSD_EXT` | 🟠 **IN FRIGO** — **4.598.932 barre M1 dal 2010.11.14**, diff media **0,0608% > 0,05%** | 🔴 id. | id. |
| **INDICI** `D30EUR` (DAX) · `U30USD` (Dow) | 🔴 **NON IMPORTATI** — nessuna riga nel referto d'import | — | id. (il file contiene solo NASUSD e SPXUSD) |

🔴 **E IL VINCOLO CHE VA SCRITTO OGNI VOLTA CHE SI CITA UN `_EXT`: quel feed e' fatto di
BARRE M1, NON DI TICK.** Una corsa su `_EXT` **non e' modello 4**, e per il punto (1) qui
sopra il fattore OHLC→tick misurato in casa e' **1,71-1,85 in eccesso**.
👉 **Un numero `_EXT` non si confronta direttamente con un numero a tick**: apre una prova di
REGIME (Emendamento C del 16/08), **non** un verdetto di merito.
🟢 Conseguenza operativa: sui motori **forex e oro** la frase *«la prova di regime non e'
possibile»* va cancellata e sostituita con il costo della corsa. Sugli **indici** resta vera,
e la ragione e' il banco (storico BCM dal **2024.09.26** = **un regime e mezzo**), non il motore.

---

## 1) APERTURE (breakout apertura mercato)

| # | EA | Sym | TF/finestra | Config chiave | Modello | Risultato | Verdetto |
|---|---|---|---|---|---|---|---|
| A1 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **entrambe + Supertrend ON**, buffer 200-600, floor 200 | real tick | 3% combo pos, best PF 1.03 | 🔴 morto (config sbagliata) |
| A2 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **SOLO LONG, ST OFF**, buffer 600, floor 200 | real tick | **PF 1.49 (avg 1.25), DD 3.8%, 314 tr**, cluster 100% pos | 🟢 **KEEPER** |
| A3 | DAX_Apertura_EU | D30EUR | range 15 min, ora 8 | **SOLO SHORT**, ST OFF, buffer 200-600 | real tick | — | ⏳ ~~in coda~~ ✏️ 25/09: **superata dalla FASE M del 07/08** (solo short, retest, range 25/35/45: IS PF 0,77-0,85) |
| A4 | Nasdaq_Apertura_US `770260` | NASUSD | candela H1 prec, ora 14:30 | **la griglia del 26/07**: SOLO LONG, floor 0-400, buffer 50-350 | real tick | 0% combo pos, best PF 0.91 | 🟢 **VIVA — E OPERA IN CHALLENGE.** ✏️ **RISCRITTO IL 22-23/09/2026.** Il *«🔴 morto»* del 26/07 **resta vero per la sua griglia** (breakout cieco LONG-only), ma **non e' il verdetto del motore**: la cella che sta operando su FTMO `541452707` e' un'**ALTRA configurazione** — `InpEntryMode=2` (**RETEST**), `InpRangeMinutes=35`, `InpBufferPoints=200`, **due lati**, `InpRetestOffsetPts=0`, `InpTP1_R=0,5`, **`InpTP1_ClosePct=50`**, `InpBEatR=0`, `InpTrailMode=1`, `InpTrailTF=M5`, `InpUseVolumeFilter=true`, **`InpRiskPercent=2,00`** (preset `mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set`). 📊 **Numeri di QUELLA cella, a tick reali, banco 80.000, taglia 2,00% = la taglia di campo** (`risultati_prove/R199B/ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_R199B.csv`, Pass 2): **IS PF 1,22116 · n 135 `[uscite]` · DD 7,3069%** · **OOS PF 1,21546 · n 172 `[uscite]` = 102 posizioni · DD 7,8576%**. 🟢 **Il DD e' SOTTO il muro del 10% ALLA TAGLIA VERA**, senza raddoppiare niente. 🔴 **Ma il MERITO resta SOSPESO**: 102 posizioni < 150 (Emendamento A). ⚪ **Certificato:** ① ✅ · ② ✅ · ③ ✅ (8 manopole d'uscita ad asse il 20-21/09: R199A/B, R200A/C/E) · ④ 🟡 **PARZIALE, e la prima stesura di questa riga sbagliava**: `ABTG_Nasdaq_Apertura_US` ha CSV **solo su NASUSD** (verificato su tutta la storia di git). I gemelli esistono per il **MECCANISMO** (`ABTG_DAX_Apertura_EU` su D30EUR/100GBP/F40EUR, `ABTG_Dow_Apertura_US` su U30USD), **non per questo binario** · ⑤ 🟡 **PARZIALE — TF provati per nome: grafico solo M5; `InpTrailTF` M1·M2·M3·M4·M5·M6·M10·M12·M15 (R200A, e M5 vince); `InpLevelTF` MAI mosso (H1 in tutti i CSV); `InpSessionHour` MAI ad asse**. 👉 Verdetto d'insieme: **VIVA IN CAMPO, merito sospeso per campione, ⑤ da isolare.** |
| A5 | DAX + Nasdaq "stile Monza" | D30EUR/NASUSD | candela 5-min pre-apertura | **direzione ADATTIVA Supertrend D1** + filtro 17-40 pt + floor | real tick | — | ⏳ in coda |
| A16 | `Nasdaq_PreOpen_Breakout_EA.mq5` (**ESTERNO**, caricato da Claudio il 12/09/2026, magic 20260617) | NASUSD | M5, candela 15:25-15:30 **Roma** = 14:25-14:30 **server** | buffer 7 idx, MinRange 17 idx, **nessun tetto di ampiezza**, stop al bordo opposto, target **FISSO** +50 pt + 50% a +20 pt, EMA50 pesa 70/30, nessun filtro spread, nessuna news, **nessun Guardian** | **non girato** | — | 🔴 **NON SI SCHIERA** — e il motivo che basta da solo **non e' il PF**: **(1)** `InpLocalUtcOffsetHours=2` **CABLATO** + ancoraggio a **Roma** anziche' alla borsa → dal **1 nov 2026 al 14 mar 2027** (~95 sedute) arma sulla candela delle 14:25, **un'ora prima, IN SILENZIO** — cioe' **dentro la fase funded**; **(2)** COSTO: stop minimo **13,33x** lo spread misurato (pavimento duro 13,3x), **12,63x** al P95. ⚠️ L'ingresso e' **la stessa FAMIGLIA** di `ABTG_Nasdaq_Live5m` `770203` — **non "identico"**: casa include la barra M1 dell'apertura (r.600-625) e l'esterno tratta un **sovrainsieme** di giornate (nessun tetto a 40) → vedi **L2**, che e' ⚪ NON ANCORA MISURATO. 12/09/2026 · `report/AUDIT_NASDAQ_PREOPEN_2026-09-12.md` · `report/PREOPEN_NASDAQ_VALE_UN_POSTO_2026-09-12.md` · `report/PREOPEN_NASDAQ_IL_VERDETTO_2026-09-12.md` |

**A2 = configurazione vincente DAX aperture (da discutere con Emiliano):**
`Ora apertura 8:00 server | Range 15 min | Buffer 600 pt (6 punti indice) | SOLO LONG | Supertrend OFF | Floor SL 200 pt | Slippage 100 pt | Rischio 1%`
→ già messa nell'EA `ABTG_DAX_Apertura_EU_Ottimizzato` (magic 770111).

---

## 2) LIVE 5 MINUTI (rottura candela pre-apertura)

| # | EA | Sym | Config | Modello | Risultato | Verdetto |
|---|---|---|---|---|---|---|
| L1 | DAX_Live5m (orig.) | D30EUR | buffer 700, entrambe | real tick | **27/27 combo NEGATIVE — 🔴 e di quelle 27 passate NON ESISTE NESSUN CSV**, in tutta la storia di git. 📊 **L'unica cella con un CSV** (`risultati_prove/ABTG_DAX_Live5m/ABTG_DAX_Live5m_D30EUR_{IS,OOS}.csv`, `PrevWin=5`, ST OFF, due lati, cancello d'ampiezza SPENTO): **tick · IS PF 0,93488 · n 225 · DD 26,07%** · **OOS PF 0,85701 · n 342 deal · DD 39,74%** — tutti **@ rischio 2,00%**. Gli stessi pin in **OHLC**: IS 1,27364 / OOS **1,46853** (fattore **1,714**) | ⚪ **NON ANCORA MISURATO** (22-23/09/2026) — ✏️ sostituisce il 🔴 morto del 26.07.26. 🔴 **MA la cella che il CSV ce l'ha e' BOCCIATA SUL RISCHIO, e questo resta**: DD OOS **39,74% alla taglia di campo**, quasi quattro volte il muro del 10%. ⚪ **Certificato:** ① ✅ · ② ✅ · ③ 🔴 **NO** · ④ 🔴 **NO** (solo D30EUR) · ⑤ 🔴 **NO — TF provati per nome: solo M5 di grafico, finestra d'ingresso solo 5 minuti** (`InpLevelTF` H1 · `InpFilterTF` H1 · `InpStTF` H1 · `InpCorrTF` H1 · `InpTrailTF` M1: **nessuno mai mosso**). 👉 Il numero brutto vale, il **verdetto di morte no**: manca meta' del certificato |
| L2 | Nasdaq_Live5m (orig.) `770203` | NASUSD | buffer 700, MinRange 1700, MaxRange 4000, entrambe, TP1 1R + 50% + trailing M1 | real tick | 27/27 combo NEGATIVE · cella mediana: **PF IS 1,01621** (n 116, DD 11,52%, +98,96) · **PF OOS 0,96265** (n 175 deal = **88-175 posizioni**, DD 19,40%, −326,54) — tutti **@ rischio 2%** · OHLC stessa cella: OOS 2,16249 / +8.943,56 (fattore 2,25 = perche' OHLC non e' un verdetto) | ⚪ **NON ANCORA MISURATO** (12/09/2026, secondo strato del cancello — sostituisce il 🔴 morto del 26.07.26). 🔴 Bocciato su INGRESSO e COSTO (stop minimo 24 idx / spread misurato 1,80 = **13,33x** = il pavimento DURO al decimale; **12,63x** al P95 1,90 = **sotto**). 🕳️ **Manca:** (a) **asse USCITA mai girato su `RangeMode=1`/`PrevWin=5`** — gli assi F/I girarono tutti su `RangeMode=0`; (b) **voce 5 non chiusa, e la ragione e' stata CORRETTA il 13/09**: il TF del grafico **non entra nei numeri** (unica occorrenza di `PERIOD_CURRENT` a r.296, ramo morto con `InpTrailStartR=0`) → cambiarlo darebbe **gli stessi numeri**, non zero trade. ✍️ Si chiude solo toccando il TF dell'**INGRESSO** (`InpPrevWindowMin`/`InpLevelTF`) = **firma di Claudio**. _(La prima stesura citava `InpTimeframe != M5`: e' un input dell'EA **ESTERNO**, non di questo.)_; (c) gemelli **parziali, e la ragione e' stata CORRETTA il 13/09**: il D30EUR a cancello **SPENTO** (`MinRange=MaxRange=0`) non e' lo stesso meccanismo, ✅ **ma una corsa col cancello ACCESO esiste gia'** (`ABTG_DAX_Live5m_v2`, `1500/4000`): **IS PF 1,00564 n 80 DD 4,70% · OOS PF 0,92490 n 202 DD 14,16% @ rischio 1%**, contro **OOS 0,857 n 342 DD 39,74%** a cancello spento → **il cancello morde nel verso giusto**. Confondimenti: rischio 1% vs 2%, slippage 100 pt, CloseHour 17:30. U30USD/SPXUSD mai provati; (d) larghezza finestra **mai misurata ad asse controllato** (classe 296). 👉 **Torna in coda all'imbuto, MAI in campo in automatico.** Costo per chiudere il certificato: **3,99 min** (44 passate) — vedi `report/PREOPEN_NASDAQ_IL_VERDETTO_2026-09-12.md` §8 |
| L3 | DAX_Live5m_v2 | D30EUR | 32 passate. ✏️ **DESCRIZIONE CORRETTA IL 22-23/09/2026 dal CSV**: il *«range filter»* **NON C'ERA** (`InpMinRangePts=0` e `InpMaxRangePts=0` in tutte e 32), la griglia era **LONG-ONLY** (`InpAllowShort=0` in tutte e 32) e **2 manopole su 5 erano INERTI** (`InpMinStopPts` 200/400 e `InpSkipIfTight` 0/1 danno risultati **identici alla quinta cifra**: 32 passate = **4 celle distinte x 2 finestre d'ingresso x 4 ripetizioni**) | real tick **@ rischio 1,00%** | best PF **1,04296** DD **9,097%** n 239 (Supertrend ON + PrevWin **15**); resto **0,84571-1,04062**, DD **9,10-26,08%** — **a rischio 1%: raddoppiati valgono 18,2-52,2%**. 🔥 **E QUI C'E' L'UNICO GRADIENTE DI TF DELL'INTERA FAMIGLIA**: allargando la finestra d'ingresso da **5' a 15'** a parita' di tutto il resto, **4 coppie distinte su 4** fanno **PF +0,077 / +0,085 / +0,089 / +0,136** e **DD −5,64 / −7,01 / −9,26 / −11,26 punti**. Fonte: `risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` | ⚪ **NON ANCORA MISURATO** (22-23/09/2026) — ✏️ sostituisce il 🔴 morto. ⚪ **Certificato:** ① ✅ · ② ✅ · ③ 🔴 **NO** · ④ 🔴 **NO** · ⑤ 🟡 **PARZIALE — TF per nome: grafico solo M5; finestra d'ingresso 5' e 15' (le uniche due mai provate). 30' e 60' MAI PROVATI.** 🔴 **E manca lo split IS/OOS**: finestra unica, quindi il «best di 32» e' **selezione, non altopiano** |

_Nota: in OHLC i Live5m davano numeri finti enormi (+129k DAX, +30k Nasdaq). In real tick: morti. Lezione: M5/breakout → OHLC inganna._
🟢 ✏️ **CONFERMATA E QUANTIFICATA IL 22-23/09/2026, e il numero adesso c'e'**: il fattore OHLC→tick sul PF OOS vale **1,714** su `L1` (1,46853 → 0,85701), **1,850** su `L3` con cancello acceso (1,71088 → 0,92490) e **2,246** su `L2` (2,16249 → 0,96265). 👉 **Su questa famiglia l'OHLC gonfia il PF fra il 71% e il 125%**: e' la riga di questo registro che ha retto meglio alla riverifica.

> **⚠️ VERDETTO DEL 26/07/2026 — RISCRITTO IL 22-23/09/2026** (fonti: `report/RIESAME_MORTI_BREAKOUT_M5_2026-09-22.md` §3, e **ogni numero riverificato sul CSV**).
>
> 🟢 **COSA RESTA VERO, E SI CHIUDE DAVVERO.** La **rottura secca della candela pre-apertura da 5 minuti**, a **due lati insieme**, **senza filtro di trend** e **senza cancello d'ampiezza**, **non paga a tick veri sugli indici BCM** — e muore **prima sul RISCHIO che sul PF**:
> `ABTG_DAX_Live5m` D30EUR OOS **PF 0,85701 · n 342 deal · DD 39,74% @ rischio 2,00%** (`risultati_prove/ABTG_DAX_Live5m/..._OOS.csv`);
> `ABTG_Nasdaq_Live5m` NASUSD OOS **PF 0,96265 · n 175 deal · DD 19,40% @ 2,00%** (`risultati_prove/ABTG_Nasdaq_Live5m/..._OOS.csv`);
> `ABTG_DAX_Live5m_v2` D30EUR ramo `PrevWin=5` / ST OFF **PF 0,846-0,951 · DD 16,1-26,1% @ 1,00%** = **31,5-51,9% alla taglia FTMO** (`risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv`).
> 🔴 **E il COSTO lo spiega da solo**: lo stop minimo strutturale di quelle corse vale **1,2x – 8,8x lo spread D30EUR misurato**, contro i **40x** della regola di casa. **Su M5 quel motore paga il pedaggio, non il mercato.**
>
> 🔴 **COSA INVECE NON E' MAI STATO MISURATO, e la frase vecchia dava per morto:**
> **(1)** `ABTG_DAX_M3` e `ABTG_Londra_ORB` **non hanno MAI avuto un CSV** — **riverificato il 22-23/09 con `git log --all --pretty=format: --name-only`: sull'intera storia del repo i soli file che portano quei nomi sono `.mq5`, `.set`, `.ini`, `.pine` e `.md`. Zero risultati.** E i loro `.ini` del 26/07 dichiarano **`Model=1` = OHLC**. 👉 Sono **⚪ NON ANCORA MISURATI**, non morti.
> **(2)** Anche le corse a tick citate dalla frase (**27+27 passate** su `L1` e `L2`) **non hanno CSV agli atti**; girarono dal **2024.01.01** contro un pavimento tick misurato al **2024.09.26** (**29,5% della finestra su tick fabbricati**), coi **due lati pinnati insieme** e con il **Supertrend pinnato a ZERO**.
> **(3)** **NESSUNO dei sei e' mai stato girato su un TF diverso dal suo**: `L1`/`L2`/`L3`/`O2`/`O4` **solo M5**, `O3` **solo M3**. E nell'unica volta in cui il TF effettivo e' stato alzato — finestra d'ingresso **5' → 15'**, `valid_DAX_Live5m_v2_D30EUR_realtick.csv` — il **PF e' salito in 4 coppie distinte su 4 (+0,077 / +0,085 / +0,089 / +0,136)** e il **DD e' sceso di 5,64-11,26 punti**. 🔴 **30 e 60 minuti non sono MAI stati provati.**
> **(4)** **Due dei sei non sono breakout d'apertura, ed e' un errore di categoria**: `ABTG_DAX_M3` e' Supertrend **H4 bias / M3 trigger** con EMA200 e ADX (la famiglia **VIVA** su H1/H4), e `ABTG_ORB_Fibo` entra con un **LIMIT nella Golden Zone 50-61,8%** = un **RETEST**, cioe' la geometria che in casa **paga**.
> **(5)** `ABTG_Londra_ORB` costruisce il canale **06:00-07:00 server** ed entra alle **07:00**, mentre il 03/09 e' stato **misurato** che **Londra apre alle 08:00 ora server**: ha misurato la **pre-apertura**. Le tre ore non sono **mai** state su un asse. _(Lo stesso vale per **R45**, `prove/R45c` r.20: `InpRangeStartHour=7`.)_
>
> ## 👉 CONCLUSIONE
> 🟢 **«NON COSTRUIRE ALTRI v2 M5» RESTA IN PIEDI.**
> 🔴 **«Il breakout in apertura non ha edge» NON e' dimostrato: e' dimostrato che NON PAGA SU M5**, che e' il TF dove il pedaggio se lo mangia.
> Il capitolo si riapre **solo** su **TF piu' alti**, **meccanismi** (cancello d'ampiezza, filtro di trend, retest), **simboli** e **gestione dell'uscita** — **mai** su una griglia piu' fitta degli stessi parametri su M5.

---

---

## 2-bis) FIBO H4 — il "0/8" e' UN NUMERO SOLO, CONTATO OTTO VOLTE (trovato il 21/08/2026)

| # | EA | Sym | Risultato in archivio | Verdetto |
|---|---|---|---|---|
| F1 | FiboH4_Multi | 8 coppie forex+oro H4 | **0/8 promossi** (coda fascia B, 10-11/08) | 🔴 bocciato allora, e **il numero resta** |

🔴 **MA il banco era rotto, ed e' misurato.** `ABTG_FiboH4_Multi` e'
**multi-simbolo**: opera su `InpSymbols`, non sul simbolo del grafico. Il file
prova scriveva `InpSymbols=` **vuoto** con sopra la nota *"il pin sotto e'
OBBLIGATORIO"* — e **MT5 ignora un pin di stringa vuoto**, usando il default
compilato. Nei 16 CSV in archivio la colonna `InpSymbols` dice
`GBPUSD;USDJPY;EURUSD` in **tutte** le passate, e **7 file su 8 danno lo stesso
numero al centesimo** (IS da −384,56 a −394,13 / OOS da +116,17 a +118,68).
➡️ Quel "0/8" e' **una configurazione bocciata, contata otto volte**.

🔵 **E non ha mai giudicato la strategia del corso.** Le tre divergenze di
geometria (18/08): distanza ordini **~x10**, target **x2,1**, stop **~x4**.
➡️ **R93** (bozza `risultati_archivio/R93_CRITERI.md`, decisione di Claudio del
21/08 *"1,2,3 si guardano"*) rimisura in due gambe: **A** il filtro news sul
nostro EA, **B** la geometria del corso con `ABTG_FiboH4_Corso.mq5` (nuovo).

🛠️ **Corretto per non ripeterlo:** `scan_market.ps1` (blocco FiboH4) ora usa il
segnaposto `__SYM__`; e c'e' `backtest_pipeline/controlla_prova.py`, che il pin
vuoto lo trova **prima** di svegliare MT5.


## 2-ter) POST NEWS — il "nessun edge" e' UNA PASSATA CHE NON E' MAI GIRATA (corretto il 03/09/2026)

| # | EA | Sym | Risultato in archivio | Verdetto |
|---|---|---|---|---|
| P1 | ABTG_PostNews | EURUSD / EURJPY, IS+OOS | **Profit 0.00, PF 0.00000, Trades 0** su **ogni riga dei 4 CSV** — riverificato il 22-23/09/2026 su `risultati_prove/ABTG_PostNews/*.csv` (2 righe ciascuno, 8 righe in tutto, tutte a zero) | ⚪ **NESSUNA MISURA** (22-23/09/2026) — ✏️ sostituisce il 🔴 del 07/08, che era **RITIRATO** ma ancora scritto in rosso. 🔴 **PF 0,00000 su 0 operazioni NON e' «nessun edge»: e' NESSUNA MISURA.** Certificato: ① 🔴 · ② 🔴 · ③ 🔴 · ④ 🔴 · ⑤ 🔴 — **zero punti su cinque**. Il motore non e' mai partito (cause (a) dato e (b) canale, qui sotto) |

🔴 **Non e' un verdetto ribaltato: e' un verdetto INESISTENTE.** Quattro file di
risultato con `Trades 0` non misurano una strategia debole, non misurano niente.
`risultati_prove/ABTG_PostNews/*.csv` — colonna `Trades` = 0 su ogni riga.

🔎 **DUE cause sommate, e servivano tutte e due per fare zero:**
- **(a) il DATO.** `mql5/Files/abtg_news.csv` aveva **17 righe datate 2026-2027**
  (`data/abtg_news.csv` e' **vuoto, 0 byte**). Con `InpRestrictToNews=true` e
  nessun evento nel periodo, nessun ordine parte.
- **(b) il CANALE.** L'EA apriva il CSV **senza `FILE_COMMON`**. Nel tester ogni
  agente ha la **sua** sandbox `MQL5\Files` e i driver di casa non ci copiano
  file ausiliari (gia' verificato riga per riga in `lancia_r93.ps1`, ed e' lo
  stesso difetto pagato sul FiboH4): `FileOpen` falliva, `LoadNews` tornava con
  0 eventi e **il filtro si spegneva da solo, in silenzio.**

🛠️ **Corretto, e in modo che non si ripeta:**
- `ABTG_PostNews.mq5` **v1.10**: `InpNewsCommon` (default `true`, Common prima e
  sandbox come ripiego — **il live non cambia**), due canarini in chiaro
  (`CALENDARIO CIECO` / `CANARINO ROSSO`) e la riga di copertura
  `[PostNews][NEWS] letto da … | UTILI per questo preset N | dal … al …`.
  **Una passata con N=0 si butta.** Piu' `InpAutoTest` sui casi di accettazione
  della SPEC (par. 7).
- **Il calendario vero**: `backtest_pipeline/costruisci_news_postnews.py` →
  `mql5/Files/abtg_news_postnews_2010_2025_UTC.csv`, **599 eventi 2010-2025**
  (143 ECB PC, 84 FOMC PC, 186 Unemployment Rate USA, 186 Nonfarm Payrolls),
  fusi dalle due sorgenti di biblioteca. ADP / U6 / Private Nonfarm esclusi in
  modo esplicito (`NewsToday` fa match sulla **data**: un ADP di mercoledi'
  aprirebbe in un giorno senza notizia). Autotest 14 casi, 0 falliti.
  ⚠️ **`abtg_news.csv` NON e' stato toccato: e' il file del forward.**

⚖️ **E il round rifatto NON promuove comunque.** 12-16 eventi l'anno: il metro
di casa (Emendamento A, >=150 operazioni per finestra) **non e' raggiungibile**.
Il giudizio possibile e' la **prova di regime** e vale **solo sul RISCHIO**
(Emendamento B). Va scritto **prima** dei numeri, non dopo.

⚠️ **Da tenere accanto al risultato, gia' in registro (lapide 03/09):**
`arXiv 2605.04004` §4.7 — su 993 eventi il drift post-news e' reale **nelle
prime cinque barre** e da bar +6 le T-statistiche stanno fra 0,14 e 0,69.
Misurato su Nasdaq, non sul forex: **indicazione forte, non verdetto**. Ma la
Post News piazza i pendenti a news+10/+15 e li lascia vivi **per ore**: la
maggior parte della sua finestra di riempimento cade **fuori** dalle cinque
barre. E' un'attesa dichiarata prima della misura.

🆕 **Cella nuova in coda (03/09):** `prove/POSTNEWS_NFP_00_conta.txt` —
disoccupazione USA su **USDJPY M5**, dalla slide del corso AB Forex (pag.
140-143), preset `ABTG_PostNews_NFP_USDJPY.set`, magic 771203. E' un **passo 0
conta-occasioni**, OHLC, e non e' stata lanciata. Il track record 2009-2017 del
relatore e' **[dichiarato]**, pips grezzi senza costi: motivazione per
misurare, **mai** un risultato da citare.


## 3) ORB e altri breakout indici (screen OHLC + direzione L/S)

| # | EA | Sym | Miglior config | Risultato | Verdetto |
|---|---|---|---|---|---|
| O1 | ORB | NASUSD | EntryPoints 20, TP_R 2.5, entrambe | real tick: 50% pos, best PF 1.15, DD 16%, 625 tr | 🟡 marginale |
| O2 | ORB_Fibo | NASUSD | — | **PF IS 0,83507 · PF OOS 0,96816** · **DD IS 3,02% · DD OOS 3,10%** · **n IS 91 · n OOS 75** — 🔴 **modello OHLC**, `InpRiskPercent` nominale **1** (vedi la nota sul rischio realizzato), **1 sola passata utile per finestra** (riverificato il 22-23/09/2026 su `risultati_prove/ABTG_ORB_Fibo/ABTG_ORB_Fibo_NASUSD_{IS,OOS}_ohlc.csv`: 2 righe ciascuno, **stesso esito, asse = `InpMagic` 770602/770603 = un asse TECNICO, non una griglia**). 🔴 **Su questo motore NON esiste UNA SOLA passata a tick reali** | 🟠 **NON ANCORA MISURATO** (10/09, quinto giro di cancello, classe 211) — era scritto "morto" **senza certificato**. Manca: **(a)** `n` OOS **75 < 95** (`R125-G4`) e **< 150** (Emendamento A) → **merito SOSPESO**, non bocciato; **(b)** mai girato a **tick**; **(c)** **nessun simbolo gemello** (solo NASUSD); **(d)** ⑤ **TF mai cambiato — e adesso e' scritto PER NOME (22-23/09/2026, riverificato sui due CSV): `InpExecTF` vale `PERIOD_M5` in TUTTE le passate e `InpORMinutes` vale 30 in TUTTE. Sono due `ENUM/int` VERI e modificabili, mai mossi**; **(e)** **gestione dell'uscita mai messa ad asse** (`InpExitOnEmaClose`, `InpUseTrailEMA`, `InpTP1Pct`; e `prove/R15_ORB_gestione_DD.txt` scrive *«e' il candidato del giro successivo»* — **quel giro non c'e' mai stato**). 🔴 **E il DD (3,10%) non e' confrontabile, contro quanto scritto finora**: `InpRiskPercent` dice **1** ma `LotByRisk` (mq5 r.414-419) quantizza il lotto (`MathFloor(lot/step)*step`, poi `MathMax(volume_min,...)`), quindi su un indice con passo 0,10 il **rischio realizzato e' [NON MISURATO]**. Il PF non ne risente, **il DD si'**. 🔵 **E non e' un breakout**: `ABTG_ORB_Fibo.mq5` r.219-220 — la rottura fissa solo la DIREZIONE, l'ingresso e' un **LIMIT nella Golden Zone 50-61,8%** con stop oltre il 78,6% = un **RETEST**, la geometria che in casa **paga**. 👉 Rientra in coda all'imbuto, **mai in campo in automatico** |
| O3 | DAX_M3 | D30EUR | — | 🔴 **«OHLC 33% pos, short 0%» NON E' VERIFICABILE: `ABTG_DAX_M3` non ha MAI avuto un CSV**, in tutta la storia di git (riverificato il 22-23/09/2026 con `git log --all --pretty=format: --name-only`: solo `.mq5`, `.set`, `.ini`, `.pine`, `.md`). L'unico atto e' `ini/ABTG_DAX_M3.ini` del 26/07, che dichiara **`Model=1` = OHLC 1-min**. Niente colonna MODELLO accanto al PF **perche' non c'e' la colonna PF** | ⚪ **NON ANCORA MISURATO — ZERO PUNTI SU CINQUE** (22-23/09/2026). ① 🔴 · ② 🔴 · ③ 🔴 (`InpTrailOnST` e `InpExitOnFlip` sono le righe 8 e 15 della Tabella B dell'`AUDIT_USCITE_2026-09-09.md`: **zero occorrenze come asse in tutto il repo**) · ④ 🔴 · ⑤ 🔴 **TF per nome: solo M3 di trigger + solo H4 di bias. `InpTriggerTF` e `InpBiasTF` sono `ENUM_TIMEFRAMES` VERI e non sono MAI stati mossi** — e M3 e' il TF piu' caro della scala. 🔴 **E NON E' UN BREAKOUT M5**: e' Supertrend **H4 bias / M3 trigger** con EMA200 + ADX>=25, cioe' la famiglia **VIVA** su H1/H4. Metterlo nella frase «il breakout M5 non ha edge» e' un **errore di categoria**. ⚠️ Nell'`.ini` `InpSLFixedPts` e' spazzolato su 6 valori mentre `InpSLMode` resta su SUPERTREND: **manopola INERTE per costruzione** (mq5 r.270-271), sei passate identiche ogni volta |
| O4 | Londra_ORB | GBPUSD | — | 🔴 **«OHLC 11% pos, DD 23%» NON E' VERIFICABILE: `ABTG_Londra_ORB` non ha MAI avuto un CSV**, in tutta la storia di git (riverificato il 22-23/09/2026, stesso metodo di O3: solo `.mq5`, `.set`, `.ini`). `ini/ABTG_Londra_ORB.ini` dichiara **`Model=1` = OHLC**, e `InpRiskPercent` **non compare**: quel **DD e' a rischio IGNOTO** → non confrontabile con nessun muro | ⚪ **NON ANCORA MISURATO — ZERO PUNTI SU CINQUE** (22-23/09/2026). 🔴 **E il difetto strutturale vale piu' del numero mancante: ha misurato L'ORA SBAGLIATA.** `InpRangeStartHour=6` · `InpRangeEndHour=7` · `InpPlaceHour=7` = canale **06:00-07:00 server**, ingresso alle **07:00 server**; ma il 03/09 e' stato **MISURATO** (`risultati_archivio/allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt`) che **Londra apre alle 08:00 ora server**. 👉 **Ha costruito il canale e piazzato gli ordini un'ora PRIMA dell'apertura.** ③ 🔴 (`InpUsePartial`/`InpBreakeven`/`InpUseTrailing` **tutti false per default e mai ad asse**) · ④ 🔴 · ⑤ 🔴 **solo M5, canale solo 06:00-07:00: le tre ore non sono MAI state su un asse** (l'`.ini` spazzola solo `InpBufferPips` x8, `InpTPRangeMult` x7 e i due lati = 224 passate, **nemmeno una tocca l'orologio**). 🟢 **Unica buona notizia: su GBPUSD lo spread misurato e' 0,2 pip** → il 40x chiede 8,0 pip e **il pedaggio NON e' la spiegazione**, al contrario degli indici |

> ⚠️ **04/09/2026 — la FINESTRA del range ORB e' contesa** (voce dei docenti
> 14:30-14:45 server vs indicatore e nostre sedie 14:25-14:30). Tutta la
> ricostruzione, con le tre letture possibili e il prerequisito Q1, sta nella
> sezione **«ORB — LA FINESTRA DEL RANGE E' CONTESA»** piu' sotto e nel referto
> `caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md` §1. **Non misurato.**

---

## 4) SUPERTREND REVERSAL portato su indici (screen OHLC 1-min)
_Strategia = trend + rimbalzo (NON breakout). Su oro fa PF 3.17. Ottimizza StMult / StAtrPeriod / TP_RR, rischio 1%._

| # | Sym | TF | Risultato | Verdetto |
|---|---|---|---|---|
| S1 | DAX (D30EUR) | **H1** | **66% combo pos**, best +2254 PF 1.48 (419 tr) / +1955 **PF 2.01 DD 4.0%** (239 tr), 67 combo con PF>1.2 | 🟢 **grande candidato** (da validare real tick) |
| S2 | DAX (D30EUR) | M5 | 0% pos, DD 30-37% | 🔴 morto |
| S3 | Nasdaq (NASUSD) | H4 | 43% pos ma best solo 15-19 trade | 🟡 pochi trade, inaffidabile |
| S4 | DAX (D30EUR) | **H4** | 55% pos, 68 combo PF>1.2; best +1196 PF 1.64 DD 6.6% (181tr), fino a PF 3.34 (85tr) | 🟢 edge robusto |
| S5 | Nasdaq (NASUSD) | **H1** | 47% pos, **58 combo PF>1.2**; best **PF 1.79 DD 0.9% 135tr**, cluster PF 1.66-1.79 DD ~1% | 🟢 edge pulito |
| S6 | Nasdaq (NASUSD) | M5 | 5% pos, best PF 1.10 DD 11.5% | 🔴 morto |

**SCOPERTA INDICI (da validare in real tick, poi forward):**
- `SupertrendReversal DAX **H1**` | StMult 3.0 / AtrP 9-10 / TP_RR 3.0 → PF 1.5-2.0, DD 4%, **419 tr**
- `SupertrendReversal DAX **H4**` | StMult 3.0 / AtrP 8-9 / TP_RR 3.0 → PF 1.6-2.6, DD 3-7%, 85-181 tr
- `SupertrendReversal Nasdaq **H1**` | StMult 3.0-3.5 / AtrP 10 / TP_RR 3.0 → PF 1.66-1.79, **DD ~1%**, 135-155 tr
- M5 morto su entrambi. H4 Nasdaq pochi trade.

### ✅ VALIDAZIONE REAL-TICK (26.07.26) — CONFERMATA, promossi a _Ottimizzato
_Griglia stretta StMult 3.0/3.5 × AtrP 9/10 × TP_RR 2.5/3.0, rischio 1%, tick reali._

| # | Sym | TF | Config vincente | Profit | PF | DD% | Trade | EA creato | Magic |
|---|---|---|---|---|---|---|---|---|---|
| S1v | DAX (D30EUR) | **H1** | StMult 3.5 / AtrP 10 / TP 3.0 | 1075 | **1.45** | 5.6% | 223 | `ABTG_SupRev_DAX_H1_Ottimizzato` | 970911 |
| S4v | DAX (D30EUR) | **H4** | StMult 3.0 / AtrP 9 / TP 3.0 | 781 | **1.96** | 5.7% | 86 | `ABTG_SupRev_DAX_H4_Ottimizzato` | 970912 |
| S5v | Nasdaq (NASUSD) | **H1** | StMult 3.0 / AtrP 10 / TP 3.0 | 479 | **1.57** | **1.17%** | 155 | `ABTG_SupRev_NAS_H1_Ottimizzato` | 970913 |

- **DAX H1:** solo StMult **3.5** in positivo (4/8); StMult 3.0 tutte negative. Plateau pulito sulle 3.5.
- **DAX H4:** 6/8 positive; 3.0/AtrP9 miglior profitto, 3.5/AtrP10 miglior DD (3.5%).
- **Nasdaq H1:** **8/8 positive**, DD ~1-2.4%. Il più forte: prop-friendly. ⭐
- CSV archiviati: `valid_SupRevRT_D30EUR_H1/H4.csv`, `valid_SupRevRT_NASUSD_H1.csv`.

---

## 5) ORO (baseline già validati — spina dorsale)
| EA | Sym | TF | PF | Note |
|---|---|---|---|---|
| SupertrendReversal_Multi | XAUUSD | H4 | **3.17** | migliore in assoluto |
| EMA200 | XAUUSD | — | 1.92 | 100% combo pos |
| GoldenCross | XAUUSD | — | 1.58 | |
| SupertrendReversal | XAUUSD | H4 | 2.74 | |

---

## SPUNTI DALLA LIVE DI EMILIANO MONZA (17.07.26, apertura Nasdaq)
**Da usare:**
- Direzione decisa PRIMA dal trend Weekly/Daily + correlazione S&P → opera solo in quella direzione (→ test A5 stile Monza).
- Filtro ampiezza candela **17-40 punti** (sotto=whipsaw, sopra=stop troppo largo).
- Ordine a **7 punti** oltre max/min della candela 5-min pre-apertura.
- ORB: volumi in crescita alla rottura + EMA 9/21 allineate + ingresso sul **retest** se apre lontano.
- Parziale 50% a ~20 punti + stop in pari.

**Da NON usare (pericoloso):**
- Piano B/C = hedging/martingala (raddoppio contro la perdita). È ciò che gli ha causato −500k / −1,4M di drawdown. Escluso.

---

## DOMANDE PER EMILIANO (bozza)
1. Sul **DAX aperture** conviene davvero solo-LONG, o la direzione adattiva (Supertrend Daily) rende di più anche prendendo gli short nei giorni ribassisti?
2. Buffer: 7 punti fissi o proporzionale all'ATR/ampiezza candela?
3. Filtro ampiezza 17-40: valori confermati anche sul DAX o solo Nasdaq?
4. Sul **Nasdaq** l'aperture da solo non ha edge nei nostri test: quali filtri aggiuntivi usi tu (correlazione, imbalance, livelli) che possiamo automatizzare?
5. Il SupertrendReversal su **DAX H1** ci dà PF ~1.5-2.0: ha senso come "core" indici o preferisci sempre l'apertura?

---
_Ultimo aggiornamento: dopo i test aperture real-tick + SupertrendReversal indici (parziale). Mancano: A3, A5, S4/S5/S6, DAX short._

---

# REGOLE EMILIANO MONZA — sintesi da 18 live (apertura DAX)
_Estratte da 18 trascrizioni (mattina DAX + qualche serale + 1 di Paolo). Distinte: RICORRENTE (in più live) = affidabile / ONE-OFF = detto una volta. Le live sono quasi tutte DAX; sul Nasdaq quasi nulla (vedi sezione dedicata)._

## A. Orari (ora italiana; server BCM = −1)
- **RICORRENTE** DAX apre 09:00 IT (08:00 server). Studio pre-apertura su D1/H4/H1 prima.
- **RICORRENTE** **ORB = prima candela M15, 09:00-09:15 IT** (08:00-08:15 server). Si opera **dalle 09:15**.
- **RICORRENTE** Chiusura **sempre in giornata, MAI overnight** (una overnight = 50k € di swap).
- Bassa volatilità 11:00-12:00; ECB/Lagarde parla alle 09:00 (muove DAX/EURUSD).

## B. Direzione (la cosa più martellata — "prima di tutto: long o short?")
- **RICORRENTE** La direzione la dà il **Daily**: struttura max/min crescenti (long) o decrescenti (short) + **forza delle ultime 3 candele** + "metà candela" = livello che invalida.
- **RICORRENTE** **Correlazione S&P500 (H1): il DAX segue l'S&P** ("il DAX non parte se non parte l'SMP"). EUR/USD correlato al DAX; USD/JPY all'S&P; di notte guida il Nikkei/Japan.
- **RICORRENTE** Livelli S/R su **D1 + Weekly**: "1 sopra e 1 sotto il prezzo, non 2000 linee". Open Weekly = spartiacque.
- Opera **solo in direzione del bias** ("battezzatura"); controtrend a metà size o niente.

## C. Ingresso
- **RICORRENTE (CENTRALE)** ORB: si entra alla rottura del max/min della candela M15 **SOLO se**: (1) la candela **chiude col corpo fuori dal range** (non solo spike), (2) **volumi ≥ +50% / 1,5× la media(20)**, (3) **medie 9/21 inclinate** nella direzione. Se apre lontano dal livello → **entra sul RETEST**, mai inseguire.
- **RICORRENTE** Max/min della notte: ordine pendente a **10 punti** oltre (indici).
- Se un livello viene "sfiorato" la prima volta → sposta l'ordine (la 2ª volta rompe). 2° tocco = più probabile la rottura (setup A+).

## D. Filtri e DIVIETI
- **RICORRENTE** Niente ingresso su rottura **senza volumi** (= fake breakout).
- **RICORRENTE** Niente trade se **range troppo ampio / stop troppo largo** (ORB tardivo con canale ~140 pt → skip).
- **RICORRENTE** Blackout **news**: 11:00 e 14:30 IT (CPI/PPI) + ECB 09:00 → **cancella i pendenti**. No giorni FOMC/NFP.
- Vietato "terra di nessuno" (metà candela) e inseguire i prezzi.
- **Declassano il setup** (5 ostacoli): media 200 H1, VWAP, S/R, pre-section, numero tondo.

## E. Stop / Target / Gestione
- **RICORRENTE** Stop DAX tipico **~40 punti**, messo **sotto media/Supertrend/minimo** (5-10 pt oltre), MAI dove c'è la liquidità retail. ATR(14) come metodo base. La **size si calcola dallo stop** (~1 €/punto per contratto).
- **RICORRENTE** RR **1:1 → 1:2**. Target: numeri tondi, VWAP, max/min notte, chiusura gap. 1° obiettivo ~30 pt o media 50.
- **RICORRENTE** **Parziale 50% + stop in pari dopo ~20-30 punti.** Trailing sotto medie/Supertrend.
- **RICORRENTE** Money management **1/3 + 2/3** (il 2/3 deve essere eseguito → su livelli price action, distanza ≥20 pt dal 1°).
- **Stop temporale** (Dr. Mind): trade >6 min sospetto, ~33 min chiudi. "Se entri bene, esci veloce".

## F. Indicatori e SETTAGGI ESATTI
- **Bollinger:** DAX/giorno **37 / dev 3** ("37,3"); valute **20 / 2**; pre-apertura/notte/laterale **20 o 22**.
- **Medie:** 200 (istituzionale, MAI da sola → sempre con S/R), 100, 89, 50, 21, 14, 9. ORB usa **9 e 21** inclinate.
- **Supertrend:** 3 livelli, il **3° è il più importante**; es. **mult 3.5 / ATR 10**; livelli D1 e Weekly.
- **VWAP M15** (volatility-weighted, custom) = filtro direzionale: sopra=long, sotto=short.
- **Volumi:** media **20** (o 50), soglia **≥ +50% / 1,5×** per validare la rottura.
- **ATR(14)** per lo stop. Rischio **1-2%**.

## G. NASDAQ (poco materiale — importante saperlo)
- Nelle 18 live **quasi NIENTE sul Nasdaq**: le live pomeridiane USA non c'erano.
- Emiliano **EVITA il Nasdaq vicino alle trimestrali (earnings)**: troppo sensibile/volatile; di notte preferisce l'S&P.
- **Differenza prezzi tra broker più marcata sul Nasdaq** → i livelli notte vanno letti sul PROPRIO broker.
- Traduzione per noi: sul Nasdaq il breakout aperture è debole (test lo confermano). Meglio (a) filtro correlazione + evitare earnings, oppure (b) puntare sul **SupertrendReversal H1** (da validare).

## H. DA NON AUTOMATIZZARE (pericoloso / discrezionale)
- **Hedging/"edging"** e **martingala/prezzo medio** (raddoppio contro la perdita) → è ciò che gli ha fatto −500k/−1,4M. ESCLUSO.
- Reversal discrezionale, scalping M1/M3, overnight, letture "a sentimento", size aggressive su conto grande.

---

## MODIFICHE CONCRETE DA FARE AGLI EA (priorità)
1. **Filtro VOLUMI alla rottura** (≥1,5× media 20) — è il filtro anti-fake più ripetuto. NON ce l'abbiamo nell'aperture → **da aggiungere nel codice**. [alta priorità]
2. **Filtro VWAP M15** direzionale — da aggiungere. [alta]
3. **Direzione adattiva D1 (Supertrend) + correlazione S&P** — gli input ESISTONO già (`InpUseSupertrend`+`InpStTF=D1`, `InpUseCorrelation`+`SPXUSD`) → **solo da testare** (parzialmente nel test "Monza" A5). [media, già avviata]
4. **Blackout news 11:00/14:30** — input `InpUseNewsFilter` già presente → caricare `abtg_news.csv` e attivarlo. [media]
5. **Filtro ampiezza candela** (relativo/17-40) — input `InpMinRangePts`/`InpMaxRangePts` già presenti → testare. [media]
6. **Conferma "chiusura corpo fuori range" + retest** invece del solo pending-stop — modifica al motore. [bassa, complessa]

_Ultimo aggiornamento: consolidate le 18 live di Emiliano. Prossimo: aggiungere filtro volumi + VWAP al motore aperture e ri-testare._

---
## AGGIORNAMENTO — motore aperture con filtri Emiliano
- Aggiunto al codice degli EA aperture (+ _Ottimizzato + Live5m_v2) il **filtro VOLUMI** (`InpUseVolumeFilter`, `InpVolMult`, `InpVolAvgBars`): entra solo se il volume della rottura ≥ mult × media. Default OFF (nessun impatto finché non attivato).
- Nuovo test **A6 — DAX Apertura "motore Emiliano"** (`valid_DAX_Apertura_Emiliano`): real tick, 48 config, variando Buffer(400/600/800) × Direzione(solo-LONG / entrambe) × Supertrend-D1(off/on) × FiltroVolumi(off/on) × VolMult(1.5/2.0). Base fissa: ora 8, range 15, floor 200, slippage 100, rischio 1%. → ⏳ da lanciare (`rilancia_dax_emiliano.ps1`). Risultati in `risultati_dax_emiliano\`.
- Cartelle nuove: `docs/live_paolo/` (trascrizioni Paolo) e `backtest_pipeline/risultati_archivio/` (archivio CSV per progetto; indice = questo file).
- TODO prossimo: filtro VWAP M15 (per gestione/direzione), da aggiungere dopo aver validato il filtro volumi.

---
# REGOLE PAOLO — sintesi (6 live; NB: strategie diverse dall'apertura)
_Paolo fa soprattutto **forex swing/reversal** (Super Trend Inverte, Fibonacci, Bollinger, Wyckoff/Volume Profile). NON fa breakout in apertura. Estratto solo ciò che serve come FILTRO ai nostri EA._

## Filtri AUTOMATIZZABILI utili (nuovi rispetto a Emiliano)
- **Filtro distanza/ADR (importante per l'apertura):** NON entrare se al segnale il prezzo è **troppo lontano** dal livello di rottura (minimo notte/range): movimento già impulsivo → il retest lo supera. Confronto distanza vs **ADR giornaliero**. Il retest è affidabile solo se **vicino** al livello (es. scartare se >50 punti). → mecanizzabile.
- **ADX(14)** soglie **20 / 25 / 50**: <20 laterale (no trade), >25 forza, ~50 esaurimento. Filtro di forza (non direzione).
- **Medie ordinate 14/50/200 + posizione vs EMA200** come conferma trend (14>50>200 long / 14<50<200 short).
- **Std Dev in espansione** (uscita da compressione Bollinger) come conferma di breakout vero.
- **Imbalance/FVG:** se la candela successiva **chiude DENTRO** l'imbalance → rientro (gap richiuso); se chiude **FUORI** → prosecuzione.

## Conferme importanti (allineate ai nostri test)
- **Volumi affidabili SOLO sugli indici** (regolamentati), NON sulle valute → il nostro filtro volumi sugli indici (DAX/Nasdaq) è legittimo. ✅
- **DAX più debole dell'S&P** → se l'S&P scende, il DAX scende di più (direzione da correlazione S&P). ✅ (come Emiliano)
- Apertura considerata **"pericolosa"** se pre-apertura ha già fatto un movimento impulsivo forte → coerente col filtro distanza/ampiezza.

## Da NON automatizzare (Paolo)
- Gestione/parziali "a sentimento", Wyckoff (accumulo/distribuzione), lettura swing/BOS discrezionale, PTE (iperestensione, molto soggettiva), VWAP/volumi letti a occhio.

## Idea EA futura (bassa priorità)
- **Filtro ADR/distanza** da aggiungere al motore aperture: skip se il prezzo alla rottura è troppo lontano dal livello (o se l'ampiezza pre-apertura > X% dell'ADR). Riduce i falsi breakout impulsivi. Da valutare dopo il filtro volumi.

---
# REGOLE MARCO GARBUGLIA — audio (crea EA, obiettivo prop)
## Metodo (= quello che stiamo costruendo)
- Ogni EA con set di **filtri toggle ON/OFF + valori regolabili a mano**: **RSI** (momentum E ipercomprato/ipervenduto), **ADX**, **ATR**, **media mobile** (long/short vs MA, periodo config), **incrocio medie** (9>21, entrambe>200), **Supertrend**.
- Partire con **tutti i filtri OFF**, attivarne **uno alla volta** (parte da RSI) → trovare la combo ideale.
- Prima della consegna: **verificare tutte le combinazioni, evitare conflitti/paradossi**, ricontrollare il codice 2 volte.

## Strumenti consigliati (LEAD)
- Mattina: **DAX** + **FTSE (UK100)**.
- Pomeriggio: **Russell (US2000)** + **Dow (US30)** → "**vanno meglio del Nasdaq**". ← da testare!
- DAX: max/min della notte; ORB su indici.

## Idee nuove (da valutare)
- **ORB breakout + RETEST** (non breakout secco): M5 chiude fuori senza ombra sopra → candela che rientra e si appoggia sull'ORB → entra. (Ombra% difficile da codificare.)
- **Canale notturno** (dalle 21-22 indici piatti): range M5 → breakout della mediana, stop dall'altro lato. Buono per conto personale, NON per prop.
- **Russell/Dow pomeriggio mean-reversion**: aprono sotto la media, apertura forte long → sparano 2-3 candele M5 poi si schiantano sulla media e tornano al livello pre-apertura (quasi ogni giorno). Idea: long fino a MA200 poi short al rifiuto, target = livello pre-apertura. Stop corto → 1:5/1:6.

## Test avviato
- **A7 — Aperture su nuovi indici** (`valid_Apertura_UK100/US2000/US30`): real tick, varia direzione(long/short/both) × buffer(200/500/800), ora 8 (UK100) / 14:30 (Russell,Dow), range 15, floor 200. Runner `rilancia_apertura_nuovi_indici.ps1`. ⏳ da lanciare (verificare che i simboli siano in Market Watch).

## TODO framework filtri modulari (Marco + Emiliano + Paolo)
Aggiungere al motore aperture, tutti toggle indipendenti (AND-gate, no conflitti): RSI, ADX, ATR, MA-filter, MA-cross (volumi ✅ e Supertrend ✅ gia' presenti). Poi sweep di tutte le combo + validazione real-tick del vincitore (evitare overfitting/pochi trade).

---
## EA APERTURA MARCO (nuovo, famiglia "Marco")
- Creato **`ABTG_Apertura_Marco.mq5`** (magic 770301): motore aperture + TUTTI i filtri di Marco come **toggle indipendenti** (AND-gate, no conflitti):
  - `InpUseMaFilter` (prezzo vs MA, periodo/metodo/TF), `InpUseRsi` (mode 0=momentum / 1=ipercomprato-venduto), `InpUseAdx` (soglia min), `InpUseAtr` (min/max punti) — oltre a Supertrend, correlazione, volumi già presenti.
  - Tutti **default OFF** (metodo Marco: parti da tutto OFF, accendi 1 filtro alla volta).
- **Test M-base** (`valid_Marco_DAX_base`): tutti i filtri OFF, DAX ora 8, range 15, LONG, floor 200, buffer 400/600/800 → deve ridare **~PF 1.49** (conferma che l'EA è sano). Runner `rilancia_marco.ps1`. ⏳ da lanciare.
- Poi: accendere i filtri uno alla volta (RSI, ADX, ATR, MA...) e vedere se migliorano PF/DD, con validazione del vincitore.

### ✅ RISULTATI CACCIA MOTORE M5 (26.07.26) — filtri Emiliano nel motore Marco, real-tick
_Sweep isolato: direzione × correlazione S&P × volumi × EMA. DAX ora 8, Nasdaq ora 14:30, rischio 1%._

**DAX (D30EUR M5):**
| Config | PF | DD% | Trade |
|---|---|---|---|
| baseline LONG buffer 600 (nessun filtro) ⭐ | **1.24** | 4.7% | 309 |
| + Volumi | 1.21 | 5.0% | 264 |
| + Correlazione S&P | 1.21 | 3.9% | 178 |
| + EMA / qualsiasi SHORT | ≤0.92 ❌ | — | — |

→ Motore sano (LONG edge confermato, PF 1.24; SHORT distrugge). **I filtri NON migliorano il PF**; la correlazione dimezza i trade e abbassa il DD ma taglia anche il profitto. L'`_Ottimizzato` esistente (logica candela H1, PF 1.49) resta il campione DAX.

**NASDAQ (NASUSD M5):**
| Config | PF (range) | Trade |
|---|---|---|
| baseline nudo | 0.63–0.84 ❌ | 336–454 |
| + Volumi | 0.66–0.68 ❌ | 129–184 |
| + Correlazione S&P | 0.51–0.66 ❌ | 199–215 |
| + Corr + Vol | 0.60–0.67 ❌ | 122–181 |

→ **IPOTESI FALSATA: la correlazione S&P NON salva il Nasdaq.** Nessuna combo supera PF 0.76. Il filtro funziona meccanicamente (taglia i trade da 336 a ~200 → dati S&P presenti, test valido), ma non crea edge dove non c'è.

> **CONCLUSIONE M5 (definitiva).** Il breakout M5 in apertura è morto sul Nasdaq anche coi filtri di Emiliano; sul DAX funziona solo LONG e l'Ottimizzato esistente lo cattura meglio. **Fine della caccia al motore M5.** L'edge reale resta: DAX aperture LONG (M5 su candela H1) + SupRev su H1/H4 + oro. Nota: questo è un *proxy automatico* della regola di Emiliano (EMA 14/100 su S&P H1); la sua lettura discrezionale live è un'altra cosa e non è automatizzabile 1:1.

### Tassonomia famiglie EA (tutte → backtest → real-tick → forward)
- **NOSTRI (validati):** Oro (SupRev_Multi/EMA200/GoldenCross), DAX aperture LONG, SupertrendReversal indici (DAX H1/H4, Nasdaq H1 in validazione).
- **EMILIANO:** motore aperture + filtri (volumi/direzione D1/correlazione/ampiezza) — test A6.
- **MARCO:** `ABTG_Apertura_Marco` + filtri modulari (RSI/ADX/ATR/MA) + nuovi indici (UK100/Russell/Dow) — test A7.

---

## APERTURA su NUOVI INDICI — FTSE & Dow (26.07.26, real-tick)
_Idea di Marco: Russell/Dow/UK100 in apertura > Nasdaq. Testato col motore aperture (ora 8 FTSE, 14:30 Dow), sweep direzione×buffer, rischio 1%. Russell 2000 NON quotato su BCM._

| Sym | Strumento | Migliore config | Profit | PF | DD% | Verdetto |
|---|---|---|---|---|---|---|
| 100GBP | FTSE 100 | buffer 800 LONG | -302 | 0.90 | 9.6% | 🔴 morto |
| U30USD | Dow Jones | buffer 200 LONG | -9 | 0.997 (pari) | 8.6% | 🔴 morto (a malapena in pari) |

✅ **I DUE NUMERI QUI SOPRA SONO STATI RIVERIFICATI SUL CSV IL 22-23/09/2026 E REGGONO AL
CENTESIMO** (`risultati_archivio/Apertura_nuovi_indici/valid_Apertura_{U30USD_Dow,100GBP_FTSE}.csv`,
96 passate ciascuno, **modello 4 = tick reali**, **`InpRiskPercent=1`**):
`U30USD` best **PF 0,99721 · Profit −9,00 · DD 8,5752% · n 360` · `100GBP` best **PF 0,90423 ·
Profit −302,12 · DD 9,5820% · n 283`. **0 celle su 96 sopra 1,00 su tutti e due.**
🔴 **MA misurano `InpEntryMode = 0` — il BREAKOUT CIECO** — su **una finestra sola, senza split
IS/OOS**, con asse su `InpBufferPoints` (200/500/800), i due lati e `InpTrailFixedPts`.
👉 **Quel verdetto vale per il breakout cieco, e SOLO per lui.**

---

> ## ✏️ **CONCLUSIONE APERTURA — RISCRITTA IL 22-23/09/2026, e la vecchia era smentita dai nostri stessi numeri**
>
> **Il testo del 26/07 diceva:** *«Il breakout M5 in apertura funziona SOLO sul DAX, SOLO LONG.
> Su Nasdaq/FTSE/Dow → morto. … L'idea di Marco (Dow>Nasdaq) NON regge in versione automatica.
> Fine dell'espansione della famiglia aperture.»*
>
> 🟢 **COSA RESTA VERO:** il **breakout CIECO** in apertura non paga sul Dow ne' sul FTSE —
> 0/96 celle su tutti e due, e i numeri sono quelli riverificati qui sopra. **Chi vuole il
> breakout cieco su quei due indici deve portare una misura nuova.**
>
> 🔴 **COSA E' FALSO, e lo dicono tre misure indipendenti:**
>
> **(1) «Fine dell'espansione della famiglia aperture»: la famiglia e' META' DELLA CHALLENGE.**
> Tre delle sei sedie che operano su FTMO `541452707` dal 21/09 sono aperture: **`770101`**
> `ABTG_DAX_Apertura_EU` D30EUR M5 · **`770202`** `ABTG_Dow_Apertura_US` U30USD M5 ·
> **`770260`** `ABTG_Nasdaq_Apertura_US` NASUSD M5 (`report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md`
> rr.199-205, e i tre `.set` in `mql5/Presets/FTMO/`).
>
> **(2) IL MOTORE CHE OPERA SUL DOW NON E' IL BREAKOUT: E' IL RETEST, ed e' misurato a tick.**
> `R197A` (21/09, banco 80.000, tick reali, `RILIEVI: 0`) mette `InpEntryMode` **0 / 1 / 2** sullo
> stesso asse su `U30USD`, e il RETEST vince **in tutte e due le finestre**:
>
> | `InpEntryMode` | IS: PF · n · DD | OOS: PF · n · DD |
> |---|---|---|
> | **0 BREAKOUT** | 🔴 0,96503 · 87 · 11,99% | 1,18772 · 162 · 8,86% |
> | **2 RETEST** | 🟢 **1,21214** · 74 · 11,09% | 🟢 **1,25384** · 130 · 8,75% |
>
> _(`risultati_prove/R197A/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_R197A.csv`, `InpRiskPercent=2`.)_
> E `R202A` porta la cella viva del Dow a **OOS PF 1,27175 · n 130 · DD 4,3944% @ rischio 1%**.
> 👉 **«Su Dow → morto» era un verdetto sul BREAKOUT, spacciato per verdetto sul MOTORE.**
>
> **(3) «L'idea di Marco (Dow>Nasdaq) NON regge»: REGGE, e su due misure.**
> 🟢 **Prima misura — lo studio FASE A su 8 indici** (`risultati_archivio/studio_apertura/Studio_<SIM>_RIEPILOGO.csv`,
> 8 file dal 03/08/2026, **3.302 rotture** — non «~3.500»). 🔴 **Modello 1 = OHLC: e' uno
> SCREENING, e la cosa utilizzabile e' la CLASSIFICA, non il livello**, perche' gli otto indici
> sono misurati **nello stesso modo, con la stessa geometria** (buffer 200 pt, slippage 100,
> TP 2,0R, stop all'estremo opposto):
>
> | # | simbolo | strumento | cieco (n) | solo LONG (n) | solo SHORT (n) | con filtro H4 (n) |
> |---|---|---|---:|---:|---:|---:|
> | **1** | **`U30USD`** | **Dow** | 🟢 **+0,074** (446) | 🟢 **+0,095** (231) | 🟢 +0,052 (215) | 🟢 **+0,126** (212) |
> | 2 | `D30EUR` | DAX | 🟢 +0,026 (440) | +0,007 (225) | 🟢 **+0,045** (215) | −0,017 (203) |
> | **3** | **`NASUSD`** | **Nasdaq** | **+0,001** (447) | −0,005 (226) | +0,007 (221) | 🟢 +0,055 (234) |
> | 4 | `SPXUSD` | S&P 500 | −0,017 (444) | −0,022 (227) | −0,013 (217) | −0,002 (227) |
> | 5= | `E50EUR` | Stoxx 50 | −0,048 (440) | −0,055 (245) | −0,040 (195) | −0,068 (211) |
> | 5= | `E35EUR` | IBEX 35 | −0,048 (211) | −0,032 (106) | −0,065 (105) | −0,129 (104) |
> | 7 | `F40EUR` | CAC 40 | −0,056 (443) | −0,054 (235) | −0,058 (208) | −0,109 (202) |
> | 8 | `100GBP` | FTSE 100 | 🔴 **−0,138** (431) | −0,072 (216) | 🔴 −0,205 (215) | −0,137 (213) |
>
> ⚠️ **Errata su un referto di stanotte**: `report/RIESAME_MORTI_APERTURE_2026-09-22.md` scrive
> due volte *«il Nasdaq e' quinto»*. **Il CSV dice TERZO** (+0,001, dietro Dow +0,074 e DAX
> +0,026) — e la sua stessa tabella §2.4 lo mette al 3° posto. **Vale il CSV.** La conclusione
> «Dow primo» non cambia.
> 🟢 **Seconda misura — a tick reali, 20-21/09**: Dow OOS **1,27175** (`R202A`) contro Nasdaq OOS
> **1,21546** (`R199B`). Stesso verso.
> 🔴 **E terza, la piu' scomoda: la frase contraddice la tabella che le sta SOPRA, nel registro
> stesso.** Il 26/07 il Dow fa best **0,997** e il Nasdaq (riga A4) best **0,91**: **anche nel
> corpus che ha prodotto quella frase, il Dow batteva il Nasdaq.**
> _(⚠️ Il **0,91** di A4 e' **dichiarato nel registro, NON verificabile contro un CSV**: nessun
> file di quella griglia e' in repo. Lo scrivo come dichiarazione, non come misura — e quindi
> questo terzo argomento **vale meno degli altri due**, che sono su CSV.)_
>
> ### 🧪 IL CONTRO-ESEMPIO, costruito CONTRO questa riscrittura (regola del 10/09)
> **L'argomento che difenderebbe il verdetto vecchio:** *«La FASE A e' OHLC. Un modello ottimista
> non puo' ribaltare una misura a TICK su 96 celle. E il fattore OHLC→tick misurato in casa e'
> 1,71-1,85: portando il Dow FASE A a tick, il +0,074 sparisce.»*
> ✅ **Il primo pezzo e' giusto, e infatti NON uso la FASE A per promuovere niente: la uso per
> ORDINARE otto indici misurati nello stesso identico modo. Il fattore OHLC→tick colpisce tutti
> e otto, quindi cancella il LIVELLO e lascia in piedi la CLASSIFICA.**
> 🔴 **Il secondo pezzo cade da solo, perche' la classifica non e' l'unica prova**: `R197A`,
> `R197B`, `R172D` e `R202A` sono **modello 4, tick reali**, banco 80.000, `RILIEVI: 0`, con
> **split IS/OOS pulito**, e danno il Dow **positivo in tutte e due le finestre**. **Non e'
> l'OHLC a ribaltare il tick: e' un tick nuovo a ribaltare un tick vecchio su un'ALTRA
> configurazione.**
> 👉 **Il verdetto vecchio non regge. Quello che regge di lui — «il breakout cieco non paga su
> Dow e FTSE» — e' stato tenuto, per intero, qui sopra.**
>
> 🟢 **E resta vero anche questo, che non e' in discussione:** il **SupertrendReversal** su H1/H4
> e' il motore piu' generalizzabile della casa.

---

## SupRev su NUOVI INDICI — screen OHLC (26.07.26)
_SupertrendReversal (il motore che generalizza) su Dow/Stoxx50/CAC/FTSE/Nikkei, H1+H4, griglia StMult 2.5-3.5 x AtrP 8-10 x TP_RR 2.0-3.0, rischio 1%._

| Sym | Strumento | TF | Migliore config | PF | DD% | Trade | Verdetto |
|---|---|---|---|---|---|---|---|
| U30USD | Dow | **H4** | StMult 3.5 / AtrP 8-9 / TP 3.0 | **2.1-2.58** | 3-4% | ~80 | 🟢 FORTE (cluster) |
| U30USD | Dow | **H1** | StMult 3.5 / AtrP 9 / TP 3.0 | 1.2-1.33 | 7-8% | 273-454 | 🟢 buono |
| F40EUR | CAC 40 | H4 | StMult 2.5 / AtrP 9 | ~1.7 | 3% | 65 | 🟡 decente |
| E50EUR | Stoxx 50 | H1 | StMult 3.5 / AtrP 10 | 1.32-1.47 | 1.2% | 60 | 🟡 marginale |
| E50EUR | Stoxx 50 | H4 | StMult 3.0 / AtrP 8 | 2.8 | 0.6% | 49 | 🟡 troppo pochi trade |
| F40EUR | CAC 40 | H1 | StMult 3.5 / AtrP 9 | 1.29 | 6% | 131 | 🟡 debole |
| 100GBP | FTSE | H4 | StMult 3.0 / AtrP 9 | 1.29 | 2% | 48 | 🔴 debole |
| 100GBP | FTSE | H1 | — | tutte neg | — | — | 🔴 morto |
| 225JPY | Nikkei | H1/H4 | StMult 3.5 | PF ~2 | 0.2% | 24-75 | 🔴 profitto irrisorio (~€50, lotto JPY minuscolo) |

> **SCOPERTA: il SupRev generalizza sul Dow (U30USD).** H4 PF 2.5 DD ~3% (livello prop), H1 buono con tanti trade. Il Dow era morto in apertura, vivo col SupRev. CAC H4 secondario. FTSE/Nikkei scartati. **Da validare real-tick: Dow H4 + H1 (+ CAC H4 bonus).**

### ✅ VALIDAZIONE REAL-TICK SupRev nuovi indici (26.07.26) — CONFERMATA
| Sym | TF | Config vincente | Profit | PF | DD% | Trade | EA creato | Magic |
|---|---|---|---|---|---|---|---|---|
| U30USD (Dow) | **H4** | StMult 3.5 / AtrP 8 / TP 3.0 | 1661 | **2.77** | 4.0% | 79 | `ABTG_SupRev_DOW_H4_Ottimizzato` | 970914 |
| F40EUR (CAC) | **H4** | StMult 2.5 / AtrP 9 / TP 2.5 | 519 | **1.79** | 3.5% | 65 | `ABTG_SupRev_CAC_H4_Ottimizzato` | 970915 |
| U30USD (Dow) | **H1** | StMult 3.5 / AtrP 9 / TP 3.0 | 560 | 1.20 | 9.8% | 273 | `ABTG_SupRev_DOW_H1_Ottimizzato` (opzionale, DD alto) | 970916 |

- **Dow H4:** cluster StMult 3.5 → PF 2.09-2.77, DD 3-4%. Identico all'OHLC. 🟢 forte (livello prop/oro).
- **CAC H4:** StMult 2.5/AtrP9 → PF 1.70-1.79 DD 3%; StMult 3.0 negativo. 🟢 keeper.
- **Dow H1:** positivo (PF 1.20, 273tr) ma DD ~10% → secondario/opzionale.
- Il SupRev ora ha edge REAL-TICK confermato su: Oro, DAX (H1/H4), Nasdaq (H1), Dow (H4/H1), CAC (H4). **Motore che generalizza, dimostrato.**

> ### 🛑 REVOCA DEL 30/07/2026, SCRITTA QUI IL 09/09/2026 (arrivava con 41 giorni di ritardo)
> _I numeri qui sopra **restano**: sono veri e riproducibili. Cambia il
> **verdetto**. Fino a oggi questo registro diceva **"CONFERMATA"** e **non
> portava la revoca**: chi apriva solo `REGISTRO_TEST.md` credeva che Dow H4
> fosse un keeper. **Non lo e' piu' dal 30/07.**_
>
> 🔴 **`ABTG_SupRev_DOW_H4_Ottimizzato` (970914) e `ABTG_SupRev_CAC_H4_Ottimizzato`
> (970915): PROMOZIONI REVOCATE — "illusione OHLC".**
> Revoca gia' agli atti in `risultati_archivio/CLASSIFICHE.md` §2
> (Dow H4 **PFmed 0,79**, DD 3,3, 56 tr, *"❌ CROLLA (illusione OHLC)"*) e in
> `FLOTTA_ATTIVA.md` §"SCARTATI (backtest) ma tenuti in osservazione"
> (Dow H4 *"illusione OHLC (RT 0.79)"* · CAC H4 *"overfit (RT 0.96)"*).
>
> ✅ **Perche' 2,77 e 0,79 non si contraddicono — verificato sui CSV grezzi
> il 09/09, non ripreso dalla prosa:**
> - Il **2,77** e' la **CELLA MIGLIORE** di uno sweep **a finestra unica,
>   senza split**: `risultati_archivio/SupRev_nuovi_indici/valid_SupRevRT_U30USD_H4_realtick.csv`,
>   **8 celle**, PF da **0,487 a 2,768**; la cella 2,76794 ha **DD 4,0022 ·
>   n 79** — **coincide al centesimo con la riga della tabella qui sopra**.
>   La **mediana** di quello stesso sweep e' **1,772**.
> - Lo **0,79** e' un **PF MEDIANO**, cioe' un altro oggetto. Il ricalcolo
>   indipendente del 09/09 (`risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv`,
>   riga `SupRev,DOW,H4,Ottimizzato_U30USD`) legge sullo sweep **con split**
>   `risultati_prove/ABTG_SupRev_DOW_H4_Ottimizzato/`: **PFmed IS 0,741 ·
>   PFmed OOS 0,921** (10 celle per finestra) contro **PFmax 4,928 / 2,324**.
>   ⚠️ **Il valore esatto "0,79 · 56 trade" di `CLASSIFICHE.md` NON e'
>   riproducibile da nessun CSV oggi in repo** (il piu' vicino e' OOS n=57
>   PF 0,930): lo marco **[NON RIPRODOTTO]**. **La sostanza pero' regge da
>   tre misure indipendenti: la mediana sta sotto 1, la cella migliore sta a
>   2,77. Un keeper si giudica sulla mediana.**
>
> 📌 **Regola che questa riga lascia in eredita': un PF va sempre scritto con
> l'aggettivo davanti — "PF della cella migliore" o "PF mediano". Senza
> l'aggettivo il numero non vuol dire niente**, ed e' esattamente cosi' che
> una promozione revocata e' sopravvissuta 41 giorni in questo registro.
> ➡️ Il Dow H1 (970916, PF 1.20 · DD 9,8% · 273 tr) **non e' toccato da questa
> revoca**: era gia' *"secondario/opzionale"*.
> 📄 Verbale: `report/CONTRADDIZIONI_CHIUSE_2026-09-09.md` §C2.

---

## MaxMinNotte — rottura range notturno all'apertura europea (26.07.26, real-tick)
_Box 23:00-04:59 server, piazza 07:59, cutoff 08:30. Sweep direzione x buffer, SL ad ATR, rischio 1%._

| Indice | Migliore config | PF | DD% | Trade | Verdetto |
|---|---|---|---|---|---|
| DAX (D30EUR) | **SHORT only, buffer 1000, TP2 3.0** | **1.18742** | 7.2851% | 107 | 🟡 unica viva (edge modesto) |
| FTSE (100GBP) | SHORT only, buffer 1500, TP2 1.5 | max **0.67170** | 16.0281% | 82 | 🔴 morto |
| CAC (F40EUR) | **LONG** only, buffer 500, TP2 2.5 | max **0.99852** | 10.1232% | 112 | 🔴 morto |
| Stoxx50 (E50EUR) | **LONG** only, buffer 500, TP2 2.5 | max **0.83979** | 13.9046% | 80 | 🔴 morto |

🔴 ✏️ **RIGA STOXX50 CORRETTA IL 22-23/09/2026 — due righe di questo registro si contraddicevano,
e vince il CSV.** Qui c'era scritto *«max 0.59»*, mentre r.2527 e la sezione «TRE MORTI COL
CERTIFICATO COMPLETO» scrivevano **0,8398** per lo stesso simbolo e lo stesso file.
**Riaperto il CSV** (`risultati_archivio/MaxMinNotte/8eefb007-valid_MaxMin_E50EUR.csv`, 72 passate,
modello tick, `InpRiskPercent=1`): il massimo del file e' **0,83979** (LONG only). **Lo 0,59 e'
il massimo del SOLO LATO SHORT** (0,58966, buffer 1500, TP2 1.5, n 71, DD 12,80%).
👉 Il verdetto **non cambia** (0 celle su 72 sopra 1,00), ma **il numero era di un sottoinsieme
spacciato per il totale**, ed e' la classe di errore che il 16/08 ha costretto a scrivere la
regola *«un PF va sempre scritto con l'aggettivo davanti»*.
🟢 **Gli altri tre reggono alla riverifica** — D30EUR 1,18742 / 7,2851% / 107 ✅ · 100GBP 0,67170
(che e' insieme il massimo short e il massimo assoluto) ✅ · F40EUR 0,99852 ✅ — **ma in due casi
su quattro il «migliore» e' il lato LONG, non lo short**, e la colonna «migliore config» era vuota.
📏 **MODELLO e RISCHIO, che mancavano a tutta la tabella**: tick reali, **`InpRiskPercent=1` in
tutte e 288 le passate dei quattro file**. Alla taglia FTMO del 2,00% quei DD vanno **quasi
raddoppiati** (fattore 1,956-1,990): E50EUR **27,2-27,7%**, 100GBP **31,4-31,9%**.

> **Night-box: solo DAX SHORT ha edge (PF 1.19)** — la rottura al RIBASSO del range notturno (opposto dell'aperture che e' LONG). Complementare all'aperture. In raffinamento (`valid_MaxMin_DAX_short_refine`: buffer x SL-ATR x filtro ampiezza box x correlazione S&P). Nota: un AGENTE non puo' ottimizzare (non ha MT5); l'ottimizzazione gira sul PC di backtest.

### ✅ RAFFINAMENTO DAX night-box SHORT (26.07.26) — CONFERMATO real-tick
_Sweep buffer x SL-ATR x filtro box x correlazione S&P. La correlazione e' la CHIAVE._

| Config (short) | PF | DD% | Trade | Note |
|---|---|---|---|---|
| **corr ON, buffer 1000, AtrSL 2.5, TP2 3.0** ⭐ | **2.05** | 3.1% | 41 | scelto (centrale del plateau) |
| corr ON, buffer 1300, AtrSL 2.5 | 2.25 | 3.2% | 38 | miglior profitto |
| corr ON, buffer 700, AtrSL 2.0 | 2.10 | 3.5% | 39 | |
| corr OFF (qualsiasi) | 1.0-1.25 | 6-9% | ~100 | modesto |

- **La correlazione S&P raddoppia il PF (1.2→2.0+) e dimezza il DD (7%→3%)**, taglia i trade a ~40. Filtro ampiezza box irrilevante (notti DAX sempre larghe).
- Promosso: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (magic 770411) — short only, corr S&P ON, buffer 1000, SL ATR x2.5, TP2 3.0, rischio 1%.
- **Complementare all'aperture LONG:** sul DAX ora copriamo entrambe le direzioni (aperture LONG + night-box SHORT), con setup e orari diversi.
- Nota metodologica: la correlazione S&P NON salvava il breakout M5 (test Marco/Emiliano) ma QUI salva il night-box. Il filtro giusto dipende dalla strategia.

### 🌙 23/08/26 — analisi del PDF di corso "Strategia NIGHTLY" (33 pag.)
Referto completo (parametri, confronto regola-per-regola, verdetto):
**`caccia_strategie/ANALISI_NIGHTLY_PDF_2026-08-23.md`**. Le tre righe che
toccano questo registro — il resto sta nel referto, non si duplica:
- ⚠️ **RETTIFICA al "Nightly 0/8"**: su **U30USD, D30EUR, XAUUSD** l'EA fa
  **ZERO trade** perche' il filtro QB (`InpMaxNightVolPips=45`) e' confrontato
  con `ATR(H1)/PipSize()`, e su indici/oro `PipSize()=_Point` → sempre ≥45.
  **Su quei mercati il fade non e' stato bocciato: non e' stato misurato.**
  Il verdetto negativo regge su EURUSD/GBPUSD/USDCHF (~160 trade a testa).
  > 🛑 **ESTENSIONE DELLA RETTIFICA — 09/09/2026: i simboli non misurati sono
  > SEI, non tre.** Contati oggi sui CSV (`risultati_prove/ABTG_Nightly/*.csv`,
  > commit `400a462`), colonna `Trades`: **AUDUSD 0/0 · USDJPY 0/0 · XAUUSD
  > 0/0 · XAGUSD 0/4 · D30EUR 0/0 · U30USD 0/0**. Hanno un campione vero
  > **solo** EURUSD (106/164), GBPUSD (96/163) e USDCHF (81/131).
  > 🔴 **E la causa del 23/08 non basta**: `PipSize()=_Point` spiega indici e
  > metalli, **non spiega AUDUSD e USDJPY**, che sono forex e sono a zero lo
  > stesso → causa `[NON MISURATO]`. ➡️ Il "0/8" e' un verdetto su **TRE**
  > mercati; gli altri sei tornano in coda all'imbuto come **NON ANCORA
  > MISURATI**. 📄 `report/CONTRADDIZIONI_CHIUSE_2026-09-09.md` §C5.
- ✅ Il **BREAKOUT** del box (questa famiglia) e' confermato dal PDF e dalla
  misura di casa (91,1% delle notti rompe un lato, `NOTTE_ORO.md`).
- 🆕 Unica proposta uscita: **BREAKIN del box notturno** (falsa rottura →
  reversal, PAG 26/28) sul motore `ABTG_LiquiditySweep`, che R89 aveva chiuso
  per **carenza di livelli** (14 trade IS): il box notturno ne da' ~250/anno
  per lato. Spec nel referto §7b; **nessun file prova ancora scritto**.

---

## EA SuperWave — cross EMA14x200 a favore del Supertrend (26.07.26, screen OHLC)
_Nuovo EA dalla dashboard SuperWave (magic 770501). Ingresso: incrocio EMA14xEMA200 confermato dal Supertrend. Griglia StMult 2.5/3.0/3.5 x TP_RR 2.0/2.5/3.0, entrambe direzioni, rischio 1%._

| Sym | Strumento | TF | Migliore | PF | DD% | Trade | Verdetto |
|---|---|---|---|---|---|---|---|
| U30USD | Dow | **H1** | StMult 2.5 / TP 3.0 | **1.42** | 4.3% | 226 | 🟢 vincitore (tutte pos.) |
| D30EUR | DAX | H4 | StMult 3.0 / TP 2.0 | 1.30 | 3.3% | 56 | 🟡 decente |
| U30USD | Dow | H4 | StMult 3.5 | 2.5 | 5.9% | 23 | 🟡 pochi trade |
| NASUSD | Nasdaq | H1 | StMult 3.0 / TP 2.0 | 1.26 | 2.0% | 95 | 🟡 marginale |
| D30EUR | DAX | H1 | — | max 0.84 | 17% | — | 🔴 morto |
| NASUSD | Nasdaq | H4 | — | negative | — | 16-18 | 🔴 morto |
| XAUUSD | Oro | H1/H4 | — | ~1.0/neg | — | — | 🔴 morto (l'oro rende col SupRev, non col cross) |

> **SuperWave: il cross 14x200 e' un motore di TREND** — vivo su Dow H1 (netto, 226tr) e DAX H4 (56tr). Su oro/Nasdaq no. Da validare real-tick: Dow H1 + DAX H4.

### ✅ VALIDAZIONE REAL-TICK SuperWave (26.07.26) — CONFERMATA
| Sym | TF | Config | Profit | PF | DD% | Trade | EA creato | Magic |
|---|---|---|---|---|---|---|---|---|
| U30USD (Dow) | **H1** | StMult 2.5 / TP 3.0 | 1433 | **1.52** | 4.0% | 227 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | 770511 |
| D30EUR (DAX) | **H4** | StMult 3.0 / TP 2.0 | 278 | **1.28** | 3.3% | 56 | `ABTG_SuperWave_DAX_H4_Ottimizzato` | 770512 |

- Dow H1: tutte 9 positive, real-tick (1.52) anche > OHLC (1.42). Robusto.
- DAX H4: 7/9 positive, DD basso. Secondario.
- La dashboard SuperWave (cross EMA14x200 + Supertrend) e' diventata un EA reale validato. Il Dow conferma di essere lo strumento piu' tradabile del parco (SupRev + SuperWave).

---

## G1-PAOLO — i tre valori della live del 27/08, PREPARATO (28.08.26) — NON ANCORA GIRATO

_Ablazione a stella sui tre input che la live di Paolo del 27/08 sera ha
nominato e che **abbiamo gia' nel codice senza averli mai misurati**
(`risultati_archivio/ANALISI_LIVE_PAOLO_2026-08-27.md` §3, spunti P1/P2/P5)._

**🔴 La correzione che cambia il disegno, verificata per grep nel sorgente:
i tre input NON stanno nello stesso EA.**

| input | dove vive DAVVERO |
|---|---|
| `InpEma2` (89 vs **50**) | **solo** famiglia **SupRev** (base + tutti i derivati) |
| `InpAdxMin` (20 vs **25**) | **solo** `ABTG_SupertrendInvert` (riga 65) |
| `InpUseStoch` (ON vs **OFF**) | **solo** `ABTG_SupertrendInvert` (riga 69) |

La famiglia SupRev **non ha** un filtro ADX ne' uno stocastico: non sono spenti,
**non esistono** (`adx=0 stoch=0` su tutti e dieci i file). Le "quattro celle su
un EA solo" non si possono fare, e **nessun input e' stato aggiunto a nessun EA**
(quattro di quelli hanno una sedia viva).

**5 celle, 2 motori, 2 banchi**, tutte su **XAUUSD**:

| cella | EA | TF | delta | magic |
|---|---|---|---|---|
| 00_suprev_base | `ABTG_SupertrendReversal` | H4 | baseline `InpEma2=89` | 778000/778001 |
| 01_suprev_ema50 | `ABTG_SupertrendReversal` | H4 | **`InpEma2` 89 -> 50** | 778100/778101 |
| 10_invert_base | `ABTG_SupertrendInvert` | H1 | baseline ADX 20 + Stoch ON | 778300/778301 |
| 11_invert_adx25 | `ABTG_SupertrendInvert` | H1 | **`InpAdxMin` 20 -> 25** | 778400/778401 |
| 12_invert_stochoff | `ABTG_SupertrendInvert` | H1 | **`InpUseStoch` ON -> OFF** | 778500/778501 |

**Banchi**: S = modello 1 OHLC M1 2020.01.01->2026.06.30 (il campione, n≈208
sull'antenato R103/R114) · V = modello 4 tick reali 2024.07.05->2026.06.30 (il
riempimento vero, campione sottile: n=44 agli atti su oro H4).
**Criterio congelato**: il delta si propone solo se ha lo **stesso segno su
tutte e 4 le sotto-finestre**; segno opposto fra S e V sull'OOS = **conflitto
dichiarato, nessuna proposta**.

- Artefatti: `prove/G1PAOLO_*.txt` (5) · `prove/REFERTO_PREPARAZIONE_G1PAOLO.md`
  (criteri PRIMA dei numeri) · `righe/RIGA_G1PAOLO.ps1` ·
  `righe/RIGA_G1PAOLO_DA_MANDARE.md`.
- ⚠️ **Aperto**: la profondita' **TICK di XAUUSD non e' mai stata misurata**
  (R86/R87 §2.0). Il `2024.07.05` e' **INFERITO** da GBPUSD -> PASSO 0 nella
  pagina della riga.
- ⚠️ **Nessuna sedia viva toccata.** Nessun numero: **il round non e' ancora
  girato.**

---

## ORB — LA FINESTRA DEL RANGE E' CONTESA (letto il 04/09/2026, NON misurato)

_Referto completo: **`caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md`** §1.
Non duplico: qui solo la riga che serve a chi apre il registro._

Claudio ha mandato insieme **la trascrizione della live di Paolo del 03/09** e
**i parametri del suo `ORB_Indicator_V17`**. Le due fonti **non dicono la stessa
cosa** sulla finestra su cui si disegna il box:

| fonte | finestra USA | finestra DAX |
|---|---|---|
| **La VOCE dei docenti** (Paolo 03/09 + Emiliano r.213, RICORRENTE su 18 live) | **15:30-15:45 IT** = **14:30-14:45 server** | **09:00-09:15 IT** = **08:00-08:15 server** |
| **Lo STRUMENTO** (`ORB_Indicator_V17`, `InpTime1 14:25:00` / `InpTime2 14:29:59`; **stessi numeri della V15**) | **14:25-14:30 server** = i **5 minuti PRIMA** dell'apertura | ⚪ **non lo sappiamo**: il preset DAX non ce l'abbiamo |
| 🪑 **LE NOSTRE DUE SEDIE VIVE** (`ABTG_ORB` 770601 NASUSD · `ABTG_ORB_Ottimizzato` 770611 U30USD) | **14:25-14:30 server** (`InpRangeStartHour/Min`, `InpRangeEndHour/Min`) | — |

**Le due finestre non si sovrappongono nemmeno per un secondo**, e hanno durata
diversa (5 minuti contro 15).

- 🟢 **Quello che regge oggi**: la finestra che usiamo **ha una misura dietro**
  (`report/CONTRATTI_SEDIE.md` r.83 — 770611: DD **9,92%** R15, **119 trade**,
  OOS 12,6 mesi). La finestra dettata a voce **non e' mai stata misurata da noi
  su Nasdaq/Dow**. **Il valore misurato batte il valore dettato.**
- 🟢 **Controllo passato, mai fatto prima**: su **4 parametri** (finestra,
  `EntryPoints 10.0`, tabella **K a 6 gruppi**, fine giornata **22:59**) la
  **V17** dell'indicatore da' **gli stessi numeri della V15** su cui e' scritto
  il nostro `ABTG_ORB` (header righe 7-13). **La replica non e' andata alla
  deriva.**
- 🔴 **Prerequisito prima di qualunque griglia**: i **due preset `.set` di Paolo**
  (_"ORB DAX"_ e _"ORB Wall Street"_, r.91) — sono l'unica cosa che scioglie il
  nodo. **Domanda Q1 del referto.**
- ⚠️ **Secondo dubbio, da non nascondere**: lo screenshot dei parametri e' su
  **`NASUSD_EXT`**, che e' **un simbolo custom NOSTRO** (import HistData, in
  frigo per il cancello zero). **[INFERITO] quel terminale e' probabilmente il
  nostro, non quello di Paolo** → quei valori potrebbero essere il default di
  fabbrica, non il preset del docente. **Q1-bis.**

➡️ **SPUNTO S1 (non un candidato, non una coda):** la finestra e' fatta di
**4 input**, `14:25-14:30` vs `14:30-14:45`. **Gradino G1 pulito, zero righe di
codice, nessuna ricompilazione — DOPO Q1**, non prima: se il preset di Paolo
dice una terza cosa, la griglia cambia.

### Le altre due righe che questo referto lascia al registro

- 🔴 **Divergenza fra i due docenti sull'ampiezza del range ORB.** La r.230 di
  questo registro (**RICORRENTE, Emiliano, 18 live**) dice _"niente trade se
  range troppo ampio"_; **Paolo il 03/09 lo nega esplicitamente** (_"mi
  condiziona la size e basta"_). **La riga 230 resta com'e'**: si annota la
  contraddizione, non si riscrive una regola misurata su una live sola.
  ⚠️ Nota: **noi oggi quel filtro non ce l'abbiamo** — siamo per caso allineati
  a Paolo.
- 📌 **ADR: QUARTO passaggio in nove giorni, e le righe 284/299 sono ancora due
  IDEE.** Stavolta con un uso **nuovo**: non solo "distanza <= ADR", ma
  **consumo giornaliero > ~2x ADR -> il mercato si riposa** (e la dashboard
  Python che Paolo annuncia ha **due colonne su dieci** dedicate all'ADR).
  Prerequisito invariato e ancora aperto dal 27/08: **come lo calcola**
  (High-Low o True Range, weekend, confine di giornata).

⛔ **Nessuna azione sulla flotta da questa lettura. Nessun parametro toccato.**

---

## CRT TURTLE SOUP (Neo Malesa, MIT) — CHIUSO 31/08/2026: senza edge a tick nel toro, gate compreso

Saga completa in `risultati_archivio/REFERTO_CRT_2026-08-30.md`. In sintesi:

| banco | finestra | config | risultato | verdetto |
|---|---|---|---|---|
| tick BCM M4 | 2024-2026 (toro) | sweep 30 celle, ungated | PF 0.43-0.73, 0/30 | 🔴 morto nel toro |
| OHLC _EXT M1 | 2020-2024 (4 regimi) | cella robusta | +5744, vive nel CHOP (2022/2023), perde crollo e toro | 🟡 motore da range |
| OHLC _EXT M1 | 2020-2024 | + gate ADX(D1)<=30 | +10135, OGNI regime positivo | 🟢 gate valido su OHLC |
| tick BCM M4 | 2024-2026 (toro) | + gate ADX(D1)<=30, corsa VERA | **PF 0.459** (ungated 0.462), 17/19 mesi rossi, 2 lati rossi | 🔴 **il gate non salva a tick** |

- **NON deployabile. PARCHEGGIATO** candidato-chop: si riapre solo con tick
  Dukascopy del regime range, o mercato tornato chop. Magic 7691xx riservati.
- Lasciti tecnici: EA v3 (CopyRates D1 + fallback M15 — gli handle iADX/iATR
  su D1 NON popolano nel tester tick su nativo: vale per ogni EA futuro);
  classe "skip-senza-Rifai" in CHECKLIST_RIGA_DI_LANCIO.md (4 corse della
  saga erano zombie: CSV stantii spacciati per freschi).

---

## CHAOS LYAPUNOV (gate LLE su EMA-cross, da jojoale CB76446) — BOCCIATO 31/08/2026

Screening OHLC NASUSD_EXT M15 2020-2024, 105 celle (referto:
`risultati_archivio/REFERTO_CHAOS_2026-08-31.md`). Il gate MORDE (15/15 gruppi
monotoni) ma **al CONTRARIO della tesi**: gate stretto (solo "regime leggibile",
LLE basso) = PF 0.39-0.42; gate largo = PF 1.25-1.33. La fascia PF>=1.3 & DD<8%
e' UNA cella su 105 -> outlier -> BOCCIA da criterio congelato. Il verde a gate
largo = drift Nasdaq + ottimismo OHLC su EMA-cross, non edge del gate. n sottile
ovunque (55-92 trade/4 anni). **La tesi "LLE basso = tradeable" e' falsificata
sugli indici.** Magic 769200 libero. Il calcolo LLE resta come mattone misurato.

### Chaos ablazione (31/08, corsa 09:57) — ingrediente LLE NON promosso (criterio congelato)
Gate al massimo (0.09) vs nudo (999) su 2020-2024 OHLC: PF 1.789 vs 1.150,
DD 8.78% vs 21.01%, profit 33175 vs 39724. Passa la condizione PF (+0.64),
fallisce profit_totale -> sepoltura da lettera congelata. Osservazione
registrata: la condizione profit_totale e' anti-filtro per costruzione
(lezione in checklist, vale per le ablazioni FUTURE, non retroattiva).
Porta di rientro: round nuovo su motore diverso con criteri risk-adjusted
congelati prima. EA resta bocciato. Referto:
risultati_archivio/REFERTO_CHAOSABL_2026-08-31.md

### NY Session Retest — PASSO 0 VALIDO (31/08, corsa v5 10:36, tick M15 U30USD)
Retest-VWAP nudo (gate OFF): n=625/21 mesi (~1/gg), **PF 1.002** (pareggio
perfetto), DD 12.9%, pegg.gio -2.0%, take mediano win +87.6 idx pts, LONG
+4789 / SHORT -4575. Overnight veri 2.88% (<5% firmato, assenza tick festivi).
Lezioni pagate nel round: H1 muto per costruzione, flat a ora-del-giorno che
si resetta a mezzanotte (fix: flat di recupero + open_time nel CSV), criterio
zero-overnight-assoluto fisicamente irraggiungibile (riscritto prima dei
numeri). Prossimo: TARATURA del gate slope+espansione (criteri gia' nel
prova). Referto: risultati_archivio/REFERTO_NYRETEST_2026-08-31.md

### NY Session Retest — TARATURA CHIUSA (31/08): gate REALE, edge sotto barra al n minimo
Estensione finale 8 celle: PF massimo a slope 75 (1.37/1.43, DD 3.7-4.7%,
pegg.gio -0.69%) ma n=114-115 < 150 -> muro R59, merito sospeso. A slope 60
(n=160) PF 1.14-1.20 sotto barra. NON promosso, NON deployabile. Primo gate
costitutivo della flotta VALIDATO a tick (slope VWAP: monotono, DD dimezzato;
espansione decorativa). Porta di rientro MECCANICA: tagliando quando la
finestra tick BCM dara' n>=150 sulla cella slope 75 (~5.4 trade/mese, stima
2027) o Dukascopy pre-2024. Referto completo:
risultati_archivio/REFERTO_NYRETEST_2026-08-31.md

---

## IMPORT DUKASCOPY TICK — PASSO 0 CONSEGNATO (31/08/2026): strumenti pronti, NIENTE lancio

L'operazione che sblocca i DUE verdetti parcheggiati (NY Retest slope75
n=114<150; CRT candidato-chop senza tick del suo regime). Consegnati:
- `dukascopy/DUKASCOPY_PASSO0.md` — fattibilita' misurata (tick Dow/Nasdaq
  dal 2012, ~4 min/giorno di crawl misurato il 18/08 = il muro vero),
  mappa fuso UTC->server con le 4 settimane sfasate USA/EU nella
  sovrapposizione, criteri della SONDA congelati PRIMA (mediana diff
  minuto <=0,05%, copertura >=80%, discriminante DST);
- `dukascopy/dukascopy_tick.py` (DUKA-TICK-v1, autotest 9/9 in cloud) —
  .bi5 -> CSV tick mensili in ORA SERVER, due calendari DST implementati,
  cache condivisa col fratello M1, riconversione --solo-cache gratis;
- `mql5/Scripts/ABTG_ImportaTickEsterno.mq5` (BOZZA, MAI COMPILATA) —
  clone U30USD/NASUSD -> U30USD_DK/NASUSD_DK + CustomTicksReplace +
  sonda incorporata col cancello.
Missioni proposte (da firmare): B = NASUSD 2022-2023 (2 notti) prima,
A = U30USD 2019-2024 (4-5 notti) poi. Le righe di lancio arriveranno con
verificatore quando Claudio decidera'. Regola d'uso: SOLO verdetti a
parametri congelati, mai taratura su feed esterno.

### CACCIA FREQUENZA (31/08 sera) — le tre righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_FREQUENZA_2026-08-31.md`. Il resto
sta li', non si duplica.

- 🪦 **DUE LAPIDI NUOVE, da paper letti per intero — risparmiano due cacce.**
  (a) arXiv **2605.11423** (Mesfin): il day-classifier volatilita'+volume+gap
  su MNQ attiva su **4,4% dei giorni = 40 in 4 anni**, e l'autore ha gia'
  falsificato **8 configurazioni direzionali su 8**. Ci lascia pero' una
  conferma esterna del lead sul Dow: **77,6% di quei giorni si ribalta dal
  picco intraday** (restituzione media 11,73 pt, picco fra le 14:00 e le 15:30
  ET). (b) arXiv **2605.17724** (Mesfin): LSTM e gradient boosting su OHLCV
  5-min MNQ, **nessuna configurazione sopra il tasso base del 51,8%**,
  944 giorni. Conclusione dell'autore: **4 anni di OHLCV a 5 minuti su un solo
  strumento NON BASTANO**. La nostra finestra tick sugli indici e' **21 mesi**,
  meno della meta'. 👉 **Niente round ML sugli indici finche' i dati non
  crescono.**
- 🔴 **I due "vincitori" di arXiv 2605.04004 §5 (RTH Confluence, London Signal
  B) NON sono riproducibili**: il loro cuore e' un classificatore GMM che
  l'autore dichiara di "a separate research program" e che **non e' pubblicato
  in nessuno dei suoi tre paper** (verificato per interrogazione autore su
  arXiv). E comunque **fallirebbero il pavimento di frequenza**: 0,72 e 0,31
  trade/giorno contro il minimo di 1. **Non si portano nell'imbuto.**
- 🆕 **Unico promosso: `M0PB`** (Marcns_, MPL 2.0, TradingView, Pine letto
  integrale) — impulso estremo RSI(6) **nel verso** + rientro sulla EMA5,
  uscita al massimo mobile a 12 barre, stop 2,75·ATR(10), **un solo input
  libero**, due lati simmetrici, zero bandiere rosse nel motore.
  **PASSO 0 = SONDA DI CONTEGGIO, non griglia** (le tre fonti dati sono murate
  dal proxy: la frequenza da qui NON si misura). Bozza con criteri congelati:
  `prove/M0PB_FREQUENZA_BOZZA.txt`. Cancelli: **< 1 segnale/giorno → scarto**;
  **take mediano < 6,0 punti indice → scarto**. Ablazione gia' congelata:
  massimo mobile a 12 barre **contro** uscita a tempo alla barra 13.

---

### BreakinBox (falsa rottura box notturno DAX) — CHIUSO 31/08: l'ablazione lo smaschera come R95 con un livello nuovo
Ablazione A/B a tick (2024-2026, D30EUR): TP al lato opposto (tesi) PF 1.007
DD 24.1% contro RR fisso 2.0 (controllo R95) PF 1.106 DD 19.7% -> vince il
controllo su PF E DD = tesi falsificata, e il controllo stesso buca il
cancello DD<=15%. Candidato chiuso da criterio congelato, niente caccia
all'RR. In cassa: conversione D30EUR=100 misurata (prima volta), frequenza
~20/mese due lati, EA-mattone autotestato. Referto:
risultati_archivio/REFERTO_BREAKIN_2026-08-31.md

### DaxReEntry — PASSO 0 misurato (31/08 16:25): LONG 6/6 verde (PF fino 1.80, DD 2.5%), SHORT morto, n<=92 -> merito sospeso R59
Banda long vera ordinata col filtro, bordo aperto a break=40. Take mediano win
+76.8 idx (long): S0 preannunciato largo, si chiude con lo spread flotta.
Frequenza ~3-4/mese/lato: cecchino da mossa-4, non portata. Referto:
risultati_archivio/REFERTO_DAXREENTRY_2026-08-31.md

### CACCIA FREQUENZA — SECONDA BATTUTA (31/08 notte): le righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_FREQUENZA2_2026-08-31.md`. Il resto
sta li', non si duplica.

- 🔧 **CORREZIONE MISURATA, e conta per ogni round forex futuro: il pavimento
  1999 del forex e' su OHLC M1, NON sui tick.** `R102_REFERTO_BLOCCO1.md`
  riga 6 dice *"modello OHLC M1"* e riga 136 *"niente tick reali"*;
  `BLOCCO2` riga 19 dice *"Prima operazione 1999.01.04 su tutte e tre"*.
  ➡️ Sul forex abbiamo **~27 anni di M1 OHLC misurati** (vantaggio vero per lo
  SCREENING e per la PROVA DI REGIME: toro/orso/laterale/crollo si scelgono
  davvero, contro i 21 mesi a regime unico degli indici), ma **la profondita'
  TICK del forex BCM non e' mai stata sondata** — stesso buco aperto di XAUUSD
  (G1-PAOLO). **`F6 verdetti solo a tick` non si ammorbidisce**: `@DAQUANDO` si
  MISURA con `scarica_storico.ps1`.
- 🪦 **Il Code Base ha smesso di produrre motori, ed e' misurato.** Interrogati
  uno per uno i 20 id piu' recenti (76669 → 75473): **15 attrezzi** (pannelli,
  calcolatori, sei utility `Quantora` di fila, logger), **3 recovery/basket**,
  1 gia' bocciato (Chaos 76446), 1 motore generico. **Zero EA di sessione, zero
  forex intraday, zero uscite a tempo, in quattro pagine.** ➡️ **Non aprire piu'
  il Code Base per cercare MOTORI intraday: aprirlo per gli ATTREZZI** — come
  il *RealCost Spread P95 Logger* (**74148**), promosso il 23/08 e **mai usato:
  sesta caccia che lo scrive**.
- 🆕 **QuantConnect e' raggiungibile (200 su bersaglio noto, mai usata prima in
  6 dossier) ma NON e' una fonte per noi**: la libreria e' fatta di strategie
  di PORTAFOGLIO a ribilancio giornaliero/mensile. Lette per intero
  `Combining Mean Reversion and Momentum in Forex Market` (**ribilancio
  MENSILE**, ~1-2 trade/mese, nessuno stop) e `Dual Thrust` (range breakout,
  nessuno stop, ~1/giorno). **Quantpedia riconfermata PREMIUM** su 4 slug reali
  (302.356 byte identici = home page).
- 🔴 **DIREZIONE "tenuta lunga" (12-15 barre, arXiv 2605.04004 §6.2): ZERO
  candidati nel web gratuito**, e il motivo e' strutturale (il retail esce su
  TP/SL, l'accademia ribilancia il mese). 🎯 **La risposta e' in casa e non e'
  mai stata accesa: la `SONDA DELL'OROLOGIO`** (EA `ABTG_SondaOrologio.mq5`,
  7 file prova, `RIGA_SONDA_OROLOGIO_DA_MANDARE.md`, referto di preparazione —
  tutti preparati il 28/08). **In `risultati_archivio` NON esiste nessun
  referto: non e' MAI girata.** E' il solo meccanismo FX a tenuta di ore con
  frequenza >=1/giorno che il progetto possieda.
- 🆕 **Unico promosso: `EURUSD 5min london session strategy`** (SoftKill21,
  MPL 2.0, TradingView, Pine v4 letto integrale, **52 righe / 8 input**) —
  canale SMA5(high)/SMA5(low) rotto in **chiusura**, sessione di Londra,
  conferma RSI(5) **che l'autore dichiara opzionale**, `close_all`
  incondizionato a fine sessione, **`max_intraday_filled_orders(6)`** e
  **`max_intraday_loss(2, percent_of_equity)`** dentro il motore.
  🎯 **Il numero che lo promuove e' la GEOMETRIA: `tp=150 / sl=80` tick =
  RR 1,875 → supera il cancello H8 con un win rate del 37,4% lordo / 42,0%
  netto a 1 pip di costo, contro il 62-79% richiesto da M0PB e il 53,8% di
  P2.** Frequenza **~5/giorno DICHIARATA DALL'AUTORE** sulla pagina e
  confermata da due righe di codice — [DICHIARATA, non misurata: le tre fonti
  dati restano murate].
  **PASSO 0 = SONDA DI CONTEGGIO, non griglia.** Bozza coi criteri congelati:
  `prove/LONDONFX_FREQUENZA_BOZZA.txt`. Cancelli: **<1 segnale/giorno →
  scarto**; **escursione favorevole mediana <3,0 pip → scarto**; **RR<0,70 →
  scarto per aritmetica senza corsa a tick**.
  🔬 **Due ablazioni gia' congelate:** (1) canale **nudo** contro canale+RSI
  (l'autore dichiara l'RSI accessorio → filtro appiccicato, 0/5 in casa);
  (2) **UN SOLO EA contenitore** (`ABTG_LondonFx`: sessione + flat + cap
  giornalieri + rischio %) con **tre motori a interruttore** — canale nudo,
  canale+RSI, e **l'allineamento a 5 medie del P2 del 28/08 (stesso autore,
  stessa coppia, stessa sessione, mai girato)**. Se i tre vanno uguale, **il
  contenitore E' l'edge** e il segnale non conta.

## M0PB (Momentum Pull Back, Marcns tv/GnsUpEsB, MPL 2.0) — MORTO AL PASSO 0, 31/08/2026
- **Verdetto: MORTO 12/12** (3 indici × 2 TF × 2 lati) alla sonda di conteggio
  `ABTG_SondaM0PB` (contatore puro, zero ordini, open prices, pin `4e1cdf8`,
  corsa 31/08 19:35). Referto: `risultati_archivio/REFERTO_SONDAM0PB_2026-08-31.md`.
- **F1 (frequenza): 0/12.** Lato migliore 0,52 segnali/giorno (U30 M5 short)
  contro soglia 1,00; su M15 0,15-0,21. Il claim "alta frequenza" della pagina
  TradingView sui nostri indici RTH vale un segnale ogni 2 giorni per lato.
- **H8 (RR >= 0,70, FIRMA 2): 7/12 sotto**, i 5 sopra a 0,70-0,74; win rate
  necessario 62-70%. Stop 2,75xATR strutturalmente piu' largo del take.
  T10: nessun mult va pescato per far passare il cancello.
- **F2 (take > 7 punti idx): 12/12 verdi** (27-119 punti) — irrilevante senza
  frequenza e senza RR.
- Collaudi 6/6 verdi (autotest 0/12, determinismo 2 passate, ATR alla Pine
  davvero diverso da iATR: 9,6-16,4%). Costo del verdetto: 1 compilazione +
  12 passate (~minuti), ZERO corse a tick sprecate. **La sonda-prima-dell'EA
  paga: e' il modo giusto di bocciare.**
- **NON ritestare con altre griglie** (seconda caccia 19/08). Alternative gia'
  in vivaio, stessa missione frequenza: LondonFx (RR 1,875, bozza congelata)
  e Sonda dell'Orologio (pronta dal 28/08, mai girata).

> ### 🛑 RETTIFICA DEL 09/09/2026 — IL VERDETTO SCENDE DA **"MORTO"** A **"NON ANCORA MISURATO"**
> _I dodici numeri qui sopra **restano**: sono buoni, sono riproducibili e
> costano minuti. Cambia il **verdetto**, e cambia per due motivi che con
> l'accusa originale **non c'entrano**._
>
> #### ✅ Prima, la buona notizia: l'accusa di metodo e' FALSA, e va detto
> `report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` §R5 sostiene che il win rate
> **62-70%** sia *"aggiunto DOPO aver visto i numeri"*, violando la regola di
> casa. 🔎 **Controllato sui file e sugli orari: non e' andata cosi'.** Il
> file prova `prove/M0PB_FREQUENZA_M5.txt` §F4-bis **congela prima della
> corsa** sia la soglia **RR ≥ 0,70** sia la **tabella del win rate**
> (*"RR 0,36 → 79,0% | 0,50 → 71,7% | 0,73 → 62,2% | 1,00 → 53,8%"*), sotto
> l'intestazione **"CRITERI DI ACCETTAZIONE (CONGELATI IL 31/08 PRIMA DI OGNI
> NUMERO)"**. Cronologia dai commit: prova+riga `2c4b466` **15:08 UTC** e
> `4e1cdf8` **15:31 UTC**; corsa **19:35**; referto `8ee2392` **18:27 UTC**.
> 👉 **I criteri erano congelati ore prima. La casa ha fatto il suo lavoro.**
> L'unico pezzo davvero non congelato e' l'inciso editoriale *"la zona che in
> casa non ha mai pagato"* — che e' un **commento**, non un cancello, e non
> compare in nessuna delle 12 celle di verdetto.
>
> #### 🔴 Ma il verdetto scende lo stesso, per DUE motivi migliori
> 1. **`F1` e' stato applicato PER LATO, e quell'unita' non e' piu' quella di
>    casa.** La firma del **07/09** (`report/FIRME_2026-09-07.md`, H13;
>    `CLAUDE.md` §PAVIMENTO DI FREQUENZA) sposta il pavimento di **1,00
>    op/giorno** dalla **singola sedia** alla **FAMIGLIA**. Con l'unita' nuova,
>    e usando **i numeri del referto stesso** (r.35-40): M5 sui **3 indici, due
>    lati** = **2,957 op/giorno**; le 5 celle che passano H8 = **1,516**;
>    NASUSD M5 due lati da solo = **0,992**. 👉 **`F1: 0/12` era il cancello
>    che uccideva 12 celle su 12, ed e' l'unico decaduto per firma.** E
>    `CLAUDE.md` e' esplicito: le esclusioni motivate **solo** dalla frequenza
>    *"tornano in coda all'imbuto, **mai in campo in automatico**"*.
> 2. **`H8` come FIRMATO non e' mai stato misurato.** La FIRMA 2 del 31/08 dice
>    testualmente *"**E ≥ 0.075R misurata A TICK**"*. Il passo 0 ha usato una
>    **delega dichiarata** — `RR = mediana(take)/mediana(stop)` su passata
>    open-prices — che il file prova ammette apertamente. E' onesto ed e'
>    congelato prima, **ma un rapporto di mediane non e' un'attesa**, e la
>    corsa a tick che la firma richiede **non e' mai stata lanciata**
>    (*"Nessuna corsa a tick va lanciata"*). 👉 **`E` = `[NON MISURATO]`.** E
>    perfino sulla delega **5 celle su 12 PASSANO** (0,712-0,743).
>
> #### 🪦 E il CERTIFICATO DI MORTE (regola del 09/09) non e' compilabile
> Servono cinque voci; M0PB ne ha **due**: ✅ TF cambiato (M5 **e** M15) · ✅
> simboli gemelli (3 indici × 2 lati). Mancano: 🔴 **PF** (la sonda e' un
> contatore puro, **zero ordini**) · 🔴 **n e DD** (nessun trade simulato) ·
> 🔴 **gestione dell'uscita mai messa ad asse** (lo stop e' rimasto **fisso a
> 2,75×ATR** in tutte e 12 le celle — ed e' *proprio quello* che fa cadere
> l'RR, perche' lo stop e' strutturalmente piu' largo del take).
> ➡️ **Verdetto: `NON ANCORA MISURATO`. Torna in coda all'imbuto.**
>
> #### 🎯 Cosa servirebbe per giudicarlo con criteri congelati prima
> **Congelare PRIMA di lanciare**, in un file prova nuovo: **(a)** il pavimento
> di frequenza dichiarato **per FAMIGLIA** (H13), non per lato; **(b)** `E ≥
> 0,075R` **misurata a tick** — cioe' un EA con ordini veri, non una sonda —
> perche' e' il cancello **come firmato**; **(c)** almeno **un asse sulla
> gestione dell'uscita** (il moltiplicatore dello stop e/o un take
> strutturale), **dichiarato come asse e non come recupero**, cosi' che non
> violi la seconda caccia del 19/08; **(d)** le due finestre con **n ≥ 150**
> per lato o la rinuncia esplicita al giudizio di MERITO (valvola R59).
> ⚠️ **Nulla di questo dice che M0PB funzioni. Dice che non lo sappiamo.**
> 📄 Verbale: `report/CONTRADDIZIONI_CHIUSE_2026-09-09.md` §C8.

## RSI+EMA V8 (Pine anonimo, incollato in chat 01-02/09) — NON PROMOSSO, CONFERMATO DA MISURA, 03/09/2026
- **Verdetto: il filtro RSI toglie solo il 9-13% degli incroci EMA(5/20)**
  (ablazione su 7 corse: 3 indici x M5/M15 + ORO_M15, 21 mesi, sonda
  `ABTG_SondaRsiEmaV8`, pin `0f01962`). Nei numeri e' un incrocio di EMA:
  famiglia SuperWave/ChaosLyapunov, gia' morta due volte. Il verdetto di
  carta del 31/08 (SCHEDA_RSIEMA_V8) esce CONFERMATO DA UNA MISURA — la
  porta di rientro e' stata esercitata coi numeri, come chiesto da Claudio.
- F1 abbondante (2,0-6,6 segnali/giorno per lato: la frequenza non era il
  problema); geometria MFE~MAE, RR 0,92-1,17, WR necessario 50-56% =
  moneta lanciata (indicazione, limiti superiori); muro F4: a taglia di
  flotta 19,5% (M5) / 8,45% (M15) di rischio aperto contro cap 3,25%.
- PROBLEMI 7 dichiarati: invariante V8 della sonda violato su ~1-1,5% dei
  segnali -> escursioni NON certificate; il verdetto poggia sui CONTEGGI
  (robusti). Referto: `risultati_archivio/REFERTO_SONDARSIEMAV8_2026-09-03.md`.
- **NON ritestare con altre griglie.** L'esperimento manuale di Claudio
  (diario DIARIO_MANUALE_V8.md) continua: misura Claudio+V8, non il V8 nudo.

## LONDONFX (canale di Londra + RSI, EURUSD) — PASSO 0 SUPERATO, 03/09/2026
- **PRIMO SUPERSTITE della missione frequenza**: su EURUSD M15 con RSI,
  12/12 righe VIVE (2,0-2,3 segnali/giorno per lato, MFE med 10-13,4 pip,
  RR 0,90-1,14); M5 vivo a ora 8, sospeso a ora 4 (spread non misurato).
  Ablazione: il filtro RSI taglia il 73-77% dei segnali nudi (filtro VERO,
  opposto del V8). Corsa pulita: PROBLEMI 0, collaudi tutti verdi.
- Referto: `risultati_archivio/REFERTO_SONDALONDONFX_2026-09-03.md`.
  GEMELLA GBPUSD (09:16): 24/24 righe VIVE, MFE 12,6-16,3 pip su M15+RSI,
  filtro -76% anche sul Cable. Prossimi passi: SPREAD_FLOTTA (74148), round a
  tick reali su EURUSD M15 ora=8 con criteri congelati prima + ablazione
  a 3 motori (contenitore vs segnale). Il passo 0 conta occasioni: il
  MERITO non e' ancora misurato.
- 📝 **BOZZA DEI CRITERI del round a tick (R116 proposto, numero verificato
  libero il 03/09): `risultati_archivio/LONDONFX_TICK_CRITERI.md`** — DA
  FIRMARE, 12 righe F. Banco: tick REALI dal pavimento misurato 2024.07.05
  -> 2026.06.30 (~23,8 mesi, UN SOLO REGIME), M15, EURUSD+GBPUSD, ora
  CONGELATA a 8, rischio 0,65%. Cancelli: E OOS >= 0,075R NETTA (FIRMA 2
  del 31/08) · PF >= 1,15 · DD <= 8,0% · peggior giornata >= -4,0% (oltre,
  il Guardian avrebbe messo in pausa: backtest non riproducibile) · n >= 150
  per gamba. Ablazione a 3 motori con soglia di somiglianza DICHIARATA PRIMA
  (scarto di E <= 0,05R = 2/3 del cancello H8 -> "il contenitore e' l'edge").
  Numero da tenere in cima: 1R = 8 pip, il cancello vale 0,60 pip e lo
  spread assunto 1,0-2,0 -> **il costo e' 1,7-3,3 volte l'edge richiesto**.
  Previsione dichiarata prima: MAE mediana 11,8 pip > SL 8,0 pip -> l'esito
  piu' probabile e' un NO. NIENTE e' stato girato ne' compilato.

### CACCIA FREQUENZA — QUINTA BATTUTA (03/09, fronte B): le righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md`.
Il resto sta li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi.**

- 🔓 **SI POSSONO SCARICARE BARRE M1 DA QUI.** `github.com/FutureSharks/financial-data`
  (GPL-3.0) via `raw.githubusercontent.com`: **DAX (`GRXEUR`, stessa scala di
  D30EUR), S&P, Nikkei, EuroStoxx M1 2010-2018** e **Nasdaq/oro/major M1
  2005-2020**. Scaricate e usate oggi: **1.870.955 barre M1**. Chiude il buco
  dichiarato in quattro dossier ("da qui nessun agente puo' misurare una
  frequenza"). Limiti e percorsi: `PROMEMORIA_SBLOCCO_FONTI.md` (blocco 03/09)
  e `caccia_strategie/biblioteca/sonde_esterne/LEGGIMI.md`.
  ⚠️ **Non e' BCM, e' OHLC M1, e' senza costi, e finisce nel 2020: da qui
  escono MISURE DI OCCASIONI, mai verdetti.** F6 non si ammorbidisce.
- 🩹 **CORREZIONE:** girava l'idea che **R95 (sweep+reclaim JPY) fosse "in coda,
  non morto"**. `R95_REFERTO.md` (23/08) dice **0/30, PF 0,65-0,80, nessuna
  passata sopra 1,00**, con **21.354 livelli creati e 0 buttati** e l'asse
  della DENSITA' gia' spazzolato da M30 a H4. **E' bocciato.**
- 🪦 **TRE LAPIDI NUOVE, tutte con un numero.**
  (a) **Post-news 15-30 min: chiuso.** `arXiv 2605.04004` §4.7 (paper gia'
  citato in 18 file del repo, §4.7 mai letto): 993 eventi 2022-2025 su MNQ,
  _"the drift is real in the first five bars … From bar +6 onward, T-statistics
  … are between 0.14 and 0.69"_, RTH T=0,38, Appendice A **`D127 — MNQ
  post-news drift permanently rejected — LOCKED`**. E _"news proximity adds no
  value"_ nemmeno come FILTRO. ⚠️ misurato su Nasdaq: per le due sedie
  `ABTG_PostNews` su EURUSD/EURJPY e' un'indicazione forte, non un verdetto.
  (b) **Sweep di micro-pivot sugli indici M5/M15: chiuso.** La densita' che
  aveva ucciso R89 (14 trade IS) **si risolve** — pivot(3,3) da' **4,22-4,57
  segnali/giorno per lato su DAX M5** — ma su **22.616 segnali** il tasso
  TP-prima-di-SL e' **43,5-48,2% contro il 49,6% richiesto da H8 (8/8 sotto)**
  e il **delta contro un ingresso CASUALE della stessa geometria e' −0,2 punti**.
  (c) **Compressione ATR → espansione: chiusa.** Su **9.723 segnali**,
  frequenza **0,55-1,87/gg per lato (0/8 sopra il pavimento)** e TP-prima-di-SL
  **31,6-36,0% contro 35,8% (7/8 sotto)**, delta contro il caso **−1,2 punti**.
- 🧪 **LA LEZIONE DI METODO, e vale per ogni sonda futura: IL CONTROLLO A
  INGRESSI CASUALI.** Un tasso di vittoria da solo non dice niente; dice tutto
  accanto al tasso di un ingresso **a caso con la stessa geometria, sugli
  stessi dati**. Su **16 celle e 32.339 segnali** il delta medio e' **−0,70
  punti**. Costa dieci righe. **Da oggi ogni sonda di conteggio porta il suo.**
- 🛠️ **UNA RIPARAZIONE VALE PIU' DI UNA CACCIA:** `ABTG_OutOfNoise` **non e'
  bocciato, e' rotto** (`REFERTO_PASSO0_OUTOFNOISE_2026-08-29.md`, n=0 su 3
  celle): `CopyRates(...,0,need,r)` conta barre di **calendario** invece che di
  **seduta**, quindi `nDays` resta 4-5 contro `InpConeMinDays=14` e l'EA non
  entra mai. **Ed e' proprio il "momentum intraday M5/M15" che la caccia
  cercava fuori**: la versione ad alta frequenza del paper di Gao e' quella di
  Zarattini-Aziz-Barbon, e il suo porting e' gia' in casa.
- ⛔ **Meccanismi chiusi per ARITMETICA, non per qualita':** gap intraday e
  gap-fill (**un gap di apertura e' UNO al giorno**: nessuna implementazione
  puo' superare il pavimento di 2 segnali/giorno per lato).

## QUINTA BATTUTA CACCIA FREQUENZA (03/09/2026, tre fronti per MECCANISMO) — 0 EA promossi, 3 lapidi misurate, il giacimento e' in casa
- Dossier: `caccia_strategie/CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md` (24
  meccanismi in 10 famiglie), `CACCIA_FREQUENZA5_IMPLEMENTAZIONI_2026-09-03.md`
  (8 meccanismi battuti, 47 strategie, 12 sorgenti letti, MISURE su 32.339
  segnali con controllo a ingressi casuali), `report/GIACIMENTO_DI_CASA_2026-09-03.md`
  (122 artefatti censiti).
- **LAPIDI (misurate, non opinate):** (L1) regime post-news 15-30 min su
  Nasdaq: CHIUSO — arXiv 2605.04004 §4.7, 993 eventi, T 0,14-0,69 da barra +6,
  "D127 permanently rejected"; (L2) sweep di micro-pivot sugli indici: densita'
  ok (4,2-4,6/gg) ma TP-prima-di-SL 43-48% contro 49,6% richiesto, 8/8 sotto,
  delta vs caso -0,2 pt su 22.616 segnali; (L3) compressione ATR -> espansione:
  0/8 sopra il pavimento di frequenza, 7/8 sotto H8, delta vs caso -1,2 pt su
  9.723 segnali; (L4) gap intraday: uno al giorno per costruzione, non puo'
  superare il pavimento; (L5) momentum intraday di Gao: morto in casa (R98) per
  attrito overnight che sui CFD non esiste (Elaut-Frommel-Lampaert); (L6)
  contrarian post-sovrareazione su forex/commodity: chiuso dagli autori
  (Caporale-Plastun) e coerente con R42 0/24.
- **CORREZIONE agli atti:** R95 (sweep JPY) NON e' "in coda": `R95_REFERTO.md`
  23/08 = 30/30 passate in perdita, PF 0,65-0,80. E' BOCCIATO.
- **NOVITA' DI METODO:** (a) dati M1 storici raggiungibili via
  raw.githubusercontent (FutureSharks/financial-data, GPL-3: DAX/S&P/Nasdaq/oro
  2005-2020, fuso EST, OHLC non tick, zero costi -> misure di occasioni, mai
  verdetti); (b) controllo a INGRESSI CASUALI con la stessa geometria, sugli
  stessi dati: un win rate senza il suo caso non dice nulla (script in
  `caccia_strategie/biblioteca/sonde_esterne/`); (c) uno zero su arXiv NON e'
  assenza di letteratura (la microstruttura vive su JF/JFE/RFS/JBF, non su arXiv).
- **CONVERGENZA DEI TRE FRONTI:** il materiale migliore e' GIA' IN CASA:
  `ABTG_OutOfNoise` = esattamente il momentum intraday di Zarattini-Aziz-Barbon
  (SFI RP 24-97), baco di warmup gia' corretto (v1.01/v1.02), MAI rigirato ->
  una corsa; Sonda dell'Orologio (celle GBPUSD/oro dopo il Passo C);
  `ABTG_VwapRevert` (M15 DAX, oggi adjudicabile con lo spread misurato);
  `ABTG_AllineaLondra` (M15 EURUSD). Meccanismi nuovi con evidenza da rivista,
  mai toccati: fix valutari (Krohn-Mueller-Whelan JF 2024 — sopravvive SOLO il
  fade dello spike, la deriva muore di costo x2,7), numeri tondi (Osler JF
  2003), salti statistici (Lee-Mykland RFS 2008), lead-lag USA->Europa
  (misurabile con la sonda RELATIVO). Regola nuova proposta: prima di portare
  un meccanismo accademico sui CFD, chiedersi su quale ATTRITO ISTITUZIONALE
  poggia e se esiste su BCM.
- **La mossa piu' economica del prossimo giro:** SPREAD_FLOTTA su
  EURUSD/GBPUSD/XAUUSD (stessa macchina del 03/09, zero modifiche): tutti i
  cancelli forex poggiano ancora su una convenzione.

## 🪦 ABTG_VwapRevert (D30EUR M15) — FALSIFICATO 03/09/2026, cancello S0
Passo 0 girato a tick reali (`backtest_pipeline/risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt`):
4 celle (00_nudo, 01_long, 02_short, 03_overnight), tutte **S0 NON PASSA** (rapporto
punti/spread ben sotto 2,5, anzi NEGATIVO su tutte e quattro: -0,11 / -0,21 / -0,14 / -0,21).
Il motore perde in media PIU' dello spread: non e' un problema di costo, e' un problema
di edge. Per la clausola gia' scritta nella bozza dei criteri ("un S0 NON PASSA sulla
00_nudo chiude il capitolo VWAP anche come motore: non si cerca un'altra taratura per
farlo passare"), il candidato e' CHIUSO. n OOS 00_nudo=107 (sotto 150: comunque il
rischio era gia' bocciato dal merito prima che il campione contasse). Nessuna nuova
taratura di InpSigmaMult o altri parametri: il meccanismo VWAP-reversion su D30EUR M15
e' arato.

## 🪦 R116 ABTG_LondonFx EURUSD (M15, tick reali) — BOCCIATA PER RISCHIO, tutti e 3 i motori
`backtest_pipeline/risultati_archivio/r116_londonfx/CORSA_EURUSD_2026-09-03_1751_BOCCIATA.txt`.
IS 2024.07.05->2025.04.21, OOS 2025.04.22->2026.06.30, un solo regime (dichiarato). Motore 2
(canale+RSI, l'unico promuovibile): E OOS=-0,1078R (soglia 0,075R), PF OOS=0,843 (soglia 1,15),
DD OOS=37,14% (tetto 8%), IS gia' in perdita (profit -36.353,98, PF 0,795). Motori 1 e 3
(controlli) bocciati per rischio allo stesso modo (DD 45,29% e 31,26%). Nessuno passa A1/A2/A3/A4.
Ablazione S1: differenza fra motori 0,0561R, sopra soglia 0,05R MA nessun motore passa i cancelli
di merito, quindi nessuna promozione comunque. Fase 2 (slippage) NON dovuta: nessuna cella
passa i cancelli A. **Previsione pre-dichiarata nei criteri (par. 0.2): "NO probabile" -- CONFERMATA.**
Rilievo: motore 1 (controllo, canale nudo) e' strozzato dal tetto giornaliero (38%/22% dei giorni
oltre soglia 20%): il suo posto nel confronto S1 e' contaminato, ma non cambia il verdetto (nessun
motore passa comunque). Spread misurato ed archiviato (F9/H12): EURUSD Londra motore 2, IS mediana
0,200 pip, OOS mediana 0,100 pip. GBPUSD ancora da girare, ma la bocciatura e' PER RISCHIO (non per
frequenza): probabile lo stesso esito, si vede.

## 🪦 R116 ABTG_LondonFx GBPUSD (M15, tick reali) — BOCCIATA PER RISCHIO (numeri peggiori di EURUSD) + BANCO SPORCO su motore 3
`backtest_pipeline/risultati_archivio/r116_londonfx/CORSA_GBPUSD_2026-09-03_1755_BOCCIATA_BANCO_SPORCO.txt`.
Motore 2 (l'unico promuovibile): E OOS=-0,1726R (peggio di EURUSD -0,108R), PF OOS=0,763, DD OOS=55,03%,
IS gia' in perdita pesante (PF 0,688). Motori 1 e 3 bocciati con DD 55-61%. **R116 CHIUSO su entrambi i
simboli, entrambi bocciati per rischio, previsione pre-dichiarata ("NO probabile") confermata due volte.**

⚠️ **PROBLEMA PROCEDURALE, da investigare separatamente:** il gate di sanita' del driver (5.0.1) ha
dichiarato il banco GBPUSD "FERMO" -- i gemelli (stesso motore 3, magic 774001 vs 774002, dovrebbero
dare Profit/Expected Payoff IDENTICI) DIVERGONO su IS e OOS. Non cambia il verdetto (tutti e tre i
motori sono comunque ben dentro la bocciatura per rischio, la divergenza non sposterebbe nessun numero
dentro i cancelli), ma segnala un problema di determinismo/non-riproducibilita' del tester su questo
banco che va capito prima di fidarsi ciecamente dei prossimi round su GBPUSD. Motori 1 e 2 non
segnalati come rotti dal gate.

✅ **04/09 -- LA CAUSA E' CONFERMATA, e non e' l'EA: CLASSE 129** (checklist, riquadro suo).
Piu' **agenti locali MT5 vivi insieme** fanno divergere davvero le celle che dovrebbero uscire
identiche: su `RIGA_POSTNEWS_ISM`, 5 corse consecutive con 4 core attivi hanno dato **5 divergenze
DIVERSE** (39, 13, 20, 2, 7 operazioni di scarto, mai lo stesso numero), e con **Core 1 solo** i
gemelli sono usciti **identici alla prima corsa**. La corsa GBPUSD del 03/09 girava con piu' agenti.

📄 **05/09 -- RIGA PRONTA PER RIFARLA A BANCO PULITO: R116-BIS.**
`righe/RIGA_R116BIS_LONDONFX_DA_MANDARE.md` + driver `righe/RIGA_R116BIS_LONDONFX.ps1`
(pin `c3a21c6...`, marcatore `MARCATORE_RIGA_R116BIS_LONDONFX_v1`). **Non tocca un solo parametro
del motore**: stessi criteri firmati, stesso EA v1.01 (blob identico a quello che ha girato),
stessi due prova (blob identici), stessi cancelli. Cambia **solo il banco** -- un agente solo -- e
l'etichetta dei CSV (`R116B_`, cosi' i CSV del giro sporco non si possono rileggere al posto di
questi. Il driver **conta i processi `metatester64` vivi** ogni 400 ms e mette il massimo nel
referto: **> 1 = PROBLEMA, round fermo**, qualunque numero sia uscito (un gate che non legge niente
non e' un gate verde). Le tre letture del confronto col 03/09 sono **congelate nella pagina prima
dei numeri**: (a) numeri uguali -> la bocciatura GBPUSD diventa leggibile e R116 chiude pulito;
(b) numeri diversi -> il referto GBPUSD del 03/09 e' carta straccia **e diventa obbligatorio
rifare anche EURUSD**; (c) gemelli che divergono ANCORA a un agente -> la classe 129 non spiega
tutto, e il sospettato diventa il motore 3.
⚠️ **La gamba EURUSD del 03/09 NON si rifa' per obbligo**: aveva PROBLEMI 0 e gemelli identici su
3 coppie, cioe' il gate di identita' -- la prova di casa che il banco era pulito -- e' PASSATO.
⚠️ **E il verdetto non e' in gioco comunque**: F12 resta firmata, da R116 **non esce una sedia**.

### SECONDA CACCIA DOPO R116 (03/09 sera) — le righe che toccano questo registro

Dossier completo: `caccia_strategie/CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md`.
Il resto sta li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi.**

- 🪦 **L'APERTURA DI LONDRA E' CHIUSA IN TUTTE E DUE LE FORME "A LIVELLO", e la
  chiusura non viene dal web: viene dai nostri `input`.** I 4 migliori candidati
  esterni letti oggi (TradingView: `4H Range Scalp V3 - Smart Fakeout`,
  `Strategy_500 Turtle Soup NY V5`, `Gold H1 Breakout Failure`,
  `Parent Session Sweeps`) sono **riga per riga `ABTG_BreakinBox`**, che il
  31/08 e' stato misurato a tick su D30EUR e **CHIUSO da lettera congelata**
  (A: TP al lato opposto **PF 1,007 DD 24,1%** · B: RR fisso 2,0 **PF 1,106
  DD 19,7%**, cancello DD <=15%). Verificato negli `input` del nostro EA
  (righe 191-237): `InpConfirmMaxBars=8` **e'** il `max_bars_outside=6` del
  candidato C1; `InpSlBufferPts` **e'** l'SL all'estremo dello sweep;
  `InpMinBoxATR` **e'** il filtro di ampiezza; `InpTP_RR` **e'** l'ablazione.
  👉 **Non si riapre cambiando simbolo**: sarebbe BreakinBox su forex, e R95 ha
  gia' girato quella geometria su EURJPY (**0/30**).
- 🕐 **IL FUSO DI LONDRA E' CHIUSO (aperto come `[INCERTO]` il 19/08 con TRE
  valori diversi in tre posti).** Il Passo 0 di `ABTG_AllineaLondra` (03/09
  16:51) lo scrive misurato: _"l'orologio del server BCM segna la STESSA ora di
  Londra tutto l'anno"_ → **Londra apre alle 08:00 ORA SERVER**. Ne segue che
  `Londra_ORB` ("06-07 server") e R45 ("07:00 server") misuravano la
  **pre-apertura**, non l'apertura.
- 🎯 **L'alternativa vera sulla stessa inefficienza NON e' un range: e' la
  DERIVA ORARIA** (`OROLOGIO_VS_BREEDON_2026-09-03.md`, misurata oggi) —
  EURUSD **SHORT 08:00-16:00 server**, C1 **4,59** su IS 2011-2017 (n=1.607) e
  **5,31** su OOS 2017-2026 (n=2.411), **cella indicata PRIMA dei numeri**.
  Zero livelli, zero rotture: **nessuna parentela con i sei caduti di Londra**,
  e riempie il buco SHORT. Il suo problema e' l'**ESECUZIONE** (~1 bp la uccide),
  non l'edge → la domanda del prossimo round e' *"come si entra senza pagare lo
  spread"*, non *"quale motore"*.
- 🔬 **CONTROLLO DI METODO NUOVO, da rifare sempre: la licenza si verifica
  contro un bersaglio noto.** Prima di scrivere "nessuna licenza" su 8 sorgenti
  ho riscaricato uno script che sappiamo MPL: **l'intestazione c'e'**, quindi il
  canale non la perde. Risultato scomodo: **i due candidati con MPL 2.0 sono
  quelli ROTTI** (`SMC Liquidity Grab Pro` ha `barmerge.lookahead_on`;
  `Falcon Liquidity Grab` ha `low < ta.lowest(low,5)`, condizione
  **matematicamente impossibile**), e i quattro scritti bene non hanno licenza.
  **Una licenza libera non certifica che il codice funzioni.**
- ⛔ **ANGOLO REGIME: bloccato dai DATI, non dall'idea.** `REFERTO_CRT` STAGE-2
  misura che il fade di sessione e' un motore da **CHOP** (2023 **+5.259** su
  n=83; orso 2022 **+2.633**) e **perde nel crollo (−2.760) e nel toro liscio
  (−609)**. I tick BCM coprono **21-24 mesi di solo toro**: il regime in cui la
  famiglia vive **non e' raggiungibile** senza l'import Dukascopy (strumenti
  pronti dal 31/08, **mai lanciati**). Stessa porta di CRT e NY-Retest.
- 🕳️ **Buco dichiarato:** **Osler 2003 (JF) e Osler 2005 (JIMF)** — la tesi
  accademica sotto lo stop-hunt — **NON APERTE**: SSRN 403 (13ª di fila),
  `newyorkfed.org` egress-blocked, mirror `technicalanalysis.org.uk` 403,
  `ideas.repec.org` egress-blocked su due trasporti. ⚠️ E dallo snippet si
  intuisce che taglierebbe **in due direzioni opposte** (il "cascade" dopo il
  livello e' un argomento **pro-breakout**): da leggere prima di citarla.
- 🔧 **Un attrezzo in cassa:** `Dynamic Session Range Sweep Detector`
  (Code Base **76305**, indicatore) — level builder di sessione **in ora
  server**, `PipSize` fatto giusto, e una **penetrazione minima** prima di
  contare uno sweep (`InpMinSweepPips=2,0`) che `ABTG_BreakinBox` **non ha**.

## 🔴 DUKA IMPORT+SONDA U30USD_DK -- CANCELLO CHIUSO (per lettera dei criteri congelati)
`backtest_pipeline/risultati_archivio/duka/REFERTO_IMPORT_SONDA_2026-09-03_2243.txt`.
5/6 giorni-campione dentro soglia (mediana |diff bid| <=0,05%), 1 fuori:
**2024.11.20 a 0,0696%**. Criteri congelati PRIMA (par. 4a) distinguevano tre esiti:
tutti dentro=OK, SOLO i giorni DST (2024.10.29/31, 2025.03.12/25) fuori=riconvertire,
ALTRI giorni fuori=CANCELLO CHIUSO "nessun 'pero' quasi'". Il 20/11/2024 NON e' uno
dei quattro giorni DST elencati (e' 3+ settimane dopo la fine DST europea del 27/10 e
la fine DST USA del 3/11): per lettera del criterio gia' firmato, questo e' CANCELLO
CHIUSO, non "quasi". Il tester stesso non sa distinguere (verdetto automatico "QUASI:
leggere quali giorni falliscono") -- lo si e' letto qui a mano.
**U30USD_DK va in FRIGO** (come gli _EXT HistData): non si usa per verdetti a
parametri congelati finche' non si capisce la causa del 20/11 (holiday pre-Thanksgiving?
copertura tick nativa zero quel giorno? -- non misurato qui). Prima di riaprire il
capitolo: aprire un grafico U30USD M1 per scaricare lo storico tick nativo di quel
giorno specifico e rilanciare la sonda con -SoloSonda per vedere se il problema e'
"non confrontabile" (tick nativi assenti) o un vero disallineamento prezzi.

---

### CACCIA NOTIZIE (03/09 sera, due fronti) — le righe che toccano questo registro

Dossier completi: `caccia_strategie/CACCIA_NOTIZIE_TASSONOMIA_2026-09-03.md`
(19 famiglie di eventi, frequenze contate su 46.112 righe di calendario di casa)
e `caccia_strategie/CACCIA_CANDELA_NEWS_2026-09-03.md` (3 meccanismi cercati,
8 implementazioni viste, 3 sorgenti letti). Il resto sta li', non si duplica.
**ZERO EA esterni promossi, ZERO file prova nuovi.**

- 🔧 **CORREZIONE ALLA LAPIDE L1, misurata.** `arxiv.org/abs/2605.04004`
  (aperto oggi) dichiara **barre da CINQUE MINUTI**. Quindi il §4.7 del paper
  ("the drift is real in the **first five bars**... **from bar +6** onward
  T = 0,14-0,69") vuol dire **reale nei minuti 0-25, morto dal minuto 30**.
  🔴 **L1 chiude il post-news DAL MINUTO 30. NON chiude i minuti 0-25** — che
  e' esattamente dove agisce `ABTG_PostNews` (news+10 FOMC / news+15 ECB).
  ⚠️ Non e' una promozione: l'autore attribuisce quella deriva **al salto**
  ("that is just the news spike itself"), non a una continuazione prendibile
  entrando dopo. Ma L1 finora era citata come chiusura di TUTTA la famiglia.
- 🪦 **LAPIDE NUOVA — SPIKE & FADE: chiuso.** La tesi accademica esiste
  (Ederington & Lee, JFQA 30(1) 117-134, 1995: sovrareazione nei **primi 40
  secondi**, corretta nel **2º-3º minuto**, futures FX/tassi **1988-1992**),
  ma vive **sotto M5** e **dentro la finestra vietata FTMO (±2 min)**.
  Non si testa con la nostra macchina e non si esegue su un funded.
  ⚠️ Il paper NON e' stato aperto (Cambridge/IDEAS bloccati): citazione da
  snippet, marcata [INCERTO] nel dossier. La lapide regge lo stesso perche'
  l'orizzonte a 40 secondi e' sotto M5 da qualunque fonte lo si legga.
- 🕳️ **"MOMENTUM CANDLE CONTINUATION" (il colore della 1ª candela predice le
  successive): NESSUNA letteratura, NESSUNA implementazione.** arXiv API 3
  interrogazioni, Quantpedia, ricerca generale: torna solo folklore retail.
  Non e' un meccanismo bocciato: e' un meccanismo che non esiste da leggere.
- 🎯 **IL TERZO MECCANISMO CE L'ABBIAMO GIA', ED E' IL MIGLIORE LETTO OGGI.**
  `ABTG_PostNews.mq5` (473 righe, 39 input) **e'** il "range della candela
  della notizia come livello": max/min di due candele M5, BUY/SELL STOP oltre
  gli estremi, **OCO VERO** (`OcoCheck`), **SL vero**, **rischio in %**,
  size calcolata sul **doppio stop**. Zero bandiere rosse. 🔴 Due rilievi:
  `InpRiskPercent` di default **3,0** (va rimesso a 0,65 prima di qualunque
  confronto) e **39 input** (sopra il tetto ~15).
- 🧱 **IL VINCOLO FTMO NON DIPENDE DALLA FAMIGLIA DI EVENTO: DIPENDE DAL
  MINUTO.** Vietato aprire **o chiudere** (SL/TP inclusi) ±2 min dal rilascio
  sugli strumenti colpiti, **solo su FTMO Account Standard** (non in
  Challenge, non su Swing). ➡️ **news+3 minuti in poi = compatibile con ogni
  famiglia**; **pendenti prima del dato = incompatibile con tutte**.
  🔴 **5 implementazioni esterne su 5 piazzano PRIMA o SUL rilascio: 100% del
  campione esterno e' FTMO-incompatibile.**
  ⚠️ **Insidia nuova, mai considerata:** un EA che entra a news+10 puo' avere
  lo **SL colpito dentro la finestra ±2 min dell'evento SUCCESSIVO**, e con
  **43 giorni l'anno a >=4 eventi high** non e' teorico. **Un EA news
  FTMO-compatibile ha bisogno del calendario per USCIRE, non solo per entrare.**
- 📊 **NUMERI DI CASA, contati oggi sui 3 CSV di `biblioteca/dati/`
  (46.112 righe):** il **33%** di tutte le notizie high di 5 anni cade
  nell'ora **13:00 server** (NFP/CPI/PPI/Retail/GDP + conf. stampa ECB);
  **48,7%** dei giorni di calendario ha >=1 evento high; **43 giorni/anno**
  ne hanno >=4 (= sfonderebbero il cap C1 di 5 SL vivi prima del muro FTMO);
  **269 eventi USD high/anno** su **137 giorni**.
  🔴 **NFP + Unemployment Rate + Average Hourly Earnings escono nello STESSO
  MINUTO**: 3 righe di CSV, **UN solo movimento**. Un filtro largo apre 3 volte.
- 🕳️ **BUCO DI COPERTURA MISURATO:** i nostri CSV marcano ad alto impatto solo
  **USD/GBP/EUR/JPY**. Per **CAD/AUD/NZD/CHF** l'unico "impatto 3" e' la
  **decisione sui tassi**: CPI e lavoro di quei paesi passano come impatto 2.
  Un motore su AUD/CAD non sarebbe protetto dal filtro news di casa.
- 🔧 **TRE CORREZIONI DI METODO agli atti:** (a) **Quantpedia NON e' tutta
  premium** — le pagine `/strategies/` si', **gli ARTICOLI del blog no** (2
  letti interi oggi): su Quantpedia si entra dagli articoli; (b) **la ricerca
  repository di GitHub FUNZIONA** (controllo positivo `q=mql5` -> **2,6k
  repo**): gli zero dei dossier precedenti sono zeri VERI, ma le query lunghe
  danno 0 perche' GitHub vuole TUTTI i termini — vanno spezzate; (c) **il
  calendario nativo MQL5 non gira nel tester**, confermato su due pagine
  indipendenti (libro MQL5 + articolo 22580 del 28/05/2026): **ogni EA news di
  casa DEVE essere guidato da CSV** — cosa che `ABTG_PostNews` gia' fa.
- 🚨 **DA NON FAR GIRARE MAI ACCANTO ALLA FLOTTA:** Code Base **55630**
  (Mullerp04) ha un `DeletePending()` che **cancella TUTTI i pendenti del
  terminale senza controllare il magic** (il commento dice il contrario, il
  codice non lo fa). Su un conto con piu' EA accesi cancellerebbe i pendenti
  di MaxMinNotte e delle aperture.
- 🔴 **TradingView e' CHIUSA per il tema news, e ora e' motivato:** Pine non ha
  un calendario con timestamp di rilascio al minuto (verificato sulla pagina
  di uno script open-source: *"TradingView doesn't support external API
  connections"*). Non esiste una STRATEGY news-driven backtestabile li'.
- 🎯 **LA MOSSA PIU' ECONOMICA DEL PROSSIMO GIRO, e non e' un EA nuovo:**
  `ABTG_PostNews` oggi vede **16 eventi/anno** (8 FOMC + 8 ECB) — con la
  regola IS>=150 servirebbero ~9 anni. **NFP e CPI USA escono alla STESSA ORA
  (13:30 server) e MAI lo stesso giorno**: +24 eventi/anno = **40 totali,
  +150%**, cambiando **solo il CSV e 3 input**, zero righe di codice.
  Spec (senza `@DAQUANDO`, da misurare) in `CACCIA_CANDELA_NEWS_2026-09-03.md` §7.
  🔬 Ablazione gia' pronta e gratis: il corso **butta** la candela della
  notizia sull'ECB e la **tiene** sul FOMC, senza mai spiegare perche'. Sono 5
  minuti di `InpActionMin`: nessuna delle due versioni ha mai avuto un numero.
- 🚧 **Buchi dichiarati:** la **lista FTMO degli eventi "Restricted event"**
  NON e' stata letta (ftmo.com egress-blocked, 3 aggregatori bloccati) —
  **serve che Claudio apra `ftmo.com/en/calendar/` dal suo browser**, sono 2
  minuti e chiudono un buco che gli agenti non possono chiudere.
  **forexfactory.com 403** (calendario e thread), **SSRN 403** (14ª di fila),
  e 13 domini accademici/istituzionali bloccati (NBER, Fed, ECB, Cambridge,
  ScienceDirect, ResearchGate, Semantic Scholar, Skidmore...).

## 🪦 POSTNEWS — candidati A (ISM 15:00/EURUSD) e B (blocco 13:30/USDJPY): PASSO 0 CHIUSO, SENZA EDGE, 05/09/2026

Passo 0 (conta-occasioni + screening Modello 1 OHLC) dei due candidati usciti
dalla caccia notizie del 04/09 (`CACCIA_POSTNEWS_ALTRE_FAMIGLIE_2026-09-04.md`),
stesso motore `ABTG_PostNews.mq5` v1.10 della sedia NFP viva (due pendenti sul
range post-notizia), SL/TP/offset **copiati di netto dalla sedia NFP, mai
ritarati** su questi simboli/eventi. Righe: `RIGA_POSTNEWS_ISM.ps1` e
`RIGA_POSTNEWS_1330.ps1`, pin `1dbae10394488181c65cfbfa5c9f91d4852fb18e`.

- 🔴 **A (ISM Manufacturing/Services PMI + CB Consumer Confidence, 15:15
  server, EURUSD, magic 774701/774706):** IS (2010-2015, n=234) **PF 0,76**,
  Profit -4.651,72, DD% 6,92. OOS (2015-2023, n=312) **PF 0,79**, Profit
  -5.633,01, DD% 6,94. **PF sotto 1 su ENTRAMBE le finestre.**
- 🔴 **B (CPI m/m + Retail Sales + Core Retail Sales + PPI, 13:45 server,
  USDJPY, magic 774801/774806 — stessa ora della sedia NFP, calendario
  diverso):** IS (2010-2015, n=151, appena sopra soglia) **PF 0,66**, Profit
  -4.084,87, DD% 4,75. OOS (2015-2023, n=253) **PF 0,90**, Profit -1.979,08,
  DD% 4,56. **PF sotto 1 su ENTRAMBE le finestre.**
- ✅ **Campione pieno su tutte e 4 le letture** (Emendamento A: A supera 150
  comodo, B lo tocca appena — coerente col conto dei 150 gia' scritto nella
  pagina, che avvertiva B non ci sarebbe arrivato facile). Nessuna sospensione
  per campione sottile: il verdetto e' leggibile, ed e' negativo.
- 🐛 **CLASSE 129 (nuova, in `CHECKLIST_RIGA_DI_LANCIO.md`): le righe "gemello
  di coerenza" (2 celle che DEVONO uscire identiche, cambia solo il magic)
  vanno lanciate con UN SOLO agente locale MT5.** Con gli 8 core della
  macchina di backtest (4 attivi), 5 corse di fila su ISM hanno dato gemelli
  **mai identici** (scarti da 2 a 39 operazioni, verso variabile) e
  `CALENDARIO CIECO` occasionale. **Causa confermata con un monitor in tempo
  reale** (`Get-Process metatester64` in loop): 4 processi tester vivi
  contemporaneamente nell'istante esatto della lettura del calendario —
  uno per cella/finestra, in corsa sullo stesso file condiviso. Disabilitando
  Core 2/3/4 (pannello Strategy Tester -> Agenti), la corsa successiva ha
  dato gemelli **identici al centesimo**. Il verdetto di merito (PF<1 su
  tutte le letture) non e' MAI cambiato durante la caccia al bug: nessuna
  delle sei letture (pulite o sporche) ha mai mostrato PF>=1.
- 🔬 **Non e' un cancello chiuso per sempre: e' un motore, non un mandato.**
  Il PF<1 boccia QUESTO meccanismo (breakout a due pendenti) su QUESTI due
  eventi con QUESTI parametri (ereditati dall'NFP, mai ritarati). Per la
  Regola della Seconda Caccia (19/08), **non si ritocca SL/TP sugli stessi
  dati per farli tornare verdi** (sarebbe il curve-fitting gia' pagato in
  casa): si cerca un MECCANISMO diverso sulla stessa inefficienza (fade,
  liquidity sweep, gestione a tempo). Caccia aperta il 05/09/2026, dossier
  in arrivo in `caccia_strategie/`.

---

### SECONDA CACCIA POST-NEWS (05/09/2026) — 3 meccanismi MISURATI, 3 bocciati, 0 promossi

Dossier completo: `caccia_strategie/CACCIA_POSTNEWS_MECCANISMI_2026-09-05.md`.
Il resto sta li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi,
nessun EA/preset/sedia toccati.** Applicazione della Regola della seconda
caccia dopo il PF<1 su 4 letture (ISM 15:00 EURUSD 0,76/0,79 · 13:30 USDJPY
0,66/0,90).

- 🧪 **PER LA PRIMA VOLTA LA FAMIGLIA NEWS E' STATA MISURATA, NON OPINATA.**
  Sonde Python su barre M1 esterne (FutureSharks, GPL-3.0, Oanda, **UTC come
  il nostro calendario FF: zero conversioni di fuso**): **EUR_USD 3.719.294
  barre** e **XAU_USD 3.594.016**, 2010-01-03 -> 2020-05-14. **686
  giornate-evento su EURUSD, 683 su oro, 7 varianti di meccanismo**, ognuna col
  **controllo a ingressi casuali** (che esce PF 1,00 / 1,06 = sonda non
  sbilanciata). Sonde in `caccia_strategie/biblioteca/sonde_esterne/sonda_postnews*.py`.
  ⚠️ Limiti dichiarati: non e' BCM, OHLC non tick, **ZERO costi**, finestra che
  NON copre il regime 2021-2026. **Misure di occasioni, mai verdetti (F6).**
- 🪦 **LAPIDE — IL FADE POST-NOTIZIA E' CHIUSO, MISURATO.** ISM: **PF 0,85
  (t -1,26)** EURUSD e **PF 0,73 (t -2,41)** oro; 13:30: PF 1,10 contro un
  controllo casuale a 1,06 (EURUSD) e 1,08 contro **1,11** (oro, cioe' PEGGIO
  del caso). **Il segno si ribalta fra blocchi e fra simboli.** Ragione
  strutturale: il fade e' lo specchio del breakout **sugli stessi prezzi di
  scatto** -> a somma quasi nulla, e paga lo spread due volte.
  **Invertire una strategia perdente non e' un meccanismo nuovo.**
- 🪦 **LAPIDE — LIQUIDITY SWEEP sul range della notizia: chiuso.** ISM **PF
  0,86** (4/11 anni), 13:30 PF 1,18 ma contro casuale 1,06 e tutto fatto nel
  2010-2012. **E' il TERZO giro sulla stessa geometria**: BreakinBox chiuso a
  tick il 31/08 (PF 1,007, DD 24,1%) e R95 0/30. Cambiare il LIVELLO (range
  news invece del box notturno) non cambia la geometria.
- ⏱️ **USCITA A TEMPO 30': l'unica variante con t>2, UCCISA DALLA PROVA
  DELL'EPOCA.** ISM EURUSD tutto 2010-2020: media +1,84 pip, t 2,73, PF 1,57,
  9/11 anni. Ma **2010-2011 (n=73): +7,87 pip, PF 3,14, +574,7 pip** contro
  **2012-2020 (n=298): +0,36 pip, t 0,61, PF 1,12**. **L'84% del profitto dal
  20% del campione, e sono i due anni piu' vecchi.** +0,36 pip su stop 25 =
  **0,014R contro il cancello 0,075R NETTI** (FIRMA 2). Sul blocco 13:30 la
  stessa gestione e' NEGATIVA su entrambi i simboli (PF 0,93 e 0,79).
  🟡 Lascito utile: **se il motore si riaccende, la finestra viva giusta e'
  ~30 minuti, non 70-85.**
- 🔴 **RILIEVO SULLE SEDIE VIVE, non un candidato: `InpUseOCO=false` e il
  DOPPIO RIEMPIMENTO al 24%.** Misurato: **92/371 = 24,8%** (ISM) e
  **74/315 = 23,5%** (13:30) delle giornate riempiono ENTRAMBE le gambe.
  Senza OCO la giornata di whipsaw vale **-2,0R** mentre il trend pulito paga
  **+1,2R**: asimmetria STRUTTURALE contro la strategia. A 0,65%/evento fa
  **1,30% in una giornata** invece di 0,65% = il doppio del contratto della
  sedia. ⚠️ `InpUseOCO` **e' un input**: la tensione con la Regola della
  seconda caccia e' DICHIARATA, non aggirata. **Decisione di Claudio.**
- 🆕 **SCOPERTA NEI DATI DI CASA (mai vista in 3 dossier notizie): i CSV
  `biblioteca/dati/CALENDARIO_news-*.csv` contengono FORECAST e ACTUAL.**
  **1.667 eventi USA ad alto impatto** con entrambi i valori, **2021.01.05 ->
  2024.10.29** (⚠️ **NON** fino al 2025 malgrado il nome del file; colonna
  "precedente" vuota ovunque). Mappatura verificata su 3 verita' note (NFP dic-2020
  -140K, NFP mar-2023 236K, ISM dic-2020 60,7).
  📐 Giornate distinte: 13:30 **220** · 15:00 **138** · Claims **199** ·
  15:00+Claims **319** (si sovrappongono solo 18 volte) · tutti e tre **452**
  in 3,8 anni. 🎯 **Poolati, i 452 darebbero 226 IS + 226 OOS = la PRIMA volta
  che la famiglia news vede il pavimento dei 150** — ma **solo poolando**, e
  `InpActionHour` e' una costante dell'istanza (r.74-75): servirebbe leggere
  l'ora dell'evento dal CSV.
- 🟡 **UNICO MECCANISMO ANCORA IN PIEDI, e NON misurabile da qui: la SORPRESA
  (actual vs forecast), un solo lato.** I prezzi esterni finiscono 2020-05, il
  calendario con sorpresa comincia 2021-01: **zero giorni in comune. Nessun
  numero, e non lo invento.** Due obiezioni gia' agli atti prima di spendere un
  round: (a) **tre misure indipendenti** dicono che la sorpresa e' gia' prezzata
  molto prima del minuto 15 — Ederington-Lee ("40 seconds", da snippet),
  **Takahashi arXiv 2508.06788 letto oggi nel PDF: _"shocks dissipate almost
  entirely within a second"_**, Mesfin ("just the news spike itself");
  (b) **Ben Omrane & Savaser 2016 (JIFMIM 45): "sign switch effect"** — in
  regimi di forte avversione al rischio il segno della reazione FX si INVERTE,
  e le famiglie che lo fanno sono consumi/casa/lavoro/credito [da snippet].
- 🔧 **ATTREZZO (non un candidato da imbuto): `Economic Calendar CSV`,
  Code Base 52977, Stanislav Korotky (`marketeer`), 22/10/2024 agg. 22/11/2024.**
  Esporta il calendario nativo MT5 in CSV **e fa correzione di ora legale** sui
  timestamp storici = **proprio il difetto DST misurato il 04/09** (10 NFP su
  174 a 12:30 invece che 13:30). E' la sola strada per avere actual/forecast
  oltre il 2024 e all'indietro. ⚠️ **Sorgente NON letto** (solo la pagina):
  **va letto prima di girarlo.**
- 📐 **Geometria, rilievo misurato:** il range post-notizia mediano (2 candele
  M5, ISM) su EURUSD e' **13,2 pip** -> **lo SL di 25 pip vale 1,89 volte il
  range che definisce il setup.**
- 🥇 **Risposta PARZIALE alla domanda lasciata aperta il 04/09 ("quale asset
  reagisce di piu'"): depurato del controllo casuale, oro ed EURUSD si
  EQUIVALGONO** (+0,046R contro +0,041R per evento) e **sono entrambi sotto il
  cancello**. Sull'oro **il controllo casuale guadagna da solo** (+0,055R): e'
  deriva 2010-2012, non edge. **Cambiare simbolo non salva la famiglia.**
- 🔧 **CORREZIONI DI METODO agli atti:** (a) **l'API arXiv risponde solo in
  HTTPS** — in http torna **301 con 0 byte** (si legge come "fonte nulla" ed e'
  falso); (b) **`api.github.com` e' inutilizzabile** da qui (**403**, "sessions
  are bound to their configured repositories"): la ricerca GitHub si fa dalla
  **UI**; (c) **la ricerca interna di mql5.com (`/en/search#!keyword=`) e' guidata
  da JS e torna solo l'interfaccia**: inutile; (d) ⚠️ **una risposta di WebFetch
  non e' una citazione**: sul PDF Takahashi il riassunto conteneva una frase
  sul "reversal in the first few minutes" **che nel testo NON C'E'** — estratto
  il PDF a mano, l'abstract dice l'opposto ("within a second").
  **Sui paper: estrarre il testo, non fidarsi del riassunto.**
- 🚧 **Buchi dichiarati:** **USD_JPY non esiste sulla fonte esterna (404 vero)**
  -> il blocco 13:30 e' stato misurato su EURUSD e oro, **non sul simbolo della
  cella bocciata**. Nessuna misura dopo il 2020-05 (il regime delle sedie non e'
  coperto). Otto domini accademici bloccati; il paper piu' vicino al nostro
  orizzonte — **Almeida-Goodhart-Payne, JFQA 1998, dati a 5 minuti, effetti nei
  15 minuti dopo il rilascio** — e' su `researchonline.lse.ac.uk`, **bloccato**:
  se un giorno si riapre la famiglia, **si parte da li'**.

---

### CACCIA DEDICATA AL TIMEFRAME M15 (05/09/2026) — 0 EA promossi, 4 lapidi, 1 LEGGE NUOVA

Dossier completo: `caccia_strategie/CACCIA_TF_M15_2026-09-05.md`. Il resto sta
li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi, nessun EA /
preset / sedia / parametro di forward toccato.** Battuta parallela a quelle su
M5 e M30 (agenti gemelli). Misurate 436.869 barre M15 su 3 strumenti
(GRXEUR 2012-2018, SPXUSD 2012-2018, EURUSD Oanda 2013-2019), sempre col
CONTROLLO A INGRESSI CASUALI.

- 📏 **LEGGE NUOVA, E VALE PER TUTTE E TRE LE BATTUTE: SU M15 IL COSTO E' PIU'
  GRANDE DEL CANCELLO H8.** Con SL = 1,2 ATR(14) su M15, **1R = 20,85 punti
  DAX / 25,8 punti Dow [INFERITO] / 10,8 pip EURUSD**, e lo spread di casa vale
  **0,082 / 0,078 / 0,095 R per operazione** — cioe' **piu' dell'intero cancello
  H8 (0,075R)**. ➡️ **Un motore M15 deve misurare E LORDA >= 0,157R per
  consegnare 0,075R netti.** Proposta di metodo (decide Claudio): **ogni passo 0
  su M5/M15/M30 dichiara 1R IN PUNTI e IL COSTO IN R nella prima riga del
  referto**, prima di qualunque win rate. Avrebbe risparmiato LondonFx (1R = 8
  pip, costo 1,7-3,3x l'edge richiesto: numero scritto DOPO la promozione).
- 🪦 **LAPIDE — M31 SALTO STATISTICO (Lee-Mykland, RFS 21(6) 2535-2563, 2008) su
  M15: CHIUSO.** Era il meccanismo M31 della tassonomia del 03/09, **mai
  toccato**, coi criteri J1-J5 congelati e mai misurati. Oggi misurato per
  intero. **L'edge C'E'** (batte il controllo casuale in modo **monotono** su 3
  strumenti e 6 soglie), ma **muore di aritmetica: la cella con l'edge non ha
  campione, la cella col campione non ha edge.** DAX senza notizia:
  2,0σ = **1,34 segn./gg/lato** ma E netta **−0,036R**; 4,5σ = E netta
  **+0,104R** ma **0,10 segn./gg/lato = ~88 operazioni su tutto il banco tick
  disponibile (pavimento indici 2024.09.26)**, cioe' **sotto n>=150: un round a
  tick non sarebbe nemmeno LEGGIBILE**. E **nessuna cella passa S0** (take/spread
  **1,93-2,28** contro il 2,5 che ha falsificato `ABTG_VwapRevert`).
  **NON ritestare con altre soglie o altre geometrie** (regola della seconda
  caccia): la contro-prova e' gia' fatta, vedi riga sotto.
- 🔧 **CONTRO-PROVA CHE CHIUDE LA PORTA — "muore di edge o di costo?".**
  Rigirando tutto con SL=TP=2,5 ATR e orizzonte 24 barre: DAX 4,0σ passa da
  E=+0,1406R a **+0,0639R**, cioe' **0,169 ATR contro 0,160 ATR** di edge
  assoluto. 🎯 **L'edge per segnale e' una QUANTITA' FISSA DI ATR (~0,16), non
  un multiplo fisso di R**: allargando lo stop l'edge in R si diluisce
  esattamente quanto il costo. **Nessuna geometria salva l'aritmetica.**
- 🪦 **LAPIDE — IL FADE DEL SALTO: chiuso.** Perde contro il controllo casuale
  in **9 celle su 9** (da −2,6 a −8,6 punti), RR da mediane 0,76-0,92 contro
  1,09-1,32 della continuazione. ⚠️ Questo **contraddice l'ipotesi scritta il
  03/09** nella tassonomia ("il salto senza notizia e' quello dove il rientro e'
  piu' probabile"): sui nostri strumenti il salto **CONTINUA**. Letto, non scelto.
- 🥇 **FATTO NUOVO E UTILE ANCHE FUORI DA QUESTO MOTORE: sugli INDICI l'edge sta
  nei salti SENZA notizia, sul FOREX in quelli CON notizia.** SPXUSD 4,0σ:
  senza notizia **55,7% contro 46,9% del caso (+8,8 punti, n=1.032)**, con
  notizia **46,7% contro 47,6%**. EURUSD: l'opposto. ➡️ Sugli indici il salto da
  calendario e' rumore gia' prezzato, il salto da flusso e' informazione.
  Cancello J5 (>70% su notizia = e' `ABTG_PostNews` travestito) **PASSATO
  larghissimo: 13,3%-41,3%**.
- 🔬 **LA LEGGE DEL GATE (÷4-6, 31/08) CONFERMATA LA QUINTA VOLTA — e stavolta
  come CURVA CONTINUA dentro UN SOLO motore, con UNA sola manopola.** DAX senza
  notizia, da 2,0σ a 4,5σ: **frequenza ÷13,4** (1,34 → 0,10 segn./gg/lato) e
  **edge ×4,0** (+0,047R → +0,186R), **monotono in entrambe le direzioni, zero
  inversioni**. Non e' piu' un aneddoto su 4 EA diversi: e' una proprieta' del
  mercato a 15 minuti.
- 🕐 **CORREZIONE MISURATA AL `LEGGIMI` DELLE SONDE ESTERNE, e conta per ogni
  sonda futura: gli indici histdata NON sono in EST fisso.** Il minuto a piu'
  alta |variazione| media M1 **non si sposta fra inverno ed estate** (SPXUSD
  09:30 e 15:59 in entrambe; GRXEUR 03:00 in entrambe) → sono in **ora di NEW
  YORK CON ORA LEGALE**. ➡️ **ora file + 5 = ora server BCM tutto l'anno**, e il
  collaudo passa contro due verita' di casa (DAX 08:00 server, USA 14:30 server).
  I file **Oanda sono invece in UTC** (EURUSD picca 13:30 d'inverno e 12:30
  d'estate = NFP). ⚠️ Per incrociare gli indici col calendario FF serve la
  regola DST **americana**. Attrezzo nuovo: `sonda_orologio_fonte_esterna.py`.
- 🪦 **DUE LAPIDI DA PAPER, metadati VERIFICATI con l'API arXiv** (non con la
  pagina): (a) **arXiv 2608.21888**, Kitron & Wengrowicz, 22/08/2026,
  _"Short-horizon mean reversion in cryptocurrency markets"_ — e' su **candele
  da 15 minuti**, e chiude **M16 (Nagel) su M15**: sulle **187 azioni/ETF USA
  liquidi AUC media 0,499 e solo il 2,7% significativo** = la reversione a 15'
  **non esiste su strumenti liquidi**; dove esiste, _"the gross edge peaks near
  1.3 bp per trade against a 5 bp round-trip cost"_ e _"not one of the 183
  crypto pairs clears even the 5 bp maker band at any threshold"_.
  (b) **arXiv 2607.09426**, Kim & Hansen, 16/07/2026, _"The Quarter-Hour
  Effect"_ — predicibilita' ai confini del quarto d'ora (R2 OOS 3,37%) ma
  **0,5 bp lordi = _"one tenth of a single standard-tier taker fee"_**, e
  orizzonte **10 secondi** (sotto il nostro TF, e contro il paletto E9).
- 🎯 **TRE CONFERME ESTERNE INDIPENDENTI, STESSA CONCLUSIONE DELLA MIA MISURA**:
  2608.21888 (15 min, crypto+azioni), 2607.09426 (quarto d'ora, crypto futures)
  e **2605.04004** (Mesfin, MNQ 5 min: _"a two-point round-trip transaction cost
  eliminates this gross edge entirely in every case"_). **Sull'intraday breve
  l'edge lordo esiste e il costo se lo mangia tutto: non e' un difetto della
  nostra macchina, e' la struttura del timeframe.**
- ❓ **LA DOMANDA DEL PROSSIMO PASSO NON E' "quale altro motore M15": e' "COME
  SI ENTRA SENZA PAGARE LO SPREAD"** — la stessa rimasta aperta il 03/09
  sull'orologio di Breedon, e adesso posta da **due meccanismi indipendenti**.
  🥇 **La mossa piu' economica resta la stessa da sette cacce: misurare lo
  spread VERO su D30EUR/U30USD/NASUSD nella fascia di lavoro** col *RealCost
  Spread P95 Logger* (Code Base **74148**, promosso il 23/08 e **mai usato**).
  Tutta la tabella dei costi poggia ancora su **spread di CONVENZIONE**: se il
  DAX fosse a 1,0 invece di 1,7, la cella 4,0σ passerebbe da +0,059R a +0,088R
  **e il verdetto cambierebbe**.
- 🚧 **Buchi dichiarati:** **GitHub ricerca 429 con `Retry-After: 3600`** (⚠️ non
  e' un 404: il pool GitHub di oggi NON e' stato guardato, vale la misura del
  02/09); **`public.econ.duke.edu` EGRESS_BLOCKED** → il PDF di *"Intraday
  Market Return Predictability Culled from the Factor Zoo"* (Bollerslev e
  coautori) **non aperto**, ed e' il paper piu' vicino al nostro problema: se si
  riapre il tema, si parte da li' e **serve che lo scarichi Claudio**;
  **MQL5 Code Base** raggiungibile ma con **autori e date non leggibili** (lista
  JS); **PDF di Lee-Mykland non aperto** (la soglia e' stata comunque spazzolata
  a mano da 2,0σ a 4,5σ, quindi la costante degli autori e' irrilevante qui);
  **nessun dato dopo il 2019-2020** (il regime 2024-2026 delle sedie NON e'
  coperto); **`SPXUSD → U30USD` e' un riscalamento `[INFERITO]`**, la gamba DAX
  invece e' diretta (GRXEUR = stessa scala di D30EUR).
- 🔧 **CORREZIONE DI METODO agli atti (recidiva del 05/09):** per arXiv
  2607.09426 il riassunto di `WebFetch` dava _"August 24, 2026"_ mentre **l'API
  dice `2026-07-16`**. **Una risposta di WebFetch non e' una citazione: i
  metadati si verificano con l'API.**

---

### CACCIA TF **M5** (05/09/2026, battuta dedicata) — 4 meccanismi MISURATI, 4 sepolti, 0 promossi

Dossier completo: `caccia_strategie/CACCIA_TF_M5_2026-09-05.md`. Il resto sta
li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi, nessun EA/
preset/sedia toccati.** Battute gemelle su M15 e M30 lo stesso giorno.

- 🔴 **LA RIGA CHE GOVERNA OGNI CACCIA M5 FUTURA — LA TASSA DEL COSTO.**
  Su **EURUSD M5** uno stop sensato e' **8 pip**, quindi **1 pip di spread vale
  0,1250R**; su **D30EUR M5** uno stop di **20 punti** con lo spread MISURATO in
  casa (**1,65 pti**, `SPREAD_FLOTTA_MISURA_2026-09-03.md`) vale **0,0825R**.
  👉 **Il pedaggio di UNA operazione M5 vale 1,1-1,7 volte l'intero cancello H8
  (0,075R)**, quindi **un candidato M5 deve promettere 0,16-0,20R LORDI o non e'
  un candidato.** 🔴 **Il massimo LORDO misurato oggi su quattro meccanismi con
  evidenza da Journal of Finance e' +0,0922R.** **Su M5 non manca il segnale: il
  segnale e' piu' piccolo del pedaggio.** E' la spiegazione quantitativa del
  perche' il capitolo M5 e' morto 210 celle fa (r.40).
- 🪦 **LAPIDE — M11 FIX VALUTARI (Krohn-Mueller-Whelan *JF* 79(1) 2024; Evans
  *JBF* 2018): meccanismo VERO, candidato MORTO.** Collaudo F6 **PASSATO**: i tre
  fix si vedono nei dati al minuto giusto in entrambe le stagioni (**WMR 15:59
  Londra = 1,34-1,45× il fondo**, ECB 13:15 = 1,49×, Tokyo 01:55 = **1,93×**,
  volume raddoppiato). 🎯 **E il segno era PRE-REGISTRATO e l'ha azzeccato:**
  EURUSD dopo il fix WMR fa **+1,90 pip mediani** nel quintile in cui il dollaro
  e' salito di piu' (**58,1% positive**) e **−0,60** nel quintile opposto,
  **monotono su 5 quintili**, su 2 fix su 3 (l'ECB no). 🔴 **SCARTO lo stesso,
  per lettera del criterio congelato:** **F3 quota di rientro = 0,038-0,082**
  (rientra il 4-8% del run-up, moneta al 51-53%) → **il FADE non esiste**; e la
  cella buona vale **1,90 pip contro il cancello di 3,0** e **0,2 eventi/giorno
  contro il pavimento di 2,00**. **Nessuna altra taratura.**
- 🪦 **LAPIDE — M23 NUMERI TONDI (Osler *JF* 2003 / *JIMF* 2005): nessuna
  informazione direzionale.** R1 passa largo (3,04 / 6,07 / 31,05 tocchi al
  giorno su griglie 100/50/10 pip), R3 e R5 passano — ma su **93.000+ segnali**
  il delta contro il controllo **APPAIATO** e' **da −1,50 a +0,90 punti, 5 letture
  su 6 negative**. Il 55-57% di "rimbalzi" e' un artefatto della definizione.
  L'ipotesi dichiarata (_"il clustering del 2003 su una banca vale nel 2026 su un
  broker retail?"_) e' **misurata: no**.
- 🔴 **M31 SALTO STATISTICO (Lee-Mykland *RFS* 2008) su M5: 16 celle su 16 sotto
  il cancello, due mercati.** EURUSD: da T=3 a T=6 la frequenza va da **5,65 a
  0,70/gg** (÷8) e il lordo da −0,011R a **+0,0922R** — netto a 1 pip, **sempre
  negativo** (−0,033R il migliore). DAX (08:00-16:00 server): informazione
  direzionale **sempre positiva** (+0,018R/+0,031R) ma **un terzo del pedaggio**
  → netta −0,035R/−0,072R. ⚠️ **La gamba M15 e' dell'agente gemello**
  (`sonda_salti_m15*.py`): su M15 lo stop raddoppia e la tassa si dimezza —
  **i due numeri vanno letti insieme.**
- 🔴 **M25 LEAD-LAG DIREZIONALE S&P → DAX su M5: frequenza SI', edge NO.**
  2-7 segnali/giorno (**l'unico dei quattro a passare il pavimento F1**), e
  **8 celle su 8 negative al netto**. La colonna che lo smonta e' la **monetina**
  (+0,24/+0,96 pti): quasi tutto il "lordo" e' la **deriva del DAX 2011-2018**
  raccolta da una geometria TP40/SL20, non il segnale. Depurata, l'informazione
  direzionale e' **−0,003R/+0,013R = zero**. ➡️ **Conferma diretta di H8: _"la
  frequenza da sola non e' un merito"_.** ⚠️ Non e' RELATIVO/M7 (z-score del
  RAPPORTO): quello e' un'altra coda, non toccato.
- 🔬 **CORREZIONE DI METODO, e tocca i dossier del 03/09: IL CONTROLLO CASUALE VA
  APPAIATO.** Sugli **stessi** segnali, il controllo **non appaiato** (metodo
  03/09) da' **+6,72/+12,67 punti** di delta apparente; il controllo **appaiato**
  (stessa barra, stessa geometria, **lato opposto**) da' **−1,50/+0,90**.
  **7-12 punti di artefatto**, perche' i segnali stanno nelle ore vive e l'ora
  morta non arriva mai al TP. 🖊️ **Da oggi una sonda DIREZIONALE si controlla
  col lato opposto sulla stessa barra** (media dei due lati = monetina esatta,
  zero varianza). ✅ **Le lapidi L2/L3 del 03/09 non cambiano: si rafforzano**
  (erano gia' negative contro un controllo generoso).
- ⏱️ **IL COLLAUDO DELL'OROLOGIO HA CAMBIATO UN VERDETTO, non un arrotondamento.**
  Recepita la correzione di fuso dell'agente M15 (histdata = ora di New York
  **con** ora legale, **file+5 = server**), **le due corse DAX sono state
  RIFATTE**: sulla finestra sbagliata (07:00-15:00) il lead-lag era il candidato
  piu' vicino di tutti (**+0,0332R netti a 2,04 segnali/gg**); sulla finestra
  giusta (08:00-16:00) scende a **−0,0613R**. La differenza era **l'ora di
  pre-apertura**. **Un orologio sbagliato produce un numero pulito e falso.**
- 🔧 **DUE ATTREZZI dal Code Base, e centrano il collo di bottiglia misurato**
  (**sorgente NON letto: solo la pagina** — vale la lezione del 55630):
  **76117 `Round Trip Cost Reconciler MT5`** (`usamah41`, 2026.08.13) misura il
  costo di andata e ritorno **reale** → e' la riga **H12** aperta, e oggi si e'
  visto che **il costo non e' un dettaglio del verdetto: e' il verdetto**;
  **76934 `Position Peak Logger — how far your trades actually travelled, in R`**
  (`petrkostal`, 2026.09.04) registra **MFE/MAE in R** → e' il dato che manca al
  censimento dei contratti. ✅ **Riconfermato il 31/08:** degli **11 id nuovi**
  (76669 → 76972) sono **tutti** pannelli/calcolatori/logger/demo Renko.
  **Zero motori M5.**
- ⛔ **TradingView (controllo positivo 🟢, 23 script visti): zero sorgenti
  aperti, e il motivo e' quantitativo.** Ogni titolo cade in una famiglia gia'
  sepolta con un numero di casa: scalping a pila di indicatori, `Intraday
  Pullback Sniper` (banda+oscillatore = **M14, 6 finestre su 6 rosse**),
  `Liquidity Pools`/`Key Liquidity` (**M24, cimitero tre volte**), tre
  `Opening Drive` (**ORB, ~210 celle**), `Session-Based Momentum Scalper with
  ATR Filter` (**L3, 0/8 sopra il pavimento**).
- 🚧 **Buchi dichiarati:** **GitHub 429** (`Retry-After: 3600`, UI e WebFetch;
  `api.github.com` 403) → **fronte GitHub NON battuto — e un 429 non e' un 404**;
  **lo spread FOREX di BCM resta NON MISURATO** (H12), quindi la colonna "netta"
  su EURUSD e' una stima su **1,0 pip di convenzione** (⚠️ a 0,5 pip il salto
  T=6 tornerebbe a ~+0,03R, **ancora sotto il cancello**: nessuna conclusione si
  ribalta); sorgenti dei due attrezzi non letti; finestre **2011-2019/2018**, il
  regime delle sedie **non e' coperto**; **niente tick, zero costi dentro le
  sonde, non e' BCM**.
- 🎯 **LA DOMANDA CHE LASCIA, ed e' una strada, non un motore:** _"esiste UN
  meccanismo che produca 0,16-0,20R LORDI su M5? E se no, perche' cerchiamo la
  portata SCENDENDO di timeframe invece che AGGIUNGENDO SIMBOLI a M15-H1?"_
  Il progetto ha gia' risposto due volte: la caccia M1 del 29/08 (_"la frequenza
  NON la compreremo scendendo"_) e il gradiente **H1 > M30 > M15** di R108/R111.
  ⚠️ **E cio' che NON dice:** M5 non e' morto **come TEMPO DI INGRESSO** di una
  tesi piu' lenta — `ABTG_DAX_Apertura_EU` opera su M5 ma su un **livello H1** e
  con stop largo, e **quella forma la tassa non la paga**. E' l'unica M5 viva in
  casa, e adesso si sa perche'.

## 🪦 R117 RELATIVO D30EUR (M5, tick reali, cella N=40 / sigma=1,35) — BOCCIATA PER RISCHIO

Finestra `2024.09.26 -> 2026.06.30`, split 40/60, rischio 0,65%, SL 2,75xATR,
tetto 5 trade/giorno. **E OOS -0,267R · PF OOS 0,452 · DD OOS 25,01% · peggior
giornata -5,20%.** Due muri prop sfondati insieme (DD > 10%, giornata < -5%):
**bocciatura PER RISCHIO**, che l'Emendamento della Finestra (regola B) non
sospende mai e che **non dipende da n**.

> ⚠️ **NON si ritocca e NON si riprova con una finestra piu' lunga.** Allargare
> la finestra non puo' riabilitare una gamba bocciata sul rischio. Era anche la
> gamba con la previsione peggiore scritta PRIMA dei numeri: lo spread del DAX
> nella nostra sessione (2,80 punti indice) mangiava da solo il **79%** del
> cancello H8, e dalle 17 server in poi il DAX e' fuori dal suo cash.

## ⏸️ R117 RELATIVO NASUSD (M5, tick reali, stessa cella) — MERITO SOSPESO (il rischio non e' mai stato rosso)

**E OOS 0,063R** (zona morta: soglia 0,075, muro 0,050) · **PF OOS 1,189**
(passa) · **DD OOS 8,40%** (zona morta: soglia 8,0, muro 10,0) · **peggior
giornata -2,12%** (passa) · **A7 0,00%** (collaudo passato).
🔴 **A6 NON soddisfatto: n IS 87 / n OOS 154** contro i 150 richiesti in
ENTRAMBE. E **A3 incoerente**: IS in perdita (PF 0,754), OOS in utile — ma su
campioni di taglia molto diversa, quindi l'incoerenza **puo' essere rumore**.

### 📏 E A6 NON E' RAGGIUNGIBILE SU QUESTA GAMBA — misurato, non temuto

| | |
|---|---:|
| IS: 87 operazioni su 183 feriali | 0,475 op/gg |
| OOS: 154 operazioni su 276 feriali | 0,558 op/gg |
| media pesata | **0,525 op/gg** |
| 300 operazioni (150+150) chiedono | **567 feriali** |
| disponibili dal pavimento 2024.09.26 a oggi | **503** |
| **mancano** | **64 feriali ~ 3 mesi** |

Lo split e' un **gioco a somma zero**: il massimo ottenibile e'
**min(n_IS, n_OOS) ~ 133**. Il pavimento non si abbassa (BCM sugli indici e'
**dichiarato completo**; lo storico `_EXT` e' in frigo per il **cancello zero**).
📅 **A6 si soddisfa da sola aspettando:** i 567 feriali cadono intorno al
**27/11/2026**.

📄 **RIGA PRONTA: R117BIS**, `righe/RIGA_RELATIVO_R117BIS_DA_MANDARE.md` +
driver `righe/RIGA_RELATIVO_R117BIS.ps1` (pin `48b035cf…`, marcatore
`MARCATORE_RIGA_RELATIVO_R117BIS_v1`). **Non tocca un solo parametro del
motore** (stesso blob dell'EA): muove solo `@FINOA` a **2026.08.31** e
`FrazioneIS` a **0,50**, cambia i magic (774621/774631) perche' un CSV di R117
non possa essere riletto al posto di uno del round nuovo, e aggiunge tre blocchi
di referto (**campione unito A6b — proposta, non firmata**; **quanto storico
servirebbe per A6**; **controllo di coerenza col passo 0**).
⚠️ **Il verdetto atteso resta `MERITO SOSPESO`**, e va detto prima: il round
serve a leggere **A3 su campioni bilanciati** e a mettere agli atti il campione
unito, non a far passare A6.

---

### CACCIA MECCANISMI DAX/DOW (06/09/2026) — 0 EA esterni promossi, 1 verifica che chiude un capitolo

Dossier completo: `caccia_strategie/CACCIA_INDICI_DAX_DOW_MECCANISMI_2026-09-06.md`.
Il resto sta li', non si duplica. **ZERO EA esterni promossi, nessun EA/preset/
sedia/parametro di forward toccato, nessun backtest lanciato.** Applicazione
della Regola della Seconda Caccia su DAX e Dow.

- 🚨 **L'ORB-STRADDLE (doppio ordine stop opposto + cancellazione immediata
  della gamba opposta) E' GIA' IN CASA, IN QUATTRO EA, E DUE GIRANO SUL CONTO
  REALE.** Verificato nel sorgente, non nella descrizione:
  `ABTG_DAX_Apertura_EU.mq5` (770101, **LIVE**) piazza BuyStop r.**1073** e
  SellStop r.**1096** e cancella con `HandleOCO()` r.**1850-1854** ->
  `CancelMyPendings()` r.**1833-1845**, chiamato a ogni tick da r.**590**;
  `ABTG_ORB_Ottimizzato.mq5` (770611, **LIVE**) r.**456/471/1029**;
  `ABTG_Londra_ORB.mq5` r.**220/235/304**; `ABTG_MaxMinNotte.mq5`
  r.**355/367/473**. (Piu' `ABTG_PostNews.mq5` con `OcoCheck`.)
  🔴 **E i quattro "tratti distintivi" della fonte esterna sono INPUT che
  abbiamo gia'**: geometria ATR-adattiva = `InpSLMode=ABTG_SL_ATR` +
  `InpAtrSlMult` (r.**314-315**); pavimento di stop a ZERO = `InpMinStopPts`,
  **il cui default e' gia' 0** (r.**345**); parziale+BE+runner = `InpTP1_R` /
  `InpBEatR` (r.**317/320**). ➡️ Proporlo sarebbe **una griglia di parametri su
  una sedia viva**: esattamente cio' che la regola del 19/08 vieta.
  ⚠️ **Resta UNA decisione di Claudio, non un candidato**: la sedia gira con
  floor 200 e SL al bordo opposto; floor 0 + SL ATR sono due valori di due input
  esistenti, misurabili solo come **ablazione su banco separato con magic nuovi**.
  Numero da mettere davanti prima di deciderlo: spread D30EUR misurato **1,65
  punti indice** -> con SL 20 punti il costo vale **0,0825R = 1,1 volte l'intero
  cancello H8**. "Stop strettissimo" e "prop" sono in tensione.
  📌 I numeri della fonte (DAX PF 2,40 DD 2,07% · Dow PF 3,01 DD 2,67%) sono
  **[DICHIARATI, BACKTEST IDEALE, NON VERIFICATI DA NOI]** e non pesano.
- 🪦 **CONFERMA, quinta volta di fila: il Code Base non produce piu' MOTORI.**
  I due soli EA nuovi dal 05/09 sono doppioni per ammissione della loro stessa
  pagina: **76927 `Session Range Desk MT5`** (Erdem Mumin Kaynak, 03/09/2026) =
  range di sessione + ingresso ai bordi + stop al bordo opposto = **il nostro
  `ABTG_ORB`**, e l'autore lo definisce _"a programming example"_;
  **77009 `SuperTrend TV EA`** (Mykyta Samoiliuk, 06/09/2026) = flip SuperTrend
  = **famiglia SupRev gia' viva**, e l'autore scrive _"backtests showed modest
  results due to spread costs from frequent reversals"_. Gli altri 38 titoli
  della prima pagina sono **tutti** attrezzi.
- 🪦 **TradingView, terza conferma indipendente (28/08, 30/08, 06/09): il DAX
  gratuito col sorgente e' fatto di INDICATORI.** Tag `dax`: **20 su 22 sono
  indicatori**, e le 2 `strategy` non sono DAX-specifiche. Tag `us30`: **11 su
  13 indicatori**. Le famiglie ricorrenti sono tutte gia' sepolte con un numero
  di casa (ORB, sweep di liquidita' M24, incroci di medie, range asiatico).
  🔴 Due morti per DATI e non per idea: `DAX Breadth`, `DAX Universe Relative
  Strength`, `McClellan for GER30` richiedono i **costituenti dell'indice**, che
  su MT5/BCM non esistono.
- 🪦 **TRE LAPIDI DA PAPER, metadati VERIFICATI con l'API arXiv** (non con la
  pagina): (a) **2511.06177** (Vlasiuk-Smirnov, 09/11/2025) — l'abstract dice
  _"for short lags (1-5,000 ticks), expected responses cluster near zero ...
  suggesting high short-term efficiency"_, e serve NBBO tick di SPY: non
  traducibile; (b) **2512.15720** (Singha, 02/12/2025) — l'entropia di
  order-flow predice la **TAGLIA** del movimento, **non la direzione**
  (_"directional accuracy remains at chance levels (45%)"_): al massimo un gate
  appiccicato, che in casa e' **0 su 5**; (c) **2604.26063** (Lin et al.,
  28/04/2026, VP-MACD su S&P/Nasdaq/**Dow**) — e' un **incrocio di medie**,
  famiglia morta due volte in casa, senza codice pubblicato.
  📌 La letteratura sulle **aste** (4 paper scorsi) e' tutta microstruttura da
  **libro ordini su azioni singole**: su un CFD di indice non esiste asta e non
  esiste libro. Nessuna traduzione possibile.
- 🕳️ **FATTO NUOVO TENUTO, e non e' un candidato: l'ASTA INTRADAY DI XETRA.**
  Lo script `Xetra Auctions Breakout [Box Strategy]` (ovvo_113, agg. 11/02/2026,
  1.742 like) dichiara un'asta intraday DAX alle **13:00-13:02 CET = 12:00-12:02
  ORA SERVER** — un evento di liquidita' **programmato a minuto fisso in mezzo
  alla seduta**, che la flotta non usa: le aperture DAX smettono alle 12:00 e
  `DaxReEntry` comincia alle 12:05. ⚠️ **[INCERTO]: l'orario NON e' verificato
  alla fonte primaria** (`cashmarket.deutsche-boerse.com` e `xetra.com` sono
  entrambi **EGRESS_BLOCKED**) — servono due minuti del browser di Claudio.
  🔴 **E come MECCANISMO resta scarto**: box su finestra oraria + rottura = ORB
  (~210 celle), box + fade = R42 (0/24 IS e 0/24 OOS). _"Cambiare il LIVELLO non
  cambia la geometria"_ (03/09). Si misura, semmai, con una sonda Python sui
  dati M1 esterni gia' in casa (GRXEUR 2012-2018, ora file +5 = ora server).
- 🥇 **L'UNICA PROPOSTA, ed e' DI CASA e MAI ACCESA: la SONDA DELL'OROLOGIO
  sugli INDICI.** `ABTG_SondaOrologio.mq5` (971 righe, scritto il 28/08, **mai
  compilato, mai girato** — zero referti in `risultati_archivio/`) ha sette
  celle FOREX e **zero celle indice**. Meccanismo: si entra all'ora, si esce
  all'ora, **nessuna condizione di prezzo mai** -> nessun parente nel cimitero
  (ORB, fade, sweep, box, incroci, VWAP, gap, relativo, salto: tutti sepolti).
  🎯 **Il numero che lo promuove e' il CAMPIONE, ed e' aritmetica:** entra
  **1 volta al giorno per costruzione** -> **459 feriali** dal pavimento
  2024.09.26 al 2026.06.30 = **~229 operazioni per meta' IS/OOS**, contro il
  pavimento di 150. E' **l'unica famiglia su DAX/Dow che il muro del campione
  non uccide**: R117 RELATIVO NASUSD n 87/154, NY Retest n 114-115, DaxReEntry
  n<=92, salto DAX M15 n~88 — **tutti "merito sospeso"**.
  Cancello zero congelato: **lordo medio/giornata >= 3x lo spread MISURATO in
  quell'ora** (sul DAX, con spread 1,65 pti, fa **>= 4,95 punti indice**),
  lettura SEVERA su ENTRAMBI i simboli.
  ⚠️ Rischio principale dichiarato PRIMA: **un solo regime (toro)** -> criterio
  **I7**, i due lati si leggono INSIEME e una cella simmetrica-opposta e'
  **DERIVA, non edge**.
  ⚠️ Porta d'uscita firmata prima: **se la tabella esce PIATTA, la lapide D7
  ("l'ora del fix": volatilita' si', direzione no) esce CONFERMATA ED ESTESA
  agli indici e la pista si chiude per sempre.**
  📄 Artefatti: `prove/SONDA_OROLOGIO_INDICI.txt` (specifica, criteri **I1-I8**
  congelati, NON si lancia) + 4 celle eseguibili
  `prove/SONDA_OROLOGIO_11_D30EUR_LONG.txt`, `12_D30EUR_SHORT`,
  `13_U30USD_LONG`, `14_U30USD_SHORT`. **Magic 777211-777214 vergini**
  (cercati uno per uno nel repo il 06/09: zero occorrenze; i 777200-777206 sono
  del ramo forex).
- 🚧 **Buchi dichiarati:** **GitHub NON BATTUTO** — UI **429 `Retry-After:
  3600`**, `api.github.com` **403**, **`gh` CLI non installato** in ambiente:
  **terza caccia di fila** (02/09, 05/09, 06/09), ed e' la fonte che di solito
  da' il SORGENTE; **Forex Factory 403**; **SSRN 403**; **Deutsche Boerse e
  Xetra EGRESS_BLOCKED**; **ZERO sorgenti esterni letti oggi** (i due del Code
  Base si scartano sulla loro stessa pagina, il Pine dello script Xetra la fetch
  non lo rende) — e' la debolezza principale del dossier e non e' nascosta;
  **autori e date del Code Base non leggibili dalla lista** (JS), presi dalle
  schede.

---

### CACCIA ORO/ARGENTO — MECCANISMI (06/09/2026) — 0 promossi, 3 LAPIDI MISURATE, 1 CANCELLO, 1 BUG DA 0,6 R

Dossier completo: `caccia_strategie/CACCIA_ORO_ARGENTO_MECCANISMI_2026-09-06.md`.
Il resto sta li', non si duplica. **ZERO EA promossi, ZERO file prova nuovi,
nessun EA/preset/sedia toccati, nessun backtest lanciato.** Al sorgente su
**12 oggetti** (4 `.mq5` nuovi del Code Base + 8 Pine sui metalli), archiviati
in `caccia_strategie/biblioteca/sorgenti/`. Applicazione della
Regola della seconda caccia dopo la chiusura di `ABTG_AltaVelocita` (rosso 8/8
a tick) e il rifiuto dell'argento nello studio PS5 esterno.

- 🔬 **PRIMA VOLTA CHE MECCANISMI SPECIFICI DELL'ORO VENGONO MISURATI, NON
  OPINATI.** Sonde Python su barre M5 esterne (FutureSharks, GPL-3.0, Oanda,
  **UTC**): **XAU_USD 594.311 barre**, **USB10Y_USD 484.218** (future Treasury
  10 anni), **EUR_USD 623.889**, 2012-01-01 -> 2020-05-14. **~430
  configurazioni**, cancello congelato PRIMA (R netto >= +0,075 · n >= 150 ·
  anni positivi >= 7/9 · costo A/R **dichiarato** 0,25 $). Sonde in
  `caccia_strategie/biblioteca/sonde_esterne/sonda_oro_*.py`.
  ⚠️ Limiti dichiarati: non e' BCM, OHLC non tick, **costo dichiarato NON
  misurato**, finestra che **non copre il regime 2021-2026**.
- 🟢 **IL LEAD-LAG BOND -> ORO ESISTE, ED E' L'UNICA COSA VIVA DEL DOSSIER.**
  Disegno C (bond forte, oro ancora fermo): **n=2.210, +0,3219 $/evento,
  t=+4,12, PF 1,303, 8 anni su 9**. E **passa la sua falsificazione**: il
  momentum dell'oro DA SOLO, sugli stessi dati, fa **t=+0,46, PF 1,020** ->
  l'informazione viene davvero dal BOND. La controprova (l'oro guida il bond?)
  da' un effetto **venti volte piu' piccolo**.
- 🪦 **LAPIDE 1 — E MUORE DENTRO LO SPREAD.** Con SL/TP veri (SL = a x ATR60',
  TP = b x SL, ambiguita' intrabarra **a sfavore**) e costo 0,25 $:
  **54 celle, 0 promosse**; la migliore **+0,0201 R** contro il cancello di
  +0,075 R, e sta positiva **3 anni su 9**. Su scala **giornaliera**: **90
  celle, 0 a t>=2,0**, con un anno che vale fino al **111%** del totale.
  **Un edge che non copre il costo non e' un edge piu' piccolo: e' zero.**
- 🪦 **LAPIDE 2 — ORO <- DOLLARO: negativo in ENTRAMBI i versi.** Disegno C con
  driver EUR_USD: verso della tesi **−0,3447 $/evento, t=−6,31, PF 0,718,
  0 anni positivi su 9**; verso contrario **−0,1553 $, t=−2,85**. La
  confluenza bond+dollaro **non aggiunge niente** (miglior t=+1,30).
  ➡️ *"L'oro segue il dollaro"* e' vero come **correlazione** e falso come
  **segnale operabile**.
- 🪦 **LAPIDE 3 — L'ASTA LBMA (fixing 10:30 e 15:00 Londra): 72 celle su 72
  NEGATIVE**, fade E continuazione, su entrambe le aste; in 68 su 72 gli anni
  positivi sono 0 o 1 su 9. Meccanismo **specifico dell'oro** e **mai
  registrato prima** (verificato: zero occorrenze di LBMA/fixing/Treasury nel
  registro). **La finestra d'asta a M5 e' zona di costo puro.**
- 🔴 **XAG_USD NON ESISTE SULLA FONTE ESTERNA — 404 VERO** (XAU_USD 200,
  1.649.390 byte, stessa richiesta). ➡️ **spread oro/argento, ratio trading,
  SMT fra metalli: NON MISURABILI da questo ambiente.** Non misurati, non
  inventati. Si aggiunge alle tre bocciature indipendenti gia' agli atti
  sull'argento (CostToCost XAGUSD PF 0,70 6/7 anni negativi e spenta il 24/08;
  argento "non giudicabile" in fase 0; PS5 esterno *"perde a prescindere"*).
- 🚪 **IL CANCELLO CHE BLOCCA TUTTO, ED E' APERTO DA 12 GIORNI: LO SPREAD BCM
  SULL'ORO NON E' MAI STATO MISURATO.** Il verdetto del lead-lag si ribalta
  su quel numero: a **0,00 $** fa PF 1,303 e 8/9 anni; a **0,25 $** fa
  +0,02 R; a **0,35 $** fa **PF 0,906 e 2/9 anni**. Lo strumento e' gratuito
  ed e' **promosso dal 23/08 e mai usato**: `RealCost Spread P95 Logger MT5`,
  [Code Base 74148](https://www.mql5.com/en/code/74148). **E' lo stesso
  cancello che blocca `KA-Gold Bot` (promosso 9/10 il 25/08, mai costruito).**
  Sotto 0,10 $ lo scaffale oro intraday esiste; sopra 0,30 $ si chiude e lo si
  scrive una volta per tutte.
- 🧨 **RILIEVO DI PROCESSO — UN LOOK-AHEAD DA 0,60 R, PRESO PERCHE' IL NUMERO
  ERA TROPPO BELLO.** La sonda LBMA alla prima esecuzione dava **PF 2,721 ·
  WR 76,4% · 9 anni su 9**. Trattato come **sospetto di bug**, non come
  scoperta: il segnale usava la **chiusura** della barra `j` e l'ingresso
  avveniva all'**apertura della STESSA barra `j`**. Corretto a `j+1`, la stessa
  cella va da **+0,3930 R a −0,2043 R**. 📌 Segno di riconoscimento da
  ricordare: **la simmetria innaturale fra i due lati** (CONTINUA +0,39 /
  FADE −0,73 sugli stessi eventi) vuol dire che si sta misurando la **barra
  d'ingresso**, non il mercato.
- 📚 **CODE BASE SULL'ORO: ESAURITO, e stavolta col catalogo completo.**
  **1.609 titoli** ricrawlati (42 pagine, HTTP 200), **18 in tema metalli**, di
  cui **12 con "recovery"/"grid"/"quantum"** nel nome o negli input e **5 della
  famiglia `SilverTrend`** (falso amico: e' un indicatore di tendenza, **non
  l'argento**). **4 sorgenti nuovi letti riga per riga, tutti scartati**:
  `Sniper Gold Hybrid Recovery EA` (76605, 26/08/2026, 65 input,
  `RecoveryLotMultiplier=1.20` + cap interno al **12%** contro un muro prop del
  10%), `XANDER Grid XAUUSD` (71776, griglia bidirezionale `GridStep=390` +
  `AVERAGE_TP`), `Quantum XAUUSD Silver Trader` (73622, **79 input**, doppia
  taratura Gold_/Silver_ = fratello del 63193 gia' scartato il 16/08),
  `GoldWarrior02b` (20577, `InpMultiplier=3 // Multiplier of hedge positions`
  + `iCustom` non allegati + lotto fisso).
- 🌲 **TRADINGVIEW: 8 STRATEGIE SUI METALLI LETTE RIGA PER RIGA, 0 PROMOSSE.**
  169 script censiti su 8 query, **113 col sorgente leggibile**. **Due sono
  ROTTE**: `XAG strategy 1h` (@SoftKill21, MPL-2.0) ha
  `strategy.entry("long",1,when=short1)` — **il 2o argomento in Pine v4 e' il
  bool `long`, quindi i nomi sono invertiti**, ed e' **lo stesso difetto gia'
  verbalizzato il 28/08**; `Gold/Silver 30m Only` (@MtxTrader) ha l'uscita
  short identica a quella long e l'ingresso short su `vrsi > 35`. **Quattro
  senza stop loss.** L'unica davvero in tema — `Silver Long/Short` (@tyler747),
  che E' il gold/silver ratio — dimensiona al **100% dell'equity**, non ha
  stop, e ha le soglie GSR **60/45 cablate sull'epoca 2000-2020** (il GSR ha
  toccato **125 nel marzo 2020**). `Aurum DCX` (@exlux) e' il meglio scritto
  (tutti i `request.security` con `lookahead_off`, SL/TP + trailing) ma ha
  **28 input e cinque filtri impilati** = l'architettura che da noi e' **0
  successi su 5**. ➡️ **La tesi del RAPPORTO oro/argento esiste come idea, ma
  NON esiste una implementazione sana: andrebbe scritta da zero** — e prima
  serve l'argento, che da qui non si misura.
- ⚠️ **TRAPPOLA DA ANNOTARE (`Gold/Silver Spread`, @MarcoValente):**
  `spr = (au - ag)` con oro ~2.000 e argento ~25 e' **oro al 98,7%**. Quel
  grafico chiama "spread" **il prezzo dell'oro**. L'oggetto giusto e' il
  **RAPPORTO** `au/ag`, non la differenza.
- 🧨 **UN MIO ERRORE DI CANALE, CORRETTO IN GIORNATA E A VERBALE.** A meta'
  caccia avevo concluso che *"TradingView non da' il codice"* perche' il campo
  `scriptSource` era vuoto in **164 script su 169**. **Falso**, e la procedura
  giusta era gia' in `PROMEMORIA_SBLOCCO_FONTI.md` §2-A **dal 28/08**: si legge
  **`access`** e si scarica da **`pine-facade`**. Rimisurato: **113 leggibili
  su 169 (67%), non 5 (3%)**. 📌 **`scriptSource` vuoto non vuol dire
  "protetto": vuol dire "usa l'altro endpoint". Il campo che dice la verita' e'
  `access`.** Otto sorgenti scaricati subito dopo, 8 volte HTTP 200.
- 🌐 **Altre fonti, resa zero:** arXiv **7 query, 2 paper in
  tema e 0 operabili** (il turn-of-the-year sull'oro e' calendario annuale =
  famiglia R63 chiusa, e 1 occasione l'anno); Quantpedia **82 slug, 5 su
  materie prime**, tutti panieri di futures con roll = non traducibili su CFD.
- ✅ **CANALE NUOVO DA SCRIVERE IN `PROMEMORIA_SBLOCCO_FONTI.md`:**
  **`tradingview.com` risponde 200 oggi** (`/scripts/gold/` e
  `/pubscripts-suggest-json/?search=`), e **`quantpedia.com/strategies/` pure**
  — erano dichiarate bloccate. ⚠️ Ma su TradingView **il sorgente non arriva**
  per gli script moderni: canale buono per i **titoli**, non per il **codice**.
- 🚧 **Buchi dichiarati:** **argento non misurabile** (404 vero); **regime
  2021-2026 non coperto** (i dati esterni finiscono il 2020-05-14: nessuna
  misura sull'oro sopra i 2.000 $); **spread vero non misurato** (ogni numero
  e' al netto di un costo **dichiarato**); **GitHub UI 403 oggi** — era viva il
  05/09, riprovata due volte con attesa, **dichiarata non raggiunta, non
  cancellata**; **164 script TradingView su 169 col titolo verificato e il
  codice no** — e un titolo non e' un candidato; **Forex Factory 403** e
  **api.github.com 403**, coerenti coi dossier precedenti.

---

## 🪦 09/09/2026 — `ABTG_IBRetest` (magic 772900): SCARTATO dal cancello C0

**Origine**: meccanica derivata da *"IB Completed"* di Genxtraders (TradingView,
slug `Z1CwMI6V`), scritta da specifica in codice nostro. Dossier di caccia
`report/CACCIA_M30_INDICI_2026-09-08.md`, dove era il candidato **P1, 9/10** —
il piu' solido dei tre. Referti: `report/P0_IBRETEST_2026-09-09.md` (madre
U30USD) e `report/P0_IBRETEST_NASUSD_2026-09-09.md` (gemelli + verdetto).

**Famiglia misurata su TRE simboli, M30, tick reali, 2024.09.26 -> 2026.06.30,
deposito 10.000, rischio 0,65%:**

| simbolo | n | PF IS | PF OOS | DD IS | DD OOS |
|---|---|---|---|---|---|
| U30USD | 95 | 0,38242 | 0,69663 | 7,38% | 7,61% |
| NASUSD | 84 | 0,56297 | 0,59292 | 5,80% | 5,31% |
| D30EUR | 165 | **1,21062** | 0,96493 | 2,80% | 5,25% |
| **FAMIGLIA** | **344** | **0,7356** (n=135) | **0,8124** (n=209) | non sommabile | non sommabile |

**PF di famiglia 0,7798.** Cancello **C0** (`n >= 150` + `PF < 1,10` nella
finestra peggiore -> scarto senza griglia), congelato nei file prova PRIMA
delle corse: **scatta**, e scatta sulla **sola finestra OOS a campione pieno**
(n=209). Secondo motivo indipendente: **0,78 op/giorno di famiglia** contro il
pavimento firmato di **1,00** (07/09).

**PERCHE' STA QUI, cioe' cosa NON rifare:**
1. 🚫 **Non ritestare "solo il DAX".** D30EUR ha una finestra a **PF 1,21 con DD
   2,80%** ed e' il simbolo migliore dei tre. Tenerlo e buttare gli altri due
   e' la scelta a posteriori vietata dalla regola del 19/08: su **58
   operazioni** PF 1,21 non e' distinguibile da PF 1,00, e infatti l'OOS dello
   **stesso simbolo**, senza che nulla fosse stato ottimizzato, fa **0,96493**.
2. 🚫 **Non rigrigliare `InpSmaLen` / `InpPivot` / `InpRR` / l'orario di flat.**
   Su un motore a PF 0,78 di famiglia una griglia trova solo picchi di rumore.
3. ✅ **Quello che si PUO' riprendere** (clausola buona del 19/08, meccanismo
   diverso sulla stessa inefficienza): **la GESTIONE DELL'USCITA**. Misurato:
   **il 62% dei trade non muore di stop ne' di TP, ma del flat di fine seduta**
   (52/84 su NASUSD, 103/165 su D30EUR). Il porting ha un **TP unico a 2R**
   mentre la fonte esce a scaglioni **1R/2R/3R/4R/5R con breakeven a 2R**: era
   il **rischio di porting n.2, dichiarato per iscritto prima delle corse**, e
   si e' misurato da solo. Sarebbe un MOTORE NUOVO, non una cella nuova.

**COSA LASCIA DI BUONO (l'EA e' sano, non e' il codice il problema):**
- 4 cancelli su 5 passati su **tutti e tre** i simboli: frequenza, rischio
  (DD max 7,61%), muro giornaliero (peggior giornata −1,08%), costo C3
  (stop mediano 110-240 punti indice = **67x-123x lo spread**, frontiera 40x);
- **G1 determinismo**: celle gemelle 772900/772950 identiche alla cifra in
  tutte e sei le corse;
- **due lati veri**: Long/Short 60/40 su NASUSD, **29/29 in IS su D30EUR**;
- **pavimento del lotto non morde** (4 casi su 344) -> nessuna corsa a 100k.

**BUCO DICHIARATO, da chiudere sui prossimi EA:** su D30EUR la colonna
`Reject` conta **94 ordini rifiutati su ~259 tentativi (36%)** contro 16 su
NASUSD e 2 su U30USD-IS. E' la firma del cancello sullo spread che respinge i
segnali serali (finestra DAX ~11 ore contro 5,5 degli USA, asimmetria
**dichiarata prima** nel file prova). **Ma l'ORA dei trade riempiti non e'
misurabile da queste colonne**: serve una colonna `Ora Ingresso` nell'OnTester.
Finche' non c'e', il numero del DAX e' **non verificabile su quel punto** —
il che non e' la stessa cosa che "sporco".

---

## 🚧 ORO — FINESTRA 15:36 M1 (metodo del collega di Claudio) — 🔴 BOCCIATO PER COSTO (10/09/2026)

**Cella giudicata:** XAUUSD · range M5 **14:30-14:35 server** (15:30-15:35 IT) ·
rottura su **M1 alle 14:36** · ingresso **a mercato** · uscita dopo **3-4 candele M1**.
Referto completo: `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md`.

**I NUMERI (misurati, con fonte):**
- **spread BCM sull'oro**: **0,16 $** (17/08 17:34 srv, `sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` r.59)
  e **0,22 $** (27/08 08:5x srv, `R114_CORSA_20260827/REFERTO_R114.txt` r.112-113).
  🔴 **Nella finestra 14:30-14:41 e' [NON MISURATO]** — i conti usano il numero PIU' FAVOREVOLE.
  ✍️ **ERRATA**: il "0,24 $ misurato in casa" di `CACCIA_APERTURE_ORO_2026-09-08.md` r.208/390
  **non ha fonte nel repo** e va ritirato.
- **commissione MISURATA**: **−3,48 EUR/lotto giro completo** (n=385, `data/statements/trades_auto.csv`).
  🚨 **L'oro paga commissione; D30EUR/NASUSD/U30USD pagano ZERO.** = 0,0403 $ = 25% dello spread.
- **costo pieno giro completo**: **0,2003 $ = 20,03 USD/lotto = 17,28 EUR**. Contratto **100 oz/lotto**,
  1 punto (0,01 $) = **1,00 USD/lotto**.
- **frontiera `40 x spread`** → stop minimo **6,40 $** (**8,01 $** col pedaggio pieno);
  pavimento DURO `13,3x` → 2,13 $.
- **movimento MISURATO del trade in quella finestra**: **1,41 $** (mediana, n=33 aperture
  14:35-14:40 srv su **19 giornate**, magic 0 = trading manuale di Claudio; durata mediana **1,9 min**).
  Controprova indipendente: range di giornata mediano **40,50 $** (n=60 giorni) con la regola √t
  dà 1,47 $ → **scarto 4,3%**.
- **rapporto stop/spread reale: 8,8x - 12,5x** → **sotto anche il pavimento DURO**.
  Manca un fattore **3,2-4,5x** al pavimento di lavoro. *(Per confronto: U30USD H1 = 56,9x,
  margine +42%, il più sottile mai accettato; gli indici su M5 sono già esclusi PER COSTO.)*

**PROVA SPERIMENTALE IN CAMPO (non è solo aritmetica):** le stesse 33 operazioni fanno
**22 vinte su 33 (66,7%)** e chiudono a **−785,99 EUR netti**, di cui **~473 EUR (60%)
sono solo pedaggio** (377,92 spread stimato + 95,24 commissione misurata).
**Vincere due volte su tre e perdere è la firma del cancello di costo.**
⚠️ n=33 è sottile per il MERITO (valvola R59) — ma il verdetto di costo non poggia su questi
trade: poggia sull'aritmetica. Questi sono la conferma indipendente.

**VALE IDENTICO PER IL TRADING A MANO.** Spread e commissione li mette il broker, non l'EA.
E a mano il costo è **più alto**: ogni secondo di esitazione vale **~1,24 USD/lotto**
(derivato da 1,41 $ / 1,9 min), ed è un **limite inferiore** perché sulla rottura la velocità
è sopra la media.

**🔓 NON È MORTA LA TESI — il TF più basso che la frontiera lascia passare sull'oro:**
**M30 con stop ≥ ~8,8 $** (1,5 × il range tipico, margine **+9,7%** — sottile: a +50% di spread
non passa più) · **H1 = il gradino robusto** (+55% a 1,5x). Il range d'apertura su M30
(14:30-15:00 srv) è lo stesso meccanismo di `ABTG_ORB` / `ABTG_Nasdaq_Apertura_US`, macchine
già in casa. **Ma non è più il trade del collega**: range 30 min, durata ore, stop ≥ 8,8 $.

**BUCHI DICHIARATI (nessuno di questi è "morto", sono [NON MISURATO]):**
spread nella finestra 14:30-14:41 · slippage sull'oro (0 righe XAUUSD in tutti i dataset:
il `SlippageLogger` sta sul REALE 10105439, che ha solo D30EUR) · slippage della reazione
umana · requote/rifiuti · **profondità a tick di XAUUSD** (blocca ogni verdetto di MERITO
sull'oro, regola F6) · ATR per TF sull'oro (oggi [INFERITO]).

---

## 🪦 12/09/2026 — SEQUENZA DI INVERSIONE MONOTONA su indici: **MISURATA FUORI, NON ENTRA** (e il certificato ha i numeri)

Nata dalla **regola della seconda caccia** dopo l'**A6** dei blocchi B e C di
`ABTG_SupRev` (`risultati_archivio/R123_BLOCCO_C_2026-09-12.md`). Dossier completo:
`report/CACCIA_SUPREV_ALTERNATIVE_2026-09-12.md`. **Zero passate di tester spese,
zero EA toccati.**

- 🧬 **MECCANISMO (vergine in casa: `grep` su "streak/consecutiv" = zero occorrenze
  come motore).** Candela madre direzionale + N candele monotone contrarie (tutte
  dallo stesso lato, chiusure strettamente progressive, nessuna che viola l'estremo
  della madre) → ingresso al close della N-esima, **SL strutturale all'estremo della
  madre**, TP a multiplo di R. Fonte letta nel sorgente: `Momentum Sequence Strategy
  [Herman]`, helmans13, **MPL 2.0**, TradingView `mmrInMTp` /
  pine-facade `PUB;11d65a5fe0724173b72c230c576947fc`. **Zero bandiere del §4**
  (stop vero, `pyramiding=0`, nessun repaint); unico difetto = **lotto fisso**, che
  sta nella gestione e non nel motore.
- 🔬 **MISURA (sonde nuove: `caccia_strategie/biblioteca/sonde_esterne/sonda_sequenza.py`
  e `sonda_sequenza_anni.py`)** su **1.942.126 barre M1** di `GRXEUR` + `SPXUSD`
  2015-2018 (histdata, GPL-3.0), sessione cash, ambiguita' intrabarra **a sfavore**,
  **controllo appaiato** (stessa barra, lato opposto), orologio **ricollaudato**
  (GRXEUR picca 03:00 file = 08:00 server).
- 🐻 **IL FATTO CHE TENGO: l'asimmetria dei lati.** Su DAX, RR 2,0: **SHORT positivo in
  6 combinazioni su 6** (N × TF), **LONG negativo in 6 su 6**. Le due piu' pulite:
  **H1 N=3 SHORT E netta +0,057R** (n=251, 1R 85,8 pt = **52× lo spread**) contro
  **H1 N=3 LONG −0,211R** (n=265). Sul medesimo segnale il lato opposto fa **27,8%**
  di TP-prima-di-SL dove lo short fa 35,9%.
- 🔁 **IL CONTRO-ESEMPIO CONTRO ME STESSO, e una cella si e' ribaltata (dichiarato).**
  Nella prima passata filtravo dentro la sessione **solo la barra d'ingresso**: un
  pattern poteva cominciare **nella notte**. Con la variante `ALLIN=1` (tutte le barre
  del pattern in sessione) **M30 N=3 SHORT passa a 3/4** (+0,117 / −0,199 / +0,038 /
  +0,159, n 87-128 per anno). 🔴 **Non cambia il verdetto, e il conto e' questo:** ho
  guardato **24 celle** (12 × 2 varianti) e il cancello "3 anni su 4" sotto una moneta
  annuale passa il **31,25%** delle volte → su 24 celle una moneta ne darebbe **~7,5**,
  io ne trovo **2**. 📌 **Lezione di metodo da tenere: un test di SEGNO su 4 anni non e'
  un cancello severo** — serve segno **+** taglia, o piu' anni.
- 🎯 **E CIO' CHE NON E' RUMORE: il segno lo decide l'ANNO, non il parametro.** Celle
  short positive per anno (6 celle N × TF): **2015 5/6** (crollo d'agosto) · **2016
  1/6** · **2017 1/6** (il toro piu' tranquillo del decennio) · **2018 6/6** (orso).
  Non dipende da N, non dipende dal TF, non dipende da RR: e' un **interruttore di
  regime**.
- 🔴 **IL CANCELLO CHE L'HA FERMATA, scritto PRIMA dei numeri** (intestazione di
  `sonda_sequenza_anni.py`): *"il segno della E netta deve reggere in ≥3 anni su 4"*.
  Esito: **2 su 4** su tutte le celle con campione — **H1 N=3 SHORT: +0,297 (2015) /
  −0,115 (2016) / −0,241 (2017) / +0,201 (2018)**. Positiva **solo** negli anni con
  discese e volatilita', negativa in **entrambi** gli anni di toro tranquillo.
  L'unica riga a 3/4 (H1 N=4 SHORT) ha **21-26 operazioni per anno**.
- 🧲 **LA TENAGLIA, col conto:** frontiera `stop ≥ 40 × spread` sul DAX (spread
  misurato 1,65) = **66 punti indice** → la passano **solo** H1 N≥3 (85,8 pt) e M30
  N=4 (83,3 pt). Ma sui **459 feriali** della cassaforte tick BCM quelle celle fanno
  **115-235 operazioni totali** → **46/69** e **94/141** per finestra, **sotto il
  pavimento dei 150**. Le celle che passano il campione (M30 N=3 L+S, ~475 op; N=2
  L+S, ~1.020) hanno **1R a 24-36× lo spread**: fuori per costo. **Dove passa il
  costo non passa il campione, e viceversa** — identico a M31.
- 🔗 **TERZA CONFERMA INDIPENDENTE che la famiglia e' REGIME-CONDIZIONALE**, e le altre
  due erano gia' agli atti: `ABTG_InvEsaurimento` **E3** (PF 1,16 totale ma **−5.604
  nel toro 2017** / **+2.946 nell'orso Q4-2018**, `REFERTO_INVES_2026-08-30.md`) e il
  paper **arXiv 2605.04004** su MNQ (*"MNQ OU mean reversion permanently rejected
  (Hurst 0.59, trending)"*, *"momentum-dominant at 5-minute resolution"*, 14 famiglie
  di segnale, 947 giorni, **nessuna passata**).
  ➡️ **Conseguenza operativa: sugli indici BCM (21 mesi, UN solo toro) un round di
  questa famiglia compra un rosso prevedibile.** Non e' un verdetto sul meccanismo:
  e' un verdetto sul rapporto valore/costo **oggi**, a tre settimane dalla challenge.
- 📌 **STATO: ⏸️ CONGELATO, NON MORTO.** Spec con criteri **S1-S9 congelati** e attesa
  dichiarata in `backtest_pipeline/prove/SEQUENZA_INDICI_SPEC.txt` (**NON LANCIABILE**:
  l'EA non esiste). Riapre **solo** con dati d'orso sugli indici o con una variabile di
  regime **costitutiva** (il filtro appiccicato dopo e' **0 successi su 5** in casa).
- 🚫 **E I QUATTRO SCARTATI DELLA STESSA CACCIA, letti nel sorgente** (nessuno ha
  prodotto un numero perche' nessuno ha superato il setaccio):
  `EA KCI Embeded Sniper` (Code Base **74582**, 234 righe) → tesi non scrivibile (somma
  di differenze di z-score) + `CopyTickVolume` su CFD + lotto fisso; 🧨 **e un baco
  vero: r.206-215, con `InpUseTrendFilter=true` l'EA non puo' aprire NIENTE** (le due
  guardie opposte si applicano entrambe) ·
  `The Bar Counter Trend Reversal Strategy` (tradedots, `0KAtQQDD`) → **nessuno stop**
  (zero `strategy.exit`) + motore = esaurimento grezzo + bordo di canale = **E1 (PF
  0,95) + M14 (6 finestre su 6 rosse)** ·
  `AxMan Exhaustion / Sniper V4` (Axj_Stev, `72gQqAzW`) → **nessuno stop** + RSI/volume
  spike (**R109, DD 44-68%**) + liquidity grab (**M24, 0/30**) ·
  `Bearish Wick Reversal` (Botnet101, `Kz4wRzup`) → **nessuno stop** +
  `calc_on_every_tick=true` + un lato solo + soglia **1% del prezzo** (≈240 punti DAX
  in una barra: su H1 in sessione non capita).
- 🕳️ **Fonti NULLE dichiarate quel giorno:** SSRN **403** (e restano fuori i due paper
  che servirebbero: Grant-Wolf-Yu `abstract_id=689282`, Baltussen-Da-Soebhag `=5039009`
  — **visti solo come titolo in un elenco di ricerca, non aperti**) · Quantpedia **308**
  · GitHub **403** UI e API · Forex Factory **403** · arXiv **API in timeout** (la
  pagina elenco invece passa). 🟢 **Nuovo canale confermato vivo:** `mql5.com/en/code/download/<ID>`
  restituisce lo **zip col `.mq5` vero** senza autenticazione.

---

## CACCIA DEL SABATO (13/09/2026, TF basso · priorita' FOREX) — 0 EA promossi, 0 file prova, 3 sorgenti letti, 2 porte chiuse

Dossier completo: `report/CACCIA_SABATO_2026-09-13.md`. Il resto sta li', non si
duplica. **ZERO EA promossi, ZERO file prova nuovi, nessun EA / preset / sedia /
parametro di forward toccato, nessun backtest eseguito.** 320 titoli del Code
Base sfogliati su 8 pagine (649.349 byte), 12 schede aperte (200), 3 sorgenti
scaricati e letti riga per riga e archiviati in `biblioteca/sorgenti/`.

- **PORTA CHIUSA — `Market Miner` (Code Base 74818, amarfx, 09/07/2026): ZERO
  STOP LOSS IN 861 RIGHE.** `grep -i "PositionModify|SetStopLoss|stoploss"` ->
  **zero righe**. Tutti e otto gli invii sono `trade.Buy(lot, _Symbol, Ask)` a
  **tre argomenti** (r.336/371/442/477/548/583/654/689): nessun `sl`, nessun
  `tp`. L'uscita e' un **obiettivo di equity di paniere per magic** (r.325,
  chiusura su `Profit()+Swap()` sommati, r.725-745): si chiude in utile e **mai
  in perdita**. Oltre: **90 input** (6x il tetto), `Account_Risk_percent = 99`
  (r.62), `LotSize = 0.01` fisso (r.59). **Nome interno del file: `CycleTrade.mq5`**
  (r.2) — il titolo pubblicato *"Market Miner - A multi strategy EA gold mine"*
  e' marketing; `#property copyright "Amarnath Kondiyan Mohan"`. **Quattro cicli
  con magic 111/333/555/777, taglia separata e obiettivo di equity separato**, su
  inviluppi a deviazione 0,3/0,7/0,7 (r.74/90/106 -> `iEnvelopes` r.203-207).
  ⚠️ Precisione: quelle deviazioni sono **larghezze di banda, NON passi di
  griglia**, e `Distance=10` (r.107) e' un filtro d'ingresso, non uno step —
  **non e' una griglia a passo fisso**; ma quattro sistemi senza stop sullo
  stesso simbolo che chiudono solo per utile di paniere accumulano contro il
  prezzo, e **funzionalmente e' mediazione** `[INFERITO dalla struttura]`.
  **Chiude la porta H1 lasciata
  ESPLICITAMENTE aperta il 06/09** (`CACCIA_TFBASSO_FREQUENZA` r.476: _"non e'
  un cadavere, e' fuori dal MIO perimetro. Chi batte H1 lo apra"_).
- **FATTO VERIFICATO — Code Base 77220 `ZetaBurst Scalper EA` e 77167
  `PulseStrike Scalper` SONO LO STESSO FILE BYTE PER BYTE.**
  `md5sum = 0d1ad42e8bef432b2b99bceca1ab8b41`, `diff` vuoto, 20.306 byte,
  stesso autore (`ranaali878`), pubblicati a un giorno di distanza (10/09 e
  09/09). **Chi conta i candidati del Code Base per titolo li conta doppi.**
  SCARTO: (a) il **gate di costo dell'autore stesso** (`InpMinTPToSpreadRatio=3`
  con `SL/TP = 0,55/0,35`) implica `stop/spread >= 4,71x` contro il nostro
  pavimento **DURO di 13,3x** = **35%**, e **11,8%** del pavimento di lavoro
  40x; (b) e' **M31 salto statistico** con uno stimatore a 4 secondi invece di
  Lee-Mykland: famiglia **sepolta due volte** (M5 16/16 sotto il cancello; M15
  con la contro-prova _"l'edge per segnale e' una QUANTITA' FISSA DI ATR
  (~0,16): nessuna geometria salva l'aritmetica"_, che chiude anche la fuga
  "portalo su H1"); (c) **RR 0,64** (TP 0,35 ATR / SL 0,55 ATR) = win rate >61%
  solo per il pari. **Il setaccio §4 lo passa pulito** (nessuna martingala,
  nessuna griglia, stop vero al broker, rischio in %): muore di costo e di
  doppione, e va scritto cosi'. 🟢 **E lo stop e' STRUTTURALE, verificato**:
  `slDist = InpStopLossATRMult * atr` (r.403) su `iATR(_Symbol,_Period,...)`
  (r.141) + pavimento al minimo del broker (r.386-388), **nessun numero fisso in
  pip** — e' l'unico dei tre sorgenti di oggi con uno stop strutturale vero.
  ⚠️ **Nome interno `PulseStrike_Scalper.mq5`** anche nel file scaricato da
  77220: il titolo pubblicato non e' il nome del sorgente.
- **SCARTO — `Heikin Ashi Engulfing` (Code Base 35628, traderonemax,
  14/07/2021):** r.826 `VolumeMode == "martingale"` -> `BetMartingale(...
  mmMgMultiplyOnLoss ...)` definita a r.3165 = **martingala nel codice**;
  r.4323 **WebRequest**; r.1331 `iCustom("Examples\\Heiken_Ashi")`; lotto fisso
  `0.01`; stop a **pip FISSI** (50) = non strutturale; 8.213 righe da
  costruttore visuale. **E' materiale di un VENDITORE COMMERCIALE**:
  `#property copyright "https://payhip.com/forexeas"` (r.2-3). ⚠️ La martingala
  e' **UNA delle ~11 modalita' selezionabili** di `VolumeMode` (r.809-826), non
  il default: **modulo OPZIONALE ma PRESENTE**, e resta scarto per RISCHIO (un EA
  che *puo'* mediare su un conto prop non serve), non solo per lettera.
- 🔎 **DUE CONTROLLI NUOVI, nati da `Market Miner` e da applicare a OGNI
  candidato prima di promuoverlo.** (1) **Il grep non e' un verdetto:** su
  `Market Miner` il grep di `martingal|grid|averag|recover|hedge|Multiplier` ha
  dato **ZERO righe** e la mediazione c'era comunque, nascosta nella STRUTTURA
  (quattro cicli) e nei NOMI (`c1_lot`…`c4_lot`). 👉 **Aprire le chiamate di
  apertura e CONTARE GLI ARGOMENTI**: `trade.Buy(lot,symbol,price)` = tre
  argomenti = **`sl=0`**, contro la firma
  `(volume,symbol,price,sl,tp,comment)`. Costa dieci secondi.
  (2) **Confrontare il NOME INTERNO col TITOLO PUBBLICATO**: `Market Miner` ->
  `CycleTrade.mq5`; `ZetaBurst Scalper` -> `PulseStrike_Scalper`. **Quando
  divergono, il titolo e' marketing e il sorgente e' il fatto — oggi due
  candidati su tre divergono.**
- **IL CONTO CHE RISPONDE ALLA RICHIESTA "TROPPI POCHI EA DAL TF BASSO", e
  contraddice l'assunto del brief.** Col costo **all-in** (spread misurato +
  commissione 0,004% del nozionale in valuta base, giro completo) **EURUSD M5 e
  M15 sfondano il pavimento DURO, non solo quello di lavoro**:
  M5 stop 8,0 pip / 0,86 all-in = **9,30x** (70% del duro, 23% del 40x);
  M15 stop 10,8 pip / 0,86 = **12,56x** (94% del duro, 31% del 40x).
  Per il 40x su EURUSD serve uno stop **>= 34,4 pip**. **Il major piu'
  economico e' GBPUSD** (spread 0,2 [LETTURA UNICA] + ~0,47 commissione
  [INFERITO] = **~0,67 pip**): pavimento duro a **>= 8,9 pip**, pavimento di
  lavoro a **>= 26,8 pip**. **Bersaglio indicato: GBPUSD M30.**
- **E UNA LEZIONE DI METODO, CON IL FINDING UCCISO DALL'AUTORE.** Avevo trovato
  che le cacce M5/M15 del 05/09 usavano la **convenzione 1,0 pip** mentre la
  sonda del 10/09 **misura 0,4** su EURUSD, e che a 0,4 pip il salto statistico
  M31 ribaltava il segno (lordo +0,0922R, netto da **−0,033R** a **+0,042R**).
  **L'aritmetica torna al centesimo, e la tesi e' comunque FALSA:** nello
  **stesso referto**, poche righe sopra la tabella, c'e' il termine che mancava
  — _"spread 0,3 + commissione ~0,5 = **0,86 pip all-in su EURUSD**"_. La
  convenzione di 1,0 pip era corretta entro il **14%**, non pessimista di 2,5
  volte. **Nessun ribaltamento. Classe di errore: ho letto la tabella che mi
  dava ragione e non il paragrafo sopra.**
- **CONSEGUENZA SULLA FREQUENZA, ed e' una inferenza dichiarata (non una
  misura):** 150 posizioni per lato in 18 giorni di mercato richiedono **11,5
  op/giorno per lato**, che a TF basso e' territorio di pedaggio insostenibile.
  **Quindi le 150 posizioni per il 1 ottobre possono venire solo dal BACKTEST,
  non dal forward** — e allora l'asse che rende schierabile una sedia e' la
  **PROFONDITA' DELLO STORICO** (forex: gennaio 1999, R102; indici: 21 mesi),
  non la velocita' del motore. Decide Claudio.
- **BUCHI DICHIARATI:** **TradingView NON aperta** in questa battuta (e' il buco
  vero: prima fonte della prossima); SSRN 403, Quantpedia 308/502, GitHub UI
  403, Forex Factory 403, arXiv API timeout (non aggirati); popolarita' delle
  schede Code Base **[NON MISURATO]** (contatori in JS); **lo spread forex BCM
  e' UNA lettura di UN istante (17/08 17:34 srv)** e su **AUDUSD/EURAUD/GBPJPY/
  CHFJPY la sonda legge 0 = nessun tick**, quindi il loro costo e' **[NON
  MISURATO]**; **gli stop tipici M30 sul forex sono [NON MISURATO]** e NON
  sono stati estrapolati.
- **MOSSA PIU' ECONOMICA (decide Claudio):** far girare il *RealCost Spread P95
  Logger MT5* (Code Base **74148**, a1066832477, 20/06/2026, scheda aperta oggi
  HTTP 200) su GBPUSD/EURUSD/USDJPY nelle fasce di lavoro. **Costo: ZERO passate
  di tester** (e' un logger dal vivo). Promosso in casa il 23/08 e **mai usato**:
  lo segnalano **sette cacce di fila**. Se GBPUSD nella fascia di lavoro fosse
  0,5 invece di 0,2, la soglia del 40x passerebbe da 26,8 a **38,8 pip** e il
  bersaglio M30 sparirebbe.

---

## 12/09/2026 — SCARTI CON IL NUMERO su `ABTG_EMA200` (dossier `report/EMA200_I_DUE_REQUISITI_2026-09-12.md`)

Scavo di sola lettura sull'archivio, **nessun backtest lanciato**. Qui vanno solo
le righe che **scartano** qualcosa: il resto (e le due CORREZIONI al referto del
mattino) sta nel dossier.

### 🪦 TF esclusi PER COSTO su U30USD — frontiera `stop >= 40 x spread`, pavimento duro 13,3x
Spread MISURATO su 64.711.285 tick (`risultati_archivio/spread_flotta/spread_orario_U30USD.csv`):
mediana di sessione (ore 14-21 server) **1,8-2,0** punti indice; commissione sugli
indici **0,0000 MISURATA** (n=302 deal, `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md`
r.181-183, riconfermata oggi su 21/21 posizioni della sedia 771531) => **il pedaggio
all-in sul Dow e' lo SPREAD e basta**. Stop della gamba debole = `InpSLatr x ATR`
= **1,0 x ATR**, con ATR(14) H1 **MISURATO 78,0-88,2** punti indice (backtest R112
mediana 88,2 su 33 coppie; statement dal vivo 65,5/73,6/78,0 su 3 coppie, rapporto
gamba1/gamba2 = 1,4992-1,5000). Legge di scala DICHIARATA `ATR(T)=ATR(H1)*sqrt(T/60)`,
ancorata al misurato, margine +-20%.

| TF | gamba 2 / spread sessione | verdetto |
|---|---|---|
| **M5** | **11,5 - 13,1x** | SCARTATO: **sfonda il pavimento DURO 13,3x**. Piu': 21 mesi a M5 = ~132.000 barre, sopra il tetto ~100.000 del tester |
| **M15** | **20,0 - 22,6x** | SCARTATO per costo (50-57% della frontiera). Sopra il duro |
| **M20** | **23,1 - 26,1x** | SCARTATO per costo |
| **M30** | **28,3 - 32,0x** | SCARTATO per costo sulla gamba 2 (71-80%). La gamba 1 (42,5-48,0x) passerebbe |
| H1 (la sedia) | 33,6 - 45,2x | NON scartato: la soglia 40x cade DENTRO la banda misurata => **C3 FRAGILE** |
| H2 / H3 / H4 | 56,6-64,0x / 69,3-78,3x / 80,0-90,5x | passano il costo |

> **Conseguenza, e va scritta perche' cambia come si legge la sedia: su U30USD H1
> non e' una scelta, e' il PAVIMENTO.** Sotto H1 nessun TF tiene il costo sulla
> gamba debole; sopra H1 nessun TF tiene la frequenza. La cella viva sta
> nell'unica casella che soddisfa entrambi i cancelli.
> **E le celle M15/M20/M30 della prova `COLLAUDO_EMADOW_05_tf_U30USD.txt` sono
> quindi INFORMATIVE E NON PROMUOVIBILI**: qualunque numero diano, sono escluse
> per costo in anticipo. Le celle che decidono sono H1 (sentinella) / H2 / H3 / H4.

### 🪦 `U30USD` a H4 — scartato per FREQUENZA, NON per edge
`risultati_archivio/EMA200/H4_OHLC/scan_ABTG_EMA200_H4_U30USD.csv`: **77 celle
positive su 85 vive**, best PF **3,0247**, DD 2,59%. **Ma Trades 15-82 su tutta la
finestra** = ~8-41 POSIZIONI al rapporto misurato ~2,0 => **molto sotto il
pavimento dei 150**. Scartato per frequenza, e l'edge resta agli atti.
(Verdetto d'epoca, `risultati_archivio/EMA200/ANALISI_EMA200.md` r.60-73: *"EMA200
e' un motore da H4, NON da H1"* -- vero sul PF, **falso sul calendario di ottobre**.)

### 🪦 `E50EUR` (EuroStoxx) — scartato su tutti e due i TF, col numero
- H1 OHLC: **0 celle positive su 88 vive**, best PF **0,7403**
- H4 OHLC: **0 celle positive su 81 vive**, best PF **0,9535**
**L'unico dei sette gemelli azionari che resta morto anche a H4.** Scartato.

### 🪦 `NASUSD` a H1 — scartato col numero
H1 OHLC **1/85** celle positive (best PF 1,0197); scan H1 di `risultati_prove/`
**2/83** (best PF 1,0285). Scartato a H1.
**BUCO DICHIARATO, NON SCARTATO: `NASUSD` a H4 non e' mai stato misurato** -- il
file `scan_ABTG_EMA200_H4_NASUSD.csv` **non esiste**, mentre i suoi due vicini
(`SPXUSD` 75/86, `U30USD` 77/85) a H4 girano. E' l'unico buco della matrice dei
gemelli di questo motore. **Non e' un morto: e' un non misurato.**

### 🪦 `771511`-`771515` (i cinque gemelli H4 in forward dal 01/08) — NON scartati, ma muti
**0 posizioni** in tutto lo statement 30/03 -> 11/09/2026 (`data/statements/trades_auto.csv`,
verificato oggi; concorda con `report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md`
r.176-180) e **assenti dal censimento `.chr` del 12/09**. Verdetto:
**[NON ANCORA MISURATO IN FORWARD]**, non "morti". Domanda aperta a Claudio: sono
ancora attaccati?

### 🔴 E UN CRITERIO FIRMATO CHE E' SCATTATO (non uno scarto: una revisione dovuta)
Corsia **MERITO** del 18/08 (*"famiglia a 20+ operazioni totali in perdita ->
revisione di tutte le sedie"*). Misurato oggi su `trades_auto.csv`, unita'
**(magic, simbolo)** e **POSIZIONI**, finestra 30/03 -> 11/09/2026:
`771531` U30USD **21 pos / -19,39** · `771501` D30EUR **6 / -77,31** · `771501`
XAUUSD **3 / +24,80** · `971501` XAUUSD **9 / -54,37** => **famiglia 39 posizioni,
netto -126,27. SCATTATO.**
- Tasso di vincita di campo **10/21 = 47,6%** contro **156/257 = 60,7%** del
  backtest: scarto **1,2 sigma** => **il campione NON da' un verdetto sul merito**
  (Emendamento B del 16/08).
- **RISCHIO: dentro.** DD forward sui chiusi **5,44 R = 2,72% del saldo** (R = 0,5%
  per gamba, `ABTG_EMA200.mq5` r.361) contro **7,21-7,83%** promessi; peggior
  giornata forward **-2,36 R = -1,18%** contro **-2,448%** del backtest.
  **Nessuna revisione di rischio.**

### ✅ COSE CHE NON SI RIPAGANO PIU' (misurate oggi, da file gia' in casa)
- **swap su U30USD = 0,00** su 21 posizioni, di cui **4 tenute oltre la mezzanotte**
  (una attraverso il weekend 14->16/08). Era `[NON MISURABILE]`.
- **commissione su U30USD = 0,00** su 21/21 della sedia stessa.
- **valore del punto = 0,8569-0,8628** unita'/punto/lotto, n=8, da `|P/L|/(dist x lotti)`:
  **0,861 confermato, 8,61 escluso** (chiude il conflitto `CONTRACT_SIZE` di R114).
- **max posizioni contemporanee = 2** e **rischio aperto massimo = 1,00% del saldo**,
  per COSTRUZIONE (`ABTG_EMA200.mq5` r.322 `if(HasPosition() || HasPending()) return;`
  + r.361 `riskPct = InpRiskPercent/nOrders`), confermato sul campo su n=39 posizioni.
  **Chiude il "buco strutturale del flottante" e riduce il buco B6 a <= 1,00% per
  questa sedia.**
- **la classe 226 NON tocca il PF**: 1,52365 per deal contro **1,52370** per
  posizione. Decide `n`, la frequenza e i cancelli di campione; **non** PF ne' DD.

---

## 12/09/2026 — SCARTI E RIPESCAGGI SULLA CACCIA ALLA **SECONDA SEDIA** (dossier `report/LA_SECONDA_SEDIA_2026-09-12.md`)

Metro: i cinque requisiti del CERTIFICATO DI MORTE + i cinque del piano di ottobre v2.
**Nessun backtest eseguito**: tutto ricontato sui CSV e sui per-trade d'archivio.
Unita' del campione: **POSIZIONI** (`position_id` distinti), non deal (classe 226).

### 🪦 `ABTG_PTE` GBPUSD H1 (`771332`, candidata R78) — SCARTATA COME SECONDA SEDIA, col numero
- **PF OOS 1,095** · **DD 9,87% @1%** · **n 477 DEAL** su OOS 2013.04→2026.06 (13 anni).
- 📋 **Modello 1 (OHLC) = SCREENING**, non un verdetto. Fonte: `risultati_archivio/REFERTO_ROUND78_SEDIA_VERA_FINESTRA_LUNGA.md` §2.
- 🎯 **A TICK REALI lo stesso motore fa n = 49** (IS 25 / OOS 49, finestra 2024.07.05→2026.06.30,
  `REFERTO_ROUND58_PTE_TICK_REALI.md`).
- 🚧 **CANCELLO: PF 1,095 < 1,10** su un campione che e' screening, **e** a tick il campione e' **49**,
  cioe' il **33%** del pavimento dei 150.
- 📌 E' anche il **contro-esempio che smonta il riframing "comanda la profondita' di storico"**:
  **ventisei anni di barre producono 49 operazioni di verdetto**, perche' i tick BCM partono dal
  **2024.07.05**. La sedia del duello **non e' toccata**: qui si scarta la sua candidatura al 2 seggio.

### 🪦 `ABTG_EMA200` **EURUSD H1 a DUE LATI (`AllowLong=1` E `AllowShort=1`)** — resta BOCCIATA (R29), e il numero e' quello
- **PF OOS 1,076-1,224** · **DD OOS 9,05-11,98% @1%** · **n 583-759 deal** · IS: PF 0,986-1,222, DD 8,36-10,15%.
- Fonte ricontata da me: `risultati_prove/ABTG_EMA200/ABTG_EMA200_EURUSD_{IS,OOS}_r29a.csv`
  (30 celle ciascuno, assi `InpOrder1Atr` x `InpOrder2Atr` x `InpTP_RR`).
- 🚧 **CANCELLO (R29, 12/08/2026): 7/30 PASS pieni, sparsi** — meta' regione manca `PF 1,10` (1,08-1,13),
  meta' sfonda `DD 10%` (10,0-12,0 @1%). Verdetto scritto: *"e' un no"*.

### ⏸️ `ABTG_EMA200` **EURUSD H1 LATO LONG DA SOLO** — **NON ANCORA MISURATO**, e va in coda all'imbuto
- 🎯 **Tick reali**, finestra UNICA 2024.01.01→2026.06.30, rischio 1%: **34 celle long, 34/34 in utile**,
  **33/34** con PF>=1,10 e n>=150 **deal**, **PF mediana 1,2742** (best 1,37120), **DD 6,22-8,25%**,
  n **530-754 deal**. Il lato **short** da solo: PF mediana 1,1070, DD **7,46-13,91%**. I due lati insieme:
  DD **9,53-13,91%** — **cioe' esattamente il difetto che R29 aveva visto**.
  Fonte: `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_EURUSD.csv`
  (143 righe; 94 celle vive, 94/94 in utile; le 49 celle a zero sono `AllowLong=0 E AllowShort=0`, cioe'
  **motore spento**, non spazio sterile).
- 🔴 **PERCHE' NON E' UN MORTO**: in **tutte e 30** le celle di R29 `InpAllowLong=1` **E**
  `InpAllowShort=1` (verificato da me nei CSV). **Il lato separato non ha MAI visto uno split IS/OOS.**
  E R29 scrive: *"si riapre SOLO con una tesi nuova, non con un ritocco delle soglie"* — **il LATO e' una
  tesi nuova**, ed e' la regola dei due lati firmata il 25/08.
- 🔴 **COSA MANCA, per nome**: (1) **n in POSIZIONI** — nessun per-trade EURUSD in archivio, il rapporto
  2,0117 e' misurato su U30USD e applicarlo e' una **derivazione**; (2) **nessuno split IS/OOS**;
  (3) `Optimization=2` = **GENETICO** (`valida_realtick.ps1` r.181) ⇒ **34 celle su 120 combinazioni long:
  le celle NON sono un campione uniforme della griglia**, e va detto ogni volta che si cita il 34/34;
  (4) i primi ~6 mesi della finestra (2024.01.01→2024.07.05) hanno tick **GENERATI dalle M1**, non veri.
- 🚧 **E UN CANCELLO CHE MORDE SUBITO — TF ESCLUSO PER COSTO, col numero**: stop `1,0 x ATR(H1)`
  ~ **18,0 pip** [DERIVATO da `ATR(14) M15 EURUSD = 9,00 pip` misurato, scalato `x sqrt(60/15)`],
  pedaggio all-in EURUSD **0,864 pip** [MISURATO: spread 0,4 + commissione 0,4636, verificato con
  `calcola_pedaggio_forex.py --autotest` tutto VERDE] ⇒ **20,8x**, cioe' **il 52% del pavimento di lavoro
  40x**. 🔴 **H1 ESCLUSO PER COSTO** (sopra il duro 13,3x). 🟢 **A H4: 36,0 pip / 0,864 = 41,7x, PASSA.**
- ➡️ **Costo per chiudere**: 30 celle x 2 finestre = **60 passate** = `T = 0,6 + 0,077 x 60` = **5,22 min**,
  piu' **2 passate** per il per-trade. **Non e' un ostacolo.** Va in coda, **mai in campo in automatico**.

### 🟠 `ABTG_EMA200` H4 su `AUDJPY` `GBPJPY` `GBPUSD` `200AUD` `SPXUSD` (`771511`-`771515`) — FUORI PER **ARITMETICA DEL CAMPIONE**, non per edge
- 🎯 Tick reali, finestra 2024.01.01→2026.06.30, rischio 1%, **lato per lato** (ricontato da me su
  `risultati_archivio/EMA200/realtick_H4/`, 8 file):

| simbolo | lato | celle in utile | con PF>=1,10 **e** n>=150 deal | PF mediana | DD |
|---|---|---:|---:|---:|---|
| `AUDJPY` | **LONG** | **24/24** | **21/24** | **1,8628** | 2,15-5,23% |
| `GBPJPY` | **LONG** | **32/32** | **24/32** | **1,7564** | 3,18-4,53% |
| `GBPUSD` | **SHORT** | **32/32** | **20/32** | **1,6760** | 3,58-5,86% |
| `GBPUSD` | LONG | 8/31 | 0/31 | **0,9644** | 3,70-7,60% |
| `200AUD` | LONG | 25/25 | 0/25 | 1,9515 | 1,39-2,56% |
| `SPXUSD` | LONG | 31/31 | 0/31 | 1,5914 | 1,96-3,79% |

- 🚧 **CANCELLO: n.** 138-200 **deal** su 30 mesi; col rapporto 2,0117 ⇒ **69-99 POSIZIONI**, cioe'
  **0,11-0,16 pos/giorno feriale**. 🔴 **150 posizioni PER FINESTRA a H4 non esistono nel banco a tick**,
  ne' oggi ne' il 30/09: e' aritmetica, non frequenza. E in **forward**: **0 posizioni** nello statement
  30/03→11/09.
- 🟢 **E CONFERMANO LA REGOLA DEI DUE LATI col numero**: su `GBPUSD` H4 lo **short** fa 32/32 in utile
  (PF mediana 1,676) e il **long** 8/31 (PF mediana 0,964). **Stesso simbolo, stesso TF, segno opposto.**
- ⚪ **E il costo su quei simboli NON e' misurato**: alla sonda del 17/08 `AUDJPY`, `GBPJPY`, `AUDUSD`,
  `CADJPY`, `USDNOK` leggono **`SpreadPt = 0`**, che vuol dire **nessun tick in quel momento**, non spread
  nullo. Commissione derivata: **AUDJPY 0,4534 pip** · **GBPJPY 0,8645 pip** (4,0 unita' base convertite
  con `AUD/EUR = 0,6137` e `GBP/EUR = 1,1703`, ricavati dalle commissioni misurate). Per 40x su AUDJPY
  serve stop **>= 38,1 pip** se lo spread e' 0,5. **R5 su questi simboli e' NON ANCORA MISURATO.**
- ➡️ **Verdetto: in coda all'imbuto per DOPO ottobre.** Non morti: **fuori per frequenza, col numero.**

### 🔴 `ABTG_Dow_Apertura_US` U30USD M5 LONG (`770202`) — SECONDO in graduatoria, ma **MERITO SOSPESO PER ARITMETICA**, e il piano ha un numero sbagliato
- 🎯 Tick reali, dep. 100.000, rischio 1%: **OOS PF 1,27013 · DD 4,3941% · IS PF 1,22247 · DD 5,6692%**
  (`risultati_prove/aperture_r47/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_r47c.csv`).
- 🔴 **n in POSIZIONI = 96 OOS e 56 IS, CONTATE** — **non 130**, come scrive
  `report/PIANO_CHALLENGE_OTTOBRE_v2.md` §2 riga 3. La riga del piano dice *"senza `InpTP1Pct`, quindi
  sono posizioni"*: **l'input di questa famiglia si chiama `InpTP1_ClosePct`** e nel preset vivo
  (`mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set`) vale **50,0**.
  Misura: `abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv` → **130 deal = 96 `position_id`**
  (rapporto **1,3542**) · `..._772507.csv` → **96 deal = 96** (rapporto **1,0000**).
- 🚧 **CANCELLO: 96 posizioni = 64% del pavimento, e NON COLMABILE.** Frequenza **0,362 pos/g**, sotto lo
  **0,57** che serve per avere 150 in OOS; e il banco a tick e' **tutta** la storia BCM dell'indice
  (2024.09.26, stato `COMPLETO`). **Nessun round lo chiude entro ottobre.**
- 🟢 Quello che invece **regge**: R1 pieno e verificato (R47c vs preset vivo: **80 input su 80**, solo
  `InpRiskPercent` e `InpMagic` differiscono) e il `.set` del 100k **esiste** (commit `d4fd83a`).
- 📌 **E sul Dow il parziale SERVE**, al contrario del DAX: `InpTP1_ClosePct` 50 → 0 fa PF OOS
  1,27013 → **1,25809** e DD 4,3941% → **5,4280%**, cioe' **peggio su tutti e due gli assi** (R47d).
  Sul DAX lo stesso cambio migliora tutti e due. **Due indici, stessa manopola, verso opposto: misurato.**

### 🚫 `Dow_Apertura` U30USD — IL **40/40 OOS** NON E' UTILIZZABILE PER `770202` (trappola disinnescata)
- `risultati_archivio/Dow_Apertura/dow_walkforward_{IS,OOS}.csv`: **Modello 4**, dep. 10.000,
  **OOS 40/40 celle in utile, PF 1,267-1,560 (mediana 1,376), DD max 8,70%, n 186-198**; IS 39/40.
  E' il numero piu' seducente dell'intero archivio.
- 🔴 **Misura un'ALTRA sedia.** Diff manopola per manopola contro il preset vivo di `770202`: **DODICI
  input differiscono**, fra cui `InpEntryMode` **0 (BREAKOUT)** contro **2 (RETEST)**, `InpRangeMinutes`
  **15** contro **35**, `InpBufferPoints` **200** contro **1000**, `InpAllowShort` **1** contro **false**,
  `InpTP1_ClosePct` **0** contro **50**, `InpTP1_R` **0,33-0,84** (l'asse) contro **1,0 (fuori dall'asse)**.
- 📌 **Classe 224 alla lettera.** Chi avesse portato *"il Dow ha un 40/40 fuori campione"* davanti a una
  firma avrebbe consegnato il numero di un'altra configurazione. **Il 40/40 resta valido: per il motore
  BREAKOUT a due lati con range di 15 minuti, che non e' una sedia del parco.**

### ✅ IL RIPESCAGGIO — `ABTG_DAX_Apertura_EU` su **F40EUR / E50EUR / E35EUR**: non esclusi, **MAI PROVATI**
- `risultati_archivio/DAX_Apertura/` contiene **5 CSV e sono tutti `D30EUR`**. Nessun file di questa EA
  porta `F40EUR` nel nome ne' nelle colonne. **Casella LIBERA, non provata.**
- 🎯 **Perche' conta**: e' la via piu' economica per chiudere **R3** sulla prima classificata
  (`0,728 + 0,728 = 1,44` contro un pavimento di **1,00 per FAMIGLIA**, firma 07/09). Parigi apre
  **09:00 IT = 08:00 ORA SERVER**, quindi `InpSessionHour=8` resta corretto senza toccarlo.
- 📄 File prova scritto oggi e passato da **tutti e due** i cancelli:
  `backtest_pipeline/prove/R138a_gemello_F40EUR_770101.txt` — **4 passate = 0,91 min**.
- 🟢 ✏️ **BUCO CHIUSO IL 22-23/09/2026 — LA TABELLA E' IN REPO, E IL SUO PERCORSO E' QUESTO:**
  **`backtest_pipeline/risultati_archivio/studio_apertura/Studio_<SIMBOLO>_RIEPILOGO.csv`** — **otto
  file**, uno per indice (`U30USD` `D30EUR` `NASUSD` `SPXUSD` `E50EUR` `E35EUR` `F40EUR` `100GBP`),
  piu' gli otto CSV per-trade, committati il **03/08/2026**. Qui c'era scritto *«la sua tabella per
  simbolo non l'ho trovata nel repo»*, e lo stesso testo sta in
  `backtest_pipeline/prove/R138a_gemello_F40EUR_770101.txt` rr.56-60: **va corretto anche li'.**
  ✏️ **E due dettagli della vecchia riga erano sbagliati**: le rotture sono **3.302**, non «~3.500»
  (somma della riga *«TUTTI i breakout»* degli otto file); e il modello **NON e' a tick reali, e'
  `Modello 1` = OHLC M1** (`studio_apertura.ps1` r.93) — quindi e' **screening**, e la cosa
  utilizzabile e' la **classifica**, non il livello.
- 🔴 **E LA RISPOSTA ALLA DOMANDA CHE IL BUCO PONEVA E' «SI»: `F40EUR` HA GIA' UN NUMERO, ED E'
  NEGATIVO** — **−0,056 R/trade** sul cieco (n 443), **−0,054** solo LONG, **−0,109** col filtro H4.
  👉 **Quindi `R138a` E' un ritest di un caduto, e serve la tesi nuova.** 🟢 **La tesi c'e', ed e'
  quella gia' scritta qui sopra**: la cella viva non e' la **rottura cieca** che la FASE A misura, e'
  un **RETEST con offset**, geometria che la FASE A non contempla — e che su `U30USD` a tick reali
  vale **+0,25 di PF contro il breakout** (R197A, vedi la CONCLUSIONE APERTURA riscritta). **La
  condizione «va cercata PRIMA di lanciare» e' soddisfatta: cercata, trovata, letta.**
- 🔴 **E LA STESSA LETTURA CHIUDE UN'ALTRA RIGA DI QUESTA SEZIONE**: il titolo qui sopra dice
  *«`E50EUR` / `E35EUR`: non esclusi, MAI PROVATI. Casella LIBERA»*. **Non e' una casella libera.**
  La FASE A li da' **tutti e tre negativi** — `F40EUR` **−0,056** · `E50EUR` **−0,048** ·
  `E35EUR` **−0,048** — e `SPXUSD` **−0,017**. **Provati in OHLC e negativi**: per la regola della
  seconda caccia (19/08) rifarli chiede una **tesi nuova**, che e' la stessa del RETEST.
- ⚠️ **E un secondo condizionale, scritto prima della corsa**: `D30EUR` e `F40EUR` **aprono allo stesso
  minuto**. Se la famiglia arrivasse a 1,44 pos/g sommando due sedie che fanno **la stessa operazione nello
  stesso momento**, la frequenza sarebbe doppia e la **diversificazione ZERO**. Il verdetto di R138a e'
  **condizionato** alla misura della sovrapposizione dei giorni operativi (strumenti gia' in casa:
  `sovrapposizione_sedie.py`, `chi_va_con_chi.py`).

### 🟢 E IL CONTRARIO DI UNO SCARTO: `ABTG_DAX_Apertura_EU` D30EUR M5 LONG (`770101`) e' la **PRIMA CLASSIFICATA** al secondo seggio
- **n in POSIZIONI: OOS 193 · IS 132, CONTATE** (`abtg_trades_..._772501.csv` → 270 deal = 193 `position_id`,
  rapporto **1,3990**; `..._772503.csv` → 193 deal = 193, rapporto **1,0000**: **stesse entrate, stesse 193
  posizioni**, due configurazioni a **una** manopola di distanza). 🟢 **OOS sopra il pavimento dei 150.**
- 🎯 **DD sul banco della challenge: 7,2328% a rischio 1,0% su deposito 100.000 EUR, TICK REALI** — che il
  piano v2 dichiara `[NON MISURATO]`. **Il deposito e' dedotto dai P/L, non dai commenti**: 18.029,58 / 193
  posizioni a rischio 1% = **0,0934 R/posizione** se il banco e' 100.000 (plausibile: `E alta` di casa =
  0,075R) e **0,934 R** se e' 10.000 (assurdo). Controprova incrociata: R119, a 0,65%, da'
  1.103,31 / 193 = **0,0879 R** ⇒ **lo stesso edge su due banchi diversi**, scarto 6,3%.
- 🟡 **R5: 33,0x sulla geometria viva** (56,1 idx / spread mediano 1,70 dell'ora modale 08, misurato su
  **30.974.789 tick**), 42,3x sullo stop pieno (71,9 idx, n=7 gambe vere), **26,6x al p95**. Pavimento di
  lavoro 40x **non passato**; pavimento **DURO 13,3x passato x2,5** ⇒ **raccomandazione, non spegnimento**.
- 🟠 **R3: 0,728 pos/giorno feriale** (non 0,97: quello conta i DEAL), contro 1,00 per famiglia.
- 🎁 **E in archivio c'e' gia' una cella che la batte con UNA SOLA MANOPOLA, mai portata in campo**:
  `InpTP1_ClosePct` 50 → 0 ⇒ **PF OOS 1,39709 → 1,49140 · DD OOS 7,2328% → 6,2719% · profitto +31% · a
  parita' di 193 posizioni**; e in IS **PF 1,12634 → 1,18323 · DD 5,4362% → 4,9576% · profitto +47%**.
  **Meglio su tutti e due gli assi in tutte e due le finestre.** Trovata tre volte da tre letture
  indipendenti (R120 del 09/09, il setaccio del 12/09, e oggi). **Non manca una misura: manca una FIRMA.**
  ⚠️ Il vantaggio di PF in OOS (**+0,094**) e' **appena sotto** la soglia di rumore di 0,10 usata in casa
  per una cella isolata: il verdetto non poggia sul PF da solo, poggia su PF **e** DD **e** profitto che
  migliorano insieme su due finestre a campione costante.
- 📄 Round proposti, **tutti e due i cancelli verdi**: `prove/R137c_parziale_770101_D30EUR.txt` (4 passate,
  **0,91 min**, il cancello del gruppo) · `R137a_floorstop_allarga_770101_D30EUR.txt` (14, **1,68 min**) ·
  `R137b_floorstop_salta_770101_D30EUR.txt` (14, **1,68 min**) · `R138a_gemello_F40EUR_770101.txt` (4,
  **0,91 min**). **Totale 36 passate = 5,17 min** col metro `T = 0,6 + 0,077 x passate` per round.

---

## 12/09/2026 — GLI SCARTI CHE NON AVEVANO IL NUMERO, ADESSO CE L'HANNO (dossier `report/I_BOCCIATI_HANNO_UN_CERTIFICATO_2026-09-12.md`)

Censimento **voce per voce** di tutti i verdetti negativi di questo registro contro il
**CERTIFICATO DI MORTE** (09/09). **Sola lettura d'archivio, nessun backtest lanciato,
nessun EA / preset / sedia / `CODA.txt` toccati.** Qui vanno solo le righe che **aggiungono
un numero** o **correggono** una riga esistente: il resto sta nel dossier.

### 🔢 IL CONTO, prima di tutto — e falsifica un'ipotesi comoda
Contando per **RIGA** (i cinque termini `senza edge|bocciat|scartat|MORTO|archiviat`) questo
file da' **89 righe negative, di cui 12 con "PF"** — riprodotto al numero esatto. Ma una
**riga** non e' una **voce**: contando per VOCE (motore x simbolo x TF) sono **72**, e
**52 su 72 hanno un PF** (registro **o** archivio). 🔴 **Quindi "77 bocciati senza PF" e'
FALSO: i senza-PF sono 20.** Il PF non stava sulla riga accanto: stava **nel CSV accanto**.
🔴 **Il buco vero e' un altro: 47 voci su 72 non hanno il certificato completo, e in 38 casi
su 47 la voce che manca e' la 3 — LA GESTIONE DELL'USCITA.**

### 🪦 DIECI SCARTI COL NUMERO, ricalcolato oggi dai CSV grezzi (costo: zero passate)

| scarto | PF | DD | n (deal) | cancello | file |
|---|---:|---:|---:|---|---|
| `MaxMinNotte` **100GBP** | best **0,6717** | **16,03%** | 82 | **0/54 celle positive** + DD oltre il muro | `risultati_archivio/MaxMinNotte/efe054b5-valid_MaxMin_100GBP.csv` |
| `MaxMinNotte` **E50EUR** | best **0,8398** | **13,90%** | 80 | **0/54** + DD | `.../8eefb007-valid_MaxMin_E50EUR.csv` |
| `MaxMinNotte` **F40EUR** | best **0,9985** | **10,12%** | 112 | **0/54** + DD al muro | `.../4528c79b-valid_MaxMin_F40EUR.csv` |
| `SupRev` **100GBP H1** | best **0,8822** | **4,55%** | 160 | **0/27 celle positive** | `.../SupRev_nuovi_indici/c016704b-valid_SupRevScr_100GBP_H1.csv` |
| `SupRev` 100GBP H4 | best 1,2891 | 2,04% | 48 | 5/27 positive, n 48 -> merito sospeso, e la gamba H1 e' 0/27 | `.../2ab6d7d9-...` |
| `SupRev` 225JPY H1 | best 2,1574 | 0,22% | 75 | 🔴 **scartato per TAGLIA DEL CONTRATTO**, non per edge (profitto ~50 EUR, lotto JPY minuscolo) | `.../9d856486-...` |
| `SupRev` 225JPY H4 | best 2,1626 | 0,12% | 27 | idem | `.../cfe6ccec-...` |
| `EMA200` **E50EUR H1** | best 0,7403 | **7,12%** | 210 (max 467) | **0/88 celle positive** | `.../EMA200/H1_OHLC/scan_..._E50EUR.csv` |
| `EMA200` **E50EUR H4** | best 0,9535 | **4,64%** | 81 (max 150) | **0/81 celle positive** | `.../EMA200/H4_OHLC/scan_..._E50EUR.csv` |
| `EMA200` **NASUSD H1** | best 1,0197 | **5,74%** | 255 (max 594) | **1/85 celle positive** | `.../EMA200/H1_OHLC/scan_..._NASUSD.csv` |
| `Live5m_v2` D30EUR | best **1,0430** | **9,10%** | 239 | 8/32 positive; e M5 sugli indici e' **escluso PER COSTO** (11,5-13,1x contro il duro 13,3x) | `.../Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` |

> 🟢 **Quattro di questi RIPRODUCONO al centesimo numeri scritti da un'altra sessione** (SupRev
> 100GBP H4, SupRev 225JPY H1 e H4, Live5m_v2): e' il controllo chiesto dalla regola del
> 10/09 — verificare contro i numeri veri di qualcun altro, non contro valori che tornano.
> ⚠️ **E i tre `EMA200`/`SupRev` a zero celle positive sono OHLC = SCREENING.** Qui la
> direzione dell'errore aiuta: **l'OHLC e' OTTIMISTA**, e un modello ottimista che da' **0
> celle positive su 169 letture** (E50EUR H1+H4) non sta nascondendo un edge. **E' l'unico
> caso in cui uno zero OHLC vale come chiusura, ed e' un'eccezione, non la regola.**

### ✏️ DUE ERRATA a righe di questo registro

1. **r.2296 (`EMA200 U30USD H4`) accoppia due celle diverse.** Dice *"best PF 3,0247,
   DD 2,59%"*. Sul CSV la cella a **PF 3,02473** ha **DD 2,4575** e **32 deal**; il **2,5927**
   e' della cella **successiva** (PF 2,81599, 34 deal). Non sposta il verdetto, ma e' la stessa
   classe del *"PF senza l'aggettivo davanti"*: due numeri di due celle su una riga sola.
2. **r.459 (`MaxMinNotte` CAC) dice "max ~1.0".** Il numero esatto e' **0,9985**, cioe'
   **sotto** 1, non "a pari". Con DD **10,12%** sulla cella migliore.

### 🔴 E UNA RI-ETICHETTATURA CHE CAMBIA COSA SI DEVE FARE — `EMA200 U30USD H4`
La r.2292 dice *"scartato per FREQUENZA, NON per edge"* e motiva con *"Trades 15-82 = ~8-41
posizioni => molto sotto il pavimento dei 150"*. 🛑 **Quello non e' il pavimento di frequenza:
e' la regola del CAMPIONE** (Emendamento A). Lo dice
`report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` §0 regola 4: *"un candidato bocciato perche' il
campione IS non arriva a 150 operazioni NON e' un caso di questo referto"*.
👉 **La differenza conta perche' cambia la cura:** il pavimento di **FREQUENZA** si chiude
**aggiungendo SIMBOLI** (firma 07/09); la regola del **CAMPIONE** si chiude **SOLO aggiungendo
STORICO**. Sul Dow lo storico e' **21 mesi**: quella porta resta chiusa, e nessun simbolo in
piu' la apre. ✅ Numeri ricontati oggi: **77 celle positive su 85**, bestPF **3,02473**,
DD **2,4575%**, **32 deal** (82 il massimo del file) = **16-41 posizioni** al fattore
misurato 2,0117. **L'edge c'e', il campione no.**
➡️ **E il conto vero degli scarti "per sola frequenza" in questo registro e' 1, non 47**: le
altre 46 righe che citano la frequenza sono titoli di dossier, descrizioni di cancelli e
conteggi di segnali. (`M0PB` era gia' declassato il 09/09; su `IBRetest` la frequenza e' il
**secondo** motivo, e il primo — **C0**, PF famiglia 0,7798 su n=209 OOS a campione pieno —
regge da solo.)

### 🔥 IL BUCO PIU' GROSSO TROVATO OGGI — `ABTG_EMA200` a H4 non ha MAI VISTO UN FUORI CAMPIONE
Non e' uno scarto: e' un motore **mai portato a termine**, e per questo va scritto qui.
Le 135 celle per simbolo di `risultati_archivio/EMA200/realtick_H4/` (8 simboli, **tick
reali**, banco `ini/ABTG_EMA200.ini`: Model=4, 2024.01.01 -> 2026.06.30) vengono da **UNA
FINESTRA SOLA, ottimizzata intera**. **Nel repo non esiste nessuna lettura IS/OOS di questo
motore a H4, su nessuno degli otto simboli.** E quello che c'e' non e' poco:

| simbolo | celle a DUE LATI | positive | PF min-max | DD min-max | deal (~posizioni) |
|---|---:|---:|---|---|---|
| **AUDJPY** | 28 | **28 / 28** | 1,076 - 1,845 | 2,889 - 9,464% | 255-347 (~128-174) |
| **GBPUSD** | 24 | **24 / 24** | 1,147 - 1,348 | 5,783 - 9,223% | 274-380 (~137-190) |

🔴 **CLASSE 226, nel verso sfavorevole: ne abbiamo MENO di quante sembrava.** Al fattore
**misurato 2,0117** quei "255-347 trade" sono **128-174 POSIZIONI** su UNA finestra, cioe'
sotto i 150 anche senza split. **Ed e' questo, non il PF, il motivo per cui cinque sedie
(`771511`-`771515`) stanno in campo senza un verdetto. Il numero non era mai stato scritto.**
🔬 **Contro-esempio costruito prima di consegnare** (ipotesi alternativa: *"e' la deriva del
carry, non il motore"*): su AUDJPY il lato SHORT fa **16 positive su 32, PF mediano 0,991** —
**centrato sullo zero, non rosso** (se fosse deriva sarebbe rosso come `SuperWave DOW short`
PF OOS 0,429). E su **GBPUSD il lato forte e' lo SHORT** (best PF 2,066) mentre su AUDJPY e'
il **LONG**: stesso motore, lato opposto. **La deriva non e' esclusa ma non e' dimostrata**, e
il discriminante sono le celle a **due lati**, che una deriva monodirezionale non puo'
raccogliere. Falsificatore pre-dichiarato nei file prova.
🚨 **E un fatto di campo che si chiude a mano in due minuti:** le cinque sedie H4 hanno
**ZERO posizioni** dal 01/08 (`data/statements/trades_auto.csv`), contro un'attesa aggregata
di **~20** (celle dei preset, 2,8-3,6 posizioni/mese l'una). Con lambda ~20 la probabilita' di
vedere zero e' **~2 x 10⁻⁹**: **non e' sfortuna.** Domanda aperta a Claudio, terminale MT5
**50503392** (`BCM Markets MT5 Terminal`), grafici AUDJPY/GBPJPY/GBPUSD/200AUD/SPXUSD a H4:
**quei cinque EA sono ancora attaccati?**
⚠️ Rilievo tecnico: il preset `mql5/Presets/ABTG_EMA200_FW_AUDJPY_H4.set` gira
`InpOrder2Atr=0,35`, un valore che **NON esiste** fra quelli dell'asse d'archivio (0,2 / 0,3 /
0,4 / 0,5 / 0,6). **E' un'interpolazione, non una cella con un numero.**

### 🗂️ FiboH4_Multi — il "0/8" RICONTATO: 96 righe su 96 sul basket
Estensione della rettifica del 21/08, con il conteggio completo: la colonna `InpSymbols` vale
`GBPUSD;USDJPY;EURUSD` in **96 righe su 96** dei 16 CSV. L'ottavo file (XAUUSD) differisce
(IS -536,71 / OOS +299,89, n 67/70) **solo per la cadenza delle barre del grafico**: `OnTick`
e' guidato dal simbolo del grafico, il basket e' lo stesso (sorgente r.278-287, ripiego su
`_Symbol` solo a lista VUOTA). Certificato: **2 voci su 5** (PF 0,594-0,697 IS / 0,783-1,281
OOS; n 63-83 deal; DD 3,12-7,55%). Mancano **3 (uscita: tutti i parametri d'uscita pinnati in
96 righe su 96), 4 (ZERO simboli singoli, mai) e 5 (InpTF=16388 in 96 righe su 96)**.
➡️ **Verdetto: NON ANCORA MISURATO.** File prova pronto: `prove/R139c_FIBOH4_GBPUSD_unsimbolo.txt`.

### 📦 TRE FILE PROVA NUOVI, cancello deterministico PASSATO (`controlla_prova.py`, exit 0)
`prove/R139a_EMA200_AUDJPY_H4_LS.txt` (4 celle) · `prove/R139b_EMA200_GBPUSD_H4_LS.txt`
(4 celle) · `prove/R139c_FIBOH4_GBPUSD_unsimbolo.txt` (3 celle). **11 celle, 22 passate,
T = 0,6 + 0,077 x 22 = 2,29 min.** Magic vergini 771560 / 771561 / 772060. ASCII puro
verificato con `python3`. 🚨 **Tutti e tre a `-Modello 1` = OHLC M1** (NON tick), e il motivo
e' misurato: il pavimento **tick** del forex e' **2024.07.05**, quindi su 16,5-27,5 anni i
tick **non esistono** — classe 273. **Nessuno dei tre e' in `CODA.txt`: non e' stata toccata.**

---

## CACCIA TF BASSO (12/09/2026, M5/M15/M30 con STOP STRUTTURALE) — 0 EA esterni promossi, 1 sorgente letto e scartato col numero, 1 REGOLA NUOVA

Dossier completo: `report/CACCIA_TF_BASSO_2026-09-12.md`. Il resto sta li', non
si duplica. **ZERO EA scritti o toccati, ZERO backtest eseguiti, ZERO righe in
`CODA.txt`.** Fonte dei numeri: sonde
`caccia_strategie/biblioteca/sonde_esterne/sonda_cono_{ampiezza,rumore}_dax.py`
su **1.266.562 barre M1** GRXEUR (DAX cash histdata), **1.493 sedute 2013-2018**.

- 🔑 **REGOLA NUOVA — L'ANCORA UNICA. Lo stop strutturalmente largo NON compra
  edge: lo compra solo se il TARGET nasce dalla STESSA struttura dello stop.**
  `E_netta(R) = (edge_punti - costo_punti) / stop_punti`: il costo e' fisso,
  quindi allargare lo stop **divide** l'edge in R. Misurato oggi sul cono di
  rumore per terzili di ampiezza dello stop: stop da **34,6 a 94,7 punti**
  (x2,7) ed edge lordo da **+3,07 a +3,31 punti** (+7,8%) -> **E in R da
  +0,0542 a +0,0118, diviso 4,6**. Contro-prova a favore: `ABTG_DAX_Apertura_EU`
  (770101, VIVA) ha `tp = entry + dist*TpTotalR()` con `dist` = **lo stop
  stesso** (r.1070) e stop dall'estremo opposto del range (`ABTG_SL_RANGE`,
  r.236) -> **stessa ancora, E in R invariante**. E' la seconda misura
  indipendente dopo M31 del 05/09 (_"l'edge e' una quantita' fissa di ATR"_).
  👉 **Da oggi ogni scheda di caccia su TF basso porta la colonna "ANCORA
  UNICA?" accanto a `stop/spread`. Senza quella colonna, `stop/spread` e' un
  numero cosmetico.**
- 📏 **MISURA NUOVA — lo stop strutturale del CONO DI RUMORE sul DAX (M18).**
  Ampiezza intera del cono (= stop in modo `SL_CONO`), punti indice: mediana
  **89,1** su 25.239 controlli a orologio -> **52,4x** lo spread MISURATO
  (1,70, 30.974.789 tick); **0,4%** sotto il pavimento DURO 13,3x; allo stress
  p95 (2,70) resta **36,3x**, a spread +100% resta **28,9x**. Cresce con l'ora:
  **27,8x alle 08:30 -> 76,9x alle 16:30 server**. 🟢 **Su M30 la frontiera del
  costo NON e' il collo di bottiglia.**
- 🔴 **E L'EDGE DEL CONO, sulla geometria FEDELE al sorgente (gap adjustment
  `baseUp=max(open,close_pre)`, `ABTG_OutOfNoise.mq5` r.697-700): informazione
  direzionale +0,0012 R = ZERO.** n=1012, 0,678 op/gg, E netta -0,0131 R
  (t=-0,49) contro controllo **APPAIATO** (stessa barra, stessa distanza, lato
  opposto) -0,0156 R. Senza gap adjustment (variante **NON fedele**) +0,0243 R
  con t=+0,86, comunque sotto il cancello H8 di **0,075 R**.
  ⚠️ **Non e' un certificato di morte**: (a) OHLC M1, non tick reali; (b) un
  solo primo-segnale per seduta contro i 2 ammessi; (c) 🔴 **la VWAP non e'
  calcolabile** su quei file (colonna volume = 0) e il trailing su VWAP e'
  l'uscita che la fonte e la letteratura di seguito dichiarano decisiva;
  (d) DAX cash 2013-2018, non il CFD BCM 2024-2026. **Verdetto: NON ANCORA
  MISURATO.**
- 🪦 **SCARTO COL NUMERO — `Exp_DarvasBoxes_System`** (Code Base **15907**,
  `GODZILLA`, 2016.10.10, NOLICENSE, **sorgente scaricato e letto: 144 righe,
  16 input**). `input int StopLoss_=1000` / `TakeProfit_=2000` **punti MT5
  FISSI** (r.29-30): su D30EUR 1000 punti MT5 = **10 punti indice** ->
  **5,9x** lo spread = **44% del pavimento DURO 13,3x**. **Bocciato per
  COSTO.** In piu': `MM=0.1` con `MMMode=LOT` = **lotto fisso** (r.27-28) e
  l'enum `MarginMode` espone **`LOSSFREEMARGIN`/`LOSSBALANCE`** (r.20-21) =
  taglia in funzione delle perdite. 🟢 A suo credito: `SignalBar=1` = decide su
  barra chiusa (nessun repaint) e l'indicatore e' **allegato**.
- 🗺️ **Le cinque geometrie di sessione confermate PIENE** (mappa di
  `CACCIA_NOTTE_2026-09-12.md` §2.1): 72 strategie TradingView e ~1.642 titoli
  Code Base sfogliati oggi **cadono tutte** su rottura (~210 celle) · fade
  (R42 0/24+0/24) · falsa rottura (BreakinBox PF 1,007 DD 24,1%) · sweep+reclaim
  (R95 0/30) · rottura-retest-rirottura (IBRetest PF 0,7798 su n=344). E le
  classi a **stop ATR del TF corrente** sono fuori mandato per costruzione
  (su U30USD **11,5-13,1x a M5**, **20,0-22,6x a M15**).
- 📐 **CHIUSA DI PASSAGGIO la riga M23 di `PIANO_PROP.md`** (*"conversione punti
  su DAX: 100 come US? da VERIFICARE"*): e' **MISURATA a 100**, cioe' 1 punto
  indice = 100 punti MT5 anche su D30EUR -- `report/CANCELLO_COSTO_FLOTTA_
  2026-09-10.md` r.290 (D30EUR/U30USD/NASUSD, 2 decimali, `_Point = 0,01`).
- 📦 **DUE FILE PROVA NUOVI, cancello deterministico PASSATO** (`controlla_prova.py`,
  `ESITO: OK`, 0 problemi): `prove/NOISE_M30_D30EUR_ancora.txt` (magic **773810**
  vergine) e `prove/NOISE_M30_NASUSD_gemello.txt` (magic **773820** vergine).
  Un solo asse: **`InpSlMode` CONO(0) contro ATR(1)**, il modo `SL_CONO` che
  esiste nel sorgente (r.143 enum, r.814-815) e **non e' mai stato girato**.
  4 celle, **8 passate, T = 1,22 minuti**. Da girare a **tick reali
  (`-Modello 4`)**. Tre uscite dichiarate, compresa **C: n=0 o catena rotta NON
  e' una risposta** -> si leggono le colonne di diagnostica v1.02 e si riapre il
  baco, non si cambia parametro.
- 🚧 **Buchi dichiarati:** **SSRN 403** su `4824172` (Zarattini, il paper della
  fonte) **e** su `5095349` (Maroy, *"Improvements to Intraday Momentum
  Strategies..."*, che secondo l'indice di ricerca dichiara **VWAP e "ladder"**
  come le uscite migliori -- cioe' proprio il pezzo non misurabile dalle mie
  sonde): **nessuno dei due PDF e' stato aperto**, e sono i due documenti piu'
  utili al candidato. 🙋 **Claudio li scarica da un browser normale in due
  minuti.** Piu': **arXiv API 429 -> 503** (non raggiunta OGGI, **non e' un
  404**), **api.github.com 403 strutturale**, **researchgate e
  alexandria.unisg.ch 000**, **quantseeker/quantitativo/quantmacro/
  quantifiedstrategies EGRESS_BLOCKED**, **Quantpedia non tentata**, ampiezza
  del cono su **NASUSD e U30USD [NON MISURATA]** (non estrapolata).

---

## 🪦 12/09/2026 — LA BANDA BASSA (M5 / M15 / M30): scarti col numero
**Dossier completo: `report/LA_BANDA_BASSA_2026-09-12.md`.** Scavo di **sola lettura**
d'archivio + lettura di sorgente. **Nessun backtest lanciato, `CODA.txt` non toccata.**
Nasce dalla richiesta di Claudio del 12/09: *"Ma sono tutti in h1 o h4. Dobbiamo
trovare m5, 15 e 30 x le prop"*.

### 🔴 CORREZIONE DI UN FATTO, prima degli scarti
*"Di M30 non esiste niente"* e' **falso sull'archivio** e vero solo sulla flotta e
sulla colonna `@PERIODO` della coda. Misurato oggi:
- **flotta viva (42 sedie)**: `M1 1 · M5 7 · M15 4 · **M30 0** · H1 22 · H2 2 · H4 6`;
- **coda di stanotte (28 round, per `@PERIODO`)**: `H1 16 · M5 6 · H4 5 · M15 1 · M30 0`
  -- **ma `COLLAUDO_EMADOW_05_tf_U30USD.txt` r.126 porta `InpTF=16385||15||1||16388||Y`
  = M15/M20/M30/H1/H2/H3/H4**, quindi M30 in coda **c'e'**, dentro un file
  etichettato `@PERIODO H1`;
- **archivio**: **168 CSV con una cella M30**, di cui **68 a TICK REALI**, su **12
  simboli** e **8 famiglie**, piu' **34 coppie IS/OOS complete** a tick.
👉 **La causa del falso zero e' che su 8 famiglie il TF operativo e' `InpTF`, non il
grafico** (`SuperWave` r.52 · `EMA200` r.49 · `BreakingBand` r.269 · `PTE` r.51 ·
`CostToCost` r.149 · `EasyTrend` r.179 · `GapFill` r.128 · i `SupRev_*_Ott`).
**Un censimento fatto su `@PERIODO` non vede la banda bassa.**

### 🪦 SCARTO 1 — LA BANDA M30 E M20 SUI MOTORI A STOP SCALANTE (8 famiglie)
**34 coppie IS/OOS a TICK REALI con la cella M30: `PF >= 1,10` in ENTRAMBE le
finestre in 0 casi su 34. A M20 anche 0 su 34.** Negli **stessi** 34 sweep, a H1
sono **4** e a H4 sono **9** (contro-esempio costruito: l'alternativa *"quelle 34
corse sono una famiglia debole"* prevedeva zero anche a H1/H4 -- **falsificata**).
🔴 **Il campione NON e' la scusa:** **24 su 34** hanno `n >= 150` in OOS e il piu'
grosso fa **n = 1.151** (`EMA200` GBPUSD M30 OOS).
E il **DD OOS mediano sale MONOTONO scendendo**: H4 **2,74%** -> H1 **4,82%** ->
M30 **6,61%** -> M15 **8,63%** -> M20 **8,90%**.
Famiglie coperte, per nome: `SuperWave` · `WOL` · `EMA200` · `SupertrendInvert` ·
`SupertrendReversal` · i cinque `SupRev_*_Ottimizzato` · `EMA200_Ottimizzato` ·
`SuperWave_*_Ottimizzato`. (Piu' `BreakingBand`, chiusa a parte da **R111**.)
⚠️ **Limite dichiarato, e mi corregge:** in quelle 34 coppie le celle con
`PF >= 1,10` **E** `n >= 150` in entrambe le finestre sono **0 a TUTTI i TF**. Quindi
il verdetto onesto e' *"a M30 il merito e' misurato e negativo su 34 serie"*, **non**
*"a M30 non esiste un motore"*.

### 🪦 SCARTO 2 — le celle M30/M15 singole, col PF, il DD, l'n e il cancello
| candidato | TF | n (IS/OOS) | PF (IS/OOS) | DD (IS/OOS) | rischio | cancello | verdetto |
|---|---|---|---|---|---|---|---|
| `ABTG_SupertrendReversal_Multi_Ott` XAUUSD | M30 | 257 / 427 (**deal**) | **1,25637 / 1,08718** | 10,66% / 22,06% | **2,0%** | 🔴 **PICCO, non altopiano**: vicini sullo stesso asse **M20 IS 0,709** e **H1 IS 0,984** · PF OOS **1,087 < 1,10** | 🪦 **scartata per REGOLA DI SELEZIONE.** 🟢 **NON per rischio**: 22,06% e' a 2,0%, a 0,65% fa **~7,17%** [DERIV. lineare] |
| `ABTG_SupertrendReversal_Multi_Ott` XAUUSD | **M15** | 511 / 882 | 0,75293 / 1,14283 | **42,58%** / 18,48% | 2,0% | 🔴 **IS in perdita** · DD IS **42,58% = 13,84% a 0,65%** [DERIV.] | 🪦 **scartata per RISCHIO** |
| `ABTG_EMA200_Ottimizzato` XAUUSD | M30 | 460 / 674 | 0,78220 / 1,10258 | 16,91% / 9,68% | 1,0% | 🔴 IS in perdita · DD IS 16,91% > 10% | 🪦 scartata |
| `ABTG_SupRev_DOW_H4_Ott` U30USD | M30 | 163 / 362 | 0,66190 / 1,36960 | 7,78% / 5,24% | 1,0% | 🔴 IS in perdita (merito incoerente fra finestre) | 🪦 scartata |
| `ABTG_SuperWave` U30USD | M30 | 122 / 290 | 1,20400 / 0,93050 | 4,79% / 8,48% | 1,0% | 🔴 OOS in perdita · n IS 122 < 150 | 🪦 scartata |
| `ABTG_SupRev_DAX_H1_Ott` D30EUR | M30 | 181 / 328 | 0,60690 / 0,98750 | 12,00% / 9,41% | 1,0% | 🔴 entrambe sotto 1,10 · DD IS 12,00% > 10% | 🪦 scartata |
| `ABTG_SupRev_NAS_H1_Ott` NASUSD | M30 | 84 / 185 | 0,78190 / 0,86810 | 3,74% / 4,21% | 1,0% | 🔴 entrambe sotto 1,10 | 🪦 scartata |
| `ABTG_EMA200` XAUUSD/GBPUSD/AUDJPY/GBPJPY/SPXUSD | M30 | 415-1.151 | **0 su 5** con PF >= 1,10 in entrambe | fino a 37,72% | 1,0% | 🔴 merito, su campione **abbondante** | 🪦 scartate |

### 🪦 SCARTO 3 — ESCLUSI PER COSTO A M30, col numero
Pedaggio **all-in**: sugli indici e sull'oro e' **lo spread** (commissione **0,0000
MISURATA**, n=302 deal); sul forex si aggiunge **0,004% del nozionale in valuta
base** (su GBPUSD la commissione e' il **73,1%** del pedaggio). Due leggi di scala,
**tenute separate e non mediate**: `k = 0,50` **ASSUNTA** (radice del tempo) e
`k = 0,968` **MISURATA** sull'unica coppia a due TF dello stesso codice e simbolo che
possediamo (`SuperWave` U30USD: **77,1 idx a H1** n=4 contro **295,5 a H4** n=8,
geometria identica riga per riga -- la radice del tempo **sovrastima del 92%**).

`stop/spread` a **M30** con `k = 0,968` (prudente): `EMA200` U30USD **28,1x** ·
`EasyTrend` GBPUSD **24,1x** · `EMA200_Ott` XAUUSD **21,7x** · `SuperWave`
U30USD **19,7x** · `SupertrendRev_Ott` XAUUSD **18,1x** · `PTE` U30USD **16,6x** ·
`SupRev_NAS_H1` NASUSD **14,7x** · `SupRev_DAX_H4` D30EUR **13,4x** ·
`BreakingBand` EURUSD **13,1x** · `SupertrendReversal` 225JPY **3,6x** ·
`CostToCost` EURJPY **3,4x** e GBPCAD **2,7x**.
🔴 **ZERO dei 14 motori di classe S misurati passa il 40x a M30 col `k` misurato.**
Gli ultimi tre **sfondano anche il pavimento DURO 13,3x**.

### 🪦 SCARTO 4 — LA DISCESA DI TF SULLA CLASSE G: guadagno `0,00`, **MISURATO DAL CODICE**
**21 sedie su 42** hanno lo stop ancorato al **CALENDARIO** (minuti di sessione,
box notturno, candela D1, gap, pip fissi) e **non alle barre**. Su tutte e 21
scendere di TF **non compra nemmeno un'operazione**, e la prova e' una riga:
`ABTG_DAX_Apertura_EU` r.1007-1020 (range su **`PERIOD_M1` cablato**) + r.679
(macchina a fasi su **minuti d'orologio**) + `InpOneTradePerDay=true` ·
`ABTG_Dow_Apertura_US` r.226 · `ABTG_Nasdaq_Apertura_US` r.205 ·
`ABTG_ORB_Ottimizzato` r.135 · `ABTG_PunteLarry` r.142 (*"i pattern restano su
D1"*) + r.415-420 + r.283 · `ABTG_GapFill` r.128 + r.245 (`ATR` su **`PERIOD_D1`**) ·
`ABTG_MaxMinNotte` r.51-54 (box 23:00-04:59 **ora server**) + r.76 (`InpMgmtTF`,
input **separato** dal grafico) · `ABTG_PostNews` r.98 (`InpSLpips = 25` **fisso**) ·
`ABTG_GapContinuation` (nessun `ENUM_TIMEFRAMES`, nessun `iATR`).

### 📏 E LA LEGGE CHE NE ESCE, falsificabile
> **Un motore guadagna operazioni scendendo di TF se e solo se il suo stop si
> stringe scendendo di TF.** Non sono due proprieta' correlate: sono **la stessa**,
> perche' dipendono entrambe dall'ANCORAGGIO del setup (barre contro calendario).
👉 **La banda bassa non e' un serbatoio di frequenza, per costruzione.** La
frequenza ha un solo interruttore misurato, ed e' il **numero di SIMBOLI** (firma
del 07/09, pavimento 1,00 op/giorno per **FAMIGLIA**).
Il guadagno sulla classe S e' **MISURATO su 58 serie** (asse `InpTF` dentro lo
stesso CSV, quindi la finestra si elide): **H1 -> M30 mediana 1,97x** (banda
1,13-3,33) · **M30 -> M15 mediana 1,85x** (banda 0,93-2,67, e **una serie sta sotto
1,00**). 🔬 Verifica contro numeri di altri: **R108/R111** (due round indipendenti,
BreakingBand GBPUSD, stessa epoca 2022-2026, tick) danno `227/174 = 1,304` --
**dentro la banda**. 👉 **Il moltiplicatore dipende dal MOTORE: 1,30 su una banda,
1,85 su un supertrend. Non si usa un solo numero per tutti.**

### 🔧 UN DIFETTO TROVATO E RIPARATO, non uno scarto
`prove/ABTG_ImpulsoApertura.txt` (08/09) e' **NON LANCIABILE**: `controlla_prova.py`
-> *"2 assi Y (`InpImpulseATRMult`, `InpRR`)"*, **ESITO: FALLITO**. Piu' due difetti
letti oggi: **`InpAllowShort` pinnato a 0** mentre il suo criterio **C2** dice *"DUE
LATI, SEMPRE (regola 25/08)"*; e **salta il suo stesso PASSO 0** (il C0 chiede un
conteggio prima di qualunque griglia, il file e' una griglia 5x4). Il file **non e'
stato toccato**: resta agli atti come specifica dei criteri C0-C9.
🔴 **E un vincolo di CODICE che nessuno aveva scritto:** `ABTG_ImpulsoApertura.mq5`
r.329-332, `OnInit` **RIFIUTA** se l'ora d'apertura non cade su un confine di barra.
Dow e Nasdaq aprono alle **14:30 server** = 870 minuti: `870 % 60 = 30` ->
🔴 **H1 e H2 sono ILLEGALI su U30USD e NASUSD, e M30 e' il TF piu' ALTO legale.**
Chi avesse provato a "salire di TF" avrebbe avuto un EA che non parte, in silenzio.

### 📦 TRE FILE PROVA NUOVI — 6 celle, **12 passate, T = 2,72 min**, entrambi i cancelli VERDI
`controlla_prova.py` **OK 3/3, 0 problemi** · `controlla_riga.py --oggetto prova`
**EXIT 0, ASCII puro 3/3** (byte >127 contati con **python3**, mai con `grep`).
🔴 **Il secondo strato (`controllo-preventivo`) NON e' stato invocato: lo lancia il
coordinatore.** Magic **787701/787751 · 787702/787752 · 787704/787754**, VERGINI
(`grep -rl` repo-wide, `.git` escluso, 0 file). **Niente messo in coda.**
- `prove/R140a_impulso_M30_D30EUR.txt` -- `ABTG_ImpulsoApertura` D30EUR **M30**, due
  lati, asse tecnico sul magic (G1). Il **PASSO 0** del solo motore M30 mai
  misurato. Costo pre-calcolato come **BANDA 15,8x - 48,3x** (ADR 186,5 idx MIS x
  sqrt(30/1440), con e senza il fattore d'apertura **3,05** MIS sul DAX): il limite
  superiore sta **sopra** il 40x, quindi **l'esito positivo e' RAGGIUNGIBILE**
  (classe 278). Attesa piu' probabile dichiarata: **(b) il numero brutto**,
  `Reject >= 60%` -> *"a M30 non arriva alla frontiera, si sale a H1"*.
- `prove/R140b_impulso_M30_U30USD.txt` -- stesso motore, **secondo simbolo della
  FAMIGLIA**. Banda **22,7x - 69,2x**. E su questo simbolo **non c'e' un TF piu'
  alto legale**, quindi un no **chiude il simbolo** invece di rimandarlo.
  🔴 Cancello duro **C4**: alle 14:30 su U30USD operano gia' **770202** e **770611**,
  **entrambe SOLO LONG** -> il ramo long e' promuovibile **solo** se i giorni-segnale
  non coincidono (misura sui per-trade, **ZERO passate**).
- `prove/R140c_tfingresso_M15_770101_D30EUR.txt` -- `ABTG_DAX_Apertura_EU` D30EUR
  **M15**: chiude la **casella 5** del certificato della **SECONDA SEDIA** (*"il TF
  d'ingresso, MAI cambiato"*, `LA_SECONDA_SEDIA` par. 3.2). **Invarianza prevista dal
  sorgente**: range su `PERIOD_M1` cablato (r.1007-1020), fasi su minuti d'orologio
  (r.679), e le **tre** dipendenze da `PERIOD_CURRENT` (r.437 · r.1370 · r.2202)
  sono **tutte inerti** con i pin della cella viva (`SLMode=0`, `TrailMode=1`,
  `AtrFilter=false`, `VolumeFilter=false`, `EntryMode=2`, `TrailStartR=0`,
  `BEatR=0`). Atteso: **identita' con R47a alla quinta cifra**.
  🔴 **Verifica OBBLIGATORIA**: un'identita' perfetta puo' essere una misura **o** un
  artefatto (se `@PERIODO` non arrivasse al tester, la corsa girerebbe **a M5 due
  volte** e darebbe **lo stesso CSV**) -> **si legge il `.ini` / il Giornale**, dove
  il TF del simbolo e' scritto.

### 🔓 ESCLUSIONI "PER SOLA FREQUENZA" RILETTE con la firma del 07/09
- `ABTG_MaxMinNotte_DAX_Short` 770411 (era *"0,078 op/g = 13x sotto"*): la famiglia
  a due sedie resta **sotto 1,00**, e 🔴 **scendere di TF non aiuta** (box notturno +
  ATR su `InpMgmtTF`, input separato: **1 setup a notte a qualunque TF**). La
  frequenza qui si compra **solo con altri simboli** -> **in coda all'imbuto**.
- `ABTG_EMA200` H4 sui 5 gemelli: gia' rilette in `LA_SECONDA_SEDIA` par. 2.1
  (famiglia 0,55-0,80 pos/g). 🆕 **E la discesa a M30 non le salva**: 28,1x col `k`
  misurato, e le celle M30 di `EMA200` sui 5 simboli sono **0 su 5** con n 415-1.151.
- `ABTG_LVNArbitro` U30USD M30: **resta bocciato e la firma non lo tocca** -- era
  bocciato per **DD** (11,33%/18,01% a 0,65%; 11,76%/19,35% a 100k), non per
  frequenza, che era **1,57 op/g**, la migliore del parco.
- `ABTG_IBRetest` M30: **resta chiuso**, PF famiglia **0,7798** e' un numero
  **misurato e brutto**. Cio' che si puo' riprendere e' la **gestione dell'uscita**
  (**il 62% dei trade muore del flat di fine seduta**), e sarebbe **un motore nuovo**.

### 🚧 BUCHI DICHIARATI (i tre che pesano)
1. 🔴 **L'esponente `k` ha UN SOLO punto di misura** (n=4 / n=8, due epoche). Con
   `k = 0,50` sette motori di classe S passano il 40x a M30; con `k = 0,968`
   **zero**. **E' il buco piu' importante del dossier**, e l'ho scritto in due
   colonne invece di scegliere.
2. **Spread orario [NON MISURATO] su `F40EUR`, `225JPY`, `AUDJPY`, `GBPJPY`,
   `CHFJPY`, `EURAUD`, `AUDUSD`** (alla sonda leggono `SpreadPt = 0` = *nessun tick
   in quell'istante*, **non** spread nullo): **16 righe della graduatoria restano
   sospese, non promosse**. Si chiude con `ABTG_SpreadLogger`, **ZERO passate**.
3. **«Max barre nel grafico» sul terminale di backtest `50504400` (`C:\MT5_Backtest`)
   e' [NON MISURATO]**, e `walkforward_generico.ps1` **NON scrive `[Charts] MaxBars`**
   (grep: zero occorrenze; lo scrivono solo `RIGA_R107`, `RIGA_R111`,
   `RIGA_STORICO_INDICI`). 21 mesi di D30EUR a **M5** sono **~126.000 barre**
   [DERIVATO], **sopra** il tetto delle ~100.000. 🟢 **Che il tetto abbia tagliato
   l'IS di R47 e' FALSIFICATO**: la frequenza IS e' **0,721 pos/g** contro **0,728**
   in OOS, **scarto 1,0%** -- l'alternativa prevedeva uno scarto grande.
   🔴 Ma il **valore** del tetto resta ignoto, e leggerlo costa **zero passate**.
4. 🔴 **`prove/ABTG_HVAncora_00_conta.txt` (U30USD M30, due lati, cancello VERDE,
   attesa dichiarata) NON E' MAI STATO LANCIATO dall'08/09.** Sono **4 passate =
   0,91 minuti** sulla banda M30 esatta che Claudio ha chiesto. **Zero righe da
   scrivere: serve solo la decisione di metterlo in coda.**

---

## 🔦 12/09/2026 — I QUATTRO INVISIBILI: le prime righe di registro di quattro EA scritti e mai girati (dossier `report/I_QUATTRO_INVISIBILI_2026-09-12.md`)

> 🔴 **Fatto, misurato oggi:** quattro EA in `mql5/Experts/` scritti fra il **22/08** e
> l'**08/09** non hanno **NESSUNA** riga in questo registro, **NESSUN** CSV in
> `risultati_prove/` e **NESSUN** round in coda. Non sono ne' vivi ne' morti: sono
> **invisibili**, ed e' esattamente la classe di perdita che il 09/09 Claudio ha chiamato
> *"NON E' ACCETTABILE"*. Queste sono le loro **prime quattro righe**.
> 🛑 **Nessun backtest eseguito. `CODA.txt` NON toccata (39 righe). Nessun EA, preset,
> magic o sedia in forward toccati.** Il **secondo strato del cancello** (agente
> `controllo-preventivo`) **non e' invocabile dall'agente**: lo lancia il coordinatore,
> e sta dichiarato in tutti e cinque i file prova.

### 📋 LA TABELLA DEI QUATTRO — verdetto, ancora, ancoraggio, costo

| EA (data del `.mq5`) | verdetto | **ANCORA UNICA** (file:riga) | **barre o calendario** | `stop/spread` M5 / M15 / M30 / H1 | PF · n · DD |
|---|---|---|---|---|---|
| `ABTG_IntradayMomentum` (22/08) | ⚪ **NON ANCORA MISURATO** — misura proposta `R141a`/`R141b` | 🔴 **NO** — stop `2,0 x ATR(InpAtrTF=M30)` r.157-160 · uscita = **CAMPANELLA** r.136-137 | 🔴 **CALENDARIO 100%** (r.57-60: *"IL TF DEL GRAFICO NON CONTA"*) · guadagno di frequenza scendendo di TF **0,00 op/g, MISURATO DAL CODICE** | il TF e' **irrilevante**: lo stop e' `2 x ATR(M30)` a qualunque grafico. **NASUSD 53,3x** · **U30USD 47,8x** (mediane MIS ora 20) | **[NON MISURATO]** tutti e tre |
| `ABTG_AtrExhaustVol` (25/08) | ⚪ **NON ANCORA MISURATO** — misura proposta `R141c` | 🟢 **SI** — stop `min(pivot, low[1]) - buffer` r.500/514 · `tp = entry + R x InpTP_RR` r.649 con **R = lo stop** | 🟢 **BARRE piene (classe S)**: pivot (5,5), ATR(14) e media volume **tutti sul grafico**. E' **l'unico dei quattro** a cui *"scendere di TF"* si applica alla lettera | NASUSD: **10,9x** 🔴 · **18,8x** · **26,6x** · **37,7x** (spread MIS 1,70) — 🔴 **M5 ESCLUSO PER COSTO** (10,9x contro il duro 13,3x) | **[NON MISURATO]** tutti e tre |
| `ABTG_HVAncora` (08/09) | ⚪ **NON ANCORA MISURATO** — misura proposta `R141d` | 🟢 **SI**, con una crepa — stop `InpStopAtr x ATR` r.927 · `tp = entry + InpRR x slDist` r.945. 🔴 **CREPA: il flat 21:00 (r.223-225) e' un'ancora di CALENDARIO** e a `InpStopAtr=2,5` il TP sta al **72% del range giornaliero MISURATO (314,5 idx)** -> quasi mai raggiunto | 🟡 **MISTO**: HV su 30/252 **barre**, stop in **ATR del grafico** (classe S), ma `InpAncoraSoloOggi=true` e il flat sono **calendario** | U30USD a `InpStopAtr=1,0`: **9,3x** 🔴 · **16,0x** (12,3x al mattino) 🔴 · **22,7x** · **32,1x**. 🔴 **Nessun TF passa il 40x a 1,0**; M30 e' il piu' basso sopra il duro a **tutte** le ore | **[NON MISURATO]** tutti e tre |
| `ABTG_DaxValueArea` (30/08) | ⚪ **NON ANCORA MISURATO** — misura proposta `R141e` | 🔴 **NO** — stop = (escursione di **una barra**) + **buffer FISSO** r.415-421 · target = **larghezza della VALUE AREA** r.432-446 | 🔴 **CALENDARIO per il segnale** (1 VA/giorno, tetto 2/giorno, cassa 08:00-16:30) · **BARRE per lo stop**. 👉 **il peggiore dei quattro abbinamenti: scendere di TF costa DUE volte** (come `ABTG_ImpulsoApertura`) | D30EUR col buffer della fonte (3,0 idx): **5,6x** 🔴 · **8,5x** 🔴 · **11,3x** 🔴 · **15,2x**. 🔴 **SFONDA IL PAVIMENTO DURO 13,3x A M5, M15 E M30** | **[NON MISURATO]** tutti e tre |

🔴 **Nessuno dei quattro si archivia**: manca **il PF**, manca **n**, manca **DD**, e
delle cinque caselle del certificato del 09/09 **ne mancano cinque su cinque**. Il
verdetto e' **"NON ANCORA MISURATO"**, non *"morto"*, e la via piu' corta al numero
costa **5,16 minuti di macchina** in tutto.

---

### 🚨 IL DIFETTO PIU' GRAVE, ED E' DI ARITMETICA — `prove/ABTG_HVAncora_00_conta.txt` (08/09) **HA UN'ATTESA IMPOSSIBILE**

Il buco **#4** della sezione precedente di questo registro dice *"cancello VERDE, attesa
dichiarata, 4 passate = 0,91 minuti, serve solo la decisione di metterlo in coda"*.
🔴 **VA CORRETTO, e la correzione cambia cosa si deve fare.**

```
ABTG_HVAncora.mq5 r.239   input double InpMaxSpreadPctOfStop = 2.5;
ABTG_HVAncora.mq5 r.935   if(spreadPrezzo > (InpMaxSpreadPctOfStop/100.0)*slDist)
                             -> IL TRADE SI SALTA
```
2,5% dello stop = *"spread <= 1/40 dello stop"* = il **pavimento di lavoro
`stop >= 40 x spread`, applicato tick per tick dall'EA**.

| ingrediente | numero | fonte |
|---|---:|---|
| range giornaliero U30USD | **314,5 punti indice** (n = 24 giorni) | 🥇 **MISURATO**, `report/ROUND_ORB_ATR_PS5_2026-09-10.md` r.233 |
| range di barra M30 | **45,4 punti indice** | [DERIVATO] `314,5 x sqrt(30/1440)` |
| spread U30USD ore 08-13 (mediana) | **2,60** | 🥇 **MISURATO** su 64.711.285 tick, `spread_flotta/spread_orario_U30USD.csv` |
| spread U30USD ore 14-20 (mediana) | **1,90 - 2,00** | 🥇 **MISURATO**, 4.931.660 tick alla sola ora 14 |
| **spread / stop** con `InpStopAtr = 1,0` | **4,41%** (pomeriggio) · **5,73%** (mattino) | contro una soglia di **2,50%** |

> ## 🔴 **Col pin del 08/09 l'EA avrebbe RIFIUTATO IL 100% DEI TRADE, a ogni ora della finestra. Le "50-200 operazioni" attese sono impossibili PER COSTRUZIONE (classe 278).**
> E il danno peggiore non e' la corsa buttata: **uno zero letto come "niente segnali"
> avrebbe SEPOLTO un motore che non era nemmeno stato interrogato.**

- 🟢 **Il file del 08/09 NON e' stato modificato** (stessa scelta fatta oggi su
  `prove/ABTG_ImpulsoApertura.txt`): resta come reperto dei criteri, che sono buoni.
- 🟢 **La riparazione e' `prove/R141d_hvancora_stopatr_M30_U30USD.txt`**: l'asse e'
  `InpStopAtr` (1,0 / 1,5 / 2,0 / 2,5) e **misura dove cade il muro dei rifiuti**.
  Ed e' legittimo allargare lo stop **solo** perche' su questo motore **l'ANCORA E'
  UNICA** (`tp = entry + InpRR x slDist`, r.945): su un motore ad ancore diverse lo
  stesso asse sarebbe **curve fitting sul costo**.
- 🎁 **Effetto collaterale che vale da solo**: il `k` a cui compaiono le prime
  operazioni **MISURA l'ATR(M30) vero di U30USD**, che oggi e' `[DERIVATO]` e mai
  misurato. Se compaiono gia' a `k = 1,5`, allora `ATR(M30) >= 53,3 idx`, cioe' la
  derivazione da ADR **sottostima di almeno il 17%** — che e' **esattamente** la
  sottostima del **18-27%** gia' misurata in casa su un altro motore
  (`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` r.182). **Due strade indipendenti.**

---

### 🚨 QUATTRO DIFETTI BLOCCANTI in `prove/ABTG_DaxValueArea.txt` (30/08) — **NON LANCIABILE**

| # | difetto | conseguenza, verificata sul sorgente del driver |
|---|---|---|
| 1 | **TRE assi Y** (`InpVaPercent`, `InpAcceptBars`, `InpSide`) | `controlla_prova.py` **FALLISCE**: un file prova misura UNA variabile alla volta |
| 2 | 🔴 **le direttive `@` sono COMMENTATE**: `# @SIMBOLO  D30EUR`, `# @PERIODO  M5`, `# @DAQUANDO ...` | `walkforward_generico.ps1` **r.495-501** salta le righe che iniziano con `#` **PRIMA** di guardare la `@` -> `$Direttive` resta vuoto -> il driver **MUORE** su **r.737** (*"manca il simbolo"*) |
| 3 | **nessuna riga `#  EA: <nome>`** nell'intestazione | il cancello stampa *"EA NON TROVATO -> non misurabile"* e **non controlla niente** |
| 4 | **`@PERIODO M5`** su D30EUR per 21 mesi | **~126.700 barre** [DERIVATO: 276 barre/giorno x ~459 feriali], **sopra** il tetto delle ~100.000: la finestra vera sarebbe piu' corta di quella dichiarata, **in silenzio** |

🔴 **E UN PUNTO CIECO DEL CANCELLO, che e' una classe nuova**: `controlla_prova.py`
verifica la finestra cercando la **sottostringa** `"@DAQUANDO"` nel testo — e la trova
**dentro il commento**. Quindi su questo file il cancello **dichiarava la finestra
presente mentre il driver non l'avrebbe vista**. Va in `CHECKLIST_RIGA_DI_LANCIO.md`.
🟢 Il file del 30/08 **NON e' stato modificato**: resta reperto.

---

### 🔧 UNA MANOPOLA INERTE TROVATA **LEGGENDO**, prima di spendere una notte

`ABTG_AtrExhaustVol.mq5` r.557-561:
```
double Tolleranza(livello, atr)
  { if(InpProxMode==EX_PROX_ATR) return(atr*InpProxAtrMult);
    return(livello*InpProxPercent/100.0); }
```
Col modo **dell'autore** (`EX_PROX_PERC`, `InpProxPercent = 0,5`) la tolleranza e' lo
**0,5% del prezzo del pivot**. Su NASUSD, prezzo mediano **MISURATO 29.001**
(`ROUND_ORB_ATR_PS5` r.234):

| | numero |
|---|---:|
| tolleranza di prossimita' | **145,0 punti indice** |
| range di barra M30 | **45,3 punti indice** [DERIVATO da 313,8 MIS] |
| **tolleranza in range di barra** | 🔴 **3,2 BARRE INTERE** |

> 🔴 **Una delle TRE condizioni COSTITUTIVE del motore non filtra niente.** L'autore ha
> tarato lo 0,5% su uno strumento dove 0,5% e' dell'ordine della barra; su un indice a
> cinque cifre non lo e'. Col modo `EX_PROX_ATR` (`0,5 x ATR(14)` = **~22,6 idx** =
> **mezza barra**) morde.
> 👉 E' la classe di difetto del censimento del 09/09 (**874 CSV su 1.960 con esiti
> IDENTICI** = manopole girate senza che mordessero). **Qui la manopola non era ancora
> stata girata, e la si trova inerte PRIMA di pagarla.** L'asse di `R141c` **e' proprio
> quella manopola.**

---

### 📦 I CINQUE FILE PROVA CONSEGNATI — 14 celle, **28 passate, 5,16 minuti**

Metro di casa: **`T(min) = 0,6 + 0,077 x passate`, per ROUND.**
Riferimento: la coda di stanotte fa **258 passate** in tutto.

| ord. | file | EA · simbolo · TF | asse unico | celle | passate | **T (min)** |
|---:|---|---|---|---:|---:|---:|
| **1** | `prove/R141a_momentum_NASUSD_r12.txt` | `IntradayMomentum` · NASUSD · M30 | `InpUseSecondSignal` (il predittore r12) | 2 | 4 | **0,91** |
| **2** | `prove/R141b_momentum_U30USD_gemello.txt` | `IntradayMomentum` · U30USD · M30 | `InpUseSecondSignal` (gemello, ablazione a stella) | 2 | 4 | **0,91** |
| **3** | `prove/R141c_atrexh_M30_NASUSD.txt` | `AtrExhaustVol` · NASUSD · M30 | `InpProxMode` (PERC inerte contro ATR) | 2 | 4 | **0,91** |
| **4** | `prove/R141d_hvancora_stopatr_M30_U30USD.txt` | `HVAncora` · U30USD · M30 | `InpStopAtr` (1,0 / 1,5 / 2,0 / 2,5) | 4 | 8 | **1,22** |
| **5** | `prove/R141e_daxva_buffer_M15_D30EUR.txt` | `DaxValueArea` · D30EUR · M15 | `InpSlBufferPts` (800 / 2800 / 4800 / 6800) | 4 | 8 | **1,22** |
| | **TOTALE** | | | **14** | **28** | **5,16** |

**Cancello deterministico, riprodotto:**
```
=== CONTROLLO FILE PROVA ===
  R141a_momentum_NASUSD_r12.txt          ABTG_IntradayMomentum.mq5  pin=27 celle= 2  OK
  R141b_momentum_U30USD_gemello.txt      ABTG_IntradayMomentum.mq5  pin=27 celle= 2  OK
  R141c_atrexh_M30_NASUSD.txt            ABTG_AtrExhaustVol.mq5     pin=35 celle= 2  OK
      . asse ENUM (ENUM_EX_PROX): il passo e' IGNORATO, celle = membri fra 0 e 1 = 2
  R141d_hvancora_stopatr_M30_U30USD.txt  ABTG_HVAncora.mq5          pin=29 celle= 4  OK
  R141e_daxva_buffer_M15_D30EUR.txt      ABTG_DaxValueArea.mq5      pin=25 celle= 4  OK
file: 5 | celle totali: 14 | passate: 28 | problemi: 0        ESITO: OK
controlla_riga.py --oggetto prova : EXIT 0 su 5 file su 5
byte >127 (contati con python3, MAI con grep '[^\x00-\x7F]'): 0 su tutti e cinque
magic 784101 · 784102 · 784103 · 784104 · 784105 : grep -rl repo-wide, .git escluso -> ZERO
etichetta blocco r141 : ZERO collisioni con le 29 in coda (la piu' alta e' r139c)
```

🚨 **CLASSE 273, e in tutti e cinque i file il commento NON e' invertito:**
**`-Modello 4` = TICK REALI · `-Modello 1` = OHLC M1 = SOLO SCREENING.** Il modello non
e' pinnato nei file: arriva dalla riga di lancio, dove il default del driver e' **4**
(`walkforward_generico.ps1` r.180).
🚨 **CLASSE NUOVISSIMA (asse ENUM come intervallo con passo)**: gli unici ENUM in gioco
sono `InpAtrTF` (pinnato col **valore esplicito 30** = `PERIOD_M30`), `InpProxMode` e
`InpTrigMode` (due membri ciascuno, **valori espliciti 0 e 1**). **Nessun intervallo
largo su un enum.** Il numero di celle e' stato **guardato** dopo aver scritto ogni
file, come impone la classe: 2 · 2 · 2 · 4 · 4, cioe' quello che doveva essere.
🕐 **ORA SERVER BCM in tutti e cinque** (= ora italiana - 1): `InpSessionHour = 8` per
il DAX (**non 9**), `InpEntryHour = 20` / `InpExitHour = 21` / `InpHourStart = 14` per
gli USA (**non 21 / 22 / 15**). **Un CSV con l'ora italiana si CESTINA.**

---

### 🪦 GLI SCARTI COL NUMERO usciti da questa lettura

| candidato | TF | cancello che lo ferma | numero | verdetto |
|---|---|---|---|---|
| `ABTG_AtrExhaustVol` **NASUSD M5** | M5 | 🔴 **COSTO** | stop ~**18,5 idx** [DER] / spread **1,70** MIS = **10,9x** contro il pavimento DURO **13,3x** | 🪦 **ESCLUSO PER COSTO, col numero** |
| `ABTG_HVAncora` **U30USD M5** | M5 | 🔴 **COSTO** | **9,3x** (ore 14-20) e **7,1x** (ore 08-13), contro il duro 13,3x | 🪦 **ESCLUSO PER COSTO** |
| `ABTG_HVAncora` **U30USD M15** | M15 | 🔴 **COSTO** alle ore 08-13 | **12,3x** al mattino (sotto il duro), **16,0x** al pomeriggio | 🪦 **ESCLUSO PER COSTO** nella meta' mattutina della sua finestra |
| `ABTG_DaxValueArea` **D30EUR M5 · M15 · M30** col buffer della fonte (3,0 idx) | M5/M15/M30 | 🔴 **COSTO** | **5,6x · 8,5x · 11,3x**, tutti e tre **sotto il pavimento DURO 13,3x**. E `InpMinStopPts = 500` punti MT5 = **5,0 idx = 2,9x** non protegge niente | 🪦 **SFONDA IL DURO A TUTTI E TRE I TF.** Non e' salvabile scendendo: **peggiora** |
| `ABTG_DaxValueArea` **D30EUR M30** come profilo volumetrico | M30 | 🔴 **DEGENERAZIONE DEL PROFILO** | a M30 la seduta cash ha **17 barre** e ognuna spalma il volume su **5,4 dei ~22 bin** (r.286-312) = **il 25% del profilo per barra** -> il POC tende al centro del range e la VA al range x 0,7 | 🪦 **il profilo volumetrico degenera in una statistica geometrica di RANGE**, cioe' un **ORB con un altro nome** — e l'ORB in casa e' chiuso con **~210 celle a tick** (R45 0/48, R12 48/48 negative OOS) |
| `ABTG_DaxValueArea` **D30EUR M5** | M5 | 🔴 **TETTO DELLE BARRE** | **~126.700 barre** sopra il tetto delle ~100.000 | 🪦 **escluso per il tetto**, non per il costo — e il costo lo escluderebbe comunque (5,6x) |
| `ABTG_DaxValueArea` — celle `InpSlBufferPts` **800** e **2800** di `R141e` | M15 | 🔴 **COSTO, pre-dichiarato** | **4,7x** e **16,5x**, sotto il pavimento di LAVORO 40x (la prima anche sotto il duro) | 🪦 **INFORMATIVE E NON PROMUOVIBILI, qualunque numero diano.** Stesso trattamento gia' dato alle celle M5/M15/M20/M30 di `ABTG_EMA200` su U30USD |
| `ABTG_HVAncora` — celle `InpStopAtr` **1,0** e **1,5** di `R141d` | M30 | 🔴 **COSTO, e lo applica l'EA stesso** | spread/stop **4,41%** e **2,94%** contro la soglia **2,50%** di `InpMaxSpreadPctOfStop` -> **il trade si salta** | 🪦 **Trades attesi ~0. Non e' un baco: e' il cancello che funziona.** Girano come **misura di dove cade il muro** |
| `ABTG_IntradayMomentum` — **la discesa di TF** | qualunque | 🔴 **nessun guadagno** | **0,00 op/giorno** guadagnate scendendo, **MISURATO DAL CODICE** (segnale, ingresso e uscita sono tutti d'orologio; lo stop e' `ATR(InpAtrTF)`, input separato) | 🪦 **non si scende: non c'e' niente da comprare.** E non gli serve: fa gia' **1 op/giorno**, **3 di famiglia** su tre indici |
| `ABTG_DaxValueArea` — **la discesa di TF** | qualunque | 🔴 **costa DUE volte** | segnale a **CALENDARIO** (1 VA/giorno, tetto **2/giorno**) -> **0,00 op/g** guadagnate; stop a **BARRE** -> si stringe | 🪦 **il peggiore dei quattro abbinamenti**, come `ABTG_ImpulsoApertura` (`LA_BANDA_BASSA` par. 4) |

---

### 📊 LA COSA CHE CAMBIA LA CLASSIFICA, e non e' il timeframe: **IL CAMPIONE**

Sedute nella finestra `@DAQUANDO 2024.09.26` -> `@FINOA 2026.06.30`: **643 giorni di
calendario -> ~459 feriali -> ~443 sedute** (meno le feste). Taglio del driver
`FrazioneIS = 0,40` -> **IS ~177 sedute, OOS ~266 sedute**.

| EA | operazioni/giorno attese | **n atteso IS** | **n atteso OOS** | arriva a 150 in ENTRAMBE? |
|---|---|---:|---:|:--:|
| `IntradayMomentum` (cella r12 spento) | **1,00 per costruzione** (`InpMinAbsR1Pct = 0`) | **160-180** | **240-270** | 🟢 **SI, per aritmetica del calendario** |
| `DaxValueArea` | 0,4 - 1,2 [NON MISURATO] | 72-212 | 108-318 | 🟡 **meta' delle volte** |
| `AtrExhaustVol` | 0,10 - 1,20 [NON MISURATO] | 18-212 | 26-318 | 🟡 **solo la meta' alta** |
| `HVAncora` | 0,11 - 0,45 (attesa del file 08/09) | 20-80 | 30-120 | 🔴 **NO** — merito **SOSPESO** (valvola R59), rischio leggibile |

> ## 🟢 **`ABTG_IntradayMomentum` e' l'UNICO dei quattro che arriva a `n >= 150` in TUTTE E DUE le finestre, e non per fortuna: perche' opera una volta al giorno e i giorni ci sono.** Con `1,00 op/giorno` su un simbolo e **3 indici** in famiglia fa **3 op/giorno di famiglia**, cioe' **tre volte** il pavimento firmato il 07/09.
> 🔴 **E la parte scomoda, scritta prima:** il suo pedaggio **MISURATO** e' `1,70 + 1,70 = 3,40 punti indice` andata e ritorno su NASUSD (ore 20 e 21, mediane su 11,2 e 6,8 milioni di tick). Col success rate **DEL PAPER** (54,37%, `[DICHIARATO NEL PAPER, NON MISURATO DA NOI]`) l'edge atteso e' **1,98 - 3,96 punti**, cioe' **edge/costo = 0,58 - 1,16**. 👉 **Col solo `r1` questo motore sta SUL FILO del suo pedaggio, e la meta' bassa della banda e' in perdita prima di cominciare.** Col doppio predittore (77,05% dichiarato) il rapporto sale a **3,6 - 7,2**. **E' per questo che l'asse del round e' `r12`: non e' una taratura, e' l'unica cosa che in aritmetica separa i due casi.**

### 🔬 E IL NUMERO CHE SEPARA NASUSD DA U30USD, perche' la frontiera e' una **DISTRIBUZIONE**

| simbolo | range giornaliero **p25** (MIS) | ATR(M30) al p25 [DER] | stop `2 x ATR` | spread ora 20 (MIS) | **stop/spread al p25** |
|---|---:|---:|---:|---:|---:|
| **NASUSD** | **239,4** | 34,6 | 69,1 | **1,70** | 🟢 **40,6x — passa ANCORA il 40x** |
| **U30USD** | **172,0** | 24,8 | 49,7 | **1,90** | 🟡 **26,1x — sopra il duro, sotto il 40x** |
| D30EUR | 146,0 | 21,1 | 42,2 | 1,70 (ora 16) | 🟡 **24,8x** |

> 🎯 **NASUSD e' l'unico dei tre indici dove anche il giorno al 25esimo percentile sta
> sopra il pavimento di lavoro.** E' l'unico numero che ordina i due gemelli, e **e'
> per questo che `R141a` e' NASUSD e `R141b` e' U30USD, non il contrario.**
> 🔴 **Frazione delle operazioni sotto il 40x su U30USD: almeno il 25%** [DERIVATO dal
> p25 del range]. **Sotto il duro 13,3x: [NON MISURATO]** — servirebbe un giorno **1,7
> volte piu' quieto del p25**.

---

### 🎯 L'ORDINE PROPOSTO, e il NO col motivo

| ord. | chi | perche' in quest'ordine |
|---:|---|---|
| 🥇 **1** | `R141a` + `R141b` — `IntradayMomentum` NASUSD e U30USD | **L'unico dei quattro con `n >= 150` garantito in entrambe le finestre**, **1 op/giorno** senza chiedere niente al timeframe, e la frontiera del costo **passata con margine** all'ora piu' economica del feed (53,3x e 47,8x). Otto passate, **1,82 minuti**, e rispondono **in tutti e due i versi** |
| 🥈 **2** | `R141c` — `AtrExhaustVol` NASUSD M30 | **L'unico ad ANCORA UNICA + BARRE piene**: e' il solo dei quattro a cui la domanda di Claudio (*"M5, M15 e M30"*) si applica alla lettera, e il solo su cui la frontiera del costo **si compra senza pagare edge**. Ma la **frequenza e' `[NON MISURATA]`** e la meta' bassa della banda sta sotto 150 |
| 🥉 **3** | `R141d` — `HVAncora` U30USD M30 | Ripara un'**attesa impossibile** e **misura l'ATR(M30) vero di U30USD**, che non abbiamo. Ma l'attesa di frequenza del file del 08/09 **non arriva a 150 in nessuna finestra**: e' un **PASSO 0 di costo**, non un candidato a sedia |
| 🔴 **4 — NON stanotte** | `R141e` — `DaxValueArea` D30EUR M15 | 🔴 **ANCORA UNICA = NO** + **CALENDARIO per il segnale e BARRE per lo stop** + il profilo che **degenera in un ORB** salendo di TF + il **tetto delle barre** che chiude M5. La cella che paga il pedaggio (40,0x) ha **RR ~1,0 sul target finale e ~0,5 sul primo**; la cella con RR buono (4,1-5,2) sta a **4,7x**, tre volte sotto il duro. 👉 **DOPPIA MORSA, scritta col numero prima della corsa.** Gira come **misura di una legge**, non come candidato: se il PF **sale** col buffer, la regola dell'ancora unica e' **falsificata** su questo motore — e quello e' il risultato piu' importante che il round puo' dare |

> ✏️ **CORRETTO IL 15/09/2026 (controllo-preventivo).** La riga sopra (13/09) usa il criterio
> a PUNTO SINGOLO "se il PF sale, la legge e' falsificata": **e' quello che la classe 292 (12/09)
> ha dimostrato insufficiente** — a edge zero il PF sale COMUNQUE del 18% per sola geometria+pedaggio
> (tabella del PF nullo per cella: 0,79/0,90/0,92/0,93). Il criterio VIVO da qui in poi e' quello
> riparato il 15/09 (classe 292 riparata, classe 347): "legge falsificata" richiede l'IC 95%
> dell'Eccesso (PF misurato - PF nullo) sopra zero su >=2 celle adiacenti, in ENTRAMBE le finestre
> IS/OOS, n>=150 ciascuna, piu' il pavimento PF>=1,10 su almeno una cella — vedi
> `prove/R141e_daxva_buffer_M15_D30EUR.txt`. Questa riga resta come reperto storico di cosa si
> pensava il 13/09, non come istruzione per leggere i risultati.

🙋 **E UNA COSA CHE CHIEDE UNA FIRMA, NON UN ROUND:** in `R141c` il pin
`InpFridayClose = true` e' **NOSTRO** (il sorgente parte a `false`, cioe' tiene le
posizioni nel fine settimana: su un CFD indice quello misurerebbe il **gap del
weekend**, non il motore). E' una restrizione **piu' prudente** del default, ma
**rischio e taglie sono di Claudio** e va segnalata, non decisa.

## CACCIA ALLO STOP STRUTTURALE (13/09/2026) — 1.221 sorgenti setacciati, 3 promossi IN CODA, 0 file prova, 1 FONTE SBLOCCATA

Dossier completo: `report/CACCIA_STOP_STRUTTURALE_2026-09-13.md`. Il resto sta li',
non si duplica. **Zero EA toccati, zero preset, zero `CODA.txt`, zero backtest,
zero terminali.** File nuovi: il dossier + 4 sorgenti esterni in
`biblioteca/sorgenti/`.

- 🔓 **SBLOCCO DI FONTE, e vale piu' dei candidati: TradingView e' leggibile E
  cercabile.** `PROMEMORIA_SBLOCCO_FONTI.md` la da' per chiusa (*"il Pine NON e'
  nell'HTML -> non setacciabile"*) e la caccia del mattino la dichiara **buco
  aperto**. Misurato il 13/09: **(a)** `tradingview.com/pubscripts-suggest-json/?search=<parole>`
  -> **200**, JSON con nome, autore, `agreeCount`, `scriptIdPart`, `kind`,
  `access`, **50 risultati per query**; **(b)** `pine-facade.tradingview.com/pine-facade/get/PUB%3B<hash>/last`
  -> **200**, campo **`source`** = **il Pine in chiaro**. Controllo positivo:
  `ATR Exhaustion & Volume Spike` (3.550 byte) = lo script che in casa e' gia'
  `ABTG_AtrExhaustVol`. 👉 **Il §4 e' applicabile a TradingView senza intermediari,
  e la ricerca per MECCANISMO — impossibile sul Code Base (`?s=` in JS) — li' funziona.**
  ⚠️ Limite dichiarato: e' un **suggeritore**, le query lunghe rendono 0
  (`"opening range breakout atr"` -> 0, `"opening range breakout"` -> 50).

- 📊 **IL NUMERO CHE GIUSTIFICA IL MANDATO.** Su **907 sorgenti `.mq5`** scaricati
  oggi dal Code Base (25 pagine, 999 titoli), decodificati UTF-16 e setacciati:
  **stop strutturale (ATR o livello) senza martingala = 50, cioe' il 5,5%**;
  **stop come costante numerica in un `input` = 187 (20,6%)**; griglia 177;
  martingala 44. Su TradingView la quota di stop strutturale e' **98 su 314
  strategie open-source (31,2%)**. 🔴 **Lo stop strutturale e' il 5,5% del Code
  Base: chi non mette quel filtro in TESTA butta 19 sorgenti su 20.** *(conteggi
  [DERIVATI] da regex, residuo di falsi positivi dichiarato)*

- 🏅 **TRE PROMOSSI, TUTTI `IN CODA`, NESSUNO `PROVA SUBITO`** — e il motivo e'
  strutturale, non di merito: sono Pine, quindi la voce *"testabile senza
  riscritture"* vale **0** per costruzione.
  **C1 `Volatility Momentum Breakout Strategy`** (cryptechcapital, TV `dJe0bGvQ`,
  2025-02-05, 111 righe, 10 input, licenza [INCERTO], 27 agree) — **6/10**.
  🥇 **L'unico dei 1.221 in cui SOGLIA D'INGRESSO, STOP e TARGET scalano tutti
  con lo stesso ATR**: ingresso `close > Highest(high,20)[1] + 1,5 x ATR`, stop
  `entry - k x ATR`, target `entry + (entry-stop) x RR` = **ancora unica
  ESPLICITA**. **Simmetrico L/S per costruzione** (nessun input di lato) = buco
  SHORT. 🔴 Difetto: `riskPercent` (r.45) **definito e mai usato** -> la taglia e'
  5% dell'equity (r.33), verificato a grep (le entry r.72/74 non passano `qty`).
  **C2 `[KL] Mean Reversion (ATR) Strategy`** (DojiEmoji, TV `vUm2xj05`,
  2021-10-31, 108 righe, 8 input, **MPL 2.0**, 146 agree) — **7/10, il piu' alto**.
  Segnale = **ATR fuori di 1 sigma dalla sua media** + deriva lognormale > 0
  (volatilita', NON prezzo); stop `low - 2 x ATR` che trascina; **uscita a
  1R/2R/3R a scaglioni con R = 2 x ATR**: la gestione **e' gia' la nostra**.
  🔴 Long-only, taglia = 5% di allocazione. 🐛 latch
  `_signal_diverted_ATR := not s and X or Y` da riscrivere esplicito.
  **C3 `Donchian Breakout with ATR Trailing Stop`** (raven_suurineru, TV
  `NeEiwmDq`, 2026-07-07, 146 righe, Pine v6) — **5/10**. 🟢 Il **sizing piu'
  pulito della giornata** (`qty = equity x riskPct / (ATR x mult)`), niente
  look-ahead. 🔴 **Doppione**: `ABTG_CanaleLento` **E'** Donchian 55/20 e la EMA200
  e' la nostra sedia migliore.

- 🎯 **LA FRONTIERA DEL COSTO, E IL RISULTATO CHE RIAPRE M15 SUGLI INDICI.**
  Spread **MISURATI** (`data/spread_vivo/...2026-09-12`, n~79-85 mila, GG 5-6):
  D30EUR **1,70** · NASUSD **1,80** · U30USD **2,00** idx; commissione indici
  **0,0000** (n=302 deal). ATR da ADR **MISURATI** (186,5 / 313,8 / 314,5).
  `stop/spread` di C1 al variare di `kStop`:

  | | k=1,0 | k=1,5 | k=2,0 | k=2,5 |
  |---|---:|---:|---:|---:|
  | D30EUR M15 | 🔴 **11,2x** | 16,8x | 22,4x | 28,0x |
  | D30EUR M30 | 15,8x | 23,8x | 31,7x | 🟢 39,6x |
  | NASUSD M15 | 17,8x | 26,7x | 35,6x | 🟢 **44,5x** |
  | NASUSD M30 | 25,2x | 🟢 37,7x | 🟢 50,3x | 62,9x |
  | U30USD M15 | 16,0x | 24,1x | 32,1x | 🟢 **40,1x** |
  | U30USD M30 | 22,7x | 34,0x | 🟢 45,4x | 56,7x |

  > 🟢 **Con uno stop STRUTTURALE, M15 su NASUSD e U30USD supera il pavimento di
  > lavoro 40x a k=2,5.** Nelle quattro cacce precedenti M15 sfondava perche' lo
  > stop era una costante e **non poteva crescere**. 🔴 **D30EUR M15 a k=1,0 fa
  > 11,2x: SFONDA IL PAVIMENTO DURO 13,3x** — sul DAX il TF basso resta chiuso.
  > ⚠️ La legge `ADR x sqrt(t/1440)` **sottostima del 18-27%** (MIS): sono
  > **pavimenti**, non stime centrate.
  > 🔴 **E l'invarianza in R e' ASSUNTA, NON misurata su questo motore** (stessa
  > onesta' di `R141c` r.60-66). Sul cono di rumore, misurata, **crollava**
  > (+0,054 R -> +0,012 R). **Il primo round deve essere l'asse su `kStop`.**

- 🪦 **SCARTI COL NUMERO.**
  **`AdaptiveTrader Pro EA`** (Code Base **52152**, sasan31, 2024.09.15, 388
  righe, 20 input, **mai setacciato prima**): 🔴 **si ottimizza da solo a
  runtime** — `BacktestWithParameters(...)` (r.250) girato ogni
  `OptimizationInterval = 3600` s su tre cicli annidati (r.265-272) per scegliere
  i parametri "migliori" sui dati appena passati -> **non riproducibile**; e
  `iATR(symbol, PERIOD_M5, 14)` (r.105) **inchioda l'ATR a M5**. 🟢 Stop
  strutturale (r.223) e rischio in % (r.10): l'idraulica e' buona, la misura no.
  **`Dow Theory Trend Strategy`** (TV, Salaryman_G, 139 agree): 🔴 **ZERO stop** —
  due `strategy.entry`, **nessun** `strategy.exit`. **Ed e' il contro-esempio che
  dimostra che il filtro automatico non e' un verdetto**: l'euristica lo aveva
  marcato *"stop strutturale"* per via dei `lastPivotLow`. **Classe 289 in piena
  regola, e si trova solo leggendo.**
  **`Volatility Breakout System [Fixed Risk]`** (TV, debdaspt85, 212 agree): 🔴
  **ancora MISTA** — stop `entry - 4 x ATR` ma breakeven e trailing in
  **percentuale del prezzo** -> allargando lo stop l'edge in R si diluisce; piu'
  `lookahead=barmerge.lookahead_on` nel file e 4 filtri a interruttore.
  **Pagine 11-25 del Code Base (597 sorgenti, 2010-2013): POZZO SECCO, misurato** —
  20 con stop strutturale (3,3%), **127 con parole di griglia**, e i sopravvissuti
  hanno 27-71 input (`MacdPatternTraderAll`, `Flat Channel`, `jMaster RSI`,
  `Freeman`). **Non si riapre senza una ragione nuova.**
  **Famiglie intere scartate per doppione**: ~18 Supertrend TV (in casa 9 EA +
  blocco B/C chiuso il 12/09), ~14 ORB TV (porta chiusa, ~210 celle), ~8 VWAP TV
  (`ABTG_VwapRevert` falsificato il 03/09), ~30 incroci di indicatori con ATR
  SL/TP appiccicato (§5C: nessuna tesi).

- 🔧 **«MERITO MA STOP FISSO» — una sola vale la riscrittura.**
  **`Keltner bounce from border. No repaint. V2`** (TV `mQKGzLMD`, zelibobla,
  **2.000 agree**): fade **simmetrico** dell'estremo (rottura della banda di
  Keltner a **8 ATR** dalla media a 200, uscita sul ritorno alla media) = **tesi
  di LATERALE/CROLLO**, e in casa **`grep -i keltner` sui 115 EA da ZERO**:
  famiglia **VERGINE**. 🔴 Blocco: `SL = input(defval=50, "Stop loss in ticks")`
  e `tradeSize = 1` fisso. 🟢 **Riscrittura ~3 ore**: la banda **e' gia'**
  `EMA ± k x ATR`, quindi ancorare lo stop alla banda rende **l'ancora unica per
  costruzione** (anche il target, la media, scala con la stessa ATR).
  🐛 Reperto: nel ramo `enterOnBorderTouchFromInside` l'ordine "SELL" e' aperto
  come `strategy.long` — **bug dell'autore, da non portare**.

- 🔴 **ZERO FILE PROVA, E LO ZERO HA UNA PROVA.** Un file prova esiste solo se
  esiste l'`.mq5`: `controlla_prova.py` su un file con `# EA: ABTG_NonEsiste`
  risponde **"EA NON TROVATO -> non misurabile"**, `problemi: 1`, `exit 1`
  (provato oggi). I tre promossi sono Pine: l'`.mq5` va **scritto**, e scrivere
  EA e' **fuori dal perimetro di questa caccia**. Al suo posto il dossier
  consegna la **SPEC di C1 pronta da codificare** (9 input, primo asse
  `kStop = 1,0 || 1,5 || 2,0 || 2,5`, 4 celle x 2 finestre = ~1 minuto macchina).

- 🕳️ **BUCHI DICHIARATI:** **arXiv 429 x2 + timeout a 40 s** (e 429 ≠ 404: non
  cancella niente, si riprova) · **SSRN 403** · **Forex Factory 403** ·
  **Quantpedia 200 ma 0 link di strategia nell'HTML** (contenuto in JS: raggiunta,
  **non setacciabile**) · **GitHub: `raw` legge (README 200) ma l'elenco dei file
  e' 403 e i 4 percorsi tentati danno 404 -> ZERO sorgenti GitHub letti oggi**
  (buco piu' grosso della giornata) · popolarita' Code Base **[NON MISURATA]**
  (contatori in JS) · **ATR reale dei simboli [NON MISURATO]** (tutto poggia su
  `ADR x sqrt`) · **ATR M30 sul FOREX [NON MISURATO]** -> C1 **non** e' proposto
  sul forex, perche' li' il conto di costo non esiste.

---

---

# 🗃️ INDICE DEI 48 ROUND DI `dal_vps/` — **dove sta il verdetto di ognuno** (18/09/2026)

> ## 🔴 **PERCHÉ QUESTA SEZIONE ESISTE, e il motivo è un errore mio di oggi**
> Il 18/09 ho riletto da zero i CSV di `r139a`/`r139b` e ho scritto un referto che
> annunciava i numeri come **nuovi**, denunciando in prima riga la classe 411
> (*«prima di ordinare una misura, si cerca se esiste già»*). **Erano già stati letti
> il 13/09 alle 23:32**, venticinque minuti dopo che i CSV erano atterrati, con gli
> **stessi numeri e gli stessi verdetti**.
>
> 👉 **Ho cercato i CSV. Ho cercato QUESTO registro. Non ho cercato i REFERTI.**
> E chi cerca qui — che è dove si cerca — trovava solo *«file prova pronto, cancello
> deterministico passato»* e concludeva che il numero non esistesse.
>
> ## 📌 **Il difetto non era di misura: era di ARCHIVIO. 48 verdetti vivevano in un referto che il registro non linkava. Questa tabella è la riparazione, e costa zero macchina.**

**Fonte unica di tutte le righe qui sotto**: `report/LETTURA_BACKLOG_NOTTE_2026-09-13.md`,
commit `7aaa9526` del **13/09/2026 23:32 +0200**. Dettaglio cella per cella di
`r136*`/`r137*`/`q770be`/`r138a`/`cemad*` in
`backtest_pipeline/risultati_archivio/R136_R137_LA_NOTTE_CHE_I_CSV_SONO_ARRIVATI_2026-09-13.md`.
CSV: `backtest_pipeline/risultati_prove/dal_vps/<EA>/`, tutti committati il **13/09 23:05-23:07**.

⚠️ **Questa tabella è un INDICE, non un verdetto nuovo**: è generata meccanicamente
dalle righe 105-153 del referto sopra, senza ricopiare nulla a mano. Il verdetto, i
criteri congelati e i buchi dichiarati stanno **lì**, e lì vanno letti prima di citarli.

| round | riga fonte | EA | simbolo/TF | PF IS/OOS | DD% IS/OOS | n IS/OOS | verdetto |
|---|---|---|---|---|---|---|---|
| **r136a** | **r.105** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — S1 riproduce; altopiano di **6 celle** (SLatr 0,6-1,6); **"il default va bene"** |
| **r136b** | **r.106** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — S1 ✓; altopiano 0,25-0,75, **centro 0,50 NON batte il default** |
| **r136c** | **r.107** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — S1 ✓; altopiano 25-50-75 **col centro = cella viva**; la cella NUDA è peggiore |
| **r136d** | **r.108** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ⏸️ **NON MISURABILE** — S1 ✓ ma **il segno si inverte fra IS e OOS** (criterio 1 del file) |
| **cemad02** | **r.109** | EMA200 | U30USD H1 | — / 1,20110 | — / 5,73 | vuoto / 237 | ✅ **PASS** — riproduce l'IS di R112; **132 posizioni MISURATE**; codice 2 = falso allarme |
| **cemad05** | **r.110** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — G0-B ✓; **requisito 5 (TF) CHIUSO**: H1 confermato, M15/M20/M30 bocciati |
| **r137a** | **r.111** | DAX_Apertura_EU | D30EUR M5 | 1,12634 / 1,39709 | 5,44 / 7,23 | 175 / 270 (**193 pos**) | ❌ **A1 FALLITO** — 1 sola cella a-costo passa; **prezzo di R5 misurato** (vedi §3) |
| **r137b** | **r.112** | DAX_Apertura_EU | D30EUR M5 | 1,12634 / 1,39709 | 5,44 / 7,23 | 175 / 270 | ❌ **FAIL** — ramo SKIP: campione a **24 posizioni** e PF **in calo monotono** |
| **r137c** | **r.113** | DAX_Apertura_EU | D30EUR M5 | 1,18323 / **1,49140** | 4,96 / **6,27** | 132 / **193 pos** | ✅ **PASS** — riproduzione 8/8 → **è una FIRMA** |
| **r138a** | **r.114** | DAX_Apertura_EU | **F40EUR** M5 | 1,44028 / **0,76965** | 7,36 / **11,82** | 130 / 195 (**152 pos**) | ❌ **FAIL F3 (rischio)** — DD OOS 11,82% > 10,0%; merito negativo su campione leggibile |
| **q770be** | **r.115** | DAX_Apertura_EU | D30EUR M5 | 1,18323 / 1,49140 | 4,96 / 6,27 | 132 / 193 | ❌ **FAIL soglia** — peggior giornata **invariata** (-1,0793% su 4 celle su 4) |
| **r139a** | **r.116** | EMA200 | AUDJPY H4 (OHLC) | 0,80 / 0,95-1,01 | **15,4-16,9 / 16,9-20,4** | 757-768 / 1292-1345 | ❌ **FAIL S3 (rischio)** — DD > 14,0% su **tutte** le celle, in **entrambe** le finestre |
| **r139b** | **r.117** | EMA200 | GBPUSD H4 (OHLC) | 0,80-0,84 / 1,13 | **17,7-20,3** / 10,1-11,0 | 856-875 / 1292-1321 (**718 pos**) | ❌ **FAIL S3 + S4** — DD IS > 14,0%; **segno opposto su 4 celle su 4 = REGIME, non edge** |
| **r139c** | **r.118** | FiboH4_Multi | GBPUSD H4 (OHLC) | 0,79-0,83 / 0,94-0,97 | **20,7-23,3 / 17,2-17,7** | 548-572 / 725-737 (**643 pos**) | ❌ **FAIL F1 (rischio)** — DD > 14,0% ovunque; PF < 1,00 in entrambe |
| **r141a** | **r.119** | IntradayMomentum | NASUSD M30 | **0,60887** / 1,24334 | 7,76 / 3,03 | **146** / 261 | ⏸️ **NON GIUDICABILE** — IS a **4 operazioni** dal pavimento; segno nettamente discorde |
| **r141b** | **r.120** | IntradayMomentum | U30USD M30 | **0,59938** / 1,03501 | 6,42 / 4,41 | **146** / 261 | ⏸️ **NON GIUDICABILE** — stesso schema del gemello, **identico nei conteggi** |
| **r141c** | **r.121** | AtrExhaustVol | NASUSD M30 | 0,97227 / 1,22915 (cella ATR) | 5,69 / 4,14 | 70 / 96 | ❌ cella PERC **scartata** (C0 + DD 19,25%) · ⏸️ cella ATR non giudicabile (n<150) |
| **r141d** | **r.122** | HVAncora | U30USD M30 | 1,38464 / 1,92073 (k=1,0) | 3,42 / 2,06 | 22 / 31 | ⏸️ **NON GIUDICABILE sul merito** — ma **PASSO 0 RIUSCITO**: il motore opera (vedi §4) |
| **r142a** | **r.123** | Nasdaq_Live5m | NASUSD M5 | 1,01472 / 0,95624 | 12,3 / 22,5 @2% | **116 / 175** (riproduce) | ❌ **merito: scarta** (tutte < 1,10 con n≥150) · ✅ **voce 3 del certificato CHIUSA** |
| **r142b** | **r.124** | Nasdaq_Live5m | NASUSD M5 | 1,01472 / 0,95624 | 12,3 / 22,5 @2% | 116 / 175 (riproduce) | ❌ **merito: scarta** — l'asse morde (+0,11 PF) ma **nessuna cella arriva a 1,10** |
| **r142c** | **r.125** | Nasdaq_Live5m | NASUSD M5 | 1,01472 / 0,95624 | 12,3 / 22,5 @2% | 116 / 175 (riproduce) | ❌ **merito: scarta** — senza trailing il DD OOS sale a **33,62%** @2% |
| **r127c** 🐤 | **r.126** | CostToCost | EURJPY H4 (OHLC) | 1,17686 / 1,52341 | 11,0 / 12,3 | 153 / 242 = **395** | ✅ **PASS — IL CANARINO DELLA NOTTE** (vedi §1) |
| **r127b** | **r.127** | SupertrendRev_Ott | XAUUSD H4 (OHLC) | 0,85447 / 1,12525 | 6,58 / 5,91 | 230 / 427 = **657** | ⏸️ ancora **n 657 esatta** ✅ · merito non giudicabile (OHLC + PF IS < 1,00 su 7/7) |
| **r126a** | **r.128** | SuperWave_DOW_H1 | U30USD H1 | **1,48166** / 1,24312 | 4,04 / 4,17 | 72 / 131 | ❌ **ANCORA GRADO C** — PF IS **1,48166 contro 1,84892** (Δ 0,367 > ±0,15) → **round fermo** |
| **r126b** | **r.129** | SuperWave_DOW_H1 | U30USD H1 | 1,48166 / 1,24312 (lookback 5) | 4,04 / 4,17 | 72 / 131 | ⏸️ **non leggibile** (stesso gruppo) — **ma conferma il determinismo interno** |
| **r126d** | **r.130** | SuperWave | NASUSD H1 | 0,71-1,13 / **0,73-0,84** | 1,72 / 2,7-3,2 | 35-38 / **58-63** | ❌ **FAIL G3+G4** — PF OOS < 1,10 su **9 celle su 9**; n OOS < 95 (pavimento) |
| **r132c** | **r.131** | SupRev_DOW_H1_Ott | U30USD H1 | 0,98846 / 1,38900 (NearAtr 1,0) | 6,17 / 5,91 | 117 / 152 | ❌ **ROUND NULLO** — la riproduzione fallisce su **3 celle su 5** (vedi §5) |
| **r120b11** | **r.132** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 1,48166 / **1,24312** | 4,04 / 4,17 | 72 / 131 | ❌ **G1 metro FALLITO** — PF OOS fuori dalla forbice **1,30-1,55** → le altre 3 celle non si leggono |
| **r120b00** | **r.133** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 0,90317 / 1,18671 | 6,04 / 6,23 | 46 / 90 | ❌ non leggibile (G1 del gruppo) |
| **r120b01** | **r.134** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 1,40616 / 0,98333 | 4,45 / 5,11 | 71 / 125 | ❌ non leggibile (G1 del gruppo) |
| **r120b10** | **r.135** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 1,48914 / 1,24312 | 3,80 / 4,17 | 72 / 131 | ❌ non leggibile (G1 del gruppo) |
| **r120e11** | **r.136** | SuperWave_DOW_H1 | U30USD H1 (**dep 100k**) | 1,39744 / 1,22034 | 3,48 / 4,21 | **106 / 184** | ⏸️ metro del banco — **ha misurato la cosa che spiega tutto** (§5) |
| **r120e00** | **r.137** | SuperWave_DOW_H1 | U30USD H1 (**dep 100k**) | 0,97751 / 1,28437 | 5,07 / 6,53 | 74 / 130 | ⏸️ metro del banco |
| **r133b** | **r.138** | ORB_Ottimizzato | U30USD M30 | 1,24979 / 1,67419 (cella 0) | 7,89 / 9,76 | 71 / 119 | ❌ cella 1 **scartata per rischio** (DD IS **27,21%** > 12,0%) · merito non leggibile (n<150) |
| **r133c** | **r.139** | MaxMinNotte | D30EUR M5 | 1,99749 / 1,01569 (box 0) | 4,89 / 9,05 | 38 / 65 | ⏸️ **NON GIUDICABILE, dichiarato prima** — consegnata la curva Trades(soglia) |
| **P0_IBRETEST** 📦 | **r.140** | IBRetest | U30USD M30 | 0,38242 / 0,69663 | 7,38 / 7,61 | 42 / 53 | ⏸️ archivio — frequenza **0,21 op/g** in banda; merito sospeso; segno negativo concorde |
| **P0IBRTDAX** 📦 | **r.141** | IBRetest | D30EUR M30 | 1,21062 / 0,96493 | 2,80 / 5,25 | 58 / 107 | ⏸️ archivio — merito sospeso (n<150) |
| **P0IBRTNAS** 📦 | **r.142** | IBRetest | NASUSD M30 | 0,56297 / 0,59292 | 5,80 / 5,31 | 35 / 49 | ⏸️ archivio — merito sospeso; segno negativo concorde |
| **P0CONTA (LVN)** 📦 | **r.143** | LVNArbitro | U30USD M30 | 0,97856 / 1,05108 | **18,01** / 11,33 | 392 / 618 | ❌ archivio — **C0 (PF<1,10 con n≥150) + rischio** (DD > 10%) |
| **P0_100K (LVN)** 📦 | **r.144** | LVNArbitro | U30USD M30 | 0,97485 / 1,05227 | **19,35** / 11,76 | 392 / 618 | ❌ archivio — idem, confermato alla taglia 100k |
| **P0CONTA (ORB-B)** 📦 | **r.145** | OpeningReversalB | U30USD M5 | 1,82619 / — | 0,96 / 0,00 | **2 / 0** | ❌ archivio — **bocciato per frequenza** |
| **P0A_FAIL** 📦 | **r.146** | OpeningReversalB | U30USD M5 | 1,82619 / — | 0,96 / 0,00 | 2 / 0 | ❌ archivio — contatori: State1 24-29, State2 16-19, **Entry 2** |
| **P0B_SIGNAL** 📦 | **r.147** | OpeningReversalB | U30USD M5 | 0,00-1,83 / — | ≤0,96 / 0,00 | 1-2 / 0 | ❌ archivio — State1 fino a **49**, ingressi **1-2** |
| **P0C_FT** 📦 | **r.148** | OpeningReversalB | U30USD M5 | 1,75-3,56 / — | ≤0,96 / 0,00 | 2-3 / 0 | ❌ archivio — il PF 3,56 è su **3 operazioni**: numero senza campione |
| **P0_EURCHF** 📦 | **r.149** | Nightly | EURCHF | 0,89113 / 0,81429 | **11,10 / 15,39** | 63 / 85 | ❌ archivio — **BOCCIATO PER RISCHIO** (soglia congelata: DD > 10% su una cella) |
| **R123AGATE** 📦 | **r.150** | SupRev_DOW_H1_Ott | U30USD H1 | 0,98837 / 1,38944 | 6,17 / 5,91 | 117 / 152 | 📦 **ancora d'archivio** (09/09) — termine di paragone di r132c |
| **R123BSTMULT** 📦 | **r.151** | SupRev_DOW_H1_Ott | U30USD H1 | 0,88-2,02 / 0,91-1,42 | 2,9-8,9 / 3,6-12,4 | 97-180 / 112-261 | 📦 ancora d'archivio |
| **R123CATRP** 📦 | **r.152** | SupRev_DOW_H1_Ott | U30USD H1 | 0,56-1,18 / 0,56-1,39 | 4,9-9,1 / 2,8-9,2 | 104-136 / 108-202 | 📦 ancora d'archivio |
| **R123DNEARATR** 📦 | **r.153** | SupRev_DOW_H1_Ott | U30USD H1 | 0,63-1,00 / 0,99-1,39 | 4,6-7,2 / 5,9-6,4 | 64-128 / 122-172 | 📦 **ancora d'archivio — è quella che r132c non riproduce** |

## 🏁 LA LETTURA D'INSIEME, misurata il 18/09 su tutte le **329 celle distinte**

> ### 🔴 **ZERO round su 48 passa tutti e quattro i cancelli di casa. E quello che blocca è SEMPRE lo stesso: il CAMPIONE. Diciannove round arrivano a 3 su 4 fallendo solo lì.**

I sei che il campione lo passano, lo pagano in **rischio**: tre forex a 16,5 anni
(`r139a` 768/1345 deal, `r139b` 875/1321, `r139c` 557/737) e tre a DD alto
(`P0CONTA` e `P0_100K` fino a **29,77% @1%**, `cemad05` fino a **30,71%** a TF basso).

🔎 **E 69 celle distinte su 329 non erano MAI state scritte da nessuna parte**
(test: PF al 3°/5° decimale o P/L al centesimo, cercato in 2.095 file `.md`/`.txt`).
Le tre concentrazioni: `r126a` **14 mute su 18**, `r126b` **10 su 14**, `r127b` **9 su 14**.
⚠️ Nelle altre (`r126d`, `r133c`) le celle mute sono **brutte o minuscole**, e non
scriverle era ragionevole: si dichiara invece di gonfiare il numero.

### 🟠 `r127b` — riletto e chiuso il 18/09, e NON è un'occasione
Segnalato come promettente (*«celle con PF OOS sopra 1,10 su n=427, mai scritte»*).
Riaperti i CSV **da me**: **IS 7 celle su 7 NEGATIVE** (PF 0,792-0,855, DD 6,5-10,2%,
230 deal) contro **OOS 7 su 7 positive** (PF 1,053-1,125, DD 5,9-8,4%, 427 deal).
🔴 **Segno opposto su 7 celle su 7 = `S4`, «REGIME, non edge»** — la stessa forma di
`r139b`. Il PF OOS sopra 1,10 c'era; l'IS che lo uccide non era stato guardato.

### 📚 Chi rileggerei per primo, e perché
1. 🥇 **`r126a` + `r126b`** — fermi su un cancello di **riproduzione**, non su un numero
   brutto: 9/9 e 7/7 celle passano merito+rischio+segno (PF OOS 1,135-1,402, DD@1%
   3,15-4,58%, n OOS 115-139 deal). ⚠️ Il campione resta sotto il pavimento.
2. 🥈 **`r133b`** — PF OOS **1,674**, ma la cella **viva** in IS fa PF 0,523 con DD
   **27,21%**, e il file prova non è mai stato aperto.
3. 🥉 **`r141d`** — passo 0 riuscito; il tappo vero è misurato altrove (91 ancore IS e
   165 OOS che **scadono**).

### ⚠️ Un difetto DEL REFERTO FONTE, trovato il 18/09 e non ancora corretto lì
La riga `r139a` di `LETTURA_BACKLOG_NOTTE_2026-09-13.md` scrive **n OOS 1292-1345**:
il minimo vero è **1322**, e **1292 è di `r139b`** (contaminazione fra righe adiacenti).
Non sposta il verdetto, ma chi cita quel numero citi **questa** riga.

📝 Audit completo: `report/I_QUARANTOTTO_2026-09-18.md`. Riproduzione indipendente
di `r139a`/`r139b` a cinque giorni di distanza, partita dai CSV e non dal referto:
`report/AUDJPY_E_GBPUSD_IL_NUMERO_CHE_MANCAVA_2026-09-18.md` (stessi numeri, stessi verdetti).

---

# 🗃️ R83 e R84 — **ERANO SENZA UNA RIGA IN QUESTO REGISTRO** (aggiunti il 18/09/2026)

🔴 **Perché sta scritto qui**: il 18/09 Claudio ha chiesto *«PROVA IL RETEST SUL NASDAQ»* e io gli
avevo appena detto che *«non risulta mai provato»*. **Era falso**: R83 lo aveva misurato il
18-19/08, con IS, OOS e per-trade in repo. Non l'ho trovato perché **`grep -i r83` su questo
registro dava ZERO**, esattamente come il 13/09 per R139a/b. Il verdetto esisteva in
`report/PIANO_PROP.md` (rr.1149 e 2546) — ma chi cerca un round lo cerca **qui**.

## R83 — DUELLO DEGLI INGRESSI (FIRMA 6 del 18/08) · EA `ABTG_Apertura_3Ingressi`
**La domanda**: *«a parità ASSOLUTA di livello, orario, stop, gestione e uscite, quale STILE
D'INGRESSO regge meglio su QUESTO mercato?»* · finestra `@DAQUANDO 2024.09.26`, M15, tick reali
(modello 4) · canarini di equivalenza al centesimo su entrambi i core (**291/291** e **311/311**
trade identici).
CSV: `backtest_pipeline/risultati_archivio/r83_csv/` · file prova: `prove/R83n*.txt`, `R83d*.txt`
· criteri congelati: `prove/R83_INGRESSI_CRITERI.md`.

| cella | mercato | stile | IS PF | IS n | OOS PF | OOS n | OOS DD% | OOS profit |
|---|---|---|---:|---:|---:|---:|---:|---:|
| `r83n0` | NASUSD | STOP oltre il livello *(lo stile VIVO)* | 1,2537 | 156 | 0,8731 | 291 | 17,070 | −795,03 |
| `r83n1` | NASUSD | **LIMIT sul RETEST** | 0,9465 | 187 | **0,6239** | 303 | **29,137** | **−2.411,28** |
| `r83n2` | NASUSD | MARKET a chiusura oltre | 0,7046 | 198 | 0,9785 | 313 | 6,178 | −91,83 |
| `r83d0` | D30EUR | STOP oltre il livello | 1,0467 | 220 | 1,0409 | 325 | 13,262 | +251,22 |
| `r83d1` | D30EUR | **LIMIT sul RETEST** | 1,0781 | 197 | **1,1878** | 311 | 10,598 | **+999,42** |
| `r83d2` | D30EUR | MARKET a chiusura oltre | 0,8038 | 212 | 0,9842 | 322 | 8,688 | −82,77 |

### 🎯 VERDETTO — **la stessa regola d'ingresso CAMBIA SEGNO fra i due mercati**
- 🟢 **DAX: il RETEST vince**, ed è l'unica cella positiva in tutte e due le finestre. **Incorona
  la config della sedia viva `770101`** — il cambio BREAKOUT→RETEST del 7 agosto.
- 🔴 **Nasdaq: il RETEST è il PEGGIORE dei tre**, e di parecchio: PF OOS **0,624** su 303 trade,
  DD **29,14%** (il più alto del round). **Zero modalità positive su tre.**
- 📌 **Regola che ne esce, ed è generale**: *ogni estensione a un altro indice RIFA' il duello,
  non eredita il RETEST.*

### 🔬 Il MECCANISMO, ricontato sui per-trade il 18/09 (aggregato per POSIZIONE, non per deal)
| cella | posizioni | % vinte | vincita media | perdita media | **\|vinc./perd.\|** |
|---|---:|---:|---:|---:|---:|
| RETEST Nasdaq (`777021`) | 260 | 70,4% | +21,85 | −84,35 | 🔴 **0,259** |
| STOP Nasdaq (`777011`) | 241 | 72,2% | +31,38 | −96,23 | 0,326 |
| RETEST DAX (`777121`) | 245 | 73,9% | +34,92 | −83,15 | 🟢 **0,420** |

👉 **Il RETEST sul Nasdaq vince spesso e piccolo, perde di rado e pieno.** Sul rapporto che
conta peggiora pure lo stile vivo (0,259 contro 0,326). Sul DAX fa l'opposto (0,420, il migliore).
⚠️ `PIANO_PROP.md` r.1149 riporta l'autopsia come *«74/78 perdite = stop pieni 1R contro vincite
medie 0,18R»*: **numeri diversi dai miei perché contati per DEAL** (303 deal = 260 posizioni,
classe 226). Stessa conclusione, unità diversa — **e va detto quale si sta citando.**

## R84 — ABLAZIONE DEI CRITERI (metodo completo del corso) · NASUSD M15, tick reali
Nove celle (`r84a`…`r84i`), stessa finestra. **9/9 celle OOS negative.** Cella `A` (scheletro
nudo): 241 posizioni, PF 0,873, DD osservato 17,07%. La cella `D` (volumi OR ATR) passa tutti e
quattro i cancelli congelati (PF 1,104 vs 0,988, DD dimezzato, n=311) **pur restando OOS-negativa**
→ riduttore di perdita, **mai edge**.
CSV: `backtest_pipeline/risultati_archivio/r84_csv/` · prove: `prove/R84*.txt` · criteri:
`prove/R84_ABLAZIONE_CRITERI.md` · distribuzione del DD per riordino delle 9 celle:
`report/IL_DRAWDOWN_CHE_NON_ABBIAMO_MISURATO_2026-09-18.md` §10.

### 🔴 RIMANDO OBBLIGATORIO — **R83 NON è tutta la storia del retest sul Nasdaq**
Lo stesso giorno (18/09) si è scoperto che `InpEntryMode=2` su NASUSD è misurato anche nel
**walk-forward** (`Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv`, magic **`770201`**, il
core vero) — e lì **due celle sono POSITIVE** (volumi ON: IS PF 1,145 n=91 · OOS PF 1,109 n=94).
🔴 **Non è una contraddizione: è un SETUP DIVERSO** (`InpRangeMode` 0 contro 2, `InpRangeMinutes`
35 contro 15, `InpTP1_R` 0,5 contro 1,0, EA diverso). La riconciliazione completa, con il diff
parametro per parametro e i cancelli applicati a ognuna, sta in
**`report/IL_RETEST_SUL_NASDAQ_LA_RICONCILIAZIONE_2026-09-18.md`**.
👉 **Chi cita R83n1 come «il retest sul Nasdaq» cita metà della misura.**

### 🎯 CONSEGUENZA CONGIUNTA R83+R84 sulla sedia `770201`
**12 configurazioni, 12 OOS negative** = **terzo verdetto indipendente**. È la misura che sostiene
la **FIRMA 5** (`770201` 🔴 **[SENZA CONTRATTO]**, spenta dal 18/08 09:41 —
`report/CONTRATTI_SEDIE.md` r.54).

---

## R180 — DUELLO DEGLI INGRESSI **SUL DOW** (U30USD) · ⏳ **PREPARATO, NON ANCORA GIRATO** (18/09/2026)
Estensione di **R83** al terzo indice, come prescrive la regola che R83 stesso ha prodotto:
*«ogni estensione a un altro indice RIFÀ il duello, non eredita il RETEST»* (riga 3412).
R83 ha duellato su **D30EUR** e **NASUSD**; **su U30USD mai**.
File prova: `prove/R180u{0,1,2}[b]_*_U30USD.txt` + `prove/R180uV_canarino_vivo_U30USD.txt` ·
generatore: `prove/R180_GENERA.py` · criteri congelati: `prove/R180_DUELLO_DOW_CRITERI.md` ·
referto: `report/DUELLO_GEMELLI_DOW_SPX_2026-09-18.md` · censimento:
`backtest_pipeline/censimento_entrymode.py`.

**Il censimento meccanico (2.376 CSV, 368 con `InpEntryMode`) — cosa esiste già su U30USD:**

| modalità (semantica) | misurata? | n | PF | DD |
|---|---|---|---|---|
| BREAKOUT (stop) | ✅ SÌ (96 + 143 celle) | fino a 471 · 106-113 | max **0,997** · 1,106-1,214 | fino a **15,7%** |
| **RETEST (limit)** = la sedia viva `770202` | ✅ SÌ, **6 corse** (`r6` `r35` `r46b` `r47c` `r47d` `ptc` `csv_r54`) | IS 56-150 / OOS 96-218 | IS 0,77-1,38 / **OOS 1,01-1,68** | 2,5-9,9% |
| **CLOSECONFIRM (market a chiusura)** | 🔴 **MAI** | — | — | — |
| FADE | ✅ SÌ | 324 | **0,806** | **19,7%** |
| DELAYED | ✅ SÌ (157 celle) | 2-168 | max **0,978** | fino a **24,3%** |

👉 **Non manca il retest: manca il CONFRONTO AD ARMI PARI** (quelle sei corse hanno finestre,
filtri e scopi diversi) **e manca la CLOSECONFIRM**, mai girata su questo simbolo.

🪤 **TRAPPOLA DA RICORDARE — `InpEntryMode` non significa la stessa cosa nei due EA:**
`ABTG_Dow_Apertura_US` (`ENUM_ABTG_ENTRY`) **2 = RETEST**; `ABTG_Apertura_3Ingressi`
(`ENUM_ABTG_STYLE`) **1 = RETEST**, **2 = CLOSECONFIRM**. Ponte in `ABTG_Apertura_3Ingressi.mq5`
r.561-565. Chi copia il numero invece del significato misura un'altra strategia.

🟢 **DUE COSE TROVATE E MAI SCRITTE PRIMA:**
1. **Il PASSO 0 di R83 sul Dow è già risolto** — `risultati_archivio/ABTG_StoricoScaricato.csv`
   (commit `70b289d5`, 08/09/2026): `U30USD,TICK,68558736,2024.09.26,-,COMPLETO` e
   `D30EUR,TICK,35496307,2024.09.26,-,COMPLETO`. **NASUSD e SPXUSD no.**
2. **Il pavimento dei 150 si supera SOLO coi due lati**: misurato su `r6` (retest, range 35):
   solo long **74 IS / 130 OOS** (204 in tutto, irraggiungibile); due lati **147 IS / 203 OOS**
   (350) → a taglio 0,50 ≈ **175/175**, sopra il pavimento tutte e due. Per questo il round ha
   **due famiglie** (`L` solo long @0,40 = la cella viva · `B` due lati @0,50).

**Magic vergini** 777410/411 · 777420/421 · 777430/431 · 777440/441 · 777450/451 · 777460/461 ·
777490/491 — verificati con `grep -rIl --exclude-dir=.git -w "<m>" .` → **0 file per tutti e 14**.
**Cancello strato 1**: `controlla_prova.py` → 7 file, 14 celle, **0 problemi, ESITO OK**.
**Costo [STIMA]**: 28 passate → **2,3-10,5 min** (basi misurate R88a 0,083 e R112 0,375
min/passata); si pianifica **15 min**. 🔴 **[NON MISURATO]** la cache tick al primo avvio.

🛑 **Cosa NON misura**: robustezza di regime (21 mesi, un regime e mezzo, niente 2020/2022 — BCM
non ha di più); il pavimento dei 150 sulla famiglia L (**non lo supera, atteso 74/130**);
lo slippage (`InpSlippagePts=0` → **la modalità 0 è avvantaggiata**, e se vince ha l'asterisco);
spread di prop, requote, rifiuti. E **non è confrontabile riga per riga con R83**: lì i filtri
erano spenti, qui l'EMA della cella viva è **accesa** (1/50 su H4).

## R185 — SONDA SU **SPXUSD** · 🔴 **IL DUELLO SPX NON PARTE FINCHÉ NON RISPONDE** (18/09/2026)
Criteri: `prove/R185_SONDA_SPXUSD_CRITERI.md`. **Nessun file prova di duello è stato scritto**, e
la ragione è misurata: sul **motore delle aperture**, su SPXUSD, **ZERO righe in tutto il repo**.

🪤 **Falso positivo da non ripetere**: `grep SPXUSD` sui CSV risponde SÌ in decine di file — ma è
il valore della colonna **`InpCorrSymbol`** (filtro di correlazione, per giunta **spento**), **non**
il simbolo negoziato. L'unica cosa davvero girata su SPXUSD è `ABTG_GoldenCross` (H1/H4).

| domanda | oggi |
|---|---|
| BCM quota SPXUSD | ✅ SÌ |
| profondità **BARRE** | ✅ **2024.09.26 `COMPLETO`** (sonda 17/08) |
| profondità **TICK REALI** | 🔴 **MAI MISURATA** |
| specifiche di contratto (lotto min, valore punto, spread) | 🔴 **MAI MISURATE** |

Tre cancelli congelati: **Q1** tick (PASS / PARZIALE con finestra riscritta / FAIL → solo OHLC
dichiarato come screening, **mai** verdetto) · **Q2** pavimento del lotto (classe 229: se il lotto
minimo rischia >1%, PF e DD descrivono una taglia che non esiste) · **Q3** frontiera del costo
`stop >= 40 x spread` (se M5 la sfonda → **escluso PER COSTO, col numero accanto**, duello su
M15/M30). Strumento: `scarica_storico.ps1` (nessuno script nuovo).
📌 `SPXUSD_EXT` (M1 2010→2026, import del 26/08) **non serve qui**: OHLC, altro simbolo, marcato
*«solo prova di regime»*. **Costo [STIMA, NON MISURATO]**: 30-180 min per simbolo.
🔴 `scarica_storico.ps1 -Auto` **senza** `-TerminaleBacktest` chiude **TUTTI** i terminali, compreso
il **REALE 10105439**: sul VPS è obbligatorio `-TerminaleBacktest "C:\MT5_Backtest"` (demo 50504400).

---

## 🔬 R183 — LA CROCE DELLE SLIDE: conferma di VOLUME sull'ingresso a CHIUSURA (NASUSD)
**18/09/2026 · PREPARATO, NON ANCORA GIRATO.** EA `ABTG_Apertura_3Ingressi` · NASUSD M15 ·
`@DAQUANDO 2024.09.26` · tick reali modello 4 · taglio IS/OOS 0,40 — **le stesse condizioni
di R83/R84**, corpo estratto meccanicamente dalle 78 righe di `prove/R83n2_conferma_NASUSD.txt`.
Criteri congelati PRIMA dei numeri: `prove/R183_CROCE_SLIDE_CRITERI.md` ·
dossier: `report/R183_LA_CROCE_DELLE_SLIDE_LA_GRIGLIA_2026-09-18.md`.

**LA DOMANDA:** la conferma di VOLUME delle slide, attaccata all'ingresso che le slide
prescrivono (MARKET alla CHIUSURA della candela di rottura), **aggiunge edge o taglia e basta?**

**LE CELLE (11 celle · 22 passate · `controlla_prova.py` ESITO OK · stima 2-9 min macchina):**
| file | asse | celle | magic (vergini, `grep -rnoE "7793[5-9][0-9]" .` → 0) |
|---|---|---:|---|
| `prove/R183a_volmult_closeconf_NASUSD.txt` | `InpVolMult` 1,00/1,25/**1,50**/1,75/2,00 | 5 | `779350` |
| `prove/R183b_volavgbars_closeconf_NASUSD.txt` | `InpVolAvgBars` 10/**20**/30/40 | 4 | `779360` |
| `prove/R183c_canarino_baseline_NASUSD.txt` | `InpMagic` (asse tecnico, cancello G1) | 2 | `779370`·`779371` |

**BASELINE DA BATTERE** (R83n2, stesso EA, filtri spenti): IS PF 0,70462 n=198 DD 9,4841 ·
**OOS PF 0,97849 n=313 DD 6,1775**.

### ✅ LA CASELLA È VUOTA — ricontata a macchina
Censimento su **368 CSV / 18.410 righe** (worktree `.claude` esclusi): su NASUSD **tutte** le
righe con ≥1 filtro acceso hanno `InpEntryMode=0` (**610 righe**); le righe a ingresso CHIUSURA
sono **4** (`R83n2`: 2 gemelle x 2 finestre), tutte a filtri spenti. 🔴 **Ma il primo giro del censimento deduceva il simbolo dal
PERCORSO e saltava 73 file in silenzio** (classe 430, applicata a se stessi): rifatto senza
filtri di simbolo, sono emersi i **vicini di casella, che sono misurati e dicono di no**.

### 🔴 I VICINI, MAI CITATI PRIMA — `Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` (core `770201`)
| motore (enum del CORE) | volumi | IS PF · n | OOS PF · n |
|---|---|---|---|
| OPENCONFIRM (5) | ON | **1,816** · 108 | **0,956** · 104 |
| DELAYED (4) | ON | **1,710** · 56 | **0,696** · 51 |
| RETEST (2) | ON | 1,145 · 91 | 1,109 · 94 |

**Tre casi su tre: IS che brilla, OOS che non regge, campione dimezzato (240→104 · 247→51 ·
240→94).** 👉 Il `PF 1,200` di `DELAYED+volumi` del 05/08 (`Openconfirm/MOTORI_INGRESSO.md`,
*«il tipo di coincidenza che di solito non è coincidenza»*) **fuori campione fa 0,696: era
rumore**, ed è ora documentato. ⚠️ `InpEntryMode=2` vuol dire **CLOSECONF** nel `3Ingressi` e
**RETEST** nel core: due enum diversi, mappatura del core verificata **contro i numeri**.

### 🔌 DUE DEI TRE ASSI CHIESTI SONO **INERTI** — e non si lanciano
`InpUseAtrFilter` e `InpConfirmMode` vivono solo in `ConfirmOK()` (r.2518-2526), chiamata a
r.1116/1208/1314/1764 — **mai dal ramo CLOSECONFIRM**, che usa `VolumeOKtf(cftf)` (r.1594) e
nient'altro. Su `InpEntryMode=2` **non vengono letti mai**: 8 passate identiche al centesimo.
✅ Il claim *«`InpConfirmMode` inerte sotto i due filtri, r.2410»* è **vero** (r.2410 del core,
r.2525 del `3Ingressi`) **ma insufficiente**: lì non si sveglia **nemmeno** accendendone due.
📌 **Difetto di classe NUOVA: `CHECKLIST_RIGA_DI_LANCIO.md` classe 431** (ultima era la 430).
🕳️ **Buco dichiarato**: la metà **ATR** della regola delle slide **non è misurabile col codice
di oggi**. Costa **una riga** (`VolumeOKtf(cftf)` → `ConfirmOK()`): **decisione di Claudio**.

### 🎯 ATTESA E SOGLIE, congelate PRIMA
Attesa: PF OOS **1,00-1,10** con `n` **110-175** a VolMult 1,50. **Previsione onesta scritta
prima: il round finirà con «sovra-filtro» o con «il default nudo va bene uguale».**
Soglie: `n` OOS **≥150** (merito) · **≥157** (anti-sovra-filtro) · **altopiano di ≥3 celle,
mai il picco** · segno non ribaltato IS/OOS · DD OOS **≤6,18%** · **confronto col default
obbligatorio** (±0,05 → «i filtri non aggiungono») · **G1**: se `R183c` non riproduce R83n2 al
centesimo **ci si ferma**.
🧪 **Contro-esempio**: PF monotono crescente **e** `n` monotono decrescente **senza ottimo
interno** = **taglio**, si scrive «taglio» qualunque sia il PF. Modello del sovra-filtro già in
casa: `DELAYED+volumi` IS 1,710 n=56 → OOS 0,696 n=51.

🚫 **R183 NON PROMUOVE NIENTE E NON RIACCENDE NIENTE.** La sedia `770201` resta **SPENTA** e
🔴 **[SENZA CONTRATTO]** (PF 0,82 · DD 17% · 19/20 celle OOS negative — FIRMA 5 del 18/08).
Nessun backtest eseguito, nessun EA/preset/forward toccato, niente sul conto reale `10105439`.
📌 Nota d'archivio: **`R84BIS_B1/B2` (sensibilità a `InpVolMult` sul Nasdaq) è stato preparato
il 18/08 e MAI GIRATO** — zero CSV nel repo. R183a è la prima misura di quell'asse.

---

## 🌙 R187 — `ABTG_MaxMinNotte` su **NASUSD**: la casella era LIBERA, non provata (19/09/2026)

**Origine**: screenshot dei colleghi di Claudio sul Nasdaq — i livelli a grafico sono
`Max sett. prec. · Max notturno · Max giorno prec. · Apertura giorno · Min notturno`, e il nostro
EA delle aperture sul Nasdaq **non usa nessuno di questi**. Sullo stesso livello (candela H1
prec. / range dei primi N minuti) abbiamo già provato **tre ingressi diversi e perdono tutti e
tre**: breakout PF OOS **0,873** · retest **0,624** · fade **0,930**.
👉 **Quando tre ingressi diversi sullo stesso livello sbagliano, l'indiziato è il LIVELLO.**

### 🏺 CENSIMENTO (per CONTENUTO, non per nome) — `ABTG_MaxMinNotte` non è MAI girato su NASUSD

| simbolo | CSV in archivio | catena di prova |
|---|---:|---|
| `D30EUR` | **24** | `ini/valid_MaxMin_D30EUR.ini` · `prove/R103_*_770411.txt` · `r81_csv/` |
| `XAUUSD` | **14** | `maxmin_oro.ps1 -Sym XAUUSD` · `prove/R103_*_770402.txt` |
| `EURUSD` | 2 | `prove/ABTG_MaxMinNotte.txt` |
| `F40EUR` · `E50EUR` · `100GBP` | 1 + 1 + 1 | `rilancia_maxmin_indici.ps1 $Targets` |
| 🔴 **`NASUSD`** | **0** | **nessuna corsa, nessun `.ini`, nessun file prova, nessun file in `git log`** |

🔴 **Il simbolo NON è dentro i CSV** (`OnTesterDeinit`/`FrameInputs` scrive solo gli INPUT), e
`InpCorrSymbol=SPXUSD` compare su **43 CSV su 43** mentre le corse su `SPXUSD` sono **ZERO**:
un `grep SPXUSD` dà il **100% di falsi positivi**. → **classe 444** della checklist.
🟠 E l'occasione era in piena vista: `scan_market.ps1` r.54 ha **`NASUSD` nella lista simboli di
`ABTG_MaxMinNotte`** — la scansione era *scritta* e **mai lanciata**.

### 🟢 CORREZIONE A UNA CREDENZA DI CASA — i tick di NASUSD **sono misurati**
`ABTG_StoricoScaricato.csv` non elenca `NASUSD`, ma
`risultati_archivio/misura_tick/REFERTO_MISURA_TICK_NASUSD.txt` (30/08/2026) sì:
**tick reali dal `2024.09.26`, 166.509.474 tick**. → il round gira a **modello 4**, **non** è
`[SOTTO SONDA]`.

### 📋 I DUE FILE PROVA (pronti, `controlla_prova.py` **OK**, ASCII puro, 52 pin, 2 celle ciascuno)
| file | box (ora server) | piazza | cutoff | flat | magic |
|---|---|---|---|---|---|
| `prove/R187a_notteEU_MaxMinNotte_NASUSD.txt` | 23:00-04:59 | 07:59 | 08:30 | 17:30 | `761600/761601` |
| `prove/R187b_notteUS_MaxMinNotte_NASUSD.txt` | 23:00-14:29 | 14:29 | **15:50** | **20:45** | `761610/761611` |

Gestione **copiata verbatim** dalla cella viva `770411`. Due sole deviazioni, **dichiarate come
scelte**: `InpAllowLong` false→**true** (regola dei DUE LATI, firmata 25/08, bloccante su
Nasdaq/DAX/Dow) e `InpUseCorrelation` true→**false** (il filtro guarda `SPXUSD`: sul DAX chiede
*«tira l'America?»*, sul Nasdaq chiede *«tira il Nasdaq?»* — **non è lo stesso meccanismo**).

### 📐 ATTESA CONGELATA PRIMA DEI NUMERI
**n = 180, banda 120-220**, ricavato per **due strade indipendenti che coincidono**
(`41 × 2,38 × 1,84 = 179,5` e `255 × 0,7047 = 179,7`, basi: R103 r.81 e
`080957cf-valid_MaxMin_D30EUR.csv`).
🔴 **PF atteso: NESSUNO.** Le tre prove di questo motore **fuori dal DAX** fanno **0/54 celle
positive tutte e tre** (`100GBP` 0,6717 · `E50EUR` 0,8398 · `F40EUR` 0,9985, rr.2526-2528):
**la base storica è NEGATIVA**, e va scritto prima della corsa.

### 🛑 SOGLIE DI `n`, e il verdetto che NON si può scrivere
`n ≥ 150` merito leggibile · `50-149` merito **sospeso** (rischio leggibile lo stesso) ·
🔴 **`n < 50` → «NON MISURATO — FINESTRA SBAGLIATA», MAI «non funziona»** · `n = 0` → difetto di
configurazione. Se `a` e `b` si dividono sulla soglia, **il round ha misurato l'OROLOGIO, non il
livello**, e il livello resta NON MISURATO.

### 💰 COSTO E CANCELLI
**Stima 15-25 minuti** (base **misurata**: 0,7 min/passata su `MaxMinNotte D30EUR` M15 a tick
reali, `R104_REFERTO_DRIVER_20260825_0738.txt` r.15, **scalata ×4,69** perché `NASUSD` ha 166,5 M
tick contro i 35,5 M di `D30EUR` nella stessa finestra). Banco `C:\MT5_Backtest` (demo
`50504400`). Cancello di costo: `stop 100,25 idx / spread 1,90 p95 =` **52,8×** → 🟢 PASS (+32%),
**ma l'ATR di `NASUSD` è `[INFERITO]`**: il cancello regge finché l'ATR(M15) vero è ≥ **30,4 idx**.

📄 Referto: `report/R187_IL_LIVELLO_NOTTURNO_SUL_NASDAQ_2026-09-19.md`
🛑 **Nessun backtest eseguito, nessun EA/preset/forward toccato, nessuna taglia e nessuna
accensione proposta, niente sul conto reale `10105439`.**

---

## 🚪 R81 — USCITE `770411` (D30EUR) — **girato il 18/08/2026, MAI REGISTRATO FINO A OGGI**

**Riga aperta il 19/09/2026** durante il censimento delle uscite della rosa. Il round esiste, è
girato, i CSV sono in archivio (`backtest_pipeline/risultati_archivio/r81_csv/`) — e in questo
registro compariva **una volta sola, come nome di cartella** in una colonna "catena di prova"
(r.3611 della versione precedente): **nessun numero, nessuna variante, nessun verdetto.**
È il difetto che il CERTIFICATO DI MORTE del 09/09 vuole impedire, nel verso opposto: non un
morto senza certificato, ma **una misura viva che nessuno sapeva di avere**.

**Che cos'era**: sei varianti di USCITA a **ingressi identici** su `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`,
D30EUR M15, tick reali, deposito 100.000, `InpRiskPercent` 1,0, finestra 2024.09.26 → 2026.06.30
(`@FRAZIONEIS` 0,40). Ogni variante con **due gemelli G1 sul magic** (778110…778161), tutti usciti
identici al centesimo.

| variante | gestione | IS `PF / DD% / Trades` | OOS `PF / DD% / Trades` |
|---|---|---|---|
| `r81a` **= la sedia viva** | scala piena | 1,87803 / 3,0977 / 20 | 2,15985 / **1,9213** / 21 |
| `r81b` | tutta SPENTA | 2,37960 / 7,0155 / 13 | 2,20206 / 6,1401 / 14 |
| `r81c` | **solo breakeven** | **2,92019** / 4,0891 / 20 | **2,69515** / 3,7338 / 22 |
| `r81d` | scala, trail 3,5×ATR | 2,17327 / 3,2509 / 20 | 1,78521 / 2,4583 / 21 |
| `r81e` | scala, trail 1,0×ATR | 1,03072 / 3,4144 / 16 | 1,48580 / 3,1023 / 15 |
| `r81f` | spenta, TPfinal 2R | 1,16955 / 7,0155 / 13 | 1,87505 / 4,0753 / 14 |

### 🛑 IL VERDETTO, e non è una promozione
**`r81c` batte la sedia viva in TUTTE E DUE le finestre** (PF +0,54 in IS, +0,54 in OOS), pagando
~1-2 punti di DD. 🔴 **E NON SI PROMUOVE**, per una ragione misurata lo stesso giorno: i file
per-trade dello stesso round dicono che quelle sono **14 POSIZIONI**, non 21 trade — la colonna
`Trades` conta i **deal in uscita** (classe **454**). A 14 posizioni il **MERITO È SOSPESO**
(valvola R59) e mezzo punto di PF **è rumore fino a prova contraria**. Il RISCHIO invece si legge
a qualunque `n`: il DD raddoppia (1,92 → 3,73 in OOS), e il DD basso è il patrimonio di questa
sedia.
**Stato: `NON ANCORA MISURATO` sul merito, `MISURATO` sul rischio.** Nessun preset toccato.

### ✅ E COSA SPUNTA DEL CERTIFICATO
Casella 3 — *«la gestione dell'uscita è stata messa ad asse?»* — su `770411`: **PIENA**, da un
mese. Ciò che resta aperto su questa sedia è **dove** (`InpTP1_R`, `InpTP2_R`), **quanto largo**
lo stop (`InpAtrSLmult`, mai mosso su QUESTO binario) e **quanto vive l'ordine**
(`InpEntryCutoffMin`, mai mosso in nessuno dei 20 CSV).

---

## 🕓 R191 — LE USCITE DELLA ROSA: due round SCRITTI, non ancora girati (19/09/2026)

| round | sedia | asse | celle × 2 gambe | ancora | deposito |
|---|---|---|---:|---|---|
| `R191a` | **`770411`** D30EUR M15 | `InpEntryCutoffMin` 10/30/50/70/90 | **10 passate** | cella **30** = `r81a` | **100000** |
| `R191b` | **`770511`** U30USD H1 | `InpTP_RR` 1,50 → 6,00 passo 0,75 | **14 passate** | cella **3,00** = `r120e11` | **100000** |

📐 **ATTESE E SOGLIE congelate PRIMA dei numeri, dentro i file prova.** In sintesi:
`R191a` — nessuna cella con **meno `Trades` dell'ancora** è promuovibile a nessun PF (è la difesa
contro il filtro travestito da uscita); scarto a `DD > 8,0%`; merito **sospeso in partenza**
(~27 posizioni totali). `R191b` — scarto a `DD > 8,0%` e a `PF < 1,10` dove `Trades ≥ 150`; e
🔴 **il round non può promuovere nulla comunque**, perché `770511` è al **96% del pavimento di
costo** (38,5× contro 40×) e `InpTP_RR` non tocca lo stop.

💰 **Costo: 24 passate.** `R191a` = 10 × **0,700 min/passata MISURATI sullo stesso EA/simbolo/TF/
modello** (`risultati_archivio/R104_REFERTO_DRIVER_20260825_0738.txt` r.15) = **7,0 min**.
`R191b` = 14 × 0,700 (estremo alto) = **9,8 min**; la base vicina misurata (0,083 su U30USD tick)
darebbe 1,2 min. **Totale dichiarato: ~17 minuti.**

🔒 Magic vergini `787410` / `787420` (grep su tutto il repo: zero). Etichette `r191a` / `r191b`:
zero. Cancello primo strato: `controlla_prova.py` **0 problemi**, `controlla_riga.py --oggetto
prova` **nessun difetto meccanico**. ⏳ **Secondo strato (`controllo-preventivo`) non ancora
lanciato: finché non torna, non si manda niente al VPS.**

📄 Referto: `report/USCITE_DELLA_ROSA_2026-09-19.md`
🛑 **Nessun backtest eseguito, nessun EA/preset/forward toccato, nessuna taglia e nessuna
accensione proposta, niente sul conto reale `10105439`.** Bersaglio: banco `C:\MT5_Backtest`,
demo `50504400`.

---

## 🌍 R192 — ALLARGARE LA ROSA: **simbolo × TF scavato in archivio**, e l'unica casella ancora libera (19/09/2026)

**Origine**: bussola del 1° ottobre e `report/FREQUENZA_DELLA_ROSA_2026-09-19.md`
(*nessuna famiglia raggiunge 1,00 op/giorno*). Censimento di **2.376 CSV**, di cui **315** dei tre
motori della rosa, letti cella per cella con IS↔OOS appaiati sullo stesso `Pass`, `ohlc` esclusi.
📄 Referto: `report/ALLARGARE_LA_ROSA_2026-09-19.md`

### 🟢 IL RISULTATO CHE CAMBIA IL QUADRO: la famiglia Aperture il pavimento **lo supera già**
`ABTG_Dow_Apertura_US` è lo **stesso motore** di `ABTG_DAX_Apertura_EU` (r.53 del sorgente Dow;
tutti e tre montano `ABTG_ApertureCore.mqh`). Contata come **famiglia**, in **POSIZIONI**, sul
backtest OOS a tick reali:

| gamba | posizioni OOS | gg lav | op/gg |
|---|---:|---:|---:|
| `770101` D30EUR ora 08 | **193** | 276 | **0,699** |
| `770202` U30USD ora 14:30 | **96** | 276 | **0,348** |
| **famiglia** | **289** | 276 | 🟢 **1,047** |

🔴 **Ma in campo la stessa famiglia fa 0,834**, perché `770202` ha fatto **4 posizioni in 31 giorni
lavorativi (0,129/gg)** contro le 0,348 promesse — **fattore 2,7**, ultima operazione 28/08.
👉 **La via più corta a +0,22 op/giorno di tutto il dossier non costa un minuto di macchina: è
capire cosa sta facendo quella sedia.**

### 📏 LA MISURA CHE MANCAVA A TUTTI — il rapporto deal→posizioni, **MISURATO**
Sei file per-trade in `risultati_prove/trades_portafoglio/`, mai aperti da nessun referto.
`position_id` distinti contro la colonna `Trades`:
`DAX_Apertura_EU` D30EUR **270/193 = 1,399** · `Dow_Apertura_US` U30USD **130/96 = 1,354** ·
`MaxMinNotte` D30EUR 21/14 = 1,500 · `MaxMinNotte` XAUUSD 92/68 = 1,353 ·
`SupertrendReversal` 225JPY 50/31 = 1,613 · 🟢 **`ORB_Ottimizzato` U30USD 119/119 = 1,000**
(l'unico **senza parziale** — è il contro-esempio che prova che il rapporto misura la parziale e
non il lettore). Chiude in parte il `[NON MISURATO]` dichiarato da
`report/QUANTI_SIMBOLI_PASSANO_2026-09-19.md`.

### ⚪ TRE **NON ANCORA MISURATI**, NON TRE MORTI — `MaxMinNotte` sui gemelli europei
✏️ **RICLASSIFICATO IL 22-23/09/2026: il titolo diceva «TRE MORTI COL CERTIFICATO COMPLETO», e
il certificato NON era completo — manca il punto ⑤.**

🟢 **I numeri reggono tutti alla riverifica sul CSV, e restano scritti**: `F40EUR` · `E50EUR` ·
`100GBP`, **72 passate ciascuno**, modello **tick**, **`InpRiskPercent=1`**, asse su
`InpBufferPoints` (500/1000/1500) × lati × `InpTP2_R` (1,5-4,0), **ZERO celle con PF ≥ 1,10 su
tutti e tre** (e zero sopra **1,00**), PF massimo **0,99852 / 0,83979 / 0,67170**, DD fino a
**40,67% / 35,25% / 48,26%** — che alla taglia FTMO del 2,00% valgono **~80% / ~69% / ~94%**.
Fonti: `risultati_archivio/MaxMinNotte/{4528c79b,8eefb007,efe054b5}-valid_MaxMin_*.csv`.

🔴 **MA IL PUNTO ⑤ E' VUOTO, ED E' MISURATO: `InpMgmtTF` vale `15` in 216 passate su 216.**
(Le tre griglie, aperte una per una il 22-23/09: nessuna delle 72+72+72 righe porta un valore
diverso.) 👉 **`InpMgmtTF` e' la manopola di TF che su questo motore entra nei numeri**, ed e'
rimasta inchiodata a **M15** in ogni corsa mai fatta sui gemelli europei. Per il certificato
del 09/09 e per la direttiva del 22/09 il verdetto e' quindi:

| simbolo | ① PF | ② n e DD | ③ uscita ad asse | ④ gemelli | ⑤ TF **per nome** | **verdetto** |
|---|:-:|:-:|:-:|:-:|---|---|
| `F40EUR` | ✅ 0,99852 (tick) | ✅ 112 · 10,12% @1% | 🟡 solo `InpTP2_R` | ✅ | 🔴 **solo `InpMgmtTF`=M15** | ⚪ **NON ANCORA MISURATO** |
| `E50EUR` | ✅ 0,83979 (tick) | ✅ 80 · 13,90% @1% | 🟡 solo `InpTP2_R` | ✅ | 🔴 **solo `InpMgmtTF`=M15** | ⚪ **NON ANCORA MISURATO** |
| `100GBP` | ✅ 0,67170 (tick) | ✅ 82 · 16,03% @1% | 🟡 solo `InpTP2_R` | ✅ | 🔴 **solo `InpMgmtTF`=M15** | ⚪ **NON ANCORA MISURATO** |

### 🧪 IL CONTRO-ESEMPIO, costruito CONTRO questa riclassificazione
**L'argomento che difenderebbe il «morto»:** *«0 celle su 216 sopra 1,00, con DD che alla taglia
di campo arrivano al 94%. Nessun cambio di TF di gestione recupera 30 punti di PF: e'
accanimento, e la regola del 19/08 vieta di allargare la griglia su un motore senza edge.»*
✅ **E' l'argomento piu' forte del lotto, e in gran parte TIENE. Infatti NON sto riaprendo una
griglia**: la regola del 19/08 vieta *«altri parametri dello stesso motore morto»*, e
`InpMgmtTF` **non e' un parametro della griglia gia' girata — e' l'asse che quella griglia non
ha mai toccato**, cioe' esattamente cio' che il certificato chiede al punto ⑤.
🔴 **E il pezzo che NON tiene e' il DD**: e' l'unico numero che qui boccia da solo, ed e' un
**fatto accaduto** (Emendamento B del 16/08). 👉 **Quindi il verdetto onesto non e' «morto» e
non e' «riaprilo»: e' «⚪ NON ANCORA MISURATO sul MERITO, 🔴 BOCCIATO SUL RISCHIO»** — e il
secondo dei due basta a tenerli fuori dal campo **oggi**, senza bisogno di chiamarli morti.
📌 **Cosa serve per chiudere il certificato, se e quando varra' la pena**: una corsa con
`InpMgmtTF` ad asse. **Costo e priorita' sono di Claudio** — e la priorita' onesta e' BASSA,
perche' nessuno di questi tre diventa una sedia per il 1° ottobre.
👉 **Il MaxMinNotte non si allarga sugli indici europei: e' misurato sul RISCHIO, non supposto.
Sul MERITO, il certificato resta aperto di una casella.**

### 🔴 DUE VIE DI ALLARGAMENTO GIÀ PERCORSE E NEGATIVE — e una tocca un round già scritto
1. **TF più basso su `SuperWave_DOW_H1_Ottimizzato` U30USD**: la discesa H1→M30 **è già in
   archivio a tick reali sulla stessa finestra**
   (`risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._{IS,OOS}.csv`):
   **M30 OOS n=320 PF 0,868** · M20 OOS n=512 PF 0,753 DD 14,17% · M15 OOS n=637 PF 0,826
   DD 14,07%, contro H1 OOS n=143 PF 1,328.
   🔴 **A M30 l'OOS ha 320 operazioni: il merito NON è sospeso, è LETTO, ed è un no.**
   ⚠️ Il round base gira su un **binario più vecchio** di `r120e11` (4 colonne `Inp*` in meno), e
   su H1 quel binario fa **meglio** (PF OOS 1,328 contro 1,220). 👉 **`R190b` resta da girare ma
   va letto come CERTIFICATO, non come candidato**: la frase *«la cella non-promossa più bella
   dell'archivio»* nel suo file prova va corretta prima della corsa.
2. **Lato SHORT dell'apertura**: `ptc` sul Dow, tre valori di range, **OOS profit
   −3.281 / −2.795 / −6.010** passando da LONG-only a due lati (a fronte di **+55% di deal**),
   con IS **positivo su 3 su 3**. Sul DAX `Walkforward_Aperture/DAX_M_direzione` dice lo stesso:
   short IS PF **0,846**, combinazione IS PF **0,998** contro il long **1,131**.
   🟢 **Con questo la REGOLA DEI DUE LATI (25/08) è soddisfatta su D30EUR, U30USD e NASUSD: il
   lato short dell'apertura è stato misurato su tutti e tre ed è un no su tutti e tre.**
   ✏️ **PRECISATO IL 25/09/2026** (certificato del 09/09): *"un no"* vale per l'**interruttore**
   `InpAllowShort` sulla geometria del long. Sul lato short **la gestione dell'uscita e il filtro di regime
   non sono MAI stati messi ad asse**: per il certificato il lato short dell'apertura e' **NON ANCORA
   MISURATO**, non morto. Round preparato: **R251** (`prove/R251*`), quadro in
   `report/LATO_SHORT_DAX_APERTURA_2026-09-25.md`.
   🆕 **R251 CORSO il 25/09** (`report/REFERTO_R251_2026-09-25.md`): short identico al long e ritocchi d'uscita
   **BOCCIATI PER RISCHIO** (DD_fisso IS 10,4-24,2% contro 5,79% del long); filtro Supertrend: R1-R3 passati su
   H12 e D1, merito **SOSPESO** (n OOS < 150), H12 unica cella M1-M3 e isolata -> *"NON C'E' UNA CONFIGURAZIONE
   ROBUSTA"*. Per il certificato resta **NON ANCORA MISURATO**: mancano il punto 5 (TF mai cambiato) e il punto 4
   sul filtro (U30USD, NASUSD).
   ✏️ **E sulla sedia viva `770101` (25/09, cancello di R251, classe 793)**: col trailing acceso la parziale
   non e' a 1R ma a **mediana 0,57R** (ripiego ATR r.2356, misurato su R246e 794611). I numeri di contratto
   restano validi (il backtest lo contiene); sbagliata era la descrizione (`LA_BANDA_BASSA` r.406-408, errata).

### 🕳️ LA CASELLA LIBERA: **`InpSessionHour` non è MAI stato messo ad asse**
Su 2.376 CSV, **230** portano la colonna `InpSessionHour`. Di questi: `InpRangeMinutes` ad asse in
**54**, `InpSessionMin` ad asse in **0**, 🔴 **`InpSessionHour` ad asse in `0`**.
È una casella **libera**, non provata. E conta perché la famiglia Aperture fa **una posizione al
giorno per simbolo** (verificato: 193 posizioni su 193 giornate distinte): la portata cresce solo
con **un simbolo in più** — esauriti — **o con una SESSIONE in più**.

### 📦 I DUE FILE PROVA (scritti, `controlla_prova.py` **OK 0 problemi**, ASCII puro, NON girati)
| file | asse | celle | passate | costo (estremo alto) | magic |
|---|---|---:|---:|---:|---|
| `prove/R192a_sessionhour_DAXAPERTURA_D30EUR.txt` | **`InpSessionHour` 8→13** | 6 | 12 | 9,0 min | `762900` |
| `prove/R192b_aperturaUSA_DAXAPERTURA_D30EUR.txt` | `InpMagic` (2 gemelli G1) | 2 | 4 | 3,4 min | `762910/762911` |

Magic **vergini** (grep su tutto il repo: zero occorrenze). Base di costo **misurata sullo stesso
EA e simbolo**: 0,700 min/passata (`R104_REFERTO_DRIVER_20260825_0738.txt` r.15).
**Àncora dentro il round**: la cella *ora 8* di `R192a` deve riprodurre `ptd`
(IS n=175 PF 1,12634 DD 5,4362% · OOS n=270 PF 1,39709 DD 7,2328%, righe **77** e **75** dei CSV
grezzi). Se non riproduce, **le altre cinque celle non si leggono**.
🔴 Due pin cambiano rispetto a `ptd` e sono dichiarati nel file: `InpUsaGuardian` (default `true`
a HEAD, r.144) pinnato **`false`**, e `InpAllowReverse` pinnato `false`.
🔴 Confondente dichiarato **prima**: `InpCloseHour` resta 17:30 per tutte le celle, quindi le ore
tarde hanno meno spazio → **regola asimmetrica**: chi batte l'ora 8 è un segnale vero, chi perde è
`[NON MISURATO]`, non «quell'ora non funziona».

### 🚨 E UN BLOCCO CHE VALE PRIMA DI ACCENDERE QUALSIASI SECONDA SESSIONE
Due sedie Aperture sullo **stesso simbolo** si ostacolano: `PositionClose(_Symbol)` su conto
HEDGING chiude la posizione **più vecchia del simbolo di chiunque**
(`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` r.39). È lo stesso blocco che ha fermato le
due sedie Nasdaq il 19/09. 🔴 **Non si accende niente finché la chiusura non è per TICKET.**

📌 Classi nuove registrate: **464** (frequenza di campo gonfiata da un difetto noto) e **465**
(rapporto deal→posizioni trasportato fra celle, con la soglia di rottura dentro la banda).
🛑 **Nessun backtest eseguito, nessun EA/preset/forward toccato, nessuna taglia e nessuna
accensione proposta, niente sul conto reale `10105439`.** Bersaglio dei due file: banco
`C:\MT5_Backtest`, demo `50504400`. ⏳ Secondo strato del cancello (`controllo-preventivo`) **non
lanciato da me**: finché non torna, niente va verso il VPS.

---

# 🗃️ I TREDICI ROUND DEL 20-21/09/2026 — ARCHIVIATI IL 22-23/09/2026

🔴 **Perche' questa sezione esiste.** Fino al 22/09 `grep` su questo registro non trovava
**nessuna** occorrenza di `R172`, `R196`, `R197`, `R198`, `R199`, `R200`, `R201`, `R202`:
**l'intera campagna del 20-21/09 sulla famiglia APERTURE — 13 round, tutti `ROUND GIRATO` /
`RILIEVI: 0` — non era archiviata.** Ed e' la campagna che ha deciso le manopole di **tre sedie
che stanno operando in challenge**. E' esattamente il difetto che Claudio ha chiamato
*«NON E' ACCETTABILE»* il 09/09: il numero esiste, ma chi cerca dove si cerca non lo trova.

### 📐 Contesto comune ai 13, letto dai referti e dai file prova (non dedotto)
- **Macchina**: `DESKTOP-H4D7CAJ` (PC di backtest), terminale `C:\Program Files\BCM Markets MT5 Terminal`, conto **50503392**.
- **Modello 4 = TICK REALI** · **deposito 80.000** · **`@PERIODO M5`** su tutti e 13.
- **Finestra**: `@DAQUANDO 2024.09.26` → `2026.06.30`, **taglio `FrazioneIS 0.40`** ⇒ **IS
  2024.09.26 → ~2025.06.09** · **OOS ~2025.06.10 → 2026.06.30**. _(Il taglio e' dichiarato
  nel file prova in 4 round su 13; negli altri 9 e' il default del driver, **che e' lo stesso
  0.40** — `walkforward_generico.ps1` r.189.)_
- ⚠️ **Classe 550**: dove `InpTP1_ClosePct > 0` la colonna `Trades` conta **USCITE**, non posizioni.
- ⚠️ **Classe 547**: il rischio sta accanto a ogni DD, ed e' **diverso fra i round** (vedi colonna).
- **Tutti e 13: `ESITO: ROUND GIRATO` · `RILIEVI: 0`.**

### 📊 LA TABELLA — un round per riga

| round | EA (magic) | sym | TF | modello | rischio | **ASSE** (letto dal CSV) | **PF IS** (min-max) | **PF OOS** (min-max) | **n** IS/OOS | **DD** IS/OOS | **VERDETTO** |
|---|---|---|---|---|---|---|---|---|---|---|---|
| **R172D** | `ABTG_Dow_Apertura_US` (789540) | `U30USD` | M5 | tick | **1,00%** | `InpBEatR` 0,00→0,90 (7) | 0,88635 – **1,28819** | 0,88927 – **1,27175** | 68-75 / 115-130 `[uscite]` | 2,86-5,67% / 4,39-5,06% | 🔴 **LASCIA COM'E'** — lo stop a pari **non si accende sul Dow**: la cella viva (`BEatR=0`) fa OOS **1,27175** e **nessuna alternativa la batte**. Round scritto il 16/09 e girato il 21/09 |
| **R196A** | `ABTG_Nasdaq_Apertura_US` (770260) | `NASUSD` | M5 | tick | **2,00%** | `InpMinRangePts` 0 vs **7200** | 1,11621 / **1,44176** | **1,14894** / 1,09953 | 82→55 / 102→75 | 12,36→6,90% / 9,12→6,94% | 🔴 **LASCIA COM'E' (`0`)** — il pavimento d'ampiezza **migliora l'IS e peggiora l'OOS**, e costa il **26% delle operazioni**. Segno che si inverte fra le finestre = selezione, non edge |
| **R197A** | `ABTG_Dow_Apertura_US` (770202) | `U30USD` | M5 | tick | **2,00%** | `InpEntryMode` **0 / 1 / 2** | 0,96503 / *[n=2]* / **1,21214** | 1,18772 / *[n=2]* / **1,25384** | 87·2·74 / 162·2·130 | 11,99·0,80·11,09% / 8,86·4,70·8,75% | 🟢 **IL RETEST VINCE, IN TUTTE E DUE LE FINESTRE** — e col BREAKOUT l'IS del Dow va in **perdita** (0,965). ⚠️ `EntryMode=1` produce **2 sole operazioni**: cella **degenere**, `PF 0` = nessuna misura, non uno zero |
| **R197B** | `ABTG_Dow_Apertura_US` (770202) | `U30USD` | M5 | tick | **2,00%** | `InpRetestOffsetPts` 0/200/**400**/600 | 0,97281 / 1,07130 / **1,21214** / 1,10983 | 1,12516 / **1,27968** / 1,25384 / 1,25920 | 72-74 / 130-133 | 10,84-12,88% / 8,75-9,44% | 🔵 **OFFSET 400 CONFERMATO SUL DOW** — centro dell'altopiano (3 celle su 4 sopra 1,25 in OOS) e **miglior DD OOS**. 🔴 Lo `0` e' la **peggiore** delle quattro |
| **R198** | `ABTG_Nasdaq_Apertura_US` (770260) | `NASUSD` | M5 | tick | **2,00%** | `InpRetestOffsetPts` **0**/200/400/600 | 1,11621 / 1,28278 / 1,28578 / **1,29988** | **1,14894** / 0,95514 / 0,83796 / 0,83807 | 78-82 / 96-102 | 9,09-12,36% / 9,12-**26,11%** | 🔴 **NO, E FORTE: SUL NASDAQ LO `0` IN CAMPO E' IL MIGLIORE.** Il segno **si inverte fra IS e OOS su 3 celle su 3**, e il DD OOS arriva al **26,11% @ 2,00%** = oltre il doppio del muro. 👉 **La cella che vince sul Dow (400) NON e' trasferibile al Nasdaq**: misurato, non supposto |
| **R199A** | `ABTG_Nasdaq_Apertura_US` (770260) | `NASUSD` | M5 | tick | **2,00%** | `InpBEatR` 0 / **0,5** / 1,0 / 1,5 | 1,11621 / **1,27601** / 1,13553 / 1,11621 | 1,14894 / **1,23262** / 1,18903 / 1,14894 | **82 / 102, invariati su tutte** | 12,36→**8,72%** / 9,12→**8,65%** | 🟠 **MISURA VINCENTE, PROPOSTA POI RITIRATA.** `0,5 R` **domina** la cella viva su PF (+14,3% IS, +7,3% OOS), DD (−29,4% / −5,2%) e profitto (+94% / +22%), **a operazioni invariate**. 🔴 **Ritirata perche' Dow (`R172D`) e DAX (`R201A`) la rifiutano**: una manopola che vince su un simbolo solo non si generalizza. 🔎 `1,5 R` riproduce `0` **perche' il bersaglio sta a `InpTP1_R x 3 = 1,5 R`**: non ha strada davanti (geometria, non guasto) |
| **R199B** | `ABTG_Nasdaq_Apertura_US` (770260) | `NASUSD` | M5 | tick | **2,00%** | `InpTP1_ClosePct` **0**/25/**50**/75 | 1,11621 / **1,24954** / **1,22116** / 1,19253 | 1,14894 / **1,22396** / **1,21546** / 1,20435 | 82→135 / 102→**172** `[uscite]` | 12,36→**7,31%** / 9,12→**7,86%** | 🟢🟢 **L'UNICA PROMOZIONE DEI TREDICI, ED E' IN CAMPO.** `ClosePct 0 → 50` migliora **PF, DD E profitto in tutte e due le finestre**. Firma di Claudio (*«ACCENDILA AL 50%»*) e accensione il **21/09 alle 20:22**, commit `496408a9`. 🟢 **E porta la sedia SOTTO il muro FTMO del 10% alla taglia vera: DD IS 7,31% · OOS 7,86% @ 2,00%** (IS −40,9%). 🔴 **Il merito resta sospeso**: 172 uscite = **102 posizioni** < 150 |
| **R200A** | `ABTG_Nasdaq_Apertura_US` (770260) | `NASUSD` | M5 | tick | **2,00%** | 🟢 **`InpTrailTF` su NOVE TF: M1·M2·M3·M4·M5·M6·M10·M12·M15** | 0,91982 – **1,13354** | 0,89257 – **1,17495** | 82 / 102 (invariati) | 7,73-17,69% / 9,12-16,22% | 🔴 **M5 RESTA — ed e' l'unico TF positivo in TUTTE E DUE le finestre con DD sotto il 10% OOS** (IS 1,11621 · OOS 1,14894 · DD OOS 9,1244%). 🔎 **M1 e' PRIMO in IS (1,13354) e ULTIMO in OOS (0,89257)**: segno invertito = selezione. M6 fa il miglior OOS (1,17495) ma solo 1,03 in IS e DD OOS 10,87%. 📌 **Questo e' l'UNICO asse di TIMEFRAME mai girato in tutta la famiglia APERTURE**, e chiude una casella del punto ⑤ per `770260` |
| **R200C** | `ABTG_Nasdaq_Apertura_US` (770260) | `NASUSD` | M5 | tick | **2,00%** | `InpTrailMode` 0 / **1** / 2 | 1,11685 / **1,11621** / 0,65823 | 1,01777 / **1,14894** / 0,80365 | 82 / 102 | **16,19** / 12,36 / 8,04% · 12,72 / **9,12** / 5,32% | 🔴 **PREVBAR (`1`) E' GIA' IL MIGLIORE** — miglior PF in tutte e due le finestre. ⚠️ Il modo `2` **dimezza il DD** (OOS 5,32%) ma **uccide il PF** (0,80): e' una leva sul rischio, non sul merito, e va ricordata se un giorno servisse comprare DD con profitto |
| **R200E** | `ABTG_Nasdaq_Apertura_US` (770260) | `NASUSD` | M5 | tick | **2,00%** | `InpTrailFixedPts` 410 → 18410 (10 valori) | 0,65823 – **1,14559** | 0,80365 – **1,06050** | 82 / 102 | 8,04-**20,07%** / 5,32-**20,05%** | 🔴 **NESSUNA FINESTRA UTILE** — il PF OOS non arriva mai a 1,07 e il DD sale fino al **20% @ 2,00%**, cioe' il doppio del muro. Il trailing a punti fissi **non compete** col PREVBAR |
| **R201A** | `ABTG_DAX_Apertura_EU` (789521) | `D30EUR` | M5 | tick | **1,00%** | `InpBEatR` 0,00→0,90 (7) | 1,03942 – **1,14812** | **1,25071 – 1,51555** | 158-177 / 248-271 `[uscite]` | 3,40-5,90% / 3,94-7,39% | 🔴 **LASCIA COM'E'** — 🟢 **ma e' la riga piu' bella dei tredici**: il DAX fa **7 celle su 7 sopra 1,25 in OOS**, con la cella viva (`BEatR=0`) a **1,39520 · n 270 · DD 7,2506% @ 1,00%**. Nessuna alternativa domina: lo stop a pari **non serve** |
| **R202A** | `ABTG_Dow_Apertura_US` (789540) | `U30USD` | M5 | tick | **1,00%** | `InpTP1_R` 0,25/0,50/0,75/**1,00** | **1,39731** / 1,05804 / 1,37909 / 1,22173 | 0,93207 / 1,10328 / 1,13744 / 🟢 **1,27175** | 74-96 / 130-161 `[uscite]` | 2,55-5,67% / 4,39-4,57% | 🔴 **RESTA `InpTP1_R = 1,00`** — e **per misura, non per abitudine**: le tre alternative falliscono **tutti e quattro** i cancelli congelati prima del round. ⚠️ `0,25` va in **perdita** in OOS (0,93207, −864,82). 🔎 La manopola **non muove solo il parziale**: il bersaglio finale e' `InpTP1_R x 3`, quindi scendere **rinuncia a meta' della coda** |
| **R202B** | `ABTG_DAX_Apertura_EU` (789521) | `D30EUR` | M5 | tick | **1,00%** | `InpTP1_R` 0,25/0,50/0,75/**1,00** | 1,05870 – **1,12733** | 1,24194 – 🟢 **1,39520** | 175-223 / 270-339 `[uscite]` | 4,05-6,06% / 4,85-7,76% | 🔴 **RESTA `InpTP1_R = 1,00`** — miglior PF OOS **e** miglior profitto. 🟠 **L'unica alternativa non liquidata**: `0,25` ha **DD OOS 4,8467% (−33,2%)** a fronte di **PF −2,23%** → cancello (b) **NON RISOLTO**, chiuso da un **veto strutturale** sull'altopiano. E' l'unica porta ancora socchiusa dei tredici |

### 🟢 IL CONTROLLO DI RIPRODUZIONE, che vale quanto i numeri
- `R199A` cella `BEatR = 0` **riproduce `R196A`/`R198` al centesimo su tutte e due le finestre**
  (IS `82 · 1,11621 · 12,3568` · OOS `102 · 1,14894 · 9,1244`).
- `R202A` cella `1.00` contro `R172D` Pass 0: **91 colonne confrontate, due differenze, entrambe
  di sola formattazione** (`0` vs `0.00`). `R202B` contro `R201A`: **101 colonne, le stesse due.**
  Coincidono anche `Expected Payoff`, `Recovery Factor`, `Sharpe Ratio`, `Peggior Giornata %` e
  `Serie Perdente Peggiore`. 👉 **La catena pin → driver → file prova ha tenuto alla colonna.**
  Verbale: `report/VERDETTO_R202_2026-09-21.md`.

### 📌 COSA LASCIANO IN EREDITA' I TREDICI
1. 🟢 **Una promozione sola su tredici round** (`R199B`), misurata, firmata e in campo in **sei ore**.
2. 🔴 **Una manopola che vinceva ed e' stata ritirata** (`R199A`) perche' **non si generalizzava**:
   e' il metodo che funziona, non un'occasione persa.
3. 🔴 **La prova che una cella NON si trasferisce fra simboli gemelli**: `InpRetestOffsetPts`
   **400 sul Dow, 0 sul Nasdaq**, misurato lo stesso giorno sugli stessi assi (`R197B` vs `R198`).
4. 🟢 **Il primo e unico asse di TIMEFRAME della famiglia** (`R200A`, nove TF di trailing).
5. ⚪ **E il buco che resta**: `InpLevelTF` (H1 in **tutti** i CSV) e `InpSessionHour` (asse in
   **0** CSV su 2.376) **non sono mai stati mossi da nessuno dei tredici.** Il punto ⑤ delle tre
   sedie d'apertura resta **aperto sull'INGRESSO**, e la loro chiusura e' **una firma di Claudio**,
   non un lavoro d'agente.

_🛑 Nessun round e' stato lanciato per scrivere questa sezione: i tredici erano gia' girati il
20-21/09. Fonti primarie: `backtest_pipeline/risultati_prove/{R172D,R196A,R197A,R197B,R198,R199A,R199B,R200A,R200C,R200E,R201A,R202A,R202B}/` —
per ogni round il `REFERTO_ROUND_*.txt` e i due CSV `_IS_`/`_OOS_`, **aperti e letti colonna per
colonna il 22-23/09/2026**. Referti di lettura: `report/DD_NASDAQ_R199_2026-09-21.md` ·
`report/DD_NASDAQ_IL_ROUND_GIA_FATTO_2026-09-22.md` · `report/PROFONDITA_RETEST_2026-09-21.md` ·
`report/VERDETTO_R202_2026-09-21.md`._

---

## 🐻 25/09/2026 — SECONDA CACCIA DAX SHORT dopo R251: 10 meccanismi misurati FUORI, 1 in coda (`CACCIA_DAX_SHORT_2026-09-25.md`)

Regola della seconda caccia (19/08) dopo R251 (short retest d'apertura **bocciato per rischio**).
**Zero passate di tester, zero EA/preset/sedie toccati.** Sonda esterna `GRXEUR` M1 **2011-2018**
(8 anni, 2.017 sedute, costo 1,70, ambiguita' a sfavore, controllo appaiato), criteri G1-G4
**pushati prima** (`473c57f6`): `caccia_strategie/biblioteca/sonde_esterne/sonda_dax_short_meccanismi.py`.
🔴 **Nessuna di queste righe e' un certificato di morte**: e' SCREENING esterno, non BCM, non tick.
Il verdetto per tutte le celle mai girate su BCM resta **NON ANCORA MISURATO (sonda esterna negativa)**.

| cella | E netta · t · anni+ · stop med | esito sonda |
|---|---|---|
| ITSM 1a -> ultima mezz'ora, corto (con notte / solo seduta) | −0,046 R t −3,26 2/8 · −0,057 R t −4,51 1/8 · stop 30x | 🔴 negativa **e sotto la frontiera del costo** |
| fade del gap-up >=0,25% / >=0,50% | −0,018 R 3/8 · −0,030 R 3/8 | 🔴 negativa |
| apertura USA: inversione / continuazione | −0,022 R · +0,007 R | 🔴 piatta |
| 10:00 New York, corto incondizionato | −0,010 R 2/8, info +0,015 | 🔴 volatilita', non direzione |
| cono di rumore, SOLO corto | −0,028 R 3/8, info −0,012 | 🔴 conferma lo zero del 12/09 (trailing VWAP NON misurabile) |
| gap-down continuazione >=0,25% | +0,110 R t 1,80 5/8 | 🟠 manca G1 e G3 |
| **gap-down continuazione >=0,50%** (rottura del min. range 15', 2R) | **+0,185 R t 2,12 6/8, DD 6,5 R, n 175** | 🟢 **PASSA-SONDA** + 6 contro-esempi (gap = motore; lungo speculare senza informazione; EuroStoxx concorde t 1,51; S&P NO t 0,49) |

- 📦 **In coda, NON girato:** `prove/R253a_gapcont_DAX_short_ora8.txt` + `R253b_gapcont_DAX_short_ora9.txt`
  ✅ **GIRATO il 25/09 22:52-22:55 (2 min) sul PC di backtest, catena VERDE** (`report/REFERTO_R253_2026-09-25.md`, archivio `risultati_archivio/R253/`): curva in fase **29 posizioni** in 21 mesi, PF 0,898, EP −0,041 R, DD chiuso 5,63% (R1 ≤ 6,5 NON VIOLATO su n 29, P senza edge 0,56, oltre il peggio di CE9 4,8 R), pegg. giorno −0,98%, serie 3; K1 stop mediano 116 pti = 68× spread AMMESSO; O1 vs 770411 17%; O2 vs 770105 NON MISURABILE (zip R252 assente). **Merito SOSPESO, segno DISCORDE con CE9 ma dentro l'attesa di toro. Certificato: NON ANCORA MISURATO** (mancano uscita ad asse, gemelli E50/F40, range 5/10/15).
  (`ABTG_GapContinuation`, D30EUR solo short, orologio in fase come R252; `controlla_prova.py` OK).
  Merito **sospeso per aritmetica** in partenza (~0,09 posizioni/seduta): il round giudica catena,
  costo, rischio e sovrapposizione con 770411/770105.
- 🔧 **Difetto di strumento trovato leggendo (non un verdetto):** `ABTG_DAX_Apertura_EU`
  `InpEntryMode=1` (`GAPFILL`) su D30EUR misura il gap sulle **barre D1 del CFD**
  (`iClose(D1,1)` / `iOpen(D1,0)`, r.2013-2014), non il gap della cash: in FASE B **7 e 9
  operazioni**. Il gap di cassa sul DAX si misura con `ABTG_GapContinuation` (chiusura della
  seduta precedente sulle M1, r.637-655).
- 📄 Fonte esterna letta sul PDF: arXiv **2605.04004** (Mesfin, MNQ 2021-2025), _gap continuation
  short_ netto +14,52 pti, T 1,46, 35 op. OOS, 2024 negativo: _"most credible near-miss"_.
