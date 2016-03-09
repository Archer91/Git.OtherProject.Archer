// JScript File
function KeyDown(){ 
    if (window.event.keyCode == 13) //Enter
    {
        event.returnValue=false;
        event.cancel = true;
        //alert(event.srcElement.type);
        if (event.srcElement.type == 'text' || event.srcElement.type == 'select-one')
        {
            var i, oCurrentElement, txtElement;
            for (i=0;i<document.getElementsByTagName("a").length;i++)
            {
                oCurrentElement = document.getElementsByTagName("a").item(i);
                txtElement=oCurrentElement.innerText;
                if (txtElement == "确认")
                {
                    oCurrentElement.click();
                    return false;
                }
            }
            for (i=0;i<document.getElementsByTagName("input").length;i++)
            {
                oCurrentElement = document.getElementsByTagName("input").item(i);
                txtElement=oCurrentElement.value;
                if (txtElement == "刷新")
                {
                    oCurrentElement.click();
                    return false;
                }
            }
        }
	    return false;
    }
    else if (window.event.keyCode == 27)    //ESC
    {
        event.returnValue=false;
        event.cancel = true;
        if (event.srcElement.type == 'text' || event.srcElement.type == 'select-one')
        {
            var i, oCurrentElement, txtElement;
            for (i=0;i<document.getElementsByTagName("a").length;i++)
            {
                oCurrentElement = document.getElementsByTagName("a").item(i);
                txtElement=oCurrentElement.innerText;
                if (txtElement == "取消")
                {
                    oCurrentElement.click();
                    break;
                }
            }
        }
	    return false;
    }
    else if (window.event.keyCode == 8)    //Back Space
    {
        if (event.srcElement.type != 'text' && event.srcElement.type != 'password')
        {
            event.returnValue=false;
            event.cancel = true;
	        return false;
	    }
    }

}

function dropKeyUp(){ 
    if (window.event.keyCode == 13)
    {
        event.returnValue=false;
        event.cancel = true;

        var i, oCurrentElement, txtElement;
        for (i=0;i<document.getElementsByTagName("a").length;i++)
        {
            oCurrentElement = document.getElementsByTagName("a").item(i);
            txtElement=oCurrentElement.innerText;
            if (txtElement == "查找")
            {
                oCurrentElement.click();
                break;
            }
        }
        //MD，太诡异了，如果没有这一句，那么焦点就跑到IE的菜单栏去，郁闷。
        oCurrentElement.focus();
	    return false;
    }
}

var lastPressTime = 0;
var strLookUp = "";
function catch_press(oSel) { 
	if (event.keyCode < 0x2f)
		return;

    //sel.options[sel.selectedIndex].text = sel.options[sel.selectedIndex].text + String.fromCharCode(event.keyCode); 
    var thisPressTime = new Date().getTime();
    var ln = oSel.options.length;
    
    if ((thisPressTime - lastPressTime)>2000)   //两次按键的间隔小于2秒，或者第一次按键
        strLookUp="";
    strLookUp =  strLookUp + String.fromCharCode(event.keyCode);
    var utext = strLookUp.toUpperCase();
    //document.getElementById("ctl00_contentMain_Label2").innerText = utext;
    for(var i=0;i<ln;i++) {
        var newtxt = oSel.options[i].text;
        var uopt = newtxt.toUpperCase();
        if (uopt != utext && 0 == uopt.indexOf(utext)) {
	        //var txtrange = event.srcElement.createTextRange();
	        //event.srcElement.value = strLookUp + newtxt.substr(strLookUp.length);
	        //var txtrange = document.body.createTextRange();
	        //txtrange.moveToElementText(oSel);
	        //txtrange.moveStart("character", strLookUp.length);
	        //txtrange.select();
	        oSel.selectedIndex = i;
	        break;
        } else if (uopt == utext) {
	        oSel.selectedIndex = i;
        }
    }
    lastPressTime = thisPressTime;
    event.returnValue = false;
 }

function isDate(str)
{
    var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
    if(r==null)return false; 
    var d = new Date(r[1], r[3]-1, r[4]);
    return (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]);
}

function textBoxClick()
{
    var oText = event.srcElement;
    var strText = oText.value;
    
    if(isDate(strText))
    {
        var r = strText.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
	    var txtrange = oText.createTextRange();
        txtrange.findText(r[1]);
        txtrange.select();
    }
    else
        oText.select();
}