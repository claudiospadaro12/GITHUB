# EA CPI M5: bersaglio = ampiezza media delle candele CPI degli ultimi 5 anni (idea di Claudio), criteri scritti PRIMA dei numeri (25/11/2026)

**Idea (25/11):** "si possono fare bei profitti sulla candela di apertura che spara forte; misurare la media dell'ampiezza delle candele CPI negli ultimi 5 anni; la media e' la distanza della chiusura dell'operazione".

## Passo 0: fedelta' della simulazione (prima di qualsiasi variante)
La simulazione M1 (Fase 1) dava +2-4 USD/oz nel 2024-26, il tester a tick reali -0,15 (27 eventi, `CPI_M5_T1_RISULTATI`). Si rifa' la simulazione M1 **identica all'EA** (livelli = max/min della M5 [T-10, T-5) +/- 1 USD, ordini attivi da T-5 min, SL sul livello opposto, OCO, uscita all'ultimo minuto della M5) e la si confronta **evento per evento** con i 27 esiti reali del tester (stessa giornata). Si riportano scarto medio, mediano e correlazione. Se la correlazione e' < 0,5 la simulazione M1 non e' affidabile per valutare varianti e si passa direttamente al tester (EA con bersaglio, vedi sotto).
**Costo di esecuzione calibrato:** scarto medio (M1 - tester) per evento = penalita' in USD/oz applicata come stress a tutte le varianti.

## Varianti (decise ora; stesse per tutti gli eventi)
- **Ampiezza di riferimento** = media (primaria) e mediana (sensibilita') del range High-Low della candela M5 CPI, calcolata **solo sugli eventi dei 5 anni precedenti** (nessun look-ahead; servono >= 24 eventi, quindi si valuta dal 2018).
- **V0** base: nessun bersaglio, uscita all'ultimo minuto (EA attuale).
- **V1** bersaglio = 1,0 x ampiezza media dalla fine dell'ordine (entry), poi uscita all'ultimo minuto se non raggiunto. **V2** = 0,5 x media. **V3** = 1,0 x mediana.
- Stress di esecuzione: penalita' per operazione 0 e quella calibrata al passo 0.

## Criteri
- Periodi: 2018-2022 (sviluppo, nessuna ottimizzazione) e **2023-2026 (hold-out, aperto una volta)**. Una variante e' "promettente" se, con la penalita' calibrata, media per evento > +0,5 USD/oz in entrambi i periodi, mediana >= 0 in entrambi e PF >= 1,3 nel 2023-2026. Con circa 8 eventi l'anno il campione e' piccolo: un risultato positivo resta da confermare nel tester a tick reali (EA con input bersaglio) e non e' una prova.
- Misura accessoria (descrittiva): ampiezza media e mediana della candela CPI per anno e 5 anni mobili; quota di eventi in cui il range supera la media.

## Previsione (scritta ora)
Passo 0: correlazione M1/tester 0,3-0,7, scarto medio circa +2/+3 USD/oz (l'M1 e' ottimista). La media dell'ampiezza (circa 10 USD) e' pilotata da pochi eventi enormi e supera la mediana (circa 6): un bersaglio alla media viene raggiunto in meno del 35% dei casi, quindi V1 riduce poco le perdite e taglia le vincite grandi. Previsione: nessuna variante e' promettente con la penalita' calibrata; probabilita' di una promettente: 15%.

## Aggiunta (25/11, DOPO i risultati del bersaglio, scritta PRIMA di calcolare la famiglia M)
Risultati visti: (1) la simulazione M1 fedele all'EA riproduce il tester (27 eventi, correlazione 0,89, scarto mediano 0,14, scarto medio 2,63 USD/oz concentrato in 5 eventi con esecuzione molto peggiore); (2) con la penalita' calibrata **nessuna variante del bersaglio e' promettente**: PF 0,02-0,75 (V0 base 0,62 e 0,75); il bersaglio taglia le vincite grandi che fanno tutto il profitto (+65 USD/oz del 14/07/2026); (3) l'ampiezza della candela CPI non e' stazionaria: in USD 3-5 (2013-20), 10-16 (2021-25), 31 (2026); in % del prezzo 0,2-0,4% fino al 2020 e 0,46-0,79% dal 2021; la correlazione con il prezzo e' 0,73.
**Famiglia M (momentum dopo il primo minuto), fissata ora:** non piu' ordini stop prima della notizia (nessuna posizione in whipsaw e nessuno stop eseguito dentro lo spike), ma ingresso **a mercato all'apertura del secondo minuto** nella direzione del primo, **solo se il primo minuto "spara forte"**.
- Ampiezza di riferimento A = media % del range M5 CPI degli ultimi 5 anni (solo eventi precedenti, >= 24 eventi) x prezzo (normalizzata, come da (3)).
- Condizioni: range del primo minuto R1 >= f x A, con **f = 0,25 (M1) e f = 0,5 (M2)**, e corpo del primo minuto >= 50% di R1 (direzione chiara). Ingresso al secondo minuto con spread = max(spread M1, 0,50 USD); SL sull'estremo opposto del primo minuto; uscita all'ultimo minuto della M5. **M3:** come M2 con bersaglio 1,0 x A dall'ingresso.
- Stress di esecuzione: penalita' 0 e 1,0 USD/oz per operazione (slippage di un ordine a mercato dopo 60 secondi; ipotesi, non misurata).
- Periodi: 2018-2022 e **2023-2026 (hold-out, una volta)**. "Promettente" se con penalita' 1,0: media > +0,5 USD/oz in entrambi, mediana >= 0 in entrambi, PF >= 1,3 nel 2023-2026, e almeno 20 operazioni per periodo. Anche allora: da confermare nel tester a tick reali (EA con modo momentum), non una prova.
- **Previsione (scritta ora):** il primo minuto contiene gran parte del movimento e dopo c'e' spesso ritracciamento: media dopo il primo minuto fra -1 e +1 USD/oz, nessuna cella promettente; probabilita' di una promettente 20%.
