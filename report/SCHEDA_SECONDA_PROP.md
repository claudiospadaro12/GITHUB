# SCHEDA SECONDA PROP — studio regolamenti (D3, avviato 12/08)

**Perche'**: la strategia decisa e' stesso portafoglio su DUE DITTE
DIVERSE (mai 5+5, mai due conti sulla stessa ditta). FTMO e' il metro
di paragone (il 100k dry-run simula i SUOI limiti: 10% totale, 5%
giornaliero, statici). La seconda ditta va scelta ADESSO con lo studio,
ma si compra SOLO dopo il forward maturo (regola 30/07, invariata).

**Come si usa**: una copia del blocco qui sotto per ogni ditta
studiata. Claudio legge il regolamento (telefono/poltrona), risponde
alle domande, Claude incrocia con le esigenze della flotta. Screenshot
dei passaggi ambigui -> si valutano insieme.

---

## Le 7 domande — e cosa ci serve sentire

**1. EA permessi senza restrizioni?**
   - Cerca: "Expert Advisor", "automated trading", "copy trading".
   - Ci serve: EA ammessi senza lista di divieti vaghi.
   - 🚩 Bandiere rosse: divieto di "copiare trade fra conti" scritto in
     modo largo (noi avremo GLI STESSI trade su due ditte: dev'essere
     chiaro che vietano il copy fra conti DELLA STESSA ditta, non la
     stessa strategia altrove); divieto di "HFT/tick scalping" scritto
     cosi' vago da poter colpire qualsiasi EA.

**2. Limiti di perdita: statici o trailing?**
   - Ci serve: daily loss e max drawdown STATICI (come FTMO). Il nostro
     Guardian e le tarature (0,65% -> p99 ~9,4%) sono costruiti su
     pavimenti fissi.
   - 🚩 TRAILING drawdown (il tetto sale coi profitti): cambia TUTTO il
     dimensionamento — se la ditta e' trailing, o si scarta o si
     ri-tara il Guardian sul peggiore dei due mondi.
   - Annota i numeri esatti: daily %, totale %, su equity o balance,
     a che ora resetta il "giorno" (fuso!).

**3. News trading permesso?**
   - I nostri EA NON filtrano le news per scelta (misurato: il filtro
     non paga). Se la ditta vieta di operare N minuti attorno alle news
     ad alto impatto SUL CONTO FINANZIATO, per noi e' un problema vero:
     il DAX/Dow aprono spesso vicino a dati macro.
   - Ci serve: nessuna restrizione news, o restrizione solo su
     "aprire posizioni nei 2 minuti attorno" (da valutare col
     calendario delle nostre aperture).

**4. Notturno e weekend?**
   - MaxMin DAX lavora 23:00-05:00 server, l'oro 22:00-07:00: ci serve
     trading notturno libero.
   - Posizioni overnight/weekend: la flotta chiude quasi tutto in
     giornata (flat 17:30/21:45), ma verificare comunque il divieto di
     holding weekend (STREV H2 e vivaio H1/H2 possono tenere qualche
     ora in piu').

**5. Consistency rules (regole di coerenza)?**
   - Cerca: "consistency", "max % of profit from single day/trade".
   - 🚩 Se un solo giorno non puo' superare il 20-30% del profitto
     totale: il DAX da solo fa giornate grosse — rischio di payout
     rifiutato pur avendo guadagnato. Ci serve: NESSUNA consistency
     rule, o soglia molto larga.

**6. Costi e payout**
   - Costo challenge 100k, refund alla prima payout?, split (80%+?),
     frequenza payout (14 gg? mensile?), scaling plan.
   - Ci serve per la SEQUENZA AUTOFINANZIATA: payout ditta 1 -> paga
     challenge ditta 2.

**7. Broker/feed: spread e slippage sugli indici CFD**
   - I nostri edge vivono su DAX/Dow/Nasdaq CFD: spread tipico in
     punti? commissioni? server dove? (il fuso cambia InpSessionHour!).
   - 🚩 Feed "interno" con spread larghi in apertura = l'edge
     dell'apertura si assottiglia proprio quando serve.
   - NOTA TECNICA (lezione v21 di oggi): cambiare broker = verificare
     fuso E unita' dei punti di OGNI simbolo. Niente trapianti di
     config: si ri-verifica tutto sul feed nuovo.

---

## Ditte candidate da studiare (ordine suggerito)

| Ditta | Perche' in lista | Stato studio |
|---|---|---|
| **FundedNext (Stellar 2-Step)** | **PRIMA DA STUDIARE** — pre-studio Claude 12/08 (fonti terze): DD statico, NESSUNA consistency su Stellar CFD, EA personali ammessi (vietati solo i commerciali), news = niente violazione ma "taglio 40%" sui profitti in finestra news sul conto finanziato | 🟡 pre-studio ok, DA VERIFICARE sul sito |
| The5ers (High Stakes) | seconda scelta — limiti molto simili a FTMO (10% assoluto + 5% daily statici), EA propri ammessi; 🚩 MA vieta ESECUZIONI nei 2 min attorno alle news ad alto impatto: per EA senza filtro news e' un rischio di violazione, va mappato contro i nostri orari fissi d'ingresso | 🟡 pre-studio ok, DA VERIFICARE |
| Funding Pips | costi bassi, payout frequenti | ⬜ da leggere |
| E8 Markets | popolare, ma verificare consistency e trailing | ⬜ da leggere |
| Alpha Capital | EA dichiaratamente ammessi | ⬜ da leggere |

### ⚠️ Aggiornamento pre-studio FundedNext (12/08 sera)
Claudio e' finito per errore su helpfutures.fundednext.com (prodotto
FUTURES: daily 1,25%, drawdown EOD progressivo = trailing — NON e' il
nostro; conferma vissuta che "il piano specifico conta"). Posto giusto:
**help.fundednext.com**, articoli del piano **Stellar 2-Step (CFD/MT5)**.
Dal pre-studio, TRE regole nuove da verificare con screenshot:
1. **Rischio totale aperto max 3%** sul conto finanziato (somma delle
   posizioni aperte) — 🚩 LA domanda per noi: con 12 serie a 0,65-1%
   l'una, quante posizioni CONTEMPORANEE abbiamo nei momenti peggiori?
   (misurabile dai nostri per-trade). Se la regola e' com'e' scritta,
   puo' imporre taratura 0,5% o un tetto ai simultanei.
2. **Stop-loss obbligatorio entro 3 minuti dall'apertura** sul funded —
   i nostri EA mettono sempre SL al piazzamento (verificare per tutti).
3. **EA = add-on A PAGAMENTO per account** su MT4/MT5 — costo extra
   da mettere nel punto 6.
Confermati (sempre da fonti terze): 10% statico / 5% daily dal saldo di
chiusura del giorno prima, news = taglio profitti (no violazione),
no consistency su Stellar CFD.

### 📊 ANALISI SOVRAPPOSIZIONI (12/08 sera) — la risposta alla domanda del 3%
Misurata sui per-trade OOS delle 12 serie (16 mesi). Gli export hanno
solo le chiusure, quindi la misura e' la COINCIDENZA PER GIORNATA
(tetto superiore della simultaneita' vera):
- 8 serie attive nello stesso giorno: 1 volta (15/10/2025)
- 6 serie: 7 giorni · 5 serie: 21 giorni · 4 serie: 52 giorni
- Il blocco affollato e' il POMERIGGIO 14:30-17:30 server: DAX+MaxMin+
  oro (aperti dal mattino, flat 17:30) incrociano Dow+ORB (dalle 14:30)
  + EMA200/PTE/SW che possono essere dentro a qualunque ora.
**Lettura**: se la regola FundedNext e' "somma del rischio delle
posizioni aperte <= 3%", il caso peggiore osservato (8 posizioni)
sfora a QUALSIASI taratura sopra lo 0,375%: 8 x 0,65% = 5,2%.
Attenuanti reali: (1) meta' delle nostre posizioni dopo il TP1 sono a
BE con rischio ~0 (la somma vera e' piu' bassa del conteggio x
rischio); (2) stesso-giorno non e' stesso-istante. Ma la conclusione
operativa non cambia: **le PAROLE ESATTE della regola (rischio da SL?
perdita flottante? margine?) decidono se FundedNext e' compatibile col
portafoglio pieno** — e' il primo screenshot da fare.
Nota di riflesso: FTMO non ha un tetto del genere — un motivo in piu'
per cui e' il metro di paragone. Prossimo passo tecnico possibile:
misurare le sovrapposizioni VERE dal conto demo (la cronologia MT5 ha
anche gli ingressi), se la regola confermata lo rendera' necessario.

_Pre-studio 12/08 da fonti terze (riassunti 2026, non i siti ufficiali):
ogni affermazione va CONFERMATA sulle FAQ ufficiali della ditta prima
del verdetto. La differenza chiave emersa: davanti alle news, FundedNext
taglia i profitti (nessuna violazione possibile), The5ers vieta le
esecuzioni (violazione possibile per un EA non filtrato). Per una
flotta che gira da sola, la prima formula e' strutturalmente piu' sicura._

⚠️ Le regole delle prop CAMBIANO SPESSO: ogni riga sopra va verificata
sul sito ufficiale IL GIORNO dello studio, mai per sentito dire. E il
piano specifico conta (lo stesso nome puo' avere programmi con regole
diverse).

---

## SCHEDA COMPILATA #1 — FundedNext (Stellar CFD)
- Data studio: 12/08/2026 (screenshot Claudio dell'articolo ufficiale
  "Quali sono i limiti di rischio di un conto FundedNext?", 6 lug 2026)
- 1 EA: ✅ ammessi ("tutti gli stili, inclusi automatizzati")
- 2 Limiti: 10% statico / 5% daily ✅ — MA vedi regola 3% sotto
- 3 News: taglio profitti, no violazione ✅ (fonte terza, non riverificata)
- 5 Consistency: nessuna su Stellar CFD ✅
- **LA REGOLA CHE DECIDE — rischio cumulativo max 3% "in qualsiasi
  momento" sul conto finanziato.** Parole esatte: rischio = massima
  perdita potenziale DALLA POSIZIONE DELLO STOP-LOSS, e SOMMA delle
  perdite massime realizzate e non realizzate su TUTTE le operazioni,
  sul saldo iniziale. Si applica a tutti gli stili, automatizzati
  inclusi. Enforcement: 1a violazione = ammonimento + confisca 100% dei
  profitti "non conformi" del ciclo; 2a violazione = **riclassificazione
  PERMANENTE a rischio cumulativo 1%**. Swap/commissioni esclusi.
- **Incrocio con la NOSTRA misura** (sovrapposizioni 16 mesi OOS):
  6-8 serie attive nello stesso giorno nei giorni pieni, blocco
  14:30-17:30. A 0,65% la somma degli SL aperti puo' plausibilmente
  superare il 3% PROPRIO NEI GIORNI MIGLIORI (piu' setup = piu'
  posizioni): la regola confischerebbe i profitti delle giornate
  buone, e alla seconda segnalazione il conto scende a 1% cumulativo
  = portafoglio morto. Stare sotto con certezza = taratura ~0,375%
  (rendimento quasi dimezzato rispetto allo 0,65%) o un coordinatore
  che salta trade (= divergenza dal comportamento misurato).
- **VERDETTO: ❌ SCARTATA come seconda prop per il portafoglio pieno.**
  La regola non uccide il conto ma tassa esattamente cio' che ci rende
  forti: la diversificazione simultanea. Resta tecnicamente possibile
  per un sotto-portafoglio 4-5 serie, ma D3 chiede la REPLICA del
  portafoglio completo: non e' questa la ditta.
- Prossima da studiare: **The5ers High Stakes** (limiti FTMO-like;
  da mappare il divieto di esecuzioni ±2 min sulle news contro i
  nostri orari fissi di ingresso).

## SCHEDA COMPILATA #2 — The5ers (High Stakes) — IN CORSO
- Data studio: 12/08/2026 (screenshot Claudio delle FAQ ufficiali
  the5ers.com, last update 10/08/2026)
- **3 NEWS — VERIFICATA, testo ufficiale:**
  - Tenere posizioni aperte sulle news: PERMESSO ✅
  - VIETATO eseguire QUALSIASI ordine (market, stop, limit) da 2 min
    prima a 2 min dopo una news ad alto impatto (red folder Forex
    Factory) SULLA valuta/indice correlato. Ora del LORO server.
  - Violazione = **SOFT BREACH**: profitti di quel trade detratti,
    perdite restano al trader. NON e' una chiusura del conto ✅
  - SL/TP preimpostati che scattano durante le news: ESPLICITAMENTE
    non e' violazione ✅ (salva trailing e stop della flotta)
  - ⚠️ IL PUNTO PER NOI: "la regola si applica al momento in cui
    l'ordine viene ESEGUITO, non a quando il pending e' stato
    piazzato" — un pending che scatta dentro la finestra E' soft
    breach. I nostri box MaxMin (DAX notte, oro) scattano sulla
    rottura: se la rottura arriva su una news (l'oro sui dati USA!),
    quel trade e' tassato. Tassa occasionale (finestre da 4 min),
    non struttura: accettabile, ma da stimare in forward.
  - Nota a margine: il divieto di "bracketing" sulle news (buy stop +
    sell stop insieme) e' scritto SOLO per Instant Funding/Bootcamp —
    il MaxMin e' un bracket: se mai si guardasse un altro programma
    loro, questo lo esclude. Su High Stakes vale solo la finestra 2 min.
- **2 LIMITI — VERIFICATI, testo ufficiale (FAQ 10/08/2026):**
  - Max loss: **10% dal SALDO INIZIALE (absolute drawdown) = STATICO** ✅
  - Daily: **5% dal massimo tra equity e balance di chiusura del giorno
    prima**, fotografato alle **00:00 ora del loro server** ✅
  - Sforare uno dei due = chiusura del conto (hard, come FTMO)
  - Struttura IDENTICA a FTMO: il Guardian e la taratura 0,65%
    (p99 ~9,4% < 10%) si trasferiscono cosi' come sono.
  - Seconda conferma ufficiale (FAQ 10/06/2026, incollata da Claudio):
    daily 5% dal max(equity, balance) di INIZIO giornata, **MT5 Server
    Time GMT+2 inverno / GMT+3 estate**. Quindi il LORO server d'estate
    e' ~2 ORE AVANTI rispetto a BCM (che sta a ora italiana −1):
    lezione v21 gia' in cassa — se un giorno si passa a The5ers, OGNI
    InpSessionHour va ricalcolato e OGNI EA riverificato sul loro
    feed (fuso + unita' punti + spread). Trafila prevista, non
    sorpresa.
- **1 EA — VERIFICATO, testo ufficiale (incollato da Claudio 12/08):**
  - EA ammessi purche' NON: copino segnali altrui, tick scalping,
    arbitraggi (latency/reverse/hedge), HFT, emulatori. I nostri:
    nessuna di queste categorie ✅
  - **Lo stop-loss deve essere VISIBILE in piattaforma** (niente SL
    "stealth"): i nostri EA piazzano sempre SL reali sulle posizioni ✅
  - **"Il trader deve POSSEDERE il codice sorgente dell'EA"**: caso
    nostro perfetto — tutti gli ABTG hanno sorgente nel repo ✅✅
    (nota gustosa: il v21 dell'amico questa regola l'avrebbe FALLITA —
    solo ex5, niente sorgente. Terza conferma della scelta di oggi.)
- **5/6 PAYOUT E CONSISTENCY — VERIFICATI in parte (testo ufficiale
  11/08/2026, articolo "conto finanziato $200K"):**
  - Split: **80/20** al trader (meno generoso di altri, accettabile)
  - Prelievo minimo $250 — **🚩 TETTO $3.000 PER CICLO DI PAYOUT**:
    la regola col morso. Sul conto 200k = 1,5% a ciclo. Il nostro
    scenario da ~4.400-5.500 EUR/mese di quota trader regge SOLO se
    il ciclo e' quindicinale (2 x 3.000 = ~6k/mese) e/o se il tetto
    CRESCE con lo scaling. DA CHIARIRE: frequenza del ciclo, crescita
    del tetto nel tempo, e se l'articolo (conto $200K) e' proprio il
    percorso High Stakes 100k. Nota strategica: e' l'argomento PIU'
    FORTE mai trovato a favore della replica su 2-3 ditte (D3
    estesa): i tetti per-ditta si sommano.
  - **Daily consistency 50%**: nessun giorno singolo puo' valere piu'
    del 50% del profitto totale AL MOMENTO della richiesta di payout.
    Piu' morbida della soglia 20-30% temuta in checklist, e si gestisce
    ASPETTANDO (richiedi quando il totale >= 2x la miglior giornata).
    Coi 12 motori il profitto e' gia' distribuito; da modellare sulle
    nostre giornate DAX grosse, ma non e' un blocco: e' un ritmo.
- **⚠️ PRATICHE VIETATE (testo integrale 28/07/2026, trovato da
  Claudio OLTRE la checklist — la scoperta piu' importante):**
  Violarle = TERMINAZIONE del rapporto + ban + niente rimborso (NON
  soft breach). Lista lunga e in parte SCRITTA VAGA, con TRE punti che
  toccano la nostra flotta:
  1. 🚩🚩 **"Bulk trading: piu' trade aperti simultaneamente...
     strumenti automatici che aprono piu' trade insieme, mostrando
     chiaramente che dietro non c'e' un trader"** — 12 EA che alle
     14:30-14:45 possono aprire 3-4 posizioni quasi insieme SONO
     "piu' trade aperti simultaneamente da strumenti automatici".
     Noi siamo un portafoglio legittimo, ma la regola com'e' scritta
     non distingue.
  2. 🚩🚩 **"Bracketing: pending buy stop + sell stop vicino al prezzo
     attorno alle news"** — il MaxMin E' un bracket per costruzione
     (box con buy stop + sell stop). Lo piazza a orario fisso, non
     "attorno alle news" — ma nei giorni in cui una news rossa cade in
     mattinata, il lato che scatta sullo spike e' INDISTINGUIBILE
     dalla situazione vietata. Rischio strutturale per MaxMin DAX
     notte e MaxMin ORO.
  3. 🚩 **"One-sided bets: posizioni costantemente in una sola
     direzione"** — DAX Apertura (SOLO LONG), Dow Apertura (SOLO
     LONG), MaxMin DAX Short (SOLO SHORT) sono mono-direzione PER
     SCELTA MISURATA. La regola com'e' scritta li descrive.
  4. (minore) "Concentrazione ripetuta su strumento singolo/correlati"
     — i 5 motori sul Dow: correlazioni misurate basse, ma lo
     strumento e' lo stesso; dipende dall'interpretazione.
  Cose invece a posto: niente arbitraggi/HFT/tick scalping/copy ✅,
  sorgente posseduto ✅, richieste server nella norma ✅, il
  cross-firm vietato e' quello MANIPOLATIVO (posizioni OPPOSTE fra
  ditte) — la replica D3 e' STESSA direzione, non e' l'esempio
  vietato, ma resta zona grigia da chiarire ✅/⚠️.
- **STATO VERDETTO #2 (12/08 sera): CANDIDATA CON RISERVE.** Numeri
  e regole quantitative tutte compatibili (news soft-breach, drawdown
  FTMO-like, EA col sorgente). MA le pratiche vietate contengono 3
  clausole vaghe che un revisore potrebbe applicare alla nostra
  flotta, con pena massima. PASSO OBBLIGATO prima di ogni acquisto:
  **chiarimenti SCRITTI dal loro supporto** su (a) portafoglio di EA
  propri che aprono piu' posizioni simultanee, (b) bracket OCO a
  orario fisso notturno/alba, (c) EA mono-direzione da backtest.
  Se le risposte scritte sono positive, e' la candidata; se sono
  evasive, si passa alla prossima ditta.
- **SCALING (testo ufficiale 10/06/2026):** a $350k di saldo ->
  payout fisso mensile $4.000; a $500k -> $10.000/mese. Quindi il
  tetto da $3.000/ciclo e' della FASE INIZIALE e l'economia CRESCE
  con lo scaling: la traiettoria del flusso c'e', e' solo piu' lenta
  in partenza. (Resta da capire la frequenza del ciclo iniziale.)
- DA COMPLETARE:
  - 🚩 tetto di esposizione aggregata ("maximum exposure" nelle FAQ)
  - frequenza del ciclo di payout iniziale
  - 4 notturno/weekend · 6 costo challenge · 7 spread
- LEZIONE DI METODO (da aggiungere alla checklist per ogni ditta
  futura): leggere SEMPRE per intero la pagina "Prohibited Trading
  Practices" — le 7 domande non bastano, le trappole vivono li'.
- **Verdetto: in corso — la regola news e' COMPATIBILE (tassa
  occasionale, nessun rischio conto). Si prosegue.**
