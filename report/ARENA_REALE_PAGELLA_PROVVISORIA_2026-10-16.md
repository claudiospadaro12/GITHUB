# Arena sul REALE 10105439 -- pagella provvisoria del 16/10/2026 (dal cronistorico delle 16:33)

Fonte: `risultati_archivio/ARENA_REALE_20261016/cronistorico_reale_10105439_2026-10-16_1633.xlsx` (Posizioni, Ordini, Affari, Risultati). Attacco dichiarato da Claudio: 14:50 ora italiana = 13:50 server (la prima operazione e' alle 13:51:09 server). Lotto base 0,01 (visto nel report). **Provvisoria**: mancano l'ora dello stacco e la soglia del Guardian.

## Numeri [LETTO dal report]
- Saldo di partenza 5.051,32 (dopo la prima commissione) -> **4.661,70**; netto **-389,64 EUR**; linea di credito (bonus) 2.500; equity finale 7.161,70, conto piatto (margine 0, flottante 0).
- 95 posizioni: 56 vincenti (58,9%), PF 0,21; profitto lordo 102,12, perdita lorda -491,76; DD di saldo 463,67 (9,05%); 29 perdite di fila (-463,29); commissioni -4,94 (0,04 EUR a 0,01 lotti per giro).
- Commenti: 26 CF B + 9 CF S + 18 FinlabX [F] (scalp) e 26 FinlabX [R] (recupero, cesti CID).

## Ricostruzione [DERIVATO]
- Dalle 13:51 alle 14:20 circa: ~40 piccoli scalp [F] a 0,01-0,03 lotti, quasi tutti +0,8 EUR, piu' un recupero [R] con piccole vincite/perdite: parziale **+74,57 EUR** (66 posizioni, commissioni comprese).
- **Dalle 14:21:56 il cesto di vendite [R]** (oro in salita da 4.155 a 4.193): 10 vendite a 0,01-0,05 lotti, **0,30 lotti in tutto in 31 minuti**, prezzo medio d'ingresso 4.175,73; carico massimo 0,36 lotti (0,30 sell + 0,06 buy) alle 14:55:33.
- **15:01:05-07 il Guardian chiude tutto**: le 10 vendite escono a 4.192,8 medi per **-454,71 EUR** (-32,7 ... -58,5 a posizione). Dopo il Guardian: 19 aperture da 0,01 chiuse nel giro di uno-due secondi (15:01:39-15:32:17), **-8,42 EUR** (media 0,44 EUR per giro) = l'Arena che riapre e il Guardian che richiude [INFERITO dal fatto che durano 1-2 secondi e vanno tutte in perdita]. Dopo le 15:32 nessuna operazione fino alle 16:33.
- Controfattuale (stesse 10 vendite, prezzo 4.196,4 alle 15:32): flottante circa -536 invece di -455 realizzati: **il Guardian ha risparmiato circa 80 EUR a quell'ora**, non di piu', se non si guarda cosa e' successo dopo [DERIVATO: non include ingressi di recupero che l'EA avrebbe aggiunto, ne' un eventuale rientro dell'oro].
- Costo reale per giro di 1-2 secondi su 0,01 lotti: 0,2-1,0 EUR (media 0,44 con commissione): piu' dello spread da solo (19-21 punti = 0,17 EUR) perche' include slippage e ritardo in un momento di prezzo veloce [DERIVATO, un'ora di mercato mosso].

## Cosa conferma delle nostre misure
La coda dell'Arena non e' un'ipotesi: un'ora e mezza dopo l'attacco il recupero era a 0,30 lotti contro un rialzo di 37 USD, e il Guardian ha tagliato a -455. Coerente con tester e demo (nessuna regola separa le code dai profitti). Il bonus non ha assorbito niente: la perdita e' uscita dal saldo (5.051 -> 4.662).

## Aperto
Soglia del Guardian: CORREZIONE del 16/10 sera -- non e' 6%: il codice (ABTG_Guardian.mq5 v1.14) misura la perdita del giorno come equity a inizio giornata meno equity corrente (-455 sulle vendite, ma +75 di guadagni gia' incassati oggi: circa -380 di giornata) contro InpDailyLossPct x gStart; 5,0% (default) x 7.551 = circa 378: **e' il default del 5%** [DERIVATO, da confermare dal pannello del Guardian: gStart e soglie]; ora dello stacco dell'Arena; se il Guardian e' ancora vivo; commissione BCM vera; termini del bonus.
