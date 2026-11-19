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

---
## RISULTATO (19/11/2026, zip GOLDENZOE_NIKKEI; 3 passate su BCM `225JPY`, 100.000 EUR, Modello 1, qualita 99%)
| Passata | Operazioni | PF tester | Netto EUR | Punti (somma) | Swap totale EUR |
|---|---|---|---|---|---|
| D1 N=20 | 12 | 0,69 | -15,26 | +2.288 | -28,7 |
| D1 N=55 | 10 | 0,23 | -46,89 | -2.765 | -21,1 |
| H4 N=55 (esplorativa) | 41 | 1,22 | +16,09 | positivo | -17,7 circa |
**Fatti trovati:**
1. **Storico BCM `225JPY`:** la prima operazione D1 e del 02/05/2025 (472 barre D1) e la prima H4 del 30/10/2024: il confronto col simulatore vale da meta 2025 (simulatore: 9 operazioni per N=20 e 9 per N=55 nella stessa finestra).
2. **BUG DI DIMENSIONAMENTO (EA v1.10 e precedenti):** su `225JPY` il lotto e SEMPRE 0,1 (minimo): `SYMBOL_TRADE_TICK_VALUE` e 10 non convertito in euro, mentre il profitto reale per punto e circa 0,0057 EUR per 0,1 lotto. Il rischio effettivo e quindi minuscolo (DD 0,07%, rendimenti di centesimi di percento): **in EUR e % i risultati non sono confrontabili**. Corretto in **v1.11** con l'opzione `InpLotMode=1` (lotto da `OrderCalcProfit`); il default 0 lascia invariato il comportamento validato sull'oro. Vale per qualsiasi CFD in valuta diversa dal conto.
3. **Swap nel tester BCM molto piu alto della specifica:** circa **13% annuo del nozionale** (sommando swap e giorni di tenuta D1 N=20: -28,7 EUR su 251 giorni con nozionale medio circa 312 EUR per 0,1 lotto), contro -1,40% annuo dichiarato dal simbolo; lo swap supera il profitto lordo (+13,5 EUR). Da verificare sul demo reale (il tester applica lo swap della specifica corrente): FTMO `JP225.cash` circa 5,5% annuo.
4. **Operazioni D1:** 12 (N=20) e 10 (N=55) contro 9 e 9 del simulatore: entro +-3. **Ingressi in comune** con il simulatore: circa la meta (stesse date nel 02/05, 08-11/08, 12/09, 06/01, 08-09/04, 25-26/05 e 16/06; diverse le altre): differenze di dati (CFD BCM contro indice Yahoo) e di ATR (media semplice di MT5 contro Wilder).
5. **Segno:** N=20 positivo in punti (+2.288) ma negativo in EUR dopo lo swap; N=55 negativo anche in punti (-2.765, penalizzato dall'ultima operazione -3.926 punti). Il simulatore e positivo (+4,6 R e +3,0 R sul campione completo).
**Esito (regola 1): esecuzione NON confermata** (segno diverso dal simulatore). Previsioni: operazioni +-3 (65%) si; segno positivo (75%) **no**; PF >= 1,2 (60%) **no**; DD <= 8% (80%) si ma privo di significato per il bug dei lotti; H4 positivo (55%) si (esplorativo). Campione di 10-12 operazioni: inconcludente sul vantaggio, concludente sul costo (swap) e sul bug. Il candidato Nikkei resta valido SOLO sul simulatore D1; su CFD BCM il costo dello swap lo penalizza.

## RIPETIZIONE con lotto corretto (EA v1.11, `InpLotMode=1`): previsioni PRIMA dei numeri
Stesse 3 passate e stessa finestra, rischio 1% vero (circa 1.000 EUR per operazione). Previsioni: lotto medio D1 tra 3 e 12 lotti-indice e rischio per operazione 0,8-1,2% dell'equity: **80%**; swap totale tra 8% e 18% annuo del nozionale (conferma dello swap alto del tester): **70%**; D1 N=20 netto positivo dopo lo swap: **40%**; D1 N=55 netto positivo: **30%**; DD equity D1 N=20 tra 3% e 12%: **65%**. Regola: se lo swap resta > 8% annuo e il netto D1 e <= 0, il Nikkei CFD BCM **non e operativo** a questi costi (nessun test su FTMO finche non si misura lo swap reale sul demo).

---
## RISULTATO DELLA RIPETIZIONE con lotto corretto (EA v1.11, `InpLotMode=1`; zip GOLDENZOE_NIKKEI2; dati in `NIKKEI_CFD_BCM_dati/`)
| Passata | Operazioni | PF | Netto EUR (% su 100k) | DD equity | Profitto lordo | Swap | Lotto medio |
|---|---|---|---|---|---|---|---|
| D1 N=20 | 12 | 0,90 | -202 (-0,20%) | 2,66% | +1.431 | -1.634 | 5,7 |
| D1 N=55 | 10 | 0,41 | -1.703 (-1,70%) | 3,66% | -409 | -1.295 | 5,8 |
| H4 N=55 (esplorativa) | 41 | 1,08 | +939 (+0,94%) | 5,18% | +3.907 | -2.969 | 16,9 |
- **Dimensionamento corretto:** lotti D1 3,0-10,3 (previsione 3-12: si). **Swap: circa 14% annuo del nozionale** (stima da giorni di tenuta e prezzi: 14,2% / 14,0% / 14,8%): previsione 8-18% **si**. Lo swap supera il profitto lordo nelle D1 (N=20: +1.431 contro -1.634) e assorbe il 76% di quello H4.
- **Conferma dal demo reale BCM** (`data/statements/trades_auto.csv`, D30EUR long): swap -3,33 EUR su 0,5 lotti per 1 notte (circa 9,6% annuo), -12,34 su 0,5 lotti per 3 notti (circa 11,7%), -4,80 su 0,6 lotti per 1 notte (circa 11,6%). **Gli indici BCM costano circa 10-14% annuo sul long**, non il -1,40% letto dalla specifica (modo "interesse % annuo": la lettura della cifra era sbagliata).
- Previsioni: D1 N=20 netto positivo (40%): **no**; D1 N=55 (30%): **no**; DD N=20 tra 3% e 12% (65%): **no** (2,66%, appena sotto); swap 8-18% (70%): **si**.
- **Esito (regola scritta):** swap > 8% annuo e netto D1 <= 0 -> **Nikkei CFD su BCM NON operativo a questi costi.** Il vantaggio lordo D1 N=20 (+1,4% in 255 giorni di tenuta con 12 operazioni) non copre il finanziamento. Su FTMO `JP225.cash` (swap circa 5,5% annuo, da scalare: swap N=20 circa -630 EUR, netto circa +800 EUR sullo stesso campione) non e stato provato e i dati FTMO non sono disponibili senza login. **Il tema generale e il costo di finanziamento dei long sugli indici e sull'oro: da inserire nel confronto broker.**
