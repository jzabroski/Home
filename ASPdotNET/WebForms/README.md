
# Telerik

> By design, ASPxGridview works via internal callbacks. At the same time, while in callback processing, our ASP.NET controls can update only their own rendering, but not the rendering of outside controls or the entire page. Therefore, you cannot use the Response.Write method in the CustomButtonCallback event handler.

# PreRender Is Key

```
public partial class Default7 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Page_PreRender(object sender, EventArgs e)
    {
        EnsureChildControls();
        if (!IsPostBack)
        {
            Session["panelNames"] = pnl1.ClientID;          
            string var4 = Session["panelNames"].ToString();
            Session["panels"] = "ScrollTo('" + var4 + "');";
            ((HtmlControl)(this.Page.FindControl("mainbody"))).Attributes.Add("onload", Session["panels"].ToString());
            string var = ScrollPos.Value;
       }
    }
}
```
