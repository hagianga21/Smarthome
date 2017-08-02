var express = require('express');
var app = express();
var pug = require('pug');
var fetch = require('node-fetch');
const path = require('path');

app.set('view engine', 'pug')
app.set("views", path.join(__dirname, "views"));

var a = 0;
var obj = {};
obj.led1 = "on";
obj.led2 = "on";

function FetchData(){
    fetch('http://192.168.122.26/mrbs_sourcecode/API/Demo/APIController.php')
        .then(function(res) {
            return res.json();
        }).then(function(json) {
            a = json.API[0].id;
            console.log(a);
        })

}



app.get('/', function (req, res) {
    res.render('index', { title: 'Hey', message: 'Hello there!',info: a})
});

app.get('/control', function (req, res) {
    res.render('control', {title: 'Control'})
});


// Post ve trang thai den 1
app.post('/led1', function (req, res) {
    obj.led1 = (obj.led1 === "on") ? "off" : "on";
    res.redirect('/state');
});
// Post ve trang thai den 2
app.post('/led2', function (req, res) {
    obj.led2 = (obj.led2 === "on") ? "off" : "on";
    res.redirect('/state');
});

app.get('/state', function (req, res) {
    res.end(JSON.stringify(obj));
});

app.get('/process_get', function (req, res) {
   response = {
      first_name:req.query.first_name,
   };
   a = req.query.first_name;
   console.log(response);
   res.end(JSON.stringify(response));
});

app.listen(3000)
