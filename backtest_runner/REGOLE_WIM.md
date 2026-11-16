# REGOLE_WIM.md - cosa abbiamo preso dal metodo di Wim, con la fonte, e cosa NON sappiamo

**Natura:** regole di lavoro per la fabbrica di set. Fonte: i file e i set di Wim presenti nei nostri repo/PC (non il suo codice, che non abbiamo mai visto) e il documento di criteri `report/UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI_2026-11-15.md` (sezioni 1-12). Dove sotto c'e scritto "NOSTRA" la regola non e di Wim.

## Le regole usate

| # | Regola | Dove si applica | Origine |
|---|---|---|---|
| R1 | **Lotto fisso per confrontare**, rischio in % solo per il conto vero (oro: 0,1 lotti, "Adjust Lot Size to Variable Values"/ATRDefault nei suoi set) | `InpFixedLot`; SetGenerator scrive il profilo in % ma i test di confronto si fanno anche a lotto fisso | Wim (set oro) |
| R2 | **Perturbazione**: ogni parametro un passo a sinistra e uno a destra; passa se almeno il 70% dei vicini e in profitto e il PF mediano e >= 0,8 x quello base | `BacktestRunner.ps1` (`Crea-Vicini`) | Wim (stress test) |
| R3 | **Dentro-campione / fuori-campione separati** (suo: IS 2013-2023, OOS 2004-2012 e 2024-25) | config: IS 2013-2022, OOS 2023-24/06 (i dati BCM li abbiamo da li) | Wim, finestre ADATTATE |
| R4 | **Ricerca a candele da 1 minuto, controllo a tick reali**: PF tick / PF candele >= 0,7; DD tick <= 1,5 x; operazioni +-10% | `-TICK` nei due motori | Wim (stress test) |
| R5 | **Efficienza walk-forward** (profitto mensile fuori campione / dentro campione) >= 0,5 | `BacktestRunner.ps1` | Wim |
| R6 | **Rischio da prop firm**: tetti di perdita giornaliera e totale dentro l'EA (suoi esempi: PropFirmMaxDailyDD 2,0; MaxAllowedDD 9 / DailyDD 4; MaxRiskMaxDD 2,7) | `InpMaxDailyLossPct`, `InpMaxTotalDDPct`, profili di `SetGenerator.py` | Wim (set PropFirm), valori dei profili NOSTRI |
| R7 | **Struttura degli input** (livelli HL con forza L/R e countback, distanza minima dal livello, offset, scadenza dei pendenti, break-even, trailing, filtri) | `Template_EA_Wim.mq5` | Wim (nomi e struttura nei suoi set); logica scritta da noi |
| R8 | **Fine-tuning solo di un passo** attorno al candidato, mai salti | generatore dei vicini | Wim |
| R9 | **Registro dei tentativi** (quante passate si sono guardate) e soglie piu alte quando le caselle sono molte | `Risultati\tentativi.json` | NOSTRA |

## Cosa Wim NON documenta (quindi non lo fingiamo)
- **Nessun rapporto fisso stop/target.** Nei suoi set varia da strategia a strategia: i nostri 3 profili usano stop 1,5 ATR e target 2R come PUNTO DI PARTENZA da testare, non come regola sua.
- **Wim ottimizza con l'algoritmo genetico** (criterio Custom max con minimi di EP/RF/operazioni; candidati 40% migliori / 30% diversi / resto casuali). Il "no genetici ciechi" di questa fabbrica e una variante NOSTRA: batch logici di set (un parametro alla volta + griglia ortogonale L9, vedi `GeneraSet_Wim.py`), con un numero di passate piccolo e contato.
- **Break & retest: Wim non lo consiglia.** `ENTRY_RETEST` e `ENTRY_LIMIT` del template sono NOSTRI, servono a cercare strategie diverse dalle sue (obiettivo del 15/11), non sono la sua logica.
- Il suo codice sorgente, i valori esatti di ogni set pubblicato, le ore di sessione (nostri set: sempre ORA SERVER, vedi CLAUDE.md: BCM GMT+1 fisso, l'ora legale sposta di 1 ora).

## Limiti che restano veri
- Un set che supera il filtro e "validato su storico": **non vuol dire pronto per un conto.** Serve il forward in demo.
- Il filtro "PF > 1,5 dentro-campione" e la soglia dell'obiettivo di Claudio: a molte prove, qualche set la supera per caso (R9).
- Il tetto totale dentro l'EA (es. 4%) ferma l'EA per sempre: un DD "sotto il 4%" puo essere ottenuto fermandosi presto. Per questo il motore chiede anche profitto > 0, operazioni minime e il fuori campione.
