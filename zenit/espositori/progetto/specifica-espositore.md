# Espositore da punto vendita Zenit - specifica per richiesta preventivo (nuovo layout)

Documento di lavoro per i fornitori. **Tutte le misure, i pesi e le capacita' sono ipotesi di progetto** (non verificate con i prodotti reali) da confermare/correggere. I disegni sono parametrici (`genera_disegni.py`, parametro larghezza `W`): cambiando i parametri si rigenerano SVG e PNG (`render_png.js`).

Il progetto riprende il linguaggio dell'espositore attuale (foto del cliente): struttura in metallo **nero** con pannello forato nero, testata **bianca** con logo Zenit al centro, social in alto a destra, QR in basso a destra, bollino Made in Italy e bandiera a sinistra; **fasce bianche a mensola** con "LINEA ..."; **pennelli nudi** (senza blister) appesi a ganci; **rulli in piedi** in basso; base nera con pannello bianco con indirizzo web. Blu logo #3850A2.

| Variante | Frontale | Laterale |
|---|---|---|
| A - da terra 50 cm (principale) | `espositore-A-frontale.svg/.png` | `espositore-A-laterale.svg/.png` |
| A100 - da terra 100 cm (come l'originale) | `espositore-A100-frontale.svg/.png` | come A (stessa sezione) |
| B - da banco 50 cm, ridotto | `espositore-B-frontale.svg/.png` | `espositore-B-laterale.svg/.png` |

Rendering 3D: `../../rendering/output/espositore-{A,A100,B}-3q.png`, `espositore-{A,A100}-frontale.png`.

## 1. Cosa cambia rispetto all'originale (miglioramenti dal benchmark)

1. **Fasce per LINEA/USO con codice colore**: ogni fascia ha il nome linea, il tipo d'uso e 4 riquadri-superficie (scala a 4 livelli con 3 puntini di rugosita' crescente: lisce #3850A2, poco ruvide #2E8B8B, ruvide #E8731A, molto ruvide #B23A2E). Nelle fasce dei pennelli i livelli non adatti sono sbiaditi. **L'assegnazione colori alle linee (Dakota = lisce/poco ruvide, Nonstop = tutte) e' solo illustrativa**, da definire con Zenit.
2. **Guida alla scelta a livello occhi** (250 mm, da 1480 a 1730 mm da terra, centro a ~160 cm; zona richiesta 140-170): 4 righe superficie -> pelo consigliato, + QR. I valori "pelo corto 4-5 mm" ecc. sono **esempi tipici, non dati Zenit**.
3. **Rulli in piedi in scomparti per misura** 20/23/25 cm, vasca a gradini (alzata 32 mm) cosi' il pelo e' visibile, sponda anteriore (h 70) con cartellino prezzo e campione di pelo.
4. **Scorta in basso** dietro sportello (base 220 mm).
5. **Testata intercambiabile**: inserto stampato sfilabile in profili neri; contenuti come l'originale.
6. **Cartellino prezzo sotto ogni gancio** (~44 x 18 mm).
7. **Segnaletica leggibile da 1-2 m**: nomi linea e misure con altezza maschio ~30 mm o piu'; scritte secondarie (esempi pelo) piu' piccole, da guardare da vicino.

## 2. Ipotesi di partenza (parametri, mm)

| Parametro | A (50) | A100 | B banco |
|---|---|---|---|
| Ingombro L x P x H | 500 x 400 x 2200 (misure cliente) | 1000 x 400 x 2200 | 500 x 400 x 1100 (ipotesi) |
| Facce | 1 (pannello posteriore forato 20, come originale; per 2 facce serve un nuovo progetto, p. es. 2 x 200 di profondita') | 1 | 1 |
| Base / scorta | 220, sportello frontale | 220 | zoccolo 40 con piedini, niente scorta |
| Vasca rulli | da 220 a 620; 3 scomparti | 6 scomparti | 3 scomparti |
| Fascia bianca (mensola) | h 60, aggetto 60 | idem | idem |
| Sezione ganci 1 (LINEA DAKOTA) | h 360 | h 360 | non presente |
| Sezione ganci 2 (LINEA NONSTOP) | h 320 | h 320 | h 380 |
| Guida alla scelta | 460 x 250 | 960 x 250 | non presente |
| Testata | 460 x 470 | 960 x 470 | 460 x 160 |
| Struttura | montanti/fianchi neri 20, pannello forato Ø5 passo 25 x 25 | idem | idem |

Zone dal basso (A): base 0-220 | vasca rulli 220-620 | fascia RULLI 620-680 | ganci Dakota 680-1040 | fascia Dakota 1040-1100 | ganci Nonstop 1100-1420 | fascia Nonstop 1420-1480 | guida 1480-1730 | testata 1730-2200. (La fascia sta sopra la sezione che nomina, come nella foto.)

**Prodotti (ipotesi dichiarate)**
- Rulli: lunghezza max 250 mm (standard 200/230/250), diametro manicotto 65 mm, in piedi, gioco 4 mm.
- Pennelli: nudi, manico in legno, lunghezze 150-300 mm; larghezza testa: lunghi/radiatore ~30 mm (passo 38), pennellesse da soffitto ~100 mm (passo 112), piatti/tondi ~64 mm (passo 78). Appesi a foro nel manico su gancio L 150, Ø5. Spessore ~15-25 mm: fino a 3 pezzi per gancio in profondita' (ipotesi).

## 3. Capacita' stimata (calcolata dal generatore)

| | A 50 cm | A100 | B |
|---|---|---|---|
| Posti gancio per sezione | 10 = 5 lunghi + 2 soffitto + 3 piatti | 21 = 10 + 4 + 7 | 10 |
| Posti gancio totali | 20 | 42 | 10 |
| Pennelli (3 per gancio, ipotesi) | **60** (solo 20 visibili in prima fila) | **126** (42 visibili) | 30 |
| Rulli per scomparto | 2 affiancati x 5 file = 10 | idem | 10 |
| Rulli totali in vasca | **30** (10 per misura) | **60** | 30 |

Note oneste: la A da 50 cm espone pochi pezzi (20 posti gancio contro ~34 dell'originale da 100 cm, scalando alla larghezza); le file di rulli dietro la prima sono visibili solo dall'alto. La scorta nel vano base non e' stata quantificata (vano utile circa 460 x 360 x 170 mm: ci stanno cartoni di rulli solo se coricati, da verificare con le scatole reali).

Carico stimato (pesi da verificare): pennelli ~0,1 kg cad. -> ~6 kg (A) / ~13 kg (A100); rulli ~0,25 kg -> ~8 kg (A) / ~15 kg (A100); piu' scorta.

## 4. Materiali

- **Struttura**: metallo (lamiera/tubo) verniciato a polvere nero opaco; pannello posteriore **forato** nero Ø5 passo 25 (standard ganci). Vasca a gradini e divisori in lamiera nera.
- **Pannelli stampati**: testata (inserto), guida alla scelta, fasce a mensola, pannello web sullo sportello, sponde con cartellino: stampa 4/0 su forex/PVC o lamiera serigrafata, colori brand da Pantone/RAL reali del cliente.
- Alternativa economica da chiedere: pannelli stampati su cartone/forex con struttura minima in metallo. Il cartone da solo non e' consigliato per la vasca rulli e per i ganci (portata, umidita' in negozi di vernici).

## 5. Montaggio, imballo

Obiettivo: imballo piatto, montaggio senza attrezzi o con chiave esagonale, 1 persona. Pezzi principali (A): base con sportello, fianchi (2), pannello forato, vasca + gradini + divisori (2), fasce (3), pannello guida, testata con profili, ganci (~20), cartellini. Ingombro piatto, peso, pezzi per bancale: **da dichiarare dal fornitore**. Antiribaltamento: prova a carico completo a carico del fornitore (altezza 220 per profondita' 40 e' snello: serve zavorra in base o fissaggio a parete).

## 6. Dati che il fornitore deve confermare

1. Fattibilita' delle misure (220 x 50 x 40), spessori, stabilita' e antiribaltamento; modifiche suggerite.
2. Portata certificata (totale, per gancio, per vasca) e materiali proposti.
3. Prezzo per scaglioni, costi di attrezzaggio/stampi/serigrafia, tempi di campione e produzione, MOQ, prototipo.
4. Sistema di testata sfilabile (profili, fissaggio anti-furto) e di fissaggio delle fasce.
5. Ganci e accessori standard (lunghezza, Ø, portacartellino), compatibilita' con foratura.
6. Sportello: serratura/chiusura, ingombro utile interno.
7. File di stampa (formato, abbondanze, profili colore), imballo e peso.

## 7. Domande aperte per Zenit

- Lunghezze, larghezze e pesi reali dei pennelli; quanti per gancio; quali referenze/linee per sezione (ora Dakota/Nonstop come nella foto).
- Assegnazione dei 4 livelli di rugosita' ai rulli e alle linee; testi e valori della guida alla scelta; indirizzo del QR (nel disegno e' un segnaposto non scansionabile).
- Larghezza definitiva: 50 cm (misura cliente) oppure 100 cm come l'originale; una o due facce.
- Indirizzo web ufficiale (nei disegni: www.pennellificiozenit.it, ricavato dalla foto/repo), Pantone/RAL, logo vettoriale, bollino Made in Italy ufficiale.
- Variante da banco: serve davvero? Altezza massima del banco? (la B qui e' un'ipotesi ridotta.)
- Scorta nel vano base: cosa deve contenere (cartoni di rulli? pennelli?).

## 8. Stato raccomandazioni del benchmark

| # | Raccomandazione | Stato |
|---|---|---|
| 1-2 | Ordine per uso e codice colore | Applicato nelle fasce (4 livelli); assegnazione alle linee da confermare |
| 3 | Pennelli fuori imballo per la prova tattile | Applicato (pennelli nudi); rischio furto da valutare |
| 4 | Campione di pelo sulle vaschette | Applicato su ogni scomparto |
| 5 | Guida alla scelta a livello occhi | Applicato (centro ~160 cm, 148-173) |
| 6 | Scorta in basso | Applicato come ipotesi (sportello) |
| 7 | Modularita' terra/banco/parete | Terra 50/100 e banco ridotto; parete non disegnata |
| 8 | Tre varianti di materiale | Vedi sez. 4 (solo metallo + pannelli stampati sviluppato) |
| 9 | Testata sostituibile | Applicato (inserto sfilabile), meccanismo da specificare |
| 10 | Segnaletica da 1-2 m e QR | Applicato; QR segnaposto |
