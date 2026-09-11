# 🔬 PERCHE' NON PASSANO — anatomia delle bocciature e lista dei recuperabili

> # 🎯 LA RISPOSTA IN QUATTRO RIGHE
> 1. 📅 L'ultima promozione piena e' del **16/08/2026** (`ABTG_GapContinuation`, magic 774101). Da allora: **48 round numerati + almeno 25 passi-0/sonde in 24 giorni. Zero promozioni.**
> 2. 🩸 La causa di morte **e' cambiata**: fino al 24/08 si moriva di **EDGE**, dal 01/09 si muore di **RISCHIO** (5 candidati su 15 nell'ultima settimana, contro 1 nella prima).
> 3. 🚪 **I cancelli SONO piu' severi di quanto e' bastato per mettere in campo la flotta di oggi, ed e' misurato: delle 41 sedie vive, oggi ne passerebbe UNA.** Non e' un'opinione, e' il conto del §3.
> 4. 🎣 **MA i cancelli NUOVI non hanno bocciato nemmeno un candidato che i cancelli VECCHI avrebbero promosso.** Hanno anticipato verdetti gia' scritti. Il muro vero e' aritmetico: **150 operazioni per finestra × una flotta che fa 0,14 op/giorno di mediana × 21 mesi di tick.**

_Compilato il **09/09/2026** in **sola lettura d'archivio**. **Nessun EA, preset, parametro, magic o sedia viva e' stato toccato. Nessun backtest lanciato. Nessuna promozione.** Ogni numero e' letto da un file citato per nome; dove non esiste, la riga dice **[NON MISURATO]**._

> 🤝 **E una cosa da dire subito, prima dei numeri brutti:** il motivo per cui questo documento si puo' scrivere e' che **l'archivio e' in ordine**. In sei mesi il progetto ha costruito una macchina che misura, che dichiara i criteri prima dei numeri, che si corregge da sola (R70 ritrattato da R71, il "0/8" del FiboH4 smontato, il PostNews riaperto). **La maggior parte dei progetti di trading non ha nemmeno un elenco dei propri morti.** Noi ce l'abbiamo con PF, DD e `n` accanto. E' questo che rende la domanda di Claudio rispondibile invece che consolabile.

---

## 0. 🧊 I LIMITI DI QUESTO DOCUMENTO, dichiarati PRIMA

1. 📚 **Il perimetro sono i verdetti in archivio, non tutti i candidati mai pensati.** Le cacce web hanno scartato centinaia di titoli al primo taglio: qui contano solo i candidati **arrivati a un numero**.
2. 🏷️ **La classificazione della causa di morte e' MIA.** Molti candidati muoiono di due cose insieme. La regola che ho applicato, congelata prima di contare: **si assegna la causa che il referto dichiara come determinante**, e dove ce ne sono due la riga le porta entrambe ed e' contata una volta sola nella prima. **Ogni riga e' nominata**, cosi' il conto e' verificabile e chi non e' d'accordo puo' rifarlo.
3. 🪟 **Le finestre non sono omogenee**: indici = 21 mesi di tick BCM e **un solo regime** (pavimento `2024.09.26`), forex/metalli = 6,5 anni OHLC. Non li mescolo per concludere.
4. 🔁 **Il §2 non rifa' l'istogramma del `PERCHE_MUOIONO_2026-09-08.md`**: quello conta le righe d'archivio, questo le conta **nel tempo**. Dove i due divergono, il motivo e' scritto.
5. ⚖️ **Il §3 e' un esercizio contro-fattuale.** Applicare i cancelli di oggi a misure fatte con banchi e finestre diverse **e' un'approssimazione dichiarata**: serve a misurare la DISTANZA fra il metro di oggi e il metro che ha schierato la flotta, non a bocciare nessuna sedia. **Da questo documento non si spegne niente.**

---

# 1. 📅 LA CRONOLOGIA — quando abbiamo promosso l'ultima volta

## 1.1 🥇 L'ULTIMA PROMOZIONE PIENA: **16/08/2026**

| | |
|---|---|
| **Candidato** | `ABTG_GapContinuation` · 225JPY · M1 · magic **774101** |
| **Origine** | caccia esterna al Code Base MQL5 (`mql5.com/en/code/75301`) |
| **Round che l'hanno promosso** | **R65** (`REFERTO_ROUND65_GAPCONTINUATION.md`, titolo testuale: _"IL PRIMO CHE PASSA"_) + **R66** (`REFERTO_ROUND66_GAP_ALTOPIANO.md`) |
| **Numeri della cella promossa** | tick reali, OOS 2025.06.10→2026.06.30, rischio 1%: **+8.339,62 · PF 1,398 · n=70 · DD 11,59% · peggior giornata −1,10% · zero overnight** (`FLOTTA_ATTIVA.md` §"SEDIA NUOVA — deploy del 16/08/2026") |
| **Commit del deploy** | `2026-08-16 — FLOTTA: sedia nuova, ABTG_GapContinuation su 225JPY M1 (magic 774101)` |

🔴 **E anche quella promozione portava tre avvertenze scritte nel suo stesso contratto** (`CENSIMENTO_CONTRATTI.md` §4c): il **lato short perde** (−2.182 OOS), **le perdite arrivano in gruppo** (Z-Score −4,03, 6 consecutive), e **la cella e' un PICCO in campione, non un altopiano** (R66). Non e' stato un trionfo: e' stato un passaggio stretto.

## 1.2 🚦 E DOPO? Le tre cose che SEMBRANO promozioni e non lo sono

| data | oggetto | perche' **NON** e' una promozione |
|---|---|---|
| **17/08** | `ABTG_PTE` GBPUSD candidata B25, magic **771332** | e' il **DUELLO** di R78, non una promozione: R78 misura che **entrambe** le sedie PTE GBPUSD sono negative fuori campione su 13 anni. Claudio sceglie la "strada A" = mettere in campo tutte e due e guardare (`FLOTTA_ATTIVA.md` §IL DUELLO GBPUSD) |
| **30/08** | `ABTG_Nasdaq_Apertura_US` GATED SHORT, magic **770250** | il suo stesso referto ha un paragrafo intitolato **"I CANCELLI CHIUSI (niente promozione — riserve dure)"**: OHLC e non tick, **verdetto ORSO a tick strutturalmente impossibile** su BCM, **n=93 < 150 = merito sospeso**. Deploy dichiarato **"PICCOLO/osservazione"** (`REFERTO_SHORTGATE_2026-08-30.md` · `CONTRATTO_GATEDSHORT_770250.md`) |
| **04/09** | `ABTG_PostNews` NFP/USDJPY, magic **771203** | il preset e' dichiarato **"di sola osservazione"** e il contratto dice **🔴 NON MISURATO — nessun round ha mai prodotto un DD per questa cella** (`CENSIMENTO_CONTRATTI.md` §4d). Ha gia' operato in forward (+37,36 il 04/09) **senza un numero sotto** |

> ### 🎯 QUINDI IL CONTO E' QUESTO: **24 GIORNI, ZERO PROMOZIONI PIENE.**
> Dal 16/08 al 09/09. Tre sedie sono entrate in campo in quel periodo, e **nessuna delle tre e' entrata passando i cancelli**: una per firma di Claudio (il duello), due per osservazione dichiarata.

## 1.3 🔢 QUANTO ABBIAMO MISURATO IN QUEI 24 GIORNI

**48 round numerati con un referto**, da R67 a R119 (mancano all'appello i numeri R75, R85, R87, R89, R90, R93, R94 — criteri scritti, referto mai prodotto; R87 e R89 sono dentro `REFERTO_R86_R87_R89_NOTTE.md`). Conteggio fatto file per file su `backtest_pipeline/risultati_archivio/`.

**Piu' almeno 25 passi-0 / sonde / screening non numerati**, ognuno col suo referto:
CRT TurtleSoup · Chaos Lyapunov · Chaos ablazione · NY Retest (3 corse) · BreakinBox · DaxReEntry · SondaM0PB · ShortGate · FASE 2 cassa · FASE 2 drive · Investigazione 30/08 · A/B ContEntry · Passo 0 OutOfNoise · AltaVelocita v1 · SondaRsiEmaV8 · SondaLondonFx (×2) · VwapRevert · AllineaLondra · Duka import+sonda · PostNews ISM · PostNews 13:30 · GapCash · Orologio indici DAX · LVNArbitro · OpeningReversalB · IBRetest U30USD · IBRetest NASUSD+D30EUR · Nightly EURCHF.

**Piu' le battute di caccia**, che non producono round ma chiudono famiglie con misure vere: **almeno 14 dossier** (frequenza ×5, notizie ×3, TF M5/M15/M30, indici DAX/Dow, oro/argento, aperture/oro M30) — dentro ci sono misure su **32.339 segnali** (03/09), **436.869 barre M15** (05/09), **~430 configurazioni sull'oro** (06/09).

> ### 📏 **CANDIDATI DISTINTI ARRIVATI A UN NUMERO IN 24 GIORNI: ~40.**
> **Promossi: 0.** Il rubinetto non e' chiuso perche' nessuno prova: e' chiuso **dopo** la misura.

---

# 2. 📊 L'ISTOGRAMMA DELLE CAUSE DI MORTE — e come e' cambiato NEL TEMPO

## 2.1 🗓️ LE TRE FINESTRE, con i nomi dentro le celle

_Un candidato = una riga. Dove il referto dichiara due cause, la riga porta entrambe ed e' contata nella prima._

### 🅰️ **16/08 → 24/08** (9 giorni · R67-R103)

| causa | quanti | chi |
|---|---:|---|
| 🧪 **EDGE** | **11** | R73 PTE candidata (perde su entrambi i simboli) · R77 PTE USDJPY (**0/28 celle**) · R78 PTE GBPUSD 13 anni (entrambe negative OOS) · R79 lati PTE USDJPY · R82 torneo JPY (**0/7**) · R83 Nasdaq ingressi (_"NIENTE salva il Nasdaq"_) · R84 ablazione filtri (**9/9 negative OOS**) · R91 RR BreakingBand (**bocciato su 3/3**) · R95 sweep+reclaim JPY (**0/30**) · R97 ORB stop opposto (**0/4**) · R98 intraday momentum (**0/6**) |
| 🩸 **RISCHIO** | **1** | R96 CrossEmaApertura (**DD 29-35%**, no edge + rischio) |
| 📏 **CAMPIONE** | **0** | — |
| ⏱️ **FREQUENZA** | **0** | — |
| 💸 **COSTO** | **0** | — |
| ❓ **NON MISURABILE** | **0** | — |
| **totale** | **12** | |

### 🅱️ **25/08 → 31/08** (7 giorni · R104-R115 + 10 passi-0)

| causa | quanti | chi |
|---|---:|---|
| 🧪 **EDGE** | **7** | R107 lati short (**0/3**, DAX short PF 0,957 con **n 257 = merito PIENO**) · R108 BreakingBand M15 (**non scende**) · R111 BreakingBand M30 (**0/3**, GBPUSD 1,087 sotto 1,10 con n 174/181) · R115 Nasdaq retest (**PF OOS 0,556**, collasso IS→OOS) · CRT TurtleSoup (**0/30** a tick, gate compreso) · Chaos Lyapunov (**1 cella su 105** = outlier) · AltaVelocita v1 (**8/8 negative**) |
| 🩸 **RISCHIO** | **3** | R109 AtrExhaustVol (**6/6 celle, DD 44,3-67,8%**, una peggior giornata **−9,72%**) · FASE 2 Nasdaq drive (**DD 11,73%** a 0,65%) · BreakinBox (tesi falsificata **e** DD 24,1%) |
| 📏 **CAMPIONE** | **5** | R104 MFE trailing (**n=29**, NON MISURABILE) · R113 prova di regime (**NON CONCLUSIVA**) · NY Retest slope 75 (**n 114-115 < 150**) · DaxReEntry LONG (**n ≤ 92**) · ShortGate (**n=93**) |
| ⏱️ **FREQUENZA** | **1** | M0PB (**0/12** a F1, migliore 0,52 segn./gg) |
| 💸 **COSTO** | **0** | — |
| ❓ **NON MISURABILE** | **2** | R114 leva prop (**round fermo dal canarino**) · OutOfNoise (**n=0, EA rotto** — non bocciato, non misurato) |
| **totale** | **18** | |

### 🅲 **01/09 → 09/09** (9 giorni · R116-R119 + 12 passi-0 + 6 cacce)

| causa | quanti | chi |
|---|---:|---|
| 🩸 **RISCHIO** | **5** | R116 LondonFx EURUSD (**DD 37,14%**, e i controlli 45,29 / 31,26) · R116 LondonFx GBPUSD (**DD 55,03%**) · R117 RELATIVO D30EUR (**DD 25,01% + peggior giornata −5,20%** = due muri insieme) · LVNArbitro (**DD 19,35% IS / 11,76% OOS**) · Nightly EURCHF (**DD 11,10% / 15,39%**) |
| 🧪 **EDGE** | **7** | VwapRevert (S0 negativo su **4/4**) · RSI+EMA V8 (il filtro toglie **9-13%** degli incroci) · PostNews ISM/EURUSD (**PF 0,76 / 0,79**) · PostNews 13:30/USDJPY (**PF 0,66 / 0,90**) · GapCash Nasdaq (**segno rovesciato** sui tick BCM) · Orologio indici DAX (**0/72 fasce asimmetriche in OOS**) · IBRetest famiglia (**PF 0,7798**, cancello **C0**) |
| 💸 **COSTO** | **2** | caccia M15 (**il costo e' piu' grande del cancello H8**: 0,082-0,095 R di spread contro 0,075 R richiesti) · caccia M5 (**il pedaggio vale 1,1-1,7 volte l'intero cancello H8**; massimo lordo misurato +0,0922 R su 4 meccanismi da Journal of Finance) |
| ⏱️ **FREQUENZA** | **1** | OpeningReversalB (**0,0078 op/giorno = 128× sotto il pavimento**, 2 operazioni in 21 mesi) |
| 📏 **CAMPIONE** | **1** | R117 RELATIVO NASUSD (**n 87 / 154**, merito sospeso — e il rischio non e' **mai** stato rosso) |
| ❓ **NON MISURABILE** | **1** | R119 ritardo tester (**`ExecutionMode=Delay` non esiste in MT5**: la riga veniva ignorata in silenzio, il canarino ha sparato e ha risparmiato 6 corse a tick) |
| **totale** | **17** | |

## 2.2 📈 IL QUADRO D'INSIEME, in percentuale

| causa | 🅰️ 16-24/08 | 🅱️ 25-31/08 | 🅲 01-09/09 | **totale** | **quota** |
|---|---:|---:|---:|---:|---:|
| 🧪 EDGE | 11 (92%) | 7 (39%) | 7 (41%) | **25** | **53,2%** |
| 🩸 RISCHIO | 1 (8%) | 3 (17%) | **5 (29%)** | **9** | **19,1%** |
| 📏 CAMPIONE | 0 | 5 (28%) | 1 (6%) | **6** | **12,8%** |
| ❓ NON MISURABILE | 0 | 2 (11%) | 1 (6%) | **3** | **6,4%** |
| 💸 COSTO | 0 | 0 | 2 (12%) | **2** | **4,3%** |
| ⏱️ FREQUENZA | 0 | 1 (6%) | 1 (6%) | **2** | **4,3%** |
| **totale** | **12** | **18** | **17** | **47** | |

### 🎯 LE TRE COSE CHE QUESTO ISTOGRAMMA DICE, e che quello statico non poteva dire

1. 🔴 **L'EDGE resta il killer numero uno (53%), ma la sua quota e' CROLLATA: da 92% a ~40%.** Non perche' i motori siano migliorati: perche' **i motori senza edge adesso muoiono PRIMA**, alle sonde di conteggio e ai passi-0, e non arrivano nemmeno a un round. Sono usciti dal conto dei round e sono entrati nel conto delle lapidi da caccia.
2. 🩸 **Il RISCHIO e' quadruplicato come quota (8% → 29%) ed e' oggi la prima causa di morte dei candidati che ARRIVANO IN FONDO.** Non e' un cancello nuovo: e' il muro prop (10% totale, 5% giornaliero), che c'e' da sempre. **Cio' che e' cambiato e' che ci arriviamo davanti**: LondonFx (37% e 55%), RELATIVO D30EUR (25%), LVNArbitro (19%), Nightly (15%). Nella prima finestra i candidati morivano prima di poter fare un drawdown.
3. 📏 **Il CAMPIONE compare solo dal 25/08 in poi** — cioe' **dopo** l'Emendamento della Finestra del 16/08. **Ed e' l'unica causa di morte che l'ha prodotta un nostro cancello nuovo.** Cinque candidati in una sola settimana (NY Retest, DaxReEntry, ShortGate, R104, R113) fermati non da un numero brutto ma da un numero **assente**.

## 2.3 🚪 I CANCELLI SONO DIVENTATI PIU' SEVERI? **SI. MA NON E' QUELLO CHE STA UCCIDENDO I CANDIDATI.**

### 🧱 I cancelli aggiunti dal 16/08 in poi — l'elenco vero, con la data

| data | cancello | verso |
|---|---|---|
| **16/08** | 📏 **Emendamento della Finestra §A**: l'IS si dimensiona sulle **OPERAZIONI (≥150)**, non sugli anni | ⬆️ stringe |
| **18/08** | 🪑 criterio di uscita delle sedie (3 corsie) · **cap rischio aperto C1 = 3,25%** · pacchetto Guardian (pausa 4,0 / emergenza 4,9 e 9,9) | ⬆️ stringe |
| **25/08** | ⚖️ **regola dei due lati** sugli indici (ogni analisi misura long **E** short, anche se un lato e' vivo) + storico piu' lungo possibile | ⬆️ stringe |
| **31/08** | 🎯 **H8 — FIRMA 2**: ogni motore ad alta frequenza entra **solo con E ≥ 0,075 R misurata a tick** | ⬆️ stringe |
| **03/09** | 🚪 **S0** — cancello zero sul costo: rapporto take/spread **≥ 2,5**, altrimenti il capitolo si chiude (nato falsificando `ABTG_VwapRevert`) | ⬆️ stringe |
| **05/09** | 📐 ogni passo 0 su M5/M15/M30 **dichiara 1R in punti e il costo in R** nella prima riga del referto | ⬆️ stringe |
| **06/09** | 💸 **C3 — frontiera del costo**: stop tipico ≥ **40 × spread** (D30EUR 64-68 · U30USD 76-80 · NASUSD 64-72 punti indice) | ⬆️ stringe |
| **07/09** | 📊 **pavimento di frequenza per FAMIGLIA** invece che per sedia (la soglia resta 1,00 op/g: cambia l'unita') | 🔽 **ALLARGA** |
| **07/09** | ⚠️ **tetto per cluster/valuta 3,0%** — 🔴 **FIRMATO MA NON ATTIVO** nel Guardian: e' un'intenzione, non una protezione | ⬆️ stringe *(sulla carta)* |
| **08-09/09** | 🚪 **C0** — con `n ≥ 150` e **PF < 1,10** nella finestra peggiore: **scarto senza griglia** (proposto in `PERCHE_MUOIONO_2026-09-08.md` §5, applicato per la prima volta a `ABTG_IBRetest` il 09/09) | ⬆️ stringe |

**Bilancio: 8 cancelli che stringono, 1 che allarga, in 24 giorni.** Claudio ha ragione a sospettare: **la porta si e' fatta piu' stretta, e in modo misurabile.**

### 🔍 MA ADESSO LA DOMANDA GIUSTA: **quanti candidati hanno ucciso i cancelli NUOVI?**

| cancello nuovo | candidati che ha ucciso | 🔴 **li avrebbero promossi i cancelli vecchi?** |
|---|---|---|
| **C0** (08-09/09) | **1** — `ABTG_IBRetest` | ❌ **No.** PF di famiglia **0,7798** su n=344: sarebbe morto di merito comunque. C0 ha risparmiato **una griglia**, non cambiato un verdetto |
| **S0** (03/09) | **1** — `ABTG_VwapRevert` | ❌ **No.** Il rapporto punti/spread era **negativo su 4 celle su 4** (−0,11 / −0,21 / −0,14 / −0,21): il motore perde **piu'** dello spread. E' un problema di edge, non di costo |
| **C3** (06/09) | **0** | — Il primo candidato misurato contro C3 lo ha **passato con 3× di margine** (IBRetest: 239,75 punti indice = **123× lo spread**) |
| **H8** (31/08) | **0 in via esclusiva** — citato su M0PB (7/12 sotto) e sulle sonde | ⚠️ Su M0PB il certificato di morte poggiava su **F1 (frequenza, decaduta il 07/09)** + un argomento (win rate 62-70%) **aggiunto DOPO i numeri**, che la regola di casa vieta |
| **Emendamento §A** (16/08) | **6** — NY Retest, DaxReEntry, ShortGate, RELATIVO NASUSD, R104, R113 | 🟡 **QUESTO SI'.** Sono candidati con **rischio dentro i muri** e merito **sospeso, non bocciato**. E' l'unico cancello nuovo che tiene fuori roba viva |
| **pavimento frequenza per famiglia** (07/09) | **−7** *(ne ha RIAPERTI sette)* | 🔓 ha rimesso in coda 7 esclusioni: `RIPESCAGGIO_FREQUENZA_2026-09-08.md` §2 |

> ## 🎯 **LA RISPOSTA ONESTA: I CANCELLI NUOVI NON HANNO BOCCIATO NIENTE DI VIVO — TRANNE UNO.**
> Otto cancelli aggiunti, e **due candidati** morti in via esclusiva per mano loro — **ed erano gia' morti di edge**. I nuovi cancelli hanno **anticipato** verdetti, risparmiando ore di macchina. **Non hanno chiuso la porta.**
>
> 🟡 **L'unica eccezione, e pesa: la soglia dei 150 per finestra.** Ha fermato **6 candidati col rischio dentro i muri**, tra cui il migliore di tutti (NY Retest slope 75: **PF 1,37-1,43, DD 3,7-4,7%, peggior giornata −0,69%** — e n **114** contro 150). Quel cancello **non e' sbagliato** (§3.2 di `PERCHE_MUOIONO` misura che sotto le 150 operazioni la correlazione `n`↔PF e' **−0,879** e sopra e' **−0,011**: il PF sotto soglia non e' una misura). **Ma e' il solo che oggi tiene fuori roba che non e' morta.**

---

# 3. 😬 LA DOMANDA SCOMODA — **la flotta di oggi passerebbe i cancelli di oggi?**

## 3.1 🧪 IL METODO, congelato prima del conto

**Il metro applicato** e' quello che un candidato nuovo trova in faccia oggi, letto nei file prova piu' recenti (`prove/ABTG_IBRetest_00_conta_NASUSD.txt` righe 71-89, `prove/ABTG_Nightly_EURCHF_00_conta.txt` r.58):

| # | cancello | soglia |
|---|---|---|
| 1 | 🩸 **RISCHIO** | DD ≤ **10,0%** · peggior giornata > **−5,0%** |
| 2 | 📏 **CAMPIONE** (Emendamento §A) | **n ≥ 150 per finestra** ⇒ **n ≥ 300** totali |
| 3 | 🚪 **C0** | se `n ≥ 150`: **PF ≥ 1,10** nella finestra peggiore |
| 4 | ⏱️ **FREQUENZA** | **≥ 1,00 op/giorno di FAMIGLIA** (firma 07/09) |
| 5 | 💸 **C3** | stop mediano ≥ **40 × spread** |

**La fonte dei numeri della flotta**: `R103_REFERTO_BLOCCO1_INDICI.md` (15 sedie indici, 21 mesi) + `R103_REFERTO_FINALE.md` (25 sedie forex/metalli, 6,5 anni) — **l'unico posto del repo dove PF, DD e `n` sono misurati con lo stesso metro su molte sedie**, normalizzati a rischio 1%. Piu' `CENSIMENTO_CONTRATTI.md` per le sedie nate dopo e per le frequenze.

⚠️ **Le approssimazioni, dichiarate:** (a) R103 e' **OHLC M1**, quindi il **DD e' un LIMITE INFERIORE**, mai un permesso; (b) R103 da' l'`n` **totale** della finestra, non lo split IS/OOS: leggo il campione in **due modi** — generoso (`n ≥ 150` totali) e alla lettera (`n ≥ 300`); (c) il cancello **C3 e' [NON MISURATO] su quasi tutta la flotta** (lo stop mediano in punti indice non e' in archivio per queste sedie) e quindi **non lo conto**: il numero che segue e' quindi **ottimista**.

## 3.2 🔢 IL CONTO — **41 sedie uniche, quante ne passano**

`CENSIMENTO_CONTRATTI.md` §6: **47 righe-sedia su 3 conti = 41 SEDIE UNICHE**.
Di queste: **35 hanno un PF da R103** · **2 hanno un PF altrove** (GatedShort, GapContinuation) · **4 sono `[NON MISURATO]`** (PostNews ECB 771201, PostNews FOMC 771202, PostNews NFP 771203, `BREAKOUT_EA_JPY_v3`).

| lettura | **passano** | su 41 | chi |
|---|---:|---:|---|
| 🟢 **generosa** (DD ≤10% · PF ≥1,10 · `n` ≥150 **totali**) | **10** | 24% | ORB_Ott U30USD · EMA200 U30USD · DAX_Apertura D30EUR · Dow_Apertura U30USD · SuperWave_DOW_H1 · SupRev_NAS_H1 · PunteLarry EURCAD · EMA200_Ott XAUUSD · SupertrendRev_Ott XAUUSD · PTE GBPUSD B25 |
| 🔴 **alla lettera** (stesso, ma `n` ≥ **300** = 150 per finestra) | **3** | **7,3%** | **EMA200 U30USD** · **DAX_Apertura D30EUR** · **EMA200_Ott XAUUSD** |
| 🔴🔴 **col metro di un round vero** (R116: PF ≥1,15 · DD ≤8,0% · n ≥300) | **3** | 7,3% | gli stessi tre |

### 🧨 E ORA I TRE SOPRAVVISSUTI, SMONTATI UNO PER UNO

| sedia | passa? | il fatto che lo smonta |
|---|---|---|
| `ABTG_EMA200_Ott` **XAUUSD** 971501 | ✅ sulla carta (PF 1,20 · DD 7,8% · n 610 su 6,5 anni) | 🔴 **R100 lo rimisura su 22 anni: DD 45,91% a rischio 1% = 10,4× il promesso originale.** La firma del 23/08 dice testualmente **"prop: NO a nessuna taglia"** (`CENSIMENTO_CONTRATTI.md` §4b). **Il suo passaggio e' un artefatto della finestra corta.** |
| `ABTG_DAX_Apertura_EU` **D30EUR** 770101 | ✅ su R103 (PF 1,34 · DD@1% 7,28% · n 446) | ~~🔴 **Sulla cella del suo CONTRATTO (R83/R118, tick, rischio 1%) fa DD 10,5984% — SOPRA il muro del 10% — con PF 1,18776 e n 311** (`r118_csv/ABTG_DAX_Apertura_EU_D30EUR_OOS_r118c.csv`). Sta dentro **perche' gira a 0,65%**: il margine viene dalla taglia.~~ 🔴🆕 **ERRATA 11/09 — QUESTO SMONTAGGIO NON REGGE PIU', ED E' UN ERRORE MIO DI ATTRIBUZIONE.** R83/R118 **non e' la cella del suo contratto**: quelle corse hanno **`InpAllowShort=1`** (e magic di laboratorio), cioe' **il lato corto acceso**, che sul conto reale 10105439 **non gira e non e' mai girato** (`InpAllowShort=false` nel preset vivo). La cella **davvero viva** e' long-only e fa **DD 6,7111% a rischio 1,0%** (`aperture_r35/..._OOS_r35.csv` r.8, PF 1,41521, n 270) e **4,3501% a 0,65%** (`ritardo_r119b_csv/..._R119_DAX_D0000.csv` r.2, `InpMagic=770101`, PF 1,41105). 👉 **Cade la conclusione *"sta dentro solo perche' gira a 0,65%"*: sta dentro il muro del 10% ANCHE a 1,0%, con 3,3 punti di margine.** Il lato corto da solo valeva **+3,8873 punti** di DD. ⚠️ **[MISURATO a deposito 10.000 EUR]** — su banco **100.000 EUR** e' **[NON MISURATO]** (+7,8% misurato sul solo effetto deposito). 📄 `report/CONFLITTO_DD_770101_2026-09-11.md`. 🟢 **E la riga del §3 va letta di conseguenza: questa sedia non e' un sopravvissuto *smontato*.** Resta ferma per **altro** (R3 0,97 op/g da sola, R5 33,0x sul cancello del costo), non per il suo DD. E sull'IS dell'ancora dell'08/09 fa **PF 1,15396** |
| `ABTG_EMA200` **U30USD** 771531 | ✅ **e regge lo smontaggio** — PF **1,42** · DD **6,48%** · **n 712** · peggior giornata **−2,24%** (massimo del blocco indici) · **1,55 op/giorno da sola** | 🟡 Unico buco: **C3 [NON MISURATO]** (lo stop mediano in punti indice non e' in archivio). E il DD viene da **OHLC** = limite inferiore |

> ### 🔴🆕 ERRATA 11/09 — **HO SMONTATO LA `770101` COL NUMERO DI UN'ALTRA SEDIA. E HO CONTROLLATO SE IL VERDETTO SI RIBALTA: NO.**
> Lo smontaggio della `770101` qui sopra poggiava su **R83/R118 (DD 10,5984% a
> tick)**, che e' la cella **col lato corto ACCESO** — non quella che gira. La
> cella viva, **long-only e a tick**, fa **DD 6,7111% @1,0%** con **PF 1,41521**
> (`aperture_r35/..._OOS_r35.csv` r.8) e **4,3501% @0,65%**
> (`ritardo_r119b_csv/..._R119_DAX_D0000.csv` r.2). 🔴 **Quindi lo smontaggio,
> come e' scritto, CADE: sul DD questa sedia non e' sopra il muro, ne' a 0,65%
> ne' a 1,0%.** 📄 `report/CONFLITTO_DD_770101_2026-09-11.md`.
>
> 🧪 **E allora i sopravvissuti diventano DUE? Ho provato a romperlo, e la
> risposta e' NO — per un motivo diverso da quello che avevo scritto:**
>
> | criterio del §3 | la cella VIVA a tick (R35/R119) | esito |
> |---|---|---|
> | PF ≥ 1,15 | **1,41521** | ✅ |
> | DD ≤ 8,0% (a 1%) | **6,7111%** | ✅ |
> | **`n` ≥ 300** | 🔴 **270 uscite — e in POSIZIONI sono 193** | ❌ **BOCCIA** |
>
> 👉 **Il `n = 311` che l'aveva fatta entrare nella riga «alla lettera» e' della
> cella col corto acceso, non di questa.** Sulla cella viva il campione **non
> arriva a 300**, e la sedia esce dalla riga `n ≥ 300` **dalla porta del
> campione invece che da quella del rischio**.
> ⚠️ **E l'`n = 446` di R103 non la salva**: R103 e' **OHLC M1** — limite
> inferiore dichiarato al §0/§3 — e da' l'`n` **totale** della finestra, **non**
> lo split IS/OOS. Usarlo per riammetterla sarebbe **scegliere la misura piu'
> comoda**, che e' l'errore opposto a quello che sto correggendo.
>
> ✅ **CONCLUSIONE: il titolo qui sotto RESTA VERO, e il conto resta UNO.** Cio'
> che cambia e' **il capo d'imputazione della `770101`**: non *"fa un DD sopra
> il muro"*, ma *"sulla cella che gira davvero il campione si ferma a 270"*.
> 🟢 **Ed e' una notizia buona travestita da errata**: sul **rischio** questa
> sedia e' **piu' sana** di come l'avevo descritta.
> ⚠️ Con l'asterisco di sempre: **[MISURATO a deposito 10.000 EUR]**; su banco
> **100.000 EUR** il DD promesso e' **[NON MISURATO]** (+7,8% misurato sul solo
> effetto deposito).

> ## 🔴 **LA RIGA CHE CLAUDIO DEVE LEGGERE DUE VOLTE**
> ## **DELLE 41 SEDIE CHE HA IN CAMPO, OGGI NE PASSEREBBE UNA.**
> `ABTG_EMA200` sul Dow. Ed e' anche l'unica famiglia che supera il pavimento di frequenza (§3.3).
>
> 🎯 **E lo stesso vale per l'ultima promozione vera.** `ABTG_GapContinuation` — il candidato del 16/08, quello che *"e' passato"* — oggi **fallirebbe tre cancelli su cinque**: **DD 11,59% > 10%** (rischio), **n=70 < 150** (campione), **0,17 op/giorno di famiglia < 1,00** (frequenza). 🔴 **La sedia che ha superato i cancelli tre settimane fa non li supererebbe oggi.** Questo non e' un sospetto: e' il confronto fra due numeri scritti nei nostri file.

## 3.3 ⏱️ E IL PAVIMENTO DI FREQUENZA, applicato alla flotta vera

_Frequenze promesse da `CENSIMENTO_CONTRATTI.md`, sommate per famiglia (motore × simboli), come dice la firma del 07/09._

| famiglia | sedie | **op/giorno** | verdetto |
|---|---:|---:|---|
| **EMA200** | 2 | **1,850** | 🟢 **PASSA** |
| **Aperture** *(DAX+Dow+GatedShort, 3 EA distinti)* | 3 | **1,660** | 🟢 passa **se** i tre EA contano come una famiglia; **presi uno per uno: nessuno passa** |
| SupertrendReversal / SupRev | 5 | 0,861 | 🔴 sotto |
| SuperWave | 2 | 0,680 | 🔴 sotto |
| PunteLarry | 6 | 0,512 | 🔴 sotto |
| PTE | 3 | 0,470 | 🔴 sotto |
| ORB | 1 | 0,430 | 🔴 sotto |
| CostToCost | 2 | 0,429 | 🔴 sotto |
| EasyTrend | 2 | 0,309 | 🔴 sotto |
| MaxMinNotte | 2 | 0,248 | 🔴 sotto |
| GapFill | 5 | 0,225 | 🔴 sotto |
| BreakingBand | 3 | 0,175 | 🔴 sotto |
| GapContinuation | 1 | 0,170 | 🔴 sotto |
| PostNews ×3 · `BREAKOUT_EA_JPY_v3` | 4 | **[NON MISURATO]** | ❓ |

**Portata totale della flotta misurata: 8,02 operazioni/giorno su 37 sedie. Mediana per sedia: 0,140.**
🔴 **UNA sola sedia su 37 supera 1,00 da sola** (EMA200 Dow, 1,55). **UNA famiglia su 13 supera il pavimento** (due, se le tre Aperture contano insieme).

## 3.4 ⚖️ QUINDI: I CANCELLI SONO TARATI GIUSTI O SONO IMPOSSIBILI?

**Rispondo separando le due meta', perche' hanno risposte OPPOSTE.**

### ✅ I cancelli di RISCHIO e di EDGE sono **tarati giusti**, e lo dimostra un conteggio
`PERCHE_MUOIONO_2026-09-08.md` §1.2: **13 motori su 13** bocciati o sospesi per rischio in tutto l'archivio hanno **PF ≤ 1,19**. Zero eccezioni. Le due sedie vive stanno **sopra**. 🔴 **Nessun allentamento avrebbe salvato LondonFx (DD 37%), RELATIVO D30EUR (25%), AtrExhaustVol (68%) o Nightly (15%): sono da 1,5 a 6,8 volte il muro di una prop.** Chiudere un occhio li' non porta una sedia in campo: porta una squalifica.

### 🔴 Il cancello del CAMPIONE e' **strutturalmente irraggiungibile**, e non e' colpa della soglia: e' aritmetica
```
   n richieste = 300 (150 IS + 150 OOS)
   flotta: mediana 0,14 op/giorno per sedia · migliore 1,55
   ⇒ a 0,14 op/g servono 2.143 giorni di borsa = 8,3 ANNI
   ⇒ a 0,52 op/g (RELATIVO NASUSD) servono 577 giorni = 2,3 anni
   ⇒ tick BCM sugli INDICI disponibili: 2024.09.26 → oggi = ~500 giorni di borsa
```
🎯 **Ed e' esattamente cio' che il progetto ha gia' misurato da solo su R117** (`REGISTRO_TEST.md` §"A6 NON E' RAGGIUNGIBILE SU QUESTA GAMBA"): a 0,525 op/giorno servono **567 feriali**, ne abbiamo **503**, **mancano 64 = ~3 mesi**, e la data in cui A6 si soddisfa da sola e' il **27/11/2026** — cioe' **due mesi DOPO l'inizio della challenge**.

> ### 🥇 **LA CONCLUSIONE, DETTA COME VA DETTA**
> **Non abbiamo cancelli troppo severi. Abbiamo un cancello dimensionato in OPERAZIONI e una flotta che le operazioni non le produce, su una finestra dati che non le contiene.**
>
> Il cancello dei 150 **e' giusto in linea di principio** (sotto quella soglia il PF non e' una misura: `−0,879` contro `−0,011`) **e impossibile in pratica** con questi motori e questi dati. Le due cose sono vere insieme, e **la via d'uscita non e' abbassarlo**: e' 🎯 **produrre operazioni dove il backtest non puo' (il forward demo) e allargare ai simboli i motori che gia' hanno un numero**. Ed e' esattamente cio' che la firma del 07/09 aveva gia' capito.

---

# 4. 🎣 LA LISTA DEI RECUPERABILI — ordinata

**Criteri del mandato, applicati alla lettera e senza sconti:**
`PF OOS ≥ 0,90 con n ≥ 100` → **A** · `bocciato per SOLA frequenza con PF > 1,10` → **B** · `bocciato per RISCHIO con PF > 1,20` → **C** · `PF < 0,80` → **MORTO**.

## 4.1 🥇 **RECUPERABILE A** — PF OOS ≥ 0,90 con n ≥ 100

> ⚠️ **Il criterio A e' largo per costruzione** (PF 0,90 vuol dire *perdere*). L'ho applicato **alla lettera** e poi ho separato in due: chi e' fermo per un **numero mancante** (recuperabile davvero) da chi e' fermo per un **numero brutto** (dove "un passo dalla soglia" e' un'illusione ottica). **La distinzione e' il valore di questa lista.**

### 🟢 A1 — fermi da un numero **MANCANTE**: i recuperabili veri

| # | candidato | PF | `n` | DD | perche' e' recuperabile | cosa servirebbe | ⏱️ costo macchina |
|---:|---|---:|---:|---:|---|---|---|
| 🥇 | **NY SESSION RETEST slope 75** (VWAP di seduta, U30USD M15 + trend H1) | **1,374 / 1,427** (sl5/sl7) | **115 / 114** | **3,7-4,7%** · pegg. giornata **−0,69%** | 🎯 **E' il miglior numero non promosso dell'archivio.** Fermato **SOLO** dal muro dei 150. Il gate slope e' **il primo gate costitutivo della flotta VALIDATO a tick**: monotono, dimezza il DD. Rischio **eccellente** | Il tagliando e' **gia' calendarizzato e meccanico**: la cella fa ~5,4 op/mese, la finestra tick BCM cresce da sola → n≥150 stimato **primavera-estate 2027**. 🎯 **Oppure: demo sul piccolo 50503392 adesso**, dove le operazioni si accumulano in tempo reale invece che aspettare il backtest | **ZERO ore di banco.** Serve preset + magic nuovo + compilazione (l'EA esiste). ⏱️ **~1 ora di lavoro umano** |
| 🥈 | **RELATIVO NASUSD** (z-score NASUSD/U30USD, M5) | **1,189** OOS | **87 IS / 154 OOS** | **8,40%** · pegg. giornata **−2,12%** | 🟡 **Il rischio non e' MAI stato rosso.** Bocciato solo su A6 (n IS 87) e con E OOS **0,063R** in zona morta (soglia 0,075, muro 0,050). La gamba gemella D30EUR e' **bocciata per rischio** (DD 25,01%) → **solo NASUSD** | R117BIS e' **gia' pronto e pinnato** (`righe/RIGA_RELATIVO_R117BIS.ps1`, pin `48b035cf…`): non tocca un parametro del motore, muove `@FINOA` e `FrazioneIS`. ⚠️ **Il verdetto atteso resta MERITO SOSPESO** — serve a leggere A3 su campioni bilanciati. 🔴 **A6 si soddisfa da sola il 27/11/2026** | ⏱️ **minuti di banco** (riga pronta) + ~1 ora per il pacchetto demo |
| 🥉 | **SupRev DOW H1** (`ABTG_SupRev_DOW_H1_Ottimizzato`, magic **970916**) | **1,20** | **273** 🟢 | **9,8%** a rischio **1,0%** | 🎯 **L'UNICO di tutta la corsia demo col MERITO MISURABILE a pieno titolo (n≥150).** Etichettato *"DD troppo alto"* in `CLASSIFICHE.md` — ma **misurato a 1%**, e la sedia girerebbe a **0,65%** ⇒ DD atteso **~6,4%**. 🟢 **E' il piu' veloce della coda: ~0,60 op/giorno** [DERIVATA dal gemello 770511] | Rimisurare **la stessa cella** a 0,65%, split IS/OOS 40/60, finestra tick 2024.09.26→2026.06.30, **misurando la peggior giornata** (oggi 🔴 NON MISURATA, e con DD 9,8% **non e' implicata**) | ⏱️ **pochi minuti di banco** — l'EA esiste ed e' gia' compilato dal 26/07 |

⚠️ **La contro-evidenza su A3, dichiarata prima che la trovi qualcun altro:** la gamba **H4** dello stesso motore sullo stesso simbolo (970914) ha avuto la **promozione REVOCATA** — PFmed a tick **0,79** contro OHLC 2,58 — e il CAC H4 e' crollato da **7,37 a 0,96**. 🟢 Ma il numero dell'H1 **e' gia' a tick**, non OHLC: non e' della stessa natura.

### 🔴 A2 — soddisfano il criterio A **alla lettera**, ma il numero brutto e' gia' stato letto

| candidato | PF | `n` | perche' NON e' un recuperabile |
|---|---:|---:|---|
| **BreakingBand GBPUSD M30** (R111) | 1,087 OOS | 174 OOS / 181 IS | 🔴 **Il merito NON e' sospeso: e' misurabile e dice no.** Su 8 anni interi PF 1,032 con n 358 e DD 11% = *"in pari, non paga il costo del rischio"*. Il capitolo "discesa di TF della Breaking Band" e' **CHIUSO** (H1 > M30 > M15, gradiente monotono su 3 simboli) |
| **LVNArbitro U30USD M30** | 1,053 OOS | **618** OOS | 🔴 **DD 11,76% (OOS) e 19,35% (IS) a 100k.** Il suo referto lo descrive come *"un'erosione lunga"*: guadagna +11,31% — **sopra il target del +10%** — ma **avrebbe sfondato il muro prima di arrivarci** |
| **AtrExhaustVol** (R109, 4 celle su 6) | 0,911-0,990 | 655-927 | 🔴 **DD da 44,3% a 67,8%**, una peggior giornata **−9,72%**. Da 4,4 a 6,8 volte il muro prop |
| **LondonFx EURUSD** 5 medie / canale nudo | 0,923 / 0,898 | 1.343 / 2.253 | 🔴 **DD 31,26% e 45,29%.** E il motore promuovibile (canale+RSI) fa **0,843 con DD 37,14%** |
| **IBRetest D30EUR** (gamba migliore) | 0,96493 OOS | ~107 OOS | 🔴 **Vietato esplicitamente dal suo stesso referto**: *"Non ritestare solo il DAX"* — tenere il simbolo migliore e buttare gli altri due e' la scelta a posteriori che la regola del 19/08 vieta. PF di **famiglia 0,7798** |
| **DAX short in apertura** (R107) | 0,957 OOS | **257** OOS | 🔴 **Campione PIENO, rosso in ENTRAMBE le finestre**, compresa quella che contiene la discesa feb-apr 2025. *"Non paga neppure quando il calendario glielo apparecchia"* |

🟡 **E uno che manca il criterio per un soffio, ma va nominato:** **DaxReEntry lato LONG** — **6/6 celle verdi, PF fino a 1,80, DD 2,5-4,6%**, take mediano **+76,8 punti indice = 46,5× lo spread D30EUR** (🟢 sopra la frontiera del costo **di lavoro**). Fuori da A solo perche' **n = 57/92 < 100**. Lo short e' **misurato e morto** (PF 0,38-0,54): **long-only, e scritto nel preset**. 🎯 **In sostanza e' il quarto A1**, e sta gia' fra i quattro 🟢 di `CORSIA_DEMO_CANDIDATI_v2.md`.

## 4.2 🟢 **RECUPERABILE B** — bocciato per **sola frequenza** con PF > 1,10

`RIPESCAGGIO_FREQUENZA_2026-09-08.md` ha censito **7 candidati** rientrati in coda dopo la firma del 07/09. Ho controllato il PF di tutti e sette.

| # | candidato | PF | `n` | DD | verdetto B |
|---:|---|---:|---:|---:|---|
| 🥇 | **SUPERWAVE DAX H4** (`ABTG_SuperWave_DAX_H4_Ottimizzato`, magic **770512**) | **1,28** ✅ **a TICK REALI** | 56 | **3,3%** a 1% · 7/9 celle positive | 🟢 **RECUPERABILE B — e' l'unico dei sette con un PF.** |
| 2 | famiglia **gap di sessione cash** (D30EUR/U30USD/SPXUSD) | **[NON MISURATO]** | — | [NON MISURATO] | ❌ fuori: nessun PF. E sull'unico simbolo portato a tick BCM il **segno si e' rovesciato** (07/09) |
| 3 | **IU Gap Fill** — ingresso alla riconquista confermata | **[NON MISURATO]** | — | [NON MISURATO] | ❌ fuori: nessun PF |
| 4 | **M27** deriva overnight vs intraday | **[NON MISURATO]** | — | [NON MISURATO] | ❌ fuori: nessuna corsa mai fatta |
| 5 | **M0PB** (Momentum Pull Back) | **[NON MISURATO]** | — | [NON MISURATO] | ❌ fuori: la sonda **non apre ordini** — di M0PB conosciamo frequenza e geometria, **null'altro** |
| 6 | **RSI Ea MT5** (Code Base 59303) | **[NON MISURATO]** | — | [NON MISURATO] | ❌ fuori: mai girato |
| 7 | **Power Hour + ICT Opening Gap** | **[NON MISURATO]** | — | [NON MISURATO] | ❌ fuori: **il sorgente non e' mai stato aperto** |

> ### 🔴 IL FATTO SCOMODO DEL RIPESCAGGIO, e va detto: **SEI DEI SETTE RIPESCATI NON HANNO NESSUN PF.**
> Non e' un difetto del referto del 08/09 — quel documento lo dichiara riga per riga. **Ma cambia il significato del ripescaggio**: la firma del 07/09 non ha restituito sei candidati misurati e ingiustamente scartati; ha restituito **sei domande mai poste**. 🎯 **Il ripescaggio per frequenza produce UN recuperabile, non sette.**
>
> 🟡 **Aggiunta onesta fuori lista:** `SuperWave NASUSD H1` — **PF 1,26 · DD 2,0% · n 95**, ma **[OHLC, screening 26/07, mai a tick]** e con la finestra dello screening **non dichiarata nel registro**. Non fu scartato per frequenza (fu detto *"marginale"*), quindi non e' un B — ma la famiglia SuperWave ha **due trasferimenti OHLC→tick misurati e FEDELI** (Dow H1 1,42→**1,52**, DAX H4 1,30→**1,28**), che e' l'opposto del SupRev. **Merita una corsa a tick, non una promozione.**
>
> 🔴 **E la contro-evidenza sulla famiglia:** SuperWave **GBPUSD** e' morta (R103: PF 0,79 · DD 13,4% · 5/7 anni negativi, spenta il 24/08) e il **lato short del Dow** e' morto (R110: PF OOS 0,429). 🧮 **E con il DAX H4 dentro, la famiglia fa 0,80 op/giorno: ANCORA SOTTO il pavimento di 1,00.** Il ripescaggio la avvicina, non la risolve.

## 4.3 ⚫ **RECUPERABILE C** — bocciato per RISCHIO con PF > 1,20

> ## 🔴 **LA LISTA C E' VUOTA. ZERO CANDIDATI. E QUESTO E' IL RISULTATO PIU' IMPORTANTE DEL DOCUMENTO.**

Il criterio del mandato — *"un DD si abbassa con la taglia, un edge no"* — e' **giusto in linea di principio**. Ma applicato all'archivio non trova **nessuno**, e il motivo e' un conteggio gia' agli atti:

> **`PERCHE_MUOIONO_2026-09-08.md` §1.2: dei 13 motori bocciati o sospesi per rischio con un PF misurato — PF minimo 0,763 · mediano 0,917 · MASSIMO 1,189. NESSUNO, MAI, ha superato 1,19.**

I quattro piu' alti, in ordine: `AllineaLondra` **1,12** (estremo alto di 8 letture, 7/8 in perdita) · `FASE 2 Nasdaq` **1,083** · `LVNArbitro` OOS **1,053** · `BreakinBox` **1,007**. **Il piu' vicino alla soglia di 1,20 dista 0,08 punti di PF, e ha 7 letture su 8 in rosso.**

### 🎯 COSA SIGNIFICA, tradotto
**Non esiste, in tutto l'archivio, un motore con un edge vero ucciso da un drawdown.** Se ne esistesse uno, lo si rimpicciolirebbe e andrebbe in campo — **ed e' esattamente cio' che il progetto ha gia' fatto**, tre volte, sulle sedie **vive**:

| sedia viva | PF | DD a 1% | taglia viva | DD alla taglia viva |
|---|---:|---:|---:|---:|
| `CostToCost` EURJPY 772361 | **1,41** | 12,3% | 0,65% | ~8,0% |
| `MaxMinNotte` XAUUSD 770402 | **1,31** | 10,6% (22a: **19,72%**) | 0,5% | ~10,0% |
| `ORB_Ott` U30USD 770611 | **1,67** | **10,00%** | 0,30% | ~2,98% |

👉 **La manopola della taglia funziona e la usiamo gia'.** Il problema e' che **non c'e' niente di nuovo su cui usarla**: chi ha un DD fuori dai muri, in casa nostra, ha anche PF ≤ 1,19 — cioe' **non e' un motore buono che sbanda, e' un motore senza edge, e il drawdown e' il modo in cui la cosa si vede**.

## 4.4 💀 **MORTI — PF < 0,80. NON SI TOCCANO.**

_Dirlo vale quanto elencare i vivi: ogni ora spesa qui e' un'ora tolta al 1° ottobre._

| candidato | PF | il numero che chiude la porta |
|---|---:|---|
| `RELATIVO` D30EUR M5 | **0,452** | DD 25,01% **+** peggior giornata −5,20% = due muri insieme |
| `ORB` Dow **SHORT** (R54) | **0,520** | DD 26,37% |
| `ABTG_IBRetest` U30USD IS | **0,382** | famiglia 0,7798 su n=344, cancello **C0** |
| `Nasdaq retest` long (R115) | **0,556** | n=199 ≥150 = **merito misurabile**, DD 17,50%, collasso IS 1,624 → OOS 0,556 |
| `IBRetest` NASUSD | **0,563 / 0,593** | idem, famiglia |
| `Nasdaq_Apertura_US` **SHORT** (R107) | **0,460** | IS PF 3,220 → OOS 0,460: overfit da manuale |
| `CRT TurtleSoup` a tick | **0,43-0,73** | 0/30, e il gate ADX **non salva** (0,459 gated vs 0,462 nudo) |
| `PostNews` blocco 13:30 USDJPY | **0,66 / 0,90** | PF < 1 su **entrambe** le finestre, campione pieno |
| `PostNews` ISM EURUSD | **0,76 / 0,79** | idem |
| `CostToCost` XAGUSD | **0,70** | 6/7 anni negativi — spenta il 24/08 |
| `LondonFx` GBPUSD canale+RSI | **0,763** | DD 55,03% |
| `EURUSD` BreakingBand M30 | **0,740** | n=195 sull'intera = NO misurabile |
| `SuperWave` GBPUSD | **0,79** | DD 13,4%, 5/7 anni negativi — spenta il 24/08 |
| `AltaVelocita` v1/v1.1 GBPUSD | **0,54-0,82** | 8/8 celle negative |

🚫 **E le famiglie chiuse con una misura, che non si riaprono cambiando simbolo o parametro** (regola della seconda caccia, 19/08): breakout M5 in apertura (**27/27 combo negative** a tick) · fade estremi del range (**0/48**) · Londra ORB (**0/48**) · rimbalzo ORL/ORH (**0/8+0/8**) · sweep+reclaim JPY (**0/30 con 21.354 livelli creati** — *non e' fame di segnali*) · micro-pivot sweep (**−0,2 punti su 22.616 segnali** contro ingressi casuali) · compressione ATR (**−1,2 punti su 9.723**) · numeri tondi Osler (**5 letture su 6 negative su 93.000+ segnali**) · asta LBMA sull'oro (**72 celle su 72 negative**) · orologio sugli indici ramo DAX (**0/72 fasce asimmetriche in OOS**).

## 4.5 🧾 IL RIASSUNTO DELLA LISTA

| classe | quanti | e sono |
|---|---:|---|
| 🥇 **A1 — recuperabili veri** (fermi da un numero mancante) | **3** *(+1 che sfiora)* | NY Retest slope 75 · RELATIVO NASUSD · SupRev DOW H1 *(+ DaxReEntry LONG)* |
| 🔴 **A2 — passano il criterio A alla lettera, ma sono gia' letti** | **6** | BB GBPUSD M30 · LVNArbitro · AtrExhaustVol · LondonFx · IBRetest DAX · DAX short |
| 🟢 **B — bocciati per sola frequenza con PF > 1,10** | **1** *(su 7 ripescati)* | SuperWave DAX H4 |
| ⚫ **C — bocciati per rischio con PF > 1,20** | **0** | **la lista e' vuota, e il perche' e' il 13/13** |
| 💀 **MORTI (PF < 0,80)** | **14 nominati** + ~10 famiglie chiuse | non si toccano |

> 🎯 **Nota di convergenza:** i **tre A1 + DaxReEntry LONG + SuperWave DAX H4** sono **esattamente** i quattro 🟢 di `CORSIA_DEMO_CANDIDATI_v2.md` §2 piu' il capofila della coda (§3.1). **Due analisi indipendenti, partite da criteri diversi, arrivano alla stessa lista.** Non e' una prova, ma e' l'indizio piu' forte che la lista sia giusta.

---

# 5. 🚀 LE TRE COSE CHE FAREI IO — in ordine di valore/costo, con la challenge fra ~3 settimane

> 🧊 **Sono proposte. Non tocco niente. La firma e' di Claudio.**

## 🥇 1. **METTERE IN DEMO SUL PICCOLO 50503392 I QUATTRO CANDIDATI GIA' PRONTI — questa settimana.**

**Chi:** RELATIVO NASUSD (0,525 op/g) · NY Retest slope 75 (0,25) · DaxReEntry **LONG-ONLY** (0,17) · SuperWave DAX H4 (0,12).
**Cosa costa:** 🟢 **ZERO ore di banco, ZERO EA da scrivere.** Tutti e quattro hanno l'EA gia' scritto e compilato. Manca a tutti la stessa terna: **preset · magic nuovo · compilazione**. ⏱️ **Mezza giornata di lavoro umano per tutti e quattro.**

**Perche' e' la prima:**
- 🎯 **Aggiunge +1,08 op/giorno** a una flotta che oggi ne fa 8,02 in totale con **mediana 0,14**. Sono **~22 operazioni al mese** in piu' di dati veri, e le operazioni sono l'**unica cosa che produce un verdetto in tre settimane**.
- 🎯 **E' l'unico modo di attaccare il muro dei 150 senza abbassarlo.** Il backtest non puo' dare quelle operazioni (i tick BCM sugli indici partono dal 2024.09.26 e non si allungano); **il forward demo si'**, in tempo reale.
- 🎯 **Il conto giusto esiste gia' ed e' gratis.** Il 06/09 Claudio ha deciso: **niente Guardian sul piccolo**, perche' *"dobbiamo vedere appieno come si comportano gli EA"*. **Il piccolo e' lo strumento di misura, non il conto da proteggere** — e questo e' esattamente il suo mestiere.
- ✅ **Tutti e quattro hanno il RISCHIO gia' misurato e dentro i muri** (DD 2,5% · 3,7-4,7% · 8,40% · 3,3%). Non e' chiudere un occhio: **il rischio non e' sospeso, e' verde**. Ad essere sospeso e' solo il **merito**, che e' esattamente cio' che il forward misura.

**🔴 Le condizioni, che valgono quanto la proposta:**
1. **Il contratto si scrive PRIMA della prima posizione** (`CORSIA_DEMO_REGOLE.md`, 4 righe: la domanda · il traguardo n=150 con la data · il DD promesso · il tagliando a 6 mesi), altrimenti il criterio di uscita del 18/08 **non e' applicabile**.
2. **RELATIVO: solo NASUSD.** La gamba D30EUR e' bocciata per rischio (DD 25,01%, peggior giornata −5,20%).
3. **DaxReEntry: long-only, scritto nel preset.** Lo short e' misurato e morto.
4. ⚠️ **SuperWave DAX H4 ha la peggior giornata [NON MISURATA]**: e' *implicata* da un DD del 3,3%, ma implicata **non e' provata** (R112: *"PeggGio e' un PAVIMENTO — il muro prop guarda il FLOTTANTE"*).

---

## 🥈 2. **IL ROUND DI RIMISURA DEL `SupRev DOW H1` (970916) — pochi minuti di banco.**

**Cosa:** rimisurare **la stessa cella, senza toccare un parametro** — `StMult 3,5 / AtrP 9 / TP_RR 3,0` — alla **taglia deployabile 0,65%**, con **split IS/OOS 40/60**, sulla finestra tick **2024.09.26 → 2026.06.30**, **misurando la peggior giornata**.

**Perche' e' la seconda:**
- 🥇 **E' l'unico candidato di tutta la corsia demo col MERITO MISURABILE a pieno titolo: n = 273.** In un progetto dove *"il merito sospeso e' la condizione normale"*, questo e' un unicum.
- 🎯 **Ed e' il piu' veloce della coda: ~0,60 op/giorno**, contro lo 0,525 del migliore dei quattro verdi.
- 🎯 **La sua unica accusa e' un numero letto alla taglia sbagliata.** L'etichetta *"DD troppo alto"* viene da **9,8% a rischio 1,0%**; a 0,65% l'aritmetica di casa da' **~6,4%**. 🔴 **Ma e' aritmetica, non misura** — ed e' proprio per questo che il round va fatto invece di dedurlo.
- ⏱️ **Costa minuti**: l'EA esiste ed e' compilato dal 26/07.

**🔴 Cosa va scritto PRIMA dei numeri:** che il numero del 26/07 e' una validazione **full-period senza split**, su una finestra dichiarata "2024.01→2026.06 nominale" quando **i tick indici BCM partono dal 2024.09.26**; e che la **gamba H4 dello stesso motore ha avuto la promozione REVOCATA** (PFmed tick 0,79 contro OHLC 2,58). 🟢 Il numero dell'H1 e' pero' **gia' a tick**: non e' della stessa natura.

---

## 🥉 3. **ALLARGARE AI SIMBOLI I MOTORI CHE HANNO GIA' UN NUMERO — a partire da `EMA200`.**

**Cosa:** prendere i motori che **passano i cancelli di oggi** e metterli su **piu' simboli**, invece di cercarne di nuovi. Il capofila e' ovvio: **`ABTG_EMA200` — PF 1,42 · DD 6,48% · n 712 · peggior giornata −2,24% · 1,55 op/giorno.** E' **l'unica sedia della flotta che passa oggi tutti i cancelli** (§3.2) **e** l'unica famiglia sopra il pavimento di frequenza (§3.3).

**Perche' e' la terza (e perche' non e' la prima):**
- 🎯 **E' cio' che la firma del 07/09 dice, misurato sul campo vero**: un conto reale con statistiche calcolate da MQL5 gira **3-5 EA su 26 simboli** e fa **0,29-0,47 op/giorno per simbolo**. **La portata la fa la larghezza, non la velocita'.** E noi le sedie le abbiamo **una per simbolo**.
- 🎯 **R106 lo ha gia' misurato dall'altro lato:** tagliare sedie **rallenta** il viaggio verso il +10% (da 16 a 28 giorni mediani) **senza comprare sicurezza** (zero violazioni dei muri in tutte le configurazioni). *"La flotta E' la squadra."*
- ⏱️ **Costa un walk-forward per simbolo su un EA gia' compilato**: minuti di banco ciascuno.
- 🔴 **Ma e' terza, e per una ragione seria:** il **tetto per cluster/valuta al 3,0%** e' **firmato il 07/09 e NON ATTIVO** (implementato in Guardian v1.13 ma **spento di default, non compilato, non collaudato**). 🚨 **Allargare ai simboli senza controllo della correlazione e' esattamente la trappola misurata**: i due portafogli "prop firm ready" a larga base letti hanno **DD del 32,59% e 45,64%**. 👉 **Quella che allarga e' firmata e pronta; quella che protegge no. Prima si accende la seconda.**

---

## 🚫 E LE TRE COSE CHE **NON** FAREI, nelle prossime tre settimane

1. ❌ **Non abbasserei nessun cancello di RISCHIO.** Non porterebbe in campo nemmeno una sedia (§3.4): chi e' fuori sta a 1,5-6,8 volte il muro.
2. ❌ **Non scriverei EA nuovi.** M0PB, la deriva oraria di Breedon, il gap-riconquista: sono **EA da scrivere + un round intero = giorni, non ore**. 🔴 **Non e' materiale da 1 ottobre**, e il referto del 08/09 lo dice gia' con queste parole.
3. ❌ **Non aprirei un'ottava caccia web.** Le ultime sei hanno prodotto **zero EA promossi** e la conclusione converge da sola: *"il materiale migliore e' GIA' IN CASA"* (03/09), *"il Code Base non produce piu' MOTORI"* (quinta conferma, 06/09), *"su TradingView il DAX gratuito e' fatto di INDICATORI"* (terza conferma indipendente).

---

# 6. 🕳️ I BUCHI DI QUESTO DOCUMENTO — dichiarati, non tappati a mente

1. 🔴 **Il cancello C3 (costo) e' [NON MISURATO] su quasi tutta la flotta.** Lo stop mediano in punti indice non e' in archivio per queste sedie. **Il conto "1 su 41" del §3.2 e' quindi OTTIMISTA**: con C3 potrebbe scendere.
2. 🔴 **Lo spread BCM su FOREX e ORO non e' mai stato misurato** (riga **H12**, aperta da sette dossier). Tutti i giudizi di costo di questo documento valgono **solo sui tre indici**. Il logger sull'oro raccoglie dal 06/09 sera: prima lettura utile a 5 sedute.
3. 🔴 **Lo slippage non e' misurato**: `ABTG_SlippageLogger` sul conto reale ha ancora **0 deal**. Ogni gradino di slippaggio di ogni round resta **uno scenario assunto**.
4. 🔴 **Non esiste una foto `.chr` piu' recente del 25/08.** Il perimetro delle 41 sedie e' la somma di quattro fonti (`CENSIMENTO_CONTRATTI.md` §0) e ha **quattro buchi noti** elencati nel suo §5.
5. 🔴 **Tutti i numeri a tick sugli indici vengono da 21 mesi di UN SOLO REGIME (toro).** `PERCHE_MUOIONO` §3.3-bis lo dice senza sconti: *"non e' possibile, con i dati che abbiamo, distinguere «hanno un edge» da «erano dalla parte giusta del toro»"*.
6. 🟡 **La classificazione delle cause di morte del §2 e' mia**, e un'altra persona ragionevole potrebbe spostare 3-4 righe. **Le due conclusioni forti del documento non dipendono da quella classificazione**: sono il conto del §3 (1 su 41) e il conteggio 13/13 del §4.3.

---

_Fonti primarie, tutte nel branch `lavoro`: `backtest_pipeline/REGISTRO_TEST.md` · `backtest_pipeline/risultati_archivio/` (R65-R119, referti passo-0, `R103_REFERTO_FINALE.md`, `R103_REFERTO_BLOCCO1_INDICI.md`, `REFERTO_NYRETEST_2026-08-31.md`, `REFERTO_SHORTGATE_2026-08-30.md`, `REFERTO_R115_2026-08-29.md`, `REFERTO_R118_PAVIMENTO_STOP.md`, `r116_londonfx/`, `r118_csv/`) · `report/CENSIMENTO_CONTRATTI.md` · `report/PERCHE_MUOIONO_2026-09-08.md` · `report/PERCHE_NON_ARRIVIAMO_2026-09-07.md` · `report/RIPESCAGGIO_FREQUENZA_2026-09-08.md` · `report/CORSIA_DEMO_CANDIDATI.md` e `_v2.md` · `report/FIRME_2026-08-18.md`, `_2026-08-31.md`, `_2026-09-07.md` · `report/P0_*.md` · `backtest_pipeline/prove/ABTG_IBRetest_00_conta_NASUSD.txt` · `FLOTTA_ATTIVA.md` · `HANDOFF.md` · `CLAUDE.md`._
_**Se un referto e questo documento divergono, comanda il referto.**_
