# Analisi del METODO VOLUMETRICO DAX V5 (LOCKED) — attraverso la lente del progetto

_30/08/2026. Documento originale: `docs/metodi/PROMPT_Volumetrico_apertura_DAX_20260625.docx`
(caricato da Claudio). Questo file NON e' il prompt: e' la nostra LETTURA di cosa
e' automatizzabile e cosa resta discrezionale, per decidere se ne nasce un EA._

## COS'E' (in una riga)
Un framework di **analisi manuale discrezionale** dell'apertura DAX basato su
**Volume Profile + Order Flow + Wyckoff**, che legge **4 immagini** (M5 con VP
attivo, H1 multi-sessione, dashboard MTF+intermarket, M3 timing) e produce un
**bias intraday** (long/short/neutro) fino all'apertura USA, con una **mappa
operativa** a scenari (balance / long / short) ancorata a POC/VAH/VAL.

## LA DIVISIONE CHE CONTA PER NOI: automatizzabile vs discrezionale

### 🟢 AUTOMATIZZABILE e TESTABILE (il cuore che potrebbe diventare un EA)
1. **I livelli di Value Area** — POC, VAH, VAL del profilo della sessione
   precedente/attiva: si CALCOLANO da dati (volume per prezzo). Non serve
   "leggerli dallo screenshot": un EA li ricava.
2. **FASE 5 — posizione dell'apertura vs Value Area** (la regola piu' pulita):
   - Open **sopra VAH** -> bias rialzista
   - Open **dentro VA** -> rotazione (balance)
   - Open **sotto VAL** -> bias ribassista
   E' una regola CONDIZIONALE, secca, testabile.
3. **Gli scenari operativi (FASE 8) come regole SE->ALLORA**:
   - **Balance day**: prezzo dentro VA + equilibrio -> LONG su VAL target POC/VAH,
     SHORT su VAH target POC/VAL (rotazione dei bordi).
   - **Direzionale**: accettazione FUORI dalla Value Area (sopra VAH o sotto VAL)
     con volumi -> continuazione nel verso della rottura.
   Questo e' un motore **Market-Profile / Value-Area** classico, e SI PUO' scrivere.

### 🔴 DISCREZIONALE / NON automatizzabile in modo affidabile
- **Wyckoff** (accumulazione/distribuzione, spring, upthrust, shakeout, bear trap):
  il prompt stesso dice "classificare ASSENTE se non e' chiara" -> e' giudizio
  visivo, non una regola meccanica robusta.
- **Forma del profilo** (P/b/D-shape, double distribution) e **assorbimento**:
  leggibili a occhio, molto fragili da codificare senza overfitting.
- **Intermarket** (SPX500, Nikkei "in fase / fuori fase"): qualitativo.
- Tutta l'impostazione "leggi SOLO dalle immagini, vietato dedurre" e' pensata
  per l'analisi MANUALE, non per un EA.

### ⚠️ IL MURO TECNICO NOSTRO, gia' misurato e load-bearing
- **Il volume su CFD indici a BCM e' TICK-VOLUME, non volume scambiato reale.**
  Il Volume Profile costruito su tick-volume e' un **PROXY**, non il vero VP di
  mercato. Va detto ad ogni riga: un edge "volumetrico" misurato su tick-volume
  e' una FORMA, non il libro ordini. (Stessa avvertenza del resto del progetto.)
- Fuso: il metodo lavora in ora IT/CET; sul feed BCM = server -1h (DAX apre
  09:00 IT = 08:00 server). Ogni orario va convertito (regola di casa).

## COME SI LEGA A CIO' CHE ABBIAMO GIA'
- **DAX ReEntry** (appena costruito, magic 769300): sweep+reclaim del RANGE
  mattutino. Il metodo volumetrico userebbe invece i LIVELLI di VALUE AREA
  (POC/VAH/VAL) -> meccanismo DIVERSO, complementare. Non e' un doppione.
- **MaxMinNotte_DAX** (box notturno): altro riferimento, altra fascia.
- **Aperture DAX EU** (breakout del range d'apertura): il breakout della Value
  Area sarebbe un fratello ma su un livello VOLUMETRICO, non geometrico.
- **Buco che riempirebbe**: un motore DAX **mean-reversion/breakout sui livelli
  di Value Area** all'apertura EU non esiste nella flotta. E' un candidato NUOVO.

## VERDETTO (onesto)
Il metodo, COSI' COM'E', e' un **aiuto all'analisi manuale** di Claudio — utile
per decidere a mano, ma **non e' un EA**: meta' e' giudizio visivo/Wyckoff.
PERO' il suo **scheletro testabile** (livelli Value Area + regola open-vs-VA +
scenari balance/direzionale SE->ALLORA) e' un **candidato EA reale**, con una
tesi economica seria (il valore accettato di ieri governa l'apertura di oggi) e
un buco che riempie. Da trattare come gli altri candidati: criteri congelati
PRIMA dei numeri, verdetto a tick, due lati, pavimento SL, flat EOD, e
l'avvertenza dura sul tick-volume-come-proxy.

## DUE STRADE (Claudio sceglie)
- **A. USARLO ORA (manuale)**: Claudio manda le 4 immagini e io applico il prompt
  V5 alla lettera (check eliminatorio -> fasi 1-8 -> mappa operativa). Serve il
  set completo di screenshot; senza, "ANALISI NON VALIDA" per sua stessa regola.
- **B. AUTOMATIZZARNE IL CUORE**: estraggo la parte testabile in un candidato
  `ABTG_DaxValueArea` (VP proxy su tick-volume, open-vs-VA, rotazione/breakout),
  criteri congelati, imbuto. Wyckoff e forma-profilo restano fuori (manuali).
