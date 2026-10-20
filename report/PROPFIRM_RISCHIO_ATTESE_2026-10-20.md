# Prop Firm Gold EA: prova delle impostazioni del manuale del venditore, previsioni scritte PRIMA dei numeri (20/10/2026)

**Non controllata da agenti.** Claudio non trova preset del venditore per il Prop Firm Gold EA ("non trovo altro"). Quindi si misura da soli: si impongono nel tester i valori che il manuale indica, senza file di set. Contesto: `PROPFIRM_MANUALE_VENDITORE_CONFRONTO_2026-10-20.md`. Riferimento = corsa del 19/10: XAUUSD H1, ticks reali, 80.000, tutti gli input default (`InpRiskType=0, InpRiskLevel=0, InpBaseMoneyMode=0`, protezione giornaliera spenta): **+34.129,71 (+42,7%), PF 1,25, 673 operazioni, DD equity 11.023 EUR = 13,8% degli 80.000 (9,72% dal picco), lotti 0,16-0,31, 14/21 mesi positivi**.

## Cosa si fa
Cinque corse continue 01/01/2025-01/10/2026, XAUUSD, 80.000, leva 1:100, ExecutionMode 0, input imposti e verificati nel report (nessun altro input imposto):
| passata | timeframe | modello | imposto | Quale domanda |
|---|---|---|---|---|
| T1 | H1 | ticks reali | `InpRiskLevel=1` | il livello 1 e' piu' rischioso di 0? |
| T2 | H1 | ticks reali | `InpRiskLevel=2` | idem livello 2 |
| T3 | M30 | ticks reali | `InpRiskLevel=0`, protezione giornaliera spenta | il timeframe (M30 consigliato) cambia il risultato? |
| T4 | M30 | ticks reali | come T3 + `InpCloseTradesOnEquityDrawdown=true`, `InpMaxEquityDrawdown=4.0` | la protezione giornaliera cosa fa? |
| T5 | M30 | **OHLC a 1 minuto** | come T3 | il modello consigliato dal venditore cambia il risultato? |
**Non so cosa significhino i valori numerici di `InpRiskLevel`** (il venditore parla di Basso/Medio/Alto: 0/1/2 e' l'ipotesi piu' naturale [NON VERIFICATO]); lo si legge da lotti e DD. Non si cambia `InpRiskType` e `InpBaseMoneyMode` (non so cosa siano): si registrano i loro valori.
## Soglie (invariate)
S-N, S-M, S-H, S-DD (perdita dal deposito <= 10%; DD dal picco <= 15,2%), S-COSTO, S-NOSCALA, S-PORT (con Gold Reaper: tetto <= 10% degli 80.000). **DD sempre anche come % degli 80.000 iniziali.** Non si sceglie la passata piu' redditizia: la domanda e' se esiste una configurazione prudente che passa S-DD e S-PORT.
## Previsioni dichiarate ORA
- **PF1**: tutti gli input imposti applicati in tutte e cinque (nessun "INPUT NON APPLICATI"). Fiducia 80%.
- **PF2** (ordine dei livelli): lotto mediano T2 >= T1 > riferimento (livello 0); DD in % degli 80.000: T2 > T1 > 13,8%. Fiducia 60%.
- **PF3** (timeframe): T3 ha operazioni entro +/-10% di 673 e netto entro +/-25% di +34.130 (il venditore dice "nessun timeframe fisso"). Fiducia 55%.
- **PF4** (protezione giornaliera): T4 ha un DD (in % degli 80.000) inferiore a T3 e un netto non inferiore al 70% di T3; operazioni diverse da T3 (la protezione interviene almeno una volta). Fiducia 60%.
- **PF5** (modello): T5 con netto entro +/-30% di T3 e operazioni entro +/-10%. Se T5 supera T3 di oltre il 30%, i numeri del venditore (OHLC 1 minuto) sono gonfiati rispetto ai ticks reali. Fiducia 55% che stia entro la banda.
- **PF6**: nessuna delle cinque ha un DD dal deposito maggiore di 15% degli 80.000. Fiducia 70%.
- **PF7** (durata): ogni corsa meno di 30 minuti (il riferimento a 5.000 e' durato 151 s). Fiducia 80%.
Se T3 o T4 portano il DD in % degli 80.000 sotto circa 6%, si rifa' il calcolo S-PORT con il Gold Reaper (scritto dopo).
