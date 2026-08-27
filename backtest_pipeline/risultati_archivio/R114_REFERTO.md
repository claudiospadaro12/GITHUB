# 🏁 R114 — REFERTO DEL ROUND: **IL BANCO DI CASA NON PUÒ MISURARE LA LEVA PROP** — e lo ha detto DA SOLO, prima di mentire

_Corsa: 27/08/2026 09:52-09:56 (4,3 min), pin `5550cd7`. Esito driver:
**ROUND FERMO DAL CANARINO (exit 2)** — che NON è un guasto: è il gate
84-bis che ha fatto esattamente il suo mestiere. Zero passate di misura
eseguite, zero numeri falsi in tabella (15 righe n/d oneste). Zip agli
atti: `R114_LEVA_CORSA_20260827_0952.zip`._

## 🔍 LA DIAGNOSI — con la pistola fumante negli artefatti

1. **Il canarino** (deposito 2.000 / leva 15 sugli input ORB) ha eseguito
   **190 uscite senza UN SOLO rifiuto di margine** — il rilevatore non ha
   morso sul controllo positivo → il driver si è fermato invece di
   stampare "zero rifiuti" sulle celle.
2. **La pistola fumante è nella sonda G-SPEC**: gli .ini portavano
   `Leverage=15` (verificato negli artefatti: `gen_R114_sonda_U30USD.ini`
   riga `Leverage=15`), ma il tester ha stampato **`ACCOUNT_LEVERAGE;100`**.
   → **Il tester MT5 di BCM IGNORA la riga Leverage=15 dell'ini** e
   ripiega in silenzio sulla leva del conto (100). Causa più probabile:
   1:15 non è nella lista di leve che il tester di questo broker accetta.
3. **E c'è un secondo strato, più profondo**: i simboli indici BCM
   portano un **margin rate PROPRIO di 0,01** (1% per simbolo,
   TRADE_CALC_MODE=1) — il margine osservato per 1 lotto U30USD è
   **343 USD su un nozionale di ~510.000** (~0,07%). Su questo banco il
   margine è minuscolo PER COSTRUZIONE del simbolo: anche se la leva
   dell'ini fosse onorata, il margine non somiglierebbe mai a quello di
   una prop. **Il banco misura il motore, non il margine prop.**

## ⚖️ VERDETTO: la domanda di R114 NON si risponde su questo banco — ed è una risposta

La lettura pre-dichiarata prevedeva l'esito: _"se il tester non simula la
leva, il round si ferma"_ (criteri § 1 punto 4, G-CAN). È successo. La
LISTA DELLE SEDIE AMMISSIBILI resta **vuota per onestà**: nessun verdetto
per sedia esce da un banco che non vede il margine.

## 🎁 QUELLO CHE IL ROUND CONSEGNA COMUNQUE (misurato)

- **Le specifiche margine complete dei 3 simboli BCM** (G-SPEC): margin
  rate 0,01 indici, **VOLUME_MAX=100 confermato anche su XAUUSD**
  (chiuso il buco della fase 1), volume min/step, **stop-out del banco:
  margin call 100% / stop-out 50%**, contract size confermati (10 per
  gli indici, 100 oz oro).
- **La conferma del metodo**: senza il canarino, questo round avrebbe
  prodotto 15 righe di "zero rifiuti" perfettamente plausibili e FALSE —
  e la lista delle sedie ammissibili sarebbe stata firmata su un banco
  cieco. Il gate 84-bis ha pagato il biglietto di tutta la sua famiglia.

## ➡️ LA STRADA GIUSTA, ADESSO — ed è più semplice del round

**Il margine prop si misura SUI SIMBOLI DELLA PROP**: i demo/trial delle
prop (FTMO offre il Free Trial, FundedNext il trial) hanno i simboli col
margin rate VERO del loro server. E lo strumento esiste già:
**`ABTG_SondaMargine`** — si attacca a un grafico del demo della prop,
stampa le righe GSPEC (margin rate, margine osservato per lotto,
volume max, stop-out) e si rimuove. **Due minuti, zero round, numeri
veri.** Con quelli l'aritmetica della FASE 1 diventa esatta e la lista
delle sedie ammissibili si compila con margini OSSERVATI.

Proposta operativa: quando Claudio apre il Free Trial FTMO (gratuito, si
fa dal sito in 10 minuti), la sonda gira sui loro US30/GER40/NAS100/
XAUUSD e chiude il cancello 6 con la misura vera. Stesso giochino
sull'eventuale demo FundedNext.

## 📌 A REGISTRO

- Checklist **95** (nuova): la riga `Leverage=N` dell'ini del tester può
  essere IGNORATA in silenzio se N non è nella lista del broker — il
  banco ripiega sulla leva del conto e nessun errore compare. Ogni round
  che tocca la leva deve avere un controllo positivo (canarino) e la
  sonda che stampa `ACCOUNT_LEVERAGE` osservato.
- Magic 7636xx + canarino bruciati. G0-A/G0-C/G-SPEC tutti verdi; le 30
  passate di misura non sono mai partite (giusto così).
- Costo del round: **4,3 minuti** per scoprire che lo strumento era
  cieco — invece di una delibera d'acquisto firmata su numeri falsi.
