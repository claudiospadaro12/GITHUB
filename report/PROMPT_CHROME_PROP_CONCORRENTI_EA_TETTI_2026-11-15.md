# Prompt per Claude in Chrome: FundedNext e The5ers, EA di terzi e tetti di capitale (15/11/2026)

Segue `THE5ERS_ANALISI_2026-11-07.md` (The5ers letta il 07/11: EA di terzi senza sorgente NON ammessi, da ricontrollare per cambiamenti), `PROMPT_ESTENSIONE_CHROME_PROP_EA_TERZI_2026-11-07.md` (FundedNext risultava incerto: "EA vietati sopra 50.000 $" oppure "ammessi con tetto 300.000 $ per strategia", da fonti secondarie) e `SEGNALAZIONE_BAN_PROP_FIRM_2026-11-14.md` (un utente anonimo dice di essere stato bannato da entrambe per "copytrading" con gli EA di Wim: NON verificato). Questo prompt chiede SOLO i punti che servono alla decisione: EA di terzi, stessa strategia di altri utenti, tetti di capitale, quando e con quali conseguenze.

```
OBIETTIVO: leggere SOLO le pagine pubbliche e ufficiali di FundedNext e di The5ers e rispondere, con la frase esatta e l'indirizzo (URL) di ogni risposta, a queste domande. Nessuna interpretazione, nessun riassunto al posto della frase.

SITI (usa solo questi e le loro pagine di regole/aiuto; ignora blog, affiliati, recensioni e video)
- FundedNext: sito ufficiale e help center (Terms and Conditions, Trading Rules, Prohibited Trading Practices / Restricted Strategies, FAQ su Expert Advisor, copy trading, account multipli, tetto di capitale / Maximum Allocation / account limits, scaling, payout, refund).
- The5ers: sito ufficiale e help center (Terms, Rules, FAQ Expert Advisors, copy trading, account multipli, capitale massimo / account limits, scaling, payout, refund).
- Se avanza tempo: E8 Markets (stesse domande), dopo aver finito le due principali.

REGOLE DI SICUREZZA (obbligatorie)
- Nessun login, nessun acquisto, nessun click su Buy / Start / Checkout / Get Funded / link di affiliazione o broker, nessun form, nessun download di file eseguibili. Se compare una richiesta di login, pagamento o dati personali, FERMATI su quella pagina e scrivilo.
- Non inventare nulla. Valore non leggibile = "non leggibile". Cosa assente = "NON TROVATO". Se due pagine si contraddicono, riporta ENTRAMBE le frasi con i due URL e la data di aggiornamento se mostrata.
- Lingua: copia le frasi cosi come sono (inglese); le note tue in italiano.

DOMANDE (per ciascuna prop; per ogni risposta: FRASE ESATTA tra virgolette, URL, data di aggiornamento della pagina se mostrata, e un'etichetta CHIARO / AMBIGUO / NON TROVATO)
A. EA DI TERZI
 1. Un Expert Advisor ACQUISTATO da un fornitore (file compilato .ex5, senza sorgente, venduto sul MQL5 Market o dal venditore) e ammesso? Serve il sorgente? Serve l'approvazione scritta preventiva? Ci sono EA nominati come vietati (elenco) o categorie di EA vietate?
 2. Differenze fra programmi (challenge a 1 o 2 fasi, conto finanziato, soglie di capitale): le regole sugli EA cambiano sopra una certa taglia (per esempio "sopra 50.000 $")?
 3. Stop loss obbligatorio e visibile? Stop virtuali/nascosti vietati? Durata minima dei trade? Martingala, grid, hedging, HFT, latency arbitrage, tick scalping: ciascuno vietato o no.
B. STESSA STRATEGIA DI ALTRI UTENTI / COPY TRADING
 4. Cosa significa esattamente "copy trading", "copytrading", "identical trades", "same strategy", "duplicate strategies" o "strategy replication"? Riporta ogni frase che li definisce.
 5. Se piu clienti usano lo stesso EA commerciale (anche con set o rischio diversi, anche con la Randomization), e considerato copy trading o "stessa strategia"? Con quale frase?
 6. Quali sono le conseguenze scritte (ammonimento, sospensione, chiusura del conto, confisca dei profitti, ban, nessun rimborso)? Si applicano anche DOPO aver superato la challenge o dopo un payout? C'e un esempio o una procedura di contestazione/appello?
C. TETTI DI CAPITALE
 7. Capitale massimo per trader (somma di tutti i conti), per strategia, per nucleo familiare/indirizzo/dispositivo/IP, e per "parti collegate". Valuta usata (USD/EUR) e come si converte.
 8. Il tetto vale per i conti attivi, per quelli in valutazione, o anche per quelli finanziati? Include i conti di altri trader con la stessa strategia ("evaluated alongside")?
 9. In quale fase viene controllato (acquisto, durante la challenge, verifica, emissione del conto finanziato, payout)? Cosa succede se si supera (conto negato, sospeso, chiuso, rimborso o no)? Preavviso?
 10. Numero massimo di conti per persona e per programma; regole su familiari che operano separatamente (stesso indirizzo, stessi EA).
D. VARIE UTILI ALLA SCELTA
 11. Perdita giornaliera e massima: base (balance o equity, flottante incluso), ora di reset e fuso, trailing o fissa.
 12. Oro (XAUUSD) e metalli: restrizioni di leva, lotto o EA? Posizioni e ordini pendenti nel weekend? Stop sulle notizie (minuti, quali conti)?
 13. Richieste al server / numero di ordini al giorno ("hyperactive", "excessive requests"): c'e un numero?
 14. Rimborso della quota, reset, riacquisto, scadenze, inattivita.

FORMATO DELL'OUTPUT
1. Per ogni prop una tabella: punto | risposta | frase esatta | URL | CHIARO/AMBIGUO/NON TROVATO.
2. Elenco di tutte le pagine lette (URL + data di aggiornamento se mostrata).
3. Sezione finale per ciascuna prop, con una riga ciascuna, solo con frasi esatte e URL:
   - "EA DI TERZI COMPILATI SENZA SORGENTE: AMMESSI?"
   - "STESSO EA USATO DA PIU CLIENTI: PERMESSO / VIETATO / NON CHIARO?"
   - "TETTO DI CAPITALE: valore, a chi si applica, quando si controlla".
4. Elenco di domande da fare all'assistenza per iscritto (non domande a cui hai gia la risposta).
5. Salva testo e screenshot: crea lo zip PROP_CONCORRENTI_<AAAA-MM-GG>.zip con 00_info.txt (data e ora italiana, pagine lette), 01_indice.md, un file di testo grezzo per ogni pagina letta (<prop>_<NN>_<nome pagina>.txt) e, per ogni risposta chiave, uno screenshot della frase (<prop>_<NN>.jpg). Dimensione massima 10 MB (JPEG qualita 85; se serve _parte1.zip, _parte2.zip).
6. Alla fine dimmi: quante pagine hai letto per prop, quali NON hai potuto aprire e perche, posizione e dimensione dello zip.

NON dare giudizi su quale prop scegliere e non consigliare acquisti: riporta solo cio che c'e scritto.
```

## Dopo la lettura
Mandami lo zip (o l'output). Lo confronto con FTMO (`FTMO_RISPOSTA_ORIGINALE_2026-11-10_INGLESE.md` e la risposta in attesa) e con le regole sugli EA di terzi gia archiviate. Una prop e candidata solo se la frase esatta ammette EA acquistati senza sorgente **e** non vieta lo stesso EA usato da piu clienti, oppure se l'assistenza lo conferma per iscritto.
