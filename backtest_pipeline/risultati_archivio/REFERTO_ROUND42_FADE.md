# REFERTO ROUND 42 — FADE del falso breakout: BOCCIATO 48/48 (13/08/2026 sera)

**Domanda:** il fade degli estremi del range di apertura (ramo `RANGE_FADE`
degli EA Apertura, mai misurato; Build Alpha setup 2, backlog ORB n.1)
ha un edge su NASUSD (dove il breakout puro perde da 100+ celle) e su
D30EUR (il "mercato whipsaw" del commento nel codice)?

**Risposta: NO, con la nettezza piu' totale mai vista in un round.**

## I numeri (griglia 12 celle x 2 finestre x 2 simboli, tick reali M5)

| | IS (24 celle) | OOS (24 celle) |
|---|---|---|
| **Celle positive** | **0/24** | **0/24** |
| NASUSD — migliore | −508 (15' off400 atr1,5, PF 0,91) | −936 (35' off200 atr1,5, PF 0,86) |
| NASUSD — peggiore | −2.415 (PF 0,62) | −2.883 (PF 0,65) |
| D30EUR — migliore | −911 (35' off0 atr1,5, PF 0,83) | −707 (35' off400 atr1,0, PF 0,93) |
| D30EUR — peggiore | −3.180 (PF 0,50) | −3.383 (PF 0,61) |

Campioni enormi (195-214 trade IS, 300-333 OOS per cella): il verdetto
non e' fragile, e' scolpito. PF fra 0,50 e 0,93 SEMPRE sotto 1. Niente
pattern di regime (IS e OOS rossi insieme): non c'e' nemmeno la panchina.

## Le ipotesi scritte prima, ad una ad una

1. *"Il fade e' positivo dove il breakout era rosso"* — **FALSIFICATA.**
   Sul Nasdaq perdono ENTRAMBI i lati del bancone: la rottura E il fade.
2. *"L'offset aiuta"* — vero solo come "meno peggio" (le celle 35'/offset
   sono le meno rosse su entrambi i mercati), irrilevante ai fini pratici.
3. *"Whipsaw DAX"* (il commento nel codice) — **FALSIFICATO**: il DAX
   fade e' il peggiore del lotto (fino a −3.383 OOS).

## La domanda onesta dichiarata in prova: e' morto il MOTORE o la GESTIONE?

Il MOTORE. Una gestione diversa puo' spostare un PF da 0,95 a 1,05 —
non risollevare un campo intero fra 0,50 e 0,93 su 48 celle, due
mercati e due finestre temporali indipendenti. E la lettura d'insieme
e' coerente e preziosa: **agli estremi del range di apertura non c'e'
edge IN NESSUNA DELLE DUE DIREZIONI** (breakout puro: bocciato R7/02.08/
R25; fade: bocciato oggi). L'unica cosa che ha sempre pagato e' il
RETEST — entrare sul RITORNO al livello DOPO la rottura confermata —
esattamente cio' che Build Alpha chiama il setup a piu' alta
probabilita' e cio' che i titolari DAX/Dow fanno in live da mesi.

## Decisioni

- **Backlog ORB n.1 CHIUSO** ❌ (non riaprire senza fatti nuovi).
- Nessun EA nuovo, nessun grafico, nessun magic consumato: il round e'
  costato una sera di tester e ha comprato una risposta definitiva.
- Fascia C, prossimi della lista quando Claudio vorra': rimbalzo su ORL
  (mean-reversion DENTRO il range, motore diverso dal fade SUGLI
  estremi), target 2x/3x, ORB Londra.

_Dati: `risultati_prove/aperture_r42/` (4 CSV). Prove con ipotesi e
criteri congelati: `prove/R42a_fade_NASUSD.txt`, `prove/R42b_fade_DAX.txt`._
