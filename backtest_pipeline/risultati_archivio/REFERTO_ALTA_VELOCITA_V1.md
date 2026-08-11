# REFERTO — ABTG_AltaVelocita v1/v1.1 (11/08/2026): BOCCIATO su GBPUSD

**Dall'idea al verdetto in UN giorno, zero euro di forward spesi.** Manuale
ricevuto la mattina, tesi distillata, formula originale del ciclo ottenuta
(3 fonti), EA scritto (1.045 righe, compilato al primo colpo), collaudato,
corretto una volta, bocciato coi criteri congelati. L'imbuto ha fatto il
suo lavoro alla massima velocita' possibile — e il verdetto vale per
QUELLO CHE ABBIAMO TESTATO: la meccanizzazione v1.1, non il trading a
mano di Manuela.

## I numeri (GBPUSD, ciclo H4, ingresso M5, sweep StMult 2,5-4,0)

| Versione | Finestra | Celle | Esito |
|---|---|---|---|
| v1 OHLC | IS + OOS | 8 | 8/8 negative (PF 0,59-0,85) |
| v1 TICK REALI | IS + OOS | 8 | 8/8 negative (PF 0,54-0,82, DD fino 37%) — conferma: perdita media ~0,1R/trade |
| v1.1 OHLC (regola stop del manuale) | IS | 4 | 3 negative + StMult 2,5 a +13,25 (PF 1,002 = zero) |
| v1.1 OHLC | OOS | 4 | **4/4 negative** (PF 0,57-0,76) |

Cancello congelato (una cella >0 in ENTRAMBE le finestre): **nessuna**.
La v1.1 (pavimento/tetto dello stop in ATR operativo — regola esplicita
del manuale che la v1 non implementava) toglie ~30% dei trade e alza un
po' i PF in campione, ma fuori campione non cambia il segno: il problema
non erano (solo) gli stop-rumore.

## Lettura onesta

1. **La macchina funziona** (compila, sequenzia rottura/ritest/ripartenza,
   gestisce): quello che manca e' l'EDGE della traduzione meccanica.
2. **Il cuore non tradotto e' probabilmente IL cuore**: le trendline sulle
   punte dell'RSI ("una punta per ciclo, mai saltarne uno"), la lettura
   dei canali, la discrezionalita' sul contesto. Il manuale stesso lo
   dice: "l'indicatore non decide per te". La v1.1 entra dove le regole
   meccaniche dicono si', e i numeri dicono che non basta.
3. **Niente coda a 8 simboli per ora**: col terreno di casa (forex/cross)
   profondamente rosso su tutte le celle e le finestre, spazzolare altri
   7 simboli e' pesca, non ricerca (lezione fascia A: l'iterazione era
   una, e' stata usata). `CODA_ALTAV.csv` resta nel repo, pronta se un
   giorno una TESI NUOVA la giustifica (es. v2 con vere trendline RSI).
4. **Il valore che resta**: la tesi distillata, la formula del ciclo
   (riusabile come indicatore di studio), l'EA come base per una v2
   SE arrivera' un'idea di traduzione migliore — e il metodo: un
   capitolo aperto e chiuso in giornata senza bruciare un euro.

## Decisione
- ABTG_AltaVelocita NON entra in FASE 0 estesa, NON va in forward.
- Il capitolo si riapre SOLO con una tesi nuova scritta prima dei numeri
  (candidata naturale: implementazione vera delle trendline sulle punte
  RSI per-ciclo, che e' un progetto a se').

_CSV: `risultati_prove/ABTG_AltaVelocita/` (v1 ohlc+tick, v1.1 ohlc con
suffisso _v11)._

---

## AGGIORNAMENTO v2 (11/08 sera) — VERDETTO DEFINITIVO: CHIUSO

La v2 col motore VERO delle punte RSI (una per ciclo, classificazione
divergenza/convergenza/doppio-massimo, A/B pulito col fallback v1.1) e'
stata collaudata sulle due combo dichiarate nella tesi. Controlli
perfetti: baseline gemelle = v1.1 al centesimo; trade -80/-93% col
motore acceso (la selettivita' funziona).

| Combo | Cella | IS | OOS |
|---|---|---|---|
| H4->M5 | v1.1 base | -1.172 (108 tr) | -1.598 (166 tr) |
| H4->M5 | punte div/conv | -303 (22 tr) | -523 (35 tr) |
| H4->M5 | punte SOLO div | -261 (7 tr) | -149 (12 tr) |
| D1->M15 | v1.1 base | -259 (26 tr) | -786 (52 tr) |
| D1->M15 | punte div/conv | -254 (3 tr) | -161 (13 tr) |
| D1->M15 | punte SOLO div | -107 (1 tr) | -85 (3 tr) |

**Il dato che chiude la questione: anche le SOLE divergenze da manuale
perdono.** Il motore seleziona meno ma non seleziona meglio. Nessuna
cella >0 in entrambe le finestre -> niente promozione ai tick -> come
da patto congelato nella tesi: **capitolo CHIUSO, nessuna v3.**

Cio' che resta in cassa: la formula originale del ciclo (indicatore di
studio), la tesi distillata, un EA-laboratorio con A/B integrato, e la
prova piu' pulita finora del metodo: DUE versioni testate e bocciate in
UN giorno, zero euro di forward, zero mesi persi. La strategia resta
quello che il suo stesso manuale dichiara: un metodo dove l'ultimo
strato — quello che guadagna — e' umano.
