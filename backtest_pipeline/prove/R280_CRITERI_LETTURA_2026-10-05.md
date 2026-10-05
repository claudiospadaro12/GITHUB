# R280 -- criteri di LETTURA e bersaglio della riga (congelati il 05/10/2026, PRIMA di qualunque corsa)

> **Nessun numero R280 esiste.** I due file prova (`R280a_filtrotf_h1_memoria_candidato_dow_U30USD.txt`, `R280e_ancora_g1_candidato_dow_U30USD.txt`) sono del 03/10, passati
> una volta dal `controllo-preventivo` (commit `33a51b53`) e **non cambiano**: questo file **non sposta nessuna soglia**. Fa tre cose: (1) scrive il **bersaglio** e la
> dichiarazione della **classe 1102**; (2) **completa**, prima dei numeri, i punti in cui i file prova non decidono una combinazione (sezione 5: ogni completamento
> dichiarato come tale); (3) fissa le **parole di verdetto**. Chi legge applica `python3 backtest_pipeline/leggi_r280.py <raccolta>`: rifa' il cancello da CSV grezzi in
> Python/Decimal, indipendente dalla riga PowerShell.

## 0. Bersaglio e che cosa NON si tocca

- **Dove gira**: UNA finestra PowerShell sul **PC di backtest `DESKTOP-H4D7CAJ`**, che apre e chiude da sola il suo terminale `C:\Program Files\BCM Markets MT5 Terminal`
  (loggato sul **demo 50503392**, lo stesso numero del piccolo sul VPS). **Mai sul VPS `VMI3047753`** (firma del 21/09: i round girano sul PC di backtest).
- **NON toccati, per nome**: REALE `10105439` (`C:\BCM_Reale`) · FTMO trial `1514806751` (`C:\FTMO`, ex challenge 541452707: sedie e Guardian) · piccolo `50503392` sul VPS
  (`BCM Markets MT5 Terminal`) · 100k `50504263` (`BCM Markets MT5 Terminal -V3`) · manuale `50503635` (`C:\MT5_MANUALE`) · banco `50504400` (`C:\MT5_Backtest`, spento finche' FTMO opera)
  · Pepperstone · Tickmill. Nessun preset, EA, sedia, taglia, rischio o conto viene toccato; nessun processo chiuso, nessuna cache svuotata.
- **Sola lettura del campo, tester a parte**: il round gira nel tester di quel PC. Se ai grafici di quel PC c'e' una sedia attaccata la riga si ferma (guardia EA).

## 1. La domanda, una sola

Il merito del candidato #1 del Dow (breakout 15', due lati, filtro EMA H4/220, `U30USD`) regge se il filtro legge un TF la cui griglia e' IDENTICA su BCM e FTMO (H1)?
La variabile e' una sola: la **memoria in ore** del filtro (EMA N su H1 = N ore; su H4 = 4N). La cella 880 ha la STESSA memoria dell'ancora H4/220: separa la griglia dalla memoria.
(Dettaglio e attese: `R280a_*.txt` par. 0-5.)

## 2. Cosa gira (due job in UN round, dal commit pinnato nella riga)

| job | file prova | EA / simbolo / TF | asse | celle x gambe | magic |
|---|---|---|---|---|---|
| `R280e` (per primo: i CANCELLI) | `R280e_ancora_g1_candidato_dow_U30USD.txt` | `ABTG_Nasdaq_Apertura_US` U30USD M5 | `InpMagic` 798711/798721 (due gemelle) | 2 x 2 = 4 passate | 798711, 798721 |
| `R280a` (la misura) | `R280a_filtrotf_h1_memoria_candidato_dow_U30USD.txt` | idem, `InpFilterTF`=H1 pinnato | `InpEmaSlow` 220/440/660/880/1100/1320 | 6 x 2 = 12 passate | 798701 (pinnato) |

Modello 4 (tick reali), **deposito 10000** (non e' il default per caso: e' quello di R262b da cui la cella deriva; i file prova non hanno `@DEPOSITO`), rischio 1,0 pinnato,
IS 2024.09.26-2025.06.30 (277 giorni, `@FRAZIONEIS 0.4322` su 2024.09.26-2026.06.30), OOS 2025.07.01-2026.06.30. 97 input per file. Magic `7987xx`: `git grep -w` su HEAD e su ogni
`origin/*` il 05/10 li trova SOLO nei due file prova e come menzione di riserva in `report/APERTURE_DOW_MAPPA_2026-10-03.md` (classe 1096: la verginita' e' DATATA, e
non copre la cache del tester del PC, che non sta nel repo).

## 3. CLASSE 1102 -- dichiarazione: la finestra R280 NON cade dentro un IS gia' misurato di QUESTA cella, tranne la riproduzione voluta

Scansione dei CSV del repo (`python3 backtest_pipeline/collaudo_riga_R280/scan_1102.py`, 05/10, 367 CSV con le colonne `InpFilterTF` e `InpEmaSlow`):
- **(a) le sei celle H1 di R280a: 0 righe** con `InpFilterTF=16385`, `InpEmaFast=1`, `TP1_R=0.5`, due lati, rischio 1 su `U30USD`. Nessuna e' stata misurata, su nessuna finestra. Le sole
  righe H1 del repo (24, in quattro file) sono `EmaFast=14`, `TP1_R=1`, altri simboli (NASUSD/D30EUR) o altri EA: **non sono la stessa cella**.
- **(b) la cella di R280e (H4/220): 4 righe, due corse indipendenti** (R245b, R262b del 27/09) x IS e OOS, **alla cifra uguali**: IS 157 / PF 1,25920 / DD 7,1736 / Profit 1249,94;
  OOS 199 / PF 1,48133 / DD 6,6241 / Profit 2974,09. Le finestre di R280 sono **le stesse** di quelle due corse (identiche, non una sottofinestra): R280e e' per costruzione una
  **RIPRODUZIONE** (G0), non una misura nuova. Informazione di merito nuova da R280e: **zero, voluta**. Serve solo a dire se il banco e' quello di R262b.
- **Conseguenza per le attese di rischio**: il DD dell'ancora (7,1736 IS / 6,6241 OOS) e' un **RIFERIMENTO, non un tetto** per le celle H1: il filtro H1 e' un'altra cella (altro bias
  giornaliero, altri ingressi), quindi la regola della 1102 ("DD della finestra che contiene = tetto") non si applica a R280a. Le bande DD 5-8% di R280a par. 5 vengono dalla STESSA
  finestra H4 (non da una sottofinestra) e sono scritte come "attese senza giudizio". Quello che R280a misura di NUOVO e' tutto: PF, n, DD delle sei celle H1.
- Il file prova R280a, a differenza di LATI A1, **non** pone nessuna soglia di DD su una sottofinestra: C-c e' il muro 10,00 a qualunque n, su finestre intere.

## 4. Le ATTESE (ricopiate dai file prova, scritte il 03/10 prima dei numeri) e il contro-esempio

- **G0/G1 (R280e): attesa VERDE/PASS** (e' la riproduzione di una corsa del 27/09 con lo stesso EA, sorgente identico: `git diff 02c70e17..HEAD` sull'EA e sull'`ABTG_PausaGuardian.mqh` vuoto).
- **R280a**: ipotesi `H_MEMORIA` (conta la memoria in ore, non la griglia). Attesa per cella in `R280a_*.txt` par. 5 (n IS 138-162 che CRESCE con la memoria, PF IS 1,10-1,55, PF OOS
  1,30-1,60, DD 4-9). `leggi_r280.py` stampa dentro/FUORI per ogni numero **senza giudizio**. L'attesa scritta in mappa: *"il default va bene su quasi tutto"*.
- **Contro-esempio (alternativa che da' lo stesso numero)**, da `R280a_*.txt` par. 7: "la 880 coincide con l'ancora perche' il filtro da' lo STESSO bias nel 95% dei giorni (manopola
  quasi muta)". Il numero che le separa e' la colonna Trades: Trades entro +-2 dall'ancora e PF uguale alla seconda cifra **in tutte e due le finestre** = ANNOTAZIONE "manopola quasi muta"
  accanto a V1 (non cambia la zona; buco dichiarato: manca la cella "filtro spento"). Il lettore la implementa (`quasi_muta`) e la prova al bordo (dn 2 contro 3, PF 1,25 contro 1,26).
- **Contro-esempio del GATE** (il numero che produce l'ALTRA spiegazione "il banco non e' quello di R262b"): deposito 100000 al posto di 10000 sposta il Profit di un fattore ~10
  (1249,94 -> ~12499) e i Trades; un EA diverso sposta i Trades. Entrambi cadono fuori dalla tolleranza (autotest: casi "deposito sbagliato" e "EA o dati diversi").

## 5. TOLLERANZE e COMPLETAMENTI scritti prima dei numeri

**Tolleranza di banco G0 + G1** (scritta in `R280e_*.txt`: *"la stessa di R250 par. 5.2"*, cioe' R246 par. 1 / R250 par. 5.1; fonte precedente e NON uno scarto visto, classe 1091:
R246a e R246c (Dow, simbolo in USD su conto EUR) hanno avuto UN centesimo su UN deal di UNA gemella (`REFERTO_R246_2026-09-24.md` par. 1: da li' la tolleranza di R250 5.1); R262 contro R245: zero scarti su 48 celle d'ancora, `risultati_archivio/ROUND_CORTI_B_2026-09-27/RIEPILOGO_ROUND_CORTI_B.txt` riga G0):

| colonna | regola (bordo DENTRO, Decimal) |
|---|---|
| Trades | **ESATTO** |
| Profit | `|diff|` <= **0,05** EUR |
| Profit Factor | `|diff|` <= **0,00005** ("alla quarta decimale", come la classe 875 e `leggi_r255.py`) |
| Equity DD % | `|diff|` <= **0,01** |

G0 = ognuna delle due gemelle contro i numeri dell'ancora (sopra); G1 = le due gemelle fra loro (riferimento: magic 798711). Il Recovery Factor e' scritto in R280e come numero
dell'ancora ma **senza tolleranza congelata**: si **elenca lo scarto** fra i residui, non blocca (e' derivato da Profit e DD). Interpretazione dichiarata: la frase di R280e
*"Trades e PF identici"* in G1 = nella tolleranza qui sopra (il "centesimo di conversione NON annulla", scritto nello stesso paragrafo). Il PRECEDENTE contrario e' R235
(altro EA, NASUSD): residuo di 0,97 EUR fra corse. Se un residuo cosi' uscisse qui, il gate darebbe FAIL e la riga NON si ricalibra a posteriori: **sarebbe la direzione sicura**
(un round buttato, mai un banco sbagliato certificato) e una nuova tolleranza avrebbe bisogno di una nuova misura e di una firma.

**Soglie di R280a (invariate, par. 6)**: C-a PF >= 1,10 in IS e OOS; C-b n >= 150 in IS e OOS; C-c Equity DD % <= 10,00 in IS e OOS; rumore |dPF| <= 0,15 e |dn| <= 8; "meglio del
default" = oltre 0,15 di PF sull'ancora in TUTTE E DUE le finestre senza DD peggiore. Sentinelle S0 (data del referto di OGGI), S2 (manopola muta), S4 (Trades < 20 = guasto).

**Completamenti (i file prova non decidono questi punti; ognuno e' un'interpretazione scritta ORA, senza numeri, e provata al bordo in `leggi_r280.py --autotest`):**
1. **Altopiano**: celle CONTIGUE sull'asse (220, 440, ..., 1320) che passano C-a **e** C-c (C-b non richiesta: se non passa e' "MERITO SOSPESO"); se ci sono piu' corse, la **piu' lunga**;
   a parita' la memoria piu' bassa; il **centro** e' la cella di mezzo, se pari **la memoria piu' bassa** delle due di mezzo (regola di R245); **mai il picco**.
2. **V1/V2**: se l'altopiano esiste e la 880 e' dentro il rumore, **V1** se almeno una cella dell'altopiano passa C-b in tutte e due le finestre, **V2** (solo campione) se **nessuna** la passa.
3. **Rumore**: il par. 6 lo definisce `|dPF| <= 0,15 e |dn| <= 8` (ogni finestra); il par. 5 (`H_GRIGLIA`) nomina l'n solo in IS. Si applica il par. 6 (in ogni finestra) **e** si calcola
   anche il par. 5: **se le due letture divergono la zona e' ZONA GRIGIA e non si sceglie a posteriori**.
4. **"Nessuna cella H1 passa C-a mentre l'ancora passa"** (seconda clausola di V3): e' **implicata dalla prima**. Una 880 dentro il rumore ha PF >= 1,2592-0,15 = 1,1092 in IS e
   >= 1,48133-0,15 = 1,33133 in OOS, cioe' passa C-a: il ramo e' irraggiungibile. Non e' nel codice; l'autotest lo dimostra con i due numeri.
5. **S2**: "identiche alla quinta cifra" = le sei celle con Trades, Profit, PF e DD uguali alla cifra del CSV, in tutte e due le finestre -> V4 NULLO.
6. **S4**: una cella con Trades < 20 in una finestra e' un **guasto** ed esce dai conti (si scrive "S4 GUASTO"). Se e' la **880**, V1 e V3 non sono decidibili -> ZONA GRIGIA.
7. **S0**: la data di `RIEPILOGO_ROUND_R280.txt` deve essere la data di OGGI (`--oggi AAAA-MM-GG` per rileggere un altro giorno, dichiarandolo); se no: NON ANCORA MISURATO, **niente cancello e niente numeri**.
8. **Combinazioni non coperte da V1-V4** (es. 1-2 celle passano C-a e C-c, o C-a passa ma C-c no in tutte): **ZONA GRIGIA** con la frase di R280a *"NON C'E' UNA CONFIGURAZIONE ROBUSTA"*;
   non si forza una zona.
9. **n = Trades**: per questo EA (`InpTP1_ClosePct=0`) un'uscita = una posizione (R263e: 154 deal = 154 posizioni): `|dn| <= 8 posizioni` si legge sulla colonna Trades.

## 6. PAROLE DI VERDETTO (e che cosa non vogliono dire)

| zona (R280a par. 6) | parola | significa |
|---|---|---|
| **V4** (G0/G1 FAIL, o S2) | **NULLO** | la **misura** non vale (banco diverso o manopola muta). **NON** vuol dire "la griglia non conta" |
| **V3** (880 fuori dal rumore) | **EFFETTO** | la griglia/TF del filtro **conta**: CE-4 confermato |
| **V1** (altopiano + 880 nel rumore) | **ZONA GRIGIA** | portabile su UN regime; NON e' un altopiano di merito (Emendamento C, regola del 19/08) |
| **V2** (solo campione) | **ZONA GRIGIA** | le celle passano C-a e C-c ma cadono su C-b |
| non coperta | **ZONA GRIGIA** | non si forza |
| catena non OK, data vecchia, CSV illeggibile | **NON ANCORA MISURATO** | non c'e' una misura da leggere |

**In coda a OGNI parola**: *"MERITO: NON ANCORA MISURATO"* (un regime, un broker, n IS < 150 sulle celle corte). **Nessuna cella viene promossa, nessuna taglia proposta,
nessun preset FTMO, qualunque numero esca.** Non si archivia niente: V3 non e' la morte del candidato (certificato di morte: manca ancora la gestione dell'uscita, i gemelli, il TF
del grafico).

## 7. Buchi dichiarati (ricopiati dai file prova, nessuno chiuso da questo round)

Un regime solo (toro 2024-26), un broker (BCM); i due lati non si separano (il CSV da' il totale: serve il gemello `AllowShort=0/AllowLong=0` sulla cella che esce, come R245e/f);
nessun per-trade utile (le sei celle condividono il magic 798701, classe 41/455); ora fissa 14:30 BCM che d'inverno e' un'ora PRIMA della cash (le due tempistiche sono mescolate come nell'ancora:
i confronti sono fra celle con lo stesso orologio); nessuna misura sul feed FTMO; manca la cella "filtro spento" (un asse per volta); il DD alla taglia 2,00% non si legge qui.

## 8. Come si legge

`python3 backtest_pipeline/leggi_r280.py ROUND_R280_<data>` sulla raccolta estratta dallo zip (non si leggono i CSV di R280a **prima** che il cancello G0 + G1 sia PASS: ne' a occhio,
ne' dal referto del driver; la riga non li stampa e dirotta la console del driver di R280a su file).
