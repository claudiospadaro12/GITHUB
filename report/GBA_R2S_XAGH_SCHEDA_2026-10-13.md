# GBA R2S: l'ARGENTO A TF PIÙ ALTI (M30, H1, H4), misura R-XAG-1 (scheda, 13/10/2026)

**Stato: riga in cancello (13/10/2026), pin `f6571dccbbc5ae07cf73a4310146a7912cfd73fb`, riga al commit `8686de85` (SHA `4d0064d4…`, corretta dal verificatore).** Lettore D2 v4 `leggi_gba_r2s_c3g.py` PASS (SHA256 `1697135a2ba01a27803dace9e72089df52b820c663a671c16869e58304a07b07`, commit `85542985`). Richiesta di Claudio del 13/10: **"SI PREPARA ANCHE QUELLA"**.
Fonte delle attese: `docs/RISPOSTA_A_GEMINI_GBA_R2S_XAG2_LETTURA_2026-10-13.md`, versione **corretta dal cancello** (commit `584545d3`, SHA256 `3cc5970b…`), regola R-XAG-1.

| oggetto | file | SHA256 |
|---|---|---|
| file prova (lotto `R2SXAGH`) | `backtest_pipeline/prove/GBA_R2S_XAGUSDH_2026-10-13.txt` | `fd8d997d2518e58ecc684a54caa4268cb4fa5b4c268171e51509f97575e2c049` |
| riga di lancio (pin `f6571dcc`, commit `8686de85`) | `backtest_pipeline/righe/RIGA_LANCIA_GBA_R2S_XAGH.txt` | `4d0064d40df3055af0261a929bd7fe367ad6991a6a047b2319a84a052ab6416d` |
| file madre | `backtest_pipeline/prove/GBA_R2S_XAGUSD2_2026-10-12.txt` | `dbe11bc3…` (PASS, girato al pin `d53493a9` il 13/10) |
| EA / include / driver | invariati: `1381E3DC…` / `3EC97115…` / `GBA_R0_PASSATE.ps1` v5 `C239F628…` | ricalcolati a HEAD `584545d3`: uguali |

## 1. 🛠️ Il disegno (le clausole Y1-Y7 sono nel file prova)
- **Un lotto, `R2SXAGH`**, asse `InpSignalTF`, **3 celle**: `M30 = 30`, `H1 = 16385`, `H4 = 16388`. 🔴 Sono i codici `ENUM_TIMEFRAMES` di MQL5, gli **unici** che il driver v5 accetta (`TF_NOMI` r.126, validazione r.198): **60 e 240 il driver li rifiuta** (provato, §4). Il pin `InpSignalTF` resta 1: nessuna cella REPL (il driver v5 la ammette facoltativa).
- Modello 1, T1 2026.07.01-09.30, lotto fisso 1,00, deposito 1.000.000 EUR, magic 775800, i **30 pin identici** al file madre (diff vuoto). Passate `R2SXAGH_01_M30_T1_m775800`, `_02_H1_`, `_03_H4_`.
- **Timeout per passata 45 → 20 minuti, tetto del lotto 50** (Y3): il 13/10 H-ZERO-R è stata **smentita** (la REPL argento con n = 0 si è chiusa in 33 s), e nessuno dei due stalli misurati su questo PC si è risolto da solo prima del timeout. Con tetto 50 la terza passata parte anche dopo **due** stalli pieni (2 × 21,6 = 43,3 minuti).
- **Ancora: non si rigira.** CE1H = ancora del 12/10 (`GBA_R0_R2SANC.zip`, SHA256 `259f4ba0…`, come la usa D2 v3) **e** CE7H del giro nuovo.
- Il testo generico del file madre (righe 94-276: DRIVER E LETTORE, L1-L7, SOGLIE, CE2-CE6, ESITI ed ECCEZIONE n = 0) è copiato **byte per byte**; i **deittici** (classe 1387) sono sostituiti in Y7: celle e lotto, "M1 dell'argento [NON MISURATO]" (ora misurato), le ATTESE e SMENTITE, il CE1 "stesso giro", e il CE2 `XAGUSD M..` che **alla lettera farebbe rossa la H1 e la H4**.

## 2. 🎯 Attese, smentite ed esiti (scritti prima dei numeri, nel file prova)
| cella | righe segnale [INFERITO] | C3G cella [INFERITO, base M15] | classe S2 attesa | smentita (SH1) | n ingressi |
|---|---|---|---|---|---|
| M30 | ~180 | 16-18x | FRA | nessuna banda in R-XAG-1: si scrive il numero | 0-10 |
| H1 | ~90 | 21-27x | FRA | fuori **17-34x** | 0-12 |
| H4 | ~20 (< 30 probabile) | 39-62x | a cavallo di 40x | fuori **31-75x** | 0-14 |

- **Soglie dell'argento: S = 6,65x** (E1-E4 + ordine di E3, R3 governata da E3). 13,3-40x è **FRA**, non "escluso": un H4 a 30x **non** è "escluso per costo".
- 🔴 **Conseguenza strutturale**: la (i) vuole una fascia da ≥ 100 righe e la (iv) ≥ 100 righe **per lato**, quindi ≥ 200 righe nella cella. A H1 (~90) e H4 (~20) **ESCLUSA non è raggiungibile, qualunque C3G esca**: con questo lotto la casella 5 dell'argento **non si chiude** a H1 e H4. ESCLUSA (Modello 1) è raggiungibile solo a M30, e solo con l'esponente crollato (C3G < 6,65 contro 11,95 della M15).
- **Esito atteso**: tutte e tre "n insufficiente a Modello 1 su una tranche (NON escluso)". A H4 "C3G ≥ 40x" e "FRA" sono un testa o croce scritto prima.
- **Albero per cella**, il primo che vale decide: **H0 (C)** controlli (KO diversi da "ZERO operazioni", CE1H/CE2/CE4/CE6/CE9/CE10, CE3 con ingressi, **0 segnali = quantificatore vuoto**, tentati > 0 con n = 0) → **H1 (A)** n netto ≥ 30 e "solo spread" ≥ 40x → **H2 ESCLUSA (Modello 1)** (i)-(v), da confermare con E3 → **H3 n insufficiente**. Le quattro voci coprono tutte le combinazioni. **Nessun esito chiude la casella 4 o la 5**; nessun PF letto come merito (motivo che resta vero: **regime unico**, classe 1384); lati separati.
- **H4 con 0 segnali**: H0, C3G **NON DEFINITO** (né 0 né infinito), SH1 non valutabile, "0 segnali in T1" scritto accanto; si legge la storia (CE10).
- **Righe fra 40x e 50x** stampate per ogni cella: a H4 sono la misura della spiegazione (b) di Gemini (100% scartato con C3G 40-50x è **possibile**). R-XAG-3 è misurata solo a M1/M15.

**Controlli in più (di strumento: tolgono la lettura, mai danno un esito)**
- **CE7H**: in ogni passata `XAGUSD,<TF>: 353614 ticks` (colonna `ticks_gen` del MANIFEST), tolleranza zero. [MISURATO: 353.614 il 12/10 a M1, il 13/10 a M1 e a M15.] Vede storia M1 accorciata/allungata e generatore cambiato; **non vede** prezzi o spread M1 riscritti a parità di tick (decisione aperta 1).
- **CE9** filtro = costo: `L_lt ≤ S_sp ≤ L_lt + L_eq` (righe libere < 50,0 / scartate per spread / stampate 50,0). Contro-esempio: un ingresso stampato 42,0x la fa rossa.
- **CE10** riscaldamento: righe `[GBA] dati non pronti` = 0 [MISURATO a M1 e M15; a H4 l'EMA 100 chiede ~17 giorni di storia prima del 01/07: NON MISURATO]; anche una sola → cella (C).

## 3. ⏱️ Bersaglio e tempo
- 🖥️ **Solo una finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`**, terminale `C:\Program Files\BCM Markets MT5 Terminal` (demo **50503392**), solo Strategy Tester, `AllowLiveTrading=false`. Guardie, elenco NON TOCCATI (VPS, reale 10105439, FTMO…), mutex e stampa PID/titolo/cartella: **identici** alla riga XAG2 (PASS).
- **Un solo giro GBA alla volta**: si lancia dopo che qualunque altro giro GBA (per esempio la conferma a tick reali `R2S XAGT`) ha stampato la sua riga finale con rc.
- **Tempo atteso 3-6 minuti** (3 passate da 30-45 s: 33 e 41 s il 13/10). **Non fermarla prima di 85 minuti** = download 1 + compilazione fino a 3,1 + tetto 50 + ultima passata fino a 21,7 + zip e raccolta ~3 = ~79, più 6 di margine.
- Raccolta: `Desktop\GBA_R2S_XAGH.zip` con `GBA_R0_R2SXAGH.zip` + `ESITI_R2S_XAGH.txt`.

## 4. ✅ Controlli eseguiti (worktree, nessun MT5)
- `controlla_prova.py`: **OK** (31 pin, 0 problemi). `controlla_riga.py --oggetto prova`: nessun difetto meccanico.
- **Parsing vero del driver v5** (r.91-247, 341-472, 593-651) in `pwsh`: prima **validato** rigenerando l'ini archiviato `gba_R2SXAG2_01_M15_T1_m775800.ini` (**identico**); poi sul file nuovo: lotto `R2SXAGH`, 3 passate, Modello 1, tetto 50; tre ini `Symbol=XAGUSD`, `Period=M30/H1/H4`, `Model=1`, T1, `InpSignalTF=30/16385/16388`, `InpMagic=775800`, `AllowLiveTrading=false`; righe AVVIO attese `PERIOD_M30/H1/H4`. **Contro-esempio**: H1 scritto `60` → il driver si ferma ("non e un codice ENUM_TIMEFRAMES").
- `controlla_riga.py --riga`: sulla bozza l'unico bloccante è il **PIN** (atteso); con un commit vero del repo al suo posto: **nessun difetto meccanico** (rilievi: i conti e le cartelle nominati nell'elenco NON TOCCATI, come nella riga XAG2).
- **Parser + `StaticParameterBinder::BindCommand`** su tutti gli 84 comandi della riga: 0 errori di parsing, 0 problemi (solo i falsi positivi noti di `Set-Content -Encoding/-NoNewline`). **Contro-esempio classe 1385** (`-ForegroundColor Cyan` ripetuto): il binder lo trova.
- Riga costruita dalla riga XAG2 con **15 sostituzioni**, ognuna controllata per numero di occorrenze; nessun residuo `XAG2`; ASCII puro; `$LOTTI` a un elemento con la forma `@(,@(...))` della riga modello.

## 5. 📖 Cosa serve a D2 (`leggi_gba_r2s_c3g.py`, lo sta scrivendo un altro agente: qui NON toccato)
D2 v4 (SHA256 `1697135a…`, commit `85542985`, 247 autotest OK) legge questo zip; i punti che seguono sono implementati. (Storico: D2 v3 `77F1F72E…` lo rifiutava.) Servivano:
1. `LOTTI["R2SXAGH"]`: prova `GBA_R2S_XAGUSDH_2026-10-13.txt`, sha `fd8d997d…c049`, simbolo `XAGUSD`, celle `[("M30","M30"),("H1","H1"),("H4","H4")]`, **S = 6,65**, pin = quello della riga XAGH, tag `R2SXAGH_01_M30_T1_m775800` / `_02_H1_` / `_03_H4_`.
2. `TF_NUM` con **`M30 "30"`, `H1 "16385"`, `H4 "16388"`** (oggi solo M1/M5/M15).
3. `ESITI_R2S_XAGH.txt` e il giro `("R2SANC","R2SXAGH")`, letto **solo** con l'ancora del 12/10 (SHA `259f4ba0…`).
4. 🔴 **Orologio a H4**: D2 r.264-267 rifiuta l'intero zip se l'ora della riga ≠ ora server. A H4 la barra della **domenica** apre alle 20:00 e il primo tick è alle **23:00** (riapertura settimanale dell'argento [MISURATO: le 71 righe M1 di domenica sono tutte alle 23; nessuna riga alle 22 = pausa]). Su 13 domeniche, con ~6,5% di barre con segnale, ~0,85 righe attese: **un rifiuto è più probabile che no** [INFERITO]. Serve: a H4 ora della riga in `[ora, ora+3]`, stesso giorno, `ora` multiplo di 4. A M30 e H1 non cambia nulla.
5. CE1H (ancora + CE7H su `ticks_gen` = 353614), CE9 e CE10 stampati per cella; righe ≥ 40x e ≥ 50x per cella (già ci sono); l'albero H0-H3 nell'ordine scritto.
6. E3(1): se una cella esce "ESCLUSA (Modello 1)", la conferma a tick reali va letta con **lo stesso SHA256 di D2**.

## 6. ⚪ Cosa NON è stato verificato
- La riga intera non è stata girata (solo Windows, solo il PC di backtest). Che il tester carichi la storia H4 **prima** del 01/07 per il riscaldamento (CE10 lo rileva). Che i tick generati restino 353.614 sopra M15 (CE7H, se no: tutto (C)). Che il report porti `Periodo` come `H1 (…)` e `H4 (…)` (il driver lo pretende; mai visto a H1/H4 con questo EA). Le stime di righe, C3G e n sono **[INFERITO]**.
- Le passate a Modello 4 dell'argento di luglio (`valida_realtick.ps1`, XAGUSD H4, altri EA) sono un **indizio** che la storia a tick esista sul PC, non una prova; qui non servono (Modello 1).

## 7. 🙋 Decisioni aperte
1. **Cella testimone M15** (+~40 s): renderebbe CE7H un controllo a tolleranza zero sul giornale (384 righe, C3G 11,95, BUY 12,20 / SELL 11,80 del 13/10) e coprirebbe il buco "prezzi M1 riscritti". Il disegno richiesto è a 3 celle: non aggiunta.
2. **DECISO: timeout 20 (nella riga). Alternativa scartata, 45 come XAG2**: con 45 il caso peggiore sale a ~155 minuti, senza una lettura in più misurata.
3. **FATTO: D2 v4 PASS** con i punti del §5, passato dal cancello **prima** di aprire lo zip (senza, CE9 non è valutabile e tutte le celle sono (C)).
