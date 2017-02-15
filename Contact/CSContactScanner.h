//
//  CSContactScanner.h
//  Contact
//
//  Created by CPU11808 on 2/14/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Contacts;
#import "CSContact.h"

@interface CSContactScanner : NSObject

+ (id)contactManager;

- (NSMutableArray*)getAllContacts;

@end
