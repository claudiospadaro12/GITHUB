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
