# 📏 CENSIMENTO DELLA REGOLA DELLA FINESTRA — quali EA la possono rispettare

_Chiesto da Claudio il 16/08 subito dopo aver congelato il punto A
dell'**EMENDAMENTO DELLA FINESTRA** (`CLAUDE.md`): **"è una regola che vale per
tutti?"**. Sì, vale per tutti. Questo file dice **cosa costa**, motore per
motore, con i numeri e non a sentimento._

---

## 1. 🔢 COME È STATO CALCOLATO (metodo dichiarato prima delle tabelle)

- **Fonte:** tutti i CSV `*_OOS_*` archiviati nel repo con l'intestazione
  OPTFRAME — **1.788 file letti**, mediana dei `Trades` per ogni coppia
  EA × simbolo (la mediana e non il massimo: una griglia contiene celle che
  operano molto e celle che non operano quasi).
- **Finestra OOS:** dal `@DAQUANDO` del file prova corrispondente alla fine dei
  dati (`2026.06.30`), moltiplicato per **0,60** (lo split del driver).
- **`trade/anno` = n mediano OOS ÷ anni di OOS.**
- **La regola chiede 150 trade nell'IS *e* 150 nell'OOS = 300 in totale**,
  quindi **anni necessari = 300 ÷ trade/anno**.

⚠️ **[STIMA]** Dove il file prova non esiste ho usato `2024.09.26`, che è il
`@DAQUANDO` di **110 prove su 153**. Per le coppie marcate così il numero è un
ordine di grandezza, non una misura al decimale. **Il verdetto di gruppo non
cambia** (si tratta di distinguere 20 trade/anno da 200), ma il numero singolo
sì.

## 2. 🚨 IL VERO COLLO DI BOTTIGLIA NON È LA REGOLA: **È LO STORICO CHE NON ABBIAMO MAI MISURATO**

| classe | storico su BCM | trade/anno necessari |
|---|---|---:|
| **Forex** (GBPUSD 2010, USDJPY 1971) | **~16 anni** ✅ | **≥ 19** |
| **Indici, metalli, energia** | **21 mesi** (`2024.09.26`) 🔴 | **≥ 170** |

> ### 🔴 Su **155 coppie EA × simbolo**, lo storico è stato **MISURATO** su **DUE** (GBPUSD e USDJPY, la notte del 16/08). Su tutte le altre usiamo `2024.09.26` **per abitudine, non per misura.**

**Questa è la cosa da sistemare per prima, e costa due minuti**: `ABTG_InfoBroker`
/ `ABTG_HistoryDownloader` esistono già. Finché non giriamo la sonda su tutti i
simboli, metà di questo censimento resta una stima.

**E la seconda leva è già pronta e mai usata fino in fondo:** in **R56** è stato
mappato **Dukascopy con otto indici dal 2012**, nomi verificati
(`USA30IDXUSD`, `DEUIDXEUR`…), e la macchina di import è già scritta e collaudata
(6 simboli, 15,2 M barre M1, zero scartate, diff 0,005-0,011%).
**Dodici anni di indici invece di ventuno mesi: è quello che sblocca il Gruppo B.**

## 3. 📊 IL CENSIMENTO

Totale coppie EA x simbolo con CSV OOS archiviati: **155**

- 🟢 ce la fanno GIA' oggi (>=170 trade/anno): **22**
- 🟡 ce la farebbero con storico profondo (18,8-170): **94**
- 🔴 non ce la fanno nemmeno con 16 anni (<18,8): **22**
- ⚰️ ZERO trade (non operano): **17**


### 🟢 GRUPPO A — ce la fanno con i 21 mesi di BCM (>=170 trade/anno)

| EA | simbolo | n OOS (mediana) | trade/anno | anni per 300 trade |
|---|---|---:|---:|---:|
| `ABTG_EMA200` | EURUSD | 662 | 627 | **0.5** |
| `ABTG_EMA200` | 225JPY | 508 | 482 | **0.6** |
| `ABTG_TurnaroundTuesday` | GBPUSD | 497 | 471 | **0.6** |
| `ABTG_EMA200` | U30USD | 456 | 433 | **0.7** |
| `ABTG_ORB_Ottimizzato` | EURUSD | 368 | 349 | **0.9** |
| `ABTG_EMA200` | XAUUSD | 363 | 344 | **0.9** |
| `ABTG_DAX_Live5m` | D30EUR | 352 | 334 | **0.9** |
| `ABTG_ORB_Ottimizzato` | GBPUSD | 350 | 332 | **0.9** |
| `ABTG_ORB` | NASUSD | 308 | 292 | **1.0** |
| `ABTG_ORB_Ottimizzato` | XAUUSD | 288 | 273 | **1.1** |
| `ABTG_DAX_Apertura_EU` | D30EUR | 249 | 236 | **1.3** |
| `ABTG_AltaVelocita` | USDJPY | 228 | 216 | **1.4** |
| `ABTG_ORB_Ottimizzato` | D30EUR | 226 | 215 | **1.4** |
| `ABTG_PTE` | GBPUSD | 254 | 214 | **1.4** |
| `ABTG_DAX_Live5m_v2` | D30EUR | 211 | 200 | **1.5** |
| `ABTG_AltaVelocita` | USDCHF | 200 | 190 | **1.6** |
| `ABTG_AltaVelocita` | U30USD | 199 | 189 | **1.6** |
| `ABTG_Nasdaq_Live5m` | NASUSD | 198 | 188 | **1.6** |
| `ABTG_ORB_Ottimizzato` | NASUSD | 196 | 185 | **1.6** |
| `ABTG_AltaVelocita` | GBPJPY | 195 | 185 | **1.6** |
| `ABTG_AltaVelocita` | AUDUSD | 188 | 178 | **1.7** |
| `ABTG_PTE` | USDJPY | 204 | 171 | **1.8** |

### 🟡 GRUPPO B — servono da 1,8 a 16 anni di storico

| EA | simbolo | n OOS (mediana) | trade/anno | anni per 300 trade |
|---|---|---:|---:|---:|
| `ABTG_ORB_Ottimizzato` | U30USD | 178 | 168 | **1.8** |
| `ABTG_AltaVelocita` | EURUSD | 173 | 164 | **1.8** |
| `ABTG_AltaVelocita` | XAUUSD | 170 | 161 | **1.9** |
| `ABTG_EMA200` | GBPJPY | 169 | 160 | **1.9** |
| `ABTG_EMA200` | GBPUSD | 167 | 158 | **1.9** |
| `ABTG_Nightly` | EURUSD | 164 | 156 | **1.9** |
| `ABTG_Nightly` | GBPUSD | 163 | 155 | **1.9** |
| `ABTG_AltaVelocita` | GBPUSD | 150 | 143 | **2.1** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD | 138 | 131 | **2.3** |
| `ABTG_EMA200` | AUDJPY | 134 | 127 | **2.4** |
| `ABTG_EMA200` | 200AUD | 132 | 125 | **2.4** |
| `ABTG_Nightly` | USDCHF | 131 | 124 | **2.4** |
| `ABTG_Dow_Apertura_US` | U30USD | 130 | 123 | **2.4** |
| `ABTG_EMA200` | SPXUSD | 110 | 104 | **2.9** |
| `ABTG_Nasdaq_Apertura_US` | NASUSD | 100 | 95 | **3.2** |
| `ABTG_MaxMinNotte` | XAUUSD | 92 | 88 | **3.4** |
| `ABTG_EMA200_Ottimizzato` | XAUUSD | 92 | 87 | **3.4** |
| `ABTG_GapContinuation` | 225JPY | 91 | 86 | **3.5** |
| `ABTG_CostToCost` | CHFJPY | 88 | 83 | **3.6** |
| `ABTG_CanaleLento` | XAUUSD | 86 | 82 | **3.7** |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD | 81 | 77 | **3.9** |
| `ABTG_FiboH4_Multi` | GBPJPY | 77 | 73 | **4.1** |
| `ABTG_FiboH4_Multi` | AUDUSD | 77 | 73 | **4.1** |
| `ABTG_FiboH4_Multi` | CADJPY | 77 | 73 | **4.1** |
| `ABTG_FiboH4_Multi` | GBPUSD | 77 | 73 | **4.1** |
| `ABTG_FiboH4_Multi` | EURUSD | 77 | 73 | **4.1** |
| `ABTG_FiboH4_Multi` | USDCHF | 77 | 73 | **4.1** |
| `ABTG_FiboH4_Multi` | USDJPY | 77 | 73 | **4.1** |
| `ABTG_ORB_Fibo` | NASUSD | 75 | 71 | **4.2** |
| `ABTG_WOL` | SPXUSD | 70 | 66 | **4.5** |
| `ABTG_FiboH4_Multi` | XAUUSD | 65 | 62 | **4.9** |
| `ABTG_GoldenCross` | NZDUSD | 65 | 62 | **4.9** |
| `ABTG_SupRev_DOW_H1_Ottimizzato` | U30USD | 65 | 62 | **4.9** |
| `ABTG_GoldenCross_Ottimizzato` | NASUSD | 64 | 61 | **4.9** |
| `ABTG_CostToCost` | EURJPY | 64 | 61 | **4.9** |
| `ABTG_GoldenCross_Ottimizzato` | U30USD | 63 | 60 | **5.0** |
| `ABTG_GoldenCross` | USDCHF | 63 | 60 | **5.0** |
| `ABTG_SuperWave` | GBPUSD | 63 | 60 | **5.0** |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR | 63 | 60 | **5.0** |
| `ABTG_SupertrendReversal` | D30EUR | 62 | 59 | **5.1** |
| `ABTG_SupRev_DAX_H1_Ottimizzato` | D30EUR | 62 | 59 | **5.1** |
| `ABTG_CostToCost` | GBPCAD | 62 | 59 | **5.1** |
| `ABTG_SuperWave` | U30USD | 61 | 58 | **5.2** |
| `ABTG_GoldenCross_Ottimizzato` | D30EUR | 60 | 57 | **5.3** |
| `ABTG_GoldenCross_Ottimizzato` | XAUUSD | 57 | 54 | **5.6** |
| `ABTG_SupRev_DOW_H4_Ottimizzato` | U30USD | 57 | 54 | **5.6** |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | D30EUR | 56 | 53 | **5.6** |
| `ABTG_SupRev_CAC_H4_Ottimizzato` | F40EUR | 56 | 53 | **5.6** |
| `ABTG_SupertrendReversal_Multi_Ottimizzato` | XAUUSD | 56 | 53 | **5.7** |
| `ABTG_GoldenCross_Ottimizzato` | GBPUSD | 55 | 52 | **5.8** |
| `ABTG_SuperWave` | USDJPY | 54 | 51 | **5.9** |
| `ABTG_SuperWave` | GBPJPY | 53 | 50 | **6.0** |
| `ABTG_SuperWave` | D30EUR | 53 | 50 | **6.0** |
| `ABTG_WOL` | GBPUSD | 52 | 49 | **6.1** |
| `ABTG_GoldenCross` | XAUUSD | 52 | 49 | **6.1** |
| `ABTG_GoldenCross_Ottimizzato` | USDJPY | 52 | 49 | **6.1** |
| `ABTG_EasyTrend` | CHFJPY | 52 | 49 | **6.1** |
| `ABTG_EasyTrend` | AUDJPY | 50 | 47 | **6.3** |
| `ABTG_GoldenCross` | USDCAD | 49 | 46 | **6.5** |
| `ABTG_MeanRevert` | GBPUSD | 314 | 46 | **6.6** |
| `ABTG_SupertrendReversal` | E35EUR | 45 | 43 | **7.0** |
| `ABTG_EasyTrend` | GBPUSD | 41 | 39 | **7.7** |
| `ABTG_EasyTrend` | EURUSD | 41 | 39 | **7.7** |
| `ABTG_CostToCost` | XAGUSD | 41 | 39 | **7.7** |
| `ABTG_PTE` | U30USD | 44 | 37 | **8.0** |
| `ABTG_PunteLarry` | U30USD | 38 | 36 | **8.3** |
| `ABTG_SupertrendReversal` | GBPJPY | 36 | 34 | **8.8** |
| `ABTG_WOL` | EURUSD | 36 | 34 | **8.8** |
| `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | 35 | 33 | **9.0** |
| `ABTG_EasyTrend` | EURCAD | 33 | 31 | **9.6** |
| `ABTG_PunteLarry` | EURAUD | 33 | 31 | **9.6** |
| `ABTG_WOL` | U30USD | 32 | 30 | **9.9** |
| `ABTG_WOL` | NASUSD | 32 | 30 | **9.9** |
| `ABTG_SupertrendReversal` | CHFJPY | 32 | 30 | **10.0** |
| `ABTG_EasyTrend` | EURGBP | 30 | 28 | **10.5** |
| `ABTG_SupertrendReversal_Multi` | XAUUSD | 30 | 28 | **10.5** |
| `ABTG_SupertrendReversal` | AUDUSD | 29 | 27 | **10.9** |
| `ABTG_WOL` | USDJPY | 29 | 27 | **10.9** |
| `ABTG_SupertrendReversal` | 225JPY | 26 | 25 | **12.2** |
| `ABTG_BreakingBand` | GBPUSD | 26 | 25 | **12.2** |
| `ABTG_SupertrendReversal` | NASUSD | 25 | 24 | **12.7** |
| `ABTG_SuperWave` | SPXUSD | 25 | 24 | **12.7** |
| `ABTG_PunteLarry` | GBPUSD | 25 | 24 | **12.7** |
| `ABTG_WOL` | XAUUSD | 24 | 23 | **13.2** |
| `ABTG_BreakingBand` | EURUSD | 24 | 23 | **13.2** |
| `ABTG_SupertrendReversal` | XAGUSD | 22 | 21 | **14.4** |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | D30EUR | 21 | 20 | **15.1** |
| `ABTG_GapFill` | F40EUR | 21 | 20 | **15.1** |
| `ABTG_BreakingBand` | EURCAD | 20 | 19 | **15.4** |
| `ABTG_WOL` | XAGUSD | 20 | 19 | **15.8** |
| `ABTG_GapFill` | U30USD | 20 | 19 | **15.8** |
| `ABTG_GapFill` | SPXUSD | 20 | 19 | **15.8** |
| `ABTG_SuperWave` | NASUSD | 20 | 19 | **15.8** |
| `ABTG_PunteLarry` | GBPJPY | 20 | 19 | **15.8** |

### 🔴 GRUPPO C — servono PIU' DI 16 ANNI: la regola non e' soddisfacibile

| EA | simbolo | n OOS (mediana) | trade/anno | anni per 300 trade |
|---|---|---:|---:|---:|
| `ABTG_PTE` | D30EUR | 22 | 18 | **16.2** |
| `ABTG_WOL` | D30EUR | 19 | 18 | **16.7** |
| `ABTG_PunteLarry` | EURCAD | 19 | 18 | **16.7** |
| `ABTG_GapFill` | UKOIL | 18 | 17 | **17.6** |
| `ABTG_GapFill` | 225JPY | 15 | 14 | **21.1** |
| `ABTG_GapFill` | USOIL | 15 | 14 | **21.1** |
| `ABTG_PTE` | 225JPY | 16 | 14 | **21.7** |
| `ABTG_SuperWave` | XAUUSD | 14 | 13 | **22.6** |
| `ABTG_BreakingBand` | GBPJPY | 14 | 13 | **23.4** |
| `ABTG_PTE` | NASUSD | 15 | 13 | **23.8** |
| `ABTG_SupertrendReversal` | XAUUSD | 12 | 11 | **26.4** |
| `ABTG_GapFill` | AUDUSD | 12 | 11 | **26.4** |
| `ABTG_BreakingBand` | AUDUSD | 11 | 10 | **28.8** |
| `ABTG_SuperWave` | 225JPY | 11 | 10 | **28.8** |
| `ABTG_PunteLarry` | XAUUSD | 11 | 10 | **28.8** |
| `ABTG_PTE` | XAGUSD | 12 | 10 | **31.1** |
| `ABTG_PTE` | XAUUSD | 11 | 9 | **32.5** |
| `ABTG_GapFill` | EURUSD | 9 | 9 | **35.2** |
| `ABTG_PTE` | SPXUSD | 10 | 8 | **37.6** |
| `ABTG_BreakingBand` | NZDJPY | 8 | 8 | **39.5** |
| `ABTG_GapFill` | GBPUSD | 8 | 8 | **39.5** |
| `ABTG_Nightly` | XAGUSD | 4 | 4 | **79.1** |

### ⚰️ GRUPPO D — ZERO trade: non operano affatto

| EA | simbolo | n OOS (mediana) | trade/anno | anni per 300 trade |
|---|---|---:|---:|---:|
| `ABTG_PostNews` | EURUSD | 0 | 0 | — |
| `ABTG_PostNews` | EURJPY | 0 | 0 | — |
| `ABTG_SupertrendInvert` | XAGUSD | 0 | 0 | — |
| `ABTG_SupertrendInvert` | XAUUSD | 0 | 0 | — |
| `ABTG_SupertrendInvert` | GBPJPY | 0 | 0 | — |
| `ABTG_SupertrendInvert` | EURUSD | 0 | 0 | — |
| `ABTG_SupertrendInvert` | USDJPY | 0 | 0 | — |
| `ABTG_SupertrendInvert` | 225JPY | 0 | 0 | — |
| `ABTG_SupertrendInvert` | U30USD | 0 | 0 | — |
| `ABTG_SupertrendInvert` | D30EUR | 0 | 0 | — |
| `ABTG_SupertrendInvert` | NASUSD | 0 | 0 | — |
| `ABTG_MaxMinNotte` | EURUSD | 0 | 0 | — |
| `ABTG_Nightly` | U30USD | 0 | 0 | — |
| `ABTG_Nightly` | D30EUR | 0 | 0 | — |
| `ABTG_Nightly` | XAUUSD | 0 | 0 | — |
| `ABTG_Nightly` | AUDUSD | 0 | 0 | — |
| `ABTG_Nightly` | USDJPY | 0 | 0 | — |

---

## 4. 🚦 COSA NE ESCE, IN QUATTRO RIGHE

> **1. 🟢 22 coppie su 155 rispettano la regola OGGI**, con lo storico che
> abbiamo. Sono i motori ad alta frequenza: `EMA200`, `ORB`, `AltaVelocita`,
> le **aperture DAX/Nasdaq/Dow**, `TurnaroundTuesday`. **Su questi la regola
> non cambia niente: la rispettavano già.**
>
> **2. 🟡 94 coppie su 155 sono bloccate SOLO dallo storico**, non dalla
> strategia. Con 12 anni di Dukascopy invece di 21 mesi di BCM, **quasi tutte
> passano.** È il gruppo dove la regola morde, ed è anche quello dove la cura
> esiste già.
>
> **3. 🔴 22 coppie non ce la fanno nemmeno con sedici anni.** `GapFill` su
> EURUSD (8 trade/anno), `SuperWave` su XAUUSD (13), `PTE` su XAGUSD/SPXUSD.
> **Per questi la regola dice una cosa scomoda e vera: non sono misurabili, e
> non lo saranno mai con questi timeframe.** O si scende di timeframe, o si
> accetta che restino non giudicabili sul MERITO — mai sul rischio (valvola R59).
>
> **4. ⚰️ 17 coppie fanno ZERO trade.** `SupertrendInvert` su 9 simboli,
> `Nightly` su 6, `PostNews` su 2. **Non è un problema di finestra: quel codice
> non opera.** Già saputo per `SupertrendInvert` (coda fascia B) e `Nightly`
> (0/8); qui è confermato su tutto l'archivio.

## 5. ➡️ AZIONI, IN ORDINE DI RAPPORTO VALORE/COSTO

1. 🔬 **Sonda dello storico su TUTTI i simboli** (~2 minuti, script già
   scritto). Trasforma metà di questo censimento da **[STIMA]** a misura.
   **Senza questo, il resto poggia su un'assunzione.**
2. 📥 **Import Dukascopy degli indici dal 2012** — macchina già collaudata in
   R56. **Sblocca il Gruppo B, cioè 94 coppie su 155.**
3. 🧹 **Chiudere il Gruppo D**: 17 coppie che non operano. Non vanno rimesse in
   nessuna coda finché non si capisce se è un difetto o un filtro troppo stretto.
4. 📉 **Dichiarare il Gruppo C non giudicabile sul MERITO** e lasciarlo lì:
   la regola B dice che il rischio si giudica lo stesso.

⚠️ **E vale il principio già scritto: la regola NON è retroattiva.** I round già
giudicati restano come sono. Questo censimento dice cosa succede **da qui in
avanti**, non riapre i verdetti passati.
