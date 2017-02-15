//
//  CSContact.h
//  Contact
//
//  Created by CPU11808 on 2/15/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Contacts;

@interface CSContact : NSObject

@property NSString *fullName;
@property NSData *thumbnailImageData;

- (id)initWithContact:(CNContact *)contact;
- (NSString *)get2CharatersByFullName;

@end
