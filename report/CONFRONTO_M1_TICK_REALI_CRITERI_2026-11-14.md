# Confronto candele da 1 minuto (Modello 1) contro tick reali (Modello 4) sui nostri EA: CRITERI E PREVISIONI (scritti PRIMA di guardare i numeri, 14/11/2026)

**Domanda**: i nostri test a Modello 1 (OHLC 1 minuto, usato per 2013/2018/2020 e in parte 2025) sono affidabili rispetto ai tick reali? Soglie prese dal video UBS Optimizer di Wim (lette da un fotogramma a bassa risoluzione, quindi da ricontrollare), applicate a coppie dello STESSO set, STESSO anno e STESSO deposito 80.000 EUR gia in archivio.

**Coppie disponibili** (cartelle `risultati_archivio/`): Reaper `ANNO80K_REAPER_MAXDD_20261029_0416` (2025_M1 contro 2025_M4, DD12 e DD15; il M4 copre 2025.01.01-2026.10.01, lo confronto solo sulle operazioni chiuse nel 2025); Goldbot `ANNO80K_GOLDBOT_ZIP_1608` (2025_M1 contro 2025_M4); Daytrade Pro `ANNO80K_DTP_20261028_0253` (PROPFIRM_R27, 2025_M1 contro 2025_M4); Goldbot set venditore `ANNO80K_GOLDBOT_SETVEND_20261030_0145` (21M_M1 contro 21M_M4, PF105). Phantom e Gold Trade Pro: NON ci sono coppie M1/M4 (non confrontabili).

**Metriche e soglie (di Wim, per un candidato)**: rapporto profit factor tick/M1 >= 0,7 = PASS, < 0,5 = FAIL, in mezzo = CAUTION; drawdown a tick reali <= 1,5 volte quello M1; numero di operazioni diverso al massimo 10%; win rate diversa al massimo 10 punti percentuali. Aggiungo (MIA misura, non di Wim): rapporto del profitto netto tick/M1 e drawdown sul SALDO (le operazioni chiuse): il drawdown dell'equity del solo 2025 non si ricava dal M4 a 21 mesi.

**Previsioni (fissate ora)**
1. Reaper: ordini pendenti con trailing e filtri sul candle; con M1 le operazioni di ingresso/uscita nella stessa barra sono risolte in modo ottimistico. Prevedo PF tick tra 0,6 e 0,95 del PF M1 (CAUTION o PASS), numero di operazioni diverso piu del 10%, win rate vicina (entro 10 punti), DD saldo tick >= DD saldo M1.
2. Goldbot: strategie su barre; prevedo PASS su tutte le metriche (PF ratio >= 0,8, operazioni entro 10%).
3. Daytrade Pro (D1): prevedo PASS pieno.
4. Direzione dell'errore: il M1 sovrastima il profitto netto rispetto ai tick reali nella maggior parte delle coppie (previsione: 4 coppie su 5 con netto tick < netto M1).
**Cosa farebbe cambiare i miei numeri**: se il Reaper risulta FAIL (PF ratio < 0,5) o DD tick > 1,5 volte M1, le stime su Reaper a Modello 1 (P4, REAPER_SOLO, bundle) vanno ridimensionate; se risultano PASS, restano come sono.

**Limiti dichiarati prima**: 1 anno (2025) e 5 coppie; il saldo parte uguale ma i lotti dipendono dal saldo (MaxAllowedDD), quindi i profitti si compongono diversamente; il Reaper ha Randomization (rumore proprio, anche tra due run identiche); i set confrontati non sono tutti i nostri set Prop (DD12/DD15 sono varianti di MaxAllowedDD).

---
# RISULTATI (14/11/2026, dopo i criteri sopra)

**Metodo**: dai report HTML del tester (BCM, deposito 80.000 EUR, XAUUSD) ho estratto le operazioni chiuse (tabella "Affari") e calcolato, sulla STESSA finestra, PF, win rate, numero di operazioni, netto e drawdown sul saldo (operazioni chiuse). I totali coincidono con le intestazioni dei report (es. Goldbot 237 operazioni; Reaper M4 791 su 21 mesi). Un errore mio iniziale (confronto di date con punti contro trattini, che troncava la finestra dei 21 mesi) e stato corretto prima di scrivere i risultati. Script: `/tmp/claude-0/work/m1tick.py` (non nel repo). Daytrade Pro: la run a tick reali risulta **KO** (manifest vuoto): NON CONFRONTABILE. Phantom e Gold Trade Pro: nessuna coppia.

| Coppia (stesso set, stesso deposito) | Finestra | PF M1 / tick (rapporto) | Netto M1 / tick (rapporto) | Operazioni M1 / tick | Win rate M1 / tick | DD saldo M1 / tick (rapporto) | Peggior giorno chiuso M1 / tick |
|---|---|---|---|---|---|---|---|
| Reaper DD12 | 2025 | 2,81 / 2,63 (0,94) | 43.316 / 39.912 (0,92) | 497 / 499 (+0,4%) | 72,0 / 71,5 | 4,08% / 4,36% (1,07) | -1,49% / -1,50% |
| Reaper DD15 | 2025 | 2,34 / 2,19 (0,94) | 42.477 / 38.353 (0,90) | 491 / 493 (+0,4%) | 70,7 / 70,2 | 5,39% / 5,50% (1,02) | -4,20% / -4,04% |
| Goldbot (set ZIP) | 2025 | 2,58 / 2,38 (0,92) | 8.571 / 7.871 (0,92) | 237 / 236 (-0,4%) | 54,9 / 55,1 | 1,26% / 1,33% (1,05) | -0,85% / -0,86% |
| Goldbot (set venditore PF105) | 21 mesi (2025-01 / 2026-09) | 1,85 / 1,67 (0,90) | 31.847 / 26.557 (0,83) | 451 / 449 (-0,4%) | 52,8 / 53,0 | 5,76% / 7,75% (1,35) | -2,57% / -2,96% |

Drawdown dell'equity sull'intera durata (dai report): Goldbot PF105 6,05% (M1) contro 7,62% (tick) = 1,26; Goldbot ZIP 1,55% contro 1,58%. Per il Reaper il DD equity dei report non e confrontabile (M1 = 2025, tick = 21 mesi).

## Verdetto con le soglie di Wim (PF >= 0,7; DD <= 1,5 volte; operazioni entro 10%; win rate entro 10 punti)
**4 coppie su 4 PASS su tutte le metriche.** Confronto con le previsioni scritte prima:
1. Reaper: PF ratio previsto 0,6-0,95 -> 0,94 (nei limiti, a fondo scala alto); "operazioni diverse piu del 10%" -> **SBAGLIATA** (+0,4%); win rate entro 10 punti -> giusta; DD saldo tick >= M1 -> giusta (1,02-1,07).
2. Goldbot: PASS -> giusta.
3. Daytrade Pro: NON VERIFICABILE (run a tick reali KO).
4. Direzione: netto tick < netto M1 in 4 coppie su 4 -> giusta. **Il Modello 1 sovrastima il netto di circa 8-17% e il PF di circa 6-10%.**
Nessuno dei criteri che cambierebbero le mie stime e scattato (nessun FAIL, nessun DD tick > 1,5 volte M1).

## Cosa ne segue (e cosa NON ne segue)
- Le stime a Modello 1 sono **affidabili nella forma** (stesse operazioni, stesso win rate, giorni peggiori quasi uguali), ma **ottimistiche sui profitti**: i tempi per +10% / +5% (che dipendono dal netto) sono sottostimati di circa 10-20% se la differenza vale anche per gli altri anni. NON MISURATO su 2013/2018/2020: i tick reali BCM esistono solo dal 2025 nei nostri dati.
- Il **drawdown e piu alto a tick reali**, da +2% a +35%; la coppia con la finestra piu lunga (21 mesi, Goldbot) ha il rapporto peggiore (1,35 sul saldo, 1,26 sull'equity). Il peggior giorno chiuso del Goldbot PF105 passa da -2,57% a -2,96% (+15%).
- **Il margine di P1 sul limite del 5% e stretto**: la parte oro (Goldbot L0 + Phantom L1) ha avuto il peggior giorno equity -4,46% (31/12/2013, M1; -4,69% con i costi centrali): margine 0,3-0,5 punti. Se a tick reali il giorno peggiore salisse del 15% (come il Goldbot PF105) andrebbe a -5,1/-5,4%. Non e una previsione: la differenza M1-tick e stata misurata solo nel 2025 e su altri set; per il 2013 NON MISURATO. Rafforza pero la regola gia fissata: Guardian a 4,3% e nessuna taglia aumentata.
- I **fail% a 0%** di P1/P3/P4 e la tabella Reaper v2 vanno letti con questa avvertenza (non cambio le cifre: non ho dati per correggerle).
- Il comportamento del Reaper (trailing, ordini pendenti) NON mostra la differenza che prevedevo: il Modello 1 ricostruisce le sue operazioni quasi identiche.
- **Limiti**: 1 anno e 4 coppie; Reaper con Randomization (in questi test valore non verificato qui); le coppie Reaper sono varianti DD12/DD15, non il set Prop L0/L3; Phantom, Gold Trade Pro e Daytrade Pro non sono coperti.

---
# TAPPA 2 (14/11/2026): criteri e previsioni fissati PRIMA di lanciare la riga

**Cosa si lancia**: i componenti oro di P1 e P4 a TICK REALI (Modello 4), anno 2025 (2025-01-01 -> 2026-01-01), deposito 160.000 EUR, XAUUSD, set ufficiali di `combodeal.zip` applicati con -SetFile, STESSI input e STESSO deposito delle passate a candele gia in archivio (`D160_R1_*_2025` e `D160_R2_*_2025`, Modello 1). 3 passate: Goldbot Prop (L0, `Goldbot_PropFirm_5_2.5.set`), Phantom Gradino 1 (L1, `GoldPhantom_Propfirm.set`), Reaper Combo (L3, `Gold_reaper_propfirm_combo_3GOLD.set`). Phantom e Reaper hanno Randomization 50 (rumore): per misurare il rumore uso le due ripetizioni a candele (R1, R2) come "banda"; una sola passata a tick per EA. Le passate a candele NON si rilanciano.

**Confronto**: sulle operazioni chiuse nel 2025, stesse metriche e soglie di Wim di sopra (PF tick/M1 >= 0,7; DD saldo tick <= 1,5 volte M1; operazioni entro 10%; win rate entro 10 punti) piu il peggior giorno chiuso. Un risultato a tick reali "dentro la banda M1" (tra il minimo e il massimo di R1 e R2) NON e distinguibile dal rumore.

**Previsioni (fissate ora)**
1. Goldbot L0 (deterministico): PASS pieno; PF ratio 0,85-1,0; operazioni entro 3%; peggior giorno tick fino a +15% rispetto a M1.
2. Reaper L3 (strategie a basso rischio, pochi ordini): PF ratio 0,85-1,05, DD tick fino a 1,3 volte M1; la differenza M1-tick sara piccola o dentro la banda del rumore.
3. Phantom L1: la piu incerta: PF ratio tra 0,7 e 1,0, DD tick fino a 1,5 volte M1; probabilita che almeno una metrica esca dalla banda del rumore: circa 40%.
4. Direzione: netto tick < netto M1 per i tre EA (mi aspetto 3 su 3; accetto 2 su 3 come "confermata").
**Cosa cambierebbe i miei numeri**: se un EA risulta FAIL (PF ratio < 0,5) o DD tick > 1,5 volte M1, le tabelle P1/P4 vanno corrette per quell'EA; se tutte e tre sono dentro le soglie, la sola avvertenza resta quella gia scritta sopra (tempi +10-20%, DD +2-35%).
**Limiti dichiarati**: un solo anno (2025); una passata a tick per EA rumoroso; il 2013 (anno del peggior giorno) non e confrontabile (nessun tick reale BCM); deposito 160.000 invece di 80.000 (le percentuali si confrontano, i lotti scalano con il saldo).

---
# TAPPA 2, VARIANTE A 80.000 EUR (14/11/2026, su osservazione di Claudio: le challenge sono da 80k)
Il test della Tappa 2 era stato preparato a 160.000 EUR per confrontarlo con le passate a candele D160. Ma le challenge Swing sono da 80.000 e, nei nostri dati D160 (`RISULTATI_D160_ORO_2026-11-09.md`), il **Reaper Combo (L3) NON scala col doppio** (rapporto 160k/80k = 2,93 nel 2013 e 1,61 nel 2020; Phantom Gradino 1 2,03-2,20): per quell'EA un risultato a 160k non rappresenta il conto da 80k. Per questo e stata preparata la variante **TICK80** (`BOOT_RIGA_TICK80_ORO.txt`: pin b535ac31, SHA256 BEBE11FE...): stesse 3 passate, deposito 80.000. Le passate a candele da confrontare sono quelle a 80.000 della griglia ANNO_ORO_GRADINI (2025: L0 Goldbot, L1 Phantom, L3 Reaper; dati in `ORO_GRADINI_dati/oro_agg.json`). Criteri, soglie e previsioni della Tappa 2 restano invariati (scritti prima). Con 80k i lotti sono la meta: l'arrotondamento a 0,01 pesa di piu, soprattutto sul Reaper L3.

---
# TAPPA 3 (14/11/2026): PHANTOM A TICK REALI SUL 2026, contro il segnale di Wim e il nostro trial. CRITERI E PREVISIONI scritti PRIMA di lanciare la riga

**Domanda**: il divario tra il Phantom in tester (2025: PF 2,87-2,90, 1.105 operazioni, +25% su 160k) e il Phantom live (segnale Darwinex di Wim dal 27/01/2026: PF 1,07-1,08, 692 operazioni in 48 settimane; nostro trial FTMO ottobre-novembre: 25 operazioni, PF 0,26; reale 12 operazioni, PF 0,40) e dovuto al PERIODO (2026 diverso dal 2025), al CAPITALE PICCOLO del segnale (2.000-5.000 USD) o a COSTI/ESECUZIONE e impostazioni?

**Passate** (Gold Phantom `GoldPhantom_Propfirm.set` = Gradino 1 = L1, XAUUSD H1, Modello 4 tick reali, 01/01/2026 -> 13/11/2026, set ufficiale da `combodeal.zip`, nessun input cambiato): (A) deposito **80.000 EUR** (la nostra configurazione P1); (B) deposito **5.000 EUR** (approssima il segnale Darwinex, 5.000 USD circa, capitale versato). Il Phantom ha Randomization 50: una passata ciascuno = un solo percorso; il rumore a 80k lo stimo dalle due ripetizioni a candele del 2025 (R1 contro R2: netto 40.190 contro 41.576, PF 2,87 contro 2,90).

**Metriche**: profit factor, operazioni totali e per settimana, win rate, netto in %, peggior mese, segno dei mesi (confronto con la tabella mensile del segnale, che mi dovra dare Claudio come schermata), PF del sotto-periodo 20/10-12/11/2026 (stesso del trial).

**Previsioni (fissate ora)**
1. A (80k): PF tra 1,8 e 3,5: probabilita 65%. Operazioni per settimana 18-25 (nel 2025: 21): probabilita 70%.
2. B (5k): meno strategie attive (TradeFrequency Auto sceglie in base al saldo) e lotti arrotondati: operazioni per settimana pari al 40-70% di A: probabilita 55%; PF di B tra A-0,6 e A+0,6: 50%.
3. Il PF del segnale (1,07) NON viene riprodotto da A ne da B (nessuna delle due sotto 1,5): probabilita 70%. Se questo accade il divario non si spiega con periodo e capitale: restano costi/esecuzione e impostazioni diverse del segnale.
4. Segno dei mesi di A uguale al segnale in almeno 6 mesi su 10: 55%.
5. Sotto-periodo 20/10-12/11: PF di A inferiore a quello dell'intero periodo: 60%.

**Regole di lettura (decise ora)**
- A con PF >= 1,8: il tester regge nel 2026; il divario col segnale non e da periodo; passa a costi/impostazioni (e il Phantom resta "non validato dal vivo"), nessuna correzione ai tempi di P1.
- A con PF tra 1,4 e 1,8: 2026 piu debole del 2025; ricalcolare i tempi di P1 con il Phantom ridotto; avvertenza esplicita.
- A con PF < 1,4: il Phantom 2026 e molto sotto al 2025: P1 va rivisto (tempi, e se sostituire il Phantom con altro nella parte oro) PRIMA di comprare le challenge.
- B molto peggio di A (PF di B < A - 1,0 oppure operazioni < 40% di A): il capitale piccolo spiega il segnale; l'80k resta il riferimento.
**Limiti**: un solo percorso con rumore; impostazioni del segnale NON note; periodo parziale (1/1-13/11); il segnale e in USD su Darwinex; nessun costo FTMO.
