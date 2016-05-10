WhileVisibleInScrollView Fuse trigger [![Build Status](https://travis-ci.org/bolav/fuse-whilevisibleinscrollview.svg?branch=master)](https://travis-ci.org/bolav/fuse-whilevisibleinscrollview)
=====================================

A trigger for [Fuse](http://www.fusetools.com/), for when elements are visible in a ScrollView.

Status: beta
Author: bolav


### Usage:

In your unoproj, just copy the `WhileVisibleInScrollView.uno` and use it like this:

```
<ScrollView>
  <StackPanel>
    <Button Text="Button">
      <WhileVisibleInScrollView>
        <DebugAction Message="Button visible!" />
      </WhileVisibleInScrollView>
    </Button>
  </StackPanel>
</ScrollView>
```

Or use [fusepm](https://github.com/bolav/fusepm)

    $ fusepm install https://github.com/bolav/fuse-whilevisibleinscrollview

### Support

* For feature request or bugs just post a github issue.