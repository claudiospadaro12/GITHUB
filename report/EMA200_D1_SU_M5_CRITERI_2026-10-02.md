# La EMA200 del D1 letta su barre M5 / M15 / H1: CRITERI CONGELATI (02/10/2026)

> **Scritto e committato PRIMA di qualunque numero su dati veri.** Mandato della notte 01/02-10 (Claudio dorme:
> _"pensateci voi"_). Nasce da `report/SCHEDA_LIVE_PAOLO_2026-10-01.md` (punto 1 e proposta M1: Paolo usa la
> **EMA200 del D1 disegnata come linea su un grafico M5**) e chiude il buco dichiarato da
> `report/EMA200_RIMBALZO_MISURA_2026-10-01.md` sez. 0-bis, riga "EMA200 di un TF SUPERIORE guardata su un grafico
> piu' basso: **NO**". Estende SOLO quel caso.
> Strumento: `backtest_pipeline/ema200_d1_su_m5.py` (MARCATORE_EMA200_D1_SU_M5_v1), che riusa lettura dei feed,
> orologio, ATR, Wilson, regimi e sintetici di `backtest_pipeline/ema200_rimbalzo.py` (MARCATORE_EMA200_RIMBALZO_v1,
> criteri `report/EMA200_RIMBALZO_CRITERI_2026-10-01.md`, commit `c23bfe61`). Referto:
> `report/EMA200_D1_SU_M5_MISURA_2026-10-02.md`; archivio `backtest_pipeline/risultati_archivio/EMA200_D1_M5_2026-10-02/`.
> **Non e' un backtest**: niente PF, niente equity, niente costo dentro la P. Non tocca EA, preset, sedie, conti,
> terminali. Zero Strategy Tester, zero VPS, nessuna riga di lancio. Il numero NON va a Claudio prima di un cancello
> indipendente.
> Dove questo file tace, valgono alla lettera i criteri del 01/10 (stesse definizioni, stesse soglie).

---

## 0. La domanda

**"La EMA200 del D1, tracciata come linea su un grafico M5, respinge il prezzo che la tocca per la prima volta
piu' di quanto farebbe una linea lenta qualsiasi collocata a caso rispetto alla giornata?"** (Paolo, live del
01/10, r.21-31: "metti una linea sulla media 200", "rimbalza subito e torna indietro"; ordine limite sulla linea.)

- **H1 (rimbalzo)** e **H2 (ritest dopo lo sfondamento)** come nei criteri del 01/10, sez. 3 e 4, con UNA sola
  differenza: la linea non e' la EMA200 del TF di lettura ma la **EMA200 delle chiusure D1**.
- H3 (gradiente) NON e' oggetto di questa misura: il confronto con la EMA200 del TF di lettura (gia' misurata il
  01/10) e' una tabella descrittiva.

Unita' = **EVENTO** (un primo tocco, uno sfondamento). Si dichiara SEMPRE anche quanti **giorni** distinti li
contengono (sez. 6.4).

---

## 1. Dati, feed, fuso, finestre (gli stessi del 01/10, nessun feed nuovo)

| dataset | feed | M1 disponibili | eventi possibili DAL (dopo 600 giorni D1 di riscaldamento) | ruolo |
|---|---|---|---|---|
| DAX (`D30EUR`) | HistData `GRXEUR` (mirror FutureSharks), ora NY -> UTC | 2010-11-15 -> 2018-12-28 | ~primavera 2013 -> 2018-12 (~5,7 anni) | principale |
| Oro A (`XAUUSD`) | Oanda `XAU_USD` (mirror FutureSharks), UTC | 2006-03-19 -> 2020-05-14 | ~estate 2008 -> 2020-05 (~11,8 anni) | principale |
| Oro B (`XAUUSD`) | HistData in repo, portato in UTC | 2021-01-03 -> 2026-09-18 | ~primavera 2023 -> 2026-09 (~3,4 anni) | gemello di FEED dell'oro A (mai concatenati, R80) |
| S&P (`SPXUSD`) | HistData `SPXUSD`, ora NY -> UTC | 2010-11-14 -> 2018-12-31 | ~primavera 2013 -> 2018-12 | **SECONDARIO** (mandato) |
| Nasdaq, Dow | -- | non raggiungibili da questa sessione (sez. 9 del referto 01/10) | -- | **NON MISURATI** |

- **Cache**: gli `.npz` M1 gia' costruiti dalla corsa del 01/10 (`m1_<DATASET>.npz`, stessa funzione
  `carica_dataset`); se mancano si riscaricano dal mirror con la stessa funzione.
- **Cancello d'orologio (G-OROLOGIO), bloccante per simbolo**: la funzione del 01/10, con le ancore del 01/10
  (DAX 07:00/08:00/13:30/14:30 UTC; oro 13:30/15:00 UTC). **S&P: l'ancora 15:00 UTC (= 10:00 NY, dati delle
  10:00) e' dichiarata QUI, prima**, perche' il 01/10 il cancello con le sole 13:30/14:30 era fallito per l'ancora
  mancante con spostamento stagionale esatto (classe 1036). L'S&P resta comunque **lettura secondaria** (mandato).
  **Qui l'orologio conta piu' che il 01/10**: il livello dipende dalle chiusure D1, quindi un errore di fuso
  sposta la linea su TUTTI i TF di lettura, non solo su H4/D1 (autotest T8).
- **Filtro di qualita' del feed, dichiarato PRIMA (classi 1037, 1054)**: un evento si scarta se l'ATR(14) del TF
  di lettura che lo misura (barra chiusa precedente per H1, barra di sfondamento per H2) e' **< 0,1 x la mediana**
  dell'ATR di quel TF sul dataset (giorni dopo il riscaldamento). Uguale per tutti i dataset; nella separazione
  (distanza >= 1 ATR) una barra con ATR sotto soglia conta distanza 0 (mai "lontana"). I surrogati usano la
  stessa soglia (mediana del vero). Il referto scrive quante barre ed eventi tocca.
- **Regime**: anno solare etichettato dal rendimento close-to-close, TORO >= +10%, ORSO <= -5%, LATERALE in mezzo
  (identico al 01/10). "Crollo": buco dichiarato.

## 2. Il GIORNO D1 e il LIVELLO

### 2.1 Il giorno
- **Giorno = giorno di calendario sull'orologio UTC+1 fisso** (= BCM di oggi, `report/OROLOGIO_BCM_2026-09-24.md`),
  come il D1 del 01/10, **con i minuti di sabato e domenica attribuiti al lunedi'** (niente barre D1 domenicali
  di un'ora: la EMA200 avrebbe ~6 barre a settimana invece di 5 e sarebbe un'altra linea). Il referto scrive
  quanti minuti di weekend sposta.
- **Sensibilita' dichiarata (solo per la variante FERMA)**: giorno che chiude alle **17:00 di New York**
  (= mezzanotte di un server UTC+2/+3 con l'ora legale USA, la convenzione FTMO). E' descrittiva: dice quanto il
  risultato dipende da DOVE cade la chiusura D1, che e' diversa da broker a broker.

### 2.2 Il livello: EMA200 sulle chiusure D1 (alpha = 2/201, seme = primo close), tre varianti
Sia `E_i` = EMA200 dopo la chiusura del giorno i. Per una barra k del TF di lettura nel giorno i:
- **FERMA (PRIMARIA, unica che decide)**: la linea per tutta la giornata i e' `E_{i-1}` (ultimo giorno CHIUSO),
  costante. E' "la linea sul grafico M5 aggiornata alla chiusura del giorno".
- **VIVA (descrittiva, "con la barra D1 in formazione")**: la linea alla chiusura della barra k vale
  `EV_k = E_{i-1} + alpha x (close_k - E_{i-1})` (il close della barra di lettura fa da close provvisorio del
  giorno); la linea con cui si giudica il contatto della barra k e' `EV_{k-1}` (nota prima della barra k). E' quello
  che registra un indicatore MTF che campiona la D1 alla chiusura di ogni barra M5.
- **RIDIPINTA (contro-esempio, LOOK-AHEAD dichiarato, non decide niente)**: la linea della giornata i e' `E_i`,
  il valore FINALE del giorno, che contiene la chiusura del giorno stesso. E' quello che disegna un grafico
  STORICO con un indicatore MTF che ridipinge: serve a dire quanto un occhio che guarda lo storico vede una linea
  diversa da quella che c'era.

**Algebra scritta prima (e' parte del contro-esempio)**: una linea viva aggiornata tick per tick vale
`E_{i-1} + alpha x (p - E_{i-1})`, e il prezzo p la tocca quando `p = E_{i-1} + alpha (p - E_{i-1})`, cioe'
**esattamente quando p = E_{i-1}**: il tocco della linea viva tick per tick COINCIDE con quello della FERMA.
La VIVA campionata alla barra differisce dalla FERMA di `alpha x (close_{k-1} - E_{i-1})`, cioe' ~1% della
distanza del close precedente dalla linea (con il prezzo a 10 ATR M5 dalla linea: 0,1 ATR). **Quindi "ferma" e
"in formazione" devono dare quasi gli stessi eventi**: se divergono molto, e' un difetto dello strumento.

### 2.3 Placebo di livello (stessi dati, stessa geometria, alla FERMA)
EMA100, EMA150, EMA250 e SMA200 **sulle chiusure D1**. **Novita' rispetto al 01/10** (rilievo del cancello del
01/10, sez. 5): **i placebo hanno i LORO surrogati**, quindi un effetto e un verdetto propri (descrittivi).

### 2.4 ATR e riscaldamento
- ATR(14) = media SEMPLICE del true range, **del TF di lettura** (M5, M15, H1), come il 01/10. Livello e ATR
  congelati all'evento (L = linea della barra di contatto; A = ATR della barra chiusa precedente).
- **Riscaldamento**: nessun evento nei primi **600 giorni D1** di ogni dataset (peso del seme e^-6 = 0,25%).
- TF di lettura: **M5, M15, H1**. Barre costruite dentro il giorno (bordi a multipli del TF dalla mezzanotte
  UTC+1; una barra non attraversa mai due giorni).

## 3. Eventi ed esiti (identici al 01/10, sez. 3 e 4, con la linea D1)

- **H1**: barra pulita sopra = `low_j > linea_j`; armato sopra alla barra k = le **20** barre k-20..k-1 tutte
  pulite sopra e almeno una con `(close_j - linea_j)/ATR_j >= 1,0`; **primo tocco** = barra armata con
  `low_k <= linea_k`; minuto del tocco = primo M1 di k con `low <= L`. Esiti sui minuti M1, livello e ATR congelati:
  B (rimbalzo `high >= L + X A`, dal minuto DOPO il tocco), P (sfondamento `low <= L - Y A`, gia' nel minuto del
  tocco), AMB, TO entro la fine della barra k+19. Specchio per il lato short. **Lati separati, sempre.**
- **Celle**: X in {0,25; 0,5; 1,0} x Y in {0,5; 1,0}. **PRIMARIA: X = Y = 1,0 (null 0,500), l'unica che decide.**
  Cella della collega (0,25; 1,0), null 0,800: descrittiva.
- **H2**: regime "sopra" = ultime 20 chiusure del TF sopra la linea; sfondamento = `close_k <= linea_k - 0,5 ATR_k`
  a regime stabilito; esiti dalla barra k+1: RT (ritest a `L - 0,10 A`) contro RA (fuga a `L - 1,5 A`), AMB, TO
  entro 20 barre; "gia' scappati" (d0 >= 1,5) contati RA. Null per evento `(1,5 - d0)/(1,5 - 0,10)`.
  L'implementazione e' a salti (piu' veloce) e DEVE dare gli stessi eventi del ciclo del 01/10 (autotest T9).
- **Sottoinsiemi** (tutti con i loro surrogati; il verdetto si legge solo su TUTTO):
  - **PRIMO_GIORNO**: solo il primo evento della giornata per lato (la situazione dell'ordine limite lasciato la
    sera prima, live 01/10 r.131; e la risposta alla dipendenza intragiornaliera);
  - **SENZA_GAP / SOLO_GAP**: "tocco in gap d'apertura" = il tocco avviene nel PRIMO minuto della PRIMA barra della
    giornata e l'apertura di quel minuto e' gia' oltre la linea (il prezzo ha scavalcato la linea di notte);
  - **SENZA_TONDI / SOLO_TONDI**: la linea dista <= 0,25 ATR (TF di lettura) da un numero tondo: **DAX multipli di
    100 punti, S&P di 50, oro di 10 $** (griglie fissate qui);
  - regimi TORO / LATERALE / ORSO (cella primaria).

## 4. I null

- **N0 analitico**: come il 01/10 (0,500 alla primaria, 0,800 alla collega; H2 per evento). Non e' il riferimento
  del verdetto (grana M1, minuti violenti: misura 01/10 sez. 7).
- **N1 surrogato a blocchi di GIORNI INTERI (IL riferimento del verdetto)**: si permutano i giorni (ogni giorno
  tiene tutti i suoi minuti, in ordine, con il minuto-del-giorno originale); i prezzi si ricostruiscono dai
  rendimenti log minuto per minuto (gap d'apertura compresi); EMA D1, ATR, barre ed eventi si RICALCOLANO sul
  surrogato. **200 surrogati** per dataset (stessi per tutte le varianti e i placebo), seme fisso.
  - **Perche' il giorno e NON 40 barre del TF (classe 1034 applicata nel verso giusto)**: il blocco deve essere
    CORTO rispetto alla memoria della relazione da rompere. Qui la relazione e' prezzo / EMA200 **D1**, memoria
    ~100 giorni: un blocco di 1 giorno e' l'1% della memoria, e la rompe. In piu' il giorno intero CONSERVA quello
    che non e' della linea e che, se rotto, potrebbe fingere un effetto: la forma intraday (apertura, sessioni,
    dati delle 14:30), i **giorni di trend**, i **gap d'apertura**, la volatilita' del giorno. Il blocco di 40
    barre M5 (200 minuti) del 01/10 spezzerebbe la stagionalita' intraday: il 01/10 l'inclinazione +0,016 a M5
    "non e' separabile" proprio per questo.
  - Conserva: deriva totale, volatilita' e sua forma intraday, giorni di trend, gap, grana M1.
  - Rompe: dove la EMA D1 cade rispetto al percorso della giornata.
  - Limite dichiarato: rompe anche la persistenza fra giorni consecutivi (trend di piu' giorni, raggruppamento
    della volatilita' su settimane). Un effetto "della 200" e un effetto "dei trend di piu' giorni" non sono
    separabili da questo null; la regola dei due lati e i placebo restano le guardie.
- **N2 placebo** (sez. 2.3), ora con surrogati propri.

## 5. L'IC (cambia rispetto al 01/10, e il perche')

Con una linea D1 quasi ferma nella giornata, **piu' eventi dello stesso giorno NON sono indipendenti** (stessa
giornata, stessa linea, stessa volatilita'). Quindi:
- si riportano **n eventi** e **n giorni** distinti;
- **IC del verdetto = il PIU' LARGO fra Wilson 95% e bootstrap a grappoli per giorno** (2.000 repliche, percentili
  2,5-97,5, seme fisso). Entrambi nel CSV.

## 6. Criteri di lettura (identici al 01/10 sez. 7, con l'IC della sez. 5)

Per ogni (dataset, TF, lato), cella primaria, variante FERMA, sottoinsieme TUTTO:
- **n < 150** -> **NON ANCORA MISURATO** (si scrive n e n giorni).
- **EFFETTO**: `P > p97,5 surrogati` e `effetto >= +0,05` e estremo basso dell'IC > mediana surrogati.
- **CONTRARIO**: specchio.
- **NULLO**: `|effetto| < 0,03` e P dentro [p2,5; p97,5] e semi-ampiezza IC <= 0,06.
- altrimenti **ZONA GRIGIA** (si dice di quanto e perche').

Sul FENOMENO, per TF (DAX e oro sono i due simboli; oro A e oro B sono gemelli di FEED dello stesso simbolo;
S&P secondario non e' necessario ne' sufficiente):
- **H1/H2 VERO** solo se EFFETTO su **DAX e oro** (almeno un feed), **tutti e due i lati**, segno concorde in ogni
  classe di regime con n >= 150, e i placebo NON lo riproducono (placebo con verdetto proprio EFFETTO = effetto di
  una linea lenta qualsiasi).
- **SENZA CONTENUTO (dentro il null)** se NULLO su tutte le celle con n >= 150 di quel TF, con DAX e oro misurati.
- altrimenti **NON ANCORA MISURATO**, con l'elenco di cosa manca. Le parole "morto" e "vero" senza n, IC, null e
  gemelli non si usano.
- **Forma forte** (P >= 0,75 alla primaria, la frase di Paolo presa alla lettera): **ESCLUSA** per una cella con
  n >= 150 se l'estremo alto dell'IC del verdetto e' < 0,75.

### 6.1 Banda contro l'ipotesi ALTERNATIVA (classe 178)
- Paolo alla lettera ("rimbalza subito e torna indietro") predice **P >= 0,75** alla primaria contro un null
  ~0,45-0,50 (il null vero a M5 e' sotto 0,50: minuti violenti, 01/10): effetto **>= +0,25**. Con n = 150 la
  semi-ampiezza dell'IC e' ~0,08-0,10: le due ipotesi **non cadono nella stessa banda**, la misura le separa.
- Una forma DEBOLE (+0,05) **non e' separabile** con questi campioni: servirebbero ~1.500 eventi per lato
  [DERIVATO: semi-ampiezza 0,025]. Se esce ZONA GRIGIA si scrive cosi', non "morto".

### 6.2 Lettura AGGREGATA (secondaria, dichiarata qui)
Per ogni TF, lato e variante: si sommano gli eventi di **DAX + oro A + oro B** (giorni diversi: nessun evento
contato due volte) e, separatamente, **+ S&P**; il surrogato aggregato i-esimo e' la somma dei surrogati i-esimi.
Stesse soglie. Serve a dire se "da nessuna parte c'e' un rimbalzo grosso" con un campione piu' largo; **non** puo'
dare VERO (le regole dei gemelli e dei due lati restano per simbolo), e un suo EFFETTO e' un **indizio** da
rimisurare per simbolo.

### 6.3 Confronto con la EMA200 del TF di lettura (descrittivo)
Stessi dataset e TF: P della EMA200 D1 (FERMA) accanto alla P della EMA200 del TF del 01/10 (CSV in
`risultati_archivio/EMA200_RIMBALZO_2026-10-01/`). Nessun verdetto: dice se la D1 e' "piu' forte" della linea
del grafico.

---

## 7. Contro-esempi: cosa farebbe sembrare vero un effetto senza esserlo

| contro-esempio | che cosa produrrebbe | come e' coperto |
|---|---|---|
| **La EMA D1 e' quasi ferma nella giornata**: la distanza dal livello e' una funzione LENTA; il "primo tocco dopo 20 barre pulite" su M5 e' il prezzo che arriva su una linea orizzontale qualsiasi | eventi in grappoli negli stessi pochi giorni; un IC "da n eventi" troppo stretto; un effetto di "linea orizzontale" scambiato per un effetto "della 200" | n giorni dichiarato; IC a grappoli per giorno (sez. 5); N1 a giorni interi (la linea del surrogato e' anch'essa lenta e orizzontale); placebo con surrogati; sottoinsieme PRIMO_GIORNO |
| **Giorni di trend** | il giorno che scende dritto attraversa la linea e prosegue: P bassa contro N0 (sembra "la 200 non tiene" o, al contrario, i giorni laterali la fanno sembrare "forte") | N1 a giorni interi conserva ogni giorno di trend com'e' (cambia solo dove cade la linea); autotest T5: serie con giorni di trend e gap, nessun livello -> contro N0 puo' scostarsi, contro N1 NON deve uscire EFFETTO/CONTRARIO |
| **Gap d'apertura** | la linea "toccata" mentre il mercato e' chiuso: il primo minuto e' gia' oltre; un ordine limite si riempie all'apertura, peggio del livello | flag `gap`; righe SENZA_GAP e SOLO_GAP con surrogati propri; N1 conserva i gap. Attesa: 2-15% degli eventi |
| **Numero tondo** | la linea cade su 12.000 DAX o 1.300 $: il rimbalzo e' del tondo, non della 200 | flag `tondo` (sez. 3), righe SENZA_TONDI / SOLO_TONDI. Aritmetica scritta prima: la finestra di +/-0,25 ATR copre ~3-5% della griglia (DAX: ATR M5 ~8,7 pt [01/10], 4,4/100; oro: 0,37/10 $), quindi i tondi pesano su ~3-5% degli eventi e non possono spostare la P di piu' di ~0,02-0,03 |
| **Fuso / chiusura D1 sbagliata** | un'altra linea, eventi "puliti e falsi" | G-OROLOGIO bloccante; autotest T8 (feed spostato di 1 h -> eventi diversi); sensibilita' NYCLOSE |
| **Look-ahead della linea** | usare la EMA del giorno stesso (che contiene la chiusura di oggi) | FERMA = `E_{i-1}`; autotest T7 (cambiare il giorno i non sposta la linea dei giorni <= i; cambia quella del giorno i+1); RIDIPINTA misurata a parte come contro-esempio |
| **Weekend: barre D1 domenicali** | un'altra EMA (6 barre a settimana) | weekend -> lunedi' (sez. 2.1), autotest T12; il referto conta i minuti spostati |
| **Feed piatto (Oanda)** | ATR ~0 -> distanze infinite, R enormi | filtro dichiarato (sez. 1), autotest T14 |
| **Soglie asimmetriche** | 0,80 dal nulla alla cella (0,25; 1,0) | verdetto solo sulla primaria simmetrica |
| **Strumento cieco (classe 1014)** | "nessun effetto" perche' lo strumento non lo vede | autotest T3: rimbalzo PIANTATO alla EMA200 D1 deve uscire EFFETTO contro N1 a giorni |
| **Molti confronti** | ~5% delle righe oltre p97,5 per caso | il verdetto e' solo sulla primaria TUTTO FERMA; le altre righe sono descrittive; regimi e sottoinsiemi non promuovono niente |
| **Deriva** | lato long favorito in finestra toro | lati separati; N1 conserva la deriva |

### 7.1 Quanti eventi attesi per anno (scritto prima, dal random walk dell'autotest preliminare)
Su un random walk M1 di ~24,6 anni utili (6.400 giorni feriali dopo il riscaldamento) lo strumento ha trovato, alla
FERMA, **~23 primi tocchi per lato per anno a M5 (560 / 570), ~13 a M15 (338 / 318), ~6 a H1 (176 / 132)**, in
~16 giorni distinti per lato per anno a M5 [MISURATO sul sintetico, non sul mercato]. Sui dataset veri questo da':
- **M5**: DAX ~140 per lato (5,7 anni), oro A ~280, oro B ~80, S&P ~140 (meno se gli anni toro 2013-2017 tengono il
  prezzo lontano dalla linea);
- **M15**: circa la meta'; **H1**: circa un quarto.
**Attesa: n >= 150 per lato quasi solo sull'oro A a M5 (forse M15) e forse sul DAX a M5; H1 NON ANCORA MISURATO
ovunque.** Quindi il verdetto sul FENOMENO quasi certamente sara' **NON ANCORA MISURATO** per mancanza di gemelli
con n >= 150; la lettura aggregata (6.2) e' il modo dichiarato per avere comunque un numero su ~500+ eventi.

---

## 8. Autotest (tutti PASS prima dei dati veri, altrimenti codice 2 e nessun numero)

| # | prova | soglia |
|---|---|---|
| T12 | sabato e domenica sera hanno l'etichetta del lunedi'; il giorno NYCLOSE cambia alle 17:00 NY | uguaglianza |
| T1 | random walk M1 (solo giorni feriali, ~7.000 giorni), FERMA, M5: n primaria (due lati) >= 1.000; P per lato entro 0,500 +/- 0,04 | come scritto |
| T2 | stesso random walk, M5/M15/H1, H1 e H2: **nessun EFFETTO ne' CONTRARIO** contro N1 a giorni | nessun falso positivo |
| T6 | FERMA contro VIVA sul random walk: eventi in comune fra l'85% e il 100% escluso (vicine per l'algebra di sez. 2.2, ma lo strumento le distingue) | come scritto |
| T3 | **rimbalzo PIANTATO** alla EMA200 D1 FERMA (spinta di ritorno di 0,6 sigma/minuto quando il prezzo e' entro 0,15 ATR M5 dalla linea dal lato di provenienza, ~7.000 giorni), M5: **effetto >= +0,10 e EFFETTO** contro N1, due lati. Stampa (senza soglia) cosa vede il placebo EMA100 | come scritto |
| T5 | **giorni di trend + gap** senza alcun livello (deriva giornaliera N(0; 0,03 sigma/min), gap d'apertura N(0; 10 sigma)), M5/M15: **nessun EFFETTO ne' CONTRARIO** contro N1; si stampa lo scarto da N0 | nessun falso positivo |
| T7 | look-ahead: cambiare il giorno i non tocca la FERMA dei giorni <= i e tocca quella del giorno i+1; la VIVA di contatto della barra k non dipende dalla barra k ma quella della k+1 si' | uguaglianza / differenza |
| T8 | feed spostato di +60 minuti: gli eventi FERMA M5 cambiano | differenza |
| T9 | H2 a salti == ciclo di `ema200_rimbalzo.eventi_h2` (EMA del TF, stesso input, filtro spento) | identita' evento per evento |
| T10 | H1 == `ema200_rimbalzo.eventi_h1` (6 celle) sullo stesso input | identita' |
| T11 | il surrogato conserva l'escursione di ogni giorno e il minuto del giorno | identita' |
| T13 | mutazione: X 1,0 -> 0,25 sposta P di > 0,15 | come scritto |
| T14 | un tratto piatto di 3 giorni nel feed non produce eventi con ATR sotto il filtro | nessuno |

**Cambio di soglia dichiarato, fatto PRIMA dei dati veri (solo sintetici):** la prima stesura di T3 chiedeva
"P >= 0,70 e EFFETTO" (soglia ripresa dal piantato H1 del 01/10, dove il piantato dava 0,92). Alla prova
preliminare il piantato a M5 sulla linea D1 da' **P 0,627 / 0,656 contro surrogati 0,503 / 0,495, verdetto EFFETTO
su tutti e due i lati** (n 561 / 573), mentre il placebo EMA100 sullo stesso sintetico da' 0,495 / 0,504 NULLO.
Lo strumento VEDE il piantato e lo attribuisce alla linea giusta; la soglia 0,70 misurava la forza del piantato,
non la vista dello strumento. Sostituita con "effetto >= +0,10 e EFFETTO" (il piantato e' di +0,12 / +0,16): e'
una prova PIU' severa della vista (un effetto piu' piccolo deve uscire). Nessun dato vero era stato caricato.
Prova preliminare completa: 34/36 (le 2 cadute = questa soglia), random walk M5 0,498 / 0,484 (n 560 / 570, 396 /
383 giorni) NULLO, M15 0,494 / 0,506 NULLO; giorni di trend + gap: scarto da N0 -0,044..-0,094, contro N1 nessun
EFFETTO/CONTRARIO; FERMA/VIVA in comune 94,5-95,3%.

Se un autotest fallisce per RUMORE (campione piccolo) si alza il campione, mai la tolleranza (classe 1035), e lo
si dichiara.

## 9. Attese dichiarate (prima dei numeri, con il perche')

- **E1 (primaria, FERMA)**: effetto contro N1 entro +/-0,05 dove n >= 150; P fra 0,40 e 0,55; **forma forte
  ESCLUSA** dove n >= 150. Perche': il 01/10 la EMA200 del TF non respinge (P 0,40-0,55) e la D1 sul grafico basso e'
  "una linea orizzontale lenta"; e i minuti violenti al tocco (9-23% a M5) non dipendono dalla linea.
- **E2 (campione)**: sez. 7.1. Verdetto sul fenomeno NON ANCORA MISURATO per gemelli insufficienti; aggregato
  con n >= 300 per lato a M5.
- **E3 (FERMA contro VIVA)**: eventi in comune >= 90%, |delta P| <= 0,03 per cella.
- **E4 (RIDIPINTA)**: |delta P| <= 0,03 dalla FERMA (la ridipintura sposta la linea di alpha x (C_i - E_{i-1}),
  pochi decimi di ATR M5).
- **E5 (cella della collega)**: 0,65-0,80, sotto il random walk come il 01/10.
- **E6 (H2)**: P_RT vicino al null per evento e ai surrogati (+/-0,05).
- **E7 (gap)**: 2-15% degli eventi M5 (DAX e S&P di piu', oro di meno); **E8 (tondi)**: 3-5%.
- **E9 (placebo)**: P della 200 entro +/-0,03 dalla forbice dei placebo; nessun placebo EFFETTO.
- **E10 (NYCLOSE)**: verdetti invariati; P entro +/-0,03.
- Se l'effetto esce pulito, oltre la banda, su DAX e oro, due lati, assente nei placebo: **e' un risultato vero e
  si scrive come tale.**

## 10. Che cosa NON fa questa misura (dichiarato prima)

Niente PF, niente gestione dell'uscita (parziale, pari, trailing: e' li' che il 01/10 sospetta stia il guadagno
della sedia 771531), niente ordine limite "uno prima e uno dopo" la linea (V8 della scheda Paolo), niente esito
in ADR(50 gg), niente evento "apertura entro 0,3 ADR dalla linea" (proposta M1 della scheda), niente filtro
"ostacolo" sulle aperture DAX (M2), niente sessione cash separata dalla notte, niente Nasdaq/Dow/feed BCM, niente
spread S&P. Non sceglie parametri per nessun EA, non promuove ne' archivia sedie, non tocca rischio e taglie.
