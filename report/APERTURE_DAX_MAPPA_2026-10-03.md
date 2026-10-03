# APERTURE DAX (D30EUR / GER40, BCM): LA MAPPA, IL COSTO, L'OROLOGIO, TRE MISURE (03/10/2026)

**Mandato di Claudio (03/10)**: aperture intraday sul DAX in **breakout E in retest**, **long E short sempre entrambi**, TF **M5 (preferito)**, M15, M30, H1, H4. *"Abbiamo lo storico ampio e i motori."*
Autore: `cercatore-parametri` · **SOLA LETTURA sul repo** (nessun backtest, nessun EA/preset/forward/VPS/conto toccato, nessuna riga di lancio, nessuna taglia) · HEAD di partenza `0205a221`, branch `lavoro`.
Etichette: `[MISURATO]` letto da me su un CSV/referto in questa sessione · `[DERIVATO]` calcolato da numeri scritti · `[INFERITO]` ragionamento, non misura · `[NON MISURATO]` il dato non c'e'.

---

## 0. IN DODICI RIGHE

1. **"Storico ampio": per il DAX NON lo e'.** Il nativo BCM di `D30EUR` parte dal **2024.09.26** (22 mesi; `REFERTO_WALKFORWARD` r.20-27 `[MISURATO]` dalla sonda `SERIES_SERVER_FIRSTDATE`). Il DAX lungo esiste solo fuori: HistData 2010-2018, **1.718.805 barre M1** sane, firmato `D-G/D-H` ma **SOLO_PROVA_REGIME**, **mai importato**, **zero giorni in comune col nativo** (cancello ZERO *inapplicabile*, `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` §0.2). Quindi la **prova di regime sul DAX apertura e' `[NON DISPONIBILE]`** oggi: un regime solo (rialzo, con il crollo di aprile 2025 nell'IS-era). Il tetto delle 100.000 barre **non morde**: la stessa finestra continua (641 giorni M5, ~132.000 barre, `@FRAZIONEIS 0.001`) ha gia' girato sullo stesso simbolo, TF e macchina con un altro EA (R253a/b del 25/09, `MaxBars=100000000`, catena verde, nessun avviso di storico troncato: `RIEPILOGO_R253.txt`); con `ABTG_DAX_Apertura_EU` e' la finestra di R252 (non tornato): `[NON VERIFICATO]` su questo EA, e lo prende la sentinella S2.
2. **Il TF del grafico e' INERTE su breakout e retest a tick**: il range d'apertura si legge su `PERIOD_M1` **cablato** (`MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` §1.1-1.2). M5, M15, M30, H1, H4 sono **la stessa cella**: quattro CSV identici (e a OHLC misurerebbero il simulatore). I TF che **mordono davvero** sono quattro input: `InpOCTimeframe` (conferma di OPENCONFIRM), `InpLevelTF` (livello PREVBAR), `InpTrailTF` (misurato M1-M30), `InpMgmtTF` (solo `770411`). Vedi §3.
3. **Cosa trovo che nessuno aveva incrociato (tre cose):** (a) **R252** (lo short DAX **in fase con la cash**, 24 passate, 5-8 min dichiarati, riga PASS dal 25/09) **non e' mai tornato**: nessun CSV in nessun ramo; e' l'unica misura che dice se il DD 12,31% dello short vivo e' un artefatto dell'orologio (R251: tutto il DD OOS cade nell'inverno sfasato; estate PF 1,390 su 96 pos, inverno 0,899 su 85). (b) **R207b non misura niente di nuovo**: la cella (ClosePct 0 + BE 1,0) e' **gia' misurata** (q770be Pass 2: OOS PF 1,45723, DD 6,2584, 193 pos); `MISURE_COSTO_ZERO_DAX` §2 punto 2 la presenta come cella senza risultato in archivio. (c) il BREAKOUT e l'OPENCONFIRM del DAX hanno **solo numeri a due lati insieme e a gestione vecchia**: **per lato, a gestione di oggi e in fase, `[NON MISURATO]`**.
4. **Costo**: su M5 il DAX **non sfonda** il `stop >= 40 x spread` per breakout/retest a range 35' (stop `[DERIVATO]` 86,5 / 93,5 idx contro un pavimento di **68,0** idx a BCM 1,70 e **53,2** a FTMO P95 1,33). Quello che sfonda e': stop ad ATR di TF basso (FADE 13,7x, `770411` a M5 22,8x BCM), range <= 15' (33,9x BCM), e **l'ora 8 d'inverno** (pre-mercato, spread ~2,8 `[INFERITO]`: 33x).
5. **Orologio**: **tutti** i round a ora fissa 8 su 2024.09.26-2026.06.30 **mescolano** cash-estate e pre-mercato-inverno (inverno ~60% dei giorni IS, ~40% OOS); **non lo mescolano** solo R246 (separato per data, DAX long e `770411`) e, quando tornera', R252.
6. **Le 3 misure** (§6, in ordine di rapporto valore/costo): **M1** R252 + `PRV_DAXAP_04a-h` (lato x modo, in fase; **file pronti**, 7-13 min); **M2** R192b esteso (DAX all'apertura USA, seconda sessione = frequenza; file esiste, serve prima la sonda dell'ampiezza 14:30); **M3** asse `InpOCTimeframe` M5..H1 (**condizionata** a M1, ~8 min).
7. **File prova pronti, gia' passati da `controlla_prova.py` e `controlla_riga.py --oggetto prova`** (0 problemi, 8 file, 16 celle, 32 passate, ASCII puro): `backtest_pipeline/prove/PRV_DAXAP_04a..04h_*.txt`. **Secondo strato (`controllo-preventivo`) NON fatto da me: niente di questo esce verso Claudio/PC senza.**
8. **Chiedo a Claudio una cosa a costo zero**: lo **zip di R252** (`ROUND_R252_SHORT_DAX_INFASE_<data>.zip` sul Desktop del PC di backtest `DESKTOP-H4D7CAJ`, nome dalla riga `RIGA_R252_SHORT_DAX_INFASE.txt`). Se esiste: 0 minuti di macchina. Se non e' mai partito: va rilanciato.

---

## 1. LE PREMESSE DEL MANDATO CHE VANNO CORRETTE (con la fonte)

| premessa | stato | fonte |
|---|---|---|
| "abbiamo lo storico ampio" | **FALSA per il tick/costo**: nativo D30EUR dal 2024.09.26; il lungo e' solo esterno e solo per regime | `REFERTO_WALKFORWARD.md` r.20-27; `LO_STORICO_ESTERNO_MAPPA` §0.2; `STORICO_INDICI_CRITERI.md` D-G/D-H |
| "TF M5..H4 come asse" | **ASSE DEGENERE** per breakout/retest a tick (inerte per sorgente); asse vero solo su 4 input | `MAPPA_COSTO` §1; `INVENTARIO_MOTORI_APERTURA` §8 |
| "R92b" fra i motori DAX | **non e' un motore DAX**: R92b = `ABTG_Bulge` v5.20, 22 cross forex, diagnosi del guasto tester (`R92BAB_P` ha un DAX come *controllo positivo del banco*, non e' una misura d'apertura) | `report/R92b_CRITERI.md` r.1-6; `R92BAB_LETTURA_2026-10-01.md` |
| "R128" misura l'uscita | solo **R128a** (TrailTF) e **R128e** (CloseHour) hanno un successore girato (R273, PRV_DAXAP_02); **R128b/c/d: nessun CSV in repo** `[NON MISURATO]` | `report/R128_USCITA_APERTURE_2026-09-11.md`; `git grep` |
| R207b come misura utile | **non e' una cella nuova** (= q770be Pass 2 + riproduzione di R47a): IS 132 pos PF 1,18323 DD 4,9576 / OOS 193 pos PF 1,45723 DD 6,2584 | `prove/R207b_*.txt` par. 6; `risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/*_q770be.csv` `[MISURATO]` |
| `PREOPEN_*_DAX` "RangeMode=1 mai acceso sul DAX" | **incompleto**: FASE L (07/08) l'ha girato a tick sul DAX, retest, due lati: RangeMode 1 IS 1,109 n 239 / OOS 0,861 n 320; RangeMode 2 (H1) IS 1,080 n 238 / OOS 0,884 n 326; RangeMode 0 range 35 IS 0,998 n 224 / OOS 1,237 n 316. **Per lato: `[NON MISURATO]`** | `Walkforward_Aperture/DAX_L_rangemode_*.csv` `[MISURATO]` |
| `CENSIMENTO_ORB` M4: gemelli europei del DAX long | **simboli gia' esclusi per costo**: F40EUR 18,6x, E35EUR 15,3x, E50EUR 9,2x (R35/spread); e F40EUR **e' stato girato** (r138a: IS 1,440 / OOS 0,770, DD OOS 11,82%, FAIL rischio) | `MAPPA_COSTO` §4.2; `REGISTRO_TEST` r.3534 |
| `R241a/b` (sei modi per lato) | **SOSPESI dal 24/09** (premessa falsa: i sei modi erano gia' misurati a due lati insieme) e a **rischio 2,0** con G0 su un banco diverso: li **sostituisce** `PRV_DAXAP_04` (rischio 1, G0 di banco R270/R252, modi 0 e 5, in fase) | `prove/R241b_*.txt` r.1-120 |

---

## 2. LA MAPPA: motore x direzione x TF

**Banco comune dove non scritto**: D30EUR M5, tick reali (Modello 4), `ABTG_DAX_Apertura_EU`, ora 8 server, range 35', buffer 5,0 idx, rischio 1%, finestra `2024.09.26 -> 2026.06.30`, IS 40% (IS ~ fino 2025.06.09, OOS ~ dal 2025.06.10), **orologio MESCOLATO** (vedi §4). `deal` = `Trades` del tester (con parziale 50% una posizione fa 1-2 deal; `pos` = posizioni contate dal per-trade). **TF**: dove scrivo "inerte" intendo *per sorgente* (nessun CSV con TF diverso esiste per quel meccanismo, se non dove indicato).

### 2.1 RETEST (`InpEntryMode=2`: la sedia 770101 long / 770105 short)

| lato | cella e finestra | PF IS / OOS · n · DD (IS / OOS) | fonte | stato |
|---|---|---|---|---|
| **LONG** (770101) | 35/500/off 200, ClosePct 50 + BE + PREVBAR, ora 8 mista | 1,12634 / **1,39709** · 175 / 270 deal (132 / **193 pos**) · 5,4362 / 7,2328 | `ROUND_R270_USCITA_DAX_2026-09-28/` (R270c); `risultati_prove/aperture_r47/*_r47a.csv`; `ROUND_DAXAP02_20261001_2244/` cella 17 | **[MISURATO]**, G0 al centesimo in 3 round |
| LONG per stagione | d0 estate (cash) · d0 inverno (1h prima) · d+1 inverno (cash) | PF 1,108 (157 pos) · 1,389 (168) · **1,184 (138, 0,627/g)**; serie "come FTMO" **1,143 su 295 pos, DD saldo 9,50% a rischio 1** (contro 6,06% del d0 anno intero) | `report/LETTURA_R246_INVERNO_2026-09-29.md` §2-3; `REFERTO_R246_2026-09-24.md` §5.2 | **[MISURATO]**, in fase |
| LONG griglia range x buffer | 12 range x 15 buffer, 180 celle distinte (360 righe = gemelli di magic) | **20 celle** con IS e OOS >= 1,10; **range 35: buffer 100-600 (6 contigue)**; range 50: buffer 100, 300-900; isolate: range 25 (buf 400, 500), 55 (900), 60 (300, 1000, 1100); 5-20, 30, 40, 45: zero. Su range 35: buf 300/400/500/600 -> IS 1,147/1,165/1,126/1,105, OOS 1,253/1,330/**1,397**/1,249 | `risultati_prove/ABTG_DAX_Apertura_EU/*_ptd.csv` `[MISURATO]` (ricalcolato) | **[MISURATO]**: la viva sta DENTRO l'altopiano 35 (centro buf 300-400); spostare a 400: IS +0,04, OOS -0,07 = il default va bene |
| LONG durata del range (buf 500) | 15..60 min step 5 | IS 0,777 (15) .. 1,131 (35) .. 1,314 (60); OOS 1,129 (15) .. **1,415 (35)** .. 1,013 (60); n OOS 242-282 | `risultati_prove/aperture_r35/*_r35.csv` | **[MISURATO]**; ribaltamento IS/OOS ai due estremi |
| LONG uscita | TrailMode ATR/PREVBAR/FIXED410 · TP1_R 0,5/1/1,5/2 · TrailTF M1..M30 · CloseHour 11/13/15/17 | OOS 1,028 (DD **10,85 = R1 violato**) / **1,397** / 1,232 · 1,242/1,397/1,385/1,410 · M5 1,397, M10 1,370 (IS 1,021), M20 1,120 e M30 1,085 (DD 10,66 / 10,88: R1 violato) · 1,354/1,293/1,370/1,397 | `LETTURA_R270_2026-09-28.md`; `LETTURA_ORB_R271_R272_R273_2026-09-29.md`; `PRV_DAXAP_02_LETTURA_2026-10-01.md` | **[MISURATO]**: **"il default va bene"** su 4 manopole |
| LONG parziale | ClosePct 0 (BE 0 / 0,5 / 1,0 / 1,5) | IS 1,183 · OOS **1,491** (BE 0 e 1,5), 1,457 (BE 1,0), 1,446 (BE 0,5) · DD 4,96 / 6,27 · 132 / 193 pos | `dal_vps/.../*_q770be.csv`, `*_r137c.csv` | **[MISURATO]** in 4 round; vantaggio +0,094 = **dentro il rumore** (banda 0,147); **firma pendente di Claudio** |
| LONG filtro volumi | `InpUseVolumeFilter` x VolMult 1,2/1,5/1,8 | n OOS 270 -> 150/96/62 deal; PF OOS 1,646/1,538/2,375 (IS 1,191/1,503/1,729, n 104/68/43) | `*_r26.csv` | **[MISURATO]**: la qualita' si compra con la **frequenza** (opposto al requisito di ottobre) |
| **SHORT** (770105) | specchio del long, ora 8 mista | **0,96513 / 0,95734** · 138 / 257 deal (194 pos OOS) · 7,4732 / **12,3052** | `R270d` (`ROUND_R270...`); `LETTURA_R270` §3; FASE M (`DAX_M_direzione_*.csv`): IS 0,846 n152 DD 10,54 / OOS 1,065 n243 DD 12,05 | **[MISURATO]**, **bocciato per rischio** a quella cella (R1: DD > 9% a 1%) |
| SHORT per stagione (solo OOS, 1 gamba) | per-trade 792520, ancora R251 | **estate 96 pos PF 1,390 · inverno ora 8 (pre-mercato) 85 pos PF 0,899**; tutto il DD OOS (1246 EUR dal 20/11/25 al 23/01/26) cade nell'inverno sfasato | `REFERTO_R251_2026-09-25.md` §4; `prove/R252a` par. 1 | **[MISURATO] descrittivo**, n < 150 per stagione |
| SHORT **in fase** (R252a-d) | ora 8 d'estate + ora 9 d'inverno, 641 giorni continui | **`[NON ARRIVATO]`**: nessun CSV in nessun ramo; file `R252a..f` passano `controlla_prova` (6 file, 12 celle, 24 passate, 0 problemi, ri-verificato oggi) | `backtest_pipeline/prove/R252*.txt`, `righe/RIGA_R252_SHORT_DAX_INFASE.txt` | **MISURA 1** |
| SHORT uscita | TrailStartR 0..1,5 · TrailMode · parziale 0 · TP1_R · Supertrend H4..D1 | nessuna passa R1 con merito; Supertrend **H12** IS 1,214 / OOS 1,771 (61 / 126 deal) isolata -> **"NON C'E' UNA CONFIGURAZIONE ROBUSTA"**; D1 IS 0,763 (ribaltamento) | `REFERTO_R251` §2; `LETTURA_R270` §3 | **[MISURATO]** |
| DUE LATI | range 35, 25, 45 | 35: IS 0,998 n224 DD 8,41 / OOS **1,237** n316 DD 10,49; con `InpAllowReverse` OOS +74,6% di profitto ma IS peggiore, peggior giornata x1,9 | `Walkforward_Aperture/DAX_M_*`; `REFERTO_ROUND51_REVERSE_DAX.md` | **[MISURATO]**: "sostituisce, non somma" (256+243 -> 316) |
| TF (M15, M30, H1, H4) | chart TF | **inerte** per sorgente; `R140c` (M15) **scritto, nessun CSV** | `MAPPA_COSTO` §1; `REGISTRO_TEST` r.3072 | `[NON MISURATO]` come CSV; **non c'e' niente da misurare** a tick |

### 2.2 BREAKOUT (`InpEntryMode=0`)

| lato | cella | PF IS / OOS · n · DD | fonte | stato |
|---|---|---|---|---|
| DUE LATI INSIEME | range 35, buf 200, TP1_R 0,5, ClosePct 0, ora 8 mista (gestione **vecchia**) | **1,271 / 0,966** · 179 / 243 · 7,86 / 14,54 | `Walkforward_Aperture/DAX_B_motore_*.csv` (FASE B, 06/08) | `[MISURATO]`, ribaltamento |
| DUE LATI, griglia range x buffer | range 5-45 x buf 100-700, 20 celle | OOS positive su 4 buffer: range **35 = 4/4**, **45 = 4/4**, 5-25 = **0/4**; IS 5-35: 3-4/4, 45: 1/4; **solo 35 e' positivo in entrambe le finestre** | `DAX_A_geometria_*.csv`; `report/CENSIMENTO_ORB_2026-09-29.md` §5 | `[MISURATO]`, superficie rumorosa |
| DUE LATI, vecchissimo | 138 passate, range x buf x TrailFixed | PF mediano **0,77**, 1% delle celle con PF > 1, n ~440 (window 02/08) | `risultati_archivio/DAX_Apertura/ANALISI_MOTORI_DAX_M5.md` | `[MISURATO]` ma **mediana della griglia, non cella al centro**; **la regola dei due lati e' del 25/08, dopo** |
| **LONG** solo | "A2": range 15, buf 600, Supertrend OFF, floor 200 | PF 1,49 (media 1,25), DD 3,8, 314 tr, **senza split IS/OOS** | `REGISTRO_TEST` r.91 | `[LETTO]`, **CSV originale NON in repo** (`RIESAME_MORTI_APERTURE` §0): non rileggibile, indizio |
| **LONG / SHORT** per lato, gestione di oggi, in fase | -- | -- | -- | **`[NON MISURATO]`** -> **M1** (`PRV_DAXAP_04a/b` short, `04e/f` long) |
| TF | chart TF | **inerte** per sorgente | `MAPPA_COSTO` §1 | -- |

### 2.3 OPENCONFIRM (`InpEntryMode=5`: breakout con conferma di candela)

| lato | cella | PF IS / OOS · n · DD | fonte | stato |
|---|---|---|---|---|
| DUE LATI | range 35, buf 200, vol OFF, chart M5 | **0,935 / 1,035** · 186 / 250 · 10,64 / 13,52 | `DAX_B_motore_*` | `[MISURATO]`; `REFERTO_FASE_B_C5` (regola "deve funzionare su DUE mercati"): DAX +209,36 / Nasdaq -365,50 -> bocciato |
| DUE LATI, **TF** della candela | range 15, buf 200, vol OFF: `InpOCTimeframe` **M15 contro chart-M5** | **M15: PF 1,006 n 439 DD 19,58 (+71) · M5: PF 0,890 n 440 DD 23,81 (-1.378)**; con volumi ON il segno si **inverte** (M15 0,947 n 438 / M5 1,086 n 429) | `Openconfirm/DAX_openconfirm_M15.csv`, `DAX_openconfirm_graficoM5.csv` `[MISURATO]` (finestra intera, senza split) | **due soli valori di TF, effetto di segno opposto con/senza volumi = non e' una misura di TF** |
| per lato | -- | -- | -- | **`[NON MISURATO]`** -> **M1** (`04c/d` short, `04g/h` long) |
| TF M30, H1, H4 | `InpOCTimeframe` | -- | -- | `[NON MISURATO]` -> **M3** (condizionata) |

### 2.4 DELAYED / FADE / GAPFILL (gli altri tre modi del motore)

| modo | lato | misura | fonte | stato |
|---|---|---|---|---|
| DELAYED, **solo LONG**, range 35 | long | 9 celle (attesa 15/30/45 x BREAK/MID/CANDLE): CANDLE 15=30 min **IS 1,499 n142 DD 4,70 / OOS 1,100 n194 DD 8,65** (+444); BREAK OOS 0,879 / MID 0,832; 45 min peggio. **Celle 15' e 30' identiche** (range 35' le fa collassare). "Nessuna cella batte il retest in entrambe le finestre" | `ABTG_DAX_Apertura_EU/*_r27.csv`; `REFERTO_ROUND27_DELAYED.md` | `[MISURATO]` long; **short `[NON MISURATO]`** |
| DELAYED, due lati | 2 lati | IS 1,278 n179 / OOS 0,946 n245 (vol OFF); + volumi: **IS 1,113 / OOS 0,717** | `DAX_B_motore_*` | `[MISURATO]` |
| RANGE_FADE | 2 lati | **0 celle su 24 con PF >= 1 sul DAX** (12 celle x 2 finestre; 48 con il Nasdaq): OOS 0,608-0,928, DD fino a 33,9%; 0/136 nell'analisi del 02/08; due lati OOS 0,772 | `aperture_r42/*_r42.csv`; `REFERTO_ROUND42_FADE.md`; `DAX_B_motore_*` | `[MISURATO]`, **morto per lato-insieme**; **per lato e TF M30/H1: `[NON MISURATO]`** (casella 5 del certificato; **stop ad ATR**: M5 13,7x = escluso per costo, §3) |
| GAPFILL | 2 lati | **7 / 9 deal**: sul CFD il "gap" e' lo stacco di mezzanotte del D1, non il gap della cash | `DAX_B_motore_*`; `REGISTRO_TEST` r.4209 | `[MISURATO]` = **campione inesistente**, non un gap-fill |

### 2.5 Livello pre-apertura / candela precedente (`InpRangeMode` 1 e 2) e `InpLevelTF`

| cella | PF IS / OOS · n · DD | stato |
|---|---|---|
| RangeMode 1 (finestra 60' PRIMA dell'apertura), retest, due lati | 1,109 n239 DD 10,86 / **0,861** n320 DD 15,57 | `[MISURATO]` (`DAX_L_rangemode_*`) |
| RangeMode 2, **`InpLevelTF`=H1** (candela precedente), retest, due lati | 1,080 n238 DD 10,00 / **0,884** n326 DD 14,94 | `[MISURATO]` |
| `InpLevelTF` M5 / M15 / M30 / H4 | -- | `[NON MISURATO]` (e **non lo propongo**: con n 320-326 sopra 150 il merito e' leggibile ed e' **negativo a due lati**; serve una **tesi nuova** per riaprire) |
| per lato, in fase | -- | `[NON MISURATO]` |

### 2.6 `770411` MaxMin DAX SHORT (box notturno, rottura al ribasso) e il suo specchio

| lato | misura | fonte | stato |
|---|---|---|---|
| **SHORT** (la sedia) | IS PF 1,87803 (20 deal) DD 3,0977 / OOS **2,15985 (21 deal, 14 pos)** DD 1,9213 (`PRV_DAXAP_03a` cella 07:59 = R246i). In fase: d0 estate 1,450 (11 pos), d0 inverno 2,558 (16), d+1 inverno 0,996 (17); serie "come FTMO" 1,187 su 28 pos | `PRV_DAXAP_03_LETTURA_2026-10-02.md`; `LETTURA_R246_INVERNO` | `[MISURATO]`, **n < 30: il PF non si legge**; merito mai leggibile (14 pos OOS) |
| SHORT, minuto di piazzamento | 07:59/08:00/08:01: 0-3 deal di differenza; ritardo +5/+10/+15: IS sale (2,60 / 4,03 / 4,66), OOS **crolla** (1,130 / 0,568 / 0,325) | `PRV_DAXAP_03_LETTURA` | **ribaltamento su 13-15 deal: nessun caso per ritardare** |
| **LONG** (specchio, filtro S&P 0/1) | **0 celle su 41 a tick con PF >= 1,00**; corr=1: 72 pos PF **0,883** DD 7,82 | `REGISTRO_TEST` r.4557-4575 (R261a) | `[MISURATO]`: motore "NON ANCORA MISURATO" solo per uscita e gemelli |
| TF `InpMgmtTF` sul **long** | M15/M20/M30/H1/H2/H3/H4: PF **0,883 / 0,869 / 0,705 / 0,823 / 0,761 / 0,724 / 0,721**, stesse 72 giornate | R261b | `[MISURATO]`, casella 5 chiusa **sul long** |
| TF `InpMgmtTF` sullo **short**, `InpAtrSLmult` | `R214g` e `R206a`: scritti, **nessun CSV** | `prove/R214g_*.txt`, `R206a_*.txt` | `[NON MISURATO]`; con 14 pos OOS **non si leggera' mai il merito** (solo il rischio): bassa priorita' |

### 2.7 Altri meccanismi sulla stessa inefficienza (DAX, apertura/primo ora)

| meccanismo | misura | stato |
|---|---|---|
| `ABTG_DaxReEntry` (range 08:35-11:05, fascia 11:05-14:15) | LONG 6/6 verde, PF 1,159 (n92) .. **1,69-1,80 (n57, break 40)**, DD 2,5-4,6%; SHORT 0,38-0,54 (n 45-94); **~3-4 trade/mese per lato** | `REFERTO_DAXREENTRY_2026-08-31.md`: **merito sospeso (n<150), cecchino: non aiuta la frequenza** |
| `ABTG_GapContinuation` SHORT (gap-down) | 29 pos in fase, PF 0,898, DD 5,63% | `REFERTO_R253_2026-09-25.md`: merito sospeso, ~0,09 pos/seduta |
| `ABTG_DAX_Live5m` / `_v2` (candela pre-apertura 5') | OOS 0,857 n342 DD 39,74% (2%); v2 0,85-0,95; **lato short v2 `[NON MISURATO]`** | `CENSIMENTO_ORB` riga 17: negativo a tick e sotto costo su M5 |
| ORB 65' ("Dax Open Range", `ABTG_ORB_Ottimizzato`) | scheda completa OOS 1,022 DD 17,5% n191; ribaltamento Spearman -1,0 | `REFERTO_ROUND11_ORB_DAX.md` |
| `ORB_DAX_BASE_EA`, `ORB_OpeningRange` | **nessun CSV in tutta la storia git** | `CENSIMENTO_ORB` righe 21-22: `[NON MISURATO]` |
| `ABTG_ImpulsoApertura` M30 (`R140a`) | EA scritto, **non compilato**; round **mai girato** | `report/EA_IMPULSO_APERTURA_2026-09-08.md` |

### 2.8 Il giacimento (manopole inerti e mai messe ad asse, per la famiglia)

- **Inerti misurate** su **2.143 righe di CSV DAX apertura -> 1.219 esiti distinti** (di cui ~700 duplicati sono i gemelli di magic, voluti): `InpTrailFixedPts` con trailing PREVBAR (`Aperture_Ingresso`: 160 passate -> **20 esiti**; `Aperture_Trailing`: 96 -> **7**; `Openconfirm`: 96 -> **9**); `InpRangeMinutes` con `RangeMode != 0` (FASE L: 6 -> 4); DELAYED 15' = 30' (R27: 9 -> 6); `InpUseVolumeFilter` sul GAPFILL.
- **Mai ad asse** (verificato con `grep` sui CSV/prove di questa sessione): **`InpPlaceHour/Min` del retest e del breakout** (solo su `770411`: PRV_DAXAP_03), **`InpSessionHour` del DAX** (R192a scritto, nessun CSV), **`InpMaxRangePts`** (PRV_DAXAP_01 *bloccato* dal cancello del 01/10: classe 294), `InpPendingExpiryMin` (120 ovunque; R43c/d lo muovono solo sul FADE), **`InpOCTimeframe` a range 35**, `InpLevelTF` != H1, `InpMgmtTF` dello short, `InpAtrSLmult` del `770411`, `InpCloseHour` fuori da PRV_DAXAP_02.

---

## 3. COSTO: la frontiera `stop >= 40 x spread`, TF per TF, con il numero accanto

**Spread (idx = punti MT5 / 100) `[MISURATO]`**: BCM, tick storici 2024.09.26-2026.06.30 (`risultati_archivio/spread_flotta/spread_orario_D30EUR.csv`, ricalcolato): **ora 8 mediana 1,70 / P95 2,70** (miscela estate-inverno), ora 9 **1,70 / 1,90**, ora 7 (pre-mercato d'estate) **2,80 / 4,10**. Logger vivo BCM 04-11/09 (estate, GG=5, `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv`): ora 8 **1,60 / 1,70**. FTMO `GER40.cash`, ora 10 server (= cash): **1,23 / 1,33**, ora 09 (pre) 1,43 / 2,33 (`SPREAD_APERTURA_FTMO_2026-09-21.md` §2; **GG=1: sottile**). Commissione/swap FTMO e slippage: `[NON MISURATO]` (ogni "x" FTMO e' un tetto).
**Pavimenti 40x `[DERIVATO]`**: **68,0** idx (BCM 1,70) · **108** (BCM P95 2,70) · **49,2** (FTMO 1,23) · **53,2** (FTMO P95 1,33). Pavimento duro 13,3x.

### 3.1 Breakout / retest / delayed: lo stop NON dipende dal TF del grafico

Stop = range + k. Range 15' mediano **54,65 idx** (`Studio_D30EUR.csv`, **n=440**, `[MISURATO]`, ricalcolato), range a T minuti `[INFERITO]` = 54,65 x sqrt(T/15) (legge di casa; sul DAX il rialzo d'apertura x1,56 spinge nello stesso verso).

| range (min) | R mediano | stop RETEST (R+3) | x su 1,70 (BCM) | x su 1,33 (FTMO P95) | giudizio |
|---:|---:|---:|---:|---:|---|
| 5 | 31,6 | 34,6 | **20,3x** | 26,0x | **ESCLUSO PER COSTO** (<40, sopra il duro 13,3) |
| 10 | 44,6 | 47,6 | **28,0x** | 35,8x | **ESCLUSO PER COSTO** |
| 15 | 54,6 | 57,6 | **33,9x** | 43,3x | sotto 40 a BCM, passa a FTMO |
| 25 | 70,6 | 73,6 | 43,3x | 55,3x | passa |
| **35 (viva)** | 83,5 | **86,5** | **50,9x** | 65,0x | **passa** |
| 45 | 94,7 | 97,7 | 57,4x | 73,4x | passa |
| 60 (= "H1") | 109,3 | 112,3 | 66,1x | 84,4x | passa |
| 120 | 154,6 | 157,6 | 92,7x | 118,5x | passa |
| 240 (= "H4") | 218,6 | 221,6 | 130,4x | 166,6x | passa (ma e' il territorio di `DaxReEntry`, 3-4 trade/mese) |

- BREAKOUT / OPENCONFIRM / GAPFILL: stop **R+10** (35': **93,5** idx -> **55x** BCM, 76x su 1,23, 70x su 1,33; OPENCONFIRM `>=` per l'overshoot `[NON MISURATO]`). DELAYED: stop = **R** (83,5, 49x), puo' scendere (DIR_CANDLE con `InpMinStopPts=0`: lotto al massimo, `INVENTARIO` §4.4).
- **Quota di giornate sotto il pavimento** (R15 per giorno x 1,5275 + k `[INFERITO]`): al P95 FTMO (53,2): retest 23,4% / breakout 14,5%; alla mediana BCM (68,0): retest 33,4% / breakout 28,9%. Dalla ricostruzione dei lotti del 770101 (`PARAMETRI_DAX_APERTURA` §a): 30,5% / 43,7% (325 pos): due stime, **non** si riconciliano da questa sessione.
- **Su M5 il DAX NON sfonda la frontiera per breakout e retest a 35'**: il TF non e' nello stop. Cio' che la sfonda e' **il range corto** (5', 10', 15' a BCM) e **l'ora 8 d'inverno**: in pre-mercato lo spread e' ~2,8 (`[INFERITO]` dall'ora 7 d'estate; **non** e' una misura dell'ora 8 d'inverno), quindi 86,5/2,8 = **30,9x** e 93,5/2,8 = **33x**, entrambi sotto 40.

### 3.2 Dove il TF entra nello stop: ATR sul TF del grafico / di gestione

ATR(14) M15 del DAX **26,8 idx** (`[DERIVATO]`, riconciliazione 25,7-29,2: `ATR_DAX_M30_RICONCILIAZIONE_2026-09-17.md`; **mai letto `iATR`**), scala sqrt(T) `[INFERITO]`.

| TF | ATR | RANGE_FADE 1,5x ATR(chart TF) | x su 1,70 / 1,23 | `770411` 2,5x ATR(`InpMgmtTF`) | x su 1,70 / 1,23 |
|---|---:|---:|---|---:|---|
| **M5** | 15,5 | 23,2 | **13,7x / 18,9x: ESCLUSO PER COSTO** (sul filo del duro 13,3x) | 38,7 | **22,8x / 31,4x: ESCLUSO** |
| M15 | 26,8 | 40,2 | 23,6x / 32,7x: escluso | 67,0 | **39,4x** / 54,5x: sul pavimento a BCM |
| M30 | 37,9 | 56,9 | 33,4x / 46,2x: escluso a BCM, passa a FTMO | 94,8 | 55,7x / 77,0x |
| H1 | 53,6 | 80,4 | 47,3x / 65,4x: passa | 134,0 | 78,8x / 108,9x |
| H4 | 107,2 | 160,8 | 94,6x / 130,7x | 268,0 | 157,6x / 217,9x |

(`PARAMETRI_DAX_APERTURA` §"Il TF" calcola il `770411` a M5 su 1,33: **29x**: coerente con la mia colonna FTMO se si usa 1,33 invece di 1,23.)

### 3.3 TF che MORDONO: cosa e' misurato (tutti a M5 tranne dove scritto)

| input | valori misurati | dove | cosa manca |
|---|---|---|---|
| `InpTrailTF` (long) | M1..M5 (R24 sul retest long; FASE I su breakout due lati: ribaltamento, Spearman -0,60), **M5..M30** (R273) | M5 vive; M10 pari in OOS ma IS 1,021; da M20 R1 violato | **chiuso** |
| `InpLevelTF` (livello PREVBAR) | solo **H1** (FASE L, due lati, retest) | negativo OOS | M5/M15/M30/H4 e per lato; **non propongo** (tesi mancante) |
| `InpOCTimeframe` (OPENCONFIRM) | **M5 e M15** (05/08, range 15, due lati) | segno opposto con/senza volumi | M30, H1 (H4 fa entrare solo alle 12:00 `[INFERITO]`); **a range 35, gestione di oggi, per lato: tutto** -> **M3** |
| `InpMgmtTF` (`770411`) | long: M15..H4 (R261b); **short: nessuno** | long tutto < 1,00 | short (R214g): bassa priorita' |
| TF del grafico | -- | inerte per sorgente | niente |

---

## 4. OROLOGIO: quali celle misurate mescolano le due tempistiche

**Regola**: BCM indici = **UTC+1 fisso** su tutto lo storico indici (`OROLOGIO_BCM_2026-09-24.md` §0). Cash Xetra 09:00 italiane = **08:00 server d'estate**, **09:00 server d'inverno**; `InpSessionHour=8` d'inverno arma **un'ora prima** (pre-mercato). Inverno UE: `2024.10.27 <= d < 2025.03.30` e `2025.10.26 <= d < 2026.03.29`. Feriali sulla finestra continua: **estate 238, inverno 220** (`R252a` par. 4); gamba IS ~60% inverno, OOS ~40% (`PRV_DAXAP_02_LETTURA`). **FTMO e' IT+1 tutto l'anno**: la sua sedia e' in fase con la cash per costruzione (data del suo cambio d'ora `[NON MISURATA]`, misura del 25/10). BCM: dal **26/10** (DAX) le sedie a ora fissa armano un'ora prima.

| cella misurata | finestra / ora | tempistica | mescola? |
|---|---|---|---|
| 770101 long: R47a, R270c/e, R273, PRV_DAXAP_02, `ptd`, `r35`, `r26/r27`, R120, FASE A-M, `Aperture_Ingresso` | 2024.09.26-2026.06.30, ora 8 | estate in fase / inverno 1h prima | **MESCOLA** (contratto: PF 1,27 mesi allineati n144, 1,48 sfasati n126 `[LETTO]`; causa non dimostrata) |
| 770105 short: R251, R270b/d | idem | idem | **MESCOLA**; per-trade OOS 792520: 96 estate PF 1,390 / 85 inverno PF 0,899 |
| **R246 (770101 e 770411)**: d0, -1h, **d+1** | stesse finestre, **stagione per data di chiusura** | separato | **NO**: d0 estate cash / d0 inverno pre / **d+1 inverno cash** |
| **R252a-d (770105 in fase)** | ora 8 + ora 9, finestra continua | in fase | **NO** (quando tornera') |
| 770411: R81, R246i-l, R261, PRV_DAXAP_03a/b | idem | **03a/b MESCOLANO** (dichiarato nei file); R246 separa | n < 30 ovunque |
| Studio `Studio_D30EUR` (range 15', n=440), 05/08 `Aperture_*`, `Openconfirm/*`, `DAX_Apertura/*` | 2024.09.26-2026.06.30 (alcuni "2024.01": prima del 2024.09.26 BCM non ha dati, `REFERTO_WALKFORWARD` r.20-27) | ora 8 | **MESCOLANO** |
| PRV_DAXAP_04a-h (questa famiglia) | ora 8 file x estate, ora 9 file x inverno | in fase (curva ricomposta da per-trade) | **NO** |

---

## 5. LA GRIGLIA: cosa propongo, e cosa NON propongo

**Regola 19/08 rispettata**: nessun asse sui parametri d'ingresso di un motore a PF < 1,10 su campione pieno. Si confrontano **meccanismi** (modo x lato x orologio) e **TF**; i parametri restano ai valori del vivo (R252a, a specchio del 770101).

**NON propongo** (e perche', col numero): `PRV_DAXAP_01` (bloccato, classe 294); **R207b** (non e' una cella nuova: q770be); `R241a/b` (sostituiti da 04); `R191a/R192a/R214g/R206a` (n=14 pos OOS sul `770411`: solo rischio); **gemelli europei** (esclusi per costo; F40 girato: FAIL); **PREOPEN/`InpLevelTF` != H1** (FASE L negativa a n 320-326, serve tesi nuova); **altro buffer/range sul retest long** (griglia 180 celle gia' fatta: la viva e' dentro l'altopiano 35; il secondo altopiano a range 50 resta **non provato in fase** e non lo sposto da solo).

---

## 6. LE TRE MISURE (in ordine di rapporto "avvicina una sedia schierabile" / costo)

### M1 -- LATO x MODO, IN FASE: R252 (retest) + PRV_DAXAP_04 (breakout, openconfirm)

**Perche' e' la prima**: (a) la sedia 770105 e' **in campo** e il numero che la giudica (R252) **manca da 8 giorni**; (b) la regola dei due lati non e' chiusa per **breakout e openconfirm** (solo due-lati-insieme, gestione vecchia); (c) costa **7,2-12,6 minuti** (retta di R252a par. 14, controprova R251: previsti 249 s, misurati 270 s).
**Contenuto**: **R252a-d** (esistono: short nudo e H12 a ora 8/9; + R252e/f long di riferimento, ridondanti per la frequenza dopo R246 INVERNO, `R252a` par. 10) e **8 file nuovi** `PRV_DAXAP_04a..h` (breakout e openconfirm, short e long, ora 8 e ora 9). Un solo cambiamento per file rispetto a R252 (il modo, piu' il magic; diff eseguito). 32 passate nuove.
**File pronti** (0 problemi su `controlla_prova.py`, nessun difetto meccanico su `controlla_riga.py --oggetto prova`; ASCII puro; magic `798301-798358` vergini; **testa** = `04a`, con criteri, attese, contro-esempio, costo, orologio, buchi):
`backtest_pipeline/prove/PRV_DAXAP_04a_modi_short_breakout_ora8_D30EUR.txt` (testa) · `04b_..short_breakout_ora9` · `04c_..short_openconfirm_ora8` · `04d_..short_openconfirm_ora9` · `04e..04h` (gemelli long).
**Finestra** `2024.09.26 -> 2026.06.30`, `@FRAZIONEIS 0.001` (IS = moncone di 1 giorno, OOS = corsa continua 641 giorni; la curva IN FASE si ricompone dal per-trade: righe d'estate dell'ora 8 + righe d'inverno dell'ora 9, come `R252a` par. 5). **Tranche: non servono** (cap barre: stessa finestra continua gia' girata da R253 su altro EA; su questo EA `[NON VERIFICATO]` e lo prende la sentinella S2 sulla prima chiusura: se cade dopo il 2024.10.03 il tester ha troncato e si spezza in due tranche, 2024.09.26-2025.09.30 e 2025.10.01-2026.06.30, ciascuna <100.000 barre).
**Attesa scritta PRIMA** (nel file): posizioni 65-90% dei feriali (OOS-era 170-235); PF in fase 0,85-1,30 su tutte e 4 le celle (centro 1,05); **direzione**: PF(breakout) <= PF(retest) - 0,05 in >= 3 confronti su 4 (entra 7 idx peggio, stop 7 idx piu' largo); DD OOS-era in fase 4-12%.
**Contro-esempio**: l'attesa e' smentita se il breakout batte il retest di >= 0,10 sia in IS-era che in OOS-era sullo stesso lato con >= 150 posizioni; l'ipotesi "il retest lascia a secco le discese a V" (H_SHORT_V) la **non aspetto** (REFERTO_R251 §3: le manopole predette vanno nel verso opposto).
**Soglie congelate** (= R252a par. 9): R1 5,79% / R2 8,21% di DD a saldo chiuso della curva in fase (con k, e_eff, D); R3 -1,10%; merito solo con posizioni OOS-era >= 150; M1 PF >= 1,10; M2 >= controllo + 0,10 con EP > EP controllo; M3 concordanza IS/OOS. Esito massimo: "PROMOSSA AL PASSO DOPO" = asse proprio + prova di regime, **mai una sedia**.
**Costo**: solo short (R252a-d + 04a-d) **~7,2 min**; tutto (R252a-f + 04a-h) **~12,6 min** (tetto 25, poi ci si ferma). Zero se lo zip di R252 esiste (si risparmiano 3,6-5,4 min).
**Buchi dichiarati**: il **lettore del round non esiste** (`r252_attese.py` ha le attese; il modello e' `r246_giudizio_d1.py`): e' lavoro, non macchina, `[NON MISURATO]` in ore; un regime solo; IS-era 197 feriali = sotto 150 pos (giudica il rischio); per-trade senza ora d'ingresso; spread FTMO GG=1.

### M2 -- LA SECONDA SESSIONE DEL DAX: apertura USA (R192b esteso), con la sonda dell'ampiezza prima

**Perche'**: la frequenza della famiglia Aperture e' **1,047 op/giorno** con DAX 0,699 + Dow 0,348 (`ALLARGARE_LA_ROSA_2026-09-19` §0.1, backtest OOS in posizioni): sopra il pavimento **di poco, con due sedie**. "Una sessione in piu'" sul simbolo che conosciamo e' la via piu' corta; **`InpSessionHour` del DAX non e' mai stato ad asse** (R192a/R192b scritti il 19/09, **nessun CSV**).
**Passo 0 (zero tester sul motore, 1 passata dello Studio)**: l'**ampiezza del range 14:30-15:05 sul D30EUR e' `[NON MISURATA]`** (`Studio_D30EUR` misura solo le 08:00): senza, il cancello del costo (**range >= 54 idx per stop >= 64**, R192b) non si calcola. Strumento esistente: `ABTG_Apertura_Study_EA`; costo `[NON MISURATO]`.
**Passo 1**: `R192b` (long, retest, ora 14 min 30, flat 20:30, 4 passate; **da estendere ai due lati e all'orologio in fase**: 14:30 BCM e' l'apertura USA (15:30 IT) **solo d'estate**; d'inverno BCM = IT e la cash USA e' alle 15:30 server).
**Attesa**: n 120-300 deal per finestra (R192b, ~1 setup/giorno); **PF: nessuna attesa** (base storica vuota; due indizi opposti: l'ora piu' mossa del pomeriggio contro "il filtro che aiuta gli indici USA danneggia gli europei", `DOW_MOTORE.md`); DD < 14%. **Contro-esempio**: se n < 50 e' "configurazione o finestra sbagliata", mai "non funziona"; se passa tutto resta **un candidato**, non una sedia, finche' non c'e' il costo e la conta in posizioni.
**Rischi dichiarati**: stesso driver (US open) di `770202`/`770260` -> **cluster**, e `PositionClose(_Symbol)` su hedging chiude la piu' vecchia del simbolo: la toppa per ticket e' in HEAD sui tre Apertura (`9fca63d9`) ma **non l'ho verificata su questo percorso**.
**Costo**: 4 passate **0,9-3,4 min** (0,9 con la retta di R252a; 3,4 e' il dichiarato di R192b); esteso ai due lati e in fase ~8-10 file x 54 s ~ **8-9 min** `[DERIVATO]`.

### M3 -- L'ASSE TF VERO DI OPENCONFIRM: `InpOCTimeframe` M5..H1 (CONDIZIONATA a M1)

**Perche'**: e' l'**unico asse TF del motore** che e' il meccanismo (il TF e' la candela di conferma: breakout "M5 (preferito), M15, M30, H1" nel senso che chiede Claudio). Prior `[MISURATO]` debole: M15 batte M5 senza volumi (1,006 contro 0,890), perde con i volumi (0,947 contro 1,086) = segno invertito.
**Condizione**: parte **solo se** `04c/04d` (short) o `04g/04h` (long) danno PF per posizione in fase >= 1,00 su >= 150 posizioni OOS-era. Altrimenti **non si fa**: nessun asse TF su un motore senza evidenza.
**Disegno**: un file per lato, asse `InpOCTimeframe` 5 -> 16385 (enum: **8 celle**: M5 M6 M10 M12 M15 M20 M30 H1; H2-H4 fuori: H4 entra solo alle 12:00 `[INFERITO]`), cella viva = M5 (G0 contro `04c`/`04g`), **ora in fase** come M1.
**Attesa**: **posizioni non crescenti col TF** (candela piu' lunga = meno aperture "oltre il livello"), PF entro +-0,15 della cella M5, **"il default (M5) va bene"** (~80%). **Contro-esempio**: una cella >= M5 + 0,10 in IS-era E OOS-era con **tre celle contigue** = altopiano; **una cella che sporge** = "NON C'E' UNA CONFIGURAZIONE ROBUSTA".
**Costo**: 16 passate per lato **~4 min per lato, ~8 min** `[DERIVATO]` (R273 e' dentro un pacchetto: 24 passate R271-R273 in 6 min). **Non preparo il file**: dipende da M1.

**Ore macchina in totale** (se partono tutte): M1 0,12-0,21 h + M2 0,15 h + M3 0,13 h = **~0,4-0,5 h**. Il costo vero e' il **lettore** (M1) e il **cancello a due strati** su 8+ file.

---

## 7. COSA CHIEDO A CLAUDIO (il resto e' deciso dal repo)

1. **Lo zip di R252** sul Desktop del PC di backtest `DESKTOP-H4D7CAJ` (`ROUND_R252_SHORT_DAX_INFASE_<AAAA-MM-GG>.zip`): se c'e', va caricato; se la riga non e' mai partita, **via libera a rilanciarla** (24 passate, 5-8 min; passa dal cancello, e' una riga gia' scritta il 25/09).
2. **Via libera ai file `PRV_DAXAP_04a..h`** (passano dal secondo strato e dal cancello della riga come tutto il resto) e **a scrivere il lettore** del round.
3. **R192b/M2**: vuole davvero una **seconda sessione sul DAX** (cluster con Dow e Nasdaq) prima che si misuri l'ampiezza delle 14:30?
4. Non e' mia ma pesa su tutto: la **decisione sull'orologio BCM entro il 25/10** (dal 26/10 le sedie a ora fissa armano un'ora prima sul DAX).

---

## 8. IL CONTRO-ESEMPIO CHE HO COSTRUITO CONTRO IL MIO STESSO LAVORO (prima di consegnare)

1. **Mia idea iniziale: "la prima misura e' R207b (cella pulita ClosePct 0 + BE 1,0)".** Aperto il file: la cella e' **gia' misurata** (q770be Pass 2). Scartata. (La frase di `MISURE_COSTO_ZERO_DAX` §2 punto 2 era giusta su R207b-mai-girato ma non conosceva q770be: va completata.)
2. **Mia idea: "preparo un file a 6 modi per lato sull'enum `InpEntryMode`".** Esiste gia' (R241a/b), sospeso, e **mescola l'orologio**: lo short perde tutto il DD nell'inverno pre-mercato (R251 §4); un round misto sullo short **sbaglia il verso**. Rifatto **in fase**, per cella, con per-trade, sul metodo di R252.
3. **"R252 non e' mai tornato"**: cercato in tutti i rami (`git grep` dei magic 792601-792656 e `git ls-tree`): nessun risultato; **ma** lo zip potrebbe stare sul PC di Claudio (e' una domanda per lui, non una conclusione). R252e/f sono ridondanti per la frequenza dopo R246 INVERNO (tornato il 29/09).
4. **"Il TF e' inerte"**: l'ho verificato sul **sorgente** (due volte, e `PERIOD_CURRENT` solo in 4 punti) e **contro un CSV**: `DAX_openconfirm_graficoM5` contro `_M15` mostra un effetto del TF **dove il TF e' il meccanismo** (OC), e **nessuno** dove non lo e'. Resta `[MISURATO su sorgente]`, **non** su 4 CSV di TF diversi (R140c non e' mai girato).
5. **Spread "ora 8 d'inverno = 2,8"** e' un **`[INFERITO]`** dall'ora 7 d'estate, **non** una misura: il logger vivo e' d'estate e l'archivio e' una miscela per tick. L'ho scritto con la sua etichetta nel file prova e qui.
6. **Quote di giornate sotto 40x**: due stime (R15 per giorno x 1,5275: 33,4% retest; lotti ricostruiti: 43,7%) **non si riconciliano**; le riporto tutte e due.
7. **Dichiaro cosa NON ho fatto**: nessun backtest, nessun numero di merito nuovo; i PF di §2 sono **riletti dai CSV/referti** (ricalcolati da me i dati della griglia `ptd`, `r35`, FASE A-M-L, R26/R27/R42, q770be, Openconfirm); `R252` non l'ho letto perche' non c'e'.

---

## 9. BUCHI DICHIARATI

- **R252 non arrivato**; **lettore dei round 04/R252 inesistente**; **profondita' di regime del DAX apertura: nessuna** (un regime, ~21 mesi); HistData DAX non importato.
- **Range 35' vero** del D30EUR: `[DERIVATO]` da R15 (n=440); la sonda (`PRV_DAXAP_00`, FASE 1b) e' **ferma**: la corsa DAX del 29/09 e' fallita ("nessun dato nelle finestre attese"), causa non diagnosticata (`PARAMETRI_DAX_APERTURA` buco 2).
- **Ampiezza 14:30 del DAX**: `[NON MISURATA]` (M2).
- **Spread FTMO**: GG=1; commissioni/swap/slippage FTMO `[NON MISURATO]`; cambio d'ora FTMO `[NON MISURATO]` (25/10).
- `R140c`, `R128b/c/d`, `R214g`, `R206a`, `R191a`, `R192a/b`, `R205a` (che dice "short mai girato": errata gia' in testa): **scritti, nessun CSV in repo**.
- Il per-trade non ha l'ora d'ingresso (solo `close_time`): durata ingresso->uscita non misurabile.
- Questo dossier e i file `PRV_DAXAP_04*` hanno passato il **primo strato** (`controlla_prova.py`, `controlla_riga.py --oggetto prova`). **Il secondo strato (`controllo-preventivo`) NON e' stato eseguito da questa sessione**: finche' non torna PASS, **niente esce**.

_Fonti principali (percorsi dal repo)_: `report/PARAMETRI_DAX_APERTURA_2026-10-01.md`, `report/INVENTARIO_MOTORI_APERTURA_2026-09-24.md`, `report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md`, `report/OROLOGIO_BCM_2026-09-24.md`, `report/CENSIMENTO_ORB_2026-09-29.md`, `report/LETTURA_R246_INVERNO_2026-09-29.md`, `report/REFERTO_R251_2026-09-25.md`, `report/LETTURA_R270_2026-09-28.md`, `report/LETTURA_ORB_R271_R272_R273_2026-09-29.md`, `report/PRV_DAXAP_02_LETTURA_2026-10-01.md`, `report/PRV_DAXAP_03_LETTURA_2026-10-02.md`, `report/MISURE_COSTO_ZERO_DAX_2026-09-29.md`, `report/ALLARGARE_LA_ROSA_2026-09-19.md`, `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`, `backtest_pipeline/REGISTRO_TEST.md`, `backtest_pipeline/risultati_archivio/{Walkforward_Aperture,Openconfirm,Aperture_Ingresso,DAX_Apertura,spread_flotta,studio_apertura}/`, `backtest_pipeline/risultati_prove/{ABTG_DAX_Apertura_EU,aperture_r35,aperture_r42,dal_vps}/`, `data/spread_vivo/`, `backtest_pipeline/prove/{R252*,R207b*,R192b*,PRV_DAXAP_*}`.
