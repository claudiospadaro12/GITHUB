# EA GBA (`ABTG_GoldBreakoutATR`) -- note di costruzione (09/10/2026)

**Che cos'e'**: `mql5/Experts/ABTG_GoldBreakoutATR.mq5` v1.10, l'EA "notturno sull'oro" di Emiliano **ricreato dalla descrizione** (live del 09/10 + foto/testo dei pannelli: `report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md`). Il suo codice non lo abbiamo e non lo copiamo.
**Collaudo a tavolino**: `backtest_pipeline/collaudo_gba.py` (statico + funzioni vere dell'EA compilate in C++ + specchio Python + simulazione + mutanti).
**Stato**: scritto, **NON compilato** (MetaEditor non c'e' in questo ambiente), **NON testato nel tester**, **NON passato dal cancello**. Nessun numero di performance e' nostro: PF 2,03 / 62 operazioni / "nessuna notte negativa" sono **DICHIARATI** da Emiliano su un campione di circa una settimana.

---

## 1. Fedele alla descrizione (regola -> funzione)
| # | Regola (fonte) | Dove nel codice |
|---|---|---|
| R1 | segnale alla **chiusura** di una barra del TF del segnale (live: "quando la chiusura di una barra...") | `OnTick` -> primo tick della barra nuova -> `GbaNuovaBarra` |
| R2 | close > **massimo delle N barre precedenti, esclusa la barra di segnale** (N = 48, foto) e close > **EMA 100**; specchio per lo short | `GbaCanale` + `GbaDirezione` (rottura e lato EMA **stretti**) |
| R3 | ingresso **a mercato** nella direzione della rottura | `GbaApri` al primo tick della barra successiva |
| R4 | spread massimo = **0,05 x ATR** (foto, file Input) | `GbaSpreadOk` (0 = filtro spento) |
| R5 | **SL iniziale = 2,5 x ATR(14)** (foto) | `GbaApri` |
| R6 | **trailing = massimo dall'ingresso - 2,5 x ATR** (minimo + per lo short), solo a favore (foto) | `GbaEstremo`, `GbaSLProposto`, `GbaSLMigliore` |
| R7 | **uscita a tempo dopo 48 barre** del TF del segnale (live + foto) | `GbaUscitaTempo` |
| R8 | **breakeven** acceso (foto: true), si arma a **+1,0 ATR**, SL = ingresso **+/- 0,0 ATR** | `GbaBeArmato`, `GbaSLProposto` |
| R9 | una posizione per magic e simbolo | `GbaPosizioneAperta` |
| R10 | **perdita giornaliera massima in valuta**, 0 = spenta (foto 0; in live "la uso") | `GbaPnlGiorno` + `GbaGiornoBloccato` |
| R11 | **verifica del margine libero** prima dell'ordine (foto: true) | `GbaMargineOk` |
| R12 | **filtro orario** sulle ore server dei NUOVI ingressi, 0-24 = nessun filtro (foto) | `GbaOraOk` |
| R13 | **slippage massimo 30 punti** (foto) | `trade.SetDeviationInPoints` + `PositionClose` |
| R14 | lati LONG/SHORT accendibili (pannello: "LONG ON / SHORT ON"), default entrambi accesi | `GbaDecidi` (`InpAllowLong`, `InpAllowShort`) |
| R15 | **tetto di operazioni APERTE per giorno server** (audit del dossier Gold Breakout PRO, spec. par. 12: il prodotto del Market dichiara "Max Trade Per Day"; Emiliano NON ne parla e il suo pannello mostra 12 operazioni in un giorno): `InpMaxTradesPerDay`, **default 0 = nessun limite = replica fedele** | `GbaTroppeOggi` + `GbaAperteOggi` + `GbaDecidi` (motivo `GBA_TETTO`) |
| -- | Guardian (firme B1/C1) **immediatamente prima** di `trade.Buy`/`trade.Sell`, mai su chiusure e spostamenti dello stop | `GbaApri` |

**Asse spread (spec. par. 9)**: `InpSpreadMaxATR` default **0,05 = REPLICA** dichiarata (valore del file Input); **0,10 / 0,20 / 0,35 = celle di MISURA** (alle 08:52 il pannello era a 0,35). Il log di avvio stampa lo stop/spread minimo garantito (`InpSL_ATR / InpSpreadMaxATR`: 50x a 0,05, 7,1x a 0,35 -- sotto la frontiera di casa `stop >= 40 x spread`). Ogni segnale **scartato per spread** si stampa sempre (anche con `InpVerbose=false`) con **spread/ATR in %** e **stop/spread**; in `OnDeinit` la riga `[GBA-CONTA]` conta segnali, ingressi tentati e scarti per motivo (SPREAD, posizione aperta, ora, perdita giornaliera, lato spento, ATR non valido).

**Lotto**: `InpLotMode = 0`, `InpLots = 1,00` = **decisione di Claudio del 09/10 ("LOTTI 1, INIZIAMO COSI'"), riportata dal coordinatore e scritta nella spec. par. 6**. Il pannello di Emiliano mostra 10,00. **1,00 lotto XAUUSD = 100 oz: 1 USD di movimento = 100 USD.** La perdita a SL = 2,5 x ATR x 100 x lotti, quindi **dipende dall'ATR del momento** (con ATR 1,35 USD: ~337 USD a SL); **il rischio in % dipende dal conto, che non e' deciso** -- l'EA non dichiara nessun rischio %. Il modo 1 (rischio % del saldo con lo SL) esiste con `InpRiskPct = 0,25` **SEGNAPOSTO DA FIRMARE DA CLAUDIO**.

**Tetto giornaliero (v1.10)**: conta i deal d'**ingresso** (`DEAL_ENTRY_IN`) di questo magic su questo simbolo dalla **mezzanotte server** (`GbaInizioGiorno`, la stessa della perdita giornaliera); raggiunto il tetto blocca **solo i NUOVI ingressi** (la posizione aperta resta gestita). Ogni segnale scartato per il tetto stampa **sempre** la riga `[GBA] TETTO GIORNALIERO` (operazioni aperte oggi, giorno server, max); `[GBA-CONTA]` porta il conteggio `tetto giornaliero` accanto agli altri scarti. Il conteggio legge lo storico solo se il tetto e' acceso e c'e' un segnale. E' un **asse da misurare** (es. 0 / 1 / 2 / 3), non un valore deciso.

## 2. NOSTRE scelte (non dette da Emiliano: da dichiarare accanto a ogni numero)
1. **TF di EMA e ATR** [APERTO, spec. par. 4.1]: input `InpTrendTF` / `InpAtrTF`, default `PERIOD_CURRENT` che qui significa **uguale al TF del SEGNALE (non al grafico)** -- semantica nostra, dichiarata nel commento dell'input e nel log. Su TF diverso si legge la barra **chiusa** all'apertura della barra in corso del segnale (niente look-ahead).
2. **ATR di trailing e breakeven** [APERTO, nuovo input `InpTrailAtrMode`]: default 0 = ATR dell'**ultima barra chiusa** (si aggiorna); 1 = ATR della **barra di segnale** (fisso). La descrizione non lo dice.
3. **"Massimo dall'ingresso"** = massimo dei massimi delle barre dalla barra d'ingresso a quella in corso (prezzi **Bid**, come le barre MT5). Conseguenze: (a) se l'ingresso non avviene al primo tick, la barra d'ingresso porta anche i tick prima dell'ingresso; (b) per lo short si usa il minimo dei Bid mentre lo stop scatta sull'Ask: la distanza effettiva e' `kTrail x ATR - spread`. Scelta **senza stato**: un riavvio del terminale non perde niente.
4. **Breakeven** misurato sul prezzo di chiusura corrente (Bid per il long, Ask per lo short), con `>=`; se armato, vince il piu' favorevole fra BE e trailing. Una volta spostato lo stop non torna indietro (solo a favore).
5. **Uscita a tempo** conta le **barre esistenti** del TF (`iBarShift`), non i minuti: dove mancano barre (pausa giornaliera dell'oro, minuti senza tick di notte) la posizione vive piu' di 48 minuti di orologio. Si chiude alla barra N (dopo N barre intere).
6. **Ora del filtro** = ora server dell'**apertura della barra** d'ingresso. `Start > End` = a cavallo della mezzanotte (es. 22-6); `Start == End` = **nessun filtro** (scelta nostra, stampata in avvio). BCM e' **UTC+1 fisso**: d'estate ora italiana - 1, d'inverno = ora italiana.
7. **Perdita giornaliera**: solo questo magic su questo simbolo; deal del **giorno server** (profitto + swap + commissioni + fee) + flottante della posizione viva; **blocca solo i NUOVI ingressi, non chiude la posizione aperta**; si azzera a mezzanotte server (una "notte" a cavallo della mezzanotte ha DUE giornate). Calcolata solo quando c'e' un segnale.
8. **Lotti**: arrotondati in GIU' al passo; **sotto il minimo l'ordine si salta** (non si alza il lotto); sopra il massimo si taglia al massimo con avviso. Valore del tick dal lato perdita (`SYMBOL_TRADE_TICK_VALUE_LOSS`).
9. **Stops level**: se lo SL iniziale e' troppo vicino si **salta** l'ordine (non si allarga lo stop); il trailing rispetta `max(STOPS_LEVEL, FREEZE_LEVEL)`. SL arrotondati al tick piu' vicino; uno spostamento parte solo se migliora di almeno mezzo tick.
10. **Avvio a meta' barra**: il primo segnale si valuta alla barra nuova successiva. Una barra con dati non pronti viene **consumata** (si stampa).
11. **Ordine in `OnTick`**: prima la gestione (tempo, BE, trailing), poi il segnale. Se l'uscita a tempo chiude sulla barra nuova, la stessa barra puo' aprire.
12. **Nessuna uscita su segnale opposto** (non descritta). Niente TP.
13. **Spread** = Ask - Bid al primo tick della barra nuova.
14. **Magic 775800** (blocco 7758xx, zero occorrenze nel repo il 09/10). Il magic della foto (20261105) non si usa. Nota: avevo scelto il blocco 7751xx, ma durante la stesura `ABTG_Bulge_Telemetria.mq5` (altro agente, WIP 17bcc4ba) ha preso quel blocco: il collaudo l'ha trovato e mi sono spostato io. Il numero esatto non e' scritto qui apposta, per non far scattare il controllo 'magic libero' del collaudo dell'altro EA. Commento ordini `GBA_L` / `GBA_S` (5 caratteri).
15. **Tetto di operazioni (R15)**: un'operazione = un deal d'ingresso (un riempimento parziale ne conterebbe piu' di uno; con una posizione alla volta e ordini a mercato non dovrebbe capitare); il giorno e' quello **server** dell'apertura della barra di segnale (una "notte" a cavallo della mezzanotte ha DUE tetti); l'ordine dei cancelli e' lato -> posizione aperta -> ora -> perdita giornaliera -> **tetto** -> ATR -> spread, quindi uno scarto viene contato una volta sola, sotto il primo cancello chiuso.
16. **Mancano** rispetto all'EA di Emiliano: pulsanti e pannello, il suo log `GBA_events.csv`, il filtro "SESSIONE" (semantica non chiara), il "RESET A INPUT". Manca anche, rispetto agli EA di casa, un `OnTester` con export per-trade: **il round lo legge dal report del tester** finche' non si aggiunge.

## 3. Che cosa NON ho potuto verificare
- **Compilazione MQL5**: MetaEditor non c'e'. Il codice usa solo API gia' presenti in altri EA del repo, ma la prima compilazione e' di Claudio. Punti da guardare se il compilatore si lamenta: `MathMax` su due `long` in `GbaGestisci`, formati `%I64u`.
- **`GbaApri`, `GbaGestisci`, `GbaPnlGiorno`, `GbaMargineOk`, `GbaPosizioneAperta`** (API di conto/ordini): solo controlli statici, nessuna esecuzione.
- **Guardian** oltre la sua riga (fail-open nel tester, come gli altri EA).
- **iMA/iATR del terminale**: il collaudo usa EMA e ATR calcolati in Python come buffer; prova il **cablaggio** (quale barra, quale handle, quale TF), non i valori del terminale.
- **Frequenza, PF, DD, costo**: niente. Lo spread BCM sull'oro di notte e quanto spesso passa il cancello del 5% e' **la prima misura** (contatore `[GBA-CONTA]`).
- **Fill reali**: con trailing a ogni nuovo massimo su M1 l'EA manda molte modifiche di stop; nel tester va bene, dal vivo va guardato il carico (eventuale passo minimo = scelta da misurare).

## 4. Il collaudo (`collaudo_gba.py`), esito al 09/10
`python3 backtest_pipeline/collaudo_gba.py` -> **ESITO: PASS** (v1.10), 141 controlli ok, **mutanti presi 88/88** (50 di logica, tutti presi da P o X; 38 statici). Durata ~9 minuti.
- **S** statico: ASCII/LF/parentesi; niente WebRequest/SendMail/SendNotification/SendFTP/OrderSend/#import; 30 input con nome/tipo/default dichiarati; magic e blocco liberi in tutto il repo; Guardian prima di ognuno dei 2 invii (solo in `GbaApri`), mai in `GbaGestisci`; SL = `InpSL_ATR x ATR`; retcode; margine; slippage a CTrade; handle rilasciati; `OnTick` gestisce prima del segnale; log di avvio con **tutti** gli input; righe dello spread e contatore; 25 `PrintFormat` con segnaposto = argomenti.
- **P** funzioni vere dell'EA compilate in C++: nucleo dell'autotest a 0 fallimenti; 3000 casi casuali per canale, decisione e gestione + 4000 per estremo/lotti/giorno contro lo **specchio Python scritto dalla specifica**, con prezzi sulla griglia 0,01 per provocare i pareggi.
- **Tetto (v1.10)**: 1000 casi ai bordi della mezzanotte (00:00:00, 23:59:59, +/-1 s, +/-1 giorno) per `GbaInizioGiorno`/`GbaStessoGiorno`/`GbaTroppeOggi`; casi del tetto nel nucleo dell'autotest (2 su 2 bloccato, 1 su 2 libero, 0 = nessun limite anche a 50 aperte, posizione aperta prima del tetto); due configurazioni di simulazione (tetto 2/giorno; tetto 1/giorno con ore 22-6 a cavallo della mezzanotte): **mai piu' di N ingressi per giorno server** e dopo la mezzanotte si riapre (6 celle con ingressi il giorno 2), 1268 scarti per tetto. Mutanti: `>` invece di `>=`, 0 che non spegne, giorno = settimana, mezzanotte spostata di un'ora, tetto ignorato, motivo sbagliato, tetto prima della posizione aperta -> tutti presi da P **e** X; default 2, conteggio dei deal di USCITA, riga del tetto solo se verbose, tetto tolto da `[GBA-CONTA]`, conteggio mai chiamato -> presi dallo statico.
- **X** simulazione: le **letture vere** (`GbaLeggiSegnale`, `GbaLeggiGestione`, `GbaShiftChiusa`, `GbaLeggiBuffer` con `CopyHigh/CopyLow/CopyClose/CopyBuffer/iBarShift/iTime/ArraySetAsSeries` simulati con la semantica MQL5) guidate tick per tick su 10 configurazioni x 3 semi (EMA o ATR su M5, ATR fisso, BE spento, asse spread 0,05/0,10/0,20/0,35, ore 22-6 e 3-11, lati spenti, tetto 1 e 2 al giorno) di 1800 barre M1 che attraversano una mezzanotte server: **877 operazioni identiche** allo specchio, uscite a SL, TEMPO e FINE; scarti per spread 154, posizione 4594, ora 1070, lato 915, tetto 1268.
- **Un mutante equivalente dichiarato** (non e' un buco): "EMA cercata con il TF dell'ATR" non cambia niente, perche' all'istante corrente `iBarShift` da' 0 su qualunque TF; il TF conta solo per un istante passato (ATR fisso del modo 1), ed e' quello mutato in L34.

## 5. Dubbi aperti (da chiedere a Claudio / a Emiliano)
1. TF di EMA e ATR (default: TF del segnale; la verifica numerica della spec. par. 8.1 dice ATR su M1, EMA [INFERITO]).
2. ATR del trailing: aggiornato o fisso all'ingresso (`InpTrailAtrMode`).
3. "Massimo dall'ingresso": massimo delle barre (Bid) o del prezzo di tick visto dall'EA? E per lo short, Bid o Ask?
4. Uscita a tempo: barre esistenti o minuti di orologio?
5. Perdita giornaliera: chiude anche la posizione aperta o blocca solo i nuovi ingressi? Quale giorno (server, locale)?
6. Ore notturne vere e orologio del suo pannello (05:30-06:39 di cosa?).
7. Con quale spread massimo sono nate le 62 operazioni (0,05 o 0,35)?
8. Lotto: 1,00 deciso da Claudio; il conto non e' deciso -> il rischio % non e' calcolabile oggi.
9. Filtro "SESSIONE ON" del pannello: che cosa fa?
10. Il trailing a ogni tick su M1 genera molte modifiche: accettabile sul conto scelto?
11. **Tetto di operazioni al giorno** (v1.10): il default 0 replica Emiliano, che non ne parla (12 operazioni nel suo giorno record). Se usarlo, e con quale N, e' una decisione di Claudio **dopo** la misura dell'asse; e il giorno da usare (server o una "notte" a cavallo della mezzanotte) va deciso insieme alle ore.
12. **GBA_events.csv**: il nostro EA non scrive un CSV di eventi (si legge dal giornale e dal report del tester).

## 6. Le misure prima di qualunque campo (certificato dei 5, nessuna riga di lancio qui)
Tutte **ipotesi da misurare, mai criteri**: (1) replica dei default (spread 0,05) con PF/n/DD; (2) asse spread 0,05/0,10/0,20/0,35 con la frequenza che ne esce e lo stop/spread; (3) uscita ad asse (trailing, tempo, BE on/off, `InpTrailAtrMode`); (3-bis) tetto di operazioni al giorno 0/1/2/3; (4) TF M1/M3/M5 ed EMA 50/100; (5) ore notte contro giorno (fasce a priori); (6) simboli gemelli da dichiarare; (7) tutti e due i lati, sempre; con **tick reali** e il costo vero dello spread notturno. Nulla sul conto reale, nulla sui conti di campo finche' non c'e' il PASS dei cancelli e le firme di Claudio.
