# 🚪 LA PORTA DEL TRAILING — `ABTG_EMA200` U30USD (sedia `771531`)

**18/09/2026.** Verdetto di merito su `r136d` letto **dai CSV che erano già in
repo**, zero macchina, più il file prova per la misura che manca.

---

## 🎯 IL VERDETTO IN UNA RIGA

> 🔴 **Il trailing OFF NON È MISURATO come miglioramento, e non è una formalità:
> il criterio 1 del file prova — congelato PRIMA dei numeri e dichiarato
> OBBLIGATORIO — chiede la concordanza IS/OOS, e il segno si INVERTE.** In OOS
> la cella 0 fa **+0,24715 di PF e +21,1% di profitto**; in IS fa **−0,09394 di
> PF e −55,4% di profitto**. 🟢 **Ma non è un morto**: il DD migliora in
> *entrambe* le finestre, la manopola **morde** (casella 3 del certificato
> chiusa con un numero), e il profitto **per posizione** è l'unica strada che
> resta aperta — ed è quella che il round R179a va a contare.

---

## 1. 📊 LA SUPERFICIE — tutte le celle, IS e OOS

`r136d` ha **UN SOLO asse** (`InpUseTrailing`, bool) ⇒ **2 celle**. Verificato:
`backtest_pipeline/prove/R136d_trailing_U30USD.txt` ultima riga
`InpUseTrailing=1||0||1||1||Y`, e `controlla_prova.py` conta `celle= 2`.

**Fonte di TUTTI i numeri qui sotto** (file + riga), tutti `[MISURATO]`:
`backtest_pipeline/risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_IS_r136d.csv`
r.2-3 e `..._OOS_r136d.csv` r.2-3.

| finestra | cella | Profit | PF | Equity DD % | Trades (deal) | Sharpe | Recovery |
|---|---|---:|---:|---:|---:|---:|---:|
| **IS** | `InpUseTrailing=1` (**viva**) | 4.585,40 | **1,20110** | **5,7325** | **237** | 3,77377 | 0,78806 |
| **IS** | `InpUseTrailing=0` (OFF) | 2.045,18 | **1,10716** | **5,4988** | **194** | 1,31936 | 0,36750 |
| **OOS** | `InpUseTrailing=1` (**viva**) | 23.321,47 | **1,52365** | **7,8323** | **517** | 8,16765 | 2,53681 |
| **OOS** | `InpUseTrailing=0` (OFF) | 28.249,94 | **1,77080** | **7,4151** | **427** | 7,57603 | 3,21232 |

### 🔴 Altopiano o punto isolato? **Nessuno dei due: non è una superficie.**
Con **2 celle non esiste un altopiano per costruzione**, e il file prova lo
dichiarava già prima della corsa (`A1-bis`: *«A1 (altopiano di 3 celle) È
INAPPLICABILE: le celle sono due. Il round NON può concludere "c'è una
configurazione robusta"»*).
👉 Quindi la regola di casa **centro-mai-il-picco non si può nemmeno applicare**:
non c'è un vicino che confermi. L'unico controllo disponibile è la
**concordanza IS/OOS** — ed è esattamente quello che fallisce.

### ✅ Però una cosa la superficie la dice, ed è un risultato
`A3` (anti-altopiano-finto): due celle con `n` e PF identici alla quarta cifra
sarebbero **una cella misurata due volte**. Qui `n` fa 517 → 427 e PF fa
1,52365 → 1,77080. 🟢 **La manopola MORDE: `A5` (asse inerte) è escluso, e la
casella 3 del certificato di morte — «gestione dell'uscita messa ad asse almeno
una volta» — si chiude con un numero su 213 CSV d'archivio in cui
`InpUseTrailing` era `1` **213 volte su 213**.

---

## 2. ⚖️ L'INVERSIONE, GUARDATA IN FACCIA

### I QUATTRO NUMERI (PF e DD, IS e OOS, per le due celle)

| | **IS** trailing ON → OFF | **OOS** trailing ON → OFF |
|---|---|---|
| **PF** | 1,20110 → **1,10716** · 🔴 **−0,09394** | 1,52365 → **1,77080** · 🟢 **+0,24715** |
| **DD** | 5,7325% → **5,4988%** · 🟢 **−0,2337 pt** | 7,8323% → **7,4151%** · 🟢 **−0,4172 pt** |

### 🔬 E il quadro completo, perché due metriche non bastano

| metrica | verso in **IS** | verso in **OOS** | concorda? |
|---|---|---|---|
| Profit | 🔴 **−55,4%** (−2.540,22) | 🟢 **+21,1%** (+4.928,47) | ❌ **NO** |
| PF | 🔴 −0,09394 | 🟢 +0,24715 | ❌ **NO** |
| Recovery Factor | 🔴 −53,4% | 🟢 +26,7% | ❌ **NO** |
| **Equity DD** | 🟢 **meglio** | 🟢 **meglio** | ✅ **SÌ** |
| **Sharpe** | 🔴 **−65,0%** | 🔴 **−7,2%** | ✅ **SÌ (peggio)** |

🔴 **Le uniche due metriche che concordano fra le finestre sono il DD (meglio) e
lo SHARPE (PEGGIO).** Le tre metriche di **merito** si invertono tutte e tre.
👉 Lo Sharpe che scende *anche in OOS* mentre il profitto sale dice una cosa
precisa: **meno trade, più grassi, più volatili**. Il vantaggio OOS non è
nemmeno unanime dentro la sua finestra.

### 📐 IL GIUDIZIO SECONDO I CRITERI CONGELATI — non secondo il mio gusto

Criteri: `R136d_trailing_U30USD.txt` blocco *«COME LO DISTINGUO DA UN
MIGLIORAMENTO VERO»* + `A1..A10` in `R136a_slatr_U30USD.txt` rr.272-333.

| criterio congelato | esito | il numero |
|---|---|---|
| **1. Concordanza IS/OOS OBBLIGATORIA** — *«se il segno si inverte fra IS e OOS il verdetto è "non misurabile", non "metà buono"»* | 🔴 **FALLITO** | segno invertito su PF, profitto e RF |
| **2. DD non peggiora oltre `A7` (8,5%)** | ✅ **PASSATO** | 7,4151% e 5,4988%: **migliora** in entrambe |
| **3. Margine ≥ 0,10 di PF (`A9`)** | 🟠 **PASSA in OOS, NON in IS** | +0,24715 · in IS −0,09394 (vedi nota ⬇️) |
| **4. Profitto per POSIZIONE, non per uscita** | 🔴 **`[NON MISURATO]`** | posizioni della cella 0 ignote → **è il round R179a** |
| **5. Coerenza col terzetto b/c/d** | 🔴 **`[NON MISURATO]`**, due letture in disaccordo | vedi §2.2 |
| `A1` altopiano ≥3 celle | ⚪ **INAPPLICABILE** (`A1-bis`) | 2 celle |
| `A4` picco · `A8` centro dell'altopiano | ⚪ **INAPPLICABILI** | nessun vicino |
| `A6` verdetto | 🔴 richiede `A1` ⇒ **non si può scrivere** «c'è una configurazione migliore» | — |
| `A7` rischio a qualunque n | ✅ nessuna cella di rischio | max 7,8323% < 8,5% |
| `A10` il round non promuove niente | ✅ | nulla promosso |

> 🟠 **NOTA ONESTA SUL CRITERIO 3, e taglia in due direzioni.** Il divario IS
> sul PF è **−0,09394**, cioè **sotto** la banda di rumore di 0,10 che `A9`
> stessa ha congelato: *letto sul solo PF*, l'IS «non conferma» invece di
> «smentire». 🔴 **Ma sul PROFITTO lo stesso IS perde il 55,4%** e lo Sharpe il
> 65,0%: quello **non è rumore di nessuna banda dichiarata**. Due letture della
> stessa finestra in disaccordo ⇒ per la regola di casa il valore è
> `[NON MISURATO]` **con entrambi scritti**. In ogni caso il criterio 1 non si
> salva: **in IS un vantaggio non c'è**, e il criterio chiede che ci sia.

### 2.2 🔬 CRITERIO 5 — la coerenza col terzetto, e perché il test è malformato

Fonte: `..._OOS_r136c.csv` r.3 (`InpTP1Pct=0` ⇒ parziale **+** stop in pari **+**
trailing tutti spenti, perché tutti e tre sono agganciati a `beDone`).

| lettura | effetto del **solo trailing OFF** | effetto dei **tre meccanismi OFF** | il singolo sta DENTRO il totale? |
|---|---:|---:|---|
| su **PF** | +0,24715 | −0,24221 | 🔴 **NO** (0,24715 > 0,24221, **e segno opposto**) |
| su **Profitto** | +4.928,47 | −8.102,60 | ✅ **SÌ** |

🔴 **Il criterio 5, come è scritto, FALLISCE.** Ma la causa non è un round che
misura un'altra cosa: **il PF è un RAPPORTO, e i rapporti non si sommano.** Il
test di annidamento è ben posto solo su una quantità additiva — il profitto — e
lì passa. 👉 Lo dichiaro come **difetto del criterio**, non come anomalia della
misura, e il valore resta `[NON MISURATO]` con **entrambe** le letture scritte.

🟢 **E la decomposizione, fatta sul profitto, dice una cosa che vale l'intero
terzetto**: `parziale + stop in pari` = **+13.031,07** di profitto OOS e
**+0,48936** di PF (r136c cella 0 → r136d cella 0). **Il parziale è dove sta
l'edge della gestione; il trailing gli costa 4.928,47 sopra.**

---

## 3. 📏 IL CAMPIONE — e qui c'è il fatto che decide

🔴 **`Trades` nel CSV conta DEAL, non POSIZIONI** (classe 226), e l'Emendamento A
del 16/08 si decide sulle **operazioni**. Il fattore deal/posizione su questa
sedia è **MISURATO in due valori diversi**:

| finestra | deal | posizioni | fattore | fonte |
|---|---:|---:|---:|---|
| IS | 237 | **132** | **1,79545** | `report/EMA200_DOW_COSA_MANCA_PER_IL_1_OTTOBRE_2026-09-17.md` rr.213-217 (5 notti) |
| OOS | 517 | **257** | **2,01167** | `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` (518 righe, `position_id` distinti = 257, **ricontato da me il 18/09**) |

### Confronto col pavimento dei 150 **per finestra**

| cella | finestra | posizioni | vs 150 | conseguenza |
|---|---|---:|---|---|
| ON (viva) | IS | **132** `[MISURATO]` | 🔴 **SOTTO (−12%)** | **merito SOSPESO**, rischio si legge (Em. B) |
| ON (viva) | OOS | **257** `[MISURATO]` | ✅ sopra | merito leggibile |
| OFF | IS | **`[NON MISURATO]`** (194 deal) | — | banda ai fattori misurati: **95–111** ⇒ 🔴 **sotto** `[STIMATO]` |
| OFF | OOS | **`[NON MISURATO]`** (427 deal) | — | banda 208–244 ⇒ ✅ sopra `[STIMATO]` |

🔴 **L'IS di questa sedia, in POSIZIONI, sta SOTTO il pavimento su entrambe le
celle.** E non è una scusa trovata dopo: `A2` lo aveva **pre-dichiarato** prima
della corsa (*«E L'IS È SOSPESO PER COSTRUZIONE SU TUTTE LE CELLE… L'IS di questo
round serve al SEGNO e al RISCHIO, non al merito»*).
👉 **Quindi il segno IS è usabile — `A2` lo dice esplicitamente — e il segno IS
è NEGATIVO.** Non c'è scappatoia: il criterio 1 resta fallito, e la finestra che
lo farebbe passare **non esiste ancora**.

---

## 4. 💰 QUANTO VALE IN PRATICA — e l'interazione col parziale

### 4.1 Il DD, riscalato
Il backtest gira a `InpRiskPercent=1.0`, deposito 100.000 (`R136d` blocco BANCO).
Riscalatura lineare a 0,65%:

| | DD @1,0% `[MISURATO]` | DD @0,65% `[STIMATO]` |
|---|---:|---:|
| cella viva (trailing ON) | 7,8323% | **5,091%** |
| trailing OFF | 7,4151% | **4,820%** |
| **guadagno** | **0,4172 pt** | **0,271 pt** |

⚠️ `[STIMATO]` e non `[MISURATO]`: il DD **non** scala esattamente in modo
lineare col rischio (dipendenza dal percorso + capitalizzazione). Il verso è
sicuro, la terza cifra no.
📐 In budget di muro prop: 5,091% consuma il **50,9%** di un muro al 10%,
4,820% ne consuma il **48,2%**. **Il trailing OFF libererebbe ~2,7 punti
percentuali di budget.** 🔴 **Non commento taglie né livelli di rischio: sono
firma di Claudio.**

### 4.2 🔴 E IL DD MIGLIORA ANCHE PER UNA RAGIONE CHE NON È MERITO
Il file prova `R136d` **si aspettava il DD PIÙ ALTO** a trailing spento
(*«atteso PIÙ ALTO… banda 6%-12%»*). È uscito **più BASSO**. Il valore cade
dentro la banda, ma **il verso della previsione è sbagliato** — e un modello che
sbaglia il verso sul *rischio* è un modello che non abbiamo capito.
👉 L'altra spiegazione, e va scritta: **la cella 0 fa MENO posizioni** (427 deal
contro 517), e meno posizioni = meno esposizione = meno DD. **Parte di quello
0,4172 è COMPRATO CON LA FREQUENZA, non guadagnato con la geometria.** Questo
round non separa le due cose (servirebbe un DD normalizzato per esposizione, che
il tester non stampa): **buco dichiarato**.

### 4.3 ✅ SÌ, TRAILING E PARZIALE INTERAGISCONO — ed è **asimmetrico**

Letto nel codice: `mql5/Experts/ABTG_EMA200.mq5` r.436
`if(InpUseTrailing && beDone && e14>0)`. **Il trailing è sotto la guardia
`beDone`, che è la stessa che accende lo stop in pari, e che diventa `true` solo
quando scatta il parziale.**

| esperimento | è pulito? | perché |
|---|---|---|
| **trailing OFF, parziale ON** (`r136d` cella 0) | ✅ **SÌ, 1 meccanismo** | il parziale resta, `beDone` resta, cade solo l'inseguimento |
| **parziale OFF** (`r136c` cella 0, `InpTP1Pct=0`) | 🔴 **NO, 3 meccanismi** | spegne parziale **+** stop in pari **+** trailing insieme |

👉 **Si può provare il trailing da solo. NON si può provare il parziale da solo.**
Quindi «provarli separatamente inganna» è vero **in una sola direzione**, e la
lettura del 12/09 regge: il DD OOS a parziale spento va a **13,9367%**
(`..._OOS_r136c.csv` r.3, `n`=165 deal) — 🔴 **oltre il muro del 10%**. **È il
parziale che tiene il DD sotto il muro, non il trailing.**
🟢 E infatti il trailing, spento, il DD lo **abbassa**: i due meccanismi non
lavorano nella stessa direzione sul rischio.

### 4.4 🎯 IL NUMERO CHE DECIDE SE VALE LA PENA — e oggi non esiste
Profitto per **posizione** della cella viva, OOS:
**23.321,47 / 257 = 90,745** `[MISURATO]`.
Per la cella 0 il numeratore è noto (28.249,94 `[MISURATO]`), il denominatore
**no**.

| fattore deal/posizione | posizioni | profitto/posizione | vs 90,745 | pos/giorno (su 276 feriali) |
|---:|---:|---:|---:|---:|
| 1,75 | 244 | 115,78 | +27,6% | 0,884 |
| **1,79545** (misurato IS) | 238 | 118,79 | +30,9% | 0,862 |
| **2,01167** (misurato OOS) | 212 | 133,09 | **+46,7%** | 0,769 |
| **1,37162 = PAREGGIO** | **311** | **90,745** | **0,0%** | 1,128 |

🔴 **Il pareggio sta a 311 posizioni**, cioè a un fattore di **1,37162** — sotto
**entrambi** i fattori mai misurati su questa sedia. **Quindi il verso è atteso
(meglio per posizione), ma la TAGLIA è `[NON MISURATO]`** — e fra +27,6% e
+46,7% ci sono due contratti diversi. **Per questo serve R179a.**

---

## 5. 🛠️ PARTE 2 — IL FILE PROVA PRONTO (non armato)

📄 **`backtest_pipeline/prove/R179a_posizioni_trailingOFF_U30USD.txt`**
✅ `controlla_prova.py`: **`pin=43 celle=2 problemi=0 ESITO: OK`** (stesso conteggio
di pin di `R136d` ⇒ è la stessa cella con un asse scambiato).

| voce | valore |
|---|---|
| cella | `R136d` cella 0 = sedia viva con `InpUseTrailing=false` **pinnato** |
| **asse** | 🔴 **TECNICO sul magic**: `InpMagic=786410||786410||1||786411||Y` (gemelli vergini: `grep -rl` ⇒ 0 file) |
| `@FRAZIONEIS` | **0.40**, dichiarato, con la conseguenza scritta |
| costo | **4 passate ≈ 1,5 min** (ritmo R112: 0,375 min/passata) |
| artefatto | `Common\Files\abtg_trades_ABTG_EMA200_U30USD_786410.csv` (+ `...786411`), **gamba OOS** |

### 🔴 PERCHÉ L'ASSE **NON** È `InpUseTrailing`, come chiedeva il mandato
**Quella combinazione non può funzionare, e non è un'opinione — è nel codice:**
1. il nome del per-trade contiene **solo il magic** (`ABTG_EMA200.mq5` r.619);
2. si apre in `FILE_WRITE` ⇒ **troncamento** (r.620): ogni passata dello stesso
   magic **cancella** la precedente;
3. ⇒ con asse `InpUseTrailing` le due celle **condividono il magic** e **una
   delle due va persa**, e il per-trade **non porta nessun campo** che dica
   quale è rimasta (r.622: `close_time·symbol·magic·position_id·deal_type·
   volume·price·net_profit` — `InpUseTrailing` **non c'è**).
   Col mapping passata→valore misurato in `..._OOS_r136d.csv` (Pass=0 ↔ valore 0,
   Pass=1 ↔ valore 1), la superstite sarebbe la cella **con** il trailing:
   **un round intero per riprodurre le 257 posizioni che abbiamo già.**

🟢 Due magic gemelli risolvono **tutto in una mossa**: due file distinti (niente
sovrascrittura) **+** il cancello **G1 di determinismo** gratis (i due conteggi
devono essere identici — `CHECKLIST_RIGA_DI_LANCIO.md`, regola tripla punto 3).
💰 **Costa 4 passate invece di 2**: una cella sola significa **zero assi Y**, e
`controlla_prova.py` (controllo 4) la **rifiuta**. I 45 secondi in più comprano
la verifica di determinismo su un numero che poi useremo per decidere.

### 🧊 I criteri congelati NEL FILE, prima dei numeri (B1..B10, severi)
- **B1 sentinella S1**: i due CSV devono riprodurre `r136d` cella 0 **alla quarta
  cifra** (IS 2045.18 / 1.10716 / 5.4988 / 194 · OOS 28249.94 / 1.77080 / 7.4151
  / 427). Una colonna che non torna ⇒ **`ESITO: NON MISURATO`**, non si legge il
  resto. *Cancello gratis: il numero di confronto è già in repo.*
- **B2 G1**: gemelli con righe **e** conteggi identici, o la misura non si legge.
- **B3**: si stampano **deal, posizioni e rapporto** per entrambi i gemelli, con
  tre esiti distinti (file assente / sola intestazione / N).
- **B4 banda di forma**: fattore fuori da **1,75–2,05** ⇒ nessuna conclusione di
  merito, si cerca la causa.
- **B5**: posizioni OOS < 150 ⇒ **merito sospeso** (rischio no).
- **B6 «il trailing OFF è meglio»** richiede **tutte e quattro**: B1+B2 ok ·
  posizioni ≥ 150 · profitto/posizione ≥ **99,82** (= +10%, cioè `P ≤ 283`) ·
  **e la concordanza IS/OOS, che questo round NON può dare.**
  🔴 **Verdetto massimo ammesso, congelato adesso**: *«vantaggio di profitto per
  posizione MISURATO nella sola finestra OOS, e NON MISURATO come miglioramento
  finché una TERZA finestra o una PROVA DI REGIME non concorda».*
- **B7 «il default va bene»**: `283 ≤ P ≤ 345`. · **B8 «è PEGGIO»**: `P ≥ 346`.
- **B9**: il DD non si rimisura e il contratto della sedia (7,8323%) non cambia.
- **B10**: **non promuove niente.** Nessun preset, nessuna sedia, nessun forward,
  nessun conto reale.

### ⚠️ E il trasporto, scritto nel file
Il per-trade finisce in `Common\Files` e **la corsia ROUND del runner non ha un
canale per il per-trade** (zero occorrenze di `abtg_trades` in `runner_abtg.ps1`,
`righe\RIGA_SOTTILE_ROUND.ps1`, `righe\RIGA_ROUND_VPS.ps1` — misurato
nell'intestazione di `CODA_12_pertrade_posizioni.ps1`): i conteggi li stampa
**CODA_12**. E **il trasporto dei CSV di riepilogo è fermo dal 13/09**
(`report/IL_TRASPORTO_E_FERMO_2026-09-17.md`, 47 round illeggibili): **il round
può girare stanotte e il CSV arrivare giorni dopo.** Non è un motivo per non
pre-posizionare 90 secondi di macchina — è un motivo per saperlo prima.

---

## 6. 🚫 NESSUN CERTIFICATO DI MORTE — cosa manca, per nome

**La porta resta APERTA.** Perché diventi un miglioramento servono, in ordine di
costo:
1. 🟡 **le POSIZIONI della cella 0** → `R179a`, **1,5 minuti di macchina**, file
   pronto e passato dal cancello;
2. 🟠 **una TERZA finestra o una PROVA DI REGIME** che rompa il pareggio fra un
   IS negativo e un OOS positivo — è **l'unica cosa** che può riparare il
   criterio 1. Costo `[NON STIMATO]` in questo dossier;
3. ⚪ **le posizioni IS della cella 0**, che `R179a` **non** produce (il
   per-trade IS viene sovrascritto dall'OOS).

🔴 **E la cosa che NON va rimessa in discussione**: sulla **frequenza** il
trailing OFF **peggiora**, ed è chiuso dal codice (r.322: l'EA non arma finché la
casella è occupata; trailing OFF = posizione tenuta più a lungo = ingressi ≤).
`R179a` mette solo il **numero** al posto del verso: pos/giorno attese
**0,754–0,884** `[STIMATO]` (su 276 feriali) contro **0,931** della cella viva — 🔴 entrambe sotto
il pavimento di **1,00 per famiglia**.

---

### 🧾 Buchi dichiarati di questo dossier
- ⚠️ **Tutti i numeri sono di un banco a TICK REALI ma con GUARDIAN fail-open nel
  tester** (come R112 e R136d): confrontabili fra round, **non** descrivono il
  campo.
- ⚠️ **Un solo regime** (21 mesi di indice in salita). Regola C dell'Emendamento
  della Finestra: **non soddisfatta**.
- ⚠️ **Lato short da solo**: `[NON MISURATO]`. Gira L+S come la sedia viva.
- ⚠️ **Riscalatura del DD a 0,65%**: `[STIMATO]`, lineare, verso sicuro e terza
  cifra no.
- ⚠️ **Il denominatore dei giorni feriali OOS e' esso stesso `[NON MISURATO]`**:
  **276** (ricalcolo) contro **272** (referto 17/09 §3.3) —
  `report/EMA200_IL_PAVIMENTO_DI_FREQUENZA_2026-09-17.md` r.53, **due valori di
  casa scritti entrambi**. Tutte le pos/giorno di questo dossier usano **276**,
  cioè il valore **sfavorevole**.
- ⚠️ **I 3 deal in eccesso** su 517 = 2×257+3 non sono attribuiti:
  `[NON MISURATO]`.


---

# 🎯 IL VERDETTO, SCRITTO LO STESSO GIORNO E A ZERO MINUTI DI MACCHINA (17/09/2026)

> Il cancello di giudizio su `R179a` ha bocciato l'armamento con la ragione
> migliore possibile: **il numero che il round voleva contare esisteva già.**
> Verificato da me sui cinque log del runner.

## Il numero mancante: **215 posizioni**

```
backtest_pipeline/coda/referti/CODA_12_pertrade_posizioni_20260917_033003.log
r.209-214   abtg_trades_ABTG_EMA200_U30USD_786400.csv
            deal uscita: 427
            POSIZIONI  : 215
            rapporto   : 1.986
            close_time : dal 2025.06.12 13:44:51 al 2026.06.26 16:30:02
```

**Identico nelle notti 13, 14, 15, 16 e 17/09**, cinque scritture fresche:
`427 / 215 / 1,986`. `[MISURATO]`

**La cella è identificata da tre fatti indipendenti**, non da una convenzione:
427 deal = la colonna `Trades` della riga `Pass=0` (la cella ON fa **517**) ·
la finestra `close_time` cade dentro l'OOS · il primo `close_time` è identico
**al byte** alla prima riga del per-trade di R112 → **stesso banco**.

## 📊 IL CONFRONTO CHE CONTA — profitto per POSIZIONE

| | posizioni | profitto OOS | **profitto / posizione** |
|---|---:|---:|---:|
| trailing **ON** (cella viva) | 257 | 23.321,47 | **90,745** |
| trailing **OFF** | **215** | 28.249,94 | 🟢 **131,395** |
| | −16,3% | +21,1% | 🟢 **+44,8%** |

## 🟠 IL VERDETTO, nella forma massima che i criteri congelati ammettono

> Con `InpUseTrailing=false` la sedia `ABTG_EMA200` U30USD H1 fa **215
> posizioni** in OOS (427 deal, fattore 1,986) contro le **257** della cella
> viva, e il **profitto per posizione passa da 90,75 a 131,40: +44,8%**
> `[MISURATO]`. La frequenza scende a **0,779-0,790 posizioni/giorno feriale**,
> **sotto** il pavimento di 1,00 per famiglia.
>
> 🔴 **Il vantaggio è MISURATO nella sola finestra OOS, e resta NON MISURATO
> come MIGLIORAMENTO** finché una **terza finestra** o una **prova di regime**
> non concorda: in IS il segno si inverte (PF −0,09394, profitto **−55,4%**).

⚠️ **E un limite che non si nasconde**: 215 contro 257 posizioni sono
**−16,3% di esposizione in numero di trade**, quindi **una parte** del
miglioramento di drawdown (7,4151 contro 7,8323) **è comprata con la
frequenza, non con la geometria**. Il DD normalizzato per esposizione non è
una colonna del tester: `[NON MISURATO]`.

## 🚫 Nessun certificato di morte — e che cosa manca, per nome
1. ✅ le **posizioni OOS** della cella OFF: **chiuse**, 215;
2. 🟠 una **terza finestra o prova di regime**: l'**unica** cosa che può
   riparare il criterio di concordanza. Costo `[NON STIMATO]`;
3. ⚪ le **posizioni IS** della cella OFF (194 deal): `[NON MISURATE]`, e
   nessun round in casa le produce. Attesa dichiarabile prima: **97-108
   posizioni**. Costo: **1,5 minuti**. 👉 È l'unica cosa qui dentro che
   nessuno ha ancora misurato, e l'unica per cui valga accendere il tester.

📌 `R179a` **non è stato armato** ed è marcato `NON ARMARE` in testa al file,
con la ragione. Non è stato cancellato: i suoi criteri `B1..B10` sono serviti
a **leggere** questo numero, e il difetto stava nella ricerca, non nel
mestiere. → classe **411**.
