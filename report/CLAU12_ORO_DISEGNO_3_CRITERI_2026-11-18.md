# CLAU12 oro, disegno 3: breakout sui livelli giornalieri con distanze in % del prezzo, pendenti longevi e filtro "fake breakout" - criteri e previsioni scritti PRIMA di qualsiasi numero (18/11/2026)

**Natura:** piano di prova su tester, dati FTMO. Nessun giudizio su lotti, taglie, conti o acquisti. Decisione di Claudio (18/11): "andiamo avanti scrivendo un EA sull'oro simile a quello di Wim". **Non e una copia:** nessun codice, regole di livello e di conferma NON note; si usano SOLO i fatti dei manuali e dei report (`REAPER_COMPORTAMENTO_STRATEGIE_2026-11-18.md`). Eredita dai disegni 0-2 (`CLAU12_BREAKOUT_ORO_CRITERI`, `CLAU12_ORO_DISEGNI_2_E_3_CRITERI`): **71 set guardati, nessun candidato** (il disegno 2 e caduto in G4).
**Trasparenza:** il disegno nasce dalla lettura dei manuali Profalgo e dei report del Reaper (strategie 2-4: stop 0,3-0,5% del prezzo, target 1,6-3,1%, ordini che restano 6-7 giorni, distanze proporzionali al prezzo), NON dall'esame del 2021-2024 del nostro EA. Il periodo 2021-2024 e stato usato per bocciare il disegno 2: lo uso ancora come fuori-campione, ma e per questo un test meno puro; l'unica verifica residua davvero pulita e l'hold-out 2025-2026 (mai aperto per nessun EA nostro).

## 1. Cosa cambia nell'EA (template 1.04, da scrivere DOPO questi criteri)
- Nuovi modi **SL_PCT / TP_PCT**: stop e target = percentuale del prezzo corrente (come `UseVariableValues` del Reaper), non punti fissi.
- Nuovo input **fake breakout filter** `InpFBF`: 0 = spento; 1 = dopo il riempimento, alla chiusura della candela H1 su cui e entrato, se chiude contro la posizione la chiude subito; 2 = lo stesso con la candela H4 (come "Low/Medium" del Reaper, senza copiarne i dettagli).
- Resto invariato: breakout con ordini stop su entrambi i lati, `InpRearm=false` (pendenti persistenti), un solo trade al giorno, lotto 0,1, nessun break-even/trailing, nessun filtro news (il calendario non e disponibile nel tester), offset 0,10 ATR e distanza minima 0,20 ATR.

## 2. Prerequisiti (bloccanti)
- Template 1.04 compila e passa la **passata di controllo a occhio** (10 operazioni: stop e target in % del prezzo giusti; filtro che chiude solo quando la candela d'ingresso chiude contro; persistenza). Se c'e un difetto, si corregge e i numeri di quel giro non si usano. Previsione: almeno un difetto: 50%.

## 3. Batch: ortogonale L9 su 4 fattori (livelli D1 soltanto), 9 set
| Fattore | livelli |
|---|---|
| A. Stop (% del prezzo) | 0,35 / 0,50 / 0,70 |
| B. Target (% del prezzo) | 1,6 / 2,1 / 3,1 |
| C. Countback livelli D1 (giorni) | 5 / 10 / 20 |
| D. Filtro fake breakout | spento / H1 / H4 |
Righe L9 (0-based): 0000, 0111, 0222, 1012, 1120, 1201, 2021, 2102, 2210. **9 set.** Scadenza fissa 6 giorni (come le strategie 2-4). Contatore: **80 set** (71 + 9) piu fino a 8 vicini per ogni finalista.

## 4. Finestre, costi, porte (identiche ai disegni 1-2, per confrontabilita)
IS 2015-2020 (G3: 2015-17 e 2018-20); OOS 2021-22 e 2023-24 (G4); hold-out 2025-01 -> 2026-10 (G5, aperto UNA volta, solo per chi supera G4); tick proxy BCM 2024-07-15 -> 2024-12-31 (G6). Costi: netto = tester - 3,6 EUR a operazione. **G1:** netto > 0, PF netto >= 1,30, operazioni >= 100, recovery >= 1,5, **t >= 3,3**. **G2** (>= 70% dei vicini in profitto, PF mediano >= 0,8 x). **G3** (entrambe le meta IS in profitto, PF >= 1,10). **G4** (PF netto >= 1,20 e profitto > 0 in ENTRAMBE, >= 20 operazioni, WFE >= 0,5). **G6** (PF tick/candele >= 0,7; DD tick <= 1,5 x; operazioni +/- 10%).

## 5. Previsioni (scritte ora)
- Almeno un set con PF netto >= 1,30 e >= 100 operazioni in IS: **35%**.
- Almeno un set passa G1: **15%**.
- Passa G1-G4 (OOS 2021-24): **6%** (il disegno 2 era al 5% e ha fallito; qui le distanze proporzionali al prezzo e il filtro possono aiutare, ma resta un breakout sull'oro dopo tre disegni gia guardati).
- Il migliore ha il filtro fake breakout acceso (H1 o H4): 60%.
- Il migliore supera il PF netto 1,42 del disegno 1: 40%.
- Passa anche G6 (tick): 3%.

## 6. Regole d'arresto
- Se nessun set supera G1: **"nessun candidato"** per il disegno 3 e si chiude la famiglia "breakout sui livelli giornalieri dell'oro, un solo timeframe di livello" senza secondo batch.
- Se un finalista cade in G4: stessa conclusione.
- Nessun EA va in demo/conto prima di G1-G6 e di una decisione di Claudio. Soglie non ritoccate dopo aver visto i numeri.

## 7. Cosa NON sappiamo ancora (limiti dichiarati)
La regola esatta con cui i sistemi di Wim scelgono i livelli e le "conferme" non e nota: questo disegno e una **nostra ipotesi** ispirata ai fatti pubblici, e puo non riprodurre i loro risultati. I confronti di correlazione con i loro conti (se arriveranno a G4) sono solo un'etichetta.

## 8. Esito della passata di controllo (P2), 18/11/2026 - scritto PRIMA di qualsiasi numero del batch
File: `RIEPILOGO_CONTROLLO_DISEGNO3.txt` (template 1.04, FTMO, XAUUSD D1, 01/01-01/04/2019, righe L9 n. 2 e n. 3). I numeri di questo giro **non** si usano per scegliere nulla.
**Verificato a occhio, tutto conforme:**
- Stop e target in % del prezzo d'ingresso: buy stop 1285,16 -> stop 1280,66 (-0,35%), target 1312,15 (+2,10%) nella riga 2 e 1325,00 (+3,10%) nella riga 3. Idem sui sell.
- Countback diverso -> livelli diversi (sell stop 1234,33 con 10 giorni, 1220,10 con 20 giorni).
- Pendenti persistenti: restano fino a riempimento/scadenza; scadenza 6 giorni arrotondata dal tester alla mezzanotte successiva (~7 giorni, noto); dopo la scadenza si riarma alle 00:00, rifiuto 10018 (mercato chiuso) e ordini piazzati alle 01:05.
- Alla riempita di un lato l'altro viene cancellato; mai due posizioni insieme; nessun ingresso con posizione aperta; a fine test (29/03 22:58) i pendenti residui vengono cancellati.
- Il filtro fake breakout scatta come scritto (`la candela PERIOD_H1 d'ingresso chiude contro (1297.45 vs 1298.06): chiudo`).
**Difetto bloccante: nessuno.** Previsione scritta "almeno un difetto: 50%" -> **sbagliata** (nessun difetto bloccante; la v1.04 dopo 3 correzioni precedenti passa al primo giro).
**Osservazione di progetto (non e un difetto del codice):** quando l'ingresso avviene a pochi secondi dalla chiusura della candela H1 (es. entrato 18:59:40, chiuso 19:00:00), il filtro confronta una candela di 20 secondi con il prezzo d'ingresso e chiude quasi a caso, con piccola perdita. Nella riga 2 (H1) **5 operazioni su 10** sono uscite cosi entro 1 ora (-2 / -15 EUR contro i -40 dello stop); nella riga 3 (H4) **1 su 4**. Non so come il fornitore risolva questo caso. **Decisione presa ora, prima dei numeri:** il template NON si cambia; il filtro e un fattore del batch (spento/H1/H4), quindi il suo effetto (anche quello "casuale") e misurato dentro i risultati; se vince il filtro H1 lo segno come limite da verificare. Nessuna variante "ignora le candele quasi chiuse" in questo disegno.
**Limite dei dati di controllo:** 3 mesi, 10 + 4 operazioni: servono solo a vedere che il codice fa quello che dice, non a giudicare la strategia.

## 9. Risultato del batch da 9 set (FTMO, IS 2015-2020, 18/11/2026) - **NESSUN CANDIDATO**
Dati: `report/CLAU12_ORO_DISEGNO3_dati/RISULTATI_BATCH9_DISEGNO3_FTMO.csv`. Costo 3,6 EUR/operazione, soglie G1 invariate (non ritoccate dopo i numeri).
| set | stop % | target % | cb | FBF | ops | netto EUR | PF netto | recovery | t |
|---|---|---|---|---|---|---|---|---|---|
| R1 | 0,35 | 1,6 | 5 | spento | 297 | -273 | 0,98 | 0,54 | -0,16 |
| R2 | 0,35 | 2,1 | 10 | H1 | 214 | +1.124 | 1,17 | 1,80 | 0,77 |
| R3 | 0,35 | 3,1 | 20 | H4 | 138 | +1.145 | 1,21 | 1,61 | 0,70 |
| R4 | 0,50 | 1,6 | 10 | H4 | 217 | +69 | 1,01 | 0,67 | 0,05 |
| R5 | 0,50 | 2,1 | 20 | spento | 145 | +239 | 1,03 | 0,46 | 0,15 |
| R6 | 0,50 | 3,1 | 5 | H1 | 279 | -1.459 | 0,87 | -0,31 | -0,71 |
| R7 | 0,70 | 1,6 | 20 | H1 | 163 | -247 | 0,96 | 0,33 | -0,19 |
| R8 | 0,70 | 2,1 | 5 | H4 | 273 | -2.133 | 0,84 | -0,47 | -1,09 |
| R9 | 0,70 | 3,1 | 10 | spento | 153 | -2.554 | 0,79 | -0,58 | -1,20 |
**G1: 0 set su 9.** Il migliore per PF netto e R3 (1,21, t 0,70); nessuno ha PF netto >= 1,30 ne t >= 3,3 (massimo 0,77). 4 set su 9 in profitto, ma con profitti di poche migliaia di euro su 6 anni: indistinguibili dal caso.
**Previsioni vs risultato:** PF netto >= 1,30 con >= 100 ops: 35% -> NO; almeno un G1: 15% -> NO; G1-G4: 6% -> NO; G6: 3% -> NO; migliore con filtro acceso: 60% -> si (R2 e R3, ma il filtro e confuso con gli altri fattori); migliore sopra PF 1,42: 40% -> NO.
**Effetti medi (netto EUR per livello, L9, solo descrittivi, NON usati per scegliere):** stop 0,35/0,50/0,70 = +665 / -384 / -1.645; target 1,6/2,1/3,1 = -150 / -257 / -956; countback 5/10/20 = -1.288 / -454 / +379; filtro spento/H1/H4 = -863 / -194 / -306. Direzione coerente (stop stretto, countback lungo), ma con 9 prove e t massimo 0,77 non e un segnale.
**Regola d'arresto applicata (sezione 6):** nessun set supera G1 -> **"nessun candidato"** per il disegno 3; si chiude la famiglia "breakout sui livelli giornalieri dell'oro, un solo timeframe di livello" **senza secondo batch** e senza G2-G4. Hold-out 2025-2026 non aperto. Contatore: **80 set guardati nella campagna, nessun candidato.**
