# 🚀 SCHIERAMENTO FTMO — la serata di **domenica 20/09/2026**, gesto per gesto

**Scritto il 19/09/2026 notte** · branch `lavoro` · agente **controllo-preventivo**
🚫 **Nessun EA toccato, nessun preset modificato, nessuna taglia scelta, nessun round lanciato.**
🚫 Conto reale **10105439**: non nominato se non per **rifiutarlo**.

> ## 🎯 A COSA SERVE QUESTO FILE
> È il **§Ⓐ del pacchetto** (`report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md`) portato al
> livello del gesto: **cosa si preme, in che ordine, come si vede che è andata, quanto costa**.
> Il pacchetto dice *perché*. Questo dice *come*, e **con l'orologio in mano**.

---

## ⓪ 🖥️ IL BERSAGLIO DELLA RIGA — si dice prima del codice, sempre

> # 🖥️ **finestra PowerShell sul VPS**
> La riga **legge** le sette cartelle dati per **escluderle**, e **scrive in UNA SOLA**: quella
> del terminale **FTMO**, che identifica da sola.
>
> 🚫 **Cosa NON viene toccato, per nome:**
> `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`) · `50504263` (`… -V3`) ·
> 🔴 **`10105439` (`C:\BCM_Reale`)** · `50504400` (`C:\MT5_Backtest`) ·
> `50503635` (`C:\MT5_MANUALE`) · Pepperstone · Tickmill.
>
> ✋ **Nessun MT5 va aperto o chiuso per questa riga.** Il terminale FTMO può restare aperto:
> lo script scrive **solo** in `MQL5\Experts`, `MQL5\Include`, `MQL5\Presets` — mai un `.chr`,
> mai un profilo, mai un `config`. Sono quelli che MT5 riscrive alla chiusura; i `.mq5` e i
> `.set` no.

---

## ① ⏱️ LA CATENA COMPLETA — **95-145 minuti**, e dove sono i minuti

| # | cosa | 🖥️ dove | chi | ⏱️ stima | 🔴 rischio |
|---|---|---|---|---:|---|
| **1** | 💰 comprare la challenge, ricevere credenziali | browser | ✍️ Claudio | **5-20 min** | dipende da FTMO |
| **2** | ⬇️ installare l'MT5 FTMO in **`C:\MT5_FTMO`** — 🔴 **non** dentro una cartella BCM | 🖥️ VPS | ✍️ Claudio | **10-20 min** | — |
| **3** | 🔑 login + attesa sincronizzazione simboli | 🪟 **FTMO** | ✍️ Claudio | **2-5 min** | 🔴 **senza login il giornale è vuoto e il passo 5 rifiuta** |
| **4** | 📸 **le due letture che valgono la notte**: orologio Market Watch vs orologio Windows; *Specification* di US30/GER40/NAS100 | 🪟 **FTMO** | ✍️ Claudio | **5 min** | trasforma il `+2` da `[INFERITO]` a misurato |
| **5** | ▶️ **LA RIGA** (§②) — copia 9 sorgenti + 9 preset | 🖥️ **PowerShell sul VPS** | 🤖 | ⏱️ **~3 s** *(misurato: 2,4 s · tetto 120 s)* | rifiuta invece di indovinare |
| **6** | 🔨 **F7 in MetaEditor**, 🔴 **`ABTG_Guardian.mq5` per PRIMO** | 🪟 **FTMO** | ✍️ Claudio | **10-20 min** | 🔴 **senza tetto se uno fallisce** |
| **7** | 📊 aprire i grafici, simbolo + TF giusti | 🪟 **FTMO** | ✍️ Claudio | **10 min** | — |
| **8** | ⚙️ caricare i preset + 🔴 **rimappare gli orari (+2h)** + la **taglia** | 🪟 **FTMO** | ✍️ Claudio | 🔴 **20-30 min** | 🔴 **il passo più lungo e il più facile da sbagliare** |
| **9** | 🛡️ attaccare `ABTG_Guardian` col preset FTMO | 🪟 **FTMO** | ✍️ Claudio | **5 min** | — |
| **10** | ▶️ **AutoTrading ON** + faccine sui grafici | 🪟 **FTMO** | ✍️ Claudio | **5 min** | vedi §④ l'ordine di accensione |
| | | | **TOTALE** | 🔴 **~72-120 min** | **più** il tempo d'acquisto |

> ## 🟢 **CI STA IN UNA SERA. E se non ci sta, non si perde niente.**
> Misurato su 96 posizioni vere in `data/statements/trades_auto.csv`: **nessuna sedia della rosa
> ha mai aperto di domenica. Zero volte.** La prima operazione che conta è **lunedì alle 07:00-08:00**.
> 👉 **La notte è un cuscinetto, non una scadenza.**
> ⚠️ Con **una** eccezione, ed è al §④.

🟢 **Cosa cambia rispetto al pacchetto**: il passo 6 del pacchetto era *«copiare 6 `.mq5` +
include a mano con Esplora Risorse, 5-10 min»*. Adesso è **3 secondi** e — più importante —
**verificato**: ogni file viene riletto dal disco e confrontato con l'impronta attesa. Il buco
**B7** («il conteggio righe atteso non è scritto da nessuna parte») è **chiuso**: sta dentro lo
script, riga per riga, e viene stampato.

---

## ② ▶️ LA RIGA

> # 🖥️ **BERSAGLIO: finestra PowerShell sul VPS.** Nessun MT5 da aprire o chiudere.
> 🔑 **`-ContoAtteso` è il numero del conto FTMO che ti è arrivato per mail.** Sostituiscilo.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    $pin='25fd32d7ea540f6284ca1b43bc951dec36c130a7'; $conto='IL_TUO_CONTO_FTMO'; $p="$env:USERPROFILE\SCHIERA_FTMO.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/SCHIERA_FTMO.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_SCHIERA_FTMO_v1' -Quiet)){ throw 'SCRIPT VECCHIO: manca il marcatore MARCATORE_SCHIERA_FTMO_v1.' };
    $global:LASTEXITCODE = 0; & $p -ContoAtteso $conto -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host ('FERMATO (uscita ' + $LASTEXITCODE + '): NON premere F7. Manda tutto l output qui sopra.') -ForegroundColor Red }
    else { Write-Host 'FATTO (uscita 0). Sul Desktop trovi la cartella SCHIERA_FTMO_<data> e lo zip: dentro ci sono il referto e i file scaricati.' -ForegroundColor Green } }
```

🕐 **Dura ~3 secondi** (misurato 2,4 s su nove sorgenti e nove preset). Oltre **120 s** è la rete.

### 🔎 Se vuoi guardare prima di scrivere
Stessa riga con **`-SoloDiagnosi`** in coda: fa la scoperta, dice che cosa **copierebbe**, e
**non scrive niente**, nemmeno una cartella.

---

## ③ 🔐 COME FA A TROVARE UN TERMINALE CHE OGGI NON ESISTE — le quattro serrature

Nessun percorso è cablato. La cartella dati si **scopre**, e la scoperta può finire in **tre**
modi: una candidata (si lavora), **zero** (rifiuta), **più di una** (rifiuta). Su un conto che
costa soldi veri **non si indovina**.

| # | serratura | come fallisce |
|---|---|---|
| **1** | la cartella non deve essere una delle **sette censite** — confronto per **hash** della cartella dati | `ESCLUSA <hash> = 10105439 *** REALE ***` |
| **2** | il suo `origin.txt` non deve contenere `BCM` · `Pepperstone` · `Tickmill` · `MT5_Backtest` · `MT5_MANUALE` | `ESCLUSA … contiene "BCM": e una cartella di casa` |
| **3** | il **GIORNALE** (`<dati>\logs`, **non** `MQL5\Logs`) deve contenere il numero di `-ContoAtteso` | `conto 1520371: non trovato -> scartata` |
| **4** | giornale o `origin.txt` devono **nominare FTMO** | `FTMO: non nominato -> scartata` |

➕ **E una serratura prima di tutte**: `-ContoAtteso` viene **rifiutato in partenza** se è uno
dei cinque conti di casa (`50503392` `50504263` `10105439` `50504400` `50503635`). È la stessa
idea di `InpLoginAtteso` sul reale.
➕ **E una dopo**: il percorso di destinazione **vero**, quello su cui si scriverà, ripassa dalla
lista nera. Se un giorno la scoperta cambiasse, morirebbe lì.

### 🧪 I CONTRO-ESEMPI — **eseguiti**, non raccontati
Banco: un finto `%APPDATA%\MetaQuotes\Terminal` con le **sette** cartelle di casa ricostruite
(hash veri, `origin.txt` veri, giornali finti) più le candidate del caso.

| # | caso | esito | file finiti nel terminale |
|---|---|---|---|
| **A** | **zero candidate** (solo le sette di casa) | 🟢 rifiuta, uscita **1**, elenca tutte e sette con l'etichetta | **0** |
| **B** | **due candidate** confermate, stesso conto | 🟢 rifiuta, uscita **1**, stampa tutte e due | **0** |
| **C** | 🔴 **la candidata È IL REALE**: hash **nuovo**, giornale con `1520371` e `FTMO-Demo2`, ma `origin.txt = C:\BCM_Reale` | 🟢 **rifiutata dalla serratura 2** prima ancora di leggere il giornale | **0** |
| **D1** | `-ContoAtteso` che **non compare** nel giornale | 🟢 rifiuta e spiega le tre cause possibili | **0** |
| **D2** | `-ContoAtteso = 10105439` (il **reale**) | 🟢 rifiuta **prima di guardare il disco** | **0** |
| **D3** | cartella **senza `origin.txt`** | 🟢 esclusa: *«non posso CERTIFICARE di chi è»* | **0** |
| **D4** | `-Pin lavoro` (un **ramo**, non uno SHA) | 🟢 rifiuta: *«un ramo si muove, un commit no»* | **0** |
| **E** | 🟢 **terminale vergine**: `MQL5\Include` e `MQL5\Presets` **assenti** | 🟢 le crea, copia 9 sorgenti + 9 preset, **2,4 s**, uscita **0** | 18 |
| **G** | **secondo lancio di fila** | 🟢 `GIA GIUSTO` ×9 e `GIA IDENTICO` ×9: **nessun download, nessuna scrittura** | invariati |
| **H** | 🔴 **Claudio rimappa a mano `InpSessionHour=8 → 10`, poi rilancia la riga** | 🟢 **NON sovrascritto**: la modifica a mano sopravvive, la versione del repo finisce accanto come `…_DAL_REPO.set` | invariati |
| **F1** | `-Pin` a un commit **vecchio**: un preset obbligatorio non esiste lì | 🟢 rifiuta col **404 e l'URL in chiaro** | **0** |
| **F2** | un **EA mancante** al suo pin (mutante dello script) | 🟢 rifiuta col 404 | **0** |
| **I** | un preset che **non porta il suo `InpMagic`** (preset della sedia sbagliata) | 🟢 rifiuta: *«caricarlo sul grafico sbagliato è come si perde una serata»* | **0** |

> ## 🎯 **In tutti e nove i rifiuti: ZERO file nella cartella del terminale.** È una proprietà del disegno, non una fortuna: **scarica e verifica TUTTO prima di copiare QUALUNQUE cosa.**

---

## ④ 📋 L'ORDINE DI ACCENSIONE — da spuntare, e come si verifica ogni passo

| # | gesto | 🖥️ dove | ✅ come si vede che è andata | ⏱️ |
|---|---|---|---|---:|
| **1** | login FTMO | 🪟 **FTMO** | i prezzi di Market Watch **si muovono** (domenica sera dopo l'apertura) | 2-5 min |
| **2** | 📸 orologio Market Watch **contro** orologio di Windows | 🪟 **FTMO** | 🔴 **è la misura che trasforma il `+2` da ipotesi a fatto.** Se il Market Watch è **avanti di 2** su Windows: confermato | 2 min |
| **3** | ▶️ **la riga** (§②) | 🖥️ **PowerShell VPS** | uscita **0** e la tabella `C E, ED E QUELLO GIUSTO` su **tutte** le righe | ~3 s |
| **4** | 🔨 **F7 su `ABTG_Guardian.mq5` — PER PRIMO** | 🪟 MetaEditor **FTMO** | `0 errors, 0 warnings`. 🔴 **Se muore su `cannot open include file`, si ferma tutto e mi si manda l'errore**: è l'unico modo in cui l'include può essere sbagliato, e si scopre al **primo** colpo invece che al nono | 3 min |
| **5** | 🔨 F7 sugli altri 7 `.mq5` | 🪟 MetaEditor **FTMO** | `0 errors` ciascuno | 10-20 min |
| **6** | 📊 grafici: `D30EUR` M5 · `D30EUR` M15 · `U30USD` M5 · `U30USD` H1 ×2 · `NASUSD` M5 | 🪟 **FTMO** | i nomi dei simboli FTMO **possono essere diversi** (`GER40`, `US30`, `NAS100`): 🔴 **si usa quello che c'è in Market Watch** | 10 min |
| **7** | ⚙️ preset + 🔴 **rimappatura +2** | 🪟 **FTMO** | 🟢 **la riga ti ha già stampato la tabella**: `InpSessionHour BCM 8 -> FTMO 10`, valore per valore, preset per preset. **Si copia da lì, non a memoria** | 20-30 min |
| **8** | 💰 **la taglia** | 🪟 **FTMO** | 🔴 **`InpRiskPercent` è una firma di CLAUDIO**, non è scritta da nessuna parte in questo pacchetto | — |
| **9** | 🛡️ Guardian con `ABTG_Guardian_FTMO_2Step.set` e 🔴 **`InpDailyResetHour=1`** (la riga te lo stampa: `BCM 23 -> FTMO 1`) | 🪟 **FTMO** | il pannello del Guardian compare sul grafico | 5 min |
| **10** | ▶️ **AutoTrading ON** | 🪟 **FTMO** | faccina 😊 su ogni grafico | 5 min |

### 🪤 L'AVVISO SULL'ORDINE DI ACCENSIONE — **`770511` SuperWave e la riapertura di domenica**

> ## 🔴 **`770511` è l'unica sedia della rosa senza NESSUNA guardia oraria attiva.**
> **Verificato nel preset vivo**: `InpUseTimeWindow=false`, `InpStartHour=0`, `InpEndHour=24`.
> La finestra oraria è **inerte**: non è che *abbiamo deciso* di lasciarla libera — **nessuno l'ha
> mai accesa**. L'EA può entrare **a qualunque ora, qualunque giorno**, riapertura domenicale
> compresa. 🔴 **E lo ha già fatto**: 31/08 alle 06:00 (×2), 07/09 alle 05:00 (×2).
>
> ⚖️ Il **«gap trading»** sta fra le **Forbidden Trading Practices** FTMO e vale **sempre, anche
> in Challenge** (`docs/REGOLAMENTO_FTMO_2026-08.md` r.83) — a differenza delle regole sulle news,
> che in valutazione non si applicano.
>
> 👉 **Raccomandazione (è una raccomandazione, la firma è di Claudio): accendere `770511` PER
> ULTIMA, lunedì mattina, non domenica sera.**
> 💸 **Il costo, detto onesto**: SuperWave fa ~10,8 operazioni al mese e **metà cadono di lunedì**.
> Spegnerla una notte **può costare un'operazione**. Non è gratis.
>
> 🚫 **E NON si tocca `InpUseTimeWindow`**: cambiare quel parametro è una **modifica di
> comportamento su una sedia viva**, e non è una decisione di uno script né mia.

🟡 Su **`771531` EMA200** l'avviso **non** si applica allo stesso modo: può aprire all'alba
(lo ha fatto il 17/08 alle 01:21 e 02:41) **ma** è l'unica sedia che passa tutti i cancelli alla
lettera (PF OOS **1,52**, n **517**, **30/30 PASS** walk-forward tick). Spegnere la sedia migliore
per un'ambiguità di regolamento è un prezzo alto. 👉 **Si manda la domanda al supporto** (già
scritta, buco B4) e si decide con la risposta in mano.

---

## ⑤ 📦 COSA INSTALLA, E CON QUALE PIN — la tabella completa

### 5.1 I sorgenti (`MQL5\Experts`) — impronta **congelata**

| file | sedia | pin | righe attese *(CODA_06)* |
|---|---|---|---:|
| `ABTG_DAX_Apertura_EU.mq5` | `770101` DAX Apertura · `D30EUR` M5 | `9fca63d9` | **2425** *(2426)* |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` | `770411` MaxMin DAX Short · `D30EUR` M15 | `5fc0bc31` | **619** *(620)* |
| `ABTG_Dow_Apertura_US.mq5` | `770202` Dow Apertura · `U30USD` M5 | `9fca63d9` | **2205** *(2206)* |
| `ABTG_EMA200.mq5` | `771531` EMA200 Dow · `U30USD` H1 | 🔴 **`26a18566`** *(non HEAD)* | **552** *(553)* |
| `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | `770511` SuperWave · `U30USD` H1 | 🔴 **`872dba82`** *(non HEAD)* | **645** *(646)* |
| `ABTG_Nasdaq_Apertura_US.mq5` | `770260` Nasdaq RETEST · `NASUSD` M5 | `9fca63d9` | **2624** *(2625)* |
| `ABTG_Guardian.mq5` | `779001` Guardian **v1.12** | 🔴 **`d884f7e1`** *(non HEAD)* | **498** *(499)* |
| `ABTG_PostNews.mq5` | `771202`/`771203`/`771204` | `61dc18c9` | **666** *(667)* |
| `ABTG_PausaGuardian.mqh` → `MQL5\Include` | 🔴 **senza di lui NESSUN F7 parte** (classe 27) | `26a18566` — **v1.20** | **398** *(399)* |

📌 I numeri di `EMA200` (552) e `SuperWave` (645) e dell'include (398) **coincidono al bit** con
quelli già approvati in `backtest_pipeline/righe/COMPILA_771531_770511.ps1`. È il contro-esempio
che valida il **righello**: se la mia funzione d'impronta fosse diversa dalla sua, quei tre numeri
non tornerebbero.

### 5.2 I preset (`MQL5\Presets`) — pin + controllo **nel merito**

Sei obbligatori (`770101` `770411` `770202` `771531` `770511` `779001`), quattro opzionali
(`770260` + i tre PostNews). Ognuno deve contenere **il proprio `InpMagic=`**, altrimenti la riga
rifiuta tutto.

🔴 **Perché i preset NON hanno l'impronta congelata e gli EA sì** — e non è una svista:
un `.mq5` è il sorgente da cui nasce il binario su cui sono stati **misurati PF, DD e frequenza**:
se cambia di una riga, **il contratto non è più quello**. I `.set` invece sono **ancora in
lavorazione stanotte** da altre sessioni: congelarne l'impronta farebbe fallire la riga domani per
un motivo che **non è un difetto**. Quindi i preset si prendono **dal `-Pin`** (immutabile per
costruzione) e si controllano nel **merito**. L'impronta viene stampata e finisce nel referto.

---

## ⑥ 🔴 LE TRE DECISIONI CHE HO DOVUTO PRENDERE — e la misura che c'è dietro

### 6.1 🛡️ **Il Guardian va a `d884f7e1` (v1.12), NON a HEAD. E il pacchetto, su questo, portava a un F7 morto.**

**Il fatto, misurato simbolo per simbolo:** il §④ passo 7 del pacchetto prescrive l'include alla
**v1.20 (398 righe)**. Ma `ABTG_Guardian.mq5` **a HEAD (v1.14)** chiama tre funzioni che in v1.20
**non esistono**:
```
ABTG_ClusterParse_Calc · ABTG_ClusterGVRadice · ABTG_SimboloNelCluster_Calc
```
👉 **Guardian a HEAD + include v1.20 = F7 che muore.** E siccome l'include è **uno solo** per
tutto il terminale, non è un problema che si aggira: è una scelta che va fatta.

**Le alternative, tutte e tre misurate:**

| Guardian | include | esito | costo |
|---|---|---|---|
| **HEAD v1.14** (19 input) | **v1.20** (398) | 🔴 **F7 MUORE** | — |
| **HEAD v1.14** (19 input) | **HEAD** (2461) | 🟠 compila | 🔴 l'include a HEAD sta sul commit **«LAVORO IN CORSO — tetto cluster C2 collegato»**: è **esattamente** il tipo di commit che `COMPILA_771531_770511` si era già rifiutata di spedire |
| 🟢 **v1.12 `d884f7e1`** (16 input) | **v1.20** (398) | 🟢 **compila** | si perde il tetto per **cluster (C2)** |
| v1.10 `a53820e6` (15 input, quello **in campo**) | v1.20 | 🟢 compila | 🔴 **manca il fix critico del 06/09** |

**Perché v1.12 e non v1.10**, che pure è quello vivo e già compilato:
> `d884f7e1` = *«Fix critico: Guardian catturava la baseline dal bilancio, non dall'equità»*.
> 🔴 **Su FTMO la perdita giornaliera è esattamente quel numero.** Schierare il v1.10 vorrebbe
> dire mettere sul conto della challenge un Guardian con un difetto **noto** proprio nel calcolo
> che FTMO usa per bocciarti.

**Cosa si perde, e perché va bene:** il tetto per **cluster (C2)**. 🟢 CLAUDE.md lo dichiara **non
necessario adesso** e lo prova in **quattro modi** (algebrico, aritmetico, strutturale, empirico):
il cluster `AZIONARIO` proposto al **3,5%** è **più largo del C1 al 3,25% già acceso**.
🟢 **Il C1 al 3,25%, che è la firma viva, c'è ed è nel preset.**

✅ **Verificato nome per nome**: tutti e **15** gli input di `ABTG_Guardian_FTMO_2Step.set`
esistono nel v1.12. Il sedicesimo input del v1.12, `InpAutotest`, ha default `false`: **no-op**.

### 6.2 🥇 **`770402` MaxMin ORO NON si schiera domenica — ed è un'omissione DICHIARATA**

Il pacchetto dice *«copiare **sei** `.mq5`»* e la rosa è di **sette** sedie: il settimo EA
(`ABTG_MaxMinNotte.mq5`) **manca dal conteggio**, e manca anche dalla lista righe del buco **B7**.
Non è un errore del pacchetto — `770402` è marcata **«SERVE MISURA»** — ma **un'omissione
silenziosa la sera dello schieramento è il modo in cui una sedia sparisce senza che nessuno se ne
accorga**. 👉 Quindi la riga la **stampa** come **SEDIA SOSPESA**, col motivo per esteso:

> il binario in campo (`08239510`, 28/07) ha il **breakeven annegato nel parziale a 0,01 lotti**
> = rischio attivo; il bersaglio HEAD (`7d0da9f9`) **rende effettivo `InpOneTradePerDay`** e quindi
> **cambia la frequenza con cui il contratto è stato misurato**. 🔴 **Serve una corsa di controllo
> e una firma di Claudio.** Finché non ci sono, non si sceglie.

🪑 **Quindi la rosa di domenica è di SEI sedie + Guardian** (+ le tre PostNews, se i preset
arrivano), non sette. **Va detto a Claudio prima, non dopo.**

### 6.3 ✍️ **Un preset modificato a mano NON viene mai sovrascritto** — regola opposta a quella dei `.mq5`

Un `.mq5` diverso = **binario sbagliato** = va sostituito.
Un `.set` diverso = quasi sempre **una mano umana** (Claudio che ha rimappato gli orari +2 e ha
premuto Salva dentro MT5), e **quella non si tocca**. Al secondo lancio della riga il lavoro fatto
a mano **deve sopravvivere** — contro-esempio **H**, eseguito. La versione del repo viene messa
**accanto** come `…_DAL_REPO.set`, così si può confrontare senza perdere niente.

---

## ⑦ ⚪ COSA NON È COPERTO — dichiarato, non nascosto

1. 🔴 **Nessun F7 è stato provato.** Che i nove sorgenti compilino sul terminale FTMO è
   **[NON VERIFICATO]**: qui non c'è MetaEditor. Ho verificato la cosa che si può verificare —
   che **ogni funzione `ABTG_` chiamata dai nove EA esista nell'include che installo**, nome per
   nome. È il difetto che uccide l'F7 più spesso (classe 27), ma **non è una prova di compilazione**.
2. 🔴 **Il `.set` di `770260` non esiste in repo** (buco **B6**): `grep -rln "770260" --include=*.set`
   = **0 file**, riverificato stanotte. La riga lo cerca al pin: se un'altra sessione lo committa
   prima, lo trova da solo; se no, **stampa che quella sedia non si accende** e va avanti.
3. ⚪ **I tre preset PostNews sono in lavorazione** da un'altra sessione: li prendo dal `-Pin` e
   controllo solo che portino il loro `InpMagic`. **Il merito di quei tre preset non l'ho
   giudicato io.**
4. ⚪ **Il `+2` degli orari è `[INFERITO]`** (`docs/REGOLAMENTO_FTMO_2026-08.md` r.130,
   etichetta *[LETTO-VIA-SEARCH, 13/08]*). La riga lo **stampa come proposta**, non lo scrive.
   Si chiude in 10 secondi col passo 2 del §④.
5. ⚪ **I nomi dei simboli FTMO non li conosco.** Se su FTMO l'indice tedesco si chiama `GER40`
   e non `D30EUR`, i preset vanno caricati sul grafico giusto **a occhio del simbolo**, e nessuno
   script può saperlo prima.
6. ⚪ **Il banco di prova è Linux, non Windows.** Il parser è quello vero
   (`Parser::ParseFile`, 0 errori) e il cancello dichiara *«nessun costrutto pwsh-7-only»*,
   ma **il VPS ha PowerShell 5.1 e io ho girato i contro-esempi su pwsh 7.4.6**.
7. ⚪ **`InpRiskPercent` (la taglia) non è toccata da niente di tutto questo.** È una firma di
   Claudio e resta **[NON DECISA]**.

---

## ⑦bis 🔴 **UNA COSA SUCCEDE ADESSO IN UN'ALTRA SESSIONE, E CAMBIA LA SERATA**

Mentre scrivevo, nell'albero di lavoro sono comparsi (ancora **NON committati**, quindi **non
pinnabili** e non toccati da me):
- `mql5/Presets/FTMO/` — **dieci preset GIÀ RIMAPPATI** a FTMO (`…_770101_FTMO.set` ecc.);
- `mql5/Presets/ABTG_Nasdaq_Apertura_US_RETEST_770260.set` — 🎉 **il buco B6 che si chiude**;
- `backtest_pipeline/rimappa_preset_ftmo.py` + `report/PRESET_FTMO_OROLOGIO_2026-09-20.md`.

> ## 🟢 **PRIMA LA BELLA NOTIZIA, ED È UN CONTRO-ESEMPIO CHE NON MI SONO COSTRUITO IO.**
> `ABTG_DAX_Apertura_EU_770101_FTMO.set` porta `InpSessionHour=10` e `InpCloseHour=19`.
> La mia riga, partendo dal preset BCM, stampa `InpSessionHour BCM 8 -> FTMO 10` e
> `InpCloseHour BCM 17 -> FTMO 19`. 👉 **Due strade indipendenti, stesso numero.** L'aritmetica
> del `+2` non è più solo mia.

🔴 **MA LA CONSEGUENZA OPERATIVA È GROSSA, e va decisa prima di domenica:** se quei preset
vengono **committati**, la tabella del §5.2 va ripuntata su `mql5/Presets/FTMO/*` e il **passo 8**
del §④ — 🔴 *la rimappatura a mano, 20-30 minuti, il passo più lungo e il più facile da sbagliare*
— **sparisce dalla serata**. Restano il caricamento del preset e la taglia.

⏱️ **Costo della modifica: ~10 minuti** (dieci righe di manifesto + un nuovo pin + i contro-esempi
rigirati). 👉 **Va fatto appena quei file sono su `lavoro`**, e va fatto da chi coordina, non in
autonomia: il merito di quei preset non l'ho giudicato io, e il `770260` arriva con un **nome e un
percorso diversi** da quelli che il mio manifesto cerca oggi.

🟢 **Nel frattempo la riga di oggi è corretta e sicura lo stesso**: i preset FTMO non esistono al
pin `25fd32d7`, quindi copia quelli BCM e **stampa la tabella di rimappatura**. Non sbaglia, fa
solo lavorare Claudio venti minuti in più.

---

## ⑧ 📎 FONTI

`report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` (§Ⓐ cronologia, §④ ordine, §⑥ buchi B6/B7) ·
`report/I_BINARI_DELLA_ROSA_2026-09-19.md` (le sette cartelle dati, i vintage in campo) ·
`report/COMPILAZIONE_771531_770511_2026-09-19.md` (i pin di `771531` e `770511`) ·
`report/collaudi/CENSIMENTO_MT5_VPS_2026-09-12_0846.txt` (hash → terminale, Pepperstone e Tickmill) ·
`docs/REGOLAMENTO_FTMO_2026-08.md` r.83 (gap trading) e r.130 (fuso) ·
`CLAUDE.md` (regola dei terminali multipli · C2 non necessario · niente emoji nei `.ps1`) ·
`backtest_pipeline/righe/SCHIERA_FTMO.ps1` (lo script) ·
`backtest_pipeline/righe/COMPILA_771531_770511.ps1` (il modello).
