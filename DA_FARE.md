> ⚠️ **QUESTO FILE E' STORICO (14/08) — NON e' la coda attuale.** Per lo stato
> vivo e i prossimi passi vai a **`HANDOFF.md`, sezione "AGGIORNAMENTO 03/09"**
> (coda in fondo alla sezione) + `report/PIANO_PROP.md` v18. Sotto qui e' tutto
> materiale gia' CHIUSO, tenuto solo come archivio. Non seguire l'ordine di
> lancio qui sotto: e' superato.

---

# DA FARE — lista di ripresa (aggiornata 14/08/2026, mattina)

_Lista esatta, in ordine di lancio. Tutto cio' che serve e' gia' scritto e
pushato sul branch `lavoro`. Le righe sono pinnate al commit SHA._

**Ordine consigliato (il tester serializza tutto):** 0 sul VPS (30 secondi,
in parallelo) - poi sul PC: **0-bis R51** (corto) -> **3-bis DST** (10-20
min, MT5 si apre da solo) -> **1 R50** (32 lanci, si lascia girare).

---

## 0. DAX FANTASMA — **CHIUSO** (14/08 sera)

Provato dal giornale del PC: alle 09:25:01 l'istanza sul grafico **D30EUR M3**
ha piazzato buy stop 2 D30EUR a 26479.00 (ticket **#3160534**) e il sell stop
gemello, sul conto 50503392. Motore breakout, buffer 20 pt, rischio 2%, cioe'
una configurazione mai validata. Referto completo con tutte e quattro le
appendici: `report/DAX_14-08_DUE_MOTORI.md`.

**VERIFICATO il 15/08 alle 00:14** (`caccia_ticket.ps1` su PC e VPS, con
controllo positivo): dei tre stop pieni del magic 770101, **DUE sono del PC**
(10/08 #3109763 -101,83 e 14/08 #3160534 -104,60 = **-206,43 riattribuiti**) e
**uno e' del VPS** (06/08 #3088160 -102,96, trade regolare che resta a carico
del portafoglio). L'inferenza della pagella era sbagliata per un terzo.
Referto: `report/CACCIA_TICKET_770101.md`.

**RISPOSTA (15/08, `censimento_ordini.ps1` su entrambe le macchine): NON DUE
GIORNATE, SEDICI.** Il PC ha piazzato **174 ordini** sul conto vivo dal 06/07
al 14/08, **33 sono diventati trade veri** per **-511,28**. Controllo che
valida tutto: dei trade non attribuiti, quelli con magic di EA sono **ZERO**
(gli altri sono manuali/mobile, tutti prima del 22/07) -> **per gli EA
l'attribuzione e' completa al 100%**.

**Il numero che ribalta due settimane di letture: dal 22/07 il conto piccolo
fa -340,70, ma il PC ci mette -475,56 e il VPS +93,14. Senza il fantasma la
flotta e' a +134,86: NON e' in perdita.** Referto:
`report/CENSIMENTO_ORDINI_PC.md`.

**DA FARE ORA:**
1. **Controllo di tenuta**: rilanciare il censimento **fra una settimana**. Se
   il PC ha piazzato zero ordini nuovi, il lucchetto tiene e il caso si chiude.
   E' l'unica prova che vale.
2. Ricalcolare le classifiche del forward **escludendo i 33 trade del PC**.
3. Il magic 770101 va ricalcolato **solo sui trade del VPS** prima di
   confrontarlo con qualunque backtest (era un miscuglio: 15 PC + 11 VPS).
4. Staccare i 10 EA di terzi dai grafici del PC (sono la fonte dei 104
   `Invalid price`).

**DOMANDA CHIUSA (era: piu' grande di quella aperta):** sul PC ci sono 52 giornali e
12 righe `order #` nei soli tre giorni guardati. **Quante ALTRE volte il PC ha
piazzato sul conto vivo?** Si risponde elencando TUTTI gli `order #` del
giornale del PC e incrociandoli col CSV dei trade. Costa quanto la caccia ai
tre ticket.

**Fatto:** AutoTrading spento sul PC · EA staccato dal grafico M3 · 23 driver
che generano ini del tester blindati con `[Experts] AllowLiveTrading=false` ·
guardia A4 corretta (confondeva "non lo so" con "non ho operato").

**Guardia A4 — CHIUSA anche sugli altri tre (14/08 sera):**
`ABTG_Dow_Apertura_US` 1.00->1.01, `ABTG_Nasdaq_Apertura_US` 1.01->1.02,
`ABTG_Apertura_Marco` 1.00->1.01. Adesso `HaGiaOperatoOggi()` restituisce
anche `storicoOk`: se lo storico non ha risposto, la giornata NON viene
timbrata e il controllo si ripete al tick dopo. **Da ricompilare sul VPS**
alla prossima occasione (nel tester non cambia niente: li' lo storico c'e'
sempre).

## 0-bis. R51 — **CHIUSO** (14/08 notte): RISERVA, il reverse resta spento

8 passate, 2 CSV su 2, gemelli identici al centesimo. L'EA v1.01 con
`InpAllowReverse` compila e gira (era la prima volta).

| | profitto | DD | trade | peggior giornata |
|---|---|---|---|---|
| **IS** off -> on | 3.158 -> **2.763** | 7,20 -> **8,79%** | 208 -> 313 | -1,07 -> **-2,06%** |
| **OOS** off -> on | 9.062 -> **15.821** | 10,75 -> **10,30%** | 332 -> 527 | -1,08 -> **-2,06%** |

- **Criterio 1 (frequenza): PASSATO**, 195 attivazioni contro una soglia di 20.
  **La mia ipotesi 2 e' falsificata**: stimavo "meno di 1 giorno su 5", sono
  **3 su 5** (+59% di operativita'). Motivo: il reverse parte anche quando il
  primo LIMIT **scade inevaso**, che e' il caso piu' comune - scritto nella
  tesi §3 e poi dimenticato nella stima.
- **Criterio 3 (DD)**: passa fuori (10,30 <= 10,75, e Recovery +81%), **fallisce
  dentro** (8,79 contro 7,20).
- **Criterio 4 (due banchi): FALLITO.** I trade aggiunti rendono **-3,76 in
  campione** e **+34,66 fuori**: direzioni opposte. -> **RISERVA**.
- **Criteri 2 e 5**: non misurabili senza per-trade, come dichiarato prima del
  lancio. Il criterio 6 dice "se passa tutto": non si spende.

**Il numero che decide: la peggior giornata RADDOPPIA** (-1,07 -> -2,06%), su
entrambe le finestre. Era l'ipotesi 3 scritta prima, confermata al decimale. Il
pavimento FTMO e' -5% al giorno e le serie che lo condividono sono 27+.

**30° RIBALTAMENTO**: negativo in campione, +74,6% fuori. Nessuna delle due
letture da sola sarebbe stata affidabile.

**Nessun cambio al forward**, `InpAllowReverse` resta **false**. Il diritto di
riaprire il caso lo da' il **forward**, non un altro giro sulla stessa finestra
OOS (gia' guardata otto volte). Referto:
`risultati_archivio/REFERTO_ROUND51_REVERSE_DAX.md`, CSV in
`risultati_archivio/csv_r51/`.

## 1. R50 — **COLLAUDATO, PRONTO AL ROUND VERO**

Il 14/08 sera il primo CSV e' uscito: `BB_GBPUSD_ORSO_r50.csv (2 righe)`.
Sei difetti trovati e corretti per arrivarci, l'ultimo dei quali era la causa
vera: l'import ammazzava MT5 con `Stop-Process -Force` e la registrazione dei
simboli custom non veniva salvata (le barre si, il simbolo no). Storia
completa: `risultati_archivio/REFERTO_ROUND50_AVVIO.md`.

Sul PC di BACKTEST, MT5 CHIUSO:

```
irm https://raw.githubusercontent.com/claudiospadaro12/GITHUB/63627eb1e181ea83496f30a200095fd02161f486/backtest_pipeline/prova_regime.ps1 -OutFile "$env:TEMP\prova_regime.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\prova_regime.ps1"
```

8 celle x 4 finestre = 32 lanci. Zip in `Desktop\regime_r50.zip`.
Le 4 finestre: ORSO 2022 - CROLLO 2020 - TORO 2021 - LATERALE 2019.

**Il verdetto si scrive coi criteri approvati** in
`prove/PROVA_REGIME_CRITERI.md` (A sopravvivenza, B tenuta, C rango, D due
banchi, E ripescaggi). Non si spostano, e ogni verdetto cita il criterio.

## 1-bis. R52 — IL LATO SCARTATO (domanda di Claudio, tesi gia' congelata)

"Se un EA e' tarato solo su long, il test valuta se lo short sarebbe potuto
entrare?" Su R50 la risposta e' NO, e non serve: **sette celle su otto
lavorano gia' in tutti e due i sensi** (BB e GAP non hanno nemmeno gli input
del lato; PTE, SW, EZ hanno entrambi a true). L'unica in cui il lato e' stato
una scelta e' **LARRY, short-only**.

Dove la domanda morde davvero e' sulle celle degli INDICI, che entreranno con
Pepperstone: sono state tarate su 21 mesi di mercato che saliva, quindi il
lato scelto li' dentro puo' essere un riflesso del campione piu' che una
scoperta.

Tesi e criteri congelati il 14/08 a numeri non visti:
`prove/R52_LATI_TESI.md`. Regola madre: **i dati _EXT PROPONGONO, non
validano**. Da fare dopo R50 e dopo Pepperstone.

## 1-ter. R53 — **CHIUSO** (14/08 notte): la fascia NON decide, si tiene 8-18

128 passate, 8 CSV su 8. Igiene: la cella 8-18 riproduce R48 (GBPUSD stesso
n=41, PF 1,483 contro 1,49; CHFJPY PF 1,250 contro 1,25).

Miglior PF fuori campione, un voto per simbolo: **7-17 due voti** (GBPUSD,
EURGBP) e **8-18 due voti** (AUDJPY, CHFJPY). Serviva **3 su 4**: nessuno ci
arriva. Con la coerenza IS richiesta dal criterio 2, **un solo simbolo su 4**
ha un fuso coerente. -> **criterio 3: si tiene il valore letterale 8-18**.

Il risultato e' piu' forte di un pareggio: se fosse un fuso vincerebbe
DAPPERTUTTO. Invece GBPUSD preferisce piu' presto (Londra) e AUDJPY piu'
tardi: e' il pattern delle sessioni proprie di ogni cambio, non di un
orologio spostato. **Ipotesi 1 della tesi falsificata.** Conseguenza per ogni
strategia futura della stessa fonte: **orario letterale, niente rimappatura**.

- **29° RIBALTAMENTO** (AUDJPY): 8-18 e' la PEGGIORE in campione (PF 0,649,
  -5.395) e la MIGLIORE fuori (PF 1,521, +14.787). ~20.000 EUR di differenza,
  e riguarda proprio la fascia che usiamo.
- **Trappola disinnescata dal criterio 1**: su 3 simboli su 4 la cella piu'
  bella fra tutte e 16 ha larghezza SBAGLIATA (8 o 13 ore), e batte la
  diagonale per 2-27 millesimi di PF. Si sarebbe rotta la regola del coach
  per niente.
- EURGBP rosso in tutte e 8 le celle: conferma indipendente di R48.
- Limite dichiarato: il file pinna TP 1,5 su tutti, ma la cella viva AUDJPY e'
  TP 1,0. Non cambia il verdetto (senza AUDJPY la soglia e' ancora piu'
  lontana).

**Easy Trend resta fuori** da portafoglio (R49) e prova di regime (R50), e le
tre sedie in osservazione non si toccano (criterio 4). Referto:
`risultati_archivio/REFERTO_ROUND53_FUSO_EASYTREND.md`, CSV in
`risultati_archivio/csv_r53/`.

## 1-quater. R54 — **CHIUSO** (14/08 sera): i due short sono BOCCIATI

Girato: 16 passate, 4 CSV su 4, sweep gemello identico al centesimo, e le due
celle vive riprodotte al centesimo (Dow = R46 riga 33; ORB = R15, stesso n=119).

- **Dow Apertura**: short OOS PF **0,840** (n=73) -> bocciato per merito, non
  per campione piccolo. Long+short fa **-42% di profitto** OOS e **DD doppio**.
- **ORB-EMA200 Dow**: short rosso in **entrambe** le finestre (PF 0,681 / 0,520,
  DD 26,4%). Long+short: -87% di profitto e DD da 9,76% a 17,16%.
- **28° RIBALTAMENTO**: sul Dow Apertura lo short e' la cella MIGLIORE in
  campione (PF 1,511, DD 2,68% contro 5,67% del long) e va **rosso** fuori.
  9.000 EUR di differenza sulla stessa ricetta.

**Nessun cambio al forward** (criterio 5, scritto prima): le due celle vive
girano gia' nella configurazione migliore delle tre, su profitto E su DD.
Referto: `risultati_archivio/REFERTO_ROUND54_LATI_DOW.md`, CSV in
`risultati_archivio/csv_r54/`.

Del censimento R52 restano **9 celle su 11** col lato spento a mano: tutte
bloccate in attesa di storico che oggi non abbiamo.

## 1-quinquies. R55 — **CHIUSO** (15/08): scala lo STOP LARGO, non il tipo di ordine

40 passate, 4 CSV su 4, gemelli 20/20 identici. **Controllo d'igiene passato**:
la riga a slippage 0 dell'ORB riproduce R54b **al centesimo** (+41.057,00 ·
1,6742 · 9,7623 · n=119); il PTE combacia a <0,8% con lo stesso n=40.
(Scarto dichiarato: PTE in campione fa 28 trade contro i 27 della coda a 10k.)

| | slip 0 -> 200 pt (OOS) | DD | esito |
|---|---|---|---|
| **PTE** (a mercato) | 1.093 -> **928** (-15%), PF 1,171 -> **1,142** | 3,2166 -> **3,2711%** | 🟢 **SCALA** |
| **ORB** (a stop) | 41.057 -> **35.755** (-13%), PF 1,674 -> **1,570** | 9,76 -> 🔴 **10,34%** | 🔴 **solo taglia piccola** |

**L'ORB non muore di PF: muore di DRAWDOWN.** Sfonda il cancello del 10% con
appena **150 punti = 1,5 punti indice**. R15 l'aveva promossa con DD 9,92% e
doppio asterisco ("cella di confine"): R55 misura quanto e' sottile quel
confine.

**Costo per trade a 200 punti**: PTE **-4,12 EUR** (0,41% di R) · ORB
**-44,55 EUR** (4,5% di R) = **undici volte**.

🔑 **La scoperta**: il tipo di ordine NON spiega la differenza. La spiega la
**LARGHEZZA DELLO STOP** — `lotto = R / distanza stop`, quindi stop stretto =
piu' lotti = ogni punto di slippage costa di piu'. L'ORB ha lo stop al 50% del
range, il PTE a 1 ATR + buffer. **Stessa lezione della FASE H** (07/08: "il
drawdown non lo fa la geometria, lo fa lo stop stretto") da un'altra porta:
**una cella con lo stop stretto e' fragile due volte**.

**Criterio gratis per tutte e 32 le celle vive**: si guarda `InpSLMode` e si sa
gia' quali reggono la taglia e quali no, senza un altro round.

**Nessun cambio ai parametri vivi**: `InpSlippagePts` resta 0 su entrambi gli
EA. Referto: `risultati_archivio/REFERTO_ROUND55_SLIPPAGE.md`, CSV in
`risultati_archivio/csv_r55/`.

**Resta aperto e non lo chiude nessun backtest**: riempimento parziale e
profondita' del book a 177 lotti. MT5 non li modella. Risponde solo il forward
a taglia crescente.

## 2. GLI INDICI: Pepperstone (il pezzo grosso che manca)

HistData non ha gli indici, quindi **4 titolari su 5 (DAX, Dow, Nasdaq,
Nikkei) restano fuori dalla prova di regime** finche' non c'e' Pepperstone.
Due agenti hanno consegnato/stanno consegnando gli attrezzi:
- `installa_pepperstone.ps1` (installer + storico + TICK REALI)
- `prepara_broker_esterno.ps1` + `ABTG_InfoBroker.mq5` (nomi veri dei
  simboli, fuso misurato, walk-forward sul terminale nuovo)

Sequenza quando Claudio torna:
1. lanciare l'installer;
2. **creare il conto demo a mano** dal terminale (File > Apri un conto >
   Pepperstone > server demo): questo passaggio NON e' automatizzabile;
3. lanciare il ricognitore `-SoloElenco` per avere nomi simboli + fuso;
4. scaricare storico e tick (attenzione: decine di GB, si parte con pochi
   simboli per collaudare);
5. R50-bis sugli indici.

**Attenzione al fuso**: Pepperstone e' GMT+3 (ora legale) / GMT+2 (solare),
BCM oggi e' GMT+1 -> **+2 ore**. Ma i due broker cambiano ora legale in
DATE DIVERSE (USA vs Europa): 2-3 settimane l'anno la differenza vale 1 ora.
Gli orari degli EA sono in ORA SERVER e vanno rimappati prima di ogni test.

## 3. DOMANDA APERTA CHE TOCCA I SOLDI VERI

**Il server BCM cambia ora legale?** La nostra regola ("server = ora
italiana - 1") ha sempre avuto la nota "in questo periodo dell'anno" e non
e' mai stata verificata d'inverno. Se BCM NON cambiasse, dal **25 ottobre
2026** tutti gli `InpSessionHour` degli EA VIVI sarebbero sbagliati di
un'ora (DAX, aperture USA, fasce orarie, box notturno).

Indizio raccolto il 14/08: i trade del DAX Apertura sono regolari anche in
inverno (122 chiusure nov-mar contro 107 giu-ott), il che suggerisce che il
server segua il cambio europeo — **ma non e' una prova** (il CFD quota anche
in pre-mercato). Il ricognitore misurera' l'ora della PRIMA BARRA della
giornata in gennaio contro luglio: quello e' il dato definitivo.
**Scadenza: prima del 25/10/2026.**

## 3-bis. LA MISURA CHE CONVIENE FARE PER PRIMA (10 minuti, sul PC di backtest)

Il ricognitore e' pronto e sa misurare il DST **anche su BCM**, senza
aspettare Pepperstone. Va fatto ADESSO, perche' se la risposta e' "BCM non
segue il cambio d'ora europeo" allora il 25/10 vanno corretti gli EA VIVI:

```
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/8ab7219826b61a391f05f7c7b03b228307921615/backtest_pipeline/prepara_broker_esterno.ps1" -OutFile "$env:USERPROFILE\prepara_broker_esterno.ps1"
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\prepara_broker_esterno.ps1" -BrokerPattern "BCM" -SoloElenco -Auto -Filtro "D30EUR" -SimboloFuso "D30EUR" -SimboloGrafico "D30EUR"
```

Legge la prima barra della giornata del DAX su date campione (gennaio,
marzo, aprile, luglio, ottobre, novembre) e dice se l'ora di apertura
CAMBIA fra le stagioni. Serve anche come riferimento per il delta con
Pepperstone. Zip pronto in `Desktop\broker_esterno.zip`.

## 4. ROBA DI ROUTINE

- **Pagella serale**: da adesso si guarda **il win rate**, non il P/L
  (R47: payoff basso = normale per questi EA; il conto e' sotto per
  varianza sul win rate, 60% contro il 73-81% del tester).
- **Domenica sera**: debutto della famiglia GAP sulla riapertura.
- **Vivaio a 26 grafici** (23 in prova + 5 in osservazione): verdetti a 15
  trade per famiglia. LARRY parla per primo (6-8 settimane).
- **D3 prop**: in pausa fino a 1-2 settimane di forward, poi le domande
  gia' scritte in `report/DOMANDE_SUPPORTO_PROP.md`.

## 5. IN CODA, SENZA FRETTA

- Tick Easy Trend sui 5 simboli minori (CADJPY, USDCHF, XAUUSD, USDJPY,
  EURUSD): non servono per il verdetto della famiglia.
- Import esterno di altri simboli forex/metalli oltre EURUSD e GBPUSD.
- Riordino Desktop sul VPS (lo script c'e' gia', con anteprima e -Annulla).
- E35EUR: terza volta che resta fuori per mancanza di tick su BCM.
