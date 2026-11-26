# Gold_Ichimoku_TK_ATR_EA (A1) - scheda
Sorgente: `materiali_ea/Gold_Ichimoku_TK_ATR_EA.mq5` (722 righe, v3.00). FV = FATTO_VERIFICATO, INF = INFERENZA, DV = DA_VERIFICARE.

## Misure esistenti (FV)
Nessuna. `grep` su report/ e tradingview/: solo menzioni nella matrice del 26/11; la sigla `IchiTrend_Gold_Base` (A7, "nessun numero") e' un altro EA. L'intestazione dichiara "configurazione VALIDATA" (r.21-23) e "replica FEDELE" della Pine v3: DV, nessuna evidenza nel repo (INFORMAZIONE_DEL_COMMITTENTE).

## Regole (FV)
- H1 su oro, barra chiusa: Tenkan = Donchian 7, Kijun = Donchian 22, Senkou B = Donchian 44, nuvola non spostata (r.9-15, 236-262; shift 1).
- Segnale = incrocio Tenkan/Kijun (r.366-367); default solo LONG, filtro Kumo ON (close sopra la nuvola, r.83, 92, 432-441); ADX/espansione BB/Kijun spenti (r.84-88).
- Ingresso a mercato al primo tick della barra nuova (r.206-211, 465-467); SL = 1,5 x ATR(14) sempre (r.98, 460, 469); nessun TP in EXIT_CROSS (r.96, 471-474).
- Uscita su incrocio opposto a barra chiusa (r.382-394); trailing solo in EXIT_ATRTRAIL (r.596). Rischio 0,5% del saldo (r.105, 534-568). Una posizione (r.670-675).

## Controlli R2
| Controllo | Esito |
|---|---|
| Barra in formazione per decidere | NO (iClose/Donchian/ATR su shift 1: r.363, 238-243, 270). Barra 0 solo nel trailing ATR (r.606, 623), spento di default |
| Orari / ora legale | NO: nessun filtro orario ne' input di ora; non esposto al DST (BCM GMT+1 fisso irrilevante) |
| Distanze in punti fissi | Spread massimo in POINT, spento (r.110, 680-686): SI ma non attivo. Il resto in ATR |
| Nuova barra | SI (r.217-226); alla prima chiamata e' true: all'aggancio valuta l'ultima barra chiusa e puo' entrare in ritardo (INF, minore) |
| Stop minimo del broker | NO: SL non confrontato con stops/freeze level (r.460-494); un rifiuto = segnale perso senza retry (r.496-501) |
| Spread | solo filtro opzionale in punti (r.454, 680-686) |
| Ordine rifiutato | log del retcode, nessun retry |
| Magic/commento | 250604; "TK long/short" (r.109, 490) |
| Dati futuri | NO |

## Difetti
1. Blocca il forward (alta): `HasOpenPosition` usa `PositionSelect(_Symbol)` (r.672) e poi confronta il magic (r.674). Con conto HEDGING e un altro EA sull'oro (GoldenZoe, Goldbot...) la posizione selezionata puo' essere quella dell'altro: l'EA non vede la propria, ne apre una seconda o non gestisce l'uscita. In tester a EA singolo non conta. Correggere con ciclo su magic.
2. Minore/falsa i test: lotto con `SYMBOL_TRADE_TICK_VALUE` (r.539, bug noto CFD non convertiti, CLAUDE.md) e `MathMax(minLot)` (r.559) che puo' superare lo 0,5%; nessuna deviazione impostata (solo magic, r.154); filling fissato una volta (r.155, 183-192).
3. Minore: nessun controllo del TF: il default e' tarato su H1 ma gira su qualunque grafico (r.157-160), con ATR e Donchian sul TF del grafico.
4. Minore: la guardia B1/C1 e' fail-open nel tester (r.31-42): test e live non confrontabili sul punto.
5. Gap e week-end: SL a 1,5 ATR e uscita solo a chiusura di barra; nessuna protezione dai gap di lunedi' (INF).

## Misurabilita'
XAUUSD H1 da M1 BCM 2004-2026: Modello 1 sufficiente (EA a barre chiuse, SL ATR largo); tick non necessari. Stima frequenza: INF, decine di operazioni/anno long-only con Kumo, circa 500-1.500 in 20 anni, da confermare. Costo swap long BCM sull'oro (-9,7% annuo, CLAUDE.md) pesa perche' l'uscita su incrocio tiene giorni: misurare lordo e netto. Correlazione col GoldenZoe (oro long) da calcolare: soglia |rho| <= 0,5 (CLAUDE.md).

## Ipotesi (criteri scritti prima; stesse porte P1-P5 della Famiglia 1 per confrontabilita')
- H1: default, 2015-23 (primaria): PF >= 1,20, rendimento > 0, >= 100 operazioni; 2005-14 PF >= 1,0; 2024-26 hold-out chiuso fino alla fine. Probabilita' 22%; "REGGE" completo (t >= 2,7) 5%.
- H2: quota swap > 25% del lordo sulle operazioni oltre 3 giorni. 55%. E' diagnostica: se vera, il netto va riportato sempre.
- H3: H4 invece di H1 (cella dichiarata, nessun altro input): PF >= 1,20 in 2 finestre su 3. 15%.

## Classe: A (priorita' bassa)
Misurabile subito in tester (nessun difetto falsa i test); il difetto 1 va corretto prima di qualunque forward. Famiglia gia' affollata: trend oro (Supertrend, Donchian D1, GoldenZoe) senza vantaggio stabile misurato, correlazione probabilmente alta.
