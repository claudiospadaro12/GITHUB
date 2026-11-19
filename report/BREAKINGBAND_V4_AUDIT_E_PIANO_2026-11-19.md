# BreakingBand_MT5_v4 (Massimo) — audit del codice e piano di ottimizzazione (19/11/2026)
Materiale: `BreakingBand_MT5_v4.mq5` (copiato invariato in `mql5/Experts/`), `Riepilogo_BreakingBand_per_Claudio.pdf`. Flusso richiesto (Fasi 1-4): qui **Fase 1 (audit) e Fase 2 (disegno e .set) sono fatte**; la Fase 3 (tester) gira solo sul PC di backtest e non e' stata lanciata: **nessuna metrica di tester e' riportata qui, perche' non esiste ancora un report MT5 nostro.**
## FASE 1 — Audit
**Cosa fa:** su nuova barra chiusa (turno su shift >= 1: nessun repainting) cerca un "bulge" (larghezza Bollinger >= 1,12 x media a 20 barre, StdDev > SMA50 della StdDev, candela >= 1,5 ATR entro 20 barre, prezzo oltre 0,4 della semi-larghezza dalla mediana); poi aspetta un ritracciamento "ordinato" (nessuna candela > 1,5 ATR, ombra <= 1,5 corpo) fino a 40 barre e un segnale di conferma (StdDev rientra sotto la sua SMA50 **e** bande in restringimento). Entra a favore del bulge (continuazione) oppure **contro** (inversione) se negli ultimi 60 barre ci sono almeno 2 bulge nella stessa direzione. SL 3 ATR; TP = mediana (modo 1); rischio 0,5%.
**Discrepanze col riepilogo/PDF e bug logici (dal codice):**
1. **"Range 30-50% del bulge" (riepilogo) NON e' implementato**: `RetracementOK` controlla solo ampiezza e ombre delle candele.
2. **TP sulla mediana vale davvero solo per le inversioni.** Per una continuazione long il prezzo e' di norma sopra la mediana: `tp<=entry` fa scattare il ripiego `entry + 2 ATR`. Risultato: continuazioni con SL 3 ATR / TP 2 ATR (RR 0,67), inversioni con TP sulla mediana. Il PF dei due tipi va misurato separatamente.
3. **L'"inversione" e' semplificata:** basta aver contato 2 bulge nello stesso verso nelle ultime 60 barre (conteggio con salto di 21 barre per bulge). Non verifica ritest della banda dell'impulso, deviazione standard in calo, ecc. della Guida Operativa.
4. **Stato congelato durante una posizione:** `if(HasPos()) return;` sta prima dell'aggiornamento di `bBar`; a posizione chiusa `bBar` non corrisponde piu' alla posizione reale del bulge e `RetracementOK` guarda barre sbagliate (raro).
5. **Rilevazione ripetuta dello stesso bulge:** dopo un'operazione o una scadenza lo stato si azzera e lo stesso bulge, se ancora valido, puo' ripartire.
6. **Parametri hardcoded:** finestra media bande = 20 (non `BB_Period`), lookback inversione = 60, finestra impulso minima = 3, nessun filtro spread/orario/notizie, nessuna uscita a tempo.
7. Buffer: `ArraySetAsSeries` dopo `CopyBuffer` e' corretto; `Load` ha dimensioni sufficienti (130 barre per indici fino a 108). Nessun repainting rilevato.
**Il riepilogo di Massimo, letto con i suoi numeri:** v4 = 30 operazioni in 13 anni (2,3/anno), PF 1,69, win 76,67% (23 vincenti / 7 perdenti), netto **+240 su 10.000 (+2,4% in 13 anni)**. Dai suoi numeri il rapporto vincita media / perdita media e' circa 0,51; il rendimento atteso per operazione e' circa +0,16 volte la perdita, con errore standard circa 0,12: **t circa 1,4, non significativo**. Sono state provate 4 versioni e si mostra la migliore (selezione). Sharpe 6,16 su 30 operazioni non e' una misura affidabile. v3 e v4 hanno entrambe 30 operazioni: verificare se sono le stesse. Il suo test Python precedente dava PF 1,01; il nostro test su anni nuovi di forex dava "NON DIMOSTRATO" (N=49, R medio +0,006) e sull'oro PF 0,51 (Sala del Consiglio). **Portare la strategia su 12 simboli non e' un test indipendente: e' 12 tentativi di trovare un risultato (confronti multipli).**
**Classificazione degli input:**
| Gruppo | Input |
|---|---|
| **Core** | Bulge_BWexp, Bulge_ImpATR, Bulge_DistMid, Bulge_MaxBars, Retr_MaxCandleATR, Retr_ShadowBody, Retr_MaxBars, UseStdDevCut, StdDevSMA, EnableContinuation, EnableReversal, Reversal_MinBulges, SL_ATRmult, TP_Mode, TP_ATRmult, BB_Period, BB_Dev, ATR_Period |
| **Secondari** | nessuno nel codice (mancano filtri orari, trailing, breakeven, spread) |
| **Fissi** | RiskPercent, MagicNumber |
## FASE 2 — Disegno (scritto PRIMA di qualunque numero)
**Il problema vero:** l'obiettivo "PF >= 1,5, DD <= 15%, >= 150 operazioni" non e' raggiungibile con il codice com'e': il default fa circa 30 operazioni in 13 anni (v2 con criteri larghi: 1.434 operazioni, PF 0,90). Ottimizzare su 15-20 operazioni sarebbe adattamento al rumore. **La passata 1 cerca quindi se esiste una zona intermedia (>= 150 operazioni IS) con PF decente.**
**Simbolo/TF:** EURUSD H1 (come il riepilogo). **Dati/modello:** BCM tester, barre da 1 minuto (nostro standard). **In-Sample 2013-01-01 -> 2020-12-31 (8 anni); Out-of-Sample 2021-01-01 -> 2024-12-31 (4 anni); 2025-2026 NON si tocca (hold-out).**
**Parametri liberi (passata 1, `BREAKINGBAND_V4_SET/opt_pass1.set`):** Bulge_BWexp {1,08; 1,12; 1,16; 1,20}; Bulge_ImpATR {1,0; 1,25; 1,5}; Retr_MaxCandleATR {1,0; 1,5; 2,0}; UseStdDevCut {no; si'}: **72 combinazioni**. Tutto il resto al default (`baseline.set`).
**Porte (scritte ora):** Fase 0 = baseline sul solo In-Sample: **se le operazioni IS sono < 60, non si ottimizza (non valutabile)**. Passata 1: scartare passaggi con < 150 operazioni IS o DD > 15%; **plateau**: la scelta deve avere i vicini (un passo) con PF IS > 1,3 in almeno meta' dei casi; **Top 3** dal plateau (non il picco), valutati UNA volta sull'OOS: validato se PF > 1,3, >= 50 operazioni, R medio > 0 e DD <= 15%. Contatore dei tentativi: 72 (+ le 4 versioni gia' provate da Massimo). Nessun ritocco di soglie dopo.
## Previsioni
- Baseline (default) su IS 2013-2020: < 60 operazioni: **85%**.
- Esiste una combinazione con >= 150 operazioni IS e PF IS >= 1,5 con DD <= 15%: **8%**.
- Un Top 3 passa l'OOS (PF > 1,3, >= 50 op.): **3%**.
- Separando continuazione e inversione, una delle due ha PF netto < 1 in IS: **60%**.
## Cosa serve per la Fase 3
Riga pinnata sul PC di backtest (compila `BreakingBand_MT5_v4.mq5` da repo con SHA256, esegue baseline e le 72 prove sul solo IS, poi OOS dei finalisti, MT5 chiuso). Non scritta finche' non dici di si': peso medio (2-3 ore mie), 6-8 ore di tester.
