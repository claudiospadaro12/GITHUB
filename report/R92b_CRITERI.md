# R92b -- CRITERI, scritti PRIMA dei numeri (30/09/2026)

Banco: `ABTG_Bulge` v5.20 (`mql5/Experts/ABTG_Bulge.mq5`, SHA256
`ED4E88B1CFBA36AD81658935E8920FE31462AE3202DD61C9C50A039ACEF57BBD`), include
`mql5/Include/ABTG_PausaGuardian.mqh` SHA256
`3EC971152E85E0082488CC4243FF45AE09948C191D52AB96050B48F94641A737`. Nessuno dei due
si tocca: il driver li compila dal ramo `lavoro` e la riga di lancio ne ricontrolla
lo SHA256 dopo ogni job (classe 166/892).

Stato di questo file: **scritto prima di qualunque passata di R92b**. Nessun numero di
R92b esiste al momento della scrittura. Se un numero uscito suggerisse un criterio
migliore, vale dal round dopo.

## 0. LE FIRME, e da dove viene ciascuna

1. **29/09/2026** -- `report/FIRME_2026-09-29_BULGE_R92B.md`, testuale: *"FIRMO, PARTI DAL PASSO 0"*.
   Firma il round, la domanda unica, le soglie S1/S2/S3 (invariate rispetto a
   `backtest_pipeline/risultati_archivio/R92_CRITERI.md`), DD alla taglia <= 10%,
   stop >= 40 x (spread + commissione), scelta al centro dell'altopiano (mai il picco),
   rumore A3 10,5% relativo, rischio 0,80%. Non firma preset, taglie, sedie, conti.
2. **Due decisioni successive di Claudio, mai scritte prima di oggi** (riferite dalla
   sessione madre, che le ha ricevute in chat; qui le metto a verbale):
   - **DUE FINESTRE**: IS `2010.01.01 - 2021.12.31`, OOS `2022.01.01 - 2026.06.30`.
     Motivo: il passo 0 (`backtest_pipeline/risultati_archivio/MISURA_STORICO_CROSS22_2026-09-29/`,
     barre M1 sul disco del PC di backtest, due passate) ha misurato che **21 cross su 22 coprono
     dal 2010.01.01** e **GBPNZD ha il muro al 2010.05.10** (stabile su due passate, barre
     coerenti: 5.843.078 poi 5.843.118).
   - **UN ASSE ALLA VOLTA**: il driver (`backtest_pipeline/righe/RIGA_ROUND_VPS.ps1`,
     marcatore `MARCATORE_RIGA_ROUND_VPS_v2`, SHA256
     `3341756FB37889DBD6E827A87BAC26893E01C85B6C18343918083B01B4DD3425`) accetta un solo
     asse per lavoro. Questo **SOSTITUISCE le 24 celle a incrocio** della firma del 29/09
     (ATR x Multi x ADX x Arancio = 2x3x2x2 = 24) con quattro assi separati attorno a una
     cella di partenza, piu' una cella AMPIA e un controllo.
3. **30/09/2026** -- testuale, riferita dalla sessione madre: *"Approvo, procedi con un asse
   alla volta"*. E' l'approvazione del disegno di questo file (assi separati al posto
   dell'incrocio a 24 celle). Provenienza da dire: la frase mi arriva dalla sessione madre;
   la conversazione con Claudio non e' stata letta da chi ha scritto questo file.

Cosa questa firma **NON** e': non cambia S1/S2/S3, non firma nessun preset, nessuna
taglia, nessuna sedia, nessun conto; il perimetro del runner resta di sola lettura.

## 1. LA DOMANDA, UNA SOLA

> **Quali filtri costano piu' segnali, e con che PF / win rate per cella?**

NON "quale simbolo promuoviamo", NON "quale cella mettiamo in campo". Il round e'
**descrittivo**: non sceglie niente. E' un round **Modello 1 (OHLC M1)**: **screening,
nessun verdetto di merito a tick reali**. Puo' bocciare, non puo' promuovere
(R57: a parita' di tutto, il passaggio OHLC -> tick ha ribaltato il segno di un PF 1,62 in 0,75
e fatto sparire fino al 49% delle operazioni).

## 2. IL BANCO, dichiarato

| voce | valore |
|---|---|
| EA / TF | `ABTG_Bulge` v5.20, **H1** |
| grafico del tester | **GBPUSD**; `Symbols_List` = i **22 cross** (stessa lista di `ABTG_Bulge` e di `prove/R92_scan_BULGE.txt`) |
| modello | **1 = OHLC M1**, CSV con suffisso `_ohlc` |
| barre | `Signal_Bar_Offset=1` (barre chiuse), tranne il controllo (`=0`) |
| rischio | `Risk_Mode=0`, `Risk_Percent=0.8`, `Max_Trades=4`: 0,80 x 4 = 3,20% <= cap C1 3,25% |
| gestione | **nuda** (`Enable_Partial_Close=0`, `Enable_BE_1R=0`, `Enable_Trailing_R=0`) |
| kill switch | acceso (4 SL/giorno, 3 consecutivi, -2%/giorno) |
| Guardian | `InpUsaGuardian=1`, **inerte nel tester** (GlobalVariable assenti: fail-open); vale anche per il cap 3,20% |
| deposito | 10000 (passato esplicito alla riga; valuta EUR, leva 100 del driver) |
| finestra lunga | `@DAQUANDO 2010.01.01`, `@FINOA 2026.06.30`, `@FRAZIONEIS 0.7275` |
| taglio IS/OOS | il driver calcola `Meta = Inizio + floor(giorni x frazione)`: 6024 giorni x 0,7275 = 4382 -> **Meta = 2021.12.31**; IS = 4383 giorni (12,0 anni), OOS da **2022.01.01** = 1642 giorni (4,5 anni). Verificato con il calcolo, non a memoria. (0,727 darebbe 2021.12.28, 0,728 darebbe 2022.01.03: la quarta cifra conta.) |
| cella di partenza **P** | ATR filter **1**, `Bulge_Multi` **1.1**, ADX **1** (soglia 30, solo sul BLU), Arancio **0**, Viola **EA** (non Pine), Blu 1, Viola 1 |
| regime IS (dichiarato accanto a OGNI numero IS) | 2010-2021: **piu' regimi in una finestra sola** -- crisi del debito euro 2010-12, calma 2013-14, shock SNB del 15/01/2015 (tocca CADCHF, NZDCHF, USDCHF), Brexit 2016, crollo COVID 2020. [DICHIARATO da calendario: non misurato su questi dati] |
| regime OOS | 2022 dollaro forte, 2023-24 disinflazione, 2025-26. E' lo stesso regime di R92. |
| orologio BCM | l'EA non ha input orari (H1 su barre chiuse): la classe d'errore "ora server / UTC+1 fisso" (`report/OROLOGIO_BCM_2026-09-24.md`) **non si applica** a questo round. [Dal codice: nessun `InpSessionHour`.] |

### 2.1 Regola GBPNZD (dichiarata prima)
GBPNZD ha il muro al 2010.05.10: **nella gamba IS gira su una finestra piu' corta**
(2010.05.10 - 2021.12.31, non dal 2010.01.01). Il driver ha UN `@DAQUANDO` per file, non uno
per simbolo, quindi il cesto parte dal 2010.01.01 e GBPNZD non ha barre per i primi 4 mesi e
9 giorni. Peso: ~4,3 mesi su 22 simboli x 144 mesi di IS = **0,14% del tempo-simbolo IS**.
Regole: (a) si scrive accanto a ogni numero IS ("GBPNZD dal 2010.05.10"); (b) **non si
rilancia** (perderebbe l'unico banco a 22 cross per recuperare lo 0,14%); (c) la gamba
**OOS e' completa** per tutti e 22 (il muro e' nel 2010); (d) [NON MISURATO] come si
comporta il tester con un simbolo del cesto senza barre all'inizio della finestra: il primo
job a finestra lunga (R92ba) lo mostra, e se esce senza CSV la riga si ferma (par. 4.3).

## 3. I LAVORI (nell'ordine in cui girano: il controllo per primo)

| # | etichetta | file prova | asse (controllo in **grassetto**) | celle x gambe | magic | finestra |
|---|---|---|---|---|---|---|
| 0 | R92b0 | `R92b0_controllo_offset0.txt` | `InpMagic` gemello (2 celle IDENTICHE, `Signal_Bar_Offset=0`) | 2 x 2 = 4 | 799201 / 799251 | 2022.01.01-2026.06.30 |
| a | R92ba | `R92ba_asse_ATR.txt` | `Use_ATR_Filter` {**1**, 0} | 2 x 2 = 4 | 799211 | 2010.01.01-2026.06.30 |
| b | R92bb | `R92bb_asse_BulgeMulti.txt` | `Bulge_Multi` {1.0, **1.1**, 1.2} | 3 x 2 = 6 | 799221 | idem |
| c | R92bc | `R92bc_asse_ADX.txt` | `Use_ADX_Filter` {**1**, 0} | 2 x 2 = 4 | 799231 | idem |
| d | R92bd | `R92bd_asse_Arancio.txt` | `Use_Orange` {**0**, 1} | 2 x 2 = 4 | 799241 | idem |
| e | R92be | `R92be_cella_AMPIA.txt` | `InpMagic` gemello; ATR 0, Multi 1.0, ADX 0, Arancio 1 **insieme** | 2 x 2 = 4 | 799261 / 799311 | idem |

Totale **26 passate**. Il blocco 7992xx e' libero (grep su tutto il repo: zero occorrenze).
Perche' due lavori con l'asse tecnico sul magic (0 ed e): il driver, con **zero assi Y**,
non esegue nessuna passata e lascia i CSV da 0 byte (classe 134); l'asse sul magic fa
due passate identiche per costruzione, che sono anche il **gemello di determinismo** (G1).

La cella **AMPIA** e' identica, input per input, al preset
`mql5/Presets/sedie_piccolo/ABTG_Bulge_v520_piccolo_AMPIO.set`, salvo **tre** differenze
dichiarate: `InpMagic` (799261/799311 al posto di 772701), `InpVerbose=0` e `InpAutoTest=0`
(nel preset sono a `true`: stampano soltanto, nessun effetto sugli ordini). `InpComment` resta
`BULGE_V520A`. Verificato con un confronto riga per riga eseguito a macchina (47 input uguali,
3 diversi), non a occhio.

La cella P compare in **quattro lavori** (a, b, c, d) con quattro magic diversi: e' un
controllo di determinismo gratis (attesa E3, sotto).

## 4. IL CONTROLLO (lavoro 0): `Signal_Bar_Offset=0` deve riprodurre R92

### 4.1 Cosa deve riprodurre
`Signal_Bar_Offset=0` riproduce la v5.10 in modo esatto (dichiarato nel sorgente, changelog
punto 13: stessi indici, stesso `barsNeeded`, stessi bound). R92
(`backtest_pipeline/risultati_archivio/R92_REFERTO.md`) sulla cella base ha contato
**n = 106 operazioni sul totale dei 22 cross** (finestra 2022.01.01-2026.06.30, 22 passate a
un simbolo l'una). Il controllo lancia la cella P con offset 0 sulla **stessa finestra**.

### 4.2 IL CRITERIO (firmato prima dei numeri)
> **Il controllo PASSA se n = Trades(gamba IS) + Trades(gamba OOS) cade in [90 ; 122]**
> (106 +-15%, estremi inclusi). **Se non cade li', il banco e' rotto e NESSUN altro numero vale.**

Come si legge n: la colonna `Trades` del CSV (STAT_TRADES) e' **la stessa grandezza** con cui R92
ha contato 106. Si **sommano le due gambe** (IS `2022.01.01-2025.04.08` + OOS
`2025.04.09-2026.06.30`, con `@FRAZIONEIS 0.7275`) di **una** cella; la seconda cella (gemella
`+50`) deve dare gli stessi numeri (G1) e NON si somma. La banda e' stata decisa dalla sessione
madre (+-15%) e **non e' derivata da una misura**: e' una tolleranza dichiarata.

### 4.3 Perche' la banda e' larga e non stretta: cosa cambia dal banco di R92 (dichiarato)
R92 sommava 22 passate a un simbolo; qui c'e' UNA passata sul cesto. Differenze note e
[INFERITE] (nessuna misurata):
1. **`Max_Trades=4` e kill switch sono UNO sul cesto** (in R92 erano 22, uno per simbolo): fa
   scendere n. Con ~106 posizioni in 4,5 anni la concorrenza media e' molto sotto 1 posizione,
   quindi il tetto morde poco -- ma "poco" non e' misurato.
2. **La finestra e' spezzata in due gambe**: kill switch e contatori ripartono da zero al
   taglio; una posizione aperta al taglio puo' non essere contata da nessuna delle due gambe
   [INFERITO sul comportamento del tester a fine test]. Peso atteso: 0-2 operazioni.
3. **Il BLU sui simboli NON del grafico**: R92 (cella base, un simbolo per passata) aveva il
   BLU a zero per costruzione; il collaudo del basket ha visto `BLU=6 su 115 aperture` (5%),
   dai simboli non del grafico. Con offset 0 su 21 simboli non-grafico, n puo' salire
   di un ordine del 5% [INFERITO].
4. Lo stesso motivo agisce sul VIOLA-EA dei simboli non del grafico: la barra 0 puo' avere gia' un
   corpo, e `|c0-o0| <= 1,5 ATR` non e' piu' sempre vero -> n puo' scendere [INFERITO].
Le quattro spinte hanno segno diverso e ordine di grandezza <= ~5-10% ciascuna: e' il motivo
per cui la banda e' +-15% e non +-5%.

### 4.4 CONTRO-ESEMPIO: la banda distingue dall'ipotesi alternativa?
Un intervallo che non separa il vero dal falso non e' un test (classe 178). Ipotesi alternative
"banco rotto" e il numero che ciascuna produce:

| ipotesi alternativa | n che produce | cade in [90;122]? | il controllo la vede? |
|---|---|---|---|
| il cesto non arriva all'EA, legge solo GBPUSD (`Symbols_List` ignorata) | ~11 (n di GBPUSD in R92) | NO | **si', da n** |
| finestra accorciata di un anno (3,5 anni invece di 4,5) | ~106 x 3,5/4,5 = ~82 | NO (sotto) | si' |
| il lettore somma una gamba sola | IS: ~77 (72,7% di 106); OOS: ~29 | NO | si' -- e' il motivo per cui il lettore somma |
| zero operazioni (banco non gira) | 0 | NO | si' (E0: `Trades>0` obbligatorio) |
| **`Signal_Bar_Offset=1` arrivato al posto di 0** | **non noto** (e' quello che R92b misura: se la frequenza di Claudio tornasse, sarebbe ~1000; se no, ~100-200) | **puo' cadere DENTRO** | **NO, da n non si vede** |
| gemelle diverse (banco non deterministico) | qualunque | qualunque | no da n; **si' da G1** |
| EA diverso da quello del pin | qualunque | qualunque | no da n; **si' da SHA256** |

Le righe 5, 6, 7 sono il punto: **la banda di n, da sola, non separa "offset 0 arrivato" da
"offset 1 arrivato".** Per questo il controllo passa SOLO se valgono **tutte e quattro** le condizioni:
(i) n in [90;122]; (ii) **P0**: la colonna `Signal_Bar_Offset` del CSV vale **0** in tutte le righe di
tutte e due le gambe; (iii) **G1**: le due gemelle identiche in Profit, PF, DD, Trades, in IS e OOS;
(iv) SHA256 di EA e include = pin. La (ii) e' la sola che separa 0 da 1; senza di lei la (i) non
prova niente.

### 4.5 Cosa succede se il controllo NON passa (deciso ora, non dopo)
La riga di lancio **si ferma dopo il controllo**: i lavori a-e **non partono**, la raccolta si fa lo
stesso. Nessun numero dei lavori a-e esiste, quindi nessuno si legge. **La banda NON si allarga
dopo aver visto n**: se n cade fuori di poco (85 o 127) si manda a Claudio con la scomposizione
delle quattro spinte del par. 4.3 (sul per-trade della gamba OOS), e sara' lui a firmare un
criterio nuovo **per il round dopo**.

## 5. LE ATTESE, dichiarate PRIMA, ciascuna col suo contro-esempio

Per ogni attesa: l'ipotesi alternativa, il numero che essa produce, e se cade dentro l'attesa
(allora l'attesa non e' un test e non si usa come tale).

**E1 -- P0, i pin e l'asse sono arrivati (cancello per job, rende NULLO il file).** Tutti gli
input pinnati nel file prova compaiono nel CSV `_OOS` col valore pinnato, e i valori dell'asse
sono esattamente quelli attesi. Alternativa: MT5 ignora in silenzio un input (e' successo con
`InpSymbols=` vuoto, `controlla_prova.py`). L'alternativa produce una colonna diversa: E1 la
vede per costruzione. Limite: `Symbols_List` ha come pin lo stesso valore del default compilato,
quindi E1 NON puo' dire se il pin e' arrivato o se e' stato usato il default -- ma sono identici,
quindi non cambia la misura.

**E2 -- G1 gemelle (lavori 0 ed e, NULLO se falliscono).** Le due righe di ogni CSV sono identiche in
Profit, PF, Equity DD %, Trades. Alternativa: banco non deterministico (dipende dall'agente o
dall'ordine di sincronizzazione dei 22 simboli). Un banco cosi' produrrebbe scarti di qualche
operazione: il confronto e' **esatto** (1e-6), non una banda.

**E3 -- la cella P e' identica nei quattro lavori a, b, c, d (NULLO se no).** P e' misurata 4
volte con 4 magic diversi (nessun hit di cache possibile: l'input differisce). Attesa: Profit,
PF, DD, Trades **identici** in IS e in OOS. Alternativa: non determinismo fra job. Confronto
esatto, su quattro grandezze (un confronto sul solo n non vedrebbe due esecuzioni con stessi n e
uscite diverse).

**E4 -- direzione degli assi (etichetta di lettura, NON cancello).** Ogni filtro, se tolto, non
puo' che aggiungere segnali candidati; percio':
- ATR (a): `n(ATR spento) >= n(ATR acceso)`, in IS e in OOS.
- Multi (b): `n(1.0) >= n(1.1) >= n(1.2)` (bulge piu' esigente = meno segnali).
- ADX (c): `n(ADX spento) >= n(ADX acceso)`, e **lo scarto DIRETTO e' tutto BLU** (l'ADX e' applicato
  solo al BLU: `ADX_Apply_On_Purple=0`, `ADX_Apply_On_Orange=0`); per effetto di percorso (tetto,
  posizione gia' aperta, kill switch) anche VIOLA e ARANCIO possono spostarsi di poco.
- Arancio (d): `n(Arancio acceso) >= n(Arancio spento)`.
- AMPIA (e): `n(AMPIA) >= ` ciascuna delle quattro celle "un asse allargato" (ATR spento, Multi 1.0, ADX
  spento, Arancio acceso).
Alternativa: asse inerte (n uguali e Profit uguale) o invertito. **Cosa NON dice l'attesa**: la
monotonia e' ordinamento per candidati, non per operazioni realizzate: `Max_Trades=4`,
`HasOpenTrade` e il kill switch rendono l'insieme dipendente dal percorso, quindi una violazione
PICCOLA (pochi punti percento) e' compatibile con la meccanica. **Una violazione si scrive come
anomalia con la sua causa cercata** (colonne `Peggior Giornata %` e `Perdite Consecutive Max` del CSV per
il kill switch; per il tetto, il per-trade dell'AMPIA); non c'e' soglia numerica perche' non c'e' una misura su cui
appoggiarla. **L'ampiezza dello spostamento di n NON e' prevista: e' quello che il round misura.**
Caso speciale ADX: se l'asse esce **identico al centesimo** in tutte le quattro grandezze, si guarda il
per-trade dell'AMPIA (ADX spento): se contiene BLU > 0 e l'asse e' esatto-inerte, l'asse e' sospetto
(si ricontrolla P0 su `Use_ADX_Filter`, `ADX_Apply_On_Blue`); se il BLU dell'AMPIA e' 0, l'inerzia e'
coerente (niente da filtrare). Esatto-inerte + BLU>0 e' il numero che l'ipotesi "asse morto" produce, e
non cade dentro un asse sano.

**E5 -- la frequenza: due ipotesi, dichiarate con la loro predizione (etichetta di lettura).**
Ipotesi di **Claudio**: il motore fa ~10,5 operazioni per simbolo per anno (268 in 4,25 anni su 6
simboli, dal suo xlsx) -> sul cesto di 22 in 4,49 anni **~1040** operazioni (n(P, OOS)). E' la media dei SUOI
sei simboli, non una stima sui 22: [DICHIARATO]. Ipotesi **R92 residuo**: la barra 1 non ripristina
la frequenza e restano ~1,07 per simbolo per anno -> n(P, OOS) tra ~100 e ~200. Lettura: n(P, OOS) < 150
= la frequenza resta ~10 volte sotto (e in ogni caso il merito e' SOSPESO, Emendamento A); 150-500 =
parzialmente; >= 500 = ripristinata almeno a meta'. Contro-esempio: n alto NON prova che il motore sia
buono (un banco che rientra piu' volte sulla stesso segnale ne farebbe di piu'): E5 misura la FREQUENZA,
mai il valore, e la conferma di non-duplicati e' `HasOpenTrade` gia' letto nel sorgente.

**E6 -- il profilo di Claudio (S3), dove misurabile.** Ipotesi da falsificare: win rate alto
(80,22% nel suo backtest), perdita media 2,47x la vincita media. Il win rate NON e' nel CSV
dell'ottimizzazione: esce solo dal per-trade. Per-trade **disponibile**: controllo e AMPIA (magic
gemelli, un file per magic, gamba OOS) e **UNA cella per asse** (il file di un magic pinnato viene
sovrascritto da ogni passata; sopravvive l'ultima passata dell'OOS, identificata con la somma dei
`net_profit` contro il `Profit` del CSV). Per le altre celle S3 e' **NON MISURATO** (par. 8).

**E7 -- l'IS e' l'OOS del passo 0.** L'IS 2010-2021 esiste per tutti i 22 cross tranne GBPNZD
(par. 2.1): e' misurato dal passo 0, non presunto.

## 6. LE SOGLIE, e su che cosa si applicano (interpretazione dichiarata)

Le soglie sono quelle firmate il 21/08 e invariate il 29/09: **S1 n >= 30 - S2 PF >= 1,30 - S3 win
rate >= 65% e profitto > 0**. Bocciatura secca invariata: n < 20, profitto <= 0, PF < 1,00.

- **Oggetto** -- in R92 le soglie valevano PER SIMBOLO. Il disegno di R92b (un cesto, un grafico) produce
  **una riga per cella e per finestra sull'aggregato del cesto**, non una riga per simbolo. Quindi qui
  S1/S2/S3 si leggono **per cella x finestra, sul cesto intero**. E' un'interpretazione, la dichiaro:
  se Claudio intendeva altro (per simbolo), il disegno non lo fornisce e si dovra' decidere un round
  ulteriore. La regola di famiglia per simbolo (R92 par. 4) **non e' applicabile**.
- **Finestre (Emendamento B, casa)**: il VECCHIO (IS 2010-2021) giudica il **RISCHIO**, il RECENTE (OOS
  2022-2026) giudica il **MERITO**. S2 e S3 si decidono sull'OOS; l'IS si riporta e serve come
  coerenza di segno. **PF IS < 1 NON boccia** una cella (regola B: non si boccia un motore perche' non
  guadagnava nel 2012); **il DD IS boccia** (un drawdown e' un fatto accaduto).
- **DD alla taglia**: `Equity DD %` di ciascuna gamba <= **10,0%** (rischio 0,80%). Non si conferma
  "sotto il 10%" da una gamba sola: servono tutte e due.
- **n si legge in POSIZIONI, non in deal.** In gestione nuda una posizione chiude con **un solo deal di
  uscita** (nessun parziale, nessun BE, nessun trailing), quindi `Trades` del CSV = posizioni
  [INFERITO dal sorgente]. Sulla cella il cui per-trade e' identificato la riga di lancio stampa
  posizioni (`position_id` distinti) e `Trades` uno accanto all'altro: se divergono vale la posizione e
  la divergenza si scrive (lezione R270: 175 deal su 132 posizioni).
- **n < 150 nella finestra**: il MERITO di quella finestra e' SOSPESO (Emendamento A, valvola R59: il
  campione sottile sospende il giudizio sul merito, mai sul rischio). Il conto si fa su OOS e IS
  separatamente.
- **Stop >= 40 x (spread + commissione)**: **NON MISURABILE da questo round** (il per-trade non porta la
  distanza dello stop e il modello 1 non da' lo spread vero per trade). Si chiude con un calcolo a parte:
  stop = 3 x ATR(14) H1 per cross contro lo spread misurato BCM (`backtest_pipeline/calcola_pedaggio_forex.py`,
  che vuole `--stop`). Finche' non c'e', **nessuna cella supera il cancello di costo**: e' [NON MISURATO],
  non "passato".
- **Rumore A3 = 10,5% relativo** (ereditato da R270c/R208b, [PRESTITO: non ritarato su Bulge]): una cella
  e' "diversa" da P solo se il suo PF OOS differisce da quello di P per piu' del 10,5% del PF di P;
  dentro la banda e' "pari".
- **Selezione**: **nessuna cella si sceglie** (round descrittivo). Il "centro dell'altopiano, mai il picco" vale
  solo per l'asse a tre celle `Bulge_Multi`: il centro e' **1.1 = P**; 1.0 e 1.2 sono **bordi** e, se un
  bordo vince, si scrive "bordo" (classe 907), non "altopiano". Gli assi a due celle sono **contrasti**
  (quanto costa un filtro), non selezioni.

## 7. COSA NON SI PUO' DIRE DI UN ROUND MODELLO 1

1. Nessun verdetto di merito: R57 (segno ribaltato e fino al 49% delle operazioni sparisce a tick).
2. Nessuna cella si promuove; nessun preset, taglia, sedia, conto.
3. Il PF di una cella non e' quello del campo: spread del modello 1 [NON MISURATO], niente slippage, Guardian inerte.
4. Il DD e' quello del tester OHLC: **sottostima** il movimento intrabarra (dichiarato, non quantificato).
5. "Il filtro X non serve" non si dice da un asse a due celle: si dice quanti segnali costa e con che PF.
6. Niente per singolo cross: il disegno non produce una riga per simbolo (par. 8).
7. La sedia `BULGE V520 AMPIO` del piccolo 50503392 NON e' validata ne' bocciata da questo round: gira
   in campo con altri dati, altro spread, altro orologio (BCM UTC+1 fisso).
8. "La frequenza e' tornata" non si dice senza la lettura E5 e senza i limiti di E5.

## 8. COSA IL DISEGNO NON MISURA (limiti gia' noti, scritti prima dei numeri)

- **Win rate (S3) per cella**: solo le celle con per-trade sopravvissuto (controllo, AMPIA, una per asse).
  Le altre: **NON MISURATO**. Chiudere il buco costa una corsa OOS-only per cella con magic gemelli
  (proposta, non implementata; costo [NON MISURATO]).
- **BLU / VIOLA / ARANCIO per cella**: idem (colonna `signal` del per-trade, solo celle sopravvissute).
  In ottimizzazione MT5 non esegue le `Print`: la riga `[BULGE-CONTA]` non c'e'.
- **Per simbolo**: nessuna riga per simbolo.
- **Stop/costo**: par. 6.
- **Gambe separate**: il DD non attraversa il taglio 2021.12.31/2022.01.01.
- **Il comportamento del tester con GBPNZD senza barre nei primi 4 mesi**: [NON MISURATO] fino a R92ba.

## 9. IL TEMPO, [NON MISURATO]

Nessun job di questo tipo (22 simboli, OHLC M1, H1, dal 2010) e' mai girato su questa macchina: **non c'e' un
numero misurato** e non ne scrivo uno. Quello che si puo' dire con onesta':
- costo relativo, in cella-giorni (celle x giorni di finestra): controllo 3282; a 12048; b 18072; c 12048;
  d 12048; e 12048 -> totale **69546 = 21,2 volte il controllo** (26 passate, di cui 22 su 16,5 anni).
- il controllo (il piu' corto) **fissa il ritmo**: la riga di lancio ne stampa i minuti e ne ricava una
  proiezione **proporzionale** [INFERITA: sovrastima, perche' l'overhead fisso di un job viene moltiplicato per
  21 invece che per 6]. Se il controllo dura <= ~28 min il round sta in circa una notte (<= ~10 h);
  28-60 min = piu' di una notte; **> 60 min = la riga si ferma da sola** dopo il controllo (troppo pesante:
  si riscrive il disegno, non si insiste).
- tetto per job = **3 x** la sua proporzione dal controllo; oltre non e' lento, e' bloccato.
- rischio [NON MISURATO]: memoria del tester (22 simboli x 12 anni di M1). Se un job a finestra lunga esce
  senza CSV la riga si ferma (par. 4.5 esteso a R92ba).

## 10. COSA CHIUDE QUESTO FILE

Il round e' pronto a girare quando: (1) i file prova passano `controlla_prova.py` e
`controlla_riga.py --oggetto prova`; (2) la riga di lancio passa `controlla_riga.py --oggetto riga`,
e poi il cancello di giudizio (`controllo-preventivo`); (3) Claudio la manda. Niente di questo
e' stato lanciato o mandato al momento in cui questo file e' scritto.
