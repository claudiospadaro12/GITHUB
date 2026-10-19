# Test a fondo degli EA del Market (gruppo A del setaccio): ambito e previsioni, scritti PRIMA dei numeri (19/10/2026)

Soglie e criteri di scelta: `MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md` (non cambiano). Lettura del setaccio: `SETACCIO_MARKET_LETTURA_2026-10-19.md`. Non rivisto da agenti.

## Ambito del primo giro (riga con `DEEP_TESTER_TRANCHE.ps1`)
10 EA, tutti **XAUUSD H1**, 21 tranche mensili (gen 2025 - set 2026, 5.000 EUR ciascuna) **piu una corsa continua** (01/01/2025 - 01/10/2026): AI Golden Life, Ghost Scalper, Prop Firm Gold EA, Smart Gold Hunter, Quantum Titan, TitanForge, Nebula Cartographer, EA Super Trend XAUUSD, Quantum iGold, PolyGold Scalper.
- Scelti perche' **hanno operato nel setaccio e H1/M15 danno risultati uguali o quasi** (ignorano il periodo del grafico: H1 e' una scelta neutra). Compresi quelli in perdita nel setaccio (Quantum iGold, PolyGold): **non si esclude nessuno per il risultato di due mesi**.
- **Esclusi da questo giro**: Institutional SMC, Pac Man BTC, Ultimate Breakout (dipendono dal periodo: serve il periodo dichiarato dal venditore); Night Scalper e Quantum Commander (misura mancante); Range Breakout e Waka Waka (operano su altri simboli); gruppo B (recupero/griglia/piramidazione): giro a parte con tetti di esposizione.
- **Input**: NON imposti. Restano quelli salvati dal tester per ogni EA, cioe quelli del setaccio (l'ultima corsa su questo PC). **Controllo obbligatorio prima di leggere qualunque numero**: gli input scritti nel report del test a fondo devono coincidere con quelli del setaccio; se no, il giro non e' conforme.
- **Prop Firm Gold EA dichiara randomizzazione** (H1 +550 e M15 +524 nel setaccio, a parita' di operazioni: coerente con una componente casuale): per S-STAB la corsa continua va ripetuta 3 volte; in questo giro ne gira una, le altre due dopo, se quella supera la soglia.

## Previsioni dichiarate ORA (da verificare, non da difendere)
- **P1**: al massimo **3 dei 10** soddisfano TUTTE le soglie S-N, S-M, S-H, S-DD, S-NOSCALA, S-COSTO.
- **P2**: **TitanForge e Nebula** (profit factor 85 e 36 nel setaccio) avranno profit factor su 21 mesi **sotto 10**.
- **P3**: **EA Super Trend** avra' un drawdown mensile massimo **sopra il 15,2%** in almeno un mese (nel setaccio, M15: 16,1%; lotto 4 volte piu' grande del minimo).
- **P4**: **Quantum iGold e PolyGold** restano in perdita su 21 mesi.
- **P5**: la **corsa continua** produce un profitto **inferiore alla somma dei 21 mesi indipendenti** per la maggioranza degli EA (come per il Gold Reaper: -51%).
- Se P1-P5 sono sbagliate, la lettura lo dice cosi'.

## Costo previsto [DERIVATO dal setaccio, non misurato su 21 mesi]
Circa 1-2 minuti per due mesi per gli EA veloci: 21 mesi mensili + corsa continua in circa 25-60 minuti per EA, quindi circa 5-10 ore per i dieci. Timeout 90 minuti per tranche (4 volte per la continua).
