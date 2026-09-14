# 📋 RESOCONTO DELLA GIORNATA — 14/09/2026, ore 21:00

> Non è la pagella (quella è un'altra Routine, scorecard trade-per-trade
> alle 23:00). Questo è il punto sul progetto.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Il runner della notte** (`REFERTO_RUNNER_20260914_033004.txt`): 63 righe in
coda, **tutte eseguite, uscita 0**. Le 15 righe nuove armate ieri sera hanno
girato senza intoppi: **R145a/b** (VolExpBreak, primo collaudo di
compilazione — passato), **R125a-f** (ORB, 6 celle), **R127a** (SupRev
NASDAQ), **R146a/b/c + R147a/b/c** (le uscite mai provate). 🔴 **I numeri
(PF/DD/n) sono ancora sul VPS** — la raccolta (`carica_risultati.ps1`,
appena portato nel repo) non è ancora stata rilanciata da quando è stato
corretto. Nessuna seconda corsa notturna oggi: il prossimo giro è stanotte
(03:30), e includerà anche `r148a/bl/bs` (il Cycle, primo collaudo vero).

**Le consegne della giornata**, verificate una per una prima di fidarmi
(elenco, non un referto per ognuna):
- 🔬 **Analisi di 3 documenti del collega Marco** — critica alla nostra
  metodologia: trovata una contraddizione vera fra due nostri documenti
  congelati (il gate "Campione" del dossier chiede IS≥57, ma `CLAUDE.md`
  misurato dice che servono 190-256 per leggere l'altopiano).
- 🌀 **`ABTG_Cycle`** — EA nuovo dall'indicatore di Emiliano, 3 round (uno
  lato/altro lato/entrambi), 2 correzioni reali trovate dal secondo
  giudizio, armati.
- 🕵️ **`controllo-caccia`** — nuovo agente creato oggi, ha già auditato 2
  cacce esterne: fiducia alta su entrambe, con difetti minori trovati (una
  fonte saltata senza dichiararlo, un branding Bitcoin omesso in una
  scheda).
- 🔧 **Runbook di ricompilazione** per il piccolo 50503392: trovata una
  trappola vera (il Guardian in campo, se riattaccato senza F7, darebbe una
  protezione senza i cap firmati il 18/08 — il suo `.ex5` è più vecchio del
  sorgente, unico caso su 70).
- 📼 **Trascrizione live Emiliano** del 14/09 — 7ª della serie, la più
  pulita sul fronte bandiere; confermato con misura nostra che l'ORB a 15
  minuti che insegna è **peggiore** del nostro 35-45 minuti (8/8 vs 0/8 OOS).
- 🎯 **Andrea Unger** — nessun candidato (16 fonti sue bloccate dal proxy di
  rete), ma confermato che il suo sizing a rischio % è quello che già
  usiamo.
- 📊 **Due indicatori MT5 nuovi** (orologio server/italia, conto alla
  rovescia multi-TF) — puro display, zero rischio, entrambi corretti dal
  secondo giudizio prima di arrivare a te.
- 🔢 **Un buco di casa**: la nostra stessa checklist dei difetti ha 4 numeri
  di classe duplicati — documentato, non rinumerato a sensazione.
- 🧭 **In corso da questa mattina, ancora senza risposta**: la mappatura
  delle prossime manopole d'uscita e la Monte Carlo del DD per singola
  cella — nessuna consegna, ore di lavoro. Se non rientrano stanotte lo
  segnalo domani come anomalia, non come normalità.
- 🕐 **In corso ora**: la traduzione della strategia NASDAQ di un corso
  esterno (Bardolla) che hai caricato — verifica in corso se i suoi "5
  punti di stop" sopravvivono al nostro cancello di costo (quasi certo che
  no, lo dirò col numero).

---

## 💶 IL CONTO

**Dry-run 100k (50504263)**: ultimo numero che trovo scritto è **+2,85%**
(`report/RESOCONTO_2026-09-10.md`, dato del 07-10/09) — **NON RIMISURATO
oggi**, quindi potrebbe essere cambiato. Non lo aggiorno a occhio: se ti
serve il numero di oggi, va letto dalla pagella delle 23:00.

**SlippageLogger sul reale (10105439)**: ancora **solo 5 deal totali**,
l'ultimo scritto l'11/09. Campione troppo sottile per concludere niente.

**🔴 La cosa che tocca i soldi veri, oggi**: hai firmato **r137c** — il
cambio `InpTP1_ClosePct` 50→0 sulla sedia viva `770101` (DAX, conto reale).
Ho modificato il file **nel repo** (`mql5/Presets/conto_reale/
ABTG_DAX_Apertura_EU_770101_REALE.set`), verificato due volte (compresa la
scoperta che a ClosePct=0 si disattiva anche il breakeven al primo
obiettivo, non solo la parziale — il trailing resta comunque attivo).
**Non so se l'hai già caricato sul terminale reale** — se non l'hai fatto,
resta un'azione tua: applicalo **solo a sedia piatta**, fuori sessione.

---

## 🔬 COSA HO DECISO IO

- Ho **beccato e corretto due miei errori di pin** prima che uscissero
  (classe 265, due volte) — autocorretti, non dal secondo giudizio.
- Ho corretto un **errore di contesto mio** passato a un agente ("R148a è
  già girato stanotte" — falso, era solo armato) — preso dal secondo
  giudizio prima che si propagasse.
- Ho deciso di **non rinumerare** la checklist duplicata a sensazione:
  costava meno documentare il buco che rischiare un fix indovinato su una
  citazione ambigua.
- Ho lanciato ~15 agenti in autonomia oggi, tutti passati dal doppio
  cancello prima di arrivare a te (nessuno bypassato).

---

## ⚠️ COSA ASPETTA CLAUDIO

- 🔴 **Se non l'hai già fatto**: caricare `r137c` sul terminale reale
  10105439 (solo a sedia piatta, fuori sessione).
- 📥 Rilanciare `carica_risultati.ps1` sul VPS per leggere i risultati della
  notte (incluso, stanotte, il primo esito vero del Cycle).
- 🛡️ Decidere il ramo A/B del Guardian sul piccolo (runbook di
  ricompilazione) — tenere la decisione del 06/09 o riattaccarlo con
  ricompilazione prima.
- 📸 Le 9 domande/screenshot per Emiliano (wrap, zona di protezione, ecc.),
  se vuoi chiudere quei buchi.
- 💬 Niente di nuovo su FTMO/trading manuale: erano domande tue, risposte
  date, nessuna azione in sospeso da parte mia.

---

## 🎯 DOMANI

1. Leggere il referto della notte (63+3 righe, incluso il primo collaudo
   vero del Cycle) appena rientra il rilancio della raccolta CSV.
2. Se le manopole d'uscita e la Monte Carlo DD non sono ancora rientrate,
   capire perché — non è normale che girino da questa mattina.
3. Chiudere la traduzione NASDAQ Bardolla (in corso ora) e riportartela.
4. Proseguire l'imbuto sulle famiglie già in coda.
