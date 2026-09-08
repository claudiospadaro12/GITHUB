# 🎯 CACCIA — INTRADAY **M30 / H1** SUGLI INDICI (D30EUR · U30USD · NASUSD), DUE LATI — 08/09/2026

**Seconda battuta della giornata.** La prima (`report/CACCIA_APERTURE_ORO_2026-09-08.md`)
ha guardato **le aperture**. Questa guarda **quello che succede DOPO**: motori che
non dipendono dalla candela d'apertura, sulla banda **M30/H1** — l'unica in cui,
per misura di casa, la volatilita' entra nella frontiera del costo
`stop >= 40 x spread` (stop naturale misurato: **20 punti a M5**, **17,4 a M15** →
sotto soglia; M30 e H1 ci stanno).

🔒 **Nessun EA in forward toccato. Nessun preset, nessun parametro, nessun magic.
Nessun backtest lanciato. Nessuna riga di codice copiata da nessuna fonte.**

---

## 🔴 LA PRIMA RIGA, che e' quella che il mandato chiede

> ## **3 PROMOSSI**, tutti e tre **A DUE LATI NATIVI** (long **E** short dallo stesso codice, non come opzione) — su **~150 titoli di strategia visti**, **26 sorgenti scaricati**, **13 letti riga per riga**, **8 archiviati in repo**.
>
> | # | nome | meccanismo in una riga | lati |
> |---|---|---|---|
> | 🥇 **P1** | **IB Completed** (TradingView, `Z1CwMI6V`) | rottura dell'**Initial Balance** → **ritorno** al livello → **fallimento del ritorno** → si entra NELLA direzione della rottura | **LONG + SHORT** simmetrici |
> | 🥈 **P2** | **LVN Rejection / Acceptance** (TradingView, `j35ygZIm`, MPL 2.0) | lo stesso bordo di banda genera **FADE** se rifiutato a volume basso, **BREAKOUT** se accettato per due chiusure — **l'arbitro E' il motore** | **LONG + SHORT** simmetrici |
> | 🥉 **P3** | **HV Spike (HVP + OR Breakout + Reversal)** (TradingView, `1oZNa7Oq`) | un **salto di percentile della volatilita'** (o il cambio di sessione) ancora una barra di riferimento; poi estensione 100% → breakout, oppure estensione fallita e rientro → fade | **LONG + SHORT** simmetrici |
>
> 🟡 **E la notizia scomoda, detta subito perche' condiziona tutti e tre:**
> lo **storico BCM sugli indici parte dal 2024.09.26** (misurato — 252 milioni di
> tick, `SPREAD_FLOTTA_MISURA_2026-09-03.md`), cioe' **~21 mesi**. Un motore da
> **1 operazione per seduta per simbolo** su 21 mesi fa **~220 operazioni totali
> per simbolo**: spezzate in IS/OOS fanno **~110 e ~110**, cioe' **sotto il
> pavimento dei 150** dell'emendamento della finestra. 👉 **Il campione si
> raggiunge solo mettendo in comune i tre simboli** (che e' esattamente l'unita'
> "FAMIGLIA" firmata da Claudio il 07/09), e questo va scritto **prima** dei
> numeri, non dopo. E' dentro i tre file prova.

---

## 0. ⚖️ I CRITERI — CONGELATI PRIMA DI APRIRE UN BROWSER

Presi **alla lettera** dal mandato, non riscritti dopo aver visto niente.

| # | criterio | soglia |
|---|---|---|
| **C1** | **TF di lavoro M30 o H1** | tenuta tipica **ore**, non minuti. M5/M15 fuori (frontiera del costo), D1 fuori (frequenza) |
| **C2** | **FREQUENZA di FAMIGLIA** | ≥ **1,00 op/giorno** su (motore × simboli schierabili). Un motore da 8 trade l'anno **si scarta e si dice** |
| **C3** | 🛑 **STOP PRESENTE ALL'INGRESSO** | niente stop = scarto immediato, **per quanto bello sia il grafico**. Include lo **stop virtuale** (uscita a `close`) e lo stop **messo dopo** l'apertura |
| **C4** | **frontiera del costo** | stop tipico in punti indice ≥ **40 × spread**. Spread MISURATI: **D30EUR 1,6-1,7 · U30USD 1,9-2,0 · NASUSD 1,6-1,8** → soglie **64-68 · 76-80 · 64-72** punti indice |
| **C5** | **due lati** (regola 25/08) | long **E** short. Un lato solo senza ragione strutturale = punto in meno, scritto |
| **C6** | **il §4 non si ammorbidisce** | martingala · griglia · recovery · hedge di copertura · piramidazione senza stop · repaint · look-ahead → fuori, **con la riga di codice che lo prova** |
| **C7** | **meccanismo NUOVO** (seconda caccia, 19/08) | mai "un'altra griglia sullo stesso motore morto". Include il **cambio di TF**: portare a M30 un motore falsificato a M15 **e'** un parametro diverso |
| **C8** | **gratuito, sorgente leggibile** | mai promuovere da una descrizione. Licenza annotata sempre |
| **C9** | **passa la lista dei caduti** | `backtest_pipeline/REGISTRO_TEST.md` + tassonomia dei 31 meccanismi del 03/09 + `biblioteca/sorgenti/` (96 sorgenti gia' setacciati) |

🔴 **E il criterio che non e' un criterio: i numeri dichiarati dagli autori non
pesano.** Nessuna percentuale di vincita, nessun profit factor, nessun "backtested
on 5 years" di questo dossier e' entrato in un punteggio. Dove li cito, li cito
**etichettati e neutri**.

---

## 1. 📕 COSA HO LETTO IN CASA PRIMA DI USCIRE

`CLAUDE.md` (per intero) · `report/CACCIA_APERTURE_ORO_2026-09-08.md` (la gemella
di stamattina, per non ripeterla) · `backtest_pipeline/caccia_strategie/CACCIA_TF_M30_2026-09-05.md`
(**709 righe, per intero** — e' la battuta M30 precedente, quella con **zero
promossi e cinque meccanismi falsificati**) · `CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md`
(la mappa dei **31 meccanismi**, con lo STATO di ciascuno) ·
`CACCIA_H1_INTRADAY_INDICI_2026-08-30.md` · `caccia_strategie/PROMEMORIA_SBLOCCO_FONTI.md` ·
gli indici dei quattro dossier del 06/09 (Nasdaq, DAX/Dow, short, TF basso) ·
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/` (**elenco completo dei 96
sorgenti gia' archiviati**) · `backtest_pipeline/prove/LEGGIMI.md` ·
`backtest_pipeline/prove/RELATIVO_D30_M15.txt` e `VWAPREVERT_DAX_M15_BOZZA.txt`
(la forma dei file prova).

### 1.1 ⛔ Cio' che NON ho riproposto, e la misura che lo chiude

| oggetto | perche' e' chiuso, col numero |
|---|---|
| **ORB / breakout nudo (M1)** | ⬛ **~210 celle a tick**. R45 **0/48**, R12 **48/48 negative**, capitolo M5 chiuso il 26/07 |
| **falsa rottura di livello — CRT / Turtle Soup / BreakinBox (M24)** | ⬛ **tre volte**, **0/30 celle a tick** |
| **fade della banda incondizionato (M14)** | ⬛ **due volte**, R108/R111 **6 finestre su 6 rosse**, con gradiente **H1 > M30 > M15** — cioe' peggiora proprio dove sto cercando |
| **fade dell'anomalo / sovrareazione (M17)** | ⬛ cimitero **interno ed esterno** |
| **fade degli estremi del range d'apertura (M5)** | ⬛ R42 **0/24 IS e 0/24 OOS** |
| **momentum "prima mezz'ora → ultima mezz'ora" (M13/Gao)** | ⬛ **R98** |
| **deriva a mezz'ora (M27)** | ⬛ chiuso il **05/09** su 1.518 sedute: la mezz'ora migliore rende **1,63 punti** contro un cancello di **4,95** = **0,33×** |
| **cross-asset indice × valuta** | ⬛ chiuso il 05/09 su **8.112 barre M30**: correlazione ritardata **−0,015**, monotonia rotta |
| **reversione overnight → intraday** | ⬛ chiuso il 05/09, universariata piatta e cross-sezionale **look-ahead** |
| **lead-lag USA→Europa giornaliero (M25 come motore)** | ⬛ chiuso il 05/09 su 2.532 giornate |
| **stagionalita' di calendario pura** | ⬛ **R63: 0/24 OOS** su 11.928 operazioni |
| **IBS (Internal Bar Strength)** | 🟡 **gia' IN CODA dal 06/09** (`CACCIA_NASDAQ_MECCANISMI_2026-09-06.md` §3). Ritrovato oggi in 6 varianti su TradingView, **non riproposto** — sarebbe contarlo due volte |
| **`RELATIVO` / pair trading a z-score (M7)** | 🟡 a tick **adesso**. Ritrovati oggi 4 script della stessa famiglia (`Pair Trade`, `Pairs Trading OLS`, …): **adiacenti, non riproposti** |
| **`NY Session Trend Retest`** | 🟡 **gia' in `biblioteca/sorgenti/` dal 30/08** e gia' misurato (`CORSIA_DEMO_CANDIDATI_v2.md` riga 154: **~0,25 op/g**, perdita mediana 58,0 punti = **29,7× lo spread**). Ritrovato oggi via tag `vwap` e **riconosciuto**: vedi §5.1 |

> 🔬 **Il rilievo di metodo che me lo ha fatto riconoscere, e vale per chi viene
> dopo:** su TradingView **lo stesso script ha due identificativi diversi** — lo
> slug pubblico (`zV6RrYm5`) e l'hash interno del sorgente (`dad2e548e366`), e in
> `biblioteca/sorgenti/` e' archiviato **con l'hash**. Un `grep` sullo slug dice
> "NUOVO" su una cosa che abbiamo gia'. 👉 **La novita' si verifica sul TITOLO e
> sul CONTENUTO, non sull'id.** Oggi mi ha salvato un falso promosso.

---

## 2. 📡 CONTROLLO POSITIVO — misurato OGGI, prima di cercare

Ogni riga e' una chiamata fatta stamattina, non una memoria.

| fonte | bersaglio | esito misurato oggi | verdetto |
|---|---|---|---|
| **MQL5 Code Base** — elenco | `mql5.com/en/code/mt5/experts` | **200, 85.172 byte**, 40 titoli+id+autore per pagina (primo: `SMC Liquidity Sweep Scalper`, id 77094) | 🟢 **PASSA** |
| **MQL5 Code Base** — scheda | `/en/code/77060` | **200**, `<meta name="description">` con descrizione completa **+ autore + data** | 🟢 **PASSA** |
| **MQL5 Code Base** — sorgente | `/en/code/download/69545/VR_Breakdown_level.mq5` | **200, 9.323 byte**, `.mq5` vero, 202 righe | 🟢 **PASSA** |
| **TradingView** — elenco | `/scripts/?script_type=strategies` | **200, 660.364 byte**, 20 titoli con slug | 🟢 **PASSA** |
| **TradingView** — sorgente Pine | `pine-facade/get/PUB;<hash>/last` | **200**, `scriptAccess = open_no_auth`, sorgente Pine in chiaro | 🟢 **PASSA** |
| **arXiv** — pagina | `arxiv.org/abs/2010.01727` | **200, 39.252 byte** | 🟢 **PASSA** |
| **arXiv** — API | `export.arxiv.org/api/query` (https) | **200, 10.358 byte**, 4 voci con titolo/data/id | 🟢 **PASSA** (⚠️ **solo HTTPS**, `http://` da 0 byte) |
| 🔴 **SSRN** | `papers.ssrn.com/...abstract_id=2730304` | **403, 5.505 byte** | 🔴 **NULLA** — dichiarato, non aggirato |

🔴 **Due muri e una trappola, tutti misurati oggi:**

1. **SSRN 403** — confermato per l'ennesima volta. Non l'ho riprovato oltre.
2. **La ricerca testuale di TradingView e' in JS**: `?text=initial+balance` torna
   **200 con ZERO script nell'HTML** (provato su 4 query). ➡️ **Su TradingView si
   puo' SOLO navigare per TAG.** E' il vincolo che ha dato la forma a tutta la
   battuta: 14 tag interrogati invece di 14 ricerche libere.
3. 🔬 **E un baco mio, che segnalo perche' e' costato 5 candidati e puo' costarli
   ancora:** l'hash del sorgente Pine **non e' esadecimale**. La regex
   `PUB;[a-f0-9]{32}` fallisce silenziosamente su hash come
   `PUB;9BvHDRiSb4aHK48WNncyAMDYOmYRzKe1` e fa sembrare "protetto" uno script
   **open source**. La forma giusta e' `PUB;[A-Za-z0-9]{32}`. 👉 **Cinque script
   che avevo marcato "NO HASH (protected?)" erano tutti `open_no_auth`.**

---

## 3. 🔭 COSA HO SFOGLIATO, FONTE PER FONTE

### 3.1 TradingView — **14 tag**, ~150 titoli di strategia, 25 sorgenti scaricati

Query sul **meccanismo**, mai sul formato. I tag gia' bruciati dalle battute
precedenti (`donchian`, `pivotpoints`, `statistics`, `correlation`, `intermarket`,
`timeofday`, `overnight`, `pairstrading`, `scalping`, `intraday`, `daytrading`,
`pullback`, `trendfollowing`, `volatility`, `dax`, `us30`, `nasdaq`) **non li ho
riaperti**. Questi sono nuovi:

| tag | strategie viste | cosa ha reso |
|---|---:|---|
| `vwap` | **24** | 1 sorgente letto (§4.4), il resto famiglia M9/M15 gia' in casa |
| `meanreversion` | **24** | 2 sorgenti letti; **6 varianti IBS** → gia' in coda dal 06/09 |
| `liquidity` | **15** | 1 sorgente letto (§5.2); **9 su 15 della stessa firma "JOAT"** = mashup senza tesi |
| `openingrange` | **5** | **P1 arriva da qui** |
| `marketprofile` | **2** | ⬜ **tag a resa quasi zero, da segnare** |
| `sessions` | **2** | ⬜ **idem — 2 titoli in tutto** |
| `indices` | **19** | dominato da giornalieri su SPY/QQQ; 3 sorgenti letti |
| `futures` | **22** | 2 sorgenti letti |
| `range` | **20** | 3 sorgenti letti |
| `reversal` | **24** | 1 sorgente letto |
| `linearregression` | **17** | 2 sorgenti letti |
| `orderflow` | **4** | ⬜ **quasi vuoto**, tutti "JOAT" |
| `dayofweek` | **3** | stagionali → ⬛ R63 |
| `volumeprofile` | **1** | ⬜ **UN solo script in tutto il tag** |
| `supportandresistance` | 23 | **P2 arriva dal tag `atr`, ma la famiglia si vede qui**: 5 griglie/DCA dichiarate |
| `standarddeviation` | 19 | bande su cripto; 1 sorgente letto |
| `keltnerchannel` | 9 | 1 sorgente letto (§5.3) |
| `atr` | **24** | **P2 arriva da qui**; 8 su 24 sono "JOAT" |

🏷️ **Da aggiungere alla lista dei tag a resa ZERO/quasi-zero** (vale per le prossime
cacce, si risparmiano minuti): **`volumeprofile` (1)** · **`sessions` (2)** ·
**`marketprofile` (2)** · **`dayofweek` (3)** · **`orderflow` (4)**.

🚩 **E un rilievo che vale piu' di un tag:** **su 4 tag diversi compaiono 12 script
firmati "JOAT"** (`Precision Edge System — JOAT`, `Quant Synthesis — JOAT`,
`Vantage Protocol — JOAT`, `Concordance Execution Model — JOAT`, …). Sono **lo
stesso autore che riempie i tag con nomi diversi**. Contarli come 12 candidati
sarebbe gonfiare il numero: **li conto come UNA famiglia, scartata in blocco per
"mashup senza tesi in una riga" (C-tesi)**, e lo scrivo invece di tacerlo.

### 3.2 MQL5 Code Base — **480 titoli su 12 pagine**, 1 sorgente scaricato

⚠️ **Non e' un censimento nuovo, ed e' voluto:** il Code Base e' stato censito il
02/09 su **400 id / 10 pagine** con esito _"zero motori intraday con SL vero +
rischio % + frequenza"_, e la battuta M30 del 05/09 ha scritto nero su bianco che
**"M30 non e' una ragione nuova"** per riaprirlo. Ho quindi fatto **una passata
mirata**, non una spazzolata: 480 titoli filtrati per parole del mio angolo
(`session|vwap|intraday|index|dax|nasdaq|dow|range|reversion|hour|open|close|day|sweep|liquidity|time|pivot|level`),
poi **incrociati uno per uno con il repo**.

**Risultato: 47 titoli in bersaglio, 46 gia' visti in casa, 1 nuovo.**

| id | titolo | esito |
|---|---|---|
| **69545** | *VR Breakdown level* (VOLDEMAR, 23/02/2026) | 🔴 **l'unico nuovo, e SCARTO** — §5.4 |

Gli altri 46 erano gia' in `SWEEP_MECCANISMI_2026-08-23.md`, nei dossier del 06/09,
o nella caccia di stamattina (`68082`, `68704`, `68764`, `71460`, `76153`, `76927`,
`77094`, `77060`). **Nessuno ricontrollato.**

### 3.3 arXiv q-fin — 2 query, resa quasi nulla, e lo dico

| query | voci | esito |
|---|---:|---|
| `all:"intraday momentum"` | 4 | **2605.04004** (*Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures*) e' **gia' citato in casa** (il muro d'attrito, §6.2); `2602.18912` e' su AAPL; `2009.04200` su cripto; `2006.08307` e' HMM = ML |
| `abs:"intraday reversal"` | 0 | 🔴 **zero voci** |

✅ Coerente con la regola gia' scritta il 03/09 e riconfermata il 05/09: **arXiv
indicizza la fisica della finanza, non la microstruttura empirica direzionale.**
👉 Per il nostro angolo **non e' una fonte produttiva**, e conviene smettere di
spenderci giri. Il canale utile per la letteratura resta il **motore di ricerca**,
con l'etichetta `[LETTO-VIA-SEARCH]` e senza far pesare nulla.

---

## 4. ✅ I TRE PROMOSSI — schede complete

### 🥇 P1 · **IB Completed** — rottura, ritorno, **fallimento del ritorno**

```
NOME            IB Completed
FONTE / URL     https://www.tradingview.com/script/Z1CwMI6V-IB-Completed/
AUTORE / DATA   Genxtraders  ·  creato 25/08/2026  ·  Pine v6
LICENZA         [INCERTO] -- nessuna intestazione di licenza nel sorgente.
                scriptAccess = "open_no_auth" [VERIFICATO oggi via pine-facade].
                Nessuna riga copiata; l'attribuzione va in testa al .mq5 derivato.
ARCHIVIO        biblioteca/sorgenti/IbCompleted_Genxtraders-NOLICENSE_tvZ1CwMI6V_2026-09-08.pine
RIGHE / INPUT   1.092 righe · 124 input dichiarati, di cui 45 sono COLORI e
                "Show ..." e ~60 sono livelli opzionali TUTTI a default FALSE
                (PWH/PWL, PDH/PDL, magic lines, ONL, SMA D9/H4/100/200).
                >>> Gli input che toccano il SEGNALE sono ~16.  [INFERITO,
                    contati a mano sui gruppi g_ib/g_piv/g_sma/g_htf/g_risk/g_sess]

TESI IN UNA RIGA
  "Guadagna perche' chi ha comprato la rottura dell'Initial Balance viene
   riportato sul livello, si convince di essere in trappola, e quando il
   livello CEDE DI NUOVO e' lui a doverlo vendere: il secondo passaggio ha
   dietro liquidita' forzata, il primo no."

MECCANICA (letta riga per riga, righe 706-801 del sorgente)
  1. si costruisce l'Initial Balance nella finestra 09:30-10:30 (input);
  2. LATO SHORT: (a) il minimo rompe sotto IB-low; (b) RITORNO: il massimo
     risale a toccare IB-low E la chiusura torna sopra la SMA9; (c) INGRESSO:
     chiusura di nuovo SOTTO la SMA9 E SOTTO IB-low.  LONG speculare, e il
     codice e' scritto due volte in modo simmetrico (righe 706-756 / 757-801).
  3. una sola operazione per seduta (`sessionTradeDone` blocca ENTRAMBI i lati);
  4. blocco orario: niente ingressi dopo il cutoff, chiusura forzata al goFlat.

GESTIONE RISCHIO
  ✅ sizing "Risk-Based" NEL CODICE (riga 692: qty = riskAmount /
     (ticks_di_stop * tickVal)) -- cioe' rischio per operazione, non lotto fisso
  ✅ stop STRUTTURALE presente all'ingresso: minimo/massimo di swing confermato
     (`ta.pivotlow(low,2,2)`) con buffer; in mancanza, l'estremo del ritorno
  ✅ uscite a scaglioni 1R / 2R / 3R / 4R / 5R + BREAKEVEN + flat di fine seduta
     -- cioe' GIA' la gestione di casa (parziale 1R + BE + runner)
  ✅ pyramiding = 0, una posizione alla volta

BANDIERE ROSSE   NESSUNA.  Verificate una per una:
  - martingala/griglia/averaging: assenti (pyramiding=0, nessun lotto dipendente
    dall'esito precedente)
  - look-ahead: TUTTE le 9 chiamate `request.security` portano
    `lookahead = barmerge.lookahead_off` ESPLICITO (righe 243, 329-336)
  - repaint: il pivot e' confermato (`pivotRight` barre di ritardo) e il codice
    lo indicizza correttamente a `bar_index - pivotRight`; il GRILLETTO non usa
    il pivot, usa chiusure confermate contro SMA9 e contro il livello IB
  - riempimento ottimista: `calc_on_every_tick = false` e
    `process_orders_on_close = false` -- e' la configurazione CONSERVATIVA
  - DLL/rete/licenze: assenti
  ⚠️ un solo neo, dichiarato: `default_qty_type = strategy.fixed` in intestazione;
     il sizing a rischio e' una MODALITA' (`sizingMode`), non il default.

COSTO DI PORTING  Pine -> MQL5 = RISCRITTURA, non traduzione.
                  ~6-9 ore per la sola macchina a stati + IB + sizing.
                  ✅ MA la parte piu' cara (scala 1R..5R + BE + flat orario) in
                     casa ESISTE GIA' negli EA DAX/Dow: si riusa, non si riscrive.

PUNTEGGIO (0-2)
  [2] semplicita'          16 input di segnale, 3 stati, nessun indicatore esotico
  [2] il filtro E' il motore  non c'e' NESSUN motore sotto: senza la sequenza
                              rottura-ritorno-fallimento non esiste segnale
  [2] tesi di mercato       scritta sopra in una riga
  [2] riempie un BUCO       due lati NATIVI, e nessuna sedia viva fa
                            "break-retest-fail" su un livello di SEDUTA
  [1] testabile senza riscritture   -1: e' Pine, va portato
  ------------------------------------------------------------------
  TOTALE 9/10   ->  🟢 PROVA SUBITO

PERCHE'   Perche' non e' un ORB. L'ORB compra la rottura; questo la SCARTA e
          aspetta che il ritorno fallisca -- che e' la differenza fra il
          motore ⬛ con 210 celle rosse e una sequenza che in casa non e' mai
          stata misurata.
```

**🔍 Perche' NON e' un caduto — verificato uno per uno, non asserito:**

| caduto | perche' P1 non e' lui |
|---|---|
| **M1 · ORB nudo** (⬛ 210 celle) | l'ORB **entra sulla rottura**. Qui la rottura **non e' un ingresso**: e' solo il passo 1 di 3. Un ORB e questo motore, sulla stessa seduta, prendono trade **diversi o nessuno** |
| **M24 · falsa rottura / CRT** (⬛ 0/30) | il CRT **fade la rottura** (entra CONTRO). Qui si entra **NELLA direzione** della rottura, dopo che il ritorno e' fallito. **Segno opposto** |
| **R42 · fade degli estremi del box** (0/24+0/24) | idem: quello e' contrarian sul livello, questo e' continuazione |
| **`NY First Candle Break and Retest`** (in biblioteca dal 25/08) | quello lavora sulla **prima candela** di NY (una barra); qui il livello e' un **Initial Balance da 60 minuti** e c'e' un terzo stato (il **fallimento** del ritorno) che li' non esiste |
| **`InitialBalanceBO`** (in biblioteca dal 28/08, slug `4732849691c1`) | **script diverso, autore diverso**: quello e' un IB **breakout** nudo. Confrontati oggi: `4732849691c1` = 306 righe, entrata sulla rottura; `Z1CwMI6V` = 1.092 righe, entrata al terzo stato |

**🏛️ In ottica prop:** una operazione per seduta per simbolo, **flat obbligatorio a
fine giornata** (nessuna esposizione overnight → **nessuno swap, nessuno spread
notturno**: sul DAX quello e' **3,5-3,9 punti contro 1,6-1,7 in sessione**,
misurato). Il rischio giornaliero e' **strutturalmente 1R per simbolo**: con tre
simboli e 0,65% l'esposizione peggiore di giornata e' **~1,95%**, contro un cap
giornaliero prop del **5%**. 🔴 **Ma i tre simboli sono correlati**: se rompono e
falliscono lo stesso giorno nella stessa direzione, **le tre perdite arrivano
insieme** — e' esattamente il caso che il tetto per cluster al 3,0% dovrebbe
coprire, tetto che **e' FIRMATO ma NON ATTIVO nel Guardian**. Va detto ogni volta.

---

### 🥈 P2 · **LVN Rejection / Acceptance** — l'arbitro che sceglie fra fade e breakout

```
NOME            LVN Rejection / Acceptance Strategy
FONTE / URL     https://www.tradingview.com/script/j35ygZIm-LVN-Rejection-Acceptance-Strategy/
AUTORE / DATA   AIScripts  ·  creato 06/05/2026  ·  Pine v6
LICENZA         🟢 MPL 2.0  -- DICHIARATA in testa al sorgente [VERIFICATO]
ARCHIVIO        biblioteca/sorgenti/LvnRejectionAcceptance_AIScripts-MPL2_tvj35ygZIm_2026-09-08.pine
RIGHE / INPUT   57 righe · 5 input.  Cinque.

TESI IN UNA RIGA
  "Guadagna perche' lo stesso bordo di banda vuol dire due cose OPPOSTE, e il
   modo di distinguerle e' il VOLUME: se il prezzo lo perfora e rientra SENZA
   volume, nessuno lo voleva davvero -> si torna indietro; se lo tiene per due
   chiusure, il livello e' stato ACCETTATO -> si va avanti."

MECCANICA (righe 27-33, il cuore e' 6 righe)
  banda = SMA(40) +/- 0,8 * ATR(14)
  RIFIUTO rialzista:  minimo SOTTO il bordo basso, chiusura SOPRA il bordo basso,
                      E volume < 0,8 * media(volume,40)          -> LONG (fade)
  RIFIUTO ribassista: speculare                                   -> SHORT (fade)
  ACCETTAZIONE rialz.: due chiusure consecutive SOPRA il bordo alto -> LONG (bo)
  ACCETTAZIONE ribas.: due chiusure consecutive SOTTO il bordo basso-> SHORT (bo)
  Una posizione alla volta (`strategy.position_size == 0`).

GESTIONE RISCHIO
  ✅ stop e target ATR simmetrici: stop 1,5*ATR, target 1,5*ATR*RR (RR=2)
  🔴 DIFETTO VERO, e va scritto: `strategy.exit` e' chiamato FUORI dal blocco
     di ingresso e usa `strategy.position_avg_price`, che sulla barra
     d'ingresso vale ancora `na`.  ==> LA PRIMA BARRA E' SENZA STOP.
     Su M30 sono 30 minuti scoperti.  E' un baco di GESTIONE, non di motore:
     in MQL5 lo stop si passa dentro l'OrderSend e il problema non esiste.

BANDIERE ROSSE   nessuna nel MOTORE.  Nessun martingala, nessuna griglia,
                 nessun `request.security`, nessuna rete, nessun repaint
                 (tutto su chiusure confermate).
                 🔴 la barra d'ingresso senza stop e' bandiera §4 sull'EA COSI'
                    COM'E' -- e infatti l'EA cosi' com'e' NON si schiera: si
                    riscrive la gestione, che e' la parte che sappiamo fare.

⚠️ IL NOME MENTE, E LO DICO SUBITO: non c'e' nessun Volume Profile e nessun
   Low Volume Node.  E' una banda SMA+-ATR.  Chi promuovesse questo script
   PER IL NOME comprerebbe una cosa che non c'e'.  Io lo promuovo per le sei
   righe che ho letto, non per il titolo.

COSTO DI PORTING  ~3-4 ore.  57 righe, 5 input, zero dipendenze.
                  E' il candidato piu' ECONOMICO dei tre.

PUNTEGGIO (0-2)
  [2] semplicita'          5 input.  Il minimo mai visto in una caccia di questo
                           progetto con due lati e uno stop
  [2] il filtro E' il motore  l'arbitro rifiuto/accettazione NON e' un filtro
                              sopra qualcosa: e' l'unica cosa che decide se si
                              compra o si vende
  [2] tesi di mercato       scritta sopra
  [2] riempie un BUCO       due lati nativi + e' l'unico motore letto oggi che
                            puo' produrre un FADE e un BREAKOUT dallo stesso
                            livello.  In flotta non esiste nulla di simile
  [1] testabile senza riscritture   -1: Pine, e la gestione va rifatta
  ------------------------------------------------------------------
  TOTALE 9/10   ->  🟢 PROVA SUBITO
```

**🔍 Perche' NON e' un caduto:**

| caduto | perche' P2 non e' lui |
|---|---|
| **M14 · fade della banda** (⬛ 6/6 rosse, gradiente H1>M30>M15) | 🔴 **Questa e' l'obiezione seria e la scrivo per prima.** M14 e' il fade **INCONDIZIONATO**: si vende il bordo alto e basta. Qui il fade richiede **due condizioni congiunte** (perforazione **con rientro nella stessa barra** + **volume sotto media**) e — soprattutto — **la stessa banda produce anche il segnale OPPOSTO** quando quelle condizioni mancano. **Non e' M14 con un filtro: e' un arbitro che contiene M14 come uno dei due rami.** Se la misura dira' che il ramo fade e' rosso e quello breakout no, avremo imparato qualcosa che 6 finestre di M14 non potevano dire |
| **M19 · arbitro di regime** (🟨 in canna dal 01/09) | 🟡 **e' parente, e lo dichiaro.** M19 sceglie il motore in base allo **stato di volatilita'** (contrazione-espansione). Qui l'arbitro e' il **comportamento del prezzo sul livello** (rifiutato o accettato) + il **volume**. **Arbitri diversi, stessa idea madre.** Non e' "un'altra griglia su M19": e' una seconda implementazione della stessa famiglia, con un discriminante che M19 non ha |
| **M17 · fade dell'anomalo** (⬛) | quello fade un'ESTENSIONE eccezionale (coda). Qui il rifiuto e' un evento **ordinario**: un bordo perforato e rientrato, che capita quasi ogni giorno |

**🏛️ In ottica prop:** frequenza **piu' alta** dei due gemelli (nessun limite di
una operazione per seduta) — 🟢 buono per il pavimento, 🔴 **e' il candidato con
il rischio giornaliero peggiore dei tre**, perche' niente gli impedisce di
prendere 3-4 operazioni nello stesso pomeriggio sullo stesso simbolo. **Va misurata
la peggior giornata prima di qualunque altra cosa** (la nostra misurata e' −2,06%,
R51, ≈3,2R a 0,65%). ⚠️ E il volume: su BCM sugli indici e' **tick volume**, non
volume scambiato — **il ramo "rifiuto" poggia su una variabile che sul nostro feed
significa un'altra cosa**. E' il rischio numero 1 del porting, ed e' scritto nel
file prova.

---

### 🥉 P3 · **HV Spike** — la volatilita' che ancora il livello, poi due rami

```
NOME            HV Spike Strategy (HVP + OR Breakout + Reversal + TP/SL Modes)
FONTE / URL     https://www.tradingview.com/script/1oZNa7Oq-HV-Spike-Strategy-HVP-OR-Breakout-Reversal-TP-SL-Modes/
AUTORE / DATA   kostastrovas  ·  creato 26/10/2025  ·  Pine v6
LICENZA         [INCERTO] -- nessuna intestazione. scriptAccess = "open_no_auth"
ARCHIVIO        biblioteca/sorgenti/HvSpikeOrBreakoutReversal_kostastrovas-NOLICENSE_tv1oZNa7Oq_2026-09-08.pine
RIGHE / INPUT   134 righe · 15 input (al tetto di casa, non sopra)

TESI IN UNA RIGA
  "Guadagna perche' la barra in cui la volatilita' SALTA di percentile e' la
   barra in cui e' arrivata l'informazione: il suo range diventa il metro della
   giornata, e il mercato o lo estende (continuazione) o non ce la fa e rientra
   (esaurimento).  Il livello non lo scegliamo noi: lo sceglie l'evento."

MECCANICA (righe 60-125)
  ATTIVAZIONE (due modalita', input):
    (a) "HV Spike": il percentile a 252 barre della volatilita' storica
        ATTRAVERSA verso l'alto una soglia (default 50)      <- evento raro
    (b) "Market Sessions": apertura di Tokyo / Londra / New York <- 3/giorno
  Alla barra di attivazione si congelano: spikeHigh, spikeLow, e i livelli
  a +/-50% e +/-100% del range di quella barra.
  RAMO BREAKOUT:  chiusura oltre il livello 100%                -> nella direzione
  RAMO REVERSAL:  c'era stata l'estensione 100%, il prezzo E' RIENTRATO dentro
                  il range della barra evento, e poi taglia il 50% opposto
                                                                -> contro
  Una sola operazione per attivazione (`tradeTaken`).

GESTIONE RISCHIO
  ✅ bracket ATR simmetrico: stop 1,0*ATR(14), take 2,0*ATR(14)  -> RR 2,0
  🔴 STESSO BACO DI P2, e qui e' PEGGIO: `entryPrice = strategy.position_avg_price`
     e' calcolato PRIMA dell'ingresso (riga 108), quindi sulla barra d'ingresso
     vale `na`, quindi `strategy.exit(stop = na, limit = na)` NON PIAZZA NIENTE.
     E `strategy.exit` NON viene richiamato nelle barre successive.
     ==> IN QUESTO SCRIPT LO STOP E IL TAKE NON ESISTONO AFFATTO.
     Qualunque numero di performance l'autore mostri e' quindi il risultato di
     una strategia SENZA USCITE.  Non lo commento oltre: non pesa comunque.

BANDIERE ROSSE   nessuna nel MOTORE (no martingala, no griglia, no security,
                 no rete, no repaint -- tutte chiusure confermate).
                 🔴 la GESTIONE e' rotta, non "scadente": non c'e'.

COSTO DI PORTING  ~4-5 ore (il percentile HV a 252 barre e' il pezzo piu' noioso).

PUNTEGGIO (0-2)
  [2] semplicita'          15 input, al tetto
  [2] il filtro E' il motore  il salto di percentile non filtra niente: CREA il
                              livello.  Senza di lui non c'e' nemmeno un prezzo
                              di riferimento
  [2] tesi di mercato       scritta sopra
  [1] riempie un BUCO       -1: il ramo breakout e' vicino a famiglie ⬛ e la
                            modalita' "sessioni" e' un ORB.  Il pezzo NUOVO e'
                            l'ancoraggio all'EVENTO DI VOLATILITA'
  [1] testabile senza riscritture   -1: Pine + gestione da scrivere da zero
  ------------------------------------------------------------------
  TOTALE 8/10   ->  🟢 PROVA SUBITO (ultimo dei tre)

⚠️ E LA CONDIZIONE CHE METTO IO, PRIMA DEI NUMERI:
   si prova SOLO la modalita' (a) "HV Spike".  La modalita' (b)
   "Market Sessions" e' un ORB con un altro nome, e l'ORB e' ⬛ con 210 celle:
   provarla sarebbe la Regola della Seconda Caccia violata alla lettera.
   >>> Conseguenza dichiarata subito: senza il ramo sessioni la FREQUENZA
       CROLLA (l'attraversamento di percentile e' un evento, non un orario).
       Se non arriva al pavimento di famiglia, P3 muore per C2 -- e va bene
       cosi': meglio saperlo alla prima passata che al terzo round.
```

**🔍 Perche' NON e' un caduto:** **M2** (ORB condizionato allo stato di volatilita')
e' 🟨 *in canna/parziale*, e questo e' il suo parente piu' vicino. La differenza,
scritta: in M2 la volatilita' **autorizza** un box orario; qui la volatilita'
**e' il box** — la barra dell'evento e' il riferimento, e non c'e' nessun orario.
👉 **M2 e' "ORB con permesso", P3 e' "livello generato dall'evento".** Se sembra
un cavillo, il modo di scioglierlo e' misurarlo, non discuterlo.

**🏛️ In ottica prop:** e' il piu' **irregolare** dei tre — a raffiche, perche' i
salti di volatilita' si raggruppano. 🔴 **E' la forma che il DD trailing punisce
di piu'** (lunghi piatti e poi movimenti): se Claudio sceglie una prop con
drawdown che insegue l'equity, questo candidato va rivalutato da zero, perche'
**tutte le nostre Monte Carlo sono su DD statico dal deposito**.

---

## 5. 🗑️ I BOCCIATI — uno per riga, col motivo

### 5.1 Letti nel SORGENTE riga per riga e scartati (10)

| # | oggetto | fonte | 🔴 motivo, in una riga |
|---|---|---|---|
| 1 | **VWAP Touch (Rolling Prev-VWAP)** `4JD54K2I` | TV, kalvey16, 26/02/2026, 234 righe | 🟡 **IN CODA, non scarto secco**: motore = ritorno alla VWAP **nella direzione della seduta** = **M9**, gia' misurato in casa **nudo a PF 1,002** (pareggio). Il pezzo nuovo e' la **macchina di rientro dopo lo stop** (4 modalita': attesa / conferma di flip / allungo+flip) — ma e' un **filtro aggiunto a un motore gia' tarato**, e in casa quella forma fa **0 successi su 5**. Neo tecnico: `calc_on_every_tick = true` + ordine limite = **riempimento ottimista**; `qty` = 1 contratto fisso |
| 2 | **NY Session Trend Retest** `zV6RrYm5` | TV, itzkarmakyo, MPL 2.0, 705 righe | 🔴 **DOPPIONE — ce l'abbiamo gia'**: identico byte per byte (704 righe) a `biblioteca/sorgenti/NySessionTrendRetest_..._2026-08-30.pine`, archiviato il 30/08 e **gia' misurato** (~0,25 op/g). Merito tecnico che segnalo lo stesso: 34 input, ma il **gate di regime "pendenza della VWAP + ampiezza minima"** e' l'unico pezzo che M9 nudo non ha |
| 3 | **Execution-Aware Trend [BSL]** `Z9O5w3SG` | TV, BarState Labs, MPL 2.0, 304 righe, 02/09/2026 | 🔴 **stop VIRTUALE (C3)**: l'uscita e' `strategy.close` su una trascinata a **chiusura di barra**, non un ordine di stop → su un broker e' un SL che non esiste. **+** motore = **rottura di canale Donchian(20)** = famiglia ⬛. 🟢 Da tenere agli atti una cosa sola, ed e' metodologia non strategia: ha un input `Active sample = Full history / In-sample / Out-of-sample` **dentro lo script**, con il tooltip _"Full history is a descriptive starting point, not validation"_. **E' la nostra disciplina IS/OOS scritta da un estraneo.** |
| 4 | **TriAnchor Elastic Reversion** `vbiLfaCo` | TV, exlux, MPL 2.0, 137 righe | 🔴 **tre motivi indipendenti**: (a) **il lato LONG non ha stop** — il blocco dei bracket long e' **commentato** (ultime 6 righe del sorgente), solo lo short e' protetto → asimmetria di rischio; (b) dipende da **SPY / QQQ / IWM** per il gate di ampiezza: **simboli che BCM non quota**; (c) `if want_long[10] strategy.entry(...)` = **ingresso 10 barre dopo il segnale**, senza una ragione scritta. 🟢 **Un'idea da rubare, e la scrivo perche' e' buona**: la "**energia elastica**" = somma dei quadrati delle distanze normalizzate da **tre VWAP ancorate** (giorno, settimana, mese), e uno **z-score robusto su mediana/MAD** invece che media/deviazione. Sono due tecniche che in casa non usiamo e che costano poche righe |
| 5 | **FlowStateTrader** `omL7kjy0` | TV, 518 righe, 26 input | 🔴 **la condizione d'ingresso e' quasi vacua**: `support = ta.lowest(low, 20)` include la barra corrente, quindi `low <= support` e' vero **ogni volta che la barra fa il nuovo minimo a 20 barre** e la seconda condizione `close > support - 0,5*ATR` e' quasi sempre vera → resta "nuovo minimo a 20 barre + volume". **+** lotto fisso in contratti. 🟢 Ha comunque stop ATR reale, TP1/TP2 parziali e trascinata a tre modalita' |
| 6 | **Channel Reversion System (CRS)** `XRZCjbFr` | TV, Mateo Sandoval, 90 righe | 🔴 **fuori perimetro tre volte**: timeframe **giornaliero**, **LONG-ONLY** (C5), e l'autore stesso scrive _"flat roughly 80% of the time"_ → **frequenza fuori scala** (C2). Motore = quarto inferiore di Donchian(50) + SMA200 = **doppione di `ABTG_EMA200`** |
| 7 | **3 Red / 3 Green + Volatility Check** `1v0u3Weg` | TV, 54 righe | 🔴 **nessuno stop** (C3): l'uscita e' "3 candele verdi" o 22 giorni di tempo. **+** giornaliero, **+** long-only |
| 8 | **Range Filter Strategy with ATR TP/SL** `jtm3aJ4O` | TV, 56 righe | 🔴 **stesso baco na di P2/P3** (`position_avg_price` prima dell'ingresso) **+** motore = **rottura di banda Bollinger** = famiglia bande, e la rottura di banda e' Donchian travestito |
| 9 | **Sniper V4: Liquidity & Fast Exhaustion** (`AxMan…`) `72gQqAzW` | TV, 78 righe | 🔴 **nessuno stop** (C3): si esce solo sull'esaurimento opposto → perdita illimitata. **+** motore = **sweep di liquidita' (M24 ⬛ 3 volte)** + **RSI di esaurimento (M17 ⬛)**: due cadaveri sommati |
| 10 | **Volume Breakout Strategy [Tables Fixed]** `36zwwSMa` | TV, 205 righe | 🔴 **cinque filtri appiccicati** a una rottura di Keltner (EMA220 + ADX>20 + RSI>50 + volume + trend): e' **esattamente** la forma che in casa fa **0 successi su 5**. **+ 50% dell'equity per operazione con leva 2** |

### 5.2 Letti nel SORGENTE — MQL5 Code Base (1)

| oggetto | 🔴 motivo |
|---|---|
| **VR Breakdown level** (Code Base **69545**, VOLDEMAR, 23/02/2026, 202 righe, `.mq5` scaricato e letto) | 🔴 **STOP NON PRESENTE ALL'INGRESSO (C3), e lo prova il codice**: alla riga 79 `trade.Buy(lt)` viene chiamato **senza `sl` e senza `tp`**; lo stop viene messo dopo, in un ciclo che itera su `total = PositionsTotal()` **letto PRIMA dell'apertura** (riga 61) → **la posizione nuova non e' nel ciclo e resta scoperta fino al tick successivo**. 🔴 **+ lotto fisso** `input double iLots = 0.01`. 🔴 **+** motore = rottura del massimo/minimo della barra precedente = **breakout nudo, famiglia ⬛**. 🔴 **+** nessun limite al numero di posizioni per seduta, nessun filtro orario |

### 5.3 Scartati al PRIMO TAGLIO (sorgente **non** aperto — dichiarato)

| gruppo | n | motivo, in una riga |
|---|---:|---|
| **famiglia "JOAT"** (`Precision Edge`, `Quant Synthesis`, `Vantage Protocol`, `Concordance ×4`, `Helios`, `Aureate`, `Charter`, `Bastion`, `Tectonic`, `Fracture`, `Sovereign`, `Caldera`, `APEX V2`, `CryptoFlux`, `Liquidity Maxing`) | **17** | stesso autore, nomi diversi, **nessuna tesi in una riga** ricavabile dalla scheda. Contate come **una** famiglia, scartata in blocco |
| **IBS in tutte le sue forme** (`SHORT-ONLY IBS`, `IBS for SPY and NDQ`, `IBS Strategy`, `Bollinger+IBS`, `Avg H/L Range + IBS`, …) | **6** | 🟡 **non e' uno scarto, e' un "gia' in coda"**: promosso il 06/09 come candidato B. **Non lo conto due volte.** (Letto lo stesso il sorgente di `Ay41FF7e`: **nessuno stop**, uscita solo su IBS ≤ 0,3 — conferma il difetto gia' registrato il 06/09) |
| **SHORT-ONLY di Botnet101** (`10-Bar Low Pullback`, `Consecutive Close High`, `Consecutive Bars Above MA`, `ATR Sell the Rip`) | **4** | 🟡 il **lato** e' il nostro buco, ma sono tutti **giornalieri su SPY/QQQ** e **senza stop** (stessa firma dell'IBS letto sopra). **Fuori per C1 e C3** |
| **griglie / DCA dichiarate nel titolo** (`AliceTears Grid`, `Continuous Market Grid bot`, `3Commas ×2`, `Adaptive S-R Reversal DCA`, `TRADLEWARE DCA`, `OrangePulse DCA`, `dca-martingale strategy`, `AUTOMATIC GRID BOT`) | **9** | **§4, senza appello** |
| **cripto / azionario indiano / ETF-only** (BANKNIFTY, LINKUSDT, ETHUSD, ONEUSDT, BTC, INTC, SPY-solo…) | **~22** | **strumenti che BCM non quota** o fuori dai simboli attivi |
| **stagionali / calendario** (`Turnaround Tuesday`, `Turn of the Month`, `Buy Tuesday`, `Seasonal Strategies V1`, `FTSE Fridays`, `TDOW`) | **6** | ⬛ **R63: 0/24 OOS** su 11.928 operazioni |
| **pair trading / z-score su spread** (`Pair Trade`, `Pair Trade crypto`, `Pairs Trading OLS`, `Return Dispersion Matrix`) | **4** | 🟡 **adiacenti a `RELATIVO`**, che e' **a tick adesso**. Non si duplica un motore in corsa |
| **mashup multi-indicatore senza tesi** (`Ultimate TEMA LSMA Institutional`, `Squared9 Pro`, `Tristan's Multi-Indicator ×2`, `Quadruple EMA + S/R`, `Ichimoku+MACD+CMF+TSI`, `SSL Wave Trend`, `Multi-Indicator Swing`, `KALKI TFXBOT`, …) | **~15** | nessuna tesi scrivibile in una riga → **non e' un esperimento, e' una spazzolata** |
| **utility / template / non-strategie** (`How To Set Backtest Date Range` ×3, `TradingView Alerts to MT4/MT5` ×2, `Automate on Hyperliquid`, `Close Trade at end of day`, `Alert alertcondition`) | **~9** | non sono strategie |
| **Code Base — titoli in bersaglio ma gia' visti in casa** | **46** | gia' in `SWEEP_MECCANISMI_2026-08-23.md`, nei quattro dossier del 06/09 o nella caccia di stamattina. **Non ricontrollati, per regola** |

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

| buco | cosa ci costa |
|---|---|
| 🔴 **SSRN** — **403 misurato oggi** | la letteratura peer-reviewed sull'intraday degli indici resta **fuori portata diretta**. Tutto cio' che sarebbe venuto di li' oggi **manca**, e non l'ho sostituito con la memoria |
| 🔴 **La ricerca testuale di TradingView e' in JS** | ho potuto navigare **solo per tag**. Uno script con un meccanismo perfetto ma **taggato male e' invisibile**, e non so quanti siano. E' il limite piu' grande di questa battuta |
| 🔴 **Il tetto di 24 script per pagina di tag** | i tag `vwap`, `meanreversion`, `reversal`, `atr`, `range`, `futures` sono tutti **esattamente a 24** = **troncati**. **Non ho visto la coda di 6 tag su 18** |
| 🔴 **I numeri di performance di TUTTI i candidati** | non li ho guardati, per criterio (§0). Non e' un buco: e' la regola. Ma va detto che **non so** se P1/P2/P3 "funzionino" secondo i loro autori, e **non voglio saperlo prima della nostra misura** |
| 🟠 **~85 titoli scartati da titolo/scheda** | sorgente **non aperto**. Motivo per gruppo in §5.3. Se uno di quei gruppi fosse sbagliato, e' li' che ho sbagliato |
| 🟠 **Lo storico BCM sugli indici e' 21 mesi** (2024.09.26, **misurato**) | ⚠️ **il vincolo piu' duro di questa consegna**, e non e' colpa dei candidati: un motore da 1 op/seduta **non arriva a 150 trade per parte su un simbolo solo**. La via e' **mettere in comune i tre indici** (unita' FAMIGLIA, firmata il 07/09) → e' scritto nei tre file prova, prima dei numeri |
| 🟠 **Il "volume" di P2 su BCM e' TICK VOLUME** | il ramo *rifiuto* poggia su `volume < 0,8 × media`. Sul nostro feed quel numero conta **i tick, non i contratti**. **Non e' la stessa variabile del sorgente** e puo' cambiare il segno del ramo. Rischio n.1 del porting, dichiarato nel file prova |
| ⬜ **`H-L Range Strategy`, `Breakout Scalper Session`, `cATRpillar`, `Linear Regression Reverse`, `Moving Regression Band`** | scaricati **dopo** aver corretto il baco della regex, **ma non letti a fondo** per budget di tempo. Sono in `open_no_auth`, quindi **recuperabili in 10 minuti** da chi viene dopo. Li dichiaro invece di fingere di averli valutati |

---

## 7. ⚖️ RIEPILOGO DEI NUMERI DELLA BATTUTA

| | |
|---|---:|
| fonti col controllo positivo **passato** | **4** (Code Base elenco/scheda/sorgente, TradingView elenco/sorgente, arXiv pagina/API) |
| fonti **NULLE**, dichiarate | **1** (SSRN, 403) |
| tag TradingView interrogati (tutti **nuovi**) | **18** |
| titoli di strategia visti su TradingView | **~150** |
| titoli MQL5 Code Base scorsi (12 pagine) | **480** |
| di cui in bersaglio per il mio angolo | **47** |
| di cui **nuovi** per il repo | **1** |
| sorgenti **scaricati** | **26** (25 Pine + 1 `.mq5`) |
| sorgenti **letti riga per riga** | **13** |
| sorgenti **archiviati in repo** oggi | **8** |
| 🟢 **PROMOSSI** | **3** — e **tutti e tre a due lati nativi** |
| 🔴 bocciati **col sorgente in mano** | **11** |
| ⚪ bocciati al primo taglio (dichiarato) | **~85 titoli, in 10 gruppi** |
| file prova consegnati | **3** |

**I tre motivi ricorrenti per cui il resto e' caduto**, in ordine di frequenza:

1. 🥇 **NESSUNO STOP, o uno stop che non e' un ordine.** 5 sorgenti su 13 letti.
   E in **3 casi su 5** non e' nemmeno una scelta dell'autore: e' **lo stesso
   identico baco Pine** — `strategy.position_avg_price` letto **prima**
   dell'ingresso, quando vale ancora `na`. 👉 **Chi legge Pine in questo progetto
   controlli sempre quella riga.** Un backtest con `stop = na` e' un backtest
   **senza stop**, e sembra bellissimo.
2. 🥈 **Motore gia' nel cimitero di casa**, con nomi nuovi: ORB, sweep di
   liquidita', fade di banda, esaurimento RSI. Il nome cambia ogni sei mesi, le
   210 celle rosse no.
3. 🥉 **Filtri appiccicati a un motore gia' tarato** (fino a **cinque** in un solo
   script). In casa: **0 successi su 5**.

🟢 **E la cosa andata BENE, che va scritta accanto:** il canale delle fonti oggi
era **aperto su tre lati** (Code Base **col sorgente**, TradingView **col Pine in
chiaro**, arXiv) — non era mai successo in questo progetto che tutti e tre
rispondessero lo stesso giorno. La battuta e' potuta essere **una lettura di
codice**, non una lettura di descrizioni. Ed e' esattamente per questo che tre
candidati sono passati invece di zero.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **"Sulla banda M30/H1, dove il costo NON e' piu' il vincolo, esiste un motore a DUE LATI la cui CONDIZIONE e' costitutiva — e regge il pavimento di frequenza di famiglia sui tre indici?"**

E' la domanda giusta perche' **la battuta M30 del 05/09 ha gia' escluso l'altra
meta'**: li' e' stato misurato che a M30 l'ATR del DAX vale 25-40 punti contro
1,65 di spread, cioe' **il muro d'attrito non c'e' quasi piu'** — e che **cinque
meccanismi senza condizione sono tutti risultati rumore**, tre su tre falliti sulla
**monotonia**. La conclusione scritta li' era, testuale: *"non serve cercare
meccanismi PIU' GRANDI. Serve cercare meccanismi con una CONDIZIONE, e la
condizione dev'essere il motore."*

👉 **P1, P2 e P3 sono tre risposte a quella frase, ed e' l'unico motivo per cui
li ho promossi.** In tutti e tre, togliendo la condizione, **non resta nessun
segnale** — non resta un motore peggiore: non resta niente.

**L'ordine di coda che propongo, e il perche':**

| ordine | chi | perche' proprio quello |
|---|---|---|
| 1° | **P2 · LVN** | **e' il piu' economico**: 57 righe, 5 input, 3-4 ore di porting. Risponde alla domanda al costo piu' basso, e se il ramo *fade* e il ramo *breakout* si comportano in modo opposto abbiamo imparato qualcosa **su tutta la famiglia delle bande**, non solo su questo script |
| 2° | **P1 · IB Completed** | **e' il piu' completo** e il piu' vicino a una sedia schierabile (sizing a rischio, stop strutturale, scala 1R-5R, flat serale gia' dentro). Costa di piu' (6-9 ore) ma **parte piu' avanti** |
| 3° | **P3 · HV Spike** | **e' il piu' fragile sulla frequenza**, e va misurata **quella per prima**: se il solo ramo HV non arriva al pavimento di famiglia, **muore li'** e non costa un round |

⚠️ **Prima di qualunque riga di lancio**: `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.
E l'ora **sempre in ora server BCM** (italiana − 1): l'Initial Balance di P1, se
si sceglie la finestra USA, va scritto **14:30-15:30 server**, non 15:30-16:30.

---

## 📎 ATTRIBUZIONI E LICENZE

Nessuna riga di codice e' stata copiata da nessuna fonte. I sorgenti sono
archiviati **come letti**, per tracciabilita', in
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/`.

| oggetto | autore | licenza | come l'ho letta |
|---|---|---|---|
| `IB Completed` | **Genxtraders** | 🟠 **[INCERTO]** — nessuna intestazione; `open_no_auth` verificato | sorgente aperto, 1.092 righe |
| `LVN Rejection / Acceptance` | **AIScripts** | 🟢 **MPL 2.0** dichiarata in testa | sorgente aperto, 57 righe |
| `HV Spike Strategy` | **kostastrovas** | 🟠 **[INCERTO]** — nessuna intestazione; `open_no_auth` verificato | sorgente aperto, 134 righe |
| `VWAP Touch (Rolling Prev-VWAP)` | **kalvey16** | 🟠 **[INCERTO]** | sorgente aperto, 234 righe |
| `Execution-Aware Trend [BSL]` | **BarState Labs** | 🟢 **MPL 2.0** | sorgente aperto, 304 righe |
| `TriAnchor Elastic Reversion` | **exlux** | 🟢 **MPL 2.0** | sorgente aperto, 137 righe |
| `FlowStateTrader` | — | 🟠 **[INCERTO]** | sorgente aperto, 518 righe |
| `VR Breakdown level` | **VOLDEMAR / Trading-Go** | 🟠 **[INCERTO]** — Code Base senza licenza dichiarata | `.mq5` scaricato e letto, 202 righe |

🔴 **Sui tre candidati con licenza [INCERTO] la regola di casa e' la stessa di
sempre e non cambia:** si legge, si impara la **meccanica**, si scrive **codice
nostro**, e l'attribuzione va **in testa al `.mq5` derivato** oltre che qui.
Nessun file di quegli autori finisce mai in `mql5\Experts\`.

**Letteratura citata, con l'etichetta di come l'ho letta:**
arXiv **2605.04004** *Structural Limits of OHLCV-Based Intraday Signals in MNQ
Futures* `[VERIFICATO via API oggi — titolo e data letti]`, **gia' noto in casa**.

**Nessun EA scritto, nessun EA compilato, nessun parametro in forward toccato,
nessuna sedia accesa o spenta, nessun backtest lanciato.**

---

# 🔎 VERIFICA DI CLAUDE — 08/09/2026

## ✅ Consegnato tutto, e i file ci sono
`IBRETEST_M30_BOZZA.txt`, `LVNARBITRO_M30_BOZZA.txt`, `HVANCHOR_M30_BOZZA.txt`
in `backtest_pipeline/prove/`; gli 8 sorgenti archiviati in
`backtest_pipeline/caccia_strategie/biblioteca/sorgenti/` (il riassunto citava
un percorso accorciato: i file **ci sono**).

## 🩺 IL REPERTO CHE VALE OLTRE QUESTA CACCIA
5 sorgenti su 13 **non hanno stop**, e in **3 casi è lo stesso identico baco
Pine**: `strategy.position_avg_price` letto **prima** dell'ingresso → `stop = na`
→ **backtest senza stop, che sembra bellissimo**.

> ### 👉 Da qui in avanti, chi legge Pine in questo progetto controlla PRIMA quella riga.
> È un cancello nuovo che costa dieci secondi e smaschera una curva perfetta.

## ⚠️ UNA CORREZIONE CHE CAMBIA COSA È POSSIBILE
Il referto dice: *"lo storico BCM indici parte dal 2024.09.26 (misurato) = ~21
mesi, quindi il campione esiste solo mettendo in comune i tre indici"*.

**Vero, ma incompleto.** Quel muro riguarda i **tick** dei simboli standard.
Agli atti del progetto esiste **`NASUSD_EXT` con OHLC 2020-2024**, già in casa e
già usato (screening di regime, dossier Lyapunov 769200).

| | |
|---|---|
| `NASUSD_EXT` | ✅ **OHLC 2020-2024 disponibile** |
| `D30EUR_EXT` | ❓ **non trovato** — va verificato **prima** di prometterlo |
| U30USD | ❓ da verificare |

👉 Conseguenza pratica per questi tre candidati: sul **Nasdaq** si può fare uno
**screening di regime su 4 anni in OHLC** — regola F6 di casa: lo screening a
OHLC non dà verdetti di merito, ma **taglia i morti in fretta**, che a tre
settimane dalla challenge è esattamente ciò che serve. Il verdetto a tick resta
sulla finestra dei 21 mesi, **e va dichiarato ogni volta**.

## 🧭 ORDINE CONSIGLIATO (decide Claudio)
1. 🥈 **P2 `LVN Rejection/Acceptance`** per primo — **non** perché sia il
   migliore (P1 ha un punto in più), ma perché costa **3-4 ore** contro le
   6-8 di P1: **57 righe, 5 input**. A 23 giorni dalla scadenza, il candidato
   che entra **prima** nell'imbuto vale più di quello che entrerebbe meglio.
2. 🥇 **P1 `IB Completed`** subito dopo: stop strutturale su pivot confermato,
   sizing a rischio **già nel codice**, `lookahead_off` esplicito su tutte e 9
   le `request.security`. È il più solido dei tre.
3. 🥉 **P3 `HV Spike`** per ultimo.

🔴 E per tutti e tre vale la stessa cosa detta per ogni candidato di oggi:
**nessuno va in campo senza passare l'imbuto.** Un motore letto nel sorgente e
promosso da una caccia è un **candidato**, non una sedia.
