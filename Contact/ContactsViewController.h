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
#import "SelectedContactCell.h"

@interface ContactsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *contacts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
