# 🗂️ CODA — cosa si fa appena Claudio e' davanti al PC

_Scritta il 16/08/2026 su sua richiesta: **"metti tutto in coda, quando arrivo
a casa davanti al pc facciamo tutto"**. Ordine pensato: prima le cose che
sbloccano le altre._

> ⚙️ **Regole che non cambiano**: MT5 CHIUSO sul PC di backtest · OHLC solo
> screening, verdetti solo a tick reali · **nessun parametro in forward si
> tocca** · commit e push a ogni passo.

---

## 1. 🧪 SCREENING DI `ABTG_MeanRevert` — due righe, in quest'ordine

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

## 2. 🔓 SBLOCCARE I DOMINI DELLE FONTI

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
