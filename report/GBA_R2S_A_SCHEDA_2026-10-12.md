# GBA R2S STADIO A — i simboli gemelli, sonda dei costi (scheda, 12/10/2026)

**Stato: BOZZA, NON consegnata.** Primo giro dello strato 2 (`controllo-preventivo`, 12/10) sul pin `a2406def`: **FAIL** per un solo difetto di giudizio (classe 1104 b: il "costo grezzo" di una CELLA usato da attese, smentite e frase "FRA sui segnali grezzi" non aveva una regola di aggregazione delle sei fasce), corretto nei 5 file prova (blocco L3, regola della **mediana ponderata per n** scritta prima dei numeri). Secondo giro dello strato 2 (12/10) sul pin `b68faae7`: **FAIL** per un difetto rimasto dal primo giro (classi 1369 e 1104 b: la regola "ESCLUSA PER COSTO" dell'esito (B), *"< 13,3x in OGNI fascia con >= 100 segnali"*, era vera **a vuoto** con zero fasce a 100 segnali e chiudeva la casella 4 anche con una sola fascia a 100 e la cella a 45x), corretto nei 4 file dei gemelli (esito B: servono almeno una fascia a 100, tutte quelle sotto soglia **e** la cella sotto soglia) e nel blocco L3 di tutti e 5; smentita dell'argento estesa al costo grezzo della CELLA. Gli SHA dei file prova sono cambiati di nuovo: **la riga va ripinnata** al commit che contiene i 5 file prova corretti (e i 5 SHA nuovi messi nella riga), **poi** di nuovo i due strati del cancello.
Terzo giro dello strato 2 (12/10) sul pin `2d391b5f`: **FAIL**, corretto nei 5 file prova (solo commenti: i 9 ini generati dal driver sono identici byte per byte). (1) **La L3 sottostima di 14,6% sull'oro** (classe 291): misurata sulle 6973 righe di S0_01 che erano già nello zip, la mediana ponderata delle mediane di fascia fa 19,48x, la mediana vera del campo `stop/spread` 22,80x. Ora "ESCLUSA PER COSTO" si legge **solo** sul C3G (mediana del campo `stop/spread` delle righe del giornale), con lo strumento D2 passato dal cancello prima di aprire lo zip; senza D2 non si scrive "ESCLUSA". (2) **CE6** (classi 1369 e 1372): `ingressi tentati` si conta prima dell'ordine e il driver non mette KO gli ordini rifiutati; ora serve `tentati − n ≤ 1`, e l'eccezione n = 0 vale solo con `tentati 0` e `scartati spread ≥ 1`. (3) L'esito (A) scrive una frase anche sotto 13,3x. (4) La **CE2** diventa rossa solo per l'etichetta mancante o per la firma dell'oro su ogni fascia; le bande diventano attese. (5) Lo **spread della cella** (smentita dell'argento, fonte del Dow) ha una definizione.

EA `mql5/Experts/ABTG_GoldBreakoutATR.mq5` v1.10, SHA256 `1381e3dc…` — **non toccato**. Driver `GBA_R0_PASSATE.ps1` v5 (`C239F628…`) e lettore `leggi_gba_r0.py` (`9CD02D2A…`) — **non toccati**.
Fonte del disegno: `report/GBA_R2_PIANO_2026-10-10.md` §5.1-5.4 (R2S), §3.3, §6. Richiesta di Claudio del 12/10: *"SI PREPARA LA RIGA PER IL GBA SUGLI ALTRI SIMBOLI"*.

## 1. 🎯 Cosa misura (e niente altro)
Casella 4 del certificato di morte (simboli gemelli), **stadio A del piano**: la REPL di R1A **invariata** (canale 48, EMA 100, ATR 14, spread max 0,05 × ATR, SL e trailing 2,5 × ATR, tempo 48 barre, BE 1,0 ATR, lotto fisso 1,00) con il **solo simbolo cambiato** e il **TF del segnale** come variabile, **Modello 1** (OHLC su M1: sonda di conteggio e costo, come S0 del 09/10), **una tranche** T1 2026.07.01-2026.09.30 (la stessa di R1A). Risponde a una sola domanda: **quali (simbolo, TF) hanno abbastanza ingressi, e a che costo, per meritare lo stadio B a tick reali.** Nessun PF si legge come merito.

| lotto | file prova | SHA256 | celle (InpSignalTF) | passate | tetto |
|---|---|---|---|---:|---:|
| R2SANC | `GBA_R2S_ANCORA_2026-10-12.txt` | `770ECBC0…` | XAUUSD REPL = M1 (**ancora**) | 1 | 10' |
| R2SXAG | `GBA_R2S_XAGUSD_2026-10-12.txt` | `959124AF…` | XAGUSD REPL = M1, M15 | 2 | 15' |
| R2SNAS | `GBA_R2S_NASUSD_2026-10-12.txt` | `03D642DB…` | NASUSD M5, M15 | 2 | 15' |
| R2SD30 | `GBA_R2S_D30EUR_2026-10-12.txt` | `1C9CCEFF…` | D30EUR M5, M15 | 2 | 15' |
| R2SU30 | `GBA_R2S_U30USD_2026-10-12.txt` | `56DDF0CF…` | U30USD M5, M15 | 2 | 15' |

Dei 30 pin, rispetto al file madre `GBA_R0_REPLICA_2026-10-09.txt`, cambia **solo `InpSymbol`** (l'ancora: nulla). Magic 775800 ovunque (il driver ammette solo 775800/775850; il blocco 7758xx non è usato da nessuna sedia).

## 2. 🖥️ Bersaglio, tempo, cosa NON viene toccato
- **Bersaglio**: SOLO una finestra **PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`**; il terminale è `C:\Program Files\BCM Markets MT5 Terminal` (loggato sul demo **50503392**), aperto e chiuso dallo script una volta per passata, **solo Strategy Tester** (`AllowLiveTrading=false`). La riga si rifiuta di partire su un'altra macchina.
- **NON TOCCATI, per nome** (paragrafo della riga, identico alle righe modello): prima su questo PC `C:\MT5_Backtest` (cartella dati 04C7A32B) e `C:\FundedNext_Manuale` (2B8180C3), che devono restare CHIUSI; poi il VPS VMI3047753 e TUTTE le sue cartelle dati: FTMO trial 1514806751 (`C:\FTMO`, le sedie e il Guardian), **REALE 10105439 (`C:\BCM_Reale`)**, 100k 50504263 (`BCM Markets MT5 Terminal -V3`), piccolo 50503392 sul VPS (`BCM Markets MT5 Terminal`), manuale 50503635 (`C:\MT5_MANUALE`), banco 50504400 (`C:\MT5_Backtest`), Pepperstone, Tickmill. Non tocca `CODA.txt`, il runner notturno, preset, sedie, conti, taglie, né alcun parametro in forward. Scrive SOLO: `abtg_passata` nel profilo utente, `MQL5\Experts` e `MQL5\Include` del terminale BCM del PC, i report `.htm` del tester, il Desktop (zip `GBA_R0_R2SANC/R2SXAG/R2SNAS/R2SD30/R2SU30` e la raccolta `GBA_R2S_A.zip` con `ESITI_R2S_A.txt`).
- **Tempo**: centro **~12 minuti**, intervallo 8-40 (ancora: S0, 5 passate a Modello 1 in 4 minuti, 34 s a passata; qui 9 passate + 5 compilazioni; i simboli nuovi possono scaricare la storia M1 la prima volta). **Non fermarla prima di 250 minuti** (caso peggiore calcolato nella riga). Nessuna spesa.
- 🟡 **rc 3 atteso per l'argento**: con ZERO operazioni il driver mette la passata KO e il lotto R2SXAG esce con rc 3. Non è un guasto (vedi §4, eccezione); lo zip esce lo stesso.

## 3. 📏 Attese scritte PRIMA dei numeri (dettaglio e smentite nei file prova)
Stime **[INFERITO]** su stime (piano §5.2 per scalatura dall'oro, quota che passa il filtro ridotta col rapporto tester/proxy misurato sull'oro). Bande larghe di proposito; fuori banda = si legge il giornale prima, non è un risultato.

| (simbolo, TF) | costo GREZZO (piano 5.3) | quota liberi scartata per spread | n ingressi T1 | esito atteso stadio A |
|---|---|---|---|---|
| XAGUSD M1 | < 13,3x (stima 2,2x) | ≥ 97% | 0-30 (~5; **0 probabile**) | (B) non passa |
| XAGUSD M15 | < 13,3x (stima 9,6x) | ≥ 95% | 0-15 (~3) | (B) non passa |
| NASUSD M5 | 35-50x (stima 42,7x) | 55-85% | 80-450 | (A) passa |
| NASUSD M15 | ≥ 40x (76,9x) | 10-50% | 40-250 | (A) passa |
| D30EUR M5 | < 40x, FRA (29,7x) | 70-95% | 40-300 | (A) con "FRA sui grezzi, PASSA solo grazie al filtro" |
| D30EUR M15 | ≥ 40x (53,5x) | 30-70% | 30-200 | (A) |
| U30USD M5 | < 40x, FRA (25,3x) | 80-97% | 25-200 | (A) con "FRA sui grezzi"; (B) possibile |
| U30USD M15 | ≥ 40x (45,5x) | 40-80% | 25-180 | (A), costo grezzo sul bordo |
| **XAUUSD M1 (ancora)** | — | — | **158 esatti** | rifà S0_01 al centesimo |

**Regola congelata del piano 5.3** (letterale): *"passa allo stadio B solo (simbolo, TF) con mediana >= 40x (S2 PASSA) e n >= 30 segnali in T1; una cella FRA si può misurare per capire ma non può diventare sedia."* Lettura scritta ora (decisione D1): mediana = S2 del file madre **sugli ingressi**, riga *solo spread* (commissione indici = 0 misurata); n = ingressi del report.
Regime: **uno solo** (lug-set 2026). Lati: il lettore stampa BUY e SELL separati. Taglia: 1,00 lotto ≠ 100 oz → cifre in EUR non confrontabili con l'oro, PF e stop/spread sì.

## 4. 🧪 I contro-esempi costruiti prima (e quelli già girati oggi)
1. 🔴 **Il costo sugli ingressi NON può smentire nessuna attesa del piano** (trovato preparando il lotto). Con il filtro 0,05 ogni ingresso ha spread ≤ 0,05 × ATR ⇒ stop/spread ≥ **50x per costruzione** (R1A: p10 51,3). La riga *solo spread* del lettore dà ≥ 50x su **qualunque** simbolo: le attese 5.3 ("argento < 13,3x", "D30/U30 M5 FRA") sono sui **segnali grezzi** e su quella riga sarebbero "smentite" per costruzione. Quindi nei file: S2 sugli ingressi per la porta (CE3 = controllo di parsing: quota < 40x deve essere 0%), costo grezzo come **descrizione** con lo strumento dichiarato (rapporto delle mediane ATR/spread per fascia, righe (6) del lettore). ✏️ **Corretto dal cancello (12/10, classe 1104 b)**: le righe (6) danno **sei** rapporti, uno per fascia, mentre attese, smentite e frase "FRA sui segnali grezzi" parlano del costo grezzo **della cella**. Senza una regola scritta prima, sei fasce che cadono a cavallo della soglia (sull'oro vanno da 10,6x a 37,0x) permettevano di scegliere DOPO quale fascia "conferma". Regola ora nei file (blocco L3): **mediana ponderata per n dei rapporti per fascia** (oro S0: **19,5x**, FRA, come il proxy 21,6x); restano fascia per fascia solo "ESCLUSA PER COSTO" e la smentita dell'argento. ✏️ **Corretto al secondo giro (12/10, classi 1369 e 1104 b)**: *"< 13,3x in OGNI fascia con >= 100 segnali"* era vera **a vuoto** quando nessuna fascia arriva a 100 segnali (storia M1 parziale, pochi segnali) e diceva "ESCLUSA" anche con **una sola** fascia a 100 sotto soglia e la cella a 45x (provato con la regola scritta: entrambi i casi uscivano "ESCLUSA"). Ora "ESCLUSA PER COSTO" chiede tutte e tre: **almeno una** fascia con >= 100 segnali, **ognuna** di esse sotto soglia, **e** il costo grezzo della CELLA sotto soglia (13,3x indici, 6,65x argento); altrimenti "n insufficiente". La smentita dell'argento scatta anche sul costo grezzo della CELLA >= 13,3x.
2. 🔴 **n = 0 rompe la lettura dell'argento**: il driver mette KO una passata con ZERO operazioni (r.816) e il lettore la scarta (G0). **Provato su zip finto**: il lettore stampa lo stesso i conteggi `[GBA-CONTA]` nella riga (2) (segnali, scartati spread, posizione aperta), ma **non** le righe (6): il costo grezzo dell'argento resterebbe NON MISURATO. Scritto come eccezione negli ESITI (n = 0 non è un guasto) e come decisione D2.
3. 🔴 **Il lettore non verifica il simbolo** (difetto L7): uno zip finto con i deal, il giornale e il report **veri dell'oro** (S0_01) sotto l'etichetta R2SXAG M15 viene stampato come `CELLA M15 [lotto R2SXAG] … XAGUSD M15`, G0 OK, coi numeri dell'oro. La guardia è il driver (report di un altro simbolo = KO, r.806) e, in lettura, **la firma dello spread** (oro 0,17-0,25 USD per fascia: una cella di un altro simbolo con quella firma = letta come oro, non si usa).
4. ✅ **Ancora R2SANC = S0_01**: l'ini generato dal codice vero del driver (pwsh) è **identico** all'ini archiviato di S0_01 salvo il nome del Report; lo zip finto dell'ancora letto da solo ridà n=158, solo spread 55,9x, commissioni −548,50, PF 0,86, e `6973 = 158 + 6520 + 295` (CE4); caricato con `GBA_R0_S0.zip` il lettore si **ferma per doppione** (prova d'identità A3). Attesa sul giro vero: identico al centesimo. Perché 55,9x e non 58,8x: 58,8x è R1A a tick reali, l'ancora è a Modello 1.
5. ✅ **Il driver rifiuta le celle sbagliate** (parsing vero del driver v5 eseguito con pwsh): cella M1 col valore del pin non chiamata REPL, cella con una seconda variabile (`InpSymbol` in cella), `InpSignalTF=0`, `InpSymbol` vuoto, magic 775801, conteggi del blocco `@GBA-ASSE` sbagliati, lotto `R1A` riservato → **tutti fermati**. Gli ini delle 9 passate differiscono da S0_01 **solo** in `Symbol`, `Period`, `InpSymbol`, `InpSignalTF` e nome del Report.

## 5. 📖 Il lettore su un simbolo diverso dall'oro (difetti, nessun lettore nuovo scritto)
`leggi_gba_r0.py` legge i lotti dichiarativi con qualunque simbolo/TF (intestazione con simbolo e TF). Valori cablati per l'oro, cercati nel sorgente:
- **L1** righe costo `+0,04/+0,08 USD/oz` = commissione dell'oro (`COMM_USD_OZ`, r.44): sugli indici sbagliate di unità (trascurabili), sull'argento ≈ quanto lo spread → si legge solo *solo spread*.
- **L2** costo sugli ingressi ≥ 50x per costruzione (contro-esempio 1).
- **L3** la mediana del campo `stop/spread` che l'EA scrive a piena precisione in ogni riga segnale **non è stampata**.
- **L4** ATR e spread delle righe segnale a 2 decimali (EA `%.2f`): sull'argento ±25% per mediana.
- **L5** PF_V sottrae 3,90 EUR/lotto (commissione dell'oro, r.42) se il tester non addebita commissioni: sugli indici (commissione vera 0) distorce al ribasso. **Da togliere prima dello stadio B.**
- **L6** le sei fasce S6 sono quelle dell'oro: sugli indici solo descrizione.
- **L7** simbolo/TF presi dal manifest e dall'ini, mai confrontati col report (contro-esempio 3).
- `leggi_gba_uscite.py`: 100 oz cablati (r.161, r.172) → non applicabile. `leggi_gba_notti.py`: solo lotti notte → non applicabile.

**Comandi di lettura** (dopo il giro, col lettore passato `9CD02D2A…`):
```
python3 -I backtest_pipeline/leggi_gba_r0.py GBA_R0_R2SANC.zip
python3 -I backtest_pipeline/leggi_gba_r0.py backtest_pipeline/risultati_archivio/GBA_R0_S0_20261010/GBA_R0_S0.zip GBA_R0_R2SANC.zip   # DEVE fermarsi: doppione
python3 -I backtest_pipeline/leggi_gba_r0.py GBA_R0_R2SXAG.zip GBA_R0_R2SNAS.zip GBA_R0_R2SD30.zip GBA_R0_R2SU30.zip
```

## 6. ✅ Controlli eseguiti il 12/10 (nel worktree, nessuna macchina MT5)
- `controlla_prova.py` sui 5 file prova: **ESITO OK**, 0 problemi. `controlla_riga.py --oggetto prova`: nessun difetto meccanico, ASCII puro.
- `controlla_riga.py --oggetto riga` sulla riga: 7 PASSATI, **1 BLOCCANTE atteso** (`[PIN]` segnaposto). Stessa riga con un pin vero (HEAD del worktree, solo prova): **8 PASSATI, nessun difetto meccanico**; restano i 4 rilievi "da leggere a mano" identici alle righe modello (nomi dei conti nella lista dei NON toccati).
- (strato 2, 12/10, pin `a2406def`) riga col pin vero + driver: **14 PASSATI, nessun difetto meccanico**; SHA dei 5 file prova, del driver v5, dell'EA e dell'include ricalcolati dal commit = quelli della riga; ini dell'ancora identico a S0_01 salvo il Report; zip finto dell'ancora: n=158, solo spread 55,9x, −548,50, doppione con `GBA_R0_S0.zip` → ERRORE. Unico difetto: classe 1104 b (sopra, §4 punto 1), corretto nei file prova → **SHA nuovi, pin da rifare**.
- (strato 2, secondo giro, 12/10, pin `b68faae7`) riga col pin vero + driver: **14 PASSATI, nessun difetto meccanico**; SHA dei 5 file prova (`4B134B37…`/`89A95A41…`/`AA506CD7…`/`044DC666…`/`02FEE0F4…`), driver `C239F628…`, EA `1381E3DC…`, include `3EC97115…`, lettore `9CD02D2A…` ricalcolati dal commit = quelli della riga e invariati dal primo giro; pin antenato di `origin/lavoro`; la correzione del primo giro AGGIUNGE solo il blocco L3 (attese e smentite non toccate). Mediana ponderata ricalcolata sulle righe (6) di S0 = 19,48x. Difetto: "ESCLUSA PER COSTO" vera a vuoto / su una fascia sola (sopra, §4 punto 1), corretto → **SHA nuovi, pin da rifare**.
- Parsing e `TestoIni` del driver v5 eseguiti con pwsh sui 5 file: 9 passate, simbolo/TF/modello/tetto attesi, righe AVVIO attese stampate. Contro-esempi del §4 punti 2-5.

## 7. ⚪ Cosa NON è stato verificato
- Che i simboli `XAGUSD`, `NASUSD`, `D30EUR`, `U30USD` siano nel Market Watch del terminale del PC di backtest e che la storia **M1** di T1 2026 sia scaricabile (i nomi sono quelli BCM usati nei round del repo, es. `R103_ABTG_CostToCost_XAGUSD`, `R183b_…_NASUSD`; la storia M1 dell'argento sul PC è `[NON MISURATO]`, `NIGHTLY_SEI_SIMBOLI` r.415). Se manca, il driver mette KO la passata col motivo.
- Che `1,00` lotti sia ammesso sui quattro simboli (CE5: l'EA lo dice in giornale se lo riduce).
- Lo spread del Modello 1 sugli indici e sull'argento rispetto al vivo (sull'oro: 55,9x contro 58,8x a tick reali).
- Che le barre M1 dell'argento in T1 stiano sotto il tetto di 100.000 (oro T1: 88.416; il driver avvisa sopra 95.000 e fa KO sopra 100.000).
- Il giro vero: niente è girato su MT5 da qui.

## 8. 🙋 Decisioni aperte
- **D1 (metodo, prima dei numeri)**: la porta dello stadio B legge S2 **sugli ingressi** (file madre, scelta di default nei file: con il filtro 0,05 diventa di fatto n ≥ 30, come per la REPL dell'oro: grezzo M1 21,6x FRA, ingressi 58,8x PASSA) oppure **sui segnali grezzi** (intento del piano §5.2; servirebbe D2)? Con la prima vanno allo stadio B fino a 6 celle indice (18 passate), con la seconda fino a 4 (12).
- **D2 (lettura, prima di aprire lo zip)**: il costo grezzo per fascia esce dal lettore passato solo come rapporto di mediane e **solo con n ≥ 1**. Per misurarlo davvero (mediana del campo `stop/spread` di tutte le righe segnale, anche con n = 0, per lato) serve una piccola aggiunta al lettore, da passare dal cancello **prima** di aprire lo zip — oppure si accetta "costo grezzo NON MISURATO" per le celle a n = 0 (probabile sull'argento). ✏️ **Dal terzo giro D2 non è più facoltativo per "ESCLUSA"**: la L3 sottostima di 14,6% sull'oro (19,48x contro 22,80x, S0_01) proprio verso l'esclusione, quindi **senza lo strumento D2 nessuna cella esce "ESCLUSA PER COSTO"** (esce "n insufficiente" con la L3 come descrizione). Lo strumento deve leggere da `log\GBA_<passata>.txt` il campo `stop/spread` (escludendo e contando le righe a −1.0x), lo `spread` e l'`ora server`, e stampare il C3G della cella e delle sei fasce del lettore, ciascuna col suo n. Prova d'accettazione già scritta: su S0_01 deve dare **22,80x** sulla cella e asia 19,80 / europa 24,50 / pausa 26,20 / USA apertura 39,20 / USA pomeriggio 20,60 / rollover 10,65x.
- **D3 (stadio B, non ora)**: togliere L5 dal lettore; scegliere le tranche (le tre del 2026 del piano, oppure tutto lo storico indici dal 2024.09.26 per la regola dei due lati + storico lungo del 25/08).
- **Per Claudio**: solo il via al giro (nessuna spesa, ~12 minuti sul PC di backtest, nessun conto reale, nessuna taglia).
