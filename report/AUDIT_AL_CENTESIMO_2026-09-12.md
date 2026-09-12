# 🔍 AUDIT AL CENTESIMO — 12/09/2026

> Claudio: _"RICONTROLLIAMO TUTTO PERCHE' AD OGGI ABBIAMO 7 AGENTI, PRIMA NE
> AVEVAMO SOLO 1. CONTROLLIAMO TUTTO AL CENTESIMO E RIFACCIAMO I BACKTEST."_

---

# 🚦 LA RISPOSTA CHE SERVE SUBITO

## ❓ C'e' un'altra riga da spegnere prima delle 03:30?

# ➡️ **NO.**

Nessuna delle **27** righe di round in coda ha il difetto cercato, e nessuna ha
un difetto che ne giustifichi lo spegnimento. Misurato, non stimato:

- le celle dei 27 file prova sono **129 in totale** (258 passate), e il file
  piu' grosso ne fa **9** (`R133c`, `R126a`, `R126d`);
- **27 su 27** dichiarano nei propri commenti quante celle si aspettano, e
  **27 su 27 tornano**: 8=8, 2=2, 9=9, 7=7, 7=7, 4=4, 2=2, 8=8, 9=9, 7=7, 7=7,
  9=9, 2=2 (x6 sui magic gemelli), 7=7, 2=2, 2=2, 7=7, 7=7, 2=2, 4=4, 4=4, 3=3;
- **nessuno dei 27** ha un asse su un input `ENUM_*` (verificato aprendo il
  `.mq5` dell'`-Expert` della coda, input per input: 12 `double`, 6 `long`,
  4 `int`, 2 `bool`, 3 `double`);
- **0 problemi** da `controlla_prova.py` su tutti e 27.

## 🟢 E C'E' UNA RIGA DA RIACCENDERE, INVECE

🔴 **`cemad05` e' stata spenta per un numero SBAGLIATO.** Il suo costo vero
non e' 16.374 celle: e' **7**. Dettaglio completo al §1. In sintesi:

| | dichiarato ieri | **misurato oggi** |
|---|---|---|
| celle | 16.374 | 🟢 **7** |
| passate | 32.748 | 🟢 **14** |
| peso nella coda | 99,2% | 🟢 **5,1%** (7 su 136) |
| fattore sulla notte | **128x** | 🟢 **1,05x** |

👉 **La decisione resta tua** (`CODA.txt` la gestisci tu, io non l'ho toccata).
Ma la motivazione scritta nel commit `43e4e30` **non regge**: quella riga non
teneva in ostaggio nessuno. Se resta spenta, deve restarlo per l'**altra**
ragione — che il requisito 5 di `ABTG_EMA200` e' chiuso dal 01/08 — e quella
regge benissimo.

## 🟢 LA NOTTE E' LIBERA: 39 righe su 39 passano il cancello VERO

Non l'ho dedotto leggendo: **ho fatto girare il cancello del runner** sui
sorgenti scaricati **ai loro pin**.

```
VAGLIO DELLE 39 RIGHE DI CODA AI LORO PIN: 39 righe, 0 rifiutate
```
E il collaudo interno del runner: **`COLLAUDO: 50 giusti, 0 sbagliati su 50`**.

---

# 1. 🎭 LA CLASSE CACCIATA — e il verdetto si ribalta sul caso di partenza

## 1.1 Il difetto esiste, ma non e' quello che sembrava

La classe da cacciare era: *un asse scritto come intervallo con passo su un
input il cui dominio non e' contiguo*. L'ho cercata in **tutti i 689** file
prova. La trovo in **20 file**. Ma prima di elencarli va detta la cosa che
cambia tutto.

🔴 **MT5 non esegue quell'intervallo. E il nostro driver lo sa da mesi.**

`walkforward_generico.ps1` r.784-790 — il codice, non un commento.
⚠️ **CITAZIONE, NON UNA RIGA DA LANCIARE**: il blocco qui sotto e' sorgente
copiato dal driver, e la staccionata e' senza linguaggio di proposito (il
cancello deterministico legge un blocco ```` ```powershell ```` come una riga
di lancio, e me l'ha giustamente bocciato — classe 173).
```
if($EnumMembri.ContainsKey($tipoP)){
  # ENUM: MT5 IGNORA LO STEP e spazzola i membri fra start e stop.
  $celle=@($EnumMembri[$tipoP] | Where-Object { $_ -ge $lo -and $_ -le $hi }).Count
```

Quindi su `InpTF=16385||15||1||16388||Y` le celle **non** sono 16.374: sono i
**membri** di `ENUM_TIMEFRAMES` fra 15 e 16388, cioe' **M15 M20 M30 H1 H2 H3
H4 = 7**.

## 1.2 Il file prova lo aveva scritto. Nero su bianco. Prima.

`COLLAUDO_EMADOW_05_tf_U30USD.txt` r.59-69:
> *"QUANTO COSTA: MT5 sugli enum ignora lo step e spazzola i MEMBRI fra start e
> stop: 15=M15, 20=M20, 30=M30, 16385=H1, 16386=H2, 16387=H3, 16388=H4 = **7
> celle** x 1 x 1 corsa x 2 gambe (IS + OOS) = **14 passate**."*
> *"ATTENZIONE A UN NUMERO CHE MENTE... `controlla_prova.py` conta questo asse
> ARITMETICAMENTE e stampa `celle=16374`. **E' sbagliato per costruzione**...
> Le celle vere sono SETTE, e il driver le conta bene."*

🔴 **La causa non e' un errore di calcolo: e' che il numero del cancello e'
stato creduto invece del file che lo smentiva.** E' la classe 276 (due
strumenti di casa, verdetti opposti) applicata a un **numero** invece che a un
verdetto.

## 1.3 La verifica in TRE modi indipendenti, contro numeri scritti da altri

Non ho verificato la mia risposta contro se stessa. L'ho verificata contro
numeri che stavano **gia'** in casa, scritti da qualcun altro:

| fonte, scritta da altri | dichiara | il conto corretto da' |
|---|---|---|
| `COLLAUDO_EMADOW_05` r.59-61 | 7 celle | 🟢 **7** |
| `R128a_trailingTF_D30EUR` r.255-257 | 7 celle | 🟢 **7** |
| `R128a` r.265-268, **dall'archivio**: `InpTF=16385\|\|15\|\|1\|\|16408\|\|Y` produsse **11 RIGHE** (40+ CSV in `risultati_prove\`) | 11 | 🟢 **11** |

Il terzo e' il piu' forte: e' una misura **reale**, fatta in archivio, contro
cui l'aritmetica avrebbe detto 16.394.

## 1.4 I 20 file con la scrittura pericolosa — elencati per NOME

Non "tutto cio' che non e' a posto" (classe 180): l'elenco.

**In coda stanotte: ZERO.**

| file | asse | aritmetico | **vero** | in coda? |
|---|---|---:|---:|---|
| `COLLAUDO_EMADOW_05_tf_U30USD.txt` | `InpTF` | 16.374 | **7** | no (spenta) |
| `R133a_livelliTF_NASUSD.txt` | `InpLevelTF` | 16.374 | **7** | no (commentata) |
| `R128a_trailingTF_D30EUR.txt` | `InpTrailTF` | 26 | **7** | no |
| `R17_oro_notte.txt` | `InpMgmtTF` | 16.363 | n/d (2 assi, EA non risolto) | no |
| **17 legacy** `ABTG_*.txt` (07/08, "PROVA FASE 0") | `InpTF` | 16.394 | **11** | no |

🔎 **E la scoperta utile: i 17 legacy vengono da un GENERATORE, non da 17
errori.** Tutti portano la stessa riga alla stessa posizione (r.34), con due
sole varianti di start (`16385` e `16388`). E' un **modello copiato**, ed e'
l'origine della classe. Quei 17 il cancello li scarta gia' per altra via: non
hanno la riga `# EA:`, quindi escono **`EA NON TROVATO -> non misurabile`**.

⚠️ **Un caso che non e' un difetto e va detto per non allarmare**:
`ABTG_DAX_Apertura_EU.txt` e `R24_trailing_nasdaq.txt` portano
`InpTrailTF=5||1||1||5||Y`. Li' aritmetica ed enumerazione **danno la stessa
risposta** (1,2,3,4,5 sono tutti membri): 5 celle in entrambi i modi. Sono
sani, e sono anche la ragione per cui il difetto e' sopravvissuto tanto — la
nota dell'08/08 diceva "misurato", ma era misurato **sul caso che non
distingue** (lo nota `R128a` r.259-262).

---

# 2. 🔧 PERCHE' IL CANCELLO NON L'HA FERMATA — e la toppa

## 2.1 La diagnosi corretta

La domanda era *"il numero era stampato e nessuno lo guardava"*. 🔴 **Vero solo
a metà, e l'altra metà e' piu' grave: il numero era SBAGLIATO.** Se fosse stato
guardato, avrebbe fatto spegnere una riga sana — che e' esattamente quello che
e' successo.

Quindi ho toppato **prima la causa, poi il sintomo**.

## 2.2 Toppa 1 (la causa): `controlla_prova.py` conta come il driver

Le tabelle degli enum sono **copiate** da `walkforward_generico.ps1` r.385-413,
non inventate — `PERIOD_CURRENT=0` escluso compreso, come fa il driver a r.412.
Il doppione e' **dichiarato nel commento**: se il driver cambia, va rifatto.

Effetto misurato su tutto l'archivio:

| | prima | dopo |
|---|---:|---:|
| celle totali sui 689 file | **33.472** | 🟢 **719** |
| problemi trovati | 476 | 🟢 **476** |

👉 Il conto aritmetico gonfiava l'archivio di **46,5x**, e i problemi restano
**476 prima e 476 dopo**: nessuna regressione, nessun falso FAIL nuovo.

E quando i due conti differiscono il cancello **stampa tutti e due**:
```
COLLAUDO_EMADOW_05_tf_U30USD.txt  ABTG_EMA200.mq5  pin=42 celle= 7  OK
    . asse ENUM (ENUM_TIMEFRAMES): il passo e' IGNORATO, celle = membri
      fra 15 e 16388 = 7  [il conto aritmetico direbbe 16374: NON guardarlo]
```

Aggiunto anche: **asse enum con ZERO membri nell'intervallo → PROBLEMA**, non
`celle=0` in silenzio (il driver non farebbe nemmeno una passata).

## 2.3 Toppa 2 (il sintomo): il TETTO — soglia dichiarata PRIMA dei numeri

**La regola, scritta prima di guardare la distribuzione:**
1. **FAIL** a un tetto posto *sopra la griglia legittima piu' grande che il
   progetto abbia mai scritto*, con almeno **2x** di margine — perche' **un
   falso FAIL costa quanto un falso PASS**.
2. **Avviso, non FAIL**, se un file fa piu' del **50%** delle celle del gruppo:
   e' un'affermazione strutturale ("un file pesa piu' di tutti gli altri
   insieme"), non un numero tarato.
3. **FAIL senza soglia** se l'asse e' su un enum e i valori non sono membri.

**Poi** la distribuzione vera. Popolazione dichiarata: i **217** file mono-asse
con EA risolvibile (la popolazione che il cancello giudica), contati con la
regola del driver:

| | valore |
|---|---:|
| p50 | **2** |
| p90 | **7** |
| p95 | **8** |
| p99 | **10** |
| **massimo MAI scritto** | **24** (`R129a`, `R129b`) |
| file sopra 24 | **0** |
| file sopra 40 | **0** |
| file sopra 64 | **0** |

👉 La distribuzione e' **bimodale con un buco vuoto largo 16.338**: 502 file
legittimi tutti ≤24, i difettosi tutti ≥16.363, **niente in mezzo**. Qualunque
soglia in quel buco separa perfettamente. Scelta: **64** = 2,67x il massimo
storico, 6,4x il p99. `--tetto` e `--quota` sono parametri: una griglia grossa
davvero necessaria si autorizza e **si dichiara nel referto**.

## 2.4 🧪 I CONTRO-ESEMPI — provato a ROMPERLO, non a confermarlo

| contro-esempio | atteso | misurato |
|---|---|---|
| **falso FAIL**: tetto 64 su tutti i 689 file | 0 bocciature | 🟢 **0** |
| **vero FAIL**: griglia da 601 celle costruita a posta (`0.4..1.6` passo `0.002`) | bocciata | 🟢 **bocciata** |
| **regressione**: problemi prima vs dopo sui 689 | identici | 🟢 **476 = 476**, insiemi identici |
| **i 27 in coda** devono restare verdi | 0 problemi | 🟢 **129 celle, 0 problemi** |
| **enum vuoto** (`16397..16400`) | problema | 🟢 **problema** |
| **quota** su un gruppo dove un file vale il 98,8% | avvisa | 🟢 **avvisa** |
| **quota** su coda vera + `cemad05` (7 su 136) | NON avvisa | 🟢 **non avvisa** |

📌 Classe nuova in checklist: **287** (numero verificato col grep su tutto il
repo: 0 occorrenze precedenti).

---

# 3. 🕸️ L'INCROCIO FRA I 7 AGENTI

**157 commit oggi.** Cercati i difetti che nascono *solo* dal lavoro parallelo.

## 3.1 🔴 Numeri di classe DUPLICATI — ce n'e' un TERZO, e non e' di oggi

Popolazione: le **271** intestazioni `##` numerate della checklist (escluse 5
`###`, che sono sotto-titoli e non classi).

| numero | occorrenze | righe |
|---|---:|---|
| **5** | 2 | 73, 127 |
| **26** | 2 | 636, 674 |
| **101** | **3** | 5168, 5270, 9162 |

👉 Oltre alle due collisioni di oggi (252 e 267, gia' rinumerate), la **101 e'
tripla** e la 5 e la 26 sono doppie. Sono vecchie, non di oggi — ma chi cita
"classe 101" oggi cita **tre cose diverse**.

## 3.2 🔴 Classi CITATE ma MAI SCRITTE — il debito piu' caro

Buchi nella serie: `42 43 44 45 156 157 160 161 162 163 164 181 182 183 244
250 270 272 273`. La maggior parte sono numeri mai usati. **Ma quattro sono
citati come se esistessero:**

| classe | dove e' citata | nella checklist |
|---|---|---|
| **270** | 6 referti + `RIGA_SOTTILE_ROUND.ps1` (13+ citazioni) | 🔴 **ZERO** |
| **273** | `RIPINNAGGIO_CODA`, `SETTE_IN_CODA` | 🔴 solo in prosa, nessuna intestazione |
| **272** | `CODA_12_pertrade_posizioni.ps1` | 🔴 solo in prosa |
| **164** | **`CLAUDE.md`** e **`CODA.txt`** (il pin che deve essere un commit) | 🔴 solo in prosa |

🔴 La checklist e' la memoria: _"se una classe non ci finisce, la si ripaga"_.
La **270** in particolare e' la toppa che ha cambiato l'impronta del driver
(`$SHA_WALK`) **stamattina** e non ha una riga sua.

## 3.3 🟢 Magic, etichette, collisioni: PULITO

| controllo | risultato |
|---|---|
| magic duplicati **dentro** i 27 in coda | 🟢 **0** (27 valori distinti) |
| magic duplicati contro le **42 sedie vive** (letti dai `.chr` di stanotte, `CODA_08`) | 🟢 **0** |
| valori spazzolati dagli assi-magic (`+1`) che collidono | 🟢 **0** |
| etichette duplicate in coda | 🟢 **0** (39 distinte) |
| conti vietati negli argomenti della coda | 🟢 **0** |

⚠️ **Un rilievo, non un difetto**: il blocco `7862xx` e' condiviso fra
`R136b` (786200, `ABTG_EMA200`) e la famiglia `R137/R138` (786201-786205,
`ABTG_DAX_Apertura_EU`). Nessuna collisione esatta, EA diversi. Ma due agenti
hanno pescato dallo stesso blocco lo stesso giorno: la prossima volta basta
un `+1` sfortunato.

## 3.4 🟢 File toccati da due agenti nello stesso minuto: 1, benigno

`report/SECONDA_CACCIA_2026-09-12.md` — `508d8a0` (14:47:15) lo crea, `ecb7788`
(14:47:39) corregge **una riga**. Sequenziali, stesso autore, nessuna
sovrascrittura.

## 3.5 🔴 IL DIFETTO DA 7 AGENTI E' CAPITATO A ME, MENTRE SCRIVEVO QUESTO

Non e' un aneddoto: e' la classe cercata, **colta in diretta**, ed e' la prova
migliore che Claudio ha ragione a volere il ricontrollo.

**Alle 18:35:15** il commit `61c232e` — **non mio** — ha inghiottito le mie due
modifiche non ancora committate:

| file nel commit `61c232e` | di chi e' |
|---|---|
| `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (+100) | 🔵 **mio** (classe 287) |
| `backtest_pipeline/controlla_prova.py` (+146/−4) | 🔵 **mio** (toppa enum + tetto) |
| `backtest_pipeline/prove/R141a_momentum_NASUSD_r12.txt` (+321) | 🟠 **di un altro agente** |
| `backtest_pipeline/prove/R141b_momentum_U30USD_gemello.txt` (+168) | 🟠 **di un altro agente** |

🔴 **La causa e' un `git add -A` (o `commit -a`) su un albero condiviso.** Il
risultato: **un commit che dichiara una cosa e ne contiene quattro**, di due
mani diverse. Se una delle due meta' fosse stata sbagliata, si sarebbe dovuto
revertire anche l'altra — e il messaggio del commit non avrebbe aiutato
nessuno a capire quale.

👉 **Ed e' la ragione per cui questa consegna aggiunge i file PER NOME.** Con
sette agenti su un albero solo, `git add -A` non e' una scorciatoia: e' un
modo di committare il lavoro di qualcun altro **a meta'**.

🟢 **Danno effettivo: ZERO, ma per fortuna, non per metodo.** Verificato:
- il `controlla_prova.py` in HEAD e' **identico** al mio (albero pulito);
- i due `R141` presi in ostaggio **passano il cancello**: 2, 2 celle, 0 problemi;
- i loro magic (`784101`, `784102`) non collidono con **niente**: 0 sedie vive,
  0 righe in coda, 1 sola occorrenza a testa in tutti i file prova.

🟠 **E mentre scrivo ce ne sono altri due in lavorazione**, non tracciati:
`R141c_atrexh_M30_NASUSD.txt` e `R141d_hvancora_stopatr_M30_U30USD.txt`. Li ho
passati al cancello lo stesso (2 e 4 celle, **0 problemi**, magic `784103`/
`784104` liberi).

🟢 **E un dividendo immediato della toppa di oggi**: su `R141c` il cancello
nuovo ha **gia'** riconosciuto un asse enum — `InpSlMode`… no, `ENUM_EX_PROX` —
e l'ha contato **come membri, non come intervallo**:
```
R141c_atrexh_M30_NASUSD.txt   ABTG_AtrExhaustVol.mq5  pin=35 celle= 2  OK
    . asse ENUM (ENUM_EX_PROX): il passo e' IGNORATO, celle = membri fra 0 e 1 = 2
```
Con il vecchio conto aritmetico avrebbe detto 2 anche lui (0..1 passo 1 e'
il caso che **non distingue**, §1.4) — ma ora il tipo e' **dichiarato in
chiaro**, e il prossimo asse enum con estremi larghi non potra' piu' mentire.

## 3.6 ⚠️ Quattro PRESET toccati oggi — controllato, e va bene

`2ad4450` (00:33) aggiunge **4 `.set` NUOVI** per le sedie del 100k, fra cui
`770101` che e' un **magic VIVO**. 🟢 **Non e' una modifica al forward**: 892
inserimenti, **0 cancellazioni**, sono file nuovi che **fotografano** la
configurazione esistente, e lo dichiarano in testa. Nessun parametro di una
sedia viva e' stato cambiato.

🟢 E il numero del genitore regge: **ZERO `.mq5` e ZERO `.mqh` toccati oggi** —
verificato, e conta perche' il driver compila l'EA dall'HEAD del branch.

---

# 4. 🔬 RIVERIFICA DEI NUMERI DEL GENITORE — quello che regge e quello che no

| numero dichiarato | verdetto | misura mia |
|---|---|---|
| 39 righe eseguibili | 🟢 **regge** | 39 |
| 18 round a `1445abf8` | 🟢 **regge** | 18 (+1 `84999392`, +1 `8d9d4fb9`, +7 `0c38419f` = 27 round) |
| 12 pin distinti, tutti commit | 🟢 **regge** | 12, `git cat-file -t` = `commit` per tutti e 12 |
| 10 Expert su 10 presenti | 🟢 **regge** | 10 distinti, tutti in `mql5/Experts/` |
| 0 conti vietati negli argomenti | 🟢 **regge** | 0 |
| ZERO EA e include toccati oggi | 🟢 **regge** | 0 `.mq5`, 0 `.mqh` |
| 4 driver in coda, **2 distinti** | 🟢 **regge** | `62A53763` x18, `15DE7D5F` x9 |
| toppa 270 in tutti e due | 🟢 **regge** | `ex5Atteso` x2 in entrambi |
| **56 righe** non-commento di differenza | 🟢 **regge** | ne conto **57**, di cui **1 e' una riga vuota** → 56 sostanziali. 📌 Differenza di **popolazione**, non errore: la sua e' quella giusta |
| **40 su 40** righe con HTTP 200 | 🟡 **popolazione cambiata** | la coda ora ha **39** righe (la 40ª era `cemad05`). Ho riverificato in altro modo: **39 su 39** file esistono al proprio pin (`git cat-file -e`), 0 mancanti |
| "16.374 celle, 99,2%, fattore 128" | 🔴 **NON REGGE** | §1: celle vere **7**, peso **5,1%**, fattore **1,05x** |

## 4.1 ❓ LA SUA DOMANDA APERTA: due driver rendono i round non confrontabili?

# ➡️ **NO.** E non e' un'opinione: e' misurato.

`15DE7D5F` = `62A53763` **+ solo aggiunte**:
```
rimozioni fra i due driver: 0
```
Tutte le aggiunte stanno dentro `if($Direttive.ContainsKey("FRAZIONEIS"))`,
oppure sono un `[switch]` nuovo con default falso, oppure `Write-Host`.
**In assenza della direttiva `@FRAZIONEIS` i due driver sono la stessa cosa.**

E la direttiva chi la usa? **Solo 2 dei 27 file** — ed entrambi stanno sul
driver **giusto**:

| file | direttiva | driver | esito |
|---|---|---|---|
| `CANARINO_FRAZIONEIS_D30EUR.txt` | `@FRAZIONEIS 0.50` | `15DE7D5F` | 🟢 lo legge |
| `COLLAUDO_EMADOW_02_pertrade_IS.txt` | `@FRAZIONEIS 0.002` | `15DE7D5F` | 🟢 lo legge |
| gli altri **18** su `62A53763` | nessuna | — | 🟢 nessun effetto |

👉 **Accoppiamento corretto.** Se uno dei 18 avesse avuto `@FRAZIONEIS`, il
vecchio driver l'avrebbe **ignorata in silenzio** girando al taglio di fabbrica
0.40: quello sarebbe stato un difetto grave. Non c'e'.

## 4.2 ❓ `r132c` riproduce R123D: e' lo stesso banco?

**R123D e' girato il 09/09 alle 20:19.** Il driver di allora era `36370C65`
(commit `0de31c0a`, 08/09). `r132c` girera' su `62A53763`. 🔴 **Driver diverso,
537 righe non-commento di differenza.** L'ho guardato a fondo:

**🟠 Prima ho creduto di aver trovato una mina, e poi l'ho rotta io.**
`c2b157c3` (11/09) dice *"@FINOA non era letta"*, e `R123d` dichiara
`@FINOA 2026.06.30`. Sembrava la finestra spostata → le 5 celle non potevano
tornare → round dichiarato NULLO per un motivo falso.
🟢 **FALSO ALLARME, e il controesempio e' il default**: il driver dell'08/09
ha `[string]$Fino = "2026.06.30"` (r.160) — **la stessa data**. Ignorava
`@FINOA`, ma partiva comunque da li'. **Finestra identica.**

Le altre verifiche:

| controllo | esito |
|---|---|
| righe del diff che toccano `FromDate`/`ToDate`/`Model`/`Deposit`/`Leverage`/`Spread`/`Symbol`/`Period`/`Forward`/`Delay` | 🟢 **0** |
| `$FrazioneIS` di fabbrica nei due driver | 🟢 **0.40 = 0.40** |
| `RIGA_SOTTILE_ROUND.ps1` passa `-Fino` o `-FrazioneIS`? | 🟢 **no** → vince `@FINOA` = stessa data |
| `@DAQUANDO` letta da entrambi | 🟢 sì (r.476 nel vecchio) |

👉 **Conclusione: il banco e' lo stesso per tutto cio' che il repo puo'
dimostrare.** Le 537 righe sono **guardie** (scelta del terminale, terminali
vietati, normalizzazione percorsi, lettura `@FINOA`), non impostazioni del
tester. Il cancello di `r132c` e' **legittimo**.

🕳️ **Il residuo, e lo dichiaro invece di coprirlo**: non posso verificare **su
quale terminale fisico** girò R123D. Se girò su una cartella dati diversa da
`C:\MT5_Backtest`, il feed potrebbe differire. Cosa lo chiude: il log della
corsa del 09/09 con la riga *"terminale scelto"* del driver. 👉 E se le 5 celle
**non** tornano, la prima cosa da guardare e' **`n`**, non il PF — come il file
prova stesso prescrive a r.64-66.

---

# 5. ✅ I "BACKTEST DA RIFARE" — confermo la sua correzione, con UNA rettifica

## 🟢 Confermato: NESSUN round e' mai stato misurato. Non c'e' niente da rifare.

| prova | risultato |
|---|---|
| CSV di round prodotti oggi | 🟢 **0** (i soli 2 CSV di oggi sono `SPREAD_VIVO_*`, un'altra catena) |
| `REFERTO_ROUND_*` in archivio | 🟢 **0** |

## 🔴 LA RETTIFICA, e cambia il racconto: il runner E' GIRATO STAMATTINA

Lei scrive *"la coda parte alle 03:30, nessun round di oggi e' girato"*. La
conclusione e' giusta, **la ragione no**:

`backtest_pipeline/coda/referti/REFERTO_RUNNER_20260912_033002.txt` — il runner
**e' partito**, alle **03:30:02** di oggi, su **15 righe**:
```
eseguiti  : 11
rifiutati : 4
falliti   : 0
ESITO: PARZIALE
```
E i 4 rifiutati sono **esattamente i 4 round** (`r132c`, `r133b`, `r133a`,
`r133c`), tutti con lo stesso motivo:
```
RIFIUTATO -- G1: manca il marcatore 'RUNNER_SOLA_LETTURA'.
```

🔎 **Perche':** quel messaggio ha il testo del runner **v2** (un marcatore
solo, `$MARC_RICHIESTO`). La **corsia ROUND** (`RUNNER_ROUND_BACKTEST`) e'
nata l'11/09 nel commit `19e3445`, il cui messaggio dice — testuale — *"IN
CORSO D'OPERA — **NON INSTALLARE IL RUNNER**"*. Alle 03:30 sul VPS girava
ancora il v2, che quel marcatore non lo conosceva.

## 🟢 E il perche' stanotte funziona — verificato, non sperato

Ero a un passo dal dichiarare bloccata tutta la notte. **Poi ho cercato la
prova del contrario e l'ho trovata**: `report/RUNNER_V3_IN_CAMPO_2026-09-12.md`
— runner v3 installato oggi alle **08:45**. Riverificato da me sull'artefatto:

| controllo | atteso | misurato |
|---|---|---|
| righe del runner a HEAD | 836 | 🟢 **836** |
| sha256 | `21AC6672…` | 🟢 **`21AC6672`** |
| `MARCATORE_RUNNER_ABTG_v3` | presente | 🟢 **2** |
| `MARCATORE_RUNNER_ABTG_v2` | assente | 🟢 **0** |
| `$MARC_ROUND = "RUNNER_ROUND_BACKTEST"` | presente | 🟢 **r.109** |
| collaudo interno `-CollaudoCancelli` | tutto verde | 🟢 **50/50** |
| le 39 righe ai loro pin nel cancello vero | 0 rifiutate | 🟢 **0** |

👉 **La lezione da incassare**: stamattina 4 round su 4 sono morti su un
cancello, e il referto lo diceva a chiare lettere. **Nessuno dei referti di
oggi ha ripreso quel `rifiutati : 4`.** Domattina la prima cosa da leggere e'
la riga `RIEPILOGO` del referto, prima di qualunque PF.

---

# 🕳️ NON COPERTO — i buchi, dichiarati

1. **Su quale terminale fisico girò R123D** (§4.2). Non e' nel repo. Serve il
   log della corsa del 09/09 con la riga "terminale scelto".
2. **HTTP 200 dal raw di GitHub** sulle 39 righe. Non l'ho rifatto: ho
   verificato l'**esistenza dell'oggetto git** al pin (`git cat-file -e`,
   39/39). E' una prova piu' forte sul contenuto ma **non** prova che
   `raw.githubusercontent.com` risponda — se un commit non fosse stato
   **pushato**, in locale c'e' e da remoto e' 404. 👉 Da rifare dal VPS.
3. **`R17_oro_notte.txt`**: 2 assi Y e nessuna riga `# EA:`, quindi il tipo di
   `InpMgmtTF` non e' risolvibile e non so dire se le sue celle vere sono 5 o
   16.363. Il cancello lo scarta comunque (`EA NON TROVATO`). Non e' in coda.
4. **Il comportamento di MT5 sugli enum l'ho verificato sul DRIVER e
   sull'ARCHIVIO**, non lanciando MT5. La prova d'archivio (11 righe su 40+
   CSV) e' forte, ma e' una misura di **un** caso, non di tutti gli enum.
5. **Le 537 righe fra i driver di R123D e r132c** le ho classificate come
   "guardie" leggendo il diff e verificando che 0 toccano le impostazioni del
   tester. Non ho eseguito i due driver in parallelo sullo stesso file prova:
   quello sarebbe il controllo definitivo, e costa una corsa.
6. **I 476 problemi preesistenti** sui 689 file d'archivio: contati e
   verificato che **non cambiano** con la mia toppa, ma **non li ho aperti uno
   per uno**. Sono file d'archivio, nessuno in coda.
7. **Duplicati di classe 5 / 26 / 101**: elencati, **non rinumerati**.
   Rinumerare tocca le citazioni in tutto il repo: e' un lavoro da fare con
   una mano sola, e non l'ho fatto per non incrociarmi con gli altri agenti.

---

# 📌 COSA CHIEDO A TE, CLAUDIO — tre cose, tutte a costo zero

1. 🟢 **`cemad05`**: decidi tu se riaccenderla. Costo vero **14 passate su
   272**. Se resta spenta va bene, ma la ragione giusta e' *"requisito 5 gia'
   chiuso dal 01/08"*, non *"costa 33.000 passate"*.
2. 🔴 **Domattina leggi per prima la riga `rifiutati :`** del
   `REFERTO_RUNNER_*`. Stamattina diceva **4** e non se n'e' accorto nessuno.
3. 🟠 **Le classi 270, 272, 273 e 164** sono citate in giro come se fossero
   scritte, e in checklist non ci sono. Va scritta la 270 almeno: e' la toppa
   che ha cambiato l'impronta del driver oggi.
4. 🔴 **Una regola per i 7 agenti, e la chiedo io**: `git add -A` **vietato**
   sull'albero condiviso, si aggiunge **per nome**. Oggi e' costato un commit
   con dentro il lavoro di due mani (§3.5). Danno zero **per fortuna**.

🔥 **E la bussola, perche' conta piu' del resto**: oggi il ponteggio ha tenuto.
Il cancello vero dice **39 su 39** e **50 su 50**, i magic sono puliti, i pin
sono commit, i due driver sono accoppiati bene. 🎯 **Stanotte partono 27 round
veri su 10 motori.** Non abbiamo perso una notte: ne abbiamo salvata una e
recuperato un round che stava per essere buttato per un numero sbagliato.
**Non ci accontentiamo.** 💪
