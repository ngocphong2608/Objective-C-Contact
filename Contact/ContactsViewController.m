//
//  ContactsViewController.m
//  Contact
//
//  Created by CPU11808 on 2/15/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

NSArray *contactIndexTitles;
NSArray *contactSectionTitles;
NSMutableDictionary *contactsDict;
NSMutableArray *selectedContacts;

UIImage *defaultThumbnail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedContacts = [NSMutableArray new];
    
    defaultThumbnail = [UIImage imageNamed:@"default_thumbnail.JPG"];
    
    contactIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    
    [self.tableView setEditing:YES animated:YES];
    
    // load contacts async
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        _contacts = [CSContactScanner.contactManager getAllContacts];
        [self buildContactsDict];
        
        dispatch_async(dispatch_get_main_queue(), ^{    
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view private methods

/**
 Each cell has a image and a label.
 If image is missing, label will be setted as 2 characters of contact's full name

 @param cell the table cell
 @param imageData image data of contact
 @param shortName 2 characters of contact's full name
 */
- (void)setThumbnailImageForTableCell:(ContactCell *)cell withImageData:(NSData *)imageData orShortName:(NSString *) shortName {
    if (imageData == NULL) {
        cell.imageNameLabel.text = shortName;
        cell.thumbnailImageView.image = defaultThumbnail;
    } else {
        cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
    }
}


/**
 Making a dictionary of contacts
 The keys of dictionary will be first character off full name
 If full name is null or empty the key will be '#' character
 */
- (void)buildContactsDict {
    
    // init contactsDict
    contactsDict = [NSMutableDictionary new];
    for (NSString *contactIndex in contactIndexTitles) {
        [contactsDict setObject:[NSMutableArray new] forKey:contactIndex];
    }
    
    for (CSContact *contact in _contacts) {
        NSString *fullName = contact.fullName;
        
        if (fullName == NULL || [fullName length] < 1)
            [contactsDict[@"#"] addObject:contact];
        else {
            [contactsDict[[fullName substringToIndex:1]] addObject:contact];
        }
    }
    
    // remove keys have no contacts
    for (NSString *contactIndex in contactIndexTitles) {
        if ([contactsDict[contactIndex] count] < 1) {
            [contactsDict removeObjectForKey:contactIndex];
        }
    }
    
    contactSectionTitles = [[contactsDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
//    NSLog(@"%@", contactsDict);
//    NSLog(@"%@", contactSectionTitles);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [contactSectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *sectionTitle = [contactSectionTitles objectAtIndex:section];
    NSArray *sectionContacts = [contactsDict objectForKey:sectionTitle];
    return [sectionContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    } else {
        cell.thumbnailImageView.image = NULL;
        cell.imageNameLabel.text = @"";
    }
    
    NSString *sectionTitle = [contactSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contactsDict objectForKey:sectionTitle];
    
    CSContact *contact = [sectionContacts objectAtIndex:indexPath.row];
    
    [self setThumbnailImageForTableCell:cell withImageData:contact.thumbnailImageData orShortName:contact.get2CharatersByFullName];
  
    cell.nameLabel.text = contact.fullName;
    
    return cell;
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return contactIndexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [contactSectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [contactSectionTitles indexOfObject:title];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [contactSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contactsDict objectForKey:sectionTitle];
    CSContact *contact = [sectionContacts objectAtIndex:indexPath.row];
    
//    NSLog(@"user selected %@", [contact fullName]);
    [selectedContacts addObject:contact];
    [_collectionView reloadData];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [contactSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [contactsDict objectForKey:sectionTitle];
    CSContact *contact = [sectionContacts objectAtIndex:indexPath.row];
    
//    NSLog(@"user de-selected %@",[contact fullName]);
    [selectedContacts removeObject:contact];
    [_collectionView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *contactCell = (ContactCell *)cell;
    contactCell.thumbnailImageView.layer.cornerRadius = contactCell.thumbnailImageView.frame.size.width / 2;
    contactCell.thumbnailImageView.clipsToBounds = YES;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}
//
//- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
//{
//    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"fullName contains[c] %@", searchText];
//    searchResults = [_contacts filteredArrayUsingPredicate:resultPredicate];
//}
//
//
//-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
//{
//    [self filterContentForSearchText:searchString
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
//    
//    return YES;
//}

#pragma mark - Collection view datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [selectedContacts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SelectedContactCell";
    
    SelectedContactCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.thumbnailImageView.image = NULL;
    cell.imageNameLabel.text = @"";
    
    CSContact *contact = [selectedContacts objectAtIndex:indexPath.row];
    
    [self setThumbnailImageForCollectionCell:cell withImageData:contact.thumbnailImageData orShortName:contact.get2CharatersByFullName];
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectedContactCell *contactCell = (SelectedContactCell *) cell;
    contactCell.thumbnailImageView.layer.cornerRadius = contactCell.thumbnailImageView.frame.size.width / 2;
    contactCell.thumbnailImageView.clipsToBounds = YES;
}

- (void)setThumbnailImageForCollectionCell:(SelectedContactCell *)cell withImageData:(NSData *)imageData orShortName:(NSString *) shortName{
    if (imageData == NULL) {
        cell.imageNameLabel.text = shortName;
    } else {
        cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
    }
}


/**
 Retrive indexPath from contact

 @param contact the contact that user tap on
 @return indexPath of that contact in contacts tableView
 */
- (NSIndexPath *)indexPathFromContact:(CSContact *)contact {
    
    NSString *character = [[contact fullName] substringToIndex:1];
    int section = 0;
    for (int i = 0; i < [contactSectionTitles count]; i++) {
        if ([character isEqualToString:contactSectionTitles[i]])
            section = i;
    }
    
    NSArray* contactsInSection = contactsDict[character];
    int row = 0;
    for (int i = 0; i < [contactsInSection count]; i++) {
        if ([contact isEqual:contactsInSection[i]])
            row = i;
    }
    
//    NSLog(@"%d %d", section, row);
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSContact *contact = selectedContacts[indexPath.row];

    NSIndexPath *tableIndexPath = [self indexPathFromContact:contact];
    
    [_tableView scrollToRowAtIndexPath:tableIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
