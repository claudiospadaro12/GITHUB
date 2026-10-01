# SuperWave Dashboard: cosa fa, come leggerla, come usarla (checklist)
Versione analizzata: il file che Claudio ha mandato il 01/10/2026 (695 righe, `#property version "4.00"`, copia in `docs/sorgenti_ricevuti/`). **Nel repo c'e' un'altra versione con lo stesso numero** (`mql5/Indicators/ABTG_SuperWave_Dashboard.mq5`, 936 righe, con media 50, incrocio e lampeggio "dolce"): quale gira sul tuo grafico lo dice la finestra Input (se vedi `InpMA4` e `InpShowCross` e' quella del repo). Questa checklist descrive **quella che hai mandato**.
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

## 6. Problemi trovati leggendo il codice (da correggere)
| # | Difetto | Effetto | Gravita' |
|---|---|---|---|
| 1 | La confluenza H4/M3 e' "stessa direzione", non "inversione" | una parte grande dei simboli (stima: circa meta') lampeggia sempre | alta (e' quello che vedi) |
| 2 | Il lampeggio ridisegna tutto il grafico ogni secondo | sfarfallio, grafico pesante | media |
| 3 | Il ricalcolo (29 simboli x 7 TF) gira ogni 3 s nel thread del grafico | scatti | media |
| 4 | Se i dati di un simbolo/TF non sono pronti la cella si azzera | celle e simboli che spariscono e tornano | media |
| 5 | Il Supertrend della griglia usa una finestra di 90 barre e un ATR "Wilder"; quello sul grafico usa l'ATR di MT5 | la cella puo' dire una cosa e il grafico un'altra; inversioni spurie quando la finestra scorre | alta [da provare nel tester: l'ATR di MT5 e' una media semplice] |
| 6 | L'"operazione" usa il prezzo corrente come ingresso | TP e lotti cambiano a ogni tick; nessun setup fisso | alta per l'uso |
| 7 | I bottoni usano `ChartSetSymbolPeriod` per ricalcolare | possibile ripartenza dell'indicatore e perdita dello stato dei bottoni [da verificare] | bassa |
| 8 | Heikin Ashi si disegna sopra le candele vere | doppie candele | bassa |

## 7. Come usarla senza farti male (finche' non e' sistemata)
1. Spegni il lampeggio (`InpBlink=false`) e guarda **solo le celle colorate**.
2. Usa le celle come **allarme** ("e' appena girato su H1"), poi decidi tu sul grafico.
3. Non usare i TP/lotti del pannello come ordine: servono per ordine di grandezza.
4. Non e' una strategia validata: nel repo SuperWave ha avuto uno screen con Dow H1 PF 1,42 su 226 operazioni e DAX H4 secondario, oro e Nasdaq "morti" (commit a86089c8): sono PF di screening, non un contratto.
5. La taglia (1%) e' la **tua** scelta: nel pannello e' solo un default.

## 8. Cosa succede dopo
Sto preparando una v4.1 che corregge 1, 2, 3, 4, 5 e 6 (confluenza = inversione recente nella direzione di H4; lampeggio breve e poi fisso; niente ridisegno ogni secondo; stato non pronto mantenuto; ATR e finestra come sul grafico; ingresso fissato alla barra di inversione). Passa dai due controlli prima di arrivare a te.
