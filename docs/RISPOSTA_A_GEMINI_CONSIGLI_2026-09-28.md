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

---

## Seconda consegna di Gemini, sera del 28/09: «Guida per il miglioramento del Profit Factor» (`docs/GEMINI_GUIDA_MIGLIORAMENTO_PF_2026-09-28.pdf`, 2 pagine)

| # | Punto | Verifica nel repo | Cosa se ne fa |
|---|---|---|---|
| 1 | Regola zero: mai ottimizzare i parametri di un motore senza edge; cambiare meccanismi/simboli/TF/uscita | E' la regola del 19/08 e del 09/09 di `CLAUDE.md`, ricopiata. | Niente: gia' legge. |
| 2 | L'edge sta nell'uscita: trailing dinamico (Dow 1,238 → 1,371 con la candela M5 precedente), parziali e breakeven ad asse | I numeri sono NOSTRI (`dow_trailing.csv`, `LE_MANOPOLE_INERTI_2026-09-23.md`). **R270 di stasera ha appena misurato l'uscita del DAX su tutte le leve: il vivo e' il centro, TP1_R inerte fra 1 e 2R** (`report/LETTURA_R270_2026-09-28.md`). | Gia' fatto; la guida arriva dopo la misura. |
| 3 | Shift del TF (H4 → H1/M15) per frequenza, rispettando stop >= 40x spread | Regola di casa (motto del 09/09: TF piu' bassi, frontiera del costo). Sull'oro EMA200 il TF e' gia' stato cambiato (R32a H1: PF 0,56-0,85, nel certificato di stasera). | Niente di nuovo. |
| 4 | Filtro dello SPAZIO (`InpSpaceMode`) e filtro VWAP/trend di fondo | Gli input **esistono gia'** nel sorgente (`ABTG_DAX_Apertura_EU.mq5`: `InpSpaceMode`, `InpUseVwapFilter`, `InpUseEmaFilter`), a default spenti: sono nelle 874 corse a manopole inerti. L'"oro col trend" (R260d) e' stato misurato stasera: **rischio violato**. | Candidato per un round SOLO se proposto con attesa e contro-esempio (classe 178); oggi nessuna misura dice che accendere `InpSpaceMode` aiuti. |
| 5 | Oro EMA200 H4 regime-dependent: filtro di regime (ATR D1) che spegne l'EA nei laterali invece di cestinare il motore | Idea legittima ma a rischio di **adattamento a posteriori**: il filtro va definito PRIMA su una regola indipendente e provato su 2017-23 E 2024-26 con la prova di regime (Emendamento C). R260d ha gia' provato un filtro di trend sull'oro (770402, non EMA200): taglia, non separa. | Se Claudio lo vuole: file prova con filtro ATR-D1 definito ex ante, attesa dichiarata, contro-esempio "il filtro spegne anche il 2024-26". In coda, non urgente. |

Bilancio delle due consegne: 7 punti su 9 gia' scritti nel repo o gia' misurati oggi; 2 candidati (tokenizer AST per il
cancello; filtro di regime ex ante sull'oro EMA200). Per la prossima consegna Gemini deve citare i file del repo che gia' trattano
il punto e proporre l'ATTESA con il contro-esempio, come chiede il comando (Agente 3 e 4).
