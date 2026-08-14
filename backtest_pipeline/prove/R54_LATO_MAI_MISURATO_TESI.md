# R54 — I DUE LATI CHE NON ABBIAMO MAI MISURATO (Dow)

_Tesi e criteri congelati il **14/08/2026**, a numeri non visti. Da leggere
prima del primo CSV: dopo non si toccano._

---

## 1. Da dove nasce

Il censimento R52 (`prove/R52_CENSIMENTO_LATI.md`) ha passato in rassegna
tutte e **32 le celle vive**. Undici hanno un lato spento **a mano**. Di
quelle undici, nove sono bloccate: o aspettano lo storico lungo degli indici
(Pepperstone, che oggi **non c'e'** — vedi §5), o aspettano i dati `_EXT` sui
cambi.

**Due no.** Due si possono misurare **subito, sul feed nativo BCM**, con i
dati che sono gia' in casa:

| # | cella | lato oggi | perche' e' un buco vero |
|---|---|---|---|
| 2 | **Dow Apertura US** (U30USD M5, magic 770202) | solo long | R6 ha spazzolato `AllowShort` **sopra** il long: ha confrontato "solo long" con "long+short". **Il solo-short non e' mai stato lanciato.** |
| 5 | **ORB-EMA200 Dow** (U30USD M5, magic 770611) | solo long | il "solo long" viene dalla FONTE (tradethatswing) ed e' rimasto pinnato in R13/R14/R15. Sul **Dow** lo sweep del lato non e' mai esistito (c'e' stato solo sul Nasdaq, R7a/b). |

Sono i **soldi veri**: tutte e due girano in forward, tutte e due sul conto
100k col Guardiano.

## 2. Cosa si prova (e cosa NON si prova)

Si sposta **un solo input per EA** — `InpAllowLong` e `InpAllowShort` — sopra
la geometria **VIVA**, quella che gira coi soldi, senza toccare nient'altro.
Escono 4 celle, se ne leggono **3**:

| cella | significato |
|---|---|
| `1/0` | **solo long** = com'e' oggi. E' il metro, non un candidato. |
| `0/1` | **solo short** = il buco. Mai lanciato in sei settimane. |
| `1/1` | **entrambi** = quello che R6 aveva gia' confrontato col long. |
| `0/0` | non opera. **Si ignora**, come le 12 celle fuori diagonale di R53. |

**Non si cerca la cella migliore.** Si cerca la risposta a una domanda sola:
_il lato spento era una scoperta o era il campione?_

## 3. L'ipotesi vera, scritta prima

Il campione BCM sugli indici parte dal **26/09/2024**: ventun mesi in cui il
Dow ha fatto quasi solo una cosa, salire. Un long-only misurato dentro una
salita ha un vantaggio che **non e' dell'idea, e' del periodo**.

> **[IPOTESI A]** Se il long-only fosse solo il riflesso del campione, il
> solo-short dovrebbe risultare **rosso ma non catastrofico** (una specularita'
> approssimativa), e il long+short dovrebbe stare **in mezzo**.
>
> **[IPOTESI B]** Se invece l'apertura del Dow avesse davvero un'asimmetria
> strutturale (i breakout al rialzo alla campanella funzionano e quelli al
> ribasso no), il solo-short deve essere **molto peggio** della semplice
> specularita', e il long+short deve **avvicinarsi al long-only da sotto**.
>
> **[NON DIMOSTRABILE QUI]** Nessuna delle due ipotesi si chiude su questo
> campione: un solo regime non separa "asimmetria del mercato" da "asimmetria
> del periodo". Questo round **non promuove lo short**. Al massimo lo
> qualifica come da rimisurare quando arrivano gli altri regimi.

C'e' anche un motivo tecnico per aspettarsi pochi trade short: tutte e due le
celle hanno un **filtro di trend direzionale** (EMA H4 sul Dow Apertura,
EMA200 M5 sull'ORB). In un campione che sale, il lato short passa il filtro
poche volte. **Un campione piccolo non e' un risultato**: e' un criterio di
scarto (vedi criterio 2).

## 4. CRITERI (congelati, a numeri non visti)

1. **La cella `0/0` si ignora.** Non e' un risultato, e' una cella che non
   opera.
2. **Numerosita' minima: n >= 30 fuori campione.** Sotto quella soglia il
   verdetto e' "non misurabile", NON "non funziona". Detto prima proprio
   perche' e' l'esito piu' probabile sullo short.
3. **Lo short diventa CANDIDATO solo se**: PF OOS >= 1,10 **E** positivo
   anche IS **E** n >= 30. Tre cancelli, tutti e tre, come per chiunque altro.
4. **Il long+short sostituisce il long-only solo se**: fa piu' profitto OOS
   **E** un DD OOS non piu' alto. E' lo **standard di portafoglio** gia'
   scritto ("un ingresso e' buono se aggiunge profitto E abbassa le code"):
   qui si applica dentro la stessa cella. Guadagnare di piu' peggiorando il DD
   **non basta**.
5. **Nessun cambio al forward esce da questo round.** Le due celle stanno sul
   conto 100k: si toccano solo dopo un round di conferma dedicato, con la sua
   tesi. Questo qui produce **informazione**, non deploy.
6. **Se il solo-short e' verde e regge i tre cancelli**, la conseguenza NON e'
   "accendiamo lo short": e' che **R6 e R13/R14/R15 vanno riletti**, perche'
   hanno scelto un lato senza aver misurato l'alternativa.
7. Il metro e' l'**OOS**, e si guarda **una volta sola**. Il Dow e' gia' stato
   guardato in OOS tre volte (R14+R15): questa e' la quarta, ed e' scritta
   qui perche' pesi in classifica.

## 5. Nota onesta sui dati (14/08/2026 sera)

**Di Pepperstone non abbiamo un solo byte.** Il conto demo non risulta creato
(il Giornale dice `Invalid account`, e i server UK non hanno gruppi demo lato
server), il ricognitore e' andato in timeout e ha consegnato **0 file**. La
tabella dei simboli in `docs/BROKER_ESTERNO_MAPPA.md` e' ancora vuota, come
deve essere finche' nessuno l'ha verificata.

Quindi: **la prova di regime sugli indici oggi non si puo' fare.** Nemmeno
con l'import HistData, che i cambi ce li ha e gli indici no.

Questo round e' esattamente il lavoro che **non dipende da quel dato**: gira
sul feed nativo, sui ventun mesi che abbiamo, e produce un numero che oggi
non esiste. Con i limiti scritti al §3, che restano.
