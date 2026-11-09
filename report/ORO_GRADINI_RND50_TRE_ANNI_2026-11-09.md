# The Gold Reaper a 80.000 EUR su 2013 / 2020 / 2025, DUE volte per anno: cosa dice lo zip `ANNO_ORO_GRADINI_RND50`

**Natura: LETTURA di uno zip di misura.** Materiale: `ANNO_ORO_GRADINI_RND50_20261109_0551.zip` (24 MB, 114 file, 6 corse), arrivato il 09/11/2026. Script di raccolta `MARCATORE_ANNO80K_WIM_TESTER_v1` (pin `f5fcea83`), che **raccoglie e dichiara di non giudicare**. Il giudizio e' questo documento.

🔴 **SCREENING, NON VERDETTO.** Tutte e sei le corse sono a **Modello 1** (barre / tick generati, **NON tick reali**) e con **`ExecutionMode=0`**: **nessun ritardo di esecuzione, nessuno slippage di latenza**. I costi qui sono **ottimistici per costruzione**.

> ✏️ **SECONDA STESURA (09/11), dopo il cancello.** La prima rispondeva alla domanda sul muro FTMO **col campo sbagliato del report**, mentre il campo giusto era **nella stessa riga**; dichiarava **[NON MISURATO]** il criterio dei giorni, che invece **si misura da questo zip e BOCCIA il candidato**; e dava per certo un ripiego dell'EA che **l'EA smentisce nel proprio giornale**. Le correzioni sono dichiarate dove cadono (classi **1541-1547**). Nessuna e' cosmetica: **la prima stesura, letta di fretta, diceva "compralo"**.

## 1. Che cosa e' stato misurato

**The Gold Reaper MT5.ex5** — EA di **terzi** dal MQL5 Market, **scatola nera, nessun sorgente**. SHA256 `AB636AF9...F7E4`, **ricontrollato dopo ogni passata e sempre UGUALE**. Il binario **non e' nel repo** e non e' stato decompilato.

XAUUSD **H1**, deposito **80.000 EUR** a conto vuoto, leva 1:100 del tester, qualita' storico **99-100%**. Preset `Gold_reaper_propfirm`: `Risk=1234`, `StartLots=0.01`, `UseWeightedLots=true`, `MaxAllowedDD=9.00`, `PropFirmMaxDailyDD=4.00`, `OnlyUp=false`, `TradeFrequency=2`, **nove strategie accese** (`RunStrat1..9=true`), `EnableNFP_Filter=true`, **`EnableIR_Filter=false`**, **`Randomization=50`**.

**Sei corse = due ripetizioni (R1, R2) x tre anni (2013, 2020, 2025)**, ognuna a conto vuoto e indipendente. 🔴 **I loro numeri NON si sommano: si confrontano** (classe 1487).

⚠️ Questo zip **non e'** il test dei criteri congelati del 26/10 (`report/TRE_ANNI_PROP_80K_3EA_CRITERI_2026-10-26.md`), che chiedono **2013 SHORT, 2018 LATERALE, 2020 LONG** col 2025 come **calibrazione**: qui il **2018 manca** e il 2025 e' un terzo anno.

## 2. I numeri, tutti e sei

| | anno | n | netto | PF | win% | vinc. media | perd. media | rapporto | serve | **scarto** |
|---|---|---|---|---|---|---|---|---|---|---|
| R1 | 2013 | 601 | +13.070,90 | 1,29 | 66,22% | 145,16 | 218,36 | 0,66:1 | 60,07% | **+6,15** |
| R2 | 2013 | 639 | +21.779,99 | 1,47 | 66,35% | 160,51 | 213,31 | 0,75:1 | 57,06% | **+9,29** |
| R1 | 2020 | 591 | +22.487,49 | 1,74 | 67,34% | 133,11 | 156,42 | 0,85:1 | 54,03% | **+13,31** |
| R2 | 2020 | 573 | +25.442,23 | 1,88 | 66,84% | 141,95 | 150,69 | 0,94:1 | 51,49% | **+15,35** |
| R1 | 2025 | 599 | +33.592,95 | 2,72 | 71,95% | 123,30 | 115,42 | 1,07:1 | 48,35% | **+23,60** |
| R2 | 2025 | 621 | +33.743,52 | 2,63 | 73,27% | 119,79 | 124,06 | 0,97:1 | 50,88% | **+22,39** |

_`rapporto = vincita media / perdita media`, `serve = 1/(1+rapporto)`, `scarto = win% ottenuto − win% necessario`._
📌 **Base del win%**: il report mette l'unico trade a P/L **esattamente zero** (R1/2013) fra i **vincenti**; nelle altre cinque corse gli zeri sono **zero**. Con la convenzione delle pagelle (zeri fuori da numeratore **e** denominatore, classe 1526) R1/2013 fa 66,17% e lo scarto **+6,10** invece di +6,15: **differenza ≤ 0,06 punti su una corsa su sei**, e il report e' **internamente coerente** (la sua media-vincita usa lo stesso denominatore del suo win%). Dichiarato, non trascurato.

🟢 **Sei corse su sei in utile, e lo scarto e' positivo in tutte e sei: da +6,15 a +23,60.**

🔴 **MA IL CONFRONTO CON LE NOSTRE FAMIGLIE VA FATTO CON LA CAUTELA ATTACCATA, NON IN APPENDICE.** In casa: Bulge **−4,84** su n=291, `MAXMIN ORO` **+15,0** su n=18, `DAX Apertura RETEST` **+36,6** su n=21. 🔴 **Quei tre numeri sono operazioni di CAMPO** (spread e slippage veri); questi sei sono **Modello 1 con `ExecutionMode=0`**. **Sono due basi diverse** (classe **1526**, recidiva: nella prima stesura la cautela stava tre sezioni dopo la frase che concludeva *"fascia alta"*). 👉 **Il confronto corretto e': lo scarto di questo motore, MISURATO SENZA COSTI, sta nella fascia dei nostri misurati CON i costi — e questo e' un indizio, non un piazzamento.**

📌 Nota tecnica per chi ricalcola: il `Fattore di Profitto` del report **non** e' (somma vincite)/(somma perdite) sulle posizioni — MT5 calcola la `Perdita Lorda` a livello di **affare** e ci include le commissioni d'ingresso delle posizioni vincenti. A livello di posizione R1/2013 fa 1,3033 -> **1,30**, non 1,29. Immateriale, ma non e' un errore.

## 3. 🔴 LA COSA PIU' IMPORTANTE DEL PROFITTO: LO SCARTO FRA LE DUE RIPETIZIONI

Stesso EA, stesso preset, stesso anno, stesso deposito. **L'unica differenza e' `Randomization=50`.**

| anno | netto R1 | netto R2 | scarto | in % del minore |
|---|---|---|---|---|
| **2013** | +13.070,90 | +21.779,99 | 🔴 **+8.709,09** | 🔴 **+67%** |
| 2020 | +22.487,49 | +25.442,23 | +2.954,74 | +13% |
| 2025 | +33.592,95 | +33.743,52 | +150,57 | +0,4% |

🔴 Nel 2013 due corse identiche danno **13.071** e **21.780**, e cambiano anche il peggior giorno (−5.647,56 contro −5.461,90) e la striscia piu' lunga (30 contro 36).

👉 **Criterio d'acquisto: una singola corsa di questo EA non e' una misura.** Nessun numero del venditore — e nessuno dei nostri — e' il valore: e' **una estrazione**. ⚠️ E **due ripetizioni non sono una distribuzione**: tutto cio' che dico sull'ampiezza e' un'indicazione su **n=2**.
🔴 **E il verso della variabilita' e' quello sbagliato: e' massima nell'anno piu' difficile.** Nel 2025 le due corse coincidono allo 0,4%; nel 2013 divergono del 67%.

## 4. 🟢 IL MURO STATICO FTMO: SEI SU SEI NON L'HANNO TOCCATO — e la prima stesura usava il campo sbagliato

Il muro statico FTMO e' **l'equita' che non scende sotto il 90% del saldo iniziale** = **72.000 EUR** su 80.000 (`docs/REGOLAMENTO_FTMO_2026-09-20.md` r.59; il Guardian misura sul saldo di partenza in **tutte e due** le modalita', `ABTG_Guardian.mq5` r.739-745).

🔴 **E il minimo dell'equita' e' STAMPATO nel report**, nella stessa tabella del `Profitto Totale Netto`: la voce **`Equità Drawdown Assoluta`** vale **deposito − equita' minima**.

| | anno | **Eq. DD ASSOLUTA** | **equita' MINIMA** | margine sul muro 72.000 | esito |
|---|---|---|---|---|---|
| R1 | 2013 | 4.124,48 | **75.875,52** | +3.875,52 | 🟢 **non sfondato** |
| R2 | 2013 | 3.957,73 | **76.042,27** | +4.042,27 | 🟢 **non sfondato** |
| R1 | 2020 | 51,60 | 79.948,40 | +7.948,40 | 🟢 |
| R2 | 2020 | 75,07 | 79.924,93 | +7.924,93 | 🟢 |
| R1 | 2025 | 1.931,70 | 78.068,30 | +6.068,30 | 🟢 |
| R2 | 2025 | 2.000,14 | 77.999,86 | +5.999,86 | 🟢 |

✅ **Che quel campo sia davvero "quanto sei scesa sotto il deposito" l'ho CHIUSO con una misura, non con una deduzione**: cercando nei 26 report dell'archivio con quel campo, **ne esiste uno a `0,00` esatto** (`SET80K_SOMAGOLD_TRANCHE1_20261025`). Un drawdown qualunque non vale mai zero su una corsa che opera: **zero vuol dire "mai scesa sotto il deposito"**, che e' la definizione. ✅ Conferma strutturale: `Eq. DD Assoluta > Bilancio DD Assoluto` in **6 corse su 6** — l'equita' toccata e' sempre ≤ il saldo toccato, ordinamento che solo questa definizione produce.

🔴 **Che cosa cade della prima stesura.** Avevo costruito un *"pavimento certo = 80.000 − DD massimale"*: l'algebra regge (il massimo corrente parte dal deposito), **ma e' un limite inferiore inutile** quando il minimo vero e' stampato. E produceva un fantasma: *«R2/2013, pavimento 71.678: sfondamento POSSIBILE, NON dimostrato»* -> **falso, e' dimostrato che NON e' avvenuto, con 4.042 EUR di margine**. Cade anche *«la curva di equita' non c'e', quindi il minimo vero resta ignoto»*: il minimo **non richiede la curva**. Classe **1541**, ed e' il difetto del 10/09 alla lettera — *i numeri veri erano nella stessa riga che avevo letto*.

⚠️ **Il limite che resta, e va scritto ogni volta:** quello e' il minimo **sulla curva campionata dal tester a Modello 1**. FTMO misura l'equita' in tempo reale: il minimo vero puo' essere piu' basso. I margini (3.875-7.948 EUR) sono larghi, **ma non sono una dimostrazione a tick reali.**

### 4-bis. 🟢 E IL CRITERIO CONGELATO DEL 26/10 LO PASSANO TUTTE E SEI

Il criterio dice *«DD equity **assoluto** ≤ 8.000 EUR (10% di 80.000)»* — e il campo che porta **letteralmente quel nome** e' `Equità Drawdown Assoluta`. Massimo delle sei: **4.124,48**. 🟢 **Passano tutte e sei, la peggiore con 3.875 EUR di margine.**

🔴 **Nella prima stesura avevo applicato il criterio a `Equità Drawdown MASSIMA`** (8.321,66) e concluso che R2/2013 era bocciata **e** che *«il nostro criterio e' piu' severo del muro che vuole proteggere»*. 👉 **Era una divergenza inventata: il criterio E' il muro** (8.000 = 10% di 80.000 = il pavimento 72.000), e l'avevo misurato col campo sbagliato. Classe **1542**.
📌 Per lo stesso motivo cade il contro-esempio D della prima stesura: *«lette sul deposito le percentuali diventano 4,50-10,40% e R2/2013 passa il 10%»* e' aritmeticamente giusto ma **misura una quantita' che non significa niente** — il DD **massimale** rapportato al deposito non e' una regola di nessuno. La quantita' FTMO e' l'**assoluta**: 3.957,73 = **4,95%**.

### 4-ter. 🔴 IL MURO CHE SI ROMPE E' L'ALTRO: QUELLO GIORNALIERO — e si misura da questo zip

La prima stesura dichiarava il criterio dei giorni **[NON MISURATO]**, *«serve la lista delle operazioni giorno per giorno e il lettore congelato legge l'archivio, non questo zip»*. 🔴 **La lista e' DENTRO i `.htm` di questo zip** (tabella `Affari`, 1.147-1.279 righe per corsa, con `Ora`, `Commissioni`, `Swap`, `Profitto`, `Bilancio`). Che un lettore congelato non la legga non vuol dire che il dato non ci sia. Classe **1543**.

Misurata (P/L **realizzato** per giorno, saldo a inizio giornata dal `Bilancio` dell'ultimo affare del giorno prima):

| | anno | peggior giorno | P/L realizzato | saldo a inizio | **%** | criterio ≥5% | muro giornaliero 4.000 EUR |
|---|---|---|---|---|---|---|---|
| **R1** | **2013** | **18/12/2013** | **−5.647,56** | 100.286,39 | 🔴 **−5,63%** | 🔴 **FALLISCE** | 🔴 **SFONDA** |
| R2 | 2013 | 18/12/2013 | −5.461,90 | 109.516,51 | 🟠 **−4,99%** | passa di **0,01 punti** | 🔴 **SFONDA** |
| R1 | 2020 | 28/09/2020 | −2.062,77 | 101.195,91 | −2,04% | ✅ | dentro |
| R2 | 2020 | 18/11/2020 | −1.889,20 | 102.284,70 | −1,85% | ✅ | dentro |
| R1 | 2025 | 16/07/2025 | −1.009,21 | 95.184,82 | −1,06% | ✅ | dentro |
| R2 | 2025 | 05/12/2025 | −1.125,36 | 108.235,91 | −1,04% | ✅ | dentro |

✅ **Contro-esempio costruito prima di consegnare**, ed e' l'obiezione ovvia: *«il giorno FTMO e' a mezzanotte CE(S)T, non a mezzanotte server»*. Rifatto il raggruppamento con **−1 ora**: 🟢 **i sei peggiori giorni e i sei numeri non cambiano di un centesimo.** Il verdetto e' **insensibile alla convenzione di fuso** (le chiusure del 18/12/2013 stanno fra le 16:51 e le 19:01, a sette ore dal confine).

👉 **Quindi: NON e' `PROP-ANNI`, e la ragione forte non e' che manca il 2018 — e' che la condizione dei giorni FALLISCE su un anno che c'e'.** La riserva sul 2018 resta vera e resta necessaria per **dichiarare** il criterio, ma usarla da sola sarebbe stato nascondersi dietro una lacuna avendo il dato in mano.
🔴 **E il realizzato e' un limite INFERIORE** (lo dicono i criteri stessi: *«FTMO misura sull'equita'»*): R2/2013 a **−4,99%** passa **solo sulla carta**.

🔴 **E IL GIORNO HA UN NOME: 18 dicembre 2013, la riunione FOMC del taper.** Le due corse si rompono **lo stesso giorno**. E nel preset: **`EnableNFP_Filter=true`** ma **`EnableIR_Filter=false`**. 👉 **L'EA si protegge dai dati sull'occupazione e NON dalle decisioni sui tassi, e il giorno che gli rompe il muro e' una decisione sui tassi.** E' la cosa piu' azionabile dello zip (vedi §9).

## 5. 🔴 IL RISCHIO: STRISCE, MARGINE, E UN MOTORE CHE NON E' QUELLO CHE SEMBRA

| | anno | Z-Score | striscia piu' LUNGA | **peggiore in DENARO** | livello di margine (minimo) |
|---|---|---|---|---|---|
| R1 | 2013 | **−15,00** | 30 (−4.046,78) | 🔴 **−5.966,80 (12 op.)** | 🔴 **112,69%** |
| R2 | 2013 | **−15,50** | 36 (−4.410,22) | 🔴 **−5.843,46 (11 op.)** | 🔴 **119,55%** |
| R1 | 2020 | −13,43 | 15 (−1.203,57) | −2.697,76 (8) | 242,84% |
| R2 | 2020 | −12,78 | 12 (−1.029,75) | −2.876,10 (9) | 246,18% |
| R1 | 2025 | −12,70 | 13 (−2.344,00) | −2.344,00 (13) | 343,98% |
| R2 | 2025 | −13,00 | 8 (−1.386,25) | −1.849,00 (6) | 336,65% |

🔴 **Z-Score da −12,70 a −15,50, significativita' oltre il 99%**: le strisce **sono una proprieta' del motore**, non sfortuna.
🔴 **E il numero di rischio e' quello in DENARO, che la prima stesura non riportava: −5.966,80 in DODICI operazioni = il 149% del muro giornaliero FTMO da 4.000 EUR.** Conferma per via indipendente il §4-ter. (La prima stesura intitolava la colonna *"perdite consecutive (peggiore)"* e ci metteva la striscia piu' **lunga**: `Massima perdite consecutive ($)` e `Massimale perdite consecutive` sono **due voci diverse** — l'accoppiamento era giusto, l'etichetta no.)

🟢 **Il `livello di margine` e' il MINIMO raggiunto — il `[NON VERIFICATO]` della prima stesura si chiude.** Due prove: (a) a fine test non ci sono posizioni aperte, quindi il margine usato e' 0 e un valore "finale" sarebbe infinito, non 112,69%; (b) ricostruendo il volume massimo aperto e l'equita' in quell'istante, il margine per lotto che ne deriva e' **8.520-9.500 EUR**, contro gli **8.580,52 EUR/lotto misurati in R114 del 27/08**, e lo scarto e' spiegato dal cambio.

🔴 **Ma la conseguenza che avevo tirato era sbagliata.** Lo **stop out** MT5 e' a **50%**, non a 100% (`report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` r.116). Quindi 112,69% e' a **12,7 punti dalla CHIAMATA di margine** e a **62,7 dallo stop out**: 👉 **la conseguenza operativa non e' la liquidazione, e' l'ORDINE RIFIUTATO** — e di quello abbiamo la misura dal vivo (`report/FORWARD_DEMO_PROP_50504894_GIORNO1_2026-10-30.md`: 25 sell stop rifiutati per margine insufficiente, **circa il 37% del volume richiesto eseguito**). Classe **1546**.

### 5-bis. 🔴 «2,4 OPERAZIONI AL GIORNO» DESCRIVE UN MOTORE CHE NON ESISTE

| corsa | ingressi | **giorni ATTIVI** | ingressi per giorno attivo | max in **un minuto** | % ingressi in giorni da ≥5 | max volume aperto |
|---|---|---|---|---|---|---|
| R1/2013 | 601 | **104** su ~252 | **5,78** | **10** | 81% | 🔴 **11,00 lotti** |
| R2/2013 | 639 | 102 | 6,26 | 10 | 84% | 10,25 |
| R1/2020 | 591 | 116 | 5,09 | 10 | 77% | 4,48 |
| R2/2020 | 573 | 115 | 4,98 | 9 | 76% | 4,65 |
| R1/2025 | 599 | 101 | 5,93 | 7 | 82% | 2,51 |
| R2/2025 | 621 | 101 | 6,15 | 8 | 84% | 2,54 |

🔴 **La divisione 601/252 = 2,38 e' giusta; come descrizione del motore e' falsa.** L'EA e' **fermo nel 54-60% dei giorni di borsa**, e quando parte apre **5-6 posizioni, fino a 10 nello stesso minuto** (nove strategie sullo stesso simbolo). Non e' una sedia da 2,4 op/giorno: e' una sedia da **~100 giorni attivi l'anno, a raffiche**. Classe **1545**.
🔴 **E la prima stesura si contraddiceva**: usava `n≈600` come argomento di robustezza **e** dichiarava `Z-Score −15,00`. **Lo Z a −15 E' la misura che quel n non vale 600**: l'n efficace e' dell'ordine dei **giorni attivi (~100)**.
📌 Sul pavimento di frequenza del 07/09 (1,00 op/giorno **per famiglia**): una famiglia da un simbolo e' legittima, ma la grandezza da confrontare **non e' 601/252**.

🟢 **E le raffiche spiegano tutto il resto in un colpo**: 10 posizioni in un minuto da nove strategie correlate **sono** il meccanismo del −5.647,56 del 18/12/2013 (undici chiusure in 2h10), del picco di **11,00 lotti** e del margine al 112,69%. **Sono un fatto solo, non cinque sintomi.**

## 6. 🟠 L'ORA: il difetto possibile resta, la mia spiegazione no

Il preset porta **`AutoGMT=true`** con ripiego **`Broker_GMT_OFFSET_Winter=2`** / **`Summer=3`**, e nei giornali di tutte e sei le corse compare `Error when reading GMT URL. Error code = 4014`.

🔴 **La prima stesura concludeva: «quindi l'EA usa i due numeri fissi del preset», e lo dichiarava CERTO. L'EA lo smentisce TRE RIGHE SOTTO, nel suo stesso giornale:**

```
Error when reading GMT URL. Error code  =4014
GMT_Offset wrongly detected.  Trying againg!
Error when reading GMT URL. Error code  =4014
GMT_Offset still wrong.  Using VPS time for GMT detection!
```

👉 **Il ripiego dichiarato dall'EA e' «Using VPS time for GMT detection», non i numeri del preset.** E il valore che ne ricava **non e' stampato**. Quindi: *«usa i due numeri del preset»* e' **smentito**; *«il ripiego e' certo»* e' **falso**; *«sbaglierebbe di un'ora d'inverno e DUE d'estate»* **non segue** — era aritmetica su un ripiego che non avviene. Classe **1544**, e **recidiva 1522 per la quinta volta in una settimana**: una spiegazione plausibile al posto di una verifica, con la smentita **nello stesso file**.
⚠️ E non va fatto l'errore simmetrico: nei log c'e' un `GMT+1`, ma e' il **banner di avvio del terminale** (il fuso del PC di backtest), **non** l'offset adottato dall'EA.

🟢 **Quello che regge: il verso della convenzione.** `Broker_GMT_OFFSET_Winter=2 / Summer=3` significa *"il server e' GMT+X"* — il default 2/3 e' esattamente **EET (UTC+2/+3)**, il fuso di quasi tutti i broker MT5. Prova indipendente dai log: l'EA **ri-tenta la rilevazione solo alle date di cambio ora** (2013: 11/03, 01/04, 27/10, 03/11; 2025: 10/03, 31/03, 26/10, 03/11 — i confini DST USA e UE), quindi **ragiona in offset-dal-GMT ed e' DST-aware**. 👉 Su BCM (**UTC+1 FISSO**, misurato su ~24.400 deal, `report/OROLOGIO_BCM_2026-09-24.md`) i due numeri giusti **sarebbero 1 e 1**. **Ma quale offset l'EA adotti davvero resta [NON MISURATO]**: e' una scatola nera e non lo stampa.

📌 Compaiono anche `'unknown error 4753' when modifying stoploss`. ⚠️ I conteggi di queste righe che si vedono nei referti sono presi su un **campione troncato alle prime 15 righe di giornale**: **non sono totali**, e non li uso come tali.

## 7. 🔴 E LA COSA CHE PESA PIU' DI TUTTE SULLA SPESA: LA CORSA 2013 NON SI PUO' RIPRODURRE SU UN CONTO FTMO

Il tester gira a **~10.000 USD per lotto fisso** (≈1:45 sul nozionale, misurato in R114 del 27/08). FTMO sull'oro e' **1:9-1:15**.

| anno | picco di esposizione | nozionale | margine a **1:15** | margine a **1:9** |
|---|---|---|---|---|
| **2013** | **11,00 lotti** (oro ~1.650) | ~1,82 M USD | 🔴 **~110.000 EUR = 138% del conto** | 🔴 **~183.000 EUR = 229%** |
| 2025 | 2,54 lotti (oro ~2.600) | ~0,66 M USD | ~40.000 EUR = **50%** | ~67.000 EUR = **83%** |

👉 **Le due corse 2013 — quelle su cui poggia tutto il ragionamento sul rischio — descrivono passate che su un conto FTMO da 80.000 NON AVREBBERO POTUTO APRIRSI.** Con il fill parziale misurato dal vivo (37% del volume richiesto) il 2013 su conto prop non e' *"piu' rischioso"*: e' **un altro EA**. Classe **1547**.
⚠️ **Il margine FTMO sull'oro e' aperto in casa fra 1:9 e 1:15** (`PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` punto B11, da chiudere con uno screenshot): il 2013 e' **impossibile con tutti e due** (138% e 229%), il 2025 **cambia natura** fra 50% e 83%.

## 8. ✅ I CONTRO-ESEMPI che restano in piedi

**A. _«Lo scarto positivo in tutti e sei gli anni dimostra un edge.»_** Lo scarto nasce da medie di un Modello 1 **senza slippage**. Il 2013 e' la riga fragile: **rapporto 0,66:1 che chiede il 60,07%** con scarto **+6,15**; un peggioramento del 10% sul rapporto delle medie porta il `serve` oltre il **62%** e si mangia **un terzo** dello scarto. 👉 **Regge nel 2020 e nel 2025; nel 2013 e' sottile — e il 2013 e' l'anno del rischio.** La prova che lo chiude e' una corsa **con i costi**.

**B. _«Il 2025 e' il miglior anno, quindi l'EA e' migliorato.»_** 🔴 Non e' un'inferenza che questi dati permettono. La monotonia **+6,15 < +13,31 < +23,60** e' **la forma attesa da un motore adattato ai dati recenti**, per un EA in vendita nel 2026. Dai soli tre anni *"migliorato"* e *"adattato al recente"* **non si distinguono** — e il 2025 e' anche l'anno in cui la randomizzazione non sposta niente (0,4%), coerente con tutte e due le spiegazioni.

**C. _«Nessuno stop out in sei corse, quindi reggerebbe una prop.»_** No, per **tre** ragioni diverse: (1) lo stop out e' a **50%** di margine e il minimo e' 112,69%, quindi la conseguenza vera e' **l'ordine rifiutato** (§5); (2) il muro FTMO non e' lo stop out del broker, e quello **giornaliero si rompe** (§4-ter); (3) l'esposizione del 2013 **non entra nel conto** (§7).

**D. _«Il lato corto e' sempre il migliore, quindi non e' un adattamento alla direzione.»_** Regge in **6 corse su 6** (short vincenti **70,37-75,88%** contro long 55,86-72,60%, anche nel 2020 e 2025 che sono anni di oro **in salita**) — 🔴 ma **il vantaggio si assottiglia da 20,0 punti nel 2013 a 2,3-3,4 nel 2025**, e il numero di short crolla da 311-333 a 168-183 su ~600. Nella prima stesura era *«il risultato piu' incoraggiante dello zip»* e il range partiva da 73,87% invece di **70,37%**: era piu' stabile di quanto e'.

## 9. 👉 Che cosa farei adesso, nell'ordine corretto

1. 🔬 **Riaccendere `EnableIR_Filter` e rifare il 2013.** E' **una manopola e una corsa**, e punta esattamente al numero che oggi boccia il candidato: il giorno che rompe il muro giornaliero in **tutte e due** le corse 2013 e' il **18/12/2013, la riunione FOMC del taper**, e il filtro dei tassi e' **spento** mentre quello dell'occupazione e' acceso. _(Nella prima stesura il passo 1 erano 6-8 corse per misurare quante estrazioni sfondano il muro statico: domanda **gia' chiusa** dal §4.)_
2. 📅 **Aggiungere il 2018 LATERALE**, l'anno previsto dai criteri congelati che manca. Nei nove EA letti in ottobre l'anno peggiore era il laterale in **sette** casi.
3. 💶 **Rifare la riga migliore CON I COSTI**, perche' il contro-esempio A e' aperto sul 2013.
4. 📐 **Chiudere B11: il margine FTMO sull'oro** (1:9 o 1:15). Decide se il **2025** e' schierabile (50% contro 83% del conto) — il 2013 e' escluso in tutti i casi.
5. 🕒 **Chiedere al venditore**: (a) quale offset adotta l'EA quando `AutoGMT` ripiega su *"VPS time"*, e che valore ne esce su un server **senza ora legale**; (b) a quanto va messo `Broker_GMT_OFFSET_Winter`/`Summer` su un server **UTC+1 fisso**. 🔴 Serve **anche** per gli altri EA del pacchetto, su cui **non ho misure**.

## 10. Che cosa questo zip NON dice

- 🔴 **Non e' un verdetto**: Modello 1, nessuno slippage, nessun ritardo.
- 🔴 **Non autorizza nessuna spesa.** Il pacchetto da ~1.500 EUR resta una **firma di Claudio**: qui si misura, non si consiglia.
- 🔴 **NON e' `PROP-ANNI`**, e per **due** ragioni: la condizione dei **giorni fallisce** su R1/2013 (§4-ter) **e** manca il 2018 previsto dai criteri.
- 🔴 **La CALIBRAZIONE 2025 Modello 1 contro Modello 4 non l'ho verificata**, ed e' la **quarta** condizione di `PROP-ANNI`: i criteri del 26/10 dicono che se non passa, *«i tre anni vecchi di quell'EA sono NON ATTENDIBILI»*. **[NON MISURATO]**, e va dichiarato perche' se cade porta via anche il 2013 e il 2020.
- 🔴 **L'offset GMT adottato dall'EA**: scatola nera, non stampato. **[NON MISURATO]**.
- ⚠️ **Il minimo di equita' e' quello campionato a Modello 1**, non a tick reali.
- ⚠️ **Nessun input e' stato IMPOSTO dal `.ini`**: valgono quelli salvati dal tester per questo EA su questo PC. Il report li stampa tutti, quindi **si sa quali sono** — ma non che fossero scelti, e la riproducibilita' su un altro PC non e' garantita.
- ⚠️ **Due ripetizioni non sono una distribuzione**, e i **picchi ricostruiti** di cui parlavo nella prima stesura vanno con la loro banda di arrotondamento (la % ha due decimali).
