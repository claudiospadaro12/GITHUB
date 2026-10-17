# Pacchetto Oro -- W1 (luglio-settembre 2026): Gold Reaper 5.4 e TIG nel nostro tester (lettura del 17/10/2026)

Fonte: `risultati_archivio/PACCHETTO_ORO_W1_20261017/` (zip GOLDREAPER e TIG, giro lanciato alle 09:17). Attese e criteri scritti PRIMA dei numeri: `THE_GOLD_REAPER_ATTESE_2026-10-16.md`, `THE_IMPOSSIBLE_GOLD_ATTESE_2026-10-16.md`, `PACCHETTO_ORO_ATTESE_2026-10-17.md`. Operazioni ricostruite dagli Affari dei report (abbinamento in->out per lato e volume; somme = profitto del report, controllato).

## Conformita' [LETTO nei REFERTO]
Tutte le 6 tranche OK: XAUUSD, finestre mensili corrette, **100% ticks reali**, deposito 5.000 EUR, leva 1:100, nessun input imposto, **.ex5 con la stessa SHA256 prima e dopo ogni tranche** (Gold Reaper AB636AF9..., TIG 30213352...). Ticks XAUUSD reali dal 10/07/2024. Il tester gira VELOCE: **Gold Reaper circa 11-13 minuti per mese, TIG 38 secondi per mese**: la finestra lunga W2 (18 mesi) costa circa 3,6 ore per il Gold Reaper e 12 minuti per TIG.

## THE GOLD REAPER 5.4 (H1, default) [LETTO + DERIVATO]
| mese | operazioni | vinc. | netto EUR | PF | DD equita' |
|---|---|---|---|---|---|
| luglio | 33 | 51,5% | -66,83 | 0,60 | 4,35% |
| agosto | 40 | 65,0% | +611,85 | 4,00 | 4,50% |
| settembre | 40 | 77,5% | +726,73 | 8,44 | 2,96% |
| **tot** | **113** | **65,5%** | **+1.271,75 (+25,4%)** | **3,73** | max 4,50% |
Luglio e' **identico al giro del 16/10** (-66,83): il tester e' riproducibile. Ha aperto solo alcune strategie; lotti 0,01-0,05, posizioni contemporanee al massimo 0,22 lotti (agosto). Giorno peggiore REALIZZATO -145,5 (12/8, -2,7%).
- **H1** (positivo in 2 mesi su 3): **REGGE** (agosto e settembre).
- **H2'** (DD <= 14%): **REGGE** (4,35%, 4,50%, 2,96%).
- **H3'** (rapporto lotti <= 2): **SMENTITA alla lettera**: luglio 2,0, agosto 5,0, settembre 4,0. Il lotto cresce con il saldo e con il peso della strategia (nessuna martingala vista, ma il criterio scritto era un tetto).
- **H4/H6** (giorno <= -200 EUR): **non smentita sul realizzato** (peggiore -145,5); l'equity intraday vera richiede il replay M1.
- **H5** (win rate 65-80% a ticks reali): aggregato **65,5% DENTRO**; luglio da solo 51,5% fuori.
- Cautela: **agosto e settembre 2026 sono mesi di trend forte dell'oro** (PF 4 e 8,4 sono molto alti): un periodo favorevole ai breakout. Tre mesi, un feed. Il test lungo W2 serve a questo.

## THE IMPOSSIBLE GOLD (TIG) (M5, default) [LETTO + DERIVATO]
| mese | operazioni | vinc. | netto EUR | PF | DD equita' |
|---|---|---|---|---|---|
| luglio | 70 | **1** | -3.072,56 | 0,18 | **75,5%** |
| agosto | 56 | **2** | +3.163,54 | 1,37 | **61,6%** (13.088 EUR di DD da un picco alto) |
| settembre | 104 | **1** | -3.815,57 | 0,10 | **76,9%** |
| **tot** | **230** | **4 (1,7%)** | **-3.724,59** | 0,77 | |
**TIG e' una lotteria a un rischio per trade dell'1,5% composto**: 218 stop da circa -1,5% dell'equity (medi -69 EUR) e **4 vincite in tutto**: +691 (luglio, 97 USD di movimento), +7.928 (agosto, 292 USD in 4 giorni, da 4.041 a 4.334), +3.699 (agosto, 88 USD), +404 (settembre). Senza il +7.928 di agosto il trimestre sarebbe -11.650. Lo stesso profilo si vede sul demo: il BUY 0,36 aperto il 14/10 e' una di queste rare vincite.
- **T0** (i default coincidono col demo): **REGGE**, tutti gli input letti dal report coincidono con la scheda (lookback 16, buffer 1,5, SL 25, TP 300, rischio 1,5% composto, max 1 posizione, max 5 al giorno, sessione 10-20, esclusione 12-15, trailing 10/2, estensione TP 14, regime EMA 50).
- **T1**: una sola posizione per volta (**regge**); rapporto lotti 4,3 / 2,7 / 4,3 (**smentito alla lettera**: i lotti seguono l'equity: scendono da 0,34 a 0,08 nei drawdown, salgono con la vincita; non c'e' scala dopo le perdite: e' il contrario).
- **T2** (max 5/giorno): **REGGE** (5, 5, 5).
- **T3** (sessione): nel tester le aperture stanno fra le 10:00 e le 19:59 SERVER (ore 10, 11, 15-19): l'EA usa l'orologio del server come fosse GMT; il demo del 14/10 operava un'ora dopo (11:05, 12:05, 19:15). **Differenza di un'ora fra tester e live** [DERIVATO]: smentita rispetto alla finestra "GMT = server -1".
- **T4** (perdita per stop 1,0-2,0%): **REGGE** su 229 stop su 230; **eccezione: 14/07 sell 0,17 lotti chiuso a -735,2 (-29% dell'equity)**: stop di 25 pips "saltato" dal rilascio dei dati (CPI, 13:30 server): lo stop non e' un limite sulle notizie. Un caso su 230, ma pesa quanto otto stop.
- **T5** (win rate < 40% in ogni mese): **REGGE** (1,4%, 3,6%, 1,0%).
- **T6** (giorno <= 7,5%): **SMENTITA** sul realizzato: 14/07 -29,5%, 16/09 -11,7%, 28/08 -10,6%, 06/07 -9,3%.
- **T7** (positivo in almeno 2 mesi su 3 e somma positiva): **CONTRARIO**: positivo 1 mese su 3, somma -3.724,59, 230 operazioni (sopra le 60 minime).
**Giudizio descrittivo**: TIG a questa taglia (1,5% composto) NON e' adatto ne' a una prop ne' a un reale da 4.000 EUR: drawdown di equity 60-77% in tre mesi su tre. Il demo di ieri (+2.531 flottanti) e' una di quelle quattro vincite. **Un TIG con rischio per trade molto piu' basso** (0,1-0,25%) e' un'altra prova da fare, ora costa 12 minuti.

## Cosa NON dicono questi numeri
Tre mesi, un feed (BCM), nessuna slippage del reale (il tester ha lo stop a prezzo ma con salti reali nei ticks), commissione del tester 0,02 EUR per 0,01 lotti a lato [la commissione BCM vera e' ancora da avere per iscritto]. Per il Gold Reaper il filtro NFP nel tester usa offset GMT manuali sfasati: la protezione non e' quella del live.
Le tre prove del pacchetto (Gold Trade Pro, Goldbot One, Gold Phantom) sono in corso sulla seconda riga, con i timeframe ancora da confermare.

---

## ✏️ ANNOTAZIONE DELLA SERA DEL 17/10/2026 -- sei correzioni ricontate ALLA FONTE, e una riserva che si ribalta
Aggiunta **in coda, senza riscrivere niente** sopra (il referto resta com'era scritto). Tutto ricontato dai tre `.htm` per EA e dai **giornali del tester** dentro i due zip, non da questo testo. Cancello: `controllo-preventivo` sulla bozza del messaggio a Claudio + ricontrollo indipendente in sessione.

**1. PF aggregato del Gold Reaper: 3,72, non 3,73.** Dai lordi della testa dei tre report: `1.739,61 / 467,86 = 3,7182`. Per tranche la testa scrive `0,60 / 4,00 / 8,44`, e ricontati danno `0,598 / 4,002 / 8,440`: tornano.
**2. Le uscite di TIG, per tipo, e sommano a 230**: **226 `sl` · 3 `tp` · 1 `end of test`**. Il numero **218** scritto sopra **non e' riproducibile** da nessun conteggio sulle uscite: va considerato ritirato finche' chi l'ha scritto non dichiara il filtro.
**3. 🔴 Delle "4 vincite" di TIG, quelle prodotte dal MOTORE sono TRE.** Elenco completo delle uscite in profitto del trimestre: `31/07 21:54:58 vol 0,08 **+691,16 [end of test]**` · `07/08 13:30:06 vol 0,32 +7.928,13 [tp 4329.24]` · `19/08 14:12:32 vol 0,49 +3.699,92 [tp 4449.91]` · `17/09 12:58:26 vol 0,13 +403,76 [tp 4352.51]`. La prima e' la **chiusura forzata di fine tranche**: non e' un'uscita della strategia e il suo P/L e' `[NON DETERMINATO]` (dove sarebbe finita non si sa). 👉 Conseguenza che **peggiora** il quadro: a **luglio il motore ha prodotto ZERO uscite in profitto** su 70 operazioni — il profitto lordo del mese (**691,16**) e' esattamente e solo quella chiusura di fine test.
**4. Il giorno peggiore di TIG: i tre numeri, con la loro base.** Il 14/07 la posizione `sell 0,17` aperta il **13/07 alle 15:05 a 4.040,03**, con SL a **4.042,53** (**2,50 USD** dall'ingresso), e' stata chiusa il **14/07 alle 13:30:44 a 4.089,71**: **47,18 USD oltre lo stop**. P/L lordo -737,49, commissione -0,30, swap +2,88 = **-735,21 netti**, saldo da **2.595,58 a 1.860,67**. Quindi: **l'operazione** vale **-28,3%** del saldo di apertura di giornata; **il giorno realizzato** (una seconda perdita, -29,77) chiude a 1.830,48 = **-29,5%**; e il **DD di equita' del giorno, che TIG stampa da solo nel suo giornale**, e' `Max Daily DD: **42.43% ($1349.32)** on 2026.07.14`. 🔴 Il numero piu' grave era **nel log, gia' calcolato**, e non era nel referto. Gli altri due peggiori, dallo stesso giornale: **28/08 45,56% ($7.269,87)** e **11/09 23,25% ($774,20)** -- contro i realizzati -10,6% e -11,7% citati sopra. (L'EA scrive `$`, ma il conto del tester e' in **EUR**: e' l'importo in valuta del conto con un'etichetta dollaro.)
**5. "+1.271,75 (+25,4%)" non e' il rendimento di un trimestre.** `REFERTO_GOLDREAPER_TRANCHE.txt` r.9 lo avvisa da solo: *"ogni tranche parte a CONTO VUOTO il primo giorno del mese... le tre tranche sono INDIPENDENTI (deposito 5000 EUR ognuna)"*. Sono **tre giri separati** da 5.000: **-1,3% / +12,2% / +14,5%**. E il Gold Reaper dimensiona il lotto dal saldo (`MaxAllowedDD=30.0`, `UseWeightedLots=true`, `OnlyUp=true`, letti dai `Dati in ingresso` del report): su un giro **continuo** il numero e' un altro, **non misurato**. Stessa etichetta per il *"senza il +7.928 sarebbe -11.650"*: e' una **sottrazione aritmetica**, non una simulazione, perche' TIG dimensiona sull'equity.
**6. I lotti vivi contemporanei del Gold Reaper, per mese: 0,06 / 0,22 / 0,14.** Il **0,22** di agosto **smentisce anche H3** (tetto scritto prima: lotti vivi <= 0,08), non solo H3'.

### 🔴 E LA RISERVA SI RIBALTA: il mese migliore e' un mese in cui l'oro e' SCESO
Sopra c'e' scritto *"agosto e settembre 2026 sono mesi di trend forte dell'oro"*. **Misurato: e' vero per agosto, FALSO per settembre.** Escursione dell'oro ricavata dall'**unione dei prezzi operati dai DUE EA** (limite **inferiore** del range vero: nessuno dei due copre tutte le ore) e direzione letta su inizio/fine di ciascuno, che **concordano**:

| mese | escursione (unione, limite inf.) | direzione: GR inizio->fine | TIG inizio->fine | GR netto | GR PF |
|---|---|---|---|---|---|
| luglio | 3.979,23-4.175,75 = **196,52 (4,94%)** | 4.061,33 -> 4.099,72 (**+0,9%**) | 3.985,66 -> 4.051,62 (+1,7%) | **-66,83** | 0,60 |
| agosto | 4.022,66-4.611,50 = **588,84 (14,64%)** | 4.022,66 -> 4.566,70 (**+13,5%**) | 4.047,02 -> 4.429,93 (+9,5%) | +611,85 | 4,00 |
| settembre | 4.115,41-4.485,54 = **370,13 (8,99%)** | 4.396,67 -> 4.115,41 (**-6,4%**) | 4.364,72 -> 4.152,32 (-4,9%) | +726,73 | 8,44 |

👉 **Il PF 8,44 cade nel mese in cui l'oro ha PERSO il 5-6%.** Quindi *"il trend dell'oro spiega i numeri"* **non regge**: la spiegazione alternativa che sta in piedi su tutti e tre i mesi e' che il motore sia lungo di **ESCURSIONE, non di direzione** — guadagna nei due mesi larghi (14,6% e 9,0%), perde nell'unico mese stretto (4,9%). Se e' cosi', il **+10,6% al mese dichiarato dal venditore e' un beta sulla volatilita'**, non un edge, e un trimestre fatto di mesi stretti non assomiglia a questo.
🧪 **Misura che lo conferma o lo smonta, da aggiungere a W2 (costo zero, sui dati che il giro produce da se')**: ordinare i 18 mesi per escursione e guardare se il P/L segue l'escursione. *Attesa dichiarata ora, prima dei numeri*: se l'ipotesi "escursione" e' giusta, i mesi nel terzo piu' stretto sono **in maggioranza negativi**; se e' sbagliata, il segno dei mesi e' indipendente dall'escursione.

### Quello che questa annotazione NON ha verificato
- Che il **14/07/2026** fosse un giorno di dato USA: nessun calendario in casa ne' nel tester. Che il salto di 47,18 USD sia **mercato** o un **buco nei tick BCM** e' `[NON DECISO]`: servirebbe la serie dei tick di quel minuto. 🟢 Il giudizio su TIG **non dipende** da quel giorno: DD di equita' 61-77% in tre mesi su tre, PF 0,77 e **tre uscite in profitto su 230** bastano da soli.
- Le cifre di movimento delle vincite TIG (97 / 292 / 88 USD) e la perdita media di **-69 EUR** per stop: non ricontate.
- L'equita' **intraday** del Gold Reaper giorno per giorno (H4/H6): non misurata. Si ha solo il tetto mensile dal DD di equita' della testa (**223,24 / 257,35 / 152,97 EUR**), che in luglio e agosto **non esclude** un giorno oltre -200.
- **B5 fra Gold Reaper e TIG, calcolata oggi** con `backtest_pipeline/correlazione_pacchetto.py` sugli stessi tre mesi: `r = 0,071` su **n = 67 giorni**, ma **22 giorni co-attivi** (sotto il minimo di 30 dichiarato nel metodo) e intervallo bootstrap al 95% `[-0,019; 0,387]` -> esito **NON MISURATA**, non "scorrelati". La contro-prova sull'equita' a inizio giornata da' `r = 0,027`, stesso esito. E nel **10% dei giorni peggiori** del portafoglio `r = 0,418` su 6 giorni: la media bassa **non dice** cosa fanno nei giorni che contano.
