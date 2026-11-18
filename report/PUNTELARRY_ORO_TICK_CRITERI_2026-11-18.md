# PunteLarry sull'oro: Modello 1 contro TICK REALI — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Natura: solo tester (BCM portabile, XAUUSD, H1, default dell'EA, rischio 1%, deposito 100.000 EUR), due passate sulla **stessa finestra**: Modello 1 e Modello 4 (tick reali). Finestra: da 2024-08-01 (l'oro ha tick reali BCM dal 10/07/2024) fino all'ultimo mese consecutivo con tick in cartella, massimo 2026-10-01 (la riga misura la copertura e la salva in `COPERTURA_TICK_XAUUSD.txt`). Seguito di `PUNTELARRY_ORO_2024_26_CRITERI_2026-11-18.md` (M1 2024-01/2026-10: 41 op., PF 1,28, +3,87%).
**Limiti dichiarati:** una sola passata per modello; ~2 anni di finestra (poche decine di operazioni, t basso); i tick reali coprono solo questa finestra: **non dicono nulla sul 2005-2023**; non e un test fuori campione nuovo, e un controllo di affidabilita dell'esecuzione.
## Porte (nessuna ritoccabile)
- **CONFERMATO A TICK:** Modello 4: PF sui rendimenti per operazione >= 1,20, rendimento > 0 e >= 8 operazioni.
- **NON CONFERMATO A TICK:** PF < 1,20 o rendimento <= 0. NON VALUTABILE: < 8 operazioni, errore o copertura < 12 mesi.
- **Confronto con M1 (soglie di Wim):** rapporto PF tick/M1 >= 0,7 = PASS, < 0,5 = FAIL, in mezzo = CAUTION; operazioni diverse al massimo 10%. Se anche il M1 sulla stessa finestra non passa le porte, il confronto si riporta ma il verdetto sul tick non cambia.
## Previsioni
- CONFERMATO A TICK: **40%**; NON CONFERMATO: **50%**; NON VALUTABILE: **10%**.
- M1 sulla stessa finestra (2024-08/2026-10) passa le porte: **65%** (taglia i primi 7 mesi del 2024).
- Rapporto PF tick/M1 >= 0,7: **65%**; numero di operazioni entro il 10%: **60%** (ordini pendenti: i tick possono attivarli in modo diverso).

## Risultato (18/11/2026; 2 passate OK; `PUNTELARRY_TICK_dati/`)
Finestra 2024-08-01 -> 2026-10-01 per entrambe; il report del tester dice **100% tick reali, 166 milioni di tick** (M4) contro 99% e 3 milioni (M1).
| | Op. | Rend. | PF | t | DD | Anni (rend. %) |
|---|---|---|---|---|---|---|
| Modello 1 | 39 | +6,24% | 1,50 | 0,91 | 5,9% | 2024 +3,06 / 2025 +0,16 / 2026 +3,06 |
| **Modello 4 (tick reali)** | **39** | **+5,56%** | **1,44** | 0,82 | 5,9% | 2024 +3,01 / 2025 -0,03 / 2026 +2,66 |

**Verdetto: CONFERMATO A TICK** (PF 1,44 >= 1,20, rendimento > 0, 39 >= 8 operazioni). Rapporto PF tick/M1 = 0,96 -> **PASS** (soglia 0,7); operazioni identiche (0% di differenza, soglia 10%). Previsioni: CONFERMATO 40% -> si; M1 stessa finestra passa 65% -> si; rapporto >= 0,7 (65%) -> si; operazioni entro 10% (60%) -> si.
**Lettura onesta:** l'esecuzione a tick non cambia la storia: le operazioni sono le stesse e i numeri quasi uguali, quindi il risultato non dipende dall'artefatto delle barre da 1 minuto. **Attenzione:** la finestra da agosto 2024 e imposta dai tick (disponibili dal 10/07/2024), ma esclude 2 operazioni perdenti del gen-lug 2024 presenti nel test M1 piu lungo (PF 1,28, 41 op.): **il numero da citare resta PF 1,28 su 2024-26, non 1,44.** Resta il limite principale: ~2 anni, 39 operazioni, t 0,8, 2025 praticamente piatto (-0,03%), il 2024 e il 2026 pesano quasi tutto. PunteLarry oro rimane un **indizio solido sull'esecuzione, debole sulla significativita**; non generalizza a EURUSD (0/3). Non si promuove: e un candidato da tenere in forward demo piccolo solo se Claudio lo decide.
