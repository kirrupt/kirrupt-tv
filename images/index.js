var http = require('http'),
    httpProxy = require('http-proxy');

var proxy = httpProxy.createProxyServer({});

var server = http.createServer(function(req, res) {
  req.url = '/shows/' + req.url;

  proxy.web(req, res, {
    target: {
      protocol: 'https:',
      host: 'tv.kirrupt.com',
      port: 443
    },
    changeOrigin: true,
    followRedirects: true,
  });
});

server.listen(8080, '0.0.0.0');
