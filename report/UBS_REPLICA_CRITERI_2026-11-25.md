# UBS: replica dei PF dichiarati nell'Excel (set di Wim e degli utenti), criteri scritti PRIMA dei numeri (25/11/2026)

**Richiesta di Claudio (25/11):** "proviamo anche i set degli utenti e guardiamo i PF del file Excel e proviamo se sono confermati anche dai nostri test"; e "dobbiamo provare tutte le combinazioni possibili di ottimizzazione, non mi importa il tempo". Questa e' la **Fase R (replica)**, prima dell'ottimizzazione: serve a sapere quali set e quali famiglie hanno un PF che si riproduce sui NOSTRI dati, cosi' l'ottimizzazione non si spreca su modelli senza vantaggio.

## Materiale
`UBS_sets_profit_factor.xlsx` (Zairex_, Telegram UBS): 312 set, **Vantage a tick, 2020-2026, PF/operazioni/utile/DD dichiarati** (non nostri). Inventario: 741 set distinti (`UBS_INVENTARIO/master_inventory.csv`): 361 pacchetto V9.8 di Wim, 274 set degli utenti (Telegram), 62 Christmas, 44 pacchetto di Wim. **Con PF dichiarato nell'Excel: 249** (solo 21 dei 274 set degli utenti: gli altri non hanno un PF nell'Excel e si provano senza confronto). Copertura dati BCM: `COPERTURA_UBS_2026-11-25.md`.

## Fase R1: replica sul periodo dell'Excel
Ogni set cosi' com'e' (nessuna ottimizzazione), EA UBS originale, lotto fisso 0,1, deposito 100.000, BCM, **Modello 1 (1 minuto OHLC)** dal 01/01/2020 al 31/10/2026 (indici e petrolio nativi solo dal 09/2024: periodo ridotto dichiarato; US500/USTEC su `_EXT` con orologio da verificare; Tesla e Bitcoin: nessun dato, esclusi e riportati come "non provabili").
- **CONFERMATO:** PF nostro >= 1,20 **e** (PF nostro - 1) >= 0,5 x (PF Excel - 1) **e** operazioni nostre >= 50% di quelle dichiarate (minimo 30).
- **PARZIALE:** PF nostro >= 1,10 senza il resto. **NON CONFERMATO:** il resto.
- Misure riportate: rapporto PF nostro / PF Excel (mediana per famiglia), correlazione di rango tra i due PF, % confermati per famiglia e per fonte (Wim / utenti).

## Fase R2: fuori campione prima del 2020 (solo per CONFERMATO o PARZIALE)
Stessi set, nessun cambiamento, 01/01/2013 -> 31/12/2019 (forex e argento; indici `_EXT` dal 2010 con riserva). **Regge** se PF >= 1,10 con >= 30 operazioni. Questo e' il vero fuori campione: la replica R1 e' sullo stesso periodo dell'autore (in campione per lui) e misura solo se il PF si riproduce coi nostri dati.

## Passaggio all'ottimizzazione
Solo le **famiglie** (stesso modello e simbolo) con almeno un set CONFERMATO e che REGGE in R2 passano alla Fase O (ottimizzazione coi cancelli della campagna: `UBS_CAMPAGNA_OTTIMIZZAZIONE_CRITERI_2026-11-22.md`). Le altre si riportano come "vantaggio dichiarato non riprodotto". Contatore dei tentativi dichiarato; soglie non abbassate.

## Previsione (scritta ora)
Mediana del rapporto PF nostro / PF Excel: **0,7**. Correlazione di rango fra i due PF: **0,4-0,6**. **Confermati: 25-40% dei set provabili**; set degli utenti meno di quelli di Wim; i set con PF >= 3 e poche operazioni (e, d, g: 55-104 op.) e quelli sull'oro in 2024-26 (periodo di trend) si confermano di piu' in R1 ma regrediscono in R2. **R2: meno della meta' dei confermati regge.** Probabilita' che almeno una famiglia non oro superi R1+R2: 45%.

## Limiti dichiarati
Excel di una sola persona su un solo feed (Vantage): nessuna verifica indipendente del file; M1 OHLC invece di tick (si ripete a tick reali solo per i sopravvissuti, da 07/2024); Tesla e Bitcoin non provabili; 99 set dell'inventario con PF ma simbolo non riconosciuto dal nome vanno assegnati leggendo il `.set`.
