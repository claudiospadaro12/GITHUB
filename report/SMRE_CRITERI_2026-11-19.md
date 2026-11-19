# SMRE (TV n.28, Market_Logic_India, Pine v6, indicatore) — audit e criteri scritti PRIMA dei numeri (19/11/2026)
Sorgente: `TV_SCOUT_SMRE_2026-11-19.zip` (1.470 righe; copia del sorgente fatta a mano da Claudio, non confrontata con la pagina). E' un **indicatore multi-strato**, non una strategia: dice di non avere backtest. Strati: L1 nucleo statistico (OU, Hurst, ADF, Variance Ratio), L2 regime di volatilita' (richiede un simbolo VIX), L3 basis spot-futures, L4 opzioni, L5 microstruttura (VWAP, VPIN, volumi), L6 gamma, L7 dispersione, L9 cross-asset. L3, L4, L6, L7, L9 richiedono simboli esterni (nel codice 17 `request.security`, tutte su simboli opzionali, nessun `lookahead`): senza simboli restano **solo L1 e L5**.
## Audit (dal codice)
- **Anti-repainting:** nessun `lookahead`, nessun pivot, nessun `barstate.isrealtime`; i segnali usano la chiusura della barra: a barra chiusa sono stabili. Pulito.
- **Pesi di default (senza VIX):** il moltiplicatore L2 senza VIX vale 0,50 (ramo "else"). Composite = (L1 x 0,28 + L5 x 0,22) x 0,5. Massimo teorico di L1 da solo = 0,28 x 1,5 x 0,5 = **0,21**; di L5 da solo = 0,22 x (1,5 x 1,25 x 1,15) x 0,5 = **0,24**: **entrambi sotto la soglia scalp 0,25**. Quindi **nessuno dei due strati puo' generare un segnale da solo: servono L1 e L5 concordi e forti**. Con un VIX configurato il moltiplicatore sale (fino a 1,25) e i segnali aumentano.
- **Filtro orario di default pensato per la borsa indiana:** sessione 9:15-15:30, salta i primi/ultimi 15 minuti e l'ora 12 (fuso dell'exchange). Su altri mercati va regolato; su H1 consente solo le barre delle 10, 11, 13, 14, 15 del fuso del simbolo. Il fuso esatto dei nostri dati non coincide con quello di TradingView: **approssimazione dichiarata** (ora server dei CSV FTMO).
- **Uscite:** lo script non ha uscite operative; il tracciamento interno considera "vincita" il solo tocco della media OU (tolleranza 0,25 ATR) prima dello stop 1,2 ATR, "scaduta" dopo 15/60/150 barre (scalp/swing/session). **Uscita nostra nel test:** SL 1,2 ATR, TP = massimo tra media OU e ingresso +2 ATR (come `tgtLong/tgtShort` dello script), chiusura a tempo alle 15/60/150 barre; R = distanza stop reale (SL 1,2 ATR). Ingresso all'apertura della barra successiva, una posizione alla volta.
- **Volume:** L5 usa il volume: sui CSV FTMO il tick volume (somma M1). Su Nasdaq/S&P il volume e' 0: L5 non funziona e senza L5 non si genera alcun segnale, quindi test solo su EURUSD e oro.
## Test
Dati EURUSD e XAUUSD H1 2014-11/2020-12 (CSV M1 FTMO, riga 00:00 scartata, volume = somma tickvol). IS = fino al 27/02/2019, OOS dopo. Costi: EURUSD 1,0 pip, oro 0,35 USD. Parametri tutti di default dell'autore (calibrazione automatica H1: finestra OU 24 barre, Hurst < 0,55, ADF < -2,86, VR(4) < 1, vita media <= 60 barre). Nessuna ottimizzazione. **4 varianti scritte ora:** V0 default (moltiplicatore 0,5, filtro orario sull'ora server); V1 moltiplicatore 1,0 (come con VIX in regime stabile), filtro orario attivo; V2 = V0 senza filtro orario; V3 = V1 senza filtro orario.
**Porte (immutate):** IS PF >= 1,5, DD <= 15%, >= 100 operazioni; VALIDATA se OOS PF > 1,2, R medio > 0, >= 30 operazioni.
## Previsioni
- Nessuna variante validata su nessun mercato: **95%**.
- V0: meno di 100 operazioni in tutto il periodo per mercato: **75%**.
- Almeno una variante con >= 100 operazioni IS su un mercato: **60%** (V3 la piu' probabile).
- PF IS < 1,2 in tutte le varianti con >= 100 operazioni: **85%** (stop 1,2 ATR stretto contro un bersaglio >= 2 ATR).
- Tasso di "tocco della media prima dello stop" (definizione dell'autore) > 50% nelle varianti con >= 100 segnali: **55%** (ma R netto <= 0: **80%**).
## Limiti
Solo L1 e L5 testabili; le vere condizioni di segnale dell'autore (VIX, basis, opzioni) non sono riproducibili qui; fuso orario approssimato; H1 su 6 anni; il codice e' stato copiato a mano (esattezza non verificata contro la pagina).

## RISULTATI (`backtest_runner/simulatore/tv_scout8_smre.py`; solo L1 + L5, parametri di default, nessuna ottimizzazione)
| Variante | Mercato | Segnali (scalp/swing/session) | Operazioni | IS n / R / PF | OOS n / R / PF | Esito |
|---|---|---|---|---|---|---|
| V0 moltipl. 0,5, filtro orario | EURUSD | 21 (21/0/0) | 21 | 16 / -0,46 / 0,39 | 5 / -0,26 / 0,59 | < 100: NON VALUTABILE |
| V0 | XAUUSD | 5 | 5 | 4 / +0,93 / 4,36 | 1 / -1,11 / 0 | < 100: NON VALUTABILE |
| V1 moltipl. 1,0, filtro orario | EURUSD | 606 (501/50/55) | 457 | 322 / +0,06 / **1,10** (DD 19%) | 135 / -0,19 / 0,73 | NON VALIDATA |
| V1 | XAUUSD | 505 (408/49/48) | 387 | 273 / -0,09 / 0,87 (DD 40%) | 114 / -0,20 / 0,73 | NON VALIDATA |
| V2 moltipl. 0,5, senza filtro | EURUSD / XAUUSD | 45 / 24 | 43 / 23 | 33 / 15 | 10 / 8 | < 100: NON VALUTABILE |
| V3 moltipl. 1,0, senza filtro | EURUSD | 1.803 (1.533/127/143) | 1.035 | 720 / -0,04 / 0,94 (DD 41%) | 315 / -0,15 / 0,78 | NON VALIDATA |
| V3 | XAUUSD | 1.635 | 951 | 672 / -0,20 / 0,73 (DD 78%) | 279 / -0,09 / 0,86 | NON VALIDATA |
**Con le impostazioni di default (senza VIX) lo script produce pochissimi segnali** (21 e 5 in 6 anni su H1) e, con quelli che produce, perde su EURUSD. **Portando il moltiplicatore a 1,0** (come con un VIX configurato in regime stabile) i segnali diventano centinaia, ma il PF in addestramento e' 1,10 / 0,87 (V1) e 0,94 / 0,73 (V3), e fuori campione 0,73-0,86: **nessun vantaggio**, win rate 31-39% con stop 1,2 ATR e bersaglio >= 2 ATR (R medio < 0 nei casi con molte operazioni).
Previsioni: nessuna validata (95%) → si'; V0 < 100 operazioni (75%) → si' (21 e 5); almeno una variante >= 100 IS (60%) → si' (V1, V3); PF IS < 1,2 in tutte quelle con >= 100 (85%) → si'; "tocco della media prima dello stop" > 50% (55%): **non misurato** (il test usa la nostra uscita con TP >= 2 ATR, non il tocco della media).
**Verdetto: SMRE non validato come generatore di segnali su EURUSD/oro H1 con i soli strati L1+L5. Nessun Pine finale.** Non testati: gli strati che richiedono simboli esterni (VIX, basis, opzioni, gamma, dispersione, cross-asset): il cuore del "multi-layer" dell'autore. Per testarli servirebbero quei dati storici, che non abbiamo, e lo script dichiara di non essere un backtest.
Limiti: port approssimato (fuso orario dei CSV usato come "ora dell'exchange"; VWAP giornaliero azzerato a mezzanotte server; tickvol al posto del volume reale; codice copiato a mano non confrontato con la pagina).
