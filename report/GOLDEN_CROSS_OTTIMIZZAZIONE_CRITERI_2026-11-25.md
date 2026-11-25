# Golden Cross HA: ottimizzazione con i criteri di Wim (campagna UBS), scritta PRIMA dei numeri (25/11/2026)

**Richiesta di Claudio (25/11):** "ottimizza coi criteri di Wim". Si applicano i cancelli della campagna (`UBS_CAMPAGNA_OTTIMIZZAZIONE_CRITERI_2026-11-22.md`, sez. 3), adattati a un test Python sulla famiglia A (PDF HA+ADX) su 10 coppie forex H1/H4. La famiglia B (Paolo) non si ottimizza: sull'oro 13-23 operazioni per periodo (flip+cross) e PF < 1 in tutti i periodi (bande).

## Griglia (576 combinazioni = 576 tentativi, contatore dichiarato)
ADX minimo {15, 20, 25, 30} x distanza massima dalla EMA21 {0,5; 1,0; 1,5} ATR x target {1R, 1,5R, 2R, 3R} x stop {minimo/massimo delle ultime 3 barre -/+ 0,1 ATR; 1,5 ATR; 2,5 ATR} x uscita su EMA21 {si, no} x timeframe {H1, H4}. Fissi: EMA 9/21/50, 3 Heiken Ashi con stoppino <= 25% del corpo, incrocio nelle ultime 6 barre, costi e regole di gestione del simulatore corretto.

## Cancelli (identici alla campagna; finestre adattate)
- **Ricerca solo in campione IS 2005-2015.** OOS 2016-2021 e hold-out 2022-2026 non si guardano durante la ricerca.
- **Idoneo IS:** PF >= 1,30, operazioni >= 300, profitto > 0, anni positivi >= 60%.
- **Selezione:** fino a **10 candidati distinti** fra gli idonei: 40% migliori per risultato (R netto), 30% piu diversi (greedy sulla distanza fra curve in PF, drawdown e numero di operazioni), 30% a sorte (seme fisso 2026).
- **V1 (OOS 2016-2021):** PF >= 1,20, profitto > 0, operazioni >= 150, anni non negativi >= 60%.
- **V2 (perturbazione):** variando di un passo ADX, distanza, target e stop, almeno il 70% delle varianti ha PF > 1,0 sia in IS sia in V1.
- **V4 (hold-out 2022-2026):** PF > 1,0 con >= 100 operazioni, UNA volta, solo sui sopravvissuti. **V3 (tick)** solo per chi arriva a V4: serve l'EA MQL5 e il tester sul PC di Claudio.
- **Candidato** = V1+V2+V4. Nessuna soglia cambia dopo i numeri. Un gruppo con 0 idonei si scrive "nessun candidato"; non si rilancia con intervalli modificati.
- Per gli **non idonei si riporta solo la distribuzione dei PF in campione** (massimo, mediana, numero di idonei): nessun numero OOS/hold-out per loro.

## Previsione (scritta ora)
Le 12 varianti gia' provate (forex e oro) hanno PF 0,6-0,99 in tutti i periodi, IS compreso. **Idonei IS (PF >= 1,30 con >= 300 operazioni): 0 combinazioni su 576** (probabilita' 80%). Massimo PF IS della griglia: 1,0-1,15. Probabilita' di almeno un candidato V1+V2+V4: 3%.
