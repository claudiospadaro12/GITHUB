# BREAKIN BOX — ABLAZIONE A/B: VINCE IL CONTROLLO — la tesi del TP al box opposto e' FALSIFICATA

_Corsa VERA: 31/08/2026 14:43, pin 131b6f5. ABTG_BreakinBox (EA nuovo, PRIMO
compile OK 69KB), D30EUR M15 tick 2024.09.26->2026.06.30, 2 gambe x 2 gemelli.
Freschezza piena: cache 0/0, ablazione VALIDA (solo TP_RR e Magic diversi),
gemelli IDENTICI su entrambe le gambe, autotest 0, overnight veri 0/770 (il
flat a due tempi funziona al primo colpo su un EA nuovo), PROBLEMI 0.
Zip BREAKIN_CORSA_20260831_1443._

## LA MISURA

| gamba | n | PF | DD | pegg.gio | LONG/SHORT |
|---|---|---|---|---|---|
| A — TP al lato opposto del box (LA TESI) | 416 | 1.007 | 24.1% | -2.05 | 193/223 |
| B — RR fisso 2.0 (CONTROLLO = geometria R95) | 354 | **1.106** | **19.7%** | -2.04 | 158/196 |

Confronto per-trade/risk-adjusted (criterio congelato): **B batte A su PF
(+0.10) E su DD (-4.4 punti)**, peggior giornata pari. Non e' vicino: e' netto.

## IL VERDETTO (dalla lettera congelata nei prova, scritta PRIMA dei numeri)
**"VINCE LA GAMBA B (RR fisso) -> il motore e' R95 CON UN LIVELLO NUOVO e IL
CAPITOLO SI CHIUDE LI'. Niente caccia a 'un RR migliore': vietata dalla
Regola della Seconda Caccia (19/08)."** Si applica alla lettera.
- La tesi del dossier (l'edge sta nella taglia del take al lato opposto) e'
  FALSIFICATA: il TP strutturale rende MENO e rischia PIU' dell'RR fisso.
- E nemmeno la gamba B e' un candidato: DD 19.7% > cancello 15% (congelato),
  PF 1.106 marginale. Inseguirla = la caccia all'RR vietata.
- **CANDIDATO CHIUSO.** Niente round di griglia, niente deploy.

## COSA RESTA IN CASSA (misurato, riusabile)
- **Conversione D30EUR = 100 CONFERMATA** (digits 2, mediane in scala: prima
  misura in assoluto sul DAX — vale per tutti i round DAX futuri).
- Frequenza del breakin sul DAX: ~20 posizioni/mese, due lati vivi (>=150
  per lato) — il FENOMENO esiste, e' il suo sfruttamento che non paga.
- L'EA ABTG_BreakinBox resta nel repo come mattone (box-engine + conferma
  differita + flat a due tempi, tutto autotestato): se una caccia futura
  porta una GESTIONE diversa sulla stessa geometria, il banco e' pronto.
- Terza conferma indipendente della lezione arXiv 2605.04004: sui falsi
  breakout degli indici la geometria corta sotto il soffitto di frizione
  non paga (CRT tick, paper n=6442, breakin A/B).
