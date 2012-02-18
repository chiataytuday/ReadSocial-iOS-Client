//
//  ReadSocial.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#define RSDefaultGroup  @"partner-testing-channel"

#import "ReadSocial.h"
#import "RSPage.h"
#import "ReadSocialViewController.h"
#import "DataContext.h"
#import "RSParagraph+Core.h"

NSString* const ReadSocialUserSelectedParagraphNotification         =   @"ReadSocialUserSelectedParagraphNotification";
NSString* const ReadSocialUserWillComposeNoteNotification           =   @"ReadSocialUserWillComposeNoteNotification";
NSString* const ReadSocialUserDidComposeNoteNotification            =   @"ReadSocialUserDidComposeNoteNotification";
NSString* const ReadSocialUserWillComposeResponseNotification       =   @"ReadSocialUserWillComposeResponseNotification";
NSString* const ReadSocialUserDidComposeResponseNotification        =   @"ReadSocialUserDidComposeResponseNotification";
NSString* const ReadSocialParagraphNoteCountUpdatedNotification     =   @"ReadSocialParagraphNoteCountUpdatedNotification";
NSString* const ReadSocialUserDidChangeGroupNotification            =   @"ReadSocialUserDidChangeGroupNotification";

@interface ReadSocial()
{
    @private
    NSString *_currentGroup;
}
/**
 Determines the group with which ReadSocial should intialize.
 If this is the first time this app is being launched, it will return the value of defaultGroup
 otherwise it will look in standardUserDefaults for the last used group.
 
 @return    The name of the group.
 */
- (NSString *) determineInitialGroup;

@end


@implementation ReadSocial
@synthesize networkID, rsPopover, currentPage, defaultGroup;

- (NSString *) getCurrentGroup
{
    if (!_currentGroup)
    {
        _currentGroup = [self determineInitialGroup];
    }
    
    return _currentGroup;
}

- (void) changeToGroupWithString: (NSString *)groupName
{
    // Set the new group name
    _currentGroup = groupName;
    
    // Save the last used group
    [[NSUserDefaults standardUserDefaults] setValue:groupName forKey:@"ReadSocialGroup"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Clear out the persistent store
    [DataContext erase];
    
    // Update the current page
    [currentPage createParagraphs];
    [currentPage requestCommentCount];
}

- (NSString *) determineInitialGroup
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *lastGroup = [[NSUserDefaults standardUserDefaults] valueForKey:@"ReadSocialGroup"];
    
    if (lastGroup)
    {
        return lastGroup;
    }
    else if (defaultGroup)
    {
        return defaultGroup;
    }
    else
    {
        return RSDefaultGroup;
    }
}


- (RSPage *) initializeView: (id<ReadSocialDataSource>)view
{
    RSPage *page = [[RSPage alloc] initWithDataSource:view];
    [page createParagraphs];
    [page requestCommentCount];
    return page;
}

+ (void) setCurrentPage: (id<ReadSocialDataSource>)view
{
    ReadSocial *rs = [ReadSocial sharedInstance];
    rs.currentPage = [rs initializeView:view];
}

+ (void) openReadSocialForParagraph:(RSParagraph *)paragraph inView :(UIView *)view
{
    ReadSocial *rs = [ReadSocial sharedInstance];
    
    // Determine the index of the paragraph on the current page.
    // TODO: What if this paragraph doesn't exist on this page?
    NSInteger index = [rs.currentPage.paragraphs indexOfObject:paragraph];
    
    // Determine the bounding rectangle for the paragraph
    CGRect frame = [rs.currentPage.datasource rectForParagraphAtIndex:index];
    
    // Open the UI
    // TODO: Add another level of abstraction between the API and UI so that the UI could be overridden.
    ReadSocialViewController *rsvc = [[ReadSocialViewController alloc] initWithParagraph:paragraph];
    rs.rsPopover = [[UIPopoverController alloc] initWithContentViewController:rsvc];
    
    // Present the UIPopoverController
    [rs.rsPopover presentPopoverFromRect:frame inView:view permittedArrowDirections:(UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp) animated:YES];
}

+ (void) openReadSocialForRawParagraph: (NSString *)content inView: (UIView *)view
{
    // Create the paragraph
    RSParagraph *paragraph = [RSParagraph createParagraphInDefaultContextForString:content];
    
    [ReadSocial openReadSocialForParagraph:paragraph inView:view];
}

+ (void) openReadSocialForSelectionInView: (UIView *)view
{
    ReadSocial *rs = [ReadSocial sharedInstance];
    
    RSParagraph *paragraph = rs.currentPage.selectedParagraph;
    [ReadSocial openReadSocialForParagraph:paragraph inView:view];
}

+ (NSNumber *) networkID
{
    return [ReadSocial sharedInstance].networkID;
}

+ (NSString *) currentGroup
{
    return [ReadSocial sharedInstance].currentGroup;
}

+ (ReadSocial *) sharedInstance
{
    static ReadSocial *_sharedInstance;
    @synchronized(self)
    {
        if (!_sharedInstance)
        {
            _sharedInstance = [ReadSocial new];
        }
        return _sharedInstance ;
    }
}

+ (ReadSocial *) initializeWithNetworkID: (NSNumber *)networkID andDefaultGroup: (NSString *)defaultGroup
{
    static BOOL initialized;
    
    // This method should only ever be called once--preferably in applicationDidFinishLaunching
    // Any other calls and we will raise an exception.
    if (initialized)
    {
        [NSException raise:@"ReadSocial already initialized" format:@"ReadSocial was previously initialized and can only be initialized once."];
    }
    
    ReadSocial *rs = [ReadSocial sharedInstance];
    rs.networkID    =   networkID;
    rs.defaultGroup =   defaultGroup;
    
    initialized = true;
    
    return rs;
}

@end