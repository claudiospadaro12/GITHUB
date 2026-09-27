# 🔬 AUTOPSIA DEI TRADE PERSI — DAX box notturno (long contro short), ORO (long contro short), DOW short — 27/09/2026

**Sola lettura.** Nessun EA, preset, file prova o CSV toccato. Strumento: `backtest_pipeline/autopsia_pertrade.py`
(autotest **24/24** PASS dopo il cancello; erano 15). Fonte: i per-trade appena misurati in `backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE/`
piu' il per-trade dello short 770411 di R246 (`risultati_archivio/R246/PERTRADE/`). Origine della richiesta: Gemini §4
(`docs/RISPOSTA_GEMINI_2026-09-27.md`): *"capire PERCHE' un edge sparisce, non cercare a caso una combinazione"*.

Etichette: **[MISURATO]** = letto dal per-trade · **[DERIVATO]** = calcolato con un'ipotesi dichiarata · **[IPOTESI]** = lettura, non prova.

> ✏️ **CORRETTO DAL CANCELLO STRATO 2 (27/09/2026, prima di qualunque uso)** — cinque punti cambiano, e uno capovolge una conclusione:
> **(1)** 🔴 **B.3 era sbagliato**: il contro-esempio per GIORNO non poteva bocciare la news. Il file `abtg_news_2021_2025_UTC.csv` ha un **buco**
> (16/11-17/12/2024: un evento in 33 giorni, contati come giorni "senza news") e dal **2025.03.30 e' UTC-1** (NFP/CPI delle 8:30 ET scritti alle 11:30,
> fuori dalla finestra 12-15). Rifatto alla grana giusta (minuti, orologio convertito): **24 stop su 88 chiudono entro 30' da un dato USD High contro
> 12,5 attesi per caso (P = 0,003), 12 entro 5' contro 4,8**. La news c'e' **in una parte** degli stop (classe 862). **(2)** Causa 1 del DAX: la
> DIFFERENZA di corsa e' fuori dal rumore al 95% ma al margine; la SPIEGAZIONE "il gap-up rientra" e' **[IPOTESI]** (il per-trade non ha il gap).
> **(3)** R260d e' **H4** (chiusura H4 contro EMA200 H4), non D1; R267g1 ha **5 celle** (H4..D1), non 1. **(4)** Per-trade Dow in repo: **15**, non 14.
> **(5)** L'autotest non provava la sovrapposizione delle finestre che il testo gli attribuiva: aggiunta, piu' 8 casi su orologio e calendario.

## 🎯 IN TRE RIGHE

1. 🟢 **Il DAX LONG non e' lo specchio dello short: i TRADE dei due lati sono asimmetrici** (che lo sia la NOTTE del DAX e' l'ipotesi, sotto). Stessa taglia di stop (mediana **-45** contro **-46 EUR/lotto**),
   stessa quota di stop (**46%** contro **41%** delle posizioni), ma la corsa dei vinti e' **la meta'** (TP1_RUN **+38** contro **+77 EUR/lotto**;
   una posizione che ha preso TP1 rende **0,86 R** sul long contro **1,42 R** sullo short) [MISURATO]. E lasciata correre fino alle 17:30
   (cella H4, stesse 72 giornate) la rottura in su e' un **testa o croce: 32 vinte / 27 perse, +20 EUR/lotto mediana** [MISURATO].
   🧪 **E' rumore?** No, ma al margine: differenza short-long sulle TP1_RUN **+48 EUR/lotto per posizione, IC bootstrap 95% [+11 ; +91]**; in R per
   posizione con TP1 **+0,56 R, IC [+0,15 ; +0,98]**, permutazione p ~0,003 (una coda) [DERIVATO, n=25/14 le TP1_RUN, 30/14 le posizioni con TP1] — ma e' **una delle ~dozzine di tagli**
   guardati qui, quindi vale **INDIZIO FORTE, non causa**. La SPIEGAZIONE *"il gap-up rientra, il gap-down continua"* e' **[IPOTESI]**: il per-trade
   non porta il gap (§E), le giornate dei due lati sono DIVERSE (filtro S&P opposto) e l'uscita EMA200 (r.449-455) scatta solo **contro** il trend
   del TF di gestione, quindi "mercato" e "uscita" qui **non si separano**: le separano R267g2-g4.
2. 🟡 **L'ORO perde negli STOP alle ORE USA**: il 52% (long) / 54% (short) degli stop pieni chiude fra le **13:30 e le 15:29 server**, una fetta che e' il **19%**
   della vita del trade; gli stop sono il **70% / 82% della perdita lorda** da un **20% / 25%** delle posizioni [MISURATO].
   🟠 **E la news c'e', in una parte** (✏️ corretto dal cancello, B.3): alla grana dei MINUTI **24 stop su 88 chiudono entro 30' da un dato USD High,
   contro 12,5 attesi per caso** (P = 0,003), **12 entro 5' contro 4,8** [MISURATO, 2021.01.04-2025.07.03 esclusi i buchi del file]. Il test per
   GIORNO della prima stesura (1,18 contro 1,20) non poteva dirlo: flag vero sul 62% dei giorni, buco nov-dic 2024 contato come "senza news",
   file UTC-1 dal 2025.03.30. Quindi: **~12 stop in eccesso su 88 sono del dato, il resto (~3/4) e' sessione**. R267a (news, oggi NON LANCIARE per
   il canale del file) **non e' bocciato da qui**: la previsione e' **INCERTA** (la chiusura a ±30' toglie anche i timestop vinti, B.3).
3. 🔴 **DOW SHORT: autopsia NON possibile.** In repo esistono **15 per-trade** di `ABTG_Dow_Apertura_US` (R246 794601-04/651-54 = 8, R248 765283/84 = 2,
   770206 = 1, 772505-08 = 4; ✏️ la prima stesura diceva 14) e **tutti** hanno `deal_type=1` (chiusure di LONG): **zero deal di short**. I CSV `csv_r54/*_r54a.csv` sono di ottimizzazione, senza per-trade.
   👉 **L'autopsia del Dow short aspetta R255** (24 file gia' scritti in `prove/R255*`), ci si ferma ad A e B.

---

## 0. Che cosa e' stato letto, magic per magic (verificato in `RIEPILOGO_ROUND_CORTI_B.txt` r.11-14 e nei file prova)

| magic | cosa e' | file prova | finestra | n deal / posizioni | somma | note |
|---|---|---|---|---:|---:|---|
| **795401** | DAX LONG, **corr=1** (filtro S&P acceso), M15 | R261a (asse corr 0/1: il per-trade e' dell'ULTIMA cella = corr=1) | 2024.09.26 → 2026.06.30 | 103 / 72 | -3.952,27 | ✏️ la richiesta diceva "795401 = corr=0?": **no, e' corr=1**; corr=0 (147 deal, PF 0,905) **non ha per-trade** |
| **795402** | DAX LONG, corr=1, **InpMgmtTF=H4** (ultima cella dell'asse) | R261b | idem | 75 / 72 | -6.073,97 | stesse 72 giornate di 795401 |
| **795403** | DAX LONG, **geometria R244b** (box 06:00→00:00 del giorno prima, MinBox 6800, cutoff 12:00, scadenza 600', SLMode=0) | R261c | idem | 157 / 107 | -3.321,63 | = R244b C=12 al centesimo |
| **794623** + **795404** | DAX SHORT corr=1 = **770411 d0**, due gambe contigue (R246k finestra A 2024.09.26→2025.06.09 + R261d OOS 2025.06.10→2026.06.30) | R246k, R261d | 2024.09.26 → 2026.06.30 | 20+21 / 13+14 = **41 / 27** | +4.766,96 + 6.143,38 = **+10.910,34** | lo script verifica che le finestre non si sovrappongano; 795404 = r81a/R246i al centesimo (T1 VERDE) |
| **795301** | ORO LONG (770402 solo long, OHLC M1, H2, 0,5%) | R260a | 2020.01.01 → 2026.06.30 | 375 / 279 | +14.255,33 deal / **+14.062,17** con k | k = 1,811 EUR/lotto (classe 844) |
| **795302** | ORO SHORT | R260b | idem | 318 / 232 | **+9.165,26** con k | k = 1,804 |
| **795303** | ORO STRADDLE | R260c | idem | 693 / 511 | +24.736,49 con k | 511 = 279 + 232: **nessun giorno con tutti e due i lati** |

Rischio del banco: DAX 1,0% (795401/402/404, 794623), 0,65% (795403); oro 0,5%. Per confrontare lati con rischio uguale si usa **EUR/lotto**
(net/volume); il DAX a 1% ha 1 R ≈ 1.000 EUR, quindi le medie in EUR sono anche in R.

### Che cosa il per-trade NON ha, e quindi che cosa qui NON si misura
- **niente ora d'ingresso, niente prezzo d'ingresso, niente box**: l'ora e' quella di CHIUSURA; l'ampiezza dello stop (R) si ricava dal primo deal
  (`|net|/vol` di uno stop pieno, `net/vol` del primo parziale = 1 R) — **solo per 63/72 DAX long, 25/27 short, 138/279 oro long, 137/232 oro short**;
  le posizioni a 1 deal chiuse al flat non hanno R misurabile [DERIVATO];
- **niente commento del deal**: il motivo d'uscita e' dedotto dall'ora e dalla forma (1 deal in perdita prima del flat = STOP_PIENO; ultimo deal all'ora
  di flat = TIMESTOP; 2+ deal = TP1 preso, poi RUN o BE) [DERIVATO];
- la **stagione** e' l'ora legale europea (ultima domenica di marzo → ultima di ottobre). Sugli **indici** BCM e' UTC+1 fisso da sempre
  (`report/OROLOGIO_BCM_2026-09-24.md`): ORA_LEGALE = apertura Xetra alle 08:00 server (dentro la finestra 07:59-08:30 del pendente),
  ORA_SOLARE = Xetra alle 09:00 server (il pendente vive e muore PRIMA della cash). Sull'**oro** l'orologio e' quello forex: vecchio (IT−1 tutto l'anno,
  cioe' ora di Londra) fino a fine 2024, UTC+1 fisso dopo → per l'oro 2020-2024 la stagione **NON e' un effetto d'orologio**, e' calendario.

---

## A. 🇩🇪 DAX — LONG del box notturno contro SHORT (770411)

### A.1 Persi contro vinti — 795401 (long corr=1, M15) e 794623+795404 (short corr=1)

**Per MOTIVO d'uscita** [DERIVATO]

| motivo | LONG n | vinti | persi | net EUR | EUR/lotto | SHORT n | vinti | persi | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| STOP_PIENO | 33 | 0 | 33 | -33.730 | **-44,6** | 11 | 0 | 11 | -10.726 | **-49,2** |
| TP1_BE (parziale poi pari) | 5 | 5 | 0 | +2.436 | +16,7 | 0 | – | – | – | – |
| TP1_RUN (parziale poi corsa) | 25 | 25 | 0 | +25.148 | **+38,2** | 14 | 14 | 0 | +20.821 | **+77,3** |
| TIMESTOP 17:30 | **0** | – | – | – | – | **0** | – | – | – | – |
| ALTRO (1 deal in utile, trailing senza TP1) | 9 | 9 | 0 | +2.194 | +9,3 | 2 | 2 | 0 | +815 | +16,2 |
| **TOTALE** | **72** | **39** | **33** | **-3.952** | **-2,2** | **27** | **16** | **11** | **+10.910** | **+20,3** |

- media vinta / media persa: LONG **+764 / -1.022** (rapporto 1,34) · SHORT **+1.352 / -975** (0,72). Con lo stesso stop, il long dovrebbe vincere il 57% per
  stare in pari e vince il 54%; lo short vince il 59% con un rapporto che ne basterebbe il 42%.
- **Nessuna posizione arriva alle 17:30**, ne' long ne' short: con SL 2,5 ATR M15 e trailing 2 ATR tutto si chiude entro le 15:xx.

**Per ORA di chiusura (server)**

| ora | LONG n | v | p | PF | EUR/lotto | SHORT n | v | p | PF | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 08 | **37** | 13 | **24** | **0,24** | -21,1 | 12 | 5 | 7 | 0,68 | -8,4 |
| 09 | 23 | 16 | 7 | 1,54 | +5,4 | 9 | 5 | 4 | 1,04 | +0,9 |
| 10 | 3 | 2 | 1 | 2,25 | +27,2 | 2 | 2 | 0 | inf | +127,2 |
| 11 | 2 | 2 | 0 | inf | +65,5 | 3 | 3 | 0 | inf | +176,9 |
| 12-15 | 7 | 6 | 1 | 8,14 | +65,3 | 1 | 1 | 0 | inf | +77,7 |

- Stop pieni per minuti dopo le 08:00 [MISURATO]: LONG `0,0,2,6,6,9,11,13,15,17,18,19,23,25,26,33,34,34,38,49,49,52,53,57,60,60,65,70,80,91,93,163,390`
  → **6 entro 10', 15 entro 30', 26 su 33 entro l'ora**; SHORT `11,15,25,28,55,56,58,60,74,91,116` → 8 su 11 entro l'ora. **La rottura falsa
  all'apertura c'e' su tutti e due i lati**, nella stessa proporzione (46% contro 41%): NON e' la differenza.
- Corsa dopo TP1 (punti indice fra il primo e l'ultimo deal delle TP1_RUN) [MISURATO]: LONG mediana **33** pt, media 34, max 103 · SHORT mediana 39,
  **media 85, max 365**. La coda dello short paga 2,5 volte.

**Per GIORNO della settimana**

| giorno | LONG n | v | p | PF | net | SHORT n | v | p | PF | net |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Lun | 10 | 4 | 6 | 0,54 | -2.772 | 5 | 2 | 3 | 0,95 | -174 |
| **Mar** | 12 | 3 | **9** | **0,23** | **-7.023** | 6 | 3 | 3 | 1,99 | +3.145 |
| Mer | 19 | 12 | 7 | 1,07 | +492 | 5 | 2 | 3 | 1,27 | +613 |
| Gio | 16 | 12 | 4 | 2,39 | +5.718 | 4 | 4 | 0 | inf | +2.992 |
| Ven | 15 | 8 | 7 | 0,95 | -368 | 7 | 5 | 2 | 3,11 | +4.335 |

Il martedi' del long vale **178% della perdita totale** (-7.023 su -3.952): senza i martedi' il long sarebbe positivo (+3.071 su 60 posizioni).
n=12: [MISURATO] ma **sottile**, e **nell'EA non esiste una manopola dei giorni della settimana** (nessun input, `grep -i dayofweek` vuoto): si dichiara, non si propone.

**Per ANNO / STAGIONE / MESE**

| chiave | LONG n | v | p | PF | net | SHORT n | v | p | PF | net |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2024 (da ott.) | 9 | 3 | 6 | 0,28 | -4.364 | 5 | 3 | 2 | 0,69 | -647 |
| 2025 | 47 | 29 | 18 | **1,22** | +3.986 | 14 | 8 | 6 | 2,48 | +8.115 |
| 2026 (a giu.) | 16 | 7 | 9 | 0,61 | -3.574 | 8 | 5 | 3 | 2,08 | +3.442 |
| ORA_LEGALE (Xetra dentro la finestra) | 45 | 22 | 23 | 0,82 | -4.260 | 11 | 5 | 6 | 1,45 | +2.355 |
| ORA_SOLARE (pendente prima della cash) | 27 | 17 | 10 | 1,03 | +308 | 16 | 11 | 5 | **2,56** | +8.555 |
| mesi del long in utile | gen +1.760 · feb +866 · mag **+3.054** · dic +1.507 | | | | | | | | | |
| mesi del long in perdita | nov **0/4 -4.023** · lug 1/3 -2.870 · giu 1/4 -2.515 · apr -957 | | | | | | | | | |

Anno-mese del long [MISURATO]: 2024-11 **0/3 -3.020**; 2025-01 **4/4 +3.032**; 2025-05 **3/3 +4.300**; 2025-07 1/4 -2.870; 2026-06 0/2 -1.964.
Il long guadagna **solo nei mesi di rally verticale del DAX** (gen-feb 2025, mag 2025) e li restituisce nei mesi di laterale/ribasso: e' un **motore di trend
mascherato da breakout**, e il filtro S&P H1 (EMA 14/100) non lo sa (corr=0 PF 0,905, corr=1 0,883: uguali).

### A.2 Ampiezza (R in EUR/lotto ≈ punti indice) — [DERIVATO dal primo deal]

| terzile di R | LONG n | vinti | PF | net | stop | SHORT n | vinti | PF | net | stop |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| stretto (20-35 / 0-45) | 21 | 11 | 0,83 | -1.731 | 10 | 8 | 3 | 1,11 | +468 | 5 |
| medio (37-52 / 46-64) | 21 | 9 | **0,54** | -5.616 | 12 | 8 | 5 | 1,54 | +1.746 | 3 |
| largo (56-164 / 65-217) | 21 | 10 | 1,11 | +1.201 | 11 | 9 | 6 | **3,49** | +7.881 | 3 |

R mediano degli stop = R mediano dei TP1 sul long (45 contro 46): **la volatilita' del giorno non distingue i persi dai vinti sul long**. Sullo short
la coda larga (ATR alta = giornata di paura) fa il grosso: +7.881 su +10.910.

### A.3 Le stesse 72 giornate lasciate correre (795402, gestione H4): che cosa succede alle 17:30

- 59 posizioni su 72 arrivano al flat (stop 2,5 ATR H4 ≈ -233 EUR/lotto, 12 stop pieni a -11.787): al flat **32 vinte / 27 perse, +5.636 EUR, +25 EUR/lotto medio,
  +20 mediana** [MISURATO]. ⚠️ H4 cambia anche lo STOP (5 volte piu' largo), il trailing e l'EMA200: e' "stesse giornate", non "stesse posizioni
  lasciate correre". E 🔴 **lo SHORT a H4 non e' misurato**: questo paragrafo dice che la deriva del long fino alle 17:30 e' debole, **non** che
  quella dello short sia forte — il confronto che proverebbe l'asimmetria manca.
- Concordanza col M15 sulle stesse giornate: 46/72 stesso segno; **16 giornate vinte a M15 sarebbero perse alle 17:30** (la corsa mattutina rientra), 10 perse a M15
  sarebbero vinte. La deriva di fine giornata dopo una rottura in su e' **quasi zero**: questo e' il numero che dice "asimmetria", non "uscita sbagliata".

### A.4 Le tre cause piu' probabili, con il numero, la manopola ESISTENTE e la misura (UNA per causa, niente griglie)

| # | causa | il numero che la sostiene | manopola gia' nell'EA (`ABTG_MaxMinNotte.mq5`) | UNA misura, costo | previsione scritta PRIMA |
|---|---|---|---|---|---|
| 1 | 🔴 **La corsa dopo TP1 del long e' la meta' di quella dello short** [DERIVATO, IC al 95% che esclude lo zero, al margine]. Lettura: *asimmetria del mercato, il gap-up rientra* **[IPOTESI]** — con l'uscita EMA200 (r.449-455) e le giornate diverse dei due lati, l'uscita NON e' esclusa | TP1_RUN **+38 contro +77 EUR/lotto**; 0,86 R contro 1,42 R per posizione con TP1; H4 al flat 32/27 e +20/lotto mediana; stop uguali (-45/-46) e quota stop uguale (46%/41%) [MISURATO] | `InpUseTrailing`/`InpTrailAtrMult` r.160-161, `InpBreakeven` r.154, `InpTP1Pct` r.153 — **gia' in coda: R267g2/g3/g4** (CORTI C), che chiudono la casella (3) del certificato | **nessuna passata nuova**: si leggono R267g2-g4 col per-trade | se la causa e' il mercato e non l'uscita, **nessuna delle tre celle porta il PF sopra 1,00** e la TP1_RUN media resta < 50 EUR/lotto. Se invece il trailing tagliava la coda, g2 (trailing OFF) alza la mediana della corsa sopra i 39 pt dello short. Contro-esempio gia' in mano: la cella H4 lascia correre e fa +20/lotto |
| 2 | 🟠 **Il long paga solo nei mesi di rally verticale**: e' trend, non breakout; il filtro S&P H1 non lo vede | 2025-01 4/4 +3.032, 2025-05 3/3 +4.300; 2024-11 0/3 -3.020, 2026-06 0/2; corr=0 e corr=1 identici (0,905 / 0,883) [MISURATO] | `InpUseCorrelation` + `InpCorrSymbol` r.164-168: il trend del **DAX stesso** — **gia' in coda: R267g1** | **nessuna passata nuova** (R267g1: ✏️ **5 celle**, `InpCorrTF` H4/H6/H8/H12/D1, lettura sulla cella centrale **H8** come congelato nel file; la previsione del file e' H0) | se regge, R267g1 (H8) **toglie** 2024-11 e 2026-06 e **tiene** gen/feb/mag 2025: PF > 1,00 con n < 50 (quindi indizio, non merito). Se il PF resta 0,88 con lo stesso n, il trend non e' la spiegazione |
| 3 | 🟡 **La finestra 07:59-08:30 con l'asta Xetra DENTRO (ora legale) e' peggio di quella PRIMA della cash (ora solare)** — su tutti e due i lati | LONG 0,82 (n=45) contro 1,03 (n=27); SHORT 1,45 (n=11) contro 2,56 (n=16); 24 stop del long su 33 chiudono nell'ora 08 [MISURATO]; lettura "asta d'apertura = generatore di rotture false" [IPOTESI] | `InpPlaceHour/Min` r.126-127, `InpEntryCutoffHour/Min` r.128-129: la variante **-1h** (06:59 → 07:30 server) che R246j/l ha gia' misurato sullo short | **1 passata** (clone di R246j con `InpAllowLong=true`, `InpAllowShort=false`, corr=1, magic vergine) — e' la stessa domanda dell'orologio che Claudio deve decidere entro il 25/10 | se l'asta e' la causa, il -1h porta la quota di stop nell'ora 08 sotto il 50% e il PF d'estate sopra 1,00; se no, resta 0,8 e la stagione era calendario. R246 sullo short ha gia' letto "FREQUENZA → STAGIONE, indizio debole" (referto R246 r.19): la banda attesa e' stretta |

🚫 **Quello che NON si propone**: `InpMinBoxPts/InpMaxBoxPts` sul DAX long (l'ampiezza NON separa persi da vinti: A.2), un nuovo asse di `InpTP2_R`/`InpAtrSLmult`
(PF < 1,10 su 41 celle: niente parametri d'ingresso, referto CORTI B §2.4), un filtro del martedi' (manopola inesistente + n=12).

**Risposta alla domanda "specchio o asimmetria"**: **asimmetria** [MISURATO su stop uguali e code diverse]. La geometria R244b (795403) lo conferma da
un'altra angolatura: 44 TP1_RUN a +63 EUR/lotto ma **29 TIMESTOP persi su 37** (PF 0,15 alle 17:30): quando il long non prende il parziale in mattinata,
a fine giornata ha perso — e i 9 stop pieni a -220/lotto arrivano tutti fra le 10:02 e le 16:07, mai all'apertura.

---

## B. 🥇 ORO — LONG (795301) contro SHORT (795302), 2020-2026

### B.1 Persi contro vinti

**Per MOTIVO d'uscita** [DERIVATO]

| motivo | LONG n | vinti | persi | PF | net EUR | EUR/lotto | SHORT n | vinti | persi | PF | net EUR | EUR/lotto |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| STOP_PIENO (estremo opposto del box, SLMode=0) | 56 | 0 | 56 | 0 | **-29.192** | **-1.163** | 59 | 0 | 59 | 0 | **-29.524** | **-1.188** |
| TP1_BE | 9 | 9 | 0 | inf | +2.475 | +774 | 7 | 7 | 0 | inf | +1.748 | +568 |
| TP1_RUN | 29 | 29 | 0 | inf | +13.506 | +1.075 | 33 | 33 | 0 | inf | +16.712 | +1.284 |
| **TIMESTOP 17:30** | **161** | 98 | 63 | **2,80** | **+22.882** | +407 | **118** | 78 | 40 | **3,65** | **+17.175** | +419 |
| ALTRO | 24 | 24 | 0 | inf | +4.391 | +458 | 15 | 15 | 0 | inf | +3.054 | +616 |
| **TOTALE** | **279** | **160** | **119** | **1,336** | **+14.062** | +132 | **232** | **133** | **99** | **1,255** | **+9.165** | +105 |

- Il motore dell'oro e' il **TIMESTOP**: 58% (long) / 51% (short) delle posizioni arrivano alle 17:30, e li' il PF e' 2,8-3,7. **Tutti i 63/40 timestop persi
  sono a 1 deal** (mai preso TP1): la rottura che non parte, chiusa in pari-meno.
- Gli **stop pieni** sono il **20% / 25%** delle posizioni ma il **70% / 82% della perdita lorda** (29.192 su 41.895; 29.524 su 36.012) [MISURATO].
  Lo stop e' l'estremo opposto del box: mediana **-1.118 / -1.164 EUR/lotto**, cioe' 2,7 volte il timestop vinto medio.

**Per ORA di chiusura** (server) — dove cadono gli stop

| ora | LONG n | v | p | PF | SHORT n | v | p | PF |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| 07-08 (prima del cutoff) | 9 | 9 | 0 | inf | 10 | 10 | 0 | inf |
| 09-11 | 18 | 6 | 12 | **0,13** | 8 | 6 | 2 | 1,68 |
| 12 | 10 | 7 | 3 | 1,64 | 7 | 0 | 7 | **0,00** |
| 13 | 25 | 15 | 10 | 1,24 | 26 | 10 | 16 | **0,42** |
| 14 | 21 | 7 | 14 | **0,31** | 27 | 14 | 13 | 1,03 |
| 15 | 22 | 11 | 11 | 0,76 | 22 | 8 | 14 | 0,58 |
| 16 | 10 | 6 | 4 | 1,47 | 11 | 5 | 6 | 0,65 |
| **17** (flat) | **164** | 99 | 65 | **2,61** | **121** | 80 | 41 | **3,55** |

- Stop pieni per mezz'ora [MISURATO]: LONG **12 fra 13:30-14:29, 17 fra 14:30-15:29 = 29/56 = 52%**; SHORT 16 + 16 = **32/59 = 54%**. Quella finestra e' 2 ore su
  10,5 di vita (**19%**). ⚠️ Il 19% e' il riferimento UNIFORME: l'oro ha la volatilita' piu' alta proprio nella sessione USA, e uno stop largo
  (~1.150 EUR/lotto) cade dove il prezzo si muove di piu'. Che la concentrazione sia **anomala** rispetto alla volatilita' e' **[IPOTESI]**: il
  per-trade non ha il profilo di volatilita' per ora. Nessuno stop prima delle 09:46 (long) / 10:08 (short): **l'oro non ha la rottura falsa all'apertura**, ha la rottura falsa
  **all'apertura di New York**.
- Verifica sugli stop stessi [MISURATO]: sul vecchio orologio (< 2025, server = ora di Londra) **13:30 server = 8:30 ET (dati USA)** e **14:30 = 9:30 ET
  (apertura cash USA)** in tutte e due le stagioni; il picco degli stop d'estate sta sui dati (13:30: 3 long, 7 short), quello d'inverno sull'apertura cash
  (14:30: 5 long, 3 short). Coerente con "sessione USA", non con un dato preciso; n piccoli, non decisivo.

**Per GIORNO della settimana / ANNO / STAGIONE / MESE**

| chiave | LONG n | v | p | PF | net | SHORT n | v | p | PF | net |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Lun | 43 | 19 | 24 | 0,95 | -365 | 44 | 30 | 14 | 2,15 | +4.750 |
| **Mar** | 49 | 30 | 19 | 1,71 | +4.476 | 52 | 23 | **29** | **0,59** | **-4.347** |
| Mer | 57 | 30 | 27 | 0,74 | -2.726 | 41 | 22 | 19 | 0,85 | -1.102 |
| Gio | 64 | 37 | 27 | 1,36 | +3.795 | 46 | 32 | 14 | 2,19 | +6.314 |
| Ven | 66 | 44 | 22 | **2,26** | +8.882 | 49 | 26 | 23 | 1,42 | +3.551 |
| 2020 | 42 | 24 | 18 | 1,50 | +2.941 | 28 | 11 | 17 | **0,45** | -2.632 |
| **2021** | 35 | 17 | 18 | **0,93** | -521 | 42 | 21 | 21 | 1,03 | +229 |
| 2022 | 40 | 24 | 16 | 1,28 | +1.578 | 41 | 30 | 11 | 2,21 | +4.803 |
| **2023** | 42 | 20 | 22 | **0,85** | -1.204 | 40 | 19 | 21 | 0,82 | -1.454 |
| 2024 | 56 | 35 | 21 | 1,78 | +5.979 | 31 | 17 | 14 | 1,14 | +779 |
| 2025 | 47 | 28 | 19 | 1,50 | +2.989 | 38 | 24 | 14 | 1,58 | +2.997 |
| 2026 (a giu.) | 17 | 12 | 5 | 2,56 | +2.300 | 12 | 11 | 1 | 9,20 | +4.442 |
| ORA_LEGALE (apr-ott) | 154 | 95 | 59 | **1,70** | +13.977 | 140 | 75 | 65 | **1,01** | +299 |
| ORA_SOLARE (nov-mar) | 125 | 65 | 60 | **1,00** | +85 | 92 | 58 | 34 | **1,71** | +8.866 |
| mesi in perdita | feb 0,63 · nov 0,81 · dic 0,70 | | | | | ott 0,68 · **nov 0,46** · giu/ago 0,95-0,98 | | | | |

- **Il long NON e' solo "trend 2024-25"** [MISURATO]: 2020-2023 n=159 PF **1,104** (timestop PF 2,98), 2024-2026 n=120 PF 1,744. Le due meta' del referto
  (1,171 / 1,521) tornano al millesimo. Gli anni negativi sono **2021 (0,93: 11 stop -5.671, TP1 preso 10 volte su 35)** e **2023 (0,85: 11 stop -5.683 + 11
  timestop persi, timestop PF 1,89 = il piu' basso della serie)**: 2023 e' l'anno in cui la rottura di Londra **non arriva alle 17:30 in utile**, non l'anno degli stop.
- **Le stagioni sono SPECULARI fra i lati** (long 1,70/1,00, short 1,01/1,71) e in **novembre perdono tutti e due** (0,81 / 0,46). Sul vecchio orologio
  (2020-2024) la stagione non e' un artefatto d'orologio: e' **calendario** [MISURATO sullo split; il perche' e' IPOTESI]. ✏️ La tabella qui sopra
  MESCOLA i due orologi (dal 2025 UTC+1 fisso = Londra+1 d'inverno): ristretta al **2020-2024** lo specchio regge (**long 1,71 n121 / 0,86 n94;
  short 0,85 n107 / 1,48 n75**); sul **2025-2026** no (long 1,66 / 1,76; short 1,99 / 2,75, n 17-33) [MISURATO].
- Weekday: **martedi' dello short 0,59 (n=52, -4.347)** e mercoledi' negativo su tutti e due i lati; venerdi' del long 2,26. n≈50: sottile, e nell'EA non c'e' la manopola.

### B.2 Ampiezza del box (R = box + buffer, dal primo deal) [DERIVATO]

| terzile di R (EUR/lotto) | LONG n | vinti | PF | net | stop | SHORT n | vinti | PF | net | stop |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| stretto (637-1.004 / 655-1.067) | 46 | 25 | 1,22 | +2.359 | 21 | 45 | 24 | **1,02** | +192 | 21 |
| medio (1.011-1.341 / 1.082-1.411) | 46 | 29 | 1,63 | +5.583 | 17 | 45 | 24 | **1,05** | +476 | 21 |
| largo (1.358-7.630 / 1.412-5.961) | 46 | 28 | 1,52 | +4.933 | 18 | 47 | 30 | **1,86** | +7.327 | 17 |

Misurato su 138/279 e 137/232 posizioni (quelle con stop pieno o TP1 preso): **sullo short il box stretto non paga (PF 1,02-1,05), il largo si' (1,86)**; sul long
e' piatto. 1.400 EUR/lotto ≈ 15,5 $ ≈ **1.550 punti** a 100 oz e EURUSD ~0,9 [DERIVATO].

### B.3 Il contro-esempio sul filtro notizie — ✏️ RIFATTO DAL CANCELLO (la prima stesura concludeva il contrario)

Ipotesi alternativa: "gli stop delle 13:30-15:29 sono il DATO USA". Calendario: `mql5/Files/abtg_news_2021_2025_UTC.csv` (2.311 eventi USD High).

🔴 **Che cosa non andava nella prima stesura** (flag "giorno con un evento USD fra le 12 e le 15 UTC", 2021.01.01 → 2025.07.03; i suoi numeri si
riproducono esatti: long 1,184 n116 / 1,201 n80, short 1,288 n104 / 1,264 n69, stop 13-15 in giorni con news 21/31 e 21/34):
- **grana**: il flag e' vero sul **62-63%** delle posizioni, quindi confronta "quasi tutti i giorni" con "quasi nessuno" e non puo' vedere uno stop che
  scatta **nei minuti** del dato;
- **buco del file**: dal 16/11 al 17/12/2024 c'e' **un evento in 33 giorni**, e dopo il 2025.07.03 tre in sei mesi: quei giorni finivano nel gruppo
  "SENZA news";
- **orologio del file**: dal **2025.03.30** il file e' **UTC-1** (NFP 2025.06.06, CPI 2025.06.11 e 2025.07.03 alle **11:30** invece che 12:30; ISM
  2025.04.01 alle 13:00 invece che 14:00; FOMC 2025.06.18 alle 17:00), quindi i dati delle 8:30 ET cadevano FUORI dalla finestra 12-15.

**Rifatto** (`autopsia_pertrade.py --news ... --orologio forex`, §F): tratti coperti **2021.01.04 → 2024.11.15 e 2025.01.02 → 2025.07.03**, file
corretto di +60' dal 2025.03.30 (`CORREZIONI_NEWS`, 136 righe), eventi convertiti in ora server (Londra fino al 2024, UTC+1 dopo — ancore
`OROLOGIO_BCM` r.133 e r.137 nell'autotest). Atteso per caso = stessa ora di chiusura su tutti i giorni coperti.

| 2021-2025, tratti coperti | LONG | SHORT | insieme |
|---|---|---|---|
| STOP_PIENO chiusi **entro 5'** dopo un dato | **6 su 43** (atteso 2,1; P 0,020) | **6 su 45** (atteso 2,7; P 0,060) | **12 su 88** (atteso 4,8; P 0,004) |
| STOP_PIENO chiusi **entro 30'** dopo un dato | **11 su 43** (atteso 5,8; P 0,034) | **13 su 45** (atteso 6,8; P 0,021) | **24 su 88** (atteso 12,5; P 0,003) |
| PF giorni CON / SENZA evento 12-15 UTC (grana del giorno) | 1,124 n118 / 1,485 n68 | 1,269 n107 / 1,241 n63 | IC bootstrap della differenza del long [-1,57 ; +0,50]: **non dice niente** |

🧪 **Contro-esempio del contro-esempio** (l'orologio sbagliato deve spegnere il segnale): con gli eventi a **UTC+2** gli stop entro 5' diventano **0 e 0**;
a UTC+1 fisso anche prima del 2025 **3 e 2**; con l'orologio forex giusto **6 e 6**. Il segnale sta dove l'orologio e' giusto — che e' anche una
conferma indiretta dell'orologio forex sull'oro, finora [INFERITO].

👉 **La news c'e', in una parte**: ~**12 stop in eccesso su 88** (circa uno su sette) sono del dato; gli altri ~3/4 cadono nella sessione USA **fuori**
dai 30' di un dato. Le posizioni vive attraverso un dato guadagnano comunque (chiusura >= 13:00: PF 1,29 long n=98, 1,31 short n=89, prima stesura, non
rifatto): un filtro che chiude a ±30' (`InpNewsFlatten=true`, dichiarato r.181, agisce r.251) taglierebbe **anche** i timestop vinti.
Previsione per R267a: **INCERTA nel verso** — puo' togliere ~12 stop pieni (~-1.160 EUR/lotto l'uno) e insieme una parte dei timestop vinti; se
|ΔPF| < 0,05 i due effetti si sono compensati, **non** "la news non conta". ⚠️ E R267a (file di un altro agente) usa lo stesso calendario con
`InpNewsShiftMinutes=60` fisso: il suo par. 6-C dichiara l'errore d'inverno 2021-2024, **non** l'UTC-1 del file dal 2025.03.30 (li' +60 porta
gli eventi a UTC, cioe' un'ora PRIMA dell'ora server) ne' il buco di nov-dic 2024.

### B.4 Le tre cause piu' probabili, con il numero, la manopola ESISTENTE e la misura (UNA per causa)

| # | causa | il numero che la sostiene | manopola gia' nell'EA | UNA misura, costo | previsione scritta PRIMA |
|---|---|---|---|---|---|
| 1 | 🔴 **Lo stop all'estremo del box viene preso nella sessione USA** (13:30-15:29 server), quando l'oro cambia direzione | 52% / 54% degli stop in un 19% della giornata; stop = 70% / 82% della perdita lorda; nessuno stop prima delle 09:46 [MISURATO]. ✏️ In parte e' la news: ~12 stop in eccesso su 88 entro 30' da un dato (B.3); il resto e' sessione | `InpCloseHour/Min` r.130-131 (flat **prima** di New York: 13:00 server) — la manopola c'e', il valore no | **2 passate** (long, short) a `InpCloseHour=13`, OHLC M1, 2020-2026 — **con il contro-esempio dichiarato**: i timestop vinti (PF 2,8-3,7) vivono anch'essi attraverso le ore USA, e la cella H4 del DAX ha mostrato che "chiudere prima" puo' tagliare anche i vinti | se la causa regge: **stop pieni -50% e PF > 1,45** (long) / **> 1,35** (short); se il timestop delle 13:00 vale meno di quello delle 17:30, il PF **cala** e la causa era "sessione USA come rischio simmetrico", da accettare |
| 2 | 🟠 **Il box stretto non paga sullo short** (e sul long e' indifferente) | terzili B.2: short 1,02 / 1,05 / **1,86**; long 1,22 / 1,63 / 1,52 [DERIVATO su 137 e 138 posizioni] | `InpMinBoxPts` r.122 → **gia' in coda: R267b** (asse 0/650/1300/1950/2600 pt, due lati) | **nessuna passata nuova** | R267b: sullo **short** la cella **1300** (13 $) alza il PF sopra 1,35 tagliando ~1/3 delle posizioni; sul **long** le celle sono **piatte** (±0,10). Se il long sale piu' dello short, la lettura dei terzili era rumore |
| 3 | 🟡 **Il long negli anni laterali (2021, 2023) non arriva alle 17:30 in utile**: e' il regime, non lo stop | 2023 timestop PF **1,89** contro 2,98 medio 2020-23 e 5,82 nel 2020; 2021 TP1 preso 10/35; 2020-23 PF 1,104 comunque > 1,10 [MISURATO] | `InpUseCorrelation` + `InpCorrSymbol=XAUUSD` (trend dell'oro stesso: ✏️ **chiusura H4 contro EMA200 H4**, `InpCorrTF=16388`, EmaFast 1 / EmaSlow 200 — la prima stesura diceva D1) → **gia' in coda: R260d** | **nessuna passata nuova** | R260d: **toglie** piu' posizioni nel 2021 e 2023 che nel 2024-2025; PF 2020-2023 sale sopra 1,25 con n che scende sotto 120 (indizio, non merito). Se toglie in proporzione uguale ogni anno, il trend non e' la causa |

🚫 **Quello che NON si propone**: `InpSLMode`/`InpAtrSLmult` (gia' ad asse 0/1/2 nelle griglie `MaxMin_Oro/oro_maxmin_fase1_*.csv` e trailing in R151a: non
e' una misura nuova), un filtro dei giorni (manopola inesistente). ✏️ Il filtro notizie **non e' smentito** (B.3 rifatto): e' gia' in coda come R267a, con verso incerto.

---

## C. 🇺🇸 DOW SHORT d'apertura — NON MISURABILE OGGI, e perche' e' un fatto e non una scelta

Cercati (repo intero, escluse le worktree): `csv_r54/` contiene solo `ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_r54a.csv` e `ABTG_ORB_Ottimizzato_*_r54b.csv`
= CSV di ottimizzazione (una riga per cella, nessun deal). Nessun file con `7726` nel nome fuori da `.git/objects`. I **15** per-trade (✏️ erano scritti 14) `abtg_trades_ABTG_Dow_Apertura_US_*`
(R246, R248, `trades_portafoglio/770206`, `aperture_r47/772505-772508`) hanno **100% `deal_type=1`** (chiusure di long): 130+192+74+93+14+130+96 deal, **zero short**.
👉 **L'autopsia del Dow short aspetta il per-trade di R255** (`prove/R255a-v`, magic 7955xx, 1430/1530): lo script e' pronto, la riga e' `python3
backtest_pipeline/autopsia_pertrade.py <per-trade R255> --close 17:30 --label "DOW SHORT"`.

---

## D. 🧪 I CONTRO-ESEMPI COSTRUITI (regola del 10/09), oltre a B.3

1. **"Togli le rotture false e il long ha edge"**: senza le posizioni chiuse prima delle 08:30 il long fa PF **1,468** su 50 (+8.578). E' **sopravvivenza**, non
   un filtro: alle 08:00 non si sa quale delle 22 posizioni chiuse prima delle 08:30 (✏️ la prima stesura diceva 37, che e' l'ora 08 intera) chiudera' in perdita, e lo short ha la stessa quota di stop precoci (41%) e guadagna lo stesso. Il numero
   si riporta per dire **che cosa NON vuol dire**.
2. **"Il long perde per la stagione dell'orologio"**: la stagione del long (0,82 / 1,03) va nella **stessa direzione dello short** (1,45 / 2,56) — se fosse la
   causa del long, sarebbe anche la causa dello short che pero' guadagna. E' un modulatore, non la causa: per questo e' la causa **3**, non la 1.
3. **"Il long e' l'uscita sbagliata"**: la cella H4 (795402) lascia correre le **stesse 72 giornate** fino al flat e fa **+20 EUR/lotto mediana, 32/27**.
   Se l'uscita fosse il problema, il flat avrebbe mostrato la coda: non c'e'. ⚠️ Contro-esempio **a una gamba sola**: la stessa prova sullo short
   (cella H4 short) non esiste, e H4 cambia anche stop, trailing ed EMA200 (A.3). Dice "la deriva del long e' debole", non "asimmetria".
4. **Autotest dello strumento** (✏️ **24 casi**; la prima stesura ne aveva 15 e attribuiva all'autotest la sovrapposizione delle finestre, che era solo
   in `main()`): posizione a 2 deal con TP1 e chiusura alle 17:30 → TIMESTOP (non TP1_RUN); TP1 poi -4 → TP1_BE; deal_type misti sulla stessa posizione →
   si ferma; finestre sovrapposte (anche solo il giorno di confine) → si ferma, contigue 794623+795404 → passano; confini dell'ora legale 2024/2025/2026;
   orologio UTC→server con le ancore esterne di `OROLOGIO_BCM` r.133 (NFP 03/11/2023) e r.137 (CPI 12/02/2025); correzione -1h del file news solo sul
   file che ce l'ha; buco di calendario escluso; prossimita' contata a mano; PF ai bordi; sequenze V P P V P P P.
   **Fuori dall'autotest, verificato dal cancello rileggendo i CSV**: le somme per posizione riproducono il RIEPILOGO al centesimo sul DAX
   (-3.952,27 / -6.073,97 / -3.321,63 / +6.143,38) e la gamba 794623 = CSV `_IS` di R261d (Profit **4.766,96**, Trades **20**) al centesimo;
   sull'oro k = 1,811 / 1,804 (arrotondati al millesimo) rida' i Profit del CSV **entro 0,03 EUR**, non al centesimo.

## E. 🔴 NON MISURATO / NON MISURABILE dal per-trade

- **ampiezza del box** vera (in punti), **ora d'ingresso**, **gap d'apertura** (chiusura del giorno prima → apertura): il per-trade non li porta. R deriva dal primo
  deal e copre 63/72, 25/27, 138/279, 137/232 posizioni: le posizioni a 1 deal chiuse al flat restano fuori dai terzili (bias dichiarato).
- **corr=0 del DAX long** (147 deal): nessun per-trade (la cella scrive solo l'ultima).
- **short del DAX fra il 2025.04.08 e il 2025.08.19**: zero posizioni nelle due gambe (non un buco di dati: il filtro S&P non ha aperto).
- **orologio dell'oro**: assunto forex [INFERITO], come nel referto CORTI B §5(e) — ✏️ ora con un indizio a favore (B.3: il segnale news sta solo
  sull'orologio forex).
- **calendario news**: buco 16/11-17/12/2024 e dopo il 2025.07.03; UTC-1 dal 2025.03.30 (corretto nello script, `CORREZIONI_NEWS`). Il file NON e'
  stato riparato: e' input di R267a e di altri agenti.
- **DAX long contro short: le giornate sono diverse** (filtro S&P a verso opposto) e la cella long di R261a gira con `InpUsaGuardian=true`, la gamba
  short di R261d con `false`: l'effetto del Guardian nel tester [NON VERIFICATO] qui.
- **profilo di volatilita' per ora** (oro): serve per dire se la concentrazione degli stop 13:30-15:29 e' anomala; il per-trade non ce l'ha.
- il **DOW short**: §C.

## F. Riproduzione

```
python3 backtest_pipeline/autopsia_pertrade.py --autotest
P=backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE; Q=backtest_pipeline/risultati_archivio/R246/PERTRADE
python3 backtest_pipeline/autopsia_pertrade.py $P/abtg_trades_ABTG_MaxMinNotte_D30EUR_795401.csv --label "DAX LONG corr=1" \
   --confronta $Q/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_794623.csv $P/abtg_trades_ABTG_MaxMinNotte_D30EUR_795404.csv --label2 "DAX SHORT"
python3 backtest_pipeline/autopsia_pertrade.py $P/abtg_trades_ABTG_MaxMinNotte_D30EUR_795402.csv --label "DAX LONG H4"
python3 backtest_pipeline/autopsia_pertrade.py $P/abtg_trades_ABTG_MaxMinNotte_D30EUR_795403.csv --label "DAX LONG R244b"
python3 backtest_pipeline/autopsia_pertrade.py $P/abtg_trades_ABTG_MaxMinNotte_XAUUSD_795301.csv --k 1.811 --label "ORO LONG" \
   --confronta $P/abtg_trades_ABTG_MaxMinNotte_XAUUSD_795302.csv --k2 1.804 --label2 "ORO SHORT" \
   --news mql5/Files/abtg_news_2021_2025_UTC.csv --orologio forex        # B.3 rifatto (tabella della prossimita')
```
I terzili di R, la corsa dopo TP1, il confronto M15/H4 per giornata, gli IC bootstrap di A e la riga "prima stesura" di B.3 sono calcoli sulle
stesse posizioni (`aggrega()` dello script) **non stampati dalla riga** (classe 861: si elencano); la tabella per-lotto e per-ora e la prossimita'
news di B.3 sono quelle stampate dallo script.

**Bussola**: questa e' diagnosi, non una sedia. Nessun esito qui rende schierabile niente; le taglie e i preset restano firme di Claudio. Il valore di
oggi e' che **tre round gia' in coda (R267g1-g4, R267b, R260d) hanno ora una previsione scritta prima del numero**, e che **R267a (news) ha una
misura vera sotto**: ~12 stop su 88 nascono nei 30' di un dato USA — non "bocciato", e con due difetti del calendario da sistemare prima di girarlo.
