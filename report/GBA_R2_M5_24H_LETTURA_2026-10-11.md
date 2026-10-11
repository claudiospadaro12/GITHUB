# GBA R2 M5 A 24 ORE (lotto R2M5H24) -- lettura del 11/10/2026

Fonte: `GBA_R2_M5_24H.zip` (SHA256 `7cd57878126089948226cc6a0860b2016930c1c037cf27391a998ff4b435cca2`; contiene `ESITI_R2_M5_24H.txt` e `GBA_R0_R2M5H24.zip`). Archivio: `backtest_pipeline/risultati_archivio/GBA_R2_M5_24H_20261011/`.
Prova: `backtest_pipeline/prove/GBA_R2_M5H24_2026-10-11.txt` (SHA256 `4DD1D39A...`, identico alla copia dentro lo zip). Lettore: `backtest_pipeline/leggi_gba_r0.py` (SHA256 `9CD02D2A...`, verificato nel repo prima di usarlo; `--autotest` OK, 118 controlli). `leggi_gba_notti.py` (1404C68D) **NON applicabile** a questo lotto (la prova lo dice: senza filtro 00-07 non c'e' una "notte" da leggere): non usato, nessun verdetto per notte.
Questa lettura **non da' nessun verdetto di merito** oltre l'esito neutro E1/E2/E3 della prova. Stato del motore: **NON ANCORA MISURATO**.

## 1. Cancelli (prima di ogni numero)
| controllo | atteso | misura | esito |
|---|---|---|---|
| zip nuovo, non vecchio | pin 44671dc2..., data 11/10 | ESITI: pin `44671dc2cf24f43473a70ebe1b74e749f9e5defe`, 17:57:44-18:01:31 dell'11/10, rc 0, 4 min; RIEPILOGO: data 2026-10-11 18:01:30, stesso pin, PC DESKTOP-H4D7CAJ | OK |
| compilazione | 0 errori | RIEPILOGO e `compile_gba.log`: 0 errori, 0 avvisi; EA SHA 1381E3DC... (v1.10, invariato) | OK |
| passate | 3 su 3 | 3 OK, 0 KO; 48-49 s l'una; 100% tick reali; barre/tick uguali fra barre generate e report | OK |
| G0 (lettore) | OK per passata | G0 OK x3 | OK |
| UNA variabile | solo `InpHourEnd` 7 -> 24 | `diff` degli ini T1-T3 contro quelli archiviati di R2NOTTEM5: differiscono SOLO in `InpHourEnd` (7 -> 24) e nel nome del Report | OK |
| CONTROLLO DIRETTO (nessun filtro orario) | riga ESECUZIONE `(nessun filtro orario)`, ingressi in >= 5 fasce su 6 | log T1-T3: `InpHourEnd=24 (nessun filtro orario)`; fasce con n > 0: 6 su 6 (296 / 230 / 136 / 227 / 159 / 12) | OK |
| stessi segnali di R2NOTTEM5 | stesse barre di rottura | segnali EA 1290 / 1129 / 1110 in T1 / T2 / T3, identici a R2NOTTEM5 | OK |
| prova nello zip = prova nel repo | SHA uguale | `4dd1d39a...` uguale | OK |

## 2. Numeri chiave (1 lotto fisso, deposito fittizio 1.000.000 EUR, commissione del tester inclusa nel PF_V)
| lotto / cella | n totale | PF_V totale | netto EUR | T1 n / PF | T2 n / PF | T3 n / PF |
|---|---:|---:|---:|---|---|---|
| **R2M5H24, M5 24 ore (questo lotto)** | **1.060** | **0,918** | **-40.072** | 336 / 0,897 | 343 / 0,873 | 381 / 0,954 |
| R2NOTTEM5, M5 00-07 (termine di confronto) | 303 | 1,325 | +37.319 | 93 / 0,873 | 97 / 0,848 | 113 / 2,094 |
| R2NOTTEM1, M1 00-07 | 143 | 0,928 | -5.047 | 6 / 0,110 | 33 / 0,471 | 104 / 1,123 |
| R1A, M1 24 ore (filtro 0,05 x ATR M1; PF_V; tranche a 2 decimali, uguali al PF del report) | 933 | 0,855 | -53.819 | 128 / 0,83 | 248 / 0,77 | 557 / 0,89 |

(R2NOTTEM1/R2NOTTEM5 da `report/GBA_R2_NOTTE_M5_LETTURA_2026-10-11.md` e dalla lettura rifatta oggi dello stesso zip M5; R1A da `report/GBA_R0_R1A_LETTURA_2026-10-10.md`. Il confronto con R1A mescola TF e filtro di spread: la prova lo dice, il solo confronto che isola la finestra oraria e' quello con R2NOTTEM5.)
- Frequenza H24: 5,17 / 5,36 / 6,05 operazioni al giorno feriale. Long 535 (PF_V 0,92, -19.947), short 525 (PF_V 0,92, -20.125). Win rate 29%. Uscite: 1.054 a stop (PF 0,856), 6 a mercato.
- Costo (S2), mediana stop/spread: 70,5x solo spread, **59,7x con +0,04 USD/oz**, 51,7x con +0,08 (16% sotto 40x). PASSA in tutte e tre le versioni.
- DD equity a 1 lotto: T1 22.802, T2 34.925, T3 47.781 EUR (la % non si legge: deposito fittizio). Contro R2NOTTEM5 (11.534 / 21.663 / 11.549): 1,98x / 1,61x / **4,14x**.
- Concentrazione (S5, per operazione): migliore operazione = 4% del profitto positivo; netto senza le 5 migliori -93.233; il lettore scrive FRAGILE (con netto totale gia' negativo la regola si attiva meccanicamente; non aggiunge informazione).

## 3. Esito della prova (applicato alla lettera)
Pre-condizioni: lettura valida (G0 OK, CONTROLLO DIRETTO OK) e n totale >= 520 -> 1.060, **nessun guasto**.
- **PF_V totale = 0,918 <= 1,03 -> E1.**
- E2 non puo' valere insieme a E1 (richiede PF_V totale >= 1,3): PF_V di tranche > 1,3 con n >= 150: **0 su 3**. E3 e' il complemento: non scatta. Verificato anche con `tabella_decisione_gba_m5h24.py` (strumento di analisi, non passato dal cancello): `esiti('L', n_ok=True, k=0) = ['E1']`.

> **E1, testo della prova:** cella H24 indistinguibile dalla REPL e da 1,0 (S8): **non e' un candidato**; si scrive il numero (PF_V 0,918, n 1.060) e la colonna per tranche (0,897 / 0,873 / 0,954). **COMPATIBILE con [N] e con [R]**: quale, lo DESCRIVONO la colonna per tranche e le sei fasce; nessuna delle due si scrive come verdetto.

## 4. Attese scritte prima contro misura
| voce (prova) | attesa / soglia | misura | esito |
|---|---|---|---|
| n totale | ~1.045, banda 820-1.275 | 1.060 | dentro |
| n per tranche | ~335 / 340 / 370 | 336 / 343 / 381 | dentro |
| range producibile / smentita simulatore | 520-2.394 / n < 700 o > 1.600 | 1.060 | nessuna smentita, nessun guasto |
| PF_V totale | 0,75-1,10; fuori se >= 1,25 | 0,918 | dentro; non >= 1,25 |
| PF_V totale <= 1,03 su n >= 150 | = indistinguibile dalla REPL (S8) | 0,918 | **scatta (= E1)** |
| fascia asia dentro H24 | n 200-350 (atteso ~290; 240-330); PF_V banda 1,10-1,55 (~R2NOTTEM5) | n 296; PF_V **1,111** | n dentro; PF_V sul bordo basso della banda (NON una soglia) |
| fasce n (atteso, simulato/1,13) | europa ~240, pausa ~130, USA apertura ~210, USA pomeriggio ~160, rollover ~20 | 230, 136, 227, 159, 12 | tutte compatibili |
| giorno 07-22 n | ~730 (pavimento ~360-410) | 752 | dentro |
| fascia giorno PF_V < 1,0 (piano r.214) | unione 07-22 | **NON stampata dal lettore** -> NON MISURATO per la regola della prova (vedi 5); il segno e' implicato dal netto 07-22 di -65.714 (strumento non passato): PF_V < 1,0 (0,820), descrizione, non esito; fasce singole: europa 0,56, pausa 1,13, USA apertura 0,65, USA pomeriggio 1,33 | NON MISURATO per la regola della prova; compatibile con "< 1,0" come descrizione |
| costo mediano (+0,04) | 52-68x -> PASSA | 59,7x | dentro |
| DD "fino a ~3x" R2NOTTEM5 [INFERITO] | ~3x | 1,98x / 1,61x / **4,14x** | T3 FUORI dall'attesa (non e' una soglia: si legge, non si giudica) |
| effetto della sequenza sulla fascia asia | "PICCOLO" (330 contro 333) | n 296 contro 303 (-7), ma netto 12.732 contro 37.319 | n come previsto; **il netto NO** (vedi 5) |

## 5. Colonna per tranche e sei fasce (descrizione; nessuna frase e' un verdetto)
| fascia (ora server dell'ingresso) | n | PF_V | netto EUR | PF_V per tranche T1 / T2 / T3 |
|---|---:|---:|---:|---|
| asia 00-07 | 296 | 1,111 | +12.732 | 0,87 / 0,79 / 1,58 |
| europa 07-12 | 230 | 0,560 | -50.552 | 1,09 / 0,62 / 0,35 |
| pausa 12-14 | 136 | 1,131 | +6.574 | 1,05 / 1,28 / 1,09 |
| USA apertura 14-17 | 227 | 0,654 | -44.981 | 0,48 / 0,72 / 0,70 |
| USA pomeriggio 17-22 | 159 | 1,332 | +23.244 | 1,72 / 1,11 / 1,36 |
| rollover 22-24 | 12 | 3,211 | +12.910 | n 1 / 9 / 2 (sospesa, n < 100) |
S6 (media di r contro zero, p < 0,0083, n >= 100, stesso segno in >= 2 tranche): nessuna fascia distinguibile da zero (p piu' basso: europa 0,024). Per il verdetto per regime (firma 10/10): **NON MISURATO** (nove mesi, nessun regime di 4 tranche; con la regola "2 trimestri" il lettore stampa NON REGGE per LATERALE e VOLATILE, ma e' una decisione APERTA di Claudio e non e' usata qui).

**Notte contro resto, SOLO descrizione** (strumento mio, non passato dal cancello; il resto 07-24 NON e' l'unione 07-22 della prova perche' include le 12 operazioni di rollover; netto notte + resto = totale, controllato):
| | n | netto EUR | netto medio EUR | PF_V |
|---|---:|---:|---:|---:|
| notte 00-07 | 296 | +12.732 | +43 | 1,111 |
| resto 07-24 | 764 | -52.804 | -69 | 0,858 |
| (di cui 07-22: n 752, netto -65.714; l'unione 07-22 e' NON MISURATA per la regola della prova, nessun lettore passato ne stampa il PF_V; un netto negativo implica PF_V < 1,0, 0,820 con il mio script: descrizione, non esito) | | | | |
Per tranche, notte: T1 93 / -3.818, T2 94 / -8.603, T3 109 / +25.154; resto: T1 243 / -7.174, T2 249 / -9.761, T3 272 / -35.869.

**Confronto "ingressi comuni" con R2NOTTEM5** (funzioni di `gba_ingressi_comuni.py` importate senza modificarlo -- il file porta nell'intestazione "Bozza, NON passata dal cancello" (r.1-2), quindi anche questo confronto poggia su uno strumento NON passato; chiave = tranche + data-ora server dell'ingresso + lato; solo ingressi 00:00-06:59 di H24):
- 296 comuni su 303: **per tutti e 296 stesso prezzo e volume d'ingresso, stesso S/L iniziale, stessa ora d'uscita, stesso netto al centesimo** (controllo della chiave). Solo-H24 (ADDED): 0. Solo-R2NOTTEM5 (REMOVED): **7**, netto **+24.587** (T1 0, T2 3 / +2.278, T3 4 / +22.309).
- I 7 hanno, in H24, una posizione gia' aperta che occupa lo slot (una per volta): 3 sono posizioni che attraversano la pausa (sezione 6), 4 sono ingressi delle 23:10-23:35. I 7 includono i rango 1, 2 e 5 su 303 di R2NOTTEM5 per netto. Contro-esempio al "sfortuna": sorteggiando 7 operazioni a caso su 303, P(netto rimosso >= +24.587) = 0,0001 (20.000 estrazioni, seed 777) -- non e' una rimozione casuale; la causa comune (la stessa mossa che fa vincere la posizione serale fa vincere anche l'ingresso dopo la riapertura) e' una lettura, non dimostrata.
- Effetto: la fascia asia dentro H24 e' **la stessa sequenza di R2NOTTEM5 tranne 7 ingressi**, ma PF_V 1,325 -> 1,111 e netto +37.319 -> +12.732. I 296 comuni sono ESATTAMENTE R2NOTTEM5 senza quei 7. (La prova prevedeva questo effetto "piccolo" in n; in netto non lo e'.)

## 6. Posizioni aperte durante la pausa giornaliera dei prezzi (controllo dichiarato; regola del repo: buco 23:00-00:05 server fino all'08/03/2026, 22:00-23:00 dal 09/03)
| | n | PF_V | netto EUR |
|---|---:|---:|---:|
| totale H24 | 1.060 | 0,918 | -40.072 |
| **attraversano la pausa** | **28** | 13,31 | **+62.800** |
| resto, tolte le 28 (insieme SELEZIONATO su una conseguenza del trattamento, classe 1315: non e' la cella) | 1.032 | 0,786 | -102.871 |
| per tranche, attraversanti | T1 6 / +2.580, T2 8 / +17.041, T3 14 / +43.179 | | |
| per tranche, resto tolte le 28 (stessa avvertenza) | T1 330 PF 0,871; T2 335 PF 0,756; T3 367 PF 0,766 | | |
- **Tutte le 28 sono ingressi 19:35-21:50, quindi stanno nella fascia "USA pomeriggio"**: senza di loro quella fascia ha n 131, PF_V **0,390**, netto -39.555 (con le 28: n 159, PF_V 1,332, +23.244); contabilmente, attribuzione [NON ATTRIBUITA], classe 1315. Le altre cinque fasce non hanno attraversanti.
- Escono tutte dopo la riapertura (fra le 23:05 e le 01:24 server; per 3, dopo un fine settimana: lun 23/02 01:01, lun 02/03 00:06, dom 12/04 23:10 server) con commento `sl <livello>`; la piu' grande: 28/01 21:05 -> 29/01 00:39, +18.104 (e' il netto singolo piu' alto dell'intero lotto).
- Contro-esempi alla regola: (i) finestre della pausa a confronto (script `finestre_pausa_m5h24.py`, non passato dal cancello): regola del repo (23:00-00:05 fino all'08/03, 22:00-23:00 dal 09/03) **28 attraversanti, +62.800, resto 0,786**; buco dei tick misurato dal cancello sui giornali 2026 (22:55-00:04 prima del 09/03, 21:55-23:00 dopo) **28 / +62.800 / 0,786**; trading fermo (21:55-00:05 d'inverno, 21:55-23:05 d'estate) **28 / +62.800 / 0,786**, stesso insieme di 28 in tutte e tre; finestra LARGA (22:00-00:05 in ogni data) **41 / +74.268 / 0,759**: la conclusione non dipende dalla finestra scelta (e vale la cautela sul 0,786 scritta nel punto "Cosa NON dice" qui sotto); (ii) giornali: i `retcode 10018 (market closed)` sono 0 in T1, 5 in T2 (10/04, ore 21:50:00-21:54:04 server), 246 in T3 su 11 giorni (ore 21:52:21-22:54:55 server, tutte prima del 09/03; 243 spostamenti SL + 3 ordini, quindi i "DA GUARDARE" del lettore SONO questo fenomeno). **Coincidono con le POSIZIONI, non con la FINESTRA della regola**: in T3 cadono fra 21:52 e 22:55, cioe' prima della finestra invernale 23:00-00:05 della regola del repo (e in T2 prima del buco dei tick di 21:55); la copertura e' per data, non per istante: **10 dei 12 giorni** con errori (1 in T2, 11 in T3) coincidono con una posizione attraversante (gli altri due, 26/01 con 1 riga e 04/02 con 2 righe, sono ordini rifiutati, non coperti); (iii) R2NOTTEM5 ha 0 attraversanti con la regola del repo (1 con la finestra larga).
- Cosa NON dice: non dice che le attraversanti siano "un artefatto del tester" (in reale esistono, con gap reali) ne' che siano un edge; non cambia E1 (che e' definito sul PF_V totale 0,918); dice che **il totale 0,918 contiene 28 operazioni che valgono +62.800** e che il resto, tolte loro, fa 0,786. Quel 0,786 NON e' un PF della cella: le 28 esistono SOLO per il trattamento (con InpHourEnd=7 nessuna posizione arriva alla pausa: R2NOTTEM5 ne ha 0), quindi toglierle e' una selezione su una conseguenza del trattamento (classe 1315, regola 2). Quanta parte del loro +62.800 venga dalla pausa stessa (uscita prevista contro uscita effettiva, classe 1315 regola 1) NON e' misurato: [NON ATTRIBUITA]. Precedente nel repo: R2U (`report/GBA_R2_USCITA_LETTURA_2026-10-11.md`, ERRATA) e R1A (4 attraversanti in REPL).

## 7. Bootstrap per giorno (DESCRITTIVO; `leggi_gba_r0.py` non lo stampa, strumento mio non passato dal cancello; 5.000 ricampionamenti, seed 12345, giorno server dell'ingresso)
| insieme | n | PF_V | giorni | IC95 |
|---|---:|---:|---:|---|
| H24 totale | 1.060 | 0,918 | 195 | [0,742 ; 1,123] |
| H24 senza le 28 attraversanti (insieme SELEZIONATO su una conseguenza del trattamento, classe 1315: l'IC descrive quel sottoinsieme, non la cella) | 1.032 | 0,786 | 195 | [0,636 ; 0,963] |
| H24 fascia asia | 296 | 1,111 | 165 | [0,761 ; 1,594] |
| H24 resto 07-24 | 764 | 0,858 | 194 | [0,639 ; 1,112] |
| R2NOTTEM5 (ancora) | 303 | 1,325 | 167 | [0,930 ; 1,839] |
| H24 T1 / T2 / T3 | 336 / 343 / 381 | 0,897 / 0,873 / 0,954 | 66 / 67 / 62 | [0,62;1,28] / [0,64;1,17] / [0,67;1,34] |
L'IC del totale contiene 1,0 e l'intervallo S8 della REPL [0,70 ; 1,03]. Controllo del mio strumento: sull'ancora R2NOTTEM5 da' [0,930 ; 1,839] contro il [0,943 ; 1,836] del bootstrap per notte gia' archiviato (stesso ordine di grandezza con unita' di ricampionamento diversa).

## 8. Quale spiegazione e' COMPATIBILE coi numeri (descrizione, la prova lo chiede; nessuna e' un verdetto)
- **[TF] "conta M5 + filtro, non la notte" (atteso: giorno rende come la notte, totale >= 1,25):** il totale e' 0,918 e il resto 07-24 e' 0,858: **non compatibile con questa previsione**.
- **[N] "conta la notte" (atteso: asia ~1,3, giorno < 1,0, totale 0,85-1,05):** totale dentro (0,918); asia 1,111 (banda larga 1,10-1,55, sul bordo basso); giorno: europa e USA apertura < 1, ma pausa 1,13 e USA pomeriggio 1,33 (contabilmente: senza le 28 la fascia USA pomeriggio fa 0,390; attribuzione [NON ATTRIBUITA], classe 1315). Compatibile sul totale; la meta' "giorno < 1,0" come unione e' NON MISURATA per la regola della prova (nessun lettore passato la stampa), ma il segno e' implicato dal netto 07-22 di -65.714 (PF_V < 1,0, 0,820, strumento non passato): compatibile anche nella meta' giorno, come descrizione, non come esito.
- **[R] "conta il regime" (atteso: T3 >= 1,3, T1 e T2 < 1,0):** sul totale per tranche NON c'e' un T3 >= 1,3 (0,954); sulla sola fascia asia SI' lo schema (1,58 contro 0,87 / 0,79). Compatibile; non separabile da [N] con tre tranche del 2026.
- H-M5N INTERA (notte >= 1,3 in ogni tranche con n >= 150 e giorno < 1,0): **NON MISURABILE** (notte 93-109 per tranche; unione 07-22 non stampata: NON MISURATA per la regola della prova, anche se il netto 07-22 negativo ne implica il segno). Mai "confermata" ne' "smentita". Controesempio (b): non si decide; (a): la colonna per tranche e' stampata e descritta, nessun "regime"; (c): vedi 5 (la fragilita' per notte della R2NOTTEM5 dipende anche da 7 ingressi che H24 non ha).

## 9. Sorprese e incoerenze
1. **Il totale e la fascia USA pomeriggio contengono 28 posizioni che attraversano la pausa** (+62.800): contabilmente, senza le 28 il resto fa 0,786 e la fascia USA pomeriggio 0,390; attribuzione [NON ATTRIBUITA], classe 1315 (il 0,786 non e' un PF della cella). Non e' nell'attesa della prova (che parlava di blocchi fra notte e giorno, non di pausa).
2. **La fascia asia perde 7 ingressi rispetto a R2NOTTEM5 e con loro 24.587 EUR**: in n e' l'effetto "piccolo" previsto, in netto e' il 66% del netto di R2NOTTEM5. La R2NOTTEM5 non e' quindi la "stessa cella" della fascia asia dentro H24 a parita' di rendimento.
3. DD di T3 4,14x contro "fino a ~3x" [INFERITO]. Non e' una soglia.
4. Nessun conto a mano sui numeri gia' visti: tutto quanto sopra e' stampato da `leggi_gba_r0.py` (sez. 1-4, 5 fasce, S8) o da due script miei (`analisi_m5h24.py`, `finestre_pausa_m5h24.py`) e da `gba_ingressi_comuni.py` (intestazione "Bozza, NON passata dal cancello"), tutti NON passati dal cancello (sez. 5 notte/resto e comuni, 6, 7); script e output sono archiviati per essere rifatti. Riserve su `analisi_m5h24.py` (NON va promosso a lettore): soglia del sorteggio rim=24587.09 e DD della sezione K scritti fissi nel codice; dipende da `gba_ingressi_comuni.py`, non passato; la copertura dei 10018 e' per data e non per istante; la regola della pausa e' fissa nel codice (d'inverno non include 22:00-22:55); contiene righe morte.

## 10. Limiti e cosa NON dice
- In-sample, tre tranche del 2026 (gen-set), un solo orologio BCM (UTC+1 fisso), 1 lotto, deposito fittizio; DD e netto in EUR non sono quelli di un conto vero. Le sei tranche 2024-25 e la tranche T0 (dal 01/10/2026) NON sono in questo lotto.
- **Non separa il TF dal filtro di spread** (0,05 x ATR M5 in tutte e due le celle): ogni "[TF]" vuol dire "M5 + filtro".
- Non dice che la notte conta, non dice che non conta, non dice che il motore e' "morto" (la parola e' vietata: il certificato non e' completo), non promuove nessuna cella.
- Il PF_V dell'unione 07-22 e la concentrazione per GIORNATA NON sono stampati da nessun lettore passato: **NON MISURATI** per la regola della prova (per 07-22 il segno e' implicato dal netto -65.714: PF_V < 1,0, 0,820, descrizione). Le cifre "resto 07-24" e bootstrap di questo documento sono descrizione di uno strumento non passato dal cancello.
- Gemini: **DOVUTO per la regola dell'11/10** (zip letto, cella che esce dall'imbuto) e **NON ancora spedito: pendente**. Domande candidate (max 3, falsificabili, una per chiamata): (1) le 28 posizioni attraversanti sono un fenomeno del tester o esistono in reale con gap analoghi? (2) quale misura separerebbe TF e filtro di spread senza il lotto R2M5SOGLIA scartato? (3) che controesempio rompe "i 7 ingressi persi sono sequenza e non mercato"?

## 11. Certificato dei 5 punti (CLAUDE.md 09/09): caselle che MANCANO
Verdetto: **NON ANCORA MISURATO**. 1 PF misurato: si' (R1A, e qui 0,918). 2 n e DD: si'. **3 uscita ad asse**: lotto R2U girato e letto l'11/10 (`report/GBA_R2_USCITA_LETTURA_2026-10-11.md`, con ERRATA multiple sul tema pausa): non la riesamino qui, ma lo stesso fenomeno delle attraversanti e' emerso anche li. **4 simboli gemelli: NO** (solo XAUUSD). **5 TF cambiato: APERTA** (M5 su 3 tranche, non sulle 9 del piano: manca R2T 24 ore su T4-T9, e T0). Il lotto non chiude nessuna casella.

## 12. Cosa il cancello deve ricontrollare
- Lo SHA del lettore (9CD02D2A) e della prova (4DD1D39A) nel repo, e che gli E1/E2/E3 qui siano scritti con le parole della prova.
- Che la sezione 6 (attraversanti) e la sezione 5 (comuni e 7 persi) non diventino un verdetto: sono descrizione di strumenti non passati (`backtest_pipeline/risultati_archivio/GBA_R2_M5_24H_20261011/analisi_m5h24.py`, `finestre_pausa_m5h24.py`, e `gba_ingressi_comuni.py` con intestazione "Bozza").
- La regola della pausa (23:00-00:05 fino all'08/03, 22:00-23:00 dal 09/03) e' ripresa dal repo (ERRATA R2U), non misurata di nuovo sui prezzi. I `10018` dei giornali coincidono con le POSIZIONI (10 giorni su 12), non con la FINESTRA (cadono 21:52-22:55 in T3, prima della finestra invernale); l'insieme delle 28 e' lo stesso con la regola del repo, col buco dei tick (22:55-00:04 / 21:55-23:00) e col trading fermo (21:55-00:05 / 21:55-23:05), 41 con la finestra larga.
- Che "S5 FRAGILE" su un netto gia' negativo sia letto come meccanico.
