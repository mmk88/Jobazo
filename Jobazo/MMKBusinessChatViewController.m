//
//  MMKBusinessChatViewController.m
//  Jobazo
//
//  Created by Munaf Kachwala on 11/28/14.
//  Copyright (c) 2014 Munaf M. Kachwala. All rights reserved.
//

#import "MMKBusinessChatViewController.h"
#import <Parse/Parse.h>
#import "MMKConstants.h"
#import <JSMessagesViewController.h>
#import <JSMessageInputView.h>
#import <JSMessageTextView.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Mixpanel.h>
#define MIXPANEL_TOKEN @"4c051590a5a3568ec9227f64a282d274"

@interface MMKBusinessChatViewController ()

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;

@property (strong, nonatomic) NSMutableArray *chats;

@property (strong, nonatomic) NSString *text;


@end

@implementation MMKBusinessChatViewController

-(JSMessageInputViewStyle)inputViewStyle
{
    
    //CHANGED THE STYLE HERE
    return JSMessageInputViewStyleFlat;
}


- (NSMutableArray *)chats
{
    if (!_chats){
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.delegate =self;
    self.dataSource =self;
    [super viewDidLoad];
    
    
    
    [[JSBubbleView appearance] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    NSLog(@"Step 0");
    self.title = @"Messages";
    NSLog(@"Step 1");
    self.messageInputView.textView.placeHolder = @"Message Your Potential Employer, dawg";
    NSLog(@"Step 2");
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"Step 3");
    
    self.currentUser = [PFUser currentUser];
    
    NSLog(@"Step 4");
    
    PFUser *testUser1 = self.chatRoom[kMMKChatRoomUser1Key];
    
    NSLog(@"Step 5");
    
    if ([testUser1.objectId isEqual:self.currentUser.objectId]){
        self.withUser = self.chatRoom[kMMKChatRoomUser2Key];
    }
    else {
        self.withUser = self.chatRoom[kMMKChatRoomUser1Key];
    }
    self.title = self.withUser[kMMKUserProfileKey][kMMKUserProfileFirstNameKey];
    self.initialLoadComplete = NO;
    
    NSLog(@"Step 6");
    
    [self checkForNewChats];
    
    NSLog(@"Step 7");
    
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
    
}





-(JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSLog(@"Step 8");
    
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kMMKChatFromUserKey];
    
    NSLog(@"Step 9");
    
    if ([testFromUser.objectId isEqual:self.currentUser.objectId])
    {
        return JSBubbleMessageTypeOutgoing;
    }
    else
    {
        return JSBubbleMessageTypeIncoming;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
     self.chatsTimer = nil;
    NSLog(@"Step 12");
}


#pragma mark - TableView DataSource

//this here shows us how many rows based on how many chats

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
}


#pragma mark - TableView Delegate REQUIRED

//when i press send this is what will happen.... and what happens if there is some text is tht

-(void)didSendText:(NSString *)text fromSender:(NSString *)sender onDate:(NSDate *)date
{
    //NSLog(@"%@", text);
    
    if (text.length != 0){
        PFObject *chat = [PFObject objectWithClassName:@"Chat"];
        [chat setObject:self.chatRoom    forKey:kMMKChatChatroomKey];
        [chat setObject:self.currentUser forKey:kMMKChatFromUserKey];
        [chat setObject:self.withUser    forKey:kMMKChatToUserKey];
        [chat setObject:text             forKey:kMMKChatTextKey];
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.chats addObject:chat];
            //[JSMessageSoundEffect playMessageSentSound];
            [self.tableView reloadData];
            [self finishSend];
            [self scrollToBottomAnimated:YES];
            
        }];
    }
}


-(UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath;

{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kMMKChatFromUserKey];
    
    if ([testFromUser.objectId isEqual:self.currentUser.objectId]){
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    }
    else{
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}


- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath sender:(NSString *)sender
{
    return nil;
}


- (id<JSMessageData>)messageForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    
    NSLog(@"%@", chat);
    
    NSString *text = chat[kMMKChatTextKey];
    
    NSDate *date = chat.createdAt;
    
    MMKBusinessMessageData *myMessage1 = [[MMKBusinessMessageData alloc] init]; //Creates a MKMessageData object -- blank slate
    
    NSLog(@"%@", text);
    
    myMessage1.text = text;
    
    myMessage1.date = date;
    
    return myMessage1;
}

#pragma mark - Messages View Delegate OPTIONAL

-(void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing)
    {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}


-(BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages View Data Source REQUIRED

-(NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    
    NSLog(@"%@", chat);
    
    NSString *message = chat[kMMKChatTextKey];
    return message;
}


#pragma mark - Helper Methods

- (void)checkForNewChats
{
    int oldChatCount = [self.chats count]; //Change the int to LONG ????
    
    PFQuery *queryForChats = [PFQuery queryWithClassName:kMMKChatClassKey];
    [queryForChats whereKey:kMMKChatChatroomKey equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            if  (self.initialLoadComplete == NO || oldChatCount != [objects count]){
                self.chats = [objects mutableCopy];
                [self.tableView reloadData];
                
                if (self.initialLoadComplete == YES)
                {
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}



/**
 *  Asks the data source for the date to display in the timestamp label *above* the row at the specified index path.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return A date object specifying when the message at indexPath was sent. This value may be `nil`.
 */
- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return nil;
}

/**
 *  Asks the data source for the imageView to display for the row at the specified index path. The imageView must have its `image` property set.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return An image view specifying the avatar for the message at indexPath. This value may be `nil`.
 */
- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return nil;
}

/**
 *  Asks the data source for the text to display in the subtitle label *below* the row at the specified index path.
 *
 *  @param indexPath An index path locating a row in the table view.
 *
 *  @return A string containing the subtitle for the message at indexPath. This value may be `nil`.
 */
- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return nil;
}

/*
- (IBAction)chatBackButtonPressed:(UIBarButtonItem *)sender {
    
    if ([[PFUser currentUser][@"profile"][@"age"] intValue] < -99) {
        [self performSegueWithIdentifier:@"chatToBusinessMatchesSegue" sender:self]; // for employer transition
    } else {
        [self performSegueWithIdentifier:@"matchesToChatSegue" sender:self]; //for employee transition
    }
}
 */



@end
