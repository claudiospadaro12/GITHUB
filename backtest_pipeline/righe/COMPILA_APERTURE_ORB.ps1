# =====================================================================
#  MARCATORE_COMPILA_APERTURE_ORB_v1
#
#  PACCHETTO DI RICOMPILAZIONE: DAX Apertura, Dow Apertura e ORB.
#  PORTA I SORGENTI "CHIUSURA PER TICKET" NELLA CARTELLA DATI DEL
#  TERMINALE SCELTO (piccolo 50503392 oppure 100k 50504263).
#  NON COMPILA: l'F7 e' a mano, ed e' di Claudio.
#
#  PERCHE': i binari in campo sono PRECEDENTI al 19/09/2026 e usano
#  gTrade.PositionClose(_Symbol), che su conto HEDGING chiude la posizione
#  PIU' VECCHIA del simbolo, DI CHIUNQUE SIA (commento "TOPPA HEDGE-SAFE"
#  nei sorgenti). Referto: report/SALA_CONSIGLIO_DAX_DOW_ORB_2026-10-23.md
#
#  COSA PORTA (versioni gia' in campo sul FTMO e sul PC di backtest):
#    ABTG_DAX_Apertura_EU.mq5   @ 9fca63d9 (non HEAD: HEAD ha +460 righe di
#                                filtro dello spazio mai misurato)
#    ABTG_Dow_Apertura_US.mq5   @ 9fca63d9
#    ABTG_ORB_Ottimizzato.mq5   @ 19312c8b (v1.04; HEAD aggiunge solo l'export CSV)
#  Input nuovi rispetto ai binari vecchi (verificati col diff dei sorgenti):
#    DAX: InpAllowReverse=false, InpUsaGuardian=true   Dow: InpUsaGuardian=true
#    ORB (da v1.02): InpAutoTest=true (stampa soltanto)
#
#  COSA FA, PER INTERO E SENZA SORPRESE:
#    1. certifica la cartella DATI del terminale scelto (hash COSTANTE) con
#       origin.txt, e rifiuta qualunque altro percorso;
#    2. trova i tre .mq5 in MQL5\Experts (esattamente uno ciascuno);
#    3. COPIA DI SICUREZZA sul Desktop di .mq5 e .ex5 (cartella + zip);
#    4. classifica cio' che c'e': GIA IN CAMPO / vintage NOTO (commit) /
#       SCONOSCIUTO. Se c'e' uno SCONOSCIUTO si ferma (backup gia' fatto),
#       salvo -AccettaSconosciuti;
#    5. CENSISCE MQL5\Include\ABTG_PausaGuardian.mqh: se manca lo installa
#       alla v1.20 (la stessa viva sul 100k); se c'e' NON LO TOCCA;
#    6. scarica i sorgenti per COMMIT e ne verifica l'impronta PRIMA di scrivere;
#    7. copia, rilegge dal disco e stampa la tabella.
#
#  COSA NON FA:
#    - NON compila; NON apre, NON chiude, NON tocca nessun processo (nessuna
#      chiamata capace di terminarne);
#    - NON tocca preset, .set, .chr, input, ordini, posizioni;
#    - NON scrive in nessuna cartella dati che non sia quella certificata.
#
#  SENZA -Esegui e' una PROVA: fa i passi 1-4 (e la copia di sicurezza sul Desktop),
#  non scrive niente nel terminale. Con -Esegui fa anche i passi 5-7.
#
#  ASCII PURO (PS 5.1 legge i .ps1 come ANSI).
# =====================================================================

param(
  [Parameter(Mandatory=$true)][ValidateSet('piccolo','100k')][string]$Dove,
  [switch]$Esegui,
  [switch]$AccettaSconosciuti
)

$ErrorActionPreference = 'Stop'
$INV = [Globalization.CultureInfo]::InvariantCulture
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

# COSTANTI DEL BERSAGLIO (non parametri: un bersaglio passato da fuori si puo' sbagliare da fuori)
if($Dove -eq 'piccolo'){
  $HASH_DATI    = '215D85D767A1C39E22D242C8114BF9F5'
  $CONTO        = '50503392'
  $PROG_ATTESO  = 'C:\Program Files\BCM Markets MT5 Terminal'
  $PROG_VIETATI = @('-V3', 'BCM_Reale', 'MT5_Backtest', 'MT5_MANUALE', 'Pepperstone', 'Tickmill', 'FTMO')
} else {
  $HASH_DATI    = 'BCA8AD18563BF5B64A433C2662D0A104'
  $CONTO        = '50504263'
  $PROG_ATTESO  = 'C:\Program Files\BCM Markets MT5 Terminal -V3'
  $PROG_VIETATI = @('BCM_Reale', 'MT5_Backtest', 'MT5_MANUALE', 'Pepperstone', 'Tickmill', 'FTMO')
}

$REPO_RAW = 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB'
$INC_REPO   = 'mql5/Include/ABTG_PausaGuardian.mqh'
$INC_COMMIT = '5fc0bc31f3a74431f23976e52051af1c1e3b4e0d'
$INC_RIGHE  = 398
$INC_SHA    = 'D179846B407FDACC963825103F850E8F8BEE39B1DA3521A504EF74F8638AC8BC'
$INC_HEAD_RIGHE = 2461
$INC_HEAD_SHA   = 'E9F503F581265A00E4389E8482A18FB9244AA53529A9969CA358137E39EF344C'

# nome | commit sorgente | righe e sha DOPO | vintage NOTI (sha scheletro -> commit)
$TAVOLA = @(
  [pscustomobject]@{
    Nome      = 'ABTG_DAX_Apertura_EU.mq5'
    Commit    = '9fca63d98046e60b29f9300fc09dad7738cc887d'
    RighePost = 2425
    ShaPost   = '59B67F5F912476E270C62079C80799B3E86F696AEE2F17BD158E2B4828BAD692'
    Noti      = @{
      '6D19136F044919A6DCFCE40F29017F88852FE180FD337B64B009BEE7F74059AF' = '99f58562 2026-09-21 (2885 righe)'
      '59C93F6064CC06C8C898106C977CB4F3BC182F990F2AB5A908B05C62321DA088' = 'bfacc1fd 2026-09-21 (2854 righe)'
      'C0B248DC6A2A4D3976863315121AB1142693B0798EB07AF77DEE338409FB7F8C' = '5d52a456 2026-09-21 (2732 righe)'
      '59B67F5F912476E270C62079C80799B3E86F696AEE2F17BD158E2B4828BAD692' = '9fca63d9 2026-09-19 (2425 righe)'
      'CA6CC3AFD0E6E131F976EAE93202BF231FBB9B06A31C60090C699FE6ECDE46C2' = '9638318f 2026-09-02 (2367 righe)'
      'F93EF55C3A38CDD7E85AC94C8A9AF6A75D50975AB0654F11F841E345D4249F16' = 'd83c1960 2026-08-19 (2360 righe)'
      '5D7171384C47B2A52208F99CC714C28763EC4211941AA55BADB9600931CE6AE1' = 'bc110939 2026-08-14 (2333 righe)'
      'D14C5D2101320B32913C34FDE715F772655A2E34D9EDFBDD48CF757AE29A2A9B' = 'c88d160a 2026-08-14 (2311 righe)'
      '5814471B27D6A017FBF14F40B420621FB5F6798C4C2CA7501B870726D185AAAB' = '6074126d 2026-08-08 (2169 righe)'
      '0B0862963D49424E2EE1CE6222C3C10172FCEBF9A1B841A14F6A77428B2E178C' = '3af47ed9 2026-08-08 (2132 righe)'
      '5471E4FF5AE5D5F78712C9460D0D5FA2F37E099A7821EF2635C4617825E2B1FF' = 'e1609a01 2026-08-07 (2119 righe)'
      'BAA66C1DB65DD3EB48EBD879AB475FEF8F3D1940C5BBD086BF67F1C7078D9508' = '0b07e462 2026-08-07 (2100 righe)'
      'C9E3F02DC2FFCFDC765280444ADA9E9C48FCB4AEAAC1048BC04E9DDF9EB78F71' = 'ef3be41f 2026-08-06 (2095 righe)'
      'ED71ECDD6CA4B0566BF25744EDEDB1C33D007A6AA857FCD81210EDAB89169A19' = '090141a5 2026-08-06 (2083 righe)'
      '65AEE6FC769C24F267CED0D2F215E45EA84B0304605D4ECDB5E9F85BA16BFF22' = '84849f72 2026-08-06 (2030 righe)'
      '58364C82580954ABBA1BA618FA8A291402A5F92C639BAF88E94356164F3D9A54' = '6e8c3f4c 2026-08-06 (2003 righe)'
      'CFBDFCD06257F0C5ACCA0120690F68E4104332DC9AC967421668FF83FC5BD040' = '2ce7abce 2026-08-06 (1911 righe)'
      '1C52E008EE557D3C3410D2120CE9D2DDB65CEE0373B597B61CDFE27EB19F66F6' = 'eba618ba 2026-08-05 (1906 righe)'
      '79A0F5E0B472ED55227A137AE1EDC0C97E0363BA1AAE1D114ADB37E2B6717238' = '0a2502f2 2026-08-05 (1876 righe)'
      '4A8CFB5E43819D46464E32044D76CCBF13EC499FFBF17726748A97BEB168F5D8' = '586e19d4 2026-08-05 (1869 righe)'
      '18EBC21E8DCF479147007A62A8DCA7D98B51438CE959440ED840D6CF088A68EA' = 'da0ac95b 2026-08-05 (1859 righe)'
      '0E256A6A5ECB9294B3C14D9687406CFBBBFF15342E7238DB379129717E98BF65' = '822ec56d 2026-08-02 (1752 righe)'
      '7DFB6F8DF8383A948CCC51C9926D5CAFC8A1CC5AFB362D06A7AE03A22562072F' = '8c31ce1c 2026-08-02 (1726 righe)'
      '135F3C630F88FE5A8D6344453FDA856DE35B2C68D747D68B65EBF42CC63AC850' = 'cfc9945d 2026-08-02 (1688 righe)'
      'F2B9996A93D096D25D93700536247075915575947448BD78B12BFEAD30B0387E' = '7bb8924e 2026-08-02 (1538 righe)'
      '0F7EDC6C1572AF3DB62014452532B931113D3696191387387214A54532C269AB' = 'dba4bcd8 2026-08-01 (1466 righe)'
      'D16019E8779A8B6E5C8A0B25161F58EB9816497E6A65FCB6FB10C30C715FC0FD' = 'f98e9e1e 2026-08-01 (1441 righe)'
      'C1318597DC627D1CC7C8EBDE246909DC1221F9C9A4A0C164C814831BFC6558DD' = '8474785e 2026-08-01 (1303 righe)'
      '82BA163A940A48101E74179716F48EBD7D6CC7D48722FBA93D307A5774EF85E5' = '22a995e2 2026-07-30 (1282 righe)'
      '2A81CEACC294AFD85FCD3D828F982753B84B567474DD96FAD77441B75FE67103' = 'bf486160 2026-07-29 (1245 righe)'
      '6E379867B0B831AE5C4B495B320D6B2BF646E5D8370C06848D14ADAE5AAFDB72' = '36d344c5 2026-07-28 (1237 righe)'
      '21409DB17C9D91EA01D8F17B1D2B4A6139D3C14856A567D0DDB714EC730B50F1' = 'a86089c8 2026-07-26 (1224 righe)'
    }
  },
  [pscustomobject]@{
    Nome      = 'ABTG_Dow_Apertura_US.mq5'
    Commit    = '9fca63d98046e60b29f9300fc09dad7738cc887d'
    RighePost = 2205
    ShaPost   = '0BF7A1B3466DA1A0807421B3CFAF59A0455276B2DD98CA8FBF610FEB391019B1'
    Noti      = @{
      '0BF7A1B3466DA1A0807421B3CFAF59A0455276B2DD98CA8FBF610FEB391019B1' = '9fca63d9 2026-09-19 (2205 righe)'
      '396C86A80D245F1111E0F378E8A1F3355ABF32077380CA4663B659D51A8B8931' = 'd83c1960 2026-08-19 (2147 righe)'
      'D95D9A7EE6AC326517002489D57961E8DC7701E872240C9EC22C297830FD882D' = '8b922147 2026-08-14 (2120 righe)'
      '81BE7D3E0EA2BA77EA295A6EBEB531FAAFA0CAA4E5812574B1858857D55EADF8' = '6074126d 2026-08-08 (2101 righe)'
      '255058CF8DD5427A6BE5ED510866546C1C932E2E775AFEFB36768BD1C7339350' = '3af47ed9 2026-08-08 (2064 righe)'
      'B05B1686A7B3D6ACDEC0967910C024C34977A48F1E0BCB41D982AE7CE886C5CB' = 'e1609a01 2026-08-07 (2051 righe)'
      'BCBB3A0F603564B98C4EE099E94E98F6D3E314553DF90BCB2342B365EEAB4587' = '0b07e462 2026-08-07 (2032 righe)'
      '280F350142C6E0612BBFE3D47DB418107280111DC4B888BDDC5006B3DCCF72F5' = 'ef3be41f 2026-08-06 (2027 righe)'
      'D1C6D743C9D9640254BCE7DB339CFDF222BC2271F64757C70B8539DFA7C8A69C' = '090141a5 2026-08-06 (2015 righe)'
      'A323064AC31171AA34AF757879EC5A09B173570FDD272204B82B2067F1804198' = '84849f72 2026-08-06 (2007 righe)'
      'D16221DC0826992BE4158CE0AAA474638C6A2E5F814BFB3FB4C96D50886DA63A' = '6e8c3f4c 2026-08-06 (1982 righe)'
      '4F4F7EF192224FD5D5AFDC06008094DD9EAE57CBAAF08C098D003AD8E15AF951' = '2ce7abce 2026-08-06 (1890 righe)'
      '94039A48FE9F3D4E3C200F4AD14E043F271BEB651D4107106853EA31C2CE7D5A' = 'eba618ba 2026-08-05 (1885 righe)'
      '6F040121E8598C4A6C90EAA36F5E0A530B49A1AE60ADDA419190C8D71CBE203A' = '586e19d4 2026-08-05 (1855 righe)'
      '51C14366F5EE3FD57DE14720B02A15AC40CE13172071F04054E60C74F21EF5AD' = 'da0ac95b 2026-08-05 (1845 righe)'
      'E600B1B77EA2A08C89D87E75CCE5EDA84F1E37FD190E929911662245BA712CEE' = 'c5654989 2026-08-04 (1738 righe)'
      '2493EE623AB3DB4536FE164E29A3186BDC1B327FCBF957444E8479DCD3E72B04' = '2a927b64 2026-08-04 (1735 righe)'
    }
  },
  [pscustomobject]@{
    Nome      = 'ABTG_ORB_Ottimizzato.mq5'
    Commit    = '19312c8bb745e954c5456f9dba382416502d5bc6'
    RighePost = 1463
    ShaPost   = '19B596E3032DD0A0A7B7C44AE9ED53853D6BAF0DCF8E7AECA0E8D85DE9AEBE3C'
    Noti      = @{
      '68E33392C1C223208BED09C66F652099DA9908D6FDFCDB0A3BA6FB6737B637D1' = 'a66dcb07 2026-09-28 (1483 righe)'
      '19B596E3032DD0A0A7B7C44AE9ED53853D6BAF0DCF8E7AECA0E8D85DE9AEBE3C' = '19312c8b 2026-09-03 (1463 righe)'
      '8FAEBA7A484B533BAE674779E0153EFE42D02FFC1DD2ED2589603E24CCE80C7D' = 'ad1f0248 2026-09-02 (1007 righe)'
      'EF5BAB2505892F7F7FE4B0C02AD70CA85AB659DCD0BD19192162A1A26DBC0AD3' = '3125e343 2026-08-19 (822 righe)'
      '778A6EEC1EF1CC0AA41BC71CDF5F089DBCDE6E6184D66287D17C2C7BCA0DE831' = '5fc0bc31 2026-08-19 (771 righe)'
      'B499F423F5C49D627E3A3A778C17962A05C965A313DAE7D6A8091899D99B3D16' = '4c424e2b 2026-08-15 (754 righe)'
      'C9B9F29D2F0FAA1EC2D6B6EB81180BCE988F4831B50D0DBED4A1790E96A56F57' = '6074126d 2026-08-08 (721 righe)'
      '328C82D9B1D96EB24CE3287771D7762E147FC140C847F82B81F27F2668587F33' = '5a941a5d 2026-08-08 (684 righe)'
      '9B188A6AF348A336483EDCD1E1856426F5949143D1BEF525FA033EF1139D4156' = '96d652aa 2026-08-08 (682 righe)'
      '60FF3C1081C90CC37E4DEE2AB1AC8F83230E91DEE3BBCC5EEDE6954A64C0CDA3' = '099d6648 2026-08-08 (674 righe)'
    }
  }
)

function Leggi-Testo($path) {
  $b = $null
  $fs = [IO.File]::Open($path, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
  try {
    $b = New-Object byte[] $fs.Length
    $letti = 0
    while($letti -lt $b.Length){
      $q = $fs.Read($b, $letti, $b.Length - $letti)
      if($q -le 0){ break }
      $letti += $q
    }
  } finally { $fs.Close() }
  if($null -eq $b -or $b.Count -lt 2){ return '' }
  if($b[0] -eq 0xFF -and $b[1] -eq 0xFE){ return [Text.Encoding]::Unicode.GetString($b) }
  $zeri = 0
  $n = [math]::Min(400, $b.Count)
  for($i = 1; $i -lt $n; $i += 2){ if($b[$i] -eq 0){ $zeri++ } }
  if($zeri -gt ($n / 4)){ return [Text.Encoding]::Unicode.GetString($b) }
  return [Text.Encoding]::UTF8.GetString($b)
}

# Scheletro ASCII: CRLF->LF, via i caratteri fuori dall'ASCII stampabile, via l'a-capo finale.
function Scheletro($testo) {
  $t = $testo -replace "`r`n", "`n"
  $t = $t -replace "`r", "`n"
  $t = $t -replace '[^\u0009\u000A\u0020-\u007E]', ''
  $t = $t.TrimEnd("`n")
  $righe = ($t -split "`n").Count
  $sha = [Security.Cryptography.SHA256]::Create()
  try {
    $hb = $sha.ComputeHash([Text.Encoding]::ASCII.GetBytes($t))
  } finally { $sha.Dispose() }
  $sb = New-Object Text.StringBuilder
  foreach($x in $hb){ [void]$sb.Append($x.ToString('X2', $INV)) }
  return [pscustomobject]@{ Righe = $righe; Sha = $sb.ToString() }
}

function Muori($msg) {
  Write-Host ''
  Write-Host '=====================================================================' -ForegroundColor Red
  Write-Host ('FERMO: ' + $msg) -ForegroundColor Red
  Write-Host 'NESSUN FILE DEL TERMINALE E STATO SOSTITUITO (la copia di sicurezza, se fatta, e sul Desktop).' -ForegroundColor Red
  Write-Host 'STATO: FERMO'
  Write-Host '=====================================================================' -ForegroundColor Red
  exit 1
}

Write-Host '====================================================================='
Write-Host ' RICOMPILAZIONE DAX / DOW / ORB -- SOLO COPIA DI FILE, NESSUNA COMPILAZIONE'
Write-Host (' bersaglio: ' + $Dove + ' (conto ' + $CONTO + '), cartella dati ' + $HASH_DATI)
Write-Host (' ora      : ' + (Get-Date).ToString('yyyy-MM-dd HH:mm:ss', $INV) + '  (ora locale)')
Write-Host '====================================================================='
Write-Host ''

# PASSO 1 -- cartella dati e certificazione
$radice = Join-Path $env:APPDATA 'MetaQuotes\Terminal'
$dati   = Join-Path $radice $HASH_DATI
if(-not (Test-Path -LiteralPath $dati)){ Muori ('la cartella dati ' + $HASH_DATI + ' non esiste sotto ' + $radice + '.') }
$origine = Join-Path $dati 'origin.txt'
if(-not (Test-Path -LiteralPath $origine)){ Muori ('manca origin.txt in ' + $dati + ': senza certificato non si scrive niente.') }
$prog = ((Leggi-Testo $origine) -replace '[^\u0020-\u007E]', '').Trim()
foreach($v in $PROG_VIETATI){
  if($prog -like ('*' + $v + '*')){ Muori ('VIETATO: la cartella ' + $HASH_DATI + ' appartiene a "' + $prog + '", che contiene "' + $v + '". Non e il terminale ' + $CONTO + '.') }
}
if($prog -ne $PROG_ATTESO){ Muori ('VIETATO: origin.txt dice "' + $prog + '", atteso "' + $PROG_ATTESO + '". Bersaglio non certificato.') }
Write-Host ('[1/7] cartella dati CERTIFICATA: ' + $prog) -ForegroundColor Green
Write-Host ('      ' + $dati)
$esperti = Join-Path $dati 'MQL5\Experts'
if(-not (Test-Path -LiteralPath $esperti)){ Muori ('manca ' + $esperti) }

# PASSO 2 -- i tre file, uno ciascuno
$tutti = @(Get-ChildItem -LiteralPath $esperti -Filter *.mq5 -Recurse -File -ErrorAction SilentlyContinue)
$trovati = @()
foreach($r in $TAVOLA){
  $c = @($tutti | Where-Object { $_.Name -eq $r.Nome })
  if($c.Count -eq 0){ Muori ('non trovo ' + $r.Nome + ' sotto ' + $esperti) }
  if($c.Count -gt 1){ Muori ($r.Nome + ' esiste in ' + $c.Count.ToString($INV) + ' copie sotto ' + $esperti + ': non so quale gira.') }
  $trovati += [pscustomobject]@{ Riga = $r; Path = $c[0].FullName; Stato = ''; Pre = $null; Scaricato = '' }
}
Write-Host '[2/7] i tre sorgenti trovati, una copia ciascuno:' -ForegroundColor Green
foreach($t in $trovati){ Write-Host ('      ' + $t.Path) }

# PASSO 3 -- copia di sicurezza di .mq5 e .ex5 (SEMPRE, prima di qualunque scrittura)
$stamp = (Get-Date).ToString('yyyy-MM-dd_HHmmss', $INV)
$desk  = Join-Path $env:USERPROFILE 'Desktop'
if(-not (Test-Path -LiteralPath $desk)){ $desk = $env:USERPROFILE }
$cartBk = Join-Path $desk ('COMPILA_APERTURE_' + $Dove + '_' + $stamp)
$dirBk  = Join-Path $cartBk 'ORIGINALI'
[void](New-Item -ItemType Directory -Path $dirBk -Force)
foreach($t in $trovati){
  Copy-Item -LiteralPath $t.Path -Destination (Join-Path $dirBk $t.Riga.Nome) -Force
  $ex = [IO.Path]::ChangeExtension($t.Path, '.ex5')
  if(Test-Path -LiteralPath $ex){ Copy-Item -LiteralPath $ex -Destination (Join-Path $dirBk ([IO.Path]::GetFileName($ex))) -Force }
}
$zipBk = Join-Path $desk ('COMPILA_APERTURE_' + $Dove + '_' + $stamp + '_ORIGINALI.zip')
Compress-Archive -Path (Join-Path $dirBk '*') -DestinationPath $zipBk -Force
Write-Host '[3/7] COPIA DI SICUREZZA fatta (.mq5 e .ex5 originali):' -ForegroundColor Green
Write-Host ('      cartella: ' + $dirBk)
Write-Host ('      zip     : ' + $zipBk)

# PASSO 4 -- classificazione di cio' che c'e'
Write-Host '[4/7] classifico i file presenti...'
$sconosciuti = @()
foreach($t in $trovati){
  $s = Scheletro (Leggi-Testo $t.Path)
  $t.Pre = $s
  $esito = ''
  if($s.Sha -eq $t.Riga.ShaPost){ $t.Stato = 'GIA_IN_CAMPO'; $esito = 'GIA IN CAMPO (e gia la versione per ticket)' }
  elseif($t.Riga.Noti.ContainsKey($s.Sha)){ $t.Stato = 'NOTO'; $esito = 'vintage noto: ' + $t.Riga.Noti[$s.Sha] }
  else { $t.Stato = 'SCONOSCIUTO'; $esito = 'SCONOSCIUTO (non e nessuna versione del repo)'; $sconosciuti += $t.Riga.Nome }
  Write-Host ('      ' + $t.Riga.Nome.PadRight(28) + ' righe=' + $s.Righe.ToString($INV).PadLeft(5) + '  sha=' + $s.Sha.Substring(0,16) + '  -> ' + $esito)
}
$daFare = @($trovati | Where-Object { $_.Stato -ne 'GIA_IN_CAMPO' })
if($daFare.Count -eq 0){
  Write-Host ''
  Write-Host '      Tutti e tre i sorgenti sono gia la versione per ticket: niente da sostituire.' -ForegroundColor Green
  Write-Host '      Se il .ex5 e piu vecchio del .mq5, serve solo l F7 (vedi sotto).' -ForegroundColor Yellow
  Write-Host ('      copia di sicurezza: ' + $zipBk)
  Write-Host 'STATO: GIA_IN_CAMPO'
  exit 0
}
if($sconosciuti.Count -gt 0 -and -not $AccettaSconosciuti){
  Write-Host ''
  foreach($g in $sconosciuti){ Write-Host ('      SCONOSCIUTO: ' + $g) -ForegroundColor Yellow }
  Write-Host '      Su questo terminale il sorgente non coincide con nessuna versione del repo:' -ForegroundColor Yellow
  Write-Host '      puo avere modifiche locali che la sostituzione cancellerebbe. Manda lo zip qui sotto' -ForegroundColor Yellow
  Write-Host ('      ' + $zipBk) -ForegroundColor Yellow
  Muori 'sorgente sconosciuto: non sostituisco senza una tua conferma esplicita (-AccettaSconosciuti).'
}
if($sconosciuti.Count -gt 0){ Write-Host '      -AccettaSconosciuti attivo: gli sconosciuti vengono sostituiti (originali nel backup).' -ForegroundColor Yellow }

if(-not $Esegui){
  Write-Host ''
  Write-Host '=====================================================================' -ForegroundColor Cyan
  Write-Host ' PROVA: nessun file del terminale e stato toccato.' -ForegroundColor Cyan
  foreach($t in $daFare){ Write-Host ('   verrebbe sostituito: ' + $t.Riga.Nome + '  (' + $t.Stato + ', ' + $t.Pre.Righe.ToString($INV) + ' righe -> ' + $t.Riga.RighePost.ToString($INV) + ' righe)') -ForegroundColor Cyan }
  Write-Host (' copia di sicurezza (.mq5 e .ex5) gia sul Desktop: ' + $zipBk) -ForegroundColor Cyan
  Write-Host '=====================================================================' -ForegroundColor Cyan
  Write-Host 'STATO: PROVA_OK'
  exit 0
}

# PASSO 5 -- l'include: si CENSISCE, non si riscrive
$dirInc  = Join-Path $dati 'MQL5\Include'
$pathInc = Join-Path $dirInc 'ABTG_PausaGuardian.mqh'
$incEsito = ''
if(Test-Path -LiteralPath $pathInc){
  $si = Scheletro (Leggi-Testo $pathInc)
  if($si.Sha -eq $INC_SHA){ $incEsito = 'PRESENTE alla v1.20 (righe ' + $si.Righe.ToString($INV) + '). NON TOCCATO.'; Write-Host ('[5/7] include: ' + $incEsito) -ForegroundColor Green }
  elseif($si.Sha -eq $INC_HEAD_SHA){ $incEsito = 'PRESENTE alla versione di HEAD (righe ' + $si.Righe.ToString($INV) + '). NON TOCCATO.'; Write-Host ('[5/7] include: ' + $incEsito) -ForegroundColor Green }
  else {
    $incEsito = 'PRESENTE ma di versione SCONOSCIUTA: righe ' + $si.Righe.ToString($INV) + ', sha ' + $si.Sha.Substring(0,16) + '. NON TOCCATO.'
    Write-Host ('[5/7] include: ' + $incEsito) -ForegroundColor Yellow
    Write-Host '      I tre EA usano solo ABTG_GuardiaIngresso(bool,string): se l F7 da errore sull include, mandami questa riga.' -ForegroundColor Yellow
  }
} else {
  Write-Host '[5/7] include: ASSENTE. Lo installo alla v1.20 (senza di lui l F7 non parte).' -ForegroundColor Yellow
  $urlInc = $REPO_RAW + '/' + $INC_COMMIT + '/' + $INC_REPO
  $wi = New-Object Net.WebClient
  try { $bi = $wi.DownloadData($urlInc) } catch { Muori ('scaricamento dell include FALLITO da ' + $urlInc + ' -- ' + $_.Exception.Message) } finally { $wi.Dispose() }
  $sI = Scheletro ([Text.Encoding]::UTF8.GetString($bi))
  if($sI.Righe -ne $INC_RIGHE -or $sI.Sha -ne $INC_SHA){ Muori ('l include scaricato NON e quello atteso (righe ' + $sI.Righe.ToString($INV) + ', sha ' + $sI.Sha.Substring(0,16) + ').') }
  if(-not (Test-Path -LiteralPath $dirInc)){ [void](New-Item -ItemType Directory -Path $dirInc -Force) }
  [IO.File]::WriteAllBytes($pathInc, $bi)
  $incEsito = 'ERA ASSENTE, INSTALLATO alla v1.20 (righe ' + $INC_RIGHE.ToString($INV) + ').'
  Write-Host ('      ' + $incEsito) -ForegroundColor Green
}

# PASSO 6 -- scarico e verifico PRIMA di scrivere
Write-Host '[6/7] scarico dal commit i sorgenti da sostituire e ne verifico l impronta...'
$dirTmp = Join-Path $cartBk 'NUOVI'
[void](New-Item -ItemType Directory -Path $dirTmp -Force)
$wc = New-Object Net.WebClient
try {
  foreach($t in $daFare){
    $url = $REPO_RAW + '/' + $t.Riga.Commit + '/mql5/Experts/' + $t.Riga.Nome
    $dst = Join-Path $dirTmp $t.Riga.Nome
    $byte = $wc.DownloadData($url)
    [IO.File]::WriteAllBytes($dst, $byte)
    $s = Scheletro ([Text.Encoding]::UTF8.GetString($byte))
    if($s.Righe -ne $t.Riga.RighePost -or $s.Sha -ne $t.Riga.ShaPost){
      Muori ('il file scaricato ' + $t.Riga.Nome + ' NON e quello atteso (righe ' + $s.Righe.ToString($INV) + ' contro ' + $t.Riga.RighePost.ToString($INV) + ', sha ' + $s.Sha.Substring(0,16) + ' contro ' + $t.Riga.ShaPost.Substring(0,16) + ').')
    }
    $t.Scaricato = $dst
    Write-Host ('      ' + $t.Riga.Nome.PadRight(28) + ' scaricato e verificato (righe ' + $s.Righe.ToString($INV) + ')') -ForegroundColor Green
  }
} finally { $wc.Dispose() }

# PASSO 7 -- sostituzione e rilettura
Write-Host '[7/7] sostituzione...'
foreach($t in $daFare){
  try { Copy-Item -LiteralPath $t.Scaricato -Destination $t.Path -Force }
  catch { Write-Host ('      COPIA FALLITA su ' + $t.Riga.Nome + ': ' + $_.Exception.Message) -ForegroundColor Red }
}
Write-Host ''
Write-Host '====================================================================='
Write-Host ' RISULTATO -- riletto dal disco del terminale, non dedotto'
Write-Host '====================================================================='
Write-Host ('  ' + 'FILE'.PadRight(28) + 'PRIMA'.PadLeft(7) + 'DOPO'.PadLeft(8) + '   ESITO')
$tuttoBene = $true
foreach($t in $trovati){
  $s = Scheletro (Leggi-Testo $t.Path)
  $ok = ($s.Sha -eq $t.Riga.ShaPost)
  if(-not $ok){ $tuttoBene = $false }
  $e = 'ENTRATA'
  if($t.Stato -eq 'GIA_IN_CAMPO'){ $e = 'GIA IN CAMPO' }
  if(-not $ok){ $e = 'NON ENTRATA -- controllare a mano' }
  $col = 'Green'
  if(-not $ok){ $col = 'Red' }
  Write-Host ('  ' + $t.Riga.Nome.PadRight(28) + $t.Pre.Righe.ToString($INV).PadLeft(7) + $s.Righe.ToString($INV).PadLeft(8) + '   ' + $e) -ForegroundColor $col
}
Write-Host ''
Write-Host ('  include ABTG_PausaGuardian.mqh: ' + $incEsito)
Write-Host ('  copia di sicurezza (.mq5 e .ex5): ' + $zipBk)
Write-Host ''
if($tuttoBene){
  Write-Host '  ADESSO TOCCA A TE, E SOLO A MANO:' -ForegroundColor Yellow
  Write-Host ('   0. fallo con la scheda Trade VUOTA (nessuna posizione ne ordine pendente) e fuori dalle sessioni:') -ForegroundColor Yellow
  Write-Host '      dopo l F7 gli EA ripartono e perdono lo stato in memoria (parziale, break-even).' -ForegroundColor Yellow
  Write-Host ('   1. apri MetaEditor del terminale ' + $CONTO + ' (' + $PROG_ATTESO + ')') -ForegroundColor Yellow
  Write-Host '   2. se hai uno dei tre file gia aperto in una scheda, CHIUDI la scheda senza salvare e riaprilo' -ForegroundColor Yellow
  Write-Host '   3. apri i tre .mq5 e premi F7 su ciascuno (0 errori attesi)' -ForegroundColor Yellow
  Write-Host '   4. in MT5 guarda la data del .ex5 e il Journal: l EA deve ripartire con gli stessi input' -ForegroundColor Yellow
  Write-Host '      (se non riparte da solo: rimuovi e riattacca, poi controlla magic e rischio a vista)' -ForegroundColor Yellow
  Write-Host ''
  Write-Host '  QUESTA RIGA NON HA COMPILATO NIENTE E NON HA TOCCATO NESSUN PROCESSO.' -ForegroundColor Yellow
  Write-Host 'STATO: ESEGUITO_OK'
  exit 0
} else {
  Write-Host '  ALMENO UN FILE NON E ENTRATO. Gli originali sono nello zip qui sopra.' -ForegroundColor Red
  Write-Host 'STATO: ESEGUITO_CON_ERRORI'
  exit 2
}
