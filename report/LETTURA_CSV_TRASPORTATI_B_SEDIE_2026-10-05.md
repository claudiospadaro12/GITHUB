# LETTURA DEI CSV TRASPORTATI - BLOCCO B (SEDIE) - 05/10/2026

> **BOZZA, NON passata dal cancello.** DOCUMENTO INTERNO, non esce. Sola lettura d'archivio: nessun round lanciato, nessun VPS toccato,
> nessun EA / preset / parametro / taglia / conto toccato, niente mandato a nessuno.
> **Perimetro**: le 13 cartelle di `backtest_pipeline/risultati_prove/dal_vps/` assegnate al blocco B (aperture DAX / Dow / Nasdaq, Live5m,
> EMA200, ORB_Ottimizzato, SuperWave e SuperWave_DOW_H1, MaxMinNotte e MaxMinNotte_DAX_Short, SupRev DOW H1 e NAS H1, Nightly).
> **Regola di lettura**: `report/RESOCONTO_EA_PIANO_2026-10-05.md` §5, applicata alla lettera (PF OOS a tick; SOPRA / SOTTO / NON MISURATO;
> affidabilita' A-D; deal e posizioni; classe 1127 = si leggono le righe SOPRA **e** SOTTO). **Nessun criterio nuovo, nessuna soglia abbassata.**
> **Metodo**: ogni numero e' ricalcolato da me dai CSV con codice mio; i resoconti G1 / G2 / G3 / G5 e i referti sono confrontati dopo, riga per riga.
> Dove un dato non c'e' nel CSV c'e' scritto NON LEGGIBILE; dove il resoconto non lo copre, [NON COPERTO]. Quando un numero spinge verso una
> decisione di rischio o di taglia, e' scritta come **decisione di Claudio** e non e' proposta qui.
> Etichette di dato: `[T]` tick reali BCM (Modello 4) · `[B]` barre OHLC M1 (Modello 1, screening: non promuove e non boccia) ·
> `[DERIVATO]` calcolo mio su numeri scritti · `[INFERITO]` deduzione non provata.

---

## 0. IN BREVE

**Cosa e' stato letto.** 67 round, 134 CSV (13 cartelle), 630 righe MT5 (una riga = una passata): 23 sono righe doppie che differiscono solo per
`InpMagic` (asse tecnico), quindi **607 celle-finestra**, 310 celle, **297 con entrambe le finestre** IS e OOS. 3 CSV sono vuoti (0 byte) **per costruzione**,
non per guasto: `r154a` OOS e `r155a` OOS (`@FRAZIONEIS 1.0` = una sola tranche, la gamba OOS e' degenere) e `cemad02` IS (`@FRAZIONEIS 0.002` = IS di un giorno).
Stato git dei 134: **68 nuovi** (entrati il 05/10), **28 aggiornati** (esistevano dal 13/09: 26 hanno gli stessi numeri; **2 no**, i due CSV OHLC di `r139b`), **38 invariati**.

**Le tre cose piu' importanti.**
1. **770250 (Nasdaq, gated short M15): lo "OOS 1,097 su 104" di G1 e' la finestra piena, non un OOS.** `r170a` (stessa cella: prova "sedia gated short", M15, solo short, 0,65%)
   divide 40/60 e da': IS **1,257** su 57 deal -> OOS **0,948** su 47 deal (DD 4,54 / 3,63%). 57+47 = 104 deal; il PF combinato ricostruito da Profit e PF e' **1,0996**
   contro l'1,097 del `REFERTO_SHORTGATE` (DD 4,54 identico all'IS). Cioe': **SEGNO INVERTITO**, non "zona grigia". La riga 14d di G1 va rivista (proposta, sez. 6 V1).
2. **SuperWave 770511 (U30USD H1) - il contratto "conteso" si restringe, e 5 dei 7 file "mai lanciati" hanno ora i numeri.** Nessuno dei 13 round riproduce la lettura 1,849 / 1,328;
   i CSV riproducono le altre due (10k: **1,482 / 1,243**, 72/131 deal, DD 4,04/4,17; 100k: **1,397 / 1,220**, 106/184 deal, DD 3,48/4,21), ciascuna piu' volte al centesimo.
   Uscite messe ad asse: parziale 0 e 25 battono la sedia in IS **e** OOS (1,674/1,455 e 1,653/1,318); TP1_R 0,5 pure (1,569/1,928); breakeven spento perde l'IS (0,879).
   In piu' la cella `r120b01` (trailing OFF, flip ON: IS 1,406 -> OOS **0,983**) e' una cella SOTTO che G2 non elenca. Qualunque cambio della sedia e' **decisione di Claudio**.
3. **Round che i resoconti davano "mai girati / NM" e che ora hanno i numeri**: Dow 770202 `r172a-j` (69 celle, 10 assi d'uscita; l'ancora riproduce il contratto al centesimo in 9 round su 10),
   ORB_Ott `r125a-f` (64 righe; G2 ne attendeva 66, scarto non verificato), SupRev NAS `r163a` (7 celle su 7 sopra 1 in IS e OOS), EMA200 `r146b`/`r147a`, Live5m `r150a`, MaxMinNotte `r133c`/`r151a`/`r170b`/`r170c`, SuperWave `r154a`.
   **Attenzione sulla provenienza**: per 54 dei 134 CSV la tabella Pass / Profit / PF / DD / Trades era **gia' stampata** nei log `coda/referti/CODA_07_desktop_*.log` committati il giorno stesso
   (10-20/09): l'ho confrontata riga per riga con i CSV, **0 differenze**. I numeri di `r172a-e,i,j`, `r173a-c`, `r147b`, `r150a`, `r151a`, `r125f`, `r146b`/`r147a` risultano quindi leggibili nei log dal giorno della corsa;
   per gli altri 80 (3 sono vuoti) la tabella non e' in nessun log (confronto referto/CSV: NON POSSIBILE).

**Dubbi principali** (sez. 8): la colonna `Trades` conta **deal**, non posizioni (le posizioni NON sono leggibili dai CSV); finestra, deposito, rischio e modello **non stanno nel CSV** (li ho presi dai file prova e da `CODA.txt`);
alcune "ancore" di round non sono la sedia (OPPRANGE di `r125a/c/e/f`, MinStopPts pinnato di `r172j`); un solo regime per tutti i round indici (21 mesi).

---

## 1. COME HO LETTO (e che cosa un CSV NON dice)

### 1.1 Cosa contiene un CSV, e cosa no
Colonne (da 50 a 93 a seconda dell'EA): `Pass`, `Profit`, `Expected Payoff`, `Profit Factor`, `Recovery Factor`, `Sharpe Ratio`, `Equity DD %`, `Trades`, in alcuni EA
`Peggior Giornata %`, `Perdite Consecutive Max`, `Serie Perdente Peggiore`, poi **tutti gli input** `Inp*` della passata. **Non c'e'**: la finestra, il deposito, il rischio dichiarato, il modello di tick,
il per-trade, il numero di **posizioni**. Il **lato** si legge dagli input `InpAllowLong` / `InpAllowShort` (letti in tutti i 67 round): solo long DAX_Apertura, Dow_Apertura e ORB_Ott (tranne `r125d`, solo short); solo short `r133c`, `r170a`, `r170c`; due lati tutti gli altri.

### 1.2 Da dove vengono finestra, deposito, rischio, modello
- **Finestra**: dal file prova del round (`backtest_pipeline/prove/<prova>.txt`: `@DAQUANDO`, `@FINOA` (default driver 2026.06.30), `@FRAZIONEIS`), con la formula del driver
  `walkforward_generico.ps1` r.934-937: `Meta = Inizio + floor(giorni x FrazioneIS)`, IS = Inizio..Meta, OOS = Meta+1..Fine. Standard indici: IS 2024.09.26-2025.06.09 (256 giorni), OOS 2025.06.10-2026.06.30.
  Il nome del file prova e' preso dalla riga di coda in `backtest_pipeline/coda/CODA.txt` (`-Prova ... -Etichetta ... -Modello ... -Deposito ...`); per `R123*` e `P0_EURCHF` (nessuna riga di coda) dal nome file e dal commento della prova.
- **Rischio**: `InpRiskPercent` scritto nella prova (1,0 salvo: 0,65 per `r152a`, `r147b`, `r170a`; 2 per Live5m; 0,5 per l'oro MaxMinNotte).
- **Modello**: `-Modello 4` = tick reali `[T]`; `-Modello 1` = barre OHLC `[B]` (`r139a/b`, `r151a`, `r170b`).
- **Verifica del deposito dal CSV** (indipendente dalla coda): `(Profit / Recovery Factor) / (Equity DD % / 100)` = base su cui e' calcolato il DD. Sui 66 round con deposito dichiarato la mediana cade vicino al deposito scritto
  (10k: 10.077-11.456; 100k: 100.905-116.301): nessun round e' stato girato a un deposito diverso da quello scritto in coda. Per `P0_EURCHF` (nessun deposito scritto) la stessa stima da' ~10.391: **10k [DERIVATO]**.

### 1.3 Unita' e classi (letterale dal piano)
- `Trades` = **deal di uscita**. Con un parziale al 50% una posizione fa 1 o 2 deal: fattore deal/posizioni **1,00-2,31** (piano §5.4, `CONTRATTI_DELLE_SEDIE_FTMO` §1). Qui **n e' sempre in deal**.
  Regola per la lettera di affidabilita' dai soli deal: **B** richiede >= **346** deal OOS (150 x 2,31: cosi' le posizioni sono garantite >= 150); 150-345 deal = B o C **provvisoria**; 70-149 = C;
  30-69 = C o D; < 30 = D. Dove il parziale e' spento (`InpTP1Pct` / `InpTP1_ClosePct` = 0) deal = posizioni.
- **SOPRA** se PF OOS >= 1,00, **SOTTO** se < 1,00, sul PF a tick `[T]` della cella; `[B]` = screening. **SEGNO INVERTITO** se IS e OOS stanno da parti opposte di 1.
  Nessun "morto": il certificato a 5 caselle (§5.6 del piano) e' compilato solo dove i CSV chiudono una casella (sez. 5 d).
- **Rischio**: riporto il DD del tester al rischio del banco. Il muro del 10% e' citato solo come lo citano i resoconti. Su `[B]` l'OHLC da' un limite **inferiore** del DD: puo' dire VIOLATO, mai NON VIOLATO.
- **Non applico** le soglie congelate (B0..B9, S1..S6) scritte dentro ogni file prova: sono criteri di chi ha scritto il round, e applicarle e' un lavoro a parte (sez. 7).

### 1.4 Cella, ancora, duplicati
Una **cella** e' un valore dell'asse del round (una riga IS e la riga OOS con gli stessi input variati). L'**ancora** e' il valore di default dell'asse nel file prova; **non sempre e' la sedia**: la colonna "cella di riferimento"
della tabella dice quando non lo e'. Le righe che differiscono solo per `InpMagic` sono duplicati (le conto una volta). Il valore di `InpMagic` non e' mai un parametro di mercato.
I totali per EA contano **righe-cella**: la stessa cella ancora ricompare in molti round (riproduzioni), quindi non sono configurazioni distinte.

### 1.5 Controlli che ho fatto sulla mia lettura (contro-esempi, prima di scrivere)
1. **Riproduzione dell'ancora contro il contratto**: dove un contratto esiste (`CONTRATTI_DELLE_SEDIE_FTMO` §2-§5, `CENSIMENTO_CONTRATTI_v2`), la cella ancora deve ridare **PF, n, DD** del contratto. Risultato (sez. 5 c): 770101, 770202, 771531, 770611, 770411 riprodotti
   **al centesimo** in 4, 9, 7, 3 e 1 round; 770511 riprodotto per due letture su tre.
2. **CSV contro tabella stampata nei log del runner**: 54 CSV confrontati (Pass, Profit, PF, DD, Trades): **54 su 54 uguali**. Gli altri 80 (77 non stampati, 3 vuoti) non sono confrontabili.
3. **Somma IS + OOS = finestra piena**: `r170a` 57+47 = 104 (= n del `REFERTO_SHORTGATE`); `r151a`/`r170b` 265+428 = 693 (= n di G3 riga 1a); `r154a` 120 = 32+88 (= IS+OOS di G2 per 770531).
4. **Determinismo fra round diversi**: la stessa cella in round diversi da' lo stesso numero (es. `r125c` buffer 2000 = `r125e` MinRangePct 0,00/0,05: 3186,22 e -80,03; `r126a` buffer 0 = `r126b` lookback 5 = `r120b11`). 26 su 28 CSV rimessi dal runner il 05/10 sono numericamente identici alla versione del 13/09.
5. **Deposito**: stima dal CSV contro la coda, vedi 1.2.
6. **Un contro-esempio che ha *fermato* una scorciatoia**: dal confronto "TP1Pct 0 contro 50" sulla SuperWave 770511 (72/116 deal contro 106/184) **non** deduco le posizioni della sedia: sull'EMA200 la gemella senza parziale ha 165 posizioni contro 257
   (`RESOCONTO_G2` §1.1 punto 13: "toglierlo cambia gli ingressi"). Sul DAX invece l'identita' deal(ClosePct 0) = posizioni(sedia) e' **verificata dal per-trade** (193 = 193, `R137a` intestazione), non da me.

---

## 2. INVENTARIO

| cosa | numero |
|---|---:|
| round letti (etichette) | 67 |
| CSV letti | 134 (131 con dati, 3 vuoti) |
| cartelle | 13 |
| righe MT5 (passate) | 630 |
| righe doppie solo per `InpMagic` | 23 |
| celle (coppie o gambe singole) | 310 |
| celle con IS e OOS | 297 (OOS sopra 1: 226 · OOS sotto 1: 71 · IS sopra 1: 225 · IS e OOS da parti opposte di 1: 91) |
| celle a gamba unica (`r154a` 7, `r155a` 5, `cemad02` 1) | 13 |
| CSV vuoti per costruzione | 3 |
| git: nuovi / aggiornati / invariati | 68 / 28 / 38 |

Legenda colonna `git`: **N** = CSV entrato il 05/10; **A** = esisteva dal 13/09 e riscritto il 05/10; **P** = presente e invariato dal 13/09 (IS/OOS).

**Esecuzioni notturne dietro questi CSV** (dai `REFERTO_RUNNER_*`, 62 dei 67 round compaiono): **401 esecuzioni** per 62 round (da 4 a 9 notti ciascuno), ~67,5 ore di tester contro ~8,5 ore di **una** esecuzione per round
(somma delle ultime esecuzioni). Il CSV nel repo e' quello dell'ultima. Codici di uscita: 0 = ROUND GIRATO; 2 = NON MISURATO per CSV mancante/vuoto (`cemad02`, `r154a`, `r155a`: attesi); 3 = ROUND GIRATO CON RILIEVI
(`r139a/b`, `r151a`, `r170b`: "round girato a Modello 1, screening, non verdetto"); 1 il 17/09 al primo tentativo di `r172f/g/h/i/j` e `r173c` (5-7 secondi), poi 0 dal 18/09. `canfrz` (DAX) compare fra i 47 round di `IL_TRASPORTO_E_FERMO` ma e' una corsa
`-SoloControllo` (10 s): **per costruzione non ha CSV**.

---

## 3. TABELLA PER ROUND (67 round, in ordine di famiglia)

Lettura: **n e' in deal**; DD = `Equity DD %` del tester al rischio del banco; "cella di riferimento" = valore di default dell'asse nel file prova (dice quando NON e' la sedia, colonna "riferimento" nella seconda tabella);
"IS sopra, OOS sotto" e "IS sotto, OOS sopra" contano le celle accoppiate dove IS e OOS stanno da parti opposte di 1 (SEGNO INVERTITO nei due versi). Banco: `T`/`B` = tick/barre, deposito, rischio (`10k*` = deposito
derivato dal CSV, non scritto in coda). La seconda tabella confronta con quanto dichiarava il resoconto di gruppo (G1 = aperture, G2 = EMA200 / SuperWave / ORB, G3 = notte, G5 = SupRev).

### 3.1 Numeri
| # | round | EA | simb. TF | banco | finestra | asse (celle) | cella di riferimento IS -> OOS (PF/n deal/DD%) | OOS sopra / sotto 1 | IS sopra, OOS sotto | IS sotto, OOS sopra | git |
|---:|---|---|---|---|---|---|---|---|---:|---:|---|
| 1 | `q770be` | DAX_Apertura_EU | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | BEatR: 0,0; 0,5; 1,0; 1,5 | 1,183/132/4,96 -> 1,491/193/6,27 | 4 / 0 | 0 | 0 | A/A |
| 2 | `r137a` | DAX_Apertura_EU | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | MinStopPts: 800; 2800; 4800; 6800; 8800; 10800; 12800 | 1,126/175/5,44 -> 1,397/270/7,23 | 7 / 0 | 0 | 2 | P/P |
| 3 | `r137b` | DAX_Apertura_EU | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | MinStopPts: 800; 2800; 4800; 6800; 8800; 10800; 12800 | 1,126/175/5,44 -> 1,397/270/7,23 | 5 / 2 | 0 | 2 | P/P |
| 4 | `r137c` | DAX_Apertura_EU | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1_ClosePct: 0; 50 | 1,126/175/5,44 -> 1,397/270/7,23 | 2 / 0 | 0 | 0 | A/P |
| 5 | `r138a` | DAX_Apertura_EU | F40EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 1,440/130/7,36 -> 0,770/195/11,82 | 0 / 1 | 1 | 0 | A/P |
| 6 | `r147c` | DAX_Apertura_EU | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | CloseAtEnd: 0; 1 | 1,126/175/5,44 -> 1,397/270/7,23 | 2 / 0 | 0 | 0 | N/N |
| 7 | `r152a` | Dow_Apertura_US | U30USD M5 | T 100k 0,65% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 1,227/74/3,71 -> 1,278/130/2,85 | 1 / 0 | 0 | 0 | N/N |
| 8 | `r172a` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TrailStartR: 0,00; 0,25; 0,50; 0,75; 1,00; 1,25; 1,50 | 1,222/74/5,67 -> 1,270/130/4,39 | 7 / 0 | 0 | 0 | N/N |
| 9 | `r172b` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | CloseHour: 15; 16; 17; 18; 19; 20; 21 | 1,223/74/5,67 -> 1,270/130/4,39 | 6 / 1 | 0 | 3 | N/N |
| 10 | `r172c` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | BreakevenAtTP1: 0; 1 | 1,222/74/5,67 -> 1,270/130/4,39 | 2 / 0 | 0 | 0 | N/N |
| 11 | `r172d` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | BEatR: 0,00; 0,15; 0,30; 0,45; 0,60; 0,75; 0,90 | 1,222/74/5,67 -> 1,270/130/4,39 | 5 / 2 | 2 | 1 | N/N |
| 12 | `r172e` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1_R: 0,50; 0,75; 1,00; 1,25; 1,50; 1,75; 2,00 | 1,222/74/5,67 -> 1,270/130/4,39 | 7 / 0 | 0 | 0 | N/N |
| 13 | `r172f` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TrailTF: 1..30 (11) | 1,222/74/5,67 -> 1,270/130/4,39 | 10 / 1 | 0 | 3 | N/N |
| 14 | `r172g` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | CloseAtEnd: 0; 1 | 1,222/74/5,67 -> 1,270/130/4,39 | 2 / 0 | 0 | 1 | N/N |
| 15 | `r172h` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLMode: 0; 1 | 1,222/74/5,67 -> 1,270/130/4,39 | 2 / 0 | 0 | 1 | N/N |
| 16 | `r172i` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | MinStopPts: 0..10500 (22) | 1,222/74/5,67 -> 1,270/130/4,39 | 17 / 5 | 5 | 0 | N/N |
| 17 | `r172j` | Dow_Apertura_US | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SkipIfTight: 0; 1 | 1,159/74/4,51 -> 1,010/128/5,04 | 1 / 1 | 1 | 0 | N/N |
| 18 | `r170a` | Nasdaq_Apertura_US | NASUSD M15 | T 100k 0,65% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | CloseAtEnd: 0; 1 | 1,257/57/4,54 -> 0,948/47/3,63 | 0 / 2 | 2 | 0 | N/N |
| 19 | `r142a` | Nasdaq_Live5m | NASUSD M5 | T 10k 2% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1_ClosePct: 0; 25; 50; 75 | 1,015/116/12,28 -> 0,956/175/22,47 | 0 / 4 | 3 | 0 | A/P |
| 20 | `r142b` | Nasdaq_Live5m | NASUSD M5 | T 10k 2% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TrailTF: 1; 2; 3; 4; 5 | 1,015/116/12,28 -> 0,956/175/22,47 | 4 / 1 | 1 | 0 | P/P |
| 21 | `r142c` | Nasdaq_Live5m | NASUSD M5 | T 10k 2% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | UseTrailing: 0; 1 | 1,015/116/12,28 -> 0,956/175/22,47 | 0 / 2 | 2 | 0 | P/A |
| 22 | `r150a` | Nasdaq_Live5m | NASUSD M5 | T 10k 2% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TrailStartR: 0,0; 0,5; 1,0; 1,5; 2,0; 2,5; 3,0 | 1,015/116/12,28 -> 0,956/175/22,47 | 2 / 5 | 5 | 0 | N/N |
| 23 | `cemad02` | EMA200 | U30USD H1 | T 100k 1,0% | 2024.09.27-2025.06.09 (il file '_OOS_' contiene la finestra IS; IS di 1 giorno, vuoto) | solo InpMagic (cella unica) | n/d -> 1,201/237/5,73 | n/d | - | - | P/A |
| 24 | `cemad05` | EMA200 | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TF: M15; M20; M30; H1; H2; H3; H4 | 1,201/237/5,73 -> 1,524/517/7,83 | 3 / 4 | 3 | 0 | A/A |
| 25 | `r136a` | EMA200 | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLatr: 0,4; 0,6; 0,8; 1,0; 1,2; 1,4; 1,6 | 1,201/237/5,73 -> 1,524/517/7,83 | 7 / 0 | 0 | 0 | A/P |
| 26 | `r136b` | EMA200 | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1_ATRmult: 0,00; 0,25; 0,50; 0,75; 1,00; 1,25; 1,50 | 1,201/237/5,73 -> 1,524/517/7,83 | 7 / 0 | 0 | 5 | A/A |
| 27 | `r136c` | EMA200 | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1Pct: 0; 25; 50; 75 | 1,201/237/5,73 -> 1,524/517/7,83 | 4 / 0 | 0 | 1 | P/P |
| 28 | `r136d` | EMA200 | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | UseTrailing: 0; 1 | 1,201/237/5,73 -> 1,524/517/7,83 | 2 / 0 | 0 | 0 | P/P |
| 29 | `r146b` | EMA200 | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | FridayClose: 0; 1 | 1,201/237/5,73 -> 1,524/517/7,83 | 2 / 0 | 0 | 0 | N/N |
| 30 | `r147a` | EMA200 | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | Breakeven: 0; 1 | 1,201/237/5,73 -> 1,524/517/7,83 | 2 / 0 | 0 | 0 | N/N |
| 31 | `r139a` | EMA200 | AUDJPY H4 | B 10k 1,0% | IS 2010.01.01-2016.08.06 / OOS 2016.08.07-2026.06.30 | TP_RR: 1,5; 2,0; 2,5; 3,0 | 0,780/757/16,94 -> 1,008/1322/16,89 | 1 / 3 | 0 | 1 | A/A |
| 32 | `r139b` | EMA200 | GBPUSD H4 | B 10k 1,0% | IS 2010.01.01-2016.08.06 / OOS 2016.08.07-2026.06.30 | TP_RR: 1,5; 2,0; 2,5; 3,0 | 0,802/856/20,41 -> 1,122/1292/10,65 | 4 / 0 | 0 | 4 | A/A |
| 33 | `r120b00` | SuperWave_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 0,903/46/6,04 -> 1,187/90/6,23 | 1 / 0 | 0 | 1 | P/A |
| 34 | `r120b01` | SuperWave_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 1,406/71/4,45 -> 0,983/125/5,11 | 0 / 1 | 1 | 0 | A/P |
| 35 | `r120b10` | SuperWave_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 1,489/72/3,80 -> 1,243/131/4,17 | 1 / 0 | 0 | 0 | P/P |
| 36 | `r120b11` | SuperWave_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 1,482/72/4,04 -> 1,243/131/4,17 | 1 / 0 | 0 | 0 | P/A |
| 37 | `r120e00` | SuperWave_DOW_H1_Ott | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 0,978/74/5,07 -> 1,284/130/6,53 | 1 / 0 | 0 | 1 | P/A |
| 38 | `r120e11` | SuperWave_DOW_H1_Ott | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 1,397/106/3,48 -> 1,220/184/4,21 | 1 / 0 | 0 | 0 | P/A |
| 39 | `r126a` | SuperWave_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferAtr: 0,000..1,000 (9) | 1,482/72/4,04 -> 1,243/131/4,17 | 9 / 0 | 0 | 0 | A/A |
| 40 | `r126b` | SuperWave_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLLookback: 1; 3; 5; 7; 9; 11; 13 | 1,482/72/4,04 -> 1,243/131/4,17 | 7 / 0 | 0 | 0 | P/P |
| 41 | `r155a` | SuperWave_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | unica 2024.09.26-2026.06.30 (nessun OOS) | TP_RR: 2,0; 2,5; 3,0; 3,5; 4,0 | 1,331/204/4,64 -> n/d | n/d | - | - | N/N |
| 42 | `r165a` | SuperWave_DOW_H1_Ott | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferPips: 3; 1003; 2003; 3003; 4003; 5003 | 1,397/106/3,48 -> 1,220/184/4,21 | 6 / 0 | 0 | 0 | N/N |
| 43 | `r173a` | SuperWave_DOW_H1_Ott | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1Pct: 0; 25; 50; 75 | 1,397/106/3,48 -> 1,220/184/4,21 | 4 / 0 | 0 | 0 | N/N |
| 44 | `r173b` | SuperWave_DOW_H1_Ott | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1_R: 0,5; 1,0; 1,5; 2,0 | 1,397/106/3,48 -> 1,220/184/4,21 | 4 / 0 | 0 | 0 | N/N |
| 45 | `r173c` | SuperWave_DOW_H1_Ott | U30USD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | Breakeven: 0; 1 | 1,397/106/3,48 -> 1,220/184/4,21 | 2 / 0 | 0 | 1 | N/N |
| 46 | `r126d` | SuperWave | NASUSD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferAtr: 0,000..1,000 (9) | 1,126/38/1,72 -> 0,778/63/3,09 | 0 / 9 | 1 | 0 | P/A |
| 47 | `r154a` | SuperWave | U30USD H4 | T 100k 1,0% | unica 2024.09.26-2026.06.30 (nessun OOS) | SLLookback: 1; 3; 5; 7; 9; 11; 13 | 2,407/120/4,24 -> n/d | n/d | - | - | N/N |
| 48 | `r125a` | ORB_Ott | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferPts: 0; 500; 1000; 1500; 2000; 2500; 3000 | 1,061/71/4,43 -> 1,762/119/4,20 | 7 / 0 | 0 | 3 | N/N |
| 49 | `r125b` | ORB_Ott | U30USD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | TP1Pct: 0; 25; 50; 75 | 1,250/71/7,89 -> 1,674/119/9,76 | 4 / 0 | 0 | 0 | N/N |
| 50 | `r125c` | ORB_Ott | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferPts: 0; 500; 1000; 1500; 2000; 2500; 3000 | 1,130/84/5,93 -> 0,997/128/9,80 | 5 / 2 | 2 | 0 | N/N |
| 51 | `r125d` | ORB_Ott | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 0,858/56/6,08 -> 0,650/97/8,88 | 0 / 1 | 0 | 0 | N/N |
| 52 | `r125e` | ORB_Ott | D30EUR M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | MinRangePct: 0,00; 0,05; 0,10; 0,15; 0,20 | 1,256/84/4,01 -> 0,997/128/7,49 | 2 / 3 | 3 | 0 | N/N |
| 53 | `r125f` | ORB_Ott | NASUSD M5 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferPts: 0; 500; 1000; 1500; 2000; 2500; 3000 | 1,200/74/6,67 -> 0,864/135/8,01 | 0 / 7 | 7 | 0 | N/N |
| 54 | `r133b` | ORB_Ott | U30USD M5 | T 100k 1% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | UseCloseConfirm: 0; 1 | 1,250/71/7,89 -> 1,674/119/9,76 | 2 / 0 | 0 | 1 | P/A |
| 55 | `r147b` | ORB_Ott | U30USD M5 | T 10k 0,65% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | CloseAtEnd: 0; 1 | 1,231/71/5,65 -> 1,675/119/6,54 | 2 / 0 | 0 | 0 | N/N |
| 56 | `r133c` | MaxMinNotte | D30EUR M15 | T 10k 1% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | MinBoxPts: 0..12000 (9) | 1,997/38/4,89 -> 1,016/65/9,05 | 4 / 5 | 5 | 0 | A/A |
| 57 | `r151a` | MaxMinNotte | XAUUSD H2 | B 100k 0,5% | IS 2020.01.01-2022.08.06 / OOS 2022.08.07-2026.06.30 | TrailAtrMult: 0,8; 1,2; 1,6; 2,0; 2,4; 2,8; 3,2 | 1,108/265/5,27 -> 1,438/428/5,30 | 7 / 0 | 0 | 1 | N/N |
| 58 | `r170b` | MaxMinNotte | XAUUSD H2 | B 100k 0,5% | IS 2020.01.01-2022.08.06 / OOS 2022.08.07-2026.06.30 | CloseAtEnd: 0; 1 | 1,108/265/5,27 -> 1,438/428/5,30 | 2 / 0 | 0 | 0 | N/N |
| 59 | `r170c` | MaxMinNotte_DAX_Short_Ott | D30EUR M15 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | CloseAtEnd: 0; 1 | 1,878/20/3,10 -> 2,160/21/1,92 | 2 / 0 | 0 | 0 | N/N |
| 60 | `R123AGATE` | SupRev_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 0,988/117/6,17 -> 1,389/152/5,91 | 1 / 0 | 0 | 1 | P/P |
| 61 | `R123BSTMULT` | SupRev_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | StMult: 2,5; 3,0; 3,5; 4,0; 4,5 | 0,988/117/6,17 -> 1,389/152/5,91 | 3 / 2 | 1 | 2 | P/P |
| 62 | `R123CATRP` | SupRev_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | StAtrPeriod: 6; 7; 8; 9; 10; 11; 12 | 0,988/117/6,17 -> 1,389/152/5,91 | 3 / 4 | 0 | 2 | P/P |
| 63 | `R123DNEARATR` | SupRev_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | NearAtr: 0,50; 0,75; 1,00; 1,25; 1,50 | 0,988/117/6,17 -> 1,389/152/5,91 | 4 / 1 | 0 | 3 | P/P |
| 64 | `r132c` | SupRev_DOW_H1_Ott | U30USD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | NearAtr: 0,25; 0,50; 0,75; 1,00; 1,25; 1,50; 1,75; 2,00 | 0,988/117/6,17 -> 1,389/152/5,91 | 7 / 1 | 0 | 6 | P/A |
| 65 | `r127a` | SupRev_NAS_H1_Ott | NASUSD H1 | T 10k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferPips: 3..3003 (9) | 1,298/71/0,99 -> 1,613/87/1,09 | 9 / 0 | 0 | 0 | N/N |
| 66 | `r163a` | SupRev_NAS_H1_Ott | NASUSD H1 | T 100k 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | SLBufferPips: 2253; 2628; 3003; 3378; 3753; 4128; 4503 | 1,540/76/0,81 -> 1,591/96/1,34 | 7 / 0 | 0 | 0 | N/N |
| 67 | `P0_EURCHF` | Nightly | EURCHF M5 | T? 10k* 1,0% | IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30 | solo InpMagic (cella unica) | 0,891/63/11,10 -> 0,814/85/15,39 | 0 / 1 | 0 | 0 | P/P |

### 3.2 Cosa dichiarava il resoconto e cosa dicono i CSV (stesso ordine)
| # | round | cella di riferimento | il resoconto diceva -> cosa dicono i CSV |
|---:|---|---|---|
| 1 | `q770be` | no (ClosePct 0 + BE) | G1 sc.1 §5 scrive 'ClosePct 0 + BE: OOS 1,491 (+0,094), firma pendente di Claudio'. CSV: coincide (OOS 1,491 su 193 deal = posizioni, ClosePct 0). Le celle BEatR 0,0 e 1,5 sono identiche in IS e OOS. |
| 2 | `r137a` | si (MinStopPts 800) | G1 sc.1 §3 elenca 'r137a-c' fra i round fatti, senza numeri. CSV: l'ancora riproduce il contratto (1,126/175/5,44 -> 1,397/270/7,23 = r47a). Floor 4800 e 6800 battono l'ancora in IS e OOS; a 10800 e 12800 IS<1 e OOS>1. |
| 3 | `r137b` | si (MinStopPts 800) | Come r137a, ma 'salta il trade se lo stop e' stretto': n crolla (IS 175 -> 15, OOS 270 -> 35 al floor 12800). OOS>=1 su 5 celle su 7, IS>=1 su 3 su 7. |
| 4 | `r137c` | NO: ancora=ClosePct 0; sedia=50 | G1 sc.1 §3 cita r137c senza numeri. CSV: ClosePct 50 = contratto; ClosePct 0 = 1,183/132 e 1,491/193 (n = posizioni del contratto: 193 pos / 276 g = 0,699 op/g promesse). |
| 5 | `r138a` | si (gemello F40EUR) | G1: 'F40EUR OOS 0,770 SOTTO (DD 11,82%)': coincide. L'IS (1,440 su 130, DD 7,36) non e' scritto da G1: il SEGNO INVERTITO IS sopra -> OOS sotto non era dichiarato. |
| 6 | `r147c` | si (CloseAtEnd 1) | G1: non citato come misura d'uscita. CSV: CloseAtEnd 1 = contratto; CloseAtEnd 0 (tieni overnight): IS 1,137/176, OOS 1,417/272, DD 7,26: due finestre sopra l'ancora di poco. |
| 7 | `r152a` | si (stessa cella a rischio 0,65%) | CT/G1: contratto a 1% (5,67/4,39). r152a e' la stessa cella al rischio di campo 0,65% (prova: InpRiskPercent 0,65): DD 3,71/2,85 = 0,65 x contratto (3,69/2,86); PF 1,227/1,278 (lieve differenza da lotti). |
| 8 | `r172a` | si (TrailStartR 0) | G1 sc.10 §3: 'R172a-j sospesi/mai girati (nove assi, 124 passate)'. CSV: 10 round (r172a-j), 69 celle, 138 passate (+ r152a: 70 celle). TrailStartR: l'ancora e' il massimo OOS (1,270); 0,25 il massimo IS (1,287). |
| 9 | `r172b` | si (CloseHour 17) | Idem. IS: 17 e' il massimo (1,223); OOS: 19-21 danno 1,399-1,425 (n 149-157) con IS 0,933-0,987: 3 celle IS sotto -> OOS sopra. CloseHour 15: 0,413 / 0,761. |
| 10 | `r172c` | si (BreakevenAtTP1 1) | Idem. BE a TP1 spento: IS 1,253 (n 74), OOS 1,211: n identico. |
| 11 | `r172d` | si (BEatR 0) | G1 sc.10 §5 cita 'BEatR nessuno batte la viva (R172D)' (e a §3 'R172a-j mai girati'): CSV conferma, nessuna cella supera l'ancora in OOS (max 1,267 a 0,90); 0,15/0,30 IS>1 -> OOS<1. |
| 12 | `r172e` | si (TP1_R 1,00) | G1 sc.10 §5: 'TP1_R 1,00 massimo sul bordo dell'asse 0,25-1,00 (0,93/1,10/1,14/1,27): il bordo non e' un centro'. CSV, asse esteso a 2,0: OOS 1,259/1,294/1,285/1,252 a 1,25-2,00 (n 113-126): l'ancora e' sulla spalla sinistra di un altopiano, non un massimo di bordo. |
| 13 | `r172f` | si (InpTrailTF M5) | G1 sc.10 §9: per il Dow 'mancano gemelli e InpTrailTF' (certificato dello short). CSV (solo lato long): TrailTF M1-M30: M1 0,752/0,798; altopiano M5-M10 (IS 1,222-1,232; OOS 1,230-1,270); M30 0,975/1,039. |
| 14 | `r172g` | si (CloseAtEnd 1) | G1: non citato. CSV: CloseAtEnd 0 (tieni overnight) = IS 0,974/72, OOS 1,467/138 (DD 3,50): IS sotto -> OOS sopra. |
| 15 | `r172h` | si (SLMode 0) | G1: non citato. CSV: SLMode 1: IS 0,789 (DD 10,93) / OOS 1,111 (DD 5,47, peggior giornata -1,14%). |
| 16 | `r172i` | si (MinStopPts 500 = 0) | G1: non citato. CSV: celle 500-2500 identiche all'ancora (inerti); da 3500 il PF scende; da 8500 IS>1 -> OOS<1 (5 celle). n OOS 128-130. |
| 17 | `r172j` | NO: MinStopPts pinnato 8000 | G1: non citato. CSV: la cella 'SkipIfTight 0' coincide con MinStopPts 8000 di r172i (1,159/74 e 1,010/128): l'ancora non e' la sedia. SkipIfTight 1: IS 1,276/46, OOS 0,927/92. |
| 18 | `r170a` | 770250 (gated short M15 0,65%) | G1 sc.14 riga 14d: '770250 OOS 1,097 su 104, DD 4,54%: ZONA GRIGIA'. CSV r170a: IS 1,257/57/4,54, OOS 0,948/47/3,63. 57+47 = 104 deal; PF combinato ricostruito da Profit e PF = 1,0996 (REFERTO_SHORTGATE: 1,097 su 104, DD 4,54): il 1,097 e' la finestra piena. |
| 19 | `r142a` | si (ClosePct 50) | G1 sc.23: 'r142a/b/c: IS 1,01472 / OOS 0,95624 (116/175, DD 12,3/22,5% @2%); l'asse morde (+0,11 PF) ma nessuna cella arriva a 1,10': conferma. ClosePct 0/25: IS 1,054/1,045, OOS 0,964/0,970. |
| 20 | `r142b` | si (TrailTF M1) | Idem: TrailTF M2-M5 OOS 1,001-1,070 (max 1,070, +0,11 sull'ancora), DD OOS 17,6-27,9%; IS 1,214-1,262. |
| 21 | `r142c` | si (trailing 1) | G1: 'senza trailing DD OOS 33,62%': coincide (OOS 0,999). IS senza trailing 1,322 -> OOS 0,999. |
| 22 | `r150a` | si (TrailStartR 0) | G1: non citato (quarta manopola d'uscita). CSV: IS 1,015-1,283 su 7/7; OOS 0,912-1,014 (2 su 7 sopra, max 1,014): nessuna cella arriva a 1,10; DD OOS 22,3-34,3%. |
| 23 | `cemad02` | si | G2 §13: 'il file IS di cemad02 e' 0 byte per scelta @FRAZIONEIS 0,002'. CSV: IS vuoto; il file '_OOS_' contiene la finestra IS dei round r136 (237 deal, 1,2011, DD 5,7325 = r136a IS al centesimo). IS posizioni (132) NON LEGGIBILE: nessun per-trade. |
| 24 | `cemad05` | si (H1) | G2 §1.1 tab. 5: H2 2,599/1,173, H3 2,152/0,908, H4 1,660/1,425, M30 1,034/0,907, M20 1,117/0,833, M15 0,771/0,954: CSV conferma tutti. |
| 25 | `r136a` | si (SLatr 1,0) | G2 §1.1 §10: SLatr 0,8 OOS 1,612; altopiano 0,8-1,6; centro 1,2 non batte la viva: CSV conferma (1,612; 1,462 a 1,2). |
| 26 | `r136b` | si (TP1_ATRmult 0 = spento) | G2: TP1_ATRmult 0,25 OOS 1,590, DD 2,10%, IS 0,994: coincide. Celle con TP1 acceso: IS 0,762-1,014 (sopra 1 solo a 0,50), OOS 1,409-1,590 (6 su 6 sopra 1). |
| 27 | `r136c` | si (TP1Pct 50) | G2: 'taglia del parziale inerte (25-75: 1,518-1,526); parziale spento DD OOS 13,94%': coincide. Parziale 0: IS 0,935/81, OOS 1,281/165. |
| 28 | `r136d` | si (trailing 1) | G2: 'trailing 0: OOS 1,771, IS 1,107, segno invertito fra IS e OOS (nota: IS 1,107 e' comunque sopra 1)': coincide. IS e OOS restano entrambi >=1; il 'segno invertito' di G2 e' il verso del delta rispetto all'ancora (IS peggiora, OOS migliora), non rispetto a 1. |
| 29 | `r146b` | si (Friday 0) | G2: non citato (0 occorrenze). CSV: FridayClose 1: IS 1,213/233 DD 4,81; OOS 1,425/503 DD 7,84. |
| 30 | `r147a` | si (Breakeven 1) | G2: non citato. CSV: Breakeven 0: IS 1,288/368, OOS 1,528/769 (DD 8,90): n +55% IS, +49% OOS; PF OOS invariato. |
| 31 | `r139a` | n/a (OHLC) | G2: AUDJPY H4 16,5 anni IS 0,78-0,81 / OOS 0,95-1,01: conferma. [B]: screening. |
| 32 | `r139b` | n/a (OHLC) | G2: GBPUSD IS 0,80-0,84 / OOS 1,13 (segno invertito 4 su 4): conferma. Il CSV del 05/10 differisce da quello del 13/09 (OHLC, PF IS 0,835 contro 0,838 ecc.). |
| 33 | `r120b00` | si (b00 = trail OFF flip OFF) | G2 §2.2 (2a passata): 'b00 0,903/1,187 (90 deal): SOPRA(OOS) con SEGNO INVERTITO': conferma. |
| 34 | `r120b01` | si (trail OFF flip ON) | G2: NON CITATO. CSV: IS 1,406/71, OOS 0,983/125, DD OOS 5,11: cella SOTTO in OOS (IS sopra -> OOS sotto), omessa dalle liste G2. |
| 35 | `r120b10` | si (trail ON flip OFF) | G2: 'ExitOnFlip inerte a trailing acceso (OOS identico cifra per cifra)': conferma per l'OOS (344,12 / 1,243 / 131); l'IS no (1,489 contro 1,482 di b11, profit 493,73 contro 488,63). |
| 36 | `r120b11` | si (sedia 10k) | G2: 'r120b11: IS 1,482 (72)/OOS 1,243 (131), DD 4,04/4,17': coincide. E' la seconda delle due letture del contratto CONTESO. |
| 37 | `r120e00` | si (e00) | G2: 'e00 0,978/1,284 (130), DD OOS 6,53': conferma. |
| 38 | `r120e11` | si (sedia 100k) | G2: 'r120e11 1,397 (106)/1,220 (184), DD 3,48/4,21': conferma. |
| 39 | `r126a` | si (SLBufferAtr 0) | G2: 'R126a/b lookback 5: ancora grado C, IS 1,48166 contro 1,84892': conferma 1,482 (la lettura 1,849 non e' in nessun CSV). Buffer 0,125-1,0: IS 1,558-1,879, OOS 1,234-1,402. |
| 40 | `r126b` | si (SLLookback 5) | G2: idem: ancora 1,482/1,243. Lookback 3/7/9 battono l'ancora in IS e OOS (n IS 68-76, OOS 124-137). |
| 41 | `r155a` | si (TP_RR 3,0, finestra piena 10k) | G2 §2.2 pt.3: 'TP_RR: file mai lanciato'. CSV: finestra piena 2024.09.26-2026.06.30, nessun OOS: PF 1,263-1,344, n 203-205, DD 4,41-4,88. |
| 42 | `r165a` | si (SLBufferPips 3) | G2: 'SLBuffer: file mai lanciato'. CSV: IS 1,373-1,419, OOS 1,209-1,258, n 106/184 invariante, DD OOS 4,02-4,48: 6 su 6 sopra. |
| 43 | `r173a` | si (TP1Pct 50) | G2: 'TP1Pct: mai lanciato'. CSV: TP1Pct 0: IS 1,674/72, OOS 1,455/116; 25: 1,653/1,318; 75: 1,106/1,140. Parziale 0 e 25 battono la sedia in IS e OOS. |
| 44 | `r173b` | si (TP1_R 1,0) | G2: 'TP1_R: mai lanciato'. CSV: TP1_R 0,5: IS 1,569/114, OOS 1,928/208 (DD 3,56); 1,5: 1,309/1,323; 2,0: 1,342/1,366: 4 su 4 sopra 1 in IS e OOS. |
| 45 | `r173c` | si (Breakeven 1) | G2: 'BE: mai lanciato'. CSV: Breakeven 0: IS 0,879/207, OOS 1,050/418 (DD 4,06): IS sotto -> OOS sopra; n raddoppia. |
| 46 | `r126d` | si (NASUSD H1) | G2 §2.1: 'NASUSD H1 (R126d, 9 celle) IS 0,71-1,13 / OOS 0,73-0,84, n 35-38/58-63': conferma (OOS 0,732-0,843). |
| 47 | `r154a` | si (770531 H2 chart H4, finestra piena) | G2 §2.1: U30USD H2 IS 5,571 (32 deal) / OOS 1,762 (88 deal), DD 4,27%: r154a non e' citato. CSV a finestra piena (nessun OOS per costruzione): PF 2,238-2,565, n 120 (= 32+88), DD 3,60-4,29; n invariante. |
| 48 | `r125a` | NO: OPPRANGE (SLMode 0) | G2 §3.2: 'R125 (66 passate): preparato, mai girato'. OPPRANGE (R88a): IS 0,93-1,09, OOS 1,68, DD 3,70-5,87. CSV r125a (7 celle): IS 0,916-1,063, OOS 1,645-1,839, DD OOS 3,84-4,40; n 71/119 invariante. |
| 49 | `r125b` | si (TP1Pct 0 = sedia, HALFRANGE) | G2: 'R88a/R118a: HALFRANGE IS 1,250 (71)/OOS 1,674 (119), DD 7,89/9,76': CSV r125b ancora identico. TP1Pct 25/50/75 (mai spazzolato): IS 1,175/1,106/1,034, OOS 1,488/1,411/1,332, DD OOS 9,89-10,58. |
| 50 | `r125c` | NO: OPPRANGE long D30EUR | G2: 'D30EUR (R11): OOS 0,94-1,02, DD 17,5-29,7%'. CSV r125c: IS 1,130-1,308; OOS 0,997-1,116 (5 su 7 sopra 1); DD OOS 6,32-9,80; n 84/128 invariante. |
| 51 | `r125d` | NO: OPPRANGE short D30EUR | G2: lato short solo su U30USD (OOS 0,52, DD 26,4%). CSV: D30EUR short IS 0,858/56, OOS 0,650/97, DD 8,88. |
| 52 | `r125e` | NO: OPPRANGE D30EUR buf 2000 | G2: non citato. CSV: MinRangePct 0,15 e 0,20: IS 1,207/58 e 1,222/44; OOS 1,152/88 (DD 2,95) e 1,372/71 (DD 2,31): celle sopra 1 in entrambe con n sottile; 0,10: IS 1,360 -> OOS 0,999. Celle 0,00 e 0,05 identiche (= r125c buffer 2000). |
| 53 | `r125f` | NO: OPPRANGE NASUSD | G2: 'NASUSD (R97): IS 1,13-1,32 / OOS 0,84-0,91 su 135 deal; R13 'primo altopiano' smentito': CSV r125f: IS 1,192-1,422 (n 74), OOS 0,767-0,864 (n 135): 7 su 7 IS sopra -> OOS sotto. |
| 54 | `r133b` | si (CloseConfirm 0 = sedia) | G2 §3.2 C5: 'l'etichetta M30 di r133b e' sbagliata: i numeri sono identici a R88a': CSV conferma (ancora = 1,250/71, 1,674/119). CloseConfirm 1: IS 0,523/80 (DD 27,2), OOS 1,122/136 (DD 11,96). |
| 55 | `r147b` | si (770611 a 0,65% e 10k) | G2: non citato (R15 a 10k e 1%: 1,223/1,657, DD 8,63/9,92). CSV a 0,65%: 1,231/71/5,65 -> 1,675/119/6,54 = contratto CENSIMENTO_CONTRATTI_v2 r.216 (DD 5,6530 IS / 6,5389 OOS, 119/71 pos) al centesimo. CloseAtEnd inerte: OOS identico, IS 1,2319 contro 1,2308. |
| 56 | `r133c` | NO: MaxMinNotte short senza filtro S&P | G3: non citato. CSV: IS 1,997 (38) -> OOS 1,016 (65, DD 9,05) all'ancora; MinBoxPts alza l'IS (fino a 9,414 su 13) e abbassa l'OOS (fino a 0,197 su 17): 5 celle IS sopra -> OOS sotto. |
| 57 | `r151a` | si (oro H2, trailing 2,0) | G3 riga 1a: 'oro due lati H2 [B] 0,5% dep 100k: 1,308 (s.OOS) n 693 D = 511 P'. CSV: stessa geometria con split: IS 1,108/265 + OOS 1,438/428 = 693 deal. TrailAtrMult 1,2-3,2 altopiano (OOS 1,44-1,52); 0,8: IS 0,935 -> OOS 1,661. [B]: screening. |
| 58 | `r170b` | si (CloseAtEnd 1) | G3: non citato. CSV: CloseAtEnd 0: IS 1,091/332, OOS 1,091/493 (DD 5,76) contro 1,438/428 con CloseAtEnd 1: l'OOS dell'ancora dipende dal flat a fine finestra. [B]. |
| 59 | `r170c` | si (770411, CloseAtEnd 1) | G3 sc.4.2: 'IS 1,878 / OOS 2,160, 20 D / 21 D = 14 P, DD 3,10/1,92': CSV identico; CloseAtEnd inerte (le due celle identiche in IS e OOS). |
| 60 | `R123AGATE` | si (cella viva 970916) | G5 D01: 'R123/r132c 0,988/1,389 (117/152)': conferma. Le due righe differiscono solo per InpMagic. |
| 61 | `R123BSTMULT` | si (StMult 3,5) | G5 D02-D04: St 4,5 2,017/1,418; St 4,0 0,721/1,093; St 2,5 0,877/0,914; St 3,0 1,084/0,953: conferma. |
| 62 | `R123CATRP` | si (AtrP 9) | G5 D02-D04: AtrP 12 1,177/1,359; AtrP 8 0,781/1,164; AtrP 6/7/10/11 OOS <1: conferma. |
| 63 | `R123DNEARATR` | si (NearAtr 1,0) | G5 D02-D04: NearAtr 1,25 1,005/1,322; 0,5 0,635/0,992; 0,75 0,770/1,284: conferma. |
| 64 | `r132c` | si (NearAtr 1,0) | G5 §1.7: 'r132c: 8 celle NearAtr 0,25-2,0; riproduzione 3 su 5, scarto 0,51-0,53 EUR': l'ancora IS -15,45 contro -15,58 di R123 (0,13), OOS 622,28 contro 622,79 (0,51). 1,75 e 2,00 identiche. |
| 65 | `r127a` | si (SLBufferPips 3) | G5 Y01/Y02: 'R127a-ancora 1,298 (71)/1,613 (87); 9 celle su 9 sopra': conferma (IS 1,298-1,523, OOS 1,497-1,721). |
| 66 | `r163a` | si (SLBufferPips 2253) | G5 §1.6 e D19: 'R163a scritto/armato, nessun CSV in repo: NM'. CSV: 7 celle, IS 1,432-1,542 (n 76), OOS 1,485-1,615 (n 96), DD OOS 1,10-1,34 (100k): 7 su 7 sopra 1 in IS e OOS; n invariante. |
| 67 | `P0_EURCHF` | si (P0 Nightly) | G3 sc.4.5: 'EURCHF [T] 0,891/0,814 · 63/85 · 11,10/15,39': conferma. Finestra 2024.09.26 (non la finestra lunga nativa: difetto D6 di G3). |

---

## 4. SCHEDE BREVI PER EA

Ogni scheda: round letti, cella di riferimento e contratto, misure, segni invertiti, caselle del certificato che i CSV chiudono, cosa cambierebbe (proposta), NON LEGGIBILE. La classe e' quella del piano applicata ai soli CSV; **non e' un verdetto**.

### 4.1 `ABTG_DAX_Apertura_EU` - sedia 770101 (long) - 6 round, 12 CSV (`q770be`, `r137a/b/c`, `r138a`, `r147c`)
- **Perimetro**: D30EUR M5 (`r138a`: F40EUR M5), `[T]`, 100k, rischio 1%, IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30. **Tutte le prove sono solo long** (`InpAllowShort=false`): il lato short (770105) **non e' in questa cartella** [NON COPERTO qui].
- **Cella del contratto** (ClosePct 50, floor 800): **1,126 / 175 / 5,44 -> 1,397 / 270 / 7,23**, riprodotta al centesimo in 4 round (`r137a`, `r137b`, `r137c` ClosePct 50, `r147c` CloseAtEnd 1) = `r47a` del contratto (DD IS 5,4362 / OOS 7,2328).
  Posizioni NON LEGGIBILI dal CSV; con ClosePct 0 deal = posizioni: **132 / 193**, e 193 / 276 giorni = 0,699 op/g = la frequenza promessa dal contratto.
- **Misure**: `r137a` (floor dello stop allargato, 7 celle): OOS 1,284-1,496 su 7 su 7; IS 0,846-1,317, sopra 1 su 5 su 7; floor 4800: 1,317 / 1,496, floor 6800 (68 idx, la frontiera 40x scritta nella prova): **1,233 / 1,420, n 178/272, DD 5,11/7,25**; floor 10800 e 12800: IS 0,966 e 0,846, OOS 1,288 e 1,284.
  `r137b` (stop stretto = trade saltato): n crolla (IS 175 -> 15, OOS 270 -> 35), OOS 5 su 7 sopra, IS 3 su 7. `r147c`: tenere overnight (CloseAtEnd 0) IS 1,137 / OOS 1,417. `q770be` (ClosePct 0 + BEatR 0 / 0,5 / 1,0 / 1,5): OOS 1,446-1,491 su 193, IS 1,152-1,183 su 132; BEatR 0,0 e 1,5 identiche.
  `r138a` (F40EUR): **IS 1,440 / 130 / 7,36 -> OOS 0,770 / 195 / 11,82**: SEGNO INVERTITO (IS sopra -> OOS sotto), DD OOS sopra il 10%.
- **Classe (lettura)**: 770101 long **SOPRA**, aff. **B** se si accettano le 193 posizioni contate nel contratto (dal solo CSV: 270 deal = B o C provvisoria); IS 132 pos < 150; un solo regime. F40EUR **SOTTO** (195 deal: B o C provvisoria), SEGNO INVERTITO.
- **Caselle**: (3) uscita: floor stop, skip, ClosePct, CloseAtEnd, BEatR messi ad asse sul long; (4) gemelli: F40EUR (long); (5) TF: non applicabile (range letto su M1).
- **Cambia?** Il verdetto del long G1 e' **confermato**. G1 non scrive l'IS di F40EUR (segno invertito non dichiarato). `r137a` e' la misura che serve alla questione "costo FRAGILE": al floor 6800 l'IS e l'OOS non peggiorano l'ancora (1,233 / 1,420 contro 1,126 / 1,397);
  se e come usarla sul preset e' **decisione di Claudio** (non e' una taglia ma tocca la sedia in campo).

### 4.2 `ABTG_Dow_Apertura_US` - sedia 770202 (long) - 11 round, 22 CSV (`r152a`, `r172a-j`)
- **Perimetro**: U30USD M5, `[T]`, 100k, 1% (`r152a`: 0,65% = taglia di campo), stesse finestre; **solo long** (`InpAllowShort=false`); lo short (R54a, R255) non e' in questa cartella [NON COPERTO qui].
- **Ancora = contratto**: **1,222 / 74 / 5,67 -> 1,270 / 130 / 4,39** (DD IS 5,6692 / OOS 4,3941) in **9 round su 10** (`r172a-i`); `r172j` ha MinStopPts pinnato a 8000 e non e' la sedia. `r152a` a 0,65%: 1,227 / 74 / 3,71 -> 1,278 / 130 / 2,85 (DD = 0,65 x contratto).
  Posizioni (96 OOS, 56 IS nel contratto): NON LEGGIBILI dai CSV. Frequenza: 130 deal / 276 g = 0,471 op/g in deal (promessa 0,348 in posizioni).
- **Dieci assi d'uscita** (G1: "sospesi / mai girati"): 69 celle, 138 passate.
  TrailStartR 0-1,5: l'ancora e' il massimo OOS (1,270); IS massimo a 0,25 (1,287). CloseHour 15-21: IS massimo all'ancora (1,223); OOS 19-21 danno 1,399-1,425 (n 149-157) con IS 0,933-0,987 (3 celle IS sotto -> OOS sopra); a 15: 0,413 / 0,761.
  BreakevenAtTP1 spento: 1,253 / 1,211 (n invariante 74/130). BEatR 0-0,90: nessuna cella supera l'ancora in OOS (max 1,267 a 0,90); 0,15 e 0,30 IS sopra -> OOS sotto. TP1_R 0,5-2,0: OOS 1,105-1,294, **altopiano 1,0-2,0 (OOS 1,252-1,294, n 113-126)**; IS 1,058-1,385.
  TrailTF M1-M30: M1 0,752 / 0,798; altopiano M5-M10 (IS 1,222-1,232, OOS 1,230-1,270); M2, M3 e M30 IS sotto -> OOS sopra. CloseAtEnd 0: **IS 0,974 / 72 -> OOS 1,467 / 138** (DD 3,50). SLMode 1: IS 0,789 (DD 10,93) -> OOS 1,111 (DD 5,47).
  MinStopPts 0-10500: 500-2500 identiche all'ancora, poi cala; IS 22/22 sopra 1, OOS 17/22; **5 celle (8500-10500) IS sopra -> OOS sotto**. SkipIfTight (a 8000): 0 -> 1,159 / 1,010; 1 -> **1,276 / 46 -> 0,927 / 92**.
  **Nessuna cella supera l'ancora in IS e in OOS insieme, salvo TP1_R 1,50 e 1,75** (IS +0,104 / +0,095, OOS +0,024 / +0,015 sull'ancora). I candidati forti in OOS (CloseHour 19-21, CloseAtEnd 0, SLMode 1) hanno tutti l'IS sotto 1.
- **Classe (lettura)**: long **SOPRA**, aff. **C** (130 deal < 150: per costruzione < 150 posizioni); un solo regime; DD OOS 4,39% a 1%.
- **Caselle**: per il **long** sono messe ad asse 9 manopole d'uscita (casella 3) e `InpTrailTF` (la "manopola TF" che per G1 e' l'unica che morde, casella 5). Per lo **short** (SOTTO per G1) nulla: tutti i round sono long.
- **Cambia?** G1 sc.10 §3 ("R172a-j sospesi / mai girati") e §5 ("TP1_R 1,00 massimo sul bordo dell'asse 0,25-1,00") vanno aggiornati (sez. 6 V3): l'ancora e' sulla spalla sinistra di un altopiano OOS 1,0-2,0, non su un bordo-massimo.
  Il verdetto del long (SOPRA C, MERITO SOSPESO) resta; "il default va bene" e' confermato, nel senso "nessuna cella lo batte in IS e OOS insieme", su 8 degli 9 assi con ancora = sedia (fa eccezione TP1_R).

### 4.3 `ABTG_Nasdaq_Apertura_US` - 770250 (gated short M15) - 1 round, 2 CSV (`r170a`)
- **Perimetro**: NASUSD **M15**, solo short, filtro EMA H4 (la prova: "sedia gated short"), `[T]`, 100k, rischio **0,65%**, IS ..2025.06.09 / OOS 2025.06.10.. Asse `InpCloseAtEnd` (2 celle).
- **Numeri**: CloseAtEnd 1 (default): **IS 1,257 / 57 / 4,54 -> OOS 0,948 / 47 / 3,63**; CloseAtEnd 0: IS 1,316 / 56 -> OOS 0,948 / 47 (OOS identico).
- **Lettura**: 57 + 47 = 104 deal = n del `REFERTO_SHORTGATE_2026-08-30` (104, PF 1,097, DD 4,54, +1951): il PF combinato IS+OOS ricostruito da Profit e PF (GL = Profit / (PF - 1)) e' **1,0996**, il profitto 1968,56, il DD 4,54 e' quello dell'IS.
  Quindi **lo 1,097 e' la finestra piena**; con lo split 40/60 l'OOS e' **0,948** (SEGNO INVERTITO: IS sopra -> OOS sotto) e **la regione sotto 1 e' proprio l'OOS**. Classe (lettura): **SOTTO**, aff. **C o D** (47 deal con parziale al 50%: 21-47 posizioni).
- **Cambia?** Si': riga 14d di G1 ("SOPRA C (PF ~1), ZONA GRIGIA, OOS 1,097 su 104") - sez. 6 V1. La sedia e' ferma dal 25/09 (G1): nessuna azione qui.

### 4.4 `ABTG_Nasdaq_Live5m` - 770203 (spenta) - 4 round, 8 CSV (`r142a/b/c`, `r150a`)
- **Perimetro**: NASUSD M5, ingresso pre-apertura, due lati, `[T]`, **10k, rischio 2%**, finestre standard. Assi: ClosePct (r142a), TrailTF (r142b), trailing on/off (r142c), TrailStartR (r150a).
- **Ancora**: **1,015 / 116 / 12,28 -> 0,956 / 175 / 22,47** (IS 98 / OOS -448 in profitto), riprodotta in 4 round = G1 sc.23 (r142).
- **Celle** (18): IS sopra in 17 su 18, **OOS sopra in 6 su 18**; 11 celle IS sopra -> OOS sotto; **nessuna cella arriva a 1,10 in OOS** (max 1,070 a TrailTF M2). DD OOS **17,6-34,3%** su tutte le 18 celle (al 2%, sopra il muro 10% citato dai resoconti).
  Senza trailing: IS 1,322 -> OOS 0,999, DD 33,62. `r150a` (TrailStartR 0-3 R): IS 1,015-1,283, OOS 0,912-1,014 (2 su 7 sopra 1).
- **Classe**: **SOTTO**, aff. B o C provvisoria (175 deal con parziale 50%). Certificato: casella 3 chiusa dai quattro assi (G1 ne contava tre: `r150a` e' la quarta); (4) gemelli parziali; (5) non applicabile.
- **Cambia?** Nessun verdetto: `r150a` conferma G1 (nessuna cella a 1,10); G1 non lo cita (sez. 6 V12).

### 4.5 `ABTG_EMA200` - sedia 771531 (U30USD H1 L+S) e H4 forex - 10 round, 20 CSV (19 con dati)
- **Perimetro U30USD H1**: `[T]`, 100k, 1%, finestre standard, **due lati**. Round: `r136a` (SLatr), `r136b` (TP1_ATRmult), `r136c` (TP1Pct), `r136d` (trailing), `r146b` (venerdi'), `r147a` (breakeven), `cemad05` (TF M15-H4), `cemad02` (per-trade IS).
- **Ancora = contratto**: **1,201 / 237 / 5,73 -> 1,524 / 517 / 7,83** in **7 round** (DD IS 5,7325 / OOS 7,8323). Posizioni: 257 OOS e 132 IS (dichiarato) NON LEGGIBILI dal CSV: 517 deal e 237 deal. Frequenza in deal: 517 / 276 = 1,873 op/g (promessa 0,931 in posizioni, 257 / 276).
  **`cemad02`**: il CSV IS e' vuoto; il file `_OOS_` contiene **la finestra IS** (2024.09.27-2025.06.09: 237 deal, 1,2011, DD 5,7325 = IS di `r136a`). Le posizioni IS (132) restano NON LEGGIBILI: serve il per-trade (G2 punto D1).
- **Misure**: SLatr 0,4-1,6: IS 1,072-1,255, OOS 1,264-1,612 (7 su 7 sopra), altopiano 0,6-1,6. TP1_ATRmult: con TP1 acceso IS 0,762-1,014 (sopra 1 solo a 0,50), OOS 1,409-1,590. TP1Pct 25/75 inerte (OOS 1,518 / 1,526); parziale 0: IS 0,935 / 81 -> OOS 1,281 / 165, DD OOS 13,94.
  Trailing spento: IS 1,107 -> OOS 1,771 (DD 7,42). **Venerdi' (r146b, non in G2)**: FridayClose 1: IS 1,213 / 233 (DD 4,81), OOS 1,425 / 503 (DD 7,84). **Breakeven (r147a, non in G2)**: Breakeven 0: IS 1,288 / 368, OOS 1,528 / **769** (DD 8,90): **deal +55% IS, +49% OOS**, PF OOS invariato.
  TF (cemad05): M15 0,771 / 0,954 (DD OOS 26,34), M20 1,117 / 0,833, M30 1,034 / 0,907, **H1 1,201 / 1,524**, H2 2,599 / 1,173, H3 2,152 / 0,908, H4 1,660 / 1,425: conferma G2.
- **H4 forex `[B]` (`r139a/b`, 2010.01.01-2026.06.30, IS ..2016.08.06 / OOS 2016.08.07.., 10k)**: AUDJPY IS 0,780-0,807 (n 757-768, DD 15,35-16,94) / OOS 0,949-1,008 (n 1322-1345, DD 16,89-20,44); GBPUSD IS 0,802-0,835 (n 856-875, DD 17,95-20,41) / **OOS 1,122-1,136** (n 1292-1321, DD 10,14-11,25): **IS sotto -> OOS sopra su 4 celle su 4** (GBPUSD).
  Screening: non promuove e non boccia. Il CSV di `r139b` del 05/10 differisce lievemente da quello del 13/09 (IS 0,835 contro 0,838 a TP_RR 3,0; stesso n).
- **Classe (lettura)**: 771531 **SOPRA**, aff. **B** (517 deal >= 346: B anche dal solo CSV; 257 pos nel contratto), IS pos < 150 (132 dichiarato); un solo regime; stagione e regime NON LEGGIBILI. AUDJPY H4 `[B]` SOTTO (screening); GBPUSD H4 `[B]` SOPRA (screening) con SEGNO INVERTITO.
- **Caselle**: la 771531 e' SOPRA (non serve certificato). Per le celle SOTTO (AUDJPY H4, gemelli): `r139a/b` mettono ad asse `InpTP_RR` 1,5-3,0 (casella 3, OHLC) e sono due simboli gemelli (casella 4, OHLC).
- **Cambia?** Nessun verdetto cambia. **G2 non cita `r146b` / `r147a`** (sez. 6 V4): sono due assi d'uscita in piu' per la 771531; il breakeven spento alza i deal del 49% a PF OOS invariato (leva di frequenza: decisione di Claudio).

### 4.6 `ABTG_SuperWave_DOW_H1_Ottimizzato` - sedia 770511 (U30USD H1 L+S) - 13 round, 26 CSV (25 con dati)
- **Perimetro**: `[T]`, due lati, StMult 2,5, TP_RR 3,0, trailing sul Supertrend. 10k: `r120b00/01/10/11`, `r126a`, `r126b`, `r155a`; 100k: `r120e00/11`, `r165a`, `r173a/b/c`. Finestre standard; `r155a` = finestra piena senza OOS.
- **Contratto "conteso"** (3 letture nel `CONTRATTI_DELLE_SEDIE_FTMO` §5): **1,849 / 1,328 (84/143 deal)** [26/07, archivio]: **nessun CSV di questa cartella la riproduce**; **1,482 / 1,243** (10k: IS 72 / OOS 131 deal, DD 4,04 / 4,17): riprodotta da `r120b11`, `r126a`, `r126b`; **100k: 1,397 / 1,220** (106 / 184 deal, DD 3,48 / 4,21): riprodotta da `r120e11`, `r165a`, `r173a/b/c`.
  Il solo deposito sposta n da 131 a 184 (+40%) a parita' di ogni altro input. Posizioni: NON LEGGIBILI (forbice di G2 62-143 non ristretta: vedi 1.5 punto 6).
- **R120 (2x2 `TrailOnST` x `ExitOnFlip`)**, IS -> OOS: (1,1) 1,482 -> 1,243 (10k) | 1,397 -> 1,220 (100k); (1,0) 1,489 -> 1,243 (OOS identico a (1,1), IS no: 493,73 contro 488,63); **(0,1) 1,406 / 71 -> 0,983 / 125 (DD OOS 5,11): cella SOTTO, assente dalle liste G2**; (0,0) 0,903 / 46 -> 1,187 / 90 (10k) | 0,978 / 74 -> 1,284 / 130 (100k).
- **Uscite messe ad asse** (100k, finestre standard): TP1Pct 0 / 25 / **50 (sedia)** / 75: IS 1,674 / 1,653 / 1,397 / 1,106, OOS 1,455 / 1,318 / 1,220 / 1,140 (deal OOS 116 / 184 / 184 / 184; DD OOS 4,64 / 4,43 / 4,21 / 4,02). TP1_R 0,5 / **1,0** / 1,5 / 2,0: IS 1,569 / 1,397 / 1,309 / 1,342, OOS **1,928** / 1,220 / 1,323 / 1,366 (deal OOS 208 / 184 / 182 / 180; DD OOS 3,56 / 4,21 / 4,14 / 4,10).
  Breakeven spento: IS 0,879 / 207 -> OOS 1,050 / 418 (DD 4,06). SLBufferPips 3-5003: IS 1,373-1,419, OOS 1,209-1,258, **n 106 / 184 invariante**, DD OOS 4,02-4,48. Con la regola scritta nel file `r173a` (B2: celle sopra il DD piu' alto misurato a 100k, 4,2149%): `r173a` 2 su 4 (parziale 0: 4,639; 25: 4,428), nessuna sopra l'8%.
- **Uscite a 10k**: SLBufferAtr 0-1,0 (`r126a`): IS 1,482-1,879, OOS 1,234-1,402, 9 su 9 sopra in entrambe; SLLookback 1-13 (`r126b`): IS 1,369-1,638, OOS 1,135-1,305, 7 su 7; **TP_RR 2,0-4,0 (`r155a`, finestra piena, 10k)**: PF 1,263-1,344, n 203-205, DD 4,41-4,88.
- **Celle che battono la sedia in IS e OOS**: TP1Pct 0 e 25; TP1_R 0,5; SLBufferPips 1003 e 5003 (4003 solo di 0,0003 in IS); a 10k SLBufferAtr 0,125 e 0,375-1,0 (7 celle, non 0,25) e SLLookback 3, 7, 9. Sono dati, non una scelta: la regola di casa e' il centro dell'altopiano, mai il picco; qualunque cambio della sedia e' **decisione di Claudio**.
- **Classe (lettura)**: cella di contratto **CONTESA -> NON MISURATO** per il piano §5.2.6 (e' G2); entrambe le letture riproducibili sono **SOPRA** (OOS >= 1,22); aff. C (131 deal a 10k) / B o C provvisoria (184 deal a 100k); un solo regime.
- **Caselle**: (3) uscita: R120 + TP1Pct, TP1_R, BE, TP_RR, SLBuffer, SLLookback ora **con CSV** (G2: "7 file, 30 celle, 60 passate, mai lanciati": qui hanno CSV 5 file, `r155a`, `r165a`, `r173a/b/c`, 21 celle; il TF M30 `R190b` e gli altri file NON hanno CSV in questa cartella); (4) gemelli: NASUSD (`r126d`); (5) TF: **NON chiusa** (R190b mai girato).
- **Cambia?** Si' (sez. 6 V2): aggiornare "mai lanciati"; la CONTESA si riduce a una lettura non riproducibile; aggiungere la cella `r120b01`; la frase "il trailing OFF non va provato (misurato: vince acceso)" vale per (0,0) in IS, non per (0,1).

### 4.7 `ABTG_SuperWave` (nativo) - 2 round, 4 CSV (`r126d`, `r154a`)
- **`r126d`** NASUSD H1, `[T]`, 10k, 1%, due lati, SLBufferAtr 0-1,0: IS 0,708-1,126 (n 35-38, DD ~1,72), **OOS 0,732-0,843 (n 58-63, DD 2,71-3,25): 9 su 9 SOTTO**; 1 su 9 IS sopra (l'ancora 1,126 -> 0,778). Conferma G2 (R126d).
- **`r154a`** = sedia 770531 (U30USD, grafico H4, `InpTF` interno H2, StMult 3,5, TP_RR 2,0), `[T]`, 100k, 1%, **finestra piena 2024.09.26-2026.06.30, nessun OOS**, SLLookback 1-13: **PF 2,238-2,565, n 120 invariante, DD 3,60-4,29**; lookback 5 (ancora): 2,407 / 120 / 4,24.
  n 120 = 32 (IS) + 88 (OOS) di G2 per R23d: coerente. G2 non cita `r154a`.
- **Classe**: NASUSD H1 **SOTTO** (aff. C, 58-63 deal); U30USD H2 finestra piena **SOPRA senza OOS** (C*).

### 4.8 `ABTG_ORB_Ottimizzato` - sedia 770611 (U30USD M5 long) - 8 round, 16 CSV (`r125a-f`, `r133b`, `r147b`)
- **Perimetro**: `[T]`, M5, solo long (tranne `r125d` short), 100k / 1% (`r147b`: 10k / 0,65%). `r125b`, `r133b` e `r147b` usano la ricetta della sedia (HALFRANGE, `SLMode` 3, `InpTP1Pct` 0); **`r125a/c/e/f` usano OPPRANGE (`SLMode` 0)**: non e' la sedia.
- **Ancora della sedia**: **1,250 / 71 / 7,89 -> 1,674 / 119 / 9,76** (`r125b` e `r133b`, = R88a al centesimo; n 119 = posizioni, TP1Pct 0); a 0,65% e 10k (`r147b`) **1,231 / 71 / 5,65 -> 1,675 / 119 / 6,54** = contratto `CENSIMENTO_CONTRATTI_v2` r.216 (DD 5,6530 / 6,5389).
  Frequenza: 119 / 276 = 0,431 op/g (contratto ~0,43).
- **`r125b` (parziale, mai spazzolato)**: TP1Pct 25 / 50 / 75: IS 1,175 / 1,106 / 1,034, OOS 1,488 / 1,411 / 1,332, deal OOS 188, DD OOS 9,89-10,58: il parziale peggiora IS e OOS rispetto a zero.
- **OPPRANGE** (`r125a`, U30USD, buffer 0-3000): IS 0,916-1,063 (4 su 7 sopra 1), OOS 1,645-1,839 (7 su 7), DD OOS 3,84-4,40, n 71 / 119 invariante.
  **`r125c` D30EUR long** (buffer 0-3000): IS 1,130-1,308, **OOS 0,997-1,116** (5 su 7 sopra), DD OOS 6,32-9,80, n 84 / 128. **`r125e`** (D30EUR, buffer 2000, MinRangePct 0-0,20): 0,00 e 0,05 identiche; 0,10 -> IS 1,360 / OOS 0,999; **0,15 -> 1,207 / 58 -> 1,152 / 88 (DD 2,95); 0,20 -> 1,222 / 44 -> 1,372 / 71 (DD 2,31)**.
  **`r125d` D30EUR short**: IS 0,858 / 56 -> OOS 0,650 / 97 (DD 8,88). **`r125f` NASUSD long** (buffer 0-3000): **IS 1,192-1,422 (n 74) -> OOS 0,767-0,864 (n 135): 7 su 7 IS sopra -> OOS sotto**, DD OOS 6,89-8,75.
- **`r133b`**: CloseConfirm 1: IS 0,523 / 80 (DD 27,2) -> OOS 1,122 / 136 (DD 11,96). **`r147b`**: CloseAtEnd inerte (OOS identico, IS 1,2319 / 1,2308).
- **Classe (lettura)**: sedia **SOPRA**, aff. **C** (119 deal = 119 posizioni); un solo regime; DD OOS 9,76% a 1% (100k). NASUSD **SOTTO** (7 su 7, SEGNO INVERTITO); D30EUR short **SOTTO** (aff. C); **D30EUR long (OPPRANGE): MISTA** (OOS 0,997-1,372, celle sopra con n IS 44-58 e OOS 71-88: aff. C o D).
- **Caselle**: NASUSD (SOTTO): (3) uscita: buffer dello stop (OPPRANGE) ad asse, BE / `AtrSLmult` mai; (4) gemelli: D30EUR (long e short), NASUSD provati qui; (5) TF: `InpExecTF` M5 in tutti i round: **non chiusa**.
- **Cambia?** Si' (sez. 6 V5): "R125 mai girato" e la riga "D30EUR (R11) SOTTO 0,94-1,02" vanno aggiornate; il resto (NASUSD e short SOTTO, sedia SOPRA C) e' confermato.

### 4.9 `ABTG_MaxMinNotte` (generico) - 3 round, 6 CSV (`r133c`, `r151a`, `r170b`)
- **`r133c`** D30EUR M15, `[T]`, 10k, 1%, **solo short, filtro S&P spento**, `InpMinBoxPts` 0-12000: ancora **1,997 / 38 / 4,89 -> 1,016 / 65 / 9,05**; salendo l'IS arriva a 9,414 (su 13 deal) mentre l'OOS scende a 0,197 (su 17): **5 celle IS sopra -> OOS sotto**; OOS sopra 1 su 4 celle (0, 1500, 4500, 6000). G3 non cita il round.
- **`r151a`** (oro H2, `[B]`, 100k, 0,5%, 2020.01.01-2026.06.30, IS ..2022.08.06 / OOS 2022.08.07..): TrailAtrMult 0,8-3,2: IS 0,935-1,135 (n 237-275), **OOS 1,438-1,661** (n 401-444), DD OOS 2,35-5,59; ancora 2,0: **1,108 / 265 / 5,27 -> 1,438 / 428 / 5,30**; 0,8: IS 0,935 -> OOS 1,661 (DD 2,35).
- **`r170b`** (stessa geometria, CloseAtEnd): CloseAtEnd 1 = ancora di `r151a`; **CloseAtEnd 0: IS 1,091 / 332 -> OOS 1,091 / 493 (DD 5,76)**: l'OOS dell'ancora (1,438) dipende dal flat a fine finestra.
- **Lettura**: 265 + 428 = **693 deal = n della riga 1a di G3**: la stessa corsa, ora con lo split. Resta `[B]` (screening). DD `[B]` al 0,5%: limite inferiore, non dice NON VIOLATO.
- **Cambia?** Si' (sez. 6 V7): G3 1a e' "NM per piano 5.3 (screening [B] senza OOS)": con lo split la premessa "senza OOS" cade; per il piano §5.2.3 diventa screening classificato SOPRA (OOS 1,438), non promozione.

### 4.10 `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` - sedia 770411 - 1 round, 2 CSV (`r170c`)
- D30EUR M15 short con filtro S&P, `[T]`, 100k, 1%. **IS 1,878 / 20 / 3,10 -> OOS 2,160 / 21 / 1,92**, identico al contratto (`CONTRATTI_DELLE_SEDIE_FTMO` §4: n 20 / 21 deal, 14 posizioni, DD 3,0977 / 1,9213) e a G3 sc.4.2; **CloseAtEnd 0 e 1 identiche in IS e OOS** (manopola inerte su questa sedia).
- Classe: **SOPRA**, aff. **D** (21 deal; 14 posizioni nel contratto). Frequenza: 14 / 276 = 0,051 (contratto). Nessun verdetto cambia.

### 4.11 `ABTG_SupRev_DOW_H1_Ottimizzato` - 970916 (spenta) - 5 round, 10 CSV (`R123a-d`, `r132c`)
- U30USD H1, `[T]`, **10k** (dichiarato nel commento delle prove R123: G5 lo dava "non dichiarato"; stima dal CSV 10.046-11.051), 1%, finestre standard.
- **Ancora (cella viva)**: **0,988 / 117 / 6,17 -> 1,389 / 152 / 5,91** (IS sotto -> OOS sopra), riprodotta in 5 round (`r132c`: IS -15,45 contro -15,58, OOS 622,28 contro 622,79; scarto 0,13 / 0,51 EUR come scritto da G5). StMult 2,5-4,5, AtrP 6-12, NearAtr 0,25-2,0.
- Celle (26): IS sopra 1 su 5, OOS sopra 18 su 26; **15 celle IS sotto -> OOS sopra o IS sopra -> OOS sotto**; **cella con IS e OOS sopra: StMult 4,5 (2,017 / 1,418), AtrP 12 (1,177 / 1,359), NearAtr 1,25 (1,005 / 1,322)**; StMult 2,5 e 3,0 e AtrP 6 / 7 / 10 / 11 OOS sotto 1 con n OOS 108-261.
- Tutti i numeri di G5 (D01-D04) coincidono con i CSV: **0 differenze**. G5 D01 scrive "DD 6,3 / 4,8": sono i DD del TF-scan; per R123/r132c il DD OOS e' 5,91.
- **Classe**: cella viva **IS sotto -> OOS sopra** (SEGNO INVERTITO), aff. B o C provvisoria (152 deal). Nessun verdetto cambia.

### 4.12 `ABTG_SupRev_NAS_H1_Ottimizzato` - 970913 - 2 round, 4 CSV (`r127a`, `r163a`)
- NASUSD H1, `[T]`, SLBufferPips ad asse. **`r127a`** (10k, 1%, buffer 3-3003): IS 1,298-1,523 (n 69-71, DD 0,66-0,99) / OOS 1,497-1,721 (n 84-87, DD 0,98-1,31): **9 su 9 sopra in IS e OOS**; ancora 1,298 / 71 -> 1,613 / 87. Coincide con G5 (Y01, Y02).
- **`r163a`** (100k, 1%, buffer 2253-4503): **IS 1,432-1,542 (n 76, DD 0,74-0,81) / OOS 1,485-1,615 (n 96, DD 1,10-1,34): 7 su 7 sopra in IS e OOS**; ancora 2253: 1,540 / 76 / 0,81 -> 1,591 / 96 / 1,34; n invariante. G5 lo dava "scritto/armato, nessun CSV: NM".
- **n dipende dal deposito, sulla stessa cella** (buffer 2253, presente in entrambi i round): 10k `r127a` IS 1,523 / 69 -> OOS 1,640 / 86; 100k `r163a` IS 1,540 / 76 -> OOS 1,591 / 96 (difetto M45 di G5).
- **Classe**: **SOPRA**, aff. **C** (96 deal OOS; posizioni NON LEGGIBILI); un solo regime (21 mesi). `[T]`. Costo 28,7x (G5) NON misurabile dai CSV. Cambia: sez. 6 V6 (R163a da NM a misurato).

### 4.13 `ABTG_Nightly` - 1 round, 2 CSV (`P0_EURCHF`)
- EURCHF M5, `[T]`, 10k [DERIVATO], 1%, solo `InpMagic`: **IS 0,891 / 63 / 11,10 -> OOS 0,814 / 85 / 15,39** (due righe doppie). Coincide con G3 sc.4.5. Finestra 2024.09.26-2026.06.30 (G3 D6: la finestra nativa 1993/1999 non e' usata).
- Classe: **SOTTO**, aff. C; certificato incompleto (uscita mai ad asse: G3). Nessun verdetto cambia.

---

## 5. CONFRONTO CON I RESOCONTI DI GRUPPO

Fonti confrontate: `RESOCONTO_EA_G1_APERTURE`, `..._G2_EMA200_SW_ORB`, `..._G3_NOTTE_EVENTI_BULGE`, `..._G5_SUPERTREND_GOLDEN_ORO`, `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20`, `CENSIMENTO_CONTRATTI_v2`, `IL_TRASPORTO_E_FERMO_2026-09-17`.
**Differenze referto / CSV**: dove un numero e' scritto dal resoconto e il CSV lo contiene, **coincide** nei casi controllati (PF, n, DD al decimale scritto). **Unica divergenza numerica trovata**: GBPUSD H4 `r139b` (G2 §1.1: DD IS 17,7-20,3 e OOS 10,1-11,0; CSV del 05/10: 17,95-20,41 e 10,14-11,25; il CSV del 13/09 coincideva con G2: 17,73-20,32 e 10,05-11,05). Le altre divergenze sono di **stato** (round dati per "mai girati" / "NM" che hanno CSV),
di **etichetta** (OOS che non e' un OOS) e di **omissione** (celle non citate), elencate in 5.f.

### 5.a Celle SOPRA e SOTTO 1 nello stesso round (classe 1127, entrambi i versi)
Round con almeno una cella OOS >= 1 **e** almeno una < 1 (PF OOS a tick; `[B]` = screening):
| round | EA | OOS sopra 1 (valore: PF IS -> PF OOS) | OOS sotto 1 (valore: PF IS -> PF OOS) |
|---|---|---|---|
| `r137b` | DAX_Apertura_EU | 800: 1,126 -> 1,397; 2800: 1,198 -> 1,294; 4800: 1,079 -> 1,294; 6800: 0,900 -> 1,271; 8800: 0,724 -> 1,185 | 10800: 0,670 -> 0,976; 12800: 0,652 -> 0,876 |
| `r172b` | Dow_Apertura_US | 16: 1,044 -> 1,368; 17: 1,223 -> 1,270; 18: 1,112 -> 1,294; 19: 0,955 -> 1,408; 20: 0,987 -> 1,399; 21: 0,933 -> 1,425 | 15: 0,413 -> 0,761 |
| `r172d` | Dow_Apertura_US | 0,00: 1,222 -> 1,270; 0,45: 0,887 -> 1,032; 0,60: 1,198 -> 1,113; 0,75: 1,245 -> 1,219; 0,90: 1,222 -> 1,267 | 0,15: 1,286 -> 0,892; 0,30: 1,182 -> 0,889 |
| `r172f` | Dow_Apertura_US | 2: 0,942 -> 1,064; 3: 0,927 -> 1,069; 4: 1,028 -> 1,237; 5: 1,222 -> 1,270; 6: 1,230 -> 1,230; 10: 1,232 -> 1,268; 12: 1,105 -> 1,148; 15: 1,183 -> 1,177; 20: 1,032 -> 1,110; 30: 0,975 -> 1,039 | 1: 0,752 -> 0,798 |
| `r172i` | Dow_Apertura_US | 0: 1,222 -> 1,270; 500: 1,222 -> 1,270; 1000: 1,222 -> 1,270; 1500: 1,222 -> 1,270; 2000: 1,222 -> 1,270; 2500: 1,222 -> 1,270; 3000: 1,222 -> 1,270; 3500: 1,221 -> 1,268; 4000: 1,218 -> 1,269; 4500: 1,204 -> 1,240; 5000: 1,190 -> 1,208; 5500: 1,090 -> 1,202; 6000: 1,075 -> 1,148; 6500: 1,093 -> 1,142; 7000: 1,078 -> 1,060; 7500: 1,183 -> 1,044; 8000: 1,159 -> 1,010 | 8500: 1,286 -> 0,998; 9000: 1,246 -> 0,984; 9500: 1,178 -> 0,974; 10000: 1,153 -> 0,961; 10500: 1,215 -> 0,952 |
| `r172j` | Dow_Apertura_US | 0: 1,159 -> 1,010 | 1: 1,276 -> 0,927 |
| `r142b` | Nasdaq_Live5m | 2: 1,238 -> 1,070; 3: 1,262 -> 1,010; 4: 1,214 -> 1,001; 5: 1,231 -> 1,047 | 1: 1,015 -> 0,956 |
| `r150a` | Nasdaq_Live5m | 0,5: 1,137 -> 1,000; 3,0: 1,283 -> 1,014 | 0,0: 1,015 -> 0,956; 1,0: 1,124 -> 0,965; 1,5: 1,172 -> 0,912; 2,0: 1,200 -> 0,956; 2,5: 1,256 -> 0,980 |
| `cemad05` | EMA200 | H1: 1,201 -> 1,524; H2: 2,599 -> 1,173; H4: 1,660 -> 1,425 | M15: 0,771 -> 0,954; M20: 1,117 -> 0,833; M30: 1,034 -> 0,907; H3: 2,152 -> 0,908 |
| `r139a` | EMA200 | 1,5: 0,780 -> 1,008 | 2,0: 0,803 -> 0,971; 2,5: 0,803 -> 0,949; 3,0: 0,807 -> 0,956 |
| `r125c` | ORB_Ott | 500: 1,172 -> 1,029; 1000: 1,240 -> 1,116; 1500: 1,308 -> 1,083; 2500: 1,304 -> 1,008; 3000: 1,296 -> 1,038 | 0: 1,130 -> 0,997; 2000: 1,256 -> 0,997 |
| `r125e` | ORB_Ott | 0,15: 1,207 -> 1,152; 0,20: 1,222 -> 1,372 | 0,00: 1,256 -> 0,997; 0,05: 1,256 -> 0,997; 0,10: 1,360 -> 0,999 |
| `r133c` | MaxMinNotte | 0: 1,997 -> 1,016; 1500: 1,997 -> 1,016; 4500: 2,236 -> 1,062; 6000: 2,928 -> 1,006 | 3000: 1,997 -> 0,997; 7500: 5,300 -> 0,916; 9000: 5,578 -> 0,833; 10500: 9,414 -> 0,566; 12000: 6,984 -> 0,197 |
| `R123BSTMULT` | SupRev_DOW_H1_Ott | 3,5: 0,988 -> 1,389; 4,0: 0,721 -> 1,093; 4,5: 2,017 -> 1,418 | 2,5: 0,877 -> 0,914; 3,0: 1,084 -> 0,953 |
| `R123CATRP` | SupRev_DOW_H1_Ott | 8: 0,781 -> 1,164; 9: 0,988 -> 1,389; 12: 1,177 -> 1,359 | 6: 0,556 -> 0,914; 7: 0,851 -> 0,882; 10: 0,888 -> 0,610; 11: 0,836 -> 0,559 |
| `R123DNEARATR` | SupRev_DOW_H1_Ott | 0,75: 0,770 -> 1,284; 1,00: 0,988 -> 1,389; 1,25: 1,005 -> 1,322; 1,50: 0,865 -> 1,322 | 0,50: 0,635 -> 0,992 |
| `r132c` | SupRev_DOW_H1_Ott | 0,25: 0,628 -> 1,076; 0,75: 0,770 -> 1,284; 1,00: 0,988 -> 1,389; 1,25: 1,005 -> 1,322; 1,50: 0,865 -> 1,322; 1,75: 0,719 -> 1,245; 2,00: 0,719 -> 1,245 | 0,50: 0,635 -> 0,991 |

### 5.b Segno invertito IS -> OOS (nei due versi)
Round con celle dove IS e OOS stanno da parti opposte di 1. Il verso "IS sopra, OOS sotto" e' quello che la selezione sull'IS non vede; l'altro ("IS sotto, OOS sopra") e' il regime che cambia, non un'opportunita' (regola S4 di casa: regime, non edge).
| round | EA | IS sopra, OOS sotto (valore: PF IS -> PF OOS) | IS sotto, OOS sopra (valore: PF IS -> PF OOS) |
|---|---|---|---|
| `r137a` | DAX_Apertura_EU | - | 10800: 0,966 -> 1,288; 12800: 0,846 -> 1,284 |
| `r137b` | DAX_Apertura_EU | - | 6800: 0,900 -> 1,271; 8800: 0,724 -> 1,185 |
| `r138a` | DAX_Apertura_EU | cella: 1,440 -> 0,770 | - |
| `r172b` | Dow_Apertura_US | - | 19: 0,955 -> 1,408; 20: 0,987 -> 1,399; 21: 0,933 -> 1,425 |
| `r172d` | Dow_Apertura_US | 0,15: 1,286 -> 0,892; 0,30: 1,182 -> 0,889 | 0,45: 0,887 -> 1,032 |
| `r172f` | Dow_Apertura_US | - | 2: 0,942 -> 1,064; 3: 0,927 -> 1,069; 30: 0,975 -> 1,039 |
| `r172g` | Dow_Apertura_US | - | 0: 0,974 -> 1,467 |
| `r172h` | Dow_Apertura_US | - | 1: 0,789 -> 1,111 |
| `r172i` | Dow_Apertura_US | 8500: 1,286 -> 0,998; 9000: 1,246 -> 0,984; 9500: 1,178 -> 0,974; 10000: 1,153 -> 0,961; 10500: 1,215 -> 0,952 | - |
| `r172j` | Dow_Apertura_US | 1: 1,276 -> 0,927 | - |
| `r170a` | Nasdaq_Apertura_US | 0: 1,316 -> 0,948; 1: 1,257 -> 0,948 | - |
| `r142a` | Nasdaq_Live5m | 0: 1,054 -> 0,964; 25: 1,045 -> 0,970; 50: 1,015 -> 0,956 | - |
| `r142b` | Nasdaq_Live5m | 1: 1,015 -> 0,956 | - |
| `r142c` | Nasdaq_Live5m | 0: 1,322 -> 0,999; 1: 1,015 -> 0,956 | - |
| `r150a` | Nasdaq_Live5m | 0,0: 1,015 -> 0,956; 1,0: 1,124 -> 0,965; 1,5: 1,172 -> 0,912; 2,0: 1,200 -> 0,956; 2,5: 1,256 -> 0,980 | - |
| `cemad05` | EMA200 | M20: 1,117 -> 0,833; M30: 1,034 -> 0,907; H3: 2,152 -> 0,908 | - |
| `r136b` | EMA200 | - | 0,25: 0,994 -> 1,590; 0,75: 0,900 -> 1,436; 1,00: 0,869 -> 1,549; 1,25: 0,837 -> 1,540; 1,50: 0,762 -> 1,587 |
| `r136c` | EMA200 | - | 0: 0,935 -> 1,281 |
| `r139a` | EMA200 | - | 1,5: 0,780 -> 1,008 |
| `r139b` | EMA200 | - | 1,5: 0,802 -> 1,122; 2,0: 0,832 -> 1,136; 2,5: 0,833 -> 1,128; 3,0: 0,835 -> 1,135 |
| `r120b00` | SuperWave_DOW_H1_Ott | - | cella: 0,903 -> 1,187 |
| `r120b01` | SuperWave_DOW_H1_Ott | cella: 1,406 -> 0,983 | - |
| `r120e00` | SuperWave_DOW_H1_Ott | - | cella: 0,978 -> 1,284 |
| `r173c` | SuperWave_DOW_H1_Ott | - | 0: 0,879 -> 1,050 |
| `r126d` | SuperWave | 0,000: 1,126 -> 0,778 | - |
| `r125a` | ORB_Ott | - | 2000: 0,932 -> 1,689; 2500: 0,916 -> 1,738; 3000: 0,934 -> 1,673 |
| `r125c` | ORB_Ott | 0: 1,130 -> 0,997; 2000: 1,256 -> 0,997 | - |
| `r125e` | ORB_Ott | 0,00: 1,256 -> 0,997; 0,05: 1,256 -> 0,997; 0,10: 1,360 -> 0,999 | - |
| `r125f` | ORB_Ott | 0: 1,200 -> 0,864; 500: 1,278 -> 0,863; 1000: 1,382 -> 0,827; 1500: 1,192 -> 0,815; 2000: 1,252 -> 0,791; 2500: 1,372 -> 0,833; 3000: 1,422 -> 0,767 | - |
| `r133b` | ORB_Ott | - | 1: 0,523 -> 1,122 |
| `r133c` | MaxMinNotte | 3000: 1,997 -> 0,997; 7500: 5,300 -> 0,916; 9000: 5,578 -> 0,833; 10500: 9,414 -> 0,566; 12000: 6,984 -> 0,197 | - |
| `r151a` | MaxMinNotte | - | 0,8: 0,935 -> 1,661 |
| `R123AGATE` | SupRev_DOW_H1_Ott | - | cella: 0,988 -> 1,389 |
| `R123BSTMULT` | SupRev_DOW_H1_Ott | 3,0: 1,084 -> 0,953 | 3,5: 0,988 -> 1,389; 4,0: 0,721 -> 1,093 |
| `R123CATRP` | SupRev_DOW_H1_Ott | - | 8: 0,781 -> 1,164; 9: 0,988 -> 1,389 |
| `R123DNEARATR` | SupRev_DOW_H1_Ott | - | 0,75: 0,770 -> 1,284; 1,00: 0,988 -> 1,389; 1,50: 0,865 -> 1,322 |
| `r132c` | SupRev_DOW_H1_Ott | - | 0,25: 0,628 -> 1,076; 0,75: 0,770 -> 1,284; 1,00: 0,988 -> 1,389; 1,50: 0,865 -> 1,322; 1,75: 0,719 -> 1,245; 2,00: 0,719 -> 1,245 |

### 5.c Sedie 770xxx / 771xxx / 970xxx: confronto col contratto, solo dove il dato e' nel CSV
DD = `Equity DD %` al banco del contratto. n dei CSV = deal; frequenza in deal = n OOS / 276 giorni (OOS `walkforward_generico` 2025.06.10-2026.06.30 come da `CONTRATTI_DELLE_SEDIE_FTMO` §1); la frequenza **promessa** e' in posizioni e dai CSV NON e' leggibile.

| sedia | contratto (fonte) | CSV | esito |
|---|---|---|---|
| 770101 long (D30EUR M5) | PF 1,12634 / 1,39709; DD 5,4362 / 7,2328 (100k, 1%); n 175 / 270 deal = 132 / 193 pos; 0,699 op/g (CT §2) | `r137a`, `r137b`, `r137c` (ClosePct 50), `r147c`: identici cifra per cifra; ClosePct 0: 132 / 193 deal | **riproduce, 4 round**; 193 / 276 = 0,699 op/g con ClosePct 0 |
| 770202 long (U30USD M5) | PF 1,22247 / 1,27013; DD 5,6692 / 4,3941; n 74 / 130 deal = 56 / 96 pos; 0,348 op/g (CT §2) | `r172a-i`: identici; `r152a` a 0,65%: DD 3,7120 / 2,8469 | **riproduce, 9 round**; posizioni NON LEGGIBILI; 130 / 276 = 0,471 op/g in deal |
| 771531 (U30USD H1 L+S) | PF 1,20110 / 1,52365; DD 5,7325 / 7,8323; n 237 / 517 deal (257 pos OOS; 132 IS dichiarato); 0,931 op/g (CT §2) | `cemad05`, `r136a-d`, `r146b`, `r147a`: identici; `cemad02` "OOS" = finestra IS (237 deal) | **riproduce, 7 round**; posizioni NON LEGGIBILI; 517 / 276 = 1,873 op/g in deal |
| 770511 (U30USD H1 L+S) | **CONTESO**: 1,84892 / 1,32770 (84 / 143 deal; DD 3,7267 / 3,9082) **oppure** 1,48166 / 1,24312 (72 / 131; DD 4,0393 / 4,1675); 100k DD OOS 4,2149; ~0,294 op/g stimato (CT §2, §5) | 10k: 1,482 / 1,243, 72 / 131, DD 4,04 / 4,17 (`r120b11`, `r126a`, `r126b`); 100k: 1,397 / 1,220, 106 / 184, DD 3,48 / 4,21 (`r120e11`, `r165a`, `r173a/b/c`) | **2 letture su 3 riprodotte**; **1,849 / 1,328 mai**; 131 / 276 = 0,475 e 184 / 276 = 0,667 op/g in deal |
| 770611 (U30USD M5 long) | 100k 1%: PF 1,250 / 1,674, DD 7,89 / 9,76, 71 / 119 pos (R88a, G2); 10k 0,65%: DD 5,6530 / 6,5389, ~0,43 op/g (`CENSIMENTO_CONTRATTI_v2` r.216) | `r125b` e `r133b` (100k): identici a R88a; `r147b` (10k, 0,65%): DD 5,6530 / 6,5389 | **riproduce, 3 round**; 119 deal = 119 pos (TP1Pct 0): 119 / 276 = 0,431 op/g |
| 770411 (D30EUR M15 short + filtro) | PF 1,87803 / 2,15985; DD 3,0977 / 1,9213; n OOS 21 deal = 14 pos (IS in pos NON MISURATO, forbice 9-20); 0,051 op/g (CT §4) | `r170c`: identico, IS 20 deal (estremo alto della forbice) e OOS 21 deal (le due celle CloseAtEnd uguali) | **riproduce, 1 round**; 14 / 276 = 0,051 (pos dal contratto) |
| 770250 (NASUSD M15 gated short) | `REFERTO_SHORTGATE` 30/08: n 104, PF 1,097, DD 4,54, +1951 (finestra piena); G1 14d lo scrive come "OOS" | `r170a`: IS 1,257 / 57 / 4,54, OOS 0,948 / 47 / 3,63; 57 + 47 = 104; PF combinato 1,0996 | **il 1,097 e' la finestra piena**; l'OOS e' 0,948 |
| 770203 Live5m (spenta) | G1 sc.23: IS 1,015 / OOS 0,956, 116 / 175, DD 12,3 / 22,5 a 2% | `r142a-c`, `r150a` (ancora identica in 4 round) | **riproduce** |
| 970913 SupRev NAS H1 | G5 Y01: `R127a` ancora 1,298 / 71 -> 1,613 / 87; contratto "PF 1,57, DD 1,17%, 155 deal" = finestra piena | `r127a`: 1,298 / 71 / 0,99 -> 1,613 / 87 / 1,09; 71 + 87 = 158 | **riproduce R127a**; il contratto (155 deal, finestra piena, binario diverso) non e' confrontabile con uno split |
| 970916 SupRev DOW H1 (spenta) | G5 D01: 0,988 / 1,389 (117 / 152) | `R123a-d`, `r132c` | **riproduce, 5 round** |
| Nightly EURCHF | G3 4.5: 0,891 / 0,814, 63 / 85, DD 11,10 / 15,39 | `P0_EURCHF` | **riproduce** |

**Frequenza promessa contro CSV**: nessuna sedia ha le posizioni nel CSV; per 770101 (ClosePct 0) e 770611 (TP1Pct 0) deal = posizioni e la frequenza torna (0,699; 0,431). Il confronto con la frequenza di campo (forward) e' fuori da questo file (demo solo).

### 5.d Caselle del certificato di morte che i CSV chiudono (indicazione, il certificato lo compila chi tiene il resoconto)
Caselle: (3) uscita ad asse, (4) simboli gemelli, (5) TF. Solo le celle SOTTO o NON MISURATE ne hanno bisogno. "Chiude" = i CSV contengono un asse di quella casella per quella cella; non vuol dire che il certificato sia completo.

| cella SOTTO (o senza OOS) | casella (3) uscita | casella (4) gemelli | casella (5) TF | cosa manca dai CSV |
|---|---|---|---|---|
| Live5m NASUSD M5 due lati (OOS 0,956 / 175) | **ClosePct (`r142a`), TrailTF (`r142b`), trailing on/off (`r142c`), TrailStartR (`r150a`)**: quattro manopole | non nei CSV | non applicabile (G1) | gemelli completi |
| 770250 NASUSD M15 short gated (OOS 0,948 / 47) | solo `CloseAtEnd` (`r170a`, inerte in OOS) | nessuno | nessuno (M15 fisso) | quasi tutto |
| ORB_Ott NASUSD long OPPRANGE (OOS 0,767-0,864, 7 su 7) | buffer dello stop 0-3000 (`r125f`); BE, AtrSLmult, trailing mai | D30EUR long e short, NASUSD (`r125c-f`) | `InpExecTF` M5 in tutti i round: **non chiusa** | TF, BE |
| ORB_Ott D30EUR short (OOS 0,650 / 97) | nessuno (buffer 2000 pinnato) | D30EUR short misurato | non chiusa | uscita, TF |
| DAX_Apertura F40EUR long (OOS 0,770 / 195) | nessun asse su F40EUR (cella unica) | F40EUR long | non applicabile (range su M1) | uscita su F40EUR |
| SuperWave NASUSD H1 (OOS 0,732-0,843, 9 su 9) | buffer dello stop in ATR 0-1,0 (`r126d`); TP1 / BE / trailing no | NASUSD | non chiusa dai CSV | uscita vera, TF |
| SW_DOW `r120b01` (trail OFF, flip ON: OOS 0,983) | e' un braccio del 2x2 R120 | - | - | - |
| SupRev DOW H1 (StMult 2,5 / 3,0, AtrP 6-11, NearAtr 0,5) | assi di ingresso e filtro, non di uscita: **non chiusa** | altri simboli in G5 | TF-scan in G5 | uscita |
| MaxMinNotte D30EUR short senza filtro (`r133c`, OOS ~1,0) | `MinBoxPts` e' un filtro d'ingresso: **non chiusa** | - | `InpMgmtTF` mai ad asse | uscita, TF |
| EMA200 AUDJPY H4 `[B]` (IS 0,780-0,807) | `InpTP_RR` 1,5-3,0 (`r139a`, OHLC) | AUDJPY e GBPUSD (OHLC) | n/a | tick |
| Nightly EURCHF M5 (OOS 0,814 / 85) | mai | solo EURCHF | non applicabile | uscita, gemelli |

Le celle SOPRA (770101, 770202, 771531, 770511, 770611, 770411, 970913) non hanno bisogno del certificato; per loro i CSV chiudono assi d'uscita aggiuntivi (sez. 4).

### 5.e Quali verdetti cambierebbero
Vedi la sezione 6 (V1-V12): sono proposte, non riscritture.

### 5.f Cosa i CSV smentiscono o correggono nei resoconti
1. **G1 sc.10 §3**: "R172a-j sospesi / mai girati (nove assi di gestione, 124 passate)" -> **10 round, 69 celle, 138 passate, CSV in repo**; sette dei dieci (a-e, i, j) erano stampati nei log `CODA_07` del 18-20/09. (G1 sc.10 §5 cita invece "BEatR nessuno batte la viva (R172D)": coerente con `r172d`.)
2. **G1 sc.10 §5**: "TP1_R 1,00 massimo sul bordo dell'asse 0,25-1,00: il bordo non e' un centro" -> con l'asse esteso a 2,0 l'OOS e' 1,270 a 1,0 e **1,252-1,294 da 1,0 a 2,0**: l'ancora e' sulla spalla di un altopiano.
3. **G1 riga 14d (770250)**: "OOS 1,097 su 104, ZONA GRIGIA" -> **1,097 e' la finestra piena**; OOS 0,948 su 47 deal (5.c).
4. **G2 sc.2.2 / §0**: "i 7 file (30 celle / 60 passate) gateati e MAI lanciati (0 CSV con i loro magic)" -> **5 file hanno CSV** (`r155a`, `r165a`, `r173a/b/c`, 21 celle). Il TF M30 (`R190b`) no.
5. **G2 sc.3.2 e §4**: "R125 (66 passate): preparato, mai girato" -> **CSV in repo, 64 righe** (a, b, c, d, e, f). Scarto di 2 righe sul conteggio di G2: causa NON verificata.
6. **G2 sc.2.2**: "il trailing sul Supertrend porta l'edge (spento: IS 1,489 -> 0,903)" -> vale per (trail OFF, flip OFF); con **flip ON e trail OFF l'IS resta 1,406** (e l'OOS e' 0,983). "ExitOnFlip inerte (OOS identico)" vale per l'OOS, **non per l'IS** (1,489 contro 1,482).
7. **G2 sc.2.2 / §0.1**: la cella `r120b01` (OOS 0,983) **non e' elencata** fra le SOTTO; l'EA e' gia' in entrambe le liste (nessun cambio di conteggio per EA, ma una cella SOTTO manca).
8. **G2 sc.3.2**: "D30EUR (R11) 0,94-1,02, DD 17,5-29,7%" -> `r125c` (D30EUR long OPPRANGE): **OOS 0,997-1,116, DD 6,32-9,80**; `r125e` ha celle **IS e OOS sopra 1** con DD OOS 2,31-2,95 (n sottile).
9. **G5 sc.1.6 / D19**: "R163a scritto/armato, nessun CSV: NM" -> **CSV in repo**: 7 su 7 sopra in IS e OOS.
10. **G5 §6 "deposito dei round R123 [NON VERIFICATO]"** -> il commento delle prove R123 dichiara 10.000 e la stima dal CSV da' 10.046-11.051: **10k**.
11. **G5 D01 "DD 6,3 / 4,8"** accanto a "0,988 / 1,389 (R123/r132c)": 6,3 / 4,8 sono i DD del TF-scan; per R123/r132c i DD sono 6,17 (IS) e 5,91 (OOS).
12. **G3 riga 1a (oro 693 deal)**: "(s.OOS)": la stessa corsa e' splittata in `r151a`/`r170b` (265 + 428 = 693): IS 1,108, OOS 1,438 `[B]`. **G3 non cita** `r133c`, `r151a`, `r170b`, `r170c`.
13. **G2 non cita** `r146b`, `r147a` (EMA200), `r154a` (SW U30USD H2 finestra piena). **G1 non cita** `r147c`, `r150a` come misure d'uscita.
14. **Contratto 770511**: la lettura 1,849 / 1,328 non e' riprodotta da nessun CSV (13 round).
15. **`cemad02`**: il CSV `_OOS_` e' in realta' la finestra IS (G2 lo scrive correttamente a §13 come "IS 0 byte"; il nome file induce in errore chi legge `_OOS_`).
16. **`IL_TRASPORTO_E_FERMO`**: elenca `canfrz` fra i round con numeri prodotti; e' una corsa `-SoloControllo` senza CSV per costruzione.
17. **GBPUSD H4 `r139b`**: i DD che G2 scrive (17,7-20,3 IS, 10,1-11,0 OOS) sono quelli del CSV del 13/09; il CSV del 05/10 ha 17,95-20,41 e 10,14-11,25 (screening `[B]`, nessun verdetto cambia).
18. **Ancore che non sono la sedia**: `r125a/c/e/f` (OPPRANGE), `r172j` (MinStopPts 8000), `r137c` (ClosePct 0), `q770be` (ClosePct 0): chi cita "l'ancora di round X" come cella viva sbaglia sedia.

---

## 6. COSA CAMBIEREBBE NEI VERDETTI (proposte; i resoconti NON sono riscritti qui)

Ogni voce e' una **proposta** a chi tiene il resoconto. Dove la scelta tocca taglia, rischio, preset o una sedia in campo e' **decisione di Claudio**.

| # | resoconto / riga | oggi dice | i CSV dicono | proposta |
|---|---|---|---|---|
| V1 | G1 riga 14d, scheda 14 (770250) | SOPRA C, ZONA GRIGIA, "OOS 1,097 su 104" | `r170a`: IS 1,257 / 57 -> OOS **0,948 / 47** (SEGNO INVERTITO); 1,097 = finestra piena | etichettare 1,097 come "finestra piena"; classe lettura **SOTTO, aff. C o D**; sedia ferma dal 25/09: nessuna azione, decisione di Claudio se riaccenderla |
| V2 | G2 sc.2.2 (770511) | CONTESA -> NM; "7 file mai lanciati"; "trailing OFF non va provato" | 2 letture su 3 riproducibili (SOPRA, OOS >= 1,22); 5 file con CSV; cella (0,1) SOTTO; TP1Pct 0/25 e TP1_R 0,5 battono la sedia in IS e OOS; BE spento IS 0,879 | aggiornare "mai lanciati" e la frase sul trailing; aggiungere `r120b01`; la riga resta NM finche' non si riconcilia 1,849; **qualunque modifica della sedia: decisione di Claudio** |
| V3 | G1 sc.10 (770202) | R172a-j "mai girati"; TP1_R "bordo" | 69 celle, ancora = contratto in 9 round; altopiano TP1_R 1,0-2,0; nessuna cella batte l'ancora in IS e OOS salvo TP1_R 1,5 / 1,75 | aggiornare sc.10 §3 e §5; casella (5) del long: `InpTrailTF` misurato; la classe (SOPRA C) non cambia |
| V4 | G2 sc.1.1 (771531) | uscite: TP1Pct, trailing, TP1_ATRmult, SLatr, TF | `r146b` (venerdi') e `r147a` (breakeven) non citati; BE spento: deal +49% OOS a PF invariato | aggiungere i due assi; la leva di frequenza (famiglia EMA200 0,931 contro pavimento 1,00) e' una **decisione di Claudio** |
| V5 | G2 sc.3.2 (ORB_Ott) | "R125 mai girato"; D30EUR (R11) SOTTO 0,94-1,02 | R125: 64 righe; D30EUR long OPPRANGE OOS 0,997-1,116 (DD 6,3-9,8), con MinRangePct 0,15-0,20 IS e OOS sopra (n 58 / 44 IS, 88 / 71 OOS, DD OOS 2,95 / 2,31); NASUSD 7 su 7 IS sopra -> OOS sotto; D30EUR short SOTTO | la riga D30EUR passa da SOTTO a **MISTA (SOPRA C o D)**; NASUSD e short restano SOTTO; sedia invariata |
| V6 | G5 sc.1.6, D19 (970913) | R163a "NM" | 7 su 7 sopra in IS e OOS a 100k (n 76 / 96, DD OOS 1,10-1,34) | R163a da NM a misurato; la cella resta SOPRA C; il costo 28,7x resta NON misurato |
| V7 | G3 riga 1a (oro H2 [B]) | "NM per piano 5.3 (screening senza OOS)" | stessa corsa con split: IS 1,108 / 265, OOS 1,438 / 428 `[B]` | togliere "senza OOS"; per piano §5.2.3: screening classificato **SOPRA (OOS 1,438)**, non promozione |
| V8 | G3 (non cita `r133c`) | - | D30EUR short senza filtro: IS 1,997 / 38 -> OOS 1,016 / 65 (DD 9,05); MinBoxPts peggiora l'OOS (fino a 0,197) | aggiungere la riga (cella ~1, DD OOS 9,05) |
| V9 | G2 sc.2.1 (770531 H2) | IS 5,571 / 32, OOS 1,762 / 88 | `r154a` finestra piena: 2,238-2,565, n 120 = 32+88, 7 lookback | aggiungere `r154a`; nessun cambio di classe (SOPRA C) |
| V10 | G1 sc.1 (F40EUR) | "OOS 0,770 SOTTO" | IS 1,440 / 130 -> OOS 0,770 / 195 (DD 11,82) | scrivere l'IS: **SEGNO INVERTITO** |
| V11 | G1 sc.1 (costo FRAGILE) | "23-44% giornate sotto 40x" | `r137a`: floor 6800 (= 40x secondo la prova) 1,233 / 1,420, n 178 / 272 | citare la misura; se usarla sul preset e' **decisione di Claudio** |
| V12 | G1 sc.23 (Live5m) | tre manopole (r142a-c), nessuna cella a 1,10 | `r150a` quarta manopola: stesso esito (OOS max 1,014) | aggiungere `r150a`; verdetto invariato |

**Nessun EA passa da "non morto" a "morto" e nessun criterio viene toccato.** I conteggi per EA dei gruppi (EA con celle SOPRA / SOTTO) cambiano solo per **ORB_Ott** (la riga D30EUR) se si accetta V5; il resto resta uguale.

---

## 7. [NON COPERTO]

1. **Posizioni**: nessun per-trade nella cartella (il per-trade di `cemad02`, magic 766620/766621, non e' committato). Ogni n e' in **deal**; le lettere B/C sono quindi provvisorie dove il parziale e' acceso (sez. 1.3).
2. **Regime e stagione**: i CSV indici coprono un solo regime (2024.09.26-2026.06.30) e non separano estate / inverno (orologio BCM); orso, laterale, crollo NON LEGGIBILI. Solo `r139a/b` (16,5 anni) e `r151a`/`r170b` (6,5 anni) sono lunghi, e sono `[B]`.
3. **Soglie congelate nei file prova** (ATTESA, SENTINELLE, SOGLIE B0..B9 / S1..S6): **non applicate**. Ho applicato letteralmente una sola regola numerica scritta in un file prova (`r173a` B2: celle sopra il DD 4,2149%), perche' e' un conteggio e non un giudizio. Applicare le altre e' un lavoro a parte.
4. **Referti dei round** (`REFERTO_ROUND_<etichetta>.txt`, nello zip sul Desktop del VPS): non in repo. Il confronto referto/CSV e' stato fatto solo con le tabelle dei log `CODA_07`: possibile per 54 CSV su 134; per 77 NON POSSIBILE (3 vuoti).
5. **Round fuori dal mio perimetro o senza CSV**: `canfrz` (nessun CSV per costruzione); `R190b` (TF M30 della 770511) e gli altri file "mai lanciati" di G2; `r161c` (CSV nel solo ARCHIVIO del Desktop VPS) e i 5 round di G6b (non miei, dichiarati nel commit di trasporto).
6. **Lato short e due lati** su 770101 / 770202 (R54a, R255, R270, R251): non in questa cartella (le prove di `r137`, `r138a`, `r172` sono long-only).
7. **Costo (frontiera 40x), spread, slippage, orologio**: non sono nei CSV.
8. **Binario**: il numero di colonne varia per EA (50-93) ma il CSV non identifica il binario; il confronto binario del contratto 770511 (26/07 contro 19/09) NON LEGGIBILE.
9. **Valuta e profitto assoluto**: il CSV da' `Profit` nella valuta del conto di banco, non dichiarata; i DD sono in % e restano confrontabili.
10. **Famiglie degli altri gruppi** (G4 forex, G6 cacce, G5 oro/GoldenCross): non toccate. Sono lette qui solo SupRev DOW H1 / NAS H1 (cartelle assegnate).

---

## 8. PUNTI DUBBI

1. **Unita' di n**: `Trades` = deal. Le soglie 150 / 346 sono applicate ai deal come nel piano; per le celle con parziale (TP1Pct / ClosePct > 0) la classe puo' essere B o C. Le posizioni dei contratti (193, 96, 257, 14, 119) vengono dai per-trade dei contratti, non da questi CSV.
2. **Ancora non e' sedia**: le colonne "cella di riferimento" dicono quando. Rischio: leggere "l'ancora di `r125c`" come la 770611 (e' OPPRANGE).
3. **Contratto 770511**: due letture riproducibili e una no. Il CSV non dice quale binario ha prodotto 1,849 / 1,328; non lo ricostruisco. Il confronto "TP1Pct 0 = posizioni" non vale (1.5 punto 6).
4. **`r139b` del 05/10 diverso da quello del 13/09** (OHLC, `[B]`): IS 0,802-0,835 contro 0,803-0,838, OOS 1,122-1,136 contro 1,127-1,139, DD OOS max 11,25 contro 11,05; le altre 26 coppie "aggiornate" sono identiche (anche `r139a`, stesso EA e stesso Modello 1). Causa NON isolata (storico M1 aggiornato? binario?): G2 cita "OOS 1,13" (compatibile con entrambe) e i DD del CSV vecchio.
5. **Identificazione di `r170a` con 770250**: dedotta dal titolo della prova ("sedia gated short del Nasdaq", NASUSD M15 solo short, 0,65%, `.set 770250 LIVE` citato nel file) e dalla coincidenza numerica con il `REFERTO_SHORTGATE` (n 104, DD 4,54, profitto 1968,56 contro 1951, PF 1,0996 contro 1,097). Il CSV ha `InpMagic` 787310 (magic di prova), non 770250. La differenza di 17,56 EUR di profitto (0,9%) e' di binario / lotto: non verificata.
6. **Ricostruzione del PF combinato** `GL = Profit / (PF - 1)`, `GP = GL x PF`: esatta per costruzione sulle due gambe, ma assume che il PF del CSV sia a 5 decimali (lo e'); l'errore di arrotondamento sul PF combinato e' < 0,001.
7. **Conteggi "celle"**: contano righe-cella; le ancore si ripetono nei round (riproduzioni), quindi 226 celle OOS sopra 1 non sono 226 configurazioni.
8. **Stesso round rifatto 4-9 notti**: il CSV del repo e' l'ultimo; non so se le esecuzioni precedenti dessero numeri identici (per i 28 CSV riscritti il 05/10: 26 su 28 si').
9. **`Profit` e deposito**: i CSV a 10k e a 100k della stessa cella differiscono in n (131 / 184 sulla 770511; 69 / 76 e 86 / 96 sulla SupRev NAS): il difetto M45 e' presente nei miei dati e non l'ho isolato.
10. **G1 "124 passate" contro 138**: la differenza (14) coincide con `r172f` contato 4 celle invece di 11 `[INFERITO]`.
11. **Stato git "A"**: 28 CSV riscritti il 05/10 dal trasporto; la data nel nome e' quella del commit, non quella della corsa. La data di corsa dei CSV (17-20/09 per i piu') si legge nei log `CODA_07` (colonna ora del Desktop VPS), non nei CSV.

---

## ALLEGATO A - TUTTE LE CELLE (607 righe-cella dopo la deduplica)

Una tabella per round, stesso ordine della sez. 3. `n` = deal; `profit` nella valuta del conto di banco (non dichiarata); `riferimento` = cella di riferimento del round; le note "IS sopra -> OOS sotto" ecc. sono quelle della sez. 5.b.
Le righe doppie per `InpMagic` sono contate una volta; `r154a` e `r155a` hanno solo la gamba "IS" = finestra piena; `cemad02` ha solo il file `_OOS_` (= finestra IS).

**DAX_Apertura_EU / `q770be`** (D30EUR M5, T 100k 1,0%) - asse `InpBEatR`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,0 | 1,183 | 132 | 4,96 | 5569,37 | 1,491 | 193 | 6,27 | 23607,28 | riferimento |
| 0,5 | 1,152 | 132 | 5,06 | 4594,13 | 1,446 | 193 | 6,25 | 19161,41 |  |
| 1,0 | 1,183 | 132 | 4,96 | 5569,37 | 1,457 | 193 | 6,26 | 21163,84 |  |
| 1,5 | 1,183 | 132 | 4,96 | 5569,37 | 1,491 | 193 | 6,27 | 23607,28 |  |

**DAX_Apertura_EU / `r137a`** (D30EUR M5, T 100k 1,0%) - asse `InpMinStopPts`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 800 | 1,126 | 175 | 5,44 | 3789,36 | 1,397 | 270 | 7,23 | 18029,58 | riferimento |
| 2800 | 1,162 | 175 | 4,67 | 4697,13 | 1,396 | 270 | 7,23 | 17966,45 |  |
| 4800 | 1,317 | 178 | 4,73 | 8050,04 | 1,496 | 272 | 7,25 | 20680,57 |  |
| 6800 | 1,233 | 178 | 5,11 | 5365,34 | 1,420 | 272 | 7,25 | 16195,06 |  |
| 8800 | 1,038 | 178 | 5,71 | 851,96 | 1,381 | 273 | 6,32 | 13027,96 |  |
| 10800 | 0,966 | 178 | 5,71 | -692,65 | 1,288 | 273 | 5,69 | 8944,77 | IS sotto -> OOS sopra |
| 12800 | 0,846 | 178 | 6,23 | -3037,92 | 1,284 | 274 | 6,34 | 7807,31 | IS sotto -> OOS sopra |

**DAX_Apertura_EU / `r137b`** (D30EUR M5, T 100k 1,0%) - asse `InpMinStopPts`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 800 | 1,126 | 175 | 5,44 | 3789,36 | 1,397 | 270 | 7,23 | 18029,58 | riferimento |
| 2800 | 1,198 | 162 | 4,50 | 5140,75 | 1,294 | 264 | 7,20 | 12933,72 |  |
| 4800 | 1,079 | 126 | 6,28 | 1548,27 | 1,294 | 209 | 7,21 | 8943,62 |  |
| 6800 | 0,900 | 84 | 7,09 | -1415,31 | 1,271 | 164 | 7,05 | 5799,59 | IS sotto -> OOS sopra |
| 8800 | 0,724 | 43 | 4,17 | -1946,78 | 1,185 | 97 | 6,51 | 2293,96 | IS sotto -> OOS sopra |
| 10800 | 0,670 | 27 | 3,37 | -1334,73 | 0,976 | 65 | 5,60 | -217,53 | IS e OOS sotto |
| 12800 | 0,652 | 15 | 2,46 | -679,75 | 0,876 | 35 | 4,68 | -632,52 | IS e OOS sotto |

**DAX_Apertura_EU / `r137c`** (D30EUR M5, T 100k 1,0%) - asse `InpTP1_ClosePct`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,183 | 132 | 4,96 | 5569,37 | 1,491 | 193 | 6,27 | 23607,28 |  |
| 50 | 1,126 | 175 | 5,44 | 3789,36 | 1,397 | 270 | 7,23 | 18029,58 | riferimento |

**DAX_Apertura_EU / `r138a`** (F40EUR M5, T 100k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 1,440 | 130 | 7,36 | 7126,12 | 0,770 | 195 | 11,82 | -7266,30 | riferimento; IS sopra -> OOS sotto |

**DAX_Apertura_EU / `r147c`** (D30EUR M5, T 100k 1,0%) - asse `InpCloseAtEnd`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,137 | 176 | 5,44 | 4082,90 | 1,417 | 272 | 7,26 | 18889,38 |  |
| 1 | 1,126 | 175 | 5,44 | 3789,36 | 1,397 | 270 | 7,23 | 18029,58 | riferimento |

**Dow_Apertura_US / `r152a`** (U30USD M5, T 100k 0,65%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 1,227 | 74 | 3,71 | 1861,43 | 1,278 | 130 | 2,85 | 4398,20 | riferimento |

**Dow_Apertura_US / `r172a`** (U30USD M5, T 100k 1,0%) - asse `InpTrailStartR`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,00 | 1,222 | 74 | 5,67 | 2811,84 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |
| 0,25 | 1,287 | 79 | 5,68 | 3958,16 | 1,145 | 133 | 5,33 | 4037,50 |  |
| 0,50 | 1,083 | 76 | 5,37 | 1373,53 | 1,019 | 131 | 7,01 | 591,04 |  |
| 0,75 | 1,064 | 74 | 5,61 | 1106,23 | 1,040 | 126 | 6,97 | 1290,57 |  |
| 1,00 | 1,034 | 73 | 5,56 | 602,25 | 1,061 | 123 | 6,88 | 2001,04 |  |
| 1,25 | 1,018 | 73 | 5,56 | 321,18 | 1,044 | 123 | 6,88 | 1444,00 |  |
| 1,50 | 1,035 | 73 | 5,16 | 637,04 | 1,066 | 123 | 6,88 | 2151,67 |  |

**Dow_Apertura_US / `r172b`** (U30USD M5, T 100k 1,0%) - asse `InpCloseHour`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 15 | 0,413 | 29 | 4,82 | -3867,23 | 0,761 | 46 | 3,09 | -1325,66 | IS e OOS sotto |
| 16 | 1,044 | 65 | 5,93 | 581,14 | 1,368 | 121 | 3,11 | 7927,24 |  |
| 17 | 1,223 | 74 | 5,67 | 2812,69 | 1,270 | 130 | 4,39 | 6721,83 | riferimento |
| 18 | 1,112 | 78 | 5,70 | 1576,16 | 1,294 | 141 | 4,29 | 7821,50 |  |
| 19 | 0,955 | 76 | 5,69 | -636,22 | 1,408 | 149 | 4,20 | 10463,88 | IS sotto -> OOS sopra |
| 20 | 0,987 | 79 | 5,70 | -178,09 | 1,399 | 151 | 4,20 | 10357,31 | IS sotto -> OOS sopra |
| 21 | 0,933 | 84 | 5,70 | -999,30 | 1,425 | 157 | 4,20 | 11186,50 | IS sotto -> OOS sopra |

**Dow_Apertura_US / `r172c`** (U30USD M5, T 100k 1,0%) - asse `InpBreakevenAtTP1`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,253 | 74 | 5,67 | 3202,68 | 1,211 | 130 | 4,39 | 5536,41 |  |
| 1 | 1,222 | 74 | 5,67 | 2811,84 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |

**Dow_Apertura_US / `r172d`** (U30USD M5, T 100k 1,0%) - asse `InpBEatR`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,00 | 1,222 | 74 | 5,67 | 2811,84 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |
| 0,15 | 1,286 | 68 | 2,89 | 1420,08 | 0,892 | 115 | 4,82 | -1395,01 | IS sopra -> OOS sotto |
| 0,30 | 1,182 | 71 | 4,41 | 1452,65 | 0,889 | 120 | 5,07 | -1970,96 | IS sopra -> OOS sotto |
| 0,45 | 0,887 | 73 | 5,30 | -1309,96 | 1,032 | 126 | 4,39 | 674,83 | IS sotto -> OOS sopra |
| 0,60 | 1,198 | 75 | 4,53 | 2315,07 | 1,113 | 128 | 4,39 | 2491,07 |  |
| 0,75 | 1,245 | 75 | 4,60 | 2880,32 | 1,219 | 130 | 4,39 | 5159,37 |  |
| 0,90 | 1,222 | 75 | 5,45 | 2805,18 | 1,267 | 130 | 4,39 | 6622,96 |  |

**Dow_Apertura_US / `r172e`** (U30USD M5, T 100k 1,0%) - asse `InpTP1_R`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,50 | 1,058 | 87 | 4,18 | 672,64 | 1,105 | 148 | 4,57 | 2208,17 |  |
| 0,75 | 1,385 | 85 | 4,20 | 4562,85 | 1,139 | 140 | 4,47 | 3235,80 |  |
| 1,00 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |
| 1,25 | 1,285 | 73 | 5,67 | 3620,31 | 1,259 | 126 | 4,17 | 6734,37 |  |
| 1,50 | 1,326 | 69 | 5,68 | 4163,15 | 1,294 | 120 | 4,00 | 7672,15 |  |
| 1,75 | 1,318 | 64 | 5,67 | 4050,57 | 1,285 | 116 | 4,22 | 7795,11 |  |
| 2,00 | 1,326 | 64 | 5,68 | 4163,72 | 1,252 | 113 | 4,33 | 7128,88 |  |

**Dow_Apertura_US / `r172f`** (U30USD M5, T 100k 1,0%) - asse `InpTrailTF`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | 0,752 | 62 | 7,12 | -2833,49 | 0,798 | 109 | 4,99 | -3763,40 | IS e OOS sotto |
| 2 | 0,942 | 67 | 4,48 | -670,63 | 1,064 | 118 | 4,61 | 1311,84 | IS sotto -> OOS sopra |
| 3 | 0,927 | 69 | 5,96 | -972,47 | 1,069 | 123 | 5,15 | 1495,07 | IS sotto -> OOS sopra |
| 4 | 1,028 | 69 | 5,52 | 386,39 | 1,237 | 128 | 4,17 | 5640,53 |  |
| 5 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |
| 6 | 1,230 | 73 | 4,71 | 2869,48 | 1,230 | 128 | 4,98 | 5900,87 |  |
| 10 | 1,232 | 80 | 5,57 | 3329,01 | 1,268 | 134 | 5,53 | 6880,66 |  |
| 12 | 1,105 | 78 | 5,43 | 1644,76 | 1,148 | 135 | 5,66 | 4390,23 |  |
| 15 | 1,183 | 78 | 5,58 | 2692,64 | 1,177 | 139 | 5,57 | 5203,37 |  |
| 20 | 1,032 | 77 | 5,00 | 512,93 | 1,110 | 137 | 5,79 | 3385,44 |  |
| 30 | 0,975 | 78 | 5,27 | -439,92 | 1,039 | 134 | 6,67 | 1238,68 | IS sotto -> OOS sopra |

**Dow_Apertura_US / `r172g`** (U30USD M5, T 100k 1,0%) - asse `InpCloseAtEnd`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 0,974 | 72 | 5,70 | -351,16 | 1,467 | 138 | 3,50 | 11352,57 | IS sotto -> OOS sopra |
| 1 | 1,222 | 74 | 5,67 | 2811,84 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |

**Dow_Apertura_US / `r172h`** (U30USD M5, T 100k 1,0%) - asse `InpSLMode`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,222 | 74 | 5,67 | 2811,84 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |
| 1 | 0,789 | 71 | 10,93 | -5138,39 | 1,111 | 125 | 5,47 | 4368,32 | IS sotto -> OOS sopra |

**Dow_Apertura_US / `r172i`** (U30USD M5, T 100k 1,0%) - asse `InpMinStopPts`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,222 | 74 | 5,67 | 2811,84 | 1,270 | 130 | 4,39 | 6721,93 |  |
| 500 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6721,93 | riferimento |
| 1000 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6721,93 |  |
| 1500 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6721,93 |  |
| 2000 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6721,93 |  |
| 2500 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6721,93 |  |
| 3000 | 1,222 | 74 | 5,67 | 2811,83 | 1,270 | 130 | 4,39 | 6727,01 |  |
| 3500 | 1,221 | 74 | 5,64 | 2794,26 | 1,268 | 130 | 4,39 | 6687,59 |  |
| 4000 | 1,218 | 74 | 5,57 | 2753,28 | 1,269 | 130 | 4,39 | 6691,16 |  |
| 4500 | 1,204 | 74 | 5,53 | 2568,62 | 1,240 | 130 | 4,39 | 5977,46 |  |
| 5000 | 1,190 | 74 | 5,50 | 2411,82 | 1,208 | 130 | 4,39 | 5114,48 |  |
| 5500 | 1,090 | 74 | 5,45 | 1136,95 | 1,202 | 130 | 4,38 | 4976,07 |  |
| 6000 | 1,075 | 74 | 5,45 | 944,12 | 1,148 | 130 | 4,38 | 3619,38 |  |
| 6500 | 1,093 | 74 | 5,40 | 1173,27 | 1,142 | 130 | 4,38 | 3446,49 |  |
| 7000 | 1,078 | 74 | 5,38 | 973,70 | 1,060 | 129 | 4,81 | 1501,14 |  |
| 7500 | 1,183 | 74 | 4,55 | 2136,35 | 1,044 | 129 | 4,79 | 1116,46 |  |
| 8000 | 1,159 | 74 | 4,51 | 1851,17 | 1,010 | 128 | 5,04 | 256,11 |  |
| 8500 | 1,286 | 75 | 3,25 | 3066,63 | 0,998 | 128 | 5,09 | -47,89 | IS sopra -> OOS sotto |
| 9000 | 1,246 | 75 | 3,29 | 2633,48 | 0,984 | 128 | 5,19 | -394,53 | IS sopra -> OOS sotto |
| 9500 | 1,178 | 75 | 3,33 | 1904,59 | 0,974 | 128 | 4,96 | -652,61 | IS sopra -> OOS sotto |
| 10000 | 1,153 | 75 | 3,29 | 1623,78 | 0,961 | 128 | 4,98 | -956,39 | IS sopra -> OOS sotto |
| 10500 | 1,215 | 75 | 3,06 | 2119,30 | 0,952 | 128 | 5,08 | -1190,79 | IS sopra -> OOS sotto |

**Dow_Apertura_US / `r172j`** (U30USD M5, T 100k 1,0%) - asse `InpSkipIfTight`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,159 | 74 | 4,51 | 1851,18 | 1,010 | 128 | 5,04 | 256,11 | riferimento |
| 1 | 1,276 | 46 | 2,43 | 1566,49 | 0,927 | 92 | 5,47 | -1116,91 | IS sopra -> OOS sotto |

**Nasdaq_Apertura_US / `r170a`** (NASUSD M15, T 100k 0,65%) - asse `InpCloseAtEnd`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,316 | 56 | 4,12 | 2933,64 | 0,948 | 47 | 3,63 | -527,34 | IS sopra -> OOS sotto |
| 1 | 1,257 | 57 | 4,54 | 2495,90 | 0,948 | 47 | 3,63 | -527,34 | riferimento; IS sopra -> OOS sotto |

**Nasdaq_Live5m / `r142a`** (NASUSD M5, T 10k 2%) - asse `InpTP1_ClosePct`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,054 | 86 | 15,55 | 373,55 | 0,964 | 131 | 24,28 | -372,20 | IS sopra -> OOS sotto |
| 25 | 1,045 | 116 | 12,91 | 300,46 | 0,970 | 175 | 23,43 | -308,32 | IS sopra -> OOS sotto |
| 50 | 1,015 | 116 | 12,28 | 97,65 | 0,956 | 175 | 22,47 | -447,69 | riferimento; IS sopra -> OOS sotto |
| 75 | 0,988 | 116 | 12,25 | -80,43 | 0,945 | 175 | 21,52 | -565,55 | IS e OOS sotto |

**Nasdaq_Live5m / `r142b`** (NASUSD M5, T 10k 2%) - asse `InpTrailTF`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | 1,015 | 116 | 12,28 | 97,65 | 0,956 | 175 | 22,47 | -447,69 | riferimento; IS sopra -> OOS sotto |
| 2 | 1,238 | 124 | 15,45 | 1779,85 | 1,070 | 185 | 17,62 | 865,64 |  |
| 3 | 1,262 | 122 | 15,50 | 2111,68 | 1,010 | 188 | 25,78 | 127,47 |  |
| 4 | 1,214 | 123 | 15,57 | 1803,45 | 1,001 | 190 | 27,88 | 13,12 |  |
| 5 | 1,231 | 123 | 15,32 | 2001,56 | 1,047 | 194 | 27,07 | 680,27 |  |

**Nasdaq_Live5m / `r142c`** (NASUSD M5, T 10k 2%) - asse `InpUseTrailing`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,322 | 127 | 12,95 | 3200,64 | 0,999 | 195 | 33,62 | -7,75 | IS sopra -> OOS sotto |
| 1 | 1,015 | 116 | 12,28 | 97,65 | 0,956 | 175 | 22,47 | -447,69 | riferimento; IS sopra -> OOS sotto |

**Nasdaq_Live5m / `r150a`** (NASUSD M5, T 10k 2%) - asse `InpTrailStartR`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,0 | 1,015 | 116 | 12,28 | 97,65 | 0,956 | 175 | 22,47 | -447,69 | riferimento; IS sopra -> OOS sotto |
| 0,5 | 1,137 | 124 | 13,73 | 1047,80 | 1,000 | 183 | 22,28 | 0,94 |  |
| 1,0 | 1,124 | 127 | 13,39 | 1154,79 | 0,965 | 195 | 28,13 | -505,54 | IS sopra -> OOS sotto |
| 1,5 | 1,172 | 127 | 13,76 | 1608,70 | 0,912 | 195 | 32,82 | -1223,46 | IS sopra -> OOS sotto |
| 2,0 | 1,200 | 127 | 15,00 | 1927,24 | 0,956 | 195 | 33,08 | -638,67 | IS sopra -> OOS sotto |
| 2,5 | 1,256 | 127 | 13,22 | 2507,82 | 0,980 | 195 | 32,92 | -293,96 | IS sopra -> OOS sotto |
| 3,0 | 1,283 | 127 | 13,55 | 2733,20 | 1,014 | 195 | 34,30 | 211,20 |  |

**EMA200 / `cemad02`** (U30USD H1, T 100k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | n/d | n/d | n/d | n/d | 1,201 | 237 | 5,73 | 4585,40 | riferimento |

**EMA200 / `cemad05`** (U30USD H1, T 100k 1,0%) - asse `InpTF`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| M15 | 0,771 | 1168 | 27,77 | -23264,36 | 0,954 | 2020 | 26,34 | -9455,87 | IS e OOS sotto |
| M20 | 1,117 | 918 | 9,13 | 10071,18 | 0,833 | 1642 | 30,71 | -26414,93 | IS sopra -> OOS sotto |
| M30 | 1,034 | 508 | 10,92 | 1845,29 | 0,907 | 1268 | 15,87 | -11403,85 | IS sopra -> OOS sotto |
| H1 | 1,201 | 237 | 5,73 | 4585,40 | 1,524 | 517 | 7,83 | 23321,47 | riferimento |
| H2 | 2,599 | 127 | 2,42 | 14274,61 | 1,173 | 266 | 6,12 | 4094,51 |  |
| H3 | 2,152 | 36 | 2,18 | 4111,89 | 0,908 | 170 | 9,00 | -1518,71 | IS sopra -> OOS sotto |
| H4 | 1,660 | 26 | 2,37 | 1698,05 | 1,425 | 116 | 4,45 | 4604,21 |  |

**EMA200 / `r136a`** (U30USD H1, T 100k 1,0%) - asse `InpSLatr`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,4 | 1,073 | 209 | 5,54 | 2505,32 | 1,264 | 473 | 9,96 | 18218,34 |  |
| 0,6 | 1,145 | 217 | 5,51 | 4309,12 | 1,521 | 494 | 7,15 | 29687,68 |  |
| 0,8 | 1,189 | 231 | 5,13 | 4819,42 | 1,612 | 506 | 8,19 | 31817,40 |  |
| 1,0 | 1,201 | 237 | 5,73 | 4585,40 | 1,524 | 517 | 7,83 | 23321,47 | riferimento |
| 1,2 | 1,255 | 247 | 4,73 | 5205,39 | 1,462 | 519 | 5,97 | 18534,01 |  |
| 1,4 | 1,218 | 242 | 4,27 | 4018,76 | 1,595 | 529 | 5,77 | 19607,27 |  |
| 1,6 | 1,072 | 241 | 4,76 | 1302,12 | 1,458 | 527 | 6,25 | 14420,69 |  |

**EMA200 / `r136b`** (U30USD H1, T 100k 1,0%) - asse `InpTP1_ATRmult`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,00 | 1,201 | 237 | 5,73 | 4585,40 | 1,524 | 517 | 7,83 | 23321,47 | riferimento |
| 0,25 | 0,994 | 252 | 3,08 | -73,01 | 1,590 | 495 | 2,10 | 9857,85 | IS sotto -> OOS sopra |
| 0,50 | 1,014 | 221 | 3,14 | 238,83 | 1,409 | 453 | 3,21 | 12485,01 |  |
| 0,75 | 0,900 | 191 | 4,91 | -2303,91 | 1,436 | 422 | 7,52 | 17179,38 | IS sotto -> OOS sopra |
| 1,00 | 0,869 | 165 | 5,99 | -3237,19 | 1,549 | 379 | 8,63 | 22471,25 | IS sotto -> OOS sopra |
| 1,25 | 0,837 | 156 | 7,14 | -4286,67 | 1,540 | 363 | 9,46 | 24319,22 | IS sotto -> OOS sopra |
| 1,50 | 0,762 | 147 | 8,90 | -6819,91 | 1,587 | 336 | 9,87 | 27719,21 | IS sotto -> OOS sopra |

**EMA200 / `r136c`** (U30USD H1, T 100k 1,0%) - asse `InpTP1Pct`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 0,935 | 81 | 7,25 | -1766,02 | 1,281 | 165 | 13,94 | 15218,87 | IS sotto -> OOS sopra |
| 25 | 1,200 | 250 | 5,74 | 4563,68 | 1,518 | 602 | 7,87 | 23081,23 |  |
| 50 | 1,201 | 237 | 5,73 | 4585,40 | 1,524 | 517 | 7,83 | 23321,47 | riferimento |
| 75 | 1,200 | 228 | 5,73 | 4577,18 | 1,526 | 471 | 7,82 | 23442,84 |  |

**EMA200 / `r136d`** (U30USD H1, T 100k 1,0%) - asse `InpUseTrailing`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,107 | 194 | 5,50 | 2045,18 | 1,771 | 427 | 7,42 | 28249,94 |  |
| 1 | 1,201 | 237 | 5,73 | 4585,40 | 1,524 | 517 | 7,83 | 23321,47 | riferimento |

**EMA200 / `r146b`** (U30USD H1, T 100k 1,0%) - asse `InpFridayClose`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,201 | 237 | 5,73 | 4585,40 | 1,524 | 517 | 7,83 | 23321,47 | riferimento |
| 1 | 1,213 | 233 | 4,81 | 4664,25 | 1,425 | 503 | 7,84 | 18591,49 |  |

**EMA200 / `r147a`** (U30USD H1, T 100k 1,0%) - asse `InpBreakeven`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,288 | 368 | 5,74 | 4043,98 | 1,528 | 769 | 8,90 | 16188,08 |  |
| 1 | 1,201 | 237 | 5,73 | 4585,40 | 1,524 | 517 | 7,83 | 23321,47 | riferimento |

**EMA200 / `r139a`** (AUDJPY H4, B 10k 1,0%) - asse `InpTP_RR`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1,5 | 0,780 | 757 | 16,94 | -1528,97 | 1,008 | 1322 | 16,89 | 89,17 | riferimento; IS sotto -> OOS sopra |
| 2,0 | 0,803 | 762 | 15,57 | -1384,64 | 0,971 | 1340 | 18,34 | -332,44 | IS e OOS sotto |
| 2,5 | 0,803 | 767 | 15,61 | -1388,56 | 0,949 | 1344 | 20,44 | -574,15 | IS e OOS sotto |
| 3,0 | 0,807 | 768 | 15,35 | -1362,92 | 0,956 | 1345 | 20,00 | -497,21 | IS e OOS sotto |

**EMA200 / `r139b`** (GBPUSD H4, B 10k 1,0%) - asse `InpTP_RR`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1,5 | 0,802 | 856 | 20,41 | -1694,99 | 1,122 | 1292 | 10,65 | 1344,55 | riferimento; IS sotto -> OOS sopra |
| 2,0 | 0,832 | 870 | 18,56 | -1461,46 | 1,136 | 1316 | 10,14 | 1497,63 | IS sotto -> OOS sopra |
| 2,5 | 0,833 | 874 | 18,32 | -1451,91 | 1,128 | 1321 | 11,25 | 1399,17 | IS sotto -> OOS sopra |
| 3,0 | 0,835 | 875 | 17,95 | -1428,94 | 1,135 | 1321 | 11,06 | 1482,39 | IS sotto -> OOS sopra |

**SuperWave_DOW_H1_Ott / `r120b00`** (U30USD H1, T 10k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 0,903 | 46 | 6,04 | -115,71 | 1,187 | 90 | 6,23 | 273,91 | riferimento; IS sotto -> OOS sopra |

**SuperWave_DOW_H1_Ott / `r120b01`** (U30USD H1, T 10k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 1,406 | 71 | 4,45 | 518,22 | 0,983 | 125 | 5,11 | -30,48 | riferimento; IS sopra -> OOS sotto |

**SuperWave_DOW_H1_Ott / `r120b10`** (U30USD H1, T 10k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 1,489 | 72 | 3,80 | 493,73 | 1,243 | 131 | 4,17 | 344,12 | riferimento |

**SuperWave_DOW_H1_Ott / `r120b11`** (U30USD H1, T 10k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 1,482 | 72 | 4,04 | 488,63 | 1,243 | 131 | 4,17 | 344,12 | riferimento |

**SuperWave_DOW_H1_Ott / `r120e00`** (U30USD H1, T 100k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 0,978 | 74 | 5,07 | -278,47 | 1,284 | 130 | 6,53 | 4950,89 | riferimento; IS sotto -> OOS sopra |

**SuperWave_DOW_H1_Ott / `r120e11`** (U30USD H1, T 100k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 1,397 | 106 | 3,48 | 4236,16 | 1,220 | 184 | 4,21 | 3454,83 | riferimento |

**SuperWave_DOW_H1_Ott / `r126a`** (U30USD H1, T 10k 1,0%) - asse `InpSLBufferAtr`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,000 | 1,482 | 72 | 4,04 | 488,63 | 1,243 | 131 | 4,17 | 344,12 | riferimento |
| 0,125 | 1,558 | 72 | 3,59 | 538,48 | 1,276 | 128 | 3,67 | 366,01 |  |
| 0,250 | 1,626 | 70 | 3,58 | 571,81 | 1,234 | 125 | 4,36 | 294,48 |  |
| 0,375 | 1,682 | 68 | 3,59 | 607,78 | 1,307 | 124 | 4,25 | 366,76 |  |
| 0,500 | 1,738 | 68 | 3,26 | 631,28 | 1,402 | 124 | 4,03 | 445,58 |  |
| 0,625 | 1,879 | 67 | 3,23 | 702,04 | 1,306 | 120 | 3,99 | 329,26 |  |
| 0,750 | 1,704 | 66 | 3,28 | 556,10 | 1,322 | 120 | 3,79 | 339,45 |  |
| 0,875 | 1,817 | 64 | 2,57 | 605,91 | 1,247 | 116 | 3,35 | 244,97 |  |
| 1,000 | 1,804 | 63 | 2,37 | 596,38 | 1,282 | 115 | 3,15 | 270,93 |  |

**SuperWave_DOW_H1_Ott / `r126b`** (U30USD H1, T 10k 1,0%) - asse `InpSLLookback`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | 1,369 | 76 | 4,13 | 415,81 | 1,301 | 139 | 4,25 | 464,47 |  |
| 3 | 1,606 | 76 | 3,91 | 652,41 | 1,299 | 137 | 4,58 | 457,44 |  |
| 5 | 1,482 | 72 | 4,04 | 488,63 | 1,243 | 131 | 4,17 | 344,12 | riferimento |
| 7 | 1,511 | 68 | 3,66 | 496,02 | 1,247 | 128 | 3,98 | 334,89 |  |
| 9 | 1,591 | 68 | 3,44 | 544,84 | 1,305 | 124 | 3,55 | 391,22 |  |
| 11 | 1,638 | 68 | 3,43 | 571,51 | 1,135 | 119 | 3,98 | 171,45 |  |
| 13 | 1,538 | 66 | 2,81 | 434,45 | 1,196 | 115 | 3,98 | 230,03 |  |

**SuperWave_DOW_H1_Ott / `r155a`** (U30USD H1, T 10k 1,0%) - asse `InpTP_RR`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 2,0 | 1,263 | 203 | 4,45 | 638,05 | n/d | n/d | n/d | n/d |  |
| 2,5 | 1,324 | 203 | 4,41 | 791,42 | n/d | n/d | n/d | n/d |  |
| 3,0 | 1,331 | 204 | 4,64 | 832,07 | n/d | n/d | n/d | n/d | riferimento |
| 3,5 | 1,344 | 205 | 4,88 | 862,31 | n/d | n/d | n/d | n/d |  |
| 4,0 | 1,341 | 204 | 4,88 | 856,39 | n/d | n/d | n/d | n/d |  |

**SuperWave_DOW_H1_Ott / `r165a`** (U30USD H1, T 100k 1,0%) - asse `InpSLBufferPips`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 3 | 1,397 | 106 | 3,48 | 4236,16 | 1,220 | 184 | 4,21 | 3454,83 | riferimento |
| 1003 | 1,405 | 106 | 3,42 | 4136,66 | 1,254 | 184 | 4,06 | 3815,55 |  |
| 2003 | 1,373 | 106 | 3,34 | 3665,83 | 1,209 | 184 | 4,48 | 2998,47 |  |
| 3003 | 1,378 | 106 | 3,19 | 3589,97 | 1,222 | 184 | 4,29 | 3045,31 |  |
| 4003 | 1,398 | 106 | 3,03 | 3652,78 | 1,247 | 184 | 4,16 | 3279,99 |  |
| 5003 | 1,419 | 106 | 2,97 | 3729,39 | 1,258 | 184 | 4,02 | 3314,02 |  |

**SuperWave_DOW_H1_Ott / `r173a`** (U30USD H1, T 100k 1,0%) - asse `InpTP1Pct`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,674 | 72 | 4,98 | 8224,94 | 1,455 | 116 | 4,64 | 7541,09 |  |
| 25 | 1,653 | 105 | 4,08 | 7098,04 | 1,318 | 184 | 4,43 | 5035,45 |  |
| 50 | 1,397 | 106 | 3,48 | 4236,16 | 1,220 | 184 | 4,21 | 3454,83 | riferimento |
| 75 | 1,106 | 106 | 3,27 | 1106,73 | 1,140 | 184 | 4,02 | 2181,28 |  |

**SuperWave_DOW_H1_Ott / `r173b`** (U30USD H1, T 100k 1,0%) - asse `InpTP1_R`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,5 | 1,569 | 114 | 3,69 | 4584,50 | 1,928 | 208 | 3,56 | 8525,57 |  |
| 1,0 | 1,397 | 106 | 3,48 | 4236,16 | 1,220 | 184 | 4,21 | 3454,83 | riferimento |
| 1,5 | 1,309 | 102 | 3,76 | 3518,05 | 1,323 | 182 | 4,14 | 5154,88 |  |
| 2,0 | 1,342 | 102 | 3,81 | 3920,79 | 1,366 | 180 | 4,10 | 5943,72 |  |

**SuperWave_DOW_H1_Ott / `r173c`** (U30USD H1, T 100k 1,0%) - asse `InpBreakeven`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 0,879 | 207 | 3,96 | -1251,47 | 1,050 | 418 | 4,06 | 773,35 | IS sotto -> OOS sopra |
| 1 | 1,397 | 106 | 3,48 | 4236,16 | 1,220 | 184 | 4,21 | 3454,83 | riferimento |

**SuperWave / `r126d`** (NASUSD H1, T 10k 1,0%) - asse `InpSLBufferAtr`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,000 | 1,126 | 38 | 1,72 | 29,62 | 0,778 | 63 | 3,09 | -114,66 | riferimento; IS sopra -> OOS sotto |
| 0,125 | 0,982 | 37 | 1,72 | -4,36 | 0,759 | 62 | 3,08 | -117,65 | IS e OOS sotto |
| 0,250 | 0,995 | 37 | 1,72 | -1,28 | 0,732 | 60 | 3,25 | -130,63 | IS e OOS sotto |
| 0,375 | 0,946 | 35 | 1,72 | -12,08 | 0,750 | 60 | 3,17 | -120,05 | IS e OOS sotto |
| 0,500 | 0,963 | 35 | 1,72 | -8,45 | 0,790 | 60 | 2,97 | -96,73 | IS e OOS sotto |
| 0,625 | 0,981 | 35 | 1,72 | -4,32 | 0,782 | 59 | 2,93 | -99,57 | IS e OOS sotto |
| 0,750 | 0,863 | 35 | 1,73 | -30,78 | 0,809 | 58 | 2,80 | -83,74 | IS e OOS sotto |
| 0,875 | 0,708 | 35 | 1,73 | -65,81 | 0,836 | 58 | 2,71 | -70,34 | IS e OOS sotto |
| 1,000 | 0,708 | 35 | 1,73 | -65,81 | 0,843 | 58 | 2,71 | -67,12 | IS e OOS sotto |

**SuperWave / `r154a`** (U30USD H4, T 100k 1,0%) - asse `InpSLLookback`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | 2,565 | 120 | 4,29 | 11302,65 | n/d | n/d | n/d | n/d |  |
| 3 | 2,435 | 120 | 4,27 | 10266,80 | n/d | n/d | n/d | n/d |  |
| 5 | 2,407 | 120 | 4,24 | 10063,89 | n/d | n/d | n/d | n/d | riferimento |
| 7 | 2,275 | 120 | 4,19 | 8973,53 | n/d | n/d | n/d | n/d |  |
| 9 | 2,238 | 120 | 4,15 | 8609,35 | n/d | n/d | n/d | n/d |  |
| 11 | 2,418 | 120 | 3,72 | 8734,22 | n/d | n/d | n/d | n/d |  |
| 13 | 2,379 | 120 | 3,60 | 8230,81 | n/d | n/d | n/d | n/d |  |

**ORB_Ott / `r125a`** (U30USD M5, T 100k 1,0%) - asse `InpSLBufferPts`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,061 | 71 | 4,43 | 1215,02 | 1,762 | 119 | 4,20 | 21942,40 | riferimento |
| 500 | 1,063 | 71 | 4,78 | 1190,21 | 1,839 | 119 | 3,84 | 23003,35 |  |
| 1000 | 1,006 | 71 | 4,57 | 98,32 | 1,645 | 119 | 4,40 | 16850,58 |  |
| 1500 | 1,032 | 71 | 3,99 | 534,65 | 1,659 | 119 | 4,18 | 16448,63 |  |
| 2000 | 0,932 | 71 | 5,57 | -1110,47 | 1,689 | 119 | 4,38 | 16523,85 | IS sotto -> OOS sopra |
| 2500 | 0,916 | 71 | 5,47 | -1306,46 | 1,738 | 119 | 4,11 | 17081,85 | IS sotto -> OOS sopra |
| 3000 | 0,934 | 71 | 5,15 | -992,26 | 1,673 | 119 | 3,91 | 14936,14 | IS sotto -> OOS sopra |

**ORB_Ott / `r125b`** (U30USD M5, T 100k 1,0%) - asse `InpTP1Pct`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,250 | 71 | 7,89 | 9509,39 | 1,674 | 119 | 9,76 | 41057,00 | riferimento |
| 25 | 1,175 | 107 | 4,98 | 5876,40 | 1,488 | 188 | 10,58 | 23369,09 |  |
| 50 | 1,106 | 107 | 4,86 | 3446,54 | 1,411 | 188 | 10,00 | 19226,64 |  |
| 75 | 1,034 | 107 | 4,74 | 1054,50 | 1,332 | 188 | 9,89 | 15134,51 |  |

**ORB_Ott / `r125c`** (D30EUR M5, T 100k 1,0%) - asse `InpSLBufferPts`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,130 | 84 | 5,93 | 2409,49 | 0,997 | 128 | 9,80 | -106,31 | riferimento; IS sopra -> OOS sotto |
| 500 | 1,172 | 84 | 4,65 | 2708,62 | 1,029 | 128 | 9,26 | 842,17 |  |
| 1000 | 1,240 | 84 | 4,16 | 3466,62 | 1,116 | 128 | 8,21 | 3093,62 |  |
| 1500 | 1,308 | 84 | 3,77 | 4124,16 | 1,083 | 128 | 8,22 | 2052,24 |  |
| 2000 | 1,256 | 84 | 4,01 | 3186,22 | 0,997 | 128 | 7,49 | -80,03 | IS sopra -> OOS sotto |
| 2500 | 1,304 | 84 | 3,71 | 3537,63 | 1,008 | 128 | 6,86 | 175,81 |  |
| 3000 | 1,296 | 84 | 3,47 | 3232,34 | 1,038 | 128 | 6,32 | 802,79 |  |

**ORB_Ott / `r125d`** (D30EUR M5, T 100k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 0,858 | 56 | 6,08 | -1778,44 | 0,650 | 97 | 8,88 | -6461,73 | riferimento; IS e OOS sotto |

**ORB_Ott / `r125e`** (D30EUR M5, T 100k 1,0%) - asse `InpMinRangePct`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,00 | 1,256 | 84 | 4,01 | 3186,22 | 0,997 | 128 | 7,49 | -80,03 | riferimento; IS sopra -> OOS sotto |
| 0,05 | 1,256 | 84 | 4,01 | 3186,22 | 0,997 | 128 | 7,49 | -80,03 | IS sopra -> OOS sotto |
| 0,10 | 1,360 | 72 | 3,02 | 3709,14 | 0,999 | 118 | 7,68 | -22,05 | IS sopra -> OOS sotto |
| 0,15 | 1,207 | 58 | 3,45 | 1804,55 | 1,152 | 88 | 2,95 | 2303,91 |  |
| 0,20 | 1,222 | 44 | 3,17 | 1503,49 | 1,372 | 71 | 2,31 | 4147,54 |  |

**ORB_Ott / `r125f`** (NASUSD M5, T 100k 1,0%) - asse `InpSLBufferPts`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,200 | 74 | 6,67 | 3855,82 | 0,864 | 135 | 8,01 | -4643,60 | riferimento; IS sopra -> OOS sotto |
| 500 | 1,278 | 74 | 6,20 | 4986,78 | 0,863 | 135 | 8,20 | -4389,46 | IS sopra -> OOS sotto |
| 1000 | 1,382 | 74 | 5,82 | 6205,17 | 0,827 | 135 | 8,75 | -5240,29 | IS sopra -> OOS sotto |
| 1500 | 1,192 | 74 | 5,55 | 2909,46 | 0,815 | 135 | 8,19 | -5345,97 | IS sopra -> OOS sotto |
| 2000 | 1,252 | 74 | 5,22 | 3574,41 | 0,791 | 135 | 8,33 | -5752,23 | IS sopra -> OOS sotto |
| 2500 | 1,372 | 74 | 4,99 | 4738,90 | 0,833 | 135 | 6,89 | -4285,97 | IS sopra -> OOS sotto |
| 3000 | 1,422 | 74 | 4,79 | 5103,33 | 0,767 | 135 | 8,04 | -5672,68 | IS sopra -> OOS sotto |

**ORB_Ott / `r133b`** (U30USD M5, T 100k 1%) - asse `InpUseCloseConfirm`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,250 | 71 | 7,89 | 9509,39 | 1,674 | 119 | 9,76 | 41057,00 | riferimento |
| 1 | 0,523 | 80 | 27,21 | -24193,13 | 1,122 | 136 | 11,96 | 9626,26 | IS sotto -> OOS sopra |

**ORB_Ott / `r147b`** (U30USD M5, T 10k 0,65%) - asse `InpCloseAtEnd`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,232 | 71 | 5,66 | 571,45 | 1,675 | 119 | 6,54 | 2484,17 |  |
| 1 | 1,231 | 71 | 5,65 | 569,12 | 1,675 | 119 | 6,54 | 2484,17 | riferimento |

**MaxMinNotte / `r133c`** (D30EUR M15, T 10k 1%) - asse `InpMinBoxPts`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,997 | 38 | 4,89 | 945,18 | 1,016 | 65 | 9,05 | 36,07 | riferimento |
| 1500 | 1,997 | 38 | 4,89 | 945,18 | 1,016 | 65 | 9,05 | 36,07 |  |
| 3000 | 1,997 | 38 | 4,89 | 945,18 | 0,997 | 63 | 9,06 | -7,26 | IS sopra -> OOS sotto |
| 4500 | 2,236 | 37 | 3,92 | 1054,43 | 1,062 | 59 | 8,21 | 129,78 |  |
| 6000 | 2,928 | 34 | 2,09 | 1245,64 | 1,006 | 50 | 8,14 | 11,63 |  |
| 7500 | 5,300 | 25 | 1,77 | 1368,19 | 0,916 | 42 | 8,13 | -137,03 | IS sopra -> OOS sotto |
| 9000 | 5,578 | 16 | 1,73 | 975,73 | 0,833 | 35 | 8,73 | -252,73 | IS sopra -> OOS sotto |
| 10500 | 9,414 | 13 | 1,76 | 873,86 | 0,566 | 24 | 8,02 | -506,99 | IS sopra -> OOS sotto |
| 12000 | 6,984 | 10 | 1,76 | 621,47 | 0,197 | 17 | 8,77 | -843,39 | IS sopra -> OOS sotto |

**MaxMinNotte / `r151a`** (XAUUSD H2, B 100k 0,5%) - asse `InpTrailAtrMult`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,8 | 0,935 | 237 | 5,24 | -1621,49 | 1,661 | 401 | 2,35 | 20874,76 | IS sotto -> OOS sopra |
| 1,2 | 1,075 | 271 | 3,08 | 2168,00 | 1,523 | 438 | 4,72 | 22164,25 |  |
| 1,6 | 1,090 | 275 | 4,55 | 2798,62 | 1,449 | 444 | 5,59 | 20553,05 |  |
| 2,0 | 1,108 | 265 | 5,27 | 3458,79 | 1,438 | 428 | 5,30 | 20430,81 | riferimento |
| 2,4 | 1,132 | 260 | 5,30 | 4237,80 | 1,473 | 421 | 4,90 | 22310,28 |  |
| 2,8 | 1,135 | 260 | 5,20 | 4361,92 | 1,475 | 418 | 4,92 | 22429,03 |  |
| 3,2 | 1,109 | 259 | 5,89 | 3568,25 | 1,470 | 418 | 4,92 | 22222,29 |  |

**MaxMinNotte / `r170b`** (XAUUSD H2, B 100k 0,5%) - asse `InpCloseAtEnd`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,091 | 332 | 4,69 | 3451,95 | 1,091 | 493 | 5,76 | 5040,56 |  |
| 1 | 1,108 | 265 | 5,27 | 3458,79 | 1,438 | 428 | 5,30 | 20430,81 | riferimento |

**MaxMinNotte_DAX_Short_Ott / `r170c`** (D30EUR M15, T 100k 1,0%) - asse `InpCloseAtEnd`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0 | 1,878 | 20 | 3,10 | 4766,96 | 2,160 | 21 | 1,92 | 6143,38 |  |
| 1 | 1,878 | 20 | 3,10 | 4766,96 | 2,160 | 21 | 1,92 | 6143,38 | riferimento |

**SupRev_DOW_H1_Ott / `R123AGATE`** (U30USD H1, T 10k 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 0,988 | 117 | 6,17 | -15,58 | 1,389 | 152 | 5,91 | 622,79 | riferimento; IS sotto -> OOS sopra |

**SupRev_DOW_H1_Ott / `R123BSTMULT`** (U30USD H1, T 10k 1,0%) - asse `InpStMult`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 2,5 | 0,877 | 180 | 8,88 | -250,84 | 0,914 | 261 | 10,23 | -227,96 | IS e OOS sotto |
| 3,0 | 1,084 | 144 | 2,94 | 108,26 | 0,953 | 200 | 12,36 | -123,22 | IS sopra -> OOS sotto |
| 3,5 | 0,988 | 117 | 6,17 | -15,58 | 1,389 | 152 | 5,91 | 622,79 | riferimento; IS sotto -> OOS sopra |
| 4,0 | 0,721 | 100 | 8,41 | -352,95 | 1,093 | 112 | 3,61 | 101,40 | IS sotto -> OOS sopra |
| 4,5 | 2,017 | 97 | 3,75 | 1036,97 | 1,418 | 117 | 5,70 | 668,49 |  |

**SupRev_DOW_H1_Ott / `R123CATRP`** (U30USD H1, T 10k 1,0%) - asse `InpStAtrPeriod`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 6 | 0,556 | 104 | 8,13 | -563,84 | 0,914 | 202 | 8,97 | -222,20 | IS e OOS sotto |
| 7 | 0,851 | 117 | 5,10 | -161,18 | 0,882 | 165 | 6,34 | -253,27 | IS e OOS sotto |
| 8 | 0,781 | 136 | 9,11 | -322,04 | 1,164 | 179 | 6,73 | 338,71 | IS sotto -> OOS sopra |
| 9 | 0,988 | 117 | 6,17 | -15,58 | 1,389 | 152 | 5,91 | 622,79 | riferimento; IS sotto -> OOS sopra |
| 10 | 0,888 | 111 | 7,06 | -143,20 | 0,610 | 128 | 8,66 | -585,58 | IS e OOS sotto |
| 11 | 0,836 | 129 | 6,08 | -215,76 | 0,559 | 108 | 9,23 | -687,38 | IS e OOS sotto |
| 12 | 1,177 | 106 | 4,93 | 213,62 | 1,359 | 133 | 2,84 | 481,54 |  |

**SupRev_DOW_H1_Ott / `R123DNEARATR`** (U30USD H1, T 10k 1,0%) - asse `InpNearAtr`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,50 | 0,635 | 64 | 4,59 | -315,18 | 0,992 | 122 | 6,21 | -12,28 | IS e OOS sotto |
| 0,75 | 0,770 | 99 | 6,25 | -284,14 | 1,284 | 133 | 6,21 | 423,33 | IS sotto -> OOS sopra |
| 1,00 | 0,988 | 117 | 6,17 | -15,58 | 1,389 | 152 | 5,91 | 622,79 | riferimento; IS sotto -> OOS sopra |
| 1,25 | 1,005 | 122 | 5,95 | 6,74 | 1,322 | 172 | 6,40 | 643,57 |  |
| 1,50 | 0,865 | 128 | 7,17 | -220,72 | 1,322 | 172 | 6,40 | 643,57 | IS sotto -> OOS sopra |

**SupRev_DOW_H1_Ott / `r132c`** (U30USD H1, T 10k 1,0%) - asse `InpNearAtr`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 0,25 | 0,628 | 43 | 4,34 | -263,91 | 1,076 | 80 | 3,77 | 65,74 | IS sotto -> OOS sopra |
| 0,50 | 0,635 | 64 | 4,59 | -314,65 | 0,991 | 122 | 6,21 | -12,79 | IS e OOS sotto |
| 0,75 | 0,770 | 99 | 6,25 | -283,61 | 1,284 | 133 | 6,21 | 422,82 | IS sotto -> OOS sopra |
| 1,00 | 0,988 | 117 | 6,17 | -15,45 | 1,389 | 152 | 5,91 | 622,28 | riferimento; IS sotto -> OOS sopra |
| 1,25 | 1,005 | 122 | 5,95 | 6,74 | 1,322 | 172 | 6,40 | 643,57 |  |
| 1,50 | 0,865 | 128 | 7,17 | -220,72 | 1,322 | 172 | 6,40 | 643,57 | IS sotto -> OOS sopra |
| 1,75 | 0,719 | 132 | 10,21 | -538,14 | 1,245 | 176 | 6,40 | 515,91 | IS sotto -> OOS sopra |
| 2,00 | 0,719 | 132 | 10,21 | -538,14 | 1,245 | 176 | 6,40 | 515,91 | IS sotto -> OOS sopra |

**SupRev_NAS_H1_Ott / `r127a`** (NASUSD H1, T 10k 1,0%) - asse `InpSLBufferPips`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 3 | 1,298 | 71 | 0,99 | 113,13 | 1,613 | 87 | 1,09 | 325,72 | riferimento |
| 378 | 1,402 | 71 | 0,90 | 138,46 | 1,653 | 87 | 0,98 | 331,08 |  |
| 753 | 1,459 | 70 | 0,74 | 152,01 | 1,497 | 86 | 1,22 | 233,05 |  |
| 1128 | 1,467 | 70 | 0,72 | 152,44 | 1,596 | 86 | 1,21 | 261,81 |  |
| 1503 | 1,402 | 69 | 0,72 | 119,30 | 1,721 | 86 | 1,09 | 290,26 |  |
| 1878 | 1,465 | 69 | 0,72 | 135,04 | 1,668 | 86 | 1,31 | 254,31 |  |
| 2253 | 1,523 | 69 | 0,66 | 140,49 | 1,640 | 86 | 1,29 | 236,56 |  |
| 2628 | 1,401 | 69 | 0,66 | 103,78 | 1,599 | 85 | 1,27 | 213,75 |  |
| 3003 | 1,483 | 69 | 0,66 | 120,02 | 1,634 | 84 | 1,22 | 221,50 |  |

**SupRev_NAS_H1_Ott / `r163a`** (NASUSD H1, T 100k 1,0%) - asse `InpSLBufferPips`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 2253 | 1,540 | 76 | 0,81 | 1964,39 | 1,591 | 96 | 1,34 | 2734,64 | riferimento |
| 2628 | 1,479 | 76 | 0,80 | 1691,20 | 1,557 | 96 | 1,31 | 2493,14 |  |
| 3003 | 1,526 | 76 | 0,79 | 1785,73 | 1,600 | 96 | 1,25 | 2568,49 |  |
| 3378 | 1,542 | 76 | 0,77 | 1785,36 | 1,615 | 96 | 1,23 | 2554,36 |  |
| 3753 | 1,498 | 76 | 0,76 | 1590,88 | 1,485 | 96 | 1,19 | 1940,58 |  |
| 4128 | 1,500 | 76 | 0,74 | 1562,58 | 1,511 | 96 | 1,17 | 1995,63 |  |
| 4503 | 1,432 | 76 | 0,79 | 1305,25 | 1,540 | 96 | 1,10 | 2009,05 |  |

**Nightly / `P0_EURCHF`** (EURCHF M5, T? 10k* 1,0%) - asse `InpMagic (cella unica)`; n = deal; DD = Equity DD % del tester

| valore | PF IS | n IS | DD IS | profit IS | PF OOS | n OOS | DD OOS | profit OOS | nota |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| - | 0,891 | 63 | 11,10 | -408,07 | 0,814 | 85 | 15,39 | -956,49 | riferimento; IS e OOS sotto |

---

## CHANGELOG
| data | cosa |
|---|---|
| 05/10/2026 | bozza: 67 round / 134 CSV letti con codice mio; confronto con G1 / G2 / G3 / G5; **NON passata dal cancello** (`controllo-preventivo`, `controlla_riga.py`): niente di questo file esce verso Claudio senza PASS |
