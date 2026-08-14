# PROVA DI REGIME — criteri scritti PRIMA dei dati (14/08/2026)

_Richiesta di Claudio: "rifacciamo i calcoli con qualche anno in piu', anche
quando il mercato era in fase calante, per capire se entrano altri EA o se
qualcuno deve uscire". Sono d'accordo: e' il test che oggi manca di piu'
(vedi `report/ASPETTATIVE_REALISTICHE.md`, "IL LIMITE DELLA FINESTRA"). Ma
un test cosi' puo' distruggere lavoro buono se i criteri si scrivono dopo
aver visto i numeri. Quindi si scrivono adesso, e non si spostano._

## 1. Cosa si testa (e cosa NON si tocca)

- Si testano **le celle GIA' PROMOSSE**, esattamente come sono: parametri
  **CONGELATI**, nessuna ottimizzazione, nessuna griglia. Una cella = un
  lancio.
- **Vietato** cercare parametri nuovi sui dati vecchi: sarebbe overfitting
  su una finestra piu' lunga, cioe' lo stesso errore con piu' anni.
- Perimetro: le famiglie con dati esterni affidabili (forex e metalli: BB,
  GAP, LARRY, COST, EasyTrend, PTE/SW forex). Gli INDICI entrano solo se
  il feed esterno passa la validazione (vedi punto 2).

## 2. Cancello ZERO: senza validazione del feed, non si guarda nulla

L'import produce un referto di sovrapposizione (differenza media fra le
chiusure H1 importate e quelle NATIVE di BCM nel periodo comune). Regola:

- differenza media > **2 points** su un cambio a 5 decimali, oppure
  meno dell'**80%** delle barre H1 in comune -> **il simbolo NON si usa**.
  Prima si sistema il feed (fuso, festivi, fonte), poi si misura.
- Il confronto di merito si fa **SEMPRE sullo stesso feed**: periodo
  calante vs periodo crescente **sui dati _EXT**, mai "_EXT 2022 contro
  BCM 2025". Spread e commissioni diversi rendono il confronto assoluto
  fra feed privo di significato; il confronto RELATIVO dentro lo stesso
  feed invece regge.

## 3. Le finestre (fissate ora)

| Finestra | Periodo | Che cos'e' |
|---|---|---|
| **ORSO** | 2022.01.01 - 2022.10.31 | mercato calante + inflazione: il buco vero del nostro campione |
| **CROLLO** | 2020.02.01 - 2020.04.30 | shock Covid: volatilita' estrema, gap, spread larghi |
| **TORO** | 2021.01.01 - 2021.12.31 | anno di riferimento crescente, per il confronto relativo |
| **LATERALE** | 2019.01.01 - 2019.12.31 | quarto contesto, se i dati arrivano fin li' |

## 4. I criteri di giudizio (congelati)

Per OGNI cella promossa, misurata a rischio 1% su 100k:

**A. SOPRAVVIVENZA (il minimo sindacale).** Nelle finestre ORSO e CROLLO
il drawdown non deve superare **il doppio** del DD misurato nella finestra
OOS originale, **e comunque mai il 20%**. Chi sfonda entrambe le finestre
avverse va **declassato**: peso dimezzato, oppure gli serve un filtro di
regime prima di tornare a peso pieno.

**B. TENUTA.** Nelle finestre avverse il PF deve restare **>= 0,90**.
Attenzione, e' un criterio di NON-SANGUINAMENTO, non di profitto:
**quasi tutte le nostre celle sono long-only**, ed e' NORMALE che un
long-only guadagni poco o niente in un mercato che scende. Bocciare un
long-only perche' non guadagna nell'orso sarebbe un errore di lettura;
bocciarlo perche' si distrugge, no.

**C. PROMOZIONE DI RANGO.** Chi nell'ORSO fa **PF >= 1,10** con DD dentro
il criterio A sale di rango: e' un motore che lavora in entrambi i regimi
-> priorita' in prop e candidato al peso pieno. **Questi sono gli EA che
cerchiamo davvero**, ed e' anche il modo per far entrare in squadra
qualcuno che oggi e' in panchina.

**D. REGOLA DEI DUE BANCHI.** Nessuna decisione (ne' uscita ne'
promozione) da UNA sola finestra: serve la stessa direzione in ORSO e
CROLLO. Un solo periodo avverso e' un aneddoto.

**E. RIPESCAGGI.** Le celle oggi in panchina o in osservazione (riserve
regime della fascia B, gap Dow/Nikkei, Easy Trend, EURGBP short) si
rimisurano con gli stessi criteri: se superano A e C, tornano in gioco
con un round di portafoglio dedicato — **non entrano per simpatia**.

## 5. Cosa questo test NON puo' fare

- Non rende i dati esterni buoni per TARARE: la taratura resta su BCM.
- Non copre gli indici se il feed non passa il cancello zero.
- Non trasforma 21 mesi in 8 anni di certezze: aggiunge **contesti**, non
  garanzie. Il DD peggiore possibile resta sconosciuto per definizione.
- Non sostituisce il forward: il vivaio continua per la sua strada.

## 6. Sequenza operativa

1. Import + referto di validazione (agente in corso).
2. Cancello zero su ogni simbolo: passa / non passa.
3. Lancio delle celle congelate sulle 4 finestre (round **R50**).
4. Tabella unica: cella x finestra -> Profit, PF, DD, n.
5. Verdetti secondo A-E, referto, e SOLO DOPO le decisioni su squadra e
   portafoglio.

## APPROVATO (Claudio, 14/08/2026)

> "Voglio fare i controlli del caso. Ci servono piu' anni. Ce la dobbiamo fare."

I criteri A-E sopra sono **CONGELATI da questo momento**. Non si spostano
per nessun motivo, nemmeno se i numeri faranno male a un EA a cui teniamo:
e' esattamente il momento in cui una regola scritta prima vale qualcosa.
Da qui in avanti ogni verdetto della prova di regime cita il criterio che
lo produce.
