# GBA (ABTG_GoldBreakoutATR v1.10, magic 775800) - PROPOSTA DEL RISK MANAGER: gestione della posizione e tetti di rischio (10/10/2026)

Autore: agente Risk Manager (rischio e gestione della posizione). **BOZZA, NON passata dal cancello** (controllo-preventivo non ha letto questo file): non e' una consegna a Claudio finche' il cancello non risponde PASS. **Solo carta e analisi su deal gia' presenti**: nessun backtest lanciato, nessun EA/preset/conto/forward toccato, nessun file prova scritto. I parametri di RISCHIO e di TAGLIA (tetti, lotti, %) sono di Claudio: qui si PROPONE e si MISURA ex-post, non si decide.
Etichette: **[MISURATO]** ricalcolato da me sui deal di R1A/R1B (zip in `backtest_pipeline/risultati_archivio/`) o letto dal sorgente | **[DERIVATO]** conto su numeri misurati | **[SIMULATO]** esce da un modello senza prezzi (sez. 3), mai una misura | **[INFERITO]** ragionamento | **[NON MISURATO]** buco | **[DICHIARATO]** detto da terzi, mai un criterio.
Fonti: `mql5/Experts/ABTG_GoldBreakoutATR.mq5` (SHA256 1381E3DC9B4B..., identico in R1A e R1B secondo i RIEPILOGO_R0) | `backtest_pipeline/risultati_archivio/GBA_R0_R1A_20261010/GBA_R0_R1A.zip` (933 operazioni, 3 tranche 2026) | `.../GBA_R0_R1B_20261010/GBA_R0_R1B.zip` (celle C010/C020/C035: 3.918 / 6.949 / 7.420 operazioni) | `report/GBA_R2_PIANO_2026-10-10.md` (caselle 3-5) | `report/GBA_R0_R1A_LETTURA_2026-10-10.md`, `report/GBA_R0_R1B_LETTURA_2026-10-10.md` | `report/AUDIT_USCITE_2026-09-09.md` (Tabella A e B) | `backtest_pipeline/leggi_gba_uscite.py` (lettore, usato come libreria) | `report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md` (valori di Emiliano, [DICHIARATO]).
**Riproducibilita'**: i numeri della sez. 4 e 6 escono dal lettore `leggi_gba_uscite.py` piu' piccoli script di analisi che NON ho committato (il mandato dice: solo questo path). Il simulatore nullo e' descritto per intero in appendice A (parametri, seed): chi lo rifa' deve ritrovare i numeri entro l'errore di Monte Carlo dichiarato. **Se Claudio vuole gli script nel repo, e' un commit a parte (e passano dal cancello).**

---

## 0. In dieci righe

1. **Il conto**: con win rate 26,5% e payoff 2,37 il PF_V e' 0,855. Per PF_V = 1,0 servono **+58 EUR a operazione** (= +0,044 R sul rischio medio di 1.302 EUR). Cioe' o win rate 29,6% a payoff invariato (+3,1 punti), o payoff 2,77 a win rate invariato (+17%), o perdita media da 539 a 461 EUR (-14,5%). Per 1,1 servono 31,7% o payoff 3,05; per 1,3 servono 35,4% o payoff 3,61. [DERIVATO, sez. 1]
2. **Costo**: azzerare spread e commissione (23,5 EUR a operazione) porta il PF_V a 0,914, non a 1,0. Nessun intervento sul costo salva questa cella (conferma il piano R2). [DERIVATO]
3. **Fatto nuovo, e cambia la lettura**: sotto l'ipotesi che il prezzo sia una martingala, **qualunque regola d'uscita lascia l'aspettativa uguale a -(spread + commissione)** (teorema di arresto opzionale); l'uscita rimodella la distribuzione (win rate, payoff, drawdown), non crea valore. Il test diretto sui deal: **deriva lorda per operazione = -34 +- 38 EUR sulla REPL (z -0,9); -9 +- 7 EUR su C035 (n 7.420); -10 +- 8 su C020**. Nessuna e' positiva, nessuna e' significativamente negativa; il lato SELL e' negativo in tutte e tre le celle larghe (z -2,0 / -2,2 / -2,1, celle non indipendenti), il BUY e' a zero (z +0,2 / +0,4 / +0,4). [MISURATO, sez. 4]
4. **Per arrivare a PF_V = 1,0 servirebbe una deriva lorda di almeno +23,5 EUR per operazione**: sulle celle larghe e' esclusa a 4,5-4,6 sigma *per l'uscita attuale*. Resta aperta una sola porta: che un'altra uscita realizzi una deriva diversa perche' il prezzo non e' una martingala a certi orizzonti (continuazione dopo il ritracciamento). **E' l'unica cosa che R2U puo' scoprire.** [DERIVATO]
5. **Il BE che "morde nel 59%" non e' un'anomalia**: un modello senza deriva calibrato sulle quote di uscita riproduce 64% armato e 54% di ritorno al pareggio (misurato 59,3% e 54,1%). Il BE taglia la perdita lorda per operazione del 21% e la deviazione standard del 10% a PF invariato (+0,003): **e' una manopola di forma, non di merito**. Quello che costa davvero e' il BE ANTICIPATO (trigger 0,5 ATR: PF -0,05 con il modello nullo, -0,08 con una deriva). [SIMULATO, sez. 3]
6. **Potenza**: a n = 933 per cella il rumore appaiato sul PF e' 0,04-0,09, e le differenze attese fra celle d'uscita sono +-0,01-0,05. **R2U sulla sola REPL non puo' distinguere quasi nessuna coppia di celle.** Si puo' alzare la potenza di 2,7 volte facendo girare le stesse tre uscite anche sulla cella C020 (n 6.949) come *diagnostica di profilo*, non come candidato (sez. 5, P3).
7. **SL/TP dinamici**: il TP non esiste (TP = 0 in tutte le chiamate, r.653/659/806 del sorgente). Lo SL iniziale (2,5 ATR) e il trailing (2,5 ATR) hanno la **stessa distanza**: dopo il primo movimento lo stop effettivo e' il trailing, e `InpSL_ATR` e' inerte. **Trappola da NON fare**: alzare `InpSL_ATR` per "passare" la frontiera `stop >= 40 x spread` e' fittizio (la distanza reale resta kTrail x ATR). [MISURATO nel codice + SIMULATO]
8. **Tetti**: `InpMaxDailyLoss` e `InpMaxTradesPerDay` esistono gia' (default 0). Letti ex-post su R1A: un tetto giornaliero a 1-3 R porta il giorno peggiore da -6,9 R a -2,5/-4,3 R senza cambiare il merito per operazione (PF 0,78-0,87 contro 0,855, dentro il rumore). **Il "tetto 1 al giorno" (PF 1,29) e' un'ipotesi di REGIME, non una cella**: permutazione p = 0,014 sul totale, ma p = 0,0019 in T3 e 0,64 / 0,33 in T1 / T2, e sulle prime operazioni delle tre celle larghe di R1B (altri insiemi di operazioni, stessi giorni) il segno torna solo in T3. [MISURATO, sez. 6]
9. **Le 5 priorita'** (sez. 5): **(1)** letture dei tetti ex-post, 0 passate; **(2)** BE spento + ATR fisso + tempo spento (controllo positivo), 9 passate; **(3)** asse kTrail a 4 punti letto come PENDENZA (1,5 / 2,5 / 3,5 / spento), 9 passate; **(4)** amplificatore di potenza su C020, 9 passate; **(5)** BE 0,5 / 1,5, 6 passate. Totale 33 passate = 26-35 minuti di tester (43-69 minuti di orologio).
10. **Onesta' di fondo**: la probabilita' che una di queste celle esca dal rumore *e* superi S8 (PF_V > 1,03) e S4 (>= 1,5) e' bassa, e va scritta cosi'. Se non esce, la risposta e' **"il default va bene, e nessuna uscita lo salva"**, ed e' un risultato che chiude la casella 3 del certificato, non un fallimento. **Niente "morto"**: restano le caselle 4 (simboli) e 5 (TF).

---

## 1. IL CONTO MATEMATICO: quanto devono muoversi win rate, payoff e costo

Punto di partenza [MISURATO, R1A, 933 operazioni, netto = profitto + commissioni + swap, 1,00 lotto]: 247 vincenti (26,5%) con media +1.280 EUR, 686 perdenti (incluse le 299 uscite a BE a -0,015 R) con media -539 EUR; payoff 2,373; PF_V 0,855; media per operazione -57,7 EUR; rischio nominale medio all'ingresso 1.302 EUR (mediana 1.112). Per operazione: lordo dei vincenti 339,0 EUR, lordo dei perdenti 396,7 EUR.
**Identita' usata**: PF = vincite / perdite, quindi PF = 1 + (netto per operazione) / (perdite per operazione) = 1 + netto / 396,7. **Ogni 4 EUR a operazione valgono 0,01 di PF.**

### 1.1 Cosa serve per un dato PF_V (una leva alla volta, tutto il resto fermo) [DERIVATO]

| PF_V target | win rate necessario (payoff 2,37) | payoff necessario (win rate 26,5%) | payoff a win rate 30% / 35% | +EUR a operazione (solo sui vincenti) | perdita media da 539 a... |
|---|---|---|---|---|---|
| 1,0 | **29,6%** (+3,1 pt) | **2,77** (+17%) | 2,33 / 1,86 | +58 | 461 (-14,5%) |
| 1,1 | 31,7% (+5,2 pt) | 3,05 (+29%) | 2,57 / 2,04 | +97 | 419 (-22%) |
| 1,3 | 35,4% (+8,9 pt) | 3,61 (+52%) | 3,03 / 2,41 | +177 | 355 (-34%) |
| 1,5 | 38,7% (+12,2 pt) | 4,16 (+75%) | 3,50 / 2,79 | +256 | 307 (-43%) |

(Il piano R2 scrive "+210 EUR per PF 1,5": e' il calcolo del lettore con l'aggiunta distribuita su tutte le operazioni, vincenti e perdenti insieme; la mia colonna e' il primo ordine sulle sole vincenti. Le due convenzioni danno 210 e 256: nessuna contraddizione, due modi di spendere gli stessi euro.)

### 1.2 Il costo [DERIVATO]
Scomposizione della media per operazione, convenzione "martingala" (il livello dello stop NON e' il prezzo giusto: lo slittamento e' gia' dentro il processo, vedi 1.3): **-57,7 = -34,2 (deriva lorda) -19,7 (spread d'ingresso, un lato) -3,4 (commissione) -0,4 (swap)**.
- Azzerare spread e commissione (-23,5 EUR) porta il PF_V a **0,914**. Non basta.
- Per PF_V = 1,0 serve una deriva lorda di **almeno +23,5 EUR per operazione** (= +0,018 R, circa 0,24 EUR per oncia), cioe' **+57,7 sopra l'osservato**.
- Il piano R2 (sez. 1.5) usa la convenzione "lordo di spread, commissione E slittamento" e trova -17,6 EUR (-0,014 R). **Le due cifre differiscono di 16,6 EUR, che e' lo slittamento sugli stop (-16,8 EUR a uscita)**: e' una convenzione contabile, non una contraddizione, e *nessuna delle due si distingue da zero* (errore standard 38 EUR sulla REPL). La scelta ha un'unica conseguenza pratica, in 1.3.

### 1.3 Perche' lo slittamento non e' un costo in piu' (e perche' conta) [DERIVATO + INFERITO]
Se il prezzo e' una martingala, una regola d'arresto qualsiasi (stop, trailing, tempo) esce al prezzo del tick in cui scatta, e il valore atteso di quel prezzo e' il prezzo d'ingresso. Il fatto che il tick sia 0,09-0,17 USD oltre il livello dello stop e' la manifestazione di questo, non una tassa aggiuntiva. Quindi sotto H0 l'aspettativa e' **-(spread + commissione) = -23,5 EUR**, non -40. L'osservato e' -57,7 +- 38: **non discrimina fra -23,5 e -40** (z -0,9 / -0,5). [NON DISCRIMINATO fra le due convenzioni.]
**Conseguenza**: gli interventi "sul costo" disponibili (filtrare di piu' lo spread, meno slittamento) valgono al piu' lo spread e la commissione (23,5 EUR = 0,06 PF), e gia' R1B ha mostrato che allargare il filtro di spread non cambia il PF (0,83 / 0,82 / 0,82).

### 1.4 Quanta deriva basta per cambiare il PF, e quanto campione serve per vederla [DERIVATO]
Deviazione standard del profitto lordo per operazione: 1.169 EUR (0,90 R). Per vedere con z = 2 una deriva di **+24 EUR** (= la soglia del PF 1,0) servono **~9.200 operazioni**; per +63 EUR (soglia PF 1,1) ~1.400; per +10 EUR ~55.000. R1A ne ha 933 (a 2 sigma ci vede solo derive > 75 EUR, cioe' PF > ~1,13); R1B ne ha 7.420 nella cella C035 (errore standard 7,3 EUR, rischio medio 578 EUR: a 2 sigma vede derive > ~15 EUR). **Per questo la cella REPL da sola non puo' rispondere "esiste una deriva da PF 1,0?"**, e per questo propongo l'amplificatore (P3).

---

## 2. COME E' FATTA OGGI LA GESTIONE (dal sorgente) [MISURATO nel codice]

| elemento | cosa fa | riferimento |
|---|---|---|
| TP | **assente**: `trade.Buy/Sell(..., sl, 0.0, ...)`; `PositionModify(tk, sl, curTP)` mantiene TP = 0 | GbaApri r.653/659, GbaGestisci r.806 |
| SL iniziale | `InpSL_ATR` (2,5) x ATR della barra di segnale, dal prezzo d'ingresso (ask / bid) | GbaApri r.631 |
| Trailing | dal PRIMO tick: stop = estremo dall'ingresso -/+ `InpTrail_ATR` (2,5) x ATR dell'ultima barra chiusa (`InpTrailAtrMode` 0) o della barra di segnale (1); si sposta solo a favore, di almeno mezzo tick | GbaSLProposto r.329, GbaSLMigliore r.360 |
| Breakeven | quando `prezzo - ingresso >= InpBE_TriggerATR x ATR`, stop = ingresso +/- `InpBE_OffsetATR` x ATR; vince il piu' favorevole fra trailing e BE | GbaBeArmato r.319 |
| Tempo | chiusura a mercato dopo `InpTimeExitBars` (48) barre | GbaUscitaTempo r.380 |
| Parziali | **non esistono** | - |
| Perdita giornaliera | `InpMaxDailyLoss` (valuta del conto, 0 = spenta): blocca i NUOVI ingressi quando pnl chiuso del giorno server <= -tetto | r.689-690, GbaGiornoBloccato r.257 |
| Operazioni al giorno | `InpMaxTradesPerDay` (0 = nessun limite): blocca i nuovi ingressi quando le aperte oggi >= tetto | r.692-693, GbaTroppeOggi r.276 |

**Conseguenze che il piano non scrive** [DERIVATO dal codice]:
- Con kSL = kTrail = 2,5 la distanza dello stop e' la stessa dall'ingresso: al primo rialzo dell'estremo oltre lo spread (0,21 USD) lo stop effettivo diventa il trailing. **`InpSL_ATR` >= `InpTrail_ATR` e' inerte** (simulazione: dPF +0,001, deviazione appaiata 0,004). La quota di uscite allo SL iniziale (1,1%) e' esattamente "il prezzo non e' mai salito oltre lo spread prima di scendere di 2,5 ATR".
- **Trappola della frontiera**: `stop/spread minimo garantito = InpSL_ATR / InpSpreadMaxATR` (messaggio del codice, r.913). Alzare kSL a 3,5 porterebbe C010 da 28,2x a 39,5x "sul foglio", ma lo stop REALE resta kTrail x ATR = 2,5 ATR: la frontiera va letta su `min(kSL, kTrail)`. Chi alzasse solo kSL per far passare una cella FRA farebbe un errore di misura. (Alzare *entrambi* a 3,5 e' un'altra cosa: allarga lo stop vero, ed e' coperto dall'asse kTrail.)
- **Il rischio realizzato non e' il rischio nominale**: perdita media realizzata per perdente 539 EUR = 0,41 R; **peggiore operazione -1,08 R** (nessuna oltre 1,1 R in 933); 1,1% delle uscite allo SL iniziale. Se un giorno il lotto sara' a rischio % (`InpLotMode = 1`), il rischio per operazione e' fissato sullo SL nominale ma quello vero e' circa meta'.

---

## 3. IL MODELLO NULLO: cosa sa dire e cosa no [SIMULATO]

**Perche' esiste**: il mandato chiede "attesa numerica scritta PRIMA dei numeri per ogni proposta". Per le uscite, un'attesa a mano ("il BE spento fara' 0,70-1,00") non ha nessun ancoraggio. Il modello da' un'attesa derivata: un prezzo SENZA deriva (martingala), con le regole d'uscita del sorgente, costi d'ingresso reali, calibrato su statistiche aggregate di R1A.
**Cos'e'** (parametri completi in appendice A): passeggiata casuale a passi di 1 secondo; volatilita' lognormale per barra e per operazione; ATR(14) calcolato sulle barre simulate; ATR d'ingresso estratto dai 933 ATR veri di R1A; spread 0,21 USD, commissione 0,034 USD/oz; stop, trailing (ATR ultima barra chiusa), BE e tempo come nel sorgente.

### 3.1 Calibrazione contro R1A [SIMULATO vs MISURATO]
| statistica (uscita attuale) | modello nullo | R1A misurato |
|---|---|---|
| quota SL iniziale | 2,3% | 1,1% |
| quota BE | 34,9% | 32,0% |
| quota trailing sotto l'ingresso | 33,4% | 39,7% |
| quota trailing in profitto | 28,7% | 26,4% |
| quota tempo | 0,6% | 0,9% |
| armato BE / di questi tornati a BE | 64,2% / 54,4% | 59,3% / 54,1% |
| win rate / payoff | 28,6% / 2,32 | 26,5% / 2,37 |
| durata mediana / media (min) | 7,0-7,2 / 9,6 | 7,4 / 10,0 |
| P(R uscita >= 1) / >= 2 / >= 3 | 9,6% / 3,2-3,5% / 1,4% | 9,6% / 3,8% / 1,6% |
| PF_V | **0,927** (+- 0,02 MC) | **0,855** |
**Lettura**: struttura, durata e coda sono riprodotte; il modello sbaglia di 5-7 punti la divisione fra "sotto l'ingresso" e BE, e di 1,2 punti lo SL iniziale. **Il PF osservato sta 0,07 sotto il modello nullo = -0,7 deviazioni** (rumore per giorno 0,085-0,107): compatibile.
**Cosa NON dice** (contro-esempio costruito): la corrispondenza della forma NON prova l'assenza di deriva, perche' livello di volatilita' e deriva si compensano nella forma (con volatilita' dopo l'ingresso 0,9x anziche' 1,0x il modello riproduce comunque P(>=1R) = 8,9-10,2%). La prova dell'assenza di deriva e' il test diretto di sez. 4, non questa tabella.

### 3.2 L'alternativa: deriva costante di continuazione [SIMULATO]
Stesso modello con una deriva `mu` (in unita' di deviazione standard per minuto) nella direzione dell'ingresso. PF del default: mu = 0 -> 0,927; **0,005 -> 0,974; 0,01 -> 1,034; 0,02 -> 1,140** (PF = 1,0 per mu ~ 0,0075, interpolato). Una deriva di 0,0075 sigma al minuto e' 0,024 deviazioni standard su 10 minuti: **minuscola**, ed e' la soglia fra "0,93" e "1,0".
Limite: e' UNA alternativa (continuazione che dura 48 minuti, uguale in ogni operazione). Una continuazione che si esaurisce in 3 minuti, o presente solo in una fascia oraria, favorirebbe uscite diverse da queste: non e' modellata.

### 3.3 Effetto di ogni regola d'uscita [SIMULATO; N = 24.000 operazioni per H0, 16.000 per H1, stessi percorsi per tutte le varianti (numeri casuali comuni)]
dPF = delta PF, cioe' differenza di PF rispetto al default sugli *stessi* percorsi. "sd app." = deviazione standard della differenza su un campione di 933 operazioni appaiate (bootstrap). Colonne H1: media dei risultati a mu 0,005 e 0,01 (default ~ PF 1,0) | mu 0,02 (default PF 1,14).

| variante (input) | dPF H0 | dPF H1 (PF~1,0) | dPF H1 (mu 0,02) | sd app. (n 933) | win rate / payoff ancorati su R1A | durata media ancorata (min) |
|---|---:|---:|---:|---:|---|---|
| BE spento (`InpBE_TriggerATR` 99) | +0,003 | -0,008 | -0,020 | 0,048 | 34% / 1,67 | 12,1 |
| BE trigger 0,5 | **-0,053** | -0,075 | -0,084 | 0,071 | 18% / 3,7 | 7,2 |
| BE trigger 1,5 | +0,005 | -0,003 | -0,008 | 0,038 | 31% / 1,90 | 11,4 |
| BE trigger 2,0 | +0,005 | -0,007 | -0,017 | 0,047 | 34% / 1,71 | 12,0 |
| BE offset +0,25 ATR (trigger 1,0) | -0,002 | -0,008 | -0,010 | 0,037 | 61% / 0,55 | 9,1 |
| ATR fisso (`InpTrailAtrMode` 1) | +0,003 | +0,022 | +0,046 | 0,053 | 26% / 2,49 | 13,0 |
| kTrail 1,5 | -0,028 | -0,061 | **-0,119** | 0,084 | 33% / 1,74 | 5,2 |
| kTrail 2,0 | -0,003 | -0,013 | -0,043 | 0,059 | 30% / 2,05 | 7,6 |
| kTrail 3,5 | -0,008 | +0,014 | +0,049 | 0,064 | 21% / 3,21 | 13,5 |
| kTrail 5,0 | +0,002 | +0,038 | +0,101 | 0,082 | 15% / 4,77 | 15,6 |
| **trail spento (`InpTrail_ATR` 0)** | +0,007 | +0,044 | **+0,119** | 0,086 | 11% / 6,35 | 16,5 |
| kSL 3,5 (inerte) | +0,001 | 0,000 | +0,001 | 0,004 | = default | = default |
| kSL 1,5 (frontiera 35,3x: FRA) | -0,010 | -0,011 | -0,023 | 0,046 | 24% / 2,65 | 8,7 |
| tempo spento (0) | -0,001 | -0,003 | -0,003 | **0,005** | = default | = default |
| tempo 24 barre | -0,001 | -0,005 | -0,017 | 0,028 | = default | 9,3 |
| tempo 12 barre | +0,007 | -0,009 | -0,047 | 0,053 | 30% / 2,07 | 7,5 |
| TP 2,5 ATR (1 R) | -0,010 | -0,029 | -0,070 | 0,067 | 28% / 2,22 | 7,2 |
| TP 5 ATR (2 R) | -0,001 | -0,008 | -0,025 | 0,044 | = default | 9,0 |
| trailing armato dopo +1 ATR | +0,007 | +0,015 | +0,024 | 0,043 | 29% / 2,15 | 11,9 |
| trailing armato dopo +2,5 ATR | +0,010 | +0,017 | +0,034 | 0,045 | 29% / 2,10 | 12,3 |
| parziale 50% a 1 R | -0,005 | -0,014 | -0,035 | 0,033 | 28% / 2,23 | 10,0 |
| parziale 33% a 0,5 R | -0,007 | -0,015 | -0,036 | 0,026 | 48% / 0,93 | 10,0 |
Quote di uscita ancorate (default: SL 1,1 / BE 32,0 / sotto 39,7 / profitto 26,4 / tempo 0,9): **BE spento** -> BE 0, sotto ~67, profitto ~34; **trail spento** -> SL iniziale ~27, BE ~55, profitto 0 (non esiste), tempo ~14; **ATR fisso** -> SL iniziale ~2-6, sotto ~36, profitto ~21; **BE 0,5** -> BE ~55, sotto ~26; **BE 1,5** -> BE ~16, sotto ~51; **kTrail 3,5** -> SL iniziale ~20, BE ~43, sotto ~16. (Ancoraggio additivo: valore reale del default + differenza del modello.)
**Tre cose che il modello dice e che il piano non dice**:
1. **Sotto H0 le varianti d'uscita hanno dPF entro +-0,01 quasi dappertutto** (le uniche negative apprezzabili: BE 0,5, kTrail 1,5, TP a 1 R). **Cambiano la FORMA** (win rate 11%-61%, payoff 0,55-6,35, deviazione standard del profitto 10-20 USD, perdita lorda 3,1-5,4 USD) **non il merito.**
2. **Sotto una deriva reale l'ordine e' monotono nella DURATA DELLA TENUTA**: spento > 5,0 > 3,5 > 2,5 > 2,0 > 1,5 per kTrail. E' la **pendenza** a distinguere H0 da H1, non una cella: spento meno 1,5 vale 0,035 sotto H0 e **0,24** a mu 0,02.
3. **Lo stesso numero (dPF +0,044 a PF ~ 1,0) ha un rumore appaiato di 0,086 su 933 operazioni: z = 0,5.** A n = 6.949 (C020) il rumore scala a 0,032 (z = 1,4 a PF ~1,0; z = 3,7 a mu 0,02).

### 3.4 Dove il modello e' sicuramente sbagliato (e quindi cosa non usare)
Non modella: la sequenza reale degli ingressi (una posizione per volta: il blocco dei segnali), lo spread variabile (0,17-0,27 USD per ora), la pausa delle 22:00 e i buchi, le notizie, la volatilita' a grappolo oltre un fattore per operazione, la dinamica dell'ATR dopo l'ingresso (nel modello e' neutra), l'asimmetria BUY/SELL, il lag di esecuzione (il tester ha `ExecutionMode = 0`, zero latenza). Le **quote** di uscita hanno un errore del modello di 5-7 punti; il **PF** del modello nullo e' 0,07 sopra l'osservato. **Si usi il modello per le DIFFERENZE e per le forme, non per i livelli.**

---

## 4. LA MISURA DIRETTA DELLA DERIVA SUI DEAL [MISURATO, POST-HOC]

Metodo: per ogni operazione `deriva = profitto del deal (senza commissione e swap) + spread d'ingresso x 100 oz x cambio`, con il cambio ricavato come nel lettore (`perdita a SL / (2,5 x ATR x 100)`) e lo spread preso dalla riga `[GBA] BUY/SELL ... | spread z` del giornale. Sotto l'ipotesi nulla il valore atteso e' 0 qualunque sia l'uscita (1.3). Un lato di spread solo (l'uscita a bid/ask non e' corretta per lo spread di uscita: [NON MISURATO], ordine di grandezza < 3 EUR).

| cella | n | deriva lorda EUR/operazione (errore std, z) | in R (rischio medio) | BUY | SELL | PF_V |
|---|---:|---|---:|---|---|---:|
| REPL (R1A) | 933 | **-34,2** (38,3; -0,89) | -0,026 | -16,0 (49,5; -0,32) | -50,6 (57,5; -0,88) | 0,855 |
| C010 (R1B) | 3.918 | -17,5 (12,6; -1,39) | -0,022 | +3,5 (17,4; +0,20) | **-37,3** (18,1; **-2,05**) | 0,830 |
| C020 (R1B) | 6.949 | -10,2 (7,7; -1,34) | -0,017 | +4,2 (10,7; +0,39) | **-24,1** (10,9; **-2,21**) | 0,819 |
| C035 (R1B) | 7.420 | -9,0 (7,3; -1,23) | -0,016 | +4,5 (10,2; +0,44) | **-21,8** (10,4; **-2,10**) | 0,817 |
Per tranche (REPL): T1 -31 (z -0,42), T2 -59 (z -1,05), T3 -24 (z -0,42). Per tranche (C035): T1 -10,3 (z -1,26), T2 -11,9 (z -1,20), T3 -4,5 (z -0,25): segno concorde in 3 su 3.
**Cosa dice** [DERIVATO]:
- Nessuna cella ha una deriva lorda positiva; il limite superiore a 95% di C035 e' **+5,3 EUR** contro i **+24,4 EUR** che servono al PF 1,0 (distanza 4,6 sigma); per C020 +4,9 contro 24,4 (4,5 sigma). **Con l'uscita attuale, PF_V = 1,0 sulle celle larghe e' escluso.**
- Il lato SELL e' negativo in tutte e tre le celle larghe (z da -2,05 a -2,21). **Le tre celle non sono tre prove**: sono gli stessi giorni con insiemi di operazioni parzialmente sovrapposti. Il BUY e' a zero. Il lettore R1B lo vedeva gia' come PF (0,91 contro 0,76); qui e' in termini di deriva. Perche' (mercato in salita nel campione? asimmetria del lato?) e' [NON MISURATO]; la regola dei due lati resta: si misurano sempre entrambi. Spegnere lo SHORT NON e' una proposta di questo documento (parametro d'ingresso su un motore sotto 1).
- Sulla REPL da sola (SE 38 EUR) non si dice nulla: la deriva di +24 non e' esclusa a 1,5 sigma.

---

## 5. LE PROPOSTE, ORDINATE PER BENEFICIO / COSTO

Legenda costo: P = passate del tester (R1A: 48 s l'una a tick reali, 80 s di orologio con l'avvio; R1B: 49-63 s, **19 minuti di orologio per 9 passate = ~2,1 min l'una**). Codice = serve `mql5-ea-developer` + cancello. Beneficio: [GIUDIZIO] 0-5 su informazione (quanto cambia cio' che sappiamo) e rischio (quanto cambia il rischio che Claudio dovra' firmare). Il PF atteso e' sempre quello della sez. 3.3, ancorato.

### 5.1 Tabella completa

| ordine | proposta | input (tipo, default neutro) | P / codice | beneficio info / rischio | dPF atteso (H0 / PF~1,0) | nota |
|---:|---|---|---|---|---|---|
| 1 | **R2K: tetti letti ex-post** | `InpMaxDailyLoss` (double EUR, 0); `InpMaxTradesPerDay` (int, 0) | 0 P / 0 codice | 2 / **4** | ~0 per costruzione | PRIORITA' 1 |
| 2 | **R2U-A/B/T: BE spento, ATR fisso, tempo spento** | `InpBE_TriggerATR` (double, 1,0 -> 99); `InpTrailAtrMode` (int, 0 -> 1); `InpTimeExitBars` (int, 48 -> 0) | 9 P / 0 | 4 / 2 | BE spento +0,003 / -0,008; ATR fisso +0,003 / +0,022; tempo spento -0,001 / -0,003 | PRIORITA' 2 |
| 3 | **R2U-D+: asse kTrail a 4 punti** (1,5 / 3,5 / spento) | `InpTrail_ATR` (double, 2,5 -> 1,5; 3,5; 0) | 9 P / 0 | **5** / 2 | 1,5: -0,028 / -0,061; 3,5: -0,008 / +0,014; spento: +0,007 / +0,044 | PRIORITA' 3: il rivelatore di deriva |
| 4 | **R2U-X: amplificatore su C020** | gli stessi input, con `InpSpreadMaxATR` 0,20 fissato (pin) | 9 P / 0 | 4 / 0 | come sopra, rumore x0,37 | PRIORITA' 4 |
| 5 | **R2U-C: BE 0,5 / 1,5** | `InpBE_TriggerATR` (double, 1,0 -> 0,5; 1,5) | 6 P / 0 | 3 / 1 | 0,5: -0,053 / -0,075; 1,5: +0,005 / -0,003 | PRIORITA' 5 |
| 6 | trailing armato dopo X ATR | `InpTrailArmATR` (double, **0** = trail dal primo tick = oggi; 1,0; 2,5) | 3-6 P / codice ~10 righe | 2 / 1 | +0,007-0,010 / +0,015-0,017 | solo se 2-4 trovano struttura |
| 7 | uscita prima della pausa | `InpFlatMinuteOfDay` (int minuti server, **0** = spento; 1315 = 21:55) | 3 P / codice ~15 righe | 0 / **3** | ~0 (4 operazioni su 933) | sicurezza, non merito; decide Claudio |
| 8 | TP in ATR | `InpTP_ATR` (double, **0** = assente; 5,0) | 3 P / codice ~8 righe | 1 / 1 | -0,001 / -0,008 (TP 2 R); -0,010 / -0,029 (TP 1 R) | il trailing fa gia' il lavoro |
| 9 | chiusura parziale | `InpPartialPct` (double, **0**) + `InpPartialAtr` (double) | 3 P / codice ~25 righe | 0 / 1 | -0,005 / -0,014 | gia' misurato in casa su altri motori (R46/R47): "compra win rate, vende payoff" |
| 10 | offset del BE | `InpBE_OffsetATR` (double, 0 -> 0,25) | 3 P / 0 | 0 / 0 | -0,002 / -0,008 | cosmetico (win rate 61%, payoff 0,55) |
| 11 | tempo 12 / 24 barre | `InpTimeExitBars` | 3 P / 0 | 0 / 0 | -0,001..+0,007 / -0,005..-0,009 | taglia vincenti (54 su 57 oltre 24 min): non lo propongo |
| 12 | kSL (qualunque direzione) | `InpSL_ATR` | - | - | +0,001 (3,5) / -0,010 (1,5, sfonda la frontiera) | **non si mette ad asse**; vedi trappola in sez. 2 |
Le righe 1-5 sono le **5 proposte prioritarie** (dettaglio in 5.2-5.6). Le righe 6-9 richiedono codice: per la regola della casa **non si scrive codice per un motore a zero prima di sapere dove sta il segnale**, tranne la riga 7 che e' una questione di sicurezza (vedi 5.7). Le righe 10-12 le motivo e le scarto con il numero accanto.

### 5.2 PRIORITA' 1 - R2K: i tetti di rischio letti ex-post (0 passate, 0 codice)
**Cosa**: far leggere al lettore, su OGNI cella di R2 (e sulle 933 gia' fatte), cosa avrebbero fatto `InpMaxDailyLoss` e `InpMaxTradesPerDay` a diversi valori. Con una posizione per volta il tetto *tronca* la giornata: le operazioni sopravvissute con tetto N sono esattamente le prime N del giorno (le decisioni dell'EA dipendono solo dal passato). Non serve nessuna passata.
**Valori da leggere** (non da decidere): perdita giornaliera a **1,0 / 1,5 / 3 R** (R = 1.302 EUR a 1 lotto, 1.302 / 1.953 / 3.906) e operazioni al giorno **1 / 2 / 3 / 5**. In modalita' lotto fisso il tetto e' in EUR e vale R diversi con la volatilita' (R da 600 a 2.000 EUR): in modalita' rischio % il tetto in R e' stabile. [DECISIONE DI CLAUDIO quale modalita' e quale tetto.]

**Risultati ex-post su R1A** [MISURATO, POST-HOC = ipotesi]:
| tetto perdita giornaliera | n tenute | PF_V | DD sui trade chiusi (EUR) | giorno peggiore (EUR / R) |
|---|---:|---:|---:|---|
| nessuno | 933 | 0,855 | 60.974 (46,8 R) | -9.040 / **-6,9 R** |
| 0,5 R (651) | 518 (56%) | 0,868 | 27.195 | -3.211 / -2,5 R |
| 1,0 R (1.302) | 625 (67%) | 0,828 | 44.205 | -3.211 / -2,5 R |
| 1,5 R (1.953) | 706 (76%) | 0,790 | 61.162 | -3.603 / -2,8 R |
| 3,0 R (3.906) | 852 (91%) | 0,827 | 60.709 | -5.599 / -4,3 R |
| 6,0 R (7.812) | 929 (99,6%) | 0,845 | 64.260 | -9.040 / -6,9 R |
**Lettura**: il tetto non cambia il merito (PF 0,78-0,87 contro 0,855, dentro il rumore per giorno [0,70-1,03]); cambia la coda dei giorni: **il giorno peggiore scende da 6,9 R a 2,5-4,3 R** con un tetto a 0,5-3 R, al prezzo di 9-44% di operazioni in meno. Il drawdown non scala in modo regolare (dipende dal percorso: 27k, 44k, 61k): **non lo uso per scegliere un tetto**. I giorni con perdita >= 2 R sono 18 su 168, >= 3 R sono 8. Il tetto e' controllato al segnale, quindi il giorno puo' sforare di una operazione (fino a ~1,1 R oltre il tetto + eventuali pareggi).
[DERIVATO, NON e' una proposta di taglia] Il giorno peggiore pesa 6,9 R. Se 1 R fosse lo 0,65% del conto (l'unita' del cap C1 al 3,25%), sarebbero **4,5% in un giorno**; con un tetto fra 1,5 e 3 R il giorno peggiore e' 2,8-4,3 R = 1,8-2,8%. La pausa del Guardian e' al 4,0% (CLAUDE.md, firme 18/08): decide Claudio se e come i tetti dell'EA e quelli del Guardian si parlano.
**Attesa scritta prima**: sulle celle di R2 il PF_V con tetto restera' entro +-0,06 di quello senza tetto (H0: il tetto toglie operazioni a rendimento medio invariato); la coda del giorno peggiore scendera' di almeno il 35% con tetto <= 3 R (misurato su R1A: -38% a 3 R). **Smentita**: un tetto che *alza* il PF di piu' di 0,10 in 2 tranche su 3 = c'e' una struttura intragiornaliera (e va letta come ipotesi di REGIME, sotto).

**Il "tetto 1 al giorno" e' un'ipotesi di regime, non una cella** [MISURATO, POST-HOC, forking paths dichiarati: guardati 5 tetti]:
| tetto | n | PF_V | p di permutazione (singolo) | per tranche T1 / T2 / T3 |
|---|---:|---:|---:|---|
| 1 | 168 | **1,293** | 0,014 | 0,68 / 0,99 / **2,26** |
| 2 | 302 | 1,085 | 0,016 | 0,66 / 0,93 / 1,55 |
| 3 | 415 | 0,994 | 0,016 | 0,73 / 0,87 / 1,23 |
| 5 | 562 | 0,854 | 0,12 | 0,73 / 0,82 / 0,91 |
Test: 20.000 permutazioni della scelta dell'operazione entro il giorno (ipotesi nulla: le operazioni dello stesso giorno sono scambiabili). **p = 0,014 che ALMENO UNO dei quattro tetti raggiunga il massimo osservato (1,293)**, corretto per i 4 tetti guardati; ma **per tranche: T1 p = 0,64, T2 p = 0,33, T3 p = 0,0019**. Senza la migliore prima-operazione (+7.074 EUR il 12/02) il PF del tetto 1 resta 1,16.
**Replica su altri insiemi di operazioni** [MISURATO]: le *prime operazioni del giorno* delle tre celle larghe (insiemi diversi dalla REPL, ma stessi giorni, quindi NON indipendenti): PF_V C010 1,15 (T1 1,07 / T2 0,91 / T3 1,42) | C020 0,91 (0,39 / 0,78 / 1,35) | C035 1,07 (0,40 / 0,72 / 1,72). **Il segno positivo torna solo in T3 (gen-mar 2026, 62 giorni).** Interpretazione onesta: o la "prima rottura del giorno" ha un contenuto che esiste solo in quel regime, o e' la fortuna di 62 giorni. [NON DISTINGUIBILE con i dati di oggi.]
**Come si pre-registra la validazione (soglie scritte ORA, prima di ogni dato nuovo)**: (a) **gratis**: dopo il lotto R2REG, leggere la prima operazione del giorno della cella C035 sulle sei tranche 2024-25 (~380 giorni; la cella e' ESCLUSA PER COSTO a quel tempo: legge il meccanismo, mai una sedia): il meccanismo "regge" se PF_V(prima operazione) > PF_V(resto) in >= 4 tranche su 6 *e* p di permutazione sul pool <= 0,05; (b) **in avanti**: T0 dal 01/10/2026, 150 prime operazioni = ~175 giorni di mercato = **meta' 2027**: prima di allora il tetto 1 resta *ipotesi di gestione del rischio*, mai cella di merito (sez. 1.7 del piano, confermata).

### 5.3 PRIORITA' 2 - R2U-A/B/T: BE spento, ATR fisso, tempo spento (9 passate)
Sono le tre celle gia' nel piano (A, B, tempo) piu' la certezza che si facciano TUTTE: il tempo spento *non e' completezza, e' un controllo positivo*: e' la cella che il modello prevede con piu' precisione (sd appaiata 0,005) ed e' l'unica che prova che il lettore e il tester funzionano come da modello prima di leggere le altre.
| cella | input | tipo | default (neutro) | cella | meccanismo | passate |
|---|---|---|---|---|---|---|
| A | `InpBE_TriggerATR` | double | 1,0 | **99,0** (BE mai armato; accettato dalla validazione `< 0`) | le 299 uscite a BE (32%) restano col trailing: misura se il ritorno a pareggio e' un costo o una protezione | 3 |
| B | `InpTrailAtrMode` | int | 0 | **1** (ATR della barra di segnale, fisso) | lo stop non si stringe da solo quando l'ATR scende | 3 |
| T | `InpTimeExitBars` | int | 48 | **0** (spenta) | 8 uscite su 933: la manopola dovrebbe essere inerte | 3 |
**Attese (REPL, 3 tranche somma), scritte prima dei numeri, ancorate su R1A con il modello** [SIMULATO]:
| | A: BE spento | B: ATR fisso | T: tempo spento |
|---|---|---|---|
| PF_V | **0,76-0,95** (0,858 +- 2 x 0,048) | 0,75-0,96 (0,858 +- 2 x 0,053) | **0,844-0,864** (0,854 +- 2 x 0,005) |
| n | 700-950 | 670-905 | 925-940 (+-1%) |
| win rate (netto > 0) | 0,31-0,37 | 0,22-0,29 | 0,26-0,27 |
| payoff | 1,5-1,9 | 2,2-2,8 | 2,3-2,4 |
| quote d'uscita | BE 0; sotto l'ingresso 0,60-0,72; profitto 0,30-0,38 | SL iniziale **0,02-0,06**; sotto 0,32-0,40; profitto 0,18-0,25 | invariate; tempo 0 | 
| durata media | 11-13 min | 12-15 min | 9,5-10,5 min |
| dev. std del profitto per operazione | +10% | +3% | = |
**Controllo incrociato con il PIANO R2 (da correggere PRIMA dei numeri, perche' sono stime a mano e il modello le contraddice)**: il piano scrive per B "SL_INIT dal 1% al 10-30%": **il modello da' 2-6%** (con ATR fisso lo stop non si stringe, ma il trailing parte comunque dal primo tick: lo SL iniziale resta toccato solo se il prezzo non sale mai oltre lo spread). Se esce 10-30% il modello sbaglia la dinamica dell'ATR, ed e' un'informazione. Altre differenze: BE 0,5 -> piano "BE 40-50%", modello 55%; BE 1,5 -> piano "20-25%", modello ~16%; n di BE spento piano 650-930, modello 760-900 (concordi).
**Smentita** (soglie congelate ora): (i) *struttura*: il modello nullo e' sbagliato se per A la quota "sotto l'ingresso" esce fuori 0,55-0,75, o per T |dPF| > 0,03 (la manopola non era inerte: e' un risultato); (ii) *continuazione*: esiste se dPF appaiato per giorno >= +0,15 in almeno 2 tranche su 3 **e** PF_V > 1,03 (S8 del piano). Se nessuna delle due: **il default va bene**.
**Fuori campione**: tranche T1-T3 sono la scoperta; validazione = T0 dal 01/10/2026 (stessa cella, 1 passata per cella promossa; n >= 150 a ~4,8 operazioni/giorno verso il 20/11); il lotto R2REG (2024-25) ha la REPL quasi vuota (216 ingressi attesi su 6 tranche): per le uscite il merito li' e' NON MISURATO, il rischio (DD, peggior operazione) si legge a qualunque n.
**Costo**: 9 passate + la gemella di determinismo gia' nel piano = ~10 x 80 s = ~13 minuti di orologio (8 minuti di tester).

### 5.4 PRIORITA' 3 - L'asse kTrail a 4 punti, letto come PENDENZA (9 passate)
**Perche' e' la proposta con piu' informazione**: sotto una deriva di continuazione l'ordine di PF e' monotono nella tenuta (kTrail 1,5 < 2,5 < 3,5 < spento), e la differenza fra gli estremi vale 0,035 sotto H0 contro 0,24 a mu 0,02 (3.3). **Una pendenza su 4 punti usa 4 celle per una sola domanda** e non dipende da una cella che sporge: e' coerente con "centro dell'altopiano, mai il picco" (S7 del piano: con 3-4 punti l'altopiano si legge solo se il PF_V e' monotono).
| input | tipo | default (neutro) | celle | meccanismo | passate |
|---|---|---|---|---|---|
| `InpTrail_ATR` | double | 2,5 | **1,5** | **3,5** | **0 (spento: lo SL iniziale 2,5 ATR + BE + tempo restano)** | distanza dello stop dall'estremo; a 0 il codice lo disabilita (`kTrail > 0`) e la validazione accetta 0 | 9 |
**La cella "spento" NON e' nel piano R2** (il piano ha 1,5 e 3,5). E' l'esperimento piu' pulito sulla domanda "il prezzo continua abbastanza dopo la rottura perche' un SL fisso + BE guadagni?": e' la **versione a tenuta massima** (fino a 48 barre), e il confronto in casa e' R24 (soglia di armamento 0 contro 1,0 R sul DAX: 8o ribaltamento) e "NUDA" contro trailing sul Dow (PF 1,238 contro 1,371): **due indizi che tenere meno non peggiora e che l'in-campione ribalta**, quindi qui si legge solo la pendenza e solo con la prova in avanti.
**Attese (REPL, ancorate)** [SIMULATO]: 
| kTrail | PF_V (H0) | win rate | payoff | SL iniziale | BE | sotto | profitto | durata media | n |
|---|---|---|---|---|---|---|---|---|---|
| 1,5 | 0,83 (0,66-0,99) | 0,33 | 1,7 | 0 | 0,11 | 0,56 | 0,34 | 5,2 | 1.130-1.530 |
| 2,5 (default) | 0,855 | 0,265 | 2,37 | 0,011 | 0,32 | 0,40 | 0,26 | 10,0 | 933 |
| 3,5 | 0,85 (0,72-0,98) | 0,21 | 3,2 | 0,20 | 0,43 | 0,16 | 0,17 | 13,5 | 650-880 |
| spento | 0,86 (0,69-1,03) | 0,11 | 6,3 | 0,27 | 0,55 | 0,06 | 0 | 16,5 | 565-765 |
(Banda PF = ancorato +- 2 x sd appaiata di sez. 3.3. **n: stima con un modello a sistema di perdita a un posto, tasso di segnali 0,163/min calibrato su 4,8 operazioni al giorno su 12,6 segnali, [INFERITO], +-15%.**)
**Pendenza attesa (spento - 1,5)**: H0 **+0,035 +- 0,12** (sd come somma in quadratura delle due appaiate, prudente); con una deriva da PF ~ 1,0 **+0,105**; con mu 0,02 **+0,24**. **Smentita** (congelata): la continuazione e' presente se la pendenza (spento - 1,5), pooled sulle tre tranche, e' > +0,15 *e* le tre tranche hanno lo stesso segno *e* PF_V(spento) > 1,03. A questa soglia la prova chiama solo derive da PF >= ~1,08: una deriva da PF ~1,0 (pendenza attesa +0,105) NON la supera e si scrive "nessuna pendenza oltre il rumore" (limite di potenza a n 933, dichiarato). Altrimenti il default (2,5) resta e si scrive "nessuna pendenza oltre il rumore". **Se una sola cella sporge e le vicine no: "non c'e' una configurazione robusta".**
**Costo**: 9 passate ~ 12 minuti di orologio. Se si vuole risparmiare: la cella "spento" da sola (3 passate) e' l'80% dell'informazione.

### 5.5 PRIORITA' 4 - L'amplificatore di potenza su C020 (9 passate)
**Problema** [DERIVATO, 3.3]: a n = 933 il rumore appaiato sul PF e' 0,05-0,09 e le differenze attese sono 0,01-0,05: le celle di R2U sulla REPL sono *quasi tutte illeggibili*.
**Proposta**: ripetere sulla cella C020 (`InpSpreadMaxATR` 0,20 fissato come pin, n = 6.949 nel default di R1B) le tre uscite col massimo contenuto di informazione: **BE spento (3 P) | trail spento (3 P) | ATR fisso (3 P)**. Il default di C020 esiste gia' in R1B (stessa versione dell'EA, stessi tick, SHA identico): **zero passate di riferimento**. Una variabile per file prova (la cella C020 e' un pin, come in R1B).
**Cosa si guadagna**: il rumore appaiato su C020 scala di sqrt(933/6949) = 0,37: da 0,086 a **0,032** per il trail spento. La correlazione dei netti giornalieri fra celle diverse della stessa serie (non uscite diverse sugli stessi ingressi) e' 0,53-0,66 [MISURATO]: leggere i dPF *appaiati per giorno* dovrebbe togliere almeno ~35% di rumore rispetto a due PF indipendenti [INFERITO]. Attenzione: la "sd appaiata" del simulatore e' appaiata *per operazione* (stessi percorsi), quindi OTTIMISTICA; con le operazioni reali che divergono il rumore sta fra quella e il caso indipendente.
**Cosa NON e'**: non e' un candidato. C020 e' a 20,6x di costo (FRA, sotto la frontiera 40x per costruzione, R1B) e il 12-18% degli ingressi e' sotto 13,3x (R1B). E' una **diagnostica sul profilo di deriva dopo la rottura**, in una banda di ATR piu' bassa di quella della REPL: il trasferimento alla REPL e' [INFERITO], non misurato.
**Attese**: dPF di ogni cella vs C020 default (0,819) entro +-0,06 sotto H0; con la deriva da PF ~ 1,0 e' +0,044 per il trail spento (z 1,4), con mu 0,02 +0,119 (z 3,7). **Smentita**: se il trail spento fa dPF > +0,09 su C020 *e* il segno e' lo stesso in 3 tranche su 3, la continuazione esiste: la domanda diventa "esiste anche a ATR alto (REPL)", e R2U-D su REPL diventa la conferma. Se tutto e' dentro +-0,06: l'unica scoperta e' che anche con 7.000 operazioni non c'e' pendenza, e la casella 3 si chiude con piu' forza (z fino a 1,4).
**Costo**: 9 passate x ~2,1 min = **~19 minuti di orologio**, ~9 di tester. Nessun codice.
**Fuori campione**: T0 non vale per C020 (non e' una sedia); si valida sulla REPL con il risultato di R2U-D.

### 5.6 PRIORITA' 5 - R2U-C: BE a 0,5 e 1,5 ATR (6 passate)
| input | tipo | default (neutro) | celle | meccanismo | passate |
|---|---|---|---|---|---|
| `InpBE_TriggerATR` | double | 1,0 | **0,5** | **1,5** (con 99 di P2: 4 punti 0,5 / 1,0 / 1,5 / spento) | quanto presto si congela il pareggio; l'altopiano si legge sui 4 punti | 6 |
**Il BE "che morde nel 59%" - cosa dicono modello e dati** [SIMULATO + MISURATO]: la sequenza (59% armato, 54% di questi torna a pareggio) e' *quella che un prezzo senza deriva produce* con un trailing di ~0,75 R di distanza effettiva (64% / 54% simulato). Il BE sposta il rischio: **perdita lorda per operazione 4,3 contro 5,4 USD (-21%), deviazione standard 14,7 contro 16,2 (-10%), a PF invariato (+0,003)**. Quindi non e' "un BE che taglia i vincenti": e' un'assicurazione quasi gratuita, finche' scatta tardi. **Il BE a 0,5 ATR e' l'unico spostamento con un effetto atteso apprezzabile: PF -0,053 (H0), -0,075 (H1)**, perche' porta la quota a BE dal 32% al 55% e il win rate dal 26,5% al 17,5%, cioe' converte le operazioni che avrebbero continuato in pareggi.
**Attese (REPL)**: BE 0,5: PF_V 0,66-0,94 (0,802 +- 0,14), BE ~55%, sotto l'ingresso ~26%, win rate 0,17, payoff 3,7, n 960-1.300, durata media 7 min | BE 1,5: PF_V 0,78-0,94 (0,860 +- 0,08), BE ~16%, sotto ~51%, win rate 0,31, payoff 1,9, n 730-990.
**Smentita**: BE 0,5 con PF_V >= 0,86 in 2 tranche su 3 (il BE anticipato NON costa) o BE 1,5 con dPF <= -0,08 (il BE tardivo costa): in entrambi i casi il modello sbaglia la dinamica e la lettura del BE va rifatta. **Prior di casa**: Dow, niente BE anticipato (6 confronti su 8 in perdita, fino a -38%): coerente col segno del modello.
**Costo**: 6 passate ~ 8 minuti di orologio.

### 5.7 Fuori dal top 5 (con il motivo e il numero accanto)
- **Uscita prima della pausa** (`InpFlatMinuteOfDay`, riga 7): [MISURATO, R1A] 179 errori "market closed" (tutti in T3, 21:56-22:00 server), quattro operazioni tenute oltre la pausa (netto +3.158 EUR), 8 ordini non eseguiti; il peggiore slittamento di tutto il lotto (-11,85 USD/oz = circa -1.185 USD a 1 lotto, ~1.000-1.100 EUR, 03/03 21:41) e' proprio una di queste. Il PF non si sposta (4 operazioni su 933). E' un **buco di sicurezza**: un'operazione aperta a ridosso della pausa del venerdi' passa il fine settimana con il solo SL (server-side). Default 0 = comportamento identico; richiede codice (~15 righe: confronto dell'ora server con i minuti del giorno, `PositionClose`, e blocco dei nuovi ingressi nei 5 minuti finali, che `InpHourEnd` fa a ore intere). **Decisione di Claudio** se vale una sedia schierata; per un motore a zero non la scrivo.
- **Trailing armato dopo X ATR** (`InpTrailArmATR`, riga 6): il modello dice dPF +0,007-0,010 (H0) e +0,015-0,017 (PF~1,0) *e* una perdita realizzata che sale (SL iniziale 26-27%, perdita lorda 4,6 contro 4,3): e' un cambio di FORMA che aumenta la perdita per operazione. Prior di casa: R24 (DAX) soglia 0 batte 1,0 R in 5 righe OOS su 5, ma in-campione vinceva 1,0: **8o ribaltamento**. Candidato solo se P3 mostra pendenza positiva.
- **TP in ATR** (riga 8): assente oggi. Il modello dice che un TP a 1 R costa 0,010-0,029 e uno a 2 R 0,001-0,008, e riduce la deviazione standard del 20% / 7%: serve solo a limare la coda. Prior di casa: TP 3R secco sul DAX 0,88 contro 1,49 col trailing. **Non lo propongo.**
- **Parziale** (riga 9): -0,005 / -0,014; compra win rate (28% -> 48%) e vende payoff, come in R46/R47. Non lo propongo. Se Claudio lo volesse per la regolarita' della curva: deviazione standard -14%, costo di una commissione in piu' (~0,9 EUR a operazione = 0,002 di PF).
- **Offset del BE** (riga 10): dPF -0,002 / -0,008, win rate 61% e payoff 0,55: rende le 299 uscite a pareggio "vincenti" di pochi centesimi, **cosmetica, non merito**. Scartato.
- **Tempo a 12 / 24 barre** (riga 11): a 24 tocca 57 operazioni reali, 54 delle quali vincenti: taglia coda. Scartato come proposta; il valore 0 resta nel top 5 come controllo.
- **Uscite dinamiche del tipo "kTrail variabile con la volatilita' / a gradini / chandelier"**: non le propongo: aggiungono gradi di liberta' a un motore a zero (regola del 19/08) e la Tabella B dell'audit le conta come "mai provate" proprio perche' nessuno le ha mai messe in un'ipotesi con attesa e smentita. Se P3 trova pendenza, il "chandelier" diventa il candidato; non prima.

### 5.8 Condizioni di lettura che servono a tutte (non sono passate: sono regole del lettore)
1. **Il confronto fra celle va fatto appaiato per giorno**, con bootstrap per giorno dell'intera differenza, non come due PF indipendenti. Con l'uscita cambiata il set di operazioni diverge (S9 del piano), ma i giorni sono gli stessi.
2. **Soglie**: una cella e' "meglio del default" solo se dPF appaiato > 2 x sd (circa +0,10 a n 933; circa +0,06 a n 6.900) **e** PF_V > 1,03 (S8) **e** segno concorde in 2 tranche su 3. Per la famiglia di 12 contrasti la soglia a 2 sigma e' troppo larga: serve 2,7 sigma (Bonferroni indicativo) o la sola lettura per pendenza (5.4).
3. **Dichiarazione obbligatoria**: ogni cella scrive "meglio / uguale / peggio del DEFAULT" col numero. Se il guadagno e' dentro il rumore: **"il default va bene"**.
4. Il tetto di operazioni (5.2) e' un'ipotesi di regime: non entra nelle celle di merito.

---

## 6. VALORI DI RIFERIMENTO ESTERNI (cosa ho cercato e cosa no)
- Una ricerca web il 10/10/2026 ("Gold Breakout PRO EA MT5 XAUUSD M1 channel breakout EMA ATR trailing breakeven inputs"): **nessun .set pubblico e nessun pannello input** per questa famiglia (canale + EMA + ATR a M1). I risultati (mql5.com/en/market/product/172353 "Gold Pro Breakout", 169819 "AurumBreak Pro", 177899 "EdgeForge BreakOut Gold PRO", 168983 "Xauusd Breakout Pro") sono EA di altra struttura (H4/H1/M15 multi-TF, box asiatico con ordini stop, livelli del giorno prima): **non sono valori di riferimento per questo motore**. [NON TROVATO]
- Gli unici valori di riferimento sono quelli del pannello di Emiliano ([DICHIARATO], `report/EA_NOTTURNO_GBA_SPECIFICA_2026-10-09.md`, 09/10): trailing 2,5 ATR, BE 1,0 ATR acceso, tempo 48 barre, perdita giornaliera "off" (limiti: off; passo 500; il 5.000 citato in live e' impersonale), il prodotto di mercato dichiara "Max Trade Per Day" (spec. par.12). **Nessuno e' un criterio; nessuno ha una fonte che dica su quale campione furono scelti.**
- Non ho cercato: .set di altre famiglie, letteratura sul trailing a martingala (la regola dell'arresto opzionale e' un teorema di base, non una fonte da citare).

---

## 7. CONTRO-ESEMPI COSTRUITI PRIMA DELLA CONSEGNA
1. *"Il BE morde nel 59% perche' c'e' un difetto"* - provato contro il modello nullo: il modello riproduce 64,2% / 54,4% senza nessuna deriva ne' difetto. Regge: non e' un'anomalia. (Non prova che non ci sia deriva: sez. 3.1.)
2. *"Il modello riproduce la forma, quindi non c'e' deriva"* - provato abbassando la volatilita' dopo l'ingresso a 0,9x: P(>=1R) 8,9-10,2%, quote di uscita nei limiti. **Non regge come prova**: la forma non discrimina. Ho tolto la frase e tengo solo il test diretto della sez. 4.
3. *"Lo slittamento e' un costo in piu'"* - provato contro l'arresto opzionale e con il simulatore a passi di 1 s (overshoot medio 0,39 USD, il PnL medio con fill sul tick resta a -(spread + commissione) entro l'errore di Monte Carlo). Il dato non discrimina fra -23,5 e -40 EUR (z -0,9 / -0,5): **dichiarato "non discriminato"**, non risolto.
4. *"Il tetto 1 al giorno ha PF 1,29 quindi c'e' un meccanismo"* - provato con una permutazione (p 0,014 totale) e per tranche (T3 0,0019, T1 0,64, T2 0,33), e sulle prime operazioni di C010/C020/C035: **ridimensionato a ipotesi di regime**. La miglior prima operazione (12/02, +7.074 EUR) fa +0,13 di PF: senza di lei 1,16.
5. *"Alzare kSL porta la cella sopra la frontiera dei 40x"* - provato contro il codice e il simulatore: lo stop reale e' kTrail x ATR, kSL 3,5 da' risultati identici al default (dPF +0,001, sd 0,004). **Trappola dichiarata** (sez. 2).
6. *"Le celle larghe sono piu' potenti perche' hanno piu' operazioni"* - controllato: vero per il rumore (scala 1/sqrt(n)), ma le celle larghe hanno costo 20x (FRA) e ATR piu' basso: il trasferimento alla REPL non e' garantito. Dichiarato in 5.5.
7. *"Il piano e' coerente con il modello"* - provato: **NO su tre punti** (SL iniziale di B, BE 0,5, BE 1,5): sez. 5.3. E' la ragione per cui scrivo la correzione PRIMA dei numeri.

---

## 8. COSA NON HO VERIFICATO (buchi dichiarati)
1. **Il modello nullo e' un modello, non una misura**: 2 parametri liberi (volatilita' relativa dopo l'ingresso 1,0; dispersione fra operazioni 0,40) + 0,25 per barra, scelti guardando tre famiglie di modello (circa 60 combinazioni di parametri; due famiglie scartate perche' sbagliavano durata e coda) e confrontando 8 numeri aggregati di R1A: il modello e' *adattato* a R1A, non previsto. Non ho fatto una calibrazione formale ne' una validazione su un periodo diverso. Le **quote** sono sbagliate di 5-7 punti, il **PF** del nullo e' 0,07 sopra l'osservato.
2. **Non ho modellato**: la sequenza degli ingressi, lo spread variabile, il rollover, le notizie, la volatilita' a grappolo, il lag, l'asimmetria BUY/SELL, il ritorno a media dell'ATR. Il numero `n` per variante e' un'approssimazione a sistema di perdita (+-15%) [INFERITO].
3. **La deriva lorda** (sez. 4) usa lo spread del solo ingresso e un cambio ricavato (`perdita a SL / (2,5 x ATR x 100)`), non letto dal tester: errore atteso < 3 EUR a operazione, non misurato. Non ho controllato l'identita' contabile deal per deal; ho controllato che media REPL -57,7 EUR e PF 0,855 coincidano con il lettore.
4. **Non ho verificato che i nuovi input siano neutri**: non e' stato scritto nessun codice. Le righe 6-9 della tabella sono specifiche; la neutralita' del default va provata (autotest + gemella di determinismo) dopo il cancello.
5. **Le soglie di smentita** (+0,15, +0,09, 4 tranche su 6...) sono state scelte guardando la sola simulazione e le deviazioni appaiate del modello, non una calibrazione sul dato reale: sono congelate ORA, ma non sono "derivate" in senso forte. Il rumore appaiato *reale* delle celle d'uscita non lo conosco finche' una cella d'uscita non e' girata: le stime 0,04-0,09 sono da simulazione a numeri casuali comuni (lower bound: le operazioni reali divergono).
6. **Tetti**: la lettura ex-post tronca la giornata al segnale; non ho rifatto `GbaPnlGiorno` (somma deal chiusi + aperto per magic/simbolo) sul tester, e il giorno e' quello del tempo del tester; un'operazione a cavallo di mezzanotte e' attribuita al giorno d'ingresso. Il drawdown e' sui trade chiusi, non sull'equity.
7. **R1B**: ho letto C010/C020/C035 con lo stesso lettore di R1A, che si ferma se un ingresso non e' abbinato al giornale (non si e' fermato); non ho rifatto a mano gli abbinamenti. I conteggi coincidono con la lettura R1B (3.918 / 6.949 / 7.420 e PF_V 0,830 / 0,819 / 0,817). Le tre celle sono sovrapposte: i loro z non si sommano.
8. **Orologio**: l'ora dei deal e' quella del tester (server). Le fasce orarie non sono state toccate. L'orologio BCM d'inverno (CLAUDE.md, 24/09) non e' trattato: nessun risultato qui dipende dall'ora, salvo la nota sulla pausa delle 22:00.
9. **Non ho cercato**: deriva di continuazione per fascia oraria o per regime di ATR (sarebbe una griglia sull'ingresso); la sensibilita' alla latenza (il tester ha `ExecutionMode 0`).
10. **Non ho confrontato** le mie attese con Gemini (non richiesto qui) ne' le ho passate al `controllo-preventivo`: **questa bozza non e' passata dal cancello** e i controesempi della sez. 7 li ho costruiti io.
11. Il simulatore e gli script di analisi stanno in una cartella temporanea della sessione e **non sono nel repo**.

---

## 9. COSA SERVE DA CLAUDIO (poco)
1. Il via, o no, ai 33 passaggi (43-69 minuti di orologio, PC di backtest, **mai sul VPS**, nessuna spesa): i 9 + 9 + 9 + 6; il top 1 (tetti ex-post) non richiede macchina.
2. Una decisione che e' sua: **se i tetti giornalieri vanno in R (modalita' rischio %) o in EUR (lotto fisso)**, e se la loro soglia deve stare sopra o sotto la pausa del Guardian al 4,0%. Io ho solo misurato cosa farebbero.
3. Se vale scrivere il codice di `InpFlatMinuteOfDay` (sicurezza della pausa) prima che una cella superi S8: e' l'unica riga con codice che propongo di discutere subito.
**Non servono firme di rischio**: il lotto resta 1,00 fisso e nessun conto viene toccato.

---

## APPENDICE A - Ricetta del simulatore nullo (per rifarlo)
Percorso del bid in USD/oz, passo 1 secondo (60 per barra M1), 52 barre dopo l'ingresso, 14 barre prima. Volatilita' per barra = `exp(N(0, 0,25))` (pre-ingresso) e `exp(eta + N(0, 0,25))` con `eta ~ N(0, 0,40)` per operazione (post-ingresso), rapporto di volatilita' post/pre = 1,0. ATR(14) = media semplice dell'intervallo (massimo - minimo, intra-barra) delle 14 barre chiuse precedenti; la scala di prezzo di ogni operazione e' scelta in modo che l'ATR della barra di segnale sia uno dei 933 valori veri di R1A (estratto con reinserimento). Ingresso a ask = bid + 0,21; commissione 0,034 USD/oz; fill dello stop sul bid del tick in cui il livello viene violato (overshoot = quello naturale a 1 s, media 0,39 USD/oz: ininfluente sull'aspettativa per l'arresto opzionale; il default simulato ha -0,31 +- 0,10 USD/oz contro un atteso nullo di -0,244). Ordine in ogni sottopasso: (1) controllo dello stop, (2) uscita a tempo all'inizio della barra 48, (3) TP / parziale se previsti, (4) aggiornamento dell'estremo e dello stop (trailing da estremo - kTrail x ATR dell'ultima barra chiusa; BE se bid - ingresso >= trigger x ATR; si sposta solo a favore, solo se sotto il bid). Deriva H1: `mu` per minuto in unita' della deviazione standard di quel minuto, aggiunta ai soli sottopassi post-ingresso e scalata come la volatilita'. Semi: 100, 101, 102 (blocchi da 8.000) per H0; 100, 101 per H1. Le varianti girano sugli stessi percorsi. Rumore appaiato: 1.000 bootstrap di 933 operazioni (seme 7). Errore di Monte Carlo sul PF assoluto a N 24.000: ~0,02; sulle differenze appaiate: ~0,01.
Grandezze calibrate: nessuna sul PF; cinque quote di uscita, durata mediana, durata media, P(R >= 1/2/3) di R1A (tabella 3.1).
