# Decisioni per C0 (A1, fase 2) — cosa decidere o accettare come compromesso
Formato: decisione, opzioni, RACCOMANDAZIONE, costo/rischio. "Compromesso" = scelta con perdita dichiarata. Riferimenti: K = contraddizioni in specifica_v1.md sez. 2; U = obiezioni non risolte (sez. 10); Q = previsioni.

**D1. Ipotesi primaria unica.** Opzioni: (a) H1 pooled CONT U INV; (b) solo CONT; (c) solo INV. RACCOMANDO (a): la domanda del brief e sulla strategia; raddoppia N (vincolo principale, A5). Compromesso: un pattern buono e uno cattivo si compensano; per questo CONT e INV sono riportati separati (descrittivi).

**D2. Sostituire M15 con M30 (modifica di R006/V16 e di checklist A7).** La Guida ammette D1/H4/H1/M30, non M15; M15 e anche il piu esposto allo spread (A3/A5). RACCOMANDO: H1 primario, M30 esplorativo, M15 non testato. H4/D1 non testabili per frequenza. Se C0 vuole M15 per fedelta al brief, va dichiarato "fuori Guida" ed e una seconda esplorativa. A7 deve aggiornare le 16 celle.

**D3. Congestione CS/CDA: punteggio o cancello (K8, U-A2-1).** RACCOMANDO punteggio + stratum (Prompt: sezione non valida != pattern non valido; N). Costo: pattern testati = soprainsieme; obiezione di A2 non risolta. Alternativa: cancello (la specifica A2 sez. 1.1 e pronta), N ~ -60/75%.

**D4. Dev. std. sotto SMA50 come cancello di ingresso (K2).** RACCOMANDO cancello (`sd<S50` e `sd<=sd[-3]`) per entrambi i pattern: Guida + Protocolli + invalidazione Checklist. Costo dichiarato: riduce N e porta il target a ~1,5 ATR (pareggio 65-68%, A5); sensibilita Sa riportata. Se C0 vuole massimizzare N, la scelta alternativa e spegnerlo (lettura Checklist 5%) ma contraddice la Guida su una regola di ingresso.

**D5. Soglia candela impulsiva (K3).** RACCOMANDO 1,5 ATR (range) per entrambi; 1,0 letterale come sensibilita Sb. Compromesso: potenziale lettura meno severa della Checklist; protegge dal filtro auto-colpente.

**D6. Aggiornamento del target (K1).** Dopo il messaggio di C0: "ore". RACCOMANDO ogni 3 ORE (H1 = 3 barre, M30 = 6 barre). Nota: il testo di R003 dice "ogni 3 barre": per H1 coincide, per M30 no (A4 usa il parametro `ricalcolo_ogni`).

**D7. Nessuna uscita a tempo (K15).** RACCOMANDO `maxhold=1000` (non vincolante) + fine dati; Sc=150 come sensibilita. Rischio: posizioni lunghe bloccano i segnali (contati). A2 voleva 48, A4 ha 150 di default.

**D8. N minimo e regimi del verdetto.** RACCOMANDO: N<30 INCONCLUSIVO; 30-99 PRELIMINARE; >=100 PIENO (derivato da A5). Alternativa piu severa (V0/A5): 100 unico, con probabilita di INCONCLUSIVO ~90% (Q2 stima P(N>=100)=10%). Compromesso: i verdetti preliminari hanno bassa potenza e sono etichettati.

**D9. Statistica e soglie del verdetto.** RACCOMANDO decisione su media R netta per trade con `p_B1<=0,05` contro la linea di base abbinata, non su PF fisso (N-adattivo, evita soglie irraggiungibili). `eps=0,10 R` (circa PF 1,25) e una convenzione: C0 la conferma o la sposta PRIMA dell'hash. PF>=1,15 resta condizione secondaria.

**D10. Ampiezza della linea di base e del placebo.** B1 (decisionale), B0 e B2 (riferimento/esplorativa), placebo sintetico (obbligatorio per correttezza, CK-13), placebo a blocchi sui dati reali (opzionale). RACCOMANDO tutti e quattro: costo basso (le barre idonee si simulano una volta). Se il tempo manca, B2 e il placebo a blocchi si possono togliere senza toccare la decisione.

**D11. Allineamento motore A4 <-> specifica <-> A7 (da decidere PRIMA del codice).**
 - (a) Riempimento del target in gap: specifica/A6/A7 = al livello; A4 = all'apertura se migliore (U-A7-2). RACCOMANDO il livello (conservativo); A4 aggiunge un parametro oppure A7 e A4 concordano e dichiarano.
 - (b) Log del trade: A7 richiede la schedule completa dei target; A4 espone solo `n_agg_target` e `target_finale` (U-A7-1).
 - (c) Sostituzione spread=0 a monte (specifica 6.9) e `max_gap_ingresso_min=180`: parametri/preprocessing, non toccano la logica.
 - (d) Mancano il generatore dei segnali (macchina a stati di questa specifica) e i contatori d'imbuto: nessun agente li ha scritti.

**D12. Gestione opzionale (BE/riduzione rischio a +1 ATR): esclusa.** E "opzionale" nella Guida e nei Protocolli, aggiunge gradi di liberta e cambia il PF. RACCOMANDO fuori dal test; se Claudio la vuole, e un secondo test pre-registrato.

**D13. Ingresso.** Barra successiva al tocco/retest (K13), come da C0; entry limit/buffer 0,1-0,2 ATR esclusi (non normativi, non causali sulla candela di test). Compromesso: prezzo d'ingresso peggiore del "livello"; la differenza e misurata (distanza livello-fill in ATR).

**D14. Estensione dei dati (disegno sez. 9).** Con N atteso basso (Q2) il rimedio vero e piu storia, non soglie piu larghe. RACCOMANDO: far scaricare sul PC di backtest 2014-2017, 2019, 2021-2024 (script ABTG_HistoryDownloader.mq5 citato da A5; da verificare) e pre-registrare UNA estensione con regole identiche, valutata una volta sola. Richiede decisione di C0 e di Claudio (tempo del PC di backtest). Alternativa: accettare l'INCONCLUSIVO e usare un indicatore-allarme forward (A5) per accumulare trade.

**D15. Identita e completezza delle fonti (DA_VERIFICARE da Claudio).** (a) GUIDA_OPERATIVA_11.txt e davvero il documento ufficiale? (frase sulla fine del bulge troncata; versione "didattica"). (b) Il Pine di Claudio chiama "In-Bulge" un rimbalzo sulla banda dell'impulso (long dopo impulso ribassista, prima della mediana), che NON coincide con la CONTINUAZIONE di Guida/Protocolli (ingresso sulla banda OPPOSTA): K18. RACCOMANDO seguire Guida/Protocolli e chiedere a Claudio quale intende. (c) Dichiarazione di Test = solo etichette: usata come descrittore del tipo di contatto. (d) Screenshot descritti da C0 ma non salvati.

**D16. Chi scrive il codice dei segnali e chi lo verifica in modo indipendente.** RACCOMANDO: A4 implementa la macchina a stati da specifica_v1.md (un solo percorso di codice con specchio); A7 scrive i pattern piantati (CK-14) e una reimplementazione indipendente del nucleo (CK-16) senza partire dal codice di A4; A1 non scrive codice (A1 definisce, non esegue). Rischio (A6 punto 9): chi scrive previsioni e verdetto e lo stesso soggetto: C0 firma l'hash, A7 verifica.

**D17. Procedura di congelamento.** RACCOMANDO: C0 calcola lo sha256 di specifica_v1.md, disegno_test_v1.md, criteri/previsioni definitivi, codice dei segnali, codice del motore e dei 4 CSV; li registra in events.jsonl e commit PRIMA del run; A7 non usa git (V15 solo mtime = evidenza debole).

**D18. Formula del perimetro nel verdetto.** RACCOMANDO obbligatoria (Parte C): oro fuori scopo Guida; M15 non testato; fonte da confermare; soprainsieme dei pattern validi; 4 regimi; nessuna estensione a EURUSD/FTMO/EA.

**D19. Destino della bozza V0 (D002).** Letta e confrontata (proposta_criteri Parte E): v1 la sostituisce. RACCOMANDO conservare V0 come documento storico e registrare le differenze; le previsioni V0 non si usano.

**D20. Costanti INTERP residue (compromessi, tutte congelate, nessuna ottimizzata).** `B1=2,0`, `B4=0,50`, `B5=2,0 ATR`, `T_MAX=30`, `MIN_RETR=3`, tolleranza banda `0,10 ATR`, finestra di riferimento di 15 barre. Sono grandezze dove la Guida dice "molto/evidente" senza numeri. Sensibilita su T_MAX (Se). RACCOMANDO accettarle cosi; ogni cambio dopo l'hash e vietato.

**D21. Risposta alle obiezioni non risolte (elenco in specifica sez. 10).** Da A2: congestione, TR/range, 48 barre, ER, 80%, X2=1,0. Da A6: ibrido residuo, F17/F18, controlli [B] non ancora eseguibili perche manca il codice. Da A7: interfaccia/schedule, fill target, 16 celle con M30. RACCOMANDO inoltrarle ad A2/A4/A7 per presa d'atto prima dell'hash (non per riaprire le scelte K), e far confermare da A6 che il disegno risponde ai suoi punti T07/T08/T13.
