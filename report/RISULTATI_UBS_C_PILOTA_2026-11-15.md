# UBS C — pilota a 8 passate (15/11/2026): cosa dice e cosa NON dice

**Natura:** prova di meccanica, NON una Fase 2. Un set per famiglia, set V9.0 come consegnati, simboli BCM, anno 2025, Modello 1 (barre M1 → tick generati), deposito 100.000 EUR, una passata per set. Fonte: `ANNO_ORO_GRADINI_UBSCP_20261115_1053.zip` (8 passate, tutte `OK`, nessun input imposto, nessuno stop out, durata 28 s per passata circa). Criteri: `UBS_OTTIMIZZAZIONE_A_C_CRITERI_2026-11-14.md`; elenco: `UBS_C_ELENCO_40_SET_2026-11-15.md`.

## Tabella (dal report di ogni passata)

| Set | Simbolo/TF | Operazioni | Netto EUR | PF | DD equity | Vincenti % | Lotto/rischio nel set |
|---|---|---:|---:|---:|---:|---:|---|
| ORB_DAX_a | D30EUR M15 | 91 | +35,80 | 1,19 | 56,00 (0,06%) | 39,6 | fisso 0,1 (Risk=0) |
| ORB_USTEC_a | NASUSD M15 | 11 | +84,33 | 4,34 | 42,32 (0,04%) | 81,8 | fisso 0,1 |
| ORB_US30_c | U30USD M15 | 23 | -67,36 | 0,73 | 150,66 (0,15%) | 39,1 | fisso 0,1 |
| ORB_US500_d | SPXUSD M15 | 42 | -58,65 | 0,64 | 75,50 (0,08%) | 19,0 | fisso 0,1 |
| CLI_USDJPY_HJP09 | USDJPY D1 | 19 | +34,90 | 1,09 | 174,62 (0,17%) | 63,2 | fisso 0,1 |
| OTH_EURUSD_a | EURUSD D1 | 31 | +59,71 | 1,42 | 72,36 (0,07%) | 71,0 | fisso 0,01 |
| SCALP_USDJPY_H4 | USDJPY H4 | 293 | +54,18 | 1,82 | 5,23 (0,01%) | 64,2 | fisso 0,01 |
| VOL_EURUSD_C10 | EURUSD M15 | 19 | +1.484,83 | 1,90 | 737,31 (0,73%) | 63,2 | **rischio** (Risk=123) |

Qualità storico 98–100% (D1/H4 99%). Barre/tick coerenti con i dati BCM.

## Cosa il pilota stabilisce (fatti)
1. **La meccanica funziona.** I 8 set partono, i simboli BCM sono accettati, nessun KO, nessun input perso. Si può lanciare la corsa grande.
2. **I netti NON sono confrontabili fra set.** Sette set hanno `Risk=0` (lotto fisso 0,1 o 0,01) e il guadagno è piccolissimo per definizione; solo `VOL_EURUSD_C10` dimensiona a rischio (`Risk=123`) e per questo ha +1.485. Il +1.485 non è "meglio": è un lotto più grande. Si confrontano solo misure senza scala: PF, % vincenti, rapporto netto/DD, e (Fase 2 dei criteri) lotto uguale per tutti.
3. **Le operazioni sono troppo poche per giudicare.** La regola di casa (Emendamento A): sotto 150 operazioni per periodo = NON VALUTABILE, non scartato. Delle 8 passate solo `SCALP_USDJPY_H4` (293 in un anno, ~146 per metà anno: al limite) la rispetta. Il PF 4,34 di USTEC è su 11 operazioni: rumore. Nessun set è né promosso né bocciato da questo pilota.
4. **ORB: la finestra oraria NON segue l'ora legale.** Dalle ore di apertura/chiusura nei report: DAX entra alle 09–10 server sia in estate che in inverno; US30/US500/USTEC alle 15–17 server tutto l'anno (set con 09:00–10:30 e 15:30 scritti in ora server). Con il server BCM a GMT+1 fisso (regola di casa) la finestra giusta è DAX 08:00 e USA 14:30 server in estate. **In estate (aprile–ottobre) questi ORB lavorano un'ora dopo l'apertura vera.** I numeri dell'anno intero mescolano mezzo anno nella finestra giusta e mezzo anno in quella sbagliata (con le tre settimane di sfasamento USA/Europa in più). Vanno rifatti per stagione con gli orari dei giorni (`MondayStart`... ) impostati via `-Imposti`.
5. **Stop non validi nel tester.** Su USTEC 1.902 e su DAX 74 modifiche di SL/trailing rifiutate dal tester (`Invalid stops`, error 4756): su USTEC, per 11 operazioni. Il trailing non lavora come nel set di Wim: le distanze (punti) o il livello minimo di stop del simbolo BCM non coincidono con quelli del broker di Wim. Il PF 4,34 e il +84 di USTEC vanno quindi considerati non attendibili finché non si capisce (un set pensato per un altro numero di decimali del simbolo è l'ipotesi, NON verificata).
6. **Nessuna delle 4 ORB è convincente:** 2 positive (DAX PF 1,19; USTEC non attendibile), 2 negative (US30 0,73; US500 0,64). Coerente col prior sfavorevole (Wim: "ORB not recommended") ma con 11–91 operazioni è solo coerente, non una prova.

## Cosa NON sappiamo
- Se i PF di forex (OTH 1,42; VOL 1,90; CLI 1,09) reggono su più anni: un anno e 19–31 operazioni.
- Se lo scalper H4 USDJPY (vincita media 0,64, perdita media 0,57 a 0,01 lotto, 293 operazioni) sopravvive ai costi reali: spread e slippage su USDJPY NON misurati su FTMO/BCM; con vincite così piccole è il punto più fragile. Il Modello 1 non vede lo spread vero.
- Il ritardo di esecuzione è 0 (ExecutionMode=0): nessuno slippage di latenza.
- I dati indici BCM reali esistono solo dal 2024 (tick dal 2024-09): massimo ~2,5 anni; i `_EXT` hanno l'orario USA anomalo (vedi CLAUDE.md). Con un ORB a 1 operazione al giorno al massimo ~125 operazioni per stagione: **la soglia 150 non è raggiungibile per gli ORB sugli indici con i dati reali BCM.** Resterebbero NON VALUTABILI.

## Previsioni dei criteri: aggiornamento
- O-1 (40 set testabili): la meccanica regge; dei 40 mancano da provare i 32 non pilotati.
- O-7 (tempo): 28 s per passata (M15 anno intero, D1 anche meno): 80 passate ≈ 40 minuti di orologio, non 6–12 ore. Misurato su 8 passate, un anno, stesso PC.
- Previsione sugli ORB (al massimo 2 su 12 passano la Fase 2: 75%): resta ma ora con un secondo motivo di non-valutabilità (poche operazioni) oltre al prior.

## Prossimo passo proposto (da confermare da Claudio)
1. **Forex per primo** (dati M1 profondi, 150+ operazioni raggiungibili): i 20 set forex, due periodi P1/P2 pluriennali, **stesso lotto per tutti** (Risk=0, StartLots uguale, dichiarato) così i netti si confrontano; ~40 passate, ~20–40 minuti.
2. **ORB indici**: non lanciare l'anno intero come nel pilota. Se si vogliono provare: per stagione, con gli orari giorno per giorno corretti, e con il limite di non valutabilità dichiarato; priorità bassa.
3. **Capire gli `Invalid stops`** su USTEC/DAX prima di fidarsi di qualunque numero degli indici.
4. Piano A (EA limit sull'oro) resta in attesa delle tre risposte di Claudio.
