//
//  MMKBusinessMatchesViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/28/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKBusinessMatchesViewController.h"
#import "MMKBusinessChatViewController.h"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MMKConstants.h"
#import "AppDelegate.h"
#import "PFFacebookUtils.h"
#import <Parse/Parse.h>
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>


@interface MMKBusinessMatchesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *businessMatchesTableView;

@property (strong, nonatomic) NSMutableArray *availableChatRooms;

@end

@implementation MMKBusinessMatchesViewController

-(NSMutableArray *)availableChatRooms
{
    if (!_availableChatRooms){
        _availableChatRooms = [[NSMutableArray alloc] init];
    }
    return _availableChatRooms;
}



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //343
    
    self.businessMatchesTableView.delegate   = self;
    self.businessMatchesTableView.dataSource = self;
    
    [self updateAvailableChatRooms];
    
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMKBusinessChatViewController *chatVC = segue.destinationViewController;
    NSIndexPath *indexPath = sender;
    chatVC.chatRoom = [self.availableChatRooms objectAtIndex:indexPath.row];
}

#pragma mark - Helper Methods

- (void)updateAvailableChatRooms
{
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"user1" equalTo:[PFUser currentUser]];
    
    NSLog(@"A The User 1 is %@",query);
    
    PFQuery *queryInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
      NSLog(@"A The User 2 is %@",queryInverse);
    
    PFQuery *queryCombined = [PFQuery orQueryWithSubqueries:@[query,queryInverse]];
    [queryCombined includeKey:@"chat"];
    [queryCombined includeKey:@"user1"];
    [queryCombined includeKey:@"user2"];
    [queryCombined findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            [self.availableChatRooms removeAllObjects];
            //[self.tableView reloadData];
            [self.availableChatRooms addObjectsFromArray:objects];
            //self.availableChatRooms = [objects mutableCopy];
            [self.businessMatchesTableView reloadData];
            
        }
    }];
}


#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.availableChatRooms count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFObject *chatRoom =[self.availableChatRooms objectAtIndex:indexPath.row];
    
    PFUser *likedUser;
    PFUser *currentUser = [PFUser currentUser];
    PFUser *testUser1 = chatRoom[@"user1"];
    if ([testUser1.objectId isEqual:currentUser.objectId]) {
        likedUser =[chatRoom objectForKey:@"user2"];
    }
    else {
        likedUser = [chatRoom objectForKey:@"user1"];
    }
    
    cell.textLabel.text = likedUser[@"BusinessName"];
    cell.detailTextLabel.text = chatRoom[@"createdAt"];
    
    //344
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PFQuery *queryForPhoto = [[PFQuery alloc] initWithClassName:@"Photo"];
    [queryForPhoto whereKey:@"user" equalTo:likedUser];
    [queryForPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0){
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kMMKPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }];
        }
    }];
    
    return cell;
}

//345
#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"businessMatchesToBusinessChatSegue" sender:indexPath]; //345 indexpath
    
}

@end


