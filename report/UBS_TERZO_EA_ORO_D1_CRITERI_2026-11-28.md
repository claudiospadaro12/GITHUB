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
