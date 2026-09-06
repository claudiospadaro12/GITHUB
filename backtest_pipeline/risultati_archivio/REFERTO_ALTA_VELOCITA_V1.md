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

---

## RIMANDO (06/09/2026) — rilettura integrale della fonte

Il manuale di 38 pagine e' stato **riletto pagina per pagina** e confrontato
riga per riga con questo EA:

👉 **`report/ANALISI_MANUALE_ALTAVELOCITA_2026-09-06.md`**

In sintesi (i contenuti stanno li', non si duplicano qui):
- **Il capitolo NON si riapre**: il PDF non porta un solo parametro che non
  avessimo gia' l'11/08. Nessuna tesi nuova -> patto di chiusura intatto.
- **Fedelta' della traduzione verificata**: 13 voci esatte su 17, 3
  approssimazioni gia' dichiarate nel codice, **1 buco vero** — l'EA non ha
  **nessun filtro di sessione/fascia oraria**, che il manuale prescrive su 3
  pagine. Il verdetto rosso vale per cio' che e' stato testato: **la sessione
  non e' stata provata** (e non si prova: fuso non dichiarato dalla fonte +
  REGOLA DELLA SECONDA CACCIA).
- **Appendice D**: nessun codice, nessuna formula. L'indicatore ufficiale del
  corso **ammette di non avere la formula del ciclo**; noi ce l'abbiamo da 3
  fonti indipendenti -> su quel pezzo siamo piu' fedeli del corso.
- **Bandiere**: 1 rossa (hedging su posizione multiday, p.23 — gia' esclusa
  da questo EA), 1 arancione (rientro ripetuto dopo l'uscita in perdita,
  che contraddice la misura in euro del dossier PS5), 2 sui claim di
  rendimento. **Zero martingala, zero griglia, zero no-SL.**
- **Aperta una richiesta**: i file `AltaVelocita.mq5/.mq4` allegati al corso
  conterrebbero i parametri del Supertrend e dell'ATR, che il manuale non
  dichiara in nessuna delle 38 pagine.
