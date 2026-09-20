# 📋 RESOCONTO DELLA GIORNATA — domenica 20/09/2026

> Il punto sul **PROGETTO**. La pagella degli EA è un'altra cosa e sta in
> `report/giornata_2026-09-20.md`, scritta dalla Routine delle 23:00.

## 🏆 LA GIORNATA IN UNA RIGA
**Da «challenge comprata stamattina» a «sei sedie operative stasera».** È il primo
giorno del progetto in cui una flotta completa è in campo su un conto che costa soldi veri.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Runner delle 03:30** (`REFERTO_RUNNER_20260920_033003.txt`): **127 righe di coda**,
corsia LETTURA, cancelli G1 e G2 passati su tutte le CODA lette. Nessun rifiuto.

🟢 **E ha portato una notizia che aspettavamo da settimane**: `CODA_10` trova finalmente
il ledger dello **SlippageLogger sul conto REALE**:
```
ABTG_SlippageLogger_10105439_deal.csv   3,48 KB   14 righe   ultima scrittura 17/09 14:55
```
👉 Lo slippage in casa era `[MISURATO n=1]` (`IL_PRIMO_SLIPPAGE_VERO`). **Adesso c'è un
campione vero da leggere.** Non l'ho ancora analizzato: è la prima cosa di domani.
⚠️ Sugli altri sei terminali: `GUARDATO e NIENTE`, nessun file. Il logger gira solo sul reale.

**Caccia automatica**: nessun dossier nuovo oggi (l'ultimo è `ANALISI_TRASCRIZIONI_2026-09-14`).

**55 commit** sul branch `lavoro` nella giornata.

---

## 💶 IL CONTO

| | |
|---|---|
| **Challenge FTMO `541452707`** | 80.000 € · 2-Step · **operativa da stasera** · zero operazioni (mercato chiuso) |
| **Dry-run 100k `50504263`** | **+3.890,91 €** su n=**35**, dal 10/08 al 17/09 → **+3,89%** |
| ↳ verso il target +10% | mancano **6,11 punti** |
| **Reale `10105439`** | non toccato. Fuori perimetro, come sempre |

---

## 🔬 COSA HO DECISO IO, col numero accanto

1. **Schieramento completo su FTMO**: 7 F7, 6 sedie + Guardian + TradeExporter + SpreadLogger.
2. **Rinomina `ABTG_` → `CLAU12_`** sul solo terminale FTMO (richiesta di Claudio). 7/7, impronta invariata.
3. **`InpCorrSymbol` → `US500.cash`** in tutti e cinque i preset che lo portano. Il simbolo è
   comparso nel Market Watch dopo il prevolo: `SPXUSD` su FTMO **non esiste**.
4. **`CODA_02` esteso a `(?:ABTG_|CLAU12_)`**: senza, il monitoraggio notturno avrebbe detto
   *«nessuna riga di EA riconosciuta»* mentre le sedie lavoravano (**classe 487**).
5. **`pubblica_trades.ps1` + `run_weekly_report.py`**: il quarto conto. 🔴 E sotto c'era un
   difetto **già attivo dall'08/09**: `_account_label` mandava `trades_reale.csv` nel gruppo del
   conto piccolo, e **dentro un gruppo vince il file più recente** → il reale **sostituiva** il
   piccolo nel referto, in silenzio (**classe 499**).
6. **Due ondate di agenti** su: DD di portafoglio · `770411` · stop-vs-spread · riverifica
   regolamento · tetto delle 2.000 richieste.

## ✏️ E GLI ERRORI MIEI DELLA GIORNATA, perché il resoconto li dice

- 🔴 **Il numero sbagliato che ha cambiato una decisione**: ho dato a Claudio *«DD realizzato
  0,96% a 0,65%»*. **Non esiste in repo**: era il DD di **backtest** di un candidato **bocciato
  con n=2**. Ed è il numero su cui ha valutato se triplicare il rischio. Corretto e verificato
  (**classe 492**).
- 🔴 **Enum letto dal contesto**: ho dichiarato `770411` con stop fisso a 30 punti (21× la
  frontiera, lotto 53, margine 33,7%). **Tutto falso**: `InpSLMode=1` è ATR, non FIXED
  (**classe 495**).
- 🔴 **Script riscritto da zero** quando ne esisteva già uno migliore in repo (**classe 494**).
- 🔴 **`Magic` inventato** per un EA che non ne ha uno. Lo schieramento ha rifiutato, fail-closed
  (**classe 498**).
- 🟠 **Hype su «nessun limite di tempo»** tacendo i **4 Minimum Trading Days**.

📌 **Dodici classi archiviate oggi: 488 → 502.** Nessuno di questi difetti è arrivato in campo.

---

## ⚠️ COSA ASPETTA CLAUDIO

🔴 **Una sola cosa, e non è urgente stasera** (mercato chiuso, prima operazione lunedì):

**Il tetto FTMO delle 2.000 richieste/giorno.** Verificato alla fonte: conta anche le
**modifiche di stop** (*«opened, **modified**, or closed»*), parola che nel dossier di agosto
non c'era. Cinque sedie su sei stanno a **~65-196 richieste/giorno** (margine 10×).
🔴 **`770411` MaxMin no**: il suo trailing è agganciato al **bid/ask vivo**, `OnTick()` r.158
chiama `ManagePos()` **senza guardia di nuova barra**, e non esiste nessuna manopola che lo
diradi. Stima sulla durata massima misurata: **2.600-26.000 richieste**.

👉 **Gli ho mandato una riga** che conta le richieste vere dal giornale del demo BCM `50503392`
— **stesso codice, stessi simboli, tick veri**. Risponde **stasera** a una domanda che
altrimenti si risponde lunedì sera, a sedie operative.
🟢 Severità onesta: il testo FTMO dice *«might **alert** traders and ask them to adjust»*.
**Non è un cancello automatico come il 5%.**

🟢 **Niente che tocchi il conto reale, le taglie o i soldi. Non serve che faccia altro stasera.**

---

## 🎯 DOMANI

1. 📊 **Leggere il ledger dello slippage sul reale** (14 righe): chiude il `[MISURATO n=1]`
   che oggi ha impedito al collaudatore di proporre un `InpMinStopPts`.
2. 🔢 **Il numero delle richieste** dal demo BCM, e se `770411` sfonda → la riparazione
   (soglia minima di movimento: **non sposta nessuno stop**, cambia solo quante volte lo si
   comunica). ✍️ Firma di Claudio.
3. 📡 **Lunedì**: spread all'apertura dal SpreadLogger, ore server **10** e **16**.
   Chiude la **classe 496** (la frontiera poggia su un solo tick dell'ora più calma).
4. 🔧 **Le tre Aperture**: manca `newSL < bid` / `newSL > ask`, riga che `771531` e `770511`
   hanno già. È una **riparazione**, non un cambio di cella.
5. 🪑 **`770402` ORO**: due file prova pronti (`R193a`/`R193b`), **< 4 minuti** di banco.
