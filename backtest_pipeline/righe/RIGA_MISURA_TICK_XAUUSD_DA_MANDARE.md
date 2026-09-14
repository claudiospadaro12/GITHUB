# 🥇 MISURA PROFONDITA' TICK REALI — XAUUSD @ BCM — DA MANDARE (prerequisito Part2, 14/09/2026)

**Che cos'è.** La STESSA misura già fatta per NASUSD (20/08) e U30USD (20/08),
`RIGA_MISURA_TICK_NASUSD_DA_MANDARE.md`, ORA ESTESA all'oro. **ZERO codice
nuovo**: `RIGA_MISURA_TICK_NASUSD.ps1` ha già `-Simbolo` come parametro
generico (default `"NASUSD"`, sovrascrivibile), e pilota `scarica_storico.ps1`
+ `ABTG_HistoryDownloader.mq5`, che nella propria intestazione elenca **già**
`XAUUSD` come esempio di simbolo valido (`InpSimboli`: `"D30EUR,NASUSD,XAUUSD,
EURUSD,GBPUSD"`). **Cambia solo l'argomento `-Simbolo`.**

**Perché esiste, e da dove viene la riga esatta.**
`report/SONDA_TICK_ORO_ATTENZIONE.md` (07/09, richiesta di Claudio la notte
dell'07/09: *"metti la sonda tick dell'oro in cima alla coda di domani"*)
aveva **già scritto** la riga esatta da lanciare:
`-Simboli 'XAUUSD' -Da '2022.01.01' -Timeframes 'M1,M5' -TimeoutMin 240 -Auto`
— ma quella sonda non ha ancora un foglio DA_MANDARE pronto con blocco
copia-incolla, verifica del marcatore e raccolta automatica sul Desktop
(REGOLA DELLE RIGHE DI LANCIO, 10/08). Questo file la chiude.

**Colonna che decide:** la PRIMA data VERA dei tick di XAUUSD + il conteggio.
Serve a rispondere alla domanda che blocca `R148a_cycle_verso_NASUSD.txt`
(sezione "BUCHI DICHIARATI") e `report/ORO_1530_CANCELLO_COSTO_2026-09-10.md`
par. 9: la profondità a TICK di XAUUSD è **[NON MISURATO]**
(`risultati_archivio/misura_tick/` contiene SOLO D30EUR, NASUSD, U30USD).

**Non tocca il forward. Non promuove niente. Non ottimizza niente.**

---

## 🛑 SU QUALE MACCHINA — dichiarato per intero, non per abitudine

Il commento di testa di `RIGA_MISURA_TICK_NASUSD.ps1` dice ancora, testuale:
*"SI LANCIA SOLO SUL PC DI BACKTEST — MAI SUL VPS"*, perché passa `-Auto` a
`scarica_storico.ps1`, che apre e chiude MT5 da solo.

🔎 **Ma letto `scarica_storico.ps1` riga per riga il 14/09** (non per
abitudine, per la regola del contro-esempio di CLAUDE.md), quello script è
stato **riparato il 12/09**: SENZA `-TerminaleBacktest` esplicito, ora
**preferisce da solo il banco `C:\MT5_Backtest`** (demo **50504400**, zero EA
attaccati) se quella cartella esiste sulla macchina, e **muore** (non ripiega
su Program Files) se non la trova — la chiusura finale filtra per quel
percorso, quindi sui VPS con QUATTRO terminali BCM la chiusura tocca **solo**
quello sotto `C:\MT5_Backtest`, mai gli altri tre (righe ~200-330 e ~480-500
di `scarica_storico.ps1`, verificate il 14/09).

👉 **Quindi, ad oggi (14/09), questa sonda è PROBABILMENTE sicura anche sul
quarto terminale del VPS (50504400)** — non solo sul PC di backtest separato —
perché la riparazione di `scarica_storico.ps1` è successiva e più ampia della
frase di testa del wrapper, che non è stata aggiornata per dirlo.
🔴 **MA questo è un "probabilmente" scritto da chi non ha MT5 per verificarlo
empiricamente, non un "sicuro"**: il doppio cancello
(`controlla_riga.py` + `controllo-preventivo`) deve confermarlo PRIMA che
qualunque riga con `-Auto` giri sul VPS. Finché non lo confirma, il bersaglio
da dichiarare resta quello a zero ambiguità:

> 🖥️ **finestra PowerShell sul PC di backtest** (la macchina separata di
> sempre, senza nessun terminale vivo da proteggere) — bersaglio primario.
> 🪟 **in alternativa, dopo il PASS del doppio cancello**: `50504400`
> (`C:\MT5_Backtest`) sul VPS — e in quel caso NON si tocca nessuno dei tre
> terminali vivi (`50503392`, `50504263`, `10105439`).

---

## ▶️ LA CORSA (blocco intero, un comando solo)

`e9b47a9d62f732646a2b4f191a20b564cd90bbc7` = l'ultimo commit che tocca
`RIGA_MISURA_TICK_NASUSD.ps1` (script generico, invariato da oggi: la modifica
additiva di `ABTG_Cycle.mq5` per `R148g` NON lo tocca, quindi non serve un
giro di pin nuovo per questa sonda). Verificato: `git cat-file -e` OK, e a
quel commit il file porta il marcatore `MARCATORE_RIGA_MISURA_TICK_NASUSD_v1`.
Riga IDENTICA nella forma al blocco NASUSD/U30USD già verificato, **solo
`-Simbolo XAUUSD`** in più e `-Da`/`-Timeframes` presi dalla riga già scritta
in `SONDA_TICK_ORO_ATTENZIONE.md`.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='e9b47a9d62f732646a2b4f191a20b564cd90bbc7'; $p="$env:USERPROFILE\RIGA_MISURA_TICK_NASUSD.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_MISURA_TICK_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_MISURA_TICK_NASUSD_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore MISURA_TICK_NASUSD.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -Simbolo 'XAUUSD' -Da '2022.01.01' -Timeframes 'M1,M5' -TimeoutMin 240; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - leggi il REFERTO sul Desktop' } }
```

> 🔴 **GLI APICI SONO OBBLIGATORI su `-Timeframes 'M1,M5'`** (classe 65, già
> pagata il 07/09 su questa stessa sonda): senza apici PowerShell lega `M1,M5`
> come array e allo script arriva `"M1 M5"` con lo spazio — il `.mq5` splitta
> SOLO sulla virgola, zero timeframe riconosciuti, zero righe di barre nel
> CSV, MA la riga TICK (che sta fuori dal ciclo dei timeframe) si scrive lo
> stesso e il referto esce VERDE su una misura mai fatta. Il blocco sopra li
> ha già.
> ⏱️ **`-Da 2022.01.01`** (non `2024.09.26` come NASUSD): qui NON si conosce
> ancora dove comincia lo storico vero di XAUUSD, quindi si parte da una data
> larga per LASCIARE che la misura la trovi, invece di assumerla. Il muro
> vero (`REFERTO_MISURA_TICK_XAUUSD.txt`, riga "PRIMA DATA VERA") è l'OUTPUT
> di questa sonda, non un suo input.

---

## 📤 Cosa arriva sul Desktop

- Cartella `MISURA_TICK_XAUUSD_<data>` con:
  - **`REFERTO_MISURA_TICK_XAUUSD.txt`** — prima data tick + conteggio + muro
    barre M1/M5, stesso formato del referto NASUSD/U30USD.
  - **`misura_tick_XAUUSD.csv`** — il CSV grezzo (righe M1, M5, TICK).
  - gli ultimi log di MT5, se prodotti.
- Zip `MISURA_TICK_XAUUSD_<data>.zip` pronto da mandare.

## 🔢 Codici d'uscita
- `0` → misura completa: c'è la riga **TICK** e la corsa è finita bene.
- `2` → PARZIALE: manca la riga TICK, o `scarica_storico.ps1` è uscito ≠ 0.
  Il referto e lo zip ci sono lo stesso.
- `1` → fermato prima su pin non valido o scarico fallito.

## 👉 E DOPO, in ordine

1. Questa sonda (tick depth) **PRIMA**.
2. `RIGA_SPREAD_FLOTTA_XAUUSD_DA_MANDARE.md` **DOPO**, con `-Da`/`-A` corretti
   sulla finestra che questa sonda ha appena confermato (non sulla finestra
   NASUSD presa a prestito).
3. Con le due sonde in mano, il cancello del costo (stop ≥ 40× lo spread
   mediano dell'ORA giusta, ≥ 13,3× duro) si può finalmente **dichiarare**
   per XAUUSD su qualunque TF risulti valido — chiudendo il "BUCO DICHIARATO"
   di `R148a_cycle_verso_NASUSD.txt` e sbloccando un verdetto vero (non solo
   screening) sul candidato che Claudio ha chiesto di testare: minimo locale
   su XAUUSD M1, con l'uscita a tempo (N=5/10 barre) che lui stesso ha
   riportato come praticata a mano.
