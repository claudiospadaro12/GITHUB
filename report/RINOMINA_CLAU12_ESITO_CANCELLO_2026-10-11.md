# Rinomina ABTG -> CLAU12: esito del cancello di giudizio (11/10/2026)

Ramo locale `rinomina-clau12-visibile` (commit 3dfe0c98 + correzione df7e5f81, mai pushato, NON mergiato). Cancello: controllo-preventivo (Opus). **Verdetto: FAIL.** `lavoro` non e' stato toccato e nessun terminale nemmeno.

## Perche' non si merge (misurato eseguendo gli strumenti, non solo leggendoli)
1. **I driver dei round, anche quelli pinnati a un commit, scaricano EA e include dal branch `lavoro` PER NOME** (`walkforward_generico.ps1` r.264/317/355). Il pin fissa il wrapper, non quello che il wrapper scarica. Dopo il merge le righe di round gia' passate prenderebbero 404 e ripiegherebbero sulla copia locale vecchia, in silenzio dove manca il controllo SHA. 90 `.ps1` scaricano mql5 da `lavoro`.
2. **Il censimento dei consumatori era incompleto** (42 era poco): mancano i percorsi di `Indicators/` e `Scripts/`, e tutti i nomi composti da variabili (`"$RawBase/mql5/Experts/$EA.mq5"`).
3. **Regressioni in esecuzione**: `collaudo_gba_ottimizzato.py` passa su `lavoro` e fallisce sul ramo; quattro collaudi si fermano con FileNotFoundError.
4. **Migrazioni a meta'** (`installa_guardian.ps1`, `lancia_r93.ps1`, `rilancia_aperture_v2.ps1`): scaricano l'EA nuovo ma installano l'include col nome vecchio -> compilazione fallita su piccolo e 100k.
5. **Collisione di maiuscole sul terminale**: `CLAU12_DAX_APERTURA_EU.mq5` e `CLAU12_DAX_Apertura_EU.mq5` (TrailFix sul FTMO) sono lo STESSO file in `MQL5\Experts` (piatto, insensibile alle maiuscole).
6. **Non e' «solo visibile»**: 106 file costruiscono i nomi dei file d'uscita da `MQL_PROGRAM_NAME` (`OptResults_`, `abtg_trades_`, `abtg_tel_`...). Cambiare il nome dell'EA cambia i file che scrive.
7. `aggiorna_ea.ps1` con lo shim crea un EA PARALLELO invece di aggiornare quello attaccato.
8. Contraddice la regola di casa («nel repo NON si rinomina niente»).
Ripristinati dal cancello 15 file pinnati toccati per errore (df7e5f81).

## Cosa NON e' toccato dal cancello e resta vero
Magic, GlobalVariable, FileOpen e nomi passati al Guardian: invariati. Runner notturno, news e pagella: non toccati. Autotest dei lettori verdi.

## Percorso compatibile con i PASS esistenti
Copie ADDITIVE `CLAU12_*` (regola gia' scritta in CLAUDE.md), con i `ABTG_*` che restano su `lavoro`. Una rinomina vera in repo richiede, prima del merge: (1) i file vecchi tenuti su `lavoro` finche' ogni driver pinnato che legge il branch non va in pensione; (2) censimento rifatto su tutte le cartelle rinominate e sui nomi composti da variabili; (3) l'include installato sui terminali con TUTTI E DUE i nomi; (4) controllo di collisione case-insensitive contro i nomi schierati; (5) CLAUDE.md emendato nello stesso commit; (6) decisione esplicita sui nomi dei file d'uscita (`MQL_PROGRAM_NAME`).
