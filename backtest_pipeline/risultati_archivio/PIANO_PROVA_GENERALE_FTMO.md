# 🧪 PIANO DELLA PROVA GENERALE — LA FLOTTA SUL FREE TRIAL FTMO
### 27/08/2026 — documento da firmare, non da eseguire

> ## 🛑 COSA QUESTO DOCUMENTO NON FA
> - ❌ **niente commit, niente push** (richiesta esplicita del mandato);
> - ❌ **nessun file `.mq5` / `.mqh` / `.set` toccato**, nessun preset creato;
> - ❌ **nessuna modifica al forward BCM** — il demo 50503392 e il dry-run 100k
>   restano esattamente come sono, con le soglie firmate il 18/08;
> - ❌ **nessuna riga di lancio dettata**: le stringhe di deploy passano dal
>   **verificatore**, come sempre, e nascono **dopo** la firma, non prima;
> - ❌ **non autorizza nessun acquisto**: il trial è **gratuito**, e la regola D3
>   (risposta scritta del supporto prima di ogni euro) resta intatta.
>
> **Si firma scrivendo `FIRMO PROVA GENERALE`**, indicando **quali decisioni**
> (per numero) si accettano e quali si rimandano. **Firma parziale ammessa e
> consigliata**: ogni decisione è indipendente.

---

## 0. 🏷️ ETICHETTE — cosa è misurato e cosa è ragionato

| etichetta | significato |
|---|---|
| 🥇 **[MISURATO]** | letto da me in questo giro, in un artefatto agli atti (sorgente, `.set`, censimento, referto), con la riga citata |
| 🟢 **[OSSERVATO DA CLAUDIO]** | fatto riportato dal mandato di oggi, visto a schermo da Claudio sul terminale FTMO |
| 🟡 **[LETTO-VIA-SEARCH]** | regola della prop letta via ricerca/dossier, **nessuna pagina aperta con i nostri occhi** |
| 🔵 **[INFERITO]** | ragionamento mio ancorato a numeri di casa — **non è una misura** |
| 🔴 **[INCERTO]** | manca il dato, e lo dichiaro invece di riempirlo |

⚠️ **Controllo positivo di questo giro**: gli orari e i magic qui sotto li ho
letti **nei sorgenti `.mq5` e nei `.set`**, non nei referti che li raccontano.
Dove sorgente, `.set` e documentazione **divergono**, lo scrivo (§ 11).

---

## 1. 📸 I FATTI DEL TRIAL — cosa sappiamo oggi, e cosa NON sappiamo

### 1.1 Quello che è stato osservato (27/08)

| voce | valore | etichetta |
|---|---|---|
| capitale | **200.000 USD** | 🟢 [OSSERVATO] |
| tipo conto MT5 | **HEDGE** (hedging, come BCM) | 🟢 [OSSERVATO] |
| server | **FTMO-Demo** | 🟢 [OSSERVATO] |
| broker/entità | **FTMO Global Markets Ltd** | 🟢 [OSSERVATO] |
| terminale | **MT5 dedicato installato sul PC DI BACKTEST** | 🟢 [OSSERVATO] |
| simboli disponibili | **166** (nomi da censire) | 🟢 [OSSERVATO] |
| durata | **14 giorni DALLA PRIMA OPERAZIONE** | 🟢 [OSSERVATO] |
| finestra di attivazione | **entro 7 giorni → entro il 3/09** | 🟢 [OSSERVATO] |
| partenza proposta | **lunedì 31/08**, dopo Jackson Hole | proposta di questo piano |

### 1.2 🔴 Quello che NON sappiamo, ed è la cosa più importante della pagina

> ## ❓ IL TRIAL SIMULA UN CONTO **SWING** O UN CONTO **NORMAL/STANDARD**?
>
> **Non lo sappiamo, e da questa risposta dipende metà del valore della prova.**
> 🔴 **[INCERTO]** — nessun documento agli atti lo dice; il
> `DOSSIER_PROP_CANDIDATE_2026-08-26.md` §0 dichiara che **nessuna pagina FTMO
> è mai stata aperta** (WebFetch `EGRESS_BLOCKED` su tutti i domini).

**Perché morde:** tutta l'aritmetica del **cancello 6**
(`ANALISI_TAGLIA_FASE1_2026-08-27.md` §3) è calcolata sulla **leva Swing**
(1:30 forex · 1:15 indici · 1:9 o 1:15 metalli 🟡). Se il trial è un
**Standard a 1:100**, i margini che misureremo saranno **6-11 volte più
piccoli** di quelli della challenge Swing, e **la prova NON chiuderà il
cancello 6** — misurerà un conto che non compreremo.

**Come si risponde stasera, in due minuti, senza chiedere niente a nessuno:**

| discriminante | strumento | cosa dice |
|---|---|---|
| **`ACCOUNT_LEVERAGE`** | 🥇 `ABTG_SondaMargine.mq5` (riga 55: `AccountInfoInteger(ACCOUNT_LEVERAGE)`) | **100** → Standard · **30** → Swing |
| **`MARGIN_RATE_*` su XAUUSD** | stessa sonda (righe 39-43) | chiude anche la **domanda scritta n.1** al supporto: oro 1:9 o 1:15? |
| **nome del conto nel cruscotto FTMO** | occhi di Claudio | "Swing" compare o no |
| **pagina "Trading Objectives" del cruscotto trial** | occhi di Claudio | 🎯 **e qui c'è il regalo grosso: § 1.3** |

### 1.3 🎁 IL REGALO NASCOSTO DEL TRIAL — la prima fonte FTMO **[VERIFICATO]** della storia del progetto

Ogni riga FTMO agli atti oggi è 🟡 **[LETTO-VIA-SEARCH]**: muri, reset, leva,
fuso, tetti, clausole. **Il cruscotto del trial è una pagina ufficiale che
Claudio può aprire con i propri occhi.** Screenshot di:

1. **Trading Objectives** (muro giornaliero, muro totale, target, giorni minimi);
2. **la natura del muro totale** (statico "90% of initial" o trailing EOD) —
   ⛔ è la condizione di validità del preset Guardian firmato (`InpDDMode=0`);
3. **l'ora del reset giornaliero** dichiarata da loro;
4. **il tipo di conto** (Swing / Normal) e la **leva**;
5. **le Forbidden Trading Practices** come le mostrano dentro l'area cliente.

👉 **Cinque screenshot promuovono cinque righe da 🟡 a 🥇.** È il lavoro più
redditizio dell'intera serata, e costa dieci minuti.
🔴 Con la riserva onesta: il regolamento del **trial** potrebbe non coincidere
con quello della **challenge a pagamento** — va letto quello che c'è scritto,
non quello che ci aspettiamo.

### 1.3-bis 🥇 TRADING OBJECTIVES — pagina ufficiale ftmo.com, incollata da Claudio 27/08 sera

`[VERIFICATO]` — testo copiato direttamente dalla pagina "Obiettivi di
trading" del sito, non da search. Copre 2-Step (Challenge + Verifica):

- **Obiettivo di profitto**: 10% (Challenge) / 5% (Verifica), sul capitale
  iniziale, nessun obiettivo di profitto sull'Account FTMO funded.
- **Perdita Massima Totale**: **statica, 10% del capitale INIZIALE** —
  esempio ufficiale conto 100k: limite fisso **$90.000**, per sempre.
  **Vale anche sull'Account FTMO funded**, non solo in valutazione.
- 🆕 **Perdita Massima Giornaliera — il meccanismo esatto, e NON è quello
  che avevamo assunto**:
  > *limite(giorno N) = saldo a mezzanotte CE(S)T del giorno N − 5% del
  > CAPITALE INIZIALE (fisso in dollari, non del saldo corrente)*

  Verificato con l'esempio ufficiale: giorno 1 limite $95.000 (100k−5k);
  giorno 2 saldo $102k → limite $97.000 (102k **− 5k**, non −5,1k); giorno 3
  saldo $101k → limite $96.000. **Il cuscino in dollari resta sempre 5.000
  (5% dei 100k iniziali), l'ancora si sposta col saldo ma la SIZE del
  cuscino no.** 🔴 Diverso da Fintokei ProTrader Swing, dove il cuscino
  giornaliero CRESCE in valore assoluto col conto — qui NON cresce.
  - La verifica di sforamento intraday è su **equity** (saldo + flottante
    ± swap − commissioni), l'ancora di partenza del giorno è sul **saldo**
    a mezzanotte (il flottante overnight non sposta l'ancora, ma il
    cuscino resta fisso a 5k).
- **Giorni minimi di trading**: 4, richiesti su Challenge+Verifica insieme;
  **nessun minimo sull'Account funded**. Un giorno conta se almeno una
  posizione è stata APERTA quel giorno (00:00-23:59 CET).

🔴 **Ancora aperto**: questa pagina descrive il 2-Step generico, **non
distingue Standard da Swing**. La domanda su overnight vietato o permesso
sull'account Standard resta da chiudere (agente di ricerca in corso).

---

# 2. 🕐 IL BLOCCO DEI FUSI — la parte che, sbagliata, invalida tutto

> **Checklist punto 86** (`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`
> riga 4298): *"ogni ora stampata porta il suo fuso NELLA STESSA schermata in
> cui viene letta, e con la conversione accanto… Vale per referti, tabelle di
> chat, nomi di file e `InpSessionHour`."* 🥇 Questa sezione è l'applicazione
> letterale di quella regola.

## 2.1 I tre orologi, dichiarati una volta per tutte

```
  ORA ITALIANA  (CE(S)T)   = il riferimento umano, l'orologio di Windows sul VPS
  ORA SERVER BCM           = ora italiana  − 1        (regola di casa, CLAUDE.md)
  ORA SERVER FTMO          = ora italiana  + 1        (GMT+2 inv / GMT+3 est)
  --------------------------------------------------------------------------
  👉 FTMO = BCM + 2 ORE.   OGNI orario di sessione nei .set si sposta di +2.
```

🥇 Fonte del +1 su FTMO: `docs/REGOLAMENTO_FTMO_2026-08.md` §10, riga 106,
testuale: *"Fuso server MetaTrader: GMT+2 inverno / GMT+3 estate… ⚠️ Diverso
da BCM: FTMO server = ora italiana +1 (es. DAX apre 10:00 ora server FTMO), da
RIMAPPARE in tutti gli .ini!"* — etichetta 🟡 [LETTO-VIA-SEARCH], ripresa e
argomentata in `PROPOSTA_GUARDIAN_FTMO_2026-08-27.md` §3.3.

**Controprova aritmetica** (la stessa del §3.3 della proposta Guardian):
il DST muove **entrambi** gli orologi insieme, quindi il **+2 BCM→FTMO è fisso
tutto l'anno**, e vale anche per il reset (00:00 CE(S)T = 23:00 BCM = 01:00 FTMO).

## 2.2 🔬 LA VERIFICA EMPIRICA — **prima di fidarsi della carta** (stasera)

La carta è 🟡. Il grafico è 🥇. Procedura, 30 secondi:

1. sul terminale FTMO apri un grafico **H1** di un simbolo liquido (EURUSD);
2. leggi l'ora dell'**ultima candela H1 chiusa** = **ORA SERVER**;
3. confrontala con l'**orologio di Windows** = **ORA ITALIANA**;
4. **atteso: server = italiana + 1.**

| lettura | significato | azione |
|---|---|---|
| **+1** | la carta regge | si procede con la tabella § 2.3 e `InpDailyResetHour = 1` |
| **+2** | FTMO segue le date DST **americane** | ⚠️ tutti gli orari sono **+3** su BCM, e il reset Guardian va a **`2`** |
| **0 / altro** | 🛑 **SI FERMA TUTTO** | nessun deploy finché il numero non è spiegato |

> ⚠️ **La trappola imparata il 06/08, sbagliando** (`CLAUDE.md`): **le schede
> Esperti e Giornale di MT5 sono in ORA LOCALE del PC; il grafico è in ORA
> SERVER.** Il confronto si fa **col grafico**, mai col log. Chi fa il
> confronto col log troverà "differenza zero" e concluderà che i fusi
> coincidono: è il modo esatto in cui si sbaglia questa verifica.
>
> ➕ **Seconda verifica, gratis e indipendente**: sul grafico **D30EUR/GER40**,
> la prima candela M5 della giornata europea deve stare alle **10:00 ora
> server FTMO**. Se sta alle 08:00, il server non è +1 e la tabella § 2.3 è
> tutta sbagliata.
>
> 📅 **E le due finestre da rifare** (dalla proposta Guardian §3.3, agli atti):
> **25/10 → 01/11/2026** e **14/03 → 28/03/2027**.

## 2.3 🧾 LA TABELLA DI CONVERSIONE — **ogni EA con orari, riga per riga**

> **Da dove vengono i valori "BCM"**: dal **`.set` vivo** dove esiste, dal
> **`#define`/default del sorgente** dove il `.set` non c'è. **Etichetta su
> ogni riga.** ⚠️ Regola di casa: il valore che conta è quello **nel `.chr`
> del grafico vivo** — vedi il conflitto **X4** (§ 11).

### 🟩 Gruppo A — le sedie con orari, da convertire (+2)

| sedia (magic · simbolo) | input | **BCM** 🥇 | ora IT | **FTMO (proposto)** | fonte del valore BCM |
|---|---|---:|---:|---:|---|
| **DAX_Apertura_EU** 770101 · D30EUR | `InpSessionHour:Min` | **08:00** | 09:00 | **10:00** | `mql5/Presets/ABTG_DAX_Apertura_EU.set` |
| | `InpCloseHour:Min` | **17:30** | 18:30 | **19:30** | idem |
| **Dow_Apertura_US** 770202 · U30USD | `InpSessionHour:Min` | **14:30** | 15:30 | **16:30** | `ABTG_Dow_Apertura_US.mq5` righe 59-60 |
| | `InpCloseHour:Min` | **17:30** | 18:30 | **19:30** | idem righe 64-65 |
| **MaxMinNotte_DAX_Short_Ott** 770411 · D30EUR | `InpBoxStartHour:Min` | **23:00** | 00:00 | **01:00** 🚨 | `ABTG_MaxMinNotte_DAX.set` |
| | `InpBoxEndHour:Min` | **04:59** | 05:59 | **06:59** | idem |
| | `InpPlaceHour:Min` | **07:59** | 08:59 | **09:59** | idem |
| | `InpEntryCutoffHour:Min` | **08:30** | 09:30 | **10:30** | idem |
| | `InpCloseHour:Min` | **17:30** | 18:30 | **19:30** | idem |
| **MaxMinNotte (oro)** 770402 · XAUUSD | `InpBoxStartHour:Min` | **23:00** | 00:00 | **01:00** 🚨 | `Presets/sedie_piccolo/sedia_MAXMIN_ORO_770402.set` |
| | `InpBoxEndHour:Min` | **04:59** | 05:59 | **06:59** | idem |
| | `InpPlaceHour:Min` | **07:00** | 08:00 | **09:00** | idem ⚠️ **diverso dal DAX** |
| | `InpEntryCutoffHour:Min` | **08:30** | 09:30 | **10:30** | idem |
| | `InpCloseHour:Min` | **17:30** | 18:30 | **19:30** | idem |
| **ORB_Ottimizzato** 770611 · U30USD | `InpRangeStartHour:Min` | **14:25** | 15:25 | **16:25** | `ABTG_ORB_US.set` |
| | `InpRangeEndHour:Min` | **14:30** | 15:30 | **16:30** | idem |
| | `InpEndHour:Min` | **22:59** | 23:59 | 🛑 **NON 00:59 — vedi § 2.4** → **23:59** | idem |
| **GapContinuation** 774101 · 225JPY | `InpSessionOpenHour:Min` | **01:00** | 02:00 | **03:00** | `ABTG_GapContinuation_FORWARD.set` |
| | `InpSessionCloseHour:Min` | **07:30** | 08:30 | **09:30** | idem |
| | `InpSessionTimeMode` | **1 = MANUAL_SERVER** | — | **1, invariato** | idem ⚠️ § 2.5 |
| **EasyTrend** 772421 CHFJPY · 772422 GBPUSD | `InpHourStart` | **08** | 09 | **10** | `ABTG_EasyTrend.mq5` riga 196 🔴 fuso [INCERTO] nel sorgente stesso |
| | `InpHourEnd` | **18** | 19 | **20** | idem riga 197 |
| **EMA200** 771531 · U30USD | `InpCutoffHour` (**spento**: `InpUseCutoff=false`) | 19 | 20 | 21 *(non si applica)* | `ABTG_EMA200.mq5` righe 83-85 |
| | `InpFridayCloseHour` (**spento**: `InpFridayClose=false`) | 20 | 21 | 22 *(non si applica)* | idem riga 103 |
| **Guardian** 779001 · qualunque grafico | `InpDailyResetHour` | **23** | 00:00 | **1** | preset FIRMATO 27/08, decisione 5 |

### ⬜ Gruppo B — le sedie **senza orari**: nessuna conversione, e va detto

🥇 Verificato leggendo i sorgenti in questo giro: **non hanno alcun input di
ora di sessione**, quindi **non c'è niente da convertire** — il che è un
fatto, non una dimenticanza.

| famiglia | sedie | perché è invariante |
|---|---|---|
| **SupertrendReversal / SupRev_\*** | 970901, 770901, 770924, 970912, 970913 | `InpStartHour=0`, `InpEndHour=24` → **24 ore**: la finestra copre tutto il giorno in qualunque fuso |
| **SuperWave / SuperWave_DOW_H1_Ott** | 770531, 770511 | idem, `0`→`24` |
| **PTE** | 771321, 771322, 771332 | nessun input orario |
| **PunteLarry** | 772341-772346 | nessun input orario |
| **CostToCost** | 772361, 772362 | nessun input orario |
| **BreakingBand** | 772161-772163 | nessun input orario |
| **EMA200_Ottimizzato** | 971501 | cutoff e friday-close **spenti** |
| **GapFill** | 772231-772235 | nessun orario: solo `InpMaxHours=48` (**durata**, non ora) ⚠️ ma vedi § 2.6 |

> 📌 **Regola trasversale, per non sbagliare per eccesso di zelo:**
> **le DURATE non si convertono.** `InpRangeMinutes`, `InpDelayMinutes`,
> `InpPendingExpiryMin`, `InpMaxHours`, `InpNewsBeforeMin/AfterMin`,
> `InpExportMinutes`, `InpMaxEntryMinutesFromOpen`, `InpExitMinutesBeforeClose`
> sono **minuti**, non orologi. Chi somma +2 a un `InpRangeMinutes=15`
> ottenendo 17 ha appena rotto la cella promossa.

## 2.4 🚨 LA TRAPPOLA VERIFICATA: l'ORB muore in silenzio se si converte alla lettera

**Questo non è un timore: è codice letto oggi.** 🥇 `ABTG_ORB_Ottimizzato.mq5`
**riga 259**:

```
   if(nowMin>=InpEndHour*60+InpEndMin){ EndOfDay(); return; }
```

`nowMin` sono i **minuti dalla mezzanotte del server**. Con la conversione
letterale `22:59 BCM → 00:59 FTMO` l'input diventa `InpEndHour=0`,
`InpEndMin=59`, cioè **59**: dalle **00:59 in poi, ogni giorno**, la
condizione è vera, l'EA chiama `EndOfDay()` (riga 611: cancella i pendenti,
mette `gPhase=ORB_DONE`) e fa `return` **prima** di arrivare al blocco del
range (riga 267). 🔴 **Risultato: la sedia ORB non aprirebbe MAI un trade, e
nel giornale non comparirebbe un solo errore.**

> ### ✅ PROPOSTA — `InpEndHour:Min = 23:59` su FTMO (non 00:59)
> **Costo reale, misurato sull'orologio**: FTMO 23:59 = **IT 22:59 = ET 16:59**,
> cioè **ancora dopo la chiusura cash USA delle 16:00 ET**. Si perde **un'ora
> di coda serale** in cui il pendente resterebbe vivo — e il pendente ha già il
> suo `InpPendingExpiryMin=600` (10 ore) che lo spegne da solo.
> 🔵 **[INFERITO]**: costo operativo stimato **nullo o quasi**, e non misurato.
> **Si dichiara come scostamento voluto dalla cella promossa** (§ 11, X2).

**E la stessa domanda va fatta a ogni orario che scavalca la mezzanotte
convertendo.** Verificato in questo giro, uno per uno:

| sedia | l'orario scavalca? | esito |
|---|---|---|
| ORB `InpEndHour` 22:59 → 00:59 | ✅ **SÌ** | 🔴 rotto → si usa 23:59 |
| MaxMinNotte `InpBoxStart` 23:00 → 01:00 | ❌ no (smette di scavalcare) | 🟢 **regge**: 🥇 `ComputeBox()` riga 205 `if(tStart>=tEnd) tStart-=86400;` gestisce **entrambi** i casi. Su FTMO il box **non** attraversa più la mezzanotte: la finestra è la stessa in tempo reale |
| MaxMinNotte `InpCloseHour` 17:30 → 19:30 | ❌ no | 🟢 |
| DAX/Dow Apertura `InpCloseHour` 17:30 → 19:30 | ❌ no | 🟢 |
| GapContinuation 01:00-07:30 → 03:00-09:30 | ❌ no | 🟢 |
| EasyTrend 08-18 → 10-20 | ❌ no | 🟢 |

## 2.5 🚨 IL SECONDO INNESCO: `InpSessionTimeMode` del GapContinuation

🥇 `ABTG_GapContinuation.mq5` riga 124: il **default del sorgente** è
`SESSION_JST_DARWINEX_AUTO`, cioè **l'EA converte da solo**. Il **preset vivo**
(`ABTG_GapContinuation_FORWARD.set`) usa invece `InpSessionTimeMode=1`
(`SESSION_MANUAL_SERVER`), che 🥇 (righe 66-72 del sorgente) *"prende gli
orari COSÌ COME SONO SCRITTI, in ora server"*.

**Conseguenza doppia:**
1. in modo **manuale** la conversione +2 è **necessaria e sufficiente**;
2. 🔴 **se si trascina l'EA senza caricare il `.set`**, MT5 usa il default
   AUTO e la sessione diventa un'altra cosa — **in silenzio**. Il commento
   del sorgente (riga 64) lo dice già: *"MT5 la ignorerebbe IN SILENZIO"*.

👉 **Nel gate di installazione (§ 10.4) il `.set` di questa sedia si verifica
per primo.**

## 2.6 ⚠️ LE DUE COSE CHE IL FUSO SPOSTA E **NESSUN INPUT** GOVERNA

1. 🔴 **GapFill (5 sedie, 772231-772235)** non ha orari: opera **sull'apertura
   settimanale del simbolo**. Sul server FTMO quell'apertura cade a un'ora
   diversa e **potrebbe cadere a un prezzo diverso** (feed diverso, orari di
   sessione diversi). **Non è convertibile: è da OSSERVARE.** È anche la
   famiglia del nostro peggior giorno (🥇 25/05/26, `ANALISI_DIAL` Tab.1) e
   quella su cui pende la clausola **gap trading** di FTMO (domanda scritta D3,
   ancora **senza risposta**).
2. 🔴 **Gli orari di sessione dei simboli FTMO non sono i nostri.** Il DAX/GER40
   e gli indici USA su FTMO possono avere finestre di negoziazione e pause
   diverse da BCM. **La sonda di stasera non le legge** (§ 12, buco n.3): si
   guardano a mano in *Specifica del simbolo → Sessioni*, per i 4 indici + oro.

---

# 3. 📋 LE DECISIONI DA FIRMARE

## D1 — 🪑 IL PERIMETRO: quali sedie salgono sul trial

### D1.1 La lista di partenza è il **censimento**, non i documenti

🥇 **Fonte: `censimento_rischio_2026-08-25_0731.txt`** (letto dai `.chr` dei
grafici vivi, 25/08 ore 07:31) — **42 righe uniche** (EA · simbolo · magic):

| classe | righe | destino proposto |
|---|---:|---|
| **sedie ABTG di trading** | **36** | ✅ **salgono** (salvo simbolo assente) |
| Guardian 779001 (2 grafici) | 2 | ✅ sale **1 sola istanza** (D4) |
| TradeExporter (2 grafici) | 2 | ✅ sale **1 sola istanza** (D5) |
| `Gold_Ichimoku_TK_ATR_EA` 250604 | 1 | 🔴 **APERTA** — vedi D1.4 |
| `BREAKOUT_EA_JPY_v3` | 1 | ❌ **NON sale**: 🥇 `CONTRATTI_SEDIE.md` la classifica **[SENZA CONTRATTO]**, famiglia scartata pre-progetto (−20.853 €). Una prova generale non si fa con una sedia che nessuno ha mai promosso |

### D1.2 I 14 simboli da mappare BCM → FTMO

**Da censire stasera sui 166 simboli del loro Osservatore.** La colonna
"nome atteso" è 🔵 **[INFERITO]** e serve solo a cercare più in fretta:
**vale il nome che si legge, non quello che ci aspettiamo.**

| classe | simbolo BCM | sedie che lo usano | nome FTMO atteso 🔵 | nome FTMO **letto** |
|---|---|---|---|---|
| indice | **D30EUR** (DAX) | 770101 · 770411 · 970912 | `GER40.cash` / `GER40` | ☐ da censire |
| indice | **U30USD** (Dow) | 770202 · 770611 · 771531 · 770531 · 770511 · 771321 · 772341 · 772234 | `US30.cash` / `US30` | ☐ da censire |
| indice | **NASUSD** (Nasdaq) | 970913 | `US100.cash` / `NAS100` | ☐ da censire |
| indice | **225JPY** (Nikkei) | 770901 · 770924 · 772235 · 774101 | `JP225.cash` / `JP225` | ☐ da censire |
| metallo | **XAUUSD** | 970901 · 971501 · 770402 · 772343 | `XAUUSD` | ☐ da censire |
| forex | **EURUSD** | 772162 · 772232 | `EURUSD` | ☐ |
| forex | **GBPUSD** | 772161 · 772231 · 771322 · 771332 · 772345 · 772422 | `GBPUSD` | ☐ |
| forex | **AUDUSD** | 772163 · 772233 | `AUDUSD` | ☐ |
| forex | **EURJPY** | 772361 | `EURJPY` | ☐ |
| forex | **GBPJPY** | 772344 | `GBPJPY` | ☐ |
| forex | **GBPCAD** | 772362 | `GBPCAD` | ☐ |
| forex | **EURCAD** | 772346 | `EURCAD` | ☐ |
| forex | **EURAUD** | 772342 | `EURAUD` | ☐ |
| forex | **CHFJPY** | 772421 | `CHFJPY` | ☐ |

🚨 **Il censimento è un ARTEFATTO, non un'occhiata**: si esporta l'elenco dei
166 simboli (Osservatore → tasto destro → *Simboli*, o screenshot delle
categorie) e si deposita accanto a questo piano. Senza artefatto, la
mappatura non è verificabile e la riga X5 (§ 11) resta aperta.

### D1.3 🔴 Il perimetro è **condizionato**, e la condizione va detta

> **Se un simbolo manca su FTMO, le sue sedie NON salgono e NON si sostituisce
> il simbolo con "uno simile".** Un `GER40` al posto di `D30EUR` è già
> accettabile (stesso sottostante); un `EURCAD` mancante **non** diventa
> `EURUSD`. **La prova misura la nostra flotta, non una flotta somigliante.**
> Le sedie escluse si elencano nel referto: fanno parte del risultato.

### D1.4 ❓ La decisione aperta: `Gold_Ichimoku_TK_ATR_EA` (250604)

🥇 `CONTRATTI_SEDIE.md`: contratto **[PARZIALE]**, *"numeri pre-imbuto, broker
sbagliato, mai passata dai round"*, e **validata su Tickmill, non su BCM**.
🔴 In più: non sappiamo se espone un input magic rinominabile (non è codice
nostro) → **potrebbe rompere la regola D3 dei magic**.
**Proposta: NON sale** — ma è una riga che Claudio può ribaltare, perché è
l'unica sedia "di terze parti" e vederla su un altro broker avrebbe un valore
suo. **Firma per numero.**

### 📊 D1 — il conto proposto

| | numero |
|---|---:|
| sedie ABTG di trading dal censimento | **36** |
| − escluse per decisione (BREAKOUT, Gold Ichimoku) | −0 (già fuori dalle 36) |
| **sedie proposte sul trial** | **36** *(meno quelle il cui simbolo manca)* |
| + Guardian | 1 |
| + TradeExporter | 1 |
| **grafici totali da aprire sul terminale FTMO** | **38** |

---

## D2 — 🎚️ TAGLIE E DIAL: il trial **è** la challenge simulata

> ### PROPOSTA: **dial globale = 1,00 sulle taglie CENSITE**

**Cosa vuol dire, senza ambiguità:** ogni sedia sale **col rischio per trade
che ha oggi in campo**, letto dal censimento — **non** tutte all'1%.
Il "dial 1,00" è il **moltiplicatore globale**, non il rischio della singola
sedia (convenzione 🥇 `ANALISI_DIAL_TAGLIE_2026-08-26.md`).

| dial di sedia (dal censimento 25/08 🥇) | sedie |
|---|---|
| **1,0%** | 772161-63 · 770101(1,0) · 770202(1,0) · 771531 · 772231-35 · 770411(1,0) · 770611(1,0) · 771321 · 772341/344/345/346 · 770924 · 970901 · 770531 · 770511 · 970912 · 970913 |
| **0,65%** | 772361 · 770101 · 770202 · 770411 · 770901 |
| **0,5%** | 772422 · 770402 · 771332 · 771322 · 772342 |
| **0,3%** | 772421 · 770611 · 772343 |
| **0,25%** | 772362 · 971501 |
| **n/d** | 774101 (GapContinuation: 🥇 il censimento non trova input di rischio → **da leggere dal `.chr` prima del deploy**) |

⚠️ **La riga doppia**: le sedie 770101 · 770202 · 770411 · 770611 · 770901
compaiono **due volte** nel censimento (1,0 sul conto piccolo, 0,65/0,3 sul
dry-run 100k). 🥇 `CONTRATTI_SEDIE.md` righe 81-84 spiega perché.
👉 **Sul trial ogni sedia sale UNA VOLTA SOLA**, e **al dial del dry-run 100k
(0,65 · ORB 0,3)**, perché **quello è il contratto della corsia prop** e i
numeri di `ANALISI_DIAL`/`ANALISI_TAGLIA_FASE1` sono calcolati lì.

### Le due ragioni per cui il dial è 1,00 e non 0,74

1. 🥇 `ANALISI_DIAL_TAGLIE_2026-08-26.md`: a d=1,00 **pass-rate 99,6%**,
   mediana **12 giorni**, **0 violazioni** su 481 giorni × 40 sedie;
2. 🎯 **il trial serve a vedere la challenge come sarà**, non una versione
   annacquata. Un margine misurato a 0,74 non risponde alla domanda del
   cancello 6.

### 🚨 E la contro-misura che va letta ad alta voce PRIMA di firmare

🥇 `ANALISI_TAGLIA_FASE1_2026-08-27.md` §3b, **a leva Swing 1:15 su 200k**:

| scenario (5 ingressi indice simultanei, cap C1) | margine | % del conto |
|---|---:|---:|
| tutti al **massimo misurato** | ~299.000 € | 🔴 **149,5% — impossibile** |
| tutti alla **mediana** | ~167.400 € | 🔴 **83,7%** |

> **Firmare D2 significa firmare anche questo**: se il trial è **Swing**, è
> **atteso e previsto** che qualche ingresso venga rifiutato per margine.
> ❗ **Quel rifiuto non è un guasto: è il risultato n.1 della prova.** Va
> registrato, non "risolto" abbassando i lotti a metà corsa (D6).

---

## D3 — 🔢 I MAGIC: un blocco NUOVO e VERGINE per il trial

### Il problema

Se le sedie sul trial usassero i magic di casa (770101…), il
`TradeExporter`, le pagelle e ogni futura analisi mescolerebbero **due conti
su due broker diversi** sotto la stessa firma. 🥇 È la lezione del duello
GBPUSD (`FLOTTA_ATTIVA.md`): *"con magic uguali si sarebbero mutate a vicenda
e non ce ne saremmo accorti se non dopo settimane"*.

### 🧪 La verifica di verginità — fatta col grep, in questo giro

| controllo | comando concettuale | esito 🥇 |
|---|---|---|
| tutti i magic del repo sono a **6 cifre** | estrazione di ogni `[0-9]{6}` da `.mq5`/`.mqh`/`.set`/`.ps1`/`.md`/`.csv` | ✅ **confermato**: prefissi usati 750, 752, 760-781, 790-792, 960, 970, 971, 990, 999 |
| esiste un magic a **7 cifre che inizia per 8**? | `\b8[0-9]{6}\b` in tutto il repo | ✅ **NESSUNO** (unica occorrenza `8388736` = costante **colore** in un `.mq5`, mai un magic) |
| `InpMagic` regge 7 cifre? | tipo dichiarato negli EA | ✅ **`input long InpMagic`** in **71 file su 71** — nessun `int`, nessun troncamento |
| qualche script analizza i magic assumendo 6 cifre? | grep `magic` + regex di lunghezza in `.ps1`/`.py` | ✅ nessuno trovato |

### 🎯 PROPOSTA — **prefisso `8` + magic di casa**

```
   MAGIC_FTMO  =  8.000.000  +  MAGIC_BCM
   ------------------------------------------------
   770101  ->  8770101      MaxMinNotte DAX Short 770411 -> 8770411
   970913  ->  8970913      Guardian              779001 -> 8779001
   772231  ->  8772231      GapContinuation       774101 -> 8774101
```

**Perché questo e non un blocco `788xxx`:**
- ✅ **traceabilità immediata**: si toglie l'8 davanti e si ha la sedia di casa
  — nessuna tabella da consultare, nessun errore di trascrizione;
- ✅ **zero collisioni per costruzione**: tutta la numerazione di casa è a 6
  cifre, quindi **nessun magic FTMO potrà mai coincidere con uno di casa**,
  neanche con quelli che nasceranno nei round futuri;
- ✅ **riusabile**: `9.000.000 +` per un'eventuale seconda prop, senza
  ridiscutere niente;
- ⚠️ **il prezzo**: sette cifre invece di sei nei report. È tutto.

### La regola che accompagna la firma

> 🔴 **Un magic di casa (6 cifre) sul terminale FTMO è un DIFETTO BLOCCANTE.**
> Il gate di installazione (§ 10.4) verifica **sedia per sedia** che il magic
> letto nel `.chr` cominci per **8** e abbia **7 cifre**. Una sola sedia col
> magic vecchio → si ferma e si corregge **prima** della prima operazione.
>
> ➕ **Anche i commenti si distinguono**: proposta `InpComment` = commento di
> casa **+ ` FTMO`** (es. `MAXMIN DAX SHORT FTMO`). Costa zero e rende leggibili
> gli statement a occhio nudo.

---

## D4 — 🛡️ IL GUARDIAN SUL TRIAL

> Il preset è **già firmato** (`PROPOSTA_GUARDIAN_FTMO_2026-08-27.md`, firma
> di Claudio del 27/08 notte: *"FIRMO GUARDIAN R113 ED ANDIAMO AVANTI ANCORA
> UN PO"*). Qui **non si riapre nessun numero**: si decide **come si installa
> sul trial** e **con quale `InpStartBalance`**.

| # | input | valore per il trial | derivazione |
|---|---|---:|---|
| 1 | `InpStartBalance` | **`200000`** | 🟢 il capitale del trial. **MAI `0`**: i muri sono sul capitale iniziale |
| 2 | `InpDailyPausePct` | **`3,5`** | firmato 27/08 |
| 3 | `InpDailyLossPct` | **`4,4`** | firmato 27/08 |
| 4 | `InpTotalDDPct` | **`9,0`** | firmato 27/08 |
| 5 | `InpDDMode` | **`0`** STATICO | firmato 27/08 — ⛔ **valido solo se il trial simula il 2-Step** (§ 11, X1) |
| 6 | `InpDailyResetHour` | **`1`** | 00:00 CE(S)T = 01:00 server FTMO — **dopo** la verifica § 2.2 |
| 7 | `InpAction` | **`0`** CHIUDI+BLOCCA | firmato |
| 8 | `InpCloseAllMagics` | **`true`** | la regola è sul conto |
| 9 | `InpMaxOpenRiskPct` | **`3,25`** | FIRMA 3 del 18/08, invariata |
| 10 | `InpRiskMode` | **`0`** | invariato |
| 11-13 | `InpWarnNoSL` / `InpShowPanel` / `InpVerbose` | **`true`** | il giornale è l'unico storico che avremo |
| 14 | `InpMagic` | **`8779001`** | D3 |
| 15 | `InpComment` | **`GUARDIAN FTMO TRIAL`** | distingue i tre giornali (BCM / 100k / trial) |
| 16 | `InpAutotest` | **`true` al primo avvio, poi `false`** | prerequisito (c) della firma del 27/08 |

**Su quale grafico**: uno **qualsiasi**, purché **sempre aperto** — 🥇 il
Guardian gira su `OnTimer(1 s)`, non sui tick. **Proposta: un grafico H1 di
EURUSD dedicato**, lo stesso su cui si fa la verifica del fuso (§ 2.2).

### ⚠️ I quattro prerequisiti della firma del 27/08 che il trial deve eseguire

🥇 Decisione 10, lettere (a)-(e) del documento firmato:

| # | prerequisito | dove si esegue nel piano |
|---|---|---|
| (a) | controprova d'adozione: ogni sedia mostra l'input `InpUsaGuardian` | § 10.4, gate di installazione |
| (b) | riga *"filo verificato: 5 GlobalVariable su 5"* nel giornale | § 10.4 |
| (c) | `InpAutotest=true` al primo avvio | § 10.3 |
| (d) | verifica del fuso col **grafico** | § 2.2 |
| (e) | **procedura scritta** per rifare la baseline dopo un PC spento | § 10.6 — 🔴 **oggi non esiste da nessuna parte**, e sul trial serve *davvero* (§ 11, X3) |

---

## D5 — 📏 LE MISURE DEI 14 GIORNI: cosa si raccoglie, e con cosa

### D5.1 Gli strumenti

| strumento | dove | cosa consegna | nota |
|---|---|---|---|
| 🔬 **`ABTG_SondaMargine`** | trial, **prima** di tutto | `MARGIN_RATE`, `MARGIN_INITIAL`, `CONTRACT_SIZE`, `VOLUME_MIN/MAX/STEP/LIMIT`, `ACCOUNT_LEVERAGE`, valuta, **stop-out e margin call** | 🥇 chiude R114: *"il margine prop si misura SUI SIMBOLI DELLA PROP"*. ⚠️ gira su `OnTick` → **serve mercato aperto**, e **un grafico per simbolo** |
| 📤 **`ABTG_TradeExporter`** | trial, 1 istanza | CSV con **magic, commento, open_time, close_time, close_reason** | 🥇 `InpFile` è un input (riga 25) → **`ABTG_Trades_FTMO.csv`**, ⚠️ obbligatorio: `Common\Files` è **condiviso fra tutti gli MT5 della stessa macchina** e sul PC di backtest c'è anche BCM. Stesso nome = un file che si sovrascrive |
| 🧾 **pagella** | serale | P&L, DD, esposizione | il flusso esiste su VPS (`scarica_pagella.ps1 -Installa`, 23:15). Sul PC di backtest **va deciso** (§ 12, buco n.5) |
| 🖼️ **pannello Guardian** | a schermo | inizio giorno, DD giorno, DD totale, rischio aperto | il controllo del mattino |

### D5.2 Le sei misure che la prova deve produrre

| # | misura | come si calcola | contro cosa si confronta |
|---|---|---|---|
| **1** | 💰 **MARGINE OSSERVATO per sedia** | margine occupato all'ingresso ÷ equity, per ogni posizione | 🥇 la tabella proiettata `ANALISI_TAGLIA_FASE1` §3a (ORB 44,0% · EMADOW 38,9% · MaxMin 31,4% · ApertDAX 20,7%). **È il numero n.1 della prova** |
| **2** | 🧱 **rifiuti per margine** | conteggio delle righe *"not enough money"* / retcode 10019 nel giornale, per sedia e per giorno | oggi: **zero misure**. Qualunque numero è un guadagno |
| **3** | 🎯 **slippage FTMO vs BCM** | (prezzo eseguito − prezzo richiesto) per ingressi e per **stop**, in punti, per simbolo | 🥇 il riferimento è **21,5 punti** su uno stop Nasdaq BCM (`R109_REFERTO.md`). ⚠️ campione di 14 giorni: si guarda la **mediana**, non il massimo |
| **4** | 📊 **spread osservato** | spread medio e massimo per simbolo, nelle fasce in cui operiamo | 🥇 FTMO dichiara **zero commissioni sugli indici** (`REGOLAMENTO_FTMO` §10) → lo spread è **tutto** il costo. Su BCM il confronto esiste negli statement |
| **5** | 📐 **distanza dai muri** | ogni sera: DD giornaliero massimo e DD totale, in % di 200.000 | 🥇 attesi: worst day **−4,74%**, DD totale worst **−6,37%** (`ANALISI_DIAL` / `ANALISI_DD_TOTALE`). E **quante volte scatta la pausa a 3,5% sul FLOTTANTE** — 🔴 il buco dichiarato al §3.2 della proposta Guardian |
| **6** | 📰 **esecuzioni in finestra news rossa** | dal CSV: `open_time`/`close_time` incrociati col calendario news ad alto impatto, conteggio **±2 min** e **±5 min** | 🔴 **mai misurato in casa.** È la risposta alla domanda The5ers (±2 min = breach), FundedNext (±5 min = 40% del profitto) e FTMO Standard funded. 🥇 `ANALISI_TRADEEXPORTER_2026-08-27.md` dimostra che il CSV **ha `open_time`**: la misura è finalmente possibile |

### D5.3 ➕ Le due misure gratis che il trial regala

| misura | perché ora si può |
|---|---|
| 📡 **le 2.000 richieste server/giorno** | 🥇 buco §4.7 della proposta Guardian, *"mai contate"*. Si contano le righe di ordine/modifica nel giornale di **una giornata piena**. Con 36 sedie e i trailing che modificano l'SL, il tetto **non è ovviamente lontano** |
| ⏱️ **durata dei trade sul feed FTMO** | 🥇 le durate su BCM ci sono (`ANALISI_TRADEEXPORTER`: Aperture DAX **70% sotto i 2 minuti**). Su un altro feed cambiano — e la regola dei 2 minuti (Alpha, E8, Upcomers) si gioca lì |

---

## D6 — 🛑 QUANDO SI FERMA LA PROVA, E COSA NON SI TOCCA

### D6.1 La regola madre

> # 🧊 PER 14 GIORNI NON SI TOCCA UN PARAMETRO.
> **È una PROVA, non un'ottimizzazione.** Non si cambia un rischio, non si
> sposta un orario, non si spegne una sedia perché sta perdendo, non si
> "aggiusta" un lotto perché il margine stringe. Un parametro cambiato a metà
> corsa trasforma 14 giorni di misura in **due mezze misure di niente**.
>
> 🥇 È la stessa regola già firmata per il duello GBPUSD:
> *"fino ai 30 trade non si tocca nessuna delle due, qualunque cosa facciano
> nel frattempo"* (`FLOTTA_ATTIVA.md`).

### D6.2 Le TRE sole eccezioni ammesse (e vanno scritte nel diario)

| # | eccezione | finestra | perché è ammessa |
|---|---|---|---|
| **E1** | **correzione di un errore di INSTALLAZIONE** (magic sbagliato, `.set` non caricato, simbolo sbagliato, orario non convertito) | **solo entro le prime 24 ore**, e la sedia corretta **riparte da zero** nel conteggio | non è un cambio di parametro: è la riparazione di un deploy sbagliato |
| **E2** | **`InpDailyResetHour` del Guardian** se la verifica del fuso (§2.2) dà **+2** | in qualunque momento | è la difesa del conto, e il numero giusto è quello misurato |
| **E3** | **spegnimento di UNA sedia** che opera a un orario palesemente sbagliato | in qualunque momento | si spegne **quella**, non la prova; e si dichiara nel referto |

### D6.3 🚨 I criteri di INTERRUZIONE — quattro rossi e tre gialli

| livello | trigger | azione |
|---|---|---|
| 🔴 **STOP TOTALE** | **emergenza Guardian scattata** (giornaliera 4,4% o totale 9,0%) | la prova **è finita**: si legge il giornale, si scrive il referto. ⚠️ Il totale latcha `GV_FAILED` **per sempre** e va sbloccato a mano (F3) — 🥇 §1.2 della proposta Guardian |
| 🔴 **STOP TOTALE** | **stop-out / margin call del broker** | il conto ha smesso di somigliare al banco: nessuna misura successiva vale |
| 🔴 **STOP TOTALE** | **una sedia apre col magic di un'altra**, o due sedie condividono lo stesso magic | l'attribuzione è persa: si ferma, si corregge, si riparte con un nuovo conteggio di giorni |
| 🔴 **STOP TOTALE** | **il fuso risulta diverso da +1 e la flotta ha già operato** | tutti gli orari sono sbagliati: le operazioni fatte non sono confrontabili |
| 🟠 **allarme, prova CONTINUA** | **primo rifiuto per margine** | ⚠️ **non si interviene**: è la misura n.2. Si registra sedia, ora, lotto richiesto, margine libero |
| 🟠 **allarme, prova CONTINUA** | margin level sotto **300%** | si guarda il pannello ogni ora; sotto **200%** si valuta lo stop totale |
| 🟠 **allarme, prova CONTINUA** | slippage oltre **3×** la mediana BCM su 3 o più trade | si registra e si prosegue: lo slippage **è** un risultato |
| 🟡 **finestra dichiarata SPORCA** | terminale FTMO giù per più di **4 ore** | la prova continua, ma i giorni interessati si marcano e **non entrano nei conteggi di frequenza** |

### D6.4 E la cosa che NON è un criterio di interruzione

> ❌ **Perdere soldi non ferma la prova.** Un conto in rosso a metà trial è un
> dato, non un guasto: il muro giornaliero (5% = 10.000 $) e il Guardian a 4,4%
> esistono apposta. **Si ferma per REGOLE VIOLATE e MISURE IMPOSSIBILI, mai per
> il segno del P&L.** 🥇 Coerente con la valvola di R59: *"il campione sottile
> sospende il giudizio sul MERITO, mai sul RISCHIO"*.

---

## D7 — 🎯 COSA LA PROVA RISPONDE, E COSA NON RISPONDE

### ✅ Le sei domande che 14 giorni CHIUDONO

| # | domanda aperta oggi | dove è aperta | come il trial la chiude |
|---|---|---|---|
| 1 | **quanto margine occupa ogni sedia sul server della prop?** | 🥇 R114: *"il banco di casa NON può misurare il margine prop"*; `ANALISI_TAGLIA_FASE1` §5 punto 1 | margine **OSSERVATO**, sedia per sedia, ingresso per ingresso |
| 2 | **`SYMBOL_VOLUME_MAX` su oro, forex, Nikkei?** | 🥇 FASE 1 §5 punto 2: *"oggi il tetto è noto solo sui 3 indici"* | la sonda lo stampa per tutti i 14 simboli |
| 3 | **il cap C1 (3,25%) è esercitabile a leva prop?** | 🥇 FASE 1 §4: *"a leva 1:15 il C1 non è esercitabile com'è"* | si conta quante volte il margine morde **prima** del cap |
| 4 | **la flotta gira senza incidenti su un server non-BCM?** | mai provato | esecuzioni, rifiuti, orari, simboli, riempimenti |
| 5 | **quante volte scatta la pausa Guardian sul FLOTTANTE?** | 🥇 §3.2 proposta Guardian: *"il numero vero è più alto — e non l'abbiamo mai misurato"* | 14 giorni di flottante vero |
| 6 | **quante nostre esecuzioni cadono dentro una news rossa?** | 🔴 mai contate | il conteggio ±2 / ±5 minuti (D5.2 n.6) |

### ❌ Le cinque domande che 14 giorni NON chiudono — e vanno dette **prima**

| # | cosa NON risponde | perché |
|---|---|---|
| 1 | 🔴 **il MERITO della flotta** | 14 giorni. 🥇 La mediana di una challenge nel nostro banco è **12 giorni** e le famiglie fanno da **1 a 35 operazioni al MESE** (`CONTRATTI_SEDIE.md`): metà delle sedie farà **zero o un trade**. Un trial verde non promuove niente; un trial rosso non boccia niente |
| 2 | 🔴 **il pass-rate** | il 99,6% è una statistica su 481 giorni × 40 sedie. Una singola corsa non la conferma né la smentisce |
| 3 | 🔴 **il DD reale per famiglia** (cancello 1, M20) | serve la serie forward lunga, non due settimane |
| 4 | 🔴 **le clausole di condotta** (gap trading, one-sided bets) | 🥇 §4.8 proposta Guardian: *"si risolvono con le risposte scritte del supporto, non con una soglia"*. Un trial senza contestazioni **non è un'assoluzione**: sul trial non c'è niente da pagare |
| 5 | 🔴 **il comportamento alla taglia grande** | se il trial è a leva 1:100 (§1.2), i margini misurati **non sono quelli della Swing** e il cancello 6 resta aperto |

> ### 📌 La frase da tenere in testa per 14 giorni
> **Il trial misura la MACCHINA e il CAMPO, non il RISULTATO.**
> Risponde a *"la flotta può girare lì dentro?"*, non a *"la flotta guadagna?"*.

---

# 4. 🔧 SEZIONE OPERATIVA

## 10.1 ⚠️ La decisione operativa che nessuno ha ancora preso: **su quale macchina gira il trial?**

🟢 Il terminale FTMO è **sul PC di backtest**. E qui ci sono tre problemi veri:

| problema | perché morde | 🥇 fonte |
|---|---|---|
| **il PC di backtest si spegne** | la baseline del giorno si perde: *"se il VPS è spento all'01:00 e riparte alle 08:00, la baseline è quella delle 08:00… è l'unico buco che può far sfondare il muro senza che il Guardian se ne accorga"* | §4.2 proposta Guardian |
| **le sedie NOTTURNE non girerebbero** | MaxMinNotte (box **01:00-06:59 FTMO**), GapContinuation (**03:00-09:30 FTMO**), GapFill sull'apertura settimanale: se il PC è spento di notte, **quattro famiglie su tredici non esistono** | tabella § 2.3 |
| **il PC di backtest serve ai ROUND** | il tester MT5 satura CPU e disco. 14 giorni di trial = 14 giorni senza round, **oppure** un trial che gira su una macchina sotto carico (esecuzioni e timer del Guardian falsati) | 🔵 [INFERITO] |

> ### 🅰️ PROPOSTA — **il terminale FTMO si sposta sul VPS**
> Il VPS **è già acceso 24/7** (prassi dichiarata, §4.2 proposta Guardian), è
> dove vive la flotta, e il Guardian ci gira già. Costo: installare un secondo
> MT5 sul VPS (i due terminali convivono: cartelle dati separate via
> `origin.txt`) e verificare RAM/CPU con **38 grafici in più**.
> ⚠️ **Da misurare prima, non dopo**: se il VPS non regge 38 grafici
> aggiuntivi, il trial parte monco e non ce ne accorgiamo.
>
> ### 🅱️ SECONDA OPZIONE — resta sul PC di backtest, **acceso 24/7 per 14 giorni**
> Costo: **nessun round dal 31/08 al 14/09** (o round che sporcano la prova).
> Beneficio: zero installazioni nuove, e la sonda margine gira già lì stasera.
>
> 🔵 **Raccomandazione: 🅰️**, con 🅱️ accettabile **solo** se Claudio dichiara
> di tenere il PC acceso e di **fermare i round** per due settimane.
> **È una decisione di Claudio, non mia.**

## 10.2 📦 IL DEPLOY DEGLI EA — la strada dello script esiste già, e **non serve toccarla**

🥇 `backtest_pipeline/scarica_ottimizzati.ps1`, righe 91-107, letto oggi:

- **riga 94**: se non gli si dice niente, lo script cerca **solo** un terminale
  il cui percorso contenga `*BCM Markets MT5 Terminal*` → 🔴 **sul terminale
  FTMO non lo troverebbe mai**;
- **righe 12-16**: lo script **accetta già** i parametri `-Terminal`,
  `-MetaEditor` e `-DataFolder`;
- **righe 98-105**: se gli si passa `-Terminal`, ricava da solo la cartella
  dati confrontando `origin.txt`.

> ### ✅ PROPOSTA — **nessuna modifica al file `.ps1`**
> Si lancia lo stesso script **con `-Terminal` e `-MetaEditor` puntati
> all'installazione FTMO**. Zero codice nuovo su uno strumento che funziona.
> 🛑 **La riga esatta non la scrivo qui**: come sempre, **passa dal
> verificatore** prima di essere dettata a Claudio, con l'`irm` in testa e la
> riga di raccolta in coda (regola di casa delle righe di lancio, `CLAUDE.md`).
>
> ⚠️ **Due difetti da far cercare al verificatore, che ho visto leggendo:**
> 1. **riga 128**: lo script scarica anche `abtg_news.csv` nella `MQL5\Files`
>    del terminale bersaglio. Innocuo (i filtri news sono **spenti**: 🥇
>    `InpUseNewsFilter=false` in **10 EA su 10** controllati), ma va detto.
> 2. la lista `$EAs` (righe 34-86) è **quella di casa**: va confrontata con le
>    36 sedie di D1 — **una sedia che non è nella lista non arriva sul
>    terminale**, e nessuno se ne accorge finché non manca il grafico.

## 10.3 🌙 STASERA (giovedì 27/08) — sonde e censimenti, **zero ordini**

> 🛑 Il trial **non si attiva** finché non si piazza la prima operazione: tutto
> quello che segue è a **ordini zero** e **non consuma i 14 giorni**.
> 🥇 Coerente con il mandato: *"la sonda margine non lo attiva (zero ordini)"*.

| # | passo | consegna |
|---|---|---|
| 1 | 🕐 **verifica del fuso** col grafico H1 (§ 2.2) | screenshot grafico + orologio Windows |
| 2 | 📋 **censimento dei 166 simboli** e mappatura dei 14 (§ D1.2) | artefatto (export o screenshot) |
| 3 | 🖼️ **screenshot del cruscotto FTMO** (§ 1.3): objectives, tipo conto, leva, natura del muro totale, reset | 5 immagini = 5 righe da 🟡 a 🥇 |
| 4 | 🔬 **`ABTG_SondaMargine`** sui **14 simboli** (un grafico per volta, mercato aperto) | righe `GSPEC;` dal giornale |
| 5 | 📐 **sessioni di negoziazione** dei 4 indici + oro (Specifica del simbolo) | screenshot |
| 6 | 🧮 **ricalcolo della FASE 1 coi margini VERI** | tabella `ANALISI_TAGLIA_FASE1` §3 riscritta con [MISURATO] al posto di [PROIETTATO] |

⚠️ **Limite dichiarato della sonda**: 🥇 gira in `OnTick()` (riga 29) → **a
mercato chiuso non stampa niente**, e stampa **solo `_Symbol`**. Va spostata di
grafico in grafico. **Non stampa l'ora del server**: la verifica del fuso resta
a occhio (passo 1).

## 10.4 🗓️ WEEKEND (29-30/08) — firma, deploy, **gate di installazione**

| # | passo | criterio di superamento |
|---|---|---|
| 1 | ✍️ **firma di Claudio** su D1-D7 | scritta, per numero |
| 2 | 📦 deploy EA sul terminale FTMO (§ 10.2, riga dal verificatore) | 36 EA scaricati e **compilati** (icona non grigia) |
| 3 | 🛡️ Guardian installato con `InpAutotest=true`, `InpStartBalance=200000` | riga *"filo verificato: 5 GlobalVariable su 5"* nel giornale + esito autotest |
| 4 | 📤 TradeExporter con `InpFile=ABTG_Trades_FTMO.csv` | il file compare in `Common\Files` |
| 5 | 🪑 38 grafici aperti, `.set` caricati, orari convertiti (§ 2.3) | — |
| 6 | 🚦 **GATE DI INSTALLAZIONE** | **sotto** |

### 🚦 Il gate — si legge dai `.chr`, non dagli screenshot

🥇 Lo strumento esiste ed è collaudato: è lo stesso metodo del duello GBPUSD
(*"secondo controllo: letto dai `.chr` salvati, quattro sedie su quattro OK"*)
e del censimento del rischio.

| controllo | verde se |
|---|---|
| **magic** | ogni sedia ha **7 cifre, inizia per 8**, e togliendo l'8 si ottiene il magic di casa. **Zero magic a 6 cifre** |
| **magic unici** | nessun magic ripetuto su due sedie |
| **rischio** | il dial per sedia coincide con la tabella D2, riga per riga |
| **simbolo** | ogni sedia sta sul simbolo mappato in D1.2 |
| **orari** | ogni input della tabella § 2.3 legge il valore **FTMO**, non quello BCM. 🚨 **ORB `InpEndHour=23`, non `0`** |
| **`InpSessionTimeMode`** | GapContinuation = **1**, non il default AUTO (§ 2.5) |
| **Guardian** | `InpStartBalance=200000` · `InpDailyResetHour=1` (o 2, se § 2.2 ha detto +2) · `InpDDMode=0` |
| **adozione** | ogni sedia mostra l'input `InpUsaGuardian` nelle proprietà (prerequisito (a)) |
| **AutoTrading** | bottone verde, e **nessun ordine piazzato**: il conteggio dei 14 giorni non è ancora partito |

🔴 **Un solo rosso = non si parte lunedì.** Il trial va attivato entro il
**3/09**: c'è un margine di **tre giorni lavorativi** per rimediare. Non è
poco, ma non è infinito.

## 10.5 🚀 LUNEDÌ 31/08 — l'attivazione

| ora IT | ora BCM | **ora FTMO** | evento |
|---|---|---|---|
| 08:00 | 07:00 | **09:00** | controllo del mattino: pannello Guardian, *inizio giorno* = 200.000, battito vivo |
| 09:00 | 08:00 | **10:00** | 🎯 **apertura DAX — probabile PRIMA OPERAZIONE: da qui partono i 14 giorni** |
| 09:30 | 08:30 | **10:30** | cutoff ingressi MaxMinNotte |
| 15:30 | 14:30 | **16:30** | apertura USA: Dow Apertura + ORB |
| 18:30 | 17:30 | **19:30** | flat di giornata delle sedie d'apertura |
| 23:59 | 22:59 | **00:59** | ⚠️ **NON è l'`InpEndHour` dell'ORB**: sul trial è 23:59 FTMO (§ 2.4) |
| 00:00 | 23:00 | **01:00** | 🕐 **reset del giorno prop** — e **anche** l'apertura del box MaxMinNotte 🚨 (§ 11, X6) |

> 📅 **Fine attesa: intorno al 13-14/09.** 🔴 Il conteggio esatto **si legge sul
> cruscotto FTMO**, non si calcola qui: *"14 giorni dalla prima operazione"* può
> voler dire giorni di calendario o giorni di trading. **Da guardare il primo
> giorno.**

## 10.6 📓 IL DIARIO DELLA PROVA (ogni sera, 5 minuti)

Una riga al giorno, sempre le stesse voci — è il documento che rende leggibili
i 14 giorni **dopo**:

```
GG/MM  | equity fine giornata | DD giorno % | DD totale % | rischio aperto max %
       | margine libero MIN % | rifiuti margine (n, quali sedie)
       | pausa Guardian scattata? | terminale su/giù
       | anomalie (una riga)
```

➕ **La procedura che oggi non esiste e va scritta** (prerequisito (e) della
firma Guardian): **se il terminale è stato giù attorno all'01:00 FTMO**, la
baseline del giorno è sbagliata → si cancella la GlobalVariable
`ABTG_GUARD_<login>_DAYKEY` e si verifica che il pannello riparta dal balance
giusto. 🥇 §4.2 della proposta Guardian.

---

# 11. ⚔️ I CONFLITTI — dichiarati, non nascosti

> **Regola di casa applicata**: la gerarchia risolve, ma **il conflitto si
> scrive lo stesso**. Dove due fonti dello stesso rango divergono, il punto
> resta **APERTO**.

| # | conflitto | le due voci | rango | stato / cosa lo chiude |
|---|---|---|---|---|
| **X1** | 🔴 **il trial simula SWING o NORMAL?** | il preset Guardian firmato vale **solo per il 2-Step statico** (⛔ *"su 1-Step questo preset è NULLO"*); l'aritmetica del margine vale **solo per Swing**. Nessuno dei due è verificato sul trial | 🔴 [INCERTO] contro 🟡 | ✅ **RISOLTO 27/08 sera, sonda su 4/4 simboli**: `ACCOUNT_LEVERAGE;100` su US30/GER40/US100/XAUUSD, coerente su tutti → **conto STANDARD (1:100), non Swing**. Restano da confermare via screenshot cruscotto: nome prodotto e Trading Objectives (§1.3) |
| **X2** | 🚨 **ORB: conversione letterale vs sedia viva** | la regola "+2" dice `InpEndHour=0:59`; il codice (🥇 riga 259) dice che così **la sedia muore in silenzio** | 🥇 codice **batte** regola | **RISOLTO con scostamento dichiarato**: `23:59` su FTMO, costo 🔵 [INFERITO] ≈ nullo. **Non è più la cella promossa alla lettera, ed è scritto** |
| **X3** | 🔴 **macchina del trial: PC di backtest vs VPS** | il terminale è **sul PC** (🟢 osservato); il Guardian pretende una macchina accesa all'01:00 (🥇 §4.2) e quattro famiglie operano di notte | 🥇 contro 🟢 | **APERTO → decisione di Claudio** (§ 10.1) |
| **X4** | ⚠️ **orari: `.set` del repo vs `.chr` del grafico vivo** | i valori BCM della § 2.3 vengono dai `.set` e dai sorgenti; **il valore che opera davvero è nel `.chr`** | 🥇 `.chr` **batte** `.set` | **si chiude nel gate § 10.4**: si converte da un censimento `.chr` fresco, non da questa tabella |
| **X5** | ⚠️ **MaxMinNotte oro: 22:00-06:00 o 23:00-04:59?** | 🥇 `sedia_MAXMIN_ORO_770402.set`: box **23:00-04:59**, piazzamento **07:00** · 🟡 `DOSSIER_PROP_CANDIDATE` §5.2: *"variante oro 22:00-06:00"* | 🥇 batte 🟡 | **RISOLTO a favore del `.set`** — e la riga del dossier va corretta. ⚠️ nota: il piazzamento oro (**07:00**) **differisce dal DAX (07:59)**: due sedie della stessa famiglia, due orari |
| **X6** | 🚨 **il box MaxMinNotte apre ESATTAMENTE sul reset prop** | su BCM il box apre alle 23:00 = **sul reset**; su FTMO alle 01:00 = **ancora sul reset** (`InpDailyResetHour=1`). Il problema **si sposta, non sparisce** | 🥇 (già segnalato in `DOSSIER_PROP_CANDIDATE` §5) | **APERTO come rischio accettato**: un flottante in perdita aperto sul reset **mangia il budget del giorno nuovo**. Da osservare nei 14 giorni, non da risolvere ora |
| **X7** | ⚠️ **"35 sedie vive" contro 36** | 🥇 `ANALISI_DIAL` (base `R105_dataset_giornaliero.csv`): **35 sedie vive** · 🥇 censimento `.chr` 25/08: **36 sedie ABTG** di trading | due 🥇 dello stesso rango | **APERTO** — differenza di **una riga**, probabilmente il duello PTE GBPUSD (2 magic, 1 sedia) o le due Nikkei (770901/770924). **Si conta dal `.chr` fresco prima del deploy** |
| **X8** | ⚠️ **valuta: conto in USD, aritmetica di casa in EUR** | 🟢 il trial è in **USD 200.000** · 🥇 `ANALISI_TAGLIA_FASE1` §0c dichiara *"conto assunto in EUR [ASSUNTO DA VERIFICARE]"* e usa il cambio 1,152 | 🟢 batte l'assunzione | ✅ **RISOLTO 27/08 sera**: sonda conferma `ACCOUNT_CURRENCY;USD` su tutti e 4 i simboli — **la FASE1 va rifatta in USD**, il cambio 1,152 non entra. 🆕 **E c'è un secondo problema emerso, più grande della valuta**: vedi la nota sotto sul `MARGIN_RATE` |
| **X9** | 🔴 **news nel trial** | 🟡 *"in Challenge/Verification nessuna restrizione news per nessun tipo di conto"* (dossier §2) · 🟡 su **Standard funded** anche uno SL che scatta a ±2 min è **breach** | 🟡 contro 🟡, **e il trial non è né l'uno né l'altro** | **APERTO** → screenshot delle Forbidden Practices dal cruscotto (§1.3). Nel frattempo **si misura il conteggio** (D5.2 n.6): la misura vale comunque |
| **X10** | ⚠️ **EasyTrend: il fuso della sua fascia oraria è [INCERTO] nel sorgente stesso** | 🥇 `ABTG_EasyTrend.mq5` riga 196: *"ORA SERVER (fuso [INCERTO]: da rimappare in calibrazione)"* + esiste `REFERTO_ROUND53_FUSO_EASYTREND.md` | 🥇 auto-dichiarato | **APERTO**: la conversione +2 (08-18 → 10-20) è **coerente**, ma parte da una base che l'EA stesso dichiara incerta. Si converte e **si dichiara** |
| **X11** | 🟡 **le 2.000 richieste/giorno con 36 sedie** | 🟡 il limite esiste (repo 13/08) · 🔴 **mai contato in casa** (§4.7 proposta Guardian) | 🟡 contro 🔴 | **si chiude DENTRO la prova** (D5.3): è una delle poche cose che 14 giorni misurano bene |
| **X12** | ⚠️ **dial challenge: 1,00 o 0,74?** | 🥇 `ANALISI_DIAL` 26/08: **1,00 in challenge** · 🥇 `R106_REFERTO` 25/08: squadra **B = ×0,74** anche in challenge | due 🥇, conflitto **già agli atti** in `PIANO_PROP` riga C7 | **APERTO nel PIANO_PROP** — qui si propone **1,00** perché il trial deve mostrare il caso che compreremo. **Non lo chiude: lo illustra** |
| **X13** 🆕 | 🔴 **il margine reale è IL DOPPIO di quello calcolato con la formula semplice (prezzo×contratto÷leva)** | sonda G-SPEC, 27/08 sera, 4/4 simboli: `MARGIN_RATE_BUY_INITIAL;2.00000000` costante su US30/GER40/US100/XAUUSD | 🥇 misurato sul server vero, non deducibile da fuori | 🆕 **APERTO, e pesa più di X8**: ogni % di margine della FASE1 (calcolata con `prezzo×contratto÷leva`) va **raddoppiata**. Vedi tabella sotto |

### 🥇 TABELLA G-SPEC — le 4 sonde di stasera (27/08, tutte via `ABTG_SondaMargine` sul trial vero)

| simbolo | leva conto | valuta margine | margine OSSERVATO 1 lotto | formula semplice (mai usare da sola) | volume max |
|---|---:|---|---:|---:|---:|
| **US30.cash** | 100 | USD | **1.071,09** | 535,55 | 1.000 |
| **GER40.cash** | 100 | **EUR** ⚠️ | **614,37** | 263,71 | 1.000 |
| **US100.cash** | 100 | USD | **592,00** | 296,00 | 1.000 |
| **XAUUSD** | 100 | USD | **9.214,68** | 4.607,34 | **100** (cappato, come su BCM) |

**La lettura che conta**: `MARGIN_RATE_BUY_INITIAL = 2,0` su tutti e 4 → FTMO applica un **moltiplicatore di rischio ×2** oltre alla leva 1:100. Il margine vero **non è** `prezzo × contratto ÷ 100`: è quello **×2**. Chi avesse fatto i conti FASE1 con la formula semplice avrebbe **dimezzato** il margine reale su ogni sedia indici/oro — esattamente l'errore che R114 aveva previsto ("il banco misura il motore, non il margine prop"), e che stavolta la sonda ha chiuso PRIMA di comprare, non dopo.
Margin call **100%** / stop-out **50%** confermati su tutti e 4 (`ACCOUNT_MARGIN_SO_CALL;100` / `ACCOUNT_MARGIN_SO_SO;50`).
🔴 **Nota per il DAX**: il margine è in EUR mentre il conto è in USD → serve il cambio EUR/USD del momento per convertirlo, non si somma direttamente agli altri tre.

---

# 12. 🕳️ COSA MANCA E CHI LO PORTA

| # | buco | chi | domanda esatta |
|---|---|---|---|
| 1 | 🔴 **tipo di conto e leva del trial** | **Claudio**, stasera | screenshot cruscotto + `ACCOUNT_LEVERAGE` dalla sonda |
| 2 | 🔴 **nomi dei 166 simboli FTMO** | **Claudio**, stasera | export/screenshot dell'elenco → mappatura D1.2 |
| 3 | 🔴 **orari di sessione dei simboli FTMO** | **Claudio**, stasera | *Specifica del simbolo → Sessioni* per i 4 indici + XAUUSD |
| 4 | 🔴 **risposta scritta FTMO su gap trading + one-sided bets** | **supporto FTMO** (ticket già aperto, mail del 27/08 ~00:30) | domande già inviate, agli atti nel dossier §2 |
| 5 | 🟠 **pagella serale sul terminale FTMO** | **Claudio + chat principale** | `scarica_pagella.ps1` oggi è tarato sul VPS/BCM: va deciso se si adatta o se il diario § 10.6 basta per 14 giorni |
| 6 | 🟠 **`.chr` freschi della flotta BCM prima del deploy** | **Claudio**, weekend | il censimento del 25/08 ha **due giorni**: gli orari e i dial si rileggono dai `.chr` **del giorno del deploy** (conflitto X4) |
| 7 | 🟠 **RAM/CPU del VPS con 38 grafici in più** | **Claudio**, se si sceglie l'opzione 🅰️ | misura prima del deploy, non dopo |
| 8 | 🟡 **il dial vivo di `GapContinuation` 774101** | **Claudio**, dal `.chr` | 🥇 il censimento dice *"nessun input di rischio trovato"*: senza quel numero la sedia non ha una taglia dichiarata |
| 9 | 🟡 **la lista `$EAs` dello script contro le 36 sedie** | **verificatore**, col resto della riga di lancio | una sedia fuori lista non arriva, e nessuno se ne accorge |
| 10 | 🟡 **calendario news ad alto impatto per il periodo 31/08-14/09** | **cacciatore-config-prop / analista** | serve alla misura D5.2 n.6: senza calendario non si contano le finestre rosse |

---

# ✍️ BLOCCO FIRMA — `FIRMO PROVA GENERALE`

| # | decisione | proposta | cosa comporta firmarla |
|---|---|---|---|
| **D1** | 🪑 **perimetro** | **36 sedie** dal censimento `.chr`, quelle il cui simbolo esiste su FTMO; **fuori** `BREAKOUT_EA_JPY_v3`; **fuori** `Gold_Ichimoku` (riga ribaltabile); nessuna sostituzione di simbolo | 38 grafici sul terminale FTMO; le sedie escluse entrano nel referto |
| **D2** | 🎚️ **taglie/dial** | **dial 1,00 sulle taglie censite**, col dial della corsia prop (0,65 · ORB 0,3) dove esiste | si accetta **in anticipo** che qualche ingresso venga rifiutato per margine: è il risultato n.1, non un guasto |
| **D3** | 🔢 **magic** | **`8.000.000 + magic di casa`** (7 cifre, prefisso 8) — verginità verificata col grep in questo giro; `InpComment` + ` FTMO` | un magic a 6 cifre sul trial è un **difetto bloccante** al gate |
| **D4** | 🛡️ **Guardian** | preset **firmato** + `InpStartBalance=200000`, `InpMagic=8779001`, `InpDailyResetHour=1` **dopo** la verifica del fuso; grafico dedicato sempre aperto | i 5 prerequisiti (a)-(e) diventano passi eseguibili del § 10.4 |
| **D5** | 📏 **misure** | sonda margine + TradeExporter (`ABTG_Trades_FTMO.csv`) + diario serale; **6 misure obbligatorie** + 2 gratis | la prova ha un output definito **prima** di partire |
| **D6** | 🛑 **interruzione e congelamento** | **nessun ritocco per 14 giorni**, 3 eccezioni scritte, 4 stop rossi + 3 allarmi gialli; **il P&L non ferma la prova** | si rinuncia a "sistemare le cose" in corsa |
| **D7** | 🎯 **perimetro delle risposte** | 6 domande chiuse, **5 dichiarate NON chiuse** | firmare il D7 vuol dire dire ad alta voce: *"14 giorni non promuovono e non bocciano nessuna sedia"* |
| **D-OP1** | 🖥️ **macchina** | 🅰️ **terminale FTMO sul VPS** (raccomandata) · 🅱️ resta sul PC acceso 24/7 con round fermi | è la decisione che rende possibili (o impossibili) le sedie notturne |
| **D-OP2** | 📦 **deploy** | `scarica_ottimizzati.ps1` **senza modifiche**, con `-Terminal`/`-MetaEditor` sul percorso FTMO; **riga dal verificatore**, con `irm` e raccolta finale | zero codice nuovo |
| **D-OP3** | 📅 **calendario** | **27/08 sera**: sonde + censimenti + screenshot (zero ordini) · **29-30/08**: firma, deploy, gate · **31/08**: attivazione col primo trade · fine ~13-14/09 | il vincolo Jackson Hole 27-28/08 è rispettato; margine fino al **3/09** se il gate boccia |

> ### 📌 PERIMETRO DELLA FIRMA
> - ⛔ **Questa firma non tocca il demo BCM 50503392 né il dry-run 100k.**
> - ⛔ **Non autorizza nessun acquisto**: il trial è gratuito e la regola D3
>   (risposta scritta del supporto prima di ogni euro) resta in piedi.
> - ⛔ **Non chiude nessuno dei sei cancelli del `PIANO_PROP`**: li **alimenta**
>   (il 6 in modo diretto, il 4 con la prova sul campo del Guardian).
> - 🧊 **Regola di ripensamento**: ogni numero qui sopra si riapre **solo** con
>   una misura nuova che lo contraddica, per iscritto. Mai a caldo, mai in
>   silenzio, **mai dopo aver visto chi colpisce**.

---

## 📜 CHANGELOG

| data | versione | cosa |
|---|---|---|
| 27/08/2026 | **v1** | Prima stesura. Fonti lette in questo giro: `PROPOSTA_GUARDIAN_FTMO_2026-08-27.md` (preset firmato + §3.3 fuso), `FLOTTA_ATTIVA.md`, `backtest_pipeline/RIEPILOGO_FORWARD.md`, `DOSSIER_PROP_CANDIDATE_2026-08-26.md`, `ANALISI_TAGLIA_FASE1_2026-08-27.md`, `R114_REFERTO.md`, `ANALISI_TRADEEXPORTER_2026-08-27.md`, `CONTRATTI_SEDIE.md`, `censimento_rischio_2026-08-25_0731.txt`, CHECKLIST punti **86** e **89**, `docs/REGOLAMENTO_FTMO_2026-08.md` §10, e i **sorgenti** `ABTG_ORB_Ottimizzato.mq5`, `ABTG_MaxMinNotte*.mq5`, `ABTG_GapContinuation.mq5`, `ABTG_EasyTrend.mq5`, `ABTG_EMA200.mq5`, `ABTG_SondaMargine.mq5`, `ABTG_TradeExporter.mq5`, `scarica_ottimizzati.ps1` + i `.set` vivi. **Trovato leggendo il codice** (non nei referti): la trappola ORB § 2.4 e il modo sessione del GapContinuation § 2.5. **12 conflitti** dichiarati, **10 buchi** assegnati. Nessun file toccato, nessun commit. |

_Fine del piano. Nessun numero nudo, nessun orario senza il suo orologio._
