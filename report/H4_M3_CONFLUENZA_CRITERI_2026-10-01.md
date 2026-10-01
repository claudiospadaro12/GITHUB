# CONFLUENZA H4 / M3 del Supertrend misurata come FENOMENO: CRITERI CONGELATI (01/10/2026)

> **Scritto, committato e pushato PRIMA di caricare un solo dato vero per questa misura.**
> Mandato di Claudio, 01/10/2026 sera: _"come ti sembra questa dashboard? ci sta la correlazione H4 ed M3 e poi
> ingresso in M3? puo' avere un senso?"_. La dashboard e' `mql5/Indicators/ABTG_SuperWave_Dashboard_v41.mq5`
> (sola visione), confluenza **modo 1** (default v4.1).
> Strumento: `backtest_pipeline/h4_m3_confluenza.py`. Referto: `report/H4_M3_CONFLUENZA_MISURA_2026-10-01.md`.
> Archivio: `backtest_pipeline/risultati_archivio/H4_M3_2026-10-01/`.
> **Non e' un backtest**: niente PF, niente equity, niente gestione TP1/TP2/TP3 a quote. E' un **event study**:
> che cosa fa il prezzo DOPO l'evento, confrontato con istanti di controllo. Non tocca EA, preset, sedie,
> conti, terminali. Zero Strategy Tester, zero VPS, nessuna riga di lancio.

---

## 0. La domanda, tradotta in una misura

"Ha senso" si scompone in TRE domande, ognuna con il suo confronto:
- **D1 (il timing M3 aggiunge qualcosa alla direzione H4?)**: dopo un'inversione M3 nel verso di un H4 stabile, il
  prezzo va nel verso del segnale **piu'** di quanto ci vada in un istante qualunque in cui l'H4 punta nello
  stesso verso? Confronto **ALLINEATO contro CASUALE (controllo B)**. E' la domanda che DECIDE.
- **D2 (il filtro H4 aggiunge qualcosa all'inversione M3?)**: un'inversione M3 nel verso dell'H4 rende piu'
  di un'inversione M3 contro l'H4? Confronto **ALLINEATO contro CONTRO (controllo A)**. Descrittiva, con IC.
- **D3 (a quale costo)**: lo stop che la dashboard disegna (Supertrend M3) e le due alternative stanno sopra o
  sotto la frontiera di casa `stop >= 40 x spread`? E l'aspettativa in R, al netto dello spread, e' positiva?

---

## 1. Dati, feed, fuso, finestre (dichiarati prima)

Si riusano i dataset e il caricatore di `backtest_pipeline/ema200_rimbalzo.py` (stesse funzioni, stessa cache
gia' scaricata il 01/10, nessuna concatenazione di feed):

| sigla | simbolo casa | feed | finestra | fuso del file | ruolo |
|---|---|---|---|---|---|
| DAX | D30EUR (GER40) | HistData `GRXEUR` (mirror FutureSharks) | 2010-11-15 -> 2018-12-28 | ora di New York | **primario** |
| XAU_A | XAUUSD | Oanda `XAU_USD` (mirror FutureSharks) | 2006-03-19 -> 2020-05-14 | UTC | **primario** (gemello di feed) |
| XAU_B | XAUUSD | HistData in repo, gia' in UTC | 2021-01-03 -> 2026-09-18 | UTC | **primario** (gemello di feed) |
| SPX | SPXUSD (US500) | HistData `SPXUSD` (mirror FutureSharks) | 2010-11-14 -> 2018-12-31 | ora di New York | **SECONDARIO** |
| NASUSD, U30USD | -- | non raggiungibili da questa sessione (Nasdaq solo sul PC di backtest; Dow: nessun feed esterno) | -- | -- | **NON MISURATI** |

- Il mandato cita "DAX 2013-2018": il file del mirror copre **2010-11 -> 2018-12** e si usa **tutto**, dichiarato.
- I due feed dell'oro restano separati (regola R80): sono gemelli di FEED, contano come **un solo simbolo**.
- **Orologio**: tutto in UTC, poi barre su **UTC+1 fisso** (= orologio BCM di oggi, `report/OROLOGIO_BCM_2026-09-24.md`),
  bordi a multipli del TF dalla mezzanotte UTC+1. M3 e H1 NON dipendono da uno spostamento di ore intere;
  **H4 si'**: e' il TF su cui il cancello d'orologio morde.
- **Cancello G-OROLOGIO**, bloccante per simbolo, IDENTICO a quello della misura del rimbalzo
  (`cancello_orologio` di `ema200_rimbalzo.py`, criteri EMA200 sez. 1): picco del minuto UTC d'inverno su
  un'ancora attesa e picco d'estate esattamente 60 minuti prima. Ancore: DAX 07:00/08:00/13:30/14:30, oro
  13:30/15:00. **SPX**: 13:30/14:30 **piu' 15:00 UTC** (dato USA delle 10:00 NY), ancora gia' riconosciuta il
  01/10 (classe 1036): lo dichiaro QUI, prima dei numeri, e per questo SPX resta **lettura SECONDARIA** (non
  conta fra i gemelli del verdetto). Se un cancello fallisce: quel simbolo esce senza numeri.
- **Regime per anno** (come EMA200): rendimento close-to-close dell'anno solare, **TORO >= +10%**,
  **ORSO <= -5%**, **LATERALE** in mezzo; l'anno e' quello dell'evento.
- **Variante d'orologio FTMO** (DESCRITTIVA, non decide): le stesse misure con le barre H4 spostate di +60 min
  (H4 su UTC+2 fisso, ~ FTMO d'inverno). Serve a dire se la confluenza dipende da dove cadono i bordi H4.

---

## 2. Il Supertrend: LO STESSO della v4.1

- Implementazione: **`SW_STCore`** della v4.1 (righe 253-296 del `.mq5` al commit `de3c8a7b`), il cui specchio
  Python `py_stcore` in `backtest_pipeline/collaudo_superwave_v41.py` e' stato collaudato **bit per bit** contro
  le funzioni pure compilate in C++. ATR = **media SEMPLICE** degli ultimi `per` True Range
  (`max(h_k, c_{k-1}) - min(l_k, c_{k-1})`), banda finale classica, direzione iniziale `c >= mid`.
- Parametri della dashboard: **ATR 10, moltiplicatore 3,5**, su **M3** (evento) e **H4** (filtro).
- Lo strumento usa una versione veloce (ATR vettoriale sommato **nello stesso ordine**, ricorsione delle
  bande identica) che l'autotest deve dimostrare **identica al bit** a `py_stcore` (sez. 9).
- **Finestra della dashboard**: la v4.1 calcola su **1000 barre chiuse**; qui si calcola sullo storico intero.
  Il collaudo v4.1 ha misurato che la finestra aggancia lo storico entro <= 140 barre a 3,5 (240 a 5,0).
  Lo strumento lo **rimisura sui dati veri**: su un campione di eventi ricalcola M3 e H4 su una finestra di
  1000 barre che finisce sulla barra dell'evento e conta le discordanze di direzione e di "barre dall'inversione"
  (atteso: 0; se > 1% degli eventi, si scrive e si dice quali numeri cambiano).
- **Zona affidabile**: nessun evento prima della **300a barra** di M3, di H1 **e** di H4 di ogni dataset
  (`SW_TRUST_BARS = 300`).

---

## 3. Definizioni operative (congelate)

- **Barre**: M3, H1, H4 costruite dalle M1 presenti (nessuna barra vuota, come MT5).
- **Evento** = barra M3 `k` CHIUSA con `dir3[k] != dir3[k-1]` (inversione del Supertrend 3,5 su M3, `bsM3 = 0`).
  - istante dell'evento `tE` = inizio della barra M3 + 3 minuti (la chiusura);
  - **prezzo d'ingresso** = close della barra di inversione (= "ingresso FISSO" del pannello della dashboard);
  - verso del segnale `s = dir3[k]` (+1 BUY, -1 SELL).
- **Stato H4** all'evento: l'**ultima barra H4 CHIUSA** = quella con `inizio + 240 <= tE`. `dH4` = sua direzione,
  `bsH4` = barre H4 dall'ultima inversione (0 = inversione proprio su quella barra).
  **H4 stabile** = `bsH4 >= 3` (= `InpConflH4Stable = 3` della v4.1: `SW_Confl` rifiuta `bsH4 < 3`).
- **ATR di normalizzazione** `A` = ATR(14) di **H1** (media semplice del TR, come `atr()` di `ema200_rimbalzo.py`)
  sull'**ultima barra H1 CHIUSA** (`inizio + 60 <= tE`). Nessun look-ahead: tutto e' noto a `tE`.
- **Gruppi** (lato = **long** se il segnale e' BUY, **short** se SELL; i due lati sempre separati):
  - **ALLINEATO**: evento con H4 stabile e `dH4 == s` (= `SW_Confl(1, dH4, bsH4, s, 0, 3, 3) != 0`: la dashboard
    si accende). Segno del rendimento: `s`.
  - **CONTRO (controllo A)**: evento con H4 stabile e `dH4 == -s`. Segno: `s` (il verso dell'inversione M3).
  - **H4 INSTABILE**: evento con `bsH4 < 3`. Solo descrittivo.
  - **CASUALE (controllo B)**: chiusure di barra M3 qualunque (inversione o no) nella zona affidabile, con H4
    stabile e `dH4` = lato; segno: `dH4`. **Stesso numero** di ALLINEATO per lato, **stessa distribuzione
    oraria** (ora UTC+1) e, in piu' rispetto al mandato, **stesso mese di calendario**: per ogni evento
    ALLINEATO si estrae un istante a caso con la stessa coppia (anno-mese, ora); se la coppia non ha candidati
    si ripiega su (anno, ora), poi su (ora). Il mese serve contro il contro-esempio "trend persistente": un
    controllo sparso su 8 anni non avrebbe la deriva del mese in cui l'evento accade.
    **20 estrazioni indipendenti** (semi fissi), ciascuna dello stesso numero: riferimento = media sulle 20
    estrazioni messe insieme; banda = [p2,5; p97,5] delle 20 medie. Deviazione dichiarata dal "stesso
    numero": 20 volte lo stesso numero, perche' riduce il rumore del riferimento senza cambiarne la
    distribuzione.
  - **CASUALE-GIORNO (B', descrittivo)**: come B ma estratto nello **stesso giorno di calendario** dell'evento
    (qualunque ora, H4 stabile nello stesso verso): isola il valore del timing DENTRO la giornata.
  - **PLACEBO (controllo C)**: tutto il sistema rifatto (M3 **e** H4) con Supertrend **(ATR 10, mult 2,5)**,
    **(ATR 10, mult 3,0)**, **(ATR 14, mult 3,5)**, ognuno con i suoi ALLINEATO e il suo CASUALE.

---

## 4. Esiti (risolti sulle M1, a partire dal primo minuto con `t >= tE`)

Orizzonti **H = 30, 60, 120, 240 minuti** di orologio. Per ogni evento e orizzonte, sulle M1 in `[tE, tE + H)`:
- **R_H** = `s x (close dell'ultima M1 della finestra - ingresso) / A` (in ATR(14) di H1), e lo stesso in **punti**;
- **MFE_H** = escursione favorevole massima, **MAE_H** = avversa massima (positiva), in ATR di H1;
- **validita'**: la finestra deve contenere almeno **H/2** minuti presenti, altrimenti l'evento e' escluso a
  quell'orizzonte (mercato chiuso, fine settimana) e si conta.
- **Costo** (sottratto, non dentro le probabilita'): uno **spread per giro completo**, in prezzo:
  - DAX: **mediana dello spread per ORA SERVER BCM** (= UTC+1) dai tick BCM 2024-09 -> 2026-06,
    `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_D30EUR.csv` (ora dell'evento -> riga);
    riferimento accanto: 1,7676 pt (mediana pesata di sessione, `sonda_supertrend_segnali.py`). Limite
    dichiarato: lo spread e' quello BCM di oggi, il feed e' HistData 2010-18.
  - Oro: **0,2003 $ per giro completo** (costante, classe 587; nessuno spread orario dell'oro in repo).
    Sensibilita' accanto: **0,45 $** (`XAUUSD` FTMO, una sola giornata, `report/SPREAD_APERTURA_FTMO_2026-09-21.md`, SOTTILE).
  - SPX: **[NON MISURATO]** sul nostro broker; sensibilita' a **0,60 punti** (`US500.cash` FTMO, una giornata, SOTTILE).
  - Commissioni: gli indici e l'oro qui non ne portano; i **2,21 EUR/lotto/lato del forex** si citano solo come
    riferimento e non entrano in nessun numero.
  - `R_H netto = R_H - spread/A`.
- **Stop ipotetici** (distanza D in prezzo, fissata a `tE`), tre varianti:
  - **(a) ST M3**: D = |ingresso - valore del Supertrend M3 3,5 sulla barra di inversione| (= lo stop del pannello
    della dashboard). Se lo stop e' dal lato sbagliato (`SW_SetupOk` falso) l'evento esce dalla variante (contato).
  - **(b) 1 ATR H1**: D = A.
  - **(c) ST H4**: D = |ingresso - valore del Supertrend H4 3,5 sull'ultima barra H4 chiusa| (stop largo, ingresso
    M3 per il timing: lo schema top-down classico). Se il prezzo d'ingresso e' gia' oltre lo stop: escluso, contato.
  - per ciascuna: **D / spread** (mediana, p10, p90, quota di eventi con **D >= 40 x spread**);
  - **primo passaggio** entro 240 minuti sulle M1: **+1R prima di -1R** (TP), **-1R prima di +1R** (SL), **AMB**
    (stesso minuto: contato come SL nella variante conservativa), **TO** (nessuno dei due: chiuso a mercato a 240 min).
    `P_1R = TP / (TP + SL)` con IC di Wilson; null analitico 0,500.
  - **aspettativa in R per operazione** = media di (+1 se TP, -1 se SL o AMB, R di chiusura a 240 min se TO),
    **lorda** e **netta** (meno spread/D). Per (c) quasi tutto sara' TO a 240 minuti: dichiarato, non e' la
    gestione top-down completa (non coperta).
  - Controllo B per gli stop: (b) definito ovunque; (a) ogni istante B riceve la D/A dell'evento ALLINEATO con cui
    e' appaiato; (c) dal Supertrend H4 vero all'istante B.

---

## 5. La cella che DECIDE (unica, congelata qui)

Per ogni **dataset x lato**: metrica **R_60 lordo, media**, in ATR(14) di H1.
- **effetto** = `media(ALLINEATO) - media(CASUALE B, 20 estrazioni insieme)`.
- **IC 95%** dell'effetto: **bootstrap a blocchi di giorni** (giorno di calendario UTC+1; 2.000 ricampionamenti;
  si ricampionano i giorni e si prendono tutti gli eventi ALLINEATO e tutti gli istanti B di quei giorni).
  Gli eventi dello stesso giorno sono **dipendenti** (finestre di 60-240 minuti che si sovrappongono,
  volatilita' a grappoli): il blocco-giorno ne tiene conto dentro la giornata, **non** fra giorni consecutivi
  (limite dichiarato).
- **Verdetto della cella**:
  - **n < 150** (eventi ALLINEATO validi a 60 minuti) -> **NON ANCORA MISURATO** (merito sospeso);
  - **EFFETTO**: effetto **>= +0,05** **e** estremo basso dell'IC **> 0** **e** media ALLINEATO **sopra il p97,5**
    delle 20 medie B;
  - **CONTRARIO**: specchio (<= -0,05, estremo alto < 0, sotto il p2,5);
  - **NULLO**: |effetto| **< 0,02** **e** IC interamente dentro **[-0,05; +0,05]**;
  - altrimenti **ZONA GRIGIA** (si dice di quanto e perche').
- **Perche' 0,05 ATR di H1**: e' **circa uno spread** (DAX: 1,77 pt su un ATR H1 di ~33 pt = 0,053; oro B 0,036;
  oro A 0,068 [DERIVATO dagli ATR mediani misurati il 01/10 nel referto EMA200 sez. 7]). Un timing che vale meno
  di uno spread non paga l'ingresso.

### 5.1 Verdetto sul FENOMENO ("la confluenza H4/M3 ha contenuto")
- **CON CONTENUTO** solo se EFFETTO su **DAX e oro** (l'oro conta se EFFETTO su **entrambi i feed** con n >= 150),
  **su tutti e due i lati**, con segno concorde in **ogni classe di regime con n >= 150**, **e** l'altopiano:
  almeno **2 dei 3 placebo** con effetto dello stesso segno **>= +0,025** (regola di casa: centro dell'altopiano,
  mai il picco; un 3,5 che funziona da solo e' un picco).
- **SENZA CONTENUTO (dentro il null)** se NULLO su **tutte** le celle con n >= 150, con almeno 2 simboli misurati.
- altrimenti **NON ANCORA MISURATO**, con l'elenco di cosa manca. SPX secondario non entra nel conteggio dei
  gemelli; si riporta accanto.
- Le parole **"morto"** e **"vero"** non si usano: questa e' una misura del fenomeno, **non un certificato di
  morte** (mancano PF, gestione dell'uscita, TP a quote). Non archivia nessun candidato.

### 5.2 Letture descrittive (non decidono, si riportano tutte)
- D2: `ALLINEATO - CONTRO` a 60 minuti, con IC a blocchi di giorni.
- Tutti gli orizzonti 30/120/240, MFE/MAE, punti, netto di costo, B' (stesso giorno), placebo, H4 instabile,
  regimi, fasce orarie (notte 22-07, giorno 08-16, sera 17-21, ora UTC+1), variante d'orologio FTMO.
- **Frequenza**: eventi ALLINEATO per giorno di mercato, per lato (la frequenza e' il requisito principale del
  1 ottobre: CLAUDE.md).

---

## 6. Bande contro le ipotesi ALTERNATIVE (classe 178), scritte prima

Tre numeri insieme: **ALL** = media ALLINEATO, **B** = media CASUALE, **CON** = media CONTRO (R_60, ATR H1).

| ipotesi | che cosa produce | come la misura la separa |
|---|---|---|
| **N (nulla: passeggiata casuale)** | ALL ~ B ~ CON ~ 0 (entro +/-0,02) | NULLO; l'autotest su random walk lo deve dare |
| **A1 (Claudio ha ragione: il timing M3 nel verso H4 vale)** | ALL - B **>= +0,05**, ALL - CON > 0 | EFFETTO |
| **A2 (vale solo la direzione H4 = trend del giorno/mese)** | **B > 0** e ALL ~ B (effetto ~ 0) | NULLO/ZONA GRIGIA sulla cella che decide, ma **B** e **ALL** positivi: si scrive "e' l'H4, non l'M3". L'autotest con deriva costante deve dare B > 0 e NON EFFETTO |
| **A3 (e' momentum M3, l'H4 non c'entra)** | ALL ~ CON > B | EFFETTO contro B ma ALL - CON ~ 0: si scrive "e' l'inversione M3, non la confluenza". Autotest dedicato |
| **A4 (l'inversione M3 arriva a fine corsa: ritracciamento)** | ALL < B, CON < B | CONTRARIO |

**Attese dichiarate (prima dei numeri, con il perche')**:
- **E1**: B entro +/-0,02 su tutte le celle (a 60 minuti la deriva di mese/H4 e' piccola rispetto all'ATR di H1).
- **E2**: effetto (ALL - B) fra **-0,04 e +0,02**, segno negativo piu' probabile sul DAX: l'inversione del Supertrend
  arriva DOPO un movimento di ~3,5 ATR(M3), e sugli indici a pochi minuti prevale un leggero ritorno; nella misura
  EMA200 i "minuti violenti" all'arrivo erano il 9-23% a M5. Verdetti attesi: NULLO o ZONA GRIGIA, nessun EFFETTO.
- **E3**: |ALL - CON| < 0,03 (a 60 minuti il filtro H4 aggiunge poco).
- **E4 (costo)**: stop (a) ST M3 / spread: **mediana 10-25x sul DAX**, 15-35x oro B, 8-20x oro A; **meno del 20%**
  degli eventi sopra 40x. Stop (b) 1 ATR H1: mediana ~19x DAX, ~15x oro A, ~28x oro B (dagli ATR del 01/10):
  sotto 40x. Stop (c) ST H4: mediana **sopra 40x**. La derivazione del mandato (pannello della dashboard sul Dow
  M3 ~8,6x per radice del tempo) e' un [DERIVATO]: qui si MISURA.
- **E5**: P_1R con stop (a) fra **0,44 e 0,51**; aspettativa netta in R **negativa** (lo spread pesa 1/10-1/20 di R).
- **E6 (frequenza)**: 2-6 eventi ALLINEATO al giorno per simbolo, sommando i due lati.
- Se l'effetto esce pulito (EFFETTO su DAX e oro, due lati, regimi, altopiano): **e' un risultato vero e si scrive
  come tale**.

---

## 7. Contro-esempi: cosa farebbe sembrare vero l'effetto SENZA esserlo, e come e' coperto

| contro-esempio | che cosa produce | copertura |
|---|---|---|
| **Trend persistente / la direzione H4 e' la direzione del giorno** | ALL > 0 per pura deriva | controllo B appaiato su (mese, ora) e B' sullo stesso giorno; autotest con deriva costante: B > 0 e NON EFFETTO |
| **Volatilita' per ora del giorno** | eventi concentrati nelle ore mosse: R e costo diversi | normalizzazione per ATR(14) H1 dell'istante; B con la stessa distribuzione oraria; autotest con volatilita' oraria fortemente stagionale: nessun falso positivo |
| **Momentum M3 senza H4** | ALL > B ma per l'inversione e non per la confluenza | controllo A (CONTRO) e autotest A3 |
| **Look-ahead H4/H1** (usare la barra in formazione) | deriva finta nel verso H4, B > 0 su un random walk | solo barre CHIUSE; autotest MUTANTE con la barra H4 in formazione: su random walk DEVE dare B > 0 (lo strumento sa vedere il look-ahead), e la versione giusta B ~ 0 |
| **Orologio H4 sbagliato** | barre H4 diverse, eventi riclassificati | G-OROLOGIO bloccante; autotest: H4 spostato di 1 h cambia la classificazione; variante FTMO descrittiva |
| **Supertrend diverso dalla dashboard** | si misura un altro indicatore | identita' al bit con `py_stcore` (collaudato contro il C++ della v4.1) + controllo che il sorgente `.mq5` contenga ancora le righe di `SW_STCore` + misura dell'aggancio a 1000 barre sui dati veri |
| **Eventi dipendenti** (grappoli nello stesso giorno, finestre sovrapposte) | IC troppo stretti | bootstrap a blocchi di giorni; Wilson su P_1R dichiarato ottimista |
| **Molti confronti** (4 dataset x 2 lati x 4 orizzonti x 4 varianti x regimi) | qualche "EFFETTO" per caso | decide UNA cella congelata (R_60, 3,5, B); il resto e' descrittivo; si conta quanti EFFETTO escono fra le descrittive contro quanti ne darebbe il caso |
| **Feed e costo di un'altra epoca** | spread BCM 2024-26 su prezzi 2010-18 | dichiarato; il costo non entra nella cella che decide (lorda) |
| **Ingresso alla chiusura** (nessuno slittamento) | ingresso ottimista | dichiarato; lo spread e' l'unico costo |
| **Strumento cieco** (classe 1014) | "nessun effetto" perche' non sa vederlo | autotest con effetto PIANTATO che DEVE uscire EFFETTO |

---

## 8. Che cosa NON fa questa misura (dichiarato prima)

- Non dice se un EA sulla dashboard guadagna (niente PF, DD, gestione 40/30/30 su TP1/TP2/TP3, niente trailing).
- Non copre Nasdaq, Dow, il feed BCM, il forex della griglia della dashboard (29 simboli), M1/M5/M15/H1 come TF
  del segnale, la confluenza modo 0 (v4.00), la gestione top-down completa con stop H4 su piu' giorni.
- Non tocca rischio e taglie (di Claudio).

---

## 9. Autotest (deve passare TUTTO prima dei dati veri; codice 2 altrimenti)

1. **Identita' del Supertrend**: la versione veloce == `py_stcore` della v4.1 **al bit** (atr, bande, dir, valore) su
   serie sintetiche con salti e tratti piatti, per (10; 3,5), (10; 2,5), (14; 3,5), (1; 3,0); e il sorgente `.mq5`
   contiene ancora le righe chiave di `SW_STCore`.
2. **Random walk con volatilita' oraria stagionale** (orologio vero, fine settimana): ALL, B, CON entro +/-0,03; B
   entro +/-0,02; verdetto della cella che decide **non** EFFETTO ne' CONTRARIO su entrambi i lati.
3. **Effetto PIANTATO** (deriva nel verso del segnale per 60 minuti dopo ogni inversione M3 ALLINEATA, generata in
   tempo reale con lo stesso Supertrend): verdetto **EFFETTO** su entrambi i lati e ALL - CON > +0,05.
4. **Solo deriva H4 (A2)** (deriva costante verso l'alto): B long > +0,03 e cella long **non** EFFETTO.
5. **Momentum M3 senza H4 (A3)** (deriva dopo OGNI inversione M3, allineata o no): ALL - B >= +0,05 **e**
   |ALL - CON| < 0,03.
6. **Look-ahead mutante**: con la barra H4 in formazione al posto dell'ultima chiusa, su random walk B long deve
   uscire > +0,03 (lo strumento vede il look-ahead); la versione giusta resta entro +/-0,02 (punto 2).
7. **Orologio**: H4 spostato di 1 ora cambia il numero di eventi ALLINEATO; il cancello G-OROLOGIO boccia un file in
   EST fisso (riuso del test di `ema200_rimbalzo.py`).
8. **Mutazione della manopola**: moltiplicatore 3,5 -> 2,5 cambia il numero di eventi di almeno il 20%.
9. **Primo passaggio**: su un percorso costruito a mano, TP/SL/AMB/TO escono quelli attesi.

---

## 10. EMENDAMENTO PRIMA DEI DATI (01/10/2026 sera, dopo l'autotest su dati SINTETICI, prima di caricare un solo dato vero)

Quello che segue cambia i criteri qui sopra. E' scritto **dopo** l'autotest sintetico e **prima** della prima
corsa su dati veri (nessun file M1 vero e' stato aperto da questo strumento fino al push di questa sezione).

1. **Controllo B: appaiato per sola ORA, non per (anno-mese, ora)** -- cioe' la definizione del mandato.
   La mia aggiunta del mese era SBAGLIATA, ed e' misurato: su **6 random walk** (2.600 giorni ciascuno) il B
   appaiato per (anno-mese, ora) esce **+0,011 / +0,034** (media +0,024 ATR H1, su tutti e due i lati, tutti i
   semi), mentre la media su tutti i candidati e' **-0,008 / +0,009**. Causa: ogni mese pesa quanto i suoi eventi
   ALLINEATO, e quel numero dipende dal percorso INTERO del mese, quindi anche dal **futuro** dell'istante
   estratto (un mese con un rialzo nella seconda meta' ha piu' tempo "H4 su", piu' eventi long, e pesa di piu'
   proprio sugli istanti prima del rialzo). E' un look-ahead nella **costruzione del controllo**, non nei dati.
   L'evento ALLINEATO non ha questo difetto (somma di differenze di martingala a tempi d'arresto). Appaiato per
   sola ora: **+0,005 / -0,004** sullo stesso random walk. Resta nell'autotest come contro-esempio che DEVE
   accendersi (B(mese) - B(ora) > +0,01: misurato +0,020).
   Conseguenza sul contro-esempio "trend persistente": resta coperto dal test A2 (deriva costante: B +0,121,
   ALL +0,109, cella NULLO) e dalle righe per regime; **non** e' piu' coperto un trend che dura settimane e
   cambia segno [limite dichiarato].
2. **B' (stesso giorno) TOLTO dalla misura**: stesso difetto, piu' forte (il peso del giorno dipende dal giorno).
3. **Aggiunto CASUALE_CON (descrittivo)**: istanti con H4 stabile OPPOSTO al segnale, appaiati per ora agli
   eventi CONTRO, segnati nel verso del segnale. Da qui la lettura D2 a incrementi:
   `(ALL - B) - (CON - B_con)` = il filtro H4 cambia l'INCREMENTO dell'inversione M3 sopra la sua base?
   `ALL - CON` grezzo si riporta accanto. Nell'autotest A3 restano tutti e due i controlli (|ALL - CON| < 0,03
   come congelato, e |incremento| < 0,03).
4. **Test 6 (look-ahead) riscritto**: il mutante "barra H4 in formazione" sposta B di **solo +0,018** (long
   +0,005 -> +0,021, short -0,004 -> +0,015), non > +0,03 come avevo scritto: il filtro di stabilita' della
   dashboard (`bsH4 >= 3`) scarta proprio gli istanti in cui la barra in formazione si gira. **Quindi il test
   del random walk (B entro +/-0,02) da solo NON basterebbe a escludere quel look-ahead.** La guardia vera
   diventa **deterministica**: per ognuna delle 1.247.921 chiusure M3 sintetiche la barra H4 usata ha
   `fine <= tE` ed e' l'ultima chiusa (15.600 casi esattamente sul bordo H4). Il mutante resta, misurato, con
   soglia **> +0,008** (meta' dello spostamento misurato: soglia scelta DOPO averlo visto, su dati sintetici).
5. **Test 9**: l'atteso scritto a mano nel mio test era sbagliato (lo short con stop a 2 punti tocca 102,1 PRIMA
   del 97,9: e' SL, non TP); lo strumento era giusto. Nessun cambio ai criteri.
6. Stato dell'autotest al momento di questo emendamento: **29/29**.
