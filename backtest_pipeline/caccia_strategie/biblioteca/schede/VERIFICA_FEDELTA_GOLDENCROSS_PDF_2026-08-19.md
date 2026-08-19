# 🔬 VERIFICA DI FEDELTÀ — `ABTG_GoldenCross.mq5` contro il PDF "GOLDEN CROSS HA Strategy"

**Data:** 19/08/2026 · **Fonte normativa:** PDF ufficiale Masterclass ABTG
"GOLDEN CROSS HA Strategy", v1.0 del 01/07/2026 (EMA 9/21/50 + Heiken Ashi +
ADX/DI), **letto per intero da Claudio e trascritto regola per regola nella
consegna di questa missione**.
**Oggetto misurato:** `mql5/Experts/ABTG_GoldenCross.mq5` (783 righe, letto per
intero).

> ⚠️ **DICHIARAZIONE DI FONTE — leggila prima dei numeri.**
> Io **non ho avuto il PDF sotto gli occhi**. Ho lavorato sulla trascrizione
> delle regole fatta da Claudio. Ogni riga di questa tabella misura il codice
> contro **quella trascrizione**, non contro il documento originale. Se la
> trascrizione ha omesso o riassunto una regola, questo referto eredita
> l'omissione. **Il codice invece l'ho letto io, riga per riga: le citazioni di
> riga sono verificate.**
>
> 🔒 **Nessun `.mq5` è stato toccato.** Qui si misura e si propone. Le proposte
> della PARTE 3 sono **da implementare in un secondo momento**, opt-in e con
> default spento, una alla volta.

---

# PARTE 1 — 🎯 IL VERDETTO

## 1.1 Il numero

# **FEDELE 36/78**

**78 regole misurabili** estratte dal PDF (la 16ª del cap.12 — _"trader
emotivamente alterato"_ — è esclusa perché non meccanizzabile per definizione).

| esito | conteggio | quota |
|---|---|---|
| ✅ **FEDELE** | **36** | 46% |
| ⚠️ **DIVERGENTE** | **9** | 12% |
| 🔓 **PIÙ LARGO** (l'EA entra dove il PDF dice di non entrare) | **7** | 9% |
| 🔒 **PIÙ RIGIDO** (l'EA rinuncia a setup che il PDF ammette) | **1** | 1% |
| ⛔ **ASSENTE** | **25** | 32% |

**Sul solo perimetro meccanizzabile: 36/73 (49%).** Cinque delle 25 assenze
(spazio tecnico a resistenza, target tecnici S/R, uscita su resistenza
importante, "movimento già su S/R", "mercato senza liquidità") richiedono un
concetto — livelli e liquidità — che **l'EA non possiede in nessuna forma**.
Vedi PARTE 4.

> ⚠️ **Avvertenza sul conteggio, obbligatoria.** Il PDF è **ridondante per
> costruzione**: la checklist a 15 punti è l'espansione della sequenza a 6 fasi,
> e le 16 regole di non-ingresso del cap.12 sono in buona parte le stesse regole
> girate al negativo. **Un singolo difetto del codice viene quindi contato più
> volte.** Esempio concreto: la tolleranza sul corpo HA in riduzione pesa 3
> volte (fase 4, checklist 8, non-ingresso 8). Il 46% è una **misura di
> copertura del documento**, non una probabilità di somiglianza operativa. Il
> conteggio per blocchi (§1.3) è più onesto del totale.

## 1.2 Il verdetto in tre righe

1. **Sulla MECCANICA D'INGRESSO l'EA è molto fedele** (blocchi A/B: 14 fedeli su
   21). Le sei fasi ci sono tutte, nell'ordine, e la gestione a 1R
   (parziale + pareggio + presidio EMA21) riproduce il cap.10 quasi alla
   lettera. Chi l'ha scritto il PDF l'aveva davanti.
2. **Ma la fedeltà crolla su tutto ciò che è CONTESTO E DISCIPLINA**: livelli
   S/R (0 su 5), classificazione A/B/C (0 su 3), fasce orarie (0 su 2), e
   soprattutto **money management del cap.14 (3 fedeli su 9)**. Le regole prop —
   quelle che il PDF mette per ultime e che sono le più facili da codificare —
   sono **il blocco messo peggio di tutti**.
3. **Tre divergenze non sono omissioni ma DIFETTI**: il test dell'incrocio
   guarda una barra sola invece della finestra (§2.1-B3), il contatore delle
   perdite consecutive **viene azzerato dai parziali in profitto** (§3.4), e la
   soglia di distanza dall'EMA9 è **tre volte più larga** di quella "preferibile"
   del cap.9 (§2.4-D3). Le prime due sono bug, non scelte.

## 1.3 Dove l'EA è fedele e dove no — per blocco

| blocco del PDF | voci | ✅ | ⚠️ | 🔓 | 🔒 | ⛔ | fedeltà |
|---|---|---|---|---|---|---|---|
| **A. Sequenza (6 fasi)** | 6 | 3 | 1 | 2 | – | – | 🟡 50% |
| **B. Checklist long (15 punti)** | 15 | 11 | 1 | 2 | – | 1 | 🟢 **73%** |
| **C. Scala ADX** | 5 | 2 | – | – | 1 | 2 | 🟡 40% |
| **D. Ingresso (cap.9)** | 6 | 2 | – | 1 | – | 3 | 🔴 33% |
| **E. Stop / target / gestione (cap.10)** | 9 | 4 | 2 | – | – | 3 | 🟡 44% |
| **F. Uscite (cap.11)** | 6 | 2 | 2 | – | – | 2 | 🔴 33% |
| **G. Non-ingresso (cap.12)** | 15 | 7 | 1 | 2 | – | 5 | 🟡 47% |
| **H. Classificazione A/B/C (cap.13)** | 3 | 0 | – | – | – | 3 | 🔴 **0%** |
| **I. Money management (cap.14)** | 9 | 3 | 2 | – | – | 4 | 🔴 **33%** |
| **J. Timeframe / mercati / fasce (cap.4)** | 4 | 2 | – | – | – | 2 | 🟡 50% |
| **TOTALE** | **78** | **36** | **9** | **7** | **1** | **25** | **46%** |

## 1.4 🚨 LE CINQUE DIVERGENZE PIÙ IMPORTANTI

### ① Il test dell'incrocio EMA9/21 guarda UNA barra, non la finestra — 🐛 difetto

```
riga 363:  bool crossNow  = (ef[0] > em[0]);
riga 364:  bool crossPast = (ef[InpCrossLookback] <= em[InpCrossLookback]);
```

Il PDF chiede _"EMA9 incrocia sopra EMA21"_ (di recente). Il codice chiede
"EMA9 sopra ORA **e** EMA9 sotto **esattamente 8 barre fa**". Non è la stessa
cosa, in due modi opposti:

- 🔓 **più largo**: la condizione è vera anche se l'incrocio è avvenuto **8
  barre fa** ed è ormai vecchio. Su H4 sono **32 ore** dal trigger.
- 🔒 **più rigido, e questo è il grave**: se 8 barre fa la EMA9 era **già
  sopra**, un incrocio avvenuto 3 barre fa **non viene visto**. Il segnale è
  perso.

La formulazione fedele è "esiste `k` in `[0..lookback]` tale che
`ef[k] <= em[k]`" (o meglio `ef[k]<=em[k] && ef[k-1]>em[k-1]`, che dà anche
l'**età** dell'incrocio). **Impatto atteso: cambia l'insieme dei trade, non
solo il loro numero.** Va misurato, non corretto al buio.

### ② Manca "Prezzo > EMA9": si può entrare long col prezzo SOTTO la EMA9 — 🔓

Fase 3 del PDF: _"long: **Prezzo > EMA9** > EMA21 > EMA50"_.

```
riga 362:  bool ordered = (!InpRequireAlignment) || (ema9>ema21 && ema21>ema50);
riga 366:  bool dist    = (close1 - ema9) <= InpMaxDistATR*atr[0];
```

`ordered` controlla **solo le tre medie fra loro**. Il prezzo entra nella
formula una volta sola, a riga 359 (`close1 > ema50`). E il filtro di distanza
di riga 366 **non aiuta**: se `close1 < ema9` la differenza è negativa, quindi
`<= 1.5*ATR` è **sempre vera**. Risultato: **l'EA può aprire long con la
chiusura sotto la EMA9**, cioè con il prezzo che sta già rientrando. Nel PDF
quel setup è fuori dalla fase 3.

### ③ La distanza d'ingresso è 3× quella "preferibile" del cap.9 — 🔓

| PDF cap.9 | EA |
|---|---|
| **preferibile entro 0,5 ATR** dalla EMA9 | `InpMaxDistATR = 1.5` → **1,5 ATR** (riga 84, 366) |
| accettabile entro **1 ATR dalla EMA21** | 🚫 la distanza dalla EMA21 **non è mai misurata** |
| **oltre 1 ATR dalla EMA21 = tardivo** | 🚫 nessuna nozione di "tardivo" |

L'EA entra a mercato in una fascia che il PDF classifica esplicitamente come
**tardiva**. È la divergenza che, sul piano statistico, mi aspetto sposti di più
il payoff medio (ingressi più estesi = stop più lontano = R peggiore), ma
**non ho backtest a confronto e non lo affermo come fatto**.

### ④ Lo stop dopo 2 perdite consecutive viene **disinnescato dai parziali** — 🐛

```
riga 663-667:
   if(entry==DEAL_ENTRY_OUT)
     {
      double p=...DEAL_PROFIT + DEAL_SWAP + DEAL_COMMISSION;
      if(p<0) consecLosses++; else consecLosses=0;
     }
```

Il contatore itera **tutti i deal in uscita**, e la **chiusura parziale a +1R è
un `DEAL_ENTRY_OUT` in profitto**. Con i default in vigore (`InpPartialR=1.0`,
`InpPartialPct=50`, riga 101-102) la sequenza tipica di un trade che va a
pareggio dopo il parziale è: `+parziale` → azzera → `chiusura ~0/negativa` → 1.
**Due trade così di fila non fanno mai 2: fanno 1 e 1.** La regola del cap.14
_"STOP OPERATIVO dopo 2 perdite consecutive"_ **c'è nel codice ma in pratica
scatta molto più di rado di quanto dichiara**. Da verificare sui log reali
contando quante volte è mai scattata: **[INFERITO dal codice, non ancora
osservato sui dati]**.

### ⑤ "In trend forte mantenere" contro il TP fisso a 2R — ⚠️

Il cap.10 dice: _"in trend forte mantenere finché HA + ADX + medie restano
coerenti"_. L'EA mette un **TP fisso** a `InpTP_R = 2.0` (riga 100, 426) che
chiude **comunque**, e il trailing di default è sulla EMA21 (riga 104). Il PDF
tratta 1:2 come **ideale minimo raggiunto**, non come tetto. In più il trailing
EMA21 **non presidia niente finché non si è oltre il pareggio**:

```
riga 514:  if(isLong && newSL>sl && newSL>openP) gTrade.PositionModify(...)
```

`newSL>openP` significa che **sotto il breakeven la EMA21 non protegge**: un
trade che va male subito resta appeso allo stop swing iniziale, mentre il cap.11
prescriverebbe l'uscita alla **chiusura sotto EMA21**.

---

# PARTE 2 — 📋 LA TABELLA DI FEDELTÀ, REGOLA PER REGOLA

Legenda: ✅ FEDELE · ⚠️ DIVERGENTE · 🔓 PIÙ LARGO · 🔒 PIÙ RIGIDO · ⛔ ASSENTE

## 2.1 Blocco A — La sequenza a 6 fasi

| # | regola del PDF | esito | riga / evidenza |
|---|---|---|---|
| A1 | **Contesto**: prezzo coerente con EMA50 (sopra = solo long) | ✅ | 359 `close1 > ema50` · 373 `close1 < ema50`. Più il controllo di pendenza 360 `ema50 >= es[3]` |
| A2 | **Trigger**: incrocio EMA9/21 | ⚠️ | 363-364 — vedi §1.4 ① |
| A3 | **Allineamento**: Prezzo>EMA9>EMA21>EMA50, inclinate | 🔓 | 362 `ema9>ema21 && ema21>ema50` **senza Prezzo>EMA9** (§1.4 ②). Le pendenze ci sono: 361 |
| A4 | **Momentum**: ≥3 HA consecutive coerenti, piene, senza stoppino contrario, corpo stabile/crescente | ✅ | 297-316 `HAConfirms()` — tutte e quattro le condizioni presenti (ma vedi B8 sul corpo) |
| A5 | **Forza**: ADX>20, crescente/stabile, DI coerenti | ✅ | 351 `adx[0]>=InpAdxMin` · 352 `adx[0]>=adx[2]` · 365 `dip[0]>dim[0]` |
| A6 | **Tradeability**: stop posizionabile, spazio a S/R, RR≥1:1 | 🔓 | 424 stop posizionabile ✅ · 430 `if(InpTP_R < InpMinRR)` **tautologico** (confronta due input, mai il trade) · spazio a S/R ⛔ |

## 2.2 Blocco B — La checklist long a 15 punti

| # | punto | esito | riga / nota |
|---|---|---|---|
| B1 | prezzo sopra EMA50 | ✅ | 359 |
| B2 | EMA50 inclinata su o almeno non ribassista | ✅ | 360 `ema50 >= es[InpEmaSlopeBars]` (3 barre) |
| B3 | EMA9 incrocia sopra EMA21 | ⚠️ | 363-364 — §1.4 ① |
| B4 | EMA9 e EMA21 inclinate su | ✅ | 361 |
| B5 | medie ordinate o in allineamento | ✅ | 362 (disattivabile con `InpRequireAlignment=false`) |
| B6 | ≥3 HA rialziste consecutive | ✅ | 304-307, `InpHACount=3` di default. ⚠️ `InpHAAutoCount` (194-199, **default off**) su H1/H4 ne chiederebbe **2**: è la "regola Lavorenti", **non è nel PDF** |
| B7 | HA senza stoppino inferiore significativo | ✅ | 308-309 `wick > 0.30*body` → scarta. Soglia parametrizzata, lettura corretta dell'ombra HA (per long `hO-hL`, per short `hH-hO`) |
| B8 | corpo HA **stabile o crescente** | 🔓 | 314 `bodyRecent < 0.60*bodyOldest` → scarta. **Ammette un corpo che cala fino al 40%.** Il PDF non ammette riduzione: è la stessa cosa che il cap.12 vieta ("corpi HA in riduzione") |
| B9 | ADX>20 (preferibile >25) | ✅ | 79 `InpAdxMin=20.0`. Il "preferibile 25" non esiste come grado → vedi C4 |
| B10 | ADX crescente o almeno stabile | ✅ | 352 (confronto barra 1 vs barra 3) |
| B11 | DI+ > DI− | ✅ | 365 / 379 |
| B12 | prezzo non eccessivamente distante da EMA9 **o EMA21** | 🔓 | 366 — solo dalla EMA9, e a 1,5 ATR. §1.4 ③ |
| B13 | spazio tecnico fino alla prima resistenza | ⛔ | nessun concetto di S/R nel file |
| B14 | SL posizionabile in modo tecnico | ✅ | 410-424 swing su 10 barre + `SYMBOL_TRADE_STOPS_LEVEL`, e 424 salta se lo stop è troppo vicino |
| B15 | RR ≥1:1 (pref. 1:1,5, ideale 1:2) | ✅ | 426 `tp = entry ± risk*InpTP_R`, default **2.0 = l'ideale del PDF**. Fedele nel risultato, tautologico nel controllo (430) |

> 📌 **Short speculare:** verificato riga per riga (373-383). La simmetria è
> corretta, **nessuna asimmetria nascosta**, incluso il caso `slPrec==0` nel
> breakeven (496).

## 2.3 Blocco C — La scala dell'ADX

| # | regola | esito | nota |
|---|---|---|---|
| C1 | ADX <15 → **no trade** | ✅ | rispettata per eccesso (minimo 20) |
| C2 | ADX 15-20 → solo setup molto pulito, meglio attendere | 🔒 | col default 20 **la fascia è esclusa in blocco**: l'EA rinuncia a setup che il PDF ammetterebbe. ⚠️ **`ABTG_GoldenCross_Ottimizzato.mq5` ha `InpAdxMin=15.0`**: entra in quella fascia **senza nessuna conferma aggiuntiva** — lì l'esito è ⚠️ DIVERGENTE |
| C3 | ADX >20 → valutabile | ✅ | 351 |
| C4 | ADX >25 → preferibile | ⛔ | nessuna distinzione di grado (ricade nella classificazione A/B, blocco H) |
| C5 | ADX >35/40 → attenzione a non inseguire un movimento esteso | ⛔ | **nessun tetto superiore sull'ADX.** L'EA entra volentieri a ADX 45, cioè esattamente dove il PDF dice di stare attenti |

## 2.4 Blocco D — L'ingresso (cap.9)

| # | regola | esito | nota |
|---|---|---|---|
| D1 | ingresso **diretto** alla chiusura della 3ª HA valida | ✅ | 88 `GC_MARKET` (default) + 242 decisione solo a barra chiusa |
| D2 | ingresso **conservativo su pullback** verso EMA9 o EMA21 | ✅ | 88/89 `GC_PULLBACK` + `InpPullbackRef`, LIMIT con scadenza a 3 barre (447-450). Implementazione pulita |
| D3 | preferibile entro **0,5 ATR dalla EMA9** | 🔓 | 84 `InpMaxDistATR=1.5` → **3× più largo**. §1.4 ③ |
| D4 | accettabile entro **1 ATR dalla EMA21** | ⛔ | distanza dalla EMA21 mai calcolata |
| D5 | oltre 1 ATR dalla EMA21 = **tardivo** | ⛔ | — |
| D6 | 3ª HA molto ampia → valutare attesa del pullback | ⛔ | la modalità d'ingresso è un input fisso, **non commuta mai** in base all'ampiezza della candela |

## 2.5 Blocco E — Stop, target, gestione dinamica (cap.10)

| # | regola | esito | nota |
|---|---|---|---|
| E1 | SL sotto l'ultimo **minimo significativo** | ✅ | 412-416 `iLowest(...,InpSwingLookback=10,1)` + buffer |
| E2 | SL sotto **EMA21** | ⛔ | non esiste come modalità di stop **iniziale** (`ENUM_GC_SL` ha solo SWING e ATR). Esiste solo come **trailing** |
| E3 | SL sotto la **candela di conferma** | ⛔ | — |
| E4 | SL su **distanza tecnica ATR** | ✅ | 419 `GC_SL_ATR`, `InpAtrSLmult=1.5` |
| E5 | target: min 1:1, pref 1:1,5, **ideale 1:2** | ✅ | `InpTP_R=2.0` = l'ideale |
| E6 | target **tecnici** (S/R, massimi/minimi, pivot, aree volume) | ⛔ | il TP è **solo** un multiplo di R |
| E7 | a 1R: pareggio / parziale / protezione dietro EMA21 | ✅ | **tutte e tre**: 478-501 parziale al 50% a 1R, breakeven, trailing EMA21 di default (104). ⭐ Il pezzo più fedele di tutto l'EA, correzione del bug lotto minimo inclusa (485-500) |
| E8 | trend forte: **mantenere** finché HA+ADX+medie coerenti | ⚠️ | TP fisso a 2R che chiude comunque; nessun controllo ADX in gestione. §1.4 ⑤ |
| E9 | perdita di momentum: uscita parziale o totale | ⚠️ | `InpExitOnHAflip` esiste ma è **default false** (107); il calo di ADX non è mai letto in `ManageOpen()` |

## 2.6 Blocco F — Le uscite (cap.11)

| # | regola long | esito | nota |
|---|---|---|---|
| F1 | TP raggiunto | ✅ | TP sull'ordine |
| F2 | **chiusura sotto EMA21** | ⚠️ | non esiste come uscita. Approssimata dal **trailing** su EMA21 (525-528), che però: (a) scatta sul **tocco intrabar**, non sulla chiusura; (b) 514 `newSL>openP` → **non protegge finché non si è in utile**. §1.4 ⑤ |
| F3 | EMA9 scende sotto EMA21 | ✅ | 541-545 `InpExitOnCross=true` di default |
| F4 | cambio colore HA | ⚠️ | 546-551 presente ma **default OFF** |
| F5 | resistenza importante | ⛔ | — |
| F6 | calo marcato ADX / forte stoppino superiore | ⛔ | `ManageOpen()` non legge né ADX né le HA (se non per il flip spento) |

## 2.7 Blocco G — Le 16 regole di NON-INGRESSO (cap.12)

| # | "non entrare se..." | esito | nota |
|---|---|---|---|
| G1 | medie intrecciate | ✅ | coperto da `ordered` (362) + pendenze (360-361) |
| G2 | **EMA50 piatta col prezzo che la attraversa** | 🔓 | 360 usa `>=`: una EMA50 **perfettamente piatta passa il filtro**. Nessuna soglia minima di pendenza. Il PDF esclude esplicitamente questo caso |
| G3 | incrocio dentro una **congestione** | ⛔ | il surrogato esiste — bande di Bollinger in espansione (210-223) — ma è **`InpUseBBExpand=false` di default**: in campo la congestione non è filtrata |
| G4 | ADX <15 | ✅ | |
| G5 | ADX 15-20 senza forte conferma | ✅ | per esclusione (minimo 20) |
| G6 | DI non confermano | ✅ | 365/379 |
| G7 | HA alternano colore | ✅ | 307 `if(body<=0) return(false)` su tutte e 3 |
| G8 | corpi HA in riduzione | 🔓 | 314, tollera −40%. Doppione di B8 |
| G9 | stoppino contrario significativo | ✅ | 309 |
| G10 | prezzo troppo distante da **EMA21** | ⛔ | misurata solo la distanza dalla EMA9 |
| G11 | movimento già arrivato su S/R | ⛔ | — |
| G12 | RR < 1:1 | ✅ | per costruzione (TP = 2R) |
| G13 | **stop tecnico troppo ampio** | ⛔ | 🚨 **nessun tetto massimo sulla distanza dello stop.** Con lo swing a 10 barre, un minimo lontano produce uno stop enorme: il lotto si riduce (LotByRisk), quindi **il rischio in euro resta 1%** — ma il PDF dice di **non entrare affatto**. È una regola di **qualità del setup**, non di sizing, e il sizing non la sostituisce |
| G14 | news ad alto impatto imminenti | ⚠️ | filtro completo e ben fatto (674-718) ma **`InpUseNewsFilter=false` di default** e richiede un CSV in `MQL5/Files` |
| G15 | mercato senza liquidità | ⛔ | 🚨 **nessun filtro orario/sessione in tutto il file.** L'unico surrogato è `InpMaxSpread`, **default 0 = disattivato** (612-616) |
| G16 | trader emotivamente alterato | — | non meccanizzabile, **escluso dal conteggio** |

## 2.8 Blocco H — La classificazione A/B/C (cap.13)

| # | regola | esito | nota |
|---|---|---|---|
| H1 | **Setup A** (EMA ordinate, 3 HA forti, ADX>25, DI coerenti, spazio tecnico, RR≥1:1,5) → preferibile | ⛔ | il concetto di "qualità del setup" **non esiste nel codice**: il segnale è booleano |
| H2 | **Setup B** (condizioni principali ok, ADX>20, RR≥1:1) → prudenza | ⛔ | — |
| H3 | **Setup C** → da scartare | ⛔ | *parzialmente* ottenuto per effetto collaterale: i filtri obbligatori scartano comunque i setup deboli. Ma **non è la regola**: il PDF chiede una graduazione, non una soglia |

> 🔑 **Perché questo blocco conta più di quanto sembri:** il cap.14 **collega la
> classificazione al rischio** (_"max 1,5% **solo setup A qualificato**"_). Senza
> A/B/C, la regola del rischio variabile è **impossibile da implementare**. Le
> due assenze si tengono l'una con l'altra.

## 2.9 Blocco I — Money management (cap.14) → dettaglio nella PARTE 3

| # | regola | esito | dove |
|---|---|---|---|
| I1 | rischio **0,5% in test/demo** | ⚠️ | `InpRiskPercent=1.0` di default (110) e **1.0 anche nei preset forward** (`ABTG_GoldenCross_FW_*.set`), che girano **su conto demo** |
| I2 | 1% ordinario | ✅ | default 1.0 |
| I3 | max 1,5% **solo setup A** | ⛔ | manca la classificazione (H1) |
| I4 | **MAI oltre 2%** | ⛔ | nessun cap hard: `InpRiskPercent=8.0` viene accettato senza un warning |
| I5 | max **2 trade/giorno sullo stesso strumento** | ✅ | 111 + 250 + `TodayStats` filtra per `DEAL_SYMBOL==_Symbol` e magic (658-660) |
| I6 | max **3 trade complessivi/giorno** | ⛔ | vedi §3.3 |
| I7 | **stop dopo 2 perdite consecutive** | ⚠️ | esiste (112, 251) **ma i parziali lo azzerano** — §1.4 ④ |
| I8 | stop giornaliero **−2R / −3R** | ⛔ | non nell'EA; surrogato **più largo** nel Guardian — §3.5 |
| I9 | mai aumentare la size dopo una perdita | ✅ | `LotByRisk` (572-601) è sempre `BALANCE × %`: nessuna martingala, nessuna memoria dell'esito precedente |

## 2.10 Blocco J — Timeframe, mercati, fasce orarie (cap.4)

| # | regola | esito | nota |
|---|---|---|---|
| J1 | M5/M15 · M15/M30 · **H1/H4 swing più puliti** | ✅ | `InpTimeframe=PERIOD_H1` di default; i preset forward girano su **H4** (`InpTimeframe=16388`). Entrambi dentro il perimetro del PDF |
| J2 | mercati: indici, cambi principali, oro, petrolio | ✅ | l'EA è agnostico; in flotta gira su XAUUSD, USDCHF, USDCAD, NZDUSD (`FLOTTA_ATTIVA.md`) |
| J3 | fasce: apertura europea, pre-market/apertura USA, sovrapposizione EU/US | ⛔ | **nessun input orario** |
| J4 | evitare: fine sessione, pre-news, congestioni | ⛔ | tre surrogati, **tutti e tre spenti di default**: `InpFridayClose=false` (solo il venerdì), `InpUseNewsFilter=false`, `InpUseBBExpand=false` |

---

# PARTE 3 — 🏛️ LE REGOLE PROP DEL CAP.14: CHI LE FA RISPETTARE?

**È il blocco messo peggio (3/9) ed è il più facile da chiudere.** Qui la
domanda non è "l'EA è fedele?" ma **"esiste da qualche parte, nell'intera
flotta, qualcosa che fa rispettare questa regola?"**.

## 3.0 Il quadro in una tabella

| regola cap.14 | nell'**EA** | nel **Guardian** | verdetto |
|---|---|---|---|
| rischio 0,5% demo / 1% ordinario | ✅ input `InpRiskPercent` | – | **c'è** (ma i preset demo usano 1%) |
| max 1,5% solo setup A | ⛔ | ⛔ | 🕳️ **BUCO** (dipende dalla classificazione, assente) |
| **MAI oltre 2%** | ⛔ nessun cap | 🟡 indiretto: cap C1 sul **rischio aperto** 3,25% | 🕳️ **BUCO sul rischio per trade** |
| max 2 trade/giorno **stesso strumento** | ✅ `InpMaxTradesPerDay=2` | – | **c'è** |
| **max 3 trade/giorno complessivi** | ⛔ conta solo il proprio simbolo+magic | ⛔ il Guardian conta **euro**, non trade | 🕳️ **BUCO TOTALE** |
| **stop dopo 2 perdite consecutive** | 🟡 c'è ma i parziali lo azzerano | ⛔ | 🕳️ **BUCO DI FATTO** |
| **stop giornaliero −2R/−3R** | ⛔ | 🟡 `InpDailyPausePct=4.0` (pausa B1) e `InpDailyLossPct=5.0` | 🕳️ **BUCO** (surrogato **più largo**, e in % non in R) |
| mai aumentare size dopo perdita | ✅ per costruzione | – | **c'è** |

## 3.1 Cosa fa davvero il Guardian (verificato)

`mql5/Experts/ABTG_Guardian.mq5` sorveglia **il conto in euro**, non le regole
di setup:

- `InpDailyLossPct=5.0` — limite di perdita giornaliera duro (chiude e blocca);
- `InpTotalDDPct=10.0` — drawdown totale;
- `InpDailyPausePct=4.0` — **pausa morbida B1**: sotto −4% niente nuovi ingressi;
- `InpMaxOpenRiskPct=3.25` — **cap C1** sul rischio aperto simultaneo (5 SL vivi
  da 0,65%).

L'EA li rispetta con **una riga sola**, messa correttamente **immediatamente
prima dell'invio** (riga 436):

```
if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_GoldenCross")) return;
```

✅ Posizionamento corretto secondo la regola scritta in
`mql5/Include/ABTG_PausaGuardian.mqh` (righe 35-44): mai in cima all'imbuto, mai
sulle chiusure. **Il fail-open è totale e dichiarato**: nel Strategy Tester le
GlobalVariable non esistono, quindi i backtest restano confrontabili.

🔑 **Ma il Guardian conta EURO, il cap.14 conta OPERAZIONI E R.** Sono due
grandezze diverse: nessuna delle due copre l'altra.

## 3.2 🕳️ BUCO — "MAI oltre il 2% per trade"

Nessuno controlla `InpRiskPercent`. Il cap C1 del Guardian limita il rischio
*aperto simultaneo* (3,25%), non quello *per singola operazione*: un EA a
`InpRiskPercent=3.0` con una sola posizione aperta **passa il cap C1 senza un
fiato**, pur violando il cap.14.

**Proposta (opt-in, default = comportamento attuale):**

```
input double InpCapRischioPerTrade = 0;   // 0 = spento (attuale). >0 = tetto duro % per trade
```

Se `>0` e `InpRiskPercent > InpCapRischioPerTrade` → `Alert` + rifiuto in
`OnInit`. **Default 0 = nulla cambia.** Valore da manuale: **2.0**.

## 3.3 🕳️ BUCO TOTALE — "max 3 trade complessivi al giorno"

`TodayStats()` (648-669) filtra per `DEAL_SYMBOL==_Symbol` **e**
`DEAL_MAGIC==InpMagic`. Ogni istanza conta **solo se stessa**.

🚨 **Il fatto che rende questo buco concreto oggi:** in flotta girano **4 sedie
GoldenCross + 1 Ottimizzato** (magic 770331/32/33, 970301, più il nativo —
`FLOTTA_ATTIVA.md`). Con `InpMaxTradesPerDay=2` ciascuna, il tetto reale della
famiglia è **fino a 10 trade/giorno**, contro i **3** del cap.14. E questo senza
contare le altre ~20 sedie della flotta.

**Proposta (opt-in):** un contatore condiviso su GlobalVariable, sullo stesso
canale del Guardian (che ha già la convenzione `<radice>_<login>`):

```
input int InpMaxTradeGiornoFamiglia = 0;   // 0 = spento. >0 = tetto sui trade/giorno di TUTTA la famiglia
```

Alternativa **migliore e più pulita**: farlo fare al **Guardian**, che vede già
tutto il conto — un `InpMaxTradeGiorno` che conta i `DEAL_ENTRY_IN` del giorno
su tutti i magic e alza la pausa B1 al superamento. ⭐ **Questa è la strada che
consiglio**: una regola sola, un posto solo, e vale per l'intera flotta e non
solo per GoldenCross.

## 3.4 🕳️ BUCO DI FATTO — "stop dopo 2 perdite consecutive"

Il codice c'è, ma i parziali in profitto azzerano il contatore (§1.4 ④).

**Proposta (opt-in):** contare le perdite **per posizione**, non per deal —
raggruppando i deal per `DEAL_POSITION_ID` e sommando l'esito netto della
posizione, invece di guardare ogni `DEAL_ENTRY_OUT` isolato:

```
input bool InpPerditeContaPerPosizione = false;  // false = attuale (per deal). true = per posizione intera
```

**Metrica attesa dal test:** il numero di trade/giorno **cala** nei giorni
negativi; l'insieme dei trade nei giorni positivi **non cambia**. Se cambia
anche lì, c'è un altro effetto in mezzo.

## 3.5 🕳️ BUCO — "stop giornaliero −2R / −3R"

Il Guardian ha −4% (pausa) e −5% (blocco), ma sono **percentuali di saldo**.
Con rischio 1%, il **−3R del PDF ≈ −3%**: il Guardian interviene **dopo**.
E con rischio 0,5% (quello che il PDF vorrebbe in demo) **−3R ≈ −1,5%**: il
Guardian è **quasi il triplo più permissivo**.

**Proposta (opt-in, nell'EA perché R è una grandezza dell'EA, non del conto):**

```
input double InpStopGiornoR = 0;   // 0 = spento. es. 3.0 = stop operativo a -3R sulla giornata
```

Somma la P&L del giorno del proprio magic/simbolo divisa per il rischio in euro
per trade; se ≤ `-InpStopGiornoR` → niente nuovi ingressi fino al giorno dopo.
⚠️ **Attenzione al fuso:** `TodayStats` taglia a **mezzanotte server**
(651-653), il Guardian usa `InpDailyResetHour`. Le due finestre vanno allineate,
o i due limiti misureranno due "giornate" diverse.

## 3.6 🕳️ BUCO — "1,5% solo su setup A"

Dipende interamente dalla classificazione A/B/C (blocco H). **Proposta a due
stadi**, nell'ordine:

```
input bool   InpClassificaSetup = false;  // calcola e LOGGA il grado A/B/C, senza usarlo
input double InpRiskPercentA    = 0;      // 0 = spento. >0 = rischio usato SOLO sui setup A
```

⭐ **Il primo stadio da solo vale la pena anche se il secondo non si fa mai**:
loggando il grado di ogni ingresso si scopre, **sui dati e non a tavolino**, se
i setup A rendono davvero più dei B. **Se non c'è differenza misurabile, il
rischio differenziato del cap.14 non va implementato affatto** — sarebbe
prendere più rischio senza edge.

## 3.7 Le proposte in ordine di rapporto valore/rischio

| # | proposta | costo | valore | note |
|---|---|---|---|---|
| 1 | `InpCapRischioPerTrade` (§3.2) | banale | 🟢 alto | pura sicurezza, **non tocca nessun trade** |
| 2 | Classificazione A/B/C **solo log** (§3.6 stadio 1) | medio | 🟢 alto | **non cambia nessun trade**, produce dati |
| 3 | `InpPerditeContaPerPosizione` (§3.4) | basso | 🟡 medio | è la correzione di un difetto, ma **cambia i trade** → una variabile alla volta |
| 4 | Tetto trade/giorno di famiglia nel **Guardian** (§3.3) | medio | 🟡 medio | vale per tutta la flotta, non solo GoldenCross |
| 5 | `InpStopGiornoR` (§3.5) | medio | 🟡 medio | da allineare col fuso del Guardian |
| 6 | rischio differenziato sui setup A (§3.6 stadio 2) | basso | 🔴 **da non fare adesso** | **aumenta il rischio**: solo dopo che il punto 2 ha prodotto la prova |

> 🔒 **Nessuna di queste è stata implementata.** Tutte con default = zero/false,
> cioè comportamento identico a oggi. E ognuna va misurata **da sola**, con e
> senza, su tutti gli anni: la regola di casa non si sospende per le regole
> prop.

---

# PARTE 4 — 🌫️ LE REGOLE NON MECCANIZZABILI

Cinque regole del PDF chiedono un concetto che **l'EA non possiede in nessuna
forma**: livelli, congestione, liquidità. Non sono dimenticanze del
programmatore, sono **il residuo discrezionale della strategia**.

| regola del PDF | come l'EA la tratta | giudizio |
|---|---|---|
| **"spazio tecnico fino alla prima resistenza"** (checklist 13, fase 6) | 🚫 **la ignora**. Il TP è un multiplo di R e non guarda cosa c'è davanti | il TP a 2R è un **surrogato onesto ma cieco**: garantisce il rapporto, non la raggiungibilità |
| **"target tecnici: S/R, massimi/minimi, pivot, aree volume"** (cap.10) | 🚫 ignorata | **meccanizzabile in parte**: massimi/minimi precedenti e pivot sono calcolabili; le "aree volume" no, non su dati tick di un broker retail |
| **"uscita su resistenza importante"** (cap.11) | 🚫 ignorata | idem |
| **"movimento già arrivato su S/R"** (cap.12) | 🚫 ignorata | è la stessa nozione, in negativo |
| **"incrocio dentro una congestione"** (cap.12) | 🟡 **approssimata**: bande di Bollinger in espansione (`BBExpanding`, 210-223) — **ma default OFF** | ⭐ **la migliore approssimazione presente nel file.** La larghezza delle bande è una misura diretta di compressione: acceso, questo filtro *è* un filtro anti-congestione. **Che sia spento è una scelta, non un limite tecnico** |
| **"mercato senza liquidità"** (cap.12) + **fasce orarie** (cap.4) | 🚫 nessun filtro orario; `InpMaxSpread` esiste ma è **default 0 = spento** | 🎯 **è la meno discrezionale delle cinque**: "sessione" e "spread" sono numeri. Questo è **il buco più facilmente colmabile** dell'intero referto |
| **"trader emotivamente alterato"** (cap.12) | N/A | ⭐ nota non ironica: **un EA la rispetta per costruzione**. È l'unico punto in cui la macchina batte l'operatore senza discussione |

**Come si potrebbero avvicinare** (proposte, non implementazioni):

1. **Filtro orario** — `InpOraInizio` / `InpOraFine` in **ora server** (attenzione
   alla regola di casa sul fuso BCM: ora italiana − 1). Il PDF nomina fasce
   precise; il costo di codifica è un `if`. **Da provare per primo tra i sei**,
   perché non richiede nessun concetto nuovo.
2. **Spazio a S/R come "distanza dal massimo/minimo delle ultime N barre"** —
   surrogato grezzo ma oggettivo: se il TP a 2R cade **oltre** il massimo delle
   ultime N barre, il setup è un "C" secondo il cap.13. Opt-in.
3. **Anti-congestione**: `InpUseBBExpand=true` — **c'è già, basta accenderlo e
   misurarlo con/senza.** Costo zero, ed è già dietro un input. ⭐

---

# PARTE 5 — 📝 NOTE TECNICHE (non di fedeltà, ma da sapere)

Cose trovate leggendo il codice che **non riguardano il PDF** ma riguardano
l'affidabilità di quello che gira.

1. **Ricalcolo delle Heiken Ashi con warm-up.** `GetHA` (271-291) ricalcola le HA
   da un punto arbitrario, con seme `(o+c)/2` e **60 barre di riscaldamento**
   (riga 273). L'errore del seme decade esponenzialmente: a 60 barre è
   trascurabile. ✅ **Approssimazione corretta e dichiarata**, non un difetto.
2. **`ManageOpen()` gira a ogni tick** (240), ma legge sempre il buffer alla
   **barra 1** (chiusa): il *valore* è di barra chiusa, il *momento* della
   decisione è il primo tick utile. ✅ Corretto.
3. **Ingresso a mercato al prezzo corrente, filtro sulla `close1`.** Il filtro di
   distanza (366) usa la chiusura della barra precedente, ma l'ordine parte
   all'`ask` corrente (401, 440). Su un'apertura in gap il prezzo effettivo può
   essere ben oltre la soglia appena verificata. Effetto piccolo su H1/H4, non
   nullo.
4. **Guardia anti-duplicato reload-safe** (394-395) e **selezione hedge-safe per
   ticket** (618-626): entrambe corrette, coerenti con lo standard della flotta.
5. **`gPartialDone` è un `bool` globale**, non legato al ticket (137, 437). Viene
   riazzerato all'apertura, e l'EA tiene **una posizione per volta** (244):
   quindi funziona. ⚠️ Ma è più fragile del pattern legato al ticket usato
   altrove: dopo un reload del terminale a posizione aperta, `gPartialDone`
   torna `false` e **il parziale potrebbe essere rifatto**. Non è una questione
   di fedeltà al PDF: è robustezza.
6. **Le due varianti sono lo stesso motore.**
   `ABTG_GoldenCross_Ottimizzato.mq5` è **identico riga per riga nella logica**;
   cambiano solo i default (`InpAdxMin` 20→**15**, `InpAtrSLmult` 1.5→**1.0**,
   `InpTP_R` 2.0→**3.0**), il magic (970301) e **mancano** le due aggiunte
   recenti (filtro Bollinger e `InpHAAutoCount`). ⚠️ **Il default ADX 15 lo rende
   meno fedele al PDF del fratello** (§2.3-C2): entra nella fascia che il PDF
   riserva ai "setup molto puliti", senza avere nessuna nozione di pulizia.
   La copia in `mql5/Experts/standalone/ABTG_GoldenCross.mq5` è una versione
   **più vecchia** (senza Guardian, senza Bollinger, senza AutoCount).

---

# PARTE 6 — 🧭 COSA FARE, IN ORDINE

**Non ho backtest di questo EA sotto mano in questa sessione, quindi non
affermo che nessuna di queste modifiche migliori le performance.** Dico solo
cosa è **coerente col PDF** e **quale metrica dovrebbe muoversi**.

| # | intervento | tipo | metrica attesa |
|---|---|---|---|
| 1 | 🐛 **Correggere il test dell'incrocio** (§1.4 ①) su un input `InpCrossModo` (default = attuale) | difetto | cambia **l'insieme** dei trade. Confronto obbligato sugli stessi anni |
| 2 | 🐛 **Perdite consecutive per posizione** (§3.4) | difetto | meno trade nei giorni negativi, stessi trade altrove |
| 3 | ➕ **`Prezzo > EMA9`** dietro input, default off (§1.4 ②) | fedeltà | meno trade, ingressi meno "in rientro" |
| 4 | ➕ **Distanza dalla EMA21** e soglia 0,5 ATR dalla EMA9 (§1.4 ③) | fedeltà | meno trade, R medio migliore **se il PDF ha ragione** |
| 5 | 🛡️ **`InpCapRischioPerTrade`** (§3.2) | sicurezza | **nessuna**: non cambia un trade |
| 6 | 📊 **Classificazione A/B/C solo a log** (§3.6) | conoscenza | **nessuna**: produce dati per decidere il punto 7 |
| 7 | ⏰ **Filtro orario** (§4.1) | fedeltà | meno trade, drawdown atteso più basso |
| 8 | 🔘 **Accendere `InpUseBBExpand`** e misurare con/senza | fedeltà | **costo zero, è già lì** |

> ⚠️ **Una alla volta, con e senza, su tutti gli anni.** Se un intervento
> aggiusta un anno e ne rovina altri, si scarta: è curve-fitting. E il forward
> demo resta l'unico collaudo che conta.

---

## 📌 Nota di metodo, per chi legge fra sei mesi

**Fedele 36/78 non è una bocciatura.** Un EA che copre il 46% di un documento
discrezionale di 14 capitoli — e il **73% della checklist operativa**, che è il
cuore — è un buon EA. Il PDF contiene tre cose diverse mescolate: **regole
meccaniche** (le medie, l'ADX, le HA: qui l'EA è fedele), **giudizio di
contesto** (S/R, congestione, liquidità: qui l'EA è cieco), e **disciplina
prop** (cap.14: qui l'EA è **incompleto senza motivo tecnico**).

🎯 **Il terzo gruppo è l'unico dove l'infedeltà non ha una scusa.** Un tetto di
3 trade al giorno è un contatore. Un cap del 2% è un `if`. Uno stop a −3R è una
sottrazione. **Sono le regole più facili del documento e sono quelle messe
peggio** — perché sono le uniche che non fanno guadagnare, e servono solo a non
perdere. Da qui in avanti, questo è il pezzo da chiudere per primo.
