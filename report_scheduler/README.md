# Sveglia affidabile del Report — sul VPS

Fa partire il Report di Mercato **alle 07:00 esatte** dal tuo VPS, invece di
affidarsi allo scheduler di GitHub (che ritarda di ore). Il VPS "chiama"
GitHub, che poi genera e invia la mail come sempre.

**Non serve installare Python sul VPS.** Serve solo un piccolo token GitHub.

---

## Passo 1 — Crea il token GitHub (una volta sola)

1. Vai su GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Fine-grained tokens** → **Generate new token**
2. **Token name:** `sveglia-report`
3. **Expiration:** 1 anno (o "No expiration")
4. **Repository access:** *Only select repositories* → scegli **`claudiospadaro12/GITHUB`**
5. **Permissions** → sezione *Repository permissions*:
   - **Actions** → **Read and write**
6. **Generate token** → **copia** il token (inizia con `github_pat_...`). Lo vedi una volta sola.

## Passo 2 — Salva il token sul VPS

1. Sul VPS apri il **Blocco note**
2. Incolla dentro **solo il token** (niente altro)
3. Salva il file come:
   `C:\Users\Administrator\.gh_report_token.txt`
   *(File → Salva con nome → scrivi il percorso esatto, "Tutti i file")*

## Passo 3 — Copia questi file sul VPS

Metti `trigger_report.ps1` e `setup_task.ps1` in una cartella sul VPS,
es. `C:\report_scheduler\`.

## Passo 4 — Registra l'operazione pianificata

1. Sul VPS, tasto destro su **PowerShell** → **Esegui come amministratore**
2. Vai nella cartella:
   ```powershell
   cd C:\report_scheduler
   ```
3. Lancia:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\setup_task.ps1
   ```
4. Deve stampare: `[OK] Operazione 'ReportMercatoGiornaliero' creata`.

## Passo 5 — Prova subito (senza aspettare le 07:00)

```powershell
Start-ScheduledTask -TaskName "ReportMercatoGiornaliero"
```
Dopo ~1-2 minuti dovresti ricevere la mail del report. Se arriva → **fatto per sempre.** ✅

---

## ⚠️ Controlla l'orario del VPS

Il Task Scheduler usa l'ora **locale del VPS**. Verifica l'orologio in basso a
destra sul VPS:

- Se è già **ora italiana** → le 07:00 vanno bene, non cambiare niente.
- Se il VPS è su **UTC** (ora di Londra) → apri `setup_task.ps1` e cambia
  `-At 7:00AM` in `-At 5:00AM` (estate) / `-At 6:00AM` (inverno), così
  corrisponde alle 07:00 di Roma. Poi rilancia il Passo 4.

## Come funziona (in breve)

```
VPS Task Scheduler (07:00, affidabile)
   └─> trigger_report.ps1  → chiama l'API di GitHub (workflow_dispatch)
        └─> il workflow parte SUBITO (niente ritardo GitHub)
             └─> genera il report e invia la mail
```

## Se qualcosa non va

- **Mail non arriva** dopo il Passo 5: controlla che il token abbia il permesso
  *Actions: Read and write* e che il file `.gh_report_token.txt` contenga solo il token.
- **"Token non trovato"**: il file non è in `C:\Users\Administrator\.gh_report_token.txt`.
- Puoi sempre vedere se il report è partito su GitHub → scheda **Actions** del repo.
