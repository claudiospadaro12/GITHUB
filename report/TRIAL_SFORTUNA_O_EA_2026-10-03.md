# Trial FTMO 1514806751, due giorni (01-02/10/2026): sfortuna o EA? -- una misura, non un'opinione

Domanda di Claudio (03/10): *"siamo stati troppo sfortunati... oppure gli EA vanno male?"*
Stato: **la sezione 0 (criteri, metodi, soglie, attese, contro-esempi) e' scritta e committata PRIMA di calcolare qualunque
probabilita'.** I risultati arrivano dopo, nelle sezioni A-F, e la sezione 0 non si tocca.
Sola lettura: nessun EA, preset, forward, conto o VPS toccato. **Nessuna taglia proposta: le taglie sono di Claudio.**
Etichette: [MISURATO] letto/calcolato da file del repo · [DERIVATO] calcolato da numeri scritti · [NON MISURATO] il dato non c'e'.

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
