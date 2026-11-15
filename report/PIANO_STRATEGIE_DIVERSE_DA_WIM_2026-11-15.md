# Piano: trovare strategie DIVERSE dagli EA di Wim (15/11/2026, sera; criteri scritti PRIMA dei numeri)

**Natura: PIANO.** Nessuna passata lanciata. Solo demo e tester; reale 10105439, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti.

## 0. Decisione di Claudio (15/11/2026, sera)
"Il nostro obiettivo primario e trovare strategie diverse dagli EA di Wim, pertanto qualsiasi cosa va bene, impegniamoci al massimo. Proviamo tutto." **Questo rende l'ottimizzazione dei set di Wim (pilota oro) UNO dei filoni, non l'obiettivo.**

## 1. Cosa vuol dire "diverso" (tre livelli, dal piu debole al piu forte)
1. **Parametri diversi, stesso EA** (set UBS nostri): diverso nei file, uguale nella logica. FTMO potrebbe considerarlo la stessa strategia (domanda del 14/11 ancora senza risposta). **Livello piu debole.**
2. **Logica diversa, stesso mercato** (es. oro con rimbalzo al livello al posto di breakout): comportamento diverso, correlazione bassa col portafoglio di Wim (P1/P3/P4).
3. **Logica e mercato diversi** (es. aperture DAX/Nasdaq dei nostri ABTG): il piu lontano da Wim.
- **Misura oggettiva:** correlazione giornaliera del profitto realizzato (e, dove si puo, del flottante) con i portafogli oro di Wim: **<= 0,30** = diverso; 0,30-0,60 = parente; > 0,60 = stessa cosa.
- **Giudizio di FTMO:** NON lo conosciamo. Lo scriviamo come incertezza, non lo assumiamo.

## 2. I filoni (ognuno con regola di arresto scritta prima)
| # | Filone | Livello | Stato | Cosa serve |
|---|---|---|---|---|
| F1 | **Inventario dei nostri EA ABTG** (47 file in `mql5/Experts`: aperture DAX/Nasdaq, ORB, Nightly, MaxMinNotte, SupRev/SuperWave, EMA200, GoldenCross, HARSI, PTE, WOL, FiboH4, PostNews, ...) e dei loro risultati gia nel repo | 2-3 | **parte subito, solo repo** | niente da te |
| F2 | **EA nostro oro "rimbalzo al livello"** (ordini limit) | 2 | criteri gia scritti (`EA_ORO_RIMBALZO_LIVELLO_CRITERI_2026-11-15.md`, regole MIE proposte, mancano le tue correzioni) | tua risposta: "ok alle regole proposte" oppure correzioni |
| F3 | **Ottimizzazione UBS sull'oro** (pilota con criteri in `UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI_2026-11-15.md`) | 1 | in attesa dell'output della riga di sola lettura | incollare l'output (Ctrl+V) |
| F4 | **Nuove famiglie di logica sull'oro e sugli indici** scritte da noi (es. fade del range asiatico, mean reversion Bollinger/RSI, trend EMA con filtro, momentum a sessione) | 2-3 | da definire dopo F1 (per non rifare cio che esiste) | scelta delle famiglie |
| F5 | **EA di altri venditori** (non Wim), con sorgente o con regole che le prop ammettono | 2-3 | ricerca (prompt per Chrome), dopo la risposta di FTMO sul "stessa strategia" | risposta FTMO |
| F6 | **Ricerca "hybrid allocation"** e altre prop (FundedNext, The5ers, E8) per i tetti | - | prompt gia pronto, in attesa dello zip | lo zip |
| F7 | **Scalper Claudio 1.03** (misura del vantaggio a tick reali, oro) | 3 | file compilato OK (0 errori), corsa interrotta da Claudio, nessun dato | decidere se rilanciarlo |

## 3. Regole contro i falsi successi (valgono per OGNI filone: "provare tutto" moltiplica il rischio di trovare per caso)
1. **Criteri e previsioni scritti prima di ogni test** (come sempre).
2. **Registro dei tentativi:** si conta quante varianti/combinazioni si guardano per filone; il numero va nel referto. Piu si prova, piu alta la soglia (statistica t >= 3,5 invece di 2 quando le caselle guardate sono molte).
3. **Hold-out intoccabile:** 2025-01-01 -> 2026-01-01 a tick reali, mai usato per scegliere o ritoccare; si apre UNA volta per i finalisti. Se si ritocca dopo averlo visto, non e piu hold-out e lo si dichiara.
4. **Confronto sempre con una base:** un candidato conta se batte il controllo (set di Wim a lotto uguale, oppure "nessuna strategia") dopo i costi, non se e solo positivo.
5. **Stabilita:** vale solo cio che regge in due meta del periodo e in zone di parametri vicine (non punti isolati).
6. **Costi reali:** commissioni e slippage FTMO misurati (5,1 EUR/lotto, circa 0,4 USD/oncia in entrata) e, dove esistono, tick reali; a Modello 1 gli scalper e le strategie a stop piccoli si sovrastimano (scalper: PF dimezzato a tick).
7. **Orologio:** server BCM GMT+1 fisso; ogni logica a orario si controlla estate/inverno (regola CLAUDE.md).
8. **Soglie minime per entrare in un portafoglio FTMO:** PF >= 1,20 dopo i costi nel fuori campione, DD giornaliero sotto il 5% del deposito, almeno 100 operazioni, correlazione <= 0,60 con le altre componenti.
9. **Si scrive "nessun candidato" quando e cosi**, senza ritoccare le soglie per ottenerne uno.

## 4. Ordine di lavoro proposto
1. **F1 subito** (solo repo): inventario, risultati gia esistenti, correlazione stimabile con l'oro di Wim dove i dati ci sono. Esce un elenco ordinato per "diversita" e per "evidenza gia presente".
2. **F2:** appena Claudio conferma le regole (o le corregge), scrivo il codice (EA nuovo, versione 1.00) e le righe di test.
3. **F3:** appena arriva l'output della riga di sola lettura.
4. **F4/F5:** dopo F1 e dopo la risposta di FTMO.
5. **Capacita:** un solo giro del tester alla volta sul PC di backtest; le notti lunghe (griglie da 10-14 ore) si assegnano a UN filone alla volta, quello con il migliore rapporto "diversita / evidenza".

## 5. Cosa NON sappiamo
- Se FTMO tratta un set UBS con parametri diversi come "strategia diversa" (risposta in attesa).
- Quali dei 47 EA ABTG hanno gia risultati affidabili nel repo, a che periodo e a che costi (F1 lo dice).
- Se esiste una strategia sull'oro (o sugli indici) con vantaggio dopo i costi che non sia un breakout: finora tutti i candidati non-Wim misurati (scalper UBS, Scalper Claudio 1.02) sono crollati a tick reali.
- Spread FTMO reali (foto di lunedi).
