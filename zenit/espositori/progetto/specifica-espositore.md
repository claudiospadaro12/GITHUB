# Espositore da punto vendita Zenit - specifica per richiesta preventivo

Documento di lavoro per i fornitori. **Tutte le misure e i pesi sono ipotesi di progetto** (non ancora verificate con i prodotti reali) e vanno confermate/corrette dal cliente. I disegni sono parametrici (`genera_disegni.py`): cambiando i parametri si rigenerano SVG e PNG.

Disegni allegati (quote in mm, schema non in scala di produzione):

| Variante | Frontale | Laterale |
|---|---|---|
| A - da terra, 2 facce | `espositore-A-frontale.svg/.png` | `espositore-A-laterale.svg/.png` |
| B - da banco, 1 faccia | `espositore-B-frontale.svg/.png` | `espositore-B-laterale.svg/.png` |

## 1. Ipotesi di partenza (parametri)

| Parametro | Var. A da terra | Var. B da banco |
|---|---|---|
| Ingombro base (L x P) | 500 x 400 (misura indicata dal cliente) | 450 x 300 |
| Altezza totale | 2200 (misura indicata dal cliente) | 880 |
| Facce espositive | 2 (schiena a schiena, montante centrale 20) | 1 (pannello posteriore 20) |
| Base | 120 zavorrata; piedini regolabili oppure ruote Ø60 frenate (opz., altezza totale invariata) | 30, piedini antiscivolo |
| Testata (header) | 500 x 250, spessore 60, stampa fronte/retro | 450 x 100, spessore 40 |
| Zona ganci (pannello forato) | 990 alt., 4 righe, passo righe ~248 | 410 alt., 2 righe, passo ~205 |
| Fascia grafica + tasche DL | 160 alt., 2 tasche formato DL (99x210), visibile 140 | non prevista (tasca clip-on opzionale) |
| Vaschette rulli | 4 per faccia, passo 170, inclinazione 15 gradi, profondita' utile 180, sponda h 35 | 2, passo 170, profondita' utile 270 |
| Foratura pannello | Ø5, passo 25 x 25 | idem |
| Ganci | asta Ø5, L 150, passo orizzontale 80 | idem |

Prodotti ipotizzati (da verificare): blister pennelli 70 x 170 mm, spessore 12 mm; 8 blister per gancio (~100 mm di asta occupati). Rulli confezionati Ø 65 mm, lunghezze 250 / 230 / 200 / 100 mm (max 25 cm, come da catalogo), sdraiati con asse parallelo alla fronte, gioco 10 mm.

## 2. Disposizione e capacita' di riferimento

**Variante A (per faccia)**
- Pennelli: 4 righe x 5 ganci x 8 blister = **160 pz** (righe di esempio: piatti / smalti e rifinitura / pennellesse e tondi / radiatori e vari).
- Rulli: vaschetta 1 (250 mm) 1 x 2 file = 2; vaschetta 2 (230 mm) 1 x 2 = 2; vaschetta 3 (200 mm) 2 x 2 = 4; vaschetta 4 (mini 100 mm) 4 x 2 = 8 -> **16 pz**.
- Totale 2 facce: **320 pennelli + 32 rulli**. 20 ganci e 4 vaschette per faccia. Capacita rulli bassa: con H 2200 si puo valutare una 5a vaschetta o rulli in verticale.

**Variante B (1 faccia)**
- Pennelli: 2 righe x 5 ganci x 8 = **80 pz**.
- Rulli: vaschetta 1 (200 mm) 2 x 4 file = 8; vaschetta 2 (mini 100 mm) 3 x 4 = 12 -> **20 pz**.

Le capacita' sono calcolate dal generatore sulle misure ipotizzate; con prodotti diversi cambiano (vedi domande aperte).

Carico stimato (da verificare con pesi reali): blister ~0,1 kg -> ~0,8 kg per gancio, ~34 kg di pennelli e ~13 kg di rulli (0,25 kg medio) nella Var. A completa, ~47 kg di merce + struttura. Il baricentro basso e' ottenuto con rulli e base nella parte bassa.

## 3. Materiali candidati

| | Cartone ondulato rinforzato | Metallo verniciato (lamiera/tubo + pannello forato) | Legno / MDF (melaminico o laccato) |
|---|---|---|---|
| Uso tipico | promozionale, a rotazione (settimane-mesi) | permanente (anni) | semi-permanente, look "negozio" |
| Pro | costo unitario piu' basso a volumi alti; stampa full-colour diretta/offset; leggero; riciclabile; spedizione piatta compatta | massima portata e durata; ganci standard sul mercato; ruote e base robuste; finiture RAL | aspetto premium; buona rigidita'; stampa/etichette applicate; riparabile |
| Contro | portata limitata (ganci e vaschette con rulli richiedono onda tripla/doppia-doppia e rinforzi); sensibile a umidita' (negozi di vernici!); non adatto a ruote; durata breve | costo di attrezzaggio e unitario piu' alto; peso e trasporto; grafica solo su pannelli adesivi/stampati applicati | peso elevato; sensibile a urti agli spigoli e all'umidita'; costo medio-alto |
| Portata indicativa (da dichiarare dal fornitore) | ~15-25 kg complessivi con rinforzi; ganci in metallo infilati nel cartone (max 0,8-1 kg/gancio) | > 80 kg; ganci 2-3 kg cad. | ~40-60 kg |
| Adatto a | Var. B (banco) e Var. A promozionale, tirature medio-alte | Var. A permanente | Var. A/B di fascia alta, tirature basse |
| Verifica fornitore | resistenza a compressione, umidita'; ganci/vaschette in cartone vs plastica | spessori, saldature, test ribaltamento | spessori, bordi, peso totale |

**Proposta di partenza:** Var. B in cartone ondulato con ganci metallici; Var. A in metallo verniciato con testata e fianchi stampati (pannelli PVC/forex o lamiera serigrafata). Chiedere preventivo alternativo cartone per la Var. A.

## 4. Finiture e stampa

- Colori brand (**placeholder**: blu #14386B, arancio #F08A1C, neutro sabbia #F4F1EA): il cliente fornira' i Pantone/CMYK/RAL reali.
- Testata e fianchi: stampa 4/0 (o 4+1) su fronte e retro; file vettoriali + logo Zenit forniti dal cliente (il disegno mostra solo un riquadro "LOGO ZENIT").
- Metallo: verniciatura a polvere, RAL da definire; cartone: stampa offset su patinato o diretta, plastificazione opaca/antigraffio; legno: laccato opaco o laminato.
- Headline di esempio: "PENNELLI E RULLI - per ogni superficie." e "Scegli il rullo giusto." (testi di prova, da sostituire).
- Cartellini prezzo: clip/profilo a scatto su sponda vaschetta h 35 e su listello ganci; formato ~64 x 20 mm (da confermare).
- Tasche portadepliant: acrilico o PET trasparente, formato DL, fissaggio a viti o biadesivo.

## 5. Montaggio, imballo, trasporto

- Obiettivo: **imballo piatto**, montaggio senza attrezzi o con chiave esagonale, <= 10 minuti, 1 persona. Montanti/pannelli e vaschette a incastro o a scatto; testata inserita sul montante.
- Pezzi principali Var. A: base, montante centrale + pannelli forati (2), fianchi (2), testata (1), vaschette (8), ganci (42), tasche (4), cartellini. Ingombro piatto atteso circa 1900 x 650 x 150 mm (**stima, da confermare**).
- Imballo: scatola unica per espositore, bancale con N pezzi da definire; peso lordo da dichiarare.
- Ruote opzionali: 4 x Ø60, 2 con freno, portata >= 25 kg/ruota.
- Stabilita': prova di ribaltamento (carico completo, inclinazione secondo norma/uso interno) a carico del fornitore.

## 6. Dati che il fornitore deve confermare

1. Materiale/i proposti per ciascuna variante e relativa portata certificata (totale, per gancio, per vaschetta).
2. Fattibilita' delle misure indicate (ingombro, spessori, raggio di inclinazione, profondita' vaschette) ed eventuali modifiche suggerite per ridurre costo/peso.
3. Prezzo unitario per scaglioni (es. 50 / 100 / 250 / 500 pezzi), costo attrezzaggio/fustelle/stampi una tantum, costo ruote opzionali.
4. Tempi di campione e di produzione; MOQ; possibilita' di prototipo bianco.
5. Dimensioni, peso e volume dell'imballo, pezzi per bancale, tempo di montaggio.
6. Tolleranze, finiture disponibili, resistenza all'umidita' (cartone), test di ribaltamento e di carico.
7. Ganci e accessori standard disponibili (L, Ø, portata), compatibilita' del passo di foratura.
8. File richiesti per la stampa (formato, abbondanze, profili colore).
9. Garanzie, sostituzione parti, ricambi.

## 7. Domande aperte per Zenit (da chiarire prima del preventivo)

- Misure reali di blister e rulli (L x H x spessore, peso), modalita' di confezione dei rulli (sleeve, scatola, shrink, con o senza manico).
- Numero di referenze da esporre e quali (pennelli piatti/rotondi/smalti, rulli per tipo di pelo e lunghezza) e se vanno raggruppati per applicazione.
- Quantita' di espositori da ordinare, uso permanente o promozionale, budget unitario target.
- Facce: stessa grafica/assortimento su entrambe? Serve la variante a parete?
- Ruote si/no; ancoraggio; limiti di ingombro dei punti vendita target; altezza massima del banco per la Var. B.
- Colori brand e logo ufficiali, headline definitive, necessita' di illuminazione o QR code.
- Tasche portadepliant: quali formati (DL, A5) e quanti.


## Raccomandazioni del benchmark: stato (benchmark/espositori-concorrenza.md)
| # | Raccomandazione | Stato |
|---|---|---|
| 1-2 | Ordine per superficie/uso e codice colore | Parziale: la fascia guida usa gli stessi 4 colori delle etichette (lisce, poco ruvide, ruvide, molto ruvide). Le righe dei pennelli restano per tipo (come nel catalogo). |
| 3 | Pennelli fuori imballo per la prova tattile | Non applicato nel disegno (blister). Da valutare con il cliente, anche per il rischio furto. |
| 4 | Campione di pelo/texture sulle vaschette | Applicato: un riquadro campione sulla sponda di ogni vaschetta. |
| 5 | Guida alla scelta a livello occhi | Parziale: la fascia guida e' sopra le vaschette dei rulli (circa 90 cm), non a 150-170 cm. Spostarla richiede di riordinare il layout: da decidere. |
| 6 | Scorta in basso | Applicato come ipotesi: la base diventa vano scorta con sportello chiudibile. |
| 7 | Modularita' terra/banco/parete | Solo terra e banco (varianti A e B). La parete non e' disegnata. |
| 8 | Tre varianti di materiale | Gia' nel confronto cartone/metallo/MDF di questo documento. |
| 9 | Testata sostituibile | Da specificare al fornitore: inserto di testata intercambiabile. |
| 10 | Segnaletica da 1-2 m e QR | Applicato: scritte grandi e QR segnaposto in testata. L'indirizzo del QR va deciso. |

Le misure dell'espositore da terra (H 220 x L 50 x P 40 cm) sono state indicate dal cliente.
