# 📋 RESOCONTO DELLA GIORNATA — **18/09/2026**

*Il punto sul PROGETTO. La pagella degli EA (netto del giorno, trade per trade) è un'altra cosa
e gira alle 23:00 in un'altra chat: `report/giornata_2026-09-18.md`.*
**71 commit su `lavoro` oggi.**

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

### Il runner, corsa automatica delle **03:30** (sola lettura + corsia ROUND su `C:\MT5_Backtest`)
`backtest_pipeline/coda/referti/REFERTO_RUNNER_20260918_033004.txt`

| voce | valore |
|---|---|
| righe di coda | **127** |
| eseguite con uscita 0 | **81** |
| uscita 2 | **23** · uscita 3 | **23** |
| **rifiutate dai cancelli** | 🟢 **0** |
| esito | **PARZIALE** |

🟢 **Tutti i cancelli G1-G4 sono passati su tutte le righe**: nessuna riga malformata è arrivata
al terminale. ⚠️ **46 righe su 127 escono con codice ≠ 0** e il referto dice *«guarda il log»*:
la **causa non l'ho diagnosticata oggi** — 🔴 **[NON MISURATO]**, va in coda a domani.

### 🥇 E il runner ha trovato la cosa più grossa della giornata, da solo
`CODA_06_quale_codice_gira` ha fotografato che sul terminale **50503392**
(`BCM Markets MT5 Terminal`) **sei sedie su otto girano sorgenti di AGOSTO**.
Referto: `report/IL_CAMPO_GIRA_AGOSTO_ANCORA_2026-09-18.md` · censimento completo:
`report/CENSIMENTO_BINARI_50503392_2026-09-18.md`.

**Quattro difetti ATTIVI nel codice che opera adesso**, ordinati per danno:
1. 🧨 **Pavimento lotto minimo** → volume `totLot+volMin` = **doppio del rischio**. Colpisce
   **SuperWave `770511`**. Misurato in campo il 20/08: **1,42% su un contratto da 1,0%**.
2. 🧨 **Breakeven annegato nel parziale**: a 0,01 lotti la parziale arrotonda a zero **e salta
   anche lo stop in pari**. Colpisce **MAXMIN ORO `770402`**, che opera **proprio a 0,01 lotti**
   su tutte e 11 le posizioni. **112,78 € misurati** nella famiglia.
3. 🧨 **Guardia «un trade al giorno» col buco** (il giorno timbrato prima del controllo storico).
   Colpisce **DAX `770101`**, Dow, Nasdaq. Caso reale: 14/08 16:17:43, lotto 1,90.
4. ✍️ **FIX C4 latente**: `ABTG_DEF_RISK` ancora **2.0** compilato sul DAX → raddoppia al primo
   «Ripristina».

🟢 **Due sedie sono allineate**: `ORB_Ottimizzato` v1.04 (03/09) e `PostNews` v1.10 (04/09).
🟢 **La macchina di backtest è interamente a HEAD**: la divergenza è solo repo ↔ VPS.

### La caccia automatica
**Niente di nuovo oggi**: l'ultimo dossier in `backtest_pipeline/caccia_strategie/` è del
**14/09**. La Routine gira ogni 2 giorni: prossima finestra utile, non oggi.

---

## 💶 IL CONTO

| conto | stato |
|---|---|
| **100k `50504263`** (dry-run) | `data/statements/trades_100k.csv`: **35 posizioni**, P/L cumulato **+3.890,91 €**. Su un deposito da 100.000 fa **+3,89%** → al target +10% **mancano ~6.109 €**. ⚠️ È il **P/L dei trade esportati**, non il saldo letto dal terminale |
| **REALE `10105439`** | 🔴 **`data/statements/trades_reale.csv` NON ESISTE.** Il `TradeExporter` sul reale non ha ancora prodotto niente → **il SlippageLogger sul reale continua a non avere deal**. Invariato rispetto all'08/09 |
| **piccolo `50503392`** | vedi la pagella delle 23:00 |

---

## 🔬 COSA HO DECISO IO (e il numero che lo giustifica)

1. **`770201` Nasdaq FUORI dalla rosa per la prop.** L'avevo messa **prima** citando «7 vinte su
   7». È SPENTA dal 18/08 e 🔴 [SENZA CONTRATTO]: PF 0,82 · DD 17% · **19/20 celle OOS negative**
   (`CONTRATTI_SEDIE.md` r.54). Con R83+R84 fa **12 configurazioni, 12 OOS negative**.
2. **Nessuna taglia proposta, su nessuna sedia.** Il rischio realizzato di `770511` è misurato su
   **UN SOLO segnale** (0,33%): con n=1 non è misurato affatto.
3. **Nessun round lanciato sul Nasdaq per «provare il retest»**: è già provato, e i tick degli
   indici partono dal **26/09/2024** — più campione su quella finestra **non esiste**.
4. **Indicizzati R83 e R84 in `REGISTRO_TEST.md`** (erano a zero righe: è il motivo per cui ho
   detto «mai provato» di una cosa misurata).

### 🔴 E GLI ERRORI DI OGGI, che il cancello ha preso prima che ti costassero
- **«il RETEST sul Nasdaq non è mai stato provato»** → **falso**: misurato in tre posti.
- **«è già provato e ha perso»** → **incompleto**: due celle sono positive in OOS.
- **«0,13% di rischio realizzato su `770511`»** → **sbagliato**: contava le **gambe**, non i
  **segnali**. È **0,33% su n=1**. *(Ed è l'errore che avevi corretto tu stamattina sulla stessa
  sedia.)*
- **«il Guardian assente sul piccolo è un difetto»** → **no, è una TUA firma** del 06/09.
- **Due frasi delle live attribuite al DAX** → erano dette guardando l'**S&P**.
- **`770402` fuori contratto** → **no, è IN contratto**: la firma R100 del 23/08 l'ha portata a 0,5%.

📌 **Sei correzioni, tutte trovate prima della consegna.** Tre classi nuove in checklist (**427**,
**428**, **429**), più **430-433** dagli agenti.

---

## ⚠️ COSA ASPETTA CLAUDIO

**Niente che tocchi il conto reale 10105439.** Quattro cose, tutte tue per firma:

1. 🔴 **Ricompilare i due file che colpiscono sedie della rosa** — SuperWave e MaxMinNotte sul
   terminale **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`). ⚠️ **NON a HEAD**:
   SuperWave va a **`872dba82` (08/09)**, che è marcato passato-cancello *e* porta il fix n.1.
   Fuori dal perimetro del runner, che è in sola lettura. **Se dici sì, ti preparo la sequenza.**
2. 🟠 **La prop**: FTMO (1:15) o FundedNext Stellar 2-Step (1:25). Cambia quanti lotti entrano in
   margine più di qualunque altra decisione, e **blocca il pacchetto di schieramento**.
3. 🟠 **Le taglie** (`InpRiskPercent` per sedia). Tue per mandato.
4. ⚪ **La riga dell'ATR** in `MonitorCloseConfirm`: una riga, e la regola delle slide diventa
   misurabile per intero. Senza, ne misuriamo metà.

---

## 🎯 DOMANI

1. **Diagnosticare le 46 righe con uscita ≠ 0** del runner — oggi non l'ho fatto.
2. 🥇 **`MaxMinNotte` sul Nasdaq**: il motore dei livelli notturni, mai puntato lì (**0 file su
   NASUSD** contro 24 su D30EUR). È la pista che nasce dalle immagini di Claudio, ed è l'unica
   che cambia **il livello**, non l'ingresso.
3. **R180 (duello Dow)** e **R183 (croce delle slide)**: pronti, sotto cancello, in attesa di via.
4. **R185 (sonda SPX + NASUSD)**: profondità dei tick reali, mai misurata su quei due simboli.

---

## 🧭 LA BUSSOLA, onesta
Oggi ho prodotto **molto ponteggio** — referti, correzioni, indici d'archivio — e va dichiarato.
🟢 **Ma tre cose avvicinano davvero una sedia**: la rosa è pulita (una sedia bocciata è uscita), il
DAX ha una seconda misura indipendente che lo conferma, e soprattutto **sappiamo che due delle tre
sedie della rosa girano codice difettoso in campo** — che era invisibile stamattina ed è il primo
cancello dello schieramento.
🔴 **Sul Nasdaq la quadra NON c'è**: 16 configurazioni misurate, **zero passano i cancelli**.
