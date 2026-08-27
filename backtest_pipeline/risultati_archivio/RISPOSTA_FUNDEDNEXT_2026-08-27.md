# 📬 RISPOSTA SCRITTA DI FUNDEDNEXT — 27/08/2026 00:16 (Zoe Castillo, support@fundednext.com)

_Risposta alla mail di Claudio delle 23:56 del 26/08 (5 domande,
Stellar 2-Step 200k). Fonte: .eml originale girato da Claudio, DKIM
fundednext.com PASS. Da qui in avanti queste righe sono **[RISPOSTA
SCRITTA]** — il rango più alto delle fonti del dossier, sopra le FAQ._

## Le cinque risposte, testuali in sintesi

1. **Fee add-on EA (200k)**: **$30, una tantum al checkout**, niente per
   fase/rinnovo, niente costi ricorrenti. → _Il buco della fee si chiude:
   trascurabile._
2. **Leva Stellar 2-Step — "would be this for BOTH Challenge and
   FundedNext Account"**: Forex **1:100** · **Indici & Commodities
   1:15** · Crypto 1:1. **Margin call al 100%.**
   → 🔴 **La lettura del dossier (1:25 in challenge) è SMENTITA dalla
   risposta scritta: gli indici sono 1:15 ANCHE in challenge.** E
   "Commodities 1:15" copre l'oro.
3. **Volumi**: **nessun limite di lotti** per ordine o per simbolo,
   finché si sta dentro margine e limiti di rischio.
4. **Multi-conto**: **"you cannot run your EA across two separate 200k
   accounts."** Tetto aggregato d'acquisto **$300k per trader E per
   strategia EA**. Il tetto NON limita la crescita del singolo conto via
   Scale-Up (fino a $4M).
5. **Ciclo Scale-Up**: definito dai cicli di prelievo. Primo scatto:
   **4 Performance Rewards in minimo 2 mesi, crescita ≥4% per ciclo,
   ultimo ciclo in profitto → balance +25%.**

## ⚖️ COSA CAMBIA NEL QUADRO

- 🔴 **Il vantaggio-leva di FundedNext NON ESISTE**: 1:15 sugli indici
  in tutte le fasi = lo stesso muro di margine di FTMO. Il problema n.1
  scoperto dall'ANALISI_TAGLIA (basket C1 = 149% del margine ai massimi
  / 84% alle mediane a 1:15) vale IDENTICO qui. La Q1 del dossier
  ("FTMO misurabile vs FundedNext clausola") si scioglie così: **sono
  uguali sul fronte indici; resta aperta solo l'ambiguità oro di FTMO.**
- 🟢 Tre buone notizie vere: fee EA irrisoria; **zero tetti di lotti**
  (il vincolo di volume di R109 sul broker prop qui non esiste — resta
  solo il margine); **margin call al 100%** dichiarato.
- 🟡 Multi-conto: il no è esplicito e scritto — a FundedNext si compra
  **UN conto** (200k) e si cresce solo via Scale-Up. Niente 2×200k.
- 🟡 Ciclo Scale-Up ora definito: 2+ mesi e 4 payout per scatto del 25%.
  Più lento di quanto sperato, più veloce di FTMO (che chiede 10%/mese
  per 4 mesi consecutivi).

## ➡️ LA MOSSA CHE QUESTA RISPOSTA SBLOCCA (proposta FASE 2)

Il tester MT5 ha il campo `Leverage` nell'.ini: **la prova della taglia
FASE 2 può girare il banco a `Leverage=15`** e MISURARE direttamente
quali ordini verrebbero rifiutati per margine, con la flotta com'è —
invece di stimarlo con l'aritmetica. È la misura che decide quali sedie
salgono sul conto prop (a qualunque prop, visto che 1:15 è lo standard).
Da disegnare con criteri propri.
