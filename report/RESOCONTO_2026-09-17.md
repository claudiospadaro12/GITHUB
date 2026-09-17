# 📋 RESOCONTO DELLA GIORNATA — 17/09/2026, ore 21:00

> ⚠️ **Non è la pagella.** Lo scorecard degli EA dai trade del giorno lo fa la
> Routine delle 23:00 in un'altra chat (`report/giornata_2026-09-17.md`).
> Questo è il punto sul **progetto**.
>
> 🧭 **Bussola, dichiarata subito e senza sconti**: oggi **nessuna sedia si è
> avvicinata al campo**. La giornata ha prodotto **una riparazione**, **una
> diagnosi grossa**, **uno strumento manuale** e **sette classi di difetto**.
> Utile, ma è **ponteggio**, e va chiamato così. Mancano 13 giorni.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Il runner del 17/09 è arrivato**, in ritardo ma non in avaria: 122 righe,
fine alle **18:11 locali VPS** (stimata ~20:08 CEST, quindi in anticipo).

| esito | n | significato |
|---|---:|---|
| **uscita 0** | 74 | girato, numeri prodotti |
| uscita 3 | 20 | girato **con rilievi** — i numeri ci sono |
| uscita 2 | 22 | in gran parte `@FRAZIONEIS 1.0`: l'OOS non può esistere per costruzione (classe 395) |
| 🔴 **uscita 1** | **6** | **non sono nemmeno partiti** — colpa mia, vedi sotto |

**36 round hanno girato per la PRIMA volta**, e **19 hanno i numeri completi**
(11 a uscita 0 + 8 a uscita 3).

🎯 **E lo SlippageLogger sul reale 10105439 HA I DEAL.** Era la domanda aperta
da giorni, e la risposta è sì, con i numeri (`CODA_10_slippage_20260917_033003.log`):
- **7.903 deal esaminati, 11 registrati**, 70.146 scansioni, `autotest: casi falliti 0`;
- **`D30EUR` INGRESSI: n = 4 · mediana −0,100 · media +0,050 · P95 e max +0,700
  punti indice · costo totale 0,02 EUR.**

👉 **Lo slippage in ingresso sulla sedia che gira sul reale è, di fatto, zero.**
Su 4 ingressi il costo cumulato è **due centesimi di euro**. È una buona
notizia vera, e cambia un'assunzione: nei conti di costo lo slippage su
`D30EUR` non è la voce che decide. ⚠️ Con n = 4 è un **fatto misurato, non una
statistica**: il giudizio di merito resta sospeso, il rischio no.

**La caccia automatica**: nessun dossier nuovo. L'ultimo in
`backtest_pipeline/caccia_strategie/` è del **21/08**. La Routine gira ogni 2
giorni alle 08:00 — 🔴 **[NON MISURATO]** se non ha trovato niente o se non ha
girato. Va guardato, non assunto.

---

## 💶 IL CONTO

- **Dry-run 100k (target +10%)**: 🔴 **non ricalcolato oggi.** Il numero
  cumulato è dominio della pagella delle 23:00 e **non l'ho rifatto per non
  produrre una seconda verità**. Rimando a `report/giornata_2026-09-17.md`.
- 🔴 **Un buco nei dati, citabile**: la pagella del 16/09 segna
  `reale 10105439 → trades_reale.csv → ⚪ CSV ASSENTE`. Il **TradeExporter sul
  reale non consegna**, quindi il P&L del reale non entra in nessuna pagella.
  Non è una decisione di rischio: è un tubo staccato.
- Slippage sul reale: sopra. **Misurato, e trascurabile.**

---

## 🔬 COSA HO DECISO IO, col numero accanto

**1. 🔴 Riparato un errore mio che aveva fermato 7 round.** I sei a uscita 1
sono morti su un **404**: il file prova non era al pin. Causa misurata — il
**giro di pin era corto di una generazione**: file prova e rotazione di `$PIN`
nello stesso commit, e un commit non può pinnare sé stesso. Contro-esempio
dalla stessa notte: i round *riusciti* hanno un commit **dedicato** il cui
padre contiene già la prova. Poi ho controllato **tutta** la coda invece dei
soli sei che avevano gridato, e ne ho trovato un **settimo** (`r177a`) che
sarebbe fallito domani. Riparati tutti: **115 raggiungibili su 115**, prima
erano 108. Costo dell'errore: **34 secondi di macchina, zero numeri sbagliati**.
→ classe **401**.

**2. 🚚 Trovato il tappo vero: il trasporto dei risultati è fermo dal 13/09.**
**47 round hanno i numeri fatti e dal repo non se ne legge uno.** Verificato in
quattro modi (il runner pubblica solo su `coda/referti/`; nessun `.ps1` fa
`git push`; `git log` su `dal_vps/` si ferma al 13/09 con etichette fino a
`r142c`; incrocio 82 etichette a uscita 0/3 contro 35 con CSV). Dentro ci sono
**tre sedie della rosa di ottobre**, `DAX_Apertura_EU` (che gira anche sul
reale) e `EMA200` comprese. Lo strumento esiste già (`carica_risultati.ps1`,
classe 307) e i percorsi **combaciano** — verificato, non supposto. Manca solo
che venga lanciato: **non è installato come attività pianificata**, ed è
l'unico anello della catena rimasto a mano.
→ `report/IL_TRASPORTO_E_FERMO_2026-09-17.md`

**3. 🧮 Ricontato un numero di un agente, e il mio ha tenuto.** Un agente ha
proposto **48** illeggibili al posto dei miei **47**. Ricontato con **due
metodi indipendenti**: 47 e 47. Il suo 48 includeva `r127a`, che ha i CSV in
repo dal 16/09 (`eb281b53`, recuperati dal log). **Referto non corretto.**
L'agente ha poi ritirato la correzione e ha scritto la classe **405**.

**4. 🛠️ Costruito l'indicatore manuale che Claudio ha chiesto**, e non
reinventandolo: è il **porting del suo Pine v1.2** (band riding + 3 EMA) con
il Supertrend come terza origine e la EMA 200. Il Pine **è entrato in repo**
(`pine/ABTG_BandRiding_3EMA_v1.2.pine`): senza la fonte, la fedeltà non era
ri-verificabile da nessuno. Tre giri di cancello, **18 difetti corretti**.
→ classi **402, 403, 406, 407**

**5. 📏 Letti tre assi mai letti, a costo zero di macchina** (fatto stanotte,
va nel conto di oggi): la **Regola dei Due Lati misurata su `770202`** — lo
short costa **+4,3 punti di DD e −0,17 di PF per +56% di frequenza**, fuori
campione. La configurazione viva (solo LONG) è confermata dai numeri.

### 🔴 E GLI ERRORI MIEI DI OGGI, elencati
- il **giro di pin corto** (7 round fermi, punto 1);
- nel commit dell'ATR, **un conto di costo falso di ~2.700 volte** (avevo
  confrontato il ricalcolo pieno nuovo con la coda del vecchio) → classe **407**;
- una **giustificazione troppo sicura di sé** su come `iMA` riempie la testa
  → classe **406**. Nel file ora c'è `[NON MISURATO]`, non la versione
  alternativa: **sostituire un'assunzione con un'altra non è verificare**;
- **l'ATR sbagliato in partenza**: avevo usato `iATR` credendolo Wilder,
  mentre è la **SMA del True Range** — e la misura era **in casa da settembre**
  (`SondaM0PB` T3, citata in 5 file). Non l'ho cercata. Conseguenza: il mio
  interruttore Wilder/SMA **non commutava niente**.

---

## ⚠️ COSA ASPETTA CLAUDIO

Solo cose che toccano il conto reale, il rischio, o i soldi — più le due che
richiedono una mano sul VPS:

1. 🚚 **Lanciare la riga di `carica_risultati.ps1`** su una finestra
   PowerShell del VPS. Passata dal cancello e riverificata da me (pin
   raggiungibile, impronta SHA-256 identica, pin su `origin/lavoro`). Sblocca
   **47 round già pagati**. Nessun MT5 da toccare.
2. ✂️ **La potatura della coda** (72 round già misurati → **~11 h di macchina
   a notte**). Preparata, **non eseguita**: il perimetro del runner è sola
   lettura. Marcia indietro: un `sed`.
3. 🔧 **Togliere `-Rifai`** da `RIGA_ROUND_VPS.ps1` r.649 — tocca lo script del
   runner, quindi firma sua.
4. ⏰ **Installare il trasporto come attività pianificata** dopo il runner,
   così smette di dipendere da noi che ce ne accorgiamo.

🟢 **Niente che tocchi il conto reale 10105439, nessuna taglia, nessun
parametro di rischio, nessuna spesa.** Su quel fronte: **non serve che tu
faccia nulla.**

---

## 🎯 DOMANI

- I **6 round riparati** ripartono stanotte (`r172f-j`, `r173c`), più `r174a`,
  `r175a`, `r176a`, `r177a`, `r178a` armati dopo le 03:30 di oggi.
- ⚠️ **Ma se il trasporto non riparte, stanotte produce altri numeri che
  nessuno legge.** È la cosa da fare per prima, e costa pochi minuti.
- Quarto giro di cancello sull'indicatore, poi la riga per installarlo (**solo**
  sul `50504400` / `C:\MT5_Backtest`: i tre terminali con le sedie vive non si
  toccano).
- Da guardare: perché la caccia automatica non pubblica dossier dal 21/08, e
  perché il `TradeExporter` sul reale non consegna il CSV.
