# APERTURE NASDAQ - MAPPA di cio' che e' misurato, di cio' che manca, e delle tre misure che costano meno

**03/10/2026** - `cercatore-parametri` - **SOLA LETTURA sul repo**: nessun backtest, nessuna riga di lancio,
nessun preset/EA/sedia/forward toccato, niente VPS, niente conto reale `10105439`, nessuna taglia.
Mandato di Claudio (03/10): aperture intraday del NASDAQ (`NASUSD` BCM / `US100.cash` FTMO), **breakout e retest, long e short
sempre entrambi** (regola dei due lati, 25/08), TF M5 (preferito) M15 M30 H1 H4. Etichette: `[MISURATO]` = letto da un CSV o da
un referto con il percorso accanto; `[DERIVATO]` = calcolato qui da numeri gia' scritti; `[NON MISURATO]` = non c'e', e dice cosa manca.
Non ho cercato sul web: il mandato di questa sessione e' sola lettura del repo; i valori esterni citati stanno gia' in repo (par. 9).

---

## 0. In dodici righe

1. **Per QUESTO motore (`ABTG_Nasdaq_Apertura_US`, sedia `770260`, RETEST due lati, M5) la configurazione che i dati sostengono e' quella in
   campo** (range 35', buffer 200, volumi ON, TP1 0,5R, parziale 50%, BE, trailing M5, rischio 2,00): IS PF 1,221 / OOS PF 1,215, DD
   7,31% / 7,86% alla taglia vera, **82 / 102 posizioni** (135 / 172 uscite) `[MISURATO]`
   `backtest_pipeline/risultati_prove/R199B/ABTG_Nasdaq_Apertura_US_NASUSD_{IS,OOS}_R199B.csv`, Pass 2. **Nessuna cella misurata la batte con
   n >= 150**: la risposta onesta e' "il default in campo va bene", e il merito resta **sospeso** (102 < 150).
2. **Il merito non e' misurabile su tick BCM per questa cella, per aritmetica**: a 0,37 posizioni/giorno servono ~405 feriali per
   150 posizioni in UNA finestra, ~810 per IS + OOS; i tick BCM indici partono il 2024.09.26 (459 feriali al 30/06/2026, 525 al 30/09/2026)
   `[DERIVATO]`. Le vie sono due: lo storico esterno `NASUSD_EXT` (barre M1, OHLC: screening di regime, mai verdetto) o il forward.
3. **Nessuna cella misurata e' "allineata" con la cash USA in tutti i giorni**: l'orologio BCM e' UTC+1 fisso, quindi 14:30 BCM e' la cash
   solo d'estate USA e e' le 8:30 di New York d'inverno. Nella finestra del contratto di `770260` i giorni "pre-cash" sono **90 su 183
   nell'IS (49,2%) e 90 su 276 nell'OOS (32,6%)** `[DERIVATO]` da `report/OROLOGIO_BCM_2026-09-24.md` e dal calendario USA.
4. **Sul Nasdaq la casella dell'orologio non e' mai stata fatta** (DAX, Dow e MaxMin si': R246 e R246 inverno). 0 CSV su 98 con la colonna
   `InpSessionHour` la fanno variare, e 0 su 154 file Nasdaq/NASUSD con le colonne d'ingresso (par. 3) `[MISURATO]`. **Dalle posizioni di R199B si ricava un indizio (non una misura): ~0,69 pos/giorno d'inverno
   contro ~0,22 d'estate** (1,3 sigma). Se fosse vero, la frequenza promessa (0,36-0,37) e' una media di due tassi e la sedia FTMO d'inverno, che
   arma alla cash, farebbe meno.
5. **Costo**: il TF del grafico NON entra nello stop per i meccanismi a range (stop = range, calcolato su M1): 63,9x lo spread a mediana su
   35' `[DERIVATO]` (42,6x al P95 2,70), **nessun TF sfonda il 40x**; ma sullo stop STIMATO della sedia viva (83,2) il P95 da' **30,8x, sotto il 40x**
   (ricostruzione B 117,0: 43,3x), e lo spread FTMO `US100.cash` alle 16:30 e' `[NON MISURATO]`. Lo sfondano solo i motori con stop da ATR o da candela: RANGE_FADE a M5 (19,3x) e M15 (33,4x),
   AtrExhaustVol M5 (10,9x), ORB 5' (26,5x), SupRev H1 (28,7x). Par. 4.
6. **Manopole mai mosse sulla cella viva** (verificato a macchina su tutti i CSV Nasdaq, par. 3): `InpSessionHour/Min`, `InpRangeMinutes`,
   `InpVolMult`, `InpVolAvgBars`, `InpBufferPoints`, `InpTP1_R`, `InpPendingExpiryMin`, `InpCloseHour/Min/AtEnd`, il TF del grafico, il lato.
7. **Tre misure, in ordine di rapporto valore/costo** (par. 6): **R274** l'orologio della cella viva (file prova NUOVI, pronti, 16 passate,
   5-24 min); **R214c/d** il TF M15/M30 della cella viva (gia' scritti e verdi, 8 passate, 2,7-12 min); **R275** il BREAKOUT con volumi ON e la
   gestione d'uscita della sedia viva (descritto, 4 passate, 1,3-6 min).
8. File prova **gia' passati** da `controlla_prova.py` (OK, 4 file, 8 celle, 16 passate, 0 problemi) e da `controlla_riga.py --oggetto prova`
   (EXIT 0, nessun difetto meccanico): `backtest_pipeline/prove/R274{a,b,c,d}_orologio_*_NASDAQ_NASUSD.txt`. **Il secondo strato (`controllo-preventivo`)
   NON e' stato invocato da me: finche' non torna, niente va al PC di backtest.** Nessuna riga di lancio preparata.

---

## 1. Stato di oggi, per non misurare un bersaglio che non c'e'

- La challenge FTMO `541452707` e' **chiusa il 30/09** (`report/FTMO_CHALLENGE_CHIUSURA_2026-09-30.md`, `report/DIARIO.md` 30/09). Dal 01/10 gira la
  Free Trial 160K (login `1514806751` dentro `C:\FTMO`), con **nessuna sedia aggiunta** oltre la flotta della challenge (770101, 770105, 770202, 770260, 771531, 770511, 770411), fra cui `770260`
  (`report/TRIAL_14_GIORNI_CRITERI_2026-10-01.md`). Il binario in campo di `770260` e' al pin `9fca63d9` (`report/NFP_2026-10-02_SEDIE_TRIAL.md`, righe sul binario) e il suo codice e' identico a HEAD: `git diff 9fca63d9..HEAD` su
  `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` contiene solo righe di commento (verificato il 03/10, come per i pin `9fa84716` e `28c18463` di R199B).
- Giornata 01/10: la RETEST Nasdaq ha **saltato** per volumi insufficienti (`report/NOTTE_2026-10-02.md` r.6). E' il filtro volumi che fa il suo lavoro,
  e cioe' la frequenza bassa.
- Frequenza promessa `770260`: **0,360-0,370 posizioni/giorno** (`report/TRIAL_14_GIORNI_CRITERI_2026-10-01.md` r.11; `report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md`
  r.75-83). Con le altre due aperture della flotta (770101 0,699, 770202 0,348) la FAMIGLIA aperture sta a **1,407** `[DERIVATO]`, sopra il pavimento 1,00.
  Il Nasdaq da solo e' il 37% del pavimento.

---

## 2. LA MAPPA: motore x direzione x TF

Lettura: PF IS / OOS, n, DD, banco, finestra. Finestre standard: IS `2024.09.26 -> 2025.06.09`, OOS `2025.06.10 -> 2026.06.30` (taglio 0,40),
**tick reali** salvo dove scritto OHLC. **Regime: un solo (Nasdaq al rialzo, 21 mesi)** salvo le righe EXT. **Orologio: tutte le celle con
`InpSessionHour=14` mescolano le due tempistiche** (par. 5). La colonna rischio conta: i DD a 1% e a 2% non si confrontano.
"pos" = posizioni, "usc" = uscite (con parziale accesa la colonna `Trades` conta uscite, classe 550).

### 2.1 `ABTG_Nasdaq_Apertura_US`, RETEST (`InpEntryMode=2`) - la famiglia della sedia viva

| cella (pin che contano) | direzione | TF grafico | PF IS / OOS | n IS / OOS | DD IS / OOS | rischio | fonte | stato |
|---|---|---|---|---|---|---|---|---|
| **VIVA `770260`**: range 35', buf 200, off 0, vol ON 1,5x20, TP1 0,5R + 50%, BE, trail PREVBAR M5 | **L+S** | M5 | **1,221 / 1,215** | **82 / 102 pos** (135 / 172 usc) | 7,31% / 7,86% | 2,00% | `risultati_prove/R199B/*_R199B.csv` Pass 2 | `[MISURATO]`, merito sospeso (n < 150) |
| id. | **long solo** | M5 | `[NON MISURATO]` | | | | R231a e' scritto ma mai girato | **buco** |
| id. | **short solo** | M5 | `[NON MISURATO]` | | | | R231a (2 celle: short 0/1, 4 passate), nessun CSV in repo | **buco** |
| id. | L+S | **M15** | `[NON MISURATO]` | | | | `prove/R214c_tfgrafico_M15_NASDAQ_770260.txt` pronto, nessun CSV | **buco** (il TF morde: il filtro volumi legge la barra del grafico, r.2530) |
| id. | L+S | **M30** | `[NON MISURATO]` | | | | `prove/R214d_*` idem | **buco** |
| id. | L+S | **H1 / H4** | `[NON MISURATO]` | | | | nessun file prova | **buco**, non preparato (par. 3 e 4) |
| id., senza parziale (ClosePct 0) | L+S | M5 | 1,116 / 1,149 | 82 / 102 pos | 12,36% / 9,12% | 2,00% | R199B Pass 0 | `[MISURATO]` |
| id., offset 200 / 400 / 600 | L+S | M5 | IS 1,283 / 1,286 / 1,300; OOS **0,955 / 0,838 / 0,838** | 96-102 pos | OOS fino a 26,11% | 2,00% | `R198` | `[MISURATO]`: il segno si inverte IS/OOS su 3 celle su 3. **L'offset 0 della cella viva e' al BORDO della griglia (nessun offset negativo provato): non e' un altopiano** |
| id., ClosePct 25 / 50 / 75 | L+S | M5 | IS 1,250 / 1,221 / 1,193; OOS 1,224 / 1,215 / 1,204 | 135 / 172 usc | 7,3-7,9% / 7,5-8,3% | 2,00% | `R199B` | `[MISURATO]`: **altopiano vero, il 50 e' il centro** |
| id., trail TF M1..M15 | L+S | M5 | M5: 1,116 / 1,149 (unico positivo in entrambe con DD OOS < 10%) | 82 / 102 | | 2,00% | `R200A` | `[MISURATO]` M1 primo IS e ultimo OOS = selezione |
| id., `InpMinRangePts` 7200 | L+S | M5 | IS 1,442 / OOS 1,100 | 55 / 75 | 6,90% / 6,94% | 2,00% | `R196A` | `[MISURATO]`, segno IS/OOS che si inverte |
| RETEST L+S, vol **ON**, TP1 0,5R, ClosePct 0, buf 200 | L+S | M5 | 1,145 / 1,109 | 91 / 94 | 5,95% / 3,68% | 1% | `Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` | `[MISURATO]` il vicino piu' stretto |
| id., vol **OFF** | L+S | M5 | **0,814 / 1,041** | 176 / 240 | 16,25% / 8,79% | 1% | idem | `[MISURATO]`: segno IS/OOS opposto = "regime, non edge" |
| RETEST buf 500 off 200 TP1 1R, vol OFF, range 35' | **solo long** | M5 | 0,963 / **1,130** | 156 / 196 | 7,22% / 4,90% | 1% | `Walkforward_Aperture/NASDAQ_M_direzione_{IS,OOS}.csv` | `[MISURATO]` |
| id. | **solo short** | M5 | **1,165** / 0,823 | 142 / 197 | 7,55% / 9,10% | 1% | idem | `[MISURATO]`: i due lati si ribaltano a specchio fra IS e OOS |
| id. | L+S | M5 | 0,928 / 1,022 | 220 / 301 | 11,56% / 7,88% | 1% | idem | `[MISURATO]` |
| RETEST "geometria del Dow" (buf 1000, off 400, EMA H4) | long | M5 | 1,080 / 1,110 | 85 / 113 | - / 5,62% | 1% | `risultati_archivio/R107_REFERTO.md` | `[MISURATO]` |
| id. | short | M5 | **3,220 / 0,460** | 58 / 59 | - / 11,34% | 1% | idem | `[MISURATO]`: "la geometria del Dow non si trasporta" |
| RETEST "geometria nativa" (RangeMode 2, 15', buf 300, EMA H4, flat 20:45) | long | M5 | 1,624 / **0,556** | 133 / 199 | - / 17,50% | 0,65% | `risultati_archivio/REFERTO_R115_2026-08-29.md` | `[MISURATO]` collasso IS->OOS |
| id. | short | M5 | 1,125 / **0,517** | 78 / 96 | - / 12,53% | 0,65% | idem | `[MISURATO]` |
| RETEST, RangeMode 2 (candela H1) o 1 (pre-apertura 5'), 35' | L+S | M5 | OOS **0,665** (RM2) / 0,798 (RM1) contro 1,022 (RM0) | 321-329 vs 301 | OOS 26,29% / 17,35% / 7,88% | 1% | `NASDAQ_L_rangemode_*.csv` | `[MISURATO]`: la formazione "range dei primi 35'" (RM0) e' la migliore; `InpRangeMinutes` e' INERTE con RM 1 e 2 (righe 15' e 35' identiche, verificato) |
| RETEST su griglia range 5-45 x buf x off, vol OFF | L+S | M5 | `NASDAQ_D_retest`: IS best 1,001 / OOS mediana 0,873 best 1,051; `NASDAQ_E_retest_fill_FULL` (20 passate): PF 0,765-1,001 n 382-430 DD 14,65-41,25% | | | 1% | `Walkforward_Aperture/` | `[MISURATO]` negativo |
| `ABTG_Apertura_3Ingressi` n1 "LIMIT sul retest", RangeMode 2, 15', TP1 1R | L+S | **M15** | 0,947 / **0,624** | 187 / 303 | 9,71% / **29,14%** | 1% | `risultati_archivio/r83_csv/`, REGISTRO `R83` | `[MISURATO]`, **motore diverso, stessa parola "retest"**: non e' la sedia (`report/IL_RETEST_SUL_NASDAQ_LA_RICONCILIAZIONE_2026-09-18.md`) |
| `PREOPEN_RETEST_NAS_M15` (livello pre-apertura 5', M15, due lati e solo short) | L / S | **M15** | `[NON MISURATO]` | | | | `prove/PREOPEN_RETEST_NAS_M15{,_SHORT}.txt`: "NON DEVE GIRARE finche' i criteri non sono firmati" | scritto, mai girato, criteri non firmati |

### 2.2 Stesso EA, BREAKOUT (`InpEntryMode=0`) e gli altri meccanismi

| cella | direzione | TF | PF IS / OOS | n IS / OOS | DD IS / OOS | rischio | fonte | stato |
|---|---|---|---|---|---|---|---|---|
| BREAKOUT nudo L+S, vol OFF, range 35', buf 200, TP1 0,5R | L+S | M5 | 0,894 / 0,949 | 182 / 244 | 15,70% / 9,60% | 1% | `NASDAQ_B_motore_*` | `[MISURATO]` negativo |
| BREAKOUT, vol **ON** | L+S | M5 | **1,071 / 1,063** | 114 / 108 | 5,85% / 4,13% | 1% | idem | `[MISURATO]`: **l'unica cella breakout positiva in entrambe le finestre**, mai provata con la gestione d'uscita della sedia viva (R275, par. 6) |
| BREAKOUT, vol ON, `InpVolMult` 1,2 / 1,5 / 1,8 (24 passate) | L+S | M5 | max 1,516 | max 81 | 9,57% | 1% | `risultati_archivio/Nasdaq_Apertura/ablaz_2_vol_NASUSD.csv`, finestra UNICA non spezzata | `[MISURATO]`, nessun IS/OOS |
| BREAKOUT geometria `NASDAQ_A` (range 5-45 x buf, vol OFF) | L+S | M5 | OOS mediana **0,878**, best 1,012 (20 celle) | 250-255 | fino a 24,23% | 1% | `NASDAQ_A_geometria_*` | `[MISURATO]` |
| BREAKOUT "config viva" del 770201 (PREVBAR, 15', buf 200) | L+S | M5 | 1,241 / **0,859** | 165 / 316 | 6,30% / 16,21% | 1% | `risultati_prove/ABTG_Nasdaq_Apertura_US/` r25 | `[MISURATO]`, sedia spenta il 18/08 |
| BREAKOUT, direzione ad asse | long / short | qualunque | `[NON MISURATO]` | | | | la direzione e' stata un asse solo sul RETEST (`NASDAQ_M`) | **buco** |
| `ABTG_Apertura_3Ingressi` n0 "STOP oltre il livello" | L+S | **M15** | 1,254 / 0,873 | 156 / 291 | 6,14% / 17,07% | 1% | `r83_csv`, `r84_csv` (9 celle su 9 OOS negative) | `[MISURATO]`: M15 e' misurato ma e' un altro EA |
| breakdown SOLO SHORT gated (EMA 50x200 H4), `770250` | **short** | **M15** | OOS 1,097 / (IS n.d.) | OOS 104 | OOS 4,54% | 0,65% | `report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md` 4.1 (da `REFERTO_SHORTGATE_2026-08-30.md` r.67) | `[MISURATO]` tick, un solo regime; in campo sul demo BCM, 2 operazioni |
| id., 2020-2024 OHLC `NASUSD_EXT` M15 (crollo 2020, orso 2022) | short | M15 | **1,84** (n 93) | 93 | 2,07% | 0,65% | `risultati_archivio/REFERTO_SHORTGATE_2026-08-30.md` | `[MISURATO]` OHLC = screening; per-trade per regime **mai segmentato** |
| BREAKOUT long solo / short solo, qualunque TF | | | `[NON MISURATO]` | | | | | **buco** |
| GAPFILL | L+S | M5 | 2,083 / 1,937 (+gapnas: OOS fino a 2,87) | **23 / 19** (OOS 16-43) | 4,64% / 3,28% | 1% | `NASDAQ_B_motore_*`, `GapFill_Nasdaq/` | `[MISURATO]`, n sotto 150, **bloccato da una regola**: il gap trading FTMO (`MAIL_FTMO_GAP_TRADING_TERZO_GIRO_2026-08-28.md`, mai partita) |
| OPENCONFIRM | L+S | M5; `InpOCTimeframe` M15 | vol OFF 1,107 / 0,927; vol ON **1,816 / 0,956** | 178 / 240 (OFF), 108 / 104 (ON) | OFF 7,69% / 7,18%; ON 3,75% / 6,72% | 1% | `NASDAQ_B_motore_*`; `Openconfirm/NASDAQ_openconfirm_M15.csv` (96 passate, **9 esiti distinti**) | `[MISURATO]` IS che brilla, OOS no. Il "M15" e' `InpOCTimeframe`, non il TF del grafico |
| DELAYED | L+S | M5 | vol OFF 1,013 / 0,890; ON 1,710 / **0,696** | 184 / 247 (OFF), 56 / 51 (ON) | OFF 12,59% / 12,18%; ON 3,72% / 4,61% | 1% | `NASDAQ_B_motore_*` | `[MISURATO]` |
| RANGE_FADE (R42), rimbalzo su ORL long (r43a) / short (r43b) | L+S, long, short | M5 | R42 su NASUSD: IS best 0,906 / OOS best 0,864 (12 passate per finestra; sul round intero 0/48 positive, PF 0,50-0,93); r43a long OOS mediana 0,827 max 0,984; r43b short OOS mediana 0,613 max 0,666 | R42 210 / 314 | | 1% | `risultati_archivio/REFERTO_ROUND42_FADE.md`, `risultati_prove/aperture_r42/`, `aperture_r43/` | `[MISURATO]`; **casella TF mancante** (M30/H1 per il fade, par. 4) |

### 2.3 Gli altri motori che toccano l'apertura del Nasdaq

| motore | cella | direzione | TF | PF IS / OOS | n | DD OOS | fonte | stato |
|---|---|---|---|---|---|---|---|---|
| `ABTG_ORB` (770601) | range 5' 14:25-14:30, config viva `r7a` | L+S | M5 | 0,824 / 1,050 | 222 / 355 | 19,41% @1% | `report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md` 4.1 | `[MISURATO]`, spenta dal 10/08 (bug), DD ~38,8% alla taglia 2% |
| `ABTG_ORB` | R8 "da manuale" OR 30', vol ON | L+S | M5 | 1,491 / **1,032** (e 1,456 / 1,023) | 190 / 185 | 4,85% / 5,24% | idem | `[MISURATO]` PF 1,02-1,03 = pareggio |
| `ABTG_ORB_Ottimizzato` NASUSD | 216 passate, il LATO non e' mai un asse | L+S | M5 | `r44b` best OOS 1,156 | 135 | **12,26% @1%** | idem; `R97_REFERTO.md`: 4 geometrie OOS 0,84-0,91 | `[MISURATO]`, bocciata sul rischio |
| `ABTG_ORB_Fibo` | cella di default | L+S | M5 | tick **0,803 / 0,851** (OHLC 0,835 / 0,968) | 91 / 75 | 3,66% | `report/LETTURA_ORB_R271_R272_R273_2026-09-29.md` | `[MISURATO]` a tick il 29/09, negativo |
| `ABTG_Nasdaq_Live5m` (770203) | candela 5' pre-apertura | L+S | M5 | 1,016 / **0,963** | 116 / 175 | 19,40% @2% | `REGISTRO_TEST.md` L2 | `[MISURATO]` 27/27 negative; OHLC "2,16" e' artefatto (fattore 2,246) |
| `Nasdaq_PreOpen_Breakout_EA` (esterno) | candela 14:25-14:30 | L+S | M5 | | | | `report/AUDIT_NASDAQ_PREOPEN_2026-09-12.md` | **NON SI SCHIERA**: fuso cablato (`InpLocalUtcOffsetHours=2`) + costo 13,33x |
| `ABTG_IBRetest` NASUSD | retest IB, M30 | L+S | **M30** | **0,563 / 0,593** | 35 / 49 | 5,31% | `report/P0_IBRETEST_NASUSD_2026-09-09.md` | `[MISURATO]`, n sottile, segno concorde negativo |
| `ABTG_IntradayMomentum` NASUSD | `r141a` | L+S | **M30** | 0,609 / 1,243 | 146 / 261 | 3,03% | `REGISTRO_TEST.md` R141 | non giudicabile (IS a 4 operazioni dal pavimento, segno discorde) |
| `ABTG_MaxMinNotte` NASUSD | R187a/b (box notturno, rottura) | L+S | M15 | `[NON MISURATO]` | | | `prove/R187{a,b}_*`: nessun CSV | scritto, mai girato |
| Marco/Emiliano "stile Monza" | base / emiliano | L+S | M5 | finestra unica: 0,842 / 0,760 | 335 / 267 | | `risultati_archivio/Marco_Emiliano/`, `CENSIMENTO_PF_TUTTI_2026-09-09.csv` | `[MISURATO]` senza IS/OOS |

**Il certificato di morte a cinque punti** (PF, n+DD, uscita ad asse, gemelli, TF) **non e' completo per nessuna di queste righe**
(`report/ORB_NASDAQ_PERCHE_E_SPENTO_2026-09-23.md` par. 2: 0 su 12). Il registro `REGISTRO_TEST.md` (A4, A16, L2, O1, O2, S3-S6) usa ancora la parola
"morto" dove il verdetto corretto e' "NON ANCORA MISURATO", per esempio sui TF.

### 2.4 Direzione: cosa dicono le coppie lungo/corto, dove esistono

Tutte le coppie misurate sul Nasdaq mostrano **lo stesso difetto**: un lato brilla in IS e crolla in OOS, l'altro il contrario
(`NASDAQ_M`: long 0,963 -> 1,130, short 1,165 -> 0,823; `R107`: short 3,220 -> 0,460; `R115`: long 1,624 -> 0,556). Questo e' il fingerprint di un
**regime** (discesa feb-apr 2025 dentro l'IS, OOS quasi tutto salita: `R107_REFERTO.md` par. "IL DETTAGLIO"), non di un edge per lato. **Nessuna coppia
lungo/corto e' mai stata misurata sulla cella viva e nessuna ha n >= 150 per lato in tutte e due le finestre.** La prova di regime che separerebbe le
due letture e' proprio quella che serve `NASUSD_EXT` (par. 7).

---

## 3. Le manopole: inerti, mai ad asse, e cosa e' un altopiano

**Verifica a macchina (03/10)**, su tutti i CSV con nome Nasdaq/NASUSD in `risultati_archivio/` e `risultati_prove/` che portano le colonne
`InpEntryMode` e `InpUseVolumeFilter` (154 file), cercando quali input variano DENTRO un file:

- **Sulle righe con RETEST + volumi ON (la cella viva) le uniche manopole mai mosse sono 7**: `InpBEatR` (R199A), `InpMinRangePts` (R196A),
  `InpRetestOffsetPts` (R198), `InpTP1_ClosePct` (R199B), `InpTrailFixedPts` (R200E), `InpTrailMode` (R200C), `InpTrailTF` (R200A). Tutto il resto
  della cella viva non e' MAI stato un asse.
- **Mai ad asse in nessuno dei 154 file**: `InpSessionHour`, `InpSessionMin`, `InpCloseHour`, `InpCloseMin`, `InpCloseAtEnd`, `InpLevelTF`, `InpFilterTF`,
  `InpOCTimeframe`, `InpMaxRangePts`, `InpMinStopPts`, `InpSkipIfTight`, `InpVolAvgBars`, `InpStTF`, `InpVwapTF`, `InpCorrTF`, `InpAtrPeriodMgmt`, i filtri news (66 input in tutto, elenco prodotto dal conto; `InpUseVolRegime` e `InpUseSRFilter` sono stati un asse solo nel lab R30, 2 file). **Sul retest con volumi ON mai mossi**: `InpVolMult` (la manopola che fa la differenza fra IS 0,814 e 1,145; ad asse
  solo sul BREAKOUT, 1,2/1,5/1,8), `InpRangeMinutes` (5-45 solo con volumi OFF), `InpBufferPoints`, `InpTP1_R` (solo 0,5/1,0 con volumi OFF in `NASDAQ_F_gestione`),
  `InpPendingExpiryMin`, il lato.
- **Manopole INERTI misurate** (girate senza che mordessero; l'archivio del 09/09 ne contava 874 CSV su 1.960): `InpRangeMinutes` con `RangeMode` 1 o 2 (righe
  15' e 35' **identiche** in `NASDAQ_L_rangemode_*`, verificato qui); `InpTrailFixedPts` con `TrailMode=1` (`NASDAQ_openconfirm_M15.csv`: 96 passate, **9 esiti
  distinti**); `InpUseVolumeFilter` in `ABTG_ORB_Ottimizzato` r12 (48 passate, 24 distinte); `InpGapMinPoints` 100-300 (`GapFill_Nasdaq`, 24 passate, 6 distinte);
  `InpUseGapFill` con `EntryMode=2` (r.733-736, `R231a` par. 4.1); `InpOneTradePerDay` nel tester (`report/INVENTARIO_MOTORI_APERTURA_2026-09-24.md` par. 5.1);
  `InpUseAtrFilter`/`InpConfirmMode` su RETEST (N9 dell'inventario); `InpBEatR` 1,5 con `TP1_R` 0,5 (geometria: il bersaglio sta a 1,5R); **il TF del grafico su
  BREAKOUT/GAPFILL/RETEST/DELAYED a filtri spenti** (range su `PERIOD_M1` cablato, r.941-954; `report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` par. 1).
- **Altopiano o picco?** `InpTP1_ClosePct` 25/50/75: **altopiano** (IS 1,19-1,25, OOS 1,20-1,22), il 50 e' il centro. `InpRetestOffsetPts`: **picco al bordo** (0 vince in OOS,
  3 vicini su 3 perdono, segno invertito in IS). `InpTrailTF`: M5 e' l'unico positivo in entrambe con DD OOS < 10% ma M1 e M6 sono primi in una finestra e ultimi nell'altra:
  **un centro sostenuto da un vicino solo**. `InpBEatR`: il dominio utile dopo l'accensione del parziale e' 0 < x < 0,5 R e **non e' mai stato misurato** (R209a e' scritto, non girato,
  `report/DD_NASDAQ_IL_ROUND_GIA_FATTO_2026-09-22.md` par. 3-4).
- **Verdetto sulla ricerca di parametri per questa cella**: dove l'altopiano esiste (ClosePct) il default e' gia' al centro; dove non esiste (offset, trail TF) **"non c'e'
  una configurazione robusta provata"** e si scrive cosi'. Non propongo nessuna griglia sui parametri d'ingresso: la regola del 19/08 non e' in gioco (la cella non e' dichiarata senza
  edge: e' positiva in IS e OOS), ma **l'asse VolMult va pagato con una prova fuori campione o di regime** (par. 7).

---

## 4. Il COSTO: frontiera `stop >= 40 x spread` per TF, con lo spread vero

**Spread vero `NASUSD`** (punti indice, 1 idx = 100 punti MT5; commissione CFD indici = 0, `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md`):

| fonte | ora server | mediana / P95 | etichetta |
|---|---|---|---|
| archivio tick 2024.09.26 -> 2026.06.30, 156,1 M tick | **14** / 15 / 16-20 | **1,80 / 2,70** · 1,80 / 2,60 · 1,70 / 1,80 | `[MISURATO]` `risultati_archivio/spread_flotta/spread_orario_NASUSD.csv` |
| id., ore pre-mercato | 0-13 | 2,3-2,6 / 2,7 | `[MISURATO]` |
| logger vivo 04-11/09/2026, 5 s, 5 giornate | tutte | **1,80 / 1,90** | `[MISURATO]` `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` |
| FTMO `US100.cash` ora 10 server (cash chiusa) | 10 | 1,45 / 1,65 (GG=1); un tick 1,53 a mercato chiuso | `[MISURATO]` sottile, `report/SPREAD_APERTURA_FTMO_2026-09-21.md` |
| FTMO `US100.cash` **alle 16:30 server (l'apertura)** | 16 | `[NON MISURATO]` (il logger si e' fermato alle 10:50) | **buco** |

Disaccordo dichiarato: nelle ore pre-mercato l'archivio dice ~2,5 e il logger dice 1,8; l'ora 14 mescola cash d'estate e pre-mercato d'inverno e **lo spread per stagione
`[NON MISURATO]`**. Uso 1,80 (mediana) e 2,70 (P95 ora 14). Frontiera: **40x = 72,0 idx (108,0 al P95)**; pavimento duro 13,3x = 23,9 idx.

| stop (idx) | geometria | M5 | M15 | M30 | H1 | H4 | x a 1,80 | x a 2,70 | etichetta |
|---|---|---|---|---|---|---|---|---|---|
| range 35' mediano 115,0 | BREAKOUT / RETEST / GAPFILL / OPENCONFIRM / DELAYED | passa | passa | passa | passa | passa | **63,9x** | 42,6x | `[DERIVATO]` 75,30 (`Studio_NASUSD`, n=447, 15') x radice(35/15) |
| stop stimato `770260` 83,2 | RETEST viva | passa | passa | passa | passa | passa | 46,2x | **30,8x** | `[DERIVATO]` stima di casa; ricostruzione B 117,0 = 65,0x / 43,3x |
| range 15' mediano 75,3 | `ABTG_ORB_Ottimizzato` OPPRANGE | passa | passa | passa | passa | passa | 41,8x | 27,9x | `[DERIVATO]` |
| range 15' P10 23,8 / 35' P10 36,4 | i giorni stretti | | | | | | **13,2x / 20,2x** | | `[DERIVATO]`: il ~21% dei giorni e' sotto il 40x anche sulla sedia viva (a spread FTMO 1,53, `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` 6.2: 353 su 447 sopravvivono al floor 40x) |
| `1,5 x ATR(TF)`, RANGE_FADE | fade | **19,3x ESCLUSO** | **33,4x ESCLUSO** | 47,3x | 66,8x | 133,7x | | 12,9x / 22,3x / 31,5x / 44,6x / 89,1x | `[DERIVATO]` ATR(TF) = 384,6 x radice(T/1380) (`ANCORA_ADR_FLOTTA_INDICI`), H4 mio dallo stesso conto |
| AtrExhaustVol | stop pivot | **10,9x ESCLUSO** (sotto il duro) | | | | | | | `[MISURATO]` `REGISTRO_TEST.md` r.3289 |
| IntradayMomentum | stop ATR M30 | | | **53,3x** | | | | | `[MISURATO]` `REGISTRO_TEST.md` r.3117 |
| SupRev NAS | stop candela H1 | | | | **28,7x ESCLUSO** | | | | `[MISURATO]` `CANCELLO_COSTO_FLOTTA` r.660 |
| `770601` ORB 5' | stop 47,7 | **26,5x ESCLUSO** | | | | | | | `[MISURATO]` n=9 |
| `PreOpen` esterno | stop minimo | 13,33x ESCLUSO (duro) | | | | | | | `[MISURATO]` `AUDIT_NASDAQ_PREOPEN` |

**Risposta secca alla domanda 2**: per i meccanismi a range (breakout e retest) **nessun TF sfonda il 40x**, perche' lo stop e' il range e non la barra; lo sfondano solo i motori con
stop da ATR o da candela: **M5 e M15** per il fade e per AtrExhaustVol, **H1** per SupRev. Al P95 dello spread (2,70) la sedia viva scende a 30,8x e cala sotto il 40x: **il costo vero
di `770260` dipende dall'ora e dalla stagione dello spread, e quella dipendenza non e' misurata** (par. 5). Il TF M15/M30 della cella viva (R214c/d) non cambia lo stop: cambia il filtro volumi.
**H4**: per i meccanismi a range non c'e' esclusione per costo, ma sul grafico H4 il filtro volumi confronta l'ultima barra H4 chiusa con la media delle 20 precedenti (80 ore):
non e' "la stessa strategia piu' lenta", e' un altro filtro (r.2513-2530 `[DERIVATO]` dal sorgente). Nessuna regola di OnInit rifiuta H1/H4 sul Nasdaq (grep `INIT_PARAMETERS_INCORRECT` e
confini di barra: zero), a differenza di `ABTG_ImpulsoApertura` che rifiuta H1/H2 perche' l'apertura cade a :30 (`REGISTRO_TEST.md` r.3049-3051): **legalita' di H1/H4 `[DERIVATA]`, non provata a tester**.

---

## 5. L'OROLOGIO: quali celle mescolano le due tempistiche

BCM = UTC+1 fisso su tutto l'arco dei tick indici (`report/OROLOGIO_BCM_2026-09-24.md`, quattro ancore su quattro). La cash USA (9:30 New York) cade alle **14:30 BCM con gli USA in
ora legale** (2a domenica di marzo -> 1a di novembre) e alle **15:30 BCM d'inverno**; **al 03/10/2026 siamo in "14:30 = cash"; dal 02/11/2026 14:30 BCM = 8:30 New York**. FTMO (16:30
FTMO) e' alla cash tutto l'anno tranne le settimane in cui gli USA sono gia'/ancora in ora legale e l'Europa no (26-30/10/2026 e marzo 2027): li' arma un'ora dopo `[DERIVATO]`.

Conteggio feriali (calcolato a mano e confrontato con il cancello, che stampa 180/279 sulla finestra intera):

| finestra | feriali | USA estate (14:30 = cash) | USA inverno (14:30 = 8:30 NY) | UE inverno | USA estate + UE inverno (FTMO tardi) |
|---|---:|---:|---:|---:|---:|
| IS `2024.09.26 -> 2025.06.09` | 183 | 93 | **90 (49,2%)** | 110 | 20 |
| OOS `2025.06.10 -> 2026.06.30` | 276 | 186 | **90 (32,6%)** | 110 | 20 |
| tutta `2024.09.26 -> 2026.06.30` | 459 | 279 | 180 | 220 | 40 |
| fresca `2026.07.01 -> 2026.09.30` | 66 | 66 | 0 | 0 | 0 |

- **MESCOLANO le due tempistiche (tutte)**: ogni cella di par. 2 con `InpSessionHour=14` sulla finestra 2024.09.26 -> 2026.06.30: R199B e tutta la serie R196-R200, `NASDAQ_A..M`,
  `R83/R84`, `R97`, `R107`, `R115`, `ORB r7/r8/r44b`, `Live5m`, `770250`, `R42/R43`. **Nessuna cella misurata sul Nasdaq arma "alla cash" in tutti i giorni.** Il per-trade della cella
  RETEST non e' in repo (`OROLOGIO_BCM` par. 5.1.1 `[NON MISURATO]`), quindi non si puo' nemmeno dividere a posteriori.
- **NON mescolano per costruzione**: le corse su `NASUSD_EXT` 2010-2024 (barre M1 con l'orologio vecchio "italiana - 1" tutto l'anno: 14:30 e' la cash USA tutto l'anno tranne ~20 feriali
  l'anno, `OROLOGIO_BCM` par. 5.1.4): `SHORTGATE` 2020-2024, R113. Sono OHLC, quindi screening di regime.
- **Indizio sul Nasdaq, su un'altra cella** (`r84a_776010`, `EntryMode=0`): PF 0,70 nei mesi allineati contro 1,39 nei mesi sfasati; chiusure alle 14:xx in 158 casi su 192 (allineati)
  contro 15:xx in 55 su 99 (sfasati) (`OROLOGIO_BCM` par. 5.1.1-5.1.2).
- **Per DAX e Dow l'orologio ha gia' dato numeri**: DAX d0 inverno (1h prima della cash) PF 1,389 con 0,764 pos/g contro d+1 inverno (alla cash) PF 1,184 con 0,627 pos/g; d'estate 1h prima
  della cash PF 0,774 contro 1,108; Dow sospeso (`report/LETTURA_R246_INVERNO_2026-09-29.md`). **Non si trasferisce al Nasdaq: stesso meccanismo, EA e feed diversi.**
- **L'indizio di frequenza che muove R274** `[DERIVATO]`: R199B Pass 0 ha 82 posizioni su 183 feriali (IS: 90 inverno + 93 estate) e 102 su 276 (OOS: 90 + 186). Il sistema
  `90w + 93s = 82 ; 90w + 186s = 102` da' **s = 0,215 +- 0,146 e w = 0,689 +- 0,230** pos/feriale (1 sigma, Poisson), differenza 0,474 +- 0,371 = **1,3 sigma: indizio, non misura**
  (esattamente determinato, assume lo stesso tasso stagionale nelle due finestre).

---

## 6. LE TRE MISURE (miglior rapporto "avvicina una sedia schierabile" / costo)

Metro di costo: **20,1 s/passata** misurato sulla famiglia (R202A, Dow M5 tick, 8 passate in 2 min 41 s, tetto superiore, `risultati_prove/R202A/`); bordo alto del coordinatore 89,6 s/passata;
il Nasdaq ha 156,1 M tick contro 64,7 M del Dow nella stessa finestra, quindi ~48 s `[DERIVATO lineare]`. **Tutte sul PC di backtest `DESKTOP-H4D7CAJ`, mai sul VPS** (firma 21/09).
Nessuna si lancia da qui: servono la riga di lancio, il cancello e la firma di Claudio.

### Misura 1 - R274: l'orologio della cella viva (retest due lati) - FILE PROVA PRONTI

`backtest_pipeline/prove/R274a_orologio_d0_B_NASDAQ_NASUSD.txt` (testa, 369 righe dopo il secondo strato) · `R274b_orologio_d1_B_*` · `R274c_orologio_d0_A_*` · `R274d_orologio_d1_A_*`.
**4 file x 2 celle gemelle (asse = magic, G1) x 2 finestre = 16 passate; 5-24 min (centro ~13), le A costano meno.** Magic `798201/798251 · 798211/798261 · 798202/798252 · 798212/798262`,
vergini (zero occorrenze in repo e su tutti i rami remoti).

- **Cosa misura**: la cella viva (R199B Pass 2, 97 pin copiati e **verificati a macchina contro la riga del CSV**: diffe-
  renze = magic, `InpNewsCurrencies` vuoto, e nei file d+1 `InpSessionHour` 14 -> 15 e `InpCloseHour` 17 -> 18) armata alla vecchia ora (d0, 14:30) e un'ora dopo (d+1, 15:30 = alla cash
  d'inverno, come FTMO), con per-trade per leggere i giorni per stagione (USA e UE). **Una variabile per file**: l'orologio in blocco, oppure la finestra.
- **Attesa, scritta prima dei numeri** (nel file, par. 4): sulle posizioni dei 180 feriali d'inverno USA di A+B, **H_ORA** (conta l'orologio) -> la d+1 d'inverno fa ~39 posizioni (1 sigma 12-65);
  **H_STAGIONE** -> ~124 (83-166); disgiunte; la zona 65-83 e' MISTO. Verdetto con Qf2 = (r_w0 - r_w1)/(r_w0 - r_s0), zone 0,30/0,70, **precondizione** r_w0 - r_s0 >= 0,15 pos/g
  (sennò "divario non riprodotto" e nessun verdetto). PF: si scrive, **non decide** (n < 150).
- **Soglie congelate**: **R2 frequenza** della serie "come FTMO" (d0 nei 238 giorni UE d'estate + d+1 nei 220 giorni UE d'inverno) < 0,25 pos/g = meno di due terzi del promesso 0,37 ->
  revisione di Claudio (corsia TAGLIANDO, firma 18/08); **R1 rischio** (Emendamento B, a qualunque n): DD di saldo della serie > 10% -> revisione immediata (confronto: contratto 7,31% / 7,86%).
- **Cancelli**: G0 (R274a riproduce R199B Pass 2: Trades e DD esatti, Profit entro 1,00 EUR, PF/RF entro 0,0002 -- tolleranza di banco scritta prima, dal residuo NASUSD di R235: 0,97 EUR), G1 (gemelle identiche, stessa tolleranza), G2 (A e B coerenti fra loro e col CSV; il 26/09/2024 puo' spostare tutti i lotti dopo, si dichiara), S1 sentinella dell'orologio (nessuna uscita
  prima di 16:05 / 15:05 ne' dopo flat+1'; uscite >= 23:00 = GIALLO da leggere per data, regola scritta ora dopo il caso Memorial Day del Dow).
- **Contro-esempio** (nel file, par. 5): pin non arrivato -> per-trade di d+1 identico a d0 e colonna `InpSessionHour` = 14 -> NULLO; le due ipotesi producono bande disgiunte (nessuna
  sovrapposizione al 1 sigma, quindi la banda MISURA qualcosa: classe 178); se il divario d'inverno/estate non si riproduce la mia derivazione era rumore (1,3 sigma) e il registro lo scrive.
- **Cosa decide**: se la sedia FTMO d'inverno (alla cash dal 02/11) fara' **meno** di quanto il contratto promette, e di quanto. Non decide **quale** orario mettere (decisione di Claudio entro il 25/10).
- **Cosa NON misura** (elenco per nome nel file, par. 6): spread/feed FTMO alle 16:30, Guardian, commissione FTMO, inverni 2010-2024, quale lato fa la frequenza, il calendario UE di FTMO.
- **Buco dichiarato**: lo **script di lettura** per questa famiglia (l'analogo di `backtest_pipeline/r246_giudizio_d1.py`, con `--autotest`) **non esiste**: va scritto PRIMA di aprire i per-trade, con questi
  criteri come specifica. `[NON FATTO in questa sessione]`.

### Misura 2 - R214c/R214d: il TF del grafico M15 e M30 della cella viva - GIA' SCRITTI E VERDI

`backtest_pipeline/prove/R214c_tfgrafico_M15_NASDAQ_770260.txt` · `R214d_tfgrafico_M30_NASDAQ_770260.txt`; `controlla_prova.py` rilanciato il 03/10 a HEAD: **OK, 2 celle ciascuno, pin 97, 0 problemi**.
**8 passate, 2,7-12 min.** Sono gli unici file della famiglia dove il TF del grafico morde davvero: la cella viva ha `InpUseVolumeFilter=true` e `VolumeOK()` legge la barra del grafico (r.2530).

- **Attesa (nel file, par. 4)**: salendo di TF il filtro rifiuta meno -> **n >= 135 usc in IS e >= 172 in OOS**; sul PF **nessuna direzione dichiarata**. Se n scende, l'attesa e' falsificata e va detto per primo.
- **Soglie (par. 6)**: "M15 meglio di M5" solo se TUTTE E TRE in OOS: RF >= 1,29687, DD <= 7,8576, Profit >= 7647,07; "M5 va bene" se RF e DD stanno dentro il 10% (e' un risultato, non un fallimento);
  DD > 9,0% in una finestra = notizia in cima. **Il merito resta sospeso** (102 pos): R214 misura, non propone.
- **Contro-esempio**: `@PERIODO` non arrivato (CSV identico al base) -> si apre il `.ini`; "e' il tester che consegna i tick diversi" -> si rompe col controllo incrociato sul Dow (R214a/b, `ABTG_Dow_Apertura_US`,
  dove il TF e' inerte e deve dare l'identita'). **Buco dichiarato nel file**: nessuna ancora di regressione possibile (il TF entra nei numeri), solo G1.
- **Perche' vale**: e' la leva di FREQUENZA della sedia (il filtro volumi e' cio' che la porta a 0,37) e chiude la casella TF del certificato di `770260` nell'unico punto in cui il TF conta.
- **Attenzione**: H1 e H4 NON sono coperti da nessun file; se Claudio li vuole, e' un file nuovo con la stessa struttura e il significato di "filtro regime a 80 ore" dichiarato (par. 4).

### Misura 3 - R275: BREAKOUT con volumi ON e la gestione d'uscita della sedia viva - DESCRITTA, FILE NON PREPARATO

**Perche'**: il BREAKOUT con volumi ON e' l'unica cella breakout positiva in entrambe le finestre (IS 1,071 n 114 / OOS 1,063 n 108, DD 5,85% / 4,13% a 1%, `NASDAQ_B_motore_*`) e **non ha mai
avuto la gestione d'uscita che ha spostato il retest** (ClosePct 0 -> 50 + BE a 0,5R: PF IS +9,4%, OOS +5,8%, DD IS -40,9%, OOS -13,9%, R199B). E' la meta' "breakout" del mandato, con un asse
ammesso dalla regola del 19/08 (gestione d'uscita, non parametri d'ingresso).
**Cella**: `EntryMode=0`, resto del pin di R274a, **asse `InpTP1_ClosePct` 0 / 50** (2 celle, 4 passate), banco 80.000, rischio 2,00, tick, M5, finestra B 0,40, magic gemelli nuovi.
**Costo**: 4 passate, 1,3-6 min `[DERIVATO]`.
**Attesa, scritta ora**: PF IS 1,07 -> 1,12-1,17 e OOS 1,06 -> 1,10-1,12 col parziale (per analogia di direzione con il retest, **non un numero promesso**); DD a 2% da ~11,7% / ~8,3% (il doppio del DD a 1%
di `NASDAQ_B`) verso 8-9%; n pos ~108-114 per finestra (**sotto 150: merito sospeso**, si legge il rischio). **Soglie da congelare nel file**: segno non ribaltato fra IS e OOS; PF >= 1,10 in entrambe;
DD <= 10% a 2% in entrambe; G0: la cella ClosePct 0 deve restare dentro +-0,05 di PF e +-10% di n rispetto a `NASDAQ_B` (pin diversi: rischio 2 e non 1, quindi G0 GIALLO, non VERDE).
**Contro-esempio**: se PF sale con n invariato e DD scende (come nel retest) e' la gestione; se PF sale e n crolla e' un taglio; **il modello del sovra-filtro e' gia' in casa** (DELAYED+volumi IS 1,710 -> OOS 0,696).
**Collisione da dichiarare**: due sedie sullo stesso simbolo e stesso orario si ostacolano (`PositionClose(_Symbol)`, `report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`): la toppa per ticket e' nel binario
`9fca63d9` ma **due sedie Nasdaq sovrapposte non vanno accese senza una misura di compresenza** (come `report/ORB_DOW_100K_COMPRESENZA_2026-09-13.md`). Non e' una proposta di schieramento.

### Gia' pronti e adiacenti (non nelle tre, costo minimo)

`R231a_lato_corto_NASDAQ_NASUSD.txt` (4 passate, verde al cancello, mai girato): spegne il corto della cella viva; **l'unico lato acceso della rosa che nessuno ha mai pesato**. Attesa del file:
n(short=0) 88-96 IS e 112-122 OOS; T3 "discordi" e' un esito probabile (FASE M: solo short +IS/-OOS). Il merito e' sospeso; se T2 esce si "propone di spegnerlo" (firma di Claudio) e **spegnere un lato riduce la
frequenza**, il contrario di cio' che serve; per questo non e' fra le tre. `R209a` (BEatR 0-0,5 R): 5 celle, mai girato, dominio nuovo dopo l'accensione del parziale; valore basso.

**Ordine proposto**: R274 (nuovo, decide cosa vale il contratto d'inverno) -> R214c/d (leva di frequenza) -> R275. Totale 28 passate, **9-42 min**. **Nessuna e' lanciabile finche' non passa il secondo strato.**

---

## 7. L'allargamento si paga: la prova di regime (NON proposta come quarta misura, e' il suo pagamento)

Ogni asse nuovo sulla cella viva (`InpVolMult`, `InpRangeMinutes` con volumi ON, `InpTP1_R`, buffer) dev'essere pagato con una prova fuori campione o di regime. L'unico storico lungo e' **`NASUSD_EXT`**
(5.233.590 barre M1, 2010.11.14 -> 2026.07.31, **firma di Claudio 26/08 "FIRMO FRIGO NASUSD"**, rapporto diff/vol 0,199 contro soglia 0,20: il bordo piu' sottile possibile,
`report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` par. 1.2). Ritmo `NASUSD_EXT`: **~0,3 min/cella** (R113: 18 celle su 16 anni in 5,4 min). Vincoli, dichiarati:

- **OHLC, non tick**: il fattore OHLC->tick misurato e' **1,71-1,85 in eccesso** (2,246 sul Live5m): un numero EXT apre una prova di regime, non e' un verdetto.
- **Volume su `NASUSD_EXT`: `[NON MISURATO]`** (le colonne di `ABTG_ImportEsterno_referto.csv` non lo dicono). Se e' zero, `VolumeOKtf` esce con `avg <= 0 -> return true` e **la cella "volumi ON" gira come "volumi OFF"
  senza avvisare** (IS 0,814 / OOS 1,041 su tick). Va controllato PRIMA di leggere un solo PF.
- **L'orologio EXT e' quello vecchio** (italiana - 1 tutto l'anno): lo screening e' allineato alla cash, a differenza dei tick BCM.
- Misure di regime utili: retest e breakout x long e short x quattro finestre (toro, orso, laterale, crollo; la macchina di R50-R59), con la sola cella-viva senza volumi e il lato come asse: e' l'unico modo di
  avere n >= 150 per lato. **Non e' un file prova di questa sessione**: richiede il controllo del volume e la firma sui criteri.

---

## 8. Il verdetto che i dati sostengono, per QUESTO motore

1. **Configurazione**: la cella in campo. Nessuna cella misurata la batte con n >= 150 e in tutte e due le finestre; dove c'e' un altopiano (ClosePct 25-75) il default e' al centro;
   dove la cella vince "al bordo" (offset 0) o su un vicino solo (trail TF M5) **non c'e' una configurazione robusta provata**.
2. **Meglio del default?** La cella in campo batte la sua versione precedente (ClosePct 0) su PF, DD e profitto in tutte e due le finestre (R199B) e la versione a volumi OFF (IS 0,814): **ma tutto a n < 150**: e'
   indizio forte, non verdetto.
3. **Frequenza**: 0,37 pos/g, al 37% del pavimento di famiglia; la sedia contribuisce alla FAMIGLIA aperture (1,407 con DAX e Dow) ma non e' una sedia ad alta frequenza.
   La leva di frequenza misurabile con meno costo e' il filtro volumi (R214c/d); la leva di mercato e' l'orologio (R274).
4. **Direzione**: non c'e' nessuna misura per lato sulla cella viva; le coppie vicine si ribaltano fra IS e OOS (regime).
5. **Certificato di morte**: nessun candidato di par. 2.2-2.3 e' archiviabile come "morto": mancano TF cambiato (tutti), gemelli (quasi tutti), uscita ad asse (breakout vol ON).

---

## 9. Valori di riferimento esterni gia' in repo (nessuna ricerca web in questa sessione)

| valore | fonte e data | uso |
|---|---|---|
| strategia Nasdaq dei colleghi: TF M15, canale = max/min dei 15' prima dell'apertura, pendenti +7..+10 punti, SL 5 punti, BE a +30, RR 1:2, parziale 50% | `docs/live_emiliano/c05566f8-Piano_Trading__NASDAQ__ABTG.pdf` letto in `report/IL_NASDAQ_IN_PUNTI_E_IL_DAX_2026-09-23.md` par. 1 (23/09) | i **rapporti** si trasferiscono, i numeri assoluti in punti no (sul Nasdaq 5 punti = 2,8x lo spread: sotto il pavimento duro) |
| set ORB di Lee Samson, NAS "5 and 15 Tight": range 16:30 -> 16:35/16:45, SL 300, trail 400, BE 100, rischio $1000; NAS "5 Percent": SL 400, trail 1000, auto-uscita a +4%; offset 0, `close_all = -2500` | `report/CACCIA_CONFIG_PROP_2026-10-01.md` N16 (blog 751385, 05/01/2023, MT4) | unita' `[INCERTO]`: se 400 = 40 punti. Valori per la gestione d'uscita, non strategia |
| Artemis NAS100 ORB Edge M5 v1.30 (130+ parametri, solo `.set`, codice non visibile) | `report/ARTEMIS_NAS100_ORB_2026-08-21.md` (21/08) | riferimento di nomi/valori |
| Free Trial FTMO: 14 giorni, target 5%, 5% giornaliero, 10% statico | `report/CACCIA_CONFIG_PROP_2026-10-01.md` | vincolo del DD alla taglia 2,00% |

---

## 10. Buchi dichiarati (per nome)

1. Per-trade della cella RETEST viva in repo: **non c'e'**. Non si puo' dividere R199B per stagione ne' per lato.
2. Spread `US100.cash` all'apertura (16:30 FTMO) e per stagione: **non misurato**. Disaccordo archivio/logger nelle ore pre-mercato.
3. Volume di `NASUSD_EXT`: **non misurato**; commissione FTMO su CFD indici: **non misurata** (ogni "x" FTMO e' un tetto).
4. Legalita' a tester di H1/H4 sul Nasdaq: **derivata dal sorgente, non provata**; H1/H4 non hanno file prova.
5. Lo script di lettura di R274 (bootstrap/bande e `--autotest`): **da scrivere** prima di aprire i per-trade.
6. Il fattore OHLC -> tick sul retest a limite (non solo sul breakout): `[NON MISURATO]`.
7. Il feed `US100.cash` contro `NASUSD`: diversi ("Il tester non e' FTMO", `report/RFWD_CRITERI.md` r.191); le cifre BCM descrivono il banco, non il campo.
8. Se FTMO segue il calendario UE all'ora legale (settimana 26-30/10/2026): **non verificato**, dipende da un controllo sul terminale FTMO il 25/10.
9. Nessuna ricerca web: i valori esterni sono quelli gia' in repo.

**Perimetro rispettato**: nessun backtest eseguito, nessun EA, preset, sedia o forward toccato, niente VPS, nessuna riga di lancio, nessuna taglia, nessun parametro in forward, niente sul conto reale `10105439`.
Fonti primarie lette: `R199B` (CSV e referto), `Walkforward_Aperture/NASDAQ_{A..M}_*.csv`, `R107_REFERTO.md`, `REFERTO_R115_2026-08-29.md`, `spread_flotta/`, `SPREAD_VIVO`, i referti citati.
