# GBA R2S STADIO A -- lettura dello zip del 12/10/2026 (simboli gemelli, sonda dei costi)

Fonte: `GBA_R2S_A.zip` (PC DESKTOP-H4D7CAJ, 12/10 16:30-16:55, pin `cc9bcda0b64943b1e02ae8f52af68ccff81012d4`, riga PASS 2a1d1199). Archivio: `backtest_pipeline/risultati_archivio/GBA_R2S_A_20261012/` (zip SHA256 AE62E772...). Strumento: D2 `leggi_gba_r2s_c3g.py` SHA256 14384D87... (PASS, 4814795a); G0 del lettore `leggi_gba_r0.py` OK su tutte le passate lette (ANC, NAS x2, D30 x2, U30 x2). Regole: E1-E4 + ordine di E3 (docs/RISPOSTA_A_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md). Un solo regime (T1 2026.07.01-09.30), Modello 1 (barre: SONDA di costo, nessun PF letto come merito), lotto fisso 1,00.
**Nessun candidato e' archiviato; la casella 4 del certificato di morte resta "NON ANCORA MISURATO" per tutti.**

## Ancora (CE1)
R2SANC (XAUUSD M1): VERDE. Manifest 158 operazioni / -6.364,79 / PF 0,86, conteggi dell'EA e C3G identici a S0 del 09/10: la macchina e' la stessa di allora. I numeri dei gemelli valgono.

## Esito per cella (esito di riferimento E1+E4)
| cella | segnali grezzi | ingressi n | C3G cella | BUY / SELL | righe >=40x | costo "solo spread" degli ingressi | esito |
|---|---:|---:|---:|---|---:|---:|---|
| NASUSD M5 | 1.491 | 124 | 33,90 | 30,30 / 37,40 | 516 | 60,8x | (A) passa allo stadio B; C3G FRA |
| NASUSD M15 | 488 | 135 | 62,00 | 54,95 / 72,75 | 407 | 72,4x | (A); C3G >= 40x |
| D30EUR M5 | 1.393 | 60 | 22,20 | 19,45 / 26,20 | 343 | 54,5x | (A); C3G FRA |
| D30EUR M15 | 418 | 98 | 49,05 | n.d. nel riepilogo | -- | 64,2x | (A); C3G >= 40x |
| U30USD M5 | 1.451 | 112 | 29,90 | 27,80 / 32,50 | 458 | 66,7x | (A); C3G FRA |
| U30USD M15 | 460 | 115 | 58,05 | 54,65 / 67,95 | 363 | 76,1x | (A); C3G >= 40x |
| XAGUSD M1 | 6.611 | 0 | 2,40 | 2,50 / 2,30 | 0 | -- | (C): passata KO (timeout 20 min, report .htm assente); CE6 rossa |
| XAGUSD M15 | -- | -- | -- | -- | -- | -- | (C): NON LANCIATA (tetto di 15 minuti del lotto) |

Per il dettaglio per fascia e per lato vedi `LETTURA_D2_R2S_A.txt` nell'archivio. Nessuna cella esce "ESCLUSA".

## Attese scritte prima, contro misura
- NASUSD M5 "fra 35 e 50x": misurato **33,90**, appena sotto la banda [attesa MANCATA di poco]. Resta FRA.
- D30EUR e U30USD M5 "< 40x (FRA)": 22,20 e 29,90 [CONFERMATA]. M15 ">= 40x": 49,05 e 58,05 [CONFERMATA]. NASUSD M15 62,00 [coerente con la stima].
- XAGUSD "< 13,3x a M1 e a M15": M1 **2,40x** [coerente con la stima 2,2x], ma la cella e' formalmente (C).

## Regola congelata del piano 5.3 (cosa va allo stadio B)
Allo stadio B passa solo una cella con C3G >= 40x e n >= 30: **NASUSD M15, D30EUR M15, U30USD M15**. Le tre M5 sono FRA (33,9 / 22,2 / 29,9): si possono misurare per capire (lo dichiaro) ma **non possono diventare sedia**. Il lettore le etichetta "(A) passa allo stadio B ... FRA sui segnali grezzi, PASSA solo grazie al filtro": quella dicitura non dice che diventano sedia.

## Dove stanno gli ingressi (E2) [DESCRITTIVO]
Il filtro di spread (0,05 x ATR) scarta il 90-95% dei segnali liberi a M5 e il 50-56% a M15. Gli ingressi si concentrano in poche fasce: NASUSD M5 USA apertura 53%, D30EUR M5 europa 62%, U30USD M5 USA apertura 74% (asia 0 ingressi), D30EUR M15 europa 62%. Il costo e' basso solo dove lo spread e' stretto; resta da vedere a tick reali.

## Argento (l'unica cosa che non e' (A))
Il giornale dell'argento M1 arriva fino al 29/09 23:59:59 e stampa la riga FINE dell'EA: **l'EA ha girato tutto il trimestre**. Sono 6.611 segnali, **tutti** scartati per spread: ATR 0,03-0,04 USD, spread 0,05 USD = 143-168% dell'ATR contro il limite del 5%. C3G cella 2,40x, nessuna riga a >=40x, nessuna fascia sopra 4,2x. Se la passata non fosse andata in KO, tutte le condizioni (i)-(v) sarebbero vere. **Ma la passata e' KO** (il tester ha superato i 20 minuti e il report non e' stato scritto) e per regola un KO fuori dall'eccezione n=0 e' "conferma non data": l'argento M1 resta **(C)**, M15 non e' mai partito. Quindi: **numero molto forte, formalmente non misurato.** La via piu' corta e' rifare l'argento da solo (M1 e M15) con un timeout piu' lungo.

## Dichiarazioni
- Il costo "solo spread" degli ingressi e' >= 50x per costruzione (il filtro); i numeri che contano sono C3G e la concentrazione.
- Sulla sonda a Modello 1 il C3G dell'oro e' +5,6% rispetto ai tick reali; per indici e argento il verso e' NON MISURATO. Per questo lo stadio B e' a tick reali.
- Un regime, 3 mesi del 2026. Nessuna tranche T2/T3 e nessun 2025 per gli indici (storico BCM dal 2024.09.26).
- Lettura per lato: vedi file D2; nessun lato e' stato giudicato per merito.

## Cosa serve per chiudere la casella 4 e andare avanti
1. **Stadio B a tick reali** per NASUSD M15, D30EUR M15, U30USD M15 su 3 tranche (e, se Claudio vuole capire, le M5 FRA come sola descrizione). File prova, riga e cancello da scrivere.
2. **Argento** M1 e M15 rifatti con timeout piu' lungo.
3. Confronto con Gemini su questa lettura (dovuto, regola dell'11/10).

## ERRATA (12/10/2026 sera, strato 2 del cancello; la lettura sopra resta com'era scritta)
**E-L1. La frase della sezione "Dove stanno gli ingressi (E2)" -- «Il costo e' basso solo dove lo spread e' stretto» -- e' SBAGLIATA per Nasdaq e Dow e vera solo in parte per il DAX.** Va letta cosi':
*«Gli ingressi stanno dove l'ATR supera 20 volte lo spread (il filtro 0,05 x ATR). A Modello 1 lo spread di NASUSD e U30USD e' praticamente fisso, quindi su questi due simboli la selezione e' per VOLATILITA', non per spread stretto. Sul DAX lo spread ha due livelli e la selezione e' per tutte e due le cose: le ore a 2,80 sono escluse dallo spread, dentro le ore a spread basso decide l'ATR.»*
Conteggi sui giornali dello zip [MISURATO, strato 2, parser indipendente dalla bozza]:
- NASUSD: spread 1,80 in 1.491 righe su 1.491 (M5) e in 487 su 488 (M15, una a 1,90). ATR mediano degli ingressi contro tutte le righe: **43,78 contro 24,44** (M5), 52,16 contro 44,63 (M15).
- U30USD: spread 2,00 in 1.446 su 1.451 (M5, 5 a 3,00) e 457 su 460 (M15, 3 a 3,00). ATR mediano ingressi contro righe: **53,33 contro 24,00** (M5), 61,14 contro 46,43 (M15).
- D30EUR: spread **1,30-1,60 (mediana 1,40) nelle ore server 8-15** (e in parte alle 7, alle 16 e in qualche riga serale delle 17-21) e **2,80 la notte e la sera** (tutte le righe delle ore 0-6 e 23, quasi tutte delle 17-21, parte delle 7 e 16). M5: 695 righe a 1,30-1,60 e 698 a 2,80; le righe a 2,80 hanno C3G **10,65x e 0 ingressi**. M15: 263 righe a 1,30-1,60 e 155 a 2,80; le righe a 2,80 hanno C3G **20,60x e 2 ingressi** su 98. Dentro le righe a 1,40 l'ATR mediano e' 23,95 (M5) contro 30,65 degli ingressi; a M15 36,64 contro 37,77 (a M15 la banda bassa sta gia' a 65,45x: li' quasi tutto passa il filtro e a togliere e' la regola «una posizione per volta»).
Conseguenza: nessuna. Nessun esito, nessuna soglia e nessuna cella cambiano; cambia la SPIEGAZIONE della concentrazione, che non e' «costo basso» (regola R2 di `docs/RISPOSTA_A_GEMINI_GBA_R2S_LETTURA_2026-10-12.md`).

**E-L2. Tabella "Esito per cella", riga D30EUR M15**: BUY / SELL non e' «n.d. nel riepilogo»: lo strumento D2 li stampa, **46,30 (n 222) / 52,85 (n 196)**; righe >= 40x non e' «--» ma **245** (`LETTURA_D2_R2S_A.txt`, riga della cella, e `D2_C3G_R2S_A.csv`). Nessun esito cambia (la cella e' (A) per C3G 49,05 >= 40x e n 98 >= 30).

**E-L3. Dichiarazioni, seconda riga**: «sulla sonda a Modello 1 il C3G dell'oro e' +5,6% rispetto ai tick reali» e' giusto in quella base; nell'altra base (tick su Modello 1) e' -5,3% (21,60 / 22,80). Da qui in avanti si scrive sempre la base.
