# 🧾 ATTACCARE `ABTG_TradeExporter` SUL CONTO REALE 10105439 — istruzione controllata

**Scritto dal cancello `controllo-preventivo`.**
**Ora di scrittura: 12/09/2026 00:26 ora italiana** (= 11/09 23:26 ora server BCM).
Il nome del file resta quello chiesto (`..._2026-09-11.md`), ma **l'ora conta** e
sta scritta: e' gia' **sabato notte**, e questo cambia due cose vere piu' avanti
(§7 e §9).

---

# 0️⃣ VERDETTO DEL CANCELLO: 🔴 **FAIL sull'istruzione COSI' COM'ERA** — e le tre ragioni non sono formali

> 🟢 **Prima quello che ha RETTO**, perche' un elenco di soli difetti descrive
> male la realta' (regola di casa): **l'analisi del sorgente e' GIUSTA al 100%,
> rifatta da me riga per riga e non presa per buona.** `ABTG_TradeExporter.mq5`
> (211 righe) **non contiene nessuna chiamata di trading**: grep su
> `OrderSend`, `CTrade`, `PositionOpen`, `PositionClose`, `PositionModify`,
> `OrderDelete`, `OrderModify` → **zero occorrenze**, e in piu' **zero
> `#include`** (nessuna libreria trascinata dentro). I quattro input sono
> esattamente quelli dichiarati. Il preset `ABTG_TradeExporter_REALE.set`
> esiste, e' **ASCII puro (0 byte sopra 127)** e ha `InpFile` giusto. La catena
> a valle (`pubblica_trades.ps1` → `analizza_trades.py`) e' **gia' pronta e
> coerente**: il nome `ABTG_Trades_Reale.csv` e le 16 colonne combaciano.
> 👉 **Su "l'EA e' innocuo" non ho trovato NIENTE da correggere.**

## 🔴 I TRE DIFETTI CHE BLOCCANO L'ISTRUZIONE ORIGINALE

| # | difetto | classe | prova |
|---|---|---|---|
| **1** | **Sul terminale del reale ci sono QUATTRO EA, non due** — e il quarto e' **`ABTG_Guardian` su EURGBP H1**, che **CHIUDE POSIZIONI** (`CTrade` + `PositionClose`, `ABTG_Guardian.mq5` r.182/r.690). Trascinare l'esportatore su quel grafico **spegne il freno d'emergenza del conto vero.** | 🆕 **242** (proposta) | `CODA_09_giornale_operativo_20260911`: `03:30:00.798 ABTG_Guardian (EURGBP,H1) [GUARDIAN] eq=[OMESSO: repo pubblico] ... stato=OK`. Il censimento `CODA_01` **non lo elenca** (dice 3 sedie): la sua foto `.chr` e' **vecchia di 100,3 ore** (`CODA_05`). |
| **2** | **Il gesto "trascina l'EA dal Navigatore" e' OGGI IMPOSSIBILE**: `ABTG_TradeExporter` **non risulta presente** sul terminale del reale. | 🆕 **243** (proposta) | `CODA_06_quale_codice_gira_20260911`, sezione `C:\BCM_Reale`: **43 sorgenti `.mq5`**, elencati per nome, e l'esportatore **non c'e'** (ci sono solo `ABTG_DAX_Apertura_EU`, `ABTG_Guardian`, `ABTG_ORB_Ottimizzato`, `ABTG_SlippageLogger` + 39 esempi MetaQuotes). |
| **3** | **Il CSV NON arriverebbe nel repo "stasera"**: l'attivita' `ABTG_PubblicaTrades` gira **`/SC WEEKLY /D MON,TUE,WED,THU,FRI /ST 22:45`** (`pubblica_trades.ps1` r.~85). Adesso e' **sabato 00:26**: la pubblicazione di venerdi' e' **gia' passata** (commit `2026-09-11 22:45:03 +0200`). **Prossima corsa: lunedi' 14/09 alle 22:45.** | 219-bis / nuova | `git log -- data/statements/trades_auto.csv` → cinque corse consecutive alle 22:45. |

🔴 **E c'e' una QUARTA cosa, che non e' un difetto tecnico ma una DECISIONE DI
CLAUDIO** (§8): **il repo `claudiospadaro12/GITHUB` e' PUBBLICO**
(`api.github.com` → `"private": false, "visibility": "public"`). Pubblicare
`trades_reale.csv` mette **lo storico operativo di un conto con soldi veri su
internet, per sempre, dentro la storia di git.** Nessun documento lo aveva mai
scritto. **Non lo decido io.**

---

# 1️⃣ 🖥️ IL TERMINALE — sei installazioni, una sola e' quella giusta

✏️ **NOTA DEL 12/09/2026 — e la prima versione di questa nota era SBAGLIATA.**
🟢 **Il SEI e' GIUSTO.** `CODA_03` r.63 conta cartella dati chi ha **`MQL5`
dentro**, che e' la definizione giusta, e sul VPS sono **sei**. Sotto
`MetaQuotes\Terminal` ci sono anche `Common`, `Community`, `Help` e **due
residui senza `MQL5`** (`15BEB048…` 0,07 GB e `FF5C0E29…` 0,00 GB): `CODA_04`
li **pesa** perche' misura il disco, ma **non sono terminali**.
🔴 Stamattina avevo scritto qui *"non SEI, OTTO"*: **era un mio errore**, e la
causa e' che ho confrontato due conteggi senza leggere la **definizione** dietro
a ciascuno. Memoria: `report/DUE_MACCHINE_2026-09-12.md` (sezione ERRATA).

<details>
<summary>La nota sbagliata, lasciata per memoria</summary>
✏️ ~~**CORRETTO IL 12/09/2026: non SEI, OTTO.**~~ Qui c'era scritto *"Sul VPS ci
sono SEI cartelle dati MT5"*: **falso**, e l'errore e' mio. `CODA_03` scrive
*"cartelle dati: 6"* perche' conta quelle di cui **sa dire il programma** — ed
e' corretto lui. Incrociando con `CODA_04`, che le **pesa tutte**, le cartelle
dati sono **OTTO**: le due in piu' sono **`15BEB048…` (0,07 GB)** e
**`FF5C0E29…` (0,00 GB)**, e **non sono mai state identificate**. Piccole,
quindi probabilmente terminali aperti e mai usati — 🔴 *"probabilmente"* non e'
una misura. E la cautela era **scritta nel referto** (`CODA_03` dice *"NON
TROVATO nei giornali recenti (non vuol dire che non ci sia)"*): l'ho ignorata
scrivendo un totale. Misura: `report/DUE_MACCHINE_2026-09-12.md`.

</details>

Sul VPS ci sono **SEI** cartelle dati MT5 (misurato stanotte,
`backtest_pipeline/coda/referti/CODA_03_conti_dei_terminali_20260911_033002.log`):

## ✅ L'UNICO DA TOCCARE
### **conto 10105439** (REALE, soldi veri) — cartella programma **`C:\BCM_Reale`** — profilo `Default`

## ❌ I CINQUE DA NON TOCCARE
| conto | cartella programma |
|---|---|
| **50503392** (demo piccolo) | `C:\Program Files\BCM Markets MT5 Terminal` |
| **50504263** (dry-run 100k) | `C:\Program Files\BCM Markets MT5 Terminal -V3` |
| **50504400** (banco backtest) | `C:\MT5_Backtest` |
| conto non identificato nei giornali | `C:\Program Files\Pepperstone MetaTrader 5` |
| conto non identificato nei giornali | `C:\Program Files\Tickmill Europe MT5 Terminal` |

## 🔍 E IL RICONOSCIMENTO NON SI FA "A OCCHIO"
Riga di **sola lettura**: stampa e basta.

```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```

👉 Serve la riga il cui **`Path` comincia con `C:\BCM_Reale`**: quello e' il PID
del **10105439**. Porta in primo piano **quella** finestra e controlla che nella
scheda **Conto** / in alto compaia **`10105439`**.
🔴 **Se leggi 50503392, 50504263 o 50504400: FERMATI, e' la finestra sbagliata.**
_(Regola nata da un incidente vero del 06/09: un attacco EA destinato al piccolo
stava per finire sul REALE.)_

---

# 2️⃣ 🔴 IL RISCHIO NUMERO UNO: **IL NOME DEL FILE**

## ⛔ SE `InpFile` RESTA IL DEFAULT `ABTG_Trades.csv`, IL CONTO REALE SOVRASCRIVE IL CSV DEL CONTO PICCOLO 50503392.

**Perche' succede** (verificato nel sorgente, non raccontato):
`ABTG_TradeExporter.mq5` r.173-175 apre il file con `FILE_COMMON` →
scrive in **`%APPDATA%\MetaQuotes\Terminal\Common\Files`**, che e'
**UNA SOLA cartella condivisa da TUTTI i terminali MT5 dello stesso utente
Windows**. Tre terminali con lo stesso `InpFile` = i tre conti si sovrascrivono
a vicenda.

| conto | `InpFile` obbligatorio | dove finisce nel repo |
|---|---|---|
| piccolo 50503392 | `ABTG_Trades.csv` | `data/statements/trades_auto.csv` (**175.746 byte, 1.304 righe**) |
| 100k 50504263 | `ABTG_Trades_100k.csv` | `data/statements/trades_100k.csv` (4.490 byte) |
| **REALE 10105439** | 🔴 **`ABTG_Trades_Reale.csv`** | `data/statements/trades_reale.csv` |

Verificato in `backtest_pipeline/pubblica_trades.ps1` (parametri
`$CsvNameReale = "ABTG_Trades_Reale.csv"` → `$RepoPathReale =
"data/statements/trades_reale.csv"`): **se il nome non e' ESATTAMENTE quello,
lo script non pubblica niente per il reale** e in piu' il piccolo racconta il
conto sbagliato.

⚠️ **E NON si ripara da solo.** Se il nome resta il default, i due esportatori
riscrivono lo **stesso** file ogni 30 minuti: il contenuto **alterna** fra i due
conti e la pagella pesca a caso. Si ripara solo **cambiando l'input**.
🟢 La rete di sicurezza c'e' ma e' l'ultima: l'ultima copia buona del piccolo e'
gia' nel repo (`trades_auto.csv`, pubblicata alle 22:45 di venerdi').

👉 **Al §6 c'e' la riga che STAMPA la prova che l'incidente non e' successo.**

---

# 3️⃣ 🔴 IL PERICOLO VERO: **SU QUALE GRAFICO**

**Trascinare un EA su un grafico che ne ha gia' uno lo SOSTITUISCE.**
Sul terminale del **10105439** i grafici occupati sono **QUATTRO**, non due:

| grafico | EA | magic | cosa succede se ci finisce sopra l'esportatore |
|---|---|---|---|
| **D30EUR M5** | `ABTG_DAX_Apertura_EU` | **770101** | 🔴 sedia viva con soldi veri: si spegne |
| **U30USD M5** | `ABTG_ORB_Ottimizzato` | **770611** | 🔴 sedia viva con soldi veri: si spegne |
| **EURJPY H1** | `ABTG_SlippageLogger` | — | 🟠 si perde la misura dello slippage vero |
| 🆕 **EURGBP H1** | **`ABTG_Guardian`** | **779001** | 🔴🔴 **si spegne il FRENO D'EMERGENZA**: e' l'unico dei quattro che **chiude posizioni** (`CTrade`, `PositionClose`) |

> 🔎 **Come lo so, e perche' il documento dell'08/09 non lo diceva.** Il
> censimento delle sedie (`CODA_01`) legge i file `.chr`, cioe' una **foto al
> salvataggio del profilo**: quella del reale e' del **06/09 23:10**, **vecchia
> di 100,3 ore** (`CODA_05`), ed elenca **tre** sedie. Il **giornale** invece e'
> di stanotte e inchioda il Guardian vivo su EURGBP H1 alle 03:30.
> 👉 **La foto e il giornale non dicono la stessa cosa, e il giornale vince.**

## ✅ LA REGOLA CHE ELIMINA IL PROBLEMA ALLA RADICE
🔴 **NON si cerca "un grafico libero". SI APRE UN GRAFICO NUOVO.**
In MT5 **File → Nuovo grafico → EURUSD** apre una **finestra nuova**, che e'
**vuota per costruzione** — anche se dello stesso simbolo esistesse gia' un
grafico. Cosi' il ragionamento *"quali simboli sono liberi?"* (che si appoggia a
una foto vecchia di 100 ore, ed e' un insieme definito **per differenza** —
classe 180) **non serve piu'**.

**Simbolo consigliato: `EURUSD`, periodo `H1`.** Motivo: nessuno dei quattro EA
del reale lo usa (usano D30EUR, U30USD, EURJPY, EURGBP), quindi **non puoi
confondere due finestre che si somigliano**. E' anche dove sta l'esportatore sul
100k (`SQUADRA 100K\chart05.chr`), quindi il VPS e' gia' cosi'.
⚠️ Se `EURUSD` non fosse nella **Osservazione del mercato** di quel terminale,
si aggiunge da li' (`Ctrl+U`). **Non e' stato verificato che ci sia** (§10).

## 🧪 COME SI VERIFICA CHE IL GRAFICO E' VUOTO, **PRIMA** DI TRASCINARE
Sulla finestra appena aperta, **angolo in alto a DESTRA**:
- 🟢 **vuoto** = non c'e' **nessun nome di EA** e **nessuna faccina** 🙂/🙁;
- 🔴 **occupato** = c'e' scritto un nome (es. `ABTG_Guardian`) con la faccina.

👉 **Se vedi un nome qualsiasi in quell'angolo: non e' il grafico nuovo. Chiudi
e rifai `File → Nuovo grafico`.**

---

# 4️⃣ ⚠️ PRIMA DI TUTTO: L'EA **NON C'E'** SU QUEL TERMINALE

Misurato stanotte: su `C:\BCM_Reale` ci sono **43 sorgenti `.mq5`** e
`ABTG_TradeExporter` **non e' fra questi**.
⚠️ **Limite dichiarato**: quel censimento elenca i **`.mq5`**. Se qualcuno avesse
copiato li' solo il **`.ex5`** compilato, **non comparirebbe**. Quindi e' un
**indizio fortissimo, non una prova** — e infatti il passo 1 lo **misura**
invece di assumerlo.

## 🔎 La riga che lo dice, per tutti e sei i terminali (sola lettura)

```powershell
Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal") -Directory | ForEach-Object { $o = Join-Path $_.FullName "origin.txt"; $n = $_.Name; if (Test-Path $o) { $n = (Get-Content $o -Raw) }; $e = Join-Path $_.FullName "MQL5\Experts"; Write-Host ("--- " + $n); Write-Host ("    cartella : " + $e); Write-Host ("    ABTG_TradeExporter.ex5 presente: " + (Test-Path (Join-Path $e "ABTG_TradeExporter.ex5"))) }
```

🎯 **ATTESA DICHIARATA PRIMA DI VEDERE IL NUMERO** (regola di casa):
- `C:\Program Files\BCM Markets MT5 Terminal` (**50503392**) → **True**
- `C:\Program Files\BCM Markets MT5 Terminal -V3` (**50504263**) → **True**
- `C:\BCM_Reale` (**10105439**) → 🔴 **False** ← e' questo che ci aspettiamo
- gli altri tre → indifferente

**Se invece esce `True` su `C:\BCM_Reale`**: ottimo, **salti tutto il passo 2**.

## 🚚 COME PORTARCELO — e perche' **NON** con MetaEditor

| via | cosa comporta | giudizio |
|---|---|---|
| 🟢 **COPIARE il `.ex5` gia' compilato** dalla cartella `MQL5\Experts` del piccolo **50503392** a quella del reale (le due cartelle le stampa la riga qui sopra) | aggiunge **un file nuovo**. Non tocca nessun file dei quattro EA vivi. | ✅ **QUESTA** |
| 🔴 copiare il `.mq5` e compilarlo con **F7 in MetaEditor** aperto dal terminale del reale | MetaEditor ha anche **"Compila tutto"**, e **MT5 RICARICA un EA quando il suo `.ex5` cambia sul disco**: un click sbagliato **reinizializza `770101`, `770611` e il Guardian sul conto vero**, in silenzio. | ❌ **NO** |

> 📌 **Onesta' sulla fonte**: che MT5 ricarichi l'EA alla ricompilazione e'
> **comportamento noto del programma**, **non misurato da noi su questa
> macchina**. Ma l'asimmetria e' netta: la via 🟢 non ha **nessun** modo di
> toccare gli altri EA, la via 🔴 ne ha uno. Si prende quella senza.

⚠️ **Il limite della via 🟢, dichiarato**: un `.ex5` gira solo se la build di MT5
del terminale di destinazione e' compatibile con quella che l'ha compilato. Qui
sono **due MT5 dello stesso broker sulla stessa macchina**, quindi e' quasi
certo che vada — ma **se non va, lo dice la scheda Esperti** ("expert non
compatibile" o simile) e **non succede nient'altro**. In quel caso: **fermati e
scrivimelo**, non aprire MetaEditor.
📌 Dopo la copia, nel **Navigatore** (`Ctrl+N`) → clic destro → **Aggiorna**,
altrimenti l'EA nuovo non compare.

---

# 5️⃣ 📋 I PASSI, uno per uno — **CONTO 10105439, `C:\BCM_Reale`**

> ⏱️ **Quando**: adesso e' la finestra migliore della settimana — **mercati
> chiusi**. Nessun range ORB in formazione (si forma **14:30-14:45 ora server =
> 15:30-15:45 italiane**), nessuna apertura DAX (**08:00 server = 09:00
> italiane**), nessuna posizione viva (il Guardian stanotte stampa
> `rischioAperto=0.00%`).
> 📌 **Ora server BCM = ora italiana − 1.** Sempre.

**0.** Lancia la riga del **§1** e porta in primo piano **solo** la finestra con
`Path` = `C:\BCM_Reale`. Verifica **`10105439`** nella scheda Conto.
🔴 Altro numero → **FERMATI**.

**1.** Lancia la riga del **§4** e leggi la riga di `C:\BCM_Reale`.
- `True` → vai al **passo 3**.
- `False` → **passo 2**.

**2.** Con **Esplora Risorse** (non con uno script), copia
`ABTG_TradeExporter.ex5` dalla cartella `MQL5\Experts` del **piccolo 50503392**
alla cartella `MQL5\Experts` del **reale 10105439** — **i due percorsi esatti li
ha appena stampati la riga del §4**. Poi `Ctrl+N` → clic destro nel Navigatore →
**Aggiorna**.
🔴 **Non aprire MetaEditor. Non premere F7. Non toccare nessun altro file di
quella cartella.**

**3.** **File → Nuovo grafico → `EURUSD`**, poi mettilo su **H1**.
🔴 **NON usare un grafico gia' aperto.** Controlla l'angolo in alto a destra:
**deve essere vuoto** (niente nome EA, niente faccina).

**4.** Trascina `ABTG_TradeExporter` **su quella finestra nuova**. Si apre la
finestra dei parametri.

**5.** Scheda **"Dati in ingresso"**. I valori devono essere **esattamente**
questi quattro — o li carichi col pulsante **"Carica"** scegliendo
`ABTG_TradeExporter_REALE.set`, oppure **li scrivi a mano** (sono quattro, e
fare a mano toglie la dipendenza da un file che potrebbe non essere sul VPS):

| input | valore |
|---|---|
| 🔴 **`InpFile`** | 🔴 **`ABTG_Trades_Reale.csv`** ← **LA RIGA CHE CONTA. GUARDALA DUE VOLTE.** |
| `InpFromYear` | `2024` |
| `InpExportMinutes` | `30` |
| `InpUseCommon` | `true` |

🔴 **Se `InpFile` dice `ABTG_Trades.csv` (il default) e premi OK, entro un
secondo il conto REALE ha sovrascritto il CSV del conto piccolo** (l'export
parte in `OnInit`, r.101, non aspetta i 30 minuti). **Vedi §2.**

**6.** 🟢 **Su QUESTA finestra si preme OK** — ed e' giusto cosi': l'EA non sta
ancora girando, OK e' il gesto che lo avvia.
🔴 **E qui la differenza che costa cara: su QUALUNQUE finestra "Proprieta'" di
uno dei quattro EA GIA' VIVI (`770101`, `770611`, SlippageLogger, Guardian) si
esce con ANNULLA / Esc, MAI con OK** — premere OK su un EA che gira lo
**reinizializza** (`OnDeinit`/`OnInit`) e ne azzera gli stati in memoria, **sul
conto reale**. Se in questa sessione ti trovi davanti una di quelle finestre:
**Esc**.

**7.** Guarda la scheda **Esperti**: deve comparire **subito** una riga

```
[TradeExporter] esportati N trade chiusi in Common\Files\ABTG_Trades_Reale.csv
```

🎯 **Attesa dichiarata**: il nome del file deve finire in **`_Reale.csv`**.
🔵 **Su `N` NON ho un'attesa**, e lo dico invece di inventarla: **del conto
10105439 non esiste NESSUNO statement nel repo**, quindi non so quante
operazioni chiuse abbia dal 2024. **Qualunque `N` esca e' un'informazione
nuova** — anche `N=0` (vorrebbe dire storico non ancora scaricato in quel
terminale, e si guarda insieme).

**8.** La **prova stampata** che l'incidente del §2 **non** e' successo
(sola lettura):

```powershell
Get-ChildItem (Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files") -Filter "ABTG_Trades*.csv" | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
```

🎯 **ATTESA DICHIARATA PRIMA DI GUARDARE** — devono uscire **TRE** file:

| file | lunghezza attesa | significato |
|---|---:|---|
| `ABTG_Trades.csv` | **≈ 175.746 byte** (piccolo 50503392) | 🟢 **se e' ancora ~175 KB, il piccolo e' salvo** |
| `ABTG_Trades_100k.csv` | ≈ 4.490 byte | intatto |
| `ABTG_Trades_Reale.csv` | **nuovo, piccolo** | 🟢 il reale scrive nel posto giusto |

🔴 **CONTRO-ESEMPIO, cioe' come si vede il disastro invece di confermarsi
addosso**: se hai lasciato il nome di default, `ABTG_Trades_Reale.csv`
**NON compare affatto** e `ABTG_Trades.csv` **crolla da 175 KB a pochi KB**, con
`LastWriteTime` di un minuto fa. Le due situazioni sono **distinguibili a
colpo d'occhio**: e' per questo che la verifica e' un elenco di **tre** file e
non "il file nuovo esiste".
👉 **Se succede: torna al passo 5, correggi `InpFile`, OK.** Il piccolo si
rimette a posto **da solo entro 30 minuti** (il suo esportatore riscrive) — ma
**solo dopo** che hai corretto il nome.

**9.** Se vuoi vedere subito com'e' fatto (sola lettura, prime 3 righe):

```powershell
Get-Content (Join-Path $env:APPDATA "MetaQuotes\Terminal\Common\Files\ABTG_Trades_Reale.csv") -TotalCount 3
```

**10.** **File → Profili → Salva profilo** (`Default`), altrimenti l'EA sparisce
al primo riavvio del terminale.
⚠️ **Prima di salvare, conta le finestre dei grafici: devono essere CINQUE**
(D30EUR, U30USD, EURJPY, EURGBP + EURUSD nuovo). Salvare il profilo **congela
quello che vedi**: se per sbaglio un grafico fosse stato chiuso, il salvataggio
rende definitiva la perdita.
🟢 **Effetto collaterale buono**: questo salvataggio **aggiorna la foto `.chr`
vecchia di 100 ore** e da domani i censimenti vedranno finalmente **anche il
Guardian**.

---

# 6️⃣ 📬 COSA DEVE TORNARE INDIETRO

1. 📸 **Screenshot della scheda Esperti** con la riga `[TradeExporter] esportati
   N trade chiusi in Common\Files\ABTG_Trades_Reale.csv` — **e' la prova che il
   nome file e' quello giusto**, la cosa piu' importante di tutte.
2. 📸 **L'uscita della riga del passo 8** (i tre CSV con lunghezza e data): e' la
   prova che il conto piccolo non e' stato toccato.
3. 📸 **L'uscita della riga del passo 1** (`ABTG_TradeExporter.ex5 presente:`),
   se hai dovuto fare il passo 2.
4. ✅ Conferma a voce che **il profilo e' stato salvato** e che i grafici erano
   **cinque**.
5. 📎 **[FACOLTATIVO, ma e' la via piu' veloce ai numeri]** allega direttamente
   in chat il file `ABTG_Trades_Reale.csv`: incolla
   `%APPDATA%\MetaQuotes\Terminal\Common\Files` nella barra di Esplora Risorse e
   trascina il file nella chat. **Cosi' i numeri del reale li leggo stanotte
   invece che lunedi'** (§7).

---

# 7️⃣ ⏱️ QUANTO CI METTE AD ARRIVARE — **e la risposta non e' "stasera"**

| tappa | quando | fonte |
|---|---|---|
| il CSV compare in `Common\Files` | **immediato** (export in `OnInit`, r.101) | sorgente letto |
| si riaggiorna | ogni **30 minuti** (`InpExportMinutes=30`, timer: **funziona anche col mercato chiuso**, r.102/106) | sorgente letto |
| 🔴 arriva **nel repo** | **lunedi' 14/09 alle 22:45** | attivita' `ABTG_PubblicaTrades`: `/SC WEEKLY /D MON,TUE,WED,THU,FRI /ST 22:45` |
| lo legge la pagella | **lunedi' 14/09 alle 23:00-23:15** | `analizza_trades.py` → `CSV_REALE` |

🔴 **Perche' non stasera**: e' **sabato 00:26**. L'ultima corsa dell'attivita' e'
stata **venerdi' 11/09 alle 22:45** (commit verificato in `git log`), e il
prossimo giorno feriale e' **lunedi'**.
👉 Se vuoi i numeri prima: **punto 5 del §6** (trascini il file in chat).
🚫 **Non ti do una riga per pubblicare a mano**: `pubblica_trades.ps1` **non ha
un MARCATORE di versione**, quindi una riga che lo scarichi ed esegua **viene
bocciata dal cancello** (e giustamente: senza marcatore non si sa se gira la
copia buona o una vecchia in cache). Si aggiunge il marcatore, oppure si aspetta
lunedi'.

---

# 8️⃣ 🔴 LA DECISIONE CHE E' TUA, E CHE NESSUNO AVEVA SCRITTO

## Il repo `claudiospadaro12/GITHUB` e' **PUBBLICO**.
Verificato adesso: `https://api.github.com/repos/claudiospadaro12/GITHUB` →
`"private": false`, `"visibility": "public"`.

Quindi `pubblica_trades.ps1` metterebbe **`data/statements/trades_reale.csv`** —
cioe' **ogni operazione chiusa del tuo conto con soldi veri**: simbolo, volume,
prezzi, **profitto in euro**, magic — **su internet, in chiaro, e per sempre
nella storia di git** (anche cancellandolo dopo, il commit resta).

- 🟢 Il file **non contiene** il numero di conto, ne' il tuo nome, ne' il saldo.
- 🔴 Contiene **le taglie reali e i P/L reali**. I due CSV gia' pubblici sono di
  conti **demo**: questo sarebbe il primo di **denaro vero**.
- 🔵 Se non ti va, l'esportatore **serve lo stesso**: il file resta in
  `Common\Files` e me lo mandi tu quando vuoi (§6 punto 5). Si perde solo
  l'automatismo della pagella serale.

👉 **Il conto reale e' fra le tre cose che CLAUDE.md riserva a te. Io lo segnalo
e mi fermo.** Se mi dici "pubblica", si pubblica; se mi dici "no", cambio la
catena in modo che il reale **non** salga sul repo.

---

# 9️⃣ 🚪 L'ALTERNATIVA CHE **NON TOCCA NESSUN GRAFICO** — e per la prima misura basta

## 🅰️ L'estratto conto di MT5 (consigliata se stasera vuoi solo i NUMERI)
Nel terminale **10105439** (`C:\BCM_Reale`), in basso:
scheda **Cronologia** → clic destro → **Rapporto** → salva su Desktop
(HTML o XLSX) → mandamelo.

- ✅ **Zero grafici toccati, zero EA toccati, zero file copiati.** Il rischio di
  spegnere una sedia e' **nullo**, perche' non si va mai vicino a un grafico.
- ✅ Contiene **tutte le operazioni chiuse con il P/L vero**: basta e avanza per
  la prima misura (frequenza, DD realizzato, netto, e il controllo del parziale
  della `770101`).
- 🔴 **Cosa si perde, detto in chiaro:** (a) **la colonna `magic`**, quindi
  l'attribuzione all'EA si fa per **simbolo/commento** invece che per numero —
  qui regge perche' le due sedie stanno su **simboli diversi** (`D30EUR`=770101,
  `U30USD`=770611), ma **non reggerebbe** se un giorno due EA condividessero un
  simbolo; (b) il **`close_reason`** (sl / tp / expert), che e' quello che
  distingue lo stop **iniziale** dal **trailing**; (c) il **massimo/minimo di
  sessione** (la "frazione di movimento catturata"); (d) **l'automatismo**: e'
  un gesto da rifare a mano ogni volta.
- 🔴 **Avvertenza**: si lavora nella scheda **Cronologia**. La scheda **Trade**,
  che le sta accanto, e' quella dove il clic destro offre **"Chiudi
  posizione"**. Non e' la stessa scheda.

## 🅱️ A mani completamente ferme (gia' fatto, ogni notte)
I **giornali** del terminale del reale sono gia' letti dal runner in sola
lettura: `CODA_09` conta le operazioni per giorno. Misurato stanotte:
**10/09 e 11/09 → ZERO operazioni** sul 10105439, equity **[OMESSA: repo pubblico]**, `totDD
-0,10%`. 🔴 **Ma il giornale non stampa il P/L**: da qui non si ricava ne' il
profitto ne' il drawdown realizzato. Serve 🅰️ o l'esportatore.

## 🎯 LA MIA RACCOMANDAZIONE, in una riga
**Stasera 🅰️** (costa due click e non puo' rompere niente) **e l'esportatore
quando vuoi**, perche' — misurato al §7 — **l'esportatore non consegna niente
prima di lunedi' 22:45 comunque.** Non c'e' nessuna fretta che giustifichi di
fare il gesto piu' delicato di corsa.

## 🧩 E SE FAI DUE GESTI NELLA STESSA SEDUTA
C'e' gia' un altro gesto in attesa sullo stesso terminale
(`report/DUE_GESTI_2026-09-11.md`, il cambio OPPRANGE sulla `770611`) — **e il
suo perimetro e' ancora in dubbio** (§5 buco 8 di quel documento: un verbale
dice "sul reale", il piano dice "senza toccare il reale"). 🔴 **Quel dubbio va
chiuso prima**, non durante.
Se li fai tutti e due: **prima l'esportatore** (aggiunge solo un grafico), **poi
il cambio parametri** (reinizializza una sedia viva), **e un solo salvataggio
del profilo alla fine**.

---

# 🔟 ↩️ COME SI ANNULLA — in dieci secondi, senza toccare nient'altro

1. Clic destro **sul grafico EURUSD H1 dell'esportatore** (controlla il nome
   `ABTG_TradeExporter` nell'angolo in alto a destra: **e' l'unico grafico da
   cui si tocca qualcosa**) → **Consulenti Esperti** → **Rimuovi**.
   Oppure, piu' semplice: **chiudi quella finestra di grafico**.
2. **File → Profili → Salva profilo** (altrimenti l'EA torna al riavvio).
3. 🔵 Facoltativo: cancella `ABTG_Trades_Reale.csv` da
   `%APPDATA%\MetaQuotes\Terminal\Common\Files`. Se non lo cancelli non succede
   niente: `pubblica_trades.ps1` lo tratta come **facoltativo** e si limita a
   pubblicare l'ultima versione.
4. 🔵 Il `.ex5` copiato al passo 2 puo' restare dov'e': un file non attaccato a
   nessun grafico **non esegue niente**.

🔴 **Quello che NON annulla niente**: togliere l'esportatore **non** ripara un
`ABTG_Trades.csv` sovrascritto. Quello si ripara solo **correggendo `InpFile`**
e aspettando il giro successivo dell'esportatore del piccolo (≤30 min).

---

# 1️⃣1️⃣ 🚦 IL CANCELLO DETERMINISTICO — esito riportato

```
python3 backtest_pipeline/controlla_riga.py --oggetto md report/EXPORTER_SUL_REALE_2026-09-11.md
```

Le **quattro** righe PowerShell di questo documento sono **tutte di sola
lettura** (`Get-Process`, `Get-ChildItem`, `Get-Content`, `Test-Path`,
`Write-Host`): nessuno script scaricato, nessun `Copy-Item`, nessun percorso di
terminale scritto dentro una riga, nessun conto nominato in una riga, **ASCII
puro**. L'esito e' riportato nel messaggio che accompagna questo referto.

🚫 **Due righe le ho scritte e BUTTATE, e dico perche':**
- una `Copy-Item` che portava il CSV sul Desktop → **bocciata (classe 173)**:
  `Copy-Item` non e' nella lista bianca di sola lettura. Sostituita da un gesto
  di Esplora Risorse (§6 punto 5), che **fa la stessa cosa senza far eseguire
  niente**.
- una riga che scaricava ed eseguiva `pubblica_trades.ps1` → **bocciata
  (MARCATORE)**: quello script **non ha un marcatore di versione**, quindi non
  si puo' dimostrare che giri la copia buona. Vedi §7.

---

# 1️⃣2️⃣ 📌 CLASSI NUOVE DA AGGIUNGERE ALLA CHECKLIST

🔴 **PRIMA: c'e' una COLLISIONE DI NUMERI da sanare.**
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` ha gia' una **classe 239**
(*"il riconoscitore ancorato in testa: 668 file veri dichiarati inesistenti"*),
ma `report/OPPRANGE_LA_FIRMA_VA_RIVISTA_2026-09-11.md` r.123 e
`report/DUE_GESTI_2026-09-11.md` §4 chiamano **"239"** la regola
*"la finestra Proprieta' si chiude con Annulla"*. **Sono due cose diverse con lo
stesso numero**, e la seconda **non e' ancora nella checklist**: va inserita con
un numero libero **prima** che qualcuno la citi per l'ennesima volta.

Numeri liberi da **240** in poi (la checklist si ferma a 239; 240/241 sono gia'
**proposte** in `DUE_GESTI`):

- **242 — L'INVENTARIO DELLE SEDIE PRESO DALLA FOTO, SMENTITO DAL GIORNALE.**
  L'istruzione per il conto reale diceva *"due sedie vive"*, e anche il
  censimento `CODA_01` ne elenca **tre**, perche' legge i `.chr` — una foto
  **vecchia di 100,3 ore**. Il **giornale** della stessa notte mostra un
  **quarto** EA vivo, `ABTG_Guardian` su **EURGBP H1**, che e' **l'unico dei
  quattro che chiude posizioni**. 👉 **Prima di dichiarare quali grafici sono
  liberi su un terminale, la foto `.chr` si incrocia col GIORNALE, e vince il
  giornale.** E il gesto si progetta in modo da **non dipendere dall'elenco**
  (grafico NUOVO, non "grafico libero"): un insieme definito per differenza e'
  la classe 180 travestita.
  *(Caso: 11/09/2026, esportatore sul reale 10105439.)*

- **243 — L'ISTRUZIONE CHE CHIEDE DI TRASCINARE UN EA CHE SU QUEL TERMINALE NON
  ESISTE.** `report/PAGELLA_CONTO_REALE_2026-09-08.md` faceva partire il gesto
  da *"trascina `ABTG_TradeExporter` dal Navigatore"*, con la verifica
  dell'esistenza declassata a passo facoltativo. Misurato il 11/09: su
  `C:\BCM_Reale` ci sono **43 `.mq5`** e **l'esportatore non e' fra questi** —
  il gesto, cosi' scritto, si sarebbe fermato al primo minuto **davanti allo
  schermo del conto reale**, che e' il posto peggiore dove improvvisare.
  👉 **Un'istruzione che dice "trascina X" deve prima PROVARE che X e' su QUEL
  terminale**, e deve portarsi dietro **la via di rimedio gia' scelta e
  giudicata** (qui: copiare il `.ex5`, **mai** aprire MetaEditor accanto a un
  conto vero, perche' MT5 ricarica gli EA quando il loro `.ex5` cambia).
  *(Caso: 11/09/2026.)*

- **244 — IL DATO DI UN CONTO REALE PUBBLICATO SU UN REPO PUBBLICO, senza che
  nessuno l'abbia mai scritto.** La catena `TradeExporter → pubblica_trades.ps1
  → data/statements/` e' nata su conti **demo** e funziona benissimo; estesa al
  **10105439** mette P/L e taglie **reali** su un repo **pubblico**
  (`"private": false`), **irreversibilmente** (git). Tre documenti descrivono la
  catena, **nessuno** dice questa frase. 👉 **Quando una catena gia' collaudata
  viene puntata su un oggetto di natura diversa (demo → reale, letto →
  scritto, privato → pubblico), si ri-dichiara COSA ESCE e DOVE FINISCE**, e la
  decisione torna a chi ha la firma su quell'oggetto.
  *(Caso: 11/09/2026.)*

---

# 1️⃣3️⃣ 🕳️ NON COPERTO — quello che questo documento **non** ha verificato

| # | buco | perche' |
|---|---|---|
| 1 | **Che `ABTG_TradeExporter.ex5` sia davvero assente dal reale** | Il censimento elenca i **`.mq5`**: un `.ex5` copiato da solo **non comparirebbe**. Per questo il passo 1 lo **misura** (`Test-Path`) invece di fidarsi. |
| 2 | **Che `EURUSD` sia nella Osservazione del mercato del 10105439** | Mai guardato. Se manca: `Ctrl+U` e si aggiunge. Non cambia niente del resto. |
| 3 | **Che il `.ex5` del piccolo giri sul terminale del reale** | Stessa macchina, stesso broker → compatibilita' quasi certa, **ma non misurata**. Se MT5 la rifiuta lo dice nella scheda Esperti e **non succede altro**. |
| 4 | **Quanti grafici siano APERTI ADESSO sul reale** | So quali hanno un EA (giornale, fresco) e quanti `.chr` esistono (**4**, foto del 06/09). **Non so** se ci siano grafici senza EA aperti dopo. E' **irrilevante** per il gesto, perche' il passo 3 apre una finestra **nuova**. |
| 5 | **Il valore di `N`** nella riga di Esperti | 🔴 **Del conto 10105439 non esiste NESSUNO statement nel repo**: non ho un'attesa e **non me la invento**. |
| 6 | **Che il `.set` sia sul VPS** | `mql5/Presets/ABTG_TradeExporter_REALE.set` e' nel repo, **non e' stato verificato sul disco del VPS**. Per questo il passo 5 offre l'inserimento **a mano** dei quattro valori. |
| 7 | **Che `pubblica_trades.ps1` pubblichi davvero il terzo CSV** | Il ramo "file mancante" e' stato provato (08/09); il ramo "file **presente**" per il reale **non e' mai stato eseguito**: nessun `ABTG_Trades_Reale.csv` e' mai esistito. **La prima volta e' lunedi'.** |
| 8 | **Che l'attivita' pianificata esista ancora sul VPS** | Prova **indiretta ma forte**: cinque commit consecutivi alle **22:45** (07→11/09). Non ho letto `schtasks /Query`. |
| 9 | **Il perimetro del gesto OPPRANGE sulla `770611`** | 🟠 Contraddizione aperta fra `FIRME_2026-09-11.md` e `PIANO_CHALLENGE_OTTOBRE_v2.md`, dichiarata in `DUE_GESTI_2026-09-11.md` §5.8. **Non la chiudo io.** |
| 10 | **Il comportamento dell'esportatore col mercato chiuso** | `SessionRange()` (r.79-96) usa `iBarShift`/`iHighest` su M5: se lo storico M5 di D30EUR/U30USD non e' in cache, le colonne `session_high`/`session_low` possono uscire a **0,00** al primo giro. **Non e' un errore e non tocca nessun'altra colonna** — ma se le vedi a zero, e' questo. |

---

*Nessun file e' stato modificato. Nessun EA e' stato toccato. Nessuna riga e'
partita verso il VPS. Nessun candidato e' stato promosso o archiviato. Questo
documento e' una lettura di file gia' in archivio piu' un'istruzione manuale.*
