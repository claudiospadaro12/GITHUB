# Live di Emiliano e Paolo del 19, 20 e 23/11/2026 (TurboScribe): sintesi delle regole e dei punti utili
Fonte: `TurboScribe_Export_2656897945.zip`. Letti per intero: Emiliano IA 19/11, Paolo 20/11, Emiliano 23/11 (mattina). **Non letti in questo passaggio:** Paolo 17/11 ed Emiliano 18/11 (gia' coperti dalla sintesi del 18/11, non riverificati). **File vuoti da rifare:** Emiliano 09/11 (0 parole), Emiliano IA 19/11 serata (0), Paolo 12/11 (5 parole). Sintesi prodotta da un sotto-agente in sola lettura e riportata qui; tutte le cifre dette dai relatori sono **non verificate**. Bulge, Breaking Band, Bollinger come strategia, ban o regole delle prop: **non nominati** in queste tre live.
## Regole esplicite (misurabili)
- **Direzione** (Emiliano 23/11): candela weekly e daily concordi: ++ solo long, -- solo short, discordi = fermo. Contesto: ultime 3 weekly con massimi/minimi crescenti o decrescenti e S/R weekly.
- **Setup notte** (19/11 e 23/11): ordine pendente a 3 pip oltre il massimo/minimo della notte, nella direzione scelta; a fill: chiudi meta', stop a pari, cancella il secondo ordine.
- **ORB DAX** (Emiliano 23/11): candela M15 delle 9:00-9:15 (ora non precisata) come range per il giorno; ingresso in M5 se la candela apre fuori dal range e con **volumi crescenti** (altrimenti no); stop a meta' del range o sotto il VWAP (5-15 min). Paolo e Emiliano "hanno visioni diverse" sui volumi.
- **ORB di Paolo** (20/11): M5, candela che apre e chiude fuori dal range con medie ordinate, VWAP ed EMA50 a favore; meglio dopo conferma e retest; parziale dopo circa 30-40 punti, stop a pari, poi Supertrend o EMA 21/50; uscita all'inversione del Supertrend. Il suo **bot pre-market**: box M1 vicino all'apertura USA (15:30), due ordini pendenti a 5 punti dal box, l'altro cancellato al fill; Dow a TP pieno, Nasdaq al 50%. Backtest 2026 "348 operazioni, avrebbe raddoppiato il conto": **non mostrato**.
- **Fibonacci** (Paolo): ritracciamento valido 38,2-61,8; sotto o sopra invalida; estensioni 127,2 / 161,8 / 200; "non e' un punto di ingresso", serve confluenza.
- **Dimensione:** dal stop: stop vicino = quantita' piena, lontano = poca e il resto sul retest. Stop sempre tecnico.
- **Cicli** (Tonino): target = minimo candela H4 + 2 x ATR(14) H4 + 13%; indicatore non fornito.
## Discrezionale (non testabile cosi' com'e')
Doji / spinning top / 1-2-3, zone di liquidita' e "mani forti", "mercato aperto all'interno = ribassista", numeri tondi, "occhio umano", dimensione "a occhio".
## Intelligenza artificiale (19/11)
Strumenti citati: Claude e Claude Code (principale), ChatGPT, Gemini, Kimi, Grok, Manus, NotebookLM, n8n; "Sala del Consiglio" (agente capo + sub-agenti) regalata e dichiarata "rivendibile a 20-30k"; 170-200 prompt "analista" promessi per il 23/11; idea futura: agente che mette lo stop automatico e blocca gli ingressi fuori piano. Spesa IA dichiarata 600-700 euro al mese.
## Red flag e coerenza
- "Stop SEMPRE" ma la strategia Nasdaq 15:25 detta "senza stop, con triplo ordine" (contraddizione, vaga).
- Cifre non provate: "80% di probabilita'", "1,7 milioni portati a casa", "da 500 a 500mila" (poi azzerato), "il Nasdaq non perde mai", "profittevoli 10-50k al mese", backtest di Paolo non mostrato. Persa 80% del conto nel 2025 ("da 56 a 7").
- Vendita di materiale (prompt, Sala del Consiglio, Training Camp); invito a non rivendere le registrazioni. Prezzi: non detti.
## Cosa vale la pena testare (solo regole esplicite)
1. **Filtro "weekly + daily concordi"** come aggiunta ai setup gia' chiusi (ORB, ordine a 3 pip dal massimo/minimo della notte): e' nuovo rispetto ai nostri test.
2. **Volumi crescenti** come filtro dell'ORB DAX/Dow (dati con tickvol: i nostri CSV hanno volumi limitati; verificare).
3. **Ordine a 3 pip oltre il massimo/minimo della notte** con direzione dal filtro weekly+daily su forex (serve M1/H1 forex da BCM) e DAX (M1 solo dal 2024).
Gli ORB di Emiliano e Paolo (M5/M15, 15:30 e 9:00) sono gia' stati misurati e chiusi senza vantaggio (`ORB_FIBO_EMILIANO_CRITERI_2026-11-20.md`): un test nuovo ha senso solo per i filtri aggiunti.
