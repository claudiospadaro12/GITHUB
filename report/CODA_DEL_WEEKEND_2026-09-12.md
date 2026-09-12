# 🌙 LA CODA DEL WEEKEND — 12/09/2026

**Ri-pinnaggio (DECIMO giro) + 12 righe di round pronte per la finestra da
~28 ore.** Nessun backtest eseguito, nessun EA toccato, nessun preset, nessuna
taglia, `CODA.txt` **non modificata**, le 7 righe già in coda **non toccate**.

> 🎯 **La bussola, detta prima dei dettagli:** questa notte non è ponteggio. È
> la prima volta che entrano in macchina **quattro requisiti del certificato di
> morte** su quattro motori diversi — e in particolare la riga a **ZERO** della
> Tabella B dell'audit uscite (`InpTrailOnST` × `InpExitOnFlip`), che in tutto
> l'archivio non è **mai** stata un asse.

---

## 🥇 0. LA RISPOSTA IN QUATTRO RIGHE

| cosa | esito |
|---|---|
| **Pin nuovo** | `e6c0d70ef3bf61efd110ab4c9e7ee46e6ad40e7b` — 🟢 `git merge-base --is-ancestor 124db40 e6c0d70e` → **esce 0**, la toppa della classe 270 **c'è** |
| **Righe pronte** | **12** in coda (6 pulite + 6 con rischio dichiarato) · **1 tenuta fuori** (`r126c`, e il motivo è il contagio, §5) |
| **Costo** | **118 passate**, **16,3 minuti** col metro misurato · banda onesta **2,2–4,4 ore** · finestra **28 ore** → si usa **l'8–16%** |
| **Difetto bloccante trovato strada facendo** | 🔴 **`r127c` e `r127b` avevano il `-Modello` INVERTITO.** Lanciato così, il **canarino della notte sarebbe morto per costruzione** e avrebbe fermato gli altri undici round dando la colpa al binario. Corretto (§2) |

---

## 🔧 1. IL RI-PINNAGGIO — decimo giro, e la prova che la toppa c'è

### 1.1 Che cosa è cambiato nel file

`backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1` — **due sole righe di codice**,
più 61 righe di commento che spiegano perché:

| riga | prima | dopo |
|---|---|---|
| `$PIN` | `fb9b4731391c221b6229409f8e9fd7ca44bc2514` | **`e6c0d70ef3bf61efd110ab4c9e7ee46e6ad40e7b`** |
| `$SHA_WALK` | `02E2FE8F…9ECF3FEA` | **`62A53763A186195DBE3FB3DAEE01B45A53B80F09BDC831B68046BD50F7CBB7BC`** |
| `$SHA_ROUND` | `348ED533…9D0A315B` | **`348ED533…9D0A315B` — NON toccata** |

🟢 E `$SHA_ROUND` non è stata lasciata lì per fede: è stata **RICALCOLATA** sul
blob del pin nuovo e coincide. Le due impronte vengono da
`git cat-file blob <pin>:<file> | sha256sum`, e sono state **riverificate
scaricandole via HTTPS** dal pin (non dal blob locale): coincidono al byte.

### 1.2 🔴 IL CONTROLLO CHE DECIDE TUTTO, e il suo contro-esempio

Il mandato chiede di verificare che `124db40` sia antenato del pin nuovo. Fatto —
**ma un «esce 0» da solo non vale niente**, perché uno strumento rotto stampa 0
sempre. Quindi ho fatto girare lo stesso comando **anche sul pin vecchio**, dove
la risposta **deve** essere l'opposto:

| comando | atteso | ottenuto |
|---|---|---|
| `git merge-base --is-ancestor 124db40 e6c0d70e` | **0** (la toppa c'è) | 🟢 **0** |
| `git merge-base --is-ancestor 124db40 fb9b4731` *(pin vecchio)* | **1** (la toppa NON c'è) | 🟢 **1** |
| `git merge-base --is-ancestor 124db40 8027068f` *(pin di r132c/r133b/r133c)* | **1** | 🟢 **1** |
| `git merge-base --is-ancestor 124db40 0c7d98af` *(pin dei quattro r136)* | **1** | 🟢 **1** |

E un secondo controllo **indipendente dal primo**, sui byte invece che sul grafo:
quante volte compare `Remove-Item -LiteralPath $ex5Atteso` nel driver a quel pin?

| pin | occorrenze |
|---|---|
| **`e6c0d70e`** (nuovo) | 🟢 **1** |
| `fb9b4731` · `8027068f` · `0c7d98af` | 🔴 **0 · 0 · 0** |

👉 **Due misure diverse, stessa risposta.** Il controllo distingue i due casi,
quindi il suo «0» dice qualcosa.

### 1.3 🔴 E LA COSA CHE VA DETTA, anche se non posso ripararla

**Nessuna delle 7 righe già in coda ha la toppa della classe 270.** Restano al
loro pin per mandato, e non le ho toccate. Ma chi legge i loro CSV la mattina
deve sapere che **per loro il falso positivo silenzioso è ancora possibile**, e
che il rilevatore di riserva sono le loro **ancore**:

- `r132c` deve riprodurre **5 celle di R123D** cifra per cifra;
- `r136a` deve ridare la cella viva **IS 237 / PF 1,20110 / DD 5,7325%** e
  **OOS 517 / 1,52365 / 7,8323%**.

⚠️ **E c'è un caso in cui l'ancora NON salva, e va nominato:** se la
compilazione di `ABTG_SupRev_DOW_H1_Ottimizzato` fallisse e girasse l'`.ex5`
**stantio dell'era pre-`b45dd00`**, `r132c` riprodurrebbe R123D **perfettamente**
— perché R123D è nata proprio su quel binario. 🔴 Il gate passerebbe
**confermando il nulla**. Stesso schema su `r136a`. Non è un motivo per
fermarle: è un motivo per **non leggere un loro PASS come collaudo della
neutralità di `b45dd00`**.

### 1.4 🟢 E un difetto che il pin nuovo ripara e nessuno aveva chiesto

`COLLAUDO_EMADOW_05_tf_U30USD.txt` **esiste** anche a `fb9b4731` e `0c7d98af`
— quindi la classe 265 («il pin non contiene quel file») era vera per
`8027068f`, non per quelli. 🔴 **Ma esiste in una versione SUPERATA**, e questo
è peggio di un 404: blob `758a9cf5…` a `fb9b4731` / `0c7d98af` contro
`6e81858b…` al pin nuovo. Quella vecchia è la stesura **prima** delle 5
correzioni bloccanti del cancello di giudizio (commit `92c9621`, «secondo giro:
applicati 5 bloccanti + 4 gravi»). Col pin vecchio il round avrebbe girato la
versione **bocciata**, con un file prova che esiste e sembra giusto.

### 1.5 I cancelli meccanici, lanciati DA SOLI e senza pipe (classe 254)

| cancello | comando | uscita |
|---|---|---|
| `controlla_riga.py` su `RIGA_SOTTILE_ROUND.ps1` | lanciato singolo, redirezione su file | 🟢 **0** — 6 controlli passati: ASCII puro · parser PowerShell vero **0 errori** · param block riconosciuto · niente pwsh-7-only · formati .NET · nessun Parse senza cultura invariante |
| `controlla_prova.py` sui 13 file prova | uno per uno | 🟢 **0** su tutti e 13, **0 problemi** |
| `VagliaScript` del runner (G1+G2+G3) sul file ri-pinnato | eseguita per davvero con `pwsh` | 🟢 **ok=True, corsia=ROUND** — «G1, G2 e G3 passato: bersaglio dichiarato e coerente» |
| `VagliaArgomenti` (G4) sugli argomenti veri delle 12 righe | eseguita | 🟢 **ok=True** su tutte |

🔴 **E i quattro contro-esempi, perché senza di loro quei PASS non provano
niente.** Li ho costruiti io e girati sullo **stesso** cancello:

| contro-esempio | atteso | ottenuto |
|---|---|---|
| `Remove-Item` **scommentato** (il mio nuovo blocco lo cita dentro un commento) | RIFIUTO | 🟢 **G2: riga 229 contiene 'Remove-Item'** |
| `$BancoBT` riassegnato a `D:\MT5_Altro` | RIFIUTO | 🟢 **G3: riga 401 nomina un terminale senza puntare al banco** |
| marcatore `RUNNER_SOLA_LETTURA` aggiunto (due marcatori) | RIFIUTO | 🟢 **G1: ambiguità, si rifiuta** |
| argomenti con un percorso fuori dal banco (`D:\Altro`) | RIFIUTO | 🟢 **G4: percorso fuori dal banco** |

👉 Il cancello **becca** il caso peggiore del mio stesso diff (ho infilato un
divieto dentro un commento) e **non** becca la riga vera. Poi il suo PASS vuol
dire qualcosa.

💡 **Un quinto contro-esempio che NON ha rotto nulla, e lo scrivo lo stesso:**
il regex del pin (`^[0-9a-f]{40}$`) in PowerShell è **case-insensitive**, quindi
un pin MAIUSCOLO passerebbe il controllo. Ho verificato se sia un buco:
GitHub raw risponde **HTTP 200 anche con lo SHA in maiuscolo**. 🟢 Innocuo,
nessuna riparazione necessaria.

---

## 🔴 2. IL DIFETTO BLOCCANTE CHE HO TROVATO STRADA FACENDO

Non era nel mandato. È emerso leggendo i file prova uno per uno, e **avrebbe
buttato la notte**.

### 2.1 Il fatto

`R127c_orologio_EURJPY.txt` r.13 e `R127b_sllookback_XAUUSD.txt` r.13 dicevano
**`-Modello 4`**, e due righe sotto scrivevano **«`-Modello 4` = OHLC M1»**.

È **invertito**. `walkforward_generico.ps1` r.172, testuale:

```
[int]$Modello = 4,   # 4 = tick reali (verita'). 1 = OHLC M1: SOLO screening, mai verdetti
```

È **lo stesso difetto, specchiato**, che l'11/09 sera il commit `1764a0e` ha
corretto sui tre file `R132` (là era scritto `-Modello 1` con accanto «tick
reali»). Due volte in due giorni: è una **classe**, non una distrazione.

### 2.2 Quale metà era il typo — e come l'ho stabilito senza indovinare

Le due letture possibili sono simmetriche («voleva 4 e ha sbagliato
l'etichetta» / «voleva OHLC e ha sbagliato il numero»). Ho cercato chi decide:

1. 🟢 **`R127b` lo dice in chiaro:** *«Si usa qui perché l'ANCORA di questo file
   (R99) è nata così, e due numeri con modelli diversi non si confrontano»* —
   e, due righe sopra, *«su 22 anni i tick non esistono»*. **Intento = OHLC.**
2. 🟢 **`R127c` ha la tolleranza al centesimo** (`n ±2%`, `PF ±0,03`). Quella si
   scrive **solo** se il modello combacia. Confronto che chiude il punto:
   **`R126d`**, la cui ancora è OHLC ma che gira a tick reali, scrive
   esplicitamente *«NON è un'ancora al centesimo, è un ordine di grandezza»*.
   👉 L'autore **sa** come si scrive quando i modelli non combaciano. Qui non
   l'ha scritto.
3. 🟢 **La fonte dell'ancora lo dichiara:**
   `risultati_archivio/R103_REFERTO_FINALE.md`, intestazione r.6-7: *«Pin
   `7e2fb0d` (v3). **OHLC M1** → il DD è un LIMITE INFERIORE e il profitto una
   STIMA DEL LORDO»*.

### 2.3 🧪 IL CONTRO-ESEMPIO, che è una misura in archivio e non una lettura

Il driver (r.1446) appende `_ohlc` al nome del CSV **quando il modello non è 4**:

```
$Suffisso = if($Modello -eq 4){ "" } else { "_ohlc" }
```

E quel suffisso **non è lettera morta**: nel repo ci sono **288** CSV `_ohlc`
(`find backtest_pipeline -name "*_ohlc*.csv" | wc -l`). Quindi l'assenza del
suffisso è **una misura**, non un silenzio. Applicato ai due casi opposti:

| round | dove sta l'ancora | suffisso | ⇒ modello dell'ancora | `-Modello` giusto |
|---|---|---|---|---|
| `r126a` | `..._U30USD_IS.csv` / `..._OOS.csv` (contengono `1.84892` e `1.32770` — verificato con `grep -l`) | **assente** | **tick reali** | 🟢 **4** (era già giusto) |
| `r127c` | `R103_REFERTO_FINALE.md`, che dichiara OHLC M1 in intestazione | — | **OHLC M1** | 🔴 **1** (era 4) |
| `r127b` | R99, dichiarata OHLC dal file prova stesso | — | **OHLC M1** | 🔴 **1** (era 4) |

👉 Lo stesso strumento dà risposte **diverse** su round diversi. Poi il suo «1»
su `r127c` vuol dire qualcosa.

### 2.4 💰 Quanto costava

🔴 `r127c` **è il canarino della notte**: se non ricompone `394 ±2%` e
`PF 1,41 ±0,03`, **gli altri undici si fermano**. A tick reali non avrebbe
potuto ricomporlo **per costruzione** — e il referto della mattina avrebbe
scritto *«il canarino è morto, sospetto il binario `b45dd00`»*. Undici round
fermati, e un verdetto **falso** su un commit innocente.
🔴 Su `r127b`, il **PF si legge per la prima volta in assoluto** (R99 non lo
dichiara): a tick reali su 22 anni senza tick, sarebbe nato **non
attribuibile**.

✏️ **Corretto** nei due file prova (commit `e6c0d70`): numero portato a **1**,
etichetta corretta con la citazione della r.172, e la correzione lasciata
**visibile** dentro il file, non riscritta in silenzio. `controlla_prova.py`
dopo la patch: 🟢 **OK su entrambi, 0 problemi** (8 celle / 7 celle).

### 2.5 🟡 Un difetto minore del driver, dichiarato e NON toccato

`walkforward_generico.ps1` r.830 scrive `Model=4` **cablato** nell'`.ini` di
**anteprima** di `-SoloControllo`. Quindi chi girasse `r127b`/`r127c` a mano con
`-SoloControllo` leggerebbe *«Model=4»* mentre la corsa vera scriverebbe
`Model=1` (r.1484).
🟢 **Zero impatto sulla notte**: il runner non passa `-SoloControllo`. Ma è uno
**stato implicito che mente** in un'anteprima, ed è candidato a classe nuova.
Il driver **non l'ho toccato** (vincolo).

---

## 📋 3. LA TABELLA DELLE RIGHE, IN ORDINE

Ordine **del cancello** (`IL_WIP_E_DIAGNOSTICA_2026-09-12.md` §6.4), non mio.
Metro del costo: **`T(min) = 0,6 + 0,077 × passate`, per round** — tarato su
`REFERTO_R88.txt` r.10-14.

### BLOCCO A — le sei pulite

| # | round | EA · simbolo · TF | asse (celle) | passate | T stim. | requisito del certificato che chiude | ⚓ ancora | 📅 data del BINARIO dell'ancora | deriva del sorgente |
|---|---|---|---|---:|---:|---|---|---|---|
| **A1** 🐦 | **`r127c`** | `ABTG_CostToCost` · EURJPY · H4 | `InpMaxBarsHold` 25→200 (8) | 16 | 1,83 | **3** — uscita ad asse. `InpMaxBarsHold` = **100 in 128 CSV su 128**: manopola **inerte per censimento** | PF **1,41** · n **394** · DD **12,3%** (OHLC M1, finestra piena) — `R103_REFERTO_FINALE.md` r.15 | 🟢 **`26a1856`, 19/08/2026** — unico commit possibile (l'EA ne ha **3** in tutto) | 🟢 **UNO SOLO: `b45dd00`** |
| **A2** | **`r126a`** | `ABTG_SuperWave_DOW_H1_Ottimizzato` · U30USD · H1 | `InpSLBufferAtr` 0→1,0 (9) | 18 | 1,99 | **3** — la manopola che **esiste, è a zero e non ha mai girato** | IS PF **1,84892** n **84** DD **3,7267%** / OOS PF **1,32770** n **143** DD **3,9082%** (tick reali) | 🟢 **`400a462`, 08/08/2026 06:54** — **scritto nel file prova**, non ricavato | 🔴 **SEI**: `3af47ed` (**sizing**, 08/08 11:48) · `6074126` · `7f80a87` · `f8ebc32` · `872dba8` · `b45dd00` |
| **A3** | **`r127b`** | `ABTG_SupertrendReversal_Ottimizzato` · XAUUSD · H4 | `InpSLLookback` 1→13 (7) | 14 | 1,68 | **3** + **1** — asse d'uscita mai mosso (**5 in 290 CSV su 290**) **e il PF si legge per la PRIMA VOLTA** | DD **9,02%** · n **657** · PF **[NON MISURATO]** (R99, OHLC) | 🟡 **`f8ebc32`, 19/08/2026** — *ricavato*, non dichiarato in nessun file | 🔴 **`872dba8`** (08/09, **non** diagnostica: sposta il pavimento del lotto prima di `lotPend`) + `b45dd00` |
| **A4** | `r126b` | `ABTG_SuperWave_DOW_H1_Ottimizzato` · U30USD · H1 | `InpSLLookback` 1→13 (7) | 14 | 1,68 | **3** — secondo asse d'uscita sulla stessa sedia | la cella `lookback=5` = **la stessa configurazione** della cella `b=0` di A2 | 🟢 `400a462`, 08/08/2026 | 🔴 sei, come A2 |
| **A5** | `r126d` | **`ABTG_SuperWave`** (il generico!) · NASUSD · H1 | `InpSLBufferAtr` 0→1,0 (9) | 18 | 1,99 | **4** — **simbolo gemello** — + **3** | PF **1,02213** · n **97** · DD **3,3131%** (OHLC, finestra piena) | 🟡 `a4107cf`/`a86089c`, 26/07/2026 — *ricavato* | 🔴 sei + `a5d36d8` (11/08) |
| **A6** | `cemad05` | `ABTG_EMA200` · U30USD · H1 | `InpTF` **7 celle** (M15·M20·M30·H1·H2·H3·H4) | 14 | 1,68 | **5** — **il TF cambiato**, su l'unica delle 41 sedie vive che passa i cancelli alla lettera | G0-B: la cella H1 deve ridare OOS PF **1,52365** · DD **7,8323%** · **517 deal** (R112, tick reali) | 🟢 **`26a1856`, 19/08/2026** (pin R112 `f33f374`; il commit dopo è `b45dd00`) | 🟢 **UNO SOLO: `b45dd00`**, già letto e dichiarato diagnostica |
| | | | **BLOCCO A** | **94** | **10,84** | | | | |

### BLOCCO B — le sei di R120b / R120e, con rischio dichiarato (§5)

| # | round | configurazione pinnata | passate | T stim. | requisito |
|---|---|---|---:|---:|---|
| B1 | `r120b11` | trail **1** × flip **1** (= la sedia viva) | 4 | 0,91 | **3** — e chiude la riga a **ZERO** della Tabella B |
| B2 | `r120b00` | trail **0** × flip **0** (nuda) | 4 | 0,91 | **3** |
| B3 | `r120b01` | trail **0** × flip **1** | 4 | 0,91 | **3** |
| B4 | `r120b10` | trail **1** × flip **0** | 4 | 0,91 | **3** |
| B5 | `r120e11` | come B1 ma **`-Deposito 100000`** (l'unico delta = la **taglia**) | 4 | 0,91 | **3** |
| B6 | `r120e00` | come B2 ma `-Deposito 100000` | 4 | 0,91 | **3** |
| | | **BLOCCO B** | **24** | **5,45** | |

🔥 **Perché il blocco B vale più di quanto sembri da 4 passate a testa:** i
quattro `R120b` sono un **fattoriale 2×2 su `InpTrailOnST` × `InpExitOnFlip`**
— verificato riga per riga nei quattro file. Quella famiglia
(`InpTrailOnST`, `InpExitOnFlip`, `InpFirstFraction`) è **la riga a ZERO** della
Tabella B di `report/AUDIT_USCITE_2026-09-09.md`: su 32 meccanismi d'uscita
censiti, quei tre **non sono mai stati un asse**. Ancore: `REGISTRO_TEST.md`
r.476 (finestra piena PF **1,52** · n **227** · DD **4,0%**) e la corsa `r3` a
tick (IS PF 1,44 n 75 DD 4,77% / OOS PF 1,33 n 143 DD 3,91%), binario 🟡
`a4107cf` del **26/07/2026** — *ricavato, non dichiarato*.
🔴 E le loro ancore **restano «metro, non verdetto»**: sono le parole del file
prova, e sono quelle giuste. Per questo vanno **dopo** il blocco A.

### 💰 IL TOTALE, con la banda scritta onesta

| | passate | T col metro | banda dichiarata (**8–16×**) |
|---|---:|---:|---:|
| Blocco A | 94 | **10,8 min** | 1,4 – 2,9 h |
| Blocco B | 24 | **5,5 min** | 0,7 – 1,5 h |
| **NUOVE (A+B)** | **118** | **16,3 min** | **2,2 – 4,4 h** |
| le 7 già in coda (non mie) | 78 | 10,2 min | 1,4 – 2,7 h |
| **TUTTA LA NOTTE** | **196** | **26,5 min** | **3,5 – 7,1 h** |

🔴 **La banda va letta, non il numero singolo.** Il metro `0,6 + 0,077 × passate`
è tarato su **un** EA e **un** simbolo per round; qui ci sono **quattro EA** e
**cinque simboli**, cioè **fuori dal dominio di taratura**, e una misura
parallela di oggi dà fino a **8–16×** la stima. Più:
- 🔴 **lo scarico dei tick / delle barre M1 è `[NON MISURATO]`** e non entra in
  nessuna delle cifre qui sopra;
- ⚠️ **il round più esposto è `r127b`**: XAUUSD **22 anni** in OHLC M1. Per
  confronto misurato, R103 fece 25 sedie × 6,5 anni in **36 minuti** *«perché
  le barre M1 erano in gran parte già a disco»* — su 22 anni di oro quella
  premessa **non c'è**;
- ⏱️ e `ImbutoGiro()` di `b45dd00` gira **a ogni tick**: non cambia i risultati,
  può far salire l'orologio del tester. In ottimizzazione MT5 sopprime `Print`,
  quindi il costo lì è ~zero — ma se una notte sforasse, **questa è la riga da
  guardare**.

🟢 **Con 28 ore di finestra, anche il capo alto della banda (7,1 h) usa il 25%
del tempo.** Il vincolo che ci ha guidati per settimane — «~1 ora di notte» —
stanotte **non esiste**.

---

## ✅ 4. I CONTROLLI DEL MANDATO, uno per uno

### 4.1 🔴 `-FrazioneIS 0.50` — riverificato da me, non creduto

La riga sottile **non passa** `-FrazioneIS` e il driver ha default **0.40** →
taglio 40/60. Un round con criteri congelati a 50/50 sarebbe **non
attribuibile** (classe 268). Comando lanciato da solo:

```
grep -rl "FrazioneIS 0.50" backtest_pipeline/prove/
```

→ **23 file**, e sono: 3 `.md` di criteri (`R128_USCITA`, `R129_COSTO`,
`R130_LIVELLI`) + i **20** round, **tutti su D30EUR**, elencati **per nome**
(mai «tutto ciò che non è X», classe 180): `R128b` `R128c` `R128d` `R128e` ·
`R129a` `R129b` `R129c` · `R130a` `R130b` `R130c` `R130d` `R130e` · `R131a`
`R131b` `R131c` `R131d` `R131e` `R131f` `R131g` `R131h`.

🟢 **Nessuno dei 12. E nemmeno `cemad05`** (controllato esplicitamente, era la
richiesta). Di più, in positivo: `cemad05` **dichiara** *«split 40/60 —
IDENTICO a R112/R110»* a r.8, cioè chiede **proprio** il default; e `r126a`
r.298 scrive *«il driver taglia l'IS al 40% dei GIORNI»*. Non è solo
compatibile: è voluto.

### 4.2 Il conto delle celle di `cemad05` — il numero che mente

`controlla_prova.py` stampa **`celle=16374`** su `InpTF=16385||15||1||16388||Y`.
È sbagliato **per costruzione**: conta aritmeticamente. Su un **enum** MT5
ignora lo step e spazzola i **membri** fra start e stop, e il driver lo sa —
`walkforward_generico.ps1` r.622-626:

```
if($EnumMembri.ContainsKey($tipoP)){
  # ENUM: MT5 IGNORA LO STEP e spazzola i membri fra start e stop.
  $celle=@($EnumMembri[$tipoP] | Where-Object { $_ -ge $lo -and $_ -le $hi }).Count
```

Membri di `ENUM_TIMEFRAMES` fra 15 e 16388: **15 · 20 · 30 · 16385 · 16386 ·
16387 · 16388 = 7 celle → 14 passate.** 🟢 Coincide con quello che il file prova
dichiara da sé. Il numero da guardare sul VPS è quello che **il driver** stampa.

### 4.3 I due motivi per cui `cemad05` era stato bocciato: entrambi chiusi

| motivo | stato |
|---|---|
| (a) il pin di coda non portava quel file (**classe 265**) | 🟢 chiuso — ed è **più grave di come era scritto**: a `8027068f` il file è **assente**, a `fb9b4731`/`0c7d98af` è **presente ma nella versione superata** (§1.4) |
| (b) passava `-Deposito 10000` mentre il file dichiara `deposito 100000` a r.7 | 🟢 chiuso: la riga A6 porta **`-Deposito 100000`** |

### 4.4 🚫 `cemad02` — NON aggiunto, come da mandato

Asse gemello sul magic → **classe 129**. Non è in nessuno dei due blocchi.
🔴 **E applicando la stessa regola con la stessa mano**, ho trovato che **sette
dei dodici** hanno lo stesso asse gemello. È il §5.

### 4.5 📐 Campione in POSIZIONI, non in deal (classe 226)

Le ancore qui sopra sono riportate **nell'unità della loro fonte**, e due la
dichiarano in **deal**: `cemad05` («517 deal») e `r136a` («237 deal»). Con il
fattore misurato **1,000–2,314**, 517 deal possono essere anche solo **~223
posizioni**. 🔴 Il pavimento delle **150 operazioni** si legge in **posizioni**:
quindi *«517»* non autorizza da solo a dire «merito pieno».
🟢 **Ma il cancello dell'ancora funziona comunque**, e vale la pena dirlo: è un
confronto **della stessa colonna, dallo stesso driver, contro se stessa** —
l'unità non serve per confrontare, serve per **giudicare**. Per `r127c` il `394`
di R103 è nella colonna `Trades` di MT5: **quale unità sia è `[NON MISURATO]`**,
e non cambia il `±2%`.

---

## 🔴 5. LA COSA CHE IL MANDATO NON SAPEVA: SETTE DEI DODICI SONO GEMELLI

Il mandato dice di escludere `cemad02` perché *«ha un asse gemello sul magic e
cade nella classe 129»*. Applicando **quella stessa regola** ai dodici, misurato
file per file:

| round | asse spazzolato | 2 celle gemelle? | il file pretende identità? |
|---|---|---|---|
| `r126c` | `InpMagic=779320‖779320‖10‖779330‖Y` | **SÌ** | 🔴 *«se non escono IDENTICHE AL CENTESIMO il banco è sporco e **TUTTO R126 si ferma**»* |
| `r120b00/01/10/11` | `InpMagic=7832x0‖…‖7832x1‖Y` | **SÌ** | 🔴 *«G0 DETERMINISMO: le due passate gemelle devono […] altrimenti **IL ROUND È NULLO**»* |
| `r120e00/11` | `InpMagic=7835x0‖…‖7835x1‖Y` | **SÌ** | 🔴 idem |
| `r127c` `r127b` `r126a` `r126b` `r126d` `cemad05` | assi veri | **no** | — |

La classe 129 chiede **un solo agente locale MT5** (pannello Strategy Tester →
**Agenti**) per tutta la durata della riga. È un **passo a mano dentro MT5**: il
runner **non può farlo**, e non può nemmeno verificare che sia stato fatto.

### 5.1 🧪 Ma la CAUSA misurata della 129 qui non c'è — e questo cambia la decisione

La 129 non è un sospetto: fu **misurata** su `RIGA_POSTNEWS_ISM`, con un monitor
in tempo reale che vide **4 `metatester64.exe` vivi** a leggere **lo stesso
`Common\Files\<calendario>.csv` nello stesso istante**. 5 corse, 5 divergenze
diverse (39, 13, 20, 2, 7 operazioni). Disabilitati i core 2/3/4 → gemelli
**identici al centesimo**.

👉 Quindi il meccanismo è **la contesa su un file condiviso**. Misurato sui
sette: **`InpUseNewsFilter` = `false`/`0` in tutti e sette.** Nessuno legge il
calendario. 🟡 I gemelli **possono** uscire identici — non è garantito, è
possibile, e la configurazione degli agenti sul banco `C:\MT5_Backtest`
(50504400) è **`[NON MISURATO]`** da qui.

### 5.2 ⚖️ La decisione, e non è la stessa per tutti e sette

**Sei entrano (blocco B), uno resta fuori.** La differenza non è prudenza: è il
**contagio**, e sta scritta nei file.

| | se i gemelli divergono per classe 129 | costo |
|---|---|---|
| `r120b`×4, `r120e`×2 | il round si dichiara **nullo da sé**, e **nessun altro round ne viene toccato** | **0,91 min** su una finestra di **28 ore** |
| 🔴 **`r126c`** | per il suo stesso testo, **«TUTTO R126 si ferma PRIMA di qualunque altro numero»** → annulla **anche `r126a`, `r126b`, `r126d`** = **50 passate e tre dei sei round buoni** | catastrofico |

👉 `r126c` è **l'unico dei tredici il cui fallimento non costa se stesso, ma
altri tre**. Per questo la sua riga è consegnata **commentata**.

🟢 **E non lascia un buco**, perché il determinismo si legge comunque: la cella
`b=0` di `r126a` e la cella `lookback=5` di `r126b` sono **la stessa
configurazione** (lo dicono entrambi i file), e devono dare lo stesso numero —
**due letture da due corse separate**, che è un controllo più forte di due celle
dentro la stessa ottimizzazione.
📌 **Come si chiude `r126c`**: a mano sul PC di backtest con **un solo agente
locale**, prima o dopo la notte. Costa **4 passate**. La riga è pronta e
commentata in `RIGHE_PRONTE_WEEKEND_2026-09-12.txt`, blocco C.

---

## 🕳️ 6. I BUCHI DICHIARATI — tutti in un posto

1. 🔴 **Non ho compilato niente e non ho eseguito nessun backtest.** «Il diff è
   neutro» **non è** «compila». Resta vero il §6.2 del referto del WIP: il
   codice dell'imbuto di `b45dd00` **non è mai stato compilato da nessuno**.
   🟢 Ma con la toppa 270 dentro il pin, una compilazione fallita adesso
   **muore rumorosa** invece di girare il binario vecchio in silenzio.
2. 🔴 **Le 7 righe già in coda girano senza la toppa 270** (§1.3), e sul loro
   PASS non si può leggere un collaudo di `b45dd00`.
3. 🟡 **Due date di binario su sei sono RICAVATE da me, non scritte**:
   `f8ebc32` (`r127b`) e `a4107cf` (`r120b`/`r120e`/`r126d`), ottenute
   incrociando la data dell'artefatto d'ancora col `git log` del `.mq5`. È
   un'**inferenza**: se qualcuno ha un pin esplicito, vince il suo. Le due 🟢
   (`400a462` scritto nel file prova, `26a1856` unico commit possibile) sono
   più solide.
4. ⚠️ **Classe 267-bis su cinque round su sei**: fra l'ancora e oggi il binario
   è cambiato. 🟢 **E questo NON li rende illeggibili**: tutte le celle di un
   round girano sullo **stesso** binario, quindi **la forma dell'asse è
   valida** — muore **solo** il confronto con l'archivio. 🔴 **Non si buttano
   celle buone per un cambio di codice documentato e voluto.** Ordine dei
   sospetti su `r126a`/`r126b`: **`3af47ed` (sizing)** e **`872dba8`**, poi
   `f8ebc32`/`7f80a87`/`6074126`, e **`b45dd00` per ultimo** (ha l'alibi:
   30 hunk su 30 diagnostica).
5. 🔴 **La banda del costo è 8–16×, non un ±10%**, e lo scarico dei tick è
   `[NON MISURATO]` (§3).
6. ⚠️ **`r126a` avverte di un'interferenza e la lascio in piedi**: se `r120b`
   girasse e spostasse la cella di riferimento, `r126a` andrebbe rifatto sulla
   nuova base. 🟢 L'ordine A-prima-di-B la rispetta.
7. 🟡 **Su `r126a` il MERITO resta sospeso, ed è aritmetica, non opinione**: 227
   operazioni in tutta la storia disponibile **non si dividono in 150+150**.
   Il file lo scrive da sé, e corregge `PIANO_CHALLENGE_OTTOBRE.md` r.76 («n 227
   = MERITO PIENO»: quel 227 è della finestra **piena**, che non ha nessun fuori
   campione — spezzata fa **84 e 143**). 🔴 Il **RISCHIO** si legge comunque, a
   qualunque `n` (Emendamento B).
8. 🟡 **`r126a`/`r126b`/`r126c`/`r126d` girano su UN SOLO REGIME** (`@DAQUANDO
   2024.09.26` = il **muro dei tick** BCM su U30USD, misurato in
   `REFERTO_SONDA_STORICO_17-08.md`: il broker non ha più storico). Non si può
   allargare indietro: Dow prevalentemente al rialzo.
9. 🟢 **Nessun numero di questo referto è mio.** PF, n, DD, date e commit
   vengono tutti da un CSV, da un file prova o da un `git log` **citato per
   nome**. Gli unici conti miei sono aritmetica del metro (`0,6 + 0,077 × N`) e
   conteggi di celle. Dove manca il numero c'è **`[NON MISURATO]`**.

---

## 📤 7. COSA CONSEGNO, E COSA NON HO TOCCATO

**Consegnato:**
- `backtest_pipeline/righe/RIGA_SOTTILE_ROUND.ps1` — ri-pinnato (decimo giro),
  ASCII puro, 2 righe di codice cambiate, `controlla_riga.py` **0**,
  `VagliaScript` **ok=True corsia=ROUND**, 4 contro-esempi rifiutati;
- `backtest_pipeline/prove/R127c_orologio_EURJPY.txt` e
  `R127b_sllookback_XAUUSD.txt` — `-Modello` corretto (bloccante),
  `controlla_prova.py` **OK**;
- `backtest_pipeline/coda/RIGHE_PRONTE_WEEKEND_2026-09-12.txt` — **12 righe
  attive + 1 commentata**, nel formato esatto delle 7 esistenti, verificate
  facendo girare **il parser vero del runner** (12 accettate, 0 rifiutate);
- questo referto.

**NON toccato** (e verificato con `git status`):
🚫 `CODA.txt` · 🚫 `walkforward_generico.ps1` · 🚫 le 7 righe in coda e i loro
pin · 🚫 nessun EA, nessun `.mqh`, nessun preset, nessun parametro di rischio o
taglia (`[FIRMA DI CLAUDIO]`) · 🚫 nessun backtest eseguito, nessun forward
sfiorato.

🔴 **La coda la aggiorna chi ne ha il mandato, dopo il PASS del cancello di
giudizio.** Il file del §7 è un foglio da copiare: verificato che
`runner_abtg.ps1` r.96 legge **solo** `backtest_pipeline/coda/CODA.txt` e che
nessuno script del repo fa un glob su quella cartella.
