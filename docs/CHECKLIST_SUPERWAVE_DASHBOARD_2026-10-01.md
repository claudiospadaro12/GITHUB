# SuperWave Dashboard: cosa fa, come leggerla, come usarla (checklist)
Versione analizzata: il file che Claudio ha mandato il 01/10/2026 (695 righe, `#property version "4.00"`, copia in `docs/sorgenti_ricevuti/`). **Nel repo c'e' un'altra versione con lo stesso numero** (`mql5/Indicators/ABTG_SuperWave_Dashboard.mq5`, 936 righe, con media 50, incrocio e lampeggio "dolce"): sul tuo grafico gira **quella che hai mandato** (confermato dalla tua schermata della finestra Input: niente `InpMA4` ne' `InpShowCross`). Questa checklist descrive quella.
Cosa e': un INDICATORE di sola visione. Non apre ordini, non tocca conti. Va su UN solo grafico.

## 1. Cosa vedi sul grafico (tre blocchi)
- [ ] **Griglia a sinistra** (SUPERWAVE): una riga per simbolo, una colonna per timeframe (M1, M3, M5, M15, H1, H4, D1). Bottoni in alto: CANDELE/HA, LIVELLI, ST, Nascondi.
- [ ] **Pannello in alto a DESTRA "OPERAZIONE"**: ingresso, stop, tre target con i lotti.
- [ ] **Sul grafico**: linea ingresso, linea STOP (tratteggio), TP1, TP2, TP3 (punteggiate/tratteggio) con i prezzi scritti, una freccia BUY/SELL, i tre Supertrend (3,5 / 3,0 / 2,5) e le tre medie (14 / 100 / 200).

## 2. Come leggere la GRIGLIA
- [ ] Una cella si colora **solo nel momento in cui il Supertrend 3,5 (ATR 10) si inverte** sull'ultima barra CHIUSA di quel timeframe: **verde = BUY**, **rosso = SELL**. Poi si spegne.
- [ ] **Quanto resta accesa** = durata di UNA barra di quel TF (`InpFlipBars=1`): su M1 un minuto, su H4 quattro ore. Una cella vuota NON vuol dire "nessun trend": vuol dire "nessuna inversione appena avvenuta".
- [ ] **Click su una cella** = il grafico passa a quel simbolo e a quel timeframe. **Click sul nome** = simbolo al timeframe che hai.
- [ ] Ricorda: l'inversione e' un segnale **dopo il fatto**, calcolato a barra chiusa.

## 3. Come leggere i SIMBOLI che LAMPEGGIANO (il difetto di cui parli)
- [ ] Regola nel codice: il simbolo lampeggia (verde/rosso a sfondo che si alterna ogni secondo, testo bianco) quando **la direzione del Supertrend su H4 e quella su M3 sono uguali**. NON quando c'e' una inversione: basta che vadano nello stesso verso.
- [ ] Conseguenza: a ogni istante una parte grande dei simboli (29 in lista; **stima: circa meta' se le direzioni fossero indipendenti, non misurato**) e' "in confluenza" e lampeggia **tutti insieme**. Non e' un segnale raro, e' lo stato normale. E' la causa principale del "lampeggio" che ti da' fastidio.
- [ ] Come leggerlo oggi: un simbolo che lampeggia dice solo "H4 e M3 puntano dalla stessa parte". Per un segnale vero guarda la **cella colorata** (inversione appena avvenuta) e controlla che H4 sia nella stessa direzione.
- [ ] Spegnere subito il lampeggio senza toccare il codice: Input > `InpBlink = false`.

## 4. Come leggere il PANNELLO "OPERAZIONE" e i 3 TP
- [ ] **Non e' un ordine e non e' un segnale raro.** Appare **sempre** (se `InpShowTrade=true`) sul grafico che guardi: direzione = quella del Supertrend 3,5 sull'ultima barra chiusa.
- [ ] **Ingresso** = l'ultimo prezzo (la chiusura della barra in corso): **si sposta a ogni tick**. **Stop** = il valore del Supertrend 3,5. Il **rischio R** e' la distanza ingresso-stop, quindi **anche i TP si muovono a ogni tick**.
- [ ] **TP1, TP2, TP3** = ingresso + 1R, 2R, 3R (BUY) o meno (SELL). I lotti: rischio 1% del saldo (`InpRiskPct`) diviso 40% / 30% / 30% sui tre target (`InpSize1/2/3`), arrotondati per difetto al passo del lotto; sotto il lotto minimo il valore e' 0.
- [ ] Da leggere come **"se entrassi adesso, ecco la scala"**, non come un setup fermo. Per un ordine vero usa i numeri **fissati quando clicchi/entri**, non quelli che scorrono.
- [ ] Controllo prima di usarli: il rischio in valuta scritto nel pannello e i lotti totali devono tornare con il tuo conto e con il simbolo (indici e oro hanno valori del tick diversi).

## 5. I bottoni
- [ ] **CANDELE / HA**: Heikin Ashi disegnato sopra le candele normali (non le nasconde).
- [ ] **LIVELLI**: tre resistenze e tre supporti da swing recenti (300 barre, frattale 2).
- [ ] **ST**: accende/spegne i Supertrend e le medie sul grafico.
- [ ] **Nascondi / Mostra**: nasconde la griglia.

## 6. Problemi trovati leggendo il codice: VERIFICATI uno per uno (01/10, sera)
Righe = file ricevuto. Misure = `backtest_pipeline/collaudo_superwave_v41.py` su XAUUSD M1 2021-2026 (HistData) ricampionato, algoritmi della v4.00 riscritti in Python riga per riga. Un solo simbolo: i numeri sono un ordine di grandezza, non una legge per tutti i 29.

| # | Difetto | Verifica nel codice | Esito | Nella v4.1 |
|---|---|---|---|---|
| 1 | Confluenza = stessa direzione H4/M3, non inversione | r.537 `gConfl = (dH4!=0 && dH4==dM3)`, con dH4/dM3 = direzione (r.518-520), qualunque eta' | **CONFERMATO e misurato**: simbolo "in confluenza" il **49,9%** del tempo (150.000 barre M3, 462 giorni). La "stima meta'" ora e' una misura (su 1 simbolo) | modo 1: inversione M3 entro 3 barre nel verso dell'H4 stabile = **3,1%** del tempo; modo 0 resta disponibile |
| 2 | Lampeggio che ridisegna il grafico ogni secondo | r.176-187: colore pieno/nero ogni secondo e `ChartRedraw()` **sempre**, anche senza nessun simbolo in confluenza | **CONFERMATO** | 20 s di lampeggio poi fisso; ridisegno solo se cambia un colore |
| 3 | Ricalcolo pesante nel thread del grafico | r.169-174 + r.508-547: ogni 3 s 29 x 7 = **203 CopyRates** (90 barre) e i calcoli, nel timer; gli indicatori di un simbolo condividono UN thread, quindi il lavoro blocca anche i clic | **CONFERMATO**: 4.060 CopyRates al minuto | solo a barra chiusa nuova, 6 simboli al secondo: **~47 al minuto** (85 volte meno) |
| 4 | Dati non pronti azzerano la cella | `STdir` rende 0 con meno di P+10 barre (r.442); la cella si spegne (r.530-534) e la confluenza va a 0 (r.537, 543). Nessun controllo `SERIES_SYNCHRONIZED` | **CONFERMATO** (cella che sparisce e torna). Nota: l'azzeramento SPEGNE il lampeggio, non lo accende | stato precedente tenuto, `n/d` nel tooltip con motivo e ora |
| 5 | Griglia e grafico con Supertrend diversi | griglia: ATR **Wilder** (r.449-450) su **90 barre** (r.439), seme per close/mid (r.459). Grafico: `iATR` (r.137, 229-230), seme sempre SU (r.199) | **CONFERMATO e misurato**: direzione griglia diversa dal grafico nel **4,4-7,8%** delle barre chiuse, su ogni TF; inversioni non allineate: su M3 3.298 del grafico, 1.329 non viste dalla griglia sulla stessa barra, 1.188 della griglia assenti sul grafico | stessa funzione e stesso ATR ovunque; finestra 1000 barre; aggancio misurato al massimo 146 barre (molt. 3,5) |
| 5-bis | `iATR` di MT5 e' media semplice o Wilder? | fonte: `ATR.mq5` di serie del terminale (`MQL5\Indicators\Examples`), `ATR[i] = ATR[i-1] + (TR[i] - TR[i-P]) / P` = media SEMPLICE che scorre [citata dal sorgente di serie, non riletta qui]; misura di casa NEL TESTER: `REFERTO_SONDARELATIVO_*` "ATR divergenza vs iATR: 0.0000% (atteso ~0 con SMA del TR)" su D30 e NAS M5/M15 | **CONFERMATO: SMA**, non Wilder | la 4.1 usa la SMA del TR in tutti e tre i punti |
| 6 | Operazione col prezzo corrente come ingresso | r.276 `entry=close[rt-1]`; stop = Supertrend dell'ultima barra chiusa (r.262); direzione dal TF del grafico (r.275) | **CONFERMATO**: tick per tick su M5, l'ingresso cambia dentro **11.079 barre su 11.091** | ingresso FISSO alla chiusura della barra di inversione; 0 cambi dentro le barre, 0 fuori dalle inversioni (264 cambi) |
| 7 | I tasti ricaricano l'indicatore e perdono lo stato | r.577, 581, 585: `ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT)` | **IN PARTE SMENTITO**: la documentazione MQL5 dice che lo stesso simbolo e TF = "Aggiorna" del grafico, cioe' **ricalcolo** di tutti gli indicatori, non ricarica: lo stato dei tasti NON si perde [documentale, NON verificato nel terminale]. Ma il costo resta: ricalcolo completo a ogni clic. **CONFERMATO** invece per il clic su una cella (r.610, altro simbolo/TF = ricarica: HA, LIVELLI, ST, Nascondi tornano ai valori di partenza) | i tasti non chiamano piu' nulla; stato in GlobalVariable per grafico |
| 8 | Heikin Ashi sopra le candele vere | r.218-227: buffer HA disegnati, candele native intatte | **CONFERMATO** | candele native nascoste (`clrNONE`) e ripristinate, tecnica di `ABTG_Segnali_EMA_BB_ST` |
| 9 | (nuovo) Nascondi lascia a galla scritte e titolo | r.587-604: nascosti sfondo, nomi e celle, NON le scritte BUY/SELL (`cx_`) ne' il titolo, che restano ferme (r.510: niente aggiornamenti da nascosto) | **TROVATO** | tutto nascosto, stato ridisegnato al Mostra |
| 10 | (nuovo) Simbolo vuoto nell'elenco | una virgola in piu' in `InpSymbols` crea una riga con etichetta `""` (r.497; puo' mostrare "Label", classe 982) | **TROVATO** (minore) | vuoti e doppi tolti |
| 11 | (nuovo) Livelli cancellati e ricreati a ogni tick | r.376 `ObjectsDeleteAll` a ogni `OnCalculate` | **TROVATO** (minore, sfarfallio) | aggiornati sul posto |

### 6-bis. Le tre domande di Claudio del 01/10
**"I tasti non sono cosi' fluidi."** Cause nel codice, in ordine di peso: (1) ogni 3 s il timer rifa' 203 CopyRates e 203 Supertrend nel thread del simbolo, e il clic aspetta in coda dietro quel lavoro; (2) ogni secondo il lampeggio ridisegna tutto il grafico, anche quando non lampeggia niente; (3) ogni clic su un tasto fa ricalcolare da zero l'indicatore (e gli altri indicatori del grafico). Numeri per giro: v4.00 = ~480 oggetti della griglia, 203 CopyRates ogni 3 s (4.060 al minuto), circa 450 scritture di proprieta' ogni 3 s (2 per cella spenta, 4 per cella accesa, 1-2 per simbolo), un ridisegno al secondo sempre. v4.1 = stessi ~480 oggetti, ~47 CopyRates al minuto (solo a barra chiusa nuova, specchio del flusso), scritture solo per cio' che cambia, ridisegno solo se cambia qualcosa; i tasti non ricalcolano. Prova in 10 secondi sulla v4.00: clic su LIVELLI e guardare la scheda Esperti; se a ogni clic compare `[SuperWave] AVVIATO` il tasto RICARICA l'indicatore, se no lo ricalcola soltanto.

**"Lampeggiano i simboli senza che H4 e M3 siano della stessa direzione."** Sono **due cause insieme**: (a) **lettura**: le celle si colorano solo all'INVERSIONE (una barra), la confluenza usa la DIREZIONE: un simbolo lampeggia con tutte le celle spente, ed e' il caso normale (49,9% del tempo); (b) **difetto vero**: la griglia calcola il Supertrend in modo diverso dal grafico (difetto 5), quindi **il 7,7% dei lampeggi** (3,8% del tempo, XAUUSD M3) avviene mentre sul grafico il Supertrend di H4 e quello di M3 **non concordano**. Scartate, verificando il codice: confluenza "vecchia" per dati non pronti (no: i dati non pronti azzerano, non tengono, e il ritardo massimo e' 3 s); indici disallineati per spazi o simboli vuoti (no: nomi e confluenza usano lo stesso indice dopo il trim); simbolo doppio (lampeggiano tutte e due le righe, ma a ragione); Nascondi (da nascosto niente si aggiorna e niente lampeggia). Nella v4.1, con `InpDiagnosi=true`, ogni lampeggio si spiega con due numeri nel tooltip e nella scheda Esperti: direzione H4 e direzione M3 (piu' le barre dall'inversione).

**"Se ho un segnale su M3 e cambio TF i TP sono dall'altro lato: e' normale?"** Nella v4.00 si', ed e' un difetto d'uso: il pannello calcola direzione, stop e TP dal Supertrend del **TF che stai guardando** (r.256-279), non dal segnale che hai scelto: ogni TF ha il suo Supertrend, quindi cambiando TF possono cambiare direzione, stop, R e TP. Nella v4.1 il setup appartiene a **simbolo + TF del segnale**: clic sulla cella M3 accesa = setup M3 selezionato, che resta sul pannello e sulle linee anche se passi a H1 (le linee sono prezzi, valgono su ogni TF).

## 7. Come usarla senza farti male (finche' non e' sistemata)
1. Spegni il lampeggio (`InpBlink=false`) e guarda **solo le celle colorate**.
2. Usa le celle come **allarme** ("e' appena girato su H1"), poi decidi tu sul grafico.
3. Non usare i TP/lotti del pannello come ordine: servono per ordine di grandezza.
4. Non e' una strategia validata: nel repo SuperWave ha avuto uno screen con Dow H1 PF 1,42 su 226 operazioni e DAX H4 secondario, oro e Nasdaq "morti" (commit a86089c8): sono PF di screening, non un contratto.
5. La taglia (1%) e' la **tua** scelta: nel pannello e' solo un default.

## 8. Come leggere la v4.1 (`ABTG_SuperWave_Dashboard_v41.mq5`, in prova: passa dai controlli prima di arrivarti)
- [ ] **Cella colorata** = come prima: Supertrend 3,5 appena invertito su quel TF (una barra). Passandoci sopra: direzione, quante barre fa l'ultima inversione, ora della barra letta; `n/d` se i dati non sono pronti (lo stato mostrato e' l'ultimo buono).
- [ ] **Simbolo acceso** = M3 si e' appena invertito (entro 3 barre M3) **nella stessa direzione dell'H4**, con H4 senza inversioni nelle ultime 3 barre. Lampeggia 20 secondi, poi resta fisso finche' vale (al massimo ~9 minuti). Passandoci sopra: H4 e M3 con direzione e barre dall'inversione. Per la regola vecchia: `InpConflMode = 0`.
- [ ] **Clic su una cella accesa** = selezioni QUEL setup (es. M3 BUY): il pannello in alto a destra e le linee mostrano quel setup anche se cambi TF. Clic sul **titolo del pannello** = torni al setup del TF del grafico.
- [ ] **Pannello**: "Setup M3 BUY, fissato alle hh:mm" + ingresso (barra di inversione) + stop + TP1/2/3 con lotti; righe in fondo: "ingresso fisso a ...", distanza del prezzo dall'ingresso (punti e R), stato (APERTO / TP raggiunto / INVALIDATO). L'ingresso **non si muove** fino alla prossima inversione. "in attesa di inversione" / "nessun setup selezionato" quando non c'e' un setup valido. **Lotti indicativi**, non e' un ordine.
- [ ] **Tasti**: rispondono subito e ricordano lo stato anche se cambi simbolo/TF.
- [ ] **Ore** nel pannello e nei tooltip = **ora del server** (ora delle candele), non l'ora italiana.
- [ ] **Mettila su un grafico SENZA EA**: se sul grafico c'e' un EA, il clic su una cella NON cambia simbolo/TF a quel grafico (lo reinizializzerebbe): apre un grafico nuovo.
- [ ] Dettagli, input nuovi, rischi residui e domande aperte: `docs/SUPERWAVE_V41_NOTE.md`.

