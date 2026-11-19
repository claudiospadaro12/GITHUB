# GoldenZoe su tutti i simboli del Market Watch BCM (parametri di default): criteri scritti PRIMA dei numeri (19/11/2026)
**Domanda:** il metodo di GoldenZoe (breakout 55 candele H4, stop iniziale 3 ATR + stop mobile 3 ATR, **solo acquisti**) funziona anche su altri mercati, cosi' da avere piu' occasioni indipendenti? Modalita' "tutti i simboli del Market Watch" del tester (`Optimization=3`), H4, Modello 1, 100.000 EUR, rischio 1% dell'EA, **parametri = default dell'EA, nessuna ottimizzazione**, swap e spread BCM. Finestre: **IS 2013-2020** (selezione) e **OOS 2021-2024** (giudizio); 2025-2026 intatto. Riga: `RIGA_GOLDENZOE_MARKETWATCH_BCM.txt`. **L'oro (XAUUSD) e' il controllo positivo:** deve risultare selezionato e validato, altrimenti il test non e' attendibile.
**Porte (scritte ora, come per il Breaking Band):** simbolo **selezionato in IS**: >= 30 operazioni, PF >= 1,3, DD equity <= 15%; **validato**: selezionato in IS e in OOS >= 15 operazioni, PF > 1,2, profitto > 0. **Confronti multipli:** N simboli = N tentativi, in parte correlati (cross forex, indici): con N circa 20 per puro caso ci si attende circa 1 "selezionato"; conta solo l'OOS. Gli indici hanno storico nativo solo dal 2024: 0 operazioni in IS (non valutabili).
**Avvertenza costi:** il tester applica a ogni simbolo il swap attuale BCM costante anche agli anni vecchi (visto sull'oro: -98,78 punti, irrealistico nel 2013-2015); i simboli con swap in punti vengono penalizzati nel 2013-2020: leggere il PF IS con prudenza e confrontarlo con il PF OOS.
## Previsioni
- Oro selezionato in IS e validato in OOS (controllo positivo): **65%** (il swap BCM lo penalizza; il simulatore dava PF 1,3-1,7 senza swap).
- Altri simboli validati oltre all'oro: **0: 60%**; 1-2: 35%; 3 o piu': 5%. L'argento (XAGUSD) e' il candidato piu' probabile (40% di essere selezionato in IS).
- Operazioni IS mediane per simbolo (2013-2020, 8 anni) sotto 30 (non selezionabili per numero): **65%**.
## Limiti
Un periodo per mercato; il Market Watch del terminale portabile contiene solo alcuni simboli; il swap costante e' un costo attuale applicato al passato; nessun test a tick.

## ESTENSIONE a PIU' TIMEFRAME (richiesta del 19/11) — criteri scritti PRIMA dei numeri
La stessa regola (canale 55 candele, stop 3 ATR + stop mobile 3 ATR, solo acquisti) su **6 timeframe: H1, H2, H4, H6, H8, D1** x 2 finestre (IS 2013-2020, OOS 2021-2024) = 12 passate. Ogni TF e' una prova a se' (l'EA usa `InpTF` e il tester `Period` coerenti).
**Confronti multipli:** circa 20 simboli x 6 TF = **circa 120 test**, per solo caso ne saltano fuori diversi. **Porta rafforzata:** un simbolo e' **VALIDATO** solo se supera la porta (IS: >= 30 operazioni, PF >= 1,3, DD equity <= 15%; OOS: >= 15 operazioni, PF > 1,2, profitto > 0) **in almeno 2 timeframe adiacenti** (per esempio H4 e H6, o H2 e H4); un simbolo valido in un solo TF e' un indizio debole, non un candidato. L'oro e' il controllo positivo (deve passare in almeno 2 TF adiacenti, atteso H4 e H6 o H8).
## Previsioni (sostituiscono quelle a H4 singolo dove diverse)
- Oro validato in almeno 2 TF adiacenti: **55%**.
- Altri simboli validati (2 TF adiacenti) oltre all'oro: **0: 70%**; 1-2: 27%; 3 o piu': 3%.
- Simboli "indizio debole" (validati in un solo TF) oltre all'oro: almeno 2: **60%** (confronti multipli).
- H1 e H2: PF IS mediano tra i simboli sotto 1,0: **75%** (costi relativi piu' alti, come visto sull'oro).
