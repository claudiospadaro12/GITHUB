# 🐻 SEDIA SHORT DAX su FTMO — la gemella al contrario della `770101`, gesto per gesto (25/09/2026)

**Scritto il 25/09/2026 sera** · branch `lavoro` · per il pacchetto firmato in `report/FIRME_2026-09-25.md`
🚫 **Nessun EA toccato, nessun preset esistente modificato, niente in campo.** Qui ci sono un preset nuovo,
una riga che lo porta sul terminale e i gesti a mano. **Niente parte verso Claudio prima del PASS del cancello.**
🚫 Conto reale **10105439**: compare solo per dire che **non** si tocca.

> ## 🖊️ LA FIRMA, e di chi è
> Claudio, testuale (chat del 25/09 sera): _"FACCIAMOLA ESATTAMENTE COME LA VERSIONE LONG DEL RETEST, STESSI
> SETTAGGI MA AL CONTRARIO. TI AUTORIZZO IO."_ — conto e taglia: _"FTMO 541452707 al 2%"_.
> 🔴 **La decisione e la taglia `InpRiskPercent=2.00` sono di Claudio.** Questo documento non propone
> nessun'altra taglia e non rimette in discussione la firma: mette accanto i numeri, come promesso.

---

## ⓪ 🎯 IN UNA RIGA

**Magic nuovo `770105`** · preset `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set` = il preset
della `770101` **byte per byte, salvo tre righe** · **stesso binario in campo** (`CLAU12_DAX_Apertura_EU`) ·
**grafico NUOVO** `GER40.cash` **M5** accanto a quello della `770101` · le due istanze hanno **slot del giorno
separati** (letto nel codice) · ✅ **FTMO ammette per iscritto le posizioni opposte sullo STESSO conto**.

🟢 **E una buona notizia che non ci aspettavamo, misurata nel codice (§③.3)**: per come sono costruiti
ingressi e stop, **la long e la short di questa coppia non possono stare aperte INSIEME** — il livello che
arma una è esattamente lo stop dell'altra. Il giorno peggiore della coppia è **uno stop DOPO l'altro**, mai
due stop in contemporanea.

---

## ① 🖥️ IL BERSAGLIO — detto prima di ogni cosa

| cosa | dove |
|---|---|
| **la riga del §⑤** | 🖥️ **finestra PowerShell sul VPS** `VMI3047753`. Scrive **un solo file** nella cartella dati del terminale FTMO. Non apre e non chiude nessun MT5 |
| **i gesti del §⑥** | ✋ **azione a mano dentro MT5**, **SOLO** sul terminale 🪟 **FTMO `541452707`** (cartella programma **`C:\FTMO`**) |

🚫 **NON si toccano, per nome** (classe 755, elenco dal censimento `CODA_03`/`CODA_06` del 25/09):
- sul terminale FTMO: il **grafico della `770101`** (`GER40.cash` M5, `chart01`), le altre sedie
  (`770202` `770260` `771531` `770511` `770411`), il **Guardian** `779001` (`NZDJPY`), `ABTG_TradeExporter`,
  `ABTG_SpreadLogger`, e il pulsante **Algo Trading** della barra in alto;
- sul VPS: il **REALE `10105439`** (`C:\BCM_Reale`), il **100k `50504263`** (`BCM Markets MT5 Terminal -V3`),
  il **piccolo `50503392`** (`BCM Markets MT5 Terminal`, senza `-V3`), il **manuale `50503635`**
  (`C:\MT5_MANUALE`), il **banco `50504400`** (`C:\MT5_Backtest`, **spento**: resta spento), **Pepperstone**,
  **Tickmill**.

---

## ② 🧾 IL PRESET — cosa cambia rispetto alla `770101`, e nient'altro

**File:** `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set` · commit `3d23327e` · ASCII puro ·
SHA256 `9F936D7BE3DA3C2C3A85B1C9FBE611CCEE1F47D16DFA1DE5CA5A34B0BA5730CC`.

| riga | `770101` (long, in campo) | `770105` (short, nuova) |
|---|---|---|
| `InpAllowLong` | `true` | **`false`** |
| `InpAllowShort` | `false` | **`true`** |
| `InpMagic` | `770101` | **`770105`** |
| **tutte le altre 79** | identiche | identiche |

- 📎 **Come si verifica, a macchina**: sotto la riga `COPIA DEL PRESET 770101` il file è
  `ABTG_DAX_Apertura_EU_770101_FTMO.set` (SHA256 `234b4b40…`, ultimo commit `0127d449`) e il `diff` dà
  **esattamente tre righe** (227, 228, 303). Sopra c'è un'intestazione nuova (firma, bersaglio, contratto,
  marcatore `MARCATORE_PRESET_SHORT_DAX_FTMO_v1`); l'intestazione vecchia resta sotto, è la storia della `770101`.
- 🟢 **Confronto col grafico VIVO, non solo col repo**: la foto del `.chr` della `770101` su `C:\FTMO`
  (`CODA_08_preset_dai_chr_20260925_033004.log` r.3054-3140, `.chr` salvato il **24/09 08:06**) ha
  **82 input su 82 uguali** al preset del repo (l'unico scarto di testo è `2.0` contro `2.00`: stesso numero).
  ⚠️ Una modifica fatta a mano dopo il 24/09 08:06 **senza salvare il profilo** questa foto non la vede.
- Restano quindi, come sulla long: sessione **10:00** server FTMO, range **35** minuti, chiusura **19:30**,
  RETEST con offset 200 e buffer 500, parziale 50% a 1R con breakeven, trailing PREVBAR M5,
  `InpOneTradePerDay=true`, `InpUsaGuardian=true`, `InpMaxPosSimbolo=0`, **`InpRiskPercent=2.00`**.

### Perché `770105`
Famiglia `7701xx` = apertura DAX (convenzione di casa: `770101` sedia, `770102`/`770111` gemelli
_Ottimizzato_, `770103`/`770104` celle di test, `770151` asse di gestione). **`770105` non compare da
nessuna parte**: zero occorrenze nel repo (worktree degli agenti compresi) e zero nella storia git
(`git log -S770105 --all` = 0). È il primo numero libero della famiglia.

---

## ③ 🔍 LE DUE ISTANZE SULLO STESSO `GER40.cash` — letto nel codice che gira davvero

### ③.1 Quale codice
Sul terminale FTMO gira **`CLAU12_DAX_Apertura_EU`**, compilato il **20/09 16:58**
(`CODA_06_quale_codice_gira_20260925_033004.log` r.209); gli `ABTG_*` in `C:\FTMO` **non hanno `.ex5`**
(r.183). È la copia rinominata di `ABTG_DAX_Apertura_EU.mq5` al pin **`9fca63d9`** (`report/RINOMINA_CLAU12_2026-09-20.md`,
SHA verificato prima della rinomina), **2425 righe** (CODA_06 ne conta 2426: stesso scarto di +1 visto su
tutti i file). Classe 783 rispettata: **il preset è scritto per quel binario**, con i suoi **82 input, stessi
nomi, stesso ordine** (confronto meccanico). **Non serve nessun F7**: il binario è già lì, si attacca lo
stesso EA una seconda volta.

### ③.2 Cosa condividono e cosa no (righe al pin `9fca63d9`)
| stato | dove | condiviso fra le due istanze? |
|---|---|---|
| **slot del giorno** (`InpOneTradePerDay`) | `CicliOggi()` r.804-833: conta i deal di **ENTRATA** del giorno filtrando **simbolo + `DEAL_MAGIC == InpMagic`** (r.825); guardia r.628 | 🟢 **NO**: ogni magic ha il **suo** giorno. **Lo short non ruba il giorno alla long, e viceversa** |
| posizioni gestite (parziale, BE, trailing) | `ManagePosition()` r.1875: simbolo + magic | 🟢 NO |
| pendenti e OCO | `CancelMyPendings()` r.1833-1840, `HandleOCO()` r.1850: simbolo + magic | 🟢 NO |
| chiusura di fine sessione / news | `ChiudiMiePosizioni()` r.2160 (r.2107): **per TICKET** fra le proprie (toppa del 19/09) | 🟢 NO — la vecchia `PositionClose(_Symbol)` chiudeva quella del vicino; **qui non c'è più** |
| variabili in memoria (`gPhase`, range, ticket…) | globali del programma: **una copia per grafico** | 🟢 NO |
| GlobalVariable | l'EA **non ne scrive nessuna**; l'include in campo (v1.20, pin `26a18566`) **legge** quelle del Guardian, con nome **per CONTO** (`ABTG_GVNome` = radice + login) | 🟢 condivise **apposta**: pausa B1 e cap C1 valgono per tutto il conto |
| file | solo `OnTester` (r.2326-2328) e l'ottimizzazione; lettura di `abtg_news.csv` solo col filtro news acceso (spento) | 🟢 niente in campo |
| testo sul grafico | **nessun `Comment()`** nel sorgente | — |
| tetto per simbolo contando tutti gli EA | `InpMaxPosSimbolo=0` (r.258) = spento in tutti e due | 🟢 se fosse >0 si conterebbero a vicenda: **non va acceso** |
| **commento degli ordini** | stringa **FISSA**: `"DAX Apertura EU RETEST BUY"` (r.1504) / `"DAX Apertura EU RETEST SELL"` (r.1537), non dipende dal magic | 🟢 **si distinguono lo stesso**: la long scrive solo BUY, la short solo SELL, e l'altra sedia DAX short (`770411`) ha il suo commento `MAXMIN DAX SHORT` |

🟠 **Una cosa invece è uguale, e va saputa per leggere i log**: il prefisso delle righe nella scheda Esperti è
`[DAX Apertura EU]` per **tutte e due** (è un `#define`, r.31), e la scheda scrive per tutte e due
`CLAU12_DAX_Apertura_EU (GER40.cash,M5)`. Le due istanze si distinguono dal **contenuto** della riga
(`lati=SOLO SHORT` / `SOLO LONG`, `RETEST SELL` / `RETEST BUY`), non dall'intestazione.

### ③.3 🟢 La coppia NON può stare aperta insieme — e il contro-esempio che ho provato a costruire
Nel ramo RETEST (`MonitorRetest()`, r.1465-1545): la short si arma quando `bid <= sellTrig`, con
`sellTrig = rangeLow − buffer` (r.1472); **lo stop della long è proprio `sellTrig`** (r.1489, `InpSLMode=0`
= stop sul bordo opposto). Specularmente la long si arma a `buyTrig` (r.1471), **che è lo stop della short**
(r.1522). Il buffer è `max(500 punti, stops level)` (r.2075-2080): **identico per le due istanze**, che
leggono lo stesso simbolo sullo stesso M5.
- 🧪 **Contro-esempio cercato**: *long aperta, il prezzo scende, la short entra mentre la long è ancora
  viva?* No: la short si **arma** allo stesso tick in cui la long **viene stoppata** (stesso prezzo, stesso
  lato del book), e l'ordine che piazza è un **SELL LIMIT a `rangeLow + 200`**, **sopra** il prezzo: si
  riempie solo se il prezzo **risale di ~700 punti**, a long già chiusa. Il trailing e il breakeven
  **alzano** lo stop della long, quindi la chiudono **prima**, mai dopo. Idem a specchio.
- ⚠️ **Il residuo, dichiarato**: uno stop lato server che non viene eseguito mentre il prezzo fa 700 punti
  nel verso opposto. Non l'ho misurato; non ho trovato un modo realistico perché succeda.
- 👉 Quindi **la coppia `770101`+`770105` non crea mai un'esposizione opposta simultanea**, e **non somma
  mai 4% di rischio aperto da sola**. La somma simultanea resta possibile **con le altre sedie** (§⑤).

---

## ④ ⚖️ LE REGOLE FTMO — cosa dicono i documenti, alla lettera

### ④.1 Posizioni opposte sullo STESSO conto — ✅ **ammesse per iscritto**
Supporto FTMO (Xavier Rocha), risposta ricevuta da Claudio il **24/09/2026**, `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md`:
> «We allow hedging within the same trading account on our platform. This means you are free to buy and sell
> the same instrument within a single account as part of your risk management strategy. There are no
> restrictions from our side regarding hedging in this manner, and we support our traders in employing such
> strategies to protect their trades.»

E la stessa pagina delle Forbidden Practices, già nel dossier di agosto (`docs/REGOLAMENTO_FTMO_2026-08.md`
r.91, *letta via ricerca*): il divieto di *«simultaneously entering into opposite positions»* riguarda più
conti, *«eccezione: posizioni opposte sullo STESSO conto»*.
🟠 **Una voce da conoscere** (stesso dossier, r.94, *letta via ricerca*, non riverificata alla fonte):
> «strategies that artificially distribute profit across multiple days without proportionally distributing
> market risk, such as hedging or holding opposing positions on the same or highly correlated instruments.»

Per il §③.3 questa coppia **non tiene mai posizioni opposte insieme**, quindi questa voce non la descrive.
`docs/REGOLAMENTO_FTMO_2026-09-20.md` **non parla** di posizioni opposte sullo stesso conto (verificato per
parola: nessuna occorrenza).

### ④.2 🔴 Posizioni opposte fra conti DIVERSI — vietate, e la sedia nuova ne crea un'occasione in più
Seconda risposta del supporto (Jonas Friedrich, **25/09**, `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md`):
> «Opposite positions across different accounts can fall under the Forbidden Trading Practices regardless of
> whether the accounts are FTMO accounts, accounts with another prop firm, broker accounts, demo accounts, or
> private accounts.» · «cross-hedging can also involve correlated instruments, not only the exact same symbol.
> For example, long DAX on one account and short Dow Jones or Nasdaq on another» · «FTMO does not distinguish
> the rule based on whether the opposite exposure was intentional or accidental.»

👉 **Cosa vuol dire per la `770105`**: finora su FTMO la DAX d'apertura era solo **long**. Da quando la short è
accesa, **una qualunque posizione LONG su DAX, Dow o Nasdaq in un altro conto** (REALE `10105439`, 100k
`50504263`, piccolo `50503392`, manuale `50503635`, Pepperstone, Tickmill — **demo compresi**) mentre la
`770105` è aperta **è la fattispecie vietata**.
- 🟢 La rete c'è ed è firmata: le sospensioni del **24/09** (REALE e 100k) e del **25/09**
  (`report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`: 15 grafici indice del piccolo + il `225JPY` del 100k).
- 🔴 **Che quelle sospensioni siano ESEGUITE è `[NON VERIFICATO]` da qui**: la prova è la sonda notturna
  (`CODA_01`) della prossima notte, che deve mostrare **zero sedie indice** su quei terminali. 👉
  **Prerequisito prima di accendere la `770105`.**
- ⚠️ Con una sonda sul VPS si vedono i terminali del VPS: il piccolo è loggato anche sul PC di backtest
  (classe 792), quindi quel conto si verifica dallo **Storico lato server**, non dal VPS.

### ④.3 🟠 «Esposizione cumulata sullo stesso simbolo» — tre sedie su `GER40.cash`
`docs/REGOLAMENTO_FTMO_2026-09-20.md` §④ (*letto via ricerca*, 20/09), testo di FTMO:
> «undertaking repeated simulated trading activity that results in higher Risk per Trade Idea, thereby
> exposing your simulated account to cumulative exposure in a specific symbol or correlated symbols.»

Con la `770105` le sedie su `GER40.cash` diventano **tre**: `770101` long, `770411` short (M15), `770105`
short (M5). La `770411` e la `770105` sono **meccanismi diversi nello stesso verso** e **possono stare aperte
insieme**: **4,00% di rischio sullo stesso simbolo nello stesso verso**. Lo stesso documento chiama il cap C1
*«la difesa contro questa regola»* e dice che la sanzione descritta è **gradata** (*«first warned»*). **Nessuna
decisione qui**: è un fatto da sapere.

---

## ⑤ 🛡️ IL GUARDIAN CON UNA SEDIA IN PIÙ AL 2% — solo numeri

**Guardian in campo** (`CODA_08` del 25/09, `chart06`, = `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`):
`InpStartBalance=80000` · pausa giornaliera **3,5%** (2.800 €) · emergenza giornaliera **4,5%** (3.600 €) ·
emergenza totale **9,3%** (72.560 €) · cap rischio aperto **4,00%**. Tutte le soglie giornaliere sono in % dei
**80.000** (`ABTG_Guardian.mq5` v1.12 r.393-401) e la perdita del giorno è **equity** contro inizio giornata.
La taglia è il 2% del **SALDO** al momento dell'ordine (`CalcLotByRisk`, r.1794).

**Punto di partenza** `[DERIVATO]` da `report/TERZO_STOP_FTMO_2026-09-25.md`: saldo **75.090,72 €** dopo il
terzo stop. Se il saldo di Claudio è diverso, i numeri si spostano di conseguenza.

### ⑤.1 Il giorno peggiore della coppia: la long stoppata, POI la short stoppata (§③.3: in fila, non insieme)
| | € | % dei 80.000 |
|---|---:|---:|
| stop 1 (2% di 75.090,72) | −1.501,81 | 1,88% |
| stop 2 (2% del saldo rimasto, 73.588,91) | −1.471,78 | 1,84% |
| **giorno peggiore della coppia** | **−2.973,59** | **3,72%** *(= 3,96% del saldo d'inizio giorno)* |
| contro la **pausa** 3,5% (2.800) | 🔴 superata di 173,59 → blocca i **nuovi** ingressi di tutte le sedie per il resto del giorno | |
| contro l'**emergenza giornaliera** 4,5% (3.600) | 🟠 non raggiunta da sola: **mancano 626,41 €**. Basta che un'altra sedia perda ~0,4 R lo stesso giorno | |
| contro il **muro FTMO giornaliero** 5% (4.000) | margine **1.026,41 €** | |

🔴 **E contro l'emergenza TOTALE 9,3%**: dal saldo di oggi mancano **2.530,72 €**; la coppia nel suo giorno
peggiore ne perde **2.973,59**. 👉 **Arriva prima l'emergenza del Guardian**: chiude tutto a **72.560** e
ferma la challenge **senza scadenza** (latch `GV_FAILED`, classe 796). È lo stesso esito dei *"due stop di
fila"* di `TERZO_STOP` §3 — con la `770105` c'è **una strada in più** per arrivarci **nello stesso giorno**.
Il muro FTMO del 10% (72.000) resterebbe intatto per **117,13 €** se l'emergenza non intervenisse; lo
slittamento della chiusura d'emergenza è `[NON MISURATO]`.

### ⑤.2 Due stop INSIEME: la short con un'altra sedia (non con la long)
| | € | % dei 80.000 |
|---|---:|---:|
| due posizioni al 2% aperte insieme (es. `770105` + `770411`, o + `770202`) | −3.003,62 | 3,75% *(= 4,00% del saldo)* |
| il cap C1 a 4,00% | 🟠 **lascia entrare la seconda** (rischio aperto 2,00 < 4,00). La **terza** viene fermata solo se il cap è già acceso **quando l'ordine parte**: un pendente piazzato prima scatta lo stesso (classe 645, e le sedie entrano tutte per pendente) | |
| contro l'emergenza totale | saldo finale 72.087,10: **472,90 € sotto** i 72.560 → **fermata del Guardian** | |

🔴 **Quanto spesso capiterà, e quanto costa in probabilità di passare la challenge, è `[NON MISURATO]`**:
il Monte Carlo dallo stato di oggi (`report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md`: PASS 57,2%, fine corsa
entro 5 giorni 21-24%) **non contiene la `770105`**. Anche il DD della **coppia** long+short in due istanze
separate è `[NON MISURATO]`: la FASE M *"long + short"* (OOS PF 1,237, DD 10,49%) era **un'istanza sola con
slot condiviso**, cioè un'altra cosa (`report/LATO_SHORT_DAX_APERTURA_2026-09-25.md` §2).

---

## ⑥ 📜 IL CONTRATTO DICHIARATO DELLA `770105` — con le sue etichette

**Fonte:** R251, `report/REFERTO_R251_2026-09-25.md` §2, cella **"ancora"** = short identico al long.
D30EUR M5 **BCM**, tick reali, **deposito 10.000**, **rischio 1%**.

| gamba | finestra | PF | n (Trades) | DD_fisso | peggior giorno |
|---|---|---:|---:|---:|---:|
| IS | 2024.09.26-2025.06.30 | **0,846** | 152 | **11,19%** | −1,06% |
| OOS | 2025.07.01-2026.06.30 | **1,065** | 243 | **12,74%** | −1,00% |

- 🔴 **Alla taglia firmata (2,00%)** il DD_fisso OOS scala a **~25% (25,49%)** — **LIMITE SUPERIORE**: scala
  lineare (classe 547) e, a deposito 10.000, lotto arrotondato (classe 791). Il muro FTMO del Max Loss è il
  **10% statico**.
- 🔴 **Esito del cancello di R251 su questa cella: BOCCIATA PER RISCHIO** (soglie del long: 5,79% / 8,21%).
  **La sedia va in campo per firma di Claudio, non per promozione**: va scritto così in ogni tabella.
- 📊 Posizioni OOS **181** (per-trade `792520`), cioè ~0,7 per giorno di borsa. Per stagione (FIRME 25/09):
  **estate PF 1,39** (96 posizioni) · **inverno PF 0,90** (85).
- 🕰️ **Orologio**: nel backtest BCM d'inverno l'ora 8 arma **un'ora prima** della cash
  (`report/OROLOGIO_BCM_2026-09-24.md`); **FTMO è in fase con la cash tutto l'anno** (IT+1). **R252**
  (`backtest_pipeline/prove/R252a..f`, commit `81ceaab1`) lo sta misurando: **i numeri qui sopra possono
  cambiare** con quella misura, in un verso che oggi non si conosce.
- 🪑 **Corsia RISCHIO del criterio di uscita** (firma del 18/08): il DD promesso da confrontare col forward è
  quello di questa tabella **alla taglia vera** — cioè il 25,49% limite superiore. ⚠️ **Contro il muro del
  10% quella corsia non scatterà mai prima del muro**: chi sorveglia la sedia deve saperlo.

---

## ⑦ 📦 COME ARRIVA IL PRESET SUL TERMINALE — una riga, come il 20/09

Il 20/09 i dieci preset sono arrivati in `MQL5\Presets` del terminale FTMO con **una riga pinnata**
(`SCHIERA_FTMO.ps1`, `SCHIERAMENTO_FTMO_2026-09-20.md` §5.2), **non a mano**. Per **un** file solo non
rilancio quello script (rifarebbe il giro su dieci sorgenti e dieci preset): la riga qui sotto ne copia
le serrature essenziali e scrive **solo** il preset nuovo.

> # 🖥️ **BERSAGLIO: finestra PowerShell sul VPS `VMI3047753`.** Nessun MT5 da aprire o chiudere.
> Scrive **UN SOLO file** (`ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set`) in `MQL5\Presets` della cartella
> dati del terminale **FTMO `541452707`** (`C:\FTMO`, cartella dati `46C9F8E9FF0C747B2B5E09BCC13D5237`).
> 🚫 **NON tocca**: il grafico della `770101` e le altre sedie FTMO, il Guardian, il REALE `10105439`
> (`C:\BCM_Reale`), il 100k `50504263` (`-V3`), il piccolo `50503392`, il manuale `50503635`
> (`C:\MT5_MANUALE`), il banco `50504400` (`C:\MT5_Backtest`), Pepperstone, Tickmill.
> Il terminale FTMO **può restare aperto**: un `.set` MT5 non lo riscrive.

File: `backtest_pipeline/righe/RIGA_PRESET_SHORT_DAX_FTMO.txt` (una riga, ASCII, identica al blocco).

```powershell
& { if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753. Macchina attuale: ' + $env:COMPUTERNAME + '. Non ho scaricato ne scritto niente.') }; $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; $INV=[Globalization.CultureInfo]::InvariantCulture; $t0=Get-Date; $ts=$t0.ToString('yyyyMMdd_HHmmss',$INV); $pin='3d23327ee7ffee1d09f63d7ccaab332dff4736a8'; $nome='ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set'; $SHA='9F936D7BE3DA3C2C3A85B1C9FBE611CCEE1F47D16DFA1DE5CA5A34B0BA5730CC'; $HD='46C9F8E9FF0C747B2B5E09BCC13D5237'; $CONTO='541452707'; $L=New-Object System.Collections.ArrayList; $esito='FERMATO'; $out=$null; function D($m,$c){ [void]$L.Add($m); if($c){ Write-Host $m -ForegroundColor $c } else { Write-Host $m } }; function LT($p){ $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite); $g=0; try { $b=New-Object byte[] $fs.Length; while($g -lt $b.Length){ $k=$fs.Read($b,$g,$b.Length-$g); if($k -le 0){ break }; $g+=$k } } finally { $fs.Close() }; if($g -ge 2 -and $b[0] -eq 255 -and $b[1] -eq 254){ return [Text.Encoding]::Unicode.GetString($b,2,$g-2) }; $z=0; $n=[math]::Min(400,$g); for($i=1;$i -lt $n;$i+=2){ if($b[$i] -eq 0){ $z++ } }; if($z -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b,0,$g) }; return [Text.Encoding]::UTF8.GetString($b,0,$g) }; $dsk=$null; foreach($c in @([Environment]::GetFolderPath('Desktop'),(Join-Path $env:USERPROFILE 'Desktop'))){ if((-not $dsk) -and $c -and (Test-Path -LiteralPath $c)){ $dsk=$c } }; if(-not $dsk){ $dsk=$env:USERPROFILE }; $out=Join-Path $dsk ('PRESET_SHORT_DAX_FTMO_' + $ts); New-Item -ItemType Directory -Path $out -Force | Out-Null; try { D ('=== PRESET DELLA SEDIA 770105 (SHORT DAX) SUL TERMINALE FTMO -- ' + $t0.ToString('yyyy-MM-dd HH:mm:ss',$INV) + ' ora Windows del VPS ===') 'Cyan'; D ('BERSAGLIO: finestra PowerShell sul VPS VMI3047753. Scrive UN SOLO file, ' + $nome + ', nella cartella MQL5\Presets del terminale FTMO ' + $CONTO + ' (cartella programma C:\FTMO). Non apre e non chiude MT5, non tocca grafici, EA, profili, ordini, posizioni.') 'Yellow'; D 'VIETATO TOCCARE, e questa riga NON tocca: il grafico della 770101 e le altre sedie FTMO, il Guardian, il piccolo 50503392 (BCM Markets MT5 Terminal), il 100k 50504263 (-V3), il REALE 10105439 (C:\BCM_Reale), il banco 50504400 (C:\MT5_Backtest), il manuale 50503635 (C:\MT5_MANUALE), Pepperstone, Tickmill.' 'Yellow'; $dati=Join-Path $env:APPDATA ('MetaQuotes\Terminal\' + $HD); if(-not (Test-Path -LiteralPath $dati)){ throw ('non trovo la cartella dati ' + $dati + ' -- questa riga gira come utente ' + $env:USERNAME + ': deve essere lo stesso utente che fa girare i terminali.') }; $og=Join-Path $dati 'origin.txt'; if(-not (Test-Path -LiteralPath $og)){ throw 'manca origin.txt nella cartella dati: non posso certificare di chi e, e senza certificato non scrivo.' }; $oi=((LT $og) -replace '[^\u0020-\u007E]','').Trim().TrimEnd('\'); if($oi -ne 'C:\FTMO'){ throw ('VIETATO: origin.txt dice [' + $oi + '] e non C:\FTMO. Non e la cartella del terminale FTMO: non scrivo.') }; D ('[1/5] cartella dati ' + $HD + ' -> origin.txt = ' + $oi + ' : OK') 'Green'; $lg=Join-Path $dati 'logs'; $txt=''; $nl=0; if(Test-Path -LiteralPath $lg){ foreach($x in @(Get-ChildItem -LiteralPath $lg -Filter *.log -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10)){ $txt += (LT $x.FullName); $nl++ } }; if($txt -notmatch ('(?<![0-9])' + $CONTO + '(?![0-9])')){ throw ('nei ' + $nl + ' giornali piu recenti (logs) di quella cartella NON trovo il conto ' + $CONTO + ': non la certifico come FTMO e non scrivo.') }; D ('[2/5] giornale: conto ' + $CONTO + ' trovato in ' + $nl + ' file di logs : OK') 'Green'; $pre=Join-Path $dati 'MQL5\Presets'; if(-not (Test-Path -LiteralPath $pre -PathType Container)){ throw ('non esiste ' + $pre + ' -- il 20/09 i preset sono stati copiati li: se manca, qualcosa e cambiato. Non la creo io.') }; $f=Join-Path $out $nome; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set" -OutFile $f; if(-not (Select-String -LiteralPath $f -SimpleMatch -Pattern 'MARCATORE_PRESET_SHORT_DAX_FTMO_v1' -Quiet)){ throw 'FILE VECCHIO: il preset scaricato non porta il marcatore MARCATORE_PRESET_SHORT_DAX_FTMO_v1. Non scrivo.' }; $h=(Get-FileHash -LiteralPath $f -Algorithm SHA256).Hash; if($h -ne $SHA){ throw ('IMPRONTA DIVERSA dal preset verificato: ' + $h + ' -- non scrivo.') }; $rr=@(Get-Content -LiteralPath $f); foreach($q in @('InpMagic=770105','InpAllowLong=false','InpAllowShort=true','InpRiskPercent=2.00','InpSessionHour=10','InpCloseHour=19','InpOneTradePerDay=true','InpUsaGuardian=true')){ if(-not ($rr -contains $q)){ throw ('il preset non contiene la riga ' + $q + ': non scrivo.') } }; D '[3/5] preset scaricato dal pin, marcatore e SHA256 giusti, righe chiave presenti (magic 770105, SOLO SHORT, rischio 2.00, ore 10 e 19:30) : OK' 'Green'; $dst=Join-Path $pre $nome; if(Test-Path -LiteralPath $dst){ $hd2=(Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash; if($hd2 -eq $SHA){ D '[4/5] GIA IDENTICO: il file e gia nel terminale, uguale al byte. Nessuna scrittura.' 'Green'; $esito='FATTO (gia presente)' } else { Copy-Item -LiteralPath $dst -Destination (Join-Path $out ('GIA_PRESENTE_E_DIVERSO_' + $nome)); throw ('nel terminale c e GIA un ' + $nome + ' DIVERSO (SHA256 ' + $hd2 + '): forse ritoccato a mano. NON lo sovrascrivo. Una copia e nello zip.') } } else { Copy-Item -LiteralPath $f -Destination $dst; if((Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash -ne $SHA){ throw 'COPIA NON VERIFICATA: il file scritto nel terminale non ha lo SHA256 atteso. Mandami lo zip.' }; D ('[4/5] SCRITTO e riletto dal disco: ' + $dst) 'Green'; $esito='FATTO' }; D '[5/5] Adesso i passi a mano del referto SEDIA_SHORT_DAX_FTMO: grafico NUOVO GER40.cash M5, trascinare CLAU12_DAX_Apertura_EU, Carica questo preset.' 'Cyan' } catch { D ('FERMATO: ' + $_.Exception.Message) 'Red' } finally { D ('ESITO: ' + $esito) $null; $L | Set-Content -LiteralPath (Join-Path $out 'REFERTO.txt') -Encoding ASCII; $z=$out + '.zip'; Compress-Archive -Path (Join-Path $out '*') -DestinationPath $z -Force; Write-Host ('File nella cartella: ' + ((@(Get-ChildItem -LiteralPath $out) | ForEach-Object { $_.Name }) -join ', ') + '   (attesi: REFERTO.txt e, se il download e arrivato, ' + $nome + ')') -ForegroundColor Cyan; Write-Host ('MANDA IN CHAT QUESTO FILE: ' + $z) -ForegroundColor Cyan } }
```

⏱️ **~2-3 secondi.** A fine corsa trovi sul **Desktop del VPS** la cartella `PRESET_SHORT_DAX_FTMO_<data>` e
lo zip accanto. **File attesi dentro**: `REFERTO.txt` e `ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set`.
Si legge l'ultima riga verde: `ESITO: FATTO` (o `FATTO (gia presente)` al secondo lancio).

### ⑦.1 Le serrature, e i contro-esempi ESEGUITI (pwsh 7 su albero finto con un'esca del REALE)
| # | caso | esito | file scritti nel terminale |
|---|---|---|---|
| **A** | albero giusto (cartella `46C9…`, `origin.txt = C:\FTMO`, giornale col `541452707`) | 🟢 `ESITO: FATTO`, file riletto dal disco con lo SHA giusto, zip con i 2 file attesi | **1** |
| **B** | secondo lancio di fila | 🟢 `GIA IDENTICO`, nessuna scrittura | invariati |
| **C** | nel terminale c'è già un file con quel nome **ma diverso** (ritoccato a mano) | 🟢 **non sovrascritto**, copia del vecchio nello zip, `FERMATO` | invariati |
| **D** | `origin.txt` dice **`C:\BCM_Reale`** | 🟢 `VIETATO`, `FERMATO` | **0** |
| **E** | giornale **senza** il conto `541452707` (c'è `5414527070`) | 🟢 rifiuta | **0** |
| **F** | manca `MQL5\Presets` | 🟢 rifiuta, **non la crea** | **0** |
| **G** | incollata sul PC di backtest (`DESKTOP-H4D7CAJ`) | 🟢 muore **prima** di scaricare o creare qualunque cosa | **0**, niente sul Desktop |
| **H** | SHA atteso alterato (mutante della riga) | 🟢 `IMPRONTA DIVERSA`, rifiuta | **0** |
| **I** | marcatore atteso alterato (mutante) | 🟢 `FILE VECCHIO`, rifiuta | **0** |

🟢 In **tutti** i casi la cartella dati **esca del REALE** (hash `E23E1504…`, col conto FTMO nel giornale
apposta) ha avuto **zero** file scritti. Il download vero dal pin `3d23327e` è stato provato: **HTTP 200**,
SHA256 identico al file del repo.
⚠️ **Limite dichiarato**: il banco è **pwsh 7 su Linux**, il VPS ha **Windows PowerShell 5.1**. La riga non
usa costrutti solo-pwsh-7 (il cancello lo verifica), ma **non è stata eseguita su 5.1**.

### ⑦.2 Il cancello deterministico
`controlla_riga.py --oggetto riga`: **nessun difetto meccanico**, 6 verdi (ASCII, pin commit vero, marcatore
presente **al pin** nel file giusto, macchina inchiodata, raccolta). **Un rilievo, 671**, letto a mano: il
testo nomina `C:\MT5_Backtest` **nella lista dei NON toccati**, non come bersaglio. 🔴 **E una cosa che il
cancello NON può certificare, detta chiara**: la sua tabella dei bersagli conosce per il VPS solo il banco;
**la cartella in cui questa riga scrive (FTMO) non passa da un flag `-Terminal`**, quindi il bersaglio vero lo
giudicano le serrature della riga (§⑦.1) e lo **strato 2**.

---

## ⑧ ✋ I GESTI A MANO — sul terminale 🪟 FTMO `541452707` (`C:\FTMO`), e SOLO lì

### Passo 0 — riconoscere la finestra (sola lettura, classe 174)
🖥️ **Finestra PowerShell sul VPS.** Non tocca niente: stampa PID, titolo e cartella di ogni MT5 aperto.
```powershell
$p = @(Get-Process terminal64 -ErrorAction SilentlyContinue); "processi terminal64 vivi: " + $p.Count; $p | Select-Object Id, MainWindowTitle, @{n='Path';e={ if($_.Path){ $_.Path } else { 'NON LEGGIBILE (processo di altro utente o elevato)' } }} | Format-List
```
Il terminale giusto è il blocco con **`541452707`** nel titolo e **Path che comincia con `C:\FTMO`**. Se non
c'è un blocco così, **ci si ferma** e mi si manda l'output.

### ⏰ QUANDO attaccarla — fuori dalla sessione
🔴 **Non fra le 10:00 e le 19:30 server FTMO (09:00-18:30 italiane).** Letto nel codice: se l'EA parte a
sessione iniziata, arma **subito** sul range del giorno e, se il prezzo è già oltre il livello, piazza il SELL
LIMIT **adesso**, cioè un ingresso **che il backtest non ha misurato**. Stasera (venerdì) o nel weekend, o
lunedì **prima delle 09:00 italiane**, va bene.

### I passi
| # | gesto | ✅ come si vede che è andata |
|---|---|---|
| **1** | ▶️ la riga del §⑦ (PowerShell sul VPS) | ultima riga `ESITO: FATTO` |
| **2** | nel terminale FTMO: **File → Nuovo grafico → `GER40.cash`**, poi timeframe **M5** | un grafico **in più**; quello della `770101` resta com'è |
| **3** | dal **Navigatore → Expert Advisors**, trascinare **`CLAU12_DAX_Apertura_EU`** sul grafico **nuovo** | si apre la finestra delle proprietà dell'EA |
| **4** | scheda **Input → Carica** → `ABTG_DAX_Apertura_EU_770105_SHORT_FTMO.set` | nella lista: **`InpMagic` = 770105**, **`InpAllowLong` = false**, **`InpAllowShort` = true**, **`InpRiskPercent` = 2.0**, `InpSessionHour` = 10, `InpCloseHour` = 19 |
| **5** | scheda **Comune**: spunta **"Consenti trading algoritmico"** → **OK** | — |
| **6** | guardare il pulsante **Algo Trading** in alto: dev'essere **già verde** (acceso per le altre sedie). 🔴 **Non premerlo**: se lo premi lo spegni per **tutte** | resta verde |
| **7** | la **faccina** in alto a destra del grafico nuovo | 🙂 (se è un cappello grigio/triste, il trading algoritmico non è permesso: rifare il passo 5) |

### ✅ Verifica: tutte e due vive, senza aprire file di log
- **Sul grafico**: due grafici `GER40.cash` **M5**, ciascuno con `CLAU12_DAX_Apertura_EU` e la **faccina** 🙂.
  L'EA **non scrive niente sul grafico** (nessun `Comment()` nel codice): quello che si vede è nome e faccina.
- **Qual è quale, con certezza**: tasto destro sul grafico → **Expert Advisors → Proprietà** → scheda **Input**:
  `InpMagic` **770101** su uno, **770105** sull'altro. È l'unico posto dove il magic si legge.
- **Scheda Esperti** (in basso nel terminale, non un file): subito dopo l'attacco compaiono due righe
  `[DAX Apertura EU]`; la seconda deve dire **`lati=SOLO SHORT`** e **`rischio=2.00%`**:
  `[DAX Apertura EU] avviato su GER40.cash. Apertura server 10:00, range 35 min, flat 19:30.`
  `[DAX Apertura EU] CONFIG IN USO -> motore=ABTG_RETEST | ... | lati=SOLO SHORT | rischio=2.00% | ...`
  ⚠️ Anche la `770101` scrive righe `[DAX Apertura EU]`: la sua dice `lati=SOLO LONG`. Se leggi
  `long+short` o `SOLO LONG` sul grafico **nuovo**, il preset non è stato caricato: rifare il passo 4.
- ⚠️ L'ora delle righe della scheda Esperti è **ora del PC del VPS (italiana)**, non ora server.
- **Nello Storico, quando opererà**: commento **`DAX Apertura EU RETEST SELL`**.

### ↩️ Rollback
1. Tasto destro sul grafico **nuovo** → **Expert Advisors → Rimuovi** (oppure chiudere il grafico nuovo).
   **Non** toccare il grafico della `770101`.
2. 🔴 Togliere l'EA **non cancella** ordini e posizioni già sul server: un SELL LIMIT pendente ha **SL, TP e
   scadenza di 120 minuti** e scade da solo; una posizione aperta resta con **SL e TP sul server** ma **senza**
   parziale, trailing e chiusura delle 19:30. Il rollback si fa **quando la `770105` non ha niente di vivo**
   (Terminale → schede Operazioni: nessuna riga col commento `RETEST SELL`); se c'è, cosa farne è una
   decisione di Claudio.
3. Il file `.set` nella cartella Presets può restare: senza EA sul grafico non fa niente.

---

## ⑨ ⚪ COSA RESTA APERTO — dichiarato, non nascosto

1. 🔴 **Il contratto è BOCCIATO PER RISCHIO in R251** e al 2% il DD limite superiore è ~25% contro un muro del
   10%: è scritto in testa al preset e al §⑥. La sedia è in campo per **firma**, non per promozione.
2. 🔴 **Le sospensioni delle sedie indice sugli altri conti (24 e 25/09) vanno viste ESEGUITE** prima di
   accendere la `770105` (§④.2): con la short su FTMO, un long indice altrove è hedging fra conti.
3. 🔴 **Monte Carlo e DD della coppia in due istanze: `[NON MISURATI]`** (§⑤). Il MC di oggi è senza la
   `770105`.
4. 🟠 **R252** può spostare il contratto (orologio in fase): quando esce, questa tabella va riletta.
5. 🟠 **Tre sedie su `GER40.cash`** e la voce FTMO sull'esposizione cumulata (§④.3): fatto da sapere.
6. 🟠 **Strumenti di analisi che non conoscono `770105`**: `backtest_pipeline/hedging_demo_correlati.py`
   (r.87, insieme `FTMO_PROXY`) e `backtest_pipeline/mc_challenge_ftmo_stato.py` (r.215-222, sedie DAX).
   Finché non si aggiungono, **quei due strumenti non vedono la sedia nuova**. Non li ho toccati.
7. ⚪ **La foto del grafico vivo della `770101` è del 24/09 08:06**: una modifica a mano non salvata dopo
   quell'ora non la vedrei.
8. ⚪ **Cambio dell'ora del 25/10** (DST europeo): vale per la `770105` esattamente come per la `770101`
   (nota nell'intestazione copiata del preset).
9. ⚪ **Nessuna compilazione serve e nessuna è stata provata**: si usa il binario `CLAU12_DAX_Apertura_EU` già
   in campo.

---

## ⑩ 📎 FONTI
`report/FIRME_2026-09-25.md` (la firma) · `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set` (l'origine) ·
`backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260925_033004.log` r.3054-3140 (la `770101` viva) ·
`CODA_06_quale_codice_gira_20260925_033004.log` r.183, r.209 (il binario in campo) ·
`CODA_01_sedie_attaccate_20260925_033004.log` r.56-68 (le nove sedie FTMO) ·
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` al pin `9fca63d9` (= `CLAU12_…`) ·
`mql5/Include/ABTG_PausaGuardian.mqh` al pin `26a18566` (v1.20) · `ABTG_Guardian.mq5` al pin `d884f7e1` (v1.12) ·
`report/RINOMINA_CLAU12_2026-09-20.md` · `report/SCHIERAMENTO_FTMO_2026-09-20.md` §5.2 ·
`report/REFERTO_R251_2026-09-25.md` · `report/LATO_SHORT_DAX_APERTURA_2026-09-25.md` ·
`report/TERZO_STOP_FTMO_2026-09-25.md` · `report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md` ·
`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md` · `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` ·
`docs/REGOLAMENTO_FTMO_2026-08.md` r.91, r.94 · `docs/REGOLAMENTO_FTMO_2026-09-20.md` §④ ·
`report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` · `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` classi 174,
547, 645, 671, 755, 783, 791, 792, 796.
