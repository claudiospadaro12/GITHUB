# 🌊 SUPERWAVE `770511` — LE 56 PASSATE FERME, E LA MISURA CHE C'ERA GIA'
## R227 · 23/09/2026 · sola lettura, zero minuti di macchina

> **Il mandato.** Due lavori a costo zero: (1) i **sette file prova sulla sedia `770511`**
> (SuperWave DOW H1, **che sta operando la challenge FTMO adesso**) scritti, gateati e **mai
> lanciati**, e **fuori** dalla coda R225; (2) **due round del 21/09 che nessuno ha mai aperto**
> (`R200C`, `R197B`).
>
> 🛑 **SOLA LETTURA.** Nessun round lanciato, nessuna riga consegnata a Claudio, niente VPS,
> nessun preset o `.set` toccato, nessuna sedia accesa o spenta, nessuna taglia e nessun
> parametro di rischio proposto. Conto reale `10105439` mai nominato in un comando.
> L'unico file modificato e' `backtest_pipeline/prove/R190b_tfM30_SUPERWAVEDOW_U30USD.txt`
> (una riga di dichiarazione, §3.6) — e ci ripassa dai cancelli dentro questo referto.

---

# 0️⃣ 🎯 LE CINQUE RIGHE CHE CONTANO

1. 🔴 **LA SCOPERTA PIU' GROSSA E' CHE IL DOSSIER DI STAMATTINA SBAGLIA IL SUO TITOLO #1.**
   `LE_MANOPOLE_INERTI_2026-09-23.md` §4.2 dichiara `InpTrailOnST` e `InpExitOnFlip` su
   `770511` *«mai ad asse · 0 CSV · 0 file prova»*. **Sono misurate da giorni, con un
   2×2 completo, su TUTTE E DUE le finestre, a TICK REALI.** Sei file prova
   (`R120b_*_00/01/10/11`, `R120e_*_00/11`) e **dodici CSV** in repo. Il rilevatore non li
   ha visti perche' **l'asse e' spezzato su FILE DIVERSI**, e lui cerca la variazione
   *dentro* un CSV. §2 — 🆕 **classe 628**.
2. 🟢 **E LA RISPOSTA CHE NE ESCE E' BUONA PER LA SEDIA VIVA: il trailing sul Supertrend
   PAGA, e il preset schierato ha ragione.** Banco 10.000, 2×2 completo:
   spegnerlo porta il PF IS da **1,489 a 0,903** e il Recovery Factor da **+1,208 a −0,184**,
   col DD che **sale** da 3,80% a 6,04%. E in OOS **il profitto sale mentre il DD scende**
   (273,91 → 344,12 con DD 6,23% → 4,17%): non e' l'illusione dello stop piu' largo, e'
   merito vero. 👉 **`InpTrailOnST=true` non va ne' provato ne' toccato: e' misurato e
   vince.** §2.3
3. 🔴 **`InpExitOnFlip` E' INERTE — e non "debole": IDENTICO CIFRA PER CIFRA in OOS.**
   Con il trailing acceso, accenderlo o spegnerlo da' `Profit 344,12 · PF 1,24312 ·
   RF 0,77764 · DD 4,1675 · n 131`, **due volte**. Il meccanismo si spiega: lo stop che
   insegue il Supertrend viene colpito **prima** che il Supertrend giri, quindi l'uscita sul
   giro non ha mai occasione di sparare. 👉 **Casella CHIUSA, non vuota.** §2.4
4. 💰 **I sette file: tutti e sette passano OGGI i due cancelli.** Le celle vere sono
   **30**, le passate **60** (il «56» del dossier era giusto sui sei che contava, ma
   **escludeva `R190b`** dandolo `[NON MISURATO]`: oggi lo strumento lo risolve, sono
   2 celle). 🔴 **Ma il costo vero NON e' «4,7 minuti»: e' 34,1 minuti**, perche' la stima
   contava solo il tester e **non i 2,0 minuti di avvio per round × 7 round**. §3
5. 📖 **`R200C` e `R197B`, letti per la prima volta: tutti e due CONFERMANO LA CELLA VIVA,
   e tutti e due chiudono una casella.** `R197B` dice che il retest del Dow **non e' troppo
   profondo** (la risposta alla domanda di Claudio del 21/09) e che **l'unico modo di
   peggiorarlo e' renderlo piu' corto**. `R200C` **uccide `R200d`** — un round che era in
   attesa e che ora non si fa piu'. §4

---

# 1️⃣ 📋 I SETTE FILE, PER NOME, COL LORO ESITO AI CANCELLI **OGGI**

Rigirati da me il **23/09/2026** su HEAD `e8d1964c`, tutti e due gli strati:
`python3 backtest_pipeline/controlla_riga.py --oggetto prova <file>` e
`python3 backtest_pipeline/controlla_prova.py <file>`.

| # | file prova (`backtest_pipeline/prove/`) | asse | celle **vere** | passate | `controlla_riga` | `controlla_prova` |
|---|---|---|---:|---:|---|---|
| 1 | `R173a_tp1pct_superwave_U30USD.txt` | `InpTP1Pct` 0/25/50/75 | 4 | 8 | ✅ nessun difetto | ✅ OK, 0 problemi |
| 2 | `R173b_tp1r_superwave_U30USD.txt` | `InpTP1_R` 0,5→2,0 p.0,5 | 4 | 8 | ✅ | ✅ OK |
| 3 | `R173c_breakeven_superwave_U30USD.txt` | `InpBreakeven` 0/1 | 2 | 4 | ✅ | ✅ OK |
| 4 | `R155a_tprr_SuperWaveDowH1_U30USD.txt` | `InpTP_RR` 2,0→4,0 p.0,5 | 5 | 10 | ✅ | ✅ OK |
| 5 | `R191b_tprr_SUPERWAVEDOW_U30USD.txt` | `InpTP_RR` 1,5→6,0 p.0,75 | 7 | 14 | ✅ | ✅ OK |
| 6 | `R165a_slbufferpips_superwave_U30USD.txt` | `InpSLBufferPips` 3→5003 p.1000 | 6 | 12 | ✅ | ✅ OK |
| 7 | `R190b_tfM30_SUPERWAVEDOW_U30USD.txt` | `InpTF` M30 vs H1 (ENUM) | **2** | 4 | ✅ | ✅ OK |
| | **TOTALE** | | **30** | **60** | **7/7** | **7/7** |

🟢 **Nessuno dei sette e' scaduto**, e non e' un'impressione: l'EA
`mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` e' fermo al commit **`b45dd009` del
11/09**, e i sette file sono stati scritti fra il **16 e il 19/09** — cioe' **dopo** l'ultima
modifica del motore. E `controlla_prova.py` riverifica **ogni nome di input contro il `.mq5`
di oggi** (`input SCONOSCIUTO all'EA`, r.155): 0 sconosciuti su 7 file.

### 1.1 🔍 Le tre verifiche che il dossier lasciava aperte, chiuse col numero

| verifica chiesta | esito | come l'ho misurata |
|---|---|---|
| **sono gia' girati?** | 🟢 **NO, nessuno dei sette** | `find` su `risultati_prove/` + `risultati_archivio/` per le sette etichette: **0 file**. E il controllo indipendente, che non passa dal nome: `grep` dei sette **magic** (`779863 779867 779869 779803 787420 779828 789320`) su tutti i CSV di risultati: **0 occorrenze** |
| **`@DAQUANDO` precede il muro (classe 590)?** | 🟢 **NO** | tutti e sette portano `@DAQUANDO 2024.09.26`, che e' **esattamente** il muro dei tick reali degli indici BCM (`REFERTO_MISURA_TICK_U30USD.txt`, 67.618.571 tick). Non un giorno prima |
| **il «56» del dossier regge?** | 🟠 **si', ma sui SEI che contava** | 28 celle × 2 = 56 e' giusto per i sei; il settimo (`R190b`) il dossier lo scriveva `[NON MISURATO]` perche' e' un ENUM. Oggi `controlla_prova.py` lo risolve da solo: **2 celle** (i soli membri di `ENUM_TIMEFRAMES` fra 30 e 16385 sono M30 e H1). 👉 **il totale vero e' 30 celle / 60 passate** |

---

# 2️⃣ 🔴 IL RITROVAMENTO: `InpTrailOnST` E `InpExitOnFlip` **SONO GIA' MISURATI**

## 2.1 Il contro-esempio, costruito PRIMA di scrivere la tabella

Il dossier di stamattina si era salvato da una trappola simile (`A1_SUPREV_DOW_H1_01_trailonst.txt`
e' di **un altro EA**, `ABTG_SupRev_DOW_H1_Ottimizzato`). **Ho dovuto provare a rompere il mio
ritrovamento nello stesso modo**, e non si rompe — tre controlli indipendenti:

1. **L'intestazione.** `backtest_pipeline/prove/R120b_U30USD_{00,01,10,11}.txt` e
   `R120e_U30USD_{00_nuda,11_vivo}_TAGLIA.txt` portano tutti a **r.3**:
   `#  EA: ABTG_SuperWave_DOW_H1_Ottimizzato`. Non SupRev.
2. **Le colonne dei CSV.** I dodici file in
   `backtest_pipeline/risultati_prove/dal_vps/ABTG_SuperWave_DOW_H1_Ottimizzato/` hanno
   **53 colonne** e contengono `InpFirstFraction`, `InpUsePending`, `InpPendingExpiryBars`,
   `InpTP1_R`, `InpTP_RR`: e' l'insieme di input di **SuperWave**.
3. **La citazione incrociata, che e' la piu' forte.** Il file `R190b` — uno dei sette — indica
   **`r120e11` come proprio ANTENATO e ANCORA** e ne riporta i numeri. 👉 Se `r120e11` fosse di
   un altro motore, sarebbe rotto `R190b`, non questo referto.

## 2.2 Perche' il rilevatore non li ha visti — 🆕 **CLASSE 628**

`manopole_inerti_v2.py` cerca il **gruppo *ceteris paribus* dentro un CSV**: passate che
differiscono **solo** per la manopola in esame. Qui la manopola **non varia dentro nessun CSV**:
ogni file prova la **pinna** (`InpTrailOnST=false||false||0||false||N`) e l'asse e' realizzato
**spostandosi da un file all'altro** — un **fattoriale 2×2 a quattro corse separate**.

🔴 **E l'errore e' successo DUE VOLTE, a due agenti con due strumenti diversi.** Il dossier del
**21/09** (`CELLE_MIGLIORI_GIA_MISURATE_2026-09-21.md` r.325) ha aperto **gli stessi file** e ha
scritto: *«gli assi tecnici di `770511` (`r120b00/01/10/11`, `r120e00/11`) fanno 2 passate e 1
esito ... il cancello G1 di determinismo e' PASSATO»*. 🟢 **Quella frase e' VERA** (le due righe
di ogni CSV sono i gemelli sul magic). 🔴 **Ma e' la lettura DENTRO il file**, e nessuno ha
messo i quattro file **in colonna**. Classe scritta in `CHECKLIST_RIGA_DI_LANCIO.md`.

## 2.3 🟢 IL 2×2 COMPLETO, banco **10.000**, tick reali, U30USD H1, 2024.09.26→2026.06.30, taglio 0,40

*(Deposito **riverificato**, non assunto — classe 604: `capitale = (Profit/RF)/(DD%/100)` da'
**10.071–10.857** su tutte e otto le passate di `R120b`. Le celle `R120e` girano a **100.000**
(103.698–106.437) e **stanno in una tabella SEPARATA**, §2.5.)*

| cella | `InpTrailOnST` | `InpExitOnFlip` | **IS** PF | **IS RF** | IS DD% | IS n | **OOS** PF | **OOS RF** | OOS DD% | OOS n |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `r120b00` | ❌ off | ❌ off | 0,90317 | **−0,18371** | 6,0412 | 46 | 1,18671 | 0,43106 | 6,2319 | 90 |
| `r120b01` | ❌ off | ✅ on | 1,40616 | 1,07325 | 4,4474 | 71 | **0,98333** | **−0,05919** | 5,1132 | 125 |
| `r120b10` | ✅ on | ❌ off | **1,48914** | **1,20758** | **3,8036** | 72 | **1,24312** | **0,77764** | **4,1675** | 131 |
| `r120b11` | ✅ **on** | ✅ **on** *(= PRESET VIVO)* | 1,48166 | 1,12316 | 4,0393 | 72 | **1,24312** | **0,77764** | **4,1675** | 131 |

**Come si legge, con le regole di casa applicate una per una:**

- 🥇 **`InpTrailOnST` e' la manopola che porta l'edge.** A parita' di `ExitOnFlip=off`
  (00 → 10): PF IS **0,903 → 1,489**, RF IS **−0,184 → +1,208** (cambia **segno**),
  DD IS **6,04% → 3,80%**. In OOS: PF **1,187 → 1,243**, RF **0,431 → 0,778**,
  DD **6,23% → 4,17%**.
- 🔴 **E qui il tranello della regola 1 NON scatta, e lo dimostro invece di affermarlo.**
  «Un DD che scende non e' merito se scende anche il profitto». Qui il DD scende **e il
  profitto SALE**: OOS `Profit` **273,91 → 344,12** (+25,6%) mentre il DD va da 6,23% a
  4,17%. Sono le due cose che devono muoversi in direzioni opposte, e si muovono cosi'.
  👉 **merito vero, non aritmetica del lotto.**
- ⚠️ **L'onesta' sul campione**: `n` **non e' costante** lungo l'asse (46→72 IS, 90→131 OOS).
  Non e' quindi un confronto d'uscita "a ingressi fermi": spegnendo il trailing le posizioni
  restano aperte piu' a lungo e la sedia salta segnali successivi. **Il verso resta leggibile**
  (tutte e due le finestre concordano di segno sul trailing), il **livello** va preso con
  quella cautela.
- 📏 **E il merito, alla lettera di casa, e' SOSPESO**: `InpTP1Pct=50` e' acceso in tutte e
  quattro le celle → **classe 550, `Trades` conta USCITE, non posizioni**. Le 131 uscite OOS
  sono fra **66 e 131 posizioni**: **sotto le 150**. 👉 Quello che si legge senza riserve e' il
  **RISCHIO** (Emendamento B, a qualunque `n`), ed e' la parte buona: **DD 3,80–6,23%** su
  tutte e otto le passate.

## 2.4 🔴 `InpExitOnFlip`: INERTE quando il trailing e' acceso — la definizione stretta

A `InpTrailOnST=true` (b10 contro b11), **OOS**:

```
r120b10   Profit 344,12   PF 1,24312   RF 0,77764   DD 4,1675   n 131
r120b11   Profit 344,12   PF 1,24312   RF 0,77764   DD 4,1675   n 131
                ^^^^^^^          ^^^^^          ^^^^^       ^^^^^^    ^^^
                IDENTICI CIFRA PER CIFRA -- e non sono i gemelli sul magic:
                sono DUE FILE PROVA DIVERSI, con due magic diversi (783220/783221
                contro 783200/783201).
```

E' la definizione di **INERTE** del dossier di stamattina (uguali alla 5ª decimale), non di
«influenza debole». In **IS** la differenza esiste ma e' minuscola e **dalla parte sbagliata**
per la cella viva: `ΔPF = 0,00748` a favore di **`off`**, `Δn = 0`, `ΔDD = 0,236 pp`.

🔬 **E c'e' una spiegazione meccanica nel sorgente, non un'ipotesi.**
`ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.428 aggancia lo stop alla linea Supertrend e il
blocco di trailing (r.467) gira **solo** `if(haveST)`: lo stop **insegue** il Supertrend, quindi
**viene colpito al giro o prima**. Quando il Supertrend gira, la posizione **e' gia' chiusa
dallo stop**: l'uscita sul giro non ha mai occasione di sparare.

🟠 **Il rovescio, che va detto perche' e' l'unica cosa che `InpExitOnFlip` fa davvero**: a
trailing **spento** la manopola morde eccome — e **male**: `01` contro `00` fa
PF IS **0,903 → 1,406** ma PF OOS **1,187 → 0,983**, con RF che **cambia segno fra le due
finestre** (+1,073 IS, −0,059 OOS). **Segni discordi = rumore**, regola di casa. 👉 Non e' un
ripiego: e' una cella da non toccare.

**Conclusione operativa, e non e' un round:**
> 🟢 **La configurazione viva (`InpTrailOnST=true`, `InpExitOnFlip=true`) e' gia' la migliore o
> pari-merito sulle quattro celle, in tutte e due le finestre, su RF e su PF.** L'unica
> alternativa che la tocca (`b10`, flip spento) e' **identica in OOS** e meglio di 0,007 di PF in
> IS: **dentro il rumore**. 👉 **La risposta onesta e' «il preset va bene»** — ed e' un
> risultato, non un fallimento.

## 2.5 La tabella a **100.000** — separata, perche' e' un altro banco (classe 604)

| cella | TrailOnST | ExitOnFlip | IS PF | IS RF | IS DD% | IS n | OOS PF | OOS RF | OOS DD% | OOS n |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `r120e00` | ❌ | ❌ | 0,97751 | −0,05300 | 5,0668 | 74 | **1,28437** | 0,72504 | 6,5252 | 130 |
| `r120e11` | ✅ | ✅ | **1,39744** | **1,14216** | **3,4846** | 106 | 1,22034 | **0,77286** | **4,2149** | **184** |

🔴 **E questa e' l'unica riga dove le due metriche litigano, quindi va letta con la regola
scritta prima**: in OOS `e00` vince su PF (1,284 contro 1,220) e su `Profit` (4.950,89 contro
3.454,83) — **ma il RF, che e' il discriminante, sta con `e11`** (0,77286 contro 0,72504), il DD
e' **un terzo piu' basso** (4,21% contro 6,53%) e le operazioni sono **+41%** (184 contro 130).
👉 **La cella viva vince anche qui, sul criterio dichiarato.**

🟢 **E il confronto fra le due tabelle e' la prova sperimentale della classe 453/366**: stessa
cella, stesso simbolo, stessa finestra, stesso modello, **solo il banco cambia** →
**IS n 72 → 106 (+47%)**, **OOS n 131 → 184 (+40%)**. E' il motivo per cui `R190b` senza il
deposito dichiarato sarebbe finito nel cestino (§3.6).

## 2.6 🔴 CHE COSA RESTA DAVVERO VUOTO SU `770511` — l'elenco corretto

Il dossier ne elencava **sei**. Dopo questa verifica sono **quattro**, e sono tutte della
famiglia dell'**INGRESSO A DUE GAMBE**, non dell'uscita:

| manopola | preset vivo | CSV in archivio | file prova | stato |
|---|---|---:|---:|---|
| ~~`InpTrailOnST`~~ | `true` | **12** | **6** | ✅ **MISURATA** (§2.3) — casella chiusa |
| ~~`InpExitOnFlip`~~ | `true` | **12** | **6** | ✅ **MISURATA e INERTE** (§2.4) — casella chiusa |
| `InpFirstFraction` | `0.3333` | **0** | **0** | 🔴 **MAI AD ASSE** *(l'unico `R124a` e' su `ABTG_SupRev_DOW_H1_Ottimizzato`, altro EA — verificato a r.2)* |
| `InpUsePending` | `true` | **0** | **0** | 🔴 **MAI AD ASSE** |
| `InpPendingPips` | `20.0` | **0** | **0** | 🔴 **MAI AD ASSE** |
| `InpPendingExpiryBars` | `3` | **0** | **0** | 🔴 **MAI AD ASSE** |

🔬 **E le quattro non sono quattro domande: sono UNA.** Nel sorgente (r.381, r.405-410) la
taglia va `lotMkt = totLot × InpFirstFraction` a mercato e il resto su un **pendente stop** a
`InpPendingPips` con scadenza `InpPendingExpiryBars`. Il blocco intero gira sotto
`if(InpUsePending && lotPend>0)`. 👉 **`InpUsePending=false` spegne tutte e quattro insieme**, ed
e' l'asse da 2 celle che vale piu' di tutti: dice **se l'ingresso a due gambe serve**, prima di
spendere celle a tararlo. **Il file prova NON esiste e va scritto** — non lo scrivo io in questo
giro, lo dichiaro come buco (§6).

---

# 3️⃣ 📐 I SETTE ORDINATI PER VALORE, COL COSTO VERO

## 3.1 🔴 Il minuto-per-cella: da dove viene, e perche' non e' quello del dossier

Il dossier stimava **5,0 s/passata** dichiarandola *calibrazione TRASFERITA* (misurata su
U30USD **M5**), con forbice onesta **2,7–31 minuti**. **Ne esiste una migliore, misurata in
casa ieri**, ed e' quella che la riga R225 usa gia':

> **ANCORA `R202A` (21/09/2026, `DESKTOP-H4D7CAJ`)** — stesso driver, **`ABTG_Dow_Apertura_US`
> U30USD modello 4**: 8 passate fra le 23:24:38 e le 23:27:19 = **161 s = 20,1 s/passata =
> **0,670 minuti per CELLA** su una finestra di **642 giorni**.

🟢 **E qui il trasferimento e' quasi nullo, perche' il denominatore combacia**: i sette file
girano **2024.09.26 → 2026.06.30 = 642 giorni esatti**, cioe' **il fattore di scala della
classe 625 vale 1,000**. Stesso simbolo (`U30USD`), stesso modello (tick reali), stessa
macchina.

⚠️ **Le due incertezze che restano, dichiarate:**
- **il TF**: l'ancora e' **M5**, questi sono **H1**. A tick reali il costo e' dominato dal
  **replay dei tick** (identico: stessa finestra, stesso simbolo); l'EA lavora **su ogni barra
  nuova**, e a H1 le barre sono **12 volte meno**. 👉 **0,670 e' un MASSIMO**, non una stima
  centrata — stessa convenzione del «massimo corrente che non scende mai sotto l'ancora» della
  riga R225.
- **il motore**: SuperWave apre e gestisce un **ordine pendente** per ogni segnale, `Dow_Apertura`
  no. E' lavoro in piu' per posizione, ma su **72–184 posizioni** contro decine di milioni di
  tick: `[NON MISURATO]`, e coperto dal margine del massimo.

## 3.2 💰 IL COSTO, round per round

`attesa = 2,0 (avvio: download driver + compilazione MetaEditor + prima apertura terminale)
+ celle × 0,670 × (642/642)`

| ordine | file | celle | passate | **attesa** | deposito da passare |
|---:|---|---:|---:|---:|---|
| 1 | `R191b_tprr_SUPERWAVEDOW_U30USD.txt` | 7 | 14 | **6,7 min** | `100000` |
| 2 | `R173a_tp1pct_superwave_U30USD.txt` | 4 | 8 | **4,7 min** | `100000` |
| 3 | `R173c_breakeven_superwave_U30USD.txt` | 2 | 4 | **3,3 min** | `100000` |
| 4 | `R165a_slbufferpips_superwave_U30USD.txt` | 6 | 12 | **6,0 min** | `100000` |
| 5 | `R173b_tp1r_superwave_U30USD.txt` | 4 | 8 | **4,7 min** | `100000` |
| 6 | `R190b_tfM30_SUPERWAVEDOW_U30USD.txt` | 2 | 4 | **3,3 min** | `100000` ⚠️ §3.6 |
| ❌ | ~~`R155a_tprr_SuperWaveDowH1_U30USD.txt`~~ | 5 | 10 | 5,4 min | `10000` — **NON entra**, §3.5 |
| | **I SEI CHE PROPONGO** | **25** | **50** | **28,8 min** | |
| | *(tutti e sette)* | *30* | *60* | *34,1 min* | |

🔴 **Il «≈4,7 minuti» del dossier va corretto, e la causa e' una sola: contava solo il tester.**
Il calcolo puro di tester su 30 celle fa **20,1 minuti**; i **2,0 minuti di avvio × 7 round**
ne fanno **altri 14,0**. 👉 **34,1 minuti**, cioe' **7,2× la stima**. Resta poco — ma e' mezz'ora,
non cinque minuti, e con 38 round gia' in coda la differenza si somma.

## 3.3 🥇 L'ordine, e il perche' di ogni posto

1. **`R191b` — `InpTP_RR` 1,5→6,0, passo 0,75, 7 celle.** 🥇 **E' l'unico dei sette su cui
   l'ALTOPIANO E' OSSERVABILE**: sette celle contigue su un asse continuo, griglia **a passo
   fisso e non genetica**, quindi la regola «centro dell'altopiano, mai il picco» **si puo'
   applicare davvero**. E' la manopola d'uscita con la leva piu' lunga (il take profit finale) e
   la cella viva (`3,0`) **sta dentro** l'asse, non al bordo: 1,5 · 2,25 · **3,0** · 3,75 · 4,5 ·
   5,25 · 6,0. Anchor `r120e11` al deposito giusto.
2. **`R173a` — `InpTP1Pct` 0/25/50/75.** 🥈 **Perche' la sua cella `0` non e' un valore: e' un
   INTERRUTTORE.** Il gate a r.446 del sorgente e'
   `if(!beDone && risk>0 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100)`: con `InpTP1Pct=0`
   **spegne parziale E stop in pari insieme**. Risponde alla domanda strutturale *«la coppia
   serve?»* prima di spendere celle a tararla. 🟢 **E ha un effetto collaterale utile: la cella
   `0` toglie la parziale, quindi `Trades` torna a contare POSIZIONI** (classe 550) — e' l'unica
   cella dei sette che da' un `n` leggibile senza conversione.
3. **`R173c` — `InpBreakeven` 0/1.** 🥉 Il piu' economico di tutti (**3,3 min**) e non e' un
   doppione di `R173a`: **verificato nel sorgente**, il gate di r.446 **non contiene**
   `InpBreakeven`, quindi spegnerlo lascia il parziale acceso e **isola quale delle due meta'
   della coppia lavora**. Va **dopo** `R173a`: se `R173a` dice che la coppia non serve, questo
   diventa una curiosita'.
4. **`R165a` — `InpSLBufferPips` 3→5003.** 🟠 **Non e' una griglia di taratura: e' una PROVA DI
   MORSO su scala logaritmica**, e il file lo dichiara. 🔴 **E si porta dentro il proprio
   cancello di costo, gia' calcolato da lui**: alla cella `5003` il buffer vale 50,03 punti
   indice e il rapporto stop/spread scende a **23,7×**, **sotto il muro dei 40×** — la frontiera
   cade **fra 4003 e 5003**. 👉 **4 celle utili (3 · 1003 · 2003 · 3003) + 2 celle FUORI PER
   COSTO col numero accanto.** Vale la pena per la domanda «morde o no?», non per trovarci un
   valore da schierare.
5. **`R173b` — `InpTP1_R` 0,5→2,0.** 🟠 **Condizionato a `R173a`**: chiede *quando* deve scattare
   la coppia, e ha senso **solo se la coppia serve**. Se `R173a` incorona la cella `0`, queste
   4 celle (8 passate) sono spese su un blocco spento. 👉 **si lancia DOPO aver letto `R173a`**,
   non nella stessa infornata cieca.
6. **`R190b` — `InpTF` M30 vs H1.** 🟢 **In termini di VALORE sarebbe il primo**: e' l'unica
   strada rimasta verso il pavimento delle **150 operazioni** su questa sedia (oggi 106 IS / 184
   OOS al banco 100.000: mancano 44 operazioni che **in questa finestra non esistono**, perche'
   i tick BCM partono dal 2024.09.26 e piu' finestra non c'e'). 🔴 **Lo metto sesto per una
   ragione di PRONTEZZA, non di merito: fino a stamattina era ROTTO** (§3.6). Riparato oggi.
   **Promuovibile al 1° posto appena la riparazione e' in repo.**
7. ❌ **`R155a` — NON entra.** §3.5.

## 3.4 🔍 E la domanda che nessuno aveva fatto: `R191b` e `R155a` misurano LA STESSA MANOPOLA

Tutti e due mettono ad asse **`InpTP_RR`**, sulla **stessa sedia**, sullo **stesso simbolo**.
Metterli tutti e due in coda vuol dire **24 passate su una manopola sola**.

| | `R155a` (17/09) | `R191b` (19/09) |
|---|---|---|
| campo | 2,0 → 4,0 passo 0,5 (**5 celle**) | **1,5 → 6,0** passo 0,75 (**7 celle**) |
| walk-forward | 🔴 `@FRAZIONEIS 1.0` = **una sola tranche** | ✅ `@FRAZIONEIS 0.40` = IS + OOS veri |
| banco | `10000` | `100000` |
| ancora | `R126a` (n 72 IS / 131 OOS) | `r120e11` (n 106 IS / 184 OOS) |

## 3.5 ❌ PERCHE' `R155a` NON ENTRA IN CODA — tre motivi, tutti con un numero

1. 🔴 **La sua gamba OOS e' DEGENERE, e lo dice il driver.** `walkforward_generico.ps1` r.744-746:
   con `FrazioneIS >= 1.0` stampa *«UNA SOLA TRANCHE. La gamba OOS e' DEGENERE (finestra vuota):
   il CSV `_OOS` non descrive niente»*. L'aritmetica a r.934-937 lo conferma:
   `Meta = Inizio + 642×1,0 = 2026.06.30`, quindi la finestra OOS parte il **2026.07.01** e
   finisce il **2026.06.30** — **inizio dopo la fine**. 👉 **5 delle sue 10 passate non
   descrivono niente**, e per la regola di casa un allargamento **si paga con una prova fuori
   campione**: questo round **non ce l'ha**.
2. 🔴 **Il suo banco non e' quello degli altri sei** (`10000` contro `100000`) — e su **questa**
   EA il banco cambia `n` del **+40/+47%** (§2.5, misurato). **Classe 604: i suoi numeri non
   possono andare in colonna con quelli di `R191b`.** Non e' un difetto del file (dichiara e
   motiva il suo 10.000 per l'ancora `R126a`, ed e' la classe 366): e' un'**incompatibilita' di
   pacchetto**.
3. 🟠 **Il campo e' un sottoinsieme piu' grosso**: `R191b` copre 1,5–6,0, `R155a` 2,0–4,0. L'unica
   cella in comune e' **3,0**, che e' l'ancora.

👉 **Verdetto: `R155a` e' SUPERATO da `R191b`, non rotto.** Risparmio: **10 passate, 5,4 minuti**.
🔴 **E non si archivia come morto** — non ha certificato: **resta «NON ANCORA MISURATO», e cio'
che manca e' scritto qui**: gli serve `@FRAZIONEIS 0.40` (una riga) per avere un OOS vero. Se un
giorno servisse il confronto **al banco 10.000**, e' gia' pronto con quella modifica.

## 3.6 🔧 `R190b` ERA ROTTO — e il difetto e' la classe che lui stesso ha generato

🔴 **Il file NON dichiarava `-Deposito`** (`grep` su `depos|10000|100000|Modello`: **zero
occorrenze** prima di oggi). Il default vale **10.000**
(`walkforward_generico.ps1` r.200, `RIGA_ROUND_VPS.ps1` r.94), e la sua cella H1 e' un'**ANCORA**
che deve riprodurre **`r120e11`, girata a 100.000**.

**Conseguenza, con i numeri misurati in §2.5**: a 10.000 l'ancora avrebbe restituito **n≈72/131**
invece di **106/184**. E il file stesso (r.217 della versione originale) dice:
> *«SE L'ANCORA NON RIPRODUCE, IL ROUND NON SI LEGGE. Non si guarda la cella M30: si riapre il
> baco.»*

👉 **Il round sarebbe stato buttato per un argomento della riga di lancio, non per un fatto di
mercato** — e la diagnosi sarebbe stata *«si riapre il baco del determinismo»*, cioe' ore su un
guasto inesistente.

🔴 **E la parte che brucia: questa classe ESISTE GIA' ED E' NATA SU QUESTO FILE.**
`CHECKLIST_RIGA_DI_LANCIO.md` r.25234-25236, **CLASSE 453 del 19/09**, cita
`R190b_tfM30_SUPERWAVEDOW_U30USD.txt` **per nome** e prescrive: *«Ogni file prova porta in testa
la riga `#  Si lancia con: -Deposito <N> (motivo: ...)`»*. 👉 **La classe e' stata SCRITTA e non
APPLICATA al file che l'ha generata.** E' rimasta una nota, quattro giorni.

✅ **RIPARATO OGGI**, ed e' l'unica modifica di questo referto: **20 righe di commento in testa**
al file — la dichiarazione `-Deposito 100000`, il motivo, i numeri misurati delle due tabelle e
il controllo incrociato del `Profit` prescritto dalla classe. **Nessuna riga di parametro toccata,
nessuna cella cambiata: 2 celle prima, 2 celle dopo.**
Ripassato dai due cancelli **dopo** la modifica: `controlla_riga --oggetto prova` → *nessun
difetto meccanico*; `controlla_prova` → *celle 2, problemi 0, ESITO OK*.

⚠️ **E il rilievo che resta aperto su `R190b`, dichiarato**: il file dice da solo (r.122-126
originali) che **l'asse gemello su `InpMagic` e' stato tolto**, quindi **il cancello G1 di
determinismo NON viene rifatto in quel round**. Se l'ancora fallisse, il round non puo' dire se
la colpa e' del banco o del binario. **Non l'ho cambiato**: e' una scelta dichiarata dall'autore,
e aggiungere una cella costerebbe 0,67 min. 👉 **Decisione di Claudio, non mia.**

---

# 4️⃣ 📖 LAVORO 2 — `R200C` E `R197B`, LETTI PER LA PRIMA VOLTA

Tutti e due girati il **21/09 su `DESKTOP-H4D7CAJ`**, **tick reali**, **deposito 80.000**
(il banco FTMO vero), **M5**, `da quando 2024.09.26`. Tutti e due su **sedie che stanno operando
la challenge adesso**. Tutti e due i CSV **hanno la colonna `Peggior Giornata %`** → **classe 618
soddisfatta**, il muro giornaliero si legge dall'OPTFRAME e non dai deal.

## 4.1 🟢 `R197B` — LA PROFONDITA' DEL RETEST SUL DOW (`770202`, viva)

**Che cosa misurava.** File `backtest_pipeline/prove/R197b_profondita_retest_DOW_U30USD.txt`.
Asse unico **`InpRetestOffsetPts`**: quanto DENTRO il livello si mette il LIMIT.
Nasce da una frase di Claudio del 21/09: *«SIAMO SICURI CHE LA DISTANZA DEL RETEST NON SIA
TROPPA»*. Il Dow e' la piu' profonda delle tre aperture (400 contro 200 del DAX e 0 del Nasdaq)
ed e' **l'unica mai passata dallo studio**.

| `InpRetestOffsetPts` | IS PF | **IS RF** | IS DD% | IS n\* | OOS PF | **OOS RF** | OOS DD% | OOS n\* | OOS peggior giornata |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `0` (come il Nasdaq) | 0,97281 | 🔴 **−0,06626** | 10,8381 | 73 | 1,12516 | 0,69690 | 9,2866 | 133 | −2,0267% |
| `200` (come il DAX) | 1,07130 | 0,15863 | 11,0171 | 74 | **1,27968** | **1,50943** | 9,0081 | 133 | −2,0309% |
| **`400` ← SCHIERATO** | **1,21214** | **0,47049** | 11,0936 | 74 | 1,25384 | 1,47219 | **8,7450** | 130 | −2,0464% |
| `600` | 1,10983 | 0,20776 | 🔴 12,8757 | 72 | 1,25920 | 1,43376 | 9,4381 | 131 | −2,0360% |

\* 🔴 **classe 550**: `InpTP1_ClosePct=50` e' acceso → `Trades` conta **USCITE**. Le 133 uscite OOS
sono **fra 67 e 133 posizioni**. **Sotto le 150 in tutti i casi.**

**Il verdetto, con la regola di selezione dichiarata prima del numero:**

- ✅ **L'ATTESA SCRITTA NEL FILE E' CENTRATA.** Diceva: *«se il Dow somiglia ai gemelli, il retest
  perde meno del 5% delle operazioni»*. Misurato: **da 74 a 72 in IS (−2,7%)** e **da 133 a 130 in
  OOS (−2,3%)**. 👉 **la profondita' NON costa operazioni**. La clausola d'allarme (*«se perde piu'
  del 15%...»*) **non scatta**.
- 🟢 **C'E' UN ALTOPIANO VERO, e la griglia e' a passo fisso (non genetica), quindi la regola si
  applica.** Le celle `200 · 400 · 600` stanno tutte a **PF OOS 1,25–1,28** e **RF OOS 1,43–1,51**:
  tre celle contigue, spread piccolo. **La cella `0` casca fuori dal bordo** (RF OOS 0,697,
  **meno della meta'**) ed e' **l'unica con i segni discordi** fra le finestre (RF IS **negativo**,
  RF OOS positivo) → **rumore**.
- 🎯 **Centro dell'altopiano = `400` = LA CELLA VIVA.** E in IS `400` e' anche il massimo
  (RF 0,470 contro 0,159 e 0,208). Le due finestre **concordano**.
- 🔴 **LA RISPOSTA ALLA DOMANDA DI CLAUDIO E': NO, non e' troppa — e accorciarla e' l'unica cosa
  che la peggiora davvero.** Passare da 400 a 0 costerebbe **−53% di Recovery Factor OOS**
  (1,472 → 0,697) senza guadagnare nemmeno un'operazione.
- 📏 **MERITO SOSPESO, RISCHIO LEGGIBILE** (Emendamento B): sotto le 150 posizioni il merito non si
  pronuncia. Il rischio si', ed e' questo: **DD equity 8,75–12,88%**, **peggior giornata −2,05%
  sulla cella viva**. 🟢 Il muro giornaliero prop del 5% **passa con ampio margine, letto dalla
  colonna giusta**. 🟠 Il DD di equity supera il 10% in IS su **tutte e quattro** le celle
  (10,84–12,88%): **non e' confrontabile direttamente col muro FTMO statico del 10%** (MT5 misura
  dal picco di equity, FTMO dal saldo iniziale), ma **e' un numero da tenere d'occhio, non da
  archiviare**. Il confronto corretto e' `[NON MISURATO]` qui.

> 🟢 **CHE COSA CAMBIA PER LA SEDIA `770202`: NIENTE — ed e' esattamente il risultato buono.**
> Il valore schierato e' il centro dell'altopiano, misurato su tick reali, sul banco vero, e
> confermato da IS e OOS insieme. **Una casella chiusa**, e una domanda di Claudio con una
> risposta.

## 4.2 🔴 `R200C` — IL MODO DEL TRAILING SUL NASDAQ (`770260`, viva) — **CONFERMA LA CELLA VIVA E UCCIDE UN ROUND IN ATTESA**

**Che cosa misurava.** File `backtest_pipeline/prove/R200c_trailing_modo_NASDAQ_NASUSD.txt`.
Asse **`InpTrailMode`**, e non e' un parametro: e' il **meccanismo**, e i tre rami sono
**mutuamente esclusivi** (`0` = ATR, `1` = barra precedente **← schierato**, `2` = fisso 410
punti). Nato per un motivo preciso: **il DD della sedia non e' risolto** e il trailing era
l'ultima famiglia d'uscita rimasta.

| `InpTrailMode` | IS PF | **IS RF** | IS DD% | IS n | OOS PF | **OOS RF** | OOS DD% | OOS n | OOS peggior giornata |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `0` ATR | 1,11685 | 0,41601 | 🔴 16,1884 | 82 | 1,01777 | 🔴 **0,09042** | 12,7229 | 102 | −2,1330% |
| **`1` PREVBAR ← SCHIERATO** | 1,11621 | **0,43848** | 12,3569 | 82 | **1,14894** | **1,01319** | 9,1244 | 102 | −2,1282% |
| `2` FISSO 410 | 🔴 **0,65823** | 🔴 **−0,67670** | **8,0354** | 82 | 🔴 **0,80365** | 🔴 **−0,51550** | **5,3231** | 102 | −2,0540% |

🟢 **`n` e' IDENTICO (82/102) su tutti e tre i rami** — `InpOneTradePerDay` e
`InpTP1_ClosePct=0` (niente parziale, quindi **`Trades` = POSIZIONI**, classe 550 non morde).
👉 **E' un confronto d'uscita PULITO, a ingressi fermi**: l'unica cosa che cambia e' come si esce.

**Il verdetto:**

- 🔴 **L'IPOTESI CHE IL FILE PORTAVA IN TESTA E' SMENTITA, e va detto perche' era ben
  argomentata.** Il file aveva **corretto se stesso** prima di girare, sulla base di una tabella
  d'archivio (`gestione_20260909`) dove il modo `2` dava **DD 7,17% contro 17,65%** pagando appena
  0,009 di PF, e concludeva: *«la cella che avevo dato per morta e' quella col DD piu' basso»*.
  **Sulla cella VIVA, a tick reali, sul banco vero, quella cella PERDE SOLDI IN TUTTE E DUE LE
  FINESTRE**: `Profit` **−4.377,67 IS** e **−2.253,15 OOS**, RF **negativo due volte su due**.
- 🔴 **Ed e' il caso di scuola della REGOLA 1, quindi lo scrivo esplicito**: il modo `2` ha
  **il DD piu' basso di tutti** (8,04% IS / **5,32% OOS**, l'unico sotto il 10% in IS). **Non e'
  merito**: il profitto e' sceso **sotto zero** insieme al DD. Un DD che scende con il conto che
  cala non e' protezione, e' inattivita' costosa.
- 🟢 **Il modo `1`, cioe' quello SCHIERATO, vince su RF in tutte e due le finestre** — IS 0,438
  (il migliore dei tre) e OOS **1,013**, cioe' **11,2 volte** il runner-up. E vince anche sul DD
  contro il modo `0` (12,36% contro 16,19% IS; 9,12% contro 12,72% OOS).
- ⚠️ **L'altopiano qui NON e' osservabile, e lo dichiaro invece di fingerlo**: `InpTrailMode` e'
  un **enum a tre rami mutuamente esclusivi**, non un asse continuo. Non esistono «celle vicine».
  La selezione qui e' **una scelta fra tre meccanismi**, e il criterio applicato e' **RF concorde
  di segno sulle due finestre**, dichiarato prima: lo passa **solo il modo `1`**.
- 🔴 **MA IL ROUND RISPONDE «NO» ALLA PROPRIA RAGIONE D'ESSERE: IL DRAWDOWN NON E' RISOLTO.**
  La cella migliore ha **DD equity IS 12,36%**. L'unica che scende sotto il 10% in IS e' quella
  che perde soldi. 👉 **La famiglia del trailing e' ESAURITA come leva sul DD di `770260`**, e
  questo e' un fatto nuovo da mettere agli atti, non una non-notizia.
- 💰 **E IL RISPARMIO CONCRETO: `R200d` E' MORTO.** Il file dichiarava
  *«`InpTrailAtrMult` diventa un asse solo se prima questo round dice che il ramo ATR vale
  qualcosa. Il file c'e' gia', si chiama `R200d`, ed e' DA NON LANCIARE finche' questo non ha
  parlato.»* **Questo round ha parlato**: il ramo ATR (`modo 0`) perde contro il modo `1` su RF in
  **tutte e due** le finestre, e in OOS **di 11 volte**. 👉 **Tarare il moltiplicatore di un ramo
  perdente e' esattamente la griglia fitta su un motore senza edge che la regola del 19/08
  vieta.** `R200d` **non va lanciato**.
- 🟠 **`R200e` (tarare il `410`) resta in piedi ma serve una TESI, non un giro di manopola.**
  Il `410` e' un numero ereditato dal piano DAX e mai ritarato per il Nasdaq (r.273 del sorgente).
  Il suo unico punto misurato sulla cella viva fa **PF 0,658**. 👉 **Non si allarga una griglia su
  un ramo con PF 0,66**; se una tesi c'e', e' *«il DD e' il vincolo che blocca la sedia, e il modo
  2 e' l'unico ramo che ci va sotto»* — e allora **va scritta come tesi, col suo cancello, prima
  di spendere celle**. Non lo propongo io in questo giro.

> 🟢 **CHE COSA CAMBIA PER LA SEDIA `770260`: il preset e' confermato**, e **una casella si
> chiude con un round in meno da fare**.

## 4.3 📌 E la cosa che questi due round dicono INSIEME

Su due sedie vive, due round diversi, due manopole diverse: **tutte e due volte ha vinto il
valore gia' schierato.** 🟢 **Non e' una delusione: e' la prova che le sedie in campo non sono
state messe li' a caso** — e, secondo la regola di casa, *«se il guadagno e' dentro il rumore, la
risposta onesta e' il default va bene, ed e' un risultato»*. 🔴 **Ma e' anche un avvertimento sul
dove cercare**: su questa famiglia **i parametri d'ingresso e d'uscita sono gia' vicini
all'ottimo**, e il margine che manca alla challenge **non e' li' dentro**. Sta nei **meccanismi**
e nei **simboli**, che e' esattamente dove il mandato dice di allargare.

---

# 5️⃣ 🆕 LA CLASSE NUOVA

**CLASSE 628** — *un asse realizzato come FATTORIALE SU FILE PROVA SEPARATI e' INVISIBILE a un
rilevatore che cerca la variazione DENTRO un CSV: due dossier di fila hanno scritto «mai misurata»
su una manopola misurata due volte*. Scritta in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`
con la data 23/09/2026 e il caso reale (`InpTrailOnST`/`InpExitOnFlip` su `770511`).

---

# 6️⃣ 📋 I BUCHI DICHIARATI — **PER NOME**, ciò che NON ho coperto

1. 🔴 **NON ho scritto il file prova per `InpUsePending`** (l'ingresso a due gambe: `InpUsePending`
   · `InpFirstFraction` · `InpPendingPips` · `InpPendingExpiryBars`). E' la **casella vuota vera**
   che resta su `770511` dopo il ritrovamento di §2, e vale piu' di tre dei sette in coda: 2 celle,
   4 passate, **3,3 minuti**. **Non esiste, e va scritto.**
2. 🔴 **NON ho lanciato niente**, quindi **tutti i numeri della §3 sono ATTESE, non misure.**
   Le celle e le passate sono contate dal cancello; i **minuti** vengono dall'ancora `R202A` e
   sono un **MASSIMO**, non una previsione centrata.
3. 🟠 **Il minuto-per-cella non e' stato misurato su SuperWave H1**: l'ancora e' `Dow_Apertura`
   **M5**. Ho argomentato perche' e' un limite superiore (§3.1), **non l'ho misurato**.
   `[NON MISURATO]`.
4. 🔴 **Nessun numero di questo referto e' sul simbolo FTMO ne' al rischio dei preset FTMO.**
   L'archivio e' `U30USD`/`NASUSD` **BCM** a `InpRiskPercent=1` (i sette file) o `2` (i due round
   del 21/09); le sedie volano su `US30.cash`/`US100.cash`. **I confronti FRA CELLE valgono, i DD
   assoluti no.** Il trasferimento e' **assunto**, non misurato qui.
5. 🟠 **PROVA DI REGIME: assente.** 642 giorni = **un regime solo** (regola C dell'Emendamento
   della Finestra **non soddisfatta**) per i sette file e per i due round. E sugli indici BCM
   **piu' finestra non c'e'**: il muro dei tick e' il 2024.09.26.
6. 🟠 **Il pavimento delle 150 operazioni non e' raggiunto da nessuna delle misure lette qui**
   (`R120b` 46-131 uscite · `R197B` 72-133 uscite · `R200C` 82-102 posizioni). **Il MERITO e'
   sospeso ovunque**; quello che ho letto senza riserve e' il **RISCHIO** e il **VERSO** quando le
   due finestre concordano.
7. 🔴 **Su `R190b` il cancello G1 di determinismo NON viene rifatto** (§3.6): l'asse gemello sul
   magic e' stato tolto dall'autore. **Non l'ho reintrodotto.**
8. 🔴 **`R155a` NON e' archiviato come morto** — non ha certificato. Resta **«NON ANCORA
   MISURATO»**, e cio' che manca e': `@FRAZIONEIS 0.40` al posto di `1.0` (una riga), per avere un
   OOS che non sia una finestra vuota.
9. 🟠 **I due round del 21/09: non ho aperto i per-trade** (non esistono per queste corse). Il DD
   in valuta sarebbe derivato; **non l'ho derivato**, ho letto le colonne dell'OPTFRAME.
10. 🚫 **Non ho toccato**: `770101`, `771531`, `R214e`, `R214f` (lavoro di `R226`); nessun `.set`,
    nessun preset, nessun EA, nessuna sedia, nessun forward, nessun VPS, nessuna taglia, nessun
    parametro di rischio, nessuna riga consegnata a Claudio.
11. 🟠 **Non ho riletto gli altri 38 round della coda R225**: il confronto di valore che faccio
    e' **fra i sette di SuperWave**, non contro tutta la coda. **Dove i sette vadano inseriti
    nell'ordine dei 38 e' una decisione che non prendo io.**

---

# 7️⃣ ✅ LE DECISIONI CHE RESTANO A CLAUDIO

1. **Se aggiungere i sei round alla coda** (28,8 minuti sul PC di backtest `DESKTOP-H4D7CAJ`) e
   **in che punto dei 38**.
2. **Se far scrivere il file prova su `InpUsePending`** prima di lanciare (buco #1): e' la casella
   piu' vuota che resta sulla sedia.
3. **`R200d` non si lancia**: confermare l'archiviazione. **`R200e` si lancia solo con una tesi
   scritta prima.**
4. Tutto cio' che riguarda **taglie, rischio, accensioni, preset e il conto reale `10105439`**
   resta, come sempre, **firma sua**.

---

*R227 — 23/09/2026. Zero minuti di macchina spesi. Sette file verificati ai cancelli oggi,
dodici CSV d'archivio riaperti riga per riga, due round letti per la prima volta, un file prova
riparato, una classe nuova.*
