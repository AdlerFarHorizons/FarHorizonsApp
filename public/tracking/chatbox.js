lastReceived=0;

function initialChatLogStatus(){
    logInArea.style.display="none";
    chatArea.style.display="none";

    // is there a cookie with a login name?
    logID=$.cookies.get('loginID');
    if (logID) { // if yes, then ask the server if the id still exists
       Ajax_Send("POST","users.php","user="+logID+"&oper=checkID",checkInitialSignIn);
    }
    else { // if not, then show the login area
	logInArea.style.display="block";
    }
}

function checkInitialSignIn(res) {
    // if the logID from the cookie is also on the server then we can make 
    // the chat window visible, else make the 



}

// Hide the message form
function hideShow(hs){
if(hs=="hide"){
signInForm.signInButt.value="Sign in"
signInForm.signInButt.name="signIn"
messageForm.style.display="none"
signInForm.userName.style.display="block"
signInName.innerHTML=""
}
if(hs=="show"){
signInForm.signInButt.value="Sign out"
signInForm.signInButt.name="signOut"
messageForm.style.display="block"
signInForm.userName.style.display="none"
signInName.innerHTML=signInForm.userName.value 
}
}


// Sign in and Out
function signInOut(){
if (signInForm.userName.value=="" || signInForm.userName.value.indexOf(" ")>-1){
alert("Not valid user name\nPlease make sure your user name didn't contains a space\nOr it's not empty.");
signInForm.userName.focus();
return false;
}

// Sign in
if (signInForm.signInButt.name=="signIn"){
data="user=" + signInForm.userName.value +"&oper=signin"
Ajax_Send("POST","users.php",data,checkSignIn);
return false
}

// Sign out
if (signInForm.signInButt.name=="signOut"){
data="user=" + signInForm.userName.value +"&oper=signout"
Ajax_Send("POST","users.php",data,checkSignOut);
return false
}
}

// Sign in response
function checkSignIn(res){
if(res=="userexist"){
alert("The user name you typed is already exist\nPlease try another one");
return false;
}
if(res=="signin"){
hideShow("show")

messageForm.message.focus()
updateInterval=setInterval("updateInfo()",3000);
//serverRes.innerHTML="Sign in"
}
}

// Sign out response
function checkSignOut(res){
if(res=="usernotfound"){
    //serverRes.innerHTML="Sign out error";
res="signout"
}
if(res=="signout"){
hideShow("hide")
signInForm.userName.focus()
clearInterval(updateInterval)
    //serverRes.innerHTML="Sign out"
return false
}
}

// Update info
function updateInfo(){
    //serverRes.innerHTML="Updating"
Ajax_Send("POST","users.php","",showUsers)
Ajax_Send("POST","receive.php","lastreceived="+lastReceived,showMessages)
}

// update online users
function showUsers(res){
    //usersOnLine.innerHTML=res
}

// Update messages view
function showMessages(res){
    //serverRes.innerHTML=""
msgTmArr=res.split("<SRVTM>")
lastReceived=msgTmArr[1]
messages=document.createElement("span")
messages.innerHTML=msgTmArr[0]
chatBox.appendChild(messages)
chatBox.scrollTop=chatBox.scrollHeight
}

// Send message
function sendMessage(){
data="message="+messageForm.message.value+"&user="+signInForm.userName.value
    //serverRes.innerHTML="Sending"
Ajax_Send("POST","send.php",data,sentOk)
}

// Sent Ok
function sentOk(res){
if(res=="sentok"){
messageForm.message.value=""
messageForm.message.focus()
    //serverRes.innerHTML="Sent"
}
else{
    //serverRes.innerHTML="Not sent"
}
}

// if you don't have a chat id in a cookie on pageload then set up with a 
// login box. If you have a chat id, then verify it (in case it is stale). 
// If it is fresh then use that one. Otherwise erase cookie and set up with 
//a login box. 