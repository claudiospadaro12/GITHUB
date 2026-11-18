# Revisione Gemini del quadro unico e verifica sui numeri (18/11/2026)
Natura: parere esterno (non verificato da me alla fonte) confrontato con i dati del repository. Nessun giudizio su lotti, taglie, prop o acquisti.

| Obiezione di Gemini | Verdetto | Motivo |
|---|---|---|
| (a) Stability "TESTATO BENE" ma flottante e 80k non misurati | **Fondata, gia dichiarata** | il limite e nel cancello del 09/11; il verdetto vale per la definizione scritta, non per i limiti giornalieri prop |
| (a) Stessa famiglia/motore WSC = diversificazione non provata; rischio FTMO "stessa strategia" | **Fondata, gia dichiarata** | la parte "violazione copy trading/hedging" e speculazione: regole FTMO non verificate |
| (a) 64 vicini 64/64 = filtro non selettivo | **Fondata, gia dichiarata** | e la nostra stessa lettura (plateau) |
| (b) Luna -83% a tick e DTP 2025 = sovra-adattamento a M1 | **Parzialmente fondata** | M1 e ottimista per Luna (vero); non e "sovra-adattamento dei parametri" ma limite del modello di prezzo; per DTP il 2025 era gia il peggior anno anche a barre |
| (b) Reaper/Phantom 2013 fragili = modellati su regimi successivi | **Non supportata** | 2005-2012 fuori campione positivo per Goldbot/GTP/Reaper/Phantom; il 2013 e rumore (Randomization 50) |
| (b) Famiglie chiuse testate solo su 2015-2017 | **Fondata nella forma, non nella sostanza** | selezione 2015-2017 era scritta prima; per Gemini ho rifatto, SOLO descrittivo e senza ripescare nulla, i set sul periodo seguente: Nasdaq M1 2018-24: 0/12 in profitto, PF 0,88-0,97, t max -0,47; Nasdaq M3: 3/8 in profitto, PF 0,93-1,06, t max +0,90; breakout D1 Nasdaq: 4/8, PF 0,89-1,24, t max +1,17; fade oro 2018-20: 11/24, PF 0,78-2,45 (n minimo 24), t max +1,68. **Nessun set e significativo** (t < 2); "chiuso" va letto "nessun candidato con le regole scritte", non "logica impossibile" |
| (b) Indicement/ORB "puro in-sample" | **Non supportata** | per noi nessuna ottimizzazione su quel periodo; il limite vero e un solo periodo (nessuna validazione incrociata) |
| (c) Flottante a tick su tutto il periodo | **Fondata, in parte non fattibile** | tick BCM solo dal 10/07/2024; fattibile solo il flottante da equity del tester dove disponibile |
| (c) Vincoli FTMO (leva, lotti, 2.000 richieste) | **Fondata, bloccata** | regole non verificate (mail pronta, non inviata): non si simulano regole ignote |
| (c) Sensibilita fuso orario Luna +-1 h (degradazione > 15% = inaffidabile) | **Fondata, nuova, proponibile** | e il giro C del cancello rimasto "limite dichiarato"; criterio scritto ex ante qui sopra |
| (d) Code di perdita comuni DTP/oro | **Fondata, gia nel quadro** | 24-31 giorni osservati contro 14-16 attesi |
| (d) Apex: "elevatissima probabilita di margin call" | **Esagerata** | Conservative/Ultra: 0 stop out in tutte le passate; vero invece che DD 27-33% e giorni a -23% sono incompatibili con limiti prop stretti: e un dato, non una probabilita |
| (d) Rischio motore WSC comune | **Fondata, non misurabile da fuori** | l'.ex5 e chiuso |

**Misure nuove proponibili (decide Claudio):** (1) Luna con GMT_Offset +-1 h su 3 anni (MT5, poche passate, criterio sopra); (2) stima della dipendenza di coda DTP-oro sulle serie giornaliere gia presenti (Python, nessun file nuovo); (3) invio della mail a FTMO sulle regole (e di Claudio, fuori dal tester).
