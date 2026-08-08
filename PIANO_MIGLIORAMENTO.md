# 🔧 PIANO DI MIGLIORAMENTO — tutta la flotta, nessuno escluso

_Scritto l'08/08/2026, su richiesta di Claudio: «io li voglio migliorare tutti»._

**Ogni EA ha un prossimo passo scritto qui sotto.** Ma "migliorare" non è la stessa cosa
per tutti, e il weekend l'ha appena misurato: la flotta si divide in **quattro binari**,
e trattarli uguali è il modo per fabbricare overfitting (l'IS ci ha tradito **8 volte**).

Il modello di cosa vuol dire "migliorare" ce l'abbiamo già: `DAX Apertura EU` è passato
da −205,92 in un giorno (BREAKOUT 15/200) all'unico **validato** della flotta (RETEST
35/500/200 SOLO LONG, OOS +1800 · PF 1,42 · DD 6,7%). Non l'ha fatto un'ottimizzazione:
l'hanno fatto **otto fasi con ipotesi e criteri scritti prima**, una alla volta. Questo
piano applica lo stesso metodo a tutti, in ordine di merito misurato.

---

## BINARIO A — HANNO SEGNALE → griglie mirate (in corsa / pronte)

Il segnale c'è: si sonda se è **robusto** (vicini verdi) o un numero fortunato.

| # | EA | griglia | stato |
|---|---|---|---|
| 1 | SupertrendReversal @**Nikkei** | TF H1–H12 a **taglia prop 100k** | 🔄 round 2, in corsa |
| 2 | MaxMinNotte_DAX_Short_Ott | buffer 500–1500 (live=1000 al centro) | 🔄 round 2, in corsa |
| 3 | GoldenCross_Ott @XAUUSD H1 | ADX 10–25 (live=15) | 🔄 round 2, in corsa |
| 4 | SupertrendReversal_Multi_Ott @XAUUSD H4 | StMult 1,5–3,5 (live=2,5) | ✅ pronta (`R3_`) |
| 5 | SupRev_NAS_H1_Ott @NASUSD **H1** | StMult 2,0–4,0 (live=3,0) | ✅ pronta (`R3_`) |
| 6 | SuperWave_DOW_H1_Ott @U30USD **H1** | StMult 1,5–3,5 (perso per 13,73 €) | ✅ pronta (`R3_`) |
| 7 | SupertrendReversal @XAUUSD H3 | StMult 2,5–4,5 (n piccolo, dichiarato) | ✅ pronta (`R3_`) |
| 8 | EMA200 @SPXUSD H4 | periodo EMA 150–250 (il "200" è magico?) | ✅ pronta (`R3_`) |
| 9 | EMA200 @AUDJPY (H8–D1 aggregato) | in coda: prima serve il verdetto SPXUSD | ⏳ |
| 10 | SupRev_DOW_H4 / SupRev_DAX_H4 (picchi H4) | in coda: stessa sonda StMult dei fratelli | ⏳ |

**Regola di tutte le griglie**: il valore live sta al centro, la cella live deve
riprodurre la FASE 0 al centesimo (sanità), ribaltamento IS→OOS = non si cambia niente.

## BINARIO B — SENZA EDGE MISURATO → si migliora il MOTORE, non i numeri

15 lavori senza una cella positiva nelle due finestre nemmeno in OHLC. **Ottimizzarli è
inutile e dannoso**: una griglia su un motore che non funziona trova solo rumore. Qui si
fa quello che si è fatto col DAX: capire PERCHÉ falliscono e cambiare il meccanismo
(lavoro da `mql5-ea-developer`, un EA alla volta, ipotesi scritta prima). Ordine per
esposizione live:

| priorità | EA | indizio da cui partire |
|---|---|---|
| 1 | **ORB** @NASUSD (live!) | 06/08: stoppato in 32 s, poi si gira e ristoppato — stop dentro il rumore dell'apertura, stessa malattia curata sul DAX col RETEST |
| 2 | **PTE** @XAUUSD (live!) | 16 celle TP1×TF tutte bocciate; il BE che non scatta mai (visto live). Il motore d'uscita va ripensato, non tarato |
| 3 | ORB_Fibo @NASUSD (live!) | secondo ORB: probabile stessa cura del fratello |
| 4 | Nightly @EURUSD (live!) | RR 0,86 dichiarato in flotta: serve il 54% di vincenti solo per pareggiare — è un problema di geometria, non di parametri |
| 5 | SupertrendInvert / WOL @XAUUSD (live) | mai una cella verde: capire il segnale prima di tutto |
| 6 | PostNews @EURUSD+EURJPY (live) | un solo trade storico: forse non scatta mai — verificare il trigger |
| 7 | GoldenCross @forex ×3, MaxMinNotte @EURUSD, EMA200 @200AUD, SupRev_CAC, STREV @D30EUR | bocciati dove girano: candidati allo spegnimento o al trapianto del motore dei fratelli che funzionano (GoldenCross_Ott, MaxMinNotte DAX) |

## BINARIO C — MISURATI NEGATIVI A TICK REALI → prima la decisione, poi il motore

`DAX Live 5m` (OOS −2218, DD 39,7%, **gira al 2%**), `Live5m v2`, `Nasdaq Live 5m`.
Qui migliorare vuol dire prima di tutto **fermare l'emorragia** (decisione di Claudio),
poi eventualmente binario B. Nessuna griglia li salva: sono negativi su tutta la linea.

### ✅ Primo intervento del binario B: FATTO (08/08) — il sizing che mentiva

`LotByRisk`/`CalcLotByRisk` usava `SYMBOL_TRADE_TICK_VALUE` nudo: su 225JPY arriva non
convertito in valuta conto → lotto ~0 → sempre al minimo (misurato nel round 2). Corretto
con `OrderCalcProfit` + tick value come ripiego, **su tutta la classe: 41 EA in un colpo**
(la lezione del 05/08: si corregge la classe, non il caso). Sui simboli sani i due calcoli
coincidono: il comportamento cambia SOLO dove il tick value mente. 16 EA legacy con
pattern diversi (SuperWave_EA col lotto-a-zero, ORB_*, BULGE, Gold_*) restano da fare a
parte. ⚠️ **Sul VPS niente ricompilazioni finché il round 5 non ha misurato il fix.**

## BINARIO D — NON MISURABILI → si aggiunge l'export, e diventano misurabili

`HARSI` e `SuperWave_EA` girano live **senza OnTester**: non producono CSV, quindi non
entrano in nessuna pipeline. Primo miglioramento concreto: **aggiungere il blocco
OnTester** (lo faccio io nel codice, come per gli altri 39). Poi FASE 0 come tutti.
Stesso discorso per gli altri 20 EA del repo senza export, se mai andranno accesi.

---

## Il ritmo

Le griglie del binario A costano **ore**, non weekend: si accodano una sera per volta.
Il binario B costa di più (è progettazione), ma è quello che ha prodotto l'unico
validato: **un EA a settimana**, con le ipotesi scritte prima e il forward a confermare.
La coda del weekend rifà da capo la FASE 0 quando il codice di un EA cambia.

**Il criterio resta uno**: nessun cambio in forward senza una misura fuori campione che
lo giustifichi, mai scegliere la cella migliore in IS (8 ribaltamenti misurati), minimo
30 trade OOS per un verdetto.
