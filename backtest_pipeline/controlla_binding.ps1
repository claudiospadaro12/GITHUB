param([string]$File)
$t = Get-Content -Raw -LiteralPath $File
$err=$null; $tok=$null
$ast = [System.Management.Automation.Language.Parser]::ParseInput($t, [ref]$tok, [ref]$err)
$cmds = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.CommandAst] }, $true)
$rotti = 0
foreach($c in $cmds){
  try {
    $b = [System.Management.Automation.Language.StaticParameterBinder]::BindCommand($c)
    if($b.BindingExceptions -and $b.BindingExceptions.Count -gt 0){
      foreach($k in $b.BindingExceptions.Keys){
        $rotti++
        Write-Host ("  BINDING ROTTO: " + $c.GetCommandName() + " -> " + $b.BindingExceptions[$k].BindingException.Message)
      }
    }
  } catch {}
}
Write-Host ("sintassi: " + $err.Count + " errori | comandi: " + $cmds.Count + " | BINDING ROTTI: " + $rotti)
