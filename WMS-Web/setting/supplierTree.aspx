<%@ Page Language="C#" AutoEventWireup="true" CodeFile="supplierTree.aspx.cs" Inherits="setting_supplierTree" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <div>
             <asp:TreeView  
                    ID="TreeView1"
                    ExpandDepth="0" 
                    ShowLines="true" 
                    runat="server"
                    OnTreeNodePopulate="TreeView1_TreeNodePopulate"  />
        </div>
    </form>
</body>
</html>
