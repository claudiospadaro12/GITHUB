# Terzo EA candidato dall'oro D1 di Wim (ott. 1): regola di scelta e criteri, scritti PRIMA dei prossimi numeri (28/11/2026)

**Natura:** candidato di ricerca. Motore e set sono di Wim: restano FUORI dalla flotta prop finche Claudio non cambia la decisione del 21/11. Famiglia oro D1: un solo posto. Nessun consiglio su taglie.

## Passo 1: regola di scelta (fissata ora, deterministica, `ubs_r4_parse.py` + dati `RISULTATI_R4_2026-11-28.csv`)
**Onesta':** la regola e' scritta DOPO aver visto V1 e V3 di R4 (i 20 set), quindi V1 e V3 non sono piu' indipendenti per il set scelto. La prova pulita e' l'hold-out 2023-24 (mai aperto) al passo 4, aperto UNA volta.
1. **Pool:** i 20 set di R4 (10 selezionati + 10 controlli: tutti passaggi dell'ottimizzazione, la scelta non favorisce i "selezionati").
2. **Cancelli:** V1 (1 min 2004-12) PF >= 1,20, anni negativi <= 40%, >= 20 op; V3 (tick 2025-26) PF >= 1,0 e **>= 20 operazioni**.
3. **Punteggio = minimo tra PF V1 e PF V3** (il peggiore dei due periodi, non il picco in campione: riduce l'effetto vincitore). **Nessun uso del PF dell'ottimizzazione.**
4. **Ordine di scelta:** il punteggio piu' alto; i successivi sono riserve da usare SOLO se il primo fallisce i cancelli dei passi 2-5, nell'ordine.

**Risultato della regola (calcolato ora):** 14 set passano i cancelli (esclusi n. 1, 3, 11, 16, 17, 18: 16-19 operazioni o anni negativi). Ordine: **n. 4** (`O04_XAUUSD_D1_GVD_SEL_p233`, punteggio 2,42: PF 2,89 / 2,42, 130 e 28 op, 0 anni negativi), poi n. 10 (2,22), n. 14 (2,19), n. 2 (2,12). Nota: il n. 16 (PF 3,78 / 3,81, il piu' alto) e' escluso per 19 operazioni nel V3.

## Passi successivi (criteri)
- **P2 correlazione con GoldenZoe:** r mensile sui risultati V1 e V3, soglia |r| <= 0,5 (come tutta la campagna).
- **P3 perturbazione (V2):** parametri numerici del set (distanze, periodi) ±20%, un parametro alla volta, 1 min 2004-12: passa se >= 70% dei vicini ha PF >= 1,20 e nessuno e' in perdita netta. Richiede una riga sul PC.
- **P4 hold-out 2023-01..2024-12, 1 minuto, UNA volta:** PF >= 1,20, utile > 0, >= 20 op.
- **P5 prop:** drawdown massimo per lotto sulle passate; con i limiti 4% giornaliero / 8% totale (`config/soglie.json`) e in combinazione con GoldenZoe. Nessun consiglio su taglie: la misura e' per lotto.
- **Esito:** passa tutto = "candidato oro D1 (Wim)" per la decisione di Claudio; fallisce = si passa alla riserva (max 3, poi stop: contatore delle prove).

## Previsioni (scritte ora)
- Q1 |r| con GoldenZoe <= 0,5: 85%. Q2 perturbazione passa: 50%. Q3 hold-out passa: 65%. Q4 PF hold-out inferiore al PF V1 (2,89): 80%. Q5 passa tutto i passi 2-5: 30%.

## Limiti
Pool di 20 con V1/V3 gia' visti; V3 con 28 operazioni; oro del 2004-12, 2025-26 e 2023-24 con trend; stessa famiglia di Wim (rischio "strategia unica"/popolarita' per FTMO); il set e' di Wim: mai clonare il motore.

## Passi 3-4: dettaglio della riga R5 (aggiunto 28/11, prima dei numeri)
- **Riga:** `report/RIGA_UBS_R5.txt` (corta) -> riga lunga `backtest_pipeline/righe/RIGA_LANCIA_UBS_R5.txt` @ `6e969052`; passate in `report/UBS_NOTTE/JOBS_R5.csv` (39): RP00A controllo (set intatto, deve ridare PF 2,89 / 130 op), RP01A-RP37A perturbazioni, **RP00H hold-out 2023-01..2024-12 a 1 minuto, ultima passata, aperta una volta sola**. Parser `ubs_r4_parse.py` adattabile.
- **Perturbazioni:** i 20 parametri che l'ottimizzazione variava (flag Y nel set), uno alla volta a -20% e +20% (interi arrotondati, decimali a 0,5), 1 minuto 2004-2012, stesso periodo di V1. **Limitati al range dell'ottimizzazione:** ATRDefault +20% -> 50 (+5%), ATR_Period +20% -> 150 (+12%), ST1_countback +20% -> 250 (+14%). **Saltati (nessun vicino a +-20%):** ST1_MaxPendingOrders (1, discreto) e ST1_Expiration_hours -20% (sotto il minimo del range 24): 37 vicini.
- **Verdetto P3:** >= 70% dei 37 vicini (>= 26) con PF >= 1,20 e nessuno in perdita netta; il controllo RP00A deve riprodurre PF 2,89 (altrimenti la riga non e' affidabile e si ferma tutto).
- **Verdetto P4:** hold-out PF >= 1,20, utile > 0, >= 20 operazioni. Se P3 fallisce, il n. 4 e' scartato e l'hold-out per le riserve va rifatto con riga propria (questo hold-out e' del solo n. 4).
- Tempo stimato: R4 faceva 4-5 minuti per passata D1 a 1 minuto 2004-12: circa 3-4 ore.
