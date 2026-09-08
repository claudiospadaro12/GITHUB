# ✍️ FIRMA — PostNews EURJPY ed EURUSD dal 3,0% all'1,30%

**Claudio, 08/09/2026:** _"SI, PORTA ANCHE EURJPY E EURUSD A 1.30"_.

Chiude il rilievo dell'08/09 03:30: il rischio era stato portato a 1.30 su
**una sola** delle tre sedie PostNews (USDJPY 771203), stabile su due
censimenti.

---

## 🔢 PERCHÉ 1,30 E NON 0,65 — l'aritmetica, verificata nel sorgente

Non è un numero tondo scelto a occhio. `mql5/Experts/ABTG_PostNews.mq5`:

| riga | codice | significato |
|---|---|---|
| 98 | `InpSLpips = 25.0` | lo stop **vero** di ogni gamba: **25 pip** |
| 114 | `InpRiskRefSLpips = 50.0` | il riferimento con cui si dimensiona: **50 pip** |
| 325 | `double lot=LotByRisk(InpRiskRefSLpips*pip);` | 👉 la size si calcola sui **50**, non sui 25 |
| 479 | `risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;` | il rischio è % del **saldo** |

L'EA piazza **due pendenti opposti** (BUY STOP e SELL STOP) e si dimensiona sul
**caso peggiore**: entrambe le gambe stoppate = doppio stop = 50 pip.

| `InpRiskPercent` | UNA gamba stoppata | ENTRAMBE (caso peggiore) |
|---|---:|---:|
| **3.0** (il numero del corso) | **1,50%** | **3,00%** |
| **1.30** ✅ | **0,65%** | **1,30%** |

> ### 🎯 1,30 non è "meno rischio": è **la taglia di casa**.
> 0,65% per gamba è esattamente la size firmata il **18/08** — quella su cui è
> costruito il cap **C1 = 3,25% = 5 SL vivi da 0,65%**. Con 3.0 una sola sedia
> PostNews valeva **2,3 SL** del cap: due di queste e il cap era quasi pieno da
> sole.

---

## 🖥️ DOVE SI FA — conto e cartella dichiarati, come vuole la regola

`CLAUDE.md`, REGOLA DEI TERMINALI MULTIPLI (06/09):

| | |
|---|---|
| **conto** | 🟡 **50503392** — il DEMO piccolo |
| **cartella** | `C:\Program Files\BCM Markets MT5 Terminal` |
| profilo attivo | `ORO` |
| grafici | **EURJPY M5** (`chart43`, magic **771201**) · **EURUSD M5** (`chart44`, magic **771202**) |

### 🔴 E QUI LA REGOLA MORDE PIÙ DEL SOLITO
`CODA_03` dell'08/09 ha trovato **DUE conti** nel giornale di quella cartella:
il **50503392** (ultimo accesso 05/09) e il **conto reale** (accesso del 07/08).
👉 **Quel terminale ha cambiato login in passato.** Non basta riconoscere la
cartella: va letto **il numero di conto nel titolo della finestra**.

### La stringa che stampa PID + titolo + cartella (SOLA LETTURA)
```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-List
```
> ✅ **Autosufficiente: non scarica niente.** Il difetto del 10/08 (una copia
> vecchia dello script scaricato che rifà la cosa sbagliata) qui non può
> esistere, perché non c'è niente da scaricare.
>
> Va bene **solo** la riga il cui `Path` è
> `C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe` **e** il cui
> titolo contiene **50503392**.
> 🔴 Da NON toccare: `...MT5 Terminal -V3` (100k), `C:\BCM_Reale` (**reale**),
> `C:\MT5_Backtest` (nuovo).

---

## 📋 I DUE PASSI, e nient'altro

Su **ciascuno** dei due grafici (EURJPY M5 e EURUSD M5):
1. tasto destro sul grafico → **Lista degli Expert** (oppure **F7**);
2. scheda **Parametri di input** → `InpRiskPercent`: da **3.0** a **1.30**;
3. **OK**.

> ### ⚠️ NON caricare un preset. Solo quel numero.
> Caricare un `.set` riscriverebbe **tutti** gli input — orari, filtri news,
> **e il magic**. Qui si cambia **una cosa sola**, che è quella firmata.

### ✅ Come si verifica che sia entrato
Cambiare un input **fa ripartire l'EA**: nella scheda **Esperti** deve comparire
una riga nuova `[PostNews] avviato su EURJPY…` **con l'ora di adesso**. Se non
compare, il parametro non è stato applicato.

### 🟠 E una cosa che NON è un errore
Stanotte `CODA_01` potrebbe stampare ancora **3.0**: legge dai file `.chr`, che
MT5 riscrive **quando il profilo viene salvato**, non quando cambi un input.
👉 È esattamente la domanda che `CODA_05` misura stanotte. Per farlo entrare
anche nella foto: **File → Profili → Salva come… → `ORO`** (sovrascrivi).

---

## 🔴 IL SEGUITO: la BCE del 10/09 NON è ancora armata

Il rischio è metà del lavoro. Dai log del 07/09:
- `USDJPY` → *"righe 3 | **UTILI**"* → il calendario contiene righe **USD**
  (residuo del collaudo NFP del 04/09);
- `EURUSD` e `EURJPY` → **CANARINO ROSSO**: nessuna riga per quel simbolo.

**È il comportamento giusto**: i due preset EUR filtrano
`InpNewsCurrencies=EUR` + `InpNewsTitleMatch=ECB`, e nel file **non c'è ancora
nessuna riga BCE**. Senza quella riga, il 10/09 **non spara niente**.

### 🧨 E una trappola trovata prima di pagarla
La scorciatoia sarebbe caricare `ABTG_PostNews_ECB_EURJPY.set` anche su EURUSD:
un `.set` non contiene il simbolo, quindi "funzionerebbe". **Ma porta dentro
`InpMagic=771201`** — il magic della sedia EURJPY. Due sedie con lo **stesso
magic** non si distinguono più: né nei referti, né **dentro l'EA** quando
controlla se ha già una posizione viva.

E l'altra scorciatoia — caricare il preset FOMC su EURUSD — è sbagliata per un
altro motivo: filtra **USD** e `FOMC`, e agisce alle **19:40 server**. Sulla
BCE non sparerebbe mai.

✅ **Preparato**: `mql5/Presets/ABTG_PostNews_ECB_EURUSD.set` — identico
all'ECB, con `InpMagic=771202` e commento distinto. **Esiste; non è stato
caricato su niente.** Caricarlo (o no) è una decisione a parte.

---

## ✍️ COSA RESTA DA FIRMARE, separatamente
1. **Si arma davvero la BCE del 10/09?** Serve scrivere la riga BCE in
   `abtg_news.csv` (valuta EUR, impatto 3, titolo con "ECB"). **Scrivere quel
   file è fuori dal perimetro firmato del runner**: lo fai tu, o si firma un
   allargamento.
2. **Con quale coppia?** Solo EURJPY (preset esistente, già collaudato) oppure
   **anche** EURUSD (preset nuovo, mai girato).
