# Dal setaccio all'acquisto: criteri di scelta degli EA del Market, scritti PRIMA dei numeri (19/10/2026)

Richiesta di Claudio (19/10): fare i test sugli EA del Market scaricati, "scegliere quelli che fanno di piu'", ed e' disposto ad acquistarli. **La spesa e' una sua decisione**: qui si scrive solo COME si sceglie, prima di vedere un solo numero. Non rivisto da agenti.

## Perche' non basta "scegliere quelli che fanno di piu'"
Con N EA provati, quello col profitto piu' alto sul periodo di test e' in parte il piu' fortunato su QUEL periodo: scegliendo il migliore, il risultato dal vivo tende a essere piu' basso di quello misurato (selezione del vincitore). Piu' EA si provano, piu' succede. Quindi: **si passa o non si passa una soglia, non si fa la classifica per profitto**; fra quelli che passano si guarda la robustezza (drawdown piu' basso, mesi positivi piu' uniformi), non il guadagno.

## Fasi
1. **Setaccio** (riga in corso): *opera?* e *dipende dal periodo?* Nessun giudizio di merito (`SETACCIO_MARKET_ATTESE_2026-10-18.md`).
2. **Test a fondo**, solo per gli EA che operano e di cui si conosce il timeframe/simbolo dichiarati dal venditore: **21 mesi (gen 2025 - set 2026)**, tranche mensili E una corsa continua, 5.000 EUR, ticks reali, **input imposti esplicitamente ai valori di default e verificati nel report** (errore del 19/10: gli input salvati dal tester sono stati riusati).
3. **Prova dal vivo su demo** DOPO l'acquisto, prima di qualsiasi reale: almeno 4 settimane [se la licenza del Market si puo' usare su conto demo: NON VERIFICATO, da chiedere/leggere sulla pagina del prodotto].

## Soglie della fase 2 (un EA e' "candidato" solo se le soddisfa TUTTE)
- **S-N**: almeno **150 operazioni** nei 21 mesi (sotto: "NON MISURATO", non si decide).
- **S-M**: **>= 60% dei mesi positivi** E somma dei 21 mesi positiva, costi di tester inclusi.
- **S-H (meta' tempo)**: somma positiva in **entrambe** le meta' cronologiche (gen 2025 - mag 2026 / giu 2026 - set 2026): evita un EA che guadagna solo in una fase.
- **S-DD**: nella corsa continua la perdita massima dal deposito **<= 10%** (il tetto del Guardian di Claudio) e il drawdown mensile massimo **<= 15,2%** (la soglia usata per il pacchetto).
- **S-NOSCALA**: nessuna scala dei lotti: lotto massimo / minimo <= 3 e nessun cesto con piu' di 10 posizioni aperte insieme; **niente martingala, griglia o mediazione** (verificato dai trade, non dal testo del venditore). Se l'EA e' di questo tipo non e' "non buono": e' di un'altra classe di rischio (come l'Arena) e si valuta a parte, con tetti di esposizione.
- **S-COSTO**: il profitto medio per operazione deve essere **>= 3 volte lo spread medio** del tester sull'oro (spread del tester BCM 19-21 punti, da riverificare nel report): sotto, il vantaggio sta dentro il costo.
- **S-STAB** (se l'EA ha un'impronta casuale, come "randomizzazione" del Prop Firm Gold EA): lo stesso giro ripetuto 3 volte, e le soglie valgono sul **peggiore** dei tre.

## Insieme di acquisti
- **S-CORR**: fra gli EA da comprare, correlazione dei risultati giornalieri **<= 0,5** per ogni coppia, e con gli EA oro gia' misurati (Gold Reaper col suo set, ecc.); gli EA oro finora misurati stanno fra 0,42 e 0,60 -> la scorrelazione NON va data per scontata.
- **S-PORT**: il drawdown combinato (somma dei risultati giornalieri come lo strumento `correlazione_pacchetto.py`) **<= 10% del conto su cui girerebbero**; altrimenti si compra meno, non si "confida nel Guardian". La taglia di ogni EA e la cifra spesa sono decisioni di Claudio, non mie.
- **Un acquisto alla volta**, e il secondo solo dopo che il primo ha superato la fase 3.

## Cosa NON si fa
- Non si sceglie un EA perche' ha fatto "di piu'" nel setaccio.
- Non si cambia il periodo di un EA per farlo passare.
- Non si aggiusta una soglia dopo aver visto i numeri.
- Se nessun EA passa: la conclusione e' "nessuno da comprare", e si scrive cosi'.

## Cose NON verificabili qui
Slippage e ritardi dal vivo, feed unico BCM, spread allargato in news, differenze fra la demo del Market e la versione a pagamento, termini di rimborso del Market (da leggere sulla pagina, non da supporre).
