# GBA R0 - lotto S0 (sonda, Modello 1 OHLC) - 09/10/2026 17:21-17:26, letto il 10/10

Fonte: `backtest_pipeline/risultati_archivio/GBA_R0_S0_20261010/GBA_R0_S0.zip` (PC di backtest, pin 2f4a2a5b, EA v1.10 SHA 1381E3DC, script v3). Lettore `leggi_gba_r0.py` (output completo accanto allo zip). **Modello 1 = OHLC su M1: CONTEGGIO. Nessun PF di qui e' un verdetto.** XAUUSD M1, tranche T1 (2026.07.01-09.30), lotto fisso 1,00, deposito 1.000.000 EUR.

## Esito di meccanica
- **Compilazione: 0 errori, 0 avvisi** (prima compilazione vera di `ABTG_GoldBreakoutATR`). 5 passate OK su 5, 0 KO. Durata 4 minuti in tutto, **34 s a passata**.
- **G1 VERDE**: le due gemelle REPL (magic 775800 / 775850) danno operazioni 158/158, profitto -6364,79, PF 0,86 e DD identici: il tester e' deterministico per questo EA.
- **Barre M1 generate: 88.416** (< 100.000), ticks sintetici 353.661. Qualita' 100%.
- **Commissione sull'oro MISURATA**: il tester addebita -548,50 EUR su 158 operazioni = **3,47 EUR per operazione a 1,00 lotto** (era [NON MISURATO]). Spread alle barre di rottura: mediana 0,17-0,25 USD (europa 0,17, asia 0,24).

## Conteggio (cella di replica 0,05)
- **158 ingressi in T1 = 2,39 al giorno feriale.** Segnali EA 6.973; **98% dei segnali liberi scartati per spread** (6.520); 295 a posizione gia' aperta.
- Confronto con la dichiarazione di Emiliano ("12 il giorno record, ~9 in media, 1-2 a notte con filtro orario"): la replica sul nostro feed fa ~2,4/giorno su 24 ore: **non coincide** (il suo spread era 0,07-0,09 USD contro 0,17-0,25 BCM). Il proxy HistData avrebbe dato 111 ingressi: il tester ne da' 158 (stesso ordine di grandezza).
- Vita della posizione: mediana 7,7 minuti, p90 19,7 (scalping puro).

## Costo (prima del PF)
- REPLICA 0,05: stop/(spread) mediano **55,9x**, +commissione 3,90/giro 46,2x, +0,08/lato 39,3x: **PASSA** (con 54% sotto 40x solo nella lettura "per lato").
- Celle larghe: **0,10 mediana 30,9x; 0,20 mediana 23,0x (4% sotto 13,3x); 0,35 mediana 22,1x (13% sotto 13,3x)**: FRA, **sotto la frontiera 40x: non possono diventare sedia**.

## Screening PF (Modello 1, NON verdetto)
| Cella | n | giorno | PF | win | BUY PF | SELL PF |
|---|---:|---:|---:|---:|---:|---:|
| REPL 0,05 | 158 | 2,4 | **0,86** | 26% | 1,65 (n 76) | **0,48** (n 82) |
| 0,10 | 1.175 | 17,8 | 0,91 | 29% | 1,08 | 0,76 |
| 0,20 | 2.380 | 36,1 | 0,85 | 28% | 0,94 | 0,76 |
| 0,35 | 2.577 | 39,1 | 0,85 | 28% | 0,93 | 0,77 |
- **Dentro la banda scritta prima (PF 0,8-1,3)**, lontano dall'alternativa di Emiliano (PF >= 1,5). Un solo trimestre (T1 = un regime), n REPL 158 (appena sopra 150), **S5 FRAGILE**: senza le 5 migliori il netto e' -21.635 EUR.
- **Asimmetria lato**: BUY PF 1,65, SELL PF 0,48 (oro in rialzo in T1): il segno dipende dal regime; le fasce orarie sono SOSPESE (n < 100) o non distinguibili da zero.
- **Rischio a 1,00 lotto**: perdita a SL mediana **909 EUR** (p90 1.411, max 2.736) sulla cella 0,05 (il filtro spread seleziona i minuti piu' volatili); 388-531 EUR sulle celle larghe. Non va sul piccolo (5.431 EUR).

## Cosa NON dice
- Nessun verdetto: Modello 1, un trimestre. Il verdetto e' R1A (tick reali, 3 tranche T1-T3 del 2026, un solo regime).
- La dichiarazione di Emiliano non e' riprodotta, ne' smentita fuori dal 2026.
- Certificato di morte: mancano le caselle 3 (uscita ad asse), 4 (gemelli), 5 (TF). Vietato "morto".

## Prossimo passo
R1A: REPL su T1, T2, T3 a Modello 4 (tick reali), 3 passate, stima 9-60 minuti (il tempo vero dal ticks: S0 ha dato 34 s a passata a OHLC; R1A e' piu' lenta). R1B (celle larghe) solo se serve: sono gia' sotto la frontiera di costo.
