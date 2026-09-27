# REFERTO ROUND CORTI B (R260 / R261 / R262 / R263) -- 27/09/2026

**Corsa**: PC di backtest `DESKTOP-H4D7CAJ`, 27/09 09:10-09:54 (43 min; dichiarato 55-63), pin `02c70e17`.
**Archivio grezzo**: `backtest_pipeline/risultati_archivio/ROUND_CORTI_B_2026-09-27/` (commit `3a67aead`).
**18/18 round partiti, 0 file NULLI**, classe 166 (motore = pin, SHA256) in 18/18.
**Metodo**: prima i criteri congelati nei file di testa (`prove/R260c_*` par. 6-8, `prove/R261a_*` par. 6-7,
`prove/R262a_*` par. 5-6, `prove/R263a_*` par. 3-5), poi i numeri, **riletti alla fonte** (CSV e per-trade
dell'archivio, script in sola lettura). La pre-lettura della riga (`RIEPILOGO_ROUND_CORTI_B.txt`) e' stata
verificata, non copiata: dove non torna e' scritto (par. 6).
**Questo referto non promuove, non archivia, non propone taglie, non tocca EA/preset/sedie/conti.**

---

## 0. I VERDETTI, secondo i criteri congelati e SOLO quelli

| round | verdetto | criterio |
|---|---|---|
| **R260c** | **G0 VERDE**: 693 / PF 1,30771 / +24736,49 / DD 5,3158 = R103 alla cifra. La guardia "un trade al giorno" di HEAD `7d0da9f9` e' INERTE nel tester (misurato). R193a non serve piu'. | R1 [R260] |
| **R260a (ORO LONG)** | **R2 RISPETTATO** (279 posizioni, PF 1,336, meta' 1,171 / 1,521). Partizione: **HP** (PF_L >= 1,308), **non HPs** come avevo previsto. Rischio: DD 4,52% a 0,5% > 2,06% -> **FUORI da S3 a 2,00% con tutte e due le formule** [DERIVATO]. Finestra 6,5 anni: il contratto della sedia e' 10,0% a 0,5% sui 22 anni di R100 (straddle), e il solo long sui 22 anni e' **[NON MISURATO]** (par. 1.5, 5a). | R2, par. 6, par. 8 |
| **R260b (ORO SHORT)** | 232 posizioni, PF 1,255 (meta' 1,116 / 1,404). Si riporta, non decide. La previsione accessoria di HPs (PF_S > 1,308) **cade**: su questa geometria il lato debole e' lo SHORT. | par. 6 |
| **R261d / R261c** | **T1 VERDE** (generico = 770411 short al centesimo), **T2 VERDE** (banco = long d'archivio R244b al centesimo). R261a/b si leggono come "il long di 770411". | T1, T2, G1 |
| **R261a (DAX LONG, filtro S&P)** | G2 ok, T3 ok (il filtro MORDE: 147 -> 103 deal). corr=1: 72 posizioni, **PF 0,883 < 1,10 -> NESSUN INDIZIO** (ipotesi H0: il filtro non salva il long). Merito sospeso per costruzione (T4). Rischio: DD 7,82% a 1% > 4,08% -> **FUORI da S3 a 2,00%** [DERIVATO]. | T3, T4, T5 |
| **R261b (DAX LONG, InpMgmtTF)** | 7/7 celle con PF 0,705-0,883, **zero celle sopra 1,00**. Il punto (5) del certificato e' chiuso. | T4 + H0 di R261b |
| **DAX LONG, certificato del 09/09** | **NON ANCORA MISURATO (3: uscita; 4: gemelli col filtro S&P acceso)** -- NON "morto". Mancano i rilievi di R267g2-g4 (trailing, breakeven, parziale), in coda nella riga CORTI C, e i gemelli F40EUR/E50EUR sulla versione col filtro (mai girati, nessun file prova): la casella 4 e' piena solo per il long d'archivio a filtro spento, cioe' con il metro che la casella 3 rifiuta (par. 2.4). | CLAUDE.md, certificato di morte |
| **R262** | G0 VERDE 48/48. EmaSlow 160-280 PASSA, 300 e 320 NO (2/4). **Blocco 160-280 -> punto medio 220 -> CENTRO 220** (interno). A9: +0,002 di PF contro il default 200 -> **"il 200 va bene; lo spostamento e' solo di REGOLA"**. | par. 6 [R262a] |
| **R263** | P0 ok, G0-n VERDE, G0-SOLDI VERDE, G1-incrociato VERDE, G0-STRUTTURA VERDE. **0/48 celle-finestra sotto il muro 10% a 2%**. Curva: il muro cade fra **1,25 e 1,50%** (1,38 IS / 1,44 OOS [DERIVATO]). Muro giornaliero: tutte >= -5% (peggiore -2,47%). | par. 3-5 [R263a] |

---

## 1. R260 -- L'ORO 770402 PER LATO (ABTG_MaxMinNotte, XAUUSD H2, OHLC M1, deposito 100000, rischio 0,5%)

Fonti: `ROUND_R260{a,b,c}/ABTG_MaxMinNotte_XAUUSD_OOS_ohlc_R260{a,b,c}.csv` (gamba 2020.01.01 -> 2026.06.30;
il CSV `_IS` e' il moncone di 1 giorno, Trades 0, ATTESO par. 5) e `PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_7953{01,02,03}.csv`.

### 1.1 Cancelli
| cancello | esito | numero |
|---|---|---|
| R0 | ok | 2 celle per finestra in ogni file |
| **R1 (G0 su R260c)** | **VERDE** | Trades **693** (= 693), PF **1,30771** -> 1,308, Profit **24736,49** -> 24736, DD **5,3158** -> 5,32. Ancora: `risultati_archivio/R103_REFERTO_DRIVER_FOREX_METALLI_20260824_1922.txt` r.75 e r.1728-1732 |
| G1 | ok in 3/3 | CSV gemelli identici; per-trade 795301=795351, 795302=795352, 795303=795353 riga per riga salvo il magic (375/318/693 righe) |
| L0 | ok | 795301: deal_type 1 su 375/375; 795302: deal_type 0 su 318/318; n_a + n_b = 375 + 318 = **693 = n_c** |
| C0 (classe 844) | ok | k = (somma net - Profit)/lotti = **1,8113** (long), **1,8039** (short), **1,8081** (due lati) EUR/lotto, dentro [1,00 ; 3,00] |

**Conseguenza di R1 VERDE**: il binario che si schiererebbe (HEAD `7d0da9f9`) rida' il contratto R103 alla cifra.
La guardia "un trade al giorno" e' inerte nel tester **misurata**, non piu' solo letta. **R193a non si lancia**
(par. 2 della testa: sarebbe un doppione).

**Fatto nuovo, misurato qui (contro-esempio all'ipotesi dell'OCO del par. 6)**: il per-trade del solo-long e' **identico,
riga per riga su close_time e prezzo, alle 375 chiusure long della straddle** (e il solo-short alle 318 short);
**zero giornate** in cui i due file solo-lato chiudono lo stesso giorno. Su 6,5 anni, con questa geometria, l'OCO
**non ha mai rubato una giornata**: n_a + n_b = n_c con l'uguale, non il maggiore. "Solo long" = la straddle
senza le sue 232 posizioni short, stessi ingressi e stesse uscite (cambiano solo i lotti, perche' il saldo cresce diversamente).

### 1.2 I numeri per lato

| file | lato | deal | posizioni | PF CSV | PF in posizioni (net - k x vol) | Profit | Equity DD % (CSV) | DD saldo chiuso dal per-trade (con k) |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| R260a | LONG | 375 | **279** | 1,33476 | **1,3357** | +14.062,14 | **4,5172** | 4,1549% |
| R260b | SHORT | 318 | 232 | 1,25387 | 1,2545 | +9.165,27 | 4,0755 | 3,7284% |
| R260c | due lati | 693 | 511 | 1,30771 | 1,3085 | +24.736,49 | 5,3158 | 4,8861% |

Somma dei netti per posizione = Profit del CSV al centesimo in tutti e tre i file (verifica del k).

### 1.3 R2 -- il merito del long, e la partizione
- (i) posizioni **279 >= 150**; (ii) PF finestra piena **1,336 >= 1,10**; (iii) meta' al 2023.04.01 per data di chiusura:
  prima **135 pos. PF 1,171** (netto +3.799,16), seconda **144 pos. PF 1,521** (netto +10.262,98), tutte e due >= 1,10.
- -> **R2 RISPETTATO: "il long porta edge" sulla geometria del preset, in OHLC.**
- Partizione del par. 6: HP = R2 ok e PF_L >= 1,308 -> **PF_L 1,3357 (posizioni) / 1,33476 (CSV): HP.**
  **La mia previsione scritta (HPs) era sbagliata.** Margine sopra la linea: +0,028 di PF.
- Detto onesto sull'etichetta: HP si chiamava "R19b generalizza", ma R19b dava ~1,8 sul long (tetto dichiarato).
  Quello che si e' generalizzato e' "il long regge da solo sopra il PF della straddle", **non il livello di R19b**.
  E la struttura di R19b ("long lato debole") qui e' **rovesciata**: long 1,336 contro short 1,255.

### 1.4 Il conto anno per anno (spina dorsale), in POSIZIONI, netto meno k x volume, anno = data di chiusura

| anno | LONG pos | LONG netto EUR | LONG PF | SHORT pos | SHORT netto | SHORT PF | DUE LATI pos | DUE LATI netto | DUE LATI PF |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2020 | 42 | +2.940,72 | 1,504 | 28 | -2.631,88 | 0,452 | 70 | +221,93 | 1,021 |
| 2021 | 35 | **-520,70** | 0,928 | 42 | +228,83 | 1,029 | 77 | **-278,48** | 0,982 |
| 2022 | 40 | +1.577,95 | 1,282 | 41 | +4.803,41 | 2,207 | 81 | +6.605,78 | 1,682 |
| 2023 | 42 | **-1.203,85** | 0,851 | 40 | **-1.453,52** | 0,821 | 82 | **-2.701,34** | 0,838 |
| 2024 | 56 | +5.978,98 | 1,784 | 31 | +779,34 | 1,141 | 87 | +6.868,80 | 1,503 |
| 2025 | 47 | +2.989,26 | 1,496 | 38 | +2.997,00 | 1,578 | 85 | +6.419,38 | 1,535 |
| 2026 (a giugno) | 17 | +2.299,78 | 2,557 | 12 | +4.442,08 | 9,204 | 29 | +7.600,42 | 4,412 |
| **totale** | **279** | **+14.062,14** | **1,336** | **232** | **+9.165,27** | **1,255** | **511** | **+24.736,49** | **1,309** |

Anni negativi: long **2/7** (2021, 2023), short **2/7** (2020, 2023), due lati **2/7** (2021, 2023 = gli stessi di R103).
Il 2023 e' negativo su tutti e due i lati. Fonte: per-trade 795301/795302/795303, calcolo in sola lettura.

### 1.5 R3 / par. 8 -- il DD a taglia diversa, DUE FORMULE [DERIVATO]
d = DD misurato a 0,5%. Moltiplicativa: 1-(1-d)^f; lineare: f x d; f = taglia/0,5.
**OHLC M1: ogni DD qui sotto e' un LIMITE INFERIORE** (spread corrente, niente slippage, riempimenti ideali).
Il verdetto di rischio a una taglia lo da' solo una corsa a quella taglia (R193b).

**Oro LONG (R260a), d = Equity DD del CSV 4,5172%:**

| taglia | moltiplicativa | lineare | contro muro 10% (finestra 6,5 anni) | contro 8% (*) |
|---|---:|---:|---|---|
| 0,5% (misurato) | 4,52% | 4,52% | sotto | sotto |
| 1,0% | 8,83% | 9,03% | sotto (nel caso migliore OHLC) | **sopra** |
| 1,5% | 12,95% | 13,55% | **sopra** | **sopra** |
| 2,0% | 16,88% | 18,07% | **sopra** | **sopra** |

(*) **8% = la soglia S3 di R193b, congelata SOLO per la taglia 2,00% sulla sotto-finestra OOS** (`prove/R193b_taglia_MaxMinNotte_XAUUSD.txt`
r.200-202). Alle altre taglie la colonna e' un RIFERIMENTO (stesso margine di 2 punti per l'OHLC, R193b C2), non un cancello congelato.
**E la finestra, che pesa piu' della formula**: tutta questa tabella e' sui **6,5 anni** di R103. Il contratto della sedia e'
**10,0% a 0,5%** dai **22 anni** di R100 (19,72% a 1%, straddle, OHLC; `report/CONTRATTI_SEDIE.md` r.95: *"prop: solo <= 0,5%"*),
e R193b congela (A3 e C4) *"la taglia si decide sul PEGGIORE dei due"* / *"VINCE LA PIU' PRUDENTE"*. Il DD del **solo long sui
22 anni e' [NON MISURATO]**: finche' non c'e', il "sotto" a 1,0% vale per la finestra corta e **non e' una lettura di taglia**.

Seconda misura (per-trade a saldo chiuso con k, minorante: niente flottante), d = 4,1549%: 0,5% 4,15 · 1,0% 8,14-8,31 ·
1,5% 11,95-12,46 · 2,0% 15,61-16,62%.
Per confronto: SHORT d 4,0755% -> a 2,0% 15,33-16,30%; DUE LATI d 5,3158% -> a 2,0% **19,63-21,26%** (= la banda 19,6-21,3% gia' scritta).
**Soglia S3 tradotta a 0,5% (par. 8): d <= 2,00% (lineare) / 2,06% (moltiplicativa). Long 4,52% -> fuori con tutte e due.**
Era scritto prima: "lo ritengo IMPROBABILE". Confermato.

---

## 2. R261 -- LA VERSIONE LONG DI 770411 (ABTG_MaxMinNotte generico, D30EUR M15, TICK REALI, deposito 100000, 1%)

Fonti: `ROUND_R261{a,b,c,d}/*.csv`, `PERTRADE/abtg_trades_ABTG_MaxMinNotte_D30EUR_79540{1,2,3,4}.csv` e `_79545{3,4}.csv`.

### 2.1 Cancelli
| cancello | esito | numeri (riletti alla fonte) |
|---|---|---|
| T0 | ok | R261a 2 celle, R261b 7, R261c 2, R261d 2 |
| **T1 (G0-GEN, R261d)** | **VERDE** | IS 20 / 4766,96 / 1,87803 / 3,0977; OOS 21 / 6143,38 / 2,15985 / 1,9213 = `risultati_archivio/R246/ROUND_R246i/*.csv` al centesimo; per-trade 795404: 21 righe, 14 posizioni, somma 6143,38 |
| **T2 (G0-LONG, R261c)** | **VERDE** | 157 / -3321,63 / 0,74387 / 5,6463 = `risultati_archivio/R244/ROUND_R244b/*_IS_R244b.csv` (cutoff 12) al centesimo; per-trade 795403: 157 righe, 107 posizioni |
| G1 | ok | gemelle R261c e R261d identiche (CSV e per-trade salvo magic) |
| G2 | ok | R261a corr=1 == R261b M15: 103 / -3952,27 / 0,88300 / 7,8243 |
| L0 | ok | 795401, 795402, 795403: tutte deal_type 1; 795404: tutte deal_type 0 |
| C0 / classe 850 | ok | per-trade 795401 = cella **corr=1** (103 righe, somma -3952,27); 795402 = cella **H4** (75 righe, somma -6073,97). DAX: commissione zero, somma = Profit al centesimo |
| **T3** | **il filtro MORDE** | corr=0 147 deal, corr=1 103 deal |

### 2.2 R261a -- filtro S&P spento / acceso
| cella | deal | posizioni | PF | Profit | DD @1% |
|---|---:|---:|---:|---:|---:|
| corr=0 | 147 | [NON MISURATO: per-trade della sola cella corr=1] | 0,90464 | -4.479,57 | 7,9153 |
| **corr=1 ("la versione long")** | 103 | **72** | **0,88300** (in posizioni 0,8828) | -3.952,27 | **7,8243** |

- **INDIZIO**: soglia congelata PF corr=1 >= 1,10 con >= 50 posizioni. 72 posizioni, PF 0,883 -> **nessun indizio**.
  Esito fra le due ipotesi del par. 6: **H0** ("il filtro non salva il long": PF corr=1 ~ PF corr=0, 0,883 contro 0,905).
- Attesa di n: banda 35-63 posizioni; misurate **72, sopra la banda** (il filtro ha tenuto il 70% dei deal, non il 42-58% stimato).
- **T4**: merito sospeso (72 < 150), nessuna cella promuovibile.
- **T5 RISCHIO**: d = 7,8243% a 1% > 4,08% -> **la configurazione NON sta sotto S3 a 2,00%**; banda a 2,00% [DERIVATO]
  = [1-(1-d)^2 ; 2d] = **[15,04 ; 15,65]%**.

### 2.3 R261b -- asse InpMgmtTF (filtro acceso)
| InpMgmtTF | deal | Profit | PF | DD @1% |
|---|---:|---:|---:|---:|
| M15 | 103 | -3.952,27 | 0,88300 | 7,8243 |
| M20 | 100 | -4.443,61 | 0,86920 | 9,5072 |
| M30 | 96 | -11.030,96 | 0,70488 | 11,6818 |
| H1 | 93 | -5.437,15 | 0,82284 | 6,6206 |
| H2 | 84 | -6.950,01 | 0,76136 | 9,2173 |
| H3 | 81 | -6.791,52 | 0,72422 | 8,6610 |
| H4 | 75 | -6.073,97 | 0,72063 | 7,0409 |

- Posizioni: M15 (per-trade 795401) e H4 (795402) hanno **le stesse 72 giornate** (confronto per giorno d'ingresso):
  gli ingressi sono costanti come previsto, cambiano solo i parziali. Nessuna posizione persa al riscaldamento (prima posizione 2024.10.01 in tutte e due).
- Ipotesi nulla "PF piatto": **non piatto, cala** salendo di TF (0,883 -> 0,721). Nessuna cella >= 1,00: non c'e' un altopiano da cui scegliere.
- Costo: la cella M15 sta a **37,9x** lo spread BCM 1,70 (sotto la frontiera 40x, R242a r.219-220); le celle alte migliorano il rapporto, ma perdono di piu'.

### 2.4 Il certificato del 09/09 sul DAX LONG, applicato alla lettera
| # | requisito | stato dopo R261 |
|---|---|---|
| 1 | PF misurato | SI -- ora 0 celle >= 1,00 su 41 distinte a tick (33 d'archivio + 8 nuove di R261: corr=0, corr=1/M15, M20..H4). Massimo 0,947 (archivio), 0,905 fra le nuove |
| 2 | n e DD | SI -- corr=1: 72 posizioni, DD 7,82% @1% |
| 3 | **uscita ad asse** | **NO** per la versione long di 770411: nell'archivio solo `InpTP2_R` su un'altra geometria (ATR 1,5, filtro spento; 3,5 e 4,0 = manopola inerte), mai trailing / breakeven / parziale sul long (`report/STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md` A.4). Li misurano **R267g2 (trailing), R267g3 (breakeven), R267g4 (parziale)**, file scritti prima dei numeri, **in coda nella riga CORTI C, non girati**. L'asse InpMgmtTF di R261b muove anche lo stop e il trailing, ma il file di testa lo assegna alla casella 5: contarlo due volte sarebbe riempire due caselle con una misura sola |
| 4 | simboli gemelli | **SI per il long d'archivio, NO per la versione long di 770411**: F40EUR max 0,99852, E50EUR 0,83979, 100GBP 0,63157, tutti a filtro S&P SPENTO; col filtro acceso mai girati (nessun file prova in repo). Lo stesso metro della casella 3, che non conta l'asse `InpTP2_R` d'archivio perche' e' un'altra geometria a filtro spento, vale anche qui |
| 5 | TF cambiato | **SI -- chiuso da R261b** |

**Verdetto: NON ANCORA MISURATO (3: uscita; 4: gemelli col filtro acceso). Non e' "MORTO".** Sulla versione col filtro mancano
due caselle, e la regola del CLAUDE.md dice che ne basta una. Numeri da tenere accanto: PF 0/41 sopra 1,00, versione long 0,883 su 72 posizioni.
**E il limite, che fa parte della stessa regola**: con PF < 1,10 su tutte le 41 celle, **nessun allargamento sui parametri
d'ingresso**. Gli assi ammessi sono quelli dell'uscita (R267g2-g4) e i simboli gemelli della versione col filtro (F40EUR, E50EUR: **nessun file
prova scritto, non in coda**); solo dopo tutti e due, se restano sotto 1,00, il certificato e' completo. L'alternativa e' dichiarare
per iscritto che il filtro S&P non cambia il candidato: ma allora, con lo stesso metro, l'asse `InpTP2_R` d'archivio riempie la
casella 3. **Un metro solo per tutte e cinque le caselle.**

---

## 3. R262 -- DOVE FINISCE A DESTRA L'ALTOPIANO DI InpEmaSlow (770201, U30USD M5, tick, deposito 10000, 1%, ora fissa 14:30 BCM)

Fonti: `ROUND_R262{a,b,c,d}/ABTG_Nasdaq_Apertura_US_U30USD_{IS,OOS}_R262{a..d}.csv`.

### 3.1 G0 contro R245
Confronto sulle stringhe del CSV (Trades, Profit, PF, Equity DD %, Peggior Giornata %) contro
`risultati_archivio/R245/ROUND_R245{a..d}/*.csv`, EmaSlow 160..260 x IS/OOS x 4 TP: **48 celle su 48 identiche -> G0 VERDE**.
R245 e R262 si leggono insieme.

### 3.2 La selezione (C-a PF >= 1,10 · C-b n >= 150 · C-c DD <= 10,00%, IS e OOS; un valore passa con >= 3 TP su 4)

| EmaSlow | TP che passano | esito | cosa cade |
|---|---|---|---|
| 160 | 3/4 | PASSA | TP 0,33: DD OOS 10,40 |
| 180 | 3/4 | PASSA | TP 0,33: DD OOS 10,40 |
| 200 | 3/4 | PASSA | TP 0,84: PF IS 1,059 |
| **220** | 3/4 | **PASSA -- CENTRO** | TP 0,84: PF IS 1,062 |
| 240 | 3/4 | PASSA | TP 0,84: PF IS 1,039 |
| 260 | 3/4 | PASSA | TP 0,84: PF IS 1,063 |
| 280 | 3/4 | PASSA | TP 0,84: PF IS 1,035 |
| 300 | 2/4 | **NO** | TP 0,67: PF IS 1,048 e DD IS 10,52; TP 0,84: PF IS 0,963 e DD IS 10,57 |
| 320 | 2/4 | **NO** | TP 0,67: PF IS 1,036 e DD IS 10,52; TP 0,84: PF IS 0,947 e DD IS 10,57 |

**Applicazione della regola del par. 6, parola per parola**: blocco = corsa contigua che contiene 180 = **160-280**
(bordo sinistro 140 misurato da R245, n IS 147). Punto medio (160+280)/2 = **220**, valore di griglia esatto, nessuna
parita'. Vicini 200 e 240 passano: **centro INTERNO**. E' l'esito scritto prima: *"280 si', 300 no -> blocco 160-280 -> 220"*.
**Altopiano CHIUSO da tutte e due le parti** (140 a sinistra, 300 a destra).

### 3.3 La mediana del blocco (regola "mai la cella 200", par. 5 b)
PF sulle 7 celle 160-280, mediana [min-max]:

| TP | PF IS | PF OOS | DD IS | DD OOS |
|---|---|---|---|---|
| 0,33 | 1,320 [1,299-1,377] | 1,465 [1,336-1,489] | 6,82 [6,82-6,82] | 8,12 [7,73-10,40] |
| **0,50** | **1,265** [1,246-1,313] | **1,481** [1,315-1,489] | 7,13 [6,83-8,18] | 6,62 [6,44-8,07] |
| **0,67** | **1,240** [1,198-1,313] | **1,454** [1,271-1,460] | 6,82 [6,82-7,09] | 7,32 [7,00-8,27] |
| 0,84 | 1,062 [1,035-1,135] | 1,521 [1,340-1,530] | 7,57 [7,21-9,54] | 7,30 [6,99-8,05] |

### 3.4 E' meglio del default? (A9)
Default = 200 (compilato r.240 e centro di R245). Mediana del PF OOS delle TP 0,50 e 0,67: **a 220 = 1,4677; a 200 = 1,4654**.
Differenza **+0,0023**, sotto lo 0,10 della regola A9. -> **"Il 200 va bene; lo spostamento e' solo di REGOLA."**
E' un risultato: il centro per regola passa da 200 a 220, il merito no.

### 3.5 Le due ipotesi scritte prima -- l'esito cade FRA le due, e va detto
- **H1** ("continua fino a 320: 280/300/320 passano 3 su 4") -> **FALSA**: 300 e 320 passano 2 su 4.
- **H2** ("a un valore >= 280 cadono almeno DUE fra TP 0,33/0,50/0,67") -> **FALSA anche lei**: a 300 e 320 cade UNA
  sola (TP 0,67); la seconda che cade e' la 0,84, che H2 non contava.
- Quindi H1 e H2 non erano esaustive (classe 737, e registrata come **classe 858**: H2 contava le cadute su 3 TP, la regola
  le conta su 4; l'esito "cade una sola delle tre + la 0,84" non stava in nessuna delle due). **Il centro lo decide la regola del par. 6, che e'
  univoca**, non le ipotesi. La mia previsione (H1, altopiano aperto) era sbagliata.
- Contro-esempio (b) del par. 5 ("lo scalino OOS"): a 280-320 l'OOS **non** torna ai livelli 160-180 (1,31-1,34):
  resta 1,46-1,56. La chiusura a destra viene **dall'IS**, cioe' dalla finestra dove il seme dell'EMA (par. 4) conta di piu'
  ([DERIVATO] ~15-17 giornate a due lati su ~158 a 280-320). La regola la legge come chiusura, e io la scrivo cosi';
  aggiungo solo che e' una chiusura IS con l'OOS che sale.
- **Due coppie ferme in OOS**: fra 260 e 280 l'OOS e' **identico al centesimo in tutte e 4 le TP** (201 posizioni, stessi
  soldi); fra 300 e 320 quasi (differenze di 0,46 EUR). **Ma NON e' una manopola inerte oltre 260**: fra 280 e 300 l'OOS si
  muove (TP 0,50: PF 1,488 -> 1,531, n 201 -> 200). Due passi fermi su tre non fanno una regola (classe 738).

---

## 4. R263 -- IL DD MISURATO A 2% DEL 770201 (U30USD M5, tick, deposito 100000)

Fonti: `ROUND_R263{a..g}/*.csv`, `PERTRADE/abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_7664{11,12,13,14}.csv`,
ancore `archivio_R247_pertrade_765271.csv` / `_765273.csv` e `risultati_archivio/R248/ROUND_R248a/*_IS_R248a.csv`.

### 4.1 Cancelli (si guardano per primi)
| cancello | esito | numero |
|---|---|---|
| P0 | ok | InpRiskPercent = 2 in tutte le righe di a-f, 1,00..2,00 in g; InpEmaSlow e InpTP1_R del file |
| Asse piatto (contro-esempio del par. 4) | **NON piatto** | DD IS 7,31 -> 14,22, OOS 7,01 -> 13,81: il pin del rischio morde, R263 **non** e' nullo |
| G0-n (a-d) | **VERDE** | Trades = R245 in 48/48 celle-finestra (IS 153/154/154/157/158/158, OOS 197/197/197/199/200/201); zero rifiuti da cercare |
| **G0-SOLDI (g)** | **VERDE** | cella 1,00 OOS: 197 / 30658,23 / 1,48439 / 7,0104 / -1,2309 = R248a gamba IS alla cifra |
| G1-incrociato | **VERDE** | R263g 2,00 == R263b 200 == R263e IS == R263f IS/OOS: IS 154 / 22815,34 / 1,22718 / 14,2242 / -2,2452; OOS 197 / 66772,73 / 1,47779 / 13,8102 / -2,4680 |
| G1 gemelle (e, f) | ok | CSV identici; per-trade 766411=766412, 766413=766414 salvo magic |
| G0-STRUTTURA (e, f) | **VERDE** | 766411 contro R247 765271: 154/154 righe, 0 diverse su close_time, deal_type, price; 766413 contro 765273: 197/197, 0 diverse |
| C0 | ok | 4 per-trade presenti; somme 22815,34 e 66772,73 = Profit CSV |

### 4.2 La curva DD(taglia) della cella 200 / 0,50 (R263g) -- e' la curva su cui firma Claudio
| rischio | DD IS | DD OOS | PF IS | PF OOS | Peggior Giornata IS / OOS |
|---|---:|---:|---:|---:|---|
| 1,00% | 7,3133 | 7,0104 | 1,22944 | 1,48439 | -1,1208 / -1,2309 |
| 1,25% | 9,0956 | 8,7260 | 1,22818 | 1,48379 | -1,4033 / -1,5425 |
| 1,50% | **10,8457** | **10,4256** | 1,22587 | 1,48352 | -1,6833 / -1,8427 |
| 1,75% | 12,5589 | 12,1465 | 1,22537 | 1,48165 | -1,9644 / -2,1551 |
| 2,00% | 14,2242 | 13,8102 | 1,22718 | 1,47779 | -2,2452 / -2,4680 |

**Dove cade il muro statico del 10%**: fra 1,25 (sotto in tutte e due le finestre) e 1,50 (sopra in tutte e due).
Interpolazione lineare fra i due punti misurati **[DERIVATO]**: **IS 1,379%**, **OOS 1,437%**; la finestra che morde
per prima e' l'IS. Attesa scritta prima: "fra 1,25 e 1,50 (lineare 1,38 IS / 1,43 OOS)" -> confermata.
Muro giornaliero (-5%): mai toccato, peggiore **-2,47%** a 2% (OOS).

### 4.3 Il blocco 160-260 a 2% (R263a-d): 0 su 48 sotto il muro
DD minimo a 2%: IS **14,2242** (in 17 celle su 24 il valore e' identico al centesimo: lo stesso tratto di IS), OOS **13,1332** (260 / TP 0,50).
Attesa "0 celle su 24" confermata. Rapporto DD(2%, 100000) / DD(1%, 10000) di R245: **1,926-2,084** in 48/48, dentro la banda scritta [1,80 ; 2,10].
Il centro nuovo 220 / 0,50 a 2%: IS 14,2242, OOS 13,4999 (misurato in R263b). **La sua curva DD(taglia) NON e' misurata**
(R263g e' su 200; G0-SOLDI esiste solo per 200).

### 4.4 R263e/f -- per-trade a 2%, letto con `r247_sovrapposizione.py --deposito-nuovo 100000 --rischio-base 2.0` (classe 843)
| file | finestra | DD MASSIMO del saldo chiuso | attesa | peggior giornata chiusa | posizioni al tetto 100 lotti | attesa |
|---|---|---:|---|---:|---:|---|
| R263e (766411) | IS 2024.09.30 -> 2025.06.27 | **13,3090%** | [11,5 ; 13,4] | -2,2452% (2024.11.26) | **3** su 154 | 3-7 |
| R263f (766413) | OOS 2025.07.01 -> 2026.06.29 | **11,8764%** | [10,7 ; 12,5] | -2,4680% (2025.07.09) | **6** su 197 | 4-8 |

Il numero e' SOLO la riga "DD MASSIMO del saldo chiuso" (la riga [DERIVATO x1.00] coincide, come deve con `--rischio-base 2.0`).
Le posizioni al tetto rischiano MENO del 2%: il DD a 2% "pieno" sarebbe un po' piu' alto. Slippage non modellato (buco 4 di R263a).

---

## 5. ORO LONG -- COSA MANCA PER UNA SEDIA

Il merito (R2) c'e' in OHLC. Quello che segue e' la lista per nome; **nessuna taglia e' proposta: numeri soltanto**.

**(a) La taglia e' una firma di Claudio.** Tabella DD [DERIVATO, OHLC = limite inferiore], d = 4,5172% misurato a 0,5%:

| taglia | DD moltiplicativa | DD lineare | muro 10% (finestra 6,5 anni) | 8% (*) |
|---|---:|---:|---|---|
| 0,5% | 4,52% | 4,52% | sotto | sotto |
| 1,0% | 8,83% | 9,03% | sotto | sopra |
| 1,5% | 12,95% | 13,55% | sopra | sopra |
| 2,0% (preset FTMO oggi) | 16,88% | 18,07% | sopra | sopra |

(*) **8% = la soglia S3 di R193b, congelata SOLO per la taglia 2,00% sulla sotto-finestra OOS** (`prove/R193b_taglia_MaxMinNotte_XAUUSD.txt`
r.200-202). Alle altre taglie la colonna e' un RIFERIMENTO (stesso margine di 2 punti per l'OHLC, R193b C2), non un cancello congelato.
**E la finestra, che pesa piu' della formula**: tutta questa tabella e' sui **6,5 anni** di R103. Il contratto della sedia e'
**10,0% a 0,5%** dai **22 anni** di R100 (19,72% a 1%, straddle, OHLC; `report/CONTRATTI_SEDIE.md` r.95: *"prop: solo <= 0,5%"*),
e R193b congela (A3 e C4) *"la taglia si decide sul PEGGIORE dei due"* / *"VINCE LA PIU' PRUDENTE"*. Il DD del **solo long sui
22 anni e' [NON MISURATO]**: finche' non c'e', il "sotto" a 1,0% vale per la finestra corta e **non e' una lettura di taglia**.
**E la taglia non e' neutra sul regolamento**: il preset stesso (r.98-99) scrive *"La taglia e' UNIFORME su tutte: FTMO vieta le
size erratiche (Forbidden Practices, 'substantially larger or smaller position sizes')"*, e R193b C3 lo dice per questa sedia: una
sedia a 0,5-1,0% accanto alle altre a 2,00% tocca il **regolamento della prop**, non solo il DD. Anche questo e' della firma di Claudio.

**(b) R193b** (`prove/R193b_taglia_MaxMinNotte_XAUUSD.txt`, scritto il 20/09, **mai girato**): 4 taglie (0,5/1,0/1,5/2,0) x 2 finestre
= **8 passate**, OHLC, deposito 100000; e' la misura vera del DD alla taglia. Tre cose da sapere prima di lanciarlo:
(1) la sua nota di lancio punta a `-TerminaleBacktest "C:\MT5_Backtest"` = banco `50504400`, **spento per firma del 21/09**:
serve una riga nuova sul PC di backtest; **in `backtest_pipeline/righe/` nessuna riga lo lancia** (R193b compare solo come
fonte delle formule nelle righe CORTI B e CORTI C); (2) misura la **STRADDLE** (`InpAllowShort=true`, r.247): per il solo long
serve una variante con `InpAllowShort=false` e magic vergine (file prova nuovo, non scritto qui); (3) la sua S3 si legge a 2,00% sulla sotto-finestra OOS.

**(c) L'EA non e' su `C:\FTMO`.** Misurato: `CODA_06_quale_codice_gira_20260926_033003.log` r.179-239 elenca 56 `.mq5`, fra
cui **non** `ABTG_MaxMinNotte.mq5` (STATO_MAXMIN par. B.3). `RINOMINA_CLAU12.ps1` r.129-135 rinomina **7 file** (6 sedie +
Guardian 779001), non questo. Servono: `.mq5` al pin `7d0da9f9` + F7 contro l'include in campo `26a18566` (compilazione
**[NON VERIFICATA]**) + rinomina CLAU12 = **firma di Claudio**, e **nel weekend** (`RICOMPILA_CLAU12_TRAILFIX.ps1` r.364).

**(d) Il preset FTMO e' a due lati.** `mql5/Presets/FTMO/ABTG_MaxMinNotte_ORO_770402_FTMO.set`: `InpAllowShort=true` (r.67),
`InpRiskPercent=2.00` (r.101), `InpMagic=770402` (r.111). Il "solo long" vuole **un preset nuovo con `InpAllowShort=false` e
un magic nuovo** (da cercare vergine). Nello stesso preset `InpMaxSpread=150` contro 0 del banco: effetto **[NON MISURATO]**.

**(e) L'orologio dell'oro**: assunto = forex **[INFERITO]** (nessuna ancora XAUUSD in `OROLOGIO_BCM_2026-09-24.md`).
R260 eredita l'impasto di R103: ~7-8 mesi su 78 col box un'ora prima [DERIVATO].

**(f) Il costo**: stop mediano 32,94 $ contro spread FTMO 0,45 $ = **73,2x** contro frontiera 40x, **[MISURATO su n=2]**
(stop minimo visto 25,23 $ -> 56x); la quota di notti sotto frontiera col box vero e' **>= 4,6%** [DERIVATO, pavimento]
(STATO_MAXMIN par. B.4). Commissione FTMO **[NON MISURATA]**.

**Piu' due buchi che restano**: nessuna riprova a tick reali (tick oro BCM dal 2024.07.05, profondita' [NON VERIFICATA]);
R260d (lo stesso long col trend dell'oro come cancello) e R267a/b (news, box minimo sull'oro) sono in coda nella riga CORTI C.

---

## 6. DOVE LA PRE-LETTURA DELLA RIGA NON TORNA ALLA FONTE
1. **DD a saldo chiuso dei per-trade dell'oro**: la pre-lettura scrive 4,14 / 3,70 / 4,84%. Sono i valori **senza la commissione
   d'ingresso** (ricalcolati: 4,1360 / 3,6981 / 4,8354). Con k x volume sottratto (classe 844): **4,1549 / 3,7284 / 4,8861%**.
   Differenza piccola, ma e' la classe 844 e va scritta giusta.
2. La pre-lettura dice "R2 RISPETTATO" e rimanda la partizione al referto: la partizione e' **HP**, non la HPs prevista.
3. La pre-lettura riporta per R262 "altopiano CHIUSO a destra": vero per la regola, ma **ne' H1 ne' H2** si avverano (par. 3.5).
Tutto il resto (G0, T1, T2, G2, T3, 0/48, curva, 154/197 righe, 3 e 6 al tetto) e' tornato alla cifra.

## 7. NON VERIFICATO / NON MISURATO
- Tutti i DD dell'oro sono OHLC M1: **limite inferiore**; nessuna riprova a tick.
- DD dell'oro long a 1,0 / 1,5 / 2,0%: **[DERIVATO]** a due formule, mai misurato (serve R193b in versione long).
- DD del solo long sui **22 anni** di R100 (la finestra del contratto della sedia, 10,0% a 0,5% sulla straddle): **[NON MISURATO]**;
  R193b A3/C4: la taglia si decide sulla finestra PEGGIORE.
- Spread in memoria del terminale del PC: **[NON PINNATO]** (classe 394); il G0 VERDE di R260c dice che il banco e' equivalente a R103.
- Orologio dell'oro = forex **[INFERITO]**; orologio sul long DAX (inverno un'ora prima della cash) **[NON MISURATO]**.
- R262/R263 a ora fissa 14:30 BCM: **nessun numero descrive FTMO a 16:30** (R250 non girato); R248 = REVISIONE resta aperta.
- Curva DD(taglia) del centro nuovo 220: **[NON MISURATA]**.
- Seme dell'EMA in IS a 280-320: **[DERIVATO]** (nessun file per lato).
- Commissione FTMO su XAUUSD e GER40, SYMBOL_VOLUME_MAX di US30.cash su FTMO: **[NON MISURATI]**.
- La compilazione di `ABTG_MaxMinNotte.mq5` contro l'include in campo `26a18566`: **[NON VERIFICATA]**.
- Il vincolo "weekend" per la compilazione su C:\FTMO e' preso dall'avviso di `RICOMPILA_CLAU12_TRAILFIX.ps1` r.364 (scritto per una ricompilazione su trade vivo).
