# EMA200 e il RIMBALZO come FENOMENO: CRITERI CONGELATI (01/10/2026)

> **Scritto e committato PRIMA di qualunque numero su dati veri.** Mandato di Claudio, 01/10/2026 sera:
> _"SI PARTI, CON INDICI E ORO"_. Parte da `report/EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md` sez. 5
> (disegno proposto) e lo rende OPERATIVO, con le modifiche dichiarate in sez. 9.
> Strumento: `backtest_pipeline/ema200_rimbalzo.py`. Referto: `report/EMA200_RIMBALZO_MISURA_2026-10-01.md`.
> Non e' un backtest: niente PF, niente equity, niente costo dentro la P. Non tocca `ABTG_EMA200.mq5`,
> preset, sedie, conti, terminali. Zero passate di Strategy Tester, zero VPS.

---

## 0. Le tre domande (di Claudio e della collega)

- **H1 (rimbalzo)**: dopo il PRIMO tocco della EMA200, il prezzo si allontana dal lato da cui e' arrivato
  PRIMA di sfondare dall'altra parte.
- **H2 (ritest)**: uno sfondamento della EMA200 torna a ritestarla PRIMA di proseguire.
- **H3 (gradiente)**: su M1/M5 la EMA200 "non e' forte", sui TF alti si'.

Unita' = **EVENTO** (un tocco, uno sfondamento), mai il trade, mai l'anno.

---

## 1. Dati, feed, fuso, finestre (dichiarati prima)

| simbolo casa (FTMO) | feed usato qui | finestra | fuso del file | stato |
|---|---|---|---|---|
| D30EUR (GER40) | HistData `GRXEUR` via `raw.githubusercontent.com/FutureSharks/financial-data` (GPL-3.0) | 2010-11-15 -> 2018-12-28 | ora locale New York (EST/EDT) | MISURABILE oggi |
| SPXUSD (US500) | HistData `SPXUSD`, stessa fonte | 2010-11-14 -> 2018-12-31 | ora locale New York | MISURABILE oggi |
| XAUUSD feed A | Oanda `XAU_USD`, stessa fonte | 2006-03-19 -> 2020-05-14 | UTC (collaudato 10/09, `ORO_1530_DISEGNO_MISURA` sez. 1.3) | MISURABILE oggi |
| XAUUSD feed B | HistData, zip in repo `risultati_prove/oro_m1_histdata_zip/` portati in UTC da `histdata_oro_verso_utc.py` | 2021-01-03 -> 2026-09-18 | UTC (gia' convertito) | MISURABILE oggi |
| NASUSD (US100) | HistData `NSXUSD`: **404** sul mirror; il CSV vive solo sul PC di backtest (`%USERPROFILE%\abtg_storico_indici\NASUSD_M1.csv`, Formato 1, ora NY) | 2010-2026 | ora NY | **NON RAGGIUNGIBILE da qui**: lo strumento lo legge (`--formato f1 --fuso NY`), la corsa va fatta sul PC con una riga che passa dal cancello |
| U30USD (US30) | **nessun feed esterno esiste** (stato dell'arte 5.4); BCM solo dal 2024.09.26 | -- | -- | **NON MISURABILE oggi** (serve un export M1 BCM; nessuno strumento d'export collaudato in repo) |

Regole del feed: **mai concatenare due feed** (A e B dell'oro restano separati; R80 insegna che il feed
cambia il segno). Tutto viene portato in **UTC**; poi le barre del TF si costruiscono sull'orologio
**UTC+1 fisso** (= orologio BCM di oggi, `report/OROLOGIO_BCM_2026-09-24.md`), bordi a multipli del TF
dalla mezzanotte UTC+1; D1 = giorno di calendario UTC+1.

Conversione NY -> UTC: +5 h quando New York e' in EST, +4 h in EDT (regola USA dal 2007: seconda domenica
di marzo - prima domenica di novembre, alle 02:00 locali).

**Cancello dell'orologio (G-OROLOGIO), bloccante per simbolo**: sul minuto-del-giorno UTC con la
`|close-open|` media piu' alta, mesi di gennaio-febbraio contro giugno-agosto (fuori dalle settimane in
cui Europa e USA cambiano ora in date diverse). PASSA se il picco d'inverno cade su un'ancora attesa
(DAX: 07:00 apertura future 08:00 CET, 08:00 apertura cash 09:00 CET, 13:30 dato USA, 14:30 cash USA; SPX: 14:30 o 13:30;
oro: 13:30 dato USA o 15:00 fixing) **e** il picco d'estate cade esattamente 60 minuti prima. Se fallisce,
il simbolo esce con codice 2 e nessun numero.
Contro-esempio (perche' il cancello distingue): un file in EST FISSO convertito come se avesse l'ora legale
mette il picco estivo **120** minuti prima, non 60; un file gia' UTC trattato come NY lo mette **+60 o +0**.

**Riscaldamento**: EMA con seme = primo close; le prime **600 barre** del TF non producono eventi.

**Regime, dichiarato e MISURATO non scelto**: ogni anno solare di ogni simbolo/feed e' etichettato dal
suo rendimento close-to-close: **TORO >= +10%**, **ORSO <= -5%**, **LATERALE** in mezzo. L'anno viene dal
timestamp dell'evento. Classe "crollo" separata: **non** ricavabile con n >= 150 in queste finestre
(dichiarato come buco, sez. 8).

---

## 2. Il livello e l'ATR

- **EMA200** sul close del TF (alpha = 2/201). **ATR(14)** = media SEMPLICE del true range a 14 barre
  (come `iATR` di MT5 usato dall'EA).
- **Livello CONGELATO**: L = EMA200 della **barra chiusa precedente** all'evento; A = ATR della stessa
  barra. Nessun look-ahead: tutto e' noto prima del minuto in cui l'evento accade.
- TF misurati: **M5, M15, H1, H4, D1**. M1 non si misura come TF (e' la grana di risoluzione: vedi 6.1).

---

## 3. H1 -- definizione operativa del PRIMO TOCCO e del RIMBALZO

- **Barra pulita sopra** (j): `low_j > EMA_{j-1}` (non ha toccato la media di riferimento). Pulita sotto:
  `high_j < EMA_{j-1}`.
- **Armato sopra** alla barra k: le **N = 20** barre k-20..k-1 sono TUTTE pulite sopra, e almeno una di
  esse ha chiuso a **>= D = 1,0 ATR** dalla sua EMA (`(close_j - EMA_j)/ATR_j >= 1,0`): il prezzo era
  davvero lontano. Specchio per "sotto".
- **PRIMO TOCCO** = barra armata k con `low_k <= L` (L = EMA_{k-1}). Il **minuto del tocco** e' il primo M1
  di k con `low <= L`. Dopo un tocco, il contatore di barre pulite riparte da zero (la barra k non e'
  pulita): il tocco successivo e' "primo" solo dopo altre 20 barre senza contatto.
- **Esiti**, risolti sui minuti M1 a partire dal minuto del tocco (livello e ATR congelati):
  - **B (rimbalzo)**: `high >= L + X*A` (lato sopra), cercato dal minuto DOPO il tocco (nel minuto del
    tocco il massimo puo' essere precedente al tocco);
  - **P (sfondamento)**: `low <= L - Y*A`, cercato GIA' nel minuto del tocco;
  - **AMB**: B e P nello stesso minuto (ordine ignoto) -- riportato a parte, mai buttato;
  - **TO (timeout)**: nessuno dei due entro la fine della barra k+19 (20 barre del TF).
- **P_B = B / (B + P)**; n = B + P. Variante conservativa: AMB contate come P.
- **Lati separati, sempre** (regola dei due lati): "long" = tocco dall'alto (rimbalzo verso l'alto),
  "short" = tocco dal basso.
- **Celle**: X in {0,25; 0,5; 1,0} x Y in {0,5; 1,0}.
  - **CELLA PRIMARIA, unica che decide: X = 1,0, Y = 1,0** (simmetrica, null analitico 0,500).
  - **Cella della collega** (descrittiva): X = 0,25, Y = 1,0, null analitico **0,800**.
  - Nessuna cella e' "la migliore": il resto e' descrittivo, si riporta tutto.

## 4. H2 -- definizione operativa dello SFONDAMENTO e del RITEST

- **Regime di lato**: "sopra" e' stabilito quando le ultime **N = 20** chiusure sono tutte sopra la EMA
  (stessa barra). Specchio per "sotto".
- **SFONDAMENTO** (da sopra): prima barra k, a regime "sopra" stabilito, con `close_k <= EMA_k - b*ATR_k`,
  **b = 0,5**. Dopo uno sfondamento il regime torna "nessuno" finche' non si stabiliscono 20 chiusure
  consecutive su un lato (niente sfondamenti sovrapposti).
- Livello congelato L = EMA_k, A = ATR_k, distanza di partenza d0 = |close_k - L| / A (>= b).
- **Esiti**, sui minuti M1 dalla barra k+1 (dopo la chiusura che definisce lo sfondamento: niente look-ahead):
  - **RT (ritest)**: il prezzo torna a **L -/+ tol*A**, tol = 0,10 (sfondamento in giu': `high >= L - 0,10 A`);
  - **RA (allontanamento)**: `low <= L - Z*A`, **Z = 1,5**, senza ritest;
  - AMB nello stesso minuto; TO entro 20 barre del TF.
  - se d0 >= Z lo sfondamento e' **gia' scappato** alla chiusura: conta RA al tempo zero.
- **P_RT = RT / (RT + RA)**. Si riporta anche la quota di sfondamenti "gia' scappati".

## 5. H3 -- il gradiente

Stessi protocolli a M5, M15, H1, H4, D1 per simbolo e feed; si confronta l'**effetto** (sez. 6.4) fra TF,
non la P grezza.

---

## 6. I null (tre, e servono tutti)

### 6.1 N0 analitico (passeggiata casuale continua senza deriva)
- H1: `P_B = Y/(X+Y)` -> (1,0;1,0) **0,500** · (0,25;1,0) **0,800** · (0,5;1,0) 0,667 · (0,25;0,5) 0,667 · (0,5;0,5) 0,500 · (1,0;0,5) 0,333.
- H2: per evento `null = (Z - d0)/(Z - tol)` (0 se d0 >= Z), mediato sugli eventi veri: tiene conto della
  vera distanza di partenza. Con d0 = b = 0,5 vale 0,714 (il numero dello stato dell'arte).
- **Limite dichiarato**: N0 suppone un percorso continuo. A M5/M15 la grana M1 e' grossolana rispetto a
  X*ATR (a M5 l'ATR e' circa 2 range M1): N0 **non** e' il riferimento del verdetto, lo e' N1.

### 6.2 N1 surrogato a blocchi (IL riferimento del verdetto)
Le stesse barre M1, rimescolate a **blocchi di K = 40 barre INTERE del TF** (ogni blocco tiene i suoi minuti);
i prezzi si ricostruiscono concatenando i rendimenti log di ogni minuto rispetto al close del minuto
precedente (gap compresi); EMA, ATR ed eventi si RICALCOLANO sul surrogato.
- Conserva: deriva totale, volatilita' e suo raggruppamento entro 40 barre, autocorrelazione breve, forma
  intraday dentro il blocco, grana M1, tendenza locale fino a 40 barre.
- Rompe: la relazione fra il prezzo e la sua EMA200 (memoria media ~100 barre, > 40).
- **Numero di surrogati**: 100 a H1/H4/D1, 40 a M5/M15 (tempo macchina). Riferimento = mediana;
  banda = [p2,5; p97,5].
- **Perche' NON a blocchi di un giorno** (contro-esempio costruito prima, classe nuova 1019): a M5 la
  EMA200 ha memoria ~16 ore, cioe' MENO di un giorno: un surrogato che rimescola giorni interi CONSERVA la
  relazione prezzo-EMA dentro ogni giorno, e il null conterrebbe l'effetto che deve escludere. Il blocco
  si misura in barre del TF, non in giorni.

### 6.3 N2 placebo di livello (stessi dati veri)
EMA100, EMA150, EMA250 e SMA200 al posto della EMA200, stesso protocollo. Lettura: se una linea placebo
da' P entro +/-0,03 della EMA200, l'eventuale effetto e' "di una linea lenta qualsiasi", non "della 200".

### 6.4 L'effetto
`effetto = P_vero - mediana(P_surrogati)`. IC al 95% di P_vero con Wilson (eventi trattati come
indipendenti: sono distanti >= 20 barre per costruzione; limite dichiarato).

---

## 7. Criteri di lettura (congelati qui)

Per ogni (simbolo, feed, TF, lato), sulla **cella primaria**:
- **n < 150** -> **NON ANCORA MISURATO** (merito sospeso, Emendamento A). Si scrive n.
- **EFFETTO** (rimbalzo / ritest sopra il null): `P_vero > p97,5 surrogati` **e** `effetto >= +0,05`
  **e** estremo basso Wilson > mediana surrogati.
- **CONTRARIO**: specchio (sotto p2,5, effetto <= -0,05, estremo alto Wilson < mediana).
- **NULLO (dentro il null)**: `|effetto| < 0,03` **e** P_vero dentro [p2,5; p97,5] **e** semi-ampiezza
  Wilson <= 0,06.
- altrimenti **ZONA GRIGIA** (si dice di quanto e perche').

Verdetto sul FENOMENO (per TF):
- **H1 / H2 VERO** solo se EFFETTO su **>= 2 simboli** (gemelli) **e su tutti e due i lati**, segno
  concorde in **ogni classe di regime con n >= 150**, e il placebo NON lo riproduce (sez. 6.3).
- **H1 / H2 SENZA CONTENUTO (dentro il null)** se NULLO su tutti i simboli/lati con n >= 150 a quel TF,
  con almeno 2 simboli misurati.
- altrimenti **NON ANCORA MISURATO** con l'elenco di cosa manca. Le parole "morto" e "vero" senza n, IC,
  null e gemelli non si usano.
- **H3 CONFERMATO** solo se l'effetto (non la P) sale con il TF in modo monotono su **>= 2 simboli**, con
  differenza fra M5 e il TF piu' alto misurabile >= +0,05 e IC che non si sovrappongono. **FALSIFICATO**
  se tutti gli effetti misurabili stanno entro +/-0,03 (piatto). Altrimenti NON ANCORA MISURATO.

**Banda contro l'ipotesi ALTERNATIVA (classe 178)**, scritta prima:
- L'ipotesi della collega, presa alla lettera ("quasi sempre rimbalza"), predice sulla cella primaria
  **P_B >= 0,75** contro un null ~0,50: effetto **+0,25**, dieci volte la banda NULLO (+/-0,03). Le due
  ipotesi NON cadono nella stessa banda: la misura le separa.
- Sulla cella della collega (0,25;1,0) l'alternativa predice ~0,80-0,85 e il null **0,80**: li' "quasi
  sempre" e' gia' il random walk. Per avere contenuto serve **>= 0,85 E** sopra p97,5 dei surrogati.
- H2: il null e' ~0,6-0,7; "viene quasi sempre ritestato" ha contenuto solo sopra p97,5 dei surrogati.

Regola di casa: **centro dell'altopiano, mai il picco**: nessuna cella viene scelta dopo i numeri; il
verdetto e' sulla primaria congelata. Le celle descrittive non promuovono niente.

---

## 8. Contro-esempi: cosa lo farebbe sembrare vero SENZA esserlo (e come e' coperto)

| contro-esempio | che cosa produce | come e' coperto |
|---|---|---|
| **Soglie asimmetriche** (X piccolo, Y grande) | P alta dal nulla: 0,80 a (0,25;1,0) | N0 accanto a ogni P; verdetto sulla primaria simmetrica |
| **Deriva / trend persistente** (toro 2010-18 su DAX/SPX, oro 2024-26) | i "rimbalzi long" vincono per deriva, gli short perdono | lati separati; N1 conserva la deriva; regime per anno |
| **Raggruppamento della volatilita'** | ATR congelato ma vol che esplode dopo il tocco: B e P piu' facili | N1 conserva la vol entro 40 barre; AMB/TO riportati |
| **Mean reversion generica** (a qualunque livello) | P_B > 0,5 anche senza EMA | N1 (la conserva entro il blocco) e N2 (placebo) |
| **Grana M1 a M5/M15** | P distorta rispetto a N0 | il verdetto usa N1 (stessa grana); autotest a M5 su random walk riporta lo scarto da N0 |
| **Costo / spread** | un rimbalzo di 0,25 ATR a M5 puo' valere meno dello spread | tabella costo per TF: X*ATR mediano / spread (D30EUR 1,7676 pt, XAUUSD 0,2003 giro completo, `sonda_supertrend_segnali.py`; SPXUSD [NON MISURATO]); NON entra nella P |
| **Orologio sbagliato** | H4/D1 costruiti su bordi sbagliati, numeri "puliti e falsi" | G-OROLOGIO bloccante; autotest: spostare il feed di 1 h DEVE cambiare H4/D1 |
| **Look-ahead** | sapere lo sfondamento prima della chiusura | L e A dalla barra chiusa; H2 dalla barra dopo |
| **Surrogato a blocchi troppo lunghi rispetto alla memoria della EMA** | null che contiene l'effetto | blocchi di 40 barre del TF (6.2, classe 1019) |
| **Strumento cieco** (classe 1014) | "nessun effetto" perche' lo strumento non sa vederlo | autotest con rimbalzo PIANTATO che DEVE uscire EFFETTO, e rottura piantata che DEVE uscire CONTRARIO |

---

## 9. Autotest dello strumento (deve passare TUTTO prima dei dati veri; codice 2 se no)

1. **Random walk** M1 senza deriva, TF H1: |P_B - 0,500| <= 0,03 sulla primaria e |P_B - 0,800| <= 0,03
   sulla cella della collega (n >= 1.000); H2: |P_RT - null per evento| <= 0,04; e il verdetto contro N1
   **non** e' EFFETTO ne' CONTRARIO (niente falsi positivi).
2. **Rimbalzo PIANTATO** (una spinta di ritorno quando il prezzo e' entro 0,15 ATR dalla EMA200 dal lato
   di provenienza): P_B primaria >= 0,70 **e** verdetto EFFETTO contro N1. Uno strumento che non lo vede
   non misura.
3. **Rottura PIANTATA senza ritest** (spinta via dalla EMA dopo l'attraversamento): P_RT < 0,30 e verdetto
   CONTRARIO su H2.
4. **Orologio**: lo stesso feed spostato di 1 ora cambia il numero di eventi H4 o D1 (se resta identico lo
   strumento e' cieco al fuso). E il cancello G-OROLOGIO fallisce su un file sintetico in EST fisso.
5. **Lettura per nome**: un file Oanda con colonne `time,close,high,low,open` viene letto con l'open giusto.
6. **Mutazione**: cambiare X da 1,0 a 0,25 sposta P_B (lo strumento risponde alla manopola).
7. **Random walk a M5** (stessa grana del vero): si STAMPA lo scarto da N0 (atteso diverso da zero per
   la grana), senza soglia: e' la ragione per cui il verdetto usa N1.

---

## 10. Attese dichiarate (prima dei numeri, con il perche')

- **E1 (H1 primaria)**: effetto entro +/-0,05 su tutti i simboli/TF misurabili; verdetti per lo piu'
  NULLO o ZONA GRIGIA. Perche': nell'archivio a H4 il segno dei lati segue la deriva (stato dell'arte 2.2)
  e a finestra lunga muore (2.3).
- **E2 (cella della collega)**: P_B fra 0,75 e 0,85, cioe' vicino a 0,80 del random walk.
- **E3 (H2)**: P_RT vicino al suo null per evento e ai surrogati (+/-0,05).
- **E4 (H3)**: nessun gradiente pulito dell'effetto fra M5 e D1 (differenze entro +/-0,04); un random
  walk normalizzato in ATR e' invariante di scala.
- **E5 (lati)**: P_B grezza long > short nelle finestre toro, ma l'effetto contro N1 senza segno legato al lato.
- Se l'effetto esce pulito, oltre la banda, su due simboli e due lati e assente nei surrogati e nel
  placebo: **e' un risultato vero e si scrive come tale**.

---

## 11. Cosa NON fa questa misura

Non dice se un EA guadagna (niente PF), non sceglie parametri per `ABTG_EMA200`, non promuove ne' archivia
sedie, non tocca rischio e taglie (di Claudio). Il 69,6% dell'EA sulla sedia Dow (stato dell'arte sez. 1)
NON e' riprodotto qui: il G0 "come l'EA" richiede il Dow BCM, che non e' raggiungibile da questa sessione.
