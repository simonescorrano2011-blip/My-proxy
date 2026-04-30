const http = require('http');
const httpProxy = require('http-proxy');

// Crea il server proxy
const proxy = httpProxy.createProxyServer({});

// Porta dinamica per Fly.io (usa la porta assegnata o la 8080 come backup)
const PORT = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  // Log delle richieste (utile per vedere se il proxy sta ricevendo traffico)
  console.log(`Richiesta ricevuta per: ${req.url}`);

  // Logica base: in un proxy reale qui andrebbe la decodifica dell'URL.
  // Questo esempio reindirizza a Google come test se non specifichi nulla.
  const target = req.headers['x-target-url'] || 'https://www.google.com';

  proxy.web(req, res, {
    target: target,
    changeOrigin: true,
  }, (err) => {
    res.writeHead(500, { 'Content-Type': 'text/plain' });
    res.end('Errore del Proxy: ' + err.message);
  });
});

// Fondamentale: ascoltare su 0.0.0.0 per Fly.io
server.listen(PORT, '0.0.0.0', () => {
  console.log(`EasyProxy attivo sulla porta ${PORT}`);
});
