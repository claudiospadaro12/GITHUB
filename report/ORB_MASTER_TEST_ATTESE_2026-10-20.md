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
- **O-C**: con offset 1/1 il primo ingresso di ogni giornata USA cade a ridosso della cash USA: **14:30 server fino a venerdi' 31/10/2025, 15:30 server da lunedi' 03/11/2025** (gli USA tornano all'ora solare domenica 02/11; BCM e' UTC+1 fisso); con 2/3 gli ingressi sono spostati di 1-2 ore. Verificabile dall'ora dei deal.
- **O-D**: nessun "INPUT NON APPLICATI" (tutti i 57+ valori imposti coincidono col report).
- **O-E**: durata per passata (2 mesi) sotto 60 minuti [NON MISURATO: serve a decidere se la fase 2 e' fattibile].
- **O-F**: nessuno stop-out e nessun "no money" nel giornale.
## Fase 2 (solo dopo la lettura della fase 1): corsa continua 01/01/2025 - 01/10/2026 con l'offset corretto dalla fase 1; poi soglie S-N, S-M, S-H, S-DD, S-NOSCALA, S-COSTO, costo doppio, S-ORA (+/-1 ora), S-CORR con Prop Firm e Gold Reaper, S-PORT (stesse soglie e basi gia' scritte). Non si sceglie il preset piu' redditizio.

---
# AGGIORNAMENTO 20/10 sera: decisione di Claudio e previsioni sulla corsa continua (scritte PRIMA dei numeri)

**Decisione di Claudio**: "utilizziamo i set della Prop Firm cosi' vediamo come si e' comportato in passato, con tutti i simboli dell'EA", cioe' non aspettare la fase 2. La riga lancia in sequenza **T1 + T2 (sonda 2 mesi, offset 1/1 e 2/3) e T3 = corsa continua 01/01/2025-01/10/2026 con offset 1/1** (valore corretto per BCM UTC+1 fisso, dichiarato PRIMA di vedere la sonda). **T4 (continua con 2/3) NON parte**: solo se T1 e T2 risultano diverse e serve il confronto.
**DAX non incluso in questo giro**: il nome dell'input del simbolo DAX nella v3.4 non e' noto (i set del 23/08 non lo hanno) e senza di esso non lo si puo' imporre; il suo preset prop non c'e'. Dal report T1 si leggono i nomi degli input v3.4; il DAX si prova in un secondo giro, **con i parametri di default del venditore e scritto cosi'**, NON come "preset prop firm". Questa e' una limitazione, non un risultato.
**Confronto**: con la tabella memorizzata `CONFRONTO_DATI_MEMORIZZATI_80K_2026-10-20.md` (Prop Firm, Gold Reaper a 80K).

## Previsioni sulla corsa continua T3 (3 indici, preset prop, offset 1/1, 80K)
- **O-G**: operazioni >= 150 (S-N) e almeno 40 per ciascuno dei tre indici. Fiducia circa 70%.
- **O-H**: PF fra 1,05 e 1,8; netto positivo. Fiducia circa 60% (nessun dato precedente: i set sono del venditore).
- **O-I**: DD di equity in % degli 80.000 iniziali <= 10% e perdita dal deposito <= 10%. Fiducia circa 60% (`MaxRisk_Strategy=2` e' dimensionato dal DD, non so a quale base).
- **O-J**: correlazione giornaliera dei realizzi con Prop Firm e con Gold Reaper <= 0,3 (valore assoluto); gli indici contro l'oro. Fiducia circa 75%. S-CORR sogli 0,5.
- **O-K**: mesi positivi >= 60% (S-M). Fiducia circa 45%.
- **O-L**: S-NOSCALA (lotto max/min <= 3, <= 10 posizioni): lotto sizing a rischio fisso da DD -> probabile rapporto > 3 [incerto, fiducia 40% che passi].
- **O-M**: durata T3 sotto 16 ore. Fiducia 80%.
Letture da fare sempre: DD sia dal picco sia come % degli 80.000 iniziali; confronto con tutta la tabella memorizzata; S-ORA e costo doppio solo se T3 passa i cancelli base.

---
# AGGIORNAMENTO V2 (20/10 notte): giro corretto dopo la lettura del V1 (previsioni scritte PRIMA dei numeri)
Lettura del V1: `ORB_MASTER_V1_LETTURA_2026-10-20.md`. Errori miei corretti (offset duplicati nel .ini; due input inesistenti nella v3.4). Tre corse continue 01/01/2025-01/10/2026, EURUSD M15, 80K, preset prop (`MaxRisk_Strategy=2`, `PropFirmMaxDailyDD=4.0`), **DAX incluso con `DAX_Symbol=D30EUR`** (parametri DAX = default del venditore, NON preset prop): T1 `AutoGMT_Backtest=true` offset 2/3 (modo venditore); T2 `AutoGMT_Backtest=false` offset 1/1; T3 `AutoGMT_Backtest=false` offset 2/3.
- **V2-1**: tutti gli input imposti applicati (nessun INPUT NON APPLICATO) nelle tre corse. Fiducia 80%.
- **V2-2**: il DAX opera in T1 (>= 40 operazioni su D30EUR). Fiducia 65% (rischio: ticks D30EUR non disponibili o orari 09:00-10:30 non centrati).
- **V2-3**: in T1 le operazioni sui tre indici USA sono entro +/-3% di quelle del V1 (345/340/447). Fiducia 80%.
- **V2-4**: T1, T2 e T3 NON sono identiche (gli input d'orologio agiscono con `AutoGMT_Backtest=false`). Fiducia 65%. Se T2 = T3 al centesimo, gli offset sono inerti.
- **V2-5**: T3 (offset 2/3 sbagliati per BCM) entra circa un'ora piu' tardi di T2 in estate. Fiducia 55%.
- **V2-6**: PF di T1 totale fra 0,85 e 1,15; PF >= 1,3 improbabile (15%). Se confermato, si archivia il preset prop come "nessun vantaggio visibile" e non si prova il resto per scegliere il migliore.
- Soglie invariate (S-N, S-M, S-H, S-DD, S-NOSCALA, S-COSTO, S-CORR, S-PORT) e confronto con `CONFRONTO_DATI_MEMORIZZATI_80K_2026-10-20.md`.
