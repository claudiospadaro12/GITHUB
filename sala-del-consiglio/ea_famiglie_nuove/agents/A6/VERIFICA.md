# A6 - Verifica indipendente delle 14 schede (R3, R5)

Metodo: ogni riga citata e' stata riletta nel sorgente in `materiali_ea/<EA>.mq5` (sola lettura, nulla eseguito, nessun codice copiato). Nessuna istruzione per agenti trovata nei 14 sorgenti. Etichette: FV = fatto verificato da me, INF = inferenza, DV = da verificare.

## 1. Citazioni file:riga ricontrollate (R3)

Una citazione = una riga o un intervallo citato dal revisore. Esito: CONFERMATA (la riga contiene quanto la scheda afferma), ERRATA (riga reale indicata), NON TROVATA.

| Rev | EA | N | Citazioni ricontrollate | Esito |
|---|---|---|---|---|
| A1 | GoldBreakoutATR | 14 | 120, 128-129, 137, 148, 151, 161-162, 169, 182-183, 380-383, 483-485, 660-666, 697, 731-739 (riga 735), 897-900 | 14 CONFERMATE |
| A1 | PunteLarry | 11 | 123, 162, 169, 278, 415-420, 497-511, 696-702, 835-864, 851-855, 958, 1037 | 11 CONFERMATE |
| A1 | Gold_Ichimoku | 12 | 21-23, 98, 105, 109, 157-160 (c'e' un AVVISO e l'EA gira comunque: coerente), 217-226, 366-367, 460/469, 490, 539, 559, 672-674 | 12 CONFERMATE |
| A2 | MeanRevert | 10 | 42-52, 164-165, 176, 185-187, 197-208, 211, 232, 235-236, 256-259, assenza di SetDeviation (grep) | 10 CONFERMATE |
| A2 | OutOfNoise | 13 | 74-77, 126, 156-159, 169, 172, 180, 553, 676, 696-697, 780, 848, 859, 977-981 | 13 CONFERMATE |
| A2 | VwapRevert | 11 | 60-62, 122-123, 136, 172-173, 207, 218, 592, 796, 917-920, 933-934, 973-974 | 11 CONFERMATE |
| A3 | CRT_TurtleSoup | 10 | 81 (solo Trade.mqh, nessun Guardian: confermato da grep), 102-103, 111-112, 124, 253/260, 869, 915-929, 935-936, 943-944, 1048 | 10 CONFERMATE |
| A3 | FvgRetest | 12 | 91, 105/113, 163-164, 211/213, 666-685, 874, 925-927, 934-936, 961, 976, 1088, 1204-1208 | 12 CONFERMATE |
| A3 | LiquiditySweep | 11 | 106, 202, 224, 418, 451-453, 699-701, 723-724, 780-801, 878, 890-894 = CONFERMATE (10); **152-155** | 10 CONFERMATE, **1 ERRATA**: i tre valori contrastanti stanno a r.148-151 (r.152-155 e' il commento "tre posti, tre numeri" e il segnaposto); errore di 3 righe, la sostanza e' vera |
| A4 | AltaVelocita | 12 | 166, 167, 197 (ST_BARS 300), 397-399, 405-407, 502-503 (direzione iniziale +1 forzata), 1074, 1076, 1117-1120, 1124-1125, 1140-1141, 1212, 1249 | 12 CONFERMATE |
| A4 | TurnaroundTuesday | 12 | 96-99 ("0 successi su 5"), 176, 253, 259, 289, 431, 462, 501-503, 550-551, 623-629, 625, 628 | 12 CONFERMATE |
| A5 | CanaleLento | 9 | 340-341, 412-421, 580-581, 585, 593, 596-603, 666, 673-674, 701 | 9 CONFERMATE |
| A5 | ChaosLyapunov | 9 | 82, 166/186/195, 172, 385 (CopyClose da 0: barra in formazione, confermato), 415, 464-470, 476-481, 506-534 | 9 CONFERMATE |
| A5 | CrossEma | 9 | 39, 47-49, 118, 192-193, 353, 402, 492, 507/520-521, 701-702 | 9 CONFERMATE |
| | **Totale codice** | **155** | | **154 CONFERMATE, 1 ERRATA, 0 NON TROVATE** |

Dichiarazioni su altri file del repo (punto 3):

| Rev | Affermazione | Esito |
|---|---|---|
| A1 | GoldBreakoutATR: 2015-23 10.531 op, PF 0,94, t -1,50, DD 57%; 2005-14 29.995 op, PF 1,11, t 4,74, DD 8,7% (`FAMIGLIA1_ORO_CRITERI` r.25 e CSV) | CONFERMATA (r.25; CSV `RISULTATI_CONTROLLO_FAMIGLIA1_ORO.csv`) |
| A1 | Anni mancanti nel CSV: 2015, 2017, 2018 (su 9) e 2011, 2012, 2014 (su 10) | CONFERMATA (colonna rendimento_per_anno: presenti solo 2016, 2019-23 e 2005-10, 2013) |
| A1 | PunteLarry 2005-14 71 op PF 1,43 t 0,86; 2015-23 56 op PF 1,66 t 1,21, 2017 = 54% | CONFERMATA (CSV) |
| A1 | PunteLarry 2024-26 41 op PF 1,28 t 0,57, 2026 = 72%; Z ~1,5, p ~0,06 | CONFERMATA (`PUNTELARRY_ORO_2024_26_CRITERI` r.12-13) |
| A1 | PunteLarry tick reali 39 op PF 1,44 contro 1,50 M1, rapporto 0,96; EURUSD PF 1,08/0,74/0,96, bonus 1,34 | CONFERMATA (`PUNTELARRY_ORO_TICK_CRITERI`, `PUNTELARRY_EURUSD_CRITERI` r.16-21) |
| A1 | File identici alle copie `_F1` salvo la riga di include | CONFERMATA (diff: GoldBreakout 2 righe, PunteLarry 1 riga) |
| A3 | CRT_TurtleSoup sull'oro: 7 operazioni, PF 0,21 | CONFERMATA (CSV, 2005-14; nel 2015-23 solo 2 operazioni) |
| A2/A5 | Swap oro -9,7%/anno, -98,78 USD/lotto/notte, indici 10-14% | CONFERMATA (CLAUDE.md) |
| A5 | CanaleLento: "Donchian D1 long vs Supertrend H4 0,44 giornaliera, `CORRELAZIONE_EA_ORO_CRITERI_2026-11-21.md`" | **ERRATA nella fonte**: il numero 0,44 esiste, ma e' in `SUPERTREND_CORRELAZIONE_CRITERI_2026-11-21.md` (r.16 e 23); il file citato parla di EA oro (Reaper/Phantom/GTP) e non contiene 0,44 |

Totale complessivo: **162 CONFERMATE, 2 ERRATE, 0 NON TROVATE** (R3: minimo 2 per EA e 25 totali, ampiamente superato). Le 2 errate sono marginali: nessuna cambia una classe.

## 2. Coerenza di classe (R5) e incoerenze

Esito generale: nessuna scheda viola R5 alla lettera (nessun EA in A con un difetto "falsa i test" non risolvibile a logica invariata). Le 14 classi A/B/C nel testo coincidono con quelle in titolo: nessuna scheda con classe diversa tra titolo e corpo. Incoerenze trovate:

1. **A3 LiquiditySweep e A4 TurnaroundTuesday (classe A) ignorano misure gia' esistenti sull'oro** (FV). I sorgenti sono identici alle copie `_F1` del repo (TurnaroundTuesday e CRT byte per byte, LiquiditySweep salvo la riga 106). `report/FAMIGLIA1_ORO_CRITERI_2026-11-18.md` (r.23-29) e il CSV riportano: TurnaroundTuesday 2015-23 464 op PF 0,84 t -1,80 DD 38%, 2005-14 PF 0,74 (NON REGGE); LiquiditySweep 2015-23 154 op PF 0,79, 2005-14 PF 0,71 (NON REGGE). La scheda LiquiditySweep propone come H1 proprio una baseline sull'oro BCM (IS 2013-22, OOS 2004-12) che di fatto e' gia' stata fatta (con BE acceso, `InpBreakeven=true`); la scheda TurnaroundTuesday non cita il risultato oro. Solo A1 (GoldBreakout, PunteLarry) e A3 per CRT hanno incrociato il repo. Di conseguenza anche `report/RIANALISI_EA_NOSTRI_2026-11-26.md` riga A9 ("nessuna misura OOS nei referti") e la matrice del 26/11 sono sbagliate per questi EA. Raccomandazione a C0: A (indici soltanto, con nota "oro gia' NON REGGE") per TurnaroundTuesday; LiquiditySweep da B/C sull'oro e A solo se si cambia mercato.
2. **A2: criteri diversi per casi uguali.** OutOfNoise e' A "con protocollo" con due difetti "falsa i test" (alta: ora estiva; media: `_EXT`) risolti con input e scelta dei dati; VwapRevert e' B con difetti dello stesso tipo, che la scheda stessa dice risolvibili "solo con input, logica invariata". Per R5 anche VwapRevert potrebbe essere A (o OutOfNoise B): manca il criterio che le distingue (forse il numero incognito di segnali, ma non e' scritto).
3. **A1 Gold_Ichimoku:** il difetto 2 e' etichettato "Minore/falsa i test", la riga di classe dice "nessun difetto falsa i test". Inoltre il difetto 1 e' "Blocca il forward (alta)" e la classe e' A: accettabile (blocca il forward, non il tester) ma andrebbe scritto "A solo per il tester". La scheda non segnala che il file include `ABTG_PausaGuardian.mqh` (r.30), assente dai materiali: non compila dallo zip.
4. **Etichetta dell'include mancante non uniforme:** CrossEma lo chiama "blocca la compilazione" (A5), FvgRetest e LiquiditySweep "DA_VERIFICARE" (A3), OutOfNoise e VwapRevert "minore/DV" (A2), Gold_Ichimoku non lo cita (A1). Stesso fatto, tre gravita'. Gli EA che compilano da soli: AltaVelocita, TurnaroundTuesday, MeanRevert, CanaleLento, ChaosLyapunov, CRT.
5. **A3 CRT_TurtleSoup (B):** il pavimento a punti fissi e' un input (`InpMinStopPts`, r.103), quindi il difetto "falsa i test alta" e' risolvibile per simbolo senza codice: per R5 sarebbe A. B e' difendibile solo perche' sull'oro ha prodotto 9 operazioni totali (non valutabile), non scritto.
6. **A5 ChaosLyapunov:** la formula "ln(movimento ultime 3 barre / movimento 3 barre a lag 5-7)/5" e' una parafrasi approssimata (numeratore e denominatore sono spostamenti di 1 barra dello stesso segmento, r.172-197); la sostanza (manca la finestra di Theiler, il vicino piu' prossimo e' quasi sempre il segmento adiacente, r.172) e' confermata ed e' correttamente marcata INF/da replicare.

## 3. Difetti nuovi trovati nei sorgenti (3 EA scelti: ChaosLyapunov, FvgRetest, Gold_Ichimoku; verifica a vista anche su CrossEma, AltaVelocita, VwapRevert, MeanRevert)

| # | EA | Difetto | Gravita' | Evidenza |
|---|---|---|---|---|
| N1 | ChaosLyapunov | **Il gate e' fail-open sui casi degeneri.** `Lyapunov_Calc` restituisce 0.0 per dati corti, nessun vicino valido o distanza nulla (r.166, 186, 195); il gate blocca solo se `lle > soglia` (r.205-208) con soglia 0,00 (r.69): 0.0 passa. In serie piatte o con barre ripetute (illiquido, notte, dati `_EXT` con aggiornamenti radi) il gate "non caos" e' vero per costruzione. Gonfia `gCntGatePass` e contamina l'ablazione H2 (nudo vs gated) | media, falsa i test | FV (r.166/186/195/205-208/415) |
| N2 | FvgRetest (e stesso schema in CrossEma) | **TP tolto in silenzio.** Se il TP cade dentro lo stops level l'EA lo azzera e apre solo con SL (FvgRetest r.947, CrossEma r.402: il log dice "lo tolgo e lascio la gestione"). Con parziale/BE/trailing spenti di default (FvgRetest r.197-203, CrossEma r.100-104) la posizione non ha nessuna uscita attiva se non lo SL: R:R e durata cambiano senza traccia nel set. Raro con stops level 0, frequente su indici/oro con stops level alto | minore (falsa i test solo se lo stops level e' alto) | FV (FvgRetest r.947, CrossEma r.402) |
| N3 | Gold_Ichimoku | Include `ABTG_PausaGuardian.mqh` (r.30) assente dai materiali e non segnalato: non compila dallo zip; nel tester la guardia e' fail-open (gia' notato da A1 a r.31-42, ma senza il legame con la compilazione) | media (compilazione), non cambia classe | FV (r.30) |
| N4 | LiquiditySweep, TurnaroundTuesday, CRT | Misure gia' esistenti sull'oro non riportate (vedi punto 2.1) | alta come lacuna di scheda | FV (CSV, diff con `_F1`) |

Nessuna lettura della barra in formazione ne' orario senza ora legale ulteriore e' emersa oltre a quanto gia' dichiarato (ChaosLyapunov r.385 e flat 15:55 gia' segnalati da A5). Su VwapRevert i pendenti sono GTC con cancellazione a mano (r.973-974, 1006-1023): gestito in modo stateless dall'autore, nessun difetto nuovo.

## 4. Affidabilita' dei revisori

| Rev | Citazioni | Giudizio |
|---|---|---|
| A1 | 37 su 37 giuste (+6 dati su report giusti) | **Alta.** Unico a incrociare il repo: ha trovato che GoldBreakout e PunteLarry sono gia' misurati e identici alle `_F1`. Difetti: Ichimoku omette l'include; piccola incoerenza di etichetta |
| A2 | 34 su 34 giuste | **Alta sul codice** (orari, `_EXT`, tick volume, controlli R2 accurati). Debole sulla coerenza di classe tra OutOfNoise (A) e VwapRevert (B), senza criterio dichiarato |
| A3 | 32 su 33 (1 errore di 3 righe) | **Medio-alta.** Buon lavoro sul codice (tag "falsa i test" ben motivati); non ha cercato le misure `_F1` di LiquiditySweep, quindi la classe A e le ipotesi H1 sono parzialmente ridondanti |
| A4 | 24 su 24 giuste | **Alta sul codice** (scheda AltaVelocita la piu' dettagliata, difetti 1-3 tutti verificati). Per TurnaroundTuesday non ha cercato misure gia' esistenti: lacuna rilevante per la classe |
| A5 | 27 su 27 giuste nel codice; 1 fonte di report sbagliata | **Alta.** L'osservazione sulla finestra di Theiler e il rilievo sulla barra 0 del gate sono corretti e verificati; imprecisione nel nome del file di correlazione e nella parafrasi della formula LLE |

Limiti di A6: confronto con i `_F1` per soli 5 EA (gli altri 9 non hanno copia nel repo); nessun backtest eseguito; le inferenze sui broker e sui dati (`_EXT`, FTMO) non sono state riverificate con i dati.
