//
//  AppDelegate.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/21/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ReadSocialAPI.h"
#import "ReadSocialUI.h"

NSString* const kUseAppKey              =   @"rs_use_appkey";
NSString* const kAppIdentifierKey       =   @"rs_app_identifier";
NSString* const kAppSecretKey           =   @"rs_app_secret";
NSString* const kRSUserID               =   @"rs_user_id";
NSString* const kRSUserName             =   @"rs_user_name";
NSString* const kRSUserDomain           =   @"rs_user_domain";
NSString* const kRSUserImageURL         =   @"rs_user_image";

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"fSxua20klUTHGvq0TPHF8CVHtFI6SVTwJepRU6bl",          kAppIdentifierKey,
                              @"8iwQBJDIfslTRhs8wR1DJ3pRNpcviq53BLqTm5dO",          kAppSecretKey,
                              @"readsocial.net",                                    kRSUserDomain,
                              @"https://www.readsocial.net/images/demo-avatar.png", kRSUserImageURL,
                              @"9999",                                              kRSUserID, 
                              nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    // Initialize ReadSocial
    [ReadSocial initializeWithNetworkID:[NSNumber numberWithInt:8] defaultGroup:@"partner-testing-channel" andUILibrary:[ReadSocialUI library]];
    
    // Set the server
    [[ReadSocial sharedInstance] setApiURL:[NSURL URLWithString:@"http://dev.readsocial.net"]];
    
    // Check if the settings specified a user
    [self checkForManualUserData];
    
    // If your app has private/secret keys, typically you'd set them here:
    // (in our demo app, these values are controlled by the settings bundle--see the checkForManualUserData method).
    //[[ReadSocial sharedInstance] setAppKey:@"fSxua20klUTHGvq0TPHF8CVHtFI6SVTwJepRU6bl"];
    //[[ReadSocial sharedInstance] setAppSecret:@"8iwQBJDIfslTRhs8wR1DJ3pRNpcviq53BLqTm5dO"];
    
    // If you set private/secret keys, you MUST set the current user information before creating
    // a note or a response or the user will get an error when attempting to create notes/responses.
    // (in our demo app, these values are controlled by the settings bundle--see the checkForManualUserData method).
    //[[ReadSocial sharedInstance] setCurrentUser:[RSUser userWithID:@"100" andName:@"Daniel Pfeiffer" andImageURL:[NSURL URLWithString:@"https://www.readsocial.net/images/demo-avatar.png"] forDomain:@"floatlearning.com"]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [self checkForManualUserData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ReadSocial" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (void) resetStore
{
    NSArray *stores = [self.persistentStoreCoordinator persistentStores];
    
    for(NSPersistentStore *store in stores) {
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    
    __persistentStoreCoordinator = nil;
    __managedObjectContext = nil;
    __managedObjectModel = nil;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ReadSocial.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - 
- (void) checkForManualUserData
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    // Check if we need to use the app key
    if ([[settings valueForKey:kUseAppKey] boolValue])
    {
        // Key
        [[ReadSocial sharedInstance] setAppKey:[settings valueForKey:kAppIdentifierKey]];
        [[ReadSocial sharedInstance] setAppSecret:[settings valueForKey:kAppSecretKey]];
        
        // User data
        RSUser *user = [RSUser userWithID:[settings valueForKey:kRSUserID]
                                  andName:[settings valueForKey:kRSUserName]
                              andImageURL:[NSURL URLWithString:[settings valueForKey:kRSUserImageURL]]
                                forDomain:[settings valueForKey:kRSUserDomain]];
        
        [[ReadSocial sharedInstance] setCurrentUser:user];
        NSLog(@"Enabled manual user data.");
    }
    else
    {
        [[ReadSocial sharedInstance] setAppKey:nil];
        [[ReadSocial sharedInstance] setAppSecret:nil];
        [[ReadSocial sharedInstance] setCurrentUser:nil];
        NSLog(@"Enabled provider user data.");
    }
}

@end
