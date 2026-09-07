# R119 — IL RITARDO DEL TESTER SULLE DUE SEDIE VIVE

- **Pin della riga:** `7357f4631cdb8b789a58a0a9b8177c65702438af`
- **Marcatore riga:** `MARCATORE_RIGA_RITARDO_TESTER_v1`
- **Marcatore driver:** `MARCATORE_WALKFORWARD_GENERICO_v2_RITARDO`
- **Contratto:** `backtest_pipeline/prove/RITARDO_TESTER_R119.txt`
- **Celle congelate:** `prove/ABTG_DAX_Apertura_EU_RITARDO.txt`, `prove/ABTG_ORB_Ottimizzato_RITARDO.txt`

## 🖥️ DOVE GIRA — dichiarato, come da regola dei terminali multipli

**PC DI BACKTEST. NON il VPS.** Sul VPS non si tocca niente.
Il terminale che il driver userà è quello BCM di backtest — **conto DEMO
50503392**, cartella `C:\Program Files\BCM Markets MT5 Terminal`. Il driver
lo sceglie da solo ed **esclude** il `-V3` (100k 50504263) e `C:\BCM_Reale`
(reale 10105439): quel controllo è codice, chiuso il 07/09 (classe 37-quater).

**MT5 dev'essere CHIUSO** prima di lanciare (il driver apre il terminale con
`/config:`). Se è aperto la riga si ferma e stampa i PID.

## ⚠️ Cosa NON fa
Non apre ordini, non installa preset, non tocca nessuna sedia viva, non
cambia nessun parametro. Gli `.ini` hanno `AllowLiveTrading=false`.

---

## BLOCCO 1 — GIRO A VUOTO (30 secondi, MT5 non si apre)

```powershell
$ProgressPreference='SilentlyContinue'; $u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7357f4631cdb8b789a58a0a9b8177c65702438af/backtest_pipeline/righe/RIGA_RITARDO_TESTER.ps1'; $f="$env:TEMP\RIGA_RITARDO_TESTER.ps1"; irm ($u+'?cb='+[guid]::NewGuid().ToString('N')) -OutFile $f; & { powershell -NoProfile -ExecutionPolicy Bypass -File $f -SoloControllo }
```

**Da guardare in console, due cose:**
1. per **tutte e due** le sedie il conto delle celle deve dire **2**;
2. nell'anteprima dell'`.ini` ci dev'essere la riga **`Delay=100`**.
   Se quella riga non c'è, il driver è una copia vecchia e il round girerebbe
   **senza ritardo dicendo di averlo messo**.

## BLOCCO 2 — LA CORSA VERA (8 corse a tick reali)

```powershell
$ProgressPreference='SilentlyContinue'; $u='https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7357f4631cdb8b789a58a0a9b8177c65702438af/backtest_pipeline/righe/RIGA_RITARDO_TESTER.ps1'; $f="$env:TEMP\RIGA_RITARDO_TESTER.ps1"; irm ($u+'?cb='+[guid]::NewGuid().ToString('N')) -OutFile $f; & { powershell -NoProfile -ExecutionPolicy Bypass -File $f -Rifai }
```

Alla fine, sul **Desktop**: cartella `RITARDO_R119` e **`RITARDO_R119.zip`** —
è quello lo zip da mandarmi.

### Il round può fermarsi da solo dopo DUE corse
È previsto. Fra la corsa `ORB Delay=0` e la corsa `ORB Delay=500` gira il
**cancello G0 (canarino)**: confronta i due CSV.
- **diversi** → il ritardo morde, partono le altre sei corse;
- **identici cifra per cifra** → MT5 ignora la chiave `Delay` da `.ini`, esito
  **NON MISURATO**, e le altre sei corse non si lanciano (macchina risparmiata).

> **NON MISURATO non vuol dire "immune al ritardo".** Vuol dire che la leva non
> è utilizzabile da riga di comando e va cercata un'altra strada.

**Anche se si ferma, mandami lo zip:** il referto serve lo stesso.

### Codici d'uscita di questa riga
| codice | significato |
|---|---|
| 0 | MISURATO — tutte e otto le corse fatte |
| 1 | preparazione fallita (MT5 aperto, scarico fallito, driver vecchio) |
| 2 | fermato dal cancello G0 — NON MISURATO |
| 3 | PARZIALE — mancano dei CSV |

## COLLAUDO DEL CANCELLO (non serve MT5, non serve lanciarlo)
Il cancello G0 è stato fatto scattare sul banco in tutti e tre i casi
(identici → `IGNORATA`, diversi → `MORDE`, file mancante → `ILLEGGIBILE`).
Si può rifare quando si vuole:
`-CollaudoCancello -CsvA <file> -CsvB <file>`
