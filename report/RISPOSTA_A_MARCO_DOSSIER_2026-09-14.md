# 🔍 Risposta al terzo documento di Marco — critica al NOSTRO dossier metodologico (14/09/2026)

Marco non ha criticato una strategia stavolta: ha criticato **il nostro
`DOSSIER_METODO_ABTG_2026-09-11.pdf`**, quello scritto per il Claude Code del
suo progetto. Quattro punti. Li ho verificati TUTTI contro il testo congelato
vero (pag. 2-3 del dossier), non contro il suo riassunto — per non ripetere
l'errore del 10/09 (classe "verifico che confermi, non che rompa").

## 1. 💰 Gate costo = solo spread, non costo pieno — CONFERMATO, gap vero

Testo congelato (dossier p.2): *"stop ≥40 × spread mediano dell'ora... Pavimento
duro: 13,3×"*. **40/3 = 13,33 esatto** — Marco l'aveva intuito senza vederlo,
ha indovinato. Il gate NON include la commissione. Sul suo conto la commissione
(0,50) supera lo spread (0,30): costo vero 2,87× lo spread da solo.

🟡 **Non e' una notizia nuova per noi** — `PIANO_CHALLENGE_OTTOBRE_v2.md` e
`CENSIMENTO_CONTRATTI` hanno gia' una colonna "stop/spr ALL-IN" che include la
commissione, usata in pratica altrove. **Ma il gate CONGELATO nel dossier
ufficiale resta spread-puro**: c'e' un buco fra il metodo scritto e la prassi.
Da riconciliare — proposta di Marco (rapporto costo-pieno/aspettativa-per-
operazione) e' ragionevole ma **e' un cambio di criterio firmato**, quindi
decide Claudio, non si cambia da soli.

## 2. 🔢 Campione IS/OOS — NON e' uno scambio di etichette, e' un'altra cosa

Testo congelato: *"Campione: n OOS ≥95 e n IS ≥57"*, letterale, verificato
pixel per pixel. Marco sospettava un'inversione (IS piu' grande di OOS, come
di consueto nel walk-forward). **Non e' uno scambio**: 95+57=152, coerente col
pavimento totale di 150 operazioni (§4.1), ed e' voluto — l'OOS porta il
verdetto di merito (PF≥1,40), quindi serve piu' potenza statistica LI'; l'IS
serve solo a scegliere la cella.

🔴 **MA verificandolo ho trovato un problema PIU' SERIO, non quello di Marco**:
il nostro stesso `CLAUDE.md` (regola "Emendamento della finestra", congelata
16/08) dice che l'IS **misurato** ha bisogno di **~190-256 operazioni** per
leggere un altopiano senza rumore (R70 con n=75-159: superficie frastagliata;
R71 con n=190-256: altopiano leggibile). Il gate "Campione" del dossier
richiede solo **IS≥57** — **meno di un terzo** di quanto la nostra stessa
misura empirica dice serve per selezionare la cella senza inseguire rumore.
**Due documenti nostri, congelati in date diverse, si contraddicono sulla
stessa soglia.** Questo e' un buco vero da portare a te, non una svista di
Marco.

## 3. 🏔️ Altopiano contro un null "vero" — proposta interessante, non pronta

Il dossier (§3.3) conferma: *"200.000 griglie casuali: zero pareggi
irrisolti"* — ma quella prova serve a validare la REGOLA DI SELEZIONE (che il
baricentro non ammetta due letture), **non** a costruire una distribuzione
nulla di "quanto puo' essere lungo un blocco contiguo per puro rumore, su un
motore senza edge". Sono due usi diversi della stessa macchina a griglie
casuali. Riusarla per il secondo scopo e' plausibile ma **va costruita**: non
l'abbiamo mai fatta girare cosi'.

## 4. 📉 DD senza Monte Carlo di riordino — QUI Marco ha ragione, e abbiamo GIA' l'attrezzo

Il gate "Rischio(OOS): DD ≤7,00%" nel dossier e' letto su **una sola
sequenza** — nessun riordino. Marco ha ragione a chiedere una distribuzione.
**E la notizia buona**: **l'attrezzo esiste gia' e funziona**, l'abbiamo
costruito per tutt'altro — `dd_portafoglio.py` / `mc_trailing.py`
(`REFERTO_M1_MC_TRAILING.md`, 18/08): rimescolo dei GIORNI INTERI (correlazione
same-day conservata), 2000 iterazioni, seed 42, validato al centesimo contro
la baseline nota. Oggi gira a **livello di portafoglio** (27 serie insieme,
p99 statico 8,51% a 0,65%). **Non e' MAI stato puntato su una singola cella**
per giudicare il gate OOS≤7% del funnel — sarebbe un riuso diretto dello
stesso script, non un lavoro nuovo da inventare.

---

## 📋 Sintesi per Claudio

| # | Trovato | Stato |
|---|---|---|
| 1 | Gate costo spread-puro (13,3×=40/3 esatto), gap col praticato ALL-IN altrove | 🟡 conferma, decisione tua se cambiare il gate firmato |
| 2 | Campione IS/OOS non e' uno scambio — MA c'e' una contraddizione vera fra dossier (IS≥57) e CLAUDE.md (IS misurato serve ≥190-256 per l'altopiano) | 🔴 buco vero, tuo da decidere |
| 3 | Null-distribution per l'altopiano — idea buona, macchina esiste ma per altro scopo | 🟢 da costruire, non urgente |
| 4 | DD Monte Carlo di riordino sul gate OOS≤7% — non fatto, ma script gia' pronto e validato | 🟢 azione a costo basso, proponibile subito |

**Niente di questo tocca un round gia' armato o un parametro in forward.**
Sono tutti cambi di CRITERIO, non di dato — quindi restano fermi finche' non
firmi tu.
