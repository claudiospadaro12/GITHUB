# 🧪 R183 — LA CROCE DELLE SLIDE: la conferma di VOLUME sull'ingresso a CHIUSURA (NASUSD)

_Criteri congelati il **18/09/2026**, **PRIMA di qualunque numero di questo round**.
Chi legge la tabella dei risultati deve aver letto prima questo file._

> 🎯 **LA DOMANDA, UNA SOLA:**
> **«La conferma di VOLUME che le slide chiedono, attaccata all'ingresso che le slide
> prescrivono (MARKET alla CHIUSURA della candela di rottura), AGGIUNGE edge sul
> Nasdaq — o TAGLIA e basta?»**

🚫 **QUESTO ROUND NON RIACCENDE NIENTE.** La sedia `770201` resta **SPENTA** e
🔴 **[SENZA CONTRATTO]** (PF 0,82 · DD 17% · 19/20 celle OOS negative — FIRMA 5 del
18/08). R183 **misura e basta**: non propone taglie, non propone accensioni, non tocca
il forward, non tocca il conto reale `10105439`, non tocca il codice di nessun EA.

---

## 1. 🔍 PERCHÉ ESISTE: la casella è vuota, e l'ho verificato meccanicamente

Il referto `report/LE_SLIDE_NASDAQ_LA_CROCE_MAI_GIRATA_2026-09-18.md` sostiene che la
casella «ingresso a chiusura + filtri accesi» non è mai stata girata. **Non l'ho preso
per buono: l'ho ricontato.**

Censimento su **tutti** i CSV del repo (esclusi i worktree `.claude`):
**2.402 file, di cui 368 con la colonna `InpEntryMode`, per 18.410 righe di risultato.**

**Risultato, su NASUSD:**

| InpEntryMode | righe con ≥1 filtro acceso |
|---|---:|
| **0 (breakout)** | **610** |
| 1 · 2 · 3 · 4 · 5 | **0** |

Le righe NASUSD con ingresso a **CHIUSURA** (`InpEntryMode=2` di
`ABTG_Apertura_3Ingressi`) sono **8 in tutto, tutte a filtri spenti**.
👉 **La casella è VUOTA. Confermato.**

### 1.1 ⚠️ MA IL CENSIMENTO HA TROVATO ANCHE QUELLO CHE IL REFERTO NON CITAVA

Il primo giro del mio censimento dava «croce vuota» **anche perché sbagliava**: deduceva
il simbolo dal percorso e **saltava 73 file** che il simbolo nel nome non ce l'hanno —
fra cui i `Walkforward_Aperture/NASDAQ_*`. Rifatto **senza nessun filtro di simbolo né
di famiglia**, elencando per nome ogni riga con `InpEntryMode ∉ {0,1}`, sono usciti **due
archivi che il referto non nomina** e che **cambiano l'attesa di questo round**:

**(a)** `risultati_archivio/Openconfirm/NASDAQ_openconfirm_M15.csv` — 96 passate,
**9 esiti distinti** (manopola inerte: `InpTrailFixedPts` spazzolata su 8 valori senza
mordere), core `ABTG_Nasdaq_Apertura_US`, magic `770201`, finestra piena 2024.01→2026.06:

| motore | volumi OFF | volumi ON |
|---|---|---|
| OPENCONFIRM (5) | PF 0,868 · n=431 | PF 0,955 · n=403 |
| DELAYED (4) | PF 0,909 · n=204 | PF **1,200** · n=**99** |

**(b)** `risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` — **ed è
il dato che pesa di più**, perché è l'unico con un taglio IS/OOS:

| motore | volumi | IS PF · n | OOS PF · n |
|---|---|---|---|
| OPENCONFIRM (5) | OFF | 1,107 · 178 | 0,927 · 240 |
| OPENCONFIRM (5) | **ON** | **1,816** · 108 | **0,956** · 104 |
| DELAYED (4) | **ON** | **1,710** · 56 | **0,696** · 51 |
| RETEST (2, enum del core) | **ON** | 1,145 · 91 | 1,109 · 94 |

> 🔴 **Tre casi su tre: la conferma di volume su un ingresso confermato sul Nasdaq
> produce un IS bellissimo, un OOS che non regge, e un campione DIMEZZATO
> (240→104, 247→51, 240→94).** Quella è la firma del SOVRA-FILTRO, ed è **già
> misurata**. R183 parte con questa ipotesi come la **più probabile**, non come la
> meno probabile.

⚠️ **E i due enum NON si confondono** (è il difetto che questo paragrafo evita):
`ABTG_Apertura_3Ingressi` ha `0=STOP · 1=LIMIT/retest · 2=CLOSECONF`;
`ABTG_Nasdaq_Apertura_US` ha `0=BREAKOUT · 1=GAPFILL · 2=RETEST · 3=RANGE_FADE ·
4=DELAYED · 5=OPENCONFIRM` (sorgente r.149-157, mappatura ricontrollata contro i numeri
di `Openconfirm/MOTORI_INGRESSO.md`). **`InpEntryMode=2` vuol dire due cose diverse nei
due EA.** Nessuna riga di quegli archivi è l'ingresso a CHIUSURA: **CLOSECONF non esiste
nel core**, è codice che vive solo in `ABTG_Apertura_3Ingressi` (FIRMA 6).

---

## 2. 🔧 DUE MANOPOLE SONO **INERTI** SU QUESTO INGRESSO — verificato nel sorgente

Il compito chiedeva di mettere ad asse anche **ATR ON/OFF** e **`InpConfirmMode` OR/AND**.
🔴 **Non si può, e non perché sia difficile: perché quelle passate uscirebbero IDENTICHE.**

In `mql5/Experts/ABTG_Apertura_3Ingressi.mq5`:
- `InpUseAtrFilter` e `InpConfirmMode` vivono **solo** dentro `ConfirmOK()` (r.2518-2526);
- `ConfirmOK()` è chiamata in **quattro** punti: r.1116 `TryPlaceBreakout`, r.1208
  `TryPlaceRangeFade`, r.1314 `TryPlaceDelayed`, r.1764 gap fill;
- il ramo CLOSECONFIRM **non è nessuno di quei quattro**: `MonitorCloseConfirm()`
  (r.1576) chiama `VolumeOKtf(cftf)` a **r.1594** e nient'altro.

👉 Su `InpEntryMode=2`: **l'ATR non viene mai letto, `InpConfirmMode` non viene mai letto.**

Sul claim «`InpConfirmMode` è inerte con meno di due filtri accesi, riga 2410»:
✅ **verificato e vero**, ed è r.**2410** di `ABTG_Nasdaq_Apertura_US.mq5` (r.**2525** in
`ABTG_Apertura_3Ingressi.mq5`) — l'unica riga che lo legge, raggiungibile solo quando
**entrambi** i filtri sono accesi. 🔴 **Ma su CLOSECONF la manopola è inerte per un
motivo PIÙ FORTE: quella riga non viene raggiunta mai, nemmeno con tutti e due i filtri
accesi.** Metterla ad asse qui produrrebbe la patologia delle **874 CSV a esito
identico** del censimento 09/09: manopole girate senza che mordessero.

### 2.1 ✅ Quello che invece MORDE su CLOSECONF (verificato, non assunto)
| manopola | morde? | dove |
|---|---|---|
| `InpUseVolumeFilter` · `InpVolMult` · `InpVolAvgBars` | ✅ SÌ | `VolumeOKtf` r.1594 |
| `InpUseEmaFilter` · `InpUseSupertrend` · `InpUseSupertrend3` · `InpUseCorrelation` · `InpUseVwapFilter` | ✅ SÌ | `TrendBias()` → `gBias` all'arming (`ArmCloseConfirm`) |
| `InpUseAtrFilter` · `InpConfirmMode` | ❌ **NO** | `ConfirmOK()` mai chiamata su questo ramo |

**Conseguenza sul disegno del round:** R183 mette ad asse **la sola metà che esiste**,
cioè la conferma di **VOLUME**. I filtri di trend **non entrano**: non sono la regola
delle slide (che chiede *volumi o ATR*), e accenderli qui misurerebbe due cose insieme —
lo stesso errore che R83 e R84 si erano dati la regola di non fare.

---

## 3. 📋 LE CELLE — 11 celle, 22 passate

| file | asse (UNA variabile) | celle | magic |
|---|---|---:|---|
| `R183a_volmult_closeconf_NASUSD.txt` | `InpVolMult` 1,00 / 1,25 / **1,50** / 1,75 / 2,00 | 5 | `779350` |
| `R183b_volavgbars_closeconf_NASUSD.txt` | `InpVolAvgBars` 10 / **20** / 30 / 40 | 4 | `779360` |
| `R183c_canarino_baseline_NASUSD.txt` | `InpMagic` (asse **tecnico**, gemelli) | 2 | `779370` · `779371` |

**In grassetto il valore DA DOCUMENTO** (`R84_ABLAZIONE_CRITERI.md` §1: *«volumi ×1,5 su
20 barre»*). Sta al **centro** della griglia apposta: un altopiano si legge solo se si
hanno celle da tutte e due le parti.

🔎 **I magic sono VERGINI**, cercati col grep, comando dichiarato:
```
grep -rnoE --exclude-dir=.git --exclude-dir=.claude "7793[5-9][0-9]" .
→ 0 occorrenze (banda 779350-779399 libera)
```
✅ E non collidono con i round che **altri due agenti** stavano scrivendo nella stessa ora:
`R180u*` (duello ingressi sul Dow, magic `7774xx`/`7779xx`) e `R181_SONDA_SPXUSD` (che
riserva anche `R182s*`). Verificato **tre volte**, l'ultima subito prima del commit: è il
motivo per cui questo round si chiama **R183**. ⚠️ Con più agenti in parallelo **il numero
di round è una risorsa condivisa**: si rilegge `ls prove/` *immediatamente prima* di
committare, non solo quando si comincia.

### 3.1 🔒 Le condizioni sono quelle di R83/R84, e non «più o meno»
Il corpo dei tre file prova è stato **estratto meccanicamente** da
`prove/R83n2_conferma_NASUSD.txt` (78 righe `@`/`Inp`) e modificato **solo** nelle righe
dell'asse e del magic, con un'asserzione che pretende **esattamente 1 sostituzione** per
riga toccata. Quindi: `NASUSD` · `M15` · `@DAQUANDO 2024.09.26` · sessione 14:30 server ·
range 15' · buffer 200 · `InpRangeMode=2` · `InpLevelTF=H1` · `InpOCTimeframe=0`
(=M15) · rischio 1% · TP1 1R 50% · BE · trailing base candela M1 · slippage 0.
**Modello 4 (tick reali), taglio IS/OOS al default 0,40** — gli stessi di R83n2, che a
0,40 dà IS n=198 / OOS n=313 (rapporto 0,387 ✓).

### 3.2 ⚠️ Il limite della finestra, dichiarato accanto ai numeri, sempre
- **Un regime e mezzo.** Niente 2020, niente 2022 → R183 **non misura** la robustezza di
  regime (Emendamento della finestra, punto C).
- **I TICK REALI degli INDICI a BCM non sono mai stati misurati in profondità**
  (difetto n.18, PASSO 0 di `R84_ABLAZIONE_CRITERI.md` §3.1). Il `2024.09.26` è la
  profondità delle **BARRE**. Se i tick partono dopo, **la finestra va riscritta e questi
  criteri con lei**.
- **Un numero OHLC non sarebbe un verdetto**: qui si gira a **tick reali, modello 4**.
  Se per qualsiasi motivo si girasse a modello 1, **il round è screening, non verdetto**.

---

## 4. 📊 L'ATTESA, DICHIARATA PRIMA DEI NUMERI (e da dove la ricavo)

**Baseline da battere** — `R83n2`, stesso EA, stesso file, filtri spenti:
**IS PF 0,70462 · n=198 · DD 9,4841** | **OOS PF 0,97849 · n=313 · DD 6,1775**

| grandezza | attesa | perché |
|---|---|---|
| **n OOS** a `InpVolMult=1,50` | **110 – 175** | i tre casi walk-forward di §1.1 tagliano il campione del 47-79%; su 313 → 65-165. Il CLOSECONF valuta la conferma sulla **stessa barra M15 che ha chiuso oltre**, quindi mi aspetto un taglio verso l'estremo **meno** severo |
| **n OOS** a `InpVolMult=1,00` | **> 250** | soglia ≈ media: passa circa metà-due terzi delle barre |
| **PF OOS** migliore cella | **1,00 – 1,10** | su breakout (R84) i volumi hanno portato l'OOS da 0,873 a 0,950; su OPENCONFIRM da 0,927 a 0,956; su RETEST a 1,109. **Nessuno dei precedenti misurati supera 1,11** |
| **PF IS** migliore cella | **1,10 – 1,85** | ed è **il numero di cui NON mi fido**: è esattamente lì che i precedenti mentono (OPENCONFIRM IS 1,816 → OOS 0,956) |
| **DD OOS** | **≤ 6,18%** (non peggiora) | in tutti e cinque i precedenti misurati il filtro volumi **abbassa** il DD |

🎯 **La mia previsione onesta, scritta prima**: **il round finirà con «sovra-filtro» o
con «il default nudo va bene uguale».** Probabilità che esca una cella con
**PF OOS ≥ 1,10 E n ≥ 150**: **bassa.** Lo scrivo adesso così non posso raccontarmelo
dopo. **E il round vale lo stesso i suoi ~5 minuti**, perché oggi quella frase è
un'**ipotesi** e domani è una **misura** — e perché la sensibilità a `InpVolMult` sul
Nasdaq **non esiste in archivio** (`R84BIS_B1/B2` la preparava il 18/08 e **non è mai
stata girata**: zero CSV nel repo).

---

## 5. 🚦 LE SOGLIE, CONGELATE PRIMA — cosa fa scartare, col numero

1. 🔴 **PAVIMENTO DI CAMPIONE: `n OOS ≥ 150`.** Sotto, il **MERITO è sospeso**
   (Emendamento A). Una cella con PF 1,40 e n=70 **non è un risultato**: si scrive
   *«campione insufficiente»*. Il **RISCHIO** (DD) si legge comunque, a qualunque n
   (Emendamento B).
2. 🔴 **ANTI-SOVRA-FILTRO: una cella conta solo se `n OOS ≥ 157`** (= 50% dei 313 della
   baseline). Se PF sale **e** n scende sotto metà → verdetto **«sovra-filtro»**, mai
   «scoperta».
3. 📐 **ALTOPIANO, MAI IL PICCO.** La cella si sceglie come **CENTRO di almeno TRE celle
   contigue** di `InpVolMult` che passano (1) e (2). **Se una cella sporge e le due
   vicine no → «non c'è una configurazione robusta»**, e il round finisce lì.
   *(Con 5 celle, un altopiano di 3 è il minimo leggibile: è il motivo per cui le celle
   sono 5 e non 2.)*
4. **SEGNO NON RIBALTATO fra IS e OOS** (criterio già di R83, §: *«segno non ribaltato,
   DD non peggiore di 1 punto»*). Ribaltato → la cella non si legge.
5. **DD**: nessuna cella con **DD OOS > 6,18%** può essere dichiarata migliore della
   baseline, nemmeno con un PF più alto.
6. 🔁 **CONFRONTO COL DEFAULT, OBBLIGATORIO.** Se il miglior altopiano sta entro
   **±0,05** di PF OOS 0,978 → si scrive **«i filtri non aggiungono: la baseline nuda va
   bene uguale»**. ✅ **È un risultato, non un fallimento.**
7. **CANCELLO G1 (`R183c`)**: se le due gemelle non escono identiche, **o** se non
   riproducono R83n2 al centesimo, **ci si FERMA** e nessun numero di `R183a`/`R183b` si
   legge. Non si «aggiusta» la baseline.
8. 🚫 **E qualunque cosa esca, R183 NON PROMUOVE.** 21 mesi e un regime e mezzo non
   bastano (Emendamento C). Una cella che passasse tutto sarebbe un **candidato a una
   prova di regime**, non una sedia.

---

## 6. 🕵️ IL CONTRO-ESEMPIO — che cosa vedrei se i filtri **tagliassero** invece di aggiungere

🔴 **È l'ipotesi PIÙ probabile, non la meno.** Le due spiegazioni vanno distinte **prima**,
altrimenti il numero non vuol dire niente. Ecco le due firme, e sono distinguibili:

| | **il filtro AGGIUNGE edge** | **il filtro TAGLIA e basta** |
|---|---|---|
| PF lungo l'asse `InpVolMult` | sale, poi **si stabilizza su un altopiano**: c'è un **ottimo interno** | sale **monotonicamente** fino all'ultima cella: nessun ottimo interno |
| `n` | scende **poco** (toglieva perdenti) | scende **monotonicamente e molto**, in proporzione al guadagno di PF |
| IS vs OOS | il guadagno regge **su tutte e due** | l'IS esplode, **l'OOS no** |
| payoff atteso per operazione | sale | ~fermo: si sta solo campionando meno |

🔢 **IL NUMERO CHE FA DA MODELLO AL SOVRA-FILTRO, ed è già misurato in casa:**
`DELAYED + volumi` su NASUSD — **IS PF 1,710 con n=56 → OOS PF 0,696 con n=51**
(`Walkforward_Aperture/NASDAQ_B_motore_*.csv`). E il suo gemello sulla finestra piena:
PF 1,200 con n=99 contro 0,909 con n=204, cioè **PF sopra 1 comprato dimezzando il
campione**.
👉 **Se R183 riproduce QUELLA firma, il verdetto è «sovra-filtro», NON «il metodo del
corso funziona».** Anche — e soprattutto — se il PF è bello.

🧪 **Il test è quantitativo e si applica meccanicamente**, non a occhio:
- **monotonia**: se PF(1,00) < PF(1,25) < PF(1,50) < PF(1,75) < PF(2,00) **e**
  n(1,00) > n(1,25) > … > n(2,00) senza nessun ottimo interno → **taglio**, e si scrive
  «taglio», qualunque sia il PF finale;
- **efficienza del taglio**: se `ΔPF / Δ(-n)` è ~costante lungo l'asse, il filtro sta
  solo **rimuovendo campione**, non **selezionando**. Un filtro che seleziona ha un
  punto dove smette di pagare.

⚠️ **E il contro-esempio vale anche contro di me**: `R183b` esiste apposta per provare a
rompere un eventuale risultato di `R183a`. Se la conferma di volume «funziona» solo con
`InpVolAvgBars=20` e non con 10/30/40, **non è una conferma di volume: è una
coincidenza su una lunghezza di media.**

---

## 7. 🕳️ I BUCHI, DICHIARATI

1. 🔴 **La metà ATR della regola delle slide NON è misurabile con il codice di oggi** su
   questo ingresso (§2). Servirebbe **una riga** in `MonitorCloseConfirm()`
   (`VolumeOKtf(cftf)` → `ConfirmOK()`), e con lei tornerebbero vive **anche
   `InpConfirmMode` OR/AND**. 🚫 **Questo round NON la scrive** (vincolo: non si toccano
   gli EA). 👉 **Va chiesta a Claudio come round separato** — è la differenza fra
   misurare *metà* della regola del corso e misurarla *tutta*.
2. **La regola delle slide è «volumi **O** ATR»**: R183 misura **solo il primo ramo**.
   Un esito negativo di R183 **non chiude** la domanda delle slide, la dimezza. Va detto
   in ogni riga di consegna.
3. **Il terzo pezzo delle slide — la size frazionata** (*«divido la size»*) — non esiste
   nel codice delle aperture. Fuori da R183.
4. **Profondità dei TICK degli indici**: mai misurata (§3.2). È il PASSO 0, e resta
   aperto anche per questo round.
5. **Un regime e mezzo**: nessun 2020, nessun 2022.

---

## 8. 💰 IL COSTO IN TEMPO MACCHINA — **stima**, con la base dichiarata

**11 celle × 2 finestre (IS + OOS) = 22 passate MT5**, più **6 avvii di MT5**
(3 file prova × 2 finestre).

**Base della stima** (misure vere del repo, `report/CODA_NOTTE_2_2026-09-12.md` r.292-294):
- `R88a`: **96 passate in 8,0 min → 0,083 min/passata** (tick reali, M5, 21 mesi);
- `R112`: **0,375 min/passata** sullo stesso EA/simbolo/finestra/modello, **ma con gambe
  separate** (l'avvio di MT5 pesa più della corsa).

**R183 gira su M15**, cioè **un terzo delle barre di M5** sulla stessa finestra, ma con
**6 gambe**: il costo è dominato dagli avvii, non dalle barre.

> 💰 **STIMA: 2 – 9 minuti macchina** (banda onesta: 22 × 0,083 = **1,8 min** all'estremo
> basso; 22 × 0,375 = **8,3 min** all'estremo alto, più gli avvii).
> ⚠️ **È una stima, non una misura**: il tempo vero di R183 **[NON MISURATO]** finché non
> gira. Se la corsa sfora i 15 minuti, **c'è qualcosa che non va** (probabile: tick non
> in cache, e allora la prima gamba paga il download).

**Dove gira**: sul **PC di BACKTEST**, mai sul VPS. 🚫 **Questo file non contiene e non
autorizza nessuna riga di lancio**: la riga la scrive chi la lancia, e passa dal cancello
(`controlla_riga.py` + agente `controllo-preventivo`) **prima** di uscire.

---

## 9. 📐 COME SI LEGGE IL RISULTATO — l'ordine è vincolante

1. **`R183c` per primo.** Non passa → si ferma tutto, non si legge altro.
2. **`R183a`**, applicando nell'ordine: pavimento `n≥150` → anti-sovra-filtro `n≥157` →
   altopiano di 3 → segno IS/OOS → DD.
3. **`R183b`** come prova di rottura del risultato di `R183a`.
4. **Confronto col default** (soglia 6), **obbligatorio**, anche se il risultato è bello.
5. Il verdetto si scrive **con la regola di selezione accanto al numero**. Un PF senza la
   regola che ha scelto la cella **non vuol dire niente**.

---
*Fonti: censimento su 368 CSV / 18.410 righe (18/09/2026) ·
`mql5/Experts/ABTG_Apertura_3Ingressi.mq5` r.1116/1208/1314/1576/1594/1764/2518-2526 ·
`mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` r.149-157/2403-2410 ·
`backtest_pipeline/risultati_archivio/r83_csv/` · `r84_csv/` ·
`risultati_archivio/Openconfirm/{NASDAQ_openconfirm_M15.csv, MOTORI_INGRESSO.md}` ·
`risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` ·
`prove/R84_ABLAZIONE_CRITERI.md` · `report/CODA_NOTTE_2_2026-09-12.md` r.292-294.*
