# ✍️ FIRMA DEL 21/09/2026 — **la taglia resta al 2,00%**

Testuale, dopo aver visto i numeri: _**"PROVO COSI"**_.

---

## ① 🖊️ COSA E' STATO DECISO
**Le sei sedie FTMO restano a `InpRiskPercent=2.00`** (PostNews a 1,30). Nessun cambio di
taglia, nessuno spegnimento.

🟢 **E' una decisione presa CON i numeri sul tavolo, non senza**, ed e' questo che la rende
diversa da un azzardo. Claudio ha visto, prima di firmare:

| | |
|---|---|
| Monte Carlo sull'ordine dei giorni | 🔴 **12,4%** delle sequenze arriva al muro a 2,00% · **1,7%** a 1,00% |
| il prezzo dell'alternativa | dimezzare costa **~1 mese** in piu' su Step 1 — **e FTMO non ha limite di tempo** |
| la rete | il Guardian chiude tutto a **72.560 EUR** (9,3% STATICO), il muro FTMO e' a **72.000** |
| il margine fra le due | **560 EUR = 0,70%** |
| la frequenza vera della flotta | **2,68 op/giorno**, non 1 |

📌 **E una cosa che va scritta perche' era un mio errore di comunicazione**: il DD di
contratto di `771531` @2,00% (15,66%, 16,7-17,4% coi costi) **non e' il rischio del conto**.
E' un numero di backtest in un mondo senza Guardian. In campo la corsa si ferma al **9,3%
statico**. 🔴 Il che pero' non e' una salvezza: a −9,3% la challenge e' finita lo stesso,
perche' resterebbe **0,70% di spazio** e servirebbe **+10%** da li'. Il Guardian trasforma
*conto bruciato* in *conto morto* — importantissimo (niente violazione a referto), ma non
riporta in gara.

---

## ② 🔴 COSA CAMBIA, ADESSO CHE LA TAGLIA E' FIRMATA
**Il Guardian non e' piu' una cintura: e' L'UNICA rete.** Al 2,00% la differenza fra
finire la challenge e bruciarla passa **tutta** da lui. Quindi da oggi:

1. 🔎 **Le sue vie di fuga vanno verificate, non assunte.** Il referto
   `report/DD_PORTAFOGLIO_FTMO_2026-09-20.md` ne ha gia' dichiarate tre (**B1** il cap non
   vede il realizzato · **B2** i pendenti LIMIT lo scavalcano · **B3** fail-open) e finora
   erano note **teoriche**. Adesso sono **il perimetro della decisione**.
2. 📏 **Il margine da 560 EUR va misurato contro lo slippage di chiusura**: il Guardian
   chiude **tutte** le posizioni insieme (`InpCloseAllMagics=true`). Se lo slippage su quelle
   chiusure simultanee supera 560 EUR, si passa il muro **mentre si sta salvando il conto**.
   `[NON MISURATO]`.
3. 🛡️ **Le sei soglie di revisione restano quelle @2,00%** gia' scritte in
   `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`, coi tre modi di leggerle.
4. 📊 **La pagella serale deve riportare ogni giorno tre numeri**: equity · distanza da
   **72.560** (linea del Guardian) · distanza da **72.000** (muro FTMO).

---

## ③ 🚪 LA PORTA CHE RESTA APERTA, e non e' un ripensamento
Sul tavolo e' rimasta una **terza via mai calcolata**: taglia **non uniforme**. `771531` e'
la sedia che porta il drawdown; `770101` e `770411` **non peggiorano nemmeno coi costi**.
👉 Si puo' tenere il 2% dove il DD e' piccolo e scendere dove e' grosso — **stesso ritorno
atteso, meno coda sinistra**. Costo: un'ora di lavoro, **zero round**.
🟢 Non e' una proposta di cambiare idea: e' un'opzione che resta sul tavolo se il forward
dovesse avvicinarsi alle soglie.
