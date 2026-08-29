# CACCIA — MOTORI NUOVI NASDAQ, TF BASSO, DRIVE-CONTINUATION (per prop) — 29/08/2026

## IL RISULTATO IN UNA RIGA
**ZERO motori nuovi promossi — e il motivo e' utile: il meccanismo "drive-continuation
Nasdaq" che il mandato cerca E' GIA' COSTRUITO E STAGED IN CASA** = `ABTG_OutOfNoise.mq5`
(P3, il PASSO 0 che stiamo lanciando). Il porting e' FEDELE alla formula Concretum
autorevole (`upper=base*(1+avgMove)` == `firstconstant*(1+vm*sigma)`). Il campo e' arato:
non c'e' un import da aggiungere.

**Cio' che porto NON e' un candidato: e' EVIDENZA ESTERNA che cambia il GIUDIZIO DI
RISCHIO del round P3, da iniettare come cancello PRIMA dei numeri.**

## L'EVIDENZA DECISIVA: `giovannibrusco/zarattini-2023-orb-qqq` (GitHub, MIT, Python)
Replica INDIPENDENTE e cost-aware dell'ORB 5' di Zarattini su QQQ (Nasdaq), 2016-2023,
1.775 trade. NON e' un EA: e' una FALSIFICAZIONE della versione nuda. Numeri letti nel
README/estrazione:
- **COSTO**: edge lordo $0.070/share; break-even a **~2.2 cent/share** di slippage;
  con costi realistici l'edge NETTO crolla a $0.020/share. PnL senza slippage $138.639
  -> con slippage **$4.860**.
- **REGIME**: filtro NQ significativo per-trade (t=2.05) MA **"76% del PnL filtrato e'
  il solo 2022"**, **"perde nel 2017, 2020 e inizio 2023"**, testuale: **"togli il 2022
  ad alta volatilita' e resta poco: gli edge ORB sono un effetto di regime di
  volatilita', non strutturale."**
- Target 10R quasi decorativo (colpito 2-3%), **75% esce sullo stop**, 22% flat a fine gg.

## PERCHE' E' DECISIVO PER NOI
Il feed BCM sugli indici e' **21 mesi, un solo regime RIALZISTA** (no 2022). Il
drive-following a banda vive delle code convesse; se quelle code sono un fenomeno
2022/alta-vol (come dice questa replica indipendente sul Nasdaq stesso), sui nostri 21
mesi di toro **il round misurerebbe l'edge proprio dove il regime che lo genera non c'e'.**
- NON e' un motivo per non lanciare il PASSO 0 (conta operazioni + costo, non giudica merito).
- E' il motivo per cui il **MERITO resta SOSPESO** (valvola R59 / Emendamento B) finche' non
  si apre la cassaforte 2021-2026 (FASE 2) col 2022 dentro.

## DUE AMENDAMENTI DA INIETTARE (criterio, non file nuovi)
1. **Cancello slippage esplicito**: misurare lo spread NASUSD con lo **Spread Logger
   (Code Base 74148, promosso 23/08, MAI usato)** PRIMA di leggere qualunque PF del P3.
   Il break-even ~2.2c/share e' load-bearing; su CFD va RIMISURATO, non assunto.
   (Nel P3 lo spread NASUSD e' oggi dichiarato 1-2 pti indice [INCERTO, NON MISURATO].)
2. **De-2022 obbligatorio in validazione FASE 2**: quando si apre la cassaforte
   2021-2026, leggere l'aspettativa/trade ANCHE senza il 2022 (oltre che senza il 2023).
   Se l'edge sparisce senza il 2022 -> effetto di regime, non motore.

## RISCHIO PROP (misurare, non stimare)
Il drive-follower convesso, sui giorni di trend forte, compra INSIEME alle sedie long
d'apertura (Dow 770202, DAX EU) -> scorrelazione bassa proprio quando conta, e forma che
il DD trailing di alcune prop punisce. **La sovrapposizione delle giornate va MISURATA**,
ed e' un criterio d'uscita.

## SCARTATI (una riga a testa)
- **MQL5 art. 17745 (ORB1/2/3 su USTEC)**: licenza "all rights reserved MetaQuotes" =
  non riusabile su conto prop. Utile solo come spec (conferma il cono su CFD Nasdaq).
- **Concretum Bands (TradingView, ConcretumR, MPL 2.0)**: e' un indicatore (niente
  entry/exit), ma e' la formula AUTOREVOLE per cross-checkare ancoraggio e `vm` del nostro.
- **Opening Drive Continuation (NQ), TradingView joetroyer**: access=2 PROTETTO, niente
  sorgente = non esiste come candidato.
- **paper SSRN 4729284 / 4824172 (Zarattini)**: SSRN bloccato (403); regole via porting,
  nessun numero d'autore usato in un punteggio.

## NON VISTO (dichiarato)
SSRN/arxiv/mql5 diretti bloccati; sorgente byte-esatto del repo Python letto via README;
**spread reale BCM NASUSD M15 tuttora NON MISURATO** (cancello S0 load-bearing); ancoraggio
`base=max/min(open,close_ieri)` e `vm` del nostro vs Concretum da confermare.

## ATTRIBUZIONE
`ABTG_OutOfNoise` deriva da "Out of the Noise Intraday" di Yuri Lopukhov (MIT); la banda e'
"Concretum Bands" di ConcretumR (MPL 2.0); la falsificazione cost/regime e' di giovanni
brusco (MIT); i paper sono di Zarattini/Aziz/Barbon. Nessun numero d'autore ha pesato su un
punteggio.
