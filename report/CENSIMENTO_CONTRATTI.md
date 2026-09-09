# 📜 CENSIMENTO DEI CONTRATTI — che cosa il backtest ha PROMESSO, sedia per sedia

_Compilato il **07/09/2026**. È il **prerequisito dichiarato** del criterio di
uscita delle sedie firmato il 18/08/2026 (`report/FIRME_2026-08-18.md`, corsia
RISCHIO: **"DD forward > DD promesso dal backtest della cella promossa →
revisione IMMEDIATA"**). Senza questa tabella quel criterio **non è
applicabile**: il "DD promesso" non sta scritto in nessun posto operativo._

> 🧊 **Regola di lettura, congelata prima dei numeri.** Questo file **non
> giudica e non spegne niente**: registra la promessa e la sua fonte. Dove la
> promessa non è ricostruibile dall'archivio la riga dice **NON MISURATO** e
> spiega perché. **Nessun numero è stimato, interpolato o inventato.** Un
> censimento pieno di NON MISURATO vale più di uno completo e inventato.

---

## 0. 🧭 DA DOVE VIENE LA LISTA DELLE SEDIE (il perimetro, dichiarato)

Non esiste oggi una foto unica e recente di tutti e tre i terminali. Il
perimetro di questo censimento è la **somma di quattro fonti**, ognuna citata
sulla riga che genera:

| # | fonte | che cosa dà | data |
|---|---|---|---|
| A | `backtest_pipeline/risultati_archivio/censimento_rischio_2026-08-25_0731.txt` | ultima lettura **automatica dai `.chr`**: EA · simbolo · magic · rischio dichiarato (52 righe → 37 sedie di trading uniche) | 25/08 |
| B | `report/CONTRATTI_SEDIE.md` (M11 del 18/08 + revisioni firmate 23-24/08) | il **DD promesso e la frequenza promessa** già ricostruiti, con la fonte | 18-24/08 |
| C | `HANDOFF.md` §06/09 + `mql5/Presets/conto_reale/` | il **conto reale 10105439**: verifica grafico-per-grafico del 06/09 | 06/09 |
| D | verbali di deploy successivi al 25/08 (`report/CONTRATTO_GATEDSHORT_770250.md`, `backtest_pipeline/righe/RIGA_POSTNEWS_*`) | le sedie **nate dopo** l'ultima foto `.chr` | 30/08-04/09 |

🔴 **Il perimetro ha tre buchi noti, elencati in §5 e NON tappati a mente.**

---

## 1. ⚖️ LE UNITÀ DI MISURA — senza queste, i DD non si confrontano fra loro

1. **Il DD promesso è sempre accompagnato da DEPOSITO + RISCHIO %** del
   backtest che lo ha prodotto. Un DD del 10% a rischio 1% e un DD del 10% a
   rischio 0,25% **non sono lo stesso rischio**.
2. **Scala col rischio**: il DD% scala ~linearmente col rischio per trade
   ([APPROSSIMATO], è la convenzione di casa già usata nelle revisioni firmate
   del 23-24/08). Dove la sedia gira a taglia diversa dal backtest, la riga
   riporta **il DD del backtest** e, fra parentesi, **il DD atteso alla taglia
   viva**, marcato `≈`.
3. **Il DD% è ~indipendente dal deposito** a rischio percentuale: la % vale
   anche sul piccolo (~5.100 €) e sul reale (equità 7.500 €). **Gli euro no.**
4. **`n`** = operazioni contate dal tester nella finestra su cui la promessa è
   scritta. ⚠️ Su PTE / SuperWave / MaxMin il tester conta le **chiusure
   parziali** (2-3 per posizione): dove è noto, è scritto.
5. **MERITO SOSPESO** = regola di casa (valvola R59 + Emendamento B):
   **sotto 150 operazioni il giudizio sul MERITO si sospende, quello sul
   RISCHIO no** — un DD accaduto vale a qualunque `n`.
6. **Frequenza promessa** in operazioni/giorno = op/mese ÷ **21,7 giorni di
   borsa**. La conversione è dichiarata qui una volta sola.
7. **Modello**: `tick` = tick reali (Modello 4) · `OHLC` = 1 minuto OHLC
   (Modello 1) = **limite INFERIORE del DD**, mai un permesso.

---

## 2. 💶 CONTO REALE — 10105439 (istanza `C:\BCM_Reale`) — 2 SEDIE

_Fonte della lista: `HANDOFF.md` §06/09 (verifica grafico-per-grafico:
`D30EUR,M5` = DAX Apertura EU ✅, `U30USD,M5` = ORB Ottimizzato ✅) +
`mql5/Presets/conto_reale/*.set` (`InpRiskPercent=0.65` su entrambe).
Guardian 779002 e SlippageLogger sono utility: non tradano, non hanno contratto._

| EA | Magic | Sym | TF | Rischio VIVO | **DD PROMESSO** | Deposito/rischio del backtest | `n` | MERITO | **Freq. promessa** | Fonte | STATO |
|---|---:|---|---|---:|---|---|---:|---|---|---|---|
| `ABTG_DAX_Apertura_EU` | 770101 | D30EUR | M5 | **0,65%** | **10,60%** a 1% → **≈6,89%** a 0,65% | **10.000 €** · **1,0%** · **tick** · OOS 2024.09.26+split, 12,6 mesi | **311** | 🟢 **PIENO** (311 ≥ 150) | ~21 op/mese ⇒ **~0,97 op/g** | `risultati_archivio/r83_csv/ABTG_Apertura_3Ingressi_D30EUR_OOS_r83d1.csv` riga `entry=1` (DD 10,5984 · n 311 · PF 1,18776 · profit +999,42 · pegg. giorno −1,0671%) — **R83**, cella RETEST = la cella viva; revisione firmata 02/09 (`FIRME_2026-09-02.md`) | ✅ **MISURATO** |
| `ABTG_ORB_Ottimizzato` | 770611 | U30USD | M5 | **0,65%** | **6,5389%** (OOS) · **5,6530%** (IS) — **già alla taglia viva** | **10.000 €** · **0,65%** · **tick** · IS 2024.09.26→2025.06.09 / OOS 2025.06.10→2026.06.30 | **119** OOS · **71** IS | 🟠 **SOSPESO** (119 e 71 < 150) | ~9,4 op/mese ⇒ **~0,43 op/g** | `risultati_archivio/ritardo_r119_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_R119_ORB_D0000.csv` · referto `REFERTO_RITARDO_R119_PRIMO_GIRO.md` — **R119, 07/09/2026** | ✅ **MISURATO** (il più recente e il più pulito del parco: taglia del backtest = taglia viva) |

> 🔴 **Nota di rischio che va detta ogni volta che si cita l'ORB sul reale**:
> il contratto storico della sedia è **9,92% a rischio 1%** (R15) col
> **doppio asterisco** — passava il muro del 10% per 8 centesimi. E R118
> (`REFERTO_R118_PAVIMENTO_STOP.md`) misura che **la configurazione VIVA è
> l'unica che sfonda il muro sotto slippage (DD 9,76 → 10,34 a 1%)**. Il
> 6,54% qui sopra è lo stesso motore alla taglia ridotta: il margine viene
> dalla taglia, non dal motore.

### 🛑 CHIUSURA DELLA CONTRADDIZIONE C3 (09/09/2026) — **9,92% e 10,00% NON SONO IN CONFLITTO: SONO DUE MISURE DIVERSE**

_Aperta da `report/CENSIMENTO_SCARTATI_PROSA_2026-09-09.md` §C3 e da
`report/PERCHE_MUOIONO_2026-09-08.md` r.66-67 e r.77-80. **Chiusa senza
lanciare niente**, confrontando i due referti campo per campo._

| | **9,92%** | **10,00%** |
|---|---|---|
| fonte | `risultati_archivio/REFERTO_ROUND15_ORB_GESTIONE.md` r.14-17 | `risultati_archivio/R103_REFERTO_BLOCCO1_INDICI.md` r.12 |
| data | **09/08/2026** (R15) | **24/08/2026** (R103, corsa 13:48→14:02) |
| finestra | **solo OOS** (~12,6 mesi) | **21 mesi INTERI** (IS+OOS, 2024.09.26 → 2026.06.30) |
| modello di barre | **tick reali** | **OHLC M1** |
| deposito | **10.000 €** | **100.000 €** |
| rischio simulato | **1,0%** — misurato direttamente | **0,3%** → DD misurato **3,00%**, poi **NORMALIZZATO ×3,33** |
| `n` | **119** | **190** |
| PF | 1,657 | 1,67 |

🔎 **La prova che e' la STESSA cella e non due celle rivali: `71 + 119 = 190`.**
L'IS di R15 fa **71** trade e l'OOS **119**; R103 gira la **stessa
configurazione** sulla finestra intera e conta **esattamente 190**. **Non e' un
conflitto: e' la stessa sedia guardata su una finestra piu' lunga, con un
modello di barre piu' grezzo e con una taglia diversa riportata a 1% con una
moltiplicazione.**

**➡️ QUALE E' IL NUMERO DEL CONTRATTO — la risposta in tre righe, in ordine:**
1. 🥇 **Il numero OPERATIVO, quello che si usa oggi sulla `770611` del conto
   REALE 10105439, e' `6,5389%` OOS / `5,6530%` IS** — **R119 del 07/09/2026**,
   perche' e' **l'unico misurato ALLA TAGLIA VIVA (0,65%)**, a tick, col
   **preset del conto reale**. E' gia' la riga della tabella §2 qui sopra.
2. 🥈 **Il contratto STORICO e' `9,92% a 1%` (R15)** — tick reali, misura
   diretta, **col doppio asterisco** (passava il muro per 8 centesimi).
3. 🥉 **Il `10,00%` di R103 e' un numero DERIVATO, non una misura a 1%**: viene
   da 3,00% moltiplicato per 3,33, su barre OHLC. **Va citato come stima di
   confronto fra motori** (e' la colonna normalizzata di una classifica), **mai
   come il DD promesso della sedia**.

**🔴 E la risposta a "dentro il muro o AL muro" e' che la domanda cambia con la
taglia, ed e' l'unica cosa che conta:**
- **a 1,0% — taglia che NON e' in campo** — la sedia sta **al muro da tutte e
  tre le parti**: 9,92% (R15, tick) · 10,00% (R103, derivato) · e **10,34%
  SOPRA il muro** sotto slippage assunto (`REFERTO_R118_PAVIMENTO_STOP.md`).
  **Tre misure indipendenti nella stessa fascia: non e' rumore, e' il posto
  dove sta il motore.**
- **a 0,65% — la taglia VERA sul conto reale** — sta a **6,54%**, cioe' **3,46
  punti sotto il muro**. ✅ **Dentro.**
- 👉 Quindi: **la sedia e' DENTRO il muro, e ci sta per la TAGLIA, non per il
  motore.** Alzarla a 1% la porta **al** muro o **oltre**. Questa frase era
  gia' in questo file e nel `PIANO_PROP`: la chiusura di C3 non la cambia, **la
  rende una misura invece che un'avvertenza**.
- ⚠️ **Resta il limite dichiarato e non chiuso da nessuno dei tre numeri**: il
  **merito e' SOSPESO** (n 119 e 71, sotto 150) e **21 mesi sono UN SOLO
  REGIME (toro)**. E lo slippaggio vero sul conto che paga e' **`[NON
  MISURATO]`** (`SlippageLogger`: **0 deal**, `PIANO_PROP.md` I1/M37).

📄 Verbale: `report/CONTRADDIZIONI_CHIUSE_2026-09-09.md` §C3.

---

## 3. 🛡️ CONTO 100K DEMO — 50504263 (istanza `-V3`, dry-run FTMO 2-Step) — 5 SEDIE

_Fonte: `report/DEPLOY_GUARDIANO_100K.md` (deploy 09/08, 5 EA verificati
campo-per-campo) + conferma indiretta dalle pagelle 24/08→04/09 (§"Conto 100k"
di `report/giornata_*.md`: hanno operato lì **solo** DAX Apertura RETEST, Dow
Apertura RETEST, ORB OTT, MAXMIN DAX SHORT, STREV). **I magic sono gli stessi
del piccolo** (decisione firmata n.2 del 02/09: si rinumerano solo
all'apertura della challenge vera)._

🛑 **La migrazione delle 13 sedie nuove (`PIANO_MIGRAZIONE_100K_2026-08-31.md`,
blocco magic `88xxxx`) NON RISULTA ESEGUITA**: nessun magic `88xxxx` compare in
nessuna pagella né in nessun censimento. Il 100k è ancora il quintetto del 09/08.

| EA | Magic | Sym | TF | Rischio VIVO | **DD PROMESSO** | Deposito/rischio del backtest | `n` | MERITO | **Freq. promessa** | Fonte | STATO |
|---|---:|---|---|---:|---|---|---:|---|---|---|---|
| `ABTG_DAX_Apertura_EU` | 770101 | D30EUR | M5 | **0,65%** | **10,60%** a 1% → **≈6,89%** | 10.000 € · 1,0% · tick · 12,6 mesi | **311** | 🟢 PIENO | ~0,97 op/g | R83 (come sopra) | ✅ **MISURATO** |
| `ABTG_Dow_Apertura_US` | 770202 | U30USD | M5 | **0,65%** | **4,22%** a 1% → **≈2,74%** | **100.000 €** · **1,0%** · **tick** · OOS 2025.06.10→2026.06.30 | **130** | 🟠 **SOSPESO** (130 < 150) | ~10 op/mese ⇒ **~0,46 op/g** | `REFERTO_PORTAFOGLIO_R16.md` §serie (riga `Dow Apertura ricetta 770206`: 130 tr · +6.721,93 · DD 4,22%); riconferma R54 4,39% PF 1,270 | ✅ **MISURATO** |
| `ABTG_ORB_Ottimizzato` | 770611 | U30USD | M5 | **0,30%** | **9,92%** a 1% (R15, doppio asterisco) / **9,72%** a 100k (R16) → **≈2,98%** a 0,30% | R15: 10.000 € · 1,0% · tick — R16: 100.000 € · 1,0% · tick | **119** | 🟠 **SOSPESO** | ~0,43 op/g | `REFERTO_ROUND15_ORB_GESTIONE.md` · `REFERTO_PORTAFOGLIO_R16.md` (riga `ORB-EMA200 lab 770612`) | ✅ **MISURATO** |
| `ABTG_MaxMinNotte_DAX_Short_Ott` | 770411 | D30EUR | M15 | **0,65%** | **1,27%** a 1% → **≈0,83%** | **100.000 €** · **1,0%** · **tick** · OOS 12,6 mesi | **21** | 🟠 **SOSPESO** (21 ≪ 150) | ~1,7 op/mese ⇒ **~0,078 op/g** | `REFERTO_PORTAFOGLIO_R16.md` (riga `MaxMinNotte DAX Short 770413`: 21 tr · DD 1,27%) | ✅ **MISURATO** ⚠️ campione minuscolo |
| `ABTG_SupertrendReversal` (Nikkei H2) | 770901 | 225JPY | H2 | **0,65%** | **0,88%** (R5, 100k) / **0,65%** (R16) a 1% → **≈0,57%** | 100.000 € · 1,0% · tick · OOS 12,6 mesi | **50** | 🟠 **SOSPESO** | ~4 op/mese ⇒ **~0,18 op/g** | `REFERTO_ROUND5_NIKKEI.md` · `REFERTO_PORTAFOGLIO_R16.md` (riga `Nikkei STREV H2 770903`: 50 tr · DD 0,65%) | ✅ **MISURATO** |

---

## 4. 🧪 CONTO PICCOLO DEMO — 50503392 (istanza `BCM Markets MT5 Terminal`, senza `-V3`)

**È il conto-strumento di misura**: decisione di Claudio del 06/09 —
**NIENTE Guardian sul piccolo**, perché il DD della flotta si deve vedere
**NON FRENATO**, altrimenti il criterio di RISCHIO del 18/08 confronterebbe un
numero potato con un numero intero (`HANDOFF.md` §3 del 06/09).

### 4a. 🏛️ Le storiche R16 e il vivaio R23

| EA | Magic | Sym | TF | Rischio VIVO | **DD PROMESSO** | Deposito/rischio del backtest | `n` | MERITO | **Freq. promessa** | Fonte | STATO |
|---|---:|---|---|---:|---|---|---:|---|---|---|---|
| `ABTG_DAX_Apertura_EU` | 770101 | D30EUR | M5 | **1,0%** | **10,60%** | 10.000 € · 1,0% · tick · 12,6 mesi | **311** | 🟢 PIENO | ~0,97 op/g | R83 — CSV citato in §2 | ✅ **MISURATO** |
| `ABTG_Dow_Apertura_US` | 770202 | U30USD | M5 | **1,0%** | **4,22%** | 100.000 € · 1,0% · tick | **130** | 🟠 SOSPESO | ~0,46 op/g | R16 · R54 | ✅ **MISURATO** |
| `ABTG_ORB_Ottimizzato` | 770611 | U30USD | M5 | **1,0%** | **9,92%** ⚠️ doppio asterisco | 10.000 € · 1,0% · tick | **119** | 🟠 SOSPESO | ~0,43 op/g | R15 · R16 · R119 | ✅ **MISURATO** |
| `ABTG_MaxMinNotte_DAX_Short_Ott` | 770411 | D30EUR | M15 | **1,0%** | **1,27%** | 100.000 € · 1,0% · tick | **21** | 🟠 SOSPESO | ~0,078 op/g | R16 | ✅ **MISURATO** |
| `ABTG_SupertrendReversal` (Nikkei H4 FW) | 770924 | 225JPY | H2 | **1,0%** | **0,14%** | [deposito **NON DICHIARATO** nel registro] · 1,0% · tick 30/07 · 2024.01→2026.06 nominale | **21** | 🟠 SOSPESO | ~1 op/mese ⇒ **~0,046 op/g** | `CLASSIFICHE.md` §2 SupertrendReversal · `FLOTTA_ATTIVA.md` — 🔴 e `VERBALE_CHIUSURA_770101_2026-09-02.md` §C1 dice che **il 02/09 non era in lista Expert** | 🟠 **DA RIPRODURRE** (deposito ignoto + presenza in campo contesa) |
| `ABTG_MaxMinNotte` (oro notte) | 770402 | XAUUSD | H2 | **0,5%** | **19,72%** a 1% → **10,0%** a 0,5% (firma 23/08) ⚠️ solo il TORO 2021 fa 9,4% a 1% | [deposito **NON DICHIARATO** nel referto] · 1,0% · **OHLC** (limite inferiore) · **2004.06.11→2026.06.30, 22 anni** | **693** (R103, 6,5 anni) | 🟢 PIENO | ~3,7 posizioni/mese ⇒ **~0,17 op/g** (dato R17; forward finora 2 trade) | `R100_REFERTO.md` tabella madre (riga `MaxMinNotte 770402`: DD 22a **19,72%**, pegg. giorno −1,07%, **3,7x il promesso vecchio**) · zip `R100_ORO_FLOTTA_CORSA_20260823_1449` | ✅ **MISURATO** (riscritto da R100) |
| `ABTG_PTE` | 771321 | U30USD | H1 | **1,0%** | **2,18%** | **100.000 €** · **1,0%** · **tick** · OOS ~12,5 mesi | **40** chiusure | 🟠 SOSPESO | ~3,2 op/mese ⇒ **~0,15 op/g** | `REFERTO_ROUND23_PERTRADE.md` · deploy `report/VIVAIO_R23_DEPLOY.md` | ✅ **MISURATO** |
| `ABTG_PTE` (storica, duello) | 771322 | GBPUSD | H1 | **0,5%** | **2,64%** a 1% → **≈1,32%** | 100.000 € · 1,0% · tick · OOS ~12,5 mesi | **49** chiusure | 🟠 SOSPESO | ~3,9 op/mese ⇒ **~0,18 op/g** | `REFERTO_ROUND23_PERTRADE.md` | 🟠 **DA RIPRODURRE** — 🔴 **contratto CONTESO**: R78 (OHLC 13 anni) sulla stessa cella dà **DD 17,68% · PF 0,972 · −2.125**; R103 (6,5 anni) dà **DD 13,1% · PF 0,96 · n 175**. Il 2,64% e il 13-17% **non possono essere entrambi il DD promesso** |
| `ABTG_PTE` (candidata B25, duello) | 771332 | GBPUSD | H1 | **0,5%** | **9,87%** a 1% → **≈4,94%** | [deposito **NON DICHIARATO**] · 1,0% · **OHLC** · OOS 2013.04→2026.06, 13 anni | **477** | 🟢 PIENO | ~3 op/mese ⇒ **~0,14 op/g** | `REFERTO_ROUND78_SEDIA_VERA_FINESTRA_LUNGA.md` §2 · R103: DD 5,8% a 1%, n 188 | ✅ **MISURATO** |
| `ABTG_SuperWave` (H2) | 770531 | U30USD | H2 | **1,0%** | **2,96%** | 100.000 € · 1,0% · tick · OOS ~12,5 mesi | **88** chiusure (~50 posizioni) | 🟠 SOSPESO | ~4 posizioni/mese ⇒ **~0,18 op/g** | `REFERTO_ROUND23_PERTRADE.md` | ✅ **MISURATO** |

### 4b. 📈 EMA200 e i vecchi «Ottimizzati» del 26/07

| EA | Magic | Sym | TF | Rischio VIVO | **DD PROMESSO** | Deposito/rischio del backtest | `n` | MERITO | **Freq. promessa** | Fonte | STATO |
|---|---:|---|---|---:|---|---|---:|---|---|---|---|
| `ABTG_EMA200` | 771531 | U30USD | H1 | **1,0%** | **7,21%** | [deposito **NON DICHIARATO**, walk-forward → default driver **10.000 €**] · 1,0% · OOS 12/06/2025→26/06/2026 | **444** | 🟢 **PIENO** | ~33-35 op/mese ⇒ **~1,55 op/g** | `REFERTO_ROUND29_EMA200_WF.md` (cella CENTRO O1 0,20 / O2 0,3 / TP 2,0, regione 30/30 PASS) · `REFERTO_ROUND31_EMA200_PORTAFOGLIO.md` · R103 indici: DD 6,48% n 712 | ✅ **MISURATO** — 🔴 **è il singolo motore più veloce della flotta**: 1,55 op/g da sola |
| `ABTG_EMA200_Ottimizzato` | 971501 | XAUUSD | H4 | **0,25%** | **45,91%** a 1% → **11,5%** a 0,25% (firma 23/08) | [deposito **NON DICHIARATO**] · 1,0% · **OHLC** · **22 anni** | **610** (R103, 6,5a) | 🟢 PIENO | ~6,6 op/mese ⇒ **~0,30 op/g** | `R100_REFERTO.md` (riga `EMA200_Ottimizzato 971501`: DD 22a **45,91%**, **10,4x** il promesso vecchio di 4,40%, pegg. giorno −1,91%) | ✅ **MISURATO** — 🔴 **prop: NO a nessuna taglia** (firma 23/08) |
| `ABTG_SupertrendReversal_Ottimizzato` | 970901 | XAUUSD | H4 | **1,0%** | **9,02%** | [deposito **NON DICHIARATO**] · 1,0% · **OHLC** · 2004.06.11→2026.06.30, **22 anni** | **657** | 🟢 **PIENO** | ~2,5 op/mese ⇒ **~0,115 op/g** | `R99_REFERTO.md` §A (DD massimo equity 22 anni **9,02%**, 657 op, gemelli identici al centesimo) · zip `R99_ORO_22ANNI_CORSA_20260823_1333` | ✅ **MISURATO** ⚠️ margine sul muro 10% = **0,98 punti**; a rischio 2% i numeri raddoppiano |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | 970912 | D30EUR | H4 | **1,0%** | **5,7%** | [deposito **NON DICHIARATO**] · 1,0% · tick 26/07 · 2024.01→2026.06 nominale (tick indici dal 2024.09.26) | **86** | 🟠 SOSPESO | ~4 op/mese ⇒ **~0,18 op/g** | `REGISTRO_TEST.md` §4 S4v (PF 1,96 · 86 tr) · R103 indici: DD 4,22% n 99 | 🟠 **DA RIPRODURRE** — revalidation 30/07 dà **PFmed reale 1,05 marginale**; ed è l'unica sedia con **tensione statistica vera** sul silenzio (`DIAGNOSI_SEDIE_MUTE_2026-09-05.md` §6) |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | 970913 | NASUSD | H1 | **1,0%** | **1,17%** | [deposito **NON DICHIARATO**] · 1,0% · tick · 2024.01→2026.06 nominale | **155** | 🟢 **PIENO** (155 ≥ 150) | ~7,4 op/mese ⇒ **~0,34 op/g** | `REGISTRO_TEST.md` §4 S5v (PF 1,57 · 8/8 combo positive) · `CLASSIFICHE.md` · R103 indici: DD 1,48% n 172 | ✅ **MISURATO** ⭐ il prop-friendly |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | 770511 | U30USD | H1 | **1,0%** | **4,0%** | [deposito **NON DICHIARATO**] · 1,0% · tick · 2024.01→2026.06 nominale | **227** | 🟢 **PIENO** | ~10,8 op/mese ⇒ **~0,50 op/g** | `REGISTRO_TEST.md` §SuperWave validazione (PF 1,52 · 9/9 combo) · R103 indici: DD 4,14% n 290 | ✅ **MISURATO** |

### 4c. 🧬 Le famiglie di agosto (walk-forward IS 40 / OOS 60, storico dal 2024.09.26)

_Salvo dove indicato: **deposito 10.000 €** (default di `walkforward_generico.ps1`
riga 101) · **rischio 1,0%** · OOS ~13 mesi._

| EA | Magic | Sym | TF | Rischio VIVO | **DD PROMESSO** | Deposito/rischio del backtest | `n` | MERITO | **Freq. promessa** | Fonte | STATO |
|---|---:|---|---|---:|---|---|---:|---|---|---|---|
| `ABTG_BreakingBand` | 772161 | GBPUSD | H1 | 1,0% | **3,4%** (WF) / **1,9%** (100k R34) | 10.000 € / 100.000 € · 1,0% | **26** | 🟠 SOSPESO | ~2,0 op/mese ⇒ **~0,092 op/g** | `REFERTO_ROUND33_BREAKINGBAND_WF.md` · `REFERTO_ROUND34_BB_PORTAFOGLIO.md` · R103: DD 7,8% n 126 (6,5 anni) | ✅ MISURATO |
| `ABTG_BreakingBand` | 772162 | EURUSD | H1 | 1,0% | **1,2%** | 10.000 € · 1,0% | **13** ⚠️ IS con **4 trade** | 🟠 SOSPESO | ~1,0 op/mese ⇒ **~0,046 op/g** | R33 · R34 · R103: DD 2,5% n 59 | ✅ MISURATO ⚠️ campione al limite del leggibile |
| `ABTG_BreakingBand` | 772163 | AUDUSD | H1 | 1,0% | **1,2%** | 10.000 € · 1,0% | **11** | 🟠 SOSPESO | ~0,8 op/mese ⇒ **~0,037 op/g** | R33 · R34 · R103: DD 2,1% n 64 | ✅ MISURATO ⚠️ idem |
| `ABTG_GapFill` | 772231 | GBPUSD | — | 1,0% | **2,4%** (WF) / 1,0% (100k) | 10.000 € / 100.000 € · 1,0% | **8** | 🟠 SOSPESO | ~0,6 op/mese ⇒ **~0,028 op/g** | `REFERTO_ROUND36_GAPFILL_WF.md` · `REFERTO_ROUND37_GAP_PORTAFOGLIO.md` · R103: n 13 «sottile» | ✅ MISURATO |
| `ABTG_GapFill` | 772232 | EURUSD | — | 1,0% | **1,5%** / 1,0% | 10.000 € / 100.000 € · 1,0% | **9** | 🟠 SOSPESO | ~0,7 op/mese ⇒ **~0,032 op/g** | R36 · R37 · R103: n 14 «sottile» | ✅ MISURATO |
| `ABTG_GapFill` | 772233 | AUDUSD | — | 1,0% | **1,9%** / 1,0% | 10.000 € / 100.000 € · 1,0% | **12** | 🟠 SOSPESO | ~0,9 op/mese ⇒ **~0,041 op/g** | R36 · R37 · R103: n 17 «sottile» | ✅ MISURATO |
| `ABTG_GapFill` | 772234 | U30USD | — | 1,0% | **2,3%** | 10.000 € · 1,0% | **20** | 🟠 SOSPESO | ~1,5 op/mese ⇒ **~0,069 op/g** | R36 (PF 1,30); **esclusa dal portafoglio R37** (cumulo del lunedì) → osservazione, porta 100k chiusa · R103 indici: DD 3,21% n 30 | ✅ MISURATO |
| `ABTG_GapFill` | 772235 | 225JPY | — | 1,0% | **4,3%** | 10.000 € · 1,0% | **15** | 🟠 SOSPESO | ~1,2 op/mese ⇒ **~0,055 op/g** | R36 (PF 1,14, il più tirato) · richeck R65 (DD 4,36%) · R103 indici: DD 4,66% n 26 | ✅ MISURATO |
| `ABTG_PunteLarry` | 772341 | U30USD | H1 | 1,0% | **3,9%** | 10.000 € · 1,0% | **38** | 🟠 SOSPESO | ~2,9 op/mese ⇒ **~0,134 op/g** | `REFERTO_ROUND38_PUNTE_LARRY.md` · deploy R39 · R103 indici: DD 3,96% n 55 | ✅ MISURATO |
| `ABTG_PunteLarry` | 772342 | EURAUD | H1 | **0,5%** | **17,1%** a 1% → **8,6%** a 0,5% | **100.000 €** · normalizzato a 1,0% · **OHLC** · **6,5 anni** | **216** | 🟢 PIENO | ~2,5 op/mese ⇒ **~0,115 op/g** | `R103_REFERTO_FINALE.md` pos. 15 (DD 1% **17,1%** · PF 1,05 · n 216 · 3/7 anni negativi) — era 3,7% in R38 | ✅ MISURATO (riscritto da R103) |
| `ABTG_PunteLarry` | 772343 | XAUUSD | H1 | **0,3%** | **29,74%** a 1% → **9,0%** a 0,3% | [deposito **NON DICHIARATO**] · 1,0% · **OHLC** · **22 anni** | ~10 op/anno (R100); **60** in R103 (6,5a) | 🟠 SOSPESO | ~0,8 op/mese ⇒ **~0,037 op/g** | `R100_REFERTO.md` (DD 22a **29,74%** = **8,5x** il promesso vecchio 3,50%; pegg. giorno −3,91% a 1%) | ✅ MISURATO — 🔴 tagliando 6 mesi: se il merito non arriva, spegnere |
| `ABTG_PunteLarry` | 772344 | GBPJPY | H1 | 1,0% | **2,7%** | 10.000 € · 1,0% | **20** | 🟠 SOSPESO | ~1,5 op/mese ⇒ **~0,069 op/g** | R38 · R39 · R103: DD 9,0% n 139 (6,5 anni) | ✅ MISURATO |
| `ABTG_PunteLarry` | 772345 | GBPUSD | H1 | 1,0% | **5,1%** | 10.000 € · 1,0% | **25** | 🟠 SOSPESO | ~1,9 op/mese ⇒ **~0,088 op/g** | R38 · R39 · R103: DD 8,5% n 121 | ✅ MISURATO |
| `ABTG_PunteLarry` | 772346 | EURCAD | H1 | 1,0% | **4,8%** | 10.000 € · 1,0% | **19** | 🟠 SOSPESO | ~1,5 op/mese ⇒ **~0,069 op/g** | R38 · R39 (PF 1,25, «il più tirato») · R103: DD 7,0% n 154 | ✅ MISURATO |
| `ABTG_CostToCost` | 772361 | EURJPY | — | **0,65%** | **12,3%** a 1% → **8,0%** a 0,65% | **100.000 €** · normalizzato a 1,0% · **OHLC** · **6,5 anni** | **394** | 🟢 PIENO | ~4,7 op/mese ⇒ **~0,217 op/g** | `R103_REFERTO_FINALE.md` pos. 2 (PF 1,41 · DD 12,3% · n 394 · 1/7 anni neg.) — era 9,33% in R40/R41 | ✅ MISURATO (riscritto da R103) |
| `ABTG_CostToCost` | 772362 | GBPCAD | — | **0,25%** | **41,5%** a 1% → **10,4%** a 0,25% | 100.000 € · normalizzato a 1,0% · **OHLC** · 6,5 anni | **382** | 🟢 PIENO | ~4,6 op/mese ⇒ **~0,212 op/g** | `R103_REFERTO_FINALE.md` pos. 25 (🔴 **−14.978 · PF 0,92 · DD 41,5%**) — era 6,18% in R40/R41 | ✅ MISURATO — 🔴 **il DD promesso più alto di tutta la flotta anche dopo la riduzione** |
| `ABTG_EasyTrend` | 772422 | GBPUSD | — | **0,5%** | **15,8%** a 1% → **7,9%** a 0,5% | 100.000 € · normalizzato a 1,0% · **OHLC** · 6,5 anni | **254** | 🟢 PIENO | ~2,9 op/mese ⇒ **~0,134 op/g** | `R103_REFERTO_FINALE.md` pos. 9 (PF 1,06) — era 4,58% in R48; famiglia **BOCCIATA in portafoglio** (R49), porta 100k chiusa | ✅ MISURATO (riscritto da R103) |
| `ABTG_EasyTrend` | 772421 | CHFJPY | — | **0,3%** | **21,8%** a 1% → **6,5%** a 0,3% | 100.000 € · normalizzato a 1,0% · **OHLC** · 6,5 anni | **265** | 🟢 PIENO | ~3,8 op/mese ⇒ **~0,175 op/g** | `R103_REFERTO_FINALE.md` pos. 8 (PF **1,07** · DD **21,8%** · 4/7 anni negativi) — era 6,27% in R48 | ✅ MISURATO |
| `ABTG_GapContinuation` | 774101 | 225JPY | M1 | ⚠️ **n/d nel `.chr`** (deploy dichiarato 1,0%) | **11,59%** | **100.000 €** · **1,0%** · **tick** · OOS 2025.06.10→2026.06.30 | **70** chiusure (~47 giornate) | 🟠 SOSPESO | ~3,7 op/mese ⇒ **~0,17 op/g** | `REFERTO_ROUND65_GAPCONTINUATION.md` · `REFERTO_ROUND66_GAP_ALTOPIANO.md` | ✅ MISURATO ⚠️ **tre avvertenze scritte nel contratto**: lo short perde (−2.182), le perdite arrivano in GRUPPO (Z −4,03, 6 di fila), la cella è un **PICCO non un altopiano**. E il **rischio vivo non è leggibile dal `.chr`** |

### 4d. 🌩️ Le sedie nate DOPO l'ultima foto `.chr` del 25/08

| EA | Magic | Sym | TF | Rischio VIVO | **DD PROMESSO** | Deposito/rischio del backtest | `n` | MERITO | **Freq. promessa** | Fonte | STATO |
|---|---:|---|---|---:|---|---|---:|---|---|---|---|
| `ABTG_Nasdaq_Apertura_US` (**GATED SHORT**) | **770250** | NASUSD | M15 | **0,35%** | **4,54%** a 0,65% → **~2,4%** a 0,35% · pegg. giornata −0,72% → ~−0,4% | [deposito **NON DICHIARATO**] · **0,65%** · **tick BCM** · 21 mesi (solo TORO) | **104** | 🟠 SOSPESO (104 < 150, dichiarato nel contratto) | ~5 op/mese ⇒ **~0,23 op/g** (meno nella calma) | `report/CONTRATTO_GATEDSHORT_770250.md` · `risultati_archivio/REFERTO_SHORTGATE_2026-08-30.md` | ✅ **MISURATO** — 🔴 riserva dichiarata: **il verdetto ORSO è OHLC, non tick** (i tick BCM partono dal 2024.09: nessun orso). ⚠️ Il contratto dice «conto PICCOLO ~5k SEPARATO dal 50503392»: **su quale terminale giri davvero va confermato** (§5) |
| `ABTG_PostNews` (ECB) | **771201** | EURJPY | M5 | [**n/d**: assente dal censimento `.chr` del 25/08] | 🔴 **NESSUNO** | — | — | — | — | L'unica misura agli atti su questo motore/simbolo è `REGISTRO_TEST.md` P1: **«Profit 0.00, Trades 0» in tutti e 4 i CSV**, poi **RITIRATA** (il calendario non veniva letto). Sedia dichiarata VIVA in `backtest_pipeline/righe/RIGA_POSTNEWS_ECBFOMC_VERIFICA_DA_MANDARE.md` (04/09) | 🔴 **NON MISURATO** — nessun round ha mai prodotto un DD per questa cella |
| `ABTG_PostNews` (FOMC) | **771202** | EURUSD | M5 | [**n/d**] | 🔴 **NESSUNO** | — | — | — | — | idem sopra | 🔴 **NON MISURATO** |
| `ABTG_PostNews` (NFP/Unemployment) | **771203** | USDJPY | M5 | **1,30%/evento** (= 0,65% per ordine × 2 pendenti) — `ABTG_PostNews_NFP_USDJPY_LIVE_2026-09-04.set` | 🔴 **NESSUNO** | — | — | — | — | Il **PASSO 0** (`prove/POSTNEWS_NFP_00_conta.txt`, riga `RIGA_POSTNEWS_NFP_DA_MANDARE.md`) **non ha prodotto nessun CSV in archivio**. Il preset è dichiarato **«di sola osservazione»** (commit `2019ca8`, 04/09). Il track record 2009-2017 della slide è **[DICHIARATO]**, pips grezzi senza costi: **non è una fonte** | 🔴 **NON MISURATO** — 🔵 ha però già operato in forward (+37,36 il 04/09, `report/giornata_2026-09-04.md`) |
| `BREAKOUT_EA_JPY_v3` | **n/d** (nessun input magic leggibile) | USDJPY | — | **n/d** | 🔴 **NESSUNO** | — | — | — | — | Famiglia **SCARTATA pre-progetto**: paniere 7 cross JPY 2022-24 = **−20.853 €, PF 0,67-0,95 su TUTTE, DD 30-48%** (`docs/Portafoglio_Strategie.md` §Breakout JPY). Della **v3** non esiste alcun referto | 🔴 **NON MISURATO** — presente in **tutti e sette** i censimenti `.chr`, mai spenta. ⚠️ Decisione «A su JPY» del 21/08: `report/FIRMA_2026-08-21_DUE_SEDIE.md` |

### 4e. 🪦 FUORI CAMPO — righe che l'inventario si portava dietro per inerzia

| EA | Magic | Sym | perché NON è una sedia | fonte |
|---|---:|---|---|---|
| `Gold_Ichimoku_TK_ATR_EA` | 250604 | XAUUSD | 🪦 **SEDIA FANTASMA**: rimossa dal campo da Claudio a giugno. Il censimento la contava viva per un **`.chr` residuo su disco**. Prova indipendente: l'EA firma `TK long`/`TK short` e quelle stringhe compaiono **ZERO volte in 1.281 righe di statement**; i 2 trade di giugno attribuiti portano la firma `IchiCross long/short` = **un altro EA con lo stesso magic di default**. E il motore era già bocciato dalla corsia rischio (DD 21,52% a 0,5%) | `report/DIAGNOSI_SEDIE_MUTE_2026-09-05.md` §2 · `ERRATA_R103_ICHIMOKU_2026-08-25.md` |
| `ABTG_Nasdaq_Apertura_US` (breakout) | 770201 | NASUSD | ⛔ **SPENTA dal 18/08 09:41** (FIRMA 5 «spegnile tutte e tre»): assente dai censimenti del 18/08 09:41 e 19/08 ×3. Non aveva mai avuto contratto (tick reali 31/07: PF 0,82 · DD 17% · SCARTATO; walk-forward 05/08: **19/20 celle OOS negative**) | `report/CONTRATTI_SEDIE.md` §correzione 21/08 |
| `ABTG_PTE` | 771323 | USDJPY | 🔴 **SPENTA 24/08** (firma «A+b», R103) | `report/FIRMA_REVISIONE_FLOTTA_2026-08-24.md` |
| `ABTG_SuperWave` | 770532 | GBPUSD | 🔴 **SPENTA 24/08** | idem |
| `ABTG_CostToCost` | 772363 | XAGUSD | 🔴 **SPENTA 24/08** | idem |
| `ABTG_EasyTrend` | 772423 | AUDJPY | 🔴 **SPENTA 24/08** | idem |
| `ABTG_SupRev_DOW_H4_Ottimizzato` | 970914 | U30USD | Contratto scritto (4,0%) ma **promozione REVOCATA** (revalidation pulita: PFmed reale **0,79**, illusione OHLC). **Assente dal censimento `.chr` del 25/08** | `REGISTRO_TEST.md` · `CLASSIFICHE.md` §Scartati |
| `ABTG_SupRev_DAX_H1_Ottimizzato` | — | D30EUR | 🔴 spenta l'11/08 con delibera di Claudio | `REFERTO_FUORILISTA.md` |
| `ABTG_Guardian` 779001/779002 · `ABTG_TradeExporter` ×2 · `ABTG_SpreadLogger` · `ABTG_SlippageLogger` | — | — | ⚙️ **utility: non tradano, non hanno contratto** | — |

---

## 5. 🔴 I BUCHI DEL PERIMETRO — dichiarati, non tappati a mente

1. **Non esiste una foto `.chr` più recente del 25/08.** Da allora sono
   successe cose che il censimento automatico non ha mai visto: il deploy
   della GatedShort (30/08), le tre PostNews, il deploy sul **conto reale**
   (06/09), il riavvio del terminale piccolo trovato **CHIUSO** nella notte
   del 05-06/09 (`HANDOFF.md`) — dopo il quale **non è stato verificato che
   tutti i grafici/EA fossero ancora attaccati**.
2. **Le sedie ☠️ «morte in osservazione»** (`ABTG_DAX_Live5m`,
   `DAX_Live5m_v2`, `Nasdaq_Live5m`, `ABTG_ORB` nativo, `ABTG_ORB_Fibo`) sono
   date per **accese** in `report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`
   (righe 9-13) ma **non compaiono nel censimento `.chr` del 25/08**. Le due
   fonti si contraddicono. Nessuna di loro ha contratto. **Non le ho contate
   fra le sedie**: se sono accese, sono altre 5 righe SENZA CONTRATTO.
3. **`ABTG_Nasdaq_Apertura_US_Ottimizzato`** è elencato come «sedia apertura
   viva» nell'audit del 03/09 (riga 6) **senza magic**, e non è nel censimento
   `.chr`. Non ho inventato un magic: la riga non esiste in questa tabella.
4. **Il conto della GatedShort 770250**: il contratto dice «conto PICCOLO ~5k,
   SEPARATO dal 50503392». Sul VPS i conti da ~5k oggi sono **due** (il demo
   piccolo con bilancio 5.103,62 e il reale 10105439 con bilancio 5.000 +
   credito 2.500). **Non è deducibile dai documenti su quale dei due giri.**

---

## 6. 🧮 SINTESI

**Sedie censite: 47 righe-sedia su 3 conti = 41 SEDIE UNICHE** per
EA/simbolo/magic. Le righe sono piu' delle sedie perche' **DAX 770101** e
**ORB 770611** girano su **tutti e tre i conti** e **Dow 770202** e **MaxMin
770411** su due, a taglie diverse: per la corsia RISCHIO **ogni conto e' un
contratto diverso** (stesso motore, DD in % uguale, ma muri e taglie diversi).

| STATO | righe | quali |
|---|---:|---|
| ✅ **MISURATO** (DD promesso + fonte + `n`) | **40** | tutte le §2, §3, §4a-d salvo le sette sotto |
| 🟠 **DA RIPRODURRE** | **3** | `771322` PTE GBPUSD (contratto conteso 2,64% vs 13-17%) · `970912` SupRev DAX H4 (PFmed 1,05 + presenza contesa) · `770924` STREV Nikkei H4 (deposito ignoto + non in lista Expert il 02/09) |
| 🔴 **NON MISURATO** | **4** | `771201` PostNews ECB · `771202` PostNews FOMC · `771203` PostNews NFP · `BREAKOUT_EA_JPY_v3` |

**Merito** (regola di casa: sotto 150 operazioni il MERITO si sospende, il
RISCHIO no): 🟢 **PIENO su 15 righe** · 🟠 **SOSPESO su 28** · 4 righe non
hanno nemmeno un `n`.
👉 **Su quasi due terzi delle righe misurate il giudizio di MERITO e'
formalmente sospeso**: oggi la corsia RISCHIO e' quasi l'unica che parla, ed e'
esattamente il motivo per cui questo file doveva esistere.

**Il rischio del backtest non e' omogeneo, ed e' la ragione per cui quella
colonna esiste**: le promesse nascono a **1,0%** (quasi tutte), a **0,65%**
(ORB R119, GatedShort) o **normalizzate a 1,0%** (R103); i depositi a
**10.000 €** (walk-forward, R83, R119) o **100.000 €** (R16, R23, R103), e in
**8 righe il deposito non e' dichiarato da nessuna parte**.
**Confrontare due DD senza questa colonna e' un errore di misura.**

### 🚨 I tre numeri che un occhio prop deve vedere subito

| sedia | DD promesso alla **taglia viva** | conto | perché brucia |
|---|---:|---|---|
| `772362` CostToCost GBPCAD | **~10,4%** | piccolo | da solo **è tutto il muro FTMO del 10%**, e il motore ha PF 0,92 su 6,5 anni |
| `971501` EMA200_Ott XAUUSD | **~11,5%** | piccolo | **oltre il muro**, e il DD a 1% è 45,91% (10,4x il promesso originale) |
| `770101` DAX Apertura EU | **~6,89%** a 0,65% (10,60% a 1%) | **REALE** + 100k + piccolo | è la sedia **più veloce sul conto reale** (~0,97 op/g) e il suo DD promesso da solo mangia i due terzi del muro |

---

## 7. 📋 MISURE DA CHIEDERE A CLAUDIO — ordinate per gravità del buco

> Nessuna di queste è eseguibile da qui: MT5 sta sul PC di backtest e sul VPS.
> Sono richieste, non azioni. **Niente in forward viene toccato.**

### 🥇 M-C1 — **Una foto `.chr` NUOVA di tutti e TRE i terminali** (costo: ~10 min, rischio zero)
È il buco che rende approssimative **tutte** le righe di questo file.
L'ultima è del 25/08 e da allora sono cambiati un conto (il reale), tre sedie
nuove e c'è stato un riavvio del terminale piccolo con grafici da riverificare.
Serve `censimento_rischio.ps1` su:
- **piccolo 50503392** — `C:\Program Files\BCM Markets MT5 Terminal` (**senza** `-V3`);
- **100k 50504263** — installazione **`-V3`**;
- **reale 10105439** — `C:\BCM_Reale`.
Riconoscimento della finestra dal fatto stampato, non a occhio:
`Get-Process terminal64 | select Id, MainWindowTitle, Path` (regola dei
terminali multipli, `CLAUDE.md`).
**Chiude**: buchi 1, 2, 3, 4 di §5 + il rischio vivo di `774101` (non leggibile) + la conferma di `770924`.

### 🥈 M-C2 — **Il PASSO 0 della PostNews NFP `771203`** (la sedia opera già, e non ha contratto)
La riga esiste ed è pinnata (`backtest_pipeline/righe/RIGA_POSTNEWS_NFP_DA_MANDARE.md`),
non è mai stata lanciata, e il preset stesso dichiara che **non può promuovere
niente** (12 eventi/anno × 2 gambe non arrivano a 150 op). **Ma può dare il
DD**, che è l'unica cosa che serve alla corsia RISCHIO. Oggi quella sedia
rischia **1,30% per evento** con zero numeri sotto.

### 🥉 M-C3 — **Il DD delle due PostNews ECB `771201` / FOMC `771202`**
Girano da settimane, l'unica misura agli atti («Trades 0») è stata **ritirata**
perché il calendario non veniva letto. Dopo il fix v1.10 la riga di verifica
esiste (`RIGA_POSTNEWS_ECBFOMC_VERIFICA_DA_MANDARE.md`) ma **dà solo un
binario «calendario letto sì/no», nessun numero economico**: dopo quella,
serve una corsa che produca `Equity DD %` e `Trades`.

### 4️⃣ M-C4 — **Riprodurre `771322` PTE GBPUSD per sciogliere il contratto conteso**
Tre banchi, tre risposte: R23 (tick, 12,5 mesi) **DD 2,64%** · R78 (OHLC,
13 anni) **DD 17,68% PF 0,972** · R103 (OHLC, 6,5 anni) **DD 13,1% PF 0,96**.
Finché non si sceglie **quale è il DD promesso**, la corsia RISCHIO su questa
sedia può scattare a 2,6% o a 17,7%: cioè non scatta mai in modo prevedibile.
⚠️ Il round lungo **a tick reali non si può fare** (i tick BCM partono dal
2024.07.05): la scelta è **di firma**, non di misura.

### 5️⃣ M-C5 — **Il deposito dei round R99 / R100 / R29-R31 / R36-R48**
Otto righe di questo censimento hanno `[deposito NON DICHIARATO]`. Il DD% non
cambia, ma **il peggior-giornata in euro e il confronto col forward sì**.
Si legge dagli `.ini` o dai driver di quei round, non dal referto.

### 6️⃣ M-C6 — **Scrivere un contratto o dichiarare lo stato di `BREAKOUT_EA_JPY_v3`**
È l'unica sedia della flotta di cui **non si legge nemmeno il magic**. Presente
in tutti e sette i censimenti, mai spenta, famiglia con **DD misurati 30-48%**
agli atti. Per la corsia RISCHIO è **fuori metro**: qualunque DD faccia, non
viola niente, perché nessuno ha promesso niente.

---

_Fonti primarie di questo file, tutte nel branch `lavoro`:
`report/CONTRATTI_SEDIE.md` · `report/FIRME_2026-08-18.md` ·
`backtest_pipeline/risultati_archivio/censimento_rischio_2026-08-25_0731.txt` ·
`R99_REFERTO.md` · `R100_REFERTO.md` · `R103_REFERTO_FINALE.md` ·
`R103_REFERTO_BLOCCO1_INDICI.md` · `REFERTO_PORTAFOGLIO_R16.md` ·
`REFERTO_RITARDO_R119_PRIMO_GIRO.md` + `ritardo_r119_csv/` ·
`r83_csv/` · `report/CONTRATTO_GATEDSHORT_770250.md` ·
`report/DIAGNOSI_SEDIE_MUTE_2026-09-05.md` ·
`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` · `HANDOFF.md`.
**Se un referto e questa tabella divergono, comanda il referto.**_
