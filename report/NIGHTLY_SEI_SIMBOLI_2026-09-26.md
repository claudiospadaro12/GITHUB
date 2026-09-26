# 🌙 NIGHTLY — I SEI SIMBOLI MAI MISURATI: perché fanno zero, come si sbloccano, cosa aspettarsi

**Data: 26/09/2026 · sola lettura + 6 file prova · nessun backtest eseguito · nessun EA toccato**
Richiesta di Claudio sul PDF `ABTG-NIGHTLY_20240505.pdf`: _"ANCHE QUESTA SI PUO' OTTIMIZZARE!!!! CE LA
DOBBIAMO FARE. ABBIAMO L'EA. CERCHIAMO DEI PARAMETRI X OTTIMIZZARLA AL MEGLIO."_

---

## 0. 🎯 IL VERDETTO IN SEI RIGHE

1. 🟢 **Per misurare i sei simboli NON serve toccare il sorgente: basta UN input per simbolo.**
   AUDUSD/USDJPY si sbloccano con `InpBlockNightActive=0`, oro/argento/DAX/Dow con
   `InpMaxNightVolPips=0`. **Sei file prova pronti, `controlla_prova.py`: 6/6 OK, 12 celle, 24
   passate, ~29 minuti** [STIMA, tetto alto] sul PC di backtest.
2. 🧪 **Ogni file porta la sua ANCORA**: la seconda cella rimette il blocco e **deve riprodurre lo
   zero d'archivio** (su XAGUSD: **0 / 4 operazioni, +50,82, PF 1,26185** al centesimo). Se non lo
   riproduce, la diagnosi è sbagliata e il round non si legge. Il contro-esempio sta **dentro** il
   round, non in un referto a parte.
3. 🔴 **La causa di AUDUSD/USDJPY non è più `[NON MISURATO]`**: è `ABTG_Nightly.mq5` **r.167**, un
   rifiuto **per nome** voluto dal PDF (PAG 22). Era già scritto in `R220a` §7-ii e in
   `I_CSV_A_ZERO_PERCHE_2026-09-22.md` r.180; `REGISTRO_TEST.md` r.686 era rimasto indietro.
4. 🟠 **Su XAGUSD la causa NON è chiusa**, e lo dico contro l'archivio: il filtro QB spiega l'OOS
   (4 trade) ma **non spiega un IS a zero**. C'è una seconda causa che predice lo stesso zero
   (barre M1 assenti). Il file R259 d le separa in una corsa.
5. 💸 **La frontiera del costo morde prima del PF**: **D30EUR** alla gestione di default sta a
   **18,4-20,9×** [DERIVATO] contro il 40× di lavoro → **escluso per costo dalla promozione**, col
   numero; **U30USD** sta **a cavallo** (39,0-44,1× alla mediana, 26-29× al P95).
6. ⚖️ **Onestà sull'attesa**: con questa geometria il puro caso fa PF fino a **~1,26 a n=300** e
   **~1,50 a n=100**; e su sei simboli la probabilità che **almeno uno** passi PF ≥ 1,10 in tutte e
   due le finestre **per caso** è **~25%** [STIMA]. Questo round compra **frequenza, rischio e
   segno**. **Una sedia per il 1° ottobre da qui NON esce** — e va detto adesso, non dopo.

---

## 1. 📋 COSA È GIÀ MISURATO E NON SI RIFÀ (punto d)

### 1.1 I quattro simboli con campione — **niente riottimizzazione dei parametri d'ingresso**
Fonte: `backtest_pipeline/risultati_prove/ABTG_Nightly/*.csv` (righe 2-3, passate gemelle
771701/771702 **identiche al centesimo**). Finestra 2024.09.26 → 2026.06.30 (642 giorni, **458
feriali**), IS 40% (taglio 2025.06.10), deposito 10000, rischio 1%.

| simbolo | modello | n IS / OOS | PF IS / OOS | DD% IS / OOS | stato |
|---|---|---:|---:|---:|---|
| EURUSD | OHLC | 106 / 164 | 1,04884 / 0,86117 | 10,7967 / 15,4930 | ❌ merito + rischio |
| GBPUSD | OHLC | 96 / 163 | 0,58619 / 1,04013 | 22,6211 / 11,2786 | ❌ merito + rischio |
| USDCHF | OHLC | 81 / 131 | 0,86342 / 0,97011 | 11,4246 / 14,1590 | ❌ merito + rischio |
| EURCHF | **tick reali** | 63 / 85 | 0,89113 / 0,81429 | 11,0988 / 15,3861 | ❌ **bocciato per RISCHIO** (`REGISTRO_TEST.md` r.3546) |

- 🛑 **Su questi quattro NON si allarga sull'ingresso** (regola del 19/08: motore a PF < 1,10 su
  campione pieno). **6 finestre su 8 sotto 1,00.**
- ✅ **L'uscita invece è una casella libera, e c'è già chi la riempie**: `R220a-d`
  (`prove/R220{a,b,c,d}_slpips_nightly_*.txt`) mettono `InpSLpips` ad asse su questi quattro, su
  2019.01.01 → 2026.06.30. **Stato: preparati, nessun CSV in repo** (`ls
  risultati_prove/ABTG_Nightly/`, 26/09). R259 **non li duplica** e si allinea alla loro finestra.
- ⚪ **Il TF non è una manopola su questo EA** (box da `PERIOD_M1` r.183-193, ATR da `PERIOD_H1`
  r.120, nessun input di TF): `report/RIESAME_MORTI_NOTTURNI_2026-09-22.md` §3b. Il punto ⑤ del
  certificato di morte qui è **"non applicabile, cablato"**, non vuoto.
- 🏎️ **E la cosa bella che va ricordata**: sulla famiglia misurata il Nightly fa **1,937 op/giorno
  di famiglia** (889 posizioni su 4 coppie in 459 feriali, `RIESAME_MORTI_NOTTURNI` r.37-42) — è
  il motore **più veloce** della flotta notturna. Muore su merito e rischio, **non sulla
  frequenza**. Per questo vale la pena sapere cosa fa sui sei che mancano.

### 1.2 Le sei caselle vuote (quelle di questo referto)
| simbolo | n IS / OOS d'archivio | stato vero |
|---|---:|---|
| AUDUSD | 0 / 0 | 🔴 **mai misurato** — bloccato per nome |
| USDJPY | 0 / 0 | 🔴 **mai misurato** — bloccato per nome |
| XAUUSD | 0 / 0 | 🔴 **mai misurato** — filtro QB in unità sbagliata |
| XAGUSD | 0 / **4** | 🔴 **mai misurato** — causa **aperta** (§2.3) |
| D30EUR | 0 / 0 | 🔴 **mai misurato** — filtro QB in unità sbagliata |
| U30USD | 0 / 0 | 🔴 **mai misurato** — filtro QB in unità sbagliata |

Un PF di 0,00000 su 0 operazioni **non è "nessun edge": è nessuna misura** (certificato di morte
del 09/09, punto 1).

---

## 2. 🔬 LA DIAGNOSI, SIMBOLO PER SIMBOLO (punto a)

Sorgente letto a HEAD: `mql5/Experts/ABTG_Nightly.mq5` (439 righe; `_Ottimizzato` differisce solo in
default e magic, `diff` fatto). Digits/Point dalla sonda
`risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`.

### 2.1 AUDUSD e USDJPY — **rifiuto per NOME, ogni notte**
| riga | cosa fa |
|---|---|
| `ABTG_Nightly.mq5:75` | `input bool InpBlockNightActive = true;` |
| `ABTG_Nightly.mq5:133-137` | `NightActiveSymbol()` = `StringFind(s,"JPY")>=0 \|\| "AUD" \|\| "NZD"` |
| `ABTG_Nightly.mq5:167` | `if(InpBlockNightActive && NightActiveSymbol()){ gPhase=NP_DONE; return; }` — **prima** del box |

- Il filtro QB **non c'entra**: AUDUSD Digits **5** (sonda r.29), USDJPY Digits **3** (sonda r.27)
  → `PipSize()` (r.109-113) è un pip vero, la soglia 45 è in pip come su EURUSD.
- 🧪 **Contro-esempio già caduto** (`I_CSV_A_ZERO_PERCHE_2026-09-22.md` r.204): *"sono zero per lo
  stesso QB"* → falso, con soglie in pip vere passerebbero larghi.
- ⚠️ **La regola è VOLUTA dal PDF** (PAG 22: *"Evita valute i cui mercati principali sono attivi
  durante la notte, come JPY, AUD, NZD"*). Quindi **non si ripara: si mette alla prova**. È la tesi
  nuova che la regola del 19/08 chiede: il PDF afferma che lì il fade rende **peggio**, e la corsa
  lo verifica.
- 📝 `REGISTRO_TEST.md` r.686-694 dice ancora *"causa `[NON MISURATO]`"*: **la causa era già scritta
  in `R220a` §7-ii (23/09) e in `I_CSV_A_ZERO` r.180 (22/09)**. Aggiornato oggi con un rimando.

### 2.2 XAUUSD, D30EUR, U30USD — **il filtro QB confronta pip con punti**
| riga | cosa fa |
|---|---|
| `ABTG_Nightly.mq5:72` | `input double InpMaxNightVolPips = 45;` |
| `ABTG_Nightly.mq5:109-113` | `PipSize()` = `_Point*10` se Digits ∈ {3,5}, **altrimenti `_Point`** (r.112) |
| `ABTG_Nightly.mq5:198-202` | `NightH1Vol()` = `ATR(14,H1) / PipSize()` |
| `ABTG_Nightly.mq5:213` | `if(InpMaxNightVolPips>0 && qb>=InpMaxNightVolPips){ … return(true); }` |
| `ABTG_Nightly.mq5:169` | `TryPlace()` ha reso `true` → fase `NP_PLACED` → **non riprova** fino al giorno dopo |

| simbolo | Digits (sonda) | Point | la soglia "45 pip" vale davvero | ATR(H1) noto | esito |
|---|---:|---:|---|---|---|
| XAUUSD | 2 (r.59) | 0,01 | **0,45 USD** di ATR(H1) | `[NON MISURATO]` | sempre escluso |
| D30EUR | 2 (r.65) | 0,01 | **0,45 punti indice** | 51,5-58,5 `[DERIVATO]` | sempre escluso |
| U30USD | 2 (r.71) | 0,01 | **0,45 punti indice** | 78,05-88,25 `[MISURATO]` | sempre escluso |

- 🧪 **Contro-esempio già caduto** (`I_CSV_A_ZERO` r.202): *"di notte non ci sono dati"* → falso,
  `MaxMinNotte` sugli stessi simboli e box fa 20/21 (D30EUR) e 59/92 (XAUUSD) operazioni.

### 2.3 XAGUSD — **la causa NON è chiusa** (e questa è una scoperta di oggi)
- Digits **3** (sonda r.58) → `PipSize()=0,01` → la soglia vale **0,45 USD** di ATR(H1): l'argento
  **a volte** ci sta sotto → **4 operazioni in OOS**. Fin qui `I_CSV_A_ZERO` r.203 ha ragione.
- 🔴 **Ma allora l'IS a zero chiede un'altra spiegazione.** Per il solo filtro QB, IS = 0 vuol dire
  ATR(H1) ≥ 0,45 USD in **tutte** le 183 notti feriali dell'IS (settembre 2024 → giugno 2025) e
  sotto in qualche notte dell'OOS. È possibile — l'ATR dell'argento **non è misurato** in repo — ma
  c'è una **seconda causa che predice lo stesso zero**: **barre M1 assenti nell'IS** → `ComputeBox`
  fallisce (r.185/r.207) → *"box non calcolabile: riprovo"* fino al cutoff → zero ordini.
  `prove/CODA.csv` r.7 (10/08) avvisava già che **sull'oro** lo storico M5 partiva dal 28/02/2025;
  sull'argento **non c'è scritto niente** → `[NON MISURATO]`, non assunto uguale.
- ✅ **Le due cause si separano con UNA corsa** (R259 d): se la cella a QB spento fa operazioni
  **nell'IS**, era il QB; se fa **zero anche lei**, era lo storico.

### 2.4 Una differenza fra EA e PDF che nessuno aveva messo in fila (non cambia R259)
Il PDF (PAG 14) definisce il secondo numero del QB come *"media dell'estensione delle candele H1
**durante la notte**"*. L'EA usa `ATR(14,H1)` letto alle 05:00 (r.198-202): 14 barre = 15:00-05:00
server, cioè **dentro la seduta americana**, lisciato alla Wilder. Sono **due grandezze diverse**
(lo aveva intuito `R220a` §6 dallo scarto range/ATR). E i cinque esempi del PDF (PAG 11-19) valgono
**7-22 pip** sui cross: su EURUSD il cancello a 45 pip è **[INFERITO] quasi mai mordente**. Per
questo spegnerlo sugli indici (QB=0) è la cosa **più vicina** al motore che ha girato sui forex.

---

## 3. 🔧 LA CORREZIONE MINIMA (punto b)

### 3.1 Per MISURARE basta un input — nessuna modifica del sorgente
| simbolo | input | effetto | cosa NON cambia |
|---|---|---|---|
| AUDUSD, USDJPY | `InpBlockNightActive=0` | salta r.167 | QB a 45 pip (unità giuste), stop, TP, box |
| XAUUSD, XAGUSD, D30EUR, U30USD | `InpMaxNightVolPips=0` | r.213 non morde (`InpMaxNightVolPips>0 &&`) | `qb` si calcola lo stesso (r.212) e lo stop resta `1 × ATR(14,H1)` (r.220: `qb*pip` è l'ATR in prezzo per **qualunque** `PipSize`) |

👉 **Per questo i file prova sono scritti** (punto 2 della consegna). Nessun `mql5-ea-developer`
serve per R259.

### 3.2 Per mettere alla prova il **QB del PDF** sugli indici/metalli serve il sorgente — DIFF PROPOSTA, NON APPLICATA
Il QB in pip **non ha un equivalente difendibile** in punti indice (il PDF stesso non dà l'unità,
`ANALISI_NIGHTLY_PDF_2026-08-23.md` §5.1). L'unica unità coerente fra simboli è **relativa alla
storia del simbolo stesso** (stessa conclusione di `TRASFORMAZIONI_CANDIDATE.md` §2.3). Proposta,
con **default bit-identico** (modo 0 = codice di oggi, anche nei log):

```diff
--- mql5/Experts/ABTG_Nightly.mq5  (r.72, gruppo "Filtri QB")
 input double InpMaxNightVolPips = 45; // escludi se la media candele H1 notte >= N pip (doc: QB>=45)
+input int    InpQBUnit          = 0;   // 0 = come oggi (ATR(H1)/PipSize contro N "pip"), bit-identico
+                                       // 1 = ATR(H1) di oggi / MEDIANA dello stesso valore alla stessa ora
+                                       //     sulle ultime InpQBLookback sedute: N diventa un MULTIPLO
+input int    InpQBLookback      = 100; // sedute per la mediana (solo InpQBUnit=1; sotto 20 il filtro NON morde)

--- dopo NightH1Vol() (r.198-202)
+//--- QB relativo: mediana di ATR(H1)/PipSize() alla stessa ora nelle sedute passate
+double NightH1VolMedian()
+  {
+   datetime t0=iTime(_Symbol,PERIOD_H1,1);
+   if(t0<=0) return(0);
+   double v[]; int n=0;
+   for(int d=1; d<=InpQBLookback*2 && n<InpQBLookback; d++)
+     {
+      int sh=iBarShift(_Symbol,PERIOD_H1,t0-(datetime)(d*86400),true);
+      if(sh<1) continue;                                   // weekend/festivo: nessuna barra a quell'ora
+      double a[1];
+      if(CopyBuffer(hAtrH1,0,sh,1,a)!=1 || a[0]<=0) continue;
+      ArrayResize(v,n+1); v[n]=a[0]/PipSize(); n++;
+     }
+   if(n<20) return(0);
+   ArraySort(v);
+   return((n%2==1) ? v[n/2] : 0.5*(v[n/2-1]+v[n/2]));
+  }

--- in TryPlace() (r.212-213)
    double qb=NightH1Vol();
-   if(InpMaxNightVolPips>0 && qb>=InpMaxNightVolPips){ Log(StringFormat("QB alto (%.1f>=%.0f): escluso.",qb,InpMaxNightVolPips)); return(true); }
+   if(InpQBUnit==0)
+     {
+      if(InpMaxNightVolPips>0 && qb>=InpMaxNightVolPips){ Log(StringFormat("QB alto (%.1f>=%.0f): escluso.",qb,InpMaxNightVolPips)); return(true); }
+     }
+   else
+     {
+      double med=NightH1VolMedian();
+      double rel=(med>0 ? qb/med : 0);                     // storico < 20 sedute: rel=0, il filtro NON morde (dichiarato)
+      if(InpMaxNightVolPips>0 && rel>=InpMaxNightVolPips){ Log(StringFormat("QB relativo alto (%.2f x mediana >= %.2f): escluso.",rel,InpMaxNightVolPips)); return(true); }
+     }
```
- ✅ **Lo stop non cambia**: r.220 continua a usare `qb` (in pip × `pip` = ATR in prezzo).
- ⚠️ **Non è un lavoro da fare adesso, e non l'ho applicato**: serve **`mql5-ea-developer`** + compilazione
  + **il cancello** (`controlla_riga.py` + `controllo-preventivo`) + un collaudo di **neutralità**
  (modo 0 identico al centesimo all'archivio). Ed entra in gioco **solo** se lo stadio 1 dice che su
  un simbolo c'è qualcosa da filtrare. Il valore della soglia relativa va **congelato prima dei
  numeri**: il PDF non ne dà nessuno.
- 🔴 **Limite dichiarato**: nei primi 20 giorni di storico il modo 1 non filtra (fail-open). Sugli
  indici lo storico BCM parte dal 2024.09.26, quindi il primo mese dell'IS gira senza filtro.
- 🔴 **E NON corregge la differenza del §2.4** (ATR a 14 barre contro media delle sole ore di notte):
  quella è una seconda modifica, separata, e oggi non la propongo.

---

## 4. 📐 LA GRIGLIA PROPOSTA — R259, sei file, un asse ciascuno (punto c)

### 4.1 I file
| file (`backtest_pipeline/prove/`) | simbolo | asse (2 celle) | ancora (la cella che DEVE riprodurre l'archivio) | finestra | magic |
|---|---|---|---|---|---|
| `R259_nightly_AUDUSD_PIN.txt` | AUDUSD | `InpBlockNightActive` {0,1} | cella 1 → **0 / 0** | 2019.01.01→2026.06.30, IS 0,50 | 787261 |
| `R259_nightly_USDJPY_PIN.txt` | USDJPY | `InpBlockNightActive` {0,1} | cella 1 → **0 / 0** | 2019.01.01→2026.06.30, IS 0,50 | 787262 |
| `R259_nightly_XAUUSD_PIN.txt` | XAUUSD | `InpMaxNightVolPips` {0,45} | cella 45 → **0 / 0** | 2024.09.26→2026.06.30, IS 0,40 | 787263 |
| `R259_nightly_XAGUSD_PIN.txt` | XAGUSD | `InpMaxNightVolPips` {0,45} | cella 45 → **0 / 4, +50,82, PF 1,26185, DD 1,6582%** | 2024.09.26→2026.06.30, IS 0,40 | 787264 |
| `R259_nightly_D30EUR_PIN.txt` | D30EUR | `InpMaxNightVolPips` {0,45} | cella 45 → **0 / 0** | 2024.09.26→2026.06.30, IS 0,40 | 787265 |
| `R259_nightly_U30USD_PIN.txt` | U30USD | `InpMaxNightVolPips` {0,45} | cella 45 → **0 / 0** | 2024.09.26→2026.06.30, IS 0,40 | 787266 |

- Tutti: `ABTG_Nightly`, **@PERIODO M15** (quello d'archivio, `prove/CODA.csv` r.41-48; il TF è
  inerte), **-Modello 1 (OHLC, solo screening)**, **-Deposito 10000**, rischio 1,0 (dial di misura,
  non taglia), **30 input pinnati + 1 asse + 3 stringhe al default = 34/34**.
- 🧾 **Magic vergini**: `grep` su tutto il repo (esclusi `.git`/`.claude`) per `78726x` → le sole
  occorrenze di `78726` sono valori di profitto dentro due CSV (`GoldenCross…E35EUR.csv`,
  `SuperWave_GBPUSD_OOS.csv`), nessun magic. La famiglia Nightly usa già 771701/771702, 971701,
  787201-787204.
- 🏷️ **Nome**: qui `_PIN` vuol dire "tutti gli input pinnati a mano". **Non è** il `PIN/PINA` di R254
  (sorgente a SHA fissato): scritto in testa a ogni file.
- 🔁 **G1 di determinismo**: non c'è una cella gemella sul magic (sarebbe un secondo asse). Il ruolo
  lo fa **l'ancora**, che è più forte: riproduce un CSV **di un altro giorno** sugli stessi dati. E la
  famiglia ha già **20 CSV su 20 con gemelli identici al centesimo**.

### 4.2 L'attesa, dichiarata prima dei numeri
**Frequenza** — ancorata ai 4 forex misurati: **0,323 / 0,463 / 0,566 / 0,590 op/feriale**
(EURCHF 148, USDCHF 212, GBPUSD 259, EURUSD 270 su 458 feriali, CSV d'archivio).

| gruppo | feriali IS / OOS | n atteso per finestra [STIMA] | merito leggibile (≥150)? |
|---|---:|---:|---|
| AUDUSD, USDJPY | 978 / 977 | **316-577** | ✅ atteso sì |
| XAUUSD, XAGUSD, D30EUR, U30USD | 183 / 275 | IS **59-108** · OOS **89-162** | 🔴 atteso **SOSPESO** almeno in IS |

👉 Sui quattro non-forex **lo dichiaro prima**: il file compra **frequenza e rischio**, non un
verdetto di merito. Lo storico BCM degli indici parte dal **2024.09.26** (`ABTG_StoricoScaricato.csv`
r.2-7): prima non c'è niente da allungare. I simboli `_EXT` hanno il **cancello zero chiuso**
(`STORICO_INDICI_20260910_1356/REFERTO_STORICO_INDICI.txt` r.15-18) e servono solo alla prova di regime.

**Il modello nullo — "che numero produce l'ipotesi NESSUN EDGE?"** [STIMA]
Modello binomiale dichiarato: operazioni indipendenti, vincente **+1,28 R** (media IS 1,309 / OOS
1,252 misurate su EURCHF, `R220a` §5-B), perdente −1 R, probabilità di vincere al pareggio lordo
**43,86%**, costo `c` in R per operazione = spread/stop. 8.000 simulazioni per riga, script in
scratchpad (non in repo: è un conto, non uno strumento).

| costo | n | PF mediano | PF al 95% | P(PF ≥ 1,10) | DD mediano | P(DD > 10 R) |
|---|---:|---:|---|---:|---:|---:|
| 0 | 100 | 1,006 | 0,66-1,50 | 29,7% | 12,1 R | 66,0% |
| 0 | 300 | 1,006 | 0,80-1,26 | 20,3% | 21,5 R | 97,5% |
| 0,024 (U30: 2,0/83) | 150 | 0,964 | 0,69-1,33 | 21,6% | 16,7 R | 87,9% |
| 0,024 | 300 | 0,964 | 0,76-1,21 | 12,9% | 24,7 R | 98,8% |
| 0,052 (D30: 2,8/54) | 150 | 0,917 | 0,66-1,27 | 13,3% | 18,7 R | 91,1% |

**E l'ipotesi "il PDF ha ragione"** — il PDF **non dichiara nessun numero di performance** (33 pagine,
`ANALISI_NIGHTLY_PDF` §4), quindi la definisco io, **prima**: un edge vero da sedia, PF netto 1,20.

| PF vero | n | P(PF misurato ≥ 1,10) | DD mediano | P(DD ≤ 10 R) |
|---:|---:|---:|---:|---:|
| 1,20 | 150 | 72,1% | 10,3 R | 45,9% |
| 1,20 | 300 | 79,0% | 13,4 R | **18,3%** |
| 1,30 | 300 | 92,8% | 11,7 R | 30,9% |

📌 **Tre cose che queste tabelle dicono, prima dei numeri veri:**
1. **A n ≈ 100 il PF non separa niente**: il caso arriva a 1,50. Sui quattro non-forex il PF di
   stadio 1 si legge **solo come segno**.
2. **Molteplicità**: a n=150 e costo 0,024, P(PF ≥ 1,10 in IS **e** OOS | nessun edge) ≈ 0,216² =
   4,7% per simbolo → su **sei** simboli, P(almeno uno verde per caso) = 1 − 0,953⁶ ≈ **25%**.
   **Un simbolo verde da solo non è un edge.**
3. 🔴 **Il cancello di rischio a 1% boccia anche un edge vero**: con PF vero 1,20 un DD > 10 R su
   300 operazioni capita **82 volte su 100**. **Il cancello resta com'è** (Emendamento B, soglia di
   casa DD > 10% @1%): ma chi legge deve sapere che un "fuori per rischio" qui dice **quale taglia
   regge**, non se c'è l'edge. La taglia è di Claudio.

**Il test del PDF su AUDUSD/USDJPY**: se il PDF ha ragione, PF(AUDUSD, USDJPY) **≤** PF dei forex
"dormienti" sulla **stessa** finestra (cella 0 di R220a-d). Se AUDUSD/USDJPY vengono **meglio** dei
dormienti, la lista nera del PDF è **falsificata su BCM** — ed è un risultato.

### 4.3 La frontiera del costo `stop ≥ 40 × spread`, simbolo per simbolo
Stop alla gestione di default = `1 × ATR(14,H1)` letto alle 05:00 server (r.220). Spread alle h05
server da `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` (04-11/09/2026, GG=5).

| simbolo | spread h05 mediana (P95) | stop = ATR(14,H1) | stop/spread | verdetto di costo |
|---|---|---|---:|---|
| AUDUSD | `[NON MISURATO]` (fuori dal logger) | `[NON MISURATO]` | — | ⚪ non promuovibile finché non misurato |
| USDJPY | 0,3 pip (1,0) | `[NON MISURATO]` | serve ≥ 12 pip | ⚪ non promuovibile finché non misurato |
| XAUUSD | 0,25 USD (0,28) | ~12,8 USD `[DERIVATO, grossolano]`: ampiezza notte 41,6 USD × quota oraria media 30,9% (`NOTTE_ORO.md` r.7-25) | ~51× | 🟢 sopra, **ma non è un ATR misurato** |
| XAGUSD | `[NON MISURATO]` (snapshot 0,041 USD, sonda r.58: non è una mediana) | `[NON MISURATO]` | — | ⚪ non promuovibile finché non misurato |
| D30EUR | 2,8 punti (2,8) | 51,5-58,5 `[DERIVATO]` (M30 36,4-41,4 × √2, `ATR_DAX_M30_RICONCILIAZIONE` r.14-17) | **18,4-20,9×** | 🔴 **ESCLUSO PER COSTO** alla gestione di default (sopra il duro 13,3×, sotto il 40×) |
| U30USD | 2,0 punti (3,0) | 78,05-88,25 `[MISURATO]`, tutte le ore (`ANCORA_ADR_FLOTTA_INDICI` r.409) | **39,0-44,1×** (26-29× al P95) | 🟠 **FRAGILE**, a cavallo |

⚠️ Sui due indici l'ATR alle 05:00 pesa le **ore quiete** della notte, quindi è semmai **più basso**
della banda usata: il rapporto vero è semmai **peggiore**. Direzione nota, ampiezza `[NON MISURATO]`.
👉 **D30EUR si gira lo stesso** (3,3 minuti): dà frequenza e rischio, e la strada per rientrare nel
costo è un asse d'**uscita** (`InpSLatrMult` 2,0 → 103-117 punti = 36,8-41,8× `[DERIVATO]`), stadio 2.

### 4.4 Le soglie, congelate prima (identiche in tutti i file, §5-§6 di ciascuno)
- **S0** ancora non riprodotta → **round non letto** finché non si sa perché.
- **S1** cella di misura a 0 operazioni, o rapporto op/feriale IS/OOS fuori da 0,5-2,0 → **prima il
  disco** (prima data M1), poi il PF (classe 590).
- **S2** n < 150 in una finestra → **merito sospeso**; il rischio si legge (Emendamento B).
- **S3** DD > 10% @1% in una finestra → **fuori per rischio alla gestione di default**. **Non è un
  certificato di morte**: il punto ③ (uscita ad asse) resta vuoto fino allo stadio 2.
- **S4** frontiera del costo sotto 40× → **nessuna cella promuovibile**, qualunque PF.
- **S5** PF ≥ 1,10 in IS e OOS → **solo screening passato**: serve `-Modello 4` (muro tick forex
  2024.07.05 `[INFERITO]` per AUDUSD/USDJPY; indici 2024.09.26 `COMPLETO`; metalli `[NON MISURATO]`)
  e la molteplicità (~25%) va scritta accanto.
- 🎯 **Centro dell'altopiano**: in stadio 1 **non c'è un altopiano da leggere** (una cella di misura
  per simbolo, nessuna selezione dentro il simbolo). Si leggerà nello stadio 2, sugli assi d'uscita.

### 4.5 Il costo in tempo macchina
| file | celle | giorni | minuti [STIMA, tetto] |
|---|---:|---:|---:|
| AUDUSD, USDJPY | 2 + 2 | 2.737 | 7,7 + 7,7 |
| XAUUSD, XAGUSD, D30EUR, U30USD | 2 × 4 | 642 | 3,3 × 4 |
| **totale** | **12 celle = 24 passate** | | **~29 min** |

Formula di casa (classe 625): `avvio 2 min + celle × 0,670 × giorni/642`. Ancora: **R202A** su
`DESKTOP-H4D7CAJ`, 0,670 min/cella su 642 giorni — ma era **-Modello 4**, quindi per il -Modello 1
di R259 è un **tetto**, non una media. Le celle ancora (zero operazioni) costano semmai meno.

### 4.6 I prerequisiti, da controllare PRIMA di lanciare (costo: zero passate)
1. **Barre M1 sul disco di `DESKTOP-H4D7CAJ`** per i sei simboli (l'EA legge il box da `PERIOD_M1`,
   r.183-190). Noto: AUDUSD M1 **COMPLETO dal 1993.04.26** (`R102_REFERTO_DRIVER_BLOCCO1…txt`
   r.486-487, macchina `[NON VERIFICATO]`); D30EUR/U30USD M1 **COMPLETO dal 2024.09.26**
   (`ABTG_StoricoScaricato.csv`). **USDJPY**: `[NON MISURATO]`, e c'è un indizio **contro**
   (`LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` r.292: scarico M1 2018+ ancora aperto). **XAUUSD,
   XAGUSD**: `[NON MISURATO]`.
2. **Round sul PC di backtest, mai sul VPS** (firma 21/09): il banco `50504400` resta spento.
3. **Nessuna riga di lancio è uscita da qui**: prima di qualunque riga servono `controlla_riga.py` e
   l'agente `controllo-preventivo` (cancello del 09/09). `controlla_prova.py` l'ho girato io: **6/6 OK**.

---

## 5. 🔜 LO STADIO 2 — NON scritto, e il perché
Sui simboli che passano **S0 e S1** (misura vera, campione non troncato), l'uscita va messa ad asse
**una manopola per file**, come `R220a-d`: `InpTPfrac`, `InpCloseAtCutoff` (chiudere alle 07:00 non è
**mai** stato provato: 20 CSV su 20 a `false`), `InpSLatrMult`, e i **due lati separati**
(`InpAllowLong`/`InpAllowShort`, mai isolati — regola dei due lati sugli indici, 25/08).
- 🔴 **La trappola d'unità, da scrivere nei file dello stadio 2**: `InpSLpips`, `InpEdgeOffsetPips`,
  `InpMinRangePips`, `InpMaxRangePips` sono tutti in **"pip" di `PipSize()`**, che su oro/indici vale
  `_Point` = **0,01**. Un `InpSLpips=20` sul Dow sono **0,20 punti**, non 20. È la stessa classe di
  `MaxMinNotte` EURUSD (`InpBufferPoints=1000` = 100 pip, `I_CSV_A_ZERO` r.187).
- Perché non adesso: lo stadio 2 dipende da S0/S1, e su un simbolo che non riempie non c'è uscita
  da misurare. **Due round da 12-24 passate fatti bene, non uno da 100.**

---

## 6. 🪑 E IL 1° OTTOBRE?
🔴 **Da R259 una sedia schierabile per il 1° ottobre NON esce**: è OHLC (screening), sui quattro
non-forex il merito è atteso sospeso per n, e ogni verde va riconfermato a tick e sul costo. Quello
che **esce davvero** è: **sei certificati di morte che smettono di essere vuoti** (o sei occasioni
che smettono di essere invisibili), la **frequenza** del motore più veloce della flotta notturna sui
simboli che nessuno ha mai visto, e la **risposta a una regola del PDF** (la lista nera JPY/AUD).
È **misura**, non ponteggio — ma non è ancora una sedia, e lo scrivo così.

---

## 7. 🕳️ BUCHI DICHIARATI
| # | buco | come si chiude | costo |
|---|---|---|---|
| 1 | ATR(14,H1) **alle 05:00** su tutti e sei | l'EA lo stampa già (r.234-235: `QB %.1f`) nel log dell'agente; il driver **non raccoglie** i log degli agenti (`walkforward_generico.ps1`, nessuna occorrenza) → lettura a mano sul PC di backtest, oppure una sonda | minuti |
| 2 | spread h05 di AUDUSD e XAGUSD | aggiungerli ad `ABTG_SpreadLogger` (gira dal 04/09) | zero passate |
| 3 | barre M1 di USDJPY/XAUUSD/XAGUSD su `DESKTOP-H4D7CAJ` | Archivio storico → M1 → prima data | zero passate |
| 4 | `.ex5` sul banco = `.mq5` a HEAD | hash all'avvio della corsa | zero |
| 5 | il modello nullo è binomiale a operazioni **indipendenti**: le due pendenti della stessa notte non lo sono | è una **stima** e lo resta: nessun numero di R259 si giudica contro di lei, serve solo a dire quanto rumore aspettarsi | — |
| 6 | l'indizio sul costo di XAUUSD (~51×) è una **mediana di rapporti × una mediana**, non un ATR | buco 1 | — |
| 7 | la finestra d'archivio dei non-forex è **un solo regime** (set. 2024 → giu. 2026) | nessuna via nativa: lo storico BCM indici parte lì | — |
| 8 | `ABTG_Nightly_Ottimizzato` (971701: offset 2, SL 1,25×ATR, TP 0,3): **nessun CSV** | fuori da questo referto: è un set di parametri d'**ingresso** scelto senza misura su un motore a PF < 1,10, la regola del 19/08 lo esclude | — |

---

## 8. 🧪 I CONTRO-ESEMPI — provati a rompere, non a confermare
| l'obiezione | cosa dicono i dati | esito |
|---|---|---|
| *"`InpMaxNightVolPips=0` cambia anche lo stop, quindi il motore non è lo stesso"* | r.220: `slDist = InpSLatrMult*(qb>0?qb*pip:range)`; `qb` è calcolato a r.212 **prima** del cancello e **indipendentemente** da `InpMaxNightVolPips` | ✅ regge: cambia solo il cancello |
| *"le celle ancora sono passate buttate"* | sono l'unico modo di sapere, **dentro** il round, se il binario sul banco è quello citato. Su XAGUSD l'ancora è **numerica** (0/4, +50,82) | ✅ regge |
| *"con QB=0 sui forex dormienti il motore sarebbe diverso da quello misurato"* | vero solo se il cancello a 45 pip mordeva sui forex; i numeri del PDF (7-22 pip) e il fatto che l'ATR sia in pip veri lo rendono **[INFERITO] raro**. **Non misurato**, e scritto così | 🟡 inferenza dichiarata |
| *"AUDUSD/USDJPY: riaprire contro il PDF è inseguire un numero"* | no: la tesi è **del PDF**, e la corsa può solo **confermarla** (PF ≤ dormienti) o **falsificarla**. Nessun parametro d'ingresso si muove | ✅ regge |
| *"la causa di XAGUSD è chiusa"* (`I_CSV_A_ZERO` r.203) | IS a zero con OOS a 4 non è spiegato dal solo QB senza un ATR misurato; storico M1 mancante predice lo stesso zero | 🔴 **riaperta**, e R259 d la chiude |
| *"PF 1,15 su 100 operazioni = candidato"* | il nullo arriva a **1,50** al 95% a n=100 | ✅ la soglia di lettura è il segno, non la promozione |

---

## 9. ✅ COSA HO CONTROLLATO, E CON CHE ESITO
- `python3 backtest_pipeline/controlla_prova.py backtest_pipeline/prove/R259_*.txt` → **6 file, 12 celle,
  24 passate, 0 problemi, ESITO: OK** (pin=31 per file: 30 fissi + 1 asse).
- **ASCII puro** nei sei file prova (`grep -P '[^\x00-\x7F]'` → 0 righe).
- **Magic** `787261-787266`: nessuna occorrenza nel repo prima di R259.
- **Numero di round**: R256-R257 liberi, **R258 è di un altro agente** (`ANALISI_PDF_LONDRA_2026-09-26.md`
  r.9), R259 libero.
- 🔴 **NON fatto da me**: lo strato 2 del cancello (agente `controllo-preventivo`) e nessuna riga di
  lancio. **Nessun backtest, nessun EA toccato, nessun forward toccato, nessun rischio o taglia proposti.**

_Fonti principali: `mql5/Experts/ABTG_Nightly.mq5` (HEAD), `backtest_pipeline/risultati_prove/ABTG_Nightly/`
(20 CSV + referto P0), `backtest_pipeline/prove/R220a_slpips_nightly_EURCHF.txt`,
`backtest_pipeline/caccia_strategie/ANALISI_NIGHTLY_PDF_2026-08-23.md`, testo estratto del PDF (33 pagine),
`report/I_CSV_A_ZERO_PERCHE_2026-09-22.md`, `report/TRASFORMAZIONI_CANDIDATE.md`,
`report/RIESAME_MORTI_NOTTURNI_2026-09-22.md`, `data/spread_vivo/`, sonda `215D85D7_ABTG_InfoBroker.csv`._
