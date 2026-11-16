# Pilota di ottimizzazione UBS sull'ORO: criteri e previsioni scritti PRIMA dei numeri (15/11/2026, sera)

**Natura: CRITERI.** Nessuna passata lanciata, nessun numero nuovo. Solo tester sul MT5 portable `C:\MT5_BCM_Opt` (demo BCM 50503392); reale, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti. Base: `UBS_PILOTA_OTTIMIZZAZIONE_EURUSD_CRITERI_2026-11-15.md` (pilota EURUSD D1, chiuso con "nessun miglioramento rispetto al set di Wim").

## 0. Decisione di Claudio (15/11/2026, sera)
"Sì, partiamo dall'oro, scrivi i criteri." **Questo cambia la decisione del 15/11 mattina "portafoglio separato dall'oro"**: per questo pilota l'oro rientra. La decisione sul portafoglio finale resta di Claudio.

## 1. Perche l'oro, e cosa vogliamo
- Il forex non-oro dei set di Wim ha rendimento/DD basso (0,3-1,0) e gli scalper crollano a tick reali (`RISULTATI_UBS_C_FOREX_TICK_2026-11-15.md`); il pilota EURUSD D1 non ha trovato niente. I set d'oro sono quelli che rendono (P1/P3).
- **Obiettivo:** trovare, con il metodo di Wim, almeno un set d'oro con **rendimento/DD piu alto del set base di Wim**, che regga fuori campione, a tick reali e nel 2025, e che sia **un set nostro** (file diverso da quelli distribuiti ai clienti di Wim). **Attenzione:** se FTMO considera "strategia identica" anche un set con parametri diversi, il vantaggio sul tetto dei 400.000 $ non esiste. La risposta di FTMO e ancora in attesa: questo pilota NON dipende da quella risposta, ma il valore pratico si.
- **Giudice:** il risultato su dati nuovi (OOS, tick reali, hold-out 2025), CONFRONTATO SEMPRE con il set base di Wim a lotto uguale. Un candidato che non batte il base non serve, anche se positivo.

## 2. Lezioni del pilota EURUSD, applicate qui
1. **Il genetico veloce si e fermato a 143 passaggi** (130 passaggi/ora; stima MT5 80-125 ore) e il "migliore" coincideva col base: **qui si usa una GRIGLIA (algoritmo completo) con pochi parametri e un numero di passaggi che entra nel tempo**; mostra anche il paesaggio e permette di misurare la stabilita (vicini) senza passate extra.
2. **Il filtro "expected payoff >= 3" era mio e penalizzava i profili a basso rischio.** Qui il criterio dentro l'ottimizzazione e **Custom max con i minimi preimpostati da Wim nel set di ottimizzazione, SENZA modificarli**; i miei filtri valgono solo DOPO, sul file dei risultati (sezione 5).
3. **I tick reali BCM non esistevano per gli anni vecchi** (forex da luglio 2024): **PRIMA di lanciare, una riga di sola lettura misura da quando esistono i tick XAUUSD sul portable e sul terminale principale** (sezione 9, passo 2). La finestra di convalida a tick si fissa dopo, ma PRIMA di qualunque risultato.
4. **Previsioni di tempo sbagliate** (P-1): qui il tempo si MISURA con una passata base e si decide il numero di passaggi dopo, non prima.
5. **Un bug di script (`$C`/`$c`) ha invalidato 12 passate:** gli script nuovi si controllano per collisioni di nomi PRIMA di girare.

## 3. Dati (tre blocchi, scritti ora)
- **Dentro campione (IS):** 2013-01-01 -> 2022-12-31, **Modello 1 (OHLC 1 minuto)**. Metà 1: 2013-2017; metà 2: 2018-2022 (per la verifica di stabilita).
- **Fuori campione 1 (OOS1):** 2023-01-01 -> 2024-12-31, Modello 1 (e a tick reali nella parte coperta, vedi sotto).
- **Hold-out finale 2025:** 2025-01-01 -> 2026-01-01, **tick reali**. **Mai aperto durante ottimizzazione e scelta**; si usa UNA volta sui finalisti. Se qualcosa cambia dopo averlo visto, non e piu un hold-out e va dichiarato.
- Storico XAUUSD nel portable: copiato dal terminale principale (come fatto per EURUSD) con `MaxBars=100.000.000` (gia impostato). **Se i dati oro BCM non coprono il 2013, IS parte dal primo anno completo disponibile** (dichiarato nel referto, non cambia le altre regole).
- **Orologio:** lo storico BCM ha server GMT+1 fisso (regola CLAUDE.md). I set d'oro sono AutoGMT/senza ore di sessione fisse: **si sceglie un set base senza parametri di ora di sessione**; se ne ha, vale la regola estate/inverno (l'ora cambia due volte l'anno) e si dichiara il limite.

## 4. Impostazioni dell'ottimizzazione (in MT5 portable, fatte da Claudio con foto)
- EA `WIM\Ultimate_Breakout_EA_WSC_V9.5`, **XAUUSD**, un solo timeframe (quello del set base), non ottimizzato.
- Modello **1 minuto OHLC**, ritardo zero, **Forward: No**, deposito **100.000 EUR**, leva 1:100, **lotto fisso 0,1** (`Risk=0`, `StartLots=0.1`), spread filter OFF. (Lotto fisso per confrontabilita: i set che scalano il lotto col saldo, come i `CLI_*`, non si usano come base.)
- Algoritmo: **COMPLETO (griglia)**, criterio **Custom max** con i minimi di Wim lasciati come nel set.
- **Set base: da scegliere DOPO la riga di sola lettura, PRIMA di qualunque risultato.** Candidati (set di ottimizzazione d'oro di Wim, V9.0): (a) `GOLD\Goldtrade Pro\optimization_gold.set`; (b) `GOLD\Gold Reaper\optimization.set`; (c) `GOLD\GOLD_Various_Old\old optimizations XAUUSD H4\optimization.set`. Wim (Discord 09/11): "Start from the OPTIMIZATION.set templates... Use the UBS gold optimization set on XAUUSD H1 with a broad period". **Regola di scelta (fissa):** il primo, nell'ordine (a), (b), (c), che (i) e presente nel portable, (ii) non ha ore di sessione fisse fra i parametri liberi, (iii) ha un set "gemello" gia misurato da noi come set di Wim consegnato (GTP E/a per il Goldtrade Pro, Reaper s1/s5 per il Reaper) in modo da avere un controllo. In caso di parita, il timeframe piu alto (meno sensibile ai tick).
- **Massimo 4 parametri liberi, 5 valori ciascuno = 625 passaggi.** Scelti fra quelli che il set base ha gia attivi per l'ottimizzazione (`||Y`), esclusi lotto/rischio e ore. Priorita: stop iniziale, target iniziale, distanza minima dal massimo/minimo, scadenza. **Il trailing resta fisso** (il piu soggetto a sovra-adattamento: nel pilota EURUSD il "migliore" aveva trailing 5/5). Intervalli: da meta a due volte il valore del set base, con **pavimento = 50% del valore base** per stop e target (anti-scalper senza dover indovinare le unita in punti). I valori esatti si scrivono nel file, dalla riga di sola lettura, PRIMA di lanciare.
- **UNA sola griglia.** Non si rilancia con intervalli diversi dopo aver visto i risultati. Si registra: passaggi, tempo, quanti superano i minimi.
- **Tempo massimo 14 ore** dall'avvio; se non finisce si interrompe e si usano i passaggi fatti, dichiarando "griglia incompleta". **Controllo a +60 minuti:** passaggi fatti e stima di MT5; se la stima supera 20 ore si interrompe PRIMA di sprecare la notte e si riduce a 3 parametri (5 valori = 125 passaggi). Quella e l'unica modifica ammessa e si scrive prima.
- Un solo giro del tester alla volta; MT5 normale e Scalper non girano mentre l'ottimizzazione e in corso.

## 5. Scelta dei candidati (regole fisse, le applico io sul file dei risultati)
1. **Selezione grezza:** PF >= 1,30, operazioni >= 150 (IS), recovery factor >= 1,5, netto > 0.
2. **Zona stabile:** il candidato deve essere il CENTRO di una zona in cui almeno il **70% dei vicini** (un passo in piu o in meno su UN parametro alla volta, fino a 8 vicini) rispetta gli stessi minimi. Un punto isolato non e un candidato (sovra-adattamento).
3. **Massimo 10 candidati**, ordinati per rendimento/DD (netto / DD equity) fra i centri di zona. **C0 = set base di Wim** (controllo) sempre incluso, con gli stessi input (`Risk=0`, `StartLots=0,1`).
4. **Passaggi guardati** (numero di combinazioni e di passate di convalida) nel referto.

## 6. Convalida (le faccio con le nostre righe del tester, set per set, lotto 0,1)
- **V0 Riproduzione:** C0 e il migliore: IS 2013-2022 deve coincidere con la griglia (profitto, PF, operazioni +-2%). Se no: errore mio/del tester, si ferma.
- **V1 OOS1 a candele (2023-2024):** PF >= 1,20, netto > 0, recovery >= 1, **E rendimento/DD del candidato >= 1,10 x quello di C0** nello stesso periodo.
- **V2 Stabilita nel tempo (IS diviso in due):** PF >= 1,15 e netto > 0 in ENTRAMBE le meta (2013-2017 e 2018-2022); e **rapporto DD fra le due meta <= 2,5** (nostro dato: il dailyC aveva 3,08 e il DD misurato in un periodo non valeva nell'altro).
- **V3 Tick reali** (solo per chi passa V1 e V2), **nella finestra con tick completi** (qualita >= 98%) fissata dalla riga di sola lettura: PF tick/M1 >= 0,7, DD tick <= 1,5 x M1, operazioni +-10%.
- **V4 Hold-out 2025 a tick reali (UNA volta, solo finalisti):** PF >= 1,20, netto > 0, rendimento/DD >= C0 nello stesso anno, DD sotto il 5% del deposito in ogni giorno chiuso. Il lotto non si cambia dopo aver visto il risultato.
- **V5 (se un candidato passa tutto):** simulazione di challenge (stessa dei P1/P3, fail-rate su partenze di tutto l'anno) contro il set di Wim, per verificare che il rendimento in piu non sia pagato con piu rischio di fallire.

## 7. Regole di arresto
- **Nessun candidato supera V1 + V2 + V3 battendo C0:** si scrive "nessun miglioramento rispetto al set di Wim sull'oro", la griglia NON si rifa con intervalli diversi e si valuta con Claudio cosa fare (altro set di partenza, tenere i set di Wim cosi come sono, oppure piano A: EA limit-rimbalzo sull'oro).
- **Se la finestra di tick reali e troppo corta** (meno di 2 anni o meno di 100 operazioni per candidato) V3 si scrive "non valutabile" e un candidato NON passa a V4 senza V3: si dichiara e si decide con Claudio, senza abbassare la soglia.
- **Si interrompe prima** se: la griglia mostra solo passaggi con 0 operazioni o errori; il PC supera il 95% di memoria; errori di licenza; stima oltre 20 ore a +60 minuti (vedi sopra).
- **Non si cambiano intervalli, soglie o periodo a ottimizzazione in corso o dopo aver visto i risultati.**

## 8. Previsioni (scritte ora, prima di qualunque numero)
- **G-1** I dati XAUUSD BCM coprono dal 2013 con qualita >= 98% per tutto l'IS: 70%.
- **G-2** La passata base IS (10 anni, Modello 1) dura meno di 4 minuti per agente: 60%.
- **G-3** Ritmo dell'ottimizzazione >= 100 passaggi/ora: 40% (mediana attesa 70/h: le passate d'oro sono piu lunghe di quelle EURUSD D1 da 69 s e nel pilota il ritmo era 130/h).
- **G-4** La griglia da 625 passaggi finisce entro 14 ore: 50%.
- **G-5** Almeno 5 passaggi superano la selezione grezza (PF >= 1,30, ecc.): 75%.
- **G-6** Almeno 1 candidato e centro di una zona stabile (70% dei vicini): 55%.
- **G-7** Almeno 1 candidato supera V1 (batte C0 di 1,10x nell'OOS1): 25%.
- **G-8** Almeno 1 candidato supera V1 + V2 + V3: 12%.
- **G-9** Almeno 1 candidato batte C0 nell'hold-out 2025 a tick (V4): 8%.
- **G-10** Il migliore per Custom in IS batte C0 in IS di piu del 20% in rendimento/DD (quasi certo: e lo scopo dell'ottimizzazione): 90%; ma nel OOS1 il suo rendimento/DD e meno del 60% di quello in IS: 75%.
- **G-11** Verdetto finale "nessun miglioramento rispetto al set di Wim": 75%.
- **Nota di calibrazione:** nel pilota EURUSD le mie previsioni di tempo e di tenuta ai tick erano troppo ottimistiche; questa volta le probabilita sono scritte piu basse sui passi che richiedono tenuta fuori campione.

## 9. Passi pratici (uno alla volta, io annuncio in grassetto)
1. **Criteri** (questo file). 
2. **Riga di sola lettura** (nessuna scrittura): elenco dei set di ottimizzazione d'oro presenti nel portable, parametri liberi `||Y` di ciascuno (valori, minimo, passo, massimo), copertura storico M1 XAUUSD del portable e del terminale principale (primo anno, mesi), copertura dei tick reali XAUUSD per mese (portable e principale).
3. **Scelta del set base e dei 4 parametri, scritta nel file PRIMA di lanciare** (con valori e passi), poi finestra di tick per V3/V4.
4. **Copia dello storico oro nel portable** (se manca) con riga bloccata per SHA256 e marcatore; **passata base IS** per misurare tempo e riferimento C0.
5. **Griglia** (Claudio, MT5 portable, con foto di conferma delle impostazioni) e controllo a +60 minuti.
6. Esportazione dei risultati (xml), selezione (sezione 5), convalide (V0-V5), referto.

## 10. Cosa NON sappiamo
- Se i tre set di ottimizzazione d'oro sono tra i 15 copiati nel portable il 15/11 e quali parametri hanno liberi (la riga del passo 2 lo dice).
- Da quando esistono i tick reali XAUUSD sul BCM e se coprono abbastanza per V3 (nostri test oro a tick: 2025 e 21 mesi del Reaper; copertura mensile non misurata).
- Se la passata base IS da 10 anni su oro regge nel tempo dell'i7 portatile (nel pilota: 3,7 min/passaggio/agente con 8 agenti per una passata da 69 s).
- Se FTMO considera un set con parametri diversi una "strategia diversa" (domanda in attesa).
- Spread e slippage FTMO reali sull'oro (non misurati; foto di lunedi).
- Se l'oro del 2013-2022 e un regime ripetibile (oro in forte rialzo 2024-2025: un candidato che "regge" nel 2025 puo essere solo il rialzo).

## 11. Esito della riga di sola lettura e decisioni (15/11/2026 23:00, scritte PRIMA di qualunque passata; nessun risultato di performance visto)
**Dati letti (output di Claudio):** PC i7-8550U, 8 processori logici, RAM 15,8 GB, C: libero 247 GB; nessun MT5 aperto. Nel portable 15 set di ottimizzazione, **5 d'oro**: `Gold Reaper\optimization.set` (17 parametri liberi, tutti i timeframe a 0 = grafico), `Goldbot One\Optimization.set` (16; ha `RNG_CheckHour=9`), `Goldtrade Pro\optimization_gold.set` (16), `GOLD_Various_Old\old optimizations XAUUSD H4\optimization.set` (15), `GOLD_Various_Old\Variable paramaters (daily)\optimization.set` (20). Tutti con `AutoGMT=true`, offset 3/2, `Risk=0`, `StartLots=0.01`.
**Storico:** portable XAUUSD solo 2023-2026 (4 file, 69 MB: **manca 2013-2022, va copiato**); terminale principale XAUUSD 2004-2026 (23 file, 451 MB) e **tick reali solo da 2024-07 a 2026-11** (29 mesi mensili, 794 MB); il portable non ha tick. (Copia locale: non e la disponibilita del server.)

**Decisioni (applicando la regola della sezione 4):**
1. **Set base = Goldtrade Pro** (`optimization_gold.set`): e il primo in ordine (a) che e presente, non ha parametri di ora di sessione fra i liberi (solo `AutoGMT`), e ha un gemello gia misurato da noi (**GOLDTRADEPRO_E**: XAUUSD, timeframe **D1** (16408), gia in P1 e nel portafoglio live di Wim). Il Goldbot One e escluso dalla regola (ha `RNG_CheckHour`).
2. **C0 (controllo) = GOLDTRADEPRO_E V9.0 come consegnato** (candela di conferma ON), con `Risk=0` e `StartLots=0,1`, altri input invariati. **La griglia e CENTRATA su C0**: il punto centrale e esattamente il set di Wim; la domanda e "ritoccando questi 4 parametri si fa meglio del set di Wim?". Il modello d'ingresso e il timeframe (D1) non si toccano. I range e i passi vengono dal template (`optimization_gold.set`).
3. **I 4 parametri liberi:** `Exit_stop`, `Exit_limit`, `ST1_MinDist_to_HL`, `ST1_Expiration_hours`. Trailing e tutto il resto fissi ai valori di C0.
4. **5 valori per parametro** = 50%, 75%, 100%, 150%, 200% del valore di C0, arrotondati al passo del template (se due valori coincidono dopo l'arrotondamento si prende il passo successivo del template); pavimento 50% per stop e target come da sezione 4. I valori numerici si scrivono qui dopo aver letto il set C0 (seconda riga di sola lettura), PRIMA di lanciare.
5. **Finestra dei tick reali (V3) fissata ora:** `2024-07-01 -> 2024-12-31` **piu** `2026-01-01 -> 2026-10-31` (i soli periodi con tick locali che NON sono hold-out e non usati per scegliere); minimo **30 operazioni** per candidato (sostituisce "100": con un set daily D1 (circa 25 operazioni l'anno) 100 operazioni non arriverebbero mai; il potere statistico e BASSO e lo dichiaro). Il confronto M1/tick e sulla STESSA finestra e sullo stesso set. Se C0 stesso ha meno di 30 operazioni nella finestra, V3 e "non valutabile" e un candidato non passa a V4 senza V3 (si decide con Claudio).
6. **V4 hold-out 2025 a tick reali** invariato; **V4b: 2026-01-01 -> 2026-10-31 a tick reali** come secondo controllo finale, aperto UNA sola volta insieme a V4, mai usato prima.
7. **Dove si fa:** ottimizzazione e V0-V2 sul MT5 portable (storico oro da copiare); **V3, V4, V4b sul terminale principale BCM con la pipeline del tester gia collaudata** (ha i tick oro e le nostre guardie), con i candidati passati come input (`-Imposti`).
8. **Tempo atteso (stima, non misurata):** una passata IS da 10 anni su oro D1 a M1 circa 100-150 s per agente; con il ritmo misurato nel pilota (circa 2,5 agenti effettivi) circa **60-90 passaggi/ora, 625 passaggi in circa 7-10 ore**. Tetto 14 ore come da sezione 4.
9. **Previsioni aggiornate:** G-1 (storico XAUUSD dal 2013 esiste nel terminale principale): **verificata nell'esistenza dei file**, la qualita dei dati si vede alla prima passata. G-3 (>= 100 passaggi/ora): scendo a **30%**. G-4 (griglia entro 14 ore): sale a **60%**.

## 12. Valori della griglia (15/11/2026 23:15, scritti PRIMA di lanciare; corregge il punto 4 della sezione 11)
**Correzione:** MT5 accetta per ogni parametro solo un intervallo UNIFORME (inizio, passo, fine): i valori "50/75/100/150/200%" arrotondati NON si possono dare. Si usano passi uniformi centrati sul valore di C0 (GTP E, letto dal set: `Exit_stop=600`, `Exit_limit=1700`, `ST1_MinDist_to_HL=550`, `ST1_Expiration_hours=480`; `Risk=0`, `StartLots=0,1`, `EP=RF=TR=0`, candela di conferma ON, NFP OFF, `ST1_Timeframe=D1`):
| Parametro | Valori (5) | C0 |
|---|---|---|
| `Exit_stop` | 300, 450, **600**, 750, 900 (passo 150; 300 = pavimento 50%) | centro |
| `Exit_limit` | 900, 1300, **1700**, 2100, 2500 (passo 400; 900 >= 50%) | centro |
| `ST1_MinDist_to_HL` | 350, 450, **550**, 650, 750 (passo 100) | centro |
| `ST1_Expiration_hours` | 96, 192, 288, 384, **480** (passo 96, multiplo di 24) | **bordo alto**: il template arriva a 500, quindi 480 e gia il massimo possibile; su questo asse C0 ha vicini solo da un lato |
- **625 passaggi**; il centro (600/1700/550/480) e esattamente C0.
- **Criterio Custom max con minimi a zero**: nel template Goldtrade Pro `EP=RF=TR=0`, quindi nessun minimo di Wim da lasciare. Con una griglia completa tutti i 625 passaggi sono eseguiti e salvati: la scelta si fa dopo, con le regole della sezione 5. (La lezione del pilota EURUSD, "il mio minimo di expected payoff penalizzava i profili sicuri", non si ripete.)
- Nel `.set` del GTP E sono attivi per default 14 parametri (`||Y`): lo script li porta tutti a N tranne i 4 sopra. Il resto vale come in C0.
- **Nota di lettura:** la zona stabile (sezione 5) sull'asse scadenza avra solo vicini "in giu"; per quell'asse "70% dei vicini" si calcola sui vicini che esistono.
- Quel che C0 e: la versione GOLD\Goldtrade Pro del GTP E (SHA256 `B56985DA...`, NFP OFF), non quella del portafoglio live (NFP ON, SHA `9035AB4F...`). Dichiarato.

## 13. Orologio e fusi orari (15/11/2026 23:20, su richiesta di Claudio: "occhio sempre all'orologio ed ai fusi")
Regola CLAUDE.md: server BCM = **GMT+1 FISSO** (ora italiana in inverno, un'ora indietro in estate). FTMO: server = ora italiana + 1 (GMT+2 inverno, GMT+3 estate). Il PC di backtest mostra l'ora italiana (22:35 il 15/11 nella foto, coerente).
1. **Periodi di test:** tutte le date (IS 2013-2022, OOS 2023-2024, tick 2024-07/2024-12 e 2026-01/2026-10, hold-out 2025) sono **date del server BCM**: nessun problema di fuso per gli intervalli.
2. **Il set base (GTP E) non ha orari di sessione:** `UseTradingTimeZones=false`, finestre 00:00-23:59 tutti i giorni, NFP/IR/CPI OFF. `AutoGMT=true` con offset 3/2 (sono gli offset tipici di un server a GMT+2/+3 come FTMO: **nel tester su BCM non ho verificato come li usa**). Per questo set l'orologio conta poco per gli ingressi; **non conta per le date, conta per la candela D1.**
3. **Limite materiale (dichiarato ora):** la **candela giornaliera cambia taglio fra BCM e FTMO.** BCM (GMT+1 fisso) apre il D1 alle 23:00 UTC tutto l'anno; FTMO (GMT+2/+3) lo apre alle 22:00 UTC in inverno e alle 21:00 UTC in estate (circa la chiusura di New York). Massimi/minimi giornalieri, forza degli HL e livelli di rottura (`ST1_Timeframe=D1`) **sono quindi leggermente diversi** fra i due dati; il guadagno trovato su candele BCM **non e garantito sulle candele FTMO**. Per l'ottimizzazione e i test non si puo cambiare.
4. **Controllo aggiuntivo V6 (solo finalisti, se esiste):** rifare la passata del finalista e di C0 sul terminale di prova FTMO gia presente sul PC (`C:\MT5_Backtest\Mt5_Ftmo_Prova`, nel censimento), **se** il suo storico oro copre abbastanza anni (non verificato: da leggere con una riga di sola lettura prima). Un candidato che crolla sulle candele FTMO non entra. Se lo storico FTMO e troppo corto: "non valutabile", dichiarato.
5. **Cambio d'ora:** nessun parametro di orario nel set; le tre settimane di scarto USA/Europa (marzo e ottobre/novembre) cambiano il comportamento nelle news ma il filtro news e OFF. Se un finalista dovesse avere orari, vale la regola estate/inverno del CLAUDE.md.
6. **Scalper Claudio 1.03 (quando si rilancia):** le 6 fasce da 4 ore delle righe EDGE sono in ORA SERVER BCM (GMT+1 fisso), quindi in estate Londra e New York cadono un'ora prima rispetto alla stessa fascia in inverno; le fasce vanno lette separando estate e inverno oppure dichiarando il limite. Il live sul reale (broker diverso) avrebbe un altro fuso: da rifare.
7. **Orari delle mie previsioni di tempo:** tutte in ora italiana (PC); durata in ore, non in orari di server.

## 14. Correzione di un'incoerenza dei miei criteri (16/11/2026 16:30, PRIMA di lanciare V3) e finestre definitive
**Errore mio:** nella sezione 11 (punto 5) la finestra V3 comprendeva **2026-01 -> 2026-10**, e al punto 6 lo stesso periodo era **V4b** (secondo controllo finale "mai usato prima"). Usarlo per V3 mostrerebbe le prestazioni dei finalisti nel 2026 e brucerebbe V4b. **Correzione (valida da ora, prima di qualunque numero a tick):**
- **V3 (tick contro candele) = SOLO `2024-07-01 -> 2024-12-31`** (unico periodo con tick locali che non e ne hold-out ne dentro-campione di scelta... ma e parte dell'OOS 2023-2024 gia visto a candele: si guarda il RAPPORTO tick/candele, non una nuova prova di merito). Circa 11-15 operazioni per candidato: **campione piccolissimo, dichiarato**. Claudio ha approvato (16/11) l'esecuzione "comunque" nonostante il minimo di 30 operazioni non raggiunto; la sua approvazione riguardava il V3 con poche operazioni, **non** l'uso del 2026.
- **V4 (2025) e V4b (2026-01 -> 2026-10):** restano hold-out, aperti UNA volta, e **in quell'occasione ogni finestra si esegue in entrambi i modelli (candele e tick)** cosi il confronto tick/candele si estende su 12 + 10 mesi senza bruciare nulla in anticipo.
- **Finalisti (gia decisi, sezione "Prossimi passi" del referto):** C0 (Wim), C1, C5, C6. Soglie V3 invariate: PF tick/candele >= 0,7; DD tick <= 1,5 x candele; operazioni +-10%.
- **Previsione (scritta ora):** V3 non fallisce in modo netto (rapporto PF >= 0,7 e operazioni +-10%) per i quattro finalisti: 70% (set D1 a stop larghi: sulle misure precedenti Reaper/Goldbot/Phantom il rapporto PF era 0,94 e il netto cambiava di 3-8%).

## 15. Prima corsa V3 (16/11/2026, ore 16:30 italiane): esito tecnico e correzione della finestra (scritta PRIMA di rilanciare)
**Output di Claudio (finestra 2024-07-01 -> 2024-12-31, 8 passate):** candele (M1) **tutte valide**, qualita 100%, 698.547 barre; **tick reali (M4): qualita 95% su tutte e quattro e SOLO C1 ha prodotto numeri** (22.760.888 tick, +527,00, 10 operazioni, PF 4,49, DD 238,17); **C0, C5, C6 a tick: 0 tick, 0 operazioni, profitto 0 = passate non riuscite.**
- **Candele (stessa finestra):** C0 +256,07 / 11 ops / PF 2,12 / DD 326,32; C1 +531,86 / 10 / 4,54 / 241,78; C5 +357,08 / 11 / 2,65 / 307,90; C6 +583,13 / 10 / 6,90 / 204,14.
- **Unica coppia valida (C1):** profitto tick/candele 527,00 / 531,86 = **0,99**; PF 4,49 / 4,54 = **0,99**; DD 238,17 / 241,78 = **0,99**; operazioni 10 = 10. **Soglie V3 rispettate per C1, ma qualita dei tick 95% (sotto il 98% richiesto) e 10 operazioni: indicazione, non prova.** C0, C5 e C6 NON hanno un confronto: **nessuna conclusione su di loro.**
- **Causa del 95% e degli zeri: NON verificata.** Ipotesi: i file tick locali di luglio 2024 iniziano a meta mese (il terminale principale ha i tick "da luglio 2024"), quindi i primi giorni mancano (circa 9 su 184 = 5%) e il tester prova a scaricarli dal server; la passata riesce o fallisce a seconda dell'esito del download (visto lo stesso con i forex a 2023: "connection lost").
- **Correzione (decisa prima di vedere altri numeri a tick):** `VALIDA_TICK_ORO2.ps1` cerca, **solo con C0 e solo a tick**, la prima data di inizio fra 2024-07-10 / 07-15 / 07-22 / 08-01 che da qualita >= 99%; **la scelta non usa nessun risultato di merito** (conta solo qualita e numero di tick). Poi ripete le 8 passate in quella finestra (M1 e M4 per C0, C1, C5, C6) e **ripete le passate a 0 tick fino a 3 volte**, stampando le righe dei giornali sui tick. **Se nessuna data da qualita >= 99%: si ferma e si scrive "V3 non valutabile".** Le soglie restano quelle della sezione 14.
- **Nota di trasparenza:** ho gia visto la coppia C1 (rapporti 0,99 sull'intera finestra). Non influisce sulla scelta della data (che dipende solo da qualita e tick).

## 16. Esito V3 (16/11/2026, 2a corsa) e regole definitive di V4 / V4b (scritte PRIMA di aprire l'hold-out)
**V3 (finestra 2024-07-10 -> 2024-12-31, scelta perche la PRIMA data provata ha dato qualita tick 100% e 22.269.590 tick; i risultati a candele sono identici a quelli della finestra dal 1 luglio: nei primi 9 giorni nessuna operazione).** Output di Claudio:
| Finalista | Candele: profitto / ops / PF / DD | Tick reali: profitto / ops / PF / DD | Rapporti profitto / PF / DD |
|---|---|---|---|
| C0 (Wim) | 256,07 / 11 / 2,12 / 326,32 | 250,41 / 11 / 2,09 / 323,29 | 0,98 / 0,99 / 0,99 |
| C1 | 531,86 / 10 / 4,54 / 241,78 | 527,00 / 10 / 4,49 / 238,17 | 0,99 / 0,99 / 0,99 |
| C5 | 357,08 / 11 / 2,65 / 307,90 | 352,59 / 11 / 2,62 / 304,61 | 0,99 / 0,99 / 0,99 |
| C6 | 583,13 / 10 / 6,90 / 204,14 | 578,10 / 10 / 6,80 / 196,20 | 0,99 / 0,99 / 0,96 |
- **Tutti e quattro passano V3** (rapporto PF >= 0,7, DD tick <= 1,5 x candele, operazioni uguali): **i tick riducono il profitto dell'1-2%, non cambiano il quadro.** I tre candidati conservano il vantaggio su Wim anche a tick (profitto 353-578 contro 250). **Limiti:** 10-11 operazioni per finalista in 5,7 mesi: campione piccolissimo; periodo gia visto a candele nell'OOS 2023-2024. Prima corsa fallita per i tick dei primi giorni di luglio (qualita 95%, tre passate a zero): causa non verificata, la finestra dal 10 luglio e pulita.
**Regole definitive di V4 (2025-01-01 -> 2025-12-31) e V4b (2026-01-01 -> 2026-10-31), aperte UNA volta, per C0, C1, C5, C6, in ENTRAMBI i modelli (candele e tick reali):**
- **Un finalista "passa" una finestra** se, **a tick reali**: PF >= 1,20, profitto > 0, **rendimento/DD (profitto / DD in euro) >= quello di C0 nella STESSA finestra**, DD massimo equity <= 5% del deposito; e il rapporto tick/candele (PF >= 0,7, DD <= 1,5 x, operazioni +-10%) tiene.
- **Esito per finalista:** "ROBUSTO" solo se passa **sia V4 sia V4b**; "MISTO" se passa solo una (non si adotta); "NO" se nessuna. **Se un finalista non e confrontabile in una finestra (passata fallita o qualita tick < 99%), la finestra e "non valutabile" e l'esito massimo e "MISTO".**
- **Avvertenza scritta ora:** il 2025 e un anno di forte rialzo dell'oro (come il 2023-2024): un target piu lontano lo favorisce per costruzione; **un successo nel 2025 da solo NON basta**, e per questo conta V4b (2026). Se anche il 2026 e un rialzo, il risultato non distingue "robusto" da "regime favorevole"; **lo dichiarero nel referto.**
- **Una volta letti i numeri non si cambiano ne finalisti ne soglie.** Contatore di campagna (oro): 625 + 625 (griglia invalida, non usata) + 33 + 8 + 8 + 16 passate.
- **Previsioni (scritte ora):** almeno 1 finalista ROBUSTO: 55%; tutti e tre i candidati ROBUSTI: 25%; nessun candidato batte C0 nel 2025 a rendimento/DD: 15%; il rapporto tick/candele resta >= 0,9 su PF in tutte le finestre: 80%.

## 17. V6 (trasferimento su dati FTMO): esito della prova di licenza e regole definitive (16/11/2026, scritte PRIMA dei numeri della corsa completa)
**Prova di licenza e profondita (`PROVA_FTMO_ORO.ps1`, output di Claudio, set C0, XAUUSD D1, Modello 1, un anno per passata):**
| Anno | Qualita storico | Barre | Profitto | Operazioni | PF | DD equity |
|---|---|---|---|---|---|---|
| 2013 | 0% | 0 | 0 | 0 | 0 | - (nessuno storico) |
| 2016 | 99% | 258 | +463,90 | 18 | 2,67 | 389,98 |
| 2019 | 100% | 257 | +245,69 | 19 | 1,99 | 203,52 |
| 2022 | 99% | 258 | +931,05 | 22 | 4,67 | 169,24 |
| 2025 | 100% | 257 | **+44,68** | 18 | **1,22** | 238,42 |
- **La licenza funziona sul terminale FTMO** (il set opera: 18-22 operazioni per anno). **Lo storico oro FTMO parte dal 2015-01-02** (log: "history synchronized from 2015.01.02 to 2016.12.30"); il 2013 non esiste.
- **Dato da non ignorare:** C0 nel 2025 con Modello 1: **BCM +243,59 / 22 operazioni / PF 1,96; FTMO +44,68 / 18 operazioni / PF 1,22.** Stesso EA, stesso set, stesso lotto: il profitto scende dell'82%. Cause possibili (NON separate): taglio della candela D1 (BCM 23:00 UTC, FTMO 22:00/21:00 UTC), prezzi e spread storici del feed FTMO, commissioni/specifiche del simbolo nel tester. **Per gli altri anni non ho ancora il confronto sullo stesso anno su BCM.**
- **Errore mio da dichiarare:** nel messaggio e nell'intestazione dello script avevo scritto che il conto FTMO-Demo fosse "una demo di prova". **Dal log il login e `1515150476`, lo stesso conto del Guardian di `C:\FTMO` sul VPS (equity 76.847, 30 ordini pendenti).** Il tester NON invia ordini e `AllowLiveTrading=false`; nessun grafico con EA e stato lanciato. Rischio concreto: basso; ma il terminale e collegato al conto reale della challenge. **Raccomandazione: usare per i test un conto FTMO Free Trial separato** (stesso server FTMO-Demo, stessi dati) e lasciare questo terminale spento.
**Regole V6 (Modello 1 su entrambi i broker; i tick FTMO non sono scaricati):** 4 finalisti x 4 finestre (2015-01-01 -> 2022-12-31; 2023-2024; 2025; 2026-01-01 -> 2026-10-31) su FTMO e BCM, stessi parametri.
- **Una finestra "passa" per un finalista su FTMO** se profitto > 0, PF >= 1,15 e rendimento/DD (profitto / DD euro) >= quello di C0 **su FTMO nella stessa finestra**.
- **Trasferimento riuscito** se passa **almeno 3 finestre su 4, inclusa 2015-2022.** Altrimenti "NON TRASFERITO" (non si adotta su FTMO).
- **Si riportano anche i rapporti FTMO/BCM** (profitto e PF) per ogni finalista e finestra; **il confronto non attribuisce la causa** (taglio, prezzi, spread): per isolare il solo taglio resta l'opzione B (simbolo personalizzato dai minuti BCM).
- **Previsioni (scritte ora):** C1 trasferito (>= 3 finestre su 4): 55%; C0 su FTMO ha PF piu basso che su BCM in almeno 3 finestre su 4: 80%; il vantaggio di C1 su C0 resta nella finestra 2015-2022 su FTMO: 65%; tutti e tre i candidati trasferiti: 35%.
