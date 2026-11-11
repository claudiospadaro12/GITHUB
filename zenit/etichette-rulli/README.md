# Etichette rulli Zenit - layout unico 5 lingue

**Ipotesi di formato:** cartoncino/stringa da inserire nell'anima del rullo (o fascetta), **210 x 60 mm**, una sola facciata. Dimensioni parametriche (vedi sotto).

## Layout (e perche')
- **Pannello sinistro (blu):** logo, nome prodotto, codice articolo, EAN-13. Sono i dati "neutri", leggibili a colpo d'occhio a scaffale.
- **Fascia superiore:** schema quotato del rullo (lunghezza, Ø esterno/interno, altezza pelo: valori numerici, nessuna lingua) + icone delle superfici/vernici consigliate.
- **5 righe, una per lingua** (IT, EN, DE, ES, FR) con sigla in riquadro: nome, descrizione, altezza pelo, materiale, utilizzi. Ordine e struttura identici in ogni riga, cosi' si trova subito la propria lingua. Sigle e non bandiere: bandiere ambigue per EN/ES e per mercati multi-lingua.
- **Piede:** dati azienda (segnaposto) e "Made in Italy".
- Palette: blu Zenit `#12355B`, arancio `#E8731A`, beige chiaro `#F3F1EC` (modificabili in `prodotti.json`).

## File
- `prodotti.json` - tutti i dati (formato, colori, azienda, traduzioni, prodotti)
- `template.html` - template parametrico (HTML/SVG + JS, genera EAN-13 e icone)
- `logo-placeholder.svg` - logo segnaposto
- `genera_pdf.py` - genera PDF + PNG (usa Chrome headless e `pdftoppm`, nessun pacchetto Python da installare)
- `output/` - `anteprima.pdf/.png` (foglio con tutte le etichette) e `stampa.pdf` (una etichetta per pagina a misura esatta)

## Uso
```
python3 genera_pdf.py            # anteprima
python3 genera_pdf.py --stampa   # pagine a misura esatta 210x60 per la tipografia
```

## Come cambiare
- **Dati prodotto:** in `prodotti.json`, lista `prodotti` (copiare un blocco, togliere `"esempio": true` per i dati reali: scompare il marchio ESEMPIO). L'EAN va inserito a 12 cifre: la 13a (controllo) e' calcolata.
- **Logo:** sostituire `logo-placeholder.svg` con il logo (SVG o PNG) oppure cambiare `"logo"` in `prodotti.json`.
- **Dimensioni:** `formato.larghezza_mm` / `altezza_mm`. I caratteri si scalano; sotto circa 150x45 mm il testo diventa troppo piccolo (verificare).
- **Azienda:** blocco `azienda`. **Colori:** blocco `colori`. **Traduzioni/utilizzi:** blocchi `termini`, `materiali`, `utilizzi`.
- Per aprire `template.html` direttamente nel browser servono i dati inseriti al posto di `__DATI__`: usare sempre `genera_pdf.py`.

## Da fornire dal cliente
- Logo Zenit vettoriale (SVG/AI/PDF) e manuale colori ufficiali
- Formato/supporto reale (cartoncino nell'anima? fascetta? dimensioni esatte, carta, stampa)
- Dati aziendali completi (indirizzo, tel., email, sito, P.IVA) ed eventuale importatore/riferimenti legali
- Elenco prodotti reali: codici, EAN assegnati (prefisso GS1 aziendale), misure, materiali, altezze pelo, descrizioni
- Revisione delle traduzioni da parte di madrelingua/tecnici del settore
- Eventuali elementi obbligatori: lotto/data, marchi, simboli di riciclo, testi per mercati specifici

## Raccomandazioni del benchmark applicate (benchmark/etichette-rulli-concorrenza.md)
- Applicate: altezza pelo in mm con indicatore a barre (corto/medio/lungo, soglie ipotizzate da Zenit: <=8, 9-14, >=15 mm); scala delle superfici a 4 livelli con colori, presa dalle classi del catalogo 2026 (lisce / poco ruvide / ruvide / molto ruvide); icone e numeri uguali nelle 5 lingue; confezione in zona fissa; materiale in chiaro.
- Non applicate perche' mancano i dati: matrice vernice x rullo (compatibilita' non presente nel catalogo), indirizzo QR alla guida, simbolo di riciclo, marchio di gamma distintivo.
- Da confermare: le soglie del pelo e le traduzioni.
