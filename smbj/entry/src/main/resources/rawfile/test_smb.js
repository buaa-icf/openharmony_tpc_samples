// npm install -S smb2

// load the library
var SMB2 = require('smb2');

// create an SMB2 instance
var smb2Client = new SMB2({
    share: '\\\\192.168.112.1\\f$',
    domain:'DOMAIN',
    username: 'Administrator',
    password: 'ck123321ck',
    autoCloseTimeout:15000
  });

  smb2Client.readFile('smb_test\\test1111.pdf',function(err, data){
    if(err) throw err;
    for(let i=0;i<data.length;i++){
      console.log("SMBJ.PNG:"+ data[i]);
    }
   
  });

//   smb2Client.writeFile('smb_test\\ss.txt', 'appdent Hello Node', function (err,, data) {

//     // if(err) throw err;
//     // console.log('It\'s saved!');
// });
smb2Client.writeFile('smb_test\\test.txt', 'appdent Hello Node','utf8', function (err) {
    if (err) throw err;
    console.log('It\'s saved!');
    
});