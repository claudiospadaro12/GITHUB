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
