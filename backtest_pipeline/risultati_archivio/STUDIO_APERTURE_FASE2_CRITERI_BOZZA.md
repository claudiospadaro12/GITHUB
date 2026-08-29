# 📐 CRITERI FASE 2 — IL MOTORE DELLE APERTURE [BOZZA — DA FIRMARE]

> **Stato: BOZZA.** Scritta il 29/08 guardando SOLO il referto
> `LETTURA_ANATOMIA_APERTURE_2026-08-26.md` (FASE 1, IS 2010-2020 Nasdaq).
> La cassaforte 2021-2026 resta SIGILLATA finche' i criteri non sono firmati.
> Nessun motore, nessun numero, finche' Claudio non firma. Regola delle due fasi.

## 0) DA DOVE NASCE (il fatto misurato, non l'opinione)
L'anatomia FASE 1 ha misurato, su 2.569 giorni buoni, stabile anno per anno:

| classe | freq | payoff (MFE60:MAE60) |
|---|---|---|
| RIENTRO | 38,7% | ~1:1, **chiusura ≈ ZERO** |
| DRIVE-UP + DRIVE-DOWN | **~45%** | **5:1 / 6:1** |
| RANGE | 8,7% | 1:1 |
| FADE | ~7% | — |

Due fatti che decidono il disegno:
1. **La direzione nuda dei primi 15' e' una moneta** (persistenza 52,6% / 46,8%).
   L'informazione NON e' nel verso.
2. **Il gap non sposta le frequenze** alle soglie di casa. Non e' l'interruttore.

**Conseguenza gia' vera oggi**: il RETEST che gira in forward (DAX, PF 1,065)
raccoglie la struttura RIENTRO — payoff ~1:1 — ed e' per questo che l'edge e'
MODESTO. Il premio grosso (5-6:1) e' nel DRIVE. **La FASE 2 non ottimizza il
retest: prova a raccogliere il DRIVE.**

## 1) LA DOMANDA DELLA FASE 2 (una sola, onesta)
> **Esiste un FILTRO DI SELEZIONE, applicabile AL MOMENTO DELLA ROTTURA, che
> sposta la miscela verso i DRIVE (che tengono) e via dai RIENTRO (che
> rientrano) — abbastanza da rendere il drive-following un motore, non una
> moneta?**

Se la risposta e' NO (nessun filtro batte la moneta), il verdetto onesto e':
"il retest resta l'edge, il drive non e' raccoglibile meccanicamente" — e si
chiude, come ogni altra caccia. **Il filtro e' TUTTO**: senza, il
drive-following e' 45% vinte grosse contro 42% RIENTRO stoppati, e la
persistenza 52,6% dice che a nudo e' marginale.

## 2) LE FEATURE DI SELEZIONE DA TESTARE (congelate PRIMA dei numeri)
Ipotesi STRUTTURALI (non direzionali, non sul gap — entrambi esclusi dai fatti
§0). Ognuna e' un interruttore, si accende UNA alla volta (ablazione a stella):
- **F1 — Forza della rottura**: range della candela di rottura >= k x ATR.
  Ipotesi: una rottura decisa tiene piu' di una sfilacciata.
- **F2 — Ampiezza del range dei primi 15'**: OR stretto (< k x ATR) = rottura
  piu' pulita. Ipotesi: da un range compresso il DRIVE parte meglio.
- **F3 — Allineamento HTF**: la rottura concorda col trend H1/D1 (EMA o
  struttura). Ipotesi: il DRIVE che va col trend maggiore tiene di piu'.
- **F4 — Ora della rottura**: rottura precoce (entro N minuti dall'apertura)
  = piu' spazio per correre. [da misurare, non assunto]
- **[ESCLUSI per misura]**: direzione nuda (moneta, §0.1) e gap (§0.2).

Si dichiara PRIMA: quale/quali feature, con quali soglie k, e che si legge la
SUPERFICIE (altopiano, centro — mai il picco isolato), non la cella migliore.

## 3) IL BERSAGLIO DI DISEGNO (la forma del payoff, non la frequenza)
Il motore e' **drive-FOLLOWING**: entra sulla rottura selezionata, e la
gestione DEVE rispettare l'asimmetria misurata (coda lunga: DRIVE-DOWN Q3
0,90%, max 3,06%):
- **Runner obbligatorio**: non si cappa a 1R. Un pezzo corre verso la coda.
- **SL con PAVIMENTO OBBLIGATORIO** (lezione R109, congelata): mai
  `InpMinSLPts=0`. Lo stop deve sopravvivere al rumore del DRIVE (MAE ~0,11%)
  ma NON per forza al rientro del RIENTRO (MAE ~0,24%): e' proprio il RIENTRO
  che il filtro §2 deve ridurre. Se il filtro non lo riduce, lo stop stretto
  mangia le 42% RIENTRO e il motore non paga.
- **Costo**: su Nasdaq a 24.000, MFE mediano 0,53-0,64% = 125-155 punti indice
  contro spread 1-2 → c'e' spazio fisico. Il cancello costo si misura, non si
  assume (S0a con spread DICHIARATO se non misurato).

## 4) LA VALIDAZIONE (dove si giudica)
- **Due fasi, rigide**: i criteri e le soglie si congelano qui, guardando SOLO
  la FASE 1 (IS 2010-2020). La cassaforte **2021-2026** e' l'OOS: si apre UNA
  volta, dopo la firma.
- **Il 2023 con le pinze**: 22,9% giorni sospetti nella cassaforte. Il confronto
  OOS si fa ANCHE senza il 2023.
- **Tick BCM**: il payoff in punti si conferma a tick reali sulla finestra tick
  disponibile (dichiarare la profondita' vera; se non misurata, riserva).
- **Prova di regime**: la FASE 1 e' Nasdaq. Il motore, se regge, si prova anche
  su DAX/Dow (l'anatomia va rifatta o si assume per analogia? — DA DECIDERE in
  firma). L'IS 2010-2020 e' un mix di regimi: e' il suo pregio contro il "unico
  toro" che ha bocciato i fade.

## 5) CRITERI DI LETTURA (cosa decide, congelato)
- **DECIDE**: l'**aspettativa per trade** (non solo il PF), letta sulla
  cassaforte, con la coerenza fra sotto-periodi. Un motore che vive di una coda
  rara va guardato anche sulla peggior giornata e sulle perdite consecutive.
- **RISCHIO (mai sospeso, regola B)**: DD e peggior giornata contro il muro
  prop. Un drive-following stoppato spesso puo' avere un DD di frequenza: si
  misura.
- **CAMPIONE**: >= 150 trade OOS per giudicare il merito; sotto, merito sospeso.
  L'apertura fa ~1 setup/giorno per simbolo -> il campione c'e' su piu' anni.
- **VINCE la FASE 2** solo se un filtro §2 produce un'aspettativa per trade
  POSITIVA e STABILE sulla cassaforte (e senza-2023), con DD sotto il muro. Un
  solo periodo o un solo simbolo = non dimostrato.

## 6) COSA NON SI FA
- Niente motore, niente ottimizzazione, niente numeri PRIMA della firma.
- Niente griglia sulle soglie per inseguire un picco (Seconda Caccia).
- Non si tocca il forward: il RETEST vivo resta, la FASE 2 e' un round nuovo.

---
**[FIRMA CLAUDIO]**: quali feature §2 si testano (F1/F2/F3/F4, con che soglie),
se la prova di regime include DAX/Dow, e la conferma dei criteri di lettura §5.
Da qui nascono i file prova e la riga — non prima.
