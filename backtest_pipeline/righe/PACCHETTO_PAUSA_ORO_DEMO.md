# 🟡 PACCHETTO PAUSA ORO DEMO — la PROCEDURA del blocco (f) della sedia oro long FTMO (27/09/2026)

**Stato: PROCEDURA, non esecuzione. Niente e' stato fatto sul VPS. Niente e' firmato.** Questo documento e' il
blocco **(f)** della catena scritta in `report/SEDIA_ORO_LONG_FTMO_BOZZA_2026-09-27.md` (§② riga (f) e §⑧.4): *"cosa fare
delle sedie oro del piccolo, di Tickmill e del manuale e' una firma di Claudio, e 🔴 e' un BLOCCO: senza, l'attacco (d) non
si fa"*. Qui c'e' **che cosa si mette in pausa, dove, come, quando e come si verifica** — con ogni riga passata dal cancello
deterministico (§⑧). Il cancello di giudizio (agente `controllo-preventivo`) ha dato **FAIL sulla prima stesura** (`74e94396`): i difetti
sono corretti in questo file e scritti in §⑧.

Fonti (tutte lette, non copiate dalla bozza): `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260927_033003.log`
(sedie attaccate per cartella dati, con lati) · `CODA_03_conti_dei_terminali_20260927_033003.log` (conto letto dal giornale)
· `CODA_05_foto_fresca_20260927_033003.log` (terminale vivo o muto) · `CODA_08_preset_dai_chr_20260927_033003.log` (gli input
di ogni sedia) · `CODA_09_giornale_operativo_20260927_033003.log` (gli ordini veri del 22 e 23/09) · `REFERTO_RUNNER_20260927_033003.txt`
(12 righe eseguite, corsia ROUND 0) · `mql5/Experts/Gold_Ichimoku_TK_ATR_EA.mq5` r.49-53 e r.92 · `mql5/Experts/ABTG_ScalperDirezionale.mq5`
r.96, r.125-126 · `report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` (il modello: la sospensione delle 15 sedie indice) ·
`docs/RISPOSTA_SUPPORTO_FTMO_2026-09-24.md` (Xavier Rocha) e `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` (Jonas Friedrich) ·
`backtest_pipeline/righe/SOSPENDI_SEDIE_PICCOLO_CHR.ps1` (intestazione) · `backtest_pipeline/controlla_riga.py` (tabella
`BERSAGLI_PER_MACCHINA`: il PC di backtest e' loggato sul `50503392`) · `CLAUDE.md` (regola dei terminali multipli, ampliamento
del 12/09, regola delle righe).

---

## ⓪ 🎯 IN UNA RIGA

Il giorno in cui la sedia oro **solo long** va sul conto FTMO `541452707` (`C:\FTMO`), **cinque sedie oro** che vivono altrove
possono stare **short** sull'oro mentre FTMO e' long — e FTMO ha scritto che questo e' hedging fra conti, **demo compresi**,
**anche se accidentale**, **senza soglia**. Le cinque: sul piccolo `50503392` la `770402` (MaxMinNotte, L+S), la `971501`
(EMA200_Ottimizzato, L+S), la `970901` (SupertrendReversal_Ottimizzato, L+S); sul manuale `50503635` la `779901` (scalper
in modo **CANDELA / MEZZO CORPO**: verso deciso **da solo** a ogni candela M1, verde = long, rossa = short = **L+S
per costruzione**); su Tickmill la `250604` (Ichimoku, lati non letti dalla sonda = si
tratta come L+S). La `772343` (PunteLarry XAUUSD, **solo long**) **resta**: stesso verso, permesso per iscritto. 🟢 **Buona
notizia misurata**: oggi il piccolo e' **chiuso** dal 23/09 19:35 e Tickmill dal 20/07 — quindi da quei due terminali, adesso,
non parte niente. 🔴 **Cattiva notizia misurata**: chiuso il terminale, **restano sul server** le posizioni e i pendenti
(sul piccolo il 23/09 alle 03:25 c'era una posizione XAUUSD `#3430899` gestita dalla `971501` — short, dal TP 4262,42 del suo
SELL LIMIT: se sia ancora aperta **[NON MISURATO]**), e il conto `50503392` e' loggato **anche sul PC di backtest
`DESKTOP-H4D7CAJ`**, che nessuna sonda vede.

---

## ① 📩 IL FATTO — che cosa ha scritto FTMO, per iscritto

- **24/09 (Xavier Rocha, `RISPOSTA_SUPPORTO_FTMO_2026-09-24.md`)**: *"hedging across multiple trading accounts is strictly
  prohibited. This includes any form of trading that involves opening opposite positions irrespective of the entity/company
  (prop firms/brokers)"*. Stesso conto: permesso.
- **25/09 (Jonas Friedrich, `RISPOSTA_SUPPORTO_FTMO_2026-09-25.md`)**, punto per punto: **(1)** vale anche se l'esposizione
  opposta sta su un **demo** di un altro broker; **(2)** vale anche se e' **accidentale**; **(3)** vale **in Challenge**;
  **(4)** vale sugli strumenti **correlati**, e FTMO **non da' una lista**; **(5)** copiare la stessa strategia **nello stesso
  verso** e' *"generally allowed"*; **(6)** **nessuna soglia** di durata o taglia: *"avoid having opposite exposure across
  different accounts altogether at any time"*.
- La sospensione del 25/09 ha spento gli **indici** e ha scritto (`SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`, «Cosa resta fuori»):
  *"le sedie oro/forex del piccolo restano accese. FTMO non ha sedie su quei simboli"*. **Con una sedia oro su FTMO quella frase
  smette di essere vera.** Uno short della `770402` sul piccolo aperto mentre il long FTMO e' in campo e' la fattispecie
  letterale del punto (2).

---

## ② 📋 LE SEDIE ORO, TERMINALE PER TERMINALE — verificate alla fonte

Legenda lati: **L+S** = `InpAllowLong=true` e `InpAllowShort=true` letti dal `.chr`; **SOLO LONG** = `InpAllowShort=false`;
**IGNOTO** = l'EA non ha quegli input (la sonda stampa `-`) → **si tratta come L+S**. La colonna «fonte» dice **dove sta il
numero**: se manca, il numero non vale.

| terminale (conto) | cartella programma / cartella dati | magic | EA · simbolo · TF · rischio | lati | fonte della riga | azione |
|---|---|---|---|---|---|---|
| piccolo **`50503392`** | `C:\Program Files\BCM Markets MT5 Terminal` (SENZA `-V3`) / `215D85D767A1C39E22D242C8114BF9F5`, profilo `ORO` | **`770402`** | `ABTG_MaxMinNotte` · XAUUSD · M15 · 0,5 | **L+S** | CODA_01 27/09 `[ORO\chart29.chr]`; CODA_08 r.1292-1293 `InpAllowLong=true` / `InpAllowShort=true`; **fatto**: CODA_09 giorno 20260923, 08:00 ora VPS = 07:00 BCM: `BUY STOP @ 4371.75` **e** `SELL STOP @ 4330.70` piazzati insieme | 🔴 **PAUSA** |
| piccolo `50503392` | idem | **`971501`** | `ABTG_EMA200_Ottimizzato` · XAUUSD · H4 · 0,25 | **L+S** | CODA_01 `[ORO\chart34.chr]`; CODA_08 r.1373-1374; **fatto**: CODA_09 20260922 13:00 `SELL LIMIT 1/2`, 20260923 03:25 `modify position #3430899 XAUUSD (sl 4345.65, tp 4262.42)` = posizione **short** viva quella notte | 🔴 **PAUSA** |
| piccolo `50503392` | idem | **`970901`** | `ABTG_SupertrendReversal_Ottimizzato` · XAUUSD · H4 · 1 | **L+S** | CODA_01 `[ORO\chart36.chr]`; CODA_08 r.1452-1453; CODA_09 20260922 17:00 `buy stop` (rifiutato, invalid price) | 🔴 **PAUSA** |
| piccolo `50503392` | idem | `772343` | `ABTG_PunteLarry` · XAUUSD · H1 · 0,3 | **SOLO LONG** | CODA_01 `[ORO\chart13.chr]` «SOLO LONG»; CODA_08 r.630-631 `InpAllowLong=true` / `InpAllowShort=false` | 🟢 **RESTA** — stesso verso del long FTMO (Jonas, punto 5). Se un giorno FTMO dicesse che anche il copy demo conta, e' una sedia sola da togliere |
| **PC di backtest `DESKTOP-H4D7CAJ`**, **stesso conto `50503392`** | `C:\Program Files\BCM Markets MT5 Terminal` (tabella `BERSAGLI_PER_MACCHINA` di `controlla_riga.py`) / cartella dati **[NON MISURATA]** | **[NON MISURATO]** | **[NON MISURATO]**: nessuna sonda gira li' | — | `SOSPENSIONE` «Cosa resta fuori»; classe 826; il 14/08 da li' sono partiti ordini veri (#3160534/#3160535) | 🔴 **GUARDARE A MANO** (§④.2) e mettere in pausa ogni sedia oro non solo-long che ci sia |
| manuale **`50503635`** | `C:\MT5_MANUALE` / `CF6C240A869369695913FB76DA84BD22`, profilo `Default` | **`779901`** | `ABTG_ScalperDirezionale (4)` · XAUUSD · M1 · (lotti a scalini 0,01→0,10, `InpPositions=8`) | **L+S, letto**: il preset e' `InpEntryMode=1` = `ENTRY_CANDELA` (CODA_08 r.2470; sorgente r.97 e r.102) con `InpCandleRule=4` = `CR_MEZZO_CORPO` (r.2472; sorgente r.98, r.779-793: *"precedente VERDE e prezzo sopra la meta' = long; ROSSA e sotto = short"*): il verso lo decide **l'EA, candela per candela**. `InpDirection=0` (r.2489) vale **solo nel modo MANUALE** (gruppo *"Verso e avvio (modo MANUALE)"*, sorgente r.124-125, e r.894): qui e' inerte. `InpAutoStart=false` (r.2490): parte col pulsante START. Binario in campo v1.07 del 25/09 22:31 (CODA_06 r.431), la prima con la regola 4 | CODA_01 `[Default\chart05.chr]` (il 25/09 non c'era: `SOSPENSIONE` r.83 «zero sedie»); CODA_08 r.2470-2490; CODA_09 20260925 22:53 cinque `market buy 0.01 XAUUSD [market closed]` | 🔴 **PAUSA** — e vale anche per le operazioni **a mano** sull'oro su quel conto: e' lo stesso divieto |
| **Tickmill** (conto **[NON MISURATO]**: CODA_03 «NON TROVATO nei giornali recenti») | `C:\Program Files\Tickmill Europe MT5 Terminal` / `857385E4B0F2356AD99AA95CDF40FAE9`, profilo `Default` | **`250604`** | `Gold_Ichimoku_TK_ATR_EA` · XAUUSD · M5 · 0,5 | **IGNOTO → L+S**. Indizio, dichiarato per quello che vale: il `.chr` porta `InpTradeDirection=1` (CODA_08 r.2327) e nel sorgente in repo `1 = DIR_LONG_ONLY` (r.49-53), identico dall'importazione del 04/08 (`188499a0`); ma il `.mq5` sul terminale Tickmill e' del **17/06/2026** (CODA_06 r.359, 708 righe, v3.00) e il **binario non e' verificato** | CODA_01 `[Default\chart01.chr]` lati `-`; CODA_05: ultimo log Esperti **20/07/2026 22:19** = terminale chiuso da due mesi | 🔴 **PAUSA** = **non riaprire Tickmill** finche' la sedia oro FTMO e' in campo; se si riapre, togliere l'EA prima |
| FTMO **`541452707`** | `C:\FTMO` / `46C9F8E9FF0C747B2B5E09BCC13D5237` | — | 9 sedie, **nessuna su XAUUSD** | — | CODA_01 27/09 | ⚪ **NON SI TOCCA** qui: e' il bersaglio del passo (d), che e' un altro pacchetto |
| REALE **`10105439`** | `C:\BCM_Reale` / `E23E1504A8D02A22179395F0652B86B6` | — | ORB EURAUD `770611`, Guardian `779002`, SlippageLogger: **zero oro** | — | CODA_01 27/09 | ⚪ **NON SI TOCCA, MAI** |
| 100k **`50504263`** | `C:\Program Files\BCM Markets MT5 Terminal -V3` / `BCA8AD18563BF5B64A433C2662D0A104` | — | profilo `SQUADRA 100K`: TradeExporter + Guardian; residui in `Default`: 6 (5 sedie **indice** + un Guardian), zero oro | — | CODA_01 27/09 | ⚪ **NON SI TOCCA** e **non si cambia profilo** (i residui tornerebbero in campo) |
| banco **`50504400`** | `C:\MT5_Backtest` / `04C7A32B575E40027B4FF8724D14D702` | — | 0 sedie; ultimo log 21/09 14:51 | — | CODA_01 + CODA_05 27/09 | ⚪ **SPENTO, resta spento** (firma del 21/09) |
| Pepperstone (demo `62128200` per `report/RUNNER_V3_IN_CAMPO_2026-09-12.md`; CODA_03: conto non letto) | `C:\Program Files\Pepperstone MetaTrader 5` / `73B7A2420D6397DFF9014A20F1201F97` | — | 0 sedie, nessun log | — | CODA_01/02 27/09 | ⚪ **NON SI TOCCA** |

Totale: **5 sedie in PAUSA** (3 sul piccolo + 1 manuale + 1 Tickmill), **1 RESTA** (`772343`), **1 buco da guardare a mano**
(PC di backtest). Nella bozza §⑧.4 i numeri sono gli stessi: qui sono stati **riletti dai referti**, non ricopiati.

---

## ③ 📸 LO STATO DEI TERMINALI OGGI (foto delle 03:30 del 27/09) — decide QUALE procedura vale

| terminale | vivo o chiuso | prova | conseguenza per la pausa |
|---|---|---|---|
| piccolo `50503392` (VPS) | 🔒 **CHIUSO dal 23/09 19:35** | CODA_05: ultimo log Esperti 23/09 19:35, «TERMINALE MUTO»; i `.chr` sono del 25/09 13:07 (scritti dalla riga di sospensione a terminale chiuso) | le sedie oro **non operano dal VPS**; ma **riaprire il terminale = 25 sedie che ripartono**, comprese le tre oro a due lati. E il conto puo' operare **dal PC di backtest** |
| PC di backtest `DESKTOP-H4D7CAJ` | **[NON MISURATO]** | nessuna sonda | va guardato a mano (§④.2) |
| manuale `50503635` | 🟠 **ultimo segno di vita 25/09 22:54**; se e' aperto adesso **[NON MISURATO]** (lo dice la riga di riconoscimento del §④) | CODA_05: profilo 25/09 22:40, ultimo log 25/09 22:54 (28,6 ore prima della sonda) | pausa **a mano dentro MT5** (§④.3) |
| Tickmill | 🔒 **CHIUSO dal 20/07/2026 22:19** | CODA_05 «l'ultimo log ha 1637 ore» | la `250604` e' inerte: la pausa e' **non riaprirlo** (§④.4) |
| FTMO, 100k `-V3`, REALE | FTMO e `-V3` vivi alle 03:28 / 03:11 del 27/09; REALE ultimo log 25/09 22:50 | CODA_05 | **non si toccano** |

🔴 **Quello che la foto NON dice**: le **posizioni e i pendenti sul server**. Stop e take profit vivono sul server del broker: un
terminale chiuso non li spegne. Sul `50503392` il 23/09 alle 03:25 la `971501` gestiva la posizione XAUUSD `#3430899` (short,
per il TP 4262,42 del suo SELL LIMIT del 22/09); se **oggi e' ancora aperta** e' **[NON MISURATO]** da qui (classe 792: l'unica
fonte a livello di conto e' lo **Storico** dell'app o del web terminal, che vede i deal di tutte le macchine). **Questa e' la
prima cosa da guardare, prima di qualunque rimozione.**

---

## ④ 🖥️🪟✋ TERMINALE PER TERMINALE — bersaglio, cosa NON si tocca, riconoscimento, passi, verifica

### Regola comune, prima di tutto (CLAUDE.md, regola dei terminali multipli + ampliamento del 12/09)
Ogni stringa qui sotto dice **in testa** su quale macchina si incolla e **si rifiuta di girare altrove** (`throw` sulla guardia
`$env:COMPUTERNAME`). Sul VPS `VMI3047753` convivono **otto cartelle dati** (CODA_01: banco, piccolo, FTMO, Pepperstone,
Tickmill, 100k `-V3`, manuale, REALE): *"gira sul VPS"* non e' un bersaglio, e' un indirizzo. Le finestre MT5 si riconoscono
dal **numero di conto nel titolo** e dalla **cartella in `Path`**, mai a occhio, con questa riga di sola lettura.

🖥️ **Bersaglio: finestra PowerShell sul VPS `VMI3047753`** (nessun MT5 da aprire: la riga stampa PID, titolo e cartella di
ogni MT5 aperto e basta). NON tocca: FTMO `541452707` (`C:\FTMO`), REALE `10105439` (`C:\BCM_Reale`), 100k `50504263` (`-V3`),
banco `50504400` (`C:\MT5_Backtest`), piccolo `50503392`, manuale `50503635`, Pepperstone, Tickmill. Se stampa `0`, ha
funzionato ma non vede nessun MT5 (utente diverso o processo elevato): fermarsi e dirlo.

```powershell
& { if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $p=@(Get-Process terminal64 -ErrorAction SilentlyContinue); Write-Host ('processi terminal64 vivi su questo VPS: ' + $p.Count); $p | Select-Object Id, MainWindowTitle, @{n='Path';e={ if($_.Path){ $_.Path } else { 'NON LEGGIBILE (processo di altro utente o elevato)' } }} | Format-List; Write-Host 'Questa riga LEGGE E STAMPA: nessun processo aperto o chiuso, nessun file scritto. Il terminale si riconosce dal NUMERO DI CONTO nel titolo e dalla CARTELLA in Path, mai a occhio.' }
```

(`Format-List`, non `Format-Table -AutoSize`: la classe 174 misura che `-AutoSize` tronca proprio la colonna `Path`, e ` -V3`
e' la prima cosa che sparisce.)

---

### ④.1 🪟 piccolo `50503392` — `C:\Program Files\BCM Markets MT5 Terminal` (SENZA `-V3`), cartella dati `215D85D7…`, profilo `ORO`

**Cosa NON viene toccato, per nome**: FTMO `541452707` (`C:\FTMO`); REALE `10105439` (`C:\BCM_Reale`); 100k `50504263`
(`C:\Program Files\BCM Markets MT5 Terminal -V3`: cartella dal nome quasi uguale, **la differenza e' il suffisso**); banco
`50504400` (`C:\MT5_Backtest`, spento); manuale `50503635` (`C:\MT5_MANUALE`); Pepperstone; Tickmill. **E sul piccolo stesso non
si toccano** le 19 sedie forex, la `772343` PunteLarry XAUUSD (solo long), TradeExporter e SpreadLogger (25 grafici con EA in tutto, CODA_01). 🚫 **Non si preme
`Algo Trading`** nella barra in alto se non nel ramo B qui sotto, e solo per i secondi che servono: spegne anche le forex.

**Il terminale oggi e' CHIUSO** (§③). Quindi ci sono **due rami**, e la scelta e' di Claudio:

**Ramo A — resta chiuso, si tolgono gli EA dai `.chr` (stesso metodo del 25/09).** E' il ramo che **non fa ripartire niente**.
Serve una riga **gemella di `RIGA_SOSPENDI_SEDIE_PICCOLO.txt`** (pin `b392f20d`, PASS dei due strati il 25/09) con una tavola di
**tre** sedie scelte **per contenuto** (nome EA + `XAUUSD` + magic `770402` / `971501` / `970901`), backup dell'intero profilo con
SHA256 file per file e `-Annulla` per tornare indietro, **a terminale chiuso** (lo script rifiuta di scrivere se `terminal64` del piccolo
e' vivo). 🔴 **Quella riga NON e' scritta qui**: scrive su disco, quindi e' un file nuovo che passa dai due cancelli e porta
una **firma di Claudio**. Cosa gia' misurato e da ricordare: `SOSPENSIONE` §ESEGUITO, «Da verificare (1)» — *"il comportamento
di MT5 su un `.chr` senza blocco `<expert>` [NON VERIFICATO]"*. Le 15 sedie indice sono state tolte cosi' e il terminale **non
e' stato riaperto da allora**: quella verifica e' **ancora aperta**.

**Ramo B — si riapre il terminale e si tolgono gli EA a mano.** 🔴 Riaprire il piccolo fa ripartire **25 sedie in un colpo**,
comprese le tre oro a due lati: si fa **solo a mercato dell'oro CHIUSO, cioe' nel weekend** (§⑤). 🔴 **Un feriale NON e' mai
sicuro, a nessuna ora**, letto nel codice: la `971501` e la `970901` partono con `gLastBar=0` (`ABTG_EMA200_Ottimizzato.mq5`
r.157 e r.348-354; `ABTG_SupertrendReversal_Ottimizzato.mq5` r.121 e r.283-289), quindi il **primo tick dopo la riapertura e'
una "barra nuova"** e valutano subito il segnale, **lontano o no dal cambio di candela H4**; la `770402` (`ABTG_MaxMinNotte.mq5`
r.267-290), se quel giorno non ha operato, fra le 07:00 e le 17:30 BCM **piazza BUY STOP e SELL STOP al primo tick** (dopo le
08:30 li cancella al tick successivo: vivono un tick, come misurato nella bozza §⑥ per la gemella FTMO, classe 866), e prima
delle 07:00 arma alle 07:00. Si apre con doppio clic sul programma `terminal64` **dentro la cartella `C:\Program Files\BCM Markets MT5 Terminal`**
(quella SENZA `-V3`: la cartella col `-V3` e' il 100k `50504263`, vivo) e, **prima di toccare qualunque cosa**, si rilancia la riga di riconoscimento in testa al §④: il
processo nuovo deve avere **`50503392` nel titolo** e un `Path` che sta nella cartella SENZA `-V3`.
✋ Dentro MT5 `50503392`, riconosciuto cosi':
0. **Scheda Trade** in basso: posizioni e pendenti su **XAUUSD**. Foto a Claudio (§⑥ punto 3). Togliere l'EA **non cancella
   un pendente** e **non chiude una posizione**.
1. Trovare il grafico **dal nome dell'EA in alto a destra**, non dal simbolo: sul piccolo ci sono **quattro** grafici XAUUSD
   (H1 PunteLarry `772343`, M15 MaxMinNotte `770402`, **H4 EMA200_Ottimizzato `971501`**, **H4 SupertrendReversal_Ottimizzato
   `970901`**: due H4, si distinguono solo dal nome). Classe 803, cosa si perde se si sbaglia grafico: togliendo la
   PunteLarry al posto di una delle tre si spegne l'unica sedia oro che doveva restare, e il suo BUY STOP pendente (se ce
   n'e' uno) resterebbe sul server senza chi lo gestisce.
2. Sul grafico giusto: **tasto destro → Expert Advisors → Rimuovi** (in alcune versioni: **Elenco esperti → Rimuovi**).
   L'icona in alto a destra sparisce; nella scheda **Esperti** compare *"expert … removed"*. Il grafico **resta aperto**.
3. Tre volte: `770402`, `971501`, `970901`.
4. **Spazzata** (classe 788): scorrere **tutte** le linguette in basso; ogni grafico **XAUUSD** con un EA in alto a destra che
   non sia `ABTG_PunteLarry` va tolto lo stesso e **scritto per nome** a Claude. La tabella e' la foto del profilo salvato
   (`.chr` del 25/09 13:07): un EA attaccato dopo non ci sta.
5. 🔴 **File → Profili → Salva profilo**, stesso nome **`ORO`**, conferma la sovrascrittura. Senza, al prossimo avvio le tre
   sedie tornano da sole, e la sonda `CODA_01` della notte non vede la rimozione (classe 822).
6. Il terminale poi si **richiude** (torna allo stato di oggi) oppure si lascia aperto con le forex: **scelta di Claudio**, ma
   se resta aperto vale la regola del passo 0 anche per le forex correlate (§⑦).

**Verifica dopo** (vale per tutti e due i rami). 🖥️ **Bersaglio: finestra PowerShell sul VPS `VMI3047753`**. La riga legge la
**sola cartella dati `215D85D7…`** dopo aver controllato che `origin.txt` dica proprio `C:\Program Files\BCM Markets MT5
Terminal`; stampa il profilo attivo, il conto letto dal giornale, ogni grafico con un EA (nome, magic, `InpAllowLong`,
`InpAllowShort`) e segna `<== ORO`; **attesa dopo la pausa: 1 grafico ORO con EA, e zero ORO che non siano solo-long** (la `772343`, `AllowShort=false`): il
verdetto guarda **quanti E quali** (un ORO `L+S` o con lati `-` lo fa rosso, e anche un file illeggibile). NON tocca e NON legge: FTMO
`541452707`, REALE `10105439`, 100k `50504263` (`-V3`), banco `50504400`, manuale `50503635`, Pepperstone, Tickmill. Non apre e
non chiude processi, non scrive file. Lanciata **prima** della pausa deve stampare **4** ORO (e' il contro-esempio: se
stampa 1 prima della pausa, la riga non misura).

```powershell
& { if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $ErrorActionPreference='Continue'; $INV=[Globalization.CultureInfo]::InvariantCulture; $H='215D85D767A1C39E22D242C8114BF9F5'; $ATT='C:\Program Files\BCM Markets MT5 Terminal'; $CHI='piccolo 50503392'; $PROFATT='ORO'; $ATTESO=1; Write-Host ''; Write-Host ('=== SEDIE ORO NEL PROFILO SALVATO -- ' + $CHI + ' -- cartella dati ' + $H + ' -- SOLA LETTURA -- ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss',$INV) + ' ora Windows del VPS ===') -ForegroundColor Cyan; Write-Host ('    bersaglio della LETTURA: ' + $ATT + ' (' + $CHI + '). NON tocca e NON legge: FTMO 541452707 (C:\FTMO), REALE 10105439 (C:\BCM_Reale), 100k 50504263 (BCM Markets MT5 Terminal -V3), banco 50504400 (C:\MT5_Backtest, spento), Pepperstone 62128200, manuale 50503635 (C:\MT5_MANUALE), Tickmill. Nessun processo aperto o chiuso, nessun file scritto.'); function Leggi($p){ $b=$null; try { $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite); $b=[byte[]]::new($fs.Length); [void]$fs.Read($b,0,$b.Length); $fs.Dispose() } catch { return '' }; if($null -eq $b -or $b.Count -lt 2){ return '' }; if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }; $z=0; $n=[math]::Min(400,$b.Count); for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $z++ } }; if($z -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }; return [Text.Encoding]::UTF8.GetString($b) }; $root=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $D=Join-Path $root $H; if(-not (Test-Path -LiteralPath $D)){ throw ('STOP: la cartella dati ' + $D + ' non esiste su questa macchina: non leggo niente') }; $o=Join-Path $D 'origin.txt'; if(-not (Test-Path -LiteralPath $o)){ throw ('STOP: manca ' + $o + ': senza origin.txt non so di quale terminale sono questi grafici') }; $orig=((Leggi $o) -replace '[^\u0020-\u007E]','').Trim(); if($orig -ne $ATT){ throw ('STOP: origin.txt dice [' + $orig + '] e non [' + $ATT + ']: hash e programma NON combaciano, non leggo') }; Write-Host ('    origin.txt = ' + $orig + '   COMBACIA con il programma atteso') -ForegroundColor Green; $ini=Join-Path $D 'config\common.ini'; $prof=''; $ti=Leggi $ini; if($ti -ne ''){ $m=[regex]::Match($ti,'(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.+?)[ \t]*$'); if($m.Success){ $prof=$m.Groups[1].Value.Trim() } }; if($prof -eq ''){ throw 'STOP: config\common.ini non dichiara ProfileLast (o non si legge): non so quale profilo carica il terminale e non lo indovino' }; Write-Host ('    profilo ATTIVO (config\common.ini, ProfileLast): ' + $prof + '   atteso dalla sonda CODA_01 del 27/09: ' + $PROFATT + '   ' + $(if($PROFATT -eq ''){'(nessun atteso: qui la sonda notturna non gira)'}elseif($prof -ieq $PROFATT){'COMBACIA'}else{'DIVERSO: leggere a mano prima di credere al resto'})); $lg=Join-Path $D 'logs'; if(Test-Path -LiteralPath $lg){ foreach($f in @(Get-ChildItem -LiteralPath $lg -Filter '*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 3)){ $tl=Leggi $f.FullName; $k=0; foreach($ln in ($tl -split '\r?\n')){ if($ln -match 'authorization|login on'){ if($k -lt 2){ Write-Host ('    giornale ' + $f.Name + ': ' + $ln.Trim().TrimStart([char]65279)) }; $k++ } } } } else { Write-Host '    (nessuna cartella logs: il conto non si legge dal giornale)' -ForegroundColor Yellow }; $PC=Join-Path $D ('MQL5\Profiles\Charts\' + $prof); if(-not (Test-Path -LiteralPath $PC)){ throw ('STOP: la cartella del profilo ' + $PC + ' non esiste') }; $files=@(Get-ChildItem -LiteralPath $PC -Filter 'chart*.chr' | Sort-Object Name); $ult='-'; if($files.Count -gt 0){ $ult=($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) }; Write-Host ('    file chart*.chr nel profilo ' + $prof + ': ' + $files.Count + '   ultimo salvataggio del profilo: ' + $ult + '   (i .chr sono la FOTO del profilo SALVATO: un EA attaccato dopo NON compare, classe 788)'); Write-Host '    --- ogni grafico con un EA sopra ---'; $oro=0; $orobad=0; $conEA=0; $ill=0; foreach($x in $files){ $t=Leggi $x.FullName; if($t -eq ''){ $ill++; Write-Host ('      ' + $x.Name + '   ILLEGGIBILE') -ForegroundColor Yellow; continue }; $sym='-'; $ms=[regex]::Match($t,'(?im)^[ \t]*symbol[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ms.Success){ $sym=$ms.Groups[1].Value.Trim() }; $ea=''; $mag='-'; $al='-'; $as='-'; $me=[regex]::Match($t,'(?is)<expert>(.*?)</expert>'); if($me.Success){ $blk=$me.Groups[1].Value; $mn=[regex]::Match($blk,'(?im)^[ \t]*name[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mn.Success){ $ea=$mn.Groups[1].Value.Trim() }; $mm=[regex]::Match($blk,'(?im)^[ \t]*InpMagic[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mm.Success){ $mag=$mm.Groups[1].Value.Trim() }; $ml=[regex]::Match($blk,'(?im)^[ \t]*InpAllowLong[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ml.Success){ $al=$ml.Groups[1].Value.Trim() }; $mh=[regex]::Match($blk,'(?im)^[ \t]*InpAllowShort[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mh.Success){ $as=$mh.Groups[1].Value.Trim() } }; if($ea -eq '' -or $ea -ieq 'Main'){ continue }; $conEA++; $eoro=($sym -match 'XAU|GOLD'); $seg=''; $col='Gray'; if($eoro){ $oro++; $seg='   <== ORO solo long'; $col='Yellow'; if(-not ($as -match '^(false|0)$')){ $orobad++; $seg='   <== ORO CON LATO SHORT POSSIBILE (L+S, o lati non letti = L+S)'; $col='Red' } }; Write-Host ('      ' + $x.Name.PadRight(12) + $sym.PadRight(12) + $ea.PadRight(42) + ' magic ' + $mag.PadRight(9) + ' AllowLong=' + $al.PadRight(6) + ' AllowShort=' + $as.PadRight(6) + $seg) -ForegroundColor $col }; Write-Host ('    RIEPILOGO: grafici con EA = ' + $conEA + '   di cui su ORO = ' + $oro + '   di cui NON solo-long = ' + $orobad + '   file illeggibili = ' + $ill + '   (AllowLong/AllowShort = - vuol dire che l EA non ha quegli input: i lati NON sono letti, si trattano come L+S)'); Write-Host ('    ATTESO DOPO LA PAUSA su ORO = ' + $ATTESO + ' (la sola ABTG_PunteLarry XAUUSD magic 772343, SOLO LONG, che RESTA)   ' + $(if($oro -eq $ATTESO -and $orobad -eq 0 -and $ill -eq 0){'COMBACIA (conta E lati: nessun ORO con lato short possibile, nessun file illeggibile)'}else{'NON COMBACIA: il verdetto guarda QUANTI e QUALI (un ORO L+S o con lati non letti rimasto, o la sedia solo-long tolta al posto di un altra, o un file illeggibile, bastano a farlo rosso); o la pausa non e completa, o e stato tolto il grafico SBAGLIATO, o il profilo non e stato salvato (File, Profili, Salva profilo), o e cambiato qualcosa: leggere la tabella qui sopra riga per riga'})) -ForegroundColor $(if($oro -eq $ATTESO -and $orobad -eq 0 -and $ill -eq 0){'Green'}else{'Red'}); Write-Host 'Questa riga LEGGE E STAMPA: non ha scritto, copiato, aperto, chiuso o modificato niente. Un pendente o una posizione sul SERVER non si vedono da qui: scheda Trade, oppure lo Storico del conto.' }
```

E la notte dopo `CODA_01_sedie_attaccate` (runner 03:30, sola lettura, `REFERTO_RUNNER` 27/09: 12 righe, corsia ROUND 0)
rilegge lo stesso profilo: al mattino la conferma arriva da sola, sedia per sedia.

---

### ④.2 🖥️ PC di backtest `DESKTOP-H4D7CAJ` — **stesso conto `50503392`** del piccolo, e nessuna sonda lo guarda

E' il buco piu' grande di questo pacchetto, ed e' scritto in tre posti (`SOSPENSIONE` «Cosa resta fuori», classe 826, tabella
del cancello): il MT5 di quella macchina (`C:\Program Files\BCM Markets MT5 Terminal`) e' loggato sul **`50503392`**, e il
14/08 da li' sono partiti ordini veri (#3160534/#3160535) che il VPS non ha mai visto. **Se li' c'e' un grafico XAUUSD con la
`770402`, la pausa fatta sul VPS non serve a niente.**

🖥️ **Bersaglio: finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`** (la riga si rifiuta di girare su qualunque altra
macchina). Non ci sono terminali FTMO/REALE/100k su quel PC per quanto ne sappiamo, ma la riga lo **dichiara** lo stesso:
NON tocca nessun terminale, nessun processo, nessun file. Prima il riconoscimento delle finestre:

```powershell
& { if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del PC di backtest DESKTOP-H4D7CAJ. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $p=@(Get-Process terminal64 -ErrorAction SilentlyContinue); Write-Host ('processi terminal64 vivi su questo PC di backtest: ' + $p.Count); $p | Select-Object Id, MainWindowTitle, @{n='Path';e={ if($_.Path){ $_.Path } else { 'NON LEGGIBILE (processo di altro utente o elevato)' } }} | Format-List; Write-Host 'Questa riga LEGGE E STAMPA: nessun processo aperto o chiuso, nessun file scritto. Il terminale si riconosce dal NUMERO DI CONTO nel titolo e dalla CARTELLA in Path, mai a occhio.' }
```

Poi la lettura di **tutte** le cartelle dati MT5 di quel PC (l'hash della sua cartella dati e' **[NON MISURATO]**, quindi la
riga non lo pretende: stampa ogni cartella con il suo `origin.txt`, il conto letto dal giornale, e i grafici ORO con un EA).
**Attesa mentre la sedia oro FTMO e' in campo: 0**, e lo zero vale **solo** se la riga ha letto la cartella del MT5 BCM
(`origin.txt` = `C:\Program Files\BCM Markets MT5 Terminal`, oppure installazione portable in quella cartella) senza buchi:
altrimenti stampa **NON CONCLUSIVO** in giallo, mai verde (classe 177), e il `50503392` da quella macchina resta [NON MISURATO].

```powershell
& { if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del PC di backtest DESKTOP-H4D7CAJ. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $ErrorActionPreference='Continue'; $INV=[Globalization.CultureInfo]::InvariantCulture; $PROFATT=''; Write-Host ''; Write-Host ('=== SEDIE ORO NEI PROFILI SALVATI DI OGNI CARTELLA DATI MT5 DEL PC DI BACKTEST DESKTOP-H4D7CAJ -- SOLA LETTURA -- ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss',$INV) + ' ora Windows del PC ===') -ForegroundColor Cyan; Write-Host '    Su questa macchina il MT5 (C:\Program Files\BCM Markets MT5 Terminal) e loggato sul demo 50503392, lo stesso conto del piccolo del VPS: cio che opera da qui la sonda notturna del VPS NON lo vede (14/08/2026: ordini veri partiti da qui). Questa riga NON tocca niente: nessun processo aperto o chiuso, nessun file scritto.'; function Leggi($p){ $b=$null; try { $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite); $b=[byte[]]::new($fs.Length); [void]$fs.Read($b,0,$b.Length); $fs.Dispose() } catch { return '' }; if($null -eq $b -or $b.Count -lt 2){ return '' }; if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }; $z=0; $n=[math]::Min(400,$b.Count); for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $z++ } }; if($z -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }; return [Text.Encoding]::UTF8.GetString($b) }; $root=''; if($env:APPDATA){ $root=Join-Path $env:APPDATA 'MetaQuotes\Terminal' }; if($root -eq '' -or -not (Test-Path -LiteralPath $root)){ throw ('STOP: non esiste la radice delle cartelle dati [' + $root + '] per l utente ' + $env:USERNAME + ': niente da leggere qui') }; $cart=@(Get-ChildItem -LiteralPath $root -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'MQL5') } | Sort-Object Name); $PF='C:\Program Files\BCM Markets MT5 Terminal'; if(Test-Path -LiteralPath (Join-Path $PF 'MQL5')){ $cart+=@(Get-Item -LiteralPath $PF); Write-Host ('    ATTENZIONE: ' + $PF + ' ha una sua cartella MQL5: installazione PORTABLE, la leggo come cartella dati') -ForegroundColor Yellow }; Write-Host ('    cartelle dati con MQL5: ' + $cart.Count); $totOro=0; $totBad=0; $totIll=0; $err=0; $bcm=0; foreach($cd in $cart){ $D=$cd.FullName; $o=Join-Path $D 'origin.txt'; $orig='(nessun origin.txt)'; if(Test-Path -LiteralPath $o){ $orig=((Leggi $o) -replace '[^\u0020-\u007E]','').Trim() }; Write-Host ''; if($orig -ieq $PF -or $D -ieq $PF){ $bcm++ }; Write-Host ('=== CARTELLA ' + $cd.Name + '   programma: ' + $orig) -ForegroundColor Cyan; try { $ini=Join-Path $D 'config\common.ini'; $prof=''; $ti=Leggi $ini; if($ti -ne ''){ $m=[regex]::Match($ti,'(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.+?)[ \t]*$'); if($m.Success){ $prof=$m.Groups[1].Value.Trim() } }; if($prof -eq ''){ throw 'STOP: config\common.ini non dichiara ProfileLast (o non si legge): non so quale profilo carica il terminale e non lo indovino' }; Write-Host ('    profilo ATTIVO (config\common.ini, ProfileLast): ' + $prof + '   atteso dalla sonda CODA_01 del 27/09: ' + $PROFATT + '   ' + $(if($PROFATT -eq ''){'(nessun atteso: qui la sonda notturna non gira)'}elseif($prof -ieq $PROFATT){'COMBACIA'}else{'DIVERSO: leggere a mano prima di credere al resto'})); $lg=Join-Path $D 'logs'; if(Test-Path -LiteralPath $lg){ foreach($f in @(Get-ChildItem -LiteralPath $lg -Filter '*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 3)){ $tl=Leggi $f.FullName; $k=0; foreach($ln in ($tl -split '\r?\n')){ if($ln -match 'authorization|login on'){ if($k -lt 2){ Write-Host ('    giornale ' + $f.Name + ': ' + $ln.Trim().TrimStart([char]65279)) }; $k++ } } } } else { Write-Host '    (nessuna cartella logs: il conto non si legge dal giornale)' -ForegroundColor Yellow }; $PC=Join-Path $D ('MQL5\Profiles\Charts\' + $prof); if(-not (Test-Path -LiteralPath $PC)){ throw ('STOP: la cartella del profilo ' + $PC + ' non esiste') }; $files=@(Get-ChildItem -LiteralPath $PC -Filter 'chart*.chr' | Sort-Object Name); $ult='-'; if($files.Count -gt 0){ $ult=($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) }; Write-Host ('    file chart*.chr nel profilo ' + $prof + ': ' + $files.Count + '   ultimo salvataggio del profilo: ' + $ult + '   (i .chr sono la FOTO del profilo SALVATO: un EA attaccato dopo NON compare, classe 788)'); Write-Host '    --- ogni grafico con un EA sopra ---'; $oro=0; $orobad=0; $conEA=0; $ill=0; foreach($x in $files){ $t=Leggi $x.FullName; if($t -eq ''){ $ill++; Write-Host ('      ' + $x.Name + '   ILLEGGIBILE') -ForegroundColor Yellow; continue }; $sym='-'; $ms=[regex]::Match($t,'(?im)^[ \t]*symbol[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ms.Success){ $sym=$ms.Groups[1].Value.Trim() }; $ea=''; $mag='-'; $al='-'; $as='-'; $me=[regex]::Match($t,'(?is)<expert>(.*?)</expert>'); if($me.Success){ $blk=$me.Groups[1].Value; $mn=[regex]::Match($blk,'(?im)^[ \t]*name[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mn.Success){ $ea=$mn.Groups[1].Value.Trim() }; $mm=[regex]::Match($blk,'(?im)^[ \t]*InpMagic[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mm.Success){ $mag=$mm.Groups[1].Value.Trim() }; $ml=[regex]::Match($blk,'(?im)^[ \t]*InpAllowLong[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ml.Success){ $al=$ml.Groups[1].Value.Trim() }; $mh=[regex]::Match($blk,'(?im)^[ \t]*InpAllowShort[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mh.Success){ $as=$mh.Groups[1].Value.Trim() } }; if($ea -eq '' -or $ea -ieq 'Main'){ continue }; $conEA++; $eoro=($sym -match 'XAU|GOLD'); $seg=''; $col='Gray'; if($eoro){ $oro++; $seg='   <== ORO solo long'; $col='Yellow'; if(-not ($as -match '^(false|0)$')){ $orobad++; $seg='   <== ORO CON LATO SHORT POSSIBILE (L+S, o lati non letti = L+S)'; $col='Red' } }; Write-Host ('      ' + $x.Name.PadRight(12) + $sym.PadRight(12) + $ea.PadRight(42) + ' magic ' + $mag.PadRight(9) + ' AllowLong=' + $al.PadRight(6) + ' AllowShort=' + $as.PadRight(6) + $seg) -ForegroundColor $col }; Write-Host ('    RIEPILOGO: grafici con EA = ' + $conEA + '   di cui su ORO = ' + $oro + '   di cui NON solo-long = ' + $orobad + '   file illeggibili = ' + $ill + '   (AllowLong/AllowShort = - vuol dire che l EA non ha quegli input: i lati NON sono letti, si trattano come L+S)'); $totOro+=$oro; $totBad+=$orobad; $totIll+=$ill } catch { $err++; Write-Host ('    ' + $_.Exception.Message + '   (questa cartella NON e letta: conta come buco, non come zero)') -ForegroundColor Yellow } }; Write-Host ''; Write-Host ('TOTALE grafici su ORO con un EA sopra, in tutte le cartelle dati lette: ' + $totOro + '   di cui NON solo-long: ' + $totBad + '   cartelle dati trovate: ' + $cart.Count + '   di cui del programma BCM (origin.txt o portable): ' + $bcm + '   cartelle NON lette: ' + $err + '   file illeggibili: ' + $totIll + '   ATTESO mentre la sedia oro FTMO e in campo: 0 ORO, con almeno 1 cartella BCM letta e 0 buchi'); if($totOro -gt 0){ Write-Host 'ESITO: NON COMBACIA -- c e almeno un grafico ORO con un EA: leggere la tabella, e ogni ORO non solo-long va tolto a mano (passi del ramo B)' -ForegroundColor Red } elseif($bcm -lt 1 -or $err -gt 0 -or $totIll -gt 0){ Write-Host ('ESITO: NON CONCLUSIVO, NON e un via libera (classe 177): lo zero vale solo se ho letto la cartella del MT5 BCM. Cartelle BCM trovate: ' + $bcm + ', cartelle non lette: ' + $err + ', file illeggibili: ' + $totIll + '. Se il MT5 BCM di questo PC gira con un altro utente Windows o da un altra cartella, la sua cartella dati non e qui: dirlo a Claude, il conto 50503392 da questa macchina resta NON MISURATO.') -ForegroundColor Yellow } else { Write-Host 'ESITO: COMBACIA -- cartella del MT5 BCM letta, zero grafici ORO con un EA, zero buchi' -ForegroundColor Green }; Write-Host 'Questa riga LEGGE E STAMPA: non ha scritto, copiato, aperto, chiuso o modificato niente. Posizioni e pendenti sul SERVER non si vedono da qui: scheda Trade, oppure lo Storico del conto.' }
```

✋ Se stampa un grafico ORO con un EA che non sia solo long: dentro il MT5 di quel PC, stessi passi 0-5 del ramo B qui sopra
(scheda Trade → Rimuovi → spazzata → Salva profilo). Se il PC e' spento, la verifica si fa **alla prossima accensione e prima
di qualunque cosa**, e fino ad allora il conto `50503392` da quella macchina e' **[NON MISURATO]**.

---

### ④.3 🪟 manuale `50503635` — `C:\MT5_MANUALE`, cartella dati `CF6C240A…`, profilo `Default`

**Cosa NON viene toccato, per nome**: FTMO `541452707` (`C:\FTMO`); REALE `10105439` (`C:\BCM_Reale`); 100k `50504263` (`-V3`);
piccolo `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`); banco `50504400` (`C:\MT5_Backtest`); Pepperstone; Tickmill.
Sul manuale stesso: gli altri 5 grafici del profilo (`Main`/senza EA, CODA_08 r.2559), e i pannelli.

Ultimo segno di vita del terminale: 25/09 22:54 (§③); se e' aperto adesso lo dice la riga di riconoscimento. Lo scalper
`ABTG_ScalperDirezionale (4)` su XAUUSD M1, magic `779901`, gira in modo **CANDELA** con la regola **MEZZO CORPO**
(`InpEntryMode=1`, `InpCandleRule=4`, CODA_08 r.2470-2472): **il verso lo sceglie l'EA a ogni candela M1** (verde e prezzo
sopra la meta' del corpo = long, rossa e sotto = short), fino a 8 posizioni per ondata. `InpDirection=0` ("verso dalla tua
posizione a mano") vale **solo nel modo MANUALE** ed e' inerte qui. Parte col pulsante **START** (`InpAutoStart=false`). E'
quindi **L+S per costruzione, letto dal preset**. Il 25/09 alle 22:53 ora VPS ha provato cinque `market buy` a mercato chiuso
(CODA_09): quella candela era verde; la successiva poteva essere rossa.

✋ Dentro MT5 `50503635` (finestra riconosciuta con la riga in testa al §④: `50503635` nel titolo, `Path` che comincia con
`C:\MT5_MANUALE`):
0. **Scheda Trade**: posizioni e pendenti **XAUUSD**. Foto a Claudio.
1. Grafico **XAUUSD M1** con `ABTG_ScalperDirezionale (4)` in alto a destra → **tasto destro → Expert Advisors → Rimuovi**.
2. **Spazzata** (classe 788): il 25/09 sera sullo stesso terminale giravano **quattro** istanze `(1)…(4)` su M1 e una `(4)` su
   M5 (CODA_02 r.136-143); il profilo salvato alle 22:40 ne tiene **una**. Ogni altro grafico XAUUSD con un EA va tolto e
   scritto per nome.
3. 🔴 **File → Profili → Salva profilo**, nome **`Default`**.
4. `Algo Trading` in alto: su questo terminale **spegnerlo e' una scelta possibile** (non ci sono altre sedie da tenere
   accese), ma **non sostituisce la rimozione**: con `Algo Trading` spento l'EA resta nel profilo e riparte al primo click.
   Se Claudio lo spegne, lo fa **in piu'**, non **al posto di**.
5. 🔴 **E vale per le mani**: finche' la sedia oro FTMO e' in campo, **nessuna operazione manuale short sull'oro** su questo
   conto (ne' su nessun altro): FTMO non distingue EA e mano, distingue il **verso**.

**Verifica dopo.** 🖥️ **Bersaglio: finestra PowerShell sul VPS `VMI3047753`**, sola lettura della cartella `CF6C240A…` (con
controllo che `origin.txt` dica `C:\MT5_MANUALE`); **attesa dopo la pausa: 0 grafici ORO con EA**. NON tocca e NON legge: FTMO
`541452707`, REALE `10105439`, 100k `50504263`, piccolo `50503392`, banco `50504400`, Pepperstone, Tickmill.

```powershell
& { if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $ErrorActionPreference='Continue'; $INV=[Globalization.CultureInfo]::InvariantCulture; $H='CF6C240A869369695913FB76DA84BD22'; $ATT='C:\MT5_MANUALE'; $CHI='manuale 50503635'; $PROFATT='Default'; $ATTESO=0; Write-Host ''; Write-Host ('=== SEDIE ORO NEL PROFILO SALVATO -- ' + $CHI + ' -- cartella dati ' + $H + ' -- SOLA LETTURA -- ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss',$INV) + ' ora Windows del VPS ===') -ForegroundColor Cyan; Write-Host ('    bersaglio della LETTURA: ' + $ATT + ' (' + $CHI + '). NON tocca e NON legge: FTMO 541452707 (C:\FTMO), REALE 10105439 (C:\BCM_Reale), 100k 50504263 (BCM Markets MT5 Terminal -V3), banco 50504400 (C:\MT5_Backtest, spento), Pepperstone 62128200, piccolo 50503392 (BCM Markets MT5 Terminal, SENZA -V3), Tickmill. Nessun processo aperto o chiuso, nessun file scritto.'); function Leggi($p){ $b=$null; try { $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite); $b=[byte[]]::new($fs.Length); [void]$fs.Read($b,0,$b.Length); $fs.Dispose() } catch { return '' }; if($null -eq $b -or $b.Count -lt 2){ return '' }; if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }; $z=0; $n=[math]::Min(400,$b.Count); for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $z++ } }; if($z -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }; return [Text.Encoding]::UTF8.GetString($b) }; $root=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $D=Join-Path $root $H; if(-not (Test-Path -LiteralPath $D)){ throw ('STOP: la cartella dati ' + $D + ' non esiste su questa macchina: non leggo niente') }; $o=Join-Path $D 'origin.txt'; if(-not (Test-Path -LiteralPath $o)){ throw ('STOP: manca ' + $o + ': senza origin.txt non so di quale terminale sono questi grafici') }; $orig=((Leggi $o) -replace '[^\u0020-\u007E]','').Trim(); if($orig -ne $ATT){ throw ('STOP: origin.txt dice [' + $orig + '] e non [' + $ATT + ']: hash e programma NON combaciano, non leggo') }; Write-Host ('    origin.txt = ' + $orig + '   COMBACIA con il programma atteso') -ForegroundColor Green; $ini=Join-Path $D 'config\common.ini'; $prof=''; $ti=Leggi $ini; if($ti -ne ''){ $m=[regex]::Match($ti,'(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.+?)[ \t]*$'); if($m.Success){ $prof=$m.Groups[1].Value.Trim() } }; if($prof -eq ''){ throw 'STOP: config\common.ini non dichiara ProfileLast (o non si legge): non so quale profilo carica il terminale e non lo indovino' }; Write-Host ('    profilo ATTIVO (config\common.ini, ProfileLast): ' + $prof + '   atteso dalla sonda CODA_01 del 27/09: ' + $PROFATT + '   ' + $(if($PROFATT -eq ''){'(nessun atteso: qui la sonda notturna non gira)'}elseif($prof -ieq $PROFATT){'COMBACIA'}else{'DIVERSO: leggere a mano prima di credere al resto'})); $lg=Join-Path $D 'logs'; if(Test-Path -LiteralPath $lg){ foreach($f in @(Get-ChildItem -LiteralPath $lg -Filter '*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 3)){ $tl=Leggi $f.FullName; $k=0; foreach($ln in ($tl -split '\r?\n')){ if($ln -match 'authorization|login on'){ if($k -lt 2){ Write-Host ('    giornale ' + $f.Name + ': ' + $ln.Trim().TrimStart([char]65279)) }; $k++ } } } } else { Write-Host '    (nessuna cartella logs: il conto non si legge dal giornale)' -ForegroundColor Yellow }; $PC=Join-Path $D ('MQL5\Profiles\Charts\' + $prof); if(-not (Test-Path -LiteralPath $PC)){ throw ('STOP: la cartella del profilo ' + $PC + ' non esiste') }; $files=@(Get-ChildItem -LiteralPath $PC -Filter 'chart*.chr' | Sort-Object Name); $ult='-'; if($files.Count -gt 0){ $ult=($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) }; Write-Host ('    file chart*.chr nel profilo ' + $prof + ': ' + $files.Count + '   ultimo salvataggio del profilo: ' + $ult + '   (i .chr sono la FOTO del profilo SALVATO: un EA attaccato dopo NON compare, classe 788)'); Write-Host '    --- ogni grafico con un EA sopra ---'; $oro=0; $orobad=0; $conEA=0; $ill=0; foreach($x in $files){ $t=Leggi $x.FullName; if($t -eq ''){ $ill++; Write-Host ('      ' + $x.Name + '   ILLEGGIBILE') -ForegroundColor Yellow; continue }; $sym='-'; $ms=[regex]::Match($t,'(?im)^[ \t]*symbol[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ms.Success){ $sym=$ms.Groups[1].Value.Trim() }; $ea=''; $mag='-'; $al='-'; $as='-'; $me=[regex]::Match($t,'(?is)<expert>(.*?)</expert>'); if($me.Success){ $blk=$me.Groups[1].Value; $mn=[regex]::Match($blk,'(?im)^[ \t]*name[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mn.Success){ $ea=$mn.Groups[1].Value.Trim() }; $mm=[regex]::Match($blk,'(?im)^[ \t]*InpMagic[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mm.Success){ $mag=$mm.Groups[1].Value.Trim() }; $ml=[regex]::Match($blk,'(?im)^[ \t]*InpAllowLong[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ml.Success){ $al=$ml.Groups[1].Value.Trim() }; $mh=[regex]::Match($blk,'(?im)^[ \t]*InpAllowShort[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mh.Success){ $as=$mh.Groups[1].Value.Trim() } }; if($ea -eq '' -or $ea -ieq 'Main'){ continue }; $conEA++; $eoro=($sym -match 'XAU|GOLD'); $seg=''; $col='Gray'; if($eoro){ $oro++; $seg='   <== ORO solo long'; $col='Yellow'; if(-not ($as -match '^(false|0)$')){ $orobad++; $seg='   <== ORO CON LATO SHORT POSSIBILE (L+S, o lati non letti = L+S)'; $col='Red' } }; Write-Host ('      ' + $x.Name.PadRight(12) + $sym.PadRight(12) + $ea.PadRight(42) + ' magic ' + $mag.PadRight(9) + ' AllowLong=' + $al.PadRight(6) + ' AllowShort=' + $as.PadRight(6) + $seg) -ForegroundColor $col }; Write-Host ('    RIEPILOGO: grafici con EA = ' + $conEA + '   di cui su ORO = ' + $oro + '   di cui NON solo-long = ' + $orobad + '   file illeggibili = ' + $ill + '   (AllowLong/AllowShort = - vuol dire che l EA non ha quegli input: i lati NON sono letti, si trattano come L+S)'); Write-Host ('    ATTESO DOPO LA PAUSA su ORO = ' + $ATTESO + ' (nessuna: lo scalper 779901 va tolto)   ' + $(if($oro -eq $ATTESO -and $orobad -eq 0 -and $ill -eq 0){'COMBACIA (conta E lati: nessun ORO con lato short possibile, nessun file illeggibile)'}else{'NON COMBACIA: il verdetto guarda QUANTI e QUALI (un ORO L+S o con lati non letti rimasto, o la sedia solo-long tolta al posto di un altra, o un file illeggibile, bastano a farlo rosso); o la pausa non e completa, o e stato tolto il grafico SBAGLIATO, o il profilo non e stato salvato (File, Profili, Salva profilo), o e cambiato qualcosa: leggere la tabella qui sopra riga per riga'})) -ForegroundColor $(if($oro -eq $ATTESO -and $orobad -eq 0 -and $ill -eq 0){'Green'}else{'Red'}); Write-Host 'Questa riga LEGGE E STAMPA: non ha scritto, copiato, aperto, chiuso o modificato niente. Un pendente o una posizione sul SERVER non si vedono da qui: scheda Trade, oppure lo Storico del conto.' }
```

---

### ④.4 🪟 Tickmill — `C:\Program Files\Tickmill Europe MT5 Terminal`, cartella dati `857385E4…`, profilo `Default`

**Cosa NON viene toccato, per nome**: FTMO `541452707` (`C:\FTMO`); REALE `10105439` (`C:\BCM_Reale`); 100k `50504263` (`-V3`);
piccolo `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`); banco `50504400` (`C:\MT5_Backtest`); manuale `50503635`
(`C:\MT5_MANUALE`); Pepperstone. Su Tickmill stesso: il `BREAKOUT_EA_JPY_v3` su USDJPY (`[Default\chart02.chr]`) non e' oro e
non si tocca in questo pacchetto (la sua correlazione con l'oro e' **[NON MISURATA]**, §⑦).

Il terminale e' **chiuso dal 20/07/2026** (§③). Il conto Tickmill **non e' letto dalla sonda** (CODA_03) e non e' scritto in
nessun referto: **[NON MISURATO]**. La `Gold_Ichimoku_TK_ATR_EA` `250604` e' quindi **inerte**, e la pausa piu' sicura e' la piu'
semplice: **non riaprire Tickmill** finche' la sedia oro FTMO e' in campo. Se Claudio vuole riaprirlo per un altro motivo,
lo si fa **solo nel weekend** (stessa ragione del ramo B del piccolo: il comportamento del binario del 17/06 al primo tick
**non e' letto**), col programma `terminal64` della cartella `C:\Program Files\Tickmill Europe MT5 Terminal`, e prima di toccare qualunque cosa si
rilancia la riga di riconoscimento del §④ (`Path` che comincia con `C:\Program Files\Tickmill Europe MT5 Terminal`; il numero
di conto Tickmill **non e' noto**: si legge nel titolo e si scrive). Poi
✋ dentro MT5 Tickmill, **prima di ogni altra cosa**: scheda Trade (posizioni XAUUSD sul server: un terminale chiuso da due
mesi puo' avercene, **[NON MISURATO]**) → grafico XAUUSD M5 → tasto destro → Expert Advisors → Rimuovi → spazzata → **Salva
profilo** `Default`. Sull'indizio "solo long" (`InpTradeDirection=1`): **non basta** per lasciarla accesa, perche' il binario in
campo e' del 17/06 e l'enum e' letto dal sorgente in repo; se Claudio apre la finestra **Input** dell'EA e legge *"Direzione dei
trade = Solo LONG"*, quella e' una misura sul binario vero e la sedia puo' passare a **RESTA** — decisione sua, scritta in
`REGISTRO`/`PROMEMORIA` con la foto.

**Verifica dopo** (e anche **oggi**, per fotografare lo stato di partenza: attesa oggi **1** ORO). 🖥️ **Bersaglio: finestra
PowerShell sul VPS `VMI3047753`**, sola lettura della cartella `857385E4…`; **attesa dopo la pausa: 0**. NON tocca e NON legge:
FTMO `541452707`, REALE `10105439`, 100k `50504263`, piccolo `50503392`, banco `50504400`, manuale `50503635`, Pepperstone.

```powershell
& { if($env:COMPUTERNAME -ne 'VMI3047753'){ throw ('VIETATO: questa riga si incolla SOLO nella finestra PowerShell del VPS VMI3047753. Macchina attuale: ' + $env:COMPUTERNAME + '. Qui non si esegue niente.') }; $ErrorActionPreference='Continue'; $INV=[Globalization.CultureInfo]::InvariantCulture; $H='857385E4B0F2356AD99AA95CDF40FAE9'; $ATT='C:\Program Files\Tickmill Europe MT5 Terminal'; $CHI='Tickmill (conto non letto dalla sonda)'; $PROFATT='Default'; $ATTESO=0; Write-Host ''; Write-Host ('=== SEDIE ORO NEL PROFILO SALVATO -- ' + $CHI + ' -- cartella dati ' + $H + ' -- SOLA LETTURA -- ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss',$INV) + ' ora Windows del VPS ===') -ForegroundColor Cyan; Write-Host ('    bersaglio della LETTURA: ' + $ATT + ' (' + $CHI + '). NON tocca e NON legge: FTMO 541452707 (C:\FTMO), REALE 10105439 (C:\BCM_Reale), 100k 50504263 (BCM Markets MT5 Terminal -V3), banco 50504400 (C:\MT5_Backtest, spento), Pepperstone 62128200, piccolo 50503392 (BCM Markets MT5 Terminal, SENZA -V3), manuale 50503635 (C:\MT5_MANUALE). Nessun processo aperto o chiuso, nessun file scritto.'); function Leggi($p){ $b=$null; try { $fs=[IO.File]::Open($p,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite); $b=[byte[]]::new($fs.Length); [void]$fs.Read($b,0,$b.Length); $fs.Dispose() } catch { return '' }; if($null -eq $b -or $b.Count -lt 2){ return '' }; if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }; $z=0; $n=[math]::Min(400,$b.Count); for($i=1; $i -lt $n; $i+=2){ if($b[$i] -eq 0){ $z++ } }; if($z -gt ($n/4)){ return [Text.Encoding]::Unicode.GetString($b) }; return [Text.Encoding]::UTF8.GetString($b) }; $root=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; $D=Join-Path $root $H; if(-not (Test-Path -LiteralPath $D)){ throw ('STOP: la cartella dati ' + $D + ' non esiste su questa macchina: non leggo niente') }; $o=Join-Path $D 'origin.txt'; if(-not (Test-Path -LiteralPath $o)){ throw ('STOP: manca ' + $o + ': senza origin.txt non so di quale terminale sono questi grafici') }; $orig=((Leggi $o) -replace '[^\u0020-\u007E]','').Trim(); if($orig -ne $ATT){ throw ('STOP: origin.txt dice [' + $orig + '] e non [' + $ATT + ']: hash e programma NON combaciano, non leggo') }; Write-Host ('    origin.txt = ' + $orig + '   COMBACIA con il programma atteso') -ForegroundColor Green; $ini=Join-Path $D 'config\common.ini'; $prof=''; $ti=Leggi $ini; if($ti -ne ''){ $m=[regex]::Match($ti,'(?im)^[ \t]*ProfileLast[ \t]*=[ \t]*(.+?)[ \t]*$'); if($m.Success){ $prof=$m.Groups[1].Value.Trim() } }; if($prof -eq ''){ throw 'STOP: config\common.ini non dichiara ProfileLast (o non si legge): non so quale profilo carica il terminale e non lo indovino' }; Write-Host ('    profilo ATTIVO (config\common.ini, ProfileLast): ' + $prof + '   atteso dalla sonda CODA_01 del 27/09: ' + $PROFATT + '   ' + $(if($PROFATT -eq ''){'(nessun atteso: qui la sonda notturna non gira)'}elseif($prof -ieq $PROFATT){'COMBACIA'}else{'DIVERSO: leggere a mano prima di credere al resto'})); $lg=Join-Path $D 'logs'; if(Test-Path -LiteralPath $lg){ foreach($f in @(Get-ChildItem -LiteralPath $lg -Filter '*.log' | Sort-Object LastWriteTime -Descending | Select-Object -First 3)){ $tl=Leggi $f.FullName; $k=0; foreach($ln in ($tl -split '\r?\n')){ if($ln -match 'authorization|login on'){ if($k -lt 2){ Write-Host ('    giornale ' + $f.Name + ': ' + $ln.Trim().TrimStart([char]65279)) }; $k++ } } } } else { Write-Host '    (nessuna cartella logs: il conto non si legge dal giornale)' -ForegroundColor Yellow }; $PC=Join-Path $D ('MQL5\Profiles\Charts\' + $prof); if(-not (Test-Path -LiteralPath $PC)){ throw ('STOP: la cartella del profilo ' + $PC + ' non esiste') }; $files=@(Get-ChildItem -LiteralPath $PC -Filter 'chart*.chr' | Sort-Object Name); $ult='-'; if($files.Count -gt 0){ $ult=($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime.ToString('yyyy-MM-dd HH:mm',$INV) }; Write-Host ('    file chart*.chr nel profilo ' + $prof + ': ' + $files.Count + '   ultimo salvataggio del profilo: ' + $ult + '   (i .chr sono la FOTO del profilo SALVATO: un EA attaccato dopo NON compare, classe 788)'); Write-Host '    --- ogni grafico con un EA sopra ---'; $oro=0; $orobad=0; $conEA=0; $ill=0; foreach($x in $files){ $t=Leggi $x.FullName; if($t -eq ''){ $ill++; Write-Host ('      ' + $x.Name + '   ILLEGGIBILE') -ForegroundColor Yellow; continue }; $sym='-'; $ms=[regex]::Match($t,'(?im)^[ \t]*symbol[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ms.Success){ $sym=$ms.Groups[1].Value.Trim() }; $ea=''; $mag='-'; $al='-'; $as='-'; $me=[regex]::Match($t,'(?is)<expert>(.*?)</expert>'); if($me.Success){ $blk=$me.Groups[1].Value; $mn=[regex]::Match($blk,'(?im)^[ \t]*name[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mn.Success){ $ea=$mn.Groups[1].Value.Trim() }; $mm=[regex]::Match($blk,'(?im)^[ \t]*InpMagic[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mm.Success){ $mag=$mm.Groups[1].Value.Trim() }; $ml=[regex]::Match($blk,'(?im)^[ \t]*InpAllowLong[ \t]*=[ \t]*(.+?)[ \t]*$'); if($ml.Success){ $al=$ml.Groups[1].Value.Trim() }; $mh=[regex]::Match($blk,'(?im)^[ \t]*InpAllowShort[ \t]*=[ \t]*(.+?)[ \t]*$'); if($mh.Success){ $as=$mh.Groups[1].Value.Trim() } }; if($ea -eq '' -or $ea -ieq 'Main'){ continue }; $conEA++; $eoro=($sym -match 'XAU|GOLD'); $seg=''; $col='Gray'; if($eoro){ $oro++; $seg='   <== ORO solo long'; $col='Yellow'; if(-not ($as -match '^(false|0)$')){ $orobad++; $seg='   <== ORO CON LATO SHORT POSSIBILE (L+S, o lati non letti = L+S)'; $col='Red' } }; Write-Host ('      ' + $x.Name.PadRight(12) + $sym.PadRight(12) + $ea.PadRight(42) + ' magic ' + $mag.PadRight(9) + ' AllowLong=' + $al.PadRight(6) + ' AllowShort=' + $as.PadRight(6) + $seg) -ForegroundColor $col }; Write-Host ('    RIEPILOGO: grafici con EA = ' + $conEA + '   di cui su ORO = ' + $oro + '   di cui NON solo-long = ' + $orobad + '   file illeggibili = ' + $ill + '   (AllowLong/AllowShort = - vuol dire che l EA non ha quegli input: i lati NON sono letti, si trattano come L+S)'); Write-Host ('    ATTESO DOPO LA PAUSA su ORO = ' + $ATTESO + ' (nessuna: la Gold_Ichimoku 250604 va tolta)   ' + $(if($oro -eq $ATTESO -and $orobad -eq 0 -and $ill -eq 0){'COMBACIA (conta E lati: nessun ORO con lato short possibile, nessun file illeggibile)'}else{'NON COMBACIA: il verdetto guarda QUANTI e QUALI (un ORO L+S o con lati non letti rimasto, o la sedia solo-long tolta al posto di un altra, o un file illeggibile, bastano a farlo rosso); o la pausa non e completa, o e stato tolto il grafico SBAGLIATO, o il profilo non e stato salvato (File, Profili, Salva profilo), o e cambiato qualcosa: leggere la tabella qui sopra riga per riga'})) -ForegroundColor $(if($oro -eq $ATTESO -and $orobad -eq 0 -and $ill -eq 0){'Green'}else{'Red'}); Write-Host 'Questa riga LEGGE E STAMPA: non ha scritto, copiato, aperto, chiuso o modificato niente. Un pendente o una posizione sul SERVER non si vedono da qui: scheda Trade, oppure lo Storico del conto.' }
```

---

### ④.5 ⚪ Quelli che NON si toccano, e perche' — elencati per nome, non «tutto il resto» (classe 180/755)
- **FTMO `541452707` (`C:\FTMO`)**: 9 sedie, nessuna XAUUSD. E' il bersaglio dell'**attacco** (d), che ha il suo pacchetto
  (bozza §⑥) e viene **dopo** questa pausa, mai prima.
- **REALE `10105439` (`C:\BCM_Reale`)**: zero sedie oro (ORB EURAUD, Guardian `779002`, SlippageLogger). **Nessuna riga di
  questo pacchetto lo nomina come bersaglio**, e nessuna scrive.
- **100k `50504263` (`… -V3`)**: profilo attivo `SQUADRA 100K` senza oro; i **residui** nel profilo `Default` sono 5 sedie
  **indice** piu' un Guardian (sospese il 24/09): **non cambiare profilo**.
- **Banco `50504400` (`C:\MT5_Backtest`)**: spento dal 21/09 14:51, resta spento (firma del 21/09).
- **Pepperstone** (`73B7A242…`): zero sedie, nessun log.
- Come si sa che su FTMO, REALE e `-V3` l'oro non c'e': **due misure**, non una. (1) CODA_01 del 27/09, profilo attivo **e**
  residui (la foto del profilo SALVATO: per CODA_05 e' **tiepida** su FTMO e `-V3`, classe 788); (2) CODA_09: **nessuna riga
  XAUUSD** nei giornali di FTMO (26-27/09), `-V3` (26-27/09) e REALE (24-25/09). Argento (`XAG`): zero grafici con un EA in tutte e
  otto le cartelle.

---

## ⑤ ⏰ ORDINE E TEMPISTICA — e la porta di rientro

**L'ordine, ed e' un ordine e non un elenco**:
1. 📸 **Foto lato server, prima di tutto**: posizioni e pendenti **XAUUSD** sui conti `50503392` (dall'app o dal web terminal:
   il terminale del VPS e' chiuso e il PC di backtest non e' sondato), `50503635` (scheda Trade del manuale), Tickmill (se
   riaperto). Il numero da cui si parte e' *"quanti short oro sono aperti adesso su un conto non FTMO"*, contando le **posizioni sell**
   **e i pendenti di vendita** (`sell stop`/`sell limit`: scattano da soli): se **> 0**, l'attacco (d) **aspetta** che siano
   chiusi o cancellati (§⑥ punto 3).
2. ✋ **Manuale `50503635`** (vivo): rimozione `779901` + spazzata + salva profilo (§④.3).
3. 🪟 **Piccolo `50503392`**: ramo A (riga da scrivere, firma) o ramo B (a mano, in finestra sicura) (§④.1).
4. 🖥️ **PC di backtest `DESKTOP-H4D7CAJ`**: le due righe di sola lettura + eventuale rimozione (§④.2).
5. 🔒 **Tickmill**: resta chiuso (§④.4). Riga di verifica lo stesso, per la foto.
6. ✅ **Verifiche**: le righe di §④ (attese: piccolo **1**, manuale **0**, Tickmill **0**, PC di backtest **0**) e la notte dopo
   `CODA_01`.
7. 🥇 **Solo dopo**: l'attacco (d) su FTMO, nella sua finestra (bozza §⑥: mai fra le 09:00 e le 19:30 FTMO; meglio weekend).

**Quando NO, con i tre orologi** (BCM = UTC+1 fisso; oggi FTMO = BCM + 2, Italia = BCM + 1; `OROLOGIO_BCM_2026-09-24`):
- 🔴 **Mai fra le 09:00 e le 10:30 FTMO = 07:00-08:30 BCM = 08:00-09:30 italiane.** E' la finestra in cui la `770402` del piccolo
  **piazza** (`InpPlaceHour=7` BCM, cutoff `8:30`, CODA_08 r.1282-1285: **07:00 BCM = 09:00 FTMO**, lo stesso box della sedia
  FTMO) e in cui la sedia FTMO avra' il suo buy stop vivo (bozza §⑥). Un pendente demo che scatta in quella finestra e'
  l'esposizione opposta **nello stesso minuto** del long FTMO.
- 🔴 Le due H4 del piccolo (`971501`, `970901`) agiscono all'apertura della candela H4 (misurato in CODA_09: SELL LIMIT alle
  13:00 e buy stop alle 17:00 ora VPS = 12:00 e 16:00 BCM) **e al primo tick dopo ogni riapertura o riattacco** (`gLastBar=0`,
  §④.1 ramo B): stare lontani da 00/04/08/12/16/20 BCM **non protegge**. Per questo il ramo B e ogni riapertura di Tickmill si
  fanno **solo a mercato chiuso**.
- 🟢 **Meglio a mercato chiuso**: da sabato mattina alla riapertura della domenica sera (l'ora esatta di riapertura dell'oro su
  BCM e su FTMO **[NON MISURATA]** qui; l'ancora FX della domenica e' in `OROLOGIO_BCM`). Il 25/09 alle 22:53 ora VPS (21:53 BCM) l'oro
  su BCM era gia' `[market closed]` (CODA_09): ma il 25/09 era un **venerdi'**, quindi quella riga puo' essere la chiusura
  del weekend; la pausa serale quotidiana dell'oro su BCM e' **[NON MISURATA]**, e **non** e' una finestra per il ramo B.
- 🔴 **Scadenza di questa tabella: 24-25/10/2026.** BCM non cambia orologio, FTMO e l'Italia si': i delta diventano +1 e 0 (bozza
  §⑨, decisione di Claudio entro il 25/10). Da quel giorno le tre colonne vanno riscritte, non ricopiate.

**La porta di rientro** (stessa forma di `SOSPENSIONE` «Come si torna indietro»): le sedie demo in pausa **si riaccendono
quando la sedia oro FTMO si spegne**, cioe' quando su `541452707` **non c'e' piu' ne' l'EA sul grafico XAUUSD, ne' una
posizione, ne' un pendente XAUUSD**. Si riattaccano **identiche** con gli input salvati in `CODA_08_preset_dai_chr_20260927_033003.log`
(`770402` r.1271-1359, `971501` r.1361-1440, `970901` r.1442-1520, `779901` r.2465-2557, `250604` r.2309-2337): non serve salvare
nessun modello. La riga per farlo (o il `-Annulla` sul backup del ramo A) si scrive **allora**, e passa dal cancello.

---

## ✍️ ⑥ LE TRE RIGHE CHE RESTANO DI CLAUDIO

1. 🖊️ **E' una firma sua, e senza firma non si esegue niente.** La bozza lo dice alla lettera (§② riga (f): *"firma? si'
   (il piccolo)"*; §⑧.4: *"e' un BLOCCO: senza, l'attacco (d) non si fa"*). Questo documento **descrive**; nessuna riga qui
   scrive, apre o chiude qualcosa; le sole azioni che cambiano lo stato (rimozioni a mano, riga del ramo A) partono **dopo il
   suo "si'"** e, la riga, dopo i due cancelli. Le cose da firmare sono **tre**: (i) la pausa delle cinque; (ii) il ramo A o B
   per il piccolo; (iii) cosa fare della `250604` di Tickmill se il binario dice "solo long".
2. 🔴 **Niente conto reale.** Il REALE `10105439` (`C:\BCM_Reale`) non ha sedie oro, **non e' bersaglio di nessuna riga** di
   questo pacchetto, e resta fuori anche dalla porta di rientro. Il perimetro del runner resta **sola lettura**.
3. ⚖️ **Le posizioni e i pendenti aperti al momento della pausa sono scelta sua — con il fatto davanti.** Il fatto: togliere
   un EA **non chiude una posizione** (SL e TP vivono sul server) e **non cancella un pendente** (`SOSPENSIONE` «Come si fa»,
   punto 0); ma **spegne la gestione** (parziali, pareggio, trailing, chiusura di fine giornata delle 17:30 BCM della `770402`,
   `InpCloseAtEnd=true`). Le scadenze **misurate** dai preset: pendenti `770402` = 90 minuti (`InpPendingExpiryMin=90`) o cutoff
   08:30 BCM; `971501` = 6 candele H4 = 24 ore (`InpPendingExpiryBars=6`); `970901` = 3 candele H4 = 12 ore
   (`InpPendingExpiryBars=3`); le **posizioni** non scadono mai (`971501`: `InpUseCutoff=false`, `InpFridayClose=false`;
   `970901`: `InpUseTimeWindow=false`). Quindi: **chiudere a mano** oppure **lasciar scadere/andare a SL-TP** e' scelta sua,
   **ma** finche' un **short** XAUUSD e' aperto su un conto non FTMO, **l'attacco (d) non parte**: quello non e' una scelta,
   e' il punto (6) di Jonas. E sono **demo**: cancellare un pendente non costa niente.

---

## ⚪ ⑦ COSA RESTA [NON MISURATO] — per nome

- **Lati della `779901`**: **L+S misurato dal preset** (modo CANDELA, regola MEZZO CORPO: il verso lo sceglie l'EA a ogni
  candela); resta **[NON MISURATO]** solo che il binario v1.07 in campo sia identico al sorgente in repo. **Lati della `250604`**: indizio "solo long" dal `.chr` + sorgente in repo; **binario Tickmill del 17/06 non
  verificato** → L+S.
- **Conto Tickmill**: non letto (CODA_03). **Conto della cartella Pepperstone**: non letto dalla sonda (il `62128200` viene da
  `report/RUNNER_V3_IN_CAMPO_2026-09-12.md`).
- **Posizioni e pendenti sul server** di `50503392` (in particolare la `#3430899` XAUUSD del 23/09), di `50503635` e di Tickmill:
  nessuna sonda li vede; solo lo Storico del conto.
- **PC di backtest `DESKTOP-H4D7CAJ`**: se MT5 e' aperto, quali sedie ha, quale hash ha la sua cartella dati. Fino alla riga di
  §④.2, il conto `50503392` **da quella macchina** e' [NON MISURATO] (classe 826).
- **Se il piccolo e' ancora chiuso adesso**: la foto e' delle 03:30 del 27/09.
- **Comportamento di MT5 su un `.chr` senza `<expert>`** (ramo A): `SOSPENSIONE` «Da verificare (1)», ancora aperto.
- **Correlati**: FTMO conta anche gli strumenti correlati e non da' una lista. Sul piccolo restano accese sedie **USD**
  (`BreakingBand`/`GapFill` su EURUSD, GBPUSD, AUDUSD; `PostNews` USDJPY/EURUSD/EURJPY; `PunteLarry` GBPUSD **solo short**
  `772345`; `EasyTrend` GBPUSD; `PTE` GBPUSD) e su Tickmill il `BREAKOUT_EA_JPY_v3`: la loro correlazione con XAUUSD e'
  **[NON MISURATA]** (quella oro/dollaro e' [INFERITA] negativa, e "negativa" vuol dire che un **long USD** somiglia a uno
  **short oro**). Non e' in questo pacchetto: e' una misura da fare **prima** di dire che il pacchetto basta.
- **Ora di riapertura dell'oro** la domenica (BCM e FTMO) e la **pausa serale** dell'oro su BCM: non misurate al minuto.
- **Gli offset dopo il 24-25/10**: la tabella di §⑤ scade.
- **Se il copy nello stesso verso su un demo** (la `772343` long accanto al long FTMO) sia davvero indifferente per FTMO:
  *"generally allowed"* (Jonas, punto 5) non e' *"always"*. Domanda da aggiungere alla prossima mail, non da assumere.

---

## 🚦 ⑧ CANCELLI — cosa e' passato, e i contro-esempi eseguiti

- **Strato 1, deterministico**: `python3 backtest_pipeline/controlla_riga.py --oggetto md backtest_pipeline/righe/PACCHETTO_PAUSA_ORO_DEMO.md`
  e, per ognuna delle **sei** stringhe, `--oggetto riga` sul file di riga: **zero difetti bloccanti**; rilievi attesi e voluti
  **457/671** (le stringhe nominano REALE, `-V3`, banco e i conti **nell'elenco di cio' che NON toccano**, come impone
  l'ampliamento del 12/09: il cancello li rende visibili, non li giudica).
- **Banco eseguito in `pwsh` su un albero finto** (`APPDATA` e `COMPUTERNAME` finti, nessuna macchina vera): riga del piccolo
  su 7 `.chr` finti → **4 ORO, 6 con EA, NON COMBACIA** (prima della pausa, come deve); `.chr` UTF-16 **senza BOM** e UTF-8
  senza BOM letti (euristica degli zeri, la stessa di `CODA_01`); grafico **senza EA** (`<expert>` vuoto + `name=Main` nella
  finestra) **non contato** (classe 789); EA **senza** `InpAllowLong/Short` → `-`; `origin.txt` diverso dal programma atteso →
  **STOP** senza leggere; macchina diversa → **VIETATO** prima di qualunque lettura; riga del PC di backtest → tutte le
  cartelle, totale ORO e attesa 0.
- **Difetto trovato dal banco e corretto PRIMA di consegnare** (regola del 13/09): nella prima stesura della riga del PC di
  backtest il ciclo usava `$d` e dentro assegnava `$D` — in PowerShell **sono la stessa variabile** (classe 757) e il nome
  della cartella usciva vuoto. Rinominato `$cd`; il banco stampa l'hash.
- **Strato 2** (agente `controllo-preventivo`, 27/09): **FAIL sulla prima stesura `74e94396`**, corretto in questo commit.
  Difetti: (1) lati della `779901` dedotti da `InpDirection`, che il modo CANDELA ignora (classe 880); (2) la verifica del
  piccolo contava QUANTI ORO restano e non QUALI: sul banco, tolta la `772343` e lasciata la `971501` L+S, stampava
  **COMBACIA** in verde (classe 881); (3) la riga del PC di backtest dava **0 in verde** su zero cartelle dati o con la
  cartella BCM non letta, e le quattro righe non contavano i file illeggibili nel verdetto (classe 177); (4) il ramo B
  "feriale lontano dalle 07:00-08:30 BCM e dai cambi H4" non protegge: primo tick = barra nuova (classe 882, figlia della
  866); (5) ramo B e riapertura Tickmill senza percorso dell'eseguibile ne' riconoscimento dopo l'apertura (regola dei
  terminali multipli); (6) manuale e REALE detti "vivi" da un log di 28 ore prima, e la "pausa serale" dell'oro dedotta da
  un venerdi'. Banco `pwsh` rifatto dal cancello sulle righe corrette: piccolo "pausa sbagliata" -> NON COMBACIA rosso,
  "pausa giusta" -> COMBACIA, `.chr` UTF-16 senza BOM con `XAUEUR` L+S e `GOLD.r` senza lati -> contati e rossi, `.chr`
  vuoto -> illeggibile -> rosso; PC: zero cartelle -> NON CONCLUSIVO, cartella BCM senza `ProfileLast` -> NON CONCLUSIVO,
  cartella BCM letta e pulita -> COMBACIA; manuale con lo scalper (lati `-`) -> rosso, senza -> verde; macchina sbagliata ->
  VIETATO. Le sei stringhe: parser PowerShell 0 errori, ASCII puro.
