# Trial FTMO 1514806751, due giorni (01-02/10/2026): sfortuna o EA? -- una misura, non un'opinione

Domanda di Claudio (03/10): *"siamo stati troppo sfortunati... oppure gli EA vanno male?"*
Stato: **la sezione 0 (criteri, metodi, soglie, attese, contro-esempi) e' scritta e committata PRIMA di calcolare qualunque
probabilita'.** I risultati arrivano dopo, nelle sezioni A-F, e la sezione 0 non si tocca.
Sola lettura: nessun EA, preset, forward, conto o VPS toccato. **Nessuna taglia proposta: le taglie sono di Claudio.**
Etichette: [MISURATO] letto/calcolato da file del repo · [DERIVATO] calcolato da numeri scritti · [NON MISURATO] il dato non c'e'.
✏️ **Cancello (controllo-preventivo, 03/10): FAIL al primo passaggio, correzioni di parole dentro il testo (marcate ✏️), numeri del
modello riprodotti da un'implementazione indipendente. Serve un secondo passaggio prima di consegnare a Claudio.** La sezione 0 non
e' toccata.

---

## 0. CRITERI (congelati prima dei numeri)

### 0.1 Che cosa ho gia' visto prima di scrivere questa sezione (dichiarato, perche' non posso "disvederlo")
- Il report del trial (13 posizioni, netto -8.811,59, data dal mandato e dal file): per sedia, gli esiti grezzi sono noti
  (DAX 770411 1 stop; DAX 770105 1 stop; Bulge 10 posizioni; ORB 770621 1 stop). **Nessuna probabilita' e' stata calcolata.**
- I contratti e le loro fonti (sotto). Nessun per-trade di contratto e' stato riaperto per contare vincite o code prima di
  questo commit, salvo i numeri gia' scritti in repo da altri (stop-rate 770411 5/14 nell'audit del 01/10).

### 0.2 Fonti
- Trial: `data/statements/ReportHistory_trial_1514806751_2026-10-03.xlsx` (report MT5 del 03/10 11:38; **senza** la sezione
  `Posizioni aperte`: tutto piatto). Parser: **copia** di `backtest_pipeline/lettura_trial.py` adattata al formato senza
  `Posizioni aperte` -> `backtest_pipeline/lettura_trial_senza_aperte.py` (l'originale NON si tocca). Controllo d'ingresso
  obbligatorio: il parser deve ritrovare **13 posizioni, netto -8.811,59, commissioni -204,04, saldo finale 151.188,41**; se
  non li ritrova, nessun numero sotto vale.
- Challenge FTMO 541452707 (solo come estensione secondaria, stesso codice, stesso broker):
  `data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx`.
- Contratti (per-trade OOS, R = netto della posizione / (1% x quota x saldo prima), funzione `pertrade_pos` di
  `backtest_pipeline/audit_rischio_flotta.py` **importata, non modificata**):

| sedia | per-trade usato | banco | che cosa e' rispetto al contratto | fonte del contratto |
|---|---|---|---|---|
| `770411` MaxMin DAX short | `risultati_prove/trades_portafoglio/..._770413.csv` | 100k, 1%, tick | **e' il contratto** (14 posizioni OOS, DD 1,9213%, PF 2,16) | `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` par. 4 |
| `770105` DAX Apertura RETEST short | `risultati_archivio/R251/PERTRADE/..._792520.csv` | **10k**, 1%, tick | cella "ancora" R251 (181 posizioni, PF per posizione 1,065). La cella esatta a 100k (R270, PF OOS **0,957**, 194 pos, DD 12,31%) **non ha per-trade** in repo. Uso il piu' FAVOREVOLE dei due: sposta p verso il basso, cioe' verso "EFFETTO" (verso prudente per la domanda "e' sfortuna?") | `SEDIA_SHORT_DAX_FTMO_2026-09-25.md` par. 6, `LETTURA_R270_2026-09-28.md` par. 3 |
| `770621` ORB Dow (preset trial) | `risultati_prove/trades_portafoglio/abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv` | 100k, 1%, tick | cella HALFRANGE del preset (119 posizioni OOS, PF 1,674, DD 9,76%) | `CENSIMENTO_ORB_2026-09-29.md` riga 13 e V7 |
| `770101` DAX Apertura RETEST long | `risultati_prove/aperture_r47/..._772501.csv` | 100k, 1% | contratto (193 pos) | `CONTRATTI...` par. 2 |
| `770202` Dow Apertura | `risultati_prove/aperture_r47/..._772505.csv` | 100k, 1% | contratto (96 pos) | idem |
| `771531` EMA200 Dow (2 gambe) | `risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv`, quota 0,5 | 100k, 1% | contratto (257 pos) | idem |
| **Bulge** (A `BULGE_V520_FT_*` 772720 · B `BULGE_VIOLA_*` 772700 · `BULGE VIOLA_*` 772720 dopo il ripristino) | **nessuno** | -- | **contratto [NON MISURATO]**: nessun IS/OOS, R92b mai chiuso | `PACCHETTO_BULGE_ORB_TRIAL_2026-10-01.md` par. 7.4 |
| `770260`, `770511` | nessun per-trade in repo | -- | contratto senza distribuzione per posizione: **fuori dal modello di portafoglio** | `AUDIT_RISCHIO_FLOTTA` par. F |

- **Riferimenti NON contrattuali per il Bulge** (servono solo a dire "se il Bulge fosse quello del riferimento X, quanto sarebbe
  raro il trial"; il verdetto del Bulge resta NON ANCORA MISURATO qualunque cosa esca):
  - **Rif-1** = il backtest di Claudio dichiarato nel sorgente (`ABTG_Bulge.mq5` r.27-39): WR **80,22%**, media vincita +131,63,
    media perdita -325,39, n 268, rischio 3%, Blu+Viola, altro cesto, dati 40%, nessun IS/OOS. Modello a due punti
    [DERIVATO]: vincita = +131,63/325,39 = **+0,4045 R**, perdita = **-1 R** (approssimazione: la perdita media trattata come uno stop pieno).
  - **Rif-2** = forward dell'antenato `BULGE_MULTI_SIGNAL` **solo VIOLA** sul piccolo 50503392 (n=50, PF 0,6949, `giornata_2026-10-02.md`),
    distribuzione di R estratta da `data/statements/ReportHistory_50503392_2026-10-01.xlsx` con `leggi_report` dell'audit
    (importato). Versione col difetto del primo tick, feed BCM: e' un antenato, non la sedia.

### 0.3 Unita' e definizioni
- **Posizione** = ID posizione MT5. **Netto** = profitto + commissioni + swap. **Vinta** = netto > 0.
- **R del trial** = netto / rischio all'ingresso; rischio = |prezzo d'ingresso - SL dell'ordine d'apertura| x volume x valore EUR
  per punto per lotto (ricavato dalla posizione stessa; se non ricavabile, mediana del simbolo nel report). Stessa definizione
  dell'audit del 01/10 par. 0.2. Controllo: il rischio del DAX 770411 deve tornare ~3.199-3.237 EUR, del 770105 ~3.106 EUR
  (numeri gia' scritti in `TRIAL_GIORNO1_ANALISI` e nell'audit).
- **Giorno** = data server FTMO della chiusura. Peggior giorno FTMO dichiarato: **-6.974,99 = -4,36%** (pannello FTMO, misura su
  EQUITY intragiornaliera). Il realizzato a fine giorno del 01/10 e' un'altra quantita' (lo calcolo e lo scrivo accanto).
- **Perdita complessiva** = -8.811,59 / 160.000 = **-5,51%**.

### 0.4 Test per sedia (punti 1-4 del mandato)
1. **Esito osservato**: n, vinte, netto EUR, somma R.
2. **Contratto**: WR (quota di posizioni con netto > 0), payoff (vincita media R / perdita media R), stop-rate (R <= -0,70),
   DD con fonte -- **ricalcolati dal per-trade**, non ricopiati.
3. **Probabilita' sotto il contratto**:
   - **p_win** = P(X <= k | n, WR contratto), **binomiale esatta**;
   - **p_net** (statistica PRIMARIA) = P(somma di n R estratti i.i.d. dal per-trade del contratto <= somma R osservata),
     **bootstrap, 200.000 simulazioni, seme 20261003** (`random.Random`);
   - **intervallo** di p_net: banda 5-95% su **2.000 ricampionamenti del contratto stesso** (stesso seme) = quanto p si muove
     per l'incertezza del contratto, non solo per il Monte Carlo (errore MC dichiarato a parte);
   - **potenza**: p_min = P sotto il contratto del risultato PEGGIORE possibile a quell'n (tutte perse:
     (1-WR)^n per la binomiale; per il netto, n volte il R minimo del contratto). **Se p_min >= 0,05 il test non puo' dare
     EFFETTO a nessun esito: il verdetto e' NON ANCORA MISURATO**, con p scritto lo stesso.
4. **Verdetto per sedia, su p_net**: **EFFETTO** p < 0,05 (raro sotto il contratto: "non solo sfortuna") · **ZONA GRIGIA**
   0,05 <= p < 0,20 · **NULLO** p >= 0,20 (esito ordinario sotto il contratto: compatibile con la sfortuna) · **NON ANCORA
   MISURATO** se il contratto manca o il test non ha potenza. Se p_win cade in una categoria diversa da p_net si scrive, ma
   **decide p_net** (dichiarato ora, per non scegliere dopo la statistica piu' comoda).
5. **Estensione secondaria** (non decide il verdetto del trial, si scrive accanto): stessa prova su **challenge 22-30/09 +
   trial** per le sedie con posizioni in entrambi (770411, 770105), stesso codice e stesso broker.

### 0.5 Portafoglio (punto 5 del mandato)
- **Modello P6** = le sedie del trial con per-trade di contratto: 770101, 770105, 770202, 770411, 771531 (due gambe), ORB 770621,
  alle **taglie in campo**: indici 2,00%, EMA200 1,00% per gamba, ORB 0,30%. **Fuori**: 770260, 770511 (nessun per-trade),
  Bulge (contratto assente). Quindi P6 descrive **solo la parte misurata** della flotta; non e' un tetto del rischio.
- **Calendario**: giorni lavorativi (lun-ven) della finestra comune **2025.07.01 -> 2026.06.29** (sovrapposizione dei per-trade);
  rendimento del giorno = somma R x taglia delle posizioni chiuse quel giorno. I festivi senza operazioni contano come giorni a
  zero (gonfia un poco i giorni a zero: spinge le probabilita' per giorno **in basso**, dichiarato).
- Statistiche, tutte su P/L **realizzato** (non equity):
  - **S1** P(un giorno <= -4,36%) e P(un giorno <= il realizzato vero del 01/10, calcolato dal parser: stessa unita' del modello);
  - **S2** P(2 giorni lavorativi CONSECUTIVI con somma <= -5,51%) sulle finestre scorrevoli del calendario (ordine vero, conserva
    l'autocorrelazione); accanto il bootstrap di 2 giorni i.i.d. (200.000, seme 20261003);
  - **S3** P(almeno uno dei 2 giorni consecutivi <= -4,36%);
  - **S4 (PRIMARIA del portafoglio, confronto alla pari)** P(somma di 2 giorni consecutivi di P6 <= la somma osservata nel trial
    delle SOLE sedie P6). Verdetto con le stesse soglie del 0.4 punto 4.
  - Se un conteggio esatto e' 0 su N finestre: si scrive "0 su N" e il limite superiore al 95% **3/N** (regola del tre), mai "zero".
- **Contributo della correlazione**: stesse S1-S4 con la serie giornaliera di **ogni sedia permutata indipendentemente** sui giorni
  (rompe "stesso giorno" e "stesso indice"), **2.000 permutazioni, seme 20261003** -> P_indip media. **Contributo = P_calendario -
  P_indip.** In piu', "stesso indice": giorni del contratto con stop (R <= -0,70) di **due** sedie DAX (770101, 770105, 770411)
  contro l'atteso sotto indipendenza (prodotto delle frequenze giornaliere di stop) -> rapporto (lift).
- **Avvertenza fissa**: P/L realizzato e' un LIMITE INFERIORE della perdita intragiornaliera in equity (la -4,36% FTMO e' in
  equity): P(realizzato <= -4,36%) sottostima P(equity <= -4,36%).

### 0.6 Attese (previsioni, scritte prima; le scrivo anche se sbagliano)
| oggetto | previsione | perche' |
|---|---|---|
| 770411 trial (1 stop) | p_net ~0,3-0,45, **NON ANCORA MISURATO** (p_min = stop-rate ~0,36 > 0,05) | n = 1 non ha potenza |
| 770105 trial (1 stop) | p_net ~0,3-0,5, NON ANCORA MISURATO | idem, contratto ~ PF 1 |
| ORB trial (1 stop) | p_net ~0,4-0,6, NON ANCORA MISURATO | idem |
| 770411 challenge+trial (4 pos.) | p_net 0,05-0,20, **ZONA GRIGIA** | 3 stop su 4 contro stop-rate 36% e R medio +0,43 |
| Bulge sotto Rif-1 (WR 80%) | p_win ~0,10-0,15 (6 vinte su 10) | WR osservato 60% |
| Bulge sotto Rif-2 (antenato viola) | p ~0,3-0,6 | l'antenato perde gia' (PF 0,69) |
| P6, S1 (giorno <= -4,36%) | 0,5-2% per giorno | audit: 2 giorni <= -5% su 242 con 4 sedie |
| P6, S4 (2 giorni <= osservato P6 ~-4,3%) | 1-5%, **ZONA GRIGIA o EFFETTO al bordo** | due stop DAX da 2% nello stesso giorno sono rari nel contratto (1 giorno in 198, audit) |
| contributo correlazione | positivo ma piccolo sulle code per giorno; il "doppio DAX" ha lift > 1 | le sedie DAX condividono l'apertura |

### 0.7 Contro-esempi obbligatori (costruiti prima; se uno fallisce, i numeri non si consegnano)
- **CE1 (il test sa dire EFFETTO)**: osservato sintetico di **10 stop pieni** (10 x -1,0 R) per la 770411 sotto il suo contratto ->
  deve uscire **p_net < 0,05** (EFFETTO). Se esce NULLO, il test non distingue niente.
- **CE2 (il test sa dire NULLO)**: osservato sintetico = n estrazioni pari alla **mediana** del contratto -> deve uscire **p_net >= 0,20**.
- **CE3 (la correlazione si vede)**: contratto sintetico in cui due sedie hanno gli **stessi giorni di stop** (stop sincroni) ->
  il contributo della correlazione su S1 deve essere **> 0** e chiaramente sopra quello del calendario indipendente; con serie
  gia' indipendenti il contributo deve essere ~0.
- **CE4 (parser)**: totali del trial ritrovati al centesimo (0.2). Rischio DAX ritrovato dentro le bande scritte (0.3).
- **CE5 (il verdetto opposto)**: per la domanda di Claudio si scrive anche **quale esito di 2 giorni avrebbe dato EFFETTO** al
  portafoglio P6 (la soglia di perdita che porta S4 sotto 0,05): se l'osservato ci sta sotto o sopra, si dice di quanto.

### 0.8 Che cosa NON coprira'
Regole vere della Free Trial (si usano 5%/10% del 2-Step solo come metro) · equity intragiornaliera (simulo realizzato) ·
Guardian (pausa 3,5% dalle 13:36 del 01/10: ha ridotto le occasioni, non e' nel modello) · Bulge, 770260, 770511 nel portafoglio ·
regime: tutto il contratto e' un solo anno (2025-26) e il trial e' 2 giorni · presenza effettiva di 770101 e 771531 sul trial
[NON VERIFICATA: `NFP_2026-10-02_SEDIE_TRIAL.md` sez. 0 punto 3] · chiusura della EURGBP del 02/10 22:23 a mercato senza commento
(causa [NON LETTA]: non e' uno stop ne' un TP).

---
# RISULTATI (dopo il commit dei criteri `15d9bc23`; la sezione 0 non e' stata toccata)

Strumenti: `backtest_pipeline/lettura_trial_senza_aperte.py` (copia del parser) e `backtest_pipeline/trial_sfortuna_o_ea.py`
(importa senza modificarli `pertrade_pos` e `leggi_report` di `audit_rischio_flotta.py`). Uscita completa della corsa che fa
fede: `backtest_pipeline/risultati_archivio/TRIAL_SFORTUNA_O_EA_2026-10-03_console.txt` (~7 minuti; con `VELOCE=1` salta le
bande per sedia). Seme 20261003 ovunque.

**Deviazioni dai criteri, dichiarate DOPO i numeri, con la ragione:**
- **D1 - p_net "robusto"**: con n = 1 la p_net congelata misura soprattutto **quanto e' grande uno stop** in unita' di R, non se lo
  stop e' strano: sul banco da 10k della 770105 il pavimento del lotto rimpicciolisce gli stop (mediana -0,969 R) e uno stop pieno di
  campo (-1,002 R) finisce nella coda (p 0,0057); sull'ORB lo stop di campo ha 11,2 punti di slittamento (-1,136 R). Accanto alla
  p_net congelata scrivo la **p_net con ogni R <= -0,70 posto a -1,0** in tutti e due i lati. **Nessun verdetto cambia**: dove
  la differenza e' grande, il test e' gia' NON ANCORA MISURATO per la regola di potenza congelata (0.4 punto 3).
- **D2 - Rif-2**: il `ReportHistory_50503392_2026-10-01.xlsx` contiene solo 12 posizioni `BULGE_MULTI_SIGNAL_VIOLA` (PF 0,45), non
  le 50 citate: il controllo di riproduzione l'ha fermato. La fonte vera del n=50 e' `data/statements/trades_auto.csv` (magic
  20250001, 01/04-05/06/2026): riprodotto **n 50 · PF 0,6949 · netto -438,04** al centesimo. Quel file non ha lo SL: R = netto /
  mediana degli stop (143,65 EUR) [DERIVATO].
- **D3 - presenza delle sedie**: la sezione 0 dava `770101` e `771531` come [NON VERIFICATE] sul trial. Il **profilo salvato** di
  `C:\FTMO` letto dalla sonda notturna (`backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20261003_033003.log`, 03/10 03:30)
  porta 770202, 770260, 770511, 770411, 770105, 770621, 772720 + Guardian/Exporter/SpreadLogger, **e NON 770101 ne' 771531**.
  ✏️ *Corretto dal cancello (03/10), classe 1057 recidiva*: quella sonda **rilegge i `.chr` modificati il 30/09 23:24**, cioe' la
  **stessa foto, scattata PRIMA del trial**, che `NFP_2026-10-02_SEDIE_TRIAL.md` sez. 0 punto 3 aveva gia' dichiarato "non decide"
  (e `HANDOFF.md` r.11 dice il contrario: Algo acceso con 770101 e 771531 dentro). Era nota **prima** del commit dei criteri (la sezione
  0.8 la cita): non e' un'informazione nuova. E la foto **non descrive il trial**: il Bulge B (`BULGE_VIOLA_`, 772700) ha operato il
  01/10 alle 10:00 e **non e' nel profilo**. Gli ordini del trial non decidono neanche loro: nessun ordine da 770101/771531, ma
  nessuno anche da 770202, 770260, 770511 che nel profilo ci sono. Quindi la presenza e' **[INFERITA], NON VERIFICATA** (si chiude
  solo con la faccina a schermo, `PIANO_SEDIE_VIA_PIU_CORTA_2026-10-03.md` riga 3 della tabella delle verifiche). **P4 =
  770105, 770202, 770411, 770621 e' una SENSIBILITA' aggiunta dopo i numeri; il verdetto del portafoglio resta quello congelato,
  su P6.** Scrivo P6 e P4 tutti e due.
- **D4 - sensibilita' aggiunte** (non decidono): Guardian approssimato; stop del banco portati a -1,0; due "sedie-ombra" per
  770260/770511 (serie della 770202 permutata: PROXY, non contratto).

## A. Che cosa e' successo [MISURATO dal report del 03/10]

CE4 superato: **13 posizioni, netto -8.811,59, commissioni -204,04, saldo 151.188,41** ritrovati al centesimo; rischio DAX
770411 **3.237 EUR** (banda 3.199-3.237), 770105 **3.106 EUR**. (Il `lettura_trial.py` originale su questo file si ferma con
`KeyError: 'Posizioni aperte'`: e' la ragione della copia.)

| sedia / famiglia | n | vinte | netto EUR | somma R | % di 160.000 | note |
|---|---:|---:|---:|---:|---:|---|
| `770411` MaxMin DAX short | 1 | 0 | -3.292,52 | -1,017 | -2,06% | 01/10 09:59 -> 10:06, stop; il 02/10 sell stop piazzato e cancellato alle 10:30 |
| `770105` DAX Apertura RETEST short | 1 | 0 | -3.110,48 | -1,002 | -1,94% | 01/10 11:13 -> 13:36, stop, **stesso giorno e stessa direzione** della 770411 |
| `770621` ORB Dow | 1 | 0 | -537,86 | -1,136 | -0,34% | 02/10 16:46 -> 16:48, stop con **11,2 punti** di slittamento (0,14 R) |
| **Bulge** (A 0,80% · B 1,00% · "BULGE VIOLA" 0,80% misurato dai lotti) | 10 | 6 | -1.870,73 | -1,685 | -1,17% | 3 stop, 6 TP, 1 chiusura a mercato senza commento (EURGBP 02/10 22:23, -0,48 R, causa [NON LETTA]) |
| **totale** | **13** | **6** | **-8.811,59** | | **-5,51%** | |

- Per giorno, **realizzato**: 01/10 **-5.815,64 = -3,635%** · 02/10 **-2.995,95 = -1,872%** (di 160.000). Il -4,36% del pannello FTMO
  e' in **equity** (flottante dentro): il realizzato del giorno peggiore e' -3,635%.
- **Composizione della perdita**: i due DAX **-6.403,00 = 72,7%** · Bulge **-1.870,73 = 21,2%** · ORB **-537,86 = 6,1%**.

## B. I contratti, ricalcolati dal per-trade [MISURATO]

| sedia | n contratto | WR | R medio vinte / perse | payoff | stop-rate | R medio | PF | DD @1% (fonte) |
|---|---:|---:|---|---:|---:|---:|---:|---|
| `770411` (770413, 100k) | 14 | **57,1%** | +1,401 / -0,853 | 1,64 | 35,7% | +0,435 | 2,16 | **1,92%** (`CONTRATTI_DELLE_SEDIE` par. 4) |
| `770105` (R251 792520, 10k) | 181 | **73,5%** | +0,318 / -0,822 | 0,39 | 22,7% | **+0,016** | 1,065 | 12,74% (R251); cella esatta a 100k **PF 0,957, DD 12,31%** (R270) |
| `770621` ORB (770612, 100k) | 119 | **40,3%** | +1,801 / -0,714 | 2,52 | 35,3% | +0,300 | 1,674 | **9,76%** (`CENSIMENTO_ORB` riga 13) |
| **Bulge** | -- | **[NON MISURATO]** | -- | -- | -- | -- | -- | **[NON MISURATO]** |

## C. Per sedia: la probabilita' sotto il contratto (punti 1-4 del mandato)

Binomiale esatta per le vincite (p_win); p_net = bootstrap 200.000 (MC, errore +-0,002 al massimo) e convoluzione esatta dove
calcolabile (le due coincidono entro l'errore MC in tutti i casi: secondo controllo dello strumento); banda 5-95% su 2.000
ricampionamenti del contratto.

| oggetto | osservato | p_win | p_net congelata [banda] | p_net robusta D1 [banda] | p_min (potenza) | **verdetto** |
|---|---|---:|---|---|---:|---|
| `770411` trial | 0/1, -1,017 R | 0,429 | 0,143 [0,000-0,294] | 0,357 [0,144-0,573] | 0,429 | **NON ANCORA MISURATO** (n = 1, senza potenza) |
| `770105` trial | 0/1, -1,002 R | 0,265 | 0,0057 [0,000-0,016] *artefatto d'unita'* | **0,227** [0,177-0,281] | 0,265 | **NON ANCORA MISURATO** (senza potenza) |
| `770621` ORB trial | 0/1, -1,136 R | 0,597 | 0,025 [0,004-0,051] *lo slittamento dello stop* | **0,353** [0,282-0,431] | 0,597 | **NON ANCORA MISURATO** (senza potenza) |
| Bulge | 6/10, -1,685 R | -- | -- | -- | -- | **NON ANCORA MISURATO (contratto assente)** |
| *estensione* `770411` challenge + trial | 1/4, -2,413 R | 0,214 | **0,040** [0,002-0,175] | 0,042 [0,002-0,179] | 0,034 | **EFFETTO** (al bordo; la banda arriva a 0,18) |
| *estensione* `770105` challenge + trial | 1/2, -0,947 R | 0,460 | 0,100 [0,067-0,137] | 0,149 [0,106-0,196] | 0,070 | NON ANCORA MISURATO (senza potenza) |

- **Lettura, con l'avvertenza del campione sottile**: nel trial ogni sedia indice ha fatto UNA operazione. Uno stop pieno, sotto il
  suo contratto, capita **il 23% (770105), il 36% (770411), il 35% (ORB)** delle volte: preso da solo **e' ordinaria amministrazione**.
  Due giorni non possono dire niente sul merito di una sedia, e la regola di potenza lo dice prima di me.
- **La 770411 su tutto FTMO (9 giorni, 4 posizioni)**: **EFFETTO al bordo** sul netto (p 0,040; la binomiale delle vincite dice
  0,21: segnali discordi, decide il netto come congelato) e **fuori sulla frequenza**: 4 posizioni contro 0,46 attese, **P(>=4) =
  0,0013**. La RFWD del 30/09 ha mostrato che il tester BCM rifa le stesse operazioni (non e' esecuzione). Quindi la frase giusta e':
  **il contratto della 770411 (14 posizioni in un anno) non descrive la sedia che opera oggi**, ne' per frequenza ne' per esito.
  Con un contratto da 14 operazioni la banda di p va da 0,002 a 0,18: e' **il contratto a essere sottile**, il rischio (stop pieni
  da 2%) e' invece un fatto accaduto, a qualunque n.
- **La 770105 non e' "sfortunata": il suo contratto dice gia' che non guadagna.** R medio +0,016 sul banco da 10k e **PF 0,957 alla
  cella esatta a 100k** (R270: bocciata per rischio, in campo per firma di Claudio del 25/09). Uno stop della 770105 e' il suo
  comportamento atteso, non un incidente.
- **Bulge, contratto [NON MISURATO]** -- quindi nessun numero di "sfortuna" e' possibile. Quello che si puo' misurare:
  - con i payoff **del trial stesso** (vincita media +0,290 R, perdita media -0,856 R) serve **il 74,7% di vincite per pareggiare**;
    all'ingresso (TP/SL degli ordini, senza costi) il **77,3%**. Il trial ne ha fatte il **60%**. [MISURATO]
  - **se** il Bulge fosse il backtest dichiarato da Claudio (Rif-1, WR 80,22%, modello a due punti): p_win 0,117, **p_net 0,031**
    [0,026-0,038] -> il trial sarebbe raro;
  - **se** il Bulge fosse il suo antenato in forward solo viola (Rif-2, n 50, PF 0,6949): p_win 0,201, **p_net 0,225** [0,050-0,510]
    -> il trial e' ordinario. Cioe': **il trial del Bulge assomiglia, sul netto, al forward che perde, non al backtest che vince.** Non e' un
    verdetto (R92b non e' chiuso): e' il verso in cui puntano i due soli riferimenti che abbiamo.

## D. Portafoglio (punto 5 del mandato)

Calendario 2025.07.01 -> 2026.06.29, **260 giorni lavorativi, 259 coppie consecutive**; P/L **realizzato** alle taglie di campo;
"osservato P6" = 770411 + 770105 + ORB nel trial = **-4,338%** in 2 giorni. Intervalli = Clopper-Pearson 95% sul conteggio.

| statistica | **P6** (6 sedie, sezione 0: DECIDE) | **P4** (presenza INFERITA dal profilo del 30/09, D3: sensibilita') | P4 + 2 ombre (proxy) | P6 col Guardian appross. | P4 col Guardian appross. |
|---|---|---|---:|---:|---:|
| S1 un giorno <= -4,36% | **6/260 = 2,3%** [0,9-5,0] | 1/260 = 0,4% [0,0-2,1] | 0,9% | 0,0% | 0,0% |
| S1 un giorno <= -3,635% (realizzato del 01/10) | 12/260 = 4,6% [2,4-7,9] | 5/260 = 1,9% [0,6-4,4] | 3,9% | 7,3% | 2,3% |
| S2 2 giorni consecutivi <= -5,51% | **6/259 = 2,3%** [0,9-5,0] | 3/259 = 1,2% [0,2-3,4] | 2,1% | 1,5% | 1,2% |
| S3 almeno uno dei 2 giorni <= -4,36% | 12/259 = 4,6% [2,4-8,0] | 2/259 = 0,8% [0,1-2,8] | 1,8% | 0,0% | 0,0% |
| **S4 (PRIMARIA) 2 giorni <= -4,338%** | **15/259 = 5,8%** [3,3-9,4] | **5/259 = 1,9%** [0,6-4,5] | **4,2%** | 5,0% | 1,5% |
| bootstrap 2 giorni i.i.d. (S2 / S3 / S4) | 3,3% / 4,6% / 5,9% | 1,2% / 0,8% / 1,7% | | | |
| **verdetto su S4** | **ZONA GRIGIA** (congelato) | EFFETTO *se* 770101 e 771531 non c'erano [NON VERIFICATO] | EFFETTO al bordo | ZONA GRIGIA al bordo | EFFETTO |

✏️ *Ricostruzione indipendente del cancello (03/10)*: `backtest_pipeline/trial_sfortuna_controllo_indipendente.py` (cicli espliciti,
solo libreria standard, nessun import dagli strumenti di sopra; uscita in
`backtest_pipeline/risultati_archivio/TRIAL_SFORTUNA_CONTROLLO_INDIPENDENTE_2026-10-03_console.txt`) ritrova **S1-S4 identici** per P6
(15/259) e P4 (5/259). Due scelte di implementazione muovono i numeri, nessuna il verdetto: (a) R sul **deposito fisso** invece che
sul saldo composto -> P6 S4 **18/259 = 6,9%** (ZONA GRIGIA), S2 10/259; P4 invariato; (b) lo strumento **scarta in silenzio 4
posizioni EMA200 chiuse di domenica** (07/09/2025 due vinte, 21/06/2026 due stop da ~-1 R): portate al lunedi', P6 S2 6 -> 7, S4
invariato.

- **CE5 (il risultato che avrebbe girato il verdetto)**: il 5o percentile delle coppie di giorni e' **-4,51% per P6** e **-3,10%
  per P4**. L'osservato **-4,34%** sta 0,17 punti SOPRA la soglia di P6 (quindi ZONA GRIGIA per un soffio) e 1,24 punti SOTTO quella
  di P4.
- **Il Guardian** (pausa a -3,5%: il giorno si ferma, ma si ferma anche il recupero) toglie i giorni peggiori di -4,36% realizzato
  e **aumenta** quelli intorno a -3,6/-4,2%: S4 resta 1,5-5,0%. Approssimazione **per eccesso** (taglia anche posizioni aperte prima
  della soglia: il per-trade ha solo le uscite).
- **Stop del banco portati a -1,0 (D4)**: fattori 0,985-1,032; S1-S4 **invariati** (S1 realizzato 4,6% -> 5,0%).
- **Cosa spinge P4 in su, non misurato**: (i) 770260 e 770511 (attaccate, senza per-trade): con due ombre indipendenti S4 sale da
  1,9% a 4,2%; (ii) la 770411 nel contratto opera 14 giorni su 260, in campo ~9 volte di piu' (0,44 contro 0,051 al giorno, sezione C): con la frequenza di
  campo le giornate di doppio stop DAX sarebbero piu' frequenti. Tutti e due i termini spingono p **verso l'alto** (verso "sfortuna"):
  **l'EFFETTO di P4 e' un limite basso della rarita', non un punto fermo.**

### Quanto pesa la correlazione [MISURATO]

| | calendario (vero) | stesso indice allineato, indici indipendenti | tutte indipendenti | contributo **stesso indice** | contributo **fra indici** |
|---|---:|---:|---:|---:|---:|
| P6, S1 giorno <= -4,36% | 2,31% | 1,69% | 1,02% | **+0,67** | +0,62 |
| P6, S3 (2 giorni, uno <= -4,36%) | 4,63% | 3,36% | 2,03% | **+1,33** | +1,28 |
| P6, S4 (primaria) | 5,79% | 5,50% | 4,26% | **+1,25** | +0,29 |
| P6, S2 (2 giorni <= -5,51%) | 2,32% | 2,96% | 2,09% | +0,88 | -0,65 |
| P4, S4 ✏️ | 1,93% | 1,25% | 0,99% | **+0,27** (DAX +0,28 · Dow ~0) | **+0,68** |

✏️ *Riga P4 corretta dal cancello (03/10)*: qui c'era "P4 ha un solo indice con due sedie: il DAX" e il solo totale +0,96. **Falso**:
in P4 il Dow ha due sedie (770202 e ORB 770621). Scomposta (2.000 permutazioni, seme 20261003, strumento indipendente sopra): **due
terzi della correlazione di P4 vengono dagli indici DIVERSI**, non dallo stesso indice.

- **La correlazione piu' che raddoppia la probabilita' di un giorno <= -4,36%** (1,0% -> 2,3% su P6) e **raddoppia** quella del
  risultato di 2 giorni su P4 (1,0% -> 1,9%). Sui giorni singoli pesano in parti simili lo stesso indice e gli indici diversi; sul
  risultato di 2 giorni di **P6** pesa quasi tutto **lo stesso indice**; su **P4 no** (+0,27 stesso indice, +0,68 fra indici).
- ✏️ **Le 5 coppie di P4 sotto l'osservato, sedia per sedia** [MISURATO, strumento indipendente]: due contengono il **15/10/2025**,
  giorno in cui **tutte e quattro** le sedie di P4 prendono stop (le due short DAX **e** le due Dow: e' un giorno di mercato, non
  "di DAX"); le altre tre **non contengono la 770411**: 770105 stoppata due giorni di fila (21+24/11/2025, 16+19/01/2026, con
  770202 nel secondo) e 770202 da sola a -4,06% (09+12/01/2026). Le due short DAX stoppate lo stesso giorno sono quindi **una
  giornata su cinque** delle rare, non "la" causa.
- **Il DAX**: giorni con stop di **due** sedie DAX (770101, 770105, 770411) **14 su 260, contro 7,45 attesi se fossero indipendenti:
  lift 1,88**. ✏️ *Ma per coppia*: **11 dei 14 sono 770101 long + 770105 short** (lo stesso motore nei due versi, frustato nella
  stessa mattina), 1 e' 770101 + 770411, e **solo 2 sono le due short 770105 + 770411**; e la 770101 sul trial non risulta nel
  profilo salvato (D3). Per le due short: stop insieme in 2 degli 11 giorni di compresenza contro ~0,8-0,9 attesi
  [DERIVATO: 11 x 0,227 x 0,357; oppure 260 x 0,158 x 0,019]: **P(>=2) ~0,19-0,22 sotto indipendenza (Poisson)**, cioe' il
  contratto **non distingue** una correlazione fra le due short dal caso. Il 01/10 e' una giornata con le due short DAX stoppate
  in sequenza; il lift 1,88 **non** e' una misura di quella coppia.
- Il contributo "fra indici" su S2 e' negativo (-0,65): sulle perdite piu' grandi DAX e Dow nel contratto si compensano un poco.
  Un anno solo: [INCERTO] come segno.

## E. Contro-esempi (sezione 0.7) ed esiti

| # | caso costruito | atteso | ottenuto | esito |
|---|---|---|---|---|
| CE1 | 10 stop pieni della 770411 | EFFETTO | p_net **0,00002** | regge |
| CE2 | 3 posizioni alla mediana del contratto (+0,759 R) | NULLO | p_net **0,656** | regge |
| CE3 | due sedie gemelle con gli stessi giorni di stop / una coppia gia' indipendente | contributo > 0 / ~0 | **+0,0189** / +0,0023 (= 0,6 giorni su 260: la risoluzione del calendario) | regge |
| CE4 | totali e rischio del trial | al centesimo | 13 · -8.811,59 · -204,04 · 151.188,41 · 3.237 · 3.106 | regge |
| CE5 | la perdita di 2 giorni che avrebbe dato EFFETTO | soglia scritta | P6 -4,51% · P4 -3,10% (osservato -4,34%) | scritto in D |
| **CE6 (trovato, non previsto)** | la p_net congelata a n = 1 | dovrebbe dire "ordinario" per uno stop pieno | **0,0057** sulla 770105 e **0,025** sull'ORB: misura la **taglia** dello stop (pavimento del lotto del banco, slittamento), non la sua probabilita' | **il verdetto regge** solo grazie alla regola di potenza congelata; senza, avrebbe scritto due EFFETTO falsi. Corretto con D1 |
| CE7 (trovato) | Rif-2 dal file sbagliato | n 50, PF 0,6949 | 12 posizioni, PF 0,45 | fermato dall'`assert`, fonte corretta (D2) |

## F. Attese contro esiti

| oggetto | previsione (sezione 0.6) | esito | |
|---|---|---|---|
| 770411 trial | p 0,30-0,45, NON ANC. MIS. | 0,143 congelata / 0,357 robusta, NON ANC. MIS. | verdetto giusto, p congelata fuori banda per CE6 |
| 770105 trial | p 0,30-0,50, NON ANC. MIS. | 0,0057 / 0,227, NON ANC. MIS. | idem |
| ORB trial | p 0,40-0,60, NON ANC. MIS. | 0,025 / 0,353, NON ANC. MIS. | idem |
| 770411 challenge+trial | ZONA GRIGIA 0,05-0,20 | **EFFETTO 0,040** | **smentita** di poco: peggio del previsto |
| Bulge Rif-1 | p_win 0,10-0,15 | 0,117 | presa |
| Bulge Rif-2 | p 0,3-0,6 | 0,225 | un poco sotto |
| P6, S1 | 0,5-2% per giorno | **2,3%** | appena sopra: il contratto a 2% fa piu' giornate rosse di quanto pensassi |
| P6, S4 | 1-5%, grigia/effetto al bordo | 5,8% grigia (P6) · 1,9% effetto (P4) | presa; ✏️ decide P6 (congelato), P4 e' condizionato a una presenza NON VERIFICATA |
| correlazione | positiva, piccola per giorno; lift DAX > 1 | **piu' che raddoppia** S1; lift 1,88 | **smentita sul "piccola"** |

## G. Che cosa NON copre (oltre alla sezione 0.8)
- Le regole vere della Free Trial; l'equity intragiornaliera (tutto e' realizzato); gli ingressi bloccati dal Guardian nel trial.
- 770260, 770511 e Bulge nel portafoglio (solo ombre e riferimenti, mai contratti); la 770411 alla sua frequenza di campo.
- Un anno solo di contratto (2025-26, un regime) e due giorni di trial: le probabilita' sono descrittive.
- Il grafico vivo di `C:\FTMO`: la presenza viene da un profilo salvato il **30/09 23:24** (prima del trial), riletto dalle sonde
  del 01, 02 e 03/10 (classe 1057: una sonda che rilegge la stessa foto non e' una seconda misura). **P4 e' condizionato a questo.**
- ✏️ *Aggiunte del cancello (03/10)*: (i) la regola di potenza e' applicata dallo strumento come **max** fra il p_min binomiale e
  quello del netto: e' una lettura della sezione 0.4 (che li elenca tutti e due senza dire come si combinano), fissata nel codice
  **dopo** il commit dei criteri. Con il solo p_min del netto (statistica primaria), a n = 1 sarebbe 1/181 = 0,0055 per la 770105
  e 1/119 per l'ORB: la 770105 e l'ORB uscirebbero **EFFETTO** (l'artefatto di CE6). Il "nessun verdetto cambia" di D1 vale **sotto
  questa lettura**, che e' la prudente, e va detto. (ii) Il p_min del netto stampato in console (`netto 0.0000` per 770105 e ORB) e'
  un difetto di arrotondamento di `p_net_esatto` (valori a 1e-6, soglia non arrotondata): il valore vero e' 1/m; non entra in
  nessun verdetto perche' domina il binomiale. (iii) La 770411 ha un **secondo contratto** aperto (`CONTRATTI_DELLE_SEDIE` B8:
  promozione 26/07, n 41 deal ~27 posizioni, PF 2,05): qui si usa quello da 14 posizioni; l'eccesso di frequenza si vede anche sul
  campo BCM (0,50 sul piccolo, 0,57 sul 100k: `CONTRATTI_DELLE_SEDIE` par. 6), quindi non e' un fatto del solo FTMO. (iv) I "9 giorni"
  della 770411 su FTMO contano 22-30/09 + 01-02/10 senza verificare da quando la sedia fosse accesa sulla challenge: se meno, P(>=4)
  scende ancora.

## H. LA RISPOSTA ALLA DOMANDA DI CLAUDIO
1. **Esecuzione: sana.** Il tester BCM rifa le operazioni di FTMO (RFWD 30/09); gli slittamenti sono entro ~1 punto sul DAX e
   frazioni di pip sul forex, salvo lo stop dell'ORB (11 punti, 0,14 R). Non e' un guasto.
2. **Sedia per sedia, in due giorni: NON ANCORA MISURATO.** Una operazione ciascuna; ogni stop, preso da solo, capitava il 23-36%
   delle volte. Due giorni non bocciano e non assolvono nessuna sedia.
3. ✏️ *(riscritto dal cancello, 03/10)* **Il conto nel suo insieme: ZONA GRIGIA** sulla misura congelata (P6): un risultato cosi'
   in 2 giorni il contratto lo fa **~6 volte su 100** (15 coppie su 259). Non e' un esito ordinario (NULLO, p >= 0,20), ma non e' nemmeno
   un effetto dimostrato (EFFETTO, p < 0,05). **Se** 770101 e 771531 non erano attaccate (lo dice solo una foto del profilo del 30/09, **NON
   VERIFICATA**: decide la faccina), sarebbe ~2 su 100 (EFFETTO, limite basso). La correlazione **raddoppia** quella probabilita'
   (P4: 1,0% -> 1,9%), ma per due terzi e' **DAX e Dow che perdono lo stesso giorno**, non le due short DAX fra loro: nel contratto
   le due short stoppate insieme sono 2 giorni, compatibili col caso.
4. **Tre pezzi vanno "male" per contratto, non per sorte**: 770105 ha un contratto senza edge (PF 0,957, in campo per firma);
   il Bulge non ha contratto e coi suoi payoff chiede ~75% di vincite (ne ha fatte 60%, contro il 76% del suo antenato in forward;
   somiglia all'antenato che perde, PF 0,69, sul netto (p 0,23), non sulle vincite); la 770411
   su FTMO opera ~9 volte il contratto (0,44 contro 0,051 posizioni al giorno) e perde piu' del contratto (EFFETTO al bordo): **il suo contratto da 14 operazioni non la descrive**.
5. **E un fatto di struttura**: alle taglie di oggi il contratto stesso delle sei sedie produce un giorno realizzato <= -4,36%
   **6 volte su 260** (una ogni ~43 giorni di borsa). Le taglie sono di Claudio: qui nessuna proposta.
