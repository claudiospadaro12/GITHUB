# Scheda live 24/08/2026 (conduce Paolo; Emiliano assente per intervento)

_Fonte: trascrizione caricata da Claudio la sera del 24/08. Ogni numero è
[FONTE CORSO], mai un criterio nostro finché non è misurato in casa._

## Le DUE conferme incrociate (corso ↔ nostre misure)
1. **ORB: "si entra SOLO con aumento di volume"** — regola meccanica
   dichiarata e mostrata sullo storico (le entrate senza aumento di volume
   erano quelle cattive). **Converge con R101**: il filtro volumi
   (02_volumi) è il NOSTRO unico candidato sopravvissuto a G1+G2+G3 sulle
   Aperture. Due strade indipendenti, stessa conclusione. Rafforza il caso
   per il round di validazione del gemello volumi.
2. **"Le correlazioni sono andate tutte a farsi fottere in questo periodo"**
   (Paolo, testuale) — converge con R101/G3: il filtro correlazione SPXUSD
   era incoerente fra Dow e DAX ed è stato bocciato dal cancello. Il corso
   lo ammette a voce; noi l'abbiamo misurato.

## I TRE spunti nuovi
3. **Parabolic SAR come trailing** ("lo sto sperimentando e funziona bene";
   alternative citate: Supertrend o media 50; tesi: gli indici, presa la
   direzione, la tengono fino all'apertura successiva). → Candidato di
   GESTIONE da misurare nella stessa famiglia di R104 (la domanda di
   Claudio di stamattina: il trailing 2xATR restituisce troppo?). Gradini
   possibili: trailing attuale vs PSAR default vs media 50, stessa sedia,
   stessa finestra.
4. **ORB sul DAX** (box 9:00-9:15 IT = 8:00-8:15 server, chiusura del CORPO
   intero fuori dal box, conferma volumi, pullback se la candela chiude
   lontano). Il nostro ORB gira solo su U30USD. → Candidato sedia nuova per
   l'imbuto; prima passa dal REGISTRO_TEST (lista dei caduti — seconda
   caccia) e dai criteri di casa.
5. **Slippage sugli stop indici, vissuto in diretta**: Paolo ha preso "il
   doppio dello stop" su una candela news del DAX. Conferma la corsia
   prop-hardening (stress slippage) e la nota del censimento ("stop
   saltato"). Non è teoria: è successo in live davanti agli allievi.

## Watchpoint operativo della settimana
- **Jackson Hole giovedì 27 e venerdì 28/08**: due giornate dichiarate ad
  alta volatilità (dichiarazioni Fed). Le nostre sedie girano senza filtro
  news (R101: news OUT per criterio); la rete è il Guardian B1 (pausa 4%).
  Da sapere, non da agire: se le giornate fossero selvagge, i numeri di
  quei giorni si leggono col contesto.
  - ✅ **CONFERMATO dalla live del 25/08** (Paolo, testuale): _"Quello sono
    giorni di altissima volatilità che non sai dove va il mercato […] non
    si fa quella. Non sai quando esce e non sai come esce la notizia."_
  - ⚠️ **CORREZIONE sulla data**: nella trascrizione del 25/08 Paolo dice
    solo **"venerdì"** e **"fine agosto"** — le date **27/28 NON sono nel
    suo parlato**. La finestra gio-ven resta come prudenziale, ma non è
    attribuibile a lui. Dettaglio in `ANALISI_LIVE_PAOLO_2026-08-25.md` §B1.

---

## ➡️ SEGUITO: live del 25/08 (Paolo, lezione SUPERTREND)
Referto completo: **`ANALISI_LIVE_PAOLO_2026-08-25.md`** (stessa cartella).
Non duplico qui: in sintesi, i tre spunti che ne escono con priorità alta sono
il **filtro trend su TF superiore** (teorema dei 3 TF), l'**ADR a 50 giorni**
(assente ovunque da noi) e il **riesame di `ABTG_SupertrendInvert` sugli
indici** (EA già scritto, bocciato solo su oro H1). Bandiera di contrasto: il
suo cavallo di battaglia è la **DAX M3**, che noi abbiamo misurato **morta**
in real-tick (capitolo breakout M5 chiuso, `REGISTRO_TEST.md` riga 40).

⚠️ Nota di lettura incrociata: Emiliano (24/08) parla **intraday su indici**,
Paolo (25/08) parla **swing forex H4-Weekly**. Sono due mestieri diversi nello
stesso corso: **una regola dell'uno non vale automaticamente per l'altro**. E
sono **una fonte sola**, non due indipendenti.

## Minori / non azionabili
- VWAP: il corso usa il GIORNALIERO per l'intraday; il nostro gradino 07
  (VWAP sessione M15) è già misurato non-candidato. Nessun cambio.
- POC come livello: domanda rimasta senza risposta anche per loro.
- Retest sul breakout ("se chiude troppo lontano, aspetta il pullback"):
  la nostra geometria RETEST fa già questo. Siamo avanti, di nuovo.
