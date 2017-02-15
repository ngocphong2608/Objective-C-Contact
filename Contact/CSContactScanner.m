//
//  CSContactScanner.m
//  Contact
//
//  Created by CPU11808 on 2/14/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import "CSContactScanner.h"

@implementation CSContactScanner


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
            return;
        }
        
        NSError *fetchError;
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch: @[CNContactIdentifierKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]]];
        
        BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
            [contacts addObject:contact];
        }];
        
        if (!success) {
            NSLog(@"error = %@", fetchError);
        }
        
        dispatch_group_leave(contactGroup);
        
//        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
//        
//        for (CNContact *contact in contacts) {
//            NSString *string = [formatter stringFromContact:contact];
//            NSLog(@"contact = %@", string);
//        }
    }];
    
    dispatch_group_wait(contactGroup, DISPATCH_TIME_FOREVER);
    
    
    return contacts;
}

@end
