$Dec=@{}
function Valore($id,$difetto){ if($Dec.ContainsKey($id)){ return $Dec[$id].Valore }; return $difetto }
function FinestraSimbolo([string]$bcm, [int]$daGlob, [int]$aGlob){
  $spec = (Valore "D-H" "")
  if([string]::IsNullOrWhiteSpace($spec)){ return @($daGlob, $aGlob, "D-D (nessuna D-H)") }
  foreach($pezzo in ($spec -split ";")){
    $p = $pezzo.Trim()
    if($p -eq ""){ continue }
    $kv = $p -split ":"
    if($kv.Count -ne 2){ continue }
    if($kv[0].Trim().ToUpper() -ne $bcm.ToUpper()){ continue }
    $m = [regex]::Match($kv[1].Trim(),'^(\d{4})-(\d{4})$')
    if(-not $m.Success){ continue }
    $d = [int]$m.Groups[1].Value; $a = [int]$m.Groups[2].Value
    if($a -lt $d){ continue }
    # LA D-H PUO' SOLO STRINGERE, MAI ALLARGARE: un simbolo non puo'
    # ottenere da qui anni che la D-D non ha gia' autorizzato.
    if($d -lt $daGlob){ $d = $daGlob }
    if($a -gt $aGlob){ $a = $aGlob }
    return @($d, $a, ("D-H " + $bcm))
  }
  return @($daGlob, $aGlob, "D-D (non nominato in D-H)")
}
function Prova($titolo,$dh,$sym,$attDa,$attA){
  if($null -eq $dh){ $script:Dec=@{} } else { $script:Dec=@{ "D-H" = @{ Valore=$dh; Stato="FIRMATO" } } }
  $r = FinestraSimbolo $sym 2010 2026
  $ok = ([int]$r[0] -eq $attDa -and [int]$r[1] -eq $attA)
  $esito = if($ok){"OK  "}else{"FAIL"}
  Write-Host ("  " + $esito + "  " + $titolo.PadRight(46) + " -> " + $r[0] + "-" + $r[1] + "  [" + $r[2] + "]")
  if(-not $ok){ $script:falliti++ }
}
$falliti=0
Write-Host "=== BANCO D-H (globale = 2010-2026) ==="
Prova "nessuna D-H: eredita la globale"            $null                      "D30EUR" 2010 2026
Prova "D-H vuota: eredita la globale"              ""                         "D30EUR" 2010 2026
Prova "DAX nominato: STRINGE a 2010-2018"          "D30EUR:2010-2018"         "D30EUR" 2010 2018
Prova "NASUSD non nominato: resta globale"         "D30EUR:2010-2018"         "NASUSD" 2010 2026
Prova "due simboli, prende il suo"                 "D30EUR:2010-2018;NASUSD:2012-2020" "NASUSD" 2012 2020
Prova "minuscolo/spazi: riconosce lo stesso"       " d30eur : 2010-2018 "     "D30EUR" 2010 2018
Prova "tenta di ALLARGARE: viene tagliato"         "D30EUR:2005-2030"         "D30EUR" 2010 2026
Prova "formato rotto: eredita la globale"          "D30EUR:duemiladieci"      "D30EUR" 2010 2026
Prova "rovesciata (a<da): eredita la globale"      "D30EUR:2018-2010"         "D30EUR" 2010 2026
Prova "simbolo non in lista: globale"              "D30EUR:2010-2018"         "U30USD" 2010 2026
Write-Host ""
if($falliti -gt 0){ Write-Host ("BANCO FALLITO: " + $falliti + " casi") -ForegroundColor Red; exit 1 }
Write-Host "BANCO: 10 casi su 10 PASSATI" -ForegroundColor Green
