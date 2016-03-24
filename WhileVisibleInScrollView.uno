using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Triggers;
public class WhileVisibleInScrollView : WhileTrigger
{
	SVPanel svp;

	protected override void OnRooted(Node parentNode)
	{
		base.OnRooted(parentNode);
		if (ParentNode is SVPanel)
		{
			svp = ParentNode as SVPanel;
			svp.ScrolledIntoView += OnScrolledIntoView;
			svp.ScrolledOutOfView += OnScrolledOutOfView;
			if (svp.InView) {
				BypassActivate();
			}
			else {
				BypassDeactivate();
			}
		}
		else
		{
			Diagnostics.Error("Warning: "+this+" only applies to SVPanel. Was attached to: "+ParentNode, this);
		}
	}

	protected override void OnUnrooted(Node parentNode)
	{
		if (svp != null)
		{
			svp.ScrolledIntoView -= OnScrolledIntoView;
			svp.ScrolledOutOfView -= OnScrolledOutOfView;
			svp = null;
		}
		base.OnUnrooted(parentNode);
	}

	public void OnScrolledIntoView(object sender, EventArgs args) {
		Activate();
	}
	public void OnScrolledOutOfView(object sender, EventArgs args) {
		Deactivate();
	}
}
