//
//  CSContact.m
//  Contact
//
//  Created by CPU11808 on 2/15/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import "CSContact.h"

@implementation CSContact

- (id)initWithContact:(CNContact *)contact {
    
    self = [super init];
    if (self) {
        // copy contact full name
        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
        _fullName = [formatter stringFromContact:contact];
        
        // copy thumbnail image
        _thumbnailImageData = contact.thumbnailImageData;
    }
    return self;
}

- (NSString *)get2CharatersByFullName {
    return [_fullName substringToIndex:1];
}

@end
