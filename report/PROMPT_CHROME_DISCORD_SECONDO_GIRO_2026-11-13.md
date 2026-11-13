# Prompt per Claude in Chrome: SECONDO GIRO mirato su Discord ForexEASolutions (13/11/2026)

Uso: Chrome aperto su Discord (web), account di Claudio, server ForexEASolutions; estensione Claude attiva. Incolla il prompt nel pannello laterale. SOLA LETTURA. Il primo giro (zip DISCORD_NUOVI_2026-11-13) ha lasciato fuori propfirm-discussion e altri canali e ha letto solo in parte all-gold-eas. Questo giro copre solo quello che manca. Lo zip finale (< 10 MB) va in Download; Claudio lo manda a Claude in chat.

```
Sei in Chrome con Discord aperto sul server ForexEASolutions (Wim). Fai una lettura in SOLA LETTURA e alla fine crei un file ZIP. Questo e il SECONDO giro: il primo non ha letto alcuni canali e ha letto solo in parte all-gold-eas.

REGOLE FERME
- Non scrivere messaggi, non mettere reazioni, non cliccare link a pagamento o inviti, non cambiare impostazioni. Mai password o token: se Discord chiede un login, fermati e dillo.
- Non inventare nulla. Se un dato non c'e scrivi "NON TROVATO". I numeri sono quelli scritti da Wim e dagli utenti, non verificati.
- Allegati: NON scaricarli e NON aprirli. Elencali soltanto (nome file, dimensione, autore, canale, data e ora UTC, link al messaggio).
- Orari in UTC. Se Discord mostra la traduzione automatica in italiano, riporta il testo originale se puoi.
- AUTORE: per ogni messaggio verifica chi lo ha scritto. Nei messaggi "di continuazione" (senza nome in cima) risali al messaggio sopra che mostra il nome. Se non sei sicuro, scrivi "AUTORE INCERTO". Un messaggio di risposta (con la barra della citazione) ha come autore chi risponde, non chi e citato. "Digital_Wim" e un bot e NON e Wim.
- TESTO COMPLETO: se un messaggio e troncato ("mostra altro", "Read more", testo tagliato), aprilo e riporta tutto il testo. Se non ci riesci scrivi "TRONCATO" e il punto in cui si ferma.

PERIODO: dal 03/11/2026 00:00 UTC fino ad adesso. Leggi TUTTI i messaggi, anche se sono tanti: scorri all'indietro fino al 03/11, non saltare nulla.

PRIORITA 1 (leggi per primo, integralmente, ogni messaggio)
a) propfirm-discussion
b) backtesting-discussion
c) product-manuals
d) share-your-performance

PRIORITA 2 (all-gold-eas, 1.344 messaggi circa)
Leggi TUTTI i messaggi di Wim e dei moderatori e tutti i messaggi che contengono una di queste parole (anche il messaggio prima e quello dopo, per il contesto): FTMO, prop, challenge, swing, drawdown, DD, daily, stop out, stopout, margin, leverage, spread, slippage, news, NFP, Guardian, strategy 5, strategy 8, "strat 8", bug, bugged, TGR, Reaper, Phantom, Goldbot, GTP, "Gold Trade Pro", "max allowed", "max risk", "trade frequency", "manual strategy", license, licence, "license invalid", IPv6, update, version, set, Combo, 3GOLD, "opposite", "hedge", "same EA", "multiple accounts".

PRIORITA 3 (se hai tempo, solo i messaggi di Wim e le parole chiave sopra)
daytrade-pro, ultimate-breakout-system (anche il secondo canale con lo stesso nome, se esiste), automated-support, my-manual-ea-interventions, manual-trade-discussion, general-trade-talk, usefull-tools, newbies-corner, plug-and-play-eas, indicement-and-orb-master, luna-ai, bitcoin-eas, links-to-ea-product-page.
GIA LETTI NEL PRIMO GIRO (non rifarli): important-announcements, ea-update-notifications, karnek_questions, broker-discussion, vps_discussion.

COSA CERCO (con autore, data e ora UTC e FRASE ESATTA tra virgolette per Wim e i moderatori)
1. FTMO e altre prop: esperienze con challenge e conti funded; quanti conti con lo stesso EA; limite di capitale per strategia; posizioni opposte tra conti; limite di richieste al giorno; filtro news; Swing; stop out; spread e slippage dell'oro; conti sospesi, respinti o chiusi e il motivo; consigli di Wim sui set prop (Prop, Combo, 3GOLD) e sul Guardian.
2. Gold Reaper: il "Maybe TGR is bugged" del 05/11 e il backtest della strategia 8; la segnalazione del 13/11 di 5 posizioni aperte insieme con la strategia 8 (quale EA e? quale set? la risposta di Wim); strategia 4; giorni di perdita grande; novita sui set Combo/3GOLD.
3. Gold Phantom: risposta COMPLETA di Wim dell'11/11 sulla strategia 5 e sul Max Allowed Total Drawdown (testo intero); Trade Frequency e selezione manuale; due ordini strat 5 in parallelo.
4. Goldbot One, Gold Trade Pro, Daytrade Pro: cambiamenti, bug, risultati dichiarati con periodo, broker e rischio; mesi negativi; DD in un giorno.
5. Licenze: "license invalid", IPv6, EA ricaricati sulla dashboard il 07/11 (cosa e cambiato, serve riscaricare?), URL da consentire in MT5.
6. Messaggi di Wim troncati nel primo giro: 03/11 07:01 UTC (monetizzazione / prezzo EA 0,99 / community 948), 04/11 ("Wim could be a scammer..." chi lo scrive e in risposta a cosa), 09/11 ("last year he paused it..."), 10/11 15:40 UTC (GTP 1 loss, TGR 4 losses), 11/11 07:10 UTC (strategy 5).
7. Tutto cio che contraddice il manuale o messaggi precedenti di Wim.

OUTPUT: cartella DISCORD_GIRO2_<data di oggi>, zip DISCORD_GIRO2_<data di oggi>.zip in Download, meno di 10 MB. File Markdown UTF-8:
  00_INDICE.md: per ogni canale intervallo di date coperto, numero di messaggi letti, canali non letti e perche.
  01_wim_e_moderatori.md: tutti i loro messaggi in ordine di data, testo COMPLETO, con canale, data e ora UTC, a chi rispondono.
  02_prop_firm_FTMO.md: tutto su prop firm e FTMO, con autore, data e ora, canale e testo; per ogni voce "dichiarato da utente" o "dichiarato da Wim".
  03_EA_Reaper_Phantom_Goldbot_GTP_DTP.md: per EA, cosa e cambiato e problemi segnalati, con fonte.
  04_licenze_e_VPS.md: tutto su license invalid, IPv6, dashboard, URL.
  05_performance_e_numeri.md: numeri con periodo, broker, rischio; slippage; mesi negativi; DD in un giorno.
  06_allegati_elenco.md: tabella allegati; evidenzia quelli di Wim/moderatori e i .set, .zip, .pdf, .csv.
  07_per_canale/<canale>.md: un file per canale, ogni messaggio letto (autore, ora UTC, testo breve; completo per Wim e moderatori).
  99_DA_CONTROLLARE_A_MANO.md: cosa non hai letto o capito, "AUTORE INCERTO", "TRONCATO", traduzioni dubbie, contraddizioni.
Se non riesci a creare lo zip: scrivi ogni file nella risposta in blocchi che iniziano con "=== FILE: nome ===" e finiscono con "=== FINE ===". Dillo all'inizio.
In chat, in fondo: al massimo 15 righe con le cose piu importanti per chi usa Reaper, Phantom, Goldbot, Gold Trade Pro e Daytrade Pro su FTMO.
Scrivi in italiano, frasi esatte nella lingua originale. Nessun consiglio di acquisto, lotto o taglia.
```

## Dopo
Claudio manda lo zip a Claude; io lo confronto con i test (P1, P4, Reaper, Phantom) e scrivo cosa cambia.
