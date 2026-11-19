# Nikkei 225 long-only sul CFD del broker (BCM `225JPY`): criteri PRIMA dei numeri (19/11/2026)

Candidato: Nikkei 225 long-only, screening D1 su Yahoo (N=20 e N=55) -> IS, OOS e hold-out 2025+ passati (`GOLDENZOE_ALTRI_MERCATI_CRITERI`); correlazione con GoldenZoe oro circa 0. **Qui si prova l'esecuzione sul CFD reale del broker** (spread, swap, orari): `225JPY` del tester BCM portabile, storico nativo dal 2024, quindi **solo controllo di esecuzione, non statistica** (14-16 operazioni).
**EA:** `GoldenZoe_H4` v1.10 senza modifiche (e generico: simbolo e timeframe dal grafico), long-only, ATR 14, stop 3 ATR, Chandelier 3 ATR, rischio 1%, 100.000 EUR, Modello 1, **2024-01-01 -> 2026-10-31**, filtro news spento.
**Passate (3):** **D1 N=20**, **D1 N=55** (le varianti validate), **H4 N=55** (richiesta di Claudio, **ESPLORATIVA**: l'H4 non ha dati lunghi per essere validato; resta solo descrittiva).
**Riferimento dal simulatore D1 (Yahoo Nikkei, ingressi 2024-01 -> 2026-10):** N=20: 16 operazioni, PF 1,85, +4,9 R; N=55: 14 operazioni, PF 1,59, +3,0 R.
**Swap (dai dati misurati):** BCM `225JPY` modo "interesse annuo": long **-1,40%**, short -1,15% del prezzo; FTMO `JP225.cash` -901 punti long (circa 5,5% annuo del nozionale). Su BCM il costo e basso.

## Previsioni (prima dei numeri)
- D1: operazioni del tester entro +-3 dal simulatore (16 e 14): **65%**.
- D1: segno positivo come il simulatore: **75%**; PF tester >= 1,2: **60%**.
- D1 N=20 e N=55: DD equity <= 8%: **80%**.
- H4 N=55: segno positivo: **55%** (nessun riferimento; esplorativo).
## Regole di esito
1. **Esecuzione confermata (D1)** se operazioni entro +-3 dal simulatore E segno uguale (netto > 0 con stesso verso). Altrimenti si indaga la differenza (dati BCM contro Yahoo, orari, spread) prima di altro.
2. Nessun giudizio statistico: troppo poche operazioni. Si riportano PF, DD, swap totale, operazioni.
3. **H4:** descrittivo; un risultato positivo NON e una validazione e non cambia l'esito dello screening.
4. Passo successivo (non in questa passata): stesso test su `JP225.cash` FTMO se i dati sono disponibili; nessun demo prima.
