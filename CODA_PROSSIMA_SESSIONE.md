# 🗂️ CODA — cosa si fa appena Claudio e' davanti al PC

> ## 🌙 PIANO DELLA NOTTE 16→17/08 — deciso da Claudio
>
> Claudio voleva mettere i tre EA nuovi sul VPS per l'apertura di stanotte.
> **Ha scelto invece di misurarli prima**, e la ragione sta nei numeri: i tre
> EA hanno **ZERO backtest, ZERO referti**, e due non hanno nemmeno
> `@DAQUANDO`. In piu' **non c'e' fretta**: GAPFILL fa ~2 trade al mese,
> TurnaroundTuesday 1 a settimana, CanaleLento tiene le posizioni per
> settimane. Perdere un'apertura non costa niente; accendere codice mai
> misurato costa il conto (il 14/08, −104,60 per UN EA non previsto).
>
> **Il VPS resta com'e'. Stanotte lavora il PC.**
>
> | passo | dove | cosa |
> |---|---|---|
> | 1 | MetaEditor | **compilare i 3 EA** (F7). Se uno da' errore, si manda il messaggio esatto |
> | 2 | MT5 aperto | misurare lo storico di **GBPUSD H1** e **XAUUSD D1** |
> | 3 | — | **chiudere MT5** |
> | 4 | PowerShell | i **tre screening in OHLC**, uno dopo l'altro (una macchina, un lavoro) |
>
> **Le tre griglie:** `CanaleLento` XAUUSD D1 **20 celle** · `TurnaroundTuesday`
> GBPUSD H1 **24 celle** · `GapContinuation` 225JPY M1 **54 celle**.
> Tutte e tre **Modello 1 (OHLC)**: e' screening, e i file prova lo dicono
> tutti e tre. 🔴 **Il verdetto sara' solo a tick reali** (R57: cambiando
> solo il modello il segno dell'orso si e' ribaltato).
>
> ⚠️ `@DAQUANDO` di GBPUSD e XAUUSD **non si inventa**: esce dal passo 2 e si
> passa con `-DaQuando`. Domattina va scritto nei due file prova.

> ## ✅ AGGIORNAMENTO 16/08 ore 14:30 — I PRIMI DUE PUNTI SONO FATTI
>
> **1. Screening `ABTG_MeanRevert`: FATTO e BOCCIATO.** 12 celle su 12 in
> perdita su 11 anni e mezzo, PF massimo 0,986, DD fino al 37%. Famiglia
> chiusa, prova di regime NON lanciata (sarebbe una macchina su un cadavere).
> Referto: `risultati_archivio/REFERTO_ROUND60_MEANREVERT.md`.
>
> **2. Sblocco dei domini: FATTO E VERIFICATO.** `mql5.com` risponde
> **HTTP 200** ("Free download of trading robots... MQL5 Code Base") e
> `arxiv.org` **HTTP 200** (API `export.arxiv.org` con risultati reali).
> 🔓 **Il Code Base e la letteratura adesso si aprono da soli.**
>
> ### ⚠️ TRAPPOLA GIA' PAGATA: LA SESSIONE NUOVA PARTE SUL BRANCH SBAGLIATO
> La prima sessione lanciata dopo lo sblocco e' partita su
> `claude/verifica-siti-caccia-strategie-v5pzqv`, che punta a un commit di
> **due mesi fa** — e quindi non trovava ne' questo file, ne' l'agente
> `cacciatore-strategie`, ne' il `SETACCIO_MANUALE.md`. **Non e' un bug: e'
> il branch.** Prima cosa da fare in ogni sessione nuova:
> ```
> git fetch origin lavoro && git checkout lavoro && git log --oneline -3
> ```
>
> ### ✅ AGGIORNAMENTO 16/08 ore 15:15 — PUNTO 3 FATTO, E LE TRE CACCE ANCHE
>
> **Punto 3 — `Nikkei225_Gap_Continuation`: sorgente ripescato e lavorato.**
> Trovato sul Code Base (`mql5.com/en/code/75301`, v1.50, 43.393 byte) e letto
> per intero. Gli input erano **31, non 39** (8 erano `input group`); fuso
> risolto in ora server BCM (**01:00-07:30**, col calcolo e col buco DST
> dichiarato); asimmetria 1,25% spenta e messa in misura come assi separati.
> 🔴 **Non lanciabile: nel sorgente manca `OnTester`** — serve
> `mql5-ea-developer`. Poi la misura di `@DAQUANDO` sullo storico **M1** di
> `225JPY` (non si eredita da R36/R37: quelli erano H1).
> Dossier: `caccia_strategie/CACCIA_2026-08-16_C_NIKKEI_GAP.md`.
>
> **Tre cacce sui tre buchi, chiuse.** Mandato nuovo di Claudio applicato
> (§5.F "motore grezzo da rifinire" + §7-bis "cancello prop", scritti nel
> file dell'agente):
>
> | caccia | buco | promosso |
> |---|---|---|
> | **D** | laterale | 🥇 `001 - Turnaround Tuesday` (Code Base 73674) **9/10** |
> | **E** | crollo | 🥇 `BreakoutStrategy` (Code Base 49272) **9/10** |
> | **F** | short simmetrico | 🥇 **lo stesso `001 - Turnaround Tuesday`, 10/10** |
>
> 🎯 **D e F sono arrivate allo stesso EA partendo da due buchi diversi, senza
> parlarsi.** Un solo file prova, `prove/ABTG_TurnaroundTuesday.txt`.
>
> 🔬 **La scoperta che pesa piu' dei tre candidati** e' nel dossier E:
> **arXiv 2607.01550** (Kurth, Eisler, Rej, Bouchaud — CFM, 02/07/2026, ~100
> futures, 1995-2025) misura che il trend **veloce** e' passato da Sharpe
> **0,84 a 0,12** dopo il 2009, ed e' svanito **proprio su indici e valute**
> mentre regge su materie prime e tassi. **Il nostro universo e' il
> sottoinsieme dove e' morto, e le ~210 celle ORB sono la versione piu'
> veloce di quel segnale.** Non ribalta nessun verdetto: dice dove cercare.
>
> ⚠️ **Nessuno dei tre e' lanciabile oggi**: a tutti manca `OnTester`, e i
> due `@DAQUANDO` non misurati restano vuoti apposta.
>
> ### 🎯 QUINDI IL PROSSIMO PASSO E' IL 3, non l'1 e non il 2
> E prima di cacciare: **leggere `caccia_strategie/SETACCIO_MANUALE.md`**
> (22 file gia' setacciati, non si ricontrollano) e usare **l'agente
> `cacciatore-strategie`**, non dei general-purpose.
>
> ⚠️ **I tre buchi NON si deducono: sono misurati.** Stanno in
> `report/ROBUSTEZZA.md` e nei referti R50/R59 —
> **LATERALE** (`LARRY_GBPUSD` −6.445 nel 2019) ·
> **CROLLO** (`BB` +502 dove Larry fa −708) ·
> **SHORT simmetrico** (14 celle vive quasi tutte long-only).


_Scritta il 16/08/2026 su sua richiesta: **"metti tutto in coda, quando arrivo
a casa davanti al pc facciamo tutto"**. Ordine pensato: prima le cose che
sbloccano le altre._

> ⚙️ **Regole che non cambiano**: MT5 CHIUSO sul PC di backtest · OHLC solo
> screening, verdetti solo a tick reali · **nessun parametro in forward si
> tocca** · commit e push a ogni passo.

---

## 1. ✅ ~~SCREENING DI `ABTG_MeanRevert`~~ — **FATTO, BOCCIATO (R60)**

**Stato:** EA **scritto e COMPILATO** (44.394 byte, verificato il 16/08),
file prova con `@DAQUANDO 2015.01.01` misurato. **Manca solo lanciarlo.**

**Riga 1 — giro a vuoto** (un minuto, non lancia niente). E' il **punto 5
della checklist**, nato dall'errore di R58.

```
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/18925cb9cc51bad7d493052737cb416a6f4b29fd/backtest_pipeline/prove/ABTG_MeanRevert.txt" -OutFile "$env:USERPROFILE\ABTG_MeanRevert.txt"; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/18925cb9cc51bad7d493052737cb416a6f4b29fd/backtest_pipeline/walkforward_generico.ps1" -OutFile "$env:USERPROFILE\walkforward_generico.ps1"; powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\walkforward_generico.ps1" -Expert ABTG_MeanRevert -Prova "$env:USERPROFILE\ABTG_MeanRevert.txt" -Modello 1 -Deposito 100000 -Etichetta mr1 -SoloControllo
```

✅ **Deve stampare `spazzolati: 1` e `InpLookback 6 celle`.**
🛑 Qualunque altra cosa: **fermarsi e mandare lo screenshot.**

**Riga 2 — lo screening vero** (solo se la 1 dice `6 celle`):

```
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\walkforward_generico.ps1" -Expert ABTG_MeanRevert -Prova "$env:USERPROFILE\ABTG_MeanRevert.txt" -Modello 1 -Deposito 100000 -Etichetta mr1; $d=Join-Path ([Environment]::GetFolderPath("Desktop")) "mr1"; New-Item -ItemType Directory -Force -Path $d | Out-Null; Copy-Item "$env:USERPROFILE\risultati_prove\ABTG_MeanRevert\*mr1*" $d -Force -EA SilentlyContinue; Copy-Item "$env:USERPROFILE\gen_*mr1*.ini" $d -Force -EA SilentlyContinue; Get-ChildItem $d | Select-Object Name,Length | Format-Table -AutoSize; Compress-Archive -Path "$d\*" -DestinationPath (Join-Path ([Environment]::GetFolderPath("Desktop")) "mr1.zip") -Force; Write-Host "`nZIP: Desktop\mr1.zip" -ForegroundColor Green
```

📦 Nello zip: i due CSV **e le due `.ini`** (servono per controllare cosa ha
ricevuto MT5 senza doverle chiedere dopo).

🎯 **Il criterio n.1 e' congelato e non si ammorbidisce:** deve essere
**positiva nel LATERALE 2019**, dove `LARRY_GBPUSD` fa **−6.445**. Se e' rossa
anche li', la tesi e' morta e la famiglia si chiude.

---

## 2. ✅ ~~SBLOCCARE I DOMINI DELLE FONTI~~ — **FATTO E VERIFICATO**

**Il passo che moltiplica tutto il resto.** Procedura completa, lista dei 14
domini pronta da incollare, avvertenze:
`backtest_pipeline/caccia_strategie/PROMEMORIA_SBLOCCO_FONTI.md`

In due righe: **claude.ai/code** → icona a nuvola sopra la casella del
messaggio → ingranaggio sull'ambiente → **Network access: `Custom`** → domini
uno per riga → ⚠️ **spuntare "Also include default list of common package
managers"** (senza, si perde GitHub). Poi serve una **sessione nuova**.

---

## 3. 🕳️ `Nikkei225_Gap_Continuation` — **ED E' UN MOTORE DI APERTURA**

Promosso "in coda" nella seconda battuta di caccia. Prima di lanciarlo servono
tre cose, tutte gia' scritte in `SETACCIO_MANUALE.md`:

1. **sfrondare i 39 input** (le manopole vere sono ~7)
2. ⚠️ **risolvere il fuso**: e' tarato sul Nikkei di **Darwinex**, noi siamo su
   `225JPY` con **BCM un'ora indietro rispetto all'Italia**. Un EA di sessione
   con l'ora sbagliata misura un altro mercato.
3. **togliere l'asimmetria** `InpSellFullRiskFromGapPct = 1.25` (rischio
   diverso fra long e short: odore di taratura)

---

## 4. 📊 MISURE APERTE, piccole ma bloccanti

- **DD OOS originale di `COST_EURJPY`** — e' **l'unico numero** che separa
  quella cella da una promozione di rango (criterio A di R59).
- **Indici a tick reali su BCM**: `-Simboli "D30EUR,U30USD" -Timeframes "M1,H1" -Da 2015.01.01 -Auto`
- **Storico Pepperstone degli indici**, a mercato aperto.
- **Blocco LZMA** per i `.bi5` di Dukascopy (14 anni di indici fermi li').

---

## 5. 🧭 IL FILONE NUOVO: **motori per le APERTURE di DAX e Nasdaq**

_Intuizione di Claudio, 16/08. Merita un posto in coda, e merita anche i
numeri che gia' abbiamo — perche' cambiano DOVE cercare._

### Cosa abbiamo gia' misurato sulle aperture (e non va rifatto)

| round | cosa | esito |
|---|---|---|
| batteria ORB (R7-R13) | ~210 celle a tick reali, 4 mercati | _"il breakout puro al tocco e' morto ovunque"_ |
| **R42** | il **FADE** del range di apertura, NASUSD + D30EUR | **0 celle positive su 48** |
| **R45** | ORB sulla sessione di Londra | **0 celle verdi su 48** |
| **R12** | ORB + EMA200 + volumi sul Nasdaq | **48 su 48 negative OOS** |

> 🎯 **La lettura che resta da R42, ed e' la bussola di questo filone:**
> _"agli estremi del range di apertura non c'e' edge in nessuna direzione —
> **paga solo il RETEST**."_ Ed e' esattamente cio' che fa
> `ABTG_DAX_Apertura_EU`, che e' **live con win rate 81,0%**.

### Quindi dove si cerca DAVVERO

🚫 **Non** rottura, **non** fade: quelle due porte sono chiuse con 96 celle.

✅ **Si cerca:**
1. **Implementazioni esterne del RETEST** — l'unica meccanica di apertura che
   nei nostri dati paga. Confrontarle con la nostra ricetta e' un test vero.
2. **Il GAP di apertura in CONTINUAZIONE** — ed e' il candidato del punto 3.
   Noi abbiamo `ABTG_GapFill` (il gap **si chiude**, R36, `225JPY` promosso);
   la direzione opposta **non l'abbiamo mai misurata**, ne' sul Nikkei ne'
   sugli indici europei e americani. **Il candidato in coda e' gia' un motore
   di apertura: la sua tesi si trasferisce dritta su DAX e Nasdaq.**
3. **Il lato SHORT dell'apertura** — R54 ha bocciato lo short del Dow
   (PF OOS 0,840 su 73 trade), ma su DAX e Nasdaq non e' mai stato misurato
   come motore nato short, solo come ramo aggiunto.

### Parole per la caccia, aggiornate

| ✅ cerca | ❌ gia' coperto |
|---|---|
| **retest · gap continuation · opening drive · first pullback · reversal** | breakout · opening range · ORB · range fade · session |

---

## 6. 🐢 SUL FONDO (non urgenti, ma agli atti)

- Monte Carlo con **DD trailing** (il muro che si muove col picco)
- ricompilare gli EA con la guardia A4 sul VPS
- **staccare il PC dal conto live 50503392**
- misurare il **DST su BCM** — scadenza **25/10/2026**
- `SW_GBPUSD` TORO non riproduce R50 → **[INCERTO]**, aperto

---

> ### La frase da rileggere quando si riparte
> **Il collo di bottiglia oggi non e' il metodo, e non e' il materiale: e'
> quanto materiale riusciamo a far passare dal setaccio.** Su 22 file letti
> nel sorgente in una mattina: **1 promosso, 1 in coda, 12 scartati con
> motivo scritto**. Il setaccio funziona. Serve solo dargli piu' roba —
> ed e' il punto 2.
