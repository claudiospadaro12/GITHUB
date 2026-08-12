# SCHEDA SECONDA PROP — studio regolamenti (D3, avviato 12/08)

**Perche'**: la strategia decisa e' stesso portafoglio su DUE DITTE
DIVERSE (mai 5+5, mai due conti sulla stessa ditta). FTMO e' il metro
di paragone (il 100k dry-run simula i SUOI limiti: 10% totale, 5%
giornaliero, statici). La seconda ditta va scelta ADESSO con lo studio,
ma si compra SOLO dopo il forward maturo (regola 30/07, invariata).

**Come si usa**: una copia del blocco qui sotto per ogni ditta
studiata. Claudio legge il regolamento (telefono/poltrona), risponde
alle domande, Claude incrocia con le esigenze della flotta. Screenshot
dei passaggi ambigui -> si valutano insieme.

---

## Le 7 domande — e cosa ci serve sentire

**1. EA permessi senza restrizioni?**
   - Cerca: "Expert Advisor", "automated trading", "copy trading".
   - Ci serve: EA ammessi senza lista di divieti vaghi.
   - 🚩 Bandiere rosse: divieto di "copiare trade fra conti" scritto in
     modo largo (noi avremo GLI STESSI trade su due ditte: dev'essere
     chiaro che vietano il copy fra conti DELLA STESSA ditta, non la
     stessa strategia altrove); divieto di "HFT/tick scalping" scritto
     cosi' vago da poter colpire qualsiasi EA.

**2. Limiti di perdita: statici o trailing?**
   - Ci serve: daily loss e max drawdown STATICI (come FTMO). Il nostro
     Guardian e le tarature (0,65% -> p99 ~9,4%) sono costruiti su
     pavimenti fissi.
   - 🚩 TRAILING drawdown (il tetto sale coi profitti): cambia TUTTO il
     dimensionamento — se la ditta e' trailing, o si scarta o si
     ri-tara il Guardian sul peggiore dei due mondi.
   - Annota i numeri esatti: daily %, totale %, su equity o balance,
     a che ora resetta il "giorno" (fuso!).

**3. News trading permesso?**
   - I nostri EA NON filtrano le news per scelta (misurato: il filtro
     non paga). Se la ditta vieta di operare N minuti attorno alle news
     ad alto impatto SUL CONTO FINANZIATO, per noi e' un problema vero:
     il DAX/Dow aprono spesso vicino a dati macro.
   - Ci serve: nessuna restrizione news, o restrizione solo su
     "aprire posizioni nei 2 minuti attorno" (da valutare col
     calendario delle nostre aperture).

**4. Notturno e weekend?**
   - MaxMin DAX lavora 23:00-05:00 server, l'oro 22:00-07:00: ci serve
     trading notturno libero.
   - Posizioni overnight/weekend: la flotta chiude quasi tutto in
     giornata (flat 17:30/21:45), ma verificare comunque il divieto di
     holding weekend (STREV H2 e vivaio H1/H2 possono tenere qualche
     ora in piu').

**5. Consistency rules (regole di coerenza)?**
   - Cerca: "consistency", "max % of profit from single day/trade".
   - 🚩 Se un solo giorno non puo' superare il 20-30% del profitto
     totale: il DAX da solo fa giornate grosse — rischio di payout
     rifiutato pur avendo guadagnato. Ci serve: NESSUNA consistency
     rule, o soglia molto larga.

**6. Costi e payout**
   - Costo challenge 100k, refund alla prima payout?, split (80%+?),
     frequenza payout (14 gg? mensile?), scaling plan.
   - Ci serve per la SEQUENZA AUTOFINANZIATA: payout ditta 1 -> paga
     challenge ditta 2.

**7. Broker/feed: spread e slippage sugli indici CFD**
   - I nostri edge vivono su DAX/Dow/Nasdaq CFD: spread tipico in
     punti? commissioni? server dove? (il fuso cambia InpSessionHour!).
   - 🚩 Feed "interno" con spread larghi in apertura = l'edge
     dell'apertura si assottiglia proprio quando serve.
   - NOTA TECNICA (lezione v21 di oggi): cambiare broker = verificare
     fuso E unita' dei punti di OGNI simbolo. Niente trapianti di
     config: si ri-verifica tutto sul feed nuovo.

---

## Ditte candidate da studiare (ordine suggerito)

| Ditta | Perche' in lista | Stato studio |
|---|---|---|
| **FundedNext (Stellar 2-Step)** | **PRIMA DA STUDIARE** — pre-studio Claude 12/08 (fonti terze): DD statico, NESSUNA consistency su Stellar CFD, EA personali ammessi (vietati solo i commerciali), news = niente violazione ma "taglio 40%" sui profitti in finestra news sul conto finanziato | 🟡 pre-studio ok, DA VERIFICARE sul sito |
| The5ers (High Stakes) | seconda scelta — limiti molto simili a FTMO (10% assoluto + 5% daily statici), EA propri ammessi; 🚩 MA vieta ESECUZIONI nei 2 min attorno alle news ad alto impatto: per EA senza filtro news e' un rischio di violazione, va mappato contro i nostri orari fissi d'ingresso | 🟡 pre-studio ok, DA VERIFICARE |
| Funding Pips | costi bassi, payout frequenti | ⬜ da leggere |
| E8 Markets | popolare, ma verificare consistency e trailing | ⬜ da leggere |
| Alpha Capital | EA dichiaratamente ammessi | ⬜ da leggere |

_Pre-studio 12/08 da fonti terze (riassunti 2026, non i siti ufficiali):
ogni affermazione va CONFERMATA sulle FAQ ufficiali della ditta prima
del verdetto. La differenza chiave emersa: davanti alle news, FundedNext
taglia i profitti (nessuna violazione possibile), The5ers vieta le
esecuzioni (violazione possibile per un EA non filtrato). Per una
flotta che gira da sola, la prima formula e' strutturalmente piu' sicura._

⚠️ Le regole delle prop CAMBIANO SPESSO: ogni riga sopra va verificata
sul sito ufficiale IL GIORNO dello studio, mai per sentito dire. E il
piano specifico conta (lo stesso nome puo' avere programmi con regole
diverse).

---

## SCHEDA COMPILATA #1 — <nome ditta>
- Data studio:
- Piano/programma:
- 1 EA: ⬜ ok ⬜ dubbio ⬜ no — note:
- 2 Limiti: daily __% / totale __% / ⬜ statico ⬜ trailing / reset ore __
- 3 News: ⬜ libere ⬜ ristrette — note:
- 4 Notturno/weekend: ⬜ ok ⬜ no — note:
- 5 Consistency: ⬜ nessuna ⬜ soglia __% — note:
- 6 Costo 100k __ / refund ⬜ / split __% / payout ogni __ gg
- 7 Spread DAX __ / Dow __ / Nasdaq __ / fuso server __
- **Verdetto: ⬜ candidata ⬜ scartata — perche':**
