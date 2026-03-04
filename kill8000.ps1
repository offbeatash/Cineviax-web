$conn = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
if ($conn) {
    $p = $conn.OwningProcess
    Write-Host "Killing process $p on port 8000"
    Stop-Process -Id $p -Force
} else {
    Write-Host "No process on port 8000"
}