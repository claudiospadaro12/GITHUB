# 🌙 R187 — IL LIVELLO NOTTURNO SUL NASDAQ: **un round MAI FATTO**, e il censimento lo prova

**19/09/2026** · branch `lavoro` · nato dagli screenshot dei colleghi di Claudio
(`Max sett. prec. · Max notturno · Max giorno prec. · Apertura giorno · Min notturno`)

> # 🟢 **VERDETTO IN UNA RIGA: `ABTG_MaxMinNotte` non è MAI girato su `NASUSD`. Zero corse su 43 CSV. La casella è libera, non provata — e i tick reali per riempirla CI SONO.**

---

## ① 🏺 IL CENSIMENTO, fatto DENTRO i file e non sui nomi

Il mandato diceva di rifarlo guardando dentro i CSV. 🔴 **E la prima cosa che ho trovato è che
DENTRO i CSV il simbolo NON C'È.**

Gli `OptResults_*.csv` di questa famiglia li scrive `OnTesterDeinit` via `FrameInputs`: contengono
**solo gli INPUT dell'EA**. Il simbolo scambiato non è un input, quindi non c'è nessuna colonna
che lo porti. L'unica colonna che *sembra* un simbolo è **`InpCorrSymbol`**, che è un
**parametro** (il simbolo di correlazione), non il mercato della corsa.

| la trappola, col numero | |
|---|---|
| CSV della famiglia `MaxMinNotte` in archivio | **43** |
| di questi, con `InpCorrSymbol=SPXUSD` su **tutte** le righe | **43 / 43 = 100%** |
| corse di `MaxMinNotte` realmente fatte su `SPXUSD` | 🔴 **ZERO** |

> 🔴 **Un `grep SPXUSD` dentro questi CSV dà 43 falsi positivi su 43.** È esattamente
> l'avvertimento ricevuto, confermato al 100%. La catena di prova vera è
> **nome file → `.ini` (`Symbol=`) / file prova (`@SIMBOLO`) / lanciatore (`$Symbols`)**.

### Il censimento per contenuto — 43 CSV, ricostruiti sulla catena

| simbolo | CSV | fonte della catena |
|---|---:|---|
| **D30EUR** | **24** | `ini/valid_MaxMin_D30EUR.ini` · `prove/R103_…_D30EUR_770411.txt` · `r81_csv/` |
| **XAUUSD** | **14** | `maxmin_oro.ps1 -Sym XAUUSD` · `prove/R103_…_XAUUSD_770402.txt` |
| **EURUSD** | **2** | `prove/ABTG_MaxMinNotte.txt` |
| **F40EUR** | 1 | `rilancia_maxmin_indici.ps1` `$Targets` |
| **E50EUR** | 1 | idem |
| **100GBP** | 1 | idem |
| 🔴 **NASUSD** | **0** | **— nessuna corsa, nessun `.ini`, nessun file prova** |

🟢 **E il conteggio per contenuto trova 9 file in più di quello per nome** (43 contro i 34 del
conteggio sui percorsi: 6 `XAUUSD` con nomi tipo `oro_maxmin_fase1_*` e i 3 indici europei).
La regola di casa regge: **contare sui nomi salta dei file.**

### Le tre prove indipendenti che su `NASUSD` non c'è niente
1. **Contenuto**: 0 CSV su 43 (tabella sopra).
2. **File prova**: 17 file prova in repo hanno gli input del box notturno. `@SIMBOLO` →
   `D30EUR`, `XAUUSD`, `EURCHF`. **Mai `NASUSD`.**
3. **Storia git**: `git log --all --name-only` su tutti i path che contengono `maxmin`
   → **zero** path con `nas` nel nome. Nessun file cancellato che potesse contenerlo.

🟠 **E l'occasione stava in piena vista**: `scan_market.ps1` r.54 e `rilancia_scan_market.ps1` r.33
hanno **`NASUSD` nella lista simboli di `ABTG_MaxMinNotte`**. La scansione era *scritta*, con il
Nasdaq dentro — **non è mai stata lanciata** (nessun `scan_ABTG_MaxMinNotte_*.csv` esiste).

---

## ② 🟢 LA CORREZIONE CHE SBLOCCA IL ROUND: **i tick di NASUSD sono MISURATI**

Il mandato diceva di dichiarare il round **[SOTTO SONDA]** perché la profondità dei tick di
`NASUSD` non sarebbe mai stata misurata (`ABTG_StoricoScaricato.csv` ha `U30USD` e `D30EUR`, non
`NASUSD`). **Quel file davvero non ce l'ha. Ma un referto dedicato sì:**

```
backtest_pipeline/risultati_archivio/misura_tick/REFERTO_MISURA_TICK_NASUSD.txt   (30/08/2026)
  I TICK REALI DI NASUSD PARTONO DAL 2024.09.26   (166509474 tick)
  NASUSD M1  barre=660018   prima data server 2024.09.26
```

> ## 🟢 **Quindi il round NON è sotto sonda: gira a TICK REALI (modello 4) sulla finestra `2024.09.26 → 2026.06.30`, la stessa degli altri round indici.**
> La sonda che mancava non mancava: mancava **nell'indice sbagliato**.

---

## ③ 🎯 IL ROUND — due file, e l'unica cosa che cambia fra loro è **QUALE NOTTE**

Il round misura **il LIVELLO**, non i parametri. La gestione è copiata **verbatim** dalla cella
viva `770411` (`ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set`, foto del
`.chr` del 06/09). Cambia il **simbolo**: è un allargamento su **SIMBOLO**, permesso dalla regola
del 19/08. E il motore **non** è senza edge (R103: PF 2,257 su `D30EUR`), quindi il divieto di
infittire non morde.

| | **`R187a` — notte EUROPEA** | **`R187b` — notte AMERICANA** |
|---|---|---|
| box (ora server) | **23:00 → 04:59** (359 min) | **23:00 → 14:29** (929 min) |
| piazza ordini | **07:59** (apertura DAX) | **14:29** (apertura Nasdaq) |
| cutoff ingressi | **08:30** (31 min) | **15:50** (81 min) |
| flat | **17:30** | **20:45** |
| magic (gemelli) | `761600` / `761601` | `761610` / `761611` |
| tutto il resto | **identico**: buffer 1000, SL `2,5×ATR(14) M15`, TP1 1R/50% + BE, TP2 3R, target EMA200, trail 2,0 ATR, 0,65%, M15 | **identico** |

### 🔴 L'ORA: le tre scelte, ognuna con la sua ragione misurata

1. **Perché `InpBoxStartHour` resta `23` anche nella variante americana — e non l'ho deciso io.**
   `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv`, righe `NASUSD`:
   ora 21 → 2.628 campioni · 🔴 **ora 22 → 0 campioni, 2.987 scartati** · ora 23 → 3.299.
   **`NASUSD` è CHIUSO all'ora 22 server.** La riapertura alle 23:00 è il confine naturale della
   sua notte. 🟢 **Ci sono arrivato da una misura diversa e ha dato lo stesso numero della cella
   viva.**
2. **Perché il cutoff di `R187b` NON sono 31 minuti.** Sotto la legge di casa
   `range ≈ ADR × √(t/W)` (`ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md`), il rapporto
   *escursione(cutoff) / ampiezza(box)* vale `√(31/359) = 0,294` — **e `ADR` e `W` si
   semplificano**. Per tenerlo su un box di 929 minuti servono `929 × 31/359 = **80,2 min**` →
   cutoff **15:50**. 🔴 *Copiare i 31 minuti avrebbe dato un muro 2,6× più alto con la stessa
   finestra per scavalcarlo: `n` minuscolo, e la lettura sbagliata «il livello non funziona».*
3. **Perché il flat passa a 20:45.** In `OnTick` il controllo
   `nowMin >= InpCloseHour*60+InpCloseMin → EndOfDay(); return;` sta **PRIMA** del piazzamento.
   20:45 = 15 min prima della chiusura cash USA (21:00 server), ed è l'orario che la casa usa già
   su `NASUSD` per `770250` (classe 441). ⚠️ E una "traduzione" ingenua a `14:29 + 9h31 = 24:00`
   **non sarebbe mai scattata** (`nowMin` arriva a 1439): zero flat, in silenzio.

---

## ④ 📐 L'ATTESA, DICHIARATA PRIMA DEI NUMERI — e verificata per **due strade indipendenti**

**Base misurata A** — `R103_REFERTO_DRIVER_BLOCCO1_INDICI_20260824_1348.txt` r.81:
`MaxMinNotte` `D30EUR`, **stessa finestra di questo round**, PF 2,257 · DD 1,98 · **n = 41**
(short-only + corr ON = la cella viva).

**Base misurata B** — `MaxMinNotte/080957cf-valid_MaxMin_D30EUR.csv`, 72 celle, corr OFF:
short-only **107** · long-only **149** · **due lati 255** (mediane).

| strada | conto | risultato |
|---|---|---:|
| 1 | `41 × 2,38` (due lati) `× 1,84` (corr OFF) | **179,5** |
| 2 | `255 × 0,7047` (riscalo 642/911 giorni fra le due finestre) | **179,7** |

> 🟢 **Due strade indipendenti, stesso numero.** È il controllo del 10/09 — verificare contro
> numeri già scritti da altri, non contro valori che tornano.

**ATTESA CONGELATA: `n = 180`, banda 120-220**, per tutti e due i file (il cutoff di `R187b` è
stato scelto apposta perché le due attese coincidano → **ogni differenza fra `a` e `b` è
informazione sul LIVELLO, non rumore di taratura**).

🔴 **E il PF atteso è NESSUNO, e va detto prima.** Le uniche misure di questo motore **fuori dal
DAX** sono tre indici europei, e fanno **0/54 celle positive tutti e tre**:
`100GBP` 0,6717 · `E50EUR` 0,8398 · `F40EUR` 0,9985 (`REGISTRO_TEST` rr.2526-2528).
**La base storica di `MaxMinNotte` fuori dal DAX è NEGATIVA.** Se esce PF > 1,10 è una notizia;
se esce 0,9 è quello che dice l'archivio.

---

## ⑤ 🛑 IL CONTRO-ESEMPIO: **che cosa vedrei se il round misurasse la cosa sbagliata**

Le soglie di `n` sono nei file prova, **congelate prima dei numeri**:

| `n` | verdetto ammesso |
|---|---|
| **≥ 150** | il **MERITO** si legge (Emendamento A) |
| **50-149** | merito **SOSPESO**: si scrive *"indizio"*, mai *"funziona"/"non funziona"*. Il **RISCHIO** si legge lo stesso (Emendamento B) |
| 🔴 **< 50** | **«NON MISURATO — FINESTRA SBAGLIATA»**, **mai** *"non funziona"* |
| **0** | non è un risultato: è un difetto di configurazione (`place < cutoff < close`) |

### E la lettura incrociata dei due file, scritta prima della corsa
- **`a ≥ 50` e `b ≥ 50`** → il box si rompe con tutti e due gli orologi: il confronto dei PF parla
  **del livello**. Caso buono.
- 🔴 **`a < 50` e `b ≥ 50`** (o il contrario) → **il round ha misurato L'OROLOGIO, non il
  livello**. Verdetto: *"la notte del Nasdaq è quella dell'altro file"*, e il livello resta
  **NON MISURATO**.
- 🔴 **`a < 50` e `b < 50`** → **NON MISURATO**, e l'ipotesi da falsificare diventa **la legge
  `√(t/W)` applicata a questa geometria** — che sarebbe un risultato utile di suo, perché quella
  legge la usiamo anche altrove. **Non** si scrive *"il livello notturno sul Nasdaq non vale"*.
- **`a` e `b` ≥ 150 con PF molto diversi** → prima di raccontarlo si esclude che sia la **DURATA**
  della posizione (flat 17:30 contro 20:45), l'unica altra cosa cambiata.

🟢 **E il verso dell'errore è dichiarato**: il buffer di 1000 punti (= 10 idx) è il **3,96%**
dell'ADR di `D30EUR` (252,5) ma solo il **2,60%** di quello di `NASUSD` (384,6 — entrambi
`[MISURATO]`). Su `NASUSD` il buffer relativo è **più piccolo**, quindi si rompe **più**
facilmente. **Se `n` esce basso, non è il buffer.**

---

## ⑥ 💰 IL COSTO IN TEMPO MACCHINA — stima **con la base, e con la correzione che mi sono fatto da solo**

**Base misurata**: `R104_REFERTO_DRIVER_20260825_0738.txt` r.13-15 — *stesso motore*, `D30EUR`
M15, finestra `2024.09.26 → 2026.08.24`, **modello 4 tick reali**: **0,7 minuti di passata**.

🔴 **Ma quella base è su `D30EUR`, e usarla nuda sarebbe la classe 192** (modello di costo col
denominatore sbagliato). Nella stessa finestra: `D30EUR` **35.496.307** tick, `NASUSD`
**166.509.474** → **×4,69**, e il tester scala coi tick.
→ `0,7 × 4,69 ≈` **3,3 min/passata**.

| | |
|---|---|
| celle | 2 file × 2 celle gemelle = **4** |
| passate nominali | 4 × 2 gambe = **8** (di cui 4 sulla gamba OOS **degenere**, costo ~0) |
| **stima** | 🟢 **15-25 minuti** in tutto |
| bersaglio | 🖥️ **banco da backtest `C:\MT5_Backtest`, demo `50504400`** — **NON** il piccolo `50503392`, **NON** il 100k `50504263`, **NON** il reale `10105439` |

---

## ⑦ 🚦 IL CANCELLO DI COSTO `stop ≥ 40 × spread`

`stop = 2,5 × ATR(14) M15 = 2,5 × 40,1 = **100,25 idx**` · spread `NASUSD` **1,80** mediana /
**1,90** p95 → **52,8×** → 🟢 **PASS con +32%**.

🟢 E non ho dovuto sperare che l'ora 07 somigliasse all'ora 14: **lo spread di `NASUSD` è PIATTO
su tutte e 24 le ore** (1,80/1,90 ovunque, n≈3.600/ora, 5 giornate, `[MISURATO]`). Vale per tutti
e due gli orologi.

🔴 **Contro-esempio del cancello**: l'`ATR` è **`[INFERITO]`** — *«su NASUSD non esiste nessun ATR
misurato»* (`ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` rr.402 e 512). Il cancello regge finché
l'ATR(M15) **vero** è ≥ **30,4 idx**, cioè finché l'inferenza (40,1) non sovrastima di più del
**24,2%**. Sotto quella soglia **il round è fuori costo e il suo PF non vale**.

---

## ⑧ 🕳️ I BUCHI, DICHIARATI

1. 🔴 **L'ATR(14) M15 di `NASUSD` è INFERITO, non misurato.** È l'unico numero del round senza una
   misura sotto. Lo chiude una sonda ATR su `NASUSD`; finché non c'è, il margine del cancello di
   costo è quello scritto sopra e non di più.
2. 🟠 **`@FRAZIONEIS 1.0` = una sola tranche, gamba OOS DEGENERE.** È una scelta, non una
   dimenticanza: con 21 mesi di tick e ~0,39 op/giorno il campione **massimo** è ~180, e uno
   split 40/60 darebbe **72 IS e 108 OOS — tutti e due sotto il pavimento dei 150**. E l'IS/OOS
   serve a smascherare la **selezione**: qui non si seleziona niente (l'unico asse è il magic
   tecnico), quindi non compra nulla e costa metà campione.
   👉 **Il fuori campione si paga dopo, ed è già firmato**: se il round passa, il passo successivo
   è la **prova di regime su `NASUSD_EXT`** (2010.11.14 → 2026.07.31, 5,23 M barre M1, modello 1),
   firmata da Claudio il 26/08 *«FIRMO FRIGO NASUSD»* coi limiti scolpiti — **parametri
   CONGELATI, SOLO prova di regime, MAI promozione** (`R113_CRITERI.md` rr.36-60).
3. 🟠 **Il trasferimento del tasso di rottura da `D30EUR` a `NASUSD` è `[NON MISURATO]`.** La
   legge `√(t/W)` dice che dovrebbe essere lo stesso, ma un effetto non è nella legge: alle 08:00
   server **il DAX apre, il Nasdaq no**. È il motivo della banda 120-220 invece di un numero.
4. ⚠️ **Se mai questo round portasse a una sedia su `NASUSD`, eredita la classe 441**: su quel
   simbolo vive già `770250`, e `PositionClose(_Symbol)` su conto hedging colpisce la posizione
   **più vecchia del simbolo**, di chiunque sia. Va riletto **prima** di qualunque schieramento —
   che non è questo round.

---

## ⑨ ✅ COSA È PRONTO

| artefatto | stato |
|---|---|
| `backtest_pipeline/prove/R187a_notteEU_MaxMinNotte_NASUSD.txt` | 🟢 `controlla_prova.py` **OK**, 52 pin, 2 celle, ASCII puro |
| `backtest_pipeline/prove/R187b_notteUS_MaxMinNotte_NASUSD.txt` | 🟢 `controlla_prova.py` **OK**, 52 pin, 2 celle, ASCII puro |
| magic `761600/761601/761610/761611` | 🟢 **VERGINI** — `grep -rIn -oE "\b7616[0-9]{2}\b" . --exclude-dir=.git` → zero occorrenze prima di oggi |
| numero di round | 🟢 **R187** — `R176` era già occupato da `R176a_beatatr_breakingband_GBPUSD.txt`, rinumerato **prima** della consegna |
| classi nuove | 🟢 **444** e **445** in `CHECKLIST_RIGA_DI_LANCIO.md` |

🛑 **Questo lavoro non esegue backtest, non tocca EA/preset/forward, non propone taglie né
accensioni, e non nomina il conto reale `10105439` se non per escluderlo.**

---
*Fonti, per file: censimento su 43 CSV `MaxMinNotte` (`risultati_archivio/{MaxMinNotte,MaxMin_Oro,r81_csv}`,
`risultati_prove/{ABTG_MaxMinNotte,ABTG_MaxMinNotte_DAX_Short_Ottimizzato,MaxMin_Oro_r17,MaxMin_Oro_r19,MaxMin_Oro_fase2_vecchioscript,dal_vps}`)
· `backtest_pipeline/ini/valid_MaxMin_*.ini` · `rilancia_maxmin_indici.ps1` · `maxmin_oro.ps1` ·
`scan_market.ps1` r.54 · `rilancia_scan_market.ps1` r.33 ·
`risultati_archivio/misura_tick/REFERTO_MISURA_TICK_NASUSD.txt` ·
`risultati_archivio/R103_REFERTO_DRIVER_BLOCCO1_INDICI_20260824_1348.txt` r.81 ·
`risultati_archivio/R104_REFERTO_DRIVER_20260825_0738.txt` rr.13-15 ·
`risultati_archivio/R113_CRITERI.md` rr.36-60 · `REGISTRO_TEST.md` rr.453-476 e 2526-2528 ·
`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` rr.98-100, 310-318, 395-412, 512 ·
`data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` (righe `NASUSD`) ·
`mql5/Experts/ABTG_MaxMinNotte.mq5` (`ComputeBox` r.199, `OnTick` r.156, scadenza pendenti r.235) ·
`mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set` ·
`report/IL_NASDAQ_IN_CAMPO_C_E_GIA_2026-09-18.md` · `report/LA_STRATEGIA_NASDAQ_DEI_COLLEGHI_2026-09-18.md`.*
