<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>仓储管理系统WMS</title>
    <script type="text/javascript" src="./JScripts/enterKey.js"></script>
<SCRIPT language=JavaScript>
var doImage=doImage;
var TType=TType;

function mhHover(tbl,idx,cls)
{
	var t,d;
	if(document.getElementById)t=document.getElementById(tbl);
	else t=document.all(tbl);
	if(t==null)return;
	if(t.getElementsByTagName)d=t.getElementsByTagName("TD");
	else d=t.all.tags("TD");
	if(d==null)return;
	if(d.length<=idx)return;
	d[idx].className=cls;
}
</SCRIPT>
</head>

<body onkeydown="KeyDown()" oncontextmenu="event.returnValue=false" leftMargin=0 topMargin=0>
<form id="frmMain" runat=server>
    <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
      <TR>
        <td align="left" noWrap style="height: 22px" class="headerbar">
	       <b><font color=#f3c518>仓储</font><font color="#00FF33">管理</font><font color="#00FFCC">系统</font><font color="#CC00CC">W</font><font color="#FF9900">M</font><font color="#00FF33">S</font></b>
        </td>
        <TD id=msviGlobalToolbar dir=ltr noWrap align=right style="height: 22px" class="headerbar">
          <TABLE cellSpacing=0 cellPadding=0 border=0>
            <TBODY>
            <TR>
		      <TD class=gt0 onmouseover="mhHover('msviGlobalToolbar', 0, 'gt1')" 
              onmouseout="mhHover('msviGlobalToolbar', 0, 'gt0')" noWrap style="height: 18px">
                <font color=white>欢迎你，<asp:LoginName ID="LoginName1" runat="server" /></font></TD>	
              <TD class=gtsep style="height: 18px">|</TD>
		      <TD class=gt0 onmouseover="mhHover('msviGlobalToolbar', 2, 'gt1')" 
              onmouseout="mhHover('msviGlobalToolbar', 2, 'gt0')" noWrap style="height: 18px">
		  	    <asp:LoginStatus ID="LoginStatus1" runat="server" LoginText="重新登录" LogoutText="退出系统" LogoutAction="Redirect" LogoutPageUrl="~/Login.aspx"/></TD>
              <TD class=gtsep style="height: 18px">|</TD>
		      <TD class=gt0 onmouseover="mhHover('msviGlobalToolbar', 4, 'gt1')" 
              onmouseout="mhHover('msviGlobalToolbar', 4, 'gt0')" noWrap style="height: 18px">
                <a  href="#" onClick="window.external.addFavorite('http://localhost/WMS', '仓储管理系统')" target="_self">加入收藏夹</a>
              <TD class=gtsep style="height: 18px">|</TD>
		      <TD class=gt0 onmouseover="mhHover('msviGlobalToolbar', 6, 'gt1')" 
              onmouseout="mhHover('msviGlobalToolbar', 6, 'gt0')" noWrap style="height: 18px">
		  	    <asp:HyperLink ID="HyperLink2" NavigateUrl="mailto:jen.xiao@gmail.com" runat="server">联系我们</asp:HyperLink>
		  	</TD>
		  	</TR></TBODY></TABLE>
		</TD>
	   </TR>
	</TABLE>


    <Table ID="tblMain" runat="server" cellSpacing=0 cellPadding=0 border=0 width="100%">
        <tr>
        <td runat=server id="tdMainMenu" Class="mainmenu">
            <div id="mainnav">
                <asp:SiteMapDataSource runat="server" ID="sitemap"/>
                <asp:Menu ID="menuMain" runat="server" DataSourceID="sitemap" SkinID="menuMain" DisappearAfter="200"
                    OnMenuItemDataBound="menuMain_MenuItemDataBound" Target="main">
                </asp:Menu>
            </div>
        </td>
        </tr>
        <tr>
            <td Class="main">
                <iframe id="main" name="main" width=100% height=570px src="welcome.htm"></iframe>
            </td>
        </tr>
    </Table>
</form>
</body>
</html>