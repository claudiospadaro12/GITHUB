# Combinazioni di set con Guardian simulato: criteri e previsioni scritti PRIMA dei numeri (04/11/2026)
Richiesta di Claudio: rifare le analisi anche col Guardian e con varie combinazioni dei set caricati. Non controllata da agenti.

## Dati
Report con deal gia fatti (80.000 EUR, XAUUSD, Modello 1, anni 2013, 2018, 2020, 2025), dagli archivi su `lavoro` e dagli zip caricati: Reaper (D9, DD6, DD9, DD12, DD15, LIVE30, LIVE9, R50A, R50B), Goldbot (PF525, PF105, LOW3), Phantom (PROPCOMBO_D4, PROPFIRM_D9, LOWRISK_D10, MEDIUM_D30, HIGHRISK_D60), Gold Trade Pro (PROPFIRM_R1, LOWRISK_R15, MEDIUM_R3, HIGHRISK_R6 e COMBO 0,5), piu "nessuno" per Goldbot, Phantom e GTP (il Reaper c'e sempre). Combinazioni = una variante per EA.

## Guardian simulato (approssimazione sul realizzato, senza flottante)
Parametri del set FTMO: perdita giornaliera 4,3% (giornata = giorno di calendario del server, base 80.000 fissi), perdita totale 9,3% (dal deposito 80.000). Due modelli:
- **A (ideale)**: quando la perdita realizzata del giorno arriva a -4,3% la giornata si ferma esattamente a -4,3% e gli eventi successivi di quel giorno cadono (EA in pausa fino al giorno dopo).
- **B (a evento)**: la giornata si ferma al valore corrente al deal che supera -4,3% (puo andare oltre, come uno spike veloce che il Guardian non puo anticipare; il Guardian controlla ogni secondo); gli eventi successivi del giorno cadono.
Totale: se il cumulato realizzato dal deposito arriva a -9,3% si ferma tutto (FALLITA).
Limite dichiarato: le posizioni aperte al momento del taglio non sono chiuse al valore flottante ma semplicemente i loro deal successivi del giorno sono scartati; quelli dei giorni dopo restano. E una stima, non una simulazione.

## Misura "prova di 14 giorni" (regole FTMO NON verificate: obiettivo +5% = 4.000, perdita giornaliera 5%, perdita totale 10%)
Per ogni giorno di partenza dell'anno una finestra di 14 giorni di calendario, 80.000 di partenza: PASSA se il cumulato tocca +4.000 senza prima toccare -5% in un giorno (realizzato) o -10% dal deposito; FALLISCE se tocca prima uno dei due limiti; altrimenti SCADE. Si riportano passa / fallisce / scade (%) su tutte le finestre dei 4 anni, per modello A e B.

## Criteri
Per ogni combinazione: tasso di fallimento (modello B) sui 4 anni, tasso di passaggio, peggior giorno e DD per anno. Classifica: prima per fallimento piu basso, poi per passaggio piu alto. Non scelgo "la migliore": riporto la classifica, la posizione del trio attuale (Reaper D9 + Goldbot PF525 + Phantom D4) e dei 4 EA con GTP COMBO, e quanto la classifica dipende dall'anno (nessuna scelta "sull'anno migliore"). Rischio di sovradattamento: 4 anni, un percorso per anno; la miglior combinazione non e una raccomandazione.

## Previsioni (probabilita)
- **K1** Il trio attuale ha fallimento (modello B) > 0 sui 4 anni: 75%.
- **K2** Il modello A riduce il fallimento rispetto al B in almeno meta delle combinazioni: 80%.
- **K3** Esiste almeno una combinazione con fallimento 0 (B) e passaggio >= 40%: 45%.
- **K4** Aggiungere un GTP a una combinazione peggiora il fallimento (B) in piu del 60% delle coppie con/senza GTP: 70%.
- **K5** La combinazione con passaggio piu alto contiene il Reaper D9 o un Reaper DD9: 35% (i set piu aggressivi sul Reaper dominano).
- **K6** Il 2013 e l'anno che determina il fallimento (fallimento > 5% nel 2013 e < 2% negli altri tre anni) per il trio attuale: 60%.
