# Stadio 1 dell'ottimizzatore, versione onesta: effetto isolato di "pip fissi -> ATR" sull'oro (19/11/2026) — criteri scritti PRIMA dei numeri
**Scoperta che cambia lo stadio 1:** dei 4 EA oro "Ottimizzati" tre usano gia' distanze in ATR (SupertrendReversal_Multi, EMA200, GoldenCross: stop e pendenti in ATR/swing). L'unico con distanze in pip fissi e' **SupertrendReversal_Ottimizzato**, e **il suo gemello `_Multi` e' identico riga per riga tranne**: pendente 20 pip -> 0,5 ATR, buffer stop 3 pip -> 0,2 ATR, ATR del Supertrend 7 -> 12, TP 2,5R -> 3,0R, magic e commento (diff: 28 righe, tutte queste). Quindi non serve scrivere codice nuovo: l'esperimento controllato esiste gia'. Nota: sull'oro BCM (2 decimali) 1 pip = 0,01 USD, cioe' **20 pip = 0,20 USD e 3 pip = 0,03 USD**: nell'EA a pip fissi il pendente e il buffer sono quasi nulli; la versione ATR li mette a circa 7 e 3 USD (H4).
## Quattro varianti (XAUUSD H4, Modello 1, 100.000 EUR, rischio 2% degli EA, tutto il resto = default)
1. **PIPS**: `ABTG_SupertrendReversal_Ottimizzato`, default (Supertrend ATR 7, mult 2,5, RR 2,5, pendente 20 pip, buffer 3 pip).
2. **ATR_EQ**: `_Multi` con Supertrend ATR 7, RR 2,5 e distanze ATR scelte per **equivalere a PIPS a un ATR H4 tipico (circa 15 USD)**: pendente 0,013 ATR (circa 0,20 USD), buffer 0,002 ATR (circa 0,03 USD). Isola solo la **scala** (stesso comportamento, ma proporzionale all'ATR).
3. **ATR_DEF**: `_Multi` con Supertrend ATR 7, RR 2,5 e distanze ATR di default (0,5 / 0,2). Isola il **cambio di valori** (pendente e buffer reali).
4. **MULTI_DEF**: `_Multi` con tutti i suoi default (ATR 12, RR 3,0): riferimento.
Finestre mai usate per ottimizzare questi parametri: **2015-2023** e **2005-2014** (quelle gia' misurate dal controllo del 19/11: MULTI_DEF e PIPS devono riprodurre i numeri di allora: Multi 2015-23 PF 1,10 / 7 anni su 9; PIPS 0,91 / 4 su 9; 2005-14: 0,72 / 3 su 10 e 0,85 / 2 su 10).
## Porte e previsioni
- **Controllo di riproducibilita':** MULTI_DEF e PIPS riproducono i PF di allora entro 0,03; altrimenti il confronto non vale.
- **La scala ATR "aiuta"** se ATR_EQ batte PIPS in ENTRAMBE le finestre (PF su rendimenti +0,05 o piu', senza ridurre gli anni positivi). **Il cambio di valori aiuta** se ATR_DEF batte ATR_EQ allo stesso modo.
- Previsioni: ATR_EQ ~ PIPS (differenza < 0,05 in PF su tutte e due le finestre): **70%** (a 0,013 ATR il pendente e' quasi a mercato: la scala conta poco). ATR_DEF migliore di PIPS in entrambe le finestre: **30%**. Almeno una variante con PF su rendimenti > 1,3 in entrambe le finestre: **5%**.
## Limiti
Un solo EA, un solo mercato, una sola famiglia (Supertrend): non e' una prova generale dell'ipotesi "scala ATR". Non dice nulla sugli orari (stadio 1b: DAX/Nasdaq, dati indici da verificare). Il 2024-2026 non si usa (periodo di ottimizzazione).

## RISULTATI (zip `STADIO1_ATR.zip`, tester BCM, XAUUSD H4, Modello 1; dati in `STADIO1_ATR_dati/`)
| Variante | 2015-2023: op. / PF / DD / anni positivi | 2005-2014: op. / PF / DD / anni positivi |
|---|---|---|
| PIPS (SupertrendReversal, pip fissi) | 267 / 0,91 / 9,8% / 4 su 9 | 265 / 0,85 / 11,1% / 2 su 10 |
| ATR_EQ (ATR equivalente ai pip) | 267 / 0,90 / 9,8% / 4 su 9 | 265 / 0,85 / 11,2% / 2 su 10 |
| ATR_DEF (distanze ATR 0,5 / 0,2) | 379 / **1,00** / 20,0% / 4 su 9 | 353 / **1,02** / 13,0% / 4 su 10 |
| MULTI_DEF (Supertrend ATR 12, RR 3,0) | 406 / 1,10 / 21,9% / 7 su 9 | 342 / 0,72 / 27,9% / 3 su 10 |
- **Riproducibilita' (porta):** PIPS e MULTI_DEF riproducono esattamente i PF del controllo precedente (0,91 / 0,85 e 1,10 / 0,72): il confronto vale.
- **La scala non conta:** ATR_EQ ≈ PIPS (stessi trade, PF 0,90 contro 0,91 e 0,85 contro 0,85): previsione 70% -> **si'**. Con distanze quasi nulle (0,20 e 0,03 USD) scalarle con l'ATR non cambia nulla.
- **Cambiare i valori aiuta un poco:** ATR_DEF batte PIPS in entrambe le finestre (+0,09 e +0,17 di PF; piu' operazioni, piu' anni positivi nel 2005-14): previsione 30% -> **si'**. Ma il PF resta ~1,0 (pareggio, non edge) e il DD 2015-23 e' 20%.
- **Sensibilita' ai parametri:** ATR_DEF e MULTI_DEF differiscono solo per Supertrend ATR 7 -> 12 e RR 2,5 -> 3,0: PF 1,00 -> 1,10 nel 2015-23 e 1,02 -> 0,72 nel 2005-14. Nessun plateau: il risultato oscilla di 0,3-0,4 PF con due parametri.
- Nessuna variante ha PF > 1,3 in entrambe le finestre (previsione 5%): confermato.
**Verdetto stadio 1:** l'ipotesi "i pip fissi fanno perdere, l'ATR sistema" **non e' confermata**. Normalizzare per ATR non crea vantaggio; la differenza vera e' nei valori del pendente e del buffer, e porta da una perdita a un pareggio. Il Supertrend sull'oro H4 resta senza edge stabile (la "scoperta" del PF 3,17 era sul 2024-26 su cui era ottimizzato).
