# Webinar Emiliano del 22/10/2026 (serata finale): cosa serve ai nostri test

Fonte: `data/trascrizioni/WEBINAR_EMILIANO_2026-10-22_lezione4.txt` (trascrizione automatica, con errori di sbobinatura). Non controllata da agenti. Le cifre che cita lui sono **sue dichiarazioni, non verificate**.

## 1. Utile per i test (regole operative dette a voce)
- **Nasdaq, strategia delle 15:25**: "candela da 5 minuti delle 15:25, alle 15:30 tiro una riga, metto sotto l'ordine" = candela **PRE** (14:25-14:30 server d'estate). Risolve il dubbio di R277 ("PRE o POST"): **PRE e la sua regola**, POST e la variante nostra. Cella `R277a/b`.
- **Whipsaw**: "e la seconda volta che il Nasdaq apre e fa su e giu e ti prende tutti e due gli ordini". Il caso in cui entrano entrambi i pendenti e quello che il nostro R277 NON replica (il suo "piano B").
- **Passare all'US30**: "siccome questa strategia funziona sul Nasdaq e sull'US30, da domani passate all'US30; in questi due giorni vi avrebbe fatto fare i soldi". **Non e un test: e un'osservazione di due giorni.** Idea di test: stessa regola dei 5 minuti sul Dow (da prevedere e congelare prima).
- **Volatilita**: Nasdaq e US30 i due indici piu volatili, US30 leggermente piu del Nasdaq (da Mataf), il DAX meno. Nasdaq: escursione media circa **1000 punti** giornalieri.
- **Confluenza per entrate "a basso rischio"** (non e un algoritmo nostro): fine della volatilita media + supporto importante su timeframe mensile/settimanale/giornaliero (H4 "non lo guardo") + media 200 giornaliera. Scalping a "pavimento" con molti contratti. Non e codificato e non e testato.

## 2. Da leggere con cautela (le sue metriche)
- **"Profit factor 89", "98,93% di operazioni positive"**, 647 mila euro in un giorno: lui stesso dice che **il drawdown mostrato e FALSO** (conta solo le operazioni chiuse): "sono andato sotto di 220 mila euro per fare 635 mila", ma il report mostra 0,10%. Un profit factor e una percentuale di vincenti del genere con un drawdown flottante cosi grande sono tipici di **un sistema che tiene in perdita e media** (hedging, ordini divisi). Quindi **non sono confrontabili con i nostri criteri** (che misurano il drawdown di equity).
- Ammette perdite pubbliche di **700 mila su 1,3 milioni** e un conto da 200 mila bruciato. Il suo messaggio: prelevare i profitti, non fare interessi composti.

## 3. Marketing
Il resto (circa meta) e la proposta del percorso a pagamento (3 mesi + 12 mesi, "algoritmi di supporto decisionale", coaching) e testimonianze. Nessuna decisione d'acquisto: e di Claudio.

## 4. Prossimi passi possibili (non avviati)
1. Leggere R277 guardando **prima PRE** (a/b), poi POST.
2. Una versione **Dow** della regola dei 5 minuti, con criteri scritti prima.
3. Tenere separato il test del whipsaw (entrambi i pendenti scattano) come variante, se serve.
