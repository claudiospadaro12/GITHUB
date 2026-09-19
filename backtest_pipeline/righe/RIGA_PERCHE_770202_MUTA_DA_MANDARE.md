# 🔇 PERCHE' `770202` E' MUTA — la riga che toglie il troncamento — DA MANDARE

## 🖥️ BERSAGLIO: **finestra PowerShell sul VPS**
**Nessun MT5 da aprire, nessun EA da trascinare, nessun grafico da toccare.**
La riga **LEGGE** i file di log (`MQL5\Logs\*.log`) di **tutte** le cartelle dati
presenti sul VPS e **STAMPA**.

🔴 **Che cosa NON viene toccato** (sul VPS convivono SEI cartelle dati):
- ❌ **50503392** `C:\Program Files\BCM Markets MT5 Terminal` (piccolo) — solo letto
- ❌ **50504263** `C:\Program Files\BCM Markets MT5 Terminal -V3` (100k) — solo letto
- ❌ **10105439** `C:\BCM_Reale` — 🔴 **conto REALE: solo letto, mai toccato**
- ❌ **50504400** `C:\MT5_Backtest` — solo letto
- ❌ Pepperstone e Tickmill — solo letti
La riga **non apre, non chiude, non compila, non attacca, non stacca** niente.
Non manda ordini, non modifica preset, non tocca il forward.

---

## ❓ A che domanda risponde, e a una sola
**Dal 28/08/2026 la sedia `770202` (`ABTG_Dow_Apertura_US`, U30USD M5) non apre
piu' niente.** Dai referti notturni e' gia' **misurato** che la sedia **e' viva e
arma ogni seduta**: scrive `RETEST armato` alle **16:05 locali = 15:05 server**,
che e' esattamente `14:30 + 35 minuti di range` — **l'ora giusta**.

Dopo l'armamento **non manda nessun ordine**. Le strade possibili sono **tre**, e
il numero che le distingue (`bias`) sta **dentro la stessa riga di log**, ma
**dopo il carattere 110**, dove il referto notturno `CODA_02` taglia.

| | cosa dice il log | causa | cosa si cambia dopo |
|---|---|---|---|
| **A** | `bias -1` o `bias 2` | il filtro **EMA H4** tiene chiuso il lato LONG, e `InpAllowShort=false` chiude l'altro | il **lato**, o il filtro — e si paga in PF/DD (numeri gia' misurati) |
| **B** | `bias 0`/`+1` **e** compare `BUY LIMIT (retest)` | ordine piazzato e **scaduto non eseguito** (offset **400 pt** dentro il livello, scadenza 120 min) | l'**offset del retest**: e' il "costo del metodo" scritto nel codice |
| **C** | `bias 0`/`+1` **e nessun** `BUY LIMIT` | **rottura mai avvenuta**: mercato | **niente**: la sedia sta facendo il suo mestiere |

🟢 **Nessuna delle tre e' un guasto.** Questa riga non serve a capire se la sedia
e' rotta (e' gia' misurato che non lo e'): serve a sapere **su quale manopola
vale la pena spendere una corsa di backtest**.

---

## 🛠️ E ripara un difetto dello strumento — **classe 466**
`CODA_02_chi_ha_operato.ps1` ordina i log **dal piu' recente al piu' vecchio**
(r.38 `Sort-Object LastWriteTime -Descending`) e poi, dentro il ciclo,
**sovrascrive** `$ultima[$k]` (r.52). Il valore che sopravvive e' quello del file
**PIU' VECCHIO** dei tre. 👉 **La colonna "ultima riga" e' l'ultima riga di DUE
GIORNI FA.** Qui i file si leggono in **ordine crescente di nome** e **ogni riga
esce con la sua data davanti**, presa dal nome del file.

---

## ▶️ LA CORSA (un comando solo)

`<PIN>` = l'hash del **commit** che contiene questo pacchetto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_PERCHE_770202_MUTA.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PERCHE_770202_MUTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PERCHE_770202_MUTA_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore PERCHE_770202_MUTA.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Giorni 25; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - leggi il REFERTO sul Desktop' } }
```

Dura **secondi**: legge file di testo, non tick.

---

## 📤 Cosa arriva sul Desktop del VPS
- Cartella `PERCHE_770202_MUTA_<data>` con **`REFERTO_770202_MUTA.txt`** — tutte
  le righe **INTERE**, una per riga, con **la data davanti** e la cartella dati
  + il **numero di conto letto dal giornale** in testa a ogni blocco.
- Zip **`PERCHE_770202_MUTA_<data>.zip`** pronto da mandare.

**File attesi, da verificare in console** (la riga li elenca da sola):
1. `...\Desktop\PERCHE_770202_MUTA_<data>\REFERTO_770202_MUTA.txt`
2. `...\Desktop\PERCHE_770202_MUTA_<data>.zip`

## 🔢 Codici d'uscita
- `0` → trovate righe `RETEST armato`: il referto ha la risposta.
- `2` → **PARZIALE**: nessun `RETEST armato` nella finestra di log letta (log
  ruotati o cancellati). Il referto e lo zip ci sono lo stesso.
- `1` → nessuna cartella `MetaQuotes\Terminal`.

## ⚠️ I limiti, dichiarati prima dei numeri
1. **Scheda Esperti = ORA LOCALE del VPS. Grafico = ORA SERVER = locale meno 1.**
   Le `16:05` locali sono le **15:05 server**.
2. Un EA che non stampa non vuol dire che non opera — ma `770202` ha
   `InpVerbose=true`, quindi **stampa**.
3. Se MT5 ha **ruotato o cancellato** i log vecchi, i giorni mancanti **mancano**:
   la riga lo dice e non li inventa.
