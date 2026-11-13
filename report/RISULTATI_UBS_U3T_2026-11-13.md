# UBS U3 tappa 2: il DD misurato in un periodo, provato in un altro — RISULTATI (13/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 1, XAUUSD, deposito 100.000 EUR, qualita 98%). Criteri e previsioni fissati prima: `UBS_U3_CRITERI_2026-11-12.md`; tappa 1: `RISULTATI_UBS_U3A_2026-11-12.md`. Script `D160_dati/analisi_ubs_u3t.py`, dati `D160_dati/ubsu3t.json`. Solo tester; nessun giudizio su lotti, taglie, acquisti.
Validita: 18/18 passate valide (deposito 100.000, qualita 98%, nessuno stop out / no money, `Risk=123`, `MaxRiskPerStrategy_Value=2.0`, `AdjustLotsizeToVariableValues=true` confermati; tutti gli altri input uguali al set; `HistoricalMaxDD` = DD01 dell'altro periodo x 1,15).

## Tabella (DD equity in % del deposito; rapporto = DD01 del periodo di prova / DD01 del periodo di misura)
Incrocio **X** = misura 2013-18, prova 2019-25. Incrocio **Y** = misura 2019-25, prova 2013-18.
| Set | Incr. | HistoricalMaxDD | rapporto | DD% prova | classe | lotto medio |
|---|---|---|---|---|---|---|
| Phantom strat8 | X | 229,34 | 0,81 | 1,58 | PRECISO | 0,21 |
| | Y | 185,42 | 1,24 | 3,03 | LONTANO | 0,41 |
| Phantom strat3 | X | 59,73 | 0,99 | 2,31 | PRECISO | 0,20 |
| | Y | 58,84 | 1,02 | 2,58 | FUORI | 0,34 |
| Goldbot dailyC | X | 19,24 | **0,33** | 0,72 | LONTANO | 0,72 |
| | Y | 6,26 | **3,08** | **8,84** | LONTANO | 4,14 |
| Gold Trade Pro E | X | 38,09 | 1,25 | 3,09 | LONTANO | 0,90 |
| | Y | 47,50 | 0,80 | 2,02 | PRECISO | 1,07 |
| Phantom Gold_c | X | 59,73 | 0,99 | 2,31 | PRECISO | 0,20 |
| | Y | 58,84 | 1,02 | 2,58 | FUORI | 0,34 |
| Goldbot dailyI | X | 100,22 | 0,80 | 1,62 | PRECISO | 0,17 |
| | Y | 80,27 | 1,25 | 2,88 | FUORI | 0,34 |
| Gold Trade Pro a | X | 111,52 | 1,22 | 2,43 | PRECISO | 0,27 |
| | Y | 136,40 | 0,82 | 2,03 | PRECISO | 0,36 |
| Reaper s5 H1 | X | 172,82 | **0,54** | 1,18 | FUORI | 0,18 |
| | Y | 93,17 | **1,85** | 3,79 | LONTANO | 0,54 |
| Reaper s1 D1 | X | 266,89 | 0,89 | 1,76 | PRECISO | 0,08 |
| | Y | 236,46 | 1,13 | 2,44 | PRECISO | 0,16 |
Conteggi (18 casi): **PRECISO 9, FUORI 4, LONTANO 5**. DD% mediano 2,37, media 2,62, minimo 0,72, massimo 8,84. Phantom strat3 e Gold_c sono la stessa strategia (non due prove indipendenti).

## Verdetto (regola fissata prima)
REGGE richiede PRECISO >= 9 e LONTANO <= 2; REGGE CON LIMITI richiede PRECISO 5-8, oppure PRECISO >= 9 con LONTANO 3-4. Qui PRECISO = 9 ma **LONTANO = 5** → per la regola scritta: **NON REGGE**. Per onesta: due dei cinque LONTANO sono appena oltre la soglia (3,03 e 3,09 contro 3,0) e tre dei cinque stanno nei due set dove il DD01 cambiava molto fra i periodi (Goldbot dailyC, Reaper s5).

## Previsioni
| | Previsione | Esito |
|---|---|---|
| U3-3 | PRECISO >= 9 su 18 (25%); >= 5 (65%) | **entrambe vere** (9) |
| U3-4 | LONTANO >= 4 su 18 (65%) | **vera** (5) |
| U3-5 | DD% mediano sopra 2,39 (70%) | **falsa** (2,37, per un soffio) |
| U3-6 | dove il periodo di prova e piu duro, DD% > 2,5 in >= 80% dei casi (80%) | **falsa** (7 su 9 = 78%) |
| U3-7 | REGGE 15% / CON LIMITI 40% / NON REGGE 45% | **NON REGGE** (il 45%) |

## Letture
1. **Il DD% segue il rapporto fra i periodi.** In tutti i 18 casi il DD% e circa 2 x rapporto x un fattore compreso fra 0,98 e 1,44 (mediana 1,16). Quando il DD01 fra misura e prova e simile (rapporto 0,8-1,25: 14 casi), il DD% sta fra 1,58 e 3,09: 9 PRECISO, 3 FUORI, 2 LONTANO (al limite). Dove il DD01 cambia molto fra i periodi (Goldbot dailyC, Reaper s5: 4 casi), il metodo sbaglia: 0,72 e 8,84 per dailyC, 1,18 e 3,79 per Reaper s5.
2. **Confronto con U2 (in-sample)**: B PRECISO 5/9, LONTANO 0/9, DD% 2,00-2,71. Fuori periodo PRECISO 9/18 (la meta) e LONTANO 5/18: la precisione di U2 era in parte circolare, come sospettato. Il caso peggiore, Goldbot dailyC provato nel 2013-18 con il DD misurato nel 2019-25 (5,44 contro 16,73): lotto medio 4,14 e DD 8,84%.
3. **Ipotesi NON testata**: un margine di sicurezza sul DD misurato (come l'arrotondamento in su suggerito da Wim) abbasserebbe il DD% dei casi in cui il periodo di prova e piu duro; non e stato provato in questo test. Non si puo sapere in anticipo se il periodo futuro sara piu duro di quello di misura.
4. Il DD misurato e piu stabile fra periodi per i set con DD01 simile nei due sottoperiodi (tappa 1: 7 set su 9 entro 1,25 volte); per gli altri 2 il metodo richiede cautela.

## Limiti
Un percorso per set (Randomization 0); 6-7 anni per periodo; un solo spezzettamento (2013-18 / 2019-25); cambio EUR/USD 1,15 ipotesi; Modello 1; il lotto cresce col saldo; solo oro e solo questi 9 set (7 strategie indipendenti); nessuna conclusione su lotti o taglie per i conti.
