//
//  ContactsViewController.m
//  Contact
//
//  Created by CPU11808 on 2/15/17.
//  Copyright © 2017 CPU11808. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@property (strong, nonatomic) NSArray *contactIndexTitles;
@property (strong, nonatomic) NSMutableDictionary *contactsDict;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEditing:YES animated:YES];
    
    _contactIndexTitles = @[@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    
    
    [self buildContactsDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) buildContactsDict {
    
    // init contactsDict
    _contactsDict = [NSMutableDictionary new];
    for (NSString *contactIndex in _contactIndexTitles) {
        [_contactsDict setObject:[NSMutableArray new] forKey:contactIndex];
    }
    
    for (CSContact *contact in _contacts) {
        [_contactsDict[[contact.fullName substringToIndex:1]] addObject:contact];
    }
    
    NSLog(@"%@", _contactsDict);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_contactsDict count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [_contactIndexTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *sectionTitle = [_contactIndexTitles objectAtIndex:section];
    NSArray *sectionContacts = [_contactsDict objectForKey:sectionTitle];
    return [sectionContacts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ContactCell";
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSString *sectionTitle = [_contactIndexTitles objectAtIndex:indexPath.section];
    NSArray *sectionContacts = [_contactsDict objectForKey:sectionTitle];
    
    CSContact *contact = [sectionContacts objectAtIndex:indexPath.row];
    
    [self setThumbnailImageForCell:cell withImageData:contact.thumbnailImageData orShortName:contact.get2CharatersByFullName];
  
    cell.nameLabel.text = contact.fullName;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _contactIndexTitles;
}

- (void) setThumbnailImageForCell:(ContactCell *)cell withImageData:(NSData *)imageData orShortName:(NSString *) shortName{
    if (imageData == NULL) {
        cell.imageNameLabel.text = shortName;
    } else {
        cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"user selected %@",[[_contacts objectAtIndex:indexPath.row] fullName]);
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"user de-selected %@",[[_contacts objectAtIndex:indexPath.row] fullName]);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
