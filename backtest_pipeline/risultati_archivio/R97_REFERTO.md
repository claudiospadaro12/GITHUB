# R97 — REFERTO: lo stop all'estremo opposto NON salva l'ORB sul Nasdaq. 0/4.

**Data verdetto: 22/08/2026 sera. Corsa: tick reali (Model 4), pin `85874e5`,
zip `R97_ORB_NASUSD_CORSA_20260822_2144`. Criteri firmati il 21/08 in
`R97_CRITERI.md` — letti PRIMA dei numeri, come da regola.**

## I gate, prima dei numeri
- **Conversione (par. 3, il gate firmato): MISURATA = 100** (1 punto indice
  = 100 punti MT5), con due misure indipendenti concordi (1.960 ordini in
  modo FIXED, mediana 10 di prezzo; digits del per-trade = 2). Stesso
  fattore di U30USD: i 500 pt di buffer di R97b/c valgono 5 punti indice,
  cioe' la cella regina di R88. **Nessun errore x10 possibile.**
- PASSO 0 tutto verde: 210 operazioni della cella sonda, prima operazione
  2024.09.30 (limite criteri: entro 2024.12.31), gemelli IDENTICI.
- Nota di trasparenza: la cella r97rif e' stata SALTATA dal driver nella
  corsa delle 21:44 perche' i suoi CSV erano gia' stati prodotti dalla
  corsa interrotta delle 21:11 — stesso pin, stessa cella, stessi criteri:
  numeri validi, provenienza dichiarata.

## I numeri (IS 2024.09.26–2025.06.09 · OOS 2025.06.10–2026.06.30)

| cella | geometria | IS Profit | IS PF | IS DD | n IS | OOS Profit | OOS PF | OOS DD | n OOS |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| **R97-rif** | HALFRANGE, TP range 1,5 (la sedia viva del Dow) | +11.861 | 1,32 | 12,6% | 74 | **−5.553** | **0,91** | **12,4%** | 135 |
| R97a | OPPRANGE, buf 0, TP 2R | +5.284 | 1,27 | 7,1% | 74 | **−3.636** | **0,89** | 9,0% | 135 |
| R97b | OPPRANGE, buf 500, TP 1,5R | +4.987 | 1,28 | 6,2% | 74 | **−4.389** | **0,86** | 8,2% | 135 |
| R97c | OPPRANGE, buf 500, TP 2R | +2.328 | 1,13 | 6,5% | 74 | **−5.109** | **0,84** | 8,4% | 135 |

R97d (TP 1:1, non firmata): NON girata (switch -ConD spento). Irrilevante
visto il quadro sotto.

## I cancelli firmati (par. 5), cella per cella
- **S1 (DD OOS <= 7,00%): 0/4.** Tutte sopra: 9,0 / 8,2 / 8,4 / 12,4.
- **S2 (PF OOS >= 1,40): 0/4.** Tutte NON SOLO sotto 1,40: **tutte sotto
  1,00** — in OOS il motore PERDE, in ogni geometria provata.
- S3 (IS positivo, PF IS >= 1,10): 4/4 — l'IS passa ovunque.
- **S4 (n OOS >= 95, n IS >= 57): 4/4 — il campione C'E'.** n IS 74 e'
  sotto il canarino ~100 (merito IS da leggere con prudenza), ma il
  VERDETTO sta nell'OOS, e li' n=135: pieno titolo a giudicare.

**VERDETTO: 0/4. BOCCIATO.**

## La lettura che conta (ed e' piu' profonda del verdetto)
Le 4 celle hanno **GLI STESSI INGRESSI** (74 trade IS, 135 OOS, identici
per costruzione: cambiano solo stop e TP). Tutte e quattro perdono in OOS.
**Quindi il problema NON e' la geometria dell'uscita: sono gli INGRESSI.**
Lo stop largo di R88 curava un motore i cui ingressi avevano un edge
(Dow) e venivano ammazzati dal rumore; qui non c'e' niente da curare,
perche' nella finestra recente gli ingressi del breakout d'apertura sul
Nasdaq non hanno edge. IS verde + OOS rosso su tutte le celle e' la firma
classica: l'edge c'era nella finestra 2024–inizio 2025 ed e' sparito dopo.

Questo CONFERMA in casa nostra, coi nostri tick, quello che il paper
indipendente (947 giorni di MNQ, arXiv 2605.04004v2) diceva da fuori:
**l'ORB sul Nasdaq muore.** Due fonti indipendenti, stessa conclusione.

## Cosa NON dice questo round (onesta' sui limiti)
- Un solo regime (indici USA 2024–2026): misura la trasferibilita' dentro
  questo regime, non tutta la storia. Ma per aprire una sedia serve
  l'edge ADESSO, e adesso non c'e'.
- Niente parziali (InpTP1Pct=0, come R88): non testate. Ma con ingressi
  che perdono, nessuna gestione le salva.
- R97 non produce sedie (par. 6) — e infatti non ne produce.

## Prossimo passo — REGOLA DELLA SECONDA CACCIA (19/08)
Motore dichiarato senza edge -> si cercano MECCANISMI ALTERNATIVI sulla
stessa inefficienza, MAI parametri diversi del motore morto. Il candidato
e' gia' in casa, trovato dallo sweep del 22/08: **A1 — "Market Intraday
Momentum" (Gao/Han/Li/Zhou)**: il rendimento della prima mezz'ora predice
l'ultima mezz'ora. Meccanismo COMPLETAMENTE diverso dal breakout (niente
ingresso in apertura: si misura l'apertura e si opera la chiusura), con
paper accademico dietro. EA da scrivere (~250 righe). In coda anche il
conflitto R42-vs-paper sul retest, che resta da sciogliere con Claudio.
