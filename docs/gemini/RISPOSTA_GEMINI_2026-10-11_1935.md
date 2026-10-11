# RISPOSTA DI GEMINI -- 11/10/2026 19:35 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (20236 byte, SHA256 83B232D9D29247F5)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_PIANO_PICCOLO_DEMO_2026-10-11.md` (37035 byte, SHA256 1D9BF4473DADD7FA)
- domanda del giorno: Piano conto demo: rispondi SOLO alla Q2 della sez. 4 del PACCHETTO, nel ruolo B del protocollo (avvocato del diavolo); ignora l'indicazione Agente 3 e Agente 4; niente ruoli A, C, D e niente sezione E; una sola procedura di attribuzione e una sola base di confronto; tabella N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo; NON LO SO dove manca un dato.

---

Ecco la risposta alla **Q2** (ruolo B: avvocato del diavolo) relativa al piano di schieramento sul conto demo.

### Ruolo B: Avvocato del diavolo (Q2)

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| 1 | La procedura di attribuzione del DD per sedia deve basarsi sulla somma cumulata dei P/L chiusi (colonna `profit` + `commission` + `swap` dell'export per-trade) filtrata per `magic`. | IPOTESI | PIANO sez. 6 | Confronto tra export per-trade e bilancio totale | 10 min |
| 2 | La base di confronto deve essere la **valuta fissa** (DD promesso % x capitale di riferimento x taglia effettiva), poiché la % sull'equity corrente è contaminata dalle mani. | IPOTESI | PIANO sez. 2, fatto 13 | Calcolo del DD su serie storica P/L chiusi | 15 min |
| 3 | Attesa: se la procedura funziona, il DD della sedia EMA200 deve restare entro la banda [5,73% - 7,83%] (IS/OOS) del capitale di riferimento, indipendentemente dalle mani. | CALCOLO | PIANO sez. 3a | Confronto serie cumulata magic vs soglia | 15 min |
| 4 | Ipotesi alternativa: se le mani contaminano il DD, il valore calcolato in valuta fissa oscillerà in base al saldo (fatto 17), producendo un DD "fittizio" non attribuibile alla sedia. | IPOTESI | PIANO sez. 2, fatto 17 | Correlazione tra P/L mani e saldo | 20 min |
| 5 | Il DD fluttuante (intra-posizione) non è attribuibile con i dati attuali: l'export per-trade registra solo posizioni chiuse. | FATTO | PIANO sez. 2, fatto 14 | Verifica colonne export | 5 min |
| 6 | Contro-esempio: una mano aperta in perdita (non chiusa) riduce l'equity totale, facendo scattare il muro del monitor (sez. 3c) anche se la sedia EMA200 è in profitto. | IPOTESI | PIANO sez. 3c | Simulazione muro su equity | 30 min |

**Risposta alla domanda:**
La procedura proposta è l'attribuzione del DD tramite **somma cumulata dei P/L chiusi per magic** su **base di confronto in valuta fissa**. 
- **Attesa**: Il DD della sedia EMA200 deve mantenersi coerente con il backtest (banda 5,73%-7,83% del capitale di riferimento). 
- **Ipotesi alternativa**: Se il DD calcolato in valuta fissa mostra picchi improvvisi in coincidenza con le operazioni manuali (fatto 10-11), la procedura è contaminata. 
- **Falsificatore**: Una divergenza tra il DD calcolato per magic e il DD dell'equity totale che non si spiega con la somma dei P/L chiusi delle sedie. 
- **Contro-esempio**: La sedia EMA200 calcola il lotto sul saldo corrente (fatto 17). Una mano chiusa in forte perdita (es. -1.462 EUR) riduce il saldo, riducendo automaticamente il rischio in valuta dei segnali successivi della sedia. Il DD calcolato in valuta fissa risulterà "migliore" (più basso) non per merito della sedia, ma per l'effetto del saldo ridotto dalle mani. 
- **Cosa non si può attribuire**: Il DD fluttuante (MAE) durante la vita della posizione, poiché l'export per-trade (fatto 14) non contiene serie temporali di equity o rischio aperto. Servirebbe un log continuo del rischio aperto per magic (ponteggio).

**NON LO SO**: Non è possibile determinare con i dati attuali se il DD fluttuante delle mani senza stop loss (fatto 15) sia già stato incluso nei calcoli di rischio del monitor, poiché il monitor non logga il magic delle posizioni senza stop.
