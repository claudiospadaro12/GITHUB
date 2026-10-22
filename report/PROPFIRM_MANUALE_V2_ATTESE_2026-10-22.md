# Prop Firm Gold EA v2.5, test secondo il MANUALE del venditore: attese scritte PRIMA dei numeri (22/10/2026)

**Non controllata da agenti.** Fonte delle regole: manuale (blog 765213) e FAQ (blog 765211) del venditore, letti da screenshot di Claudio il 22/10. Schermata degli input v2.5 (stessa data): `Risk Calculation Base`=Use Starting Balance (valore 0), `Risk Type`=Automatic Risk (0), `Risk Level (Automatic)`=Low (0), `Risk % (Manual)` e `Lots (Fixed)` a 0, `Enable Daily Drawdown Protection`=false, `Max Daily Loss %`=4.0.

## Cosa cambia rispetto ai test fatti finora
1. Il manuale dice: **lotto fisso NON consigliato** (l'EA adatta lotto e stop alla volatilita); si usa il **rischio manuale in %** (= rischio massimo PER OPERAZIONE, fino a 3 operazioni al giorno: 1% -> circa 3% di perdita giornaliera nel caso peggiore, 0,5% -> circa 1,5%). La checklist del 20/10 che chiedeva "un set a lotto fisso" e superata.
2. **OHLC a 1 minuto, mai tick reali** (l'EA lavora sulle aperture delle candele M1); **rischio sul saldo iniziale fisso**; **periodo lungo dal 2018**; timeframe consigliato M30 (ma "funziona in qualsiasi arco temporale").
3. **Protezione giornaliera** (chiude TUTTE le posizioni del conto): "solo per prop firm", al 4% se la prop da 5%.
4. **Il server consigliato e GMT+2/+3: BCM e GMT+1 fisso. Questo test misura "come va su BCM", NON il comportamento sul server giusto.**

## Cosa si fa
XAUUSD, **M30, modello 1 (OHLC a 1 minuto), deposito 80.000, leva 1:100**, Use Starting Balance (default, non imposto), 12 passate singole (conto vuoto ognuna):
| celle (stesse in due finestre) | InpRiskType | InpRiskLevel | InpRiskPercent | protezione giornaliera |
|---|---|---|---|---|
| c1 riferimento | 0 Automatic | 0 Low | 0 | spenta |
| c2 | 0 | 0 | 0 | **accesa 4,0** |
| c3 | **1 Manual** [IPOTESI: ordine del menu, da confermare] | - | **0,5** | spenta |
| c4 | 1 | - | 0,5 | accesa 4,0 |
| c5 | 1 | - | **1,0** | spenta |
| c6 | 1 | - | 1,0 | accesa 4,0 |
Finestre: **W1 = 2025.01.01 -> 2026.10.01** (T1-T6), **W2 = 2018.01.01 -> 2026.10.01** (T7-T12). I valori 0,5% e 1% sono gli esempi del manuale, non una scelta di taglia.
Riferimento storico (H1, tick reali, default Low, spento): +34.130 / PF 1,25 / 673 operazioni / DD equity 11.023 = 13,8% degli 80.000.

## Soglie (invariate)
S-N >= 150 operazioni, S-M >= 60% mesi positivi, S-H entrambe le meta positive, **S-DD <= 10% dal deposito e <= 15,2% dal picco**, S-NOSCALA (rapporto lotti <= 3, <= 10 posizioni), S-COSTO. **DD sempre anche in % degli 80.000.** Una cella "TIENE" solo se passa S-N, S-M, S-H, S-DD e S-NOSCALA in ENTRAMBE le finestre.

## Previsioni dichiarate ORA
- **E1**: tutti gli input imposti risultano applicati nel report (nessun "INPUT NON APPLICATI"): 75%.
- **E2 (mappa del menu)**: nelle celle c3-c6 il rischio e manuale davvero: i lotti cambiano rispetto a c1 e la perdita di un'operazione che prende lo stop sta fra 0,3% e 0,8% di 80.000 (c3/c4) e fra 0,6% e 1,6% (c5/c6): 65%. Se i lotti sono 0,01 fissi o non ci sono operazioni, la mappa "1 = Manual" e SBAGLIATA e la passata non si legge.
- **E3 (scala col rischio)**: DD in % di 80.000 di c5 fra 1,5 e 2,5 volte quello di c3 (a protezione spenta): 55%.
- **E4 (protezione)**: in almeno 2 coppie su 3 la protezione ACCESA abbassa il DD in % di 80.000 e lascia un netto >= 70% di quello spento: 50%.
- **E5 (riferimento OHLC/M30)**: c1 in W1 ha netto entro +/-25% di +34.130 e DD entro 9,5%-18%: 50%.
- **E6 (cicli vecchi)**: in W2 almeno una delle sei celle ha PF < 1,2 o DD > 10% di 80.000: 70% (nei test RG4 su 2018-20 il Prop Firm aveva PF 0,97-1,01 e DD 11-15%).
- **E7**: almeno UNA cella "TIENE" (vedi sopra): **35%**.
- **E8 (durata)**: ogni W1 meno di 15 minuti, ogni W2 meno di 60 minuti: 70%.

## Cosa NON dice
Non e il server GMT+2/+3 del venditore; un solo EA (non il portafoglio con Gold Reaper e Goldbot One: se la protezione scatta chiude anche loro); nessuna taglia e nessun consiglio di acquisto.
