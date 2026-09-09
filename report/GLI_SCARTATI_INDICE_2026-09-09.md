# 🗺️ GLI SCARTATI — LA PORTA D'INGRESSO (09/09/2026)

Richiesta di Claudio, testuale: *"IO VOGLIO CHE VENGA RICONTROLLATO TUTTI GLI
SCARTATI E VOGLIO LA TABELLA CON I PROFIT FACTOR DI TUTTI E LE SOLUZIONI PER
MIGLIORARLI... HO BISOGNO DI SAPERE QUALI E QUANTI SONO."*

Quattro agenti in parallelo, **3.243 righe di referto**, quattro strade
indipendenti. Questo file dice **quale aprire per quale domanda**.

⚠️ **Nota d'archivio**: `CENSIMENTO_SCARTATI_PROSA` e' entrato nel commit
`0d37e0a`, il cui messaggio parla d'altro (i due agenti hanno consegnato a
pochi minuti di distanza e `git add -A` l'ha raccolto). Il file e' integro e
tracciato; e' il **messaggio di commit** a non descriverlo. Scritto qui perche'
un archivio che mente sulla propria storia e' peggio di un archivio incompleto.

---

## 📂 I QUATTRO REFERTI

| Se vuoi sapere... | Apri | Righe |
|---|---|---|
| **Quali e quanti sono, e da quale cancello sono morti** | `CENSIMENTO_SCARTATI_PROSA_2026-09-09.md` | 535 |
| **Il PF misurato di tutti, ordinato: chi e' vicino alla soglia** | `CENSIMENTO_PF_MISURATI_2026-09-09.md` | 1.970 |
| **Se abbiamo davvero provato trailing / BE / parziali** | `AUDIT_USCITE_2026-09-09.md` | 306 |
| **Perche' da 24 giorni non passa piu' nessuno** | `PERCHE_NON_PASSANO_2026-09-09.md` | 432 |

Dati grezzi rimacinabili: `backtest_pipeline/risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv`
(1.558 righe, 37 colonne) + gli script `censimento_pf.py` e `censimento_pf_referto.py`.

---

## 🔢 QUANTI SONO — i numeri, in un posto solo

| | |
|---|---|
| **Verdetti di scarto censiti** | **207** (119 nostri con `.mq5` · 88 esterni mai portati in MQL5) |
| **CSV di risultati macinati** | **2.069** su 148 round |
| **Righe motore x simbolo x round** | 1.558 (430 con OOS) |
| 🟢 **Candidati "vicini alla soglia"** (PF OOS mediano >= 0,90 **e** n >= 100) | **127** |
| **Giorni dall'ultima promozione piena** | **24** (16/08/2026, `GapContinuation` 225JPY) |
| **Round numerati da allora, con zero promozioni** | **48** (R67 -> R119) |

### Da cosa muoiono (prosa, 207 righe)
`EDGE/PF` **80 (38,6%)** · `ALTRO` **47 (22,7%)** · `RISCHIO/DD` 33 (15,9%) ·
`FREQUENZA` 17 (8,2%) · `BACO/NON GIRATA` 13 (6,3%) · `NON MISURABILE` 11 (5,3%) ·
costo/muro/contraddizione 6.

🔴 **`ALTRO` seconda colonna** = 47 candidati **mai arrivati a un backtest**
perche' rotti o vietati in partenza (griglia, no-stop, doppione, strumento non
quotato, look-ahead). E' il cancello **piu' economico** che abbiamo: costa una
lettura, non un round.

---

## 🏆 LE TRE COSE CHE VALGONO PIU' DI TUTTE LE ALTRE

### 1. 🔧 La leva mai tirata: **l'USCITA vale 0,61 punti di PF, ed e' misurato**
`R46`, stesso ingresso, **6 strutture d'uscita**, tick reali, **fuori campione**:
DAX da **PF 0,88 / DD 22,50%** (TP 3R secco) a **PF 1,49 / DD 6,27%** (trailing
PREVBAR senza parziale). Dow 1,01 -> 1,27.
🚨 **Sulla famiglia Supertrend — le sedie in campo su oro, argento, Nikkei,
NAS H1, DAX H4 — la gestione dell'uscita non e' MAI stata messa ad asse**:
`InpTrailOnST` (15 EA), `InpExitOnFlip` (14 EA), `InpFirstFraction` (14 EA)
hanno **zero** occorrenze `||Y` in tutto il repo. Girano al default.
🛠️ **E `backtest_pipeline/scan_gestione.ps1` esiste, 48 passate, MAI LANCIATO.**

### 2. 🚚 Il motore validato e non schierato: **`ABTG_EMA200` sul Dow**
**Due indagini indipendenti, partite da fonti diverse, sono arrivate allo
stesso nome.** PF OOS mediano **1,52 su n=517** · lato short **1,89 su n=302 con
DD 2,66%** · **1,55 op/giorno** (il piu' veloce della flotta, da solo
supererebbe il pavimento di famiglia) · **30/30 PASS a walk-forward tick (R32)**.
E' **l'UNICA delle 41 sedie vive** che passa i cancelli di oggi alla lettera.
Sta sul demo piccolo. E' in calendario per la **fase 3** della migrazione
firmata il 02/09, dietro un cancello di fase non ancora verde.

### 3. 📏 Il cancello fuori portata: **i 150 per finestra**
300 operazioni alla velocita' **mediana** delle nostre sedie (**0,140 op/g**) =
**8,3 anni**. Tick BCM disponibili sugli indici: **~500 giorni**.
👉 **Nessuna sedia singola puo' arrivarci, con nessun motore.** Non e' che i
motori siano peggiorati: e' che un cancello e' fuori dalla portata dei dati.
🔴 **Decisione di Claudio, da prendere PRIMA dei prossimi numeri**: applicare i
150 alla **FAMIGLIA** (come gia' fatto il 07/09 con la frequenza), oppure
motori piu' veloci, oppure piu' simboli.

---

## 💎 I RECUPERABILI — la lista per la caccia sul web

### 🟢 CLASSE A1 — fermi da un numero **MANCANTE**, non da un numero brutto
| Candidato | PF | n | DD | Perche' e' fermo |
|---|---|---|---|---|
| **NY Retest slope 75** | 1,374 / 1,427 | 114-115 | 3,7-4,7% | sotto i 150 |
| **SupRev DOW H1** (970916) | 1,20 | **273** | — | unico merito PIENO della corsia |
| **RELATIVO NASUSD** | 1,189 | 87 / 154 | rischio mai rosso | campione |
| **DaxReEntry LONG** | sfiora | — | — | — |

### 🟡 CLASSE B — bocciati per **sola frequenza**
**1 solo su 7** ha un PF: `SuperWave DAX H4`, **1,28 a tick**.
⚠️ Gli altri **6 non hanno NESSUN PF misurato**: non sono recuperabili, sono
**non misurati** — ed e' una differenza che cambia cosa si fa dopo.

### 🟠 CLASSE C — bocciati per rischio ma con PF > 1,20
🈳 **VUOTA. Zero candidati.** Perche' **13 su 13** dei bocciati per rischio
hanno PF <= 1,19: erano **bocciature per edge travestite**.

### ⚫ MORTI — 14 nominati + ~10 famiglie chiuse
Elencati nel censimento della prosa. **Dirlo serve a non farci perdere tempo.**

---

## ⚔️ LE DIECI CONTRADDIZIONI — da chiudere, non da nascondere

🔴 **C1, la piu' pesante — `ABTG_FvgRetest`**: `HANDOFF.md` r.610-612 (29/08)
dice **"DD 42,9%, bocciato per rischio"**; tre file recenti (03/09, 07/09,
08/09) dicono tutti **"zero CSV, zero referto, MAI MISURATO"**. Verificato: in
`risultati_archivio/` **non esiste nessuna cartella FVG**. L'indizio materiale
sta coi tre recenti — **ma il 42,9% e' in HANDOFF, il file che si legge per
ripartire, e nessuno l'ha mai ritirato.**
👉 **Finche' non si chiude, quel DD non si puo' citare in nessuna direzione.**

Le altre nove nel censimento della prosa. Le tre che pesano dopo C1:
- **C2** `SupRev`: 2,77/1,79 e' la **cella migliore**, 0,79/0,96 il **PF
  mediano** — si spiega, ma il registro dice ancora "CONFERMATA" e **non porta
  la revoca**;
- **C3** `ORB 770611`: DD **9,92% contro 10,00%** — decide se la sedia sul
  conto REALE e' dentro il muro o **al** muro;
- **C8** il certificato di morte di `M0PB` poggia su un criterio aggiunto
  **DOPO** i numeri. E' la cosa che in casa non si fa.

### 👥 I doppioni
15 motori con verdetti diversi. La famiglia **SupRev** ha **14 righe con
verdetti opposti** (vivi su oro/NAS H1/DAX H4, morti su M5/M15, **due
promozioni revocate**): il criterio che li separa e' **TF + SIMBOLO, non il
motore**. `ABTG_Relativo` ha **due verdetti opposti sulla stessa identica
cella** (D30EUR bocciata per rischio, NASUSD merito sospeso col rischio mai
rosso).

---

## 🕳️ I BUCHI, dichiarati
- Su 119 righe nostre, solo **49 hanno un PF numerico** e **54 un DD**. In
  sezione B la maggioranza **non e' mai arrivata a un backtest**: non hanno
  numeri **per costruzione**. Scritto `[NON MISURATO]`, non inventato.
- **230 righe** del censimento CSV hanno TF `[NON MISURATO]`, **108** hanno il
  TF ottimizzato, **18** (R113/R114) non hanno il simbolo — **non dedotto**,
  sarebbe inferenza.
- I CSV **non portano** la data della finestra, ne' tick-vs-OHLC, ne' il
  verdetto: quel pezzo sta nei referti.
- ⚠️ **La cima della tabella ordinata per PF non sono i vincitori, sono i
  campioni sottili**: in testa `SupertrendInvert XAGUSD` con **PF 1357 su DUE
  operazioni**. Marcato in rosso nel referto.
- 🔎 **874 CSV su 1.960 hanno passate con esito IDENTICO** = manopole **inerti**
  nella griglia (peggiore: 160 passate, **20 esiti distinti**). Mediana e picco
  calcolati sugli **esiti distinti**. 👉 Conseguenza: **a volte "l'abbiamo
  provato" voleva dire "l'abbiamo girato senza che mordesse"** — c'e' spazio di
  ricerca che credevamo consumato e non lo e'.

---

## 🎯 LE MOSSE PROPOSTE, in ordine di valore su costo
1. 🥇 **Lanciare `scan_gestione.ps1`** sulle Supertrend in campo — gia' scritto,
   48 passate, mai lanciato, e la leva vale 0,61 punti di PF.
2. 🥈 **I 4 candidati A1 in demo** sul piccolo **50503392** — zero ore di banco,
   **+1,08 op/giorno**: l'unico modo di attaccare il muro dei 150 **senza
   abbassarlo**.
3. 🥉 **Rimisura `SupRev DOW H1`** a 0,65% con split — minuti di banco.
4. ⚠️ **Allargare `EMA200` ad altri simboli** — **solo dopo** aver acceso il
   tetto per cluster al **3,0%**, firmato il 07/09 e **ancora spento**.
5. 🧹 **Chiudere C1** (il DD 42,9% fantasma in `HANDOFF.md`): costa una riga, e
   finche' resta li' inquina il file che si legge per ripartire.
