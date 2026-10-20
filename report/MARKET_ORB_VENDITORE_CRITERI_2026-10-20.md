# EA ORB (Opening Range Breakout) dello stesso venditore del Gold Reaper: criteri scritti PRIMA di scaricarlo e misurarlo (20/10/2026)

**Non controllata da agenti.** Claudio scarica la demo dal Market per cercare un EA SCORRELATO da Prop Firm e Gold Reaper. Si applica lo stesso percorso (setaccio -> test a fondo -> S-CORR/S-PORT); spesa e taglie sue.

## Perche' puo' essere scorrelato (ipotesi, da misurare)
Un ORB entra sulla rottura del range dell'apertura di una sessione (orario fisso), gli altri due sono su logiche diverse (Prop Firm, Gold Reaper). Ma se tradano lo stesso simbolo (oro) e le rotture capitano nelle stesse giornate di movimento, la correlazione puo' restare alta: **non si assume, si misura.**

## Da sapere PRIMA del test (Claudio, dalla pagina del Market / pannello input)
Nome esatto dell'EA, simbolo/i dichiarati, timeframe dichiarato, orari di sessione negli input e **in quale ora sono scritti (server, GMT, ora italiana)**. Il server BCM e' un'ora indietro rispetto all'ora italiana: un orario d'apertura sbagliato di un'ora cambia completamente il range.

## Soglie (invariate) e due in piu' specifiche per ORB
- Le solite: S-N >= 150 operazioni, S-M >= 60% mesi positivi e somma > 0, S-H (gen25-mag26 e giu26-set26 entrambe > 0), S-DD (perdita dal deposito <= 10%, DD <= 15,2%), S-NOSCALA (lotto max/min <= 3, <= 10 posizioni), S-COSTO (>= 3 volte lo spread), costo doppio (netto > 0, PF > 1,10).
- **S-CORR** <= 0,50 con Prop Firm e con Gold Reaper (strumento congelato); **S-PORT** tetto <= 10% del conto con Prop Firm + Gold Reaper + ORB.
- **S-ORA (nuova)**: spostando di +1 ora e di -1 ora l'orario di apertura/sessione, il netto della corsa continua resta > 0 e il PF > 1,10 (se l'EA ha l'orario fra gli input; altrimenti [NON TESTABILE]). Serve perche' tester, server e ora italiana sono tre orologi diversi: un EA che funziona solo a un orario esatto e' fragile.
## Previsioni dichiarate ORA
- **O1**: r (giornaliero) ORB / Prop Firm <= 0,30; ORB / Gold Reaper fra 0,20 e 0,50.
- **O2**: meno di 400 operazioni in 21 mesi (circa una al giorno al massimo) e DD mensile < 15,2%.
- **O3**: S-ORA fallisce per almeno una delle due direzioni (ORB sensibile all'orario).
