# 🔬 DOSSIER — I TRE PRODOTTI ESTERNI SUL NASDAQ, GUARDATI A FONDO

_Scritto il **22/08/2026** (le tre letture veloci sono della notte del 21/08).
Tutte le pagine citate sono state **aperte davvero**, e la data di lettura e'
**22/08/2026** salvo diversa indicazione. Ogni numero che viene da fuori e'
etichettato **[DICHIARATO DAL VENDITORE, NON MISURATO DA NOI]**._

**Mandato**: andare piu' a fondo dei tre referti della notte
(`INDICATORE_DIEGO_NASDAQ_2026-08-21.md`, `ARTEMIS_NAS100_ORB_2026-08-21.md`,
`MASTER_NASDAQ_FTMO_2026-08-21.md`), usando il web e rileggendo i `.set`
originali. Ordine esplicito di Claudio nel §"Prossimo passo" di
`R97_CRITERI.md`: *"FIRMIAMO R97, POI ANALIZZIAMO QUESTI EA BENE"*.

> ## 🎯 LA RIGA CHE CONTA
> **Ho aperto 14 pagine su 3 fonti. Nessuno dei tre prodotti ha un track
> record verificabile: entrambi i venditori MQL5 hanno _0 signals pubblicati_
> e _0 subscribers_. E i due `.set` in nostro possesso contengono DUE FATTI
> che i referti di stanotte hanno letto al contrario — Artemis NON punta a
> 1:1 (punta a 3,5R), e Master Nasdaq NON gira allo 0,4% di rischio (gira a
> LOTTO FISSO 0,01, il rischio percentuale e' DISATTIVATO nel preset). Il
> primo dei due errori tocca direttamente la cella `R97d`.**

---

## 0. ✅ CONTROLLO POSITIVO DELLE FONTI (fatto prima di cercare)

| fonte | bersaglio noto | esito |
|---|---|---|
| MQL5 Market (WebFetch) | pagina 179855 deve mostrare nome/autore/prezzo/versione | ✅ contenuti veri |
| MQL5 Market (curl diretto) | HTML completo di 111837 (293 kB) | ✅ 200, testo integrale |
| MQL5 tab `/comments` e `/updates` | devono restituire il thread e il changelog | ✅ entrambi 200 con testo |
| **web.archive.org** | snapshot storici delle schede | ❌ **BLOCCATO** (`Host not in allowlist` via bash; `unable to fetch` via WebFetch) |
| Forex Factory / Reddit / Google | tracce indipendenti dei due prodotti | ✅ risponde, ma **zero risultati pertinenti** (vedi §4) |

🔴 **Cosa NON ho potuto vedere, e va dichiarato:** senza Wayback **non posso
datare** quando la frase *"Propfirm & FTMO no longer supported"* e' comparsa
nella scheda del Master Nasdaq. E' l'unica domanda del mandato rimasta
**[INCERTO]** — vedi §3.3 per cosa ho potuto stabilire lo stesso.

---

## 1. 📊 LA TABELLA DI CONFRONTO

| | **Diego_Nasdaq_Bands** | **Artemis NAS100 ORB Edge** | **Master Nasdaq FTMO** |
|---|---|---|---|
| **cos'e'** | indicatore (disegna livelli, non opera) | EA ORB completo | EA a **paniere di 10 blocchi** |
| **autore** | **ignoto** | Nathan James Gilks (UK) | Yudi Sri Warsito (Indonesia) |
| **URL** | **nessuno** | [MT5 180116](https://www.mql5.com/en/market/product/180116) · [MT4 179855](https://www.mql5.com/it/market/product/179855) | [111837](https://www.mql5.com/en/market/product/111837) |
| **prezzo** | — (postato in un gruppo del corso) | 59 USD (no noleggio) | 60 USD · **noleggio 30 USD/anno** |
| **eta' del prodotto** | ignota | **MT5 pubblicato 12/07/2026 → 41 giorni** | pubblicato 23/01/2024 → **2,5 anni**, v4.6 del 07/02/2026 |
| **meccanismo** | ORB su candela 15:25 IT, ingressi ±24 pt, TP/SL ±33 pt | ORB 15 min + OCO straddle + Market State Engine + moduli sweep/recovery | 10 blocchi MA-veloce/MA-lenta + RSI + divergenza, SL/TP in ATR |
| **rapporto TP:SL del preset** | **1:1** (33/33) | **3,5R** con parziali 1,2R/2,5R/4,0R 🔴 *(non 1:1: correzione, §2.1)* | **1:1 su TUTTI e 10 i blocchi** (SL e TP allo STESSO multiplo ATR) |
| **rischio del preset** | non definito (e' un indicatore) | **0,20%/trade**, max 1 posizione | 🔴 **LOTTO FISSO 0,01** — `Risk_Percent=0,4` **non attivo** (§3.1) |
| **posizioni simultanee max** | — | **1** | 🔴 **20** (5 blocchi attivi × 2 buy + 2 sell) |
| **filtro news** | no | 🔴 **NESSUNO** — e il venditore l'aveva promesso "entro pochi giorni" il 20/07 (§2.2) | no |
| **recovery/griglia** | no | 🔴 **modulo Recovery Ladder presente** (×1,2 lotto/layer), spento di default | no (nessun indizio nel `.set`) |
| **track record verificabile** | nessuno | 🔴 **0 signals, 0 subscribers** sul profilo autore | 🔴 **0 signals, 0 subscribers** sul profilo autore |
| **recensioni** | — | **1 recensione in TUTTO il catalogo** (26-32 prodotti), e **non su questo EA**: la tab del MT4 dice *"Nessuna recensione"* | **6 sul prodotto**, 4,5/5 su **112** a livello venditore |
| **red flag principale** | provenienza anonima + ora sbagliata per BCM | **fabbrica di prodotti**: 19 prodotti in 77 giorni (§2.3) | **la firma dell'ottimizzatore** nei 10 blocchi (§3.2) |

---

## 2. 🏹 ARTEMIS NAS100 ORB EDGE EA — quello che stanotte non si era visto

### 2.0 Provenienza del nostro `.set`: e' il file UFFICIALE del venditore
**[VERIFICATO 22/08]** Il file che abbiamo (`Artemis-NAS100-ORB-Edge-M5-MT5-v1.30.set`)
e' **esattamente** l'allegato `Artemis-NAS100-ORB-Edge-M5-MT5-v1_30.zip` che
Gilks ha pubblicato nel commento **#11 del 16/08/2026 14:55** sulla pagina MT5.
Testo suo: *"Key defaults include Adaptive ORB Quality ON, Hybrid OCO Trail,
Impulse Trail ON, Flip Reversal ON, and Recovery Ladder OFF"* — combacia riga
per riga col nostro file. **Non stiamo leggendo un preset di terze mani: e'
il preset di rilascio dell'autore.**

✅ **Risposto da Claudio (22/08)**: *"Artemis l'ho copiato dallo store di
MQ5"* — nessun acquisto, il file era scaricabile pubblicamente dalla pagina
(non serve aver comprato per leggere/scaricare il preset di rilascio postato
nei commenti). Il gradino 3 del cancello (demo nel tester) **NON e'**
finanziato: se si vuole andare oltre il `.set`, va scaricata la demo gratuita
a parte, zero soldi impegnati finora.

### 2.1 🔴 CORREZIONE DI FATTO: Artemis NON punta a 1:1 — punta a 3,5R
`R97_CRITERI.md` §4.1 scrive: *"sia Diego che Artemis puntano a un TP vicino
1:1 invece che 1,5-2R"*. **Sul `.set` questo e' falso per Artemis:**

```
InpORBTakeProfitR=3.5        <- target principale
InpTP1AtR=1.2  / 25%         InpTP2AtR=2.5 / 35%
InpTP3AtR=4.0  / 40%         InpUseFinalCloseAtR=true / InpFinalCloseAtR=5.0
InpBreakEvenAtR=0.9          InpTrailStartR=1.5
```
Il vincitore pieno vale **≈2,78R medi** (0,25×1,2 + 0,35×2,5 + 0,40×4,0).
L'unica cosa "vicina a 1:1" e' il **primo parziale su un quarto di posizione**.

> 🎯 **Conseguenza operativa**: la giustificazione della cella `R97d`
> ("l'idea esterna del TP 1:1") regge **solo su Diego e su Master Nasdaq**,
> NON su Artemis. Anzi: **Artemis rema nella direzione OPPOSTA** — stop largo
> (1,0×ATR dietro il range) + target lungo con parziali. Che e' esattamente la
> direzione di R88/R97. **Artemis e' una conferma indipendente della tesi di
> R97, non un argomento per R97d.** Correzione da portare a Claudio prima che
> R97d venga eventualmente approvata.

### 2.2 🔴 IL VENDITORE HA SBAGLIATO A DESCRIVERE IL PROPRIO PRODOTTO, IN 7 MINUTI
**[VERIFICATO 22/08, testo verbatim dalla tab commenti MT5]**

- **20/07/2026 19:10** — Abriel Rivera (cliente): *"I just bought this EA
  today... Is there a News filter coded in the EA?"*
- **20/07/2026 19:18** — Gilks: *"**Yes**, the Artemis NAS100 ORB Edge EA
  includes a manual news filter. You can set up to three broker-time blackout
  windows to prevent new trades around major events such as CPI, NFP or FOMC."*
- **20/07/2026 19:25 (sette minuti dopo)** — Gilks: *"Apologies for the
  confusion. **I incorrectly stated** that the EA currently includes
  user-configurable news blackout settings... a dedicated news filter is
  **not yet available**. We are already adapting this feature and expect to
  introduce it **within the next few days**."*

**E il seguito lo misuriamo noi, sul file:** il preset v1.30 del **16/08/2026**
— **27 giorni dopo** quel "within the next few days" — contiene **ZERO input
di news** (letto riga per riga: 190 righe, nessuna occorrenza).

> Non e' una questione di simpatia. E' che **su una prop il filtro news e' una
> regola, non una comodita'**: chi vende un EA per NAS100 in apertura USA e non
> sa se il proprio prodotto ha il filtro news, **non ha misurato il proprio
> prodotto contro le regole delle prop**.

### 2.3 🔴 LA FABBRICA: 19 prodotti in 77 giorni
**[VERIFICATO 22/08, estratto dal feed "Published product" del profilo]**

| data | prodotto | prezzo |
|---|---|---|
| 2026.05.17 | Artemis Supertrend Pro Indicator | 35 |
| 2026.05.17 | Artemis ORB Breakout Indicator | 35 |
| 2026.05.18 | Artemis ORB Breakout Indicator MT5 | 49 |
| 2026.05.18 | Artemis Gold M1 Scalper MT5 | 35 |
| 2026.05.19 | Artemis ORB Scanner MT5 | 39 |
| 2026.05.20 | Artemis Trend Pro Indicator MT5 | 35 |
| 2026.05.23 | Artemis Tradedeck Trade Panel | 35 |
| 2026.05.24 | Artemis Trend Pro MT4 · Artemis Autochart AI | 35 / 49 |
| 2026.05.31 | Artemis One EA MT4 **e** MT5 (stesso giorno) | 35 / 35 |
| 2026.06.04 | **Artemis NAS100 Orb Edge EA MT4** | 59 |
| 2026.06.05 | Artemis Tradedeck Trade Panel MT4 | 35 |
| 2026.06.06 | Artemis US30 Opening Bell EA MT4 | 99 |
| 2026.06.27 | Artemis FX HFT Throttle MT5 | 49 |
| 2026.06.29 | Artemis Gold HFT Throttle EA MT5 | FREE |
| 2026.07.12 | **Artemis NAS100 Orb Edge EA MT5** | 59 |
| 2026.07.13 | Artemis Bitcoin Orbit EA MT5 | 99 |
| 2026.08.02 | Artemis Scalp X Pro MT5 | 69 |

**19 pubblicazioni in 77 giorni = un prodotto ogni 4 giorni**, su oro,
bitcoin, forex, indici, indicatori, scanner e pannelli. Profilo autore:
**26 prodotti**, campo "experience: **no**", **0 signals**, **0 subscribers**,
reputazione 4870, 10 amici. La pagina venditore ne conta 32 fra MT4 e MT5.

📌 E c'e' il gemello del Dow: **"Artemis US30 Opening Bell EA MT4" (99 USD,
06/06/2026)** — cioe' lo **stesso schema di apertura** rivenduto sull'indice
su cui gira la nostra sedia live `ABTG_ORB_Ottimizzato`. Un ORB per simbolo,
ognuno col suo prezzo.

### 2.4 🔴 IL MODULO RECOVERY NON E' UN RESIDUO: E' IL CUORE DI UN ALTRO LORO PRODOTTO
Il referto di stanotte segnalava giustamente la `Recovery Ladder` spenta.
**Il web aggiunge il pezzo che mancava**: la scheda di **Artemis Bitcoin Orbit
EA MT5** (13/07/2026, 99 USD), stesso autore, si presenta cosi' —
*"a more transparent alternative to a traditional grid or black-box basket
robot... **capped volatility-based recovery**, cost-aware **basket exits**"*.

> Quindi il motore di recovery/basket **e' codice condiviso della casa
> Artemis, venduto altrove come funzione principale**. Non e' un interruttore
> dimenticato: e' un modulo di prodotto, dentro il binario che gireremmo noi.

### 2.5 Cosa il preset Artemis ha di BUONO (e va detto, perche' e' materiale copiabile)
Il referto di stanotte non li ha elencati; sono i mattoni "prop" che ha davvero:

| input | valore | a cosa serve |
|---|---|---|
| `InpRiskPercent` | **0,2%** | rischio per trade (noi: 0,65%) |
| `InpMaxOpenPositions` | **1** | mai due posizioni insieme |
| `InpMaxDailyLossPercent` | **1,0%** | 🔵 **cap perdita giornaliera DENTRO l'EA** |
| `InpMaxTradesPerDay` | **6** | 🔵 tetto operazioni/giorno |
| `InpMaxConsecutiveLosses` | **6** | 🔵 stop dopo N perdite di fila |
| `InpCooldownMinutes` | **10** | 🔵 pausa fra un trade e l'altro |
| `InpUseReducedRiskHighVol` / `InpHighVolRiskMultiplier` | true / **0,5** | 🔵 dimezza il rischio in alta volatilita' |
| `InpUseEmergencyStop` + `InpEmergencyStopDDPercent` | true / **5,0%** | chiude tutto **e mette in pausa l'EA** |
| `InpMaxSpreadPoints` / `InpSlippagePoints` | 900 / 50 | guardia spread e slippage |
| `InpUseFridayEarlyExit` / `InpFridayExitHour` | true / **20** | 🟠 blocca il venerdi'... **ma `InpFridayCloseOpenTrades=false`**: non chiude quelle aperte |

Aritmetica del preset: **6 trade × 0,2% = 1,2%** teorici, tagliati a **1,0%**
dal cap giornaliero. E' una configurazione **coerente** con un muro
giornaliero del 5%: usa **un quinto** del muro nel giorno peggiore.

### 2.6 ⏰ L'ORARIO, calcolato bene (il referto di stanotte si fermava a meta')
Il preset e' scritto per un broker dove **l'apertura NY cade alle 16:30 di
chart time** (`InpNYOpenStartHour=16`, `InpNYOpenStartMinute=30`), con
`InpBrokerUTCOffsetHours=2` e `InpAutoDetectBrokerOffset=true`.

- 09:30 ET d'estate = 13:30 UTC → **16:30 su un broker GMT+3 (estate)**. Torna.
  Coerente anche `InpLondonStartHour=10` (= 07:00 UTC = apertura Londra).
- **BCM d'estate e' GMT+1** (regola di casa: server = ora italiana − 1; 15:30 IT
  = 14:30 server = 13:30 UTC). **Lo scarto e' di 2 ore esatte.**

> 🚨 **Se `InpAutoDetectBrokerOffset` non funziona come promesso, su BCM il
> range ORB si formerebbe alle 16:30 SERVER = 17:30 IT = 11:30 ET**: due ore
> dopo la campana, in piena mezza mattinata americana. Non "un'ora", **due**.
> E il venditore stesso, nel commento #1: *"Session settings use MT5 chart
> time, so **confirm that the configured New York open matches your broker's
> server clock**"*.

### 2.7 L'unico cliente che ha parlato, e cosa ha detto
Sulle DUE pagine (MT4 + MT5) esistono in tutto **18 commenti**: **12 sono del
venditore** (set file e annunci). I clienti sono **due**:
- **Abriel Rivera** (il compratore del 20/07): chiede la guida, chiede il
  filtro news, poi il **21/07** scrive che **un backtest di un anno gli ha
  richiesto oltre un'ora** anche col pannello spento, su Vantage / Switch /
  IC Markets. **Nessun risultato riportato. Mai.**
- **Robbert Van Rijswijk** (10/07, pagina MT4): *"testing it now, got any
  presets?"*. **Nessun seguito.**

Risposta del venditore (#7, 21/07) — **[DICHIARATO, NON MISURATO DA NOI]**:
*"the default settings for NAS... are quite positive in most broker accounts
- **we run it on IC Markets Live** (and 4 other brokers in demo)... you will
see we may sometimes not trade at all if we consider the ORB not to be
healthy."* → **gira in live secondo lui, ma il suo profilo ha 0 signals: quel
live non e' verificabile da nessuno.**

### 2.8 ⚠️ E la v1.30 ha CHIUSO dei parametri, non aperti
Commento #11: *"removing older technical parameters that are **now handled
internally by the EA**"* + `InpUseAdaptiveORBQuality=true`. Tradotto: fra
v1.13 e v1.30 una parte della logica e' **uscita dagli input ed e' entrata
nella scatola nera**. Per noi, che non avremo mai il sorgente, e' un
movimento **nella direzione sbagliata**: meno cose misurabili, non piu'.

---

## 3. 🧺 MASTER NASDAQ FTMO MT5 — il `.set` racconta piu' della scheda

### 3.1 🔴 CORREZIONE DI FATTO: il preset NON gira allo 0,4% di rischio
Prime tre righe utili del `.set` ufficiale 4.6:
```
Fixed_Start_Lotsize      = true      <- ATTIVO
Lotsize_set              = 0.01
Dynamic_Start_Lotsize_set= false     <- SPENTO
Risk_Percent             = 0.4       <- non usato, perche' il dinamico e' spento
```
**Il preset del venditore opera a LOTTO FISSO 0,01**, non a rischio
percentuale. Il "rischio basso 0,4%" citato nel referto di stanotte **non e'
il comportamento del file**: e' un input inerte.

📌 Conseguenza pratica: su un conto da 100k il preset cosi' com'e'
rischierebbe **briciole**; per renderlo sensato bisogna **accendere il
dinamico a mano** — ed e' esattamente li' che il conto dei §3.2 diventa
pericoloso.

### 3.2 🔴 20 POSIZIONI SIMULTANEE, E I 10 BLOCCHI SONO 5 (E SI SOMIGLIANO TROPPO)
Conteggio fatto sul `.set`, blocco per blocco (valore corrente, non default):

| blocco | max buy | max sell | attivo? | TF delle due MA | ATR period SL/TP | TP:SL |
|---|---|---|---|---|---|---|
| EA_1 | 0 | 0 | ❌ | H4/H1 | 40 | 1,0 : 1,0 |
| EA_2 | 0 | 0 | ❌ | H4/H1 | 45 | 1,0 : 1,0 |
| EA_3 | 0 | 0 | ❌ | H4/H1 | 40 | 1,0 : 1,0 |
| **EA_4** | **2** | **2** | ✅ | **H8** | **61** | 1,0 : 1,0 |
| **EA_5** | **2** | **2** | ✅ | **H6** | **62** | 1,0 : 1,0 |
| **EA_6** | **2** | **2** | ✅ | **H4** | **59** | 1,0 : 1,0 |
| **EA_7** | **2** | **2** | ✅ | **H2** | **60** | 1,0 : 1,0 |
| EA_8 | 0 | 0 | ❌ | H4/H1 | 40 | 1,0 : 1,0 |
| EA_9 | 0 | 0 | ❌ | H4/H1 | 40 | 0,8 : 0,8 |
| **EA_10** | **2** | **2** | ✅ | **H3** | **61** | 1,0 : 1,0 |

_(codici TF MT5 decodificati: 16385=H1, 16386=H2, 16387=H3, 16388=H4,
16390=H6, 16392=H8.)_

**Tre cose che escono da questa tabella, e sono tutte verificabili sul file:**

1. **Si comprano 10 strategie, se ne usano 5.** La scheda dice *"This EA have
   10 strategies"*; il preset ufficiale ne tiene accese **cinque**.
   ⚠️ **[INFERITO]** che `0` significhi "blocco spento": il range di
   ottimizzazione parte da 1. **Se invece `0` volesse dire "illimitato", il
   quadro peggiora**, non migliora.
2. 🔴 **Fino a 20 posizioni aperte insieme** (5 × [2 buy + 2 sell]). Con un
   ipotetico 0,4% per trade sono **8% di rischio aperto**: **2,5 volte il
   nostro cap C1 (3,25%)** e **oltre il muro giornaliero del 5%** in un colpo
   solo. E il nostro `ABTG_GuardiaIngresso` **non puo' fermarlo**, perche' e'
   codice loro (lo dice gia' il referto di stanotte, e resta il punto piu'
   duro del prodotto).
3. 🔴 **LA FIRMA DELL'OTTIMIZZATORE.** I 5 blocchi attivi sono **lo stesso
   template** con la sola TF delle medie spazzolata su **H8 · H6 · H4 · H3 ·
   H2** e il periodo ATR su **59 · 60 · 61 · 62**. Periodi ATR **interi
   adiacenti** non li sceglie un progettista: li sceglie una griglia di
   ottimizzazione. **Non sono 5 strategie: sono 5 celle vicine della stessa
   superficie.** Il che significa che la "diversificazione" promessa dai
   trade simultanei e' **esposizione correlata**, non diversificazione — 4
   posizioni per blocco, 5 blocchi che vedono quasi la stessa cosa.

**E il TP:SL e' 1:1 su tutti e dieci i blocchi** (stesso moltiplicatore ATR
per SL e TP; EA_9 fa 0,8/0,8, che e' sempre 1:1). Questo si', **e' un dato
solido a sostegno dell'idea "target 1:1"** della cella `R97d` — con Diego, e
**senza** Artemis (§2.1).

### 3.3 🔴 "PROPFIRM & FTMO NO LONGER SUPPORTED" — cosa ho potuto stabilire
**[VERIFICATO 22/08]**, testo integrale della scheda: *"Propfirm & FTMO no
longer supported, I am sorry about that."*

Ho letto **il changelog completo** (10 versioni, `/updates`):

| versione | data | testo dell'autore |
|---|---|---|
| 4.6 | 2026.02.07 | bugs fixed · big improvement · more better performance |
| 4.5 | 2025.07.16 | **impact goverment policy's solved** · bugs fixed |
| 4.4 | 2025.03.06 | Bugs fixed · Big improvement strategy |
| 4.1 | 2024.12.17 | Major updates · **Problem solved for ranging/sideways market** · **Remove MFI & stoch divergence** |
| 3.2 | 2024.11.12 | Many bugs fixed · **More aggressive** |
| 3.1 | 2024.08.18 | **remove MACD divergence** · **add stoch divergence** · **fixed time filter GMT (London Time)** |
| 3.0 | 2024.08.08 | re-entry SL and TP if empty |
| 2.9 | 2024.05.20 | **add MFI, AO, bearsbulls power divergence** |
| 2.8 | 2024.05.13 | **add EA2, EA3, up to EA8** |
| 2.2 | 2024.05.02 | **MACD divergent** · Adjust SL TP ATR |

> **Nessuna delle 10 voci nomina le prop firm.** Il ritiro del supporto prop
> **non e' mai passato dal changelog**: sta solo nella descrizione, **senza
> data**. E senza Wayback (bloccato, §0) **non posso datarlo** → **[INCERTO]**.
> Ho anche letto **tutti i 17 commenti**: **nessun cliente ha mai chiesto
> perche'**. Il thread e' fatto di **15 post del venditore con i set file** e
> **2 soli messaggi di clienti**.

📌 **Ma il changelog dice un'altra cosa, ed e' peggio del mistero FTMO**:
`MACD divergence` aggiunto (v2.2) → **rimosso** (v3.1); `stoch divergence`
aggiunto (v3.1) → **rimosso** (v4.1); `MFI` aggiunto (v2.9) → **rimosso**
(v4.1); da 1 blocco a 8 in undici giorni (v2.8). **Questo e' il diario di un
motore ri-ottimizzato sulla stessa storia, versione dopo versione.** E' il
difetto che in casa nostra si chiama *"filtro appiccicato"* — con la
differenza che qui e' documentato dall'autore stesso, in dieci righe.

### 3.4 Le 6 recensioni, per intero (e cosa NON dicono)
**[VERIFICATO 22/08 — testo dei clienti, NON verificato da noi]**
- *Mailan Chatur Rohman, 02/10/2025*: "BEST EA with low risk but maximum results always has SL TP to minimize risk, continue mas"
- *Raed Nuor, 30/04/2025*: "best EA I wish you all the best"
- *sato777, 08/11/2024*: "**I bought this EA on the recommendation of the developer.** So far, it is giving good results. It is a long term EA."
- *Moncy Kuriakose, 01/08/2024*: "Impressed with performance. This is long term EA. Good risk-reward ratio. All trades secured with SL and TP. Developer very supportive and friendly."
- *slkws, 12/07/2024*: "Best single shot EA"
- *Agus Wahyu Pratomo, 12/12/2024*: 5 stelle **senza testo**

> **Zero numeri. Zero drawdown. Zero periodi. Zero challenge passate o
> fallite.** Nessuna delle 6 recensioni contiene un dato misurabile — sono
> tutte del tipo "bravo, continua". Per il nostro metro **valgono zero**:
> non c'e' niente da confrontare con METRO_PROP.

### 3.5 La frequenza, dalla bocca del venditore
Unico scambio cliente-venditore utile di tutto il thread
**[DICHIARATO, NON MISURATO DA NOI]**:
- *Bartosz, 22/04/2026 12:04*: "How many times per day this ea is trading?
  **I bought it yesterday and so far any trade** - is this normal?"
- *Warsito, 12:08*: "**No trade per day, that's normal. but every week there
  is definitely trade**, just wait."

→ **Frequenza dichiarata: qualche trade a settimana.** Su un round da 150+150
operazioni (Emendamento, regola A) vorrebbe dire **anni** di storico.

### 3.6 Gli orari, tradotti in ora server BCM
Finestre in GMT dichiarate nel `.set`; **BCM d'estate = GMT+1** (regola di casa):

| blocchi | finestra GMT | **= ora server BCM** | = ora italiana | = ora New York |
|---|---|---|---|---|
| EA_1/2/8/9 (spenti) | 13:00-21:00 | **14:00-22:00** | 15:00-23:00 | 09:00-17:00 |
| EA_3 (spento) | 14:00-21:00 | **15:00-22:00** | 16:00-23:00 | 10:00-17:00 |
| **EA_4/5/6/7/10 (ATTIVI)** | **14:00-19:00** | **15:00-20:00** | 16:00-21:00 | **10:00-15:00** |

→ I blocchi attivi **evitano deliberatamente i primi 30 minuti** dopo la
campana e chiudono un'ora prima del gong. ⚠️ Resta **[INCERTO]** se l'EA
calcoli il GMT con `TimeGMT()` (che nel tester puo' non coincidere con il
GMT vero) — e il changelog v3.1 dice *"fixed time filter GMT"*, cioe' **su
quel punto un bug c'e' gia' stato**.

### 3.7 Il venditore, in numeri
**[VERIFICATO 22/08, profilo MQL5]**: Indonesia · reputazione **30.004** ·
**4,5 stelle su 112 recensioni** a livello venditore · **29 prodotti** ·
164 demo · esperienza dichiarata **2 anni** · 255 amici ·
🔴 **0 signals · 0 subscribers**.

E' una **reputazione reale**, incomparabilmente piu' solida di quella di
Artemis. Due note che vanno comunque scritte:
- il suo catalogo contiene **prodotti a griglia dichiarata** (*Gold
  Gridscalping*, *Grid Engulfing*, gratuiti). Non tocca questo EA — che nel
  `.set` **non ha** moltiplicatori di lotto — ma dice che la casa la griglia
  la vende;
- **nessun signal pubblicato**: la reputazione e' sul Market, **non su un
  track record**.

### 3.8 Dettagli minori ma utili
- Il nostro file e' `MASTER-NASDAQ-4.6-**RC1**` salvato **08/02/2026 07:34**,
  cioe' il giorno dopo il post del venditore (07/02 23:51). E' **il suo file
  ufficiale**, gratuito e pubblico nella tab commenti.
- `MagicStart=4371` → magic **4371-4380**. ✅ **Nessuna collisione** con i
  nostri (770xxx, 779001) ne' con Artemis (26060701).
- Massimo spread raccomandato **4.00**, conto **senza commissioni e senza
  swap** raccomandato. Su un conto prop reale quelle condizioni **non
  esistono**: e con un TP:SL di 1:1 il costo di transazione **morde
  direttamente sull'edge**.

---

## 4. 👤 DIEGO_NASDAQ_BANDS_INDICATOR — cercato, non trovato

**Ricerche fatte il 22/08** (tutte con esito **nullo**, non con esito
negativo — cioe': non ho trovato nulla, non ho trovato prove che non esista):
1. `"ServerMin_Summer" OR "ColRefHL" OR "AutoRemovePrevDay" indicator mql5` —
   sono **nomi di variabile distintivi**, il test piu' forte disponibile:
   **zero riscontri**;
2. `"Diego" Nasdaq bands indicator MQL5 "15:25" ORB` — solo ORB generici
   (Code Base 65361, Market 131340), **nessuna corrispondenza**;
3. ricerca in italiano su indicatori da corso con la candela delle 15:25 —
   **nulla**.

> ### ⚫ VERDETTO: **resta un file di provenienza informale.**
> Autore ignoto, nessuna pagina, nessuna licenza, nessun numero dichiarato,
> **nessuna traccia sul web con i suoi stessi nomi di variabile**. Va trattato
> esattamente come lo tratta gia' `INDICATORE_DIEGO_NASDAQ_2026-08-21.md` §7:
> **fonte d'ispirazione citata, mai motore candidato, mai in forward.**
> ⚠️ Va aggiunto un punto che i referti di stanotte non dicono: **senza autore
> non c'e' licenza**. Non sappiamo se sia ridistribuibile. Il fatto che sia
> un `.ex5`/indicatore preso da un gruppo lo rende **inadatto a qualunque uso
> su un conto pagato**, indipendentemente da quanto funzioni.

---

## 5. 🧱 LA TABELLA DEI BUCHI — cosa hanno loro che noi non abbiamo

Confronto contro `ABTG_Guardian.mq5` (righe 50-70, lette oggi) e contro gli
input dei nostri EA. In piu' ho censito un **quarto** prodotto, arrivato per
strada e piu' utile dei tre: **Prop Guard Pro** (Bright Lance Soli,
[172137](https://www.mql5.com/en/market/product/172137), **GRATIS**,
pubblicato 06/04/2026) — un guardiano prop puro, la cosa piu' vicina al nostro.

| meccanismo | noi (Guardian/EA) | Artemis | Master Nasdaq | Prop Guard Pro (free) |
|---|---|---|---|---|
| cap perdita giornaliera | ✅ 4,9% (+ pausa 4,0%) | ✅ **1,0% dentro l'EA** | ❌ | ✅ 5% default |
| DD totale | ✅ 9,9% statico | ❌ | ❌ | ✅ 10% + **toggle trailing** |
| cap rischio APERTO simultaneo | ✅ **3,25% (C1)** — nostro, raro fuori | ➖ (max 1 posizione) | ❌ (fino a 20 posizioni) | ➖ (`MaxOpenPositions`, conteggio non rischio) |
| **stop dopo N perdite di fila** | ❌ **BUCO** | ✅ 6 | ❌ | ❌ |
| **max trade al giorno** | ❌ **BUCO** | ✅ 6 | ➖ (`min_times_gap` 10-40 min) | ✅ `MaxDailyTrades` |
| **cooldown fra un trade e l'altro** | ❌ **BUCO** | ✅ 10 min | ✅ per blocco | ❌ |
| **rischio ridotto in alta volatilita'** | ❌ **BUCO** | ✅ ×0,5 | ❌ | ❌ |
| **flat serale / niente overnight** | ❌ **BUCO** | 🟠 solo venerdi', e **non chiude** | ❌ | ✅ 21:50 ora broker |
| **flat del venerdi'** | ❌ **BUCO** | 🟠 blocca i nuovi alle 20:00 | ❌ | ✅ 21:50 venerdi' |
| **filtro news da calendario MQL5** | 🟠 `InpUseNewsFilter` sui nostri EA (vedi `DOSSIER_NEWS_FILTER_2026-08-21.md`), **non nel Guardian** | ❌ **assente** (promesso e non consegnato) | ❌ | ✅ **−5 / +15 min, impatto ≥ alto, valute filtrate** |
| guardia spread | 🟠 da verificare EA per EA | ✅ 900 pt | ✅ max 4.00 | ❌ |
| cap lotto per posizione | ❌ | ✅ override | ❌ | ✅ `MaxLotSize` |
| chiude posizioni di QUALSIASI magic | ✅ `InpCloseAllMagics` | ❌ (solo le sue) | ❌ (solo le sue) | ✅ |
| preset pronti per prop | ❌ | ❌ | ❌ (ritirati) | ✅ **FTMO / FundedNext / E8** |

> ### 🎯 Il Guardian regge sui MURI. Gli manca il piano di sotto.
> Sui due muri (giornaliero e totale) e sul cap di rischio aperto **siamo piu'
> avanti di tutti e tre i prodotti** — il C1 al 3,25% nessuno di loro ce l'ha.
> **I buchi veri sono i freni di comportamento**: perdite consecutive, tetto
> di operazioni, cooldown, flat serale/venerdi'. Sono **le cose che
> impediscono la giornata storta**, non quelle che la fermano quando e' gia'
> successa.

---

## 6. ⚖️ LE TRE RACCOMANDAZIONI, MOTIVATE

### 6.1 🏹 ARTEMIS NAS100 ORB EDGE — **SI SCARTA COME EA. Si tiene UNA lettura.**

**Motivo primario, che e' formale e non opinabile:**
`CANCELLO_ACQUISTI_EA.md` **gradino 2**: *"recovery/griglia/martingala
**dichiarati o inferiti** = SCARTO anche se costasse 10 euro"*. La
`Recovery Ladder` e' **dichiarata dall'autore**, ha 3 layer, spaziatura 0,85
ATR e **moltiplicatore di lotto 1,2×**, ed e' **lo stesso motore che l'autore
vende come funzione principale del Bitcoin Orbit** (§2.4). Che sia `false`
nel preset non la toglie dal binario: **noi il sorgente non lo avremo mai**.

**Motivi che si sommano, tutti verificati:**
- **0 signals, 0 subscribers, esperienza dichiarata "no"**, 1 sola recensione
  in un catalogo di 26-32 prodotti, e **nessuna su questo EA**;
- **19 prodotti in 77 giorni** (§2.3) — non e' il ritmo di chi misura;
- il venditore **ha sbagliato a dire cosa contiene il proprio prodotto** e ha
  promesso un filtro news *"entro pochi giorni"* che **27 giorni dopo non c'e'**;
- v1.30 **sposta parametri dentro la scatola nera** (§2.8);
- il preset e' scritto per un broker a **2 ore di distanza da BCM** (§2.6).

**Cosa ci portiamo a casa (e vale davvero):**
1. 🔵 **Il pacchetto di freni** del §2.5 — perdite consecutive, trade/giorno,
   cooldown, rischio ×0,5 in alta volatilita', cap giornaliero dentro l'EA.
   **Sono quattro buchi nostri, riempiti da un preset che possiamo leggere
   gratis.**
2. 🔵 **La conferma indipendente della tesi di R97**: stop **1,0×ATR dietro il
   range** + target lungo con parziali. Qualcun altro, sullo stesso mercato e
   sulla stessa candela, ha risolto il problema del drawdown **allargando lo
   stop** — che e' esattamente cio' che R55 aveva diagnosticato e che R88 ha
   misurato sul Dow.
3. 🔴 **La correzione a `R97d`** (§2.1): Artemis **non** sostiene il TP 1:1.

**Se Claudio volesse comunque misurarlo** (sua facolta'): la demo Market gira
nel tester, **costo zero**. Ma nota il fatto tecnico riportato dall'unico
cliente: **oltre un'ora per un anno di backtest** — con la nostra finestra e i
nostri criteri sarebbe un round lentissimo. **La mia raccomandazione resta:
non spendere quel tempo, prendere i quattro numeri e chiudere.**

### 6.2 🧺 MASTER NASDAQ FTMO — **SI SCARTA. E il motivo non e' la scritta "FTMO".**

Il referto di stanotte lo scartava (giustamente) per il paniere ingestibile e
per la frase del venditore. **Le due cose nuove che ho trovato lo chiudono meglio:**

1. 🔴 **La firma dell'ottimizzatore** (§3.2): i 5 blocchi attivi sono lo stesso
   template con TF H8/H6/H4/H3/H2 e ATR 59/60/61/62. **Periodi adiacenti = celle
   vicine della stessa griglia.** E il changelog (§3.3) documenta **quattro
   indicatori aggiunti e poi rimossi** in due anni. In casa nostra questo ha un
   nome e una misura: *"filtro appiccicato, 0 successi su 5"*.
2. 🔴 **20 posizioni simultanee** su un cap di casa da 3,25%, con la nostra
   `ABTG_GuardiaIngresso` **che non puo' intervenire** perche' il codice non e'
   nostro. Nessuna configurazione lo aggiusta: e' architettura.

**Cosa ci portiamo a casa:**
- ✅ **il TP:SL 1:1 su tutti e 10 i blocchi** — l'unico sostegno esterno
  **solido** all'idea della cella `R97d`, insieme a Diego. Da misurare **col
  nostro motore**, mai col loro;
- ✅ la finestra dei blocchi attivi: **15:00-20:00 server BCM** (§3.6), cioe'
  **saltare i primi 30 minuti** dopo la campana. E' un'ipotesi **misurabile a
  costo quasi zero** sul nostro ORB: una cella con inizio ritardato.

⚠️ **E la frase sulle prop resta [INCERTO]**: non e' nel changelog, non e' nei
17 commenti, nessun cliente l'ha mai chiesto, e Wayback e' bloccato. **Non
inventiamo un motivo.** Quello che si puo' scrivere e' solo: *l'autore ha
ritirato il supporto prop senza spiegarlo, e nessuno gliel'ha chiesto.*

### 6.3 👤 DIEGO — **si scarta come file. L'idea era gia' nostra.**
Nessuna traccia sul web (§4), autore ignoto, licenza ignota. E la conclusione
del referto di stanotte regge intatta: **l'idea "stop fisso + 1:1" si prova
col NOSTRO ORB**, dove gli input esistono gia' (`InpSLBufferPts`, v1.02) e il
confronto con la cella live e' a parita' di tutto il resto.

### 6.4 🎁 IL PRODOTTO PIU' UTILE DEI QUATTRO NON E' NESSUNO DEI TRE
**Prop Guard Pro** ([172137](https://www.mql5.com/en/market/product/172137),
**gratis**, 06/04/2026) e' un **guardiano prop puro** con: DD giornaliero e
totale (con **toggle trailing**, che a noi manca ed e' la cosa che
`METRO_PROP` dichiara non ricalcolata), **filtro news dal calendario MQL5
integrato** (−5/+15 min, impatto ≥ alto, valute selezionabili), **flat
overnight e venerdi' alle 21:50 ora broker**, cap posizioni/trade/lotto,
kill switch manuale e **preset dichiarati per FTMO, FundedNext e E8**.

📌 **Non e' una proposta d'acquisto** (e' gratis) e **non e' una proposta di
sostituzione** del nostro Guardian, che sui muri e sul cap C1 e' migliore.
E' una **scheda di riferimento**: i suoi default sono la lista della spesa
piu' compatta che ho trovato per riempire i buchi della tabella §5. Il
giudizio su di lui vale quanto gli altri: **1 recensione, autore non
verificato** — quindi **si legge, non si installa**.

---

## 7. 📋 PROPOSTE PER LA TABELLA MADRE (`report/PIANO_PROP.md`) — **NON applicate, NON scritte da me**

Come da mandato: **segnalate qui, il PIANO_PROP lo tocca l'architetto-prop.**
Ordine per resa/costo.

| # | proposta | dove | fonte | costo stimato | rischio |
|---|---|---|---|---|---|
| **P1** | **Stop dopo N perdite consecutive nella giornata** (Artemis: 6; noi partiremmo da 3, coerente con 3×0,65% = 1,95%) | `ABTG_Guardian` (conta i deal chiusi del giorno) **oppure** input nuovo per EA | Artemis §2.5 | ~2h + 1 giro di autotest | conteggio sbagliato su hedging/parziali: va contato per **posizione chiusa in perdita**, non per deal |
| **P2** | **Tetto operazioni/giorno** per famiglia (Artemis: 6) | Guardian, con la stessa contabilita' di P1 | Artemis §2.5 + Prop Guard Pro | ~1h dopo P1 | blocca un'entrata buona dopo una giornata movimentata |
| **P3** | **Flat serale / niente overnight** con ora **in ora server BCM** (Prop Guard Pro: 21:50 ora broker) | Guardian (chiude tutto, tutti i magic — la funzione c'e' gia') | Prop Guard Pro §6.4 | ~2h | chiusura forzata su spread largo di fine giornata; **serve una guardia spread** o si paga il flat |
| **P4** | **Rischio dimezzato in alta volatilita'** (Artemis: ×0,5) | input negli EA, **non** nel Guardian (il Guardian non dimensiona) | Artemis §2.5 | ~3h + round di misura | e' un **filtro appiccicato** se non misurato: entra solo con un round suo |
| **P5** | **Cella "apertura ritardata"**: far partire l'ORB **30 minuti dopo** la campana (15:00 server BCM invece di 14:30) | asse nuovo in un round Nasdaq **successivo** a R97 | Master Nasdaq §3.6 | 1 asse in piu' | dimezza il campione: da valutare col canarino di R97 §2.1 |
| **P6** | **Cooldown minimo fra due ingressi** (Artemis: 10 min) | Guardian o EA | Artemis §2.5 | ~1h | poco utile con `InpMaxOpenPositions=1`; **bassa priorita'** |
| **P7** | **Toggle DD TOTALE TRAILING** nel Guardian (`InpDDMode=1` **esiste gia'**, ma le nostre Monte Carlo sono su DD **statico**) | ricalcolo delle Monte Carlo, non codice | Prop Guard Pro §6.4 + `METRO_PROP` | 1 giro di simulazione | **non e' una modifica di codice: e' un buco di MISURA gia' dichiarato nel progetto** |

🔴 **Nessuna di queste si applica da sola.** Vanno in coda all'imbuto come
qualunque modifica; gli `_Ottimizzato` girano in parallelo, mai sostituiti.

---

## 8. 🔧 LE DUE CORREZIONI DA PORTARE SUBITO A CLAUDIO

1. **`R97_CRITERI.md` §4.1 va corretto**: *"sia Diego che Artemis puntano a un
   TP vicino 1:1"* → **falso per Artemis** (`InpORBTakeProfitR=3.5`, §2.1).
   L'appoggio esterno al TP 1:1 viene da **Diego + Master Nasdaq**. La cella
   `R97d` resta esclusa (com'e' firmato), ma **se un giorno rientrasse, la
   motivazione va riscritta** — e per la regola della firma, **cambia il round
   dopo, non R97**.
2. **`ARTEMIS_NAS100_ORB_2026-08-21.md` §0 va corretto**: *"5 stelle, ma su 1
   SOLA recensione"* riferito a questo EA. Letto oggi: la tab recensioni della
   pagina **MT4 dice "Nessuna recensione"**, e **l'unica recensione del
   catalogo Artemis e' su "Artemis Trend Pro MT4"**, un altro prodotto. Il
   giudizio non cambia (campione nullo in entrambi i casi), ma il fatto si'.
   E il §4 dello stesso referto dice *"Nessun riferimento a filtro notizie...
   da verificare se manca davvero"*: 🔴 **verificato, manca davvero**, ed e'
   una promessa non mantenuta (§2.2).

---

## 9. 🗂️ ELENCO DELLE PAGINE APERTE (per chi verra' dopo)

| URL | cosa ci ho preso |
|---|---|
| `mql5.com/it/market/product/179855` | scheda Artemis MT4, prezzo, versione, **"Nessuna recensione"** |
| `mql5.com/en/market/product/180116` | scheda Artemis MT5, 20 attivazioni, 33 demo |
| `mql5.com/en/market/product/179855/comments` | 7 commenti MT4 (verbatim) |
| `mql5.com/en/market/product/180116/comments` | **11 commenti MT5 verbatim** — news filter, IC Markets live, v1.30 |
| `mql5.com/en/users/artemissignals` | 26 prodotti, **0 signals**, esperienza "no", **timeline delle pubblicazioni** |
| `mql5.com/en/market/product/175481` | catalogo Artemis completo (26 voci coi prezzi) |
| `mql5.com/en/market/product/111837` | scheda Master Nasdaq, descrizione integrale, 6 recensioni |
| `mql5.com/en/market/product/111837/comments` | **17 commenti verbatim** |
| `mql5.com/en/market/product/111837/updates` | **changelog completo, 10 versioni** |
| `mql5.com/en/users/yudisriwarsito` | 29 prodotti, 4,5 (112), **0 signals** |
| `mql5.com/en/market/product/172137` | **Prop Guard Pro**: input e default (§6.4) |
| ricerche Google/FF/Reddit su entrambi i prodotti | **nessuna traccia indipendente** |
| `web.archive.org` | ❌ **bloccato** — impossibile datare la frase sulle prop |
