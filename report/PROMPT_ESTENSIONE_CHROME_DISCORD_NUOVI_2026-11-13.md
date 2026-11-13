# Prompt per Claude in Chrome: tutti i messaggi NON ANALIZZATI del server ForexEASolutions, con zip finale (13/11/2026)

Uso: Chrome aperto su Discord (web), collegato con l'account di Claudio, server ForexEASolutions; estensione Claude attiva. Incolla il prompt nel pannello laterale. SOLA LETTURA. Ultima analisi dei miei archivi: fino al 03/11/2026 (canale ultimate-breakout-system) e al 05/11/2026 (altri canali); per sicurezza si riparte dal 03/11/2026 00:00 UTC su tutti i canali. Lo zip finale (< 10 MB) viene salvato in Download e mandato a Claude in chat da Claudio.

```
Sei in Chrome con Discord aperto e collegato sul server ForexEASolutions (Wim). Fai una lettura in SOLA LETTURA di TUTTI i messaggi dal 03/11/2026 00:00 UTC fino ad adesso, in tutti i canali elencati sotto, e alla fine crei un file ZIP.

REGOLE FERME
- Non scrivere messaggi, non mettere reazioni, non cliccare inviti o link a pagamento, non cambiare impostazioni. Non inserire mai password o token: se Discord chiede un login, fermati e dillo.
- Non inventare nulla. Se un dato non c'e scrivi "NON TROVATO". I numeri sono quelli scritti da Wim o dagli utenti, non verificati.
- Allegati: NON scaricarli e NON aprirli (l'estensione rifiuta i file di altri utenti). Elencali soltanto: nome file, dimensione, autore, canale, data e ora, link al messaggio.
- Orari in UTC. Discord puo mostrare messaggi tradotti in italiano in automatico: se puoi, riporta il testo originale.
- Se un canale ha piu di 300 messaggi nuovi, leggi tutto lo stesso, scorrendo all'indietro fino al 03/11; non saltare messaggi.

CANALI DA LEGGERE (se un nome non esiste piu, dillo): important-announcements, ea-update-notifications, ultimate-breakout-system, all-gold-eas, share-your-performance, daytrade-pro, bitcoin-eas, luna-ai, indicement-and-orb-master, plug-and-play-eas, product-manuals, backtesting-discussion, propfirm-discussion, broker-discussion, vps_discussion, usefull-tools, general-trade-talk, newbies-corner, automated-support, karnek_questions, my-manual-ea-interventions, manual-trade-discussion e ogni altro canale con messaggi nuovi. Salta solo meme e chat senza legame con trading.

COSA CERCO (mettilo in evidenza, con autore, data e ora, e la FRASE ESATTA tra virgolette per i messaggi di Wim e dei moderatori)
1. Annunci e messaggi di WIM (e dei moderatori): nuove versioni degli EA, nuovi set, bug, correzioni, regole d'uso, avvisi su prop firm, risposte alle domande sul rischio. "Digital_Wim" e un bot e NON conta come Wim.
2. EA e set che usiamo: The Gold Reaper, The Gold Phantom, Goldbot One, Gold Trade Pro (settaggi Prop, Combo, 3GOLD), Daytrade Pro, Ultimate Breakout System (UBS). Per ognuno: cosa e cambiato, problemi segnalati, risultati dichiarati con periodo e broker.
3. Prop firm (FTMO soprattutto): esperienze con le sfide, regole su stesso EA su piu conti (tetto di capitale per strategia), posizioni opposte fra conti, limite di richieste al giorno, filtro news, Swing, stop out, spread e slippage dell'oro su FTMO, conti sospesi o respinti.
4. Performance: numeri con periodo, broker e rischio; mesi negativi; slippage live contro backtest; DD in un giorno.
5. Novita su UBS: nuovi set, UBS Optimizer, metodo di ottimizzazione, DD dichiarato (HistoricalMaxDD), correzioni al manuale.
6. Tutto cio che sembra in contrasto con quello che e scritto nel manuale o con messaggi precedenti di Wim.

OUTPUT: FILE E ZIP (cartella DISCORD_NUOVI_<data di oggi>, zip DISCORD_NUOVI_<data di oggi>.zip in Download, meno di 10 MB)
Crea questi file di testo (Markdown, UTF-8):
  00_INDICE.md: canali letti, intervallo di date davvero coperto per ogni canale, numero di messaggi letti, canali non letti e perche.
  01_annunci_wim.md: tutti i messaggi di Wim e dei moderatori, in ordine di data, con la frase esatta.
  02_EA_e_set_aggiornamenti.md: per EA (Reaper, Phantom, Goldbot, Gold Trade Pro, Daytrade Pro, UBS) cosa e cambiato e problemi segnalati.
  03_prop_firm_e_FTMO.md: tutto quello che riguarda prop firm e FTMO.
  04_performance_e_problemi.md: numeri di performance, slippage, mesi negativi, bug.
  05_allegati_elenco.md: tabella degli allegati (nome, dimensione, autore, canale, data e ora, link); evidenzia quelli di Wim o dei moderatori e quelli .set, .zip, .pdf, .csv.
  06_per_canale/<nome_canale>.md: un file per canale, messaggi in ordine di data (autore, data e ora UTC, testo breve; testo completo per Wim e moderatori).
  99_DA_CONTROLLARE_A_MANO.md: cosa non hai potuto leggere o capire, messaggi tradotti male, link rotti, contraddizioni.
Comprimi la cartella in DISCORD_NUOVI_<data>.zip (Download). Se non puoi creare file o uno zip: scrivi ogni file nella risposta, uno dopo l'altro, in blocchi che iniziano con la riga "=== FILE: nome_del_file ===" e finiscono con "=== FINE ===", cosi li assemblo io. Dillo all'inizio.
In chat, in fondo: al massimo 15 righe con cio che c'e di piu importante per chi usa Reaper, Phantom, Goldbot, Gold Trade Pro e Daytrade Pro su prop FTMO, e per chi usa UBS.
Scrivi tutto in italiano, tranne le frasi esatte che restano nella lingua originale. Non dare consigli di acquisto, di lotto o di taglia.
```

## Dopo
Claudio manda lo zip a Claude in chat; io lo leggo, lo confronto con i referti dei test e dei messaggi precedenti (UBS_DISCORD_2026-11-03/*, UBS_DISCORD_RIPASSO_2026-11-10.md) e scrivo cosa cambia per P1, P4 e per l'UBS.
