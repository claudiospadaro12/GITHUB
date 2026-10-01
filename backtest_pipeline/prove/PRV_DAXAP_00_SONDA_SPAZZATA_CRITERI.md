# PRV_DAXAP_00 -- SONDA DELLA SPAZZATA D'APERTURA DEL DAX (criteri congelati PRIMA dei numeri)

**01/10/2026** · scritta dal `cercatore-parametri` · **SPECIFICA, NON ESEGUITA, nessun numero DAX letto per scriverla** ·
niente PF, niente equity, niente motore: **conta eventi di prezzo** (come `anatomia_aperture.py` /
`anatomia_movimenti_m5.py`). Gira sul **PC di backtest `DESKTOP-H4D7CAJ`**, mai sul VPS. La riga di lancio non
e' scritta qui: la scrive la sessione principale e passa dal cancello.

Domanda unica: **quanto spesso uno stop largo `k x ATR(M15 pre-apertura)` viene preso dalla spazzata dei primi 10/30
minuti dopo la cash del DAX, e quanto spesso poi il prezzo va comunque dalla parte della posizione?** Risposta a
due delle cinque domande del mandato del 01/10 (stop contro rumore d'apertura; segnale ex-ante) **con un campione
da centinaia di eventi invece di 12 stop**.

## 0. Perche' una sonda e non un round di PF
La sedia `770411` ha **14 posizioni OOS / ~27 totali in 21 mesi**: merito sospeso per costruzione, e gli stop pieni
sono **12** (misurati sui per-trade di R246, 01/10). Nessuna domanda di regime ("c'e' un segnale ex-ante?") si
risponde con 12 eventi. Il prezzo ha gli eventi: ~440 giornate BCM (2024.09.26-2026.06.30) piu' i 9 anni SANI di
HistData (2010-2018, `report/DAX_13_ANNI_2026-09-10.md`). **Uso firmato D-C = SOLO_PROVA_REGIME**: la sonda produce
**priori**, non candidati; nessuna cella si promuove da qui.

## 1. Prerequisiti (e sono buchi dichiarati)
1. **La corsa DAX della FASE 1b e' fallita il 29/09**: `risultati_archivio/ANATOMIA_MOVIMENTI_M5_2026-09-29/corsa_D30EUR.log`
   r.19-20 *"CALIBRAZIONE IMPOSSIBILE: nessun dato nelle finestre attese. Si ferma."* (file
   `C:\Users\Master\histdata_m1\D30EUR_M1.csv`). **Causa NON diagnosticata.** Ipotesi da verificare PER PRIMA, a costo
   zero: la convenzione oraria dei 9 anni sani (`02:00-15:00` New York, `DAX_13_ANNI` par. "quello che resta aperto"
   punto 1) contro le finestre che lo strumento si aspetta; la banda di prezzo `(4500, 14500)` r.148 dello strumento.
   `[INFERITO]`, non provato.
2. **Un export M1 BCM `D30EUR` 2024.09.26-2026.06.30** leggibile dallo stesso lettore: `[NON VERIFICATO]` che esista
   sul PC. Senza, la **cassaforte manca** e ogni esito resta "NON CONFERMATO fuori campione".
3. **Cross-check dell'ATR**: ATR(14) M15 ricostruito dalle M1 su 5 giorni a caso contro `iATR` del terminale, scarto
   <= 3%. Il 01/10 il valore atteso e' 67,75 / 2,5 = **27,1 idx** (`TRIAL_GIORNO1_ANALISI_2026-10-01.md` r.25).

## 2. Dati e fasi
- **Addestramento**: HistData D30EUR M1, 2010-2018 (9 anni SANI). Qui si **stimano i tassi**; nessuna soglia si ritocca.
- **Cassaforte**: BCM 2024.09.26 -> 2026.06.30 (un regime solo: toro, con l'episodio di aprile 2025). Valida le soglie
  gia' congelate qui sotto. **Referti in file distinti**, mai mescolati.
- Orologio: tutto si legge in **ora italiana** (cash = 09:00 CET/CEST, DST UE). Su FTMO la sedia arma 1 minuto prima
  della cash tutto l'anno (server = IT+1): il confronto naturale e' **cash-relativo**, non BCM-relativo.
  `OROLOGIO_BCM_2026-09-24.md`. Una settimana (25/10-01/11) e' `[NON VERIFICABILE]` (preset FTMO 770411, nota "CAMBIO DI
  ORA DI FINE OTTOBRE").

## 3. Quantita' per giorno (per giorni validi col cancello qualita' dell'anatomia)
- `R5`, `R10`, `R15` = (H-L) dei primi 5/10/15 minuti dopo la cash (punti indice). **Riferimento gia' misurato**: `R15`
  mediano **54,65 idx** (n=440, `MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` r.400); quantili 10/25/50/75/90% =
  **23,9 / 34,5 / 54,8 / 78,5 / 111,0** (ricalcolati il 01/10 da `studio_apertura/Studio_D30EUR.csv`, colonna
  `ampiezza_pt`/100). **R5 e R10 sono `[NON MISURATI]` su nessuna fonte.**
- `A_pre` = ATR(14) sulle ultime 14 barre M15 **chiuse** a `t0 - 1 min` (la barra 08:30-08:45 e' l'ultima), cioe'
  esattamente cio' che l'EA legge: `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` r.139 (handle), r.237 (`atr=AtrVal()`),
  r.286 (`sl=entry+atr*InpAtrSLmult`), r.412 (`CopyBuffer(hAtr,0,1,1,a)`: shift 1).
- `rho = 2,5 x A_pre / R15` del giorno: il rapporto stop/rumore che la sedia ha **davvero**.
- Gap = `apertura(t0) - chiusura cash precedente (17:30 CET)`; range del giorno prima = H-L 09:00-17:30.

## 4. L'evento sintetico (replica geometria 770411, SHORT; il LONG a specchio, regola dei due lati)
Box = `[00:00, 05:59]` ora italiana (= BCM 23:00-04:59 d'estate = FTMO 01:00-06:59 d'estate); livello `L` = minimo del box
`- 10 idx` (`InpBufferPoints=1000`); armo a `t0 - 1 min`; **fill** se il minimo M1 <= `L` in `[t0-1, t0+30 min]`
(cutoff del preset); prezzo di fill = `L` (lordo, senza slippage). Stop = `fill + s`, con `s = k x A_pre`,
**`k in {1,5; 2,5; 3,5; 4,0}`** (2,5 = la cella viva) **piu' una griglia assoluta `s in {40,50,60,70,80,100,120,150}` idx**.
Barra M1 che tocca stop e bersaglio insieme = **stop** (pessimistico, dichiarato).
- `S10`, `S30` = primo tocco dello stop entro `t0+10` / `t0+30` min.
- `Rv` ("spazzata e gira", il caso del 01/10: stop alle 10:06:32 poi -145 punti = 2,1R) = dopo uno `S30`, il prezzo tocca
  `fill - 2 s` **prima** del flat 18:30 IT.
- Si riportano `P(S10|fill)`, `P(S30|fill)`, `P(Rv|S30)`, per anno, per lato, per `k`/`s`.

## 5. Priori gia' in casa (scritti qui perche' le ATTESE devono nascere da misure, non da memoria)
- 28 posizioni "come FTMO" del 770411 (d0 estate + d+1 inverno, per-trade R246): **fill 28; stop pieni 12; entro 10 min
  dalla cash 1; entro 30 min 5** -> `P(S30|fill) = 5/28 = 17,9%` (Wilson 95% ~ 8-36%), `P(S10|fill) = 3,6%`.
  **n=12 stop: INDIZIO.** Stop mediano della sedia **57,7 idx** (IQR 44,9-77,8), cioe' **~1,06 x R15 mediano**
  `[DERIVATO da lotti, vedi report]`.
- Retest 770101 (295 posizioni "come FTMO"): **45 stop pieni, il primo a +53 min dalla cash, solo 1 entro 60 min**:
  per costruzione (entra dopo il range di 35') non puo' essere spazzato prima di +35.
- Studio breakout cieco, range 15', stop = bordo opposto (D30EUR, 264 perdenti): entro 10 min dall'**ingresso** 7,6%,
  entro 30 min **26,1%** (Dow 11,2 / 36,7; Nasdaq 10,6 / 40,4).
- Nasdaq 2010-2020, primo tocco: il 68,5% dei primi tocchi e' "falso entro 15 min" (`falso15`, 1698 su 2480).

## 6. Le IPOTESI, congelate ORA con direzione, motivo e soglia
- **H-A (lo stop non segue il regime del giorno).** Spearman(`A_pre`, `R15`) sui giorni `<= 0,60`. Motivo: `A_pre` e'
  fatto di barre notturne/pre-apertura, `R15` di barre di cash. Banda: `<= 0,60` H-A vera · `0,60-0,75` ambigua ·
  `>= 0,75` H-A FALSA (l'ATR notturno e' un buon proxy: allora il problema non e' la larghezza). Se H-A e' vera, "k x
  ATR notturno" e' la formula sbagliata e "k x rumore d'apertura del giorno" non e' costruibile ex-ante: serve un altro
  ingresso (la sedia dovrebbe armare DOPO aver visto i primi minuti, vedi PRV_DAXAP_03).
- **H-B (la frontiera "stop >= k x rumore" esiste).** Attesa in addestramento: `P(S30|fill)` a `k=2,5` in **10-30%**
  (coerente col prior 17,9%) e **dimezzata** (`<= 0,5 x`) a `k=4,0` o a `s >= 2 x R15 mediano (~110 idx)`. Se `P(S30)` a
  `k=4,0` resta `>= 25%`: **la spazzata non e' un problema di larghezza** (e' una inversione) e la frontiera non
  esiste: si scrive cosi'. Il costo di uno stop largo (lotto piu' piccolo, parziali piu' lontane) si paga in R206a, non qui.
- **H-C (gap).** **A due code.** Prior preso da un'altra serie e dichiarato: **Nasdaq 2010-2020 (addestramento
  dell'anatomia), 1.808 giorni con |gap| >= 0,15%**: i primi tocchi **verso il riempimento del gap** falliscono (`falso15`)
  il **70,0%**, quelli **lontani dal riempimento** il **64,2%**: differenza **-5,8 punti, IC95 bootstrap [-10,0 ; -1,4]**
  (calcolo del 01/10 sulle sole righe `fase=IS`, `stato=OK`; la CASSAFORTE non e' stata letta). La mia ipotesi di partenza
  (gap-fill: i tocchi *lontani* dal riempimento falliscono di piu') e' stata **SMENTITA nel verso**. Per il DAX, short =
  *verso il riempimento dopo un gap-up*. Attesa: **`P(S30 | gap-up >= 0,25 x range del giorno prima)` superiore di
  >= 3 punti a `P(S30 | gap-down >= 0,25 x ...)`** (stesso segno del prior Nasdaq). Segno opposto di >= 3 punti = "invertita";
  entro 3 punti = "nulla". Soglia `0,25` fissata ora: **nessuna altra soglia si prova** (niente scansione).
  Riferimenti esterni per il *motivo*: statistiche di riempimento dei gap su NQ 2015-2025 (tradingstats.net, solo snippet
  del motore di ricerca, pagina bloccata dal proxy `[NON VERIFICATO alla fonte]`) e il titolo MDPI JRFM 18(3):132 (gap di
  fine settimana: **solo titolo del risultato di ricerca, non letto**).
- **H-D (macro).** Giorni con un dato alto impatto EUR/DE in `[t0-15, t0+30]` min (es. PMI flash 09:30 CET) hanno
  `P(S30)` **>= 1,5 x** la base. Solo cassaforte BCM (il calendario HistData non esiste). Copertura di `abtg_news.csv`
  sul periodo `[NON VERIFICATA]`: se manca, H-D si dichiara NON MISURATA.
- **ESCLUSO PER NOME: giorno della settimana.** Nessun meccanismo che lo preveda: provarlo sarebbe ricerca di segnali a
  caso (mandato 01/10, regola del 19/08).

## 7. I controlli che devono POTER FALLIRE (scritti prima)
- **C1 -- controllo a orario casuale** (la lezione del REGISTRO r.1219: una sonda di conteggio porta il suo controllo).
  Stessa geometria armata a **07:00 IT** (box fino alle 05:59, quindi stessa definizione di `L`), finestra 30 min.
  Se `P(S30)` alle 09:00 **non supera di >= 1,5 x** quella delle 07:00, "la spazzata d'apertura" **non e' speciale**: e'
  solo rumore a 30 minuti, e tutta la domanda 1 va riscritta come scala di volatilita', non come apertura.
- **C2 -- scambio (shuffle).** `A_pre` permutato fra i giorni: `rho_s` deve cadere a ~0 (+-0,1). Se no, il calcolo e' sbagliato.
- **C3 -- due lati.** Ogni numero a due lati; un lato che dice l'opposto dell'altro si riporta cosi'.
- **C4 -- coerenza per anno.** Un'affermazione di addestramento vale solo se il segno regge in **>= 7 dei 9 anni**.
- **C5 -- trasferimento.** Addestramento e cassaforte devono stare entro **30% relativo** sulle `P(S30)`; oltre, "non si
  trasferisce" (l'ampiezza d'apertura DAX contro la legge radice-T cambia fra regimi: x1,56 oggi, `MAPPA_COSTO` r.621).
- **n minimi**: `>= 150` eventi per cella per un'affermazione; `50-149` indizio; `< 50` `[NON MISURATO]`.

## 8. Cosa questa sonda NON e'
Non e' un backtest (niente PF, costi, slippage, parziali, trailing). Non promuove niente. Non tocca preset, EA, taglie,
conti. Un tasso di spazzata **non e' un edge**: dice quanto e' largo il rumore, non se una sedia guadagna.

## 9. Costo
**Zero minuti di tester.** Lettura in streaming di un CSV M1: l'anatomia NASUSD ha letto 5,23 M barre
(`corsa_NASUSD.log`); il DAX 2010-2018 ha ~9 x 250 giorni x 780 minuti ~ 1,8 M righe `[STIMA]`, quindi stesso ordine o meno.
**Tempo effettivo `[NON MISURATO]`** (il log non lo riporta).

## 10. A cosa serve l'esito (e a cosa no)
- `H-B` dice **dove** guardare in `R206a` (`InpAtrSLmult`): se la frontiera esiste, le celle `m >= 3,0` sono quelle da leggere;
  se non esiste, `R206a` e' un controllo di rischio e basta.
- `H-A` dice se serve un meccanismo che **veda** l'apertura prima di fissare lo stop (non un parametro: un EA diverso,
  decisione e codice di altri).
- `H-C`/`H-D` dicono se vale la pena di dare all'EA un input ex-ante (gap, evento): **solo** se passano in addestramento
  E in cassaforte. Altrimenti il risultato onesto e' *"nessun segnale ex-ante misurabile"*.
