# ABTG_StopManuale — la guardia dello stop per le operazioni MANUALI

**Scritto il 25/09/2026.** Sorgente: `mql5/Experts/ABTG_StopManuale.mq5` ·
preset: `mql5/Presets/ABTG_StopManuale_2pip.set`.

La richiesta di Claudio, testuale:

> _"un EA semi automatico che si attiva appena entro io a mercato e stoppa gli
> ordini non appena gli ordini vanno sotto di 2 pip x esempio"_

**Stato:** scritto e revisionato a tavolino, **NON COMPILATO** (in questo
ambiente non c'è MetaEditor). Il primo passo è compilarlo e provarlo su **DEMO**.
**Nessuna riga di lancio in questo documento**: dove e quando attaccarlo lo
decide Claudio.

---

## 1. Cosa fa, in tre righe

1. **Apri tu a mano** (magic 0). L'EA vede la posizione al primo tick (o entro
   250 ms, ha anche un timer) e mette lo **SL sul server del broker** a
   `ingresso - N` per un BUY, `ingresso + N` per un SELL.
2. Se lo SL sul server **non si può mettere** (rifiutato, o il broker chiede una
   distanza minima più larga di N), c'è lo **stop virtuale di riserva**: appena
   il prezzo supera la soglia (Bid per i BUY, Ask per i SELL) l'EA **chiude a
   mercato**.
3. **Non apre mai niente.** Nel codice esistono solo `PositionModify`,
   `PositionClose` e `OrderModify`: nessun `Buy`, nessun `Sell`.

Perché lo SL **sul server** e non solo "virtuale": lo SL sul server resta vivo
anche se il VPS si pianta o il terminale si chiude. Lo stop virtuale da solo
muore con il terminale.

---

## 2. Gli input

| input | default | cosa fa |
|---|---|---|
| `InpStopPips` | `2.0` | la distanza N dello stop, nell'unità scelta sotto |
| `InpUnit` | `PIPS` (0) | `PIPS` oppure `POINTS` (punti MT5) |
| `InpPipPoints` | `0` | punti per 1 pip. `0` = automatico: Digits 3/5 → 10 punti; Digits 2/4 e ogni altro caso → 1 punto |
| `InpServerSL` | `true` | mette lo SL sul server |
| `InpSoftStop` | `true` | stop virtuale di riserva: chiude a mercato se lo SL sul server manca o è più largo di N |
| `InpSpreadGuard` | `true` | se N non supera lo spread, **blocca** quel simbolo e lo scrive nel log (vedi §4) |
| `InpCloseOnAttach` | `false` | posizione **già** oltre la soglia quando attacchi l'EA: `false` = la segnala e **non** la chiude |
| `InpTakePips` | `0` (spento) | TP a N, messo **solo se il TP manca** |
| `InpBEPips` | `0` (spento) | breakeven: SL a pareggio dopo +N |
| `InpTrailPips` | `0` (spento) | trailing: distanza dal prezzo |
| `InpTrailStartPips` | `0` | trailing: parte dopo +N |
| `InpTrailStepPips` | `1.0` | trailing: sposta lo SL solo se migliora di almeno N |
| `InpSymbolScope` | `CHART_ONLY` (0) | solo il simbolo del grafico, oppure `ALL_SYMBOLS` (1) |
| `InpOnlyManual` | `true` | solo magic 0. `false` = tutte le magic non in `InpIgnoreMagics` (pericoloso su un conto con sedie) |
| `InpIgnoreMagics` | vuoto | magic da non toccare **mai**, separate da virgola. Un valore non numerico = l'EA **non parte** |
| `InpAlsoPendings` | `false` | mette SL (e TP) anche sugli ordini pendenti manuali |
| `InpDeviationPts` | `50` | scostamento massimo sulle chiusure a mercato (punti MT5) |
| `InpBackoffSec` | `30` | dopo una modifica rifiutata, attesa prima di riprovare |
| `InpMaxModifyPerMin` | `4` | tetto di modifiche per posizione al minuto |
| `InpMagic` | `779900` | magic dell'EA: non apre ordini, marca solo le sue chiusure a mercato |
| `InpVerbose` | `false` | log dettagliato |

TP, breakeven, trailing e pendenti sono **tutti spenti** di default: il
comportamento di base è solo lo stop richiesto da Claudio.

---

## 3. Le regole che l'EA rispetta sempre

- **Stringe, non allarga mai.** Se lo SL che hai messo tu (o il breakeven) è già
  più stretto della soglia, l'EA non lo tocca. Se è più largo, lo porta alla soglia.
- **Idempotente.** Uno SL già giusto entro 1 punto non viene rispedito. Dopo un
  riavvio del terminale l'EA riparte da zero e rilegge tutto dal server: non ha
  stato che si rompe.
- **Mai uno stop dal lato sbagliato del prezzo.** Ogni SL viene confrontato con
  Bid (per i BUY) o Ask (per i SELL) **prima** di spedirlo. È la lezione della
  modify a raffica del 25/09 (`report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md`):
  lì il trailing chiedeva uno stop sopra il prezzo e il server rispondeva
  "invalid stops" a ogni tick.
- **Niente raffiche.** Dopo un rifiuto l'EA aspetta `InpBackoffSec` (30 s) e lo
  scrive nel log **una volta**; lo stesso rifiuto non viene riscritto per 5
  minuti. In più, al massimo `InpMaxModifyPerMin` (4) modifiche al minuto per
  posizione. Una chiusura a mercato rifiutata si ritenta dopo 2 s, sempre con
  il log una volta sola.
- **Posizioni già sotto quando lo attacchi.** Se attacchi l'EA mentre hai una
  posizione già oltre la soglia (magari la tieni apposta), l'EA **non** la
  chiude: la segnala nel log e sul grafico. Se il prezzo rientra sopra la soglia
  la protegge come le altre. Per chiuderle subito: `InpCloseOnAttach=true`.
- **Conto reale bloccato.** Sul conto `10105439` l'EA rifiuta di partire. Serve
  la firma di Claudio, e allora si toglie il blocco in `OnInit` e si ricompila.
- **Algo Trading spento = nessuna protezione**, e lo dice: sul grafico compare
  `NON CONSENTITO - NON PROTEGGO NULLA` e il log lo ripete ogni 60 s.

Ogni riga di log comincia con **`[STOPMANUALE]`**, così si filtra nella scheda
Esperti.

---

## 4. Il minimo del broker e l'unità del pip (LEGGERE PRIMA DI USARLO)

### 4.1 La distanza minima del broker

Il broker può vietare uno SL più vicino di `SYMBOL_TRADE_STOPS_LEVEL` punti dal
prezzo, e può "congelare" gli ordini entro `SYMBOL_TRADE_FREEZE_LEVEL` punti.
L'EA fa così:

- la distanza minima che usa è `max(stops level, freeze level) + 1 punto`
  (il +1 perché anche con stops level 0 lo SL deve stare **strettamente** sotto
  il Bid / sopra l'Ask);
- se la soglia richiesta è **più vicina** del minimo e la posizione non ha SL,
  mette lo SL **al minimo consentito** e lo scrive in chiaro, per esempio:
  `SL ALLARGATO al minimo consentito: richiesto X, messo Y (stops level Z punti,
  freeze level W punti)`. **Non allarga mai in silenzio.** Lo stop virtuale
  resta sulla soglia esatta N;
- se la posizione ha già uno SL più largo e la soglia non è piazzabile in quel
  momento, **non insegue il prezzo** con una modifica a ogni tick: lo scrive una
  volta e riprova quando la soglia torna piazzabile.

I numeri che il repo ha davvero, misurati il 20/09/2026 sul terminale **FTMO**
(`backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv`):

| simbolo FTMO | Digits | Point | stops level | freeze level | spread al momento della foto |
|---|---|---|---|---|---|
| `GER40.cash` | 2 | 0.01 | **0** | **0** | 143 punti = 1,43 punti indice |
| `US30.cash` | 2 | 0.01 | **0** | **0** | 263 punti = 2,63 punti indice |
| `XAUUSD` | 2 | 0.01 | **0** | **0** | 47 punti = 0,47 USD |

Sui simboli **BCM** (`D30EUR`, `U30USD`, `NASUSD`, oro) lo stops level è
**[NON MISURATO]** nel repo (`report/LE_UNITA_NEI_PRESET_VIVI_2026-09-23.md`
punto 4). Sul conto manuale `50503635` **non è misurato nemmeno lì**: la prima
riga di log dell'EA all'avvio lo stampa (`AVVIO ... Stops level N punti, freeze
level M punti, spread ora S punti`), quindi basta attaccarlo per averlo.

### 4.2 Che cos'è "un pip" (qui si decide se l'EA ha senso su un simbolo)

- **Forex a 5 o 3 decimali** (EURUSD, USDJPY): 1 pip = 10 punti. "2 pip" = 20
  punti = 0.00020 su EURUSD. Funziona come uno se lo aspetta.
- **Simboli a 2 decimali** (indici e oro sui conti misurati sopra): con la
  regola automatica **1 pip = 1 punto = 0.01**. "2 pip" = **0.02**, cioè
  **dentro lo spread** (sul DAX FTMO lo spread era 1,43).

Con N dentro lo spread la regola "chiudi appena va sotto di N" chiuderebbe
**ogni operazione subito, per il solo spread**: un BUY nasce già sotto di uno
spread. Per questo c'è **la guardia spread** (`InpSpreadGuard=true`): se N non
supera lo spread, l'EA **non agisce su quel simbolo** (niente SL, niente
chiusure), lo scrive nel log con i numeri e lo mostra sul grafico, e ricontrolla
ogni 60 s. Una volta superata, la guardia non si ricontrolla più in quella
sessione: così uno spread che si allarga durante una notizia **non spegne** la
protezione di una posizione già aperta.

Su indici e oro l'unità giusta si sceglie così (**decisione di Claudio**):
`InpUnit=POINTS` con N in punti MT5 (esempio: 200 punti = 2,00 punti indice a 2
decimali), oppure `InpPipPoints` per forzare quanti punti vale un pip.

---

## 5. Cosa NON fa

- **Non apre operazioni**, mai.
- **Non tocca le sedie**: di default solo magic 0. Le posizioni di un EA hanno
  un magic diverso da 0 e vengono ignorate.
- **Non tocca i pendenti** se non con `InpAlsoPendings=true` (e solo con
  `InpServerSL=true`: lo stop virtuale non può agire su un ordine non eseguito).
- **Non allarga uno SL più stretto** del tuo.
- **Non mette un TP sopra il tuo**: il TP si aggiunge solo se manca.
- **Non protegge niente con Algo Trading spento**, e lo dice.
- **Lo stop virtuale non sopravvive al terminale spento**: se l'EA non gira, resta
  solo lo SL che ha già messo sul server.
- **Non garantisce il prezzo**: uno SL diventa un ordine a mercato quando scatta,
  e sui gap o sulle notizie esce al prezzo disponibile (scivolamento).
- **Non esclude una singola operazione**: se per una posizione vuoi uno stop più
  largo, finché l'EA è attaccato lo stringe. Per quella posizione si stacca l'EA.

---

## 6. Come si attacca

🪟 **Bersaglio: azione a mano dentro MT5, sul terminale del conto DEMO MANUALE
`50503635` — cartella `C:\MT5_MANUALE`.** Non si toccano: `50503392`
(`BCM Markets MT5 Terminal`), `50504263` (`... MT5 Terminal -V3`), 🔴 il
**REALE `10105439`** (`C:\BCM_Reale`), `50504400` (`C:\MT5_Backtest`), FTMO
`541452707` (`C:\FTMO`), Pepperstone, Tickmill.

Prima di toccare una finestra si stampa **quale** finestra è (sola lettura: non
cambia niente, elenca solo i terminali aperti).

🖥️ **Bersaglio della riga qui sotto: finestra PowerShell sul VPS.** Legge e
basta, non tocca nessun terminale:

```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-List
```

Si usa il terminale la cui riga `Path` comincia con `C:\MT5_MANUALE` e il cui
titolo porta `50503635`. Poi, dentro quel terminale:

1. copiare `ABTG_StopManuale.mq5` in `MQL5\Experts\` di **quel** terminale e
   compilarlo in MetaEditor (0 errori);
2. copiare `ABTG_StopManuale_2pip.set` in `MQL5\Presets\`;
3. aprire il grafico del simbolo che si trada a mano e trascinarci l'EA;
4. scheda **Input** → **Carica** → `ABTG_StopManuale_2pip.set` (rileggere §4.2
   se il simbolo è un indice o l'oro);
5. scheda **Comune**: spuntare **Consenti Algo Trading**; sul terminale il
   pulsante **Algo Trading** deve essere **verde**;
6. controllo: scheda **Esperti**, riga `[STOPMANUALE] AVVIO su conto 50503635`
   con stops level, freeze level e spread. Se il numero di conto non è
   `50503635`, **staccarlo subito**: sei sul terminale sbagliato.

**Prova su demo consigliata prima di fidarsi:** aprire a mano 0,01 lotti,
controllare che entro un secondo compaia lo SL a `ingresso - N` (BUY) e la
riga `SL a ...` nel log.

---

## 7. Come si toglie

- Tasto destro sul grafico → **Expert Advisors** → **Rimuovi** (oppure chiudere
  il grafico).
- Nel log compare `[STOPMANUALE] FERMATO`. **Gli SL già messi restano sul
  server** (sono ordini del broker): se non li vuoi più, si tolgono a mano dalla
  posizione. Lo stop virtuale invece smette subito di esistere.

---

## 8. Domande aperte per Claudio

1. **Pip o punti su indici e oro?** Con la regola automatica, "2 pip" sul DAX a
   2 decimali sono 0,02 punti indice: la guardia blocca. Per te "2 pip" sul DAX
   sono 2 punti indice (= 200 punti MT5)? E sull'oro 0,20 USD o 0,02?
2. **SL sul server o solo virtuale?** Oggi fa entrambe le cose (SL sul server +
   stop virtuale di riserva). Uno stop solo virtuale non si vede dal broker ma
   muore col terminale: sconsigliato.
3. **"Sotto di 2 pip" da dove?** Oggi la soglia si misura **dal prezzo di
   ingresso**, quindi lo spread è compreso: un BUY nasce già sotto di uno spread.
   Se intendi "2 pip di movimento contro, spread escluso", la soglia va spostata
   di uno spread: dimmelo e diventa un input.
4. **Su quale conto?** Il preset è pensato per il demo manuale `50503635`. Su
   FTMO le operazioni a mano contano come le altre per il regolamento: decisione
   tua.
