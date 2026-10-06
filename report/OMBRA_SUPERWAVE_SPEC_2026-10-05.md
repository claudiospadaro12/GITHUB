# OMBRA della SuperWave v4.1 (e di Pulsanti Grafico): SPECIFICA (05/10/2026)

> **Stato: SOLO SPECIFICA.** Nessun codice MQL5, nessun file da attaccare, nulla mandato a Claudio ne' al VPS. Cancello di giudizio
> `controllo-preventivo` del 06/10: **PASS CON RISERVE** sulla specifica (riserve corrette nel testo: sez. 1.5, 5.1, 6.2, 7).
> 🔴 **Regola di Claudio del 05/10: nessuna seconda ombra sul `50503392` per 48 ore dall'attacco dell'ombra EMA200** (prudenza su RAM/CPU).
> Questa specifica puo' esistere, ma il codice **NON si compila ne' si attacca** prima di: (a) le 48 ore; (b) una **misura nuova** di RAM e CPU
> del VPS e del `terminal64` del `50503392` con l'ombra EMA200 a regime; (c) la **firma di Claudio sul codice**. Nessuna delle tre e' nostra.
> Modello: `report/EA_EMA200_OMBRA_2026-10-05.md` (stesso schema: EA senza ordini, regole scritte prima dei numeri, CSV, lettore).
> Fonti lette per intero: `mql5/Indicators/ABTG_SuperWave_Dashboard_v41.mq5` (1826 righe, `#property version "4.10"`, ultimo commit `fd7c958d`,
> sha256 `7c2d793e4d3d44b7...`) e `mql5/Indicators/ABTG_Pulsanti_Grafico.mq5` (2029 righe, commit `791da022`, sha256 `eeb5b1af66aad642...`).
> Ponteggio di supporto (committato, riproducibile): `backtest_pipeline/ombra_sw_h0_e_struttura.py` (sottocomandi `identita`, `h0`, `struttura`).
> Etichette: [MISURATO] letto da un file/corsa; [DERIVATO] calcolo mio su numeri misurati; [STIMA] ordine di grandezza; [NON MISURATO]; [NON VERIFICATO] = vero solo in campo.

## 0. In dieci righe

1. **Segnale**: il Supertrend (ATR 10 a media semplice, moltiplicatore 3,5) di una cella (simbolo x TF) si **inverte sull'ultima barra chiusa**;
   ingresso = chiusura di quella barra, stop = valore del Supertrend su quella barra, TP1/2/3 = ingresso +- 1/2/3 R, quote 40/30/30.
2. **`ABTG_Pulsanti_Grafico` e' lo STESSO segnale, non uno indipendente** (funzioni pure identiche, provato con `ombra_sw_h0_e_struttura.py identita`
   e con un mutante che il confronto vede; la composizione del setup e' uguale per LETTURA, non per script: sez. 1.5). **La specifica e' una sola.** Differisce solo l'uso: Pulsanti e' un TF alla volta, a mano (sez. 1.5).
3. Cosa la dashboard NON definisce e noi dobbiamo scrivere ("regola nostra"): riempimento, **uscita**, vita del setup. Regola primaria **A**: stop fisso,
   residui chiusi a mercato al **flip opposto** della stessa cella (e' esattamente il momento in cui la dashboard sostituisce il setup). B (pareggio dopo TP1)
   e C (stop che segue il Supertrend) **solo descrittive** (sez. 2.3).
4. Ogni flip e' un setup: con questa regola una cella ha **sempre** un setup vivo (niente "slot occupato"), vita mediana 26 barre [DERIVATO su passeggiata aleatoria].
5. **Frequenza**: 2,2-3,4% delle barre sono un flip [MISURATO su EURUSD/XAUUSD 2019 e DAX 2017, da M1 a H4]. Per cella (24h, giorni feriali):
   M15 ~2,3/giorno, H1 ~0,5, H4 ~0,13, D1 ~0,03. **n >= 150 per cella: M15 ~3 mesi, H1 ~12-14 mesi, H4 ~4 anni**; per **famiglia** (29 simboli): H1 ~2 settimane, H4 ~2 mesi (sez. 3.2).
6. **Costo**: lo stop e' ~4,0 ATR(10) del TF [MISURATO 3,8-4,0]. M1-M5 sono **fuori frontiera** su forex e indici; M15 forex e' dentro solo nel **9%** dei setup, H1 forex nel ~59%
   (EURUSD 2019); l'oro oggi e' dentro fino a M1 al filo (sez. 3.3).
7. **H0** scritta prima: media R lorda ~0 (-0,013..+0,020 nelle alternative), **sd 0,93 R per setup**: a n=150 banda +-0,148 R, per un NULLO (semi-ampiezza <= 0,10 R) servono **~330 setup**.
   Atteso: ZONA GRIGIA / NULLO, **mai EFFETTO**. Quello che c'e' di misurato in casa sullo stesso segnale (M3, DAX/oro/S&P) e' NULLO (sez. 3.5).
8. **Risorse**: nessun handle, nessun indicatore: `CopyRates` di 1000 barre solo a barra nuova (come la dashboard) + lettura tick dei simboli con setup vivo. CPU < 1% di un core [STIMA];
   RAM dell'EA < 10 MB, marginale nel terminale <= ~120 MB se condivide le serie con l'ombra EMA200 [STIMA, NON VERIFICATO] (sez. 4).
9. **Disegno**: **EA SEPARATO**, non "ombra multi", e **contratto comune** (file, battito, stato, lettore) cosi' un'eventuale fusione e' meccanica (sez. 4.3).
10. 🔴 **E' ponteggio**: avvicina una sedia solo se una cella esce EFFETTO, e l'attesa scritta qui dice che e' improbabile. Il valore e' dare a Claudio frequenza e rischio VERI della
    dashboard che guarda, a costo di macchina ~0. Va detto cosi', non come progresso.

## 1. Il segnale ESATTO

### 1.1 Algoritmo (dal codice, righe del v4.1; Pulsanti nella sez. 1.5)
- **Supertrend `SW_STCore`** (r.253-296): per ogni barra `i >= per`: `ATR = (somma degli ultimi per True Range)/per` con `TR = max(h[k],c[k-1]) - min(l[k],c[k-1])`
  (media SEMPLICE = convenzione di `iATR` di MT5, misurato in casa), `mid = (h+l)/2`, bande `mid +- mult*ATR`, banda finale classica
  (`up = (ub<up[i-1] || c[i-1]>up[i-1]) ? ub : up[i-1]`, `dn` speculare), direzione: `+1` se `c[i] > up[i-1]`, `-1` se `c[i] < dn[i-1]`, altrimenti quella di prima;
  seme a `i==per`: `c >= mid ? +1 : -1`. Valore del Supertrend = `dn[i]` se su, `up[i]` se giu'. Nessun handle `iATR`.
- **Barre**: solo CHIUSE. La dashboard legge `CopyRates(sym, tf, 1, InpGridBars, ...)` (start=1: la barra in formazione e' esclusa) e ricalcola solo quando `iTime(sym,tf,1)` cambia (r.846-930).
- **Inversione** (`SW_BarsSinceFlip`, `first = InpAtrPeriod + 1 = 11`): `dir[i] != dir[i-1]` per `i > first`; `bs = 0` = inversione proprio sull'ultima barra chiusa.
- **Cella accesa** = `bs < InpFlipBars` con `InpFlipBars = 1`, cioe' **solo `bs == 0`**: la cella e' accesa per la durata di UNA barra del TF.
- **Setup** (r.892-926): ultima inversione `fi = SW_LastFlip(...)`; vale solo se `fi >= first + SW_TRUST_BARS` (= 311 barre dall'inizio della finestra: prima, lo stato della finestra puo' non aver
  agganciato quello dello storico intero; misurato: aggancio <= 140-146 barre a 3,5). Poi: **ingresso = `close[fi]`**, **stop = `val[fi]`** (valore del Supertrend sulla barra di inversione),
  `R = |ingresso - stop|`, valido solo se `SW_SetupOk` (stop dal lato giusto: BUY `0 < stop < ingresso`, SELL `stop > ingresso`), **TPk = ingresso +- InpTPk_R x R** (`TpPrice` r.1263).
  Il setup "resta fisso fino alla prossima inversione" (r.1469); lotti = rischio % del saldo diviso 40/30/30 (indicativi, non e' un ordine).
- **Stato mostrato** (`ComputeHits` r.1267, `SW_SetupState`): da `fi+1` fino alla barra 0 incluso, con massimi/minimi di barra: APERTO / TPk raggiunto / INVALIDATO (stop prima di ogni TP) /
  TP poi stop / "stop e TP nella stessa barra (ordine non noto)". **La dashboard non muove lo stop, non fa pareggi, non ha trailing, non chiude nessuna quota: mostra solo i tocchi.**

### 1.2 Valori di default (letti dal codice)
| input | default | ruolo |
|---|---|---|
| `InpSymbols` | 29 simboli (sez. 1.6) | griglia |
| `InpAtrPeriod` / `InpMult1` | **10 / 3,5** | **il segnale** |
| `InpMult2` / `InpMult3` | 3,0 / 2,5 | solo disegno (non entrano nel setup) |
| `InpMA1/2/3`, `InpMAmethod` | 14 / 100 / 200, SMA | solo disegno (3 handle `iMA` sul simbolo del GRAFICO) |
| `InpFlipBars` | **1** | cella accesa solo sulla barra dell'inversione |
| `InpConflMode` / `InpConflFlipBars` / `InpConflH4Stable` | 1 / 3 / 3 | evidenziazione del simbolo (non e' il setup, sez. 1.4) |
| `InpGridBars` | 1000 (min 400 = 300+100, max 5000) | barre chiuse lette per cella |
| `InpRiskPct`, `InpTP1/2/3_R`, `InpSize1/2/3` | 1,0 / 1-2-3 / 40-30-30 | scala del setup |
| `SW_TRUST_BARS` | 300 (costante) | zona affidabile |
| TF della griglia | M1, M3, M5, M15, H1, H4, D1 | 7 colonne |

### 1.3 La confluenza H4/M3 e' un'EVIDENZIAZIONE, non un segnale diverso
`SW_Confl` modo 1 (r.324): il simbolo si accende se M3 e' invertito entro 3 barre M3 chiuse nel verso dell'H4 e l'H4 non ha invertito nelle ultime 3 barre H4. **Il setup e' sempre quello
della cella (simbolo, TF del segnale)**: un'inversione M3 e' un setup M3 con o senza confluenza. La confluenza diventa una **etichetta** del setup (sez. 2.7), non un secondo segnale.

### 1.4 Cosa NON e' segnale e l'ombra NON simula
Lampeggio, riquadro del simbolo, Heikin Ashi, livelli price action, Supertrend 3,0/2,5, medie 14/100/200, lotti.

### 1.5 `ABTG_Pulsanti_Grafico.mq5`: segnale INDIPENDENTE o lo stesso? **LO STESSO.**
Prova (`python3 backtest_pipeline/ombra_sw_h0_e_struttura.py identita`): confrontate **senza spazi ne' commenti** le funzioni pure dei due file: `SW_STCore`, `SW_BarsSinceFlip`, `SW_LastFlip`,
`SW_SetupOk`, `SW_Hits`, `SW_SetupState` e `TpPrice` contro `PG_Tp` = **tutte IDENTICHE**; contro-esempio: una copia di Pulsanti con `c[i-1]<dnF[i-1]` cambiato in `<=` dentro `SW_STCore` viene vista come DIVERSA
(le altre restano uguali). Il setup di Pulsanti (`PG_Setup` r.753-769, `EvalSetup` r.1685-1727) e' riga per riga quello della SuperWave: ultima inversione fra le chiuse, `f >= first + 300`,
`entry = c[f]`, `stop = val[f]`, `SW_SetupOk`, TP a 1/2/3 R. Default uguali: `InpStPeriodo = 10`, `InpSetupMolt = 3,5`, TP 1/2/3, size 40/30/30, rischio 1%.
⚠️ **Portata della prova (cancello 06/10)**: lo script confronta le **7 funzioni pure**, NON la composizione del setup. `PG_Setup` (solo in Pulsanti) e il blocco setup della v4.1
(r.894-904) e il passaggio dei parametri (`SW_STCore(...,gStP,gSuM,...)` r.2000 con `gStP=InpStPeriodo`, `gSuM=InpSetupMolt` r.1765/1768; v4.1 r.879 `InpAtrPeriod, InpMult1`) sono
uguali **per LETTURA**, riletti dal cancello: un mutante su `f<first+trust` in `PG_Setup` **non viene visto** dallo script (provato). L'identita' e' quindi: funzioni pure [MISURATO dallo script] +
composizione [LETTO, due letture]. Resta una differenza di DATI: Pulsanti calcola sulla storia intera del grafico, la v4.1 su 1000 barre (aggancio entro 140-146 barre, sez. 1.1).

| | SuperWave v4.1 | Pulsanti Grafico (tasto ORDINE CONSIGLIATO) |
|---|---|---|
| simboli x TF | 29 x 7, tutti insieme | solo simbolo e TF del grafico, un clic alla volta |
| storia usata | 1000 barre chiuse per cella | tutta la storia del grafico (fino a "Max barre") |
| ultima inversione piu' vecchia della finestra letta | si ricorda in `GlobalVariable` (`SW41S_...`) | non serve (legge tutta la storia); se cade nelle prime 311 barre dei dati: nessun setup (codice 2) |
| confluenza H4/M3 | si' (evidenziazione) | no |
| stato (APERTO/TPk/INVALIDATO) | da `CopyRates` fino alla barra 0 | barre chiuse + barra in formazione (`SW_Hits` identica) |
| stato iniziale | acceso | **spento** (tasto) |
| avviso | "non e' un ordine" | "SETUP INDICATIVO - NON VALIDATO" |

**Conseguenza: UNA specifica, un'ombra.** Una differenza d'USO resta fuori misura: Pulsanti mostra il setup anche quando l'inversione e' vecchia, e chi lo usa a mano puo' entrare "dopo" a livelli gia' fissati.
L'ombra misura l'ingresso al momento dell'inversione, non quello discrezionale [NON MISURATO].

### 1.6 Quale combinazione simbolo x TF si simula
- **Simboli (default = lista della dashboard, 29)**: forex (24) `EURUSD EURGBP EURJPY EURCHF EURAUD EURCAD EURNZD GBPUSD GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD CHFJPY CADCHF CADJPY USDJPY USDCHF USDCAD AUDCAD AUDCHF AUDJPY AUDNZD AUDUSD`;
  indici (3) `D30EUR NASUSD SPXUSD`; metallo (1) `XAUUSD`; cripto (1) `BTCUSD`. Il codice dice "adatta ai TUOI BCM": la lista sul grafico di Claudio puo' essere diversa [domanda 1].
  🔴 **`U30USD` (il Dow) NON e' nella lista**: e' il simbolo dove la famiglia SuperWave (altro segnale, sez. 3.5) ha il PF migliore misurato (Dow H1 1,52). Proposta: input separato `InpSimboliExtra = "U30USD"` (default vuoto), da decidere.
- Rispetto alla lista dell'ombra EMA200 (30): **22 in comune, 7 solo qui** (`AUDCHF BTCUSD EURAUD EURCAD EURCHF EURJPY GBPCHF`), 8 solo li' (`NZDUSD NZDJPY NZDCAD NZDCHF XAGUSD U30USD 200AUD 225JPY`); unione 37.
- **TF**: default **M15, H1, H4, D1 su tutti i 29 = 116 celle**, piu' **M1, M3, M5 solo su `XAUUSD` = 3 celle** (l'oro e' dentro frontiera, sez. 3.3). Totale **119 celle**. M1/M3/M5 sugli altri simboli: **spenti di default**
  (fuori frontiera per costo e, soprattutto, ~+300-500 MB di serie nel terminale [STIMA]); si accendono con un input solo dopo una misura di RAM.

## 2. Regole di SIMULAZIONE (scritte PRIMA di qualunque numero)

### 2.1 Principio
La dashboard definisce: segnale, ingresso (prezzo di chiusura), stop, TP, quote. **Non definisce**: come si entra (prezzo di mercato), cosa succede ai residui, cosa succede quando arriva il flip opposto.
Tutto cio' che segue e' **"regola nostra"**, dichiarata tale; dove possibile e' la lettura piu' semplice del testo della dashboard ("il setup resta fisso fino alla prossima inversione").

### 2.2 Riempimento (a mercato, alla barra successiva)
- Decisione a **barra chiusa**: nessun look-ahead. L'ordine a mercato parte al **primo tick con ora >= apertura della barra successiva** (= chiusura della barra di inversione), letto dai tick veri
  (`CopyTicksRange`, non dall'ora in cui l'EA se ne accorge): **BUY all'Ask, SELL al Bid**. Ritardo di fill = 0 s (**ottimistico** per una mano umana: [NON MISURATO]; si logga anche il prezzo a +30 s,
  colonna `px_30s`, solo per una sensibilita' dell'ingresso).
- **I livelli restano quelli della dashboard** (`e` = chiusura della barra di inversione, `stop`, `TPk`, tutti su prezzi Bid di barra). `R_dash = |e - stop|`. Il risultato si misura **in R_dash col prezzo di
  fill vero**: `slip_ingresso_R = d*(fill - e)/R_dash` (positivo = peggio) entra in ogni gamba. Cosi' la differenza fra "il prezzo scritto" e "il prezzo preso" (spread + salto fra due barre) e' pagata, non nascosta.
- Fill oltre lo stop (gap): `SALTATO_GAP_OLTRE_STOP` (si logga, non si conta). Fill gia' oltre un TP: quella gamba chiude subito a mercato (`TP_GAP`). Nessun tick entro 6 ore dalla barra (mercato chiuso): fill al primo tick
  disponibile, con `ritardo_fill_s` scritto e flag `gap_riapertura` se > 3600 s (descrittivo a parte). Spread al fill > 3 volte quello dell'ultimo tick prima dell'apertura: flag `fill_spread_alto`.
- Setup con stop dal lato sbagliato (`SW_SetupOk` falso): `SALTATO_STOP_LATO`; sui dati veri e' 0 su 18 celle strutturali (sez. 3.1), si logga lo stesso.

### 2.3 Le tre gambe e le tre regole d'uscita (stessi tick, stesso setup)
Tre gambe con pesi **40/30/30** su TP1/TP2/TP3 (1R/2R/3R dalla dashboard), **stop comune**. `R_X = somma(peso_j x R_j)` per la regola X; `R_j` della gamba j:
TP: `TPk - fill` in R_dash (cioe' `k - slip`); stop: `d*(prezzo_di_uscita - fill)/R_dash`; flip: idem col prezzo di uscita a mercato.
- **A (PRIMARIA, e' sulla A che si giudica)**: stop fisso a `stop_dash`; i residui chiudono **a mercato al primo tick successivo alla barra del flip opposto** della stessa cella
  (BUY esce al Bid, SELL all'Ask; e' lo stesso tick in cui si apre il setup opposto: stop-and-reverse, come la dashboard che sostituisce il setup). Nessun limite di durata.
- **B (descrittiva)**: come A, ma quando la gamba 1 prende TP1 lo stop dei residui va al **prezzo di fill** (pareggio; dal tick dopo). E' la gestione del vecchio EA `ABTG_SuperWave_EA` ("break-even sui restanti dopo TP1").
- **C (descrittiva)**: come A, ma a ogni barra chiusa lo stop **segue il valore del Supertrend** di quella barra, solo nel verso favorevole (dal primo tick della barra dopo). E' la gestione che la sedia vera `770511`
  ha misurato positiva (`SUPERWAVE_LE_56_PASSATE_FERME`: trailing sul Supertrend PAGA, IS PF 1,489 contro 0,903).
- **Il verdetto e' SOLO sulla A.** B e C servono al "certificato di morte" (la gestione dell'uscita messa ad asse almeno una volta); **non possono cambiare un verdetto** e non entrano nel conteggio K.
  Se complicano il codice si tolgono (A non cambia).

### 2.4 Prezzi, ordine dei tick, stesso-bar
- **Per tick** (bid/ask veri): ordine **stop, poi TP** della gamba; stop LONG quando `Bid <= stop`, SHORT quando `Ask >= stop`, **al prezzo del tick** (se c'e' un buco, peggio dello stop); TP LONG `Bid >= TP`,
  SHORT `Ask <= TP`, **al TP, mai meglio**. Lo spread si paga **dentro** bid/ask: non si sottrae una seconda volta.
- **Stesso tick**: stop vince (a un tick non si possono incrociare stop e TP distanti: e' solo la regola).
- 🔴 **Lezione del ponteggio** (contro-esempio costruito per questa specifica): la prima versione dello script H0 usciva "al livello" dello stop su massimi/minimi di barra e la regola C mostrava **+0,022..+0,033 R
  su una passeggiata aleatoria** (impossibile: e' una martingala). Era un artefatto: uscire al livello invece che al prezzo del tick regala il superamento. Rifatto a sotto-passi con uscita al prezzo del
  sotto-passo: C = -0,008..-0,000. **L'EA deve uscire al prezzo del TICK, mai al livello.**
- **Ripiego M1** (solo se mancano i tick di un tratto PASSATO, dopo un riavvio): come l'ombra EMA200 sez. 2.3 (**stesso-bar: vince lo STOP**; Ask = Bid + spread della barra; il minuto dell'ingresso non accredita TP;
  colonna `fonte` = `TICK`/`M1`/`TICK+M1`/`+BUCO`).
- MAE/MFE del setup in R_dash dal fill, spread dentro, fino all'uscita.

### 2.5 Costo di casa (frontiera `stop >= 40 x spread`) e commissioni
- `stop = R_dash`. Si loggano **tutti i setup, anche sotto frontiera**: il lettore giudica **solo `costo_ok = 1`** e mette gli altri in una tabella descrittiva (`--includi-sotto-frontiera` per tutto).
- **Commissione, perche' conta qui**: la correzione di casa dell'11/09 (`CANCELLO_COSTO_FLOTTA`) ha mostrato che sul forex BCM il costo e' spread **piu'** commissione (**0,004% del nozionale in valuta base, giro completo**
  [MISURATO], cioe' `0,00004 x prezzo` in unita' di prezzo: EURUSD ~0,47 pip, 0,86 pip all-in) e ha ribaltato cinque sedie. Quindi il decisore e' il **costo pieno**: `costo_px = spread_fill + comm_px`;
  forex `0,00004 x fill`; **oro 0,0403 $** (misurata su 520 operazioni, `ORO_1530_CANCELLO_COSTO` 2.4); indici 0 [MISURATO]; **BTCUSD [NON MISURATO]** (0 con flag `comm_nota=NM`).
  `stop_su_costo = R_dash/costo_px`, `costo_ok = (stop_su_costo >= 40)`; si logga anche `stop_su_spread` e `costo_ok_spread` (la convenzione "solo spread" del resto del repo).
- `R_X_netto = R_X - comm_px/R_dash`. **Slippage 0. Swap ESCLUSO** [NON MISURATO]: si logga la durata del setup in giorni (H4/D1 tengono posizioni per giorni e il swap li puo' toccare).

### 2.6 Eventi particolari
- **Primissimo avvio**: la barra in corso non si valuta; nessun setup preesistente viene simulato (un'inversione vecchia non e' un evento). **Barre nate a EA spento**: trigger `PERSO_SPENTO`, mai simulate.
- **Barra vista tardi** (oltre `InpGraceSec` = 300 s dall'apertura): trigger `PERSO_RITARDO`, niente setup; se fra due valutazioni passano piu' barre, i flip delle barre intermedie sono `PERSO_RITARDO`
  (si scorrono le inversioni dopo l'ultima barra valutata, solo l'ultima e' un evento in tempo).
- **Dati non pronti**: stesso controllo della dashboard (`SW_GatePre/SW_GatePost`, serie sincronizzata, ultima barra copiata == `iTime`, calcolo provvisorio rifatto al giro dopo). Cella `non_pronta` contata nell'imbuto.
- **Persistenza**: come l'ombra EMA200 (stato su file con scrittura atomica `.tmp` -> rinomina, puntatore dei tick per simbolo, setup aperti con livelli e stato delle tre regole; armo = prima lo stato poi la riga,
  chiusura = prima la riga poi lo stato; doppioni tolti per `id` dal lettore). Una sola istanza per terminale (cartella propria, `InpTag` per una seconda).
- **Weekend / rollover**: i setup restano aperti; i tick mancano, i gap si pagano al prezzo del tick. D1 e H4 sono le barre del **server** (UTC+1 fisso, `OROLOGIO_BCM_2026-09-24.md`): nessun filtro d'ora, quindi il cambio
  d'ora del 25/10 non sposta il segnale.

### 2.7 Etichette di contesto (descrittive, non cambiano il verdetto)
- `htf` = **H4** per i TF <= H1 (il filtro della dashboard), **D1** per H4, `-` per D1. `htf_conc` = `+` se il Supertrend 3,5 del TF superiore **all'ultima barra chiusa con inizio + durata <= chiusura della barra
  di inversione** va nel verso del setup, `-` se opposto, `?` se non pronto; `htf_bs` = barre dall'ultima inversione del TF superiore (0 = proprio sull'ultima).
- `confl_dash` = 1 se `htf_conc = +` e `htf_bs >= 3` (stessa regola di `SW_Confl` modo 1, applicata a ogni TF; per M3 e' il simbolo acceso della dashboard). Una confluenza che nasce **1-2 barre M3 dopo** l'inversione
  (il pannello resta acceso 3 barre) **non e' coperta** [NON MISURATO].

### 2.8 Output (cartella `MQL5\Files\ABTG_Ombra_SW\`, ASCII, `;`, come l'ombra EMA200; nessun conflitto con `ABTG_Ombra\`)
| file | contenuto |
|---|---|
| `sw_esiti_AAAAMM.csv` | un setup per riga: `id; barra_tf; fill_server; simbolo; tf; lato; atr10; e_dash; stop_dash; R_pts; R_atr; tp1; tp2; tp3; fill_px; slip_in_R; spread_fill_pts; comm_R; stop_su_spread; stop_su_costo; costo_ok; costo_ok_spread; htf; htf_conc; htf_bs; confl_dash; esito_leg1/2/3; R_A; R_A_netto; esito_A; R_B; R_C; vita_barre; durata_min; mae_R; mfe_R; px_30s; ritardo_fill_s; flag; fonte; parametri; versione` |
| `sw_trigger_AAAAMM.csv` | **ogni flip visto**, con stato: `SETUP`, `SALTATO_STOP_LATO`, `SALTATO_GAP_OLTRE_STOP`, `PERSO_RITARDO`, `PERSO_SPENTO`, `NON_PRONTA`: e' il denominatore |
| `sw_imbuto_AAAAMM.csv` | per giorno x simbolo x TF: `valutate; non_pronte; flip_viste; setup; saltati; persi_ritardo; persi_spento; chiusi_flip; chiusi_stop; chiusi_tp3`; **quadratura** `flip_viste = setup + saltati + persi` |
| `sw_stato.txt`, `sw_battito.txt`, `sw_log.txt` | stato di riavvio, "sono vivo" ogni 60 s (setup vivi, tick, giro ultimo/massimo in ms), avvio/simboli saltati |
| `sw_audit_AAAAMMGG.csv` | **parita' con la dashboard**: per i primi 3 setup di ogni TF (12), la finestra completa di 1000 barre `H;L;C` e entry/stop/direzione/ora dell'inversione stampati a 12 cifre. Il collaudo rifa' `st_full` (specchio C++ collaudato) e deve ritrovare gli stessi numeri |

## 3. FREQUENZA, tempi per n >= 150 e ATTESE (H0) scritte prima

### 3.1 La struttura misurata (nessun esito in R: solo flip, stop e costo) [MISURATO]
`python3 backtest_pipeline/ombra_sw_h0_e_struttura.py struttura`: M1 -> TF su UTC+1, `st_full` del collaudo, Supertrend 10 x 3,5, zona affidabile 300 barre. Costo per giro: EURUSD **0,86 pip** all-in, oro **0,2003 $**, DAX **1,7 punti**.
| dataset | TF | barre | flip | flip/barra | flip/giorno feriale | stop in ATR(10) | stop/costo mediano | quota >= 40x |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| EURUSD 2019 (Oanda) | M1 | 334.834 | 11.178 | 3,34% | 43,0 | 3,92 | 3,9 | 0% |
| | M3 | 121.734 | 3.400 | 2,80% | 13,1 | 3,90 | 7,0 | 0% |
| | M5 | 73.983 | 1.896 | 2,57% | 7,3 | 3,90 | 9,6 | 1% |
| | **M15** | 24.838 | 611 | 2,49% | **2,35** | 3,84 | **19,1** | **9%** |
| | **H1** | 6.214 | 147 | 2,49% | **0,57** | 3,77 | **42,3** | **59%** |
| | H4 | 1.606 | 36 | 2,78% | 0,14 | 3,99 | 88,0 | 100% |
| XAUUSD 2019 (Oanda) | M15 / H1 / H4 | 23.609 / 5.917 / 1.576 | 593 / 128 / 33 | 2,55 / 2,28 / 2,61% | 2,28 / 0,49 / 0,13 | 3,85 / 3,91 / 3,97 | 20,5 / 43,2 / 109,5 | 14 / 56 / 100% |
| DAX 2017 (HistData) | M15 / H1 / H4 | 13.895 / 3.523 / 989 | 336 / 84 / 17 | 2,47 / 2,62 / 2,51% | 1,30 / 0,33 / 0,07 | 3,82 / 3,85 / 3,90 | 30,6 / 67,2 / 149,1 | 26 / 94 / 100% |
(M1-M5 di oro e DAX nello script; in tutte e 18 le righe lo stop sta dal lato giusto, 100%.) **Riscontro con la misura di casa sullo stesso Supertrend a M3**: `H4_M3_CONFLUENZA_MISURA` sez. 4 ha stop = 0,60-0,88 ATR H1 e
inversioni = 2,25-2,76% delle chiusure M3 (DAX 12.490/554.094, oro 14.387/637.201 e 40.170/1.656.759, S&P 23.237/841.466) [MISURATO]: stessa grandezza. Il D1 non e' misurabile con un anno (250 barre): 2,5% per barra e' [DERIVATO].
**Limite dichiarato**: sono anni 2017/2019, non il 2026; il costo e' quello BCM di oggi.

### 3.2 Tempo per n >= 150 (si alternano long e short per costruzione: 150 per lato = 300 flip)
Per **cella** (simbolo x TF, due lati insieme), 24h feriali come EURUSD/oro:
| TF | flip/giorno | n >= 150 | n >= 150 PER LATO | setup in 3 mesi (65 giorni feriali) |
|---|---:|---|---|---:|
| M1 (oro) | 41-43 | 3,5-3,7 giorni feriali | ~1,5 settimane | ~2.700 |
| M3 (oro) | 12-13 | ~2,5 settimane | ~5 settimane | ~800 |
| M5 (oro) | 7 | ~1 mese | ~2 mesi | ~450 |
| **M15** | **2,3** | **~2,9-3,0 mesi** (indici tipo DAX: ~5,3) | ~6 mesi | **~150** |
| **H1** | **0,5-0,6** | **~12-14 mesi** (DAX 21) | ~2 anni | **~35** |
| H4 | 0,13-0,14 | ~4 anni | ~8 anni | ~9 |
| D1 | ~0,025 [DERIVATO] | ~23 anni | -- | ~1,6 |
Per **famiglia** (29 simboli: 24 forex come EURUSD, oro, 3 indici come DAX, BTCUSD a 7 giorni) [DERIVATO]:
| TF | setup/giorno feriale | n >= 150 | n >= 150 per lato | in 3 mesi |
|---|---:|---|---|---:|
| M15 | ~66 | ~2,3 giorni | ~5 giorni | ~4.300 |
| H1 | ~16 | ~2 settimane | ~4 settimane | ~1.040 |
| H4 | ~3,9 | ~1,8 mesi | ~3,5 mesi | ~250 |
| D1 | ~0,74 | ~9 mesi | ~19 mesi | ~48 |
**Dichiarazione**: in 3 mesi **nessuna cella simbolo x TF a H1, H4, D1 arriva a n=150; a M15 le celle 24h ci arrivano al limite**. Il merito per cella e' [NON MISURABILE] in questo trimestre; per **famiglia** si'
(M15, H1, H4). I setup dello stesso giorno sono correlati (gambe USD comuni): n = numero di setup, non di indipendenti; il lettore usa il bootstrap a blocchi di GIORNO.

### 3.3 Frontiera di costo: quanti setup sono GIUDICABILI
Stop in ATR ~ 3,8-4,0 di ATR(10) del TF; `stop/costo` cresce con la radice del TF. [MISURATO] 2019/2017, vedi sez. 3.1; [MISURATO] oro 2026 su M3: **72,3x mediano, 94% sopra 40x** (`H4_M3_CONFLUENZA_MISURA` sez. 4; l'oro 2024: 20,3x).
- **M1, M3, M5**: fuori su forex e indici (stop/costo mediano 4-17x). **Oro 2026**: M3 72x, M5 ~93x, **M1 ~42x [DERIVATO: 72,3 x radice(1/3)]**, cioe' dentro (M1 al filo). Per questo l'oro e' l'unico simbolo con M1/M3/M5 nel default.
- **M15**: forex **9%** dentro (EURUSD 2019), indici 26% (DAX 2017), oro 14% (2019; 2026 [DERIVATO] ben piu' alto). **H1**: forex ~59%, oro 56% (2019), DAX 94%. **H4/D1**: tutto dentro.
- **Setup giudicabili in 3 mesi, famiglia FOREX** (24 coppie, proxy EURUSD 2019) [DERIVATO]: M15 ~330, H1 ~525, H4 ~220. Il 2026 forex puo' essere piu' calmo di EURUSD 2019 (ATR piu' basso = quote piu' basse):
  [NON MISURATO]; l'ombra scrive `stop_su_costo` per OGNI setup, quindi dopo il primo giorno lo sappiamo.
- Con le ATR del 2005-2020 (15-22 pip a H1, `EMA200_H4_D1_FOREX28_MISURA`) il rapporto H1 sarebbe ~2 volte piu' alto: l'anno vicino al presente (2019) e' piu' prudente e **e' quello usato**.

### 3.4 H0 e attese, scritte PRIMA dei numeri dell'ombra [DERIVATO, `ombra_sw_h0_e_struttura.py h0`, 600.000 barre per prova, semi fissi]
**H0 (per ogni cella)**: media `R_A_netto` = 0 al netto dei costi; l'esito LORDO sotto H0 e' ~0 (martingala), il netto e' `-costo/R` (-0,02 a H1 forex mediano, -0,05 a M15 forex: per questo la frontiera).
| ipotesi (passeggiata + Supertrend esatto, esito lordo) | media R_A | sd | lato long / short | |
|---|---:|---:|---|---|
| N: passeggiata aleatoria (seme 1 / 2) | -0,005 / -0,000 | 0,926 / 0,922 | -0,013 / +0,003 | **H0** |
| momentum AR(1) +0,05 | **+0,020** | 0,938 | +0,026 / +0,013 | un "vantaggio" vero ma piccolo |
| reversione AR(1) -0,05 | -0,013 | 0,916 | -0,015 / -0,011 | |
| deriva +0,03 sigma/barra (regime) | -0,004 | 0,930 | **+0,146 / -0,155** | il regime gonfia un lato, il pooled sparisce |
Regole B e C sotto H0: B -0,005 / sd 0,923; C -0,008 / sd 0,879 (descrittive).
**Numeri-spia (descrittivi, per riconoscere un errore dello strumento PRIMA di leggere il merito)**: stop in ATR(10) mediana 3,98 (p10-p90 3,58-4,35); vita del setup p10/50/90 = 9 / 26 / 71 barre; prima del flip: stop colpito **14%**,
TP1 39%, TP2 17%, TP3 7%; R per setup: mediana -0,33, p95 +1,90, **59% negativi** (distribuzione asimmetrica). Sui dati veri possono scostarsi (autocorrelazione, code grasse): se escono molto, **si guarda prima il codice, poi il mercato**.
**Banda H0 al 97,5%** con sd 0,926: **n=150 -> +-0,148 R; n=325 -> +-0,101 R; n=400 -> +-0,091 R; n=800 -> +-0,064 R**. Verdetti di casa (come `leggi_ombra_ema200.py`): NON ANCORA MISURATO se n<150 o <20 giorni distinti;
EFFETTO = media > q97,5 del null, >= +0,10 R, IC95 basso > 0 e p x K <= 0,05; CONTRARIO speculare; NULLO = |media| < 0,05 R, dentro la banda, semi-ampiezza IC <= 0,10 R (**n ~330** con questa sd); altrimenti ZONA GRIGIA.
**Banda contro l'ipotesi ALTERNATIVA (classe 178)**: il momentum piu' plausibile (+0,020 R) cade **dentro** la banda di qualunque cella (+-0,10 R a n=330): **a livello di cella l'ombra non lo distingue dal nulla**; la famiglia M15
(n ~330 giudicabili forex, +-0,10; n ~4.300 se tutto dentro, +-0,028) lo vede appena. La deriva di regime sposta un lato di +-0,15 R: **il verdetto e' sul pooled dei due lati**, i lati sono descrittivi (regola dei due lati).
**Attese per cella (quando arrivera' a n >= 150)**: media netta -0,03..+0,02 R (H0 e momentum); verdetto **ZONA GRIGIA o NULLO, mai EFFETTO**; "NON ANCORA MISURATO" per tutte le celle H1+ in questo trimestre. Una cella EFFETTO dopo la correzione per K e'
un **candidato per l'imbuto** (backtest a tick IS/OOS + prova di regime), **mai in campo in automatico**.

### 3.5 Cosa e' GIA' misurato in casa (e cosa NON si puo' prendere in prestito)
- **Stesso segnale, misurato**: `report/H4_M3_CONFLUENZA_MISURA_2026-10-01.md` (event study sull'inversione M3 nel verso di un H4 stabile, la confluenza della dashboard): a 60 minuti **NULLO su 6 celle su 6** (DAX, oro A, oro B, long e short;
  S&P secondario 2 su 2), n 2.638-9.473 per cella; il costo pesa 2-4 volte l'effetto; con lo **stop della dashboard (M3)** P(+1R prima di -1R in 240 min) = **0,491-0,534** e aspettativa netta **-0,035..-0,130 R**;
  frequenza ALLINEATO 2,8/giorno (DAX) e 4,0-4,3 (oro). **Non raggiunti**: Nasdaq, Dow, feed BCM, forex della griglia, gestione 40/30/30, **ogni TF diverso da M3 come TF del segnale**. Non e' un certificato di morte (mancano PF e gestione).
- **NON e' lo stesso segnale (da non confondere)**: la famiglia `ABTG_SuperWave` (770501/770511 Dow H1, 770512 DAX H4) e' **incrocio EMA14 x EMA200 confermato dal Supertrend** con trailing sul Supertrend: Dow H1 PF 1,52 su 227 deal,
  DAX H4 1,28 su 56 (`REGISTRO_TEST`). **Quei numeri non appartengono al flip della dashboard** e non si citano come misura dell'ombra. `ABTG_SuperWave_EA.mq5` (H4 + flip M3, stop sul Supertrend con floor 1 ATR, TP price action, BE dopo TP1)
  non ha un round proprio nel registro che io abbia trovato [NON MISURATO].
- **Vicino, non uguale**: `SUPERTREND_IL_CERTIFICATO_2026-09-22` ha misurato il flip del Supertrend **classico** (moltiplicatore 2,0, ATR di Wilder, stop-and-reverse) su H1/H4 di oro, DAX, S&P, Nikkei: PF netto 0,905-1,089, **0 celle su 8 >= 1,10**.
- Certificato di morte (CLAUDE.md 09/09): **nulla di questo archivia il flip della dashboard**: mancano PF, gestione dell'uscita, simboli gemelli (24 forex), TF. Il verdetto di oggi e' **NON ANCORA MISURATO** sui TF e simboli della dashboard.

## 4. RISORSE sul VPS e disegno

### 4.1 Disegno leggero (zero handle)
- **Nessun `iMA`, `iATR`, `iCustom`, `IndicatorCreate`**: il Supertrend e' `SW_STCore` copiato **testualmente** (nessun `#include`, come l'ombra EMA200). Test di accettazione: la riga di grep dell'ombra EMA200 (zero chiamate di trading, zero `#include`, zero
  magic, zero `GlobalVariable*`) **piu'** `iMA|iATR|iCustom|IndicatorCreate|IndicatorRelease` = 0.
- **Calcolo senza stato**: a barra chiusa nuova di una cella (`iTime(sym,tf,1)` cambiato) `CopyRates(sym, tf, 1, 1000, ...)`, `SW_STCore` sulle 1000 barre, come `UpdateSlot` della dashboard -> **identica per costruzione** e senza stato da persistere per il segnale.
  Per i setup vivi servono solo i livelli e il puntatore dei tick (sez. 2.6).
- **Dati**: 1000 barre chiuse per cella = M15 ~10 giorni, H1 ~6 settimane, H4 ~6 mesi, D1 ~4 anni (i D1 con meno di 311 barre: nessun setup, `n/d`). Array di lavoro 8 x 1000 double = 64 KB, riusati.
- **Tick**: con questa regola ogni cella ha un setup vivo, quindi i **29 simboli** hanno tick da leggere sempre (l'ombra EMA200 li legge solo con un setup aperto): `CopyTicksRange` una volta al secondo per simbolo, tetto 150 ms per fase come l'ombra EMA200.

### 4.2 Consumi [STIMA, NON MISURATO: va misurato col battito nella prima ora]
| voce | stima | nota |
|---|---|---|
| CPU a regime | < 1% di un core | ~5.900 rivalutazioni di cella al giorno (M15..D1 su 29 + oro M1/M3/M5) x ~60 us + ~29 `CopyTicksRange`/s; tetto rigido 150 ms per fase |
| RAM dell'EA | < 10 MB | array di lavoro, stato, righe in coda |
| RAM nel terminale (serie) | **<= ~120 MB sul 50503392** se condivide le serie M15/H1/H4/D1 gia' caricate dall'ombra EMA200 (22 simboli su 29 in comune; marginali 7 simboli x 4 TF + 3 serie oro); **~300-460 MB su un terminale vuoto** | le serie sono per terminale e simbolo/TF, non per indicatore [NON VERIFICATO sul nostro MT5]; i 420 handle dell'ombra EMA200 qui non ci sono |
| M1/M3/M5 su tutti i simboli | **+300-500 MB** | e' il motivo (oltre al costo) per cui sono spenti di default |
| Disco | ~150 setup/giorno ~100 KB/giorno (~3 MB/mese); stato ~40-60 KB riscritto ogni 15 s | |
Numeri misurati del VPS (`OMBRA_ATTACCO_A_MANO_2026-10-05.md`): RAM **disponibile 2792 MB su 12.282** (05/10 14:29), **1853 MB** alle 03:30; working set del `terminal64` del 50503392 **1978 MB**; via libera dell'ombra EMA200 = disponibile >= 1800 MB e `MaxBars=100000`.
**Soglie proposte (da riconfermare con numeri freschi il giorno dell'attacco, come per l'EMA200)**: working set del terminale giallo +100 MB / rosso +250 MB rispetto al "prima" misurato con l'ombra EMA200 gia' a regime; RAM disponibile rossa sotto
max(1024 MB; prima - 350 MB); CPU del `terminal64` rossa oltre +2,0 punti percentuali per 5 minuti dal minuto 10; `giro_ultimo_ms` > 1000 in due battiti di fila. Rosso = si chiude **solo** il grafico dell'ombra. Via libera: disponibile >= 1800 MB e `MaxBars` <= 100000.

### 4.3 EA unico "ombra multi" (EMA200 + SuperWave + altre dashboard) o separato? **SEPARATO, con contratto comune.**
| criterio | un EA unico | un EA per dashboard |
|---|---|---|
| RAM | risparmio ~0: le serie sono del terminale, qui non ci sono handle; si risparmia un EA da <10 MB | idem + <10 MB |
| CPU | un solo giro di tick per simbolo invece di due: risparmio < 1% di un core [STIMA] | due timer, due letture degli stessi tick |
| debito di verifica | **riapre l'ombra EMA200**: 4 letture indipendenti, v1.03, oggi attaccata; ogni modifica riparte dal cancello | **zero**: il file gia' verificato non si tocca (vincolo di questo incarico) |
| dominio di guasto | un array fuori limite (la classe gia' pagata in v1.03) ferma TUTTE le ombre | si ferma una sola |
| prossima dashboard | tocca il file unico, rischio di regressione su motori che stanno accumulando dati | file nuovo, nessun rischio sugli altri |
| formato dello stato | va versionato per non perdere i setup aperti | indipendente |
**Quando riconsiderare**: >= 4 ombre vive e il lavoro di tick duplicato supera ~3 punti percentuali, oppure la RAM del terminale oltre il rosso con due ombre. Allora si fa un EA unico **con prova di parita'**: stessa
finestra, stessi input, i CSV delle due strade devono coincidere riga per riga prima di spegnere le vecchie.
**Contratto comune (da tenere uguale in ogni ombra, e' quello che rende la fusione meccanica)**: segnale copiato testualmente dal sorgente con **prova di identita'** (come `identita` qui); regole scritte prima; tre file `esiti/trigger/imbuto` con le prime colonne
`id; barra_tf; simbolo; tf; lato`; battito e stato atomico uguali; uscita al prezzo del tick; costo di casa con `stop_su_costo`; lettore con le parole di casa; H0 e frequenza scritte prima; soglie di RAM scritte prima.
(La spec dell'ombra ForzaFX e' in corso da un altro agente: commit `fde61ac1`/`96b773db`; non toccata.)

## 5. Dove si attacca e come si legge

### 5.1 Dove (decisione di Claudio)
| | demo `50503392` (`BCM Markets MT5 Terminal`, 26 sedie, ombra EMA200 gia' attaccata) | 100k `50504263` (`... MT5 Terminal -V3`, 2 sedie) |
|---|---|---|
| RAM marginale | <= ~120 MB (serie condivise) [STIMA] | ~300-460 MB (serie da zero) [STIMA] |
| dominio di guasto | lo stesso delle 26 sedie e dell'altra ombra | separato dalle sedie vive del piccolo |
| pool RAM del VPS | stesso (12.282 MB, 2792 disponibili): **separare il processo non crea RAM** | stesso |
| note | working set gia' 1978 MB; due ombre nello stesso processo | partenza da zero, nessun precedente misurato |
**Vincolo (regola di Claudio del 05/10, non un consiglio nostro)**: sul **50503392** nessuna seconda ombra **prima di 48 ore** dall'attacco dell'ombra EMA200; poi, comunque, solo dopo una
**misura nuova** di RAM/CPU (working set stabile, cosi' il "prima" e' misurato, non stimato) e la **firma di Claudio sul codice**. Se la RAM disponibile e' sotto 1800 MB, o il working set dell'ombra EMA200 ha superato il giallo,
l'alternativa e' il 100k `50504263` solo se disponibile >= ~2300 MB: **la sceglie Claudio**, e il pool RAM del VPS e' lo stesso (spostare non crea RAM).
**Cosa NON si tocca in nessun caso**: le 26 sedie e il grafico dell'ombra EMA200 sul `50503392`; il reale `10105439` (`C:\BCM_Reale`); FTMO `1514806751` (`C:\FTMO`); il banco `50504400` (`C:\MT5_Backtest`, spento);
le cartelle Pepperstone e Tickmill; Algo Trading; nessun preset ne' Guardian. 🔴 Ogni istruzione manuale dichiara conto e cartella (`50503392` = `BCM Markets MT5 Terminal`, `50504263` = `... MT5 Terminal -V3`; **mai** `10105439` `C:\BCM_Reale`,
**mai** FTMO `1514806751` `C:\FTMO`), con la riga di sola lettura che stampa PID + titolo + cartella. Grafico NUOVO senza EA; Algo Trading non serve e non si tocca; per fermarla si chiude solo il suo grafico.

### 5.2 Come si legge: `backtest_pipeline/leggi_ombra_superwave.py` (da scrivere; fork del nucleo di `leggi_ombra_ema200.py`)
Stesso motore statistico (bootstrap a blocchi di giorno, null centrato, Bonferroni via `nb_per_k`, `N_MIN=150`, `GIORNI_MIN=20`), con queste differenze dichiarate:
1. colonne e classi (`FOREX` 24, `INDICI` 3, `METALLI`, `CRIPTO`), TF M1..D1; 2. **verdetto sulla A in R netto di commissione**; B e C in una tabella a parte, mai nel verdetto;
3. tabelle: cella simbolo x TF; **famiglia per TF**; classe x TF; per `htf_conc`/`confl_dash`; per lato (descrittiva); sotto-frontiera (descrittiva); **frequenza** (giorni a 150, flag `OLTRE 3 MESI`); quadratura dell'imbuto; trigger per stato; fonte dei prezzi;
4. tabella **numeri-spia** (sez. 3.4) con avviso ben visibile se escono dal campo; 5. **parita' con la dashboard** (`sw_audit`: rifa' `st_full`, tolleranza 1e-8 relativa, deve coincidere su direzione, ora dell'inversione, ingresso, stop);
6. parole di verdetto di casa **NULLO / ZONA GRIGIA / EFFETTO / CONTRARIO / NON ANCORA MISURATO**, con **"MERITO: NON ANCORA MISURATO"** accanto a ogni riga con n < 150; il **RISCHIO (DD in R)** si scrive sempre, a qualunque n.
Autotest del lettore come l'altro (T1: intestazioni == EA, con mutazione; contro-esempi: random walk senza falsi EFFETTO con K=119 celle; effetto piantato che deve uscire EFFETTO; C artefatto-da-livello che il lettore NON deve premiare).
**Cronologia di lettura**: giorno 1-2 numeri-spia e parita'; ~2 settimane tabella di frequenza vera (sostituisce le stime); ~4 settimane famiglia H1; 3 mesi referto: rischio, frequenza, merito per famiglia.

## 6. NON MISURATO e domande a Claudio

### 6.1 Cosa e' NON MISURATO (elenco)
1. **Tutto il merito** del flip a R dentro la dashboard sui TF e sui simboli della griglia (24 forex, Nasdaq, Dow, BTC, oro a H1+): zero numeri (il solo misurato e' M3 su DAX/oro/S&P, orizzonte 60-240 minuti, NULLO).
2. PF, DD e gestione a quote 40/30/30 su dati veri; le tre regole A/B/C sui dati veri (qui solo H0 su passeggiata aleatoria).
3. Costi di oggi: lo spread BCM di 23 simboli su 29 (misurati solo EURUSD, GBPUSD, USDJPY, XAUUSD, DAX, NAS in una settimana), la commissione BTCUSD, il swap, lo slippage; l'ATR del 2026 su forex e indici (la frontiera sopra e' 2017/2019).
4. La **sd reale** per setup (0,926 e' di passeggiata aleatoria; code grasse e volatilita' a grappoli la alzano) e quindi il numero reale per un NULLO.
5. La frequenza dei flip su D1 (stimata) e sul feed BCM in generale; l'ingresso **discrezionale** (Pulsanti a mano, ritardo umano, ingresso 1-3 barre dopo).
6. RAM e CPU reali dell'EA e delle serie condivise [NON VERIFICATO]; il comportamento di `CopyTicksRange` su 29 simboli in continuo (attese fino a 45 s citate dalla documentazione).
7. Un solo regime nel trimestre (Emendamento C della finestra non soddisfatto); un solo broker.
8. Quale versione della dashboard gira sul grafico di Claudio: la v4.00 ricevuta usa ATR di Wilder su 90 barre nella griglia e **diverge dal grafico nel 4,4-7,8% delle barre** (`docs/CHECKLIST_SUPERWAVE_DASHBOARD`, difetto 5); l'ombra segue la **v4.1**.
9. Nessun round e' stato lanciato: tutti i numeri di questo documento sono struttura o H0, non merito.

### 6.2 Cosa deve dire Claudio (decisioni)
1. **Lista simboli**: i 29 di default (cosi' com'e' nel codice) o quelli del TUO grafico? Aggiungo `U30USD` come extra? (non e' nella lista della dashboard).
2. **TF**: M15, H1, H4, D1 su tutti + M1/M3/M5 solo sull'oro (consiglio), oppure tutti e 7 su tutti (+300-500 MB di serie [STIMA], quasi tutto sotto frontiera)?
3. **Regola d'uscita primaria A** (stop fisso, chiusura al flip opposto) e B/C solo descrittive: ok? E il decisore di costo = **spread + commissione** (la convenzione corretta l'11/09)?
4. **Dove**: `50503392` (`BCM Markets MT5 Terminal`), non prima delle 48 ore della sua regola del 05/10 e di una misura nuova di RAM/CPU, oppure `50504263` (`... MT5 Terminal -V3`)?
   E la **firma sul codice** prima di compilare (sez. 7).
5. **Priorita'**: e' ponteggio a rendimento atteso basso (sez. 0, punto 10). Si costruisce adesso (il codice e' ~1 giornata piu' cancelli) o dopo la sedia che oggi pesa di piu' per il 1° ottobre? Decide lui.
6. Quale **versione** della dashboard gira sul suo grafico (4.00 ricevuta o 4.1)?

## 7. Cosa serve dal cancello e prossimi passi (nulla e' stato fatto sul codice)
- **`controllo-preventivo` (Opus)** su questo documento prima di qualunque uscita: identita' del segnale (rilegge `identita`), coerenza delle regole con il sorgente, numeri della sez. 3 (rilancia `h0` e `struttura`, stessi risultati).
- Poi, **solo dopo le risposte di Claudio**: (1) `ABTG_SuperWave_Ombra.mq5` (ASCII, zero handle, zero `#include`, uscita al prezzo del tick), (2) lettore + autotest, (3) passata MQL5 (`mql5-ea-developer`: `CopyTicksRange`, `CopyRates` a serie non sincronizzata,
  `FileMove`), (4) compilazione **solo dopo la firma di Claudio sul codice**, (5) riga d'installazione con le soglie sopra, **solo dopo le 48 ore e una misura nuova di RAM/CPU**
  (la riga porta in testa il bersaglio: finestra PowerShell sul VPS, terminale `50503392`, e cosa non tocca), (6) parita' con `sw_audit`.
- **Controlli gia' fatti qui**: `identita` (7 funzioni identiche + mutante visto); `h0` riprodotto 2 volte con gli stessi numeri; `struttura` riprodotto con `st_full` (20 flip in meno dei 11.198 della mia prima versione numpy: la
  versione con lo specchio collaudato e' quella citata); ASCII puro dello script; nessun file `.mq5`, `.ps1` ne' preset toccato; ombra EMA200 e righe DUKA/dukascopy non toccate.
