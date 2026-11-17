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
