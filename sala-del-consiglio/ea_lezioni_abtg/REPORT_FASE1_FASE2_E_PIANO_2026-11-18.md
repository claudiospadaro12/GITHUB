# Sala del Consiglio quantitativa - lezioni ABTG (18/11/2026): report, dibattito e piano pre-registrato

**Materiali letti:** PDF "La Magia delle Aperture Europee e Americane" (07/05/2025, 41 pagine), "Piano di Trading Apertura Europea" (Emiliano Monza), "Piano di Trading Apertura Americana", "Strategia Nasdaq", prompt master Sala V2. **Modalita:** consiglio SIMULATO (4 prospettive in un unico processo, non agenti indipendenti): stato massimo ottenibile = VALIDAZIONE_NECESSARIA (prompt V2 sez. 12). Nessun test eseguito in questa sessione sulle regole delle lezioni.

## FASE 1 - Report esecutivo (fatti gia misurati nel progetto)
- **I 14 EA "Ottimizzati"** (PF 1,20-3,17) sono ottimizzati e valutati sullo STESSO periodo (2024-01 -> 2026-06, oro e indici in rialzo). **Fuori campione: i 4 su oro crollano** (2015-2023: PF 0,80-1,10; il controllo 2024-26 riproduce la classifica entro il 12%, quindi il crollo e reale). 10 su 14 sono lo stesso motore (rimbalzo Supertrend): non sono scommesse indipendenti.
- **Il bersaglio "PF > 1,8 con DD < 4%" si raggiunge solo dentro il periodo di ottimizzazione:** Multi 2,85 / DD 4,0%, SupRev 2,45 / 2,2%. Fuori campione nessun EA nostro lo raggiunge. Un PF alto con DD basso e un RISULTATO da misurare su dati nuovi, non un obiettivo da "iniettare".
- **Costi:** su oro 0,1 lotti circa 0,66 USD/oncia a operazione; regole a molti trade piccoli perdono (prova a orari fissi: PF 0,60-0,77).
- **Altre debolezze strutturali:** orologio server (BCM GMT+1 fisso, FTMO IT+1: le candele H1/H4 cambiano), Modello 1 contro tick reali per gli scalper, nessun forward ancora per gli Ottimizzati.
- **Gia in repository, per le stesse famiglie delle lezioni:** `MaxMinNotte` (box notturno DAX), `DAX_Apertura_EU`, `Nasdaq_Apertura_US` (PF 0,91, "morto"), `ORB` (PF 1,15 marginale), `GapFill`, `GapContinuation`. Censimento del 19/09: solo `DAX_Apertura_EU` x D30EUR passa i cancelli tra le aperture.

## Regole delle lezioni: OGGETTIVE (testabili) contro DISCREZIONALI
**Oggettive (candidati a regole):**
- **O1 (Nasdaq, H1):** all'apertura americana (15:30 IT) ordini SELL STOP sotto i minimi e BUY STOP sopra i massimi della candela H1 precedente.
- **O2:** a esecuzione avvenuta si cancella l'ordine opposto; stop sul livello opposto del breakout.
- **O3:** a primo obiettivo (numero tondo o livello %) si chiude meta posizione e lo stop va in pari; poi trailing sulla base della candela precedente (M1) o ATR.
- **O4 (PDF 2025, breakout notturno):** range notturno come box; ingresso sulla rottura con conferma (volume/chiusura); stop vicino alla rottura (ATR o 5-10 punti oltre la linea); take profit su supporti/resistenze, Fibonacci o EMA; stop in pari appena possibile; parziale al primo target.
- **O5 (breakout classico):** candela di rottura ampia e decisa, senza ombre ambigue; ingresso DOPO la chiusura della candela; stop oltre il breakout con buffer; filtri ATR/VWAP; un gap nella stessa direzione rafforza il segnale.
- **O6:** rischio massimo 2% a operazione; niente operazioni prima/durante notizie a 3 tori (richiede calendario storico, non presente nel tester).
**Discrezionali (non testabili cosi come sono):** lettura multi-timeframe e "struttura di mercato", livelli di Larry Williams D1/W1/M, correlazione con Nikkei e SPX, multipivot, tre Supertrend 3,0/3,5/2,5 che "cambiano tutti", medie 14/89/100/200, Bande di Bollinger M15 come obiettivo, "take profit in divenire", volumi/market profile, psicologia dei numeri tondi.

## FASE 2 - Dibattito (sintesi; consiglio SIMULATO)
**Stratega:** "Le lezioni danno tre nuclei: stop order sui massimi/minimi H1 all'apertura USA (Nasdaq), breakout del box notturno sul DAX, breakout classico con candela di conferma. Voglio R minimo 1:1,5 con parziale a 1R e stop in pari."
**Validatore:** "Tutte e tre le famiglie le abbiamo gia come EA. Nasdaq_Apertura_US e morto (PF 0,91) e l'ORB e marginale. Prima di scrivere codice nuovo, la domanda e cosa aggiungono le lezioni a quegli EA. Il PF 1,8 con DD 4% non e un criterio di progetto: e un esito da misurare fuori campione. I criteri vanno scritti prima: finestra IS, OOS 2 blocchi, costi per strumento, soglia del t corretta per i set provati. Scartiamo i discrezionali finche non hanno una definizione numerica."
**Architetto MQL5:** "Un solo EA con tre moduli accendibili (M1 stop-H1 apertura, M2 box notturno, M3 breakout con conferma), gestione comune: BE, parziale, trailing ATR, rischio %, tetti giornaliero e totale. Ore in input per periodo estate/inverno, regola fissa del CLAUDE.md. Lo scrivo DOPO che un modulo supera i criteri in Python, altrimenti codifico logiche destinate a cadere."
**DevOps:** "Pipeline che abbiamo gia: simulatore Python come filtro (validato su 36 set MT5 per il motore dei breakout), poi MT5 headless con riga pinnata e hash, poi tick. Servono i dati M1 degli indici: DAX 2019-2026 e Nasdaq 2010-2026 sono sul PC di Claudio (HistData); equivalenza con i dati BCM da verificare (cancello D)."
**Decisioni (sintesi):** D1 tre moduli, nessun discrezionale; D2 prima Python, poi MQL5 per i soli sopravvissuti; D3 PF 1,8/DD 4% = esito atteso da misurare, non parametro; D4 correlazione con gli altri EA misurata prima di ottimizzare.

## Piano di test PRE-REGISTRATO (scritto prima dei numeri)
- **Moduli:** M1 stop su massimo/minimo H1 precedente all'apertura USA (NASUSD, US30; apertura 15:30 IT = ora server per periodo); M2 box notturno DAX (23:00-07:00 server, ingresso sulla rottura, stop ATR); M3 breakout dell'apertura con candela di conferma (DAX 09:00, NAS 15:30). Gestione: stop sul livello opposto, parziale 50% a 1R + stop in pari, trailing ATR; **griglia L9 su pochi fattori** (non ottimizzazione ampia).
- **Finestre:** IS 2019-2022 (DAX) e 2015-2020 (Nasdaq); OOS 2023-2024 e 2025-2026 (ultimo solo se i precedenti passano). Costi per strumento letti da report MT5 reali.
- **Porte:** PF netto >= 1,30, >= 100 operazioni, recovery >= 1,5, t >= 3,3 (come G1) in IS; vicini >= 70% in profitto; OOS PF netto >= 1,20 in entrambi i blocchi con >= 20 operazioni; **DD massimo reale <= 4% per i set "prop"**, misurato, non imposto. Cancello D sui dati esterni (operazioni +-15%, PF +-20%).
- **Previsioni:** almeno un modulo supera IS: **20%**; supera anche OOS: **8%**; raggiunge PF >= 1,8 con DD <= 4% fuori campione: **3%**.
- **Stop:** nessun modulo supera IS -> "nessun candidato" per le lezioni ABTG di apertura; nessun EA da ottimizzare.
## Consegne
`EA_Council_Master.mq5`, `Set_PropFirm_Strict.set`, `Set_Real_Aggressive.set` e la nota sulla logica: **si scrivono per i moduli che superano IS in Python** (altrimenti sarebbero logiche non provate presentate come EA). Se Claudio preferisce lo scheletro subito, si scrive come "NON VALIDATO, SOLO PER BACKTEST", senza dichiarare alcun PF.
