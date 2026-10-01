# PARAMETRI DELL'APERTURA DAX: cosa è misurato, cosa no, e le prove (01/10/2026)

**Mandato di Claudio (01/10): "cercate ovunque parametri vincenti, analizzate gli EA dove non sono mai stati analizzati".**
Famiglia: `770101` (DAX Apertura EU LONG), `770105` (DAX Apertura EU RETEST SELL), `770411` (MaxMin DAX SHORT) e i gemelli Dow/Nasdaq.
Autore: `cercatore-parametri` · **sola lettura sul repo + calcoli su file già in repo + 4 ricerche web e 9 fetch (3 bloccati dal proxy)** · **nessun backtest lanciato,
nessun preset/EA/conto toccato, nessuna riga di lancio scritta** · HEAD di partenza `0075a430`.

> ## IN SEI RIGHE
> 1. **La domanda 1 non era mai stata misurata come frontiera "stop ≥ k × rumore d'apertura"** e il rapporto non compariva in nessun file.
>    Oggi per la prima volta ha un numero: lo stop del `770411` ha mediana **57,7 idx** (n=28, ricostruito dai lotti) contro un `R15` d'apertura
>    mediano di **54,65 idx**, cioè **k ≈ 1,06**. Il `770101`/`770105` invece **non può essere spazzato** nei primi 35 minuti per costruzione
>    (stop = range intero): primo stop pieno a **+53 min** su 45 (n=295).
> 2. **Quante uscite a SL cadono entro 10/30 min dalla cash?** Sul `770411` "come FTMO": **1/12 entro 10 min, 5/12 entro 30** (mediana 58 min).
>    n=12: **indizio, non misura**. Sul `770101`: zero per costruzione. Il caso del 01/10 **non è un evento mai visto, ma non è nemmeno comune**.
> 3. **L'ora d'ingresso a +0/+1/+5/+15 minuti non è mai stata misurata** (`InpPlaceHour/Min` mai ad asse in nessun file): esiste solo la forchetta
>    di **±60 minuti** (R246). E **ritardare il piazzamento NON è "entrare più tardi"**: l'EA salta il giorno se la rottura è già avvenuta.
> 4. **Un segnale ex-ante non è misurabile con 12 stop.** Ho congelato una **sonda sui prezzi** (centinaia di eventi, 9 anni + cassaforte) e, per
>    l'unica ipotesi testabile oggi (gap) sul Nasdaq 2010-2020, **la mia ipotesi di partenza è stata smentita nel verso** (-5,8 punti, IC95 [-10,0; -1,4]).
> 5. **4 file prova nuovi** (`PRV_DAXAP_01, 02, 03a, 03b`, 34 passate, ~7-14 min di tester sul PC di backtest) + **1 sonda** (zero tester). **Attesa
>    onesta: "il default va bene" su quasi tutto.** Nessun file è promuovibile per costruzione sul `770411` (14 posizioni OOS).
>    **[CANCELLO 01/10, `controllo-preventivo`]: `PRV_DAXAP_01` è BLOCCATO** (recidiva della classe 294: con l'EA di oggi `InpMaxRangePts` acceso
>    **non salta la giornata**, la arma con buffer 0). Lanciabili dopo correzione: `02, 03a, 03b` = **22 passate, ~4,5-11 min**.
> 6. **Un rilievo di costo nuovo**: il `770411` **arma** nell'**ora 09 server FTMO** (09:59), il cui spread P95 è **2,33 idx** (non l'1,33 dell'ora 10 con cui
>    si è calcolato il pavimento 40×): `67,75 / 2,33 = 29×`, **sotto 40×** a quel minuto. `[DERIVATO]`: la tabella è per ora, non per il minuto 09:59.
>    **[CANCELLO 01/10]** *riempie* nell'ora 09 **solo quando la rottura arriva prima della cash** (il 01/10, fill 09:59:01): i 5 fill del forward BCM sono
>    **tutti** fra le 08:01 e le 08:27 BCM = 10:01-10:27 FTMO (`SEDIA_770411_IL_RIENTRO` par. 5), cioè nell'ora 10. Il 29× vale per quella coda, non per la sedia.

---

## (a) COSA È GIÀ MISURATO, per domanda

### Domanda 1 · Larghezza dello stop contro il rumore d'apertura

| cosa | numero | fonte |
|---|---|---|
| range d'apertura 15' `R15`, D30EUR | **mediana 54,65 idx** (n=440); quantili 10/25/50/75/90% = **23,9 / 34,5 / 54,8 / 78,5 / 111,0** (ricalcolati qui) | `MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` r.398-400 · `risultati_archivio/studio_apertura/Studio_D30EUR.csv` colonna `ampiezza_pt`/100 |
| rialzo d'apertura contro la legge √T | **x1,56 DAX · x1,88 Nasdaq · x3,03 Dow** (varia di 2x: non si trasferisce) | `MAPPA_COSTO` r.621 |
| `R5`, `R10` (5 e 10 minuti) | **`[NON MISURATO]`**: nessuna fonte | verificato con grep su `report/`, `risultati_archivio/` |
| stop del `770411` | `2,5 x ATR(14) M15` della barra **chiusa precedente**, letto al piazzamento (09:59 FTMO = 07:59 BCM): `.mq5` r.139, r.237, r.286, r.412 (`CopyBuffer(hAtr,0,1,1,a)`, shift 1). Il 01/10: SL 67 punti = 2,5 x ~27,1 | `TRIAL_GIORNO1_ANALISI_2026-10-01.md` r.25 |
| ATR(14) M15 del DAX | **25,7-29,2 idx `[DERIVATO]`** (mai letto `iATR`) | `ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md` |
| stop del `770101/770105` | `range 35' + buffer 5 - offset 2` = **range + 3 idx** (`ABTG_DAX_Apertura_EU.mq5` MonitorRetest r.1929-1933 (BUY) e r.1972-1976 (SELL)). Il 01/10: SL 257,49 = range ~254 idx | `TRIAL_GIORNO1_ANALISI` r.26 |
| **vincenti che durano, perdenti che muoiono presto** | vincenti mediana **165 min**, perdenti **60 min** (D30EUR); Dow 160/45, Nasdaq 190/45 | `MFE_E_DURATA_APERTURE_2026-09-22.md` r.13-21 |

**NUOVO, calcolato il 01/10 (nessun file lo aveva)**

*(i) Stop pieni del `770411` per tempo dalla cash.* Dai per-trade di R246 (`794621`+`794623`, d0) e R246-inverno (`794625`+`794626`, d+1),
costruendo la serie "come FTMO" (d0 nei giorni d'estate, casella d+1 nei giorni d'inverno, lo stesso metodo di `LETTURA_R246_INVERNO` r.37):

| insieme | posizioni | stop pieni (1 deal, ≤ -0,5R) | minuti dalla cash alla chiusura | entro 10 min | entro 30 min |
|---|---:|---:|---|---:|---:|
| **"come FTMO"** (cash-allineato) | 28 | **12** | 1, 11, 25, 26, 26, 56, 56, 60, 75, 91, 116, 383 | **1/12** | **5/12** |
| d0 grezzo BCM (arma 1h prima in inverno) | 27 | 10 | -45, -5, -2, 0, 11, 14, 25, 56, 91, 116 | 1/10 (+0 minuti) | 4/10 dopo la cash, **3/10 PRIMA** della cash |

I 3 stop **prima** della cash (-45, -5, -2 min) sono un **artefatto dell'orologio BCM d'inverno** (arma alle 07:59 BCM = 07:59 italiane, un'ora
prima di Xetra): su FTMO **non esistono**. **n = 12: INDIZIO.** In frequenza sui fill: `P(stop entro 30 min | fill) = 5/28 = 17,9%` (Wilson 95% ~8-36%).

*(ii) Stop del `770411` ricostruito dai lotti* (stop_idx = 0,01 x saldo all'ingresso / lotti; D30EUR = **1,0000 EUR/punto/lotto**,
`DUE_GESTI_2026-09-11.md` r.52). **La formula è verificata contro numeri di altri**: la somma dei `net_profit` ricostruita = `Profit` dei CSV
**al centesimo** (IS 3789,36 / OOS 18029,58) e la serie "come FTMO" del DAX conta **295 posizioni = `LETTURA_R246_INVERNO` r.37**.
Per gli stop pieni, `|net|/lotti` (31,8-66,5 + un 216,6) coincide con la formula.

| sedia | n pos | stop idx: min / p25 / **mediana** / p75 / max | quota sotto 40 / 53,2 / 68 idx |
|---|---:|---|---|
| `770411` "come FTMO" | 28 | 31,9 / 44,9 / **57,7** / 77,8 / 216,0 | (d0 tutte, 27 pos) 22% / **52%** / 70% |
| `770101` d0 (A+B) | 325 | mediana **74,0** · p10 33,9 · p90 130,5 | 16% / **30,5%** / 43,7% |

- **`stop / R15`**: `770411` ≈ **57,7 / 54,65 = 1,06**; il 01/10 `67,75 / 54,65 = 1,24`. Il `770411` ha uno stop **nell'ordine del rumore
  mediano dei primi 15 minuti**. `[DERIVATO]`: i due numeri vengono da fonti diverse (lotti dei per-trade vs studio su altro motore).
- **Retest `770101`** "come FTMO" (295 pos): **45 stop pieni, il primo a +53 min dalla cash, solo 1 entro 60 min, 11 entro 90, mediana +134 min.**
  Zero entro 35 min **per costruzione** (arma a fine range). Il caso del 01/10 sul `770105` (stop 257 punti, uscito 13:36) è **un'altra cosa**:
  giornata di range eccezionale (~254 idx contro un range-35' mediano di ~71), non spazzata d'apertura.

*(iii) Il breakout cieco (Studio, range 15', stop = bordo opposto, n=440/446/447)*, perdenti per **durata dall'ingresso**:

| indice | perdenti | entro 10 min | entro 15 min | entro 30 min |
|---|---:|---:|---:|---:|
| D30EUR | 264 | **7,6%** | 12,9% | **26,1%** |
| U30USD | 240 | 11,2% | 16,7% | 36,7% |
| NASUSD | 255 | 10,6% | 20,0% | 40,4% |

*(iv) Non esiste la frontiera "stop ≥ k x rumore" in nessun file*: l'unica famiglia che muove la larghezza dello stop è `InpAtrSlMult`
(`ABTG_DAX_Apertura_EU`: 6 CSV con asse, ma `InpSLMode=0` in **tutti** i 99 CSV leggibili, e il ramo ATR del retest si legge solo con `SLMode != 0`,
`MonitorRetest` r.1931/r.1974: **inerte per costruzione**) e, sul `770411`, **`R206a` (scritto, mai girato)**. Scansione del 22/09 dentro `R206a` r.47-62:
l'unico file dove `InpAtrSLmult` prende più di un valore è del **motore padre** `ABTG_MaxMinNotte` (magic 770401), mai di questa sedia. Sul motore padre generico, lato long, **lo stop allargato su 7 box diversi ha mosso il PF di +0,002**
(`STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md` r.60-62): una direzione di **inerzia**, non di effetto.

### Domanda 2 · Ora d'ingresso a +0/+1/+5/+15 minuti

| cosa | numero | fonte |
|---|---|---|
| **forchetta ±60 minuti** sul DAX apertura, estate | arma 1h PRIMA della cash: **PF 0,774, DD 14,05%** (184 pos) contro alla cash **PF 1,108, DD 5,55%** (157 pos) | `REFERTO_R246_2026-09-24.md` r.136-138 |
| idem, inverno (stesse giornate) | d0 (arma 1h prima) **PF 1,389 · 168 pos · 0,764/g** contro d+1 (arma alla cash) **PF 1,184 · 138 pos · 0,627/g**; serie "come FTMO" **PF 1,143 · 295 pos · DD 9,50%** contro 6,06% del d0 tutto l'anno | `LETTURA_R246_INVERNO_2026-09-29.md` r.20, r.37-38 |
| stessa forchetta sul `770411` | d0 inverno **2,558 (16 pos)** · d+1 inverno **0,996 (17 pos)** · d0 estate **1,450 (11 pos)** | idem r.22: tutte **n<30, PF non si legge** |
| ingresso ritardato a mercato sul DAX | R27 (DELAYED, 9 celle, 15/30/45 min): **nessuna cella batte il RETEST in entrambe le finestre**; le celle 15' e 30' sono **identiche** (il range di 35' le fa collassare); migliore OOS `CANDLE` +444 contro +1.811 del RETEST | `risultati_archivio/REFERTO_ROUND27_DELAYED.md` |
| cutoff / fill tardivi (scala di **ore**, motore PADRE, altra geometria) | fill oltre le 12:00 BCM: **PF marginale 0,588 su 48 deal**; fino alle 12:00 cumulato 1,409 | `REFERTO_R244_2026-09-24.md` §3 |
| **`InpPlaceHour/Min` ad asse da soli** | **MAI**, in nessun file prova e in nessun CSV (grep `\|\|Y` su `prove/`; `LE_MANOPOLE_INERTI` par. 4.4) | verificato il 01/10 |
| `InpEntryCutoffMin` (quanto vive l'ordine) | **`R191a` scritto, mai girato**, nessun CSV | `REGISTRO_TEST` r.3946 |
| primo tocco contro chiusura M5 | **solo Nasdaq**, strumento costruito e **non lanciato** (30/09); 68,5% dei primi tocchi Nasdaq 2010-2020 è "falso entro 15 min" | `CONFRONTO_TOCCO_CHIUSURA_M5_CRITERI.md` · calcolo mio su `ANATOMIA_MOVIMENTI_M5_PERGIORNO_NASUSD.csv` (1698/2480, righe `fase=IS`) |
| spread per ora (FTMO `GER40.cash`) | notte 303 · **ora 09 (pre-apertura): mediana 143, P95 233** · **ora 10: 123 / 133** (punti MT5, 100 = 1 idx) | `SPREAD_APERTURA_FTMO_2026-09-21.md` §2 |

**Cosa non è un parametro (verificato nel sorgente).** `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.188-191 piazza al primo tick `>= PlaceHour*60+PlaceMin`;
r.266-270: `if(lot>0 && gTrade.SellStop(...)) Log(...); ... return(true);`. **Un sell stop sopra il bid è un ordine non valido: fallisce in silenzio e la
fase passa a PLACED senza ordine.** Quindi **ritardare il piazzamento = "salta il giorno se la rottura è già avvenuta"**, non "entra a mercato a +N". L'ingresso a
mercato +N è un altro meccanismo (esiste nel codice del retest: `ABTG_DELAYED`/`ABTG_OPENCONFIRM`).

### Domanda 3 · Uscita ad asse e due lati

| sedia | long | short | BE / parziale / trailing | tempo massimo | TF |
|---|---|---|---|---|---|
| `770101` (retest) | **misurato**: PF OOS 1,397 (193 pos); `TrailMode`, `TP1_R`, `BEatR`, `TrailStartR` ad asse (R270c/e, R201A, R202B, R46a): **"il default va bene"**. `ClosePct 0` batte in 4 misure su 4 (PF OOS 1,491, DD 6,27) ma è **firma pendente** | **misurato e bocciato per rischio**: PF OOS 0,957, **DD 12,31% a 1%** (R270b/d, R251, FASE M) | tutti ad asse sul long | **`InpCloseHour` mai mosso** (R128e scritto su geometria vecchia, nessun CSV) | `R140c` M15 scritto (esito non letto) |
| `770105` (short) | — | come sopra | solo `TrailMode`/`TrailStartR` (R270b/d): **nessuna cella passa R1**. `TP1_R`, `ClosePct`, `BEatR` **mai** | mai | mai |
| `770411` | **misurato**: 0/41 celle a tick ≥ 1,00, a specchio col filtro S&P PF 0,883 (72 pos) (R261a/b); generico 0/34 | **R81**: 6 uscite ad asse (`r81c` solo BE batte il vivo in IS e OOS, **14 posizioni**: merito sospeso) | `InpTP1_R`, `InpTP2_R`, `InpAtrSLmult`, `InpMgmtTF` **mai** (`R206a`, `R214g` scritti, non girati) | `InpCloseHour` mai | solo M15 |
| gemelli Dow `770202` / Nasdaq `770260` | Dow **96 posizioni OOS** (Nasdaq: non letto qui): merito **sospeso** (<150), solo rischio | misurato: no su tutti e tre (REGISTRO r.4035-4040) | R202A (`TP1_R` Dow: resta 1,0) | `R172b` scritto | — |

**Regola dei due lati**: soddisfatta su DAX (long e short di `770101` e `770411`), Dow e Nasdaq; **la parte "uscita" dello short `770105` resta NON ANCORA
MISURATA** (certificato 09/09: manca TF e il filtro su U30USD/NASUSD) ma **non propongo di misurarla**: è la sedia già bocciata per rischio.

### Domanda 4 · Segnale ex-ante nei giorni di spazzata

- **Larghezza del range d'apertura** come segnale: ricalcolato qui sullo Studio (breakout cieco, n=110 per quartile): quartile più largo del DAX
  (≥ 78,5 idx) `E[R]` = **+0,125** contro -0,018 / +0,009 / -0,013 degli altri tre. **Errore standard ~0,13 per cella: dentro il rumore.**
  Sul Dow il quartile più largo è -0,069, sul Nasdaq -0,069: **nessuna coerenza fra indici**. *Non è un segnale; è la ragione per cui non lo propongo
  come ipotesi.* La manopola `InpMaxRangePts` **non è mai stata mossa** (vale 0 in tutti i 99 CSV leggibili su 132 candidati della famiglia, e `InpMinRangePts` idem):
  vedi `PRV_DAXAP_01`. **[Cancello 01/10]: e con l'EA di oggi, acceso, NON salta la giornata (classe 294): `PRV_DAXAP_01` è bloccato finché l'EA non è tappato.**
- **Gap**: "gap-fill" come motore è **chiuso per aritmetica** (un gap al giorno, `REGISTRO_TEST` r.1229) **ma come filtro non è mai stato misurato sul DAX**. Sul
  Nasdaq 2010-2020 (addestramento, sole righe `IS`/`OK`, **cassaforte non letta**) ho misurato **una** ipotesi scritta prima: i primi tocchi *lontani* dal
  riempimento del gap falliscono di più. **Smentita nel verso**: verso il riempimento 70,0% (n=927) contro lontano 64,2% (n=881), **-5,8 punti, IC95
  [-10,0; -1,4]**. Resta come **nuova** ipotesi non confermata (verso opposto) per la sonda sul DAX.
- **Supertrend sul solo lato short** (filtro di regime H12/D1): R251, **R1-R3 passati ma merito sospeso**, "NON C'È UNA CONFIGURAZIONE ROBUSTA"
  (`REGISTRO_TEST` r.4069-4073). **Giorno della settimana, dato macro**: mai misurati.
- **Il 01/10** è un evento: nessun dato M1/tick di quel giorno è in questo ambiente. Non lo analizzo.

### Domanda 5 · Orologio (solo l'impatto sulle ipotesi sopra)

- **FTMO = IT+1 tutto l'anno**: le sedie a ora fissa restano cash-allineate (09:59 server = 08:59 italiane tutto l'anno). **Il benchmark FTMO d'inverno non è
  il d0 del backtest ma la casella d+1** (arma alla cash): DAX `770101` PF **1,184** su 138 pos (non 1,389), `770411` PF **0,996** su 17 pos.
- **Q1**: nel `d0` BCM d'inverno **3 stop su 10 cadono PRIMA della cash**: artefatto che su FTMO non c'è. Tutti i numeri "FTMO" di questo dossier usano la
  serie cash-allineata.
- **Q2**: ogni round BCM con orario fisso **mescola** estate (cash-allineato) e inverno (1h prima): `PRV_DAXAP_01/02/03` lo dichiarano e **non lo separano**
  (il per-trade è uno solo per magic: sopravvive l'ultima passata, classe 455).
- **Una settimana a rischio, `[NON VERIFICABILE]`**: il preset FTMO `770411` annota che se FTMO seguisse il DST **americano** (1/11) fra il 25/10 e il 01/11
  il delta cambierebbe di 1 ora: in quella settimana la sedia armerebbe **un'ora prima della cash**, cioè la casella "d0 inverno" (lo spread dell'ora 09 ha P95 2,33 idx contro 1,33 dell'ora 10, `[DERIVATO]`).
- **Q3, Q4**: non toccati dall'orologio, a parte che ogni dato "d'inverno" va letto sulla casella giusta.

---

## (b) I BUCHI, dichiarati

1. **Nessun per-trade ha l'ora d'ingresso**: solo `close_time` (`abtg_trades_*.csv`, colonne `close_time;symbol;magic;position_id;deal_type;volume;price;net_profit`).
   Quindi la **durata ingresso→stop** del `770101/770105` e l'ora d'ingresso del `770411` sono `[NON MISURABILI]`; ho usato il tempo **dalla cash alla chiusura**.
   Aggiungere `open_time` a `ExportTrades` è **una modifica all'EA = decisione e codice di altri**.
2. **La corsa DAX della FASE 1b è fallita il 29/09** (`ANATOMIA_MOVIMENTI_M5_2026-09-29/corsa_D30EUR.log` r.19-20: *"nessun dato nelle finestre attese"*): **causa
   non diagnosticata**. Senza, il DAX non ha né `R5/R10` né il tasso di falsi tocchi. Ipotesi `[INFERITA]`: convenzione oraria `02:00-15:00` NY dei 9 anni sani.
3. **`R5` e `R10` non esistono** per il DAX in nessuna fonte; `R15` solo come **mediana/quantili d'insieme** (n=440, senza date).
4. **Gli stop ricostruiti sono `[DERIVATI]`** (lotti, 1 EUR/punto): validati su somme e conteggio, non su un'ora d'ingresso.
5. **n=12 stop pieni, 28 posizioni** sul `770411`: nessuna conclusione di merito; `770411` ha 14 posizioni OOS. Dow 96 posizioni OOS (Nasdaq non letto qui): sotto 150.
6. **Un regime solo** per tutto il BCM (2024.09.26-2026.06.30, con un episodio di crollo ad aprile 2025). HistData 2010-2018 è D-C = **SOLO_PROVA_REGIME**.
7. **`R206a`, `R191a`, `R214g`, `R192a`, `R128e`** sono scritti e **mai girati**: nessun CSV in repo. Il perché non è documentato qui.
8. **La citazione "arXiv 2605.04004: ORB long bar+1 -0,82 pt, bar+15 +2,82 pt, edge matura in 60-75 minuti"** (`MFE_E_DURATA` r.24-26) **non è verificabile**: l'abstract
   (WebFetch 01/10) dice solo *"Opening Range Breakout long ... T = 0.88, year-unstable"* su **MNQ, 947 giorni 2021-2025**; il PDF non è parsabile qui; il paper
   **non è sul DAX**. Va riletto prima di citarlo di nuovo.
9. **Le fonti esterne di queste ricerche** (fxvps.biz, trading-edge.app, tradingstats.net): **bloccate dal proxy**, letti solo gli snippet del motore di ricerca.
10. **Lo spread al minuto 09:59** non è misurato: la tabella `SPREAD_APERTURA_FTMO` è per ora (09 = tutta l'ora).

---

## (c) LE PROVE, in ordine di valore / costo

Ordine = quanto avvicina una sedia schierabile al costo di tempo macchina. **Nessuna è eseguita.** Costo in tempo macchina **dichiarato con la sua base**.

| # | prova | tester | cosa decide | attesa (PRIMA) | contro-esempio (PRIMA) |
|---|---|---|---|---|---|
| **0** | **`PRV_DAXAP_00` sonda** (prezzi, M1) | **0 min** · python sul PC | stop contro rumore d'apertura; segnale ex-ante; `P(S10)`, `P(S30)`, `P(Rv)` su centinaia di eventi | `P(S30\|fill)` a k=2,5 in 10-30%, dimezzata a k=4,0; `rho_s(A_pre,R15) <= 0,60`; gap: stesso segno del Nasdaq (-5,8) | **C1**: controllo a orario casuale (07:00): se il rapporto apertura/07:00 <1,5, la spazzata d'apertura non è speciale. **C2**: `A_pre` permutato → `rho_s`~0 |
| **1** | **`PRV_DAXAP_03a`** (`InpPlaceMin` 59/60/61) | 6 passate × 0,214-0,700 min = **1,3-4,2 min** | quanto conta il minuto **prima** della cash (il caso del 01/10); **[cancello 01/10]** è un SALDO in deal, non il numero dei fill delle 07:59 (alle 08:00 cambiano anche la barra ATR e la barra H1 del filtro S&P) | `\|Trades(60) - Trades(59)\| <= 3` deal | `\|Trades(60) - Trades(59)\| >= 0,25 x Trades(59)`: il minuto sposta un quarto del campione |
| **2** | **`PRV_DAXAP_01`** (`InpMaxRangePts` 0/50/100/150/200/250 idx) sul `770101` LONG — **BLOCCATO dal cancello 01/10: classe 294, serve prima la toppa (firma di Claudio o copia di banco dell'EA)** | 12 passate × ~11 s = **~2,2 min** (base R270: 28 passate in 5 min) | filtro ex-ante già nel codice, mai mosso | **"il default va bene"** (A5); `cap150` taglia 10 pos OOS (netto **-1.544**) e 8 IS (netto **+1.094**): **segni opposti** = ribaltamento atteso | **H-TAIL**: PF IS e OOS salgono di ≥0,05 in **tutte e due le gambe** a 150 **e** 200 |
| **3** | **`R206a` già scritto** (`InpAtrSLmult` 1,5→4,0, 12 passate) | 12 × 0,214-0,700 = **2,6-8,4 min** | frontiera dello stop sul `770411` (già validato da `controlla_prova`) | `R206a` r.140+ (H0/H1 scritte lì) | in `R206a` (lotto che si rimpicciolisce) |
| **4** | **`PRV_DAXAP_03b`** (`InpPlaceMin` 0/5/10/15) | 8 passate = **1,7-5,6 min** | il ritardo VERO: "salta se già rotto" | posizioni non crescenti col ritardo; PF **non direzionato** | **H-FILTRO** (DD scende ≥10%, PF non scende) contro **H-TAGLIO** (PF OOS(+15) ≤ 0,85 x PF(+0)) |
| **5** | **`PRV_DAXAP_02`** (`InpCloseHour` 11/13/15/17) sul `770101` | 8 passate = **~1,5 min** | tempo massimo sulla cella viva (sostituisce R128e, su geometria vecchia) | **H-RUNNER**: PF OOS(11:30) ≤ 1,257; IS e OOS discordi a 13:30 | **H-LATEFADE**: PF(13:30 o 15:30) ≥ 1,397 e ≥ 1,126 in entrambe |
| 6 | `R191a` (cutoff 10/30/50/70/90) · `R214g` (`InpMgmtTF`, 7 celle) · `R192a` (`InpSessionHour` 8→13) | già scritti: 10 / 14 / 12 passate | residuo | n=14 posizioni: solo rischio | — |

**Totale dei 4 file nuovi: 34 passate, ~7-14 min più l'avvio.** Su `770411` **nessun file è promuovibile a nessun PF** (14 posizioni OOS); si leggono **conteggio e rischio**
(`Equity DD% > 5,00` ⇒ incompatibile a 2,00%, soglia di R194a/R206a). Sul `770101` il merito si legge solo nelle celle con ≥210 deal OOS (= 150 posizioni x k 1,399).

### Dichiarazione "meglio del default?"
**Nessuna cella girata, quindi nessuna dichiarazione di vittoria.** L'attesa scritta su ogni file è **"il default va bene"**; il dossier si **accorgerebbe** del contrario solo in
una cella **al centro di un altopiano** (A1) con **IS e OOS concordi** e **regime dichiarato**. Se sporge una cella sola: *"non c'è una configurazione robusta"*.

### Perché NON propongo altro (e dove si ferma la grinta)
- **Nessun tappo/filtro sul `770105` short**: PF OOS 0,957 e DD 12,31% a 1% (`LETTURA_R270` par. 3). Una griglia d'ingresso su un motore senza edge dichiarato trova picchi di
  rumore (regola 19/08). **Decisione di Claudio** sul suo schieramento a 2,00%.
- **Nessun file sui gemelli Dow/Nasdaq**: 96 posizioni OOS, merito sospeso a priori.
- **Nessuna griglia fitta sullo stop**: `R206a` ha 6 celle; `InpAtrSLmult` si scrive solo dopo la sonda.
- **Nessun TF più basso per costo** (numeri sotto): non è pigrizia, è un conto.

### Il TF: frontiera `stop ≥ 40 x spread`, col numero accanto
ATR(M15) = 26,8 idx (il 01/10: 67,75 / 2,5 = 27,1), scala √T, spread FTMO P95: **1,33 (ora 10)** e **2,33 (ora 09, quella in cui il `770411` arma)**.

| `InpMgmtTF` (`770411`) | ATR `[DERIVATO]` | stop 2,5 x | su 1,33 | su 2,33 |
|---|---:|---:|---:|---:|
| M5 | 15,5 | **38,7 idx** | **29x: ESCLUSO PER COSTO** | **17x: ESCLUSO** |
| M15 (vivo) | 26,8 | 67,0 | 50x | **29x: SOTTO 40x** |
| M30 | 37,9 | 94,7 | 71x | 41x |
| H1 | 53,6 | 134,0 | 101x | 58x |

**Le fonti dello spread sono `SPREAD_APERTURA_FTMO_2026-09-21.md` §2-3; le tre ultime colonne sono derivate qui.** `770101` ha stop mediano 74 idx = **56x su 1,33** ma **il 30,5% delle sue posizioni sta sotto 53,2**.

---

## ALTERNATIVE DI MECCANISMO sulla stessa inefficienza (mai parametri diversi di un motore morto)

| meccanismo | stato nel repo | nota |
|---|---|---|
| **stop come % del range d'apertura** (la frontiera "k x rumore" costruita ex-ante) | **non esiste** in `770411`; `ABTG_DAX_Apertura_EU` ha `InpSLMode=0` (range) | **gli ORB EA esterni lo prevedono**: MQL5 blog "Opening Range Breakout EA Version 2", 03/01/2023: stop e trailing "percentuali del range", **filtri min/max sul range**, M5 su DAX/NASDAQ/DOW/SPX |
| **attendere il rumore** | **`ABTG_DaxReEntry`** (range 08:35-11:05, fascia 11:05-14:15): LONG 6/6 verde, PF 1,16-1,80 a seconda del `break` (1,69-1,80 a break 40), DD 2,5-4,6%, **n 57-92**: merito sospeso (`REFERTO_DAXREENTRY_2026-08-31.md`) | è già "aspetta due ore dopo l'apertura" |
| **livello pre-apertura (RangeMode=1)** | **file prova scritti** (`PREOPEN_RETEST_DAX_M15*.txt`, `PREOPEN_METRO_DAX_M15*.txt`), **"NON DEVE GIRARE FINCHÉ I CRITERI NON SONO FIRMATI"**; nessun CSV/referto | mai acceso sul DAX |
| **ingresso a mercato dopo conferma di chiusura** | `ABTG_DAX_Apertura_EU` ha `OPENCONFIRM`/`DELAYED` (R27: bocciato su DAX); strumento Nasdaq `confronto_tocco_chiusura_m5` non lanciato | MQL5 Code Base 76153 "Session Opening Range Breakout EA" (Stridz_z, 15/08/2026): range **30'**, finestra **120'**, buffer 20, SL buffer 30, RR **2,0**, **ingresso a chiusura candela** oltre il livello |
| **ATR stop**, valori di riferimento | il nostro `2,5 x ATR(M15)` | MQL5 articolo 19459 (22/09/2025): ATR(14), **moltiplicatore 2,0**, "Stop Loss Multiplier 1,5", TP 2,0, range 120' |
| **inversione dopo la spazzata** (`Rv` della sonda) | `InpAllowReverse` esiste sul **retest** (R51, 14/08: OOS +74,6% profitto, IS peggiore, peggior giornata x1,9 → riserva); **non sul MaxMin** | solo se `P(Rv\|S30)` è alta nella sonda; richiede codice (decisione di Claudio) |

**Riferimenti esterni, ciascuno con fonte e data** (solo come valori/idee; nessuno validato da noi): MQL5 Code Base 76153 · MQL5 articolo 19459 · MQL5 blog 751352 (tutti
letti con WebFetch il 01/10/2026); arXiv 2605.04004 (solo abstract, **vedi buco 8**); fxvps.biz "DAX ORB 14 anni" (snippet: PF 1,25 su H1, 9 anni su 14 positivi, *"fallisce sugli indici USA"*,
**pagina bloccata**); tradingstats.net gap NQ 2015-2025 (snippet, **pagina bloccata**).

---

## (d) FILE PRODOTTI (in `backtest_pipeline/prove/`, NON ESEGUITI)

| file | EA | celle × 2 | passate | magic | `controlla_prova.py` |
|---|---|---:|---:|---:|---|
| `PRV_DAXAP_01_maxrange_770101_D30EUR.txt` | `ABTG_DAX_Apertura_EU` | 6 | 12 | 798101 | **OK, 0 problemi** |
| `PRV_DAXAP_02_closehour_770101_D30EUR.txt` | idem | 4 | 8 | 798102 | **OK, 0 problemi** |
| `PRV_DAXAP_03a_ingresso_meno1_piu1_770411_D30EUR.txt` | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | 3 | 6 | 798103 | **OK, 0 problemi** |
| `PRV_DAXAP_03b_ritardo_5_15_770411_D30EUR.txt` | idem | 4 | 8 | 798104 | **OK, 0 problemi** |
| `PRV_DAXAP_00_SONDA_SPAZZATA_CRITERI.md` | (sonda su prezzi) | — | — | — | non applicabile (è un `.md`) |

Primo strato: `controlla_prova.py` **ESITO OK** (4 file, 17 celle, 34 passate); `controlla_riga.py --oggetto prova` **nessun difetto meccanico**, ASCII puro.
**Secondo strato (`controllo-preventivo`) NON ancora fatto: non è un PASS completo. Nessuno di questi file esce senza.**
**[AGGIORNATO 01/10, secondo strato fatto]**: `PRV_DAXAP_01` **FAIL, BLOCCATO** (classe 294: `ArmRetest` r.1577-1578 `return(true)` -> `PH_ARMED` con
`gBuffer=0`; il tappo non toglie giornate, toglie 5 idx di buffer; la toppa è un EA in forward = firma di Claudio o copia di banco). `PRV_DAXAP_03a` e
`03b` **corretti prima dei numeri** (la monotonia di `Trades` non è un cancello di NULLO: classi 662 e 1018; orologio per cella: "dalla cash" vale solo
d'estate). `PRV_DAXAP_02` **PASS** con tre correzioni di testo non bloccanti. Ogni file porta in testa il blocco `[CANCELLO 01/10/2026]`.
Magic `798101-798104`: **zero occorrenze nel working tree e in tutti i rami remoti al 01/10/2026** (`git grep`).
**Gemelle G1**: non scritte (un asse per file); il determinismo di questi pin è già stabilito da R246 (`794611/794661` e `794621/794671`, identici al centesimo). Il **G2
incrociato** `03a cella 60 ≡ 03b cella 0` (stesso istante `nowMin >= 480`) è dentro i file.

---

## IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO IL MIO STESSO LAVORO (prima di consegnare)

1. **"Lo stop del 770411 è ~1,06 x R15: è dentro il rumore."** Alternativa: i due numeri non sono confrontabili (lotti di un motore, studio di un altro). **Resta `[DERIVATO]`** e non
   decide niente: la sonda è lì apposta, e il caso C1 la fa fallire se la spazzata non è speciale.
2. **"Zero stop del retest entro 35 minuti."** È una proprietà del codice (arma a fine range, `MonitorRetest`), **non** una misura: è vera anche se il retest perdesse in modo orribile.
   Per questo non dico "il retest è immune": dico solo che il 01/10 non è un caso di spazzata d'apertura.
3. **La mia ipotesi sul gap (away falliscono di più) era sbagliata nel verso** (calcolo del 01/10 sul Nasdaq IS). L'ho scritta prima del calcolo e riportata com'è. Il verso opposto resta
   **ipotesi non confermata** (soglia `0,15%` scelta prima, **nessuna altra provata**; la CASSAFORTE non è stata letta per non bruciarla).
4. **Il netto delle posizioni tagliate dal tappo a 150 idx (-1.544 OOS, +1.094 IS)** l'ho guardato **prima** di scrivere l'attesa: l'attesa "il default va bene" è dunque *informata
   dai dati che il file dovrebbe giudicare*. L'ho dichiarato nel file; il criterio vero è la **concordanza IS/OOS**, non l'attesa.
5. **Il sell stop "sopra il bid" che fallisce in silenzio** è dedotto dal sorgente (r.266-270) e dalla regola di MT5; **non l'ho visto girare**. Il sentinella S1 di `03b` lo verifica sui dati.
6. **Non ho propagato nessuna cifra senza ricontarla**: le tabelle degli stop sono ricalcolate con script ripetibili sui per-trade in `risultati_archivio/R246/PERTRADE` e
   `ROUND_R246_INVERNO_2026-09-29/PERTRADE`; i conteggi (295 pos, 193/132, somme dei `net_profit`) tornano con i report di altri.

---

## COSA CHIEDO A CLAUDIO (il resto è già deciso dal repo)
1. **Prima di tutto, una cosa a costo zero**: diagnosticare perché la FASE 1b del DAX è fallita il 29/09 (buco 2): senza, la sonda non parte.
2. **Dare il via** ai 4 file (34 passate, ~7-14 min sul PC di backtest `DESKTOP-H4D7CAJ`, **mai sul VPS**) e a `R206a`: passano comunque dal cancello della sessione principale.
   **[Cancello 01/10]**: oggi i lanciabili sono **3** (`02, 03a, 03b`, 22 passate). `PRV_DAXAP_01` aspetta una **decisione di Claudio**: toppa di una riga
   della classe 294 sul sorgente vivo di `ABTG_DAX_Apertura_EU` (no-op in campo: le tre guardie valgono 0 in tutti i preset) **oppure** una copia di
   banco dell'EA con la toppa, mai in campo.
3. Una **firma sull'`open_time` nel per-trade** (modifica a `ExportTrades` di tutti gli EA): sblocca la durata ingresso→stop sui 5 EA della famiglia a costo zero in tester.
4. Se vuole **un meccanismo nuovo**: "stop come % del range d'apertura" è l'unico che dà una frontiera `stop >= k x rumore` **ex-ante** (nessun EA nostro lo ha). Dipende da cosa dice la sonda.
