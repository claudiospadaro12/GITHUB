# 🛑 Sospensione delle sedie BCM su DAX / Dow / Nasdaq (reale + 100k) — istruzioni per Claudio

**Firma di Claudio in chat, 24/09/2026 sera:** *"SI . VA BENE. SOSPENDIAMOLE"* (opzione A′ di `report/HEDGING_FRA_CONTI_2026-09-24.md`).
**Perché:** FTMO ha scritto che le posizioni opposte fra conti diversi sono vietate (`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md`). La sospensione vale finché FTMO non risponde alla mail inviata il 24/09 sera (`report/MAIL_FTMO_HEDGING_2026-09-24.md`).
**Quali sedie:** l'elenco viene dai grafici letti stanotte (`backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260924_033003.log`).

---

## 🖥️ BERSAGLIO
✋ **Azione A MANO dentro MT5, sul VPS**, in **due** terminali:
1. 🔴 **REALE `10105439`**, cartella programma **`C:\BCM_Reale`**;
2. **100k `50504263`**, cartella programma **`C:\Program Files\BCM Markets MT5 Terminal -V3`**.

🚫 **NON si toccano:** FTMO `541452707` (`C:\FTMO`), piccolo `50503392` (`BCM Markets MT5 Terminal`), manuale `50503635` (`C:\MT5_MANUALE`), banco `50504400` (`C:\MT5_Backtest`), Pepperstone e Tickmill.
🚫 **Non si preme il pulsante "Algo Trading"** della barra in alto: spegnerebbe anche il Guardian, lo SlippageLogger e le altre sedie.

### Primo passo: capire quale finestra è quale (sola lettura)
Finestra PowerShell **sul VPS**. La riga non tocca niente: stampa PID, titolo e cartella di ogni MT5 aperto.
```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```
Il **REALE** è quello con `Path` = `C:\BCM_Reale\terminal64.exe`. Il **100k** è quello con `Path` che finisce in `BCM Markets MT5 Terminal -V3\terminal64.exe`. Nel titolo della finestra c'è anche il numero di conto: deve dire **10105439** o **50504263**.

---

## 1) 🔴 REALE `10105439` (`C:\BCM_Reale`): DUE grafici
| grafico (TF) | EA | magic | cosa fare |
|---|---|---|---|
| **D30EUR M5** | `ABTG_DAX_Apertura_EU` | 770101 | **SOSPENDERE** |
| **U30USD M5** | `ABTG_ORB_Ottimizzato` | 770611 | **SOSPENDERE** |
| EURJPY | `ABTG_SlippageLogger` | — | ❌ **NON toccare** |
| EURGBP | `ABTG_Guardian` | 779002 | ❌ **NON toccare** |

## 2) 100k `50504263` (`...MT5 Terminal -V3`, profilo "SQUADRA 100K"): QUATTRO grafici
| grafico (TF) | EA | magic | cosa fare |
|---|---|---|---|
| **D30EUR M5** | `ABTG_DAX_Apertura_EU` | 770101 | **SOSPENDERE** |
| **U30USD M5** | `ABTG_Dow_Apertura_US` | 770202 | **SOSPENDERE** |
| **D30EUR M15** | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | 770411 | **SOSPENDERE** |
| **U30USD M5** | `ABTG_ORB_Ottimizzato` | 770611 | **SOSPENDERE** |
| 225JPY | `ABTG_SupertrendReversal` | 770901 | ❌ NON toccare (Nikkei: FTMO non ha sedie lì) |
| EURUSD | `ABTG_TradeExporter` | — | ❌ NON toccare |
| AUDNZD | `ABTG_Guardian` | 779001 | ❌ NON toccare |

⚠️ Sul 100k ci sono DUE grafici D30EUR e DUE grafici U30USD: quale EA sta sul grafico lo dice il **nome in alto a destra del grafico**, non il simbolo. Il modello va chiamato col magic di QUELL'EA.
🚫 **Non cambiare profilo sul 100k**: il profilo `Default` di quel terminale contiene ancora le stesse quattro sedie (sonda CODA_01, 24/09), e riattivarlo le rimetterebbe in campo.

---

## ✋ Come si fa, grafico per grafico
0. **Prima di tutto, scheda "Trade" in basso:** controlla se c'è una **posizione aperta** o un **ordine pendente** di queste sedie. Si riconoscono dal commento: "DAX Apertura", "Dow", "MaxMin", "ORB".
   - Se **c'è**, **fermati e mandami la foto**. Non chiudere niente a mano: stop e take profit stanno sul server.
   - Se **non c'è niente**, vai avanti. Alle 22-23 italiane queste sedie di solito sono ferme.
1. Sul grafico della sedia: **tasto destro → Modelli → Salva modello**, e chiamalo per esempio `SOSP_770101_REALE`. Serve a **rimettere la sedia identica** quando FTMO risponde, con gli stessi parametri e un clic.
2. Sempre sul grafico: **tasto destro → Expert Advisors → Rimuovi**.
3. In alto a destra del grafico **l'icona dell'EA sparisce**. Nella scheda **Esperti** compare una riga del tipo *"expert ... removed"*.
4. Il grafico **resta aperto**: si toglie solo l'EA.
5. 🔴 **Finiti TUTTI i grafici di quel terminale: File → Profili → Salva profilo.** Se la voce si chiama "Salva con nome…", scegli lo **stesso nome** (`Default` sul REALE, `SQUADRA 100K` sul 100k) e conferma la sovrascrittura. **Senza questo passo, al primo riavvio del terminale o del VPS le sedie tornano da sole**, perché MT5 ricarica i grafici dall'ultimo profilo salvato.

## ✅ Controllo, fatto da noi
- Mandami una foto della scheda **Esperti** di ciascun terminale dopo le rimozioni.
- **Stanotte alle 03:30** la sonda di sola lettura `CODA_01_sedie_attaccate` rilegge i grafici **salvati nel profilo**: per questo serve il punto 5, perché senza salvataggio la sonda vedrebbe ancora le sedie. Domattina ti confermo, numero per numero, che su REALE e 100k **non ci sono più** 770101, 770202, 770411 e 770611, e che Guardian, SlippageLogger, SupRev 225JPY e TradeExporter sono ancora lì.

## ↩️ Come si torna indietro
Quando FTMO risponde, e **se** la risposta lo permette: grafico → **tasto destro → Modelli → Carica modello** → quello salvato al punto 1. Controllare che la faccina sia 🙂 e che "Algo Trading" sia verde.

---

## ✅ ESEGUITO — 24/09/2026 sera (foto dei giornali mandate da Claudio)
- **REALE `10105439`** (profilo `Default`): `ABTG_DAX_Apertura_EU (D30EUR,M5) removed` 22:49:09 · `ABTG_ORB_Ottimizzato (U30USD,M5) removed` 22:49:21.
- **100k `50504263`** (profilo `SQUADRA 100K`): `ABTG_DAX_Apertura_EU` 22:50:30 · `ABTG_Dow_Apertura_US` 22:50:39 · `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` 22:50:47 · `ABTG_ORB_Ottimizzato` 22:50:56, tutti `removed`.
- **In più, dopo la segnalazione**: tolto anche `Nasdaq_PreOpen_Breakout_EA` dal grafico **NASUSD,M5** del 100k. Il grafico non c'era nei `.chr` della notte; il giornale del 24/09 15:30 mostra `sell 21.6 NASUSD` e `cancel sell stop 9.2`, cioe' la firma 70/30 dell'EA esterno. Claudio l'aveva attaccato al 100k.
- **Profili salvati su tutti e due i terminali** (dichiarato da Claudio).
- **Da verificare**: la sonda `CODA_01` della notte del 25/09 alle 03:30 deve NON trovare 770101, 770202, 770411, 770611 ne' il PreOpen su REALE e 100k, e deve trovare ancora Guardian, SlippageLogger, SupRev 225JPY e TradeExporter. Da annotare anche: grafico **AUDUSD,H1** nuovo sul 100k (fuori dal perimetro dell'hedging).
