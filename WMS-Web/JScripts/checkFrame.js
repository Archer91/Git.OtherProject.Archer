// JScript File

if( self == top && location != "/WMS/default.aspx")
{
    window.location.href="/WMS/default.aspx";
}

//处理GridView的Hover
var origColor;
function HandleOver( row )
{
    origColor = row.style.backgroundColor;
    row.style.backgroundColor = "#D9E8F6";
}

function HandleOut( row )
{
    row.style.backgroundColor = origColor;
}