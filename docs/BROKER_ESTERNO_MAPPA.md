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

| BCM | Che cos'e' | Broker esterno | Digits | Contract | Prima data D1 | Verificato il |
|---|---|---|---|---|---|---|
| D30EUR | DAX 40 | | | | | |
| U30USD | Dow Jones 30 | | | | | |
| NASUSD | Nasdaq 100 | | | | | |
| 225JPY | Nikkei 225 | | | | | |
| F40EUR | CAC 40 | | | | | |
| E35EUR | IBEX 35 | | | | | |
| SPXUSD | S&P 500 | | | | | |
| UKOIL | Brent | | | | | |
| USOIL | WTI | | | | | |
| XAUUSD | Oro | | | | | |
| XAGUSD | Argento | | | | | |

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
| Pepperstone | | |
| **Delta (Pepperstone - BCM)** | | |

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
