# 🚨 CENSIMENTO GAP TRADING — la flotta contro la regola FTMO (28/08/2026)

> **Mandato:** FTMO ha confermato per iscritto il 28/08 (Romeo Pagani, terzo
> giro di mail — verbale in `MAIL_FTMO_GAP_TRADING_TERZO_GIRO_2026-08-28.md`)
> che il **gap trading è vietato ANCHE in Evaluation**, a differenza di news
> trading e weekend holding che in Challenge/Verification/Free Trial **sono
> permessi**. Definizione tecnica ufficiale (Nicolas Novak, 27/08, e pagina
> Forbidden Trading Practices — `docs/REGOLAMENTO_FTMO_2026-08.md` §5-6):
>
> _"performing gap trading by **opening** simulated trades **(i)** when major
> global news, macroeconomic events, or corporate reports or earnings are
> scheduled…, or **(ii) two hours or less before a relevant financial market
> is closed for at least two hours**."_
>
> Questo file è **la fotografia dello stato attuale**, non la correzione.
> Questo è l'audit che il file della terza mail lasciava aperto come
> _"Conseguenza pratica, non ancora verificata"_.

⚠️ **NESSUN file `.mq5` o `.set` è stato toccato.** Solo lettura.

---

## 🔴 LA SINTESI IN CINQUE RIGHE

| domanda | risposta misurata |
|---|---|
| Sedie vive censite | **38** (su 22 EA distinti) |
| **Punto 1 — filtro news ATTIVO** | **0 su 38.** Zero. Nessuna eccezione. |
| di cui: filtro **assente dal codice** | **18 sedie / 6 EA** |
| di cui: filtro **presente ma spento** | **20 sedie / 15 EA** |
| **Punto 2 — cutoff pre-chiusura ≥2h** | **0 su 38 progettati per questo.** 5 sedie sono coperte *per effetto collaterale* della sessione, 3 sono **parziali/dubbie**, **30 sono nude.** |

### 💣 E c'è un secondo strato peggiore del primo

Anche le 20 sedie che il filtro news **ce l'hanno**, se qualcuno lo accendesse
domani mattina, **resterebbero scoperte lo stesso**. Tre difetti misurati nel
codice e nei dati, spiegati al §3:

1. il file news che il VPS scarica (`data/abtg_news.csv` sul branch `lavoro`)
   è **VUOTO — 0 byte**;
2. quando il file manca o è vuoto il filtro **si autospegne in silenzio**
   (`gNewsCount==0` → `InNewsBlackout()` ritorna `false`), e nel log resta solo
   una riga: _"file news non trovato: filtro di fatto spento."_;
3. `LoadNews()` è chiamata **una sola volta, in `OnInit`** (verificato: 1
   occorrenza per file su 6 EA controllati) → un CSV aggiornato ogni mattina
   dallo scheduler **non viene riletto** finché l'EA non viene ricaricato.

### 🎯 Le tre sedie più a rischio (motivate, non a naso)

1. 🥇 **`ABTG_SupRev_DAX_H4_Ottimizzato` — D30EUR, magic 970912.** È l'unica
   sedia su **DAX** senza nessun cancello orario (`InpUseTimeWindow=false`,
   verificato nel `.set` live). Il dossier FTMO di casa
   (`docs/REGOLAMENTO_FTMO_2026-08.md` §5) dice che gli **indici europei hanno
   una pausa notturna di ~3 ore** → **la clausola (ii) morde OGNI GIORNO**, non
   solo nel weekend. Le barre H4 chiudono alle 20:00 server: è esattamente
   dentro la finestra vietata.
2. 🥈 **`ABTG_ORB_Ottimizzato` — U30USD, magic 770611.** Ha un cutoff
   (`InpEndHour=21`, `InpEndMin=0` nel `.set` live) ma è **troppo tardi**: i
   pendenti restano vivi fino alle 21:00 server, e il **venerdì** la chiusura
   settimanale stimata è ~22:00 server → **l'ultima ora di operatività cade
   dentro le 2 ore vietate.**
3. 🥉 **`ABTG_GapFill` — 5 sedie (772231-772235).** Non viola la *lettera*
   della regola (apre alla **ri**apertura, non prima della chiusura), ma è
   **letteralmente "gap trading" nel nome e nella tesi**. Il dossier di casa la
   marcava già come _"ZONA GRIGIA UFFICIALE… senza risposta scritta del
   supporto, la famiglia gap-fill NON va caricata su FTMO"_. La risposta del
   28/08 **non ha chiuso questo punto**: ha chiuso solo il "vale in
   Evaluation?". Il punto "la riapertura conta?" resta aperto.

---

## 📚 §1 — LA FONTE DELLA LISTA SEDIE (e quanto è affidabile)

**Fonte usata:**
`backtest_pipeline/risultati_archivio/censimento_rischio_2026-08-25_0731.txt`
— foto dei `.chr` del **25/08/2026 07:31**, 52 righe. **È il censimento più
recente esistente nel repo** (verificato: nessun file `censimento_rischio_*`
successivo).

**Perché questa e non le altre due che il mandato citava:**

| fonte alternativa | perché NON usata come primaria |
|---|---|
| `FLOTTA_ATTIVA.md` | base scritta a mano dai **52 screenshot del 02/08**, con patch fino al 19/08. 🔴 **DISCORDANTE**: elenca come vive `GoldenCross` (×5), `EMA200` su 200AUD/AUDJPY/GBPJPY/SPXUSD, `WOL`, `HARSI`, `PostNews` (×2), `SupertrendInvert`, `Nightly`, `DAX_Live5m`, `Nasdaq_*` — **nessuna compare nel censimento del 25/08**. |
| `report/CENSIMENTO_FLOTTA_07-08.md` | 07/08, **tre settimane fa**. Utile per i limiti dello strumento (li dichiara bene), non per la lista. |
| `report/CONTRATTI_SEDIE.md` | 44 sedie, ma costruito sulla foto del **18/08 00:01** — precede le 4 sedie spente dalla firma del 24/08. |

**Coerenza controllata:** il censimento del 25/08 **non contiene** le 4 sedie
spente dalla `FIRMA_REVISIONE_FLOTTA_2026-08-24.md` (PTE USDJPY 771323,
SuperWave GBPUSD 770532, CostToCost XAGUSD 772363, EasyTrend AUDJPY 772423) e
**contiene** i rischi ridotti della Corsia B. ✅ È post-revisione, è coerente.

**Deduplica applicata:** 52 righe → **38 sedie di trading uniche**. Tolte: le
copie sul **dry-run 100k** (stessa sedia, taglia diversa: 770101, 770202,
770411, 770611, 770901) e le **3 utility** che non tradano (`ABTG_Guardian`
779001 ×3 righe, `ABTG_TradeExporter` ×2).

### ⚠️ I limiti di questa fotografia, dichiarati

1. **Ha 3 giorni** (25/08 → oggi 28/08). Un drift della flotta in questi 3
   giorni non è coperto. Il precedente c'è: `CONTRATTI_SEDIE.md` è invecchiato
   in **nove ore** (correzione del 21/08).
2. **Il lettore di `.chr` vede solo il profilo ATTIVO.** Il censimento del
   07/08 lo dichiara: EA su profili/terminali non attivi non compaiono. Se le
   sedie di `FLOTTA_ATTIVA.md` mancanti fossero solo "su un altro profilo",
   il **denominatore** cambierebbe — **il verdetto no**: `GoldenCross`, `WOL`,
   `HARSI`, `SupertrendInvert`, `Nightly` hanno tutti lo **stesso filtro news
   di famiglia con default `false`** (verificato nei sorgenti), e nessuno di
   loro ha un cutoff pre-chiusura. Andrebbero nella colonna "scoperti".
3. **Non è verificabile da qui** se sul VPS quei 38 grafici siano ancora
   attaccati adesso. Serve una corsa nuova di `censimento_rischio.ps1`.

---

## 📰 §2 — PUNTO 1: IL FILTRO NEWS, EA PER EA

**Metodo:** letto il **sorgente** per la logica reale (non il nome
dell'input), poi il **`.set` live** dove esiste in repo. Verificato che il
filtro **blocchi davvero gli ingressi** e non sia una variabile morta: sì, lo
fa (es. `ABTG_DAX_Apertura_EU.mq5:684` → `if(newsBlk) break;` dentro
`PH_BUILDING`; `ABTG_SupertrendReversal.mq5:199` → `return` in `OnTick`;
`ABTG_BreakingBand.mq5:943` → `return(false)` sul segnale). **La logica è
buona. È spenta.**

### 🟠 A — Filtro PRESENTE nel codice, SPENTO nel preset live (20 sedie / 15 EA)

Tutti condividono lo stesso blocco di famiglia: `InpUseNewsFilter` (default
`false`) + `InpNewsFile="abtg_news.csv"` + `InpNewsMinImpact=3` +
`InpNewsBeforeMin`/`InpNewsAfterMin` + `LoadNews()`/`InNewsBlackout()`.

| EA | magic live | simbolo | stato nel preset | come l'ho verificato |
|---|---|---|---|---|
| ABTG_DAX_Apertura_EU | 770101 | D30EUR | ❌ `false` | `.set` live ✅ |
| ABTG_Dow_Apertura_US | 770202 | U30USD | ❌ `false` | `.set` live ✅ |
| ABTG_EMA200 | 771531 | U30USD | ❌ `false` | `.set` live ✅ |
| ABTG_EMA200_Ottimizzato | 971501 | XAUUSD | ❌ `false` | `.set` live ✅ |
| ABTG_MaxMinNotte_DAX_Short_Ott | 770411 | D30EUR | ❌ `false` | `.set` live ✅ |
| ABTG_MaxMinNotte | 770402 | XAUUSD | ❌ `false` | `.set` live ✅ |
| ABTG_ORB_Ottimizzato | 770611 | U30USD | ❌ `false` (⚠️ `InpNewsCurrencies=USD`: sarebbe l'unico tarato) | `.set` live ✅ |
| ABTG_SupRev_DAX_H4_Ottimizzato | 970912 | D30EUR | ❌ `false` | `.set` live ✅ |
| ABTG_SupRev_NAS_H1_Ottimizzato | 970913 | NASUSD | ❌ `false` | `.set` live ✅ |
| ABTG_SuperWave_DOW_H1_Ottimizzato | 770511 | U30USD | ❌ `false` | `.set` live ✅ |
| ABTG_SuperWave (H2) | 770531 | U30USD | ❌ `false` | `.set` live ✅ |
| ABTG_SupertrendReversal (Nikkei FW) | 770924 | 225JPY | ❌ `false` | `.set` live ✅ |
| ABTG_SupertrendReversal_Ottimizzato | 970901 | XAUUSD | ❌ `false` | `.set` live ✅ |
| ABTG_PTE (storica) | 771321 | U30USD | ❌ `false` | `.set` live ✅ |
| ABTG_PTE (storica) | 771322 | GBPUSD | ❌ `false` | `.set` live ✅ |
| ABTG_PTE (candidata R78) | 771332 | GBPUSD | ❌ `false` | ⚠️ **nessun `.set` in repo** — dichiarato spento in `FLOTTA_ATTIVA.md` §duello ("filtro news off", verifica 7/7 del 17/08) + default sorgente |
| ABTG_SupertrendReversal (Nikkei H2) | 770901 | 225JPY | ❌ `false` | ⚠️ **nessun `.set` in repo** — default sorgente `false` |
| ABTG_BreakingBand | 772161 | GBPUSD | ❌ `false` | ⚠️ **nessun `.set` in repo** — default sorgente `false` |
| ABTG_BreakingBand | 772162 | EURUSD | ❌ `false` | ⚠️ idem |
| ABTG_BreakingBand | 772163 | AUDUSD | ❌ `false` | ⚠️ idem |

📌 **15 sedie su 20 sono verificate sul `.set` vero. Le altre 5 sono INFERITE**
dal default del sorgente (che è `false` in tutti i file) e da documentazione.
🔴 **Per le famiglie di agosto — BreakingBand, GapFill, PunteLarry, CostToCost,
EasyTrend, PTE 771332, GapContinuation — NON esiste nessun `.set` in repo.**
Il loro stato live è ricostruito, non letto. Serve un `config_in_uso.ps1` /
export dei `.chr` con TUTTI gli input per chiuderlo.

### 🔴 B — Filtro ASSENTE dal codice (18 sedie / 6 EA + 1 non auditabile)

Non è "spento": **non c'è proprio**. Non esiste nessun input, nessuna
funzione, nessun riferimento a news/calendario nel sorgente.

| EA | magic live | simbolo | nota |
|---|---|---|---|
| **ABTG_PunteLarry** | 772341 · 772342 · 772343 · 772344 · 772345 · 772346 | U30USD · EURAUD · XAUUSD · GBPJPY · GBPUSD · EURCAD | **6 sedie**. Nessun input news. ⚠️ `InpPatternMode=2` è il pattern **OOPS**, che *per definizione* opera su un **gap d'apertura** |
| **ABTG_GapFill** | 772231 · 772232 · 772233 · 772234 · 772235 | GBPUSD · EURUSD · AUDUSD · U30USD · 225JPY | **5 sedie**. Ha solo `InpGapMaxATR=2.0` — un **tetto di ampiezza del gap** (commento nel sorgente: _"sopra, è un gap di ROTTURA (news)"_). ⚠️ **Non è un filtro news**: non guarda nessun calendario, guarda solo quanto è grande il gap |
| **ABTG_CostToCost** | 772361 · 772362 | EURJPY · GBPCAD | 2 sedie |
| **ABTG_EasyTrend** | 772421 · 772422 | CHFJPY · GBPUSD | 2 sedie |
| **Gold_Ichimoku_TK_ATR_EA** | 250604 | XAUUSD | 1 sedia. EA esterno, nessun input di alcun genere su news/orari |
| **ABTG_GapContinuation** | 774101 | 225JPY | 1 sedia |
| **BREAKOUT_EA_JPY_v3** | n/d | USDJPY | 1 sedia. 🔴 **NON AUDITABILE**: il file `BREAKOUT_EA_JPY_v3.mq5` **non esiste nel repo** (ci sono solo `BREAKOUT_EA_JPY.mq5` e `_Multi.mq5`, e nessuno dei due ha input news). È la sedia già marcata **[SENZA CONTRATTO]** in `CONTRATTI_SEDIE.md`, mai spenta malgrado i documenti la diano per spenta |

---

## 💀 §3 — IL SECONDO STRATO: il filtro news è rotto anche da acceso

Questo non era nel mandato ma cambia il piano di rientro, quindi va scritto.

### 3.1 🕳️ Il file di calendario è VUOTO

```
$ wc -c data/abtg_news.csv
0 data/abtg_news.csv          <- ZERO BYTE, e il file È TRACCIATO su git
```

`backtest_pipeline/aggiorna_news.ps1` (lo scheduler del VPS) scarica
**esattamente questo file**:

```
$RawUrl = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/data/abtg_news.csv"
```

→ e lo scrive in `MQL5\Files\abtg_news.csv`. **Se quello script è mai girato
sul VPS, ha sovrascritto il calendario con un file vuoto.**

⚠️ **NON verificabile da qui**: cosa c'è *davvero* adesso in `MQL5\Files` sul
VPS. Da questo repo posso dire solo cosa lo script *ci mette*. Serve un
controllo sul VPS.

L'altra copia in repo, `mql5/Files/abtg_news.csv`, ha **17 eventi in tutto**
(NFP/CPI/FOMC/ECB, gen-2026 → gen-2027): è uno stub scritto a mano, non un
calendario. Esiste anche `mql5/Files/abtg_news_2021_2025_UTC.csv` (151 KB) ma
**è storico, finisce nel 2025**, e nessun preset lo punta.

### 3.2 🤫 Il fallimento è SILENZIOSO (e questo è il pezzo pericoloso)

Dal codice di famiglia (identico in tutti gli EA che ce l'hanno):

```mql5
int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
if(h==INVALID_HANDLE){ Log("file news non trovato: filtro di fatto spento."); return; }
...
bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);   // <-- file vuoto = MAI blackout
```

Con `InpUseNewsFilter=true` e il file mancante/vuoto, l'EA **si comporta
esattamente come col filtro spento**, ma il pannello e il preset dicono
"acceso". È il tipo di buco che si scopre solo dopo la violazione.

### 3.3 ⏰ Il calendario si carica UNA volta sola

`LoadNews()` è chiamata **solo in `OnInit`** — verificato con conteggio delle
occorrenze: **1** su `ABTG_SupertrendReversal`, `ABTG_PTE`,
`ABTG_ORB_Ottimizzato`, `ABTG_DAX_Apertura_EU`, `ABTG_BreakingBand`,
`ABTG_EMA200`. Un CSV aggiornato ogni mattina dallo scheduler **non entra in
memoria** finché l'EA non viene ricaricato. (L'EA `ABTG_PostNews` fa
eccezione — ma non è in flotta nel censimento del 25/08.)

### 3.4 🌍 Il fuso: tutto da rimappare il giorno della challenge

`InpNewsShiftMinutes=0` in **tutti** i preset live. I CSV di calendario in
biblioteca sono in **UTC+2**, BCM è **UTC+1** in agosto (misurato il 18/08,
`PIANO_PROP.md` §B3/M15a). Sul server **FTMO** (GMT+2/+3 = ora italiana) lo
shift cambia di nuovo. **Ogni ora cablata in questo repo si sposta di
un'ora al passaggio su FTMO**, ed è già scritto nel `DIARIO.md` del 13/08:
_"Fuso FTMO GMT+2/+3 ≠ BCM: InpSessionHour tutti da rimappare al passaggio."_

---

## 🕐 §4 — PUNTO 2: IL CUTOFF PRIMA DELLE CHIUSURE ≥2h

### 4.1 Quali chiusure contano davvero (fonte: dossier FTMO di casa)

Da `docs/REGOLAMENTO_FTMO_2026-08.md` §5 — **orari qui sotto in ORA SERVER BCM
(= ora italiana − 1)**:

| mercato | pausa giornaliera | la clausola (ii) morde **ogni giorno**? | weekend |
|---|---|---|---|
| **Indici europei (D30EUR)** | **~3 ore** (~01:00-22:00 London) | 🔴 **SÌ** — finestra vietata ~**20:00-22:00 server, TUTTI i giorni** | 🔴 sì |
| **Indici USA (U30USD, NASUSD)** | ~1 ora | 🟢 no (<2h) | 🔴 sì |
| **Oro (XAUUSD)** | ~1 ora | 🟢 no (<2h) | 🔴 sì |
| **Forex** (rollover) | tipicamente pochi minuti | 🟢 no | 🔴 sì |
| **Nikkei (225JPY)** | ⚠️ **[NON VERIFICATO]** | ⚠️ ignoto | 🔴 sì |
| **Festivi di mercato** | ⚠️ **[NON RILEVABILE DA CODICE]** | — | — |

⚠️ **Tre cose che NON posso stabilire da questo repo, e le dichiaro:**
1. **L'ora esatta della chiusura del venerdì** sul server. Stima di lavoro
   ~**22:00 server BCM** (17:00 New York), quindi finestra vietata **venerdì
   20:00-22:00 server (21:00-23:00 IT)**. Va **MISURATA** sulle specifiche di
   simbolo del broker, non assunta.
2. **Le pause giornaliere reali dei simboli su FTMO**, che è un broker diverso
   da BCM con orari e fuso diversi.
3. **I festivi.** 🔴 **Nessun EA della flotta legge le sessioni vere dal
   broker**: verificato con grep su tutti i sorgenti — `SymbolInfoSessionTrade`
   / `SymbolInfoSessionQuote` **non compaiono in nessun file**. Le uniche due
   occorrenze di API di simbolo (`ABTG_PunteLarry:993`,
   `ABTG_CanaleLento:282`) riguardano `SYMBOL_EXPIRATION_MODE`, cioè la
   scadenza dei pendenti — **niente a che vedere con le sessioni**. Tradotto:
   **la flotta non ha alcun modo di sapere quando il mercato chiude.** Tutta la
   logica temporale è a **ore cablate a mano**.

### 4.2 🟢 Coperte — 5 sedie (ma **per effetto collaterale**, non per disegno)

Nessuna di queste ha un input "cutoff pre-chiusura". Sono al sicuro perché
sono EA **legati a una sessione mattutina**, e il cancello che le ferma è
quello di sessione.

| EA / magic | meccanismo | ultimo ingresso possibile (server) | copre |
|---|---|---|---|
| **DAX_Apertura_EU** 770101 | `InpCloseHour=17` / `InpCloseMin=30` → `EndOfSession(); return;` (`.mq5:665-669`) — **blocca anche le nuove aperture**, non solo chiude | **17:30** | weekend ✅ · pausa DAX ✅ |
| **Dow_Apertura_US** 770202 | idem, stesso codice | **17:30** | weekend ✅ |
| **MaxMinNotte_DAX_Short** 770411 | `InpEntryCutoffHour=8` / `Min=30` — cancella i pendenti non scattati (`.mq5:172-176`) | **08:30** | weekend ✅ · pausa DAX ✅ |
| **MaxMinNotte (oro)** 770402 | idem | **08:30** | weekend ✅ |
| **GapContinuation** 774101 | `InpMaxEntryMinutesFromOpen=90` su sessione 01:00-07:30 | **~02:30** | weekend ✅ · pausa 225JPY ⚠️ ignota |

⚠️ **Caveat che vale per tutte e 5:** sono ore **cablate in ora server BCM**.
Sul server FTMO scivolano di un'ora e vanno rimappate; e **nessuna sa cos'è un
festivo**. La copertura è un regalo della strategia, non una garanzia.

### 4.3 🟡 Parziali / dubbie — 3 sedie

| EA / magic | meccanismo | perché non basta |
|---|---|---|
| **ORB_Ottimizzato** 770611 (U30USD) | `InpEndHour=21`, `InpEndMin=0` → `EndOfDay(); return;` (`.mq5:259`). I pendenti vivono fino a lì (`InpPendingExpiryMin=600`) | 🔴 **21:00 è troppo tardi.** Se la chiusura del venerdì è ~22:00 server, **20:00-21:00 del venerdì è dentro la finestra vietata**. Basterebbe anticipare il cutoff — ma va misurata prima l'ora vera di chiusura |
| **EasyTrend** 772421 (CHFJPY) · 772422 (GBPUSD) | `InpHourStart=8` / `InpHourEnd=18` sull'ora della **candela del segnale** (`.mq5:853`) | 🟡 il segnale si ferma alle 18, ma il **LIMIT resta valido `InpEntryWindowBars=3` barre H1** → l'esecuzione può cadere fino a **~21:00 server**. Sul venerdì è **al confine** della finestra vietata. ⚠️ Il commento del sorgente dichiara il fuso stesso come **[INCERTO]** |

### 4.4 🔴 SCOPERTE — 30 sedie, nessun cancello orario di nessun tipo

Possono aprire una posizione **in qualunque momento in cui il mercato quota**,
inclusi gli ultimi minuti del venerdì.

| EA | sedie (magic) | cosa c'è nel codice |
|---|---|---|
| **ABTG_SupRev_DAX_H4_Ott** | 970912 (D30EUR) | `InpUseTimeWindow=false` nel `.set` live → il check `.mq5:185` non scatta mai. 🥇 **LA PIÙ ESPOSTA** (vedi sintesi) |
| **ABTG_SupertrendReversal** | 770924 · 770901 (225JPY) | `InpUseTimeWindow=false`. Ha `InpFridayClose` (`.mq5:155-167`, che **chiude E impedisce di riaprire** — semantica giusta) ma è **`false` nel `.set` live**, e comunque `InpFridayCloseHour=20` andrebbe verificato contro l'ora vera |
| **ABTG_SupertrendReversal_Ott** | 970901 (XAUUSD) | `InpUseTimeWindow=false`. ⚠️ **Non ha nemmeno `InpFridayClose`** (presente nel nativo, assente nell'Ottimizzato) |
| **ABTG_SupRev_NAS_H1_Ott** | 970913 (NASUSD) | `InpUseTimeWindow=false` |
| **ABTG_SuperWave** | 770531 (U30USD) | `InpUseTimeWindow=false` |
| **ABTG_SuperWave_DOW_H1_Ott** | 770511 (U30USD) | `InpUseTimeWindow=false` |
| **ABTG_EMA200** | 771531 (U30USD) | `InpUseCutoff=false` **e** `InpFridayClose=false` nel `.set` live. Due cancelli, tutti e due aperti |
| **ABTG_EMA200_Ottimizzato** | 971501 (XAUUSD) | idem |
| **ABTG_PTE** | 771321 (U30USD) · 771322 · 771332 (GBPUSD) | 🔴 **ZERO logica oraria nel sorgente.** Grep su `hour`/`day_of_week`/`session`: le uniche occorrenze (`.mq5:200`, `:214`) sono il **contatore equity giornaliero** e il reset di `gTradesToday` — **non toccano l'ingresso** |
| **ABTG_BreakingBand** | 772161 · 772162 · 772163 | Nessun input orario. `.mq5:462` è solo la metrica di giornata |
| **ABTG_PunteLarry** | 772341-772346 (6 sedie) | Nessun input orario. Solo `InpMaxDaysHold=5` (time-stop in **uscita**, non in ingresso) |
| **ABTG_CostToCost** | 772361 · 772362 | Nessun input orario |
| **ABTG_GapFill** | 772231-772235 (5 sedie) | Nessun input orario. Apre sulla **prima barra della nuova settimana** (`WEEK_ANCHOR`, `.mq5:315-322`, _"Nessun uso di day_of_week"_) |
| **Gold_Ichimoku_TK_ATR_EA** | 250604 (XAUUSD) | Nessun input orario né news |
| **BREAKOUT_EA_JPY_v3** | n/d (USDJPY) | 🔴 sorgente non nel repo — **non auditabile** |

---

## ⚠️ §5 — LA NOTA DI RISCHIO, IN CHIARO

1. **Il rischio non è teorico ed è a più corsie.** Un EA H1/H4 senza cancello
   orario valuta la barra che chiude alle 20:00 o alle 21:00 server: sul
   **venerdì** è dentro la finestra vietata, sul **DAX è dentro ogni giorno**.
   Con 30 sedie nude e 24 di queste su H1/H4, non è un caso raro: è
   **strutturale**.
2. **Distinguo che il mandato chiedeva, e che il codice conferma.** Dove
   esistono `InpFridayClose` (SupertrendReversal, EMA200) e `InpCloseHour`
   (aperture), la semantica è **giusta**: chiudono **e fanno `return`**, cioè
   impediscono anche di riaprire. Non è "solo flat". **Il problema non è la
   semantica: è che sono tutti a `false`/troppo tardi.** L'unico caso di "chiudo
   ma non impedisco di aprire" sarebbe `InpNewsFlatten` — ma è comunque
   subordinato a `InpUseNewsFilter`, quindi oggi non fa nulla.
3. **La flotta non è mai stata progettata per questo vincolo, ed è coerente:**
   fino al 27/08 il gap trading si credeva un problema da conto finanziato. La
   risposta del 28/08 lo rende **attivo dal primo trade della Challenge**.
4. **Cosa NON so, e non fingo di sapere:**
   - se i 38 grafici siano ancora attaccati **adesso** (foto del 25/08);
   - cosa contenga **realmente** `MQL5\Files\abtg_news.csv` sul VPS;
   - gli **orari di sessione e i festivi reali sul server FTMO** (broker
     diverso, fuso diverso: **ogni ora di questo documento va rimappata**);
   - lo stato ON/OFF vero delle **7 sedie senza `.set` in repo**;
   - se FTMO consideri "gap trading" anche l'**apertura alla riapertura**
     (famiglia GapFill) — la mail del 28/08 **non ha risposto a questo**.

---

## 🧭 §6 — DIREZIONE DI FIX (una riga, come da mandato)

Il posto naturale non è dentro 22 EA diversi: è **`ABTG_Guardian`** — è già
l'unico modulo che gira su tutto il conto, che **blocca i nuovi ingressi**
senza toccare le posizioni aperte (`InpDailyPausePct`, `InpMaxOpenRiskPct`
cap 3,25%) e che ha già l'ora del server come input (`InpDailyResetHour`):
aggiungergli un cancello "niente **nuove** aperture nelle N ore prima della
chiusura del simbolo, letta da `SymbolInfoSessionTrade` invece che cablata"
coprirebbe **tutte e 38 le sedie con una modifica sola**, dietro un input con
default neutro — invece di 22 patch da validare una per una.

**Fuori scope di questo giro. Da proporre, misurare e firmare a parte.**

---

_Censimento di sola lettura. Nessun `.mq5`, nessun `.set`, nessun preset
modificato. Fonte lista sedie: `censimento_rischio_2026-08-25_0731.txt`
(25/08 07:31, la più recente in repo, dichiarata vecchia di 3 giorni)._
