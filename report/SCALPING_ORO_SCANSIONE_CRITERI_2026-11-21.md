# Scansione scalping sull'oro, quattro famiglie (criteri PRIMA dei numeri, 21/11/2026)

**Richiesta di Claudio:** "con le nostre competenze possiamo creare uno scalping sull'oro?" -> scansione pre-registrata. Script `backtest_runner/simulatore/scalping_oro_scan.py`. **Dati:** oro FTMO M1 2004-06 / 2026-11 (righe 00:00 aggregate scartate; colonne tick-volume e spread), calendario notizie BCM 2013-2026 (`NEWSEXPORT_20261119`, impatto/valuta/titolo). Orari del grafico = ora server FTMO; il calendario BCM (GMT+1 fisso) viene convertito in ora FTMO (EET/EEST) e **l'allineamento e' verificato prima del test** (picco di ampiezza M1 al minuto dell'evento). **Nessun parametro scansionato: una sola scelta per regola.**
## Finestra e costi
Si entra solo con apertura della barra successiva fra le **10:00 e le 21:55 ora server FTMO** (= 09:00-20:55 ora italiana); posizione chiusa a **22:00** al piu'. Una posizione per volta. **Costo a giro = 0,011% del prezzo** (= 0,45 $ a 4.000: spread 0,35 + 0,10 di scivolamento), **x3 per le operazioni sulle notizie** (spread largo). Nessuno swap (tenuta < 1 giorno). Stop prima del target se nella stessa barra M1. R = rendimento netto / distanza dello stop.
## Famiglie (tutte su barre M5, esecuzione su M1)
- **F1 rimbalzo:** z = (close - SMA20) / dev.std. 20 barre; **LONG se z <= -2,5, SHORT se z >= +2,5**; ingresso all'apertura dopo la chiusura del segnale. Stop **2 ATR(14)**; target = SMA20 al momento del segnale; **uscita a tempo dopo 12 barre (60 minuti)**.
- **F2 impulso:** barra con range >= **2,5 x ATR(14) delle barre precedenti** e chiusura nel 25% superiore (LONG) o inferiore (SHORT) del range; ingresso all'apertura dopo; stop **1 ATR**, target **1,5 ATR**, uscita a tempo dopo **6 barre (30 minuti)**.
- **F3 notizie (calendario BCM, eventi USD con impatto High, orari conformi alla finestra):** reazione = close(t0+4 min) - open(t0); si agisce se |reazione| >= 0,5 x ATR(14) M5; ingresso all'apertura del minuto t0+5; stop = target = **1 ATR**; uscita a tempo dopo **30 minuti**. **F3a segue** la reazione, **F3b la contrasta (fade).** Niente doppioni: gli eventi entro 30 minuti da un'operazione aperta si saltano.
- **F4 filtri su F1 e F2** (4 celle): **volume** = tick-volume M5 >= mediana delle ultime 60 barre; **spread** = spread medio M1 della barra <= mediana delle ultime 60 barre.
**8 celle (F1, F2, F3a, F3b, F1+volume, F1+spread, F2+volume, F2+spread) x 3 letture (long, short, long+short) = 24 valutazioni**, contatore looks cumulativo del giorno: 150 + 9 + 12 + 24.
## Periodi e porte
Hold-out dal 01/06/2025; prima: IS = primo 70% del tempo, OOS = ultimo 30%. **Cella-lettura PASSA** se: IS n >= 100, PF >= 1,3, t >= 2; OOS n >= 50, PF > 1,2; hold-out PF > 1,0 se n >= 20 (altrimenti non valutabile); **almeno il 60% degli anni con R totale >= 0**; per "long+short": ciascun lato PF >= 0,9. **CANDIDATO** = una cella passa; resta da confermare nel tester BCM a tick reali (lo scalping vive di tick; M1 non basta). Nessun consiglio di taglie.
## Previsioni (prima dei numeri)
- **Nessuna cella candidata: 88%.** PF IS < 1,0 in almeno 6 delle 8 celle 'long+short': **70%**. I filtri F4 migliorano il PF in almeno 2 dei 4 confronti ma restano sotto 1,0: **55% / 80%**. F3a e F3b entrambi con PF IS < 1,0: **75%**.
- **Limiti dichiarati:** costi costanti in % (ottimistici sul vecchio), nessun tick reale (SL/TP intrabar M1 con stop prima), spread medio di una serie (non quello reale dell'istante), nessuna verifica delle regole prop su scalping/notizie.

## RISULTATI (script `scalping_oro_scan.py`; output `SCALPING_ORO_SCANSIONE_RISULTATI_2026-11-21.txt`; taglio IS/OOS 04/06/2019, hold-out dal 01/06/2025)
**Allineamento calendario/oro verificato:** per 4.661 eventi USD ad alto impatto l'ampiezza media M1 e' 14,6 x 10^-4 al minuto dell'evento contro ~4,6 nei minuti precedenti (picco al minuto 0): la conversione BCM -> ora FTMO e' corretta.
| Cella (long+short) | Operazioni IS | PF IS (t) | PF OOS | PF hold-out | Anni con R >= 0 |
|---|---|---|---|---|---|
| F1 rimbalzo | 16.525 | 0,83 (-10,6) | 0,87 | 0,94 | 9% |
| F1 + volume | 14.620 | 0,84 (-9,7) | 0,88 | 0,91 | 4% |
| F1 + spread | 12.151 | 0,83 (-9,4) | 0,88 | 0,97 | 9% |
| F2 impulso | 9.421 | 0,77 (-12,8) | 0,55 | 0,78 | 0% |
| F2 + volume | 9.035 | 0,76 (-12,9) | 0,55 | 0,79 | 0% |
| F2 + spread | 7.022 | 0,78 (-10,2) | 0,54 | 0,44 | 0% |
| F3a notizie, segue la reazione | 1.386 | 0,39 (-16,0) | 0,45 | 0,49 | 0% |
| F3b notizie, contrasta (fade) | 1.386 | 0,37 (-16,9) | 0,43 | 0,58 | 0% |
- **Nessuna cella supera le porte (0 su 24 letture).** Anche i lati long e short presi da soli sono sotto 1 in IS e OOS; l'unico PF >= 1,0 e' F1 long in hold-out (1,03, ma il lato short 0,84 e l'IS 0,83). **Previsioni:** nessuna candidata (88%): **si'**; PF IS < 1 in almeno 6 delle 8 celle (70%): **si', in tutte e 8**; i filtri migliorano di poco il PF ma restano sotto 1 (55% / 80%): **si'** (F1: +0,01; F2: +0,00-0,01); F3a e F3b entrambi sotto 1 (75%): **si', molto sotto (0,37-0,49)**.
- **Perche':** il costo (0,011% = 0,45 $ a 4.000) e' una frazione grande del movimento a 5 minuti; sulle notizie (costo x3 per l'allargamento dello spread) vale circa mezza R a operazione, e segue e contrasta perdono allo stesso modo: **non c'e' direzione sfruttabile nei 5-35 minuti dopo l'evento a quei costi.** Questi PF sono lordi di nessun tick reale: se il costo reale fosse piu' basso il risultato migliorerebbe, ma restano distanti da 1,3.
- **Nota tecnica:** il primo avvio e' stato rallentato e (nella prima versione) l'uscita forzata alle 22:00 era sbagliata per un confronto di unita' di tempo (microsecondi contro nanosecondi) nelle ricerche; corretto, risultati sopra dalla versione corretta.
- **Limiti:** costi costanti in % (ottimistici sul vecchio), M1 senza tick (stop prima del target), spread dell'istante non usato, regole prop su scalping/notizie non verificate. **Non esclude uno scalping con vantaggio di tipo diverso (microstruttura, tick, orari specifici) ne' una griglia con coda lunga: esclude queste quattro famiglie con regole fisse a questi costi.**
