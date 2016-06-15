using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Controls;
using Fuse.Triggers;
using Fuse.Elements;
using Fuse.Gestures;
using Uno.UX;

public class WhileVisibleInScrollView : WhileTrigger
{
	ScrollView SVParent;
	Element ElementParent;

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

	public bool InView = false;

	protected override void OnRooted()
	{
		base.OnRooted();
		if (Parent is Element) {
			ElementParent = Parent as Element;
		}
		else {
			Diagnostics.UserRootError("Element", Parent, this);
			return;
		}

		SVParent = Parent.FindByType<ScrollView>();
		if (SVParent == null) {
			Diagnostics.UserRootError("ScrollView", Parent, this);
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

	protected override void OnUnrooted()
	{
		if (SVParent != null)
		{
			SVParent.ScrollPositionChanged -= OnScrollPositionChanged;
		}
		SVParent = null;
		base.OnUnrooted();
	}

	// TODO: Make support for full in view / partial
	public bool CheckInView() {
		if (SVParent.AllowedScrollDirections == ScrollDirections.Vertical) {
			if ((ElementParent.ActualPosition.Y <= SVParent.ScrollPosition.Y + SVParent.ActualSize.Y) && (
				 ElementParent.ActualPosition.Y + ElementParent.ActualSize.Y >= SVParent.ScrollPosition.Y)) {
				return true;
			}
			else {
				return false;
			}
		}
		return false;
	}

	bool _first = true;
	public void OnScrollPositionChanged(object sender, ValueChangedArgs<float2> args) {
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
