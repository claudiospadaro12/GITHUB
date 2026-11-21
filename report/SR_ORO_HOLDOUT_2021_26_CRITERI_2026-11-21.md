# Breakout S/R sull'oro H1: conferma su dati NUOVI 2021-2026 (criteri PRIMA dei numeri, 21/11/2026)

**Perche':** Claudio ha mostrato screen dell'oro H1 (ott-nov 2026) in cui "vince visivamente" (LuxAlgo S/R, pivot 15/15). Il test del 20/11 era su oro 2004-2020 (nessun candidato; ipotesi ER del giorno prima esplorativa, tutta negativa). Dati FTMO M1 2021-2026 (`EXPORT_M1_FTMO_20261121_082534.zip`, 6 file, 2.063.000 barre, 13 righe aggregate 00:00 scartate nel 2021). **CORREZIONE (stesso giorno, dopo i numeri): questi file erano GIA' sul server dal 19/11 (`dati_ftmo_C`, byte per byte identici: l'export del 21/11 non aggiunge nulla).** Quindi il test del 20/11 (che si chiamava '2004-2020') girava in realta' su 2004-2026 con taglio al 70% (OOS ~2020-26) e questo NON e' fuori campione puro: e' una riesecuzione con parametri congelati, i terzili ER sono calcolati su tutto lo storico. Il giudizio sotto resta valido ma va letto come conferma della stessa prova, non come dati nuovi.
## Regole fissate ora (nessun parametro riottimizzato)
- Stesso simulatore `sr_breakout.py` (pivot 15/15, ordini pendenti sui due livelli, stop 1,5 ATR, costo 0,35 $/oz), oro **H1**, uscite **E1** (target k ATR) ed **E2** (Chandelier 3 ATR), **k = 1,5** (come nell'esplorazione).
- Terzili del filtro ER (efficienza 20 giorni, giorno prima): **soglie calcolate su 2004-2020 e congelate** (non ricalcolate sul 2021-26).
- Celle: {tutti i trade, ER alto} x {E1, E2} + split per anno e per lato long/short + il solo periodo ott-nov 2026 (quello degli screen). 4 celle principali.
## Previsioni (prima dei numeri)
- Tutti i trade: PF < 1,0 sia E1 sia E2: **85%** (costi e falsi breakout dominano come nel 2004-2020).
- ER alto: PF > 1,2 con >= 100 trade: **15%**.
- Ott-nov 2026 da solo: PF > 1,0: **45%** (un solo regime, non e' una prova: pochi trade).
## Esito
**CANDIDATA** solo se in 2021-26 (n >= 100): PF > 1,2 e R medio > 0 sia per E1 sia per E2 nella stessa cella, lato short non peggiore di PF 0,8, almeno 4 anni su 6 non negativi. Altrimenti non candidata; se i tutti-i-trade sono PF < 1 la "vittoria visiva" negli screen e' selezione di periodo. Nessun consiglio di taglie.

## RISULTATI (script `sr_oro_holdout.py`; oro H1 FTMO 2021-18/11/2026, k = 1,5, costo 0,35 $)
- **E1:** tutti i trade n 3270, R -0,097, **PF 0,82** (t -5,6); ER alto n 1058 **PF 0,90**; long PF 0,89, **short 0,75**. **E2:** tutti n 1608, R -0,205, **PF 0,70**; ER alto n 478 **PF 0,87**; short PF 0,53.
- **Per anno (E1 tutti):** 2021 0,60, 2022 0,77, 2023 0,78, 2024 0,84, **2025 1,04, 2026 0,95**. **ER alto:** 2025 PF 1,23-1,31, 2026 PF 1,20-1,62 (t <= 1,9, n 51-233): positivo solo nei due anni di trend rialzista fortissimo (oro da ~2.600 a ~5.500).
- **Ott-nov 2026 (periodo degli screen):** E1 n 78 R -0,092 **PF 0,83**; E2 n 39 PF 0,84; ER alto solo n 5. **Il "vince visivamente" non si riproduce neanche in quel periodo**: e' selezione dei tratti di grafico scelti.
- **Esito: NON CANDIDATA.** Tutti-i-trade PF < 1 (E1 e E2), ER alto PF < 1,2, short peggiore di 0,8. Previsioni: tutti PF<1 (85%) si'; ER alto PF>1,2 (15%) no; ott-nov PF>1 (45%) no.
