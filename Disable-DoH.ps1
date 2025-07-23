# Disable DoH in Chrome (via registry policy)
$chromePolicyPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
New-Item -Path $chromePolicyPath -Force | Out-Null
New-ItemProperty -Path $chromePolicyPath -Name "DnsOverHttpsMode" -Value "off" -PropertyType String -Force
Remove-ItemProperty -Path $chromePolicyPath -Name "DnsOverHttpsTemplates" -ErrorAction SilentlyContinue

# Disable DoH in Edge (via registry policy)
$edgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
New-Item -Path $edgePolicyPath -Force | Out-Null
New-ItemProperty -Path $edgePolicyPath -Name "DnsOverHttpsMode" -Value "off" -PropertyType String -Force
Remove-ItemProperty -Path $edgePolicyPath -Name "DnsOverHttpsTemplates" -ErrorAction SilentlyContinue

# Disable DoH in Firefox via policies.json
$firefoxPolicyPath = "$env:ProgramFiles\Mozilla Firefox\distribution"
if (-Not (Test-Path $firefoxPolicyPath)) {
    New-Item -Path $firefoxPolicyPath -ItemType Directory -Force | Out-Null
}
$firefoxPolicyFile = Join-Path $firefoxPolicyPath "policies.json"

$firefoxPolicyJson = @"
{
  "policies": {
    "DNSOverHTTPS": {
      "Enabled": false
    }
  }
}
"@
$firefoxPolicyJson | Set-Content -Path $firefoxPolicyFile -Encoding UTF8

# Disable DoH in Opera (remove flags from shortcut)
$operaShortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Opera.lnk"
if (Test-Path $operaShortcutPath) {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($operaShortcutPath)
    $args = $shortcut.Arguments
    $args = $args -replace "--enable-features=DnsOverHttps", ""
    $args = $args -replace "--dns-over-https-templates=[^\s]*", ""
    $shortcut.Arguments = $args.Trim()
    $shortcut.Save()
}

# Optional: Write to Event Log for confirmation
if (-not (Get-EventLog -LogName Application -Source "Disable-DoH-GPO" -ErrorAction SilentlyContinue)) {
    New-EventLog -LogName Application -Source "Disable-DoH-GPO" -ErrorAction SilentlyContinue
}
Write-EventLog -LogName Application -Source "Disable-DoH-GPO" -EntryType Information -EventId 1001 -Message "DoH disabled via GPO script on $(hostname) at $(Get-Date)"

Write-Output "[Done] DoH disabled in Chrome, Edge, Firefox, and Opera."
