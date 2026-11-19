# Test dei filtri di Leonardo su BreakingBand v4 - criteri PRIMA dei numeri (19/11/2026)

**Domanda:** i filtri nuovi spiegati da Leonardo nelle due video lezioni (**mattina** e **notizie**) migliorano `BreakingBand_MT5_v4` (EA di Massimo, invariato, parametri di default), oppure la strategia resta senza vantaggio come nelle prove della sala (oro 01/11: inconcludente; forex H1 anni nuovi: win rate 73,5% contro pareggio 75,9%, R +0,006) e della replica BCM (11-13 operazioni per simbolo)?
**Dati e prove:** tester BCM portabile, Modello 1, H1 **e M30** (Leonardo: "H1, H4 e M30 cosi com'e"; H4 gia peggiore), **28 cross** (tutti i maggiori e minori forex), **2013-01-01 -> 2024-12-31**; 2025-26 **NON si usa** (hold-out). Una passata per simbolo e timeframe (56). Si analizzano le operazioni una per una (report del tester) con il calendario storico MT5 di 8 valute (`abtg_news_hist_G8.csv`, orari del server BCM GMT+1). I filtri si applicano **dopo**, escludendo operazioni dall'elenco (equivale a un filtro dell'EA, perche con 2-3 operazioni l'anno per simbolo non si sovrappongono).
**IS 2013-2020 / OOS 2021-2024:** per data di ingresso.

## Filtri (soli 2, fissati ora; nessun altro, nessun parametro scelto dopo)
- **F_MATTINA:** ingresso tra le **07:00 e le 09:59 ora italiana** (server BCM = ora italiana in inverno, un'ora indietro in estate: conversione con la regola europea dell'ora legale).
- **F_NOTIZIE:** l'operazione NON e "esposta": **nessuna notizia di impatto alto** su una delle due valute del cross cade tra l'apertura e la chiusura dell'operazione. Variante F_NOTIZIE_2H (esposta anche se la notizia cade nelle 2 ore prima dell'ingresso).
- **F_MATT+NOT:** entrambi.

## Previsioni (prima dei numeri)
- Operazioni totali (28 cross x 12 anni x H1): 500-1.300; con M30 il doppio circa: **70%**.
- Baseline (nessun filtro) H1: R medio tra -0,05 e +0,05 e win rate 70-77%: **75%**.
- F_MATTINA migliora la media R di >= 0,05 rispetto alle operazioni escluse: **25%**. F_NOTIZIE: **30%**. Entrambi insieme "candidato": **10%**.
- Su M30 lo stesso esito che su H1 (stesso segno del miglioramento): **55%**.

## Regole di esito (invariate dopo i numeri)
1. Un filtro e **SOSTENUTO** se, nel pooled H1 e nel pooled M30 separatamente: media R delle operazioni TENUTE > media R delle ESCLUSE, **in IS e in OOS**, con almeno 30 operazioni tenute per finestra.
2. Il filtro e **CANDIDATO** solo se, in aggiunta: IC90 inferiore della media R delle tenute (pooled IS+OOS) > 0, win rate delle tenute >= pareggio + 5 punti, e il risultato regge togliendo un anno o un cross alla volta (leave-one-out: mai negativo).
3. Nessun candidato = **chiuso**: Breaking Band non ha un vantaggio dimostrato nemmeno con i filtri di Leonardo; il filone e archiviato.
4. Si riportano sempre: operazioni, win rate, pareggio atteso, R medio con IC90, per baseline e filtri, H1 e M30, IS e OOS. Con 28 cross, i cross vicini all'euro non sono indipendenti: lo si scrive.
5. Nessun consiglio di taglie. Il rischio per operazione e quello di default dell'EA (0,5%).
