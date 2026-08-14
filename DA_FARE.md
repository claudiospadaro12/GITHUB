# DA FARE — lista di ripresa (aggiornata 14/08/2026, mattina)

_Claudio e' via. Questa e' la lista esatta di cosa fare quando torna al PC,
in ordine. Tutto cio' che serve e' gia' scritto e pushato sul branch `lavoro`._

---

## 1. IL ROUND CHE ASPETTA: la prova di regime sul forex (R50)

**Stato: PRONTO, si puo' lanciare subito.** L'import ha gia' funzionato:
EURUSD_EXT e GBPUSD_EXT, **2018-2024**, 2,55 milioni di barre, 0 righe
scartate, differenza dal feed BCM **0,004%**, copertura 99,6%, zero
proprieta' guaste -> **cancello zero SUPERATO**.

Sul PC di BACKTEST, MT5 CHIUSO:

```
irm https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prova_regime.ps1 -OutFile "$env:TEMP\prova_regime.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\prova_regime.ps1" -SoloControllo
```

Se il controllo e' pulito, si rilancia SENZA `-SoloControllo`: 8 celle x 4
finestre = 32 lanci, zip pronto in `Desktop\regime_r50.zip`.

Le 8 celle sono quelle VIVE su EURUSD/GBPUSD (BB x2, GAP x2, LARRY, EZ,
PTE, SW), coi parametri copiati dai preset del vivaio e **congelati**.
Le 4 finestre: ORSO 2022 - CROLLO 2020 - TORO 2021 - LATERALE 2019.

**Il verdetto si scrive coi criteri gia' approvati** in
`prove/PROVA_REGIME_CRITERI.md` (A sopravvivenza, B tenuta, C rango,
D regola dei due banchi, E ripescaggi). Non si spostano.

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
