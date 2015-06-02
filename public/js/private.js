function hide(x)
{
    if (x.checked)
    {
        document.getElementById("language").style.visibility="visible";
        document.getElementById("game").style.visibility="visible";
    }
}

function show(x)
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
        document.getElementById("reportname").style.display="none";
        document.getElementById("reportdescription").style.display="none";
        document.getElementById("submit").style.display="none";
        visible = false
    } else {
        document.getElementById("reportname").style.display="block";
        document.getElementById("reportdescription").style.display="block";
        document.getElementById("submit").style.display="block";
        visible = true
    }
console.log(visible)

};
