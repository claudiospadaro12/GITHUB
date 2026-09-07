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

### A) ~~`LONDONFX` — HA PASSATO, ed è fermo a "criteri da firmare"~~
### 🔴 A) **QUESTA VOCE ERA SBAGLIATA. CORRETTA IL 07/09, ORE 16:50.**

**Cosa avevo scritto:** che `LONDONFX` aveva passato il passo 0 il 03/09 e che
era **fermo** su *"criteri da firmare"* con l'EA *"da scrivere"* — cioè un
candidato buono parcheggiato per una firma mancante.

**Cosa dicono davvero i file.** Avevo letto `LONDONFX_TICK_CRITERI.md`, che è
una **bozza delle 09:25**, e mi ero fermato lì. I file in
`risultati_archivio/r116_londonfx/` sono **dello stesso pomeriggio**:
`CORSA_EURUSD_2026-09-03_1751_BOCCIATA.txt`. 👉 **L'EA è stato scritto e la
corsa è stata fatta, otto ore dopo la bozza.** E il verdetto è:

| motore | E in R | PF OOS | **DD OOS** | n IS / OOS | esito |
|---|---:|---:|---:|---:|---|
| canale nudo | −0,0690 | 0,898 | **45,29%** | 928 / 1325 | 🔴 BOCCIATA PER RISCHIO |
| **canale + RSI** (il promuovibile) | −0,1078 | **0,843** | **37,14%** | 470 / 662 | 🔴 BOCCIATA PER RISCHIO |
| allineamento 5 medie | −0,0517 | 0,923 | **31,26%** | 539 / 804 | 🔴 BOCCIATA PER RISCHIO |

**Non è parcheggiato: è morto, ed è morto bene.** Con **n OOS 662** il merito
non era nemmeno sospeso, e perde in **tutte e due** le finestre (IS profit
−36.353,98, PF IS 0,795).

### ⚖️ E QUESTO ROVESCIA UNA PARTE DELLA TESI — nel senso che la rafforza

Il vincitore della missione frequenza, quello con **2,0-2,3 segnali/giorno**,
è arrivato in fondo all'imbuto **con campione pieno** e ha fatto un
**drawdown del 37%**.

👉 **Nessun allentamento di cancello lo avrebbe salvato**, perché non è stato
fermato da una soglia di merito: è stato fermato dal **RISCHIO**, e il rischio
si legge a qualunque n. Allentare avrebbe messo davanti a una challenge un
motore da 37% di DD, cioè **quasi quattro volte il muro del 10%**.

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

1. ~~Firmare i criteri di `LONDONFX`~~ — **CADUTA**: la corsa c'è già ed è
   BOCCIATA PER RISCHIO su tutti e tre i motori (vedi §1A corretto).
2. **Girare il ramo FX dell'orologio** — 7 celle pronte dal 28/08, zero referti.
3. **Aprire la corsia DEMO a merito sospeso** sul piccolo 50503392: le celle
   che passano il RISCHIO ma non hanno n vanno lì ad accumulare operazioni,
   con un budget di tempo dichiarato e un criterio di uscita scritto prima.
4. **Allargare ai simboli** i motori già promossi, invece di cercarne di nuovi.

---

_Misurato su `REGISTRO_TEST.md` (1827 righe), `risultati_archivio/` e i
dossier di caccia. Ogni citazione ha il suo file._
