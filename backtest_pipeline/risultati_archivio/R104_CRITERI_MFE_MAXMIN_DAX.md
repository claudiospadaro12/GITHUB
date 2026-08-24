# 📐 R104 — QUANTO SPESSO IL PROFITTO FLOTTANTE VIENE RESTITUITO PRIMA DI 1R
## (MaxMinNotte DAX Short, misura MFE)

_Nasce dalla domanda di Claudio del 24/08/2026, davanti al trade #3221475
(D30EUR short, +200€ flottanti visti, chiuso a +15,10€ perché il prezzo è
tornato indietro PRIMA di toccare il 1° obiettivo a 1R — confermato dalla
scheda AFFARI: una sola uscita, nessuna parziale). Sua richiesta, in chat:
**"Sì, misuriamo quanto succede."** Questa è l'autorizzazione a procedere;
essendo una misura a bassissimo rischio (una sedia sola, nessun cambio in
forward, nessuna promozione possibile) si scrivono i criteri e si passa
subito alla costruzione — nessuna firma ulteriore richiesta._

## 1. La domanda esatta
Su quante operazioni della sedia viva il prezzo raggiunge un profitto
flottante importante e POI torna indietro **senza mai toccare il 1° target
(1R, dove scatta la parziale + stop in pari)**? E quanto, in media, viene
restituito?

## 2. La sedia (letta dal preset live, magic 770411)
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato`, D30EUR: SL iniziale 2,5× ATR(14,
M15); TP1 a 1R chiude 50% + stop in pari; TP2 a 3R; TPfinal 4R; trailing
2,0× ATR SOLO dopo che il prezzo ha superato l'entrata a favore. **Questi
parametri NON si toccano.**

## 3. Lo strumento di misura
Una **copia di sola misura** dell'EA (mai il sorgente live, mai un file che
tocchi il forward): `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5`, stesso
codice, stessa logica, **con l'aggiunta di UN contatore per posizione aperta**
che ad ogni tick registra il **massimo profitto flottante raggiunto** (MFE,
Maximum Favorable Excursion) espresso in **multipli di R** (R = distanza
entrata-stop iniziale, la stessa unità di misura di TP1/TP2/TPfinal). Alla
chiusura della posizione, una riga CSV con: `open_time, close_time,
mfe_R, realizzato_R, tp1_toccato (0/1), esito`.
**Nessuna decisione di trading cambia**: il contatore legge, non scrive
ordini. Magic di misura nel blocco **750xxx** (verificato libero, zero
occorrenze nel repo), gemelle 750010/750011 — mai i magic vivi (770411/12).

## 4. La finestra
**2024.09.26 → 2026.08.24 (oggi)**: è il massimo storico D30EUR disponibile
sul broker (misurato, sonda 17/08 — indici COMPLETO da quella data), esteso
fino ad oggi per avere il campione più ampio possibile (non ci sono altri
round in coda su questa sedia che impongano una finestra più corta).
Tick reali (modello 4) — coperti dal 2024.07.05, quindi l'intera finestra
ha tick veri.

## 5. I cancelli
- **G1 — campione minimo**: n ≥ 30 operazioni. Sotto, la statistica di
  frequenza è NON MISURABILE (rumore).
- **Nessuna promozione, nessun cambio in forward** (regola di sempre): il
  risultato è INFORMAZIONE su un meccanismo già in campo, non un verdetto.
- **Nessuna cella nuova, nessuna ottimizzazione**: un solo backtest, i
  parametri live esatti.

## 6. Cosa dice il referto
- Distribuzione di `mfe_R` per bucket (es. <0.3R, 0.3-0.5R, 0.5-0.8R,
  0.8-1.0R, ≥1R-toccato-TP1);
- **% di operazioni con MFE ≥ 0,5R che chiudono SENZA toccare TP1** (la
  domanda esatta di Claudio) — e quanto, in media, viene restituito su
  quelle;
- confronto: profitto realizzato totale vs profitto "sulla carta" se ogni
  MFE ≥1R fosse stato incassato (limite superiore teorico, MAI un obiettivo
  operativo — dichiarato come tale).

## 7. Cosa NON fa
Non cambia il trailing, non propone una soglia diversa, non tocca il
forward. Se il round mostrisse che il trailing è "troppo largo", la
conversazione su un eventuale aggiustamento è **successiva e separata**,
con firma propria.
