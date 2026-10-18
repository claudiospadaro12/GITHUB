# Pacchetto Oro -- W2 (gennaio 2025 - giugno 2026, + variante e W1): lettura del 18/10/2026

Fonte: `risultati_archivio/PACCHETTO_ORO_W2_20261018/` (quattro zip: GRW2, GRSET, TIGW2, TIGR025; giro lanciato il 17-18/10). Attese scritte PRIMA dei numeri: `PACCHETTO_ORO_ATTESE_2026-10-17.md` (addendum 17/10 sera). Operazioni ricostruite dagli Affari dei report (abbinamento per lato e volume; somme = profitto dei report). 78 tranche mensili, TUTTE OK: ticks reali 100%, finestre giuste, deposito 5.000, leva 1:100, stesso `.ex5` prima e dopo (Gold Reaper AB636AF9..., TIG 30213352...); GRSET e TIGR025 confermano gli input imposti (`input_ok = si` nel MANIFEST). Nota: il REFERTO delle due varianti porta ancora la riga "input imposti: NESSUNO" (difetto del testo corretto nella versione ripubblicata, classi 1480-1481): fa fede il MANIFEST e il report.
**Limite strutturale**: ogni mese parte da 5.000 EUR indipendente (non e' una curva continua); la crescita "composta" sotto e' una STIMA che moltiplica i rendimenti mensili.

## The Gold Reaper 5.4, default -- GRW2 (18 mesi mai visti) [DERIVATO]
- **16 mesi su 18 positivi** (negativi: febbraio 2025 -273,98 e ottobre 2025 -108,01). 906 operazioni, **65,6% vincenti**, PF 2,80, **netto +6.691,98** (media +371,8 al mese = +7,4% di 5.000).
- **DD di equita' massimo in un mese 9,40%** (gennaio 2025), mediana 4,17%, nessun mese oltre il 15%. Giorno peggiore REALIZZATO -3,9% (23/04/2026), nessun giorno oltre -4%. Lotti vivi contemporanei al massimo 0,34.
- Stima composta: 18 mesi **x3,51 (+251%)**; sui 21 mesi con W1 **x4,45 (+345%)**, circa 7,4% al mese: dello stesso ordine del **+312% dichiarato** dal venditore (circa 6,8% al mese composti).
- **B2 (DD <= 15,2%): REGGE** · **B3 (>= 60% dei mesi positivi e somma positiva): REGGE (89%)** · **B4 (win rate 60-80%): REGGE (65,6%)** · **B7 (crescita >= meta' del dichiarato): REGGE**.
- **Il dubbio sul "motore dell'escursione"** (attesa dichiarata 17/10 notte): se la tesi fosse giusta i 6 mesi piu' stretti sarebbero in maggioranza negativi. **Misurato: 1 su 6 negativo (somma +1.132)**: la tesi in questa forma e' **SMENTITA**. Resta una correlazione moderata (r = 0,44 fra escursione del mese e netto): i mesi larghi rendono di piu', i mesi stretti non perdono [DERIVATO: escursione dal limite inferiore dei prezzi operati dai quattro EA].
- Cautele che restano: tester a slippage zero e commissione 0,02 EUR per 0,01 lotti a lato; filtro NFP del Gold Reaper sfasato di due ore nel tester (non protegge); lotto minimo 0,01 puo' gonfiare il rendimento su conti piccoli; **il segnale pubblico "impostazioni predefinite" ha prelievo 46%**, mentre qui il massimo mensile e' 9,4%: la differenza non e' spiegata (periodo 2024? slippage? leva? dimensionamento?) [NON RISOLTO].

## Il set propfirm di Claudio -- GRSET (21 mesi) [DERIVATO]
Input imposti confermati: TradeFrequency=2, MaxAllowedDD=9, PropFirmMaxDailyDD=4, OnlyUp=false.
- **18 mesi su 21 positivi** (negativi: feb 2025 -153,60; ott 2025 -59,24; lug 2026 -48,85). 789 operazioni, **74,7% vincenti**, PF 2,79, **netto +3.616,52** (media +172 al mese = +3,4% di 5.000). Stima composta 21 mesi **x2,02 (+102%)**, 3,40% al mese.
- **DD massimo in un mese 4,53%**, mediana 1,80%; **in ognuno dei 18 mesi di GRW2 il DD del set e' piu' basso** di quello del default (es. 9,40 -> 3,28; 8,45 -> 4,53). Giorno peggiore REALIZZATO -2,4% (23/04/2026), nessun giorno oltre -4%. Lotti vivi al massimo 0,11 (default 0,34).
- **GS1 REGGE** (DD non peggiore, >= 60% mesi positivi, nessun giorno oltre -4%). **GS2** (la protezione giornaliera "agisce" almeno una volta): **NON OSSERVATA** nei giornali estratti: il giorno peggiore (-2,4%) non ha mai raggiunto il 4%; l'equita' intraday non e' misurata.
- Lettura: con il set di Claudio si prende **circa meta' del rendimento (3.617 contro 7.964 sui 21 mesi) con circa meta' del drawdown**.

## TIG -- TIGW2 (default, 18 mesi) e TIGR025 (rischio 0,25%, 21 mesi) [DERIVATO]
- **TIGW2**: **3 mesi su 18 positivi**, 1.202 operazioni, **40 vincenti (3,3%)**, netto **-24.833,23**, PF 0,65. **DD di equita' fra 37% e 78% in OGNI mese (18 su 18)**, 224 giorni con perdita realizzata oltre -4%. T5 regge, T7 smentita, **TD (DD <= 30% ogni mese) smentita 18/18**.
- **TIGR025** (variante POST-HOC, valutata solo sui 18 mesi di W2): positivi 7 su 18 (39%), somma W2 **-4.411,02**, DD oltre il 15% in 9 mesi su 21 (max 22,8%). **TV1 smentita in tutte e tre le condizioni** (DD <= 15%, somma positiva, >= 40% mesi positivi). Anche a un sesto del rischio la media e' -245 EUR al mese (-4,9%): il difetto e' l'**aspettativa negativa** (PF 0,69, 3,1% di vincenti), non solo la taglia.
- **Giudizio**: TIG non e' un candidato a nessuna taglia misurata. Le rare vincite (es. agosto 2025: UNA sola operazione, +3.695 al default) non pagano le centinaia di stop.

## B5 fra Gold Reaper e TIG (stessi 18 mesi) [DERIVATO, metodo mio, non quello congelato di `correlazione_pacchetto.py`]
Correlazione dei risultati giornalieri (giorni feriali, n = 390): **r = 0,277**, bootstrap 95% [0,10; 0,44]; sui 138 giorni co-attivi r = 0,352; fra i netti mensili r = 0,277. Il criterio era "<= 0,3, smentita se una coppia > 0,5": **non smentito per questa coppia**, ma il limite alto dell'intervallo e' 0,44. GRW2 e GRSET: r = 0,954 (stesso EA). **B5 sul PACCHETTO vero (Gold Trade Pro, Goldbot One, Gold Phantom) e B6 non misurabili: gli zip dei tre EA non sono ancora arrivati e i loro timeframe non sono confermati.**

## Cosa decide e cosa NO
La regola di acquisto (B2, B3, B5 su tre EA su quattro + B6) **non e' ancora decidibile**: per il pacchetto e' stato misurato solo il Gold Reaper, che supera B2, B3, B4, B7; mancano gli altri tre. Il Gold Reaper da solo e' un **candidato** (mai "garantito"): un feed, 21 mesi, tester senza slippage, e il segnale pubblico a 46% di prelievo resta una smentita non spiegata.

---

## ✏️ ANNOTAZIONE DEL 18/10/2026 (09:30) -- il DD rimesso su un conto CONTINUO, e B5 col metodo congelato
Aggiunta **in coda**, senza toccare niente sopra. Due misure che la lettura lascia aperte, fatte sugli stessi quattro zip.

### 1. 🔴 Il «DD massimo in un mese» NON e' il DD che vedrebbe un conto, ed e' la chiave del 46% non spiegato
Il limite strutturale dichiarato a r.4 (ogni mese riparte da 5.000 indipendenti) ha una conseguenza che cambia i numeri citati: **il DD di equita' «massimo in un mese» e' cieco alle strisce fra mesi**, perche' a ogni primo del mese il conto torna a 5.000 e il picco precedente sparisce. Confrontarlo col **prelievo di un conto continuo** (il 46% del segnale pubblico, il 10% di FTMO, il 10% del nostro Guardian) e' il confronto fra due unita' diverse (classe 1488).
**Stima del DD di un conto CONTINUO**, rimettendo dentro sia le strisce sia il dentro-mese. Metodo: equita' composta mese per mese; dentro il mese `m` l'equita' scende di `DD_abs(m) x E/5.000`; il massimo prelievo si legge su picchi e fondi di quel percorso. 📐 **Ipotesi dichiarata**: il lotto scala col saldo — ed e' **misurata**, non assunta (`UseWeightedLots=true`, `OnlyUp=true` nei `Dati in ingresso`, e il rapporto lotti che cresce col saldo, H3' smentita in W1).

| | DD max DENTRO un mese (citato sopra) | DD a sola granularita' mensile | **DD stimato di un conto CONTINUO** | equita' finale stimata |
|---|---|---|---|---|
| **Gold Reaper default** (18 mesi) | 9,40% | 5,48% | **13,45%** (peggiore a marzo 2025) | 5.000 -> **17.547** (x3,51) |
| **Set propfirm di Claudio** (21 mesi) | 4,53% | 3,07% | **5,47%** | 5.000 -> **10.084** (x2,02) |
| **TIG default** (18 mesi) | 78,13% | 99,97% | **119,56%** | 5.000 -> **circa 2 EUR** |

**Tre conseguenze, e sono tutte operative:**
- 🟠 **Il Gold Reaper default sta a 13,45%, non a 9,40%.** B2 (`<= 15,2%`) **regge ancora**, ma il margine passa da 5,8 punti a **1,75**: e' un *regge*, non un *regge largo*. 🔴 E **sfonda il 10% di FTMO e del nostro Guardian**: il default **non e' schierabile su una prop** cosi' com'e'.
- 🟢 **Il set di Claudio sta a 5,47%, e questo e' il numero che conta**: sotto il 10% di FTMO con il 45% di margine. La lettura di r.19 (*"meta' del rendimento con meta' del drawdown"*) regge anche su conto continuo: **x2,02 di equita' con 5,47% di prelievo**. 👉 Fra i due, **l'unico candidato per una prop e' il set**, non il default.
- 🔴 **TIG a conto continuo si AZZERA**: da 5.000 a **circa 2 EUR** in 18 mesi, DD stimato oltre il 100%. Il `-24.833,23` citato sopra e' la **somma di 18 conti separati** e per questo **sottostima** cosa succede davvero: un conto solo muore prima, e i mesi successivi girerebbero su niente. Questo chiude il giudizio su TIG piu' di qualunque PF.
- ⬜ **E il 46% del venditore resta NON SPIEGATO**: anche corretto a conto continuo siamo a **13,45%**, un fattore **3,4** di distanza. Quindi la differenza **non** e' l'artefatto delle tranche. Resta da spiegare (periodo diverso, slippage del reale, leva, dimensionamento, o un'altra versione dell'EA) ed e' **l'elemento piu' scomodo di tutta la misura**: un venditore il cui conto pubblico perde il 46% con gli stessi default che da noi perdono il 13,45% descrive un EA che non e' quello che abbiamo girato. **Su questo, prima di comprare, si chiede a lui.**

### 2. B5 col metodo CONGELATO (non ad hoc): REGGE, e nei giorni brutti vanno in direzioni OPPOSTE
Rifatta con `backtest_pipeline/correlazione_pacchetto.py` (metodo in `report/PACCHETTO_ORO_B5_B6_METODO_2026-10-17.md`, scritto prima di questi numeri), che aggiunge i due cancelli che un calcolo ad hoc non ha: minimo 30 giorni co-attivi e intervallo bootstrap al 95%.
- **Gold Reaper / TIG, 18 mesi: `r = 0,259`** su **n = 393** giorni, **146 co-attivi**, bootstrap 95% **[0,099; 0,416]** -> **B5 REGGE** (`<= 0,30`, e l'intervallo non tocca la soglia di smentita 0,50). Contro-prova sull'equita' a inizio giornata: `r = 0,258`, **stesso esito** — le due varianti non si contraddicono.
- 🟢 **E nel 10% dei giorni peggiori del portafoglio (41 giorni): `r = -0,355`.** Cioe' nei giorni che fanno male **si muovono in direzioni opposte**: il contrario di W1, dove su 6 soli giorni usciva +0,418. Con 39 giorni il numero ora **ha un campione**.
- La lettura di r.27 dava `r = 0,277` con un metodo dichiarato ad hoc: lo scostamento (0,259 contro 0,277) viene da **come si contano i giorni** — qui l'insieme dei giorni e' l'unione delle **finestre delle tranche conformi** e i giorni senza operazioni valgono **zero** (classe 1486). Stesso verdetto, metodo riproducibile.
- ⬜ Invariato: **B5 sul pacchetto VERO e B6 non sono misurabili**, mancano gli zip di Gold Trade Pro, Goldbot One e Gold Phantom.

### Cosa questa annotazione NON misura
- Il DD di conto continuo e' una **STIMA**, non una corsa: nessuno ha girato 18 mesi di fila su un conto solo. Resta cieco all'**equita' intraday** (il DD vero di un giorno), e la prova vera e' **una corsa continua nel tester** — che va aggiunta alla coda, con l'attesa scritta prima.
- L'ipotesi «il lotto scala col saldo» e' misurata ma **lineare per assunzione**: se l'EA ha scalini o tetti, la stima sbaglia. Direzione dell'errore **non determinata**.
- GS2 resta **NON OSSERVATA** e il filtro NFP resta sfasato nel tester: due cose che una prop vera cambierebbe.
