#!/usr/bin/env python3
"""Genera righe/ANNO80K_WIM_TESTER.ps1 dal tester gia usato (ANNO80K_TESTER.ps1, branch lavoro) con 4 modifiche minime:
 (1) EA cercato in tutto MQL5\\Experts (non solo Market): servono gli .ex5 del pacchetto Wim, scaricati dal sito;
 (2) -SetFile: copia (con eventuali -Imposti scritti DENTRO la copia) del .set del venditore in MQL5\\Profiles\\Tester e riga ExpertParameters nel .ini;
 (3) -Anno ammesso fino al 2026;
 (4) marcatore nuovo.
Uso: python3 gen_ANNO80K_WIM_TESTER.py <percorso ANNO80K_TESTER.ps1 base> """
import sys, hashlib
base = open(sys.argv[1], encoding='ascii').read()
t = base
def sost(a, b, n=1):
    global t
    assert t.count(a) == n, (t.count(a), a[:80])
    t = t.replace(a, b)
sost('MARCATORE_ANNO80K_TESTER_TRANCHE_v1', 'MARCATORE_ANNO80K_WIM_TESTER_v1', t.count('MARCATORE_ANNO80K_TESTER_TRANCHE_v1'))
sost("  [string]$Base = ''\n", "  [string]$Base = '',\n  [string]$SetFile = ''\n")
sost("if($Anno -notmatch '^20(0[5-9]|1[0-9]|2[0-5])$'){ throw ('-Anno \"' + $Anno + '\" non valido: serve un anno fra 2005 e 2025, per esempio 2013') }",
     "if($Anno -notmatch '^20(0[5-9]|1[0-9]|2[0-6])$'){ throw ('-Anno \"' + $Anno + '\" non valido: serve un anno fra 2005 e 2026, per esempio 2013') }")
sost("$MktDir = Join-Path $MqlExp 'Market'", "$MktDir = $MqlExp   # WIM v1: gli .ex5 del pacchetto Wim stanno in MQL5\\Experts (es. cartella Wim), non nel Market")
blocco = r'''
# WIM v1 (04/11/2026): -SetFile = percorso di un .set del venditore. Se c e, viene COPIATO (mai modificato l originale) in MQL5\Profiles\Tester con un nome nostro;
# gli eventuali -Imposti (es. nome dei simboli del broker) sono scritti DENTRO la copia e NON in [TesterInputs] (non so quale dei due vinca); il report li conferma o la passata e KO.
$SetNome = ''
$SetDest = ''
if($SetFile -ne ''){
  if(-not (Test-Path -LiteralPath $SetFile)){ throw ('-SetFile ' + $SetFile + ' non esiste: nessun tester e partito.') }
  $sb = [IO.File]::ReadAllBytes($SetFile)
  $uni = ($sb.Length -ge 2 -and $sb[0] -eq 255 -and $sb[1] -eq 254)
  if($uni){ $stxt = [Text.Encoding]::Unicode.GetString($sb, 2, $sb.Length - 2) } else { $stxt = [Text.Encoding]::ASCII.GetString($sb) }
  foreach($ip in $INPUT_IMPOSTI){
    $val = $ip[1]
    if($ip[2] -eq 'b'){ if($val -eq 'true'){ $val = '1' } else { $val = '0' } }
    $rx = '(?m)^' + [regex]::Escape($ip[0]) + '=[^\r\n|]*'
    if([regex]::IsMatch($stxt, $rx)){ $stxt = [regex]::Replace($stxt, $rx, ($ip[0] + '=' + $val)) } else { $stxt = $stxt.TrimEnd() + "`r`n" + $ip[0] + '=' + $val + "`r`n" }
  }
  $safe = [regex]::Replace([IO.Path]::GetFileNameWithoutExtension($SetFile), '[^A-Za-z0-9_.-]', '_')
  $SetNome = 'wim_' + $TOKL + '_' + $safe + '.set'
  $profT = Join-Path (Join-Path (Join-Path $DataFolder 'MQL5') 'Profiles') 'Tester'
  New-Item -ItemType Directory -Force -Path $profT | Out-Null
  $SetDest = Join-Path $profT $SetNome
  if($uni){ $enc = New-Object Text.UnicodeEncoding($false, $true); $outb = [byte[]]($enc.GetPreamble() + $enc.GetBytes($stxt)) } else { $outb = [byte[]][Text.Encoding]::ASCII.GetBytes($stxt) }
  [IO.File]::WriteAllBytes($SetDest, $outb)
  Dico ('set    : ' + $SetNome + '   (copia di ' + [IO.Path]::GetFileName($SetFile) + ', SHA256 originale ' + (Get-FileHash -LiteralPath $SetFile -Algorithm SHA256).Hash + ', SHA256 copia ' + (Get-FileHash -LiteralPath $SetDest -Algorithm SHA256).Hash + ', input riscritti nella copia ' + $INPUT_IMPOSTI.Count + ')') 'Green'
}
'''
sost("$DataEx5 = $Ex5.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC)\n", "$DataEx5 = $Ex5.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss', $IC)\n" + blocco)
sost("('Expert=' + $RelEx5), ('Symbol=' + $SIMBOLO)", "('Expert=' + $RelEx5), $(if($SetNome -ne ''){ 'ExpertParameters=' + $SetNome } else { '; nessun set' }), ('Symbol=' + $SIMBOLO)")
sost("  foreach($ip in $INPUT_IMPOSTI){ if($ip[2] -eq 's'){ [void]$r.Add($ip[0] + '=' + (($ip[1] -replace '\\+', ';') + ';')) } else { [void]$r.Add($ip[0] + '=' + $ip[1]) } }",
     "  if($SetNome -eq ''){ foreach($ip in $INPUT_IMPOSTI){ if($ip[2] -eq 's'){ [void]$r.Add($ip[0] + '=' + (($ip[1] -replace '\\+', ';') + ';')) } else { [void]$r.Add($ip[0] + '=' + $ip[1]) } } }")
sost("(Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null\n", "(Join-Path $Cart 'log'), (Join-Path $Cart 'ini') | Out-Null\nif($SetNome -ne ''){ Copy-Item -LiteralPath $SetDest -Destination (Join-Path (Join-Path $Cart 'ini') $SetNome) -Force }\n")
open('righe/ANNO80K_WIM_TESTER.ps1', 'w', encoding='ascii', newline='').write(t)
print('ok', len(t), hashlib.sha256(t.encode('ascii')).hexdigest().upper())
