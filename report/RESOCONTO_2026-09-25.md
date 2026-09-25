# 📋 RESOCONTO DEL 25/09/2026 — giorno 5 della challenge FTMO `541452707`

**107 commit oggi su `lavoro`.** Mancano 6 giorni al 1° ottobre. Il netto del giorno trade per trade lo fa la pagella delle 23:00 (`report/giornata_2026-09-25.md`): qui c'e' il punto sul PROGETTO.

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA
- **Runner delle 03:30** (`coda/referti/*_20260925_033004.log`): 12 righe di sola lettura, 0 nella corsia ROUND. Ha confermato la sospensione hedging sul 100k e sul reale, e ha trovato l'ORB EURAUD ancora vivo sul reale (`ORB_EURAUD_SUL_REALE_2026-09-25.md`: preset del Dow, ingresso irraggiungibile, 0 fill).
- **Round sul PC di backtest, girati da Claudio**: R248 (finestra vergine, 4 min), **R251 (short DAX, 24 passate, 5 min)**. Riproduzioni **VERDI al centesimo** in tutti e due.
- **Seconda caccia (agente, regola del 19/08)**: 10 meccanismi short DAX misurati su 8 anni di DAX cash esterno; 1 sopravvissuto (gap-down continuation), audit della caccia PASS con correzioni, oggi ridimensionato a "prova di catena, non candidato sedia" (`caccia_strategie/CACCIA_DAX_SHORT_2026-09-25.md`).
- **Cancello**: 24 passate di controllo oggi; ha trovato difetti in **ogni** consegna, comprese le mie. Classi nuove **772-805**.

## 💶 IL CONTO
- **FTMO `541452707`**: saldo **75.090,72** (−6,14% dal 80.000) dopo il **terzo stop** (`770101` DAX, −1.552,80, slittamento 0,65 pt). Tre stop pieni in cinque giornate, **tutti eseguiti da contratto** (`TERZO_STOP_FTMO_2026-09-25.md`, con errata). Al target di fase (88.000) mancano **12.909**.
- 🔴 **Correzione mia del pomeriggio**: il Guardian in campo e' **4,5 / 9,3 / 3,5 / cap 4,00**, non 4,9/9,9/4,0 come avevo scritto al mattino (fonte: `CODA_08` 25/09, `chart06.chr`). All'emergenza totale (72.560) mancano **2.530,72 EUR**: il secondo stop pieno di fila **ferma la challenge**, e il blocco non scade da solo. ✏️ **CORRETTO LA SERA DEL 25/09, e la correzione cambia il MOTIVO.** Qui c'era scritto *"2.530,72 EUR = due stop pieni a 2%"*: **falso in aritmetica**. Due stop pieni da qui costano **2.973,59** (1.501,81 + 1.471,78 — la taglia scende col saldo) e **sfondano** l'emergenza di **442,87**, che e' il "443 EUR SOTTO" gia' scritto in `TERZO_STOP_FTMO_2026-09-25.md` §3. Scritta come **equivalenza** la frase diceva il contrario del motivo: il secondo stop ferma la challenge **perche' due stop sono PIU' del margine**, non perche' sono uguali. Uno solo si regge (73.588,91, DD 8,01%, **1.029 EUR sopra**). Trovato dal cancello sulla pagella del 25/09.
- **MC dallo stato di oggi** (`MC_DALLO_STATO_DI_OGGI_2026-09-25.md`): PASS **57,2%** a 2,00% (fine entro 5 giorni di borsa 21-24%); 75,3% a 1,00% e 88,1% a 0,65% sono solo riferimenti, **nessuna proposta**. 4 sedie su 6 nel modello, un inverno solo.
- **La serie di stop**: nel backtest capita **una volta ogni 2-4 mesi**; nel forward, con le sedie come oggi, **mai** (`QUANTO_E_RARA_LA_SERIE_2026-09-25.md`). Ma tutti e 6 gli episodi storici supererebbero l'emergenza di oggi.
- **Dry-run 100k `50504263`**: sospese le sedie indice (225JPY rimosso 13:14:47); salvataggio del profilo [NON VERIFICATO] fino a CODA_01 del 26/09. **SlippageLogger sul reale**: [NON MISURATO oggi].
- **Reale `10105439`**: solo l'ORB EURAUD, che non puo' riempire. Decisione aperta dal 16/09.

## 🔬 COSA HO DECISO IO (con il numero)
1. **Sospensione delle sedie indice sui demo** (piccolo 15/15 alle 13:07, 100k alle 13:14:47): FTMO ha scritto che l'hedging fra conti vale anche sui demo e sugli indici correlati; misurato 1 episodio opposto il 22/09 e **10 giornate su 28** a rischio con le sedie accese (`HEDGING_DEMO_E_CORRELATI_2026-09-25.md`).
2. **R251 verdetto**: short identico al long e ogni ritocco d'uscita **BOCCIATI PER RISCHIO** (DD_fisso 10,4-24,2% IS contro 5,79% del long); filtro Supertrend passa il rischio ma merito sospeso, H12 isolata (`REFERTO_R251_2026-09-25.md`).
3. **R252 preparato e riga PASS**: lo short con l'ora in fase con la cash; **tutto il DD OOS dello short cade nell'inverno sfasato** (20/11-23/01). Riga mandata a Claudio alle 20:4x, in attesa dello zip.
4. **R253 preparato (PASS file prova)**: gap-down short, ricerca. Riga in scrittura.
5. **Errori miei del giorno, tutti presi dal cancello prima di arrivare a Claudio** (o corretti subito dopo): il Guardian 9,9 invece di 9,3; "6 su 6" nel feed; l'ipotesi "rimbalzo a V" data per smentita quando e' solo non sostenuta; il segno della stagione nell'R251 (opposto ai precedenti, non uguale); la pulizia del Desktop riscritta da zero mentre in repo c'era gia' lo script con sei guardie (classe 494).

## ⚠️ COSA ASPETTA CLAUDIO
- 🖊️ **Firmato oggi** (`FIRME_2026-09-25.md`): la sedia **`770105`**, gemella SHORT della 770101, **su FTMO al 2%**. Preset scritto sul terminale alle 20:45 (`ESITO: FATTO`), **attaccata alle 20:47:27** (Journal). Entra per firma, non per promozione: R251 l'ha bocciata per rischio. Conferma richiesta: foto Esperti `lati=SOLO SHORT` e Proprieta' della 770101.
- **TrailFix** (la raffica di `modify`, vista di nuovo oggi alle 11:29): con la 770105 il caso peggiore sale a ~2.628 richieste/giorno contro le 2.000 di FTMO. E' una ricompilazione: firma sua.
- **Taglia e cap** (2,00% / 4,00 in campo contro 3,25 firmato): i numeri sono nel MC; la decisione resta sua. Il cap 3,25 **non** blocca la seconda posizione al 2% (r.789: rischio gia' aperto).
- **ORB EURAUD sul reale**: lasciare, spostare o staccare (dal 16/09).
- **Cambio di taglia a meta' challenge**: se ammesso da FTMO e' [NON VERIFICATO] (Forbidden Practices).
- Sera: Claudio ha chiesto un EA scalper direzionale per il **manuale demo `50503635`**; il file `ABTG_ScalperDirezionale.mq5` e' scritto ma **fermo** ("ASPETTA"): non committato, non inviato, non passato dal cancello.

## 🎯 DOMANI
1. **CODA_01 delle 03:30**: `.chr` della 770105 su `C:\FTMO`; zero sedie indice su piccolo/100k/reale; profilo 100k salvato.
2. **Zip di R252** da Claudio → referto → dice se lo short in fase regge il rischio (la 770105 e' gia' in campo: il numero serve comunque).
3. Riga R253 → cancello → Claudio (ricerca, ~2-4 min).
4. `ABTG_StopManuale` (guardia dello stop per le operazioni a mano, manuale demo) → cancello.
5. Lo scalper direzionale: aspetta Claudio.
6. Aperto: R246 INVERNO (mai arrivato lo zip), R249 (riga pronta), Storico del piccolo dall'app (PunteLarry).

🧭 **Bussola, detta onesta**: oggi **una sedia e' entrata in campo** (770105), per firma di Claudio e con il rischio dichiarato; una pista misurata (R252) puo' darle un numero domani. Il resto della giornata e' misura e ponteggio, e va detto.
