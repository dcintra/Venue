//
//  ImageDownloader.h
//  Venue
//
//  Created by Daniel Cintra on 3/26/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloader : NSObject


-(void) downloadImage: (NSString *) photoURL photo:(UIImage*) pic;
-(UIImage *)imageIsReady:(UIImage *) image;
void UIImageFromURL( NSString * photoURL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) );
@end
