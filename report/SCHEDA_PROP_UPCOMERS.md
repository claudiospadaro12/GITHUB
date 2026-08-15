# 🟣 SCHEDA PROP — Upcomers (15/08/2026)

_Nata da una pubblicità vista da Claudio: "Single Phase, 5% Target, 90% OFF,
100k a $115,90". Stessa istruttoria fatta il 13/08 su Funding Pips._

**Fonti**: [Responsible Trading](https://responsibletrading.com/prop-firm-reviews/upcomers-prop-firm-review/) ·
[TheTrustedProp](https://thetrustedprop.com/prop-firms/upcomers) ·
[MyPropGenius](https://mypropgenius.com/reviews/upcomers/) ·
[Trustpilot](https://www.trustpilot.com/review/upcomers.com) ·
[Myfxbook](https://www.myfxbook.com/reviews/prop-trading-firms/upcomers/3331623,1)

> ⚠️ **Tutto quello che segue viene da recensioni di terze parti, non dal
> regolamento ufficiale letto da noi.** Prima di qualunque acquisto va
> confermato PER ISCRITTO dal supporto, come da regola D3: niente acquisti
> prima delle risposte scritte.

---

## 0. Chi sono

UAE (Dubai), entita' legale **Royal Flow - FZCO**, partita **fine 2024**.
Scaling dichiarato fino a 2,5 milioni. **Meno di due anni di storia**: non c'e'
un ciclo di mercato completo da guardare, ne' uno storico lungo di payout.

## 1. 🔴 IL KILLER NUMERO UNO: il drawdown e' TRAILING

> _"Upcomers uses **trailing drawdowns that shift with your equity** and lock
> at break-even"_

**Questo da solo invalida tutte le nostre misure di rischio.**

Il Guardiano sul 100k (`DEPLOY_GUARDIANO_100K.md`) e tutte le simulazioni
Monte Carlo del portafoglio sono su **drawdown STATICO dal deposito**: p50
5,74% · p95 9,89% · **p99 12,47%** su 27 serie, che a taglia 0,65% diventa
~8,1%.

Con un DD **trailing sull'equity**, ogni nuovo massimo alza il pavimento: la
distanza dal muro non e' piu' "quanto ho perso dal deposito" ma "quanto ho
restituito dal picco". Sono due numeri diversi, e il secondo e' sempre peggiore
per una curva che sale a scalini come la nostra.

**Non sappiamo se passeremmo.** Non perche' sia difficile: perche' **non l'
abbiamo mai calcolato**. Vedi §5.

## 2. 🔴 Le regole che mordono proprio noi

| regola riportata | perche' ci riguarda |
|---|---|
| **Cap di rischio per trade 1,5%–3%** | giriamo a 0,65%, quindi larghi. **Ma** il 29/07 due EA hanno aperto lo stesso segnale nello stesso secondo (`CENSIMENTO_ORDINI_PC.md` §3) e R51 ha misurato una peggior giornata a **2,06%**. Se il cap somma le posizioni nella stessa direzione — come fa Funding Pips entro 10 minuti — ci tocca. |
| **"Best day rule"**: se un giorno pesa troppo sul profitto totale, il payout puo' essere negato | 27 serie con code MC vuol dire che **una giornata grossa e' statisticamente attesa**, non un'anomalia. Regola soggettiva applicata al momento di pagare. |
| **Profit target 8–10%** secondo le recensioni | la pubblicita' dice **5%**. Delle due l'una: o il 5% e' di un programma specifico, o la grafica e' ottimista. **Da chiarire per iscritto.** |
| Primo payout limitato a **$500** | non e' un problema, ma va saputo. |
| Inattivita' 35 giorni = conto chiuso | irrilevante per noi: operiamo ogni giorno. |
| Split 80% (evaluation) / 60% (instant), 99% su alcuni conti nuovi | lo split e' l'ultima cosa che conta se il payout viene negato. |

## 3. 🚨 Il punto piu' grave: i payout negati con motivazioni soggettive

Piu' recensioni Trustpilot descrivono **revisioni di conformita' soggettive**,
con payout rifiutati per **"one-sided betting"**, **"gambling behavior"**,
**"tick scalping"** — etichette **non definite in anticipo** nel regolamento.

Questo e' il rischio che non si misura e non si assicura. E ci riguarda in
modo diretto: il DAX Apertura fa **un trade al giorno, alla campanella, su un
lato solo**. "One-sided betting" e' esattamente il tipo di etichetta che un
revisore puo' appiccicare a una strategia direzionale d'apertura.

Non sto dicendo che lo farebbero. Sto dicendo che **la regola scritta non ci
protegge**, perche' la regola non e' scritta.

## 4. 💸 Sullo sconto del 90%

$115,90 invece di $1.159 non e' un affare da valutare: e' un'informazione sul
**modello di business**. Un'azienda che vende a un decimo del listino guadagna
sulla **vendita delle challenge**, non sui payout. Piu' basso il prezzo, piu'
il conto economico dipende da quanti clienti falliscono.

Non e' una prova di disonesta' — e' il motivo per cui le regole soggettive del
§3 pesano piu' di quanto peserebbero altrove.

## 5. ✅ IL LAVORO CHE VALE COMUNQUE, E COSTA ZERO

Qualunque cosa si decida su Upcomers, **una cosa va fatta e non l'abbiamo mai
fatta**:

> ### Rifare la Monte Carlo del portafoglio con DRAWDOWN TRAILING invece che statico.

Serve per **qualunque** prop moderna, non solo per questa: il trailing e' lo
standard oggi. E' un calcolo su dati che abbiamo gia', non serve comprare
niente, e risponde alla domanda vera: **con che rischio per trade passeremmo un
10% trailing con il 99% di confidenza?**

Finche' quel numero non c'e', comprare una challenge col trailing e' comprare
un biglietto per una gara di cui non conosciamo il percorso.

## 6. E il contesto di stanotte, che pesa piu' di tutto il resto

La regola madre del progetto: **prop pagata solo dopo forward maturo**. D3 e'
in pausa **per decisione di Claudio del 13/08** ("prima 1-2 settimane di
forward del vivaio nuovo").

E stanotte abbiamo scoperto che **quel forward era contaminato**: dal 22/07 il
conto piccolo andava letto **+134,86** e non −340,70, perche' −475,56 erano del
PC fantasma (`CENSIMENTO_ORDINI_PC.md`). Il rubinetto e' chiuso dal 14/08.

**Vuol dire che il forward PULITO comincia adesso, non due settimane fa.**
La settimana di dati su cui volevamo decidere non esiste ancora.

---

# ⚖️ RACCOMANDAZIONE

> **NO adesso.** Non per i 115 dollari — quelli sono niente. Per tre motivi
> nell'ordine:
>
> 1. il **trailing DD** rende non applicabili tutte le nostre misure di
>    rischio, e il ricalcolo si fa **gratis, prima**;
> 2. **"best day rule" + payout negati soggettivamente** sono un rischio che
>    non si misura, e colpisce esattamente le strategie direzionali
>    d'apertura come le nostre;
> 3. il **forward pulito comincia oggi**: comprare una challenge adesso vuol
>    dire correre su dati che abbiamo appena scoperto sporchi.

**Cosa fare invece, in ordine, e tutto a costo zero:**

1. **Mandare le domande scritte** (adattando `DOMANDE_SUPPORTO_PROP.md`),
   chiedendo per iscritto: (a) il DD e' trailing su equity o statico, e si
   blocca al break-even a quale soglia; (b) il cap per trade somma posizioni
   di EA diversi nella stessa direzione, e in che finestra; (c) la
   definizione ESATTA di "best day rule" e "one-sided betting"; (d) se un
   portafoglio multi-EA completamente automatico e' ammesso. **La risposta —
   o la non-risposta — dice piu' della pubblicita'.**
2. **Rifare la MC col trailing** (§5).
3. **Due settimane di forward pulito** dal 15/08.
4. Solo allora, se i tre passi sono verdi, si decide se pagare.

E la promozione "90% OFF a tempo limitato" torna. Torna sempre.
