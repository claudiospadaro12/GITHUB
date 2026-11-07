# Report regole FTMO - versione 2 (2026-11-07)

**Stato: ancora parziale ma molto più completo.** Lette 22 pagine pubbliche di ftmo.com. Restano da leggere alcune sezioni (vedi "Punti non letti").

**Lingua:** le URL /en/ sono state servite in italiano dal browser. Le frasi sono riportate nella lingua della pagina. Questo va verificato sulla versione inglese reale prima di qualsiasi decisione.

## Tabella

| # | Punto | Risposta sintetica | Frase esatta | URL | Stato |
|---|---|---|---|---|---|
| 1 | Capitale massimo per trader e strategia | Tetto 400.000 USD per trader o strategia, prima della scalabilità; aumenta con Premium. Se si superano i limiti con operazioni identiche su più conti, FTMO può sospendere i conti. Equivalenti in altre valute riportati | "In qualsiasi momento, l'allocazione totale del capitale su tutti i conti e prodotti è limitata a 400.000 dollari per trader o strategia (prima di qualsiasi scalabilità)." | https://ftmo.com/en/faq/how-many-accounts-can-i-have/ | CHIARO |
| 2 | EA identici, copy, stessa strategia su più conti | Vietato eludere i limiti con registrazioni diverse. Operazioni identiche o simili su più conti, incluse copiate da stessa fonte, possono portare alla sospensione. Vietati segnali/copy condivisi a fini manipolativi e posizioni opposte fra conti collegati | "Qualora vengano rilevate operazioni identiche o sostanzialmente simili su più conti FTMO, incluse operazioni copiate o basate sulla stessa fonte di terze parti ... FTMO si riserva il diritto di sospendere i conti interessati." | https://ftmo.com/en/faq/how-many-accounts-can-i-have/ ; https://ftmo.com/en/forbidden-trading-practices/ | CHIARO (sospensione sopra soglia); soglia precisa per tipo di EA: NON TROVATO |
| 3 | Posizioni e ordini pendenti nel weekend/overnight | Posizioni: su Challenge/Verifica e Swing si possono tenere oltre le 2 ore di chiusura; su conti Standard vanno chiuse prima della pausa >2h. Ordini pendenti: per il prelievo devono essere chiusi; per il weekend non trovata regola specifica | "È necessario chiudere tutte le posizioni aperte prima dell'inizio dell'interruzione ." | https://ftmo.com/en/faq/can-i-hold-positions-overnight-or-over-the-weekend/ | AMBIGUO (pendenti weekend: NON TROVATO) |
| 4 | Regole news | Blocco 2 minuti prima e dopo, sui simboli con la valuta interessata, non su Swing né Challenge/Verifica. Vale per SL, TP e pendenti. Lista eventi nella pagina | "Tale restrizione si applica a qualsiasi ordine , inclusi Stop Loss, Take Profit o altri ordini pendenti." | https://ftmo.com/en/faq/can-i-trade-news/ | CHIARO |
| 5 | Perdita giornaliera e totale | Giornaliera (2-Step): limite = saldo delle 00:00 CE(S)T meno 5% del capitale iniziale; verifica su patrimonio netto (equity con posizioni aperte, swap e commissioni). Perdita massima totale: sezione non letta | "il patrimonio netto del conto (ovvero Saldo + Profitti/Perdite Posizioni Aperte ± Swap – Commissioni) non può scendere." | https://ftmo.com/en/trading-objectives/ | CHIARO per giornaliera; perdita totale NON TROVATO |
| 6 | Target, giorni, durata, inattività | Target 10% sfida, 5% verifica; minimo 4 giorni con almeno una posizione aperta (00:00-23:59 CE(S)T). Durata massima e inattività: NON TROVATO | "Per giornata di negoziazione si intende qualsiasi giorno ... durante il quale viene aperta almeno una posizione ." | https://ftmo.com/en/trading-objectives/ | CHIARO per target e giorni; durata/inattività NON TROVATO |
| 7 | Prelievi e profit split | Richiesta da sezione MetriX dal giorno 14 o successivo alla prima operazione. Posizioni e ordini pendenti chiusi. Revisione 1-2 giorni lavorativi. Split: 90% (1-Step e Instant), 80% default 2-Step, 90% con Scaling o Premium. Metodi e minimi indicati. Nessuna commissione FTMO | "Tutte le posizioni aperte e gli ordini pendenti devono essere chiusi prima di richiedere il premio." | https://ftmo.com/en/faq/how-do-i-withdraw-my-profits/ | CHIARO |
| 8 | Commissioni, swap, spread, leva | Una sola commissione d'acquisto, nessuna commissione nascosta. Leva Standard fino 1:100 (non aumentabile), Swing 1:30. Swap e spread per strumento: rimandati alla pagina Simboli, non letta | "FTMO addebita solo una commissione di acquisto una tantum ... Non applichiamo commissioni aggiuntive o nascoste ." | https://ftmo.com/en/faq/what-fees-do-you-charge-and-are-they-recurrent/ ; https://ftmo.com/en/faq/what-are-the-account-specifications/ | CHIARO per fee e leva; swap/spread per strumento NON TROVATO |
| 9 | EA: permessi e pratiche vietate | EA permessi (discrezionale, algoritmico o EA) purché la strategia sia replicabile e legittima. Vietati: sfruttare errori o ritardi di prezzo, strumenti ad alta velocità o AI che diano vantaggio sleale, EA che generano più di 2000 richieste server al giorno, gap trading vicino a notizie o 2 ore prima chiusura, strategie che distribuiscono artificialmente il profitto (per aggirare Best Day/Consistency), posizioni opposte fra conti collegati. Martingala, grid, tick scalping non citati per nome | "utilizzare qualsiasi software, intelligenza artificiale, strumento ad altissima velocità o immissione massiva di dati che possa manipolare, abusare o fornire un vantaggio sleale;" | https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/ ; https://ftmo.com/en/forbidden-trading-practices/ | CHIARO (permesso e divieti generali); martingala/grid/tick scalping NON TROVATO |
| 10 | VPS e piattaforme | VPN/VPS generalmente ammessi; eccezione: non operare dagli USA su MT e cTrader, né impostare geolocalizzazione USA. Piattaforme: MT4, MT5, cTrader, TradingView. Orario server MT4/MT5: GMT+2 + ora legale | "Anche l'utilizzo di VPN/VPS è generalmente consentito." | https://ftmo.com/en/faq/can-i-travel-or-use-vpn-vps/ ; https://ftmo.com/en/faq/what-are-the-account-specifications/ | CHIARO; restrizioni VPS dettagliate NON TROVATO |
| 11 | Limiti ordini/posizioni e lotti | Server: 200 ordini simultanei, 2000 posizioni al giorno; oltre 2000 richieste server al giorno per EA è vietato. Limiti di lotti per strumento: NON TROVATO | "i server della piattaforma hanno un limite di 200 ordini simultanei e 2000 posizioni massime al giorno" | https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/ ; https://ftmo.com/en/forbidden-trading-practices/ | CHIARO (ordini/posizioni); lotti NON TROVATO |
| 12 | Conti da 160k e superiori, scaling, numero conti | Banner pubblico: conti "fino a 200.000 dollari". Scaling: +25% ogni 4 mesi fino a 2.000.000 USD totali, requisiti: 4 mesi, +10% netto, 2 payout nello stesso periodo, saldo positivo. Scaling non si applica all'Instant. Max 1 Instant attivo. Il limite di 400.000 USD per trader/strategia vale comunque | "Il piano di scalabilità non si applica all'account FTMO Instant." | https://ftmo.com/en/reward-growth-and-scaling-plan/ ; https://ftmo.com/en/faq/how-many-accounts-can-i-have/ | CHIARO su scaling e Instant; 160k specifico NON TROVATO |
| 13 | Free Trial | Versione ridotta di Challenge o Instant, per prova, senza valore di qualifica. Durata e limiti: pagina dedicata, non letta | "La prova gratuita è intesa come esperienza preparatoria, non come fase di qualificazione ." | https://ftmo.com/en/faq/do-you-offer-a-free-trial/ | AMBIGUO (durata NON TROVATO) |
| 14 | Rimborso fee, reset, riacquisto | Rimborso fee: solo 2-Step, al primo prelievo premi, stesso metodo di pagamento. 1-Step e Instant: non rimborsabile. Reset e riacquisto dopo fallimento: NON TROVATO | "Per la 1-Step FTMO Challenge e l'FTMO Instant Account , la quota di iscrizione non è rimborsabile ." | https://ftmo.com/en/faq/is-the-entry-fee-refunded/ | CHIARO per rimborso; reset/riacquisto NON TROVATO |
| 15 | Altre regole su EA, copy, capitale | Regola di coerenza: solo 1-Step e Instant (2-Step no, ma ha minimo giorni). Punteggio di disciplina: informativo, non influisce su idoneità. Uso personale: vietato far operare terzi. Tetto di rischio: posizioni e rischio non sproporzionati fra conti | "il punteggio di disciplina non influisce sull'idoneità a superare le fasi di sfida o verifica di FTMO" | https://ftmo.com/en/faq/how-does-your-consistency-rule-work/ ; https://ftmo.com/en/faq/what-is-the-discipline-score/ ; https://ftmo.com/en/forbidden-trading-practices/ | CHIARO su ambito; soglia coerenza NON TROVATO |

## Pagine lette (URL, data aggiornamento non mostrata)

1. https://ftmo.com/en/faq/ (indice)
2. https://ftmo.com/en/faq/can-i-trade-news/
3. https://ftmo.com/en/faq/can-i-trade-on-the-weekend/
4. https://ftmo.com/en/faq/can-i-hold-positions-overnight-or-over-the-weekend/
5. https://ftmo.com/en/faq/which-instruments-can-i-trade-and-what-strategies-am-i-allowed-to-use/
6. https://ftmo.com/en/trading-objectives/ (2-Step: profitto, perdita giornaliera, giorni minimi)
7. https://ftmo.com/en/faq/what-is-the-swing-account-type-and-how-does-it-work/
8. https://ftmo.com/en/faq/how-does-your-consistency-rule-work/
9. https://ftmo.com/en/faq/what-is-the-difference-between-balance-and-equity/
10. https://ftmo.com/en/faq/can-i-travel-or-use-vpn-vps/
11. https://ftmo.com/en/faq/how-many-accounts-can-i-have/
12. https://ftmo.com/en/faq/what-is-the-discipline-score/
13. https://ftmo.com/en/faq/what-is-trading-according-to-a-real-market/
14. https://ftmo.com/en/faq/can-i-merge-my-accounts/
15. https://ftmo.com/en/faq/is-the-entry-fee-refunded/
16. https://ftmo.com/en/faq/do-you-offer-a-free-trial/
17. https://ftmo.com/en/faq/who-is-an-ftmo-trader-and-how-do-i-become-one/
18. https://ftmo.com/en/faq/what-fees-do-you-charge-and-are-they-recurrent/
19. https://ftmo.com/en/faq/what-are-the-account-specifications/
20. https://ftmo.com/en/faq/which-platforms-can-i-use-for-trading/
21. https://ftmo.com/en/faq/how-do-i-withdraw-my-profits/
22. https://ftmo.com/en/reward-growth-and-scaling-plan/
23. https://ftmo.com/en/forbidden-trading-practices/
24. https://ftmo.com/en/faq/how-do-the-different-accounts-provided-by-ftmo-differ/
25. https://ftmo.com/en/faq/is-the-premium-programme-compatible-with-the-scaling-plan/
26. https://ftmo.com/en/terms-and-policies/ (solo elenco titoli)

Pagine tentate senza contenuto: https://ftmo.com/en/terms-conditions/ (solo titolo, contenuto non estratto); https://ftmo.com/en/terms-and-conditions/ (idem).
Pagine 404: /en/faq/how-do-i-withdraw-my-reward/, /en/faq/how-can-i-withdraw-my-reward/, /en/prohibited-trading-practices/.

## Punti non letti

- Perdita massima totale (Maximum Loss) dei 2-Step: pannello non aperto con certezza.
- Termini e condizioni e Risk Disclosure: il contenuto non è estratto (solo titoli).
- Pagina "Obiettivi del trading CFD" e "Pratiche di trading vietate relative ai CFD" (in terms-and-policies): non aperte.
- Pagina prova gratuita dedicata, pagina Simboli, pagina Swap/spread.
- Regola di coerenza: soglia percentuale.
- Blog: non letto (non richiesto se non spiega una regola).

## Differenze fra versioni del sito

- Le pagine /en/ restituiscono testo in italiano: la versione inglese reale non è stata confrontata.
- FAQ vs pagina Obiettivi: la FAQ sulla coerenza rimanda alla pagina Obiettivi; la soglia non è stata letta.
- Versione Futures (/en/futures/faq/): NON letta, perché il tuo quesito riguarda il CFD.
- Termini: la pagina "Terms & Policies" distingue CFD e Futures, con documenti separati per "Obiettivi del trading" e "Pratiche vietate" per ciascun prodotto.

## DOMANDE DA FARE ALL'ASSISTENZA FTMO PER ISCRITTO

Per i punti AMBIGUO o NON TROVATO:

1. Gli ordini pendenti possono restare aperti nel weekend o overnight su Challenge, Verifica, Standard e Swing? (punto 3)
2. Qual è la soglia oltre la quale un EA di terze parti con stessa strategia rischia la sospensione, e come si misura? (punto 2)
3. Quali sono i limiti di lotti per strumento? (punto 11)
4. Quali sono durata massima e regola di inattività per ciascun conto? (punto 6)
5. Qual è la perdita massima totale (Maximum Loss) per 2-Step, e come si calcola? (punto 5)
6. Quali sono gli swap e spread per strumento per forex, oro, indici, crypto? (punto 8)
7. Martingala, grid, tick scalping, HFT e latency arbitrage sono vietati per nome? (punto 9)
8. Restrizioni VPS dettagliate: IP, data center, geolocalizzazione. (punto 10)
9. Conti da 160k: sono disponibili? Quali regole valgono? (punto 12)
10. Durata e limiti della prova gratuita. (punto 13)
11. Reset e riacquisto dopo fallimento. (punto 14)
12. Soglia della regola di coerenza per 1-Step e Instant. (punto 15)
13. Risposta ufficiale sulla differenza fra "dichiarazione in inglese" e versione italiana delle pagine. (generale)
