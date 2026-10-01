# SuperWave Dashboard v4.1 - nota tecnica (01/10/2026)

**File nuovo:** `mql5/Indicators/ABTG_SuperWave_Dashboard_v41.mq5` (indicatore, SOLA VISIONE: nessun ordine, nessuna rete).
**Base:** il file v4.00 che Claudio ha mandato il 01/10 (`docs/sorgenti_ricevuti/ABTG_SuperWave_Dashboard_ricevuto_2026-10-01.mq5`).
**Non toccati:** il file ricevuto e `mql5/Indicators/ABTG_SuperWave_Dashboard.mq5` (versione del repo).
**Collaudo:** `backtest_pipeline/collaudo_superwave_v41.py` (esito completo in `backtest_pipeline/risultati_archivio/SUPERWAVE_V41_COLLAUDO_2026-10-01.txt`).
**Stato:** NON compilato (qui non c'e' MetaEditor). Collaudo statico + funzioni pure compilate in C++ + misure su dati reali: tutto verde. **Prima di arrivare a Claudio passa dal cancello (`controllo-preventivo`).**

## 1. Le due "4.00": cosa le distingue

Stessa etichetta `#property version "4.00"`, due file diversi. Diff fra il ricevuto (695 righe) e quello del repo (936 righe, commit `a86089c8` del 26/07):

| Voce | Ricevuto (base della 4.1) | Repo | Nella 4.1 |
|---|---|---|---|
| Medie | 14 / 100 / 200 | 14 / **50** / 100 / 200 (input spostati: `InpMA2` = 50) | NON portato: cambia il significato di `InpMA2` |
| Incrocio 14x200 (asterisco, `InpShowCross`, `InpCrossWindow`) | no | si' | NON portato: funzione nuova, non una correzione |
| Cella accesa | inversione entro `InpFlipBars`=1 barre | segnale entro `InpMaxCandles`=10 barre, scrive le barre trascorse | NON portato: cambia la regola della cella |
| Ricalcolo | tutto ogni 3 s | a rotazione, `InpBatch`=6 simboli al secondo | PORTATO (idea e nome `InpBatch`), unito alla cache per barra chiusa |
| Lampeggio | pieno/nero ogni secondo, ridisegno sempre | ogni 2 s, fase attenuata (`Dim`), ridisegno solo se c'e' confluenza | PORTATO solo `Dim` (fase attenuata, mai nero); durata limitata e ridisegno solo su cambio sono nuovi |
| TP | multipli di R | default **livelli price action** (`InpTPmode`) | NON portato: i TP restano gli R di Claudio |
| Stop | Supertrend | Supertrend con **minimo 1 ATR** (`InpStopAtrFloor`) | NON portato: cambia lo stop |
| Rischio % | input | modificabile dal pannello, caselle copiabili | NON portato: cambia la forma del pannello |
| Heikin Ashi | disegnato SOPRA le candele | candele nascoste col colore di SFONDO | NON portato cosi': usata la tecnica di `ABTG_Segnali_EMA_BB_ST.mq5` (`clrNONE` + ripristino + riparazione, classi 963/971) |
| Nascondi | lascia a galla le scritte BUY/SELL e il titolo | cancella e ricrea la griglia | PORTATA la correzione (tutto nascosto, stato ridisegnato al Mostra) |
| Stop assurdo | nessun controllo | `MathAbs(entry-stop) > entry*0.5` -> niente operazione | PORTATO come controllo di lato (`SW_SetupOk`: stop sotto l'ingresso per BUY, sopra per SELL) |

**Quale gira sul grafico di Claudio: NON lo sappiamo.** Si riconosce dalla finestra Input: se ci sono `InpMA4` e `InpShowCross` e' quella del repo. La 4.1 parte dal ricevuto.

## 2. Cosa cambia nella 4.1 (in ordine di peso)

1. **Confluenza** (difetto 1, e il "lampeggiano senza confluenza" di Claudio). `InpConflMode=1` (default): il simbolo si accende quando **M3 si e' invertito da meno di 3 barre M3 chiuse nel verso dell'H4**, con **H4 senza inversioni nelle ultime 3 barre H4**. `InpConflMode=0` = regola v4.00 (stessa direzione). Misurato su XAUUSD M3, 150.000 barre: modo 0 acceso il **50,2%** del tempo, modo 1 il **3,1%** (circa 3,4 accensioni al giorno per simbolo, ognuna lunga al massimo 9 minuti).
2. **Lampeggio** (difetto 2). Lampeggia solo per `InpBlinkSeconds`=20 s dall'accensione, poi colore **fisso**. Nessun `ChartRedraw` se non cambia almeno un colore/visibilita' (la v4.00 ridisegnava tutto il grafico ogni secondo).
3. **Ricalcolo** (difetto 3, e "tasti non fluidi"). Ogni cella si ricalcola **solo quando c'e' una barra chiusa nuova** su quel TF (cache sull'ora dell'ultima barra chiusa, `iTime(sym,tf,1)`), a rotazione `InpBatch`=6 simboli al secondo. Specchio del flusso: **47,5 CopyRates al minuto contro 4.060** della v4.00 (85 volte meno), ogni cella aggiornata entro 4-5 s dalla chiusura.
4. **Dati non pronti** (difetto 4). Se `CopyRates` fallisce, rende poche barre o l'ultima barra non coincide con `iTime`, la cella **tiene lo stato precedente** e il tooltip dice `n/d` con il motivo e l'ora. Serie non sincronizzata con finestra piena: calcolo **PROVVISORIO**, rifatto al giro dopo (classe 981; dettaglio nel par. 6).
5. **Stesso algoritmo ovunque** (difetto 5). Una sola funzione `SW_STCore` per griglia, grafico e setup. ATR = media semplice del True Range (la convenzione di `iATR`), sommata ogni volta nello stesso ordine: lo stesso numero da qualunque barra parta la serie. Griglia su `InpGridBars`=1000 barre chiuse: misurato che lo stato della finestra aggancia quello dello storico intero dopo al massimo **146 barre** (molt. 3,5) / **236** (molt. 5,0); a 1000 barre 0 differenze su 150 punti, a 60 barre 18 su 400 (contro-esempio).
6. **Operazione = SETUP fisso** (difetto 6 + domanda di Claudio sui TP di segno opposto). Il setup appartiene a **(simbolo, TF del segnale)**: ingresso = **chiusura della barra di inversione** del Supertrend 3,5; stop = Supertrend su quella barra; R fisso; TP1/2/3 = ingresso +- 1/2/3 R; lotti dal rischio 1% con quote 40/30/30 (default di Claudio invariati). Resta fisso fino alla prossima inversione. **Clic su una cella accesa = seleziona quel setup** (resta mostrato anche se il grafico e' su un altro TF; le linee sono prezzi, valgono su ogni TF). Senza selezione: il setup del TF del grafico. Clic sul titolo del pannello = torna al TF del grafico. Il pannello mostra anche: "Setup M3 BUY, fissato alle hh:mm", "ingresso fisso a ...", distanza del prezzo dall'ingresso in punti e in R, stato dalla barra di inversione in poi (APERTO / TPk raggiunto / INVALIDATO / TP poi stop / stessa barra). Collaudo tick per tick (M1 reale -> M5): **0** barre con ingresso cambiato dentro la barra, **0** cambi fuori da una barra di inversione su 264; la regola v4.00 cambia ingresso in 11.079 barre su 11.091.
7. **Zona affidabile del setup.** Un setup si fissa solo su un'inversione ad almeno `SW_TRUST_BARS`=300 barre dall'inizio della finestra: prima, la finestra puo' "inventare" un'inversione che lo storico intero non ha (costruito nel collaudo: senza la regola esce un setup FALSO, con la regola viene rifiutato). Per inversioni piu' vecchie: il setup gia' fissato nella sessione resta; al riavvio vale la memoria in GlobalVariable (solo per il setup mostrato) e il pannello scrive "da memoria".
8. **Tasti senza ricarica** (difetto 7). HA, ST, LIVELLI, Nascondi non chiamano piu' `ChartSetSymbolPeriod`: i buffer mostrati si riempiono dai buffer di calcolo (tecnica di `ABTG_Segnali`), i livelli si ridisegnano da soli. Stato dei tasti e selezione del setup in **GlobalVariable con la ChartID nel nome** (`SW41_<ChartID>_HA/LIV/ST/HIDE/SEL_...`): sopravvivono al cambio simbolo/TF (il clic su una cella ricarica l'indicatore), si cancellano quando l'indicatore viene tolto.
9. **Heikin Ashi** (difetto 8). Candele native nascoste (`clrNONE` su 5 colori) e ripristinate su CANDELE e a ogni uscita; riparazione all'avvio se trova il residuo completo di un HA chiuso male; autoriparazione (max 3 volte) se qualcuno le rimette.
10. **Diagnosi** (`InpDiagnosi=false`). Accesa: tooltip completi e righe nel Journal a ogni cambio di confluenza (direzione H4 e M3, barre dall'inversione, ora della barra letta, barre usate, esito di CopyRates), a ogni `n/d` di M3/H4, un riepilogo al minuto (CopyRates, celle ricalcolate, ridisegni, oggetti), e il confronto **griglia contro grafico** sul simbolo/TF del grafico (riga `DIVERGENZA` se non coincidono). Ogni lampeggio si spiega con due numeri.
11. Minori: simboli vuoti e doppi tolti dall'elenco (prima: riga vuota con etichetta `""`, classe 982); livelli aggiornati sul posto invece di cancellati e ricreati a ogni tick; nessun calcolo pesante in `OnInit`; lotti con tetto `SYMBOL_VOLUME_MAX` e cifre del passo; valore del tick in perdita `SYMBOL_TRADE_TICK_VALUE_LOSS` (ripiego su `SYMBOL_TRADE_TICK_VALUE`).

## 3. Cosa NON cambia

- Tutti gli input del ricevuto restano con **nome, tipo e default identici** (il collaudo lo controlla uno per uno): rischio 1%, TP 1/2/3 R, quote 40/30/30, Supertrend 10 / 3,5 / 3,0 / 2,5, medie 14/100/200, colori, posizioni.
- La regola della **cella** (inversione entro `InpFlipBars`=1 barra chiusa), il clic cella -> simbolo+TF (`InpClickCambiaTF=true`), il clic nome -> simbolo.
- La **forma** del pannello in alto a destra (stesse righe e stesso ordine; aggiunte 3 righe in fondo: "ingresso fisso a ...", prezzo, stato).
- I livelli price action (stessa regola, 300 barre, frattale 2, 3 per lato).

## 4. Input nuovi (default)

| Input | Default | Cosa fa |
|---|---|---|
| `InpConflMode` | 1 (`CONFL_INVERSIONE_M3`) | 1 = inversione M3 recente nel verso dell'H4 stabile; 0 = regola v4.00 |
| `InpConflFlipBars` | 3 | modo 1: inversione M3 entro N barre M3 chiuse |
| `InpConflH4Stable` | 3 | modo 1: H4 senza inversioni nelle ultime N barre (0 = non richiesto). **Valore scelto da me, da confermare con Claudio**: misurato, cambia poco (3,3% del tempo con 0, 3,1% con 3, 3,0% con 6) |
| `InpBlinkSeconds` | 20 | secondi di lampeggio dall'accensione, poi fisso (0 = mai) |
| `InpBatch` | 6 | simboli controllati al secondo |
| `InpGridBars` | 1000 | barre chiuse lette per cella (minimo 400) |
| `InpClickCambiaTF` | true | clic su cella: anche il TF passa a quello della cella (comportamento v4.00) |
| `InpDiagnosi` | false | tooltip completi + righe nel Journal |

## 5. Come provarla (quando il cancello avra' dato PASS)

Bersaglio: **un terminale MT5 DEMO sul PC di Claudio**, mai sul VPS mentre la challenge opera, mai sul reale `10105439` (`C:\BCM_Reale`) ne' sul FTMO `541452707` (`C:\FTMO`). Per riconoscere la finestra senza "occhio" (finestra PowerShell sullo stesso PC, sola lettura): `Get-Process terminal64 | select Id, MainWindowTitle, Path`.

1. Copiare il `.mq5` in `MQL5\Indicators\` del terminale scelto, aprirlo in MetaEditor, F7: **0 errori** (e annotare gli avvisi).
2. Metterlo su UN grafico (es. EURUSD M15) con `InpDiagnosi=true`. Entro ~5 s la griglia e' piena.
3. Tasti: HA / ST / LIVELLI / Nascondi devono rispondere subito; nel Journal **nessuna** riga `AVVIATO` a ogni clic.
4. Simbolo acceso: passarci sopra col mouse -> tooltip con H4 e M3 (direzione e barre dall'inversione). Nel Journal la riga `confluenza nessuna -> BUY` con gli stessi numeri.
5. Cella accesa M3 di EURUSD: clic -> il pannello dice "Setup M3 BUY/SELL, fissato alle ..."; passare il grafico a H1: il pannello resta su M3 con gli stessi prezzi. Clic sul titolo del pannello -> torna al setup del TF del grafico.
6. Ogni minuto, riga di riepilogo: CopyRates nell'ordine di qualche decina; `confronti griglia/grafico ... divergenti 0`. Una riga `DIVERGENZA` va riportata (con il numero di barre del grafico).
7. Confronto col vecchio: sul grafico con la v4.00, cliccare LIVELLI e guardare il Journal: se a ogni clic compare `[SuperWave] AVVIATO` il tasto ricaricava l'indicatore; se no, era solo un ricalcolo (vedi checklist, difetto 7).

## 6. Rischi residui e cose NON verificate

- **Compilazione MQL5 [NON VERIFICATA]**: controllati a mano e dal collaudo statico parentesi, buffer, identificatori, costanti e funzioni; il blocco puro e' compilato in C++. Il resto (chiamate al terminale) no.
- **Scelta dichiarata, diversa dalla lettera del mandato**: con serie **non sincronizzata ma finestra piena e ultima barra giusta** la cella si calcola come PROVVISORIA (si rifa' a ogni giro) invece di restare ferma: se `SERIES_SYNCHRONIZED` restasse falso per sempre su un simbolo, la cella altrimenti non si aggiornerebbe mai (classe 981). Finestra incompleta e non sincronizzata: stato precedente tenuto, `n/d`.
- Scrittura dei buffer da `OnChartEvent` (tasti), `clrNONE` per nascondere le candele, tooltip con a capo: tecniche gia' usate in `ABTG_Segnali_EMA_BB_ST.mq5`, non provate in questo file nel terminale.
- Identita' griglia/grafico **dentro MT5**: stessa funzione, ma se il compilatore MQL5 fondesse le operazioni (FMA) in modo diverso nei due punti, potrebbe nascere uno scarto all'ultima cifra. La diagnosi lo scrive (`DIVERGENZA`).
- Grafico con meno di ~150 barre ("Max barre nel grafico" basso): il grafico puo' non aver agganciato lo stato; la diagnosi lo segnala.
- Selezione con nomi simbolo molto lunghi: la GlobalVariable ha un limite di 63 caratteri; se il salvataggio fallisce, Print nel Journal e la selezione non sopravvive al cambio simbolo.
- La memoria del setup (GlobalVariable `SW41S_...`) si salva solo per il setup mostrato; un'inversione piu' vecchia di ~700 barre, mai mostrata, al riavvio da' "in attesa".
- Lo stato dei tocchi usa massimo/minimo delle barre: se stop e TP cadono nella stessa barra l'ordine non si conosce (scritto "ordine non noto").
- Il lampeggio di 20 s riparte a ogni ricarica dell'indicatore (per le confluenze gia' accese).
- Un solo indicatore per grafico che nasconde le candele: con `ABTG_Segnali_EMA_BB_ST` in HA sullo stesso grafico i due si disturbano.
- **Non e' una strategia validata**: sono strumenti di lettura. I lotti sono indicativi.
- Classi nuove nate qui: **1040** (finestra con lo stesso stato ma una storia diversa: la zona affidabile del setup) e **1041** (controllo statico collaudato col refuso vero `gShST`), in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

## 7. Domande per Claudio (solo lui puo' decidere)

1. `InpConflH4Stable`: 3 barre H4 (12 ore) senza inversioni ti va bene, o preferisci 0 (basta la direzione)?
2. Un setup **invalidato** (stop toccato) va ancora mostrato col suo stato (cosi' e' ora) o va nascosto finche' non c'e' una nuova inversione?
3. `InpClickCambiaTF`: il clic su una cella deve continuare a cambiare anche il TF (default attuale) o restare sul TF che stai guardando?
