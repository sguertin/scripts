function Start-WebServer {
   [cmdletBinding()]
   param()
   & python -m http.server
}