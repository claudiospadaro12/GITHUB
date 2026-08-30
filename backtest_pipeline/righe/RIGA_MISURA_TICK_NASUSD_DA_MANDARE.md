# 📏 MISURA PROFONDITA' TICK REALI — NASUSD @ BCM — DA MANDARE

**Che cos'è.** Una **MISURA**, non un test. Va a leggere **fin dove BCM ha i
TICK REALI** di `NASUSD` e **quanti** sono. Serve a **validare o smentire** i
numeri della **cassaforte FASE 2**: a **Model 4** (Ogni tick basato su tick
reali) MT5 **non si ferma** se i tick veri mancano — **ripiega su tick
plausibili-ma-falsi** generati dalle barre. La profondità tick di NASUSD **non è
mai stata misurata**. Questa riga la misura.

**Non tocca il forward. Non promuove niente. Non ottimizza niente.**

## 🎯 La colonna che decide
La **prima data VERA dei tick** + il **conteggio**.
- ✅ **Esito atteso (ipotesi, DA CONFERMARE):** come **U30USD** (Dow, 20/08 →
  `REFERTO_MISURA_TICK_U30USD.txt`: tick reali dal **2024.09.26**, 67,6 M tick,
  PARZIALI). Se NASUSD fa lo stesso → la finestra cassaforte **2024.09.26 → 2026**
  è coperta da **tick VERI** e i suoi numeri **reggono**.
- ⚠️ **Se i tick partono DOPO, o sono pochi/assenti** → a Model 4 MT5 ha usato
  **tick FINTI** e la cassaforte va **RILETTA o RIFATTA**.

---

## 🛑🛑🛑 SI LANCIA **SOLO SUL PC DI BACKTEST — MAI SUL VPS** 🛑🛑🛑

> Questa riga passa **`-Auto`** a `scarica_storico.ps1`, che **APRE e CHIUDE MT5
> da solo**. Sul **VPS** chiuderebbe il terminale che tiene su la **FLOTTA IN
> FORWARD**: **spegneresti gli EA veri.** La regola è già scritta in testa a
> `scarica_storico.ps1` (riga ~36). **Sul PC di backtest, con MT5 CHIUSO.**
> (Se lo trova aperto, `scarica_storico.ps1` **esce 1 e lo dice** — non lo ammazza:
> è la rete che protegge il forward.)

---

## ▶️ LA CORSA (blocco intero, un comando solo)

`<PIN>` = l'hash del commit che contiene QUESTO pacchetto. Il blocco riscarica
lo script **dal pin**, verifica il **marcatore** (niente copie vecchie), poi
lancia la **stessa identica riga** che ha funzionato sul Dow:
`-Simboli NASUSD -Da 2022.01.01 -Timeframes M1,M5 -TimeoutMin 240 -Auto`.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_MISURA_TICK_NASUSD.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_MISURA_TICK_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_MISURA_TICK_NASUSD_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore MISURA_TICK_NASUSD.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - leggi il REFERTO sul Desktop' } }
```

> La **fase tick** può tenere il CSV **fermo per parecchio** (anche minuti/ore):
> è **NORMALE**, `scarica_storico.ps1` ha già il difetto pagato del "CSV non
> cresce per ore". Lascialo finire fino a `TimeoutMin=240`.

---

## 📤 Cosa arriva sul Desktop
- Cartella `MISURA_TICK_NASUSD_<data>` con:
  - **`REFERTO_MISURA_TICK_NASUSD.txt`** — la prima data tick + il conteggio + il
    muro barre M1, nello **stesso formato** del referto U30USD.
  - **`misura_tick_NASUSD.csv`** — il CSV grezzo (righe M1, M5, TICK).
  - gli ultimi **log di MT5** (`*.log`), se prodotti.
- Zip **`MISURA_TICK_NASUSD_<data>.zip`** pronto da mandare.

## 🔢 Codici d'uscita
- `0` → **misura completa**: c'è la riga **TICK** e la corsa è finita bene.
- `2` → **PARZIALE**: manca la riga TICK, o `scarica_storico.ps1` è uscito ≠ 0
  (2 = timeout/parziale). **Il referto e lo zip ci sono lo stesso** — leggere il
  referto prima di leggere qualunque numero.
- `1` → fermato prima su **pin non valido** o **scarico fallito**.
