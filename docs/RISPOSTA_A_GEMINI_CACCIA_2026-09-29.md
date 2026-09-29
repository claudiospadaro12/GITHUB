# Verifica delle risposte di Gemini alla caccia congiunta (giri 1-2, 28/09 notte), fatta a costo minimo il 29/09 mattina

Solo controlli deterministici (grep sui sorgenti). Nessun agente Opus lanciato: modalita' risparmio (Claudio 29/09: memoria al 73%).

| Affermazione di Gemini | Verifica nel repo | Esito |
|---|---|---|
| MaxMinNotte: `InpMgmtTF` "riga 105", handle a "154/155", usato in `ManagePos` r.347 | `InpMgmtTF` e' a **r.146**, gli handle ATR/EMA200 a **r.218-219** | Sostanza GIUSTA (l'input e' LETTO: manopola non inerte; nel giro 1 diceva "inerte", nel giro 2 "ATTIVO"), **numeri di riga SBAGLIATI** |
| EMA200 EURUSD: `InpSLatr` "riga 105, `ABTG_Guardian.mq5` o equivalente" | `InpSLatr` sta in `ABTG_EMA200.mq5` **r.74** (default 1,0) e lo stop e' a **r.358**: `sl = o2 -/+ InpSLatr*atr` (stop = 2o ordine +/- ATR) | File e riga SBAGLIATI; la manopola e' VIVA e mai messa ad asse: la proposta A4 resta un candidato valido (non griglia: motore NON ANCORA MISURATO, leva del costo nominata da R264 par. 11) |
| Londra: stima "3-8 pip" dal "dossier r.412" | La riga 412 del dossier e' `InpLogImbuto=1` (un blocco di input di un altro motore) | Riga **INVENTATA**. Il numero va ricalcolato dal dossier A1 (sezione Londra ORB) prima di usarlo |
| A7 Dow short: `InpRetestOffsetPts` 0-800 | Griglia di parametri su un motore senza edge (PF OOS 0,96, R255/R270): vietata dalla regola zero | Gemini l'ha RITIRATA nel giro 2 (giusto). La sostituta (filtro ATR H1 in espansione, 10 celle) e' un MECCANISMO ma e' il piu' vicino al filtro di regime gia' chiuso sull'oro col trend (R260d taglia, non separa): **in coda**, non prioritaria |

**Lezione di metodo (classe da registrare se si ripete):** Gemini cita numeri di riga con sicurezza e sbaglia 3 volte su 3.
Il contenuto tecnico (attivo/inerte, manopola viva) e' utile, le righe no. Regola per la memoria condivisa: ogni riga citata da
Gemini si verifica con grep prima di usarla; nel pacchetto gli chiediamo di citare il NOME dell'input o della funzione, non il numero.

**Cosa se ne fa (a costo basso):** unico candidato che passa subito = **A4 `InpSLatr` su EMA200 EURUSD H4** (asse 1,0/1,25/1,5,
un solo asse, attesa e contro-esempio "PF sale ma DD sale di piu' perche' il lotto scende con lo stop" da scrivere nel file prova).
Non lo scrivo oggi: costa una prova + due cancelli. Lo propongo a Claudio nell'ordine dei round di questa settimana.
