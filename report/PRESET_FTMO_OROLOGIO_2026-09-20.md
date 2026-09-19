# 🕐 I PRESET PER L'OROLOGIO FTMO — la rimappatura, il `.set` mancante, e due cose che l'ora non risolve

**20/09/2026, notte** · richiesta: *«due buchi bloccanti per domenica notte, e sono tutti e due meccanici»*
🎯 Bussola: le sedie devono essere **schierabili domenica sera** su FTMO. Questo documento è ponteggio, ma è
il ponteggio senza il quale sette sedie partono **due ore prima del mercato che abbiamo misurato**.

> ## ✅ **10 PRESET RIMAPPATI** · ✅ **il `.set` di `770260` È ricostruibile dalla fonte grezza, ed è fatto**
> ## 🔴 **E ho trovato TRE cose che nessuno aveva chiesto e che valgono più della rimappatura** — §⑥

---

## ① 🧮 IL NUMERO, PRIMA DI TUTTO IL RESTO — e da dove viene

| | fuso | fonte |
|---|---|---|
| ora italiana (oggi, CEST) | **UTC+2** | calendario |
| server **BCM** | **UTC+1** (= italiana − 1) | `CLAUDE.md`, regola fissa |
| server **FTMO** | **UTC+3** (= italiana + 1) | `docs/REGOLAMENTO_FTMO_2026-08.md` r.130, testuale |

> # ➡️ **FTMO = BCM + 2.** Un preset non rimappato parte **due ore prima**. È certo, non probabile.

---

## ② 📋 LA TABELLA DELLA RIMAPPATURA — sedia per sedia, input per input

**27 valori spostati su 10 file.** La colonna «ora italiana» è il controllo di senso: deve
descrivere lo stesso momento di mercato prima e dopo.

| sedia | input | BCM | **FTMO** | che momento è (ora italiana) |
|---|---|---:|---:|---|
| **`770101`** DAX Apertura | `InpSessionHour` | 8 | **10** | 09:00 IT — apertura DAX |
| | `InpCloseHour` | 17 | **19** | 18:30 IT — flat |
| **`770411`** MaxMin DAX Short | `InpBoxStartHour` | 23 | **1** 🔴 | 00:00 IT — inizio box notturno *(cambia GIORNO, vedi §③)* |
| | `InpBoxEndHour` | 4 | **6** | 05:59 IT — fine box |
| | `InpPlaceHour` | 7 | **9** | 08:59 IT — piazzamento pendenti |
| | `InpEntryCutoffHour` | 8 | **10** | 09:30 IT — cutoff ingressi |
| | `InpCloseHour` | 17 | **19** | 18:30 IT — flat |
| **`770202`** Dow Apertura | `InpSessionHour` | 14 | **16** | 15:30 IT — apertura Wall Street |
| | `InpCloseHour` | 17 | **19** | 18:30 IT — flat |
| **`771531`** EMA200 Dow | `InpCutoffHour` | 19 | **21** | 20:00 IT — ⚪ **INERTE** (`InpUseCutoff=false`) |
| | `InpFridayCloseHour` | 20 | **22** | 21:00 IT — ⚪ **INERTE** (`InpFridayClose=false`) |
| **`770511`** SuperWave DOW | — | — | — | 🛑 **NESSUNO, e mi fermo qui invece di sommare** — §③ |
| **`770402`** MaxMin ORO | `InpBoxStartHour` | 23 | **1** 🔴 | 00:00 IT — inizio box *(cambia GIORNO)* |
| | `InpBoxEndHour` | 4 | **6** | 05:59 IT |
| | `InpPlaceHour` | 7 | **9** | 08:00 IT |
| | `InpEntryCutoffHour` | 8 | **10** | 09:30 IT |
| | `InpCloseHour` | 17 | **19** | 18:30 IT |
| **`770260`** Nasdaq RETEST | `InpSessionHour` | 14 | **16** | 15:30 IT — apertura Nasdaq |
| | `InpCloseHour` | 17 | **19** | 18:30 IT — flat |
| **`771202`** PostNews FOMC | `InpActionHour` | 19 | **21** | 20:40 IT — 40′ dopo lo statement |
| | `InpExpiryHour` | 20 | **22** | 21:45 IT |
| | `InpFridayCloseHour` | 21 | **23** | 22:50 IT |
| **`771204`** PostNews ECB | `InpActionHour` | 14 | **16** | 15:00 IT — 15′ prima della BCE |
| | `InpExpiryHour` | 17 | **19** | 18:15 IT |
| | `InpFridayCloseHour` | 21 | **23** | 22:50 IT |
| **`771203`** PostNews NFP | `InpActionHour` | 13 | **15** | 14:45 IT — 45′ prima dell'NFP |
| | `InpExpiryHour` | 16 | **18** | 17:59 IT |
| | `InpFridayCloseHour` | 21 | **23** | 22:50 IT 🔴 *(l'unica che opera di venerdì — §④)* |

### I file
Tutti in **`mql5/Presets/FTMO/`**. 🚫 **Nessun originale è stato toccato.**

| sedia | originale (BCM, invariato) | file FTMO |
|---|---|---|
| `770101` | `mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` | `ABTG_DAX_Apertura_EU_770101_FTMO.set` |
| `770411` | `mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set` | `ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set` |
| `770202` | `mql5/Presets/ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set` | `ABTG_Dow_Apertura_US_770202_FTMO.set` |
| `771531` | `mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set` | `ABTG_EMA200_771531_FTMO.set` |
| `770511` | `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_SuperWave_DOW_H1_Ottimizzato_770511.set` | `ABTG_SuperWave_DOW_H1_770511_FTMO.set` |
| `770402` | `mql5/Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set` | `ABTG_MaxMinNotte_ORO_770402_FTMO.set` |
| `770260` | `mql5/Presets/ABTG_Nasdaq_Apertura_US_RETEST_770260.set` 🆕 **nato oggi, §⑤** | `ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` |
| `771202` | `mql5/Presets/ABTG_PostNews_FOMC_EURUSD.set` | `ABTG_PostNews_FOMC_EURUSD_771202_FTMO.set` |
| `771204` | `mql5/Presets/ABTG_PostNews_ECB_EURUSD.set` | `ABTG_PostNews_ECB_EURUSD_771204_FTMO.set` |
| `771203` | `mql5/Presets/ABTG_PostNews_NFP_USDJPY.set` | `ABTG_PostNews_NFP_USDJPY_771203_FTMO.set` |

Il generatore è in repo e si rilancia in dieci secondi:
**`backtest_pipeline/rimappa_preset_ftmo.py`**. La rimappatura non è stata battuta a mano.

---

## ③ 🌙 I DUE CASI IN CUI NON HO SOMMATO E BASTA

### 🔴 Il box notturno (`770411`, `770402`): **23:00 → 01:00, e cambia giorno**
- **BCM**: box da **23:00 del giorno PRIMA** a **04:59 di oggi** — scavalla la mezzanotte.
- **FTMO**: box da **01:00 a 06:59 DELLO STESSO GIORNO** — **non scavalla più**.
- **È lo stesso istante reale**: 22:00 → 03:59 UTC in tutti e due i casi.

**Controllato nel sorgente, non assunto.** `ComputeBox()` — `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`
r.203-206 e `ABTG_MaxMinNotte.mq5` r.305-306 — contiene:
```
   if(tStart>=tEnd) tStart-=86400;   // il box inizia il giorno prima (notte)
```
Con `23>=4` il ramo **scatta** (box di ieri). Con `1<6` il ramo **non scatta** (box di oggi).
👉 **L'assenza dello scavalco nella versione FTMO è CORRETTA, non una dimenticanza**, e la
finestra coperta è identica al minuto (dimostrato in §④, contro-esempio 2).
Ordine preservato: box < piazzamento < cutoff < flat, tutti dentro lo stesso giorno server.

### 🛑 `770511` SuperWave: **non ho spostato niente, e questa è la risposta giusta**
```
InpUseTimeWindow=false
InpStartHour=0
InpEndHour=24
```
- `InpUseTimeWindow=false` → la finestra **non viene mai valutata** (EA r.315).
- `0` e `24` **non sono un orario**: sono *«tutto il giorno»*, che è invariante per fuso.
- Sommare +2 darebbe **2 e 26**: `26` non è un'ora valida, e `2–26` sarebbe una finestra
  **inventata e più stretta** dell'originale.
👉 Il file FTMO di `770511` differisce dall'originale per **zero righe** di input. Dichiarato, non subìto.

---

## ④ 🧪 IL CONTRO-ESEMPIO — calcolato, non argomentato

Regola di casa del 10/09: *«se l'attesa è una banda, va provata contro l'IPOTESI ALTERNATIVA,
non contro il nulla»*. L'ipotesi alternativa qui è **il delta +1** — l'errore naturale di chi
legge *«FTMO = italiana +1»* e lo applica a un preset già in ora BCM.

```
==============================================================================
CONTRO-ESEMPIO 1 -- 770101 DAX: l'ora nuova e' LO STESSO ISTANTE di quella vecchia?
==============================================================================
  preset BCM   08:00 BCM  -> 2026-09-21 07:00 UTC
  preset FTMO  10:00 FTMO -> 2026-09-21 07:00 UTC  UGUALE: True
  apertura DAX 09:00 IT   -> 2026-09-21 07:00 UTC  COINCIDE: True
  ALTERNATIVA  09:00 FTMO -> 2026-09-21 06:00 UTC  scarto dalla verita': -60 min
  --> l'alternativa NON cade dentro: la misura DISCRIMINA. Un +1 al posto
      del +2 farebbe partire la sedia un'ora PRIMA dell'apertura del DAX.

==============================================================================
CONTRO-ESEMPIO 2 -- 770411 MaxMin DAX: il BOX che scavalla la mezzanotte
==============================================================================
  BCM  (23:00 / 04:59): ramo scavalco SCATTA = True
       finestra reale: 2026-09-21 22:00 UTC -> 2026-09-22 03:59 UTC
  FTMO (01:00 / 06:59): ramo scavalco SCATTA = False
       finestra reale: 2026-09-21 22:00 UTC -> 2026-09-22 03:59 UTC
  IDENTICHE: True
  --> il ramo 'tStart-=86400' non scatta piu', e NON deve scattare:
      la finestra coperta e' la stessa al minuto.

  CONTRO-ESEMPIO INTERNO -- e se avessi sommato +2 SENZA guardare il codice,
  lasciando 25:00? o se avessi tenuto 23:00 pensando 'e' notte lo stesso'?
    FTMO con 23:00 non rimappato -> 2026-09-21 20:00 UTC -> 2026-09-22 03:59 UTC
    copre 7 ore invece di 5 : box SBAGLIATO, non 'quasi giusto'.

==============================================================================
CONTRO-ESEMPIO 3 -- 771203 NFP venerdi: la chiusura settimanale regge?
==============================================================================
  InpFridayClose 21:50 BCM -> 2026-10-02 20:50 UTC
  InpFridayClose 23:50 FTMO-> 2026-10-02 20:50 UTC  UGUALE: True
  margine prima della chiusura del mercato (21:00 UTC): 10 min su BCM, 10 min su FTMO
  giorno della settimana visto dal server FTMO alle 23:50: Friday -> l'EA pretende day_of_week==5 (venerdi): OK
  --> se il +2 fosse sbagliato e fosse +3, InpFridayCloseHour sarebbe 24:
      ora NON VALIDA, e la riga non chiuderebbe MAI. Il criterio e' netto.

==============================================================================
CONTRO-ESEMPIO 4 -- la griglia delle candele: quali TF sopravvivono al +2?
==============================================================================
   M15  passo 0.25h  ->  griglia IDENTICA fra BCM e FTMO
   H1   passo 1.00h  ->  griglia IDENTICA fra BCM e FTMO
   H2   passo 2.00h  ->  griglia IDENTICA fra BCM e FTMO
   H4   passo 4.00h  ->  griglia DIVERSA (2h non e' multiplo del passo)
   D1   passo 24.00h  ->  griglia DIVERSA (2h non e' multiplo del passo)
   --> l'unico TF in uso che si rompe e' H4, e l'unica sedia che ne dipende
       DAVVERO e' 770202 (InpUseEmaFilter=true, InpFilterTF=16388).
```

### Cosa dimostra, in una riga per contro-esempio
1. **`770101`**: 08:00 BCM e 10:00 FTMO sono **lo stesso istante UTC**, e quell'istante **è**
   l'apertura del DAX. L'alternativa (+1) cade **60 minuti fuori** → la misura **discrimina**.
2. **`770411`**: le due configurazioni coprono **la stessa finestra UTC al minuto**, nonostante
   il ramo dello scavalco si comporti in modo opposto. E il contro-esempio interno mostra che
   *non* rimappare avrebbe prodotto un box di **7 ore invece di 5** — sbagliato, non «quasi giusto».
3. **`771203`**: la chiusura del venerdì resta a **10 minuti esatti** dalla chiusura settimanale
   su tutti e due i broker, e alle 23:50 FTMO il server vede ancora **venerdì** (l'EA pretende
   `day_of_week==5`). E se il delta fosse +3, `InpFridayCloseHour` sarebbe **24**: ora non valida,
   la riga non chiuderebbe mai → **il criterio è netto**, non sfumato.
4. **le griglie dei TF**: uno sfasamento di 2h lascia **identiche** M15/H1/H2 e **rompe** H4 e D1.
   È da qui che esce il rilievo su `770202` (§⑥).

---

## ⑤ 📄 IL `.set` DI `770260` — ricostruito, e ogni valore ha la sua fonte

### 🪦 Prima: **il file non è mai esistito in repo**, e non è «sparito»
```
git log --all --oneline -S"770260" -- '*.set'    ->  VUOTO
git log --all --diff-filter=D --name-only -- '*770260*'  ->  VUOTO
```
👉 Non è stato cancellato: **non è mai stato committato**. È una **classe nuova** — un artefatto
descritto come *validato* («80 input, copertura verificata nei due versi») che **non è mai
entrato nel controllo di versione**. → **CLASSE 475** in `CHECKLIST_RIGA_DI_LANCIO.md`.

### La fonte grezza, trovata e usata
`backtest_pipeline/risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_IS.csv` e
`..._OOS.csv`, **riga `Pass=8`** (`InpEntryMode=2` RETEST + `InpUseVolumeFilter=1`).

| finestra | PF | n | DD equity |
|---|---:|---:|---:|
| IS 26/09/2024 → 30/06/2025 | 1,14498 | 91 | 5,9528% |
| OOS 01/07/2025 → 30/06/2026 | **1,10936** | **94** | **3,6753%** |

✅ **Contro-prova fatta**: i **78** input della riga `Pass=8` sono **identici nelle due finestre**
(confronto automatico, **0 discordanze**). Se non lo fossero, «la cella» non esisterebbe.

### 🔴 La copertura contro **HEAD**, non contro `3af47ed9` — ed è cambiata
| binario | n. input |
|---|---:|
| `2ce7abce` (**quello che ha prodotto il CSV**) | **78** |
| `3af47ed9` (quello contro cui il referto del 18/09 dichiarava la copertura) | **80** |
| **HEAD** (con la toppa per ticket del 19/09) | **98** |

> ## 🔴 **HEAD ha 18 input che nel binario del round NON ESISTEVANO.** Un `.set` da 80 righe,
> oggi, **ne lascia 18 al default senza che nessuno l'abbia deciso.**

Il `.set` che consegno ne pinna **98 su 98**. I 18 nuovi sono **tutti inerti al default**, e
l'ho verificato **leggendo il gating**, non fidandomi del nome:

| input | default | perché è inerte | riga |
|---|---|---|---|
| `InpUseVolRegime` | `false` | `if(InpUseVolRegime)` … `if(!InpUseVolRegime) return;` | 470 · 1905 · 1966 |
| `InpUseSRFilter` | `false` | `if(!InpUseSRFilter) return(false);` *«percorso di default: esce subito»* | 485 · 1984 |
| `InpRunnerTP_R` | `0.0` | `<0` niente cap, `>0` cap; **`0` = storico 3R** | 1690-1691 |
| `InpMinBreakoutRangeATR` | `0.0` | `if(InpMinBreakoutRangeATR > 0)` → a 0 il pendente resta nudo | 777 |
| `InpMaxPosSimbolo` | `0` | `if(InpMaxPosSimbolo > 0 && …)` → 0 = nessun limite | 723 |
| `InpTrailStartR` | `0` | `(InpTrailStartR <= 0) \|\| …` → arma subito, come prima | 2224 |
| gli altri 12 (`InpVol*`, `InpSR*`) | vari | letti **solo** dentro i due `if` spenti qui sopra | — |

### 🔴 **La sola eccezione, e la dichiaro: `InpUsaGuardian`**
Non esisteva nel binario del round: **quel round ha girato SENZA Guardian.** L'ho messo a
**`true`**, in linea con le altre sei sedie. È conservativo **in una direzione sola**: il Guardian
può solo **rifiutare** un ingresso, mai aggiungerne uno → il campione in campo sarà **≤** quello
misurato, mai **>**. 👉 **Se si vuole il replay esatto del round, va messo a `false`.** Scritto
nell'intestazione del file.

### 📰 Il filtro notizie: **SPENTO**, e per **tre** ragioni indipendenti
1. **La fonte grezza dice `InpUseNewsFilter=0`**: la cella è stata *misurata* col filtro spento.
   Accenderlo darebbe una configurazione **mai misurata**.
2. **In Challenge FTMO non c'è nessuna restrizione news**: il filtro non serve a passare un cancello.
3. 🔴 **Misurato stanotte: `mql5/Files/abtg_news.csv` è in ORA ITALIANA, non in ora server.**
   FOMC **2026.01.28 → 20:00** (14:00 ET *inverno* = 19:00 UTC = 20:00 IT) e FOMC
   **2026.07.29 → 20:00** (14:00 ET *estate* = 18:00 UTC = 20:00 IT): **segue il DST europeo**.
   L'EA lo confronta con `TimeCurrent()`, che è **ora server**, e `InpNewsShiftMinutes=0` ovunque.
   👉 Acceso così, il blackout cadrebbe **un'ora tardi su BCM** e **un'ora presto su FTMO**.
   Sul repo generico `ABTG_Nasdaq_Apertura_US.set` (sedia **`770201`**, un'altra sedia)
   `InpUseNewsFilter=true`: **quel preset ha una rete messa nel posto sbagliato.**

🟢 **E i tre PostNews NON hanno questo problema**, e l'ho verificato invece di assumerlo:
`NewsToday()` (r.263-277) confronta **solo anno/mese/giorno**, non l'ora; il loro file è
**UTC puro** (`costruisci_news_postnews.py` r.34); gli eventi di quella famiglia stanno fra le
**12:15 e le 20:00 UTC** = 15:15–23:00 FTMO, **stesso giorno di calendario**.
👉 `InpNewsShiftMinutes` resta **0**. Nessuna riga news toccata.

---

## ⑥ 🔴 LE TRE COSE CHE L'OROLOGIO NON RISOLVE — e che nessuno aveva chiesto

### 🟠 **A) `SCHIERA_FTMO.ps1` copia i preset in ORA BCM e lascia il +2 a mano a Claudio**
Lo script è comparso in `backtest_pipeline/righe/` mentre lavoravo (altra sessione, **non l'ho
toccato**, era nell'elenco dei vietati). La sua tabella dei preset (rr.195-204) punta a
`mql5/Presets` e `mql5/Presets/sedie_piccolo/recupero2` — cioè **agli originali BCM**.
✏️ **E qui devo correggermi prima di consegnare, perché la prima lettura era ingenerosa.**
Il referto gemello `report/SCHIERAMENTO_FTMO_2026-09-20.md` (altra sessione, stessa notte) **sa
benissimo** che serve il +2: lo mette come **passo 8 della sequenza**, testuale — *«caricare i
preset + 🔴 rimappare gli orari (+2h) + la taglia … 🔴 20-30 min … il passo più lungo e il più
facile da sbagliare»* — e lo fa fare **a mano a Claudio dentro MT5**, input per input.

> ## 🟢 **Quindi non è un difetto altrui: è un LAVORO MANUALE che questi dieci file CANCELLANO.**
> 20-30 minuti di digitazione a mano, alle due di notte, su sette sedie — descritti dall'altra
> sessione stessa come *«il più facile da sbagliare»* — diventano **caricare un file**.

🔴 **Resta però l'azione concreta**: la tabella dei preset di `SCHIERA_FTMO.ps1` va **ripuntata su
`mql5/Presets/FTMO/`**, altrimenti copia gli originali BCM e il passo manuale torna obbligatorio.
**Tre righe**, ma qualcuno deve farle — e **io non tocco quel file** (è nella lista dei vietati).

E la sua tabella ha altri due scostamenti dalla rosa firmata:
- **manca `770402` MaxMin ORO**, che è una delle **sette** firmate da Claudio il 19/09;
- cerca `sedia_ABTG_Nasdaq_Apertura_US_770260.set` in `recupero2`: **quel nome non esiste**.
  Il file vero è quello nato stanotte (§⑤).

### 🔴 **B) DUE originali per quattro sedie, e differiscono sul RISCHIO**
| sedia | `mql5/Presets/…_100K.set` *(base che ho usato)* | `…/recupero2/sedia_….set` *(base di `SCHIERA_FTMO.ps1`)* |
|---|---|---|
| `770101` | `InpRiskPercent=0.65` · `InpUsaGuardian=true` | **`1`** · *riga Guardian assente* · niente `InpAllowReverse` |
| `770411` | `0.65` · Guardian `true` · `InpMaxSpread=0` | **`1.0`** · *assente* · `InpMaxSpread=500` |
| `770202` | `0.65` · Guardian `true` | **`1.0`** · *assente* |
| `771531` | `0.65` · Guardian `true` · `InpLogImbuto=true` | **`1.0`** · *assente* · niente `InpLogImbuto` |

> ## ✍️ **QUESTO È UN PARAMETRO DI RISCHIO: NON LO DECIDO IO.**
> Ho scelto la famiglia **`_100K` (0,65% + Guardian)** perché 0,65% è la taglia firmata e il cap
> **C1 = 3,25% = 5 × 0,65** è tarato su quella; `recupero2` è la famiglia del **demo piccolo
> 50503392**. Su un 100k FTMO con **perdita giornaliera al 5%**, `1,0%` × 5 posizioni aperte
> **è il limite giornaliero in un colpo solo**.
> **La scelta è scritta nell'intestazione di ognuno dei quattro file** e va **confermata da Claudio**.
> Se la firma dicesse `recupero2`, si rigenera in dieci secondi col generatore.

### 🔴 **C) `770202` dipende da una candela **H4**, e la griglia H4 NON sopravvive al +2**
`InpUseEmaFilter=true` · `InpFilterTF=16388` (**H4**) · `EmaFast=1` · `EmaSlow=50`
(`ABTG_Dow_Apertura_US.mq5` r.262, 405-406).
| server | dove si aprono le candele H4 |
|---|---|
| **BCM** (UTC+1) | 23 · 03 · 07 · 11 · 15 · 19 **UTC** |
| **FTMO** (UTC+3) | 21 · 01 · 05 · 09 · 13 · 17 **UTC** |

> ## 🔴 **Sono griglie DIVERSE** (2h di sfasamento su un passo di 4h): la EMA(50) su H4 **non vale
> gli stessi numeri del backtest**, e il bias long/short al momento dell'ingresso **può essere opposto**.

**Non è un input orario e NON l'ho toccato** — non era nel mandato e non è aggiustabile per somma.
Va **misurato o firmato**. 🟢 **Contro-verifica che limita il danno**: ho controllato tutte le
altre sedie e **nessun'altra** dipende da H4 o D1 in modo **attivo**:
- `770260` ha `InpFilterTF=H4` ma **`InpUseEmaFilter=false`** → inerte;
- `770402` usa `InpMgmtTF=16386` (**H2**): lo sfasamento di 2h è **esattamente un passo H2** →
  griglia **identica**, EMA200 e ATR di gestione leggono le stesse candele;
- `770101` / `770411` / `771531` / `770511` → M5/M15/H1: griglie **identiche**;
- gli ADR/prev-day (D1) sono tutti dietro interruttori **spenti** (`InpUseAdrFilter=false`,
  `InpUseSRFilter=false`, `InpUseGapFill=false` o inerte sotto RETEST).

---

## ⑦ 🔬 IL DIFF AUTOMATICO — la prova che **solo le ore** sono cambiate

**Verifica meccanica** (dentro `rimappa_preset_ftmo.py`, gira a ogni generazione): per ogni file
si confrontano le righe **non-commento** una a una; ogni differenza deve stare nell'elenco
**dichiarato** degli input orari di quella sedia, **e il conteggio deve tornare esatto**.

```
  770101  righe non-commento 82  differenze 2  fuori elenco 0  OK
  770411  righe non-commento 52  differenze 5  fuori elenco 0  OK
  770202  righe non-commento 81  differenze 2  fuori elenco 0  OK
  771531  righe non-commento 44  differenze 2  fuori elenco 0  OK
  770511  righe non-commento 50  differenze 0  fuori elenco 0  OK
  770402  righe non-commento 52  differenze 5  fuori elenco 0  OK
  770260  righe non-commento 98  differenze 2  fuori elenco 0  OK
  771202  righe non-commento 28  differenze 3  fuori elenco 0  OK
  771204  righe non-commento 28  differenze 3  fuori elenco 0  OK
  771203  righe non-commento 32  differenze 3  fuori elenco 0  OK
  ESITO GLOBALE: PASS
```

E il diff riga per riga, `diff` di sistema, commenti esclusi:

```diff
### ABTG_DAX_Apertura_EU_770101_FTMO.set
3c3
< InpSessionHour=8
---
> InpSessionHour=10
6c6
< InpCloseHour=17
---
> InpCloseHour=19

### ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set
3c3
< InpBoxStartHour=23
---
> InpBoxStartHour=1
5c5
< InpBoxEndHour=4
---
> InpBoxEndHour=6
9c9
< InpPlaceHour=7
---
> InpPlaceHour=9
11c11
< InpEntryCutoffHour=8
---
> InpEntryCutoffHour=10
13c13
< InpCloseHour=17
---
> InpCloseHour=19

### ABTG_Dow_Apertura_US_770202_FTMO.set
3c3
< InpSessionHour=14
---
> InpSessionHour=16
6c6
< InpCloseHour=17
---
> InpCloseHour=19

### ABTG_EMA200_771531_FTMO.set
27c27
< InpCutoffHour=19
---
> InpCutoffHour=21
40c40
< InpFridayCloseHour=20
---
> InpFridayCloseHour=22

### ABTG_SuperWave_DOW_H1_770511_FTMO.set
(nessuna differenza: vedi nota 770511)

### ABTG_MaxMinNotte_ORO_770402_FTMO.set
2c2
< InpBoxStartHour=23
---
> InpBoxStartHour=1
4c4
< InpBoxEndHour=4
---
> InpBoxEndHour=6
8c8
< InpPlaceHour=7
---
> InpPlaceHour=9
10c10
< InpEntryCutoffHour=8
---
> InpEntryCutoffHour=10
12c12
< InpCloseHour=17
---
> InpCloseHour=19

### ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set
2c2
< InpSessionHour=14
---
> InpSessionHour=16
5c5
< InpCloseHour=17
---
> InpCloseHour=19

### ABTG_PostNews_FOMC_EURUSD_771202_FTMO.set
1c1
< InpActionHour=19
---
> InpActionHour=21
3c3
< InpExpiryHour=20
---
> InpExpiryHour=22
21c21
< InpFridayCloseHour=21
---
> InpFridayCloseHour=23

### ABTG_PostNews_ECB_EURUSD_771204_FTMO.set
1c1
< InpActionHour=14
---
> InpActionHour=16
3c3
< InpExpiryHour=17
---
> InpExpiryHour=19
21c21
< InpFridayCloseHour=21
---
> InpFridayCloseHour=23

### ABTG_PostNews_NFP_USDJPY_771203_FTMO.set
2c2
< InpActionHour=13
---
> InpActionHour=15
4c4
< InpExpiryHour=16
---
> InpExpiryHour=18
28c28
< InpFridayCloseHour=21
---
> InpFridayCloseHour=23
```

**27 righe cambiate su 10 file, tutte e 27 sono input orari. Zero altro.**
Ogni file FTMO porta in testa lo **sha1(12) dell'originale**: se l'originale cambia, il file va rigenerato.

---

## ⑧ 🗓️ IL CAMBIO DI ORA DI FINE OTTOBRE — questi file hanno una scadenza

| data | cosa succede |
|---|---|
| **domenica 25 ottobre 2026** | finisce il **DST europeo** (IT passa a UTC+1, BCM a UTC+0) |
| **domenica 1 novembre 2026** | finisce il **DST americano** |

- 🟢 **Se FTMO e BCM cambiano lo stesso giorno** (entrambi su DST europeo): il delta **resta +2**
  e **non si tocca niente**. È lo scenario più probabile — `report/CACCIA_MARKET_2026-08-23.md`
  §9.3 scrive *«il reset FTMO è alle 00:00 CE(S)T, cioè segue l'ora legale europea»*.
- 🔴 **Se FTMO seguisse il DST AMERICANO** (cosa non rara sui broker EET), **fra il 25/10 e il
  01/11 il delta diventerebbe +3 per una settimana**, e **tutti** gli input orari andrebbero
  spostati di **un'altra ora** per quei sette giorni.
- 🔴 **E anche il lato BCM è una VERIFICA APERTA**: lo stesso referto la tiene in elenco come
  **M9** — *«verifica di ottobre: l'orologio BCM segue l'ora legale?»*, **mai chiusa**.

### 📌 La misura da mettere in calendario per il **25/10/2026** — una sola, su tutti e due i lati
> Con i terminali accesi, confrontare l'**ora dell'ultima candela M1** con l'**ora UTC**, su
> **FTMO** e su **BCM**, **prima e dopo** la notte del 25/10. Due numeri, cinque minuti.
> Se il delta non è più +2, si rilancia `backtest_pipeline/rimappa_preset_ftmo.py` cambiando
> `DELTA` e si ricaricano i preset. **La rigenerazione costa dieci secondi: la scoperta tardiva no.**

---

## ⑨ 🔍 COSA HO CONTROLLATO — anche quello che è passato

*(regola di casa: un elenco di soli difetti descrive male la realtà)*

| # | controllo | esito |
|---|---|---|
| 1 | delta +2 ricavato **alla fonte** (regolamento r.130 + regola BCM), non a memoria | ✅ |
| 2 | ogni file FTMO differisce dall'originale **solo** per input orari, verificato a macchina | ✅ **10/10** |
| 3 | conteggio delle differenze **esatto** rispetto all'elenco dichiarato | ✅ **10/10** |
| 4 | contro-esempio sull'ipotesi **+1**: cade 60′ fuori → la misura discrimina | ✅ |
| 5 | scavalco di mezzanotte del box letto **nel sorgente** (`ComputeBox`), non assunto | ✅ |
| 6 | finestra del box **identica al minuto** in UTC prima e dopo | ✅ |
| 7 | ordine degli orari preservato (box < place < cutoff < close; open < close) | ✅ **10/10** |
| 8 | chiusura del venerdì `771203`: stesso margine di 10′, `day_of_week==5` ancora vero | ✅ |
| 9 | griglie dei TF: M15/H1/H2 identiche, **H4 e D1 no** | 🔴 un caso attivo (`770202`) |
| 10 | fuso del calendario `abtg_news.csv` misurato su eventi invernali **ed estivi** | 🔴 è ora **italiana** |
| 11 | fuso del calendario PostNews (UTC) + confronto **solo per data** | ✅ nessun impatto |
| 12 | `.set` `770260` costruito dalla **fonte grezza**, IS vs OOS concordi su 78/78 | ✅ |
| 13 | copertura input `770260` contro **HEAD** (98), non contro `3af47ed9` (80) | ✅ 98/98 pinnati |
| 14 | i 18 input nuovi di HEAD: gating letto riga per riga | ✅ tutti inerti |
| 15 | `InpUsaGuardian` su `770260`: divergenza dal round **dichiarata**, non nascosta | 🟠 dichiarata |
| 16 | tutti e 10 i file in **ASCII puro** (regola 17/08), verificato byte per byte | ✅ |
| 17 | nessun originale toccato — `git status` mostra **solo aggiunte** | ✅ |
| 18 | nessun file della lista vietata toccato (`MISURA_LOTTI_*`, `MIS_SIZING_*`, `SCHIERA_FTMO.ps1`, `ABTG_PostNews_*.set`) | ✅ |
| 19 | copertura `.set` ↔ EA a HEAD per **tutte** le sedie | 🟠 4 lacune preesistenti, §⑩ |
| 20 | collisioni di magic sulle finestre rimappate (classe 473) | ✅ nessuna nuova |

---

## ⑩ 🚧 **NON COPERTO** — per nome, con il perché

| # | cosa **non** ho potuto verificare | perché | chi/come si chiude |
|---|---|---|---|
| **N1** | 🔴 **Che il server FTMO sia davvero UTC+3 oggi.** Tutto il +2 poggia su **una riga di documentazione** (r.130), non su una misura nostra | **non ho il terminale FTMO**: il conto si compra domani | **prima riga da lanciare a terminale acceso**: ora dell'ultima candela M1 vs ora UTC. Se non è +2, si rilancia il generatore con `DELTA` diverso |
| **N2** | 🔴 **Che BCM sia UTC+1 tutto l'anno.** È una regola di casa, e il referto del 23/08 la tiene **ancora aperta** (M9) | niente accesso ai dati BCM da qui | stessa misura di N1, sul terminale BCM, attorno al **25/10** |
| **N3** | 🔴 **Se FTMO segue il DST europeo o americano** | la pagina FTMO dice *«GMT+2 inverno / GMT+3 estate»* **senza la data del cambio** | misura del **25/10** (§⑧), o domanda al supporto |
| **N4** | 🔴 **`_Digits` e nome dei simboli su FTMO.** `InpBufferPoints` e `InpMinStopPts` sono in **punti**: se il Nasdaq/Dow/DAX FTMO ha decimali diversi, i livelli si spostano di **dieci volte** | terminale non disponibile | passo «specifiche simbolo» di `SCHIERA_FTMO.ps1`. Se differisce → **firma di Claudio**, non aggiustamento automatico |
| **N5** | 🔴 **L'effetto NUMERICO dello sfasamento H4 su `770202`** (§⑥C): so che la griglia cambia, **non so di quanto cambia il PF** | serve una ri-corsa del backtest con offset server diverso, e non c'è il tempo stanotte | round dedicato **o** firma che accetta la divergenza. 🔴 **Non è un dettaglio: è l'unica sedia della rosa il cui filtro d'ingresso cambia di fatto** |
| **N6** | 🟠 **Che gli originali PostNews non cambino sotto di me.** Un'altra sessione ci lavora stanotte | `ABTG_PostNews_*.set` era nella lista dei **vietati** | ogni file FTMO porta lo **sha1(12)** dell'originale in testa: se non combacia, si rigenera |
| **N7** | 🟠 **Quattro lacune di copertura `.set` ↔ EA, preesistenti e non mie** — le dichiaro perché nessuno le ha scritte: `770511` non pinna `InpUsaGuardian`, `InpPendingAtr`, `InpSLBufferAtr`, `InpLogImbuto`; `770402` non pinna `InpAutoTest`; `771202` e `771204` non pinnano `InpUsaGuardian`, `InpNewsCommon`, `InpUseOCO`, `InpAutoTest` | **fuori mandato**: non sono input orari, e il mandato dice *«solo le ore»* | tutti i default sono benigni (`InpUsaGuardian=true`, `InpUseOCO=true`, `InpNewsCommon=true`), **ma «benigno per default» non è «deciso»** |
| **N8** | 🟠 **`sedia_ABTG_SuperWave_DOW_H1_Ottimizzato_770511.set` usa `=== testo ====` come commento**, che **non è** la sintassi `.set` (il commento MT5 è `;`). MT5 le legge come nome-input **vuoto** e le ignora — quindi oggi non rompe, ma è un formato non standard | l'ho **lasciato identico** per non sporcare il diff «solo ore» | va ripulito a parte, con il suo commit |
| **N9** | 🟠 **La finestra di ritentativo di `ExpiryCloseCheck` si accorcia di 2 ore su FTMO** (va dall'orario di scadenza fino alla mezzanotte **server**): FOMC passa da 3h14 a 1h14, ECB da 6h45 a 4h45 | è una conseguenza **matematica** del fuso, non un input | 🟢 impatto atteso **nullo**: la chiusura avviene al **primo tick** dopo la scadenza e il mercato è aperto. È un **margine di robustezza** che cala, non un comportamento che cambia. `771203` non è toccata (`InpCloseAtExpiry=false`) |
| **N10** | ⚪ **Non ho provato a caricare i preset in MT5.** Un `.set` malformato si scopre caricandolo | nessun MT5 qui | primo caricamento sul terminale FTMO: **controllare che il numero di input letti sia quello atteso** |

---

## ⑪ ✋ COSA **NON** HO FATTO, per mandato
🚫 Nessun originale in `mql5/Presets/` modificato · 🚫 nessun rischio, lotto, magic o soglia
toccato · 🚫 conto reale **10105439** mai nominato se non per escluderlo · 🚫 nessun forward,
nessun round · 🚫 `MISURA_LOTTI_U30USD.ps1`, `ABTG_MIS_SIZING_*`, `MIS_SIZING_*`,
`SCHIERA_FTMO.ps1`, `ABTG_PostNews_*.set` **letti ma mai scritti** · 🚫 niente è uscito verso Claudio.

---

## ⑫ 🔀 NOTA DI CANTIERE — collisione di numero di classe, risolta

Le mie due classi nuove erano nate **474** e **475**. Nella stessa ora un'altra sessione ha
committato una classe **474** sua (*«il pin dell'EA e il pin del suo `.mqh` sono una decisione
sola»*): **due grep corretti, lo stesso numero**. Risolta **dal mio lato**, senza toccare niente
di loro: le mie sono diventate **475** e **476** e sono state spostate **dopo** la loro, così il
file resta in ordine crescente e i loro referti restano coerenti.
📌 È il precedente già usato in casa (*«classi 472/473, rinumerate da 470/471»*) — ma segnala una
cosa vera: 🔴 **«cerca il numero col grep» non basta quando più sessioni scrivono in parallelo.**
Chi passa di qui per ultimo controlla i duplicati prima di chiudere.

---

*Fonti: `docs/REGOLAMENTO_FTMO_2026-08.md` r.130 · `CLAUDE.md` (fuso BCM) ·
`backtest_pipeline/risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` riga `Pass=8` ·
`mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` a HEAD, `2ce7abce`, `3af47ed9` ·
`mql5/Experts/ABTG_MaxMinNotte{,_DAX_Short_Ottimizzato}.mq5` `ComputeBox()` ·
`mql5/Experts/ABTG_Dow_Apertura_US.mq5` r.262/405-406 · `mql5/Experts/ABTG_PostNews.mq5` r.263-277/439-450 ·
`mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.315 · `mql5/Files/abtg_news.csv` ·
`backtest_pipeline/costruisci_news_postnews.py` r.34 · `report/CACCIA_MARKET_2026-08-23.md` §9.3 e M9 ·
`report/NASDAQ_RETEST_VOLUMI_LA_SEDIA_2026-09-18.md` · `report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` B6 ·
`backtest_pipeline/righe/SCHIERA_FTMO.ps1` rr.195-204 (letto, non toccato).
Generatore: `backtest_pipeline/rimappa_preset_ftmo.py`.*
