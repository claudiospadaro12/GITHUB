# PTE (H4) e WOL (D1) sui 28 cross forex: criteri PRIMA dei numeri (20/11/2026)

**Correzione a quanto detto prima:** PTE e WOL **erano gia' stati provati sull'oro** (`FAMIGLIA1_ORO_CRITERI_2026-11-18.md`): PTE H4 2015-2023 92 operazioni, PF 0,48, NON REGGE (2005-2014: PF 1,02); WOL D1 **0 operazioni** ai default (NON VALUTABILE: doji Heikin Ashi sulla linea di apertura settimanale non scatta mai sull'oro). **Mai provati sul forex**, che e' il mercato dove il corso/le live li applicano. E' quello che si misura ora.
**Test:** EA `ABTG_PTE` (H4) e `ABTG_WOL` (D1) invariati, parametri di default dei sorgenti (nessuna ottimizzazione; filtro news spento; `InpVerbose=false` solo per ridurre il log), 28 cross forex, **2013-01-01 -> 2024-12-31**, BCM portabile, Modello 1, spread del tester, rischio 1% degli EA. 56 passate (hold-out 2025-26 non usato). **IS 2013-2020 / OOS 2021-2024** per data di chiusura. Le tabelle dei canali TMA per coppia della guida PTE (`Setting_canali_PTE`) non sono nel repository: si usano i default (56/100/2,0), limite dichiarato.
## Previsioni
- PTE: PF pooled sui 28 cross in IS tra 0,8 e 1,15: **65%**; in OOS < 1,2: **85%**.
- WOL: operazioni totali sui 28 cross in 12 anni >= 100: **45%**; < 30 (NON VALUTABILE di nuovo): **25%**.
- Un EA supera le porte sotto (pooled): **10%**.
## Regole di esito (invariate dopo i numeri)
**CANDIDATO** (per EA, sull'insieme dei cross con le operazioni sommate) se: IS PF >= 1,3 con >= 100 operazioni; OOS PF > 1,2 con >= 50 operazioni; R medio per operazione con IC90 inferiore > 0 su IS+OOS; almeno 8 anni su 12 non negativi sul pooled; **il risultato non dipende da un solo cross ne da un solo anno** (leave-one-out: PF sempre > 1,0); prova di deriva (long contro short non entrambi dipendenti da un solo lato). Meno di 100 operazioni IS pooled = **NON VALUTABILE** (si dice, non e' un no). Cross singoli: solo descrittivi (28 cross vicini non indipendenti, 56 prove: qualcuno sembrera' buono per caso). Nessun consiglio di taglie. Nessun parametro cambiato dopo i numeri: una variante e' una prova nuova.

## RISULTATI (56 passate ricevute 20/11; analisi sulle serie giornaliere di rendimento: unita' = giorno con almeno un'uscita, rendimento / 1% di rischio = R; i 28 cross sommati)
| EA | IS 2013-2020 | OOS 2021-2024 | tutto | anni positivi | cross con PF>1 in IS e OOS |
|---|---|---|---|---|---|
| **PTE (H4)** | n 1.066, R -0,106, **PF 0,76**, win 51% | n 508, R +0,106, **PF 1,31**, IC90 inf +0,043, win 62% | PF 0,91, R -0,038 (IC90 inf -0,074) | **4 su 12** (2018, 2021-24; negativi 2013-17, 2019-20) | 3 su 28 (nei cross singoli n = 16-44, caso) |
| **WOL (D1)** | n 1.335, R -0,012, **PF 0,66**, win 20% | n 633, R -0,007, **PF 0,75**, win 16% | PF 0,69 (IC90 inf -0,017) | 3 su 12 | 3 su 28 |
- Operazioni (tester): PTE 2.673, WOL 7.753 (il tester conta anche le chiusure parziali); netto tester sommato sui 28 conti da 100k: PTE -59.896 EUR, WOL -20.333 EUR.
- **Nessun EA e CANDIDATO.** PTE fallisce IS (PF 0,76 contro 1,3) e gli anni positivi (4 su 12); WOL perde in IS e OOS (PF 0,66 e 0,75). **WOL sul forex scatta (7.753 operazioni) mentre sull'oro 0:** il motore esiste, non ha vantaggio.
- **Osservazione per PTE (generata DOPO aver visto i numeri, ipotesi non provata):** perde in 2013-2020 (7 anni su 8 negativi) e guadagna dal 2021 (+1, +7, +18, +28% somma dei 28 cross). Puo' essere un cambio di regime (volatilita'/trend) o caso. Non e' un risultato: l'unico controllo pulito e' il periodo mai toccato 2025-26 (hold-out), con una previsione scritta prima e una sola prova; non e' stato fatto.
- Previsioni: PTE PF IS 0,8-1,15 (65%): **no, 0,76 (appena sotto)**; PTE OOS < 1,2 (85%): **no, 1,31**; WOL >= 100 operazioni (45%): **si'**; un EA supera le porte (10%): **no**.
