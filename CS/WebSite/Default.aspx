<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v13.1, Version=13.1.14.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>How to show a context menu for the ASPxTreeView control and handle user actions for different nodes</title>

    <script type="text/javascript">
        function treeView_OnInit (s, e) {
           ProcessNode (s.GetRootNode());
        }
        
        function ProcessNode(node) {
            var htmlElement = node.GetHtmlElement();            
            var count = node.GetNodeCount();
            
            if (htmlElement != null) {
                var handler = function (evt) {
                    popupMenu_ToggleItemsVisibility (count > 0);
                    
                    popupMenu.cpClickedNode = node;
                    popupMenu.ShowAtElement(node.GetHtmlElement());
                    
                    ASPxClientUtils.PreventEventAndBubble(evt);
                };
                ASPxClientUtils.AttachEventToElement (htmlElement, "contextmenu", handler);
            }
                        
            for (var i = 0; i < count; i++) 
                ProcessNode (node.GetNode(i));
        }

        function popupMenu_ToggleItemsVisibility(isParent) {
            popupMenu.GetItemByName("itmExpandCollapse").SetVisible(isParent);
            popupMenu.GetItemByName("itmEnableDisable").SetVisible(!isParent);
        }
        
        function popupMenu_OnPopUp(s, e) {
            s.GetItemByName("itmExpandCollapse").SetText(s.cpClickedNode.GetExpanded() ? "Collapse" : "Expand");
            s.GetItemByName("itmEnableDisable").SetText(s.cpClickedNode.GetEnabled() ? "Disable" : "Enable");
        }
        
        function popupMenu_OnItemClick(s, e) {
            if (e.item.name == "itmExpandCollapse")
                s.cpClickedNode.SetExpanded(!s.cpClickedNode.GetExpanded());
            
            if (e.item.name == "itmEnableDisable")
                s.cpClickedNode.SetEnabled(!s.cpClickedNode.GetEnabled());
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div>
            <dx:ASPxTreeView ID="treeView" ClientInstanceName="treeView" runat="server" Width="100px">
                <Nodes>
                    <dx:TreeViewNode Text="Parent 1">
                        <Nodes>
                            <dx:TreeViewNode Text="Child 1-1">
                            </dx:TreeViewNode>
                            <dx:TreeViewNode Text="Child 1-2">
                            </dx:TreeViewNode>
                        </Nodes>
                    </dx:TreeViewNode>
                    <dx:TreeViewNode Text="Parent 2">
                        <Nodes>
                            <dx:TreeViewNode Text="Child 2-1">
                            </dx:TreeViewNode>
                            <dx:TreeViewNode Text="Child 2-2">
                            </dx:TreeViewNode>
                        </Nodes>
                    </dx:TreeViewNode>
                </Nodes>
                <ClientSideEvents Init="treeView_OnInit" />
            </dx:ASPxTreeView>
            <dx:ASPxPopupMenu ID="popupMenu" ClientInstanceName="popupMenu" runat="server">
                <Items>
                    <dx:MenuItem Name="itmExpandCollapse" Text="Expand">
                    </dx:MenuItem>
                    <dx:MenuItem Name="itmEnableDisable" Text="Enable">
                    </dx:MenuItem>
                </Items>
                <ClientSideEvents PopUp="popupMenu_OnPopUp" ItemClick="popupMenu_OnItemClick" />
            </dx:ASPxPopupMenu>
        </div>
    </form>
</body>
</html>
