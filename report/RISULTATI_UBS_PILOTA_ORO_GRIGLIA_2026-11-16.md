# Pilota oro: risultati della griglia da 625 passaggi (16/11/2026): un altopiano piatto, e un dato da verificare prima di tutto

**Fonte:** `UBS_PILOTA_ORO_dati/G_ORO_griglia_625_ReportOptimizer_2026-11-16.xml` (esportato da Claudio dal MT5 portable; intestazione: `Ultimate_Breakout_EA_WSC_V9.5 XAUUSD,Daily 2013.01.01-2022.12.31`, BCMMarkets-Server, 100.000 EUR, creato alle 06:45 ora italiana del 16/11). Criteri e previsioni scritti prima: `UBS_PILOTA_ORO_OTTIMIZZAZIONE_CRITERI_2026-11-15.md` (sezioni 4-13). Analisi: `UBS_PILOTA_ORO_dati/analisi_oro.py`. Avvio 23:09 del 15/11, quindi **durata massima 7 h 36 min** (MT5 stimava 8 h 12 min). **Nessun uso di OOS, tick o hold-out in questo passo.**

## Cosa c'e nel file
- **625 passaggi su 625, tutti diversi** (5 x 5 x 5 x 5), tutti con valori nei range scritti (MinDist 350-750, Scadenza 96-480, Stop 300-900, Limit 900-2500). Colonne: Result (Custom), Profit, Expected Payoff, PF, Recovery factor, Sharpe, Equity DD %, Trades.
- **C0 (550 / 480 / 600 / 1700) = passaggio 322**: profitto +1.323,40 EUR, 286 operazioni, PF 1,65, recovery 6,53, DD equity 0,20%.

## Il risultato: un altopiano piatto
| | minimo | mediana | massimo |
|---|---|---|---|
| Profitto (EUR, 0,1 lotti, 10 anni) | 865,62 | 1.232 | 1.449 |
| Profit factor | 1,42 | 1,60 | 1,71 |
| Operazioni | 267 | 284 | 294 |
| DD equity % | 0,19 | 0,21 | 0,25 |
| Profitto / DD (Calmar a 10 anni) | 3,7 | 5,8 | 7,3 |
- **Tutti i 625 passaggi sono positivi e superano ogni filtro** (PF >= 1,30, operazioni >= 150, recovery >= 1,5): **625 su 625 passano la selezione grezza e 625 su 625 sono "centri di zona stabile"**. La regola della sezione 5 non discrimina: non c'e un punto isolato da scartare perche TUTTO e uguale. Solo 400 profili (profitto, operazioni) distinti su 625.
- **Il miglior passaggio per Calmar (365: MinDist 350, Scadenza 384, Stop 900, Limit 1700) vale 7,30 contro 6,61 di C0 (+10,4%)**: profitto +1.426 contro +1.323 (+7,8%), PF 1,69 contro 1,65. **C0 e solo 99-esimo su 625 per Calmar.** Differenze di questo ordine sono dentro il rumore di scelta: con 625 tentativi e naturale che il massimo superi il centro del 10%. Non e un miglioramento dimostrato.
- **Effetto dei parametri (media su tutta la griglia):** la distanza minima dal massimo/minimo piu bassa (350) da il Calmar medio piu alto (6,38 contro 5,24 a 750); la scadenza non conta oltre 192 ore (risultati identici a 192, 288, 384); lo stop 300 e il limit 900 sono i valori peggiori (Calmar 5,1-5,2). Niente di drammatico: il campo di variazione e +-25% sul profitto.
- **Conseguenza per l'obiettivo "strategie diverse da Wim":** i 625 set fanno quasi gli stessi 286-294 scambi: sono la STESSA strategia con parametri ritoccati (livello 1 del piano). Correlazione col set di Wim **NON MISURATA** (non ho le liste degli affari), ma e quasi certamente vicina a 1. **Questo filone non puo dare una strategia diversa.** Da solo, serve solo se FTMO considera "diverso" un set con parametri diversi (risposta in attesa).
- **Rendimento in assoluto:** C0 a 0,1 lotti = +0,13% l'anno con DD 0,20%. Per un DD dell'1-2% servirebbero 5-10 volte il lotto (rendimento 0,7-1,3% l'anno): la famiglia ha un rapporto rendimento/DD di circa 0,65 annuo, **lontano da un motore per superare una challenge**.

## ANOMALIA da verificare prima di qualsiasi convalida (V0)
**Il C0 della griglia (2013-2022) rende +1.323 con 286 operazioni e PF 1,65; il nostro test U5 (pipeline del terminale principale, stesso GTP E V9.0 con candela ON, lotto fisso 0,1, 100.000 EUR, Modello 1) dava per 2013-2018 +2.242 con 153 operazioni e PF 1,92, e per 2019-2025 +3.873 con 169 operazioni e PF 2,64.** Gia il solo 2013-2018 vale piu dell'intera griglia su 10 anni; le operazioni del 2013-2022 sono 286 contro circa 250 attese. **Cosa non so:** se (a) il set non e caricato negli stessi valori (nell'ottimizzazione da ini i parametri non ottimizzati potrebbero essere quelli di default dell'EA, non del GTP E), (b) il periodo del grafico (D1) o altri ingressi differiscono dai test U5, oppure (c) il confronto e solo sfortunato. **Non lo scarto e non lo accetto:** la regola V0 della sezione 6 impone la riproduzione.
**Verifica V0 (4 passate singole, circa 2 minuti ciascuna):** A) `OPT2_ORO.set` 2013-2022 (deve dare +1.323,40 / 286 / PF 1,65 se il percorso e identico alla griglia); B) GTP E originale 2013-2022 (se B != A, il set viene caricato diversamente); C) GTP E originale 2013-2018 (attesi 153 / +2.242 / PF 1,92); D) GTP E originale 2019-2025 (attesi 169 / +3.873 / PF 2,64). Se C e D riproducono U5 e A differisce, l'ottimizzazione e invalida (set caricato male) e la griglia va rifatta dopo la correzione.

## Previsioni: esito
- **G-1** storico dal 2013 (qualita >= 98%): l'ottimizzazione e partita senza errori su 625 passaggi con 267-294 operazioni; la qualita storica esatta si legge dai report V0.
- **G-3** (>= 100 passaggi/ora): **FALSA**: circa 82 all'ora (625 in al massimo 7 h 36 min). **G-4** (entro 14 ore): **VERA** (circa 7 ore).
- **G-5** (>= 5 passaggi superano la selezione grezza): **VERA** (625). **G-6** (>= 1 centro di zona stabile): **VERA**, ma banale: tutti. La mia nota "con la griglia i vicini misurano la stabilita" e confermata nel senso opposto a quello che speravo: **l'altopiano e cosi piatto che la stabilita non seleziona niente.**
- **G-7 ... G-11:** non ancora valutabili (servono V0-V4).
- **Bilancio:** ho sottostimato la piattezza: avevo previsto una "zona" da trovare, il risultato e un'intera griglia quasi uguale.

## Se V0 e positiva: candidati (regole sezione 5, con un chiarimento scritto ORA, dopo aver visto che i primi 10 per Calmar sono quasi doppioni)
La selezione grezza ammette tutti i 625: **candidati = i 10 migliori per Calmar fra le COMBINAZIONI DISTINTE SENZA SCADENZA** (la scadenza non cambia i risultati sopra 192 ore: prendo il passaggio con la scadenza di Calmar migliore), piu C0. E una regola di semplificazione che non guarda OOS ne tick. Elenco: pass 365, 615, 490, 315, 565, 440, 356, 240, 606, 481 (tutti MinDist 350-450, Stop 600-900, Limit 1300-2500), cioe 10 vicini che fanno quasi la stessa cosa: **il test fuori campione dira se un qualunque ritocco batte C0 di piu del 10% (V1); la mia aspettativa e di no (G-7: 25%, G-10: 75% che il rapporto in OOS scenda sotto il 60% di quello in IS).**

## Cosa NON sappiamo
La causa della differenza con U5 (sopra); se i 625 passaggi usano davvero tutti gli input del GTP E; il rapporto tra le candele D1 BCM e FTMO (vedi sezione 13 dei criteri); la correlazione dei 625 set con il C0; la qualita storica esatta di XAUUSD 2013-2022 nel portable.

## ESITO DELLA VERIFICA V0 (16/11/2026, output incollato da Claudio): LA GRIGLIA E INVALIDA
Quattro passate singole nel portable (XAUUSD D1, Modello 1, 100.000 EUR, qualita storico 98%):
| Passata | Set | Periodo | Profitto | Operazioni | PF | DD massimo equity | Atteso |
|---|---|---|---|---|---|---|---|
| A | OPT2_ORO.set | 2013-2022 | **+4.563,35** | **253** | **2,19** | 380,06 (0,37%) | era +1.323,40 / 286 / 1,65 (C0 della griglia) |
| B | GTP E originale | 2013-2022 | +4.563,35 | 253 | 2,19 | 380,06 (0,37%) | = A |
| C | GTP E originale | 2013-2018 | **+2.241,79** | **153** | **1,92** | 334,41 (0,33%) | U5: +2.242 / 153 / 1,92 / 334: **IDENTICO** |
| D | GTP E originale | 2019-2025 | **+3.873,19** | **169** | **2,64** | 380,06 (0,38%) | U5: +3.873 / 169 / 2,64 / 380: **IDENTICO** |
- **Il portable riproduce esattamente i nostri test U5** (C e D coincidono al centesimo): lo storico, il tester e l'EA sono gli stessi della pipeline principale. **A = B**: il set `OPT2_ORO.set` in passata singola vale come il GTP E originale (con C0 = i valori del GTP E).
- **Ma la griglia NON misurava il GTP E:** il suo passaggio centrale (stessi 4 valori di C0) dava +1.323 / 286 / PF 1,65 invece di +4.563 / 253 / PF 2,19. **Quindi i 625 passaggi non vanno usati per nessuna scelta.** Il numero "C0 e 99-esimo su 625" e il resto della sezione sopra sono da considerare NON validi.
- **Causa: NON verificata.** Ipotesi: nell'avvio da `.ini` la sezione `[TesterInputs]` conteneva solo le 4 righe con `||Y`; quando c'e una `[TesterInputs]` gli altri input potrebbero tornare ai valori di default dell'EA invece di quelli del set. Lo script `AVVIA_OTT_ORO2.ps1` lo verifica (passata E: stesso ini della griglia, deve dare circa +1.323) e poi rifa la griglia con TUTTI gli input in `[TesterInputs]`, ma solo se la passata di controllo F (stesso metodo, senza ExpertParameters) riproduce +4.563,35 / 253.
- **Regola nuova (per tutte le griglie):** il passaggio centrale deve coincidere con una passata singola dello stesso set; se non coincide, la griglia e invalida e non si legge.
- **Errore mio:** non avevo previsto questo rischio; la riga di avvio era stata scritta senza una passata di controllo con lo stesso metodo. Avrei dovuto notare che C0 non coincideva con U5 ancora prima di leggere i migliori. L'ho notato leggendo C0, ma dopo aver analizzato tutta la griglia.
- **Dato utile gia da V0:** GTP E a 0,1 lotti su 2013-2022 vale +4.563 (circa +0,46% l'anno, DD massimo 0,37%): rapporto rendimento/DD annuo circa 1,2 (non 0,65 come sembrava dalla griglia sbagliata).

# SECONDA GRIGLIA (VALIDA), esportata il 16/11/2026 alle 15:25 ora italiana
**Fonte:** `UBS_PILOTA_ORO_dati/G_ORO_griglia2_625_ReportOptimizer_2026-11-16.xml` (stessa intestazione: `XAUUSD,Daily 2013.01.01-2022.12.31`). Avviata con `AVVIA_OTT_ORO2.ps1` (tutti gli input in `[TesterInputs]`, passata di controllo F bloccante). Durata circa 4 h 45 min (stima di MT5): circa 131 passaggi all'ora.
**Controllo del passaggio centrale (regola nuova): OK.** C0 (550/480/600/1700, passaggio 322) = **+4.563,35, 253 operazioni, PF 2,19, DD 0,37%** = la passata singola A. **La griglia misura il GTP E di Wim.**

## Cosa mostra
| | minimo | mediana | massimo |
|---|---|---|---|
| Profitto (EUR, 0,1 lotti, 10 anni) | 2.225 | 4.544 | 6.270 |
| Profit factor | 1,58 | 2,24 | 2,74 |
| Operazioni | 245 | 253 | 273 |
- **Tutti i 625 passaggi sono positivi e superano i filtri grezzi; tutti sono "centri di zona stabile"**: la regola di selezione non scarta niente (come nella griglia sbagliata). Si applica la regola di ripiego gia scritta (sezione 12): 10 migliori per rendimento/DD (profitto / DD in euro) fra le combinazioni distinte senza scadenza.
- **C0 e 197-esimo su 625 per rendimento/DD (12,40).** Il migliore e il passaggio 594 (MinDist 750, Scadenza 384, Stop 750, Limit 2500): **16,46 = 1,33 x C0** (profitto +5.597, PF 2,53, DD 0,34%, 245 operazioni). **83 passaggi su 625 superano C0 di almeno il 10%.** Il migliore per Custom e il 592 (550/384/750/2500): +5.956, PF 2,61, DD 0,37%.
- **L'effetto e quasi tutto in UN parametro: `Exit_limit` (il target).** Calmar medio per valore: 900 → 6,77; 1300 → 9,56; 1700 → 12,28; 2100 → 12,60; 2500 → 12,96 (a stop 750: 12,64 / 14,62 / 15,30 per 1700 / 2100 / 2500). Stop 750-900 meglio di 300-600. **MinDist ha poco effetto (10,5-11,1)** e la scadenza sotto 288 ore e leggermente peggiore (10,55 contro 11,03).
- **Il valore migliore del limit (2500) e il bordo della griglia** (il template arriva a 5000): l'ottimo potrebbe stare oltre; **NON l'ho esplorato** (regola "una sola griglia").
- **Lettura prudente:** la direzione e "lasciar correre i profitti" (target piu lontano, stop piu largo). Sull'oro 2013-2022 con forti rialzi e cio che ci si aspetta da un periodo di trend; **puo valere solo per quel regime** e l'hold-out 2025 (oro in forte rialzo) lo favorirebbe per costruzione. +33% sul rendimento/DD nel dentro-campione, su 625 tentativi, **non e ancora un miglioramento dimostrato.**

## I candidati (regola: 10 migliori per rendimento/DD fra combinazioni distinte senza scadenza) + controllo
C0 = GTP E di Wim (550/480/600/1700). C1 594 (750/384/750/2500) 16,46 · C2 592 (550/384/750/2500) 15,99 · C3 593 (650/384/750/2500) 15,76 · C4 591 (450/384/750/2500) 15,68 · C5 467 (550/384/750/2100) 15,43 · C6 619 (750/384/900/2500) 15,27 · C7 468 (650/384/750/2100) 15,20 · C8 469 (750/384/750/2100) 15,18 · C9 466 (450/384/750/2100) 15,11 · C10 617 (550/384/900/2500) 14,74.
**Sono quasi doppioni** (stop 750-900, limit 2100-2500, scadenza 384): in pratica una o due configurazioni, quindi la convalida valuta UNA direzione piu che dieci idee.

## Convalida (regole scritte PRIMA, sezione 6; riscritte qui con la numerazione)
- **V1 fuori campione 2023-01-01 -> 2024-12-31 (candele, lotto 0,1):** PF >= 1,20, profitto > 0, recovery >= 1 **e** rendimento/DD >= 1,10 x quello di C0 nello STESSO periodo.
- **V2 stabilita nel tempo:** 2013-2017 e 2018-2022: PF >= 1,15 e profitto > 0 in ENTRAMBE; rapporto fra i DD delle due meta <= 2,5.
- **Un candidato va avanti solo se passa V1 e V2.** Poi V3 (tick 2024-07/2024-12 e 2026-01/2026-10), V4 e V4b (hold-out 2025 e 2026), V6 (candele FTMO). **Nessuna griglia estesa sul limit prima dell'esito di V1/V2**; se un candidato passa, un secondo esperimento DICHIARATO potra spingere il limit oltre 2500.
- Script: `VALIDA_CAND_ORO.ps1` (33 passate, tutti gli input, stesso metodo della griglia).

## Previsioni: esito parziale
- **G-3** (>= 100 passaggi/ora, scritto al 30%): **VERA** (circa 131/ora nella griglia valida; la prima griglia sbagliata era a 82/ora). **G-4** (entro 14 ore): **VERA**. **G-5/G-6:** **VERE, banali** (625 su 625). **G-10 (prima meta)** (il migliore batte C0 di piu del 20% nel dentro-campione): **VERA** (+33%); (seconda meta) rapporto OOS/IS sotto il 60%: **da misurare**. **G-7 ... G-11:** in attesa di V1/V2.

# CONVALIDA V1 / V2 (16/11/2026, output di `VALIDA_CAND_ORO.ps1` incollato da Claudio; 33 passate su 33)
**Fonte:** `UBS_PILOTA_ORO_dati/valida_cand_oro_2026-11-16.txt`; lettura con `valida_cand_oro.py` (regole del 16/11 scritte PRIMA, nessuna soglia ritoccata). Controllo di coerenza: **C0 H1 + H2 = +4.563,35 con 253 operazioni = la passata singola A e il passaggio centrale della griglia.**
| Cand. | MinDist/Scad./Stop/Limit | OOS 2023-24: profitto / ops / PF / DD EUR / rend.DD (x C0) | H1 2013-17: profitto / PF | H2 2018-22: profitto / PF | V1 | V2 |
|---|---|---|---|---|---|---|
| **C0 (Wim)** | 550/480/600/1700 | 1.309 / 47 / 2,91 / 326 / 4,01 (x1,00) | 1.849 / 1,87 | 2.714 / 2,58 | - | passa |
| C1 | 750/384/750/2500 | 1.703 / 44 / 3,85 / 242 / 7,05 (x1,76) | 2.172 / 2,10 | 3.326 / 2,98 | **passa** | passa |
| C2 | 550/384/750/2500 | 1.681 / 47 / 3,54 / 308 / 5,46 (x1,36) | 2.225 / 2,09 | 3.632 / 3,17 | passa | passa |
| C3 | 650/384/750/2500 | 1.722 / 45 / 3,89 / 242 / 7,12 (x1,78) | 2.166 / 2,06 | 3.604 / 3,14 | passa | passa |
| C4 | 450/384/750/2500 | 1.697 / 49 / 3,52 / 432 / 3,93 (x0,98) | 2.167 / 2,00 | 3.571 / 3,06 | **NO** (x0,98) | passa |
| C5 | 550/384/750/2100 | 1.729 / 47 / 3,61 / 308 / 5,62 (x1,40) | 2.168 / 2,06 | 3.588 / 3,18 | passa | passa |
| C6 | 750/384/900/2500 | 2.051 / 44 / 5,34 / 224 / 9,18 (x2,29) | 2.504 / 2,40 | 3.161 / 2,69 | **passa** | passa |
| C7 | 650/384/750/2100 | 1.611 / 45 / 3,70 / 242 / 6,66 (x1,66) | 2.109 / 2,04 | 3.560 / 3,15 | passa | passa |
| C8 | 750/384/750/2100 | 1.592 / 44 / 3,67 / 242 / 6,59 (x1,64) | 2.115 / 2,07 | 3.314 / 3,00 | passa | passa |
| C9 | 450/384/750/2100 | 1.904 / 49 / 3,83 / 318 / 5,99 (x1,49) | 2.110 / 1,97 | 3.527 / 3,07 | passa | passa |
| C10 | 550/384/900/2500 | 2.012 / 47 / 4,64 / 283 / 7,10 (x1,77) | 2.547 / 2,37 | 3.467 / 2,86 | passa | passa |

## Esito (regole applicate come scritte)
- **V1: 9 candidati su 10 passano; C4 no (x0,98).** **V2: tutti e 10 passano** (PF >= 1,97 in entrambe le meta, rapporto DD fra le meta 1,01-1,14).
- **Nel fuori campione 2023-2024 i candidati battono Wim in profitto (1.592-2.051 contro 1.309), PF (3,5-5,3 contro 2,9) e rendimento/DD (x1,36 - x2,29), e in entrambe le meta del dentro-campione.**
- **La mia previsione G-7 ("almeno un candidato passa V1": 25%; "nessuno": 75%) era SBAGLIATA.** Non avevo previsto che la direzione tenesse fuori campione.

## Cosa NON dice questo risultato (limiti)
1. **I nove sono quasi lo stesso test:** stop 750-900, limit 2100-2500, scadenza 384, distanze simili; fanno gli stessi scambi. "9 su 10" e UNA direzione confermata, non nove idee indipendenti.
2. **Campione piccolo:** 44-49 operazioni in 2 anni; PF 3,5-5,3 con cosi poche operazioni ha un intervallo largo (non calcolato: mancano le liste degli affari).
3. **2023-2024 e un periodo di forte rialzo dell'oro**, e un target piu lontano lo favorisce per costruzione; **anche il 2025 sara un rialzo**: l'hold-out confermera facilmente per un motivo che non dimostra robustezza. Contro: nella meta 2013-2017 (oro in calo e poi laterale) i candidati migliorano comunque (+14%/+38% di profitto), ma quella meta fa parte del periodo su cui la griglia e stata scelta.
4. **Il valore migliore del limit (2500) e il bordo della griglia**: l'ottimo non e stato cercato oltre.
5. **Coerenza H1+H2 contro griglia:** per 4 dei 5 candidati controllati la somma delle meta e **inferiore di 98,60 EUR** al passaggio della griglia con lo stesso numero di operazioni (C9: identico). Causa NON verificata; ipotesi: un'operazione lunga a cavallo del 31/12/2017 che nella passata divisa viene chiusa al termine del test. Non cambia gli esiti.
6. **Costi e candele:** Modello 1, spread BCM; i test a tick reali vengono dopo.
7. **Il guadagno assoluto resta piccolo:** a 0,1 lotti C6 vale circa +0,56% l'anno (profitto IS 5.665 su 10 anni, 100.000 EUR) con DD 0,39%.

## Prossimi passi (regole sezione 6; PRIMA di qualunque risultato V3/V4)
- **Finalisti per V3/V4/V4b (decisi ora, prima dei risultati):** per non testare nove doppioni scelgo **tre rappresentanti del gruppo + il controllo**: **C0** (Wim), **C1** (migliore per rendimento/DD in dentro-campione), **C6** (migliore in OOS, stop 900) e **C5** (limit 2100, il piu moderato del gruppo). C4 (unico bocciato in V1) e gli altri non proseguono, nessuna scelta dopo aver visto il 2025.
- **V3 (tick reali) - problema scritto prima:** le finestre con tick fuori hold-out (2024-07/2024-12 e 2026-01/2026-10, 16 mesi) conterranno circa 25-30 operazioni per candidato, **sotto il minimo di 30 fissato**: probabile "non valutabile" per C0. Opzioni (decide Claudio): (a) eseguire V3 comunque e dichiarare il campione, (b) usare la regola "un candidato non passa a V4 senza V3" alla lettera e fermarsi. **Consiglio: (a), perche V3 serve a vedere se i tick cambiano il quadro, non a decidere da solo.**
- **V4 (hold-out 2025 a tick) e V4b (2026-01/2026-10 a tick):** si aprono UNA volta, insieme, per i quattro finalisti. **V6:** candele FTMO, se lo storico del terminale di prova copre.
- **Nessun secondo esperimento sul limit prima di V4.**

# HOLD-OUT: V4 (2025) e V4b (2026-01 -> 2026-10), aperto il 16/11/2026 (output di `VALIDA_HOLDOUT_ORO.ps1`, 16 passate su 16)
**Fonte:** `UBS_PILOTA_ORO_dati/holdout_oro_2026-11-16.txt`. Regole applicate come scritte nella sezione 16 dei criteri (prima dei numeri), nessuna soglia ritoccata. Qualita dello storico 100% in tutte le passate, tick reali 65,7 milioni (2025) e 88 milioni (2026). Lotto 0,1, deposito 100.000 EUR, Modello 1 e Modello 4.
| Finalista | Finestra | Tick reali: profitto / ops / PF / DD EUR | Candele: profitto / PF | tick/candele: profitto / PF | rend./DD (x C0) | Esito finestra |
|---|---|---|---|---|---|---|
| **C0 (Wim)** | 2025 | 158,0 / 22 / 1,61 / 222,8 | 243,6 / 1,96 | 0,65 / 0,82 | 0,71 (x1,00) | controllo |
| C1 | 2025 | 385,9 / 20 / 3,20 / 179,3 | 526,3 / 4,03 | 0,73 / 0,79 | 2,15 (x3,03) | passa |
| C5 | 2025 | 234,0 / 22 / 1,88 / 179,3 | 372,0 / 2,56 | 0,63 / 0,73 | 1,31 (x1,84) | passa |
| C6 | 2025 | 359,7 / 20 / 2,79 / 203,1 | 500,0 / 3,50 | 0,72 / 0,80 | 1,77 (x2,50) | passa |
| **C0 (Wim)** | 2026-01/10 | 251,6 / 17 / 2,35 / 126,4 | 185,0 / 2,00 | 1,36 / 1,18 | 1,99 (x1,00) | controllo |
| C1 | 2026-01/10 | 398,0 / 17 / 2,74 / 157,7 | 263,2 / 2,16 | 1,51 / 1,27 | 2,52 (x1,27) | passa |
| C5 | 2026-01/10 | 297,1 / 17 / 2,29 / 137,2 | 203,3 / 1,90 | 1,46 / 1,21 | 2,16 (x1,09) | passa |
| C6 | 2026-01/10 | 345,5 / 17 / 2,28 / 159,9 | 222,1 / 1,83 | 1,56 / 1,25 | 2,16 (x1,09) | passa |

## Esito (regole applicate come scritte): C1, C5 e C6 sono "ROBUSTI" (passano V4 e V4b)
- **Profitto a tick reali 2025 + 2026 (22 mesi, 0,1 lotti):** Wim 410; **C1 784 (1,91 x Wim)**; C6 705 (1,72 x); C5 531 (1,30 x). Drawdown massimo 0,16-0,20% in tutti.
- **Con il fuori campione, i tick 2024-H2 e le due meta del dentro-campione, C1 batte Wim in OGNI finestra misurata** (dentro-campione, OOS 2023-2024, tick 2024-H2, 2025, 2026): una direzione coerente.
- **Previsioni (scritte prima):** "almeno 1 finalista ROBUSTO: 55%" **VERA**; "tutti e tre i candidati ROBUSTI: 25%" **VERA**; "nessun candidato batte C0 nel 2025: 15%" **FALSA**; **"rapporto tick/candele del PF >= 0,9 in tutte le finestre: 80%" FALSA** (nel 2025 il PF a tick vale 0,73-0,82 di quello a candele e il profitto cala del 27-37%; nel 2026 e MIGLIORE a tick (1,18-1,27 x), nel 2024-H2 0,98-0,99 x). Sommando 2025 e 2026 la differenza tick/candele e piccola: profitto 0,92 (C5), 0,96 (C0), 0,98 (C6), 0,99 (C1) — in linea con la stima precedente (le candele sovrastimano il profitto dell'oro di circa 3-8%).

## Limiti: cosa NON dimostra (da leggere insieme all'esito)
1. **Campione piccolissimo:** 17-22 operazioni per finestra. I rapporti tra candidati e Wim hanno un'incertezza grande; per C5 e C6 il margine su Wim nel 2026 e solo x1,09 in rendimento/DD (profitto +18% e +37%), e C5 nel 2025 ha un rapporto PF tick/candele di 0,73, vicino alla soglia 0,7.
2. **I tre sono UNA SOLA direzione** (target piu lontano e stop piu largo): "tre robusti" non sono tre conferme indipendenti.
3. **Regime:** il 2025 e un anno di forte rialzo dell'oro; **non ho misurato il rialzo del 2026**: se anche il 2026 e stato in rialzo, le due finestre non distinguono "robusto" da "regime favorevole". Da misurare (rendimento annuo dell'oro nelle finestre).
4. **L'hold-out e ora consumato** per questi parametri: ogni nuova griglia sul limit (ottimo oltre 2500? non esplorato) non ha piu 2025 e 2026 come dati intatti.
5. **Candele FTMO:** la candela D1 di FTMO e tagliata diversamente da quella BCM (sezione 13 dei criteri); V6 NON e stato fatto. **Il guadagno trovato su candele BCM non e garantito su FTMO.**
6. **Rendimento assoluto piccolo:** C1, 22 mesi: +784 su 100.000 EUR a 0,1 lotti (circa +0,43% l'anno) con DD massimo 0,16-0,18%: rapporto rendimento annuo / DD circa 2,4 a parita di lotto. Nessun giudizio su lotti o taglie.
7. **Resta lo stesso EA di Wim (set Gold Trade Pro E) con parametri ritoccati:** correlazione con Wim non misurata, quasi certamente vicina a 1; l'ipotesi di FTMO ("strategia identica?") resta in attesa.

## Contatore di campagna (oro, pilota GTP E)
625 (griglia invalida, scartata) + 625 + 33 (V1/V2) + 8 + 8 (V3, due corse) + 16 (V4/V4b) passate; 1 sola griglia valida, 4 finalisti, hold-out aperto una volta.

# V6 (candele FTMO): stato della ricerca dello storico (16/11/2026 19:38, riga di sola lettura di Claudio)
- **Terminale FTMO di prova** (`C:\MT5_Backtest\Mt5_Ftmo_Prova`, server `FTMO-Demo`): storico XAUUSD **solo 2026, 1 file da 17,2 MB**; nessun tick. **Insufficiente** per confrontare C0 e C1 su 2013-2026.
- **FundedNext** (`C:\FundedNext_Manuale`, server `FundedNext-Server`): XAUUSD **2019-2026** (8 file, 135,5 MB), tick solo 2026-09. **E un'altra societa, NON FTMO**: non usabile per affermazioni su FTMO; licenza dell'EA non verificata.
- **BCM** (principale e portable): XAUUSD **2004-2026**, tick 2024-07 -> 2026-11 (29 mesi): quelli gia usati.
- **Cosa NON so (da verificare prima di V6):** (a) se la licenza UBS funziona sul conto FTMO-Demo; (b) quanti anni di storico M1 oro scarica FTMO-Demo; (c) **la regola dell'ora legale del server FTMO**: CLAUDE.md dice "ora italiana + 1" (confermato il 02/11/2026), ma il 2 novembre e una data in cui Europa e USA sono entrambe in ora solare: **non distingue la regola UE (usata nella libreria `CLAU12_ORARI`) dalla regola USA** (taglio alla chiusura di New York); la differenza cade nelle tre settimane di scarto (marzo e ottobre-novembre).
- **Stima a priori dell'effetto del taglio D1 (NON misurata):** BCM taglia il giorno alle 23:00 UTC, FTMO alle 22:00 (inverno) o 21:00 UTC (estate): 1-2 ore spostate fra due candele giornaliere, e sono le ore piu tranquille dell'oro (dopo la chiusura di New York, prima dell'Asia). Le candele H1 restano identiche (offset di ore intere). Mi aspetto un effetto piccolo: probabilita che C1 batta ancora Wim con il taglio FTMO: 85%.
- **Opzione A:** una passata sul terminale FTMO-Demo (scarica lo storico da solo; serve la licenza sul conto FTMO-Demo e l'EA installato li). **Opzione B:** simbolo personalizzato `XAUUSD_FTMOCUT` costruito dai minuti BCM con gli orari convertiti al server FTMO (isola il solo effetto del taglio, indipendente da licenza e profondita dello storico FTMO; richiede export e import via MQL5).

# V6: trasferimento su dati FTMO (16/11/2026, output di `VALIDA_V6_ORO.ps1`, 32 passate su 32)
**Fonte:** `UBS_PILOTA_ORO_dati/v6_ftmo_bcm_oro_2026-11-16.txt`. XAUUSD D1, Modello 1, lotto 0,1, 100.000 EUR, stessi parametri e finestre su FTMO (server FTMO-Demo, storico dal 2015) e BCM. Regole della sezione 17 dei criteri (scritte prima), nessuna soglia ritoccata.
## Esito delle regole: C1, C5, C6 = "NON TRASFERITI" (passano 3 finestre su 4, ma non la 2015-2022, che era obbligatoria)
| Cand. | 2015-2022 (profitto / PF / DD EUR) | OOS 2023-24 | 2025 | 2026-01/10 | Finestre passate |
|---|---|---|---|---|---|
| **C0 (Wim, FTMO)** | 3.574 / 2,69 / **390** | 1.107 / 3,15 / 218 | 45 / 1,22 / 238 | 150 / 1,94 / 128 | controllo |
| C1 | 3.635 / 2,61 / **721** → NO (rend./DD x0,55) | 1.592 / 5,43 / 186 passa (x1,69) | 154 / 1,89 / 189 passa (x4,35) | 208 / 2,08 / 147 passa (x1,21) | 3/4 → **NON TRASFERITO** |
| C5 | 3.457 / 2,52 / **1.093** → NO (x0,35) | 1.637 / 4,77 / 231 passa (x1,40) | 127 / 1,73 / 189 passa (x3,59) | 180 / 1,94 / 147 passa (x1,04) | 3/4 → **NON TRASFERITO** |
| C6 | 4.066 / 2,73 / **1.053** → NO (x0,42) | 2.121 / 9,45 / 180 passa (x2,32) | 127 / 1,63 / 216 passa (x3,13) | 279 / 2,83 / 165 passa (x1,43) | 3/4 → **NON TRASFERITO** |
- **Perche falliscono la finestra lunga:** il profitto 2015-2022 su FTMO e simile a Wim (C1 x1,02, C5 x0,97, C6 x1,14), **ma il drawdown massimo dei candidati e 1,8-2,8 volte quello di Wim (721-1.093 contro 390 EUR, cioe 0,7-1,1% contro 0,4% del deposito)**: un episodio di perdita nel periodo 2015-2022 su dati FTMO che sui dati BCM non c'e (BCM: DD 350-390 per tutti). **Non ho localizzato quando** (servirebbe una passata per anno).
- **Nelle tre finestre recenti (2023-2026) i candidati battono Wim anche su FTMO**: profitto x1,4-1,9 (OOS), x2,8-3,5 (2025), x1,2-1,9 (2026); PF e rendimento/DD migliori.
## Cosa dice il confronto FTMO contro BCM (stesso set, stessa finestra)
- **I dati BCM NON sono un buon sostituto di FTMO per questo EA.** Profitto FTMO / BCM per Wim (C0): 2015-22 x0,90; 2023-24 x0,85; **2025 x0,18**; 2026 x0,81. Per i candidati: C1 x0,81 / x0,93 / **x0,29** / x0,79; C6 x0,87 / x1,03 / **x0,25** / x1,25.
- **Barre D1 nello stesso periodo:** FTMO 2.066 (2015-22), 515 (2023-24), 257 (2025), 215 (2026) contro BCM **2.478, 609, 288, 246**: BCM ha circa il 15-20% di barre D1 in piu (circa 310 contro 258 l'anno). **Ipotesi (NON verificata):** il server BCM a GMT+1 fisso apre la domenica sera una candela D1 breve che FTMO non ha; l'EA conta le barre D1 per individuare i massimi/minimi e la loro forza: **in BCM e FTMO i livelli di rottura e il numero di operazioni sono diversi** (2015-22: 139 operazioni su FTMO contro 194 su BCM per Wim; per i candidati 135-137 contro 188-194).
- **Conseguenza di metodo (importante):** **l'ottimizzazione di un EA destinato a FTMO va fatta sui dati FTMO**, non su BCM. Questo vale per tutti gli EA che usano barre giornaliere e livelli.
## Previsioni (scritte prima): esito
- "C1 trasferito (>= 3 finestre su 4)": 55% → **FALSA** (3 su 4 ma senza la 2015-2022). "Tutti e tre trasferiti": 35% → **FALSA**. "C0 con PF piu basso su FTMO che su BCM in >= 3 finestre su 4": 80% → **FALSA** (solo 2 su 4: 2025 e 2026). "Il vantaggio di C1 su C0 resta nel 2015-2022 su FTMO": 65% → **FALSA** (profitto x1,02, rendimento/DD x0,55).
## Limiti
Modello 1 su FTMO (tick FTMO non scaricati); 16-42 operazioni nelle finestre recenti; il conto del terminale FTMO di prova e la challenge reale (errore di descrizione dichiarato nella sezione 17); hold-out 2025/2026 gia aperto su BCM: per un'eventuale nuova ottimizzazione su dati FTMO non resta un hold-out intatto (solo i mesi futuri).
