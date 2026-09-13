# 📋 RESOCONTO DELLA GIORNATA — 13/09/2026

> Nota: per il netto dei trade del giorno vale la pagella delle 23:00
> (`report/giornata_2026-09-13.md`, script `analizza_trades.py`). Questo è il
> punto sul progetto, non un secondo scorecard.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Stanotte (03:30, `REFERTO_RUNNER_20260913_033003.txt`)**: 48 righe in coda, **42
eseguite** (36 in corsia ROUND), **0 rifiutate**, **6 "fallite"**. Riletto oggi alla
fonte, non a memoria: **5 di quelle 6 non erano fallimenti** — sono uscite col
codice 3 perché lanciate a `-Modello 1` (screening OHLC, per costruzione, non un
verdetto), non perché un terminale fosse sparito. **1 sola** (`cemad02`) è
davvero `NON MISURATO`. Risultato pratico: **34 round su 36 hanno prodotto CSV
validi**, oggi ancora sul VPS in attesa di caricamento (vedi sotto).

**Oggi, in autonomia (mandato "modalità autonoma" già dato)**: ho tenuto la
macchina accesa sui turni programmati, verificando ogni consegna alla fonte
prima di scriverla da qualche parte. Il lavoro concreto:
- **`ABTG_VolExpBreak`** (magic 775301): EA nuovo, mai compilato (niente
  MetaEditor qui), primo asse `R145a`/`R145b` (NASUSD/U30USD M30, `InpKStop`).
- **Sbloccato il "tappo" dell'ORB**: `R125a-f`, firmate da te il 10/09 e ferme
  da tre giorni per puro difetto organizzativo (mai messe in coda). Tutte e sei
  armate.
- **Chiuse le tre uscite prioritarie del censimento dell'11/09** (`R127a/b/c`):
  `R127b`/`R127c` erano già girate stanotte; `R127a` mancava, corretta due
  volte prima di entrare in coda.
- **Preparata la seconda fascia di uscite mai provate** (`R146a/b/c`,
  `InpSLBufferATR` su CostToCost EURJPY/GBPCAD, `InpFridayClose` su EMA200
  Dow).
- **Aggiornato il piano madre** (`PIANO_PROP.md` v22, nuova AREA K).

**Il doppio cancello ha trovato 4 difetti reali, tutti corretti prima di
consegnare**, mai dopo:
1. **Classe 273**: `R127a` ordinava `-Modello 1` chiamandolo "tick reali" —
   invertito. Corretto, verificato con l'ancora che riproduce solo a tick.
2. **Classe 308** (×2, `R145a` e di nuovo `R127a`): un parametro sullo stop
   allarga anche il tempo in mercato, e con una posizione alla volta le celle
   dell'asse smettono di campionare lo stesso insieme di segnali. Dichiarato
   nei file invece di nascosto — su `R127a` **senza** poter alzare il deposito
   (l'ancora è congelata a 10.000).
3. **Classe 310**: `InpTP1Pct=0` e `=100` erano la stessa cella per
   costruzione nell'ORB, ma i criteri firmati il 10/09 le trattavano come due
   bordi distinti — un doppione che sarebbe contato due volte nell'altopiano.
4. **Un mio errore**: ho pinnato `R146a/b/c` al commit sbagliato (quello che
   crea i file, non quello che aggiorna il puntatore). Trovato dal secondo
   giudizio, corretto prima che toccasse il VPS.

**Un'autocorrezione che vale la pena raccontare**: stamattina avevo scritto
(e loggato come classe 309) che il codice d'uscita 3 del runner significasse
*"esclusivamente"* un terminale sparito — con l'ombra di un rischio sul conto
reale. Nel pomeriggio l'`architetto-prop`, rileggendo lo stesso codice, ha
trovato che quella condizione ha **tre** cause possibili, e che i 5 casi di
stanotte coincidono **esattamente** con i round a `-Modello 1`: **allarme
ridimensionato da una misura**, non da un'opinione. Corretto in chat e nei
file (`RILIEVO_TERMINALI_NOTTE_2026-09-13.md`, errata in testa).

**La caccia esterna**: nessun dossier nuovo pubblicato oggi dalla routine
programmata (le ultime fonti scaricate — 6 sorgenti — sono di stamattina,
usate per `VolExpBreak`; nessuna nuova arrivata nel pomeriggio/sera).

---

## 💶 IL CONTO

**Dry-run 100k (50504263), FTMO, dal 10/08**: **102.854,99 €** (+2,85%).
Target fase 1 +10% = 110.000 → **mancano 7.145,01 € = 7,15 punti**. **Nessuna
chiusura nuova oggi** — l'ultimo trade nel registro è dell'11/09.

**SlippageLogger sul conto REALE (10105439)**: ancora **5 deal in tutto**
dall'avvio (04/09), ultima scrittura **11/09**. **Zero deal nuovi oggi**: il
conto reale non ha operato nella giornata.

---

## 🔬 COSA HO DECISO IO

Nessuna decisione su rischio, taglie o soldi (fuori dal mio mandato). Le
decisioni operative, tutte con il numero che le giustifica:
- **Priorità della giornata**: sbloccare backlog già pronto/firmato (R125,
  R127) prima di cercare materiale nuovo — criterio della bussola, "quanto
  avvicina una sedia" batte "quanto materiale nuovo produciamo".
- **Su `R127a`, non ho cambiato il deposito** per far sparire il bias di
  occupazione del posto: l'ho dichiarato nel file, perché l'ancora congelata
  di quella cella è calcolata proprio a 10.000 — cambiarla avrebbe rotto la
  riproducibilità (un criterio che è tuo, non mio, da rimuovere).
- **Corretta la mia stessa affermazione di stamattina** (classe 309) appena
  la misura l'ha smentita, invece di lasciarla in giro.

---

## ⚠️ COSA ASPETTA CLAUDIO

Solo le cose che toccano il conto reale, i parametri di rischio, o i tuoi
gesti sul VPS/MT5 — niente di urgente stanotte, ma tre letture da 30 secondi
valgono più di quanto costano:

1. **`carica_risultati.ps1`** dal VPS: **34 round già girati** aspettano solo
   di essere letti (il più pesante, 78 minuti di macchina, sarebbe da buttare
   se restasse chiuso in uno zip).
2. **Il Guardian è davvero attaccato a un grafico sul piccolo 50503392?** Il
   giornale non ne parla da due giorni — costa un'occhiata, non un
   ricompilazione.
3. (bassa priorità, il rilievo si è sgonfiato da solo) se vuoi tranquillità
   totale sui 5 round di stanotte a codice 3: aprire i 5 zip e leggere `N` in
   `ROUND GIRATO CON RILIEVI (N)` — `N=1` chiude, `N=2` fa scattare un
   controllo sul reale.

Nessuna richiesta di soldi, nessun parametro da firmare oggi.

---

## 🎯 DOMANI

- **Stanotte gira**: `R145a/b`, `R125a-f`, `R127a`, `R146a/b/c` — **12 file
  prova, 4 EA, doppio cancello passato su ognuno**. Risultati leggibili
  domattina (una volta caricati i CSV).
- Se arrivano i 34+ round di ieri notte, si legge un bel pezzo di backlog in
  un colpo solo.
- Continuo a preparare la terza fascia di manopole d'uscita mai provate, se
  il tempo lo permette.
- `K3` (riallineare il campo, Guardian per primo) resta la priorità più alta
  del piano — è tua, quando hai tempo per il VPS.
