# GBA R2 senza codice: cosa dicono i numeri (10/10/2026, sera)

Fonte: `backtest_pipeline/risultati_archivio/GBA_R2_SENZA_CODICE_20261010/` (4 zip + ESITI + `LETTURA_leggi_gba_r0_R2_SENZA_CODICE.txt`, uscita integrale del lettore passato dal re-gate al commit 7b4b6c53).
Giro: pin c6e00852, PC DESKTOP-H4D7CAJ, 19:19-19:58 (38 minuti), 28 passate OK su 28, rc 0, tick reali 100%, EA 1381E3DC compilato 0 errori. G1: la gemella REPL T1 (magic 775850) = R1A T1 (128 op / -6577,48 / PF 0,83 / DD 12.511,35), 256 deal identici uno a uno: l'ancora R1A regge e i confronti valgono.
**Stato: bozza di lettura della sessione principale; l'applicazione formale delle smentite dei file prova (S8-S10, tre rami di TRENDTF r.69, MR3) e' una MIA lettura e va riletta dal cancello. Nessuna parola 'morto': il certificato dei 5 punti non e' chiuso da nessun lotto di questo giro (mancano uscita, simboli gemelli, TF del segnale).**

## 1. Tabella attese (scritte PRIMA) contro risultato (3 tranche sommate T1-T3 2026, 1 lotto)
| Cella | n atteso | n | PF_V atteso | PF_V | costo (+0,04) | PF a 7,80 | lato BUY / SELL (PF_V) | per tranche T1 / T2 / T3 |
|---|---|---|---|---|---|---|---|---|
| REPL (R1A, ancora) | -- | 933 | -- | 0,855 | 49,4x | 0,855 | 0,89 / 0,83 | 0,83 / 0,77 / 0,89 |
| E5 (EMA su M5) | 680-910 | 765 dentro | 0,78-0,95 | **0,952** (bordo alto) | 49,1x | 0,941 | 1,07 / 0,89 | 0,77 / 0,84 / 1,03 |
| E15 (EMA su M15) | 600-800 | 679 dentro | 0,78-0,95 | **0,969** (sopra la banda) | 49,1x | 0,958 | 1,07 / 0,92 | 0,81 / 0,78 / 1,09 |
| EH1 (EMA su H1) | 450-700 | 568 dentro | 0,78-1,05 | 1,023 (dentro) | 49,2x | 1,011 | 1,11 / 0,99 | 1,01 / 0,79 / 1,12 |
| EH4 (EMA su H4) | 450-700 | 546 dentro | 0,78-1,05 | 0,837 | 49,0x | 0,827 | 0,76 / 0,87 | 0,71 / 0,81 / 0,87 |
| ED1 (EMA su D1) | 450-700 | 486 dentro | 0,78-1,05 | 0,843 | 49,0x | 0,832 | 0,74 / 0,98 | 0,89 / 0,72 / 0,90 |
| A5 (ATR su M5) | 2.300-3.500 (~2.700) | 3.203 dentro | 0,68-0,90 | 0,896 (bordo alto) | 57,3x | 0,886 | 0,93 / 0,86 | 0,85 / 0,82 / 0,97 |
| A15 (ATR su M15) | 2.300-3.500 (~3.450) | **3.913 FUORI (+12% sul tetto)** | 0,68-0,90 | **0,917 (sopra la banda)** | 84,9x | 0,908 | 0,95 / 0,89 | 0,89 / 0,96 / 0,91 |
| NOSHORT (solo BUY) | 420-520 (~443) | **443** | 0,84-0,95 | 0,887 | 49,5x | 0,876 | -- | 1,58 (n 61) / 0,79 / 0,84 |
| NOLONG (solo SELL) | 470-560 (~490) | **490** | 0,72-0,88 | 0,831 | 49,3x | -- | -- | 0,47 (n 67) / 0,75 / 0,93 |

## 2. Cosa si legge (fatti, poi interpretazione etichettata)
1. **Il costo passa ovunque** (mediana 49x con commissione 0,04 e quota sotto 13,3x = 0%): nessuna cella e' scartata per costo. A5 e A15 hanno costo piu' alto (57x e 85x) perche' l'ATR su TF piu' alto allarga lo stop.
2. **Nessuna cella supera PF_V 1,03** (la soglia di rumore S8): il massimo e' EH1 a 1,023. Nessuna cella tocca S4 (PF_V >= 1,5): per tutte "tranche con n>=150 e PF_V>1,3: 0 su 3". Concentrazione: tutte FRAGILI (il netto senza le 5 migliori operazioni e' negativo in ogni cella; la migliore operazione pesa 1-4% del profitto positivo).
3. **Solo-lato (SOLOBUY/SOLOSELL): la sequenza e' ~zero.** n = 443 e 490, esattamente i lati di R1A, e PF_V 0,887 / 0,831 contro 0,89 / 0,83. Quindi spegnere un lato non cambia le operazioni dell'altro, e l'asimmetria BUY/SELL e' quella gia' vista in R1A; le due sovrapposizioni dichiarate (488-520 e 540-560) non scattano. Su T1-T3 l'asimmetria si DESCRIVE soltanto (la smentita 'artefatto' e' della validazione T4-T9). Le tranche T1 (PF 1,58 BUY, 0,47 SELL) hanno n 61 e 67: sotto 150, merito sospeso (S1).
4. **TF dell'EMA di trend:** PF_V lungo l'asse 0,85 (REPL) / 0,95 (M5) / 0,97 (M15) / 1,02 (H1) / 0,84 (H4) / 0,84 (D1): NON monotono, un solo punto che sporge (H1) e comunque dentro il rumore (<= 1,03): il lettore lo chiama PICCO, non altopiano. Il lato BUY e' sopra 1 in E5/E15/EH1 (1,07 / 1,07 / 1,11) e il SELL sotto; con n per lato 220-330 e un solo regime e' una descrizione, non un verdetto.
5. **TF dell'ATR:** A5 0,896, A15 0,917 (REPL 0,855): sale in modo monotono ma resta sotto 1 con n molto alto (3.200-3.900, 14-20 operazioni al giorno), quindi il campione NON e' piu' sottile: a 1 lotto il netto e' -131k e -138k EUR. **Fuori attese:** A15 ha n 3.913 contro tetto 3.500 e PF_V 0,917 contro tetto 0,90; per il file si cerca la causa (righe '[GBA] dati non pronti': 0 nel lettore) e non si ritocca l'attesa. [INFERITO, da misurare] un ATR su M15 allarga lo stop e riduce gli scarti per spread (274 scartati contro 6.614 della REPL).
6. **Regime: NON MISURATO ovunque** (3 tranche sono 270 giorni, la regola firmata '1 anno = 4 tranche' non e' soddisfatta; con la lettura alternativa '2 trimestri' tutte le celle 'NON REGGONO'). Dato che il campione e' un solo regime (volatile) e solo il 2026, nessuna cella puo' essere promossa da qui (S10).
7. **Fasce orarie (REPL):** asia 00-07 PF_V 0,94 (n 142, non distinguibile da zero), europa 0,52 (n 132, supera la correzione per 6 fasce), apertura USA 0,70 (n 381, p 0,009, NON supera 0,0083); pausa 2,03 su n 89 e rollover n 10 sospesi (n<100).

## 3. Applicazione delle smentite scritte (MIA lettura, da far riconfermare dal cancello)
- **ST2 (E5, E15), tre rami di TRENDTF r.69:** con n>=150 in T2 e T3 (E15: 189/388; E5: 208/446) la condizione (a) 'PF_V >= 1,15 in almeno 2 tranche' NON e' soddisfatta (E15 0,78 e 1,09; E5 0,84 e 1,03) e la somma e' <= 1,03 (0,969 e 0,952): ramo (b) = **NULLA per il regime di scoperta** per queste due celle. NON e' 'morto': l'EMA su TF alto non e' ancora misurata sull'uscita, sui simboli gemelli e su un secondo regime.
- **MR3 (EH1, EH4, ED1):** l'ipotesi alternativa (PF_V >= 1,15 con n >= 300 in 2 tranche su 3 e long e short > 1,0) NON e' soddisfatta da nessuna. La smentita 'PF_V <= 1,03 in tutte le tranche con n >= 150' scatta per EH4 (0,81 / 0,87) e ED1 (0,72 / 0,90); NON scatta per EH1 (T3 1,12), che resta il caso aperto da ripetere in T0 (S10) senza verdetto (somma 1,023 = nella zona S8).
- **ST4 (A5, A15):** nessun esito oltre i numeri: PF_V <= 1,03 = indistinguibile dalla REPL; sotto 1 con n alto.
- **Cosa NON dice questo giro:** niente sull'uscita (casella 3), sui simboli gemelli (casella 4) e sul TF del segnale (casella 5): R2U (uscita ad asse) e R2NOTTE restano le priorita'. Il lettore non applica le attese R2 ne' le smentite: sono state applicate qui a mano.

## 4. Che cosa se ne ricava per l'oro (interpretazione, etichettata)
- [INFERITO] Sul motore breakout a 24 ore, M1, 2026, **nessun filtro sui TF degli indicatori cambia la lettura in modo distinguibile dal rumore**; il motore resta sotto 1 e vicino a 1 in T3. Il segnale che compare nei dati (EMA piu' lenta sul TF alto in T3, lato BUY) e' lo stesso 'momentum in T3' gia' visto nei dossier: cresce dove il trend 2026 era piu' forte.
- Il confronto con le dichiarazioni del docente (PF 2,03, win rate 46,8%): **nessuna cella di questo giro si avvicina** (massimo PF_V 1,023; win rate 26-42%). Il 42% di win rate di A15 (n 3.913) e' quello piu' vicino ma con payoff piu' basso e PF_V 0,92: non e' la stessa cosa.
- Prossime misure che chiudono caselle: **R2U** (uscita ad asse, casella 3), **R2NOTTE** (notte solo, M1 e M5, casella 5 in parte), poi simboli gemelli (casella 4). Costo: pochi minuti ciascuno; sono in preparazione con i loro cancelli.
