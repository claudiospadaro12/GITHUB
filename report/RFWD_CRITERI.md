# RFWD -- le sedie FTMO rigiocate nel tester: criteri, attese e ipotesi, scritti PRIMA dei numeri

Data: 30/09/2026. Stato: **congelato, nessun numero del tester visto**. Materiale pinnato al commit
`79cbb8d2851745e80b7f7a3a8b387cd348f26d82` (7 file prova `backtest_pipeline/prove/RFWD_*.txt`,
`backtest_pipeline/confronto_forward_tester.py`, il forward `data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx`
e il driver `RIGA_ROUND_VPS.ps1` approvato). Questo documento e' committato dopo il pin e prima di qualunque risultato.
La riga di lancio e' `backtest_pipeline/righe/RIGA_ROUND_RFWD.txt` (solo PC di backtest DESKTOP-H4D7CAJ, [NON LANCIATA]).

Non promuove niente, non propone nessuna taglia, non tocca preset, EA, sedie, conti. Nessun PF.

---

## 1. La domanda, una sola

> Le sedie FTMO 541452707, rigiocate nel tester sui dati BCM negli stessi giorni, fanno le STESSE operazioni che hanno
> fatto nel forward?

Serve a separare **"campione corto / mercato"** da **"orari, feed o codice FTMO diversi dal backtest"**. Caso guida: la `770411`
MaxMin DAX short ha fatto 3 posizioni in 7 giorni feriali (24/09 -1.668,46 · 29/09 +968,37 · 30/09 -1.535,91) e un sell stop
cancellato il 25/09, contro ~0,03 (`FTMO_PRIMI_OTTO_GIORNI par. 2.3`) o 0,051 (`CONTRATTI_DELLE_SEDIE par. frequenze`) posizioni/giorno
del contratto OOS: il forward e' 8-14 volte sopra.

Logica della separazione: **stessi giorni di mercato** in tester e forward. Se il tester rifa le operazioni del forward, quello che
il forward mostra non dipende da dati, orari o codice FTMO (dipende dal mercato o dal contratto). Se il tester NON le rifa, qualcosa
di FTMO-specifico (o di tester-specifico) c'e'. Se il tester fa operazioni dove FTMO non ne ha fatte, la differenza sta nel forward.

## 2. Cosa il tester puo' dire e cosa NO -- i limiti di costruzione

### 2.1 Il per-trade ha SOLO le uscite (verificato sul sorgente e sui file d'archivio)

Tutti e sei gli EA esportano `close_time;symbol;magic;position_id;deal_type;volume;price;net_profit`, **una riga per deal di uscita**
(`ExportTrades`, filtro `DEAL_ENTRY_OUT`). Quindi:

- **NON c'e' ora ne' prezzo d'ingresso.** Il compito chiedeva abbinamenti sull'ora e sul prezzo d'INGRESSO: non sono realizzabili.
  L'abbinamento si fa sulle **uscite** (ultima gamba: ora; prezzo medio ponderato delle gambe).
- **Gli ordini pendenti che non si riempiono non lasciano nessuna riga.** "Piazzati/scaduti/cancellati nel tester" e' NON OSSERVABILE.
  Il confronto elenca i pendenti del forward e scrive "nel tester NON OSSERVABILE". Un giorno con soli pendenti scaduti nel forward
  e zero posizioni nel tester e' **coerente ma non falsificabile**.
- Il per-trade e' UNO per magic e la passata OOS sovrascrive la IS: cio' che resta e' la finestra OOS (vedi 2.2).

Per avere ingressi e pendenti servirebbe un secondo canale (un test singolo con giornale del tester, modello
`righe/PASSATA_TRAILFIX.ps1`): **non costruito, non realizzabile qui senza toccare gli EA o scrivere un driver nuovo**. Detto in chiaro.

### 2.2 Deviazioni dal compito (dichiarate, con la ragione)

| compito | fatto | ragione, misurata |
|---|---|---|
| `@FINOA 2026.09.30` | `@FINOA 2026.10.01` | il tester tratta la data di fine come **ESCLUSIVA** (in casa: `prove/TRAILFIX_*_pin.txt` "fine esclusiva", R250 "2026.06.30 = ultima 06.29", e l'ultimo per-trade di R271 e' il 25/06 con FINOA 30/06). Con 09.30 il 30/09 non ci sarebbe, e il 30/09 ha lo stop pieno -1.535,91 della 770411 |
| `@DAQUANDO 2026.09.22` | `@DAQUANDO 2026.09.14`, `@FRAZIONEIS 0.38` | il driver fa SEMPRE due gambe IS/OOS e il per-trade di un magic e' sovrascritto dalla seconda: la finestra che interessa deve essere la **OOS**. IS = 14-20/09 (riscaldamento, fine esclusiva), OOS = 21/09-01/10 esclusa = giorni del forward. Meta = 14/09 + floor(17 x 0,38) = 20/09 |
| finestra 22-30/09 | il tester gira dal 21/09; **il confronto ufficiale resta 22-30/09**, il 21/09 si riporta a parte | il forward ha ordini gia' il 21/09 (buy limit DAX 11:05, 4 sell limit US30): il primo giorno vivo non si butta, ma non entra in nessun conteggio |
| rischio "identico al preset" | `InpRiskPercent=2.00` come nel campo, **deposito 80000** (il conto FTMO) | il precedente `TRAILFIX_*_pin.txt` usava 1 e 100000 ("banco dei round"); qui si replica il forward. Non e' una taglia proposta |
| xlsx "generato 30/09 09:10" | l'ultimo evento del file e' il **30/09 10:03:09 FTMO** (=08:03:09 BCM) | l'ora di intestazione non e' l'ora dell'ultimo dato ([NON SPIEGATO], forse un altro fuso). Il taglio e' l'ultimo evento **+ 15 minuti**: un taglio secco scambierebbe per "oltre" la stessa operazione chiusa dal tester qualche minuto dopo (mondo A3) |

### 2.3 Chi era viva e quando

CODA_01 (03:30 di ogni notte) e i `.chr` (`CODA_08`): le sei sedie 770101, 770202, 770260, 771531, 770511, 770411 erano attaccate dal 21-23/09
(770411: c'e' nello snapshot del 23/09; il 22/09 non ha snapshot [NON MISURATO]); la **770105 e' nata il 28/09** (chart11.chr, `.chr` del 28/09 07:43,
CODA_01 del 29/09 03:30 la vede, quello del 28/09 no): il confronto la conta viva dal 28/09 (`viva_da`); il tester prima del 28/09 e' "sedia non ancora viva", non T_SOLO.

## 3. La versione del codice in campo (ricostruita, non presunta)

Il driver compila dal ramo `lavoro` **per NOME** (`walkforward_generico.ps1` r.264: `$EABranch="lavoro"`). Quindi la versione in campo si ottiene con una
copia sul ramo, non con `-Pin`. Ricostruzione, sei sorgenti:

| sedia | EA in campo | pin (SCHIERA_FTMO tavola) | righe pin (CODA_06 = +1) | impronta scheletro al pin | EA nel tester | relazione col campo |
|---|---|---|---|---|---|---|
| 770101, 770105 | `CLAU12_DAX_Apertura_EU` | `9fca63d9` | 2425 (2426) | `59B67F5F...` = tavola | `ABTG_DAX_Apertura_EU_Pin9fca` | **byte-identico** (impronta scheletro uguale, cmp) |
| 770202 | `CLAU12_Dow_Apertura_US` | `9fca63d9` | 2205 (2206) | `0BF7A1B3...` | `ABTG_Dow_Apertura_US_Pin9fca` | **byte-identico** |
| 770260 | `CLAU12_Nasdaq_Apertura_US` | `9fca63d9` | 2624 (2625) | `87BD4B18...` | `ABTG_Nasdaq_Apertura_US_Pin9fca` | **byte-identico** |
| 771531 | `CLAU12_EMA200` | `26a18566` | 552 (553) | `5CA99D90...` | `ABTG_EMA200` (HEAD, 690 righe) | pin **+ contatori IMBUTO** (solo `cX++` e `Print`, graffe attorno a `return`): equivalenza LETTA sul diff, non misurata |
| 770511 | `CLAU12_SuperWave_DOW_H1_Ottimizzato` | `872dba82` | 645 (646) | `3C487F28...` | `ABTG_SuperWave_DOW_H1_Ottimizzato` (HEAD, 774 righe) | pin **+ contatori IMBUTO**, come sopra |
| 770411 | `CLAU12_MaxMinNotte_DAX_Short_Ottimizzato` | `5fc0bc31` | 619 (620) | `B4A56E08...` | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | **HEAD = pin** (impronta scheletro uguale) |

Prove che questo e' il codice in campo (tutte rifatte qui, non ereditate):

1. l'impronta scheletro (CRLF->LF, solo ASCII stampabile) di ogni EA **al pin** coincide con la tavola di `righe/SCHIERA_FTMO.ps1` (6 su 6);
2. `CODA_06` del 30/09 03:30 su `C:\FTMO`: righe 2426/2206/2625/553/646/620 = pin + 1 (CODA_06 conta uno in piu', classe 456); versioni 1.01/1.01/1.02/1.00/1.01/1.10;
   `.ex5` dei `CLAU12_*` del **20/09 16:58**; le copie `ABTG_*` risultano ricompilate il 28/09 07:44 [NON SPIEGATO: i grafici (`.chr`) montano i `CLAU12_*`];
3. **la lista degli input della foto dei grafici vivi (`.chr`, CODA_08) coincide, nomi e ORDINE, con quella del sorgente al pin** per tutti e sei
   (82/81/98/43/44/52 input); il ramo differisce solo per `InpLogImbuto` (EMA200, SuperWave);
4. rimane **[NON MISURATO]** l'impronta del `.ex5` in campo (non si puo' leggere da qui) e la compilazione delle tre copie `_Pin9fca` col include del ramo
   (`ABTG_DAX_Apertura_EU_Pin9fca` & c. non sono mai state compilate: la prova `TRAILFIX` e' rimasta "compilazione [NON VERIFICATA]"). Il primo job che gira lo dice (rc 1).

**Include**: il campo ha `ABTG_PausaGuardian.mqh` v1.20 (398 righe, pin `26a18566`), il ramo v1.60 (2461 righe). I sei EA usano dall'include **solo**
`ABTG_GuardiaIngresso` (controllo statico, 0 funzioni mancanti; i tre `_Pin9fca` la chiamano con 2 soli argomenti, compatibili). Con `InpUsaGuardian=false` la funzione esce alla
prima riga: l'include non puo' cambiare un deal. Il Guardian del forward c'era (true) e **puo' aver rifiutato ingressi**: non misurabile dal tester (par. 6).

## 4. Le verifiche fatte sui file prova (`collaudo_riga_RFWD/genera_prove.py`, esito stampato)

Valori: dalla **foto dei grafici vivi** di `C:\FTMO` (CODA_08 30/09 03:30), non dai `.set`. Trasformazioni, tutte e sole: orologio FTMO->BCM (-2 h) sui soli input orari;
`InpUsaGuardian` true->false; `InpCorrSymbol` US500.cash->SPXUSD; `InpMagic` asse tecnico a due celle (gemelle per G1); vuoti non scritti.

- **V1** (foto - 2h) contro l'originale BCM del repo (`Presets/*_100K.set`, `sedie_piccolo/`): 770411, 770101, 770202 differiscono **solo per `InpRiskPercent`** (0,65 -> 2,00);
  770105 = 770101 con `InpAllowLong/Short` invertiti e magic; 771531 aggiunge `InpRiskPercent` e (assente nel campo) `InpLogImbuto`; **770260 differisce in `InpTP1_ClosePct` 0->50 e `InpBreakevenAtTP1` false->true**
  (preset FTMO deliberato, documentato nel suo `.set`: vale il campo); 770511 differisce per `InpRiskPercent` 1->2 e tre input che l'originale non ha.
  **Le ore -2 coincidono con l'originale BCM in 7 su 7.** L'esecuzione fallisce se una differenza non e' fra quelle ammesse.
- **V2** `.set` FTMO del repo contro la foto: 0 discordanze sui 5 completi; EMA200 (`InpLogImbuto` non nel campo) e SuperWave (3 input che il `.set` non porta) spiegati.
- **V3 orologio contro gli ORDINI VERI del forward**, 770411: i **4 sell stop** sono piazzati alle 09:59:00-09:59:01 FTMO = `InpPlaceHour:Min` FTMO (=07:59 BCM) e quello **cancellato** il 25/09 alle 10:30:00 FTMO =
  `InpEntryCutoff` (=08:30 BCM): controllo **esatto**, dimostra anche che l'ora dell'xlsx e' l'ora server dell'EA. DAX (770101/770105): i 6 buy limit sono tutti dopo apertura+range (10:35 FTMO) e i 2 scaduti
  scadono a +119,5 / +119,9 min (`InpPendingExpiryMin=120`): controllo **necessario, non sufficiente**. La prova forte e' la foto (`InpSessionHour=10`).
- **Numero di input** dei file prova (righe `Inp` incluso l'asse): 51, 81, 81, 42, 80, 97, 43. `controlla_prova.py` e `controlla_riga.py --oggetto prova`: OK su 7 su 7.

### 4.1 Riferimento LIVE-VS-LIVE (non e' tester, non e' un numero dei round: calibra le tolleranze)

`collaudo_riga_RFWD/riferimento_live_vs_live.py`: il 22 e il 24/09 le stesse sedie hanno girato anche sui demo BCM (`trades_100k.csv`, `trades_auto.csv`; il piccolo era spento dal 23/09 19:35 al 29/09,
il 100k ha il file fermo al 24/09: sovrapposizione utile solo 22 e 24/09). Sulle **4 posizioni FTMO confrontabili** (EMA200 x2 il 22/09, 770411 il 24/09, 770101 il 24/09): **4 su 4 L1**, scarto massimo di uscita **61 s**,
di prezzo **3,06 punti (DAX)** e **6,92 punti (US30)**. Casi in cui due feed vivi divergono: il 22/09 la 770101 sul BCM ha riempito alle 09:56:41 (uscita 11:13:45) mentre FTMO ha piazzato il limit alle 10:43 BCM e non e' stato riempito
(1 posizione BCM senza gemello FTMO); il 24/09 lo stesso setup ha riempito a 14:23:03 su BCM contro 14:35:18 su FTMO (12 minuti dopo), ma l'uscita e' entro 61 s.
Lettura: fra due feed VIVI lo stesso codice si riproduce quasi al secondo sulle uscite, con divergenze di **riempimento** dei limit del retest. E' il tetto ragionevole di cio' che un tester puo' fare.

## 5. Ipotesi, tolleranze, soglie, attese

### 5.1 Le tre letture (definizione operativa; il confronto le stampa da solo)

Unita': le posizioni FORWARD delle sedie in scope (oggi 11: 770411 x3, 770101 x4, 770105 x1, 771531 x3; 770202, 770260, 770511 = 0), finestra 22-30/09 (770105: dal 28/09), fino all'ultimo evento + 15 min.

- **H_FEDELI**: il tester riproduce le operazioni del forward: `L1+L2 >= 70%` dei forward **e** `L1 >= 50%` **e** `T_SOLO senza nessun ordine forward <= 25%` dei forward.
- **H_DIVERSI_ORARI**: le operazioni ci sono ma sfasate nel tempo: `L1+L2 >= 50%` **e** `L1 <= 20%` **e** mediana dello scarto orario delle coppie L2 `>= 45 min` (una firma di errore d'orologio di 1-2 ore).
- **H_DIVERSI_FREQUENZA**: `L1+L2 <= 30%` dei forward **oppure** `T_SOLO senza nessun ordine forward >= 100%` dei forward (il tester fa piu del doppio o molto meno).
- altrimenti **INCONCLUSO**. Le tre non sono esclusive: se ne scattano piu' di una il confronto scrive "SEGNALI MULTIPLI", non sceglie.

Livelli: **L1** stessa sedia + stessa direzione + ultima uscita entro **15 min** + prezzo medio di uscita entro **10 punti (DAX) / 25 (US30) / 15 (US100)**; ambiguita' sciolta SOLO per rango di volume (coppie S1/S2), altrimenti scende a L2.
**L2** stessa sedia + direzione + stesso giorno BCM, non L1. **F_SOLO** forward senza gemello. **T_SOLO** tester senza gemello (dentro finestra viva e cutoff); si divide in (a) giorno con un pendente del forward non riempito e (b) giorno senza ordini forward.
Esito di un'uscita: classe (`STOP` 1 gamba R<=-0,70 · `TRAIL_STRETTO` 1 gamba -0,70<R<0,30 · `TARGET_O_ALTO` 1 gamba R>=0,30 · `PARZ+RESTO_BASSO` 2+ gambe R<1,5 · `PARZ+ALTO` 2+ gambe R>=1,5 · `ORARIO` uscita entro 10 min dalla chiusura d'orario)
con **la stessa regola** su forward e tester; R **nominale** = netto / (rischio% x quota x saldo prima della posizione), quota 0,5 per EMA200 (rischio diviso fra due ordini). Tolleranza R **0,25**. Si stampano separatamente "stessa classe", "R entro tolleranza" e "entrambe".

### 5.2 Perche' queste tolleranze (e cosa NON e' misurato)

- **15 minuti** = una barra di gestione della sedia piu' lenta (M15 della 770411): un trailing su barre puo' spostare l'uscita di una barra. Il riferimento live-vs-live dice che il rumore osservato e' <= 61 s (15x sotto). L'ipotesi
  alternativa "orologio sfasato di 1-2 ore" atterra a >= 60 min: **4 volte fuori banda** (mondo B, sotto).
- **10/25/15 punti** = 3 x il massimo scarto di prezzo osservato fra feed vivi (DAX 3,06 -> 10; US30 6,92 -> 25); **US100 non ha nessuna coppia viva: 15 e' scalato per prezzo, [NON MISURATO]**. La base fra il feed BCM del tester e quello FTMO puo' essere diversa dalla base BCM-live/FTMO:
  il confronto stampa lo scarto di prezzo di ogni coppia, cosi' si vede se la tolleranza ha lavorato.
- R 0,25: il saldo del tester e' per-sedia, quello del forward e' di conto (con l'oro manuale dentro): scarto atteso di pochi centesimi di R (mondo A2: 0,00-0,05).

### 5.3 CONTROESEMPI costruiti prima dei numeri (`collaudo_riga_RFWD/mondi_controesempio.py`, 17 su 17 PASS)

Ogni mondo parte dal forward vero, convertito in ora BCM e scritto come per-trade:

| mondo | cosa e' | esito atteso, ottenuto |
|---|---|---|
| A | tester FEDELE (prezzo +3 punti) | 11/11 L1, H_FEDELI, niente altro |
| A3 | uscite +5 min (la 770411 del 30/09 cade dopo il taglio secco del forward) | 11/11 L1: il margine di 15 min serve |
| B | **orologio sfasato +60 min** | L1 = 0, NON H_FEDELI, H_DIVERSI_ORARI, mediana scarto = 60,0 min; l'uscita spostata oltre il cutoff e' ESCLUSA, non T_SOLO |
| C | tester VUOTO | L1+L2 = 0, H_DIVERSI_FREQUENZA |
| D | tester INDIPENDENTE (stesso numero di posizioni, giorni/ore a caso), 40 mondi | H_FEDELI **0 volte su 40** |
| E | gemello G1 diverso su una sedia | la sedia e' NULLA e esce dal conto (nF 11 -> 8) |
| F | tester DOPPIO (le vere + altrettante in giorni senza forward) | T_SOLO 10, NON H_FEDELI |
| G | 770105 il 23/09 (sedia non ancora viva); posizione il 21/09 | escluse, non T_SOLO; 21/09 = giorno di avvio, non contato |
| H | soglie contro il nullo (4000 permutazioni, seme 20260930): tester indipendente con nT = nF: L1 attesa 2% (p95 9%), L1+L2 37% (p95 55%); con nT = 2 nF: L1 4% (p95 18%), L1+L2 60% (p95 82%) | la soglia L1 (50%) sta sopra il p95 in entrambi; **la soglia L1+L2 (70%) sta sopra il p95 solo con nT = nF** -> da sola non discrimina un tester molto attivo: per questo H_FEDELI chiede ANCHE L1 >= 50% e T_SOLO <= 25% |

`P(sovrapposizione per pura sorte)` per la 770411 (D = 7 feriali; giorni forward con posizione 24, 29, 30 = 3), ipergeometrica esatta: se il tester avesse posizioni in `k` giorni a caso,
`P(>=3 su 3 in comune)` = 0,000 (k<3), 0,029 (k=3), 0,114 (k=4), 0,286 (k=5), 0,571 (k=6); `P(>=2)` = 0,143 (k=2), 0,371 (k=3), 0,629 (k=4), 0,857 (k=5). **Solo "3 su 3 con un tester che apre in 3 giorni" e' distinguibile dal caso a p<0,05; 2 su 3 no.**

### 5.4 Etichetta per sedia (nessun verdetto, dice che cosa e' successo)

`RIPRODOTTA` (tutti i forward hanno gemello, L1 >= meta', nessun T_SOLO senza ordine forward) · `RIPRODOTTA CON ECCEDENZA` (idem, ma il tester ha posizioni in giorni senza ordini forward) ·
`PARZIALE` (>= meta' dei forward con gemello) · `DIVERSA` · **`FORWARD MUTO`** (il tester apre dove FTMO non ha aperto niente: la differenza e' nel FORWARD) · **`TESTER MUTO`** (FTMO ha aperto, il tester no) · `ZERO CONTRO ZERO` (coerente, **non falsificabile**).
Per le sedie a zero forward il confronto stampa la frequenza del contratto e la **probabilita' di zero per pura sorte (Poisson)**: 770202 (0,348/g) attese 2,4 posizioni in 7 giorni, P(0)=0,088; 770260 (0,360) 2,5, P(0)=0,080;
770511 (~0,294, stimato) 2,1, P(0)=0,128; 771531 (0,931) 6,5 attese, forward 3, P(0)=0,001; 770101 (0,699) 4,9 attese, forward 4; 770411 (0,051) 0,4 attese, forward 3. Le tre sedie US con zero forward hanno **insieme** una
probabilita' di zero per sorte di ~0,1% se indipendenti (sono correlate dal regime USA: e' un limite dichiarato): il tester dice se e' regime (zero anche li') o FTMO-specifico (il tester apre).

### 5.5 La 770411, caso per caso (cosa significano 0, 1, 2, 3 riproduzioni a L1)

| riprodotte (L1) | lettura |
|---|---|
| **0** | il tester NON rifa nessuna delle 3 posizioni: ramo "orari, feed o codice diversi" (H_DIVERSI), salvo giorno senza dati (guardia storico) o file nullo. I pendenti del forward (4 sell stop) sono l'unica traccia di cosa FTMO ha armato |
| **1** | misto: non decide, si legge giorno per giorno (quale, e perche' le altre no) |
| **2** | in gran parte fedele; per quanto detto in 5.3 non basta a escludere il caso da sola: si guarda la terza e i T_SOLO |
| **3** | il tester rifa tutte e 3: la frequenza forward molto sopra il contratto OOS **non dipende da dati/orari/codice FTMO** ma dal mercato o dal contratto |

Contesto misurato: sui demo BCM la stessa sedia mostra 0,50 e 0,57 pos/giorno su 10 e 7 giorni; il 24/09 BCM-live e FTMO hanno entrambe aperto alle 08:02:04 BCM (25288,70 contro 25286,39) e chiuso a 20 s di distanza. **Il tasso alto non e' solo di FTMO.**
Sopra il tester: il filtro di correlazione della 770411 e' ACCESO (`InpUseCorrelation=true`, US500.cash su FTMO, SPXUSD su BCM): il feed dell'indice USA entra nella decisione, e il tester non lo toglie.

### 5.6 Attese scritte PRIMA dei numeri (e con la lettura alternativa)

Sono previsioni, non soglie. Le scrivo anche se sbagliano.

| cosa | previsione | perche' / alternativa |
|---|---|---|
| **770411** | mode 2 riprodotte; P(3)=0,30, P(2)=0,38, P(1)=0,24, P(0)=0,08 | il 24/09 BCM-live e FTMO coincidono (P L1 = 0,85); il 29 e il 30/09 non hanno un dato BCM (100k fermo al 24/09, piccolo spento fino al 29): 0,60 ciascuno. Alternativa: se il tester fa 0, la lettura e' H_DIVERSI e va cercato il perche' (correlazione? feed? storico?) |
| **770101** | il tester riempie il retest anche il **22/09** (dove FTMO ha lasciato scadere il limit): P=0,65; le 4 uscite forward hanno gemello entro 15 min: P(>=3)=0,65 | il 22/09 BCM-live ha riempito alle 09:56, FTMO ha armato alle 10:43 BCM: il tester, con feed BCM, dovrebbe seguire BCM. Se invece il tester segue FTMO, l'ipotesi "differenza di feed" cade |
| **771531** | le 2 uscite del 22/09 (stop pieni, stessa ora) riprodotte: P=0,80; la 25-28/09: P=0,60 | il piccolo BCM ha aperto e chiuso alla stessa ora al secondo il 22/09 |
| **770105** | 1 posizione il 28/09 riprodotta a L1: P=0,55 | una sola operazione: qualunque cosa sia, non decide da sola |
| **770202, 770260, 770511** | il tester apre **almeno una posizione** su 770202: P=0,70; su 770260: P=0,45 (filtro volumi); su 770511: P=0,55 | il contratto dice 2-2,5 posizioni attese in 7 giorni e il forward ne ha 0 (P(0)=0,08-0,13 per sorte). Se il tester apre, la differenza e' nel forward (Guardian, feed, griglia H4 del filtro EMA sul Dow, filtro volumi sul Nasdaq); se non apre, e' regime |
| **pooled** | H_FEDELI: 0,25 · INCONCLUSO: 0,45 · H_DIVERSI (una delle due): 0,30 | i T_SOLO delle tre sedie a zero forward possono da soli far cadere H_FEDELI (soglia 25% = 2 posizioni). Non e' un difetto: e' esattamente la domanda |

Sull'evoluzione: se il tester rifa il forward -> il gap forward/contratto della 770411 e' regime o contratto, non FTMO; se non lo rifa -> la prossima misura e' UNA sola per volta (correlazione SPXUSD/US500, poi orari, poi feed), non una griglia. Nessuna promozione, nessuna taglia, nessuna sedia toccata, in nessun caso.

## 6. Cosa NON si potra' concludere, e i confondenti (con la direzione in cui spingono)

- **Il tester non e' FTMO**: feed (GER40.cash/US30.cash/US100.cash contro D30EUR/U30USD/NASUSD), spread, slippage, volume dei tick, correlazione su un altro SPX. Non separabile qui.
- **Guardian**: nel forward c'era (`InpUsaGuardian=true`); nel tester no. Puo' aver RIFIUTATO ingressi: spinge verso "il tester fa di piu'" (T_SOLO). Non misurabile qui.
- **Rifiuti di modify di FTMO** (`report/MODIFY_A_RAFFICA_FTMO_2026-09-25.md`): il trailing PREVBAR M5 di DAX Apertura salta nel campo, non nel tester: spinge verso uscite diverse a parita' di ingresso (L2 senza L1).
- **Griglia H4 del filtro EMA della 770202**: BCM UTC+1 e FTMO UTC+3 hanno griglie H4 sfasate di 2 h su un passo di 4: la EMA(50) H4 non vale gli stessi numeri (`rimappa_preset_ftmo.py`). Non eliminabile.
- **Filtro volumi del Nasdaq** (giornale FTMO 29/09 17:26 locale: "rottura con volumi insufficienti, salto"): dipende dal feed.
- **Modello del sorgente**: EMA200 e SuperWave nel tester sono pin + contatori (equivalenza letta, non misurata); le tre copie `_Pin9fca` non sono mai state compilate col include del ramo.
- **Pendenti e ingressi del tester**: non osservabili (par. 2.1). Il 25/09 (sell stop cancellato dalla 770411) nel tester si vede solo come assenza di posizione.
- **Un solo regime** (estate, ora legale, una sola settimana), **11 posizioni forward**, 7 sedie: nessuna significativita' statistica vera; le probabilita' del par. 5.3 sono descrittive.
- **Saldo**: il tester ha il suo saldo per sedia; il forward ha quello di conto (con -2.502 dell'oro manuale del 28/09 dentro): R nominale, tolleranza 0,25.
- **Ora dell'ultimo dato**: il 30/09 e' parziale (ultimo evento 10:03:09 FTMO): il DAX del pomeriggio del 30/09 non e' confrontabile.
- **Clock d'inverno**: NON rilevante qui (il 25/10 e' dopo); il delta e' +2 in tutto il periodo.

## 7. Rischi operativi della corsa [NON MISURATO], dichiarati

- **Tempo**: 28 passate su finestre di 6-10 giorni, 10-25 minuti attesi con avvio/compilazione per job, **[NON MISURATO]**; tetto 60 minuti dall'avvio (i job rimasti si scrivono NON LANCIATI).
- **Tick BCM fino al 30/09**: il terminale deve scaricarli; R248 (25/09) arrivava al 18/09. Se non li ha il per-trade esce vuoto: un per-trade a zero righe **non e' dimostrato** "zero operazioni" senza la prova che la passata OOS ha girato:
  la riga richiede che il per-trade principale sia **piu' recente del CSV `_IS`** (scritto a fine gamba IS) e che il CSV `_OOS` sia fresco, altrimenti il job e' NULLO.
- **Passate a zero operazioni**: se MT5 non le elenca nel CSV (0 righe / 0 byte), l'unica prova che hanno girato e' il per-trade fresco e piu' recente dell'IS + le righe `OnTester result` del giornale dell'agente (informativo, attese 28). [NON MISURATO] come MT5 tratta le passate a zero operazioni.
- **`OnTesterInit works too long`** (R92b): questi round sono a UN simbolo e gli EA hanno un `OnTesterInit` banale; non dovrebbero avere quel problema, **[NON MISURATO]**.
- **Cache del tester**: un rilancio con gli stessi magic puo' ripescare passate gia' calcolate e non riscrivere il per-trade; la riga cancella i suoi file propri prima di ogni job e il per-trade mancante rende il job NULLO. Rilanciando, svuotare `Tester\cache`.
- **Python** sul PC: serve 3.8+; se manca la riga lo dice e raccoglie tutto (il confronto si puo' fare altrove). Il confronto legge l'xlsx **senza librerie esterne**.
- **Il terminale di quel PC e' loggato sul demo 50503392** e con `/config` carica il suo ultimo profilo, EA compresi (14/08/2026, ordini veri): la riga ha la guardia MT5 aperto e la guardia EA sui `.chr`.

## 8. Costanti (lette dal confronto: se questo blocco e il codice divergono, l'autotest FALLISCE)

```
RFWD_COSTANTI_BEGIN
TOL_TEMPO_STRETTA_MIN=15
TOL_PREZZO_DAX_PT=10.0
TOL_PREZZO_US30_PT=25.0
TOL_PREZZO_US100_PT=15.0
TOL_R=0.25
SOGLIA_STOP_R=-0.70
SOGLIA_TRAIL_R=0.30
SOGLIA_ALTO_R=1.50
FINESTRA_ORARIO_MIN=10
DELTA_ORE=2
SALDO_INIZIALE=80000.0
H_FEDELI_L2_MIN=0.70
H_FEDELI_L1_MIN=0.50
H_FEDELI_TSOLO_B_MAX=0.25
H_DIVERSI_L2_MAX=0.30
H_DIVERSI_TSOLO_B_MIN=1.00
H_ORARI_L2_MIN=0.50
H_ORARI_L1_MAX=0.20
H_ORARI_MEDIANA_MIN=45
RFWD_COSTANTI_END
```

Finestra ufficiale: `FINESTRA_UFFICIALE_DA = 2026.09.22`. Tolleranza di taglio del forward: `TOL_TEMPO_STRETTA_MIN` (15) dopo l'ultimo evento.
