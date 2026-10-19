# Pacchetto Oro -- lettura dei giri lunghi (21 mesi gen 2025 - set 2026) e della corsa continua del Gold Reaper (19/10/2026)

## 🔴 CORREZIONE DEL 19/10 (stessa giornata, dopo l'arrivo di GRSETC) -- la corsa "GRC default" NON era default
Arrivato lo zip GRSETC, confronto i report: **GRC e GRSETC sono IDENTICI** (791 operazioni, +3.969,57, PF 2,88, DD 4,77%, stesso `.ex5` SHA256 AB636AF9...). Letti gli input scritti nei report [LETTO]: **in entrambi `TradeFrequency=2`, `MaxAllowedDD=9.0`, `PropFirmMaxDailyDD=4.0`, `OnlyUp=false`** (il set di Claudio). Il `.ini` di GRC aveva `[TesterInputs]` vuoto: il tester ha riusato **l'ultimo set salvato per quell'EA su quel PC**, cioe' quello delle corse GRSET di prima (rischio che il mio stesso REFERTO dichiarava: "default dell'EA, o ultimo valore salvato nel tester [NON VERIFICATO quale]"). **Io ho letto GRC come default senza aprire gli input del report: errore mio.** Controllo fatto ora su tutti i report: W1 (3) e GRW2 (18) hanno `5 / 30.0 / 0.0 / true` = default **veri**; GRSET W2 (21), GRC e GRSETC hanno il set di Claudio.
**Cosa cade di quanto scritto sotto sul Gold Reaper in continuo:**
- Le righe "C2 SMENTITA", "C3 SMENTITA", "B7 sotto soglia", "un quarto del rendimento dichiarato dal venditore a impostazioni di default" e "lo stato interno cambia la sequenza" **NON valgono**: riguardavano il set di Claudio e le ho confrontate con soglie costruite sul default. Una corsa continua col **default NON e' stata misurata**.
- **Lettura corretta di GRSETC (= GRC), set di Claudio, soglie scritte PRIMA per GRSETC:** **C1 CONFERMATA** (perdita max dal deposito 2,67% <= 10%; DD dal picco 4,77% <= 15,2%; anche la banda prevista 4,55-5,67% regge). **C2 CONFERMATA** (equita' finale 8.969,57 >= 5.042). **C3 CONFERMATA** (791 operazioni contro 789, +0,3%, banda +/-20%). Le tre previsioni dichiarate per il set di Claudio erano giuste. Resta: 74,72% di vincenti, lotti 0,01-0,02, +79,4% in 21 mesi (circa 2,8% al mese) sul conto continuo; la stima a mesi indipendenti del set (10.084) sovrastimava del 12% il risultato continuo.
- **Quello che NON si puo' dire**: se il Gold Reaper a default replica il Myfxbook del venditore (+312%): non misurato in continuo; a mesi indipendenti il default (GRW2+W1) ha dato +7.963,73.
**Cosa resta valido:** B5 e B6 (usano GR a mesi indipendenti con input default verificati: W1 e GRW2), e quindi la regola di acquisto del pacchetto resta NON soddisfatta; B2/B3 dei tre EA (primo giro di ciascuno su questo PC: input dal report, non verificati contro i default del venditore). Il Gold Reaper col SET di Claudio supera C1, C2, C3 e B4 in continuo; resta da dire che e' il SET di Claudio, non il prodotto "as is".
**Regola nuova per i prossimi giri**: un giro "default" va lanciato con gli input imposti esplicitamente al valore di default (o dopo aver azzerato quelli salvati) e si apre il blocco input del report PRIMA di leggere qualsiasi numero. Vale anche per il setaccio (2 passate H1/M15): per un EA girato prima su questo PC, gli input salvati possono non essere i default.


**Non controllata da agenti** (non disponibili in questa sessione): solo il mio controllo e lo strumento congelato `backtest_pipeline/correlazione_pacchetto.py` (non modificato). Ipotesi lette secondo `report/PACCHETTO_ORO_ATTESE_2026-10-17.md` (addendum 18/10, seconda e terza parte), scritte PRIMA dei numeri; criteri NON toccati.
Materiale: quattro zip arrivati dal PC di backtest (GTPL, GOLDBOTL, PHANTOML, GRC), archiviati in `backtest_pipeline/risultati_archivio/PACCHETTO_ORO_LUNGO_20261019/` (MANIFEST + REFERTO; i report .htm restano fuori repo). **GRSETC (corsa continua col set di Claudio) NON e' arrivato**: non c'e' lettura di C1-C3 per il set di Claudio.

## Conformita' dei giri [LETTO nei MANIFEST/REFERTI]
- Ticks reali 100%, deposito 5.000, finestre mensili giuste, `.ex5` con SHA256 uguale prima/dopo ogni tranche (GTPL/GOLDBOTL/PHANTOML 21/21; GRC 1/1), stop-out e no-money nel log 0, nessun timeout.
- **GTPL: tutte e 21 le tranche sono marcate KO dal mio lettore. Il difetto e' MIO e solo di etichetta**: il tester scrive il periodo come `Daily(2025.01.01-2025.02.01)` e lo script cercava la sigla `D1`. Finestra, simbolo, ticks, deposito ed `.ex5` sono giusti; lo strumento congelato (che controlla qualita' 100%, deposito e finestra, non l'etichetta) le conta tutte e 21 come conformi. **Le uso**, lo dichiaro, Claudio puo' opporsi. (Vale anche per la sonda D1 del Gold Trade Pro se mai rifatta.)
- Periodi usati: Gold Trade Pro D1, Goldbot One H1, Gold Phantom H1 -- **NON confermati dalla pagina del Market** (restano ipotesi dichiarate prima). Se Claudio conferma un periodo diverso, i tre EA si rifanno (circa 2,5 ore ciascuno per GTP/Goldbot, 4 ore per il Phantom: durate misurate nei MANIFEST).

## Gold Reaper, corsa CONTINUA (GRC, default, 2025.01.01 -> 2026.10.01, 5.000 EUR)
Numeri [LETTI nel report]: profitto +3.969,57 EUR (equita' finale 8.969,57), 791 operazioni, PF 2,88, vincenti 74,72%, DD di equita' massimo 244,27 (4,77% dal picco), DD assoluto di equita' dal deposito 133,58 (2,67%), 18 mesi su 21 positivi (mia somma per mese di chiusura dai deal).
- **C1 (DD): CONFERMATA.** Perdita massima dal deposito 2,67% (< 10%), DD dal picco 4,77% (< 15,2%). **La mia previsione dichiarata ("GRC probabile smentita su C1", banda 9,27-14,03%) era SBAGLIATA**: la banda a mesi indipendenti sovrastimava il DD di un conto continuo.
- **C2 (equita' finale >= meta' della stima a 21 mesi): SMENTITA.** 8.969,57 < 11.127 (soglia corretta). **Dichiarato**: sulla soglia vecchia e sbagliata (8.773, base a 18 mesi) sarebbe passata; non e' quella la soglia valida.
- **C3 (operazioni dentro +/-20% di 1.019): SMENTITA.** 791 = -22,4% (banda 815-1.223). Conclusione scritta prima: **lo stato interno cambia la sequenza e le stime a mesi indipendenti non valgono.** Infatti: la somma dei 21 mesi indipendenti era +7.963,73 EUR, la corsa continua +3.969,57 (circa meta'); lotti in continua 0,01-0,02 (mai sopra 0,02), in indipendente fino a 0,06.
- **B4 (win rate 60-80%)** sulla continua: 74,72% regge. **B7 (crescita >= 3,4% al mese composto, "meta' del dichiarato")**: letta a suo tempo sui mesi indipendenti e SU QUELLA BASE REGGE (non la riscrivo); **sulla corsa continua la crescita e' +79,4% in 21 mesi = circa 2,8% al mese, SOTTO la soglia 3,4%.** Il conto continuo e' la misura piu' vicina a un conto vero: la replica del Myfxbook del venditore (+312%, 10,6% al mese) a impostazioni di default NON c'e': otteniamo circa un quarto del rendimento dichiarato, con un DD circa un terzo del dichiarato (4,77% contro 15,2%).
- **Ipotesi NON testata** [DERIVATO]: il rendimento potrebbe salire con `MaxAllowedDD` piu' alto (lotti piu' grandi); qui il lotto e' fermo a 0,01-0,02. Sarebbe una VARIANTE post-hoc: va scritta e dichiarata prima, non letta come conferma.

## Gold Trade Pro (D1), Goldbot One (H1), The Gold Phantom (H1) -- 21 tranche mensili ciascuno [LETTO dai MANIFEST + report]
| EA | netto 21 mesi | operazioni | vincenti | PF per tranche | DD equita' peggiore (tranche) | mesi positivi | lotto |
|---|---|---|---|---|---|---|---|
| Gold Trade Pro | +2.553,69 | 473 | 57,9% | 0,16-135 | 11,02% (apr 2026) | 16/21 = 76% | sempre 0,01 |
| Goldbot One | +1.300,17 | 448 | 52,5% | 0,00-849 | 6,96% (feb 2026) | 16/21 = 76% | sempre 0,01 |
| The Gold Phantom | +5.292,90 | 1.199 | 69,5% | 0,46-38 | 7,71% (ott 2025) | 17/21 = 81% | mediana 0,01, max 0,03 |
(per riferimento, Gold Reaper a mesi indipendenti: +7.963,73, 1.019 operazioni, 65,6%, DD peggiore 9,40%.) Ogni tranche riparte da 5.000: nessun valore e' di un conto continuo.
- **B2 (DD <= 15,2% in ogni mese): REGGE** per tutti e tre (peggiore GTP 11,02%).
- **B3 (>= 60% dei mesi positivi E somma positiva, >= 150 operazioni): REGGE** per tutti e tre.
- Win rate: DESCRITTO, nessuna banda dichiarata (come scritto prima). Il Gold Trade Pro e il Goldbot One stanno al 52-58% con payoff ~1,4; il Phantom al 69,5% ma con payoff ~1,08 (vincite e perdite quasi uguali, il risultato dipende dalla frequenza dei vincenti).
- **Tutti e tre operano al lotto minimo (0,01)**: sul conto da 5.000 non si puo' ridurre il rischio sotto questo, e il rendimento in EUR e' quello del lotto minimo.

## B5 e B6 con lo strumento congelato (Gold Reaper a mesi indipendenti W1+W2, 21 mesi, + i tre)
- **B5 (coppie <= 0,30; smentita > 0,50)** -- r dei risultati giornalieri, n e giorni co-attivi dallo strumento: GR/GTP **0,555** [0,325; 0,734]; GR/Goldbot **0,462** [0,313; 0,600]; GR/Phantom **0,554** [0,398; 0,693]; GTP/Goldbot **0,422** [0,039; 0,723]; GTP/Phantom **0,522** [0,371; 0,663]; Goldbot/Phantom **0,599** [0,445; 0,724]. Per il metodo congelato le sei coppie sono "NON MISURATA" (l'intervallo al 95% contiene 0,50), ma **nessuna coppia e' dentro 0,30 e quattro hanno la stima puntuale sopra 0,50**: **B5 NON regge** per nessuna coppia. Nel solo 10% dei giorni peggiori (43-44 giorni) i valori sono molto diversi (da -0,32 a +0,41): campione piccolo, solo descrizione.
- **B6 (DD di portafoglio <= 1,5 x il DD del singolo peggiore): SMENTITA.** Pavimento del portafoglio **930,00 EUR (18,6% di 5.000, maggio 2026)** contro il limite 859,46 (1,5 x 572,97 del Gold Trade Pro). **Cancello di sopravvivenza: il pavimento sfonda il 10% (500 EUR)**; tetto 1.428 EUR (28,6%). Limiti dello strumento (dichiarati): quattro conti da 5.000 sommati con peso 1, non un conto condiviso; margine, lotti sul saldo comune e Guardian non simulati.

## Regola di acquisto scritta prima (B2, B3, B5 su almeno 3 EA su 4 E B6) -> **NON SODDISFATTA**
B2 e B3 reggono per i quattro EA; **B5 non regge, B6 e' smentita**. Per la regola decisa PRIMA dei numeri il pacchetto di quattro EA come "flotta scorrelata" e' **NON da comprare** a queste condizioni. Non cambio il criterio per convincere nessuno.
**Cosa resta vero e cosa no:**
- I quattro EA hanno tutti mostrato mesi positivi nella maggioranza dei mesi e DD mensili sotto il 12% in questo tester: nessuno e' "rotto".
- Pero' sono **quattro EA sullo stesso oro, che perdono insieme** (aprile-maggio 2026) e che a lotto minimo non si possono ridimensionare: l'idea di "scorrelati" non e' sostenuta.
- Il Gold Reaper da solo: B2, B3, B4, C1 reggono; **C2, C3 smentite e B7 non regge in continuo**: resta un EA con DD basso in tester ma con un rendimento molto sotto il dichiarato, e il segnale pubblico a 46% di prelievo resta una smentita NON spiegata. Non e' "candidato forte"; e' "candidato debole, con rendimento reale probabilmente piccolo".
- **Non misurato qui**: spread/slippage/ritardi dal vivo, feed unico BCM, conto reale diverso dal tester (margine oro ~8.580 EUR/lotto nel tester contro 1.784 sul reale), periodo vero dei tre EA, GRSETC.

## Da chiedere / fare
1. GRSETC: mandare lo zip se il giro e' finito (altrimenti dire cosa ha scritto la finestra).
2. Timeframe dei tre EA dalle pagine del Market (Gold Trade Pro, Goldbot One, Gold Phantom): se diversi, si rifanno.
3. Domande al venditore prima di qualsiasi acquisto (gia' elencate): impostazioni del Myfxbook (MaxAllowedDD, lotti), spiegare il 46% del segnale, rimborso scritto.
4. Il budget di 1.500 EUR in un solo pacchetto non e' sostenuto da questi test; una spesa piu' piccola, su un solo EA, e' decisione di Claudio (non propongo taglie).
