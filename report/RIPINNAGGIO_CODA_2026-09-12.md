# 📌 RI-PINNAGGIO DELLA CODA — 12/09/2026 (sabato)

## 🎯 IN UNA RIGA
La missione chiedeva di ri-pinnare **7 righe**. Misurando prima di agire ne
sono uscite **19**: le 12 righe del weekend, quelle che il blocco di CODA.txt
dichiarava **già protette dalla toppa classe 270, avevano il pin sbagliato dei
due** — e sarebbero girate esattamente col difetto dichiarato disinnescato.
Non era un falso allarme: era un allarme **più grande di quello suonato**.

---

## 1. 🧪 LA MISURA PRIMA DELL'AZIONE — `git merge-base --is-ancestor 124db40 <pin>`

Eseguito uno per uno, esito reale (exit 0 = la toppa c'è; exit 1 = NON c'è):

| pin di coda | data | `--is-ancestor 124db40 <pin>` | esito |
|---|---|---|---|
| `8027068f` (r132c r133b r133c) | 11/09 23:55 | **exit 1** | ❌ NON contiene la toppa |
| `0c7d98af` (r136a r136b r136c r136d) | 12/09 07:20 | **exit 1** | ❌ NON contiene la toppa |
| `e6c0d70e` (le 12 del weekend) | 12/09 10:15 | **exit 0** | ✅ contiene la toppa |

Il controllo positivo su `e6c0d70e` dà **0**, come previsto. Le due misure
attese dalla missione tornano entrambe.

🔴 **E PROPRIO QUI STA LA TRAPPOLA: quelle tre misure sono VERE e la
conclusione che ci si costruiva sopra era FALSA.** Il commit `124db40` è
antenato di `e6c0d70e`, sì — ma `--is-ancestor` sul pin di coda **non misura
niente sul driver**, perché il pin di coda non decide quale driver gira.
È il punto 2.

---

## 2. 🔑 QUALE DEI DUE PIN COMANDA CHE COSA — con le righe citate

I pin sono **due**, e fanno lavori **diversi**. La catena di custodia,
misurata leggendo il codice riga per riga:

### 🔗 Anello 1 — il pin della COLONNA di `CODA.txt` decide **SOLO quale versione della riga sottile** viene scaricata
`backtest_pipeline/runner_abtg.ps1`:
- **r.735** il formato: `# formato:  <pin 40 hex> | <percorso nel repo> | <argomenti opzionali>`
- **r.740** `$pin = $parti[0]; $perc = $parti[1]`
- **r.750** `$url = $RawBase + "/" + $pin + "/" + $perc + "?cb=..."`
  👉 **il pin di coda serve a UNA cosa sola: costruire l'URL dello script `$perc`.**
- **r.769-771** il lancio:
  ```
  $argv = @("-NoProfile","-ExecutionPolicy","Bypass","-File",$file)
  if($argomenti){ $argv += ($argomenti -split '\s+') }
  ```
  👉 **il runner passa allo script SOLO il terzo campo della riga. Il pin NON
  viene mai passato come argomento.**

### 🔗 Anello 2 — dentro la riga sottile, `$PIN` e `$SHA_WALK` decidono il **DRIVER** e il **FILE PROVA**
`backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1` (letto, **non modificato**):
- **r.99-105** il `param()`: `$Expert`, `$Prova`, `$Etichetta`, `$Modello`,
  `$Deposito`, `$SoloControllo`. **Non esiste nessun `-Pin`.**
- **r.28-32**, dichiarato dall'autore: *"IL PIN E' FISSO E SCRITTO QUI DENTRO,
  non e' un argomento. Chi mette la riga in coda NON sceglie quale codice
  gira."*
- **r.275** `$PIN = '...'` · **r.294** `$SHA_ROUND` · **r.305** `$SHA_WALK`
- **r.313** `$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/" + $PIN`
- **r.444** `Prendi "backtest_pipeline/walkforward_generico.ps1" $fileWalk $SHA_WALK $MARC_WALK`
  👉 **il driver viene da `$PIN` e i suoi byte sono inchiodati da `$SHA_WALK`.**
- **r.463** `"-Pin",$PIN,` — lo stesso pin viene girato al figlio.

### 🔗 Anello 3 — il **FILE PROVA** viene dallo stesso `$PIN`, non dal pin di coda
`backtest_pipeline/righe/RIGA_ROUND_VPS.ps1`:
- **r.91** `[string]$Pin = "lavoro",`
- **r.105** `$RawBase = "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$Pin"`
- **r.600** `Scarica ($RawBase + "/backtest_pipeline/prove/" + $Prova) $provaLoc`
- **r.602** lo stampa: `"file prova: " + $Prova + " (" + $lenProva + " byte) dal pin " + $Pin`

### ✅ RISPOSTA CERTA
> **Il pin della colonna di `CODA.txt` NON decide quale driver gira.** Decide
> solo **quale versione di `RIGA_SOTTILE_ROUND.ps1`** viene scaricata. È
> `$PIN` (r.275) **dentro quella versione** a decidere driver e file prova.
>
> 👉 Quindi la toppa 270 **NON arriva a tutte e 30 le righe da sola**: arriva
> solo alle righe il cui pin di coda punta a una versione della riga sottile
> il cui `$PIN` interno contiene `124db40`. **Il ri-pinnaggio serve davvero.**

### 🛑 IL CONTRO-ESEMPIO, costruito e chiuso (regola del 10/09)
L'ipotesi **alternativa** che avrebbe ribaltato tutto: *"il runner inietta il
pin di coda come argomento, sovrascrivendo `$PIN`"*. Se fosse vera, il pin di
coda comanderebbe il driver e la missione sarebbe un falso allarme.
È **REFUTATA da due fatti indipendenti**:
1. `runner_abtg.ps1` **r.769-771**: in `$argv` entrano solo `-File $file` e
   `$argomenti`. **`$pin` non compare.** Non c'è codice che lo passi.
2. `RIGA_SOTTILE_ROUND.ps1` **r.99-105**: il `param()` **non ha un `-Pin`**.
   Anche se qualcuno lo scrivesse nel terzo campo, PowerShell morirebbe su
   parametro sconosciuto.

Non è "coerente con quello che mi aspettavo": è l'ipotesi contraria, cercata
e trovata falsa nel codice.

---

## 3. 🔴 IL DIFETTO NUOVO, PIÙ GRANDE DELLA MISSIONE: le 12 righe del weekend avevano il pin sbagliato dei due

Misurato — `$PIN` e `$SHA_WALK` **interni** a ogni versione della riga sottile:

| pin di coda in uso | `$PIN` interno | `$SHA_WALK` interno | driver che gira | toppa 270? |
|---|---|---|---|---|
| `8027068f` | `9cba7a10` | `02E2FE8F…9ECF3FEA` | senza toppa | ❌ NO |
| `0c7d98af` | `fb9b4731` | `02E2FE8F…9ECF3FEA` | senza toppa | ❌ NO |
| **`e6c0d70e`** | **`fb9b4731`** | **`02E2FE8F…9ECF3FEA`** | **senza toppa** | **❌ NO** |
| `1445abf8` | `e6c0d70e` | `62A53763…F7CBB7BC` | **con** toppa | ✅ SÌ |

E `--is-ancestor 124db40` sui pin **interni**: `9cba7a10` → **exit 1**,
`fb9b4731` → **exit 1**. Nessuno dei due porta la toppa.

🎯 **Il commit del "10° giro di pin" è `1445abf8`, NON `e6c0d70e`.**
`e6c0d70e` è il commit che il 10° giro **PUNTA** (è il valore di `$PIN`), non
il commit che **contiene** il 10° giro. Chi ha compilato il blocco del weekend
ha scritto in colonna il pin **puntato** invece del pin **contenitore**:
esattamente i due pin che la missione avvertiva di non confondere, scambiati.

🔴 **Conseguenza, se la coda fosse partita così**: le 12 righe del weekend
avrebbero scaricato `RIGA_SOTTILE_ROUND.ps1@e6c0d70e`, che porta
`$SHA_WALK = 02E2FE8F…` → **il driver SENZA la toppa 270**. Cioè avrebbero
girato **col difetto che il loro stesso blocco dichiarava disinnescato**, e
la frase in `CODA.txt` r.225-228 avrebbe fatto da alibi a un referto verde.
**La riga più pericolosa della coda era quella che diceva di essere al
sicuro.**

Verifica del driver scaricato via `raw` (vedi §5): al pin `e6c0d70e` il driver
**contiene** la toppa — r.1387 `# --- 12/09/2026, CLASSE 270: L'EX5 STANTIO
CHE PASSA PER COMPILATO.` e r.1400 `Remove-Item -LiteralPath $ex5Atteso -Force
-ErrorAction SilentlyContinue`. **Il driver giusto esiste: era la riga sottile
che non lo chiedeva.**

### 📉 E c'era anche un pezzo di classe 265, live
Con `$PIN` interno a `fb9b4731`, **tre** file prova su 19 sarebbero arrivati a
una versione **vecchia** (confronto sha256 con la copia locale di oggi):

| file prova | sha a `fb9b4731` | sha locale/`e6c0d70e` | che cosa mancava |
|---|---|---|---|
| `R127c_orologio_EURJPY.txt` | `2984cc28` | `1d756dc2` | la correzione classe 273 del `-Modello` |
| `R127b_sllookback_XAUUSD.txt` | `bce2007c` | `3c2a7b5e` | la correzione classe 273 del `-Modello` |
| `COLLAUDO_EMADOW_05_tf_U30USD.txt` | `758a9cf5` | `6e81858b` | la correzione classe 263 ("46 su 46" era sopra l'universo) |

🟢 **MA — e va detto perché cambia la gravità — il danno di questi tre era
SOLO sulla carta, non sui numeri.** Misurato: confrontando le righe di
**parametri** (non-commento con `=`) e le **direttive `@`** fra `fb9b4731` e
`e6c0d70e`, per tutti e tre i file il risultato è **PARAMETRI IDENTICI** e
**DIRETTIVE IDENTICHE**. I delta sono tutti in blocchi di commento. Quindi la
corsa avrebbe prodotto gli **stessi numeri**; sarebbe stato il **referto** a
mentire (un file prova che scrive "-Modello 4" mentre la coda passa
`-Modello 1`). È classe 273 nella sua forma documentale, non un round da
buttare. **Il difetto vero delle 12 resta il driver.**

---

## 4. 🔧 CHE COSA HO SPOSTATO

**Pin nuovo per tutte le righe ROUND: `1445abf80666883ea2f6a4ecb983e91a2eb26834`**
(commit *"Decimo giro di pin: le righe del weekend scaricano il driver CON la
toppa 270"*, 12/09 10:24). `--is-ancestor 124db40 1445abf8` → **exit 0**.
Ed è **identico alla testa di `lavoro`** per quel file
(`git diff --stat 1445abf8 HEAD -- …/RIGA_SOTTILE_ROUND.ps1` → vuoto).

| # | etichetta | pin prima | pin dopo | spostato? |
|---|---|---|---|---|
| 1 | `r132c` | `8027068f` | `1445abf8` | ✅ |
| 2 | `r133b` | `8027068f` | `1445abf8` | ✅ |
| 3 | `r133c` | `8027068f` | `1445abf8` | ✅ |
| 4 | `r136a` | `0c7d98af` | `1445abf8` | ✅ |
| 5 | `r136b` | `0c7d98af` | `1445abf8` | ✅ |
| 6 | `r136c` | `0c7d98af` | `1445abf8` | ✅ |
| 7 | `r136d` | `0c7d98af` | `1445abf8` | ✅ |
| 8 | `r127c` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| 9 | `r126a` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| 10 | `r127b` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| 11 | `r126b` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| 12 | `r126d` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| 13 | `cemad05` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| 14-17 | `r120b11` `r120b00` `r120b01` `r120b10` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| 18-19 | `r120e11` `r120e00` | `e6c0d70e` | `1445abf8` | ✅ **non era in missione** |
| — | `r133a` (riga **commentata**, pronta al rientro) | `8027068f` | `1445abf8` | ✅ pin aggiornato perché non rientri con quello vecchio |

### ✋ CHE COSA **NON** HO SPOSTATO, e perché
- **Le 11 righe di SOLA LETTURA** (`CODA_01` … `CODA_11`, pin `d22c61fc`,
  `5d4ab50d`, `d6362cbb`, `269de579`, `32718b9f`, `3a648eb6`, `4833b9dc`,
  `bbd2aa02`). **Non toccate, e non è una dimenticanza**: non passano dalla
  riga sottile, non scaricano `walkforward_generico.ps1`, non compilano
  nessun `.ex5`. La classe 270 **non le riguarda per costruzione**. Spostarle
  sarebbe stato inventare un lavoro.
- **`backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1`** — **LETTO, non
  scritto.** Un altro agente ci lavora adesso (toppa `@FRAZIONEIS`).
- **`backtest_pipeline/walkforward_generico.ps1`** — **LETTO, non scritto.**
  Risulta `M` (modificato non committato) nell'albero: è il lavoro dell'altro
  agente. **Non aggiunto al commit** (aggiunta per nome, nessun `git add -A`).
- **Nessun file prova toccato**: erano già tutti alla versione corretta.

---

## 5. 🌐 LE VERIFICHE `raw`, UNA PER UNA (trappola classe 265)

### A. La riga sottile al pin di coda nuovo
```
GET .../1445abf80666883ea2f6a4ecb983e91a2eb26834/backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1
→ HTTP 200   sha256 raw = c2e8cdc5086b650b…  =  sha256 git@1445abf8 ✅
  $PIN scaricato      = 'e6c0d70ef3bf61efd110ab4c9e7ee46e6ad40e7b'  ✅
  $SHA_WALK scaricato = '62A53763A186195DBE3FB3DAEE01B45A53B80F09BDC831B68046BD50F7CBB7BC' ✅
```

### B. I due `.ps1` inchiodati al byte, dal pin interno `e6c0d70e`
| file | HTTP | sha256 misurato | atteso dalla riga sottile |
|---|---|---|---|
| `righe/RIGA_ROUND_VPS.ps1` | **200** | `348ED533…9D0A315B` | `$SHA_ROUND` ✅ combacia |
| `walkforward_generico.ps1` | **200** | `62A53763…F7CBB7BC` | `$SHA_WALK` ✅ combacia |

E nel driver scaricato via `raw`: **toppa 270 presente** (r.1387 il commento
di classe, r.1400 il `Remove-Item` dell'`.ex5` **prima** di compilare).

### C. I 19 file prova al pin interno `e6c0d70e`, sha256 contro la copia LOCALE di oggi
| file prova | HTTP | sha raw | sha locale | esito |
|---|---|---|---|---|
| `R132c_nearatr_U30USD.txt` | 200 | `9d2b6126670b` | `9d2b6126670b` | ✅ |
| `R133b_filtrovolumi_U30USD.txt` | 200 | `d59aebaebf08` | `d59aebaebf08` | ✅ |
| `R133c_ampiezzabox_D30EUR.txt` | 200 | `91622b2ce1d9` | `91622b2ce1d9` | ✅ |
| `R136a_slatr_U30USD.txt` | 200 | `a0c077a10ef3` | `a0c077a10ef3` | ✅ |
| `R136b_primobersaglio_U30USD.txt` | 200 | `c2f739d40c19` | `c2f739d40c19` | ✅ |
| `R136c_parziale_U30USD.txt` | 200 | `02a472c297a4` | `02a472c297a4` | ✅ |
| `R136d_trailing_U30USD.txt` | 200 | `41390bb91e3f` | `41390bb91e3f` | ✅ |
| `R127c_orologio_EURJPY.txt` | 200 | `1d756dc2123a` | `1d756dc2123a` | ✅ |
| `R126a_costo_bufferatr_U30USD.txt` | 200 | `80e927aaacb5` | `80e927aaacb5` | ✅ |
| `R127b_sllookback_XAUUSD.txt` | 200 | `3c2a7b5ea217` | `3c2a7b5ea217` | ✅ |
| `R126b_stop_lookback_U30USD.txt` | 200 | `d39723b11646` | `d39723b11646` | ✅ |
| `R126d_costo_bufferatr_NASUSD.txt` | 200 | `308f97925e02` | `308f97925e02` | ✅ |
| `COLLAUDO_EMADOW_05_tf_U30USD.txt` | 200 | `6e81858b3523` | `6e81858b3523` | ✅ |
| `R120b_U30USD_11_vivo.txt` | 200 | `bebf821c1481` | `bebf821c1481` | ✅ |
| `R120b_U30USD_00_nuda.txt` | 200 | `16000b58253b` | `16000b58253b` | ✅ |
| `R120b_U30USD_01_notrail.txt` | 200 | `0aa65ea459c7` | `0aa65ea459c7` | ✅ |
| `R120b_U30USD_10_noflip.txt` | 200 | `39733f1479fe` | `39733f1479fe` | ✅ |
| `R120e_U30USD_11_vivo_TAGLIA.txt` | 200 | `d07648226b7e` | `d07648226b7e` | ✅ |
| `R120e_U30USD_00_nuda_TAGLIA.txt` | 200 | `ede3228aeeaf` | `ede3228aeeaf` | ✅ |

**19 su 19: HTTP 200 e sha256 combaciante con la copia locale.** ✅
Nessun pin è stato spostato su un file prova vecchio: la trappola 265 è
chiusa **misurando**, non promettendo.

---

## 6. 🧭 CLASSE 273 — il `-Modello` invertito, controllato su tutte e 19

Semantica di casa, dal driver **r.172**:
`[int]$Modello = 4,  # 4 = tick reali (verita'). 1 = OHLC M1: SOLO screening, mai verdetti`

### Le 7 righe della missione — ✅ TUTTE COERENTI
| etichetta | `-Modello` in coda | che cosa dice il file prova | esito |
|---|---|---|---|
| `r132c` | 4 | r.15 `-Modello 4`; r.21-22 spiega **perché NON 1**: *"-Modello 1, che e' OHLC M1 (r.172)… Prova che R123D era a tick reali"* | ✅ |
| `r133b` | 4 | r.14/18 `-Modello 4`, *"NON SONO OPZIONALI"*. Nessuna menzione di OHLC | ✅ |
| `r133c` | 4 | r.15 `-Modello 4`. Nessuna menzione di OHLC | ✅ |
| `r136a` | 4 | r.334 `Modello 4 (TICK REALI)` | ✅ |
| `r136b` | 4 | r.178 `Modello 4 (TICK REALI)` | ✅ |
| `r136c` | 4 | r.183 `Modello 4 (TICK REALI)` | ✅ |
| `r136d` | 4 | r.183 `Modello 4 (TICK REALI)` | ✅ |

**Nessun `-Modello 4` con "= OHLC M1" accanto, né il contrario.** Le
menzioni di OHLC in `R136a` (r.19, r.24) sono riferimenti ad **ancore
storiche** di altri round, non alla corsa di questo file.

### Le 12 del weekend — ✅ coerenti **al pin nuovo**, ❌ lo erano solo a metà al pin vecchio
`r127b` e `r127c` girano a `-Modello 1` (la loro ancora è OHLC M1) ed è
**giusto**; ma al pin `fb9b4731` i loro file prova scrivevano ancora
`-Modello 4` con accanto `= OHLC M1`. Col pin `1445abf8` arriva la versione
corretta (`-Modello 1`), che combacia con la coda. Difetto **chiuso dal
ri-pinnaggio**, non da una modifica.

---

## 7. 🚦 I CANCELLI — lanciati DA SOLI, senza pipe (classe 254)

```
python3 backtest_pipeline/controlla_prova.py <i 7 file della missione>
  → file: 7 | celle totali: 39 | passate: 78 | problemi: 0 | ESITO: OK      EXIT=0

python3 backtest_pipeline/controlla_prova.py <i 12 file del weekend>
  → file: 12 | celle totali: 16426 | passate: 32852 | problemi: 0 | ESITO: OK  EXIT=0

python3 backtest_pipeline/controlla_riga.py --ps1 backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1
  → PASSATI (6): ASCII puro, parser 0 errori, param block riconosciuto,
    niente pwsh-7-only, formati .NET, niente Parse senza cultura invariante
  → ESITO: nessun difetto meccanico                                        EXIT=0
```
Il codice d'uscita è stato **letto** in un comando separato, e il commit è
avvenuto **dopo**.

🟢 **Le passate promesse tornano**: `r132c` 8 celle × 2 finestre = **16**
(CODA dice 16) · `r133c` 9 × 2 = **18** (CODA dice 18) · `r133b` 2 × 2 = **4**
(CODA dice 4) · `r136a-d` (7+7+4+2) × 2 = **40** (CODA dice 40). Il conto di
casa e il conto del cancello coincidono.

⚠️ `COLLAUDO_EMADOW_05` stampa **16374 celle**: è il conto **aritmetico** su
un asse `ENUM_TIMEFRAMES`, e il file prova stesso lo dichiara in anticipo
(*"ATTENZIONE A UN NUMERO CHE MENTE… controlla_prova.py conta questo asse
ARITMETICAMENTE"*). Le celle vere sono **7** (i membri fra M15 e H4). Non è
un difetto nuovo: è un numero già etichettato come bugiardo dal suo autore.

---

## 8. 🩹 CHE COS'ALTRO HO CORRETTO IN `CODA.txt`

Il blocco del weekend conteneva la **frase falsa** che ha causato tutto:
> *"🔑 QUESTE 12 SCARICANO IL DRIVER CON LA TOPPA DELLA CLASSE 270.
> Verificato: git merge-base --is-ancestor 124db40 e6c0d70e -> 0"*

Riscritta con: la distinzione fra i due pin e le righe che lo provano, la
misura che la smentisce (`$PIN = fb9b4731` **al commit** `e6c0d70e`), e
l'avviso che **il pin `1445abf8` scade appena il driver cambia** — al primo
commit di `walkforward_generico.ps1` (toppa `@FRAZIONEIS` in corso) `$SHA_WALK`
non torna più e la riga sottile **muore prima di eseguire**: fallimento
rumoroso e innocuo, non silenzioso. Allora serve un giro di pin nuovo,
**prima la riga sottile, POI la colonna della coda**.

Non ho toccato gli altri blocchi di commento: documentano storia e devono
restare come sono.

---

## 9. 🔴 CHE COSA RESTA `[NON MISURATO]`

1. **[NON MISURATO] Se la toppa 270 funziona davvero sul campo.** È letta nel
   sorgente (r.1387/1400) e verificata via `raw`, ma **nessuno ha ancora
   fatto fallire una compilazione apposta** per vedere il driver morire
   invece di girare l'`.ex5` vecchio. La prova sta nel referto di domani, non
   qui.
2. **[NON MISURATO] Il runner installato su `C:\ABTG` è al pin che crediamo.**
   La sua impronta si confronta col pin **una volta sola,
   all'installazione** — è il buco che `CODA_11` fotografa (r.170-183 di
   `CODA.txt`). Questo ri-pinnaggio agisce sulla **coda**: se il runner
   installato fosse ancora il v2, tutte e 19 le righe verrebbero **RIFIUTATE
   a G1** e nessun round partirebbe. Non è un danno, ma va letto nel referto.
3. **[NON MISURATO] La riga sottile dopo `@FRAZIONEIS`.** Il pin `1445abf8`
   vale **fino al prossimo commit di `walkforward_generico.ps1`**. L'albero
   ha già quel file `M`. Chi chiude quella toppa deve fare un **11° giro di
   pin** e poi ri-pinnare questa colonna. Senza, le 19 righe muoiono su
   `$SHA_WALK` (rumoroso, non silenzioso — il modo giusto di rompersi).
4. **[NON MISURATO] `-FrazioneIS` non arriva dalla coda.** I file prova di
   `r133b`, `r133c` e `r136a-d` scrivono `-FrazioneIS 0.40`, ma la lista
   bianca della riga sottile (r.99-105) **non ha quel parametro**: il driver
   usa il suo **default, che è `0.40`** (`walkforward_generico.ps1` r.171).
   Quindi oggi il numero **coincide** e non c'è danno. 🔴 Ma è una
   **coincidenza, non una garanzia**: se il default del driver cambiasse, i
   round girerebbero una finestra diversa da quella scritta nel file prova
   **senza che nessuno lo veda**. È esattamente il perimetro dell'altro
   agente: **segnalato, non toccato.**
5. **[NON MISURATO] `r133a` resta commentata.** Il suo motivo di ritiro
   (ABTG_Nasdaq_Apertura_US alla testa `b5d904a` = WIP che cambia il
   meccanismo d'ingresso) **non è stato rimisurato oggi**: ho solo aggiornato
   il pin perché non rientri con quello vecchio. Rientra quando quel `.mq5`
   è a un commit non-WIP.

---

## 10. ✅ STATO FINALE DELLA CODA

```
righe attive                      : 30   (11 sola lettura + 19 round)
formato valido (pin 40hex + path) : 30 / 30
righe round sul pin 1445abf8      : 19 / 19
pin vecchi residui in campo pin   : 0
```

🎯 **Domenica alle 03:30 tutte e 19 le righe round scaricano lo stesso
driver, e quel driver cancella l'`.ex5` prima di compilare.** Il cancello di
determinismo di `r132c` adesso può dire qualcosa: se riproduce R123D cifra
per cifra, è perché ha ricompilato, non perché ha riletto il binario di ieri.

**Una mina l'avevamo disinnescata stamattina. Oggi abbiamo scoperto che il
filo tagliato era quello sbagliato — e ora è quello giusto.** 💪
