# PTE e WOL, filtro notizie (V1 e W1): criteri PRIMA dei numeri (20/11/2026)

**Fonte:** `PTE_WOL_FEDELTA_EA_2026-11-20.md` (A1 e B8): nei documenti "notizie in arrivo" e' una condizione "sine qua non" (PTE, presentazione p.18, checklist) e voce di checklist (WOL). I documenti **non dicono quanto** e quale impatto: le finestre sono mie e scritte ora.
**Cambiamento agli EA (solo codice del filtro, la strategia e' invariata):** `ABTG_PTE.mq5` e `ABTG_WOL.mq5` hanno due nuovi input, spenti di default (`InpNewsCommon`: legge da Common\Files; `InpNewsPairOnly`: conta solo le notizie delle due valute del simbolo); nessun altro cambio. Calendario: `Common\Files\abtg_news_hist_G8.csv` (export MT5 gia' fatto: 8 valute, 2013-2026, ora server BCM GMT+1 fisso). Solo impatto **Alto**.
| ID | EA | Regola (override degli input) |
|---|---|---|
| V1 | PTE H4 | ingresso bloccato se c'e' una notizia ad impatto alto di una delle due valute **nei 120 minuti successivi o nei 30 precedenti** (`InpNewsBeforeMin=120`, `InpNewsAfterMin=30`) |
| W1 | WOL D1 | ingresso bloccato se c'e' una notizia ad impatto alto di una delle due valute **nelle 24 ore successive o nei 30 minuti precedenti** (`InpNewsBeforeMin=1440`, `InpNewsAfterMin=30`: sul D1 "in arrivo" = la giornata di ingresso; ipotesi mia) |
**Prova:** 28 cross forex, 2013-01-01 -> 2024-12-31, BCM portabile, Modello 1, default per il resto, `InpVerbose=false`. 56 passate. IS 2013-2020 / OOS 2021-2024, serie giornaliere dei 28 cross sommate, R = rendimento / 1%. **Il 2025-26 non si usa.** Base di confronto: PTE IS PF 0,76 / OOS 1,31; WOL IS 0,66 / OOS 0,75.
## Previsioni
- V1 toglie dal 10% al 35% delle operazioni PTE: **60%**; W1 toglie piu' del 40% delle operazioni WOL (finestra di 24 ore): **70%**.
- V1 migliora il PF di PTE sia in IS sia in OOS: **35%**; W1 migliora WOL in IS e OOS: **40%**.
- Una candidata (porte sotto): **3%**. PF IS < 1,0 per entrambe: **85%**.
## Regole di esito (invariate dopo i numeri)
**MIGLIORA LA BASE** = PF IS e OOS sopra la base, >= 100 operazioni IS. **CANDIDATA** = PF IS >= 1,3 con >= 100 operazioni; OOS PF > 1,2 con >= 50 operazioni; IC90 inferiore del R medio > 0 su IS+OOS; >= 8 anni su 12 non negativi; leave-one-out PF > 1,0; prova di deriva. Meno di 100 operazioni IS = NON VALUTABILE. Con le 5 varianti del batch 1 e queste 2 sono 7 tentativi in tutto: lettura esplorativa finche' non c'e' una conferma su dati nuovi. Nessun consiglio di taglie. Il file calendario puo' contenere errori d'orario: nessuna verifica della precisione oltre l'NFP (13:30 server d'estate, 14:30 d'inverno, gia' controllato nel file).

## RISULTATI (56 passate ricevute 20/11, nessun errore; 28 cross sommati, serie giornaliere, R = rendimento / 1%)
| Variante | IS 2013-2020 | OOS 2021-2024 | Anni positivi | Contro la base |
|---|---|---|---|---|
| base PTE | PF 0,76 (n 1.066) | PF 1,31 (n 508) | 4/12 | - |
| **V1** PTE senza notizie (120 min dopo, 30 prima) | PF 0,73, R -0,12 (n 1.005) | PF 1,29, IC90 inf +0,035 (n 473) | 3/12 | peggiora in IS e OOS (-0,03 / -0,02) |
| base WOL | PF 0,66 (n 1.335) | PF 0,75 (n 633) | 3/12 | - |
| **W1** WOL senza notizie (24 ore dopo, 30 prima) | PF 0,61, win 20% (n 774) | PF 0,62, win 16% (n 360) | 2/12 | peggiora in IS e OOS (-0,05 / -0,13) |
- **Il filtro notizie, comunque lo si implementi con queste finestre, non migliora ne' PTE ne' WOL: li peggiora entrambi.** Nessuna candidata (PF IS 0,73 e 0,61).
- Operazioni tolte: PTE -6% in IS e -7% in OOS (le notizie ad impatto alto sono poche nelle ore dell'ingresso H4); WOL -42% e -43%.
- Previsioni: V1 toglie 10-35% (60%): **no, 6-7%**; W1 toglie > 40% (70%): si'; V1 migliora (35%): no; W1 migliora (40%): no; candidata (3%): no; PF IS < 1,0 per entrambe (85%): si'.
- **Chiusura del filone fedelta' PTE/WOL con quello misurato:** 7 varianti (V1, V2, V4a, V4b, W1, W2, W3) piu' le 2 basi, 28 cross, 2013-2024 + PTE 2025-26: **nessuna candidata, nessuna con IS PF >= 1,0; unica a migliorare la base, W3 (WOL fine trend), resta PF 0,80/0,96.** Non testate: V3 (canali per coppia, serve il PDF e la mappatura), V5-V7, W4-W6 (modifiche strutturali). Limite: le finestre notizie sono mie, i documenti non le danno.
