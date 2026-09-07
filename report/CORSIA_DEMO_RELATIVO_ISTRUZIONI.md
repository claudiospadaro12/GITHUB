# 🛠️ ISTRUZIONI MANUALI — accendere `RELATIVO NASUSD` (magic 774690) sul DEMO PICCOLO

_Scritte il 07/09/2026. Scheda della sedia: `report/CORSIA_DEMO_RELATIVO_NASUSD.md`._
_Preset: `mql5/Presets/ABTG_Relativo_NASUSD_DEMO.set`._

---

## 🚨 PRIMA DI TUTTO — IL CONTO, IN CHIARO

Sul VPS ci sono **TRE terminali MT5 aperti insieme**. La regola di casa (CLAUDE.md,
nata da un incidente reale del 06/09) dice che il numero di conto e la cartella
programma **si dichiarano sempre**, e che **non si riconosce mai una finestra "a occhio"**.

| conto | cartella programma | in questa procedura |
|---|---|---|
| **50503392** — DEMO PICCOLO | `C:\Program Files\BCM Markets MT5 Terminal` | ✅ **E' QUESTO** |
| 50504263 — 100k | `C:\Program Files\BCM Markets MT5 Terminal -V3` | ❌ **NON TOCCARE** |
| 10105439 — REALE | `C:\BCM_Reale` | ⛔ **NON TOCCARE, SONO SOLDI VERI** |

🔴 **E la gamba: SOLO NASUSD.** La gamba D30EUR di questo stesso motore e'
**BOCCIATA PER RISCHIO** (DD 25,01%, peggior giornata −5,20%). Se ti ritrovi con
un grafico D30EUR sotto le mani, **hai sbagliato passo**: torna indietro.

---

## PASSO 0 — 🖨️ STAMPARE QUAL E' LA FINESTRA GIUSTA (sola lettura, non tocca niente)

PowerShell sul VPS:

```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-List
```

✅ **VERIFICA CHE DEVE ESSERE VERA PRIMA DEL PASSO 1:**
hai davanti una riga il cui `Path` e' **esattamente**
`C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe`
e ti sei **segnato il suo `Id` (PID)**.
❌ Se il Path contiene `-V3` o `BCM_Reale` → **e' un'altra riga, non quella.**
❌ Se non compare nessuna riga con quel Path → il terminale del piccolo non e'
aperto: aprilo **da quella cartella**, poi rifai il passo 0.

---

## PASSO 1 — 📁 TROVARE LA CARTELLA DATI DEL **PICCOLO** (e non di un altro)

Nel terminale identificato al passo 0:
**File → Apri cartella dati** (si apre Esplora Risorse).

✅ **VERIFICA PRIMA DEL PASSO 2:** nella barra dell'indirizzo di quella finestra
c'e' un percorso del tipo `C:\Users\<utente>\AppData\Roaming\MetaQuotes\Terminal\<ID_ESADECIMALE>\`.
**Copialo**: da qui in avanti lo chiamo `<DATI_PICCOLO>`.
⚠️ **Non indovinarlo e non riusarne uno vecchio**: i tre terminali hanno tre ID
esadecimali diversi, e quello e' l'unico punto in cui si puo' sbagliare conto
senza accorgersene.

Controllo che chiude il passo: in `<DATI_PICCOLO>\MQL5\Experts\` devono gia'
esserci gli EA che il **piccolo** sta girando. Se la cartella e' vuota o contiene
EA che non riconosci, **fermati e dimmelo**.

---

## PASSO 2 — ⬇️ PORTARE EA E PRESET DENTRO IL PICCOLO

Sostituisci `<DATI_PICCOLO>` col percorso del passo 1 e incolla in PowerShell:

```powershell
$dati = "<DATI_PICCOLO>"
$repo = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro"
New-Item -ItemType Directory -Force -Path "$dati\MQL5\Presets" | Out-Null
irm "$repo/mql5/Experts/ABTG_Relativo.mq5" -OutFile "$dati\MQL5\Experts\ABTG_Relativo.mq5" -EA Stop
irm "$repo/mql5/Presets/ABTG_Relativo_NASUSD_DEMO.set" -OutFile "$dati\MQL5\Presets\ABTG_Relativo_NASUSD_DEMO.set" -EA Stop
Get-Item "$dati\MQL5\Experts\ABTG_Relativo.mq5","$dati\MQL5\Presets\ABTG_Relativo_NASUSD_DEMO.set" |
  Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize
Select-String -Path "$dati\MQL5\Presets\ABTG_Relativo_NASUSD_DEMO.set" -Pattern "^Inp" |
  ForEach-Object { $_.Line }
```

✅ **VERIFICHE PRIMA DEL PASSO 3** (tutte e tre, o non si prosegue):
1. i **due file esistono** e `LastWriteTime` e' **di oggi**;
2. l'elenco stampato ha **esattamente 28 righe `Inp...`**;
3. dentro l'elenco leggi, alla lettera: `InpMagic=774690` · `InpSimboloMetro=U30USD` ·
   `InpRiskPercent=0.65` · `InpFinestraN=40` · `InpSogliaIngressoSigma=1.35` ·
   `InpAtrSL=2.75` · `InpMaxTradesPerDay=5` · `InpOraInizioServer=14` ·
   `InpMinInizioServer=30` · `InpOraFineServer=22`.

❌ Se `InpMagic` NON e' `774690` → hai scaricato un file sbagliato. **Stop.**
❌ Se `irm` da' errore → il branch e' `lavoro`, non `main`: ricontrolla l'URL.

---

## PASSO 3 — 🔨 COMPILARE L'EA (nel terminale del piccolo 50503392)

Nel terminale del **piccolo**: **Strumenti → Editor MetaQuotes** (o F4).
Nel Navigatore di MetaEditor: `MQL5 → Experts → ABTG_Relativo.mq5` → doppio clic
per aprirlo → **F7** (Compila).

✅ **VERIFICA PRIMA DEL PASSO 4:** nella scheda **Errori** di MetaEditor leggi
**`0 error(s), ... warning(s)`**.
- ⚠️ **I warning si possono ignorare, gli errori NO.** Se c'e' anche **un solo
  errore**, copiami il testo esatto e **fermati qui**: senza `.ex5` non esiste
  nessun EA da trascinare.
- Controllo che chiude il passo: in `<DATI_PICCOLO>\MQL5\Experts\` e' comparso
  **`ABTG_Relativo.ex5`** con data di oggi.

---

## PASSO 4 — 📈 IL GRAFICO GIUSTO, E IL METRO CHE DEVE ESSERCI

⚠️ **Questo passo ha un ordine obbligato: prima il METRO, poi la GAMBA.** L'EA
legge `U30USD` per calcolare lo z-score. Se `U30USD` non e' in Market Watch e con
lo storico scaricato, **`OnInit` FALLISCE** con questo errore nel log:
`ERRORE: il simbolo METRO 'U30USD' non e' selezionabile`.

1. **Market Watch → clic destro → Mostra tutti** (oppure Simboli → cerca) e
   assicurati che **`U30USD`** e **`NASUSD`** siano **entrambi** visibili.
2. Apri un grafico **U30USD** su un timeframe qualsiasi, lascialo caricare, poi
   **puoi anche chiuderlo**: serve a far scaricare lo storico del metro.
3. **File → Nuovo grafico → `NASUSD`** → imposta timeframe **M5**.

✅ **VERIFICA PRIMA DEL PASSO 5:** il grafico dice **NASUSD, M5**, e `U30USD` e'
presente in Market Watch con bid/ask che si muovono.

---

## PASSO 5 — 🧷 ATTACCARE L'EA E CARICARE IL PRESET

1. Dal **Navigatore → Consulenti Esperti**, trascina **`ABTG_Relativo`** sul
   grafico **NASUSD M5**.
2. Nella finestra che si apre: scheda **Parametri di input** → pulsante **Carica** →
   scegli **`ABTG_Relativo_NASUSD_DEMO.set`**.
3. Scheda **Comune** → spunta **Consenti trading algoritmico**.
4. **PRIMA di premere OK**, controlla a schermo questi **8 valori firma** (il
   controllo campo-per-campo ha gia' beccato 5 errori su 5 deploy):

| campo | deve leggere |
|---|---|
| `InpMagic` | **774690** |
| `InpSimboloMetro` | **U30USD** |
| `InpRiskPercent` | **0.65** |
| `InpFinestraN` | **40** |
| `InpSogliaIngressoSigma` | **1.35** |
| `InpAtrSL` | **2.75** |
| `InpMaxTradesPerDay` | **5** |
| `InpOraInizioServer` / `InpMinInizioServer` | **14** / **30** _(ora SERVER = 15:30 italiane)_ |

5. **OK.** Poi **screenshot** della finestra parametri e mandamelo.

✅ **VERIFICA PRIMA DEL PASSO 6:** in alto a destra sul grafico c'e' la faccina
**sorridente** accanto a `ABTG_Relativo`. Se e' triste ❌ o c'e' una **X**,
l'algo trading e' spento (globale o della finestra) → **non proseguire**.

---

## PASSO 6 — 🔍 VERIFICARE NEL LOG CHE SI SIA **ARMATO**

Scheda **Esperti**, in basso nel terminale del piccolo. Cerca **questa riga**:

```
[RELATIVO_DEMO] avviato su NASUSD PERIOD_M5 | metro U30USD | cella N=40 sigma=1.35 | SL 2.75 x ATR | rischio 0.65% | tetto 5/giorno | magic 774690
```

✅ **LA SEDIA E' ARMATA SOLO SE QUESTA RIGA C'E'** — ed e' l'ultima riga stampata
da `OnInit` (riga 1960 di `ABTG_Relativo.mq5`): se compare, **tutti i controlli
di validita' sono passati**.

Come si legge, pezzo per pezzo:
- `[RELATIVO_DEMO]` → il preset **e' stato caricato** (col default sarebbe `[RELATIVO]`);
- `NASUSD PERIOD_M5` → simbolo e timeframe giusti;
- `metro U30USD` → il secondo simbolo e' agganciato;
- `magic 774690` → **il magic nuovo**, non uno di round.

❌ **Se invece leggi una riga che comincia con `ERRORE:`**, l'EA **non e' partito**.
Le tre piu' probabili:
| riga di log | cosa vuol dire |
|---|---|
| `ERRORE: il simbolo METRO 'U30USD' non e' selezionabile` | torna al **PASSO 4**: metro non in Market Watch / storico assente |
| `ERRORE: InpSimboloMetro deve essere un simbolo DIVERSO...` | hai attaccato l'EA su un grafico **U30USD** invece che NASUSD |
| `ERRORE: InpRiskPercent deve stare fra 0 (escluso) e 5,0%` | il preset non e' stato caricato |

⚠️ **E ricordati in quale ora e' scritto quel numero** (lezione del 06/08): la
scheda **Esperti** stampa l'**ora locale del PC** (= ora italiana), il **grafico**
e' in **ora server** (= italiana − 1). Non sono in ritardo di un'ora: sono due
orologi diversi.

---

## PASSO 7 — ⏱️ COSA ASPETTARSI, E QUANDO

| quando | cosa |
|---|---|
| stesso giorno, **14:30 server** (15:30 italiane) | si apre la finestra operativa |
| **22:00 server** (23:00 italiane) | flat di fine sessione: la posizione si chiude |
| in media | **~0,525 operazioni al giorno feriale ≈ 11 al mese** |
| **02/11/2026** | ~20 operazioni |
| **08/03/2027** | 🔧 **TAGLIANDO** (~68 operazioni) |
| **13/10/2027** | 🎯 traguardo **n = 150** |

📄 L'EA scrive anche un CSV riga-per-operazione:
`<DATI_PICCOLO>\MQL5\Files\Operazioni_ABTG_Relativo_NASUSD.csv` — utile al
tagliando, **non serve toccarlo prima**.

🔴 **E i cancelli che spengono prima del tempo** (dettaglio in
`report/CORSIA_DEMO_RELATIVO_NASUSD.md`): DD oltre **8,40%**, una giornata
peggiore di **−4,0%**, piu' di **5 operazioni in un giorno**, o operazioni su un
simbolo che non sia NASUSD. **Il Guardian su questo conto NON c'e'**: non
mettera' in pausa niente, quindi la lettura del DD e' a mano.

---

## 🛑 QUATTRO COSE CHE QUESTA PROCEDURA **NON** FA

1. **Non tocca nessuna sedia in forward**, nessun preset esistente, nessun magic
   gia' in uso.
2. **Non tocca il conto 100k 50504263 ne' il REALE 10105439.**
3. **Non lancia nessun backtest.**
4. **Non promuove niente.** La corsia demo **non e' una porta verso il conto
   reale**: alla fine produce un numero, e il passaggio ai soldi veri resta una
   firma di Claudio su una misura.
