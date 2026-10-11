# Regimi del Dow BCM (U30USD H1, 2024.09.26 -> 2026.10.09): etichette con la regola DK, finestre dichiarate, lettura per H3 (11/10/2026)

**BOZZA, NON passata dal cancello.** Strato 1 (`controlla_riga.py --oggetto md`) in coda a questo file; strato 2 (`controllo-preventivo`) NON lanciato. Nessuna decisione, nessuna firma, niente mandato a Claudio.
**Perimetro**: sola lettura. Un solo CSV (`backtest_pipeline/risultati_archivio/EXPORT_BARRE_DOW_H1_20261011/U30USD_H1_91fbb7cf1900.csv`, SHA256 `FAE044F51EE46CDC6B418D33CCE5FACC94217F441BF20CF95919BC9002B6DC57`, 11.755 barre, `2024.09.26 16:00` -> `2026.10.09 20:00`, UTC+1 fisso confermato dal collaudo, `report/EXPORT_BARRE_DOW_H1_LETTURA_2026-10-11.md`). Nessun trade letto, nessun PF: **si etichetta il MERCATO, NON si giudica il merito di EMA200.** Forward, sedie, terminali, preset, conti non toccati.
**Strumento**: `backtest_pipeline/etichetta_regimi_dow.py` (SHA256 `772cfcd34a444d80a1c971dbbcd7fc7bebe236941c3b01660e0baf504a39417d`). La versione con regola, attese e contro-esempio scritti in testa e' il commit `0c06197e` su `lavoro`, **pushato prima di girare sul CSV vero**; il commit successivo corregge SOLO tre numeri di riga citati (r.187->r.186 due volte nei commenti, r.188->r.193 nel testo di una descrizione stampata): nessuna riga di logica, nessuna soglia, nessuna attesa cambiata (verificabile con `git diff 0c06197e`). Rifiuta ogni CSV con SHA256 diverso.
Etichette: `[MISURATO]` calcolato dal CSV · `[DERIVATO]` mio conto su misurati · `[DICHIARATO]` scelta mia dichiarata · `[NON MISURATO]` buco.

## 0. In otto righe

1. **OOS (b) 2025.06.12-2026.06.26 = TORO** (R +21,03 %, DD 11,15 %): **come atteso**, dentro tutte e due le bande; stabile al taglio (25 varianti su 25). `[MISURATO]`
2. **IS (a) 2024.10.22-2025.06.06 = LATERALE** (R -0,19 %, DD **18,46 %**); IS di contratto 2024.09.26-2025.06.09 = LATERALE (R +1,40 %, stesso DD). Attesa: nessuna (misura nuova); fra le tre ipotesi scritte ha prodotto **H_laterale**. `[MISURATO]` Il nome LATERALE ignora il DD per costruzione (la regola DK guarda solo |R| <= 5): dentro c'e' un calo di 18,46 % in 66 giorni (picco `2025.01.31 12:00`, fondo `2025.04.07 07:00`).
3. **Il feed intero e' MISTO** (R +22,48 %, DD 18,46 %: nessuna regola scatta, il TORO si ferma sul DD >= 15 %).
4. **Inverno 2024/25 (nov-mar) = LATERALE** (R +0,28 %, DD 9,73 %). **Inverno 2025/26 (origine) = LATERALE** (R -2,88 %, DD 11,15 %), come atteso.
5. **apr-ott 2025 = TORO** (R +13,50 %, DD 13,08 %: a 1,9 punti dal 15 %); **apr-9 giu 2025 (parte IS) = LATERALE** (R +2,06 %); **apr-ott 2026 (incompleto, feed fino al 09/10) = TORO** (R +11,35 %, DD 7,42 %: a 1,35 punti dal +10 %).
6. **H3, solo la parte "etichetta": 2024/25 e' VALUTABILE nella variante ridotta (inverno LATERALE contro apr-9 giu LATERALE) e NON VALUTABILE nella completa (LATERALE contro TORO).** 2025/26 e' l'origine e non conta (e comunque LATERALE contro TORO = no).
7. **Gli inverni BCM che possono contare sono UNO (2024/25), e solo con la variante ridotta**: la scheda stessa dichiara quel confronto "ridotto". Con N <= 3 la regola H3 dice **NON MISURABILE con queste finestre**: questo feed non cambia quel verdetto.
8. **La classe AVVERSE (ORSO + CROLLO) non compare in nessuna finestra dichiarata del feed BCM** (tabella sez. 3). `[MISURATO]` Cosa vuol dire per l'Emendamento C non lo decido io (serve DK, quindi P1/P3, F1).

## 1. La regola (fonte, riga, soglie) -- scritta prima dei numeri

**Fonte primaria**: `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` **riga 58** (sez. 1.3, "Regola di etichettatura, scritta ora"), che la scheda `report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md` cita come "regola DK" (sez. 1.8 r.118; H3 r.195). Sulle **chiusure H1** della finestra:

| etichetta | condizione (riga 58) |
|---|---|
| TORO | rendimento >= +10 % **e** DD < 15 % |
| ORSO | rendimento <= -5 % **e** DD >= 15 % |
| CROLLO | DD >= 25 % in <= 3 mesi |
| LATERALE | \|rendimento\| <= 5 % |
| MISTO | **nessuna** regola scatta, **oppure ne scattano due** (le quattro non sono ne' esclusive ne' esaustive) |

**Definizioni che la riga 58 non da' e prese da** `report/FIRME_DA_FARE_2026-10-05.md` sez. 1.2 (r.34-41) e sez. 1.3 (r.57): R = prima -> ultima chiusura H1 della finestra; DD = massimo picco-fondo sulle chiusure; "3 mesi" = **92 giorni di calendario**; crollo **lettura (i)** = esiste un calo >= 25 % con picco e fondo a <= 92 giorni (DD3m); **lettura (ii)** = il calo massimo dura <= 92 giorni. Etichetta primaria = (i) (e' quella che le tabelle di casa usano, r.57); la (ii) si stampa accanto: **in tutte le dieci finestre (i) e (ii) coincidono**.
**Stato della firma `[DICHIARATO]`**: le soglie della riga 58 sono "mie: vanno firmate" (stessa riga); F1 «FIRMO DK DOW REGIME» e la regola unica R-0 «FIRMO REGOLA REGIMI» risultano **non firmate** (`report/MIGLIORA_EMA200_DOW_771531_2026-10-08.md` r.151; la scheda dell'11/10 le richiede ancora a r.268). **Ogni etichetta qui e' quindi PROVVISORIA come regola.** Accanto alle etichette stampo, solo come nota, quella della regola unica proposta (precedenza CROLLO > ORSO > LATERALE > TORO): **in tutte le dieci finestre e' uguale all'etichetta DK**, quindi la questione della firma non sposta nessun numero di questo referto.
**Mie scelte, dichiarate**: finestra = barre con data server fra inizio 00:00 e fine 23:59; "prima chiusura" = chiusura della prima barra (la variante dall'apertura, `R_open`, e' in tabella sez. 3 solo come informazione); soglie confrontate dopo arrotondamento a 9 decimali; il DD e' sulle sole **chiusure** H1 (il DD intrabarra e' piu' grande e **non** e' misurato qui).

## 2. Le attese (scritte prima, commit `0c06197e`) e l'esito

Fonte delle attese: SOLO la proxy della scheda sez. 1.8 (mediane mensili dei prezzi di uscita OOS, grossolana, DD sottostimato).

| finestra | attesa scritta prima | ipotesi alternativa e numero che la produce | esito sul CSV |
|---|---|---|---|
| OOS (b) 2025.06.12-2026.06.26 | **TORO**; R +15...+25 %; DD 6...13 % | MISTO se DD >= 15,0 % (>= 7,4 punti oltre la proxy 7,6 %) | **TORO, R +21,03 (dentro), DD 11,15 (dentro).** Il DD vero sta sopra la proxy di 3,6 punti (come previsto: la proxy lo sottostima) e a 3,85 punti sotto il 15 % |
| OOS di contratto 2025.06.10-2026.06.30 | stessa | stessa | **TORO**, R +22,06, DD 11,15 |
| IS (a) 2024.10.22-2025.06.06 | **nessuna attesa: misura nuova**. Ipotesi: H_toro (R >= +10 e DD < 15) / H_laterale (\|R\| <= 5) / H_misto (resto) | -- | **H_laterale**: R -0,19 %. H_toro e H_misto no |
| IS di contratto 2024.09.26-2025.06.09 | idem | -- | **H_laterale**: R +1,40 % |
| inverno 2025/26 (origine) | **LATERALE**; R -7...+5 % (proxy nov 47.290 -> mar 46.467 = -1,7 %) | MISTO se R < -5 con DD < 15 | **LATERALE, R -2,88 (dentro)**. Come atteso |
| inverno 2024/25, apr-ott 2025, apr-9 giu 2025, apr-ott 2026, feed intero | **nessuna attesa: misura nuova** (per apr-ott 2026 la proxy finisce a giugno: ipotesi TORO contro MISTO) | -- | vedi sez. 3 |

Detto in chiaro: **le tre finestre con un'attesa scritta (OOS dichiarato, OOS di contratto, inverno 2025/26) l'hanno confermata tutte e tre** (la fonte e' la proxy della scheda, quindi non e' una prova indipendente dell'ipotesi della scheda: e' il controllo che il CSV e la proxy dicono la stessa cosa), e **sette finestre sono misure nuove senza attesa** (IS_a, IS_c, inverno 2024/25, apr-ott 2025, apr-9 giu 2025, apr-ott 2026, feed intero), come dichiarato.

## 3. Le etichette, con i numeri `[MISURATO]`

Quota "taglio" = su quante delle varianti (inizio e fine spostati di -30,-15,0,+15,+30 giorni, tagliate ai limiti del feed, doppioni tolti) l'etichetta primaria resta la stessa. **Non e' un criterio**: dice quanto il nome e' fragile.

| sigla | finestra | barre | R % | R da apertura % | DD % | DD3m % | regole scattate | ETICHETTA | giornaliera | taglio |
|---|---|---:|---:|---:|---:|---:|---|---|---|---|
| IS_a | 2024.10.22-2025.06.06 (scheda) | 3529 | -0,19 | -0,27 | 18,46 | 18,46 | LATERALE | **LATERALE** | LATERALE | 21/25 |
| IS_c | 2024.09.26-2025.06.09 (contratto) | 3930 | +1,40 | +1,59 | 18,46 | 18,46 | LATERALE | **LATERALE** | LATERALE | 13/15 |
| OOS_b | 2025.06.12-2026.06.26 | 6062 | +21,03 | +21,05 | 11,15 | 11,15 | TORO | **TORO** | TORO | 25/25 |
| OOS_c | 2025.06.10-2026.06.30 (contratto) | 6155 | +22,06 | +22,07 | 11,15 | 11,15 | TORO | **TORO** | TORO | 25/25 |
| INV24 | nov-24..mar-25 | 2268 | +0,28 | +0,34 | 9,73 | 9,73 | LATERALE | **LATERALE** | LATERALE | 17/25 |
| EST25 | apr-ott 2025 | 3478 | +13,50 | +13,49 | 13,08 | 13,08 | TORO | **TORO** | TORO | 19/25 |
| EST25r | apr - 9 giu 2025 (parte IS) | 1110 | +2,06 | +2,05 | 13,08 | 13,08 | LATERALE | **LATERALE** | LATERALE | 14/22 |
| INV25 | nov-25..mar-26 (**origine**) | 2306 | -2,88 | -2,72 | 11,15 | 11,15 | LATERALE | **LATERALE** | LATERALE | 19/25 |
| EST26 | apr-ott 2026 (**incompleto**, fino al 09/10) | 3151 | +11,35 | +11,55 | 7,42 | 7,42 | TORO | **TORO** | TORO | **2/10** |
| FEED | 2024.09.26-2026.10.09 (contesto) | 11755 | +22,48 | +22,72 | 18,46 | 18,46 | nessuna | **MISTO** | MISTO | 9/9 |

Picchi e fondi dei DD: IS e feed intero = picco `2025.01.31 12:00`, fondo `2025.04.07 07:00` (66 g); OOS e inverno 2025/26 = picco `2026.02.10 15:00`, fondo `2026.03.30 00:00` (47 g); inverno 2024/25 = picco `2025.01.31 12:00`, fondo `2025.03.13 18:00` (41 g); apr-ott 2025 = picco `2025.04.02 17:00`, fondo `2025.04.07 07:00` (5 g); apr-ott 2026 = picco `2026.08.05 14:00`, fondo `2026.10.01 15:00` (57 g).
**Prima barra delle finestre**: `INV25` parte `2025.11.03 00:00` (1 e 2 novembre sono sabato e domenica); `FEED`/`IS_c` partono `2024.09.26 16:00`.

**Fragilita' da non perdere `[MISURATO]`**:
- **apr-ott 2026 e' TORO per un soffio e su una finestra tagliata**: R +11,35 % contro soglia +10; 2 varianti su 10 danno TORO (le altre MISTO o LATERALE); con fine al `2026.10.01` il R scende a +9,8 % e diventa MISTO. Inoltre la finestra e' incompleta.
- **L'inverno 2024/25 finisce il 31/03/2025, a 2-7 giorni dal fondo del calo dei dazi (`2025.04.07`)**: spostando la fine di +15 giorni il DD sale da 9,73 a 18,46 %; con inizio +15 e fine +15 diventa ORSO (R -7,4 %). Sei varianti su 25 sono ORSO, due MISTO. Il LATERALE dell'inverno 2024/25 **dipende dal taglio al 31 marzo**.
- **apr-ott 2025** (TORO, DD 13,08 %) sta a 1,92 punti dal 15 %: 19/25 stabile, 5 varianti MISTO.
- **IS (a)**: 21/25 LATERALE; le quattro diverse sono tre MISTO (fine +30 giorni, R +5,2...+5,9 %) e un ORSO (inizio +30, fine -30, R -5,2 %).

## 4. Il contro-esempio (scritto prima in testa allo script) e cosa e' successo

| rischio di lettura | controllo | esito |
|---|---|---|
| **gap overnight** nelle chiusure H1 | stessa regola sulla serie giornaliera (ultima chiusura di ogni giornata server 22:00-21:59; pausa del feed a 22:00) | **0 etichette su 10 cambiano** (colonna "giornaliera" sez. 3). DD giornaliero un po' piu' basso di 1-2 punti (IS 16,55 contro 18,46; OOS 10,21 contro 11,15), mai a cavallo di una soglia nelle finestre dichiarate. Il feed ha 548 buchi con salto medio chiusura-apertura -0,01 %, massimo -3,64 % (struttura del CSV) |
| finestra che parte a meta' giornata | R dall'apertura accanto a R dalla chiusura | differenza massima 0,24 punti (feed intero: 22,48 contro 22,72), nessuna etichetta cambia |
| regola su chiuse H1 o giornaliere | la fonte dice H1: H1 e' la primaria, la giornaliera e' il controllo di sopra | -- |
| **orologio** | lo script NON e' un test d'orologio e non lo dichiara: R e DD non dipendono dall'ora. L'orologio entra solo nei confini 00:00 | coperto dal taglio a 25 varianti (un'ora di scarto e' molto meno di 15 giorni). L'UTC+1 fisso resta quello del collaudo, non di questo script |
| taglio della finestra | 25 varianti per finestra | sez. 3, ultima colonna |
| "IS (a)" = prima/ultima **chiusura di posizione**, non finestra del tester | etichettate tutte e due | verificato alla fonte: `backtest_pipeline/coda/referti/CODA_12_pertrade_posizioni_20260913_033003.log` **r.75 = 132 posizioni, r.77 = close_time dal 2024.10.22 10:22:06 al 2025.06.06 01:02:36**; l'IS di contratto (tester) e' 2024.09.26-2025.06.09. Etichetta uguale (LATERALE) |
| float alle soglie (105/100-1 = 5,000000000000004 %) | arrotondamento a 9 decimali | casi esatti nell'autotest |
| "un numero che torna" | **ricalcolo indipendente** (altro codice, solo stringhe, nessuna funzione dello script) di R e DD per IS_a, OOS_b, INV24, EST25, INV25, EST26, FEED | **identico alla seconda cifra decimale in tutti e sette** (esempio OOS_b: 21,03 e 11,15) |

## 5. Autotest sintetico (`--autotest`, parte da solo e blocca le etichette se fallisce): 30 ok, 0 FAIL

Serie H1 sintetiche con etichetta scritta nello script: toro puro (TORO) · orso puro -20 % (ORSO) · orso lento -30 % in 300 g (ORSO: nessun calo a 92 g) · laterale (LATERALE) · crash con R +7 % (CROLLO) · crash con R 0 % (**MISTO** con la regola DK letterale: scattano CROLLO e LATERALE; "CROLLO (+LATERALE)" con la unica) · crash dentro un orso lungo ((i) MISTO, (ii) ORSO: le due letture si separano) · soglie esatte: R +10,00 TORO, +9,99 MISTO, \|R\| = 5,00 LATERALE (anche 95/100), 5,01 MISTO, DD 15,00 con R +12 MISTO, DD 14,99 TORO, DD3m 25,00 CROLLO, 24,98 MISTO, R -5,00 con DD 16 MISTO (LATERALE + ORSO) · 92 contro 93 giorni · finestra a date (le barre fuori non contano; prima e ultima barra) · serie giornaliera (22:00-21:59) · **DD3m a finestra mobile contro forza bruta O(n^2) su 30 cammini casuali x 2 finestre, e DD massimo contro forza bruta su 30 cammini: coincidono** · **due mutanti** (soglia TORO a 25 %, finestra del crollo a 15 g) che **cambiano etichetta come devono**.
**Un difetto trovato e riparato prima dei numeri**: il primo mutante (crollo a 30 g) *non* cambiava etichetta e l'autotest segnava FAIL; era il **test** debole, non il codice (in 30 giorni quel crash fa -26 %, ancora >= 25 %): portato a 15 g (-15,75 %). Lo dico perche' un mutante che non muta non prova niente.

## 6. Lettura per H3 (regola della scheda r.195): chi e' "valutabile" `[MISURATO]` per la sola parte etichetta

Regola H3 (scheda `MIGLIORA_EMA200_DOW_H1_2026-10-11.md` r.195): valutabile = etichetta del nov-mar **uguale** a quella del suo apr-ott **e non MISTO** (piu' >= 5 gambe per lato in ciascuna meta': questa parte e' sui trade).

| inverno | confronto apr-ott | etichette | stessa? | non MISTO? | valutabile (etichetta) | nota |
|---|---|---|---|---|---|---|
| 2024/25 (IS, conta) | apr-ott 2025 **completo** | LATERALE contro TORO | NO | si' | **NO** | |
| 2024/25 (IS, conta) | apr - 9 giu 2025 (variante ridotta della scheda r.193: giu-ott 2025 e' OOS = origine) | LATERALE contro LATERALE | si' | si' | **SI'** (sull'etichetta) | confronto ridotto, dichiarato; fragilita' sez. 3 (17/25 e 14/22 al taglio) |
| 2025/26 (**origine, non conta**) | apr-ott 2026 incompleto | LATERALE contro TORO | NO | si' | NO | e comunque non conta |

- **Inverni BCM valutabili: al massimo UNO (2024/25), e solo nella variante ridotta.** L'inverno 2025/26 e' l'origine (r.186). Il 2012/13-2023/24 non e' nel feed BCM (parte il 26/09/2024).
- **Esito H3 sull'N**: la scheda dice N <= 3 -> NON MISURABILE; con questo feed N BCM <= 1. Il totale N (con gli inverni Dukascopy, P1/P3/F1) **non e' calcolato qui**. Questo export **non** aggiunge inverni (come gia' detto dalla lettura del collaudo).
- **Condizione sui trade (>= 5 gambe per lato per meta')**: `[NON MISURATO]`, il per-trade IS non e' in repo (scheda sez. 1.8).
- **Cosa mostra, e cosa no**: il LATERALE dell'inverno 2024/25 e il LATERALE di apr-9 giu 2025 hanno **la stessa etichetta ma non lo stesso aspetto**: il primo ha DD 9,73 %, il secondo 13,08 % in cinque giorni (i dazi). L'etichetta DK non vede il DD dentro un LATERALE; se H3 vuole separare "stagione" da "fase", la parola LATERALE da sola non basta per quel confronto. Lo segnalo, non lo risolvo.

## 7. Cosa NON e' misurato (elenco)

- **Il merito di EMA200** (nessun PF, nessun trade letto, nessun lato): non e' compito di questo referto.
- **Gambe per lato** per ogni meta' (condizione H3): per-trade IS non in repo.
- **DD intrabarra** (high/low) e sul **conto** della sedia: qui DD del prezzo sulle chiusure H1.
- **Altri inverni** (2012/13...2023/24): solo Dukascopy (P1/P3/F1 non fatti).
- **La firma della regola**: le etichette sono PROVVISORIE finche' F1 / R-0 non sono firmate; non cambierebbe nessuna etichetta di questo referto (DK = unica in tutte le finestre).
- **Quanto e' "vero" il feed BCM come mercato**: e' il feed del broker (un CFD), non un indice cash; non confrontato con altri feed in questo compito.
- **apr-ott 2026 completo**: il feed arriva al 09/10; il semestre si chiude il 31/10 e la finestra si puo' rifare.
- **Le percentuali di taglio** sono informative; nessuna soglia di "stabilita'" e' stata scritta prima, quindi non ne giudico nessuna.

## 8. Cosa ne esce per la scheda (senza decidere)

- La scheda dice che l'IS e' "NON MISURATO" come regime (sez. 1.8 r.118): **ora e' misurato, `LATERALE` con un DD di prezzo di 18,46 %**, R fra -0,19 % e +1,40 % a seconda del taglio. Il "un solo regime" (TORO 2024-26) e' quindi **da riscrivere**: nel feed BCM i regimi sono due (LATERALE nell'IS, TORO nell'OOS), **nessuno dei due AVVERSO**.
- Il rinvio alla classe AVVERSE (ORSO/CROLLO) resta com'e': serve DK. L'unico pezzo di calo vero dentro il feed (18,46 % in 66 giorni) cade dentro una finestra LATERALE, quindi **non conta** come finestra avversa; sub-finestre scelte dopo averlo visto non le uso.
- Passo successivo naturale, a zero macchina: nessuno qui.

## Appendice: come si riproduce

```
python3 backtest_pipeline/etichetta_regimi_dow.py --autotest
python3 backtest_pipeline/etichetta_regimi_dow.py --md
```

Fonti lette per la regola: `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` r.58 · `report/FIRME_DA_FARE_2026-10-05.md` r.34-41, r.57 · `report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md` (sez. 1.8, H3 r.183-195) · `report/EXPORT_BARRE_DOW_H1_LETTURA_2026-10-11.md` · `backtest_pipeline/coda/referti/CODA_12_pertrade_posizioni_20260913_033003.log` r.75, r.77.

## Strato 1 (11/10/2026)

`python3 backtest_pipeline/controlla_riga.py --oggetto md report/REGIMI_DOW_BCM_2026-10-11.md` -> **ESITO: nessun difetto meccanico** (2 controlli passati: un blocco di codice non-lancio, nessun terminale o conto vietato nominato). `controlla_prova.py` **non applicabile** (non c'e' nessun file prova `.txt`, nessuna griglia, nessun EA: e' uno script Python di sola lettura). Strato 2 (`controllo-preventivo`): **NON lanciato**, come da incarico. Questo NON e' un PASS completo.
