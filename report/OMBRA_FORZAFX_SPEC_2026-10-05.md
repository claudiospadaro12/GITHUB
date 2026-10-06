# Ombra della ForzaFX: SPECIFICA (05/10/2026)

> **Stato: SOLO SPECIFICA. Nessun codice MQL5, nessun file da attaccare, nessun EA/preset/conto toccato. Cancello di giudizio
> (`controllo-preventivo`) del 06/10: PASS CON RISERVE sulla SPECIFICA (correzioni in sez. 0, 3, 4.1, 7, 7.4). 🔴 Regola di Claudio del
> 05/10: **nessuna seconda ombra sul 50503392 per 48 ore dall'attacco dell'ombra EMA200**; e anche dopo, l'EA NON si compila ne' si
> attacca prima di (a) una misura NUOVA di RAM/CPU e (b) la firma di Claudio sul codice. Documento interno.**
> Modello: `report/EA_EMA200_OMBRA_2026-10-05.md` (EA ombra gia' attaccato sul demo 50503392, **non toccato**).
> Etichette: [MISURATO] letto da un file/sorgente; [DERIVATO] calcolo mio su numeri misurati; [STIMA] ordine di grandezza senza
> misura; [NON MISURATO]; [NON VERIFICATO] = vero solo dopo compilazione/campo; [SINTETICO] = random walk, vale solo come H0.
> Sorgenti letti per intero: `mql5/Indicators/ABTG_ForzaFX_Dashboard.mq5` (1881 righe), `docs/FORZA_FX_SPEC_2026-10-02.md`,
> `docs/FORZA_FX_NOTE.md`. Strumento di questa spec: `backtest_pipeline/ombra_forzafx_freq_sintetica.py` (sez. 4).

## 0. In otto righe

1. 🔴 **La dashboard NON definisce un segnale operativo.** Definisce un'**etichetta direzionale istantanea per coppia** (STRONG BUY /
   BUY / WEAK + / ... / STRONG SELL, dal punteggio di confluenza a soglie 90/70/40) e **niente altro**: nessun prezzo d'ingresso, nessuno
   stop, nessun target, nessuna uscita, nessun orizzonte. Lo dice il sorgente stesso (r.14 *"NON misura performance"*; tooltip r.1570
   *"confluenza di colori, NON un segnale misurato"*) e la spec (sez. 12: le 4 strategie della guida, il protocollo, stop/target/size
   sono **fuori perimetro**, regole discrezionali senza un numero dietro). Quindi l'ombra **non puo' "simulare la dashboard"**:
   simula **UNA REGOLA NOSTRA costruita sull'etichetta**.
2. Anche l'etichetta e' **in buona parte nostra**: i quattro componenti del punteggio (allineamento, differenza di forza, rotture, correlazione)
   sono **[SCELTA] nostre** dove la guida e' vaga (spec sez. 5) e i casi studio della guida **non si ricalcolano** con le sue stesse
   regole (GBPUSD "+94" somma a 91). L'ombra misura la **nostra ricostruzione** della dashboard, non la dashboard del corso.
3. **Regole candidate (entrambe "REGOLA NOSTRA, NON DELLA DASHBOARD")**: **FZ-A** = entra nel verso dell'etichetta quando una coppia
   passa a BUY/SELL (|punteggio| >= 70) a una chiusura H4; **FZ-B** = come FZ-A ma solo sulla coppia *piu' forte contro piu' debole*
   della classifica. Uscita comune: **stop 1 ATR(D1), TP 2R, uscita a tempo dopo 30 barre H4 (~5 giorni)**. Attese scritte prima (sez. 3).
4. **n si conta in CLUSTER, non in operazioni** (sez. 5): sotto H0 sintetico gli eventi sono ~6,7/giorno su 28 coppie, ma
   **quasi tutti gli eventi di uno stesso giorno si collegano per una valuta in comune**: gli indipendenti sono **al PIU' ~1 al giorno**
   (🔴 limite SUPERIORE: il sintetico ha valute indipendenti, e il legame "stesso giorno" non fonde i giorni consecutivi, che con vite
   di 5 giorni e celle W1/MN quasi costanti sono correlati; per questo il cancello chiede anche >= 26 settimane e il bootstrap a settimane, sez. 5.2). n>=150 *operazioni* arriva in
   ~1 mese e **non vuol dire niente**; n_cluster>=150 arriva in **~6,5 mesi** [DERIVATO, SINTETICO].
5. **Merito non misurabile prima di ~6-7 mesi** dall'accensione; in tre mesi si misurano rischio, frequenza vera e il fenomeno
   "l'etichetta predice la direzione a +4h/+24h/+5g" *per famiglia*. **Nessuna sedia schierabile il 1 ottobre da questo lavoro**: e'
   ricerca, e va dichiarata come tale (sez. 6.4).
6. **Costo di risorse: basso** (sez. 7). La dashboard ha **zero handle di indicatore** [MISURATO: nessun `iMA/iATR/CopyBuffer`, nessun
   `#include`]; l'ombra ne ha zero (ATR a mano, 15 barre D1, solo all'ingresso). Il costo e' memoria delle serie (28 simboli x 9 TF), **gia'
   in gran parte caricata dalle 4 istanze della dashboard su 50503392** [INFERITO, NON VERIFICATO].
7. **EA separato, non un "ombra multi"** (sez. 7.3): il comune fra EMA200 e ForzaFX e' solo il contorno (file, stato, timer), non i dati.
8. **Precedente in casa: nessuna misura.** La forza valutaria "e' sempre stata letta a colori e mai misurata" (spec sez. 0;
   Emiliano G4, Paolo Y8: *"forza valute -> nessuna regola stabile"*). **Non e' archiviata come morta: e' NON ANCORA MISURATA**
   (REGISTRO_TEST.md non ha nessuna riga su di essa; sez. 4.3).

## 1. Cosa MISURA la ForzaFX, riga per riga [MISURATO sul sorgente]

### 1.1 La cella (coppia x TF)
- **9 TF**: M1, M5, M15, M30, H1, H4, D1, W1, MN. Ogni cella guarda **la candela IN CORSO** del suo TF contro la **precedente chiusa**:
  C = Bid live, O0 = apertura in corso, H0/L0 = massimo/minimo finora, H1/L1 = massimo/minimo della precedente. D1 = "oggi finora", W1 =
  "questa settimana finora", MN = "questo mese finora". Nessuna media, nessun oscillatore (`FFX_Stato` r.118-130).
- **Stato** (precedenza: rottura > doppio fail > fail > sopra/sotto apertura), valore nella forza (`FFX_Valore` r.139-151):
  UP_BREAK +2 (C>H1) · UP +1 · FAIL_DN +0,5 · FAIL_UP -0,5 · DN -1 · DN_BREAK -2 (C<L1) · NEUTRO e FAIL doppio 0.
- **D1**: la precedente e' l'ultima candela lun-ven (input `InpD1SaltaWeekend`, r.100) per non usare la candela di un'ora della domenica.

### 1.2 La forza delle 8 valute (`FFX_Forza` r.177-204)
- **Pesi per TF** (input, r.81-89): 1,1,2,3,4,6,10,15,20 = **62**; D1+W1+MN = 45/62 = 72,6%. I TF "strategici" per l'allineamento sono
  **H4, D1, W1, MN** (`gStrat[c]=(c>=5)`, r.951).
- Per ogni cella: base riceve `+valore x peso`, quotata `-valore x peso`; **forza = somma / den**, `den = 2 x somma dei pesi delle celle
  CON DATI` (a copertura piena, 7 coppie x 62 x 2 = 868); stanno in **[-1, +1]**. Somma delle 8 forze = 0 solo con denominatori uguali.

### 1.3 Il punteggio di confluenza e le "lettere" A/D/R/C (`FFX_Punteggio` r.262-275, `FFX_Confluenza` r.256)
`punteggio = A x 40 + D x 30 + R x 20 + C x 10`, in [-100, +100]:
| lettera | cosa | denominatore / formula (sorgente) |
|---|---|---|
| **A** allineamento | media di `FFX_Dir` sui **4 TF strategici** accesi (+1 UP/UP_BREAK/FAIL_DN, -1 DN/DN_BREAK/FAIL_UP, 0 neutro/doppio fail) | somma / numero TF strategici accesi (4) |
| **D** differenza di forza | `(forza[base] - forza[quotata]) / 2` | sta in [-1,+1] per costruzione |
| **R** rotture | media sui TF accesi (9) di +1 UP_BREAK, -1 DN_BREAK, -0,5 FAIL_UP, +0,5 FAIL_DN, 0 altrimenti | somma / TF accesi |
| **C** correlazione | `ALIGN(+1)/DIVERGE(-1)/MIXED(0)` x direzione D1 della coppia | solo per **5 coppie**: EURUSD (`D30EUR`+), GBPUSD (`100GBP`-), USDJPY (`225JPY`+), AUDUSD (`200AUD`+), USDCAD (`USOIL`-), TF D1 (`InpSanityMappa` r.98) |
- **Etichetta** (`FFX_Etichetta` r.277-287, decisa sul numero **arrotondato**, `MathRound` = lontano da zero): >=90 STRONG BUY, >=70 BUY,
  >=40 WEAK +, e speculari (input r.91-93). 🔴 **Conseguenza aritmetica**: le **23 coppie senza correlazione hanno massimo +-90**
  (C=0): STRONG solo col massimo pieno degli altri tre; le 5 con correlazione arrivano a +-100. Sul sintetico (C=0) il massimo visto
  e' 86,5 [SINTETICO].
- **Tempo**: tutto e' calcolato **sulla candela in corso**, tick per tick (timer 1 s, `SymbolInfoTick`; `CopyRates` solo a candela nuova
  + correzione di 3 M1 ogni 60 s). 🔴 **Il punteggio non e' una funzione di barre chiuse**: cambia a ogni tick. Per un'ombra serve un
  **istante di lettura** dichiarato (sez. 2.1), altrimenti e' ambiguo cosa si e' simulato.
- Le celle ad **alto peso (D1/W1/MN = 73%) sono le piu' lente ma anche le piu' "di soglia"**: la cella UP/DN confronta con l'*apertura*
  di oggi/della settimana/del mese, quindi un prezzo che attraversa l'apertura la fa cambiare segno. Nel sintetico il punteggio
  **sfarfalla**: ~5,5% delle letture sta a |punteggio|>=70 e a letture orarie ogni evento resta a >=70 per ~1,8 letture in media (9302 coppie-letture/anno contro 5212 eventi) [SINTETICO, DERIVATO].

### 1.4 SI definisce un segnale operativo? Risposta: NO. Definisce un'etichetta.
| cosa | nella dashboard? | dove |
|---|---|---|
| direzione per coppia in un istante (BUY/SELL/WEAK) | **SI**, a soglie su un punteggio composto | r.277-287 |
| "forza EUR vs forza USD oltre soglia" come regola | **NO**: la differenza di forza e' solo il 30% di un punteggio, nessuna soglia sulla differenza | r.270 |
| prezzo/ordine d'ingresso, quando entrare | **NO** | -- |
| stop, target, R:R, size | **NO**: dichiarati fuori perimetro | spec sez. 12 |
| gestione dell'uscita, orizzonte | **NO** | -- |
| "TOP opportunita'" (le 5 coppie col |punteggio| piu' alto) | **SI come elenco**, non come regola | `FFX_TopOpp` r.290 |
Le "4 strategie" e il "protocollo in 6 passi" esistono **solo nella guida del corso** (non nel repo, materiale di terzi), sono
discrezionali e la spec ha deciso di **non implementarle** (sez. 12). Non e' un buco da colmare "come la dashboard": e' un buco che si
colma con **una nostra regola, dichiarata nostra**.

## 2. Le due REGOLE NOSTRE (non della dashboard) e le regole di simulazione, da scrivere PRIMA dei numeri

> 🔴 Etichetta obbligatoria in ogni tabella del lettore: **"regola nostra costruita sull'etichetta della ForzaFX, non della dashboard"**.

### 2.1 Istante di lettura (uguale per A e B) [DECISIONE DI DESIGN: da confermare al cancello]
- Letture a **ogni chiusura di barra H1** (log descrittivo `letture`), **decisioni solo alle chiusure H4** (server 00,04,08,12,16,20).
  Giorni feriali: 6 decisioni al giorno.
- **Istantanea a T-2 s** (T = chiusura): l'ombra legge lo stato di tutte le celle **prima** del cambio di candela, quindi ai TF <= H4
  la cella descrive la candela che sta chiudendo (= la sua chiusura) e ai TF D1/W1/MN la candela in corso. **Nessuno sguardo nel
  futuro**: la lettura usa solo dati con ora <= T-2 s. Se l'istantanea manca (CPU, riavvio): `PERSO_RITARDO`, la lettura **non si
  recupera** (come l'ombra EMA200).
- Come si leggono le celle: `CopyRates` diretto per le 28 x 9 celle + 5 strumenti di correlazione (D1) = **257 chiamate per lettura**,
  una volta all'ora (non uno stato vivo a 1 s come la dashboard); H0/L0 sono quelli veri del terminale (piu' esatti della dashboard,
  che li approssima fra un secondo e l'altro). Si usano **le stesse funzioni pure** del blocco `@@FFX_PURE_BEGIN..END` del sorgente
  (copiate alla lettera, collaudate in `collaudo_forza_fx.py`), non una riscrittura.
- ⚠️ **Scostamento dichiarato**: la dashboard puo' mostrare in un istante uno stato leggermente diverso da `CopyRates` (estremi persi
  tra un tick e l'altro). **Controllo contro numeri gia' scritti da altri**: le 4 istanze su 50503392 stampano ogni 15 min le righe
  `[ForzaFX diag]` (28 coppie x 9 stati, 8 forze, punteggi) con **ora server dentro**; una istanza stampa a `xx:58:08` (visto nel
  CODA_02 del 05/10: `USDJPY H4 ... 23:58:08`; 🔴 quella e' l'ora del LOG = ora LOCALE del VPS, non l'ora server: il confronto si fa sull'ora
server stampata dall'indicatore, r.1731). Confronto ombra T-2 s contro quella riga a 110 s di distanza: **atteso >=95% delle 252
  celle identiche** [STIMA; il 5% e' il cambio di stato in 110 s]. Se meno: l'istantanea non coincide con la dashboard e si
  ferma tutto prima di accendere. [NON VERIFICATO finche' non gira].

### 2.2 FZ-A (regola nostra, primaria) -- "continuazione dell'etichetta"
- **Evento**: a una decisione H4 la coppia ha `|round(punteggio)| >= 70` (BUY o SELL della dashboard) **ed e' ARMATA**. Direzione = segno.
  Dopo l'evento la coppia si **disarma** e si **riarma** quando, a una lettura (anche oraria), `|round(punteggio)| < 40` (sparisce anche
  WEAK). Etichetta `STRONG` (>=90) loggata come flag, non come regola.
- **Perche' persistenza 1 (letterale)** e non "due letture di fila": il sintetico dice che 2 letture dimezzano i cluster
  (166 contro 279 /anno) e gli eventi da 1742 a 329 /anno: peggiora il campione indipendente e allontana dalla dashboard, che non chiede persistenza; si resta sull'etichetta cosi' com'e' [DERIVATO, SINTETICO].
- **Ingresso**: a mercato al **primo tick dopo T** (Ask per BUY, Bid per SELL), entro `InpGraceSec` (60 s) da T, altrimenti `PERSO_RITARDO`.
- **Stop** = `1,0 x ATR(14) su D1` (ATR = media semplice del True Range delle 14 barre D1 **chiuse**, calcolata a mano da 15 barre, come
  `iATR`), arrotondato al tick. **TP = 2R** (2,0 x ATR D1). **Uscita a tempo**: a mercato alla **30a barra H4** dopo quella d'ingresso
  (~5 giorni di mercato; il weekend non conta perche' le barre H4 non esistono). Scelta del D1 per lo stop: il segnale e' lento (73% del
  peso su D1/W1/MN); un ATR(H1) sarebbe sotto frontiera di costo per costruzione (sez. 2.4).
- **Un setup alla volta per coppia** (come la sedia EMA200); un evento che arriva a coppia occupata e' **loggato come `OCCUPATO`**: e' il denominatore.
- **Gemello contrario** (controllo "stesso evento, stessa geometria, verso opposto", metodo di casa dei "ingressi casuali con la stessa
  geometria"): per ogni setup si simula anche il **verso opposto** con gli stessi livelli. Il lettore giudica **R_dir** e riporta
  **Delta = R_dir - R_opp**: se Delta ~ 0 ma R_dir > 0 e' la deriva (carry, JPY/CHF di finanziamento), non l'etichetta.
- **Uscita all'inversione (descrittiva, NON giudicata)**: `R_inv` = risultato se la posizione fosse chiusa alla prima lettura H4 con
  punteggio nel verso della posizione < +40 (con SL/TP comunque attivi prima). E' una seconda gestione messa ad asse (certificato di morte, punto 3).

### 2.3 FZ-B (regola nostra, secondaria) -- "il piu' forte contro il piu' debole"
- Ad ogni decisione H4: `top` = valuta con la forza massima, `bottom` = minima (parita': ordine EUR..JPY, come `FFX_Ordina`). La coppia
  `top/bottom` esiste sempre fra le 28. Direzione: BUY se `top` e' la base, SELL altrimenti.
- **Evento** solo se la dashboard etichetta **quella coppia nello stesso verso** (`|round(punteggio)| >= 70`) e la terna (coppia, verso)
  **non era gia' vera alla lettura precedente**. Stesse uscite, stesso gemello, stesse regole di simulazione.
- **Perche' esiste**: e' la lettura "valuta forte contro debole" che il cruscotto suggerisce senza mai definirla, e **riduce le
  posizioni simultanee sulla stessa valuta** (A puo' aprire 5 coppie corte sul dollaro; B ne apre una). Non e' un sottoinsieme esatto di A.

### 2.4 Regole di SIMULAZIONE (valgono per A, B e i gemelli) -- scritte qui, prima di qualunque numero
| tema | regola |
|---|---|
| prezzi | M1: bid dalla barra, **spread della barra** (campo `spread` di `MqlRates`) e, per il riempimento, lo spread allo scatto del tick d'ingresso; si usa il **maggiore dei due** (prudente) |
| riempimento | a mercato, **Ask (long) / Bid (short) al primo tick dopo T**; nessun miglioramento di prezzo; slippage 0 |
| SL | long: Low(bid) della barra <= SL; short: High(bid) + spread >= SL; **uscita al prezzo dello SL, o all'apertura della barra se c'e' un buco oltre lo SL (peggio)** |
| TP | long: High(bid) >= TP; short: Low(bid) + spread <= TP; **uscita al TP, mai meglio** |
| stessa barra SL e TP | **vince lo SL** (ripiego M1 dell'ombra EMA200, regola conservativa) |
| barra d'ingresso | **non puo' chiudere** la posizione: si guarda dalla barra M1 successiva |
| tempo | a mercato alla 30a barra H4 dopo quella d'ingresso, a Bid/Ask di quel momento |
| costo (spread) | pagato **dentro** bid/ask (si compra all'Ask, si esce al Bid), **non sottratto una seconda volta** |
| 🔴 costo (commissione) | la ForzaFX e' tutto **forex**, dove la commissione e' il **50-73% del pedaggio** (`MISURA_SPREAD_FOREX_2026-09-12.md`). Si scrive una colonna **`R_allin`** = R - commissione/stop, con commissione di casa **0,004% del nozionale in valuta BASE, giro completo** = `0,00004 x prezzo / pip` pip (EURUSD ~0,46 pip, GBPUSD ~0,53: tornano con i 0,47 e 0,5425 del referto, scarto da prezzo assunto) [DERIVATO]. **Il lettore giudica R_allin**, riporta anche R solo-spread |
| frontiera di casa | `stop_pip / (spread + commissione, in pip) >= 40` = `costo_ok`. **Si logga tutto, anche sotto frontiera** (come l'ombra EMA200); il lettore giudica solo `costo_ok=1`, il resto in tabella descrittiva a parte. Lo spread dei cross e' **[NON MISURATO]** (la flotta ha misure su EURUSD, GBPUSD, USDJPY): lo dira' il log |
| lookahead | letture con dati <= T-2 s; ATR su barre D1 **chiuse**; la barra M1 d'ingresso si salta; nessun valore calcolato con la barra che chiude dopo T |
| orologio | tutto in **ora server** (UTC+1 fisso su BCM, `report/OROLOGIO_BCM_2026-09-24.md`); l'ombra **non ha filtri d'ora**, quindi il cambio del 26/10-02/11 non sposta il segnale |
| mercato chiuso / weekend | le barre H4 non esistono: la posizione resta aperta e il tempo non scorre; flag `attraversa_weekend` nel CSV (gap di apertura = uscita all'apertura se oltre lo SL) |
| riavvio | puntatori e setup aperti in `ombrafx_stato.txt` (scrittura atomica `.tmp` -> rinomina, come l'ombra EMA200); barre perse a EA spento = `PERSO_SPENTO` solo come trigger, **mai simulate a posteriori** |

### 2.5 Cosa si logga (file in `MQL5\Files\ABTG_OmbraFX\`, cartella DIVERSA da `ABTG_Ombra`)
- `ombrafx_letture_AAAAMM.csv`: **ogni coppia a ogni lettura oraria**: punteggio, A/D/R/C, etichetta, forza base/quotata, eta' in ore
  delle candele D1/W1/MN, flag decisione H4. (~672 righe/giorno, ~100 KB/giorno [STIMA]). **Descrittivo**: qualunque regola nuova su queste
  righe e' una regola nuova con il suo K, da scrivere prima.
- `ombrafx_forze_AAAAMM.csv`: le 8 forze e la somma (controllo identita': somma 0 con 28 coppie e copertura piena).
- `ombrafx_trigger_AAAAMM.csv`: ogni evento (A e B) con lo **stato** (`ARMATO`, `OCCUPATO`, `PERSO_RITARDO`, `PERSO_SPENTO`, `RIFIUTATO`).
- `ombrafx_esiti_AAAAMM.csv`: un setup per riga: R, R_allin, R del gemello, R_inv, MAE/MFE, **rendimenti a +4h/+24h/+120h in unita' di
  ATR(D1)** (il test del *fenomeno*, senza stop), spread/commissione, `costo_ok`, `valuta_guida` (la valuta con |forza| maggiore), e per
  ogni setup l'**esposizione netta per valuta** a quel momento (serve al rischio, sez. 5.4).
- `ombrafx_stato.txt`, `ombrafx_battito.txt`, `ombrafx_log.txt`: come l'ombra EMA200.

## 3. Attese scritte PRIMA dei numeri (H0 e cosa le smentisce)

**H0 (per ogni cella giudicata)**: media R_allin = 0 al netto del costo, cioe' nessun vantaggio dell'etichetta. E' l'H0 *economica*; il
*fenomeno* ("l'etichetta predice la direzione") si legge dai rendimenti a +4h/+24h/+120h.

**Fatti che orientano l'attesa [MISURATO]**:
- **In casa nessuna misura sulla forza valutaria** (sez. 4.3). Vicini piu' prossimi: EMA200 H4 forex "al primo tocco respinge" =
  **NULLO** su entrambi i lati (6 coppie, Oanda 2005-2020; `report/EMA200_H4_D1_FOREX28_MISURA_2026-10-03.md`); momentum intraday
  sugli indici = morto in casa (R98); le sedie H4 AUDJPY/GBPUSD con "carry, non il motore" non escluso.
- Il segnale e' **dichiaratamente non ottimizzato** (la guida stessa, p.17: *"i pesi non sono ottimizzati"*, spec sez. 10).
- Un fenomeno di **deriva** (valute di finanziamento JPY/CHF) potrebbe far apparire un "vantaggio" che e' carry: per questo il gemello contrario.

| cella (regola nostra) | attesa scritta prima | cosa la smentisce |
|---|---|---|
| **FZ-A**, tutte le coppie, R_allin | media R in **[-0,10 ; +0,05]**; verdetto **ZONA GRIGIA** (n e precisione) o NULLO; **mai EFFETTO** | EFFETTO con p x K <= 0,05 e il gemello contrario non CONTRARIO nello stesso periodo |
| **FZ-A**, lato LONG / lato SHORT | stesso intervallo per lato; un lato "buono" e uno "cattivo" sullo stesso periodo e' **deriva**, non segnale | un solo lato EFFETTO e Delta = R_dir - R_opp ~ 0 -> e' carry |
| **FZ-B**, tutte le coppie | come A; B ha **meno** cluster correlati ma non per forza piu' edge | EFFETTO dopo la correzione |
| **fenomeno**: rendimento firmato a +24h in ATR(D1) | **|media| < 0,05 ATR(D1)**; banda del null a n_eff=150 circa **+-0,14** (SD ~0,85-1,0 ATR(D1) [STIMA]) | |media| fuori banda, **e** stesso segno a +4h/+120h |
| etichetta STRONG (>=90) vs BUY (70-89) | **non distinguibili** (nessuna misura dice che STRONG conta; e solo 5 coppie possono arrivarci) | STRONG EFFETTO e BUY NULLO, entrambi a n_cluster>=150 |
| **R_allin** a costo_ok=0 (sotto frontiera) | piu' basso che a costo_ok=1 (il costo mangia lo stop) | -- |

**Casualita' (contro-esempio di H0, sintetico)**: sotto random walk il rendimento a +24h firmato da A esce **-0,017 sigma-giorno** (media di 5 semi
da ~2 anni ciascuno, -0,029..-0,003 per seme, errore standard per seme ~0,03 con l'effetto di disegno) e da B **-0,025**: |media| piccola e compatibile
con 0 (A: ~1,5 errori standard a semi riuniti; tutti e 5 i semi negativi, letto come rumore, NON come assenza dimostrata di bias). Uno sguardo nel futuro
darebbe un |valore| grande **di qualunque segno**: il controllo e' a due lati, non "nessuna deriva positiva". Se l'ombra vera facesse +-0,10 in unita di
sigma-giorno, **non** sarebbe H0.
**Potere**: con SD per setup <= 1,41 R (payoff -1/+2) la banda del null (97,5%) a **n_eff=150** e' circa **+-0,23 R**, a 400 **+-0,14 R**
[DERIVATO come `EA_EMA200_OMBRA` sez. 4]. **NULLO** richiede semi-ampiezza IC <= 0,10 R: **~800 episodi indipendenti**. A n_eff=150 una
cella senza vantaggio esce **ZONA GRIGIA**, onestamente.

## 4. Frequenza attesa e tempi per n >= 150

### 4.1 Misura sintetica (H0), dichiarata per quello che e'
Script: `backtest_pipeline/ombra_forzafx_freq_sintetica.py` (seme 20261005, 5 semi x 104 settimane = 9,2 anni di 260 giorni).
Le 8 valute fanno random walk indipendenti (coppia ~0,6%/giorno), M1 non simulato, correlazione C=0, mese=4 settimane. Formule copia di
`FFX_Stato/Forza/Componenti/Confluenza`. **Controlli**: somma delle 8 forze = 4e-16 (identita' tiene); |punteggio| massimo 86,5 (<= 90 con C=0);
rendimento a valle ~0 (contro-esempio, sez. 3). **NON e' una misura sul mercato**: sul mercato vero (code grasse, USD che guida, trend) i numeri
saranno diversi, e **il log `letture` li sostituisce dopo ~2 settimane** (quota di letture a >=70 e eventi/giorno veri).

| (letture a ogni chiusura H4, persistenza 1, riarmo sotto 40) | FZ-A | FZ-B |
|---|---|---|
| quota di letture con \|punteggio\| >= 70 / >= 40 | 5,5% / 38,9% | -- |
| eventi / anno (28 coppie) | **1742** (~6,7/giorno) | **660** (~2,5/giorno) |
| 150 **operazioni** (n_raw) | ~22 giorni di mercato | ~59 giorni |
| **cluster giorno x valuta** / anno (regola di casa) | **279** (~1,07/giorno) | **308** |
| 150 **cluster** | **~140 giorni di mercato (~6,5 mesi)** | **~127 giorni (~5,9 mesi)** |
| effetto di disegno DEFF (solo dentro il giorno, **limite inferiore**) | 2,4 -> n_eff = 42% di n | 1,5 -> 68% |
| 150 indipendenti per DEFF | ~54 giorni (~11 settimane) | ~86 giorni (~4,0 mesi) |
| a letture orarie (invece che H4) | 5212 eventi/anno, 264 cluster, DEFF 4,7 | 2340, 284, DEFF 3,5 |
Il **numero di cluster non dipende da come si legge**: ~1 al giorno comunque (279 H4, 264 H1). La persistenza 2 lo scende a 166/anno.
**Lettura**: l'indipendente e' **al piu' ordine di 1 al giorno** (limite superiore, sez. 0 punto 4; sul mercato vero con l'USD fattore comune sara' meno); fra "11 settimane" (limite inferiore ottimista) e "6,5 mesi" (regola di casa).
Si assume il **cluster di casa** per il cancello: **~6-7 mesi** da quando gira.

### 4.2 Perche' i cluster non si allungano con la vita del setup
Collegare due eventi quando le **vite si sovrappongono** (finestra 2 giorni, condivisione di valuta) fa **percolare** tutto in una sola
componente (**1,2 cluster/anno** su A, 6,2 su B [SINTETICO]): il grafo si fonde e il campione "indipendente" diventa 1. **Non si usa.**
Il collegamento resta quello di `report/EMA200_H4_D1_FOREX28_CRITERI_2026-10-03.md` sez. 6 (stesso giorno UTC+1 **e** valuta condivisa), e
la sovrapposizione multi-giorno si assorbe con il **bootstrap a blocchi di SETTIMANA** (sez. 5.2).

### 4.3 Cosa e' gia' misurato sulla forza di valuta: **NULLA** (con la fonte)
- `REGISTRO_TEST.md` (radice e `backtest_pipeline/`): **nessuna riga** su forza valutaria / ForzaFX / currency strength [MISURATO: grep `forza valut|forzafx|currency strength|strength|forza relativa`; le sole due occorrenze, r.316 "forza delle ultime 3 candele" e r.1969 "Strength" che richiede i costituenti dell'indice, sono altro].
- `docs/FORZA_FX_SPEC_2026-10-02.md` sez. 0 e `docs/FORZA_FX_NOTE.md`: *"la forza valutaria nei nostri verbali e' sempre stata letta a colori
  e mai misurata"*; **nessuna misura di performance in quel giro** (esplicito).
- `report/ANALISI_LIVE_EMILIANO_2026-09-09.md` G4 (nessun numero, solo colori) e r.560 (*"selezione valuta a massimo differenziale di forza:
  precedente negativo agli atti"*: e' il **Y8 di Paolo**, "numeri aritmeticamente incoerenti", **non** una misura di merito) + `docs/live_emiliano/ANALISI_LIVE_storico.md`
  (*"forza valute -> nessuna regola stabile"*, riga su indicatori "in beta"): **sono fonti di opinione/parlato, non misure**.
- 🔴 **Quindi NON c'e' nessun certificato di morte**: lo stato corretto, per `CLAUDE.md` (IL CERTIFICATO DI MORTE), e' **"NON ANCORA MISURATO"**.
  Mancano per un "morto": PF/n/DD misurati; la gestione dell'uscita ad asse (qui: 3 gestioni: SL/TP/tempo, inversione, rendimento a orizzonte
  fisso); i simboli gemelli (28 coppie: ok); **il TF** (si legge a H4; D1 e H1 si ricavano dal log orario ma sono **regole nuove con K nuovo**).
- Fonti adiacenti da NON confondere: R42 (box + fade, 0/24 IS e 0/24 OOS) e R98 (momentum intraday sugli indici) sono **altri meccanismi**.

## 5. Indipendenza: come si conta n e come il lettore fa il bootstrap

### 5.1 Il problema
La forza di una valuta entra in **7 coppie**: se l'USD cala, EURUSD, GBPUSD, AUDUSD, NZDUSD salgono insieme **e** USDCAD, USDCHF, USDJPY
scendono insieme: 7 eventi dello stesso evento economico. Il sintetico (con valute indipendenti, quindi il caso *piu' favorevole*) dice che
gli eventi di un giorno sono **uno solo** in termini di cluster; sul mercato vero (USD fattore comune) sara' **peggio**.

### 5.2 Regole del lettore (da scrivere nel lettore PRIMA dei dati; come `leggi_ombra_ema200.py`, che si riusa importando `nb_per_k`, `pf`, `dd_r`)
- **n_raw** = setup con ingresso eseguito (esclusi `OCCUPATO`, `PERSO_*`, `RIFIUTATO`), per lato. **n_cluster** = componenti connesse (stesso
  giorno server **e** valuta condivisa), **per lato**: e' il **campione indipendente dichiarato**. Si riportano sempre **n_raw, n_cluster, giorni
  distinti, settimane distinte, coppie distinte**.
- 🔴 **Cancello del merito**: **n_cluster >= 150** *e* **>= 26 settimane distinte** *e* n_raw >= 150. Altrimenti **"NON ANCORA MISURATO" e
  "MERITO: NON ANCORA MISURATO"**. Il **RISCHIO si scrive sempre**, a qualunque n (valvola di casa). *(Questa e' la lettura prudente della regola di casa "n>=150
  operazioni": con eventi densi e correlati 150 operazioni non sono 150 prove. Stessa unita' gia' usata il 03/10 per EMA200 H4/D1. **Da confermare da Claudio**, sez. 8.)*
- **IC = il PIU' LARGO fra due**: (a) **bootstrap a blocchi di CLUSTER giorno x valuta** (si ricampionano i cluster interi); (b) **bootstrap a blocchi di
  SETTIMANA ISO server** (assorbe la sovrapposizione multi-giorno e il fatto che le celle W1/MN, che pesano il 56%, sono costanti per giorni). H0 = serie
  **centrata** (R - media). Repliche dimensionate su K (`nb_per_k`), seme fisso. Il blocco-mese di EMA200 non si usa: con 13 settimane per trimestre
  il mese darebbe 3 blocchi.
- **K** = celle giudicate = {FZ-A tutte, FZ-A LONG, FZ-A SHORT, FZ-B tutte} = **4**; correzione di **Bonferroni su K**. Tabelle per coppia, per valuta guida, per ora
  di lettura, per classe di costo: **descrittive, mai verdetto** (un verdetto per coppia a n piccolo e' una pesca fra decine di celle).
- **Verdetto** (parole di casa, regole identiche al lettore EMA200): **EFFETTO** (media > q97,5 del null, >= +0,10 R, IC95 basso > 0, p x K <= 0,05);
  **CONTRARIO** simmetrico; **NULLO** (|media| < 0,05 R, dentro la banda, semi-ampiezza IC <= 0,10 R); altrimenti **ZONA GRIGIA**.
  Un EFFETTO **non promuove niente**: va in coda all'imbuto (backtest a tick IS/OOS + prova di regime), **mai in campo in automatico**.

### 5.3 Contro-esempio gia' costruito (non una premessa)
`ombra_forzafx_freq_sintetica.py` mostra che il **cluster a catena** (vite sovrapposte) collassa a ~1 componente all'anno: se il lettore usasse
quel legame, ogni misura sarebbe "n_cluster = 1". Il lettore ha come autotest (da scrivere) un sintetico con **fattore comune del 70%** (come il test F2 di EMA200):
deve dare `n_cluster < n` di almeno il 10%, e un campione senza correlazione deve dare **EFFETTO su 5 falsi su 100 senza correzione e 0 con**.

### 5.4 Il RISCHIO si legge dalle posizioni simultanee, non solo dal DD in R
- Posizioni aperte contemporaneamente: A su 28 coppie con una per coppia e vita ~2-3 giorni: **~17 aperte in media, tetto 28** [STIMA: 6,7 eventi/giorno x ~2,5 giorni].
  Il lettore riporta **massimo di posizioni aperte, massimo di posizioni nella stessa direzione sulla stessa valuta** (es. "9 corte sull'USD"), DD in R ordinato
  per **chiusura**, e **DD sui cluster** (somma di R per giorno). 🔴 E' il DD **della famiglia NON capata**: i tetti firmati (C1 3,25% attivo; tetto per cluster 3,0% firmato
  il 07/09, **non attivo**, `report/FIRME_2026-09-07.md`) non ci sono in un'ombra: **un DD alto qui non e' un DD che il conto avrebbe preso**, ma dice **quanto
  il tetto servirebbe**.

## 6. Come si legge, cosa e' NON MISURATO, cosa deve dire Claudio

### 6.1 Il lettore (`backtest_pipeline/leggi_ombra_forzafx.py`, da scrivere con l'EA; NON in questa spec)
Stesso schema di `leggi_ombra_ema200.py` (tabelle a schermo e `--out` CSV, `--autotest`, mutazioni): (1) **FAMIGLIA** FZ-A e FZ-B (e per lato) con
n_raw, n_cluster, settimane, tasso di riempimento, PF in R_allin, media, **DD in R (RISCHIO sempre)**, IC, p, verdetto e motivo; (2) il **fenomeno**:
rendimento firmato a +4h/+24h/+120h con la banda del null; (3) **Delta = R_dir - R_opp**; (4) quota **sotto frontiera**; (5) **frequenza vera** (sostituisce
la tabella sintetica dopo ~2 settimane) e quota di letture >=70; (6) quadratura dei trigger; (7) **concordanza ombra-dashboard** sulle righe `[ForzaFX diag]`
(sez. 2.1); (8) rischio simultaneo (sez. 5.4). **Ogni tabella ha come titolo la scritta "regola nostra costruita sull'etichetta della ForzaFX, non della dashboard".**

### 6.2 Cosa e' NON MISURATO (e va scritto in testa al referto)
- **Tutto il merito** (nessun PF, nessun n): `MERITO: NON ANCORA MISURATO`. La frequenza sul mercato vero (la sez. 4 e' sintetica).
- Lo **spread dei cross** (solo EURUSD, GBPUSD, USDJPY misurati): quindi `costo_ok` per i cross.
- L'**accordo ombra-dashboard** a runtime [NON VERIFICATO]; gli **input delle 4 istanze** sul 50503392 (TF accesi, pesi, soglie: se un TF e' spento o
  una soglia diversa, il punteggio dell'ombra **non** e' quello del cruscotto: la riga d'intestazione `[ForzaFX diag] ... TF ... pesi ...` lo dice) [NON VERIFICATO].
- **Un solo regime** (periodo dell'ombra) e **un solo feed** (BCM). Emendamento C (prova di regime) **non soddisfatto** dall'ombra: serve un backtest a tick.
- Il costo **commissione** e' una formula [DERIVATO], non una lettura per coppia.
- Il carry/swap **esclusi**; posizioni di 5 giorni li pagano.
- **Non compilato / mai girato**: tutto cio' che dipende dal runtime di MT5 e' [NON VERIFICATO].

### 6.3 Parole di casa per il referto
Per ogni cella: **NON ANCORA MISURATO** / **ZONA GRIGIA** / **NULLO** / **EFFETTO** / **CONTRARIO**, sempre accanto a `MERITO: NON ANCORA MISURATO` finche'
n_cluster < 150. Un **NULLO** su A non e' un MORTO: il certificato di morte (sez. 4.3) chiede il TF cambiato.

### 6.4 🔴 La bussola, detta chiara
**Questo e' ponteggio di ricerca, non una sedia.** Dal 1 ottobre ogni ora vale quanto avvicina una sedia schierabile: la ForzaFX ombra **non produce una sedia
prima di ~6-7 mesi** e le attese scritte (sez. 3) sono NULLO/ZONA GRIGIA. Le due strade **piu' corte al numero** (da non confondere con "costruire l'EA"):
1. **Fase 0 (costo zero, nessun EA)**: le 4 istanze su 50503392 **stampano gia'** punteggi, stati e forze ogni 15 minuti nel giornale; un collettore di sola lettura
   (le righe `[ForzaFX diag]` dei `MQL5\Logs\*.log`) darebbe **la frequenza vera** e la distribuzione dei punteggi in ~2 settimane, senza accendere niente di nuovo.
   Limite: **niente prezzi**, quindi niente R. E' un allargamento del perimetro di sola lettura del runner: **firma di Claudio** (verbale `report/MANDATO_2026-09-08.md`).
2. **Backtest offline** della regola sullo storico (M1 di 28 coppie): e' la strada che da' un **n vero in giorni, non mesi**; e il collaudo ha gia' le funzioni
   (`collaudo_forza_fx.py`, uguaglianza tick-per-tick provata su 2,5 mesi di XAUUSD M1). **[NON VERIFICATO]** che esista M1 per tutte le 28 coppie (le misure
   forex in casa sono su 6 coppie Oanda 2005-2020). Gira sul **PC di backtest**, mai sul VPS (21/09). Non toccati i file DUKA/dukascopy.

## 7. Costo di risorse (VPS 12282 MB; disponibile 2792 MB il 05/10 14:29 e 1853 MB alle 03:30 col runner [MISURATO, `OMBRA_ATTACCO_A_MANO_2026-10-05.md`]; via libera di casa >= 1800 MB: margine stretto) -- disegno LEGGERO

> 🔴 Ogni numero di questa sezione sul costo dell'ombra ForzaFX e' [DERIVATO]/[INFERITO]/[NON VERIFICATO]. Prima di compilare/attaccare serve
> una **misura NUOVA** (RAM disponibile del VPS, working set e CPU del `terminal64` del 50503392 **con l'ombra EMA200 gia' viva**, 420 handle),
> fatta dopo le 48 ore e confrontata con 1978 MB / soglia 1800 MB: i numeri del 05/10 sono il "prima", non il via libera.

### 7.1 Cosa costa la dashboard [MISURATO sul sorgente / DERIVATO]
- **Zero handle di indicatore** (`grep iMA|iATR|iBands|CopyBuffer|IndicatorCreate` = nessuna riga) e **nessun `#include`**: la ForzaFX **non dipende dalla
  `ABTG_Confluenza_Dashboard`** (quella e' la dashboard delle frecce EMA/BB/Supertrend, `ABTG_Confluenza.mqh`, un altro prodotto: **fuori da questa spec**).
- Memoria propria: ~300 celle x ~15 array di numeri = **< 1 MB** [DERIVATO]. Il peso e' nelle **serie** che `CopyRates` costringe il terminale a tenere:
  28 simboli x 9 TF (piu' i 5 strumenti a D1).
- CPU: `EventSetTimer(1)`; `CopyRates` solo a candela nuova (tetto 40/s) piu' correzione di 3 M1 ogni 60 s: **~40 + ~33 `CopyRates`/minuto** per istanza
  [misura di simulazione della spec sez. 11, **non** misurata dal vivo]. Quattro istanze = ~4x [DERIVATO]: sono **quattro copie dello stesso calcolo**
  (EURNZD M3, GBPJPY H4, USDJPY H4, GBPUSD M15, dal CODA_02 del 05/10); non e' un problema mio ma **tre sarebbero ridondanti** [domanda aperta, sez. 8].

### 7.2 Cosa costerebbe l'ombra (disegno consigliato)
- **Nessun handle**: ATR(D1) calcolato **a mano** da 15 barre alla sola entrata; lo stato si legge con **257 `CopyRates` una volta all'ora** (non 1 s continuo come la dashboard).
- **Simulazione su barre M1, non su tick** (1 `CopyRates` da 2 barre al minuto **solo per le coppie con un setup aperto**, <= 28/minuto): con stop >= 1 ATR(D1)
  (decine di pip) la fedelta' di tick non serve e la regola "stessa barra: vince lo SL" e' gia' conservativa. **Molto piu' leggera dell'ombra EMA200** (che legge tick).
- Memoria marginale: se il terminale ha **gia'** le serie caricate dalle dashboard (50503392 le ha: working set 1978 MB il 05/10 14:29 [MISURATO], 4 dashboard attive) il
  marginale e' piccolo [INFERITO: la cache storica e' per terminale, non per EA; NON VERIFICATO]. Se invece l'ombra andasse su un terminale **senza** quelle serie
  (es. il 100k `50504263`), il peggiore e' **M1/M5/M15/M30 a MaxBars=100000 x 28 simboli**: fino a ~170 MB per TF con `MqlRates` da 60 byte = **fino a ~700 MB**
  [DERIVATO, limite superiore, NON VERIFICATO]: da misurare con la riga di sola lettura prima di attaccare, come per l'ombra EMA200.
- Disco: ~100 KB/giorno di `letture` + poche righe di esiti [STIMA]. Stato piccolo, riscritto solo se cambia.
- **Avvio**: una lettura completa e' 257 `CopyRates` (centinaia di ms nel peggiore, una volta). Tetto di tempo per giro (150 ms, come EMA200) con ripresa al giro dopo.

### 7.3 EA unico "ombra multi" o separato? **SEPARATO.**
| ragione | dettaglio |
|---|---|
| **isolamento del guasto** | un bug della ForzaFX non deve fermare l'ombra EMA200, **gia' attaccata e passata dai cancelli**; modificarla riapre il cancello e rischia il terminale con 26 sedie |
| **i dati non si condividono** | EMA200 ha 420 handle su 4 TF; ForzaFX ha **zero** handle e legge 9 TF di altri simboli: il solo comune e' la **cache di serie del terminale**, che e' gia' condivisa fra EA |
| **un grafico = un EA** | l'unico costo di "separato" e' **un grafico nuovo in piu'** (nessun EA su quel grafico), cioe' pochi MB |
| **il comune e' il contorno** | stato atomico, coda CSV, battito, tetto di tempo: si **copiano come disegno**, non si fondono in un unico binario |
| **la terza ombra non c'e'** | "SuperWave" non ha ancora una specifica d'ombra; quando ce ne saranno **tre**, il livello comune (stato/CSV/battito) si estrae in una libreria **allora**, con il suo cancello. Farlo ora e' ponteggio senza cliente |
Una cosa da NON fare: una **seconda scrittura sulla stessa cartella** `ABTG_Ombra`: l'ombra ForzaFX scrive in `ABTG_OmbraFX\` (sez. 2.5).

### 7.4 Dove attaccarla (quando, e se) 🪟
Bersaglio candidato: il demo **`50503392`** (`C:\Program Files\BCM Markets MT5 Terminal`), dove le serie sono gia' caricate e dove gira l'ombra EMA200: **un
cambiamento alla volta**, quindi **non prima di 48 ore** dall'attacco dell'ombra EMA200 (regola di Claudio del 05/10), **poi** una misura nuova di RAM/CPU
(sez. 7) **e** la firma di Claudio sul codice; mai insieme. Se la RAM disponibile e' sotto 1800 MB, non si attacca. **Non toccati**, per nome: reale `10105439` (`C:\BCM_Reale`),
FTMO `541452707`/`1514806751` (`C:\FTMO`), 100k `50504263` (`... MT5 Terminal -V3`), manuale `50503635` (`C:\MT5_MANUALE`), banco `50504400` (`C:\MT5_Backtest`), Pepperstone, Tickmill.
Grafico **nuovo**, mai uno con un EA. Le righe di lancio, quando serviranno, passano dal cancello come tutto il resto.

## 8. Domande per Claudio (con il mio default se tace)
1. **Vale la pena adesso?** Merito non prima di ~6-7 mesi (sez. 4.1), attesa NULLO/ZONA GRIGIA, nessuna sedia per ottobre. *Default se tace: non costruisco l'EA; propongo la
   Fase 0 (collettore dei `[ForzaFX diag]`, costo zero) e/o il backtest offline.*
2. **Firma sul perimetro del runner** per un collettore di sola lettura delle righe `[ForzaFX diag]` nei `MQL5\Logs` di 50503392 (nessun EA nuovo).
3. **Conferma delle due regole nostre** (FZ-A primaria, FZ-B secondaria) e della geometria **stop 1 ATR(D1) / TP 2R / tempo 5 giorni**: sono scelte mie, scritte prima dei numeri, **non della dashboard**.
4. **Conferma che n>=150 si legge su n_cluster** (giorno x valuta) e non su operazioni. E' coerente col 03/10 ma e' una lettura piu' severa della regola di casa.
5. **Le quattro domande aperte della nota del 02/10** restano aperte (`docs/FORZA_FX_NOTE.md` sez. 6): le **celle bianche** della tua foto (NEUTRO o grigio?), i numeri di **AUD, CAD, JPY** (la somma deve
   fare circa -0,20 se la dashboard del corso usa la formula della guida), il **DXY** su BCM, e se il corso da' il sorgente. **Se la dashboard del corso usa un'altra formula, l'ombra misura la nostra e non la sua.**
6. **Le 4 istanze della dashboard su 50503392**: gli stessi 28x9 calcolati quattro volte (EURNZD M3, GBPJPY H4, USDJPY H4, GBPUSD M15). Ne basta una? (non lo tocco io: sono finestre tue).

## 9. Cosa NON e' stato fatto / limiti di questo documento
- Nessun codice MQL5, nessun lettore, nessun EA, nessun file da attaccare. Un solo script Python di sola misura sintetica e questa spec.
- Cancello del 06/10 sulla **specifica** (`controlla_riga.py --oggetto md`: nessun difetto meccanico; `controllo-preventivo`: PASS CON RISERVE). Il futuro
  codice MQL5, il lettore e ogni riga di lancio ripassano dal cancello per conto loro.
- I numeri della sez. 4 sono **H0 su random walk** e valgono solo come ordine di grandezza; il mercato vero li sostituira' dopo ~2 settimane di `letture`.
- Non ho letto la guida del corso (non e' nel repo): le definizioni dei componenti A/D/R/C sono quelle **nostre** della spec.
- Il rischio di orologio: BCM e' UTC+1 fisso, quindi la candela D1/W1 non e' ancorata alla chiusura di New York in modo stagionale; l'ombra non ha filtri d'ora e non e' sensibile,
  ma la **composizione** delle celle D1/W1 d'inverno e' un po' diversa da quella d'estate [NON MISURATO].
