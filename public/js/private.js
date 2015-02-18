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