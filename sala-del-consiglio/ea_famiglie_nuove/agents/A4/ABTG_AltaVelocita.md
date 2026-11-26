# ABTG_AltaVelocita (A4) - scheda
Sorgente: `ABTG_AltaVelocita.mq5` (1.422 righe, v2.00, md5 9ba2d4...). FV = FATTO_VERIFICATO (file:riga), INF = INFERENZA, DV = DA_VERIFICARE.

## Regole (FV)
- Trend following su "ciclo": ciclo H4 -> operativo M5, Williams ctx M15, RSI ctx H1, Supertrend gestione M15 (r.321-330, 135). Una sequenza per lato: ATTESA -> ROTTURA (flip Supertrend M5 + due punte RSI nella direzione, r.946-964) -> RITEST (r.991-1006) -> RIPARTENZA/SEGNALE (Supertrend + CICLO operativo + punte RSI + Williams ctx estremo o uscito da <=10 barre + Williams operativo oltre -50 + RSI ctx + eta' ciclo H4 <= 2 barre + filtro direzionale, r.1009-1046).
- Motore "punte RSI per ciclo" v2 (r.603-781), CICLO = composito di 4 stocastici meno SMA9 (r.535-590); Supertrend ATR10 x3 ricalcolato da zero su 300 barre a ogni barra (r.489-521).
- Stop: estremo del ciclo H4 +-(1+10) punti (r.1076-1077); TP = estremo -/+ 2 x ATR(H4,14) (r.1074); se R/R < 3 lo stop si stringe alla cuspide Supertrend M5 (r.1091-1101); poi stop in [0,8; 4,0] x ATR M5 (r.1117-1120), distanza minima STOPS_LEVEL (r.1124).
- Gestione: uscita a mercato se Supertrend M5 gira contro (r.1162-1166); uscita MA9 x2 + RSI lookback (r.1173-1187); stop a zero (spread) per Williams opposto o Supertrend oltre ingresso (r.1193-1206); trailing sul Supertrend M15 (r.1210-1220). SL/TP veri sul server (r.1131-1132).
- Una posizione per simbolo+magic (`HasPosition` r.1227), nessun averaging/griglia/martingala (un OrderSend per segnale, r.1131-1132). Rischio 1% su BALANCE (r.1249). Magic 771401, commento `ALTAV L/S` (r.188-189); nessun altro EA dei materiali lo usa (grep).

## Controlli R2
| Voce | Esito |
|---|---|
| Barra in formazione | NO per decisioni: gate su nuova barra M5 (r.397-399), tutto letto a indice >= 1 (r.892, 1011-1013); serie TF superiori ricalcolate solo a barra nuova (r.434, 444, 466). CopyBuffer/CopyRates partono da 0 ma si leggono da 1 (r.481, 423); l'indice 0 entra nel ricalcolo Supertrend (r.503) senza influire su indici >= 1 (INF) |
| Orari in input vs ora legale | NO: nessun input orario, nessun filtro sessione, 24h su 5 giorni. Unico orario e' il file news (r.1292, `InpNewsShiftMinutes`): fuso del CSV DV; filtro spento (r.179) |
| Distanze in punti fissi | SI parziale: `InpSLBufferPoints`=10 punti (r.166, 1076, 1212) uguale su ogni simbolo (0,1 su oro, 1 pip su forex a 5 cifre, 1 punto sugli indici: INF); il resto e' scalato su ATR |
| Nuova barra | SI (M5) |
| Stop minimo broker | SI come "nessun trade" se <= STOPS_LEVEL (r.1123-1125), non aggiusta; freeze level non letto; SL a zero e trailing rispettano minDist (r.1202, 1218) |
| Spread | `InpMaxSpread`=0 = nessun limite (r.190, 1275); R/R e rischio calcolati dal prezzo senza spread (r.1067, 1085-1086): lo stop minimo 0,8 ATR M5 e' vulnerabile allo spread |
| Ordine rifiutato | NO retry: `TryEnter` torna true anche se `Buy/Sell` fallisce (r.1140-1141), il setup viene azzerato. Chiusure fallite: riprovano solo alla barra dopo (r.1164) |
| Magic/commento | SI |
| Dati futuri | NO (INF) |
| Giorno della settimana | non usato. Nessuna chiusura venerdi' ne' limite di tenuta: posizioni tenute nel weekend (SL vero ma gap possibile) e nei rollover; swap non gestito |

## Difetti
1. **Falsa i test.** Supertrend ricalcolato su finestra scorrevole di 300 barre con direzione iniziale forzata a +1 (r.502, 503): linea viola e flip dipendono dall'inizio finestra (stato non persistente), quindi lo stesso bar puo' dare livelli diversi in run con partenze diverse o dopo riavvio (INF; da provare con due date di inizio). `iATR` MT5 e' media semplice del TR, non l'RMA dell'originale Pine (DV: il .pine non e' nei materiali).
2. **Falsa i test.** Buffer 10 punti fisso (vedi sopra) e rischio che ignora lo spread con stop da 0,8 ATR M5 (r.1117): su forex a spread alto o notturno il vantaggio, se esiste, e' mangiato; in tester con spread 0 (`_EXT`) e' sovrastimato.
3. **Media.** Ordine rifiutato consuma il segnale (r.1141). Lotto portato al minimo (r.1272); rischio su balance non equity (r.1249).
4. **Media.** `RefreshData` falso salta anche `ManagePosition` (r.405-407): se i dati non sono pronti l'uscita sul flip Supertrend non gira (INF).
5. **Minore.** `InpVerbose=true` di default (r.191): log pesanti in ottimizzazione; `estremo` H4 esclude la barra H4 in corso (r.828-829, `gRatesDir[1]`); il filtro R/R e' quasi vuoto perche' il TP e' a 2 ATR(H4) dall'estremo, molto lontano da un stop M5 (INF); `close<line` in r.1011 e' quasi tautologico a Supertrend ribassista (INF). Nessun tetto operazioni/giorno (r.176) ne' limite perdita giornaliera: rischio prop in giornate laterali con molti stop da 1%.

## Misurabilita'
- Operativo M5: servono M1 (barre M5 realistiche) o tick reali; con stop 0,8-4 ATR M5 l'ordine delle barre e' critico (lezione CPI M5: la simulazione M1 sovrastima rispetto ai tick). Storico minimo ~400 barre H4 per il warm-up (r.200, 468).
- Mercati: forex BCM M1 (10-28 cross, 2013-26), oro FTMO M1 2021-26 (scartare riga 00:00), indici nativi solo 2024-26 (tick reali 2024-07..2026-11). `_EXT` inutilizzabile (spread 0, tickvol 1). Il motore Supertrend(10,3) e' gia' stato misurato su tutti i simboli e TF con 1 sola cella isolata (CLAUDE.md, 21/11; se M5 era tra i TF: DV): il valore aggiunto deve venire dai filtri RSI/Williams/ciclo, forma "motore mediocre + filtro" con 0/5 successi (citata in TurnaroundTuesday r.96-99 e CLAUDE.md "famiglie chiuse").

## Ipotesi (criteri scritti prima)
- **H1 baseline corretta.** Dopo fix (buffer scalato su ATR, equity, retry, Supertrend con warm-up fisso), tick reali 2024-07..2026-11 + M1 2013-26 su EURUSD, GBPUSD, USDJPY, XAUUSD con spread reale. Criterio: PF netto >= 1,2 IS e OOS, >= 300 trade per mercato, DD < 15%, nessun anno < 0,8. Probabilita' 5%.
- **H2 ablazione dei filtri.** Stessa uscita, stessi dati, tre versioni: solo Supertrend flip; + CICLO; + punte RSI/Williams (`InpUseRsiPunte` true/false). Criterio: ogni livello aggiunge >= 0,10 PF fuori campione con n >= 300 e meno trade; altrimenti i filtri si dichiarano rumore. Probabilita' 10%.
- **H3 sessione + spread cap + chiusura venerdi'.** Filtro spread <= 25% dello stop, niente ingressi 22-01 server, flat venerdi' 21 server. Criterio: PF +0,10 e DD -20% rispetto a H1 senza dimezzare i trade; ha senso solo se H1 >= 1,0. Probabilita' 20% condizionata.

## Classe: **B** (correggere prima di misurare). Difetti 1-3 falsano il confronto e si risolvono senza toccare la logica d'ingresso (R5), ma l'EA ha circa 25 input e 8 condizioni in cascata, prior bassa. Regola di arresto scritta prima: se H1 dopo le correzioni da' PF < 1,0 su IS, la famiglia passa a C senza ripescaggi.
