# 📬 R112 — **LA RIGA DA MANDARE** (il contratto dell'EMADOW: short-only, e a quale dial?)

**Round**: R112 — **LA SEDIA EMADOW VA MESSA A CONTRATTO SHORT-ONLY? E A QUALE DIAL DI RISCHIO?**
Una sola famiglia, la più grassa di casa: `ABTG_EMA200` su **U30USD H1** (sedia
viva **771531**, 0,65% in campo sul 100k). **Quattro celle**:

| cella | lati | dial (`InpRiskPercent`) | magic gemelli | cos'è |
|---|---|---|---|---|
| `00_metro` | L+S | 1,0 | 763400/763401 | **la sedia viva com'è** — denominatore, G0-C, G0-B, e la SUA peggior giornata |
| `01_short_r1` | solo S | 1,0 | 763410/763411 | lo short di R110 riprodotto — **il gate del banco (G0-B)** |
| `02_short_r2` | solo S | **2,0** | 763420/763421 | la scala del dial, primo gradino |
| `03_short_r3` | solo S | **3,0** | 763430/763431 | il gradino di pari-DD atteso (7,83/2,66 ≈ 2,9) |

**Criteri**: `risultati_archivio/R112_CRITERI.md` — ✅ **FIRMATI** ("**FIRMO
R112**", Claudio, 26/08/2026 sera — commit `f2a5764`): il **lucchetto della
firma** è stato tolto da **tutti e due** i punti in cui stava (titolo e § 10),
quindi la corsa vera **parte da sola**, senza switch — vedi il blocco 2.
**Driver**: `righe/RIGA_R112_EMADOW_CONTRATTO.ps1` (marcatore `MARCATORE_RIGA_R112_v1`).
**File prova**: `prove/R112_*.txt` — **quattro**.

---

## ❓ COSA MISURA, E PERCHÉ — in due righe

1. **Il contratto**: R110 ha misurato che il lato short dell'EMADOW fa **PF OOS
   1,891 (n 302) con DD 2,66%** contro il 7,83% della sedia intera — questo round
   misura se la sedia va messa **short-only**, e **a quale dial** (1/2/3%,
   congelati PRIMA dei numeri nuovi, derivazione dichiarata nei criteri § 0).
2. **La peggior giornata**: mai misurata su questa sedia — né sul metro né sui
   lati. Esce dai **per-trade** che l'EA scrive nella cartella comune, in **due
   denominatori** (100k fisso ed equity di inizio giornata), **solo OOS** —
   ed è la peggior giornata dei **CHIUSI**: il muro delle prop guarda il
   **FLOTTANTE**, questa è un **pavimento** (dichiarato in ogni tabella).

**Non è un'ottimizzazione** (nessun parametro del motore si muove: si muove il
CONTRATTO — lato e rischio), **non è un deploy** (G5: la sedia 771531 non si
tocca, il verdetto è del referto del round e la delibera è una firma separata).

---

## 🧨 LA COSA PIÙ IMPORTANTE DA SAPERE PRIMA DI LEGGERE I NUMERI

**G0-B stavolta È APPLICABILE, ed è FATALE** (decisione D3 — è la prima volta da
quando esiste questa macchina). R110 e R112 girano su **stesso banco** (modello
4, tick reali), **stessa finestra** (2024.09.26 → 2026.06.30), **stesso split**
(40/60), **stessi input** (il magic non tocca la logica). Quindi:

> `00_metro` e `01_short_r1` devono **riprodurre al centesimo** i CSV di R110
> archiviati al pin in `prove/R110_CSV_EMADOW/` — le **7 colonne statistiche**
> delle 2 righe gemelle, **identiche come stringhe**, IS e OOS.

Tre esiti, e non due (checklist 68): **OK** / **MISMATCH** (fatale: il banco non
è riproducibile fra corse — una notizia più grossa del round, la raccolta si fa
lo stesso e lo dichiara) / **NON ESEGUITO** (CSV mancante: un guasto, **non**
"superato"). Le celle `r2`/`r3` non hanno riferimento: sono la misura **nuova**.

E la seconda cosa: **la peggior giornata IS è `n/d` PER COSTRUZIONE** su tutto
il round. Le gambe girano IS poi OOS e l'export **sovrascrive** il file del
magic: sopravvive l'ultima. Il driver **non lo assume — lo misura** sulle
`close_time` (una sola chiusura prima dell'inizio OOS ⇒ `n/d`, mai un numero
sbagliato). Le date sono **in ora server BCM** (ora italiana − 1).

---

## 📌 IL PIN — ⚠️ **PIN DA ASSEGNARE** (la pagina esce col segnaposto)

```
@@PIN@@
```

⚠️ **Il pin si rilegge DOPO il push, non prima** (checklist 6 e 55). Il commit da
pinnare deve contenere **TUTTI** gli artefatti che il driver riscarica al pin:
il driver, i **4** file prova `R112_*.txt`, i criteri, i **2 antenati R110**
(`R110_EMADOW_00_metro.txt`, `R110_EMADOW_02_short.txt`), **i 4 CSV di
riferimento G0-B in `prove/R110_CSV_EMADOW/`**
(`ABTG_EMA200_U30USD_{IS,OOS}_{00_metro,02_short}.csv`) e — già in repo da
prima, ma il driver li riscarica lo stesso al pin — `walkforward_generico.ps1`,
`mql5/Experts/ABTG_EMA200.mq5`, `mql5/Include/ABTG_PausaGuardian.mqh`.
🔴 **Storia di un difetto già riparato**: i CSV di riferimento erano stati
committati sotto un **percorso raddoppiato**
(`prove/backtest_pipeline/prove/R110_CSV_EMADOW/` — commit `460d615`). Lo
spostamento al percorso giusto è **committato** in `d5df1a8` (`git mv`), e il
percorso raddoppiato **non esiste più nell'albero** — verificato dal
verificatore il 26/08 con `git ls-tree -r`. Resta valido il motivo per cui la
cosa conta: se un CSV di riferimento mancasse al pin, il driver si fermerebbe
allo scarico dei riferimenti, e fermarsi lì è il comportamento giusto.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** Magic **vergini, blocco `7634xx`**
  (verificato sul repo il 26/08). Sono **vietati e controllati nel codice**:
  `771531` (sedia viva), `771501` (sorgente) e **tutto il blocco `7633xx`**
  (bruciato da R110) — il blocco è vietato come *range*, non come elenco.
- ⚠️ **QUESTO ROUND RICOMPILA IL `.ex5` DI UNA SEDIA CHE OPERA SUL 100K.**
  Backup datato e mai sovrascritto del `.mq5` e del `.ex5`; se la compilazione
  fallisce il `.mq5` viene rimesso com'era. Gli `.ini` girano con
  `AllowLiveTrading=false`, e il driver **conta** che ci sia (2 righe).
- **16 passate** (4 celle × 2 finestre × 2 gemelle), **8 CSV**, **8 file
  per-trade**, `Model=4` (**tick reali**), finestra **2024.09.26 → 2026.06.30**,
  split 40/60, deposito 100.000.
- **Zero parametri spazzolati**: l'unico asse `Y` è `InpMagic`. Il dial cambia
  **fra** le celle, mai **dentro** una cella.
- 🧹 **Prima della corsa vera** il driver **cancella dalla cartella comune** ogni
  `abtg_trades_ABTG_EMA200_U30USD_7634*.csv` avanzato (e dice quanti ne ha
  tolti): un per-trade vecchio non deve passare per fresco. Dopo ogni cella
  **pretende file freschi** (`LastWriteTime` ≥ avvio cella): mancante o vecchio
  ⇒ peggior giornata **`n/d` col motivo**, mai zero.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`.
- ⏱️ **Durata attesa [STIMA]: 30-45 minuti** (8 gambe a tick reali, ~3-4 min
  l'una in R110) più la compilazione. `-OreMax 10` è un tetto sull'**inizio**.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata**)

> ⚠️ Non è a costo zero sul terminale: scarica gli artefatti al pin, installa
> `ABTG_PausaGuardian.mqh` e **COMPILA l'EA** (checklist 39). Quello che **non**
> fa: non apre MT5, non cancella nessun artefatto, **non misura nessun numero**
> — niente n, niente PF, **niente G0-B, niente G0-C, nessuna peggior giornata**.
> Conferma gli **artefatti**; G0-A (l'antenato) invece SÌ: gira prima di MT5.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R112.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R112_EMADOW_CONTRATTO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R112_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** — ⚠️ le righe qui sotto sono **copiate dall'output vero**
(checklist 70), eseguendo il driver il 26/08:

```
    celle ........................  4   (di cui METRO: 1)
    CSV attesi ...................  8   (IS + OOS per cella)
    righe per CSV ................  2   (le due gemelle di controllo)
    passate ......................  16
    file per-trade attesi ........  8   (2 magic gemelli per cella, dalla cartella comune)
    IS  2024.09.26 -> 2025.06.09
    OOS 2025.06.10 -> 2026.06.30
```

E poi, in ordine:

- `criteri: FIRMATI (nessun lucchetto nel file al pin)` — **e dev'essere
  questa**: se legge `NON FIRMATI` il file dei criteri al pin è tornato col
  lucchetto, e la corsa vera si fermerebbe con codice 2;
- `driver generico PINNATO (...), MaxBars alzato, AllowLiveTrading=false x2`;
- `4 file prova + 2 antenati R110 + 4 CSV riferimento G0-B scaricati al pin, righe vive verificate (46 ovunque)`;
- `gate dell'ANTENATO: ogni cella e' la copia riga per riga del suo file prova R110, salvo i delta dichiarati (catena R103 -> R110 -> R112)`;
- `gate della STELLA: ogni cella short differisce dal 00_metro SOLO su lato/dial dichiarati (+ magic)`;
- `geometria d'identita', TF del grafico, LATI, DIAL, asse unico e 8 magic vergini verificati NEI FILE`;
- `ABTG_EMA200.mq5 al pin, version 1.00, InpMagic sorgente 771501 (la sedia gira su 771531), lati + dial + export per-trade VERIFICATI NEL SORGENTE` — i tre
  magic diversi (sorgente / sedia / file prova) **sono corretti**;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`, poi `COMPILATO`;
- in fondo: `anteprime .ini in sosta: 4 su 4`, **nessun PROBLEMA in elenco** e
  `ESITO: GIRO A VUOTO COMPLETATO`.

---

## 2️⃣ POI la corsa vera — **le sei decisioni sono già firmate**

Il gate si apre da solo: il driver cerca il **lucchetto della firma** nel file
dei criteri **al pin, in tutto il file**, e nel file firmato ("FIRMO R112",
26/08 sera) non lo trova più — quindi questo blocco parte **senza switch**, e
**nessuno switch di bypass sta in questa pagina** (checklist 82: uno switch
lasciato "tanto è innocuo" diventa un bypass permanente).

> ⚠️ **Se la corsa vera uscisse con codice 2**, non è un guasto: vuol dire che
> il file dei criteri al pin è tornato col lucchetto. **Si legge il documento,
> non si aggira il gate.** La *firma in riga* (`-CriteriFirmati`) esiste per il
> solo caso "file col lucchetto e firma data a voce", finisce scritta nel
> referto, e su un file già firmato è **inerte** (e il referto lo dice tale).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R112.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R112_EMADOW_CONTRATTO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R112_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21).

> ⚠️ Nella corsa vera `exit 1` può voler dire *"la corsa è riuscita e la
> risposta non ti piace"* (o G0-B in MISMATCH — che È la risposta del giro):
> gli artefatti **esistono** e vanno mandati lo stesso.

### 🔁 Se serve riprendere

**Una cella sola**: si riprende **da questa pagina** — si rilancia il **blocco 2
intero** aggiungendo alla riga `& $p -Pin $pin` la coda
`-SoloCella 'R112_02_short_r2.txt'` (fra apici; nomi validi: i quattro
`R112_*.txt` della tabella in testa). Per rifare CSV già presenti si aggiunge
`-Rifai`. ⚠️ **Ogni ripresa è il blocco intero con il suo `irm`** (checklist
42): `$p` e `$pin` nascono dentro lo scope del blocco e una riga incollata da
sola in una console calda riuserebbe la copia e il pin **di prima**.
In **tutti** i casi il `00_metro` **rigira**: è il denominatore e porta G0-B e
G0-C. Costa 2 CSV, non una passata sprecata.

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

1. **`modo:`** — dice `CORSA` (il round) o `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto stantio.

---

## 📦 COSA MANDARE (cosa torna indietro)

Cartella e zip sul Desktop: `R112_EMADOW_CONTRATTO_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_R112.txt`** ← **è questo che conta** (tabella madre con le DUE
  colonne nuove `PeggGio%fisso` e `PeggGio%eq`, i gate cella per cella, le
  letture INFO (a)(b)(c)(d) del cancello di portafoglio — il verdetto è a mano).
  ⚠️ **Quando si applica il cancello a mano, si guarda il SEGNO**: il DD di (b)
  è un numero **positivo** (più basso = meglio), la peggior giornata di (c) è un
  numero **negativo** perché è una perdita (`-0,37%` è **peggio** di `-0,31%`).
  Il `≤` del § 6 dei criteri è scritto sulla **profondità** della perdita:
  applicato alle cifre col segno così come sono stampate **rovescia** il
  criterio (c). Il referto lo ripete su ogni riga (c);
- gli **8 CSV** di ottimizzazione (2 righe l'uno: le gemelle di controllo);
- gli **8 file per-trade** `pertrade_<cella>_<magic>.csv` (la materia prima
  della peggior giornata);
- i **4 file prova al pin** + i **2 antenati R110** + i **4 CSV di riferimento
  G0-B** (`RIF_R110_*.csv`): chi apre lo zip fra un mese rifà G0-A e G0-B a mano
  senza tornare in repo;
- i **`gen_*.ini` rigenerati-verificati** che hanno girato davvero (2 per
  cella): il driver ne rilegge `FromDate`/`ToDate` dall'artefatto;
- `compile_EMADOW.log`;
- (solo nel giro a vuoto) le **4 anteprime `.ini`**.

**MANDA IN CHAT QUESTO FILE**: lo **zip** `R112_EMADOW_CONTRATTO_*.zip`.

---

## 🚦 LE TRE USCITE

| codice | vuol dire | cosa fare |
|---|---|---|
| **0** | OK / COMPLETO CON RILIEVI (i rilievi sono risultati, non guasti) | manda lo zip |
| **1** | parziale, fermato, con problemi, **G0-B MISMATCH** (fatale ma la raccolta c'è tutta), o selettore a vuoto | **manda lo zip lo stesso** e leggi i PROBLEMI |
| **2** | **il file dei criteri al pin porta il lucchetto** (solo la corsa vera; il giro a vuoto parte comunque). Coi criteri già firmati NON deve succedere: se succede, il file è **tornato** col lucchetto | si legge il documento, **non** si aggira il gate |

---

## 🔧 PER LA SESSIONE (non per Claudio) — assegnare il pin

La pagina esce con un **segnaposto** al posto del commit. Va sostituito nei
**punti d'uso**, mai su tutta la pagina (una `sed` larga riscriverebbe anche
questa spiegazione, e la ricetta morirebbe al secondo giro — checklist 77).
Il token si **compone** in una variabile, così la ricetta non contiene mai la
stringa che sta cercando.

```bash
cd ~/GITHUB && git pull --rebase --autostash
SHA=$(git rev-parse HEAD)
F=backtest_pipeline/righe/RIGA_R112_DA_MANDARE.md
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|" "$F"
grep -c "\$pin='$SHA'" "$F"    # DEVE dare 2   <- i punti d'uso (i 2 blocchi powershell)
grep -c "$TOK" "$F"            # DEVE dare 0   <- nessun segnaposto rimasto
```

⚠️ **Servono TUTTI E DUE i conteggi.** Il solo *"0 segnaposto rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente** (il guardiano
decorativo del punto 14 applicato a un `sed`).

**Ri-pinnatura** (checklist 77-bis — il pin si rifà più spesso di quanto si
creda). Il pin vecchio si legge **dai punti d'uso** (`$pin='<40 caratteri>'`),
mai con un `grep` largo: le menzioni in prosa di un pin bruciato sono **storia**
e non si toccano mai.

```bash
NUOVO=<lo sha nuovo, 40 caratteri>
F=backtest_pipeline/righe/RIGA_R112_DA_MANDARE.md
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 2
grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
```

⚠️ Il conteggio atteso si **riconta sulla pagina vera** a ogni ri-pinnatura (la
pagina intanto può essersi riempita di storia — pin bruciati in tabella).

### E la firma dei criteri

Il gate del driver cerca una **stringa letterale** dentro `R112_CRITERI.md`, in
**tutto il file**. I criteri sono **già firmati** (26/08 sera): prima della
firma il lucchetto stava in **due punti** (titolo e § 10), e firmare ha voluto
dire toglierlo **da tutto il file**. Il controllo è un conteggio, non un colpo
d'occhio (il token si compone, mai scritto per esteso — checklist 82), e **deve
restare a zero**:

```bash
TOKF='[DA '"FIRMARE]"
F=backtest_pipeline/risultati_archivio/R112_CRITERI.md
grep -cF "$TOKF" "$F"    # oggi, a criteri FIRMATI: DEVE dare 0 (prima della firma dava 2)
```

✅ Nota d'igiene (checklist 45/82), **già chiusa**: i commenti in testa ai quattro
file prova `R112_*.txt` erano stati scritti prima della firma e nominavano il
lucchetto per esteso; sono stati ripuliti in `521ceec`. Verificato dal
verificatore il 26/08: il token **non compare in nessuno** dei quattro file
prova, né nel driver, né in questa pagina (dove è **composto**, mai scritto
intero — così un `grep` per spegnere lo stato non trova la ricetta stessa).

E si prova **nei due versi** (checklist 82): col lucchetto tolto la corsa vera
deve **partire senza switch**; col lucchetto rimesso deve tornare a **uscita 2**.
