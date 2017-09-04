MDFInternationalization assists in internationalizing your iOS app or components.

[![GitHub release](https://img.shields.io/github/release/material-foundation/material-internationalization-ios.svg)](https://github.com/material-foundation/material-internationalization-ios/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/material-foundation/material-internationalization-ios/blob/develop/LICENSE)
[![Build Status](https://travis-ci.org/material-foundation/material-internationalization-ios.svg?branch=stable)](https://travis-ci.org/material-foundation/material-internationalization-ios)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Adding RTL calculations to CGRect and other CGGeometry structures.

A view is conceptually positioned within its superview in terms of leading/trailing. When it's time
to actually lay out (i.e. setting frames), you position the frame as you usually would, but if you
are in the opposite layout direction you use this code to return a CGRect that has been flipped
around its vertical axis.

``` obj-c
// To flip a subview's frame horizontally, pass in subview.frame and the width of its parent.
CGRect flippedFrame = MDFRectFlippedHorizontally(originalFrame, CGRectGetWidth(self.bounds));
```

## Mirroring Images

A category on UIImage backports iOS 10's `[UIImage imageWithHorizontallyFlippedOrientation]` to
earlier versions of iOS.

``` obj-c
// To mirror on image, invoke mdf_imageWithHorizontallyFlippedOrientation.
UIImage *mirroredImage = [originalImage mdf_imageWithHorizontallyFlippedOrientation];
```

## Adding semantic context

A category on UIView backports iOS 9's `-[UIView semanticContentAttribute]` and iOS 10's
`-[UIView effectiveUserInterfaceLayoutDirection]` to earlier versions of iOS.

``` obj-c
// To set a semantic content attribute, set the mdf_semanticContentAttribute property.
lockedLTRView.mdf_semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;

// mdf_semanticContentAttribute is used to calculate the mdf_effectiveUserInterfaceLayoutDirection
if ([customControl mdf_effectiveUserInterfaceLayoutDirection] == UIUserInterfaceLayoutDirectionRightToLeft) {
  // Update customControl's layout to be in RTL mode.
}
```

## Usage

See Examples/Flags for a detailed example of how to use the functionality provided by this library.


## License

MDFInternationalization is licensed under the [Apache License Version 2.0](LICENSE).
