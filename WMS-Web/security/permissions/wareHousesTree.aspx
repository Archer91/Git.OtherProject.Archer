<%@ Page Language="C#" AutoEventWireup="true" CodeFile="wareHousesTree.aspx.cs" Inherits="Security_permissions_wareHousesTree"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
    <script type="text/javascript">
    function CheckAll()
    {
        var oCurrentElement
        for (i=0;i<document.getElementsByTagName("input").length;i++)
	    {
            oCurrentElement = document.getElementsByTagName("input").item(i);
		    if (oCurrentElement.type=="checkbox" && oCurrentElement != event.srcElement)
			    oCurrentElement.checked = event.srcElement.checked;
	    }
    }
</script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <asp:panel runat="server" id="panel1" scrollbars="auto" height="300px" width="100%">
            <asp:TreeView 
                ID="TreeView1"
                ExpandDepth="0"
                ShowLines="true" 
                runat="server"
                OnTreeNodePopulate="TreeView1_TreeNodePopulate" ShowCheckBoxes="Leaf"  />
        </asp:panel>
        <asp:button text="确定" id="yesButton" runat=server OnClick="yesButton_Click"/>        
    </form>
</body>
</html>
