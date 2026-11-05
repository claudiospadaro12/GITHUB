# Guardian, finestre di partenza, anni e orari — pacchetto Wim — 05/11/2026
Seguito di `RISULTATI_TEST_80K_2026-11-05.md`. Script: `analisi/wimlib.py`, `guardian_finestre_wim.py`, `anni_e_orari_wim.py` (dati in `analisi/*.json`). Eventi = deal dei report del tester (88 passate Wim + trio oro già testato: Reaper, Goldbot PF525, Phantom; anni 2013, 2020, 2025). Nessun test nuovo: sono letture dei report che già avevamo.

## 1. Guardian simulato e finestre di partenza (stesso metodo del GTP)
Metodo: giorno di calendario del server, base 80.000 fissi, Guardian a −4,3% giornaliero e −9,3% totale. **Modello A** (si ferma esattamente a −4,3%), **modello B** (si ferma al deal che supera la soglia), **nessun Guardian**. Finestre di 14 giorni (obiettivo +5% = 4.000) e di 60 giorni (obiettivo +10% = 8.000); passa se tocca l'obiettivo prima di −5% in un giorno o −10% dal deposito.
**Limite decisivo, da leggere prima dei numeri**: la simulazione lavora sul **realizzato** e scarta i deal successivi al taglio; non vede la perdita con le posizioni aperte. Per le **griglie** (Apex, Stability Pro) è **ottimistica**: la chiusura della griglia che realizza −21…−34% in un giorno è fatta di posizioni già aperte che il Guardian non può far sparire; il modello B che «riduce» quel giorno a −4% è un **artefatto**. Per le griglie va letto solo il caso «senza Guardian». Per Daytrade Pro, Luna e il trio (stop fissi, perdite piccole per operazione) l'approssimazione è più credibile.

### 1.1 Combinazioni col trio sull'oro (caso senza Guardian: percentuale di finestre da 60 giorni che toccano +10% prima di un limite / che falliscono)
| Combinazione (stesso anno, 80.000 EUR) | 2013: +10% in 60 gg senza Guardian → pass / fail | 2020 | 2025 | peggior giorno realizzato 2013 / 2020 / 2025 |
|---|---|---|---|---|
| Trio oro da solo | 69% / 13% | 29% / 0% | 46% / 0% | -4805 / -1866 / -1663 |
| Trio + Daytrade Pro lowrisk / Prop | 73% / 21% | 61% / 0% | 49% / 0% | -5099 / -2469 / -1687 |
| Trio + Daytrade Pro mediumrisk | 67% / 32% | 76% / 0% | 56% / 0% | -5569 / -3551 / -2660 |
| Trio + Luna 4%DD | 55% / 29% | 60% / 0% | 83% / 0% | -4805 / -2419 / -1595 |
| Trio + Stability Pro low | 88% / 7% | 70% / 0% | 61% / 0% | -4805 / -1779 / -1545 |
| Trio + Apex Ultra Conservative | 72% / 27% | 93% / 0% | 72% / 0% | -24676 / -5489 / -1501 |
| Trio + Apex Conservative | 78% / 22% | 100% / 0% | 77% / 0% | -33517 / -6711 / -1540 |

Lettura (stessi lotti dei test, non equalizzati tra EA):
- **Il trio oro da solo** tocca il +10% in 60 giorni nel 69% / 29% / 46% delle finestre (2013 / 2020 / 2025), con un solo anno, il 2013, con finestre fallite (13%, senza Guardian: giorni a −6,0%).
- **Daytrade Pro lowrisk aggiunto al trio** alza il passaggio (73% / 61% / 49%) **senza peggiorare il peggior giorno in modo sensibile** (−5.099 nel 2013 contro −4.805; −2.469 contro −1.866 nel 2020; −1.687 contro −1.663 nel 2025). Nessun intervento del Guardian in 2020 e 2025.
- **Stability Pro low** aggiunge velocità (88% / 70% / 61%) con peggior giorno quasi uguale al trio, **ma** da solo ha il 2017 con −20.750 in un giorno e DD assoluta 25.741: l'aggiunta al trio nel 2017 non è stata calcolata (anni in comune col trio: 2013, 2020, 2025).
- **Luna 4%DD**: aiuta nel 2020 e 2025 (60% / 83%), peggiora nel 2013 (55%, DD 11.917 con fallimento 29% senza Guardian).
- **Apex Conservative / Ultra**: velocità altissima (fino al 100%) ma nel 2013 il peggior giorno diventa −24.676 / −33.517: i numeri «con Guardian» di quegli anni **non sono credibili** (vedi il limite sopra).
- **Daytrade Pro da solo non è un acceleratore** (0–8% delle finestre a +10% in 60 giorni; 0–4% a +5% in 14 giorni): è un diversificatore a rischio basso. Il `mediumrisk` è più veloce (fino al 43%) ma fa scattare il Guardian 1–2 volte l'anno.

### 1.2 Effetto realistico del Guardian sulle griglie (letto dall'equity, non dalla simulazione)
Il report dà l'**equity minima**: Apex Conservative 2013 scende fino a −16.718 EUR dal deposito (−20,9%), 2017 −24.703, 2025 −20.155 (pur con peggior giorno realizzato di soli −303). Un Guardian a −9,3% (7.440 EUR) di equity, che controlla ogni secondo, **avrebbe chiuso tutto prima**, limitando la perdita a circa −9,3% invece di −21%…−31%: salva il conto dalla bocciatura, ma **chiude l'anno** (e con la challenge, la prova). Quindi: con il Guardian queste griglie non fanno saltare il conto, ma il Guardian scatterebbe in 3 anni su 5 (2013, 2017, 2025) per Apex Conservative: **non sono compatibili con un'operatività senza interruzioni** su 80k ai lotti dei set. A lotti più piccoli le DD scalerebbero, ma la decisione sui lotti è di Claudio.

## 2. Etichette degli anni (dai prezzi delle operazioni nei report)
Variazione tra il primo e l'ultimo prezzo di operazione dell'anno per simbolo (indicativa: non è il prezzo a gennaio/dicembre). **LONG** = ≥ +5%, **SHORT** = ≤ −5%, **laterale** nel mezzo.
- **2013**: AUDCAD −8% e AUDNZD −14% (short), AUDUSD −15% (short), EURAUD +23% e GBPAUD +19% (long), oro −27% → anno **direzionale contro le griglie sui cross AUD** (Apex/Stability: 2013 il peggiore per quelle sui cross AUD).
- **2017**: AUDNZD +5%, EURUSD +16%, EURNZD +18% (long); AUDCAD, NZDCAD, GBPAUD laterali → anno con **un movimento forte su AUDNZD** (Stability Pro 2017 −6.356, Apex 2017 giornata −26%).
- **2020**: AUDCAD +8%, AUDUSD +10%, NZDUSD +13% (long), oro +23% → anno **long con shock** (marzo).
- **2022**: USDJPY +14%, CHFJPY +13% (long), AUDUSD −7%, EURUSD −7%, GBPUSD −8% (short: dollaro forte).
- **2025**: AUDCAD +1%, AUDNZD +4%, NZDCAD −2% (**laterali** per le tre coppie delle griglie), EURJPY +15%, CHFJPY +15%, oro +67%.
Letture (non causali, solo coincidenze da verificare): le griglie Apex/Stability hanno i giorni da −20/−34% nel **2013 e 2017**, anni in cui AUDCAD/AUDNZD hanno fatto un movimento direzionale; nel **2025 laterale** il realizzato è piccolo ma l'equity oscilla fino a −25% (DD flottante). Daytrade Pro è positivo in tutti i regimi tranne il 2025 (quasi zero) senza una relazione semplice con le etichette.

## 3. Orari degli indici nel tester (ORB Master e Indicement, 2025-01 → 2026-09)
Orari degli ingressi (server) per regime USA:
- **ORB Master**: il 66–79% delle entrate cade alle **14:30 (USA ora legale)** e alle **15:30 (USA ora solare)**, cioè all'apertura del mercato USA con server GMT+1 fisso: **gli orari nel tester sono giusti** (`AutoGMT` ha funzionato). Quindi **la perdita di ORB Master in 21 mesi (7 set su 7) non è un artefatto di fuso orario**.
- **Indicement**: le entrate sono più sparse (più strategie), con picchi a 14:30 / 15:30 (apertura), 16:00–16:30 e alcune ore notturne; coerente con strategie di breakout non solo ORB. Anche qui nessuna anomalia evidente di fuso.
Conclusione: ORB Master e Indicement nel 2025–26 su BCM: **nessun vantaggio** (sezione 1 di `RISULTATI_TEST_80K`), con orari verificati.

## 4. Cosa resta aperto
- **Bitcoin Scalp Pro e Bitcoin Reaper**: non testabili sul BCM. FTMO ha BTCUSD (CFD) con leva 1:3,3 e commissione 0,0325% per lato (fonti ufficiali FTMO, luglio 2025). Serve un terminale FTMO di prova separato sul PC di backtest: **decisione di Claudio** (non tocco il terminale della challenge).
- **UBS**: per ultimo, come deciso. Sul BCM mancano Tesla e petrolio con i nomi dei set; DE40 è D30EUR; US500/US30/USTEC sono SPXUSD/U30USD/NASUSD.
- **Flottante e Guardian reale**: per una misura vera servirebbe la serie di equity del tester (non è nei report). Si può chiedere al tester di esportarla con un EA di supporto o con l'ottimizzazione di un solo passaggio: da valutare.
- Orari di Luna: da verificare allo stesso modo con l'istogramma degli ingressi (non fatto qui).
- Correlazioni e finestre dipendono dai lotti dei set a 80.000: **non sono rischio consigliato**.
