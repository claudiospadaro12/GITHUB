# Sala del consiglio su DAX Apertura, Dow Apertura e ORB Ottimizzato (23/10/2026)

**Natura: analisi per LETTURA. Nessuna compilazione, nessun backtest, nessun file di EA, preset o conto modificato.** Non controllata da agenti indipendenti oltre ai nove usati qui.
Metodo: 9 sottoagenti reali (per ogni EA: A6 revisore critico, A3 evidenze, A7 verificatore), mandati scritti prima; coordinatore (io) che ha **riverificato alla fonte** i punti marcati **[RIVERIFICATO]**. Gli altri sono **[DICHIARATO DA AGENTE]**: un agente che legge lo stesso file non e' una conferma indipendente. Nessun punteggio di qualita'. Sorgenti a `5ec2b6f1` (HEAD di `lavoro` all'avvio). Precedente: `PROVA_SALA_CONSIGLIO_NASDAQ_APERTURA_2026-10-20.md`.

## 1. In breve
1. **I binari in campo sono PRECEDENTI al 19/09**, cioe' alla "toppa hedge-safe" che chiude per ticket. Il vecchio `PositionClose(_Symbol)` su conto hedging chiude la posizione **piu' vecchia del simbolo, di chiunque sia**. [RIVERIFICATO: sorgente Dow del 19/08 r.609 e 1936; commento nel codice HEAD `ABTG_DAX_Apertura_EU.mq5` r.2590-2600; righe e date dei binari da `CODA_06_quale_codice_gira_20261023`]. Che il binario di campo derivi proprio da quelle versioni e' **INFERITO** dalle date e dal numero di righe.
2. **ORB su XAGUSD (piccolo) ed EURAUD (reale): probabile sedia che non entra mai.** `InpK=1,0` ed `InpEntryPoints=10,0` letti dai grafici il 23/10 (`CODA_08`); il codice calcola la distanza come `InpEntryPoints*InpK` in PREZZO (r.614). Sul reale il 16/10 un buy stop e' stato piazzato a **11,61799** con un cambio vicino a 1,62 (`report/giornata_2026-10-16.md`, riferito da A3). [RIVERIFICATO codice e input]
3. **I tre EA non hanno festivi, ne' limite superiore all'orario di armo, ne' correzione automatica dell'ora legale.** [RIVERIFICATO a lettura incrociata: A6 e A7 concordano per tutti e tre.]
4. **Rottura bruciata prima dell'ordine (DAX e Dow, RETEST):** `gBrokeHigh=true` e' impostato prima di Guardian e invio; un blocco o un rifiuto fa perdere il lato senza nuovo tentativo. [RIVERIFICATO: Dow r.1314-1339, DAX r.1925-1961]
5. **Orologio d'inverno: i numeri misurati non dicono `cash`.** Vedi sez. 5. La decisione e' di Claudio e non e' registrata.

## 2. Difetti comuni (matrice)
| Difetto | DAX 770101 | Dow 770202 | ORB 770611 | Fonte |
|---|---|---|---|---|
| Ore fisse in ora server, nessuna conversione, nessuna ora legale | si (r.263, 266, 811, 818, 2029) | si (r.613, 620, 820, 1400) | si (r.372-381, 409-412) | A6+A7 |
| Nessun filtro festivi, sabato/domenica, mezze sessioni | si | si | si | A6+A7 |
| Nessun limite superiore all'orario di armo (dopo riavvio arma tardi) | si (r.855) | si (r.627-628, 657-658) | si (r.381-392) | A6+A7 |
| Rifiuto del broker solo loggato, nessun nuovo tentativo | si | si | si (BuyStop/SellStop senza else) | A6+A7 |
| Lotto forzato al minimo, senza tetto, rischio su balance | si (r.2280-2287) | si (r.1651-1657) | si (r.1091-1095) | A6+A7 |
| Stato (parziale/BE) in memoria perso al riavvio | si | si | si (gPart1) | A6 |
| `PositionModify` BE/trailing non controllato, BE marcato comunque | si (r.2396-2453) | si (r.1767-1824) | parziale | A6+A7 |
| Chiusura serale dipendente dai tick | si | si | si | A6 |
| Guardian fail-open (nessun canale = via libera; `pretendi_guardian=false`) | si | si | si | A7 |
| Commento "non serve nessun .mqh" falso: serve `ABTG_PausaGuardian.mqh` | si (r.102-104) | si (r.71-73) | n/a | A6+A7 |
| Magic di default condiviso con varianti (`_Pin9fca`, `_TrailFix`, CLAU12_) | 770101 su 5 file | 770202 su 4 file | 770611 solo in set/commenti | A7 |
| Rottura "bruciata" prima dell'ordine | **si** (r.1925) | **si** (r.1314) | no | A6, riverificato |
| Il range include la barra M1 che nasce all'orario di fine | si (r.1143-1154) | si (r.844-853) | si (r.410-420) | A6 |

## 3. Difetti specifici
**DAX.** Con `InpSessionHour=8` da lunedi' 26/10 il retest si arma alle 08:35 server, 25 minuti prima di Xetra (09:00) [A6, aritmetica coerente con `DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md`]. Filtri di armo (range min/max, spread) con `return(true)` lasciano `gBuffer=0`/`gBias=0` non inizializzati: latenti, i set hanno 0 [A6]. Calendario Xetra assente nel repo: serve una tabella nuova (Capodanno, Venerdi' Santo, Lunedi' dell'Angelo, 1 maggio, 24/25/31 dicembre: INFERITO, non verificato sul calendario Deutsche Boerse).
**Dow.** Dal 02/11 con 14/17:30 il range 14:30-15:05 cade alle 8:30-9:05 ET (pre-apertura) [A6]. Filtro EMA H4 fail-open silenzioso se `CopyBuffer` fallisce [A6, r.1498-1503]. Mezze sessioni USA (27/11, 24/12): la cash chiude prima del flat.
**ORB.** I **minuti esistono** (`InpRangeStartMin=25`, `InpRangeEndMin=30`, `InpEndMin=59` come default; i set di campo dicono **14:30-14:45, fine 21:00**), quindi "14/14" va letto come 14:30-14:45 [A7, r.129-133 e set]. Dopo un riavvio: `ResetDay` riparte da WAIT, `TryPlace` non controlla gli ordini gia' vivi (raddoppia) ne' i trade gia' chiusi (secondo trade del giorno, `InpOneTradePerDay` non basta) [A6, da verificare nel tester]. Se il Guardian blocca, riprova a ogni tick fino a fine giornata [A7]. Con spread alto il primo tick brucia la giornata [A7, spento nei set]. Filtro EMA200 fail-open [A6].

## 4. Binari in campo contro HEAD (CODA_06 del 23/10; righe del sorgente accanto, Guardian nel sorgente)
| Terminale | DAX | Dow | ORB | HEAD |
|---|---|---|---|---|
| Piccolo 50503392 | 1.00, 2191 righe, **no Guardian**, 08/08 | 1.00, 2123, **no**, 08/08 | 1.04, 1464, si, 03/09 | DAX 2885, Dow 2205, ORB 1483 (v1.04) |
| 100k 50504263 | 1.01, 2361, si, 19/08 | 1.01, 2148, si, 19/08 | **1.02, 823**, si, 22/08 | idem |
| Reale 10105439 | 1.01, 2368, si, 06/09 | - | 1.04, 1464, si, 06/09 | idem |
| PC backtest | 1.01, 2426, 21/09 | 1.01, 2206, 21/09 | 1.04, 1464, 21/09 | idem |
Nessuna versione committata ha esattamente 2191 righe (A6: la piu' vicina e' `6074126d`, 2169). **La toppa per ticket e' del 19/09 (`9fca63d9`), "prerequisito delle sei sedie".** Tutti i binari del 100k e del piccolo per DAX e Dow sono anteriori. Ricompilando senza ripristinare, `InpUsaGuardian` passa al default di HEAD (true).
Rischio concreto sul 100k: su U30USD stanno Dow e ORB (Dow chiude alle 17:30, ORB alle 21:00); su D30EUR DAX e MaxMin. Il flat di uno puo' chiudere la posizione dell'altro [INFERITO, da verificare nel log: "fine sessione: chiusa la posizione #"].

## 5. Cosa il repo ha misurato (sintesi, ogni numero ha fonte nei rapporti di A3)
**DAX 770101 long, tick reali, 100k, 1%:** cella r47a IS PF 1,126 (132 pos) / OOS 1,397 (193 pos), DD OOS 7,23% (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.63). Stagioni (REFERTO_R246): **estate alla cash 1,108 (157 pos); inverno armato 1h prima 1,389 (168); inverno ALLA CASH 1,184 (138); estate armata 1h prima 0,774.** Forward: nessun dato in TRACKING; 100k 17 pos PF 3,00 (11/08-24/09, n<30); piccolo 40 righe -483,85 (contaminato da ordini del PC). Mai misurato: regimi ribasso/laterale, festivi Xetra, slippage FTMO, filtro spazio.
**Dow 770202 long:** OOS PF 1,270 su 96 pos (sotto il cancello N=150), DD OOS 4,39% a 1%. Orologio: **inverno ALLA CASH PF 0,916 (40 op.); inverno armato 1h prima 1,492 (68 pos.); estate alla cash 0,886 (84); estate 1h prima 1,038 (137).** Forward: 100k 3 pos in utile, piccolo +0,35 su 4 righe; nessun dato dopo il 28/08. Un solo regime (toro) in OOS.
**ORB 770611 U30USD long:** OOS PF 1,674 su 119 pos, DD 9,76% (100k, 1%, HALFRANGE); 49% del netto OOS da gen-feb 2026. Forward 100k: sedia ha girato per giorni a 1,0% invece di 0,3% (corretta il 03/09). **XAGUSD, EURAUD, CADCHF: nessuna misura (NON TROVATO).** Orologio d'inverno non misurato.
**Avvertenza:** le differenze d'inverno sono finestre di pochi mesi in un solo regime; la causa non e' dimostrata (`DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md` §1.5). Non sono una prova che "armare prima" sia meglio.

## 6. Portabilita' delle tre correzioni del Nasdaq Sicuro
| Correzione | DAX | Dow | ORB |
|---|---|---|---|
| Tetto lotto minimo (`InpMaxMinLotRiskX`, default 0 = spento) | si, quasi verbatim | si | si, tra r.1094-1095 |
| Festivi | **calendario Xetra da scrivere** (helper `ABTG_Pasqua`, `ABTG_NthWeekdayDom`, `ABTG_LastWeekdayDom` riusabili) | si (NYSE, funzioni pure) | si (NYSE) |
| Ora legale automatica | schema si, **regola UE** (ultima domenica di marzo e ottobre); 6 punti da sostituire | si (regola USA); 7 punti | si; 3 orari da spostare, **piu' invasivo** |
Non portabili dal Sicuro (nessuno dei due ce li ha): limite superiore all'armo, riarmo del lato dopo un rifiuto, anti-duplicato "trade gia' chiuso oggi" dell'ORB (richiede la history). Tutte le correzioni restano **opt-in, default spento**, in file nuovi `_Sicuro` con magic diverso, **in parallelo agli originali**.

## 7. Decisioni aperte (di Claudio)
1. **Orologio DAX/MaxMin da 26/10 e Dow/ORB da 02/11**: `cash`, `prima` o altro. Il default `cash` messo nelle due righe di ripristino NON era una sua decisione registrata. Il 100k e' stato scritto con `cash`.
2. **Ricompilare i binari di HEAD** (chiusura per ticket) sul 100k e sul piccolo, oppure accettare il rischio per ora.
3. **ORB su XAGUSD e EURAUD**: cosa farne (K non adattato).
4. Pulizia dei 20 set `RIPRISTINO_DEMO_20261023/*.set` (32 input estranei di indicatori e `InpVerbose` doppio in coda). Non cambia i valori dell'EA.

## 8. Limiti
Nessuna compilazione ne' esecuzione. Non ho letto i binari. Non ho verificato su BCM stop/freeze level, filling, scadenze ordini, comportamento di `iBarShift`. Calendari NYSE/Xetra non verificati su fonte ufficiale. `ABTG_PausaGuardian.mqh` letto solo in parte dagli agenti. Un agente (A3 Dow) ha aperto una shell in sola lettura per leggere CSV. Sul Nasdaq, dei punti che il tester ha potuto misurare (R276), uno e' stato confermato (festivi, su un caso), uno solo a conto molto piccolo (lotto minimo) e uno no (armo tardivo; il proxy usato non lo riproduceva): questi sono **ipotesi di esecuzione da misurare**, non fatti.
