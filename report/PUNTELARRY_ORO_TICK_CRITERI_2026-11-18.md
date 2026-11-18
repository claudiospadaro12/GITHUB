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
