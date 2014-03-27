//
//  ImageDownloader.m
//  Venue
//
//  Created by Daniel Cintra on 3/26/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader{
    dispatch_queue_t _image_queue;
}

-(void) downloadImage: (NSString *) photoURL photo:(UIImage*) pic{
    
    __block UIImage *photo = pic;
    NSLog(@"inside download image method");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURL *url = [NSURL URLWithString: photoURL];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:req
                                           queue:[NSOperationQueue currentQueue]
                               completionHandler:
         ^(NSURLResponse *res, NSData *data, NSError *err) {
             // Convert the data to a UIImage
             UIImage *image = [UIImage imageWithData:data];
             CGSize destinationSize = CGSizeMake(40, 40);
             UIGraphicsBeginImageContext(destinationSize);
             [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
             photo = UIGraphicsGetImageFromCurrentImageContext();
             UIGraphicsEndImageContext();
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"Downloaded Image!");
                 [self imageIsReady:photo];
             });
         }];
    });
}

- (UIImage *)imageIsReady:(UIImage *) image{
    NSLog(@"image is ready");
    return image;
}

void UIImageFromURL( NSString * photoURL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) ){
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSURL *URL = [NSURL URLWithString: photoURL];
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}


@end
