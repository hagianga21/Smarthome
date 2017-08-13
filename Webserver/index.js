var express = require('express');
var app = express();
var pug = require('pug');
var fetch = require('node-fetch');
var MongoClient = require('mongodb').MongoClient;
assert = require('assert');
const path = require('path');
app.set('view engine', 'pug')
app.set("views", path.join(__dirname, "views"));

var a = 0;
var obj = {};
obj.led1 = "on";
obj.led2 = "on";
//var mongourl = 'mongodb://localhost:27017//video';
/*
// Fetch data
function FetchData(){
    fetch('http://192.168.122.26/mrbs_sourcecode/API/Demo/APIController.php')
        .then(function(res) {
            return res.json();
        }).then(function(json) {
            a = json.API[0].id;
            console.log(a);
        })

}
*/
MongoClient.connect('mongodb://localhost:27017/m101', function(err, db){
    assert.equal(null,err);
    console.log("Successfully connect MongoDB");
    db.collection('hw1_1').find().toArray(function(err,docs){
        docs.forEach(function(doc){
            console.log(doc.answer);
        });
        db.close();
    });
    console.log("Called find");
});
//Neu tat mongodb roi thi mo bang lenh : mongod --dbpath=/data/db

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


/*
app.get('/process_get', function (req, res) {
   response = {
      first_name:req.query.first_name,
   };
   a = req.query.first_name;
   console.log(response);
   res.end(JSON.stringify(response));
});
*/
app.listen(3000)
