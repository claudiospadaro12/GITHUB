# BROKER ESTERNO - MAPPA E AVVERTENZE (14/08/2026)

> ## 🟢 15/08/2026 ore 13:59 — IL CONTO DEMO PEPPERSTONE ESISTE ED E' COLLEGATO
>
> `conto_attivo.ps1` sul PC legge dal Giornale:
>
> ```
> --- cartella 73B7A2420D6397DFF9014A20F1201F97 ---
>   CONTO ATTIVO : 62128200    server: PepperstoneUK-Demo through LD2-O
> ```
>
> **Il blocco di ieri sera e' superato.** Il 14/08 il Giornale diceva
> `Invalid account` e "no demo/preliminary groups on server side", e il
> ricognitore era andato in timeout con 0 file. Adesso il terminale
> (`C:\Program Files\Pepperstone MetaTrader 5`) e' loggato sul **62128200**.
>
> Il terminale e' pero' **nuovo e quasi inutilizzato**: 3 file di giornale,
> **zero** log esperti. Il prossimo passo e' il ricognitore `-SoloElenco`, che
> da' i **nomi veri dei simboli** e il **fuso misurato** — le due cose senza cui
> non si scarica niente.
>
> **Attenzione al motivo del timeout di ieri**: lo script apre un grafico per
> far girare lo script MQL5, e ieri gli era stato passato `-SimboloGrafico
> "EURUSD.p"`, un nome preso dallo snapshot del server VECCHIO. Se il simbolo
> non esiste, MT5 non apre niente e si va in timeout. Il default e' `EURUSD`:
> se fallisce di nuovo, il nome vero si legge in dieci secondi nel **Market
> Watch** di quel terminale.

> ## 🟡 15/08/2026 ore 14:55 — PRIMA RICOGNIZIONE FATTA, MA TAGLIATA A 9/1722
>
> Referto completo: `backtest_pipeline/risultati_archivio/REFERTO_RICOGNIZIONE_PEPPERSTONE.md`
> Dati grezzi: `backtest_pipeline/risultati_prove/pepperstone_ricognizione/`
>
> **Il buono, misurato:** `PepperstoneUK-Demo` e' a **UTC+0**
> (`TimeTradeServer - TimeGMT = +00:00`, letto alle 12:53:43 server).
> Conto **62128200**, DEMO, valuta **EUR**, **1722** simboli (**120** in
> Market Watch).
>
> **Il taglio:** la scansione si e' fermata a **9 simboli su 1722**, perche'
> il driver PowerShell trattava 60 s di silenzio come "ha finito" e `AUDCHF`
> (nessun dato) ha tenuto lo script fermo **69,5 s**. Corretto lo stesso
> giorno: il segnale di fine adesso e' la riga `=== FINITO` dello script,
> la soglia di silenzio sale a 300 s, e c'e' `-SoloMarketWatch`.
>
> **Quindi NON e' vero, e non va scritto da nessuna parte, che Pepperstone
> "non ha gli indici": non li abbiamo ancora guardati.**
>
> **Due allarmi da ignorare, entrambi difetti nostri (corretti oggi):**
> - `ATTENZIONE: L'ORA DI APERTURA CAMBIA DI +0 ORE` = falso. Erano **5
>   minuti** (00:00 vs 00:05) su AUDUSD, stampati con la divisione intera.
>   E il DST non si misura su un cambio: serve un **indice**.
> - `PrimaData 1993.04.xx` su tre simboli = falso: l'attesa della risposta
>   del server e' di soli **2 secondi**. Per questo il **2023.01.02** di
>   EURUSD/GBPUSD/USDCHF/USDJPY resta **[INCERTO]** e va riverificato prima
>   di dichiarare che il 2022 e il 2020 su Pepperstone non ci sono.
>
> **Il fuso NEL PASSATO resta ignoto**: l'export H1 e' uscito con la sola
> intestazione (0 barre), perche' `InpSimboloFuso` era vuoto ed e' finito su
> AUDUSD, che quei mesi in locale non li aveva.

> ## 🎉 15/08/2026 ore 15:11 — GLI INDICI CI SONO: il Dow su Pepperstone e' `US30`
>
> Secondo giro, con `-SoloMarketWatch`. **[VERIFICATO]**
>
> | | BCM | Pepperstone |
> |---|---|---|
> | Dow | `U30USD` | **`US30`** — "US Wall Street 30 Index", digits 1, point 0,1, contract 1,00, spread 20 pt |
>
> Da qui si intuisce la famiglia (DAX `GER40`/`DE40`, Nasdaq `NAS100`/`US100`),
> ma **restano da LEGGERE, non da indovinare**: la regola della mappa non cambia.
>
> **[VERIFICATO] Il DST: `SERVER ALLINEATO AL DST DEL MERCATO`** — apertura
> 00:00 su **17 date campione** da apr 2024 a lug 2026. L'allarme del primo
> giro era un artefatto da 5 minuti. Limite onesto: misurato su **EURUSD**,
> cioe' un cambio, che apre 00:00 ovunque. La misura vera va fatta su `US30`.
>
> **[VERIFICATO] Le prime date dei cambi: 2023.01.02** — EURUSD, GBPUSD e
> USDJPY danno lo stesso numero in **due corse** a 12 minuti di distanza
> (22.524 barre H1, 939 D1). Invece USDCAD (1993.04.28 -> 2026.07.29) e AUDUSD
> (2026.01.02 -> 2025.07.17) **cambiano fra le due corse**: quelle erano
> spazzatura, e la riserva del primo giro era giustificata.
> ⚠️ **La prima data di `US30` non e' ancora stata misurata**, ed e' quella che
> decide se la prova di regime su Pepperstone si puo' fare.
>
> **Anche il secondo giro e' stato tagliato: 7 simboli su 120.** Sei cambi in
> **0,15 secondi**, poi **312,9 secondi** fermo su US30. La causa non era la
> soglia del driver: dentro uno **script** MQL5 `CopyRates` su una serie non
> sincronizzata **blocca**. Corretto togliendola dalla scansione
> (`InpNonBloccare=true`, letture con `SeriesInfoInteger`, SECONDO GIRO per le
> date mancanti, tetto interno `InpMaxSecScansione=600`, nuovo stato
> **`da svegliare`** al posto di `NESSUN DATO`).
>
> **`da svegliare` non vuol dire "il broker non ce l'ha".** Confondere le due
> cose avrebbe cancellato US30 dal catalogo.
>
> **Terzo difetto**: l'export H1 e' uscito vuoto **due volte su due** perche'
> `EsportaH1` aveva `!IsStopped()` nell'intestazione del ciclo — a terminale in
> chiusura il primo `CopyRates` non partiva **nemmeno una volta**, mentre
> EURUSD aveva 22.524 barre in cache. Corretto: il primo tentativo si fa sempre.

> ## 🔴 15/08/2026 ore 15:34 — TERZO GIRO: il colpevole non era CopyRates
>
> US30 si e' bloccato **913,1 secondi** (15 min 13 s) **con CopyRates gia'
> tolto dalla scansione**. Sei cambi in 0,134 s, poi il muro. La sequenza dei
> tre giri e' la prova: 69,5 s (AUDCHF) -> 312,9 s (US30) -> **913,1 s** (US30).
> Ogni volta avevamo alzato la soglia del driver invece di curare la causa.
>
> **A bloccare e' `SeriesInfoInteger(SERIES_SERVER_FIRSTDATE)`**: se la storia
> non c'e', la chiede al server e ASPETTA. A mercato chiuso, oltre il quarto
> d'ora per UN simbolo.
>
> **Correzione: `InpSondaStorico=false` di default.** La scansione elenca i
> NOMI (nome, descrizione, digits, point, contract, tick value, spread) e non
> tocca la storia. Le date si chiedono dopo, con `-SondaStorico` e `-Filtro`
> stretto, possibilmente a mercato aperto.
>
> **✅ Export H1 riparato: 1032 barre** di EURUSD (480 SOLARE gen-2025 + 552
> LEGALE lug-2025). E' meta' del confronto: **manca il lato BCM**, e finche'
> manca lo shift storico fra i due feed resta ignoto.
>
> **📅 USDCAD in tre corse ha detto 1993.04.28, poi 2026.07.29, poi 2026.01.02.**
> Tre risposte diverse in 26 minuti. Per questo il **2023.01.02** di EURUSD,
> GBPUSD e USDJPY si scrive: e' identico in **tre corse su tre**, con 22.524
> barre H1 e 939 D1 sempre uguali.

> ## 🛤️ 15/08/2026 — "LO STORICO PEPPERSTONE LO POSSIAMO CARICARE SU BCM?"
>
> Domanda di Claudio. **Si', e la macchina c'e' gia'.** Ma le strade sono due
> e non sono equivalenti.
>
> ### A) Testare DIRETTAMENTE sul terminale Pepperstone
> `walkforward_generico.ps1 -Expert ... -BrokerPattern "Pepperstone" -Simbolo "US30"`
> esiste dal 14/08. Zero conversione: prezzi, spread, specifiche e storico
> vengono tutti dallo stesso broker, quindi sono coerenti fra loro.
> **Costo:** gli orari dei nostri EA sono in ORA SERVER BCM. Su un server a
> UTC+0 vanno RIMAPPATI, e oggi il numero che avremmo per farlo e'
> **[INFERITO], non misurato**.
>
> ### B) Importare in BCM come `US30_EXT`  ← **RACCOMANDATA**
> `ABTG_ImportaStoricoEsterno.mq5` crea il simbolo custom clonando le
> proprieta' di `U30USD` (digits, point, contract size, tick value) e
> **CALIBRA DA SOLO lo shift orario** confrontando le chiusure H1 importate
> con quelle native BCM (`CustomSymbolCreate` + `CustomRatesUpdate`).
>
> **Due vantaggi, e il secondo e' quello che decide:**
> 1. BCM ha `U30USD` **dal 26/09/2024**: sono **21 mesi di sovrapposizione**
>    con Pepperstone. Lo shift non si stima, si **misura** su ventun mesi di
>    barre comuni.
> 2. **Gli orari degli EA non si toccano.** Il simbolo custom vive nel fuso
>    BCM per costruzione: `InpSessionHour=8` resta 8. La domanda "che ora e'
>    sul server?" esce dal problema — ed e' esattamente il punto dove un
>    errore di un'ora rende spazzatura ogni verdetto.
>
> **Il pezzo che manca:** `ABTG_HistoryDownloader.mq5` scarica lo storico
> DENTRO MT5 ma **non esporta le barre in CSV** (scrive solo un riepilogo).
> Serve un esportatore lato Pepperstone che scriva il **formato 1**
> (`YYYY.MM.DD HH:MM,open,high,low,close,volume`), quello che
> `ABTG_ImportaStoricoEsterno` gia' legge. E' da scrivere.
>
> ### ⛔ MA NON SI SCRIVE ADESSO
> Prima serve sapere se `US30` su Pepperstone **arriva davvero al 2020/2022**.
> Se parte dal 2023 come i cambi (EURUSD/GBPUSD/USDJPY, confermato 3 corse su
> 3), tutta questa strada non porta da nessuna parte e l'esportatore sarebbe
> lavoro buttato. **Ordine: nomi -> prima data degli indici -> esportatore.**
>
> ### I limiti, validi per ENTRAMBE le strade
> 1. **Prova di regime, non taratura** (regola gia' congelata in
>    `report/ASPETTATIVE_REALISTICHE.md`): _"un parametro pescato qui e'
>    PEGGIO di nessun test, perche' sembra validato"_.
> 2. **Spread e commissioni sono quelli del tester, non quelli storici.** R55
>    ha appena misurato che sull'ORB **1,5 punti indice sfondano il cancello
>    del 10%**: su un test di regime dell'ORB il P&L NON si legge, si legge
>    solo "sopravvive o no".

**Stato: SCHELETRO DA COMPILARE.** Le tabelle qui sotto sono vuote apposta:
si riempiono con l'elenco VERO prodotto da `ABTG_InfoBroker`, non con nomi
plausibili. Finche' una riga non ha la data nella colonna "verificato il",
quella riga NON si usa in nessun test.

---

## 1. Perche' esiste un secondo broker

Lo storico BCM sugli INDICI parte dal **26/09/2024**: 21 mesi e un solo
regime (indici in salita). La prova di regime
(`backtest_pipeline/prove/PROVA_REGIME_CRITERI.md`) chiede il **2022**
(orso + inflazione) e il **2020** (crollo Covid). Sul forex quegli anni si
recuperano gratis via HistData (`importa_storico_esterno.ps1`); **sugli
indici no**: servono i dati di un broker che li abbia, e la demo
Pepperstone li ha.

Regola d'uso, la stessa del feed importato: **prova di regime, non
taratura**. I parametri restano quelli scelti su BCM.

---

## 2. Gli attrezzi

| File | Cosa fa |
|---|---|
| `mql5/Scripts/ABTG_InfoBroker.mq5` | ricognitore: elenca i simboli VERI del broker, misura l'offset del server, la tabella "apertura per stagione", ed esporta le chiusure H1 per il confronto fra feed |
| `backtest_pipeline/prepara_broker_esterno.ps1` | driver: trova i terminali, installa/compila, lancia, confronta i due fusi, stampa la rimappatura degli orari, raccoglie tutto sul Desktop |
| `backtest_pipeline/walkforward_generico.ps1 -BrokerPattern "..."` | fa girare un walk-forward sul terminale scelto (default "BCM" = come sempre) |

Sequenza minima (PC di backtest, **MT5 chiuso**):

```
:: 1. misura il RIFERIMENTO BCM (una volta sola)
powershell -ExecutionPolicy Bypass -File .\prepara_broker_esterno.ps1 -BrokerPattern "BCM" -SoloElenco -Auto -Filtro "D30EUR" -SimboloFuso "D30EUR" -SimboloGrafico "D30EUR"

:: 2. ricognizione del broker nuovo (PRIMA di scaricare qualsiasi cosa)
powershell -ExecutionPolicy Bypass -File .\prepara_broker_esterno.ps1 -BrokerPattern "Pepperstone" -SoloElenco -Auto

:: 3. scarico storico dei simboli VERI letti al passo 2
powershell -ExecutionPolicy Bypass -File .\prepara_broker_esterno.ps1 -BrokerPattern "Pepperstone" -Simboli "GER40,US30,NAS100" -Da 2018.01.01 -SimboloFuso "GER40" -SimboloGrafico "GER40" -Auto
```

**Sul VPS `-Auto` e `-ChiudiMT5` non si usano mai**: chiuderebbero i
terminali che tengono su gli EA in forward.

---

## 3. MAPPA DEI SIMBOLI: BCM -> broker esterno

Da compilare leggendo l'elenco prodotto dal ricognitore
(`ABTG_InfoBroker_<broker>.csv`, sezione `[SIMBOLI]`). Il driver propone
dei **candidati**, ma un nome simile puo' essere un future con scadenza,
un mini, o lo stesso indice quotato in un'altra valuta: la conferma si da'
guardando **descrizione, contract size, tick value e prima data**.

| BCM | Che cos'e' | **Pepperstone** | Digits | Point | Contract | Spread pt (weekend) | Prima data D1 | Verificato il |
|---|---|---|---|---|---|---|---|---|
| D30EUR | DAX 40 | **GER40** "Germany DAX 40 Index" | 1 | 0,1 | 1,00 | 9 | **da misurare** | 15/08/2026 |
| U30USD | Dow Jones 30 | **US30** "US Wall Street 30 Index" | 1 | 0,1 | 1,00 | 20 | **da misurare** | 15/08/2026 |
| NASUSD | Nasdaq 100 | **NAS100** "US Tech 100 Index" | 1 | 0,1 | 1,00 | 10 | **da misurare** | 15/08/2026 |
| 225JPY | Nikkei 225 | **JPN225** "Japan 225 Index" | 1 | 0,1 | **100,00** ⚠️ | 80 | **da misurare** | 15/08/2026 |
| F40EUR | CAC 40 | **FRA40** "France 40 Index" | 1 | 0,1 | 1,00 | 12 | **da misurare** | 15/08/2026 |
| E35EUR | IBEX 35 | **SPA35** "Spain 35 Index" | 1 | 0,1 | 1,00 | 100 | **da misurare** | 15/08/2026 |
| SPXUSD | S&P 500 | **US500** "US 500 Index" | 1 | 0,1 | 1,00 | 4 | **da misurare** | 15/08/2026 |
| UKOIL | Brent | **SpotBrent** "Brent Crude vs US dollar" | 3 | 0,001 | 100,00 | 32 | **da misurare** | 15/08/2026 |
| USOIL | WTI | **SpotCrude** "WTI Cash (or Spot) Contract" | 3 | 0,001 | 100,00 | 24 | **da misurare** | 15/08/2026 |
| XAUUSD | Oro | **XAUUSD** (stesso nome) | 2 | 0,01 | 100,00 | 17 | **da misurare** | 15/08/2026 |
| XAGUSD | Argento | **XAGUSD** (stesso nome) | 3 | 0,001 | 5000,00 | 23 | **da misurare** | 15/08/2026 |

**Altri indici disponibili** (non ci servono oggi, ma ci sono): UK100 (FTSE 100,
18), AUS200 (20), EUSTX50 (17), CN50 (100), HK50 (50), US2000 (3), VIX (17),
SCI25 (4), CA60 (80), CHINAH (1200), NETH25 (26), SWI20 (500), USDX (54).

> ⚠️ **DUE AVVERTENZE SU QUESTA TABELLA**
>
> 1. **Gli spread sono letti a MERCATO CHIUSO** (sabato 15/08, `MercatoAperto,NO`):
>    sono i valori larghi del weekend, **non** quelli operativi. Vanno rimisurati
>    a mercato aperto prima di usarli in qualunque conto. Detto questo, il numero
>    da tenere d'occhio c'e' gia': **US30 a 20 punti = 2,0 punti indice**, e
>    R55 ha misurato che sull'ORB **1,5 punti indice sfondano il cancello del
>    10%**. Se anche a mercato aperto restasse sopra 1,5, l'ORB su questo feed
>    non e' testabile in modo onesto.
> 2. **`JPN225` ha ContractSize 100**, mentre tutti gli altri indici hanno 1.
>    Un lotto li' vale cento volte. Il calcolo `lotto = R / distanza_stop` va
>    rifatto, non copiato.
>
> **Le prime date NON sono in questa tabella perche' non sono state misurate.**
> Chiederle al server blocca lo script (misurato: 913 s su US30 a mercato
> chiuso). Si misurano a parte, su pochi simboli e a mercato aperto.

> Attenzione al **contract size**: se sul broker esterno un lotto di DAX
> vale 25 EUR/punto invece di 1, il profitto in valuta non e' confrontabile
> nemmeno vagamente, e il calcolo del rischio degli EA cambia. Va scritto
> in tabella, non "si vedra' poi".

---

## 4. FUSO

### 4.1 Quello che dice la fonte (dichiarato, non misurato)

| Broker | Offset dichiarato | Segue il DST di |
|---|---|---|
| Pepperstone | GMT+3 da marzo a novembre, GMT+2 il resto dell'anno | **Stati Uniti** (daily allineate alla giornata di New York) |
| BCM | "ora italiana - 1" -> GMT+1 in estate | **DA VERIFICARE**: la regola non e' mai stata controllata d'inverno |

Differenza **attesa** oggi (agosto): Pepperstone = BCM **+2 ore**.
Quindi DAX 08:00 BCM -> 10:00 Pepperstone, apertura USA 14:30 BCM -> 16:30
Pepperstone. **Atteso, non verificato**: il numero buono e' quello del
punto 4.3.

### 4.2 Perche' un solo numero non basta

USA ed Europa cambiano ora in **date diverse**:

| | Inizio ora legale | Fine ora legale |
|---|---|---|
| USA | 2a domenica di marzo | 1a domenica di novembre |
| Europa | ultima domenica di marzo | ultima domenica di ottobre |

Ne escono **due finestre l'anno** (circa 2 settimane a marzo, circa 1
settimana fra fine ottobre e inizio novembre) in cui i due server **non
sono allineati** e la differenza vale **un'ora in piu' o in meno** del
solito. Si ripete **ogni anno del backtest**: su 2018-2024 sono sette
volte due finestre.

Conseguenze pratiche:

- una rimappatura con un solo numero e' **giusta per ~11 mesi e sbagliata
  per ~3 settimane**;
- in quelle settimane gli EA a fascia oraria (aperture DAX/Dow/Nasdaq,
  ORB, box notturno, fascia EasyTrend) operano un'ora fuori posto: i
  risultati di quei giorni **non sono validi** e vanno esclusi dal
  conteggio oppure dichiarati esplicitamente nel referto;
- il numero di trade coinvolti e' piccolo (3 settimane su 52), ma se
  cadono su un evento grosso possono spostare un PF: si guarda, non si
  ignora.

### 4.3 Offset MISURATO (da compilare)

Due misure indipendenti, prodotte dagli attrezzi del punto 2.

**(a) Adesso** - `TimeTradeServer() - TimeGMT()` su ognuno dei due
terminali (sezione `[SERVER]` del CSV):

| Terminale | Offset GMT misurato | Misurato il |
|---|---|---|
| BCM | | |
| Pepperstone | **+00:00 (UTC)** | 15/08/2026, quattro corse concordi |
| **Delta (Pepperstone - BCM)** | **da misurare** (BCM non ancora sondato) | |

**(b) Sul passato** - shift che minimizza la differenza fra le chiusure H1
dei due feed, provando da -6 a +6 ore, su due finestre distinte. E'
**l'unica misura valida per il backtest**, perche' l'offset di oggi non
dice niente di com'era nel 2022.
Convenzione: `ora BCM = ora broker esterno + shift`.

| Finestra | Periodo | Shift misurato | Barre H1 confrontate | Diff media |
|---|---|---|---|---|
| ORA SOLARE | 2025.01.06 - 2025.01.31 | | | |
| ORA LEGALE | 2025.07.01 - 2025.07.31 | | | |

> Le finestre stanno dentro il periodo in cui **entrambi** i broker hanno
> dati (BCM sugli indici parte dal 26/09/2024). Se i due shift risultano
> **DIVERSI**, e' la prova che l'offset non e' costante: va scritto qui in
> maiuscolo e riportato in ogni referto che usa questo feed.
>
> Nota di lettura: due feed diversi non quotano identico (dividendi,
> costruzione dell'indice, orari di chiusura). Quello che conta non e' il
> valore assoluto della differenza, ma **quanto e' netto il minimo**: se la
> colonna e' piatta, la misura non ha concluso niente e non ci si appoggia.

### 4.4 Formula di rimappatura

Da riempire con il numero del punto 4.3(b):

```
ora server <BROKER ESTERNO> = ora server BCM + ____ ore
```

Il driver stampa la tabella completa degli input orari con il valore
nuovo. Quella che segue e' l'anagrafica dei valori **BCM** da cui si parte
(elenco non esaustivo: **qualunque** input con `Hour`/`Min` nel nome e' in
ora server):

| EA | Input | Valore BCM | Valore broker esterno |
|---|---|---|---|
| ABTG_DAX_Apertura_EU (+ _Ottimizzato, _Live5m, Apertura_Marco) | InpSessionHour / InpSessionMin | 08:00 | |
| ABTG_Dow_Apertura_US | InpSessionHour / InpSessionMin | 14:30 | |
| ABTG_Nasdaq_Apertura_US (+ _Ottimizzato, _Live5m) | InpSessionHour / InpSessionMin | 14:30 | |
| ABTG_EasyTrend | InpHourStart / InpHourEnd | 08 - 18 | |
| ABTG_MaxMinNotte (+ _DAX_Short_Ottimizzato) | InpBoxStartHour / InpBoxEndHour | 23:00 - 04:59 | |
| ABTG_MaxMinNotte, variante ORO (prove R17/R19) | InpBoxStartHour / InpBoxEndHour | 22:00 - 06:00 | |
| ABTG_Nightly (+ _Ottimizzato) | InpBoxStartHour / InpBoxEndHour | 22:00 - 04:59 | |
| ABTG_ORB (+ _Ottimizzato) | InpRangeStartHour / InpRangeEndHour / InpEndHour | 14:25 - 14:30 - 22:00 | |
| ABTG_ORB_Fibo | InpORStartHour | 14:30 | |
| ABTG_Londra_ORB | InpRangeStartHour / InpRangeEndHour | 06:00 - 07:00 | |
| ABTG_DAX_M3 | InpStartHour / InpEndHour | 08 - 17 | |
| ABTG_SupertrendInvert | InpStartHour / InpEndHour | 07 - 20 | |

---

## 5. APERTURA DI SESSIONE PER STAGIONE (vale anche per BCM)

**La domanda:** a che ora, **sull'orologio del server**, apre il mercato a
gennaio? E a luglio?

- se e' la **stessa ora** -> quel server segue il DST del mercato, e un
  `InpSessionHour` fisso e' corretto tutto l'anno;
- se **cambia** -> quel server ha offset fisso (o un calendario diverso), e
  gli EA a orario fisso operano all'ora sbagliata per meta' anno.

Il ricognitore misura la prima e l'ultima barra M5 di date campione
(15 gennaio, 20 marzo, 15 aprile, 15 luglio, 15 ottobre, 28 ottobre,
20 novembre di ogni anno disponibile). Il 20 marzo e il 28 ottobre sono li'
apposta: cadono nelle finestre di disallineamento del punto 4.2.

| Terminale | Simbolo | Apertura in ora solare (gen/nov) | Apertura in ora legale (apr/lug) | Settimane disallineate (20/03 - 28/10) | Verdetto |
|---|---|---|---|---|---|
| BCM | D30EUR | | | | |
| Pepperstone | (DAX) | | | | |

### 5.1 Il rischio che questa misura serve a chiudere (SOLDI VERI)

La nostra regola interna dice "server BCM = ora italiana - 1", ma con la
postilla *"in questo periodo dell'anno"*: **non e' mai stata verificata
d'inverno**. Se BCM avesse un offset **fisso** mentre l'Europa cambia ora
l'ultima domenica di ottobre, allora **dal 26/10/2026** tutti i nostri
`InpSessionHour` sarebbero sbagliati di un'ora **sugli EA vivi**: DAX 8,
apertura USA 14:30, fasce orarie, box notturno.

Non e' un problema di backtest, e' un problema di produzione. Va misurato
**prima** di quella data e, se il verdetto e' "il server non segue il DST",
va deciso cosa fare: due set di orari stagionali, oppure un input di
correzione DST negli EA a fascia oraria.

- [ ] misura fatta su BCM il ______ - esito: ______
- [ ] decisione presa il ______ - azione: ______

---

## 6. Regole d'uso dei risultati (criteri congelati)

Dal punto 2 di `prove/PROVA_REGIME_CRITERI.md`, e vale identico qui:

1. Il confronto di merito si fa **SEMPRE dentro lo stesso feed**: periodo
   calante contro periodo crescente **sui dati di questo broker**. Mai
   "Pepperstone 2022 contro BCM 2025".
2. Spread e commissioni sono quelli impostati nel tester, non quelli
   storici del broker: su stop stretti puo' spostare il verdetto. Va detto
   ogni volta.
3. **Nessuna taratura di parametri su questo feed.** Le celle si testano
   **congelate**. Un parametro pescato qui e' peggio di nessun test, perche'
   sembra validato.
4. I CSV prodotti hanno il suffisso del broker
   (`..._r50_pepperstone.csv`): non entrano nelle classifiche insieme ai
   nostri.

---

## 7. Rischi residui, dichiarati

- **DST a meta' backtest** (punto 4.2): un solo numero di rimappatura e'
  sbagliato per ~3 settimane l'anno. Mitigazione: misurare lo shift su due
  stagioni, escludere o dichiarare quelle finestre.
- **Il feed non e' lo stesso mercato**: indici cash vs derivati, orari di
  chiusura diversi, gap diversi. Un EA d'apertura puo' comportarsi in modo
  diverso per motivi che non c'entrano con la strategia.
- **Broker singolo**: sono i dati di UN broker, con i suoi buchi e i suoi
  filtri. Un anno "buono" li' non e' un anno buono in assoluto.
- **Storico dichiarato != storico scaricabile**: `PrimaDataD1` dice quello
  che il server dichiara. Se il download si ferma prima (tappo "max barre
  nel grafico", limiti del server), il test gira su meno dati di quelli che
  credi. Si controlla nel referto dello storico, riga per riga.
- **Tick reali**: sul broker esterno potrebbero non esserci per gli anni
  vecchi. Con solo OHLC M1 il modello e' di **screening**, non da verdetti
  (stessa regola di sempre: `-Modello 1` non promuove niente).

---

## PEPPERSTONE — primo tentativo, 14/08/2026 sera: NON connesso

Terminale installato (`C:\Program Files\Pepperstone MetaTrader 5`, cartella dati
`73B7A2420D6397DFF9014A20F1201F97`, build **6111**). Il Giornale dice tutto:

```
18:17:29  Broker   PepperstoneUK-Live: no demo/preliminary groups on server side
18:17:29  Broker   PepperstoneUK-Demo: no demo/preliminary groups on server side
18:18:47  Network  '62128200': authorization on PepperstoneUK-Demo failed (Invalid account)
18:24:53  Network  '62128200': connecting to an access point with 50 % quality
18:25:04  Network  '62128200': no connection to PepperstoneUK-Demo
```

**Due fatti distinti, tutti e due utili:**

1. **`Invalid account`** — il server `PepperstoneUK-Demo` non conosce il conto
   62128200. La rete c'e' (l'access point risponde), e' l'autorizzazione che
   viene respinta.
2. **`no demo/preliminary groups on server side`** su UK-Demo **e** su UK-Live
   — su quei due server il terminale **non puo' nemmeno creare** un conto
   demo. Quindi il 62128200 non e' nato li'.

**Conseguenza operativa:** serve il server dell'entita' giusta. La lista
completa dei server Pepperstone la mostra il terminale stesso
(File > Apri un conto > cercare "Pepperstone"); il nome autorevole e' quello
scritto nell'email di apertura del demo. **Non si indovina.**

**Nota di metodo:** i prezzi fermi al novembre 2021 nel Market Watch erano la
fotografia che l'installer si porta dietro, non un feed. Il segnale vero era
il **Bilancio 0,00** con l'indicatore rosso e 2 Kb di traffico. E MT5 **non
apre nessun popup** quando l'autorizzazione fallisce: lo scrive solo qui.
