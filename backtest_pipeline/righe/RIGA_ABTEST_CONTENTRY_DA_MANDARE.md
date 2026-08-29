# 🔬 MISURA A/B — il TIMING D'INGRESSO della CONTINUAZIONE (`InpContEntryMode`)

**ABTG_BreakingBand v1.05 · GBPUSD + EURUSD + AUDUSD · H1 · tick reali · 2020→2026.6**

Spazziamo **un solo parametro-strategia** — `InpContEntryMode` — e teniamo **tutto il
resto identico alla cella VIVA di R103**. Serve a capire se il **mode 2 (IN-BULGE di
Claudio)** batte davvero il **mode 0** e il **mode 1**, sul terreno **vivo** del motore
(H1 forex, quello dove il Bulge respira — a M15 R108 l'ha gia' misurato morto, 6/6 rosse).

| mode | cos'e' |
|------|--------|
| **0** | 🕐 PRIMO tocco storico (comportamento 1.03) |
| **1** | 🔁 RETEST banda opposta (Leonardo p.4, 1.04) |
| **2** | 💥 IN-BULGE di Claudio (1.05): primo-tocco-opposta + trend mediana + candela direzionale + range |

> ⚠️ **QUESTO NON E' UN ROUND CHE PROMUOVE. E' UNA MISURA A/B.** Non tocca il forward,
> non tocca il `.mq5`, non taratura, non sceglie nessuna cella. Produce **PF / DD / n**
> per `(mode × IS/OOS × simbolo)` e li mette a referto. Il giudizio lo dara' Claudio,
> con i criteri qui sotto **congelati prima dei numeri**.

---

## 📏 CRITERI DI LETTURA — CONGELATI PRIMA DEI NUMERI (regola di casa)

- **Quale metrica decide:** il **PROFIT FACTOR FUORI CAMPIONE (PF OOS)** per mode,
  letto **insieme alla COERENZA CROSS-SIMBOLO**. Il **DD OOS** e' il guardrail del rischio.
- **La soglia (dichiarata prima):** il **mode 2 "vince" SOLO se**, su **almeno 2 simboli su 3**,
  `PF_OOS(2) > PF_OOS(0)` **e** `PF_OOS(2) > PF_OOS(1)`, **senza un DD OOS peggiore** del mode che batte.
  **Un solo simbolo a favore = NON dimostrato** (Emendamento A: _"un simbolo per parte non e' dimostrato"_).
  E **mai il picco isolato**: senza coerenza cross-simbolo, un PF che sporge su un solo simbolo e' rumore.
- **Campione sottile → merito sospeso, rischio sempre** (Emendamento B):
  se `n_OOS < 150` su un mode/simbolo, il **MERITO (PF) non si legge come verdetto** — si annota.
  Il **RISCHIO invece si legge SEMPRE**: un **DD OOS peggiore del DD promesso dalla cella viva di R103**
  e' un **fatto accaduto**, e va segnalato a qualunque `n`.

---

## 🧱 I dettagli fissati (per il verificatore)

- **Cella base = cella VIVA di R103**, byte per byte, per ogni simbolo — `InpPatternMode` **vivo**:
  GBPUSD = **2**, EURUSD = **0**, AUDUSD = **1**. Gate dell'**antenato R103** nel driver.
- **I 4 input del mode 2 restano ai DEFAULT del sorgente** (vincolo della sessione principale):
  `InpTrendSlopeFactor=0.08`, `InpTrendSlopeBars=5`, `InpContEntryMaxRangeATR=2.0`,
  `InpContRequireMidFirst=false`.
- **IS/OOS = 40/60 di R103** (stessa convenzione di `walkforward_generico`), calcolato sul terreno
  intero: **IS 2020.01.01→~2022.08.06 · OOS ~2022.08.07→2026.06.30** (lo split esatto lo calcola e
  lo stampa il driver). _Non_ il 2+2 di R108: quello era una forzatura del tetto 100k barre su M15;
  qui siamo su H1 e il terreno intero c'e' tutto.
- **Modello 4 (tick reali).** ⚠️ La profondita' dei tick BCM sul forex **non e' misurata in repo**:
  il driver lo dichiara come **rilievo** accanto a ogni numero OOS (a Model 4, se i tick reali non ci
  sono, MT5 ripiega e produce numeri plausibili e falsi).
- **MAGIC vergini: blocco `7650xx`.** GBPUSD 765000/765001 (IS) + 765002/765003 (OOS),
  EURUSD 765010…765013, AUDUSD 765020…765023. **Prova della verginita':** in tutto il repo
  le uniche `765xxx` usate sono `765121 / 765211 / 765213`, **tutte sopra il blocco**; il driver ha
  anche un **veto di range 760000–764999** (tutti i round BreakingBand gia' fatti) e la lista delle sedie vive.
- **`InpMagic` e' l'asse INERTE (gemelli):** come in R103/R108 non cambia niente della strategia,
  serve solo alla **gemella di determinismo** (i due magic devono dare PF/DD/n identici a parita' di mode).
  Percio' _"l'unico parametro spazzato e' InpContEntryMode"_. `3 mode × 2 gemelli = 6 celle` per finestra.

---

## ▶️ LA RIGA DA INCOLLARE (prima il GIRO A VUOTO)

> `<PIN>` = l'hash del commit che contiene il driver **e** i tre file prova (te lo do in chat).
> Prima gira con **`-SoloControllo`**: **non apre MT5**, scarica al pin, passa tutti i gate,
> **scrive e verifica i 6 `.ini`** (IS+OOS per i 3 simboli) e fa lo **zip sul Desktop**.
> Se i conteggi tornano, rilanci **lo stesso comando SENZA `-SoloControllo`**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_ABTEST_CONTENTRY.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_ABTEST_CONTENTRY.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_ABTEST_CONTENTRY_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' } }
```

**La corsa VERA** (dopo che il giro a vuoto e' pulito): stesso blocco **togliendo `-SoloControllo`**.

---

## 📦 LA RACCOLTA (la fa il driver, sempre)

Il driver a fine corsa scrive **da solo** sul **Desktop**:

- 📁 `ABTEST_CONTENTRY_<data_ora>\` — con dentro: **REFERTO** (`.md`, la **TABELLA A/B**),
  `ini\` (i 6 `.ini`), `risultati_prove\` (`OptResults_<SIM>_IS.csv` / `_OOS.csv`), `prove\`
  (i 3 prova A/B + i 3 antenati R103), `src_motori\` (il sorgente al pin) e il log del compilatore.
- 🗜️ `ABTEST_CONTENTRY_<data_ora>.zip` — lo zip pronto da mandare.

**File attesi da verificare nello zip:** `REFERTO_ABTEST_CONTENTRY_*.md`, i **6 `.ini`**,
i CSV `OptResults_*_IS/_OOS` (solo nella corsa vera), i 3 file prova, il sorgente e `compile_BreakingBand.log`.

---

## 🚫 Cosa NON aspettarsi

- Nel **giro a vuoto NON esce nessun numero**: senza tester non c'e' nessun PF/DD/n. E' scritto anche nel referto.
- Questa misura **NON promuove e NON spegne niente**, **NON tocca il forward** e **NON tocca `ABTG_BreakingBand.mq5`**.
  Dice solo se il **mode 2 di Claudio** merita di essere portato avanti come candidato, oppure no.

---

### File di questo pacchetto
- Driver: `backtest_pipeline/righe/RIGA_ABTEST_CONTENTRY.ps1` (marcatore `MARCATORE_RIGA_ABTEST_CONTENTRY_v1`)
- Prova: `backtest_pipeline/prove/ABTEST_CONTENTRY_ABTG_BreakingBand_{GBPUSD_765000,EURUSD_765010,AUDUSD_765020}.txt`
- Questa pagina: `backtest_pipeline/righe/RIGA_ABTEST_CONTENTRY_DA_MANDARE.md`
