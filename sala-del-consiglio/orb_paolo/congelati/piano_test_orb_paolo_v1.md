# Piano di test PRE-REGISTRATO — ORB "Metodo Paolo" (R005)

Stato: **BOZZA prima della critica di A6 (R006)**; diventa v1 congelata (con sha256) solo dopo la critica. **Nessun test eseguito. Nessun risultato visto. Nessun lotto/taglia/rischio %: il piano misura in R (multipli dello stop) e in punti/bps di prezzo.** Esecuzione solo dopo OK esplicito di Claudio, in un secondo momento, con reimplementazione indipendente.

## 1. Domande (cosa il test può dire)
- Q1. Il **nucleo oggettivo** del metodo (box 15 min, M5 che apre e chiude fuori, ingresso alla chiusura, stop sul lato opposto, TP 1:1), operazionalizzato come in sez. 3, ha un'aspettativa netta positiva sul Nasdaq?
- Q2. Quanto cambia il risultato passando da "ingresso alla chiusura della M5" a "ordine pendente al tocco" (differenza 1 del confronto)?
- Q3. Quanto cambia con le uscite del nostro live (stop a mezzo box, TP 3R) sugli stessi segnali (differenza 2)?
- Fuori portata (dichiarato): contesto (medie, SuperTrend, VWAP, volumi, trend), resistenze H1/H4, retest, "troppo lontana", TP tecnico, parziale 30–40 pt, gestione manuale. Non sono regole del PDF codificabili senza invenzioni → **NON TESTATI**, non "falliti". Eventuali proxy (es. EMA200 come nel live) sarebbero un altro piano.
- Ogni esito vale per **la nostra operazionalizzazione**, mai per "il metodo di Paolo" (il metodo non è falsificabile: A6).

## 2. Dati e controlli preliminari (nessuna lettura del P&L)
- Primario: Nasdaq `_EXT` M1 2010–2026 (simbolo esatto e hash sha256 dei file da congelare prima dell'esecuzione). Replica: S&P `_EXT` M1 2010–2026. Descrittivo: DAX D30EUR M1 da 09/2024 (non confermativo: campione piccolo; orario DAX non nel PDF).
- **Orario**: apertura cash 09:30 New York. Ora server BCM (GMT+1 fisso): **14:30 server se USA in ora legale, 15:30 server se USA in ora solare**; calendario USA ufficiale (2ª domenica di marzo – 1ª domenica di novembre). Box = [apertura, apertura+15 min). Fine sessione forzata = 15:55 New York. Da non confondere con l'ora italiana.
- Controllo C1 (prima di tutto): per ogni anno e per ogni periodo (USA ora legale / ora solare / scarti con l'Europa) verificare sui dati che il picco di volume/volatilità M1 cada al minuto di apertura previsto. Se un periodo non torna, quel periodo è escluso e il fatto riportato; **nessun risultato si legge prima che C1 sia passato**.
- Controllo C2: buchi nei dati, giorni festivi/mezze giornate USA (esclusi con elenco dichiarato), alleanza delle barre M5 con i confini.
- Controllo C3: gli `_EXT` hanno spread? Se no, solo scenari di costo (sez. 4).

## 3. Specifica delle varianti (definizioni congelate)
Comuni: un solo trade al giorno, il primo segnale valido; segnali ammessi solo fino alle 11:30 New York; entrambe le direzioni; box = max/min delle M1 nella finestra, ombre incluse; M5 costruite da M1 con confini a 5 minuti dall'apertura; se il box ha ampiezza 0 il giorno è saltato; stop = lato opposto del box senza buffer (buffer 0; un "gocciolino" è non definito nel PDF); fine sessione 15:55 New York a mercato.
- **V1 (primaria)**: M5 con **apertura e chiusura oltre lo stesso bordo** (lettura letterale slide 6); ingresso a mercato all'**apertura della M1 successiva** alla chiusura della M5; TP 1R.
- **V2**: come V1 ma basta che la **chiusura** sia oltre il bordo (apre dentro o fuori). Misura quanto pesa A-02.
- **V3**: ingresso con **ordine pendente al bordo** (tocco, nessun requisito di candela, spike inclusi), stesso stop, TP 1R. Misura la differenza 1.
- **V4**: segnali di V1, ma **stop a mezzo box e TP a 1,5 box** (3R) come nel live. Misura la differenza 2.
- **V5**: V1 con TP 2R (sensibilità sul target; «3R è ambizioso»).
Famiglia confermativa = {V1..V5} su Nasdaq; il conto delle varianti è **5** e va riportato. Nessuna altra variante verrà aggiunta dopo aver visto i numeri; se ne servono altre, nuovo piano e nuova correzione.
Non incluse (decisione di C0, non scelta dai numeri): soglie di distanza (35/41/53), box massimo, filtri di contesto.

## 4. Costi e intra-barra (dichiarati)
- Costi di scenario (round turn, in frazione del prezzo): **0, 1, 2 bps**. Scenario di riferimento per le conclusioni: **1 bps**. Si riportano sempre lordo e netto.
- Ordine intra-barra su M1 quando una barra tocca stop e target: caso riferimento **stop prima** (peggiore); si riporta anche il caso **target prima** (migliore). Una conclusione che differisce tra i due casi è dichiarata **dipendente dall'assunzione** e non conta come CONFERMATO.
- Il fill di V1/V2 è all'apertura della M1 successiva; per V3 al prezzo del bordo (nessuno slippage aggiuntivo oltre lo scenario di costo).

## 5. Metriche, periodi, soglie
- Metrica primaria: **aspettativa netta in R per trade** (media di R dopo costi), con IC 95% bootstrap a blocchi per giorno (10.000 ricampionamenti). Secondarie: win rate, profit factor, MAE/MFE, concentrazione sui 10 giorni migliori, numero trade.
- Periodi: **metà A = 2010–2017**, **metà B = 2018–2026**. Un risultato deve avere lo **stesso segno in entrambe**. Nessun parametro è scelto sui dati: tutto è fissato dal PDF o da questa sezione, quindi non serve un periodo di taratura; la divisione serve alla stabilità.
- Minimo campione per poter concludere su una metà: **300 trade** per variante (altrimenti INCONCLUSIVO per quella metà).
- Correzione per test multipli: Holm sui 5 test della famiglia (H0: aspettativa netta ≤ 0), alfa 5%.
- Benchmark (C4): stessa finestra, stesso stop/TP e stessa durata, ma **direzione casuale** (2.000 sorteggi con seme fisso) e variante "solo long"; V1 deve battere il benchmark con IC che non include zero, altrimenti l'esito è attribuito alla deriva/struttura e non al segnale.
- Controllo negativo (C5): box spostato di +60 minuti (ora sbagliata, V1): non deve mostrare un vantaggio comparabile; se lo mostra, il risultato di V1 non è attribuibile all'apertura.
- Reimplementazione (C6): un secondo implementatore indipendente (agente diverso da chi scrive il codice principale) parte dalla specifica congelata; accordo ≥ 99% sui trade (data, direzione, ingresso, uscita) prima di leggere l'esito. Differenze spiegate o la variante non conta.

## 6. Criteri di verdetto (scritti prima)
- **CONFERMATO** (solo per V1, riferito alla nostra operazionalizzazione, Nasdaq, 1 bps, caso stop-prima): aspettativa netta > 0 con IC 95% > 0 dopo Holm in **entrambe** le metà, ≥ 300 trade per metà, batte il benchmark C4, C5 non mostra vantaggio comparabile, C1 e C6 superati, concentrazione top-10 giorni < 25% del profitto lordo.
- **INDIZIO**: segno positivo in entrambe le metà ma IC include 0 (o Holm non superato), oppure positivo solo con il caso target-prima, oppure positivo senza costi ma non a 1 bps.
- **NESSUN VANTAGGIO RILEVANTE**: ≥ 300 trade per metà, IC 95% include 0 e |aspettativa netta| < 0,05 R, oppure segno discordante tra le metà.
- **NON DIMOSTRATO**: aspettativa netta negativa con IC < 0 in almeno una metà, o risultato positivo ma con un controllo C1–C6 non passato.
- **INCONCLUSIVO**: campione sotto soglia o dati non conformi (C1/C2 non superati) per più di un quarto degli anni.
- Un controllo **non eseguito non è passato**: qualsiasi C1–C6 mancante impedisce CONFERMATO.
- Per V2–V5 il verdetto è confronto con V1 (differenza di aspettativa con IC), non una conferma a sé.
- DAX: solo descrizione (n trade, aspettativa lorda, IC), nessun verdetto.

## 7. Previsioni di C0 (scritte prima, non misurate)
1. V1 ha pochi segnali (la lettura letterale «apre e chiude fuori» esclude la rottura più frequente): ipotizzo un segnale in circa il 25–50% delle sedute. Incertezza alta.
2. L'aspettativa lorda di V1 è vicina a zero; con 1 bps è ≤ 0. Probabilità che V1 raggiunga CONFERMATO: **~10%**.
3. V2 produce più trade di V1 e aspettativa non migliore (rottura più "tardiva").
4. V3 ha più trade e più stop da spike di V1; aspettativa netta inferiore a V1.
5. V4 ha win rate molto più basso e profilo diverso; l'aspettativa in R non è prevedibile a priori (non faccio previsione di segno).
6. Il benchmark "direzione casuale" fa meglio di zero nel solo long per via della deriva del Nasdaq 2010–2026.
Se le previsioni 2–4 sbagliano, lo dichiaro nel referto.

## 8. Esecuzione e perimetro
- Nessuna esecuzione senza OK di Claudio. Gira sul PC di backtest/VPS solo in sola lettura sui dati; mai sul conto reale 10105439; nessuna modifica agli EA live (`_Ottimizzato` resta in parallelo agli originali).
- Una riga per il VPS, se necessaria, segue le regole della casa (script pin + sha256 + marker, gate controlla_riga).
- Output previsto: `final/RELAZIONE_ORB_PAOLO.md`, trade-list CSV, hash dati e codice, ripartizione per periodo estate/inverno/scarti.

## 9. Stato dei controlli
C1 NON_ESEGUITO · C2 NON_ESEGUITO · C3 NON_ESEGUITO · C4 NON_ESEGUITO · C5 NON_ESEGUITO · C6 NON_ESEGUITO · Critica del piano (R006) IN CORSO · Controllo citazioni (R008) IN CORSO (C0 ne ha riletto 6, parziale).
