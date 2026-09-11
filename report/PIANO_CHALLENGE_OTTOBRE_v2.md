# 📅 PIANO CHALLENGE OTTOBRE — **v2**, rifatto coi numeri dell'11/09/2026

_Scritto dall'**architetto-prop**, **venerdi' 11/09/2026**.
**Al 1° ottobre mancano 20 giorni, di cui 13 giornate di borsa** (12/09 → 30/09)._

> ## 📌 QUALE DOCUMENTO COMANDA — dichiarato prima di tutto
> **Questo `_v2` E' IL PIANO VIVO. `PIANO_CHALLENGE_OTTOBRE.md` (v1, 08/09) resta
> in archivio come VERBALE DI QUELLO CHE CREDEVAMO IL 08/09, e non va usato per
> decidere.** Non l'ho sovrascritto apposta: quattro sue affermazioni sono state
> **misurate false** fra il 10 e l'11/09, e cancellarle cancellerebbe la prova
> che il metodo le ha trovate. In cima al v1 c'e' un rimando rosso a questa
> pagina.

> 🛑 **QUESTO FILE NON CAMBIA NIENTE.** Nessun `.mq5`, nessun `.set`, nessun
> parametro in forward, nessun terminale, nessuna riga verso il VPS. **Le taglie,
> il rischio, il conto reale 10105439 e i soldi restano firma di Claudio.** Qui
> ci sono proposte con la loro provenienza, non decisioni.

**La domanda, ed e' una sola:**

> # ❓ Con i numeri dell'11/09, che cosa deve essere vero il **30 settembre** perche' il **1° ottobre** si possa premere "inizia" **senza bluffare**?

---

# 0. 🔴 LA RISPOSTA IN UNA RIGA — e la frase del v1 riesaminata

## 🧪 IL CONTRO-ESEMPIO CHIESTO: *"il 1° ottobre e' realistico per COMPRARE, non per avere una flotta provata"* — **regge ancora?**

### 🔴 **NO. La prima meta' di quella frase E' CADUTA. La seconda e' piu' vera di prima.**

**Perche' e' caduta, col numero:** il v1 contava **quattro** requisiti e ne
concludeva *"ne passa tutti e quattro UNO"*. Ma il v1 **non contava il cancello
del costo**, che e' un criterio di casa scritto in `CLAUDE.md` (*"la frontiera
del costo `stop >= 40 x spread` non si sposta"*) ed e' stato applicato a tutta
la flotta il 10/09. Messo dentro come **R5**:

> ## 🔴 **Le candidate che passano TUTTI E CINQUE i requisiti oggi, con numeri MISURATI, sono ZERO.**
> E le due che il v1 dava per schierabili — `770611` e `770901` — **cadono tutte
> e due sul costo**: **29,5x** e **13,6x** contro un pavimento di lavoro di
> **40x** (e `770901` sta a **0,3 decimi** dal pavimento DURO 13,3x).

**Perche' la seconda meta' e' piu' vera:** al 30/09 continueremo a non avere
**nessuna famiglia a 150 operazioni forward** (la prima arriva fra gennaio e
aprile 2027), e adesso sappiamo pure che **due etichette di "merito pieno" del
v1 erano false** e che **il `n` di sei candidate su otto conta i DEAL, non le
posizioni** (§0-bis, punto 5: classe **226**, aperta oggi).

## ✅ E LA RIGA CHE SALVA IL 1° OTTOBRE — perche' una c'e', ed e' misurata

> ## Esiste una strada per arrivare al 30/09 con **TRE sedie che passano tutti e cinque i requisiti**. Costa: **un round gia' firmato**, **un file `.set`**, **una lettura d'archivio** e **due firme di Claudio**. 🔴 **Zero EA da scrivere. Zero motori nuovi. Una sola corsa di macchina.**

E la scoperta piu' grossa di questo giro e' che **la sedia meglio misurata del
parco non e' nella squadra della challenge**:

> ### 🚄 `ABTG_EMA200` **771531** (U30USD H1) e' l'UNICA del progetto con una partizione IS/OOS vera, a **tick reali**, con **tutte e due** le finestre sopra la soglia contata in POSIZIONI — e gira sul **piccolo 50503392 all'1,0%**, non sul conto della challenge.
> `R112`, 26/08, modello 4 (tick reali), `G0-B` riprodotto **al centesimo** su
> tutte e 7 le colonne in **due corse indipendenti**:
> **OOS 517 deal = 257 POSIZIONI · PF 1,52365 · DD 7,8323% · peggior giornata
> misurata −2,45%** · **IS 237 deal · PF 1,20110 · DD 5,7325%**.
> Costo: **54,9x** (+37% sul pavimento). Frequenza: **1,55 op/g**, l'unica della
> flotta che supera il pavimento **da sola**.

---

# 0-bis. ⏱️ COSA E' SCADUTO IN UNA NOTTE — le sei correzioni, tutte misurate

| # | cosa diceva il **v1** | cosa e' **misurato** ora | fonte | 🔴 effetto sul piano |
|---:|---|---|---|---|
| 1 | *"sul forex la commissione e' 0,00"* | 🔴 **il conto e' a COMMISSIONE**: **4,0000 EUR/lotto esatti** sul forex base EUR, **un solo valore distinto su 84 posizioni**; legge `0,004% del nozionale in valuta base` verificata su **otto basi**. Pedaggio all-in EURUSD **0,864 pip**, non 0,3 | `backtest_pipeline/prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md` §2 | ✅ **ZERO effetto sulle 8 candidate** (sono tutte indici/Nikkei, commissione misurata **0,0000** su 302 posizioni). 🔴 Ribalta **cinque sedie della FLOTTA** e manda `771201` PostNews EURJPY a **13,2x contro il pavimento DURO 13,3x** |
| 2 | *"`770511` n=227 = MERITO PIENO"* | 🔴 **FALSO**: il 227 e' della corsa a **finestra piena, che un fuori campione non ce l'ha**. Spezzata IS/OOS fa **84 e 143** (84+143=227), **tutte e due sotto 150** | classe **224**, `CHECKLIST_RIGA_DI_LANCIO.md:13120` | merito **SOSPESO** |
| 3 | *"`970913` n=155 = MERITO PIENO"* | 🔴 **DA RIVERIFICARE**: l'unico file OOS in archivio per quella sedia e' `..._OOS_ohlc.csv`, cioe' **screening**, che non da' mai verdetti | classe **224** | etichetta **non regge** |
| 4 | *"la compilazione porta le schierabili da 2 a 5"* | 🔴 **FALSO, ricontato sedia per sedia**: **2 → 2** in lettura stretta, **2 → 4** in lettura larga. E il fix **e' gia' nei sorgenti dall'08/09** (commit `872dba8`, 15 file su 15): non e' una modifica al codice, e' una **COMPILAZIONE** | `report/PACCHETTO_R4_DA_FIRMARE_2026-09-11.md` §2 | 👉 e con **R5 acceso il delta scende a +0**, §3 |
| 5 | *(mai scritto da nessuno)* | 🔴 **IL `n` DELL'OPTFRAME CONTA I DEAL DI USCITA, NON LE POSIZIONI.** Misurato su R112: **517 righe deal per 257 posizioni distinte** (fattore **2,01**); sulle celle short **302 per 140** (fattore **2,16**). **Sei candidate su otto hanno `InpTP1Pct = 50`**, e `770511`/`970913` hanno **anche** la tranche pendente → fino a **4 deal per segnale** | 🆕 classe **226**, aperta oggi · verificato con `awk` su `position_id` nei per-trade di `R112_CORSA_20260826/` | 🔴 **ogni `n` del piano va riletto**: §2, colonna "n in POSIZIONI" |
| 6 | *"PostNews 3,0% da portare a 1,30"* | 🟢 **FATTO da Claudio l'11/09 mattina**, tutte e tre (`771201` `771202` `771203`) al pannello F7 sul piccolo **50503392** | `report/DA_FIRMARE.md` §2 | 🔴 **il default compilato resta 3.0** (`ABTG_PostNews.mq5:113`): a ogni `Resetta` torna su **in silenzio**, ed e' costato **80,90 EUR** il 10/09 |

> ### 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO ME STESSO, sul punto 1
> *"La commissione e' la bomba del giro: quindi ribaltera' anche le candidate di ottobre."*
> 👉 **ROTTO, e va detto perche' e' la tentazione piu' facile della giornata.**
> Le 8 candidate girano su **U30USD, D30EUR, NASUSD, 225JPY**: la commissione
> misurata su quelle classi e' **0,0000 EUR/lotto su 302 posizioni**. 🔴 **Il
> delta della correzione del pedaggio sulle sedie di ottobre e' ZERO.** Chi
> avesse scritto *"cinque sedie ribaltano, quindi il piano di ottobre crolla"*
> avrebbe unito due insiemi disgiunti. **Le cinque che ribaltano sono sedie
> forex della flotta, e nessuna delle otto e' fra loro.**

---

# 1. 🚦 I CINQUE REQUISITI — dichiarati PRIMA della tabella

| # | requisito | dove si legge | perche' e' un requisito |
|---|---|---|---|
| **R1** | **cella promossa**: un round ha promosso **esattamente** la configurazione che girerebbe | `CENSIMENTO_CONTRATTI.md` col. "Fonte" | senza, il DD promesso descrive **un'altra cella** |
| **R2** | **DD di backtest dichiarato**, con **deposito + rischio + modello del banco** | `CENSIMENTO_CONTRATTI.md` | e' l'unico ingresso della corsia RISCHIO della **C3** firmata il 18/08 |
| **R3** | **frequenza misurata**, pavimento **1,00 op/g per FAMIGLIA** | firma 07/09 · `FIRME_2026-09-07.md` | una sedia da 0,2 op/g non fa in tempo a dire niente |
| **R4** | **rischio VERO = rischio DICHIARATO** | `CENSIMENTO_RISCHIO_VERO_2026-09-10.md` | un cap C1 alimentato da input bugiardi non e' una protezione |
| 🆕 **R5** | **CANCELLO DEL COSTO ALL-IN**: `stop >= 40 × pedaggio`, dove pedaggio = **spread mediano dell'ora modale + commissione misurata** | `CANCELLO_COSTO_FLOTTA_2026-09-10.md` · `COLLAUDO_SPREAD_FLOTTA_CRITERI.md` §5 | 🔴 **e' il requisito che il v1 non contava**, ed e' quello che oggi morde di piu' |

### 🧊 Le regole di lettura di R5, congelate qui e prese di peso dal collaudo del 10/09
- 🟢 **PASSA**: `>= 40x` col pedaggio all-in **alla mediana dell'ora modale**.
- 🟡 **FRAGILE**: passa alla mediana, **non** al P95 della stessa ora.
- 🔴 **SOTTO IL PAVIMENTO DI LAVORO** (`< 40x`): **non e' uno spegnimento, e' una
  raccomandazione** — e si elenca la manopola che esiste.
- ⛔ **SOTTO IL PAVIMENTO DURO** (`< 13,3x`): si scarta **per aritmetica**.
- ⚪ **NON ANCORA MISURATO**: manca lo stop o lo spread di quell'ora.

> ⚠️ **E il limite di R5, dichiarato prima di usarlo** (lo dice il referto stesso,
> in cima): `stop/spread` **NON predice il drawdown** — ρ di Spearman **+0,32**
> con l'oro dentro, **−0,02** senza. **R5 misura quanto ti mangia il pedaggio,
> non quanto drawdown farai.** Chi lo usasse come classifica di rischio userebbe
> lo strumento sbagliato. Il rischio si legge in R2.

> ⚠️ **E un limite del CONCETTO che vale per tutte e 8**: il pedaggio si paga
> **due volte**, all'ingresso e all'uscita, e l'ora dell'**uscita** e' **[NON
> MISURATO]** su ogni sedia del parco. Il pavimento `40x` di casa e' definito
> contro **uno** spread e **resta cosi'** (altrimenti le sedie non sono piu'
> confrontabili fra loro), ma va scritto: **il pedaggio vero e' circa il doppio
> di quello che il cancello misura, su tutte le sedie.**

---

# 2. 🧮 LA TABELLA DELLE 8 CANDIDATE, RIFATTA — con MISURATO/INFERITO riga per riga

**Taglia di riferimento: 0,65%** (A1 firmata). DD riportati **alla taglia viva**,
con fra parentesi il DD del banco e il suo rischio.
**Colonna `n POS`** = il campione **contato in posizioni**, non in deal (classe 226).

| # | sedia · magic · **dove gira oggi** | sym · TF | **R1** cella | **R2** DD @0,65% | **R3** op/g | **R4** rischio vero | 🆕 **R5** costo all-in | **n POS** (merito) |
|---:|---|---|---|---|---:|---|---|---|
| 1 | `ORB_Ottimizzato` **770611** 🏛️ reale 0,65% · 100k 0,30% | U30USD M5 | ✅ **R119**, cella = cella viva · **[MISURATO]** | ✅ **6,5389%** OOS · **5,6530%** IS — gia' a 0,65%, dep. 10.000, **tick** · **[MISURATO]** | **0,43** [MIS] | ✅ **0,65% vere** (`InpAllowShort=false` nel `.set` reale) · **[MISURATO]** | 🔴 **29,5x** (74% del pavimento), stop **59,0 idx** n=7, spread 2,00 ora 14 · **[MISURATO]** | **119 OOS / 71 IS** — `InpTP1Pct=0` **verificato nel CSV**, quindi **sono posizioni** ✅. 🟠 merito **SOSPESO** (<150) |
| 2 | `DAX_Apertura_EU` **770101** 🏛️ reale · 100k · piccolo | D30EUR M5 | ✅ **R83 RETEST**, cella = cella viva · **[MISURATO]** | ✅ 🆕 **CONFLITTO CHIUSO 11/09**: **4,3501%** OOS (R119, `InpAllowShort=0`, `InpMagic=770101`, n **270**, PF 1,41105) · ⚠️ **[MISURATO a deposito 10.000 EUR]** — su banco **100.000 EUR** e' **[NON MISURATO]** (+7,8% misurato sul solo effetto deposito: 7,2328% contro 6,7111% a parita' di 270 operazioni). Il ~~6,89%~~ era **10,5984% scalato**, misurato con **`InpAllowShort=1`**, risk **1,0** e magic **777120/777121** — **un'altra configurazione**: il lato corto da solo vale **+3,8873 punti** di DD. ⚠️ e il **n 311** e' di quella cella, non di questa. 📄 `report/CONFLITTO_DD_770101_2026-09-11.md` | **0,97** [MIS] | ✅ **0,65% vere** · **[MISURATO]** | 🟡 **42,3x** alla mediana **ma 33,0x sulla GEOMETRIA VIVA** (n=2) e **26,6x al P95** · **[MISURATO]** → **FRAGILE, sotto il pavimento dove conta** | **311** — EA **senza** `InpTP1Pct` **verificato**, sono posizioni ✅ · 🟢 PIENO |
| 3 | `Dow_Apertura_US` **770202** 100k 0,65% · piccolo 1,0% | U30USD M5 | ✅ R16 · riconferma R54 · **[MISURATO]** | ✅ **2,74%** (4,22% @1%, dep. **100.000**, tick, n 130) · **[MISURATO]** | **0,46** [MIS] | 🔴 **NESSUN PRESET SU FILE**: lo 0,65 vive **solo dentro un `.chr`**; il sorgente porta `ABTG_DEF_RISK 2.0` a due lati | ✅ **51,0x** — 🔴 ma lo stop e' **~102 idx [INFERITO]** (0 gambe in stop misurate); banda **44,5-53,5x** | **130** — senza `InpTP1Pct` ✅ posizioni · 🟠 SOSPESO |
| 4 | `MaxMinNotte_DAX_Short_Ott` **770411** 100k 0,65% | D30EUR M15 | ✅ R16 · **[MISURATO]** | ✅ **0,83%** (1,27% @1%, 100.000, tick) · **[MISURATO]** | 🔴 **0,078** — **13× sotto il pavimento** [MIS] | 🟠 **2 pendenti opposti** (OCO **software**, non di broker) | ⚪ **NON MISURATO**: **0 gambe in stop su 5 trade** e **ATR(14) M15 del DAX mai misurato** | **21 deal** → 🔴 **~11 posizioni [INFERITO]** (`InpTP1Pct=50`) · campione minuscolo |
| 5 | `SupertrendReversal` **770901** 100k 0,65% | 225JPY H2 | ✅ R5 · R16 · **[MISURATO]** | ✅ **0,57%** (0,88%/0,65% @1%) · **[MISURATO]** | 🔴 **0,18** [MIS] | ✅ **0,65% vere** — gamba osservata a **6,90 lotti** = 60+ volte `volMin`, il bug **non morde a 100k** · **[MISURATO]** | 🔴 **13,6x** (34% del pavimento) — **0,3 decimi sopra il pavimento DURO** · ⚠️ spread letto alle **17:34 srv = 01:34 a Tokyo, cash CHIUSO**: il verso e' **a favore**, la misura vera puo' solo migliorare | **50 deal** → 🔴 **~25 posizioni [INFERITO]** · SOSPESO |
| 6 | `SupRev_NAS_H1_Ott` **970913** ⭐ **piccolo 1,0%** | NASUSD H1 | 🟠 solo etichetta `REGISTRO_TEST` §S5v, **nessuna cella promossa** | 🟠 **1,17% @1%** ma **deposito NON DICHIARATO** | 🔴 **0,34** [MIS] | 🔴 **1,34-2,00×** [INFERITO] — `SYMBOL_VOLUME_MIN` di NASUSD **mai misurato** | 🔴 **28,7x** (72%), stop 51,65 idx n=4 · **[MISURATO]** — ⚠️ **minimo 9,70 idx = 5,4x**, sotto il duro | 🔴 **155 DA RIVERIFICARE** (unico OOS = `_ohlc`) **e** deal, non posizioni → **fra ~39 e 155 [INFERITO]** |
| 7 | `SuperWave_DOW_H1_Ott` **770511** **piccolo 1,0%** | U30USD H1 | 🟠 solo etichetta `REGISTRO_TEST` | 🟠 **4,0% @1%**, **deposito NON DICHIARATO** | 🔴 **0,50** [MIS] | 🔴 **2,00× MISURATO IN CAMPO** (20/08: **−72,32 EUR su 5.076,62 = 1,42%** contro un contratto da 1,0%) | 🔴 **forbice 25,7x – 85,7x**: il 38,5x del referto e' **un punto dentro una forbice**, angolo pessimista **29,1x** alla mediana vera 2,65 · **[MISURATO ai due estremi]** | 🔴 **227 = FINESTRA PIENA** (84+143) **e** `TP1Pct=50` **+** pendente → **fra ~57 e 227 segnali [INFERITO]** |
| 8 | `EMA200` **771531** 🚄 🔴 **PICCOLO 50503392 all'1,0% — NON sul conto della challenge** | U30USD H1 | ✅ **R29** walk-forward **30/30 PASS**, cella CENTRO · ✅ **R112** l'ha **riprodotta al centesimo** (G0-B, due corse indipendenti) · **[MISURATO]** | 🟠 **tre misure nostre che non coincidono**: 6,48% (R103) · 7,21% (R29) · **7,8323% (R112, tick)** → all'angolo peggiore **5,09% @0,65%** | ✅ **1,55** 🥇 — l'unica sopra il pavimento **da sola** [MIS] | ✅ **1,00× MISURATO sul piccolo** (`:222-224`, rischio gia' diviso /2). Su 100k il pavimento del lotto morde **MENO** (piu' saldo = piu' lotto = piu' lontano da `volMin`) → ✅ **[INFERITO, direzione dimostrata]** | ✅ **54,9x (+37%)**, stop **104,3 idx** n=8, spread 1,90 ora 17 · **[MISURATO]** | ✅ **OOS 517 deal = 257 POSIZIONI misurate** (≥150) · 🟠 **IS 237 deal ≈ 118 posizioni [INFERITO]**, sotto soglia |

### 🔢 IL CONTO, ed e' la riga che conta

| lettura | numero |
|---|---:|
| candidate esaminate | **8** |
| con **R1** pieno | **5** (770611, 770101, 770202, 770411, 770901, 771531 = 6 — meno `770411` che ha R3 rotto: **6 con R1**, 2 con sola etichetta) |
| con **R2** pieno (deposito + rischio + modello dichiarati) | ~~**5**~~ 🆕 **6** — ✅ 🆕 **`770101` NON e' piu' in conflitto** (chiuso 11/09: **4,3501% @0,65%**, dep. **10.000 EUR**, tick — 📄 `CONFLITTO_DD_770101_2026-09-11.md`); restano fuori `970913`/`770511` **senza deposito** e `771531` **con tre misure diverse**. ⚠️ **Con un asterisco che va letto**: il suo R2 e' pieno **su banco 10.000 EUR**; su un banco da **100.000 EUR** — cioe' la challenge — il DD promesso e' **[NON MISURATO]** (effetto deposito **+7,8%** misurato a parita' di 270 operazioni). **R2 e' soddisfatto alla lettera, non alla taglia della challenge** (voce **B6**) |
| con **R3** sopra il pavimento **da sola** | 🔴 **1** (`771531`, 1,55) |
| con **R4** verificato | **4** (770611, 770101, 770901, 771531) |
| 🆕 con **R5** `>= 40x` alla mediana | 🔴 **2** (`770202` 51,0x **con stop inferito** · `771531` 54,9x **misurato**) |
| 🔴 **che passano TUTTI E CINQUE, oggi, con numeri misurati** | # **ZERO** — 🆕 **invariato dopo la chiusura del conflitto `770101`**: quella sedia guadagna **R2**, ma resta sotto **R3** (0,97 op/g < 1,00 **da sola**) e sotto **R5** (**33,0x** sulla geometria VIVA < 40x). **Il totale non si muove di uno.** |
| *(lettura a 4 requisiti, come contava il v1)* | **2** — `770611` e `770901`, **e cadono tutte e due su R5** |

---

# 3. 🚦 IL DELTA SEDIE PER OGNI AZIONE — **calcolato sedia per sedia, mai sommando requisiti**

> ## 🧪 IL CONTRO-ESEMPIO CHIESTO, ed e' esattamente l'errore che ha prodotto il "da 2 a 5" falso
> **Una sedia puo' essere bloccata da PIU' requisiti insieme. Sbloccarne uno non
> la rende schierabile.** Quindi il delta si calcola **cosi'**: per ogni azione,
> si guarda **quali sedie erano a 4/5 con quel preciso requisito rotto e nient'altro**.
> Sommare "requisiti sbloccati" e' l'errore. Sotto c'e' la colonna che serve.

| azione | costo | chi tocca | 🔴 **sedie che passano 5/5 DOPO** | **Δ sedie** |
|---|---|---|---|---:|
| 💰 **Correzione del pedaggio** (commissione forex) | ✅ **gia' fatta, zero** | forex della flotta | **nessuna delle 8 e' forex**: commissione **0,0000** misurata su indici e Nikkei | **+0** |
| 🔧 **Compilazione R4** (F7 + ricarico, 15 file gia' corretti) | 10 minuti + **una firma** | `970913` `770511` `770531` `970901` `970912` | `970913` guadagna R4 **ma resta rotta su R1, R2 e R5 (28,7x)** · `770511` idem **(forbice 25,7-85,7x, angolo pessimista 29,1x)** | **+0** (era **+2** contando solo 4 requisiti, in **lettura larga**) |
| 🧪 **Round R126** (SuperWave, buffer ATR) | **non firmato** · ~corsa breve | `770511` | chiude la **forbice del costo**, ma `770511` resta rotta su **R1, R2 e R3** | **+0** |
| 🧪 **Round R125** (ORB, gia' FIRMATO 10/09) | **~7 minuti** di macchina | DAX e NASDAQ | 🔴 **sul Dow e' impossibile per costruzione** (`n` invariante 71/119 in tutte e 48 le celle di R88a). Su DAX/NAS l'`n` atteso e' **90-190 / 100-220**, cioe' **a cavallo dei 150** → e comunque **niente preset, niente magic, niente forward entro il 30/09** | **+0** certo · **0 … +1** come *candidato nuovo*, **non** come sedia schierabile |
| 📁 **Scrivere il `.set` di `770202`** (`InpRiskPercent=0.65`, `InpAllowShort=false`) | 🟢 **UN FILE. Zero macchina.** | `770202` | era **4/5 con solo R4 rotto** → 🟢 **passa 5/5** (con R5 dichiarato su **stop INFERITO**) | 🟢 **+1** |
| ✍️ **Firma sulla GEOMETRIA del giorno 1 dell'ORB**: schierare `770611` in **OPPRANGE** invece di HALFRANGE | 🟢 **zero macchina — e' gia' misurato da R88** | `770611` | era **4/5 con solo R5 rotto** (29,5x) → OPPRANGE porta lo stop a **~128 idx = ~64,0x** (**42,7x anche al P95**) → 🟢 **passa 5/5**, **e R88 misura che DIMEZZA il DD: 9,7623% → 3,840% @1%** | 🟢 **+1** |
| 📖 **Attribuire il conflitto di DD di `771531`** (R103 6,48% vs R29 7,21% vs R112 7,83%) + **misura `S*`** | 🟢 **lettura d'archivio: i tre CSV esistono gia'** | `771531` | era **4/5 con solo R2 in conflitto** → 🟢 **passa 5/5** | 🟢 **+1** |
| ✅ 🆕 **FATTO 11/09 — conflitto di DD di `770101` ATTRIBUITO** (~~R83 6,89% vs R119 4,35%~~): la causa e' **`InpAllowShort` 1 contro 0**, non finestre/split/trailing (tutti identici, verificati colonna per colonna). **R2 chiusa: DD promesso = 4,3501% @0,65%**, ⚠️ **[MISURATO a deposito 10.000 EUR]** — su banco **100.000 EUR** e' **[NON MISURATO]** (+7,8% misurato sul solo effetto deposito: 7,2328% contro 6,7111% a parita' di 270 operazioni) | lettura dei due CSV — 📄 `CONFLITTO_DD_770101_2026-09-11.md` | `770101` | ✅ chiude R2, **ma resta rotta su R5**: **33,0x sulla geometria VIVA** | **+0** |

## 🔢 IL TOTALE, con la prova che non sto sommando due volte

| | sedia | requisito unico che la blocca | azione che lo apre |
|---|---|---|---|
| 1 | `770611` | **R5** | firma sulla geometria OPPRANGE |
| 2 | `770202` | **R4** | scrivere un `.set` |
| 3 | `771531` | **R2** | attribuire il conflitto fra tre nostre misure |

> ### 🟢 **Tre sedie DIVERSE, tre requisiti DIVERSI, tre azioni DIVERSE: i delta si sommano davvero. Massimo raggiungibile al 30/09 = 3 sedie a 5/5.**
> 🔴 **E nessuna delle tre azioni e' un round.** Due sono lettura e scrittura di
> file, una e' una firma su un numero gia' misurato ad agosto. **Il collo di
> bottiglia del 1° ottobre non e' la macchina: sono tre decisioni.**

---

# 4. ⚖️ **UNA SEDIA SANA BATTE QUATTRO CHE PROMETTONO?** — il conto, non l'opinione

**Metro**: FTMO 2-Step 100k *(F1, ipotesi di lavoro — **non firmata**)*, muri
**5% giornaliero / 10% totale STATICI**, obiettivo **+10%**.
**Aspettativa**: `E alta = 0,075R` (`METRO_PROP.md` §9) e `E bassa = 0,046R`
(`REFERTO_INVES_2026-08-30`), a 0,65% = **0,0488%** e **0,0299%** per operazione.
**21,7 giornate di borsa al mese.**

| configurazione | sedie | op/g | op/mese | profitto/mese (alta / bassa) | **mesi per +10%** | muro giornaliero se **stoppano tutte** | somma DD / radice quadratica |
|---|---:|---:|---:|---|---|---:|---|
| 🔴 **la coppia che il v1 dava schierabile** (`770611` + `770901`) | 2 | 0,61 | 13,2 | 0,65% / 0,40% | **15,5 – 25,3** | **1,30%** ✅ | 7,11% / 6,56% |
| 🚄 **`771531` DA SOLA** | **1** | **1,55** | 33,6 | **1,64% / 1,01%** | 🟢 **6,1 – 9,9** | **0,65%** ✅ | 5,09% / 5,09% |
| 🟢 **il terzetto 5/5** (`770611`-OPPRANGE + `770202` + `771531`) | 3 | **2,44** | 52,9 | **2,58% / 1,58%** | 🥇 **3,9 – 6,3** | **1,95%** ✅ (cap C1 3,25) | **10,33%** 🔴 / 6,30% ✅ |
| 🔴 **tutte e otto** | 8 | 4,51 | 97,8 | 4,77% / 2,93% | 2,1 – 3,4 | ⛔ **5,20% — MURO GIORNALIERO SFONDATO dai soli stop** | — |

## 🧪 LA RISPOSTA, e mi smentisce a meta'

### ✅ **SI', una sedia sana batte quattro che promettono — ma non per il motivo che sembra.**
**`771531` da sola e' 2,5× piu' veloce della coppia che il piano v1 dichiarava
schierabile** (6,1-9,9 mesi contro 15,5-25,3), con **un quinto del rischio
giornaliero** (0,65% contro 1,30%). Non perche' sia "sana": perche' e' **quasi
tre volte piu' veloce** (1,55 contro 0,61 op/g). **La qualita' e la portata qui
sono la stessa cosa**, e il v1 non l'aveva visto perche' contava la sedia
migliore del parco **come ottava**, invece che come prima.

### 🔴 **MA una sedia sana NON batte TRE sane: il terzetto e' 1,57× piu' veloce, e sta dentro tutti e due i muri.**
Quindi la risposta giusta **non e' "una" e non e' "quattro"**: e'
**"solo quelle che passano tutti e cinque"**, che oggi sono **zero** e al 30/09
possono essere **tre**.

### 🔴 E LA COSA CHE IL TETTO GIORNALIERO **NON** DECIDE, e va detta
Con 3 sedie a 0,65% il muro del 5% **non e' il vincolo**: servirebbero **7,7
sedie** per toccarlo. 👉 **Il numero di sedie non e' una decisione di rischio
sotto il muro giornaliero: e' un AMPLIFICATORE su un segno che non abbiamo
misurato.** Con `E > 0` il terzetto arriva in **3,9-6,3 mesi**; con `E < 0`
**perde il 10% in 6,3 mesi invece che in 25**. Banco **+0,091R**, forward del
piccolo **−0,091R**: due misure nostre, **stesso rango 🥇, segno opposto**,
conflitto **aperto**. **N × E con E negativo non produce profitto: produce
perdita piu' in fretta, e quattro volte piu' in fretta con quattro sedie.**

### 🔴 E IL NUMERO CHE MI PREOCCUPA DI PIU' DEL TERZETTO
**La somma aritmetica dei DD promessi e' 10,33% contro un muro di 10%.** E' un
**limite superiore mai raggiunto in banco** (i DD non arrivano tutti lo stesso
giorno: la radice quadratica, cioe' l'ipotesi di indipendenza, da' **6,30%**) —
🔴 **ma due delle tre sedie sono sullo STESSO simbolo `U30USD`**, e
l'indipendenza li' **non e' misurata**. E' esattamente cio' che il **tetto per
cluster C10 al 3,0%** dovrebbe impedire — 🔴 **e C10 e' firmato dal 07/09 ma NON
E' ATTIVO nel Guardian: e' un'intenzione, non una protezione.**
👉 Con l'ORB in **OPPRANGE** il conto migliora di **4,04 punti** (6,54% → 2,50%):
e' la ragione **di rischio**, non di costo, per cui quella firma vale.

---

# 5. ⏱️ IL CAMMINO CRITICO FINO AL 1° OTTOBRE — dipendenze e firme

> 🔴 **IL VINCOLO CHE GOVERNA TUTTO, dichiarato per primo:**
> **il perimetro del runner notturno e' SOLA LETTURA** (un round contiene **6 dei
> 24 divieti** e verrebbe **rifiutato** — verificato). 👉 **Nessuno dei due round
> pronti, R125 e R126, puo' girare senza Claudio davanti al PC.** Allargare il
> perimetro e' **il punto 7 di `DA_FIRMARE.md`**, ed e' una **firma nuova**.

```
                 ┌─ [FIRMA A] geometria ORB del giorno 1 (OPPRANGE) ─┐
                 │       (zero macchina: R88 + cancello gia' misurati)│
 OGGI 11/09 ─────┼─ [LAVORO B] .set di 770202  (un file, agenti) ────┼──┐
                 │                                                   │  │
                 └─ [LAVORO C] attribuzione DD 771531 (archivio) ────┘  │
                                                                        │
   [FIRMA D] spostare 771531 sul conto della challenge a 0,65% ─────────┤
        └── dipende da C (quale DD si scrive nel contratto)             │
                                                                        v
   [FIRMA E] quante sedie e quali il giorno 1 ────────────────────> 30/09 lista di spunta
                                                                        ^
   [FIRMA F] invio domande ai supporti prop ── risposta SCRITTA ────────┤
        └── 🔴 UNICA VOCE CON TEMPO DI RISPOSTA CHE NON CONTROLLIAMO    │
   [FIRMA G] quale prop + statico/trailing + saldo o equity ────────────┘
        └── dipende da F.  Se il muro totale fosse TRAILING,
            il p99 a 0,65% e' 12,05% > 10%: VANNO RILETTE TUTTE le misure di DD
```

## 🟥 ENTRO MARTEDI' **15/09** — cio' che ha lead time esterno o sblocca il resto

| # | cosa | chi | perche' e' la prima settimana |
|---|---|---|---|
| **A1** | 📨 **INVIARE LE DOMANDE AI SUPPORTI PROP** (`report/DOMANDE_SUPPORTO_PROP.md`, pronte dal **13/08**, **mai inviate**) — e le due che pesano: **muro totale statico o trailing?** · **giornata su saldo o equity, e a che ora?** | 👤 **Claudio**, dalla sua email, risposta **SCRITTA** salvata in PDF | 🔴 **E' L'UNICA VOCE CON UN TEMPO DI RISPOSTA CHE NON CONTROLLIAMO NOI.** La **F4** congelata dice che senza risposte scritte **non si compra** |
| **A2** | 📁 **SCRIVERE IL `.set` DI `770202`** e, gia' che si fa, **i preset su file di TUTTE le sedie del conto challenge** — oggi le taglie 0,65/0,30 **vivono solo nei `.chr`** | 🤖 agenti scrivono · 👤 Claudio carica | 🟢 **Δ +1 sedia**, ed e' il delta piu' economico del piano |
| **A3** | 📖 **ATTRIBUIRE IL CONFLITTO DI DD DI `771531`** (R103 6,48 · R29 7,21 · R112 7,83) e **contare le posizioni IS** (i per-trade in archivio sono **solo OOS**) | 🤖 agenti, **sola lettura** | 🟢 **Δ +1 sedia** · chiude anche la classe 226 sulla candidata migliore |
| **A4** | ✍️ **FIRMA SULLA GEOMETRIA DELL'ORB DEL GIORNO 1** — OPPRANGE invece di HALFRANGE, sul **conto della challenge**, **senza toccare il reale 10105439** | 👤 **Claudio** | 🟢 **Δ +1 sedia** · **e −4,04 punti di DD** (9,7623 → 3,840 @1%) |
| **A5** | 🔧 **COMPILAZIONE R4** (F7 + ricarico, 15 sorgenti gia' corretti dall'08/09) | 👤 **Claudio** firma · 🔴 **MAI su `C:\BCM_Reale`** | **Δ +0 sedie**, ma **toglie rischio VERO da 3 sedie vive subito**: `770511` rischia **1,42% misurato** su un contratto da 1,0% |
| **A6** | 🔎 **`InpRiskMode` del Guardian** (`ABTG_Guardian.mq5:108`): il cap conta le **GAMBE VERE** o gli **input degli EA**? | 🤖 agenti, sola lettura, **costo zero** | cambia la conclusione di meta' §4 |
| **A7** | 🔎 **QUALE ALBERO COMPILA IL VPS**: `mql5/Experts/` o `mql5/Experts/standalone/`? | 👤 Claudio, **30 secondi**, sola lettura | 🔴 `standalone/ABTG_DAX_Apertura_EU.mq5:33` e' **ancora a `ABTG_DEF_RISK 2.0`**: se il VPS compilasse quella cartella, l'EA del **CONTO REALE** girerebbe **al doppio del rischio firmato**. Aperta da **tre censimenti** e **mai chiusa** |

## 🟧 ENTRO MARTEDI' **22/09** — le misure che rendono il 1° ottobre una decisione invece che una scommessa

| # | cosa | chi | cosa produce |
|---|---|---|---|
| **B1** | 📊 **DD FORWARD PER FAMIGLIA** (serie cumulata + massimo picco-valle dallo statement) | 🤖 agenti, zero MT5 | 🔴 oggi e' **`n/d` su 16 famiglie su 17**: senza, la corsia RISCHIO della C3 **non e' eseguibile** |
| **B2** | 📏 **`S*` DEL PAVIMENTO DEL LOTTO** sul conto challenge: `SYMBOL_VOLUME_MIN`, `VOLUME_STEP`, valore per punto | 👤 Claudio (`ABTG_SondaMargine`, **non tocca niente**) | chiude R4 su `771531` **per misura** invece che per monotonia |
| **B3** | 🧱 **CLUSTER + collaudo del tetto C10 3,0%** | 👤 Claudio firma l'insieme · 🤖 agenti collaudano | 🔴 **due delle tre del terzetto sono sullo stesso `U30USD`** |
| **B4** | 🧪 **R125** (firmato, ~7 min) e/o **R126** | 👤 **Claudio davanti al PC** — il runner e' sola lettura | **Δ +0 sedie per ottobre**; comprano misure per **dopo** |
| **B5** | 🕐 **MISURA DST**: `InpDailyResetHour=23` quando cambia l'ora EU (**dom 25/10**) e USA (**dom 01/11**) | 🤖 lettura sorgente · 👤 screenshot Market Watch + orologio Windows | 🔴 **cade DENTRO il primo mese di challenge** ed e' **il confine della giornata che la prop misura** |

## 🟨 ENTRO MARTEDI' **29/09** — si chiude, non si apre

| # | cosa | chi |
|---|---|---|
| **C1** | 🔢 **RINUMERARE I MAGIC** del conto challenge (oggi il 100k usa **gli stessi magic del piccolo**) | 🤖 blocco nuovo · 👤 applica |
| **C2** | ✍️ **QUANTE SEDIE E QUALI il giorno 1** · **quale prop** · **quale taglia** · **quale `InpDailyBaseline`** (equita'/saldo/max: si firma **quando** si sceglie la prop) | 👤 **Claudio, e solo lui** |
| **C3** | 🧾 **CONGELARE LA CONFIGURAZIONE DEL GIORNO 1** in **un solo file**: preset, magic, **orari in ora server BCM**, soglie Guardian, elenco sedie | 🤖 scrivono · 👤 firma |
| **C4** | 📸 **FOTO `.chr` FRESCA** di tutti e quattro i terminali + verdetto di freschezza (`CODA_05`) | 🤖 runner · 👤 dove serve |

## 🕐 GLI ORARI DEL TERZETTO — **in ora server BCM**, come vuole la regola di casa

| sedia | evento | **ora SERVER BCM** | ora **ITALIANA** | fonte |
|---|---|---|---|---|
| `770611` ORB Dow | range 15 min | **14:30 – 14:45** | 15:30 – 15:45 | `.set` reale — 🔴 **corretto dal cancello il 10/09**: il "14:25-14:30" del v1 e' la geometria di **`770601` NASUSD**, un'altra sedia (classe 197) |
| `770611` ORB Dow | flat | **21:00** | 22:00 | idem |
| `770202` Dow Apertura | apertura US, ora modale osservata | **15** (4 su 4 trade) | 16 | `trades_auto.csv` · 🔴 **nessun preset in repo** |
| `771531` EMA200 | ora modale | **17** (4 su 21, sparsa 01-21) | 18 | `trades_auto.csv`, n=21 |
| `771531` EMA200 | `InpCutoffHour` | **19** | 20 | CSV R112, `InpUseCutoff=1` |
| Guardian | `InpDailyResetHour` | **23** (= 00:00 CE**S**T) | 00:00 | B3, `FIRME_2026-08-18.md` |

🔴 **E il vincolo di calendario che cade dentro il primo mese:** l'ora legale
europea finisce **domenica 25/10/2026**, quella USA **domenica 01/11/2026**. La
riga B3 e' congelata con l'avvertenza *"resta [INCERTO] il comportamento
invernale/DST"*: fra quelle due domeniche **l'offset del server puo' cambiare, e
con lui l'ora del reset giornaliero** — cioe' **il confine della giornata che la
prop misura**. → **B5.**

---

# 6. ❌ LA LISTA ONESTA DI CIO' CHE AL 30/09 **NON** AVREMO — elencata PER NOME

> 🧪 **Contro-esempio applicato alla lista stessa (classe 180):** questa lista e'
> **per nome**, mai *"tutto cio' che non e' X"*. Se una cosa manca da qui, manca
> dalla lista, non dal mondo.

| # | cosa manchera' | perche' e' **impossibile**, non *"da fare"* | rischio residuo, in numeri |
|---:|---|---|---|
| 1 | **Una sola famiglia a 150 operazioni FORWARD** | `771531` a 1,55 op/g ci arriva in **97 giornate = fine gennaio 2027**. `770202` a 0,46 in **326 = agosto 2027** | il giudizio di MERITO resta **sospeso su tutta la squadra**: si parte con motori validati **in banco**, non **in campo** |
| 2 | **Il DD forward per famiglia** | ottenibile (B1), **ma solo se qualcuno lo calcola**: oggi e' `n/d` su **16 famiglie su 17** | la corsia RISCHIO della C3 **non e' eseguibile**. L'unica calcolata dice **7,36% contro 6,25% promesso = 1,18×** |
| 3 | **Una singola misura di slippaggio su CONTO VERO** | **0 deal** dal `SlippageLogger`; le due sedie del reale **non hanno mai eseguito** | ogni gradino di slippage di ogni round e' uno **SCENARIO ASSUNTO**. R109 misura **21,5 punti su uno stop reale** = perdita **doppia** |
| 4 | **La peggior giornata VERA (flottante incluso)** di 7 sedie su 8 | i CSV vedono i **chiusi**, il muro prop guarda l'**equity** | 🟢 **eccezione: `771531`** — R112 ha misurato **−2,45% fisso / −1,98% equity @1%** = **−1,59% / −1,29% @0,65%**. **E' l'unica del parco ad averla** |
| 5 | **La prova di regime ORSO** | 481 giornate di banco = **un solo regime, toro**; sugli indici BCM ha storia **solo dal 2024.09.26** | il 99,6% di pass-rate simulato descrive **un mercato che sale** |
| 6 | **Il feed del CONTO REALE 10105439 sondato** | tutte le letture (sonda, tick storici, commissioni) vengono **dal demo**; i 2 file di `sonda_storico_17-08/` sono **tutti e due del piccolo** | se il feed reale fosse piu' largo, **tutta la tabella di R5 e' ottimista** |
| 7 | **Lo spread al MINUTO dentro l'ora** | l'istogramma e' **orario**. Su U30USD l'ora 14 ha mediana **2,00** e **massimo 47,0** | le tre PostNews lavorano **sul rilascio della notizia**: i loro 21,9x/28,9x/26,8x sono **ottimisti per costruzione** |
| 8 | **Requote e rifiuti** | **[NON MISURABILE] dai tick**: il tick storico non contiene ordini rifiutati | — |
| 9 | **Il tetto per CLUSTER C10 attivo** | firmato 07/09 · implementato v1.13 **spento di default** · **non compilato, non collaudato** | due delle tre del terzetto sono su **`U30USD`**. **E' un'intenzione, non una protezione** |
| 10 | **La prop SCELTA e il suo regolamento verificato sul sito** | cancello 3 **rosso**. Il dossier `REGOLAMENTI_PROP_2026-09-08.md` e' **`[LETTO-VIA-SEARCH]`**: il proxy blocca i siti delle prop, **nessuna pagina aperta** | il preset Guardian e' tarato **solo su FTMO**. 🔴 **Se il muro totale fosse TRAILING, il p99 a 0,65% e' 12,05% > 10%: la taglia di casa NON reggerebbe**, e sarebbe una scoperta fatta **dopo** aver pagato |
| 11 | **La prova della TAGLIA sopra i 100k** | mai fatta. R109: il lotto sbatte su `VOLUME_MAX`=100 in **66 trade su 743 = 8,9%** | percentuali **non trasferibili** sopra 100k → **mitigato scegliendo 100k** |
| 12 | **L'`n` in POSIZIONI di 6 candidate su 8** | classe **226**, aperta oggi: il `n` dell'OPTFRAME conta i **deal di uscita** | ogni etichetta di merito del parco va riletta. **Fattore misurato 2,01 e 2,16 su R112** |
| 13 | **`InpTP1Pct` di `770511`/`970913` letto in POSIZIONI** | i loro per-trade **non sono in archivio** | il loro campione vero sta **fra ~57 e 227** e **fra ~39 e 155** |
| 14 | **Il default compilato delle PostNews a 1,30** | il pannello e' **stato di sessione**: a ogni `Resetta` torna **3.0** | e' gia' costato **80,90 EUR il 10/09**. ⛔ E `771201` e' a **13,2x contro il pavimento DURO 13,3x**: **la taglia la cambi, il pedaggio no** |
| 15 | **`ABTG_ImpulsoApertura` (769800)** | in **standby per decisione di Claudio** dall'08/09 | il file prova non e' scritto: **dieci minuti** quando arriva il via |

---

# 7. ✍️ COSA SERVE CHE FIRMI CLAUDIO — in ordine di **delta sedie**, non di rumore

| # | firma | Δ sedie | perche' e' sua e non mia | entro |
|---:|---|---:|---|---|
| 1 | **Geometria ORB del giorno 1: OPPRANGE** sul conto challenge | 🟢 **+1** | e' la configurazione che rischia, ed e' **−4,04 punti di DD**. 🔴 **Non tocca il reale 10105439** | **15/09** |
| 2 | **Spostare `771531` sul conto della challenge a 0,65%** *(dipende da A3)* | 🟢 **+1** | e' rischio e taglia | **15/09** |
| 3 | **Invio delle domande ai supporti prop** | +0 diretto · 🔴 **sblocca tutto il resto** | e' la sua email e la sua identita' verso la prop | **15/09** |
| 4 | **Compilazione R4** (F7 + ricarico, mai su `C:\BCM_Reale`) | **+0** | ricompilare **cambia il volume** delle sedie vive | **15/09** |
| 5 | **Default compilato PostNews da 3.0 a 1.30** | +0 | e' la taglia | **22/09** |
| 6 | **Insieme dei CLUSTER** per il tetto C10 | +0 · 🔴 **protegge il terzetto** | e' una scelta, non una misura | **22/09** |
| 7 | **Quale prop, quale taglia, quale `InpDailyBaseline`** | — | **sono soldi** | **29/09** |
| 8 | **Quante sedie e quali il giorno 1** | — | e' rischio, ed e' il suo conto | **29/09** |
| 9 | *(opzionale)* **allargare il perimetro del runner** ai round notturni | +0 per ottobre | vale **un round a notte senza che lui ci sia** | quando vuole |

> 🔵 **PROPOSTA DELL'ARCHITETTO-PROP, dichiarata come tale:** si parte il 1°
> ottobre **a 100k**, con **il terzetto a 5/5** (`770611`-OPPRANGE · `770202` ·
> `771531`) **a 0,65% ciascuna** = **1,95% di rischio aperto**, dentro il cap C1
> firmato (3,25%) e a **2,6× di margine** dal muro giornaliero. Le altre cinque
> entrano **a scaglioni**, una alla volta, **ognuna quando il suo requisito
> rotto e' chiuso**. 🔴 **Se al 30/09 manca la risposta scritta del supporto, la
> data slitta** — su FTMO **non c'e' limite di tempo**, quindi aspettare costa
> **zero**, mentre partire con un cancello finto costa **la fee piu' il tempo**.
> **Decide Claudio.**

---

# 8. 📮 COSA MANCA E CHI LO PORTA — le richieste agli altri agenti

| buco | 🎯 **chi lo porta** | la domanda **esatta** |
|---|---|---|
| L'`n` in **POSIZIONI** delle 8 candidate | **cacciatore-strategie** | *"Per ognuna delle 8, quante POSIZIONI distinte (`position_id`) ci sono nel CSV per-trade del round che le ha promosse? Se il per-trade non esiste, dillo per nome."* |
| Il conflitto di DD di `771531` (6,48 / 7,21 / 7,83) | **cacciatore-strategie** | *"Le tre misure hanno finestra, deposito, rischio e modello diversi? Quale delle tre descrive la cella che girerebbe il 1° ottobre?"* |
| ✅ 🆕 **CHIUSO 11/09** — ~~Il conflitto di DD di `770101` (6,89 vs 4,35)~~ | **cacciatore-strategie** | *"R83 e R119 differiscono per finestra, split o trailing 410? Qual e' il DD della cella VIVA?"* → 🔴 **RISPOSTA: NO a tutte e tre** (finestra, split e `InpTrailFixedPts=410` sono **identici**); la differenza e' **`InpAllowShort`**. **DD della cella VIVA = 4,3501% @0,65%**, ⚠️ **[MISURATO a deposito 10.000 EUR]** — su banco **100.000 EUR** e' **[NON MISURATO]** (+7,8% misurato sul solo effetto deposito: 7,2328% contro 6,7111% a parita' di 270 operazioni). 📄 `report/CONFLITTO_DD_770101_2026-09-11.md` |
| I muri della prop: **statico o trailing**, **saldo o equity** | 👤 **Claudio** (il proxy blocca i siti prop) | *"Apri la pagina FTMO 2-Step e leggi due righe: max drawdown statico o trailing? Daily loss su balance o equity, e a che ora si azzera?"* — `report/DOMANDE_SUPPORTO_PROP.md` |
| Quale albero compila il VPS | 👤 **Claudio**, 30 secondi | *"In MetaEditor sul VPS, il Navigatore punta a `mql5/Experts/` o a `mql5/Experts/standalone/`?"* |
| Spread di `225JPY` alle **h01-h07** (cash Tokyo APERTO) | **cacciatore-config-prop** | tranche **T1** del collaudo (`-Simboli 225JPY -PuntiPerIndice 1`): sblocca `770901`, `770924`, `774101`, `772235`, e il verso e' **a favore** |
| Regole prop verificate sul **sito ufficiale** | **analista-trascrizioni** / 👤 Claudio | fa fede `DOMANDE_SUPPORTO_PROP.md` **+ la risposta scritta del supporto**: senza, **non si compra** |

---

## 📚 FONTI DI QUESTO DOCUMENTO — tutte sul branch `lavoro`, tutte lette per intero

**🥇 MISURATO DA NOI (rango 1):**
`backtest_pipeline/prove/COLLAUDO_SPREAD_FLOTTA_CRITERI.md` (11/09, commissione) ·
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` (R5, 52 sedie) ·
`report/PACCHETTO_R4_DA_FIRMARE_2026-09-11.md` (il ricalcolo 2→2 / 2→4) ·
`backtest_pipeline/risultati_archivio/R112_CORSA_20260826/*.csv` + `R112_REFERTO.md` (771531, tick reali, G0-B) ·
`backtest_pipeline/risultati_archivio/REFERTO_ROUND29_EMA200_WF.md` (30/30 PASS) ·
`backtest_pipeline/risultati_archivio/R103_REFERTO_BLOCCO1_INDICI.md` 🔴 *(finestra UNICA: **non** chiude la 224)* ·
`report/CENSIMENTO_CONTRATTI.md` · `report/CENSIMENTO_RISCHIO_VERO_2026-09-10.md` ·
`data/statements/trades_auto.csv` · `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260911_033002.log` ·
`backtest_pipeline/risultati_archivio/SuperWave/valid_SuperWaveRT_U30USD_H1_realtick.csv` ·
`backtest_pipeline/risultati_archivio/ritardo_r119_csv/*.csv`

**🥈 CRITERI FIRMATI:** `backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md` (**FIRMATO 10/09**) ·
`backtest_pipeline/prove/R126_SUPERWAVE_COSTO_CRITERI.md` (**NON firmato**) ·
`report/FIRME_2026-08-18.md` · `FIRME_2026-09-02.md` · `FIRME_2026-09-07.md`

**🥉 REGOLE PROP:** `docs/REGOLAMENTO_FTMO_2026-08.md` ·
`report/REGOLAMENTI_PROP_2026-09-08.md` 🔴 **`[LETTO-VIA-SEARCH]`, nessuna pagina aperta** ·
`report/DOMANDE_SUPPORTO_PROP.md` ⏸️ **mai inviate**

**Memoria dei difetti:** `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` classi **224**, **225**, 🆕 **226**

> **Se un referto e questo piano divergono, comanda il referto.**

---

## 📜 CHANGELOG

| data | versione | cosa cambia | perche' |
|---|---|---|---|
| **08/09/2026** | **v1** | prima stesura, costruita all'indietro dal 1° ottobre. 4 requisiti, 8 candidate, *"ne passa UNO"*, *"realistico per COMPRARE"* | c'era una data, e una data cambia l'ordine delle cose |
| **11/09/2026** | **v2** *(questo file)* | 🔴 **aggiunto R5, il cancello del costo all-in** → le candidate che passano tutto diventano **ZERO** · 🔴 corrette **due etichette MERITO PIENO false** (classe 224) · 🔴 corretto il **"da 2 a 5"** in **2→2 / 2→4** · 🆕 aperta la **classe 226** (`n` = deal, non posizioni: fattore misurato **2,01**) · 🆕 **`771531` promossa a prima candidata** sui numeri di **R112** (OOS **257 posizioni**, tick, G0-B al centesimo) e dichiarata **fuori dal conto della challenge** · 🆕 **delta sedie per azione**, calcolato **sedia per sedia** · 🆕 il conto **1 sana vs 4 che promettono**, con i numeri · 🆕 la lista di cio' che manchera', **per nome** | 🔴 **la frase "il 1° ottobre e' realistico per COMPRARE" e' CADUTA**: oggi le sedie che passano i criteri di casa sono **zero**. Regge solo **condizionata a tre azioni nominate** — e nessuna delle tre e' un round |
