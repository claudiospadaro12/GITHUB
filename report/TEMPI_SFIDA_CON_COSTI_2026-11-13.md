# Tempi della sfida con i settaggi Prop, in giorni di CALENDARIO e con i costi (13/11/2026)

**Natura: SIMULAZIONE sui dati del tester** (BCM, Modello 1, 80.000 EUR, anni 2013/2020/2025). Parte oro con equity (flottante ricostruito dalle barre M1) piu Daytrade Pro Max9 realizzato (il flottante del Daytrade Pro non si ricostruisce). Combinazioni scelte: P1 (Phantom Gradino 1 + Goldbot Prop + DTP), P3 (Goldbot Combo + Gold Trade Pro Combo + DTP), P4 (Reaper Combo + Goldbot Prop + DTP). Costi "centrali" = mia ipotesi: 36 EUR/lotto oro e 4 EUR/lotto forex (andata e ritorno, meta all'apertura e meta alla chiusura), sopra quelli gia nel tester; "prudenti" = il doppio. Il netto/anno con costi centrali coincide con `PORTAFOGLIO_SCELTO_2026-11-11.md` (30.582 / 25.685 / 24.788). Partenza da ogni giorno di gennaio-marzo di ciascun anno (finestra di 9 mesi o piu); fallisce a -5% in un giorno o -10% totale; passa a +10% (fase 1) o +5% (fase 2), almeno 4 giorni. Un percorso per anno; nessun giudizio su lotti, taglie, acquisti.

## Giorni di calendario (mediana; 25-75%; massimo)
| Combinazione | Costi | Fase 1 (+10%) | Fase 2 (+5%) | Totale (mediana + mediana) | Fallimenti |
|---|---|---|---|---|---|
| **P1** | nessun costo FTMO | 72 (44-112; max 135) | 33 (20-56) | ~105 | 0% |
| | **centrali** | **76** (50-123; max 158) | 36 (22-64) | **~112** | 0% |
| | prudenti | 89 (55-136; max 182) | 40 (22-80) | ~129 | 0% |
| **P3** | nessun costo | 97 (69-145; max 201) | 40 (28-78) | ~137 | 0% |
| | **centrali** | **105** (72-146; max 257) | 45 (30-83) | **~150** | 0% |
| | prudenti | 136 (93-159; max 258) | 48 (36-105) | ~184 | 0% |
| **P4** | nessun costo | 99 (57-129; max 182) | 39 (24-77) | ~138 | 0% |
| | **centrali** | **103** (62-145; max 210) | 42 (25-83) | **~145** | 0% |
| | prudenti | 119 (71-163; max 257) | 46 (27-94) | ~165 | 0% |
Caso lento (75% delle partenze, costi centrali): P1 123+64 = ~187 giorni; P3 146+83 = ~229; P4 145+83 = ~228.

## Perche i numeri dati prima non coincidevano
- "77-117 giorni" (12/11): mediane in GIORNI DI BORSA (non di calendario), solo la parte oro, senza costi FTMO e senza Daytrade Pro, partenze da ogni giorno dell'anno e finestre troncate a fine anno.
- "28 giorni" (13/11): un'altra combinazione (set del trio piu aggressivo: Reaper D9 + Goldbot PF525 + Phantom PROPCOMBO D4), solo realizzato, contando i giorni con operazioni.
- Queste tre misure NON si confrontano fra loro; questa tabella e la sola da usare per i conti P1/P3/P4 con i costi.

## Limiti
Fallimento 0% anche perche il Daytrade Pro non ha flottante e perche i costi veri di FTMO (spread, slippage) non sono simulati; 3 anni, un percorso per anno; partenze dello stesso anno non indipendenti; non copre lo Swing (margine) ne le regole FTMO non verificate.
