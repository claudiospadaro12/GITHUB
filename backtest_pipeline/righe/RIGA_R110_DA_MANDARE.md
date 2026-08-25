# 📬 R110 — **LA RIGA DA MANDARE** (i lati mai misurati dei motori VIVI sugli indici)

**Round**: R110 — **DA QUALE LATO VIENE L'EDGE DELLE SEDIE CHE GIÀ GUADAGNANO?**
Quattro motori vivi che girano **long+short nella stessa cella**, e il cui lato
short **non ha mai avuto un numero suo**:

| famiglia | EA | simbolo / TF | sedia viva |
|---|---|---|---|
| **SUPNAS** ⭐ | `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD **H1** | 970913 |
| **SUPDAX** | `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR **H4** | 970912 |
| **SWDOW** | `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD **H1** | 770511 |
| **EMADOW** 🔥 | `ABTG_EMA200` | U30USD **H1** | 771531 |

**Perimetro**: `risultati_archivio/CENSIMENTO_LATI_SHORT_2026-08-25.md` — tabella
**1d** e § 5, **punti 1 e 2** della lista ordinata.
**Criteri**: `risultati_archivio/R110_CRITERI.md` — ⚠️ **[DA FIRMARE]**, 5 decisioni.
**Driver**: `righe/RIGA_R110_LATI_VIVI.ps1` (marcatore `MARCATORE_RIGA_R110_v1`).
**File prova**: `prove/R110_*.txt` — **dodici** (3 per famiglia).

---

## ❓ LA DOMANDA — è di Claudio, ed è della sera del 25/08

> Dopo i verdetti short di R107 (0 su 3): _"non si possono provare i vari motori?"_

**Aveva ragione a non accontentarsi.** R107 ha misurato il lato short di **una
sola famiglia di motori** — il breakout/retest d'apertura su M5. Il parco ne ha
**altri nove** che girano simmetrici e che nessuno ha mai smontato. R110 ne
prende **quattro**, e sono quelli **già vivi sul conto 100k**.

**Non è una caccia e non è una griglia.** Qui non si cerca un motore nuovo: si
**smonta un motore che già guadagna** per sapere da dove viene quello che
guadagna. Zero righe di MQL5, zero parametri spazzolati.

### 🔥 Perché EMADOW è la riga più importante del round

**712 operazioni in R103.** È il campione più grasso di tutta la flotta indici, e
**l'unico posto del parco dove un lato da solo può arrivare a n ≥ 150** su questa
finestra — cioè dove l'Emendamento regola A può essere **soddisfatto** invece che
invocato. Su tutte le altre il merito nascerà **sospeso**.

---

## 🔴 IL CANCELLO DELLA FIRMA — **è CHIUSO, e va aperto da Claudio**

`R110_CRITERI.md` porta `[DA FIRMARE]` nel titolo. Il driver **lo legge al pin**:

- il **giro a vuoto parte lo stesso** (non apre MT5, non produce nessun numero);
- la **corsa vera si ferma con `exit 2`**, a meno di `-CriteriFirmati`.

**Le cinque decisioni** (§ 10 dei criteri, tutte con la proposta già scritta):

| | decisione | proposta |
|---|---|---|
| **D1** | quali famiglie entrano | **QUATTRO**. `SupRev DAX H1` (970911) **NO**: è **MISURATO** che non è in nessuno dei due censimenti `.chr` (23/08 e 25/08), non ha file prova R103, non ha numero R103, non ha preset. Il suo metro andrebbe **ricostruito**, e una cella ricostruita non è la cella viva |
| **D2** | il cancello di merito sui lati | **quello di R54**: PF OOS ≥ 1,10 **E** positivo in IS — lo stesso con cui R107 ha appena giudicato tre short |
| **D3** | il metro numerico che **non c'è** | **G0-B `NON APPLICABILE` e dichiarato**. R103 girava a **OHLC M1 su finestra unica**, qui è **tick reali con split 40/60**: non c'è niente da riprodurre. Al suo posto mordono **G0-A (antenato)** e **G0-C (gemelli)** |
| **D4** | tre celle per famiglia o due? | **TRE** (metro + long + short). Il metro costa 8 passate in tutto e in cambio dà l'unico ancoraggio verificabile del round, il denominatore vero e la misura dello sbilancio dei lati |
| **D5** | se una famiglia non passa G0-A o G0-C | **quella famiglia si ferma, le altre tre vanno avanti** (come R100, R101, R107) |

> 🚦 **E RESTA IL CANCELLO DEL TRAFFICO: una macchina, un lavoro.** Il PC di
> backtest ha un solo MT5. ⚠️ **R109 è in coda sulla stessa macchina**: R110
> parte **solo quando nessun altro round sta toccando il terminale**.

---

## 🧨 LA COSA PIÙ IMPORTANTE DA SAPERE PRIMA DI LEGGERE I NUMERI

**In R110 non esiste nessun metro numerico da riprodurre. Su nessuna delle
quattro famiglie.** E non è pigrizia: è aritmetica.

| | R103 (dove stanno i numeri di queste sedie) | R110 (questo round) |
|---|---|---|
| modello | **1 = OHLC su M1** | **4 = TICK REALI** |
| finestra | **una sola**, 21 mesi pieni | **due**: IS 40% / OOS 60% |

E `walkforward_generico.ps1` (righe 465-468) **spezza sempre** in IS/OOS: la
finestra unica di R103 con questo strumento **non è nemmeno eseguibile**.
E se lo fosse non varrebbe: che sugli indici OHLC e tick reali **non** diano lo
stesso numero è **MISURATO** — `SupRev_DOW_H4` fece **PF 2,77 in OHLC** e
**PF 0,79 a tick reali**, e quel contratto fu **REVOCATO**.

➡️ Quindi nel referto i numeri R103 compaiono **etichettati `CONTESTO, NON UN
METRO`**, e il verdetto G0-B dice **`NON APPLICABILE`**.
🔴 **`NON APPLICABILE` NON È `SUPERATO`**: su questo round nessuno può dimostrare
*guardando i numeri* che il banco è sano. Quello che **si dimostra** è:

- **G0-A · IL GATE DELL'ANTENATO** — ogni cella è la copia **riga per riga** del
  file prova R103 di quella sedia, salvo i delta dichiarati. Gira **prima** di
  aprire MT5, e prende anche la **corruzione simmetrica** (la stessa riga storta
  in tutte e tre le celle) che il gate della stella **non può vedere**;
- **G0-C · I GEMELLI** — le due righe del CSV identiche al centesimo: dimostra
  che il banco è **deterministico**, non che è giusto.

---

## ⚠️ E LA SECONDA COSA: **la somma dei due lati NON fa il metro**

**MISURATO NEL SORGENTE**, non dedotto. Tutti e quattro i motori aprono la
funzione di ingresso con *"se ho già una posizione (o un pendente) esco"* — e
**solo dopo** guardano il lato (`ABTG_EMA200.mq5` riga 185, i tre SupRev/SuperWave
righe 173-180).

➡️ Nel metro un segnale short che arriva mentre è aperta una posizione **long**
viene buttato via; nella cella `02_short` quello slot è **libero** e quel segnale
**entra**. Quindi **`n(long) + n(short) ≠ n(metro)`**, ed è un **fatto del
motore**, non un guasto del banco. Il referto stampa i tre `n` accanto apposta.

**Corollario che conta per il verdetto**: il lato long da solo **non è la sedia
viva**, e nemmeno il lato short. Sono **tre celle diverse**, e la sedia è la prima.

---

## 📌 IL PIN — **`@@PIN@@`**

```
@@PIN@@
```

⚠️ **Il pin si rilegge DOPO il push, non prima** (checklist 6 e 55). Il commit da
pinnare deve contenere **tutti e diciotto** gli artefatti: il driver, i **dodici**
file prova, i criteri, e i **quattro file prova ANTENATI di R103** (che il driver
riscarica al pin per il gate G0-A). Se il verificatore corregge qualcosa, questo
blocco va **ripinnato e questa riga riscritta**.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

### 🔧 LA RICETTA DEL PIN — **prima pinnatura** (checklist 77)

Il segnaposto è in **7 punti**: **5** blocchi di lancio, il riquadro e il titolo.
La ricetta **compone il token in una variabile**, così non contiene mai la
stringa che sta cercando (altrimenti si riscriverebbe da sola), e tocca **solo i
punti d'uso** — la prosa che spiega deve restare leggibile anche dopo.

```bash
F=backtest_pipeline/righe/RIGA_R110_DA_MANDARE.md
SHA=<il commit vero, 40 caratteri>
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|; s|\*\*\`$TOK\`\*\*|\*\*\`$SHA\`\*\*|g" "$F"
grep -c "\$pin='$SHA'" "$F"   # DEVE dare 5   <- i punti d'uso
grep -c "$TOK" "$F"           # DEVE dare 0   <- nessun segnaposto rimasto
```

⚠️ **Servono TUTTI E DUE i conteggi.** Il solo *"0 segnaposto rimasti"* lo supera
a mani basse anche un `sed` che **non ha matchato niente**: è il guardiano
decorativo del punto 14 applicato a un `sed`.
✅ **Provata su una copia della pagina prima di scriverla qui**: 7 → 5 + 1 + 1, e
`0` segnaposto residui.

### ♻️ E LA RICETTA DI **RI-PINNATURA** (checklist 77-bis) — perché il pin si rifà

```bash
F=backtest_pipeline/righe/RIGA_R110_DA_MANDARE.md
NUOVO=<il commit nuovo, 40 caratteri>
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|; s|\*\*\`$VECCHIO\`\*\*|\*\*\`$NUOVO\`\*\*|g" "$F"
grep -c "\$pin='$NUOVO'" "$F"    # DEVE dare 5
grep -c "\$pin='$VECCHIO'" "$F"  # DEVE dare 0
```

⚠️ **Il pin vecchio si legge DAI PUNTI D'USO** (`$pin='<40 caratteri>'`), mai con
un `grep` largo: in pagina i pin compaiono anche **abbreviati**, e un `sed` largo
**riscrive la STORIA** — una riga come *"il pin X è BRUCIATO"* diventerebbe *"il
pin \<quello NUOVO\> è BRUCIATO"*, cioè l'esatto contrario del vero.
✅ **Provata anche questa su una copia**, con una riga di storia dentro: i 5 punti
d'uso cambiano, **la riga di storia resta intatta**.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira (zero CSV); con MetaEditor aperto la compilazione torna subito **senza
  compilare**. La riga si rifiuta di partire in tutti e due i casi.
- **NESSUNA SEDIA VIVA VIENE TOCCATA.** I magic sono **vergini, blocco `763xxx`**:
  i **24** numeri sono stati cercati **uno per uno** in tutto il repo il 25/08 →
  **zero occorrenze**. Sono **vietati e controllati nel codice** i quattro magic
  vivi (`970913`, `970912`, `770511`, `771531`), il default del sorgente EMA200
  (`771501`) e anche **`970911`** — *un'identità non in campo resta occupata*.
- ⚠️ **QUESTO ROUND RICOMPILA I `.ex5` DI QUATTRO SEDIE CHE OPERANO SUL 100K.**
  Il driver fa un **backup datato e mai sovrascritto** del `.mq5` **e** del `.ex5`
  di ognuna, e se una compilazione fallisce **rimette il `.mq5` com'era** (una
  compilazione fallita non è un no-op: lascerebbe il `.ex5` vecchio che opera
  sotto un `.mq5` nuovo che mente). Gli `.ini` girano con
  `AllowLiveTrading=false`, e il driver **conta** che ci sia.
- **48 passate** (12 celle × 2 finestre × 2 gemelle), **24 CSV**, `Model=4`
  (**tick reali**), finestra **2024.09.26 → 2026.06.30**, split 40/60,
  deposito 100.000, rischio 1%.
- **Zero parametri spazzolati.** L'**unico** asse con flag `Y` è `InpMagic`, e il
  driver **si ferma** se in un file prova ne trova un secondo.
- **Il round non scarica storico** e non tocca `bases\<server>\ticks`: i tick
  reali di NASUSD, D30EUR e U30USD dal 2024.09.26 sono già agli atti (sonda del
  17/08, verdetto `COMPLETO`).
- 🔧 **Se non è già stato fatto**: MT5 → Strumenti → Opzioni → Grafici →
  **"Max barre nel grafico" = Illimitato**. Il driver scrive comunque
  `[Charts] MaxBars=2000000000` nei suoi `.ini`.
- ⏱️ **Durata [STIMA, non una previsione]: 20-45 minuti.** R107 fece **24**
  passate a tick reali **sulla stessa finestra in 9 minuti** (21:14→21:23,
  referto agli atti); qui sono il **doppio**, su tre simboli i cui tick sono già
  a disco. ⚠️ **Il `n` alto di EMADOW (712) NON allunga la corsa**: a tick reali
  il tempo lo fa il **numero di tick della finestra**, non il numero di
  operazioni. `-OreMax 10` è un tetto sull'**inizio** di nuovi file.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata**)

> ⚠️ **Non è a costo zero sul terminale**: scarica gli artefatti al pin,
> **installa `ABTG_PausaGuardian.mqh`** in `MQL5\Include` e **COMPILA i quattro
> EA** (la compilazione si fa anche a vuoto, altrimenti il giro non direbbe
> niente sulla compilabilità). Quello che **non** fa: non apre MT5 per testare,
> non cancella nessun artefatto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R110.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R110_LATI_VIVI.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R110_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** — ⚠️ le righe qui sotto sono **copiate dall'output vero**
(checklist 70: un elenco riscritto "nell'ordine che sembra naturale" fa fermare
il round per un falso allarme):

```
    famiglie .....................  4   (EMADOW, SUPDAX, SUPNAS, SWDOW)
    celle ........................  12   (di cui METRO: 4)
    CSV attesi ...................  24   (IS + OOS per cella)
    righe per CSV ................  2   (le due gemelle di controllo)
    passate ......................  48
    IS  2024.09.26 -> 2025.06.09
    OOS 2025.06.10 -> 2026.06.30
```

> ⚠️ **L'elenco delle famiglie in testa è ALFABETICO** (`EMADOW, SUPDAX, SUPNAS,
> SWDOW`) perché il driver lo costruisce con `Sort-Object -Unique`. Il blocco di
> dettaglio subito sotto, invece, è in **ordine di dominio** (`SUPNAS, SUPDAX,
> SWDOW, EMADOW`) — **e anche la corsa gira in quell'ordine**. I due ordini
> diversi sono **giusti tutti e due**: non è un difetto.

E poi, in ordine:

- `criteri: NON FIRMATI (il file porta ancora [DA FIRMARE])` — **è giusto così
  finché non firmi**, e il giro a vuoto prosegue lo stesso;
- `driver generico PINNATO (...), MaxBars alzato, AllowLiveTrading=false x2`;
- `12 file prova + 4 antenati scaricati al pin, righe vive verificate (SUPNAS 45 / SUPDAX 45 / SWDOW 47 / EMADOW 46)`;
- `gate dell'ANTENATO: ogni cella e' la copia riga per riga del suo file prova R103, salvo i delta dichiarati`;
- `gate della STELLA: ogni cella dei lati differisce dal suo 00_metro SOLO sul lato che deve muovere`;
- `geometria d'identita', TF del grafico, LATI, asse unico e 24 magic vergini verificati NEI FILE`;
- `include installato: ABTG_PausaGuardian.mqh (... byte)`;
- **`COMPILATO` × 4**, tutti `v1.00`. ⚠️ Su EMADOW la riga dice
  `InpMagic del sorgente 771501 (la sedia gira su 771531)` — **è corretto**: il
  magic del sorgente, quello della sedia e quello del file prova sono **tre
  numeri diversi**;
- in fondo: `anteprime .ini in sosta: 12 su 12`, **nessun PROBLEMA in elenco** e
  `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.** `-SoloControllo`
> **non apre MT5**: non esiste nessun `n`, nessun PF, nessun DD, **nessun G0-C e
> nessuna somma dei lati**. Conferma gli **artefatti**, mai i numeri.
> **G0-A l'antenato invece SÌ**: gira prima di MT5 ed è già passato.

---

## 2️⃣ POI la corsa vera — **solo dopo aver firmato le cinque decisioni**

Se hai tolto il `[DA FIRMARE]` dal file dei criteri, il gate si apre da solo e
`-CriteriFirmati` non serve. Se preferisci **firmare in riga**, aggiungilo: la
firma finisce **scritta nel referto**.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R110.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R110_LATI_VIVI.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R110_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21). Tre righe
staccate sarebbero tre comandi indipendenti, e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella corsa
> vera `exit 1` può voler dire _"la corsa è riuscita e la risposta non ti
> piace"_: gli artefatti **esistono** e vanno mandati lo stesso.

### 🔁 Se serve riprendere

> ⚠️ **Ogni riga di ripresa è un BLOCCO INTERO, con il suo `irm` e la sua guardia**
> (checklist **42**). `$p` e `$pin` nascono **dentro** il `& { ... }` del blocco
> qui sopra, che è uno **scope figlio**: quando quel blocco finisce **non
> esistono più**. Una riga `& $p -Pin $pin ...` incollata da sola in una console
> nuova muore; e — peggio — incollata in una console **ancora calda** funziona,
> ma riusa la **copia locale già scaricata** e il **pin di prima**.

**Una famiglia sola** (qui EMADOW, la riga più importante del round):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R110.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R110_LATI_VIVI.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R110_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloEa 'EMADOW';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

**Due famiglie** — ⚠️ **l'elenco va FRA APICI** (checklist 65: senza, la virgola
fa un **array** e il binder lo unisce con uno spazio). *Provato: con gli apici e
senza, il driver seleziona correttamente in tutti e due i casi — ma gli apici
restano la forma di casa.*

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R110.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R110_LATI_VIVI.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R110_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloEa 'SWDOW,EMADOW';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

**Una cella sola** (il `00_metro` della sua famiglia rigira lo stesso):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R110.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R110_LATI_VIVI.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R110_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -CriteriFirmati -SoloCella 'R110_EMADOW_02_short.txt';
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

In **tutti** i casi il **`00_metro` della famiglia rigira**: è il denominatore
**e porta il gate G0-C** (senza, quella famiglia non ha nessun controllo di
determinismo). Costa **2 CSV**, non una passata sprecata.

> 📎 Il referto stampa in fondo un promemoria `COME SI RIPRENDE` in forma
> **abbreviata** (`... & $p -Pin <PIN> ...`): quei tre puntini stanno per il
> blocco intero qui sopra. **Si riprende da questa pagina, non da quella riga.**

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R110.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round) o `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto **stantio**:
   si guarda il nome della cartella sul Desktop (porta data e ora) e si rifà.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R110_LATI_VIVI_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_R110.txt`** ← **è questo che conta**;
- i **24 CSV** di ottimizzazione (2 righe l'uno: le gemelle di controllo);
- i **dodici file prova al pin** **e i quattro ANTENATI di R103**, così chi apre
  lo zip fra un mese può **rifare il gate G0-A a mano** senza tornare in repo;
- `compile_SUPNAS.log`, `compile_SUPDAX.log`, `compile_SWDOW.log`, `compile_EMADOW.log`;
- (solo nel giro a vuoto) le **12 anteprime `.ini`**.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. 🔬 **I QUATTRO VERDETTI DEL METRO.** Devono dire
   **`G0-A OK (antenato) + G0-C OK (gemelli identici). G0-B NON APPLICABILE`**.
   ⚠️ **`NON APPLICABILE` non è `superato`**: su questo round non c'è nessuna
   prova *numerica* che il banco sia sano, e il referto lo dichiara.
2. 🆕 **LE QUATTRO CELLE `02_short`.** Sono **la prima volta in assoluto** che il
   lato short di queste sedie ha un numero. Guardare **PF OOS**, **`n` OOS** e
   **DD**.
3. 🔥 **LA RIGA `EMADOW 02_short`.** È l'unica del round che può arrivare a
   **n ≥ 150**, cioè l'unica su cui il **merito** si può giudicare per intero.
   Se `n < 150`, il merito è **sospeso** anche lì (Emendamento regola B) — e
   quello è **un risultato**, non un guasto.
4. 🧮 **LA RIGA `SOMMA DEI LATI`**, per ogni famiglia: `metro n / long n /
   short n`. **Non devono tornare**, ed è spiegato perché. Chi li vede diversi e
   grida al bug sta leggendo il banco invece del motore.
5. 🦴 **LA SPINA DORSALE.** Se uno short esce **verde in IS e rosso in OOS**, la
   prima ipotesi **non** è *"il lato è rumore"*: la correzione di
   **febbraio-aprile 2025** cade **dentro l'IS** (che finisce il 2025.06.09) e
   l'OOS è quasi tutto salita. **E c'è un fatto nuovo che punta lì, di ieri**:
   R107 ha misurato il **NAS short a PF IS 3,220 e PF OOS 0,460**. Resta
   **[INFERITO]**: R110 non misura i sotto-periodi.
6. ⚖️ **IL RISCHIO SI GIUDICA SEMPRE**, a qualunque `n`: **DD e peggior
   giornata** di ogni lato. Un DD è un fatto accaduto — e queste sono sedie che
   stanno sui soldi. ⚠️ Ogni DD è **all'1%**: per confrontarlo col forward del
   100k si **moltiplica per 0,65**.

---

## 🔴 LE SEI COSE CHE R110 **NON** DICE

1. **NON promuove e NON boccia niente in forward.** Tutte e **quattro** le sedie
   stanno sul conto 100k: un cambio è **una firma successiva**, con referto suo (G5).
2. **NON applica i cancelli.** Produce i numeri; **G1-G5 li applica il referto del
   round, a mano.** G3 in particolare non è meccanizzabile: è un ragionamento su
   **quattro** tabelle, tre mercati e due logiche.
3. **NON riproduce R103** e non pretende di farlo. I numeri R103 nel referto sono
   **contesto**, e vengono da un altro banco.
4. ⚠️ **Se un `01_long` passa il cancello e il suo `02_short` è rosso**, la lettura
   **non** è *"lo short non serve"*: è *"questa sedia **potrebbe** essere
   long-only"* — che è una **proposta di modifica di contratto**, cioè un round
   successivo con la sua firma. **Regola R52: non si spegne un lato guardando i
   risultati.**
5. **NON estende niente agli altri CINQUE motori simmetrici mai smontati** (PTE
   Dow, PunteLarry, GapFill, SuperWave H2, SupRev Nikkei): restano **non
   misurati**, e vanno detti tali.
6. **NON chiude la domanda sul lato short.** La finestra è **21 mesi di indici
   che salgono**: il lato short parte svantaggiato **per regime**. Un *"niente
   edge short"* qui la chiude **per questa epoca e per questi quattro motori**.

---

## ✅ COSA È GIÀ STATO VERIFICATO — **eseguendo**, prima dell'invio

Checklist punto **63** (_"il parse si FA, non si dichiara impossibile"_):

- ✅ il `.ps1` **parsa**: `/opt/pwsh/pwsh` + `[Parser]::ParseFile` → **0 errori**,
  **13.973 token**; **ASCII puro** (0 caratteri non-ASCII, regola del 17/08);
- ✅ **l'audit del punto 79 (variabili CASE-INSENSITIVE) è stato FATTO su questo
  file, ed è servito**: estratti tutti i nomi di variabile del **codice** (senza
  commenti) e confrontati in minuscolo, è saltata fuori **la stessa coppia del
  difetto gemello di R109** — `$R` (l'ArrayList del referto) contro `$r` (la
  variabile di tre cicli). Oggi era innocua **solo per ordine delle istruzioni**,
  che è esattamente la fragilità che ha fatto danno in R109: **rinominata in
  `$RefTxt`** (151 occorrenze). Ri-audit sul codice: **zero collisioni**;
- ✅ **e da lì è nato il gate che a R109 mancava — LA FINESTRA SI RICONTROLLA UN
  ISTANTE PRIMA DI PASSARLA.** In R109 `$A` (il `ToDate`) era stato distrutto da
  un `$a` di comodo e il giro a vuoto uscì **`ESITO: OK`, codice 0**, perché
  *nessun gate guardava le date* — che sono metà di quello che un backtest
  misura. **Riprodotto qui** iniettando `$daquando` minuscolo prima della catena:
  il gate si ferma e stampa
  `DaQuando=[InpUsaGuardian=true||true||0||true||N InpTF=16385]`, cioè **lo
  stesso identico sintomo** (l'array unito dagli spazi);
- ✅ **il punto 76 (il `$` dentro apici doppi che mostra codice)**: la coda
  `COME SI RIPRENDE` del referto è scritta in **apici singoli**, verificato con
  il grep prescritto **e leggendo il referto prodotto**;
- 🔍 **e un secondo difetto vero trovato leggendo il referto vero** (non
  rileggendo il sorgente): l'esito di cella scriveva
  `RIGHE SBAGLIATE (IS -1 / OOS -1)` — il sentinella `-1` **crudo dentro una
  frase**, che si legge *"meno una riga"* e non vuol dire niente. È il difetto 66
  applicato alle **frasi** invece che alle colonne. Corretto: ora dice
  `(IS n/d / OOS n/d ... 'n/d' = il CSV non e' stato prodotto)`, e il referto è
  stato riletto per intero: **nessun `-1` crudo da nessuna parte**;
- ✅ **`[CmdletBinding()]` c'è ed è PROVATO** (checklist 71, il difetto di
  famiglia trovato su R108): lanciato con **`-SoloControlo`** (una L sola), lo
  script **muore** con *"A parameter cannot be found that matches parameter name
  'SoloControlo'"*, **prima** di toccare MT5. Verificato anche il prerequisito:
  lo script **non usa `$args`**;
- ✅ **i dodici file prova sono generati DAI QUATTRO ANTENATI R103 con uno
  script**, non trascritti a mano; e il `diff` contro gli antenati è stato
  eseguito e mostra **esattamente** i delta dichiarati: `InpMagic` nei metro,
  `InpMagic` + **un solo** lato nelle celle dei lati;
- ✅ **i gate girano DAVVERO sui dodici file veri**, stubbando il download dal
  repo locale: righe vive **45/45/47/46**, antenato, stella, geometria
  d'identità, TF del grafico, asse unico, **24 magic vergini** → tutti passati;
- ✅ **e i gate sono stati fatti FALLIRE, uno per uno** (un gate che non scatta
  mai non è dimostrato). Provate e **tutte e 14 fermate**: corruzione
  **simmetrica** su tutte e tre le celle di una famiglia (la prende **solo**
  l'antenato), un delta dichiarato che **non si muove**, una riga in più, un
  terzo input mosso, i due file dei lati **scambiati**, un magic **vivo**, un
  magic **duplicato** fra famiglie, un **secondo asse Y**, `@DAQUANDO` spostato,
  **`@PERIODO` H1→H4** (la trappola di R102), una riga vive tolta, la corruzione
  **anche dell'antenato** (la prende la geometria d'identità), l'EA **senza**
  `InpAllowShort`, la **versione** del sorgente diversa. Più il **controllo
  positivo**: i file sani ripassano;
- ✅ **e stella / valori / asse unico provati anche DA SOLI**, con il gate
  dell'antenato **spento**: senza quello, li prendono comunque i gate a valle
  (compreso il caso 34-bis costruito apposta con la stella **verde**);
- 🔍 **un difetto vero trovato così, prima dell'invio**: il gate
  `AllowLiveTrading=false` era tarato su **2** occorrenze con un match a testo
  libero — e nel driver generico la stringa compare **3 volte**, perché la terza
  è un **commento** (riga 627). Il giro a vuoto si è fermato su un driver sano.
  Corretto contando **solo le righe che iniziano** con quella stringa: **è il
  difetto 40-quater**, il numero atteso si misura **eseguendo**;
- ✅ **la convenzione di sentinella provata SU TUTTE LE COLONNE**: i valori
  iniziali (PF `-1.0`, DD `-1.0`, `n` `-1`, profitto `-999999`, peggior giornata
  `99.9`) escono **tutti `n/d`**; e i valori veri escono **numeri** — compresi
  **un profitto negativo** (`-2592`, che con un sentinella a `-1` sarebbe stato
  indistinguibile da una perdita di 1 euro) e **una peggior giornata negativa**
  (`-1.00`, che con il formattatore generico sarebbe uscita `n/d` su un valore
  misurato);
- ✅ **il parser del CSV provato sotto cultura it-IT** con l'intestazione VERA
  dell'OPTFRAME: `0.84003` letto **zero-virgola-84** (non 84003), gemelli
  `IDENTICI`; e i **controlli negativi**: intestazioni ignote → **si rifiuta di
  indovinare**, una riga sola → `NON VALIDO: 1 righe invece di 2`, gemelli
  diversi → `DIVERSI su n`, file inesistente → `null`;
- ✅ **gli switch e i codici d'uscita provati uno per uno**: corsa vera senza
  firma → **exit 2**; `-SoloEa 'PIPPO'` → exit 1 con l'elenco dei nomi validi;
  `-SoloEa 'SWDOW,EMADOW'` **e** `'SWDOW EMADOW'` → entrambi selezionano
  **2 famiglie / 6 celle**; `-SoloCella` su una short → **2 celle, di cui 1
  metro** (il denominatore rigira); `-SoloCella` inesistente → exit 1; senza
  `-Pin` → exit 1;
- ✅ **le stringhe attese del § 1 sono state COPIATE DALL'OUTPUT**, non riscritte
  a mano (checklist 70) — ed è così che si è visto che l'elenco delle famiglie
  esce **alfabetico** mentre il dettaglio esce in ordine di dominio;
- ✅ **i 24 magic cercati uno per uno** in tutto il repo: **zero occorrenze**. E
  il blocco `7744xx` di **R109** è stato verificato **estraneo**;
- ✅ **la natura dei motori è stata LETTA NEL SORGENTE**, non assunta: tutti e
  quattro hanno `InpAllowLong`/`InpAllowShort` (il driver si ferma se non li
  trova), e tutti e quattro escono dalla funzione d'ingresso **prima** di
  guardare il lato — che è la ragione tecnica per cui la somma dei lati non fa
  il metro.

🟡 **Non verificato, e va detto**: tutto ciò che richiede **MT5** — la
**compilazione vera** dei quattro `.mq5` (qui non c'è MetaEditor), il
comportamento del tester, la durata reale, e **ogni singolo numero**. **Il giro a
vuoto copre gli artefatti; i numeri li può dare solo la corsa.**

> ⚠️ **Il rischio residuo più concreto, dichiarato: questo round ricompila i
> `.ex5` di QUATTRO SEDIE VIVE.** È già successo in R107 su tre, senza danni, e
> qui ci sono backup datati e il ripristino del `.mq5` se la compilazione
> fallisce. Ma è la ragione per cui **MT5 va chiuso** e per cui il round **non si
> lancia mentre R109 sta girando**.
