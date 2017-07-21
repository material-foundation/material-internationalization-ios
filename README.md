MDFInternationalization assists in internationalizing your app or components.

[![Build Status](https://travis-ci.org/material-foundation/material-internationalization-ios.svg?branch=develop)](https://travis-ci.org/material-foundation/material-internationalization-ios)

## Adding RTL calculations to CGRect and other CGGeometry structures.

A view is conceptually positioned within its superview in terms of leading/trailing. When it's time
to actually lay out (i.e. setting frames), you position the frame as you usually would, but if you
are in the opposite layout direction you use this code to return a CGRect that has been flipped
around its vertical axis.

## Mirroring Images

A category on UIImage backports iOS 10's `[UIImage imageWithHorizontallyFlippedOrientation]` to
earlier versions of iOS.

## Adding semantic context

A category on UIView backports iOS 9's `-[UIView semanticContentAttribute]` and iOS 10's
`-[UIView effectiveUserInterfaceLayoutDirection]` to earlier versions of iOS.

## Usage

See MDCInternationalizationExample for an example of how to use this functionality.

## License

MDFInternationalization is licensed under the [Apache License Version 2.0](LICENSE).
