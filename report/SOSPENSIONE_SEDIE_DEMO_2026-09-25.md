# 🛑 Sospensione delle sedie su INDICI del piccolo 50503392 (+ il 225JPY del 100k 50504263): istruzioni per Claudio

**Firma di Claudio in chat, 25/09/2026:** risposta *"Sì, tutte le sedie indice"* alla domanda di sospendere tutte le sedie su U30USD, D30EUR, NASUSD e 225JPY dal piccolo `50503392` e SupertrendReversal 225JPY dal 100k `50504263`.
**Perché:** la seconda risposta di FTMO (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md`) dice che il divieto di posizioni opposte fra conti vale **anche sui demo** e **anche su indici correlati** (long DAX contro short Dow o Nasdaq), senza soglia. La sospensione del 24/09 copriva solo REALE e 100k.
**Da dove viene l'elenco:** i grafici del profilo attivo letti stanotte (`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260925_033004.log`). Le impostazioni complete di ogni sedia sono salvate in `CODA_08_preset_dai_chr_20260925_033004.log`: servono per rimetterle identiche, quindi non serve salvare un modello per ogni grafico.

---

## 🖥️ BERSAGLIO
✋ **Azione A MANO dentro MT5, sul VPS**, in **due** terminali:
1. **piccolo `50503392`**, cartella programma **`C:\Program Files\BCM Markets MT5 Terminal`** (SENZA `-V3`), profilo attivo **`ORO`**: **15 grafici**;
2. **100k `50504263`**, cartella programma **`C:\Program Files\BCM Markets MT5 Terminal -V3`**, profilo attivo **`SQUADRA 100K`**: **1 grafico**.

🚫 **NON si toccano:** FTMO `541452707` (`C:\FTMO`), REALE `10105439` (`C:\BCM_Reale`), manuale `50503635` (`C:\MT5_MANUALE`), banco `50504400` (`C:\MT5_Backtest`), Pepperstone e Tickmill.
🚫 **Non si preme il pulsante "Algo Trading"** della barra in alto: spegnerebbe anche Guardian, TradeExporter, SpreadLogger e le sedie forex e oro, che restano accese.
⚠️ Il piccolo e il 100k hanno cartelle dal nome quasi uguale: il 100k finisce con **`-V3`**. Il riconoscimento si fa con la riga qui sotto, non a occhio.

### Primo passo: capire quale finestra è quale (sola lettura)
Finestra PowerShell **sul VPS**. La riga non tocca niente: stampa PID, titolo e cartella di ogni MT5 aperto.
```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```
Il **piccolo** è quello con `Path` = `C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe` (senza `-V3`) e **50503392** nel titolo. Il **100k** ha `Path` che finisce in `BCM Markets MT5 Terminal -V3\terminal64.exe` e **50504263** nel titolo.

---

## 1) piccolo `50503392` (`BCM Markets MT5 Terminal`, profilo `ORO`): 15 grafici da SOSPENDERE
| # | grafico (TF) | EA | magic |
|---|---|---|---|
| 1 | **U30USD H1** | `ABTG_PTE` | 771321 |
| 2 | **U30USD H1** | `ABTG_GapFill` | 772234 |
| 3 | **225JPY H1** | `ABTG_GapFill` | 772235 |
| 4 | **U30USD H1** | `ABTG_PunteLarry` | 772341 |
| 5 | **225JPY M1** | `ABTG_GapContinuation` | (magic non letto dalla sonda) |
| 6 | **U30USD H4** | `ABTG_SuperWave` | 770531 |
| 7 | **D30EUR M5** | `ABTG_DAX_Apertura_EU` | 770101 |
| 8 | **U30USD M5** | `ABTG_Dow_Apertura_US` | 770202 |
| 9 | **D30EUR M15** | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | 770411 |
| 10 | **225JPY H2** | `ABTG_SupertrendReversal` | 770924 |
| 11 | **U30USD H1** | `ABTG_SuperWave_DOW_H1_Ottimizzato` | 770511 |
| 12 | **D30EUR H4** | `ABTG_SupRev_DAX_H4_Ottimizzato` | 970912 |
| 13 | **NASUSD H1** | `ABTG_SupRev_NAS_H1_Ottimizzato` | 970913 |
| 14 | **U30USD M5** | `ABTG_ORB_Ottimizzato` | 770611 |
| 15 | **NASUSD M15** | `ABTG_Nasdaq_Apertura_US` | 770250 |

❌ **Sul piccolo NON si toccano** tutte le altre sedie, forex e oro (BreakingBand, GapFill forex, PunteLarry forex e oro, CostToCost, EasyTrend, PTE GBPUSD, MaxMinNotte XAUUSD, EMA200 oro, SupertrendReversal oro, PostNews), e nemmeno TradeExporter e SpreadLogger.
⚠️ Sul piccolo ci sono **più grafici con lo stesso simbolo** (cinque U30USD H1/H4, due D30EUR, due NASUSD, tre 225JPY). Quale EA sta sul grafico lo dice il **nome in alto a destra del grafico**, non il simbolo.

## 2) 100k `50504263` (`BCM Markets MT5 Terminal -V3`, profilo `SQUADRA 100K`): 1 grafico
| grafico (TF) | EA | magic | cosa fare |
|---|---|---|---|
| **225JPY H2** | `ABTG_SupertrendReversal` | 770901 | **SOSPENDERE** |
| EURUSD | `ABTG_TradeExporter` | — | ❌ NON toccare |
| AUDNZD | `ABTG_Guardian` | 779001 | ❌ NON toccare |

🚫 **Non cambiare profilo sul 100k**: il profilo `Default` contiene ancora le sedie DAX, Dow, MaxMin e ORB sospese ieri (sonda CODA_01 del 25/09, "residui"), e riattivarlo le rimetterebbe in campo.

---

## ✋ Come si fa
0. **Prima di tutto, scheda "Trade" in basso** di quel terminale. Guarda se ci sono **posizioni aperte** o **ordini pendenti** su U30USD, D30EUR, NASUSD o 225JPY.
   - **Ordini pendenti** di queste sedie: dopo aver tolto l'EA **cancellali** (tasto destro sull'ordine → Elimina). Togliere l'EA **non** cancella i pendenti: restano sul server e possono ancora eseguirsi. È un demo, quindi cancellarli non costa niente.
   - **Posizioni aperte** di queste sedie: **non chiuderle di tua iniziativa. Mandami la foto** della scheda Trade: dal verso si capisce se c'è una sovrapposizione opposta con FTMO, e **decidi tu** se chiuderle. Stop e take profit stanno sul server, anche senza EA.
1. Sul grafico della sedia: **tasto destro → Expert Advisors → Rimuovi**.
2. In alto a destra del grafico **l'icona dell'EA sparisce**. Nella scheda **Esperti** compare una riga del tipo *"expert ... removed"*.
3. Il grafico **resta aperto**: si toglie solo l'EA.
4. 🔴 **Finiti TUTTI i grafici di quel terminale: File → Profili → Salva profilo.** Se la voce è "Salva con nome…", scegli lo **stesso nome** (`ORO` sul piccolo, `SQUADRA 100K` sul 100k) e conferma la sovrascrittura. **Senza questo passo, al primo riavvio le sedie tornano da sole.**

⏰ **Prima delle 15:30 italiane**, cioè l'apertura USA: è l'ora in cui Dow e Nasdaq Apertura, ORB e Nasdaq sparano sia sul piccolo sia su FTMO.

## ✅ Controllo, fatto da noi
- Mandami una foto della scheda **Esperti** di ciascun terminale dopo le rimozioni, e la foto della scheda **Trade** se c'erano posizioni aperte.
- **Stanotte alle 03:30** la sonda di sola lettura `CODA_01_sedie_attaccate` rilegge il profilo salvato: domattina ti confermo sedia per sedia che sul piccolo non ci sono più le 15 sedie indice, e sul 100k non c'è più il 225JPY, mentre le sedie forex e oro, il Guardian, il TradeExporter e lo SpreadLogger sono ancora lì.

## ↩️ Come si torna indietro
Se e quando servirà, ogni sedia si riattacca con le impostazioni salvate in `CODA_08_preset_dai_chr_20260925_033004.log`. Le istruzioni si scrivono allora, passando dal cancello.

## 📌 Cosa resta fuori, detto chiaro
- **Tickmill** (XAUUSD Ichimoku, USDJPY breakout) e le sedie **oro/forex** del piccolo restano accese. FTMO non ha sedie su quei simboli. La loro correlazione con gli indici è **[NON MISURATA]**, e FTMO non dà una lista.
- **ORB su EURAUD del reale `10105439`**: forex, fuori da questa sospensione; la decisione è aperta a parte (`report/ORB_EURAUD_SUL_REALE_2026-09-25.md`).
- **PC di backtest `DESKTOP-H4D7CAJ`**: il suo terminale è loggato sullo **stesso** conto `50503392`. Le righe dei round già si fermano se trovano MT5 aperto e chiedono di staccare le sedie, ma **se lì ci fossero sedie attaccate operebbero su questo stesso conto**: va controllato a vista la prossima volta che lo apri.
- Se ci sono **già state** sovrapposizioni opposte dal 21/09: misura in corso (`report/HEDGING_DEMO_E_CORRELATI_2026-09-25.md`).
