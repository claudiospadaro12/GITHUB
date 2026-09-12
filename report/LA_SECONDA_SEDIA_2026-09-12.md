# 🪑🪑 CHI E' LA SECONDA SEDIA? — la graduatoria, ordinata per **giorni di lavoro che mancano**

**12/09/2026 (sabato).** Alla challenge restano **~19 giorni**, di cui **13 giornate di borsa** (12/09 → 30/09).
Referto di **sola lettura d'archivio**. 🛑 **Nessun backtest eseguito. Nessun EA, preset, magic, sedia o
parametro di forward toccato. Nessuna riga messa in coda.** Taglie, rischio, accensioni e il conto reale
restano **firma di Claudio**.

> 🚦 **NON ANCORA PASSATO DAL CANCELLO.** Dopo questo referto i 4 file prova passano da
> `controllo-preventivo`. Il cancello deterministico `controlla_prova.py` e' **gia' verde su 4 file su 4**
> (esito in fondo, §7).

---

# 0. 🥇 LA RISPOSTA IN SEI RIGHE

1. 🪑 **La seconda sedia e' `770101` — `ABTG_DAX_Apertura_EU` su `D30EUR` M5, LATO LONG.** E' l'unica
   candidata del parco che porta insieme: **n in POSIZIONI sopra il pavimento dei 150 in OOS (193,
   CONTATE)**, **R1 verificato manopola per manopola (80 input su 80)**, **DD misurato sul banco della
   challenge (7,2328% @1% su deposito 100.000, tick reali)** e **un cluster DIVERSO dal primo seggio**.
2. ⏱️ **Giorni di lavoro che mancano: ZERO di macchina per schierarla con due raccomandazioni dichiarate;
   UN GIORNO per chiudere col numero i suoi due requisiti rotti.** Il costo totale dei quattro round
   proposti e' **36 passate = 5,17 minuti** col metro di casa `T = 0,6 + 0,077 × passate` per round.
3. 🎁 **E in archivio c'e' gia', misurata da agosto e mai portata in campo, una cella che la batte con
   UNA SOLA MANOPOLA**: `InpTP1_ClosePct` 50 → 0 fa **PF OOS 1,39709 → 1,49140** e **DD OOS 7,2328% →
   6,2719%**, **a parita' di 193 posizioni**, e migliora anche l'IS. Non e' un round: e' una **firma**.
4. 🔴 **DUE NUMERI DEL PIANO DI OTTOBRE v2 SONO SBAGLIATI, e li correggo col file:riga.**
   `770202` non ha **130** posizioni: ne ha **96** (misurate). `770101` non ha **311**: ne ha **193**
   (misurate) — e **193 > 150, quindi il verdetto "merito pieno" REGGE, ma sul numero giusto**.
   Tutte e due le righe dicevano *"l'EA non ha `InpTP1Pct`, quindi sono posizioni"*: l'input di questa
   famiglia si chiama **`InpTP1_ClosePct`**, e nei preset vivi vale **50**.
5. 🔴 **E IL RIFRAMING DELLA MISSIONE VA EMENDATO, perche' l'ho verificato e a metà non regge.**
   *"I 150 vengono solo dal backtest, quindi comanda la profondita' di storico, quindi il forex va in
   testa"*: **vero di 15,1× in OHLC, vero di 1,14× a TICK REALI.** I tick di BCM partono dal
   **2024.07.05** sul forex e dal **2024.09.26** sugli indici: **24 mesi contro 21**. La profondita' da
   26 anni del forex esiste **solo in OHLC**, che per regola di casa *non da' mai un verdetto*. §1.
6. 📏 **E al posto del riframing caduto c'e' una LEGGE, misurata e falsificabile**: sul banco a tick di
   BCM, con lo split 40/60 del driver, una sedia ha **150 posizioni in TUTTE E DUE le finestre** solo se
   fa **≥ 0,82 POSIZIONI/giorno feriale**, e **solo in OOS** se fa **≥ 0,57**. Riprodotta al trade su
   `770101`: 0,728 pos/g × 183 gg = **133 previste contro 132 misurate**; × 265 gg = **193 previste
   contro 193 misurate**. 👉 **E' la spina dorsale della graduatoria.**

---

# 1. 🧪 IL CONTRO-ESEMPIO AL RIFRAMING — costruito prima della graduatoria, perche' la graduatoria dipende da lui

La missione dice, e mi chiede di verificarlo e non assumerlo:

> *"I 150 possono venire SOLO DAL BACKTEST, quindi cio' che rende una sedia schierabile e' la PROFONDITA'
> DI STORICO, non la velocita' del motore. Forex: dati dal 1999. Indici: 21 mesi. Questo sposta il forex
> in testa e gli indici in coda."*

**La prima meta' e' vera e la confermo. La seconda cade, e cade su una misura che era gia' scritta in casa.**

## 1.1 ✅ Cosa REGGE: i 150 in forward sono aritmeticamente impossibili

| | numero | fonte |
|---|---:|---|
| giornate di borsa 12/09 → 30/09 | **13** | `report/PIANO_CHALLENGE_OTTOBRE_v2.md` testa |
| operazioni/giorno/lato per fare 150 | **11,5** | `150 / 13` |
| la sedia piu' veloce del parco, misurata | **1,000 pos/g** (`771531`, 21 posizioni / 21 gg feriali in campo) | `report/EMA200_I_DUE_REQUISITI_2026-09-12.md` §6 |

👉 **Servirebbe un motore 11,5 volte piu' veloce del piu' veloce che abbiamo.** I 150 vengono dal banco: ✅ confermato.

## 1.2 🔴 Cosa NON REGGE: la profondita' che conta e' quella dei TICK, e li' il forex vince di 3 mesi

**Il fatto, misurato da altre sessioni e ritrovato da me in tre posti indipendenti:**

| dominio | forex | indici | rapporto |
|---|---|---|---:|
| **BARRE** (OHLC M1, `Modello 1`) | GBPUSD **1993.05.11** · USDJPY/EURUSD **1971.01.03** · e il tester **legge davvero dal 2000**: `R76` ha misurato **n IS 440-631, n OOS 461-695** contro i 190-256 di R71 | **2024.09.26**, stato **`COMPLETO`** — *il broker non ce l'ha* | **15,1×** |
| 🔴 **TICK REALI** (`Modello 4`, l'unico che da' verdetti) | **2024.07.05** | **2024.09.26** | **1,14×** |

Fonti: `backtest_pipeline/risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` §3 (indici `COMPLETO`) ·
`.../REFERTO_ROUND76_TETTO_E_SELEZIONE.md` §1 (il tester legge dal 2000) · `report/NOTA_PAVIMENTO_TICK_FOREX_2026-09-01.md`
e `report/DIAGNOSI_GBPUSD_LENTA_2026-09-02.md` r.17 (*"GBPUSD: ticks data begins from 2024.07.05"*, dal Diario del tester).

E la frase che chiude il discorso l'ha scritta **R76 stesso**, nel suo §6:

> 🔴 *"E il round a tick reali su tredici anni **NON SI PUO' FARE**: i tick di BCM partono dal 2024.07.05.
> Questa e' la tensione vera del progetto: possiamo avere **o** la finestra lunga **o** il riempimento
> vero, mai tutti e due."*

### 👉 La conseguenza, che ribalta l'ordine della graduatoria
- **Un numero OHLC non e' un verdetto** (regola di casa). Quindi la profondita' da 26 anni del forex
  compra **screening**, non sedie.
- **Nel dominio dei tick la finestra e' ~la stessa per tutti** (24 mesi forex, 21 indici). Allora cio' che
  decide i 150 **torna a essere la FREQUENZA**, non il simbolo — ma la **frequenza in POSIZIONI**, non in
  deal, e misurata **sul banco**, non in forward.
- 🔬 **Il contro-esempio piu' pulito e' un caso reale**: `ABTG_PTE` GBPUSD e' il motore con la finestra
  piu' lunga che abbiamo mai girato (**2000 → 2026, IS 431 e OOS 459 deal**, R78). **A tick reali lo
  stesso motore fa n = 49** (`R58`, IS 25 / OOS 49, finestra 2024.07.05 → 2026.06.30). **Ventisei anni di
  storico producono 49 operazioni di verdetto.** Se la profondita' fosse il criterio, PTE sarebbe la
  seconda sedia. Non lo e', ed e' il motivo per cui il riframing va emendato prima di ordinare la lista.

## 1.3 📏 LA LEGGE CHE PRENDE IL SUO POSTO, e la verifica contro numeri scritti da altri

Split del driver: `FrazioneIS 0,40` (`walkforward_generico.ps1` r.179). Finestra indici
`2024.09.26 → 2026.06.30` = **642 giorni**, `floor(642 × 0,40) = 256` ⇒ **IS 2024.09.26-2025.06.09
(≈183 giorni feriali)** · **OOS 2025.06.10-2026.06.30 (≈265 giorni feriali)**.

| requisito | posizioni/giorno feriale necessarie |
|---|---:|
| 150 in **TUTTE E DUE** le finestre (Emendamento A alla lettera) | **≥ 0,82** |
| 150 **solo in OOS** (merito leggibile fuori campione, IS sospeso) | **≥ 0,57** |

🔬 **Verifica contro numeri veri gia' scritti da qualcun altro, non contro valori che tornano.**
`770101` ha frequenza **0,728 pos/g** ricavata dall'OOS. Applicata **all'IS**, che e' un'altra finestra:

```
0,728 x 183 giorni feriali = 133 posizioni previste   <->  132 MISURATE  (scarto 0,8%)
0,728 x 265 giorni feriali = 193 posizioni previste   <->  193 MISURATE  (scarto 0,0%)
```
Le 132 e le 193 non le ho stimate io: sono **`position_id` distinti contati nei per-trade di R47**
(`risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772503.csv` → 193 deal = 193
posizioni · `..._772501.csv` → 270 deal = 193 posizioni). ✅ **La legge predice una finestra che non ha
usato per calibrarsi.**

🧪 **E ho provato a romperla con l'ipotesi alternativa**, perche' *"se non c'e' niente esce un numero
basso"* non e' un test. L'ipotesi alternativa e': *"la frequenza non e' una costante della sedia, cambia
con il regime, quindi la legge non predice niente"*. **Quale numero produce?** Se la frequenza cambiasse
col regime, IS e OOS darebbero **due** frequenze diverse: misurate, danno **0,721** e **0,728** —
**scarto 1,0% su 325 posizioni totali**. L'alternativa prevede uno scarto grande e misura 1,0%: **e'
falsificata sui dati, non sul nulla.** ⚠️ Limite dichiarato: due finestre dello **stesso regime** (21
mesi di indice in salita) non provano la costanza **fra** regimi. La legge vale **dentro il banco che
abbiamo**, che e' esattamente dove viene usata.

---

# 2. 🏁 LA GRADUATORIA — ordinata per giorni di lavoro che mancano

**Le colonne pretese dalla missione, e la regola che le governa**: `PF` e `DD` mai mescolati fra modelli
(🎯 = `Modello 4` tick reali · 📋 = `Modello 1` OHLC, **solo screening**); `n` in **POSIZIONI** e non in
deal (classe 226), con `[NON MISURATO]` dove il per-trade non esiste; `LATO` sempre dichiarato.

| # | motore · simbolo · TF · **LATO** | 🎯/📋 | **PF** | **DD** | **n POSIZIONI** | file:riga | requisito del certificato che manca | passate per chiuderlo | **frontiera del costo** | 🗓️ **giorni** |
|---:|---|:--:|---|---|---|---|---|---:|---|---:|
| **🥇 1** | `ABTG_DAX_Apertura_EU` **D30EUR M5 LONG** (`770101`) | 🎯 | **OOS 1,39709** · IS 1,12634 | **OOS 7,2328%** · IS 5,4362% (@1%, dep. **100.000**) | **OOS 193** · **IS 132** — **CONTATE** | `risultati_prove/aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_OOS_r47a.csv` r.2 · `..._IS_r47a.csv` r.2 · posizioni in `abtg_trades_..._772501.csv` (270 deal / 193 pid) e `..._772503.csv` (193/193) | **nessuno dei 5** (PF ✅ · n+DD ✅ · uscita ad asse ✅ 4 fasi · gemelli ✅ U30USD+NASUSD · TF ✅ `InpTrailTF` M1→M20). 🔴 Mancano **R3** (frequenza) e **R5** (costo) del piano di ottobre | **32** (R137a/b/c) + **4** (R138a) | 🟡 **33,0x** sulla geometria viva · 42,3x sullo stop pieno · **26,6x** al p95 dell'ora 08. Duro 13,3x **passato ×2,5**. Spread D30EUR ora 08: **mediana 1,70** · p95 2,70, su **30.974.789 tick** | **0** schierabile con raccomandazione · **1** per chiudere coi numeri |
| **🥈 2** | `ABTG_Dow_Apertura_US` **U30USD M5 LONG** (`770202`) | 🎯 | **OOS 1,27013** · IS 1,22247 | **OOS 4,3941%** · IS 5,6692% (@1%, dep. 100.000) | 🔴 **OOS 96** · **IS 56** — **CONTATE**, e **NON 130** come scrive il piano | `.../ABTG_Dow_Apertura_US_U30USD_OOS_r47c.csv` r.2 · posizioni in `abtg_trades_..._772505.csv` (130 deal / 96 pid, rapporto **1,3542**) e `..._772507.csv` (96/96) | 🔴 **n**: 96 posizioni = **64% del pavimento**, e **non colmabile**: la frequenza e' **0,36 pos/g**, sotto lo 0,57 che serve per 150 in OOS, e il banco a tick e' **tutta** la storia BCM dell'indice | **non esiste** un round che lo chiuda entro ottobre | ✅ 51,0x **ma stop INFERITO** (0 gambe in stop misurate); banda 44,5-53,5x | **0** di macchina · ma resta a **merito SOSPESO per aritmetica** |
| **🥉 3** | `ABTG_EMA200` **EURUSD H1 LONG** (sedia NUOVA, gemella del 1° seggio) | 🎯 | **PF mediana 1,2742** sulle 34 celle long · best 1,37120 | **6,22 – 8,25%** (@1%) | 🔴 **[NON MISURATO]** — 530-754 **deal**, nessun per-trade EURUSD in archivio. Col rapporto 2,0117 di U30USD ⇒ **264-375**, ma il rapporto di EURUSD **non e' misurato** | `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_EURUSD.csv` (143 righe; 94 celle vive, **94/94 in utile**; long 34/34, **33/34** con PF≥1,10 e n≥150 deal) | 🔴 **n in posizioni** · 🔴 **nessuno split IS/OOS** (finestra UNICA 2024.01.01→2026.06.30) · 🔴 `Optimization=2` = **GENETICO**: 34 celle su 120 combinazioni long ⇒ **le celle NON sono un campione uniforme**, e va detto | **60** (30 celle × 2 finestre) + **2** per il per-trade | 🔴 **20,8x a H1** — stop `1,0 × ATR(H1)` ≈ **18,0 pip** [DERIVATO], pedaggio all-in **0,864 pip** [MIS] ⇒ **ESCLUSO PER COSTO dal pavimento di lavoro 40x (52%)**, sopra il duro. 🟢 **A H4: 41,7x, PASSA** | **1** |
| 4 | `ABTG_EMA200` **AUDJPY H4 LONG** (`771512`, attaccata e **muta**) | 🎯 | **PF mediana 1,8628** — il piu' alto dell'archivio a tick su celle con n≥150 deal; 24/24 celle in utile, 21/24 passano | **2,15 – 5,23%** (@1%) | 🔴 **[NON MISURATO]** — 138-200 deal; col 2,0117 ⇒ **69-99** su 30 mesi = **0,11-0,16 pos/g** | `risultati_archivio/EMA200/realtick_H4/valid_ABTG_EMA200_H4_realtick_AUDJPY.csv` | 🔴 **frequenza**: 150 posizioni **per finestra** a H4 **non esistono nel banco a tick**, ne' oggi ne' a ottobre. E **0 posizioni in forward dal 01/08** | il muro **non si sfonda** con un round | ⚪ **NON MISURATO**: spread AUDJPY **illeggibile** alla sonda (`SpreadPt=0`). Commissione **0,4534 pip** [DERIVATA: 4,0 AUD × 0,6137 AUD/EUR ÷ 5,4147 EUR/pip]. Per 40x serve stop ≥ **38,1 pip** se lo spread e' 0,5 | **dopo** ottobre |
| 5 | `ABTG_EMA200` **GBPUSD H4 SHORT** | 🎯 | PF mediana **1,6760**; 32/32 in utile, 20/32 passano | 3,58 – 5,86% (@1%) | 🔴 [NON MISURATO] — 134-189 deal | `.../realtick_H4/valid_ABTG_EMA200_H4_realtick_GBPUSD.csv` | come #4. 🟢 **e conferma la regola dei due lati**: il LONG sullo stesso simbolo e TF fa **8/31** celle in utile, PF mediana **0,9644** | — | 🟢 **40,4x** a H4 (stop 30 pip [DERIVATO], all-in 0,742 pip) | **dopo** ottobre |
| 6 | `ABTG_SuperWave` **U30USD H1 L+S** (`770511`) | 🎯 | **9/9 celle** con PF≥1,10 e n≥150 deal; best **1,5214** | **4,02 – 5,41%** | 🔴 [NON MISURATO] — 209-227 deal, rapporto nella banda **1,50-1,82** ⇒ **115-151** | `risultati_archivio/SuperWave/valid_SuperWaveRT_U30USD_H1_realtick.csv` | 🔴 **R4 rotto e MISURATO IN CAMPO**: 2,00× (20/08, −72,32 EUR su 5.076,62 = **1,42%** contro un contratto da 1,0%) · 🔴 n in posizioni **a cavallo dei 150** · cluster **U30USD** | 2 (per-trade) + la compilazione R4 | 🔴 forbice **25,7x – 85,7x**, angolo pessimista 29,1x | **2-3** |
| 7 | `ABTG_SupRev` **U30USD H4 L+S** (`970911` fam.) | 🎯 | best **2,7679** | 3,14 – 10,02% | 🔴 [NON MISURATO] — 75-117 deal | `risultati_archivio/SupRev_nuovi_indici/valid_SupRevRT_U30USD_H4_realtick.csv` | 🔴 **n**: 117 deal e' **sotto 150 anche in deal** · cluster U30USD | — | ⚪ | **dopo** ottobre |
| 8 | `ABTG_EasyTrend` **GBPUSD H1** | 🎯 | 1,24174 (mediana su 6 celle) | 7,209% | 🔴 [NON MISURATO] — 106 deal | `risultati_prove/ABTG_EasyTrend/tick/valid_ABTG_EasyTrend_*.csv` | 🔴 **n** sotto 150 anche in deal · griglia di **6 celle**: nessun altopiano leggibile | — | ✅ 175,0x (stop 35,0 pip [MIS] n=1) 🟠 ma **35,0x** all-in | **dopo** ottobre |
| 9 | `ABTG_PTE` **GBPUSD H1 L+S** (`771332`, cand. R78) | 📋 **OHLC** | OOS **1,095** | OOS **9,87%** (@1%) | n **[NON MISURATO]** — 477 deal OHLC · 🎯 **a tick n = 49** | `risultati_archivio/REFERTO_ROUND78_SEDIA_VERA_FINESTRA_LUNGA.md` §2 · `REFERTO_ROUND58_PTE_TICK_REALI.md` | 🔴 **PF 1,095 < 1,10** · 🔴 il 477 e' **OHLC = screening** · 🔴 a tick il campione e' **49** | — | ⚪ 0 gambe in stop sul demo | **fuori** — §6 |
| 10 | `ABTG_ORB_Ottimizzato` **U30USD M5 LONG** (`770611`) | 🎯 | OOS **1,675** · IS 1,231 | 9,7623% @1% | **OOS 119 · IS 71** (`InpTP1Pct=0` verificato ⇒ posizioni) | `risultati_archivio/ritardo_r119b_csv/ABTG_ORB_Ottimizzato_U30USD_OOS_R119_ORB_D0000.csv` | 🔴 **n 119 < 150** e **invariante in tutte e 48 le celle di R88a** · 🔴 **R5 29,5x** e la via OPPRANGE **e' caduta il 12/09** (in campione **PF IS 0,962, profitto −738,45**) | — | 🔴 **29,5x** (74% del pavimento) | **fuori per ottobre** — §6 |
| 11 | `ABTG_SupertrendReversal` **225JPY H2** (`770901`) | 🎯 | — | 0,57% @0,65% | ~25 [INFERITO] | `report/PIANO_CHALLENGE_OTTOBRE_v2.md` §2 riga 5 | 🔴 **R5 13,6x**, a **0,3 decimi** dal pavimento **DURO** · 🔴 frequenza **0,18 op/g** | — | ⛔ **13,6x** | **fuori** |
| 12 | `ABTG_MaxMinNotte_DAX_Short` **D30EUR M15** (`770411`) | 🎯 | — | 0,83% @0,65% | ~11 [INFERITO] | idem, riga 4 | 🔴 frequenza **0,078 op/g** = **13× sotto** il pavimento · ⚪ R5 non misurato (0 gambe in stop su 5 trade) | — | ⚪ | **fuori** |
| 13 | `ABTG_SupRev_NAS_H1` **NASUSD H1** (`970913`) | 📋 | — | 1,17% @1%, **deposito non dichiarato** | 🔴 fra **39 e 155** [INFERITO] | idem, riga 6 | 🔴 **nessuna cella promossa** (solo etichetta) · 🔴 unico OOS in archivio e' **`_ohlc`** · 🔴 R5 **28,7x** e **minimo 9,70 idx = 5,4x**, sotto il duro | — | 🔴 28,7x | **fuori** |

## 2.1 🚨 LE ESCLUSIONI "PER SOLA FREQUENZA" RILETTE — la firma del 07/09 sposta il pavimento, e due candidati tornano in coda

La firma del 07/09 sposta il pavimento di **1,00 op/giorno** dalla **sedia** alla **FAMIGLIA**. Rilette con
quel metro, e **coi numeri**:

| candidato | perche' era escluso | come si legge **oggi** | dove va |
|---|---|---|---|
| `ABTG_EMA200` **AUDJPY/GBPJPY/200AUD/SPXUSD/GBPUSD H4** (`771511`-`771515`) | frequenza | 🔓 **La famiglia EMA200-H4 a cinque simboli farebbe 0,55-0,80 pos/g** (5 × 0,11-0,16). 🔴 **Resta sotto 1,00**, e soprattutto **il pavimento dei 150 POSIZIONI PER FINESTRA non e' raggiungibile a H4 nel banco a tick**: e' un vincolo di aritmetica, non di frequenza | **in coda all'imbuto**, per **dopo** ottobre. **Mai in campo in automatico** |
| `ABTG_DAX_Apertura_EU` su **F40EUR / E50EUR / E35EUR** | 🔴 **mai misurati** — non esclusi: **non provati** | 🟢 **E' il modo piu' economico di chiudere R3 sulla prima classificata**: `0,728 + 0,728 = 1,44` con **un solo** simbolo in piu' | **R138a scritto oggi**, 4 passate |

🔴 **E un buco che dichiaro senza colmarlo**, perche' e' la stessa classe di difetto che il 09/09 ci e'
costato quattro candidati: esiste in casa uno **"studio aperture FASE A" su 8 INDICI e ~3.500 trade a tick
reali**, citato da **quattro** referti (`APERTURE_TRAILING_DAX_NASDAQ.md` r.40 ·
`REFERTO_HISTDATA_FATTIBILITA.md` r.1132 · `ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md` r.79 ·
`Dow_Apertura/DOW_MOTORE.md`). **La sua tabella per simbolo NON l'ho trovata nel repo.** Se F40EUR ha
gia' un numero li' dentro, R138a e' un **RITEST di una bocciatura** e serve una tesi nuova — e la tesi
nuova ci sarebbe (la cella viva non e' la rottura cieca: e' un **RETEST** con offset 200 pt, che la FASE A
non misurava). **Va cercato prima di lanciare, ed e' scritto dentro il file prova.**

---

# 3. 🥇 LA PRIMA CLASSIFICATA, per intero — e il contro-esempio che la farebbe cadere

## 3.1 Perche' e' lei, e non `770202` che costa lo stesso

Le due sedie hanno lo **stesso costo di macchina (zero)** e lo **stesso stato di R1 (pieno e verificato)**.
Le separano tre numeri:

| | 🥇 `770101` D30EUR | 🥈 `770202` U30USD |
|---|---:|---:|
| **posizioni OOS** (misurate) | **193** ✅ sopra 150 | **96** 🔴 il 64% del pavimento |
| **posizioni/giorno feriale** | **0,728** (≥ 0,57 ⇒ OOS leggibile) | **0,362** (< 0,57 ⇒ **nessuna** finestra arriva a 150) |
| **cluster** | **D30EUR**, fuori dal cluster americano | **U30USD**, dove sta **il primo seggio** e altre 9 istanze |

👉 **Il punto decisivo e' il terzo, e non e' un'opinione**: il tetto per cluster **C10 al 3,0%** e' firmato
il 07/09 ed e' **spento in tre modi indipendenti** (default `0`, nessun preset lo valorizza, la versione in
campo non ha la manopola — `report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md`). **Finche' C10 e' spento, la
decorrelazione si compra scegliendo il simbolo, non con il Guardian.** Mettere la seconda sedia su U30USD
significherebbe portare in challenge **due sedie sullo stesso simbolo con la protezione di cluster
disattivata** — e i portafogli larghi senza controllo della correlazione che abbiamo letto hanno DD
misurati del **32,6%** e **45,6%**.

## 3.2 Le cinque caselle del CERTIFICATO DI MORTE, letta al contrario

| # | requisito | stato | il file:riga |
|---|---|---|---|
| **1** | **PF misurato** | ✅ **OOS 1,39709 · IS 1,12634**, tick, dep. 100.000 | `aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_{OOS,IS}_r47a.csv` |
| **2** | **n e DD** | ✅ **n OOS 193 · IS 132 POSIZIONI CONTATE** · **DD OOS 7,2328% · IS 5,4362%** @1% | per-trade `abtg_trades_..._772501.csv` / `..._772503.csv` |
| **3** | **gestione dell'uscita ad asse** | ✅ **quattro volte**: `InpTP1_ClosePct` (R47a/b: 0 e 50) · `InpTP1_R` · `InpBEatR` · `InpTrailFixedPts` (fase distanze, 48 pass) · `InpTrailMode` 0/1 e `InpTrailTF` **M1→M20** (fasi trailing/trailing2, 34 pass) | `Dow_Apertura/DOW_MOTORE.md` (famiglia) · `aperture_r47/` · `Walkforward_Aperture/REFERTO_TRAILING_SOGLIA.md` |
| **4** | **simboli gemelli provati** | ✅ **U30USD** (`Dow_Apertura/`, 186 pass a tick) e **NASUSD** (`Nasdaq_Apertura/`, ablazioni) — 🔴 **mai F40EUR/E50EUR** (→ R138a) | `risultati_archivio/{Dow,Nasdaq}_Apertura/` |
| **5** | **TF cambiato** | 🟠 **il TF del grafico e' M5 in tutte le corse**; sono stati cambiati `InpTrailTF` (M1→M20), `InpFilterTF` (H1/H4) e `InpLevelTF`. 🔴 **Il TF d'ingresso, mai.** Buco dichiarato | — |

> ### 🎯 Verdetto del certificato: **4 caselle piene, 1 parziale (il TF d'ingresso). Non e' un candidato "non ancora misurato": e' un candidato misurato a cui mancano due REQUISITI DEL PIANO, non due misure di esistenza.**

## 3.3 🧪 IL CONTRO-ESEMPIO OBBLIGATORIO — la misura che la farebbe cadere, e non cade

**La trappola piu' invitante dell'archivio, per questa sedia, e' esattamente quella che l'11/09 e' costata
mezza giornata a un altro agente**: prendere una coppia IS/OOS bellissima che misura **un'altra sedia**.
Quindi l'ho cercata e l'ho lasciata scattare.

### Trappola A — `Walkforward_Aperture/DAX_F_gestione_{IS,OOS}.csv` · **RIFIUTATA**
Hanno l'asse giusto sulla sedia giusta, e numeri che confermano la tesi. E **su 71 manopole confrontabili,
SEI differiscono in tutte e 16 le righe**, fra cui `InpAllowShort` (1 contro false) e `InpFilterTF`
(H4 contro H1). Gia' rifiutate da `report/SETACCIO_ARCHIVIO_2026-09-12.md` §0. **Non le uso.**

### Trappola B — `Dow_Apertura/dow_walkforward_{IS,OOS}.csv` · **RIFIUTATA, e questa l'ho trovata io**
Sono il pezzo piu' seducente dell'intero archivio: **40 celle su 40 in utile fuori campione, PF
1,267-1,560 (mediana 1,376), DD max 8,70%, n OOS 186-198, Modello 4, deposito 10.000**. Stavo per metterle
in cima alla graduatoria. **Poi ho fatto il diff contro il preset vivo di `770202`, manopola per manopola:
DODICI input differiscono**, e non sono cosmetici —

| manopola | cella del 40/40 | preset **VIVO** `770202` |
|---|---:|---:|
| `InpEntryMode` | **0** (BREAKOUT) | **2** (RETEST) |
| `InpRangeMinutes` | 15 | **35** |
| `InpBufferPoints` | 200 | **1000** |
| `InpAllowShort` | **1** | **false** |
| `InpRetestOffsetPts` | 0 | 400 |
| `InpTP1_R` | 0,33-0,84 (l'asse) | **1,0 — fuori dall'asse** |
| `InpTP1_ClosePct` | **0** | **50** |
| `InpBreakevenAtTP1` | 0 | **true** |
| `InpConfirmMode` | 1 | 0 |
| `InpEmaSlow` | 20-200 (l'asse) | 50 — **mai misurato esattamente**, sta fra 40 e 60 |
| `InpTrailFixedPts` | 12532 | 410 |
| `InpMagic` | 770201 | 770202 |

👉 **Il 40/40 misura un motore d'apertura BREAKOUT a due lati con range di 15 minuti. La sedia viva e' un
RETEST long-only con range di 35 minuti.** Sono **due sedie diverse**, e il referto stesso di
`DOW_MOTORE.md` lo ammette in coda (*"`InpEmaSlow = 50` non era nella griglia"*).
🔴 **Chi avesse portato a Claudio "il Dow ha un 40/40 fuori campione, e' la seconda sedia" avrebbe
consegnato il numero di un'altra configurazione.** E' il contro-esempio che ha cambiato la graduatoria:
`770202` scende al secondo posto **e** la sua etichetta di merito passa da 130 a 96.

### Prova C — e ora la stessa lente **CONTRO la mia prima classificata**
`R47a` vs il preset vivo di `770101`, **80 input confrontabili su 80**:

```
DIFFERENZE: 2
   InpRiskPercent      VIVO=0.65     R47a=1      <- pura TAGLIA
   InpMagic            VIVO=770101   R47a=772502 <- non tocca il trading
nel .set e non nel CSV: InpUsaGuardian, InpAllowReverse  (input aggiunti dopo il 14/08)
```
🟢 **Passa.** E passa anche il controllo indipendente: `R119` (round del 09/09) gira la **stessa** cella a
rischio **0,65%** e magic **770101** e riproduce `InpRangeMinutes 35 · InpEntryMode 2 · InpBufferPoints 500
· InpAllowShort 0 · InpTP1_R 1,0 · InpTP1_ClosePct 50 · InpBreakevenAtTP1 1 · InpTrailFixedPts 410 ·
InpTrailMode 1 · InpTrailTF 5 · InpSessionHour 8` — **undici manopole su undici**, con
`Trades 270 · PF 1,41105 · DD 4,3501%`.

### Prova D — 🔥 **il deposito, e chiude un `[NON MISURATO]` del piano di ottobre**
Il piano v2 scrive che il DD di `770101` **su banco 100.000 EUR e' `[NON MISURATO]`**. **Lo e'**, e il
numero sta in archivio da agosto. La prova non e' il commento del file prova: e' **l'aritmetica**.

| | R47a | R119 |
|---|---:|---:|
| profitto OOS | **+18.029,58** | **+1.103,31** |
| rischio | 1,0% | 0,65% |
| posizioni | 193 | 193 |
| ⇒ **R per posizione** | 18.029,58 / 193 / (1% × D) | 1.103,31 / 193 / (0,65% × D) |
| se **D = 100.000** | **0,0934 R** ✅ plausibile (`E alta` di casa = 0,075R) | 0,0088 R ❌ dieci volte troppo piccolo |
| se **D = 10.000** | 0,934 R ❌ **assurdo** | **0,0879 R** ✅ plausibile |

👉 **R47a gira a deposito 100.000 e R119 a 10.000 — dedotto dai P/L, non dai commenti.** E il regalo e' il
controllo incrociato: **0,0934 R e 0,0879 R sono lo STESSO edge misurato su due banchi diversi** (scarto
6,3%). Quindi:

> ## 🟢 **DD di `770101` sul banco della challenge: 7,2328% a rischio 1,0% su deposito 100.000 EUR, TICK REALI, n = 193 POSIZIONI. Per scala lineare del rischio: 4,70% a 0,65%.**
> Il **4,3501%** di R119 e' lo stesso DD **su banco 10.000**: lo scarto **+8,0%** riproduce, da dati
> indipendenti, il *"+7,8% di solo effetto deposito"* che il piano v2 aveva misurato. **Due derivazioni
> diverse, stesso numero.**
> ⚠️ **Limite dichiarato:** la scala 1,0% → 0,65% e' **lineare per assunzione**. Il DD non e' esattamente
> lineare nel rischio (composizione). Il numero **misurato** e' il 7,2328% @1%.

### 🚫 E cosa NON ho potuto rompere, quindi resta in piedi come rischio
- **La prova di REGIME.** 21 mesi di storico BCM su `D30EUR`, stato **`COMPLETO`** (il broker non ha
  nulla prima): **un solo regime, toro**. La regola C dell'Emendamento della Finestra **non e' soddisfatta
  e non lo sara' il 30/09.** Nessun round la chiude.
- **L'IS a 132 posizioni.** Sotto il pavimento: l'IS giudica **segno e rischio**, mai il merito
  (Emendamento B). Il merito lo porta l'OOS, con 193.
- **La peggior escursione giornaliera di EQUITY.** `[NON MISURABILE]` dai CSV, ed e' **la** grandezza che
  decide il muro giornaliero della prop. La chiude solo un forward osservato.
- **Lo spread al MINUTO dentro l'ora 08.** L'istogramma e' **orario**, e l'ora 08 e' l'ora dell'apertura
  europea, cioe' il minuto peggiore dell'ora. 🔴 **I 33,0x e 42,3x sono OTTIMISTI PER COSTRUZIONE.**

## 3.4 🎁 Il regalo dell'archivio: una cella migliore a UNA manopola, ferma da un mese

`R47a` e `R47b` misurano la stessa sedia con `InpTP1_ClosePct` = **50** (la cella viva) e = **0**, **tutto
il resto identico** — verificato da me: **una** manopola di differenza.

| | `InpTP1_ClosePct` **50** (VIVA) | `InpTP1_ClosePct` **0** | Δ |
|---|---:|---:|---:|
| **IS** PF · DD · profitto | 1,12634 · 5,4362% · +3.789,36 | **1,18323 · 4,9576% · +5.569,37** | PF **+0,057** · DD **−0,479** · profitto **+47%** |
| **OOS** PF · DD · profitto | 1,39709 · 7,2328% · +18.029,58 | **1,49140 · 6,2719% · +23.607,28** | PF **+0,094** · DD **−0,961** · profitto **+31%** |
| **posizioni** | **193** | **193** | **0** — non e' selezione, e' **gestione** |

> 🎯 **Meglio su TUTTI E DUE gli assi, in TUTTE E DUE le finestre, a parita' di campione.** E la regola di
> selezione va dichiarata insieme al numero: **qui non sto scegliendo il centro di un altopiano**, sto
> confrontando **due** valori di una manopola binaria — quindi il criterio applicato e'
> *"migliora PF **E** DD in **entrambe** le finestre"*, che e' il cancello (b) di casa, e lo passa.
> ⚠️ **Il vantaggio di PF in OOS (+0,094) e' appena sotto la soglia di rumore di 0,10 che il progetto usa
> per una cella isolata.** E' per questo che il verdetto non poggia sul PF da solo: poggia sul **fatto che
> migliorino insieme PF, DD e profitto, in due finestre indipendenti, con lo stesso n**. Su una manopola a
> due valori quello e' il massimo di robustezza ottenibile.

🔬 **Non e' una mia scoperta, ed e' la sua forza**: la stessa cella e' stata trovata il **09/09**
(`report/R120_GESTIONE_APERTURE_2026-09-09.md`) e **ritrovata alla cieca** dal setaccio del **12/09**
(`report/SETACCIO_ARCHIVIO_2026-09-12.md` §0, riga *"meglio su TUTTI E DUE gli assi — **mai portata in
campo**"*). **Tre letture indipendenti, stessa cella, zero firme.** 👉 Cio' che manca non e' una misura:
e' una **firma**.

---

# 4. 📐 LA GRIGLIA PROPOSTA — 4 round, 36 passate, **5,17 minuti**

Metro di casa: **`T(min) = 0,6 + 0,077 × passate`, per ROUND.**

| ord. | file prova (scritto oggi, cancello ✅) | asse | celle | passate | **T (min)** | cosa chiude | attesa **DICHIARATA PRIMA** |
|---:|---|---|---:|---:|---:|---|---|
| **1** | `prove/R137c_parziale_770101_D30EUR.txt` | `InpTP1_ClosePct` (0 / 50) | 2 | **4** | **0,91** | 🚦 **il cancello del gruppo**: riproduce R47a/R47b sul binario di oggi · e porta la cella a una manopola davanti a Claudio con un numero **di oggi** | **riproduzione esatta**: 175/1,12634/5,4362 e 270/1,39709/7,2328 · 132/1,18323/4,9576 e 193/1,49140/6,2719. Se **uno** diverge, il verdetto e' *"il binario di oggi non e' quello di R47"* e i round 2-3 **non si leggono** |
| **2** | `prove/R137a_floorstop_allarga_770101_D30EUR.txt` | `InpMinStopPts` 800→12800, `SkipIfTight=false` | 7 | **14** | **1,68** | 🟡 **R5**, il cancello del costo — ramo **ALLARGA** | **Trades ~invariato** (il floor non tocca la selezione); **PF [NON MISURATO]**; **DD 5-9%**. 🔴 **Previsione scomoda: mi aspetto che il floor COSTI edge**, perche' su questo motore lo stop e' **geometrico** (estremo opposto del range) e quindi *porta informazione*: un floor la cancella nei giorni compressi. Se esce cosi', il verdetto e' *"R5 si chiude PAGANDO, e il prezzo e' questo numero"* — ed e' un risultato, perche' oggi quel prezzo non lo conosce nessuno |
| **3** | `prove/R137b_floorstop_salta_770101_D30EUR.txt` | `InpMinStopPts` 800→12800, `SkipIfTight=true` | 7 | **14** | **1,68** | 🟡 **R5**, ramo **SALTA** (ed e' il valore che sta **gia' nel preset vivo**, spento solo da `InpMinStopPts=0`) | 🔴 **DICHIARATO PRIMA: questo round NON PUO' DARE UN VERDETTO DI MERITO.** Lo stop mediano vivo e' 56,1 idx; un floor a 68 idx e' **sopra la mediana** ⇒ per costruzione salta **piu' della meta'** delle operazioni ⇒ 193 posizioni diventano **~60-100**, sotto il pavimento. Misura **la FORMA** e **il RISCHIO**, non il merito |
| **4** | `prove/R138a_gemello_F40EUR_770101.txt` | `InpMagic` gemello (asse **tecnico**, cancello G1) | 2 | **4** | **0,91** | 🟡 **R3**, la frequenza **per FAMIGLIA** | **passa se F40EUR fa ≥ 0,28 pos/g** (perche' `0,728 + 0,28 = 1,00`). Atteso **130-230 posizioni OOS = 0,49-0,87 pos/g** [STIMATO]. 🔴 **Previsione scomoda: mi aspetto F40EUR PIU' LENTO del DAX**, non piu' veloce. **PF e DD: [NON MISURATO], e non invento un'attesa che non ho** |
| | **TOTALE** | | **18** | **36** | **5,17** | | |

## 4.1 🔴 Le soglie congelate, prima dei numeri — le stesse in tutti e quattro i file
- **A1 ALTOPIANO (merito):** ≥ **3 celle contigue** con, **ciascuna**, `PF OOS ≥ 1,40` **E** `posizioni
  OOS ≥ 150` **E** `DD OOS ≤ 8,0%` **E** rapporto minimo garantito **≥ 40x**.
  🔴 **PF 1,40 e non 1,10**: non si cerca l'ammissione di un candidato, si cerca se una manopola **batte**
  un **1,39709 gia' misurato**. Una soglia sotto il valore in essere premierebbe un peggioramento.
- **A2 il pavimento dei 150 e' ASIMMETRICO:** una cella sotto 150 posizioni non conta **mai a favore**;
  puo' contare **contro**, come fatto di forma.
- **A3 anti-altopiano-finto:** due celle contigue con `Trades` identico e `PF` identico alla quarta cifra
  **non sono due celle**: sono un tratto di asse **INERTE** (censimento 09/09: **874 CSV su 1.960** con
  passate a esito identico).
- **A8 SELEZIONE, dichiarata insieme al numero:** si porta avanti il **CENTRO** del tratto contiguo,
  **MAI il picco**. Se il centro e' una cella fuori costo, **non si porta avanti niente**.
- **A10:** 🛑 **nessuno dei quattro round promuove niente**, non cambia un preset, non accende una sedia,
  non tocca il forward, non nomina il conto reale.

## 4.2 💰 La frontiera del costo, col numero — e cosa fa la manopola
Spread `D30EUR` all'**ora modale 08** (19 gambe su 34), misurato su **30.974.789 tick**
(`risultati_archivio/spread_flotta/spread_orario_D30EUR.csv` r.10): **mediana 1,70 idx · p95 2,70 · max 12,0**.
Stop: **71,9 idx** [MIS] n=7 sulle gambe vere · **56,1 idx** sulla geometria viva
(`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.391 e r.541 — **riprodotti tutti e tre da me**).

`InpMinStopPts` **garantisce un rapporto MINIMO** (nessuna gamba puo' piu' stare sotto il floor), e su quel
minimo R5 va letto — una gamba sotto 13,3x e' un problema di aritmetica, non di mediana:

| floor pt | floor idx | min x @ 1,70 | min x @ 2,70 (p95) | verdetto **congelato adesso** |
|---:|---:|---:|---:|---|
| 800 | 8,0 | 4,7x | 3,0x | ⛔ **sotto il DURO**, esclusa per aritmetica |
| 2800 | 28,0 | 16,5x | 10,4x | 🔴 fuori costo |
| 4800 | 48,0 | 28,2x | 17,8x | 🔴 fuori costo |
| **6800** | **68,0** | **40,0x** | 25,2x | 🟢 **pavimento di lavoro, esatto alla mediana** |
| 8800 | 88,0 | 51,8x | 32,6x | 🟢 |
| **10800** | **108,0** | 63,5x | **40,0x** | 🟢🟢 **dentro anche al p95** |
| 12800 | 128,0 | 75,3x | 47,4x | 🟢 |

🎯 **Due celle cadono ESATTAMENTE sulle due frontiere, e non e' un caso**: l'asse e' costruito perche'
`68,0 × 1,70 = 40,0` e `108,0 × 2,70 = 40,0`. **E' il motivo per cui il passo parte da 800 e non da 0.**
🎁 **E la cella 800 compra una misura che non abbiamo:** `270 − Trades(800)` = **quante gambe avevano uno
stop geometrico sotto 8 idx**, cioe' sotto **4,7x**. Se il numero e' 0 la manopola e' inerte li' e quella
cella e' una **seconda riproduzione gratis**; se e' > 0, e' una notizia sul rischio della sedia **viva**.

## 4.3 ⚠️ Le tre cose da fare prima di premere invio
1. ⚙️ **UN SOLO agente locale (`Core 1`)** in MT5 → Strategy Tester → Agenti (**classe 129**): con piu'
   agenti le celle gemelle divergono, e in `R138a` la coppia gemella **e'** il cancello d'identita'.
2. 🚦 **I due cancelli sulla riga**: `controlla_riga.py` **e** l'agente `controllo-preventivo`. Il
   cancello sui file prova e' **gia' verde** (§7). Il primo che fallisce blocca.
3. 📐 **`-SoloControllo` prima di ogni round**, e la riga **deve** portare **`-Deposito 100000`** e
   **`-Modello 4`**. Se parte a 10.000 o in OHLC, i confronti con R47a decadono e i file vanno
   **riscritti**, non *"letti con prudenza"*.

---

# 5. 🕳️ I BUCHI DICHIARATI — elencati **per nome** (classe 180), mai "tutto cio' che non e' X"

| # | cosa manca | perche' | conseguenza, in numeri |
|---:|---|---|---|
| 1 | **n in POSIZIONI di 6 candidati su 13** (#3, #4, #5, #6, #7, #8) | i loro per-trade **non sono in archivio** | il loro campione vero sta in bande larghe: EURUSD **264-375**, AUDJPY **69-99**, SuperWave **115-151** |
| 2 | **il rapporto deal/posizioni di EMA200 su FOREX** | misurato **solo** su U30USD (2,0117) | applicarlo a EURUSD/AUDJPY e' una **derivazione**, e va scritta come tale |
| 3 | **lo spread orario di F40EUR, AUDJPY, GBPJPY, 225JPY, XAUUSD** | `spread_flotta/` ha **3 file su 13 simboli**; alla sonda del 17/08 AUDJPY/GBPJPY/AUDUSD/CADJPY/USDNOK leggono **`SpreadPt=0`** = *nessun tick in quel momento*, **non spread nullo** | R5 su quei simboli e' ⚪ **NON ANCORA MISURATO**, mai 🟢 e mai 🔴. Costo per chiuderlo: `ABTG_SpreadOrario`, **zero passate di tester** |
| 4 | **lo spread al MINUTO dentro l'ora** | l'istogramma e' **orario** | su `D30EUR` l'ora 08 e' l'apertura europea: **33,0x e 42,3x sono ottimisti per costruzione** |
| 5 | **il pedaggio si paga DUE volte** e l'ora dell'**uscita** e' `[NON MISURATA]` su ogni sedia | il cancello 40x e' definito contro **uno** spread e resta cosi' per confrontabilita' | **il pedaggio vero e' circa il doppio**, su tutte le sedie |
| 6 | **la tabella per simbolo dello studio "FASE A"** (8 indici, ~3.500 trade, tick) | citata da 4 referti, **non trovata nel repo** | se F40EUR ha un numero negativo li', `R138a` e' un **ritest**, non una casella libera → §2.1 |
| 7 | **il valore del punto di `D30EUR` e `F40EUR`** | la riga `D30EUR` della sonda non ha `TickValue` leggibile | sentinella: se una cella larga torna con `Trades` molto basso **e** profitto ~0, il sospetto e' **lotto nullo**, non edge |
| 8 | **la sovrapposizione dei giorni operativi D30EUR ↔ F40EUR** | non ricavabile dai CSV di riepilogo | 🔴 **due indici europei che aprono allo stesso minuto possono dare frequenza doppia e diversificazione ZERO.** Il verdetto di `R138a` e' **condizionato** a questa misura (strumenti gia' in casa: `sovrapposizione_sedie.py`, `chi_va_con_chi.py`) |
| 9 | **la prova di REGIME** | 21 mesi di storico indici BCM, stato `COMPLETO`: **un solo toro** | la regola C dell'Emendamento **non e' soddisfatta e non lo sara' il 30/09**. Niente di questi round e' promuovibile senza |
| 10 | **la peggior escursione giornaliera di EQUITY** di `770101` | `[NON MISURABILE]` dai CSV | ed e' **la** grandezza che decide il muro giornaliero della prop |
| 11 | **il TF d'ingresso di `770101`** | M5 in tutte le corse d'archivio | casella 5 del certificato: **parziale** |
| 12 | **il lato SHORT della prima classificata** | la sedia viva e' **long-only** | la regola del 25/08 e' soddisfatta **altrove** sulla stessa EA e sullo stesso simbolo (`r83_csv`, `r118_csv`, `csv_r51` girano con `InpAllowShort=1`; il lato corto **da solo** vale **+3,8873 punti di DD**). Sulla **sedia** resta un buco dichiarato |

---

# 6. 🪦 GLI SCARTI, COL NUMERO — e le righe che vanno in `REGISTRO_TEST.md`

Tutti gli scarti di questo dossier sono scritti in `backtest_pipeline/REGISTRO_TEST.md` con **PF, DD, n e
il cancello**. Qui il riassunto, perche' *"un morto senza certificato non e' un morto: e' un'occasione
persa che nessuno ritrovera' piu'"*.

| candidato | PF | DD | n | 🚧 cancello che lo ferma | verdetto |
|---|---|---|---|---|---|
| `ABTG_PTE` GBPUSD H1 (`771332`) | 📋 OOS **1,095** | **9,87%** @1% | 477 **deal** OHLC · 🎯 **49 a tick** | **PF < 1,10** su un campione che e' **screening**, e a tick il campione e' 49 | 🪦 **scartato come SECONDA SEDIA, col numero** (resta la sedia del duello: non la toccco) |
| `ABTG_EMA200` **EURUSD H1 L+S** | 🎯 OOS **1,076-1,224** | **9,05-11,98%** @1% | 583-759 **deal** | **R29: 7/30 PASS pieni** — meta' regione manca `PF 1,10`, meta' sfonda `DD 10%` | 🔴 **bocciato a L+S**, e resta cosi' |
| `ABTG_EMA200` **EURUSD H1 LONG da solo** | 🎯 PF mediana **1,2742**, 34/34 celle in utile | **6,22-8,25%** @1% | **[NON MISURATO]** | 🟠 **"NON ANCORA MISURATO", non morto**: R29 girava `InpAllowLong=1` **E** `InpAllowShort=1` in **tutte e 30** le celle (verificato da me nei CSV). Il lato separato **non ha mai visto uno split IS/OOS**. E R29 scrive: *"si riapre SOLO con una tesi nuova, non con un ritocco delle soglie"* — **il lato E' una tesi nuova**, ed e' la regola del 25/08 | 🔓 **in coda all'imbuto**, 60 passate |
| `ABTG_EMA200` EURUSD **H1** — costo | — | — | — | **20,8x** contro il pavimento di lavoro 40x (52%) | 🪦 **ESCLUSO PER COSTO col numero.** 🟢 A **H4: 41,7x, passa** |
| `ABTG_EMA200` H4 su AUDJPY · GBPJPY · GBPUSD · 200AUD · SPXUSD (`771511`-`771515`) | 🎯 PF mediana **1,20-1,86** | **1,39-9,46%** | **[NON MISURATO]**, banda **21-104** | **FREQUENZA/ARITMETICA**: 0,11-0,16 pos/g ⇒ **150 posizioni per finestra non esistono nel banco a tick a H4**. E **0 posizioni in forward dal 01/08** | 🟠 **fuori PER FREQUENZA, non per edge** — e va scritto cosi' |
| `ABTG_ORB_Ottimizzato` U30USD M5 (`770611`) | 🎯 OOS **1,675** | 9,7623% @1% | **119 OOS / 71 IS** (posizioni) | **n 119 < 150** e **invariante in tutte e 48 le celle di R88a** · **R5 29,5x** · la via OPPRANGE **e' caduta il 12/09** (PF IS **0,962**, profitto **−738,45**) | 🔴 **fuori per ottobre** come SECONDA sedia |
| `ABTG_SupertrendReversal` 225JPY H2 (`770901`) | — | 0,57% @0,65% | ~25 | **R5 13,6x**, a **0,3 decimi** dal pavimento **DURO** · frequenza **0,18 op/g** | ⛔ **fuori per COSTO** |
| `ABTG_MaxMinNotte_DAX_Short` D30EUR M15 (`770411`) | — | 0,83% @0,65% | ~11 | frequenza **0,078 op/g** = **13× sotto** il pavimento | 🔴 fuori |
| `ABTG_SupRev_NAS_H1` NASUSD H1 (`970913`) | 📋 | 1,17% @1% (deposito non dichiarato) | **39-155** [INF] | **nessuna cella promossa** · unico OOS e' **`_ohlc`** · R5 **28,7x** con **minimo 5,4x** sotto il duro | 🔴 fuori |
| `Dow_Apertura` U30USD — **il 40/40 OOS** | 🎯 1,267-1,560 | max 8,70% | 186-198 | 🔴 **misura un'ALTRA sedia**: 12 input differiscono dal preset vivo (`EntryMode` 0 vs 2, `RangeMinutes` 15 vs 35, `AllowShort` 1 vs false, …) | 🚫 **non utilizzabile per `770202`** — §3.3 trappola B |

---

# 7. ✅ IL CANCELLO SUI FILE PROVA — esito, riprodotto qui

```
=== CONTROLLO FILE PROVA ===
  R137a_floorstop_allarga_770101_D30EUR.txt  ABTG_DAX_Apertura_EU.mq5  pin=81 celle= 7  OK
  R137b_floorstop_salta_770101_D30EUR.txt    ABTG_DAX_Apertura_EU.mq5  pin=81 celle= 7  OK
  R137c_parziale_770101_D30EUR.txt           ABTG_DAX_Apertura_EU.mq5  pin=81 celle= 2  OK
  R138a_gemello_F40EUR_770101.txt            ABTG_DAX_Apertura_EU.mq5  pin=81 celle= 2  OK
file: 4 | celle totali: 18 | passate (celle x 2 finestre): 36 | problemi: 0
ESITO: OK
```
Dettagli d'igiene che il cancello **non** controlla e che ho verificato a mano:
- **`InpSessionHour = 8` = ORA SERVER BCM** in tutti e quattro i file (DAX e CAC aprono 09:00 IT). La
  regola di casa dice che un CSV con `InpSessionHour = 9` va **cestinato**.
- **`InpNewsCurrencies` NON e' pinnato**, di proposito: un pin di stringa **vuota** viene **ignorato** da
  MT5 e il cancello lo boccia (controllo 3). Il default compilato e' gia' la stringa vuota.
- **Magic vergini**, verificati repo-wide il 12/09 (`grep -rl`, `.git` escluso → **0 file**): `786201`
  (R137c) · `786202` (R137a) · `786203` (R137b) · `786204`/`786205` (R138a, coppia gemella).
- **`-Modello 4`** = tick reali e **`-Modello 1`** = OHLC M1: nei quattro file il commento e il valore
  **non sono invertiti** (classe 273), e il modello **non e' pinnato nel file**: arriva dalla riga di
  lancio, dove il default del driver e' **4** (`walkforward_generico.ps1` r.180).

---

# 8. 🔴 QUANTE SEDIE, REALISTICAMENTE, IL 1° OTTOBRE

## La risposta onesta: **DUE**, e la seconda a due condizioni scritte.

| sedia | stato al 12/09 | cosa serve, per nome |
|---|---|---|
| 🚄 **1ª — `771531` `ABTG_EMA200` U30USD H1** | **3,5 requisiti su 5**; gira sul piccolo **50503392** all'1,0%, **non** sul conto della challenge | **[FIRMA]** spostarla sul conto della challenge a 0,65% · **[FIRMA]** il preset del 100k (`881531`) **non esiste** · **[MISURA]** l'`n` dell'IS in posizioni (`COLLAUDO_EMADOW_02`, **2 passate**) e la gestione dell'uscita (`R136a/b/c/d`, **40 passate**) |
| 🪑 **2ª — `770101` `ABTG_DAX_Apertura_EU` D30EUR M5 LONG** | **3 requisiti su 5 pieni e verificati** (R1 su 80 manopole, R2 sul banco da 100.000, R4). Il preset del 100k **esiste gia'** | **[FIRMA]** caricarlo sul **50504263** · **[FIRMA]** `InpTP1_ClosePct` 50 → 0 (già misurato: PF +0,094, DD −0,961, stesso n) · **[MISURA]** R5 (R137a/b, **28 passate**) e R3 (R138a, **4 passate**) |

## 🔴 E le tre cose che vanno dette nella stessa riga, senza addolcire

1. **Non e' un terzetto.** Il piano v2 proponeva `770611`-OPPRANGE + `770202` + `771531`. **Oggi
   quel terzetto non esiste piu':** l'errata del **12/09** (`report/A4_LA_GEOMETRIA_DELLO_STOP_2026-09-12.md`)
   ha misurato che **OPPRANGE in campione PERDE** (`PF IS 0,962`, profitto **−738,45**) ⇒ bocciata dai
   cancelli firmati il 19/08 ⇒ `770611` torna a **29,5x** su R5. E `770202`, ricontato oggi in posizioni,
   ha **96** e non 130 ⇒ merito **sospeso per aritmetica, non colmabile**. **Restano due.**
2. **Con due sedie non c'e' nessuna famiglia a 150 operazioni FORWARD**, e non ci sara':
   `771531` a 1,000 pos/g ci arriva a **fine gennaio 2027**; `770101` a 0,728 pos/g a **marzo 2027**.
   👉 **Si parte con motori validati IN BANCO, non IN CAMPO.** E' un fatto, non un difetto da nascondere.
3. **Il rischio aperto delle due, alla taglia 0,65%, e' 1,30%** — dentro il cap **C1 3,25%** firmato, e a
   **3,8× di margine** dal muro giornaliero del 5%. 🟢 **E la somma dei DD promessi sta dentro il muro
   del 10%**: `4,70% (770101 @0,65% su 100k) + 5,09% (771531 all'angolo peggiore) = 9,79%` come **limite
   superiore mai raggiunto in banco**; per radice quadratica **6,94%**. 🟢 **E stavolta i due simboli sono
   DIVERSI** (`D30EUR` e `U30USD`), che era il difetto piu' grosso del terzetto del piano v2 — dove **due
   sedie su tre stavano sullo stesso `U30USD`** con il tetto per cluster **spento**.

## 🎯 E la bussola, applicata a questa giornata
Questa giornata **non ha prodotto solo ponteggio**, e il metro e' questo: ha prodotto **un preset che
esiste gia' e una sedia con R1 e R2 verificati manopola per manopola**, cioe' **una sedia in piu'
schierabile il 1° ottobre**, piu' **quattro file prova gia' passati dal cancello** per chiuderne i due
requisiti aperti in **5,17 minuti** di macchina. 🔴 Ha anche prodotto **due correzioni a numeri del piano
vivo** (`96` invece di `130`, `193` invece di `311`) e **una trappola d'archivio disinnescata prima che
diventasse una firma** (il 40/40 del Dow, che misurava un'altra sedia). **Quelle sono ponteggio, e le
dichiaro come tali** — ma sono il ponteggio che impedisce alla seconda sedia di nascere sbagliata.

---

## 📚 FONTI — tutte sul branch `lavoro`, tutte aperte e ricontate da me

**🥇 MISURATO (rango 1), e tutti riletti sui file grezzi:**
`backtest_pipeline/risultati_prove/aperture_r47/` (8 CSV + 8 per-trade: **e' la fonte portante di questo
dossier**) · `.../risultati_archivio/ritardo_r119b_csv/` (la cella viva a 0,65%) ·
`.../risultati_archivio/spread_flotta/spread_orario_D30EUR.csv` (30.974.789 tick) ·
`.../risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` + `sonda_storico_17-08/*.csv` (profondita' e
`SpreadPt` per simbolo) · `.../risultati_archivio/REFERTO_ROUND76_TETTO_E_SELEZIONE.md` (il tester legge
dal 2000) · `.../risultati_archivio/REFERTO_ROUND29_EMA200_WF.md` (EURUSD 7/30, e il `L+S` verificato nei
CSV `ABTG_EMA200_EURUSD_{IS,OOS}_r29a.csv`) · `.../risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/`
(EURUSD 94/94) · `.../risultati_archivio/EMA200/realtick_H4/` (8 simboli, lato per lato) ·
`.../risultati_archivio/Dow_Apertura/` + `DOW_MOTORE.md` (il 40/40, e il diff che lo rifiuta) ·
`.../risultati_archivio/SuperWave/` · `.../risultati_archivio/SupRev_nuovi_indici/` ·
`.../risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv` (1.558 righe) ·
`mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` e `..._Dow_Apertura_US_..._770202_100K.set` ·
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` r.345-346, r.1064-1067, r.1141, r.1493-1529 ·
`backtest_pipeline/walkforward_generico.ps1` r.177/179/180 · `backtest_pipeline/dow_apertura.ps1` r.159-160, r.269-275 ·
`backtest_pipeline/valida_realtick.ps1` r.180-184 · `backtest_pipeline/calcola_pedaggio_forex.py`
(`MARCATORE_..._v3`, autotest **tutto VERDE**, eseguito oggi)

**🥈 REFERTI E CRITERI:** `report/PIANO_CHALLENGE_OTTOBRE_v2.md` · `report/EMA200_I_DUE_REQUISITI_2026-09-12.md` ·
`report/CENSIMENTO_USCITE_MAI_PROVATE_2026-09-11.md` · `report/IL_TAPPO_2026-09-11.md` ·
`report/SETACCIO_ARCHIVIO_2026-09-12.md` · `report/A4_LA_GEOMETRIA_DELLO_STOP_2026-09-12.md` ·
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` · `report/CONFLITTO_DD_770101_2026-09-11.md` ·
`report/MISURA_SPREAD_FOREX_2026-09-12.md` · `report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md` ·
`report/FIRME_2026-08-18.md` · `report/FIRME_2026-09-07.md`

> **Se un referto e questo dossier divergono, comanda il referto** — tranne sui numeri che questo dossier
> **ricalcola dai file grezzi e dichiara come correzione** (§0 punto 4).
