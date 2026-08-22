# 🐣📉 CENSIMENTO FREQUENZA DELLA FLOTTA — 22/08/2026

> Mandato: `CODA_PROSSIMA_SESSIONE.md` §6 ("CENSIMENTO FREQUENZA DELLA FLOTTA",
> richiesta di Claudio 22/08). Trovare **(a)** sedie a ZERO trade dal loro
> arrivo in flotta e **(b)** sedie con frequenza fuori scala rispetto al
> contratto in `report/CONTRATTI_SEDIE.md`.

---

## 📚 FONTI USATE (con data/ora, perché un censimento invecchia in ore — vedi `FIRMA_2026-08-21_DUE_SEDIE.md`)

| fonte | cosa dà | data/ora della foto |
|---|---|---|
| `report/CONTRATTI_SEDIE.md` | 44 sedie con "Op/mese promesse" | compilato 18/08/2026 (M11) |
| `backtest_pipeline/risultati_archivio/censimento_rischio_2026-08-19_1534.txt` | **il censimento dei `.chr` più recente in repo** (56 righe, nessuno più nuovo trovato — nessun file datato dopo il 19/08) | 19/08/2026 15:34 |
| `FLOTTA_ATTIVA.md` | mappa scritta a mano dai 52 screenshot | 02/08/2026, con patch puntuali fino al 19/08 |
| `data/statements/trades_auto.csv` (conto piccolo 50503392) | **1.206 righe**, `open_time` 2026.03.30 → 2026.08.21 | fix separazione conti del 22/08 (commit `4fa391f`) |
| `data/statements/trades_100k.csv` (conto 100k dry-run 50504263) | **11 righe**, `open_time` 2026.08.10 → 2026.08.21 (il dry-run è giovane) | idem |
| `report/FIRMA_2026-08-21_DUE_SEDIE.md`, `giornata_2026-08-19/20/21.md` | controllo incrociato sulle due sedie senza contratto | 21/08/2026 |

🔴 **Nessun censimento `.chr` più recente del 19/08 15:34 esiste in repo.** Tre
giorni (20-22/08) di eventuale drift della flotta reale **non sono coperti**:
questo censimento fotografa lo stato del 19/08 incrociato con gli statement
fino al 21/08 sera.

---

## ⚙️ METODOLOGIA (leggere prima dei numeri)

1. **Universo delle sedie**: le **44 sedie di `CONTRATTI_SEDIE.md`** (40 con
   contratto pieno, 2 parziale, 2 senza contratto), verificate ancora
   presenti nel censimento `.chr` del 19/08 15:34. Sono escluse le utility
   (`ABTG_Guardian` 779001, `ABTG_TradeExporter` NZDCAD/EURUSD, che non
   tradano). **`BREAKOUT_EA_JPY_v3`** non ha un magic leggibile né nel
   censimento né altrove: è trattata a parte, narrativamente (vedi §4).
2. **Filtro dei trade**: per ogni sedia, righe dei due CSV filtrate per
   **(magic, simbolo) insieme**, non magic da solo — perché **un magic può
   essere stato riassegnato ad un altro simbolo nel tempo** (trovato in
   questo censimento, vedi §5 "la collisione 770901"). Filtrare solo per
   magic avrebbe attribuito trade alla sedia sbagliata.
3. **Conto 100k**: trattato **a parte**, non sommato al conto piccolo. Il
   100k (dry-run Guardian, `report/DEPLOY_GUARDIANO_100K.md`) rispecchia
   **lo stesso segnale** di 5 sedie del piccolo a taglia ridotta
   (770101, 770202, 770411, 770611, e nominalmente 770901): sommarlo avrebbe
   contato due volte lo stesso ingresso. È riportato come colonna di
   riscontro (`n 100k`), non nel conteggio principale.
4. **Finestra usata**: `open_time` del trade **più vecchio** trovato per
   quella coppia (magic, simbolo) fino a **2026.08.21** (l'ultima data
   coperta dallo statement). Questa è l'approssimazione di "da quando è
   accesa" richiesta dal mandato — **non è la data reale di accensione**,
   che non è documentata sedia per sedia. 🔴 **Lo statement copre da
   2026.03.30**: una sedia a zero potrebbe essere stata accesa DOPO
   quell'inizio, quindi **"zero nello statement" non è "zero da sempre"**.
5. **Trovato scavando i dati, e riportato perché cambia la lettura**: quasi
   **nessuna sedia ha il suo primo trade prima del 20/07/2026**, anche se lo
   statement copre da fine marzo. Le famiglie di agosto (GapFill, PunteLarry,
   CostToCost, EasyTrend, BreakingBand, EMA200/SupRev "Ottimizzato") hanno
   **tutte** il primo trade fra il 27/07 e il 20/08: sono state messe in
   campo con questi magic **molto più di recente** di quanto la finestra
   nominale del contratto (12-14 mesi di backtest OOS) potrebbe far pensare.
   👉 **Quasi tutte le finestre reali sono sotto le 4 settimane**: i numeri
   di frequenza che seguono sono **provvisori per costruzione**, non per
   pigrizia di misura.
6. **Unità**: dove `CONTRATTI_SEDIE.md` distingue chiusure da posizioni (PTE,
   SuperWave, MaxMinNotte — un ingresso può generare 2-3 righe per i parziali),
   il "promesso" qui sotto è stato **ricalcolato in chiusure** per essere
   comparabile riga-a-riga col conteggio grezzo del CSV (che è per
   costruzione un conteggio di chiusure): `MaxMinNotte oro` 82 chiusure/9 mesi
   = **9,11/mese** (non 3,7 posizioni/mese) e `SuperWave U30USD H2` 88
   chiusure/12,5 mesi = **7,04/mese** (non 4 posizioni/mese). Le altre righe
   già erano espresse in chiusure nel contratto originale.
7. **Soglia di "campione insufficiente"**: se la finestra `‹10 giorni` o il
   conteggio `‹4 trade`, **non si calcola un rapporto mensile** (estrapolare
   1-2 trade su 1-2 giorni a "operazioni/mese" è rumore puro, non misura).
   Marcata **🔵 INSUFF.** Per le righe misurabili: scarto `<0,50×` promesso →
   🔴, `>2,0×` → 🟡, altrimenti ✅ (banda larga apposta, il campione è comunque
   piccolo dappertutto).

---

## 🟢 TABELLA A — 40 SEDIE A CONTRATTO PIENO

| Sedia (EA · simbolo · magic) | Trade (piccolo) | n 100k | Prima op. | Ultima op. | Finestra (gg) | Freq. reale/mese | Freq. promessa/mese | Scarto |
|---|---:|---:|---|---|---:|---:|---:|---|
| DAX_Apertura_EU · D30EUR · 770101 | 26 | 3 | 2026-07-20 | 2026-08-21 | 31 | 25,5 | 21,0 | ✅ in linea |
| Dow_Apertura_US · U30USD · 770202 | 3 | 2 | 2026-08-07 | 2026-08-13 | 13 | 7,0 | 10,0 | 🔵 INSUFF (n<4) |
| ORB_Ottimizzato · U30USD · 770611 | 4 | 4 | 2026-08-11 | 2026-08-21 | 9 | 13,5 | 9,4 | 🔵 INSUFF (finestra 9gg) |
| MaxMinNotte_DAX_Short_Ottimizzato · D30EUR · 770411 | 2 | 2 | 2026-08-18 | 2026-08-20 | 2 | — | 1,7 | 🔵 INSUFF (finestra 2gg) |
| SupertrendReversal (Nikkei H2) · 225JPY · 770901 | **0** | 0 | — | — | — | — | 4,0 | ⚫ **ZERO** |
| MaxMinNotte (oro notte) · XAUUSD · 770402 | 2 | 0 | 2026-08-11 | 2026-08-13 | 9 | 6,8 | 9,11 | 🔵 INSUFF |
| PTE · U30USD · 771321 | **0** | 0 | — | — | — | — | 3,2 | ⚫ **ZERO** |
| PTE (storica) · GBPUSD · 771322 | 1 | 0 | 2026-08-14 | 2026-08-14 | 6 | 5,1 | 3,9 | 🔵 INSUFF (n=1) |
| PTE · USDJPY · 771323 | 1 | 0 | 2026-08-19 | 2026-08-19 | 1 | — | 2,8 | 🔵 INSUFF (n=1) |
| PTE (candidata R78) · GBPUSD · 771332 | **0** | 0 | — | — | — | — | 3,0 | ⚫ **ZERO** |
| SuperWave (H2) · U30USD · 770531 | 6 | 0 | 2026-08-19 | 2026-08-20 | 1 | — | 7,04 | 🔵 INSUFF (finestra 1gg, burst) |
| SuperWave (H2) · GBPUSD · 770532 | **0** | 0 | — | — | — | — | 5,0 | ⚫ **ZERO** |
| EMA200 · U30USD · 771531 | 8 | 0 | 2026-08-14 | 2026-08-19 | 6 | 40,6 | 34,0 | 🔵 INSUFF (finestra 6gg, ma coerente) |
| EMA200_Ottimizzato · XAUUSD · 971501 | 2 | 0 | 2026-08-05 | 2026-08-05 | 15 | 4,1 | 6,6 | 🔵 INSUFF (n=2) |
| SupRev_DAX_H4_Ottimizzato · D30EUR · 970912 | **0** | 0 | — | — | — | — | 4,0 | ⚫ **ZERO** |
| SupRev_DOW_H4_Ottimizzato (revocato) · U30USD · 970914 | **0** | 0 | — | — | — | — | 3,8 | ⚫ **ZERO** *(atteso: promozione già revocata)* |
| SupRev_NAS_H1_Ottimizzato · NASUSD · 970913 | 4 | 0 | 2026-07-30 | 2026-08-17 | 22 | 5,5 | 7,4 | ✅ in linea (0,75×) |
| SuperWave_DOW_H1_Ottimizzato · U30USD · 770511 | 8 | 0 | 2026-07-27 | 2026-08-17 | 24 | 10,1 | 10,8 | ✅ in linea (0,94×) |
| SupertrendReversal (Nikkei H4 FW) · 225JPY · 770924 | **0** | 0 | — | — | — | — | 1,0 | ⚫ **ZERO** *(bassa frequenza per natura)* |
| BreakingBand · GBPUSD · 772161 | 1 | 0 | 2026-08-20 | 2026-08-20 | 1 | — | 2,0 | 🔵 INSUFF (n=1) |
| BreakingBand · EURUSD · 772162 | **0** | 0 | — | — | — | — | 1,0 | ⚫ **ZERO** |
| BreakingBand · AUDUSD · 772163 | **0** | 0 | — | — | — | — | 0,8 | ⚫ **ZERO** |
| GapFill · AUDUSD · 772233 | **0** | 0 | — | — | — | — | 0,9 | ⚫ **ZERO** |
| GapFill · GBPUSD · 772231 | **0** | 0 | — | — | — | — | 0,6 | ⚫ **ZERO** |
| GapFill · EURUSD · 772232 | **0** | 0 | — | — | — | — | 0,7 | ⚫ **ZERO** |
| GapFill · U30USD · 772234 | **0** | 0 | — | — | — | — | 1,5 | ⚫ **ZERO** |
| GapFill · 225JPY · 772235 | **0** | 0 | — | — | — | — | 1,2 | ⚫ **ZERO** |
| PunteLarry · U30USD · 772341 | **0** | 0 | — | — | — | — | 2,9 | ⚫ **ZERO** |
| PunteLarry · EURAUD · 772342 | 1 | 0 | 2026-08-17 | 2026-08-17 | 3 | — | 2,5 | 🔵 INSUFF (n=1) |
| PunteLarry · XAUUSD · 772343 | 1 | 0 | 2026-08-19 | 2026-08-19 | 1 | — | 0,8 | 🔵 INSUFF (n=1) |
| PunteLarry · GBPJPY · 772344 | **0** | 0 | — | — | — | — | 1,5 | ⚫ **ZERO** |
| PunteLarry · GBPUSD · 772345 | 1 | 0 | 2026-08-18 | 2026-08-18 | 2 | — | 1,9 | 🔵 INSUFF (n=1) |
| PunteLarry · EURCAD · 772346 | 1 | 0 | 2026-08-19 | 2026-08-19 | 1 | — | 1,5 | 🔵 INSUFF (n=1) |
| CostToCost · EURJPY · 772361 | 2 | 0 | 2026-08-14 | 2026-08-17 | 6 | 10,1 | 4,7 | 🔵 INSUFF (n=2) |
| CostToCost · GBPCAD · 772362 | 2 | 0 | 2026-08-17 | 2026-08-19 | 3 | — | 4,6 | 🔵 INSUFF (n=2) |
| CostToCost · XAGUSD · 772363 | **0** | 0 | — | — | — | — | 3,0 | ⚫ **ZERO** |
| EasyTrend · GBPUSD · 772422 | 3 | 0 | 2026-08-17 | 2026-08-20 | 3 | — | 2,9 | 🔵 INSUFF (n=3) |
| EasyTrend · AUDJPY · 772423 | 2 | 0 | 2026-08-17 | 2026-08-18 | 3 | — | 3,9 | 🔵 INSUFF (n=2) |
| EasyTrend · CHFJPY · 772421 | 1 | 0 | 2026-08-18 | 2026-08-18 | 2 | — | 3,8 | 🔵 INSUFF (n=1) |
| GapContinuation · 225JPY · 774101 | 1 | 0 | 2026-08-19 | 2026-08-19 | 1 | — | 3,7 | 🔵 INSUFF (n=1, deploy 16/08: atteso ~0,6 in 5gg) |

**Sintesi Tabella A: 15 sedie su 40 (37,5%) a ZERO trade totali · 19 con
campione insufficiente per calcolare una frequenza · 3 "✅ in linea"
misurabili (DAX_Apertura_EU, SupRev_NAS_H1_Ottimizzato, SuperWave_DOW_H1_Ottimizzato).**

---

## 🟡 TABELLA B — CONTRATTO PARZIALE E SENZA CONTRATTO (4)

| Sedia | Trade (piccolo) | Prima op. | Ultima op. | Finestra | Freq. reale/mese | Freq. promessa | Scarto |
|---|---:|---|---|---:|---:|---|---|
| SupertrendReversal_Ottimizzato · XAUUSD · 970901 (parziale: DD mai quantificato) | **0** | — | — | — | — | n/d | ⚫ **ZERO** — nessun contratto di frequenza da confrontare |
| Gold_Ichimoku_TK_ATR_EA · XAUUSD · 250604 (parziale: validato su altro broker) | 2 | 2026-06-09 | **2026-06-19** | 72gg dal 1° trade | 0,8 | ~7,2 | 🔴 **63 giorni di silenzio** dall'ultimo trade al 21/08 — vedi §6 |
| Nasdaq_Apertura_US · NASUSD · 770201 (senza contratto) | 10 | 2026-07-20 | 2026-08-11 | attiva 22gg, poi spenta | 13,8 (nella finestra attiva) | n/d | — nessun contratto; **coerente con lo spegnimento 18/08** (nessun trade dopo l'11/08) |
| BREAKOUT_EA_JPY_v3 · USDJPY (senza contratto, **nessun magic assegnato**) | non isolabile | — | — | — | — | n/d | — **non misurabile**: vedi nota sotto |

**Nota su `BREAKOUT_EA_JPY_v3`**: nel censimento `.chr` del 19/08 il campo
magic risulta vuoto ("nessun input di rischio trovato"), quindi non esiste
una chiave per isolarlo nello statement. Sul simbolo USDJPY compaiono **5
righe a `magic=0` e `strategy` vuota** (tutte chiuse fra il 30/03 e l'8/05,
**prima** della finestra di interesse) e **1 riga `magic=771323`** (quella è
`ABTG_PTE`, non il breakout). Non si può né confermare né escludere che le 5
righe a magic 0 appartengano al breakout: **il dato non lo dice**. Resta
comunque agli atti che Claudio il 21/08 ha firmato **"SPEGNERLA"**
(`FIRMA_2026-08-21_DUE_SEDIE.md`); l'esecuzione (checklist di quel file) **non
risulta ancora confermata da un censimento successivo** — nessun censimento
`.chr` più recente del 19/08 è in repo.

---

## 🕰️ TABELLA C — SEDIE "FUORI PERIMETRO": la squadra storica di `FLOTTA_ATTIVA.md` non coperta da `CONTRATTI_SEDIE.md`

`CONTRATTI_SEDIE.md` **dichiara da solo** (nota di perimetro finale) che la
squadra validata di fine luglio — GoldenCross ×4, EMA200 ×5 (magic
771511-15), SupertrendReversal ×4 (magic 770921-925), SupertrendReversal_Multi
— **non è nel censimento del 18/08** e quindi non ha un contratto qui. Sono
comunque elencate nella tabella "🟢 SQUADRA VALIDATA" di `FLOTTA_ATTIVA.md`
(02/08) come attive. **Disallineamento dichiarato esplicitamente, come
richiesto dal mandato:**

| EA · simbolo · magic (da `FLOTTA_ATTIVA.md`) | Trade nello statement | Prima/ultima op. | Nota |
|---|---:|---|---|
| GoldenCross · USDCHF · 770331 | **0** | — | — |
| GoldenCross · USDCAD · 770332 | **0** | — | — |
| GoldenCross · NZDUSD · 770333 | **0** | — | — |
| GoldenCross_Ottimizzato · XAUUSD · 970301 | **0** | — | — |
| SupertrendReversal · 225JPY · 770921 | **0** | — | — |
| SupertrendReversal · XAGUSD · 770922 | **0** | — | — |
| SupertrendReversal · D30EUR · 770923 | **0** | — | — |
| SupRev_NAS_H1_Ottimizzato (magic vecchio) · NASUSD · **770925** | 2 | 2026-07-31 → 2026-08-10 | ⚠️ vedi sotto |
| SupertrendReversal_Multi_Ottimizzato · XAUUSD · 971001 | **0** | — | — |
| EMA200 · 200AUD · 771511 | **0** | — | — |
| EMA200 · AUDJPY · 771512 | **0** | — | — |
| EMA200 · GBPJPY · 771513 | **0** | — | — |
| EMA200 · SPXUSD · 771514 | **0** | — | — |
| EMA200 · GBPUSD · 771515 | **0** | — | — |

**12 sedie su 14 (86%) a zero trade assoluto** in tutto lo statement
(2026.03.30 → 2026.08.21). Lettura più probabile, **non certa**: durante
agosto la flotta è stata migrata sui nuovi magic standardizzati (schema
`77xxxx` → `97xxxx` per gli "_Ottimizzato"), e questi 14 magic sono
**relitti di una numerazione precedente**, ormai sostituiti dalle sedie
della Tabella A (es. `770923` D30EUR H4 → probabile predecessore di
`970912` SupRev_DAX_H4_Ottimizzato, oggi anch'esso a zero). Ma è
**un'ipotesi**, non una misura: **va verificato sul VPS se questi 14
grafici esistono ancora e se hanno l'Algo Trading acceso** — se sì,
`FLOTTA_ATTIVA.md` è la fonte corretta e il censimento `.chr` del 19/08 li
ha persi per un motivo da trovare; se no, `FLOTTA_ATTIVA.md` è la sezione
più invecchiata del documento e andrebbe corretta.

**⚠️ IL CASO 770925 → 970913, e il gemello 770901 → 970901 (§5): stesso
schema, uno spiegato dai dati, l'altro no.** `770925` (NASUSD, "vecchio
magic" per FLOTTA_ATTIVA) ha **2 trade fra il 31/07 e il 10/08**, poi tace;
`970913` (stesso EA/simbolo, magic nuovo) ha trade dal 30/07 **fino al
17/08**. Le due serie non si accavallano dopo il 10/08: compatibile con
una **migrazione di magic avvenuta verso il 10-11/08** (stesso EA, stesso
simbolo, il grafico ha cambiato numero e i vecchi trade restano solo nello
storico). Non è quindi una sedia doppia oggi — è verosimilmente la stessa
sedia raccontata da due numeri in tempi diversi. **Ipotesi coerente con i
dati, non verificata sul VPS.**

---

## 🔴🚨 §5 — LA COLLISIONE DI MAGIC 770901 (trovata cercando, non nel mandato originale)

Il magic **770901** compare **due volte nei documenti per due sedie
diverse**:
- `CONTRATTI_SEDIE.md` (Tabella A qui sopra): **225JPY**, `SupertrendReversal`
  "Nikkei H2", contratto pieno, DD 0,88%.
- `FLOTTA_ATTIVA.md` (riga "XAUUSDH41"): **XAUUSD**,
  `SupertrendReversal_Ottimizzato`, magic **770901** — mentre
  `CONTRATTI_SEDIE.md`/censimento assegnano a quella stessa sedia (XAUUSD
  Ottimizzato) il magic **970901** (contratto "parziale").

**E lo statement conferma che il magic 770901 ha davvero fatto trade su
XAUUSD**: 3 chiusure, **2026-07-30 → 2026-07-31**, tutte su XAUUSD — **zero**
su 225JPY nello stesso periodo (la riga 225JPY·770901 in Tabella A è
infatti ⚫ ZERO). Quindi il magic non era "libero": **è stato riassegnato**
da XAUUSD (fino al 31/07, dati alla mano) a 225JPY (contratto scritto il
18/08), verosimilmente nella stessa finestra di rinumerazione di inizio
agosto discussa sopra per 770925/970913.

📌 **Perché conta**: se la sedia 225JPY "Nikkei H2" a magic 770901 fosse
stata avviata *prima* che il vecchio XAUUSD-770901 fosse davvero spento (o
se un vecchio grafico XAUUSD col magic 770901 fosse rimasto attaccato da
qualche parte), `CountPositions()` filtrato per simbolo+magic non le
confonderebbe fra loro (simboli diversi) — ma **qualunque referto o
censimento che legga "magic 770901" senza il simbolo rischia di sommare due
sedie diverse**, esattamente come ha fatto la prima bozza di questo stesso
censimento prima della correzione del §metodologia punto 2. **Raccomandato:
verificare sul VPS che non esista più nessun grafico XAUUSD con magic
770901 acceso.**

---

## 🟠 §6 — LA FAMIGLIA GapFill: 5 MAGIC SU 5 A ZERO TRADE

`ABTG_GapFill` è promossa (R36/R37), ha un contratto pieno su **tutti e
cinque** i simboli, ed è **presente nel censimento `.chr` del 19/08** (i
cinque commenti `GAP AUDUSD/GBPUSD/EURUSD/DOW/NIKKEI` ci sono tutti). Ma
**nessuno dei cinque magic (772231-772235) ha una sola riga nello
statement**, dal 30/03 al 21/08.

Perché e' il pattern più forte del censimento e non solo "un'altra riga
ZERO": **le famiglie di frequenza comparabile deployate nello stesso
periodo (PunteLarry, CostToCost, EasyTrend) mostrano tutte almeno un trade
su quasi ogni simbolo** nella stessa finestra di 2-4 settimane. Se GapFill
fosse acceso e funzionante quanto loro, la probabilità che **tutti e cinque
i simboli** restino contemporaneamente a zero per coincidenza è bassa
(anche alla frequenza più bassa della famiglia, ~0,6/mese, il conto
combinato dei cinque promette **~5,3 chiusure/mese**: aspettarsi zero per
3-4 settimane su tutti e cinque insieme è statisticamente stretto, anche se
non impossibile). **Non è una prova di guasto — potrebbe semplicemente
essere una famiglia a bassa frequenza e sfortunata sul periodo — ma è il
pattern che merita la verifica più immediata: i cinque grafici hanno
l'Algo Trading acceso? Il `.ex5` installato è quello con `OnTester`
funzionante o una build vecchia?**

---

## 🎯 LE 2-3 SEDIE PIÙ URGENTI DA GUARDARE

### 1. 🟠 La famiglia `ABTG_GapFill` (772231/2/3/4/5) — zero trade su TUTTI e 5 i simboli
Vedi §6. È il segnale più solido perché **non è una sedia isolata**: è un
pattern ripetuto su cinque strumenti indipendenti di una famiglia già
promossa con un contratto pieno. Azione: verificare Algo Trading + build
`.ex5` sui cinque grafici sul VPS, prima settimana prossima.

### 2. 🔴 `Gold_Ichimoku_TK_ATR_EA` (XAUUSD, 250604) — 63 giorni di silenzio, e il contratto era già zoppo
Solo **2 trade in tutto lo statement**, l'ultimo il **2026-06-19** — **63
giorni fa** rispetto alla fine della copertura (21/08). Il contratto
promette ~7,2 chiusure/mese; anche accettando il campione minuscolo (n=2,
quindi 🔵 INSUFF per la soglia di questo censimento), un silenzio di due
mesi su un motore che dovrebbe fare più di una operazione a settimana è un
fatto di per sé, non un rapporto statistico. Aggravante già agli atti in
`CONTRATTI_SEDIE.md`: è un contratto **"parziale"** validato su un **altro
broker** (Tickmill), e sullo stesso identico test su BCM il PF crollava da
1,54 a 1,01 (DD 28%). Azione: verificare se il grafico è ancora attaccato e
se l'Algo Trading è acceso prima di aspettare altre settimane.

### 3. 🟡 La famiglia `ABTG_PTE` (771321/771322/771323) — 2 trade in tutto su tre sedie, e una gamba con precedenti pesanti
`PTE U30USD` (771321) è a **zero** trade; `PTE GBPUSD storica` (771322) e
`PTE USDJPY` (771323) hanno **un trade ciascuna**. È la famiglia più vecchia
del vivaio (R23, non delle deploy di agosto), quindi il campione minuscolo
pesa di più. E **`PTE USDJPY` porta già un fascicolo negativo indipendente**
(R69: **0 celle IS positive su 28**, una delle tre celle OOS-negative del
suo stesso studio, DD promesso 3,97% il più alto della famiglia) — un
singolo trade non basta a giudicarla, ma è la sedia della flotta con il
**precedente peggiore** e ancora a **rischio 1,0%** (le due gemelle GBPUSD
del duello sono già scese a 0,5%). Azione: nessuna modifica al forward (il
mandato lo vieta), ma è la prima candidata a rileggere quando i trade
saliranno a numero misurabile.

---

## 📎 LIMITI DICHIARATI DI QUESTO CENSIMENTO

1. **Nessuna modifica è stata fatta**: nessun EA, nessun parametro, nessun
   file di criteri o Guardian toccato — solo lettura e conteggio, come da
   mandato.
2. **"Zero nello statement" ≠ "zero da sempre"**: lo statement copre da
   2026.03.30; una sedia può essere stata accesa dopo.
3. **Le finestre reali sono quasi tutte sotto le 4 settimane** (punto 5
   della metodologia): la maggioranza delle classificazioni di frequenza è
   **provvisoria per costruzione**, non per pigrizia — si rilegge fra 2-3
   settimane con più dati.
4. **Il conto 100k copre solo 11 giorni** (dal 10/08): utile solo come
   riscontro sulle 5 sedie mirror del dry-run Guardian, non come misura
   indipendente.
5. **`BREAKOUT_EA_JPY_v3` resta non misurabile** per assenza di un magic
   proprio nei dati.
6. **Il censimento `.chr` più recente disponibile è del 19/08 15:34**: tre
   giorni di eventuale drift della flotta reale (spegnimenti, nuovi
   deploy) non sono coperti da questo file.

---

_Compilato il 22/08/2026. Ogni numero di questa tabella viene da
`data/statements/trades_auto.csv` + `trades_100k.csv` (letti con Python,
filtrati per **magic e simbolo insieme**) incrociati con
`report/CONTRATTI_SEDIE.md` e il censimento `.chr` del 19/08 15:34. Nessun
numero è stato inventato o arrotondato oltre la prima cifra decimale._
