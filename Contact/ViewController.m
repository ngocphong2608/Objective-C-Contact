//
//  ViewController.m
//  Contact
//
//  Created by CPU11808 on 2/14/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import "ViewController.h"
#import "CSContactScanner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CSContactScanner *scanner = [CSContactScanner new];
        NSMutableArray *contacts = [scanner getAllContacts];
        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
        
        for (CNContact *contact in contacts) {
            NSString *string = [formatter stringFromContact:contact];
            NSLog(@"contact = %@", string);
        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
