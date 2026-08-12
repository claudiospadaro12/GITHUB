# CAMPAGNA ARSENALE — più EA a DD basso per il Guardiano (10/08/2026)

L'obiettivo dichiarato: **10 candidati validati** per poter ragionare sulla
doppia prop. Oggi le sedie occupate sono 5 (+1 in macchina). Questo file è
il piano della campagna + le decisioni aperte che spettano a Claudio.

## Lo stato delle sedie (aggiornato 11/08 sera)

| # | Candidato | Stato |
|---|---|---|
| 1 | DAX Apertura EU | ✅ in dry-run 100k |
| 2 | Dow Apertura ricetta | ✅ in dry-run 100k |
| 3 | MaxMinNotte DAX Short | ✅ in dry-run 100k |
| 4 | Nikkei STREV H2 | ✅ in dry-run 100k |
| 5 | ORB-EMA200 | ✅ in dry-run 100k (mezzo peso) |
| 6 | **Oro notturno (R17)** | 🌱 VIVAIO dal 10/08 (770402) |
| 7 | **PTE Dow H1** (fascia B→R23) | 🌱 VIVAIO dall'11/08 (771321) |
| 8 | **PTE GBPUSD H1** | 🌱 VIVAIO dall'11/08 (771322) |
| 9 | **PTE USDJPY H1** | 🌱 VIVAIO dall'11/08 (771323) |
| 10 | **SuperWave Dow H2** | 🌱 VIVAIO dall'11/08 (770531) |
| +1 | **SuperWave GBPUSD H2** | 🌱 VIVAIO dall'11/08 (770532) |
| 12 | **EMA200 Dow H1** (scan→R29 primo 30/30→R31) | 🌱 VIVAIO dal 12/08 (771531) |

**Le 10 sedie sono NOMINATE** (5 titolari + 6 in vivaio): l'obiettivo
della campagna e' passato da "trovare candidati" a "maturare il vivaio"
(10 trade/mercato = collaudo, 30/famiglia = verdetto). D2 (perimetro
forex): risposta ARRIVATA dai fatti — 3 sedie su 6 del vivaio sono forex.
Nota dell'11/08: Alta Velocita' testata (2 versioni, 1 giorno) e CHIUSA
con referto — il tritacarne funziona anche in bocciatura.

## La coda, in ordine di vicinanza alla sedia

**Fascia A — tick reali mancanti (candidati quasi pronti, ore di macchina):**
- ~~SupRev IBEX (E35EUR) H1~~ — ❌ BOCCIATO R18 (10/08): OOS 12/12 negativo, 14° ribaltamento. `REFERTO_ROUND18_IBEX.md`
- ~~GoldenCross H1 su Oro/USDJPY/GBPUSD~~ — ❌ CAPITOLO CHIUSO R20 (10/08): forex 0/6 (USDJPY IS rosso 3/3, GBPUSD 15° ribaltamento). `REFERTO_ROUND20_GOLDENCROSS_FOREX.md`
- ~~SupRev non-indici H4~~ — ❌ R21 (10/08): nessuna promozione (XAUUSD storico corto, CHFJPY/AUDUSD 0/12, GBPJPY riga di bordo NON promossa). R22 oltre-bordo: **3/9, capitolo CHIUSO** (crinale isolato, non altopiano). `REFERTO_ROUND22_GBPJPY_BORDO.md`. **FASCIA A SVUOTATA: 0 sedie da 4 round — lo screening OHLC promuove ipotesi, non candidati.** Prossimo: fascia B nel weekend.

**Fascia B — scan larghi OHLC dei motori mai visti (notti di coda weekend):**
- ✅ **CODA PRONTA (10/08 sera)**: 48 lavori in `prove/CODA.csv` — 6 motori × 8
  simboli ciascuno (SuperWave H4 · SupertrendInvert H1 · PTE H1 · WOL D1 ·
  Nightly M15 · FiboH4_Multi H4, con prova nuova e InpSymbols pinnato vuoto).
  Si lancia con `coda_weekend.ps1` (doppio click o Task Scheduler venerdì
  23:30); risultati auto-pubblicati sul repo; analisi automatica alle sveglie
  del weekend. Chi passa lo screening entra in fascia A.

**Fascia C — laboratorio (idee dal backlog ORB, una per volta):**
- fade del range (primo della lista) · OR/ATR adattivo · ORL short ·
  range 60' · sessione Londra

## Le 4 decisioni aperte (spettano a Claudio)

**D1 — Ordine della campagna.** Prima la fascia A (candidati quasi pronti,
poche ore di tick reali l'uno) o gli scan larghi di fascia B?
*Raccomandazione: fascia A in settimana (una sera = un verdetto), fascia B
in coda weekend. Il laboratorio C solo quando A è vuota.*

**D2 — Perimetro simboli.** Il portafoglio attuale è indici-centrico
(4 indici + oro in arrivo). Aprire davvero a forex/metalli incrociati
(fascia A li tocca già: USDJPY, GBPUSD, CHFJPY, AUDUSD)?
*Raccomandazione: sì — un EA forex vero sarebbe la scorrelazione più
preziosa che possiamo comprare. Ma solo attraverso l'imbuto, come tutti.*

**D3 — La seconda prop (idea di Claudio, 09/08 notte).** Confermata la
strategia: stesso portafoglio completo su DUE DITTE DIVERSE (mai 5+5).
Da decidere QUALE seconda ditta studiare. Checklist per leggere un
regolamento prop (da poltrona/telefono):
1. EA permessi senza restrizioni? (alcune vietano "copy trading" fra
   conti propri — noi avremmo stessi trade su due ditte: verificare)
2. Limiti: daily loss e max DD — statici o trailing? (il Guardiano va
   tarato sul peggiore dei due)
3. News trading permesso? (i nostri EA non filtrano le news per scelta)
4. Trading notturno/weekend permesso? (MaxMin e oro lavorano di notte)
5. Regole di coerenza ("consistency rules"): max % di profitto da un
   singolo giorno? (il DAX da solo può fare giornate grosse)
6. Costo challenge, refund, split profitti, frequenza payout
7. Broker/feed: spread e slippage sugli indici CFD (i nostri edge
   vivono lì)
*Nessuna spesa ora: regola del 30/07 invariata — prima 30 trade forward.*

**Estensione 12/08 (domanda di Claudio: "2-3 prop con gli stessi EA?")**:
SI', la replica e' il moltiplicatore del progetto — con 4 regole:
(1) ditte DIVERSE, mai conti multipli sulla stessa (le ditte aggregano;
diversificazione del rischio-ditta); (2) il rischio di replica e'
CORRELATO al 100%: la giornata cattiva arriva uguale su tutti i conti
nello stesso momento — si accetta sapendolo; (3) checklist regolamenti
sopra, per OGNI ditta nuova; (4) SEQUENZA AUTOFINANZIATA: prop 1 al
primo payout -> il payout paga la challenge 2 -> ecc. Mai 2-3 challenge
comprate insieme prima che il forward abbia parlato.

**D4 — Il conto piccolo dopo la pulizia.** Quando i morti saranno spenti,
che ruolo ha il 50503392? *Raccomandazione: diventa il VIVAIO — ogni
candidato nuovo che passa l'imbuto fa lì i suoi 30 trade forward a 1%,
prima di guadagnarsi il 100k. Trafila fissa: imbuto → vivaio → 100k.*

## Il ritmo proposto

- **In settimana**: una sera = un lancio di fascia A + referto.
- **Weekend**: coda automatica sui motori di fascia B.
- **Ogni candidato promosso**: giro per-trade (stile R16) → aggiornamento
  del referto di portafoglio → eventuale ingresso nel vivaio.
- **Pagella doppia ogni sera**: il 100k è il banco di prova che decide.

**D5 — Taglia vera per i quasi-validati (proposta di Claudio, 12/08).**
Idea: un secondo demo 100k per gli EA "a un test dal traguardo". Merito
tecnico reale (la taglia cambia i parziali: R23, 88 vs 61 chiusure), ma
RINVIATA al primo collaudo del vivaio (10 trade/mercato): li' si decide
tra (a) ingresso a mezzo peso sul 100k esistente (precedente ORB 0,3%)
e (b) secondo conto — che comunque avra' il suo momento naturale come
prova generale della SECONDA PROP (D3, stesso portafoglio su due ditte).
Fino ad allora: il vivaio sul piccolo E' il banco dei quasi-validati.
