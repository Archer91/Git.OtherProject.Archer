<%@ Page Language="C#" AutoEventWireup="true" CodeFile="print.aspx.cs" Inherits="outbound_print" EnableViewState="false" EnableTheming="false" StylesheetTheme="" MaintainScrollPositionOnPostback="false"%>

<html>
<head runat="server">
    <title>发料单</title>
    <style type="text/css"> 
    body,td 
    {
        font-size:10pt;
    }
    #tblPrint
    {
        border-spacing:0px;
        padding:0px;
    }
    #tblHeader
    {
        BORDER-left: black 1px solid;
        BORDER-top: black 1px solid;
        BORDER-right: black 2px solid;
    }
    #tblHeader td
    {
        BORDER-left: black 1px solid; 
        BORDER-top: black 1px solid;
        BORDER-bottom: black 1px solid;
    }    
    #tblDetail
    {
        BORDER-left: black 2px solid;
        BORDER-bottom: black 2px solid;    
        BORDER-right: black 2px solid;
    }
    #tblDetail td
    {
        BORDER-left: black 1px solid; 
        BORDER-top: black 1px solid;
        BORDER-bottom: black 1px solid;
    }    
    </style> 
        
    <style type="text/css" media="print"> 
    body,td 
    {
        font-size:10pt;
    }
    img
    {
        display: none;
    }
    #tblHeader
    {
        BORDER-left: black 2px solid;
        BORDER-top: black 1px solid;
        BORDER-right: black 2px solid;
    }
    #tblDetail
    {
        BORDER-left: black 2px solid;
        BORDER-bottom: black 2px solid;    
        BORDER-right: black 2px solid;
    }
    </style> 

</head>
<body onload="javascript:window.print();">
        <table id="tblPrint" width="680px" cellpadding="0" cellspacing="0">
        <tr><td width="100%">
            <table width="100%">
            <tr><td width="30px"></td>
                <td width="60px">单位名称:</td>
                <td width="100px"><U><asp:Label runat="server" ID="lblOrgan"/></U></td>
                <td width="260px" rowspan="2" align="center" style="font-size:large;"><U><b>发&nbsp;&nbsp;&nbsp;料&nbsp;&nbsp;&nbsp;单</b></U></td>
                <td width="100px" align="center"><U>第<asp:Label runat="server" ID="lblDeliveryID"/>号</U></td>
                <td></td>
            </tr>
            <tr><td width="30px"></td>
                <td width="60px">库&nbsp;&nbsp;&nbsp;&nbsp;位:</td>
                <td width="60px"><U><asp:Label runat="server" ID="lblWareHouse"/></U></td>
                <td width="100px" align="center"><asp:Label runat="server" ID="lblDeliveryDate"/></td>
                <td align="right"></td>
            </tr>
            </table>
        </td></tr>
         <tr><td width="100%">
            <table width="100%" id="tblHeader" cellspacing="0">
            <tr align="center" height="30px"><td width="50px">部门</td>
                <td width="160px"><asp:Label runat="server" ID="lblDepartment"/></td>
                <td width="50px">用途</td>
                <td width="160px"><asp:Label runat="server" ID="lblProject"/></td>
            </tr>
            </table>
        </td></tr>
         <tr><td width="100%">
             <asp:Table ID="tblDetail" runat="server" cellspacing="0">
                <asp:TableRow HorizontalAlign="Center" BackColor="#FFFFFF">
                    <asp:TableCell Width="30px">序号</asp:TableCell>
                    <asp:TableCell Width="100px">物资编号</asp:TableCell>
                    <asp:TableCell Width="120px">物资名称</asp:TableCell>
                    <asp:TableCell Width="120px">规格型号</asp:TableCell>
                    <asp:TableCell Width="80px">计量单位</asp:TableCell>
                    <asp:TableCell Width="80px">单价</asp:TableCell>
                    <asp:TableCell Width="80px">实发数量</asp:TableCell>
                    <asp:TableCell Width="80px">实发金额</asp:TableCell>
                </asp:TableRow>
             </asp:Table>
        </td></tr>        
        <tr><td width="100%">
            <table width="100%">
            <tr><td width="30px"></td>
                <td width="60px">领料人:</td>
                <td width="100px"><asp:Label runat="server" ID="lblReceiver"/></td>
                <td width="60px">操作员:</td>
                <td width="100px"><asp:Label runat="server" ID="lblCurrent"/></td>
                <td width="60px">发料人:</td>
                <td width="100px"><asp:Label runat="server" ID="lblUser"/></td>
                <td width="60px">审核人:</td>
                <td width="100px"><asp:Label runat="server" ID="lblReviewer"/></td>
            </tr>
           </table>
        </td></tr>        
        <tr><td align="center">
            <img style="cursor:hand;" src="../images/print.gif" alt="打印" onclick="javascript:window.print();" />
        </td></tr>
        </table>
</body>
</html>
