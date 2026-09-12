# CACCIA DEL SABATO — 13/09/2026 · TF BASSO, priorita' FOREX

> **Perimetro di questo file: SOLA LETTURA piu' questo `.md` piu' tre sorgenti
> archiviati.** Nessun `.mq5` nostro scritto o toccato, nessun `.set`, nessun
> parametro in forward, nessun terminale, nessun backtest eseguito, nessuna
> taglia o rischio deciso. Tutto cio' che segue e' materiale per Claudio.
>
> Mandato iniziale: motori ad alta frequenza, forex M15/M30/H1 + indici M30/H1.
> **Riorientato in corsa** dalla direzione di Claudio (_"abbiamo troppi pochi EA
> dal TF basso"_): il peso e' stato spostato sul **TF basso, forex M5/M15/M30**.
> Il materiale H1 raccolto prima del riorientamento e' in fondo (§6).

---

# 0. LA RIGA CHE VA LETTA PER PRIMA

> ## Su **320 titoli** di EA del Code Base sfogliati su 8 pagine, **28 passati al controllo di doppione**, **3 arrivati al sorgente e letti riga per riga**: **ZERO PROMOSSI. Zero file prova consegnati.**
>
> **E non e' una resa: la cosa che porto a casa e' un CONTO, ed e' la risposta
> diretta alla richiesta di Claudio sul TF basso.**
>
> ## Il TF basso sul forex NON e' aperto come il brief assumeva, e il numero lo dice
> Il brief diceva: _"FOREX: qui il TF basso e' APERTO: M5/M15/M30. Spread molto
> piu' piccolo in rapporto allo stop"_. **Misurato coi nostri numeri, e' falso su
> EURUSD:**
>
> | coppia · TF | stop tipico (numero DI CASA) | costo all-in | `stop/spread` | pavimento DURO 13,3x | pavimento di lavoro 40x |
> |---|---:|---:|---:|---|---|
> | **EURUSD M5** | **8,0 pip** | **0,86 pip** | **9,30x** | SFONDATO (70%) | 23% |
> | **EURUSD M15** | **10,8 pip** | **0,86 pip** | **12,56x** | SFONDATO (94%) | 31% |
>
> **EURUSD M5 e M15 sfondano il pavimento DURO, non solo quello di lavoro.**
> Per passare il 40x su EURUSD serve uno stop di **>= 34,4 pip**; per passare
> anche solo il pavimento duro serve **>= 11,44 pip**. Lo stop M15 di casa e'
> **10,8**. Il TF basso sul forex si apre **dove lo stop arriva a ~34 pip**, e
> su EURUSD quello non e' M15.
>
> ## E LA COPPIA GIUSTA NON E' EURUSD: E' GBPUSD
> **GBPUSD e' il major piu' economico che abbiamo misurato**: spread **0,2 pip**
> (`CANCELLO_COSTO_FLOTTA` §4.3) contro **0,4** di EURUSD. All-in stimato
> **~0,67 pip** `[INFERITO dalla legge di commissione, §2.3]`. Le soglie
> scendono di un terzo: pavimento duro a **>= 8,9 pip di stop**, pavimento di
> lavoro a **>= 26,8 pip**.
> **Su GBPUSD un M30 con stop 27-30 pip atterra proprio sul 40x. Quello e' il
> bersaglio, e su GBPUSD lo storico BCM permette la prova di regime.**

---

# 1. CONTROLLO POSITIVO — misurato oggi, prima di cercare

| fonte | bersaglio | esito misurato | verdetto |
|---|---|---|---|
| **MQL5 Code Base** (elenco) | `/en/code/mt5/experts` + `/page2` | **200** · 85.500 e 83.662 byte · id veri estratti (73210…77236) | PASSA |
| **MQL5 Code Base** (elenco, 8 pagine) | pagine 1-8 | **649.349 byte** totali · **320 coppie id+titolo** estratte | PASSA |
| **MQL5 Code Base** (scheda) | `/en/code/77220`, `/77167`, `/74818`, `/74148`, `/60413`, `/54611`, `/35628`, `/70465`, `/52152`, `/68125`, `/61921`, `/50850` | **200** su tutte e 12 · `<meta description>` con **autore e data** | PASSA |
| **MQL5 sorgente** | `/en/code/download/<ID>/<file>` | **200** su **3 file**: `Zeta_Burst.mq5` 20.306 B · `Market_Miner.mq5` 30.599 B · `heiken_ashi_engulf_ea_buy_mt5.mq5` 436.172 B | PASSA |

**Popolarita' (download/visualizzazioni): [NON MISURATO].** Sulle schede i
contatori sono renderizzati in JS; nell'HTML non ci sono. Non li invento e non
li peso.

**Fonti NON raggiunte / non aperte in questa battuta** — dichiarate, non
sostituite con la memoria:
- **SSRN 403 · Quantpedia 308/502 · GitHub UI 403 · Forex Factory 403 ·
  arXiv API timeout**: bloccati dal proxy, come dichiarato nel brief. **Non
  aggirati, e nessun frammento di motore di ricerca riportato come se fosse la
  pagina.**
- **TradingView: NON aperta in questa battuta.** Scelta dichiarata, con motivo:
  il riorientamento sul TF basso e il conto del §0 hanno consumato il budget,
  e Pine -> MQL5 e' una **riscrittura** (costo reale), cioe' la cosa piu'
  lontana da un candidato lanciabile stanotte. **E' un buco vero di questa
  caccia**, non una fonte esaurita.

---

# 2. IL CONTO DEL COSTO — il contributo vero della giornata

## 2.1 I numeri di casa che uso, e da dove vengono

| numero | valore | da dove |
|---|---:|---|
| pavimento di lavoro | **40x** (`stop/spread`) | brief + `CANCELLO_COSTO_FLOTTA_2026-09-10.md` |
| pavimento DURO | **13,3x** | idem |
| cancello H8 sul netto | **0,075 R** | `REGISTRO_TEST.md` §CACCIA TF M15 |
| stop EURUSD **M5** | **8,0 pip** | `REGISTRO_TEST.md` §CACCIA TF M5 (_"su EURUSD M5 uno stop sensato e' 8 pip"_) |
| stop EURUSD **M15** | **10,8 pip** (= 1,2 x ATR(14) M15) | `REGISTRO_TEST.md` §CACCIA TF M15 |
| spread BCM misurato EURUSD | **0,4 pip** (lettura UNICA, 17/08 17:34 srv) | `CANCELLO_COSTO_FLOTTA` §4.3 |
| spread BCM misurato GBPUSD | **0,2 pip** (lettura UNICA) | idem |
| spread BCM misurato USDJPY | **0,3 pip** (lettura UNICA) | idem |
| commissione | **0,004% del nozionale in valuta base, giro completo** | `CANCELLO_COSTO_FLOTTA` §"si scioglie la contraddizione" |
| **all-in EURUSD** | **0,86 pip** (0,3 spread + ~0,5 commissione) | idem, numero scritto dal referto |

## 2.2 LA TRAPPOLA IN CUI SONO CADUTO, E COME MI SONO ROTTO DA SOLO

Il mio primo risultato della giornata era questo, ed era **bello**:

> _"Le cacce M5/M15 del 05/09 hanno fatto il conto con la CONVENZIONE di 1,0 pip.
> Il 10/09 la sonda ha MISURATO 0,4 pip su EURUSD. A 0,4 pip il pedaggio M5
> scende da 0,1250R a 0,0500R, e il salto statistico M31 su EURUSD — lordo
> +0,0922R a T=6, dato per morto a **−0,033R netti** — diventa **+0,042R
> POSITIVO. Il segno si ribalta.**"_

**L'aritmetica torna al centesimo** (0,0922 − 0,125 = −0,033: la convenzione
di 1,0 pip su stop 8 pip da' esattamente 0,125R, quindi il numero del registro
e' ricostruito, non creduto).

**Poi ho costruito il contro-esempio, come impone la regola del 10/09: "quale
numero produce l'ALTRA spiegazione?". E la mia tesi si e' rotta.**

Nello **stesso** referto del 10/09, poche righe sopra la tabella della sonda,
c'e' la riga che mi smonta: _"La sonda diceva **0,2-0,4 pip**, le schede del
broker **0,8-1,0**. Erano vere tutte e due, e mancava un TERMINE, non una
misura: il conto e' **a commissione** (profilo raw). Spread **0,3** +
commissione **~0,5** = **0,86 pip all-in su EURUSD**."_

**Quindi la convenzione di 1,0 pip delle cacce M5/M15 non era pessimista di
2,5 volte: era ottimistica-corretta entro il 14%.** Il ribaltamento di segno
**NON esiste**, il pedaggio M5 resta **0,1075R** e il salto statistico resta
morto. **Finding ucciso dall'autore, e lo scrivo perche' e' esattamente il
genere di numero bello che costa una giornata a chi lo crede.**

> **La lezione di metodo, in una riga: sulla stessa pagina c'era sia la misura
> che mi piaceva sia il termine che la annullava. Avevo letto la tabella e non
> il paragrafo sopra.** Classe: leggere la riga che conferma e fermarsi.

## 2.3 La tabella dei costi rifatta col numero GIUSTO

Commissione derivata dalla legge dichiarata (0,004% del nozionale in valuta
base, giro completo) e **validata contro un numero scritto da qualcun altro**:
su EURUSD la mia derivazione da' **0,47 pip**, il referto del 10/09 scrive
**~0,5**. Riproduce. Percio' la applico alle altre coppie, **etichettata**:

| coppia | spread misurato | commissione | **all-in** | stop per 13,3x | stop per **40x** |
|---|---:|---:|---:|---:|---:|
| **GBPUSD** | 0,2 [LETTURA UNICA] | ~0,47 [INFERITO] | **~0,67 pip** | **>= 8,9 pip** | **>= 26,8 pip** |
| **EURUSD** | 0,4 [LETTURA UNICA] | ~0,47 [dal referto] | **0,86 pip** [VERIFICATO] | **>= 11,4 pip** | **>= 34,4 pip** |
| **USDJPY** | 0,3 [LETTURA UNICA] | ~0,60 [INFERITO] | **~0,90 pip** | **>= 12,0 pip** | **>= 36,0 pip** |
| **EURJPY** | 0,4 [LETTURA UNICA] | ~0,66 [INFERITO] | **~1,06 pip** | **>= 14,1 pip** | **>= 42,4 pip** |
| AUDUSD | **[NON MISURATO]** — la sonda legge **0** = nessun tick, non spread nullo | — | — | — | — |

**La colonna che decide dove cercare: `stop per 40x`.** GBPUSD chiede **26,8
pip**, EURJPY **42,4**. Fra i due c'e' un fattore **1,58**: cercare su GBPUSD
invece che su EURJPY vale piu' di qualunque taratura di parametri.

## 2.4 Frequenza e settimane per 150 POSIZIONI — la colonna che Claudio ha chiesto

Serve come **metro per i candidati futuri**, perche' oggi di candidati non ce
n'e'. Calcolata per **lato**, su **5 giorni di mercato a settimana**:

| op/giorno per lato | settimane per **150 posizioni** | arriva prima del 1 ottobre (18 giorni = ~2,6 sett.)? |
|---:|---:|---|
| 0,5 | **60,0** | NO |
| 1,0 | **30,0** | NO |
| 2,0 | **15,0** | NO |
| 4,0 | **7,5** | NO |
| **11,5** | **2,6** | **al pelo** |

> **Il fatto scomodo, e va detto adesso perche' cambia la strategia:
> NESSUN motore a frequenza sana raccoglie 150 posizioni per lato in forward
> entro il 1 ottobre.** Servirebbero **11,5 operazioni al giorno per lato**, che
> a TF basso e' territorio da pedaggio insostenibile (§2.3).
> **Quindi le 150 posizioni per il 1 ottobre possono arrivare SOLO dal
> BACKTEST**, non dal forward. E il backtest le da' **subito** se lo storico e'
> lungo: sul forex arriva a **gennaio 1999** (misurato, R102) contro i **21 mesi**
> degli indici.
> **Conseguenza operativa: la frequenza in op/giorno serve a far maturare il
> forward DOPO la challenge; cio' che rende una sedia schierabile il 1 ottobre
> e' la PROFONDITA' DELLO STORICO. Il forex vince su entrambi gli assi, ma per
> il secondo motivo, non per il primo.** `[Questa e' una mia inferenza dai due
> numeri (150 posizioni, 18 giorni), non una misura: decide Claudio.]`

---

# 3. I TRE SORGENTI LETTI RIGA PER RIGA — e i tre scarti

## 3.1 `ZetaBurst Scalper EA` / `PulseStrike Scalper` — **SCARTO**, e sono LO STESSO FILE

```
NOME            ZetaBurst Scalper EA  ==  PulseStrike Scalper - Statistical Burst Detection EA
FONTE / URL     https://www.mql5.com/en/code/77220  e  https://www.mql5.com/en/code/77167
AUTORE / DATA   RanaAli878 (utente /en/users/ranaali878) — 2026.09.10 e 2026.09.09
POPOLARITA'     [NON MISURATO] (contatori in JS)
LICENZA         #property copyright "Article demo EA" — nessuna licenza dichiarata -> NOLICENSE
RIGHE / INPUT   482 righe / 24 input
ARCHIVIATO      biblioteca/sorgenti/ZetaBurstScalper_RanaAli878-NOLICENSE_mql5code77220_2026-09-13.mq5
```

**FATTO NUOVO, VERIFICATO: i due ID sono lo STESSO FILE BYTE PER BYTE.**
`md5sum` = `0d1ad42e8bef432b2b99bceca1ab8b41` su entrambi, `diff` vuoto,
20.306 byte identici. Stesso autore, pubblicati a **un giorno di distanza**
sotto due nomi diversi. L'intestazione interna del file scaricato da 77220
dice `PulseStrike_Scalper.mq5` e i commenti d'ordine dicono `"PulseStrike"`.
**Chi conta i candidati del Code Base per titolo li conta doppi.**

**TESI IN UNA RIGA:** _"guadagna perche' un movimento che e' un outlier
statistico a 4 secondi contro la distribuzione dei 120 outlier precedenti
continua (o rimbalza), e si prende la coda."_

**MECCANICA (letta nel sorgente):** buffer di tick degli ultimi
`InpBurstWindowSeconds = 4` secondi (r.257); ogni 4 secondi la variazione della
finestra entra in uno storico di `InpStatsSampleCount = 120` campioni (r.272-284);
`GetBurstZScore` (r.292-312) calcola `z = (currentMove - mean)/stddev`; ingresso
se `|z| >= 3,0` (r.387). `InpModeIsMomentum` (r.394-395) decide **con** o
**contro** il burst. TP = `0,35 x ATR`, SL = `0,55 x ATR` del TF del grafico
(r.402-403). Ordine a mercato **senza** stop, poi `PositionModify` sul prezzo di
fill reale (r.431-432, r.448-452) e **se il modify fallisce chiude la posizione**
(r.455-458).

**BANDIERE ROSSE del §4, controllate una per una:**

| bandiera | esito |
|---|---|
| martingala / raddoppio | **NO** — `lot = riskAmount / (slDistPoints * valuePerPoint)`, r.422, nessuna dipendenza dall'esito precedente |
| griglia / averaging | **NO** — una posizione per volta, dichiarato e implementato |
| nessuno stop loss | **NO** — stop vero al broker, e chiude se non riesce ad attaccarlo (r.455-458) |
| recovery / hedge | **NO** |
| lotto fisso | **NO** — `InpRiskPercent = 0.5` |
| repaint / look-ahead | **NO** — decide su tick passati; nessun `CopyBuffer` shift 0 su ridisegnanti |
| indicatori esterni | **NO** — solo `iATR` |
| DLL / WebRequest / licenze | **NO** — solo `<Trade/Trade.mqh>` |
| niente sorgente | **NO** — `.mq5` letto |

**LO STOP E' STRUTTURALE, verificato — e la verifica era doverosa** perche' con
uno stop a **pip fissi** la frontiera `stop >= 40 x spread` la deciderebbe il
parametro e non il mercato. `slDist = InpStopLossATRMult * atr` (**r.403**), con
`atr = iATR(_Symbol, _Period, InpVolATRPeriod)` sul TF del grafico (r.141), piu'
un pavimento al minimo del broker `slDist = MathMax(slDist, minStopDist)`
(r.386-388, con `minStopDist` da `SYMBOL_TRADE_STOPS_LEVEL`/`FREEZE_LEVEL`).
**Nessun numero fisso in pip da nessuna parte.** 🟢 **Questo e' l'unico dei tre
sorgenti di oggi con uno stop strutturale vero**, e va detto.

⚠️ **E il nome interno NON e' il titolo pubblicato:** il file scaricato da
`/en/code/77220` (`ZetaBurst Scalper EA`) si chiama dentro
**`PulseStrike_Scalper.mq5`** e firma gli ordini `"PulseStrike"` (r.431-432).

**Il setaccio §4 lo passa pulito. Muore su altro, e su due cose indipendenti:**

**(a) LA SUA PROPRIA SOGLIA DI COSTO E' 8,5 VOLTE PIU' BASSA DELLA NOSTRA — e
si ricava dal sorgente, senza un solo dato di mercato.** Il gate dell'autore
(r.411) e' `tpDist >= spread x InpMinTPToSpreadRatio` con `InpMinTPToSpreadRatio = 3,0`.
Poiche' `SL/TP = 0,55/0,35 = 1,5714`, il gate implica
**`stop/spread >= 3,0 x 1,5714 = 4,71x`**.
Contro il nostro pavimento **DURO di 13,3x**: **passa al 35%**. Contro il
pavimento di lavoro **40x**: **al 11,8%**. Per portarlo a 40x servirebbe
`InpMinTPToSpreadRatio = 40 x 0,35 / 0,55 = 25,45` — a quel punto, su un M1
(il TF per cui l'autore lo ha scritto, dichiarato in testa al file), il TP
dovrebbe valere 25,5 spread, cioe' `0,35 x ATR(M1) >= 25,5 x 0,86 pip` ->
**ATR(M1) >= 62,6 pip**, che su EURUSD non accade. **Sotto il nostro cancello
del costo, su M1 questo EA non entrerebbe MAI.** Bocciato per COSTO, col numero,
come chiede la regola 3 del brief.

**(b) E' M31 (salto statistico) con un altro stimatore — famiglia
GIA' SEPOLTA DUE VOLTE IN CASA, e l'uscita di geometria e' GIA' CHIUSA.**
`REGISTRO_TEST.md`: su **M5**, _"16 celle su 16 sotto il cancello, due mercati"_;
su **M15**, la contro-prova dice _"l'edge per segnale e' una QUANTITA' FISSA DI
ATR (~0,16), non un multiplo fisso di R: allargando lo stop l'edge in R si
diluisce esattamente quanto il costo. **Nessuna geometria salva l'aritmetica.**"_
Questo chiude anche l'unica via di fuga che avrei proposto (_"portalo su H1,
dove lo stop 0,55 ATR passa il 40x"_): allargare lo stop non salva il netto.

**RR strutturalmente sfavorevole, ed e' un terzo motivo:** TP 0,35 ATR contro
SL 0,55 ATR = **RR 0,64**. Richiede **>61% di win rate solo per il pari, prima
dei costi**. Il referto M30 di casa lo dice gia': _"sotto RR 0,70 il win rate
richiesto sale al 62-70%, zona che in casa non ha mai pagato."_

**COSA TERREI (mestiere, non candidato).** Tre pezzi, e sono buoni:
1. **Il gate `TP >= k x spread` scritto DENTRO il motore**, non in un referto a
   posteriori. E' la forma giusta del nostro cancello del costo: si porta k a
   25,45 e il motore si auto-esclude quando il pedaggio non e' pagabile.
2. **Ordine a mercato, POI stop sul prezzo di fill REALE**, con chiusura
   immediata se il modify fallisce (r.448-458). Toglie un'intera classe di
   rifiuti "Invalid stops" sotto ritardo di esecuzione.
3. **`InpModeIsMomentum`: UNA manopola booleana che ribalta la tesi**, con
   l'autore che scrive _"this EA does not assume either is correct"_.
   **Questo tocca il risultato di ieri** (_"su un meccanismo di esaurimento il
   segno lo decide l'ANNO, non il parametro"_): un motore che espone il segno
   come **un solo booleano** e' il modo piu' economico di misurare quella
   dipendenza. **Tenerlo come forma, non come candidato.**

**VERDETTO: SCARTO** — famiglia sepolta due volte + costo proprio a 4,71x
contro un pavimento duro di 13,3x + RR 0,64.

## 3.2 `Market Miner` — **SCARTO: ZERO STOP LOSS IN 861 RIGHE**

```
NOME            Market Miner  ("A multi strategy EA gold mine :)")
NOME INTERNO    CycleTrade.mq5     <- il titolo pubblicato NON e' il nome del sorgente
FONTE / URL     https://www.mql5.com/en/code/74818
AUTORE / DATA   utente `amarfx` — 2026.07.09
                #property copyright "Amarnath Kondiyan Mohan"  (link LinkedIn, r.2-7)
LICENZA         nessuna dichiarata -> NOLICENSE
RIGHE / INPUT   861 righe / 90 input
ALLEGATI        C4GBPUSD1HR.ini, GBPUSD1HRC3_0_5.ini (+ 2 png) -> preset GBPUSD H1
ARCHIVIATO      biblioteca/sorgenti/MarketMiner_amarfx-NOLICENSE_mql5code74818_2026-09-13.mq5
```

**Il nome interno e' `CycleTrade.mq5`** (r.2, verificato aprendo il file):
*"Market Miner — A multi strategy EA gold mine :)"* e' il **titolo di vendita**,
`CycleTrade` e' la cosa. Stesso autore di Code Base **74894**
(`SuperTrend_Amarnath_Kondiyan_Mohan`).

**Perche' l'ho aperto: una collega lo aveva lasciato ESPLICITAMENTE aperto.**
`CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` r.476: _"**fuori C1**: gli `.ini`
allegati sono `C4GBPUSD1HR` -> e' **H1**, non TF basso. (non e' un cadavere: e'
fuori dal MIO perimetro. **Chi batte H1 lo apra**)"_. **Aperto. E adesso si
chiude, con un certificato.**

**SCARTO IMMEDIATO §4, e la prova e' l'assenza:**
```
grep -n -i "PositionModify|SetStopLoss|_sl\b|stoploss"  Market_Miner.mq5   ->   ZERO RIGHE
```
**In 861 righe non esiste nessuno stop loss, ne' reale ne' virtuale.** Tutti e
otto gli invii sono nella forma `trade.Buy(c1_lot, _Symbol, Ask)` /
`trade.Sell(c1_lot, _Symbol, Bid)` (r.336, 371, 442, 477, 548, 583, 654, 689):
**tre argomenti, nessun `sl`, nessun `tp`.**

L'uscita e' un **obiettivo di equity di paniere per magic**:
`c1_targetprice_buy = c1_account_equity_buy + target_amount` (r.325), chiuso
sommando `m_position.Profit() + m_position.Swap()` su tutte le posizioni dello
stesso magic (r.725-745). **Cioe': si chiude quando il PANIERE va in utile, e
non si chiude mai per perdita.** E' la struttura che fa le curve di equity piu'
belle e il drawdown finale che brucia la challenge.

**Conferma indipendente sulla firma di `CTrade::Buy`:** la firma e'
`(volume, symbol, price, sl, tp, comment)`. **Con tre argomenti, `sl = 0` e
`tp = 0` per default di linguaggio.** E in tutto il file c'e' **una sola**
`PositionClose` (conteggio verificato): l'unica uscita e' quella per utile di
paniere.

**BANDIERA 2 — QUATTRO SISTEMI SENZA STOP SULLO STESSO SIMBOLO.**
Quattro "cicli" indipendenti, ognuno col **proprio magic** (`c1=111`, `c2=333`,
`c3=555`, `c4=777`, r.67/83/99/116), la **propria taglia** (`LotSize` …
`LotSize4`, con `AutoLots`/`Lots_Risk` separati) e il **proprio obiettivo di
equity**. Ognuno lavora su un inviluppo con deviazione crescente:
`c2_InpDeviation = 0.3` · `c3 = 0.7` · `c4 = 0.7` (r.74/90/106), passate a
`iEnvelopes(...)` (r.203-207).

> **Precisazione che mi impongo per non dire piu' di quel che c'e':** quelle
> deviazioni sono **larghezze di banda dell'inviluppo**, non passi di griglia, e
> `Distance = 10` (r.107, usato a r.620-623) e' un **filtro d'ingresso** sul
> ciclo 4, non uno step. **Non e' una griglia a passo fisso.**
> 🔴 **Ma l'effetto e' lo stesso, e questo e' `[INFERITO]` dalla struttura:
> quattro sistemi che aprono sullo stesso simbolo, nessuno con uno stop, e che
> chiudono solo quando il PANIERE va in utile, accumulano posizioni contro il
> prezzo nel drawdown.** Funzionalmente e' **mediazione**, per costruzione e non
> per parametro.

**Altre bandiere, per completezza del certificato:**
- **90 input** contro il tetto di casa di ~15: **sei volte**.
- `Account_Risk_percent = 99` (r.62) — 99% dell'equity come parametro di default.
- `LotSize = 0.01` fisso (r.59), `AutoLots = false` di default.

**VERDETTO: SCARTO IMMEDIATO.** Niente stop = scarto immediato, vietato anche
come "intelligence da provare" (brief); e nessuno stop **+** accumulo nel
drawdown e' la combinazione che **brucia** un conto prop (su FTMO e' Forbidden
Practice). **La porta H1 lasciata aperta il 06/09 e' chiusa con un numero: zero
occorrenze di stop in 861 righe, una sola `PositionClose`.**

## 3.2-bis LA LEZIONE DI METODO CHE MARKET MINER REGALA — il grep non e' un verdetto

Su `Market Miner` il grep delle bandiere del §4
(`martingal|grid|averag|recover|hedge|Multiplier`) ha restituito **ZERO
RIGHE**. E la mediazione c'era comunque, nascosta **nella struttura** (quattro
cicli con magic separati) e **nei nomi** (`c1_lot` … `c4_lot`), non nelle parole.

> ## 🔎 CONTROLLO NUOVO, DA FARE SU OGNI CANDIDATO PRIMA DI PROMUOVERLO
> **Aprire le chiamate di apertura e CONTARE GLI ARGOMENTI.**
> `trade.Buy(lot, symbol, price)` -> tre argomenti -> **`sl = 0`**.
> Costa dieci secondi, e su `Market Miner` avrebbe dato il verdetto prima di
> ogni altra lettura. **Il grep trova le parole; gli argomenti trovano i fatti.**
>
> ## 🔎 E IL SECONDO: confrontare il NOME INTERNO col TITOLO PUBBLICATO.
> `Market Miner` -> `CycleTrade.mq5`. `ZetaBurst Scalper` -> `PulseStrike_Scalper`.
> **Quando divergono, il titolo e' marketing e il sorgente e' il fatto.**
> Due candidati su tre, oggi, divergono.

## 3.3 `Heikin Ashi Engulfing` — **SCARTO: funzione martingala nel codice**

```
NOME            Heikin Ashi Engulfing  (due file: _buy_ e _sell_)
FONTE / URL     https://www.mql5.com/en/code/35628
AUTORE / DATA   traderonemax — 2021.07.14
LICENZA         nessuna dichiarata -> NOLICENSE
RIGHE / INPUT   8.213 righe (UTF-16, decodificato) / 24 input
ARCHIVIATO      biblioteca/sorgenti/HeikinAshiEngulfingBuy_traderonemax-NOLICENSE_mql5code35628_2026-09-13.mq5
```

Aperto perche' e' **pro-trend** (la famiglia che il risultato di ieri NON
condanna) e perche' non aveva **nessuna** menzione in repo.

🔴 **E' materiale di un VENDITORE COMMERCIALE, scritto nell'intestazione:**
`#property copyright "https://payhip.com/forexeas"` e `#property link` uguale
(**r.2-3**, verificato). Cioe': quello che sta nel Code Base e' la vitrina
gratuita di un negozio. **Non e' motivo di scarto da solo** (il sorgente c'e' e
si legge), ma va dichiarato.

**BANDIERE ROSSE, tutte nel sorgente:**
- r.826: `else if (VolumeMode == "martingale") {lots = BetMartingale(Group, Symbol, mmTradesPool, mmMgInitialLots, mmMgMultiplyOnLoss, mmMgMultiplyOnProfit, ...)}`
  e r.3165 `double BetMartingale(` -> **martingala implementata, con
  `MultiplyOnLoss`.** Scarto §4, prima riga della tabella.
  ⚠️ **Onesta' su cosa e' esattamente:** la martingala e' **UNA** delle ~11
  modalita' selezionabili di `VolumeMode` (r.809-826: `fixed`, `block-equity`,
  `equityRisk`, … , `martingale`), non il default. **Cioe' e' un modulo
  OPZIONALE ma PRESENTE.** 🔴 **Resta scarto, e la ragione e' di rischio, non di
  lettera: un EA che PUO' mediare, in mano nostra e su un conto prop, e' un
  rischio che non serve** — e non c'e' nessun beneficio a tenerlo, visto che il
  motore sotto cade comunque sulle altre tre bandiere.
  **Conteggio verificato: 15 occorrenze** di `martingale|grid|recovery|multipl`.
- r.4323: `//-- Operations with WebRequest` -> chiamate di rete.
- r.1331: `iCustom(Symbol, Period, "Examples\\Heiken_Ashi")` -> dipendenza da
  indicatore esterno.
- `inp2_VolumeSize = 0.01` **lotto fisso**; `inp2_StopLossPips = 50.0` /
  `inp2_TakeProfitPips = 50.0` -> **stop a pip FISSI, non strutturale** (il
  brief chiede stop strutturale).
- **8.213 righe generate da un costruttore visuale** (prefisso `FXD_`): costo di
  validazione molto superiore al valore atteso.

**VERDETTO: SCARTO** (§4 quattro volte).

---

# 4. GLI SCARTI DA SCHEDA — una riga di motivo a testa

Tutti con scheda **aperta** (HTTP 200) e descrizione dell'autore **letta**.
Nessuno letto nel sorgente: il motivo di scarto e' visibile prima, e lo dico.

| ID | titolo | motivo dello scarto |
|---|---|---|
| **60413** | `EXSR` (kienasiy123, 2025.06.13) | **doppione ⬛**: contro-trend su estremi RSI + rottura di Bollinger = **M14 fade della banda**, CIMITERO due volte (R108/R111 **6 finestre su 6 rosse**, gradiente H1>M30>M15; R60 **12 celle su 12 in perdita**). In piu' `fixed SL/TP` dichiarato dall'autore = **stop non strutturale** |
| **54611** | `Outbreak Trader 1.0` (deinschanz, 2025.08.11) | **doppione ⬛**: _"trades breakouts from the range"_ = **M1 ORB nudo**, ~**210 celle a tick**, R45 **0/48**, R12 **48/48 negative OOS**. Capitolo chiuso a verbale il 26/07 |
| **70465** | `VR Rsi Robot` (2026) | **doppione + fuori TF**: RSI reversal H1+D1 sincronizzati. Reversione RSI = famiglia di `RSI+EMA V8` (NON PROMOSSO, misurato 03/09); e **H1/D1 non e' TF basso** |
| **52152** | `AdaptiveTrader Pro` | 🔴 **size variabile dichiarata dall'autore**: _"dynamic lot sizing ... performance-based adjustments"_ -> **FTMO Forbidden Practice n.8**. Scarto immediato per brief, senza aprire il sorgente |
| **68125** | `The Playground Series v1-v4` (sugoloki, 2026.01.11) | **doppione ⬛ doppio**: _"experimentation with Fair Value Gaps (FVGs) and liquidity concepts"_. FVG gia' setacciato (`KsqFairValueGapEA`, `FvgContinuationFramework` in biblioteca); **liquidity = M24**, CIMITERO **TRE volte** (CRT Turtle Soup 0/30 a tick · BreakinBox PF 1,007 DD 24,1% · LiquiditySweep chiuso da R89) |
| **61921** | `Seven strategies in One expert` | **sette motori in un file**: §5.A, manopole molto oltre il tetto ~15; e un multi-strategy non e' un meccanismo, e' un catalogo |
| **50850** | `Raymond Cloudy Day For EA` | **e' un indicatore di pivot** (_"integrates a cutting-edge calculation method ... surpassing traditional Pivot Points"_), linguaggio commerciale, e la geometria dei livelli e' chiusa; oltre: pivot = M23/M24 travestito |
| **57272 · 51014** | `Triangular Arbitrage` · `Arbitrage Triangle EURGBP-EURUSD-GBPUSD` | **non testabile con la nostra pipeline**: servono **tre simboli simultanei** in una corsa, che lo Strategy Tester non da' nel modo che ci serve. Costo di validazione > valore atteso |
| **77232 · 77234 · 77236 · 77200 · 76793 · 76794 · 76811 · 76813 · 77128** | famiglia `GDS Renko …` (9 titoli) | **lapide delle barre alternative (01/09)**: barre a soglia di prezzo, **il tempo sparisce e con lui la frequenza in op/giorno**. E sotto c'e' Donchian/ADX/MA = breakout ⬛ |
| ~**200 titoli** | `RiskPilot`, `Trade Guardian`, `GridCapitalCalculator`, `Quantora*` (7), `XP Forex Trade Manager`, `Position Size*`, `Close All*`, `Trailing*`, pannelli, logger, copier, ONNX | **non sono motori**: sono pannelli, calcolatori, utility, logger. Fuori perimetro per costruzione |
| ~**30 titoli** | `XANDER Grid`, `RSI Grid EA Pro`, `BGC Grid`, `Sideways Martingale`, `Daily Zone Recovery`, `Sniper Gold Hybrid Recovery`, `VR Locker Lite`, `Grid Master`, `Simple_Grid`, `Martingale Pulse`, `MT5-BuildYourGridEA`, `Breakout Martin Gale`, `MA Grid Trade`, `Long and Short Stepped Grid`, `VIDYA N Bars Borders Martingale`, `MACD Four Colors 2 Martingale`, `KSU_martin`, `HedgeCover`, `Martingale Levels`, `XANDER Gold Recovery`, `Basket Protective Close`, `VR Locker`, … | **§4 nel TITOLO**: martingala / griglia / recovery / hedge di copertura / lock. Scarto immediato, vietati anche come intelligence |

**Gia' setacciati in cacce precedenti, NON ricontrollati** (regola: cio' che e'
gia' stato setacciato non si ricontrolla): `76153`, `76331`, `76333`, `75586`,
`75301`, `74148`, `74840`, `74582`, `74379`, `74137`, `73958`, `73884`, `73711`,
`73674`, `73638`, `71467`, `70796`, `70052`, `68951`, `68704`, `68512`, `68082`,
`62742`, `60413`, `58135`, `57020`, `56773`, `53022`, `52105`, `49770`, `49713`,
`49272`, `43278`, `43252`, `41732`, `39012`, `77206`, `77094`, `77009`, `77060`,
`76927`, `76950`, `76951`, `76972`, `76947`, `76934`.

---

# 5. TABELLA SEPARATA — INDICI: nessun candidato nuovo, e il perche'

Il brief chiedeva una tabella separata _"esclusi per costo su M5, da rivalutare
su M30/H1"_ col rapporto `stop/spread`. **La tabella e' VUOTA: in questa battuta
non e' emerso nessun motore su indice nuovo e non-doppione da collocarci.**
I titoli su indice trovati (`AAPL cfd - ORB strategy` 76333, `Session Opening
Range Breakout EA` 76153, `Easy Range Breakout` 71460/68764, `Outbreak Trader`
54611, `Indices Testing/Tester` 48139/48137) sono **tutti ORB/range breakout**,
cioe' la famiglia con ~**210 celle a tick** in casa.

**Il numero di riferimento per chi ci tornera'**, dagli spread MISURATI in
sessione (`SPREAD_FLOTTA_MISURA_2026-09-03.md` via `CANCELLO_COSTO_FLOTTA`):
D30EUR **1,6-1,7** · NASUSD **1,6-1,8** · U30USD **1,9-2,0** punti indice.
Per il 40x servono stop di **68 / 72 / 80 punti indice**. L'ATR M30 del DAX vale
**25-40 punti** -> **anche M30 sul DAX non arriva al 40x con un solo ATR di
stop**; ci arriva con 2 ATR. **Su M30 il vincolo di casa e' l'EDGE, non il
costo** (referto M30 del 05/09), e questo va tenuto presente prima di
riaprire la famiglia.

---

# 6. IL MATERIALE H1 RACCOLTO PRIMA DEL RIORIENTAMENTO (in fondo, come chiesto)

- `Market Miner` (74818): era il bersaglio H1 della battuta -> **§3.2, scarto
  per zero stop**. Chiude una porta lasciata aperta il 06/09.
- Nessun altro candidato H1 e' arrivato al sorgente prima del riorientamento.

---

# 7. COSA NON HO POTUTO VEDERE — buchi dichiarati

1. **TradingView: non aperta.** Buco vero di questa battuta (§1). E' la fonte
   piu' ricca di price action a TF basso sul forex, ed e' **il primo posto dove
   andrebbe la prossima battuta**, con la clausola del brief: Pine -> MQL5 e'
   una **riscrittura**, non un porting.
2. **SSRN 403 · Quantpedia 308/502 · GitHub UI 403 · Forex Factory 403 ·
   arXiv API timeout**: non aggirati, non sostituiti con la memoria.
3. **Popolarita' delle schede Code Base [NON MISURATO]** (contatori in JS).
4. **Lo spread forex BCM e' UNA lettura, di UN istante, di UN'ora** (17/08
   17:34 server) — e per parecchi simboli **quell'ora non e' l'ora in cui una
   sedia lavorerebbe**. **Tutto il §2 poggia su quella lettura + una legge di
   commissione.** Su **AUDUSD, EURAUD, GBPJPY, CHFJPY la sonda legge 0 = nessun
   tick**, quindi il costo e' **[NON MISURATO]** e quelle coppie non sono
   valutabili oggi.
5. **Gli stop tipici M30 sul forex sono [NON MISURATO]**: i numeri di casa che
   ho sono M5 (8 pip) e M15 (10,8 pip) su EURUSD. **Il M30 l'ho lasciato vuoto
   invece di estrapolarlo**, ed e' proprio il TF dove il conto si deciderebbe.

---

# 8. LA MOSSA PIU' ECONOMICA CHE ESCE DA QUESTA BATTUTA

**Non e' un EA: e' una misura, e costa poco.** Tutto il §2 — cioe' la risposta
alla domanda di Claudio sul TF basso — poggia su **una lettura istantanea di
spread del 17/08 alle 17:34 server** piu' una legge di commissione. Se GBPUSD
nella fascia di lavoro fosse **0,5** invece di **0,2**, la soglia del 40x
passerebbe da **26,8** a **38,8 pip** e il bersaglio M30 sparirebbe.

**Lo strumento esiste, e' gratis, e' nel Code Base, ed e' stato promosso in casa
il 23/08 e MAI USATO** — segnalato come _"la mossa piu' economica"_ da **sette
cacce di fila**:

```
NOME     RealCost Spread P95 Logger MT5
URL      https://www.mql5.com/en/code/74148        (scheda HTTP 200, aperta oggi)
AUTORE   a1066832477 — 2026.06.20
COSA FA  media, p50, p90, p95, p99, massimo dello spread + export CSV
FILE     /en/code/download/74148/RealCostSpreadP95LoggerMT5.mq5
```

**Proposta (decide Claudio): farlo girare su GBPUSD, EURUSD, USDJPY nelle fasce
di lavoro** e sostituire nel §2.3 le colonne `[LETTURA UNICA]` e `[INFERITO]`
con numeri misurati. **Costo in passate di tester: ZERO** (e' un logger dal
vivo, non una griglia). **Bersaglio della stringa: [DA DECIDERE CON CLAUDIO] —
e va nominato per numero di conto e cartella, regola dei terminali multipli.**

---

# 8-bis. LA CORSIA FIRMATA DELLE 03:30 — vincolo di FORMA, per la prossima battuta

**Oggi non lo uso perche' non consegno file prova.** Lo scrivo qui perche' e' il
vincolo che decide se un file prova **entra** nella coda notturna senza chiedere
niente a Claudio, e la prossima battuta deve nascere gia' conforme.

La lista bianca della corsia firmata accetta **esattamente sei parametri**:
```
-Expert   -Prova   -Etichetta   -Modello   -Deposito   -SoloControllo
```
🔴 **NON accetta** `-Spread`, `-DaQuando`, `-Fino`, `-FrazioneIS`, `-Ritardo`.

👉 **Conseguenza di scrittura: se un round ha bisogno di una finestra
temporale, la finestra va DENTRO il file prova** come direttiva
`@DAQUANDO` / `@FINOA` — **non sulla riga di lancio**, o la riga non entra nella
corsia e serve una firma.

⚠️ E `@DAQUANDO` **non si inventa**: senza la data d'inizio storico **misurata**
(`scarica_storico.ps1`), la riga si lascia **vuota** e si dichiara. Precedente
di casa: sugli indici il driver diceva `2024.01.01` e i dati partivano dal
**26/09/2024** — meta' finestra IS non esisteva.

---

# 9. LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Non _"quale altro motore a TF basso"_. Questa:

> ## Su GBPUSD — il major piu' economico che abbiamo (all-in ~0,67 pip) — a quale TIMEFRAME lo stop strutturale arriva a 26,8 pip, cioe' al pavimento di lavoro 40x?
>
> Perche' **quello**, e non M5 ne' M15 su EURUSD, e' il TF basso che ci e'
> davvero aperto. E una volta trovato, sul forex quel motore puo' fare **150
> posizioni per lato subito** (storico a gennaio 1999) **e** le quattro finestre
> della prova di regime — le due cose che sugli indici, con 21 mesi di un solo
> toro, non possiamo avere.

---

## Firma di onesta'

**Zero EA promossi. Zero file prova consegnati — ed e' voluto:** un file prova
senza candidato sarebbe una griglia a caso, e il brief vieta di fingere un file
prova eseguibile. **Un finding mio e' stato ucciso da me stesso** (§2.2), e sta
scritto perche' valga da avvertimento.

Nessun EA scritto, nessun backtest eseguito, nessun forward toccato, nessun
rischio o taglia deciso.
