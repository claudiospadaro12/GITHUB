# R92BAB (diagnostica del guasto del tester) - lettura del 01/10/2026 sera
Fonte: `backtest_pipeline/risultati_archivio/ROUND_R92BAB_20261001_2201/` (zip del PC di backtest DESKTOP-H4D7CAJ, 22:01-22:12 ora PC, 12 minuti, 6 job su 6 lanciati, catena completa). Criteri scritti prima: `R92B_DIAGNOSI_CRITERI.md`.

## Vettore STATI [MISURATO dal riepilogo della riga]
`P=MISTO A=OK B=OK C=MISTO D=OK A2=OK`
- P (controllo positivo, EA DAX a UN simbolo, tick reali): gamba IS MORTA (6 righe `OnTesterInit works too long`, 22:02:25-22:03:43, `Tester cannot be initialized`), gamba OOS partita.
- C (8 cross, 55 caratteri): gamba IS partita, gamba OOS MORTA (6 righe, 22:08:29-22:09:46).
- A, A2 (22 cross, 153 caratteri), D (8 cross a 153 caratteri), B (GBPUSD): tutte e due le gambe partite, zero avvisi, CSV completi, Symbols_List lunga quanto dichiarato.

## Lettura secondo la tabella (scritta prima)
Condizione di validita' P = OK: **non soddisfatta (P = MISTO) -> riga 7: il tester di questo PC e' guasto ADESSO, nessun verdetto su A/B/C/D**; con due MISTO si applica comunque la riga 6 (non monotono, nessuna ipotesi regge). Quindi **nessuna causa e' stata decisa** e **R92b NON e' sbloccata**.

## Cosa e' comunque un FATTO misurato (non una causa)
1. **Il guasto e' intermittente**: 2 gambe morte su 12 (17%), con la stessa firma (5 avvisi a ~15,5 s uno dall'altro, poi il fatale), e **vivono entrambe le versioni dello stesso EA**: A e A2 con 22 cross e 153 caratteri sono partiti 4 gambe su 4, D (8 cross a 153) 2 su 2.
2. **Il guasto colpisce anche un EA a UN simbolo** (P, `ABTG_DAX_Apertura_EU_Pin9fca` su D30EUR): quindi la sola firma `OnTesterInit works too long` NON e' specifica del cesto a 22 simboli del Bulge ne' della lunghezza della stringa.
3. **Il taglio a 63 caratteri dell'input e' ESCLUSO dai deal** per i job A, A2 e D: il Bulge ha chiuso 208 deal (A, A2) e 147 deal (D) su simboli oltre il 63esimo carattere della stringa (es. A: 13 simboli, 208 deal su 363). Questo e' un fatto sui trade, indipendente dalla causa del guasto.
4. Costo di una gamba morta: ~78-83 s (5 avvisi + fatale), un job con una gamba morta dura 163-196 s contro 68-95 s.
5. I compilatori MetaEditor del log sono quelli del driver (uno per job, 22:01:31 ... 22:11:18): non c'e' compilazione manuale nella finestra.

## Cosa NON dice
- Non dice che il guasto sia "transitorio" (un solo giro, 12 gambe) ne' che sia legato al cesto, alla lunghezza o al numero (riga 7).
- Non dice se il guasto dipende dalla cache del tester (non svuotata: decide Claudio) o dalla prima gamba dopo l'apertura del terminale (P IS era la prima gamba della sessione; C OOS no).

## Cosa conta per R92b (l'obiettivo vero)
Con P(gamba muore) ~ 17%, un job da 2 gambe muore ~31% delle volte e un round da 10 job perde ~3 job. Il driver oggi NON riprova una gamba morta (verificato: nessun `retry` ne' riferimento a `cannot be initialized` in `walkforward_generico.ps1` / `RIGA_ROUND_VPS.ps1`). Mitigazione proposta: riprovare UNA volta la gamba che muore con `Tester cannot be initialized`, loggandolo nel riepilogo. E' una modifica al driver del PC di backtest (non tocca campo, conti ne' preset), passa dai due cancelli. Replica pulita richiede magic nuovi (o cache svuotata: scelta di Claudio).
