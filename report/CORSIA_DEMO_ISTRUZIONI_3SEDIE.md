# 🧭 CORSIA DEMO — ISTRUZIONI PER CLAUDIO (le 3 sedie del 07/09)

_Scritto il **07/09/2026**. Copre i tre candidati assegnati:
**NY SESSION RETEST**, **DAX REENTRY**, **SUPERWAVE DAX H4**._
_(Il quarto, **RELATIVO NASUSD**, è in carico a un altro agente e **non è in
questo foglio**: `report/CORSIA_DEMO_RELATIVO_NASUSD.md`.)_

---

## 🚦 IL RIASSUNTO, PRIMA DI TOCCARE QUALSIASI COSA

| # | sedia | verdetto | perché, in una riga | cosa fai oggi |
|---:|---|---|---|---|
| 1 | **NY SESSION RETEST** slope 75 · U30USD M15 | 🟢 **ACCENDERE** | traguardo **~20/03/2027**, DD promesso **4,7%**, rischio aperto max 1,30% | **i passi 0-8 qui sotto** |
| 2 | **DAX REENTRY LONG** break 40 · D30EUR M5 | 🔴 **NON ACCENDERE** | n=150 arriva nel **2029-2031**: la regola della corsia dice che lì il forward non è lo strumento | **niente.** Vedi §FINE |
| 3 | **SUPERWAVE DAX H4** · D30EUR H4 | 🔴 **NON ACCENDERE** | n=150 nel **2029-2033**, + finestra della misura **non ricostruibile** | **niente.** Vedi §FINE |

📄 Le schede complete, coi conti riga per riga:
`report/CORSIA_DEMO_NYRETEST.md` · `report/CORSIA_DEMO_DAXREENTRY.md` ·
`report/CORSIA_DEMO_SUPERWAVE_DAX_H4.md`

> ⚠️ **Io non ho compilato niente e non ho lanciato niente**: in questo ambiente
> **non c'è MetaEditor e non c'è MT5**. La compilazione e l'attacco sono **tuoi**,
> e sono i passi 3 e 6.

---

# 🖥️ PASSO 0 — SAPERE SU QUALE TERMINALE SEI (obbligatorio, non saltabile)

**Conto di destinazione: DEMO PICCOLO `50503392`.**
**Cartella programma: `C:\Program Files\BCM Markets MT5 Terminal`** (**SENZA**
`-V3`).

🔴 **NON è il conto REALE `10105439`** (cartella `C:\BCM_Reale`).
🔴 **NON è il 100k `50504263`** (cartella `...BCM Markets MT5 Terminal -V3`).

**Non riconoscere la finestra a occhio.** Apri PowerShell e incolla questa riga
di **sola lettura** (non scrive, non tocca niente):

```
Get-Process terminal64 -ErrorAction SilentlyContinue | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```

### ✅ VERIFICA PRIMA DI ANDARE AVANTI
Nell'elenco stampato devi **vedere e riconoscere per PATH** la riga il cui
`Path` è **esattamente**
`C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe`.
**È quella la finestra su cui lavorerai per tutti i passi seguenti.** Segnati il
suo **Id (PID)**.
❌ Se quella riga non c'è, il terminale del piccolo è chiuso: aprilo e rifai il
passo 0. ❌ Se ce n'è più di una con quel path, fermati e dimmelo.

---

# 📥 PASSO 1 — SCARICARE SORGENTE E PRESET DAL BRANCH `lavoro`

Sempre con l'`irm` davanti, sempre dal branch `lavoro`: **una copia vecchia sul
disco è il difetto n.1 già pagato** (regola di casa del 10/08).

```
$Base = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro"
$Dl   = "$env:USERPROFILE\Desktop\CORSIA_DEMO_NYRETEST"
New-Item -ItemType Directory -Force -Path $Dl | Out-Null
irm "$Base/mql5/Experts/ABTG_NySessionRetest.mq5"                 -OutFile "$Dl\ABTG_NySessionRetest.mq5"
irm "$Base/mql5/Presets/ABTG_NySessionRetest_U30USD_DEMO.set"     -OutFile "$Dl\ABTG_NySessionRetest_U30USD_DEMO.set"
Get-ChildItem $Dl | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
```

### ✅ VERIFICA
Devono comparire **due file**, entrambi con `LastWriteTime` di **oggi**:
`ABTG_NySessionRetest.mq5` (~decine di KB) e
`ABTG_NySessionRetest_U30USD_DEMO.set` (pochi KB).
❌ Se uno dei due manca o è di 0 byte → il download è fallito, **non proseguire**.

---

# 📂 PASSO 2 — TROVARE LA CARTELLA DATI **DEL PICCOLO** (non un'altra)

La cartella dati non è quella del programma: si riconosce da `origin.txt`.

```
$Inst = "C:\Program Files\BCM Markets MT5 Terminal"
$Data = Get-ChildItem "$env:APPDATA\MetaQuotes\Terminal" -Directory |
        Where-Object { $o = Join-Path $_.FullName "origin.txt"
                       (Test-Path $o) -and ((Get-Content $o -Raw).Trim() -ieq $Inst) } |
        Select-Object -First 1 -ExpandProperty FullName
"CARTELLA DATI DEL PICCOLO 50503392 = $Data"
```

### ✅ VERIFICA
La riga stampata deve finire con un GUID e **non** deve essere vuota.
❌ Se stampa `= ` e basta, hai il terminale sbagliato o chiuso: torna al passo 0.

Poi copia il sorgente dentro:

```
Copy-Item "$Dl\ABTG_NySessionRetest.mq5"                  -Destination "$Data\MQL5\Experts\"       -Force
Copy-Item "$Dl\ABTG_NySessionRetest_U30USD_DEMO.set"      -Destination "$Data\MQL5\Presets\"       -Force
Get-ChildItem "$Data\MQL5\Experts\ABTG_NySessionRetest.mq5","$Data\MQL5\Presets\ABTG_NySessionRetest_U30USD_DEMO.set" | Select-Object FullName, Length, LastWriteTime
```

### ✅ VERIFICA
Entrambi i file elencati, con la data di oggi.

---

# 🔨 PASSO 3 — COMPILARE (questo lo fai tu: io non ho MetaEditor)

1. Nel terminale del **piccolo 50503392** premi **F4** (apre MetaEditor su
   **quella** cartella dati — è il modo per non sbagliare istanza).
2. Nel Navigatore di MetaEditor apri `Experts\ABTG_NySessionRetest.mq5`.
3. **F7** (Compila).

### ✅ VERIFICA
Nella scheda **Errori** di MetaEditor: **`0 errors, 0 warnings`** (o solo
warning). E il file `.ex5` deve esistere:

```
Get-Item "$Data\MQL5\Experts\ABTG_NySessionRetest.ex5" | Select-Object Length, LastWriteTime
```

Deve essere **~68 KB** e con l'ora di **adesso** (il referto del 31/08 registra
"compile 68KB": se esce un numero molto diverso, dimmelo prima di andare avanti).
❌ Con errori di compilazione **ci si ferma qui**.

---

# 📈 PASSO 4 — APRIRE IL GRAFICO GIUSTO

Sul terminale del **piccolo 50503392** (`C:\Program Files\BCM Markets MT5 Terminal`):

- **Simbolo: `U30USD`**
- **Timeframe: `M15`**

🔴 **M15, non H1.** Su H1 questo motore fa **ZERO trade per costruzione** (misurato
il 31/08: la seduta contiene 6 barre H1, la pendenza a 5 barre lascia una sola
barra utile che chiude **dopo** il flat). Se il grafico è H1, l'EA sta acceso e
non farà mai niente.

### ✅ VERIFICA
In alto a sinistra sul grafico deve leggersi **`U30USD,M15`**.

---

# 🧷 PASSO 5 — ATTACCARE L'EA E CARICARE IL PRESET

1. Navigatore → **Expert Advisors** → `ABTG_NySessionRetest` → **trascina sul
   grafico `U30USD,M15`**.
2. Nella finestra che si apre, scheda **Comune**: spunta **"Consenti trading
   algoritmico"**.
3. Scheda **Parametri di input** → pulsante **`Carica`** in basso →
   scegli **`ABTG_NySessionRetest_U30USD_DEMO.set`**.
4. **NON premere ancora OK.** Prima la verifica qui sotto.

### ✅ VERIFICA A OCCHIO, MA SU NUMERI (4 righe, tutte e quattro)
Nella lista dei parametri devi leggere **esattamente**:

| parametro | valore che DEVE esserci |
|---|---|
| `InpVwapSlopeMin` | **75.0** |
| `InpSlLookback` | **5** |
| `InpMagic` | **769510** |
| `InpRiskPercent` | **0.65** |

E questi due, che sono la trappola del fuso (**ORA SERVER = ora italiana −1**):

| parametro | DEVE essere | ❌ MAI |
|---|---|---|
| `InpSessionHour` | **14** | 9 (è l'ora di New York) |
| `InpCloseHour` | **20** | 16 (è l'ora di New York) |

❌ Se anche **una sola** di queste sei righe è diversa, il preset non è entrato:
**Annulla**, rifai il passo 1 e il passo 5.

5. **OK.**

---

# 🔍 PASSO 6 — LA RIGA NEL LOG CHE DICE CHE SI È ARMATA DAVVERO

Apri la scheda **Strumenti → Esperti** (in basso). **Subito dopo l'attacco**
l'EA stampa in `OnInit` le sue righe di autotest. Cerca queste **due**:

**(a) la carta d'identità — è la prova STAMPATA che il preset è entrato:**

```
[NYRT][AUTOTEST] EMA 200 | regime slope>=75.00 exp>=0.00 | U30USD | magic 769510
```

🔎 In questa riga sola ci sono **tre fatti**: la soglia **75.00**, il simbolo
**U30USD**, il magic **769510**. Non è un'inferenza tua: è l'EA che ti dice cosa
ha letto. **Se il numero è diverso da 75.00, o il magic non è 769510, il preset
NON è entrato.**

**(b) l'esito del motore:**

```
[NYRT][AUTOTEST] esito motore: SEI BLOCCHI SU SEI, il motore ragiona come il sorgente.
```

### ✅ VERIFICA
Tutte e due le righe presenti, con i valori sopra.
❌ Se la (b) dice **`DIVERGE: non usare i risultati`** → **stacca subito l'EA** e
dimmelo: è il codice che non torna, non il mercato.

⏰ **Nota sulle ore**: le schede **Esperti e Giornale sono in ORA LOCALE del PC**
(italiana), il **grafico è in ORA SERVER** (un'ora indietro). Non è un ritardo
dell'EA: è che stai leggendo due orologi diversi (regola di casa del 06/08).

### ✅ VERIFICA FINALE DELLO STATO
In alto a destra sul grafico deve esserci la **faccina sorridente** 🙂 accanto al
nome dell'EA, e il pulsante **Trading algoritmico** della toolbar deve essere
**verde**.

---

# 📏 PASSO 7 — LA MISURA DEL LOTTO MINIMO (5 minuti, ma è un cancello vero)

🔴 **Perché**: l'EA porta il lotto **SU al minimo del broker** se il rischio non
ci arriva (riga 945 del sorgente, `MathMax(mn, ...)`). Su un conto piccolo questo
farebbe operare l'EA **a un rischio più alto dello 0,65%**, e il cancello di
rischio della scheda (DD 4,7%) misurerebbe un'altra cosa.

1. Market Watch → tasto destro su **`U30USD`** → **Specifica**. Annota:
   **Volume minimo**, **Dimensione contratto**, **Valore tick**, **Dimensione tick**.
2. Leggi il **saldo del conto 50503392** (scheda Trading).
3. Mandami questi cinque numeri.

Il conto che farò io: la perdita mediana MISURATA di questo motore è
**−58,0 punti indice**. Se **58 punti indice al lotto minimo** costano più dello
**0,65% del saldo**, la sedia **non va accesa così** e va rivista la taglia.

### ✅ VERIFICA
Hai i cinque numeri annotati. **La sedia può restare attaccata nel frattempo**
(farà al massimo 1 operazione ogni 4 giorni), ma **se il conto è troppo piccolo
la stacchiamo prima della prima chiusura.**

---

# 💾 PASSO 8 — LA RACCOLTA (regola di casa: i risultati arrivano SEMPRE sul Desktop)

```
$Out = "$env:USERPROFILE\Desktop\CORSIA_DEMO_NYRETEST_ARMATA"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
Copy-Item "$Data\MQL5\Presets\ABTG_NySessionRetest_U30USD_DEMO.set" -Destination $Out -Force
Get-ChildItem "$Data\MQL5\Logs" | Sort-Object LastWriteTime -Desc | Select-Object -First 1 | Copy-Item -Destination "$Out\log_terminale.txt" -Force
Get-Content "$Out\log_terminale.txt" | Select-String "NYRT" | Set-Content "$Out\righe_NYRT.txt"
"conto=50503392  path=C:\Program Files\BCM Markets MT5 Terminal  simbolo=U30USD  tf=M15  magic=769510" | Set-Content "$Out\identita.txt"
Compress-Archive -Path "$Out\*" -DestinationPath "$env:USERPROFILE\Desktop\CORSIA_DEMO_NYRETEST_ARMATA.zip" -Force
Get-ChildItem $Out | Select-Object Name, Length | Format-Table -AutoSize
```

### ✅ VERIFICA — nella console devi contare **QUATTRO** file
`ABTG_NySessionRetest_U30USD_DEMO.set` · `log_terminale.txt` ·
`righe_NYRT.txt` (**deve contenere le due righe `[NYRT][AUTOTEST]` del passo 6**)
· `identita.txt`.
E sul Desktop lo **zip** `CORSIA_DEMO_NYRETEST_ARMATA.zip` pronto da mandarmi.

❌ Se `righe_NYRT.txt` è **vuoto**, l'EA non ha stampato: non è armato. Torna al
passo 5.

---

# ⛔ SEDIE 2 e 3 — **OGGI NON SI TOCCA NIENTE**

## 2️⃣ DAX REENTRY LONG break 40 — NON ACCENDERE
**Non c'è nessun passo da fare, e non ho scritto il preset apposta.**
Motivo, in numeri: **2,70 operazioni/mese misurate** → n=150 arriva nel
**luglio 2029** (contando anche le 57 già in backtest) o nell'**aprile 2031**
(contando solo la demo). Il tetto della corsia è **~18 mesi**.
🔴 E se un giorno si accende: **SOLO LONG**. Lo short è misurato e morto
(PF 0,38–0,54, DD 8,8–23%).
👉 **La mia proposta al posto del deploy** (costa una riga di lancio, non anni):
provare lo **stesso meccanismo su un secondo indice** (U30USD / NASUSD), passo 0
con criteri congelati. Se regge, la **famiglia** diventa accendibile e il
traguardo si dimezza da solo. Dettagli: `report/CORSIA_DEMO_DAXREENTRY.md`.

## 3️⃣ SUPERWAVE DAX H4 — NON ACCENDERE
**Non c'è nessun passo da fare, e non ho scritto il preset apposta.**
Motivo, in numeri: **1,87–2,65 op/mese** → n=150 fra il **2029 e il 2033**.
E in più la **finestra della misura non è ricostruibile** (il `.ini` chiede
`2024.01.01`, ma i tick BCM sugli indici partono dal **2024.09.26**).
🔓 **La rilettura del 07/09 l'ho fatta e l'ostacolo "frequenza della sedia
singola" CADE davvero** (la famiglia SuperWave ha due sedie in campo): il "no" di
oggi poggia su un criterio **diverso**, il traguardo.
👉 **Al posto del deploy, tre misure da banco** che possono riaprire tutto e
costano **una corsa**: smontare i due lati, ridichiarare la finestra a
`2024.09.26`, e riprodurre la cella con il file `_Ottimizzato` (la validazione
girò l'EA **base**, con magic 770501). Dettagli:
`report/CORSIA_DEMO_SUPERWAVE_DAX_H4.md`.

---

# 📌 L'ULTIMA COSA, PRIMA CHE LA SEDIA 1 APRA LA PRIMA POSIZIONE

Scrivere in `report/CENSIMENTO_CONTRATTI.md` §4d la riga della sedia nuova:

> `ABTG_NySessionRetest` · magic **769510** · U30USD · M15 · rischio vivo
> **0,65%** · **DD PROMESSO 4,7%** · banco: 100.000 · 0,65% · **tick** ·
> 2024.09.26→2026.06.30 · **n 115** · MERITO 🟠 SOSPESO · **freq. promessa
> ~5,45 op/mese ⇒ ~0,25 op/g** · fonte `report/CORSIA_DEMO_NYRETEST.md`

**Senza quella riga il criterio di uscita del 18/08 non è applicabile**: il "DD
promesso" non starebbe scritto in nessun posto operativo
(`CORSIA_DEMO_CANDIDATI.md` §7).

---

## 🛑 E VALE PER TUTTE E TRE

**La corsia demo NON è una porta verso il conto reale.** Una sedia che va bene in
demo **non passa in campo in automatico**: torna in coda all'imbuto col suo n
finalmente pieno, e da lì si giudica col merito come tutte. Il passaggio ai soldi
veri resta una **firma specifica su un numero misurato**.
