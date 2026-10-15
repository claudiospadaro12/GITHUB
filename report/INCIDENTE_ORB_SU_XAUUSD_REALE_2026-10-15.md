# (CHIUSO da Claudio: «non preoccuparti per ABTG_ORB_Ottimizzato») Nota sul terminale REALE 10105439, 15/10/2026 21:54 (ora locale PC)

Fonte: screenshot della scheda Esperti del terminale reale dopo l'installazione dello SpreadLogger.
- 21:54:08.286 `ABTG_ORB_Ottimizzato (XAUUSD...)`: `ORB INIT`, `[ORB_OTT] avviato su XAUUSD. Range server 14:30-14:45, ingresso 10.0 x K(1.0000), fine 21:00.`
- 21:54:08.314 `CTrade::OrderSend: buy stop 0.08 XAUUSD at 4173.23 sl: 4166.86 tp: 4192.32 [invalid price]` -> **RIFIUTATO dal server**.
- 21:55:37 `ABTG_SpreadLogger (XAUUSD...)`: avviato regolarmente (conto 10105439, autotest 36/36, 1 simbolo selezionabile). Un grafico ha UN SOLO EA: lo SpreadLogger ha sostituito l'ORB sullo stesso grafico.
- Lettura [INFERITA]: sul grafico nuovo XAUUSD H1 e' stato trascinato per errore ABTG_ORB_Ottimizzato (EA CHE OPERA) per circa 90 secondi, prima dello SpreadLogger. Ha tentato un buy stop da 0,08 lotti, scartato per prezzo non valido. Non risultano altre righe ORB dopo le 21:54:08.
- DA VERIFICARE da Claudio nel terminale reale: scheda Operazioni di Trading (nessuna posizione o ordine pendente su XAUUSD) e CronoStoria (nessun deal XAUUSD di oggi). Quel conto e le sue sedie restano sue.
- Lezione per le procedure: su un terminale con soldi veri il trascinamento a mano di un EA dal Navigator e' il punto debole (lista lunga di EA con nomi simili). Prima di OK controllare il nome nella finestra dei parametri e la scheda Comune.

- 15/10 sera: Claudio dice di NON preoccuparsi per l'ORB Ottimizzato su XAUUSD: la nota resta solo come traccia, nessuna azione.
