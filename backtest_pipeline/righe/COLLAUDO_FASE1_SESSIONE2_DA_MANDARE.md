# 🛡️🧷 COLLAUDO ENFORCEMENT — **SESSIONE 2: PAUSA B1 + POSIZIONI GESTITE** — DA MANDARE

**Che cos'è.** L'azione **G3** del pacchetto
`report/COLLAUDO_ENFORCEMENT_FASE1_2026-09-02.md`: la sessione da **~40 minuti**
che collauda in campo i **criteri 5 (la pausa che morde)** e
**6 (le posizioni aperte restano gestite durante la pausa)** sul
**100k (50504263)**. È la **gemella** della sessione 1 (cap C1 + fail-open):
stessa disciplina, stesso artefatto, stesso canarino — cambia **cosa si misura**.

Le attese sono quelle **congelate il 02/09** in
`backtest_pipeline/attese_enforcement_fase1.txt`: le stringhe qui sotto le
scaricano **dal pin** e le cercano nel log — il cancello non dipende dall'occhio.

> 🚦 **MAI LE DUE SESSIONI LO STESSO GIORNO.** Lo dice il piano (azioni G2 e G3
> sono «sessione SEPARATA, altro giorno») e c'è un motivo tecnico: entrambe
> cambiano i parametri del Guardian, e due gesti diversi nello stesso log
> rendono impossibile dire **quale** ha spostato cosa. Una variabile alla volta,
> anche in campo.

📌 **Nota (classe 130):** il driver di **questa** sessione azzera da solo i suoi
valori interni a ogni corsa: le tre righe si possono lanciare nella stessa
finestra PowerShell senza problemi. **Non vale per la SESSIONE 1**: il suo
driver (già pinnato, non toccato per non invalidare la prova) ha un valore che
può sopravvivere fra due lanci nella stessa console — finché non viene
ripinnato, **la riga 3 della sessione 1 va sempre lanciata da una console
appena aperta**.

---

> 🔴 **SESSIONE WINDOWS: `Administrator`, NON Master.** Misurato il 03/09 alle
> 16:08: entrambi i `terminal64` (piccolo e `-V3`/100k) girano come
> `VMI3047753\Administrator`, e le cartelle dati vive stanno sotto
> `C:\Users\Administrator\...`. Da **Master** la riga 1 dice «NESSUNA cartella
> con evidenza» (è già successo il 05/09 con la sessione 1) e in più non potresti
> nemmeno aprire Proprietà/F3 sul terminale giusto. Le tre righe di questa
> pagina si rifiutano di partire se `$env:USERNAME` non è `Administrator`.

---

## 🛑 DOVE GIRA, E CHI FA COSA — leggilo prima di tutto

> 🖥️ **Tutto questo si fa sul VPS**, sull'istanza **`-V3`** (il terminale del
> conto **50504263**), che è **IL FORWARD VERO**.
>
> 🤖 **Le tre righe PowerShell di questa pagina sono di SOLA LETTURA.**
> Non aprono MT5, non lo chiudono, non scrivono niente dentro
> `%APPDATA%\MetaQuotes\Terminal`, non toccano `.chr`, `.set`, grafici, EA o
> ordini, e **non toccano NESSUNA GlobalVariable** — in particolare **non
> cancellano la pausa**: quella la cancelli **tu** da F3, al passo 1️⃣3️⃣, e solo
> dopo aver fatto il passo 1️⃣1️⃣. Leggono i log (**MT5 resta APERTO**: la lettura
> è condivisa) e i referti del canarino, e scrivono **solo sul Desktop**.
>
> 👤 **Ogni gesto che CAMBIA STATO lo fai TU a mano**, con la legge dello
> screenshot: abbassare la soglia di pausa, rialzarla, cancellare le due
> GlobalVariable. Nessuna riga di questa pagina può farlo — non è una promessa,
> è che quel codice **non esiste**.
>
> 🖥️ **Il PC di backtest non c'entra**: niente di questa pagina lo tocca.
>
> 🚫 **NON si compila e NON si ricompila NIENTE** (decisione **D1** del 02/09 e
> divieto **NO.5** dell'artefatto): si collauda **esattamente il software che sta
> in campo**. Il **canarino** è già installato e compilato sul 100k
> (pin `640fd93`, v1.01, prima corsa **verde** il 02/09).

---

## 🔴 IL CANCELLO CHE VIENE PRIMA DI TUTTO: **la giornata dev'essere IN PERDITA**

Non è una preferenza, è **fisica del codice**. `ABTG_Guardian.mq5` riga 400:

```
if(InpDailyPausePct>0 && dailyPct>=InpDailyPausePct)
```

e `InpDailyPausePct = 0` significa **«pausa spenta»**. Quindi:

> **Se la giornata NON è in perdita, NON esiste nessun valore della soglia che
> accenda la pausa.** Non c'è trucco, non c'è ripiego: la prova **si rimanda**.

👉 **Prima di toccare qualsiasi cosa, guarda il campo `Perdita oggi` del pannello
del Guardian** (è il prerequisito **P-4**):

| cosa leggi nel pannello | cosa fai |
|---|---|
| `Perdita oggi: -63.00  (0.06% / limite 4.9%)` → **percentuale POSITIVA** | ✅ si può fare: la soglia della prova sarà un numero **positivo e chiaramente sotto** quello (es. **0,03**) |
| percentuale **0,00%** o **negativa** (giornata in utile) | 🛑 **SI RIMANDA.** Non è un fallimento dell'enforcement: è il criterio 5 che **non è innescabile**. Si riprova un altro giorno |

📌 **Che ordine di grandezza aspettarsi:** il 03/09 nel pomeriggio `dayLoss` era
arrivato a **−0,06%**. Bastava quello. Non serve una brutta giornata: serve
**una frazione qualsiasi** di perdita.

⚠️ **E perché "chiaramente sotto" e non "appena sotto":** `dailyPct` si muove a
ogni tick con l'equity. Una soglia incollata al valore letto può non mordere più
un secondo dopo, e sembrerebbe che la pausa non funzioni. Metti circa **la
metà**, arrotondata in giù.

🧮 **La riga 1️⃣ te lo dice anche a macchina**, leggendo il campo `dayLoss=` delle
righe periodiche del Guardian. È una **spia campionata ogni 300 secondi**: se il
pannello e il log non concordano, **vale il pannello**, che è di adesso.

---

## ⏰ L'ORA GIUSTA PER FARLA (e perché non è un dettaglio)

- Le finestre operative si contano in **ORA SERVER = ora italiana − 1**; le
  schede **Esperti/Giornale** sono in **ora LOCALE del VPS = ora italiana**.
- Questa sessione ha bisogno di **DUE cose insieme**, e per questo la finestra
  conta più che nella sessione 1:
  1. un EA che **tenti davvero di entrare** dentro la pausa → criterio 5;
  2. **almeno una posizione APERTA** che si veda gestire → criterio 6.
- 🥇 **Finestra consigliata: 14:30–16:00 SERVER = 15:30–17:00 italiane.** È
  l'intersezione fra le finestre d'ingresso `WIN.3` (Dow retest) e `WIN.4` (ORB)
  dell'artefatto **e** l'orario in cui una posizione DAX/Dow della giornata è
  tipicamente ancora aperta (flat 17:30 server). Ed è anche l'ora in cui la
  perdita del giorno, se c'è, si è già formata.
- 🥈 **Alternativa 07:58–08:15 SERVER** (MaxMin piazza alle **07:59**, DAX parte
  alle 08:00): è il tentativo d'ingresso **più regolare della giornata**, ma a
  quell'ora la giornata prop è appena cominciata e `Perdita oggi` è quasi sempre
  **~0** → il cancello qui sopra ti manderà a casa. Vale solo se c'è una
  posizione notturna in perdita.
- 🛑 **Da evitare: dopo le 17:00 server.** DAX e Dow vanno **flat alle 17:30**:
  una posizione che si chiude lì dentro è chiusura oraria regolare, ma nel
  verbale del criterio 6 sembra «la posizione è sparita durante la pausa» e ti
  costringe a spiegare una cosa che non è successa.

---

## ⚖️ IL COSTO, DETTO PRIMA (X11 / R9 / X7)

1. Con la pausa accesa, per **tutta la durata della sessione** i 5 mirror **non
   aprono**. Un blocco forzato **PERDE quel trade, non lo rimanda**.
   👉 **Alla fine, annota nella pagella del giorno i trade persi** (azione G7):
   altrimenti M27 e H5 misurano un buco che è **nostro**.
2. 🔴 **E c'è un costo peggiore, se sbagli l'ordine dell'uscita: la pausa è un
   LATCH.** Non si spegne rialzando la soglia. Se esci male, il 100k **smette di
   aprire fino al reset del giorno prop** — cioè si perde **una giornata intera**
   di dry-run, e il criterio 9 (5 giornate pulite) si allunga di un giorno.
   I passi 1️⃣1️⃣ → 1️⃣3️⃣ → 1️⃣4️⃣ esistono solo per questo. **Non saltarne nessuno.**

---

## 📌 IL PIN — **`89c9003976f75cc6719aff3e9a4d2764962a95ab`**  ✅ **INSERITO** — driver **v2**, marcatore `MARCATORE_RIGA_COLLAUDO_FASE1_S2_v2` (verificato con `git ls-tree` a questo commit: ci sono sia il driver sia l'artefatto `backtest_pipeline/attese_enforcement_fase1.txt` che le tre righe scaricano). Il pin `v1` (`e487932f...`) è **bruciato**: il verificatore ha trovato il rilevatore del rilievo R2 cieco proprio al caso che deve incastrare (classe 131, corretta in v2) — non incollarlo più. ⚠️ Il pin `2e37a67...` e il marcatore `..._S1_v2` sono quelli della **SESSIONE 1**: sono un'altra riga e un'altra prova, non incollarli qui.

---

## 🧭 SE LA RIGA 1 SI FERMA SULLA CARTELLA DATI

Il driver di questa sessione usa **la stessa scoperta della S1 v2**, quella
nata dalla fermata in campo del 03/09 alle 10:45: **non cerca per NOME**
(`-V3` dentro `origin.txt`), perché il nome non è un fatto. Cerca per **FATTI**:
il conto **50504263** nei log, la riga `[GUARDIAN] filo verificato ... (conto
50504263)`, i referti del canarino intestati a quel login. E scandisce **largo**:
processi `terminal64` vivi, cartelle dati di **tutti** i profili utente,
installazioni sotto `C:\Program Files`, `C:\Program Files (x86)`, `C:\`, `D:\`.

**Se anche così si ferma, non indovina**: stampa `=== CARTELLE GUARDATE ===`
con **tutte** le cartelle esaminate e, per ognuna, i login visti, se c'è il
conto del collaudo, quanti referti del canarino, l'`origin.txt`. Due casi:

| cosa dice | cosa fare |
|---|---|
| **NESSUNA cartella con evidenza** | guarda l'elenco: se riconosci la cartella dell'istanza del 100k, rilancia **la stessa riga** con in coda `-CartellaDati '<percorso>'` |
| **AMBIGUO: 2+ cartelle con evidenza** | idem, `-CartellaDati '<percorso giusto>'` — e **dimmelo**, perché due cartelle vive sullo stesso conto possono anche voler dire **due terminali** (violazione B9) |

📍 **Il percorso vero lo dà MT5 in due secondi**: sull'istanza del 100k →
menu **File > Apri la cartella dei dati** → è **quella** cartella (quella che
contiene `logs\`, `MQL5\`, `config\`).

---

# ▶️ LA SEQUENZA — 16 passi, in quest'ordine

## 1️⃣ RIGA 1 — **LETTURA PRIMA** (PowerShell sul VPS, ~30 secondi)

Legge il terminale, il conto, l'artefatto dal pin, il log di oggi, **il GATE
della giornata in perdita**, e scrive il **segnaposto d'inizio sessione** (serve
alla riga 3️⃣ per non confondere le righe di stamattina con quelle della prova).

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if($env:USERNAME -ne 'Administrator'){ throw ('SESSIONE WINDOWS SBAGLIATA: qui sei ' + $env:USERNAME + '. Il terminale -V3 del 100k gira sotto Administrator (misurato il 03/09): chiudi, entra nella sessione Administrator e rilancia.') };
    $pin='89c9003976f75cc6719aff3e9a4d2764962a95ab'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COLLAUDO_FASE1_S2.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COLLAUDO_FASE1_S2.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COLLAUDO_FASE1_S2_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S2_*\RIGA_REFERTO_COLLAUDO_FASE1_S2.txt'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S2_*\RIGA_REFERTO_COLLAUDO_FASE1_S2.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI ADESSO sul Desktop: copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S2_*.zip'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S2_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'LETTURA NON COMPLETA (1 = fermata/rosso, 2 = parziale): mandamela lo stesso.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel referto: riga data: = ORA DI AVVIO (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), riga fine: = quando ha finito. La freschezza l''ha gia'' controllata a macchina il filtro qui sopra.') -ForegroundColor Gray }
```

**✅ Esito atteso (dal file delle attese):**

| cosa | atteso |
|---|---|
| `P-1 CONTO ATTIVO` | **50504263** (verde). Se esce un altro numero → **esito ROSSO, uscita 1: ci si ferma qui** |
| `ARTEFATTO dal pin` | 12 ATTESA, 4 VIETATA, 2 CAMPO, **5 nomi EA** |
| `PRE.FILO` + `PRE.CONTO` | ≥ 1 riga `[GUARDIAN] filo verificato: 5 GlobalVariable su 5 ... (conto 50504263)` |
| `PRE.SOGLIE` | riga `pausa morbida=4.00%  cap rischio aperto=3.25%` |
| righe **VIETATE** | **0** (`STOP.FILO`, `STOP.DAILY`, `STOP.TOTALE`, `STOP.AUTOTEST`) |
| `IL LATCH DELLA PAUSA` | `soglia ABBASSATA: MAI in questo log`, `accensioni della pausa: 0` (siamo prima del gesto) |
| `GATE DELLA SESSIONE 2` | **`GATE APERTO`** con `dayLoss` **positivo** |

🔴 **GATE — se dice `GATE CHIUSO` (dayLoss ≤ 0): guarda il pannello.** Se anche
il pannello dice `Perdita oggi` ≤ 0, **LA SESSIONE SI RIMANDA**. Non si abbassa
niente "per vedere": senza perdita del giorno la pausa non parte, e l'unica cosa
che si dimostra è di aver perso mezz'ora.

---

## 2️⃣ P-2 — **un solo Guardian** (menu **Finestra** dell'istanza `-V3`)

📸 **Screenshot.** Due Guardian sullo stesso conto si timbrano addosso a vicenda
(regola B9, rischio X4). La riga 1️⃣ ti dà solo una **spia** (i contesti che
scrivono `[GUARDIAN]`): **la prova è il menu Finestra**.

## 3️⃣ P-3 / P-4 / P-5 — **il pannello PRIMA** (è qui che si decide se si fa)

📸 **Screenshot del pannello del Guardian** e **annota su un foglio**:

- soglie **4,9 / 9,9 / pausa 4,0 / cap 3,25** e `Azione: CHIUDI+BLOCCA`;
- 🔴 **`Perdita oggi: ... (X.XX% / limite 4.9%)`** ← **è il numero che decide la
  sessione** (vedi il cancello sopra) **e** quello da cui ricavi la soglia del
  passo 6️⃣;
- **quante posizioni aperte** ci sono e **se hanno lo SL** ← senza almeno una
  posizione aperta il **criterio 6 non è osservabile** (resta 🟡 NON MISURATO);
- `Rischio aperto: X.XX%` (non serve alla prova di oggi: serve al censimento del
  criterio 9 e a farti vedere che il cap **non** l'hai toccato).

## 4️⃣ Parametri dell'EA che presidierai — 📸 screenshot

Apri la scheda **Parametri** dell'EA della finestra che presidi (Dow o ORB se
segui il consiglio dell'orario) e verifica **due campi**:

- **`InpUsaGuardian` = true** — se fosse `false`, quell'EA non chiede niente a
  nessuno e il suo silenzio non vuol dire niente (spia X1);
- **`InpMaxPosSimbolo` = 0** — è il tetto "A1" per simbolo. La nota
  `ROUND.PRECEDENZA` dell'artefatto dice che durante il collaudo **il tetto della
  sedia di prova deve restare 0**: se fosse > 0, l'EA potrebbe **non tentare**
  l'ingresso per un motivo che **non è la pausa**, e il silenzio verrebbe letto
  male.

## 5️⃣ CANARINO — **corsa 1: la fotografia PRIMA** (ed è anche la BASE del criterio 6)

Trascina lo Script **`ABTG_CanarinoGuardian`** su **un grafico qualsiasi**
dell'istanza `-V3` e premi OK (`InpGiornoOffset` resta **0**). Gira una volta,
stampa e finisce: **non manda ordini, non scrive GlobalVariable**.

**✅ Atteso nel Giornale/Esperti (tutte le righe iniziano con `[CANARINO]`):**
`login=50504263` · `ABTG_CanaleEsiste() = SI` ·
**`PAUSA B1 grezzo=NO ricalcolato=NO`** · `GUARDIAN VIVO grezzo=SI ricalcolato=SI`
· `MOTIVO ... 0 = nessuno` · `ESITO PER UN EA ADESSO: un ingresso sarebbe PERMESSO`
· `AUTOTEST: 8 blocchi su 8 passati` · `nessun rilievo`.

> 🔎 **`grezzo=X ricalcolato=Y` è la scorciatoia di QUESTA pagina**, non il testo
> letterale del Giornale. La riga vera è (una per firma, su due colonne):
> `[CANARINO] PAUSA B1       grezzo(ts>0)=NO   ABTG_PausaAttiva_Calc     =NO   -> coerenti`
> `[CANARINO] GUARDIAN VIVO  grezzo(ts>0)=SI   ABTG_GuardianVivo_Calc    =SI   -> coerenti`
> — `grezzo(ts>0)=` è il primo valore, il nome della funzione (`ABTG_PausaAttiva_Calc`
> per la pausa) è il secondo. Le due lettere `NO`/`SI` sono ciò che conta; se cerchi
> `grezzo=NO` parola per parola nel Giornale **non lo trovi**, cerca `PAUSA B1` o
> `GUARDIAN VIVO` e leggi i due valori accanto.

📌 **E la riga che serve al criterio 6:** `posizioni aperte sul conto: N` seguita
da una riga `pos #<ticket> ... sl=<valore>` per ognuna. **Quello è il "prima"
degli SL**: il confronto con le corse successive è la prova a macchina del
criterio 6. Se qui `N = 0`, il criterio 6 oggi non è osservabile — puoi fare
comunque il criterio 5, ma scrivilo nel verbale.

---

## 6️⃣ 🔧 **IL GESTO** — abbassare **`InpDailyPausePct`** (solo quello)

Sul grafico del **Guardian**: tasto destro → **Consulenti → Proprietà** →
scheda **Parametri** → **`InpDailyPausePct`** = un valore **positivo e
chiaramente sotto** la `Perdita oggi` in % letta al passo 3️⃣.
Poi OK.

| se il pannello dice `Perdita oggi` | metti `InpDailyPausePct` |
|---|---|
| 0,12% | **0,05** |
| 0,06% | **0,03** |
| 0,03% | **0,01** |

> 🛑🛑 **`InpDailyLossPct` NON SI TOCCA MAI** (rilievo R3, divieto `NO.1`
> dell'artefatto). È il campo **due righe sopra**, si chiama quasi uguale, e con
> `InpAction=0` esegue **`FlattenAll()`**: chiude **tutte** le posizioni e
> cancella **tutti** i pendenti del conto, di qualsiasi magic. E anche mettendo
> `InpAction=1` resta `GV_BLOCKDAY` timbrato per la giornata.
> **Guarda il nome del campo due volte. Il campo giusto è quello che contiene
> la parola `Pause`.**
>
> 🛑 **E non si tocca `InpMaxOpenRiskPct`**: quella è la sessione 1. Se lo muovi
> oggi, i due gesti finiscono nello stesso log e non si capisce più chi ha fatto
> cosa. Il referto te lo dice: se il cap risulta diverso da 3,25 nella giornata,
> scrive un avviso.
>
> ⚠️ **Nota tecnica (X12/R8):** premere OK **riavvia** il Guardian
> (`OnDeinit`+`OnInit`): per ~1 secondo il canale è "libero" e nel log può
> comparire un `via libera` **all'ora esatta del click**. È **per disegno**: si
> annota, non si indaga.

## 7️⃣ Verifica del gesto — 📸 screenshot del pannello

Dopo **un giro di timer (1 secondo)** il pannello deve dire:
**`Pausa morbida (0.0%): ATTIVA (stop nuovi ingressi)`**
— la parola che conta è **`ATTIVA`**, il numero fra parentesi **quasi
certamente non sarà quello che hai digitato**, e va bene così:

> 🧐 **Il pannello arrotonda la soglia a UNA cifra decimale** (`%.1f` nel codice
> del pannello). Se hai messo **0,03** leggerai **`(0.0%)`**; se hai messo
> **0,05** leggerai `(0.0%)` o `(0.1%)`. **Non è un errore e NON vuol dire
> "spenta"** (il codice scrive letteralmente `spenta` quando la soglia è 0, e
> qui invece scrive `ATTIVA`). La soglia vera, con due decimali, la stampa
> **il log**:
> `[GUARDIAN] pausa morbida=0.03%  cap rischio aperto=3.25%`. **Fa fede il log.**

Nel log dev'essere comparsa anche la riga
**`[GUARDIAN] * PAUSA NUOVI INGRESSI attiva: perdita giornaliera 0.06% >= 0.03% (fino a ... server)`**
(attesa **C5.GUARDIAN**). ⏱️ **Annota l'ora.**

## 8️⃣ CANARINO — **corsa 2: con la PAUSA ATTIVA** (è la prova deterministica del criterio 5)

**✅ Atteso:** **`PAUSA B1 grezzo=SI ricalcolato=SI -> coerenti`** ·
`MOTIVO ... 1 = PAUSA GIORNALIERA del Guardian (firma B1)` ·
**`ESITO PER UN EA ADESSO: un ingresso sarebbe FERMATO`** ·
`dettaglio: accensione=... scadenza=... adesso=...` (la **scadenza** è il
prossimo reset del giorno prop: è la prova che la pausa **durerebbe fino a lì**).

> Questo dimostra che **il canale e l'include** fermano l'ingresso. Che lo
> facciano anche i **binari dei 5 mirror** lo dimostra solo la riga `[GUARDIA]`
> di un EA vero — ed è il passo 9️⃣.

## 9️⃣ RIGA 2 — **PRESIDIO 20 minuti** (console, dal vivo)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if($env:USERNAME -ne 'Administrator'){ throw ('SESSIONE WINDOWS SBAGLIATA: qui sei ' + $env:USERNAME + '. Il terminale -V3 del 100k gira sotto Administrator (misurato il 03/09): chiudi, entra nella sessione Administrator e rilancia.') };
    $pin='89c9003976f75cc6719aff3e9a4d2764962a95ab'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COLLAUDO_FASE1_S2.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COLLAUDO_FASE1_S2.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COLLAUDO_FASE1_S2_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Presidio -Minuti 20; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S2_*\RIGA_REFERTO_COLLAUDO_FASE1_S2.txt'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S2_*\RIGA_REFERTO_COLLAUDO_FASE1_S2.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI ADESSO sul Desktop: copiami il rosso qui sopra.' };
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'PRESIDIO CHIUSO CON RILIEVI: guarda il referto.' -ForegroundColor Yellow };
    Write-Host ('referto di questo presidio: ' + $r[0].FullName) -ForegroundColor Cyan }
```

**✅ Atteso (se un EA prova davvero a entrare) — è la riga che vale la sessione:**
`[GUARDIA] <nome>: INGRESSO BLOCCATO -- PAUSA GIORNALIERA del Guardian (firma B1). Rischio aperto X.XX%. La posizione eventualmente gia' aperta NON viene toccata.`
(attese **C5.EA** e **C6.PROMESSA**)
📸 **e nella scheda Trade/Storico NON deve comparire nessun ordine nuovo** in
quella finestra: **quella parte la vede solo il tuo occhio** — fai lo
screenshot.

**✅ E in più, per il criterio 6 — questa è la differenza dalla sessione 1:**
il presidio ti stampa **anche le righe dei 5 mirror che NON parlano di blocchi**.
Durante la pausa sono proprio quelle a interessare: sono la **gestione delle
posizioni già aperte** (trailing, breakeven, parziali). Se le vedi scorrere
mentre la pausa è accesa, il criterio 6 lo stai guardando in diretta.

- 🟡 **Zero righe non è un PASS: è NON MISURATO.** Vuol dire che nessun EA
  voleva entrare. Si ripete in un'altra finestra, non si promuove.
- ⚠️ **Non è un FAIL** se scatta un **pendente piazzato prima**: la guardia
  ferma i **nuovi ingressi**, non tocca gli ordini già a mercato (limite noto
  n.1). Si annota.

## 🔟 CANARINO — **corsa 3: a fine presidio, ANCORA in pausa**

**È la corsa che misura il criterio 6.** Confrontata con la corsa 2, dà a
macchina la prova di forza 1 del paragrafo 2.4: **due corse entrambe in pausa,
stesso ticket, SL diverso = un evento di gestione avvenuto DENTRO la pausa.**

**✅ Atteso:** ancora `PAUSA B1 grezzo=SI ricalcolato=SI` · `ESITO ... FERMATO` ·
e la riga `pos #<ticket> ... sl=...` per **le stesse posizioni della corsa 1**.

| cosa vedi confrontando gli `sl=` | come si legge |
|---|---|
| **SL cambiato** su un ticket | 🥇 **prova piena**: il trailing/breakeven ha lavorato **durante** la pausa |
| **volume calato** sullo stesso ticket | 🥇 **parziale eseguito** durante la pausa: stessa forza |
| tutto **invariato**, posizione ancora aperta | 🥈 vale come prova di forza 2 (la posizione non è stata toccata né chiusa) |
| **ticket sparito** | ⚠️ **non è automaticamente un FAIL**: può essere TP, SL, chiusura oraria. **Va spiegato con lo Storico**, screenshot alla mano |

## 1️⃣1️⃣ 🔧 **RIPRISTINO, PASSO 1 DI 2** — rimettere `InpDailyPausePct = 4.0`

Sul grafico del Guardian → **Proprietà → Parametri → `InpDailyPausePct` = 4.0** → OK.
📸 **Screenshot della finestra parametri PRIMA di premere OK.**

> 🔴 **QUESTO PASSO DA SOLO NON SPEGNE LA PAUSA.** È il rilievo **R2**: la pausa
> è un **latch**. `SetPausa` ha già timbrato le due GlobalVariable, e nessuno le
> azzera fino al **cambio di giorno prop** — riavviare il Guardian **non basta**
> (`OnInit` azzera la pausa solo se cambia la chiave del giorno).
> **Serve anche il passo 1️⃣3️⃣.**
>
> 🛑 **E l'ORDINE NON È INVERTIBILE:** se cancelli le GlobalVariable **prima** di
> rialzare la soglia, il giro di timer successivo (1 secondo) **le riscrive** —
> e ti ritrovi la pausa accesa credendo di averla tolta. Il referto finale
> **se ne accorge** (`SetPausa` stampa la riga di accensione SOLO quando la GV
> è a zero: **due accensioni dentro la sessione** = le GV sono state cancellate
> e il timer le ha riscritte **entro un secondo**, cioè PRIMA che tu rialzassi
> la soglia, non dopo) e in quel caso esce **ROSSO**.

## 1️⃣2️⃣ CANARINO — **corsa 4: la MISURA del latch** (30 secondi, e non è una formalità)

**✅ Atteso — e sì, è ancora SI:** **`PAUSA B1 grezzo=SI ricalcolato=SI`** ·
`ESITO PER UN EA ADESSO: un ingresso sarebbe FERMATO`, **con la soglia già
tornata a 4,0**.

> 🎯 **Questa corsa non serve al criterio: serve a DIMOSTRARE il rilievo R2** —
> cioè che l'uscita a un passo solo lascerebbe il 100k fermo per tutta la
> giornata, credendo di averlo liberato. Se ti torna `grezzo=NO`, qualcuno ha
> già cancellato le GV (o è cambiato il giorno prop): **scrivilo**, non
> passarci sopra.

## 1️⃣3️⃣ 🔧 **RIPRISTINO, PASSO 2 DI 2** — cancellare le DUE GlobalVariable (F3)

**Strumenti → Variabili globali** (o **F3**) → seleziona **una alla volta** e
premi **Elimina**:

| nome esatto | cos'è |
|---|---|
| `ABTG_PAUSA_GIORNO_50504263` | il timbro di accensione della pausa |
| `ABTG_PAUSA_FINO_50504263` | la scadenza dichiarata della pausa |

> 🛑🛑 **SOLO QUELLE DUE. NON esiste un motivo per premere "Elimina tutte".**
> In quella finestra ci sono anche `ABTG_GUARD_50504263_START`, `..._PEAK`,
> `..._DAYSTART`: sono **la memoria del Guardian**. Se le cancelli, al primo
> riavvio il Guardian ricostruisce il **saldo iniziale con quello di oggi** e
> il limite di drawdown totale (9,9%) si ritrova misurato da una base sbagliata
> — **in silenzio, senza nessuna riga di errore**. È il tipo di danno che si
> scopre settimane dopo.
> 🛑 E **non toccare** `ABTG_GUARD_50504263_BLOCKDAY`: quello è il blocco duro,
> non c'entra con questa prova.

📸 **Screenshot della finestra F3 DOPO la cancellazione** (deve mostrare che le
due righe non ci sono più).

## 1️⃣4️⃣ CANARINO — **corsa 5: il 100k è tornato a casa** ← **la sessione non è finita prima di questa riga**

**✅ Atteso:** **`PAUSA B1 grezzo=NO ricalcolato=NO`** ·
`GUARDIAN VIVO grezzo=SI ricalcolato=SI` · `MOTIVO ... 0 = nessuno` ·
**`ESITO PER UN EA ADESSO: un ingresso sarebbe PERMESSO`** · **`nessun rilievo`**.

📸 **E lo screenshot del pannello**, che deve dire
**`Pausa morbida (4.0%): libera`** — la parola è **`libera`**, non `ATTIVA` —
insieme a **4,9 / 9,9 / cap 3,25** e `Azione: CHIUDI+BLOCCA` (condizione **C-5**
del cancello di fase).

> 🔴 **Se dice ancora `ATTIVA` o il canarino dice ancora `grezzo=SI`: NON
> CHIUDERE LA SESSIONE.** Rifai 1️⃣1️⃣ → 1️⃣3️⃣ nell'ordine giusto e ricontrolla.
> Ogni minuto che passa con la pausa accesa è forward che non gira.

## 1️⃣5️⃣ RIGA 3 — **RACCOLTA FINALE** (referto + zip da mandarmi)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if($env:USERNAME -ne 'Administrator'){ throw ('SESSIONE WINDOWS SBAGLIATA: qui sei ' + $env:USERNAME + '. Il terminale -V3 del 100k gira sotto Administrator (misurato il 03/09): chiudi, entra nella sessione Administrator e rilancia.') };
    $pin='89c9003976f75cc6719aff3e9a4d2764962a95ab'; $t0=Get-Date; $p="$env:USERPROFILE\RIGA_COLLAUDO_FASE1_S2.ps1"; Remove-Item $p -Force -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_COLLAUDO_FASE1_S2.ps1" -OutFile $p -EA Stop;
    if(-not (Select-String -LiteralPath $p -SimpleMatch -Pattern 'MARCATORE_RIGA_COLLAUDO_FASE1_S2_v2' -Quiet)){ throw 'SCRIPT VECCHIO: non lancio niente' };
    $global:LASTEXITCODE=$null; & $p -Pin $pin -Chiusura; $rc=$LASTEXITCODE;
    $r=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S2_*\RIGA_REFERTO_COLLAUDO_FASE1_S2.txt'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S2_*\RIGA_REFERTO_COLLAUDO_FASE1_S2.txt') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    if($r.Count -eq 0){ throw 'NESSUN REFERTO DI ADESSO sul Desktop: copiami il rosso qui sopra.' };
    $z=@(Get-ChildItem -Path (Join-Path $env:USERPROFILE 'Desktop\COLLAUDO_FASE1_S2_*.zip'),(Join-Path $env:USERPROFILE 'OneDrive\Desktop\COLLAUDO_FASE1_S2_*.zip') -EA SilentlyContinue | Where-Object { $_.LastWriteTime -ge $t0 } | Sort-Object LastWriteTime -Descending);
    $ko=(($rc -is [int]) -and ($rc -ne 0));
    if($rc -isnot [int]){ Write-Host 'CODICE DI USCITA NON LETTO (capita su PS 5.1): fa fede il REFERTO, non il numero.' -ForegroundColor Yellow };
    if($ko){ Write-Host 'ESITO NON VERDE (1 = rosso/fermata, 2 = parziale): mandamelo LO STESSO, e'' quello che serve.' -ForegroundColor Yellow };
    if($z.Count -gt 0){ Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z[0].FullName) -ForegroundColor Cyan } else { Write-Host ('ZIP NON FATTO: mandami questa cartella -> ' + $r[0].DirectoryName) -ForegroundColor Yellow };
    $iv=[Globalization.CultureInfo]::InvariantCulture;
    Write-Host ('POI nel referto: riga data: = ORA DI AVVIO (circa ' + $t0.ToString('yyyy-MM-dd HH:mm',$iv) + '), riga fine: = quando ha finito, riga esito:. La freschezza l''ha gia'' controllata a macchina il filtro qui sopra.') -ForegroundColor Gray }
```

💡 Se vuoi che il referto ripeta anche **l'ora del gesto** che hai annotato al
passo 7️⃣, aggiungi `-OraGesto '15:31:00'` (con **la tua** ora) dopo `-Chiusura`.
**Non è necessario**: l'inizio della pausa lo legge il referto dalla riga del
Guardian, che è più precisa di un appunto a mano.

## 1️⃣6️⃣ E per ultimo: **G7** — annota nella pagella di oggi i **trade persi** per la pausa forzata.

---

## 📤 Cosa arriva sul Desktop (ogni riga, anche quelle che falliscono)

- Cartella `COLLAUDO_FASE1_S2_<data_ora>` con
  **`RIGA_REFERTO_COLLAUDO_FASE1_S2.txt`** (i PASSI + tutto il censimento),
  la copia del **log Esperti** e del **giornale** della giornata, i **referti
  del canarino** di oggi e la copia dell'**artefatto** scaricato dal pin.
- Zip omonimo `COLLAUDO_FASE1_S2_<data_ora>.zip` → **è quello che mi mandi**.
- `COLLAUDO_FASE1_S2_SEGNAPOSTO.txt` — lo scrive la riga 1️⃣: dice alla riga 3️⃣
  da che ora in poi contano le righe.

## 🔎 COME SI LEGGE IL REFERTO

1. **In testa, i PASSI** (`terminale:` `conto:` `artefatto:` `log:`
   `censimento:` `canarino:` `zip:`): hanno **tre stati veri**
   (`NON TENTATO` / `FALLITO` / `OK`), e sono timbrati dal ramo che li decide.
   Poi la riga **`esito:`**.
2. **`data:` è l'ora di AVVIO della lettura**, `fine:` è quando ha finito. La
   freschezza l'ha già controllata **a macchina** il filtro `LastWriteTime` del
   blocco che hai lanciato.
3. **Il censimento**: per ogni chiave dell'artefatto, quante righe e quali, con
   il conto separato di **quante sono dopo il segnaposto** (cioè dentro la
   sessione).
4. **La traccia delle soglie**: ogni riavvio del Guardian col valore della pausa
   dichiarato in quel momento — è il **diario a macchina dei tuoi gesti**:
   `4.00 → 0.03 → 4.00`. L'ultima riga deve dire **4,00 = configurazione
   firmata**, e il **cap deve essere rimasto 3,25 per tutto il tempo**.
5. **Il LATCH DELLA PAUSA**: quando è stata abbassata, quando è tornata a 4,00, e
   soprattutto **quante accensioni ci sono state dentro la sessione** — il
   Guardian ne stampa una sola per giorno prop, quindi **due o più vogliono
   dire che le GV sono state cancellate e riscritte** (ordine invertito del
   ripristino), a prescindere da quando cade la seconda rispetto al ritorno a
   4,00.
6. **Il GATE**: `dayLoss` letto dai log, con l'avviso se ≤ 0.
7. **I referti del canarino**, classificati da soli: *in pausa* / *pausa spenta*
   / *pausa scritta ma scaduta*, con **le posizioni e i loro SL**.
8. **CRITERIO 6 A MACCHINA**: il confronto delle posizioni fra corse
   consecutive, con l'etichetta `[ENTRAMBE IN PAUSA]` su quelle che contano.
9. **La finestra di pausa** e cosa è successo dentro: righe dei 5 EA divise fra
   blocchi e gestione, più le righe `modif` del giornale.
10. **Il verdetto a macchina**, con tre stati e senza barare: dice **PASS**,
    **NON MISURATO** o **ROSSO**, e dichiara in fondo **quello che nessuna
    macchina può dire** e che resta ai tuoi screenshot.

## ⚠️ TRE COSE DA SAPERE PRIMA DI LEGGERE (le trova il referto, ma meglio prima)

1. **`C6.PROMESSA` non è la prova del criterio 6 — è la promessa.** È la frase
   che l'include stampa **a ogni blocco** («La posizione eventualmente gia'
   aperta NON viene toccata.»). Contarla come prova sarebbe leggere una promessa
   come un fatto: **lo dice l'artefatto stesso**. La prova è il **confronto degli
   SL** fra le corse del canarino, più la tua scheda Trade.
2. **`C5.RIENTRO` (`via libera, il blocco e' rientrato (PAUSA GIORNALIERA...)`)
   può non comparire — e NON è un fallimento.** L'include la stampa solo se
   **quell'EA richiama la guardia** dopo il ripristino, e solo se **quell'EA era
   stato bloccato prima** (la memoria è una `static` interna, per programma). Se
   dopo il ripristino nessun EA aveva più motivo di valutare un ingresso, la
   riga non esce. La sua assenza **non si conta come FAIL**.
3. **I "blocchi orfani" si contano in DUE modi** e il referto stampa entrambi:
   la regola **letterale** dell'artefatto («causa nello **stesso minuto**») è più
   severa del codice — il Guardian scrive la causa **una volta sola**, al cambio
   di stato, e un EA può bloccare **dieci minuti dopo**. Il numero che conta è
   quello della **causa vigente**. È materiale del **criterio 9**: va deciso
   **prima** di quella sessione, non dopo.

## 🔢 Codici d'uscita

| codice | cosa vuol dire | cosa mandare |
|---|---|---|
| **0** | lettura completa | lo zip |
| **2** | parziale: artefatto non scaricato, log del giorno mancante, **oppure nessuna corsa del canarino leggibile a fine sessione** (lo stato della pausa non è misurato) | lo zip **lo stesso** (dice cosa manca) |
| **1** | **ROSSO**: conto sbagliato, riga VIETATA nel log, pin assente/malformato | lo zip **lo stesso** + fermarsi |
| **1** | 🔴 **ROSSO NUOVO DI QUESTA SESSIONE: la pausa è rimasta accesa** — o perché l'ultima corsa del canarino la vede ancora scritta, o perché il log mostra **più di un'accensione dentro la sessione** (le GV sono state cancellate e il timer le ha riscritte, ordine invertito) | **prima rimetti a posto** (1️⃣1️⃣ → 1️⃣3️⃣ → 1️⃣4️⃣), poi rilancia la riga 3 e mandami lo zip |
| **1** | **cartella dati del 100k non identificata** (zero candidate, oppure 2+) | lo zip **lo stesso**: dentro c'è l'elenco completo → rilancia con `-CartellaDati` |
| _(nessuno)_ | il blocco non arriva a lanciare: `irm` fallito o marcatore assente | copiami il **rosso in console** |

---

## 🧪 COSA È GIÀ STATO PROVATO SU BANCO (e cosa no)

**Provato ESEGUENDO** il driver su un banco stubbato (log MT5 finti in UTF-16,
referti del canarino finti, artefatto locale), 5 casi, tutti e tre i modi:

| caso | atteso | ottenuto |
|---|---|---|
| sessione riuscita (pausa accesa, EA bloccato, SL mosso in pausa, ripristino a due passi, **una sola** accensione) | PASS a macchina su criterio 5 e 6, uscita 0 | ✅ |
| giornata **in utile** (`dayLoss=-0,11%`) | `GATE CHIUSO`, "si rimanda" | ✅ |
| **GV cancellate PRIMA** di rialzare la soglia → il timer le riscrive entro 1 s (**due accensioni dentro la sessione**, la seconda cade PRIMA del ritorno a 4,00) | ROSSO, uscita 1, col conteggio delle riscritture | ✅ (classe 131: la prima versione del rilevatore guardava la finestra sbagliata — dopo il ritorno, non dentro la sessione — ed era stata cieca esattamente a questo caso; corretto e rieseguito) |
| **pausa rimasta accesa** (ultima corsa del canarino con `grezzo=SI`) | ROSSO, uscita 1 | ✅ |
| **nessun referto del canarino** in chiusura | PARZIALE, uscita 2, e **niente numeri della corsa precedente** | ✅ |

**NON provato** (e va detto, non dedotto): il comportamento sul **VPS vero**
(Windows PowerShell 5.1, cartella dati reale, log MT5 reali con le loro
intestazioni) e la **scoperta automatica** della cartella dati — che sulla
sessione 1 si era fermata al primo colpo. Se si ferma, c'è `-CartellaDati`.
