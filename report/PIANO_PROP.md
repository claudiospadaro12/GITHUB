# 🏛️ PIANO PROP — la tabella madre dei parametri per passare una prop

_Prodotto dall'**architetto-prop**. Versione **v14**, aggiornata il 26/08/2026 sera
(prima stesura: 18/08/2026 ~01:00)._
_Un solo documento, vivo: ogni numero ha la sua fonte e il suo stato. Le
modifiche stanno nel CHANGELOG in fondo._

> ⛔ **Niente di questo documento e' applicato da solo.** Gli stati sono tre:
> **PROPOSTO** (argomentato, in attesa di Claudio) · **CONGELATO** (data +
> parola di Claudio: non si riapre senza una misura nuova) · **APERTO** (le
> fonti divergono o mancano — e' scritto cosa serve per chiudere).
> Il forward **non si tocca mai** da qui.

**Gerarchia delle fonti** (risolve i conflitti): 🥇 misurato da noi → 🥈 regole
prop (con etichetta di verifica) → 🥉 convergenza di fonti esterne indipendenti
→ 4° dichiarazione singola. Se una misura nostra contraddice tre video, vince
la misura — e il conflitto si scrive lo stesso.

**Fonti di questo giro** (v1):
- 🥇 `report/METRO_PROP.md` (15/08) · `report/ROBUSTEZZA.md` (15/08) ·
  `report/ROTTA_PROP.md` (09/08) · `report/DOVE_SIAMO_17-08.md` ·
  `backtest_pipeline/risultati_archivio/REFERTO_CENSIMENTO_RISCHIO.md` (17-18/08)
  · `REFERTO_PORTAFOGLIO_R16.md` · `report/DEPLOY_GUARDIANO_100K.md` (09/08)
- 🥈🥉 `backtest_pipeline/caccia_strategie/CONFIG_PROP_2026-08-18.md` (dossier
  del cacciatore-config-prop: 3 preset `.set` [VERIFICATO], censimento 6 prop
  **[LETTO-VIA-SEARCH, non verificato]**, tabella dei 36 buchi) ·
  `PROPOSTE_PROP_2026-08-18.md` (P1-P9)
- il parco com'e' oggi: `FLOTTA_ATTIVA.md` · `mql5/Experts/ABTG_Guardian.mq5`
  (209 righe, letto integralmente) · `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`
- 🥇✍️ **`report/FIRME_2026-08-18.md`** (18/08 mattina, parola esatta di
  Claudio: **"firma tutte e 3"** — incorporato al **quinto giro, v5**): il
  verbale delle tre firme (pacchetto Guardian · criterio di uscita a tre
  corsie · cap 3,25%), con la regola di ripensamento (si riapre solo con una
  misura nuova, per iscritto, mai a caldo)
- 🥇 **`REFERTO_M1_MC_TRAILING.md` + `REFERTO_M2_SOVRAPPOSIZIONE.md`**
  (18/08 mattina, **incorporati al quarto giro, v4**): le due misure a costo
  zero della sezione "COSA MANCA" **ESEGUITE** — criteri congelati PRIMA dei
  numeri (`prove/M1_MC_TRAILING_CRITERI.md` commit `2ae7077`,
  `prove/M2_SOVRAPPOSIZIONE_CRITERI.md` commit `0233835`), script
  riproducibili (`mc_trailing.py` seed 42, `sovrapposizione_sedie.py`)
- 🥉 `CONFIG_PROP_RACCOLTA_SET_2026-08-18.md` (seconda notte del cacciatore,
  **incorporato al terzo giro, v3**): **50 `.set` nuovi da 11 fonti**, 75 file
  in `biblioteca/` (indice: `biblioteca/CATALOGO.md`, ora con stanza `dati/`).
  Correzione d'evidenza sul 4/9 (Gold Reaper e Gold Phantom = STESSO autore,
  Profalgo/WSC), buco n.8 tappato due volte, **filtro news backtestabile via
  CSV**, canale di blocco fra EA trovato in natura (The Impossible Prop)
- 🥇 `CANCELLO_ACQUISTI_EA.md` (18/08 notte, **decisione di Claudio**: "sono
  disposto a pagarli" — procedura d'acquisto EA a 5 gradini + 1-bis, congelata
  prima dei casi)
- 4° **script CrewAI/articolo incollato da Claudio in chat (18/08 ~01:10)** —
  dichiarazione singola, non nostro codice, NON eseguito: schedate solo le 4
  voci con valore (breaker 4,3-4,5%, equity vs snapshot, snapshot a
  mezzanotte broker, sizing 0,5%); il resto (pipeline senza backtest reale,
  news via WebRequest) non porta valore
- 🥉/4° `ANALISI_TRASCRIZIONI_2026-08-18.md` (analista-trascrizioni,
  consegnato — **incorporato al secondo giro, v2**): 11 trascrizioni = **7
  fonti indipendenti** (3 video Petko contano 1, 2 Cash&Prop contano 1).
  **Resa numerica BASSA**: nessun `.set` dettato a voce, zero finestre news in
  minuti, zero ore di reset, zero conferma del pattern 4/9 nel parlato. Il
  marchio 🎬 sulle righe ora significa: **la fonte trascrizioni ha risposto, e
  la risposta e' "niente di numerico"** — il dettaglio riga per riga.

**🆕 Fonti nuove del quattordicesimo giro (v14, 26/08/2026 sera)** — tutte
🥇 misurate in casa salvo dove indicato:
- `backtest_pipeline/risultati_archivio/ANALISI_DIAL_TAGLIE_2026-08-26.md`
  (tradeoff della manopola globale su base R105 riconciliata: pass-rate
  **99,6% a d=1,00**, **dirupo a d≈1,055**, profitto mediano per challenge
  passata quasi piatto **8,5-9,3 k€**)
- `backtest_pipeline/risultati_archivio/ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md`
  (verdetto sull'ipotesi di Claudio "e' piu' difficile passare che restare" +
  **proposta due-dial: challenge 1,00 / funded 0,74**)
- `backtest_pipeline/risultati_archivio/ANALISI_DD_TOTALE_2026-08-26.md`
  (risposta alla domanda di Claudio "col 5% giornaliero, quanto DD totale
  serve?": **DD totale worst −6,37% a d=1,00**, muro 10% = **36% di margine**,
  **il vincolo che morde e' il GIORNALIERO**; e un muro totale **6% trailing
  si romperebbe persino sui chiusi** — seconda strada che conferma la
  bocciatura di Upcomers)
- `backtest_pipeline/risultati_archivio/R109_REFERTO.md` (i due fatti che
  rendono lo scaling **non lineare**: tetto `SYMBOL_VOLUME_MAX`=100 che ha
  tagliato il lotto su **66 trade su 743 = 8,9%**, e slippage **21,5 punti**
  su uno stop reale)
- `backtest_pipeline/caccia_strategie/DOSSIER_PROP_UPCOMERS_2026-08-26.md`
  (🥈/🟡 **[LETTO-VIA-SEARCH 26/08]** — prop **BOCCIATA**: muri 3% daily e 6%
  **TRAILING**, piu' regola dei 2 minuti e one-sided bets)
- `backtest_pipeline/risultati_archivio/R110_REFERTO.md` +
  `R112_CRITERI.md` (**FIRMATI** "FIRMO R110" 25/08 e "FIRMO R112" 26/08):
  lati mai misurati sugli indici, **EMADOW short candidata piena**, e il round
  di contratto che sta misurando **la peggior giornata** della sedia viva
- `backtest_pipeline/risultati_archivio/LETTURA_MISURE_LAMPO_2026-08-26.md` e
  `LETTURA_ANATOMIA_APERTURE_2026-08-26.md` (dati indici: frigo aperto solo a
  NASUSD_EXT; anatomia delle aperture Nasdaq su 16 anni, IS pulito)
- 🥇 **il forward vero, ricontato in questo giro**:
  `data/statements/trades_auto.csv` e `trades_100k.csv` (aggiornati **25/08
  20:47**, chiusure fino al **25/08 15:30**) letti insieme a
  `report/CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md`,
  `backtest_pipeline/TRACKING_FORWARD.md`, `backtest_pipeline/CLASSIFICA_PF.md`,
  `FLOTTA_ATTIVA.md`, `report/FIRMA_REVISIONE_FLOTTA_2026-08-24.md` (firma
  "A+b": 4 sedie spente, 5 ridotte)
- ✍️ `report/FIRME_2026-08-18.md` — riletto per intero in questo giro: e' il
  criterio che regge il **cancello 1** (merito per famiglia a 20 operazioni)
  e il **cancello 2** (censimento dei contratti come prerequisito dichiarato)

---

# 🚦 CANCELLO CHALLENGE — si valuta a CANCELLI VERDI (obiettivo meta'-fine settembre)

> **La domanda di Claudio, 26/08: _"quando possiamo iniziare a valutare una
> challenge? siamo maturi?"_**
>
> ## La risposta, in una riga: **la MACCHINA e' matura sulla carta; le PROVE FORWARD no.**
>
> Non si valuta a calendario e non si valuta "a sensazione": **si valuta a
> CANCELLI VERDI**. Sono **sei** (il sesto nasce il 26/08 sera con
> l'orientamento di Claudio sulla taglia), elencati sotto con lo stato di
> oggi e la fonte di ogni stato. Finche' uno solo e' rosso, la challenge non si compra —
> e la data e' una conseguenza, non un obiettivo. **Obiettivo realistico a
> cancelli come stanno oggi: meta'-fine settembre 2026.**

**Perche' "matura sulla carta"** (🥇 tutte misure di casa, tutte agli atti):
la simulazione rolling su 481 partenze da' **99,6% di challenge passate** alla
taglia firmata, mediana **12 giorni**, **zero violazioni dei muri**
(`ANALISI_DIAL_TAGLIE_2026-08-26.md` T2); la sopravvivenza funded a 12 mesi
e' **100%** (230/230, statico e trailing) alla stessa taglia
(`ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md` T1); il Guardian e' **vivo in
campo** sul 100k con cap e muri firmati (v7, `REFERTO_GUARDIAN_FIRME.md`).

**Perche' "le prove forward no"** — i tre fatti che tengono chiuso il cancello:
1. il **dry-run 100k** ha **15 chiusure in tutto** dal 10/08 al 25/08, da
   **4 sedie sole** (770101, 770611, 770411, 770202) — 🥇 conteggio di questo
   giro su `data/statements/trades_100k.csv`. Quindici operazioni non
   giudicano niente;
2. il conto piccolo ha campioni **sotto le 20 operazioni su quasi tutte le
   famiglie** (tabella del cancello 1) e la finestra reale di quasi tutte le
   sedie e' **sotto le 5 settimane** (🥇 `CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md`
   §metodologia p.5);
3. il **censimento dei contratti** — prerequisito dichiarato alla FIRMA 2 del
   18/08 — **non ha ancora la peggior giornata** delle sedie: la sta misurando
   R112 in questo momento (🥇 `R112_CRITERI.md` §4 e §8).

### 🗣️ L'ORIENTAMENTO DICHIARATO DA CLAUDIO (26/08 sera) — registrato, NON e' una firma

> _"con molta probabilita' voglio partire con una challenge tra le **PIU'
> ALTE** che ci sono; mi fido dei nostri expert e ho la possibilita'
> economica per iniziare da una challenge costosa"_ — **Claudio, 26/08/2026,
> testuale.**

📌 **Come lo tratta questo documento.** E' un **orientamento dichiarato**, e
sta agli atti come tale: **non e' una firma, non congela niente e non
autorizza nessun acquisto** (F4 resta congelata dal 13/08: challenge solo
dopo forward maturo). Cambia pero' **il carico della prova**, e per questo
nasce il **cancello 6**: le percentuali del nostro banco (pass-rate, DD,
worst day) sono identiche a ogni taglia **SOLO SE la scala dei lotti e'
davvero lineare** — e 🥇 R109 ha misurato che **non lo e'**. Su una taglia
grande il rischio non e' il capitale perso in fee: e' che **la macchina si
comporti in modo diverso da come e' stata misurata**, in silenzio.

⚖️ Due cose oneste da dire accanto all'orientamento, entrambe misurate:
- **la fiducia negli expert e' coerente coi numeri di banco** (99,6% di
  challenge passate a d=1,00, sopravvivenza funded 100% su 230 finestre
  annuali) — ma quegli stessi numeri poggiano su **UN SOLO regime toro** e su
  **chiusure giornaliere**, cioe' sul caso piu' gentile (avvertenze b e d di C7);
- **il forward, che e' la prova vera, ha 15 chiusure sul 100k**. La taglia
  grande non e' vietata da nessuna misura: e' che oggi **nessuna misura la
  sostiene ancora**, ed e' esattamente cio' che i sei cancelli servono a
  cambiare entro meta'-fine settembre.

📅 **VINCOLO DI CALENDARIO IMMEDIATO — JACKSON HOLE 27-28/08/2026.** Non si
apre, non si compra e non si sposta nulla prima che il simposio sia passato:
due giornate di headline sui tassi con una flotta che **non ha il filtro news
acceso** (D1/D5 tuttora spenti) sono il posto sbagliato per iniziare
qualunque cosa. Prima regola di casa applicata: si aspetta e si guarda.

## 🚧 I SEI CANCELLI

| # | cancello | stato oggi (26/08) | fonte dello stato | cosa lo fa diventare verde |
|---|---|---|---|---|
| **1** | **Famiglie principali a 20+ operazioni forward con DD reale ≤ DD promesso** (criterio firmato 18/08, corsie RISCHIO+MERITO) | 🔴 **ROSSO** — solo **2 famiglie su 17** superano le 20 operazioni (Aperture DAX 38, ORB 25); **il DD reale per famiglia non e' misurato: n/d ovunque**. E la famiglia piu' numerosa e' **in perdita** (Aperture DAX −698,46 €): per la lettera della C3 la corsia MERITO **e' gia' scattata** | 🥇 conteggio di questo giro su `data/statements/trades_auto.csv` (chiusure fino al 25/08) + ✍️ `report/FIRME_2026-08-18.md` FIRMA 2 | le famiglie che contano arrivano a 20 op **e** si misura il DD forward per famiglia contro il contratto. Serve la **pagella serale** (`scarica_pagella.ps1 -Installa`) come flusso continuo, non a spot |
| **2** | **Censimento dei contratti COMPLETO** (DD e frequenza promessi, sedia per sedia) | 🟡 **GIALLO** — `report/CONTRATTI_SEDIE.md` esiste dal 18/08 (44 sedie: 40 pieni, 2 parziali, 2 senza) ed e' stato riscritto dalla firma "A+b" del 24/08 per le 5 sedie ridotte; **manca la PEGGIOR GIORNATA**, che nessun contratto ha mai avuto — **R112 la sta misurando adesso** sull'EMADOW (metro + 3 dial) | 🥇 `report/CONTRATTI_SEDIE.md` · ✍️ `report/FIRMA_REVISIONE_FLOTTA_2026-08-24.md` · 🥇 `R112_CRITERI.md` §4 (convenzione congelata prima) e §8 ("la peggior giornata del METRO entra agli atti — oggi il censimento non ce l'ha") | referto R112 consegnato + la colonna "peggior giornata promessa" estesa almeno alle sedie che pesano. ⚠️ E' un **pavimento**: R112 misura i CHIUSI, il muro guarda il **flottante** (limite dichiarato nei criteri) |
| **3** | **Dossier prop candidate a muri STATICI 5/10, con EA ammessi, e SCELTA fatta** | 🔴 **ROSSO** — **Upcomers BOCCIATA** il 26/08 (3% daily · 6% **trailing** · regola dei 2 minuti · one-sided bets · entita' Saint Lucia 2025 senza regolatore). Restano candidate **FTMO 2-Step Swing** (ipotesi di lavoro F1/F2) e **The5ers High Stakes** con riserve; **E8 e Alpha mai istruite**. 🆕 **Un secondo dossier prop e' IN ARRIVO dal cacciatore-config-prop** | 🥈🟡 `DOSSIER_PROP_UPCOMERS_2026-08-26.md` §8 · `report/SCHEDA_SECONDA_PROP.md` (classifica 13/08) · `docs/REGOLAMENTO_FTMO_2026-08.md` | un dossier **[VERIFICATO]** (non [LETTO-VIA-SEARCH]) su almeno DUE prop a muri statici + le risposte SCRITTE del supporto (E1/D3) + la scelta di Claudio in F1 |
| **4** | **Preset Guardian sui muri della prop scelta + firma** | 🔴 **ROSSO** — il Guardian in campo e' tarato **solo su FTMO** (4,0 / 4,9 / 9,9 / reset 23 / DD statico). Il dossier Upcomers l'ha dimostrato per assurdo: su muri 3/6 ogni singola soglia sta **oltre** il muro che dovrebbe proteggere. Il preset "muri stretti" e' **proposta P1**, non esiste ancora | 🥇 preset+sorgente `mql5/Experts/ABTG_Guardian.mq5` (`InpDDMode` gia' presente, righe 53/355/367) · `DOSSIER_PROP_UPCOMERS_2026-08-26.md` §5 e §9-P1 | un preset per **famiglia di muri** (non uno solo), collaudato con autotest sul 100k, e la firma di Claudio. ➕ **manca l'enforcement**: gli EA non leggono ancora le bandiere del Guardian (decisione n.1 in lista firme) |
| **5** | **Firma del piano DUE-DIAL all'apertura** (challenge d=1,00 · funded d=0,74) | 🔴 **ROSSO** — proposta consegnata il 26/08, **mai firmata**; e ha un **conflitto dichiarato** con la raccomandazione di R106 (che per la challenge diceva ×0,74). Serve anche la **prova di regime** al dial scelto: la sopravvivenza in ORSO **non e' misurata** | 🥇 `ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md` §raccomandazione · 🥇 `R106_REFERTO.md` §verdetto proposto | la parola di Claudio su **quale dial in quale fase** + prova di regime della flotta al dial scelto (macchina R50-R56-R59, Emendamento C) |
| **6** 🆕 | 📏 **PROVA DELLA TAGLIA** — obbligatoria **prima** di comprare una taglia grande (200k+), nasce dall'orientamento dichiarato di Claudio del 26/08 | 🔴 **ROSSO — MAI FATTA.** Tutto il banco di casa (R105/R106, analisi dial, analisi DD totale) e' costruito su **base 100k** e su una **scala lineare** dei lotti: nessuna corsa e' mai stata fatta a 200k/500k. E R109 ha gia' misurato che la linearita' **si rompe** | 🥇 `R109_REFERTO.md` §"tre fatti collaterali": il lotto sbatte sul tetto **`SYMBOL_VOLUME_MAX`** (=100, dichiarato sul Dow nell'analisi dial §avvertenza (a); il taglio **misurato** su NASUSD short) ed e' stato **tagliato su 66 trade su 743 = 8,9%** — _"quei trade rischiavano MENO dell'1%, quindi i DD di questo round SOTTOSTIMANO il rischio e non si riscalano linearmente con la taglia"_; **slippage 21,5 punti** misurato su uno stop reale (perdita **doppia** dell'attesa), e cresce con la taglia · 🥇 `ANALISI_DD_TOTALE_2026-08-26.md` (il banco 100k che va riprodotto alla taglia target: **DD tot worst −6,37%**, **worst day −4,74%**, **il vincolo che morde e' il giornaliero**: margine 5% sul giorno contro 36% sul totale) | un **round di prova della taglia**: stessa flotta, stessa finestra, **deposito alla taglia target** (200k/500k), che misuri e riporti **(1)** quante operazioni finiscono al tetto di volume e su quali simboli, **(2)** se i lotti richiesti passano i **limiti di margine** del broker, **(3)** quanto si scostano DD, worst day e pass-rate dal banco 100k. **Se lo scostamento c'e', le percentuali NON sono trasferibili e la taglia grande va ricalcolata, non estrapolata** |

### 📊 CANCELLO 1 — LE OPERAZIONI FORWARD PER FAMIGLIA, CONTRO LA SOGLIA 20

🥇 **[CALCOLO DI QUESTO GIRO]** — fonte: `data/statements/trades_auto.csv`
(conto piccolo **50503392**, aggiornato 25/08 20:47, chiusure fino al 25/08
15:30). Convenzioni dichiarate: **ingressi** = righe raggruppate per
(magic, simbolo, `open_time`, lato) — i parziali 1/3-2/3 di una stessa
posizione contano **uno**; **chiusure** = righe grezze del CSV (l'unita' che
usava il censimento del 22/08, tenuta accanto per confronto); **netto** =
`profit + commissioni + swap`. Le famiglie sommano nativo + gemello
`_Ottimizzato` (regola di casa: la corsia MERITO della C3 giudica **per
famiglia**). Il conto **100k e' tenuto fuori** per non contare due volte lo
stesso segnale (stessa scelta del censimento 22/08 §3).

| famiglia | ingressi | chiusure | netto € | prima→ultima chiusura | vs soglia **20** | DD reale forward |
|---|---:|---:|---:|---|---|---|
| **Aperture DAX** (770101 · 770111 · 770102) | **38** | 39 | **−698,46** | 20/07 → 25/08 | ✅ **SOPRA** — e **in perdita** 🔴 | **n/d** |
| **ORB** (770601 · 770611) | **25** | 25 | +167,19 | 20/07 → 24/08 | ✅ **SOPRA** — in utile | **n/d** |
| **SupertrendReversal** (770901/24/25 · 9709xx · 771001) | 19 | 22 | −4,33 | 29/07 → 17/08 | 🟡 **AL BORDO** (sopra a chiusure, sotto a ingressi) | **n/d** |
| SuperWave (770511 · 770531 · 770532†) | 16 | 18 | −50,10 | 27/07 → 25/08 | ❌ sotto | n/d |
| EMA200 indici/forex (771531 · 7715xx) | 12 | 12 | +31,36 | 14/08 → 25/08 | ❌ sotto | n/d |
| EMA200 oro/DAX (771501 · 971501) | 11 | 11 | −110,49 | 22/07 → 05/08 | ❌ sotto | n/d |
| MaxMinNotte (770401 · 770402 · 770411) | 8 | 8 | +177,75 | 20/07 → 24/08 | ❌ sotto | n/d |
| EasyTrend (772421-23†) | 7 | 7 | +109,77 | 18/08 → 23/08 | ❌ sotto | n/d |
| Nightly (771701) | 6 | 6 | +295,55 | 23/07 → 10/08 | ❌ sotto | n/d |
| CostToCost (772361-63†) | 6 | 6 | −108,46 | 14/08 → 25/08 | ❌ sotto | n/d |
| PunteLarry (7723xx) | 4 | 4 | +105,66 | 17/08 → 21/08 | ❌ sotto | n/d |
| PTE (7713xx†) | 3 | 3 | −4,15 | 07/08 → 19/08 | ❌ sotto | n/d |
| Aperture DOW (770202) | 3 | 3 | −4,13 | 07/08 → 13/08 | ❌ sotto | n/d |
| Gold_Ichimoku (250604) | 2 | 2 | −82,39 | 09/06 → 19/06 | ❌ sotto (**63 gg di silenzio**) | n/d |
| GapContinuation (774101) | 1 | 1 | −51,90 | 19/08 | ❌ sotto | n/d |
| BreakingBand (7721xx) | 1 | 1 | +2,69 | 20/08 | ❌ sotto | n/d |
| **GapFill** (7722xx) | **0** | 0 | 0 | — | ⚫ **ZERO operazioni** | n/d |
| _(spenta 18/08)_ Apertura Nasdaq (770201 · 770211) | 13 | 13 | +274,68 | 20/07 → 11/08 | — sedia spenta | — |

† la famiglia contiene sedie **spente o ridotte** dalla firma "A+b" del 24/08
(PTE USDJPY, SuperWave GBPUSD, CostToCost XAGUSD, EasyTrend AUDJPY spente; 5
sedie ridotte): i conteggi qui sopra sono **storici**, comprendono cioe' anche
le operazioni fatte da sedie che oggi non ci sono piu'.

🔴 **La colonna che decide il cancello e' l'ultima, ed e' TUTTA `n/d`.** Il
criterio firmato non chiede solo il numero di operazioni: chiede **DD reale ≤
DD promesso** (corsia RISCHIO, per sedia, a qualunque n). Oggi il DD forward
per famiglia **non lo calcola nessuno**: le pagelle giornaliere danno il P&L
del giorno, non il drawdown di una famiglia sulla sua serie. 👉 **Serve la
prossima pagella serale** (`scarica_pagella.ps1 -Installa`, attivita' 23:15,
scrive `Desktop\pagella_AAAA-MM-GG.txt`) **come flusso continuo**, piu' una
misura dedicata "DD forward per famiglia" (→ M20). **Nessun numero e' stato
inventato per riempirla.**

⚠️ **Tre avvertenze sulla tabella, dichiarate:**
- **il conto e' misto**: il piccolo gira a 1% (e ora 0,25-0,65% sulle
  ridotte), il 100k a 0,65% — i netti in € non sono confrontabili fra sedie
  senza normalizzare;
- **la finestra e' cortissima**: quasi tutte le famiglie hanno il primo trade
  dopo il 20/07 (misurato nel censimento del 22/08 §metodologia p.5);
- **20 operazioni non sono un verdetto di merito**, sono la **soglia di
  revisione** firmata: a 20 op in perdita si RIVEDE, non si spegne d'ufficio
  (la parola resta di Claudio, ed e' scritta cosi' nel verbale).

### 🔔 IL FATTO CHE IL CANCELLO 1 FA EMERGERE, E VA DETTO SUBITO

**La famiglia Aperture DAX ha 38 ingressi forward e chiude a −698,46 €.** Per
la lettera della C3 (corsia MERITO: famiglia a 20+ operazioni totali in
perdita → revisione di TUTTE le sue sedie, si spegne la sedia colpevole, la
gemella positiva resta) **il criterio e' scattato**. La scomposizione, sempre
dal CSV:

| sedia | chiusure | netto € |
|---|---:|---:|
| `770101` DAX Apertura EU BUY | 14 | −282,06 |
| `770101` DAX Apertura EU SELL | 9 | −392,22 |
| `770101` DAX Apertura EU **RETEST** BUY | 5 | **+48,78** |
| `770101` (riga su NASUSD ⚠️) | 1 | +15,46 |
| `770111` DAX Apertura EU OTT BUY | 8 | **+30,32** |
| `770102` DAX Apertura EU OTT BUY | 2 | −118,74 |

👉 Le due gambe in perdita sono **BUY e SELL della modalita' vecchia**; la
modalita' **RETEST** — quella che il duello R83 aveva incoronato sul DAX — e'
**in utile**, e cosi' il gemello `770111`. 🟡 **Non lo decido io e non lo
propongo come spegnimento**: lo porto alla riga C3 come **prima famiglia che
raggiunge la soglia di revisione**, con il pezzo mancante dichiarato (il DD
promesso dal contratto, da confrontare col DD reale che oggi e' n/d).
⚠️ Segnalata anche **una riga con magic `770101` su NASUSD** (chiusa il
22/07): o e' un grafico sbagliato o e' un magic riusato — va guardata, perche'
sporca l'attribuzione della famiglia.

### 📏 CANCELLO 6 — PERCHE' UNA TAGLIA GRANDE NON E' "LO STESSO CONTO PIU' GRANDE"

L'intuizione naturale e' che le percentuali non cambino: rischio 0,65% su
100k o su 500k, stessa curva, stessi muri in %. **E' vero solo se il lotto
puo' crescere in proporzione.** Le due misure di casa che dicono che non
sempre puo':

| fatto misurato | dove | perche' morde di piu' alla taglia grande |
|---|---|---|
| **tetto `SYMBOL_VOLUME_MAX` = 100** — il lotto viene **tagliato**, e su NASUSD short e' successo **66 volte su 743 (8,9%)** | 🥇 `R109_REFERTO.md` §1 | il tetto e' **assoluto** (contratti), il rischio e' **relativo** (% del conto): a taglia doppia servono lotti doppi, e la stessa operazione sbatte sul tetto **prima**. I trade tagliati rischiano MENO del previsto → **il banco sottostima il rischio e sovrastima nulla**: la curva reale a taglia grande e' **diversa**, non solo scalata |
| **slippage 21,5 punti** su uno stop reale (perdita **doppia** dell'attesa) | 🥇 `R109_REFERTO.md` §2 | l'ordine grande mangia piu' book: **lo slippage cresce con la taglia**, e cresce proprio dove fa piu' male (stop stretti dei motori d'apertura) |
| **margine**: nessuno ha mai verificato che 8-9 posizioni simultanee alla taglia target passino i limiti del broker | — **buco dichiarato** | il picco misurato in M2 (9 posizioni di 8 sedie insieme) alla taglia grande diventa un impegno di margine mai provato |

👉 **La regola che ne esce, proposta:** _la taglia grande si compra solo dopo
che il banco e' stato RIPRODOTTO alla taglia target._ Il confronto atteso e'
semplice e binario: se DD, worst day e pass-rate alla taglia target
coincidono col banco 100k (`ANALISI_DD_TOTALE_2026-08-26.md`: worst day
−4,74%, DD tot −6,37%, 0 violazioni), la scala regge e l'orientamento di
Claudio e' sostenuto da una misura. **Se non coincidono, il numero giusto e'
quello nuovo** — e la taglia va scelta su quello, non sull'estrapolazione.
💡 Nota pratica a costo zero: **il cancello 6 non blocca i primi cinque**, si
lavora in parallelo ed e' un round di banco, non una decisione.

---

## 📍 IL PUNTO DI PARTENZA, IN QUATTRO NUMERI (perche' il piano serve)

| fatto | numero | fonte |
|---|---|---|
| agosto sul conto piccolo | **−11%** (90 op, −617,49 € su ~5.100 €) — su una prop saremmo **gia' fuori dal muro del 10%**; scalato a 0,65% farebbe −7,2% | 🥇 `DOVE_SIAMO_17-08.md` §1 |
| il rischio di casa | **0,65%** per trade → p99 Monte Carlo **8,51%** su DD **statico** (ricalcolo esatto M1; la vecchia stima "~8,1%" era leggermente ottimista), contro muro 10%. **Col TRAILING: p99 12,05% — a 0,65% NON regge** | 🥇 `METRO_PROP.md` §1-bis + `REFERTO_M1_MC_TRAILING.md` |
| il buco aritmetico | ~~timore~~ → **FATTO MISURATO**: il 03/08 alle 08:15 c'erano **9 posizioni di 8 sedie aperte insieme = 5,85%** di rischio aperto (p99 giornaliero 5,67%), oltre il muro del 5% | 🥇 `REFERTO_M2_SOVRAPPOSIZIONE.md` (forward vero, agosto) |
| il Guardian oggi | soglie **5,0 / 10,0 = esattamente sul muro** — eravamo l'unico caso letto cosi'. ✍️ **v5: il cambio e' FIRMATO** (pausa 4,0 · emergenza 4,9 / 9,9 · reset 23), attuazione a gradini: soglie+reset subito sul Guardian, pausa morbida dopo lo sviluppo, tutto collaudato sul 100k prima di un conto che conta | 🥇 preset nostro + 🥉 dossier §1A-ZERO/§2A-2B + ✍️ `FIRME_2026-08-18.md` |

~~E il vincolo che pesa su TUTTO il documento: le Monte Carlo col DD TRAILING
non esistono ancora~~ → **CADUTO il 18/08 (v4): la MC trailing ESISTE** (M1,
criteri congelati prima dei numeri). Il verdetto: **il trailing costa ~3,5
punti di p99 alla taglia di casa** (12,05% contro 8,51% statico). La taglia
del rischio ora **dipende dal TIPO di muro**: statico → 0,65% regge; trailing
→ vedi la tabella in F3.

---

# AREA A — 💰 RISCHIO PER TRADE

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| A1 | **Rischio per trade a taglia prop** | **0,65%** | 🥇 MC R16 + 27 serie (`METRO_PROP` §1-bis: p99 12,47% a 1% → ~8,1% a 0,65% vs muro 10%); decisione in `DEPLOY_GUARDIANO_100K.md` | 🥉 blog MQL5 (E0) suggerisce 0,25-0,4%; 🥉 PROPstyle ragiona per rischio TOTALE ≤1%; 4° script CrewAI (18/08): 0,5% per trade contro muro 5% ("10 perdite per sfondare"); 4° trascrizioni: Petko "1% per trade, regola semplice" [dichiarato]. Le voci esterne stanno sopra e sotto il nostro 0,65 — 2ª notte, distribuzione aggiornata: 0,5 (Prop Firm Pass) · 0,5 (TIP preset; 0,75 di listino) · **0,65 (noi)** · 1,0 (Ultimate EA) · 2,4 ⚠️ (Range Breakout ExtraLow): **siamo nel corpo della distribuzione**. 🥇 **M1 (v4) precisa il perimetro**: su DD **statico** il p99 esatto e' **8,51%** (< 10: il congelamento REGGE, la vecchia stima ~8,1 era lievemente ottimista); col **TRAILING NON regge** (p99 12,05%, sfonda il muro 10 nel 4,6% dei percorsi — non "meno dell'1%"): li' valgono le taglie di F3 (0,50/0,40). ⚠️ E vale per UNA sedia: il problema e' la SOMMA (C1) | 🧊 **CONGELATO (09/08/2026, decisione di Claudio, verbale in `DEPLOY_GUARDIANO_100K.md`: "Rischio per trade: 0,65% (non 1%!)") — da leggersi, dopo M1: 0,65% SU DD STATICO** |
| A2 | Rischio sedie **giovani** (<30 trade OOS-forward) | **0,3%** (mezzo peso) | 🥇 stessa decisione del 09/08 (ORB a 0,3% nel dry-run: "+41k dei +73,8k sono suoi: mezzo peso finche' non ha 30 trade") | nessuno | 🧊 **CONGELATO (18/08/2026, verbale FIRME, FIRMA 4: "ogni sedia con meno di 30 trade in forward gira a 0,3%" — era la prassi del dry-run, da oggi regola scritta per tutte)** |
| A3 | Taglia in **fase 2** della challenge | in dubbio: ridurre (meta'/−20%) **oppure non toccare il rischio e abbassare solo il target** | 4° blog MQL5 E0-bis ("fase 2: lotto ridotto della meta'") **CONTRO** 🥉 Ultimate EA, coi file alla mano [VERIFICATO]: `riskPercentage` **1,0 / 1,0 / 1,0** su Phase 1 / Phase 2 / Funded — cambia SOLO il target (**8 → 5 → 2**) | 🔴 **PEGGIORATO v3 (ed e' un bene saperlo): da "1 fonte a favore" a 1 CONTRO 1** — e la fonte contraria e' piu' forte (un file di configurazione, non una frase) | 🔓 APERTO — 🎬 trascrizioni: niente. Si chiude con un round nostro o col peso delle fonti future |
| A4 | Rischio massimo per sedia sul **conto piccolo** (forward) | **1,0%** (nessuna sedia sopra) | 🥇 `REFERTO_CENSIMENTO_RISCHIO.md`: tre sedie al 2% trovate 17/08, corrette a 1% (controprova 00:01 del 18/08 PASSATA, zero righe rosse); le sei peggiori perdite (−2,00…−2,19%) erano esattamente le sedie al 2% | il 100k a 0,65% conferma per contrasto: la sua peggior perdita e' **−0,65%**, il rischio di casa esatto | 🧊 **CONGELATO (18/08/2026, verbale FIRME, FIRMA 4: "nessuna sedia sopra l'1%, mai" — il censimento periodico e' la verifica, una riga rossa e' una VIOLAZIONE, non una curiosita')** |

> 📌 Nota su A1 — **la condizione di riapertura si e' AVVERATA (v4)**: al v1
> era scritto _"la riga si riapre da sola il giorno in cui esiste la MC col
> DD trailing"_. Il giorno e' arrivato (M1, 18/08) e l'esito e' un
> **perimetro**, non una revoca: sul dominio per cui Claudio l'ha congelato
> (FTMO 2-Step, DD statico — il dry-run del 09/08) il numero REGGE (8,51% <
> 10). Fuori da quel dominio (muri trailing) il congelamento **non si
> estende**: valgono le taglie misurate in F3. Se la prop scelta in F1 sara'
> trailing, A1 va rifirmato da Claudio alla taglia giusta.

# AREA B — 🛡️ GUARDIANO E CAP (ABTG_Guardian + preset)

Il Guardian oggi ha: cap giornaliero su **balance di inizio giornata vs equity**
(= formula FundedNext, e compatibile con FTMO), DD totale statico o trailing da
picco equity, lockdown persistente con ricaccia degli ordini. Gli mancano 26
dei 36 meccanismi censiti (dossier, Parte 3) — qui sotto i sette che contano.

> ✅ **Verifica fatta sul sorgente (18/08, su segnalazione dello script CrewAI
> che prescrive "floating + realizzato"):** `ABTG_Guardian.mq5` riga 155:
> `dailyLoss = dayStart - eq` — la misura corrente e' l'**EQUITY**, quindi
> **il flottante E' contato**: una posizione aperta in forte perdita fa
> scattare il breaker, non serve che chiuda. Il sospetto di buco NON sussiste
> sul lato misura. Resta aperto solo il lato **baseline** (il `dayStart` e'
> solo balance — riga B4).

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| B1 | **Cap giornaliero interno — DUE livelli** (riscritta al v3: prima confondeva due meccanismi in uno) | **pausa morbida a 4,0%** (ferma i NUOVI ingressi per la giornata) **+ chiusura d'emergenza a 4,9%** (= muro 5 − 0,1 di margine tecnico contro spread/slippage/commissioni in chiusura) — modello Prop Firm Pass | **PRINCIPIO "mai sul muro": 5+ fonti indipendenti** (Profalgo, Eriksson 4%, Ultimate EA 4,9, guida 772732 4,90, Prop Firm Pass 4,0+0,1, EquityGuard 4,5, CrewAI 4,3-4,5) — noi a 5,0 siamo **l'unico caso letto sul muro esatto** · 🥇 peggior giornata nostra −2,06% (R51): il livello morbido a 4 resta largo il doppio | 🔴 **CORREZIONE D'EVIDENZA (2ª notte)**: la "convergenza tre vendor" sul 4/9 era in realta' **DUE** — Gold Phantom dichiara `The_Gold_Phantom_V1.0_WSC` = Wim Schrynemakers = **Profalgo, lo stesso autore di Gold Reaper**, stessa lista input. E il VALORE del buffer **diverge per un fattore 10**: 1,0 pt (Profalgo+Eriksson) · 0,1 pt (Ultimate EA + guida 772732 + Prop Firm Pass, **tre fonti indipendenti**) · 0,5 pt (EquityGuard + CrewAI). Sono **due meccanismi diversi**: chi mette 4 FERMA la giornata, chi mette 4,9 para solo i costi di chiusura. Il rischio di scattare troppo presto (giornata che sarebbe rientrata) riguarda solo il livello morbido; da misurare in dry-run | 🧊 **CONGELATO (18/08/2026, "firma tutte e 3" — `FIRME_2026-08-18.md`, FIRMA 1)**. ⚙️ **v7: IN CAMPO sul 100k** — Guardian **v1.10 installato, compilato e VIVO** (conferma visiva 08:38: pannello `limite 4.9 / Pausa morbida (4.0) libera`). La pausa scrive le GlobalVariable (latch + scadenza auto-estinguente + battito 1 s) ma **gli EA non le leggono ancora**: migrazione all'include `ABTG_PausaGuardian.mqh` da decidere, un EA per volta |
| B2 | **Cap totale interno** | **chiusura d'emergenza a 9,9%** (= 10 − 0,1 tecnico); un eventuale fermo deliberato prima (es. 9,0) e' una **scelta di gestione**, non un buffer tecnico, e va decisa come tale | 🥉 il 9 secco viene da **UNA casa sola** (Profalgo, due prodotti); le tre fonti a buffer sottile direbbero **9,9** · 🥇 p99 nostro statico 8,51% (esatto, M1): sta sotto entrambe le soglie, il portafoglio ci passa | stessa correzione d'evidenza di B1: il "9" non e' "quello che dicono tutti" | 🧊 **CONGELATO (18/08/2026, verbale FIRME, FIRMA 1: emergenza sul totale a 9,9)** — ⚙️ v7: **in campo sul 100k** (pannello: `totale 9.9`) |
| B3 | **`InpDailyResetHour`** nel preset FTMO su demo BCM | **23** (oggi: 0) — reset FTMO **00:00 CE(S)T = 23:00 ora server BCM** (agosto: Italia UTC+2, BCM = italiana−1 = UTC+1 — ✅ **MISURATO 18/08 20:35 IT**: Market Watch 19:35:27 con Windows 20:35 nello stesso screenshot → il conflitto col corso ("GMT"=IT−2) e' DECISO: aveva ragione il repo, il corso sbaglia di un'ora sull'oggi; resta [INCERTO] SOLO il comportamento invernale/DST del server → E1) | 🥈 scheda FTMO del dossier §2A/§2H — ⚠️ **[LETTO-VIA-SEARCH], NON verificata** · 4° script CrewAI: snapshot alla mezzanotte del broker come base del giorno prop (coerente col principio) | ⚠️ triplo caveat: (1) la scheda prop non e' verificata sul sito ufficiale; (2) il numero dipende dal SERVER, non dalla prop — sul server FTMO tornerebbe 0; (3) lo script CrewAI dice pero' **00:00 GMT**, non CET: **discordanza di fuso fra le fonti — l'ora esatta resta [INCERTO] finche' il supporto non risponde per iscritto**. Va scritto in commento nel preset. Col valore attuale (0) il dry-run misura una giornata **sfasata di un'ora**. 2ª notte: **nessuna gamba nuova** — nessun `.set` su 50 dichiara l'ora di reset del muro (quasi nessun EA prop-ready ha quell'input: solo Prop Firm Pass, ora+minuto; TIP dichiara il fuso di SESSIONE in GMT, non del reset). Resta [INCERTO], si chiude solo col supporto. 🔴 **v11, CONFLITTO NUOVO da segnalare (non lo decido io)**: il corso (moduli base, lez. 3) dice che la piattaforma del SUO broker sta in **GMT = IT−2** — e il broker del corso **E' BCM, il nostro** (bcmmarkets.com, verificato nel referto) — mentre tutto il repo (CLAUDE.md, questo piano) dice **BCM = IT−1**. Un'ora di scarto sullo STESSO broker: o sono due server diversi della stessa casa (BlackRidge-Demo1 ≠ BCMMarkets-Server) o una delle due fonti sbaglia. **Misurabile con uno screenshot (M15)** — e se il fuso di casa fosse sbagliato, non cadrebbe solo il 23: cadrebbero TUTTI gli orari del progetto | 🧊 **CONGELATO (18/08/2026, verbale FIRME, FIRMA 1: `InpDailyResetHour=23` nel preset FTMO su BCM, col commento che il valore dipende dal server e resta [INCERTO] finche' il supporto non conferma il fuso per iscritto)** — ⚙️ v7: **in campo sul 100k** (preset caricato con commento [INCERTO] incluso) |
| B4 | **Baseline giornaliera**: balance / equity / max dei due | aggiungere l'input modo (oggi: solo balance, cablato) | 🥈 le prop divergono per regolamento: FundedNext = balance inizio giornata (come noi) · FundingPips = **max(balance, equity)** · The5ers = equity o balance di chiusura · 🥉 Bneu e Take a Break ce l'hanno come input | il valore GIUSTO dipende dalla prop scelta (area F): finche' F1 e' aperto, qui si puo' solo predisporre l'input | 🔓 APERTO — buco n.5 del censimento |
| B5 | **`InpDDMode=2`**: trailing EOD sul saldo di fine giornata piu' alto | aggiungere la modalita' (oggi: 0 statico, 1 trailing equity) | 🥉 KT Equity Protector dichiara esattamente 3 modelli · 🥈 FTMO 1-Step usa proprio questo ("il limite puo' solo salire") · 4° trascrizioni (video PropEA): _"usatelo solo su firme con drawdown STATICO invece del trailing, e' molto importante"_ — un venditore di scorciatoie che conferma la nostra cautela | scrivere il codice **non risponde** alla domanda vera (METRO_PROP §1: MC trailing mai fatta) — la rende solo misurabile. L'uso resta bloccato da C5 | 📋 PROPOSTO (P7) — il codice si'; l'USO resta APERTO |
| B6 | **Pausa morbida giornaliera** (blocca i NUOVI ingressi, non chiude) | soglia **2,5%**, `InpDailyPauseDays=1` | 🥇 il 2,5% e' la NOSTRA misura: peggior giornata storica −2,06% (R51) → "hai gia' fatto peggio del tuo peggior giorno: smetti di aprire" · 🥉 Prop Firm Pass (pausa a 4, 1 giorno) + blog MQL5 (cap 2,5%) — e la struttura a due livelli ora e' anche in B1 | 🔄 **AGGIORNATO v3: il canale di blocco ESISTE in natura.** The Impossible Prop lo implementa gratuito: **7 campi trasmessi via GlobalVariable a ogni tick** (battito, posizioni, direzione, P&L, stato di halt) + **staleness detection `SiblingStaleSec=30`** (se l'emittente muore, chi legge se ne accorge) + **`BlockIfSiblingHalted=true`**. Il nostro Guardian **gia' scrive** GlobalVariable (`BLOCKDAY`/`FAILED`): mancano la LETTURA negli EA e il battito con staleness. Resta vero che ogni EA che non legge la variabile la ignora: la verifica va fatta EA per EA, non assunta. ✍️ **v5: la firma ha scelto 4,0, non 2,5** — il MECCANISMO di questa riga (blocco ingressi via GlobalVariable, modello sibling) e' entrato nella FIRMA 1 dentro B1; la SOGLIA 2,5 non e' stata firmata | 🔓 APERTO (v5, era PROPOSTO) — declassata a **idea di riserva**: un eventuale livello extra a 2,5 si riapre solo con una misura che lo giustifichi (es. il dry-run mostra che il 4,0 non morde mai) |
| B7 | **Filtro duplicati** (la ferita del 29/07: due EA, stesso segnale, stesso secondo) | finestra **60 s** · tolleranza prezzo **50 pts** · volume **20%** — in `OnTradeTransaction` del Guardian | 🥉 Bneu "Duplicate Filter" (unico prodotto letto che ce l'ha: finestra in secondi + tolleranze) · 🥇 `CENSIMENTO_ORDINI_PC.md` §3 (il caso misurato) · regola 1 di `ROTTA_PROP` — oggi scritta in un file, **niente la fa rispettare** | 🔴 falsi positivi: due EA possono essere legittimamente long sullo stesso simbolo (swing H4 + intraday M5). Serve la lista delle coppie esentate, altrimenti fa piu' male che bene → quella lista e' APERTA | 📋 PROPOSTO (P6) — con esenzioni da definire prima |
| B8 | **Riduzione del rischio in avvicinamento al muro** (ex buco n.8 — al v1 era nei "non proposti" perche' _"nessun prodotto la implementa"_: **la 2ª notte l'ha trovata DUE volte**) | da definire: due meccanismi documentati — (a) **zone automatiche** alla The Impossible Bullion (`PropYellowPct`/`PropRedPct`/`PropDeadPct` + `YellowRiskMult`/`RedRiskMult` + cap trade + soglia qualita' per zona); (b) **scala manuale a 2 gradini** alla Range Breakout (ExtraLow↔Low legata al cuscinetto: _"sotto zero, torna a ExtraLow"_) | 🥉 raccolta §1E/§4: Bullion (guida config) + Range Breakout (manuale) · affine: EquityGuard `Warning at 80%` e PropGuard `InpWarningThresholdPercent=10` (allarme di avvicinamento, buco n.28) | ⚠️ le **soglie della Bullion NON sono pubblicate** ([INCERTO]: nomi e logica si', numeri no); la scala manuale richiede disciplina umana. E il monito del v1 resta: i moltiplicatori andrebbero tarati su misure NOSTRE, non copiati | 🔓 APERTO — da buco "di nessuno" a parametro con due modelli reali |
| B9 | **UN GUARDIAN PER CONTO, SEMPRE** (regola nata sul campo, v7) | un solo Guardian per conto, su un solo grafico — MAI due istanze | 🥇 `REFERTO_GUARDIAN_FIRME.md` §DEPLOYMENT: sul 100k ne sono stati trovati **DUE su due grafici**; doppione rimosso da Claudio. Il motivo e' tecnico: le GlobalVariable sono **per-conto** (suffisso login) — due istanze si sovrascrivono a vicenda, e in emergenza chiuderebbero le stesse posizioni **in doppio** | nessuno | 📋 PROPOSTO — in vigore di fatto dal 18/08 (doppione gia' rimosso); da congelare alla prossima firma come regola di deploy |

| B10 | 🧱 **UN PRESET GUARDIAN PER FAMIGLIA DI MURI** (nuova, v14 — e' il **CANCELLO 4**) | oggi esiste UN solo set di soglie, tarato su FTMO (4,0 / 4,9 / 9,9 / reset 23 / `InpDDMode=0`). Proposta: un preset **per famiglia di muri**, coi rapporti gia' firmati il 18/08 (pausa = 80% del muro, emergenza = 98%). Esempio calcolato dal dossier per muri 3/6: `InpDailyPausePct 2,4` · `InpDailyLossPct 3,0` · `InpTotalDDPct 6,0` · `InpDDMode 1` (trailing) · `InpDailyResetHour 1` estate / 0 inverno | 🥈🟡 `DOSSIER_PROP_UPCOMERS_2026-08-26.md` §5 (**[LETTO-VIA-SEARCH]**) — la dimostrazione per assurdo: su muri 3/6 **ogni** soglia di casa sta OLTRE il muro (pausa 4,0 contro muro 3,0 = "il conto e' gia' morto da 1 punto") · 🥇 sorgente `ABTG_Guardian.mq5`: **il trailing c'e' gia'** (`InpDDMode` righe 53/355/367, `totalDD = (InpDDMode==1)? (gPeak-eq) : (gStart-eq)`) — **non serve scrivere il meccanismo, serve tararlo** · 🥇 rapporti firmati in `FIRME_2026-08-18.md` FIRMA 1 | ⚠️ **il costo va misurato PRIMA, non dopo**: con daily 3% la pausa a 2,4% scatterebbe molto piu' spesso — la flotta passerebbe giornate intere bloccata, e nessuno ha ancora misurato quante. ⚠️ manca **il blocco del pavimento al breakeven** (proposta P3 del dossier): oggi il nostro trailing e' **piu' severo del vero** — conservativo, ma costa operativita' | 📋 **PROPOSTO (v14)** — vale **anche senza Upcomers**: e' il preset per QUALUNQUE prop a muri stretti, e senza di esso il cancello 4 non puo' diventare verde su nessuna prop diversa da FTMO |

Registrati e **non** proposti ora (con motivo): chiusura del venerdi' (i
preset prop della 1ª notte la DISABILITANO e dipende dalla prop — pero' la 2ª
notte nota che Range Breakout ha `InpClosingSession=true` su 32 preset su 32:
la **chiusura di FINE SESSIONE**, cosa diversa dal venerdi', resta nel
registro), notifiche/log CSV/pannelli (utili, non cambiano il rischio di una
riga), reset con minuti oltre che ore (serve solo se la prop scelta resetta a
mezz'ore). ~~Riduzione del rischio vicino al muro~~ → **promossa a riga B8**
al v3: la 2ª notte l'ha trovata implementata due volte.

# AREA C — 🧺 PORTAFOGLIO (il rischio delle sedie INSIEME)

**Il DD della prop e' UNO: quello del conto** (`ROTTA_PROP`). E' l'area con la
falla aritmetica piu' grossa del piano.

> 🏛️ **Nota di paternita' (v11, dai moduli base del corso):** il corso da cui
> vengono i motori **non contiene NESSUNO strumento di rischio di
> portafoglio** — la parola "correlazione" **non compare in 41 lezioni**, e il
> filtro news e' addirittura **sconsigliato** (_"dimentichiamo completamente
> le notizie macroeconomiche"_, an.tec. lez. 3 — mentre il suo stesso modulo
> FiboH4 lo rende obbligatorio: il corso e' incoerente con se stesso).
> **Guardian, cap C1, criterio C3 e filtro news sono TUTTI di casa nostra**:
> nessuna riga di quest'area puo' essere aperta o chiusa da cio' che dice il
> corso (`ANALISI_MODULI_BASE_2026-08-18.md` §5.3-5.4).

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| C1 | **Cap sul rischio APERTO simultaneo** (`InpMaxOpenRiskPct`, somma degli SL vivi) | **3,25% = 5 SL vivi da 0,65%** (proposta del referto M2), con la pausa B1 a 4,0% come seconda rete | 🥇 **MISURATO (M2, v4)**: max reale **5,85%** per-posizione / 5,20% per-sedia (03/08 08:15, 9 posizioni di 8 sedie), **p99 giornaliero 5,67%**, p95 4,94%, p50 2,60% — il timore aritmetico del v1 e' un fatto accaduto. Il 3,25 regge il conto: 5 SL pieni (−3,25%) + ~2 stop gia' realizzati (−1,3%) resta sotto la chiusura d'emergenza a 4,9; con 8-9 SL vivi il caso peggiore sfonda DA SOLO il muro e nessun guardiano puo' piu' salvarlo · 🥉 esterne (1% / 1,5% / 3%): la misura sta col ramo alto — 3,25 e' il Bneu 3% arrotondato all'unita' di casa da 0,65 | in agosto il cap avrebbe morso **5 giorni su 15** — esattamente i giorni dell'accumulo swing 01-05/08; la meta' tranquilla (p50 2,60%) non lo sentirebbe mai. ⚠️ Il numero e' un TETTO (SL pieni: i parziali/BE non sono nel CSV — verso giusto dell'errore per un cap). Due code che il cap da solo non vede: i **gemelli** (nota sotto) e una griglia stile BULGE che consuma il budget da sola (il cap la ferma perche' conta POSIZIONI, non sedie) | 🧊 **CONGELATO (18/08/2026, verbale FIRME, FIRMA 3: max 3,25% di rischio aperto simultaneo = 5 stop pieni vivi da 0,65%; il vincolo conta gli SL VIVI)**. Costo dichiarato alla firma: il cap rifiutera' trade legittimi proprio nelle mattine cariche — e' il suo lavoro. ⚙️ **v7: IN CAMPO sul 100k** — v1.10 viva, pannello `Rischio aperto 0.00% / cap 3.25% ok` (conferma visiva 08:38). `OpenRiskPct()` somma gli SL vivi via `OrderCalcProfit`, `InpRiskMode=0` = convenzione della misura M2 (cambiarlo = rimisurare la soglia); posizioni SENZA SL non bloccano ma finiscono nel Journal come warning. **Gli EA non leggono ancora la bandiera del cap: migrazione da decidere.** Finche' pausa e cap non scattano in un giorno vero, sono codice, non regole in vigore (`REFERTO_GUARDIAN_FIRME.md` §7). 🔔 **v12, PROMEMORIA FORTE dalla pagella del 18/08**: a fine serata il conto piccolo stava a **~4,84% di rischio aperto simultaneo stimato** [INFERITO] — la serata-tipo del p95 di M2 (4,94), non un'eccezione. Il cap firmato l'avrebbe RIFIUTATA: oggi **il Guardian scrive la bandiera ma nessuno la legge** — la migrazione degli EA all'include e' **l'unico pezzo firmato ancora senza enforcement in campo** → proposta: in cima alla lista sviluppo. 🆕 **v14 — il cap incontra il primo caso concreto che lo sfida**: R112 (criteri firmati 26/08) misura l'EMADOW short a dial **1% / 2% / 3%** e i suoi stessi criteri (§6, "conversione campo") mettono agli atti che **una sedia short-only a 1,95% per trade impegnerebbe fino al 60% del cap 3,25% con UN SOLO SL vivo**. Se un dial alto passasse il cancello di portafoglio, il conto lo pagherebbe il cap: la delibera dovra' pesarlo **prima** di accendere, non dopo. Il cap resta com'e' firmato — e' il contratto della sedia nuova che dovra' starci dentro |
| C2 | **Max sedie accese simultaneamente** a taglia prop | **nessun numero di sedie: il vincolo giusto e' sugli SL VIVI (= C1)**. Con cap a 5 unita', 8+ sedie accese convivono se operano in orari diversi — le correlazioni ~zero di R16 restano il motivo per tenerle | 🥇 M2 §5: la misura dice che il problema e' il **PICCO simultaneo**, non quante sedie sono accese (la griglia BULGE da sola faceva 10 posizioni = 6,50% con UNA sedia: contare le sedie non l'avrebbe vista) | nessuno | 🧊 **CONGELATO (18/08/2026, con C1: la frase firmata dice esattamente "il vincolo conta gli SL VIVI, non le sedie accese" — e' il contenuto di questa riga)** |
| C3 | **CRITERIO DI USCITA delle sedie accese** | **TRE CORSIE + porta di rientro** (testo firmato): **(1) RISCHIO — per sedia, sempre, a qualunque n**: DD forward oltre il DD promesso dal backtest della cella → intervento IMMEDIATO (revisione d'urgenza; lo spegnimento resta parola di Claudio) · **(2) MERITO — per FAMIGLIA, a 20 operazioni totali** in perdita → revisione di tutte le sedie, **si spegne la SEDIA colpevole** (in perdita e oltre il suo DD promesso), la gemella positiva resta · **(3) TAGLIANDO — 6 mesi**: famiglia sotto le 20 op e in perdita → revisione di Claudio (valvola R59: il campione sottile non da' verdetti di merito automatici); anche frequenza operativa MOLTO sotto la promessa manda in revisione · **porta di rientro**: una sedia spenta rientra se una misura nuova le rida' una ragione | 🥇 `DOVE_SIAMO_17-08.md` §5 (bozza) + discussione con Claudio (le sue due obiezioni — "20 op tutte positive?" e "gli EA lenti quanto ci mettono a farne 20?" — hanno modificato la regola: merito per FAMIGLIA, non per sedia) | ⚠️ **prerequisito dichiarato alla firma: il CENSIMENTO DEI CONTRATTI** (per ogni sedia: DD promesso + op/mese promesse, dal referto che l'ha promossa). _"Senza tabella, la regola e' inchiostro"_ → **M11, lavoro lanciato oggi** | 🧊 **CONGELATO (18/08/2026, "firma tutte e 3" — verbale FIRME, FIRMA 2)** — ✅ **v7: OPERATIVA.** M11 esiste (`report/CONTRATTI_SEDIE.md`): 44 sedie, **40 contratti pieni · 2 parziali · 2 SENZA CONTRATTO** (770201 Nasdaq Apertura, con due verdetti negativi agli atti; BREAKOUT_EA_JPY_v3, famiglia scartata pre-progetto) **+ 1 promozione REVOCATA che gira ancora** (970914, illusione OHLC). ✍️ **v8-v9 — PRIMA APPLICAZIONE COMPLETATA: FIRMA 5** (770201, BREAKOUT_EA_JPY_v3, 970914) **eseguita e VERIFICATA alle 09:41**: righe sparite dal censimento, somma 44,55→43,30 esatta al decimale; la JPY era gia' un fantasma da un mese. Porta di rientro JPY aperta con l'analisi del corso BREAKOUT |
| C4 | **Budget DD per sedia quando CONDIVIDE il conto** | la regola implicita che esce da tre fonti: **rischio per sedia ≈ budget totale ÷ n. sedie** (e per una sedia sola si puo' salire) | 🥉 **da 1 fonte a 3 (v3)**: Gold Phantom `Propfirm_combo` 9→4 (Profalgo) · The Impossible Prop (_"both EAs **share the daily DD budget**"_; da solo si sale a 1,0-1,25%) · Eriksson (_"**divide** total account risk **equally** across multiple EAs"_) — piu' le affini PROPstyle/NYAO della 1ª notte | noi facciamo l'esatto contrario (ogni sedia col rischio pieno come fosse sola). 🥇 **M2 declassa la divisione rigida (v4)**: il problema misurato e' il **PICCO simultaneo**, non la somma astratta — il cap C1 e' lo strumento **piu' mirato** (budget÷sedie punirebbe anche le sedie che non si sovrappongono mai) | 🔓 APERTO — alternativa di riserva a C1: si riapre solo se il cap in pratica non basta |
| C5 | **Rischio per trade se il DD e' TRAILING** | ~~NON LO SAPPIAMO~~ → **MISURATO (M1, 18/08)**: trailing EOD p99 **12,05%** a 0,65% · **9,27%** a 0,50% · **7,41%** a 0,40% (statico esatto: 8,51 / 6,74 / 5,63). A rischio 1% p99 18,53%: col trailing non si parte nemmeno. **Il blocco al breakeven vale oro**: sfondamento del muro 10 a 0,65% da 4,6% → **0,2%** | 🥇 `REFERTO_M1_MC_TRAILING.md` — stesse 27 serie, stesso ricampionamento della statica (baseline riprodotta al centesimo), criteri congelati PRIMA (commit `2ae7077`), seed 42 riproducibile | limiti dichiarati: finestra unica ~12,6 mesi OOS, niente equity flottante intrabar (la variante B per-trade e' ~1 punto peggio: se la prop traila sull'EQUITY, stringere di un punto), scala lineare senza compounding | ✅ **CHIUSO — MISURATO (v4)**. Le conseguenze operative vivono in F3 (taglie per muro) e A1 (perimetro del congelamento) |

| C6 | **R83-bis — l'EA delle aperture a TRE INGRESSI, e il suo vincolo di portafoglio** (nuova, v11) | UN nuovo EA con `InpEntryMode` (0=breakout stop, l'ingresso di casa · 1=limit sul retest · 2=market alla conferma). Ogni modalita' = **cella separata nell'imbuto** (magic diverso, duello alla pari con la sedia viva), **MAI segnali miscelati** nella stessa posizione. Vincolo firmato: le tre modalita' si innescano sullo **stesso evento di apertura** → posizioni CORRELATE per il cap C1: **al massimo UNA modalita' per mercato va in forward**, scelta col duello | 🥇 verbale `FIRME_2026-08-18.md`, FIRMA 6 ("SI,FIRMO R83BIS") + criteri duello congelati (commit `c305355`: 7 celle, canarino di equivalenza obbligatorio, asimmetria slippage dichiarata) | la raccomandazione di casa ha vinto sulla prima idea (3 EA separati): UN solo EA, tre modalita' attribuibili | 🧊 **CONGELATO (18/08/2026 sera, FIRMA 6)** — ⚙️ **v12: DUELLO ESEGUITO (R83), EA COLLAUDATO e in ARMERIA** (canarini di equivalenza al centesimo su ENTRAMBI i core — 291/291 e 311/311 trade identici — autotest 6/6). Esiti: **sul DAX il RETEST vince** (+999 OOS, PF 1,19) e **INCORONA la config della sedia viva 770101** (la divergenza #15 dell'audit si chiude a favore del campo — nulla da cambiare); **sul Nasdaq zero modalita' positive** (retest = disastro: 0,62, DD 29,1%; autopsia: 74/78 perdite = stop pieni 1R contro vincite medie 0,18R). Lezione trasversale misurata: **la stessa regola d'ingresso cambia segno tra mercati** — ogni estensione a un altro indice RIFA' il duello, non eredita il retest. Il round propone, non promuove |

> 🧬 **Nota nuova (v4, dall'anatomia di M2): i GEMELLI originale+Ottimizzato
> sono un rischio di duplicazione PROP.** Girano in parallelo per regola di
> casa (magic diversi, mai sostituirli) — e va benissimo **sul conto di
> sviluppo**. Ma la misura mostra che sparano **lo stesso segnale nello
> stesso secondo ogni mattina** (DAX Apertura EU + OTT alle 08:15:29-34;
> Live5m + v2 idem; EMA200 S1 + OTT S1): **su una prop sono una posizione
> DOPPIA** — 1,3% su un segnale solo, piu' un pattern "input identici"
> visibile (→ E6). Alla squadra prop si porta **UN gemello per famiglia**
> (il dry-run 100k gia' fa cosi'). E il pile-up tipo del 03/08 e' leggibile:
> **gli swing si accumulano per giorni, le aperture ci si sommano sopra in
> un secondo.**

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| C7 | 🎛️ **LA MANOPOLA GLOBALE (dial) DELLA FLOTTA — e il piano DUE-DIAL** (nuova, v14) | **challenge: d = 1,00** (= le taglie firmate oggi, flotta post-revisione "A+b") · **funded: d = 0,74**. Il dial scala **linearmente tutta la flotta**; NON e' un parametro per sedia | 🥇 `ANALISI_DIAL_TAGLIE_2026-08-26.md` (base `R105_dataset_giornaliero.csv`, 481 giorni × 40 sedie, **controllo positivo riconciliato al centesimo** su 7 numeri agli atti): a d=1,00 **pass 99,6%**, mediana **12 giorni**, **0 violazioni**; **dirupo misurato a d≈1,055** (il 25/05/26 tocca il −5% esatto); a d=1,15 il pass **SCENDE** a 96,7% con **15 partenze bruciate**; a d=1,50 → 89,2% e 51 bruciate. Profitto mediano per challenge passata **quasi piatto 8,5-9,3 k€** (la corsa si ferma al target: il dial alto arriva **prima**, non **piu' in alto**) · 🥇 `ANALISI_SOPRAVVIVENZA_FUNDED_2026-08-26.md`: sopravvivenza funded 12 mesi **100% da 0,50 a 1,00** (statico E trailing), ma **87,8% a d=1,10**, **43,0% a 1,30**, **0,0% a 1,50** — e l'aritmetica dell'esposizione: **21 volte** i giorni neri di una challenge dentro un anno funded | 🔴 **CONFLITTO FRA DUE MISURE DI CASA, STESSO RANGO — dichiarato, non nascosto**: `R106_REFERTO.md` (25/08) raccomanda per la **challenge** la squadra **B = flotta × 0,74** (_"il premio assicurativo piu' economico mai misurato in casa"_); l'analisi del 26/08 raccomanda **1,00 in challenge e 0,74 in funded**. Non e' una contraddizione sui NUMERI (tornano al centesimo: a +10% il d=1,00 passa 99,2% e lo 0,74 98,3%) ma sull'**argomento**: R106 compra margine dal muro sempre, la due-dial lo compra **dove l'esposizione dura** (12 giorni contro 252). ⚠️ Avvertenze che valgono per TUTTE e due: **(a)** lo scaling lineare e' **ottimista** (R109: tetto `SYMBOL_VOLUME_MAX`, slippage che cresce — 21,5 punti misurati su uno stop Nasdaq); **(b)** le chiusure giornaliere sono un **limite inferiore** del rischio (il flottante intraday non c'e'); **(c)** il **Guardian non e' modellato** e non e' gratis: a dial alto trasformerebbe drawdown temporanei in **perdite chiuse** — _"alzare confidando nel Guardian cambia la macchina, non solo la scala"_; **(d)** 481 giorni = **UN SOLO regime, toro** | 📋 **PROPOSTO — e' il CANCELLO 5.** Il dial 1,00 e' **gia' congelato come stato dei contratti in campo** (firma "A+b" del 24/08: 4 sedie spente, 5 ridotte); cio' che **manca la firma** e' l'uso del dial **come scelta di fase** (1,00 in challenge / 0,74 in funded). 🛑 **Nessun cambio di taglia esce da qui**: ogni spostamento e' una firma sui CONTRATTI, riga per riga, con le avvertenze (a)-(d) lette ad alta voce. E la risposta secca all'idea di partenza di Claudio (_"aumentare i lotti confidando nel Guardian"_) e' **misurata: sopra la taglia firmata non c'e' spazio, c'e' un dirupo a 1,05** |

> 📉 **Corollario di C7 — LA SPECIFICA DEI MURI DA CHIEDERE ALLA PROP** (🥇
> `ANALISI_DD_TOTALE_2026-08-26.md`, 26/08, stessa base riconciliata): alla
> taglia firmata il **DD totale peggiore mai visto e' −6,37%** (picco-valle
> sui chiusi), contro un **worst day −4,74%**. Cioe': **il muro che morde e'
> il GIORNALIERO** (margine **5%**), non il totale (margine **36%** contro un
> muro 10%) — ed e' esattamente dove il Guardian gia' lavora (pausa 4,0).
> Il DD totale e' **"un giorno cattivo piu' poco"**: 6,37 ≈ **1,3 ×** il
> worst day, le discese non si accumulano su settimane. 👉 **La specifica per
> il cacciatore-config-prop e' quindi: 5% giornaliero / 10% totale STATICI.**
> Un totale statico all'**8%** reggerebbe ancora (0 violazioni su 481
> partenze; le prime a d=1,30), ma **senza necessita' non si compra margine
> piu' stretto**. E un totale **6% TRAILING si romperebbe persino sui
> chiusi** (6,37 > 6): **muri statici o niente** — la bocciatura di Upcomers
> (F7) esce confermata da una seconda strada indipendente.

# AREA D — 📰 NEWS E ORARI

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| D1 | **Filtro news di CONFORMITA'** (finestre strette, per non violare la regola) | modulo `.mqh` con doppia alimentazione: **dal vivo** `CalendarValueHistory()` (zero DLL/WebRequest — base gratuita gia' in biblioteca: `NewsFilter_IvanPochta_*.mqh`, 283 righe, default 60/60 da stringere) · **nel tester** lettura del **calendario esportato in CSV** da `Common/Files`. Input SPENTO di default; minuti = quelli della prop scelta | 🥈 regole prop [LETTO-VIA-SEARCH]: FTMO Standard ±2 · The5ers ±2 · E8 ±5 · FundingPips **±10 anche solo TENENDO** · FTMO Swing: nessuna · 🥉 metodo CSV: manuale Range Breakout [VERIFICATO] (_"save the MT5 economic calendar as a CSV-file in the Common/Files directory"_) · 🥉 **2 CSV gia' in `biblioteca/dati/`**: 2021-2025, 37.799 righe, `data;paese;impatto 0-3;evento`, fuso **UTC+2 [VERIFICATO per ricalcolo su ISM e ADP] → su BCM (UTC+1 in agosto) va tolta UN'ORA** | 🔄 **SBLOCCATA v3: il "non backtestabile" CADE.** Resta vero per la FUNZIONE (`CalendarValueHistory` muto nel tester), falso per il metodo: il calendario si esporta dal terminale vivo e si rilegge da file — **il filtro diventa misurabile con l'imbuto di casa**. Restano: i minuti dipendono da F1; l'attenzione al fuso dei CSV; e la parita' vivo/tester va verificata (due percorsi di codice = da collaudare che decidano uguale) | 📋 **PROPOSTO (v3, era APERTO)** — costruzione del modulo backtestabile; i MINUTI restano legati a F1. 💪 **v11, gamba grossa dal verdetto sui piani di apertura**: la routine del piano stesso (_"prima di ogni dato a 3 tori tolgo tutto"_) e' **PIU' severa** di FundingPips ±10 ed E8 ±5 — **col filtro acceso a ≥10 minuti le sedie di apertura sono compliant BY DESIGN su tutte e sei le prop censite**, e oggi lo teniamo spento (fedelta' #12). La finestra da governare: **16:00 IT** (PMI/ISM/Michigan alle 15:45-16:00 con trade Nasdaq/Dow vivo da 15-30 minuti: parziale/trailing/BE che esegue li' = violazione su FundingPips ed E8) |
| D2 | **Filtro news di PROTEZIONE** (finestre larghe, es. NFP 100 min prima) | **non accenderla** senza decisione esplicita: cambia l'edge e non si puo' misurare | 🥉 Gold Phantom (NFP 100/60 con chiusura dell'aperto) | e' una modifica di strategia travestita da protezione; "lo fanno tutti" non e' una fonte. 2ª notte: il campione delle finestre va **da 5 a 100 minuti** (Range Breakout 5 · TIP 30/15 · guida 772732 30/30 · NewsFilter.mqh 60/60 · Gold Phantom 100/60): **nessuna convergenza, nessun numero da copiare** — la cautela del piano e' confermata dai numeri. Nota: col metodo CSV di D1 anche QUESTA diventa misurabile, se un giorno la si vuole giudicare | 🔓 APERTO — 🎬 trascrizioni: niente anche qui |
| D3 | **Auto-GMT** (orari di sessione in UTC + offset rilevato, invece che cablati in ora server BCM) | helper `ABTG_TimeZone.mqh`, `InpAutoGMT=false` di default | 🥉 Gold Phantom (`AutoGMT=true`, offset 2/3) · 🥉 2ª notte, mezza gamba: TIP dichiara le sessioni **in GMT** e Range Breakout ha `TimeOffset` per correggere da UTC+2 — **due modi diversi, ma l'offset e' sempre un INPUT, mai cablato** (noi lo cabliamo) · 🥇 `METRO_PROP` §11: Pepperstone e' UTC+0, un'ora dietro BCM; il giorno della challenge il server e' quello della prop | 🔴🔴 la proposta **piu' pericolosa** (P9): tocca `InpSessionHour`, dove il progetto ha gia' sbagliato (regola: DAX=8, se 9 → cestinare). Un bug qui rende spazzatura ogni backtest. Non urgente oggi; lo diventa il giorno dell'acquisto | 🔓 APERTO — da fare SOLO con round di verifica dedicato |
| D4 | **Compatibilita' overnight delle sedie notturne** | vincolo di scelta prop, non parametro: `MaxMinNotte` (box 23:00-04:59 srv), `Nightly` (22:00-04:59), variante oro (22:00-06:00) devono essere AMMESSE | 🥇 `METRO_PROP` §3 · 🥈 E8 Signature chiude tutto alle 23:00 server → **tre sedie senza setup, non "da adattare"** · v11: stessa riga per il **breakout notturno del PDF dei piani** (🔴 vietato su E8 Signature, 🟠 altrove) | nessuno: e' un filtro sulla scelta in area F | 🔓 APERTO (si chiude con F1 + risposta scritta) |
| D5 | **Filtro news del FiboH4** (nuova, v10 — dall'analisi del corso) | il modulo FiboH4 e' **il piu' prop-compatibile del corso intero**: filtro news **OBBLIGATORIO** (Forex Factory/Investing, esclusione per valuta, deroga a ≥100 pip), overnight vietato (cancella alle 18:30-19), weekend **"mai e qua dico mai"**. 🔎 E la scoperta di casa: **il nostro `ABTG_FiboH4_Multi` il filtro CE L'HA GIA', a CSV, ed e' SPENTO** (`InpUseNewsFilter=false`, legge `abtg_news.csv`, impatto/minuti configurabili) — cioe' il meccanismo CSV di D1 esiste gia' in un nostro EA, coi 2 calendari 2021-2025 gia' in biblioteca | 🥉 `ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md` §1.7 · 🥇 sorgente `ABTG_FiboH4_Multi.mq5` (righe 75-80) | lo stesso corso e' incoerente: il modulo gemello Media200 il filtro **non lo nomina mai** in 5 lezioni. E accendere un filtro cambia l'edge: passa dall'imbuto (ora misurabile, D1), non da un interruttore | 🧪 **IN MISURA (R93, 21/08)** — era APERTO. Il filtro **non era usabile nel tester**: colonne dei calendari SCAMBIATE (impatto letto da "United States" -> 0 -> non bloccava mai) e sandbox degli agenti (il CSV non arrivava). Chiusi tutti e due: convertitore + `Common\Files` + canarino "acceso ma cieco". Atteso **8-12% di barre bloccate**, calcolato PRIMA. Accensione ancora legata a D1/F1: **R93 misura il COSTO della conformita', non promuove** |

⏰ **Orari, sempre anche in ora server BCM** (agosto: BCM = italiana − 1 = UTC+1):
reset FTMO 00:00 CE(S)T = **23:00 BCM** · FundedNext / FundingPips / Alpha
00:00 UTC+3 = **22:00 BCM** · The5ers / E8 "00:00 ora server" = **[INCERTO]**,
offset dei loro server non verificato. Tutta la riga e' [LETTO-VIA-SEARCH].

# AREA E — 📜 CONFORMITA' ALLE REGOLE

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| E1 | **Invio delle domande al supporto (regola D3)** | riattivare l'invio quando il forward pulito ha 1-2 settimane. **v4: alla lista si aggiunge di diritto la domanda del breakeven-lock** (_"il pavimento trailing si blocca al capitale iniziale?"_ — M1: cambia lo sfondamento da 4,6% a 0,2%, cioe' comprabile o no) | 🥇 `DOMANDE_SUPPORTO_PROP.md` (pronte dal 13/08, invio RINVIATO per decisione di Claudio) · `METRO_PROP`: il forward pulito ricomincia dal 15/08 → 1-2 settimane ≈ **fine agosto** · 🥇 M1 §4.1 per la domanda nuova | tutto il censimento prop e' [LETTO-VIA-SEARCH]: **una regola letta male squalifica un conto vero**. E' la cosa a costo zero che vale piu' di tutto il dossier | 🔓 APERTO — decide Claudio quando; la domanda breakeven-lock va aggiunta al file D3 prima dell'invio |
| E2 | **Stessa flotta su due conti = "copy trading"?** E l'hedge? | chiarire per iscritto (domanda gia' nel file D3) | 🥇 `METRO_PROP` §5 · 🥈 FTMO cap $400k per trader O strategia · E8 "una strategia per utente" · 4° trascrizioni (scheda 4, FundedNext): **hedge multi-account VIETATO** (stesso simbolo, long su un conto e short sull'altro), **hedge sullo stesso conto permesso** — risponde a voce alla domanda tipo-2 del file D3 (OCO stesso conto = ok) — e il relatore dichiara di averlo confermato **per iscritto col supporto: e' la regola D3 in azione, fatta da un altro** | la conferma e' SUA, non nostra: per la regola di casa serve la NOSTRA risposta scritta. E il nostro caso vero (stessi EA, stesso LATO, su due conti) e' copy, non hedge: resta da chiedere | 🔓 APERTO — perimetro piu' chiaro, chiusura solo per iscritto |
| E3 | **Consistency / best-day**: quanto pesa il nostro giorno migliore? | misurarlo sui dati che abbiamo (agosto + serie R16) — oggi **non lo misuriamo neanche a posteriori** (buco n.27) | 🥈 FTMO 50% · FundedNext 40% (Rapid Pro) · E8 ~40/35% [INCERTO, fonti terze] · 🥇 `METRO_PROP` §6: con 27 serie una giornata grossa e' statisticamente ATTESA — la regola colpisce la forma della nostra curva · 🥉 **2ª notte: un vendor la misura DENTRO l'EA** (guida 772732): `Best Day Rule Max=50%`, `Minimum Trading Days=4`, `Challenge Start Date` per non contare lo storico vecchio — **meccanismo copiabile**, non solo metrica a posteriori | nessuno sul fatto che vada misurato | 🔓 APERTO — misura interna, costo basso; ora c'e' anche il modello per farla in tempo reale |
| E4 | **Cap richieste server** (FTMO: max 2.000/giorno) | contare quante ne facciamo (28 magic + Guardian a timer 1 s) — [INCERTO] oggi | 🥈 scheda FTMO (buco n.30) | nessuno | 🔓 APERTO — misura interna |
| E5 | **Randomizzazione degli ingressi** | **NON farla ora**, registrata | 🥉 5 prodotti su 7 ce l'hanno, uno la accende SOLO nel preset prop (Gold Phantom `Randomization=50`) · 🥉 trascrizioni: 3 fonti su 7 la usano — ma per **anti-detection**, che per noi e' vietato (→ E6) | serve solo con due conti/prop insieme (→ E2); farla oggi e' complessita' senza beneficio — e la lettura di P8 ("serve a non risultare strategia identica") e' confermata dal parlato | 📋 PROPOSTO (proposta = rinvio esplicito, P8) |
| E6 | **Cosa le prop RILEVANO** (intelligence difensiva, dal video marcato VIETATO PER NOI) | registrare e rispettare: le prop leggono **(a) il magic number** (magic 0 simula trading manuale — e' il trucco insegnato, quindi e' il controllo che fanno), **(b) input identici fra conti**, **(c) "tratti simili"** fra utenti dello stesso EA di mercato. Per noi: **mai magic 0, mai mascherare** — i nostri EA sono nostri, magic dichiarati, e la trasparenza e' la difesa (un EA proprietario non ha "magic condiviso fra utenti" da nascondere) | 🥉 trascrizioni: 3 fonti su 7 vendono anti-detection (Petko/app "magic unico per download", venditore-86% "soluzione tecnica per mascherarlo", Blue Edge randomization) — convergenza alta su COSA viene rilevato | nessuno: e' intelligence, non un valore da tarare. L'unico uso operativo e' in E2 (due conti nostri) e nella domanda D3 gia' scritta | 📋 PROPOSTO (registro difensivo; nessuna pratica di occultamento, MAI) |
| E8 | ⏱️ **DURATA MINIMA DEI TRADE (regola "tick scalping") — e cosa sappiamo davvero misurare** (nuova, v14) | registrare il vincolo e **misurarlo prima di scegliere la prop**: alcune prop classificano come *tick scalping* ogni trade chiuso **sotto i 2 minuti**. Non e' un parametro da tarare: e' un **filtro sulla scelta in area F** e, se la prop scelta ce l'ha, una condizione di sopravvivenza dei motori d'apertura | 🥈🟡 `DOSSIER_PROP_UPCOMERS_2026-08-26.md` §2-bis A (**[LETTO-VIA-SEARCH]**: _"minimum of 2 minutes"_, help/12640252) · 🥇 **la misura fatta in questo giro sul forward vero** (`data/statements/trades_auto.csv`, durata = `close_time − open_time`): sulle chiusure degli EA **dal 20/07** (la flotta di oggi) **39 su 256 = 15,2%** stanno sotto i 2 minuti; sull'intero storico del CSV **42 su 561 = 7,5%**; e la concentrazione e' dove ci si aspetta: **famiglia Aperture DAX 17 chiusure su 39 = 44%** sotto i 2 minuti; sul **dry-run 100k**: 1 su 15 | 🔴 **CONFLITTO CON UNA FONTE ESTERNA — risolto dalla gerarchia, e va scritto**: il dossier afferma che la durata dei nostri trade _"non e' misurabile ne' in backtest ne' in forward"_ perche' manca `open_time`. 🥇 **In FORWARD e' falso**: il CSV del `TradeExporter` **ha** `open_time` (l'ha da sempre: la pagella giornaliera stampa gia' la "durata media"), e i numeri qui accanto lo dimostrano. **In BACKTEST invece e' vero**: `ExportTrades()` degli EA esporta solo `close_time` (debito M2, ripetuto in `METRO_PROP` §13.2 → M18). Il buco quindi e' **meta' di quanto dichiarato**, e la meta' che resta e' quella che serve per giudicare una cella PRIMA di metterla in campo | 🔓 **APERTO (v14)** — si chiude in due mosse: **(1)** la prop scelta dichiara per iscritto se ha una durata minima **e se vale anche per un trade chiuso dal proprio STOP LOSS** (domanda gia' scritta, `DOSSIER_PROP_UPCOMERS` §9-P5 n.4 → va copiata in `DOMANDE_SUPPORTO_PROP.md`); **(2)** `open_time` in `ExportTrades()` (M18). ⚠️ Nota di merito: **il 44% delle Aperture DAX sotto i 2 minuti non e' un dettaglio** — su una prop con quella regola quella famiglia sarebbe **strutturalmente a rischio di contestazione**, ed e' proprio la famiglia piu' numerosa del forward |
| E7 | **Igiene di configurazione — le lezioni del setaccio 2ª notte** (regole di casa da tenere a registro) | tre lezioni: **(1)** _"prop-ready" ≠ senza recovery_: **3 famiglie su 8** lette hanno un moltiplicatore di recupero nei parametri (Ultimate EA: input `martingala` + TIME GRID 15 trade senza SL individuali · FTMO Smart Trader: `DOWN_LOTS=2,02` **con `equity_stop=0`, spento in tutti e 6 i preset** · guida 772732: `Multiplier After Loss=2,0`, max lot recovery 20,48) — e il "preset prop" e' spesso **il preset normale con la martingala disinnescata** (`DOWN_LOTS` 2,02→1,01); **(2)** 🚩 anti-pattern del **cap in VALUTA**: FTMO Smart Trader mette `DAILY_DD_` a −500/−1000/−2000 — su 100k e' 0,5-2%, su 10k e' **5-20%: lo stesso file passa o sfonda a seconda della taglia**. I cap si esprimono SEMPRE in % (il nostro Guardian lo fa gia' ✅); **(3)** l'aggressivita' si cambia nel motore o nella taglia, **mai nelle protezioni** (regola visibile in Prop Firm Pass 5/5 e Range Breakout 32/32: i profili differiscono solo su rischio/taglia, le protezioni sono identiche) | 🥉 raccolta §1D/§6 (setaccio su 8 famiglie, `.set` alla mano [VERIFICATO]) | nessuno | 📋 PROPOSTO (registro d'igiene: vincola come scriviamo/leggiamo i preset, non tocca il forward) |

# AREA F — 🎯 SCELTA DELLA PROP

| # | parametro | valore PROPOSTO | fonti (rango) | conflitti | stato |
|---|---|---|---|---|---|
| F1 | **Prop di riferimento del piano** | **FTMO 2-Step 100k** come ipotesi di lavoro (e' gia' il preset del Guardian e il modello del dry-run): daily 5% / totale 10% **STATICO** — l'unico modello coerente con le MC che abbiamo | 🥇 dry-run impostato cosi' dal 09/08 · 🥈 confronto 6 prop del dossier §2G: FundingPips ±10 min news anche tenendo (ostile), E8 daily 4% + chiusura 23:00 (uccide 3 sedie), Alpha/FundedNext/The5ers possibili alternative · 4° trascrizioni: **FundedNext 1-Step = 3% daily / 6% totale** [dichiarato a voce, 2 fonti su 7] — daily 3% e' 🔴 per il metro di casa (la nostra peggior giornata −2,06% ne mangia i due terzi, `METRO_PROP` §2); FundedTrading+ "5%/5% con DD rimosso dopo il target" [INCERTO, canale affiliato] | 🔴 TUTTO il censimento e' [LETTO-VIA-SEARCH]: nessuna riga autorizza un acquisto. FTMO Swing da confermare (F2). **Non e' una scelta d'acquisto: e' il metro su cui si tara il piano** | 📋 PROPOSTO |
| F2 | **Tipo di conto** (se FTMO) | **Swing** — nessuna restrizione news, overnight/weekend ammessi: toglie di mezzo D1 e D4 in un colpo | 🥈 scheda FTMO §2A [LETTO-VIA-SEARCH] · 🥇 le domande D3 sono gia' scritte per lo Swing · 🥇 v11, verdetto piani apertura: **FTMO Swing = la corsia larga** (le sedie di apertura "eseguibili piene, zero restrizioni news") | da confermare per iscritto (gap weekend, bracket OCO, multi-firm: le 3 domande del file D3) | 🔓 APERTO — 🎬 trascrizioni: **nessuna esperienza Swing** nei 7 relatori (l'unico racconto FTMO vissuto, BM Trading, non dice il tipo di conto). Si chiude solo con la risposta scritta |
| F3 | **Prop 1-Step / DD trailing** | ~~divieto~~ → **NUMERI (v4, da M1)**: muro trailing **10%** solo a taglia **≤0,50%** (p99 9,27, sfondamenti 0,2%) · muro **8%** solo a **≤0,40%** (p99 7,41) · muro **6%: MAI**, a nessuna taglia misurata · a 1% non si parte (p99 18,53, sfonda il 47%). ⚠️ Se il trailing e' su **EQUITY** e non su saldo EOD: stringere di ≥1 punto (variante B). E **prima di qualunque 1-Step: chiedere per iscritto se il pavimento si BLOCCA AL BREAKEVEN** — cambia lo sfondamento da 4,6% a 0,2% a 0,65: e' la differenza fra comprabile e no | 🥇 `REFERTO_M1_MC_TRAILING.md` (verdetto congelato: taglia OK se p99 variante A < muro) · 4° trascrizioni (PropEA): "solo su drawdown statico" — coerente | la regola FTMO 1-Step usata nella variante A e' [LETTO-VIA-SEARCH]: prima di comprare, risposta scritta (D3). E la corsa al target (PASSA 99,8% a 0,65/muro 10) NON e' il criterio: la challenge e' il biglietto di un conto che deve VIVERE — il criterio congelato resta il p99 | 📋 PROPOSTO (v4: da divieto a tabella delle taglie — il divieto previsto "si scioglie con C5" si e' sciolto) |
| F4 | **Quando si compra** | solo dopo **forward maturo** + **risposte scritte** del supporto | 🥇 regola madre di `METRO_PROP` (decisione di Claudio del 13/08 sul rinvio D3); il forward pulito parte dal 15/08 | agosto a −11% sul piccolo dice che la domanda "quando" oggi ha una sola risposta onesta: **non adesso** | 🧊 **CONGELATO (13/08/2026, decisione di Claudio: D3 in pausa, prop pagata solo dopo forward maturo)** — riguarda le CHALLENGE; per gli EA a pagamento vedi F5 |
| F5 | **Cancello d'acquisto degli EA a pagamento** (procedura) | 5 gradini in ordine, nessuno si salta: scheda prodotto → **1-bis due diligence sul VENDITORE** (Market → Google → Forex Peace Army → Forex Factory; nato dal caso XT Prop Firms: vendor con dossier FPA guilty 79-0) → setaccio bandiere (recovery = scarto anche a 10 euro) → **demo nel tester coi criteri scritti PRIMA** → verdetto col metro di casa → decisione di Claudio. Regole dure: niente sorgente = niente modifiche ne' certezze · **noleggio prima dell'acquisto dove esiste** · i numeri del venditore valgono ZERO | 🥇 `backtest_pipeline/caccia_strategie/CANCELLO_ACQUISTI_EA.md` (18/08 notte) | nessuno — e il file dichiara che F4 (challenge) resta intatto | 🧊 **CONGELATO (18/08/2026, decisione di Claudio: "se ci dovessero essere degli EA a pagamento che possono essere utili... sono disposto a pagarli" — procedura congelata prima dei casi)** |
| F6 | **Primo candidato al cancello: `Range Breakout Daytrader`** | avviare i gradini 1→3 del cancello F5 (nessun acquisto: prima scheda completa, due diligence, poi demo nel tester coi criteri congelati prima) | 🥉 raccolta §1C [VERIFICATO]: **32 preset pubblici letti** — e' la famiglia **piu' vicina alle nostre sedie di apertura** (range breakout su USDJPY/US30/XAUUSD/BTCUSD), con filtro news a 5 min, chiusura di sessione, scala di rischio pulita (protezioni identiche sui 4 profili) e il manuale che insegna il metodo CSV di D1 · setaccio §6: nessuna bandiera trovata nelle pagine lette ([INCERTO]: senza sorgente non e' escludibile) | 🔴 **v7 — LA DUE DILIGENCE 1-BIS E' ESEGUITA E PESA** (scheda GRADINO1 in biblioteca, commit `7f05161`): vendor **pulito**, MA il **track record LIVE pubblico del suo stesso preset prop** (Extra Low Risk USDJPY, Darwinex reale, verificato dal broker) fa **PF 0,94 su 248 operazioni in 2 anni, −8,15%**. Il preset da challenge, in live, PERDE — sono numeri del vendor su conto vero, non marketing. Raccomandazione agli atti: **niente noleggio $59** (il noleggio serve al forward, e il forward del vendor esiste gia' e dice 0,94); resta solo l'eventuale **demo gratuita nel tester** (coi criteri da congelare prima, M10). Riserve precedenti confermate: ExtraLowRisk 2,4%/trade = 3,7× il nostro 0,65; niente sorgente, mai | 📋 PROPOSTO — **sconsigliata dagli atti: si chiude salvo demo gratuita. La parola resta a Claudio** |

| F7 | 🚫 **UPCOMERS "Thunderbolt" — BOCCIATA** (nuova, v14; e con lei il **filtro di scelta** che ne discende) | **non comprare.** E la regola generale che ne esce, proposta come filtro del CANCELLO 3: **si istruiscono solo prop a muri STATICI 5/10 (o comunque compatibili con la nostra distribuzione misurata), con EA ammessi per iscritto**. Le altre si schedano e si archiviano | 🥈🟡 `DOSSIER_PROP_UPCOMERS_2026-08-26.md` (**[LETTO-VIA-SEARCH 26/08]**, controllo positivo dei canali eseguito: `curl` e WebFetch **403/EGRESS_BLOCKED**, solo la ricerca viva e centrata sul bersaglio di controllo FTMO): fase unica, **target 5%**, tempo illimitato, 0 giorni minimi, split 99%, **EA AMMESSI dal 26/05/2026** (help/11704867 + comunicato GlobeNewswire), overnight e weekend liberi — **ma muro giornaliero 3%** (base `max(equity,balance)`, reset **00:00 UTC = 01:00 BCM d'estate, 00:00 d'inverno**) e **muro totale 6% TRAILING su equity** col flottante incluso, che si blocca al breakeven solo a **+6% di balance, cioe' DOPO il target del 5%** · 🥇 il metro di casa che la boccia: **p99 8,51% su DD STATICO** (M1) contro un muro **6% trailing**; **peggior giornata −2,06%** = **69% di un muro del 3%** | 🔴 la ragione dirimente **non e' l'affidabilita': e' l'aritmetica** — la nostra coda al 99° percentile sfonda un muro del 6% **anche se fosse statico**, e questo non lo e'. Registrati comunque i segnali che pesano su una decisione futura: T&C che dicono per iscritto _"users shall not be entitled to any fees or profits"_ (**stessa clausola** con cui `INDAGINE_PROP_INSTAGRAM.md` boccio' Alpine e Meridian), **delisting da PropFirmMatch**, entita' **Saint Lucia registrata nel 2025** senza alcun regolatore, due profili Trustpilot (**4,1** sul dominio marketing contro **2,7** sul dominio dell'app), pattern coerente di payout negati per **one-sided bets** e **tick scalping**. ⚠️ E due cavilli che colpiscono proprio noi: la **regola dei 2 minuti** (→ E8) e i **one-sided bets** contro le nostre sedie mono-direzione dichiarate nel nome (`MaxMinNotte_DAX_Short`) — dove, unico punto d'incontro, la **REGOLA DEI DUE LATI** firmata il 25/08 diventerebbe anche un requisito contrattuale. ❓ **news trading: [INCERTO]**, nessuna regola trovata | 📋 **PROPOSTO (bocciatura agli atti, decide Claudio se archiviare)** — 🛑 e comunque **nessuna riga di quel dossier autorizza un acquisto**: vale la regola D3 (risposta scritta del supporto prima di qualunque euro). Il valore che resta e' **metodologico e riusabile**: il preset per famiglia di muri (B10), la lista dei 13 parametri per rifare R106 su regole diverse, e le 7 domande gia' scritte per il supporto |
| F8 | 🎯 **IL CRITERIO DI SCELTA DELLA PROP, scritto una volta sola** (nuova, v14 — nasce dal confronto Upcomers vs FTMO) | in ordine, e **il muro si guarda PRIMA del traguardo**: **(1)** muri compatibili con la **nostra distribuzione misurata** (statico 10% → 0,65% regge; trailing 10% → ≤0,50%; trailing 8% → ≤0,40%; trailing 6% → **mai**, F3/M1); **(2)** **EA ammessi per iscritto**; **(3)** overnight/weekend ammessi (3 sedie notturne, D4); **(4)** nessuna durata minima dei trade, o compatibilita' verificata (E8); **(5)** regole news compatibili col filtro ≥10 min (D1); **(6)** nessuna clausola discrezionale che colpisca le sedie mono-direzione; **(7)** solo dopo tutto questo: target, prezzo, split | 🥇 sintesi delle righe gia' agli atti (F1-F3, D1, D4, E8) + la lezione esplicita del dossier: _"il target basso e' l'esca; il muro e' il prezzo"_ · 🥇 `METRO_PROP` §9 (_"in una prop il drawdown conta piu' del rendimento"_) | nessuno — e' l'ordinamento dei criteri gia' usati, messo per iscritto perche' **il prossimo dossier lo applichi senza ridiscuterlo** | 📋 PROPOSTO (v14) — se Claudio lo firma, diventa il mandato standard del cacciatore-config-prop |

---

## 🕳️ COSA MANCA E CHI LO PORTA

| # | buco | chi lo porta | la domanda esatta |
|---|---|---|---|
| M1 | ~~MC con DD trailing EOD~~ → ✅ **ESEGUITA** (18/08, `REFERTO_M1_MC_TRAILING.md`): a 0,65% p99 trailing **12,05% > 10** — la risposta alla domanda scritta qui ("sopra o sotto il 10%?") e' **SOPRA**. C5 chiusa, F3 in numeri, A1 perimetrata | — | — |
| M2 | ~~Misura della sovrapposizione~~ → ✅ **ESEGUITA** (18/08, `REFERTO_M2_SOVRAPPOSIZIONE.md`): max reale 5,85% (03/08), p99 5,67% → proposta C1 = 3,25%. Nota tecnica ereditata (zero urgenza): per misurare la sovrapposizione anche nei BACKTEST serve `open_time` in `ExportTrades()` — oggi esporta solo `close_time` | — | — |
| M3 | ~~Convergenze dai video~~ → ✅ **CONSEGNATO** (18/08 ~01:30, `ANALISI_TRASCRIZIONI_2026-08-18.md`): resa numerica bassa, i 4 punti caldi NON confermati dal parlato; A3/C1/D1/D2/F2 aggiornati (restano APERTI), E6 aggiunta, FundedNext 1-Step 3/6 registrato | — | — |
| M8 | **I 4 screenshot dei pannelli mostrati a video e mai dettati** (referto trascrizioni, §"Le domande per Claudio"): (1) pannello PropEA — solo per capire il meccanismo hedge, NON per usarlo; (2) **Titan X: pannello MDL + finestra news filter** — l'unico dei 4 che puo' portare un campo MINUTI per D1; (3) lista input `Prop Firm Gold EA` (motore gold time-based, affine alle nostre aperture) — ⚠️ 2ª notte: **il `.set` di questo EA non esiste pubblicamente** (verificato: c'e' solo il manuale) → lo screenshot e' l'UNICA via; (4) metriche FTMO del video BM Trading | **Claudio** (fermando i video ai punti indicati nel referto) | "screenshot del pannello, non serve il video intero — il n.2 e' quello che vale di piu'" |
| M11 | ~~Censimento dei contratti~~ → ✅ **ESEGUITO** (18/08, `report/CONTRATTI_SEDIE.md`, commit `514d8c8`): 44 sedie — 40 contratti pieni, 2 parziali (970901 senza numero di DD; Gold_Ichimoku con numeri pre-imbuto sul broker sbagliato), **2 SENZA CONTRATTO** (770201, BREAKOUT_EA_JPY_v3) + promozione revocata 970914 ancora in campo. **La C3 e' operativa**; le tre anomalie → decisione D-spegnimenti | — | — |
| M10 | ~~Scheda gradino-1~~ → ✅ **ESEGUITA con la due diligence** (18/08, `biblioteca/schede/RangeBreakoutDaytrader_GRADINO1_cancello_2026-08-18.md`, commit `7f05161`): prezzo $179 / noleggio 3 mesi $59 / 1 anno $109, vendor pulito. **I criteri demo restano da congelare SOLO SE Claudio decide di fare la demo gratuita** (vedi F6: il noleggio e' sconsigliato dagli atti) | — | — |
| M9 | Ri-trascrizione completa di `Why This Prop Firm EA Robot Survives Long-Term` — **il file e' TRONCATO** prima della parte col prodotto (12 righe utili) | **Claudio** (TurboScribe di nuovo sul video intero) | "la meta' mancante e' quella coi parametri, se ci sono" |
| M4 | Schede prop **[VERIFICATO]** (oggi tutte [LETTO-VIA-SEARCH]); offset server The5ers/E8; un `.mq5` completo di guardiano open-source | **cacciatore-config-prop** (quando i domini si sbloccano / GitHub esce dal 429) | "aprire le pagine ufficiali di FTMO trading objectives + Swing e datare la scheda; che UTC hanno i server The5ers e E8?" |
| M12 | **Piano dati indici — CAMBIATO (v10)**: il crawl Dukascopy dal PC e' strozzato dal server (25 giorni su 2.389 in 1h43m, 503/reset continui → ~7 giorni proiettati; interrotto da Claudio ~17:00). Nuova strada: **HistData per DAX/Nasdaq/Nikkei/SPX** (ZIP annuali: un anno = UNA richiesta invece di ~6.200; script `histdata_m1.py` v HD-M1-v1, autotest 8/8, feed in ora UTC-5 → shift +5 gia' misurato su 8 import su 8) · **Dukascopy SOLO per il Dow** (`USA30IDXUSD`, dal 2012 — non c'e' su HistData) · **controprova a tre feed**. Serve per: prove di regime sugli indici, campioni lunghi (Emendamento A), M13. 🧊 **v12 — passo 4 ESEGUITO, ma i 3 `_EXT` sono IN FRIGO per il cancello ZERO**: diff media H1 **0,0608-0,1010% > 0,05%** (NASUSD 0,0756 · 225JPY 0,1010 · SPXUSD 0,0608), shift **+5 confermato 3/3**, copertura 97% — esistono ma NON si usano nei round. Causa parziale MISURATA: le settimane in cui DST USA e DST Europa non coincidono (~6,6% delle ore/anno) rendono il +5 fisso sbagliato di un'ora — ma sugli indici spiegano **un quarto scarso** del residuo; il secondo sospettato (che il fuso non cura) e' il **basis cash-vs-future**, scalino sempre dallo stesso lato. La cura c'e' gia': **`ABTG_ImportaStoricoEsterno_v2.mq5` (IMP-EXT-v2) SCRITTO, DST-aware, con misura del bias firmato — NON compilato ne' provato** (sequenza di collaudo verificata in §14-bis.6). **Previsione pre-registrata prima del collaudo**: la cura DST da sola probabilmente NON basta su NASUSD/225JPY, SPXUSD forse al pelo. E **D30EUR su HistData e' BOCCIATO** (minimo 2906 impossibile + sessione alle 02:00 fra 2020-06 e 2023-11): diagnosi da assegnare | **Claudio sul PC** (collaudo v2 + import) — il cloud e' 403 su tutto | fonti: `REFERTO_HISTDATA_FATTIBILITA.md` §13-14-bis + `REFERTO_DUKASCOPY_FATTIBILITA.md` §esito corsa |
| M13 | **R81-bis — il processo alle uscite su dati LUNGHI** (pista aperta, v10): R81 ha misurato che sulla MaxMin DAX Short la variante **C "solo breakeven, poi correre" batte la sedia viva in ENTRAMBE le finestre** (+82% OOS, PF 2,70 vs 2,16, DD nei muri) — ma su ~10-14 POSIZIONI per finestra: sotto il muro dei 150, **il round PROPONE, non promuove** (criteri congelati prima). La strada raccomandata dal referto: rifare su 12 anni di DAX appena M12 consegna | PC backtest, dopo M12 | "su 12 anni la C tiene?" — **la sedia viva NON si tocca in nessun caso senza nuova firma** (`REFERTO_ROUND81_USCITE.md`). v12: **resta BLOCCATA dal cancello ZERO di M12** (i dati lunghi ci sono ma sono in frigo; nota: D30EUR — il simbolo di R81 — su HistData e' proprio il BOCCIATO) |
| M14 | ✅ **BOZZA CONSEGNATA (21/08, v13)** — `report/METRO_PROP.md` **§13 GRIGLIA / MARTINGALA**, commit `0a787ca`: 5 test binari che separano **martingala pura / averaging a cap fisso con stop / recovery** (T1 stop depositato al broker · T2 cap costante · T3 perdita nota prima · T4 riarmo sulle perdite · T5 size crescente = si dichiara sempre) · **G2: l'unita' di misura e' il PACCHETTO, non il ticket** (esempio: 100 pacchetti letti a ticket diventano **390** e il win rate cala da 70% a **53,8%** — i due errori vanno in direzioni opposte) · **G3: la scheda della coda** a 6 misure · **G4: il flottante contro il muro giornaliero**, misurabile su `gWorstDayPct` (equity, tick per tick) ma **nella finestra prop** (reset **23:00 BCM** = 00:00 CE(S)T, B3) · 3 buchi d'impianto dichiarati + **il cap C1 e' cieco sugli ordini PENDENTI** (`ABTG_Guardian.mq5:159` cicla su `PositionsTotal()`). 🔴 **Sulle regole prop l'esito e' onesto e magro**: l'unica riga "GRID vietato" e' **FundedNext da un video con link affiliati (4° rango)**; **su FTMO il divieto testuale NON esiste** (`docs/REGOLAMENTO_FTMO_2026-08.md`: _"NON TROVATO divieto testuale"_) ma c'e' una **clausola discrezionale** sulle _"substantially larger position sizes compared to other trades"_ che la progressione ×1,5 (**7,59×** dentro lo stesso pacchetto) colpisce in pieno; The5ers/FundingPips/E8/Alpha: **nessuna riga nel repo** → richiesta N3. **Resta il CONGELAMENTO di Claudio** | **Claudio** (firma) + **cacciatore-config-prop** (N3: testo letterale delle pagine "prohibited practices" su grid/martingale/averaging/size non uniformi, con data e [VERIFICATO]) | "a quali condizioni una griglia a cap fisso e' misurabile col nostro imbuto, e quali prop la ammettono per iscritto?" — 1ª meta' risposta (bozza), 2ª meta' **aperta**. Nodo dei due verdetti: `report/NODO_MEDIAZIONE_2026-08-21.md` |
| M14-bis | 📏 **CONDIZIONE 6 (frequenza) — STRUMENTO CONSEGNATO, NUMERO ANCORA NO** (21/08, dopo la firma **"frequenza"** = opzione C del nodo): `mql5/Scripts/ABTG_SondaMediazione.mq5` (commit `13db8c9`) e' uno **SCRIPT** che conta **PACCHETTI** (regola G2), mai ticket, sui 3 cross del corso su H1. **Non e' un EA e non puo' aprire niente**: nessun `OnTick`, nessun `CTrade`, **nessuna chiamata di trading**, **nessun `#include`** (grep nel referto, usciti vuoti). Stampa: pacchetti per simbolo e totale · **istogramma dei livelli 1..6** con allarme automatico `CODA SOTTO-CAMPIONATA` sotto il 5% (**G3.1**) · **G3.6** (pieno e poi TP) · **finestra effettiva** e barre lette · **pacchetti per anno** (serve a dimensionare l'IS, Emendamento A) · **autotest della geometria sui 21 valori del corso**, e se fallisce **non conta niente**. **10 assunzioni numerate**, con **A1 (SuperTrend ATR 10 / mult 3,0) dichiarata INVENTATA DA NOI**: il corso non la detta mai e il `super trend.ex4` della lez. 10 non ce l'abbiamo (**M15b**). 🔴 **Se il numero uscisse vicino a 150, M15b diventa bloccante.** **Non compilato, non eseguito: zero numeri prodotti.** Referto `backtest_pipeline/risultati_archivio/SONDA_MEDIAZIONE_FREQUENZA_2026-08-21.md`, riga di lancio `backtest_pipeline/righe/RIGA_SONDA_MEDIAZIONE.md` | **Claudio** (i 4 passi della riga di lancio, sul PC di backtest, quando MT5 e' libero) | "quanti PACCHETTI fa la Mediazione in-sample?" — sotto 150 il nodo **si chiude da solo, con un numero**, e non serve nessun EA |
| M15 | **Le due richieste a Claudio dal referto moduli base** (v11): (a) ~~screenshot fuso~~ → ✅ **CHIUSA-MISURATA (18/08 20:35 IT)**: Market Watch **19:35:27**, Windows **20:35** nello stesso screenshot → **BCM = italiana−1 (UTC+1 in agosto), il repo aveva ragione, il "GMT" del corso e' sbagliato di un'ora sull'oggi** (conflitto B3 deciso; all'E1 resta solo il comportamento invernale); (b) il file **`super trend.ex4` allegato alla lezione 10** del modulo Piattaforma — i default di QUEL file sono i parametri che il corso non detta mai (la catena Mediazione/Breakout termina li') | **Claudio** (richieste gia' fatte in chat dal referto) | `ANALISI_MODULI_BASE_2026-08-18.md` §2.5 e §SuperTrend |
| M16 | ~~Debito ablazione~~ → ✅ **CHIUSA PER MISURA (v12, R84 a tick reali)**: **9 celle su 9 OOS-negative** — nessun filtro crea l'edge, l'EMA (il filtro piu' citato del corso) e' il PEGGIORE (OOS 0,681), il METODO COMPLETO chiude a 0,785 con **cautela formale** (unica cella sotto le 150 op: n=69 OOS / 102 tot). I default spenti delle sedie ora sono spenti **per misura, non per omissione**. ⚠️ **ECCEZIONE DA NON SEMPLIFICARE — il caso D**: la conferma **volumi-OR-ATR passa TUTTI e 4 i cancelli congelati** (n=311, migliora in ENTRAMBE le meta', PF tot 1,104 vs 0,988, DD dimezzato) pur restando **OOS-negativa (0,924)**: e' un **riduttore di perdita su base perdente**, mai un edge — ma per la lettera dei criteri apre la strada a un round di validazione vera (regimi + walk-forward): **PROPOSTA a Claudio, non chiusa d'ufficio** (→ lista decisioni). Resta in coda R84-bis: la copertura del filtro news sul CSV non e' misurata | — | `REFERTO_ROUND84_ABLAZIONE.md` (criteri congelati 18/08 sera, commit `2458b33`) |
| M17 | **RITIRO FORMALE del verdetto "PostNews: nessun edge"** (v11): i 4 backtest del weekend 07/08 hanno **Trades=0** — il calendario dato all'EA aveva solo eventi **2026-2027** (e il gemello era vuoto, 0 byte): **e' stato misurato il nulla**. Va ritirato (non ribaltato) in `CLASSIFICA_WEEKEND.md` e `REFERTO_WEEKEND_FASE0.md`. Dati per rifarlo sul serio: **70 eventi ECB/FOMC in biblioteca** — bastano per la **prova di regime, MAI per il merito** (n<150, Emendamento A). Nota prop gia' agli atti: la PostNews e' **di fatto vietata su FundingPips** (l'azione cade sul bordo dei ±10 min anche tenuta) e **da sola non passa nessuna challenge** (giorni minimi + consistenza); la regola del corso "ott-mar = 19:30 IT" e' **FALSIFICATA su 11/17 eventi invernali** del nostro CSV | chat principale (ritiro nei due file) + PC backtest (eventuale prova di regime) | `ANALISI_CORSO_POSTNEWS_2026-08-18.md` §1.2-1.3 |
| M5 | **Motori con edge sufficiente**: `DOVE_SIAMO` §4 dice che oggi non abbiamo un motore che passerebbe una prop | **cacciatore-strategie** + i round di casa | il piano configura il rischio; il rendimento lo devono portare le sedie |
| M18 | ⏱️ **`open_time` (+ `package_id`) in `ExportTrades()`** — e' il **QUARTO mandato** che chiede lo stesso campo (M2 del 18/08 · `METRO_PROP` §13.2 pacchetti · dossier Upcomers P2 · questo giro). 🆕 **v14 — la precisazione che cambia la priorita'**: in **forward** la durata **si misura gia'** (il CSV del `TradeExporter` ha `open_time`: 15,2% delle chiusure dal 20/07 sotto i 2 minuti, 44% sulle Aperture DAX); e' **nel BACKTEST** che non si puo' — cioe' non possiamo dire se una cella NUOVA sara' conforme **prima** di metterla in campo | **mql5-ea-developer** (una riga per EA) + rigenerazione degli export | "aggiungere `open_time` all'export per-trade di tutti gli EA: senza, la conformita' a una durata minima non e' dimostrabile in backtest e l'unita' PACCHETTO (G2) resta ricostruita per approssimazione" |
| M19 | 🔎 **IL SECONDO DOSSIER PROP — in arrivo** (cancello 3). Oggi le candidate a muri statici sono **istruite solo via search**: FTMO ha un dossier (`docs/REGOLAMENTO_FTMO_2026-08.md`), The5ers e' "candidata con riserve", **E8 e Alpha Capital non sono mai state istruite**. Serve il confronto ad **almeno DUE** prop a muri statici, con la specifica di C7 (**5% g / 10% tot STATICI**) e il criterio F8 applicato in ordine | **cacciatore-config-prop** (dossier gia' in preparazione, **citato qui come in arrivo**) | "istruire almeno due prop a **muri statici 5/10** con **EA ammessi per iscritto**: per ognuna → muri e loro natura (statico/trailing, su equity o balance), ora e fuso del reset, durata minima dei trade (esiste? vale anche per uno stop?), regole news in minuti, overnight/weekend, clausole discrezionali su strategie mono-direzione, tipo di conto HEDGING/NETTING, nomi dei simboli e fuso del server. **Con l'etichetta di verifica su ogni riga**: [VERIFICATO] solo se la pagina ufficiale e' stata aperta" |
| M20 | 📊 **DD FORWARD PER FAMIGLIA** — il numero che manca per far diventare verde il cancello 1. Oggi le pagelle danno il P&L del giorno; **nessuno calcola il drawdown di una famiglia sulla sua serie forward**, quindi il confronto "DD reale ≤ DD promesso" (criterio firmato) **non e' eseguibile**: nella tabella del cancello 1 quella colonna e' `n/d` per tutte le 17 famiglie | **Claudio** (pagella serale come flusso: `scarica_pagella.ps1 -Installa`, attivita' 23:15) + chat principale per la misura | "dal CSV degli statement: per ogni famiglia, serie cumulata del netto e **massimo picco-valle**, contro il DD promesso in `CONTRATTI_SEDIE.md`. Va tenuta viva, non fatta una volta" |
| M21 | 📏 **PROVA DELLA TAGLIA (cancello 6)**: riprodurre il banco alla **taglia target** (200k/500k) e misurare quante operazioni finiscono al tetto `SYMBOL_VOLUME_MAX`, se i lotti passano i limiti di **margine**, e di quanto si scostano DD / worst day / pass-rate dal banco 100k | **PC di backtest** (round di banco, criteri congelati prima) | "le percentuali del banco 100k valgono anche a 200k+? R109 dice che la scala **non e' lineare** (8,9% di trade tagliati dal tetto, slippage 21,5 pt): se lo scostamento esiste, la taglia grande si ricalcola, non si estrapola" |
| M22 | 🌡️ **PROVA DI REGIME AL DIAL SCELTO** (dipendenza del cancello 5): la sopravvivenza della flotta in un mercato **ORSO** non e' misurata — 481 giorni = **un solo regime, toro** (avvertenza (b) dell'analisi sopravvivenza). Sugli indici il vincolo dati e' noto: il frigo si e' aperto **solo per NASUSD_EXT** (metro relativo 0,20×vol, rapporto 0,199), **SPXUSD e 225JPY restano dentro**, il **DAX lungo e' bloccato** (grxeur **non e' il DAX** fra 2020-06 e 2023-11: sessione 02-15 NY e prezzi 3,2-4,4k → [INFERITO] EuroStoxx50) | PC di backtest + `cacciatore-strategie` per i dati | fonti: `LETTURA_MISURE_LAMPO_2026-08-26.md` (eventi 3/3 **movimenti veri**: le diff giganti erano **disallineamenti di un'ora nei botti**, non spazzatura) · `LETTURA_DIAGNOSI_DAX_2026-08-26.md` · macchina R50-R56-R59 |
| M6 | ~~Conferma del conto 100k~~ → ✅ **CHIUSO** (18/08 08:38): il dry-run gira su **`50504263`**, confermato dallo screenshot del terminale (titolo finestra) col Guardian v1.10 vivo | — | — |
| M7 | Verifica **lotto fisso** dei due EA esterni (`BREAKOUT_EA_JPY_v3`, `DAXMasterEA_v2_0`) | Claudio/VPS (censimento gia' pronto) | rischio non controllato per definizione su un conto da 5.100 € |

## ✍️ LE FIRME CHE SERVONO A CLAUDIO (in ordine di urgenza)

🆕 **v14 (26/08) — LA DECISIONE PIU' URGENTE STA IN CIMA E NON E' UN NUMERO:
E' UNA SEQUENZA.**

🚦 **FIRMA "CANCELLI" — approvare (o correggere) i SEI CANCELLI come
condizione d'acquisto di una challenge.** Non impegna un euro e non tocca il
forward: fissa **cosa dev'essere verde prima di comprare**, con l'obiettivo
dichiarato di **meta'-fine settembre**. E' la firma che rende la risposta a
_"siamo maturi?"_ una **procedura** invece di un'opinione. ⚠️ Dentro ci sono
due voci che oggi sono rosse e non dipendono da Claudio (le 20 operazioni per
famiglia, il secondo dossier prop) e **quattro che dipendono da lui**: la
firma due-dial (C7), il preset Guardian per famiglia di muri (B10), l'invio
delle domande al supporto (E1), e il **cancello 6 / prova della taglia**
(M21) — nato oggi dal suo stesso orientamento sulla taglia alta.

🎛️ **FIRMA "DUE-DIAL" (C7)** — challenge **d=1,00**, funded **d=0,74**. Si
firma **all'apertura della challenge**, non prima; ma la scelta va decisa
adesso perche' cambia i contratti. 🔴 Da leggere insieme al **conflitto con
R106** dichiarato nella riga C7 (R106 raccomandava 0,74 anche in challenge):
sono due misure di casa dello stesso rango, e la differenza sta
nell'argomento, non nei numeri. **Raccomandazione dell'architetto-prop,
dichiarata come tale: due-dial** — perche' l'esposizione della challenge dura
**12 giorni mediani** e quella del funded **252**, e ogni punto di margine dal
muro vale **21 volte di piu'** nella seconda.

🧱 **FIRMA "PRESET MURI" (B10)** — autorizzare la costruzione del preset
Guardian **per famiglia di muri** (non un secondo set di soglie cablate: un
preset per profilo, coi rapporti gia' firmati 80%/98%). Costo ~0 di sviluppo
(gli input ci sono tutti, trailing compreso), **1 round di autotest sul 100k**,
e senza di esso il cancello 4 resta rosso su qualunque prop diversa da FTMO.

🆕 **v13 (21/08) — DUE FIRME, entrambe a costo zero e
indipendenti fra loro (ancora in attesa):**

🔵 **FIRMA "METRO" (M14)** — congelare la voce **§13 GRIGLIA / MARTINGALA** di
`report/METRO_PROP.md` (bozza consegnata oggi, commit `0a787ca`). **Non apre
niente e non impegna niente**: e' lo strumento che manca per giudicare
QUALUNQUE griglia (idea del corso, EA comprato, preset di un vendor). Si firma
nella condizione migliore possibile — **zero numeri sul tavolo**, che e' la
regola di casa ("i criteri prima dei numeri"). ✅ **Vale anche se la Mediazione
viene archiviata.**

🪢 **DECISIONE "NODO MEDIAZIONE"** — `report/NODO_MEDIAZIONE_2026-08-21.md`: i
due verdetti opposti del **12/08** ("NON si meccanizza, MAI in prop") e del
**18/08** ("SI', puo' andare all'imbuto, con 6 condizioni") sono agli atti da
nove giorni, **nessuno dei due firmato**. La scheda dimostra che vertono su
**due oggetti diversi** (la pratica di Emiliano **senza stop** — scarto a vista
col metro di oggi — contro il modulo lez. 26-33, che passa tutti e quattro i
test), ma che **la ragione del 12/08 sopravvive come cancello di TAGLIA**.
Tre opzioni, si firma con una parola: **A = ARCHIVIA · B = IMBUTO · C =
FREQUENZA**. Raccomandazione dell'architetto-prop (dichiarata come tale):
**FIRMA 0 + C**.


✍️ _v5: le tre grandi sono FIRMATE (C3 · C1/C2 · B1/B2/B3 — verbale
`FIRME_2026-08-18.md`). La lista si accorcia e cambia natura: da "decidere i
numeri" ad "attuare e chiudere i dettagli"._

✅ **D-SPEGNIMENTI — ESEGUITA E VERIFICATA (v9, controprova delle 09:41)**:
FIRMA 5 ("SPEGNILE TUTTE E TRE") completata. `770201` e `970914` **spariti
dai `.chr`**, somma dichiarata **44,55% → 43,30%, esatto al decimale**
(archivio: `censimento_rischio_2026-08-18_0941.txt`). `BREAKOUT_EA_JPY_v3`
era gia' un **fantasma** (viveva solo in `Profiles\Charts\Default\
chart02.chr`, fermo al 20/07: non girava da un mese — non c'era nulla da
spegnere; il `.chr` residuo verra' rinominato per pulire i censimenti).
**E' stata la PRIMA APPLICAZIONE della C3, dalla firma alla verifica in
una giornata.** Porta di rientro JPY — 🔴 **v10, R82 CHIUDE LA STRADA DELLA
TARATURA**: il torneo sui 7 cross JPY con l'implementazione FEDELE del corso
(criteri congelati prima, autotest del test-case PASSATO, vincolo 20 candele
incluso) fa **ZERO vincitori** — OOS negativo su tutti e sette, EURJPY unico
positivo IS 2007-2014 poi spento (profilo di edge mangiato dal mercato). Il
+133% della lez. 39 non si riproduce da nessuna parte: **il rientro JPY ora
richiede una tesi NUOVA, non una taratura**. La regola di portafoglio "max
UNA sedia dalla famiglia JPY" resta in vigore (R82) — **oggi senza
candidati** (fonti: `REFERTO_ROUND82_TORNEO_JPY.md`, `REFERTO_R82_CANARINO.md`).
🥇 **v12 — la FIRMA 5 esce RAFFORZATA dalla misura**: sulla `770201` il
verdetto e' ora **TERZO e indipendente** (WF 31/07 PF 0,82 · 05/08 19/20
celle negative · R84+R83: **12 configurazioni — 9 filtri + 3 ingressi — 12
OOS negative** a tick reali). L'apertura US non ha edge su questa finestra
a prescindere da filtri e stile d'ingresso.

Restano in lista:

1. 🔔 **MIGRAZIONE EA all'include del Guardian (enforcement di C1/B1) — la
   nuova n.1 (v12)**: il cap 3,25% e la pausa 4,0 sono firmati e il Guardian
   scrive le bandiere, ma **nessun EA le legge** — e la pagella del 18/08
   stima **~4,84% di rischio aperto a fine serata** (la serata-tipo p95 di
   M2). Proposta: alzarla in cima alla lista SVILUPPO (un EA per volta,
   regola di casa), prima di qualunque altra novita'.
   ✅ **19/08 — CODICE SCRITTO, DA COLLAUDARE.** Referto:
   `backtest_pipeline/risultati_archivio/REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`.
   **48 EA vivi, 74 punti di ingresso** collegati alle bandiere; include
   `ABTG_PausaGuardian.mqh` **v1.20** (nucleo puro + autotest a 19 casi),
   Guardian **v1.11** (verifica del filo; il cap c'era gia' e non e' stato
   toccato). Default `InpUsaGuardian=true` ma con **fail-open totale**: senza
   Guardian sul conto — e nel tester — il comportamento e' identico a oggi.
   🛑 **Nulla di questo e' compilato ne' in campo**: restano da spuntare i **9
   criteri congelati** del referto, sul **dry-run 100k** e mai prima sul conto
   piccolo. La messa in campo la decide Claudio.
2. **Il caso D di R84**: aprire o no il round di **validazione vera**
   (regimi + walk-forward) della conferma volumi-OR-ATR — passa i 4 cancelli
   congelati come **riduttore di perdita su base perdente** (mai edge).
   Proposta ai sensi dei criteri; decide Claudio.
3. **E1 — la data di invio** delle domande al supporto (fine agosto, a
   forward pulito maturo?) — prima aggiungendo al file D3 la domanda
   **breakeven-lock** (M1) e la conferma del fuso di reset invernale (B3).
4. **F6 — chiusura formale**: la due diligence dice **niente noleggio**
   (il preset prop del vendor fa PF 0,94 in live reale). Resta solo
   l'opzione demo gratuita nel tester: si'/no di Claudio e, se si', criteri
   congelati prima (M10).
5. **B9 — congelare la regola "un Guardian per conto"** (gia' in vigore di
   fatto: doppione rimosso).

_(A2/A4: FIRMA 4 · D-spegnimenti: FIRMA 5.)_

---

## 📊 IL CONTO DEL GIRO

🆕 **v14 (26/08): 42 parametri censiti — 12 congelati · 15 proposti · 14
aperti · 1 chiuso per misura (C5).** Cinque righe nuove, nessun valore
firmato cambiato: **C7** (manopola globale + piano due-dial, PROPOSTO, col
conflitto R106 dichiarato) · **B10** (preset Guardian per famiglia di muri,
PROPOSTO) · **E8** (durata minima dei trade, APERTO — e la misura di casa che
smentisce meta' del buco dichiarato dal dossier) · **F7** (Upcomers BOCCIATA,
PROPOSTO) · **F8** (criterio di scelta della prop in 7 punti, PROPOSTO).
Aggiornate: **C1** (il caso R112 che sfida il cap) e la testa del documento
col **cancello challenge a sei porte**. In COSA MANCA entrano **M18** (
`open_time`, quarto mandato), **M19** (secondo dossier prop, in arrivo),
**M20** (DD forward per famiglia — il `n/d` che tiene rosso il cancello 1),
**M21** (prova della taglia) e **M22** (prova di regime al dial scelto).
🛑 **Zero modifiche al forward, zero preset toccati, zero acquisti
autorizzati.**

_(conteggio precedente, v13)_ **37 parametri: 12 congelati · 11 proposti · 13
aperti · 1 chiuso per misura (C5).**
Congelati: i 3 storici — A1 (0,65% su DD statico, 09/08) · F4 (challenge solo
dopo forward maturo, 13/08) · F5 (cancello acquisti EA, 18/08 notte) — piu'
le **8 righe firmate il 18/08** (verbale `FIRME_2026-08-18.md`): **B1**
(pausa 4,0 + emergenza 4,9) · **B2** (9,9) · **B3** (reset 23, fuso [INCERTO]
fino a conferma scritta) · **C1** (cap 3,25% sugli SL vivi) · **C2** (con C1)
· **C3** (tre corsie + porta di rientro; morde quando esiste M11) · **A2**
(giovani a 0,3%, FIRMA 4) · **A4** (mai sopra 1% sul piccolo, FIRMA 4).
Delle 12 aperte, 2 si chiudono con misure di casa a costo basso (E3, E4).
🆕 **v13 (21/08): conteggi dei PARAMETRI invariati — 37 (12C · 11P · 13A · 1
chiuso)** — perche' questo giro non ha toccato nessun valore: ha prodotto uno
**strumento** (la voce §13 del `METRO_PROP`) e una **scheda di decisione** (il
nodo Mediazione). In cima alla lista firme entrano **"METRO" (M14)** e la
scelta **A/B/C** sul nodo.
v7: **B9 nuova** (un Guardian per conto). v8-v9: **D-SPEGNIMENTI decisa,
eseguita e verificata** (FIRMA 5, prima applicazione della C3). v10: **D5
nuova** (filtro news FiboH4, gia' in casa e spento) porta il totale a 36;
la porta di rientro JPY dopo R82 richiede una **tesi nuova**. v11: **C6
CONGELATA** (FIRMA 6, R83-bis) porta i congelati a 12 e il totale a 37; in
cima alla lista restano E1, la chiusura formale di F6, il congelamento di
B9 — e le due consegne di M15 (screenshot fuso + `super trend.ex4`).

---

## 📜 CHANGELOG

| data | versione | cosa e' cambiato | perche' |
|---|---|---|---|
| 18/08/2026 ~01:00 | **v1** | prima stesura: 29 parametri in 6 aree, dalle fonti elencate in testa. Incorporati: dossier config-prop 18/08 (3 preset .set veri, censimento 6 prop non verificato, 36 buchi), le 9 proposte P1-P9, il censimento rischio 17-18/08 (tre sedie al 2% corrette a 1%), DOVE_SIAMO 17/08 (agosto −11%, manca il criterio di uscita). **NON incorporata** l'analisi trascrizioni (in lavorazione): 5 parametri marcati 🎬 in attesa | non esisteva un posto unico dove i numeri della prop stessero con fonte e stato |
| 18/08/2026 ~01:15 | v1.1 | incorporato lo **script CrewAI incollato da Claudio** (rango 4): breaker 4,3-4,5% aggiunto alle fonti di B1 (quarta voce convergente sul buffer prima del muro), sizing 0,5% aggiunto ai conflitti di A1, snapshot mezzanotte broker in B3 **con la discordanza di fuso (00:00 GMT vs 00:00 CET) segnata come [INCERTO]**. Eseguita la verifica richiesta sul Guardian: riga 155 misura su **equity** → il flottante e' contato, nessun buco nuovo (resta B4 sulla baseline) | materiale nuovo in chat durante il primo giro |
| 18/08/2026 ~01:45 | **v2** | incorporato il referto dell'**analista-trascrizioni** (11 trascrizioni = 7 fonti indipendenti, resa numerica bassa). **Nessun parametro cambia valore e nessuno si chiude**: i 4 punti caldi (buffer 4/9, ora reset, minuti news, recovery dei 4 EA) NON sono confermati dal parlato → le note 🎬 su A3/C1/D1/D2/F2 passano da "in arrivo" a "risposto: niente". Novita' incorporate: **FundedNext 1-Step 3%/6%** [a voce] in F1 (daily 3% = 🔴 per il metro di casa) · rinforzo **static-not-trailing** su B5/F3 (video PropEA) · **divieto hedge multi-account FundedNext** in E2 (risposta a voce alla domanda tipo-2 D3; la nostra conferma scritta resta da fare) · **nuova riga E6**: cosa le prop rilevano (magic condiviso, input identici, tratti simili — dal video VIETATO PER NOI, tenuto come intelligence difensiva) → **30 parametri (2C · 13P · 15A)**. In COSA MANCA: M3 chiuso, **M8** (4 screenshot, Claudio) e **M9** (ri-trascrizione del file troncato, Claudio) aggiunti | consegna dell'analista-trascrizioni (commit `bd78950`) |
| 18/08/2026 ~02:15 | **v3** | incorporata la **2ª notte del cacciatore** (`CONFIG_PROP_RACCOLTA_SET_2026-08-18.md`: 50 `.set` nuovi da 11 fonti, 75 file in biblioteca) + `CANCELLO_ACQUISTI_EA.md`. **Correzione d'evidenza su B1/B2**: la "convergenza tre vendor" sul 4/9 era a DUE (Gold Phantom = Gold Reaper = Profalgo/WSC); il principio "mai sul muro" sale a 5+ fonti, il valore del buffer diverge (1,0 / 0,5 / 0,1 pt) → **B1 riscritta a DUE livelli** (pausa 4,0 + emergenza 4,9, modello Prop Firm Pass), B2 a 9,9. **D1 APERTO→PROPOSTO**: il "non backtestabile" cade — calendario esportabile in CSV ([VERIFICATO] dal manuale Range Breakout), 2 CSV 2021-2025 (37.799 righe, UTC+2: su BCM −1h) e `NewsFilter.mqh` (283 righe, zero DLL) gia' in biblioteca. **B6**: il canale di blocco esiste in natura (TIP: GlobalVariable + battito + `SiblingStaleSec=30` + `BlockIfSiblingHalted`). **B8 nuova** (ex buco n.8: zone Bullion + scala Range Breakout, soglie Bullion [INCERTO]). **C4** da 1 a 3 fonti (regola: rischio ≈ budget ÷ sedie); **C1** +2 gambe ma resta APERTO (1% / 1,5% / 3% divergenti → M2). **A3 peggiora onestamente**: Ultimate EA coi file veri NON tocca il rischio fra fasi (1,0/1,0/1,0, target 8→5→2) → 1 contro 1. **A1 confermato per contorno** (0,5 · 0,5 · 0,65 · 1,0 · 2,4). **E3**: consistency misurabile DENTRO l'EA (Best Day 50%, min days 4, start date). **E7 nuova** (igiene: 3 recovery su 8 famiglie, anti-pattern cap in valuta, protezioni mai toccate dai profili). **F5 CONGELATA** (cancello acquisti EA, decisione di Claudio 18/08) e **F6 nuova**: primo candidato `Range Breakout Daytrader` — scheda costi e criteri demo riferiti in chat ma NON ancora depositati → M10. B3: nessuna gamba nuova (0 `.set` su 50 con ora di reset). → **34 parametri (3C · 16P · 15A)** | seconda caccia consegnata (commit `a1e8b51`/`4815ed8`/`2cd983f`) |
| 18/08/2026 mattina | **v4** | incorporate le misure **M1 e M2** (i due buchi a costo zero: ESEGUITI, criteri congelati prima dei numeri). **C5 CHIUSA-MISURATA**: trailing EOD p99 **12,05%** a 0,65 / 9,27 a 0,50 / 7,41 a 0,40 (statico esatto 8,51); breakeven-lock: sfondamento 4,6%→0,2%. **F3 da divieto a NUMERI**: 1-Step muro 10 solo ≤0,50%, muro 8 solo ≤0,40%, muro 6 mai; +1 punto di margine se il trailing e' su equity; la domanda breakeven-lock entra in E1/D3. **A1 perimetrato, non revocato**: statico 8,51<10 regge (la stima ~8,1 corretta ovunque), col trailing NON regge — congelamento da leggersi "su DD statico". **C1 APERTA→PROPOSTA**: il 5,2% temuto E' SUCCESSO (03/08: 9 pos/8 sedie = 5,85%, p99 giorn. 5,67%) → cap `InpMaxOpenRiskPct=3,25%` (5 SL vivi), morde 5 gg/15 di agosto (l'accumulo swing), p50 2,60 non lo sente. **C2 assorbita da C1** (il vincolo giusto e' sugli SL VIVI, non sulle sedie accese). **C4 declassata a riserva** (il problema misurato e' il picco, non la somma astratta). **C3 aggiornata: IN FIRMA con Claudio adesso** — versione tre corsie (rischio subito per sedia / merito a 20 op per famiglia con spegnimento della sedia colpevole / tagliando 6 mesi), resta APERTA fino alla sua parola. **Nota nuova in area C sui gemelli orig+OTT** (stesso segnale stesso secondo = posizione doppia su una prop; un gemello per famiglia alla squadra prop). M1/M2 chiuse in COSA MANCA. Firma piu' urgente: **da C3 (gia' in corso) a C1**. → **34 parametri (3C · 18P · 12A · 1 chiuso)** | M1+M2 eseguite (commit `8da31c5`, `18d98cb`) |
| 18/08/2026 mattina | **v5** | ✍️ **LE FIRME** (parola esatta di Claudio: "firma tutte e 3", verbale `report/FIRME_2026-08-18.md`, commit `45c4f42`): **CONGELATE B1** (pausa morbida 4,0 + emergenza 4,9; attuazione a gradini: emergenza+reset subito, pausa dopo lo sviluppo, collaudo sul 100k), **B2** (9,9), **B3** (reset 23 con caveat fuso [INCERTO]), **C1** (cap 3,25% = 5 SL vivi; enforcement in sviluppo — mql5-ea-developer — si testa sul 100k), **C2** (con C1: la frase firmata "il vincolo conta gli SL VIVI, non le sedie accese" e' il suo contenuto), **C3** (tre corsie + porta di rientro, modificata dalle due obiezioni di Claudio: merito per FAMIGLIA a 20 op con spegnimento della sedia colpevole; prerequisito = censimento dei contratti → **M11 nuova, assegnata e in corso**). **B6 declassata PROPOSTA→APERTA** (la firma ha scelto la soglia 4,0: il 2,5 resta idea di riserva, si riapre solo con una misura). NON firmate, restano in lista: E1 e F6 (F6 in attesa della due diligence 1-bis, come da verbale). Regola di ripensamento annotata: ogni firma si riapre solo con una misura nuova, per iscritto, mai a caldo. → **34 parametri (9C · 12P · 12A · 1 chiuso)** | le tre firme di Claudio (commit `45c4f42`) |
| 18/08/2026 in giornata | **v6** | ✍️ **FIRMA 4** (Claudio in chat: "firmo a1 e a4" — letto come A2+A4 perche' A1 era gia' congelato dal 09/08, lettura confermata a lui in chat; verbale aggiornato): **CONGELATE A2** (sedie giovani <30 trade forward a 0,3%, mezzo peso — da prassi del dry-run a regola scritta per tutte) e **A4** (nessuna sedia sopra l'1% sul conto piccolo, mai — il censimento periodico e' la verifica, una riga rossa = violazione). In cima alla lista decisioni restano solo **E1** (data invio + domanda breakeven-lock nel file D3) e **F6** (dopo la due diligence 1-bis, in corso). → **34 parametri (11C · 10P · 12A · 1 chiuso)** | FIRMA 4 nel verbale (sezione aggiunta in giornata) |
| 18/08/2026 ~08:40 | **v7** | ⚙️ **Aggiornamenti di campo.** (1) **Guardian v1.10 IN CAMPO sul 100k** — installato, compilato, VIVO (conferma visiva 08:38: `limite 4.9 / totale 9.9 / pausa 4.0 libera / rischio aperto 0.00% cap 3.25%`): B1/B2/B3 e C1 annotate "in campo; gli EA non leggono ancora le bandiere — migrazione da decidere; finche' pausa e cap non scattano in un giorno vero, sono codice". (2) **M6 CHIUSO**: conto dry-run confermato `50504263` (screenshot titolo finestra). (3) **B9 nuova**: UN GUARDIAN PER CONTO, SEMPRE — sul 100k ce n'erano due, GlobalVariable per-conto che si sovrascrivono e chiusure doppie in emergenza; doppione rimosso da Claudio. (4) **M11 CHIUSO**: `CONTRATTI_SEDIE.md` (44 sedie: 40 pieni, 2 parziali, 2 SENZA + revoca 970914 in campo) → **C3 OPERATIVA**; nasce la decisione aperta **D-SPEGNIMENTI** (770201, BREAKOUT_EA_JPY_v3, 970914 — proposta: spegnerle; NON congelata, decide Claudio). (5) **M10 eseguita + F6 aggiornata**: due diligence 1-bis fatta — vendor pulito MA il suo preset prop in live reale (Darwinex) fa **PF 0,94 su 248 op/2 anni**: niente noleggio, resta solo l'opzione demo gratuita; parola a Claudio. → **35 parametri (11C · 11P · 12A · 1 chiuso)** | Guardian vivo + censimento contratti + due diligence (commit `b3e43e4`, `514d8c8`, `7f05161`) |
| 18/08/2026 in giornata | **v8** | ✍️ **FIRMA 5 — D-SPEGNIMENTI DECISA** (parola esatta di Claudio: **"SPEGNILE TUTTE E TRE"**, verbale aggiornato): 770201 Nasdaq Apertura US · BREAKOUT_EA_JPY_v3 USDJPY · 970914 SupRev DOW H4 Ott. 🥇 **PRIMA APPLICAZIONE del criterio di uscita C3** firmato stamattina — la regola ha morso il giorno stesso in cui e' nata la sua tabella (M11). Porta di rientro valida; per la JPY l'analisi del corso BREAKOUT e' gia' in corso (se la spec regge l'imbuto, rientra con contratto). Esecuzione sul VPS in corso (Claudio), **controprova col censimento a seguire**. In cima alla lista: E1, chiusura formale F6, congelamento B9 | FIRMA 5 nel verbale |
| 18/08/2026 ~09:45 | **v9** | ✅ **FIRMA 5 ESEGUITA E VERIFICATA** (verbale aggiornato con la sezione di esecuzione): controprova col censimento delle 09:41 (`censimento_rischio_2026-08-18_0941.txt`) — 770201 e 970914 spariti dai `.chr`, somma dichiarata **44,55% → 43,30% esatto al decimale**; `BREAKOUT_EA_JPY_v3` era gia' un fantasma (solo `Profiles\Charts\Default\chart02.chr`, fermo al 20/07: non girava da un mese — nulla da spegnere, residuo da rinominare). **La C3 ha compiuto il ciclo intero in una giornata: firma → tabella → morso → verifica.** Registrata la pista della porta di rientro JPY: `ANALISI_CORSO_BREAKOUT_2026-08-18.md` + `prove/BREAKOUT_CORSO_SPEC.md` — spec meccanizzabile al 71%, contraddizione frontale corso vs backtest (+133% vs −20.853 € su stesso perimetro), 2 divergenze di implementazione nel codice v1. Conteggi invariati | esecuzione verificata (commit `b6ca393`) + analisi corso (commit `682bd57`) |
| 18/08/2026 sera | **v10** | 📚 **La giornata assorbita.** (1) **R82 CHIUSO** (torneo JPY + canarino): **ZERO vincitori su 7 cross** con l'implementazione FEDELE del corso (autotest passato, vincolo 20 candele incluso) — ipotesi A dimostrata allo screening, il +133% della lez. 39 non si riproduce; **porta di rientro JPY aggiornata: serve una TESI NUOVA, non una taratura**; "max una sedia JPY" resta, oggi senza candidati. (2) **R81 registrato come pista** (M13): variante C "solo BE poi correre" batte la sedia viva in entrambe le finestre (+82% OOS) ma su 10-14 posizioni → propone, non promuove; R81-bis su dati lunghi quando M12 consegna. (3) **I sei processi del corso**: filo rosso trasversale — **l'uscita e' il pezzo sempre indeterminato del corso** (rafforza la linea di casa del processo alle uscite, che R81 ha appena aperto con criteri congelati); **D5 nuova** (FiboH4 prop-compatibile, filtro news gia' nel nostro EA e SPENTO); **M14 nuova** (metro griglia/martingala da scrivere prima di qualunque imbuto sulla Mediazione — cap 6 ingressi ma "propriamente Martingala" a voce); **Point Break**: correlazioni del corso aritmeticamente rotte — corroborazione di 4° rango della nostra regola JPY, nessuna riga si riapre. (4) **M12 nuova — piano dati indici cambiato**: HistData (DAX/Nasdaq/Nikkei/SPX) + Dukascopy solo Dow + controprova a tre feed, dopo il crawl strozzato (25/2.389 giorni in 1h43m, interrotto). → **36 parametri (11C · 11P · 13A · 1 chiuso)** | R81+R82 chiusi, 5 analisi corso consegnate, piano dati rifatto (commit `1863a7d`, `682bd57`, e successivi) |
| 18/08/2026 notte | **v11** | 📥 Assorbita la sera. (1) **Verdetto piani apertura** (`ANALISI_PIANI_APERTURA`): prop "**eseguibili CON CONDIZIONI**" — D1 guadagna la gamba grossa (filtro ≥10 min = **compliance by design**, la routine del piano e' piu' severa delle prop; finestra **16:00 IT** da governare), F2 (FTMO Swing corsia larga), D4 (breakout notturno PDF morto su E8), 0,65% gia' firmato copre il 2% del piano; **M16 nuova**: debito ablazione filtri, R84 in preparazione — "il metodo del corso non funziona" resta NON dimostrato. (2) **Moduli base**: nota di paternita' in area C (il corso NON ha strumenti di portafoglio: correlazione mai nominata in 41 lezioni, filtro news perfino sconsigliato — Guardian/C1/C3/news sono di casa); 🔴 **conflitto di fuso segnalato in B3** (corso: BCM in GMT=IT−2 vs repo IT−1, STESSO broker — misurabile, M15a) + M15b (`super trend.ex4` lez. 10, la fine della catena dei default). (3) **PostNews**: **M17 nuova** — il verdetto del weekend 07/08 va **RITIRATO** (Trades=0: calendario 2026-2027, misurato il nulla); 70 eventi ECB/FOMC in biblioteca = prova di regime possibile, MAI merito (n<150); di fatto vietata su FundingPips; "ott-mar=19:30" falsificata 11/17. (4) ✍️ **FIRMA 6 → C6 nuova CONGELATA**: R83-bis, EA aperture a tre ingressi (`InpEntryMode` 0/1/2, celle separate, mai miscelati) col vincolo **max UNA modalita' per mercato in forward** (stesso evento = correlate per il cap C1). Conflitti segnalati e non decisi: fuso B3, news sconsigliate-vs-obbligatorie dentro il corso stesso. → **37 parametri (12C · 11P · 13A · 1 chiuso)** | piani apertura + moduli base + PostNews + FIRMA 6 |
| 18/08/2026 ~20:35 | v11.1 | 📸 **M15a CHIUSA-MISURATA, conflitto B3 DECISO**: screenshot di Claudio con Market Watch **19:35:27** e orologio Windows **20:35** nello stesso istante → **BCM = ora italiana −1 (UTC+1 in agosto)**. La regola di casa e' CONFERMATA dalla misura; l'affermazione del corso ("sostanzialmente sul GMT" = IT−2) e' **falsificata sull'oggi** — stesso broker, un'ora di errore. Il reset 23 del Guardian resta giusto (23 server = 00:00 IT). All'E1 resta SOLO la domanda invernale (il server segue il DST europeo o e' UTC+1 fisso?). M15b (`super trend.ex4` lez. 10) ancora aperta. Conteggi invariati | screenshot MT5+Windows di Claudio in chat ("ORARI. BMC 1 ORA INDIETRO.") |
| 19/08/2026 mattina | **v12** | 🌙 **Assorbita la notte 18-19/08.** (1) **M16 CHIUSA PER MISURA** (R84, tick reali): 9/9 celle OOS negative, metodo completo del corso bocciato (cautela formale: cella I n=69<150); i default spenti ora sono spenti PER MISURA. **Non semplificato**: la cella D (volumi OR ATR) passa TUTTI e 4 i cancelli congelati (PF tot 1,104 vs 0,988, DD dimezzato, n=311) pur restando OOS-negativa — riduttore di perdita, mai edge → **decisione n.2 in lista**: proposta a Claudio di validazione vera, non chiusura d'ufficio. R84-bis (copertura CSV news) in coda. (2) **R83**: duello ad armi pari (canarini al centesimo 291/291 e 311/311) — sul DAX il **RETEST vince e incorona la config della sedia viva 770101** (divergenza #15 chiusa a favore del campo); sul Nasdaq **zero modalita' positive** (autopsia retest: 74/78 perdite = stop pieni 1R vs vincite 0,18R); con R84: **12 configurazioni, 12 OOS negative** = terzo verdetto indipendente sulla 770201, **FIRMA 5 rafforzata**; C6 aggiornata: EA collaudato (6/6) e in armeria; lezione: la stessa regola cambia segno tra mercati. (3) **M12**: passo 4 eseguito ma **3 `_EXT` IN FRIGO** (cancello ZERO: diff 0,0608-0,1010% > 0,05%; shift +5 confermato 3/3); causa parziale misurata (settimane DST ~6,6%, spiega ~¼ sugli indici; secondo sospettato: basis cash-vs-future); **importatore v2 DST-aware gia' SCRITTO** (IMP-EXT-v2, da collaudare, sequenza §14-bis.6); previsione pre-registrata: la cura DST da sola probabilmente non basta su NASUSD/225JPY; **D30EUR HistData BOCCIATO** (min 2906 impossibile), diagnosi da assegnare; **M13 resta bloccata** dal cancello. (4) **Pagella 18/08**: rischio aperto ~4,84% stimato a fine serata = serata-tipo p95 di M2 → 🔔 promemoria in C1 e **nuova decisione n.1: migrazione EA all'include** (l'unico pezzo firmato senza enforcement in campo). (5) Registrato SENZA giudizio (cantiere dell'altra sessione): primo trade della sedia GapContinuation `774101` (−51,90; stop sul massimo dell'opening range senza buffer; **R85 in preparazione** dall'altra sessione). M15a era gia' chiusa in v11.1; M15b (`super trend.ex4`) resta aperta. Conteggi invariati: **37 parametri (12C · 11P · 13A · 1 chiuso)** | R83+R84 (commit `2458b33`), HistData §13-14-bis, `PAGELLA_2026-08-18.md` |
| 21/08/2026 | **v13** | 🕸️ **M14 CHIUSA A META': la voce GRIGLIA/MARTINGALA del METRO_PROP esiste** (`METRO_PROP.md` §13, bozza da firmare, commit `0a787ca`). Contenuto vero: 5 test binari (T1 stop depositato al broker · T2 cap costante · T3 perdita nota **prima** · T4 riarmo sulle perdite = scarto anche col cap · T5 size crescente = obbligo di dichiarare 7,59× e 20,78×); **G2 unita' = PACCHETTO** con l'esempio numerico (100 pacchetti → **390 ticket**, win rate 70% → **53,8%**: i due errori vanno in **direzioni opposte**, uno gonfia il campione e l'altro sgonfia il win rate) e la ricostruzione dei pacchetti dal CSV di oggi (stesso `symbol`+`magic`+`close_time` identico, perche' SL e TP sono unici); **G3 scheda della coda** a 6 misure + il conto dei pacchetti pieni consecutivi che uccidono il conto (**15,4 a 0,65% · 5,7 a 1,76% · 2,5 a 4,03%**); **G4 flottante contro il muro giornaliero** — misurabile su `gWorstDayPct` (equity a ogni tick, gia' in tutti gli EA) ma servono **finestra prop (reset 23 BCM, B3)**, **export per giorno** e **`open_time`/`package_id`**; segnalato il buco del **cap C1 cieco sugli ordini PENDENTI** (`ABTG_Guardian.mq5:159` cicla su `PositionsTotal()`) e quello di `dd_portafoglio.py` (serie giornaliera dal `close_time`: il flottante multi-giorno e' invisibile). 🔴 **Sulle regole prop la resa e' magra e dichiarata tale**: "GRID vietato" esiste **solo** come voce di un video con link affiliati (FundedNext, 4° rango); **FTMO non ha divieto testuale** ma ha la clausola discrezionale sulle _"substantially larger position sizes"_ che la progressione ×1,5 colpisce; The5ers/FundingPips/E8/Alpha **non hanno una sola riga nel repo** → richiesta **N3** al cacciatore-config-prop. **Nuovo file: `report/NODO_MEDIAZIONE_2026-08-21.md`** (riconciliazione dei due verdetti 12/08 vs 18/08, stato delle 6 condizioni — **2 risolte, 2 mezze, 2 bloccanti** — e le tre opzioni A/B/C per Claudio). **Nessun parametro cambia valore, nessun round aperto, niente toccato in forward**: M14 passa da "da scrivere" a "scritta, in attesa di firma", e nascono due voci nella lista firme | decisione di Claudio del 21/08 in chat ("1,2,3 si guardano") + `STATO_QUATTRO_STRATEGIE_2026-08-21.md` scheda 1 |
| 26/08/2026 sera | **v14** | 🚦 **NASCE IL CANCELLO CHALLENGE, in testa al documento.** Risposta alla domanda di Claudio ("quando possiamo iniziare a valutare una challenge? siamo maturi?"): **la macchina e' matura sulla carta, le prove forward no** — si valuta a **CANCELLI VERDI**, obiettivo **meta'-fine settembre 2026**. Sei cancelli con stato e fonte: (1) famiglie a 20+ op forward con DD reale ≤ promesso — 🔴 **solo 2 famiglie su 17 sopra soglia** (Aperture DAX 38 ingressi **in perdita −698,46 €**, ORB 25 in utile) e **DD reale n/d ovunque**; (2) censimento contratti — 🟡 esiste, ma **senza la peggior giornata**, che **R112 sta misurando adesso**; (3) dossier prop a muri statici — 🔴 **Upcomers bocciata**, secondo dossier **in arrivo**; (4) preset Guardian sui muri della prop scelta — 🔴 il Guardian e' tarato solo su FTMO; (5) firma del piano due-dial — 🔴 mai firmata; **(6) 🆕 PROVA DELLA TAGLIA**, nata dall'**orientamento dichiarato di Claudio** del 26/08 sera (_"voglio partire con una challenge tra le PIU' ALTE... ho la possibilita' economica"_ — registrato come orientamento, **non come firma**): prima di comprare 200k+ va misurato che i lotti non sbattano su **`SYMBOL_VOLUME_MAX`=100** (R109: **66 trade su 743 = 8,9%** tagliati) e sui limiti di margine, perche' le percentuali sono trasferibili **solo se la scala e' lineare** — e lo slippage misurato (**21,5 pt**) dice che non lo e'. 📅 Registrato il vincolo **Jackson Hole 27-28/08**: non si inizia nulla prima. 🆕 **Conteggio forward per famiglia [CALCOLO DI QUESTO GIRO]** dal CSV degli statement (chiusure fino al 25/08), con convenzioni dichiarate (ingressi vs chiusure, 100k tenuto fuori) — e la colonna **DD reale lasciata `n/d`, non inventata** (→ M20, serve la pagella serale come flusso). Righe nuove: **C7** (dial 1,00 challenge / 0,74 funded; pass **99,6%** e **dirupo a d≈1,055**; profitto mediano per passata **piatto 8,5-9,3 k€**; 🔴 **conflitto dichiarato con R106** che per la challenge raccomandava 0,74), **B10** (preset per famiglia di muri: su 3/6 **ogni** soglia di casa sta oltre il muro), **E8** (regola dei 2 minuti: 🥇 **misurato in casa** — **15,2%** delle chiusure dal 20/07 sotto i 2 min, **44% sulle Aperture DAX** — e **conflitto risolto dalla gerarchia**: in forward la durata **si misura**, in backtest no), **F7** (Upcomers **BOCCIATA**: 3% daily, 6% trailing su equity, T&C che negano il diritto ai profitti, delisting, Saint Lucia 2025), **F8** (criterio di scelta della prop in 7 punti, il muro prima del traguardo). **Corollario di C7 dall'`ANALISI_DD_TOTALE`**: DD totale worst **−6,37%** contro worst day **−4,74%** → **il vincolo che morde e' il giornaliero** (margine 5% contro 36%), specifica per il cacciatore = **5% g / 10% tot STATICI**, e un **6% trailing si romperebbe persino sui chiusi**. **C1** aggiornata col caso R112 (una short-only a 1,95%/trade impegnerebbe il **60% del cap 3,25%** con un solo SL vivo). → **42 parametri (12C · 15P · 14A · 1 chiuso)** | analisi dial + sopravvivenza funded + DD totale (26/08), dossier Upcomers, R110 chiuso e R112 firmato, letture misure lampo e anatomia aperture, forward ricontato sugli statement del 25/08 |
