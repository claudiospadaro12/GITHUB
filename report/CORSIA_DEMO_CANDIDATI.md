# 🚦 CORSIA DEMO — chi merita il forward gratis, e chi no

_Compilato il **07/09/2026** su mandato diretto di Claudio, testuale:_
> **"TROPPI SCARTI CHE MAGARI AVREBBERO RETTO IL MERCATO. SE NON LI PROVIAMO IN
> FORWARD COME SAPREMO SE PROFITTANO. NON DICO QUELLI PROPRIO MORTI MA QUELLI
> CHE CMQ AVEVANO UN PERCHE'."**

> 🧊 **REGOLA DI LETTURA, congelata prima della tabella.** Questo file **non
> promuove niente, non tocca nessuna sedia, non lancia niente**. Produce una
> LISTA con la ragione misurata riga per riga. **Decide Claudio.**
> Dove il numero non esiste in archivio la riga dice **NON MISURATO**: nessun
> numero è stimato, interpolato o inventato.

---

## 0. 🧮 IL CONTO, SUBITO

| colonna | quanti |
|---|---:|
| 🟢 **CANDIDATO ALLA CORSIA DEMO** | **4** |
| 🔴 **MORTO, e resta morto** | **35** |
| 🟡 **NON DECIDIBILE** (manca il dato) | **11** |
| ⚪ _fuori perimetro_ (sedie vive / lati e dial di sedie vive) | 7 _(non contate)_ |

👉 **Sono QUATTRO.** Claudio dice "troppi scarti": il censimento dice che gli
scarti sono tanti (35) **ma quasi tutti sono morti con un numero addosso**. Il
materiale che ha davvero "un perché" e non è mai andato in campo sta in quattro
righe — più undici che aspettano UNA corsa per diventare verdi o rossi.

---

## 1. 🧭 IL RAGIONAMENTO CHE GIUSTIFICA QUESTA CORSIA (il perno)

La regola di casa (Emendamento della Finestra, punto A + valvola R59) **sospende
il MERITO sotto 150 operazioni**; il **RISCHIO si legge sempre**, a qualunque n.

Con motori che fanno **0,12–0,53 operazioni al giorno**, 150 operazioni sono
**anni di calendario**. Per un'intera classe di candidati **il backtest non può
dare un verdetto di merito: non è un cancello severo, è lo strumento sbagliato.**
Il numero che lo dimostra è già agli atti e non è un'opinione — è il conto di
R117 su NASUSD:

| | |
|---|---:|
| operazioni/giorno misurate (media pesata IS+OOS) | **0,525** |
| feriali necessari per 150 IS + 150 OOS | **567** |
| feriali disponibili dal pavimento tick 2024.09.26 | **503** |
| **mancano** | **64 feriali ≈ 3 mesi** |

_(fonte: `backtest_pipeline/REGISTRO_TEST.md`, §"R117 RELATIVO NASUSD")_

Il **forward su demo è lo strumento che accumula quelle operazioni**, e sul conto
**DEMO PICCOLO 50503392** (cartella programma `BCM Markets MT5 Terminal`) costa
**zero euro** — Claudio il 07/09 l'ha lasciato apposta senza Guardian per
"vedere appieno come si comportano gli EA".

### 🪑 E il precedente esiste già, misurato

**`ABTG_Nasdaq_Apertura_US` GATED SHORT, magic 770250**, è stato messo in
forward il 30/08 **con n=104 < 150 e il merito formalmente sospeso** — il suo
contratto lo dichiara nero su bianco (`report/CONTRATTO_GATEDSHORT_770250.md`,
DD 4,54% a 0,65% su tick BCM, riserva scritta: *"il verdetto ORSO è OHLC, non
tick"*). **La corsia demo non è una regola nuova: è la regola che è già stata
usata una volta.** Questo documento la applica in modo sistematico.

### 🔓 E il 07/09 è cambiato un criterio che chiudeva porte

`report/FIRME_2026-09-07.md`: il **pavimento di frequenza di 1,00 op/giorno non
si applica più alla SINGOLA SEDIA ma alla FAMIGLIA** (motore × simboli
schierabili). Misurato su un conto vero con statistiche MQL5: 3-5 EA su 26
simboli fanno **0,29–0,47 op/giorno per simbolo**. *"Ogni istanza del campo è un
cecchino."* Le esclusioni motivate SOLO dalla frequenza della singola sedia
**vanno rilette** — ed è esattamente quello che fa la §2.4 qui sotto.
⚠️ **Nessuna rientra in automatico**: torna in coda all'imbuto, mai in campo.

### 🛑 I DUE CANCELLI CHE NON SI TOCCANO, NEMMENO IN DEMO

1. **Un candidato col DD MISURATO oltre i muri di casa (10% totale / 5%
   giornaliero) NON entra in corsia demo.** Il verdetto sul rischio il backtest
   sa già darlo, e un DD accaduto vale a qualunque n (Emendamento, regola B).
2. **Nessuna modifica in forward.** Questo file non spegne, non accende, non
   cambia un preset. Chi è in campo non è in questo perimetro.

---

## 2. 🟢 CANDIDATI ALLA CORSIA DEMO — **4**

_Perimetro: hanno superato il RISCHIO con una misura, e sono stati fermati SOLO
da (a) merito sospeso per n<150, (b) pavimento di frequenza applicato alla
singola sedia, (c) un cancello che chiedeva una misura che non avevamo._

---

### 🥇 G1 — **RELATIVO su NASUSD** (z-score del rapporto NASUSD/U30USD)

| voce | valore |
|---|---|
| **EA** | `mql5/Experts/ABTG_Relativo.mq5` — **ESISTE, ha già girato nel tester a tick reali** (R117). Non è la sonda: apre ordini veri, SL reale al broker |
| **Simbolo / TF** | **NASUSD** M5, metro di lettura **U30USD** · sessione 14:30–22:00 server |
| **Cella** | `InpFinestraN=40` · `InpSogliaIngressoSigma=1.35` · `InpAtrSL=2.75` · `InpMaxTradesPerDay=5` · rischio 0,65% |
| **Il numero che gli dà un "perché"** | **E OOS +0,063R · PF OOS 1,189 · DD OOS 8,40% · peggior giornata −2,12% · A7 (collaudo) 0,00%** |
| **n** | **IS 87 / OOS 154** (servono 150 in ENTRAMBE) |
| **Perché il merito era sospeso** | Cancello **A6** non soddisfatto. **E non è raggiungibile per aritmetica, non per sfortuna**: 0,525 op/gg × 503 feriali disponibili contro i 567 necessari. Lo split è a somma zero: il massimo ottenibile oggi è min(n_IS,n_OOS)≈133. A6 **si soddisfa da sola aspettando**, intorno al **27/11/2026** |
| **DD misurato** | **8,40%** — 🟠 **dentro il muro 10% ma sopra la soglia 8,0% dei criteri firmati**: zona morta, margine **1,60 punti** dal muro. Peggior giornata −2,12% (muro 5%): larga |
| **Frequenza attesa** | **0,525 op/giorno** — il più veloce dei quattro. In forward ~11 op/mese |
| **Cosa serve** | preset **DA FARE** (non esiste in `mql5/Presets/`) · compilazione sul terminale del **piccolo 50503392** · **magic nuovo** (774602 è il magic del round, non va riusato in campo) |
| **Fonte** | `backtest_pipeline/REGISTRO_TEST.md` §"⏸️ R117 RELATIVO NASUSD" · `backtest_pipeline/prove/RELATIVO_R117_NAS.txt` · `backtest_pipeline/risultati_archivio/sondarelativo/` |

🔴 **DA DIRE OGNI VOLTA CHE SI CITA:** la **gamba D30EUR dello stesso motore è
BOCCIATA PER RISCHIO** (DD OOS 25,01%, peggior giornata −5,20%, E −0,267R, PF
0,452 — **due muri prop sfondati insieme**). In demo va **SOLO NASUSD**. E A3 è
incoerente: IS in perdita (PF 0,754), OOS in utile — su campioni di taglia molto
diversa, quindi l'incoerenza **può essere rumore**, e va detto.

📄 **Nota:** esiste già la riga pronta **R117BIS**
(`backtest_pipeline/righe/RIGA_RELATIVO_R117BIS_DA_MANDARE.md`) che rimisura la
stessa cella su finestra più lunga. **Il verdetto atteso resta MERITO SOSPESO**:
non è un'alternativa alla corsia demo, è complementare.

---

### 🥈 G2 — **NY SESSION RETEST, cella slope 75** (retest della VWAP di seduta, Dow)

| voce | valore |
|---|---|
| **EA** | `mql5/Experts/ABTG_NySessionRetest.mq5` — **ESISTE**, v5, compilato e girato a tick (3 corse valide agli atti) |
| **Simbolo / TF** | **U30USD** M15 (trend letto su H1 con handle dedicato) · seduta 14:30–20:55 server, flat di recupero |
| **Cella** | gate pendenza VWAP **slope = 75** punti indice/75 min · `sl` 5 o 7 · espansione **0** (misurata decorativa) |
| **Il numero che gli dà un "perché"** | **PF 1,374 (sl5) / 1,427 (sl7) · DD 3,7–4,7% · peggior giornata −0,69%** — e il gate è **REALE e monotono**: n 625→211→160→115, DD 12,9%→3,7% |
| **n** | **114–115** |
| **Perché il merito era sospeso** | Muro R59: la barra congelata (PF≥1,3 **e** DD<8%) **è raggiunta**, ma con n<150. A slope 60 (n=160, sopra il muro) il PF scende a 1,14–1,20 = sotto barra. *"Gate REALE, edge sotto barra al n minimo."* |
| **DD misurato** | **3,7–4,7%** (motore nudo 12,87%) · overnight veri **2,88%** contro il 5% firmato |
| **Frequenza attesa** | **~5,4 op/mese ≈ 0,25 op/giorno** → n=150 in **~28 mesi** di forward |
| **Cosa serve** | preset **DA FARE** · **magic nuovo** (769503 è del round) · compilazione. EA e file prova già scritti e collaudati |
| **Fonte** | `backtest_pipeline/risultati_archivio/REFERTO_NYRETEST_2026-08-31.md` · prove `ABTG_NySessionRetest_Tar2.txt` |

🟢 **Perché è il candidato metodologicamente più pulito del lotto:** è il
**primo gate costitutivo della flotta VALIDATO a tick** (monotono, dimezza il
DD, e l'asse decorativo è stato spento con una misura). E la **porta di rientro
è già scritta, MECCANICA e calendarizzata**: tagliando quando la finestra tick
BCM darà n≥150 sulla stessa cella (stima agli atti: primavera-estate 2027).
La corsia demo non aggira quel tagliando — **lo anticipa con dati veri**.

---

### 🥉 G3 — **DAX REENTRY, lato LONG** (rottura oltre il range + reclaim confermato)

| voce | valore |
|---|---|
| **EA** | `mql5/Experts/ABTG_DaxReEntry.mq5` — **ESISTE**, compilato (58 KB, primo compile), autotest 0/18 |
| **Simbolo / TF** | **D30EUR** M5 · range 08:35–11:05, fascia operativa 11:05–14:15, flat 16:30 server |
| **Celle** | `break=40` LONG (la migliore) · `break=20` LONG (il campione più grosso) |
| **Il numero che gli dà un "perché"** | **break 40: PF 1,69–1,80 · DD 2,5–2,9% · peggior giornata −0,67% · +7.168/+9.518** · **break 20: PF 1,159 · DD 4,6% · n 92** — e **6/6 celle long verdi**, PF ordinato col filtro, DD in discesa, SL-fraction insensibile = **banda vera, non picco** |
| **n** | **57** (break 40) · **92** (break 20) |
| **Perché il merito era sospeso** | Muro R59 (n max 92 < 150) **+ cancello S0 aperto**: al 31/08 il denominatore (spread D30EUR nella fascia 11–14) **non era misurato** |
| 🔓 **Il cancello S0 oggi si chiude** | Lo spread D30EUR è stato **MISURATO il 03/09**: **1,6–1,7 punti indice in sessione** (`SPREAD_FLOTTA_MISURA_2026-09-03.md`, 252M tick, solo-bid 0,000%). Il take mediano vincente LONG è **+76,8 punti indice** → rapporto **~45×**, contro un cancello di 2,5–3×. **S0 passa larghissimo** |
| **DD misurato** | **2,5–4,6%** · peggior giornata **−0,67/−0,68%** (i migliori numeri di rischio di tutto il lotto) |
| **Frequenza attesa** | **~3–4 op/mese per lato ≈ 0,17 op/giorno** → n=150 in **~40 mesi**. È il più lento: *"cecchino, non portata"* |
| **Cosa serve** | preset **DA FARE**, **LONG-ONLY** · **magic nuovo** (769300 è del round) · compilazione |
| **Fonte** | `backtest_pipeline/risultati_archivio/REFERTO_DAXREENTRY_2026-08-31.md` · prova `ABTG_DaxReEntry.txt` |

🔴 **Il lato SHORT è MISURATO E MORTO** (PF 0,38–0,54, DD 8,8–23%): va in demo
**solo long**, e va scritto nel preset, non lasciato al caso.
⚠️ Toro unico nella finestra: un long-only qui parte avvantaggiato per regime.

---

### 4️⃣ G4 — **SUPERWAVE DAX H4** (cross EMA14×200 confermato dal Supertrend)

| voce | valore |
|---|---|
| **EA** | `mql5/Experts/ABTG_SuperWave_DAX_H4_Ottimizzato.mq5` — **ESISTE**, magic **770512** già assegnato |
| **Simbolo / TF** | **D30EUR** H4 · `StMult 3.0 / TP_RR 2.0` |
| **Il numero che gli dà un "perché"** | **Validazione a TICK REALI del 26/07: PF 1,28 · DD 3,3% · +278 · n 56 · 7/9 celle positive** |
| **n** | **56** |
| **Perché è fuori** | **NON È IN CAMPO**: `FLOTTA_ATTIVA.md` — *"🔴 NON IN CAMPO (770512: assente da censimenti ed Esperti 25/08 22:15)"*. Non compare né fra le 15 sedie indici di R103 né in `report/CENSIMENTO_CONTRATTI.md`. Fermato da **n 56 < 150** e dalla **frequenza della singola sedia** (~2,7 op/mese = 0,12 op/gg, sotto il vecchio pavimento 1,00) |
| 🔓 **Rilettura 07/09** | Esclusione motivata **solo dalla frequenza della sedia singola** → è esattamente il caso che la firma del 07/09 manda riletto. La **famiglia SuperWave ha già due sedie in campo** (DOW H1 770511, H2 770531): il pavimento si misura lì |
| **DD misurato** | **3,3%** a rischio 1% (tick reali) |
| **Frequenza attesa** | **~0,12 op/giorno** → n=150 in **anni**. Passeggero, non pilota |
| **Cosa serve** | preset **DA FARE** (in `mql5/Presets/` non esiste) · compilazione · magic 770512 riutilizzabile o nuovo |
| **Fonte** | `backtest_pipeline/REGISTRO_TEST.md` §"✅ VALIDAZIONE REAL-TICK SuperWave" · `FLOTTA_ATTIVA.md` |

🔴 **La contro-evidenza, dichiarata prima che qualcuno la trovi da solo:** la
famiglia SuperWave ha **due morti misurati** — GBPUSD (R103: PF 0,79, DD 13,4%,
**5/7 anni negativi**, spenta il 24/08) e il **lato short del Dow** (R110: PF OOS
0,429, DD 7,53%). Il DAX H4 **non è mai stato smontato per lati né rimisurato su
finestra lunga**: il suo n=56 è una finestra sola. È il più fragile dei quattro,
ed è per questo che sta in fondo alla lista.

---

## 3. 🔴 MORTO, E RESTA MORTO — **35**

_Ogni riga ha una MISURA che lo falsifica, oppure un DD fuori dai muri prop.
"Non dico quelli proprio morti": questi sono quelli._

### 3.1 Falsificati a TICK REALI su banco BCM (i più duri)

| # | candidato | il numero che lo uccide | fonte |
|---:|---|---|---|
| 1 | **ABTG_VwapRevert** D30EUR M15 | **S0 NON PASSA su 4 celle su 4**: rapporto punti/spread **negativo** (−0,11 / −0,21 / −0,14 / −0,21). *Il motore perde in media PIÙ dello spread: non è costo, è assenza di edge* | `risultati_archivio/vwaprevert/CORSA_2026-09-03_1711_FALSIFICATO.txt` |
| 2 | **ABTG_LondonFx** EURUSD M15 (3 motori) | E OOS **−0,1078R**, PF OOS **0,843**, **DD OOS 37,14%**; controlli a DD 45,29% e 31,26% | `risultati_archivio/r116_londonfx/CORSA_EURUSD_2026-09-03_1751_BOCCIATA.txt` |
| 3 | **ABTG_LondonFx** GBPUSD M15 | E OOS **−0,1726R**, PF OOS 0,763, **DD OOS 55,03%**; controlli 55–61% | `risultati_archivio/r116_londonfx/CORSA_GBPUSD_...BANCO_SPORCO.txt` ⚠️ banco sporco (classe 129) ma la bocciatura è **per rischio**, che nessuna divergenza sposta |
| 4 | **RELATIVO gamba D30EUR** (R117) | **DD OOS 25,01% + peggior giornata −5,20%** = due muri prop insieme · E −0,267R · PF 0,452 | `REGISTRO_TEST.md` §R117 |
| 5 | **ABTG_AllineaLondra** EURUSD M15 | 8 letture su 8: PF 0,60–1,12, **DD OOS 10,44%–46,62%**, profitto negativo su 7/8 | `risultati_archivio/allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt` |
| 6 | **ABTG_AtrExhaustVol** (P2 caccia M5/M15, R109) | **DD 44,3–67,8%** su 6/6 celle e **peggior giornata −9,72%** contro un muro di −5,00%. *Fatti accaduti, non stime* | `risultati_archivio/R109_REFERTO.md` |
| 7 | **ABTG_CRT_TurtleSoup** (Turtle Soup / CRT) | tick BCM ungated **PF 0,43–0,73 (0/30)**; **col gate ADX(D1)≤30 PF 0,459** contro 0,462 ungated: *il gate non salva a tick*. 17/19 mesi rossi | `risultati_archivio/REFERTO_CRT_2026-08-30.md` |
| 8 | **ABTG_BreakinBox** (falsa rottura box notturno DAX) | Ablazione: tesi **PF 1,007 DD 24,1%** contro controllo RR fisso **PF 1,106 DD 19,7%** → **tesi falsificata E il controllo buca il cancello DD≤15%** | `risultati_archivio/REFERTO_BREAKIN_2026-08-31.md` |
| 9 | **FASE 2 CASSAFORTE** — Nasdaq drive-following LONG M15 | **DD OOS 11,73% a rischio 0,65%** = fuori dal muro 10%. E il costo è già escluso come causa: spread misurato 1,7 pti, *"l'edge è sottile per ragioni INTRINSECHE"*. n OOS 297 ≥150 → **merito misurabile e sotto barra (PF 1,083)** | `risultati_archivio/REFERTO_FASE2_CASSA_2026-08-30.md` |
| 10 | **FASE 2 CASSAFORTE** — cella simmetrica (long+short) | **PF OOS 0,796, DD 19,09%**, asp/trade −47,6 | idem |
| 11 | **ABTG_AltaVelocita** v1/v1.1 GBPUSD | **8/8 celle negative a tick** (PF 0,54–0,82, **DD fino 37%**), 4/4 negative OOS anche in v1.1 | `risultati_archivio/REFERTO_ALTA_VELOCITA_V1.md` |
| 12 | **GAP CASH NASDAQ** (rimbalzo 15' dopo gap di sessione cash) | Sul dato esterno evento +0,0988% / controllo +0,0112%; **sui tick BCM evento −0,0487% / controllo −0,0134%: segno rovesciato**, e la monotonia si rompe **4 volte su 7** | `risultati_archivio/REFERTO_GAPCASH_PASSO0_2026-09-07.md` |
| 13 | **SONDA DELL'OROLOGIO — ramo DAX** (fascia oraria come bordo) | Lettura appaiata dei due lati: **0 fasce asimmetriche su 72 in OOS**, 1 su 72 in IS (e perde da tutte e due le parti). Nella maggior parte delle celle **LONG = −SHORT esatto**: ogni ora "verde" era deriva del toro | `risultati_archivio/REFERTO_OROLOGIO_INDICI_DAX_2026-09-07.md` |
| 14 | **ABTG_InvEsaurimento cella E3** (inversione con conferma) | Verde nel totale (PF 1,16, n 215, DD 8,16%) **ma la lettura per regime lo smonta: −5.604 (−95/trade) nel TORO PULITO 2017**. Il forward di oggi **è** un toro: metterlo in demo adesso significa pagare per sapere una cosa già misurata | `risultati_archivio/REFERTO_INVES_2026-08-30.md` §"lettura per regime" |
| 15 | **ABTG_InvEsaurimento cella E1** (esaurimento ≥1,0× ADR14) | **PF 0,95, −944, n 68** — la chiave FIRMATA non gira | idem |

### 3.2 Sedie SPENTE con delibera, e il numero che l'ha motivata

| # | sedia | il numero | fonte |
|---:|---|---|---|
| 16 | `ABTG_PTE` USDJPY **771323** | R103 6,5 anni: **DD 11,5% (fuori muro)**, PF 1,08, 3/7 anni negativi · R77/R78 su 13 anni: **1 cella positiva su 14** | `R103_REFERTO_FINALE.md` pos.17 · `REFERTO_ROUND77/78` |
| 17 | `ABTG_SuperWave` GBPUSD **770532** | R103: **PF 0,79 · DD 13,4% · −7.501 · 5/7 anni negativi** (DD 12,9× il promesso) | `R103_REFERTO_FINALE.md` pos.23 |
| 18 | `ABTG_CostToCost` XAGUSD **772363** | R103: **PF 0,70 · DD 16,4% · −11.701 · 6/7 anni negativi**. Più tre bocciature indipendenti sull'argento (fase 0 "non giudicabile", studio PS5 esterno "perde a prescindere") | `R103_REFERTO_FINALE.md` pos.24 |
| 19 | `ABTG_EasyTrend` AUDJPY **772423** | R103: **PF 1,01 · DD 15,9% (fuori muro)** · famiglia BOCCIATA in portafoglio (R49) | `R103_REFERTO_FINALE.md` pos.19 · `REFERTO_ROUND49` |
| 20 | `ABTG_Nasdaq_Apertura_US` breakout **770201** | Mai avuto contratto. Tick reali 31/07: **PF 0,82 · DD 17%** · walk-forward 05/08: **19/20 celle OOS negative** | `report/CONTRATTI_SEDIE.md` r.45 |
| 21 | `ABTG_SupRev_DAX_H1_Ottimizzato` **970911** | **IS −240 / OOS +1.312** con n 223 → campione pieno, **IS rosso**: merito misurabile e fallito | `risultati_archivio/REFERTO_FUORILISTA.md` |
| 22 | `ABTG_Apertura_Marco` **770301** | **Doppione esatto**: stesso trade allo stesso secondo di `DAX_Apertura_EU`, 2%+2% = 4% su un segnale; il 06/08 ha prodotto −205,92 insieme al gemello | `report/A1_A4_rischio_immediato.md` |

### 3.3 Famiglie chiuse da round con criteri congelati

| # | candidato | il numero |
|---:|---|---|
| 23 | **Breakout M5 in apertura** (Live5m, Live5m_v2, DAX_M3, ORB_Fibo, Londra_ORB, aperture Nasdaq) | real tick **27/27 combo negative** su Live5m; L3 best PF 1,04 con DD 15–26%. Verdetto definitivo 26/07: *"Non costruire altri v2 M5"* |
| 24 | **Aperture su FTSE / Dow / Nasdaq / Russell** | 100GBP PF 0,90 DD 9,6% · U30USD PF 0,997 DD 8,6% · NASUSD 0% combo positive. *"È un'anomalia del DAX"* |
| 25 | **Lati SHORT delle aperture** (DAX, Dow, Nasdaq) | R107 DAX **PF OOS 0,957 con n 257** (campione pieno, discesa feb-apr 2025 compresa) · R54 Dow PF OOS 0,840 · R107 NAS **PF OOS 0,460** |
| 26 | **ORB Dow SHORT** | R54: **PF OOS 0,520 · DD 26,37%** — asimmetria strutturale, rosso in entrambe le finestre |
| 27 | **FADE degli estremi del range di apertura** (R42) | **0/48 celle positive**, IS **e** OOS, campioni 195–333 trade |
| 28 | **Rimbalzo ORL/ORH** (R43) | **0/8 + 0/8** OOS su NASUSD e D30EUR |
| 29 | **Londra ORB / R45** | **0/48**. E il fuso è stato misurato il 03/09: quelle corse misuravano la **pre-apertura**, non l'apertura — ma il capitolo "Londra a livello" è chiuso anche dagli input (i 4 candidati esterni del 03/09 sono riga per riga `ABTG_BreakinBox`) |
| 30 | **R95 sweep + reclaim JPY** | **0/30 passate**, PF 0,65–0,80, nessuna sopra 1,00, con 21.354 livelli creati (non è fame di segnali) |
| 31 | **SupRev fuori dai simboli validati**: IBEX H1 (R18) **0/12**, GoldenCross forex (R20) **0/6**, SupRev H4 non-indici (R21) 0 promossi, GBPJPY oltre il bordo (R22) **3/9** | *"33 celle verdi promesse dallo screening, ZERO sedie a tick reali"* |
| 32 | **SupRev_DOW_H4 970914 / SupRev_CAC_H4 970915** | Promozioni REVOCATE: PFmed tick reali **0,79** e **0,96** contro OHLC 2,58 e 7,37 = **illusione OHLC** |
| 33 | **BreakingBand su M15 (R108) e M30 (R111)** | Cancello di merito **0/3** su entrambi i TF; su GBPUSD M30 il campione è pieno (IS 181 / OOS 174) e **l'IS è negativo** (PF 0,997). Gradiente misurato **H1 > M30 > M15** |
| 34 | **ABTG_MeanRevert (R60) · CrossEma (R86) · CrossEmaApertura (R96, DD 29–35%) · ORB Nasdaq (R97) · IntradayMomentum (R98)** | R60 **12/12** · R96 DD 29–35% · R97 **0/4** PF OOS <1 · R98 **0/6**, S0 impossibile |
| 35 | **RSI+EMA V8** | Il filtro RSI toglie solo il **9–13%** degli incroci EMA(5/20) su 7 corse = è un incrocio di medie travestito; e a taglia di flotta chiede **8,45%–19,5% di rischio aperto** contro il cap C1 di 3,25% |

### 3.4 🪦 Le lapidi da SONDA e da PAPER (non sono candidati, sono porte chiuse)

Non le conto come righe perché non sono mai stati EA di casa, ma vanno lette
accanto alla colonna 🔴 perché **chiudono le piste da cui verrebbero i prossimi
candidati**. Tutte con un numero:

- **M0PB** — 0/12 alla sonda di conteggio: miglior lato **0,52 segnali/giorno**; 7/12 sotto il cancello RR (`REFERTO_SONDAM0PB_2026-08-31.md`)
- **Chaos Lyapunov (gate LLE)** — il gate morde **al contrario della tesi**; fascia buona = 1 cella su 105; ablazione bocciata (`REFERTO_CHAOS` + `REFERTO_CHAOSABL`)
- **RTH Confluence / London Signal B** (arXiv 2605.04004 §5) — **irriproducibili**: il cuore è un classificatore GMM mai pubblicato; e comunque 0,72 e 0,31 trade/giorno
- **PostNews ISM 15:00 EURUSD** — PF **0,76 IS / 0,79 OOS**, n 234/312 (campione pieno) · **PostNews blocco 13:30 USDJPY** — PF **0,66 / 0,90**, n 151/253
- **Fade post-notizia** — PF 0,85 (t −1,26) e 0,73 (t −2,41); il segno si ribalta fra blocchi e simboli
- **Liquidity sweep sul range della notizia** — PF 0,86; terzo giro sulla stessa geometria
- **Uscita a tempo 30' post-news** — l'84% del profitto dal 20% del campione (2010-2011); 2012-2020 t=0,61
- **Micro-pivot sweep indici M5/M15** — 22.616 segnali, TP-prima-di-SL 43,5–48,2% contro 49,6% richiesto, **8/8 sotto**
- **Compressione ATR → espansione** — 9.723 segnali, **0/8** sopra il pavimento di frequenza, 7/8 sotto il cancello RR
- **Salto statistico Lee-Mykland** — M5: **16 celle su 16** sotto il cancello; M15: la cella con l'edge non ha campione, quella col campione non ha edge
- **Lead-lag S&P→DAX M5** — frequenza sì (2–7/gg), **8/8 celle negative al netto**
- **Fix valutari (Krohn-Mueller-Whelan JF 2024)** — meccanismo VERO e segno azzeccato, ma quota di rientro 0,038–0,082 → il fade non esiste; 0,2 eventi/giorno
- **Numeri tondi (Osler JF 2003)** — su 93.000+ segnali, delta contro controllo appaiato da −1,50 a +0,90, **5 letture su 6 negative**
- **Asta LBMA sull'oro** — **72 celle su 72 negative**
- **Oro ← dollaro** — negativo in entrambi i versi (t −6,31 / −2,85), **0 anni positivi su 9**
- **Lead-lag bond → oro** — l'unica cosa viva del dossier metalli (t +4,12, PF 1,303), **muore nello spread**: 54 celle, 0 promosse, migliore **+0,0201R** contro cancello +0,075R

### 3.5 Materiale di magazzino senza spesa (classe 4 e 5 del `GIACIMENTO_DI_CASA`)

Non li conto uno per uno (sono 3 + 14 file), ma sono 🔴 e la ragione è la stessa:
**duplicano famiglie già sepolte con un numero di casa.**
`ABTG_BreakoutCorso` (R45 0/48 + R12 48/48 OOS negative) · `ABTG_PointBreak`
(R60) · `ABTG_SuperFilter` (filtro appiccicato: 0 successi su 5) ·
`ABTG_DaxValueArea` (morto su due gambe: tick-volume su CFD + fade dei bordi
R42/R60) · tutti e **14 i file di classe 5** (5 sono ORB/breakout, BULGE_MASTER
è fade Bollinger R108/R111, il resto duplica famiglie vive).
👉 `report/GIACIMENTO_DI_CASA_2026-09-03.md` §6-7: *"Nessuno merita spesa."*

---

## 4. 🟡 NON DECIDIBILE — **11**

_Manca proprio il dato. Non tiro a indovinare: dico cosa serve per decidere._

| # | oggetto | cosa manca | costo per decidere |
|---:|---|---|---|
| 1 | **`ABTG_OutOfNoise`** (momentum intraday di Zarattini-Aziz-Barbon, NASUSD M15) | **Zero misure**: il passo 0 del 29/08 diede n=0 su 3 celle, ed è un **BACO DI WARMUP letto nel codice** (`CopyRates` contava barre di calendario invece che di seduta). **Corretto in v1.01/v1.02 e MAI RIGIRATO** | **UNA corsa** — riga `RIGA_PASSO0_OUTOFNOISE.ps1` già scritta |
| 2 | **`ABTG_FvgRetest`** (rientro nel Fair Value Gap, magic 775501) | EA scritto, prova e riga pronte, **zero CSV, zero referto**. Voto 9/10 della caccia SMC del 26/08, mai misurato in casa | **UNA corsa** (passo 0) |
| 3 | **`ABTG_OpeningReversalB`** (fade del drive d'apertura fallito a 3 stadi, U30USD M5) | EA + criteri già congelati nella spec, **mai girato**. Cancello duro già scritto: se i giorni-segnale coincidono col 770202 → scarto | riga + una corsa |
| 4 | **Round PREOPEN DAX / NAS** (livello dalla finestra pre-apertura invece che dall'ORB) | **13 file prova con criteri di merito già CONGELATI, mai lanciato**. Verificato: nessun file `PREOPEN*` in `risultati_archivio/`, la parola non compare in `REGISTRO_TEST.md` | riga di lancio + una corsa |
| 5 | **Sonda dell'Orologio, celle 03–06** (GBPUSD, XAUUSD) | **Mai girate** (sospese per lentezza tick generati, in attesa del ridisegno post-Passo C) | una corsa |
| 6 | **Sonda dell'Orologio INDICI, celle 13–14** (U30USD long/short) | **Mai girate**, e il cancello I1 è **di insieme sui due simboli**: su U30USD **non si conclude niente**, né in un verso né nell'altro | **~12 minuti di macchina** |
| 7 | **Nightly FADE sugli indici** (U30USD, D30EUR, XAUUSD) | **ZERO trade** perché il filtro QB (`InpMaxNightVolPips=45`) è confrontato con `ATR(H1)/PipSize()` e su indici/oro `PipSize()=_Point` → sempre ≥45. *"Su quei mercati il fade non è stato bocciato: non è stato MISURATO"* | fix di **un** filtro + una corsa |
| 8 | **SupRev su E50EUR (Stoxx50) H1/H4 e F40EUR (CAC) H1** | Solo **OHLC** (E50EUR H4 PF 2,8 DD 0,6% n 49 · H1 PF 1,32–1,47 DD 1,2% n 60 · F40EUR H1 PF 1,29 n 131). **Mai validati a tick.** ⚠️ E la famiglia ha **due collassi OHLC→tick documentati** (CAC H4 7,37→0,96, Dow H4 2,58→0,79): il numero OHLC da solo **non è un "perché" sufficiente** | una validazione a tick (BCM ha E50EUR/F40EUR dal 2024.09.26) |
| 9 | **FiboH4** (motore di casa + geometria del corso) | Il "**0/8**" in archivio è **una configurazione bocciata contata otto volte**: `InpSymbols` era pinnato vuoto e MT5 ha usato il default compilato (7 file su 8 danno lo stesso numero al centesimo). **R93** — i due rami A (filtro news) e B (geometria del corso, `ABTG_FiboH4_Corso.mq5`) — ha i criteri in bozza e **non è mai girato** | R93, due gambe |
| 10 | **Deriva oraria EURUSD SHORT 08:00–16:00** (Breedon-Ranaldo, pre-registrata) | Passa il cancello C1 su **entrambe** le finestre (IS **4,59** su n 1.607 · OOS **5,31** su n 2.411) — ma **non esiste un EA, non esiste uno SL, non esiste un DD**. Il killer dichiarato è l'**ESECUZIONE** (~1 bp la uccide), non l'edge | EA da scrivere + la domanda vera: *"come si entra senza pagare lo spread"* |
| 11 | **`ABTG_HARSI`** EURUSD M5 | Su un grafico dal 02/08 con la nota *"scan da fare"*: **nessuna misura in archivio, nessun contratto** | uno scan |

⚪ **Fuori da questa tabella per onestà**, perché sono **misure**, non candidati:
`ABTG_SondaSessione`, `ABTG_NFP_Study`, `ABTG_Notte_Study`, `ABTG_ImportaTickEsterno`
(bozza mai compilata) e le 5 celle **G1-PAOLO** (ablazione di parametri di sedie
vive su XAUUSD, mai girata).

---

## 5. ⚪ FUORI PERIMETRO — chi NON è uno scarto (7, non contate)

_Il mandato dice: "Tu ti occupi solo degli SCARTI e dei SOSPESI, cioè di chi NON
è in campo." Queste sono in campo, o sono proposte di modifica di contratto di
sedie in campo. **Non entrano nel conto**, ma vanno nominate perché altrimenti
qualcuno le rimette in lista domani._

| oggetto | perché è fuori |
|---|---|
| **GATED SHORT NASUSD 770250** (ex candidato SHORTGATE) | **È IN CAMPO dal 30/08** con contratto scritto (DD 4,54% a 0,65% su tick BCM, n=104, merito sospeso dichiarato). È il **precedente** di questa corsia, non un suo candidato |
| **EMADOW lato SHORT** (R110: PF OOS **1,891**, n **302**, DD 2,66%) | Merito **misurabile e passato** — ma è il lato di una sedia VIVA (771531). R112 ha già misurato i dial (1/2/3%) contro il cancello di portafoglio: **nessuno passa**, il contratto non cambia |
| **SupRev NAS H1 lato SHORT** (R110: PF OOS 1,870, DD 0,93%) | Lato di sedia viva 970913, e **n OOS 34**: indizio, non candidato |
| **SupRev DAX H4 lato SHORT** (R110) | **n 29 → NON MISURABILE** per criterio, e lato di sedia viva |
| **R101 cella `02_volumi`** (Dow: PF OOS 1,543 DD 2,83% · DAX: PF 1,550 DD 4,63%) | È un'**ablazione sulle sedie vive** 770202/770101 = proposta di modifica di contratto, non uno scarto |
| **R115 `DOW_00_long`** (PF OOS 1,278, DD 2,85%) | **È la sedia viva 770202**, ri-confermata su OOS fresco. Non è un motore nuovo (correzione firmata da Claudio il 29/08) |
| **I 5 motori simmetrici vivi mai smontati per lato** (PTE Dow, PunteLarry, GapFill, SuperWave H2, SupRev Nikkei) | Sono in campo. Il loro short **non ha mai avuto un numero suo**: è una coda di misura, non una corsia demo |

---

## 6. 🎯 COSA DICE IL CENSIMENTO, IN QUATTRO RIGHE

1. 🟢 **I candidati veri sono QUATTRO**, e tre di loro (**RELATIVO NASUSD**,
   **NY RETEST slope 75**, **DAX REENTRY LONG**) hanno il rischio misurato **a
   tick reali su banco BCM**, con DD fra **2,5% e 8,4%** e peggior giornata
   fra **−0,67% e −2,12%**. Il quarto (**SUPERWAVE DAX H4**) è validato a tick
   ma su una finestra sola e con una famiglia che ha due morti alle spalle.
2. 🛠️ **Tutti e quattro hanno l'EA GIÀ SCRITTO E GIÀ COMPILATO.** **ZERO EA da
   scrivere.** Quello che manca è identico per tutti: **un preset (nessuno
   esiste in `mql5/Presets/`), un magic nuovo, una compilazione.**
3. ⏳ **Il tempo è il vero costo**: a 0,12–0,53 op/giorno, n=150 arriva in
   **11 mesi (RELATIVO) / 28 mesi (NY RETEST) / 40 mesi (DAX REENTRY) / anni
   (SUPERWAVE)**.
   🔧 **CORREZIONE 07/09/2026 (sera):** gli **"11 mesi" di RELATIVO sono
   SBAGLIATI** e sono incoerenti con la riga "~11 op/mese" della sua stessa
   scheda G1. Il conto giusto: 0,525 op/feriale × 21,75 feriali/mese = **11,42
   op/mese** → 150 / 11,42 = **13,1 mesi**, data stimata **13/10/2027**.
   Vale quello scritto in `report/CORSIA_DEMO_RELATIVO_NASUSD.md` §2.
   Le stime degli altri tre non sono state ricontrollate. È esattamente il motivo per cui la demo è lo strumento
   giusto: **il backtest quei mesi non li può fabbricare, il forward sì.**
4. 🔴 **E gli scarti "morti" sono davvero morti**: 35 righe, ognuna con un
   numero — DD dal 11,7% al 67,8%, PF da 0,43 a 0,99, o zero segnali al
   conteggio. **Su questi non si spende un altro round**, e la Regola della
   Seconda Caccia dice come si riaprono: **meccanismo diverso sulla stessa
   inefficienza, mai un'altra griglia sullo stesso motore morto.**

---

## 7. ⚠️ COSA QUESTO DOCUMENTO NON COPRE (dichiarato)

- **Non copre l'esecuzione vera**: slippage, requote e rifiuti. Il
  `ABTG_SlippageLogger` sul conto reale ha ancora **0 deal** (HANDOFF 07/09):
  finché non produce numeri, ogni gradino di slippage è **uno scenario
  assunto**, non una misura.
- **Non copre la correlazione fra i candidati e la flotta viva.** Il **tetto
  per cluster al 3,0% è firmato il 07/09 e — dalla stessa giornata —
  IMPLEMENTATO MA NON COLLAUDATO** (`report/FIRME_2026-09-07.md` appendice:
  Guardian v1.13, **spento di default**, mappa cluster **proposta e non
  firmata**, collaudo enforcement **mai girato**). Finché il collaudo non
  gira **non è una protezione**, e mettere sedie nuove in demo non lo attiva.
- **Non copre il regime.** Tutti i numeri a tick sugli indici vengono da
  **21 mesi di UN SOLO REGIME (toro)**: il pavimento tick BCM è il
  **2024.09.26** e non si abbassa. Un long che vince qui parte avvantaggiato.
- **Non è un contratto.** Se uno di questi quattro va in demo, il suo DD
  promesso e la sua frequenza promessa vanno scritti in
  `report/CENSIMENTO_CONTRATTI.md` **prima** che apra la prima posizione —
  altrimenti il criterio di uscita del 18/08 non è applicabile.

---

_Compilato in sola lettura d'archivio. **Nessun EA, preset, sedia, magic o
parametro di forward è stato toccato. Nessun backtest lanciato. Nessuna
promozione.** Se un referto e questo documento divergono, **comanda il referto**._
