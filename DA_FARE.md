# DA FARE — lista di ripresa (aggiornata 14/08/2026, mattina)

_Claudio e' via. Questa e' la lista esatta di cosa fare quando torna al PC,
in ordine. Tutto cio' che serve e' gia' scritto e pushato sul branch `lavoro`._

---

## 0. PRIORITA' ALTA — DUE DAX APERTURA CON LO STESSO MAGIC (trovato 14/08)

I trade gemelli di stamattina hanno commenti **diversi**: il 100k
`DAX Apertura EU RETEST BUY` (BUY LIMIT), il piccolo `DAX Apertura EU BUY`
(BUY STOP). Sono due rami di codice che non si incrociano: sul conto piccolo
gira **anche** il motore BREAKOUT, quello bocciato dal banco cinque volte —
e gira **con lo stesso magic 770101** della cella validata, quindi sporca il
forward. Dettagli e prova aritmetica: `report/DAX_14-08_DUE_MOTORI.md`.

Sul **VPS** (non tocca niente, MT5 puo' restare aperto):

```
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/7dc4b65b688c1f8a0168f7b237ba6d6364fcbe86/backtest_pipeline/config_in_uso.ps1" -OutFile "$env:TEMP\config_in_uso.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\config_in_uso.ps1"
```

Stampa l'**ultima** riga `CONFIG IN USO` di ogni EA su **ogni** terminale
(conto per conto), con motore/range/buffer/offset/rischio/TP. Zip pronto in
`Desktop\config_dax.zip`. Poi si decide: spegnere l'istanza breakout, oppure
tenerla come confronto ma **con un magic suo** (es. 770102).

## 0-bis. R51 — LO SHORT DI RITORNO — **CODICE PRONTO** (14/08)

`ABTG_DAX_Apertura_EU` e' passato alla **v1.01**: nuovo input
**`InpAllowReverse`** (default **false**, quindi i conti vivi NON cambiano
comportamento). Col flag acceso il lato opposto resta sorvegliato dopo il
primo ciclo, con tetto rigido di 2 cicli/giorno e obbligo di ripartire da
flat (mai due cose vive insieme, mai 2R contemporanei).
Tesi e criteri: `prove/R51_REVERSE_TESI.md`.

Sul PC di BACKTEST, MT5 CHIUSO (il driver si scarica e ricompila l'EA da
solo):

```
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/c88d160afb8fb0125d4843a0a3e81caf4ca4ff05/backtest_pipeline/walkforward_generico.ps1" -OutFile walkforward_generico.ps1
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/c88d160afb8fb0125d4843a0a3e81caf4ca4ff05/backtest_pipeline/prove/R51_reverse_DAX.txt" -OutFile prove\R51_reverse_DAX.txt; powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 ABTG_DAX_Apertura_EU -Prova prove\R51_reverse_DAX.txt -Etichetta r51
```

Due righe sole: cella validata con reverse SPENTO vs ACCESO, tutto il resto
pinnato. **Il verdetto lo da' il drawdown, non il PF** (criterio 3): se
aggiunge profitto ma alza il DD, e' bocciato.

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

## 3-bis. LA MISURA CHE CONVIENE FARE PER PRIMA (10 minuti, sul PC di backtest)

Il ricognitore e' pronto e sa misurare il DST **anche su BCM**, senza
aspettare Pepperstone. Va fatto ADESSO, perche' se la risposta e' "BCM non
segue il cambio d'ora europeo" allora il 25/10 vanno corretti gli EA VIVI:

```
irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/prepara_broker_esterno.ps1" -OutFile "$env:USERPROFILE\prepara_broker_esterno.ps1"
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
