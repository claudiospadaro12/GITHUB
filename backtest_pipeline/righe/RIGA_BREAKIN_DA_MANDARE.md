# 📬 BREAKIN BOX — **ABLAZIONE A/B: LA RIGA DA MANDARE** (la prova che decide)

**Che cos'è:** il primo giro sul banco di **`ABTG_BreakinBox`** (EA **NUOVO, MAI
COMPILATO** — la compilazione avviene nel giro a vuoto e **se fallisce, QUELLO è
il risultato del passo**). Motore: **falsa rottura del box notturno
23:00–04:59 SERVER** (lo **stesso identico box** della sedia viva 770411, che
invece opera il breakout: mutuamente esclusivi per costruzione), ingresso
**DIFFERITO** su conferma nella sessione europea, su **D30EUR M15 a TICK REALI
(Modello 4)**, 2024.09.26 → 2026.06.30. **DUE GAMBE in sequenza**, e da sole
non decidono niente:

| Gamba | File prova | La riga che cambia | Magic gemelli |
|---|---|---|---|
| **A — LA TESI** | `prove/ABTG_BreakinBox.txt` | `InpTP_RR=0.0` → TP al **LATO OPPOSTO DEL BOX** | 769701/769702 |
| **B — IL CONTROLLO** | `prove/ABTG_BreakinBox_RRFISSO.txt` | `InpTP_RR=2.0` → TP a **RR FISSO** (= geometria R95, 0/30) | 769711/769712 |

> ⚖️ **L'ABLAZIONE È IL ROUND** (criteri congelati nei prova PRIMA dei numeri):
> **vince A** → la tesi regge (l'edge sta nella **taglia del take** e nella
> **durata**); **VINCE B → il motore è R95 TRAVESTITO (un livello nuovo sulla
> stessa geometria morta) e IL CAPITOLO SI CHIUDE LÌ** — niente caccia a "un RR
> migliore" (Regola della Seconda Caccia, 19/08); **indistinguibili** → il TP
> non è la variabile che conta, il candidato torna in coda. La riga **verifica
> MECCANICAMENTE** che i due prova differiscano **SOLO** per `InpTP_RR` e
> `InpMagic`: se differiscono altrove, si ferma prima di aprire MT5.

> 🕒 **FUSO DI CASA (non invertito):** D30EUR BCM = ora **SERVER** (IT−1) →
> box **23:00–04:59**, operativa **08:00–17:30**, flat 17:30 (l'ora della
> sedia 770411). Il gate **PRETENDE `InpBoxStartHour=23` e RIFIUTA il 22**
> (la vecchia deduzione sbagliata dal PDF, PAG 26/28) e **rifiuta il 9**
> (l'ora italiana dell'apertura). Pavimento SL: `InpMinStopPts=500`, lo 0 è
> VIETATO (R109).

> 📐 **CONVERSIONE D30EUR [NON MISURATA]:** il 100 di `InpMT5PerPuntoIndice` è
> il fattore R97 di NASUSD/U30USD, **mai misurato sul DAX**. Tocca SOLO la
> colonna `take_idx_pts` (mai i trade). La riga misura da sola, dal per-trade
> del round, **digits dei prezzi + mediana dei movimenti** (pattern R97) e li
> scrive nel referto: il cancello C2 (take mediano ≥ 6,0 punti indice) si
> legge **DOPO** quella verifica, riscalando se serve — senza rifare la corsa.

> 🌙 **Zero overnight, misurato non promesso:** il box è notturno ma
> l'**operatività è diurna** — chiusura tardiva **in giornata** = regolare
> (flat di recupero al primo tick); chiusura a **giorno successivo** =
> overnight VERO, e sopra il **5%** il file è INVALIDO. La riga confronta
> `open_time` e `close_time` da sola (riga "overnight veri" nel referto).

| | |
|---|---|
| **Driver** | `righe/RIGA_BREAKIN.ps1` (marcatore `MARCATORE_RIGA_BREAKIN_v2`) |
| **File prova** | `prove/ABTG_BreakinBox.txt` (gamba A) + `prove/ABTG_BreakinBox_RRFISSO.txt` (gamba B) |

**MT5 e MetaEditor CHIUSI. PC di backtest, non VPS.**
⏱️ **4 passate a tick** (2 gemelle per gamba — celle CONTATE nei prova:
`InpMagic` a step 1 su due valori = 2 celle a gamba) su ~21 mesi di D30EUR
M15. Metro: la griglia 48 di NYRETEST (stesso banco tick, M15 su indice) fece
48 celle in ~1–4 ore, cioè **~2–5 min a passata** → stima onesta **10–40
minuti** più le compilazioni. Il giro a vuoto è questione di minuti (ma
COMPILA: è lì che un EA mai compilato può cadere, ed è un risultato).

## 📌 IL PIN — **`<PIN>`**  ⛔ DA INSERIRE DOPO IL PUSH (commit di 40 caratteri esadecimali del branch `lavoro`)

## 1️⃣ Giro a vuoto

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_BREAKIN.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_BREAKIN.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_BREAKIN_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

## 2️⃣ Corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_BREAKIN.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_BREAKIN.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_BREAKIN_v2' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo' -ForegroundColor Yellow } }
```

## 📦 COSA TORNA
Zip sul Desktop **`BREAKIN_CORSA_...zip`** → `REFERTO_BREAKIN.txt` + i 2 prova
+ **2 griglie gemelli** (`ABTG_BreakinBox_D30EUR_IS_gambaA.csv` e
`..._IS_gambaB.csv`, **2 righe l'una**, coi contatori OPTFRAME: Breach
Alto/Basso, Armamenti Scaduti, Tp Degenere, Peggior Giornata %, Autotest
Falliti…) + **4 per-trade**
(`abtg_trades_ABTG_BreakinBox_D30EUR_769701/769702/769711/769712.csv`).
**Mandami lo zip `BREAKIN_CORSA_...` — quello `BREAKIN_CONTROLLO_...` del giro
a vuoto NON è il risultato** (serve solo se il controllo si è fermato).

## 🔎 COME SI LEGGE
🕐 **PRIMA DI TUTTO** apri `REFERTO_BREAKIN.txt` e controlla:
- riga **`data:`** = l'ora di adesso (referto stantio = giro vecchio);
- riga **`modo:`** = **CORSA** (il giro a vuoto non è il risultato);
- riga **`compilazione:`** = OK — è un EA nuovo: se è FALLITA, quello È il
  risultato del passo (gli errori sono in `COMPILAZIONE_FALLITA.log` nello zip);
- riga **`ablazione:`** = VALIDA (le righe vive differiscono SOLO per
  `InpTP_RR` e `InpMagic`);
- righe **`gemelli`** = IDENTICI per tutte e due le gambe, e **`OPERAZIONI per
  magic`** uguali dentro ogni gamba (banco deterministico);
- riga **`overnight veri`** ≤ 5% per gamba; **`autotest`** = 0 (PASSATI).

📊 Poi la **tabella delle due gambe fianco a fianco** (n, PF, DD, peggior
giornata) e la **lettura dell'ablazione** coi tre esiti congelati: vince A /
**vince B = R95 travestito, capitolo chiuso** / indistinguibili = in coda.
Confronto **per-trade/risk-adjusted, MAI profitto totale**. Poi la **nota
conversione D30EUR**: digits + mediane misurate dal per-trade — **C2 si legge
solo dopo quella verifica**. Gli altri cancelli (frequenza ≥150/lato sui
contatori, DD ≤ 15%, peggior giornata > −5%, lati letti SEPARATI dalla colonna
`dir`) stanno congelati in testa a `prove/ABTG_BreakinBox.txt`: si leggono
PRIMA dei numeri e non si spostano dopo.

🛑 **Promemoria:** 21 mesi = UN SOLO REGIME (toro): il MERITO è provvisorio per
costruzione, il RISCHIO vale pieno (Emendamento della Finestra, regola B).
Nessuna promozione esce da questo round da solo.

## 🔴 AVVISO ROSSO ATTESO
Il generico stamperà rosso sui CSV **`*_OOS`** (due volte, una per gamba): con
FrazioneIS 1.0 la gamba OOS è **degenere (0 giorni)** per costruzione. È
**atteso**: NON rilanciare, non è un errore. Fa fede l'`ESITO:` finale della
riga (verde CORSA COMPLETATO oppure giallo/rosso coi PROBLEMI elencati nel
referto).

> 🧊 Nel referto controlla anche la riga **`cache tester:`** (svuotata, coi
> conteggi) e ricorda: questo lancio è **MISURA + ABLAZIONE, non il verdetto**
> — PF OOS e centro-altopiano appartengono al round di griglia successivo.
