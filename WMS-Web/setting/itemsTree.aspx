<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="itemsTree.aspx.cs" Inherits="consume_itemsTree" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
    <script type="text/javascript" src="../JScripts/enterKey.js"></script>    
</head>
<body oncontextmenu="event.returnValue=false" onkeydown="KeyDown()" >
    <form id="form1" runat="server">
    Îï×Ê±àºÅ:<asp:TextBox ID="ItemIDTextBox" runat="server" Width="100px" onkeyup="dropKeyUp()" />
    <asp:LinkButton ID="LinkButtonSearch" runat="server" Text="²éÕÒ" OnClick="LinkButtonSearch_Click">
    </asp:LinkButton>    
    <div>
         <asp:TreeView  
            ID="TreeView1"
            ExpandDepth="0" 
            runat="server" ShowLines=true
            OnTreeNodePopulate="TreeView1_TreeNodePopulate"  >
         </asp:TreeView>
    </div>
    </form>
</body>
</html>
