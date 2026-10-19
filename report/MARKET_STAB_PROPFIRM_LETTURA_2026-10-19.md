# Prop Firm Gold EA -- ripetizioni della corsa continua (S-STAB): lettura (19/10/2026)

Regole e previsioni scritte PRIMA dei numeri in `report/MARKET_STAB_PROPFIRM_ATTESE_2026-10-19.md`. Qui le soglie sono applicate alla lettera, sul PEGGIORE delle 4 corse (corsa del test a fondo + 3 nuove). Dati: `backtest_pipeline/risultati_archivio/STAB_PROPFIRM_20261019/`, calcolo `backtest_pipeline/analizza_stab_propfirm.py` (uscita in `LETTURA_MECCANICA.txt`).

## Controllo input (obbligatorio)
Le 4 corse hanno **le stesse 24 righe di input** (confronto riga per riga dei report): rischio 0, lotti 0.0, nessun filtro spread, nessuna chiusura per drawdown, modalita' tester Prop Firm spenta. Stessa finestra 01/01/2025 - 01/10/2026, XAUUSD H1, 5.000 EUR, 100% ticks reali, 673 operazioni in tutte e 4.

## Numeri (le 4 corse)
| corsa | netto EUR | PF | mesi positivi | gen25-mag26 | giu-set26 | DD equity dal picco | lotti | pos. contemp. |
|---|---|---|---|---|---|---|---|---|
| fondo | 1.590,96 | 1,26 | 14/21 (66,7%) | +1.148 | +443 | 7,80% | 0,01 | 3 |
| run1 | 1.621,88 | 1,27 | 14/21 (66,7%) | +1.128 | +494 | 8,09% | 0,01 | 3 |
| run2 | 1.655,14 | 1,27 | 15/21 (71,4%) | +1.223 | +432 | 7,56% | 0,01-0,02 | 3 |
| run3 | 1.530,66 | 1,25 | 13/21 (61,9%) | +1.090 | +441 | 8,03% | 0,01-0,02 | 3 |

Il saldo non scende mai sotto i 5.000 EUR di partenza in nessuna corsa (perdita massima dal deposito: 0%).

## Soglie sul peggiore delle 4 corse
- **S-N** (>= 150 operazioni): 673 in tutte -> **passa**.
- **S-M** (netto > 0 e >= 60% dei mesi positivi): peggiore run3 con **61,9%** (13 mesi su 21) -> **passa, ma con un solo mese di margine**: con un mese positivo in meno sarebbe 57,1% e fallirebbe. Lo dico perche' e' il punto piu' stretto di tutta la lettura.
- **S-H** (somma > 0 in gen25-mag26 e in giu-set26): peggiori +1.090 e +432 -> **passa**.
- **S-DD** (perdita dal deposito <= 10% e DD equity <= 15,2%): peggiore **8,09%**, perdita dal deposito 0% -> **passa**.
- **S-NOSCALA** (lotto max/min <= 3, <= 10 posizioni): lotto max/min = 2 (0,02 / 0,01), 3 posizioni -> **passa**.
- **S-COSTO** (media per operazione >= 3 x spread, circa 0,18 EUR): peggiore **2,27 EUR/op** = 12,6 volte -> **passa** (nel tester non c'e' slippage; lo spread usato e' la stima di 20 punti scritta prima).
- **S-STAB**: nessuna delle 4 corse viola nessuna soglia -> **non smentita**.

## Previsioni
- **P6** (non tutte identiche, tutte positive, +500..+2.500): **confermata**. Le 4 corse sono diverse fra loro (da 1.531 a 1.655: scarto 124 EUR, circa 8% sul valore piu' alto) e tutte positive nel range.
- **P7** (PF > 1,10 in ogni corsa): **confermata** (1,25-1,27).
- La randomizzazione nel tester **agisce**, ma poco: lo scheletro e' lo stesso (stesse 673 operazioni, gli stessi mesi in perdita: feb 2025, giu 2025, dic 2025, apr 2026, mag 2026, lug 2026; si spostano solo i mesi di confine vicini a zero: lug 2025, giu 2026).

## Cose che NON so / da dichiarare
- In run2 (3 operazioni) e run3 (1 operazione), tutte a inizio gennaio 2025, il lotto e' **0,02 invece di 0,01**, con input identici. Non conosco il motivo (lotto automatico con rischio 0 e lotti 0.0: la logica non e' leggibile, e' un .ex5 di terzi). Pesa su 4 operazioni su 673 e non cambia nessuna soglia, ma e' una variabilita' nella taglia che il test a fondo (tutto 0,01) non mostrava.
- Le ripetizioni misurano solo la randomizzazione del **tester**, sullo stesso storico di prezzo. Non misurano slippage, requote, spread reali piu' larghi, latenza del VPS.
- Il file `DEEP_PROPFIRMGOLDEA.zip` mandato insieme e' il duplicato della run3 (stesso report, stessa orario di avvio 22:38:40): non aggiunge una quinta corsa.
- Profitto assoluto modesto per costruzione (0,01 lotto): circa +1.600 EUR su 5.000 in 21 mesi, DD fino a circa 8%. Come cambia con una taglia diversa sul conto reale e' una decisione di Claudio, non una mia proposta.

## Verdetto
Il Prop Firm Gold EA **supera S-STAB alla lettera** e conferma l'esito del test a fondo; resta il candidato con la lettura piu' pulita del gruppo A. Il margine piu' sottile e' S-M (61,9% contro 60%).
