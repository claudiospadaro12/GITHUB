# Scaletta di lavoro e bozza del piano di trading per Emiliano (23/11/2026)

## A. Scaletta (ordine di lavoro)
1. **Dati forex D1 dal terminale BCM** (riga `RIGA_EXPORT_D1_BCM_FOREX.txt`, Claudio) -> test del trend forex D1 (criteri gia scritti: `FOREX_TREND_D1_CRITERI_2026-11-23.md`).
2. **Lettura dei 9 progetti di claude.ai** con Claude in Chrome (`PROMPT_CLAUDE_DESKTOP_PROGETTI_2026-11-23.md`): consegna file .md, soprattutto il codice MT4 dell'EA semiautomatico.
3. **EA semiautomatico in MT5** (nostro): gestisce la posizione aperta a mano, stop 3 x ATR, take profit sulla mediana delle Bollinger aggiornato a ogni nuova barra H1; + avviso del setup Breaking Band di Leonardo + diario automatico (CSV: setup segnalato, preso o saltato, esito). Prima tester e demo.
4. **Mail a FTMO** con le domande (EA proprietari, set condivisi, richieste/giorno, tetto di capitale per strategia, **gestione automatica di posizioni aperte a mano**). Decide Claudio.
5. **Terzo EA**: se il forex D1 non passa, decisione su come proseguire (famiglie gia chiuse sotto).
6. **PIANO DI TRADING PER EMILIANO**: preparare la versione definitiva (sezione B) dopo i punti 1-3, con i progressi aggiornati; formato PDF, tono "misure e domande".

## B. Bozza del piano per Emiliano (da completare; solo misure, nessun consiglio su taglie)
### 1. Obiettivo
Una flotta di 3-7 EA **nostri**, scorrelati, per prop firm e conto reale; ogni idea passa da criteri scritti prima dei numeri, cancelli IS / OOS / plateau / hold-out e controllo di correlazione.
### 2. Progetti e stato
| Progetto | Cosa e | Stato al 23/11/2026 | Evidenza |
|---|---|---|---|
| GoldenZoe (nostro) | Oro H4, solo long, canale 55, stop 3 ATR, Chandelier | Pronto per forward demo (set PROP / MEDIO / ALTO) | Simulato su 12 anni, conto 80.000: media annua +1,9% / +3,4% / +4,9% a rischio 0,5 / 0,9 / 1,3%; 3 anni negativi su 12; DD dal picco circa 2,9 / 6,0 / 9,5% |
| Dow (DowRaptor) | Breakout sul Dow | Le **due famiglie nostre** (canale M15, apertura USA) chiuse senza candidati; il set `g` e di terzi e non fa parte del progetto | Misure di riferimento soltanto |
| EA semiautomatico + Breaking Band di Leonardo | Gestione automatica di una posizione aperta con l'occhio | In preparazione (punti 2-3 della scaletta) | Il segnale Breaking Band da solo: IS buono, OOS 2021-24 debole nella nostra replica (13 operazioni, PF 0,64-0,75), positivo nei numeri di Massimo: differenza non spiegata |
| Terzo EA | Ricerca di una strategia scorrelata | Aperta | Chiuse: coppie D1 (0/54), Bitcoin intraday (0/19), Bitcoin D1 (debole, swap), trend D1 su 33 mercati |
### 3. Strategie del corso e di Emiliano gia misurate (nessun giudizio, solo cio che abbiamo misurato)
ORB e ORB + Fibonacci (webinar 02/03 e Toolkit 05, 6 celle ciascuno su Nasdaq, S&P, oro, EURUSD): nessun vantaggio. PTE e WOL su 28 cross (PF IS 0,66-0,76): nessuna candidata. HAM con i filtri: PF 0,48-0,80. Breakout del corso: PF 0,63-0,95. Bulge (motore corretto): PF 0,83 su 2.300-3.200 operazioni. Piano orario, fade dei massimi e minimi della notte: accennati nelle live, non testati come regole complete.
### 4. Metodo
Criteri e previsioni scritti prima, soglie mai allentate, hold-out aperto una volta, costi prudenti, controllo del conteggio delle celle (falsi positivi attesi), simulatore di challenge con partenze diverse.
### 5. Prop firm
FTMO (EA ammessi, strategia unica, 2.000 richieste al giorno) e Concept Trading / iFunds: regole lette dai siti, in attesa di conferma scritta. Testimonianze di utenti raccolte (non verificate).
### 6. Domande per Emiliano (da raffinare)
- Regole esatte del tuo setup Breaking Band (ingresso, filtri, orario) per scrivere l'avviso del setup.
- Quali delle strategie del corso consideri adatte alle prop e con quali filtri.
- Come gestisci la posizione dopo l'ingresso (stop, target, trailing, orari) per allineare l'EA semiautomatico.
### 7. Limiti
Dati di test: BCM e FTMO, barre da 1 minuto; l'oro in forte rialzo dal 2024-25; pochi anni per alcuni mercati; nessun risultato reale.
