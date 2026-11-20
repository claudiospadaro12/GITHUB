# PTE e WOL, batch 1: cinque varianti dai documenti di Emiliano (solo input degli EA): criteri PRIMA dei numeri (20/11/2026)

**Fonte:** `PTE_WOL_FEDELTA_EA_2026-11-20.md` (Sala, 4 agenti). Varianti scelte dalle frasi dei documenti, nessun parametro cambia dopo i numeri. **Base di confronto (gia' misurata, 28 cross, 2013-2024):** PTE IS PF 0,76 / OOS 1,31 (2025-26: 1,07, esaurito); WOL IS PF 0,66 / OOS 0,75.
| ID | EA | Cosa cambia (input) | Frase del documento |
|---|---|---|---|
| V2 | PTE H4 | `InpDojiBodyMaxPct=20` (default 10) | guida: Emiliano usa corpo 20 (a volte 25) |
| V4a | PTE H4 | `InpSLfromDoji=true`, `InpSLbufferPips=5` | presentazione p.28: stop 5/10 pip oltre massimo/minimo della Doji |
| V4b | PTE H4 | `InpSLfromDoji=true`, `InpSLbufferPips=10` | idem (10 pip) |
| W2 | WOL D1 | `InpUseChannels=true` (canali TMA 56/100/2) | checklist: Doji dentro i canali, risposta attesa "si'" |
| W3 | WOL D1 | `InpUseEmaTrend=true` (EMA200 come proxy di "fine trend") | sine qua non p.17: Doji alla fine di un trend; il documento non definisce "trend": proxy EMA200 scelto ora |
**Prova:** 28 cross forex, **2013-01-01 -> 2024-12-31**, BCM portabile, Modello 1, parametri di default per il resto, `InpVerbose=false`. 140 passate. IS 2013-2020 / OOS 2021-2024 per data di chiusura (serie giornaliere dei 28 cross sommate, R = rendimento / 1%, come per la base). **Il 2025-26 non si usa** (esaurito per PTE; per WOL sul forex non e' stato usato ma lo si riserva a un'eventuale conferma).
**Molteplicita':** 5 varianti guardate (piu' le 2 basi): la soglia resta quella gia' scritta (non si abbassa) e un risultato e' letto come esplorativo finche' non c'e' una conferma su dati nuovi.
## Previsioni
- Almeno una variante migliora la base in PF sia in IS sia in OOS: **30%** (cinque tentativi, due finestre).
- PF IS < 1,0 in tutte e cinque le varianti: **75%**.
- V2 (piu' Doji): operazioni PTE +30-150% rispetto alla base: **65%**; PF IS entro +-0,15 dalla base: **60%**.
- W2 e W3 riducono le operazioni WOL di almeno il 30%: **80%**.
- Una variante supera tutte le porte sotto: **4%**.
## Regole di esito (invariate dopo i numeri)
**MIGLIORA LA BASE** = PF IS e PF OOS entrambi sopra quelli della base, con >= 100 operazioni IS. **CANDIDATA** = stesse porte della base (PF IS >= 1,3 con >= 100 operazioni; OOS PF > 1,2 con >= 50 operazioni; IC90 inferiore del R medio > 0 su IS+OOS; >= 8 anni su 12 non negativi; leave-one-out PF > 1,0; prova di deriva). Meno di 100 operazioni IS = NON VALUTABILE. Cross singoli solo descrittivi. Nessun consiglio di taglie. Risultato che passa = si ripete su dati nuovi prima di usarlo.

## RISULTATI (140 passate ricevute 20/11, nessun errore; 28 cross sommati, serie giornaliere, R = rendimento / 1%)
| Variante | IS 2013-2020 | OOS 2021-2024 | Anni positivi | Miglioramento rispetto alla base |
|---|---|---|---|---|
| base PTE | PF 0,76 (n 1.066) | PF 1,31 (n 508) | 4/12 | - |
| **V2** corpo Doji 20% | PF 0,77, R -0,10 (n 1.867) | PF 1,18, IC90 inf +0,016 (n 874) | 2/12 | IS +0,01, OOS -0,13: **no** |
| **V4a** stop Doji 5 pip | PF 0,80, R -0,10 (n 1.074) | PF 1,20, IC90 inf -0,002 (n 507) | 4/12 | IS +0,04, OOS -0,11: **no** |
| **V4b** stop Doji 10 pip | PF 0,81, R -0,09 (n 1.076) | PF 1,24, IC90 inf +0,014 (n 511) | 3/12 | IS +0,05, OOS -0,07: **no** |
| base WOL | PF 0,66 (n 1.335) | PF 0,75 (n 633) | 3/12 | - |
| **W2** Doji dentro i canali | PF 0,65, win 18% (n 789) | PF 0,69, win 14% (n 407) | 2/12 | peggiora in IS e OOS: **no** |
| **W3** fine trend (EMA200) | PF 0,80, win 27% (n 616) | PF 0,96, win 19% (n 289) | 5/12 | **IS +0,14, OOS +0,21: migliora la base** (ma PF < 1) |
- **Nessuna variante e' CANDIDATA** (nessuna con IS PF >= 1,3; tutte sotto 1,0 in IS). **Una sola variante "migliora la base": W3** (taglia le operazioni WOL del 54% in IS e del 54% in OOS e porta il PF da 0,66/0,75 a 0,80/0,96): resta negativa (R IS -0,010, IC90 inf negativo). Su 5 tentativi un miglioramento e' compatibile col caso; lettura esplorativa.
- **PTE: le varianti dai documenti non cambiano il quadro:** perdita in 2013-2022, utile solo nel 2023-24 (V2 +41%/+35%, V4a +35%/+23%, V4b +37%/+18% somma dei 28 cross), come la base. Le due varianti con lo stop sulla Doji hanno meno rischio in IS (PF 0,80-0,81) ma un OOS piu' basso della base (1,20-1,24 contro 1,31).
- **Test a tick reali e costi: non fatto, perche' nessuna variante supera le porte.**
- Previsioni: almeno una variante migliora la base (30%): **si' (W3)**; PF IS < 1,0 in tutte e cinque (75%): **si'**; V2 operazioni +30-150% (65%): si' (+75%); PF IS V2 entro +-0,15 (60%): si'; W2 e W3 riducono le operazioni di >= 30% (80%): si'; una candidata (4%): no.
- Non ancora testate dalla tabella della Sala: V1/W1 (notizie, "sine qua non" nei documenti: richiede di adattare il filtro news degli EA al calendario MT5), V3 (canali per coppia: serve il PDF), V5-V7, W4-W6 (modifiche strutturali).
