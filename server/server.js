var jsonServer = require('json-server');
var router = jsonServer.router('db.json');

var	server	=	jsonServer.create();
server.use(jsonServer.defaults());


server.use(router);
console.log('Listening	at	4000');
server.listen(4000);
