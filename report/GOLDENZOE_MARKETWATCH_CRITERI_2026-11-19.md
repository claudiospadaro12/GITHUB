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

## ESITO DELLA PRIMA CORSA (zip `GOLDENZOE_MARKETWATCH_20261119_1547`, riga a H4 singolo; file in `GOLDENZOE_MARKETWATCH_dati/`)
**Corsa incompleta:** l'XML dell'IS elenca solo 10 simboli (i primi 10 passaggi) e quello dell'OOS e' vuoto; la corsa e' durata circa 2 minuti. **I file `.opt` (cache del tester) pero' contengono tutti i passaggi dell'IS (39 simboli)**: li ho decodificati con `backtest_runner/strumenti/decodifica_opt_tester.py` (formato dedotto e verificato sulle 10 righe dell'XML: PF, profitto, DD e operazioni coincidono).
**IS 2013-2020, H4, default, swap BCM (decodificato):** **nessun simbolo supera la porta di selezione** (>= 30 operazioni, PF >= 1,3, DD <= 15%): i migliori sono USDNOK PF 1,26 (131 op., DD 12,8%), GBPJPY 1,18, USDSEK 1,18, USDCHF 1,16, NZDJPY 1,16, USDJPY 1,15, EURJPY 1,20 (126 op., DD 8,6%); **XAUUSD PF 0,98 (123 op., DD 17,5%)**, XAGUSD (argento) 0,52, XNGUSD 0,29, EURUSD 0,56; la grande maggioranza dei forex e' sotto 1. **Il controllo positivo (oro) non e' selezionato per colpa dello swap BCM costante applicato agli anni vecchi (lo stesso artefatto visto sul test dell'oro: senza swap il PF e' 1,5-1,7)**: lo stesso swap penalizza anche gli altri simboli, quindi il PF IS e' prudente per tutti. **OOS 2021-2024: dati non affidabili** (molti simboli con 1-7 operazioni invece di circa 60: passaggi interrotti): non si usa.
Previsioni: oro validato (65%) -> no (swap); altri simboli validati: 0 (60%) -> si'; mediana operazioni IS sotto 30 (65%) -> no (circa 120): il metodo produce molte operazioni sui forex ma senza vantaggio.
**Lettura:** su 39 simboli a H4 il metodo di GoldenZoe non mostra vantaggio fuori dall'oro; l'oro stesso e' coperto dai test precedenti. Il risultato sull'OOS va rifatto (riga multi-TF aggiornata con attesa degli agenti del tester tra una passata e l'altra e conteggio delle righe dell'XML).

---
## RISULTATO MULTI-TF (19/11/2026, zip GOLDENZOE_MARKETWATCH_20261119_1554) - 12 passate, 6 TF x IS 2013-20 / OOS 2021-24

Dati: `GOLDENZOE_MARKETWATCH_dati/MULTITF_decodificato.json` (cache .opt decodificate; 84 righe XML verificate = 0 differenze).
**Affidabilità:** IS completo (37-39 simboli con operazioni per TF). OOS TRONCATO per molti simboli: rapporto operazioni OOS/IS atteso 0,3-0,9, osservato ~0,01-0,05 su H1/H4/H8/D1 per molti simboli (es. GBPJPY H6/H8 1 operazione, USDJPY H8 1, D1 OOS solo 11 simboli). OOS usato SOLO dove il rapporto e plausibile (>=0,3).
**Controllo oro:** XAUUSD/XAGUSD IS 2013-20 PF 0,26-0,98 su tutti i TF (swap BCM costante distorce il periodo vecchio + oro 2013-20 senza trend): non e un controllo positivo valido.
**PF IS mediano su 37 simboli: 0,78-0,87 su ogni TF** = la regola, in media, perde; il vantaggio non e generale.

### Cancello IS (n>=30, PF>=1,3, DD<=15%) - soglie non allentate
EURCHF H6 (1,35); EURJPY H2 (1,32); EURNOK H6 (1,76); GBPJPY H6 (1,43), H8 (1,93); USDJPY H1 (1,39), H6 (1,67), H8 (1,57); USDNOK H4 (1,35); USDSEK H8 (1,52). 7 simboli su 222 prove (37x6): con tante prove alcuni passano per caso.

### OOS (solo dove affidabile)
| simbolo TF | IS PF n | OOS PF n | esito |
|---|---|---|---|
| EURCHF H6 | 1,35 67 | 1,03 34 | NO (PF<1,2) |
| EURNOK H6 | 1,76 73 | 0,75 44 | NO |
| EURJPY H2 | 1,32 232 | 1,33 134 | si |
| USDJPY H6 | 1,67 86 | 1,95 63 | si |
| USDSEK H8 | 1,52 43 | 1,37 37 | si |
| GBPJPY H6/H8, USDJPY H1/H8, USDNOK H4 | | OOS troncato | NON VALUTABILE |

### Regola "validato = passa in >=2 TF adiacenti": NESSUN simbolo validato
- USDJPY: H6 passa IS+OOS; H8 IS passa ma OOS troncato (1 op.); H4 IS 1,15 (no). Non valutabile.
- USDSEK: solo H8 (H6 IS 0,97). Singolo TF = no.
- EURJPY: IS passa solo H2 (H1 PF 1,36 ma DD 16,6% > 15%: fuori di 1,6 punti, NON allentato). Singolo TF = no per regola.
- **Osservazione (non e un passaggio):** EURJPY ha OOS affidabile su TUTTI e 5 i TF intraday: PF 1,34/1,33/1,39/1,34/1,89, rapporto n 0,55-0,62; IS PF 1,36/1,32/1,20/1,07/1,23 (tutti >1). Plateau coerente tra TF, swap long BCM +1,56 punti (trascurabile, non spiega il vantaggio). Caveat: solo long, 2013-24 = yen debole (deriva rialzista del cross); serve test long/short + placebo + dati OOS completi prima di qualsiasi giudizio.
- JPY crosses: rischio di deriva (yen debole 2013-24); swap long USDJPY +5,10, EURJPY +1,56, GBPJPY +5,83 punti (piccoli).

### Verdetto
Nessun candidato validato. Un solo filone da approfondire con test pre-registrato: **EURJPY long-only intraday (H1-H8)**, esito OOS affidabile e coerente. Per rifare OOS completo serve una passata per singolo simbolo (metodo GOLDENZOE_BCM), non il Market Watch (cache OOS troncata).
