& { $ErrorActionPreference='Stop'
  $Sposta=$true
  $NomeArchivio='ARCHIVIO_TEST'; $MinutiFermo=30
  $rx=@('^R[0-9]+[A-Za-z]*[_-]','^STORICO_INDICI_','^ANATOMIA_APERTURE_','^MISURE_LAMPO_','^DIAGNOSI_DAX_','^NOTTE2_','^SONDA[A-Z0-9]*_','^SPREAD_FLOTTA_','^COLLAUDO_FASE1_','^COMPILA_ORB104_','^DUKA_A_','^DUKA_IMPORT_SONDA_','^dukascopy_tick')
  $EstMai=@('.ps1','.py','.exe','.bat','.cmd','.lnk','.url','.msi','.mq5','.mqh','.ex5','.dll','.sys')
  $NomiMai=@('ARCHIVIO_TEST','ARCHIVIO_TEST_ABTG','ABTG_RISULTATI','ABTG_ZIP','ABTG_DOCUMENTI','ABTG_VARIE','ABTG_ORDINE_LOG','desktop.ini')
  $cand=@(); try{ $cand+=[Environment]::GetFolderPath('Desktop') }catch{}
  if($env:USERPROFILE){ $cand+=(Join-Path $env:USERPROFILE 'Desktop'); $cand+=(Join-Path $env:USERPROFILE 'OneDrive\Desktop') }
  $desks=New-Object System.Collections.ArrayList
  foreach($p in $cand){ if(-not $p){ continue }; if(-not (Test-Path -LiteralPath $p)){ continue }; $f=(Get-Item -LiteralPath $p).FullName.TrimEnd('\'); $gia=$false; foreach($q in $desks){ if($q -eq $f){ $gia=$true } }; if(-not $gia){ [void]$desks.Add($f) } }
  $desks=@($desks)
  if($desks.Count -eq 0){ throw 'NESSUN Desktop trovato: non tocco niente.' }
  $dest=Join-Path $desks[0] $NomeArchivio
  if(Test-Path -LiteralPath $dest){ if(-not (Get-Item -LiteralPath $dest).PSIsContainer){ throw ('Sul Desktop esiste gia'' un FILE chiamato ' + $NomeArchivio + ': rinominalo a mano. Non ho toccato niente.') } }
  Write-Host ''
  Write-Host ('=== PULIZIA DESKTOP -- ' + $(if($Sposta){'MODO REALE: SPOSTO'}else{'MODO ELENCO: non tocco niente'}) + ' ===') -ForegroundColor Cyan
  foreach($d in $desks){ Write-Host ('  desktop scandito : ' + $d) }
  Write-Host ('  archivio         : ' + $dest)
  Write-Host ('  criteri (solo primo livello): ' + ($rx -join '   '))
  Write-Host ('  NON si toccano: pagelle, strumenti (.ps1 .exe .lnk ...), roba scritta da meno di ' + $MinutiFermo + ' min, e tutto cio'' che non combacia.')
  Write-Host ''
  $righe=New-Object System.Collections.ArrayList
  $mossi=0; $saltati=0; $fresche=0; $strumenti=0; $pagelle=0; $rinominati=0; $adesso=Get-Date
  foreach($d in $desks){
    foreach($v in @(Get-ChildItem -LiteralPath $d -Force -ErrorAction SilentlyContinue)){
      if($v.Name -like 'pagella_*'){ $pagelle++; continue }
      $no=$false; foreach($n in $NomiMai){ if($v.Name -eq $n){ $no=$true } }
      if($no){ continue }
      if($v.FullName -like ($dest + '*')){ continue }
      $ok=$false; foreach($r in $rx){ if($v.Name -match $r){ $ok=$true; break } }
      if(-not $ok){ continue }
      if(-not $v.PSIsContainer){ $e=$v.Extension.ToLowerInvariant(); $vi=$false; foreach($x in $EstMai){ if($e -eq $x){ $vi=$true } }; if($vi){ Write-Host ('  STRUMENTO lasciato dov''e'' (le righe lo invocano da li''): ' + $v.Name) -ForegroundColor Gray; $strumenti++; continue } }
      $t=$v.LastWriteTime
      if($v.PSIsContainer){ foreach($f in @(Get-ChildItem -LiteralPath $v.FullName -Recurse -Force -ErrorAction SilentlyContinue)){ if($f.LastWriteTime -gt $t){ $t=$f.LastWriteTime } } }
      $eta=(New-TimeSpan -Start $t -End $adesso).TotalMinutes
      if($eta -lt $MinutiFermo){ Write-Host ('  SALTATO, scritto ' + [int]$eta + ' min fa (corsa ancora viva?): ' + $v.Name) -ForegroundColor Yellow; $fresche++; continue }
      $ext=''; $base=$v.Name
      if(-not $v.PSIsContainer){ $ext=$v.Extension; $base=$v.Name.Substring(0,$v.Name.Length-$ext.Length) }
      $target=Join-Path $dest $v.Name; $coll=$false
      if(Test-Path -LiteralPath $target){ $st=(Get-Date).ToString('yyyyMMdd_HHmmss',[System.Globalization.CultureInfo]::InvariantCulture); $k=0; do{ $sfx=''; if($k -gt 0){ $sfx='_'+$k }; $target=Join-Path $dest ($base+'_dup_'+$st+$sfx+$ext); $k++ } while((Test-Path -LiteralPath $target) -and $k -lt 100); $coll=$true }
      if(Test-Path -LiteralPath $target){ Write-Host ('  SALTATO (100 nomi gia'' occupati): ' + $v.Name) -ForegroundColor Yellow; $saltati++; continue }
      if(-not $Sposta){ Write-Host ('  ' + $(if($v.PSIsContainer){'[CART]'}else{'[FILE]'}) + ' ' + $v.Name + $(if($coll){'   -> COLLISIONE: diventerebbe ' + (Split-Path -Leaf $target)}else{''})) -ForegroundColor Cyan; $mossi++; if($coll){ $rinominati++ }; continue }
      try{
        if(-not (Test-Path -LiteralPath $dest)){ New-Item -ItemType Directory -Path $dest | Out-Null }
        Move-Item -LiteralPath $v.FullName -Destination $target -ErrorAction Stop
        if(-not (Test-Path -LiteralPath $target)){ throw 'spostato ma non trovato a destinazione' }
        [void]$righe.Add((New-Object PSObject -Property @{ Origine=$v.FullName; Destinazione=$target }))
        Write-Host ('  spostato: ' + $v.Name + '  ->  ' + (Split-Path -Leaf $target)) -ForegroundColor Green
        $mossi++; if($coll){ $rinominati++ }
      } catch { Write-Host ('  NON spostato (in uso? aperto in un programma?): ' + $v.Name + ' -- ' + $_.Exception.Message) -ForegroundColor Yellow; $saltati++ }
    }
  }
  $log='(niente spostato: nessun log)'
  if($Sposta -and $righe.Count -gt 0){ $ld=Join-Path $dest '_log'; if(-not (Test-Path -LiteralPath $ld)){ New-Item -ItemType Directory -Path $ld | Out-Null }; $log=Join-Path $ld ('archivio_' + (Get-Date).ToString('yyyy-MM-dd_HHmm',[System.Globalization.CultureInfo]::InvariantCulture) + '.csv'); $righe | Select-Object Origine,Destinazione | Export-Csv -LiteralPath $log -NoTypeInformation -Encoding UTF8 }
  Write-Host ''
  if($mossi -eq 0){ Write-Host 'NIENTE DA SPOSTARE: nessun elemento del Desktop combacia coi criteri (o e'' gia'' tutto archiviato).' -ForegroundColor Yellow }
  elseif($Sposta){ Write-Host ('FATTO: ' + $mossi + ' spostati (di cui ' + $rinominati + ' rinominati per collisione), ' + $saltati + ' saltati. NIENTE E'' STATO CANCELLATO.') -ForegroundColor Green }
  else { Write-Host ('VERREBBERO SPOSTATI ' + $mossi + ' elementi (di cui ' + $rinominati + ' in collisione). NESSUNO E'' STATO TOCCATO: questo blocco non modifica niente.') -ForegroundColor Cyan }
  Write-Host ('  lasciati fermi apposta: ' + $pagelle + ' pagelle (recupera_100k.ps1 le cerca sul Desktop), ' + $strumenti + ' strumenti, ' + $fresche + ' scritti da meno di ' + $MinutiFermo + ' min')
  if($Sposta -and $righe.Count -gt 0){ Write-Host ('  log Origine,Destinazione: ' + $log) -ForegroundColor Gray; Write-Host '  per rimettere tutto com''era: archivia_test_desktop.ps1 -Annulla (legge quel CSV), o a mano seguendo le due colonne.' -ForegroundColor Gray }
}
