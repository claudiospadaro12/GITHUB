# 🏁 R106 — REFERTO: LA SQUADRA DA CHALLENGE

_Eseguito il 25/08/2026 alla firma. 481 partenze rolling sui 21 mesi +
163 sulla sola finestra di verifica. Challenge: +10% prima di −5%
giornaliero o −10% totale (muri statici, trailing FTMO NON modellato).
[APPROSSIMATO]: chiusure giornaliere → violazioni = LIMITE INFERIORE._

## La tabella madre (percentuale di partenze che PASSANO)

| squadra | 21 mesi | solo verifica (7m) | giorni mediani al +10% |
|---|---:|---:|---:|
| **A — flotta 35, taglie attuali** | **99,2%** | **97,5%** | **16** |
| **B — flotta 35 × 0,74** | 98,3% | 95,1% | 22 |
| C — squadra ristretta 17 (regola PF/DD/n) | 95,8% | 87,7% | 28 |
| D — squadra 17 × 0,74 | 93,1% | 79,8% | 33 |

Violazioni dei muri: **ZERO in tutte le configurazioni** — tutte le
non-passate sono TRONCATE (partenze troppo vicine alla fine dei dati).

## Le tre letture, nell'ordine giusto

1. **La squadra ristretta PERDE, di nuovo.** Tagliare sedie rallenta il
   viaggio verso il +10% (16→28 giorni) senza comprare sicurezza (i muri
   erano già a zero violazioni). R105 l'aveva detto per il profitto,
   R106 lo conferma per la challenge: **la flotta È la squadra** — su
   entrambe le finestre, verifica compresa.
2. ⚠️ **MA lo "zero violazioni" della squadra A è un filo di rasoio
   TRAVESTITO da margine.** Il peggior giorno del banco è −4.737€ su un
   muro di 5.000€: passato per **263€**, cioè il 95% del muro toccato —
   su CHIUSURE giornaliere: il picco INTRA-day di quel lunedì dei gap
   quasi certamente il muro l'ha sfiorato o bucato. Lo zero di tabella
   è il limite inferiore dichiarato, non una garanzia.
3. **Per questo la raccomandazione NON è la A.** È la **B**: flotta
   intera × 0,74 → passa il 95-98% delle volte in ~3-4 settimane, e il
   peggior giorno scende a −3,5€k su 5€k di muro = **margine VERO** anche
   contro i picchi intraday invisibili. Si paga con ~6 giorni in più di
   viaggio: è il premio assicurativo più economico mai misurato in casa.

## Verdetto proposto (firma SEPARATA quando si aprirà una challenge)
**Challenge = flotta INTERA con manopola globale ×0,74** (in pratica: la
convenzione 0,65-0,75 del 100k applicata a tutte), Guardian completo
(B1+C1+S1 col latch sul target). Nessuna squadra ristretta.
Avvertenze permanenti: banco lordo-ottimista di UN regime; il mediano di
16-22 giorni in reale sarà più lento; FTMO 1-step (trailing) richiede
misura a parte.
