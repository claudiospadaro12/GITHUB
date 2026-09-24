# 📋 RESOCONTO DELLA GIORNATA — giovedì 24/09/2026, ore 21:00

**Giorno 4 della challenge FTMO `541452707`.** Mancano **7 giorni** al 1° ottobre.
Il netto trade per trade è della pagella delle 23:00 (`report/giornata_2026-09-24.md`): qui c'è il punto sul PROGETTO.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA
- **Runner notturno VPS** (`coda/referti/REFERTO_RUNNER_20260924_033003.txt`): **12 righe di sola lettura, 0 nella corsia ROUND**, uscita 0 su tutte. Nessuno Strategy Tester è partito sul VPS.
- **CODA_12** ha contato il per-trade FTMO col pin nuovo. **CODA_10**: lo SlippageLogger del reale ha **16 righe**, ultima scrittura **22/09 12:13**, quindi nessun deal nuovo da allora.
- **Caccia automatica**: `caccia_strategie/CACCIA_STOP_AMPIO_2026-09-24.md` (commit del 23/09 sera). 974 sorgenti del Code Base setacciati, **zero** con lo stop ampio per costruzione. Il risultato utile è un **conto**, non un candidato: la frontiera del 40× si attraversa fra **1,5 e 2,0 × ATR(H1)**. Tre proposte sono in bozza, **non ancora passate dal cancello**.

## 💶 IL CONTO
- **FTMO `541452707`, oggi, due sedie hanno sparato:**
  - `770411` MaxMin DAX short: **stop, −1.668,46 €** (analizzato in `report/SECONDO_STOP_FTMO_2026-09-24.md`: la geometria è quella del modello);
  - `770101` DAX Apertura RETEST BUY alle 15:35 IT: lo stop è salito sopra l'ingresso, **+69,66 €**;
  - **saldo ≈ 76.643 €**, dagli screenshot di Claudio. **Giorni di trading: 2 su 4** (22/09 e 24/09).
- **Monte Carlo** (`report/MC_MESI_ALLINEATI_2026-09-24.md`): **74,6%** di probabilità di passare dal saldo di stamattina, **70,8%** se le sedie a orario si contano solo nei mesi "come operano oggi". Che il calo venga dall'orologio **non è dimostrato**: il placebo su EMA200 sposta di più.
- **Dry-run 100k `50504263`** (`data/statements/trades_100k.csv`, fermo al 23/09 14:05): 37 righe, **netto +1.341,30 €, cioè +1,34%**. Al target del +10% mancano **8,66 punti**.
- **SlippageLogger sul reale**: i deal ci sono (16 righe, tutti `770101` D30EUR). Da ieri **nessuno nuovo**.

## 🔬 COSA È SUCCESSO, E COSA HO DECISO IO

### Tre round girati sul PC di backtest (lanciati da Claudio)
| round | esito | referto |
|---|---|---|
| **R245** Dow breakout a due lati | 🟢 altopiano `InpEmaSlow` 160-260, **centro 200**. OOS PF **1,489** n 197 DD 6,86% @1%. G0 giallo (deriva di lotto, n identico 32/32) | `REFERTO_R245_2026-09-24.md` |
| **R244** MaxMinNotte corto | 🟠 il cutoff non porta il corto a 150 posizioni (max ~105, **k = 1,42 misurato**). PF marginale 12→17 = **0,588** | `REFERTO_R244_2026-09-24.md` |
| **R243** SupRev Dow | 🔴🟢 la finestra USA **non** aiuta il Dow (0,790 / 0,794). 🟢 **corto spento con ancora Dow: OOS PF 1,643** (n 78, indizio) | `REFERTO_R243_2026-09-24.md` |

Nessuno dei tre archivia un candidato: su R243 e R244 il certificato di morte ha voci mancanti, e sono scritte.

### Scoperte del giorno
1. 🕰️ **L'orologio BCM è UTC+1 FISSO** (`report/OROLOGIO_BCM_2026-09-24.md`, circa 24.400 deal, 4 ancore). D'inverno BCM = ora italiana, quindi i backtest delle sedie a orario **mescolano due tempistiche**. Sul Dow `770202`: **PF 0,78 su n=73** nei mesi "come oggi" contro **1,66 su n=57** in quelli sfasati (ricontato alla fonte). Che la causa sia l'orologio **non è dimostrato**. CLAUDE.md è corretto. Era un compito aperto con scadenza 25/10.
2. 📩 **FTMO per iscritto**: l'hedging sullo stesso conto è **permesso**; le posizioni **opposte fra conti**, anche presso broker, sono **vietate**. Misura (`report/HEDGING_FRA_CONTI_2026-09-24.md`): **zero** sovrapposizioni opposte finora, ma ~**74%** di probabilità di almeno una in 20 giorni con le sole sedie del reale. La bozza della mail di chiarimento è pronta (`report/MAIL_FTMO_HEDGING_2026-09-24.md`).
3. 📉 **La peggior giornata del CostToCost era misurata con la regola sbagliata** (equity BCM invece del balance FTMO delle 00:00 italiane). L'EA ora ha la colonna FTMO vera, a calendario. Il "tappo" di quel candidato per FTMO è **[NON DIMOSTRATO]**.
4. 🔌 L'**EA esterno Nasdaq PreOpen** che Claudio voleva caricare su FTMO: sconsigliato con i numeri del 12/09 (gemello PF OOS **0,963**, DD **19,4%**, costo **13,3×**, orologio cablato a +2). Decisione di Claudio.

### Decisioni prese in autonomia
- **Centro di R245 = 200**, per la regola scritta prima (pari 200/220, vince il più basso).
- **CLAUDE.md "FUSO ORARIO BCM" corretto**, con la misura accanto.
- **Cancello [FUSO] riscritto a calendario** (classe 763): il 9/15 accidentale resta bloccato, quello dichiarato passa. Su 971 file prova l'esito è identico.
- **Messi in coda, con il PASS dei due strati**: passata stop SupRev, R246, R246 INVERNO, R247, R214E/F.

### ❌ I miei errori di oggi (tutti presi prima di arrivare a Claudio o al VPS)
- Ho scritto **01:00** invece di **23:00 BCM** per la mezzanotte italiana (classe 760): l'ha preso lo sviluppatore.
- **Fail-open** nel controllo 166 della riga R245: la variabile `$att` usata due volte (classe 753). L'ha preso l'agente di R244.
- Nel brief di R246 inverno avevo **invertito il verso delle ipotesi**. L'ha preso l'agente.
- Ho scritto che il bias H4 "si misura dai log degli agent": in ottimizzazione `Print` non gira (classe 771). L'ha preso il cancello della riga.
- In R243 ho lasciato **emoji dentro i file prova**, che lo strato 1 bloccava e lo strato 2 non aveva visto (classe 759).
Classi nuove nella checklist oggi: **745-771**.

## ⚠️ COSA ASPETTA CLAUDIO
1. 🔴 **Conto reale `10105439`**: sospendere o no, per la durata della challenge, le sedie su **DAX, Dow e Nasdaq** su **reale** e **100k**, finché FTMO non risponde sull'hedging fra conti. Opzione A′ del referto.
2. 📧 **Mandare la mail a FTMO** (testo pronto).
3. 💰 **Taglia del candidato R245**, se lo si schiera: a 1% il DD è 7,10%; a 2% è ~14% **[DERIVATO lineare]**, sopra il muro statico del 10%.
4. Ancora aperte da prima: **cap del Guardian 4,00% contro il 3,25% firmato**; **cancello sulla corsia ROUND del runner**; **sedie BCM a orario d'inverno**, entro il 25/10.

## 🎯 DOMANI
- **La coda al PC di backtest** (circa un'ora per le prime quattro):
  1. **passata stop SupRev**: il costo del candidato con PF 1,64;
  2. **R247**: le operazioni del candidato #1, sovrapposizione con 770202;
  3. **R246** e 4. **R246 INVERNO**: orologio o stagione, e cosa faranno le sedie FTMO dal 26/10;
  5. **R214E/F** CostToCost.
- Il controllo del **28/09**: posizioni della flotta FTMO contro le 13,4 attese.

🧭 **Bussola, detta onesta:** oggi **nessuna sedia nuova schierata**. Però due candidati hanno numeri nuovi e veri: **R245** con PF 1,49 su 197 posizioni, e il **SupRev corto** con PF 1,64 (indizio). E abbiamo **misurato un rischio che le sei sedie correvano senza saperlo**, cioè l'orologio d'inverno.
