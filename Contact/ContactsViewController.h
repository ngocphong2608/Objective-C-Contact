//
//  ContactsViewController.h
//  Contact
//
//  Created by CPU11808 on 2/15/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSContact.h"
#import "ContactCell.h"
#import "CSContactScanner.h"

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
