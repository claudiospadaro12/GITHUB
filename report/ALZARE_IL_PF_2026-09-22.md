# 📈 ALZARE IL PF DELLE SEDIE CHE VOLANO — l'archivio prima del tester

**22/09/2026** · branch `lavoro` · 🛑 **SOLA LETTURA E SOLA PREPARAZIONE**
Nessun round lanciato, nessun EA toccato, nessun preset in campo modificato, nessuna
taglia e nessun rischio proposti (sono **firma di Claudio**). Niente sul conto reale
**10105439**.

> ## 🗣️ LA RICHIESTA DI CLAUDIO, testuale
> *«Dobbiamo alzare i profit factor dei nostri EA attuali. Trovate il modo x farlo.»*

---

# 0️⃣ LE SEI RIGHE CHE CONTANO

1. 🥇 **La proposta #1 è a COSTO ZERO di tempo macchina e regge il contro-esempio più
   cattivo che esista su questa misura**: `770101` `InpTP1_ClosePct` **50 → 0**.
   PF OOS **1,39709 → 1,49140**, DD **7,2328% → 6,2719%**, e — misurato oggi, contando
   i `position_id` — **le 193 GIORNATE di operazione sono LE STESSE, insieme per
   insieme**. Il preset FTMO porta ancora `50` (r.273).
2. 🔬 **Il controllo che il committente ha chiesto con cattiveria — «col parziale il PF
   sui DEAL si gonfia» — l'ho FATTO, e la proposta NON ne dipende.** Ricalcolato il PF
   **sulle POSIZIONI**: la cella viva fa **1,39728** (contro 1,39709 sui deal:
   **+0,00019**). Il confronto 1,397 → 1,491 è **lecito**, e lo è anche su
   **profitto** (+30,9%) e **Recovery Factor** (2,029 → 2,961).
3. 🔴 **E il difetto che ho trovato provando a romperla, e che va detto**: in OOS il
   vantaggio di **profitto** è portato dalle **TRE GIORNATE MIGLIORI su 193**
   (togliendole la differenza è **−1,50 €**). Non lo nascondo e non lo uso per bocciare:
   §2.5 mostra che lo **stesso strumento boccerebbe anche la sedia stessa**, e che il
   discriminante vero è **la seconda finestra**, che concorda.
4. 🥈 **La proposta #2 vale più PF di tutte ma si paga in frequenza**: `771531`
   `InpAllowLong` **1 → 0** (solo short). PF OOS **1,52365 → 1,89147**, DD
   **7,8323% → 2,6628%**, e **PF e DD migliorano in TUTTE E DUE le finestre**. Costo:
   **257 → 140 posizioni contate**, frequenza **0,931 → 0,507 op/g**, profitto −27%.
5. 🚫 **Tre candidati che sembravano oro e che ho ucciso col numero**: il trailing
   `M5 → M2` del DAX (in **IS è la cella PEGGIORE dell'asse**), `InpRangeMinutes 35 → 45`
   sul Dow (**picco OOS, IS in perdita**), `InpTP1_ClosePct 50 → 0` **sul Dow** (stessa
   manopola della #1, **segno opposto**). E su `EMA200` il parziale è quasi **inerte** fra
   25/50/75 e **catastrofico a 0** (DD 13,94%): **«il default va bene» è un risultato.**
6. 📦 **Due file prova pronti**, già passati da `controlla_prova.py` (**ESITO: OK**),
   che chiudono due caselle oggi **vuote**, 10 passate l'uno.

---

# 1️⃣ ⚖️ LE UNITÀ DI MISURA, dichiarate PRIMA dei numeri

| cosa | come si legge qui |
|---|---|
| **`n`** | la colonna `Trades` dell'OPTFRAME conta i **DEAL DI USCITA**. Dove scrivo *posizioni* ho **contato i `position_id`** nel per-trade e lo dico. Dove non ho potuto, scrivo `[NON MISURATO]` e la forbice |
| **PF** | del tester = somma **sui deal**. 🔴 Due celle si confrontano sul PF **solo a parità di `InpTP1_ClosePct`**. Dove il regime cambia (la proposta #1!) ho **ricalcolato il PF sulle posizioni** dal per-trade, e porto anche **profitto** e **Recovery Factor** |
| **DD** | `Equity DD %` del tester, **sempre col deposito**. `tick` = Modello 4 · `OHLC` = Modello 1 = **limite INFERIORE**, mai un permesso |
| **rischio** | 🔴 **tutti i CSV d'archivio girano a `InpRiskPercent=1`**, i preset FTMO a **2,00**. I DD qui **non sono i DD che vedrà FTMO**: servono a confrontare due celle fra loro |
| **banda di rumore d'esecuzione** | **10,5% RELATIVO**, e viene dal campo: il 22/09 il primo stop vero della challenge è stato riempito **7,83 punti oltre** il livello e la perdita reale ha superato il modello del **+10,5%** (`report/PRIMO_STOP_FTMO_2026-09-22.md`, §2). ⚠️ **`n = 1`: è un campione, non un tasso** — lo uso come **soglia di prudenza**, non come fattore |
| **frequenza** | posizioni ÷ giorni di borsa. OOS `walkforward_generico` 2025.06.10→2026.06.30 = **276 gg**. Pavimento **1,00 op/g per FAMIGLIA** (firma 07/09) |

### 🔬 Come ho cercato
Indicizzate **62.367 righe** con colonne `Inp*` da **2.208 CSV** di
`backtest_pipeline/` (tutti quelli con la colonna `Profit Factor`). Per ognuna delle
sei sedie ho preso la riga della **cella di contratto** (`report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`
r.61-72) e ho tenuto **solo le righe con la STESSA firma di colonne** (stessa versione
dell'EA) che differiscono in **UNA sola** manopola non cosmetica
(`InpMagic`/`InpComment`/`InpRiskPercent`/`InpVerbose`/`InpLogImbuto`/`InpUsaGuardian`
esclusi dal confronto di identità). Poi **ogni** candidato è stato riletto **in tutte e
due le finestre**, che è il filtro che ne ha uccisi tre su cinque.

🟢 **E parto dichiarando su quali spalle sto**: `report/CELLE_MIGLIORI_GIA_MISURATE_2026-09-21.md`
(ieri) ha già fatto questa caccia. **Confermo i suoi due candidati principali** e aggiungo
quello che lì non c'era: **il ricalcolo del PF sulle posizioni**, la **prova che le entrate
non cambiano**, il **test della coda**, il **costo d'esecuzione applicato**, l'effetto sulla
**frequenza**, e la lettura per **lato** della `771531`.

---

# 2️⃣ 🥇 PROPOSTA #1 — `770101` `InpTP1_ClosePct` **50 → 0** · COSTO ZERO

## 2.1 I numeri, e sono riprodotti TRE volte

| finestra | cella VIVA (`50`) | cella proposta (`0`) | delta |
|---|---|---|---|
| **IS** 2024.09.26→2025.06.09 | PF **1,12634** · DD **5,4362%** · +3.789,36 · RF 0,64484 · **132 posizioni** | PF **1,18323** · DD **4,9576%** · +5.569,37 · RF 1,02362 · **132 posizioni** | PF **+5,1%** · DD **−8,8%** · profitto **+47,0%** |
| **OOS** 2025.06.10→2026.06.30 | PF **1,39709** · DD **7,2328%** · +18.029,58 · RF 2,02903 · **193 posizioni** | PF **1,49140** · DD **6,2719%** · +23.607,28 · RF 2,96058 · **193 posizioni** | PF **+6,7%** · DD **−13,3%** · profitto **+30,9%** |

**Peggior giornata**: `−1,0780%` → `−1,0793%` (invariata) — il muro giornaliero FTMO
(5,00%) non è toccato.

**Fonti, file e riga** (banco: **tick reali**, deposito **100.000**, rischio **1,00**):
- `backtest_pipeline/risultati_prove/aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_OOS_r47a.csv` **r.2** (viva) contro `..._OOS_r47b.csv` **r.2** (proposta)
- `backtest_pipeline/risultati_prove/aperture_r47/ABTG_DAX_Apertura_EU_D30EUR_IS_r47a.csv` **r.2** contro `..._IS_r47b.csv` **r.2**
- riproduzione 1: `backtest_pipeline/risultati_prove/aperture_r46/ABTG_DAX_Apertura_EU_D30EUR_OOS_r46a.csv` **r.2**
- riproduzione 2 **sul binario col Guardian**: `backtest_pipeline/risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r137c.csv` **r.2** (`InpTP1_ClosePct=0`) e **r.3** (`=50`)
- criteri congelati prima: `backtest_pipeline/prove/R137c_parziale_770101_D30EUR.txt`
- **quello che vola oggi**: `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set` **r.273** → `InpTP1_ClosePct=50.0`

🟢 **Bonus verificato oggi e che vale da solo**: `r137c` porta **due input che il banco
di agosto non aveva** (`InpUsaGuardian`, `InpAllowReverse`) e **riproduce `r47a`/`r47b`
al quinto decimale**, su tutte e due le finestre. 👉 **Sulla `770101` il buco B6 del
censimento dei contratti — «il binario che vola non è quello misurato» — è CHIUSO.**

## 2.2 🔬 IL CONTROLLO CHE MI È STATO CHIESTO CON CATTIVERIA — il PF sui DEAL contro il PF sulle POSIZIONI

Il PF del tester è una somma **sui deal**. Con il parziale acceso una posizione produce
**due** deal, e se il residuo esce in pari o sotto zero quel deal finisce nel
**denominatore** invece di essere netto dentro la posizione. **Quindi il PF con parziale
potrebbe essere gonfiato o sgonfiato, e senza saperlo il confronto non vale.**

**L'ho ricalcolato dal per-trade**
(`backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv`,
270 righe, e `..._772503.csv`, 193 righe), aggregando i deal per `position_id`:

| | deal | posizioni | **PF sui DEAL** | **PF sulle POSIZIONI** | scarto |
|---|---:|---:|---:|---:|---:|
| `ClosePct = 50` (viva) | 270 | **193** | 1,39709 | **1,39728** | **+0,00019** |
| `ClosePct = 0` (proposta) | 193 | **193** | 1,49140 | **1,49140** | 0 (identici per costruzione) |

> ### 🟢 **VERDETTO: il gonfiaggio da parziale su questa sedia vale 0,00019 punti di PF.**
> Il guadagno vero è **1,39728 → 1,49140 = +0,0941 punti = +6,7%**, e resta in piedi
> anche sulle due misure **immuni al problema**: **profitto +30,9%** e **RF ×1,46**.

⚠️ **E una correzione al passaggio**: `report/AUDIT_USCITE_2026-09-09.md` §2.3 scrive che
il parziale «compra win rate» (81,0% con · 74,0% senza). **Quelle sono percentuali sui
DEAL.** Contate **sulle POSIZIONI** le vincenti sono **143/193 = 74,1%** con parziale e
**142/193 = 73,6%** senza: **la differenza è 0,5 punti, non 7.** 👉 Il parziale **non
compra win rate**: **sposta soltanto la taglia delle vincite** (vincita media per
posizione 443,44 → **504,57**). La conclusione dell'audit (*«vende payoff»*) resta; la
metà «compra win rate» **non regge sulle posizioni**, ed è la stessa trappola
deal/posizioni.

## 2.3 🎯 IL CONTRO-ESEMPIO PRINCIPALE, costruito prima e **superato**

**L'ipotesi che ucciderebbe la proposta**: *«togliere il parziale cambia gli INGRESSI,
non solo le uscite — quindi le due celle non guardano le stesse operazioni e il confronto
è una finzione.»*

🔴 **Non è un'ipotesi di scuola: è successo davvero su un'altra sedia.** Sulla `771531`
la gemella senza parziale fa `n = 165` mentre le posizioni contate sono **257**
(`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §3.2): **chi avesse usato quel trucco lì si
sarebbe sbagliato del 36%.**

**Verificato oggi sui per-trade, e NON succede qui:**

| controllo | `ClosePct = 50` | `ClosePct = 0` | esito |
|---|---|---|---|
| posizioni (`position_id` distinti) | **193** | **193** | 🟢 uguali |
| **giornate** di operazione | 193 date | 193 date | 🟢 **INSIEMI IDENTICI** — differenza simmetrica **vuota, in tutte e due le direzioni** |
| posizioni con più di una operazione nello stesso giorno | 0 | 0 | 🟢 `InpOneTradePerDay` tiene |

E il **motivo per cui non può succedere** sta nel sorgente:
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` **r.268** `InpCloseAtEnd = true` (flat alle
17:30 server) + `InpOneTradePerDay = true` → **nessuna posizione sopravvive alla
giornata**, quindi **nessuna posizione può occupare il giorno dopo**. Sulla `771531`
invece `OnBarNuova` fa `if(HasPosition() || HasPending()) return` **senza flat di fine
giornata**: lì la durata mangia i segnali, **qui no.**

> 🟢 **Il contro-esempio è stato costruito, provato sull'unico caso in cui è noto che
> morda, e non morde qui. Superato.**

## 2.4 🔴 IL DIFETTO CHE HO TROVATO PROVANDO A ROMPERLA — e non lo nascondo

Ho confrontato le due celle **giornata per giornata** (193 giornate comuni):

| | valore |
|---|---:|
| differenza totale | **+5.577,70 €** |
| giornate in cui `ClosePct=0` fa **meglio** | **80** (somma +13.585,48) |
| giornate in cui fa **peggio** | **93** (somma −8.007,78) |
| giornate uguali | 20 |
| **mediana** della differenza | **0,00** |
| togliendo la **1ª** giornata migliore | +2.819,14 |
| togliendo le **3** migliori | 🔴 **−1,50** |
| togliendo le **5** migliori | 🔴 **−2.244,31** |

**E la stessa amputazione sul PF e sul DD:**

| | profitto | PF (posizioni) | DD su curva chiusa |
|---|---:|---:|---:|
| `ClosePct=50` intera | +18.029,58 | 1,39728 | 6,2516% |
| `ClosePct=0` intera | +23.607,28 | **1,49140** | **5,3969%** |
| `ClosePct=0` con le **3 migliori giornate annullate** | +18.028,08 | 🔴 **1,37526** | 🔴 **6,6962%** |

> ### 🔴 **DETTO CHIARO: in OOS il vantaggio è portato da TRE GIORNATE SU 193.**
> Senza quelle tre, la proposta è **leggermente peggiore** della cella viva su tutti e due
> gli assi. Questo **non** era nel dossier del 21/09 e **non** è nel file prova R137c.

**E il bootstrap lo conferma**: ricampionando 20.000 volte le 193 differenze giornaliere,
l'IC 95% sulla differenza è **[−2.882 ; +15.101]** e il **10,5%** dei ricampionamenti dà
**≤ 0**. *(⚠️ coincidenza di cifre da non confondere: questo 10,5% è una **quota di
ricampionamenti**, non ha niente a che vedere col +10,5% di slippaggio del §1.)* 🔴 **Statisticamente il vantaggio NON è distinguibile da zero al 95%.**

## 2.5 🧪 IL CONTRO-ESEMPIO AL MIO CONTRO-ESEMPIO — perché la proposta resta in piedi

Se boccio con quello strumento, devo accettare di boccare **anche quello che lo
strumento boccia per costruzione.** L'ho calibrato:

> **Lo stesso bootstrap, applicato al PROFITTO OOS DELLA SEDIA STESSA** (`ClosePct=50`,
> +18.029,58 €), dà **IC 95% = [−2.524 ; +38.339]**. 🔴 **Anche la sedia che sta volando
> in challenge, con questo metro, non è distinguibile da zero.**

👉 **Quindi il bootstrap su 193 somme giornaliere a coda grassa NON DISCRIMINA: boccia
tutto.** Usarlo per uccidere la proposta e non per uccidere la sedia sarebbe usare due
pesi e due misure. **Lo riporto come misura, non come verdetto.**

**Quello che discrimina davvero sono tre cose, e le ho:**

1. 🟢 **La SECONDA FINESTRA.** L'IS (2024.09→2025.06, **132 posizioni**, epoca diversa,
   dati indipendenti) migliora **su tutti e quattro** gli assi: PF +5,1%, DD −8,8%,
   profitto +47,0%, RF +58,7%. **Due finestre, stesso segno.** *(🔴 la concentrazione
   sulla coda **in IS** è `[NON MISURATO]`: il per-trade IS non esiste in repo — il driver
   lo sovrascrive con quello OOS. **Buco dichiarato, §6-B3.**)*
2. 🟢 **Il SEGNO PER TRIMESTRE**: 2025-Q2 **−7,15** · Q3 **+846,85** · Q4 **+1.542,39** ·
   2026-Q1 **+3.167,84** · Q2 **+27,77**. **Quattro trimestri su cinque a favore**, il
   quinto praticamente nullo. Non è un colpo solo: è un colpo **grosso** dentro una
   tendenza **coerente**.
3. 🟢 **Il MECCANISMO è capito e misurato, non ipotizzato.** `report/AUDIT_USCITE_2026-09-09.md`
   §2.1 (R46, sei strutture d'uscita sullo stesso ingresso) e §2.3 (payoff): **togliere il
   parziale vende win-rate e compra payoff** — cioè, **per costruzione**, sposta il P&L
   sulla coda. Una coda grassa qui **è l'effetto atteso del meccanismo**, non una
   coincidenza. *(🔴 E il rovescio va detto: un meccanismo che vive sulla coda è
   **più fragile in un campione corto**. Questa è la ragione per cui la proposta è una
   **firma**, e la firma è di Claudio.)*

## 2.6 💰 IL CANCELLO DEL COSTO D'ESECUZIONE — applicato, non citato

La regola: *un guadagno di PF più piccolo del costo d'esecuzione misurato non è un
guadagno.* Il costo misurato il 22/09 è **+10,5%** sulla perdita. Il guadagno di PF è
**+6,7%**. **Sembrerebbe dentro il rumore.** 🔴 **Ma applicato così sarebbe sbagliato, e
il conto lo dimostra.**

**Lo slippaggio colpisce TUTTE E DUE le celle.** Penalizzando le perdite del **10,5%**:

| | PF (posizioni) nominale | PF con perdite **+10,5%** |
|---|---:|---:|
| `ClosePct = 50` | 1,39728 | **1,2645** |
| `ClosePct = 0` | 1,49140 | **1,3497** |
| **distanza** | +0,0941 | **+0,0852** |

🟢 **Il vantaggio sopravvive quasi intero** (−9,5% del delta), perché il pedaggio è
**comune**.

🟢 **E c'è un secondo effetto, che va nella stessa direzione e che nessuno aveva contato:**
la cella proposta fa **193 uscite invece di 270 = 77 ESECUZIONI IN MENO** (−28,5%), tutte
chiusure **a mercato** (`r.2374`, `PositionClosePartial`). Meno esecuzioni = **meno
pedaggio**. 🔴 **Quanto valgano 77 esecuzioni su `D30EUR` è `[NON MISURATO]`** (lo
slippaggio misurato è su `US30.cash`, `n=1`), ma **il segno non è ambiguo**: il vantaggio
misurato sul banco è un **limite INFERIORE** di quello reale.

## 2.7 🪑 FREQUENZA — la proposta **non** costa operazioni

| | posizioni OOS | op/giorno | famiglia **Aperture** |
|---|---:|---:|---|
| `ClosePct = 50` | 193 | 0,699 | 1,407 🟢 sopra il pavimento |
| `ClosePct = 0` | **193** | **0,699** | **1,407** 🟢 **invariata** |

🟢 **È l'unica proposta di questo dossier che alza il PF senza tagliare una sola
operazione.** È gestione, non selezione.

## 2.8 💵 Costo e stato

**ZERO tempo macchina.** Una riga in
`mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set` r.273.
✋ **È una FIRMA DI CLAUDIO, non un lavoro** — e io non tocco preset in campo.
📌 Il contratto di rischio cambierebbe: DD promesso **7,2328% → 6,2719%** @1,00%, cioè
**14,47% → 12,54%** alla taglia che vola. **Se la firma arriva, la riga del
promemoria di revisione va aggiornata lo stesso giorno.**

---

# 3️⃣ 🥈 PROPOSTA #2 — `771531` `InpAllowLong` **1 → 0** (solo short) · COSTO ZERO

## 3.1 I numeri, e sono contati

| finestra | cella VIVA (due lati) | solo SHORT | delta |
|---|---|---|---|
| **IS** | PF **1,20110** · DD **5,7325%** · +4.585,40 · 237 deal | PF **1,23153** · DD **4,5113%** · +2.607,38 · 125 deal | PF **+2,5%** · DD **−21,3%** · profitto −43% |
| **OOS** | PF **1,52365** · DD **7,8323%** · +23.321,47 · 517 deal / **257 posizioni contate** | PF **1,89147** · DD **2,6628%** · +16.948,35 · 302 deal / **140 posizioni contate** | PF **+24,1%** · DD **−66,0%** · profitto −27% |

**Fonti** (tick reali, deposito 100.000, rischio 1,00, stessa corsa R112):
`backtest_pipeline/risultati_archivio/R112_CORSA_20260826/ABTG_EMA200_U30USD_{IS,OOS}_00_metro.csv` **r.2**
contro `..._{IS,OOS}_01_short_r1.csv` **r.2** · posizioni contate su
`pertrade_00_metro_763400.csv` (**517 deal → 257 `position_id`**) e
`pertrade_01_short_r1_763410.csv` (**302 deal → 140 `position_id`**).
Riprodotta in `R112_PARZIALE_20260826/` e in `backtest_pipeline/prove/R110_CSV_EMADOW/`.
**Quello che vola**: `mql5/Presets/FTMO/ABTG_EMA200_771531_FTMO.set` **r.116-117**
(`InpAllowLong=true`, `InpAllowShort=true`).

## 3.2 🔬 Il lato LONG letto da solo — e qui c'è una misura che il preset non cita

Il preset scrive (r.101): *«Il long puro vale PF 1,24103 … `InpAllowLong=true` E
`InpAllowShort=true` NON si toccano.»* **Il PF c'è. Il DD no.** Eccolo:

| lato, misurato DA SOLO (stessa corsa, stesso banco) | PF | **DD** | profitto | n |
|---|---:|---:|---:|---:|
| **LONG puro OOS** | 1,24103 | 🔴 **8,8973%** | +5.670,52 | 241 deal |
| **SHORT puro OOS** | **1,89147** | 🟢 **2,6628%** | +16.948,35 | 302 deal |
| due lati insieme OOS | 1,52365 | 7,8323% | +23.321,47 | 517 deal |
| **LONG puro IS** | 1,16183 | **2,6377%** | +1.843,66 | 112 deal |
| **SHORT puro IS** | **1,23153** | 4,5113% | +2.607,38 | 125 deal |

Fonte long puro: `backtest_pipeline/prove/R110_CSV_EMADOW/ABTG_EMA200_U30USD_{IS,OOS}_01_long.csv` **r.2-3**.

> ### 🔴 **In OOS il lato LONG, DA SOLO, ha un drawdown PIÙ GRANDE della sedia intera
> (8,8973% contro 7,8323%) e porta il 24% del profitto.** Alla taglia che vola sono
> **17,79%**, contro un muro FTMO del 10%.

🧪 **E il contro-esempio, costruito e in parte RIUSCITO — lo scrivo grosso.**
*«Il long è il motore del drawdown»* è vero **solo in OOS**: **in IS il long ha il DD
più BASSO dei due** (2,6377% contro 4,5113%). 🔴 **L'attribuzione del DD a un lato NON è
stabile fra le due finestre**, e chi la usasse come argomento decisivo starebbe
scegliendo sull'OOS.
🟢 **Quello che invece regge in tutte e due le finestre, e che è la proposta, è un'altra
frase**: *il solo short ha PF **più alto** e DD **più basso** della coppia, **sia in IS
sia in OOS***. Quella è misurata due volte e col segno concorde.

✅ **Seconda verifica, dal per-trade della corsa a due lati** (separando i deal per
`deal_type`): long **121 posizioni**, +5.678,16, PF **1,22380**, DD su curva chiusa
**10,36%** su 100k · short **136 posizioni**, +17.643,31, PF **1,92085**, DD **2,57%**.
🟢 Coerente con le corse a lato singolo — **due strade indipendenti, stesso risultato.**

## 3.3 🔴 IL PREZZO, e non è piccolo

| | vola oggi | proposta | conseguenza |
|---|---:|---:|---|
| posizioni OOS | **257** | **140** | −45,5% |
| frequenza | **0,931 op/g** | **0,507 op/g** | 🔴 famiglia `EMA200` da **−7%** a **−49%** sotto il pavimento 1,00 |
| profitto OOS @1,00% | 23.321,47 | 16.948,35 | −27,3% |
| posizioni IS | `[NON MISURATO]`, forbice 103-237 | `[NON MISURATO]`, 125 deal | merito IS **sospeso** in tutti e due i casi |

🔴 **E il guadagno di PF in IS (+2,5%) è DENTRO la banda di rumore d'esecuzione (10,5%).**
La riga onesta è: **in IS la proposta compra DD (−21%), non PF.** Il PF lo compra solo in
OOS (+24,1%), e quello è il lato su cui si sta scegliendo.

## 3.4 💵 Costo e stato
**ZERO tempo macchina** (una riga nel `.set`). ✋ **Firma di Claudio.**
📌 Cambierebbe il contratto di rischio: DD promesso **7,8323% → 2,6628%** @1,00%
(**15,66% → 5,33%** alla taglia che vola) — 🟢 **è la singola riduzione di rischio più
grande disponibile a costo zero su tutta la rosa**, e sulla sedia che oggi ha il DD
promesso peggiore. 🔴 **Ma la frequenza cade sotto il pavimento della sua famiglia, e
quello è un requisito firmato.** Le due cose vanno decise **insieme**, non una alla volta.

---

# 4️⃣ 🚫 I CANDIDATI CHE SEMBRAVANO ORO E CHE HO UCCISO COL NUMERO
*(li scrivo perché un morto ben documentato vale quanto un vivo: nessuno lo rifarà)*

| # | sedia | manopola | perché sembrava oro | 🔪 perché è morto |
|---|---|---|---|---|
| **X1** | `770101` | `InpTrailTF` **M5 → M2** | OOS PF **1,41521 → 1,69139** (+19,5%), DD **6,7111% → 4,9759%** (−26%). Tre celle (M1/M2/M3) battono la viva su tutti e due gli assi | 🔴 **IN CAMPIONE M2 È LA CELLA PEGGIORE DELL'ASSE**: PF **0,75978**, profitto **−594,63**, DD 7,8234%, contro la viva M5 a PF 1,13109 e +380,71. E M1 è pure negativa. 👉 L'altopiano OOS (M1-M4) e quello IS (M4-M5) **non si toccano**: scegliere M2 è scegliere **sull'OOS**. Fonte: `risultati_prove/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}.csv`, righe `InpTrailStartR=0` |
| **X2** | `770202` | `InpRangeMinutes` **35 → 45** | OOS PF **1,27507 → 1,68023** (+31,8%), DD **4,1794% → 2,4955%** | 🔴 **PICCO A DUE CELLE**: i vicini OOS fanno 1,24688 (40') e 1,27269 (55'). E **in IS la cella è in PERDITA**: PF **0,84724**, −199,75 €. 🟢 **In IS il massimo dell'asse è 35 — il valore VIVO** (PF 1,21486). *Il default va bene.* Fonte: `risultati_prove/aperture_r35/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_r35.csv` |
| **X3** | `770202` | `InpTP1_ClosePct` **50 → 0** | è **la manopola della proposta #1**, stessa famiglia, stesso round, stesso giorno | 🔴 **SUL DOW IL SEGNO SI ROVESCIA**: OOS PF **1,27013 → 1,25809** (peggio) e DD **4,3941% → 5,4280%** (+23,5%, peggio). *(In IS migliorerebbe: 1,22247 → 1,32837.)* 👉 **Chiunque fosse tentato di «estendere per simmetria» ha qui il numero che glielo impedisce.** Fonte: `aperture_r47/ABTG_Dow_Apertura_US_U30USD_{IS,OOS}_r47{c,d}.csv` r.2 |
| **X4** | `771531` | `InpTP1Pct` **50 → 0** | stessa idea della #1 sull'altra sedia | 🔴 **DISASTRO MISURATO**: OOS PF **1,52365 → 1,28144** e DD **7,8323% → 13,9367%** (+78%); IS PF **1,20110 → 0,93483** (in perdita). 🟢 **E fra 25/50/75 la manopola è quasi INERTE** (OOS 1,51843 / 1,52365 / 1,52560 — **0,5% di escursione fra i tre**). **Il default va bene, misurato.** Fonte: `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r136c.csv` |
| **X5** | `770101` | `InpUseVolumeFilter` **0 → 1** | migliora **in tutte e due le finestre** a ogni `InpVolMult`: a 1,2 → IS PF 1,19054 / DD 3,9923 · OOS PF **1,64641** / DD **4,3940** | 🔴 **È SELEZIONE, NON GESTIONE**: le uscite OOS crollano **270 → 150** (a 1,2), **→ 96** (a 1,5), **→ 62** (a 1,8). Sotto il pavimento dei 150 **in posizioni** e con la frequenza della sedia più veloce della famiglia dimezzata. 🟠 **Ma NON è morto: è "non ancora misurato bene"** — l'asse si ferma a **1,2 sul bordo basso** (mai provato 1,0-1,15, dove taglierebbe meno) e gira tutto con `InpTP1_ClosePct=50`, **mai** incrociato con la proposta #1. Fonte: `risultati_prove/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r26.csv` |
| **X6** | `770260` | `InpEntryMode` **2 → 1** | PF IS 1,14498 → **2,08266**, OOS 1,10936 → **1,93691**, DD giù in tutte e due | 🔴 **n = 23 (IS) e 19 (OOS).** Diciannove operazioni. E `InpEntryMode` **è l'identità del motore** (2 = retest): non è una manopola, **è un'altra sedia**. *(Confermo il verdetto del 21/09.)* Fonte: `risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` Pass 1/7 |
| **X7** | `770511` | `InpStMult` **2,5 → 1,5** | OOS PF **1,32770 → 1,60552**, DD **3,9082% → 3,2790%**, e **n SALE** 143 → 165 (aiuta la frequenza, che su questa sedia è 3,4× sotto il pavimento) | 🔴 **In IS la cella viva 2,5 è il MASSIMO dell'asse** (PF 1,84892) e 1,5 fa **1,19820**. E 🔴 **il contratto di questa sedia è CONTESO**: la stessa cella, stesso deposito, **41 input su 41 identici**, misurata due volte dà `n 143/PF 1,32770` e `n 131/PF 1,24312` (`CONTRATTI…20-09` §5.1, buco **B2**). 👉 **Non si propone un parametro su una sedia la cui linea di base non riproduce.** Prima B2, poi questo. Fonte: `risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/..._U30USD_{IS,OOS}_r3.csv` |
| **X8** | `771531` | `InpTP1_ATRmult` **0 → 0,25** | OOS DD **7,8323% → 2,0993%** (−73%!), PF **1,52365 → 1,58999** | 🔴 **In IS la cella va SOTTO 1**: PF **0,99392**, profitto −73,01. E il profitto OOS crolla da 23.321 a **9.858** (−58%): compra DD **pagando in profitto**, che è un altro tavolo (e una firma). Fonte: `..._{IS,OOS}_r136b.csv` |
| **X9** | `771531` | `InpUseTrailing` **1 → 0** | OOS PF **1,52365 → 1,77080** (+16,2%), DD 7,8323 → 7,4151 | 🔴 **In IS il PF PEGGIORA**: 1,20110 → **1,10716** (−7,8%). Finestre discordi sul PF → **non è una firma**. 🟠 Il DD migliora in tutte e due (−4,1% IS, −5,3% OOS): resta un candidato **da round**, non da riga. Fonte: `..._{IS,OOS}_r136d.csv` |
| **X10** | `770411` | — | — | 🟢 **Nessun vicino a una manopola batte la cella viva su PF senza peggiorare il DD**, su 162 righe della sua firma. Confermo il NO del 21/09. E il suo campione (**14 posizioni OOS contate**) non consentirebbe comunque una lettura di merito |

## 4.1 🧊 E la lezione che tiene insieme X1, X2, X7 e X9
**Quattro candidati su dieci sono morti per la STESSA ragione: migliorano in OOS e
peggiorano in IS.** Non è sfortuna, è il difetto strutturale del progetto già misurato —
`REFERTO_TRAILING_SOGLIA.md` §1 lo chiama **«l'ottavo ribaltamento IS→OOS»**, con
Spearman **−0,44** su 25 celle.
👉 **Il filtro "meglio in TUTTE E DUE le finestre" ha ucciso il 40% dei candidati. È il
filtro che vale di più di tutto questo dossier**, e le due proposte in cima sono le uniche
che lo passano.

---

# 5️⃣ 🎛️ LE MANOPOLE D'USCITA VIVE MAI MESSE AD ASSE — con la prova che sono VIVE

Metodo: per ogni sedia ho preso **tutte** le righe d'archivio con la sua identica firma di
colonne e contato i **valori distinti** assunti da ogni input. **Un solo valore in tutto
l'archivio = casella LIBERA, non casella provata.** Poi ho verificato **nel sorgente** se
il ramo che la legge è **acceso** dal preset che vola.

## 5.1 `770101` DAX Apertura — **1.052 righe della sua firma**

| manopola | valore vivo | valori distinti in archivio | 🔦 il ramo è ACCESO? (file + riga) | verdetto |
|---|---|---:|---|---|
| **`InpTP1_R`** | **1,0** | 🔴 **1 (solo 1,0)** | 🟢 **VIVA E DOPPIA**: `ABTG_DAX_Apertura_EU.mq5` **r.2081-2087** `TpTotalR(){ r = InpTP1_R*3,0 }` (bersaglio finale, usato a r.1208/1232/1445/1552/1951/1992) **e** **r.2368** `target = openP + dirSign*riskDist*InpTP1_R` (punto del parziale) | 🔥 **CASELLA LIBERA, ed è la più grossa.** → **file prova `R208b` pronto (§7)** |
| **`InpSLMode`** | **0** (`ABTG_SL_RANGE`) | 🔴 **1** | 🟢 viva: **r.1198/1222/1428/1536/1931/1974** `sl = (InpSLMode == ABTG_SL_RANGE) ? … : … AtrValue()*InpAtrSlMult` | 🔴 **LA GEOMETRIA DELLO STOP DI QUESTA SEDIA NON È MAI STATA MESSA AD ASSE.** Sulla sedia gemella `EMA200` lo stesso asse vale **−26% di DD in tutte e due le finestre** (r136a) |
| `InpAtrSlMult` | 1,5 | 2 (1,0 · 1,5) | 🔴 **INERTE**: letta solo nel ramo `InpSLMode == ABTG_SL_ATR`, e `InpSLMode` è **sempre 0** | ⚠️ **I due valori in archivio NON sono un asse: sono due pin su un ramo spento.** Esattamente il caso `InpTrailFixedPts`/`InpTrailMode` |
| `InpTrailAtrMult` · `InpTrailFixedPts` | 2,0 · 410 | 🔴 1 ciascuna | 🔴 **INERTI**: `TrailStopBuy` **r.2461** e `TrailStopSell` **r.2474** le leggono solo se `InpTrailMode != ABTG_TRAIL_PREVBAR`, e il preset ha `InpTrailMode = 1` | 🪦 **Caselle MORTE, non libere.** *(È la trappola che il mandato cita per nome.)* |
| `InpBreakevenAtTP1` | true | 🔴 1 | 🟢 viva **oggi** (r.2391) — 🔴 **ma diventa INERTE con la proposta #1**: r.2391 sta **dentro** il blocco `if(InpTP1_ClosePct > 0 && < 100)` di **r.2359** | ⚠️ **Conseguenza della #1 da dichiarare: con `ClosePct=0` nessuna posizione va più in pari.** Il DD misurato **la contiene già** |
| `InpBEatR` | 0,0 | 🔴 1 | 🟢 viva e **indipendente** dal parziale: **r.2405-2418** | 🟠 casella libera. Sul **Dow** l'asse esiste (04/08, BE 0 vs 0,5R) e ha vinto **0**: indizio, non misura, su questa sedia |
| `InpCloseAtEnd` | true | 🔴 1 | 🟢 viva: **r.2566** | 🔴 **Mai ad asse in TUTTO il repo** (37 EA ce l'hanno — `AUDIT_USCITE` §5 voce 25). ⚠️ `InpCloseHour` **è accoppiato agli ingressi** (r.811, r.1401): **non è un asse d'uscita puro** |
| `InpTrailTF` | 5 | 5 (M1…M5) | 🟢 viva | ⚠️ **asse percorso solo SOTTO il valore vivo.** Sopra M5 non c'è **niente**: il file prova `R128a` (M5→M30, 7 celle) **è scritto dall'11/09 e non è MAI STATO LANCIATO** — verificato: zero CSV `r128*` in repo. 🔴 Ma vedi **X1**: su questo asse IS e OOS si ribaltano, quindi **la metà alta va girata sapendolo** |

## 5.2 `771531` EMA200 Dow — sulle 722 righe `U30USD`

| manopola | valore vivo | valori distinti | il ramo è acceso? | verdetto |
|---|---|---:|---|---|
| **`InpUseOrder2`** | **true** | 🔴 **1** | 🟢 viva: `ABTG_EMA200.mq5` `PlaceOrders()` — il **secondo limite** e il `riskPct/nOrders` | 🔥 **Casella libera: lo scale-in a due gambe non è MAI stato acceso/spento.** Tocca insieme frequenza, taglia e DD |
| **`InpTP_RR`** | **2,0** | 5 in archivio, **ma solo 2,0 e 2,5 alla configurazione che vola** | 🟢 viva | 🟠 **Altopiano NON valutabile** (due punti). **→ file prova `R208a` pronto (§7)** |
| `InpBreakeven` | true | 🔴 1 | 🟢 viva | 🔴 casella libera |
| `InpUseEma14Bias` | true | 🔴 1 | 🟢 viva | 🔴 casella libera (è un filtro d'ingresso, non d'uscita: fuori mandato) |
| `InpUseCutoff` · `InpFridayClose` | false · false | 🔴 1 · 1 | 🔴 **spenti** → `InpCutoffHour=19` e `InpFridayCloseHour=20` sono **INERTI** (già dichiarato nel censimento dei contratti, §2 tabella diff) | 🪦 caselle **morte finché l'interruttore è false**. Accenderle è **un'altra sedia**, non una taratura |
| `InpMaxSpread` | 0 | 🔴 1 | 🟢 viva, **ma parziale**: `SpreadOK()` è chiamata **al SEGNALE** (r.325), quindi **filtra l'ingresso, non l'uscita** (`EMA200_I_DUE_REQUISITI_2026-09-12.md` §4.3) | 🟠 candidato per il **costo**, non per il PF |

## 5.3 🔴 La famiglia dove la risposta è «non è mai stato misurato»
`AUDIT_USCITE_2026-09-09.md` §1 e Tabella B: su **32 meccanismi d'uscita** censiti,
**13 non sono MAI stati messi ad asse**, e sulla famiglia **Supertrend** — cioè
`770511 SuperWave` fra le sedie che volano — **`InpTrailOnST` (15 EA), `InpExitOnFlip`
(14 EA) e `InpFirstFraction` (14 EA) hanno ZERO occorrenze come asse in tutto il repo.**
🔴 **Non lo propongo come round oggi**, e il motivo è il buco **B2**: il contratto della
`770511` **non riproduce fra il binario di luglio e quello di settembre**. Misurare
l'uscita su una linea di base che non riproduce è buttare tempo macchina.
👉 **Prima B2, poi l'uscita del Supertrend.** È la cosa più grande che resta scoperta.

---

# 6️⃣ 🏆 LA GRADUATORIA — PF guadagnato ÷ tempo macchina

| # | proposta | ΔPF OOS | ΔDD OOS | Δfrequenza | costo macchina | stato |
|---|---|---:|---:|---:|---|---|
| **1** | `770101` `InpTP1_ClosePct` **50→0** | **+0,0941** (+6,7%) | **−0,9609 pt** (−13,3%) | 🟢 **0** | 🟢 **ZERO** | ✋ **FIRMA DI CLAUDIO** — pronta, con il difetto della coda dichiarato (§2.4-2.5) |
| **2** | `771531` `InpAllowLong` **1→0** | **+0,3678** (+24,1%) | **−5,1695 pt** (−66,0%) | 🔴 **−45,5%** (0,931→0,507) | 🟢 **ZERO** | ✋ **FIRMA DI CLAUDIO** — 🔴 rompe il pavimento di frequenza della sua famiglia: le due cose si decidono **insieme** |
| **3** | `771531` `InpTP_RR` — chiudere altopiano **e** divisione IS/OOS | `[NON MISURATO]` su questa finestra | `[NON MISURATO]` | attesa: **in calo** col bersaglio | **10 passate ≈ 4-8 min** *(ancoraggio: R112 ha girato 4 celle × 2 finestre × 2 gemelli = **16 passate in 0,1 ore** = ~23 s/passata — `R112_CORSA_20260826/REFERTO_R112.txt` r.7)* | 📦 **`R208a` PRONTO**, cancello OK |
| **4** | `770101` `InpTP1_R` — la casella più grossa mai toccata | `[NON MISURATO]` | `[NON MISURATO]` | 🟢 **0 per invariante** (n bloccato a 193/132) | **10 passate**, durata `[NON MISURATO]` su M5 tick — **da confermare con `-SoloControllo`** | 📦 **`R208b` PRONTO**, cancello OK |
| **5** | `770101` `InpUseVolumeFilter` con l'asse **esteso sotto 1,2** e incrociato con la #1 | indizio **+0,23** a 1,2 | indizio **−2,3 pt** | 🔴 **uscite −44%** già a 1,2; in **posizioni** `[NON MISURATO]` | ~14 passate | 🟠 **da scrivere** — solo **dopo** la firma sulla #1, altrimenti misura la configurazione sbagliata |
| **6** | `770101` `InpSLMode` / larghezza dello stop | `[NON MISURATO]` | sul gemello `EMA200` vale **−26%** | 🟢 attesa 0 | ~4 + 14 passate | 🟠 **da scrivere** — ⚠️ **e serve PRIMA una misura**: l'ATR è su `PERIOD_CURRENT` = **M5** (`.mq5` r.510), quindi `AtrSlMult=1,5` darebbe uno stop **più STRETTO** di quello vivo, cioè il verso sbagliato per il cancello del costo. **L'ATR M5(14) del DAX all'ora 08 è `[NON MISURATO]` in repo: senza quel numero l'asse si sceglie a occhio** |
| **7** | `770511` famiglia Supertrend (`InpTrailOnST`, `InpExitOnFlip`, `InpFirstFraction`) | `[NON MISURATO]` | `[NON MISURATO]` | `[NON MISURATO]` | ~32-64 passate | 🔴 **BLOCCATA da B2** (§4 X7) |

> 🔴 **E la riga di realismo, perché la graduatoria non menta**: le posizioni **1 e 2 non
> sono round. Sono due righe in due `.set`.** Tutto il tempo macchina del mondo, oggi,
> vale meno di quelle due firme — ed è esattamente il punto del mandato.

---

# 7️⃣ 📦 I DUE FILE PROVA PRONTI — cancello passato

```
=== CONTROLLO FILE PROVA ===
  R208a_tprr_771531_U30USD.txt      ABTG_EMA200.mq5           pin=43 celle= 5  OK
  R208b_bersaglio_770101_D30EUR.txt ABTG_DAX_Apertura_EU.mq5  pin=81 celle= 5  OK
file: 2 | celle totali: 10 | passate (celle x 2 finestre): 20 | problemi: 0
ESITO: OK
```

### `backtest_pipeline/prove/R208a_tprr_771531_U30USD.txt`
Asse **`InpTP_RR` 1,0-3,0 passo 0,5** (5 celle, **centrato sul valore vivo 2,0**, due per
parte). Chiude i **due buchi** che il dossier del 21/09 ha dichiarato sul suo candidato C:
**nessuna divisione IS/OOS** (le due corse citate girano a finestra unica) e **altopiano
non valutabile** (solo 2,0 e 2,5 esistono alla configurazione che vola).
🟢 **Perché questo asse è leggibile**: `InpTP_RR` **non tocca lo stop**, quindi il rischio
in euro per operazione è identico in tutte e cinque le celle — **non è una leva di taglia
travestita**, che è ciò che ha declassato `InpSLatr` il 21/09.
**Sentinella S1** (bloccante): la cella `2,0` deve ridare IS `n 237 / PF 1,20110 / DD
5,7325%` e OOS `n 517 / PF 1,52365 / DD 7,8323%`. Se non torna, il verdetto è
**«il binario di oggi non è quello di R112»**, non «il bersaglio non serve».
**Attesa scomoda scritta prima**: *mi aspetto un altopiano piatto e la risposta «il
default va bene»* — perché `AUDIT_USCITE` riporta che su questo motore l'asse `TP_RR` ha
già dato **30 celle su 30 a PASS pieno**, e un asse che non ha mai prodotto una cella
cattiva è un asse **piatto**.

### `backtest_pipeline/prove/R208b_bersaglio_770101_D30EUR.txt`
Asse **`InpTP1_R` 0,50-1,50 passo 0,25** (5 celle, centrato sul vivo 1,0) → bersaglio
finale da **1,5R a 4,5R**. **Pinna `InpTP1_ClosePct = 0`**, e il perché è nel sorgente:
con il parziale acceso `InpTP1_R` fa **due cose accoppiate** (punto del parziale **e**
bersaglio); **con il parziale spento r.2368 è morto** e resta **una variabile, un
significato**.
🟢 **E porta un'INVARIANTE che nessun altro round di questa casa ha avuto**: su questa
sedia `InpOneTradePerDay` + `InpCloseAtEnd` alle 17:30 fanno sì che **nessuna posizione
sopravviva alla giornata**, quindi **`Trades` deve valere 193 (OOS) e 132 (IS) in TUTTE
e cinque le celle**. 👉 **Artefatto di sopravvivenza e artefatto di campione sono esclusi
per costruzione**: tutte le celle guardano le **stesse 193 operazioni**. Se un `n`
diverge, **il round si ferma prima di leggere un solo PF**.
🔴 **Dipendenza dichiarata**: parte dalla configurazione della proposta #1. **Se la firma
non arriva, il file va riscritto con il parziale a 50 e l'accoppiamento dichiarato.**

---

# 8️⃣ 🕳️ COSA RESTA NON COPERTO — per nome

| # | buco | perché conta | via più corta |
|---|---|---|---|
| **B1** | 🔴 **La concentrazione sulla coda della proposta #1 IN CAMPIONE è `[NON MISURATO]`** | Il vantaggio OOS è portato da 3 giornate su 193. Se anche l'IS fosse portato da 2-3 giornate, i «due campioni concordi» sarebbero **cinque giornate** in tutto | **una corsa**, solo gamba IS, cella `ClosePct=0`, magic vergine, export per-trade: ~1 min |
| **B2** | 🔴 **Il per-trade IS non esiste in repo per NESSUNA sedia** | Il driver lo scrive con **EA + simbolo + magic** e la gamba OOS **sovrascrive** la IS (causa già nominata in `CONTRATTI…20-09` §3.2). 👉 **Metà delle verifiche di coda sono impossibili dall'archivio, per disegno** | è un **difetto di disegno del driver**, non un round: il nome del file dovrebbe portare la gamba |
| **B3** | 🔴 **Il valore in euro dello slippaggio su `D30EUR` e `U30USD` a `n>1`** | Il **+10,5%** è **un solo campione**, su `US30.cash`. Tutta la §2.6 usa quel numero come soglia di prudenza | accumulare gli stop veri della challenge. **Costa zero: sono dati che arrivano da soli** |
| **B4** | 🔴 **`770511`: il contratto non riproduce fra binario di luglio e di settembre** | Blocca la proposta #7 **e** la X7. È l'unica sedia su cui non si può proporre niente | 1 min di tester (già scritto come **B2** nel censimento dei contratti del 20/09) |
| **B5** | 🟠 **`770260` Nasdaq: nessun candidato, ma nemmeno un vicino** | Sulle 908 righe della sua firma esiste **UN SOLO** vicino a una manopola, ed è X6 (n=19). 🔴 **E nelle griglie `NASDAQ_A/D/E/H/L/M` praticamente ogni cella sta SOTTO PF 1 in OOS**: la cella viva è un'**isola**, non un altopiano | non è una griglia in più: è una domanda sulla sedia. **Da portare a Claudio come tale** |
| **B6** | 🟠 **`InpCloseAtEnd`/`InpCloseHour`: mai ad asse in tutto il repo (37 EA)** | È l'uscita che chiude **ogni** giornata di **ogni** sedia intraday | ⚠️ **non è un asse d'uscita puro** su `770101`: `InpCloseHour` entra anche negli ingressi (r.811, r.1401). Serve un file prova scritto **sapendolo** |
| **B7** | 🟠 **`R128a` (trailing M5→M30) è scritto dall'11/09 e non è mai stato lanciato** | 7 celle già preparate e passate dal cancello. 🔴 **Ma X1 dice che su quell'asse IS e OOS si ribaltano**: va letto con quel sospetto scritto prima | 14 passate, file già in repo |
| **B8** | 🔴 **Prova di regime: assente su TUTTO questo dossier** | Lo storico BCM degli indici parte dal **2024.09.26**: 21 mesi = **un solo regime (toro)**. Regola **C** dell'Emendamento della Finestra **non soddisfatta** | 🔴 **nessuna via corta.** Non esistono dati BCM prima. 👉 **Niente di quanto c'è qui è promuovibile senza un fuori campione di regime diverso** — e questo vale **anche per le proposte 1 e 2** |

---

# 9️⃣ ✅ COSA È ANDATO BENE — perché un elenco di difetti senza le vittorie descrive male la realtà

- 🥇 **Due proposte a costo zero sono sul tavolo, misurate, riprodotte e con il
  contro-esempio costruito e superato.** Non servono round per alzare il PF delle due
  sedie migliori: serve una firma.
- 🟢 **Il buco B6 del censimento dei contratti è CHIUSO sulla `770101`**: `r137c`
  riproduce `r47a`/`r47b` **al quinto decimale** su un binario che ha **due input in
  più**, `InpUsaGuardian` compreso. Il numero del banco **descrive la sedia che gira**.
- 🟢 **Un errore di lettura vecchio è stato corretto contando**: il parziale **non
  compra win rate** (74,1% contro 73,6% **sulle posizioni**, non 81% contro 74% sui deal).
- 🟢 **Quattro «il default va bene» misurati, e sono risultati, non fallimenti**:
  `InpTP1Pct` su EMA200 (quasi inerte fra 25/50/75), `InpRangeMinutes` sul Dow (35 è il
  massimo IS), `InpTrailStartR` sul DAX (0 vince in 5 righe su 5), `InpTP1_ClosePct` sul
  Dow (la viva vince).
- 🟢 **Il filtro «meglio in tutte e due le finestre» ha fatto il suo mestiere**: ha ucciso
  **4 candidati su 10** che sarebbero passati guardando il solo OOS. Fra questi il più
  seducente del lotto (`InpTrailTF M2`, +19,5% di PF): in campione è **la cella peggiore
  dell'asse**.
- 🟢 **Due file prova pronti al cancello**, con **attesa scomoda scritta prima**, soglie
  congelate, contro-esempio costruito e — su `R208b` — **un'invariante che esclude per
  costruzione i due artefatti che hanno rovinato i round precedenti**.

---

*Misura prodotta in sola lettura il 22/09/2026. I numeri che decidono — il PF sulle
posizioni, l'identità dei 193 giorni, la scomposizione per coda e per trimestre, la
lettura per lato della `771531` — sono stati **calcolati da me sui per-trade e sui CSV
sorgente**, non ripresi dai referti. Dove un numero manca, c'è scritto `[NON MISURATO]`.
Nessun preset in campo è stato toccato: le due proposte in cima sono **firme di
Claudio**.*

---

# 🔟 ⚠️ DUE RILIEVI DI CANTIERE, trovati mentre consegnavo

## 10.1 🔴 Un difetto in un file prova scritto OGGI da un altro tavolo — `R207a`
Stamattina, sullo **stesso mandato**, è comparso in repo (non tracciato)
`backtest_pipeline/prove/R207a_parziale_e_breakeven_DAX_D30EUR.txt`, che attacca **la
stessa manopola della mia proposta #1** dal lato dei preset dei vendor
(`DOSSIER_CONFIG_PF_2026-09-22.md`). 🟢 **Il file è scritto bene e il suo asse è giusto.**
🔴 **Ma la sua riga 26 dice una cosa falsa, e non è cosmetica:**

> *«Noi qui siamo pinnati a `InpTrailMode=1` (**ABTG_TRAIL_FIXED, 410 punti**). Quindi il
> 1,49/6,27 **NON è una previsione per questa geometria**…»*

**Nel sorgente, `ABTG_DAX_Apertura_EU.mq5` r.242-244:**
```
ABTG_TRAIL_ATR     = 0
ABTG_TRAIL_PREVBAR = 1     <<<  InpTrailMode=1 E' QUESTO
ABTG_TRAIL_FIXED   = 2
```
👉 **`InpTrailMode=1` è PREVBAR, non FIXED.** Il file **pinna il valore giusto** (è la
geometria viva), ma la **riserva** che ne deriva è **infondata**: `R207a` gira sullo
**STESSO trailing di R46**, quindi **1,49/6,27 È esattamente il numero atteso**, non «un
motivo per girare». E `InpTrailFixedPts=410`, che quel paragrafo tratta come attivo, è
**INERTE** (§5.1 di questo dossier: `TrailStopBuy` r.2461 / `TrailStopSell` r.2474 lo
leggono solo se `InpTrailMode == ABTG_TRAIL_FIXED`).
✋ **Non ho toccato il file di un altro tavolo**: lo segnalo perché l'**attesa dichiarata
prima dei numeri** è la parte che decide come si leggerà il CSV, e questa è sbagliata.

## 10.2 🟠 Collisione di numerazione, evitata
I miei due file erano nati `R143a`/`R143b`: 🔴 **quei nomi sono già usati** dal 15/09
(`R143a_preopen_metro_NASUSD.txt`, `R143b_preopen_gemello_D30EUR.txt`,
`R143c_preopen_gemello_U30USD.txt`). Rinominati in **`R208a`/`R208b`** (il massimo in
`prove/` è **R207**) e ripassati dal cancello.

## 10.3 📌 E una differenza di banco fra i due tavoli, da non lasciare implicita
`R207a/b` girano a **`-Deposito 80000`** (il banco FTMO vero). Il mio **`R208b`** gira a
**100.000**, e non per distrazione: a 80.000 **nessuna cella riprodurrebbe R47/R137c**, e
senza riproduzione la sentinella **S1** non esiste — cioè si perderebbe l'unico modo di
sapere se il binario è cambiato. 🟢 **I due banchi rispondono a due domande diverse e
vanno tenuti tutti e due**: R207 dice *«quanto vale sul conto che vola»*, R208b dice
*«il numero regge ancora?»*. 🔴 **Ma i loro DD NON si confrontano fra loro** senza
dichiarare il deposito: sul `770101` la stessa cella fa **6,7111% a 10k** e **7,2328% a
100k** (+7,8%) a trade identici.
