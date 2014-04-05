//
//  NSString+AddressSubString.m
//  Venue
//
//  Created by Daniel Cintra on 4/4/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "NSString+AddressSubString.h"

@implementation NSString (AddressSubString)


//The following method cleans up the address format returned by the Google Place API by removing the Country and State

-(NSString *)substringAddress:(NSString *)addr{
    
    //check if the address contains a comma or not 
    NSRange textRange;
    textRange =[addr rangeOfString:@","];
    NSString *output;
    if(textRange.location != NSNotFound)
    {
        NSArray *streetCity = [addr componentsSeparatedByString: @", "];
        NSArray *subStrings = [streetCity subarrayWithRange: NSMakeRange(0, 2)];
        output = [subStrings componentsJoinedByString:@", "];
    } else {
        output = addr;
    }
    return output;
}

@end
