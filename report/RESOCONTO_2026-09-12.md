# 📋 RESOCONTO DELLA GIORNATA — sabato 12/09/2026, ore 21:00

_Il punto sul PROGETTO. Il netto del giorno sta nella **pagella delle 23:00**
(`report/giornata_2026-09-12.md`, altra Routine): qui non si rifa'._
**19 giorni alla challenge.**

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

### Il runner del VPS, stanotte alle 03:30 — `ESITO: PARZIALE`
`coda/referti/REFERTO_RUNNER_20260912_033002.txt`: **15 righe di coda, 11 eseguite,
4 RIFIUTATE, 0 fallite.**
🔴 I quattro rifiutati sono i **round**, e il motivo e' scritto: *"G1: manca il
marcatore `RUNNER_SOLA_LETTURA`"* — girava ancora il **runner v2**, che non conosceva
la corsia ROUND. **Zero round misurati stanotte.** Il v3 e' stato installato alle
**08:45** e verificato sull'artefatto (836 righe, sha `21AC6672`, marcatore v3 x2).
👉 Quindi la frase *"i backtest non sono stati fatti"* e' **vera nella conclusione**;
la ragione non era "non sono partiti", era **"sono stati rifiutati"**.

### E la macchina ha portato una cosa che nessuno aveva chiesto: **lo SLIPPAGE VERO**
`CODA_10_slippage` ha trovato **3 file dello SlippageLogger** sul conto **REALE
10105439**: registro con **5 deal**, **3.601 deal esaminati**, autotest **0 casi
falliti**. Calcolato da me dai deal grezzi (segno: positivo = **avverso**):

| quando | cosa | slippage |
|---|---|---|
| 08/09 12:50 | INGRESSO acquisto 0,30 | 🔴 **+0,70** punti indice |
| 08/09 13:35 | uscita in **SL** 0,20 | 🟢 **0,00** — esatto |
| 11/09 10:07 | INGRESSO acquisto 0,40 | 🟢 **-0,30** — riempito **meglio** |
| 11/09 10:45 | uscita in **SL** 0,40 | 🔴 **+1,70** punti indice |

🔴 **`n = 2` sulle uscite in SL: campione sottilissimo, nessun verdetto.** Ma e' il
primo slippage mai misurato in casa, e **nessun backtest lo produce**.
🔴 **E il fatto strutturale che conta**: quei deal sono **magic 770101 su D30EUR**,
cioe' **la sedia che stiamo validando gira GIA' sul conto REALE**, a 0,30-0,40 lotti.

---

## 💶 IL CONTO

**Dry-run 100k (`50504263`)**: **29 posizioni** dal **10/08** al **11/09**, su cinque
sedie — `770101` **12**, `770611` **8**, `770411` **4**, `770202` **3**, `770901` **2**.
🔴 **Il netto e la distanza dal +10% stanno nella pagella delle 23:00**: non li
riporto qui, sia per non duplicare sia perche' **il repository e' pubblico**.
🟢 Struttura sana su `770101`: **12 su 12** portano `RETEST BUY`, un solo simbolo,
**zero** aperture allo stesso istante, **max 1 posizione al giorno**.

**SlippageLogger sul reale**: 🟢 **SI, ha deal** (vedi sopra). Il presupposto
*"non ha ancora prodotto niente"* e' **superato**.

---

## 🔬 COSA HO DECISO IO, col numero

1. **Riparato il lettore della raccolta spread** dopo un fallimento sul campo:
   `ReadAllBytes` su un file che MT5 tiene aperto -> *"used by another process"*.
   **Regressione sulla classe 163, pagata l'08/09**, e la soluzione era gia' scritta
   in due script gemelli nella stessa cartella. Provato **eseguendo**: la versione
   vecchia riproduce lo stesso errore, la nuova legge. Pin `71879b1e`.
2. **Messi in coda 9 round nuovi** (canarino `@FRAZIONEIS`, `cemad02` per l'n dell'IS
   di EMA200, e i sette di `R137`/`R138`/`R139`), con tredici giri di pin e la catena
   verificata via `raw` **40 righe su 40, 0 problemi**.
3. **Salvato lo spread misurato** in `data/spread_vivo/`: **650.484 campioni**, e il
   confronto MQL5-vs-PowerShell a **ZERO differenze su 187 righe**.
4. 🔴 **SPENTO E POI RIACCESO `cemad05`**: l'avevo spenta credendo a **16.374 celle**;
   le celle vere sono **7** (su un ENUM, MT5 ignora il passo). **Falso allarme mio.**
   Il difetto vero era del **cancello**, che gonfiava di **46,5x** su tutto l'archivio:
   riparato (classe **287**).

---

## ⚠️ COSA ASPETTA CLAUDIO — quattro firme, e tutte toccano il RISCHIO

Dal pannello letto stasera sul terminale **50504263**:

| manopola | oggi | perche' riguarda te |
|---|---|---|
| **Spread massimo in punti** | **0 = nessun limite** | la sedia entra a **qualunque** spread. Stasera ho misurato U30USD a **30,0 punti indice** (max ora 13) e il DAX di notte a **+75%** |
| **Floor minimo di STOP** | **0.0** | il cancello *"se lo stop < floor SALTA"* e' `true` ma **inerte**. A spread +100% il **19,7%** delle 193 posizioni sta **sotto il pavimento duro 13,3x** |
| **A1 tetto posizioni+pendenti** | **0 = spento** | e' la protezione che avrebbe impedito le **due SELL gemelle** del 29/07. 🟢 **Il codice esiste GIA'**: zero righe da scrivere, manca una firma |
| **InpTP1_ClosePct** | **50** | a **0** da' PF **1,397 -> 1,491** e DD **7,23% -> 6,27%** a parita' di 193 posizioni |

🟡 E una **conferma**, non una firma: il rischio e' **scceso da 1,0 (registrato il
02/09) a 0,65** — cioe' esattamente la conclusione del collaudo prop di oggi
(*"lo 0,65% e' la condizione di sopravvivenza: a 1,00% il DD combinato fa p99
**12,17%**"*). Confermami che e' voluto.

🔴 **E una cosa che va detta e non e' una richiesta**: `770101` gira **sul conto
REALE**. Ogni decisione su quelle quattro manopole ha effetto **su soldi veri**.

---

## 🎯 DOMANI — la coda e' armata

**40 righe eseguibili** (12 di sola lettura + 27 round + il canarino), **136 celle,
272 passate, ~21 minuti**. Catena verificata riga per riga via `raw`: **0 problemi**.
Cosa risponde:
- 🐤 **il canarino** su `@FRAZIONEIS`: se stampa `IS 2024.09.26 - 2025.08.13` si aprono
  **~20 round**; se stampa `2025.06.09` **si ferma tutto**;
- 📏 **`cemad02`**: l'**n dell'IS in POSIZIONI** di `EMA200` (banda **102-165**, e il
  pavimento **150 cade DENTRO**: la misura discrimina);
- 🚪 **`R136a/b/c/d`**: chiudono il requisito **3** (gestione dell'uscita) di `EMA200`;
- 🪑 **`R137`/`R138`**: indurimento della seconda sedia `770101`;
- 🏆 **`R139a/b`**: il **primo fuori campione della storia** di `EMA200` a H4, due lati.

**In attesa del cancello di giudizio**: cinque file prova `R141` (i quattro EA mai
girati). Se passano, sono **28 passate** in piu' = ~2,2 minuti.

---

## 🔴 DOVE HO SBAGLIATO OGGI — e la causa e' UNA

**Sette volte**, e sempre la stessa: **ho creduto al numero di uno strumento invece di
aprire il file che aveva la risposta.**
1. `M30 = zero` — falso sull'archivio: **168 CSV** con una cella M30 (grepavo `@PERIODO`, il TF vero e' `InpTF`).
2. `cemad05` spenta per un numero del cancello, mentre **il file prova aveva scritto**
   *">>> ATTENZIONE A UN NUMERO CHE MENTE… stampa 'celle=16374'… le celle vere sono SETTE"*.
3. Il caso `770101` **era chiuso il 02/09** con un verbale nel repo, e l'ho riaperto da zero.
4. `LEGACY_2pct` sospettato: **rinominarlo ERA il fix** del 02/09.
5. `HVAncora` dato a Claudio come *"pronto, banda M30"*: l'EA ha un **cancello interno**
   che avrebbe rifiutato il **100%** dei trade (classe **289**).
6. *"La raccolta sblocca 7 righe"*: **ne sblocca UNA** (solo `225JPY` dei sette serviva).
7. 🔴 **La classe 254 riviolata da me** (`| tail` e poi `$?` misura `tail`): mi era
   uscito `EXIT=0` su un file che esce **1**.
8. Il lettore rotto della raccolta: **classe 163, pagata quattro giorni prima**.

🟢 **Cosa e' andato bene**: ogni volta l'errore e' stato trovato **prima** che costasse
una misura, cinque volte su otto da un cancello o da un agente, e tre volte da me
rifacendo il conto. **Zero numeri falsi consegnati.**

---

## 🧭 LA BUSSOLA, detta come va detta
Oggi: **170 commit**, **83 referti**, **39 file prova**, classi in checklist da 245 a
**289**. 🟢 E **i primi numeri di mercato veri**: lo spread su 650.484 campioni e lo
slippage vero su 5 deal.
🔴 **Ma zero motori promossi e zero round girati.** La giornata e' stata **ponteggio +
misura**, non una sedia in piu'. Le due sedie candidate (`771531` EMA200 Dow L+S e
`770101` DAX M5 long) sono le stesse di stamattina — **meglio misurate, non piu'
numerose**. Il primo numero di mercato dai round arriva col referto delle **03:30**.
