# 🎯 "COSA CI MANCA PER LA FLOTTA DA PROP?" — la risposta MISURATA

Domanda di Claudio, 07/09/2026: _"è più di un mese che ci proviamo e ancora non
siamo arrivati. Abbiamo pochi EA che tradano ogni giorno. Forse abbiamo i
cancelli troppo severi ed ogni tanto si potrebbe chiudere un occhio."_

> ## 🔴 LA RISPOSTA: **NON SONO I CANCELLI. L'IMBUTO SI FERMA ALL'ULTIMO METRO.**
> I candidati nati APPOSTA per il problema della frequenza **hanno passato** i
> cancelli, e poi si sono fermati su un passaggio che dipende da noi, non da
> loro. Sono lì fermi da 4 e da 10 giorni.

---

## 1. 🧨 LE DUE PROVE

### A) `LONDONFX` — HA PASSATO, ed è fermo a "criteri da firmare"
Referto `risultati_archivio/REFERTO_SONDALONDONFX_2026-09-03.md`, testuale:

> _"**PRIMO CANDIDATO DELLA MISSIONE FREQUENZA A PASSARE IL PASSO 0.**
> Su EURUSD M15 col filtro RSI il motore fa **2,0-2,3 segnali/giorno PER LATO**"_

- riga regina: EUR_M15, RSI, ora 8 → **2,26 sig/gg**, MFE 13,4 pip, RR 1,136
- **12/12 righe VIVE** su tutte e tre le ore
- l'ablazione dice che il filtro **è** il lavoro (taglia il 73-77%)

**Dove si è fermato:** `risultati_archivio/LONDONFX_TICK_CRITERI.md` è marcato
**"BOZZA, DA FIRMARE"**, e dentro dice che l'EA `ABTG_LondonFx.mq5` è
**"DA SCRIVERE"**. Dal **03/09**. 👉 Nessun cancello l'ha bocciato: manca
**una firma e un file di codice**.

### B) `SONDA OROLOGIO — RAMO FX` — pronta dal 28/08, **mai girata**
Sette file prova in `prove/` (gemelli, EURUSD L/S, GBPUSD L/S, XAUUSD L/S) e
**zero referti** in archivio. La caccia frequenza del 31/08 la chiamava:

> _"il solo meccanismo FX a tenuta di ore con frequenza >=1/giorno che il
> progetto possieda"_

Il **07/09 abbiamo girato il ramo INDICI** (verdetto: sul DAX l'orologio non
esiste) — **il ramo FX, quello nato per la frequenza, no.**

## 2. ⚖️ E I CANCELLI? Di cosa sono morti davvero i caduti

| caduto | causa reale |
|---|---|
| `M0PB` | **MORTO 12/12 alla sonda di CONTEGGIO** — non genera segnali. Non è un cancello severo: è un motore che non spara |
| `Chaos Lyapunov` | ingrediente LLE non promosso dall'**ablazione** |
| `CRT Turtle Soup` | senza edge a tick nel toro, **gate compreso** |
| `BreakinBox` | l'ablazione lo smaschera come **R95 con un livello nuovo** — già in casa |
| `RTH Confluence` / `London Signal B` | il cuore è un classificatore **mai pubblicato**: non riproducibili |

👉 Nessuno di questi è caduto per una soglia di merito troppo alta. Sono
caduti perché **non c'era niente sotto**, e in tre casi l'ha detto
un'**ablazione**, non un cancello.

## 3. ✅ DOVE CLAUDIO HA RAGIONE — e non è una concessione

Ha ragione su **due cose**, e tutte e due sono già misurate:

**a) Il merito SOSPESO non è una bocciatura, ed è la condizione NORMALE qui.**
La regola di casa sospende il merito sotto 150 operazioni. Con motori che
fanno 0,3-2 operazioni al giorno, **150 operazioni sono mesi**. Oggi stesso:
la sedia viva ORB ha 71 e 119 operazioni — **merito sospeso in tutte e due le
finestre**. Non le manca un cancello più largo: **le mancano operazioni.**

👉 E il posto dove si accumulano operazioni **esiste ed è gratis**: il
**DEMO PICCOLO 50503392**, che Claudio ha deciso il 07/09 di lasciare senza
Guardian proprio per *"vedere appieno come si comportano gli EA"*.
**Mettere in forward su demo una cella a merito sospeso non è chiudere un
occhio: è usare lo strumento giusto per un verdetto che il backtest non può
dare.** Costa zero euro. Il RISCHIO invece non si sospende mai — quello si
legge a qualunque n, e resta il cancello che non si tocca.

**b) La portata la fa la LARGHEZZA, non la velocità.** È la firma del 07/09,
misurata sul campo vero (3-5 EA × **26 simboli** = 0,29-0,47 op/giorno per
simbolo). 👉 **Non ci servono motori più veloci: ci servono i motori che
abbiamo GIÀ su più simboli.** E questa cosa **non l'abbiamo mai fatta**: le
sedie in campo stanno una per simbolo.

## 4. 🛤️ COSA FARE — in ordine, e nessuno di questi chiede un cancello più largo

1. **Firmare i criteri di `LONDONFX` R116 e scrivere `ABTG_LondonFx.mq5`.**
   È il candidato che ha passato, con 2,0-2,3 seg/giorno. Fermo da 4 giorni.
2. **Girare il ramo FX dell'orologio** — 7 celle pronte dal 28/08.
3. **Aprire la corsia DEMO a merito sospeso** sul piccolo 50503392: le celle
   che passano il RISCHIO ma non hanno n vanno lì ad accumulare operazioni,
   con un budget di tempo dichiarato e un criterio di uscita scritto prima.
4. **Allargare ai simboli** i motori già promossi, invece di cercarne di nuovi.

---

_Misurato su `REGISTRO_TEST.md` (1827 righe), `risultati_archivio/` e i
dossier di caccia. Ogni citazione ha il suo file._
