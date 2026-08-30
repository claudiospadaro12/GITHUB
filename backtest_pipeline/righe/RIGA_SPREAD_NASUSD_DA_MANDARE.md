# 💸 MISURA SPREAD REALE — NASUSD dai TICK STORICI — DA MANDARE

**Che cos'è.** Una **MISURA**, non un test. Va a leggere i **166M tick reali**
di `NASUSD` gia' sul disco (dal 2024.09.26) e calcola **due cose**:

1. 🚦 **LA RIGA CHE DECIDE — BID/ASK.** Per ogni tick controlla se ha un **ASK
   valido** (flag `TICK_FLAG_ASK`, oppure `ask>0 && ask>=bid`). Stampa la **%
   con ask valido** vs **% solo-bid**.
2. 📊 **Distribuzione dello SPREAD** (solo tick con ask valido, durante la
   **seduta 14:30–21:00 ORA SERVER BCM**): **mediana, P90, P95, max** in
   **PUNTI INDICE** (`spread_MT5 / 100`; R97: 1 pto indice = 100 pti MT5).

**Perché serve.** La cassaforte **FASE 2** (long **PF 1.083**) è un edge
**SOTTILE**. Girava con **`Spread=0`** nell'`.ini` a **Model 4** (Ogni tick su
tick reali). Ma Model 4 usa lo spread VERO **solo se i tick portano BID *E*
ASK**. Se i tick NASUSD sono **SOLO-BID**, allora `Spread=0` = **spread ZERO** =
il **PF 1.083 è OTTIMISTA**. Questa riga lo verifica o lo smentisce.

**Non tocca il forward. Non promuove niente. Non ottimizza niente. Non committa.**

---

## 🎯 Come si legge (criteri congelati, gia' scritti nel referto)
- ✅ **ASK valido su ~tutti i tick E mediana bassa (1–2 pti indice)** → la
  cassaforte a `Spread=0` **ha usato spread reale**, **PF 1.083 è ONESTO**, e lo
  spread **NON è il collo di bottiglia**.
- ⚠️ **MOLTI tick SOLO-BID** (soglia prudente ≥5%) → **PF 1.083 è OTTIMISTA**:
  la corsa cassaforte va **RIFATTA imponendo `Spread = P95` misurato**.
- 🚪 **Cancello S0:** la **mediana take LORDO** del motore (dal per-trade
  cassaforte) deve essere **≥ ~3–4× lo spread mediano**. Soglia dichiarata; il
  take lo confrontiamo **dopo**, con il numero misurato alla mano.

---

## 🛑🛑🛑 SI LANCIA **SOLO SUL PC DI BACKTEST — MAI SUL VPS** 🛑🛑🛑

> Questa riga **APRE e CHIUDE MT5 da sola** (StartUp Script via `.ini`). Sul
> **VPS** chiuderebbe il terminale che tiene su la **FLOTTA IN FORWARD**:
> **spegneresti gli EA veri.** Se trova MT5 **già APERTO**, **ESCE 1 e lo dice**
> (non lo ammazza) — a meno di `-ChiudiMT5` esplicito. **Sul PC di backtest, con
> MT5 CHIUSO.**

---

## ▶️ LA CORSA (blocco intero, un comando solo)

`<PIN>` = l'hash del commit che contiene QUESTO pacchetto. Il blocco riscarica
la riga **dal pin**, verifica il **marcatore** (niente copie vecchie), poi la
riga scarica **anche il motore** `ABTG_SpreadTick.mq5` dal pin, lo **compila**,
e legge i tick sulla finestra `2024.09.26 → 2026.06.30`.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_SPREAD_NASUSD.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_SPREAD_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_SPREAD_NASUSD_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore SPREAD_NASUSD.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE - leggi il REFERTO sul Desktop' } }
```

> La lettura di **166M tick** può richiedere **parecchi minuti**: è **NORMALE**,
> lascialo finire fino a `TimeoutMin=180`. Se una corsa piena è troppo lunga sul
> tuo PC, restringi la finestra passando `-Da`/`-A` (es. un trimestre
> rappresentativo) — è la leva di campionamento **dichiarata** (mediana/P95
> restano stabili se la finestra è rappresentativa).

---

## 📤 Cosa arriva sul Desktop
- Cartella `SPREAD_NASUSD_<data>` con:
  - **`REFERTO_SPREAD_NASUSD.txt`** — la **riga BID/ASK in cima** (quella che
    decide), poi la distribuzione spread in punti indice.
  - **`spread_tick_NASUSD.csv`** — le stesse misure in forma tabellare.
  - gli ultimi **log di MT5** (`*.log`), se prodotti.
- Zip **`SPREAD_NASUSD_<data>.zip`** pronto da mandare.

## 🔢 Codici d'uscita
- `0` → **misura completa**: referto txt + CSV **freschi**, corsa finita bene.
- `2` → **PARZIALE**: manca un output fresco, o è scaduto il timeout. **Il
  referto e lo zip ci sono lo stesso** (se prodotti) — leggere il referto prima
  di qualunque numero.
- `1` → fermato prima: **pin non valido**, terminale/compilazione, o **MT5 già
  APERTO** (rete che protegge il forward).
