# GBA R2U (la gestione dell'uscita messa ad asse) -- lettura del 11/10/2026

Fonte: `GBA_R2_USCITA.zip` (pin 9ee0e0ca, PC `DESKTOP-H4D7CAJ`, inizio 08:36 fine 09:06, 31 min; i 4 lotti rc 0; ESITI nell'archivio `backtest_pipeline/risultati_archivio/GBA_R2_USCITA_20261011/`). Lettore: `leggi_gba_r0.py` (PASS 7b4b6c53), caricato insieme all'ancora R1A. Attese, smentite e soglie S1-S10 sono nel file prova di ogni lotto, scritte PRIMA dei numeri (`backtest_pipeline/prove/GBA_R2U_*_2026-10-10.txt`).

## Cancelli
- **G1 (la gemella)**: REPL T1 col magic 775850 ridà R1A T1 identica: 128 operazioni, -6.577,48, PF 0,83, DD equity 12.511,35, **256 deal confrontati**. La macchina e' la stessa di R1A.
- **G0**: 25 passate su 25, tick reali (modello 4), stato driver OK. Il giornale dell'EA segnala errori di spostamento SL (trailing/BE non applicato) da 20 a 156 per lotto e di chiusura a tempo fino a 187: da guardare, non cambiano il PF del report (coincide col PF_V in ogni tranche).

## I numeri (PF_V = PF netto di costi, somma delle 3 tranche 2026; n)
| cella | variabile | n | PF_V | PF per tranche T1/T2/T3 (report del tester) |
|---|---|---:|---:|---|
| REPL (R1A) | default | 933 | 0,855 | 0,83 / 0,77 / 0,89 |
| BEOFF | BE mai armato (99) | 882 | 0,843 | 0,78 / 0,74 / 0,89 |
| BE05 | BE a 0,5 ATR | 1.074 | 0,778 | 0,63 / 0,71 / 0,82 |
| BE15 | BE a 1,5 ATR | 898 | 0,846 | 0,81 / 0,74 / 0,89 |
| ATRFIX | ATR del trailing fisso sul segnale | 926 | 0,886 | 0,72 / 0,81 / 0,94 |
| TOFF | uscita a tempo spenta (controllo positivo) | 932 | 0,849 | 0,83 / 0,77 / 0,88 |
| K15 | trailing 1,5 ATR | 1.131 | 0,848 | 0,89 / 0,91 / 0,83 |
| K35 | trailing 3,5 ATR | 873 | 0,911 | 0,96 / 0,82 / 0,94 |
| KOFF | trailing spento (99) | 859 | 0,900 | 0,98 / 0,67 / 0,97 |

## Lettura contro le soglie scritte prima
- **S8 (rumore)**: la REPL ha PF_V 0,855 con intervallo per giorno [0,70; 1,03]. **Nessuna delle 9 celle supera 1,03** (massimo K35 0,911): tutte INDISTINGUIBILI dalla REPL e da 1,0. Per la partizione (b) del file prova: **NULLA per il regime di scoperta**; nessuna cella va in T0 (S10).
- **Contro-esempio cercato** (CLAUDE.md 10/09): "il lettore potrebbe nascondere una cella buona nella somma". Smentito sul numero del tester stesso: **27 tranche su 27 hanno PF del report < 1,0** (massimo 0,98, KOFF T1); K35 e KOFF non hanno nessuna tranche >= 1. I lati: massimo K35 BUY 1,03 (n 415) e KOFF BUY 1,01 (n 408): dentro il rumore, un lato non e' un verdetto.
- **Controllo positivo**: spegnere l'uscita a tempo cambia **1 operazione su 933** (932) e il PF di 0,006: l'uscita a tempo non e' una leva su questa macchina (quasi nessuna posizione arriva al tempo massimo: vita mediana 7,4 minuti, p90 19,2). Che il tester risponda alle altre leve d'uscita si vede in n: BE05 1.074 operazioni, K15 1.131, KOFF 859 contro 933.
- **Direzione, senza giudicarla**: il BE stretto peggiora (BE05 0,778 contro BEOFF 0,843); trailing largo o spento migliora di circa 0,05 (K35 0,911, KOFF 0,900) ma K15 0,848 e REPL 0,855 non sono monotoni con K35/KOFF: e' dentro il rumore.
- **S5**: tutte le celle FRAGILI (netto senza le 5 migliori operazioni peggiora).
- **Frontiera del costo**: invariata (mediana 49 x con 3,90 EUR a giro; 0% sotto 13,3x).

## Che cosa significa (e che cosa NON significa)
Il motore, prima dei costi, vale circa -0,014 R per operazione con errore standard 0,028 R (piano R2, `report/GBA_R2_PIANO_2026-10-10.md` sez. 1.5): **zero edge lordo**. Una gestione dell'uscita sposta il PF dentro il rumore perche' non c'e' un vantaggio da catturare meglio. Questo CHIUDE la casella 3 del certificato **solo per le leve d'uscita senza codice** (BE, ATR del trailing, distanza del trailing, tempo).
**NON e' "morto"**: mancano la casella 4 (simboli gemelli), la 5 (TF cambiato) e le uscite che richiedono codice (Fake Breakout Filter, uscita a mercato se la candela d'ingresso chiude contro). Resta aperto anche il lotto R2NOTTE (ore 0-6, M1 e M5) -- la leva che i colleghi indicano -- e R2REG (2024-25, MERITO non misurabile oggi). L'ipotesi "lo stop largo e' gia' la risposta" e' da misurare, non da credere.

## Prossime misure (non eseguite)
1. `GBA_R2_NOTTE` (6 passate, ~6-10 min, primo da controllare: M5 mai girato).
2. Pilota NatCla P (colla).
3. Domanda a Gemini (regola del 11/10): quale misura nuova, e non griglia, falsifica "l'ingresso non ha edge su M1 in nessuna ora".
