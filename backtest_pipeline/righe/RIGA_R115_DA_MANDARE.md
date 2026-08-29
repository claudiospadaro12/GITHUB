# 🧪 R115 — LEVA REVERSE (DAX) + ESTENSIONE RETEST (Nasdaq, Dow) — DA MANDARE

**Che cos'è.** Un pacchetto di **MISURA** (non promuove niente, non tocca il
forward). Due domande, a criteri congelati **prima** dei numeri:

- **(a) LEVA REVERSE sul DAX** — `InpAllowReverse` false (com'è oggi) vs true.
- **(b) ESTENSIONE del RETEST** (geometria del DAX vivo) su **Nasdaq** e **Dow**,
  entrambi i lati.

## ⚠️ Leggi PRIMA di firmare
1. **Criteri**: `backtest_pipeline/risultati_archivio/R115_CRITERI.md`
   (in testa c'è il lucchetto **[DA FIRMARE]**: finché è lì, la corsa vera
   **non parte**, esce con codice 2).
2. **Il tranello del reverse** (criteri §1, misurato nel sorgente): la sedia
   viva DAX è **long-only**, e col solo `InpAllowReverse=true` **il secondo
   ciclo non parte mai**. Per questo l'A/B è a **tre celle** (00 vivo /
   01 due-lati / 02 reverse), e l'A/B "a una variabile" è **01 vs 02**.
3. **Fuso** (criteri §3): DAX **08:00 server** (09:00 IT − 1), Nasdaq/Dow
   **14:30 server** (15:30 IT − 1). Il driver **cestina** un file con l'ora
   italiana.

## 📦 Cosa gira
7 celle, 3 EA, 3 simboli, M5 tick reali, finestra **2024.09.26 → 2026.06.30**
(IS/OOS 40/60). Magic **vergini 766xxx**. Ogni cella = coppia gemella (igiene
del banco). Le corse sono delegate a `walkforward_generico.ps1` (pinnato).

---

## 1️⃣ PRIMA: il GIRO A VUOTO (sempre, anche a criteri non firmati)

Non apre MT5, non misura numeri: scarica al pin, **verifica tutti i gate**
(versione EA, fuso, baseline, stella, magic) e stampa gli `.ini` che
lancerebbe. `<PIN>` = l'hash del commit che contiene QUESTO pacchetto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R115.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R115_REVERSE_ESTENSIONE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R115_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore R115.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO sul Desktop' } }
```

---

## 2️⃣ POI (solo dopo aver tolto il lucchetto **[DA FIRMARE]** dai criteri): la CORSA VERA

Identica alla precedente, **senza `-SoloControllo`**. Apre MT5, gira le 7 celle
a tick reali (IS+OOS), scrive il referto e lo zip sul Desktop.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R115.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R115_REVERSE_ESTENSIONE.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R115_v1' -Quiet)){ throw 'SCRIPT VECCHIO: il file scaricato non ha il marcatore R115.' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO sul Desktop' } }
```

> Una cella sola (o alcune): aggiungi `-SoloLavoro 'DAX_02_reverse'` oppure
> `-SoloLavoro 'NAS_00_long DOW_00_long'` (fra apici). I gate girano comunque
> su tutti e 7 i file (servono al confronto della stella).

---

## 📤 Cosa arriva sul Desktop
- Cartella `R115_CORSA_<data>` (o `R115_CONTROLLO_<data>` nel giro a vuoto).
- `R115_REFERTO_DRIVER_<data>.txt` — la tabella OOS + IS, i **tre confronti
  del reverse** (A / A' / B) e il prior misurato dell'estensione (02/08).
- `prove\R115_*.txt` — i 7 file prova che hanno girato.
- `csv\` — i CSV IS/OOS delle celle misurate (solo nella corsa vera).
- Zip `R115_CORSA_<data>.zip` pronto da mandare.

## 🔢 Codici d'uscita
`0` tutto ok · `2` criteri non firmati (corsa vera bloccata) · `1` fermato da
un gate/errore · `3` misurato ma con problemi (es. gemelli non identici,
celle mute) — **leggere il referto prima di leggere qualunque numero**.
