# R104 — QUANTO RESTITUISCE IL TRAILING? (MaxMinNotte DAX, misura MFE)

_Corsa 25/08 07:38 (42 secondi!), pin `4be07ed`, tick reali 2024.09.26→
2026.08.24, copia di misura magic 750010 (vivi mai toccati). ESITO
formale: **NON MISURABILE** — n=29, una operazione sotto il cancello G1
(30). I CONTEGGI restano fatti e si leggono come conteggi, mai come
frequenze._

## I conteggi (n=29, 23 mesi)
- **16 su 29** hanno toccato 1R (geometrico) — l'istogramma è bimodale:
  o muore presto (<0,3R: 5) o arriva al traguardo (≥1R: 16).
- **5 operazioni** hanno fatto ≥0,5R di flottante e sono tornate indietro
  senza parziale eseguita (il caso del trade #3221475 di ieri): su queste,
  **restituito in media 1,25R dal picco**. Il fastidio di Claudio è reale
  e ora ha un numero.

## MA il verdetto sta nel confronto col tetto
| strategia | totale raccolto |
|---|---:|
| **Il sistema vero** (parziale a 1R + runner col trailing largo) | **12,93 R** |
| "Incassa tutto a 1R appena tocca" (tetto teorico irrealizzabile) | 6,60 R |

**Il meccanismo attuale raccoglie QUASI IL DOPPIO di quanto farebbe chi
incassasse sempre al primo obiettivo.** I 5 casi di restituzione (≈6R
ridati al mercato) sono il PREZZO dei runner che vanno a 3-4R — e i
runner pagano il conto con gli interessi. Il "+200 diventato +15" di ieri
è il biglietto d'ingresso di un cinema che rende 2x.

## Verdetto operativo
- **Nessun cambio al forward** (come da criteri): il trailing largo è
  NET-POSITIVO forte su questa sedia/finestra.
- L'idea Parabolic-SAR (live del corso) resta misurabile in un gradino
  futuro, ma ora si sa l'asticella: deve battere 12,93R — non basta
  "restituire meno".
- Nota tecnica agli atti: `tp1_toccato` (flag contabile) ≠ 1R geometrico
  (il trailing sposta lo stop e ManagePos ricalcola R): la divergenza è
  essa stessa un risultato, documentato nel referto driver.
