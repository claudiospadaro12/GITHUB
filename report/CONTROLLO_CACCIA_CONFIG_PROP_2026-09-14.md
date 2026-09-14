# 🕵️ CONTROLLO CACCIA — dossier `CACCIA_CONFIG_PROP_2026-09-13.md`

> Primo audit reale del metodo `controllo-caccia` (nato 14/09/2026 su richiesta
> di Claudio: *"voglio sapere se sono bravi, se setacciano bene, se vanno sui
> siti giusti"*). Oggetto: il dossier di `cacciatore-config-prop` del 13/09.
> **Non ho toccato forward, conto reale 10105439, né proposto candidati nuovi.**

---

## 🎯 LA RIGA CHE CONTA

**Ho riaperto 15 fonti esterne + tutte le citazioni di codice interno del
dossier: ZERO allucinazioni, ZERO numeri inventati, ZERO setacci mancati.**
Ho scaricato e decompresso io stesso 9 sorgenti `.mq5` dal Code Base MQL5
(non solo la pagina-riassunto: il file vero), letto in HTML grezzo 3 articoli,
riletto i 5 `.set` locali, e riverificato riga-per-riga 4 file del repo
(`ABTG_Guardian.mq5`, `ABTG_EMA200.mq5`, `ABTG_BreakinBox.mq5`,
`ABTG_TradeExporter.mq5`). **Ogni singolo numero, nome di autore, data e
numero di riga citato nel dossier è quello vero.** Compreso l'unico punto
dove il rischio di allucinazione era più alto — F6, il candidato "flagship"
del 3,0% — verificato fino alla riga di codice (`input double
InpMaxBasketRiskPercent = 3.0;`, riga 44 del file scaricato oggi).

🔴 **Ma ho trovato due buchi di COPERTURA non dichiarati** (un canale del
mandato mai girato, uno girato solo con materiale riciclato) **e un errore
di CONTEGGIO minore** (sotto-conta di un donatore in casa). Nessuno dei tre
invalida le proposte P1-P7. Dettaglio sotto.

---

## 1. 📋 COPERTURA DELLE FONTI PREVISTE DAL MANDATO

| fonte (dal mandato `cacciatore-config-prop.md`) | stato dichiarato dal dossier | verifica mia |
|---|---|---|
| **A. Siti UFFICIALI delle prop** (FTMO, FundedNext, The5ers, E8, ecc.) | girata, **bloccata**: 22/22 domini `000`/EGRESS_BLOCKED | 🟢 **riprodotto io stesso**: 6 domini campione (ftmo.com, the5ers.com, fundingpips.com, topstep.com, myfundedfx.com, forexpropreviews.com) → **6/6 stesso esito** (`connect_rejected`, policy). Blocco vero, non scusa. |
| **B. Shop/Market — EA prop in vendita** | **NON dichiarata come non girata** — presentata mescolata a F13-F15 | 🔴 **BUCO NON DICHIARATO.** F13/F14/F15 sono `.set` **riciclati** dal 18/08 e 23/08 (onestamente etichettati "riletto oggi" nella legenda), ma **nessuna pagina prodotto MQL5 Market è stata aperta oggi**: zero prezzo, zero "Scheda PRODOTTO" come richiede il mandato §5/§6.1. Il dossier lo dice tecnicamente (legenda `[SET LETTO]`) ma non lo dice come **assenza della fonte B di oggi** — va detto più chiaro. |
| **C. GitHub** (guardiani open source) | girata, **bloccata**: `github.com/search` 403, API repo-scoped, `gh` non installato | 🟢 **riprodotto io stesso, identico**: 403 su search, stesso messaggio testuale dell'API ("sessions are bound to their configured repositories"), `gh: command not found`. 🟡 **MA**: il controllo positivo su `raw.githubusercontent.com` è passato (200, 6034 byte, riprodotto anch'esso identico) e **non è mai stato usato** per pescare un repo guardian NOTO per nome/percorso invece che via search — un fallback possibile, non tentato, non dichiarato come tentativo mancato. |
| **D. Forex Factory / forum** (thread "settings/challenge passed") | **ASSENTE — zero menzioni** nel file | 🔴 **BUCO VERO, NON DICHIARATO.** Ho grep-ato il file intero per "forum", "thread", "forex factory": zero risultati. È una delle **quattro fonti in ordine di resa** del §4 del mandato ("PRIMA DI TUTTO: gli esempi copiabili") e non risulta né girata, né girata-e-vuota, né dichiarata non girata. È esattamente il tipo di assenza che il mio stesso mandato mi chiede di scovare. |
| **E. Blog/Academy delle prop** | girata, bloccata (`academy.ftmo.com` nei 22) | 🟢 coerente col blocco A |
| **MQL5 Code Base + Articoli** (canale non nel mandato originale, usato come sostituto dopo il blocco GitHub) | girata con risultati, 12 fonti | 🟢 **verificata al 100%** (vedi §2). Sostituzione ragionevole e dichiarata (§1 del dossier), coerente con la lezione già in casa (`SETACCIO_MANUALE.md`: "il Code Base si apre per gli ATTREZZI, non per i motori" — qui servivano attrezzi di rischio, uso corretto del canale) |

**Verdetto copertura**: 3 fonti su 5 del mandato sono state effettivamente
bloccate e dichiarate (A, C, E) — bene. **1 fonte (D, forum) è un buco
silenzioso.** **1 fonte (B, shop pagati) è girata solo a metà e con materiale
vecchio, senza dirlo esplicitamente come tale.**

---

## 2. 🔬 LA RIAPERTURA — candidato per candidato

**Campione: TUTTI i 12 candidati citati come FONTE in almeno una proposta
(P1-P7) + i 3 rimasti (F3, F7, F9) = 15/15, il 100% delle fonti in tabella.**
Per ognuno ho scaricato lo ZIP vero da `mql5.com/en/code/download/<id>` (o
letto l'HTML grezzo per gli articoli) e ho `grep`-ato il sorgente.

| # | candidato | autore/data dossier | **verifica reale (scaricata da me)** | esito |
|---|---|---|---|---|
| F1 | PropFirmGuard (76767) | GermanAndresSoto · 02/09 | `InpDailyLossPct=5.0` `InpTotalDdPct=10.0` `InpBufferPct=0.5` `InpResetHour=0` — **esatti, riga per riga** (`PropFirmGuardEA.mq5` r.18-21). Autore reale "German Andres Soto Castro" | ✅ **CONFERMATO** |
| F2 | ASQ RiskGuard (71120) | Robin2.0 · 28/03 | Tutti gli 8 input **esatti** (r.56,64,81,86-88,96,115), **1063 righe esatte**, sessione 08:00-20:00 e spread guard 30pt confermati (r.70-76) | ✅ **CONFERMATO** |
| F3 | Equity Guard (73870) | KairosLab · 29/06 | `InpLimitPercent=5.0` `InpTriggerPct=80.0` `InpBaseMode=BASE_BALANCE` `InpResetHour/Min=0/0` `InpEnforceFlat=true` — esatti (r.46-57) | ✅ **CONFERMATO** |
| F4 | Trade Guardian (76947) | PetrKostal · 04/09 | Tutti i 7 input esatti (r.26-39): `InpATR_Mult=3.0` `InpMinStopPoints=100` `InpCooldownHours=168` `InpCloseOnBreach=false` | ✅ **CONFERMATO** |
| F5 | Quantora DD Monitor (75794) | Quantora · 07/08 | `InpLowMaxPct=2.0` `InpModerateMaxPct=5.0` `InpHighMaxPct=10.0` `InpCountAllPositions=true`; `g_daily_pl_total=g_daily_closed_pl+g_floating` **esatto carattere per carattere** | ✅ **CONFERMATO** |
| F6 | Correlation-Aware Lot Size (77032) | RanaAli878 · 06/09 | **Il candidato più delicato** (regge il "3,0% da 3 autori"): `InpMaxBasketRiskPercent=3.0` `InpCorrelationThreshold=0.70` `InpCorrelationBars=100` `PERIOD_H1` — esatti (r.42-47). "Pearson correlation of bar-to-bar returns" **letterale nel commento r.15-16 e r.82**. Hedge naturale escluso: righe COMPOUNDS RISK / NATURAL HEDGE **trovate identiche** (r.269-280) | ✅ **CONFERMATO — al 100%, fino al bit** |
| F7 | RiskPilot Pro (77090) | RanaAli878 · 07/09 | `InpRiskPercent=1.0` `InpATRMultiplier=1.5` `InpDailyLossLimitPercent=5.0` `InpMaxDrawdownPercent=10.0` `InpMaxBasketRiskPercent=3.0`; "high watermark del BALANCE" confermato (`g_balanceHighWater=AccountInfoDouble(ACCOUNT_BALANCE)`) | ✅ **CONFERMATO** — e confermo pure l'autocorrezione del dossier: F6 e F7 sono davvero lo stesso autore |
| F8 | Prop Firm Rule Checker (76955) | RanaAli878 · 06/09 | `InpProfitTargetPercent=8.0` `InpMaxDailyLossPercent=5.0` `InpMaxTotalDDPercent=10.0` `InpMaxSingleDayPercent=30.0` `InpMinTradingDays=5` esatti; aggregazione per giorno di calendario **su soli deal chiusi confermata nel codice** (loop `HistoryDealGetTicket`, `dayKey`) | ✅ **CONFERMATO** |
| F9 | Server Clock/Reset Hour (76288) | sabari.kalathur · 18/08 | `ResetZone=ZONE_NEW_YORK` `ResetHour=17` `AutoDetectServerOffset=true`; offset NY(-300/-240), London(0/+60), Frankfurt(+60/+120) **tutti esatti** | ✅ **CONFERMATO** |
| F10 | Articolo 24331 — Basket Risk | Solomon A. Sunday · 11/09 | `MaxBasketPositions=1` `MaxBasketLossPercent=3.0` `MaxBasketMarginPercent=25.0` `MaxBasketHoldBars=0` esatti. **Il contro-esempio del dossier (§3) è verificato vero**: `MaxImpliedRiskPercent`/`MaxBasketImpliedRiskPercent` **non sono input numerici dichiarati**, solo testo/corpo — confermato indipendentemente | ✅ **CONFERMATO, incluso l'autocorrezione** |
| F11 | Articolo 23374 — Correlation Monitor | eugenioguilarte · 24/07 | `AlertHiddenFactor=130` `AlertRiskPctEquity=3.0` `AlertTopSharePct=50` `CorrLookbackBars=200` `VaRConfidenceZ=1.645` `CheckSeconds=15` `CooldownMinutes=60` — **tutti esatti** | ✅ **CONFERMATO** |
| F12 | Articolo 20587 — Risk Enforcement EA | billionaire2024 · 16/12/2025 | `InpCountFloatingPL=true` con commento letterale `// Include open position P/L in limits` — **citazione verbatim confermata**. `InpDailyLossLimit=-300` `InpWeeklyLossLimit=-1000` `InpMonthlyLossLimit=-5000` esatti | ✅ **CONFERMATO** |
| F13 | GoldTradePro V4.0 prop-firm (.set locale) | vendor · 23/08 | `MaxRiskPerStrategy=1.00`, scala low/med/high = 1.5/3.0/6.0 **esatta**, `PropFirmMaxDailyDD=4.00` | ✅ **CONFERMATO** (file locale riletto) |
| F14 | TheGoldReaper propfirm (.set locale) | vendor · 18/08 | `PropFirmMaxDailyDD=4.00` `MaxAllowedDD=9.00` esatti | ✅ **CONFERMATO** |
| F15 | TheImpossibleProp v2.0 (.set locale) | vendor · 18/08 | `MaxOpenTrades=1` `MaxTradesPerDay=10` `ShieldDrawdownPct=3.0` `PropDailyDD=5.0` `PropMaxDD=10.0` confermati. 🟡 **1 imprecisione**: `RiskPerTrade` nei file v2.0 è **0.5** (non 0.75); lo **0,75** appartiene alla v1.1 (stesso EA, versione precedente), citata nel dossier sotto lo stesso F15 come se venisse dal path "v2.0-*". Valore vero, fonte incollata in modo un po' impreciso | 🟡 **IMPRECISO** (dettaglio non regge, il grosso sì) |

**Setaccio (martingala/griglia/no-SL/repaint/DLL/lotto fisso), riapplicato da
zero su tutti i sorgenti scaricati**: `grep` mirato su `#import`/DLL → **zero
in tutti i 9 file**; su martingala/griglia/lot-multiplier → **zero**; i due
tool che aprono ordini (F3 "Panic Panel", F7 "drag-to-trade") lo fanno **solo
via pulsante/mouse** (`OnChartEvent`), mai da segnale automatico. **Nessuna
bandiera rossa persa dal cacciatore.**

**Citazioni di codice INTERNO (repo nostro)** — riverificate riga per riga:
`ABTG_Guardian.mq5` r.152 (`InpDailyPausePct`), r.153 (`InpMaxOpenRiskPct`),
r.155 (`InpWarnNoSL`), r.165-166 (`InpMaxClusterRiskPct`/`InpClusterMappa`),
r.471-472 (`ClusterTetto`), r.631 (cancello) → **tutte esatte, fino al numero
di riga**. `ABTG_EMA200.mq5` r.622 → header CSV **senza** `open_time`,
confermato. `ABTG_BreakinBox.mq5` r.1147-1163/1187/1205 → **esatte**.
`ABTG_TradeExporter.mq5` r.177 → **esatta**.

---

## 3. 🔴 L'UNICO ERRORE DI SOSTANZA TROVATO

**Il conteggio dei "donatori in casa" per `open_time` è sotto-contato.**

Il dossier scrive: *"il codice che lo scrive esiste già in DUE nostri EA
(`ABTG_BreakinBox.mq5`, `ABTG_NySessionRetest.mq5`) più un esportatore
dedicato"*. Ho grep-ato **tutti** i 113 file in `mql5/Experts/*.mq5` per
`open_time` in un vero header CSV: c'è un **TERZO EA**, `ABTG_DaxReEntry.mq5`
(r.919: `FileWrite(h,"close_time","open_time",...)`), non citato.

- Non è un'allucinazione (nessun numero inventato), è un **sotto-conteggio**.
- **Non invalida P1** — anzi lo rafforza: il meccanismo ha ancora più
  precedenti in casa di quanto scritto.
- Ma "46 EA su 48 non lo scrivono" andrebbe corretto in **45 su 48**, e la
  lista dei donatori in **tre**, non due.

*(Nota a margine, non un difetto: ho anche trovato due falsi allarmi nel mio
stesso grep — `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5` ha una
variabile chiamata `open_time` in un log MFE scollegato dall'export trade, e
`ABTG_SondaLondonFx.mq5` cita "open_time" solo per DIRE che non lo ha. Nessuno
dei due è un donatore vero — il dossier non li cita e ha ragione a non citarli.)*

---

## 4. 📐 FORMATO E PROPORZIONE

- **Sezioni richieste dal mandato**: controllo positivo ✅, tabella esempi ✅,
  confronto coi nostri numeri ✅ (fa da "tabella dei buchi"), buchi dichiarati
  ✅, proposte separate nel formato PROPOSTA/DOVE/FONTE/COSTO/RISCHIO ✅
  identico al template del mandato. **Manca**: la "Scheda PRODOTTO" per
  fonte, richiesta esplicitamente al §5/§6.1 del mandato per gli EA da shop
  — non è mai comparsa (coerente col buco di copertura B sopra).
- **Proporzione candidati-visti/promossi**: 15 fonti in tabella + 4 viste ma
  non aperte per tempo (dichiarate: 75380, 74240, 71307, 76533) + 1 vista e
  scartata a mano per non gonfiare la tabella (75606, con motivo scritto).
  12 delle 15 alimentano una proposta concreta. **Non è un rapporto sospetto**:
  è alta densità di riuso senza foglie morte, con gli esclusi motivati uno per
  uno — il contrario del "60 link copiati, 1 promosso".
- **Report in chat con la riga d'apertura** richiesta dal mandato del
  cacciatore: non verificabile da questo file da solo (non è nel `.md`, era
  nella consegna in chat che non ho in questa sessione) — non lo marco come
  fail, lo marco come **non verificabile da qui**.

---

## 5. 🧮 PUNTEGGIO DI FIDUCIA

| fonte/gruppo | girata? | esito campione | fiducia |
|---|---|---|---|
| A. Prop ufficiali | girata, bloccata (dichiarato) | riprodotto identico | 🟢 **ALTA** (sulla dichiarazione onesta del blocco) |
| B. Shop/Market pagati | **NON girata oggi**, dati riciclati | — | 🔴 **BASSA — buco non dichiarato come tale** |
| C. GitHub | girata, bloccata (dichiarato) | riprodotto identico, fallback non tentato | 🟡 **MEDIA-ALTA** |
| D. Forum/Forex Factory | **assente, non dichiarata** | — | 🔴 **BASSA — buco silenzioso** |
| E. Blog/Academy prop | girata, bloccata (dichiarato) | coerente con A | 🟢 **ALTA** |
| MQL5 Code Base + Articoli (12 fonti) | girata con risultati | **15/15 confermate**, 1 imprecisione minore, 0 allucinazioni, 0 setacci mancati | 🟢🟢 **ALTISSIMA** |
| Citazioni codice interno (Guardian/EA nostri) | — | **tutte esatte al numero di riga**, 1 sotto-conteggio (non un'invenzione) | 🟢 **ALTA** |

### 🏆 VERDETTO COMPLESSIVO: **FIDUCIA ALTA, CON DUE BUCHI DI PROCESSO DA CHIUDERE**

Sul lavoro che ha fatto — leggere il Code Base MQL5 e gli articoli — questo
cacciatore **è bravo davvero**: la precisione riga-per-riga su 15 fonti
esterne e 4 file di repo, senza uno sbaglio di sostanza, è il livello che
serve per fidarsi di un dossier senza riaprirlo ogni volta. **Il 3,0% di
consenso a tre autori indipendenti (F6/F10/F11) è vero, verificato fino al
bit.** Ma **non è andato dove il suo stesso mandato gli diceva di andare per
due canali su cinque** (forum, shop pagati) — e uno dei due buchi (D) non è
nemmeno stato nominato come assente.

---

## 6. 🔁 COSA RIFAREI IO, se ripetessi questa caccia

1. **Forex Factory**: mai tentato. Anche solo un tentativo bloccato-e-dichiarato
   vale più di un silenzio — lo aprirei o dichiarerei il blocco esplicitamente.
2. **MQL5 Market (shop pagati)**: nessuna pagina prodotto aperta oggi. Anche
   solo 2-3 pagine vendor con Scheda PRODOTTO (prezzo, meccanismi dichiarati,
   "cosa ci portiamo a casa") avrebbero completato la fonte B come il mandato
   la vuole, invece di appoggiarsi solo a `.set` di agosto.
3. **GitHub via `raw.githubusercontent.com`**: il canale RISPONDE (200
   riprodotto anche da me) ma non è mai stato usato per pescare un repo
   guardian noto per nome/percorso dopo che la ricerca è saltata — varrebbe
   un tentativo dichiarato, anche se a vuoto.
4. **Correggere "46 EA su 48" in "45 su 48"** e aggiungere `ABTG_DaxReEntry.mq5`
   alla lista dei donatori di `open_time` in P1.
5. **F15**: allineare la fonte del valore 0,75 alla v1.1 (non v2.0), o citare
   entrambe le versioni esplicitamente invece di un unico path con wildcard.

**Le proposte P1-P7 restano tutte in piedi**: nessuno dei 3 rilievi tocca il
merito di una singola proposta — toccano solo la copertura del giro e un
conteggio interno. 🎯 Nessuna decisione di Claudio va cambiata su questa base;
i due buchi (D e B) sono da chiudere alla **prossima** caccia, non da rifare
su questa.
