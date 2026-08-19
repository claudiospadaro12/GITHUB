# 🧯 VERBALE INCIDENTE — il template che ha spogliato il conto piccolo (19/08/2026)

**Esito finale: RECUPERO COMPLETO. Censimento delle 11:53 = 43,30%, identico
al centesimo al riferimento del 18/08 09:41. SPARITE: NESSUNA.**

## Cosa e' successo

Claudio ha copiato il template ABTG del 100k dall'istanza V3 e l'ha applicato
sui grafici del conto piccolo (50503392) per avere lo stesso aspetto grafico.
**Un template MT5 porta con se' anche l'expert (o la sua assenza): applicarlo
sostituisce l'EA del grafico.** Gli expert sono spariti dai grafici senza
che se ne accorgesse.

## Il conto delle vittime: 11 sedie

| fase | sedie | fonte del recupero |
|---|---|---|
| 1 (6 sedie) | PTE DOW 771321 · PTE USDJPY 771323 · PTE GBPUSD 771322 (0,5) · SW DOW 770531 · SW GBPUSD 770532 · MAXMIN ORO 770402 | preset costruiti dai SORGENTI + referti (commit 9d0ff00), incrociati con lo statement del 18/08 |
| 2 (10 sedie) | DAX 770101 · DOW 770202 · MAXMIN DAX 770411 · EMA200 771531 · EMA200 OTT 971501 · STREV Nikkei 770924 · STREV OTT 970901 · SUPERWAVE DOW H1 770511 · STREV DAX H4 970912 · STREV NAS H1 970913 | preset estratti BYTE PER BYTE dal backup .chr delle 10:24, profilo ORO (commit ed68a62) |
| 3 (1 sedia) | ORB OTT 770611 (rischio 1,0) | UNICA senza fotografia (spogliata e salvata PRIMA delle 10:24): ricostruita dal gemello 0,3 del 100k — che a suo tempo era stato estratto proprio dal grafico del piccolo — 12/12 campi verificati contro il verbale deploy R15 (commit 333c3d0) |

Ogni sedia rimessa con il rito: preset → screenshot degli input PRIMA di OK →
verifica campo per campo in chat. Zero errori ai controlli.

## Perche' il danno e' stato visto in due tempi

MT5 scrive i `.chr` su disco solo al salvataggio del profilo o all'uscita.
La prima conta (10:24) leggeva ancora la versione vecchia di 10 grafici; il
"Salva profilo" successivo ha scritto lo stato spogliato e il censimento e'
sceso a 32,30%. Il backup fatto PRIMA del salvataggio e' stato la rete di
sicurezza: senza, i valori esatti di 10 sedie sarebbero andati persi.
L'ORB era gia' stato salvato spogliato prima del primo backup: e' l'unica
sedia recuperata per via indiretta.

## Le lezioni (pagate, quindi da tenere)

1. **Un template porta con se' anche l'expert.** Mai applicare un template a
   un grafico con EA vivo senza rifare subito il giro delle faccine. Per lo
   stile grafico: salvare un template SENZA expert (nome nuovo, es.
   `ABTG_LOOK`) e applicare quello.
2. **Backup dei `.chr` PRIMA di ogni "Salva profilo"** durante un'operazione
   sui grafici: il disco conserva lo stato pre-danno solo finche' non si salva.
3. **Il censimento e' il metro**: la somma dei rischi dichiarati (43,30%) fa
   da checksum dell'intera flotta — uno scarto di 1% ha scovato l'undicesima
   vittima che a occhio nessuno aveva notato.
4. **I preset sono la memoria**: ora TUTTE le sedie del piccolo hanno un
   preset nel repo (`mql5/Presets/sedie_piccolo/` + `recupero2/`). Il
   prossimo incidente si chiude in minuti, non in ore.
5. **Punto 25 in azione** (dal verificatore): i preset `recupero2/` non
   nominano `InpUsaGuardian` (input nato il 19/08 con la migrazione Guardian,
   dopo i `.chr` di origine). Oggi innocuo (EA sul VPS pre-migrazione);
   da rigenerare durante il collaudo Guardian — gia' in CODA.

## Nota a margine

- Nel diff resta una riga NUOVA non legata all'incidente: un terzo grafico
  **Guardian su AUDNZD** (779001, n/d) sull'istanza 100k — ieri erano due,
  entrambi AUDCAD. Da guardare, non urgente.
- In coda pulizia: il PC di backtest ha un grafico DAX Apertura a rischio 2.0
  e il BreakoutCorso 779100 (visti per sbaglio quando la stringa e' girata
  sulla macchina sbagliata).

Censimento finale agli atti: `../backtest_pipeline/risultati_archivio/censimento_rischio_2026-08-19_1153.txt`
