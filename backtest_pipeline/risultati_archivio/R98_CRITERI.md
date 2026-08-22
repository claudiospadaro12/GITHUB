# 📝 R98 — MARKET INTRADAY MOMENTUM SU NASUSD — ✅ **FIRMATI il 22/08/2026**

> ## ✍️ FIRMA (22/08/2026, sera, in chat)
> La decisione aperta del §5.1 e' stata posta a Claudio come *"per firmare i
> criteri R98 manca UNA decisione: quale cancello PF OOS firmiamo?"* e la
> risposta e': **"PF 1,20 + cancello spread"** — cioe' **opzione A**.
> Con quella risposta i criteri sono FIRMATI nella forma della bozza
> presentata (finestra §2, cancello zero §3.2, sei celle §4, bocciature
> §5.2), con S2 = PF OOS >= 1,20 e il cancello zero S0 a fare il lavoro
> pesante. Firmati **a numeri di R98 mai visti**, come da regola di casa.
> Nota di percorso: l'autotest dell'EA e' gia' stato ESEGUITO e verificato
> verde sul PC di Claudio la sera stessa (0 errori di compilazione, 0 FAIL,
> zip `verifica_a1_20260822_230424`) — il gate §3.3 e' quindi gia' passato.

**Oggetto**: `mql5/Experts/ABTG_IntradayMomentum.mq5` v1.00, magic **772800**.
**Da dove nasce**: `report/SWEEP_MECCANISMI_LIBERI_2026-08-22.md` §A1
(punteggio 9/10, "PROVA SUBITO") + `R97_REFERTO.md` (regola della **seconda
caccia**, 19/08).

---

## 0. 🚫 REGOLA ZERO — cosa questo round NON e'

- **NON e' un altro ORB.** R97 ha chiuso il capitolo con 0/4 e una lettura
  precisa: *"le 4 celle hanno GLI STESSI INGRESSI e perdono tutte in OOS,
  quindi il problema sono gli INGRESSI"*. Rifare la stessa famiglia con
  un'altra griglia sarebbe il difetto gia' pagato. Qui il meccanismo e'
  **diverso per costruzione**: non si entra sulla rottura d'apertura, la si
  **misura** e si opera **otto ore dopo**.
- **NON riaccende nessuna sedia.** `ABTG_Nasdaq_Apertura_US` (770201) resta
  spenta; l'ORB del Dow (770611) non viene toccato.
- **NON e' una promozione.** Il round puo' al massimo produrre una **proposta
  motivata** per un round di deploy separato, con criteri propri.
- **I numeri del paper NON sono nostri.** 6,67% annuo OOS, Sharpe 1,08,
  success rate 54,37%, R2 fuori campione 1,2%, costi −1,22 punti percentuali:
  tutti **[DICHIARATI NEL PAPER, NON MISURATI DA NOI]**, su **SPY 1993-2013**.
  Non entrano in nessun cancello. Il nostro edge su NASUSD e' **zero** finche'
  non lo misuriamo noi.

---

## 1. 🎯 LA DOMANDA — una sola

> ### **"Sul NASUSD, il SEGNO della prima mezz'ora di cassa (14:30-15:00 server) predice il verso dell'ultima mezz'ora (20:30-21:00 server) abbastanza da pagare lo spread?"**

**Falsificazione**: se in OOS il motore non e' positivo, o se il lordo medio per
operazione non copre il **CANCELLO ZERO** dello spread (§3.2), la risposta e'
NO e il capitolo si chiude. Niente "riproviamo con un'altra soglia": sarebbe
un'altra griglia dello stesso motore, cioe' l'errore che la seconda caccia
vieta.

---

## 2. 🪟 LA FINESTRA — e per una volta il campione c'e'

| voce | valore | fonte |
|---|---|---|
| simbolo | **NASUSD** | il buco dichiarato dal 21/08 |
| TF del grafico | **M5** | proposto dallo sweep. ⚠️ **L'EA legge barre M1** per misurare le mezz'ore e l'ATR sul suo TF (`InpAtrTF=M30`): il TF del grafico **non cambia i risultati**, ma va dichiarato lo stesso perche' il tester ci costruisce sopra il modello |
| storico | **`@DAQUANDO 2024.09.26`** | `REFERTO_SONDA_STORICO_17-08.md`: NASUSD misurato **COMPLETO** da quella data. Stesso muro di R88/R97 |
| fine | `2026.06.30` | identico a R97, per confrontabilita' |
| split | **40/60** | `walkforward_generico.ps1` default |
| IS | 2024.09.26 → 2025.06.09 | **identico a R97**: le due finestre restano confrontabili |
| OOS | 2025.06.10 → 2026.06.30 | identico a R97 |
| deposito | **100.000** | come R88/R97 |
| rischio | **1,00%** | per restare confrontabili con l'archivio |

### 2.1 🐤 IL CANARINO — e qui la notizia e' BUONA, ma resta da verificare

R97 ha giudicato con **74 operazioni IS**, sotto il canarino dei ~100. Questo
motore fa **~1 operazione al giorno di borsa**: nella stessa finestra ci sono
~460 giorni di borsa, quindi **[INFERITO, NON MISURATO]** ~**180 operazioni in
IS** e ~**270 in OOS** — cioe' **entrambe le finestre sopra le 150 operazioni**
dell'Emendamento (regola A: *l'unita' di misura e' l'OPERAZIONE, non l'anno*).

> ⚠️ **E' un'inferenza, non una misura.** Va confermata con `-SoloControllo`
> **prima** di leggere un solo risultato. Se n IS scende sotto ~100, si applica
> l'Emendamento **regola B** esattamente come in R97: il **RISCHIO** decide, il
> **MERITO** resta sospeso.

### 2.2 Il regime contenuto — dichiarato prima, come sempre
**Un solo regime**: indici USA 2024-2026, fase prevalentemente rialzista.
R98 misura *se l'edge c'e' ADESSO*, non la robustezza di regime (Emendamento,
regola C). Il paper dichiara che la predittivita' **sale** nei giorni volatili,
ad alto volume e in **recessione**: se il regime scelto e' calmo, il round
misura il caso **sfavorevole** al motore. **Va scritto a referto in entrambe le
direzioni**, non solo quando fa comodo.

---

## 3. 🛑 I DUE GATE PRIMA DI QUALUNQUE PASSATA

### 3.1 ✅ PASSO 0 — la conversione punti: **GIA' MISURATA = 100**

**Non e' da rifare.** `R97_REFERTO.md` la riporta come gate firmato e **chiuso**:

> *"Conversione (par. 3, il gate firmato): **MISURATA = 100** (1 punto indice =
> 100 punti MT5), con due misure indipendenti concordi (1.960 ordini in modo
> FIXED, mediana 10 di prezzo; digits del per-trade = 2). Stesso fattore di
> U30USD. **Nessun errore x10 possibile.**"*

Conseguenza operativa per R98: **1 punto indice = 100 punti MT5**, quindi
`InpSlippagePts=100` vale **1 punto indice**. Serve qui perche' lo stop di
questo EA e' in ATR (non in punti) ma **spread e slippage si contano in punti**.

### 3.2 🔴 CANCELLO ZERO — lo spread, e si guarda PRIMA di tutto il resto

Viene dritto dalla scheda A1 (§"CONTRO n.2") ed e' la ferita gia' pagata in R55:

> **Il profitto LORDO medio per operazione, in punti indice, deve valere almeno
> TRE VOLTE lo spread medio misurato di NASUSD nella finestra 20:30-21:00
> server. Se non lo vale, il round si chiude qui e non si spazzola nient'altro.**

Il conto **[INFERITO dai numeri del paper, non nostro]**: 6,67% annuo su ~250
giornate fa ~2,7 punti base al giorno; su un Nasdaq a ~20.000 punti sono
**~5 punti indice lordi** per operazione. Con uno spread BCM di 1-2 punti
indice se ne va **il 20-40% del lordo**. **Questo numero va MISURATO sul nostro
spread, in quella mezz'ora, non stimato.**

Come si misura (proposta): passata singola della cella nuda a tick reali, poi
lordo medio per operazione dal per-trade CSV (`abtg_trades_..._772800.csv`) e
spread medio della fascia da uno script sul simbolo. **[DA DECIDERE]** se lo
spread si misura da un `-SoloReferto` o da una sonda dedicata.

### 3.3 ✅ GATE DELL'AUTOTEST — checklist 55

Prima passata singola: nel giornale devono comparire le righe `[A1][AUTOTEST]`
con **45 casi** e **zero `*** FAIL ***`**, piu' l'autotest del Guardian.
**Se compare un FAIL, i risultati non si leggono nemmeno.**

> ⚠️ **Dichiarazione onesta sullo stato del codice**: l'EA e' stato scritto
> qui, ma **qui non esistono MetaEditor ne' Strategy Tester**. Non e' mai stato
> compilato. La logica pura e' stata verificata trasponendola in C++ (44 casi,
> tutti verdi), **che NON e' una compilazione MQL5**. La prima cosa che deve
> fare Claudio e' **F7**, e poi leggere l'autotest.

---

## 4. 🔬 LE CELLE — screening minuscolo, apposta

Lo sweep lo ha scritto chiaro: *"griglia volutamente minuscola: e' uno
screening, e l'asse che conta e' il cancello zero sullo spread, non la
taratura"*. **Sei celle, una variabile alla volta**, tutte contro la cella nuda.

| cella | cosa cambia rispetto alla nuda | perche' |
|---|---|---|
| **R98-rif** 🥇 **la cella NUDA** | `InpUseOvernightInR1=true`, `InpMinAbsR1Pct=0`, `InpUseSecondSignal=false`, `InpSLatr=2.0` | **e' il paper, letterale**: r1 dalla chiusura di ieri, si opera sempre, un solo predittore |
| **R98a** | `InpUseOvernightInR1=false` | r1 **intraday puro** (open 14:30 → close 15:00). E' un **predittore DIVERSO**, non una taratura: isola quanto pesa il gap overnight |
| **R98b** | `InpUseSecondSignal=true` | la variante del paper (r12 concorde). Dichiarato dal paper: piu' success rate, meno rendimento |
| **R98c** | `InpMinAbsR1Pct=0.10` | la soglia e' un filtro **NOSTRO**: meno operazioni, lordo per operazione piu' alto. E' l'unico asse che puo' muovere il **cancello zero** |
| **R98d** | `InpSLatr=3.0` | quanto costa il **nostro** guardrail: il paper non ha stop, uno stop stretto taglia la coda che paga. Due punti bastano a dire la direzione |
| **R98e** | `InpSlippagePts=100` (= 1 punto indice) | R55: quanto scala la cella. **Non e' una cella promuovibile**, e' una misura di fragilita' |

### 4.1 🩺 LE DUE PASSATE DIAGNOSTICHE SUI LATI — obbligatorie, e NON sono celle

`InpAllowLong=false` e `InpAllowShort=false`, una per volta, sulla cella nuda.
**Servono a DICHIARARE**, non a scegliere: malattia R52 — *un lato non si
spegne MAI guardando i risultati*. Se il round finisse con "teniamo solo i
long perche' gli short perdono", quella e' una decisione da **firmare a
parte**, in un round dopo, non un esito di questo.

### 4.2 ❌ Cosa NON si spazzola in R98
Orari (sono la campanella, non parametri), `InpSignalMinutes` (il paper usa 30),
`InpEntryWindowMin`, `InpExitSafetyMin`, ATR period. **Se questi diventano
assi, non stiamo piu' misurando il paper: stiamo pescando.**

---

## 5. 🚪 I CANCELLI — proposta, con UNA tensione dichiarata

| # | cancello | soglia proposta |
|---|---|---|
| **S1** | DD OOS | **<= 7,00%** (identico a R88/R97) |
| **S2** | PF OOS | **>= 1,20** ✅ **FIRMATO (opzione A, §5.1)** |
| **S3** | IS | profitto > 0 **e** PF IS >= 1,10 (identico a R97) |
| **S4** | campione | n OOS >= 150 **e** n IS >= 150 (Emendamento regola A) — piu' severo di R97 (95/57) **perche' qui il campione c'e'** |
| **S0** | **cancello zero spread** (§3.2) | lordo medio/operazione >= **3x** lo spread medio della fascia |

### 5.1 ⚠️ LA TENSIONE, scritta prima e non nascosta: **PF 1,40 o 1,20?**

R97 usava **PF OOS >= 1,40**. Copiarlo qui sarebbe comodo (confrontabilita')
ma **rischia di essere un cancello sbagliato per questo motore**, e la ragione
e' strutturale, non un'opinione:

- l'ORB di R97 ha **TP a 1,5-2R**: pochi vincitori grossi, PF alto o niente;
- questo motore **non ha TP**: esce all'orario, quindi i vincenti e i perdenti
  hanno **taglia simile**. Un motore che vince il 54% delle volte con payoff
  ~1:1 sta strutturalmente intorno a **PF 1,1-1,3**, non 1,4.

Chiedere 1,40 a un motore a payoff simmetrico e' come chiedere a un maratoneta
il tempo sui 100 metri: **non e' severita', e' un'unita' di misura sbagliata**.

> ### 🖊️ **DECISO DA CLAUDIO, 22/08 sera, PRIMA dei numeri: OPZIONE A.**
> - ✅ **opzione A (FIRMATA)**: **PF OOS >= 1,20**, motivato dalla forma del
>   payoff, con il **cancello zero sullo spread (S0)** che fa il lavoro pesante;
> - ❌ opzione B (scartata): PF OOS >= 1,40, identico a R97 — rischiava di
>   bocciare un edge vero per la sola forma del payoff.
>
> Scelta scritta PRIMA di qualunque numero di R98, come da regola di casa.
> Da qui in avanti NON si cambia.

### 5.2 🔴 Bocciatura secca (proposta)
- **profitto netto <= 0 in OOS**;
- **cancello zero S0 fallito** (il lordo non copre 3x lo spread);
- **peggior giornata peggiore di −2,5%** al rischio 1%: con **una** posizione e
  **un** trade al giorno, un valore peggiore di ~1R e' **un BUG, non un
  risultato** (criterio 3 della bozza dello sweep) — e va trattato come tale:
  si guarda il codice, non si tara.

---

## 6. 📋 COSA PUO' USCIRE, E COSA NO

- **Puo' uscire**: una proposta motivata di round di **deploy** (sedia NASUSD
  nuova, magic 772800, fascia oraria 20:30 server — dove oggi **non abbiamo
  nessuno**: le nostre aperture sparano alle 08:00 e alle 14:30, quindi la
  scorrelazione qui e' **oraria e vera**, non dichiarata).
- **Puo' uscire**: un **verdetto negativo pulito**, che vale quanto uno
  positivo. Se il Nasdaq non ha intraday momentum nel 2024-2026, lo scriviamo
  e passiamo oltre — e la seconda caccia sul Nasdaq si chiude qui, perche' due
  meccanismi diversi bocciati sullo stesso mercato dicono qualcosa sul mercato.
- **NON puo' uscire**: nessuna sedia accesa direttamente da questo round.
- **NON puo' uscire**: nessun giudizio sul paper. Noi misuriamo **NASUSD a BCM
  nel 2024-2026**, non SPY 1993-2013. Se qui non funziona, il paper non e'
  "sbagliato": **non trasferisce sul nostro strumento, nel nostro regime, coi
  nostri costi**.

---

## 7. 📄 IL FILE PROVA (bozza — nomi degli input **vincolanti**)

⚠️ `LEGGIMI.md`: **un nome sbagliato e MT5 ignora la riga in silenzio.** Questi
nomi sono presi dal sorgente appena scritto, non dalla memoria.

```
# IPOTESI: sul Nasdaq il SEGNO della prima mezz'ora di cassa (14:30-15:00 server)
#          predice il segno dell'ultima mezz'ora (20:30-21:00 server).
#          Fonte: Gao, Han, Li, Zhou. Nostro edge = ZERO finche' non e' misurato.
# CANCELLO ZERO: lordo medio/operazione >= 3x lo spread medio della fascia.
@SIMBOLO  NASUSD
@PERIODO  M5
@DAQUANDO 2024.09.26
InpMagic=772800||772800||1||772801||Y     # magic-sweep: due passate che DEVONO coincidere
InpUseOvernightInR1=1||1||0||1||Y         # 1 = definizione del paper (r1 dalla chiusura di ieri)
InpMinAbsR1Pct=0||0||0||0.10||Y           # 0 = come il paper; 0.10 = filtro NOSTRO
InpUseSecondSignal=0||0||0||1||Y          # variante r12 del paper
InpSLatr=2.0||2.0||2.0||3.0||Y            # guardrail NOSTRO, non del paper
InpRiskPercent=1.0||1.0||0||1.0||N
InpSignalStartHour=14||14||0||14||N       # ORA SERVER: 14:30 = apertura cassa USA
InpSignalStartMin=30||30||0||30||N
InpSignalMinutes=30||30||0||30||N         # il paper usa 30: NON si spazzola
InpEntryHour=20||20||0||20||N             # ORA SERVER
InpEntryMin=30||30||0||30||N
InpExitHour=21||21||0||21||N              # ORA SERVER: chiusura cassa
InpExitMin=0||0||0||0||N
InpSlippagePts=0||0||0||100||Y            # 100 pt MT5 = 1 punto indice (conversione R97)
InpVerbose=1||1||0||1||N
InpAutoTest=1||1||0||1||N
```

---

## ✍️ FIRMA — ✅ **APPOSTA il 22/08/2026 sera** (verbale in testa al file)

```
[x] §2   la finestra IS/OOS e il canarino
[x] §3.2 il CANCELLO ZERO sullo spread (3x)
[x] §4   le sei celle + le due passate diagnostiche sui lati
[x] §5.1 PF OOS: OPZIONE A (1,20)  <-- LA DECISIONE, presa prima dei numeri
[x] §5.2 le tre bocciature secche
```

**Stato del percorso**: (1) F7 + autotest ✅ FATTO il 22/08 alle 23:04
(0 errori, 0 FAIL); (2) firma ✅ FATTA; (3) prossimo: `-SoloControllo` per
confermare il canarino (n IS ~180 e' [INFERITO], va misurato); (4) solo dopo,
la corsa vera.

**E la riga finale, quella onesta**: un backtest verde non e' una promessa.
Broker singolo, un regime solo, costi modellati al primo ordine, e un motore
che vive di **30 minuti al giorno** — cioe' proprio i 30 minuti in cui lo
spread e' piu' largo. Il collaudo vero resta il **forward demo**.
