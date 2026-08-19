# 👑 CONTROL ROOM — mappatura dello schema a 10 agenti sulla flotta REALE (19/08/2026)

Claudio ha portato in chat uno schema "Sistema Multi-Agente Coordinato" (CEO +
9 specialisti) per EA da prop firm. Verdetto: la struttura esiste GIA' nel
progetto, con agenti reali (leggono file, committano, producono referti) al
posto di voci simulate. Mappatura:

| schema | equivalente reale | note |
|---|---|---|
| 0 CEO/PM | sessione principale (chat) | unico interlocutore, roadmap, QC |
| 1 Web Scouting | cacciatore-strategie + cacciatore-config-prop | dossier agli atti |
| 2 Analista Quant | round + architetto-prop | niente martingala/grid: mai state in casa |
| 3 Risk Manager | cap FIRMATI 18/08: 0,65%/sedia, 3,25% aperto, pausa 4% | verbale FIRME |
| 4 Dev MQL5 | mql5-ea-developer | |
| 5 Architetto Guardiano | ABTG_Guardian v1.11 + PausaGuardian v1.20 | collaudo 3/4 fasi verdi il 19/08 |
| 6 Code Reviewer | verificatore-stringhe + audit di fedelta' | 3 bug GoldenCross trovati cosi' |
| 7 Walk-Forward | walkforward_generico.ps1, IS/OOS, tick reali | Emendamento della finestra |
| 8 Monte Carlo/Stress | Monte Carlo contratti sedie + collaudatore-prop (R55) | |
| 9 Post-Trade | pagella 23:15 + censimento + DIARIO | |

## Le 2 idee ADOTTATE dallo schema
1. **WFE (Walk-Forward Efficiency)** a finestre rotolanti come metrica
   esplicita — da proporre all'architetto per il metro (oggi: IS/OOS secco).
2. **Buffer interni dichiarati** (4,5 su 5 / 8 su 10): confronto da registrare
   nel PIANO_PROP accanto ai nostri firmati.

## La cosa NON adottata
Il formato di dialogo simulato "[AGENTE N]: ..." — i referti veri battono il
teatro, ed e' coerente col PROMPT_DI_INTELLIGENZA_PRECISA (zero fabbricazione).
