# Test a 80.000 EUR: Prop Firm Gold EA + Smart Gold Hunter -- cosa si misura e previsioni scritte PRIMA dei numeri (19/10/2026)

**Non controllata da agenti.** Domanda di Claudio: "con un conto da 80K cosa genera?" (`COMBINAZIONE_A_PROPFIRM_SGH_80K_2026-10-19.md` ha solo l'aritmetica lineare x16, con la dichiarazione che NON si sa come i due EA scelgono il lotto). Qui si misura.

## Cosa si fa
Per ciascun EA **una corsa CONTINUA** 01/01/2025 - 01/10/2026 (XAUUSD H1, ticks reali Modello 4, leva 1:100, input NON imposti = quelli salvati dal tester, da CONFRONTARE nel report con la corsa a 5.000), con **deposito 80.000 EUR** invece di 5.000. Stesso script del test a fondo, cambia solo il deposito (e il nome delle cartelle: `DEEP80K_*`). Niente tranche mensili.

## Previsioni dichiarate ORA
- **Q1 (lotto)**: almeno uno dei due EA usa a 80.000 un lotto **piu' grande di 0,01** (il lotto scala col saldo o con la modalita' base). Fiducia bassa (circa 60%): le righe `InpRiskType=0`, `InpLots=0.0` del Prop Firm non dicono cosa fa; nella corsa a 5.000 ha messo 0,02 in 4 operazioni su 673. **Se il lotto resta 0,01 in entrambi**, i due EA NON scalano da soli e il profitto resta quello a 5.000 (circa +1.600 / +276 EUR, cioe' circa +2,3% di 80.000): lo scrivo cosi'.
- **Q2 (se il lotto scala)**: il rendimento percentuale sul deposito resta nell'intorno di quello a 5.000: Prop Firm continua **+22% .. +41%** dell'80K (a 5.000: +32%), Smart Gold Hunter **+3% .. +8%** (a 5.000: +5,5%). Fuori da queste bande la scala NON e' lineare.
- **Q3 (drawdown)**: DD di equity dal picco del Prop Firm **<= 15,2%** e perdita massima dal deposito **<= 10%** (le soglie S-DD, invariate); stima: 6-10%.
- **Q4**: nessuno stop-out e nessun "no money" in nessuna delle due corse.
- **Q5**: numero di operazioni **uguale entro +/-10%** a quello a 5.000 (Prop Firm 673, Smart Gold Hunter 237). Se differisce di piu', l'EA cambia comportamento con la taglia.
- **Q6 (portafoglio A a 80K)**: sommando i due risultati giornalieri (calcolo mio, NON lo strumento congelato che richiede il deposito 5.000), il DD di portafoglio resta **<= 10% di 80.000** (pavimento e tetto). Se il tetto (somma dei DD dei due) supera il 10%, S-PORT non passa a quella scala.
- **Q7 (costo)**: il profitto medio per operazione resta >= 3 volte lo spread (S-COSTO): a lotto piu' grande lo spread in euro cresce in proporzione e la soglia scala uguale.

## Cosa NON misura
Slippage e requote su lotti piu' grandi (il tester non ne ha), margine reale del conto (oro nel tester ~8.580 EUR/lotto contro 1.784 sul reale), regole di una eventuale prop da 80K (perdita giornaliera/totale: non le conosco), qualunque prova dal vivo. La taglia da usare sul conto vero e' una decisione di Claudio.
