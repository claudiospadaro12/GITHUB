# The ORB Master, primo giro (preset prop firm, 3 indici, 80K): lettura (20/10/2026)

**Non controllata da agenti.** Previsioni scritte prima: `ORB_MASTER_TEST_ATTESE_2026-10-20.md` (O-A..O-M). Dati: `backtest_pipeline/risultati_archivio/ORBM_V1_20261020/` (T1 e T3; T2 identica a T1). Lettura: script miei (non lo strumento congelato).

## Stato: TUTTE E TRE LE PASSATE SONO KO (misura non valida come dichiarata) -- due errori MIEI e uno del prodotto
1. **Offset GMT mai applicati (errore mio)**: il .ini conteneva `Broker_GMT_OFFSET_Winter/Summer` DUE volte (2/3 dal preset a riga 64-65, poi 1/1 per-passata a riga 86-87); il tester ha preso la PRIMA occorrenza. T1 (che doveva essere 1/1) e T3 hanno girato a 2/3; **T1 e T2 sono identiche al centesimo** (215 deal uguali). La sonda sugli offset NON e' stata fatta.
2. **Due input del preset non esistono nella v3.4**: `ForceBalanceToUse` e `LotPerBalance_step` (assenti dai Dati in ingresso; il preset del 23/08 e' vecchio). Il tester li ha ignorati; la parte di dimensionamento a saldo del preset non e' quindi stata applicata.
3. **DAX non provato**: la v3.4 ha `DAX_Symbol=DE40` di default, simbolo che BCM non ha ("Failed to set symbol DE40 to the marketwatch"); il DAX non ha operato. Ora so il nome dell'input (`DAX_Symbol`, `RunDAX`, `DAX_StartTime_string=09:00`, `DAX_StopTime_string=10:30`); sul repo il simbolo BCM e' `D30EUR`.
Nuovi input v3.4 visti: `AutoGMT_Backtest=true`, `Time_Source=3`, `UseTradingTimeZones=true`, `RunDAX`, `ResetHighestBalanceOnWithdrawal`, orari `*_StartTime_string` (US 15:30-17:00).

## Cosa dicono comunque i numeri (INDICATIVI, non verdetto)
Corsa continua 21 mesi, EURUSD M15, 80K, ticks reali 100%, durata **17 minuti** (T3), nessuno stop-out. Configurazione effettiva: preset prop + AutoGMT_Backtest=true + offset 2/3 (come il venditore), senza DAX.
| | T3 |
|---|---|
| operazioni | 1.137 (SPXUSD 345, U30USD 340, NASUSD 447; +5 su EURUSD) |
| netto | **-407,26 EUR (-0,5% di 80.000)** |
| PF | **0,93** (U30 0,87; NAS 1,04; SPX 0,94) |
| DD equity | 1.280,90 = 1,6% degli 80.000 |
| mesi positivi | **9/21 (43%)**; gen25-mag26 +72, giu26-set26 -479 |
| vincita media / perdita media; % vincenti | +12,5 / -8,2; 38,1% |
| lotti | NAS 0,1-0,2; U30 0,1; SPX 0,5-1,0 (non scalano col saldo) |
La taglia e' minuscola (0,1 lotto su 80K): il netto in euro non dice niente da solo, ma il **PF e' invariante alla taglia** e dice che con questa configurazione non c'e' vantaggio visibile.
**Orari**: gli ingressi cadono a 14:30-14:40 server d'estate e a 15:30-15:40 server d'inverno (apertura cash USA con BCM UTC+1 fisso): **l'EA centra la sessione giusta anche con gli offset 2/3 in input**, quindi l'orologio in backtest sembra gestito da `AutoGMT_Backtest`, non dagli offset. Settimane di disallineamento DST: orari misti, nessuna prova di errore.
Errori nel giornale: 63 `TrailStop ... invalid stops` su 1.137 operazioni (trailing rifiutato dal broker nel tester, piccolo ma presente), lettura dell'URL GMT fallita (4014, atteso nel tester).
**Correlazione con l'oro** (serie giornaliere dei realizzi, T3 contro corse a 80K): Prop Firm +0,053 (mensile -0,016); Gold Reaper -0,018 (mensile -0,164). Scorrelato davvero, ma e' poco informativo se la serie e' priva di vantaggio.

## Previsioni (scritte prima), esito
O-A (opera su tutti e tre gli indici): confermata. **O-B** (T1 diversa da T2): **SBAGLIATA** (identiche, per l'errore 1). O-C (14:30/15:30 server): confermata per gli orari osservati. **O-D** (nessun input non applicato): **SBAGLIATA** (4/4/2). O-E (<60 min a passata): confermata (91 s, 78 s; continua 1.045 s). O-F (nessuno stop-out): confermata. O-G (>=150 operazioni, >=40 per indice): confermata nei numeri, ma la corsa e' KO. **O-H (PF 1,05-1,8, netto positivo): SBAGLIATA** (0,93, -407). O-I (DD <=10% degli 80K): confermata (1,6%). O-J (|correlazione| <=0,3): confermata. **O-K** (mesi positivi >=60%): **SBAGLIATA** (43%). O-L (S-NOSCALA): lotti per simbolo quasi fissi, rapporto <=2: probabile passa; O-M (<16 h): confermata.
## Cosa si fa ora
Script corretto (stesso nome, marcatore v2): toglie i due input inesistenti e gli offset duplicati, aggiunge `RunDAX` e `DAX_Symbol=D30EUR`, e fa tre corse continue (17-25 minuti l'una): T1 modo venditore con DAX, T2 `AutoGMT_Backtest=false` offset 1/1, T3 `AutoGMT_Backtest=false` offset 2/3. Previsioni: `ORB_MASTER_TEST_ATTESE_2026-10-20.md` (aggiornamento V2).
