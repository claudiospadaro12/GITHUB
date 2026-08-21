# ⚖️ R94 — CRITERI ✍️ **FIRMATI** — la cella Bollinger (37 · 1.4) sul Breaking Band

> ## ✅ FIRMATO DA CLAUDIO IN CHAT: **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"** — 21/08/2026.
> La firma integrale sta **in fondo a questo file** (sezione *"FIRMA DI CLAUDIO
> — R94 BOLLINGER 37/1.4"*): quella e' l'originale.
> Raccolta **a numeri di R94 mai visti**: nessuna passata girata. Regola di casa,
> non trattabile: *i criteri si congelano prima dei numeri, non dopo.*
> **Le soglie NON sono state toccate dalla firma e non si toccano.**
>
> ⚠️ **Una cosa NON e' firmata, ed e' scritta perche' si veda:** il **rischio
> all'1,0%** e' un'**assunzione dichiarata da Claude** (§2.1), non una parola di
> Claudio. Ribaltabile con una parola: in quel caso la base R34 va rimisurata.
>
> 📎 Il corpo qui sotto e' stato scritto **prima** della firma, quando l'esito
> "archiviata" era ancora sul tavolo (§0.2): si legge come il verbale di come ci
> si e' arrivati, non come una proposta ancora aperta.

**Numero del round:** R94. R93 e' gia' **prenotato** dal
`caccia_strategie/DOSSIER_NEWS_FILTER_2026-08-21.md` per il filtro news del
FiboH4 — quindi il primo libero e' il 94.

**Banco:** `ABTG_BreakingBand` **v1.03** · H1 · 3 simboli · **4 celle per
simbolo × 2 finestre = 24 passate** · tick reali BCM · deposito 100k · rischio
1,0% · **6 file prova** `prove\R94{a,b,c}_bb_{GBPUSD,EURUSD,AUDUSD}_p{20,37}.txt`
· driver `walkforward_generico.ps1`, lanciato da **`lancia_r94.ps1`** · riga di
lancio: **`backtest_pipeline/righe/RIGA_R94_BB37.md`**.

---

## 0. 🤝 LA PROMESSA DI ONESTA'

### 0.1 Da dove nasce, alla lettera

Nasce dalla proposta **P-PB3** dell'analisi Point Break del 18/08
(`ANALISI_POINTBREAK_2026-08-18.md:905-909`): il PIANO DI TRADING di Christian
Bertacchi prescrive **Bande di Bollinger periodo 37, deviazione 1.4**
(slide 3, confermato dal grafico di slide 4 — dichiarato **due volte** dalla
fonte, non dedotto). La nostra famiglia **Breaking Band** lavora sulle
Bollinger: aggiungere quella cella "costa quasi nulla".

**Costa quasi nulla e' vero. Che valga qualcosa non e' dimostrato**, ed e' il
motivo per cui questo file esiste invece di una riga di lancio.

### 0.2 LE TRE COSE SCOMODE, SCRITTE PRIMA (non dopo)

**(a) 🧬 Si trapianta un PARAMETRO senza la sua TESI.**
Il 37/1.4 nasce su un motore **diverso**: mean-reversion che entra *fuori* dalle
bande, su **D1/H12**. La sua tesi e' *"bande strette = violate spesso = piu'
estremi da fadare"*. Il Breaking Band fa un'altra cosa (bulge → ritracciamento
→ tocco/retest, TP sulla mediana) su **H1**. La regola di casa
(`caccia_strategie/LEGGIMI.md`) dice *"si raccoglie la MECCANICA e la TESI, mai
il risultato"*: qui la meccanica passa, la tesi **no**.

**(b) 🔢 Il campione della famiglia non permette un giudizio di MERITO.**
Base misurata in R34, tick reali:

| sedia | pattern | n IS | n OOS | frequenza |
|---|---|---:|---:|---|
| GBPUSD | CONT + INV | 13 | 26 | 2,05 op/mese |
| EURUSD | solo CONT | **4** | 13 | 1,02 op/mese |
| AUDUSD | solo INV | **5** | 11 | 0,87 op/mese |

L'Emendamento della Finestra chiede **≥150 operazioni**; R91 aveva gia'
dichiarato *"n < 30 → il MERITO e' SOSPESO"*. Con 11-26 trade OOS
**nessuna cella di R94 puo' essere promossa**, qualunque numero faccia. Un IS a
n=4 non e' una finestra, e' un aneddoto.

**(c) 🎣 Senza un vincolo, questo round e' PESCA.**
Quattro celle × tre simboli = 12 combinazioni su un campione minuscolo: la
probabilita' che *almeno una* sia bella per caso e' alta. E' esattamente la
"cella verde per caso" che la Regola della Seconda Caccia indica come **quella
che brucia la challenge**.

### 0.3 IL VINCOLO CHE RENDE IL ROUND ONESTO — e senza il quale va archiviato

> 🎯 **La domanda di R94 NON e' "quale cella rende di piu'". E' "la geometria
> 37/1.4 produce piu' OPERAZIONI?"**

Motivo meccanico, leggibile prima di misurare: **deviazione 1.4 = bande piu'
strette = piu' tocchi e piu' retest**, e il tocco della banda e' l'innesco di
entrambi i pattern. Se il conteggio sale in modo netto, la famiglia guadagna un
**campione leggibile**, che oggi non ha — e *quello* sarebbe il risultato utile,
molto piu' del profitto di 26 trade.

**Conseguenza operativa, congelata qui:** in R94 il **profitto non si guarda**
finche' il cancello di frequenza (§3) non e' superato. Se non lo e', la cella si
archivia **senza aprire la colonna Profit**.

---

## 1. 🎯 LA DOMANDA — e la sua falsificazione

**Domanda:** su `ABTG_BreakingBand` a parita' di tutto il resto, la geometria
Bollinger **37 / 1.4** cambia il numero di operazioni rispetto alla **20 / 2.0**
oggi in campo? E quale dei due parametri lo fa — il **periodo** o la
**deviazione**?

**Falsificazione dichiarata:** se il conteggio operazioni OOS **non sale** (o
scende) su tutti e tre i simboli, la risposta e' **no** e la proposta P-PB3 e'
**archiviata definitivamente**, con la riga scritta nel REGISTRO_TEST dei caduti
perche' nessuno la riproponga.

**Il fattoriale 2×2 non e' un lusso**: senza le celle miste (37/2.0 e 20/1.4)
un eventuale effetto non sarebbe attribuibile. Il periodo 37 ha una fonte in
casa (`BREAKING_BAND_TESI.md`: BB 37/3 sugli **indici**), la deviazione 1.4 no.

---

## 2. 🧪 IL DISEGNO

| | |
|---|---|
| EA | `ABTG_BreakingBand` v1.03 (nessuna modifica al sorgente: `InpBBPeriod` e `InpBBDev` esistono dalla v1.00) |
| TF | H1 (`InpTF=16385`) |
| Finestra | `@DAQUANDO 2024.09.26`, split 40/60 del driver → IS 2024.09.26-2025.06.09, OOS 2025.06.10-2026.06.30 |
| Dato | **tick reali BCM**, "Ogni tick basato su tick reali" |
| Deposito | 100.000 (per riprodurre R34 al centesimo) |
| Rischio | **1,0%** — vedi §2.1 |
| Celle | `InpBBPeriod` ∈ {20, 37} × `InpBBDev` ∈ {1.4, 2.0} |
| Simboli/pattern | GBPUSD patt.2 (CONT+INV) · EURUSD patt.0 (CONT) · AUDUSD patt.1 (INV) |
| Artefatti | **6 file prova**: per ogni simbolo un gemello **P20** e un gemello **P37**. Dentro un file si muove **una variabile sola** (la deviazione); fra i due file se ne muove **un'altra sola** (il periodo) |
| Fermi | `InpStdPeriod=20`, `InpStdSmaPeriod=50`, `InpMinRR=0`, `InpTPMode=0`, `InpBulgeWidthMult=1.35`, `InpBulgeNetMoveATR=1.0`, `InpRetestBufferATR=0.15` |

### 2.1 ⚠️ UNA DECISIONE CHE E' DI CLAUDIO, NON DELL'AGENTE — il rischio
R92 e' stato firmato a **0,80%** (era 1,00). R94 e' scritto a **1,0%** per una
ragione tecnica: **il canarino (§4) confronta col R34, che gira all'1,0%.**
Cambiando rischio il confronto salta. Le due strade sono entrambe legittime:
- **1,0%** → canarino valido, ma il round non parla la lingua di R92;
- **0,80%** → coerente con la firma piu' recente, ma la base R34 va **rimisurata
  prima** (2 passate in piu').

👉 **Da decidere in firma. L'agente non sceglie.**

### 2.2 🚫 COSA NON SI TOCCA
La sedia viva **`BB GBPUSD INV S` (magic 772161)** e le sue sorelle in forward
**non vengono toccate da questo round**: R94 gira nel tester con i magic del
driver. Nessun preset del VPS viene modificato.

---

## 3. 🚧 I CANCELLI — in ordine, e il primo blocca gli altri

### 🥇 CANCELLO 1 — FREQUENZA (l'unico che decide)
Soglie per simbolo, scalate sulla base di ciascuna sedia:

| simbolo | n OOS base | ✅ campione leggibile | 🟡 non decisivo | ❌ archiviata secca |
|---|---:|---|---|---|
| GBPUSD | 26 | **≥ 60** | 27-59 | ≤ 26 |
| EURUSD | 13 | **≥ 30** | 14-29 | ≤ 13 |
| AUDUSD | 11 | **≥ 30** | 12-29 | ≤ 11 |

**Regola d'insieme (Emendamento, punto A):** la cella deve salire su **almeno 2
simboli su 3**. Un solo simbolo che sale mentre gli altri due scendono e' rumore,
non un effetto — e si archivia.

### 🥈 CANCELLO 2 — RISCHIO (si legge SEMPRE, a qualunque n)
Se una cella fa **DD > 8%** (il doppio abbondante del 3,48% della base OOS
GBPUSD), la cella e' **fuori** anche se la frequenza sale. Un drawdown e' un
fatto accaduto, non una stima: questo cancello **non e' sospeso dal campione
piccolo**.

### 🥉 CANCELLO 3 — MERITO: **SOSPESO PER DICHIARAZIONE**
Con n OOS < 30 il merito **non si giudica**. Se il cancello 1 passa, l'esito
massimo di R94 e' una **PROPOSTA motivata** di un round successivo con la nuova
geometria e un campione vero — **mai una promozione, mai un deploy**.

### 📐 La misura che va scritta accanto a ogni riga
`aspettativa dei trade AGGIUNTI = (Profit_cella − Profit_base) / (n_cella − n_base)`.
Se viene **negativa**, la cella ha comprato frequenza pagandola con operazioni
perdenti: **e' un peggioramento anche se n sale**, e va detto.

---

## 4. 🐤 IL CANARINO — si legge PRIMA di tutto il resto

La cella **20 / 2.0** deve riprodurre R34 **al centesimo** su tutti e tre i
simboli (righe nei file prova). Se non torna, si e' mosso qualcosa che non
doveva muoversi: **il round si ferma e si cerca il perche'**, non si prosegue.

---

## 5. 📋 COSA ESCE DA R94 — i tre esiti possibili, scritti prima

1. **ARCHIVIATA** (cancello 1 fallito su ≥2 simboli): riga nel REGISTRO_TEST dei
   caduti, P-PB3 chiusa, il 37/1.4 non si ripropone piu' senza una tesi nuova.
2. **NON DECISIVO** (zona gialla): si scrive il numero, si archivia comunque, e
   si dichiara che la famiglia resta con il campione che ha.
3. **PROPOSTA** (cancello 1 passato + cancello 2 pulito): si propone a Claudio un
   round successivo **su campione vero** con la geometria nuova. Nessun deploy,
   nessun cambio di preset in forward.

> ❌ **Non esiste un quarto esito.** In particolare **non esiste** l'esito
> "la cella rende di piu', la mettiamo in campo": con 11-26 operazioni quel
> passo non e' consentito da nessuna regola di casa.

---

## 6. ✍️ FIRMA DI CLAUDIO — ✅ **RACCOLTA**

**La firma non e' qui: e' in fondo al file**, nella sezione *"FIRMA DI CLAUDIO —
R94 BOLLINGER 37/1.4, 21/08/2026, PRIMA DEI NUMERI"*. Quella e' l'originale,
questa e' solo l'indicazione di dove sta.

> **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"** — 21/08/2026.

⚠️ **Quello che la firma NON copre**: il **rischio**. Claudio ha firmato "lancia"
senza pronunciarsi, e l'1,0% resta un'**assunzione dichiarata da Claude** (§2.1),
non una sua decisione.


---

# ✍️ FIRMA DI CLAUDIO — R94 BOLLINGER 37/1.4, 21/08/2026, **PRIMA DEI NUMERI**

> **"metro,frequenza, firmo r93, r94 lancia, e prepara jpy"**
> — Claudio, 21/08/2026, in chat.

La parola **"r94 lancia"** firma i criteri e autorizza la corsa.

Dichiarazione di cecita': al momento della firma **nessun numero di questi round
e' stato prodotto, letto o guardato**. Nessuno dei due EA nuovi e' mai stato
compilato. Le soglie NON sono state toccate dalla firma.


## La domanda, che NON e' "quanto rende"
La famiglia BreakingBand gira su **n OOS di 11 / 13 / 26**: con quei campioni il
**merito e' sospeso per dichiarazione**. R94 chiede una cosa sola:
**la frequenza sale?** (deviazione 1.4 = bande piu' strette = piu' tocchi).

> **Se la frequenza non sale, il profitto non si guarda nemmeno.** Congelato qui.

Fattoriale **2x2**, 24 passate, per separare il **periodo** (che una fonte in casa ce
l'ha: BB 37/3 sugli indici) dalla **deviazione** (che non ce l'ha: viene dal corso).

## Assunzione dichiarata da Claude, NON firmata da Claudio: il rischio
Claudio ha firmato "lancia" **senza pronunciarsi sul rischio**, che era la richiesta
n.4 dell'agente (1,0% "canarino valido" contro 0,80% della firma R92).
**Assunzione presa: si resta all'1,0%**, e il motivo e' che R94 misura la
**FREQUENZA** contro la **base gia' misurata della famiglia**, che gira all'1,0%:
cambiare rischio renderebbe il confronto con la base **non comparabile**, e la
frequenza e' la grandezza che il rischio non tocca.
⚠️ **Claudio puo' ribaltare questa assunzione con una parola**, e in quel caso la
base va rimisurata insieme alla cella.

---

# 🔧 NOTA TECNICA POST-FIRMA — 21/08/2026, scritta a numeri ANCORA MAI VISTI

**Cosa e' cambiato dopo la firma, e perche' NON tocca la firma.**

Al momento della firma il disegno era **3 file prova con DUE assi ciascuno**
(`InpBBPeriod` × `InpBBDev`). Passandolo da `backtest_pipeline/controlla_prova.py`
il controllo lo ha **bocciato**, e aveva ragione:

```
- 2 assi Y: un file prova misura UNA variabile alla volta (InpBBPeriod, InpBBDev)
```

Riscritto in **6 file prova con UN asse ciascuno**: per ogni simbolo un gemello
**P20** (periodo pinnato a 20) e un gemello **P37** (periodo pinnato a 37),
entrambi con l'unico asse `InpBBDev` = 1.4 / 2.0.

> ✅ **Le celle misurate sono le STESSE, una per una**, e il conto torna
> identico a quello firmato: **12 celle, 24 passate**, stesso fattoriale 2×2,
> stesse soglie, stesso rischio, stessa finestra.
> 🔄 **E' cambiata solo la forma degli artefatti**, non il contenuto della
> misura. Le soglie **non sono state toccate**, il canarino nemmeno.
> ⚠️ **Se Claudio ritiene che anche la forma facesse parte di cio' che ha
> firmato, lo dica: si rifa' prima di lanciare, non dopo.**

Verifica successiva, dopo la riscrittura:
```
file: 6 | celle totali: 12 | passate (celle x 2 finestre): 24 | problemi: 0
ESITO: OK
```

## 🔎 Il buco chiuso mentre si scriveva la riga di lancio

Scrivendo `lancia_r94.ps1` e' saltato fuori un difetto **del giro a vuoto**, che
vale per **tutti** i round di questa casa e non solo per R94:

> 🔴 **`walkforward_generico.ps1 -SoloControllo` NON COMPILA.**
> Esce alla **riga 503**; la compilazione sta alla **riga 603**.
> Quindi un `#include` mancante o di versione sbagliata **non si vede nel giro a
> vuoto** e salta fuori **a corsa avviata**, come `undeclared identifier` dentro
> il driver — esattamente il difetto **33-bis** della checklist, che era stato
> scritto guardando un altro sintomo.

`lancia_r94.ps1` lo chiude per conto suo: **compila lui**, da riga di comando,
**anche in `-SoloControllo`**, e verifica che il `.ex5` sia stato **riscritto
adesso** (coppia sorgente/binario, punto 27). Costa dieci secondi.
📌 **Il fix vero** — far compilare il driver anche in `-SoloControllo`, o
almeno dirlo — **resta in coda come lavoro a se'**, e sta scritto qui perche'
non si perda.

## 🧪 Cosa e' stato verificato prima di consegnare

| controllo | strumento | esito |
|---|---|---|
| file prova | `controlla_prova.py` | ✅ 6 file, 12 celle, 24 passate, 0 problemi |
| driver PowerShell | `lint_ps1.py` | ✅ 0 problemi |
| sintassi PowerShell | parser vero (`Parser::ParseFile`) | ✅ 0 errori |
| ASCII puro nel `.ps1` | conteggio byte > 127 | ✅ 0 |
| estrazione `#include` | eseguita sul sorgente vero | ✅ trova `ABTG_PausaGuardian.mqh`, salta `Trade/Trade.mqh` |
| difetto 33 (secondo artefatto) | eseguito su `walkforward_generico.ps1` | ✅ 0 occorrenze dell'EA nel driver |
| il rischio cambia `n`? | lettura del sorgente | ✅ **no, e la catena si chiude nel CODICE**: `LotByRisk` **riga 1427** termina con `MathMax(mn,MathMin(mx,lot))`, cioe' il lotto e' **agganciato al MINIMO DEL BROKER** e `InpRiskPercent` non puo' azzerarlo. In piu': Guardian fail-open nel tester, nessun kill switch giornaliero, `InpMaxPositions` conta posizioni. **Residuo:** la guardia di **riga 1137** esce **senza incrementare nessun contatore** (inerte nel tester, ma sarebbe un'uscita muta) |

⚠️ **Quello che NON e' verificato:** la riga **non e' mai stata eseguita su
Windows**. Il parser conferma la sintassi, non il comportamento. Per questo il
**BLOCCO 1 (giro a vuoto) va mandato per primo**.

---

# 🧪 SECONDA VERIFICA — 21/08/2026: la riga di lancio e' stata **BOCCIATA (13 difetti)** e rifatta

_Sempre a numeri di R94 **mai visti**. **Il disegno del round non e' cambiato**:
6 file prova, 12 celle, 24 passate, stesse soglie, stesso canarino. Sono
cambiate le **guardie** della riga. Le tre che valgono piu' di tutte:_

## 🥇 1. Il canarino poteva essere servito dalla **CACHE DEL TESTER** (punto 38)

La riga v1 scriveva: *"il canarino e' anche il controllo dei dati: se i tick
fossero cambiati o mancanti, quelle righe non tornerebbero"*. **Era falso**, ed
e' stato dimostrato sui file:

> La cella di canarino di R94 (GBPUSD, `InpBBPeriod=20`, `InpBBDev=2.0`,
> `InpMinRR=0`, magic 772101, stessa finestra, stesso deposito, stesso modello)
> **e' la stessa identica passata gia' calcolata da R91 il 21/08**:
> `r91_csv/ABTG_BreakingBand_GBPUSD_OOS_r91a.csv`, `Pass 0` →
> `Profit 3160.10 | PF 1.73020 | DD 3.4801 | Trades 26`.

Con la cache piena MT5 l'avrebbe **ripescata**, e **una passata ripescata non
legge un tick**: il canarino sarebbe tornato al centesimo **anche con lo storico
sparito**, mentre le celle P37 avrebbero girato sui dati veri. **Due misure su
due mondi diversi.**
✅ `lancia_r94.ps1` ora **svuota `Tester\cache`** prima della corsa (mai
`bases\<server>\ticks`, che e' lo storico) e **muore** se non ci riesce.
✅ E aggiunge due spie: **una cella che torna in pochi secondi** e' sospetta, e
**un pass ripescato non scrive i per-trade** — che ora si ripuliscono **prima di
ogni cella** e si verificano freschi dopo.

## 🥈 2. Il funnel `[BB-FUNNEL]` **non esiste in questo round** (punto 34-ter)

`PrintFunnel()` gira in `OnTester()` (sull'**agente**) e le passate sono in
**ottimizzazione** (`Optimization=1` sempre): quelle `Print` non sono leggibili.
R91, per leggerle, dovette fare una **passata singola** dedicata.
✅ La riga **smette di prometterlo**. Il cancello si legge dalla colonna
**`Trades`** del CSV, che e' un dato e non uno schermo. Il conteggio dei log
finisce nel referto, cosi' lo **zero si legge** invece di dedurlo.
📌 **Portare i contatori in una colonna (`FrameAdd`) resta un lavoro a se':** a
branch congelato **l'EA non si tocca**.

## 🥉 3. La catena del rischio si chiude **meglio** di come era scritta

Era: *"l'unico scarto legato al lotto e' contato dal funnel"* — che dopo il
punto 2 sarebbe stato un rimando **a un artefatto inesistente**.
**La prova vera sta nel codice:**

> `LotByRisk`, **riga 1427**: `return(MathMax(mn,MathMin(mx,lot)));`
> **il lotto e' agganciato al MINIMO DEL BROKER: `InpRiskPercent` non puo'
> azzerarlo.**

Quindi `lot<=0` (riga 1133) puo' venire solo da `lossPerLot<=0` (guasto dei dati
di simbolo) o da `slDist<=0`, **gia' escluso alla riga 1100**.
✅ **L'assunzione sull'1,0% e' confermata, e ora e' DIMOSTRATA nel sorgente
invece che dedotta dai log.**
⚠️ **Residuo dichiarato**, che prima non stava scritto da nessuna parte: la
guardia di **riga 1137** esce **senza incrementare nessun contatore**. Nel tester
e' inerte, ma se non lo fosse **quell'uscita sarebbe muta**.

## Gli altri dieci, in breve
| # | difetto | correzione |
|---|---|---|
| D4 | il pin letto nell'**anteprima**, che la scrive il nostro script | si legge nella **colonna del CSV** (`InpBBPeriod` col. 15, `InpBBDev` col. 16). E il formato reale e' **`2`**, non `2.0`: MT5 tronca gli zeri |
| D5 | lo zip vecchio cancellato **alla fine** | cancellato **all'inizio** (sez. 4): una `Muori` anticipata non arrivava mai in fondo, e lo zip di ieri passava il gate dei 15 minuti |
| D6 | Desktop calcolato in **due modi diversi** fra riga e driver | stessi 4 candidati in tutti e due (con OneDrive la riga cercava lo zip dove non era) |
| D7 | le 6 anteprime dichiarate nel blocco **sbagliato** | spostate nel BLOCCO 1: nella corsa vera lo zip ne conterrebbe **0** per costruzione |
| D8 | `.ex5` non cancellato prima; attesa sul **processo** | `.ex5` cancellato prima, e si aspetta l'**artefatto** (180 s): MetaEditor e' single-instance e il processo torna subito |
| D9 | `irm` senza **TLS 1.2** | aggiunto in tutti i blocchi, come nei gemelli |
| D10 | per-trade ripuliti una volta sola: **P20 e P37 scrivono lo stesso file** | ripuliti **dentro il ciclo**, prima di ogni cella, e verificati freschi dopo |
| D11 | questo file diceva **"BOZZA, NON FIRMATI"** con la firma 20 righe sotto | intestazione e §6 corrette. **Le soglie non sono state toccate** |
| D12 | la **ripresa** era un vantaggio buttato | scritto che si rimanda lo stesso blocco (le celle fatte si saltano) e che `-Rifai` serve solo se cambia un file prova o l'EA |
| D13 | numero di riga sbagliato (`exit 0` e' alla **538**, non 503) | corretto, e aggiunte **posizioni delle colonne** e **traffico dichiarato blocco per blocco** |

## 🔒 E il PIN: la motivazione regge, ma "branch congelato" da solo no
Un SHA sarebbe una **bugia** (`walkforward_generico.ps1` riga 91 ha
`$EABranch="lavoro"` fisso e ignora `-Rif`). ✅ Ma il congelamento **dichiarato**
e' un post-it, e R94 e' tutto un confronto **fra celle**: ora e' una **misura**.
Lo script prende lo **SHA256 del sorgente** dopo la compilazione e lo
**riconfronta dopo ogni cella** con `src_prove\<EA>.mq5`; se cambia, **muore**.

## Cosa e' stato verificato, giro 2
| controllo | esito |
|---|---|
| `controlla_prova.py` | ✅ 6 file, 12 celle, 24 passate, 0 problemi |
| `lint_ps1.py` | ✅ 0 problemi |
| sintassi del driver **e delle due righe di chat** (parser vero) | ✅ 0 errori |
| ASCII puro (`.ps1` e 6 file prova) | ✅ 0 byte > 127 |
| uso di variabili prima dell'assegnazione | ✅ nessuno; sciolta la collisione `$dest` fra due sezioni |
| logica del Desktop | ✅ **eseguita**: sceglie `OneDrive\Desktop` quando e' l'unico, e ripiega su `%USERPROFILE%` |
| estrazione degli `#include` | ✅ **eseguita** sul sorgente vero: trova `ABTG_PausaGuardian.mqh`, salta `Trade/Trade.mqh` |
| gate del difetto 33 | ✅ **eseguito** sul driver vero: 0 occorrenze |
| **prova di fumo del driver** | ✅ **eseguito davvero** fino al primo passo Windows-only: scarica i 6 file prova, passa i marcatori, supera il gate 33 e si ferma su *"terminale BCM non trovato"* |

⚠️ **Quello che resta non verificato:** la riga **non e' mai stata eseguita su
Windows**. Il parser conferma la sintassi, non il comportamento.

---

# 🧪 TERZA VERIFICA — 21/08/2026: secondo FAIL, **1 bloccante nuovo + 5**

_Sempre a numeri **mai visti**, e ancora una volta **il disegno non cambia**:
6 file prova, 12 celle, 24 passate, soglie e canarino intatti._

Il verificatore ha prima **ricontrollato le correzioni precedenti senza fidarsi**
e le ha confermate tutte (cache, terza radice, catena del rischio coi numeri di
riga esatti, pin nel CSV, Desktop, compilazione, TLS, per-trade nel ciclo), ha
riestratto **i sei numeri del canarino dai CSV di R91** — tutti e sei coincidono
con riga, referto e file prova — e ha verificato che le **firme** siano
byte-identiche. Poi ha trovato questo.

## 🚨 N1 (BLOCCANTE) — la spia dei per-trade **accusava le celle SANE**

`$ptPresi -eq 0` ha **DUE** cause, non una:
1. la cella e' stata **ripescata** dalla cache (quello che la spia voleva dire);
2. 🔴 la cella era **GIA' FATTA** e il driver l'ha **saltata**
   (`walkforward_generico.ps1:615`: `if((Test-Path $done) -and -not $Rifai){ ... continue }`).
   Una cella saltata **non apre MT5** e quindi **non riscrive i per-trade**:
   per la spia e' indistinguibile da una ripescata.

**E la riga di lancio consiglia esattamente quel percorso**: *"se la corsa si
interrompe, rimanda lo stesso BLOCCO 2, le celle gia' fatte vengono saltate"*.
Su **24 passate a tick reali** un'interruzione e' probabile — e al rilancio il
referto avrebbe scritto *"CELLE SENZA PER-TRADE FRESCO (sospette di
RIPESCAGGIO)"* su **A20, B20, C20**, cioe' **le tre celle di CANARINO**: il
controllo per cui il round esiste. Claudio avrebbe fermato il round **in buona
fede**, su un allarme falso.

✅ **Corretto:** `$saltata` calcolata guardando se i due CSV esistono gia', voce
separata nel referto — **`CELLE SALTATE (CSV gia' presente, NON rigirate in
questo giro)`** — che dice che quei numeri vengono da un giro **precedente**, e
che se e' una cella di canarino **il suo controllo vale per QUEL giro** (la
cache si svuota a ogni giro). Per rifarla davvero: `-Solo <cella> -Rifai`.

> 📏 **Punto 44 della checklist:** *ogni spia costruita sull'**assenza** di un
> artefatto deve enumerare **tutte** le strade per cui quell'artefatto puo'
> mancare, e va provata sul percorso che il documento **consiglia**, non solo su
> quello dritto.*

## 🧹 R1 e R2 — residui di correzioni che avevo dichiarato chiuse

| dove | cosa diceva ancora |
|---|---|
| `lancia_r94.ps1:37` (intestazione) | *"porta via anche i LOG DEGLI AGENT ... li' c'e' il funnel [BB-FUNNEL]"* — mentre le righe 622-633 **dello stesso file** dicono il contrario |
| `R94_CRITERI.md:306` (tabella, **e questo file viaggia nello zip**) | *"Unico residuo: `lot<=0` (riga 1133), **contato dal funnel**"* — e alla riga 355 lo stesso file spiega che quella frase era sbagliata |

Il secondo e' il piu' grave dei due: **il documento conteneva l'errore e la sua
smentita, non riconciliati** — e la tabella si legge per prima.

> 📏 **Punto 45 della checklist:** *chiudere un difetto non e' correggere il
> punto dov'e' stato segnalato: e' un `grep` del **concetto** su tutti gli
> artefatti del round, intestazioni e tabelle comprese. La stringa che nomina il
> difetto deve comparire **solo dove si spiega che e' stato corretto**.*

✅ Applicato, e **anche ai concetti cambiati in questo giro**: il commento del
driver che citava ancora *"il gate dei 15 minuti"* (che dopo N2 non esiste piu')
e la spia *"se torna in pochi secondi"* (che ora deve escludere le celle
**saltate**) sono stati riscritti insieme al resto.

## ⏱️ N2 — la decisione sul `-SoloControllo` era giusta, il buco era a monte

Un dry-run che rade uno zip non ancora inviato sarebbe una **lettura
distruttiva**: la guardia resta. Ma la cancellazione sta **dopo quattro sezioni
che possono `Muori`**: corsa OK alle 10:00, rilancio alle 10:05 con MetaEditor
aperto, morte in compilazione → **lo zip delle 10:00 aveva 5 minuti e passava il
gate dei 15**.
✅ Ora il gate non guarda piu' un'eta': **lo zip deve essere piu' recente
dell'ora in cui il BLOCCO 2 e' partito** (`$t0`). Provato in laboratorio nei due
versi: zip vecchio → muore; zip scritto dopo `$t0` → passa.

## m1 e m2
- ✅ **guardia su `metaeditor64` aperto** (ce l'aveva il gemello R95: punto 9,
  sicurezza del gemello);
- ✅ **perimetro della pulizia del Desktop = perimetro del riempimento**: con
  `-Solo` la raccolta riempie solo le celle scelte, quindi radere `$dest`
  lascerebbe 2 CSV su 12 con un referto che dice *"MANCANTI: nessuno"*
  (punto 35-bis). Lo zip invece si rifa' sempre. Chiuso insieme a N1, che cita
  `-Solo` come strada di riparazione.

## E nella riga
- ✅ marcatore a **`R94-LANCIO-v3`** (senza il bump la cache di raw avrebbe
  potuto servire la v2 facendo passare il gate);
- ✅ il punto 5 delle anteprime era **un atteso che non poteva verificarsi**:
  `walkforward_generico.ps1:517-518` scrive **solo la gamba IS** (`$WF[0]`),
  quindi l'atteso giusto e' `FromDate 2024.09.26` / `ToDate 2025.06.09`, non
  `2026.06.30`. **Stesso difetto appena chiuso su R93.** Verificato ricalcolando
  la finestra con la stessa `FrazioneIS` del driver: 642 giorni, 40% = 256,
  stacco al **2025.06.09** — che e' esattamente l'IS di R34.

## Cosa e' stato verificato, giro 3
| controllo | esito |
|---|---|
| patch del verificatore | ✅ applicata (`patch -p0`, nessun fuzz) **e riletta riga per riga** |
| `controlla_prova.py` | ✅ 6 file, 12 celle, 24 passate, 0 problemi |
| `lint_ps1.py` | ✅ 0 problemi |
| parser PowerShell (driver + **i due one-liner**) | ✅ 0 errori |
| ASCII puro (7 file) | ✅ 0 byte > 127 |
| `walkforward_generico.ps1:615` (la cella saltata) | ✅ **letto**: `if((Test-Path $done) -and -not $Rifai){ ... continue }` |
| suffisso del CSV | ✅ `$SuffBroker` e' **vuoto su BCM** (riga 107): i nomi che `$giaFatte` cerca sono quelli veri |
| logica `$saltata` | ✅ **eseguita** su albero finto: 2 CSV → saltata; 0 CSV → no; **1 CSV su 2 → no** (il caso parziale non fa scattare la spia) |
| gate dello zip su `$t0` | ✅ **eseguito** nei due versi: vecchio muore, nuovo passa |
| finestra IS dell'anteprima | ✅ **ricalcolata**: 2024.09.26 → 2025.06.09 |
| prova di fumo del driver | ✅ **ripetuta** dopo la patch: scarica, passa i marcatori, supera il gate 33, si ferma su *"terminale BCM non trovato"* |

⚠️ **Quello che resta non verificato:** la riga **non e' mai stata eseguita su
Windows**. Il parser conferma la sintassi, non il comportamento.
