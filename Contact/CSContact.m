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
    
    if (_fullName == NULL || [_fullName length] < 1)
        return @"";
    
    NSMutableArray *parts = [NSMutableArray arrayWithArray:[_fullName componentsSeparatedByCharactersInSet:[NSCharacterSet  whitespaceCharacterSet]]];
    [parts removeObjectIdenticalTo:@""];
    
    if (parts.count < 1)
        return @"";
    else if (parts.count < 2)
        return [parts[0] substringToIndex:1];
    else {
        NSString *firstCharacter = [parts[0] substringToIndex:1];
        NSString *secondCharacter = [parts[parts.count - 1] substringToIndex:1];
        return [firstCharacter stringByAppendingString:secondCharacter];
    }

    return [_fullName substringToIndex:1];
}

@end
