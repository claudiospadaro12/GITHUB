# REFERTO R30 — le due idee dell'EA dell'amico nel lab Nasdaq (12/08)

## Da dove viene
Parametri di NasdaqOpeningBreakout v21 (EA esterno, girato dall'amico di
Claudio su BCM). Le DUE idee che non avevamo mai testato sono state
innestate opt-in (default spento, v1.01) nel nostro ABTG_Nasdaq_Apertura_US:
**regime di volatilita'** (percentili ATR -> buffer/SL/size adattivi) e
**filtro prossimita' S/R** (PDH/PDL + numeri tondi addosso = salta).
Base pinnata = la config MISURATA di R24 (volumi 1,5 AND). Griglia 2x2,
tick reali, ipotesi e criteri congelati nel file di prova PRIMA dei numeri.

## Igiene (tutta verde)
- **Gemello al centesimo**: baseline R30 (0,0) = cella R24 TrailStartR 0:
  IS +69,62 / PF 1,06836 / DD 4,6303 / 50 trade — OOS +476,33 / PF 1,26893 /
  DD 5,7734 / 99 trade. Identici a R24 cifra per cifra: **la prova sui dati
  che l'innesto v1.01 a default spenti non ha cambiato nulla** (l'audit
  riga-per-riga dell'agente, ora certificato dal tester).
- 4 righe tutte diverse per finestra: entrambe le feature girano davvero.
- Conteggi coerenti con le ipotesi meccaniche: VolRegime ~stessi trade
  (52 vs 50 IS, 100 vs 99 OOS); SRFilter taglia (48 vs 50 IS, 86 vs 99 OOS).

## I numeri (deposito 10k, rischio 1%)

| Cella | IS profit | IS PF | IS DD% | OOS profit | OOS PF | OOS DD% |
|---|---|---|---|---|---|---|
| baseline (0,0) | +69,62 | 1,07 | 4,63 | **+476,33** | 1,27 | 5,77 |
| VolRegime solo | −1,23 | 1,00 | **3,86** | +397,47 | **1,36** | **4,06** |
| SRFilter solo | **+221,31** | **1,27** | 2,58 | **−56,86** | 0,97 | 6,80 |
| entrambe | +32,61 | 1,04 | 3,01 | +83,72 | 1,07 | 4,40 |

## Verdetti (coi criteri congelati)

**SRFilter: BOCCIATO — ed e' la 20ª apparizione del ribaltamento.**
In campione e' la cella piu' bella del lotto (+221, PF 1,27, DD dimezzato:
esattamente il numero che convince ad accenderlo). Fuori campione e'
l'UNICA cella rossa (−57, PF 0,97). L'ipotesi chiedeva "PF su con profitto
non peggiore in entrambe le finestre": fallita dove conta. Il filtro S/R
taglia il 13% dei trade e taglia quelli buoni.

**VolRegime: NON ADOTTATO col criterio congelato — ma con l'appunto piu'
interessante del round.** Il profitto scende in entrambe le finestre
(IS da +70 a −1; OOS −17%, da +476 a +397): "stesso profitto circa" non
e' rispettato. Pero' il profilo di rischio migliora in TUTTE le metriche
in ENTRAMBE le finestre: DD 4,63→3,86 (IS) e 5,77→4,06 (OOS), peggior
giornata −1,20→−1,02, serie perdente −217→−106, PF OOS 1,27→1,36.
E' lo stesso pattern del filtro volumi sul DAX (R26): qualita' su,
profitto giu'. **Appunto a backlog**: se un giorno servira' domare il DD
di un motore VALIDATO (es. una prop con limiti piu' stretti del 10%),
il VolRegime e' il primo attrezzo da provare — su quel motore, con
questo stesso protocollo.

**Entrambe insieme: no** (peggio delle singole in tutte le direzioni utili).

## Conclusione
Il regalo dell'amico ha avuto la risposta pulita che meritava: un'idea e'
una sirena da campione (S/R), l'altra e' un attrezzo vero di risk-shaping
che pero' non e' gratis (VolRegime). Il lab Nasdaq conferma la mappa:
l'unico edge del mercato resta il filtro volumi 1,5 AND. Come scritto nel
file di prova: il grafico vivo NON si tocca da questo round — resta
pendente (da R25) il solo allineamento dei 2 input volumi.

_CSV in `risultati_prove/ABTG_Nasdaq_Apertura_US/` (suffisso _r30)._
