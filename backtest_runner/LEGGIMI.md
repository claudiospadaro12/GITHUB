# backtest_runner - architettura ibrida (Claude Code programma e analizza, MT5 calcola)

**STATO: tutto SCRITTO ma NON PROVATO su Windows.** Nel sandbox dove e stato scritto non c'e PowerShell ne MetaEditor: gli script sono stati controllati solo con il controllo collisioni (`../backtest_pipeline/controlla_collisioni_ps1.py`), con il conteggio delle parentesi e (per i .py) eseguiti davvero. Il primo errore che vedi, incollalo in chat com'e.

## Il disegno in 5 pezzi
```
Claude Code (sandbox)                         PC di backtest (Windows, MT5 chiuso)
---------------------                         ------------------------------------
Template_EA_Wim.mq5  (EA modulare)  ---zip--> Compila_EA.ps1 -> Template_EA_Wim.ex5
SetGenerator.py -> 3 set di profilo ---zip--> Run_MT5_Engine.ps1:
                                                .set -> config.ini -> terminal64 (headless, ShutdownTerminal=1)
                                                -> attende la chiusura -> legge il report -> verdetto
                                                -> Validati_Pronti_Per_Mercato\  oppure  elimina (-Scartati Sposta: Scartati\)
Analisi e nuovi set  <--- esiti.csv negli appunti (Ctrl+V in chat)
```
1. **Template_EA_Wim.mq5** - EA con 43 input: ingresso BREAKOUT/RETEST/LIMIT; stop ATR/punti/lato opposto; target in R/ATR/punti; break-even; trailing; rischio a lotto fisso o in %; tetti di perdita; filtri spread/sessione/EMA.
2. **SetGenerator.py** - scrive `Set_profili/Wim_PropFirm_LowRisk.set`, `Wim_Real_MidRisk.set`, `Wim_Aggressive.set` (+ `--modalita-tutte` = 9 set con i 3 ingressi). Controlla ogni chiave contro gli input del template: se non coincidono si ferma. Solo il RISCHIO cambia tra i profili: la struttura del trade e uguale, cosi il confronto e pulito. Sono profili di PROVA, non consigli di taglia.
3. **Run_MT5_Engine.ps1** - il ponte. Per ogni set: dentro-campione (PF > 1,5, >= 100 operazioni, profitto > 0, DD% sotto il tetto del profilo: 4 / 8 / 15), fuori campione (PF >= 1,25, >= 20 operazioni, DD sotto il tetto), tick reali (PF tick/candele >= 0,7). Superato tutto -> `Validati_Pronti_Per_Mercato`. Fallito -> eliminato (default, come chiesto) con il motivo in `Risultati\esiti.csv`; `-Scartati Sposta` li tiene in `Scartati`. **Se il report non si legge non elimina niente.**
4. **Compila_EA.ps1** - compila senza aprire MetaEditor: copia il .mq5 in `MQL5\Experts\CLAU12\` e lancia `metaeditor64.exe /compile /include /log`.
5. **BacktestRunner.ps1 + GeneraSet_Wim.py + Mappa-Parametri.py** - il filone precedente per gli EA ABTG gia esistenti (EMA200 EURUSD H4: baseline + 8 vicini + 9 L9, filtro walk-forward, perturbazione).

## "Compilare senza compilatore a riga di comando"
MT5 contiene il compilatore dentro MetaEditor. Due modi:
- **A mano (sicuro):** apri MetaEditor (F4 da MT5) -> File -> Apri -> `MQL5\Experts\CLAU12\Template_EA_Wim.mq5` -> **F7**. Se ci sono errori, copia il testo esatto della scheda "Errori" in chat.
- **Da riga:** `.\Compila_EA.ps1 -Dati C:\MT5_BCM_Opt -Portable` (MT5 e MetaEditor chiusi). Stampa il log e "COMPILATO" solo se `0 errors` e il .ex5 esiste.

## Come far partire il ciclo (in quest'ordine, uno step alla volta)
1. Estrai lo zip in una cartella sul PC di backtest (la riga di installazione lo fa sul Desktop).
2. `python SetGenerator.py` (sul PC, se hai Python) **oppure** usa i set gia inclusi in `Set_profili\`.
3. `.\Compila_EA.ps1 -Dati C:\MT5_BCM_Opt -Portable` -> deve scrivere COMPILATO. Se no, F7 a mano e incollami gli errori.
4. `.\Run_MT5_Engine.ps1 -Config .\config_Template_ORO_BCM.json -Cartella .\Set_profili -Modo Prova` -> stampa il `.ini`: controlla che ci siano TUTTI gli input. Non lancia MT5.
5. **Controllo (una passata sola, un set):** `.\Run_MT5_Engine.ps1 -Config .\config_Template_ORO_BCM.json -Set .\Set_profili\Wim_Real_MidRisk.set -Modo Esegui -Scartati Sposta` (con Sposta non perdi niente al primo giro). Verifica a mano nel tester che profitto/PF/operazioni coincidano con quanto stampato.
6. Solo dopo: `-Cartella .\Set_profili -Modo Esegui`.
7. Incolla in chat gli esiti (sono negli appunti). Io leggo, scrivo i criteri del giro dopo e rigenero i set.

## Cosa NON e verificato (leggi prima di fidarti)
- **Formato del report.** Gli script leggono il report **HTML** (come i nostri script dell'oro, che hanno funzionato) con etichette italiane e inglesi. Un report **XML** per una passata singola non l'abbiamo mai visto: il motore lo cerca solo come ripiego, col medesimo metodo, non verificato. L'XML sicuro e quello della griglia di ottimizzazione (diverso, non letto da questi script).
- **DD in %.** Il motore usa il valore piu alto tra il % della riga "massima", il % "relativo" e (DD in denaro / deposito): prudente, ma le etichette "Relativa" in italiano sono ipotizzate.
- **Template_EA_Wim.mq5 non e mai stato compilato.** Puo avere errori di sintassi. La logica non e provata: prima di leggere qualunque PF, 1 passata di controllo con le operazioni guardate a mano nel visualizzatore.
- **Ora legale/solare:** i set generati non usano il filtro di sessione (`InpUseSession=false`). Se lo attivi, le ore sono ORA SERVER BCM (GMT+1 fisso: DAX 8 in estate/9 in inverno) e vanno cambiate due volte l'anno.
- **Nome file:** `Template_EA_Wim` e un nome di lavoro; per una copia di produzione vale la regola `CLAU12_...`.
- **Retest e Limit non sono logica di Wim** (vedi REGOLE_WIM.md).
- Il "PF > 1,5 dentro-campione" con tante prove produce falsi positivi: il contatore `tentativi.json` serve a ricordartelo. Un set in `Validati_Pronti_Per_Mercato` ha superato i filtri sullo storico, **non e pronto per un conto**: prima forward in demo.
