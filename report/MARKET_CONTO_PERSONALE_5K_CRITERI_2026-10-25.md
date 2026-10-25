# Conto personale da 5.000 EUR, senza guardiano: criteri e previsioni scritti PRIMA dei numeri (25/10/2026)
**Natura: CRITERI. Non controllata da agenti.** Domanda di Claudio (25/10): "se non facessi una prop ma usassi questi EA sul mio conto personale, senza un DD giornaliero da rispettare e senza guardiano, quanti e quali mi brucerebbero il conto e quali sarebbero da avere?" Poi: "Parto con 5.000 euro, rifai la prova". **Acquisti, lotti e taglie sono decisioni di Claudio: qui si misura soltanto.**

## Cosa si fa
Per ciascuno dei **9 EA** UNA corsa continua 01/01/2025-01/10/2026, XAUUSD H1, tick reali (Modello 4), **deposito 5.000 EUR**, leva 1:100 (quella che il tester usa; la leva del broker personale di Claudio: NON VERIFICATA), nessun guardiano. Script `DEEP5K_TESTER_TRANCHE.ps1` (copia di `DEEP80K_TESTER_TRANCHE.ps1` col solo deposito cambiato), `-Tranche 22`.
EA: Rocket Breakout EA, Entry Points Pro Robot, ORB Revolution, Umbra Vault AI EA, Microedge Neural Matrix EA, Vortex Turbo EA, Gold Snap, SomaGold, SixtyNine EA (SixtyNine per ultimo, e' il piu lento).
**Input imposti esplicitamente, per non ereditare gli "ultimi valori usati":** tutti i default, tranne dove l'ultimo giro ha lasciato un valore salvato diverso: Microedge `propGuard=false`, Umbra `EquityGuardEnabled=false` (le due guardie del venditore restano SPENTE: l'ipotesi e' "nessun guardiano"); SomaGold col suo set di funzionamento (`AutoGMT=false`, offset GMT 1 e 1, `MarginCallProtection=false`, senza il quale non opera). Gli altri sei: nessun input imposto, i loro ultimi valori sono i default (ultima corsa del 25/10). Il lettore confronta gli input col setaccio.

## Cosa si misura (nessuna soglia di acquisto)
Per ogni EA, dal report e dal manifest: saldo finale e netto in % del deposito; PF; DD equity dal picco (assoluto e relativo); **stop out** e righe "no money" (ordini rifiutati per margine) dal giornale; saldo realizzato minimo in % del deposito; peggior giorno e peggior mese realizzati in % del saldo di inizio periodo; posizioni aperte insieme; serie di perdite di fila; **quota di ingressi al lotto minimo (0,01)** nei primi tre mesi e in tutto il periodo (per vedere se il pavimento del lotto morde a 5.000); confronto con la stessa corsa a 80.000 (netto %, DD relativo).

## Etichette del lettore (dichiarate ora, NON soglie di merito, NON consigli)
- **BRUCIATO**: almeno uno stop out, oppure saldo realizzato minimo <= 50% del deposito, oppure DD equity relativo >= 50%.
- **SCOSSO**: non BRUCIATO, ma DD equity relativo >= 25%, oppure almeno una riga "no money", oppure piu di 10 posizioni aperte insieme.
- **REGGE**: nessuna delle precedenti.
- In piu', **PERDE** se il netto e' <= 0 (a parte).
Le soglie 50% e 25% sono scelte mie, ordinarie e arbitrarie; servono a ordinare la lettura e le dichiaro prima. Un'etichetta REGGE non vuol dire "sicuro": 21 mesi, un percorso, tester senza slippage, gap, liquidita' reale. Una corsa che esce BRUCIATO a 5.000 ma non a 80.000 dice che il lotto minimo e il margine mordono sul conto piccolo.

## Previsioni dichiarate ORA
- P1: tutte le corse valide (stato OK): 70%.
- P2: nessuno stop out in almeno 7 EA su 9: 60%.
- P3: per almeno 5 EA su 9 il rendimento % a 5.000 e' diverso da quello a 80.000 di piu del 20% in valore relativo: 70%.
- P4: il DD relativo a 5.000 e' piu alto di quello a 80.000 in almeno 6 EA su 9: 55%.
- P5: almeno 3 EA hanno almeno il 30% degli ingressi al lotto minimo nei primi tre mesi (pavimento del lotto che morde): 50%.
- P6: almeno un EA chiuso sopra il deposito a 80.000 chiude sotto il deposito a 5.000: 40%.
- P7: almeno 3 EA con righe "no money": 50%.
- P8: etichetta BRUCIATO per almeno uno degli EA: 40%; Vortex Turbo e SomaGold fra i due peggiori per DD relativo: 65%.

## Cosa NON misura
Slippage, spread in news, gap di weekend, liquidita', margine reale del broker personale, differenze fra demo del Market e versione a pagamento, termini di licenza, qualunque conto reale. Il capitale di Claudio e' 5.000 EUR; il tester usa la leva 1:100.
