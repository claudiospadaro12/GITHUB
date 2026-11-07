# Forex, giri B (tick reali) e C (orari) — CRITERI e PREVISIONI (07/11/2026, scritti PRIMA dei numeri)

**Natura: CRITERI, non ancora lanciati.** Seguito di `CRITERI_FOREX_TESTATO_BENE_2026-11-07.md` (piano a giri A-E). Il giro A (fuori campione, 70 passate) e pronto per il lancio; B e C partono dopo che A e finito, con un'altra riga e un altro pin. Solo tester, deposito 4.000 EUR, terminale BCM del PC di backtest; lotti e taglie le decide Claudio.

---
## GIRO B — Modello 4 (tick reali) contro Modello 1 (barre da 1 minuto)

### Perche
Tutti i test forex sono in Modello 1. Dall'oro: Andrew Soma dice che le barre rendono bene al 95% sull'oro e all'80% sugli indici; langesi dice che i tick reali tolgono ~40% di profitto. Per i forex a griglia e per gli scalper con SL/TP stretti la differenza puo essere grande. Senza questo confronto, i 12 anni in OHLC del giro A sono ottimisti per ipotesi.

### Vincolo dichiarato
I tick reali del tester BCM **partono dal 10/07/2024** (verificato sull'oro il 31/10: lo script scarta una finestra che inizia prima). Lo script del tester accetta solo date di inizio a inizio anno. Quindi: **solo il 2025 completo** (01/01/2025-01/01/2026), che ha gia il riferimento in Modello 1 a 4k. Il secondo semestre 2024 richiederebbe una nuova versione dello script (-Inizio) con nuovo pin: NON in questo giro.
Non e noto se i tick reali BCM esistano per tutti i simboli dei set: se per un set il report dice qualita tick < 95% o il simbolo non ha tick, la passata e **esclusa e dichiarata**, non sostituita.

### Passate (4)
2025, deposito 4.000, Modello 4, input del set invariati. Si sceglie un set per EA, quello con piu sensibilita attesa ai tick:
| Set | Perche | Riferimento Modello 1 a 4k, anno 2025 |
|---|---|---|
| Luna `4DD` | scalper notturno con SL/TP stretti: il piu sensibile a spread e tick | netto +1.130, DD 2% |
| Apex `ConservativeGrid` | griglia con pendenti: riempimenti e chiusure dipendono dal percorso del prezzo | netto +913, DD 22% |
| Stability Pro `low risk` | griglia M5 | netto +562, DD 19% |
| Daytrade Pro `Max9DD lowrisk` | timeframe D1: controllo, dovrebbe essere poco sensibile | netto +131, DD 6% |
Ordine di lancio: dalla piu breve alla piu lunga (D1, poi Stability, Apex, Luna). Tempo: NON misurato; Luna a 15 coppie in M5 a tick reali puo essere la piu lunga (ore); timeout per passata 600 minuti.

### Validita di una passata
Report presente, deposito 4.000, Modello 4, qualita dei tick >= 95%, finestra 2025.01.01-2026.01.01, input uguali al set (confronto automatico), almeno 1 operazione.

### Misure
Netto, rendimento %, PF, operazioni, % di vincenti, DD equity relativa e assoluta, peggior giorno realizzato, stop out, righe "no money", rapporto netto/DD, e la differenza con il riferimento in Modello 1 (stesso set, stesso anno).

### Regole di lettura (fissate ora)
- **ROBUSTO ai tick**: netto a tick entro +-30% del netto a barre **e** DD relativa entro +-5 punti percentuali **e** stesso segno del netto.
- **SENSIBILE**: netto a tick diverso di piu del 30% **oppure** DD relativa diversa di piu di 5 punti. Se peggiore: "i test lunghi a barre di questo EA sono ottimisti" e il giro A va riletto con un fattore di correzione dichiarato.
- **ROVESCIATO**: il netto cambia segno, oppure DD relativa a tick > 50%, o stop out. Il set non passa il cancello "TESTATO BENE" finche non e rifatto con altri anni a tick (non possibili prima del 07/2024).
- Un solo anno e un solo percorso: B non promuove niente da solo, serve solo a dire quanto fidarsi di A.

### Previsioni dichiarate ORA (non misurate)
- **B1** Daytrade Pro `Max9`: ROBUSTO: 75% (D1, pochi ordini; ma netto di +131 e piccolo e il +-30% e 40 EUR: puo oscillare anche solo per lo spread: 40% che il netto cambi di piu del 30%).
- **B2** Luna `4DD`: netto a tick **minore** del netto a barre: 80%; SENSIBILE (>30% o DD +5 pp): 65%; ROVESCIATO: 15%.
- **B3** Apex `Conservative`: DD a tick maggiore o uguale a quella a barre: 65%; SENSIBILE: 60%; ROVESCIATO (DD > 50% o netto < 0): 15%.
- **B4** Stability `low`: SENSIBILE: 55%; ROVESCIATO: 15%.
- **B5** Almeno uno dei 4 set e SENSIBILE o ROVESCIATO: 85%. Tutti e 4 ROBUSTI: 5%.
- **B6** Per i 3 set non D1, il netto a tick e minore di quello a barre in almeno 2 su 3: 75%.
- **B7** Almeno una passata esclusa per dati tick mancanti o qualita < 95%: 35%.
- **B8** Il numero di operazioni cambia di piu del 10% fra tick e barre in almeno uno dei 4: 70% (le griglie con pendenti riempiono diversamente).

---
## GIRO C — Orari: sensibilita al `GMT_Offset` (Luna 4DD, Apex Conservative)

### Perche
Il server BCM e GMT+1 **fisso** (CLAUDE.md). Luna ha una finestra di default 23:00-01:00 "GMT+2 con ora legale" (Wim: server ICMarkets = 21-23 GMT); Apex ha `GMT_Offset` e `AutoGMT=1` nel set. Nel tester `AutoGMT` non funziona (errore 4014): nei test del 4k e del giro A si usa `AutoGMT=false` e offset invernale ed estivo **1/1**, cioe la convenzione giusta per BCM. NON VERIFICATO: (1) quanto cambiano i risultati se l'offset fosse sbagliato di un'ora, (2) cosa farebbe l'EA in live con `AutoGMT=true` su un server GMT+1 fisso, (3) se l'offset cambia davvero le ore di ingresso (potrebbe essere inattivo in un EA).

### Passate (12)
Luna `4DD` e Apex `ConservativeGrid`, anni **2022 e 2025** (hanno gia il riferimento 1/1 a 4k in Modello 1), con 3 varianti (le altre cose uguali, Modello 1, 4.000 EUR):
| Variante | `AutoGMT` | `GMT_Offset_Winter` / `Summer` | Cosa rappresenta |
|---|---|---|---|
| **V0** (riferimento, gia fatta) | false | 1 / 1 | BCM vero: GMT+1 fisso |
| **V1** | false | 0 / 0 | server creduto un'ora indietro: finestra -1 h |
| **V2** | false | 2 / 2 | server creduto un'ora avanti: finestra +1 h |
| **V3** | false | 2 / 3 | impostazione tipica ICMarkets (Wim), ereditata se si lascia il set cosi: +1 h d'inverno, +2 h d'estate |
Passate nuove: 2 EA x 2 anni x 3 varianti = **12**. `AutoGMT=true` NON e testabile nel tester: resta un controllo da fare in demo/live leggendo il Journal (offset calcolato dall'EA). Dichiarato.

### Validita di una passata
Stato OK, deposito 4.000, input del report uguali al set **salvo i tre parametri di orario** (e ogni altro input diverso e un difetto della passata), almeno 1 operazione. Se in un EA le quattro varianti danno **numeri identici**, il parametro e INATTIVO in quell'EA nel tester e si scrive cosi (non e un successo).

### Misure
Netto, DD relativa, operazioni, PF per variante, e dai deal l'**istogramma dell'ora di ingresso in ora server** (24 caselle) per Luna e Apex, separando i mesi di ora legale italiana da quelli di ora solare.

### Regole di lettura (fissate ora)
- **ORARIO CRITICO**: spostando di un'ora (V1 o V2) il netto cambia di piu del 30% **o** cambia segno **o** la DD relativa cambia di piu di 5 punti in almeno uno dei 2 anni. Conseguenza: nella checklist del live il valore dell'offset (e di `AutoGMT`) va verificato a mano al cambio dell'ora, e si aggiunge un controllo nel `CONTROLLO_PRELIMINARE`.
- **ORARIO TOLLERANTE**: V1 e V2 entro +-30% del netto e +-5 punti di DD in entrambi gli anni.
- **INATTIVO**: nessuna differenza tra le varianti.
- **V3** (default ICMarkets) e il caso piu probabile di errore dell'utente: se e peggiore di V0 di piu del 30% di netto in un anno, si scrive "attenzione: non lasciare l'offset del set".

### Previsioni dichiarate ORA (non misurate)
- **C1** Luna: l'ora di ingresso mediana in ora server si sposta di circa **+1 h** da V1 a V0 e da V0 a V2 (offset piu alto = finestra piu tardi sul server): 70%. Nessuna differenza fra le varianti (INATTIVO): 10%.
- **C2** Con V0 (offset 1/1) le entrate di Luna cadono per la maggior parte (>= 60%) fra le 22:00 e le 00:59 ora server, in ogni stagione: 55% (se l'EA converte in GMT; se applica l'ora del server cosi com'e, cadono fra 23:00 e 00:59).
- **C3** Luna `4DD`: ORARIO CRITICO: 60%; TOLLERANTE: 30%; INATTIVO: 10%.
- **C4** Apex `Conservative`: ORARIO TOLLERANTE: 55%; CRITICO: 30%; INATTIVO: 15% (una griglia e meno legata alla finestra ma ha filtro news e cancellazione dei pendenti alle 23).
- **C5** V3 e peggiore di V0 di piu del 30% di netto in almeno una delle 4 coppie EA/anno: 55%.
- **C6** V1 o V2 migliora il netto rispetto a V0 in almeno una delle 8 coppie EA/anno/variante (V1, V2): 70% (con soli 2 anni il caso fa miglioramenti: non e una scoperta, non si adotta una variante "migliore").
- **C7** In nessun caso la variante ottima e scelta per il live in base a questo giro: il live resta 1/1 (BCM) a meno di una verifica diversa del Journal.

---
## Limiti comuni
- Un percorso per anno; pochi anni (B: uno; C: due): servono a misurare una **sensibilita**, non a promuovere un set.
- Il tester non simula `AutoGMT`; il Journal in demo e la prova che manca.
- Commissioni e slippage FTMO non sono nel tester (giro E).
- Il parametro "max DD a 0,01 lotti" resta quello del venditore.
- Nessun giudizio su acquisto, lotto o taglia e nessuna modifica a live, VPS o reale.
