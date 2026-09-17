# 🪑 `ABTG_EMA200` DOW — **COSA MANCA, ESATTAMENTE, PER AVERLA IN CAMPO IL 1° OTTOBRE**

**Giovedì 17/09/2026. Mancano 13 giorni.** Bussola pura, **sola lettura**: nessun
EA, preset, file prova, riga di coda o terminale è stato toccato. Il conto reale
`10105439` non è stato letto né nominato come bersaglio. Nessuna taglia e nessun
parametro di rischio è proposto qui: sono di Claudio.

> # 🥇 IL VERDETTO IN UNA RIGA
> ## **Per schierarla mancano 9 cose: 5 di FIRMA, 3 di AZIONE MANUALE (mani di Claudio, preparazione nostra) e 1 di MISURA nostra da ~1 minuto di tester. ZERO righe di codice da scrivere.**

> ## 🧭 E LA RISPOSTA ALLA DOMANDA DI CHIUSURA
> **Se domani mattina Claudio firmasse tutto — compreso l'acquisto — SÌ, questa
> sedia è in campo ben prima del 1° ottobre.** Il gesto tecnico è **un F7 e un
> ricarico**, il preset esiste già su file, e il binario da schierare **è già
> stato compilato e fatto girare** (sul banco da backtest, 16-17/09).
> 🔴 **Quello che la blocca davvero non è lavoro nostro: è che il conto su cui
> dovrebbe girare NON ESISTE ANCORA** (firma #7 del piano, *"quale prop, quale
> taglia"*, sono soldi, scadenza 29/09). Oggi la sedia sta sul **demo piccolo
> `50503392` con ~5.000 EUR, dove nessun Guardian gira**.

---

# 0. 📣 PRIMA LE VITTORIE, perché fra il 13/09 e oggi sono cambiate cose vere

Il mandato diceva di non fidarsi del riassunto del pacchetto del 13/09. Bene: **quattro
delle sue paure sono cadute, e tutte e quattro a favore della sedia.**

| il 13/09 si diceva | oggi | fonte |
|---|---|---|
| ⛔ *"NON SI COMPILA `HEAD`"*: il commit `b45dd00` (*«IN CORSO D'OPERA — NON COMPILARE»*) non era mai passato dal cancello | 🟢 **CADUTA.** `b45dd00` ha **PASS 10/10 EA** dal doppio cancello il **15/09**, e `HEAD` **è tornato il bersaglio legittimo** | `report/RUNBOOK_RICOMPILAZIONE_PICCOLO_2026-09-14.md` r.452 e riga «S1» (aggiornata 15/09) · `report/NOTTE_2026-09-15.md` rr.32-42 |
| ⛔ *"154 righe nuove che non hanno mai visto un F7 possono non compilare affatto"* | 🟢 **CADUTA, ed è MISURATO**: sul banco `C:\MT5_Backtest` il sorgente è a **691 righe** (= `HEAD`) con l'`.ex5` accanto datato **2026-09-16 11:34**, e sei round su quel binario sono girati a **uscita 0** | `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260917_033003.log` **r.16** · `REFERTO_RUNNER_20260917_033003.txt` rr.95-120, 158 |
| 🔴 *"requisito 3 (gestione dell'uscita) mai messo ad asse"* | 🟢 **CHIUSO**, e l'ho riletto io sui CSV grezzi (§5) | `risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r136{a,b,c,d}.csv` |
| 🔴 *"requisito 5 (TF) mai cambiato su U30USD"* | 🟢 **CHIUSO**: H1 confermato, M15/M20/M30 **bocciati col numero** (§5) | `..._{IS,OOS}_cemad05.csv` |

🟢 **E una quinta, che il 12/09 era dichiarata `[NON MISURABILE]`**: il **massimo di
posizioni contemporanee**. Non serviva un backtest: **lo dice il codice, ed è 2**
(§2.3). Il *"buco strutturale che nessun backtest chiude"* del 12/09 si chiude
**leggendo**.

---

# 1. 🔴 LA LISTA DEGLI OSTACOLI, PER NOME E PER CATEGORIA

**(M)** manca una misura · **(C)** manca codice · **(F)** manca la firma di Claudio ·
**(A)** manca un'azione manuale sul VPS

| # | cat | ostacolo | costo / cosa serve |
|---:|:---:|---|---|
| 1 | **(A)** | 🔴 **Il binario in campo sul piccolo `50503392` è del 06/08 e NON legge il Guardian.** `ABTG_EMA200.mq5` in cartella terminale: **487 righe** nel log (= 486 `wc -l`), `GUARD = no`, `.ex5` del **2026-08-06 19:33**. `HEAD` ne ha **690** e il Guardian c'è (§2) | **F7 + ricarico + riattacco col preset.** 🟢 **Zero righe di codice da scrivere**, zero modifiche: il sorgente è già a posto. Procedura già scritta: `RUNBOOK_RICOMPILAZIONE_PICCOLO_2026-09-14.md` §3, e l'ordine consigliato mette **771531 per prima** (r.218) |
| 2 | **(A)** | 🚚 **Il trasporto dei risultati è fermo dal 13/09**: `r146b` (`InpFridayClose`) e `r147a` (`InpBreakeven`) — **due manopole d'uscita di QUESTA sedia** — sono girate a **uscita 0** stanotte, e **i loro CSV non sono nel repo**. Verificato: `find` su `*r146b*` / `*r147a*` → **zero file** | **Una riga sola** su una finestra PowerShell del VPS: `carica_risultati.ps1` esiste, è già gatato, i percorsi combaciano. 🟢 **Zero tempo macchina.** Sblocca anche gli altri 45 round illeggibili. 🚦 La riga la prepariamo noi e **passa dal cancello prima di uscire** |
| 3 | **(A)** | 🛡️ **Sul conto dove la sedia gira oggi NESSUN Guardian gira.** Giornale del piccolo, 16 **e** 17/09: *"GUARDIAN: nessuna riga in questo giorno"*. Il Guardian è attaccato **solo** sul 100k (`779001`) e sul reale (`779002`) | **Attaccare `ABTG_Guardian` al conto della challenge** quando esiste. Finché non c'è, la guardia dell'EA è **fail-open e MUTA** (§2.2) |
| 4 | **(F)** | ✍️ **Firma #2 del piano: spostare `771531` sul conto della challenge a 0,65%.** 🔴 **Scaduta**: il piano la dava **entro il 15/09** | È rischio e taglia → sua. Nostra solo la preparazione, **che è già fatta**: il preset `ABTG_EMA200_U30USD_H1_771531_VIVA.set` esiste su file dal 12/09 e copre **44 input su 44** (verificato con `comm` in questo giro) |
| 5 | **(F)** | 💸 **Firma #7: quale prop, quale taglia, quale `InpDailyBaseline`.** Sono **soldi**. Scadenza del piano: **29/09** | 🔴 **È IL BLOCCO VERO.** Il conto non esiste: senza di lui la sedia può solo tornare in campo **sul demo piccolo**, che non è la challenge |
| 6 | **(F)** | ✍️ **Firma #8: quante sedie e quali il giorno 1.** Scadenza **29/09** | La proposta dell'architetto è il terzetto `770611`-OPPRANGE + `770202` + `771531` a 0,65% ciascuna = 1,95% di rischio aperto, dentro il cap C1 (3,25%) |
| 7 | **(F)** | 📏 **L'IS ha 132 POSIZIONI contro il pavimento di 150 dell'Emendamento A.** Non è più una stima: è **MISURATO** (§3.2). Va **dichiarato come si legge**: (a) lettura asimmetrica — *il vecchio giudica il RISCHIO, il recente il MERITO* (Emendamento B, valvola R59) → l'IS a 132 basta per il rischio, e il merito lo giudica l'OOS a 257; oppure (b) **ritagliare la finestra** più in là | 🔴 **I criteri si cambiano prima dei numeri, non dopo** → è una firma, non una misura. Con (b) servirebbe **una corsa nuova** e il PF OOS di 1,52365 **cambierebbe**: non è gratis |
| 8 | **(F)** | 📊 **Il pavimento di frequenza di FAMIGLIA non è raggiunto, e nessuna misura lo può chiudere.** La famiglia degli **schierabili in prop** ha **un simbolo solo** e fa **0,945 posizioni/giorno** (§3.3). L'unico gemello che la porterebbe sopra è `971501` XAUUSD, firmato il 23/08 **«prop: NO a nessuna taglia»** (DD 45,91%) | 🔴 **Non è riparabile misurando**: sui quattro indici azionari gemelli il motore fa **6 celle positive su 330**. È una **concentrazione da firmare sapendola**, non un buco da colmare |
| 9 | **(M)** | 📐 **Il DD a 0,65% è un APPROSSIMATO, non una misura**: 5,09% ricavato dividendo il 7,8323% per 1,538, e la riconciliazione R29↔R112 dimostra che **quel metro sbaglia del 6%** | 🟢 **~1 minuto di tester**: stessa cella, stesso file prova, `-Deposito 100000 -Rischio 0,65`. **Non ricavabile da nessun CSV in repo** (nessuna corsa a 0,65% esiste). È il buco **M40** di `PIANO_PROP.md` r.1934 |

## 🟢 E COSA **NON** È PIÙ UN OSTACOLO — dichiarato per non farlo ricomparire

- **(C) niente.** 🔴 **Non manca UNA riga di codice.** Il sorgente a `HEAD` ha il
  Guardian, il preset ha tutti e 44 gli input, l'include compila. La colonna (C)
  di questo referto è **vuota**, ed è la notizia migliore della lista.
- **Il DD alla taglia del conto che gira (~5.000 EUR, buco M40 seconda metà)**:
  si **dissolve** se si firma la #5. Il 7,8323% è misurato **a deposito 100.000**,
  cioè **alla taglia della challenge**. Resta aperto solo se la sedia resta sul piccolo.
- **Il massimo di posizioni contemporanee e il flottante**: chiusi dal codice (§2.3)
  e dalla peggior giornata già misurata da R112 (**−2,45% sui chiusi / −1,98% in
  equity @1%** → **−1,59% / −1,29% @0,65%**, `PIANO_CHALLENGE_OTTOBRE_v2.md` r.587).
  È **l'unica sedia del parco** ad avere quel numero.

---

# 2. 🛡️ IL GUARDIAN — verificato sul sorgente di stasera, non ereditato

## 2.1 Il sorgente a `HEAD` legge il Guardian? **SÌ. Con due punti, e li ho letti.**

| cosa | dove, a `HEAD` di `lavoro` (commit `b45dd00`, 11/09) |
|---|---|
| `#include <ABTG_PausaGuardian.mqh>` | `mql5/Experts/ABTG_EMA200.mq5` **r.30** |
| l'input | **r.42** `input bool InpUsaGuardian = true;` |
| la chiamata | **r.381** `if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_EMA200")){ cO_guardian++; return; }` |
| righe totali | **690** (`wc -l`) |

⚠️ **Le righe del referto del 12/09 erano r.42 e r.381 e sono ancora quelle**:
coincidono, ma **non perché le abbia ricopiate** — le ho ricercate
(`grep -n`) sul file di stasera. **[MISURATO]**

📍 **In quale punto del flusso.** La chiamata sta **dentro `PlaceLimit()`**, che è
la funzione che manda il singolo ordine. È **dopo** il calcolo del lotto (r.376) e
**immediatamente prima** di `BuyLimit`/`SellLimit` (r.382). Quindi può solo
**impedire un nuovo ingresso**: non apre niente, non tocca posizioni già aperte,
trailing, breakeven, parziali o uscite. E siccome `PlaceOrders()` chiama
`PlaceLimit()` **due volte** (r.364 e r.366), la guardia è interrogata **una volta
per gamba**.

🟢 **Ed era già dentro la versione misurata**: nel tester il canale del Guardian
non esiste, quindi R112 ha girato con questa riga presente e in fail-open — il
PF 1,52365 **non cambia** perché la riga c'è.

## 2.2 Basta una ricompilazione? **Per il CODICE sì. Per la PROTEZIONE no.**

| serve | stato |
|---|---|
| ricompilazione dell'EA | ✅ **basta lei**: `HEAD` è ora bersaglio legittimo (cancello 15/09) e **compila** (`.ex5` 16/09 11:34 sul banco) |
| **preset** | ✅ **esiste già**: `mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set` (commit `e146a47`, 12/09), **44 chiavi su 44 input** — verificato in questo giro con `comm` fra gli `input` dell'EA e le chiavi del `.set`. 🔴 Porta `InpRiskPercent=0.65` mentre il campo gira a **1.0** (`CODA_01 ... 20260917` r.43): **caricarlo ABBASSA la taglia, ed è una DECISIONE DI CLAUDIO** |
| **input nuovi** | ✅ nessuno da inventare. Rispetto al campo ne arrivano due: `InpUsaGuardian` e `InpLogImbuto` (il discriminante visivo per capire se l'F7 ha morso è proprio la presenza di `InpLogImbuto` nella scheda Input — runbook r.211) |
| **mappa cluster (C2)** | ❌ **non serve.** L'EA chiama la guardia con **due argomenti**, quindi `cluster_mappa` resta vuota e il ramo C2 (`ABTG_PausaGuardian.mqh` r.1686 `if(StringLen(cluster_mappa)>0)`) **non si legge nemmeno**. E per la misura del 12/09 sera il C2 **non serve adesso** (è più largo del C1 già acceso) |
| 🔴 **un Guardian VIVO sul conto** | ❌ **MANCA, ed è il punto.** Vedi sotto |

🔴 **Il fail-open, alla riga.** `mql5/Include/ABTG_PausaGuardian.mqh` **r.1719**:

```
   if(!ABTG_CanaleEsiste()) return(true);       // 2. nessun guardiano su questo conto
```

**Se nessun Guardian gira sul conto, la guardia dice SÌ a tutto** — e lo fa
**senza scrivere una riga di giornale**. Sul piccolo `50503392` oggi è
esattamente così: `CODA_09_giornale_operativo_20260917_033003.log` rr.44 e 50 →
*"GUARDIAN: nessuna riga in questo giorno"* per il 16 **e** il 17/09.
Il Guardian è attaccato **solo** su `BCM Markets MT5 Terminal -V3` (100k, magic
`779001`) e su `C:\BCM_Reale` (magic `779002`) —
`CODA_01_sedie_attaccate_20260917_033003.log` rr.79, 81, 101. **[MISURATO]**

## 2.3 🔴 LA DOMANDA CHE CONTA: schierarla senza Guardian è un fail-open sul cap?

### 🟢 **La risposta, letta dal codice e non dai referti: sul rischio DELLA SEDIA no, è limitato dal codice dell'EA. Sul cap DI CONTO sì, ed è un fail-open pieno.**

**Prima una correzione, perché il mandato cita un input che qui non esiste.**
🔴 **`InpRiskMode` NON è un input di `ABTG_EMA200`.** `grep -c` sul sorgente e
sull'include → **0 e 0**. È un input **del Guardian**
(`mql5/Experts/ABTG_Guardian.mq5` **r.154**), e governa **come il Guardian conta**
il rischio aperto (0 = distanza ingresso→SL), non come l'EA lo prende.

### 📐 Il numero, derivato dal codice riga per riga

| grandezza | valore | da dove, nel codice |
|---|---|---|
| **massimo posizioni contemporanee di questa sedia** | 🎯 **2** | `ABTG_EMA200.mq5` **r.322**: `if(HasPosition() || HasPending()){ ... return; }` — l'EA **non arma una nuova candidata** finché ha una posizione **o** un pendente col suo magic sul suo simbolo (`HasPosition()` r.509-518, `HasPending()` r.520-529: filtrano per `_Symbol` **e** `InpMagic`). Un solo armamento produce **al massimo 2 gambe** (`PlaceOrders()` r.360: `nOrders = InpUseOrder2 ? 2 : 1`) |
| **rischio per posizione** | **`InpRiskPercent / 2`** = **0,325%** col preset (**0,50%** come gira oggi a 1,0) | r.361: `double riskPct = InpRiskPercent/nOrders;` poi `PlaceLimit(...,riskPct,...)` r.364/366 |
| **rischio massimo della sedia, tutto assieme** | **= `InpRiskPercent`** → **0,65%** col preset (**1,0%** oggi) | le due gambe condividono lo **stesso SL** (r.358: `sl` calcolato una volta, passato a entrambe): se stoppano entrambe si paga `2 × InpRiskPercent/2` |
| **il calcolo del lotto** | `LotByRisk()` r.467-496: `risk = BALANCE × riskPct/100`, perdita per lotto da `OrderCalcProfit` (tick value come ripiego) | — |

### ⚠️ E il limite di quel numero, dichiarato: **il pavimento del lotto lo può sfondare**

`LotByRisk` chiude con **r.495**: `return(MathMax(mn,MathMin(mx,lot)));`. Il
`MathMax` sul **volume minimo** vuol dire che **se il lotto voluto scende sotto
`0,10`, il rischio SALE sopra il nominale, e verso l'alto non c'è tetto**. È la
**classe 228**, e su questa sedia il conto è già stato fatto:
**0,834% ad ATR 200 · 1,251% ad ATR 300** (a 0,65% sul saldo del piccolo).
🟢 **Ma in campo, sui P/L veri, il pavimento NON ha morso**: il 04/09 le due gambe
sono andate a **0,20 e 0,30 lotti**, cioè 2× e 3× il minimo
(`PIANO_PROP.md` r.1841, che cita il `DIARIO.md` del 04/09). **E su un conto da
100k morde MENO, non più** (più saldo = più lotto = più lontano dal minimo):
direzione dimostrata, `[INFERITO]`.

### 🔴 Cosa si perde davvero, schierandola senza Guardian

Non il rischio della singola sedia — quello lo tiene il codice a **2 posizioni e
`InpRiskPercent`**. Si perdono **le due firme del 18/08, che sono grandezze DI
CONTO e nessun EA può calcolarsele da solo**:

1. **B1 — pausa morbida giornaliera** (perdita del giorno oltre il 4,0% blocca i
   nuovi ingressi): l'EA non sa quanto hanno perso le **altre** sedie.
2. **C1 — cap sul rischio aperto simultaneo al 3,25%** (= 5 SL vivi da 0,65%):
   somma su **tutte** le posizioni del conto, qualunque magic
   (`ABTG_Guardian.mq5` rr.376-378 e r.789).

👉 **Con una sedia sola in campo, il C1 non morderebbe mai** (0,65% contro
3,25%: servono 5 sedie). Con il terzetto proposto (1,95%) nemmeno. 🔴 **Ma
schierare senza Guardian vuol dire che il cap non esiste il giorno in cui le
sedie diventano cinque — e non lo scopriremmo da nessun log, perché la guardia
in fail-open è MUTA.**

---

# 3. 📏 IL CONTRATTO DELLA SEDIA

Il criterio d'uscita del 18/08 pretende un contratto: **DD promesso** e
**frequenza promessa**. Verdetto: 🟢 **il contratto ESISTE e la sedia ce l'ha** —
è l'unica cosa del progetto riprodotta **tre volte al centesimo** — 🔴 **ma ha
due asterischi, e uno è la taglia a cui girerebbe.**

## 3.1 ✅ IL DD PROMESSO — **c'è, con file e riga**

**`7,8323%` a rischio 1,0%, deposito 100.000, tick reali, finestra OOS
2025.06.10 → 2026.06.30.** **[MISURATO]**

Letto da me in questo giro, riga per riga:
`backtest_pipeline/risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_OOS_r31.csv`,
**righe 2 e 3** (colonne `Profit Factor` `1.52365` · `Equity DD %` `7.8323` ·
`Trades` `517`); e l'IS nel gemello `..._IS_r31.csv` (`1.20110` · `5.7325` ·
`237`). Riprodotto da R31 (12/08), R110 e R112 (26/08).
Il conflitto fra le tre misure di casa (6,48% · 7,21% · 7,83%) **è chiuso e
attribuito**: descrivono tre configurazioni diverse (OHLC vs tick · 10k vs 100k ·
finestra piena vs OOS) — `report/A3_IL_DD_DELLA_771531_2026-09-12.md` §1.

🔴 **L'asterisco: il DD a 0,65% — la taglia della challenge — NON è misurato.**
Il 5,09% che circola è `7,8323 / 1,538`, **metro lineare per convenzione di
casa**, e la riconciliazione R29↔R112 dimostra che **sbaglia del 6%**
(`PIANO_PROP.md` r.782 lo marca **[APPROSSIMATO]**). → ostacolo **#9**.

## 3.2 🆕 L'`n` IN POSIZIONI — misurato, e il numero che mancava ce l'ho trovato

> ## 🎯 **L'IS di `771531` ha 132 POSIZIONI. `[MISURATO]`, e verificato da me su cinque notti indipendenti.**

Non è una stima e non è l'ennesima citazione: l'ho contato sulla catena che gira.
`cemad02` (file prova `COLLAUDO_EMADOW_02_pertrade_IS.txt`, magic **766620/766621**)
scrive il per-trade, e `CODA_12` conta i `position_id` distinti:

| notte | file | deal | **posizioni** |
|---|---|---:|---:|
| 13/09 | `abtg_trades_ABTG_EMA200_U30USD_766620/766621.csv` | 237 | **132** |
| 14/09 | idem | 237 | **132** |
| 15/09 | idem | 237 | **132** |
| 16/09 | idem | 237 | **132** |
| 17/09 | idem (ore 07:40:05/06) | 237 | **132** |

Fonte: `backtest_pipeline/coda/referti/CODA_12_pertrade_posizioni_202609{13..17}_*.log`,
righe della sezione `abtg_trades_ABTG_EMA200_U30USD`. I file sono **riscritti ogni
notte** (l'ora cambia), quindi sono **cinque misure**, non una rilettura.

### 🧪 IL CONTRO-ESEMPIO, costruito prima di consegnare il numero
Se la corsa avesse girato **un'altra finestra**, il conteggio non vorrebbe dire
niente. Il file prova aveva messo una **sentinella dichiarata prima**: *"237 deal,
tolleranza ±2% (232-242)"*. Misurato: **237 deal esatti**, cinque notti su cinque.
👉 La finestra girata **è** l'IS di R112.
🔴 **E dichiaro il limite**: le altre due gambe della sentinella (PF 1,20110 ±0,05
e DD 5,7325%) **non le posso verificare io** — il CSV di riepilogo `_OOS_cemad02`
sta in repo ma il round chiude a `uscita 2` per costruzione. Quelle due restano
**verificate da un'altra lettura** (`LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.76:
*"+4.585,40 · PF 1,20110 · DD 5,7325% · 237 deal"*) e per la regola di stasera
(**classe 408**) **non me le attacco addosso**: il numero mio è **132 posizioni su
237 deal**, e basta quello.

### 📊 Il quadro completo dell'`n`
| finestra | deal | posizioni | pavimento 150 |
|---|---:|---:|:---:|
| **IS** 2024.09.26 → 2025.06.09 | 237 | **132** | 🔴 **sotto (−12%)** |
| **OOS** 2025.06.10 → 2026.06.30 | 517 | **257** | 🟢 **sopra (+71%)** |

⚠️ **Il rapporto deal/posizione NON è lo stesso nelle due finestre**: **1,7955**
in IS, **2,0117** in OOS. Chi converte l'IS col 2,0117 ottiene 117,8 e sbaglia.

🔎 **E una cosa che vale la pena dire, perché apre una porta invece di chiuderla**:
132 + 257 = **389 posizioni** totali sulla finestra intera. Un taglio IS/OOS
**più tardo** darebbe due finestre entrambe sopra 150 (`[INFERITO]` — è aritmetica
sui due numeri misurati, non una misura). 🔴 **Ma costa una corsa e il PF OOS di
1,52365 cambierebbe**: non è gratis, ed è il ramo (b) dell'ostacolo **#7**.

## 3.3 🔴 LA FREQUENZA PROMESSA — c'è, ed è SOTTO il pavimento di famiglia

**`0,945` posizioni per giorno feriale.** **[MISURATO]** — è `257 / 272`, e il
conto è stato riquadrato al centesimo contro i P/L veri
(`EMA200_DOW_COSA_MANCA_2026-09-12.md` §2, tabella del contro-esempio).
In **uscite** fa `517 / 272 = 1,901`.

### ⚖️ E i due numeri di casa che sembravano litigare — attribuiti, non nascosti
`CENSIMENTO_CONTRATTI_v2.md` r.312 scrive **~0,77 op/g in posizioni**; il referto
del 12/09 scrive **0,945**. Non sono due stime della stessa cosa:

| numero | come nasce | che cosa descrive |
|---|---|---|
| **0,945** | conteggio diretto: 257 `position_id` / 272 giorni feriali | 🎯 **la sedia a deposito 100.000** = quella pianificata per la challenge. **[MISURATO]** |
| **0,77** | `1,55 uscite/g` (che è il ritmo di **R29, deposito 10.000**) diviso `2,0117` (che è il fattore di **R112, deposito 100.000**) | 🔴 un **ibrido di due configurazioni** → **[INFERITO]**, non una seconda misura |

👉 **Si risolve esattamente come il conflitto sul DD: il deposito è parte della
configurazione** (a 10k il `MathFloor` taglia il lotto e cambia perfino l'insieme
dei trade: `n` 444 contro 517). **Il numero della sedia pianificata è 0,945.**
🟢 E il verdetto non dipende dalla scelta: **entrambi stanno sotto 1,00.**

### 🔴 Il pavimento è di FAMIGLIA, e la famiglia ha un simbolo solo
Il pavimento firmato il 07/09 è **1,00 op/giorno per FAMIGLIA** (motore × simboli
schierabili). La famiglia `EMA200` degli **schierabili in prop** è **una sedia
sola**: `0,945`, **sotto**. L'unico gemello che la porterebbe a 1,245 è `971501`
EMA200_Ott XAUUSD, e su quello il verbale del **23/08** dice
**«prop: NO a nessuna taglia»** (DD 45,91%) — `CENSIMENTO_CONTRATTI.md` r.231.
⚠️ E quel 1,245 **somma posizioni con deal**: non è omogeneo.

🔴 **Non è riparabile misurando**: sui quattro indici azionari gemelli il motore
fa **6 celle positive su 330** (D30EUR 0/80 · E50EUR 0/83 · F40EUR 0/81 ·
NASUSD 2/83 · SPXUSD 4/86) contro **98/98 sul Dow**. → ostacolo **#8**.

## 3.4 📜 Verdetto sul contratto
> 🟢 **La sedia HA un contratto, e il criterio d'uscita del 18/08 PUÒ funzionare su
> di lei**: la corsia RISCHIO ha un numero (DD 7,8323% @1%) e la corsia TAGLIANDO
> ha un numero (0,945 pos/g).
> 🔴 **Con due asterischi**: (1) il DD **alla taglia a cui girerebbe** (0,65%) è
> approssimato, e un contratto approssimato fa scattare — o non scattare — una
> revisione per il motivo sbagliato; (2) **il contratto scritto in
> `CENSIMENTO_CONTRATTI.md` r.230 è ANCORA quello vecchio** (7,21% · n 444). Il v1
> porta il cartello rosso *"non è più il documento vivo"*, e il v2 ha il numero
> giusto: **non è un ostacolo, è una trappola per chi legge il file sbagliato.**

---

# 4. 💰 IL CANCELLO DI COSTO — la riga c'è, e il tag è **[MIS]**

## 4.1 La riga richiesta, testuale
`report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.401**:

> `| **771531** | EMA200 | U30USD | H1 | 🔵 | InpSLatr 1.0 × ATR(14) oltre il 2° ordine (InpOrder2Atr 0.35) — r.68/74 | **104,3 idx** [MIS] n=8 | trades_auto.csv (65,5-147,0) | **1,90** (ora 17) | **54,9x** | 🟢 **SI (+37%)** | 🟢 SI |`

✅ **Lo stop NON è `[NM]`: è `[MIS]`.** Quindi **non entra nella lista degli
ostacoli** come misura mancante.

## 4.2 🔴 Ma ci sono DUE numeri di casa, e vanno scritti entrambi

| fonte | popolazione | stop | rapporto stop/spread | verdetto |
|---|---|---:|---:|---|
| `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.401 | **8 gambe VIVE** (`trades_auto.csv`, 65,5-147,0) | **104,3 idx** [MIS] | **54,9×** | 🟢 PASS **+37%** |
| `EMA200_DOW_COSA_MANCA_2026-09-12.md` §4 | **33 coppie** sulla finestra di backtest, **per gamba** | gamba 1 **132,6** · gamba 2 **88,2** [MIS] | g1 **55,6×** · g2 **37,1×** (in sessione 14-21: **62,7×** e **41,8×**; di notte **49,5×** e **33,2×**) | 🟠 **PASS alla lettera dei criteri congelati, FRAGILE di notte** |

🟢 **I due non si contraddicono, e la prova è che stanno nell'ordine giusto**:
il 104,3 è un **aggregato delle due gambe** e cade **fra** 88,2 e 132,6. Sono due
popolazioni diverse (8 eventi di campo contro 33 coppie di banco), non due stime
della stessa grandezza.
🔴 **Ma il VERDETTO cambia a seconda di quale si usa**, e va detto: il
**+37% di margine** della tabella del 10/09 **non è confermato gamba per gamba**.
Il numero che morde è la **gamba 2 a 37,1× di mediana piena** e **33,2% di notte**,
dove cade il **26,0%** degli stop pieni.

## 4.3 ✏️ Un dettaglio di fonte che correggo, e non cambia il verdetto
La r.401 descrive la geometria come `InpOrder2Atr 0.35`: quello è il **default
compilato** (`ABTG_EMA200.mq5` r.69). La **cella promossa e il preset vivo** hanno
**`InpOrder2Atr=0.3`** (`..._OOS_r31.csv` colonna `InpOrder2Atr` = `0.3`;
`..._771531_VIVA.set` r.66). 🟢 **Effetto sulla gamba 2: zero** — il suo stop è
`InpSLatr × ATR = 1,00 ATR` e non dipende da `Order2Atr`. Sulla gamba 1
l'effetto è `1,50 ATR` invece di `1,45 ATR`, cioè **+3%** a favore della sedia.

## 4.4 🔧 E la riparazione esiste già nel codice, senza toccare la geometria
`InpMaxSpread` (oggi **0 = filtro spento**, `..._VIVA.set` r.92) taglia le ore
larghe. ⚠️ Limite dichiarato: `SpreadOK()` è chiamata al **r.325** (definita al r.507), cioè al
**segnale** → filtra l'**ingresso**, non l'**uscita**, e lo stop lo si paga in
uscita. È una riparazione **parziale per costruzione**. Il file prova esiste
(`COLLAUDO_EMADOW_00_manopola_maxspread.txt`) e **non è in coda**.

---

# 5. 🧾 IL CERTIFICATO, RILETTO STASERA SUI CSV GREZZI (non sulle citazioni)

Ho aperto io i CSV in `backtest_pipeline/risultati_prove/dal_vps/ABTG_EMA200/`.
**Questi numeri sono miei.** **[MISURATO]**

| req. | esito | il numero |
|---|---|---|
| **1 PF** | ✅ | OOS **1,52365** · IS **1,20110** (`_r31.csv` r.2) |
| **2 n e DD** | 🟠 **misurato, e uno dei due è sotto** | DD OOS **7,8323%** · IS **5,7325%** · posizioni OOS **257** ✅ · IS **132** 🔴 (§3.2) |
| **3 uscita ad asse** | 🟢 **CHIUSO** | vedi sotto |
| **4 simboli gemelli** | ✅ | fatto, e la risposta è che **l'edge sta su un simbolo solo** (§3.3) |
| **5 TF cambiato** | 🟢 **CHIUSO** | `cemad05`, vedi sotto |

## 5.1 Requisito 3 — le quattro manopole d'uscita, lette da me

| asse (file) | cella viva | cosa dice la superficie | verdetto mio |
|---|---|---|---|
| **`InpSLatr`** (`r136a`, 7 celle 0,4→1,6) | **1,0** | PF OOS: 1,264 / 1,521 / **1,612** / 1,524 / 1,462 / 1,595 / 1,458 — **7 celle su 7 positive in ENTRAMBE le finestre**; IS da 1,072 a 1,255 | 🟢 **ALTOPIANO vero.** La cella viva **non è il picco** (il picco OOS è a 0,8) → **regola di casa rispettata** |
| **`InpTP1_ATRmult`** (`r136b`) | **0,00** (TP1 sulla EMA14) | 🔴 **in IS la cella viva è l'UNICA sopra 1,05**: 1,201 contro 0,900 / 0,994 / 0,869 / 1,014 / 0,837 / 0,762 | 🟠 **la scelta viva è GIUSTIFICATA ma è un PUNTO, non un altopiano.** ✏️ Questo **corregge** la lettura del 13/09 (*"altopiano 0,25-0,75"*): quello si legge **solo in OOS**; in IS quelle tre celle stanno **attorno a 1,00**, cioè sono una zona morta |
| **`InpTP1Pct`** (`r136c`) | **50** | 25 / 50 / 75 danno IS 1,200/1,201/1,200 e OOS 1,518/1,524/1,526 — **piatto**; a **0** (parziale spento) IS **0,935** e **DD OOS 13,94%**, cioè **sfonda il muro del 10%** | 🟢 **ALTOPIANO col centro = cella viva.** E dice una cosa forte: **il parziale al 50% è ciò che tiene il DD sotto il muro** |
| **`InpUseTrailing`** (`r136d`) | **true** | trailing **OFF** fa **meglio in OOS** (PF **1,771** vs 1,524 e DD **7,415%** vs 7,832%) e **peggio in IS** (1,107 vs 1,201), con n 427 vs 517 | 🟠 **il segno si INVERTE fra le finestre** → **[NON MISURATO]** come miglioramento. 🔓 **Ma è una porta aperta, non una bocciatura**: un PF 1,77 con DD più basso merita una misura in più, non l'archivio |

## 5.2 Requisito 5 — il TF, e H1 vince col numero

| `InpTF` | PF IS | PF OOS | DD OOS | n OOS |
|---|---:|---:|---:|---:|
| **H1 (16385) — viva** | **1,20110** | 🥇 **1,52365** | 7,83% | 517 |
| M15 (15) | 0,771 | 0,954 | 🔴 **26,34%** | 2020 |
| M20 (20) | 1,117 | 0,833 | 🔴 **30,71%** | 1642 |
| M30 (30) | 1,034 | 0,907 | 🔴 **15,87%** | 1268 |
| H2 (16386) | 2,599 | 1,173 | 6,12% | 266 |
| H3 (16387) | 2,152 | 0,908 | 9,00% | 170 |
| H4 (16388) | 1,660 | 1,425 | 4,45% | 116 |

🟢 **Requisito 5 CHIUSO, e H1 è la scelta giusta**: i TF bassi sfondano il muro
del 10% di DD con PF sotto 1 in OOS (**esattamente la frontiera del costo**), e
H2/H3/H4 pagano in **frequenza** (116-266 posizioni contro 517).

---

# 6. 🚦 COSA QUESTO REFERTO **NON** FA — dichiarato

- ❌ Non archivia niente. **Nessun certificato di morte.**
- ❌ Non propone taglie, parametri di rischio, né l'acquisto di niente.
- ❌ Non scrive nessuna riga di lancio: le due che servono (ostacoli **#1** e
  **#2**) vanno preparate e **passare dal doppio cancello** prima di uscire.
- ❌ Non ha toccato il conto reale `10105439`, nessun terminale, nessun preset.
- ⚠️ **Non ha verificato la compilazione VERA su un MetaEditor**: la prova che
  `HEAD` compila è **indiretta ma misurata** (l'`.ex5` del 16/09 sul banco + sei
  round a uscita 0 su quel binario). Un F7 su una macchina diversa resta un F7.

---

# 7. 🎯 LA CHIUSURA, in ordine di quanto avvicina la sedia al campo

1. **(F) #5 — quale prop e quale taglia.** 🔴 Senza il conto, tutto il resto
   porta la sedia **in campo sul demo**, non nella challenge. È l'unica cosa che
   nessun agente può fare e che non ha alternative.
2. **(A) #2 — la riga di `carica_risultati.ps1`.** Costo: minuti di rete, **zero
   macchina**. Porta a casa `r146b` e `r147a` di questa sedia più altri 45 round.
   👉 **È la cosa a rapporto valore/costo più alto della lista, e la prepariamo noi.**
3. **(F) #4 + (A) #1 — firma della taglia 0,65% e F7.** Il preset esiste, il
   binario compila, il runbook mette questa sedia **prima**.
4. **(M) #9 — il DD misurato a 0,65%.** ~1 minuto di tester. Trasforma l'ultimo
   `[APPROSSIMATO]` del contratto in un `[MISURATO]`.
5. **(F) #7 e #8 — le due dichiarazioni di criterio** (IS a 132 posizioni ·
   famiglia a 0,945 op/g). Non costano macchina: costano una decisione, e
   **vanno prese prima di premere «inizia», non dopo.**

> ## 🔥 E la nota di metodo, perché è la lezione della serata
> Questa sedia era descritta come *"ferma per due requisiti mai misurati"*.
> **I due requisiti erano già chiusi da quattro giorni**, e il numero che mancava
> di più — **l'IS in posizioni** — stava **in un log del repo dal 13/09**,
> riprodotto **cinque notti di fila**, senza che nessuno lo leggesse.
> 🔴 **Non ci siamo accontentati, e il risultato è che oggi la lista degli
> ostacoli ha la colonna (C) VUOTA.** Non manca una riga di codice. Manca un
> conto, tre gesti e cinque firme.
