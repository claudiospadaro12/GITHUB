# Checklist in ordine di priorita prima di aprire le due challenge (P1 + P4, 2-Step Swing da 80.000 EUR) - 14/11/2026

**Natura**: elenco operativo ricavato dai nostri file (`P1_ELENCO_SET_E_CONTROLLI`, `P4_ELENCO_SET_E_CONTROLLI`, `FTMO_RISPOSTE_12_DOMANDE`, `NOVITA_EXPERT_DISCORD_2026-11-14`, manuale Reaper V5.1). Non e un consiglio di acquisto, di lotto o di taglia. Cosa e verificato e cosa no e indicato riga per riga. Nessun conto reale, trial o VPS e stato toccato da me. (Nota: i titoli di P1/P4 dicono 160k perche scritti prima: le challenge Swing sono da 80k; set e input restano uguali.)

## 1. Licenze e rete (VPS e trial) - prima di tutto, altrimenti gli EA non partono
1. Opzioni MT5 > Expert Advisors > "Consenti WebRequest per gli URL elencati": `https://forexeasolutions.org/`, `https://forexeasolutions.services/` (se comprato su forexeasolutions.com), `https://www.tradewithwim.com/` (se ricevuto direttamente da Wim), `https://www.worldtimeserver.com/`, `https://nfs.faireconomy.media/` [fonte: manuale Reaper V5.1; il manuale UBS/altri EA potrebbe elencare altri URL: NON VERIFICATO].
2. Sul pannello di ogni EA deve comparire la licenza trovata. Se compare "license invalid" solo sul VPS: disattivare IPv6 [Wim, 07/11, "often helps"].
3. Calendario MT5 sincronizzato su ogni terminale nuovo (Toolbox > Calendario, aprirlo una volta) per il filtro NFP [manuale Reaper]. Da rifare dopo la migrazione Contabo.
4. Versioni: Reaper 5.6 (28/10), Goldbot One V3.5, Gold Trade Pro V7.2 (profilo `C:\MT5_Wim`); confrontare con la dashboard di Wim (Wim ha ricaricato gli EA il 07/11 senza cambiare il numero di versione). NON VERIFICATO quali versioni stanno sul VPS e sul trial.
5. Contabo (upgrade): solo dopo i 5 controlli del promemoria (oro chiuso, posizioni piatte, copia di sicurezza, risposta del supporto, FTMO). Dopo: ogni terminale riparte, Guardian OK, licenze OK, calendario OK.

## 2. Guardian (la protezione vera: il limite giornaliero interno degli EA NON ha impedito giorni a -6% nei nostri test del Reaper L0)
1. `InpStartBalance` = **80.000** (non 100.000) su ogni conto FTMO [nota di Massimo]. Guardian su un grafico XAUUSD (va bene).
   **`InpDailyResetHour` = 1 sui conti FTMO** (il server FTMO e ora italiana + 1 e il reset FTMO e a mezzanotte italiana = 01:00 server). Il preset BCM demo ha 0 (server BCM = ora italiana in inverno): non copiare 0 sui conti FTMO senza controllare. [da `FTMO_REGOLE_LETTE_ANALISI_2026-11-07.md` e dal commento del set `ABTG_Guardian_DEMO100K_BCM.set`; l'orario del server FTMO va confermato sul Market Watch il giorno della partenza.]
2. Soglie: 4,5% giornaliero e 9,5% totale come scelto da Claudio; le simulazioni dei miei referti usano 4,3%. Il Guardian NON e simulato nel tester: quanto salvi nei casi estremi e NON MISURATO.
3. Dopo la partenza leggere ogni giorno la riga `[GUARDIAN]` (equity, dayLoss, totDD, rischioAperto, stato).

## 3. Trial: caricare davvero P1 e P4 (e' la prova piu vicina alla realta)
1. P1: Gold Phantom `GoldPhantom_Propfirm.set` (XAUUSD H1, magic 75000), Goldbot One `Goldbot_PropFirm_5_2.5.set` (XAUUSD D1, magic 2000), Daytrade Pro `Daytrade_Pro_Max9%DD_lowrisk.set` (un grafico, `RunOneChartSetup=1`, magic 5656). P4: Reaper `Gold_reaper_propfirm_combo_3GOLD.set` al posto del Phantom; Goldbot e Daytrade Pro identici. Elenchi e input da verificare dopo il caricamento: nei due file `P1_/P4_ELENCO_SET_E_CONTROLLI`.
2. Un solo set per EA e un solo EA per grafico; magic diversi; nessuna altra posizione sul conto.
3. Le 13 coppie del Daytrade Pro devono esistere nel Market Watch FTMO con il nome esatto (EURUSD;GBPUSD;USDJPY;AUDUSD;XAUUSD;GBPJPY;USDCAD;EURJPY;EURNZD;EURAUD;NZDUSD;AUDJPY;CHFJPY).
4. Reaper e Phantom nei set hanno Randomization 50 (rumore ai risultati; nei test era a 0). Goldbot e Daytrade Pro a 0.
5. Mandarmi l'esportazione "Report cronistorico dei trade" del trial dopo 2-3 giorni e dopo 2-3 settimane: la confronto con le tabelle (EA, costi, slippage, giorni).

## 4. Spread e condizioni FTMO sull'oro (la grande incognita: FTMO non lo dichiara)
Fotografare (schermata intera con data e ora del server) in 3 momenti diversi, per esempio notte (circa 03:00 ora italiana), mattina europea (circa 10:00) e apertura USA (circa 15:30), piu, se riesci, il rollover (intorno a 23:00-00:00 ora italiana): Market Watch con XAUUSD (bid/ask), la finestra Specifiche (clic destro > Specifiche: spread, dimensione contratto, lotto minimo e passo, swap long e short, margine, orari di trading) e un'operazione di prova con un lotto 0,01 solo se hai gia deciso di farla (non lo chiedo). Gli orari sono una MIA proposta (spread piu alti a rollover e a ridosso delle notizie). Il server FTMO = ora italiana + 1.
Mandarmi le foto: le uso per ricalcolare i costi extra (ipotesi attuale 36 EUR/lotto round turn sull'oro, centrale; il doppio, prudente).

## 5. Prima di cliccare "acquista"
0. **Leggere i Termini e Condizioni FTMO (PDF "General Terms and Conditions - Global", collegato da ftmo.com/en/terms-and-conditions/, pagina modificata il 26/08/2026)**: e il documento che contiene le clausole su EA, hedging tra conti, richieste al server, copy trading, tetto di capitale e stop out; le pagine HTML ufficiali non le riportano e il lettore automatico non puo aprirlo (il sito lo blocca). Scaricarlo dal browser di Claudio e mandarmelo: lo leggo e confronto con le risposte scritte di FTMO del 13/11.
1. Tipo di conto: 2-Step **Swing**, 80.000 EUR; leva oro/indici 1:15, forex 1:30 (risposta scritta FTMO). Margine su P1 e P4 stimato circa 50-59% del saldo.
2. Valuta EUR ammessa. **Reset del limite giornaliero: 00:00 CE(S)T**, cioe mezzanotte italiana (pagina ufficiale ftmo.com trading objectives, modificata il 02/11/2026; era gia nel nostro `FTMO_REGOLE_LETTE_ANALISI_2026-11-07.md`). Livello di stop out: FTMO non ha risposto (Claudio ha deciso di non scrivere ancora).
3. **Posizioni opposte tra conti**: FTMO vieta "cross-account hedging in modo rigoroso" e non ha chiarito come lo misura. Nel tester P1 e P4 hanno avuto circa 2.451 ore in 3 anni con posizioni oro opposte (Phantom contro Reaper/Goldbot). Resta un rischio non misurato; Claudio ha deciso di procedere senza ulteriori mail.
4. Tetto 400.000 $ per strategia: Goldbot e Daytrade Pro sono identici su P1 e P4 (circa 180.000 $ per i due conti da 80k); con le challenge di Massimo sugli stessi EA il totale per EA si avvicina al tetto: non chiarito se EA con set diversi contano come stessa strategia (FTMO ha detto: ognuno opera i propri).
5. Nessuna taglia aumentata dopo i giorni minimi; filtro NFP acceso.

## 6. Stato dei test in corso
- Tick reali 2025 su Goldbot L0, Phantom L1 e Reaper L3 (160k): in corso sul PC di backtest. Serve solo a controllare che i test a candele da 1 minuto siano affidabili per il Phantom. Non e un prerequisito.
- Candela di conferma (UBS Goldbot daily e GTP, 382 contro 283 set): rinviata, riguarda UBS e Gold Trade Pro; non e nei set P1/P4.

## Aggiunta (14/11, dopo la lettura del testo ufficiale FTMO)
- **Richieste al server**: FTMO vieta l'EA con "more than 2,000 server requests per day on individual simulated trades or pending orders" (ftmo.com, forbidden trading practices, modificata il 02/11/2026). Probabilmente le modifiche di SL/TP contano. Nei test ho contato solo ordini piazzati o cancellati (max circa 91 al giorno per il Phantom, circa 58 per il Reaper, circa 30 per il Goldbot). **Misurare sul trial**: nel Journal di MT5 contare per giorno le righe "modify" per ogni EA e mandarmi il conteggio dopo 2-3 giorni.
- Le posizioni opposte tra conti: il testo ufficiale parla di "scopo manipolativo"; la risposta scritta di FTMO e piu severa ("rigoroso"). Vale la piu severa.
