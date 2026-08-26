# 📬 R113 — **LA RIGA DA MANDARE** (prova di regime NASUSD_EXT: l'edge short vive nelle discese?)

**Round**: R113 — **L'EDGE SHORT SUL NASDAQ VIVE NELLE DISCESE?** (lettura:
**IPOTESI-S**). Un solo motore, la sedia più prop-friendly del parco indici:
`ABTG_SupRev_NAS_H1_Ottimizzato` su **NASUSD_EXT H1** (sedia viva **970913**,
che questo round **non tocca**). **3 celle × 6 finestre = 18 lanci**, ognuno
col gemello dentro (asse magic **+5**): **36 passate**.

| cella | lati | cos'è |
|---|---|---|
| `00_metro` | L+S | la sedia viva com'è — il contesto |
| `01_long` | solo L | il denominatore |
| `02_short` | solo S | **la domanda del round** |

| # | finestra | periodo | giudica |
|---|---|---|---|
| F0 | TORO | 2021.01.01 → 2021.12.31 | merito (controllo) |
| F1 | ORSO | 2022.01.01 → 2022.10.31 | merito + rischio |
| F2 | CROLLO | 2020.02.01 → 2020.04.30 | **SOLO rischio** (E.3) |
| F3 | CROLLO_ANNO | 2020.01.01 → 2020.12.31 | merito |
| F4 | LATERALE_NAS | 2015.01.01 → 2016.06.30 | merito + rischio |
| F5 | VECCHIA | 2011.01.01 → 2012.12.31 | **SOLO rischio** (regola B) |

Magic: `763500 + F×10 + C`, gemello +5 (blocco vergine **7635xx**, range usato
763500–763557). **Vietati e controllati nel codice**: 970913, tutto 7633xx
(R110), tutto 7634xx (R112).

**Criteri**: `risultati_archivio/R113_CRITERI.md` — ✅ **GIÀ FIRMATI** («**FIRMO
R113**», Claudio, 27/08/2026 notte): il **lucchetto della firma** è stato tolto
da **tutto il file** (titolo e § 9), quindi la corsa vera **parte da sola,
senza switch** — vedi il blocco 2, e **nessuno switch di bypass sta in questa
pagina** (checklist 82).
**Driver**: `righe/RIGA_R113_REGIME_NASUSD.ps1` (marcatore `MARCATORE_RIGA_R113_v1`).
**File prova**: `prove/R113_F<0-5>_{00_metro,01_long,02_short}.txt` — **diciotto**.

---

## 🧨 LA COSA PIÙ IMPORTANTE DA SAPERE PRIMA DI LEGGERE I NUMERI

**Questi sono dati di un ALTRO broker** (D-C): `NASUSD_EXT` è barre M1
importate (HistData), **senza tick reali BCM** — il banco è **OHLC su M1
(modello 1)**, e la differenza fra i banchi è **misurata**, non temuta
(SupRev_DOW_H4: PF 2,77 OHLC → 0,79 tick reali). Quindi:

> Si legge la **FORMA** dell'edge — verde/rosso, ordini di grandezza, dove il
> motore vive e dove muore — **MAI i numeri fini**. Confronti **SOLO
> _EXT-contro-_EXT** fra finestre. E **nessuna promozione può uscire da qui**
> (G5 per costruzione): la risposta a IPOTESI-S si spunta **a mano** nel
> referto del round, sulla griglia pre-dichiarata del § 6 (che il driver
> stampa **vuota**).

E le altre differenze dai round gemelli: **niente split IS/OOS** (finestre
UNICHE di regime: il driver scrive **da solo** gli .ini del tester, senza
`walkforward_generico`), **niente G0-B** (nessun numero da riprodurre su
_EXT), **niente peggior giornata / per-trade** (fuori perimetro), **pulizia
degli artefatti condivisi PER CELLA** (checklist 88: mai in blocco a inizio
corsa; una cella già fatta viene **raccolta con l'età dichiarata**, si rifà
solo con `-Rifai`).

### 💶 E LO SPREAD DI QUESTO BANCO È **NON MISURATO** — dichiarato, non dedotto

I criteri (§ 1 punto 3) chiedevano che *"il valore effettivo dello spread sia
**letto** e dichiarato nel referto"*. **Questo driver non può leggerlo** — sta
nella configurazione **binaria** del simbolo custom, non in un file di testo —
e allora lo **dichiara mancante**, che è la regola di casa (misurato, o
dichiarato mancante: **mai ipotizzato**). Due cose separate, e non vanno
confuse:

- ✅ **Quello che è VERIFICATO**: la riga `Spread=0` è **la stessa in tutti e 18
  gli `.ini`**, riletta nell'artefatto. Il banco è **identico fra le finestre
  per costruzione** → i confronti **_EXT-vs-_EXT** (l'unica lettura che i
  criteri permettono) **reggono comunque**.
- ❓ **Quello che NON è misurato**: quanti punti di spread paga davvero una
  operazione. `ABTG_ImportaStoricoEsterno.mq5` scrive `spread = 0` in **ogni
  barra M1** importata (riga 327) e **non** copia `SYMBOL_SPREAD` dal simbolo
  BCM. Quindi **o** il tester prende lo spread dalla barra — e allora questo
  banco è **senza attrito** — **o** ripiega su `SYMBOL_SPREAD` del custom. Non
  lo sappiamo, e il referto lo scrive così, con due nomi.

> **Perché conta**: non sposta il confronto fra finestre, ma **un edge SHORT
> giudicato su un banco forse senza attrito** è una cosa da sapere **prima** di
> leggere i PF, non dopo. Se Claudio vuole chiudere la domanda è **un gesto
> solo, un'altra volta**: in MT5 → *Vista → Simboli → `NASUSD_EXT` → campo
> Spread* (oppure *Specifiche del simbolo* nel tester). Non serve per far
> partire R113.

---

⚠️ **Il simbolo è CUSTOM**: se `NASUSD_EXT` non c'è nel terminale, il driver
si ferma **prima** di aprire MT5 con l'errore onesto *"NASUSD_EXT non trovato:
va reimportato con la Riga 2 dello storico"*. Se le barre ci sono ma il tester
dicesse comunque `symbol not exist`, la **registrazione** del simbolo è andata
persa (terminale ammazzato invece che chiuso): si riapre MT5 una volta a mano
o si rifà la Riga 2.

---

## 📌 IL PIN — ✅ ASSEGNATO il 27/08/2026 notte (commit col PASS del verificatore: 3 difetti FAIL->CORRETTO, checklist 89/89-bis/89-ter nate qui)

```
9ddf37b467db7999084991253f6d55ed698a0a7a
```

⚠️ **Il pin si rilegge DOPO il push, non prima** (checklist 6 e 55). Il commit
da pinnare deve contenere **TUTTI** gli artefatti che il driver riscarica al
pin: il driver, i **18** file prova `R113_F*_*.txt`, i criteri
`R113_CRITERI.md`, i **3 antenati** `R110_SUPNAS_{00_metro,01_long,02_short}.txt`
e — già in repo da prima, ma riscaricati lo stesso al pin —
`mql5/Experts/ABTG_SupRev_NAS_H1_Ottimizzato.mq5` e
`mql5/Include/ABTG_PausaGuardian.mqh`. (Niente `walkforward_generico.ps1`:
questo driver non lo usa.)

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester
  non gira (zero CSV); con MetaEditor aperto la compilazione torna subito
  **senza compilare**. La riga si rifiuta di partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA** (G5). Ma ⚠️ **questo round RICOMPILA il
  `.ex5` di una sedia che opera sul 100k**: backup datato mai sovrascritto di
  `.mq5` e `.ex5`, ripristino se la compilazione fallisce. Gli `.ini` girano
  con `AllowLiveTrading=false`, **verificato nell'artefatto** riletto.
- **36 passate** (18 lanci × 2 gemelle), **18 CSV** (uno per lancio: finestra
  unica, niente IS/OOS), `Model=1` (**OHLC su M1** — l'unico banco che esiste
  su _EXT), deposito 100.000, leva 100, **`Spread=0` scritto nell'ini** = nella
  convenzione di casa (R100/R102/R103) *spread **corrente** del simbolo*,
  **identico in tutti e 18 gli `.ini`** — e questo è **verificato
  nell'artefatto**, quindi i confronti fra finestre reggono per costruzione.
  ⚠️ **Il valore effettivo in punti è NON MISURATO**, vedi il riquadro qui sotto.
- **Zero parametri spazzolati**: l'unico asse `Y` è `InpMagic` (sweep a passo
  5: base e base+5). Finestra e lato cambiano **fra** i file, mai dentro.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks` né
  `bases\Custom` (il simbolo lo **controlla**, non lo costruisce). La cartella
  comune coi per-trade **non viene toccata** (fuori perimetro).
- ⏱️ **Durata attesa — È UNA STIMA, dichiarata tale**: 36 passate OHLC-M1 H1 su
  finestre da 3 a 24 mesi → **10–25 minuti** più la compilazione, **da
  verificare al primo giro** (nessun lancio OHLC su _EXT è mai stato
  cronometrato prima). `-OreMax 4` è un tetto **sull'inizio** dei lanci, non
  ammazza quello in corso.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata**)

> ⚠️ Non è a costo zero sul terminale: scarica gli artefatti al pin, installa
> `ABTG_PausaGuardian.mqh` e **COMPILA l'EA** (checklist 39). Quello che **non**
> fa: non apre MT5, non cancella nessun artefatto, **non misura nessun numero**
> — niente n, niente PF, niente G0-C. Scrive e **verifica gli STESSI 18 .ini**
> della corsa vera (checklist 33) e li mette nello zip: aprine uno e leggi
> `FromDate`/`ToDate`/`Model=1`/`Symbol=NASUSD_EXT`. G0-A (l'antenato) invece
> SÌ che gira: sta prima di MT5.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='9ddf37b467db7999084991253f6d55ed698a0a7a'; $p="$env:USERPROFILE\RIGA_R113.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R113_REGIME_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R113_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine (⚠️ gli attesi qui sotto sono **dichiarati dal
codice**, non copiati da un'esecuzione — il driver non è ancora mai girato sul
PC di backtest: al primo giro, se una riga non torna, fa fede il referto):

- `lanci ........................ 18` e `passate ...................... 36`;
- il riquadro giallo `LO SPREAD EFFETTIVO E' *NON MISURATO*` — **deve esserci**:
  è la dichiarazione del § qui sopra, e sta prima dei numeri apposta;
- `criteri: FIRMATI (nessun lucchetto nel file al pin)` — **e dev'essere
  questa**: se legge `NON FIRMATI` il file al pin è tornato col lucchetto, e
  la corsa vera si fermerebbe con codice 2;
- `18 file prova R113 + 3 antenati R110_SUPNAS scaricati al pin, righe vive verificate (46 / 45)`;
- `gate dell'ANTENATO: ... (catena R103 -> R110 -> R113)`;
- `gate della STELLA: dentro ogni finestra, long e short differiscono dal metro SOLO sul lato dichiarato (+ magic)`;
- `geometria d'identita', TF del grafico, LATI, finestre @DAQUANDO/@FINOA, asse unico e 36 magic vergini verificati NEI FILE`;
- `...mq5 al pin, version 1.00, InpMagic sorgente 970913, due lati + intestazione OPTFRAME a 8 colonne VERIFICATI NEL SORGENTE`;
- `simbolo   : NASUSD_EXT trovato (... MB in bases\Custom\history)` — se dice
  `MANCANTE`, prima si rifà la **Riga 2 dello storico**, poi si torna qui;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`, poi `COMPILATO`;
- in fondo: `.ini scritti e verificati in sosta: 18 su 18`, **nessun PROBLEMA
  in elenco** e `ESITO: GIRO A VUOTO COMPLETATO`.

---

## 2️⃣ POI la corsa vera — **le otto decisioni sono già firmate**

Il gate si apre da solo: il driver cerca il **lucchetto della firma** nel file
dei criteri **al pin, in tutto il file**, e nel file firmato («FIRMO R113»,
27/08 notte) non lo trova più — quindi questo blocco parte **senza switch**.

> ⚠️ **Se la corsa vera uscisse con codice 2**, non è un guasto: vuol dire che
> il file dei criteri al pin è tornato col lucchetto. **Si legge il documento,
> non si aggira il gate.** La *firma in riga* (`-CriteriFirmati`) esiste per
> il solo caso «file col lucchetto e firma data a voce», finisce scritta nel
> referto, e su un file già firmato è **inerte** (e il referto lo dice tale).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='9ddf37b467db7999084991253f6d55ed698a0a7a'; $p="$env:USERPROFILE\RIGA_R113.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R113_REGIME_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R113_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21).

> ⚠️ Nella corsa vera `exit 1` può voler dire *"la corsa è riuscita e c'è
> qualcosa da leggere nei PROBLEMI"*: gli artefatti **esistono** e vanno
> mandati lo stesso.

### 🔁 Se serve riprendere

**Una cella sola**: si riprende **da questa pagina** — si rilancia il **blocco
2 intero** aggiungendo alla riga `& $p -Pin $pin` la coda
`-SoloCella 'R113_F1_02_short.txt'` (fra apici; nomi validi: i diciotto
`R113_F<0-5>_{00_metro,01_long,02_short}.txt`). In R113 **nessuna cella è
denominatore di un'altra** (niente G0-B): `-SoloCella` lancia **solo quella**.
Le celle il cui CSV esiste già **non si rifanno**: vengono **raccolte con
l'età dichiarata** (checklist 88) — per rifarle si aggiunge `-Rifai`.
⚠️ **Ogni ripresa è il blocco intero con il suo `irm`** (checklist 42): `$p` e
`$pin` nascono dentro lo scope del blocco e una riga incollata da sola in una
console calda riuserebbe la copia e il pin **di prima**.

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

1. **`modo:`** — dice `CORSA` (il round) o `CONTROLLO` (giro a vuoto: **non è
   il round, non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto stantio.

---

## 📦 COSA MANDARE (cosa torna indietro)

Cartella e zip sul Desktop: `R113_REGIME_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_R113.txt`** ← **è questo che conta**: intestazione D-C con la
  frase fissa dei *dati di un altro broker* e il limite OHLC, lo spread
  dichiarato, la **tabella madre a 18 righe** (cella × finestra: profitto,
  PF, DD, **n in USCITE** con l'equivalenza *~2 uscite ≈ 1 posizione*
  stampata accanto, classe E.2, esito), l'**elenco file attesi vs trovati**,
  i gate cella per cella, i **metri G2** (INFO, verdetto a mano) e la
  **griglia IPOTESI-S stampata VUOTA** — si spunta **a mano nel referto del
  round**, mai dal driver;
- i **18 CSV** `R113_F*_*.csv` (2 righe l'uno: le gemelle di controllo);
- i **18 file prova al pin** + i **3 antenati R110_SUPNAS**: chi apre lo zip
  fra un mese rifà G0-A a mano senza tornare in repo;
- i **`gen_R113_*.ini` scritti-e-riletti** che hanno girato davvero (uno per
  lancio);
- `compile_SUPNAS.log`.

**MANDA IN CHAT QUESTO FILE**: lo **zip** `R113_REGIME_*.zip`.

---

## 🚦 LE TRE USCITE

| codice | vuol dire | cosa fare |
|---|---|---|
| **0** | OK / COMPLETO CON RILIEVI (i rilievi sono risultati o note — comprese le celle GIÀ FATTE raccolte con l'età dichiarata) | manda lo zip |
| **1** | parziale, fermato, con problemi, o selettore a vuoto | **manda lo zip lo stesso** e leggi i PROBLEMI |
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
F=backtest_pipeline/righe/RIGA_R113_DA_MANDARE.md
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|" "$F"
grep -c "\$pin='$SHA'" "$F"    # DEVE dare 2   <- i punti d'uso (i 2 blocchi powershell)
grep -c "$TOK" "$F"            # DEVE dare 0   <- nessun segnaposto rimasto
```

⚠️ **Servono TUTTI E DUE i conteggi.** Il solo *"0 segnaposti rimasti"* lo
supera a mani basse anche un `sed` che **non ha matchato niente** (il
guardiano decorativo del punto 14 applicato a un `sed`). E quando il pin è
assegnato, va aggiornato anche il titolo del riquadro qui sopra (da «NON
ANCORA ASSEGNATO» ad «ASSEGNATO il …»): è prosa, si fa a mano.

**Ri-pinnatura** (checklist 77-bis — il pin si rifà più spesso di quanto si
creda). Il pin vecchio si legge **dai punti d'uso** (`$pin='<40 caratteri>'`),
mai con un `grep` largo: le menzioni in prosa di un pin bruciato sono
**storia** e non si toccano.

```bash
NUOVO=<lo sha nuovo, 40 caratteri>
F=backtest_pipeline/righe/RIGA_R113_DA_MANDARE.md
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 2
grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
```

⚠️ Il conteggio atteso si **riconta sulla pagina vera** a ogni ri-pinnatura
(la pagina intanto può essersi riempita di storia — pin bruciati in tabella).

### E la firma dei criteri

Il gate del driver cerca una **stringa letterale** dentro `R113_CRITERI.md`,
in **tutto il file**. I criteri sono **già firmati** (27/08 notte): il
controllo è un conteggio, non un colpo d'occhio (il token si compone, mai
scritto per esteso — checklist 82), e **deve restare a zero**:

```bash
TOKF='[DA '"FIRMARE]"
F=backtest_pipeline/risultati_archivio/R113_CRITERI.md
grep -cF "$TOKF" "$F"    # oggi, a criteri FIRMATI: DEVE dare 0
```

E si prova **nei due versi** (checklist 82): col lucchetto tolto la corsa vera
deve **partire senza switch**; col lucchetto rimesso deve tornare a **uscita 2**.
