# Rendering 3D (etichette ed espositori)

Immagini realistiche generate dai dati veri del progetto: logo, etichette (`../etichette-rulli/output/stampa.pdf`) e misure dell'espositore.
Sono **visualizzazioni illustrative, non prototipi**: materiali e finiture sono ipotesi; le fotografie reali dei prodotti non ci sono.

Rigenerare (serve Chromium/Playwright, gia' installati nell'ambiente):

    cd zenit/rendering && npm install
    pdftoppm -r 250 -png ../etichette-rulli/output/stampa.pdf tex/lab
    NODE_PATH=$(npm root -g) node render.js

Uscite in `output/`: espositore nuovo layout (A da terra 50 cm 3/4 e frontale; A100 da 100 cm 3/4 e frontale; B da banco ridotto 3/4), rulli con fascetta e primi piani.
L'espositore e' parametrico in `espositore.html` (`?v=A|A100|B&cam=3q|front`): misure in cm, speculari a `espositori/progetto/genera_disegni.py`. QR e valori della guida sono segnaposto.
Ipotesi: l'etichetta e' una fascetta di cartoncino avvolta attorno al rullo (21 cm di sviluppo); si vede solo meta' della fascetta alla volta.
