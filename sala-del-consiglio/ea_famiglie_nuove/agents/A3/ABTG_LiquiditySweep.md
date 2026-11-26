# ABTG_LiquiditySweep v1.11 (A3) - sorgente 1176 righe
Riferimenti = righe di `ABTG_LiquiditySweep.mq5`. Nessuna istruzione rivolta al revisore nel file. Include esterno `ABTG_PausaGuardian.mqh` (106) non fornito: DA_VERIFICARE.

## Regole (FATTO_VERIFICATO)
- Livelli: swing high/low su H4 con 21 barre CHIUSE per lato; candidata = indice 22, valutata una per nuova barra H4 (527-569, 136). Nessun look-ahead: tutte le barre di conferma sono chiuse (FIX 3, 72-80).
- Grilletto su M15 chiusa [1]: high > livello e close < livello -> SHORT; specchio LONG (308-319, 604-633). Il livello si consuma allo sweep o alla chiusura oltre, anche se il filtro blocca il trade (578-583). Sweep opposti sulla stessa barra: nessun ingresso (637-639).
- SL oltre l'estremo della barra di sweep + 0,5 ATR(M15) (192, 693), TP 2R (194), BE a 1R acceso di default (202, 780-801), una posizione (645), rischio 1% (210). Ordine a mercato (723-724). Finestra di sessione, notizie, trailing, parziale spenti (165, 196, 203, 213).

## Difetti
- [falsa i test, media] Il "motore nudo" non e' nudo: `InpBreakeven=true` (202) non fa scattare l'avviso 451-453 (elenca altre gambe, non il BE). Va pinnato nei set.
- [falsa i test, media] Spread: filtro presente, `InpMaxSpread=0` (224, 890-894); ingresso a mercato dopo la chiusura M15. Su `_EXT` spread=0.
- [falsa i test, minore] Orari: header 152-155 riporta tre valori contrastanti e la regola "server = ora IT - 1", falsa in inverno (CLAUDE.md). Finestra opt-in (165-169, 666-675) in ora server fissa: per Londra servono 8 estate / 9 inverno, un solo valore su anni interi e' sbagliato.
- [media] Nessun pavimento vero sullo stop (solo stops level, 699-701): `InpSLBufferAtr` ammette 0 (418) e in quel caso R puo' essere minuscolo e il lotto esplodere (lezione R109 citata in altre EA); il tetto volume taglia in silenzio (878).
- [minore] Nessun precarico dei livelli: rodaggio ~22 barre H4 a inizio test (94-99); stato perso al riavvio live (INFERENZA da 408-409). Nessuna chiusura serale: posizioni tenute anche nel weekend, swap non modellato nel codice.
- [minore] Filtro finestra letto sull'ora della barra [1], non di quella d'ingresso (669).

## R2 (SI/NO)
Barra in formazione per decidere: NO. Orari senza ora legale: SI (opt-in). Distanze fisse: NO (ATR/struttura); deviazione 30 punti (406). Nuova barra: SI (503-515). Stop minimo: parziale (solo stops level). Spread nel filtro: SI, spento. Rifiuto ordine: log (734). Magic 772600, commento "LIQSWEEP L/S" (222-223, 715). Dati futuri: NO.

## Misurabilita'
Qualsiasi simbolo: livelli H4 + segnale M15, OHLC chiuso. Oro BCM 2004-26, forex BCM dal 2013, indici `_EXT`. Se si usano CSV oro FTMO: scartare la riga 00:00 con tickvol > 2000, altrimenti crea swing e sweep falsi (CLAUDE.md). Campione: l'header avverte che con 21 barre i trade potrebbero essere < 150 IS (135); le colonne canarino (1100-1115) lo dicono prima del PF. Famiglia "fade falso breakout" gia' chiusa su dati nostri (CLAUDE.md, INFORMAZIONE_DEL_COMMITTENTE): prior basso.

## Ipotesi
1. Baseline con BE spento, finestra spenta, oro BCM: IS 2013-22, OOS 2004-12, hold-out 2023-24. Passa se IS PF >= 1,30, OOS >= 1,20, >= 150 trade IS. Probabilita 6%.
2. Finestra apertura Londra con ora per stagione (08:00-12:00 estate, 09:00-13:00 inverno): passa se PF in finestra >= PF fuori + 0,2 in entrambe le stagioni, >= 100 trade in finestra. Probabilita 10%.
3. TF livelli D1 con segnale H1 (stessa logica): passa se PF IS >= 1,30 e trade IS >= 150 dove H4/M15 non arriva a 150. Probabilita 8%.

## Classe: A
Difetti elencati risolvibili senza toccare la logica (pin BE, costo fisso, buffer SL > 0).
