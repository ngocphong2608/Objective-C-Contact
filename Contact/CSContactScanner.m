//
//  CSContactScanner.m
//  Contact
//
//  Created by CPU11808 on 2/14/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import "CSContactScanner.h"

@implementation CSContactScanner

+ (id)contactManager {
    
    static CSContactScanner *scanner = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanner = [CSContactScanner new];
    });
    return scanner;
}


- (NSMutableArray*) getAllContacts {
    
    dispatch_group_t contactGroup = dispatch_group_create();
    
    dispatch_group_enter(contactGroup);
    CNContactStore *store = [CNContactStore new];
    NSMutableArray *contacts = [NSMutableArray new];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        // make sure the user granted access
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // user didn't grant access;
                // so, again, tell user here why app needs permissions in order  to do it's job;
                // this is dispatched to the main queue because this request could be running on background thread
                NSLog(@"User denied");
            });
            
            dispatch_group_leave(contactGroup);
            return;
        }
        
        NSError *fetchError;
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch: @[CNContactIdentifierKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactThumbnailImageDataKey]];
        
        BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
            [contacts addObject:[[CSContact alloc] initWithContact:contact ]];
        }];
        
        if (!success) {
            NSLog(@"error = %@", fetchError);
        }
        
        dispatch_group_leave(contactGroup);
    }];
    
    dispatch_group_wait(contactGroup, DISPATCH_TIME_FOREVER);
    
    
    return contacts;
}

@end
