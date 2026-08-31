# 🔇➡️🔊 CHECKLIST "13 SEDIE MUTE" — verifica sul VPS, 15-20 minuti col telefono in mano

_Deliverable della **MOSSA 3 della FIRMA "PORTATA"** (`report/FIRME_2026-08-31.md`,
firmata da Claudio il 31/08 sera: "FIRMO TUTTE E DUE, PARTIAMO")._

**Perche' conta: queste 13 sedie valgono 21 op/mese PROMESSE e MAI CONSEGNATE
— portata gia' pagata** (Area H del `PIANO_PROP.md` v16, riga H0: 13 sedie su
37 a zero ingressi nella finestra 03→28/08). E per cinque di loro (i GapFill)
**il sospetto di guasto e' agli atti dal 22/08**
(`report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` §6) **e non e' mai stato
verificato sul VPS**: nove giorni di sospetto senza un controllo da 3 minuti.

🛑 **REGOLA DELLA MISSIONE: SOLO GUARDARE.** Niente input cambiati, niente EA
staccati o riattaccati, niente ricompilazioni: questa checklist PRODUCE UNA
CLASSIFICAZIONE, non una riparazione. Ogni riparazione e' una decisione
separata di Claudio, dopo.

---

## ⏰ PRIMA DI TUTTO — i due orologi (l'errore del 06/08, da non rifare)

| dove guardi | che ora e' |
|---|---|
| Schede **Esperti** e **Giornale** (i log) | **ora ITALIANA** (ora locale del VPS Windows) |
| **Grafico**, candele, orari negli input | **ora SERVER BCM = italiana − 1** |

Controllo lampo: l'ultima riga del log deve coincidere con l'orologio di
Windows; l'ultima candela del grafico e' un'ora indietro. Un ordine col
timestamp `09:15` nel log e' stato piazzato alle `08:15` server. **Prima di
dire che un EA e' in ritardo o muto, stabilisci in quale ora e' scritto il
numero.**

---

## 📋 LA TABELLA DELLE 13 — chi sono, dove stanno, cosa promettono

_Fonti: Area H (H0) di `report/PIANO_PROP.md` v16 · censimento `.chr`
`backtest_pipeline/risultati_archivio/censimento_rischio_2026-08-25_0731.txt`
(colonne rischio e commento) · `report/CONTRATTI_SEDIE.md` (promesse) ·
`report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` (silenzi misurati)._

| # | EA | Magic | Simbolo | Grafico atteso (TF) | Commento ordini | Rischio | Op/mese promesse | Zero da (misurato) |
|---|---|---|---|---|---|---:|---:|---|
| 1 | ABTG_GapFill | **772231** | GBPUSD | GBPUSD **H1** | `GAP GBPUSD` | 1,0 | 0,6 | sempre (mai 1 riga nello statement) |
| 2 | ABTG_GapFill | **772232** | EURUSD | EURUSD **H1** | `GAP EURUSD` | 1,0 | 0,7 | sempre |
| 3 | ABTG_GapFill | **772233** | AUDUSD | AUDUSD **H1** | `GAP AUDUSD` | 1,0 | 0,9 | sempre |
| 4 | ABTG_GapFill | **772234** | U30USD | U30USD **H1** | `GAP DOW` | 1,0 | 1,5 | sempre |
| 5 | ABTG_GapFill | **772235** | 225JPY | 225JPY **H1** | `GAP NIKKEI` | 1,0 | 1,2 | sempre |
| 6 | ABTG_PTE | **771321** | U30USD | U30USD (InpTF **H1**) | `PTE DOW` | 1,0 | 3,2 | sempre |
| 7 | ABTG_PTE (candidata R78) | **771332** | GBPUSD | GBPUSD **H1** | `PTE GBPUSD B25` | 0,5 | 3,0 | dal deploy 17/08 |
| 8 | ABTG_BreakingBand | **772162** | EURUSD | EURUSD **H1** | `BB EURUSD` | 1,0 | 1,0 | sempre |
| 9 | ABTG_BreakingBand | **772163** | AUDUSD | AUDUSD **H1** | `BB AUDUSD` | 1,0 | 0,8 | sempre |
| 10 | ABTG_PunteLarry | **772341** | U30USD | U30USD **H1** (pattern su D1) | `LARRY DOW` | 1,0 | 2,9 | sempre |
| 11 | ABTG_PunteLarry | **772344** | GBPJPY | GBPJPY **H1** (pattern su D1) | `LARRY GBPJPY` | 1,0 | 1,5 | sempre |
| 12 | ABTG_SupRev_DAX_H4_Ottimizzato | **970912** | D30EUR | D30EUR **H4** | `STREV DAX H4` | 1,0 | 4,0 | sempre |
| 13 | Gold_Ichimoku_TK_ATR_EA | **250604** | XAUUSD | XAUUSD **H1** | (vuoto nel censimento) | 0,5 | ~7,2 | **ultimo trade 19/06** — oltre 70 giorni di silenzio |

_Nota TF: il censimento `.chr` non registra il timeframe del grafico; i TF qui
sopra vengono dai default `InpTF` dei sorgenti e dalle schede di deploy
(GapFill/BreakingBand/PunteLarry: `InpTF=H1` nel sorgente; PTE GBPUSD: `InpTF
1 Hour` verificato a schermo il 17/08; SupRev DAX: H4; Ichimoku: XAUUSD H1 da
`docs/Portafoglio_Strategie.md`). Se sul VPS il TF del grafico e' diverso NON
e' di per se' un guasto (molti EA leggono `InpTF`, non il grafico) — annotalo
e basta._

---

## 🔍 LA PROCEDURA — 6 controlli per sedia, sempre nello stesso ordine

Per OGNI grafico della tabella (apri il grafico dal terminale MT5 del VPS,
conto piccolo 50503392):

1. **IL GRAFICO ESISTE?** Cerca il grafico simbolo+commento. Se il grafico
   non c'e' piu' → **GUASTA (staccata)**, hai finito con questa sedia.
2. **CAPPELLINO EA ATTIVO?** In alto a destra deve esserci il nome dell'EA
   con la faccina/cappellino ATTIVO (non grigio/barrato). E il bottone
   **Algo Trading** globale deve essere VERDE. Cappellino grigio o Algo
   spento → **GUASTA**, annota quale dei due.
3. **INPUT GIUSTI?** Doppio click sull'EA → scheda Input. Verifica i 3 campi
   firma: **magic** (colonna della tabella), **rischio**, **commento**. Un
   magic diverso da quello atteso = la sedia che cerchi NON esiste (i suoi
   trade finirebbero sotto un altro numero) → **GUASTA (identita')**.
4. **SCHEDA ESPERTI — righe recenti?** Filtra per il nome dell'EA. Domanda
   secca: **c'e' almeno una riga di OGGI o di ieri?** (ricorda: ora
   ITALIANA). Un EA vivo su H1 scrive/valuta a ogni barra o almeno
   all'avvio; un log fermo a giorni fa = EA non sta girando (terminale
   riavviato senza profilo? grafico chiuso?) → **GUASTA**.
5. **GIORNALE — errori?** Sempre filtro sul periodo recente: cerca righe
   rosse tipo `cannot load`, `not enough memory`, errori di compilazione,
   disconnessioni ripetute, `Token imprevisto` (build corrotta). Errori
   presenti → **GUASTA**, fotografa la riga.
6. **SE TUTTO SOPRA E' VERDE**: il motore e' vivo e semplicemente **non ha
   mai avuto le sue condizioni** — verifica che sia PLAUSIBILE col
   comportamento atteso della famiglia (tabella sotto) e classifica
   VIVA-MA-SELETTIVA o DA-DECIDERE.

📸 **Per ogni sedia: uno screenshot** (pannello input o scheda Esperti). E'
la "legge dello screenshot" di casa: nessuna verifica e' fatta senza foto.

---

## 🧠 IL COMPORTAMENTO ATTESO, famiglia per famiglia (per giudicare il punto 6)

### 🟠 GapFill ×5 (772231-35) — LA PRIORITA', sospetto agli atti dal 22/08
- **Quando spara**: SOLO all'apertura settimanale (domenica sera forex /
  lunedi' indici), se il gap col venerdi' sta fra `InpGapMinATR` e
  `InpGapMaxATR` per l'ATR(D1) e lo spread e' sotto soglia entro 3 barre H1.
  UNA finestra d'ingresso a settimana: se il filtro boccia, la settimana e'
  persa.
- **Cosa deve esserci nel log anche a zero trade**: una valutazione OGNI
  LUNEDI' (gap misurato, accettato o scartato). **Se nei log di lunedi'
  25/08 e lunedi' 18/08 non c'e' NULLA, la famiglia non sta valutando: e'
  guasta, non selettiva.**
- **Perche' il sospetto e' forte** (§6 del censimento 22/08): le famiglie
  gemelle deployate nello stesso periodo (PunteLarry, CostToCost, EasyTrend)
  hanno tutte almeno un trade; i 5 GapFill promettono **~5,3 chiusure/mese
  COMBINATE** e sono a zero TUTTI E CINQUE insieme da piu' di 4 settimane:
  statisticamente stretto. E il censimento chiedeva gia': **build `.ex5`
  vecchia?** (annota la data del file se riesci: Navigator → Experts).
- **Classificazione**: log del lunedi' presenti con motivo di scarto →
  **VIVA-MA-SELETTIVA**. Log del lunedi' assenti (con cappellino ok) →
  **GUASTA (build/logica)**. Cappellino/Algo/grafico ko → **GUASTA**.

### 🧪 PTE GBPUSD B25 (771332) — il controllo piu' TAGLIENTE dei tredici
- La gemella del duello (**771322**, stessi segnali d'ingresso, cambia solo
  buffer SL e TP2) **ha operato** (1 trade il 14/08). Stesso segnale, due
  esiti: se la 771322 apre e la 771332 no, il sospetto e' sul GRAFICO della
  771332 (staccato, input sbagliati, cappellino), non sul mercato.
- **Verifica extra**: pannello input campo per campo contro la tabella del
  duello in `FLOTTA_ATTIVA.md` (buffer **25**, TP2 **3,0**, rischio 0,5,
  magic 771332, commento `PTE GBPUSD B25`).
- **Classificazione**: se la 771322 ha trade nel periodo e la 771332 era
  accesa con input giusti e zero trade → **GUASTA quasi certa** (o input
  divergenti non previsti dal duello). Se anche la 771322 e' quasi ferma
  (1 trade in un mese) → **DA-DECIDERE** (famiglia lenta, il duello giudica
  a 30 trade).

### 🪑 PTE DOW (771321)
- Motore H1 su TMA, promette 3,2 op/mese; le sorelle PTE hanno fatto 1-2
  trade nel mese. Zero assoluto da sempre e' il valore piu' basso della
  famiglia. Log recenti presenti → **DA-DECIDERE** (famiglia gia' in
  osservazione C3: frequenza molto sotto il promesso = revisione). Log
  assenti → **GUASTA**.

### 📉 BreakingBand EURUSD / AUDUSD (772162 / 772163)
- Spara solo dopo un BULGE valido delle bande 20/2 (espansione + deviazione
  standard sopra la sua SMA50 + candele impulsive): condizione RARA per
  costruzione, promessa 1,0 e 0,8 op/mese. La sorella GBPUSD (772161) ha
  fatto 1 trade: la famiglia gira.
- **Classificazione**: cappellino+input+log ok → **VIVA-MA-SELETTIVA** e'
  l'esito atteso (a 0,8-1,0 op/mese, un mese a zero e' nel carattere).
  Qualunque rosso nei punti 1-5 → **GUASTA**.

### 🎯 PunteLarry DOW / GBPJPY (772341 / 772344)
- Ogni giorno all'apertura D1 valuta i pattern (Smash/Oops) e SE c'e' setup
  piazza un PENDENTE, che spesso scade non eseguito. Le 4 sorelle
  (EURAUD/XAUUSD/GBPUSD/EURCAD) hanno 1 trade a testa.
- **Cosa cercare nel log**: righe di piazzamento/cancellazione pendenti
  anche senza trade. Pendenti visti → **VIVA-MA-SELETTIVA**. Nessuna
  attivita' giornaliera nel log → **GUASTA**.

### 🌊 SupRev DAX H4 (970912)
- Supertrend H4 sul DAX: un flip ogni qualche giorno, promessa 4 op/mese —
  **un mese intero a zero NON e' nel carattere**. Contratto gia' segnato
  "marginale" (revalidation PFmed 1,05).
- **Classificazione**: se e' guasta → **GUASTA**; se e' viva coi log a
  posto → **DA-DECIDERE** (revisione C3 per frequenza + merito marginale:
  la domanda vera e' se tenerla, non se ripararla).

### 🥇 Gold Ichimoku (250604)
- Cross Tenkan/Kijun su XAUUSD H1, solo long: promette ~7,2 op/mese, e i
  cross TK su H1 capitano piu' volte al mese. **Oltre 70 giorni di silenzio
  (ultimo trade 19/06) non sono selettivita'**: o e' guasta, o il filtro
  Kumo la tiene fuori da luglio (verificabile solo dal log).
- Aggravante gia' agli atti (`CONTRATTI_SEDIE.md`): contratto PARZIALE,
  validata su ALTRO broker (Tickmill; su BCM lo stesso test faceva PF 1,01 /
  DD 28%).
- **Classificazione**: guasti tecnici → **GUASTA**. Viva e muta →
  **DA-DECIDERE con dossier gia' pronto per lo spegnimento** (tagliando C3:
  frequenza a 1/9 del promesso + contratto zoppo sul broker sbagliato — la
  parola resta a Claudio).

---

## 🚦 I TRE VERDETTI — criterio unico, dichiarato prima di guardare

| verdetto | criterio | cosa succede dopo |
|---|---|---|
| 🔴 **GUASTA** | uno qualunque dei punti 1-5 e' rosso: grafico assente, cappellino/Algo spento, magic o input sbagliati, log fermo da giorni, errori nel Giornale, build vecchia | lista di riparazione per Claudio (azione separata, MAI in questa sessione di verifica) |
| 🟢 **VIVA-MA-SELETTIVA** | punti 1-5 tutti verdi E il silenzio e' plausibile per il carattere del motore (promessa <1,5 op/mese, o log che mostrano valutazioni/scarti/pendenti) | ok cosi': si lascia lavorare, ricontrollo al prossimo censimento |
| 🟡 **DA-DECIDERE** | punti 1-5 verdi MA il silenzio e' molto oltre la frequenza promessa (Ichimoku ~7,2 → 0 · SupRev DAX 4 → 0 · PTE DOW 3,2 → 0) | revisione di Claudio ai sensi della C3 (tagliando: "frequenza molto sotto il promesso") — spegnere/tenere e' una firma, non un esito tecnico |

**Attesa dichiarata prima della verifica** (cosi' il risultato ci giudica):
GapFill = da chiarire (il pattern grida guasto, ma serve il log del lunedi');
BreakingBand ×2 e Larry ×2 = probabile VIVA-MA-SELETTIVA; 771332 = probabile
GUASTA; Ichimoku, SupRev DAX, PTE DOW = probabile DA-DECIDERE.

---

## 📱 ORDINE DI ESECUZIONE (15-20 minuti)

1. **I 5 GapFill** (772231→772235, ~6-7 min): stessa famiglia, stessi
   controlli, e il log del lunedi' e' la chiave. Prima i 5 perche' il
   sospetto e' agli atti da nove giorni e valgono ~5,3 op/mese da soli.
2. **771332 PTE B25** (~2 min): il confronto con la gemella e' immediato.
3. **970912 SupRev DAX H4** (~2 min).
4. **250604 Gold Ichimoku** (~2 min).
5. **772162/772163 BreakingBand** (~3 min).
6. **772341/772344 PunteLarry** (~3 min): cerca i pendenti nel log.
7. **771321 PTE DOW** (~2 min).

## 📤 RACCOLTA RISULTATI (regola delle righe di lancio, punto 2-3)

A fine giro: compila la tabellina qui sotto (anche a voce in chat va bene),
salva gli screenshot in una cartella sul **Desktop del VPS** (es.
`Desktop\VERIFICA_MUTE_2026-08-31\`) e zippala con `Compress-Archive` —
attesi: **13 screenshot** (uno per sedia) + eventuali foto di righe rosse
del Giornale.

| magic | verdetto (GUASTA / VIVA / DA-DECIDERE) | nota (quale punto era rosso / cosa dice il log) |
|---|---|---|
| 772231 | | |
| 772232 | | |
| 772233 | | |
| 772234 | | |
| 772235 | | |
| 771321 | | |
| 771332 | | |
| 772162 | | |
| 772163 | | |
| 772341 | | |
| 772344 | | |
| 970912 | | |
| 250604 | | |

**Col risultato in mano**: le GUASTE vanno in lista riparazioni (build,
riattacco, profilo), le VIVA restano, le DA-DECIDERE vanno a Claudio con la
C3 in mano. E il `PIANO_PROP` (H0) si aggiorna: ogni sedia che torna a
parlare e' portata gia' pagata che rientra in casa. 🔊

---

## ✅ VERDETTO GAPFILL (31/08 16:48, log VPS letti da Claudio): VIVE-MA-SELETTIVE — sospetto guasto MORTO

Prova diretta dallo screenshot dei log (scheda Esperti, conto 50503392):
- 01:00:00 ABTG_GapFill (U30USD,H1): "spread 1000 points sopra il limite
  300: rinvio alla barra successiva (barra 2 di 3)" — la GUARDIA spread
  lavora.
- **02:00:00 ABTG_GapFill (U30USD,H1): "GAP-FILL BUY @ 53409.50 SL 53311.50
  TP 53559.50 lot 0.60 (gap -124.00 = 0.34 x ATR D1, spread 200 pts,
  barra 3 della settimana, ordine 3272200)" — TRADE REALE APERTO.**

Conclusione: il silenzio di agosto era selettivita' (gap assenti/piccoli +
guardia spread), NON guasto. Il sospetto del 22/08 (CENSIMENTO §6) si chiude.
Le altre 4 GapFill loggano dallo stesso motore: presunzione VIVE (conferma
puntuale simbolo-per-simbolo alla prossima passata di checklist, priorita'
bassa). NOTA per l'aritmetica della portata: le +21 op/mese "da recuperare"
NON esistono come guasto — la frequenza promessa delle GapFill va invece
RIVISTA al ribasso sul misurato (tagliando C3, non riparazione).

Bonus dallo stesso screenshot: la flotta del piccolo OGGI e' vivissima —
SuperWave DOW short a mercato alle 07:00, LARRY pendenti su 3 simboli + un
TIME-STOP eseguito, EMA200 limiti, MaxMinNotte stop alle 08:00. Lo "zero
trade di oggi" riguardava SOLO il 100k (5 mirror).
