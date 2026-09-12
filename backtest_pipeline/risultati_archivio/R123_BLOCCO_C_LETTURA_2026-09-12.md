# ✏️ ERRATA — QUESTO REFERTO E' SUPERATO. Vale `R123_BLOCCO_C_2026-09-12.md`

**12/09/2026.** Avevo scritto qui una lettura delle sette celle del blocco C e
proposto un round (`R135a`) per estendere l'asse `InpStAtrPeriod` oltre il 12.
🔴 **Il referto buono e' un altro**, ed e' nella stessa cartella:
**`R123_BLOCCO_C_2026-09-12.md`**. Il mio va letto come errore, e vale la pena
dire *quale* errore, perche' e' il terzo della stessa famiglia in un giorno.

## 🔴 L'ERRORE 1 — ho dato un verdetto su un round i cui CRITERI erano GIA' CONGELATI

`report/ROUND_ALTOPIANO_SUPREV_2026-09-09.md` **r.109** aveva pianificato
esattamente questo blocco — *"7 celle, `InpStAtrPeriod` 6→12, magic 784120"* —
**con i cancelli di accettazione scritti PRIMA dei numeri**: `A1` (altopiano),
`A3` (anti-altopiano-finto), `A4` (picco), `A6` (verdetto di round).

**Io non li ho cercati.** Ho letto i CSV e ho costruito una lettura *mia*, a
posteriori. E la regola di casa dice l'opposto: **i criteri si cambiano prima
dei numeri, non dopo** — una lettura inventata dopo aver visto le celle non e'
una misura, e' una preferenza.

📌 **Ed e' la regola del 10/09, per la terza volta oggi**: *prima si cerca il
file che ha gia' la risposta.* Oggi l'ho pagata su `CODA_04` (il nome della
macchina era in un log da cinque notti), su `CODA_03` (la definizione di
cartella dati era nel codice), e adesso qui.

## 🔴 L'ERRORE 2 — «la 12 e' un PICCO di bordo» non e' una frase che potevo scrivere

`A4` **e' la regola che autorizza la parola "picco"**, e pretende che
**entrambe** le vicine stiano sotto 1,05. Verificato sui CSV dall'altro
referto: la 9 fa 1,389 ✅, la 10 fa 0,610 ✅, **ma la 8 fa 1,164** ❌.
➡️ **A4 non scatta.** Quindi "picco" non si scrive — ne' per la 9, ne' per la 12.

E la lettura giusta e' anche **meglio supportata** della mia: l'altopiano
candidato sta **DENTRO** la finestra (celle 8-9), non oltre il bordo; e la 12,
che avevo eletto a caso interessante, ha **n OOS 133** — sottocampionata.

## 🛑 CONSEGUENZA: **`R135a` E' RITIRATO**, e non per ripiego

Il verdetto congelato e' **`A6`: "non c'e' una configurazione robusta su questo
asse"**. Estendere **lo stesso asse** da 13 a 20 dopo un A6 e' esattamente cio'
che il limite del **19/08** vieta:

> ✅ si allarga su **motori, meccanismi, simboli, TF, gestione dell'uscita**;
> ❌ **non si allarga sui parametri di un asse gia' dichiarato non robusto**;
> e ogni allargamento si paga con una prova fuori campione o di regime.

🔑 **La mia proposta era "non accontentiamoci" applicato male.** Insistere vuol
dire cercare una **misura in piu'** — un TF, un simbolo gemello, la gestione
dell'uscita mai messa ad asse — **mai una griglia piu' larga sullo stesso asse
che ha appena fallito i suoi cancelli**. Quello e' il modo in cui nasce la cella
"verde per caso", che e' la cosa che brucia la challenge.

📄 Il file prova `backtest_pipeline/prove/R135a_U30USD_atrperiod_oltre12.txt`
resta sul disco **marcato RITIRATO in testa**: serve come memoria del
ragionamento sbagliato, **non va messo in coda e non va lanciato**.

## 🟢 LE DUE COSE CHE DI QUESTO REFERTO RESTANO VERE

1. **Le sette celle IS + sette OOS del blocco C erano davvero mai state lette**
   da nessun file del repo: quello era il ritrovamento, ed e' valido.
2. **Il campione non regge il MERITO**: la colonna `n` conta **DEAL di uscita,
   non POSIZIONI** (classe 226), quindi le posizioni stanno sotto il pavimento
   di 150 su tutte e quattordici le finestre. Il **RISCHIO** invece si giudica
   sempre, e nessuna cella sfonda il 10% di DD.

E una cosa in piu', che e' dell'altro referto e va ripetuta perche' e' grossa:
🚨 **applicando A4 al blocco B, anche il "picco" del blocco B cade** (la vicina
`StMult 4,0` fa 1,09271, non sotto 1,05). Due verdetti di "picco" scritti senza
passare dalla regola che autorizza quella parola.
