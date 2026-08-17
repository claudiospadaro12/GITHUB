# 📡 SONDA DELLO STORICO — **59 simboli su 59 misurati**, e tre assunzioni cadono

_17/08/2026, 18:34. `ABTG_InfoBroker` con `InpSondaStorico=true`, TF H1,
**tutto il broker**. Secondo giro: **date recuperate 0, ancora senza risposta 0**
— nessun simbolo è rimasto "da svegliare"._

✅ **[TRASCRITTO] RIMOSSO.** Il CSV è arrivato ed è archiviato in
`risultati_archivio/sonda_storico_17-08/`. **Verificate 16 date a campione
contro la trascrizione: ZERO discordanze.** 59 simboli, 39 `da scaricare
(parziale)` e 20 `COMPLETO`.

---

## 1. 🔴 PRIMA COSA: **UNA MIA ASSUNZIONE È CADUTA**

Da R68 in poi ho scritto e ripetuto *"lo storico GBPUSD H1 è misurato: parte dal
**2010.07.06**"*. **Era il limite del DISCO, non del broker.**

| | GBPUSD | USDJPY |
|---|---|---|
| quello che usavo | `2010.07.06` | `2010.07.06` |
| **quello che il broker HA** | **`1993.05.11`** | **`1971.01.03`** |
| stato dichiarato | **`da scaricare (parziale)`** | idem |

**`da scaricare (parziale)` vuol dire esattamente questo: sul server c'è, sul
nostro disco no.** Nessun round va rifatto — le finestre usate esistevano tutte
— ma la frase *"sedici anni"* di R68/R69 andava scritta **"sedici anni di
quelli che avevamo scaricato"**.

## 2. 🟢 SECONDA: **I METALLI HANNO STORICO PROFONDO, e nel censimento li avevo dati per corti**

| simbolo | prima data | anni |
|---|---|---:|
| **XAUUSD** | **2004.06.11** | **22,1** |
| **XAGUSD** | **2008.11.07** | **17,6** |
| XPTUSD · XPDUSD | 2015.03.29 | 11,3 |
| **XNGUSD** (gas) | **2016.08.23** | **9,9** |

Nel `CENSIMENTO_REGOLA_FINESTRA.md` avevo messo **tutti** i non-forex a
`2024.09.26` per difetto. **Sull'oro erano vent'anni di storico dati per persi.**

## 3. 🔴 TERZA: **GLI INDICI SONO CONFERMATI CORTI — e stavolta è definitivo**

| simbolo | prima data | stato |
|---|---|---|
| `100GBP` `200AUD` `225JPY` `D30EUR` `E35EUR` `E50EUR` `F40EUR` `NASUSD` `SPXUSD` `U30USD` `UKOIL` `USOIL` | **2024.09.26** | **`COMPLETO`** |

> ### 🎯 **`COMPLETO` è la parola che chiude la questione: non manca sul disco — il broker NON CE L'HA.**
>
> Il censimento diceva *"94 coppie bloccate dallo storico"* come **[STIMA]**.
> Adesso è misurato, ed è più preciso: **il buco è degli indici e dell'energia,
> e Dukascopy è l'unica strada.**

📌 Gli **8 simboli `_EXT`** già importati (`EURUSD_EXT`, `GBPUSD_EXT`,
`AUDJPY_EXT`, `CHFJPY_EXT`, `EURJPY_EXT`, `GBPCAD_EXT`, `XAUUSD_EXT`,
`USDJPY_EXT`) partono dal **2018.01.01** e sono marcati *"SOLO prova di
regime"*: **sono tutti forex e oro. Nessun indice.**

## 3-bis. 🧨 E IL CSV HA UNA COSA CHE LO SCHERMO NON MOSTRAVA: **il 2010 NON è il disco, è un'IMPOSTAZIONE**

La colonna `BarreTF` del CSV, che a schermo non c'era:

| simbolo | il broker ha | **barre H1 in LOCALE** |
|---|---|---:|
| GBPUSD | 1993.05.11 | **100.008** |
| USDJPY | 1971.01.03 | **100.008** |
| EURUSD | 1971.01.03 | **100.000** |
| EURJPY | 1993.04.26 | **100.000** |
| XAUUSD | 2004.06.11 | **100.000** |

> ### 🎯 **Cinque simboli con profondità reali diversissime (1971, 1993, 2004) si fermano tutti allo STESSO numero tondo: 100.000. Non è una coincidenza: è il tetto "Max barre nel grafico" di MT5.**

**E il conto torna:** il forex su H1 fa ~120 barre a settimana, cioè **~6.240
all'anno**. `100.000 / 6.240 = 16,0 anni`. Da luglio 2026 indietro di sedici
anni si arriva a **luglio 2010**.
👉 **`2010.07.06` non era il limite del broker NÉ del disco: era 100.000 barre
contate all'indietro da oggi.**

📌 Prova del nove: `XAGUSD` ha **26.036** barre (sotto il tetto) — quello sì è
storico che manca davvero e va scaricato.

### ⚠️ [INCERTO] dichiarato, e si chiude con una corsa

Il tetto è **dimostrato per le serie del terminale** (è ciò che
`SeriesInfoInteger` legge). **Se valga anche per lo Strategy Tester non lo so**:
il tester costruisce dalle M1 e potrebbe non esserne soggetto. **Non lo invento
e non lo do per buono.**

Si chiude così, e costa una corsa sola: rilanciare una griglia piccola su
GBPUSD con **`-DaQuando 2000.01.01`** e guardare due cose nel CSV — la
`FromDate` nella `gen_*.ini` e il numero di trade. Se n cresce rispetto alla
finestra dal 2010, **il tester NON è capped e avevamo trentatré anni
disponibili da sempre**. Se resta uguale, il tetto vale anche lì e va alzato.

## 4. ⏰ E DUE CONFERME CHE VALGONO COME IGIENE

- **`OFFSET SERVER-GMT: +01:00`** con ora locale PC 18:34 e ora server 17:34 →
  **server = ora italiana − 1.** La regola fissa in `CLAUDE.md` è **verificata
  oggi**, non ereditata.
- **`SERVER ALLINEATO AL DST DEL MERCATO: l'apertura cade alla STESSA ora
  server tutto l'anno. Un InpSessionHour fisso è corretto sempre.`**
  👉 La preoccupazione delle settimane di disallineamento USA/EU **non ci
  riguarda su BCM**. Misurato su sette date campione per stagione.

## 5. 📊 IL CENSIMENTO, RIFATTO CON LO STORICO VERO

**Regola:** servono **150 trade nell'IS + 150 nell'OOS = 300**, quindi
`anni necessari = 300 ÷ trade-anno`. La frequenza è stimata sulla stessa
finestra di misura per tutti (i 21 mesi che tutti hanno).

Coppie con storico misurato: **158**

- ✅ **88** rispettano la regola con lo storico REALE del broker
- 🔴 **53** no (troppo lente per lo storico che hanno)
- ⚰️ **17** zero trade

### 🔴 QUELLE CHE ANCORA NON CE LA FANNO

> ### 🎯 **Da 22 coppie a 88.** Non abbiamo cambiato una regola né scritto una riga di codice: **abbiamo misurato lo storico che avevamo già.**

**E delle 53 che ancora non ce la fanno, 44 sono indici o energia** — cioè
esattamente i simboli con 21 mesi. Le altre 9 sono motori troppo lenti anche
per vent'anni (`GapFill GBPUSD` 8 trade/anno su 33 anni disponibili, `PTE
XAUUSD` 10 su 22).

### 🔴 QUELLE CHE ANCORA NON CE LA FANNO

| EA | simbolo | trade/anno | storico | anni disp. | anni servono |
|---|---|---:|---|---:|---:|
| `ABTG_ORB_Ottimizzato` | U30USD | 168 | 2024.09.26 | 1.8 | **1.8** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD | 131 | 2024.09.26 | 1.8 | **2.3** |
| `ABTG_EMA200` | 200AUD | 125 | 2024.09.26 | 1.8 | **2.4** |
| `ABTG_Dow_Apertura_US` | U30USD | 123 | 2024.09.26 | 1.8 | **2.4** |
| `ABTG_EMA200` | SPXUSD | 104 | 2024.09.26 | 1.8 | **2.9** |
| `ABTG_Nasdaq_Apertura_US` | NASUSD | 95 | 2024.09.26 | 1.8 | **3.2** |
| `ABTG_GapContinuation` | 225JPY | 86 | 2024.09.26 | 1.8 | **3.5** |
| `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD | 77 | 2024.09.26 | 1.8 | **3.9** |
| `ABTG_ORB_Fibo` | NASUSD | 71 | 2024.09.26 | 1.8 | **4.2** |
| `ABTG_WOL` | SPXUSD | 66 | 2024.09.26 | 1.8 | **4.5** |
| `ABTG_SupRev_DOW_H1_Ottimizzato` | U30USD | 62 | 2024.09.26 | 1.8 | **4.9** |
| `ABTG_GoldenCross_Ottimizzato` | NASUSD | 61 | 2024.09.26 | 1.8 | **4.9** |
| `ABTG_GoldenCross_Ottimizzato` | U30USD | 60 | 2024.09.26 | 1.8 | **5.0** |
| `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR | 60 | 2024.09.26 | 1.8 | **5.0** |
| `ABTG_SupertrendReversal` | D30EUR | 59 | 2024.09.26 | 1.8 | **5.1** |
| `ABTG_SupRev_DAX_H1_Ottimizzato` | D30EUR | 59 | 2024.09.26 | 1.8 | **5.1** |
| `ABTG_SuperWave` | U30USD | 58 | 2024.09.26 | 1.8 | **5.2** |
| `ABTG_GoldenCross_Ottimizzato` | D30EUR | 57 | 2024.09.26 | 1.8 | **5.3** |
| `ABTG_SupRev_DOW_H4_Ottimizzato` | U30USD | 54 | 2024.09.26 | 1.8 | **5.6** |
| `ABTG_SuperWave_DAX_H4_Ottimizzato` | D30EUR | 53 | 2024.09.26 | 1.8 | **5.6** |
| `ABTG_SupRev_CAC_H4_Ottimizzato` | F40EUR | 53 | 2024.09.26 | 1.8 | **5.6** |
| `ABTG_SuperWave` | D30EUR | 50 | 2024.09.26 | 1.8 | **6.0** |
| `ABTG_SupertrendReversal` | E35EUR | 43 | 2024.09.26 | 1.8 | **7.0** |
| `ABTG_PTE` | U30USD | 42 | 2024.09.26 | 1.8 | **7.1** |
| `ABTG_PTE_Ottimizzato` | U30USD | 39 | 2024.09.26 | 1.8 | **7.7** |
| `ABTG_PunteLarry` | U30USD | 36 | 2024.09.26 | 1.8 | **8.3** |
| `ABTG_WOL` | U30USD | 30 | 2024.09.26 | 1.8 | **9.9** |
| `ABTG_WOL` | NASUSD | 30 | 2024.09.26 | 1.8 | **9.9** |
| `ABTG_SupertrendReversal` | 225JPY | 25 | 2024.09.26 | 1.8 | **12.2** |
| `ABTG_SupertrendReversal` | NASUSD | 24 | 2024.09.26 | 1.8 | **12.7** |
| `ABTG_SuperWave` | SPXUSD | 24 | 2024.09.26 | 1.8 | **12.7** |
| `ABTG_PTE` | D30EUR | 21 | 2024.09.26 | 1.8 | **14.4** |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | D30EUR | 20 | 2024.09.26 | 1.8 | **15.1** |
| `ABTG_GapFill` | F40EUR | 20 | 2024.09.26 | 1.8 | **15.1** |
| `ABTG_GapFill` | U30USD | 19 | 2024.09.26 | 1.8 | **15.8** |
| `ABTG_GapFill` | SPXUSD | 19 | 2024.09.26 | 1.8 | **15.8** |
| `ABTG_SuperWave` | NASUSD | 19 | 2024.09.26 | 1.8 | **15.8** |
| `ABTG_WOL` | D30EUR | 18 | 2024.09.26 | 1.8 | **16.7** |
| `ABTG_GapFill` | UKOIL | 17 | 2024.09.26 | 1.8 | **17.6** |
| `ABTG_PTE` | 225JPY | 16 | 2024.09.26 | 1.8 | **19.2** |
| `ABTG_PTE` | NASUSD | 14 | 2024.09.26 | 1.8 | **21.1** |
| `ABTG_GapFill` | 225JPY | 14 | 2024.09.26 | 1.8 | **21.1** |
| `ABTG_GapFill` | USOIL | 14 | 2024.09.26 | 1.8 | **21.1** |
| `ABTG_SuperWave` | XAUUSD | 13 | 2004.06.11 | 22.1 | **22.6** |
| `ABTG_SupertrendReversal` | XAUUSD | 11 | 2004.06.11 | 22.1 | **26.4** |
| `ABTG_PTE` | XAGUSD | 11 | 2008.11.07 | 17.6 | **27.5** |
| `ABTG_PTE` | XAUUSD | 10 | 2004.06.11 | 22.1 | **28.8** |
| `ABTG_SuperWave` | 225JPY | 10 | 2024.09.26 | 1.8 | **28.8** |
| `ABTG_PunteLarry` | XAUUSD | 10 | 2004.06.11 | 22.1 | **28.8** |
| `ABTG_PTE` | SPXUSD | 9 | 2024.09.26 | 1.8 | **33.3** |
| `ABTG_BreakingBand` | NZDJPY | 8 | 2007.02.12 | 19.4 | **39.5** |
| `ABTG_GapFill` | GBPUSD | 8 | 1993.05.11 | 33.1 | **39.5** |
| `ABTG_Nightly` | XAGUSD | 4 | 2008.11.07 | 17.6 | **79.1** |

---

## 6. 🚦 COSA CAMBIA DA ADESSO

> **1. 🔓 Sul FOREX e sui METALLI la regola della finestra non è più un
> ostacolo: 88 coppie su 158 la rispettano, e basta SCARICARE lo storico che il
> broker ha già.**
>
> **2. 🔴 Sugli INDICI il buco è confermato e definitivo: `COMPLETO` a 21 mesi.
> Dukascopy non è più "una buona idea", è l'unica strada — e adesso è misurato.**
>
> **3. ✍️ `@DAQUANDO 2010.07.06` era il disco, non il broker.** Da qui in avanti
> le date dei file prova si prendono da questo referto, non dalla memoria.

## 7. ➡️ AZIONI IN ORDINE

1. 🔧 **PRIMA DI TUTTO: alzare "Max barre nel grafico"** (Strumenti → Opzioni
   → Grafici) da 100.000 a **Illimitato**. **Senza questo, scaricare non serve
   a niente sui simboli profondi**: il tetto ritaglia comunque a 16 anni.
2. 🔬 **La corsa che chiude l'`[INCERTO]`**: griglia piccola su GBPUSD con
   `-DaQuando 2000.01.01`. Dice se il tester era capped o no — e quindi se
   quello che ci mancava erano i dati o un'impostazione.
3. 📥 **Poi** scaricare lo storico che il broker ha già —
   `ABTG_HistoryDownloader` con `InpDataInizio=1993.01.01`. Serve davvero per
   i simboli sotto il tetto, tipo `XAGUSD` (26.036 barre).
4. 📥 **Import Dukascopy per gli INDICI dal 2012** — macchina già collaudata
   (R56: 6 simboli, 15,2 M barre M1, zero scartate). È l'unico modo di dare al
   Dow, al DAX e al Nasdaq un campione da 300 trade.
5. 🔁 **Rifare i round che la finestra corta aveva zoppicato** — a partire da
   R74 sul Dow, dove la domanda sul *rendimento* era rimasta senza risposta
   proprio per questo.
6. ✅ ~~Archiviare `ABTG_InfoBroker.csv`~~ — **FATTO**, in
   `risultati_archivio/sonda_storico_17-08/`.
