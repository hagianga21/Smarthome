var express = require('express');
var app = express();
var pug = require('pug');
var fetch = require('node-fetch');
/*
//khai bao cho mongodb
var MongoClient = require('mongodb').MongoClient;
assert = require('assert');
*/
const path = require('path');
app.set('view engine', 'pug')
app.set("views", path.join(__dirname, "views"));

var a = 0;
var obj = {};
obj.thietbi1 = "off";
obj.thietbi2 = "off";
obj.thietbi3 = "off";

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

/*
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
*/

app.get('/', function (req, res) {
    res.render('index', { title: 'Hey', message: 'Hello there!',info: a})
});

app.get('/control', function (req, res) {
    res.render('control', {
        title: 'SMART HOME CONTROL PAGE', 
        thietbi1state: (obj.thietbi1 === "on") ? 'ON' : 'OFF',
        thietbi2state: (obj.thietbi2 === "on") ? 'ON' : 'OFF',
        thietbi3state: (obj.thietbi3 === "on") ? 'ON' : 'OFF',
    })
});


// Post ve trang thai thiet bi 1
app.post('/thietbi1', function (req, res) {
    obj.thietbi1 = (obj.thietbi1 === "on") ? "off" : "on";
    res.redirect('/control');
});
// Post ve trang thai thiet bi 2
app.post('/thietbi2', function (req, res) {
    obj.thietbi2 = (obj.thietbi2 === "on") ? "off" : "on";
    res.redirect('/control');
});

app.post('/thietbi3', function (req, res) {
    obj.thietbi3 = (obj.thietbi3 === "on") ? "off" : "on";
    res.redirect('/control');
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
app.listen(9000)
