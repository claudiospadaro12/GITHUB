# 🩹 PATCH **PROPOSTA** — `ABTG_Guardian.mq5`, dopo il breach del 18/09

🔴 **NIENTE DI QUESTO È APPLICATO.** Nessun EA in campo è stato toccato, nessun preset
modificato, `coda/CODA.txt` intatto. Questo file è **materiale per una firma**, non un
lavoro fatto.
📖 Riferimento: `report/IL_GUARDIAN_CONTRO_LA_REGOLA_CHE_CI_HA_UCCISI_2026-09-18.md`.

✋ **Nessuna di queste proposte cambia un parametro di rischio.** Le tre proposte sono:
**(P1)** casi di collaudo nuovi · **(P2)** rendere collaudabile una decisione già esistente ·
**(P3)** chiudere un fail-open. I **numeri** (soglia giornaliera, ora di reset) restano
esattamente come sono: li decide Claudio, e **in questo file non c'è nessuna riga che li
cambi**.

---

## P1 — 🧪 I CASI DEL BREACH, da aggiungere a `AutotestBaselineGiorno()`

**Dove**: `mql5/Experts/ABTG_Guardian.mq5`, dopo la **r.337** (fine del gruppo F) e
**prima** della r.339 (il marcatore del conteggio).
**Effetto sul comportamento in campo**: **ZERO**. `AutotestBaselineGiorno()` gira solo con
`InpAutotest=true` (r.174, default `false`) e non tocca il conto.
⚠️ **Il marcatore della r.339 va aggiornato da 22 a 28**, altrimenti la stringa mente.

```mql5
   //--- G) IL CASO DEL BREACH DEL 18/09/2026 -- FundedNext Stellar Lite 100k,
   //    conto 12061434. I numeri sono VERI e vengono dalla mail di breach
   //    (report/BREACH_FUNDEDNEXT_2026-09-18.md r.13-14): perche' e' esattamente
   //    la situazione che i 22 casi precedenti NON descrivevano -- la baseline
   //    piu' alta collaudata era 100.500 (+0,5%), questa e' +3,26%.
   //    Il conto era in GUADAGNO: e' morto sulla regola giornaliera, non sul DD.
   double balG=103258.16, eqG=103258.16;   // al reset, flottante zero
   double startG=100000.0;                 // InpStartBalance del preset vivo

   // G1) la baseline e' il riferimento di INIZIO GIORNATA, mai il saldo iniziale:
   //     con una base statica la perdita del giorno sarebbe stata 951, non 4209.
   ABTG_AutotestCaso("breach 18/09: baseline modo 0 = 103258.16 (NON il saldo iniziale 100000)",
                     BaselineUguale(BaselineGiorno_Calc(balG,eqG,0),103258.16),true,falliti);

   // G2) a flottante zero i tre modi devono coincidere: se un giorno divergono
   //     qui, qualcuno ha cambiato il significato della baseline.
   ABTG_AutotestCaso("breach 18/09: a flottante zero i tre modi danno lo STESSO numero",
                     (BaselineUguale(BaselineGiorno_Calc(balG,eqG,0),BaselineGiorno_Calc(balG,eqG,1)) &&
                      BaselineUguale(BaselineGiorno_Calc(balG,eqG,1),BaselineGiorno_Calc(balG,eqG,2))),true,falliti);

   // G3) il PAVIMENTO della prop col suo 4% (Lite): 103258.16 - 4000 = 99258.16
   ABTG_AutotestCaso("breach 18/09: pavimento PROP (4% di 100000) = 99258.16",
                     BaselineUguale(BaselineGiorno_Calc(balG,eqG,0)-0.040*startG,99258.16),true,falliti);

   // G4) il NOSTRO pavimento col preset vivo (4,9%): 98358.16, cioe' 900 SOTTO.
   //     Questo caso NON approva il 4,9: lo MISURA. Se un giorno il preset
   //     cambiera', questo caso va riscritto insieme -- ed e' voluto.
   ABTG_AutotestCaso("breach 18/09: pavimento NOSTRO a 4,9% = 98358.16 (900 SOTTO il loro)",
                     BaselineUguale(BaselineGiorno_Calc(balG,eqG,0)-0.049*startG,98358.16),true,falliti);

   // G5) all'equity del breach (99048.73) la soglia a 4,9% NON e' raggiunta:
   //     il Guardian sarebbe arrivato DOPO. Il caso e' scritto con atteso FALSE
   //     apposta: documenta un comportamento vero e sgradevole, non un augurio.
   ABTG_AutotestCaso("breach 18/09: a 99048.73 il blocco a 4,9% NON scatta (arriviamo DOPO la prop)",
                     ((103258.16-99048.73) >= 0.049*startG),false,falliti);

   // G6) ...mentre il muro del 4% e' gia' sfondato di 209,43.
   ABTG_AutotestCaso("breach 18/09: a 99048.73 il muro PROP del 4% e' GIA' sfondato",
                     ((103258.16-99048.73) >= 0.040*startG),true,falliti);
```

📌 **Perché G5 ha `atteso=false`**: un autotest serve a **fotografare** il comportamento,
non a certificare che sia desiderabile. Se domani qualcuno cambiasse `InpDailyLossPct`,
**G5 fallirebbe e lo direbbe** — che è esattamente il segnale che si vuole.

---

## P2 — 🔬 RENDERE COLLAUDABILE LA DECISIONE CHE OGGI NON LO È

**Il problema misurato**: la decisione che ci protegge è scritta **in linea** dentro
`OnTimer` (**r.738**, **r.742**, **r.745**, **r.750**) e **nessun autotest la raggiunge** —
né i 22 del Guardian né i 159 dell'include. Stessa cosa per `PropDayKey()` (**r.199-205**),
che oltre a non essere pura ha un **gemello diverso** già collaudato nell'include
(`ABTG_InizioGiornoServer_Calc`, r.1944-1949): due implementazioni dello stesso concetto,
una sola provata.

**Proposta**: estrarre due funzioni **pure**, senza cambiare una virgola del
comportamento — le righe di `OnTimer` diventano chiamate.

```mql5
//+------------------------------------------------------------------+
//| PURA -- sfondamento del muro GIORNALIERO. Stessa identica         |
//| aritmetica delle r.738/742/750 di oggi, solo estratta.            |
//|   pavimento = dayStart - pct/100*gStart                           |
//| Il confronto resta >= (come oggi): tocca il muro = sfondato.      |
//+------------------------------------------------------------------+
bool SforaGiornaliero_Calc(const double dayStart,const double eq,
                           const double pct,const double gStart)
  {
   if(gStart<=0 || pct<=0) return(false);        // spento = no-op, come tutto il resto
   return((dayStart-eq) >= (pct/100.0*gStart));
  }

//+------------------------------------------------------------------+
//| PURA -- la chiave del giorno prop. Copia esatta di PropDayKey(),  |
//| con l'orologio passato da fuori invece che letto da TimeCurrent().|
//| Aggiunta la protezione dell'input che oggi ha solo NextResetTime()|
//| (r.215): senza, le due funzioni divergono a input fuori scala.    |
//+------------------------------------------------------------------+
int PropDayKey_Calc(const datetime t,const int ora_reset)
  {
   int h=ora_reset; if(h<0) h=0; if(h>23) h=23;
   return(DayKey(t-(datetime)h*3600));
  }
```
e poi, **senza toccare nient'altro**:
- r.750 → `bool breachDaily = SforaGiornaliero_Calc(dayStart,eq,InpDailyLossPct,gStart);`
- r.204 → `return(PropDayKey_Calc(TimeCurrent(),InpDailyResetHour));`

**Casi di collaudo che questo sblocca** (oggi impossibili da scrivere):
```mql5
   //--- H) IL MURO GIORNALIERO, con i numeri del 18/09
   ABTG_AutotestCaso("muro 4,0%: a 99258.16 sfonda ESATTAMENTE sul bordo",
                     SforaGiornaliero_Calc(103258.16,99258.16,4.0,100000.0),true,falliti);
   ABTG_AutotestCaso("muro 4,0%: a 99258.17 (un centesimo sopra) NON sfonda",
                     SforaGiornaliero_Calc(103258.16,99258.17,4.0,100000.0),false,falliti);
   ABTG_AutotestCaso("muro 4,9%: all'equity del breach vero NON sfonda",
                     SforaGiornaliero_Calc(103258.16,99048.73,4.9,100000.0),false,falliti);
   ABTG_AutotestCaso("pct 0 = spento -> non sfonda mai, nemmeno a conto azzerato",
                     SforaGiornaliero_Calc(103258.16,0.0,0.0,100000.0),false,falliti);

   //--- I) LA FINESTRA DI DISALLINEAMENTO (l'errore che il 18/09 non abbiamo
   //    potuto escludere). 18/09/2026 e' il giorno 261 dell'anno.
   MqlDateTime g; g.year=2026; g.mon=9; g.day=18; g.min=0; g.sec=0;
   g.day_of_week=0; g.day_of_year=0;
   g.hour=22; datetime t2230=StructToTime(g)+30*60;   // 22:30 BCM
   g.hour=23; datetime t2330=StructToTime(g)+30*60;   // 23:30 BCM
   ABTG_AutotestCaso("reset 23: alle 22:30 BCM siamo ANCORA nel giorno prop di IERI",
                     (PropDayKey_Calc(t2230,23)!=PropDayKey_Calc(t2330,23)),true,falliti);
   ABTG_AutotestCaso("reset 22 (fuso FundedNext): alle 22:30 il giorno e' GIA' girato",
                     (PropDayKey_Calc(t2230,22)==PropDayKey_Calc(t2330,22)),true,falliti);
   ABTG_AutotestCaso("input fuori scala (99) -> si comporta come 23, non come 99",
                     (PropDayKey_Calc(t2230,99)==PropDayKey_Calc(t2230,23)),true,falliti);
```
🔴 **I due casi del gruppo I sono la fotografia dell'ora di scarto**: con `23` i due
istanti stanno in **giorni prop diversi**, con `22` nello **stesso**. Se un giorno il
preset cambierà, questi casi lo diranno da soli.

---

## P3 — 🕳️ IL FAIL-OPEN DELLA BASELINE PERSA (r.714-716)

**Il difetto**: `if((int)GlobalVariableGet(GV_DAYKEY)!=pk)`. Se le GlobalVariable
spariscono **a metà giornata** (terminale nuovo, cartella dati diversa, pulizia da F3),
`GlobalVariableGet` torna **0**, la condizione è vera, e la baseline viene **ri-catturata
all'equity corrente**: 🔴 **la perdita della giornata si azzera in silenzio**, senza una
riga che distingua "giorno nuovo" da "variabile persa".

**Proposta minima — non cambia nessuna soglia, aggiunge una riga di giornale:**
```mql5
   int pk=PropDayKey();
   bool giorno_noto=GlobalVariableCheck(GV_DAYKEY);
   if(!giorno_noto || (int)GlobalVariableGet(GV_DAYKEY)!=pk)
     {
      double base=BaselineGiorno_Calc(bal,eq,InpDailyBaseline);
      // ... tutto il resto IDENTICO a oggi ...
      if(!giorno_noto && TimeCurrent()-gAvvio>120)
         PrintFormat("[GUARDIAN] *** BASELINE RI-CATTURATA A META' GIORNATA (%.2f): la chiave "
                     "del giorno era SPARITA, non e' un giorno nuovo. La perdita gia' fatta "
                     "OGGI e' stata DIMENTICATA dal nostro contatore -- la prop invece la "
                     "sta ancora contando. Verificare a mano il margine residuo.",base);
     }
```
👉 **Non ripara il buco: lo rende VISIBILE.** Ripararlo davvero (persistere la baseline su
file, o ricostruirla dallo storico deal del giorno) è un lavoro più grosso e va deciso a
parte. ⚠️ Richiede una variabile globale `gAvvio` (l'istante di `OnInit`), per non urlare
al primissimo avvio su un terminale pulito — che è un caso legittimo.

---

## 🚦 COSA SERVE PRIMA DI TOCCARE IL CODICE

| # | prerequisito | chi |
|---|---|---|
| 1 | 🔴 **Il riferimento FundedNext è l'APERTURA o il MASSIMO del giorno?** (§4 del referto) — se è il massimo, P1/P2 vanno riscritti e il difetto è **strutturale**, non un input | **Claudio**, dalla dashboard: saldo/equity di apertura del 18/09 |
| 2 | 🔴 Il regolamento **Stellar Lite** letto alla fonte (il 4% oggi viene dalla mail, non dalle regole) | **Claudio** (le pagine ci rispondono 403) |
| 3 | 🔴 **Quale binario gira davvero** sul 100k `50504263` (in campo 16 input, a HEAD 19) | misura sul VPS, **sola lettura** |
| 4 | ⚠️ Il comportamento **invernale** di BCM (il valore dell'ora cambia dal 25/10) | misura di 2 minuti lunedì **26/10** |
| 5 | ✍️ **Le firme di Claudio**: valore di `InpDailyLossPct`/`InpDailyPausePct` per prodotto, e `InpDailyResetHour` per prodotto | **solo Claudio** |

🚦 E vale **IL CANCELLO**: niente di questo esce verso il VPS senza il PASS di
`controlla_riga.py` **e** dell'agente `controllo-preventivo`.

---

*Proposta scritta il 18/09/2026. Zero righe applicate. Zero parametri di rischio decisi.*
