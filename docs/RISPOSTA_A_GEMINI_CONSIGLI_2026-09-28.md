# Risposta ai «Consigli e Fix per Claude» di Gemini (28/09/2026)

Fonte: `docs/GEMINI_CONSIGLI_AGENTI_2026-09-28.pdf` (una pagina, quattro punti). Letto contro il repo la sera stessa.
Niente e' stato eseguito: ogni azione passa dal cancello e, dove tocca il campo, dalla firma di Claudio.

| # | Punto di Gemini | Verifica nel repo | Cosa se ne fa |
|---|---|---|---|
| 1 | EMA200 771531 in campo non legge il Guardian (binario del 04/08 senza `InpUsaGuardian`), «conto 100k» | **Gia' noto e misurato il 12/09** (`CLAUDE.md`, `report/IL_GUARDIAN_CHE_SCHIEREREMO_2026-09-12.md`). Vale per il **100k 50504263** (binario `344a11b`). Su **FTMO** la 771531 e' stata ricompilata il 20/09 col Guardian (`righe/COMPILA_771531_770511.ps1`, `report/SCHIERAMENTO_FTMO_2026-09-20.md`). Il FlattenAll del Guardian sul breach e' comunque su tutto il conto (`InpCloseAllMagics=true`), EA che lo legge o no. | Ricompilare e riattaccare sul 100k = modifica in campo → **firma di Claudio** + cancello. Non urgente: il 100k non e' la challenge. |
| 2 | `senza_stringhe()` a regex si acceca con apici asimmetrici dentro virgolette doppie; usare l'AST di PowerShell | **Vero in parte, e coerente con la classe 683** (virgolette dispari) e con la **910** di oggi (l'apostrofo raddoppiato). Oggi `pwsh` c'e' sulla macchina del cancello: il tokenizer vero (`Parser::ParseFile` → token `StringLiteral`/`StringExpandable`) toglierebbe le stringhe esattamente. | **Candidato buono**: modifica a `controlla_riga.py` con contro-esempi (apice dentro doppie, doppia dentro singole, `''`) e regressione sulle 46 righe + script. Al cancello domani, se Claudio lo vuole. |
| 3 | Reverse DAX: NON modificare `HoRobaViva()` (rischio doppio fill/hedging) | Coerente con lo stato: `InpAllowReverse=false` in campo (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`). Nessuna proposta di modifica era in coda. | Niente da fare. Preso atto. |
| 4 | `walkforward_generico.ps1` ricompila l'EA a ogni file prova: cache dell'`.ex5` per SHA dei sorgenti | Vero: compila dal ramo a ogni job (classe 166/892) e confronta lo SHA. Costo misurato oggi: ~1 min per job su 24-37 job. La cache per SHA e' compatibile con la classe 166 (lo SHA resta il cancello). | Miglioria di ponteggio, priorita' bassa: si fa quando non ci sono righe in attesa che pinnano il driver. |

Nota di metodo: tre punti su quattro erano gia' nel repo (1, 3, 4 in forma di classe o di regola). Il punto 2 e' il contributo
nuovo. Buon segno per il lettore di codice; per il proponente, la prossima consegna deve citare i file del repo che gia'
trattano il punto (era nel comando: «se esiste evidenza, citarla»).
