# Filtro NFP spento sull'oro: risultati (12/11/2026) — 18 passate

**Natura: MISURA.** Criteri e previsioni scritti prima: `CRITERI_NFP_OFF_2026-11-11.md`. Goldbot One Prop (L0) e Combo 3GOLD (L3), Phantom Gradino 1 (L1), Reaper Combo 3GOLD (L3), XAUUSD, 160.000 EUR, Modello 1, 2013 / 2020 / 2025, `EnableNFP_Filter=false` (con tutti gli altri input imposti: `EnableVirtualSLTP=false`, ritardo 99, `FridayStopHour=25`). Riferimento: passate D160 (filtro acceso). Zip `WIM_01-03` (cartella `ANNO_ORO_GRADINI_NFPOFFORO_20261111_2245`). Script `D160_dati/analisi_nfpoff_oro.py`. **Il Gold Trade Pro NON e incluso** (le 3 passate del test erano non valide; da rifare con la riga corretta).

## Validita
18/18 passate valide: stato OK, qualita 99-100%, **tutti gli input del report identici al riferimento tranne `EnableNFP_Filter=false`** (controllo su tutti gli input, non solo quelli imposti). Reaper L3 2020: la ripetizione R1 del riferimento e KO (D160), il confronto usa R2.

## Risultati (somma dei 3 anni; Phantom e Reaper: media delle ripetizioni)
| EA | Netto filtro spento vs acceso | Per anno spento / acceso (2013 / 2020 / 2025) | DD: massimo aumento | Peggior giorno: massimo peggioramento | Operazioni | Posizioni attraverso l'NFP spento / acceso (2013 / 2020 / 2025) | Esito |
|---|---|---|---|---|---|---|---|
| Goldbot L0 | 77.052 vs 79.920 (**-3,6%**) | 36.075 / 22.962 / 18.015 contro 36.687 / 25.220 / 18.014 | +0,55 pt | 0 | +2,2% | 2 / 2 / 0 contro 0 / 0 / 0 | NEUTRO |
| Goldbot L3 | 60.267 vs 62.504 (**-3,6%**) | 27.985 / 18.110 / 14.172 contro 28.502 / 19.831 / 14.171 | +0,37 pt | 0 | +2,2% | 2 / 2 / 0 contro 0 / 0 / 0 | NEUTRO |
| Phantom L1 | 87.997 vs 88.706 (-0,8%) | 20.418 / 23.989 / 43.590 contro 23.934 / 23.889 / 40.883 | +0,29 pt | 689 EUR (0,43 pt) | +1,9% | 17 / 8,5 / 3,5 contro 12 / 10 / 0 | NEUTRO |
| Reaper L3 | 45.287 vs 42.459 (**+6,7%**) | 13.444 / 13.091 / 18.752 contro 13.267 / 11.577 / 17.616 | +0,25 pt | 159 EUR (0,10 pt) | +3,0% | 4 / 4 / 0 contro 1,5 / 3 / 0 | NEUTRO |
Banda per Phantom e Reaper: minimo 10% (il riferimento di Reaper 2020 ha una sola ripetizione).

## Previsioni N1-N9 (sull'oro; GTP in attesa)
N1 21 passate valide: **vera per l'oro** (18/18; GTP da rifare) · N2 operazioni in aumento in almeno 4 EA su 5: **vera sull'oro** (4/4: +1,9 / +2,2 / +2,2 / +3,0%) · N3 nel 2025 almeno una posizione attraversa l'NFP in ogni EA: **falsa** (Goldbot 0, Reaper 0; solo il Phantom 3-4) · N4 netto cambia piu nel 2025 che nel 2013 e 2020: **falsa** · N5 Goldbot cambia meno del 5%: **vera** (-3,6% e -3,6%) · N6 almeno un EA PEGGIORE: **falsa** (nessuno) · N7 almeno un EA MIGLIORE (oltre +10%): **falsa** (massimo +6,7%) · N8 peggior giorno oltre 0,5 punti: **falsa** (massimo 0,43 pt) · N9 verdetto del portafoglio: vedi sotto.

## Verdetto (regole dei criteri) e lettura
- Regola scritta: "SPEGNERE CONVIENE" se almeno 3 EA su 5 sono MIGLIORE o NEUTRO e nessuno e PEGGIORE. **4 su 4 EA oro sono NEUTRO, nessuno PEGGIORE**; il GTP (quinto EA) non ha una misura valida. Quindi la regola dice formalmente **SPEGNERE CONVIENE (provvisorio, manca il GTP)**.
- **Lettura onesta: non cambia niente.** NEUTRO significa che il netto non cambia in modo distinguibile dal rumore (da -3,6% a +6,7%), il DD sale di 0,25-0,55 punti e il peggior giorno peggiora al massimo di 0,43 punti. **Spegnere il filtro non porta un guadagno misurabile.** Con 2013 e 2020 il filtro di per se agiva poco (alcune posizioni lo attraversavano gia).
- **Il tester non allarga lo spread nelle news**: il rischio vero dell'NFP (spread e slippage di decine di dollari in pochi secondi) non e nel test. Quindi un esito neutro **non basta a dire che sia sicuro spegnerlo** su un conto prop. Tenerlo acceso (parere di Massimo e mio) resta la scelta prudente, a costo praticamente nullo nel tester.
## Limiti
Un percorso per anno, Phantom e Reaper con rumore (2 ripetizioni); date NFP da una lista mia; il GTP non e misurato; nessun test di spread nelle news. Nessun giudizio su lotti o taglie.
