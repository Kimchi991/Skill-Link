# Remaining Fixes (Skip Freelancers Deploy for Now)

## 1. Service Card Click → Home Redirect (Modal Fail)
**Plan:**
- Home.aspx.cs: rptServices_ItemDataBound safe nulls
```
protected void rptServices_ItemDataBound(object sender, RepeaterItemEventArgs e)
{
    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
    {
        var desc = DataBinder.Eval(e.Item.DataItem, "Description") ?? "";
        // Pass safe desc to JS via Attributes or hidden
    }
}
```
- Home.aspx JS openModal try-catch

## 2. Services Initial Load Delay
**Plan:** Page_Load always LoadServices("Programming")

## 3. Deploy Script
**VS GUI:** Right-click → Publish

Confirm priority?

