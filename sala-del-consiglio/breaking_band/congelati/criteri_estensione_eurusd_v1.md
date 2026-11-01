# Estensione pre-registrata: Breaking Band su EURUSD (C0, 01/11/2026) — scritta PRIMA di qualsiasi esecuzione sui dati EURUSD
Contesto: il run sull'oro (final/RELAZIONE_FINALE.md) e INCONCLUSIVO (N=25). EURUSD e il cross principale dell'ambito dichiarato dalla Guida (major/minor, H1/M30). Dati: 4 CSV M1 BCM (2013, 2018, 2020, gen 2025-set 2026), 368-645 mila righe l'uno, hash in congelati/HASH_DATI_EURUSD.txt (calcolati alla ricezione, senza guardare i prezzi oltre le prime righe e il numero di righe, che coincide con il riepilogo dell'export).
## Regole: IDENTICHE al test sull'oro
Stessa specifica_v1.md, stesso disegno_test_v1.md, stessi criteri_previsioni_v1.md Parte B (4 esiti; N<30 INCONCLUSIVO; eps 0,10 R; p_B1<=0,05), stessi parametri (BB 20/2, stop 3 ATR, target SMA20 ricalcolato ogni 3 ore, gate sd, T_MAX 30, warm-up 200...). UNICHE modifiche ammesse (strumentali, non di regola): (1) simbolo e nomi dei file; (2) PUNTO (dimensione del punto: 0,00001 per EURUSD a 5 decimali, 0,01 per l'oro) usata per convertire lo spread da punti a prezzo; (3) eventuali costanti in USD del placebo (spread costante 25 punti): resta 25 punti del simbolo. Nessuna soglia, nessun parametro di segnale, nessuna ipotesi cambia. Il codice modificato avra un nuovo hash e un test di invarianza di scala (stesso risultato sull'oro con prezzi riscalati).
## Ipotesi primaria (UNICA)
H1, continuazione + inversione insieme, EURUSD, 4 periodi. Esplorative (non promuovono): M30, CONT e INV separati, sensibilita Sa-Sg, GBPUSD/USDJPY/EURJPY (se verranno forniti: ogni coppia e un'estensione a se, riportata separatamente; nessuna puo trasformare un esito inconcludente di EURUSD in un indizio).
## Verdetto
Esattamente la Parte B dei criteri v1 (INCONCLUSIVO / INDIZIO / NESSUN VANTAGGIO / NON DIMOSTRATO). Clausole di perimetro: ambito della Guida, ma solo un cross e 4 periodi; non e la versione discrezionale; nessuna indicazione su lotti/conti; parole vietate come in v1.
## Previsioni (probabilita, scritte ora)
- X1 N trade H1 pooled: <30 / 30-99 / >=100 = 45% / 45% / 10%.
- X2 Verdetto: INCONCLUSIVO 45%, NON DIMOSTRATO 32%, NESSUN VANTAGGIO RILEVANTE 19%, INDIZIO 4%.
- X3 (se N>=30) media R netta H1 pooled: <0 = 60%; PF netto >=1,15 = 17%.
- X4 pareggio atteso medio dei trade fra 70% e 82%: 80% (stesso meccanismo geometrico dell'oro: target ~1 ATR contro stop 3 ATR).
- X5 costo di spread medio per trade < 0,05 R: 80% (spread EURUSD piccolo rispetto all'ATR H1).
- X6 `p_B1` <= 0,05: 6%; >= 0,80 (pattern peggio del caso): 25%.
- X7 N EURUSD H1 >= N oro H1 (25): 60%.
- X8 il verdetto cambia segno rispetto all'oro (media R oro -0,16): 35%.
- X9 tutti i controlli [B] di A7 SUPERATI al primo ciclo: 55%.
## Regole di non modifica
Dopo l'hash di questo file e del codice: nessun cambio. Se un controllo fallisce: correzione con registro e nuova esecuzione di TUTTI i controlli. Se N<30: INCONCLUSIVO, e il rimedio resta piu storia o piu simboli, non soglie piu larghe.
