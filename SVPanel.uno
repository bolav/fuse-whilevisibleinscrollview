using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Controls;

public class SVPanel : Panel
{
	ScrollView FindSV (Node n) {
		if (n is Fuse.Controls.ScrollView) {
			var sv = n as Fuse.Controls.ScrollView;
			return sv;
		}
		return FindSV(n.Parent);
	}

	ScrollView SVParent;
	protected override void OnRooted()
	{
		SVParent = FindSV(Parent);
		SVParent.ScrollPositionChanged += OnScrollPositionChanged;
		// Check if we are in view now

		// Famous copy-paste pattern:
		if (SVParent.AllowedScrollDirections == Fuse.Gestures.ScrollDirections.Vertical) {
			if ((ActualPosition.Y <= SVParent.ScrollPosition.Y + SVParent.ActualSize.Y) && (
				 ActualPosition.Y + ActualSize.Y >= SVParent.ScrollPosition.Y)) {
				if (!InView) {
					InView = true;
				}
			}
			else {
				if (InView) {
					InView = false;
				}
			}
		}
		base.OnRooted();
	}

	protected override void OnUnrooted()
	{
		SVParent.ScrollPositionChanged -= OnScrollPositionChanged;
		SVParent = null;
		base.OnUnrooted();
	}


	public bool InView = false;

	public event ScrolledHandler ScrolledIntoView;
	public event ScrolledHandler ScrolledOutOfView;

	void OnScrolledIntoView(object origin)
	{
		var handler = ScrolledIntoView;
		if (handler != null)
			handler(origin, EventArgs.Empty);
	}

	void OnScrolledOutOfView(object origin)
	{
		var handler = ScrolledOutOfView;
		if (handler != null)
			handler(origin, EventArgs.Empty);
	}


	public void OnScrollPositionChanged(object sender, ScrollPositionChangedArgs args) {
		// This currently only works for vertical scroll
		if (SVParent.AllowedScrollDirections == Fuse.Gestures.ScrollDirections.Vertical) {
			if ((ActualPosition.Y <= SVParent.ScrollPosition.Y + SVParent.ActualSize.Y) && (
				 ActualPosition.Y + ActualSize.Y >= SVParent.ScrollPosition.Y)) {
				if (!InView) {
					InView = true;
					OnScrolledIntoView(SVParent);
				}
			}
			else {
				if (InView) {
					InView = false;
					OnScrolledOutOfView(SVParent);
				}
			}
		}
	}
}

public delegate void ScrolledHandler(object sender, EventArgs args);

