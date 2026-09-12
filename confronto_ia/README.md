# 🤝 Il Tavolo — Claude Code ⇄ ChatGPT

Un posto virtuale dove **due IA si confrontano sui tuoi EA**: Claude Code prepara un
dossier con i dati veri del progetto, ChatGPT lo legge e dice se i parametri sono
ottimizzati al massimo o se c'è margine; Claude Code risponde, filtra le proposte
e le trasforma in test concreti da lanciare.

Serve a una cosa sola: **evitare che chi ha scritto il codice sia anche l'unico a
giudicarlo**. Un secondo parere, per iscritto, che resta agli atti nel repo.

---

## Come funziona in 3 passi

```
  Claude Code                     confronto_ia/sessioni/          ChatGPT
 ─────────────                   ─────────────────────────       ─────────
 legge i .mq5,                    00_claude.md   (dossier)  ──▶  legge tutto
 ea_config.json,        ────▶     01_chatgpt.md  (parere)   ◀──  risponde in
 i CSV del tester                 02_claude.md   (replica)       formato fisso
 → scrive il dossier              03_chatgpt.md  ...
```

Ogni confronto è una **sessione**: una cartella con i turni numerati. È tutto testo
dentro il repository, quindi resta lo storico di chi ha detto cosa.

---

## Uso rapido

### Con Claude Code (il modo comodo)
```
/confronto ABTG_SupRev_DAX_H4_Ottimizzato
```
L'agente `confronto-ia` prepara il dossier, gestisce il dialogo, valuta le proposte
di ChatGPT e ti dice quali accoglie e quali no — con il motivo.

### A mano (funziona anche senza API, con il tuo ChatGPT normale)
```bash
# 1. prepara il dossier
python confronto_ia/tavolo.py apri --ea ABTG_SupRev_DAX_H4_Ottimizzato

# 2. apri il file che ti indica (confronto_ia/sessioni/.../00_claude.md),
#    caricalo o incollalo in ChatGPT

# 3. salva la risposta di ChatGPT in un file e registrala
python confronto_ia/tavolo.py incolla --file risposta.txt
```

### In automatico (serve una chiave API OpenAI)
```bash
# nel file .env del progetto:  OPENAI_API_KEY=sk-...   (e, se vuoi, OPENAI_MODEL=gpt-5)
python confronto_ia/tavolo.py apri --ea ABTG_SupRev_DAX_H4_Ottimizzato
python confronto_ia/tavolo.py chiedi          # manda e salva la risposta da solo
```

### Altri comandi
```bash
python confronto_ia/tavolo.py stato                    # sessioni e verdetti
python confronto_ia/tavolo.py estrai                   # il JSON dell'ultima risposta
python confronto_ia/tavolo.py replica --file mia.md    # registra il turno di Claude Code
python confronto_ia/tavolo.py apri --tema "money management sulla sfida FTMO"
python confronto_ia/dossier.py ABTG_ORB --codice --out dossier.md   # solo il dossier
```

---

## Cosa c'è dentro il dossier

Tutto letto dai file veri del repository, niente stime:

| Sezione | Da dove viene |
|---|---|
| Contesto operativo (broker, fuso orario, regole prop, rischio) | `confronto_ia/contesto/contesto_base.md` |
| Strategia dell'EA | intestazione del `.mq5` |
| **Parametri attuali** | blocco `input` del `.mq5` (con i `#define` risolti) |
| Griglia di ottimizzazione | `backtest_pipeline/ea_config.json` |
| **Risultati del tester** | CSV/XML in `backtest_pipeline/risultati_*` |
| Note forward/backtest | `TRACKING_FORWARD.md`, `RIEPILOGO_FORWARD.md`, ecc. |
| Domande + formato di risposta | `confronto_ia/PROTOCOLLO.md` |

Il pezzo che conta davvero è l'analisi **parametro per parametro**: per ogni valore
testato viene mostrato quante combinazioni restano in profitto e il PF mediano.
È così che si vede se un set è su un **plateau** (robusto) o è un **picco isolato**
(overfitting). Esempio reale:

```
- InpStMult      → 2.5: 100% pos, PF med 1.16 | 3.0: 100% pos, PF med 1.25 | 3.5: 33% pos, PF med 0.89
- InpStAtrPeriod →   9:  50% pos, PF med 1.30 |  10: 100% pos, PF med 1.31
```
Qui si legge a colpo d'occhio che `3.5` e `9` sono zone fragili.

## Il formato di risposta

ChatGPT deve chiudere ogni messaggio con un blocco JSON (verdetto, punteggio di
robustezza, criticità, proposte, test da lanciare, domande). Serve perché Claude Code
lo legge da programma: `tavolo.py estrai`. Le regole complete sono in
[`PROTOCOLLO.md`](PROTOCOLLO.md) e finiscono in fondo a ogni dossier.

## Prima di usarlo

1. Compila i limiti della tua sfida prop in `contesto/contesto_base.md`
   (perdita giornaliera, drawdown massimo, target): senza quei numeri il parere
   sull'ottimizzazione è monco.
2. Ricorda: nessun parere di ChatGPT va in produzione senza un backtest a tick reali
   che lo confermi e un forward in demo. Il tavolo è un consulente, non un decisore.

## Limiti onesti

- ChatGPT vede **solo** quello che c'è nel dossier: non ha accesso al tuo MT5 né ai tick.
- Due IA d'accordo non fanno una verità: possono sbagliare insieme, soprattutto su
  storici corti. Il forward resta l'unico giudice.
- La modalità automatica consuma crediti API OpenAI; quella manuale no.
