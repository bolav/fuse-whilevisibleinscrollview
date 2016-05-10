using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers;
using Fuse.Elements;
using Fuse.Gestures;
public class WhileVisibleInScrollView : WhileTrigger
{
	ScrollView SVParent;
	Element Parent;

	ScrollDirections _dir = ScrollDirections.All;
	public ScrollDirections Direction {
		get { return _dir; }
		set { _dir = value; }
	}
	bool _ka = false;
	public bool KeepActive {
		get { return _ka; }
		set { _ka = value; }
	}

	ScrollView FindSV (Node n) {
		if (n is Fuse.Controls.ScrollView) {
			var sv = n as Fuse.Controls.ScrollView;
			return sv;
		}
		if (n.Parent == null) {
			return null;
		}
		return FindSV(n.Parent);
	}

	public bool InView = false;

	protected override void OnRooted(Node parentNode)
	{
		base.OnRooted(parentNode);
		if (parentNode is Element) {
			Parent = parentNode as Element;
		}
		else {
			Diagnostics.Error("Warning: "+this+" needs to be attached to an Element. Was attached to: "+ParentNode, this);
			return;
		}

		SVParent = FindSV(parentNode);
		if (SVParent == null) {
			Diagnostics.Error("Warning: "+this+" needs to be inside a ScrollView. Was attached to: "+ParentNode, this);
			return;
		}

		SVParent.ScrollPositionChanged += OnScrollPositionChanged;

		if (CheckInView()) {
			BypassActivate();
			InView = true;
		}
		else {
			BypassDeactivate();
			InView = false;
		}
	}

	protected override void OnUnrooted(Node parentNode)
	{
		if (SVParent != null)
		{
			SVParent.ScrollPositionChanged -= OnScrollPositionChanged;
		}
		SVParent = null;
		Parent = null;
		base.OnUnrooted(parentNode);
	}

	// TODO: Make support for full in view / partial
	public bool CheckInView() {
		if (SVParent.AllowedScrollDirections == Fuse.Gestures.ScrollDirections.Vertical) {
			if ((Parent.ActualPosition.Y <= SVParent.ScrollPosition.Y + SVParent.ActualSize.Y) && (
				 Parent.ActualPosition.Y + Parent.ActualSize.Y >= SVParent.ScrollPosition.Y)) {
				return true;
			}
			else {
				return false;
			}
		}
		return false;
	}

	bool _first = true;
	public void OnScrollPositionChanged(object sender, ScrollPositionChangedArgs args) {
		// This currently only works for vertical scroll
		if (CheckInView()) {
			if (!InView) {
				InView = true;
				Activate();
			}
		}
		else {
			if (InView) {
				if (!KeepActive || _first) {
					InView = false;
					Deactivate();
				}
			}
		}
		_first = false; // Hack, since the size is not fished on OnRooted (all become true)
	}

}
