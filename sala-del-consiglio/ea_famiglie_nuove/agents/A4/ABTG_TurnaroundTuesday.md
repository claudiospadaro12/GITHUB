# ABTG_TurnaroundTuesday (A4) - scheda
Sorgente: `ABTG_TurnaroundTuesday.mq5` (919 righe, v1.00, md5 0c0113...). Etichette: FV = FATTO_VERIFICATO (file:riga), INF = INFERENZA, DV = DA_VERIFICARE.

## Regole (FV)
- Una sola idea: lunedi' rosso -> BUY martedi'; lunedi' verde -> SELL (`tradeUp = !isBullish`, r.550-551). Giorno di controllo/operativo `const` (r.302-303). Colore = D1 shift 1 `iOpen/iClose` (r.530-531), letto solo dopo che la barra D1 di oggi esiste (r.490-494) e solo se la precedente e' lunedi' (r.501-503).
- Ingresso: ora server >= `InpEntryHourServer`=8 (r.259, 462), finestra 120 min dalla prima barra utile (r.472-485), un tentativo per giorno di calendario (r.441-442), a mercato al primo tick della barra H1 (r.436-438).
- SL = 0.75 x ATR(D1,14) barra chiusa (r.253, 517-519, 625); TP = 1.5R (r.254, 628); pavimento STOPS_LEVEL su SL e TP (r.623-629). Chiusura forzata a ora server >= 22 (r.431), a ogni tick. Una posizione per simbolo+magic (r.752-763). Rischio 1% su EQUITY con OrderCalcProfit (r.645-654).
- Filtro ATR dell'autore spento (r.269). Nessuna griglia/mediazione/martingala/trailing: confermato (un solo OrderSend, r.718). Magic 774201, commento `ABTG_TT` (r.289-290); 774201 non compare in altri file dei materiali (grep). Frequenza max 1 trade/settimana, mai overnight.

## Controlli R2
| Voce | Esito |
|---|---|
| Barra in formazione per decidere | NO (D1 shift 1, ATR shift 1, r.490, 517, 530); tick-value non usato come prima scelta |
| Orari in input vs ora legale | SI, problema (vedi D1) |
| Distanze in punti fissi | NO per SL/TP (ATR D1); solo pavimento `max(stopslevel,2) punti` (r.623) e deviazione 30 punti (r.389) |
| Nuova barra | SI, su InpTF (r.436-438) |
| Stop minimo broker | SI, su SL e TP (r.623-629); non conta lo spread (SL da ask/bid, r.708-714: se SL=pavimento la distanza dal lato opposto e' < pavimento di uno spread: INF) |
| Spread nel filtro | NO (nessun controllo; ingresso al primo tick delle 08:00) |
| Ordine rifiutato | SI: log retcode (r.721-724), giorno consumato comunque (r.573), niente retry |
| Magic/commento | SI |
| Dati futuri | NO |
| Giorno della settimana su ora server | SI (r.457); opera solo martedi', il lunedi' e' solo lettura: venerdi/lunedi' non a rischio. Settimane con lunedi' festivo escluse e contate (r.501-503) |

## Difetti
1. **Falsa i test / media.** Intestazione r.84-91 e commenti r.89, 259 assumono ora server = IT-1 sempre ("DAX 8 server", "chiusura 23:00 IT = 22"): vale solo in ora legale. CLAUDE.md (aggiornato 04/11) dice: inverno server = ora italiana, DAX apre a 9. Con `InpEntryHourServer=8` d'inverno l'EA entra alle 8 server = 1h prima dell'apertura (se il simbolo ha barre pre-apertura) oppure alla prima barra reale (se non le ha: DV su D30EUR); chiusura 22 server = 22:00 IT d'inverno, 23:00 d'estate: orizzonte diverso tra stagioni. Gravita: falsa i test su anno intero.
2. **Falsa i test.** Indici `_EXT` (NASUSD/SPXUSD, CLAUDE.md): orologio diverso (apertura USA 14:30 anche d'inverno, 13:30 in settimane di scarto), `tickvol`=1, `spread`=0. Entry 8 e' "apertura europea": per Nasdaq/S&P non e' l'ingresso naturale (US apre 14:30) e senza costo il PF sara' gonfiato. Corretto = ora per simbolo + costo fisso in tester. Oro FTMO: la riga 00:00 aggregata falsa la barra D1 (open/high/low) e quindi il colore del lunedi' e l'ATR: va scartata prima (CLAUDE.md).
3. **Falsa i test minore.** Lotto riportato al minimo (r.682): rischio effettivo > 1% con stop larghi/conti piccoli; commento r.289 dice che il file prova pinna 20260816, contraddice r.176 (RISOLTO): incoerenza di documentazione.
4. **Minore.** `ChiudiTutte` a ogni tick dopo le 22 (r.431) anche senza posizioni (costo tester); nessuna chiusura se il terminale era spento alle 22: la posizione resta a mercoledi' fino alle 22 successive (INF, nessuna guardia). Metrica "peggior giornata" ancorata al giorno server (r.418), non al reset della prop (DV).
5. **Minore.** Nessun filtro su gap/festivi USA per Nasdaq (lunedi' festivo USA con CFD aperto: colore lunedi' atipico; DV).

## Misurabilita'
- Mercati: D30EUR (nativo 2024-26 BCM: circa 90-100 martedi', campione piccolo), `NASUSD_EXT`/`SPXUSD_EXT` 2010-26 (circa 800 martedi' ciascuno, ma spread 0 e orologio da diagnosticare), indici FTMO dal 12/2017 (Dow 2019), forex 10-28 cross BCM M1 2005/2013-26 come controllo (la tesi originale e' su azioni/indici, DV). TF operativo H1, D1 per il segnale; storico minimo 14 barre D1 piu' 5.
- Test su barre M1 sufficiente (un trade/settimana, SL largo ATR D1): basso rischio di ordine intra-barra.

## Ipotesi (criteri scritti prima; probabilita' di PASSARE il criterio)
- **H1 motore nudo con correzioni di impostazione.** Entry: D30EUR 8 estate / 9 inverno (o 0 = prima barra); `_EXT` 14:30/15:30 per stagione dal periodo; costo fisso per lato dichiarato prima. Criterio: PF netto >= 1,2 sia IS sia OOS (split cronologico 60/40), >= 100 trade per mercato, t >= 2 sul rendimento medio, nessun anno con PF < 0,8. Probabilita' 10%.
- **H2 placebo giorni.** Stessa regola `colore ieri -> contro oggi` su mercoledi', giovedi', venerdi' (solo diagnostica, nessun EA). Criterio: martedi' supera il migliore dei placebo di almeno 0,15 PF e il rapporto e' stabile IS/OOS; altrimenti l'effetto e' reversal generico non specifico del martedi'. Probabilita' che martedi' sia davvero speciale: 10%.
- **H3 uscita a orario invece di SL/TP.** Solo orario (22 server) con SL di catastrofe 2 ATR D1. Criterio: expectancy per trade >= quella di H1 senza peggiorare DD massimo di oltre 20%. Probabilita' 25% (condizionata a H1 positiva, altrimenti irrilevante).

## Classe: **A** (misurare subito), a condizione che il test usi ora per stagione/simbolo, scarto riga 00:00 oro, costi espliciti su `_EXT`. Le correzioni sono di impostazione, non toccano `tradeUp`. Prior basso (letteratura contraria citata dall'autore stesso r.32-35; reversal giornaliero gia' non trovato in famiglie D1 chiuse); utile al piano prop perche' scorrelato (1 trade/settimana, mai overnight) se sopravvive a H1.
