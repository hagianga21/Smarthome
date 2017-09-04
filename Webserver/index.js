var express = require('express');
var app = express();
var pug = require('pug');
var exphbs  = require('express-handlebars');
var fetch = require('node-fetch');
var bodyParser = require('body-parser');
/*
//khai bao cho mongodb
var MongoClient = require('mongodb').MongoClient;
assert = require('assert');
*/
const path = require('path');
app.set('view engine', 'handlebars')
app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());

var a = 0;
//Login variables
var username = "giang";
var password = "admin"; 
var loginFlag = false;

var checkChangedFlag = {};
checkChangedFlag.changedFlagStatus = "false";

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

/*
app.get('/', function (req, res) {
    res.render('index', { title: 'Hey', message: 'Hello there!',info: a})
});
*/

app.get('/', function (req, res) {
    res.redirect('/login');
});

app.get('/login', function (req, res) {
    loginFlag = false;
    res.render('login');
});

//LOGIN
app.post('/logincheck', function(req,res){
    if(req.body.username === username  && req.body.password === password){
        console.log("OK");
        loginFlag = true;
        res.redirect('/home');
    }
    else {
        console.log("Fail");
        res.redirect('/');
    }
});

app.get('/logincheckNodeMCU', function(req,res){
    if(req.query.username === username  && req.query.password === password){
        console.log("OK");
        loginFlag = true;
        res.redirect('/home');
    }
    else {
        console.log("Fail");
        res.redirect('/');
    }
});

//HOME
app.get('/home', function (req, res) {
    if(loginFlag === true){
        res.render('home',{
            insideTemperature: 36,
            insideHumidity: 66,
            letterInsideGasdetectionBox : "red",
            letterInsideHumandetectionBox: "green",
            letterInsideSecurityBox: "red",
        });
    }
    else 
        res.redirect('/');
});

//CONTROL
app.get('/control', function (req, res) {
    if(loginFlag === true){
        res.render('control', {
            device1state: (deviceState.device1 === "on") ? 'ON' : 'OFF',
            device2state: (deviceState.device2 === "on") ? 'ON' : 'OFF',
            device3state: (deviceState.device3 === "on") ? 'ON' : 'OFF',
            device1ButtonColor: (deviceState.device1 === "on") ? "green" : "red",
            device2ButtonColor: (deviceState.device2 === "on") ? "green" : "red",
            device3ButtonColor: (deviceState.device3 === "on") ? "green" : "red",
        })
    }
    else 
        res.redirect('/');
});

// Post ve trang thai các thiết bị
app.post('/device1', function (req, res) {
    deviceState.device1 = (deviceState.device1 === "on") ? "off" : "on";
    checkChangedFlag.changedFlagStatus = "true";
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
    deviceState.device2 = req.query.device2;
 });

//Trang Json trạng thái các thiết bị
app.get('/state', function (req, res) {
    res.end(JSON.stringify(deviceState));
});

app.get('/checkChangedFlag', function(req,res){
    if(req.query.device === "NodeMCU"){
        checkChangedFlag.changedFlagStatus = "false";
    }
    res.end(JSON.stringify(checkChangedFlag));
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

app.get('/camera', function (req, res) {
    if(loginFlag === true){
        res.render('camera');
    }
    else
        res.redirect('/');

});

app.get('/chart', function (req, res) {
    if(loginFlag === true){
        res.render('chart');
    }
    else
        res.redirect('/');
});

app.listen(9000)
