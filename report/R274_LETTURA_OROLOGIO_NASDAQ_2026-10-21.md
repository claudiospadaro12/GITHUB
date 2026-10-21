# R274 -- orologio della sedia 770260 (Nasdaq): lettura (21/10/2026)

Zip `ROUND_R274_2026-10-21.zip` (8 minuti, 4 round partiti, 8 per-trade su 8, motore = pin SHA256 in tutti i round: T1 superato, l'EA compila). Lettore congelato prima dell'apertura: `backtest_pipeline/r274_giudizio.py` SHA256 `3f5ff804...cfae25`, commit e0116aad. Output integrale: `risultati_archivio/R274_20261021/OUTPUT_r274_giudizio.txt`. Non controllata da agenti.

## Due scarti del lettore dalla specifica (dichiarati)
Il lettore ha dato NULLI R274a e R274c. Entrambi gli scarti sono errori del lettore rispetto al testo congelato di R274a par. 3, non criteri cambiati dopo i numeri:
1. **G1 (R274a, R274c)**: il lettore ha preteso identita' al centesimo. La specifica definisce "identico" con la TOLLERANZA DI BANCO: Profit |diff| <= 1,00 EUR, righe per-trade con |diff| > 0,01 elencate e somma dei |diff| <= 1,00. Fatti: CSV IS di R274a 7014,21 contro 7014,20 (0,01); per-trade di R274c una sola riga diversa (-1165,99 contro -1166,00, somma |diff| 0,01); per-trade di R274a gemelle identiche (0 righe diverse). **G1 passa in tutti e 4 i file.**
2. **S1 (R274c)**: il lettore ha letto l'orario del giorno: 2 uscite alle 00:20:58 e 00:25:07 del 10/01/2025 (posizione 105, due deal) "prima delle 15:05". La specifica dice: uscita alle 23:00 o dopo (riapertura dopo la pausa di sessione) = GIALLO, si elenca per data e si legge a mano. Un'uscita a mezzanotte e venti ricade in quel caso. **S1 = GIALLO per R274c, non ROSSO.** Lettura a mano: la posizione precedente chiude l'08/01 alle 16:02, la 105 chiude il 10/01 a 00:20; quindi e' rimasta aperta oltre le 17:30 del 09/01 [il 09/01/2025 la borsa USA era chiusa per lutto nazionale: IPOTESI, NON VERIFICATA]. Le 2 uscite non cambiano i conteggi stagionali in modo apprezzabile (inverno, 1 posizione).
Il lettore resta congelato com'e'; non lo ho modificato.

## Cancelli
G0 VERDE (R274a riproduce R199B IS e OOS entro la tolleranza; per-trade OOS 172 deal / 102 posizioni = R199B). G2 tutti IDENTICI. S1: R274a, R274b, R274d VERDI; R274c GIALLO. Il per-trade di R274b non e' identico a R274a (il pin d'orario e' arrivato: la manopola morde). InpSessionHour in tutti i CSV corretto.

## Verdetto (criteri congelati, tassi in posizioni per feriale, stagione USA, A+B)
| | posizioni | feriali | tasso | netto | PF [non decide] |
|---|---|---|---|---|---|
| d0 (14:30) estate | 81 | 278 | 0,291 | +4.158 | 1,187 |
| d0 (14:30) inverno | 103 | 180 | 0,572 | +11.353 | 1,232 |
| d+1 (15:30) estate | 2 | 278 | 0,007 | +169 | 1,262 |
| d+1 (15:30) inverno | 85 | 180 | 0,472 | +4.833 | 1,228 |
- Precondizione Df = 0,572 - 0,291 = **0,281 >= 0,15: divario riprodotto.**
- **Qf2 = (0,572 - 0,472) / 0,281 = 0,356: MISTO** (soglie: >= 0,70 OROLOGIO, <= 0,30 STAGIONE). Jackknife su 271 posizioni [0,343 ; 0,376], il verdetto non cambia. Gemella +50: Qf2 0,356.
- d+1 inverno 85 posizioni: dentro la banda congelata H_STAGIONE (83-166). Attese ricalcolate dai tassi veri: H_ORA 52,4, H_STAGIONE 103,0; 85 e' piu' vicino a STAGIONE (distanza 18) che a ORA (33), ma il verdetto resta MISTO.
- Significato: spostare l'armamento da 14:30 a 15:30 in inverno toglie circa il 17% delle posizioni (0,572 -> 0,472). L'orologio pesa molto invece d'estate: armare 1 h DOPO la cash (d+1 in estate USA) da' 2 posizioni su 278 feriali.
- Serie "come FTMO" [INFERITA]: 157 posizioni, 0,343 per feriale (R2: sopra la soglia 0,25, sotto il promesso 0,37), DD di saldo 6,62% (R1: dentro il contratto 7,86%; lotti non ricalcolati [DERIVATO], il DD di saldo e' un pavimento dell'Equity DD).
- Per lato (descrittivo, nessun verdetto): d0 inverno long +12.706 (50 pos) / short -1.353 (53 pos); d+1 inverno long +1.973 (41) / short +2.860 (44); d0 estate long +2.272 (49) / short +1.886 (32).

## Limiti
Merito SOSPESO (n < 150 per costruzione). Due inverni, un solo regime di mercato (Nasdaq al rialzo). NON MISURATO: spread e feed FTMO US100.cash, Guardian nel campo, commissione FTMO, settimana 26-30/10/2026, inverni prima del 2024. Il guadagno di d0 inverno e' quasi tutto long.

## Aggiunta (21/10): T4 e T6 della lista test Nasdaq, letti dagli stessi file
- **T4 giorni senza cash** (date di chiusura USA della lista, piu' quelle della finestra A: 28/11/2024, 25/12/2024, 01/01/2025, 09/01/2025, 20/01/2025, 17/02/2025, 18/04/2025, 26/05/2025; **da riverificare con il calendario ufficiale NYSE**): R274a 0, R274b 0, R274d 0, **R274c 2 deal il 20/01/2025** (posizione 115, uscite 15:30:00 e 15:50:41, +114,90 e +257,70). La previsione "almeno una operazione in un giorno di chiusura" e' confermata su un caso. Il filtro giorno/festivo manca (A7).
- **T6 piazzamento rifiutato**: i giornali del tester NON contengono nessuna riga dell'EA (grep ABTG/BUY STOP/SELL STOP/fallito: 0). Il tester non lo prova; resta DA VERIFICARE su demo, non si conclude che non succede.
