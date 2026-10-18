# Setaccio degli EA del MQL5 Market scaricati in demo -- regole scritte PRIMA di ogni numero (18/10/2026)

Contesto: Claudio ha scaricato dal Market (demo, girano solo nel tester) altri EA oltre ai quattro del pacchetto di Profalgo (esempi visti nei suoi screenshot: Prop Firm Gold EA, Smart Gold Hunter, Quantum iGold, EA Super Trend XAUUSD, Gold Beaver, Golden Mirage, Ghost Scalper, Range Breakout EA, My AI Gold; l'elenco vero lo legge la riga dalla cartella Market). Ne cerchera' altri. Il setaccio e' UNA domanda sola, ripetuta per ogni EA, con la stessa regola per tutti.

## Cosa misura (e cosa NO)
- Due passate per EA, stessa finestra **2026.01.01 -> 2026.03.01**, XAUUSD, **H1** (passata 1) e **M15** (passata 2), input di default, ticks reali (Modello 4), 5.000 EUR, leva 1:100.
- **Domanda S-A**: l'EA apre operazioni nel tester? **Domanda S-B**: il risultato (numero di operazioni) dipende dal periodo del grafico?
- **NON misura**: se l'EA e' profittevole (due mesi, nessuna conclusione), quale periodo e' "migliore", se comprarlo. Questi tre usi sono VIETATI per i numeri del setaccio.

## Regole (decise ORA)
- **S1 (opera)**: un EA "opera" se in almeno una delle due passate ha **>= 10 operazioni**. Con 1-9 operazioni in entrambe: "opera poco: serve una finestra piu' lunga prima di dire altro". Con 0 operazioni in entrambe: "non opera con questi default su XAUUSD H1/M15" -- NON significa "cattivo": cause possibili (simbolo, periodo, input da impostare, licenza/demo limitata, filtro news non simulabile) da cercare nel REFERTO e nei log, non da supporre.
- **S2 (dipende dal periodo)**: operazioni H1 e M15 che differiscono di oltre un fattore 3 = "dipende dal periodo": si NON sceglie il piu' favorevole; il periodo del test a fondo e' quello **dichiarato dal venditore sulla pagina del Market** (Claudio lo conferma, o lo leggo io dalla pagina). Se il venditore non dichiara un periodo, si dichiara e si scrive PRIMA di guardare i numeri a fondo.
- **S3 (passa al test a fondo)**: solo gli EA che "operano" (S1) E con periodo dichiarato noto. Il test a fondo ha le sue ipotesi scritte prima (stesso schema di B1-B7 del pacchetto: finestra lunga, DD, mesi positivi, ecc.). Il setaccio NON ordina gli EA per profitto e nessun EA entra o esce dal test a fondo perche' ha guadagnato o perso in gennaio-febbraio 2026.
- **S4 (conformita')**: una passata vale solo se: ticks reali al 100%, finestra e periodo giusti, stesso `.ex5` (SHA256) prima e dopo, nessun KO. Altrimenti "non conforme" e non si legge.
- **S5 (descrittivo, non giudizio)**: dagli input del report si elencano per ogni EA i nomi che richiamano martingala/griglia/moltiplicatori/recupero (Martingale, Multiplier, Grid, Recovery, Averaging, Hedge...). E' una segnalazione da verificare sulla pagina del venditore, non una prova.
- **S6 (attrito)**: tutti i test usano la stessa ipotesi di costi del nostro tester (spread del tester su BCM, commissione del conto demo). Nessun EA e' confrontato con numeri del venditore finche' non sono stati rifatti con quelle stesse condizioni.

## Limiti dichiarati
- Il periodo H1/M15 e' una sonda, non l'ipotesi di ciascun EA. Un EA pensato per M5/M1 o D1 puo' non operare o operare male a H1/M15: S2 lo segnala, non lo scarta.
- Le demo del Market possono avere funzioni limitate [NON VERIFICATO per ciascuna]. Un EA a pagamento potrebbe comportarsi diversamente dalla demo.
- Prop Firm Gold EA (pagina vista: 499 USD, v2.5, dichiara focus prop firm, niente martingala/griglia, randomizzazione): "randomizzazione" significa che due corse identiche possono dare numeri diversi [DERIVATO dal nome della funzione, NON VERIFICATO]; se i risultati variano fra due giri uguali, il test a fondo va ripetuto piu' volte e si usa la mediana.
