# 📬 PREOPEN DAX — il livello **pre-apertura** sul DAX — **LA RIGA DA MANDARE**

---

# 🛑 PRIMA DI LANCIARE: LEGGI I CRITERI. NON È UN CONTA-OPERAZIONI.

> ## ⚠️ QUESTO ROUND HA **CRITERI DI MERITO GIÀ CONGELATI**.
>
> È il **gemello del round PREOPEN DOW** preparato la mattina del 28/08:
> stessa forma, **stessi criteri**, altro mercato e **altra sedia viva**.
> Produce un **VERDETTO** — `PASSA` / `NON PASSA` / `MERITO SOSPESO` — e quel
> verdetto **entra agli atti**.
>
> ### 👉 Prima di incollare qualunque riga, **apri e leggi**
> ### 📄 `backtest_pipeline/prove/PREOPEN_RETEST_DAX_M15.txt`
> ### e in particolare **due sezioni**:
>
> | sezione | perché non si salta |
> |---|---|
> | **`COME PUÒ MORIRE`** | dice **in anticipo** i **cinque** modi in cui questo round può bocciare il candidato — e i **primi due sono NUOVI rispetto al Dow**: **(1)** il metro DAX è **forte** (PF 1,397 OOS agli atti), quindi il criterio «+0,10 di PF» chiede al candidato **~1,50**; **(2)** il **doppione con `ABTG_MaxMinNotte_DAX_Short` è alto e MISURATO**, con la tabella minuto per minuto |
> | **`CRITERI DI ACCETTAZIONE`** | dice **cosa vuol dire PASSA**: una regione di **≥3 celle adiacenti** in OOS con Profit>0, PF≥1,10, n≥30, DD<8%, peggior giornata >−2,0%, **e** che batta il **metro** di almeno **+0,10 di PF**. Più il **PASSO 0** in tre pezzi, che viene **prima di qualunque PF** |
>
> **Se non hai letto quelle due sezioni, non lanciare.**

---

## 🧭 Che cos'è, in una riga

Il nostro **`ABTG_DAX_Apertura_EU`** — la **sedia viva del DAX**, magic `770101`
— ha un interruttore che **non abbiamo mai acceso**: `InpRangeMode=1`, che
costruisce il livello dal **range PRE-apertura** invece che dai primi 35 minuti
dopo. Questo round **lo accende e lo misura**. 🔧 **Zero codice EA scritto:
l'interruttore c'è dal primo giorno** (`ComputeLevels`, righe 978-981, ramo
`ABTG_RANGE_PREV`).

**Misurato dalla caccia del 28/08 con grep su `prove/`:** **tutti e 23** i file
prova DAX pinnano `InpRangeMode` a **0**. Gli unici file al mondo che lo pinnano
a **1** sono i `PREOPEN_*_DOW_M15*` nati stamattina — e sono sul **Dow**.
È un pezzo di macchina **pagato e mai usato**.

| | |
|---|---|
| **EA** | `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` — **la sedia viva**, magic `770101`, **non si tocca** |
| **Driver** | `backtest_pipeline/righe/RIGA_PREOPEN_DAX.ps1` (marcatore `MARCATORE_RIGA_PREOPEN_DAX_v1`) |
| **File prova** | `prove/PREOPEN_RETEST_DAX_M15.txt` (**i criteri**) · `_SHORT.txt` · `PREOPEN_METRO_DAX_M15.txt` · `PREOPEN_METRO_DAX_M15_SHORT.txt` · `PREOPEN_COSTO_DAX_M15.txt` |
| **Origine** | caccia intraday indici del 28/08 (candidato P1 «Tristan's Box») + caccia apertura DAX del 28/08 §5.1 e §6 |
| **Referto di preparazione** | `prove/REFERTO_PREPARAZIONE_PREOPEN_DAX_NAS.md` |
| **Gemelli di famiglia** | 🇺🇸 **Dow** = `RIGA_PREOPEN_DOW.ps1` (girato stamattina) · 🇺🇸 **Nasdaq** = `RIGA_PREOPEN_NAS.ps1` (preparato oggi insieme a questo) |

---

## 🔬 CHE COSA GIRA, IN ORDINE — e l'ordine **non è negoziabile**

| # | fase | che cos'è | passate |
|---|---|---|---|
| **1** | 🚧 **COSTO** (PASSO 0b) | **una passata SINGOLA** sulla cella **centro** della griglia → report `.htm` → **mediana del take LORDO in punti indice**. 🔴 **Se FALLISCE, il round si ferma qui e non viene letto NESSUN Profit Factor** | 1 |
| **2** | 📏 **METRO** (PASSO 0c) | la **cella viva** (`InpRangeMode=0`, cioè `R101_DAX_00_viva`) rifatta **su M15**, sui **due lati**. È il **denominatore** del `+0,10 di PF` | 24 |
| **3** | 🔲 **GRIGLIA** | `InpPrevWindowMin` (60→300) × `InpRetestOffsetPts` (200→600), sui **due lati** | 120 |
| **4** | 🔢 **0a + criteri** | si contano le operazioni (**valvola R59**), poi il codice applica i criteri **cella per cella** e stampa il numero accanto a ognuno | — |

**≈145 passate a tick reali.** ⏱️ **[STIMA, non una previsione]: 50-120 minuti**
più la compilazione.
⚠️ Il DAX opera **molto più del Dow** (metro n OOS **270** contro 130): le
passate sono le stesse, ma ognuna ha più trade da simulare. Se dura più della
stima, **non è un guasto**.

---

## ✍️ [LE INTERPRETAZIONI] — le decisioni prese, da approvare

Le **prime tre sono IDENTICHE al round Dow** e le hai già viste stamattina; le
riporto in forma breve. **La quarta è nuova ed è specifica del DAX.**

### 1️⃣ Il cancello del costo ha **TRE stati**, non due

| take **lordo** mediano | stato | cosa fa il round |
|---|---|---|
| **> 7,0** punti indice (>3,5× lo spread) | ✅ **SUPERATO** | prosegue |
| **5,0 – 7,0** (2,5×–3,5×) | 🟡 **SOSPESO** | **prosegue**, ma ogni numero esce col cappello *«il costo non è dimostrato sopra la soglia»* |
| **< 5,0** (<2,5×) | 🔴 **FALLITO** | 🛑 **si ferma**, e nessuna griglia viene letta |

> 🔴 Nella banda **5,0–6,0** il criterio **FIRMATO** direbbe *«il round si ferma
> qui»* e il driver **PROSEGUE** (col cappello). È **l'unico punto** in cui
> l'interpretazione **allarga** un cancello congelato. Motivo: lo spread **non è
> misurato**, è **dichiarato** 2,0 punti indice, e dare un verdetto secco su un
> numero dentro l'incertezza del suo metro è il modo più elegante di sbagliare
> (R109, tre stati).

### 2️⃣ Con le **parziali accese**, «il take» non è un numero solo

- **take per GAMBA** = `|prezzo_out − prezzo_in|` di **ogni** uscita in
  guadagno → **la più CONSERVATIVA** → **è questa che fa il verdetto**;
- **take per POSIZIONE** = media **pesata sui volumi** → **informativa**, e il
  referto **la stampa accanto**, sempre.

### 3️⃣ Il criterio cerca la regione **dentro l'OOS**: è uno **SCREENING**

Il codice **applica il criterio firmato così com'è**, **e in più** stampa la
lettura onesta: *«la cella che l'IS avrebbe scelto, e come si è comportata in
OOS»*. Le due righe stanno una sotto l'altra nel referto.

### 4️⃣ 🆕 **SUL DAX IL PAVIMENTO SL RESTA A ZERO** — ed è la scelta più discutibile del giro

Il Dow gira con `InpMinStopPts=500` e `InpSkipIfTight=0` (lezione R109: senza
pavimento il lotto sbatte sui limiti di volume e **i DD sottostimano il
rischio**). **La sedia viva del DAX ha `0` e `1`**, e il suo contratto (DD
**6,25%** R16 / **7,23%** R46) è stato misurato **così**.

👉 **Ho tenuto i valori della sedia viva DAX.** Il motivo è la regola di casa
«una variabile alla volta»: mettere qui il pavimento del Dow cambierebbe **due
cose insieme** (il livello **e** lo stop) e renderebbe **illeggibile** il
confronto col metro. Il driver **lo impone con un gate** — un file prova con
`InpMinStopPts=500` **non parte**.

> ⚠️ **Il rischio che resta, dichiarato:** sui **bordi larghi** della griglia lo
> stop può diventare stretto e il lotto sbattere sul pavimento `VOLUME_MIN` o
> sul soffitto `VOLUME_MAX`; in quel caso **i DD di questo round sottostimano il
> rischio vero**. È un **`[DA VERIFICARE]`**, non un risultato: il referto
> stampa **min/max/valori distinti dei volumi** della cella del cancello proprio
> per farlo vedere. E con `InpSkipIfTight=1` una cella può anche **saltare** il
> trade invece di entrare stretta: **un n basso può venire da lì**.
>
> **Se preferisci il pavimento anche sul DAX, dimmelo: si cambia in cinque file
> e in un gate — ma allora il metro va rifatto con lo stesso pavimento**,
> altrimenti il confronto non vale.

---

## 🚨 IL DOPPIONE — la cosa che rende questo round diverso dal Dow

`ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (**SEDIA VIVA**, magic `770411`)
**gioca già il range pre-apertura del DAX**. Letto nel sorgente il 28/08:

| cosa | valore (ORA SERVER) | righe del `.mq5` |
|---|---|---|
| box notturno | **23:00 → 04:59** | 71-74 |
| ordini **STOP** posati | **07:59** | 79-80 |
| cutoff ingressi | **08:30** («solo la rottura *fresca*») | 81-82 |
| flat | 17:30 | 83-84 |
| lato | 🔴 **SHORT ONLY** | 91-92 |

Il nostro candidato arma alle **08:00** sul max/min di
`[08:00 − InpPrevWindowMin, 08:00)`. **Quanto si sovrappongono si calcola**, e
il referto stampa questa tabella (verificata eseguendo il driver):

| `prevWin` | finestra del livello | minuti dentro il box 23:00-04:59 |
|---:|---|---:|
| 60 | 07:00 – 08:00 | **0** |
| 120 | 06:00 – 08:00 | **0** |
| 180 | 05:00 – 08:00 | **0** _(confina, di un minuto)_ |
| 240 | 04:00 – 08:00 | **60** (16,7% del box) |
| 300 | 03:00 – 08:00 | **120** (33,3% del box) |

**Tre conseguenze da leggere PRIMA dei numeri:**

1. le **due celle larghe** (240 e 300) costruiscono il livello **dentro il box
   della sedia viva**. Se vincono **loro**, il sospetto di doppione è
   **strutturale** e non si liquida coi PF;
2. 🎯 **il rischio è ASIMMETRICO**: la `770411` è **SHORT ONLY**, quindi sul
   **lato LONG** di questo round un doppione **di lato NON PUÒ esistere**; sul
   **lato SHORT** è il caso peggiore possibile — stesso simbolo, stesso lato,
   stessa mezz'ora, livello dalla stessa finestra;
3. i **grilletti** restano diversi (`770411` entra a **rottura** con ordini
   STOP, noi a **retest** con ordini LIMIT). Diverso il prezzo di riempimento,
   **non necessariamente diverse le GIORNATE** — e per il drawdown della prop
   **contano le giornate**, perché **il DD è UNO** (ROTTA_PROP regola 1).

> 🔴 **QUESTO ROUND NON MISURA LA SOVRAPPOSIZIONE.** La tabella qui sopra è di
> **calendario**, non di trade in comune. La misura vera è il **passo successivo
> dichiarato**, ed è scritta nel referto del round: due passate singole (cella
> promossa + cella viva `770411`, **magic vergini entrambe**), i due export
> per-trade `abtg_trades_<EA>_D30EUR_<magic>.csv` in `Common\Files`, e il conto
> delle **giornate in comune**.
> ⚠️ **Nota di onestà**: `sovrapposizione_sedie.py` **non serve** a questo —
> legge gli statement del **forward**, non i per-trade di un backtest. Quel
> pezzo di codice **va scritto**.

---

## 📉 IL LATO SHORT — qui la domanda è un'altra rispetto al Dow

Sul **Dow** il gemello short partiva svantaggiato **per meccanismo** (filtro EMA
H4 acceso → lo short quasi non entra) e un `n` basso era **atteso**.

**Sul DAX no**, ed è misurato:

- il filtro EMA su questa sedia è **SPENTO** → il lato short **entra davvero**;
- **R107** (25/08, tick reali, **stessa finestra e stesso split**, su M5) ha già
  misurato il lato short con la geometria viva:

| | IS | OOS |
|---|---|---|
| **DAX short (R107)** | −996 · PF **0,965** · n 138 | −1.865 · PF **0,957** · DD 12,31% · **n 257** |

Con **n 257** l'Emendamento A rende il **MERITO misurabile**, e il verdetto agli
atti è: **«NIENTE EDGE, e stavolta è misurato»** — rosso **anche nell'IS**, che
contiene la discesa febbraio-aprile 2025.

👉 **La domanda del gemello short di questo round non è «c'è edge?»** (risposta
già data: no). È: **«cambiare il LIVELLO resuscita un lato già bocciato con
campione pieno?»**. L'onere della prova è **più alto**, non più basso.

📐 **E cambia quale cancello morde:**

| lato | metro agli atti | cosa chiede il «+0,10» | cancello che MORDE |
|---|---|---|---|
| **LONG** | PF **1,397** | ~**1,50** | il **+0,10** (il PF≥1,10 è quasi decorativo) |
| **SHORT** | PF **0,957** | ~1,06 → **sotto il pavimento** | il **PF ≥ 1,10 ASSOLUTO** |

Vanno superati **tutti e due**, sempre.

---

## 🔐 I MAGIC — tutti **vergini**, le due sedie vive **vietate**

| file | magic gemelli |
|---|---|
| griglia **LONG** | `781600` / `781601` |
| griglia **SHORT** | `781700` / `781701` |
| metro **LONG** | `781800` / `781801` |
| metro **SHORT** | `781900` / `781901` |
| **cancello del costo** | `782000` / `782001` |

Tutti **verificati con grep su tutto il repo il 28/08** (`.git` escluso): i
blocchi `7816xx`-`7820xx` erano a **zero occorrenze**, e adesso compaiono
**solo** negli artefatti di questo round.
_(I blocchi `7735xx`-`7739xx` del round Dow **non si riusano**: sono bruciati.)_

🔴 **Nella lista dei VIETATI ci sono DUE sedie vive, non una:**
- **`770101`** — il magic **vivo** di questa sedia;
- **`770411`** — `ABTG_MaxMinNotte_DAX_Short_Ottimizzato`, **l'altra sedia viva
  sul DAX**, quella del sospetto doppione: non deve **nemmeno poter girare per
  sbaglio** dentro questo round.

Se uno dei due comparisse in un file prova, il driver **si ferma prima di aprire
MT5** — 🧪 **verificato facendolo scattare** (vedi il referto di preparazione).

🔴 **Il cancello ha un magic TUTTO SUO** e non è un vezzo: l'export per-trade
dell'EA porta il **magic nel nome del file**, quindi una griglia che
condividesse il magic **cancellerebbe la prova del gate** (CHECKLIST 41).

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- 🧩 **La riga installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` prima di
  compilare: `walkforward_generico.ps1` **non lo fa**, e senza quel file l'EA
  non compila.
- 🔨 **Il giro a vuoto COMPILA DAVVERO**, e cancella l'`.ex5` prima. Sì, l'EA è
  già vivo in produzione e un `.ex5` c'è quasi sicuramente — **è proprio per
  questo**: un `.ex5` **vecchio** sotto un `.mq5` **nuovo** non è un no-op, è un
  binario che **opera mentendo sulla versione** (CHECKLIST 54).
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic vergini, `AllowLiveTrading=false`
  in **tutti** gli `.ini` (compreso quello della passata singola, che scrive
  questa riga: aprire MT5 *per misurare* riarmerebbe la flotta — CHECKLIST 51).
- **Banco:** `Model=4` (**tick reali**), finestra **2024.09.26 → 2026.06.30**,
  split 40/60 (**IS** fino al `2025.06.09`, **OOS** dal `2025.06.10` — le stesse
  di R101 e R107), deposito **100.000**, rischio **1%** (pinnato nei file prova;
  il default compilato del `.mq5` è **2.0%** e il referto lo dichiara),
  `Spread=0` **scritto nell'ini** (= spread corrente, **dichiarato**).
- 📐 **Il DD si legge ×0,65** per portarlo alla taglia prop 100k (in campo il
  rischio è 0,65%). Il referto stampa **tutti e due** i numeri.
- 🔧 Se non è già stato fatto: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**.

---

## 📌 IL PIN — **@@PIN@@**

```
@@PIN@@
```

> 🔴 **IL PIN QUI SOPRA È UN SEGNAPOSTO E NON FUNZIONA.** Va sostituito col
> commit vero **dopo il push**, e finché è così **LA RIGA NON PARTE** (il driver
> pretende 40 caratteri esadecimali).
> ⚠️ **E questo riquadro è un PUNTO D'USO, non prosa** (CHECKLIST 101): va
> **tolto o riscritto al passato** nello stesso passo in cui il pin diventa
> vero, altrimenti la pagina dirà *«non funziona»* puntando a un pin che
> funziona — e il cartello si consuma.

⚠️ **Il pin si rilegge DOPO il push, non prima.** Il commit da pinnare deve
contenere **tutti e otto** gli artefatti che lo script scarica:
`walkforward_generico.ps1`, `RIGA_PREOPEN_DAX.ps1`, i **cinque** file prova,
`ABTG_PausaGuardian.mqh` e **`ABTG_DAX_Apertura_EU.mq5`**.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato. Il driver **pinna anche `$EABranch` dentro
`walkforward_generico.ps1`**, altrimenti il pin varrebbe per il driver e **non
per l'EA misurato**.

### ♻️ LA RICETTA DI **RI-PINNATURA** — se un artefatto viene corretto

```bash
F=backtest_pipeline/righe/RIGA_PREOPEN_DAX_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9A-Za-z]{40}'" "$F" | head -1 | grep -oE "[0-9A-Za-z]{40}")
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 3
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
grep -ci "segnaposto\|non funziona\|la riga non parte" "$F"   # DEVE dare 0
```

⚠️ **Servono TUTTI E TRE i conteggi.** I primi due sono il punto 77: il solo
*«0 pin vecchi rimasti»* lo supera a mani basse anche un `sed` che **non ha
matchato niente**. Il terzo è il punto 101: è il cartello del segnaposto che
sopravvive alla pinnatura.

⚠️ **E il perimetro della ricetta è QUESTO FILE E BASTA**, perché la riga di
lancio **esiste in un posto solo** (CHECKLIST 100). Prima di dichiarare fatto un
ri-pin:

```bash
grep -rn "RIGA_PREOPEN_DAX.ps1" --include=*.md .   # nessun altro .md deve portare un blocco incollabile
```

---

## 1️⃣ PRIMA il giro a vuoto (**nessuna passata di misura; APRE MetaEditor per compilare, non MT5**)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_PREOPEN_DAX.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_DAX.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_DAX_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine (righe verificate eseguendo il driver su un banco
stubbato il 28/08):

- `pin ......... <40 caratteri>` · `fasi ........ COSTO -> METRO -> GRIGLIA (tutte)`;
- `IS ....... 2024.09.26 - 2025.06.09` e `OOS ...... 2025.06.10 - 2026.06.30`
  — **le stesse di R101/R107**: se fossero diverse, il metro non sarebbe
  confrontabile e il driver lo scrive nei RILIEVI;
- `file prova scaricati: 5`;
- `sorgente EA al pin: <n> righe, InpRiskPercent di default 2.0%`
  — **2.0 è il default del `.mq5`**, i file prova lo pinnano a **1.0**: il
  referto lo scrive così apposta;
- `assi letti nel file prova: InpPrevWindowMin 5 valori, InpRetestOffsetPts 3
  valori -> 15 celle x 2 gemelli = 30 passate per finestra e per lato`
  — **contati sul file prova, non a memoria**;
- `geometria, lati, RangeMode, baseline, stella, magic e assi: TUTTI PASSATI
  (cella del cancello: PrevWindowMin=180, RetestOffsetPts=400, magic 782000)`;
- 🆕 `apertura confermata sul file prova: 08:00 server  (box della sedia gemella
  770411: 23:00 - 04:59)` — è il gate che impedisce alla tabella del doppione di
  descrivere **un'apertura che il round non usa**;
- `terminale scelto: ...` → deve contenere **`BCM Markets MT5 Terminal`** e
  **non** contenere `-V3`. È **lo stesso selettore, riga per riga**, di
  `walkforward_generico.ps1`;
- `include: INSTALLATO e VERIFICATO in ...`;
- **`compilato ABTG_DAX_Apertura_EU: OK (<n> KB, <ora>)`**;
- `ini della passata singola scritto e verificato: ...`;
- `NON ESEGUITO (giro a vuoto: l'ini c'e' ed e' passato tutti i gate, MT5 non
  e' stato aperto)`;
- quattro blocchi `=== 5. <lavoro> ===` con `celle attese per finestra:` **6, 6,
  30, 30**, e in fondo `ESITO: CONTROLLO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare:** `-SoloControllo` **non apre
> MT5**. Non esiste nessun `n`, nessun PF, nessun DD, **nessun controllo sui
> gemelli**, e **il cancello del costo non è stato eseguito**. Conferma gli
> **artefatti**, mai i numeri.

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_PREOPEN_DAX.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_DAX.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_DAX_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo**. Tre righe staccate
sarebbero tre comandi indipendenti, e un `throw` alla prima non fermerebbe le
altre.

### 🔁 Se serve riprendere una fase sola

> ⚠️ **Ogni ripresa è un BLOCCO INTERO, col suo `irm`.** `$p` e `$pin` nascono
> **dentro** il `& { ... }`, che è uno scope figlio: quando quel blocco finisce
> **non esistono più**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_PREOPEN_DAX.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PREOPEN_DAX.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PREOPEN_DAX_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloFase 'GRIGLIA' -Rifai;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - normale su una ripresa: lo zip esiste, mandalo' -ForegroundColor Yellow } }
```

Fasi valide: **`COSTO`** · **`METRO`** · **`GRIGLIA`**.

> 🔴 **UNA RIPRESA NON DÀ MAI UN VERDETTO DEFINITIVO, ed è voluto.** I CSV
> delle fasi non rilanciate vengono **letti da disco** e **marcati
> `DA DISCO <data>`**: il pin con cui furono prodotti non è agli atti di quel
> referto. In quel caso il referto stampa in chiaro *«NESSUNO DEI VERDETTI QUI
> SOPRA È DEFINITIVO»* e **l'uscita è 1 anche se è andato tutto bene**.

---

## 🔢 IL CODICE D'USCITA HA UN SIGNIFICATO SOLO

| codice | vuol dire |
|---|---|
| **0** | un round **COMPLETO**, in **UN LANCIO SOLO**, **senza problemi** |
| **1** | **tutto il resto**: fermato, problemi, riprese, `-SoloFase`, dati da disco |

Un `trap` garantisce **1** su qualunque uscita anomala (difetto misurato sul
round Dow: prima di quella rete un errore fuori dai `try` usciva con **0**,
cioè una corsa esplosa che si presenta come riuscita).

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul **Desktop**: `PREOPEN_DAX_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_PREOPEN_DAX.txt`** ← **è questo che conta**;
- i **cinque file prova** (così il referto porta con sé i criteri con cui è stato giudicato);
- gli **8 CSV** `ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_{metro_long,metro_short,griglia_long,griglia_short}.csv`;
- **`gen_preopen_costo.ini`** e **`REPORT_COSTO.htm`** (la prova del cancello);
- `COMPILAZIONE_FALLITA.log`, **se** la compilazione fallisce.

### 📅 Le due righe da guardare per prime nel referto

1. **`modo:`** — dice `CORSA` (il risultato) o `CONTROLLO` (giro a vuoto:
   **non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**.

E se in cima trovi il riquadro **`QUESTA CORSA È STATA FERMATA. IL REFERTO È
MONCO.`**, tutto quello che segue è **quello che era stato misurato fino a quel
punto**: non è un verdetto.

---

## 🚩 COME SI LEGGE IL REFERTO — cinque avvertenze, non cinque note

1. 🚧 **Il cancello del costo viene PRIMA.** Se dice `FALLITO`, nel referto
   **non c'è nessuna griglia**, ed è giusto così: *un motore che non copre il
   proprio costo non ha bisogno di una griglia per essere bocciato*.
2. 📏 **Il metro su M15 potrebbe non riprodurre i numeri di R101** (che sono su
   **M5**: IS +3.789 · PF 1,126 · n 175 | OOS **+18.030** · PF **1,397** · DD
   7,23% · n **270**). **Non è un gate ed è un'attesa dichiarata.** In tutti e
   due i casi **il metro del round è il numero misurato ADESSO su M15**.
   👉 E attenzione alla colonna: il valore **vivo** dell'offset sul DAX è
   **200** (sul Dow è 400), quindi è la **colonna 200** che riproduce la sedia.
3. ⏱️ **Il confronto col metro porta un confondimento di 35 MINUTI**: il
   candidato arma alle **08:00** server, il metro alle **08:35** — finestra
   **9h30 contro 8h55**, **+6,5%**. 👉 **È molto meno grave che sul Dow**
   (là erano +24%, perché la finestra è di 3 ore invece di 9 e mezza), ma non è
   nullo, e il referto lo stampa accanto a ogni verdetto `PASSA`.
4. 🎚️ **Guarda la riga dei VOLUMI del cancello.** Se i valori distinti sono
   **1** e il volume è il minimo del broker, il lotto è andato a sbattere sul
   **pavimento `VOLUME_MIN`**: in quel caso **il rischio vero per operazione è
   più alto dell'1% dichiarato e i DD del round sottostimano**. Sui **bordi
   larghi** della griglia questo **NON è misurato**: è un `[DA VERIFICARE]`
   dichiarato. 👉 **Sul DAX pesa più che sul Dow**, perché qui il pavimento SL
   è **spento** (vedi l'interpretazione n. 4).
5. 🚨 **Guarda quali celle vincono.** Se la regione promossa cade su
   `prevWin 240` o `300`, sei **dentro il box della sedia viva `770411`**: il
   sospetto di doppione diventa strutturale e la misura della sovrapposizione
   **viene prima** di qualunque promozione.

---

## 🚫 QUELLO CHE QUESTO ROUND **NON** DICE

- ❌ **Un round che PASSA produce una CELLA CANDIDATA, non una sedia.** La
  promozione in forward è **un'altra decisione, con un'altra firma**.
- ❌ **Il doppione con `ABTG_MaxMinNotte_DAX_Short` NON è misurato qui.** La
  tabella è di **calendario**; le **giornate in comune** sono il passo
  successivo dichiarato.
- ❌ **Il lato short non riparte da zero**: R107 lo ha già bocciato con n 257.
  Questo round chiede solo se **il livello diverso** cambia quella risposta.
- ❌ **Lo spread non è misurato**: è **dichiarato** 2,0 punti indice. Ogni
  verdetto del cancello esce con l'etichetta `[SPREAD NON MISURATO]`.
- ❌ **Il pavimento SL resta spento** (scelta 4): i DD di questo round possono
  sottostimare il rischio sui bordi larghi. `[DA VERIFICARE]`.
- ❌ **Un backtest profittevole non è un profitto live.** Broker singolo, costi
  di un feed solo, **un solo regime** (21 mesi rialzisti).
