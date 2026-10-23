# R282: ABTG_Nasdaq_Apertura_US_Sicuro v1.03, le tre correzioni, lettura (23/10/2026)

Fonte: `ROUND_R282_2026-10-23.zip` (5 file x 4 passate, tick reali, NASUSD M5, cella R274a, pin 304dfa41, motore = pin SHA256 in tutti i round). Archivio `risultati_archivio/R282_20261023`. Lettore congelato `r282_giudizio.py`. Non controllata da agenti. **La copia COMPILA** (P1 centrata) e tutti e 5 i round sono partiti (rc 0).

## Verdetti col lettore congelato
| cancello | esito | nota |
|---|---|---|
| **G0** (R282a tutto spento = R274a) | **PASSA** | IS 7.014,21 / PF 1,22116 / DD 7,3069% / 135 e OOS 8.496,74 / 1,21546 / 7,8576% / 172: **identico al centesimo**. A default la copia e identica all'originale. |
| G1 gemelle | **NON PASSA (formale)** | **Errore mio nel file prova R282e**: `InpMagic=799151||...||50||799351` e un intervallo con passo 50 = **5 passate**, non 2 (le altre coppie erano 2). Le 5 righe sono identiche (Profit 7.633,87/7.633,86, PF, DD e Trades uguali; OOS tutte 1.786,35): il determinismo c'e, il lettore pretendeva 2 righe. La riga ha segnato "_OOS NON BUONO" per lo stesso motivo: non e un difetto dell'EA. Per-trade di R282e solo del primo magic (799151). |
| **FESTIVI** (R282b) | **OK** | nessuna posizione in un festivo; giorni non festivi identici. |
| **TETTO** (R282d contro R282c) | **NON OK** | IS: 92 contro 96 operazioni ma DD 6,51% contro 6,25% (peggio); OOS 120 contro 122, DD uguale 7,48%. |
| **DST** (R282e) | **NON OK (criterio mal costruito)** | vedi sotto: la logica funziona, il mio criterio (i) ignorava che il lotto dipende dal saldo. |

## Cosa dicono i numeri
- **Festivi**: in OOS l'originale non aveva operazioni nei festivi (0 tolte). In **IS** il filtro toglie 4 operazioni (131 contro 135 deal): **profitto 6.199 contro 7.014 (-815), PF 1,196 contro 1,221**: le posizioni dei festivi erano in guadagno (tra queste il 20/01/2025). E un filtro di pulizia/rischio, **non migliora la resa** in questo campione.
- **Tetto sul lotto minimo (deposito 500, X=2)**: blocca **poche** operazioni (4 in IS, 2 in OOS) e **non abbassa il DD** (IS lo alza di 0,26 punti). Effetto trascurabile. (A deposito 500 il PF e 1,25-1,28; profitti 38-54 EUR.)
- **DST automatica** (post-hoc, per-trade OOS): **estate 2025** (10/06-31/10): R282e = R282a esattamente (48 posizioni, +2.140). **Estate 2026** (da 09/03): **stesse 2 giornate**, netto diverso (-3.517 contro -3.807) perche il lotto e il 2% del saldo e il saldo e cambiato nel frattempo (path-dependent). **Inverno** (03/11/25-06/03/26): R282e **chiude alle 16-18 server** (15:30 apertura), nessuna chiusura prima delle 15:35; l'originale chiudeva alle 15-16 (un'ora prima). La logica oraria fa quello che deve.
- Orientamento inverno OOS (nessun verdetto): originale 52 posizioni PF 1,47 netto +10.163; con DST 32 posizioni PF 1,41 netto +3.164. Armare all'apertura vera dà **meno operazioni** (-38%), PF simile: come in R274 (verdetto MISTO).

## Contro le previsioni
P1 compila e parte: **CENTRATA**. P2 G0: CENTRATA. P3 FESTIVI OK: CENTRATA; "toglie almeno una posizione dall'OOS" (55%): **non avvenuto** (0). P4 TETTO OK (65%): **FALLITA**; Trades_d = 0 (15%): non avvenuto. P5 DST OK (75%): **FALLITA nella forma** (criterio sbagliato, logica verificata a mano).

## Lettura
- La copia e **sicura da usare come EA a parte**: a default fa quello che fa l'originale.
- **Utili**: festivi (toglie un rischio, costo piccolo) e ora solare automatica (evita di cambiare l'orario a mano il 02/11; cambia il profilo d'inverno). **Poco utile**: tetto lotto minimo.
- Non e stata toccata nessuna sedia, nessun preset. Nessuna taglia. Effetto sul conto reale NON MISURATO.
