<%@ Page Language="C#" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html>

<script runat="server">
     string rootPath;
      string relativePathToAutoDeployFolder ;

    void Page_Load()
    {
        rootPath = Server.MapPath("/");
        relativePathToAutoDeployFolder = Request.Url.Host.StartsWith("localhost") ? "../../" : "../"; //for difference between local dev version and staging on server

        var dir = new DirectoryInfo(rootPath + relativePathToAutoDeployFolder);
        var dirs = dir.GetDirectories().Where(s => !s.Name.Equals("lib") && !s.Name.Equals("projects") && !s.Name.Equals("DefaultSite") && !s.Name.Contains("80d-stage.com"));
        ProjectsList.DataSource = dirs;
        ProjectsList.DataBind();
    }
    
    string GetReadMeLink(object  projectFolder) {
        string readmeBtnTemplate = "<li><a href=\"http://projects.80d-stage.com/" + projectFolder+ "/{0}\" target=\"_blank\" class=\"btn btn-default btn-xs\">Read me</a></li>";
        
        string[] files = Directory.GetFiles(rootPath + relativePathToAutoDeployFolder + projectFolder, "readme*", SearchOption.TopDirectoryOnly);
        if (files.Length > 0)
        {
            return String.Format(readmeBtnTemplate,Path.GetFileName(files[0]));
        }
        return "";
    }
    string GetProjectFolders(object  projectFolder) {
        string itemTemplate = " <li><a href=\"http://projects.80d-stage.com/" + projectFolder+ "/{0}\" target=\"_blank\">{0}</a></li>";
        var items = new StringBuilder();
        
        var dir = new DirectoryInfo(rootPath + relativePathToAutoDeployFolder + projectFolder);
        foreach (var d in dir.GetDirectories().Where(s => !s.Name.StartsWith("."))) {
            items.AppendFormat(itemTemplate, d.Name);
        }
        return items.ToString();
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>80 Days Projects</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">

</head>
<body>
     <div class="container">
    <form id="form1" runat="server">
        <h1>Eighty Days Web Site Projects</h1>
        <p class="text-muted">Use for visibility into project status, for testing and to get links that can be shared with client if needed. See <a href="https://docs.google.com/a/endzone.co.uk/document/d/13OvXWzWllLVNcrdhlX4KXRwASt2A_5tRgT5z1r8P2rc/edit#heading=h.wdzz79ecrzf2">the documentation</a> for details.</p>
    <table class="table" style="width: auto; min-width: 400px;">
        <asp:Repeater ID="ProjectsList" runat="server">
            <ItemTemplate>
            <tr>
                <th colspan="2"><%#Eval("Name")%></th>
            </tr>
            <tr>
                <td>
                    Project Folders:
                    <br /> <span class="text-muted ">(auto deployed from Beanstalk)</span>
                    <ul> 
                       <%#  GetReadMeLink(Eval("Name"))  %>
                        
                       <%#  GetProjectFolders(Eval("Name"))  %>
                    </ul>
                </td>
                <td>
                    Other Links:
                    <ul>
                        <li><a href="http://<%#Eval("Name")%>.80d-stage.com/" target="_blank">Staging Site</a> <a href="http://<%#Eval("Name")%>.staging/" title="Add to your hosts file to use this link" target="_blank">(alt)</a></li>
                        <li><a href="https://eighty-days.beanstalkapp.com/<%#Eval("Name")%>/browse/tags" target="_blank">SVN Tags</a></li>
                    </ul>
                </td>
            </tr>
            </ItemTemplate>
        </asp:Repeater>
    </table>
    </form>
         </div>
</body>
</html>
