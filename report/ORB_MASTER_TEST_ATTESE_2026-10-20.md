# The ORB Master: piano di test con i preset che abbiamo, previsioni scritte PRIMA dei numeri (20/10/2026)

**Non controllata da agenti.** Claudio non trova altri preset: si testa con i 7 .set gia' in nostro possesso (identici al repo, del 23/08, 3 indici). Criteri generali: `MARKET_ORB_VENDITORE_CRITERI_2026-10-20.md` (soglie S-*, S-CORR, S-PORT, S-ORA). Lettura dei set e della pagina: `ORB_MASTER_SET_LETTURA_2026-10-20.md`.

## Limiti dichiarati PRIMA
- Il prodotto e' la **v3.4 del 17/10/2026** (4 indici, 12 varianti, parametri nuovi); i set coprono **3 indici (9 varianti)**: gli input che nei set mancano (DAX, filtro orari, `Origine ora`, `DeletePending`, `DeleteOpen`...) restano ai valori di default della v3.4 o all'ultimo salvato dal tester [NON VERIFICATO quale]: si leggono nel report ("Dati in ingresso") PRIMA di ogni numero. Se il DAX gira per default, e' un cambio rispetto ai set: lo si scrive.
- Il test usa **EURUSD M15** come grafico (indicazione del venditore) e i **simboli BCM SPXUSD, U30USD, NASUSD** (comunicati da Claudio) negli input; il DAX non e' mappato. Deposito **80.000 EUR** (coerente con Prop Firm e Gold Reaper a 80K). Ticks reali.
- Si impongono nel .ini **tutti i 57 input** non separatori del preset + i 3 simboli + `MaxRisk_Strategy` e `PropFirmMaxDailyDD` del preset scelto + gli **offset GMT** della singola passata; verificati nel report valore per valore (il tester riusa gli ultimi input salvati se non imposti: errore GRC del 19/10).

## Fase 1 -- sonda di 2 minuti-mese (nessun verdetto di merito)
Preset **prop firm** (`MaxRisk_Strategy=2`, `PropFirmMaxDailyDD=4.0`), finestra **01/10/2025 - 01/12/2025** (include il cambio d'ora UE del 26/10 e USA del 02/11), due passate: **T1 offset GMT 1/1** (BCM UTC+1 fisso) e **T2 offset GMT 2/3** (valori del venditore).
**Previsioni dichiarate ORA**
- **O-A**: in entrambe le passate l'EA apre almeno una operazione su ciascuno dei tre indici (SPXUSD, U30USD, NASUSD). Se uno non opera: simbolo o ticks non riconosciuti, misura mancante per quell'indice.
- **O-B**: le passate T1 e T2 sono **DIVERSE** (operazioni e orari di ingresso non identici): gli offset agiscono nel tester come scrive la pagina. Se identiche al centesimo, gli offset sono inerti con questi input e la pagina e' fuorviante.
- **O-C**: con offset 1/1 il primo ingresso di ogni giornata USA cade a ridosso della cash (14:30 server fino a domenica 02/11 compresa... fino al 01/11, 15:30 dal 03/11); con 2/3 gli ingressi sono spostati di 1-2 ore. Verificabile dall'ora dei deal.
- **O-D**: nessun "INPUT NON APPLICATI" (tutti i 57+ valori imposti coincidono col report).
- **O-E**: durata per passata (2 mesi) sotto 60 minuti [NON MISURATO: serve a decidere se la fase 2 e' fattibile].
- **O-F**: nessuno stop-out e nessun "no money" nel giornale.
## Fase 2 (solo dopo la lettura della fase 1): corsa continua 01/01/2025 - 01/10/2026 con l'offset corretto dalla fase 1; poi soglie S-N, S-M, S-H, S-DD, S-NOSCALA, S-COSTO, costo doppio, S-ORA (+/-1 ora), S-CORR con Prop Firm e Gold Reaper, S-PORT (stesse soglie e basi gia' scritte). Non si sceglie il preset piu' redditizio.
