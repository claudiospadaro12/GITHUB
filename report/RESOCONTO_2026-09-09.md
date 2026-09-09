# 📋 RESOCONTO DELLA GIORNATA — 09/09/2026

> **NON e' la pagella delle 23:00.** Quella gira in un'altra chat e fa lo scorecard
> degli EA dai trade del giorno (`report/giornata_2026-09-09.md`). Questo e' il punto
> sul **PROGETTO**. Il netto del giorno si legge li'.

**Giornata piu' densa del progetto: 46 commit, 8 agenti, 3 round girati sul VPS.**

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

### Il runner notturno (03:30, sola lettura)
**4 righe eseguite su 10** (`CODA_01`-`04`, uscita 0, 3-14 secondi). 🔴 **Le altre 6
RIFIUTATE per 404**: `CODA_05`-`10` puntano a pin di commit che non esistono piu' al
percorso indicato. **Difetto vecchio di ieri, non chiuso oggi** — e va detto, perche'
il runner sta girando a **meno della meta' della sua coda da due notti.**

### 🥇 I ROUND — e per la prima volta i risultati sono arrivati **DA SOLI** sul repo
`pubblica_risultati.ps1`, scritto stamattina, ha fatto il suo primo lavoro vero:
**8 CSV pubblicati alle 20:19 dal VPS senza che Claudio mandasse niente.**
Prima ogni round finiva con *"mandami lo zip"*, e con Claudio al lavoro il lavoro si
fermava per otto ore.

**R120 — studio della gestione delle APERTURE** (48 combo d'uscita, tick reali):
- 🟢 **DAX**: `parziale OFF + trailing PREVBAR` → **PF 1,379 · DD 6,03% · n 325**
  contro la sedia viva (parziale 50%) a **1,309 · 6,88%**. **Meglio su ENTRAMBI gli
  assi.** E non e' un picco: le vicine reggono fra 1,351 e 1,379.
- 🔴 **Nasdaq**: **tutte e 48 le celle sotto PF 1,00** su 483-591 operazioni. Non manca
  la gestione giusta: **il motore non guadagna.** Cambiare l'uscita sposta il DD (da
  48,7% a 7,2%) ma **non il segno**.

**R123 — l'altopiano di `SupRev DOW H1`**: sotto, nelle decisioni.

---

## 💶 IL CONTO

| conto | operazioni | netto | ultima |
|---|---:|---:|---|
| **100k 50504263** (dry-run) | 28 | **+3.025,49 €** | 08/09 12:50 |
| piccolo 50503392 | 1.288 | −19.924,70 € | 08/09 12:50 |

⚠️ **Il file dei trade e' fermo a ieri sera 12:50**: e' pubblicato alle 22:45 lun-ven,
quindi **oggi non c'e' dentro.** I numeri sopra **non includono la giornata di oggi**.

📊 **Dry-run 100k**: +3.025,49 € su 100k = **+3,03%**. Target **+10%** → mancano
**~6,97 punti**. ⚠️ Ma **il deposito iniziale esatto non e' in questo CSV**: il 3,03%
assume 100.000 tondi, ed e' **[DA VERIFICARE]** sull'estratto conto.

🔴 **`SlippageLogger` sul REALE: ancora ZERO deal.** `data/statements/trades_reale.csv`
**non esiste**. Nessun `TradeExporter` sul terminale `C:\BCM_Reale`. Buco aperto dall'08/09.

### 📸 E la foto del piccolo di stamattina (dal report `.xlsx` che Claudio ha mandato)
Equita' **5.276,65 €**, fluttuante **+147,45 €**. **Rischio aperto 0,74%** contro un cap
di 3,25% ✅. **4 posizioni su 6 gia' a rischio ZERO** (due col trailing che ha bloccato
295 punti di utile, due col breakeven scattato).
🔴 **Ma i 4 pendenti sull'oro valgono 3,94%**: se scattano tutti, il conto va a **4,68%**,
**sopra il cap C1**. Il Guardian **non li conta** (`OpenRiskPct()` scorre solo
`PositionsTotal()`, buco **B6** scritto nel nostro stesso codice).

---

## 🔬 COSA HO DECISO IO (in autonomia, col numero accanto)

1. **`ABTG_IBRetest` SCARTATO** — cancello C0. Famiglia 3 simboli, **n=344, PF 0,7798**;
   la finestra OOS da sola ha **n=209 e PF 0,812**. E la frequenza di famiglia e' **0,78
   op/giorno** contro un pavimento di 1,00: due cancelli indipendenti, stesso verdetto.
   🚫 Ho **rifiutato** di tenere solo il DAX (l'unico positivo, PF 1,21 su n=58): sarebbe
   la scelta a posteriori vietata dal 19/08.

2. **`SupRev DOW H1` NON si riaccende** — R123, girato oggi. Il numero e' vero e
   riproducibile (**OOS PF 1,389 su n=152 col binario di oggi**, contro 1,436 dell'08/08),
   **ma vive su un PICCO**:
   - `StMult`: **1 cella su 5**. I vicini a 0,953 e 1,093.
   - `StAtrPeriod`: **1 su 7**. Il vicino a destra **crolla a 0,610**.
   - `NearAtr`: 1,00 → **1,389**, 1,25 e 1,50 → **1,32197 identici** = e' **UNA cella**,
     non due (regola A3, congelata prima: *"due celle clone alla quarta cifra non sono
     due celle"*). ✅ **L'agente l'aveva previsto alla lettera.**
   👉 Soglia congelata prima: **3 celle contigue con PF OOS ≥ 1,20 e n ≥ 150**. Non c'e'
   su nessuno dei tre assi. **Verdetto: NON ANCORA MISURATO, non promuovibile.**
   ✅ **Ma la bocciatura dell'11/08 resta MAL FONDATA**: spenta su un IS con **n=118,
   sotto il pavimento**, mentre l'OOS a campione pieno guadagna.

3. **Corretta una TRAPPOLA in un nostro file prova**, prima di girare il round: diceva
   *"se non riproduce l'archivio → FILE INVALIDO"*. Avrebbe buttato un round buono per un
   cambio di codice **voluto** (il binario e' cambiato 3 volte dall'08/08). Ora la
   sentinella di **continuita' non blocca**, quella di **determinismo si'**.

4. **Chiuse 4 bombe ASCII** nella pipeline, fra cui **un'emoji dentro una stringa** in
   `controllo_flotta.ps1:191` — esattamente la classe che il 17/08 ha fatto esplodere il
   parser. Erano li' da settimane. Sweep su **236 file su 236: zero bloccanti**.

5. **Il cancello preventivo e' stato corretto TRE volte, sempre per falsi positivi miei**
   (i `||` dentro le stringhe, `$INV` non riconosciuta come cultura, non-ASCII nei
   commenti trattato come bloccante). *Un cancello che grida al lupo si impara a ignorare.*

---

## ⚠️ COSA ASPETTA CLAUDIO (solo reale, rischio, o soldi)

1. 🪙 **Il pavimento del lotto MORDE sull'oro, sul conto vivo.** A 0,01 lotti (minimo del
   broker) su 5.276 €: **`LARRY ORO L` rischia 1,75%** — **2,7 volte** il contratto dello
   0,65%. `EMA200 OTT L1` 0,88%, `MAXMIN ORO SELL` 0,78%.
   👉 **Decisione di taglia: sua.** Opzioni: lasciare, ridurre l'oro, o chiudere il buco B6.
2. 🎯 **Le due sedie sul CONTO REALE 10105439 hanno lo short SPENTO.** Sul conto che paga
   siamo **100% long**, con una flotta tarata su 21 mesi di toro. E' una scelta **misurata**
   (R107, R54), non una svista — **ma va riletta con la challenge a ottobre.**
3. 🚚 **`EMA200` Dow**: il dossier di oggi ha trovato che **il cancello del COSTO non passa**
   sulla gamba che porta il 60% del lotto. Prima di schierarla serve una sua parola.

🟢 **Per tutto il resto: niente, non serve che tu faccia nulla.**

---

## 🎯 DOMANI

| # | Cosa | Costo |
|---|---|---|
| 🥇 | **Storico DAX 2010-2018**: mai scaricato, e lo switch esiste gia' | **~5 min** |
| 🥈 | **Sonda indici Pepperstone**: `GER40` risulta "0 barre — da scaricare", **domanda mai fatta** | 5 min |
| 🥉 | **Dove vive `NASUSD_EXT`** (16 anni di Nasdaq gia' importati, ma sul PC fisso, non sul VPS) | 2 min |
| 4 | **Round LATI × REGIME** su forex e metalli: 10 file prova gia' pronti | — |
| 5 | 🔴 **Riparare i 6 pin 404 del runner**: gira a meta' coda da due notti | — |

---

## 🙋 GLI ERRORI DI OGGI, detti

- Ho mandato una riga a Claudio **prima** che il verificatore rispondesse. Lui poi ha
  trovato **3 difetti bloccanti**. E' andata bene **per fortuna, non per metodo**.
- Ho detto che `EMA200` Dow *"passa tutti i cancelli alla lettera"*: **troppo generoso.**
  I numeri con cui l'avevo eletta erano **OHLC**, e a tick il DD peggiora del 20,8%.
- Ho detto che il cancello qualita' sui dati esterni era **CHIUSO**: era vero il 25/08 e
  **superato il 26/08** da una firma di Claudio che non avevo letto.
- Ho detto che il round R120 era long-only **nei file prova**: falso, i file pinnano
  `InpAllowShort=true`. Il long-only sta **nei risultati**.
