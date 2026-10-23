# Sala del consiglio, giro 1: le aperture sugli indici (23/10/2026)
**Natura: LETTURA. Nessun EA, preset, sedia, terminale o conto toccato; nessun test lanciato; nessun numero nuovo misurato, salvo i pochi ricalcoli dichiarati.** Perimetro: DAX Apertura 770101, Dow Apertura 770202, Nasdaq Apertura 770250, MaxMin DAX short 770411, ORB Ottimizzato 770611 (sedie del piccolo 50503392 e/o ripristinate il 23/10). Metodo: 5 revisori in sola lettura (uno per EA), poi i punti pesanti **ricontrollati da me sul codice**. Etichette: **VERIFICATO** = ricontrollato da me alla fonte; **DICHIARATO** = detto da un revisore, non ricontrollato; **INFERITO** = deduzione dal codice, nessuna prova di campo. Un agente che legge un file non e' una conferma indipendente.

## 1. In breve
1. **Il difetto piu' pesante e' lo stesso per tutte: il `.ex5` sul piccolo non e' il codice che analizziamo.** DAX, Dow e Nasdaq girano da `.ex5` dell'08/08 compilati da un sorgente che chiama `PositionClose(_Symbol)` (VERIFICATO nel commit 6074126d per il Dow, righe 585 e 1890; a HEAD resta solo nei commenti). Su hedging chiude la posizione piu' vecchia del simbolo, di chiunque. Nessun backtest ha mai misurato quel binario. **Prima di qualunque misura: F7.**
2. **Orologio:** DAX e MaxMin cambiano dal 26/10, Dow, ORB e Nasdaq dal 02/11. Con le ore invariate ognuna arma un'ora prima della cash. **Tre sedie hanno anche la chiusura che cade in un'ora sbagliata, quindi servono due leve, non una.** Decisione tua.
3. **Due correzioni a quanto ti ho detto io:** (a) il "DAX Apertura PF 0,41" del forward **non misura la sedia attuale** (sono il vecchio breakout ritirato il 14/08 e il retest; vedi 4); (b) **R283-R285 hanno misurato la regola di Emiliano, non la cella ORB in campo.**
4. **Silenzi pericolosi nel codice:** il filtro S&P del MaxMin e il gate EMA del Nasdaq si spengono senza dire niente se la lettura dell'indicatore fallisce.
5. **Il merito misurabile e' quasi nullo ovunque** (poche operazioni, un solo regime toro): il giro serve a togliere difetti e a dire cosa non ha prova, non a trovare profitto.

## 2. Difetti VERIFICATI da me
| EA | Cosa | Dove |
|---|---|---|
| Dow | binario in campo con `PositionClose(_Symbol)`; HEAD pulito | commit 6074126d righe 585 e 1890; HEAD solo commenti (righe 1948, 1966) |
| Dow | il pareggio sta DENTRO il ramo del parziale: non si puo' togliere solo il parziale tenendo il pareggio | righe 1730 e 1762 (indentazione; non ho tracciato le parentesi) |
| Dow | l'intestazione descrive il default (breakout, nessun parziale), non la sedia viva | riga 286: `InpTP1_ClosePct=0` a default, il set mette il retest |
| MaxMin | filtro S&P fail-open: handle non valido o `CopyBuffer` fallita => bias 0 = "entrambi i lati" = filtro spento, senza log | righe 396-407 e 240 |
| MaxMin | `InpOneTradePerDay` dichiarato, mai usato | solo riga 66 |
| MaxMin | R non fisso: ricalcolato a ogni tick dallo stop attuale | righe 306-307 |
| Nasdaq 770250 | set vivo: breakout solo short, livelli = candela H1 precedente, gate EMA acceso, rischio 0,35%, chiusura 20, trailing armato subito; la copia Sicuro (770291) e' la cella 770260 (retest L+S), quindi NON sostituisce la 770250 | `mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set` |
| Nasdaq 770250 | gate EMA fail-open: se `CopyBuffer` fallisce il bias resta com'e' e lo short passa | righe 1749-1757 |
| ORB | `TryPlace` non controlla ordini o posizioni esistenti; `gDay` azzerato al riavvio => doppio ordine possibile dopo le 14:45 (il doppio fill e' INFERITO) | righe 359, 430-476 |
| ORB | il TP della cella viva e' 1,5 x range (`InpTPMode=1`), non 1,0 | parametri di R283a |
| DAX | in HEAD `PositionClose(_Symbol)` e' solo nel commento | riga 2595 |
| DAX (forward) | il 0,41 mescola 17 posizioni del vecchio BREAKOUT (circa -575, PF 0,1) e 16 RETEST BUY (circa +175, PF 13,5), da `trades_auto.csv` | mio ricalcolo |

## 3. Difetti DICHIARATI dai revisori (non ricontrollati)
- **DAX:** la parziale non e' a 1R: col trailing armato subito e `InitialSL` che restituisce lo stop corrente, `riskDist<=0` e ripiega su 1,5 x ATR; livello reale mediano 0,57R, 58 su 77 sotto 0,9R (ricalcolo del revisore sul PERTRADE OOS, 193 posizioni). Le intestazioni citano i numeri long+short (PF 1,237), non quelli del solo long (1,423); `InpAllowShort` compilato e' true, il "solo long" e' solo nel set; nessun limite di tempo alla rottura (3 di 17 segnali forward in ritardo); `gBrokeHigh` alzato prima di Guardian e invio (un rifiuto brucia il giorno); stato parziale solo in memoria (F7 durante la posizione puo' dare una seconda parziale); `ArmRetest` esce prima del buffer con filtri di range (dormiente); trailing con stop sopra il Bid.
- **Dow:** stesso `gBrokeHigh`; R della parziale dallo stop corrente; `iBarShift` con barre mancanti; nessun filtro festivi; BE non verificato dopo il modify.
- **Nasdaq 770250:** a 0,35% con lotto minimo 0,1 il parziale al 50% e' impossibile sul piccolo (equity circa 4,4-5,4k, NON misurato); SELL STOP rifiutato non riprovato; armo senza limite dopo un riavvio.
- **MaxMin:** nessun calcolo di ora legale, nessun calendario Xetra; con `InpMinBoxPts=0` un box di una barra passa; stato in RAM.
- **ORB:** `TryPlace` senza `else` (un rifiuto non lascia traccia: l'Emiliano lo logga); il range include la barra M1 che nasce alla fine del range (14:45 nella cella viva); niente tetto al lotto minimo; **magic 770611 condiviso con l'ORB sull'argento: sicuro per costruzione (filtra simbolo+magic), il danno e' solo statistico**.
- **Comune:** nessun Guardian sul piccolo; fail-open dove c'e'; nessun filtro festivi USA/Xetra.

## 4. Prove disponibili e NON MISURATO
| EA | Cosa regge | Cosa no |
|---|---|---|
| DAX 770101 | tick, solo long, walk-forward: IS 1,131 (189 deal) / OOS 1,423 (256 deal, DD 6,72); R47a/R270c/DAXAP02 identici al centesimo (IS 132 pos PF 1,126; OOS 193 pos PF 1,397); **concentrazione: le 10 posizioni migliori valgono +15,9R su +17,0R, senza PF 1,03** (ricalcolo revisore); forward 100k retest 17 pos PF 3,00 | binario in campo mai misurato; regimi non toro; festivi; Guardian; la parziale a 1R vero |
| Dow 770202 | cella viva R101: IS 1,222 (74 deal) / OOS 1,270 (130 deal, 96 pos); senza filtro EMA H4 0,920 / 1,193; orologio R246: inverno alla cash 0,916 (40), armato prima 1,492 (68), verdetto sospeso (G1 per 1 centesimo) | ribasso, festivi, fill del limite, binario 08/08; short 1,511/0,840 (firma di regime) |
| Nasdaq 770250 | OHLC `NASUSD_EXT` 2020-24: PF 1,84 su 93 op., ma crollo 2020 + orso 2022 = circa 97% del netto; tick BCM 104 op. PF 1,097 (IS 1,257 / OOS 0,948) | controllo senza gate mai fatto; orologio d'inverno corretto; lotto/parziale al deposito del piccolo; merito sospeso |
| MaxMin 770411 | tick: IS 1,921 (20 deal) / OOS 2,192 (21 deal); fragile: buffer 500 => 0,957; 29 op. in 23 mesi (n<30) | filtro S&P dal vivo, festivi, lunedi', orso, lotto reale |
| ORB 770611 (cella viva) | R283a IS 1,247 (71) / OOS 1,678 (119); inverno US 2025-26 PF 1,70 su 46 pos (ricalcolo revisore); 49% del netto OOS da gen-feb 2026 | orologio d'inverno isolato; barra di fine range; riavvio; **R283-R285 non dicono nulla su questa cella** (G0: Emiliano a novita' spente = Ottimizzato, al centesimo) |

## 5. Orologio (decisione tua, `cash` o `prima`)
| EA | Da | Con le ore del set | Chiusura |
|---|---|---|---|
| DAX 770101 | 26/10 | arma 07:00-07:35 UTC (un'ora prima di Xetra) | 17:30 server = chiusura del cash |
| MaxMin 770411 | 26/10 | 07:59-08:30 cade prima delle 09:00 | tutto +1h per restare uguale |
| Dow 770202 | 02/11 | 14:30 server = 08:30 ET (pre-apertura) | 17:30 server = 11:30 ET: due leve |
| ORB 770611 | 02/11 | range 14:30-14:45 = 08:30-08:45 ET (dati macro) | 21:00 server = 15:00 ET |
| Nasdaq 770250 | 02/11 | livelli 07:00-08:00 ET | pendente scade 16:30, flat 20:45 |
**Se cambi le ore dell'ORB, fallo FUORI dalla finestra 14:45-21:00**: un riavvio del grafico raddoppia gli ordini (vedi 2).

## 6. Accoppiamenti (nessuno misurato)
Cluster 14:30 server: **Dow long + ORB long sullo stesso U30USD** (stesso rischio direzionale sommato) e **Nasdaq short** (copertura implicita mai misurata). Sul D30EUR: DAX long contro MaxMin short nella stessa finestra d'apertura (vietato su FTMO). Sul piccolo ci sono altre sedie sullo stesso U30USD e **nessun Guardian**.

## 7. Quesiti candidati (nessuna taratura; varianti = EA nuovi con magic diverso; criteri scritti PRIMA)
**A. Senza macchina di backtest (da fare per primi):**
1. **F7 sul piccolo** (DAX, Dow, Nasdaq) e verifica del `.ex5`: toglie il difetto 1.
2. MaxMin: sonda di sola lettura che registra ogni giorno alle 07:59 il bias S&P letto dall'EA e lo confronta con un ricalcolo indipendente (criterio: divergenza > 0 giorni = difetto). Box del lunedi' e post-festivo contro i giorni normali, sulle barre M1.
3. ORB: conta senza EA di quanti giorni l'H/L della barra 14:45 supera il range.
4. Dow: rilettura dei per-trade senza i giorni NYSE chiusi (elenco scritto prima).
**B. Round a tick (PC di backtest), uno alla volta, nello stile R283-R285:**
5. **DAX gestione a pezzi** (input gia' esistenti): G0 = R47a al centesimo; bracci senza trailing, senza parziale, senza pareggio; soglia 0,10 in entrambe le gambe; almeno 100 operazioni. **Attesa onesta: NON DISTINGUIBILE.** Limiti: IS di 132 posizioni, coda concentrata, il braccio senza trailing sposta anche la parziale.
6. **Nasdaq 770250 gate acceso/spento** (solo `InpUseEmaFilter`): il controllo mai fatto. Rischio: feed tutto toro, non si varia 50/200.
7. **ORB orologio** con e senza `InpAutoUSDST` sull'Emiliano v1.01 (G0 su questa cella prima): lettura per giorno accoppiato, vista senza gen-feb 2026.
8. **Dow gestione a pezzi** (senza BE+parziale insieme: la sola parziale non e' separabile) e **Dow orologio** (tolleranza G1 sulla conversione scritta prima).
**C. Varianti con codice nuovo (magic diverso, flag spento = originale al centesimo), solo dopo A e B:** DAX parziale a 1R vero; DAX ora d'ingresso per bin; anti-duplicato al riavvio per ORB; log del bias per Nasdaq.

## 8. Cosa NON conviene fare
Cambiare soglie o orari "per migliorare" sul solo regime 2024-26; promuovere qualunque variante; contare il forward del piccolo come prova (3 sedie su 5 hanno meno di 30 posizioni); toccare l'originale in campo.

## 9. Decisioni di Claudio
1. F7 su DAX, Dow, Nasdaq del piccolo (prima di qualsiasi misura).
2. Orologio `cash` o `prima`, per DAX/MaxMin dal 26/10 e per Dow/ORB/Nasdaq dal 02/11.
3. Quali quesiti dei gruppi A e B lanciare e in che ordine.
4. Se l'ORB resta com'e' (Ottimizzato in campo) con l'Emiliano come variante parallela magic 770631.

## 10. Limiti
5 revisori, solo il codice e i documenti del repo; ricontrollati da me 12 punti, il resto e' DICHIARATO; i ricalcoli dei revisori (PF forward, concentrazione, inverno ORB, parziale a 0,57R) non sono stati rifatti da me; l'effetto del binario vecchio e' INFERITO, non osservato nel forward; un solo regime nel feed BCM.
