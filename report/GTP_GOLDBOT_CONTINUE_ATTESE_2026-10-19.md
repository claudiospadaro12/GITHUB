# Gold Trade Pro (D1) e Goldbot One (H1): corse CONTINUE 21 mesi -- previsioni scritte PRIMA dei numeri (19/10/2026)

**Non controllata da agenti.** Finora i due EA hanno solo 21 tranche mensili indipendenti (ognuna da 5.000): `CLASSIFICA_4_EA_GOLD_REAPER_2026-10-19.md` dice che manca la corsa continua (perdita massima dal deposito, effetto dello stato interno). Qui: UNA corsa continua 01/01/2025 - 01/10/2026, deposito 5.000, ticks reali, leva 1:100, **input NON imposti** (restano quelli salvati dal tester: da CONFRONTARE nel report con le tranche mensili). Periodi D1/H1 sono ipotesi non confermate dal venditore (invariati).

## Soglie (invariate, quelle del test a fondo adattate alla continua)
- **S-N**: >= 150 operazioni. **S-M**: netto > 0 e >= 60% dei mesi di calendario positivi (dai deal chiusi). **S-H**: somma > 0 in gen25-mag26 e in giu26-set26.
- **S-DD**: perdita massima dal deposito <= 10% e DD di equity dal picco <= 15,2%.
- **S-NOSCALA**: lotto max/min <= 3 e <= 10 posizioni contemporanee (conteggio con le uscite prima delle entrate nello stesso secondo). **S-COSTO**: media per operazione >= 3 volte il costo di spread (circa 0,18 EUR per 0,01 lotto).

## Previsioni dichiarate ORA
- **R1** (lotto fisso => stato interno irrilevante): il netto della continua sta **entro +/-25% della somma delle 21 tranche** (Gold Trade Pro +2.554 => +1.915..+3.192; Goldbot One +1.300 => +975..+1.625). Contrasto: il Gold Reaper (lotto variabile) in continua ha reso meta' delle tranche.
- **R2** (operazioni): entro +/-20% di quelle delle tranche (GTP 473 => 378..568; Goldbot 448 => 358..538).
- **R3** (DD): perdita massima dal deposito **<= 10%** e DD equity dal picco **<= 15,2%** per entrambi (stima: GTP 8-13%, Goldbot 5-9%).
- **R4** (mesi positivi): >= 60% in entrambi (nelle tranche 76%).
- **R5** (S-NOSCALA): Gold Trade Pro 10 posizioni (limite esatto, puo' sforare di 1-2 in continua), Goldbot One <= 8.
- **R6**: tutte le altre soglie passano come nelle tranche. Se R1 o R3 falliscono, la fascia 1 di Gold Trade Pro / Goldbot One cade e lo scrivo.
- Nota di metodo: nel vecchio giro mensile del Gold Trade Pro le 21 tranche erano marcate KO dal mio lettore per l'etichetta `Daily` contro `D1`: nella nuova versione dello script il lettore accetta `Daily`.
