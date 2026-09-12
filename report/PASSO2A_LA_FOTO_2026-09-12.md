# 📸 PASSO 2A — LA FOTO PRIMA DI INSTALLARE. Verdetto: **la 2B SERVE**

**12/09/2026, 08:42 (ora VPS).** Claudio ha lanciato RIGA 2A.

## 🟢 IL VERDETTO ATTESO, CONFERMATO

| | impronta SHA-256 | righe | marcatore v3 |
|---|---|---:|---|
| runner **INSTALLATO** su `C:\ABTG` | `74BD2884…` | **347** | 🔴 **0** |
| runner **v3 dal pin** `8027068f` | `21AC6672…` | **836** | 🟢 **2** |

➡️ **DIVERSO.** Il VPS gira ancora la **v2**: e' la copia che alle 03:30 ha
rifiutato i quattro round con `G1: manca il marcatore`. **La 2B serve.**
E l'impronta `74BD2884…` **coincide cifra per cifra** con la linea di base che
avevo registrato l'11/09: nessuno ha toccato quel file nel frattempo.

## 🪟 I TERMINALI VIVI — e il riconoscimento e' un FATTO STAMPATO

```
7824  10105439 - BCMMarkets-Server - Hedge - [EURAUD,H1]        C:\BCM_Reale\terminal64.exe
8664  50504263 - Conto Demo - Hedge - [D30EUR,M5]               C:\Program Files\BCM Markets MT5 Terminal -V3\terminal64.exe
9780  50503392 - Conto Demo - Hedge - [EURJPY,M5]               C:\Program Files\BCM Markets MT5 Terminal\terminal64.exe
```

🔑 **TRE, non quattro**: il **banco `50504400` (`C:\MT5_Backtest`) e' SPENTO.**
Ed e' **giusto** — il runner in corsia ROUND avvia lui `terminal64` sul banco;
non deve trovarlo aperto. 📌 Ma va scritto, perche' "tre terminali" e' anche
quello che dice `CLAUDE.md`, e la coincidenza dei due numeri e' **casuale**:
la macchina ne ospita **sei** cartelle dati, di cui una spenta e due esterne.

## 🔴 LA CREPA NEL PARACADUTE — l'XML salvato **NON si potrebbe rimettere**

`ABTG_Runner_COME_E_ADESSO.xml` dichiara in testa `encoding="UTF-16"`, ma i
byte sono **ASCII**: `0` byte nulli, **nessun BOM**. Misurato, non dedotto.
`schtasks /Query /XML` produce **UTF-16**; la riga lo ha salvato con
`Out-File -Encoding ASCII`, e la **dichiarazione e' rimasta quella di prima**.

➡️ **`schtasks /Create /XML` lo RIFIUTEREBBE.** E' un file che **sembra** un
backup e non lo e' — la classe peggiore, perche' nessuno se ne accorge finche'
non serve.

🔴 **E non e' teorico, perche' la 2B TOCCA L'ATTIVITA'.** Nel runner v3, r.677-678:
```
cmd /c "schtasks /Delete /TN $task /F >nul 2>nul"
$out = cmd /c "schtasks /Create /TN $task /TR ""$azione"" /SC DAILY /ST $Ora /F 2>&1"
```
`-Installa` **cancella e ricrea** l'attivita': non e' solo uno scambio di file.

## 🟢 MA IL RITORNO INDIETRO E' SALVO COMUNQUE — e per due ragioni

1. **Il FILE c'e'**: `runner_INSTALLATO_PRIMA.ps1`, 18.605 byte, `74BD2884…`.
   Quello e' il pezzo che conta, ed e' intatto nello zip.
2. **L'INFORMAZIONE dell'attivita' c'e'**, anche se il contenitore e' malformato.
   Le tre cose che servono a ricostruirla sono leggibili nell'XML:
   - `Command` → `powershell`
   - `Arguments` → `-NoProfile -ExecutionPolicy Bypass -File C:\ABTG\runner_abtg.ps1`
   - `StartBoundary` → `2026-09-07T03:30:00` (quindi **daily 03:30**)
   - `UserId` → SID `S-1-5-21-…-1001`

👉 Quindi: **si puo' procedere.** Se la 2B fallisse, l'attivita' si ricostruisce
da questi quattro campi con una riga **che passa prima dal cancello** — non con
l'XML rotto.

📌 **Classe da mettere in checklist**: un backup salvato **ri-codificando** un
formato che dichiara la propria codifica in testa e' un backup **non
ripristinabile**. Si salva nella codifica NATIVA (`-Encoding Unicode` per
`schtasks /XML`), o si riscrive anche la dichiarazione.
