# GBA R2S STADIO B (simboli gemelli a TICK REALI, 3 tranche): lettura dello zip (14/10/2026)

Fonte: `GBA_R2S_B.zip` (SHA256 `56b6176a5ab6f967…`), riga `4ac08402…` al pin `d53493a9`, PC di backtest `DESKTOP-H4D7CAJ`, 07:35-07:44 (**9 minuti** contro i 285 di cautela), quattro lotti tutti **rc 0**, 10 passate tutte OK, qualita' dello storico **100% tick reali** (Modello 4). Letto con D2-B (`leggi_gba_r2sb_c3g.py`, SHA `cc5e3c6b…`, PASS dei due strati del 12/10) e con `leggi_gba_r0.py` (`9cd02d2a…`): **G0 OK su tutte le passate**; **A3** (la stessa misura caricata due volte, ancora R2SBANC contro R1A_01) risponde come deve (rifiuta). Archivio: `backtest_pipeline/risultati_archivio/GBA_R2S_B_20261014/`. Nessun candidato archiviato.

## 1. L'ancora: la catena di misura regge al centesimo
`R2SBANC` (XAUUSD M1, T1, tick reali) = **128 operazioni, -6.577,48, PF 0,83, 25.648.545 tick, 88.416 barre**: **identica a R1A_01 del 10/10** (CE1 verde, `.ini` identico salvo il nome del report, C3G 21,60, righe >= 40x 651). Quindi driver, terminale e storico a tick di oggi riproducono la misura di tre giorni fa: i numeri degli indici qui sotto sono confrontabili con tutto quello che e' stato misurato.

## 2. Costo a tick reali: le tre celle degli indici PASSANO in tutte e tre le tranche (esito (P) di D2-B)
| cella (M15) | tranche | n ingressi | righe segnale | **C3G** (mediana stop/spread) | >= 40x | atteso [INFERITO] | PF report (1 lotto, DESCRITTIVO) |
|---|---|---:|---:|---:|---:|---|---:|
| **NASUSD** | T1 2026.07-09 | 129 | 488 | **59,10** | 391 | 48,75-52,87: **fuori in alto** | 0,62 |
| | T2 2026.04-06 | 130 | 499 | **59,20** | 383 | non stimato | 0,81 |
| | T3 2026.01-03 | 85 | 423 | **51,90** | 259 | non stimato | 0,65 |
| **D30EUR** | T1 | 84 | 418 | **44,20** | 233 | 39,77-44,37: **dentro** (cella a rischio) | 0,58 |
| | T2 | 91 | 403 | **54,60** | 268 | non stimato | 0,88 |
| | T3 | 73 | 385 | **48,70** | 248 | non stimato | 0,93 |
| **U30USD** | T1 | 96 | 460 | **47,50** | -- | 45,25-50,61: **dentro** | 0,71 |
| | T2 | 126 | 448 | **59,60** | -- | non stimato | 0,71 |
| | T3 | 116 | 400 | **73,80** | -- | non stimato | 0,75 |
- **«PASSA lo stadio B (COSTO)» significa SOLO che a tick reali il costo e' alla frontiera di casa (`stop >= 40 x spread`) in ognuna delle tre tranche**, non che il motore guadagni. **La casella 4 del certificato (simboli gemelli) si chiude con i numeri accanto** per Nasdaq, DAX e Dow a M15.
- **DAX T1 e' il caso al limite**: 44,2x contro la frontiera 40x, con la fascia asia a 17,5x e USA pomeriggio a 26,4x (le fasce di T3 non si confrontano con T1/T2 per il cambio d'ora). **Il resto passa con margine** (Nasdaq 52-59, Dow 47-74).
- Atteso scritto prima: **Nasdaq T1 sopra la banda** (59,1 contro 48,75-52,87): smentisce la **stima per sensibilita'**, non l'esito. Le altre due T1 cadono dentro.
- Il tester a tick reali **non addebita commissioni sugli indici** (0,00, come atteso): il costo letto e' solo lo spread.

## 3. Il merito: NON MISURATO (e il PF e' sotto 1 in tutte e nove le passate: va scritto)
- **Per regola** (piano 5.3, emendamento D, classe 1384): le tre tranche del 2026 sono **un solo regime**, quindi il **merito e' non misurabile**, qualunque sia il PF; una tranche non e' un regime.
- **Descrittivo, non merito** [MISURATO]: il PF del report a 1 lotto e' **0,58-0,93 su tutte e nove le passate** (Nasdaq 0,62/0,81/0,65; DAX 0,58/0,88/0,93; Dow 0,71/0,71/0,75); ingressi tentati 73-130 per passata; perdita a SL mediana 101-195 EUR a 1 lotto (non confrontabile con l'oro). Il costo non e' il collo di bottiglia: **il motore GBA cosi' com'e' non mostra PF >= 1 su nessun indice in nessuna delle tre tranche del 2026**. Non e' una bocciatura (un regime, 1 lotto, nessuna gestione dell'uscita messa ad asse in questo lotto), ma **non e' neppure un segnale a favore**.
- **Certificato di morte (5 caselle)**: (1) PF misurato: SI, a 1 regime; (2) n e DD: SI per cella; (3) gestione dell'uscita ad asse: **NO in questo lotto**; (4) simboli gemelli: **SI, chiusa col numero**; (5) TF cambiato: la cella e' M15 sugli indici, **M5 non provato** (il piano le tiene per «capire»). Quindi **NON e' «morto»: «NON ANCORA MISURATO»** (mancano uscita e TF), con i numeri sopra.

## 4. Cosa significa per la frontiera dei costi e per gli indici
- La **frontiera `stop >= 40 x spread` a tick reali e' rispettata** sui tre indici a M15, con margine eccetto DAX T1. E' un'ottima notizia per il **perimetro** (i motori a M15 possono vivere sugli indici BCM) ma **non per il GBA in se'**.
- Da questo lotto non esce nessuna sedia: serve un meccanismo con PF >= 1 a tick reali su **piu' regimi** e le caselle 3 e 5.

## 5. Cosa si misura adesso (una cosa per volta, un giro GBA alla volta)
1. **Conferma a tick reali dell'argento (XAGT)** [riga gia' con Claudio] e rifare le celle M30/H1 dell'argento da sole.
2. **Gestione dell'uscita ad asse** sul GBA a M15 degli indici (casella 3): un giro «R2 USCITA» e' nominato nelle righe di lancio, ma il suo stato [NON VERIFICATO: va letto nel registro dei test] e va ripreso col cancello.
3. **Piu' regimi**: lo storico indici parte dal 2024.09.26 (un anno e mezzo): servono i regimi dichiarati (toro / orso / laterale) e n >= 150 per regime; il 2026 da solo non basta.
