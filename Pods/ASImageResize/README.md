This category allows you to resize an UIImage at a constraint size, or proportionally so that it fits in a given CGSize.

This category defines the following methods :

``` objective-c
-(UIImage*)resizedImageToSize:(CGSize*)size;
-(UIImage*)resizedImageToFitInSize:(CGSize*)size scaleIfSmaller:(BOOL)scale;
```

This methods takes correctly the imageOrientation / EXIF orientation into account.

# N.B.

The author of the code is Olivier Halligon. The unpodded code repository can be found at https://github.com/AliSoftware/UIImage-Resize.