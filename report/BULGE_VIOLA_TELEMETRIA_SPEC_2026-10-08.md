# SPEC del CSV di telemetria del Bulge VIOLA (copia di banco `ABTG_Bulge_Telemetria`) -- 08/10/2026

Scopo: UNA sola corsa del tester sulla cella VIOLA-solo (quella di `backtest_pipeline/prove/BULGE_M1_cella_campo_lunga.txt`) deve produrre i dati per simulare **OFFLINE**, a costo zero di tester, tutte le uscite (BE, trailing, parziale, time-stop, regola di invalidazione a T+30, filtri orari...) e le regole di portafoglio (cap per valuta, Max_Trades, kill switch), **con l'effetto sulle aperture incluso** (slot liberati). Lo script che legge questo formato e' `backtest_pipeline/sim_bulge_viola_uscite.py` (autotest su percorsi finti, gia' scritto).

**Chi scrive il codice**: un altro agente (`mql5-ea-developer`) **dopo** questo spec; il codice di banco e' **firma di Claudio** (Q4 del dossier `MIGLIORA_BULGE_VIOLA_2026-10-08.md`); **non va su nessun conto**, gira solo sul PC di backtest `DESKTOP-H4D7CAJ`, mai sul VPS (regola 21/09). `mql5/Experts/ABTG_Bulge.mq5` **non si modifica**: la copia e' un file nuovo.

## 0. Vincoli non negoziabili
1. **Stessa logica, nessun cambio di segnali, ordini o default.** Il codice aggiunto e' solo osservazione (scritture su file). Test di accettazione **P0**: nella stessa passata, `Trades`, `Profit`, `Profit Factor`, `Equity DD %` del CSV di OptResults della copia devono essere **identici al centesimo** a quelli di `ABTG_Bulge` v5.20 (SHA256 `ED4E88B1...`) con gli stessi input; se differiscono, la copia e' rotta e nessun numero di telemetria vale.
2. **Un input nuovo**: `InpTelemetria` (bool, default `false`; i file prova lo mettono a 1). Spento = comportamento bit per bit come l'originale.
3. **Il log dei segnali e' indipendente dagli ordini**: ogni segnale VIOLA grezzo viene registrato **anche se l'ordine non parte** (Max_Trades, posizione gia' aperta, kill switch, news, Guardian, TP/SL non validi) e **anche se il filtro ATR lo avrebbe bloccato** (flag `atr_ok`). Serve a simulare cosa succede quando l'uscita anticipata libera uno slot.
4. Scrittura **a fine passata** (`OnTester`/`OnDeinit`) o a blocchi, in `MQL5\Files` (`FILE_COMMON` non necessario nel tester), **mai** dentro il percorso di apertura ordini. Nessun `Sleep`, nessuna chiamata che cambi lo stato del conto.
5. Un file per **magic** (come l'attuale `abtg_trades_*`). In ottimizzazione le `Print` degli agent non escono: i file si.

## 1. Convenzioni (valgono per tutti i file)
- Separatore `;`, decimale `.`, CRLF, intestazione obbligatoria, ANSI/ASCII.
- **Tempi**: ora SERVER del conto di backtest (BCM = UTC+1 fisso), formato `YYYY.MM.DD HH:MM:SS`. Colonne `*_utc` = stesso istante in UTC. Il tester ha la sua ora server: si registra `server_utc_offset_h` (intero) per riga.
- **Prezzi**: grezzi, cifre del simbolo. Le barre di percorso sono **BID** (come `MqlRates`); l'ask = bid + `spread_pts` x `point`.
- `side`: `1` = long, `-1` = short. `point` = `SYMBOL_POINT`; `pip_size` = 0,01 se il cross contiene JPY, altrimenti 0,0001.
- **R** (rischio) = `risk_dist` = |prezzo di riferimento d'entrata - SL| (SL = 3 ATR del segnale). I multipli `mfe_r`/`mae_r`/`r_*` sono in questa unita': mfe_r = (massimo favorevole - entrata) / risk_dist, mae_r = (entrata - minimo avverso) / risk_dist (positivo = avverso).
- Barre H1 del segnale (stessa nomenclatura dell'EA, v5.20 con `Signal_Bar_Offset = B = 1`): `iCnf = B` (barra di CONFERMA, l'ultima chiusa quando si entra), `iSig = B + 1` (barra del segnale base). L'ingresso avviene al primo tick della barra 0 (`bar_open_time`).

## 2. File 1 -- segnali: `abtg_tel_segnali_<EA>_<simbolo grafico>_<magic>.csv` (una riga per SEGNALE grezzo)
| # | Colonna | Tipo / unita' | Significato |
|---|---|---|---|
| 1 | `sig_id` | intero crescente | chiave del segnale (unica per file) |
| 2 | `symbol` | testo | cross del segnale |
| 3 | `side` | 1/-1 | direzione |
| 4 | `bar_open_time` | tempo server | apertura della barra H1 di ENTRATA (barra 0); e' l'orario d'ingresso |
| 5 | `bar_open_time_utc` | tempo UTC | idem in UTC |
| 6 | `server_utc_offset_h` | intero | offset del server in ore in quell'istante |
| 7 | `outcome` | testo | `OPENED`, `BLOCK_MAXTRADES`, `BLOCK_HASOPEN`, `BLOCK_KILL`, `BLOCK_NEWS`, `BLOCK_GUARDIAN`, `BLOCK_ATR` (con `atr_ok = 0`), `SKIP_TP`, `SKIP_SL` (esiti di `OpenOrder`/`OnTick`) |
| 8 | `atr_ok` | 0/1 | 1 se `AtrOk` lascerebbe passare (0 = il filtro ATR l'avrebbe bloccato: la riga esiste lo stesso) |
| 9 | `adx` | numero | ADX(14) alla barra di conferma (anche se `ADX_Apply_On_Purple=0`) |
| 10 | `pos_id` | intero | `POSITION_ID` se `OPENED`, altrimenti 0 |
| 11 | `entry_ref_price` | prezzo | ask (long) / bid (short) al primo tick della barra 0; se `OPENED` coincide con `open_price` |
| 12 | `atr_sig` | prezzo | ATR(14) della barra `iSig` (quello che dimensiona lo SL) |
| 13 | `risk_dist` | prezzo | `atr_sig x SL_ATR_Mult` |
| 14 | `sl_price`, 15 `tp_ini` | prezzo | SL e TP che l'ordine avrebbe (TP = mediana BB della barra `iCnf`) |
| 16 | `spread_entry_pts` | punti | spread al primo tick della barra 0 |
| 17 | `point`, 18 `pip_size` | prezzo | vedi convenzioni |
| 19-22 | `cnf_open`, `cnf_high`, `cnf_low`, `cnf_close` | prezzo | barra di CONFERMA (`iCnf`): e' "la candela del segnale" per le regole V2/V3/V5 |
| 23-26 | `sig_open`, `sig_high`, `sig_low`, `sig_close` | prezzo | barra `iSig` |
| 27 | `imp_bars_ago` | intero | `relImpDown`/`relImpUp` (barre fra l'impulso e il segnale) |
| 28-30 | `bb_up_cnf`, `bb_lo_cnf`, `bb_mid_cnf` | prezzo | bande alla barra di conferma |
| 31 | `bb_width_ratio` | numero | larghezza BB / media a `BB_Width_Len` (la grandezza di `isBulgeSig`, **solo registrata**: il VIOLA non la usa) |
| 32 | `atr_ratio` | numero | ATR barra 1 / sua media a `ATR_MA_Len` (quello che `AtrOk` confronta con 0,5-1,8) |
| 33 | `lots`, 34 `risk_money` | lotti, valuta | se `OPENED` |
| 35-38 | `commission`, `swap`, `profit`, `net` | valuta | somma su tutti i deal della posizione; `net = profit + commission + swap` |
| 39 | `open_time`, 40 `open_price` | tempo, prezzo | `DEAL_TIME`/`DEAL_PRICE` del deal IN (se `OPENED`) |
| 41 | `exit_time`, 42 `exit_price` | tempo, prezzo | ultimo deal OUT |
| 43 | `exit_reason` | testo | `tp`, `sl`, `end` (fine test), altro |
| 44 | `mfe_r`, 45 `mae_r` | R | massimo favorevole / avverso **tick a tick** (nel tester: sui tick del modello scelto) fra apertura e chiusura, in R |
| 46 | `bars_held` | intero | barre H1 attraversate |
| 47 | `exit_after_path` | 0/1 | 1 se l'uscita reale cade oltre la fine del percorso del File 2 |

## 3. File 2 -- percorso: `abtg_tel_path_<EA>_<simbolo grafico>_<magic>.csv` (righe per `sig_id`)
Una riga per barra, per OGNI segnale (anche non aperto), con prezzi **bid**:
| Colonna | Significato |
|---|---|
| `sig_id` | chiave verso il File 1 |
| `tf` | `M1` oppure `H1` |
| `k` | indice: per `M1`, minuto dall'apertura della barra di entrata (0..179 = **tre ore**: candela di entrata + due successive); per `H1`, ora dall'apertura della barra di entrata (3..119 = fino a 5 giorni) |
| `t_open` | tempo server di apertura della barra |
| `o`, `h`, `l`, `c` | OHLC bid |
| `spread_pts` | spread (punti) della barra, come `MqlRates.spread` |
| `mid1` | mediana BB(20) della barra H1 numero 1 **in quell'istante** (la quantita' che `UpdateAllTP` usa come TP): cambia una volta all'ora, si ripete sulle righe M1 della stessa ora |
| `atr1` | ATR(14) della barra H1 numero 1 in quell'istante |
Ordine delle righe: `sig_id`, poi `tf` (M1 prima), poi `k`. Righe mancanti (buco di storico, weekend) **non si riempiono**: si saltano; `k` resta l'indice nominale.

## 4. Volume e costo [STIMA, NON MISURATO]
Segnali grezzi: R92BAB VIOLA fa ~4,6 al giorno su 22 cross; sulla cella a 15 cross 2010-2026.06 l'ordine e' 5.000-20.000 segnali. Righe di percorso: ~300 per segnale -> 1,5-6 milioni di righe (~100-400 MB in ASCII). Se troppo, si abbassa `k` M1 a 0..119 e H1 a 2..71 **dichiarandolo nell'intestazione commento**. Nessun costo aggiuntivo di tester oltre alla scrittura (da misurare nel P0).

## 5. Invarianti da controllare appena arriva il file (script `sim_bulge_viola_uscite.py --controlla <cartella>`)
1. P0 sui totali (vedi 0.1).
2. `sum(net)` delle righe `OPENED` = `Profit` del CSV di OptResults (se differisce, e' lo stesso buco dei -203,65 di R92BAB: da spiegare prima di leggere un PF).
3. `bar_open_time` e' sempre sull'ora piena (secondi 0); primo `M1` di ogni `sig_id` ha `t_open = bar_open_time`.
4. Ogni `OPENED` ha `pos_id > 0` e `entry_ref_price = open_price`.
5. **Rigioco di base**: la ricostruzione dell'uscita dal percorso (SL a `sl_price`, TP dinamico da `mid1`, ordine pessimistico dentro la barra) deve coincidere con `exit_reason`/`exit_time` reali su >= 95% delle `OPENED`; sotto, lo script dichiara che la simulazione offline **non e' valida** per quella cella.
6. `outcome != OPENED` solo se esiste un motivo (`BLOCK_*`/`SKIP_*`).

## 6. Cosa questo formato NON da' (dichiarato)
- Il tracciato dentro la barra M1 (l'ordine fra massimo e minimo): lo script usa l'ipotesi **pessimistica** (prima il lato avverso) e la dichiara. Il tester a Modello 1 genera i suoi tick dalle M1: la simulazione offline vede la stessa informazione, **non** i tick reali (verdetto = tick reali, regola R57).
- Il costo d'uscita reale (slippage): si usa lo spread di barra.
- Notizie/eventi: nessun calendario nel repo.
- Il campo: il formato vale solo per il banco.
