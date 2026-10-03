# EMA200 a H4 e D1 sulle 28 coppie forex: CRITERI CONGELATI (03/10/2026)

> **Scritto e committato PRIMA di qualunque numero su dati veri.** Nessun file di prezzi e' stato aperto o letto
> prima di questo commit: sul mirror e' stata fatta solo una sonda di ESISTENZA (richieste HEAD, piu' un primo giro
> di GET scartate su /dev/null di cui si e' guardato solo codice e dimensione, mai il contenuto), riportata alla
> sez. 1.
> Nasce da una convinzione di Claudio (Piano B, trading MANUALE): *"la EMA200 su H4 e D1 respinge il prezzo al
> primo tocco"*. Le misure del 01/10 e 02/10 dicono: M5-H1 piatto e sotto il random walk; **H4 e D1 = NON ANCORA
> MISURATO per campione sottile** (n 28-108 per lato a H4, 1-20 a D1, contro 150 richiesti, su DAX e oro).
> Questo documento disegna la misura che puo' dare il numero mancante: **piu' coppie e piu' anni**.
> Estende le definizioni di `report/EMA200_RIMBALZO_CRITERI_2026-10-01.md` (commit `c23bfe61`) e usa i riferimenti
> di `report/EMA200_D1_SU_M5_CRITERI_2026-10-02.md` (commit `e2655661`). **Dove questo file tace, valgono alla
> lettera i criteri del 01/10.** Se strumento e criteri divergono, VINCONO I CRITERI.
> Strumento di base: `backtest_pipeline/ema200_rimbalzo.py` (SHA256 `dd4fb376f3a5732e...9eb2`), **importato, mai
> modificato**; riferimenti tecnici in `backtest_pipeline/ema200_d1_su_m5.py` (SHA256 `b8a75d35512128fe...33f9`,
> importato per `giorno_label`, mai modificato). Il codice NUOVO (un involucro `backtest_pipeline/ema200_forex28.py`)
> si scrive DOPO questo commit e deve fare solo quello che sta scritto qui.
> **Non e' un backtest**: niente PF, niente equity, niente stop in pip, niente costo dentro la P, **nessuna taglia**.
> Non tocca EA, preset, sedie, conti, terminali. Zero Strategy Tester, zero VPS, nessuna riga di lancio consegnata.
> **Nulla di questo va a Claudio prima del cancello** (`controllo-preventivo`).
> Etichette: [MISURATO] letto da un file/sonda; [DERIVATO] calcolo su numeri misurati; [NON MISURATO]; [INFERITO].

---

## 0. La domanda, e che cosa questa misura NON e'

**Domanda (H1, la sola che ha un verdetto qui):** dopo il PRIMO tocco della EMA200 di H4 (e di D1), il prezzo si
allontana dal lato da cui e' arrivato PRIMA di sfondare dall'altra parte, **piu' di quanto farebbe una linea lenta
qualsiasi** posta a caso rispetto al percorso?
- H2 (ritest dello sfondamento) e H3 (gradiente) **NON sono oggetto di questa misura**: non si calcolano e non
  hanno verdetto (restano com'erano il 01/10: H3 NON ANCORA MISURATO).
- Unita' = **EVENTO** (un primo tocco), mai il trade, mai l'anno. Il campione indipendente si conta in
  **cluster** (sez. 6), non in eventi.

**Che cosa NON e'**: non e' la regola d'ingresso di Claudio (ordini limite, parziali, stop in pip, contesto a
occhio non sono modellati); non dice se si guadagna; non dice nulla sulle sedie `ABTG_EMA200`. Un NULLO qui
significa "al primo tocco la 200 non respinge piu' di una linea qualsiasi **a questo n, su queste coppie e questi
anni**", mai "la 200 non serve" e mai "morto".

## 0-bis. Decisioni di lettura prese QUI, prima dei numeri (il mandato era ambiguo; le dichiaro e le segnalo)

| punto | decisione congelata | perche' |
|---|---|---|
| "storico lungo" | **tutti gli anni che il feed da' davvero**, senza scegliere finestre; il referto scrive il primo e l'ultimo giorno REALI per coppia | niente finestra scelta dopo i numeri (Emendamento A: l'unita' e' l'operazione, e si DICHIARA il regime) |
| 28 coppie, ma una sola fonte raggiungibile da qui | **due tranche**: **A6** (le 6 del mirror, misurabile subito) e **B22** (le altre 22, solo dal PC di backtest). Il verdetto di A6 porta SEMPRE l'etichetta **"6 coppie su 28"** (sez. 7.3) | le 28 non sono tutte raggiungibili (sez. 1): sulle 22 mancanti non si inventa niente |
| asse "allineamento" | UNA regola e UNA mappa (sez. 8), strettamente senza filtro sulla cella primaria | richiesta del mandato; la mappa per D1 e' quella del mandato (H4) |
| regimi del forex | classi per **coppia-anno** con soglie **+5% / -5%** (non +10% / -5% degli indici) | su un cambio un anno a +10% e' raro: con le soglie degli indici la classe TORO sarebbe quasi vuota. Soglie fissate ora, mai riviste |
| parola CONTRARIO | resta, come specchio di EFFETTO (il mandato elenca solo NULLO / ZONA GRIGIA / EFFETTO / NON ANCORA MISURATO) | senza lo specchio un "sfondamento sistematico" cadrebbe in ZONA GRIGIA |

---

## 1. Universo, fonti, anni REALI (dichiarati, non assunti)

**L'universo sono le 28 coppie fra EUR, GBP, AUD, NZD, USD, CAD, CHF, JPY** (maggiori e minori):
AUDCAD AUDCHF AUDJPY AUDNZD AUDUSD · CADCHF CADJPY CHFJPY · EURAUD EURCAD EURCHF EURGBP EURJPY EURNZD EURUSD ·
GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD GBPUSD · NZDCAD NZDCHF NZDJPY NZDUSD · USDCAD USDCHF USDJPY.

### 1.1 Fonte A: mirror Oanda `FutureSharks/financial-data` (raggiungibile da questa macchina)
`raw.githubusercontent.com/FutureSharks/financial-data/master/pyfinancialdata/data/currencies/oanda/<COPPIA>/<AAAA>/oanda-<COPPIA>-<AAAA>-<M>.csv`
(licenza GPL-3.0 del repository; dati di Oanda, condizioni d'uso [NON VERIFICATE]; nel repo entrano solo conteggi
aggregati ed eventi, mai prezzi grezzi). Colonne `time,close,high,low,open,volume`, **ora UTC** (verificata
sull'oro il 10/09; per il forex la verifica e' il cancello della sez. 2.3, non un'assunzione).

**Sonda di esistenza del 03/10/2026, ~09:55 UTC [MISURATO, solo HEAD: codice e dimensione]**: 56 orientamenti
possibili delle 8 valute provati sul mese 2010-03; **ESISTONO 6 coppie su 28**:

| coppia | primo mese | ultimo mese | file mensili | byte (somma Content-Length) | buchi interni |
|---|---|---|---|---|---|
| EURUSD | 2005-01 | 2020-05 | 185 | 301.599.911 | nessuno |
| EURJPY | 2005-01 | 2020-05 | 185 | 306.413.529 | nessuno |
| GBPUSD | 2005-01 | 2020-05 | 185 | 293.697.970 | nessuno |
| AUDUSD | 2005-01 | 2020-05 | 185 | 287.354.679 | nessuno |
| AUDJPY | 2005-01 | 2020-05 | 185 | 284.803.035 | nessuno |
| USDCAD | 2005-01 | 2020-05 | 185 | 288.708.298 | nessuno |

Finestra reale: **2005-01 -> 2020-05, 15,4 anni**; sonda 2003-2022 su tutti e sei: nessun 200 fuori da quel
range. Totale ~1,76 GB. Valute coperte: EUR, GBP, AUD, USD, CAD, JPY; **mancano NZD e CHF**; 4 coppie su 6
contengono USD (rilevante per la correlazione: sez. 6).
**NON esistono sul mirror** (404 sul mese di prova, anche con l'orientamento invertito): AUDCAD AUDCHF AUDNZD
CADCHF CADJPY CHFJPY EURAUD EURCAD EURCHF EURGBP EURNZD GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD NZDCAD NZDCHF NZDJPY
NZDUSD USDCHF USDJPY (**22**).
Raggiungibilita' di altre fonti, provata una volta e senza insistere [MISURATO 03/10]: `www.histdata.com`,
`datafeed.dukascopy.com`, `stooq.com`, `query1.finance.yahoo.com`, `data.binance.vision`, `forexsb.com`, `stooq.pl`
-> **403 dal proxy**. `raw.githubusercontent.com` passa; `github.com` (pagine) e l'API no.

### 1.2 Fonte B: HistData M1 forex, dal PC di backtest `DESKTOP-H4D7CAJ` (le 22 mancanti, e le 28 intere)
Esiste gia' lo scaricatore che da quel PC ha funzionato (15/08 e 22/09): `backtest_pipeline/oro_m1_histdata.ps1`,
parametro `-Simbolo`, zip annuali `HISTDATA_COM_ASCII_<COPPIA>_M1_<AAAA>.zip`. **Anni disponibili per coppia:
[NON MISURATO]**: li dira' la corsa, non si assumono (HistData ha date di inizio diverse per coppia).
Il formato e' quello che `ema200_rimbalzo.leggi_testo(..., "histdata")` legge (`AAAAMMGG HHMMSS;O;H;L;C;V`);
l'orologio e' ora di New York con ora legale (misurato in casa: shift +5 su 8 simboli su 8 incluso il forex,
`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`).
**Regola congelata per B: si usano solo gli anni >= 2007.** Lo strumento importato converte NY->UTC con la regola
USA in vigore dal 2007 (seconda domenica di marzo - prima di novembre); prima del 2007 la regola era diversa
(aprile-ottobre) e **non e' implementata**: includere 2000-2006 sporcherebbe 3-5 settimane l'anno. Non si
modifica lo strumento: si taglia il dato.
**Fonte C (non usata)**: l'M1 nativo BCM nei terminali del PC (R102: AUDUSD dal 1993, EURUSD dal 1971, GBPUSD dal
1993). Non esiste in repo nessuno strumento d'esportazione dell'M1 nativo in CSV: richiederebbe MQL5 nuovo, fuori
perimetro. Dichiarata come via possibile, non percorsa.

### 1.3 Che cosa vale ciascuna tranche
- **A6**: Oanda, 6 coppie, 2005-01 -> 2020-05. Misurabile subito.
- **B22 (o B28)**: HistData, 2007 -> oggi, dal PC. **Mai concatenata con A6** (R80: il feed cambia il segno): se
  si misura B su una coppia che e' anche in A, i due feed restano due righe SEPARATE, gemelli di feed.
- Il verdetto sul forex **"28 coppie"** esiste solo quando B e' misurata. Prima, la frase e' **"6 coppie su 28"**.

---

## 2. TF, orologio, barre

### 2.1 TF
- **H4 e D1: primari** (decidono).
- **M30 e H1: solo RIFERIMENTO** (stessa macchina, per dire se il forex si comporta come l'oro e il DAX a M30/H1 e
  per calibrare l'attesa); mai usati per promuovere o archiviare. M30 si costruisce con lo stesso involucro
  (`tfm = 30`); lo strumento di base non ha M30 nella sua tabella e **non si modifica**.

### 2.2 Costruzione delle barre
- **Orologio UTC+1 fisso** (= BCM di oggi), bordi a multipli del TF dalla mezzanotte UTC+1, come il 01/10.
  **H4**: come il 01/10 (barre di 4 ore; la prima e l'ultima della settimana possono essere parziali: e' cosi' anche
  su MT5).
- **D1: giorno di calendario UTC+1 con i minuti di sabato e domenica attribuiti al lunedi'** (come i criteri del
  02/10 sez. 2.1, funzione `ema200_d1_su_m5.giorno_label(t, "UTC1")`). **Differenza dichiarata dal 01/10:** il 01/10
  il D1 non faceva questa fusione; sul forex, che apre la domenica sera, produrrebbe una barra D1 di 1 ora ogni
  settimana e una EMA200 su 6 barre a settimana invece di 5, cioe' **un'altra linea**. Il referto scrive quanti
  minuti sposta. (Per H4 la fusione NON si fa: unirebbe la domenica sera a un blocco lontano di 20 ore.)
- **Sensibilita' NYCLOSE (descrittiva, non decide)**: stessa misura con la barra che chiude alle 17:00 di New York
  (convenzione dei broker UTC+2/+3 con ora legale USA, FTMO): D1 con `giorno_label(t, "NYCLOSE")`; H4 con
  `bin = (t - off + 420) // 240`, `off` = 300 (EST) o 240 (EDT). Si riporta la P vera e il verdetto; la banda dei
  surrogati e' quella della corsa primaria.
- **Riscaldamento**: nessun evento nelle prime **600 barre** del TF per coppia (peso del seme e^-6).
- **EMA200** sul close (alpha 2/201, seme = primo close), **ATR(14)** media semplice del true range: come il 01/10.

### 2.3 G-OROLOGIO (bloccante, per FEED, non per coppia)
Il fuso e' una proprieta' del feed, non della coppia, e le coppie senza USD/EUR/GBP possono avere il picco
giornaliero su un'ancora diversa. Quindi il cancello si applica al **profilo POOLED** di tutte le coppie del feed
(funzione `ema200_rimbalzo.cancello_orologio` su un M1 concatenato: ampiezza `|close-open|/close` media per
minuto-del-giorno UTC, mesi gen-feb contro giu-ago).
- **Ancore d'inverno (minuti UTC), dichiarate ora**: 07:00, 08:00 (aperture europee), 13:15 (BCE), 13:30 (dati USA
  8:30 ET), 15:00 (dati USA delle 10:00), 16:00 (fixing di Londra), 19:00 (FOMC). Tolleranza 2 minuti.
- **PASSA** se il picco d'inverno cade su un'ancora **e** il picco d'estate cade esattamente **60 minuti prima**
  (+/-2). Se fallisce: **codice 2, nessun numero** per quel feed.
- **Contro-esempio** (perche' distingue): un file in EST FISSO convertito come NY con ora legale mette il picco
  d'estate **120** minuti prima; un file gia' UTC trattato come NY lo mette a **+60 o +0** (autotest F6).
- Guardia per-coppia **solo informativa**: si stampa il picco di ogni coppia; non scarta niente.

### 2.4 G-DATI e filtro di qualita' del feed
- **G-DATI**: il referto elenca per coppia-anno le barre M1 [MISURATO]. Una coppia-anno con **meno del 50% della
  mediana** delle barre M1 delle coppia-anni della stessa coppia e' **ESCLUSA dagli eventi** (e dichiarata con nome).
  Nessuna esclusione "a occhio" dopo i numeri.
- **Filtro ATR (classi 1037/1054, adottato dal 02/10)**: un evento si scarta se l'ATR(14) della barra chiusa
  precedente e' **< 0,1 x la mediana** dell'ATR(14) di quella coppia a quel TF (dopo il riscaldamento); nella
  separazione una barra con ATR sotto soglia conta distanza 0 (mai "lontana"). I surrogati usano la soglia della
  serie VERA. **La cella primaria usa il filtro; la versione SENZA filtro (identica alla definizione del 01/10)
  si riporta come sensibilita'**; se i due verdetti divergono, si scrive "sensibile al filtro".

---

## 3. L'evento "primo tocco": IDENTICO al 01/10, sez. 3

Barra pulita sopra `low_j > EMA_{j-1}`; armato alla barra k quando le **N = 20** barre precedenti sono tutte
pulite e almeno una e' chiusa a **>= 1,0 ATR** dalla sua EMA; **PRIMO TOCCO** = barra armata con `low_k <= L`
(`L` = EMA della barra chiusa precedente, `A` = ATR della stessa barra, **congelati**); minuto del tocco = primo M1
con `low <= L`. Specchio per il tocco dal basso. **Lati separati, sempre**: "long" = tocco dall'alto (rimbalzo
verso l'alto), "short" = tocco dal basso, ciascuno sul grafico della coppia cosi' com'e' quotata.
Esiti sui minuti M1 dal minuto del tocco: **B** (rimbalzo `high >= L + X A`, dal minuto dopo), **P** (sfondamento
`low <= L - Y A`, gia' nel minuto del tocco), **AMB** (stesso minuto, riportato a parte), **TO** (nessuno dei due
entro la barra k+19). `P_B = B/(B+P)`.
**Implementazione: si importa `ema200_rimbalzo` e si riusa `eventi_h1`.** L'involucro deve in piu' conoscere il
MINUTO e il LIVELLO del tocco (servono a cluster, asse e mesi): lo fa con una funzione di arming/tocco copiata
riga per riga dalla logica di `eventi_h1` **piu' il solo filtro della sez. 2.4**, e **l'identita' evento per evento
con `R.eventi_h1` a filtro spento e' un autotest bloccante (F1)**. Nessuna definizione cambia.

## 4. Cella primaria e celle descrittive

- **CELLA PRIMARIA, l'unica che decide: X = 1,0 ATR (rimbalzo), Y = 1,0 ATR (sfondamento)**; null analitico 0,500.
- Celle descrittive (tutte riportate, nessuna promuove): X in {0,25; 0,5; 1,0} x Y in {0,5; 1,0}, fra cui la **cella
  della collega (0,25; 1,0), null analitico 0,800**.
- **Nessuna cella e' "la migliore"**: la selezione e' il centro dell'altopiano, mai il picco; nessuna cella si sceglie
  dopo i numeri; **nessun parametro nuovo dopo aver visto i numeri**. Se serve guardare un'altra cella o un altro
  filtro, e' un'altra misura con altri criteri congelati prima.

## 5. I null (tre, servono tutti)

- **N0 analitico** (random walk continuo senza deriva): 0,500 alla primaria, 0,800 alla cella della collega,
  `Y/(X+Y)` nelle altre. **Non e' il riferimento del verdetto** (grana M1): lo e' N1.
- **N1 surrogato a blocchi (IL riferimento)**: per ogni coppia, le stesse barre M1 rimescolate a **blocchi di 40
  barre INTERE del TF** (funzione `ema200_rimbalzo.surrogato`), prezzi ricostruiti dai rendimenti log minuto per
  minuto (gap compresi); EMA, ATR ed eventi si RICALCOLANO sul surrogato. **100 surrogati a H4 e D1, 40 a M30/H1**
  (riferimento), semi fissi `1000 + TF_MIN + 7 x indice coppia`. La P del surrogato i-esimo e' la P **pooled** sulle
  coppie (somma dei B su somma dei B+P). Riferimento = mediana; banda = [p2,5; p97,5].
  - Perche' 40 barre anche a D1: la memoria della EMA200 e' ~100 barre, il blocco e' il 40% di quella e la rompe;
    il blocco conserva deriva, volatilita' e suo raggruppamento entro 40 barre, grana M1.
  - **Limite dichiarato**: le coppie sono permutate **indipendentemente**, quindi la banda dei surrogati ignora la
    correlazione fra coppie e puo' risultare piu' STRETTA del vero. Effetto: rende piu' difficile NULLO (giusto) e
    piu' facile EFFETTO: per questo **EFFETTO richiede anche l'IC a blocchi di mesi** (sez. 6) sopra la mediana.
- **N2 placebo di livello**: EMA100, EMA150, EMA250, SMA200 al posto della EMA200, stesso protocollo, stessi dati.
  Descrittivi per default (P e IC). **Regola scritta ora**: se la cella primaria TUTTO di un (TF, lato) esce EFFETTO,
  oppure ZONA GRIGIA con |effetto| >= 0,03, i quattro placebo di quella cella si **rifanno con 100 surrogati
  propri** (rilievo del cancello del 02/10); lettura: un placebo con verdetto EFFETTO, o con P entro +/-0,03 dalla
  EMA200, significa "effetto di una linea lenta qualsiasi", non "della 200".

## 6. Indipendenza degli eventi, cluster, IC a blocchi

Due primi tocchi della stessa coppia sono distanti >= 20 barre per costruzione, ma **non sono indipendenti**:
coppie che condividono una valuta (EURUSD, GBPUSD, USDCAD, AUDUSD hanno tutte l'USD) si muovono insieme e toccano
la loro 200 negli stessi giorni.
- **Cluster (per lato, sugli eventi risolti B o P)**: due eventi sono collegati se **toccano nello stesso giorno
  di calendario UTC+1 E le loro coppie condividono almeno una valuta** (la stessa coppia conta come "condivisa");
  il cluster e' la componente connessa del grafo. **`n_cluster` = numero di cluster = il campione indipendente
  dichiarato.** Si riportano sempre `n` (eventi), `n_cluster`, e le coppie e i mesi distinti coinvolti.
- **IC del verdetto = il PIU' LARGO fra due**: (a) **Wilson 95% calcolato su `n_cluster`** con la P pooled; (b)
  **bootstrap a blocchi di MESE** (2.000 repliche, percentili 2,5-97,5, seme fisso): si ricampionano con
  reinserimento i mesi di calendario UTC (tutti gli eventi di tutte le coppie dello stesso mese viaggiano
  insieme) e si ricalcola `sum B / sum (B+P)`. Il blocco-mese assorbe sia lo stesso giorno sia la correlazione fra
  coppie. Entrambi nel CSV.
- **Limite dichiarato**: dipendenze piu' lunghe di un mese (un anno di trend dell'USD) restano dentro i blocchi;
  per questo la regola di concordanza per classi di regime e per coppia (sez. 7.2).

## 7. n minimo e parole del verdetto

### 7.1 Per ogni (TF, lato), cella primaria, TUTTO, coppie pooled
- **`n_cluster` < 150 -> NON ANCORA MISURATO** (merito sospeso, Emendamento A). Si scrivono `n` e `n_cluster`.
- **EFFETTO**: `P > p97,5` surrogati **e** `effetto >= +0,05` **e** estremo basso dell'IC del verdetto > mediana
  surrogati.
- **CONTRARIO**: specchio (sotto p2,5, effetto <= -0,05, estremo alto IC < mediana).
- **NULLO**: `|effetto| < 0,03` **e** P dentro [p2,5; p97,5] **e** semi-ampiezza dell'IC <= 0,06
  [DERIVATO: con Wilson e P = 0,5 serve `n_cluster` >= 267].
- altrimenti **ZONA GRIGIA**, scrivendo di quanto e perche' (imprecisione o effetto vero-ma-piccolo).
- Dove P e' tutta in B o in P (n piccolo), si legge solo la regola n.

### 7.2 Verdetto sul FENOMENO a un TF (parole identiche al 01/10 sez. 7)
- **VERO (H1 vero a quel TF)** solo se: EFFETTO su **entrambi i lati**; segno concorde in **ogni classe di regime
  con `n_cluster` >= 150** (classi per coppia-anno: TORO >= +5%, ORSO <= -5%, LATERALE in mezzo, rendimento
  close-to-close del coppia-anno); segno concorde in **almeno 2/3 delle coppie con >= 15 eventi risolti** (effetto
  coppia = P_coppia - mediana surrogati della coppia); e **nessun placebo** lo riproduce (sez. 5).
- **SENZA CONTENUTO (dentro il null)** se NULLO su entrambi i lati e su tutte le classi di regime con
  `n_cluster` >= 150, con almeno 4 coppie misurate.
- altrimenti **NON ANCORA MISURATO**, con l'elenco di cosa manca. "Morto" e "vero" senza n, IC, null e coppie
  non si usano. **Questa misura non e' un certificato di morte di niente** (mancano PF, DD, gestione dell'uscita).

### 7.3 Etichetta di copertura (obbligatoria in ogni frase che cita un verdetto)
Ogni verdetto porta **"k coppie su 28, feed, anni reali"**. Con la sola A6: **"6 coppie su 28, Oanda, 2005-2020"**.
**Il verdetto sul FOREX in generale non si scrive finche' le 22 coppie mancanti non sono misurate.** Per A6 il
verdetto vale per quelle sei coppie: quattro con USD, nessuna con CHF o NZD.

## 8. L'asse separato: ALLINEAMENTO

**Domanda:** al momento del tocco, il tocco e' piu' (o meno) respinto quando la EMA200 di un TF di contesto sta
dal lato "giusto" del prezzo? **E' UN ASSE DI LETTURA, NON UN FILTRO**: la cella primaria resta senza filtro e
decide da sola; l'asse non promuove e non archivia niente.
- **TF di contesto, mappa fissa**: **M30 -> H1 · H1 -> H4 · H4 -> D1 · D1 -> H4**.
  (Il mandato dice "su H1 per M30/H1, su H4 per D1": M30->H1 e D1->H4 sono letterali; per H1 il contesto H1 e' lo
  stesso grafico, quindi uso H4; per D1 il TF superiore naturale sarebbe W1, la cui EMA200 vuole ~4 anni di
  riscaldamento e non e' misurabile, quindi H4 come da mandato. Scelta mia, dichiarata e segnalata.)
- **Regola (una sola, strettamente)**: sia `E_c` la EMA200 dell'**ultima barra CHIUSA** del TF di contesto al
  **minuto del tocco**, `L` il livello toccato. Tocco **long** (dall'alto): **ALLINEATO se `E_c < L`**. Tocco
  **short** (dal basso): **ALLINEATO se `E_c > L`**. Altrimenti CONTRO (uguale = CONTRO). Nessuna soglia di distanza,
  nessuna pendenza, nessuna combinazione cercata.
- Un evento e' **NA** per l'asse se il contesto ha meno di **600 barre** di riscaldamento al suo minuto; il
  referto scrive quanti NA. L'evento resta valido per la cella primaria.
- **Misura**: `P_allineato`, `P_contro`, `Delta = P_allineato - P_contro`, per (TF, lato). Null: in ogni surrogato si
  rifa' la stessa etichettatura (EMA di contesto ricalcolata sul surrogato) e si ottiene la banda di `Delta`; IC di
  `Delta` col bootstrap a blocchi di mese. Parole: stesse regole di 7.1 applicate a `Delta` (null 0), con
  **`n_cluster` >= 150 in ciascuno dei due sottoinsiemi**, altrimenti NON ANCORA MISURATO.
- **Anti look-ahead**: `E_c` viene dalla barra di contesto chiusa PRIMA del minuto del tocco (autotest F13).
- Perche' potrebbe dare un falso positivo: l'allineamento e' una funzione LENTA del trend; nei periodi di trend
  l'allineato coincide con "il prezzo e' salito e la 200 sta sotto": la deriva del lato. N1 conserva la deriva
  entro 40 barre ma non il trend lungo: **per questo un Delta positivo e' un INDIZIO, mai "VERO"**, a meno di
  superare anche la concordanza per regime e per coppia della sez. 7.2.

## 9. Banda contro l'ipotesi ALTERNATIVA (classe 178), scritta prima

- **Claudio alla lettera ("respinge al primo tocco", "quasi sempre")** predice **P >= 0,75** alla cella primaria
  contro un null ~0,45-0,50: effetto **>= +0,25**, 8 volte la banda NULLO (+/-0,03). Con `n_cluster` = 150 la
  semi-ampiezza dell'IC e' ~0,08: **le due ipotesi non cadono nella stessa banda, la misura le separa.**
  **Forma forte ESCLUSA** per una cella con `n_cluster` >= 150 se l'estremo alto dell'IC del verdetto e' < 0,75.
- Sulla cella della collega (0,25; 1,0) il null e' gia' 0,800: "quasi sempre" li' e' il random walk. Contenuto solo
  con P >= 0,85 **e** sopra p97,5 dei surrogati.
- **Forma DEBOLE (un effetto di +0,05)**: separabile solo con ~1.500 cluster per lato [DERIVATO: semi-ampiezza
  0,025]. Se esce ZONA GRIGIA si scrive cosi', non "morto". Il 01/10 l'unico indizio debole era oro H1 long
  (+0,049 / +0,037, ZONA GRIGIA, un lato): e' il riferimento per leggere M30/H1 qui.

---

## 10. Contro-esempi: cosa farebbe sembrare vero un effetto senza esserlo

| contro-esempio | che cosa produrrebbe | come e' coperto |
|---|---|---|
| **Deriva / trend di una valuta** (USD 2005-2020) | i rimbalzi di un lato vincono per deriva | lati separati; N1 conserva la deriva; regime per coppia-anno; concordanza per coppia |
| **Coppie correlate trattate come indipendenti** | un IC "da n eventi" troppo stretto, un EFFETTO falso | cluster per giorno x valuta, IC a blocchi di mese, `n_cluster` dichiarato, autotest F8-F9 |
| **Soglie asimmetriche** | 0,80 dal nulla alla cella della collega | N0 accanto a ogni P; verdetto solo sulla primaria simmetrica |
| **Raggruppamento della volatilita'** | vol che esplode dopo il tocco | N1 la conserva entro 40 barre; AMB/TO riportati |
| **Mean reversion generica** | P > 0,5 senza EMA | N1 e placebo (sez. 5) |
| **Orologio sbagliato** | barre H4/D1 su bordi sbagliati: numeri "puliti e falsi" | G-OROLOGIO per feed (+60/+120 distinguibili), autotest F6; sensibilita' NYCLOSE |
| **Domenica sera: barra D1 di 1 ora** | un'altra EMA (6 barre/settimana) | weekend -> lunedi' per D1, autotest F7 |
| **Feed piatto (Oanda)** | ATR ~0, distanze enormi | filtro ATR 0,1 x mediana, sensibilita' senza filtro (classi 1037/1054) |
| **Anni con dati dimezzati** | eventi falsi/assenti | G-DATI (esclusione per coppia-anno dichiarata) |
| **Look-ahead** | EMA o contesto che contengono la chiusura dopo il tocco | `L`, `A`, `E_c` dalla barra chiusa precedente; autotest F13 |
| **Molti confronti** | ~5% delle righe oltre p97,5 per caso | verdetto solo sulla primaria TUTTO per (TF, lato); celle, regimi, NYCLOSE, asse sono descrittivi |
| **Strumento cieco** (classe 1014) | "nessun effetto" perche' lo strumento non lo vede | rimbalzo PIANTATO a H4 che DEVE uscire EFFETTO (F3) e specchio che DEVE uscire CONTRARIO (F4) |
| **Strumento allarmista** | EFFETTO dove non c'e' | dati casuali, anche con un fattore comune fra coppie, che NON devono uscire EFFETTO ne' CONTRARIO (F2) |
| **Surrogato con blocco troppo lungo** | null che contiene l'effetto | blocco 40 barre del TF (< memoria ~100) |
| **Feed misti** | segno che cambia col feed (R80) | A e B mai concatenati; gemelli di feed |

## 11. Autotest (devono passare TUTTI prima dei dati veri; se uno fallisce, niente dati, codice 2)

`python3 backtest_pipeline/ema200_forex28.py --autotest` concatena nell'ordine:

| # | prova | soglia (scritta ora) |
|---|---|---|
| **F0** | l'autotest di `ema200_rimbalzo.py` (21 prove del 01/10), importato e rieseguito tale e quale | tutte PASS |
| **F1** | identita' evento per evento fra l'involucro (filtro spento) e `R.eventi_h1` su random walk, a H1 e H4, 6 celle | identita' esatta; stesso numero di eventi |
| **F2** | **random walk, K = 4 coppie sintetiche pooled a H4** (>= 1.000 eventi per lato), con e senza **fattore comune** (70% degli incrementi condivisi): P pooled per lato entro 0,500 +/- 0,04 | non EFFETTO ne' CONTRARIO; con fattore comune `n_cluster` < `n` di almeno il 10% |
| **F3** | **rimbalzo PIANTATO a H4** (`sintetico_piantato(..., "rimbalzo", tfm=240)`, K = 4 coppie pooled): la prova che lo strumento lo VEDE | EFFETTO su entrambi i lati, `effetto >= +0,10`, placebo EMA100 e EMA250 NON EFFETTO |
| **F4** | **rimbalzo piantato di segno opposto** (forza negativa: spinta attraverso la EMA): la prova a due lati | CONTRARIO su entrambi i lati |
| **F5** | **asse**: serie H4 con rimbalzo piantato **solo quando la EMA200 D1 e' dal lato giusto** vs piantato **sempre** | solo-allineato: `Delta` EFFETTO; sempre: `Delta` NON EFFETTO |
| **F6** | **orologio**: stesso feed spostato di +1 h cambia gli eventi H4 e D1; il cancello PASSA sul feed con picco 8:30 NY scritto bene, BOCCIA quello in EST fisso (picco estivo a -120) e quello UTC letto come NY | differenza / PASS / FAIL come scritto |
| **F7** | **domenica**: serie con apertura di domenica e barra di 1 ora: D1 = 5 barre/settimana e i minuti domenicali stanno nel lunedi'; H4 NON unisce domenica e lunedi' | uguaglianza |
| **F8** | **cluster** su eventi scritti a mano: EURUSD+GBPUSD+USDJPY stesso giorno -> 1 cluster; AUDJPY + EURUSD stesso giorno -> 2; stessa coppia in giorni diversi -> separati; EURUSD + GBPJPY + AUDJPY stesso giorno -> 2 (GBPJPY e AUDJPY condividono JPY, EURUSD resta solo); aggiungendo AUDUSD lo stesso giorno -> 1 (AUDUSD lega AUDJPY e EURUSD) | conteggi esatti |
| **F9** | **IC a blocchi**: mesi alternati tutti-B / tutti-P: IC di mese >= 3 volte Wilson su `n`; eventi i.i.d.: IC di mese entro +/-30% di Wilson | come scritto |
| **F10** | **copertura**: `n_cluster` < 150 -> NON ANCORA MISURATO; l'uscita porta "k coppie su 28" | stringa e verdetto |
| **F11** | **mutazione**: X da 1,0 a 0,25 sposta P di > 0,15 | come scritto |
| **F12** | **placebo**: su dati con rimbalzo piantato alla EMA200, EMA100/150/250 danno P entro 0,500 +/- 0,05 | come scritto |
| **F13** | **look-ahead del contesto**: cambiare una barra di contesto DOPO il tocco non sposta l'etichetta; cambiare quella chiusa subito PRIMA si' | uguaglianza / differenza |

**Regola del rumore (classe 1035):** se una prova cade per campione piccolo, si ALZA il campione del sintetico e si
dichiara; **mai la tolleranza**. Se cade perche' il rimbalzo piantato non e' abbastanza forte per essere visto, si
alza la `forza` del generatore, mai la soglia. Una soglia cambiata dopo aver visto un risultato sintetico va scritta
nel referto con il numero.

## 12. Attese dichiarate (prima dei numeri, con il perche')

- **E1 (H4, primaria)**: effetto entro +/-0,05; verdetti NULLO o ZONA GRIGIA su entrambi i lati; P fra 0,42 e 0,55.
  Perche': a H4 il 01/10 le P erano 0,33-0,54 con n 28-108 e IC larghi; nessun motivo per un effetto pulito.
- **E2 (campione, [DERIVATO da oro/indici del 01/10, non dal forex])**: a H4 4-9 primi tocchi per lato per anno per
  simbolo -> A6 (90 coppia-anni dopo il riscaldamento) **360-810 eventi per lato, `n_cluster` forse 30% sotto**:
  H4 raggiunge probabilmente 150. A D1 0,7-1,7 per lato per anno (78 coppia-anni dopo 600 giorni di riscaldamento)
  -> **55-135 eventi per lato: D1 quasi certamente NON ANCORA MISURATO su A6.** Per B28 (HistData 2007-oggi,
  ~490 coppia-anni a D1) ~340-830 eventi: D1 diventa misurabile solo li'.
- **E3 (precisione)**: a `n_cluster` 300 la semi-ampiezza e' ~0,057: NULLO e' raggiungibile solo oltre ~270;
  sotto, ZONA GRIGIA per imprecisione e va scritta cosi'.
- **E4 (cella della collega)**: P fra 0,65 e 0,80 (sotto lo 0,80 del random walk, come a M5-H1); nessun "quasi
  sempre".
- **E5 (asse)**: `Delta` entro +/-0,05; se esce positivo e oltre la banda e' un indizio da rimisurare, non un esito.
- **E6 (lati)**: la P grezza segue chi sale/scende nella coppia (deriva), l'effetto contro N1 no.
- Se un effetto esce pulito (oltre la banda, due lati, concorde per regime e per coppia, assente nei placebo): **e'
  un risultato vero e si scrive come tale**, con "k coppie su 28".

## 13. Ordine delle operazioni e vincoli

1. **Questo file si committa e si pusha con percorso esplicito PRIMA di toccare i dati.** Il referto riporta l'ora
   del push e l'ora della prima lettura di un file di prezzi.
2. Poi: si scrive `ema200_forex28.py`; **autotest F0-F13 tutti PASS**; solo allora i dati A6; se un autotest o un
   G-OROLOGIO fallisce, **nessun numero** e lo si dichiara.
3. Nessuna soglia, definizione, cella o regola si cambia dopo aver visto i numeri. Un errore del codice si
   corregge, ma il file dei criteri non si riscrive: si aggiunge un'errata datata in fondo.
4. **Costo (solo descrittivo, non entra nella P)**: ATR mediano del TF in pip per coppia e rapporto
   `X*ATR/spread` dove lo spread e' misurato (`MISURA_SPREAD_FOREX_2026-09-12.md`; altrimenti [NON MISURATO]). La
   frontiera `stop >= 40 x spread` non si sposta.
5. Zero tester, zero VPS, nessun EA/preset/conto toccato, nessuna taglia. I risultati vanno in
   `backtest_pipeline/risultati_archivio/EMA200_H4_D1_FOREX28_2026-10-03/` (CSV di eventi e di sintesi, referti, log,
   `autotest.log`; mai prezzi grezzi) e nel referto `report/EMA200_H4_D1_FOREX28_MISURA_2026-10-03.md`.
6. **Per le 22 coppie mancanti (B)**: in questa sessione si PREPARA soltanto (fonte, formato, dimensione, riga di
   lancio per una finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`), **senza consegnare niente**: la riga
   deve passare `controlla_riga.py` e `controllo-preventivo`.

## 14. Che cosa significa ogni parola, per il Piano B (trading manuale, nessuna taglia)

- **NULLO**: al primo tocco la 200 non respinge piu' di una linea qualsiasi. Se la si usa, il vantaggio sta altrove
  (contesto, gestione, scelta dei momenti), **e quel "altrove" non e' misurato qui**.
- **ZONA GRIGIA**: non si distingue da un effetto piccolo a questo n; si scrive di quanto manca.
- **EFFETTO**: c'e' qualcosa oltre il caso e oltre una linea qualsiasi, su queste coppie. **Non** vuol dire che si
  guadagna: servirebbe un'altra misura con stop, target e costo.
- **NON ANCORA MISURATO**: manca il campione, non il risultato. Si dice cosa manca e quanto costa averlo.
- **CONTRARIO**: il prezzo tende a sfondare la 200 al primo tocco piu' di quanto faccia una linea qualsiasi.

---

*Fonti nel repo (tutte lette prima di scrivere):* `report/EMA200_RIMBALZO_CRITERI_2026-10-01.md`,
`report/EMA200_RIMBALZO_MISURA_2026-10-01.md`, `report/EMA200_D1_SU_M5_CRITERI_2026-10-02.md`,
`report/EMA200_D1_SU_M5_MISURA_2026-10-02.md`, `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`,
`backtest_pipeline/ema200_rimbalzo.py`, `backtest_pipeline/ema200_d1_su_m5.py`, `backtest_pipeline/oro_m1_histdata.ps1`,
`README` del mirror FutureSharks (elenco dichiarato: AUD_JPY, AUD_USD, EUR_USD, GBP_USD, USD_CAD; la sonda ha trovato
in piu' EUR_JPY).

---

## ERRATA 1 (03/10/2026, ore ~10:10 UTC, PRIMA di aprire qualunque file di prezzi): unita' del G-DATI

**Difetto trovato rileggendo la sez. 2.4 prima di scrivere il codice, non dopo aver visto numeri.** La sez. 2.4 dice
"coppia-ANNO con meno del 50% della mediana delle barre M1". Il mirror finisce a **2020-05**: l'anno 2020 ha 5 mesi
(~40% di un anno pieno) e per sei coppie su sei verrebbe **escluso alla lettera**, buttando 5 mesi di dati
completi. Non e' l'intento (l'intento e' scartare i tratti con dati dimezzati).
**Correzione congelata:** l'unita' del G-DATI e' la **coppia-MESE di calendario UTC**. Un mese con **meno del 50%
della mediana dei mesi della stessa coppia** (barre M1) e' un mese **ESCLUSO dagli eventi** (si scartano i primi
tocchi il cui minuto cade in quel mese), con elenco per nome nel referto. Il mese di ESTREMO della serie (primo e
ultimo mese del feed) e' escluso dal confronto solo se parziale per costruzione di calendario (mese in corso al
momento della pubblicazione): sul mirror nessuno, perche' 2005-01 e 2020-05 hanno file completi per la loro
estensione dichiarata (il file 2020-05 e' comunque soggetto alla regola se ha < 50%). **Vale per gli eventi
della serie vera; i surrogati sono costruiti dall'intera serie e non sono toccati** (dichiarato: se il G-DATI non
esclude nulla, la cosa e' nulla). Nessun'altra regola cambia.
