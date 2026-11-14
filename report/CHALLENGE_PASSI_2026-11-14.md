# Le due challenge FTMO (P1 e P4): lista dei passi, in ordine (14/11/2026)

**Natura**: lista operativa ricavata dai nostri file (`P1_/P4_ELENCO_SET_E_CONTROLLI`, `FTMO_TERMINI_LETTI_2026-11-14.md`, `FTMO_REGOLE_LETTE_ANALISI_2026-11-07.md`, `CHECKLIST_PRIMA_DELLA_CHALLENGE_2026-11-14.md`, manuale Reaper V5.1). Non e un consiglio di acquisto, lotto o taglia; nessuna garanzia di risultato. Decisione di Claudio (14/11): **due challenge 2-Step Swing da 80.000 EUR, P1 e P4**. Cosa e verificato e cosa no e scritto accanto a ogni passo. Nessun conto reale, trial o VPS e stato toccato da me.

## A. Pulizia e preparazione del VPS (prima di comprare)
1. Esportare lo storico (Report cronistorico dei trade, HTML o CSV) e i log del Guardian di: trial FTMO, due demo da 100k (quelle GBPJPY e AUDNZD); metterli in una cartella sul PC e mandarmeli se vuoi l'analisi. Poi eliminare i tre conti: prima verificare nessuna posizione aperta e nessun ordine pendente.
2. La prova FTMO scade il **16/11** (nota nostra): non conta di caricarci P1/P4.
3. Misurare il VPS (Task Manager, Prestazioni, alle 09:00 e alle 15:30; Monitoraggio risorse > Memoria > errori reversibili/s) prima di decidere l'upgrade Contabo. Dopo la pulizia i terminali sono: 2 FTMO, reale, demo con tutti gli EA, manuale: meno di oggi.
4. Se si fa l'upgrade Contabo (Live Migration, MAI "New Deployment"): solo con i 5 controlli del promemoria (oro chiuso, posizioni piatte, copia di sicurezza di `C:\FTMO`, `C:\BCM_Reale`, `C:\MT5_MANUALE`, `C:\MT5_Wim`, `C:\ABTG`, risposta del supporto su fermo/IP/importo/contratto, risposta FTMO). Supporto Wim solo lun-ven 9-17 CET: non farlo il venerdi sera se serve aiuto.

## B. Licenze e rete (sul VPS, per ogni nuovo terminale)
5. MT5 > Strumenti > Opzioni > Expert Advisors: "Consenti WebRequest" per `https://forexeasolutions.org/`, `https://forexeasolutions.services/`, `https://www.tradewithwim.com/` (a seconda di dove e comprato), `https://www.worldtimeserver.com/`, `https://nfs.faireconomy.media/` [manuale Reaper V5.1].
6. Se compare "license invalid" solo sul VPS: disattivare IPv6 [Wim, 07/11].
7. Aprire una volta il Calendario in Toolbox e lasciarlo sincronizzare (filtro NFP, `UseMQL5Calendar`).
8. Versioni: Reaper 5.6, Goldbot One V3.5, Gold Trade Pro V7.2, Phantom V2.5, Daytrade Pro V4.5 sul VPS contro la dashboard di Wim (ha ricaricato gli EA il 07/11 senza cambiare il numero di versione). NON VERIFICATO quali stanno sul VPS.
9. Contare le licenze: 10 per EA; non e dichiarato come Wim le conta (per conto? per terminale?). Elencare i conti su cui ogni EA e attivato.

## C. Prima di comprare (pagina d'ordine FTMO)
10. Tipo: **2-Step Swing**, 80.000 EUR, MT5. Leva oro/indici 1:15, forex 1:30. Valuta EUR ammessa. Quota circa 600 EUR a challenge (dato di Claudio), restituita al primo prelievo (2-Step).
11. Tetto **400.000 USD** sul capitale iniziale totale di tutti i conti tuoi e collegati (Termini 5.8.5(c), 6.3): 2 x 80.000 EUR sono circa 176.000-188.000 USD. Controllare il cambio sulla pagina d'ordine.
12. Obiettivi 2-Step (pagina ufficiale ftmo.com trading objectives, modificata il 02/11/2026): Challenge +10%, Verification +5%; perdita giornaliera 5% (ricalcolata alle 00:00 CE(S)T); perdita totale 10% (statica); minimo 4 giorni di trading.
13. Clausole da tenere a mente (Termini FTMO 1/11/2026): 7.5 gestione del rischio (lotti, numero di posizioni, esposizione cumulata su un simbolo o simboli correlati: tutto e oro), 7.6 (FTMO puo ridurre la leva o limitare il rischio per idea o il volume per simbolo), 7.8 (una violazione su un conto puo far chiudere tutti i collegati), 7.2.1 (nessun trade in coordinamento con terzi: Massimo ha conti propri).
14. Non risolto: livello di stop out, come FTMO misura le posizioni opposte tra conti (nei test 2.451 ore di oro opposto in 3 anni tra P1 e P4), limite di richieste (testo ufficiale: 2.000 richieste al server al giorno, "server requests" probabilmente comprende le modifiche di SL/TP).

## D. Nuovo terminale per ogni challenge (uno per conto, uno alla volta)
15. Installare un MT5 separato per challenge (cartelle diverse, per esempio `C:\FTMO_P1` e `C:\FTMO_P4`), accedere con le credenziali dell'area utente FTMO (non condividerle), server FTMO indicato.
16. Market Watch: XAUUSD con il nome esatto del conto FTMO (e le 13 coppie del Daytrade Pro: EURUSD, GBPUSD, USDJPY, AUDUSD, XAUUSD, GBPJPY, USDCAD, EURJPY, EURNZD, EURAUD, NZDUSD, AUDJPY, CHFJPY).
17. Ora del server FTMO = ora italiana + 1 (verificare sul Market Watch il giorno della partenza). Non toccare gli offset GMT degli EA (AutoGMT: inverno 2, estate 3).
18. Foto delle Specifiche di XAUUSD in 3-4 momenti (notte, mattina europea, apertura USA, rollover): spread, contratto, swap, margine. Mandarmele per ricalcolare i costi.

## E. Caricare i set (un EA alla volta, controllando gli input dopo ognuno)
19. **P1**: Phantom (XAUUSD H1, `GoldPhantom_Propfirm.set`, magic 75000: `TradeFrequency=5` Auto, `Risk=1234`, `MaxAllowedDD=9`, `PropFirmMaxDailyDD=4`, `Randomization=50`, `OnlyUp=false`); Goldbot (XAUUSD D1, `Goldbot_PropFirm_5_2.5.set`, magic 2000: `Risk=3`, `MaxRiskPerStrategy=1.0`, `PropFirmMaxDailyDD=2.0`, 8 strategie accese, NFP 180/50); Daytrade Pro (un solo grafico, `RunOneChartSetup=1`, `Daytrade_Pro_Max9%DD_lowrisk.set`, magic 5656: `Risk=99999`, `MaxRiskMaxDD=2.7`, 13 coppie incluso oro).
20. **P4**: Reaper (XAUUSD H1, `Gold_reaper_propfirm_combo_3GOLD.set`, magic 8000: `TradeFrequency=2` (NON Auto), `Risk=1234`, `MaxAllowedDD=3`, `PropFirmMaxDailyDD=4`, `Randomization=50`, `OnlyUp=false`); Goldbot e Daytrade Pro identici a P1.
21. Un EA per grafico, un set per EA, nessuna posizione di altri EA sul conto. Filtro NFP acceso. Nessun cambiamento di rischio dopo la partenza. Il Reaper Combo e un livello fisso (non alzarlo).
22. Dopo ogni caricamento: lista degli input nel pannello contro la lista dei file P1/P4, "licenza trovata" nel pannello dell'EA, nessun errore nel Journal.

## F. Guardian (su ogni challenge)
23. Su un grafico XAUUSD: `InpStartBalance=80000` (NON 100000), soglie 4,5% giornaliero e 9,5% totale come scelto da Claudio (le simulazioni dei nostri referti usano 4,3%), `InpDailyResetHour=1` (mezzanotte italiana = 01:00 server FTMO), `InpDailyBaseline=1` (saldo). Il Guardian NON e simulato nel tester. Nota del set: `InpDailyPausePct` e `InpMaxOpenRiskPct` scrivono solo variabili globali che gli EA di Wim NON leggono: la protezione e la chiusura, non la pausa.
24. Controllare che la riga `[GUARDIAN]` compaia (equity, dayLoss, totDD, rischioAperto, stato OK).

## G. Partenza
25. Partire con P1 e P4 **in giorni diversi** (consiglio mio: nei test l'esito dipende dal giorno di partenza; sfalsare le partenze riduce la correlazione). Non operare a mano sui conti challenge.
26. Primi giorni: ogni giorno controllare la riga Guardian, ordini pendenti, posizioni aperte, errori di licenza; contare nel Journal le righe "modify" per EA (limite ufficiale 2.000 richieste al giorno: NON MISURATO). Dopo 2-3 giorni e dopo 2-3 settimane: mandarmi il Report cronistorico dei trade di ogni challenge.
27. Minimo 4 giorni di trading prima di poter passare la fase.

## H. Quando una fase arriva al +10% (Challenge) o al +5% (Verification)
28. **Fermare gli EA e chiudere tutte le posizioni e gli ordini pendenti** prima di chiedere la valutazione: i Termini (5.8.6) dicono che FTMO non ha obbligo di valutare la fase se non sono chiusi tutti i trade simulati e gli ordini pendenti. Il Guardian ha la funzione di chiusura completa; per i pendenti dei set Wim (Phantom, Reaper, Goldbot) controllare a mano nella scheda Operazioni/Ordini.
29. Dopo la Verification: conto finanziato; prelievi dal giorno 14 con posizioni e pendenti chiusi (80%); le regole del conto finanziato sono in "FTMO Account Terms" (NON lette).

## I. Cosa NON sappiamo (da non dimenticare)
- Stop out di FTMO Swing, spread e slippage dell'oro, come conta i "server requests", se i set Phantom e Reaper hanno gli stessi risultati live del tester (Phantom live: PF 1,07 nel segnale di Wim contro 2,9 nel tester 2025; nostro trial 0,26 su 25 operazioni).
- Il test del Phantom a tick reali sul 2026 non e ancora fatto.
