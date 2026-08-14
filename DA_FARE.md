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

## 0-bis. R51 — LO SHORT DI RITORNO (codice pronto, da lanciare)

`InpAllowReverse` in `ABTG_DAX_Apertura_EU` v1.01, default **false**.
Tesi e criteri congelati: `prove/R51_REVERSE_TESI.md`. Si lancia col
walkforward generico e il file `prove/R51_reverse_DAX.txt`.
**Il verdetto lo da' il drawdown, non il PF.**

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

## 1-ter. R53 — DOVE CADE LA FASCIA ORARIA DI EASY TREND

La regola "candela del segnale fra le 8 e le 18" e' **[FONTE]**, viene dal
coach e non si tocca. Ma lui legge quell'ora **sul suo grafico**, cioe'
sull'ora server del SUO broker: noi l'abbiamo messa letterale su BCM. Se il
suo broker e' GMT+2 o GMT+3 la stessa regola cade a **7-17** o **6-16**.
Scritto e mai chiuso: `prove/EASY_TREND_TESI.md` righe 41-44 e
`ABTG_EasyTrend.mq5:140-144`.

Non si cerca la finestra migliore: si cerca **dove cade quella della fonte**.
Si spostano start e fine insieme tenendo la larghezza di 10 ore, e le uniche
quattro combinazioni che contano sono quelle che corrispondono a un fuso vero.
Criteri congelati in testa a `prove/R53_fuso_EZ.txt`: **un fuso vince solo se
vince su 3 simboli su 4**, altrimenti si tiene 8-18.

Perche' vale la pena: R48, R49 e R50 hanno giudicato Easy Trend con una regola
forse spostata di un'ora. E il risultato vale per **ogni** strategia futura
della stessa fonte, non solo per questa.

**LANCIATO il 14/08 sera.** PC di BACKTEST, MT5 CHIUSO. 128 passate
(16 celle x 2 finestre x 4 simboli): e' il round piu' lungo finora.

```
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/d78c80b8009be6b0c1a27aad06f804e51bc34e02/backtest_pipeline/lancia_r53.ps1" -OutFile "$env:TEMP\lancia_r53.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\lancia_r53.ps1" -Rif d78c80b8009be6b0c1a27aad06f804e51bc34e02
```

Zip in `Desktop\r53.zip`, 8 CSV attesi. Per spezzarlo:
`-Simboli "GBPUSD,EURGBP"`. Per vedere l'ini senza lanciare:
`-SoloControllo`.

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
