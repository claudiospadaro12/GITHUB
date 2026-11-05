# Test in coda: filtro "fake out" del Gold Reaper, low contro medium (da fare DOPO i test BTC)

Richiesto da Claudio il 05/11/2026: "testiamola coi nostri anni... dopo che finiscono i test su btc".

## Origine dell'ipotesi (NON verificata)
- dinocon9, #all-gold-eas, 04/07/2026: nei suoi backtest, fake out filter su "low" invece di "medium" dava circa il doppio del profitto con DD relativo quasi identico. Immagini non lette, nessuna conferma di Wim, periodo e broker non noti.
- Contro: Robin (28/07) usa medium con news filter on, test 2020-2026, Max Allowed Total DD 20% (nessun confronto con low).

## Criteri e previsioni FISSATI PRIMA dei risultati
1. Stesso EA, stesso set, stesso conto 80k, stesso tester (Modello 1 OHLC 1 min, BCM), cambia SOLO il parametro del fake out filter (medium contro low; eventualmente anche high/off se esiste nel set).
2. Anni: gli stessi dei test precedenti (long, short, laterale) per avere lo stesso confronto con il trio oro; ogni anno separato. Orari server con la regola GMT+1 fisso del CLAUDE.md (estate/inverno separati dove serve).
3. Metrica principale: equity drawdown assoluto e massimo (prop 80k), poi profitto, PF, numero trade, Guardian sim.
4. Previsioni (da confermare o smentire): (a) low da' piu' trade e piu' profitto lordo; (b) il DD sale, non resta "quasi identico", in almeno un anno laterale; (c) nei long forti la differenza e' piccola. Se invece low migliora profitto E DD in TUTTI gli anni, lo riporto come risultato sorprendente e lo ricontrollo su un secondo periodo prima di proporlo.
5. Limite dichiarato: backtest senza slippage; Wim dice che l'oro soffre slippage sui pendenti e che i fake out sono il motivo del filtro. Un risultato buono nel test non basta per il live.
6. Nessuna modifica ai set live o al VPS. Un'eventuale versione "low" sarebbe un EA/set separato con magic diverso (regola _Ottimizzato), solo se Claudio decide.

## Prima di partire
- Verificare che i test BTC FTMO siano finiti e analizzati.
- Trovare il nome esatto del parametro nel set del Reaper (set prop e combo `*_4GOLD.set`) e controllare i valori ammessi.
- Preparare riga pinnata con il gate controlla_riga.py come per le altre.
