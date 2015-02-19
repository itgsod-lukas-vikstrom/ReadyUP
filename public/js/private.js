function hideA(x)
{
    if (x.checked)
    {
        document.getElementById("language").style.visibility="visible";
        document.getElementById("game").style.visibility="visible";
    }
}

function hideB(x)
{
    if (x.checked)
    {
        document.getElementById("language").style.visibility="hidden";
        document.getElementById("game").style.visibility="hidden";
        // document.getElementById("password").style.visibility="visible";
    }
}
var visible = false
function hidereport() {
    if(visible){
        document.getElementById("reportname").style.visibility="hidden";
        document.getElementById("reportdescription").style.visibility="hidden";
        visible = false
    } else {
        document.getElementById("reportname").style.visibility="visible";
        document.getElementById("reportdescription").style.visibility="visible";
        visible = true
    }
console.log(visible)

};