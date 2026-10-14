# ANALISI LIVE EMILIANO - 14/10/2026 (mercoledi' mattina, ciclo C settimana 3: DAX in pre-apertura, ordine di Marco/Elena/Luca, "la direzione e' l'ORB", stop = ATR H1 + 4, ordini sfiorati, primo stop dopo mesi)

**Stato:** scheda dell'`analista-trascrizioni` del 14/10/2026. Strato 1 (`controlla_riga.py --oggetto md`) da rieseguire dal chiamante prima del commit; **strato 2 (`controllo-preventivo`) NON eseguito**: tocca al chiamante.
**Fonte unica:** `data/trascrizioni/LIVE_EMILIANO_14.10.26_2026-10-14_08-30-00-780.txt` (60.927 byte, 594 a capo = 595 righe in `cat -n`, TurboScribe, **nessun timestamp**; il nome del file **non** segue la convenzione `LIVE_EMILIANO_AAAA-MM-GG.txt` di SAPERE §8 punto 1: rinomina/duplicazione decisa dal chiamante, io non l'ho toccato). Letta **per intero, riga per riga**. A differenza del 12/10 le righe sono **corte** (paragrafi di 1-3 frasi): cito `r.N` = riga di `cat -n`.
**Data:** 14/10/2026 e' [INFERITO] dal nome del file e dal "CPI oggi" (r.17); la trascrizione non dice il giorno della settimana (il 14/10/2026 e' un mercoledi' per calendario: 12/10 era lunedi' nella live precedente). Il numero nel nome del file `08-30-00` e' presumibilmente l'inizio della registrazione, **fuso non dichiarato**: non converto.
**Metodo:** nessuna navigazione, nessuna integrazione da memoria. Dove cito il repo lo dico col file e **non ho rimisurato nulla**.

> ## REGOLA CHE VALE SOPRA TUTTO
> **Da questo materiale non si muove NIENTE.** Ogni numero qui dentro e' una dichiarazione di Emiliano o di un allievo: **[DICHIARATO DA LORO]**, non verificato, non e' un criterio, non e' un parametro, non e' una taglia. Nessun EA, preset, sedia, magic, conto (reale `10105439` compreso), Guardian, terminale o forward e' stato toccato. Le "ipotesi" sotto sono **specifiche scritte**, non file prova e non righe di lancio: passano dal cancello prima di esistere e i round girano **solo sul PC di backtest** (firma Claudio 21/09).

Etichette: **[TRASCRITTO chiaro]** (numero scritto e contesto lo conferma) · **[TRASCRITTO dubbio]** (puo' essere un errore dello speech-to-text o un livello detto a meta') · **[INFERITO]** (deduzione mia, dico da cosa) · **[INCERTO]** · **[DERIVATO]** (calcolo mio da numeri scritti) · **[LETTO nel repo: file]** / **[MISURATO nostro: file]** (numero nostro, preso dal file, non rimisurato) · **[NON MISURATO]**.

**Orari.** La trascrizione **non dichiara mai il fuso**. Frasi di orario: "tra cinque minuti" all'apertura (r.101), "mancano ormai un minuto" con conto alla rovescia (r.123-129), "un minuto e venti alla chiusura della candela dei 15 minuti per stabilire l'orb" (r.235): coerenti con un'apertura cash alle 09:00 ora italiana [INFERITO, non dettato]. Live futura "mercoledì alle 15" (r.555) e "dalle 15 alle 16.30" (r.559), apertura americana: **fuso non dichiarato, non converto**. "Andiamo a vedere Natalia, 23.15" (r.273): [TRASCRITTO dubbio], non e' un orario DAX plausibile ne' un prezzo (il DAX e' a 25.xxx): non lo uso.

---

## 0. La riga che conta

> **Su 1 trascrizione (595 righe): 26 gruppi di parametri con valore, 13 meccanismi, 6 bandiere (ZERO rosse, 5 arancioni, 1 ambra), ZERO regole prop, ZERO trucchi anti-prop, ZERO occorrenze di oro/GBA, di spread, di slippage e di EA da Market.** E' una live **operativa in diretta sul DAX** (strumento mai nominato: livelli 25.xxx, [INFERITO]) con allievi che rispondono (Marco, Elena, Luca, Giorgia, Consuelo) e un pezzo di analisi del proprio stop (r.351-375). **Il dato piu' utile per noi non e' una strategia: e' un numero che contraddice una nostra stima derivata**: Emiliano e Luca leggono l'**ATR(H1) del DAX a 37 e a 40 punti** (r.261, r.523) e l'ATR(M15) a 26 (r.263), mentre la nostra tabella di costo usa **ATR(14) M15 26,8 (coincide) e H1 53,6** (derivato con la scala sqrt(T), **mai letto con `iATR`**). L'H1 e' il TF da cui lui prende lo **stop = ATR + 4 punti = 41** (r.285). Se il 37-40 regge su 21 mesi, la riga H1 del nostro cancello di costo passa da "passa" a "escluso a BCM" (sezione 1, N1).
> **Il secondo pezzo e' una regola di direzione che rovescia la sua stessa cascata:** "weekly long, daily long ... da sicurezza" (r.115) in apertura, poi il long perde e a posteriori dice "È l'orb, la direzione è l'orb." (r.359) e "il D1 ormai è incerto ... una finta rottura" (r.397).
> **Niente qui e' un EA da copiare.** Tre pratiche sono da NON copiare (secondo ordine doppio come "unica operazione", stop allargato dopo l'ingresso, "rifarsi dei 300 euro con gli interessi"): sezione 8.

---

## 1. COSA C'E' DI NUOVO E INTERESSANTE PER I NOSTRI EA (max 6, ordinati per utilita' per una sedia schierabile alle prop)

(Tutte le frasi sono di **Emiliano** salvo dove scritto. Ogni "ipotesi" e' una **misura da fare**, non un criterio: attesa e smentita sono scritte **prima** dei numeri; i round girano sul PC di backtest.)

| # | cosa | fonte (frase, riga) | cosa dice il repo | IPOTESI misurabile |
|---|---|---|---|---|
| **N1** | **ATR(H1) del DAX letto a 37-40 punti, e lo stop e' "ATR H1 + 4 punti" = 41.** Contraddice una nostra stima derivata (53,6). | "Io personalmente utilizzo l'orario, l'H1." (r.261); "mi dice che sono 37 punti" (r.261); "se io l'avessi preso in M15, sono 26" (r.263); "l'ATR lo prendi in considerazione solo quando entra l'operazione" e "adesso è 37, magari tra poco sarà, non so, sarà 22" (r.263); "l'abbiamo messo esattamente a 41" e "preferisco aumentare di 4 punti lo stop loss" (r.285); Luca: "L'ATR ti dice 40 punti" (r.523) [TRASCRITTO chiaro tutti e quattro; lettura di UN mattino] | `APERTURE_DAX_MAPPA_2026-10-03.md` §3.2: ATR(14) M15 **26,8** [DERIVATO] (la sua lettura 26 **coincide**), H1 **53,6** [INFERITO: scala sqrt(T), "mai letto `iATR`"]; riga H1 "RANGE_FADE 1,5x ATR": **47,3x** su 1,70 (passa). Con ATR H1 37-40: 1,5x = 55,5-60 punti = **32,6-35,3x** su 1,70: **sotto la frontiera 40x** (stessa sorte della riga M30: "escluso a BCM, passa a FTMO"). Lo stop da 41 punti = **24,1x** su 1,70, 33,3x su 1,23, 30,8x su 1,33 [DERIVATO]: sopra il pavimento duro 13,3x, **sotto** 40x | **Lettura di `iATR(14)` H1 su D30EUR dalla cache M1 (Python, zero tester)**: ATR H1 alla barra delle 09:00 ora italiana (**orologio dichiarato**: d'estate = 08:00 server, d'inverno = 09:00 server; separare le due ere) e media di giornata, mediana e quartili su 21 mesi. **Attesa scritta prima (H0 = la nostra scala):** mediana alle 09:00 fra 50 e 57. **Smentita:** mediana fra 33 e 44 (ipotesi concorrente da r.263: l'ATR(14) H1 delle 09:00 include ~14 ore, cioe' la notte quieta, mentre l'ATR(14) M15 ne copre 3,5: stagionalita', non errore di Emiliano `[INFERITO]`). Esito = cosa si fa della riga H1 del cancello di costo. **Contro-esempio:** una lettura di un mattino non vale (lui stesso: 37 -> 22 "tra poco") |
| **N2** | **Ordini pendenti "sfiorati" e non presi: quattro episodi in una mattina piu' uno di ieri (3 punti); lui sposta l'ordine sul VWAP "perche' la seconda volta va oltre".** | "Poi, sfiorato per tre punti e lì per forza." (r.19, riferito a ieri; chi sia stato sfiorato e' [INCERTO]); "Mi ha sfiorato l'ordine, lo devo spostare" (r.275); "se la prima volta arriva lì, mi sfiora, non mi permette di gestire l'operazione come avrei dovuto gestirla, allora se ci va la seconda volta cosa succede? Va oltre" (r.277); "Mi ha risfiorato." (r.297); "Mi ha sperato l'ordine adesso." (r.427, "sperato" = sfiorato [TRASCRITTO dubbio]); "mi ha sfiorato nei limiti della notte" e "vuol dire che vanno messi giù" (r.471-473) | Regola di fill gia' in V07 (07/10 "metterlo sotto il numero tondo quando voglio essere fillato"); `InpRetestOffsetPts=200` (2 punti **dentro** il livello, "costa il 3,9% dei riempimenti") [LETTO nel repo via SAPERE V07, non rimisurato]. **Il demo non puo' vedere il problema:** 731 posizioni su 731 aperte **esattamente** al prezzo dell'ordine, zero slippage [MISURATO nostro: `report/MARKET_CLASSIFICA_2026-10-14.md` §5] | **Profondita' di penetrazione nei nostri fill (zero tester):** per ogni pendente RETEST eseguito (giornali delle sedie / tick), di quanti punti il prezzo ha attraversato il livello prima del riempimento. La quota con penetrazione < 1 punto e' la parte di backtest/demo che **un'esecuzione vera potrebbe perdere** (V47: BCM "salta gli ordini"). **Attesa scritta prima:** quota bassa (coerente col 3,9% gia' misurato); **smentita:** quota alta (soglia da congelare nel file prova **prima** di guardare, non qui). **Contro-esempio:** 5 episodi in 2 giorni di un discrezionale che opera anche in pre-apertura (spread piu' alto, V45) non descrivono ne' l'ora 08:00-09:00 server ne' le nostre sedie |
| **N3** | **La direzione non e' W/D: dopo la prima candela M15 "la direzione è l'orb"; il D1 "incerto" = finta rottura; la candela D1 che apre dentro una resistenza = lato short anche con W/D long.** | "noi quando mi apre all'interno di una resistenza, noi sappiamo che lì noi andremo short" (r.21); "ancora una volta vediamo che weekly long, daily long è cazzo da sicurezza" (r.115); poi "E l'errore va assegnato. Quindi dire, qua l'orb l'avresti dovuto prendere i short." (r.357); "È l'orb, la direzione è l'orb." (r.359); "il D1 ormai è incerto. Cosa ha fatto? Ha fatto uno spike, ha superato, quindi ha fatto una finta rottura" e "in H4 me lo mette short, in H1 è ovviamente short e quindi la direzione un po' mi è cambiata" (r.397) | V63 (apertura D1 vs EMA200 D1), V71 (direzione W/D batte l'ingresso, 09/10), V77/Q25 ("incerto" non definito): **risponde in parte a Q25** (un D1 e' "incerto" quando ha fatto uno spike oltre il livello e c'e' rientrato). Dow `770202`: filtro EMA H4 acceso PF 1,24/DD 6,9% contro spento 1,03/14,9% (altra configurazione) [LETTO nel repo via SAPERE V51]. DAX Apertura: filtro EMA spento. **Nessuna sedia usa il segno del primo M15 come filtro** | **Split ex post sui per-trade gia' esistenti di `770101`/`770105` (zero tester):** segno della candela 09:00-09:15 ora italiana (l'ORB a 15') concorde/discorde col lato del trade, in aggiunta alla cella D1 concorde/discorde di S1(a) del 05/10. **Attesa scritta prima:** nessuna differenza di PF oltre la banda di permutazione (la sedia entra comunque dopo i 35' di range: l'informazione e' in parte gia' dentro). **Contro-esempio:** n per cella < 150 => merito sospeso, si giudicano forma e rischio; due lati; regime dichiarato. Va fatto **per lato**: lui parla da discrezionale di UN giorno (n=1) |
| **N4** | **Ingresso solo alla conferma: "non appena apre sopra il livello" e' sbagliato, serve il superamento dei due massimi; ORB identificato in M15 e trigger sulla candela M3 che apre fuori con volumi crescenti.** | "il vero ingresso non lo devo fare appena apre sopra il livello, ma sopra questi due massimi, perché altrimenti rischio troppo" (r.57); "entro solo al superamento di questi due massimi" (r.59); "Aspetta che apra la candela in M3, andando a identificare l'Orb in M15" (r.193); "Io devo aspettare che mi apra il puletto sopra, con volumi crescenti, giusto? E se il VVAP è in direzione sono più contento." (r.167); "In pre-apertura in realtà non è buono fare queste cose" (r.51) | Mappa DAX §3.3: `InpOCTimeframe` misurato solo **M5 e M15**, "segno opposto con/senza volumi"; **M3 e' elencato come "tutto da fare"** [LETTO nel repo: `APERTURE_DAX_MAPPA_2026-10-03.md` §3.3]. V20/V10 (apre fuori), V09 (primo ostacolo: qui l'ostacolo e' a distanza zero) | **`InpOCTimeframe = M3` sul retest a range 35', per lato** (mai misurato). **Attesa scritta prima:** M3 non batte M5 (rumore: piu' trigger, stop piu' vicino, piu' costo). **Smentita:** cella M3 con PF >= quello di M5 in IS **e** OOS, n >= 150. **Costo prima di tutto:** M3 abbassa il ritardo ma non lo stop (lo stop dipende dal range: mappa §3.1, nessun effetto sul 40x). Giro di tester su PC di backtest (costo [NON STIMATO]) |
| **N5** | **Uscita ancorata all'ATR: metà a 1 ATR(H1) (≈ 40 punti), metà a trailing sul "culetto" M3/M5; primi parziali al numero tondo e al VWAP.** E "stop in pari": errore dichiarato quando e' messo senza aver chiuso la metà. | Emiliano a Luca: "io metà la chiuderei da ATR, metà" (r.525); "mi aspetto che vada a due ATR" (r.533, ipotesi); Luca: "Se la candela è in direzione di trend, sposto lo stop profit sul culetto della candela." (r.539), "l'ho parzializzata tre volte, lo 02 lo lascio correre" (r.545); su se stesso: "avrei dovuto chiudere la metà e portare lo stop in pari. Invece ho messo solo stop in pari." (r.435-437); regola: "E i 20 punti cosa ti dicono? Porti a casa la metà e metti il coso in pari." (r.371) | Gia' in V33/V67 (parziale + BE). **Due misure nostre che non concordano:** R46a PF 1,49 senza parziale contro 1,40 con parziale 50% a 1R; FASE F BE al primo target 1,237 contro 1,164 [MISURATO nostro via SAPERE V33]. S1 del 09/09 (parziale ancorato a una frazione del target ATR) **mai misurato** | **S1 del 09/09 con l'ATR su H1:** TP1 50% a 1,0 x ATR(H1) invece che a 1R, sulla sedia che ha il parziale; vedi anche N1 (prima si legge l'ATR H1 vero). **Attesa scritta prima:** nessun miglioramento oltre la banda (R46a dice che il parziale costa PF). **Contro-esempio:** una live non riapre un cancello chiuso; **priorita' bassa**, dopo N1 |
| **N6** | **Dopo lo stop pieno (-300 EUR, "il primo stop che prendo dopo mesi") riarma gli stessi ordini sui minimi della notte e dice di volersi "rifare con gli interessi"; poco dopo dice all'allieva che le perdite non vanno compensate.** Cosa NON copiare e cosa contare. | "Se mi viene a prendere mi rifaccio dei 300 euro con gli interessi." (r.331); "le perdite non è che vanno compensate in pari" (r.425); "a me questo è il primo stop che prendo dopo mesi di live pazzesche" (r.373); "Sono all'interno del mio range di 1%, 2%, 3%?" (r.333: **non ho trovato un altro range di rischio per operazione** nel corpus: grep di "range di 1", "1%, 2%", "uno per cento" su `data/trascrizioni`, `docs/live_emiliano`, `docs/live_paolo`) | Idea gia' in PRIORITA ("dopo uno stop pieno sul DAX non si riapre sul DAX lo stesso giorno", V36, aspetta il SI di Claudio); `770101`/`770105`/`770411` hanno `InpOneTradePerDay=true`; cap C1 3,25% = 5 SL vivi da 0,65% [LETTO nel repo: CLAUDE.md]. Il suo "1-3%" a operazione e' 1,5-4,6 volte il nostro 0,65%: la taglia e' di Claudio | **Re-entry dopo stop pieno sul DAX (tester, PC di backtest, `InpOneTradePerDay=false` in un file prova):** PF e DD del **secondo** ingresso del giorno contro il primo, per lato. **Attesa scritta prima:** PF(secondo) <= PF(primo). **Smentita:** PF(secondo) >= PF(primo) con n >= 150 (improbabile: l'n dei secondi ingressi e' una frazione dei giorni, **merito sospeso per costruzione**, restano forma e rischio). Non e' una richiesta di cambiare il Guardian |

**Ordine per utilita' (perche'):** N1 cambia un numero del cancello di costo ed e' a costo di tester zero; N2 tocca la frequenza reale delle sedie RETEST vive; N3 e N4 sono filtri/trigger mai misurati sul motore che vive; N5 e' gia' una misura in lista; N6 e' soprattutto un avvertimento.

### Quello che NON c'e' (la lista che Claudio ha chiesto di evidenziare)
Conteggi `grep` sulla trascrizione grezza (parola intera dove sensato):
- **Oro / GBA / breakout di canale:** `oro` come strumento **0** (le due righe del grep sono "lavoro", r.199 e r.475), `gold` 0, `GBA` 0. **Nessun punto di contatto con `GBA_R2S_*`**: niente da confrontare, niente contraddetto. (L'ATR di cui parla e' sul DAX.)
- **Indici:** solo il **DAX** (mai nominato). Nasdaq 0, Dow 0 (i due "dow" del grep sono "lockdown", r.487, e "Download", r.575).
- **Slippage / spread / commissioni:** `spread` 0, `slippage` 0, `commission` 0. L'unico argomento di esecuzione e' l'ordine "sfiorato" (N2).
- **Regole prop:** `prop` 0, `FTMO` 0, `funded` 0, `challenge` 0. **Trucchi anti-prop: ZERO.**
- **EA da Market / griglie / martingale:** `martingal` 0, `griglia` 0, `raddopp` 0, `mediaz` 0, hedging (`hedg`, `eggi`, `ejami`) 0 come parola; `recuper` 2 (r.375, r.487), `senza stop` 1 (r.315, in forma di avvertimento). Nessun EA da Market citato. Gli unici "EA" sono due **utility** (sezione 4, M12): un "sistemino" per mettere lo stop in automatico, che lui dice di avere (r.317, [INCERTO] chi parla) o che chiede a Elena (r.465).
- **Orario/fuso:** nessun fuso dichiarato; nessuna parola su BCM, server, inverno, 26/10. Quindi **nessuna contraddizione con UTC+1 fisso**, ma neanche conferma.

---

## 2. Com'e' fatta la live (chi parla, cosa si vede)

| righe | contenuto | peso per noi |
|---|---|---|
| r.1-13 | saluti individuali, battute | zero |
| **r.15-61** | **analisi della mattina**: weekly long/daily long, CPI oggi, livelli, "se apre dentro la resistenza -> short", ordini pendenti, **ingresso long in pre-apertura**, chiusura rapida dello short, "il vero ingresso e' al superamento dei due massimi" | **alto** |
| r.61-87 | il prezzo e' partito ("mi è spugito il prezzo"), primo obiettivo numero tondo, stop sotto | medio |
| **r.89-135** | **Marco** espone il suo trade (long, stop sotto M15, target 400, parziale; uscito in pari all'apertura) | alto |
| **r.137-197** | ordini pre-apertura su VWAP H1, confluenze, **Elena** risponde "attendo l'ORB", scambio sul short a 400 | alto |
| **r.199-309** | ordini pendenti doppi (Elena, poi Emiliano), stop in pari, ATR H1 = 37, stop 41, ordine sfiorato spostato sul VWAP, fill | **alto** |
| **r.311-377** | **stop preso (-300 EUR)**, analisi dell'errore, "la direzione e' l'orb", Elena senza stop | **alto** |
| r.379-477 | CPI, retest dell'ORB short di Elena, "D1 incerto", ordini sui minimi della notte + VWAP H1, ordini sfiorati e spostati | alto |
| **r.479-549** | **Luca** condivide lo schermo: long a "286" sul supporto weekly, due lotti, tre parziali, ATR H1 40, trailing M3/M5 | alto |
| r.551-595 | logistica (workshop, orari delle prossime live), strumenti per trascrivere ("Clipto", "Video Download Helper"), saluti | zero (orari live sono logistica) |

**Chi parla** [INFERITO dai vocativi, la trascrizione non ha etichette]: Emiliano e' l'host; **Marco** (Mianulli, r.89-135), **Elena/"Ele"/"Ede"/"Erelina"** (r.159-217, r.311-465), **Luca** (r.483-549), **Giorgia** (r.239-249), Consuelo, Tommaso, Natalia, **Paolo** (entra solo a r.559 per la logistica). Il vocativo dice chi **ascolta**: dove la frase potrebbe essere di piu' voci lo scrivo.
**Strumento:** il DAX non e' mai nominato; livelli "25.400", "25 451", "286", "338" [TRASCRITTO dubbio le ultime tre cifre]: [INFERITO] DAX (coerente con la scheda del 12/10, 25.166). **Qualita' STT: media.** Storpiature riconosciute: "bubap/boobup/duvap/VVAP" = VWAP · "TR" = ATR (r.75, r.465-469) · "cannella/cadena" = candela · "preception/preseption" = zona di prezzo (mai definita, come in V56/Q23) · "migliando" = mediando (r.287) · "pistolino" = ? (r.283) · "dieci occhi" = dieci contratti? (r.289) · "orb" = ORB.

---

## 3. PARAMETRI CON VALORE (tutti [DICHIARATO DA LORO])

| # | parametro | valore | riga + citazione | etichetta |
|---|---|---|---|---|
| P1 | ATR(H1) DAX (Emiliano) | **37** punti | "mi dice che sono 37 punti" (r.261) | TRASCRITTO chiaro |
| P2 | ATR(M15) DAX | **26** punti | "se io l'avessi preso in M15, sono 26" (r.263) | chiaro |
| P3 | ATR(H1) DAX (Luca) | **40** punti | "L'ATR cosa ti dice in H1? 40 punti." (r.523) | chiaro (Luca) |
| P4 | stop del secondo trade | **41** punti = ATR H1 + 4 | "l'abbiamo messo esattamente a 41" (r.285); "preferisco aumentare di 4 punti lo stop loss" (r.285) | chiaro |
| P5 | TF dell'ATR dello stop | **H1**; "qualunque time frame va bene" se c'e' logica | "Io personalmente utilizzo l'orario, l'H1." (r.261) | chiaro. Periodo dell'ATR **non detto** |
| P6 | quando si legge l'ATR | solo all'ingresso | "l'ATR lo prendi in considerazione solo quando entra l'operazione" (r.263) | chiaro |
| P7 | stop sotto il minimo della notte | **83** punti, scartato | "quindi ha 83 punti" ... "Sono tantissimi." (r.345) | chiaro; il numero e' una distanza dall'ingresso del long sui minimi della notte |
| P8 | distanza tra i due ordini | 10 punti "troppo vicini"; circa 14; Elena 25 punti | "i 10 punti sono troppo vicini" (r.253); "lo metterei qua, circa 14" (r.227); "Sono distante 25 punti, mi sta bene" (r.203) | dubbio (chi propone cosa) |
| P9 | rapporto delle taglie | secondo ordine = **doppio** del primo | "Il doppio della size" (r.201); "il secondo, che è il doppio del primo" (r.253) | chiaro |
| P10 | taglie in contratti | 5 e 10 | "Io prima ho usato 5 e 10" (r.329); "con un ordine di 10 del doppio" (r.267) | dubbio: "sites che rappresentano pericolo" (r.329, STT) non si capisce |
| P11 | valore di un contratto | ≈ **1 EUR per punto** | "uno stop di 370 euro" con 37 punti e "dieci occhi" (r.289) | [INFERITO] 37 x 10 = 370; "occhi" = contratti [TRASCRITTO dubbio] |
| P12 | perdita sull'ultimo trade | **-300 EUR** | "ho preso 300 euro di stop" (r.323) | chiaro; **non riconciliabile** con 5+10 contratti e stop 41 (verrebbe 205-475 a seconda dei riempimenti) [DERIVATO]: non fidarsi |
| P13 | range di rischio per operazione | **1%, 2%, 3%** | "Sono all'interno del mio range di 1%, 2%, 3%?" (r.333) | chiaro (domanda retorica). Denominatore non detto |
| P14 | target prima del livello | **395-396** invece di 400 | "il target non lo metto a 400, lo metto a 396, 395, cazzo me ne frega di 5 punti" (r.109) | chiaro |
| P15 | parziale e obiettivi di Marco | parziale a 400; oltre, 440 | "targetizzo i 400 e lì parzializzo" (r.109); "andrebbe fino ai 440" (r.111) | chiaro (Marco) |
| P16 | parziale a 20 punti | metà a casa + stop in pari | "E i 20 punti cosa ti dicono? Porti a casa la metà" (r.371) | chiaro |
| P17 | parziale ad ATR | metà a 1 ATR(H1) ≈ 40; secondo target ipotetico 2 ATR | "io metà la chiuderei da ATR" (r.525); "mi aspetto che vada a due ATR" (r.533) | chiaro |
| P18 | taglie di Luca | 2 lotti, residuo 0,5, poi 0,2; "non entro con meno di un lotto" | "erano due lotti" (r.497); "non entro con meno di un lotto" (r.499); "lo 02 lo lascio correre" (r.545) | chiaro (Luca) |
| P19 | taglia di Elena | 1 lotto | "Con 1. Con un lotto? Ok, ottimo." (r.417) | chiaro (Elena) |
| P20 | livelli di prezzo | numero tondo 25.400; "SL al 25 451"; supporto weekly "286"; livello daily "338"; "83", "86", "75" | "numero tondo 25.400" (r.103); "un ordine SL al 25 451" (r.199); "quello che dicevamo prima, 286" (r.483); "livello daily sul 338" (r.541) | **dubbio** le cifre brevi (livelli a schermo) |
| P21 | movimento "sopra e sotto" | **100** punti | "100 punti se ne fatti, sopra e sotto" (r.383) | chiaro, ora del giorno non detta |
| P22 | residuo perso dal trailing | "circa 35 punti in meno" | "uscirai sì in profit, ma con circa 35 punti in meno" (r.549) | chiaro |
| P23 | guadagno dichiarato | "100 eurini" | "I miei 100 eurini li ho fatti." (r.205) | chiaro (vedi sez. 6) |
| P24 | live future | mercoledi' 15:00-16:30 (apertura americana); giovedi' mattina con Paolo al posto della serata (workshop); venerdi' mattina Emiliano | "faccio l'aperitura americana dalle 15 alle 16.30" (r.559); "giovedì mattina la faccio invece di quella di giovedì sera" (r.563) | chiaro; **fuso non dichiarato** |
| P25 | tempo dell'ORB | candela M15, chiusura "un minuto e venti" | "un minuto e venti alla chiusura della candela dei 15 minuti per stabilire l'orb" (r.235) | chiaro |
| P26 | EMA/medie | EMA200 **esponenziale** in H4; "media 100-200 in H1" | "mettiamo la 200 esponenziale" (r.17); "a cavallo della media 100-200 in H1" (r.337) | chiaro; ancoraggio VWAP e periodo ATR **non detti** |

---

## 4. MECCANISMI (come descritti)

- **M1 - Cascata e apertura D1.** Weekly e daily (r.15-17), poi la regola "quando mi apre all'interno di una resistenza ... andremo short" (r.21), "non posso entrare adesso, perché starei azzardando" quando il contesto e' long (r.21). Vedi N3.
- **M2 - Conferma prima dell'ingresso.** "aspetto che ci sia un setup tipo una doji e una candela che mi conferma lo short" (r.55); "L'ingresso log, solo alla conferma di un setup" (r.57); superamento dei due massimi (r.59).
- **M3 - ORB.** Box = candela M15 (r.235); "Faccio la strategia dell'Orb per vedere qual è la direzione reale del mercato" (Elena, r.161, approvata); trigger su M3 (r.187-193); "È l'orb, la direzione è l'orb" (r.359); retest dell'ORB come ingresso (r.395).
- **M4 - Ordini pendenti doppi intorno al VWAP.** "è corretto metterlo prima e dopo il bubap" (r.291); stop "sotto il duvap" (r.267, r.279); due ordini = "la stessa operazione" (r.291), "non sto migliando il prezzo" (r.287).
- **M5 - Spostare l'ordine sfiorato** (r.275-277, r.471-473). Vedi N2.
- **M6 - Stop.** ATR H1 + 4 (N1); stop sotto il minimo della candela M15 "per far respirare" (r.99, r.233: "per far respirare"); stop sotto il VWAP (r.267); "Mi do un po' più di respiro" (r.301: **allarga lo stop dopo il riempimento**, direzione [INFERITA]).
- **M7 - Uscita.** Target davanti al livello (395-396); parziale; trailing sul culetto della candela M3/M5; metà a 1 ATR (N5).
- **M8 - Re-entry.** "sui retesti dei massimi della notte posso tentare l'ingresso con lo stop subito sotto il minimo della cadena" (r.251); dopo lo stop, ordini sui minimi della notte con VWAP H1 (r.427-441); "ordini sicuri" (r.429), "se dovesse rompere i minimi della notte me lo aspetto in sicurezza qua" (r.477).
- **M9 - Analisi dell'errore dopo lo stop.** "E l'errore va assegnato." (r.357); "Lo so che ho fatto un errore." (r.355); ammette: non ha parzializzato (r.361-363); "ci sono stati fatti dei errori" (r.363, con Elena).
- **M10 - Pre-apertura.** "Siamo in pre-apertura, siamo in condizioni disciplinari" (r.57) ma "in pre-apertura in realtà non è buono fare queste cose" (r.51); Marco: "prima dell'apertura, di solito non entro mai" (r.105).
- **M11 - Notizie.** "oggi c'è il CPI" e "potrebbe essere un mercato attendista" (r.17); "vediamo se riesco a fare il CPI. Non ve lo do come garantito." (r.579): **nessun ordine cancellato per il CPI** in questa live, nessuna regola di news.
- **M12 - Utility di stop automatico.** "Crei un sistemino ... che quando non metto lo stop me lo mette lui" (r.317, [INCERTO] chi parla); "Mi aspetto che entro due giorni tu mi prepari un sistemino ... che ti mette lo stop in automatico. Ma fattelo mettere con la TR" (r.465), "La TR esprime la volatilità media che ha la candela in H1" (r.469). Convergenza con il nostro design (SL sempre presente, ATR), **non indipendente**: il corso e' la fonte di molte nostre manopole.
- **M13 - Short e long contemporanei per pochi minuti.** "adesso io mi porterò a casa sia lo short che il long" (r.39), "Adesso lo short me lo chiudo veloce" (r.41): due posizioni opposte aperte insieme sullo stesso strumento [INFERITO da r.37-49; il termine hedging non e' usato]. Vedi B32.

---

## 5. REGOLE PROP CITATE

**Nessuna.** `prop`, `FTMO`, `funded`, `challenge` = 0 (grep). Nessun limite giornaliero, nessuna perdita massima, nessun obiettivo di profitto di conto. L'unico numero di rischio e' il "range di 1%, 2%, 3%" a operazione (r.333, P13), detto come autoverifica del proprio piano, senza dire di quale conto. **Trucchi per aggirare le prop (randomizzazione, copy mascherato, aggiramento divieti): ZERO.** (Per la regola di casa, se ci fossero: intelligence, VIETATO PER NOI.)

---

## 6. NUMERI DI PERFORMANCE (tutti [dichiarato, NON verificato])

- "I miei 100 eurini li ho fatti." (r.205) · "la somma di tutto è positiva" (r.281, detto **prima** dello stop) · "ho preso 300 euro di stop" (r.323) · "a me questo è il primo stop che prendo dopo mesi di live pazzesche" (r.373) · "300 euro me li posso recuperare in un secondo" (r.375).
- **Risultato netto della giornata: NON detto.** Dopo lo stop riarma ordini che, nel finale, risultano sfiorati e spostati (r.427, r.471-475): esito non riportato.
- Elena: "ho 30 punti" (r.415, [TRASCRITTO dubbio] di chi). Luca: "Adesso ho fatto 40 punti" (r.527); "il livello daily sul 338" come obiettivo (r.541).
- Marco: uscito "in pari" all'apertura (r.135).
- Enfasi senza numeri: "la migliore lezione che ho fatto negli ultimi vent'anni" (r.489), "solo i pro potevano vederla" (r.409), "oggi soltanto un pro poteva capire, intuire che poteva andare short" (r.433). **Nessun campione, nessun PF, nessun win rate, nessun drawdown.**

---

## 7. OCCORRENZE SULLE VOCI ESISTENTI (cosa e' ripetizione)

(Tutte [DICHIARATO DA LORO]; stesso coach = una sola fonte. Le voci rimandano a `docs/SAPERE_LIVE_PER_EA.md`.)

| voce | occorrenza 14/10 | cosa cambia |
|---|---|---|
| V01 / V03 / V65 | "sui retesti dei massimi della notte posso tentare l'ingresso" (r.251); ordini sui minimi della notte + VWAP H1 (r.429-441) | ripetizione; **nuovo:** i massimi/minimi della notte come zona di **re-entry dopo stop** (V91) |
| V06 | "ha fatto il retest dell'Orb" (r.395); "Un retest potrebbe essere?" (r.19) | ripetizione |
| V07 / V66 | target a 395-396 invece di 400 (r.109); ordine sfiorato spostato (r.275) | **estende** la regola di fill con 4 episodi (N2) |
| V09 | "Ma questo non è il mio primo ostacolo." (r.45); "C'ho un ostacolo subito, subito, subito vicino." (r.169); "Se trova il primo ostacolo una reazione la posso avere." (r.177) | ripetizione (ostacolo a distanza zero) |
| V10 / V20 | "Aspetta che apra la candela in M3, andando a identificare l'Orb in M15" (r.193) | **nuovo:** il trigger su M3 (N4) |
| V11 / V70 | "Non è che lo metto a casa di Dio." (r.75); stop ATR+4 (r.285) | stop **non** strettissimo: 41 punti (24,1x), non i 20 punti di V11 |
| V12 / V82 | "mettiamo la 200 esponenziale" (r.17); "c'è la media 200 in H4" (r.17); (r.19 ha "alla media 200, è un evento", frase spezzata [TRASCRITTO dubbio]) | EMA200 **H4** come livello d'ordine di ieri (25.450, dubbio): la nostra famiglia H4 e' `771511`-`771515` |
| V16 / V54 | VWAP H1 come livello d'ordine e come stop (r.139, r.267, r.279), obiettivo (r.295, r.437) | ripetizione; ancoraggio mai detto (Q33) |
| V19 | ORB = candela M15 (r.235) | ripetizione a 15' |
| V23 | "I volumi sono crescenti, sì." (r.43); "Bisogna stare attenti." con volumi crescenti (r.441) | ripetizione; **nessuna soglia** |
| V33 / V67 | "la regola è almeno porta a casa metà" (r.215) | ripetizione; **nuovo:** il costo operativo dello stop in pari (V90) |
| V34 | "anziché fare due terzi e un terzo, metto 5 cell" (r.227) | un altro valore (2/3-1/3) nella lista C11 |
| V35 / B03 | secondo ordine doppio (r.201, r.253) | ripetizione, ora con "non sto mediando" (C37) |
| V41 | 5 e 10 contratti; Elena 1 lotto; Luca 2 lotti | ripetizione |
| V44 | CPI (r.17, r.579) | ripetizione; nessuna regola sui pendenti |
| V45 / C03 / C28 | pre-apertura "non è buono" (r.51) e Marco "non entro mai" (r.105), pur avendo lui stesso fatto il long in pre-apertura | **terza contraddizione** consecutiva (07/10, 12/10, 14/10) |
| V51 / V71 / V77 | "weekly long, daily long è ... sicurezza" (r.115) | **smentita dalla stessa mattina** (N3) |
| V55 | "Numero tondo primo obiettivo" (r.71); numero tondo 25.400 (r.103) | ripetizione, il tondo come obiettivo |
| V56 | "zona di Preception" (r.151, r.267) | ancora indefinita (Q23) |
| V63 | apertura D1 dentro la resistenza = short (r.21) | **estende V63 da EMA200 D1 a ogni livello D1** |
| V83 | "se la prima volta ... mi sfiora ... se ci va la seconda volta cosa succede? Va oltre" (r.277) | coerente: la seconda volta sul livello **rompe** |

---

## 8. BANDIERE ROSSE

Ricerca per termine (grep mio): martingala 0 · griglia 0 · raddoppio 0 · mediazione 0 · hedging come parola 0 · "senza stop" 1 (avvertimento, r.315) · recupero 2 (r.375, r.487) · trucchi anti-prop 0.

| # | pratica | dove | grado | trattamento per noi |
|---|---|---|---|---|
| **B31** | **Allieva che dichiara di non mettere lo stop; l'host la corregge.** | "sono allergica agli stop loss" (r.203); "ti va bene una, ti va bene due, ti va bene tre, ma prima o poi ti prendi la legnata" (r.315); "ti brucierei il conto. Già fatto." (r.459) | arancione (pratica altrui, **corretta** dall'host: "lo stop ti libera, lo stop ti salva la vita", r.313) | Nessuna azione. Conferma la regola di casa: SL sempre presente (il Guardian si calcola da ingresso a SL) |
| **B32** | **Short e long insieme sullo stesso strumento per pochi minuti.** | "adesso io mi porterò a casa sia lo short che il long" (r.39) | arancione [INFERITO da r.37-41] | **VIETATO PER NOI**: escluso gia' in `ABTG_Nasdaq_Live5m.mq5` r.16-17 (B01). Intelligence |
| **B33** | **Intenzione di recupero dopo lo stop**: riarma ordini per "rifarsi" e lo dice. | "Se mi viene a prendere mi rifaccio dei 300 euro con gli interessi." (r.331); contraddetto da "le perdite non è che vanno compensate in pari" (r.425) e dal 12/10 "non mi voglio recuperare" (B30) | arancione | **VIETATO PER NOI** come regola; il nostro Guardian ha pausa/emergenza. Intelligence. Vedi N6 |
| **B34** | **Secondo ordine doppio del primo, chiamato "una sola operazione".** | "I due ordini non fanno parte di un'unica operazione? Non sono due operazioni separate Elena, non sto migliando il prezzo Elena." (r.287); "il secondo che è più grande è quello che ha lo stop più importante" (r.289) | arancione (stop comune dichiarato, e' la mitigazione) | Parente di B03/B25. Non si copia: rischio e taglia sono di Claudio; FTMO Forbidden Practice n. 8 (taglie diverse) |
| **B35** | **Stop allargato dopo il riempimento.** | "Lo metto qua. Mi do un po' più di respiro." (r.301-303) | arancione [direzione INFERITA] | Come 09/09 r.170 ("allarga per farlo respirare"). Non si copia: un SL che si sposta contro la posizione rompe il cap C1 |
| **B36** | **Numeri/enfasi senza campione e autocelebrazione.** | "la migliore lezione che ho fatto negli ultimi vent'anni" (r.489), "solo i pro potevano vederla" (r.409) | ambra | Registrato, non pesato (B14). Il nostro pavimento resta n >= 150 |

**Rosse piene: 0. Arancioni: 5 (B31-B35). Ambra: 1 (B36).**

---

## 9. COSA C'ERA A SCHERMO E NON NEL PARLATO (chiedere a Claudio lo screenshot)

- **Tutti i livelli del DAX**: resistenze D1 ("qua ci sono tre livelli di resistenza", r.19), supporto weekly ("c'era un supporto weekly", r.377), massimi/minimi della notte, "zona di Preception", VWAP H1 e VWAP M15, EMA200 H4, ORB M15 della mattina. Il parlato da' solo le ultime cifre (P20).
- **Impostazioni dell'ATR** (periodo, TF, su quale grafico): la TR e' "l'orario, l'H1" ma il periodo non e' mai detto.
- **Gli ordini di Emiliano**: prezzi, taglie 5/10, SL, TP al momento del piazzamento (r.267-269 "Vediamo se me lo prende").
- **Il pannello di Luca** (schermo condiviso, r.491-575): ingresso "86", i due lotti, i tre parziali, la posizione residua 0,2.
- **La chat** dei partecipanti: "Voglio che voi scriviate tutte e poi me le vado a leggere tutte" (r.27); risposte lette solo in parte.
- **Il risultato netto della giornata** dopo lo stop (r.427-477).
- **Il grafico dell'ORB M15 della mattina** (direzione della prima candela) e il minuto in cui il DAX ha rotto.

---

## 10. CONTRADDIZIONI DELLA LIVE (nuove, C32-C37)

| # | contraddizione | le posizioni | voce |
|---|---|---|---|
| **C32** | **Direzione: cascata W/D contro ORB** | "weekly long, daily long è cazzo da sicurezza" (r.115) contro "la direzione è l'orb" (r.359) e "il D1 ormai è incerto" (r.397) nella stessa mattina; 09/10 la direzione W/D "conta piu' dell'ingresso" (V71) | V84 |
| **C33** | **Stop in pari** | "Se metto lo stop in pari faccio bene? Sì, assolutamente sì." (Elena domanda, Emiliano conferma, r.211) contro "Il problema è che dopo inizio a inventare." (r.245) contro "non la costruisco per uscire in pari" (r.321) contro "Invece ho messo solo stop in pari" come errore (r.437) | V90 |
| **C34** | **Pre-apertura (terza volta)** | "In pre-apertura in realtà non è buono fare queste cose" (r.51) mentre lo sta facendo (r.37-47); 12/10 long in pre-apertura; 07/10 "assolutamente non si opera" a ridosso | C03, C28 |
| **C35** | **Perdite e recupero** | "mi rifaccio dei 300 euro con gli interessi" (r.331) contro "le perdite non è che vanno compensate" (r.425) | B33 |
| **C36** | **ATR H1 del DAX: dichiarato 37-40 contro la nostra stima derivata 53,6** | r.261, r.523 contro `APERTURE_DAX_MAPPA_2026-10-03.md` §3.2 [LETTO nel repo]. La stima nostra e' [INFERITA] (sqrt(T)), la sua e' [DICHIARATA] di un mattino: **una misura da fare, non chi ha ragione** | V86, N1 |
| **C37** | **"Non sto mediando" contro la struttura** | secondo ordine doppio, ordini scalati, stesso stop (r.287-291), contro la definizione di mediazione ripudiata il 27/08 e insegnata il 09/09 (C08); 12/10 B25 "griglia" | V87 |

---

## 11. DOMANDE PER CLAUDIO / EMILIANO (Q35-Q42)

| # | domanda | perche' |
|---|---|---|
| **Q35** | A Emiliano: periodo dell'ATR e simbolo/feed del grafico su cui legge 37 (H1) e 26 (M15); e se "37" e' la lettura delle 09:00 | N1: senza periodo e ora il numero non si confronta con il nostro 53,6 |
| **Q36** | A Claudio: screenshot M15 e H1 del DAX (D30EUR su BCM, oppure GER40.cash su FTMO) della mattina del 14/10, 08:45-10:00 italiane, con ORB, VWAP H1, massimi/minimi della notte e gli ordini; **se diventa un'istruzione: un solo terminale per numero di conto e cartella, con la stringa di sola lettura PID + titolo + cartella** | I livelli del 14/10 sono tutti a schermo (sez. 9) |
| **Q37** | A Emiliano: i 5 e 10 sono contratti? 1 contratto = 1 EUR/punto sul suo conto? "dieci occhi" (r.289) = dieci contratti? | P10, P11: la perdita da 300 EUR non si riconcilia |
| **Q38** | A Emiliano: l'ordine "sfiorato" di ieri a 25.450 (r.19) era il suo o di Pasquale? e "sfiorato per tre punti" vuol dire non eseguito? | N2: serve per contare gli episodi di mancato fill |
| **Q39** | A Emiliano: "È l'orb, la direzione è l'orb." (r.359) sostituisce W/D per il resto della giornata o solo dopo uno stop? Come disegna "D1 incerto" quando non c'e' una finta rottura? | N3, Q25 |
| **Q40** | A Emiliano: cosa intende con "ho separato gli odi" (r.307) e "Io prima ho usato 5 e 10, ... sites che rappresentano pericolo" (r.329) | P10, B34 |
| **Q41** | A Emiliano: "Andiamo a vedere Natalia, 23.15" (r.273) e' un livello, un orario o un'altra cosa? | P20 |
| **Q42** | Al chiamante: la trascrizione e' stata salvata con un nome fuori convenzione (`LIVE_EMILIANO_14.10.26_...`); va rinominata/copiata come `LIVE_EMILIANO_2026-10-14.txt` (SAPERE §8 punto 1) o si lascia? | igiene del repo |

---

## 12. COSA NE COPIAMO

**Niente come parametro e niente come criterio.** Tre cose entrano come **ipotesi da misurare** nel sapere accumulato (`docs/SAPERE_LIVE_PER_EA.md`, §2.9 e T15, voci V84-V93): N1 (lettura di `iATR` H1, zero tester), N2 (profondita' di penetrazione dei fill, zero tester) e N3 (split ex post col segno dell'ORB 15', zero tester). Le altre tre (N4-N6) richiedono tester e restano in coda. **Da non copiare:** B32-B35. **Convergenza non indipendente:** stop ATR H1 e SL automatico (M12) con il nostro design; stessa scuola.

---

## 13. VERIFICHE E LIMITI

- Letta per intero. Verifiche mie con `grep` sulla trascrizione grezza: conteggi di sez. 1 e 8; occorrenze di "sfior*" (r.19, r.275, r.277, r.297, r.427 come "sperato", r.471, r.473); "stop in pari" 12 righe; massimi/minimi della notte 19 righe; VWAP e varianti 24 righe.
- Ogni citazione tra virgolette di questa scheda e' stata ritrovata con uno script sulla riga indicata (ignorando maiuscole e punteggiatura).
- Numeri **nostri** (ATR M15 26,8, H1 53,6, spread 1,70/1,23/1,33, pavimenti 13,3x/40x, 731/731 fill, R46a/FASE F, `InpRetestOffsetPts`) vengono dai file citati e **non sono stati rimisurati**. I rapporti 24,1x, 33,3x, 30,8x, 32,6x, 35,3x sono calcoli miei (41/1,70; 41/1,23; 41/1,33; 55,5/1,70; 60/1,70).
- Nessun controllo di giudizio dello strato 2 in questa passata.
- Il parlato non ha etichette di relatore: chi dice cosa e' [INFERITO] dai vocativi e dall'andamento domanda-risposta; dove incerto, scritto.
