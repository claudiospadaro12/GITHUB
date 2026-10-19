# S-CORR e S-PORT sugli EA oro di fascia 1 + Gold Reaper: metodo e previsioni scritti PRIMA dei numeri (19/10/2026)

**Non controllata da agenti.** Soglie da `MARKET_SELEZIONE_PER_ACQUISTO_ATTESE_2026-10-19.md`: **S-CORR** = correlazione dei risultati giornalieri **<= 0,5 per ogni coppia**; **S-PORT** = drawdown combinato **<= 10% del conto** su cui girerebbero. Non le tocco.

## Insieme
Prop Firm Gold EA, Smart Gold Hunter, Gold Trade Pro (D1 ipotesi), Goldbot One (H1 ipotesi), Gold Reaper col set di Claudio. (Ghost, Quantum Titan, Phantom ecc. restano fuori: fasce 2-3.) 10 coppie.

## Metodo (quello CONGELATO del 17/10, `PACCHETTO_ORO_B5_B6_METODO_2026-10-17.md`, strumento `correlazione_pacchetto.py` non modificato)
- Serie: report delle **21 tranche mensili** di ciascun EA (ogni mese da 5.000), netto giornaliero = profitto+commissione+swap per giorno di chiusura, giorni senza operazioni = 0. Per Gold Reaper: le 21 tranche del suo set (GRSET). Le corse continue (Prop Firm, GRC) non si usano perche' lo strumento lavora per tranche.
- Per ogni coppia: r, giorni co-attivi, intervallo bootstrap 95% (seed 12345), r a giorni scartati, correlazione nel decile peggiore.
- **Regola S-CORR (scritta ora)**: passa solo se **r puntuale <= 0,50 per tutte le 10 coppie**. Dichiaro anche l'esito a tre stati dello strumento: se l'intervallo contiene 0,50 la coppia e' "NON MISURATA" e non conta come prova di scorrelazione; lo scrivo accanto, ma il verdetto S-CORR e' la regola puntuale sopra. Se una coppia e' > 0,50 -> S-CORR smentita per quella coppia.
- **S-PORT**: portafoglio a **peso 1** (EA a lotto fisso, come sul conto vero), DD sui realizzi giornalieri dentro ciascun mese comune = **pavimento**; **tetto** = somma dei DD di equita' dei singoli nello stesso mese. **S-PORT passa solo se il TETTO <= 10% (500 EUR su 5.000)**; se solo il pavimento e' <= 10% -> **NON MISURATA** (non si compra su un pavimento, regola del metodo). Portafogli: **A** = Prop Firm + Smart Gold Hunter; **B** = i 4 di fascia 1; **C** = B + Gold Reaper set.
- Limiti dichiarati: corse separate sommate, non un conto solo; il DD tra un mese e l'altro non si vede (ogni mese riparte da 5.000); niente DD intraday.

## Previsioni dichiarate ORA
- **P8**: almeno **3 delle 10 coppie** hanno r > 0,50 (stesso strumento, stesso oro: le coppie gia' misurate fra EA oro stavano a 0,42-0,60). Quindi **S-CORR smentita** per l'insieme intero.
- **P9**: Smart Gold Hunter, con pochi scambi (237 in 21 mesi), ha r <= 0,30 con tutti, ma molte coppie con SGH risulteranno NON MISURATE (pochi giorni co-attivi o intervallo largo).
- **P10**: il TETTO supera il 10% nel portafoglio B (il solo Gold Trade Pro ha avuto 11,02% in un mese) e quindi **S-PORT non passa per B e C**; per A (Prop Firm + Smart Gold Hunter) il tetto resta <= 10%.
- Se uscisse l'opposto lo scrivo cosi' com'e'.
