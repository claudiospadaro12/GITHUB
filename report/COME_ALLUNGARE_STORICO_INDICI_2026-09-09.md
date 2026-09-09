# 📈 COME ALLUNGARE LO STORICO SUGLI INDICI — referto operativo (09/09/2026)

_Missione chiesta da Claudio: **"cerchiamo di capire come fare ad aumentare lo
storico sugli indici... Io voglio migliorare qualsiasi cosa sia possibile"**.
Agente in cloud, branch `lavoro`, **zero EA toccati, zero preset, zero forward,
zero download pesanti, zero commit**. Tutto quello che segue e' letto nei
referti agli atti o verificato oggi sul web; dove non lo so c'e' scritto
`[NON MISURATO]`._

---

# 🔴 0. IL PREZZO DELL'OPERAZIONE — SI LEGGE PRIMA, NON DOPO

> ## ⚠️ **UNO STORICO ESTERNO NON HA LO SPREAD DI BCM, NON HA I SUOI ORARI DI SEDUTA E NON HA I SUOI PREZZI.**
> Quindi un round su dati esterni **misura il MERCATO, non il CONTO**.

**Cosa NON produce, mai, per nessuna ragione:**
- ❌ **niente contratti** — nessun DD promesso, nessuna frequenza promessa
  (`report/CENSIMENTO_CONTRATTI.md` non si scrive con dati _EXT);
- ❌ **niente promozione di celle**, niente taratura di parametri: e' la
  decisione **D-C `SOLO_PROVA_REGIME`** firmata il 25/08
  (`backtest_pipeline/risultati_archivio/STORICO_INDICI_CRITERI.md`);
- ❌ **niente verdetti a tick reali**: i simboli `_EXT` sono **barre M1
  importate**, il **modello 4 su questi simboli NON ESISTE**
  (`importa_storico_esterno.ps1` r. 525, citato in `R113_CRITERI.md` §1).
  E la differenza fra i due banchi e' **MISURATA in casa, non temuta**:
  **SupRev_DOW_H4 fece PF 2,77 in OHLC e PF 0,79 a tick reali** (contratto
  REVOCATO il 30/07).

**Cosa SI PUO' legittimamente concludere — e non e' poco, e' esattamente il
buco di oggi:**
- ✅ **la FORMA dell'edge attraverso i REGIMI**: verde/rosso, dove il motore
  vive e dove muore. Un PF 1,3 contro 1,5 fra due finestre _EXT e' rumore di
  banco; **un verde contro un rosso e' informazione** (`R113_CRITERI.md` §1);
- ✅ **la corsia del RISCHIO** — l'Emendamento B di casa dice
  _"il vecchio giudica il RISCHIO"_: un DD del 25% nel 2020 e' **un fatto
  accaduto**, e si legge anche su un feed diverso;
- ✅ **la FREQUENZA relativa fra epoche** (R113 ha scoperto proprio cosi' che
  il motore SupRev nel 2020-2022 **quasi non opera**);
- ✅ **lo screening veloce**: taglia i morti in fretta a tre settimane dalla
  challenge, e questo vale.

**E il numero che rende concreto il prezzo** (BCM, misurato il 17/08 e il
07/09): spread **NASUSD 180 pt = 1,80 punti indice**, **U30USD 200 = 2,00**,
**D30EUR 280 = 2,80**, **225JPY 35 = 35 punti indice**. Un feed esterno non ha
nessuno di questi numeri dentro: nel tester lo spread e' **quello che si
imposta**, e su stop stretti sposta il verdetto (**R55: 1,5 punti indice
sfondano il cancello del 10% sull'ORB**).

> 🎯 **Tradotto in una riga da ripetere in testa a ogni round _EXT:**
> _"Questo round dice SE il motore sopravvive a un altro mondo. NON dice
> quanto guadagna nel nostro."_

---

# 📊 1. LO STATO ESATTO, OGGI — indice per indice

## 1.1 🏦 Quello che abbiamo **DA BCM** (nativo)

Fonte: `backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`
(sezione `[SIMBOLI]`, conto **50503392**, 17/08/2026) — **59 simboli su 59
interrogati**, colonna `Stato`.

| simbolo BCM | che cos'e' | prima data H1 | barre H1 | stato | spread |
|---|---|---|---:|---|---:|
| **NASUSD** | Nasdaq 100 CFD | **2024.09.26** | 10.861 | 🔴 `COMPLETO` | 180 pt |
| **U30USD** | Dow Jones CFD | **2024.09.26** | 10.859 | 🔴 `COMPLETO` | 200 pt |
| **D30EUR** | DAX CFD | **2024.09.26** | 10.553 | 🔴 `COMPLETO` | 280 pt |
| **SPXUSD** | S&P 500 CFD | **2024.09.26** | 10.860 | 🔴 `COMPLETO` | 140 pt |
| **225JPY** | Nikkei 225 CFD | **2024.09.26** | 11.009 | 🔴 `COMPLETO` | 35 pt |
| **E50EUR** | Euro Stoxx 50 CFD | **2024.09.26** | 7.499 | 🔴 `COMPLETO` | 200 pt |
| **F40EUR** | CAC 40 CFD | **2024.09.26** | 6.713 | 🔴 `COMPLETO` | 170 pt |
| **100GBP** | FTSE 100 CFD | **2024.09.26** | 10.338 | 🔴 `COMPLETO` | 160 pt |
| **200AUD** | ASX 200 CFD | **2024.09.26** | 10.345 | 🔴 `COMPLETO` | 160 pt |
| **E35EUR** | IBEX 35 CFD | **2024.09.26** | 5.423 | 🔴 `COMPLETO` | 540 pt |

> ### 🎯 **`COMPLETO` e' la parola che chiude la questione: non manca sul disco — il broker NON CE L'HA.**
> Ed e' stato **riconfermato con una misura fresca l'08/09** sul terminale
> nuovo (`report/STORICO_MT5BACKTEST_ESITO_2026-09-08.md`,
> `backtest_pipeline/risultati_archivio/ABTG_StoricoScaricato.csv`):
> **D30EUR M1 643.567 · M5 129.930 · TICK 35.496.307** — prima data
> **2024.09.26**; **U30USD M1 668.718 · M5 133.819 · TICK 68.558.736** —
> prima data **2024.09.26**. **NASUSD: 166,5 M tick** dal 2024.09.26
> (`report/ROUND_USCITE_SUPERTREND_2026-09-09.md` §6.3, misura 07/09).
>
> 👉 **~21 mesi e UN SOLO REGIME (un toro).** E' scritto senza sconti anche in
> `report/PERCHE_MUOIONO_2026-09-08.md` §3.3: _"non e' possibile, con i dati
> che abbiamo, distinguere 'hanno un edge' da 'erano dalla parte giusta del
> toro'"_.

📌 **Nota che NON vale per gli indici ma va detta per non ripetere l'errore
del 17/08**: sul forex/metalli il "2010.07.06" era **il tetto delle 100.000
barre del grafico**, non il broker (USDJPY parte dal **1971.01.03**, GBPUSD dal
**1993.05.11**, XAUUSD dal **2004.06.11**). **Sugli indici quella scappatoia
non c'e'**: 10.338-11.009 barre H1 sono **sotto** il tetto, quindi il numero e'
il dato vero del broker. (Cfr. `REFERTO_SONDA_STORICO_17-08.md` §3-bis.)

## 1.2 🌍 Quello che abbiamo **DA FONTI ESTERNE** — e dove sta fisicamente

### ✅ NASUSD_EXT — **c'e', e' IMPORTATO, ed e' FUORI DAL FRIGO**

| voce | valore | fonte |
|---|---|---|
| barre M1 | **5.233.590** (0 scartate) | `risultati_archivio/STORICO_INDICI_20260826_2320/ABTG_ImportEsterno_referto.csv` |
| periodo | **2010.11.14 23:01 → 2026.07.31 21:13** | idem |
| serie M15 | **362.325** barre, 2010.11.14 → 2026.07.31 | `.../ABTG_ContaBarreEXT.csv` |
| serie H1 | **93.085** barre, stesso periodo | idem |
| shift calibrato | **+5** (automatico, scansione ±6) | idem |
| copertura H1 vs nativo | **97,0%** (10.497 barre confrontate) | idem |
| diff media H1 | **0,0756%** (v1) · **0,0662%** fuori-finestre DST (v2) | `import_ext_v2_referto_2026-08-19.csv`, cit. §15 REFERTO_HISTDATA |
| CSV sorgente sul PC | `C:\Users\Master\abtg_storico_indici\NASUSD_M1.csv`, **347,2 MB** | `ANATOMIA_APERTURE_20260826/CENSIMENTO_FONTE.txt` |
| **stato** | 🟢 **AMMESSO alla prova di regime** — firma **"FIRMO FRIGO NASUSD"**, Claudio 26/08 | `prove/PROVA_REGIME_CRITERI.md` §2 |

✅ **Ed e' gia' stato USATO davvero**: **R113** (27/08, 18/18 celle, 0 problemi)
ha girato 16 anni di Nasdaq su 6 finestre di regime — `R113_REFERTO.md`.
**Su 16 anni quel motore non e' mai esploso: DD massimo dell'intero round
1,81%.** La macchina funziona: non e' teoria.

### 🧊 SPXUSD_EXT — c'e', e' importato, **resta in frigo**

**4.598.932** barre M1, **2010.11.14 → 2026.07.31**; M15 **360.619**, H1
**92.932**; shift **+5**; copertura **97,0%**; diff **0,0608%** (v1) /
**0,0527%** fuori-finestre. Rapporto sul metro relativo **0,203 contro 0,20**:
🧊 **sopra per un pelo → FRIGO** (`LETTURA_MISURE_LAMPO_2026-08-26.md` §1).

### 🧊 225JPY_EXT — importato (finestra corta), **in frigo**

**2.357.431** barre M1, **2019.01.01 → 2026.07.31** (§14 REFERTO_HISTDATA).
diff **0,1010%** (v1) / **0,0871%** fuori-finestre; rapporto **0,232** → 🧊
**FRIGO**. ⚠️ **NON e' mai stato riscaricato sulla finestra 2010-2026**
(D-B firmata solo su `NASUSD,SPXUSD`).

### 🧊 U30USD_DK (Dow, Dukascopy tick) — scaricato, importato, **in frigo**

| voce | valore | fonte |
|---|---|---|
| finestra scaricata | **2024-10-01 → 2025-06-16**, **222/222 giorni** | `risultati_archivio/duka/REFERTO_DUKA_A_20260903_2216_COMPLETA.txt` |
| prodotto | **9 CSV tick mensili, 870,9 MB** in `C:\Users\Master\dukascopy_lavoro\tick` | idem |
| import in MT5 | ✅ eseguito il 03/09 22:43, 9 CSV copiati | `duka/REFERTO_IMPORT_SONDA_2026-09-03_2243.txt` |
| sonda | **5/6 giorni dentro soglia**, peggiore **0,0696% il 2024.11.20** | idem |
| **stato** | 🧊 **CANCELLO CHIUSO per lettera del criterio** (il 20/11/2024 non e' un giorno DST) → FRIGO | `backtest_pipeline/REGISTRO_TEST.md` r. 1185 |

> ⚠️ **E attenzione a cosa NON e' questa finestra**: 2024-10 → 2025-06 sta
> **DENTRO** lo storico nativo BCM. Era la **validazione del decoder**, non
> storia in piu'. **Del Dow profondo (2012+) non e' stato scaricato un byte.**

### ❌ D30EUR (DAX) esterno — **NON ESISTE ancora niente di usabile**

`grxeur` di HistData e' **BOCCIATO** (§2.2 qui sotto). Dukascopy `DEUIDXEUR`
esiste dal **2012** ma la corsa del 18/08 e' stata **interrotta** dopo
**25 giorni su 2.389 in 1h43m**. **Nessun `D30EUR_EXT` e nessun `D30EUR_DK`
esiste.** (Il dubbio lasciato aperto in `CACCIA_M30_INDICI_2026-09-08.md` r.661
_"D30EUR_EXT non trovato"_ **e' chiuso qui: non esiste.**)

⚠️ Esiste pero' un file fuorviante sul PC: `C:\Users\Master\histdata_m1\D30EUR_M1.csv`,
**133,3 MB**, scritto il 18/08 (`DIAGNOSI_DAX_20260826/CENSIMENTO_ZIP_DAX.txt`).
**E' il grxeur bocciato**: il nome BCM ce l'ha, la qualita' no. **Non va
importato.**

## 1.3 🖥️ IL PUNTO CHE NESSUNO HA ANCORA GUARDATO — **dove vivono questi simboli**

- I simboli `_EXT` e `_DK` sono stati creati sul **PC di backtest
  `DESKTOP-H4D7CAJ`**, terminale `C:\Program Files\BCM Markets MT5 Terminal`
  (dichiarato: _"E' il PC di BACKTEST, non il VPS"_,
  `righe/RIGA_DUKA_IMPORT_SONDA_DA_MANDARE.md` r.21).
- Ma dall'**08/09** i round girano sul **quarto terminale, sul VPS:
  `C:\MT5_Backtest`, conto demo 50504400**
  (`report/STORICO_MT5BACKTEST_ESITO_2026-09-08.md`).

> 🔴 **`[NON MISURATO]`: se `NASUSD_EXT` esista su `C:\MT5_Backtest`.**
> I simboli personalizzati **non migrano da soli** fra terminali. Se non c'e',
> ogni round _EXT o si rifa' l'import li' (i CSV sono sul PC di casa, non sul
> VPS) o gira sul PC di casa. **E' un costo reale del piano, e va misurato
> prima di prometterlo — non dopo.**
> ⚠️ E vale la **regola dei terminali multipli**: sul VPS esiste **anche** un
> `C:\Program Files\BCM Markets MT5 Terminal` che e' il **piccolo 50503392, in
> forward**. Stesso percorso, macchina diversa, conto diverso: **qualunque riga
> di import dichiara conto + cartella + macchina, sempre.**

---

# 🛑 2. PERCHE' SI E' FERMATA — la diagnosi, letta nei referti

## 2.1 ⚖️ IL CANCELLO ZERO: la formula esatta e la soglia esatta

**Definizione congelata** (`backtest_pipeline/prove/PROVA_REGIME_CRITERI.md`
§2, 14/08/2026):

> differenza media **> 0,05% del prezzo**, **oppure** meno dell'**80%** delle
> barre H1 in comune → **il simbolo NON si usa**.

**La formula, letta nel sorgente** — `mql5/Scripts/ABTG_ImportaStoricoEsterno.mq5`,
righe **497-511** (verdetto alle righe **639-644**), come riportato in
`ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md` §1:

```
per ogni bucket H1 presente in ENTRAMBI i feed nel periodo di sovrapposizione
(nativo BCM: 26/09/2024 -> fine import):
    diff_i = | Close_H1_importata - Close_H1_nativa |

diffMediaPct = 100 x SOMMA(diff_i) / SOMMA(prezzo_i)        <-- media PESATA sul prezzo

verdetto:  <= 0,05%  -> OK CONFRONTABILE
           <= 0,20%  -> DIFFERENZE FEED APPREZZABILI
           oltre     -> peggio
```

🔎 **La soglia era tarata sui FOREX**, e lo dice il testo stesso della
correzione del 14/08 (EURUSD_EXT **0,0041%**, GBPUSD_EXT **0,0052%** citati
come prova che _"passano larghi"_). **Gli indici, quel giorno, non esistevano
come `_EXT`.**

### 🖊️ E il metro E' STATO EMENDATO — con una firma e con misure

**"FIRMO FRIGO NASUSD", Claudio, 26/08/2026** (`PROVA_REGIME_CRITERI.md` §2).
Per i **soli indici** si aggiunge il **metro RELATIVO**:

> **diff media fuori-finestre ≤ 0,20 × volatilita' oraria misurata** dello
> stesso simbolo, valido **solo** con: (a) eventi di diff-max **spiegati uno
> per uno**, (b) **copertura ≥ 80%**.

**I numeri con cui e' stato applicato** (vol misurata il 26/08 con
`histdata_m1.py --vol-oraria`, `REFERTO_MISURE_LAMPO_20260826.txt`):

| simbolo | diff (fuori finestre) | **vol oraria 2025 MISURATA** | rapporto | esito |
|---|---:|---:|---:|---|
| **NASUSD** | 0,0662% | **0,3324%** | **0,199** | 🟢 **AMMESSO** (bordo sottile, dichiarato) |
| SPXUSD | 0,0527% | **0,2602%** | 0,203 | 🧊 frigo |
| 225JPY | 0,0871% | **0,3747%** | 0,232 | 🧊 frigo |
| EURUSD (controllo) | 0,0041% | 0,1232% (TOT) | 0,033 | ✅ largo, come tutti i forex |

📌 La soglia **0,20** era stata proposta il **25/08** — **PRIMA** di misurare le
volatilita' — come tetto del peggior forex promosso (AUDJPY 0,11-0,23). **Non
e' ritagliata sui numeri degli indici**, ed e' scritto nero su bianco nella
proposta stessa che _"con le stime attuali i tre indici NON passerebbero
comunque"_. Il metro ha bocciato 2 su 3: **non e' stato un condono**.

## 2.2 🩺 IL DAX ESTERNO — perche' e' bocciato, e **qual e' davvero la diagnosi mancante**

**Verdetto R (18/08, §13 REFERTO_HISTDATA) + diagnosi eseguita (26/08,
`DIAGNOSI_DAX_20260826/REFERTO_DIAGNOSI_DAX.txt`, 2,59 min, pin `386346d`):**

| anno | barre | **fuori banda 4.000-45.000** | % | giorni | finestra (ora NY) |
|---|---:|---:|---:|---:|---|
| 2019 | 325.977 | **0** | 0,000 | 0 | 00:00-23:00 |
| **2020** | 259.840 | **108.007** | **41,567** | 143 | **02:00-15:00** |
| **2021** | 187.516 | **59.081** | **31,507** | 103 | **02:00-15:00** |
| **2022** | 205.728 | **175.397** | **85,257** | 224 | **02:00-15:00** |
| **2023** | 159.626 | **3.681** | **2,306** | 8 | **02:00-15:00** |
| 2024 | 332.439 | **0** | 0,000 | 0 | 00:00-23:00 |
| 2025 | 335.844 | **0** | 0,000 | 0 | 00:00-23:00 |
| 2026 | 198.175 | **0** | 0,000 | 0 | 00:00-23:00 |

> ### 🎯 **IL FILE `grxeur` DAL GIUGNO 2020 AL NOVEMBRE 2023 NON CONTIENE IL DAX: CONTIENE UN ALTRO INDICE.**
> Tre misure indipendenti che dicono la stessa cosa
> (`LETTURA_DIAGNOSI_DAX_2026-08-26.md`): (1) la sessione cambia — **42 mesi
> consecutivi** a 02:00-15:00 NY, DENSE (**convenzione diversa, non buchi**);
> (2) i prezzi cambiano scala — 2021 min-max **3.461-4.414**, 2022
> **3.247-4.395**, quando il DAX vero stava a **12.400-16.300**; (3) le
> transizioni combaciano col calendario dei mesi (2020-01→05 max 13.827 = DAX
> vero; 2020-06 scatta; 2023-12 torna normale).

### ✅ Rispondo alla domanda esatta della missione: **quale delle quattro cause e'?**

| ipotesi | verdetto | la misura che lo dice |
|---|---|---|
| **fuso / DST** | ❌ **NON E' QUESTO** | la cura DST-aware (`IMP-EXT-v2`, collaudo 19/08, autotest 41/41) ha **PEGGIORATO** la media del **7,7-8,6%**. E la previsione era stata **pre-registrata** prima del collaudo |
| **basis cash / future / CFD** | ❌ **ESCLUSO, e misurato** | **bias mediano firmato ~0** su tutti e tre: **+0,0013% NASUSD · +0,0062% 225JPY · +0,0075% SPXUSD** (§15). Se HistData quotasse il cash e BCM un CFD-su-future ci sarebbe uno **scalino sempre dallo stesso lato**: non c'e' |
| **dividendi / aggiustamenti** | ❌ stessa risposta: si vedrebbero come bias di segno costante. **Non c'e'** | idem |
| **buchi / barre marce** | ❌ **NON sui tre promossi** — 3 eventi di diff-max su 3 sono **MOVIMENTI VERI** (23/03/2026: NASUSD **3,43%**, 225JPY **5,28%**, SPXUSD **3,66%**; 20/11/2025 ~2,0-2,6%; 09/01/2026 225JPY **3,09%** con **60 barre su 60**) | `LETTURA_MISURE_LAMPO_2026-08-26.md` §2 |
| ✅ **ORARI DI SEDUTA / CONTENUTO DEL FEED** | 🎯 **E' QUESTO** | sul DAX e' **certificato** (42 mesi con sessione e prezzi di un altro indice). Sui tre promossi e' **il residuo che resta**: copertura **97,0%** contro **99,2-99,6%** dei forex = **3 ore su 100 dell'importato non trovano una barra nativa** |

### 🕳️ E LA DIAGNOSI CHE **MANCA DAVVERO** — due buchi, entrambi economici

1. 🔴 **`grxeur` 2010-2018 NON E' MAI STATO GUARDATO.** Il censimento degli
   zip lo dice esplicitamente: cache DAX = **solo 2019-2026**; controllo
   positivo `nsxusd` = **2010→2026** (`CENSIMENTO_ZIP_DAX.txt`). Lo switch
   `-EstendiIndietro` **esiste** in `righe/RIGA_DIAGNOSI_DAX.ps1` (r.158, 859,
   918) ed e' **`NON PROVATO`, dichiarato dal codice stesso** (r.117).
   👉 **Nove anni di DAX — 2010-2018 — che contengono la crisi dell'euro 2011,
   la Cina 2015 e il Volmageddon 2018, non sono mai stati nemmeno scaricati.**
2. 🟡 **Il colpevole del 2020-2023 e' `[INFERITO]`, non misurato.** La lettura
   dice che quei min-max combaciano con l'**Euro Stoxx 50** — ma e'
   un'inferenza. Diventa un **fatto** confrontando `grxeur` 2020-2023 con
   `etxeur` (Euro Stoxx, che HistData ha) **degli stessi anni**: 4 zip.

## 2.3 ⏱️ E l'altra meta' della risposta: **perche' si e' fermata la strada Dukascopy**

**Non e' un problema di dati: e' il RATE LIMIT, ed e' misurato due volte.**
- 18/08, DAX M1: **25 giorni su 2.389 in 1h43m** con 503/reset/timeout/DNS
  continui → **~4 minuti per giorno di storico** → proiezione **~7 giorni di
  crawl**. Interrotta da Claudio con Ctrl+C.
- Tradotto in missioni (`backtest_pipeline/dukascopy/DUKASCOPY_PASSO0.md` §2d):
  **Dow 2019-09→2024-09 (~1.580 giorni) = ~105 ore = 4-5 notti**;
  **Nasdaq 2 anni (~630 giorni) = ~42 ore = 2 notti**.
- 03/09, Dow: **222 giorni completati in 0,2 h** con `curl` invece di
  `urllib` — 🎉 **il motore nuovo e' ~30× piu' veloce del preventivo**, ed e'
  **misurato**, non sperato. ⚠️ Ma su una finestra corta: **`[NON MISURATO]`
  se quel ritmo regge su 12 anni.**

---

# 🛣️ 3. LE STRADE POSSIBILI — ognuna col suo costo e col suo prezzo in onesta'

## 🥇 Strada A — **HistData** (gratis, canale gia' aperto e collaudato)

**✅ VERIFICATO OGGI, 09/09/2026** (fonte riletta adesso, non a memoria:
`dmidlo/histdata.com-tools` → `src/histdatacom/fx_enums.py`, gruppo `indices`):
gli indici di HistData sono **DIECI**, e sono esattamente questi —
`grxeur auxaud frxeur hkxhkd spxusd jpxjpy udxusd nsxusd ukxgbp etxeur`.

| nostro BCM | HistData | copre? | stato oggi |
|---|---|---|---|
| NASUSD | `nsxusd` | ✅ **2010-11 →** | 🟢 **fatto, in casa, fuori dal frigo** |
| SPXUSD | `spxusd` | ✅ 2010-11 → | 🧊 importato, in frigo (0,203) |
| 225JPY | `jpxjpy` | ✅ 2010-11 → | 🧊 in frigo, e solo 2019+ scaricato |
| D30EUR | `grxeur` | 🔴 **inutilizzabile 2020-2023**; **2010-2018 mai guardato** | ❌ |
| E50EUR | `etxeur` | ✅ 2010-11 → | ⚪ **mai toccato** |
| F40EUR | `frxeur` | ✅ 2010-11 → | ⚪ **mai toccato** |
| 100GBP | `ukxgbp` | ✅ 2010-11 → | ⚪ **mai toccato** |
| 200AUD | `auxaud` | ✅ 2010-11 → | ⚪ **mai toccato** |
| — | `hkxhkd` (Hang Seng), `udxusd` (**Dollar Index, NON il Dow**) | — | non ci servono |
| **U30USD** | **— NON C'E' —** | 🔴 **il Dow su HistData NON ESISTE** | ❌ |

**🔴 COSA MANCA, detto forte: il Dow. E il DAX.** Le due sedie piu' grosse del
portafoglio indici (`ORB`, `Apertura US`, `EMA200 Dow`, `SuperWave DOW`) girano
su un simbolo che questa strada **non copre**.

**💰 Costo misurato**: **1 richiesta HTTP per anno** (zip annuale) — la corsa
del 25/08 ha fatto **~10,1 s per anno** su NASUSD, e 17 anni interi +
conversione + import sono usciti in **~10 minuti totali**
(`REFERTO_STORICO_INDICI_RIGA1_20260825.txt`, fasi F5-F7). ⚠️ **Da fare sul PC
di Claudio: dal cloud `www.histdata.com` e' `EGRESS_BLOCKED` — riverificato
oggi, 403 dal proxy.**

## 🥈 Strada B — **Dukascopy** (gratis, tick veri, l'unica che ha il Dow E il DAX)

**✅ MISURATO in casa, sonda a tre giri del 15/08 con controllo positivo
EURUSD passato** (`REFERTO_SONDA_DUKASCOPY.md` §12):

| simbolo Dukascopy | che cos'e' | **primo anno** |
|---|---|---|
| **`USA30IDXUSD`** | **Dow Jones 30** | **2012** |
| **`USATECHIDXUSD`** | Nasdaq 100 | **2012** |
| **`USA500IDXUSD`** | S&P 500 | **2012** |
| **`DEUIDXEUR`** | **DAX 40** | **2012** |
| `GBRIDXGBP` · `FRAIDXEUR` · `EUSIDXEUR` | FTSE · CAC · Stoxx 50 | **2012** |
| `JPNIDXJPY` | Nikkei 225 | **2013** |

**E i nomi sono DECISI, non intuiti**: `US30IDXUSD`, `USA30USD`, `WS30IDXUSD`,
`GERIDXEUR` danno **404 veri** con controllo positivo OK. Coerente con una
fonte terza (dukascopy-node: tick `usa30idxusd` dal **2012-04-04**,
`usatechidxusd` dal **2012-06-14**, cit. `DUKASCOPY_PASSO0.md` r.38-39).

**Come si scarica**: `datafeed.dukascopy.com/datafeed/{SIMBOLO}/{AAAA}/{MM-1}/{GG}/{HH}h_ticks.bi5`
— **mese ZERO-BASED**, file **LZMA**, un file **per ora**. Gli strumenti sono
gia' scritti e autotestati: `backtest_pipeline/dukascopy/dukascopy_m1.py`
(M1, autotest 6/6) e `dukascopy_tick.py` (tick, **autotest 9/9**), con cache
ripresa-gratis, retry 2/5/15/30 s e fail-fast su controllo positivo, ordine
ask/bid e divisore.

**💰 Costo**: 🔴 **il muro e' il rate limit** — vedi §2.3. Con `curl` il ritmo
misurato il 03/09 e' **222 giorni in 0,2 h**; col vecchio motore era **4
min/giorno**. **`[NON MISURATO]` quale dei due regga su 12 anni.**
**Spazio disco**: **~10 GB liberi** per una missione da 5 anni (cache + CSV +
base tick MT5) — da verificare **prima** della riga.

**🎁 Il vantaggio unico**: sono **TICK**, non barre. Un `_DK` che passa il
cancello **puo' portare il modello 4** — cioe' **verdetti veri**, non solo
screening. E' l'unica strada che tocca quel livello.
**🔴 Il prezzo attuale**: `U30USD_DK` e' **in frigo** (0,0696% il 20/11/2024),
e la causa non e' capita. La misura che la separa e' scritta e costa poco:
aprire un grafico `U30USD` M1 per scaricare i tick nativi di **quel giorno** e
rilanciare la sonda con `-SoloSonda` → dice se e' **"non confrontabile"** (tick
nativi assenti = falso allarme) o **disallineamento vero**.

## 🥉 Strada C — **un altro broker MT5, demo gratis** (zero euro, ~un'ora)

**Lo stato vero**: la demo **Pepperstone `62128200`** (`PepperstoneUK-Demo`)
**esiste gia' ed e' stata sondata il 15/08**
(`sonda_storico_17-08/73B7A242_ABTG_InfoBroker.csv`). Ma:

> 🔴 **degli indici non e' stata misurata UNA data.** Nella sezione `[SIMBOLI]`
> ci sono **solo forex**; `GER40` compare **solo** nella sezione `[SESSIONI]`
> e **tutte** le sue righe dicono **`0 barre — da scaricare / nessun dato`**,
> con `VERDETTO_DST: DATI INSUFFICIENTI`. **Il simbolo non era in Market
> Watch: non e' un'assenza, e' una domanda mai fatta.**
>
> E il forex li' e' **corto**: EURUSD **2022.12.13**, GBPUSD/USDJPY
> **2023.01.02**, AUDUSD **2025.07.17**. **`[NON MISURATO]`** se gli indici
> siano piu' profondi.

**Costo per chiudere il buco: ~5 minuti** — aggiungere `US30`/`GER40`/`NAS100`
a Market Watch, aprire un grafico M1 per svegliare il server, rilanciare
`ABTG_InfoBroker` con `InpSondaStorico=true`. **Zero euro, zero codice nuovo,
zero rischio.** E se un broker MT5 avesse indici profondi, il vantaggio e'
enorme: **export nativo MT5, nessun decoder, nessun fuso da indovinare.**
🎯 **E' la casella con il miglior rapporto valore/costo non ancora aperta,
insieme al DAX 2010-2018.**

⚠️ Onesta': anche un altro broker MT5 **resta un feed diverso da BCM** — passa
per lo stesso cancello ZERO, senza sconti.

## 🔬 Strada D — **il FUTURE invece del CFD** (e perche' non risolve il problema che abbiamo)

Un **FDAX** o un **YM** ha storia lunghissima e di qualita' altissima. Ma:

- ❌ **non e' lo strumento su cui operiamo.** Ha **scadenze** (rollover: salti
  di prezzo artificiali ogni trimestre), **orari diversi**, **tick size e
  moltiplicatore diversi**, **niente notte CFD**;
- ❌ una serie "continua" e' **costruita** con una regola di rollover
  (retropolata o no): **una scelta nostra che entra nei prezzi**, cioe'
  esattamente il tipo di cosa che il progetto vieta di fare in silenzio;
- ✅ **cosa SI PUO' concludere**: la **FORMA del regime** (dove sta il toro,
  dove l'orso, dove il crollo) e la **corsia del rischio** in ordine di
  grandezza;
- ❌ **cosa NON si puo' concludere**: niente PF, niente frequenza, niente DD
  spendibile. Il rollover da solo puo' fabbricare o distruggere trade in un
  motore a rottura.

> 📌 **E c'e' un dato di casa che ridimensiona la fama del problema**: il bias
> mediano cash-vs-CFD misurato sui nostri tre indici e' **~0 (+0,0013 /
> +0,0062 / +0,0075%)**. **Fra l'indice cash di HistData e il CFD di BCM non
> c'e' un basis rilevante.** Cioe': **il cash e' gia' un buon sostituto, e il
> future porterebbe piu' problemi (rollover) che vantaggi.**
> 👉 **Proposta: strada D SCARTATA** — non per pigrizia, per un numero.

## 💰 Strada E — **dati a pagamento** 🔴 **SI PROPONE, NON SI COMPRA**

> ⚠️ **Spendere soldi e' una decisione di CLAUDIO** (mandato 08/09). Qui c'e'
> solo l'istruttoria.

**FirstRate Data** (`firstratedata.com`) — l'unico che ho potuto verificare
oggi, e **solo via ricerca web: il dominio e' `EGRESS_BLOCKED` da qui**, quindi
i numeri sono **`[DA VERIFICARE SUL PC]`**, non misurati da me:
- offre **1-min / 5-min / 30-min / 1-hour / 1-day** su **115 indici**;
- **DAX 40 (DAX)**: pagina dichiarata "**15 Years Data**";
  **Nasdaq 100 (NDX)**: "**19 anni**" di intraday;
- 🔴 **prezzo d'acquisto: `[NON MISURATO]`** — non sono riuscito ad aprire la
  pagina prezzi. Quello che ho trovato negli snippet: **~99,95 USD/anno** per
  gli aggiornamenti dopo il primo mese gratuito, e **~59-99 USD/mese** per gli
  aggiornamenti dei bundle. **Due cifre incoerenti fra loro: non le uso come
  numeri, le uso come ordine di grandezza.**

**Vale la pena?** La domanda giusta non e' "e' meglio": e' **"cosa fa che il
gratis non fa?"**
- ✅ **fa**: dati puliti, gia' controllati, senza il mestiere del decoder LZMA
  e senza rate limit → **risparmia GIORNI di lavoro**;
- ❌ **NON fa**: non ha lo spread di BCM, non ha i suoi orari, non ha i suoi
  prezzi. **Passa esattamente per lo stesso cancello ZERO**, e puo' finire in
  frigo come gli altri. **Pagare non compra una promozione.**
- 🎯 **Verdetto onesto**: **non e' urgente.** Il gratis copre gia' 8 indici su
  10 dal 2010, e i due che mancano (Dow, DAX) li ha **Dukascopy dal 2012,
  gratis**. **Si propone come riserva** se e solo se le strade A/B/C
  falliscono — e allora si chiede prima **una demo/campione** per far passare
  il cancello ZERO **prima** di pagare, non dopo.

## 🆕 Strada F — **il PROXY EUROPEO per il DAX** (idea nuova, gratis, ~10 minuti)

Il DAX esterno e' bloccato. Ma HistData ha **`etxeur` (Euro Stoxx 50)** dal
**2010-11**, e **BCM ha `E50EUR` nativo** (7.499 barre H1 dal 2024.09.26): cioe'
**il cancello ZERO e' calcolabile**, esattamente come sul Nasdaq.

- ✅ **Cosa si puo' concludere**: se un motore "da DAX" (rottura di apertura
  europea, ORB EU, gap EU) **sopravvive al 2011, al 2015, al 2018 e al 2020**
  sull'Euro Stoxx, la sua **FORMA** regge in Europa. La correlazione DAX/Stoxx
  e' notoriamente altissima **[NON MISURATA da noi — e va misurata sui 21 mesi
  di sovrapposizione BCM, non assunta]**.
- ❌ **Cosa NON si puo' concludere**: **niente sul DAX come strumento** —
  livelli, ampiezze, spread, sedute sono suoi.
- 💰 **Costo**: 1 zip per anno (~10 s/anno) + import + cancello ZERO.
  **~10-15 minuti** per avere l'esito.

**E il fratello di questa idea**: gli stessi minuti aprono anche **`frxeur`
(CAC → `F40EUR`)**, **`ukxgbp` (FTSE → `100GBP`)**, **`auxaud` (ASX →
`200AUD`)**. Quattro indici mai toccati, **tutti con un gemello nativo BCM su
cui il cancello si calcola**. 🎯 **E questo si sposa con la firma del 07/09:
il pavimento di frequenza si misura per FAMIGLIA — piu' simboli = piu'
portata.** Ma attenzione: **`E35EUR` spread 540 pt e `E50EUR` 200 pt** — la
frontiera `stop ≥ 40 × spread` va rifatta simbolo per simbolo prima di
promettere qualunque cosa.

---

# 🚦 4. IL PROMEMORIA CHE VA RIPETUTO (gia' scritto al §0, si ripete apposta)

1. 🔴 **Dati esterni = SCREENING + PROVA DI REGIME. Mai verdetti, mai
   contratti, mai promozioni.** D-C `SOLO_PROVA_REGIME`, firmata.
2. 🔴 **Parametri CONGELATI.** Si copia la cella viva riga per riga (gate G0-A
   di R113), si cambiano **solo** simbolo, date e magic. Nient'altro.
3. 🔴 **Ogni feed nuovo passa il cancello ZERO**, e il metro relativo vale
   **solo** per gli indici e **solo** con eventi spiegati + copertura ≥80%.
4. 🔴 **Nessuna riga esce senza PASS** dei due strati (`controlla_riga.py` +
   agente `controllo-preventivo`). Se il controllo non e' tornato, **si
   aspetta**.
5. 🔴 **Ogni riga dichiara conto + cartella + macchina.** Sul VPS ci sono
   **quattro** terminali e due si chiamano quasi uguale.

---

# 🗺️ 5. IL PIANO IN PASSI — ordinato per valore/costo

| # | passo | costo misurato/stimato | cosa sblocca | rischio |
|---|---|---|---|---|
| **P1** | 🇩🇪 **`grxeur` 2010-2018**: `RIGA_DIAGNOSI_DAX.ps1 -EstendiIndietro` + `--diagnosi` con `-SogliaDensita` ~41 | **9 zip × ~10 s ≈ 1,5 min di rete + ~3 min di diagnosi = ~5 minuti** | 🎯 **fino a 9 ANNI DI DAX** (crisi euro 2011, Cina 2015, Volmageddon 2018) — o la certezza che non ci sono | nullo (offline dopo il download, nessun import) |
| **P2** | 🖥️ **Sonda indici su Pepperstone `62128200`**: aggiungere `US30`/`GER40`/`NAS100`/`SPX500` a Market Watch, aprire un M1, rilanciare `ABTG_InfoBroker -InpSondaStorico` | **~5 minuti, zero euro** | 🎯 la **prima data vera** degli indici su un secondo broker MT5 — **la casella `[NON MISURATO]` piu' grossa e piu' economica del dossier** | nullo (sola lettura, conto demo terzo) |
| **P3** | 🇪🇺 **Proxy europeo**: scaricare + importare **`etxeur` (E50EUR)** 2010-2026 e calcolare il cancello ZERO | **~10-15 minuti** | 🎯 una **prova di regime europea** su 16 anni, con gemello nativo BCM per il cancello. Se passa, il buco del DAX e' aggirato **in forma** | basso (import in un simbolo `_EXT` nuovo, nessun EA toccato) |
| **P4** | 🔎 **Identificare il contaminante del DAX**: `etxeur` 2020-2023 contro `grxeur` 2020-2023 | **4 zip ≈ 40 s + confronto** | trasforma **`[INFERITO]` in `[MISURATO]`** e chiude definitivamente la scheda `grxeur` in `REGISTRO_TEST.md` (certificato di morte completo) | nullo |
| **P5** | 🗄️ **Verificare dove vivono i simboli `_EXT`**: `NASUSD_EXT` esiste su `C:\MT5_Backtest` (50504400, VPS)? | **~2 minuti** (elenco simboli custom) | evita di scoprire a meta' round che il simbolo non c'e'. **Prerequisito di qualunque round _EXT sul banco nuovo** | nullo (sola lettura) |
| **P6** | 🧊 **Riaprire `U30USD_DK`**: grafico `U30USD` M1 per i tick nativi del **20/11/2024**, poi sonda `-SoloSonda` | **~10 minuti** | dice se il 0,0696% e' **un falso allarme** (tick nativi assenti) o un vero disallineamento. **E' l'unica strada verso il Dow profondo** | nullo (nessun re-import) |
| **P7** | 🇺🇸 **Dow profondo da Dukascopy** — SOLO se P6 dice "falso allarme". Finestra dichiarata, un pezzo per volta, motore `curl` | 🟡 **`[NON MISURATO]` su finestra lunga.** Ancore: 4 min/giorno col vecchio motore (→105 h per 5 anni), **222 giorni in 0,2 h col nuovo**. **Serve una tranche pilota da ~200 giorni per misurare il ritmo vero** | 🎯 il **Dow dal 2012 a TICK** = l'unica strada verso verdetti veri, non screening | medio: rate limit, **~10 GB di disco**, notti di crawl |
| **P8** | 🧊 **SPXUSD_EXT (0,203) e 225JPY_EXT (0,232)**: non riaprire per ora | 0 | — | ⚠️ **si riaprono SOLO con una misura nuova, mai abbassando la soglia.** La soglia 0,20 e' stata fissata **prima** di vedere i numeri: e' quello che la rende valida |
| **P9** | 💰 **Dati a pagamento (FirstRate & simili)**: solo istruttoria, e solo se A/B/C falliscono | prezzo **`[NON MISURATO]`** | — | 🔴 **decisione di Claudio.** E si chiede **un campione gratuito** per far passare il cancello ZERO **prima** di pagare |

## ☀️ LA PRIMA COSA DA FARE DOMANI MATTINA

> # 🇩🇪 **P1 — SCARICARE E DIAGNOSTICARE `grxeur` 2010-2018.**
>
> **Perche' proprio questo, in tre righe:**
> 1. 💥 **E' il buco piu' grosso e piu' economico che abbiamo.** Nove anni di
>    DAX — **il simbolo della sedia `SuperWave DAX` e di mezzo vivaio** — non
>    sono mai stati **nemmeno scaricati**. Costano **cinque minuti**.
> 2. 🎯 **La risposta e' utile in tutti e due i versi.** Se sono puliti come il
>    2019 (0 barre fuori banda, finestra 00:00-23:00), **il DAX lungo esiste
>    da domani** senza aspettare 4 notti di crawl Dukascopy. Se sono marci
>    come il 2020-2023, **`grxeur` chiude con il certificato di morte
>    completo** e la strada DAX passa a Dukascopy **con una decisione, non con
>    un dubbio**.
> 3. ⚖️ **E' esattamente il caso che il motto del 09/09 descrive**: un
>    candidato fermo per un numero **MANCANTE**, non per un numero **BRUTTO**.
>    _"Se potrebbe passare, si insiste."_
>
> **In parallelo, stessa mattinata, perche' non costano niente e non si
> disturbano fra loro: P2** (sonda Pepperstone, 5 min) **e P5** (dove vive
> `NASUSD_EXT`, 2 min).
>
> ⚠️ **E prima che una qualunque di queste righe parta verso Claudio: PASS di
> `controlla_riga.py` E dell'agente `controllo-preventivo`.** Se il controllo
> non e' tornato, **si aspetta** — e' la regola del 09/09, ed e' bloccante.

---

## 🏆 E LA COSA BUONA, che va detta perche' e' vera

Questo dossier sembra un elenco di porte chiuse. **Non lo e'.**

- 🟢 **Sedici anni di Nasdaq sono GIA' IN CASA, importati, validati e usati**:
  5.233.590 barre M1 dal 2010, cancello superato **con una firma e con misure
  vere** (vol oraria misurata, 3 eventi su 3 spiegati), e un round intero
  (**R113, 18/18 celle, 0 problemi**) che li ha girati.
- 🟢 **La macchina completa esiste ed e' collaudata**: scaricatore, decoder,
  convertitore, importatore MQL5, sonda, cancello, tre referti automatici.
  Non c'e' un pezzo da inventare — **c'e' da girare la chiave su piu' simboli.**
- 🟢 **Il basis cash-vs-CFD, il sospetto piu' brutto di tutti, e' MISURATO ed
  e' ~ZERO.** Il feed esterno e il nostro CFD **guardano lo stesso oggetto**.
- 🟢 **Il metro relativo e' stato scritto PRIMA di vedere i numeri e ha
  bocciato 2 candidati su 3.** In un progetto che deve schierare sedie il
  1° ottobre, **avere un metro che boccia e' una notizia buona.**

> ### 🎯 Non ci manca una tecnologia. Ci mancano **cinque minuti di download sul DAX 2010-2018** e **cinque minuti di sonda su una demo che abbiamo gia'**. E' un lavoro da un'ora, non da un mese.

---

_📌 Nessun EA, preset, parametro o forward e' stato toccato da questo referto.
Nessun dato e' stato scaricato (dal cloud `histdata.com`, `dukascopy.com`,
`firstratedata.com`, `stooq.com`, `tickstory.com` sono tutti **`EGRESS_BLOCKED`
/ 403 dal proxy** — riverificato oggi). Nessun commit: committa Claudio._

**Fonti web verificate oggi 09/09/2026:**
[dmidlo/histdata.com-tools — fx_enums.py](https://raw.githubusercontent.com/dmidlo/histdata.com-tools/main/src/histdatacom/fx_enums.py) ·
[dukascopy-python (PyPI)](https://pypi.org/project/dukascopy-python/) ·
[FirstRate Data — DAX 40](https://firstratedata.com/i/index/DAX) ·
[FirstRate Data — Nasdaq 100](https://firstratedata.com/i/index/NDX) ·
[FirstRate Data — US Indices bundle](https://firstratedata.com/b/8/us-index-historic-intraday) ·
[Tickstory — Dukascopy date ranges](https://tickstory.com/dukascopy-historical-data-available-date-ranges/) _(non apribile: egress-blocked, citato solo come esistenza)_
