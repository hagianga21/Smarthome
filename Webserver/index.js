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
var deviceState = {};
deviceState.device1 = "off";
deviceState.device2 = "off";
deviceState.device3 = "off";

deviceState.device1TimeOn = "";
deviceState.device1TimeOff = "";
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
        device1state: (deviceState.device1 === "on") ? 'ON' : 'OFF',
        device2state: (deviceState.device2 === "on") ? 'ON' : 'OFF',
        device3state: (deviceState.device3 === "on") ? 'ON' : 'OFF',
    })
});



// Post ve trang thai các thiết bị
app.post('/device1', function (req, res) {
    deviceState.device1 = (deviceState.device1 === "on") ? "off" : "on";
    res.redirect('/control');
});
app.post('/device2', function (req, res) {
    deviceState.device2 = (deviceState.device2 === "on") ? "off" : "on";
    res.redirect('/control');
});
app.post('/device3', function (req, res) {
    deviceState.device3 = (deviceState.device3 === "on") ? "off" : "on";
    res.redirect('/control');
});

//Đọc trạng thái về từ hệ thống
app.get('/readStateFromSystem', function (req, res) {
    deviceState.device1 = req.query.device1;
 });

//Trang Json trạng thái các thiết bị
app.get('/state', function (req, res) {
    res.end(JSON.stringify(deviceState));
});

//Trang hẹn giờ
app.get('/setTimeDevice1', function (req, res) {
    res.render('setTimeDevice1')
});

app.get('/submitTheTimeDevice1', function(req,res){
    response = {
      setTimeOn:req.query.setTimeOn,
      setTimeOff:req.query.setTimeOff,
   };
   deviceState.device1TimeOn = response.setTimeOn;
   deviceState.device1TimeOff = response.setTimeOff;
   console.log(response);
   res.redirect('/control');
   //res.end(JSON.stringify(response));
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
