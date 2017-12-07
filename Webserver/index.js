var express = require('express');
var app = express();
var pug = require('pug');
var exphbs  = require('express-handlebars');
var fetch = require('node-fetch');
var bodyParser = require('body-parser');

//khai bao cho mongodb
var MongoClient = require('mongodb').MongoClient;
assert = require('assert');

const path = require('path');
app.set('view engine', 'handlebars')
app.engine('handlebars', exphbs({defaultLayout: 'main'}));
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.urlencoded({
    extended: true
}));
app.use(bodyParser.json());


var temperature = 30;
var humid = 30;
var gasDetection = "NO";
var humanDetection = "NO";
var securityStatus = "UNARMED";
var Power = 0;

var d1 = new Date();
dateNow =  d1.getDate();
monthNow = d1.getMonth() + 1;
yearNow =  d1.getFullYear();
var dateFilter = dateNow;
var monthFilter = monthNow;
var yearFilter = yearNow;

var chartTime = [];
var chartPower = [];
var chartCount = 0;
//var chartTime2 = ["1:00","3:30","4:15","6:15","7:15","8:15"];

//https://stackoverflow.com/questions/7357734/how-do-i-get-the-time-of-day-in-javascript-node-js
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
deviceState.device4 = "off";

deviceState.device1TimeOn = "00:00";
deviceState.device1TimeOff = "00:00";
deviceState.device2TimeOn = "00:00";
deviceState.device2TimeOff = "00:00";
deviceState.device3TimeOn = "00:00";
deviceState.device3TimeOff = "00:00";
deviceState.device4TimeOn = "00:00";
deviceState.device4TimeOff = "00:00";

var scenes = {};
scenes.iAmHome = "off";
scenes.goodmorning = "off";
scenes.goodnight = "off";
scenes.security = "off";
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


MongoClient.connect('mongodb://localhost:27017/LVTNtest', function(err, db){
    assert.equal(null,err);
    console.log("Successfully connect MongoDB");
    var projection = {"date" :1, "year" :1,"month" :1, "time" :1, "P":1, "_id":0}; //"deviceID": 1, 
    //db.collection('test2').insertOne({"deviceID": "D04", "date": d.getDate(), "month": d.getMonth(), "year": d.getFullYear(), "time": d.getHours() + "." + d.getMinutes(), "P": req.query.Power})
    var d = new Date();
    var cursor = db.collection('test2').find({time: {$gt: '1.20'},date: {$eq: d.getDate()},month: {$eq: d.getMonth()+1},year: {$eq: d.getFullYear()}})
    cursor.project(projection)
    cursor.forEach(
        function(doc) {
            chartTime[chartCount] = doc.time;
            chartPower[chartCount] = doc.P;
            chartCount++;
            console.log(doc.year);
        },
        function(err) {
            assert.equal(err, null);
            return db.close();
        }
    );   
});

//Neu tat mongodb roi thi mo bang lenh : mongod --dbpath=/data/db


/*
app.get('/', function (req, res) {
    res.render('index', { title: 'Hey', message: 'Hello there!',info: a})
});
*/

app.get('/', function (req, res) {
    //console.log(chartTime);
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
        MongoClient.connect('mongodb://localhost:27017/LVTNtest', function(err, db){
            chartCount = 0;
            chartTime = [];
            chartPower = [];
            assert.equal(null,err);
            var projection = {"date" :1, "year" :1,"month" :1, "time" :1, "P":1, "_id":0};
            var d = new Date();
            var cursor = db.collection('test2').find({time: {$gt: '1.20'},date: {$eq: d.getDate()},month: {$eq: d.getMonth()+1},year: {$eq: d.getFullYear()}})
            cursor.project(projection)
            cursor.forEach(
                function(doc) {
                    chartTime[chartCount] = doc.time;
                    chartPower[chartCount] = doc.P;
                    chartCount++;
                    console.log(doc.year);
                },
                function(err) {
                    assert.equal(err, null);
                    return db.close();
                }
            ); 
        })
        res.render('home',{
            chartTime: chartTime,
            chartPower: chartPower,
            insideTemperature: temperature,
            insideHumidity: humid,
            gasDetection: gasDetection,
            humanDetection: humanDetection,
            securityStatus: securityStatus,

            letterInsideGasdetectionBox : (gasDetection === "YES") ? "red": "green",
            letterInsideHumandetectionBox: (humanDetection === "YES") ? "red": "green",
            letterInsideSecurityBox: (securityStatus === "ARMED") ? "red": "green",
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
            device4state: (deviceState.device4 === "on") ? 'ON' : 'OFF',

            device1ButtonColor: (deviceState.device1 === "on") ? "green" : "red",
            device2ButtonColor: (deviceState.device2 === "on") ? "green" : "red",
            device3ButtonColor: (deviceState.device3 === "on") ? "green" : "red",
            device4ButtonColor: (deviceState.device4 === "on") ? "green" : "red",
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
    checkChangedFlag.changedFlagStatus = "true";
    res.redirect('/control');
});
app.post('/device3', function (req, res) {
    deviceState.device3 = (deviceState.device3 === "on") ? "off" : "on";
    checkChangedFlag.changedFlagStatus = "true";
    res.redirect('/control');
});
app.post('/device4', function (req, res) {
    deviceState.device4 = (deviceState.device4 === "on") ? "off" : "on";
    checkChangedFlag.changedFlagStatus = "true";
    res.redirect('/control');
});

//Đọc trạng thái về từ hệ thống
app.get('/readStateFromSystem', function (req, res) {
    if(req.query.device1)
        deviceState.device1 = req.query.device1;
    if(req.query.device2)
        deviceState.device2 = req.query.device2;
    if(req.query.device3)
        deviceState.device3 = req.query.device3;
    if(req.query.device4)
        deviceState.device4 = req.query.device4;
});

//Đọc nhiệt độ từ hệ thống 
app.get('/readTempFromSystem', function (req, res) {
    temperature = req.query.temperature;
});
app.get('/readHumidFromSystem', function (req, res) {
    humid = req.query.humid;
});
app.get('/readGasFromSystem', function (req, res) {
    gasDetection = req.query.gasDetection;
});
app.get('/readHumanFromSystem', function (req, res) {
    humanDetection = req.query.humanDetection;
});
app.get('/readPowerFromSystem', function (req, res) {
    var d = new Date();
    Power = req.query.Power;
    MongoClient.connect('mongodb://localhost:27017/LVTNtest', function(err, db){
        assert.equal(null,err);
        db.collection('test2').insertOne({"deviceID": "D04", "date": d.getDate(), "month": d.getMonth()+1, "year": d.getFullYear(), "time": d.getHours() + "." + d.getMinutes(), "P": req.query.Power})
    });
});

app.get('/Power', function (req, res) {
    res.end(JSON.stringify(Power));
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
app.get('/submitTheTimeDevice1', function(req,res){
   deviceState.device1TimeOn = req.query.setTimeOn;
   deviceState.device1TimeOff = req.query.setTimeOff;
   checkChangedFlag.changedFlagStatus = "true";
   res.redirect('/control');
});
app.get('/submitTheTimeDevice2', function(req,res){
    deviceState.device2TimeOn = req.query.setTimeOn;
    deviceState.device2TimeOff = req.query.setTimeOff;
    checkChangedFlag.changedFlagStatus = "true";
    res.redirect('/control');
});
app.get('/submitTheTimeDevice3', function(req,res){
    deviceState.device3TimeOn = req.query.setTimeOn;
    deviceState.device3TimeOff = req.query.setTimeOff;
    checkChangedFlag.changedFlagStatus = "true";
    res.redirect('/control');
});
app.get('/submitTheTimeDevice4', function(req,res){
    deviceState.device4TimeOn = req.query.setTimeOn;
    deviceState.device4TimeOff = req.query.setTimeOff;
    checkChangedFlag.changedFlagStatus = "true";
    res.redirect('/control');
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


//SCENES
app.get('/scenesjson', function (req, res) {
    res.end(JSON.stringify(scenes));
});

app.get('/scenes', function (req, res) {
    if(loginFlag === true){
        res.render('scenes', {
            goodmorningColor: (scenes.goodmorning === "on") ? "green" : "black",
            iAmHomeColor: (scenes.iAmHome === "on") ? "green" : "black",
            goodnightColor: (scenes.goodnight === "on") ? "green" : "black",
            securityColor: (scenes.security === "on") ? "green" : "black",
        })
    }
    else 
        res.redirect('/');
});
//Gui scenes
app.post('/goodmorning', function (req, res) {
    scenes.goodmorning = (scenes.goodmorning === "on") ? "off" : "on";
    scenes.iAmHome = "off";
    scenes.goodnight = "off";
    scenes.security = "off";
    res.redirect('/scenes');
});
app.post('/iamhome', function (req, res) {
    scenes.iAmHome = (scenes.iAmHome === "on") ? "off" : "on";
    scenes.goodmorning = "off";
    scenes.goodnight = "off";
    scenes.security = "off";
    res.redirect('/scenes');
});
app.post('/goodnight', function (req, res) {
    scenes.goodnight = (scenes.goodnight === "on") ? "off" : "on";
    scenes.goodmorning = "off";
    scenes.iAmHome = "off";
    scenes.security = "off";
    res.redirect('/scenes');
});
app.post('/security', function (req, res) {
    scenes.security = (scenes.security === "on") ? "off" : "on";
    scenes.goodmorning = "off";
    scenes.iAmHome = "off";
    scenes.goodnight = "off";
    res.redirect('/scenes');
});



app.get('/camera', function (req, res) {
    if(loginFlag === true){
        res.render('camera');
    }
    else
        res.redirect('/');

});

app.get('/chart', function (req, res) {
    if(loginFlag === true){
        MongoClient.connect('mongodb://localhost:27017/LVTNtest', function(err, db){
            assert.equal(null,err);
            chartCount = 0;
            chartTime = [];
            chartPower = [];
            var projection = {"date" :1, "year" :1,"month" :1, "time" :1, "P":1, "_id":0};
            var d = new Date();
            var cursor = db.collection('test2').find({date: {$eq: dateFilter},month: {$eq: monthFilter},year: {$eq: yearFilter}  })
            cursor.project(projection)
            cursor.forEach(
                function(doc) {
                    chartTime[chartCount] = doc.time;
                    chartPower[chartCount] = doc.P;
                    chartCount++;
                    console.log(doc.year);
                },
                function(err) {
                    assert.equal(err, null);
                    return db.close();
                }
            ); 
        })
        res.render('chart',{
            date: dateFilter,
            month: monthFilter,
            year: yearFilter,
            chartTime: chartTime,
            chartPower: chartPower
        });
    }
    else
        res.redirect('/');
});

app.get('/filterPower', function (req, res) {
    var a = req.query.chartChooseMonth + " " + req.query.chartChooseDate + " " + req.query.chartChooseYear;
    var b = new Date(a);
    dateFilter = b.getDate();
    monthFilter = b.getMonth()+1;
    yearFilter = b.getFullYear();
    res.redirect('/chart');
});


app.listen(9000)
