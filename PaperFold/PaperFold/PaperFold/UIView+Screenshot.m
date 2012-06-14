//
//  UIView+Screenshot.m
//  PaperFold
//
//  Created by Hon Cheng Muh on 7/2/12.
//  Copyright (c) 2012 honcheng@gmail.com. All rights reserved.
//

#import "UIView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@implementation UIView (Screenshot)

- (UIImage*)screenshot
{
    // if iOS6, use OpenGL method to take mapview screenshot
    // just a temporary method until a proper solution is found
    if ([self isKindOfClass:NSClassFromString(@"MKMapView")] && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
    {
        UIImage *image = [self openGLSnapshot];
        
        //                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //                    NSString *documentsDirectory = [paths objectAtIndex:0];
        //                    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"test.png"];
        //                    NSData *data = UIImagePNGRepresentation(image);
        //                    [data writeToFile:imagePath atomically:YES];
        
        return image;
    }
    else
    {
        if ([self isKindOfClass:NSClassFromString(@"MKMapView")])
        {
            // if the view is a mapview, screenshot has to take the screen scale into consideration
            // else, the screen shot in retina display devices will be of a less detail map (note, it is not the size of the screenshot, but it is the level of detail of the screenshot 
            UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
        }
        else
        {
            // for performance consideration, everything else other than mapview will use a lower quality screenshot
            UIGraphicsBeginImageContext(self.frame.size);
        }
        
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return screenshot;
    }
    
}

- (void)takeScreenshot:(CompletionBlock)block
{
    dispatch_queue_t queue = dispatch_queue_create("screenshot", 0);
    dispatch_async(queue, ^(void) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        dispatch_async(dispatch_get_main_queue(), ^{
            block(screenshot);
        });
        dispatch_release(queue);
    });
}


- (UIImage*)openGLSnapshot
{
    /*
     GLint backingWidth, backingHeight;
     
     // Bind the color renderbuffer used to render the OpenGL ES view
     // If your application only creates a single color renderbuffer which is already bound at this point, 
     // this call is redundant, but it is needed if you're dealing with multiple renderbuffers.
     // Note, replace "_colorRenderbuffer" with the actual name of the renderbuffer object defined in your class.
     //glBindRenderbufferOES(GL_RENDERBUFFER_OES, glIsRenderbuffer);
     
     // Get the size of the backing CAEAGLLayer
     glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
     glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
     
     NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
     NSInteger dataLength = width * height * 4;
     GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
     
     // Read pixel data from the framebuffer
     glPixelStorei(GL_PACK_ALIGNMENT, 4);
     glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
     
     // Create a CGImage with the pixel data
     // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
     // otherwise, use kCGImageAlphaPremultipliedLast
     CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
     CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
     CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,
     ref, NULL, true, kCGRenderingIntentDefault);
     
     // OpenGL ES measures data in PIXELS
     // Create a graphics context with the target size measured in POINTS
     NSInteger widthInPoints, heightInPoints;
     if (NULL != UIGraphicsBeginImageContextWithOptions) {
     // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
     // Set the scale parameter to your OpenGL ES view's contentScaleFactor
     // so that you get a high-resolution snapshot when its value is greater than 1.0
     CGFloat scale = self.contentScaleFactor;
     widthInPoints = width / scale;
     heightInPoints = height / scale;
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
     }
     else {
     // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
     widthInPoints = width;
     heightInPoints = height;
     UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
     }
     
     CGContextRef cgcontext = UIGraphicsGetCurrentContext();
     
     // UIKit coordinate system is upside down to GL/Quartz coordinate system
     // Flip the CGImage by rendering it to the flipped bitmap context
     // The size of the destination area is measured in POINTS
     CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
     CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
     
     // Retrieve the UIImage from the current context
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     
     // Clean up
     free(data);
     CFRelease(ref);
     CFRelease(colorspace);
     CGImageRelease(iref);
     
     return image;*/
    
    /*
     NSInteger myDataLength = self.frame.size.width * self.frame.size.height * 4;
     
     // allocate array and read pixels into it.
     GLubyte *buffer = (GLubyte *) malloc(myDataLength);
     glReadPixels(0, 0, self.frame.size.width, self.frame.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
     
     // gl renders "upside down" so swap top to bottom into new array.
     // there's gotta be a better way, but this works.
     GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
     for(int y = 0; y < (int)self.frame.size.height; y++)
     {
     for(int x = 0; x < self.frame.size.width * 4; x++)
     {
     buffer2[((int)self.frame.size.height-1 - y) * (int)self.frame.size.width * 4 + x] = buffer[y * 4 * (int)self.frame.size.width + x];
     }
     }
     
     // make data provider with data.
     CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
     
     // prep the ingredients
     int bitsPerComponent = 8;
     int bitsPerPixel = 32;
     int bytesPerRow = 4 * self.frame.size.width;
     CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
     CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
     CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
     
     // make the cgimage
     CGImageRef imageRef = CGImageCreate(self.frame.size.width, self.frame.size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
     
     // then make the uiimage from that
     UIImage *myImage = [UIImage imageWithCGImage:imageRef];
     return myImage;*/
    
    
    unsigned char buffer[(int)self.frame.size.width*(int)self.frame.size.height*4];
    glReadPixels(0,0,(int)self.frame.size.width,(int)self.frame.size.height,GL_RGBA,GL_UNSIGNED_BYTE,&buffer);
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, &buffer, (int)self.frame.size.width*(int)self.frame.size.height*4, NULL);
    CGImageRef iref = CGImageCreate((int)self.frame.size.width,(int)self.frame.size.height,8,32,(int)self.frame.size.width*4,CGColorSpaceCreateDeviceRGB(),kCGBitmapByteOrderDefault,ref,NULL,true,kCGRenderingIntentDefault);
    
    size_t width         = CGImageGetWidth(iref);
    size_t height        = CGImageGetHeight(iref);
    size_t length        = width*height*4;
    uint32_t *pixels     = (uint32_t *)malloc(length);
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width*4, CGImageGetColorSpace(iref), kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), iref);
    CGImageRef outputRef = CGBitmapContextCreateImage(context);
    UIImage *outputImage = [UIImage imageWithCGImage:outputRef];
    return outputImage;
}


@end
