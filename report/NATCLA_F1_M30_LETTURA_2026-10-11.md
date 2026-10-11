# NatCla F1 lotto M30 -- lettura del 11/10/2026, SECONDO LA PROVA

**Fonte**: `NATCLA_F1_M30.zip` (SHA256 `e8edeece7e218ce419fd6d7bb4106f2c01b95849d9201c7fe1884647876a0522`, caricato da Claudio), archiviato in
`backtest_pipeline/risultati_archivio/NATCLA_F1_M30_20261011/` (zip intero + MANIFEST, RIEPILOGO, prova, log, csv, trades, ini; i 4 report `.htm`,
23 MB in chiaro, restano SOLO dentro lo zip). RIEPILOGO: data 2026-10-11 17:52:44, PC DESKTOP-H4D7CAJ, pin `e2fb98ed` (quello del PASS 9fec3377),
EA v1.12 SHA256 `729BB428`, compilazione **0 errori, 0 avvisi**, 4 passate OK / 0 KO / 0 non lanciate per il driver, 11 minuti.
**Prova**: `backtest_pipeline/prove/NATCLA_F1_M30_2026-10-11.txt` SHA256 `90d67485` (la copia nello zip ha lo stesso SHA). Nessuna soglia spostata.

**Strumento**: `backtest_pipeline/leggi_natcla_f1_m30.py` -- NUOVO, scritto oggi per questa lettura, **NON passato dal cancello**. Importa in sola
lettura funzioni del lettore passato `leggi_natcla_f1.py` (728F3489, non toccato): `Sorgente`, `leggi_csv`, `leggi_report`, `pf_di`, `dd_r`,
`p_media`, `comm_r`, `nullo_riga`. Output integrale: `risultati_archivio/NATCLA_F1_M30_20261011/LETTURA_leggi_natcla_f1_m30.txt`.
**Contro-esempio fatto prima di usarlo** (`--autotest` sul pilota H1, output in `AUTOTEST_leggi_natcla_f1_m30_sul_pilota.txt`): lo stesso codice
ridà sul pilota f inclinazione 0,493 / 0,486 / 0,503 / 0,156, f ADX 0,356 / 0,362 / 0,306, guardia 64 / 64 / 55 / 70, n 144 / 134 / 110 / 92,
PF_R 1,32 / 1,13 / 0,78, nullo 0,93 / 0,96 / 0,83, DD_R 6,2 / 3,7 / 8,7, durata 70 / 95 / 20 (0 falliti, quadrature OK); e un mutante che toglie
la guardia dalla formula di f fa cadere 4 controlli su 4 (0,500 contro 0,493 ecc.).

---

## 1. L'esito, alla lettera della prova

> **Regola P_003 (prova, "IL CASO P_003"): le passate M30_002 (oro GEOM) e M30_003 (oro PIU) hanno ciascuna 4 righe `ADOTTATO` e 4 righe SETUP
> con `rischio_soldi` 0.00 -> sono "KO per il caso P_003" ALLA LETTURA (il driver le segna OK: non controlla `rischio_soldi`). 2 passate su 4:
> "il lotto e' illeggibile e la decisione P_003 (v1.13 dell'EA o tolleranza nel lettore) diventa PRIORITARIA rispetto a ogni altro lotto NatCla".**

- Leggibili: **M30_001** (controllo H1: A0 regge) e **M30_004** (EURUSD M2 M30: 0 righe ADOTTATO, 0 a rischio 0).
- **Illeggibili per regola**: M30_002 e M30_003. I loro numeri qui sotto sono **descrittivi** e **non entrano in nessuna lettura** (A1 smentita, A2,
  passo successivo): li scrivo perche' servono alla decisione P_003, non perche' la regola li ammetta.
- Il caso era **previsto** dalla prova ([IPOTESI]: "su M30 ... il caso P_003 e' atteso ALMENO altrettanto frequente"): sul pilota H1 le due passate
  oro avevano 0 righe ADOTTATO, su M30 ne hanno 4 ciascuna.
- Nessun verdetto di merito, nessuna promozione: certificato (T7) con le caselle 3 e 4 vuote per tutte le gambe.

## 2. Tabella attesa / misura / esito (ogni numero con la fonte)

Fonti: M = `MANIFEST_F1.csv` dello zip M30; P = zip del pilota archiviato `NATCLA_F1_P_20261011`; S = output di `leggi_natcla_f1_m30.py`
(colonne CSV `n_riempiti`, `rischio_soldi`, `esito_R`, `durata_min`; righe `[NATCLA-IMBUTO]` e `guardia anti-duplicato` dei `log\<passata>.txt`).

| | attesa della prova | misura | esito alla lettera |
|---|---|---|---|
| **Deviazione dichiarata** | M30: CFG InpTF con DEVIAZIONE, CFG InpAmmettiTFSottoH1 "DEVIAZIONE ATTIVA", 1 riga AVVISO; H1: etichetta FONTE, "nessun effetto", nessun AVVISO | tutte presenti nei log (S); AVVIO v1.12, magic 778601 / 778603 / 778603 / 778623, PERIOD giusto (S); driver: avvio_ok si, ADX MetaQuotes, finestre 2024.07.10 / 2024.07.05 - 2025.06.30, 100% ticks reali (M) | OK |
| **A0** controllo H1 = P_001 | righe `SETUP;` identiche; ticks 53.339.206, operazioni 232, barre 5.651; giornale uguale salvo v1.11->v1.12 e la riga CFG InpAmmettiTFSottoH1; nessuna ADOTTATO | righe SETUP 144 contro 144, **0 diverse** (S, confronto riga per riga dei due CSV); ticks 53.339.206 / 53.339.206, operazioni 232 / 232, barre 5.651 / 5.651 (M, P); giornale: 1 sola riga in piu' = `CFG InpAmmettiTFSottoH1 = true   nessun effetto ...`, 0 righe mancanti (S); ADOTTATO 0 | **A0 regge** (nessuna smentita) |
| **Regola P_003** | KO alla lettura una passata M30 con ADOTTATO + SETUP a rischio 0; 2+ su 4 = lotto illeggibile | M30_002: 4 righe rischio 0 (2024.09.15 ST25, 2024.10.13 ST30 e ST25, 2025.05.25 ST30); M30_003: le stesse 4 date/linee; M30_001 e M30_004: 0 (S) | **2 su 4 -> LOTTO ILLEGGIBILE; decisione P_003 PRIORITARIA** |
| **A1** n M30 / n H1 (bande x1,2-x2,6) | oro GEOM 173-374; oro PIU 161-348; EURUSD M2 110-239 | oro GEOM **236** (x1,64) [illeggibile]; oro PIU **201** (x1,50) [illeggibile]; EURUSD M2 **199** (x2,16) (S, = `setup_righe` M) | EURUSD M2: dentro la banda. Oro: non letto (passate illeggibili) |
| A1 rapporto riempiti/setup | 1,60-1,77; fuori da 1,2-2,2 = DA GUARDARE | 1,611 (controllo) / 1,576 / 1,602 / 1,739 (M `riempiti_somma`/`setup_righe`) | nessuno fuori da 1,2-2,2 |
| A1 Poisson (informativo) | accanto a n | 95%: 206-266 (GEOM), 173-229 (PIU), 171-227 (EURUSD M2) (S, n +/- 1,96 radice(n)) | informativo |
| A1 smentita (4 condizioni) | n GEOM < 173 E n PIU < 161 E f <= 0,56 in entrambe | non valutabile: le due gambe oro sono illeggibili per la regola P_003 | **non si emette**; verdetto sulla leva **NON ANCORA MISURATO** |
| **A2** f inclinazione (def. emendata) | <= 0,56 P50-like; >= 0,59 piu' severa; ipotesi 0,65 / 0,49-0,50 | oro GEOM **0,526** (vecchia def. 0,532), oro PIU **0,502** (0,507) [illeggibili]; EURUSD M2 **0,161** contro H1 0,156 (rapporto 1,03) (S) | EURUSD M2: confronto senza soglia, 1,03. Oro: non letto |
| A2 f ADX | confronto con 0,356 / 0,362, senza soglia | 0,343 / 0,361 [illeggibili] (S) | non letto |
| A2 controllo incrociato | scarto > 25% = DA GUARDARE (con limite INFERITO) | oro GEOM -12,3%, oro PIU -22,5% [illeggibili]; EURUSD M2 +8,8% (S) | EURUSD M2: entro il 25% |
| A2 guardia contata a mano | contarla a parte e toglierla da `occupata` | guardia 64 / 91 / 83 / 75; occupata prima dei filtri 398 / 1.500 / 3.800 / 440 (S); quadratura dell'imbuto OK in tutte (S; `imbuto_rotte` 0 in M) | fatto |
| Passo successivo | passo 0 su M30 se f > 0,56 in almeno una gamba oro | condizione non valutabile (gambe oro illeggibili) | **non scatta per regola; la priorita' e' la decisione P_003** |
| **A3** durata mediana (minuti) | x0,5-x2,0 di 70 / 95 / 20 | 87,2 (x1,25) / 119,6 (x1,26) [illeggibili] / 25,3 (x1,27) (S, `durata_min`); controllo 70,0 | EURUSD M2: dentro; E1 della madre: FEDELE (<= 60) |
| **A4** lato e regime | solo LONG oro, nessuna domanda sul segno | -- | non chiesto |
| **A5** PF_R descrittivo | nullo madre oro 0,93-0,98, forex 0,77-0,94; entro +0,10 dal PF_R H1 = non distingue | EURUSD M2 PF_R **0,80** (H1 0,78; nullo sulla geometria vera 0,77); oro GEOM 0,97 (H1 1,32; nullo 0,93), oro PIU 1,10 (H1 1,13; nullo 0,95) [illeggibili] (S; commissione addebitata dal tester in tutte le passate, quindi PF_R = lordo) | EURUSD M2: dentro il nullo forex -> **non distingue niente** |
| T6 rischio (descrittivo) | r_max = 10%/DD_R e 4%/peggior giornata | EURUSD M2: DD_R **17,0**, peggior giornata -2,08 R -> r_max 0,59% / 1,92% (S) | descrittivo (segnaposto 0,25%) |
| **A6** tempo | per passata x1,0-x2,0 di H1; lotto 9-19 min; smentita oltre x3 | 161 / 138 / 178 / 88 s contro 133 / 133 / 168 / 83 (x1,21 / x1,04 / x1,06 / x1,06) (M, P); lotto 11 minuti (RIEPILOGO) | dentro; il costo e' quasi tutto per tick |
| **A7** colla | operazioni = riempiti (fino a +3); soldi = profitto entro 2 rischi | operazioni - riempiti = 0 / 0 / 0 / 0; profitto - soldi = 0,00 in tutte (S, M) | OK |
| A7 INVIO FALLITO 10018 | attesi ALMENO quanti su H1 (29 / 29 / 5) | 29 / 22 / 14 / 10, tutti retcode 10018, ore 22-23-00 (S; = `invio_fallito` M); nessun 10019 | oro M30: **MENO** che su H1 (22 e 14 contro 29): attesa **non confermata**; EURUSD M2 10 contro 5: confermata |
| A7 uscite silenziose | 10019, stop out, lotto sotto il minimo = KO | 0 / 0 / 0 (M `lotto_min`, nessuna riga soldi nel giornale) | OK |

`semaforo` del MANIFEST = numero di righe `AVVISO SEMAFORO SFORATO` del giornale (driver `NATCLA_F1_M30_PASSATE.ps1` r.729): vale 1 in M30_002 e
M30_003 ed e' la riga del 2024.10.13 23:10, quando **due** setup adottati (ST25 e ST30) erano aperti insieme contro un massimo di 1.
`imbuto_rotte` = righe `[NATCLA-IMBUTO]` con "quadratura ROTTA" (driver r.730): 0 ovunque (e la quadratura ricontata da S torna in tutte e quattro).

## 3. Sorprese e incoerenze (da guardare, nessuna cambia l'esito)

1. **Il caso P_003 su M30 ha una firma precisa** [FATTO dal giornale M30_002/003]: la **domenica alle 23:00** (prima barra M30 alla riapertura)
   compaiono righe `guardia anti-duplicato (0 posizioni, 3 pendenti ancora sul conto)` su ST25 e/o ST30; alle **23:10** un pendente si riempie e
   viene ADOTTATO (2024.09.15, 2024.10.13, 2025.05.25: tutte domeniche). Il 2024.10.11 (venerdi) alle 20:00 erano state armate due scale insieme
   (ST25 e ST30: il semaforo conta solo i setup riempiti, quindi due scale a pendenti possono convivere). Che la cancellazione alla barra delle 23:00
   non riesca per il mercato ancora chiuso e' [IPOTESI] (l'EA non scrive le cancellazioni fallite, prova). Su H1 la stessa firma c'era una volta
   (P_003, venerdi 22:00 / domenica 23:05).
2. **Doppia esposizione** il 2024.10.13: due setup adottati aperti insieme (SEMAFORO SFORATO), con i lotti della scala originale: esito +1.424,69 e
   +1.579,41 EUR registrati a 0,00 R. E' rischio vero che il CSV non misura (rischio 0): va nella decisione P_003.
3. Le **stesse 4 adozioni** in GEOM e PIU (stesse date e linee): il modo di stop non c'entra, il meccanismo sta nei pendenti.
4. **10018 meno numerosi su M30** sull'oro (22 / 14 contro 29): l'attesa della prova ("almeno quanti") non e' confermata; l'ipotesi alla base
   (piu' aperture di barra = piu' riprezzamenti a mercato chiuso) resta tale. Sono INVII di ordini nuovi, non cancellazioni.
5. Il PF(deal) del report (1,31 / 0,98 / 1,13 / 0,81) e il PF_R per setup (1,32 / 0,97 / 1,10 / 0,80) differiscono di poco: unita' diverse (deal
   contro setup), come nel pilota.
6. **Informativo per la decisione P_003, NON una lettura**: le righe adottate hanno R = 0, quindi NON spostano PF_R, media o DD in R; spostano n
   (236 -> 232, 201 -> 197 senza di loro) e la mediana di durata. Con una tolleranza nel lettore i numeri oro resterebbero quasi identici a quelli
   descritti qui; con una v1.13 dell'EA le adozioni sparirebbero e la passata andrebbe RIFATTA (i riempimenti adottati diventerebbero setup veri o
   non esisterebbero).

## 4. Cosa NON dice questo lotto
- **Non dice se M30 porta il campione sull'oro**: le due gambe oro sono illeggibili per regola. I loro n (236, 201) sono sopra 150 e dentro le bande,
  ma la regola li esclude e la prova non emette ne' smentita ne' conferma.
- Non dice niente sul **merito**: nessuna gamba puo' essere VIVA (oro 1 simbolo, FX7 1 su 7); EURUSD M2 PF_R 0,80 sta dentro il nullo forex.
- Non dice se la **soglia d'inclinazione trasportata** e' il P50 su M30 per l'oro (A2 non letto); per l'EURUSD M2 f e' 0,161 contro 0,156 (per barra).
- Non e' un OOS, ne' una prova di regime (un regime, un broker, ExecutionMode 0).

## 5. Errori e limiti
- Strumento di lettura **non passato dal cancello** (autotest sul pilota e mutante fatti da me: il cancello deve rifarli).
- PF_R, nullo, DD, p con le funzioni del lettore passato; il raggruppamento per gamba e' mio (un simbolo per gamba qui).
- Il "nullo madre" di A5 e' l'intervallo scritto nella prova; il nullo "sulla geometria vera" (S) e' quello del lettore passato, DIAGNOSTICA; nelle
  passate oro salta 4 righe (le adottate, senza geometria).
- Poisson: approssimazione normale, sovradispersione e correlazione fra gambe NON misurate.
- I report `.htm` non sono estratti nell'archivio (23 MB): stanno nello zip archiviato.

## 6. La domanda aperta (quella che la prova rende prioritaria)
**Decisione P_003**: (a) **v1.13 dell'EA** (le adozioni non devono nascere: ad esempio non riprezzare/ricancellare alla prima barra dopo la
riapertura, o rimuovere i pendenti prima della chiusura del venerdi -- da progettare e passare dal cancello) e poi **rifare le due passate oro M30**;
oppure (b) **tolleranza nel lettore** (le righe adottate escluse da n e contate a parte, con la doppia esposizione dichiarata). E' una decisione
tecnica (prova: "decisione SEPARATA"), da prendere PRIMA di ogni altro lotto NatCla. Il passo 0 su M30 (conteggio F0) **non** e' richiesto dalla
regola in questo stato: la sua condizione (f > 0,56) e' su gambe illeggibili.

## 7. Cosa il cancello deve ricontrollare
1. `leggi_natcla_f1_m30.py` (nuovo): autotest sul pilota, mutante della guardia, formula di f e di f ADX contro la prova (A2 emendata).
2. La regola P_003 applicata alle passate M30_002/003 (4 righe `rischio_soldi` 0.00 ciascuna nei `csv\`, righe ADOTTATO nei `log\`).
3. A0: il confronto riga per riga dei due CSV e il confronto dei giornali (1 sola riga in piu').
4. La lettura di `semaforo` / `imbuto_rotte` del MANIFEST contro il driver `NATCLA_F1_M30_PASSATE.ps1`.
5. Che nessun numero delle passate oro sia usato come lettura (sono illeggibili per regola).
