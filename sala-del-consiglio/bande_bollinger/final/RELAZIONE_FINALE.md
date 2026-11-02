# Bande di Bollinger 37/3 + S/R sugli indici — relazione (test primario secondo specifica_v1)

**VERDETTO: NESSUN VANTAGGIO RILEVANTE** (solo per H1, Nasdaq100/S&P500 CFD dati `_EXT`, 2015 + 2020 + 2025-26, regole congelate).
Specifica, criteri e previsioni congelati e pubblicati (commit 87958db7) PRIMA di lanciare il codice sui dati.

## Primario (N=173, 2 strumenti × 3 periodi)
| | |
|---|---|
| Win rate | 48,0% (breakeven 55,1%) |
| R medio | −0,129 (IC90 −0,253 / −0,001) |
| R medio vincite / perdite | +0,82 / −1,00 |
| Uscite | TP 81, SL 90, MKT 2, TF 0 |
| Long / Short | 115 trade, R −0,03 (win 54%) / 58 trade, R −0,32 (win 36%) |

Per strumento×periodo (R medio): NAS 2015 −0,32 (N32), NAS 2020 −0,38 (22), NAS 2025-26 −0,11 (42); SPX 2015 +0,49 (18), SPX 2020 −0,33 (20), SPX 2025-26 −0,04 (39).

## Criteri
C1 N≥30 ✔; C2 R>0 con IC90 inferiore>0 ✘; C3 win ≥ breakeven+5pt ✘; C4 leave-one-out tutti >0 ✘ (solo "senza Nasdaq" +0,01); C5 spread ×2 >0 ✘ (−0,15); C6 placebo ✘ (p=0,97: il R medio reale e' PEGGIORE della mediana dei 100 placebo, −0,04).

## Baseline ed esplorativi (descrittivi)
- B1 solo bande, senza S/R: N=878, R −0,04 (IC90 −0,11/+0,04), win 49%. Aggiungere il filtro S/R D1/W/M ha peggiorato, non migliorato.
- M15: N=709, R −0,07 (IC90 −0,14/−0,001). K=1,0: −0,18; K=2,5: −0,04 (win 64% ma vincite 0,51R); TOL 0,25: −0,22; TOL 1,0: −0,08; senza filtro orario: −0,15; spread ×2: −0,15.
- Nessuna variante esplorativa mostra R medio positivo con IC90 inferiore > 0.

## Previsioni vs realta
- N: previsto ≥60 al 25% → 173 (previsione di N troppo bassa, i segnali sono molti di piu).
- Win rate 35–65% ✔ (48%). R medio −0,35/+0,35 ✔ (−0,13). Long meglio di short ✔ (70%). B1 ≥ primario ✔ (55%).
- Verdetto: NESSUN VANTAGGIO 28% (classe uscita, la piu probabile dopo NON DIMOSTRATO 34%); CONFERMATO 6%.

## Limiti (onesti)
- Rules scelte da C0 su una presentazione qualitativa: S/R, tolleranza, stop (la presentazione dice 15 pip per H1 sul forex, tradotti in 1,5 ATR), target e filtro "dati macro" sono operazionalizzazioni. Fasciano opera a discrezione: scelta dei livelli a occhio, "solo condizioni normali", gestione manuale.
- Dati `_EXT` clonati dal BCM: spread 0 (assunto 1,0 bp Nasdaq / 2,2 bp S&P), orario corretto +60 min verificato solo su una settimana di gennaio 2025 (DST non verificato).
- 3 periodi e 2 strumenti molto correlati (Nasdaq e S&P): i 173 trade non sono indipendenti.
- Verdetto "nessun vantaggio rilevante" = con queste regole l'IC90 esclude un vantaggio >+0,10R, non prova che ogni variante discrezionale sia inutile.

## Verifica indipendente
Un agente ha riscritto il test primario dalla sola specifica (`reimpl.py`, `note.md` con 12 ambiguita dichiarate), senza vedere codice o risultati. Confronto trade per trade: 173 su 173 identici per strumento, periodo, istante e prezzo d'ingresso, prezzo d'uscita, motivo e R (differenza massima 0). La codifica del lato differisce solo nel formato del campo.
