//
//  ViewController.m
//  SampleAppiOS
//
//  Created by Reza Fatahi on 8/8/13.
//  Copyright (c) 2013 Rex Fatahi. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    SocketIO* socketIO;
    __weak IBOutlet UICollectionView *oCollectionView;
    __weak IBOutlet UITextView *oTextView;
}

- (IBAction)submitText:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  **API** 
    //send data
    /**
    - (void) sendMessage:(NSString *)data;
    - (void) sendMessage:(NSString *)data withAcknowledge:(SocketIOCallback)function;
    - (void) sendJSON:(NSDictionary *)data;
    - (void) sendJSON:(NSDictionary *)data withAcknowledge:(SocketIOCallback)function;
    - (void) sendEvent:(NSString *)eventName withData:(NSDictionary *)data;
    - (void) sendEvent:(NSString *)eventName withData:(NSDictionary *)data andAcknowledge:(SocketIOCallback)function;
     **/
    
    //callBack
    /**
     SocketIOCallback cb = ^(id argsData) {
     NSDictionary *response = argsData;
     // do something with response
     };
     [socketIO sendEvent:@"welcomeAck" withData:dict andAcknowledge:cb];
     **/
    
    //handshake
    /**
     [socketIO connectToHost:@"localhost"
     onPort:3000
     withParams:[NSDictionary dictionaryWithObjectsAndKeys:@"1234", @"auth_token", nil]
     ];
     **/
    
    //namespace
    /**
     [socketIO connectToHost:@"localhost" onPort:3000 withParams:nil withNamespace:@"/users"];
     **/
 
    // objects returned as NSDATA data property (variableName.data)
    NSLog(@"in here");
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8081"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSLog(@"synchronous for handshake-- => data = %@", response1);
    NSString* stringFromData = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    NSLog(@"data converted to string ==> string = %@", stringFromData);

    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:8081];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    NSUUID *deviceUUID = [UIDevice currentDevice].identifierForVendor;
    NSString* deviceId = [deviceUUID UUIDString];
    NSLog(@"devicetype =>%@\ndeviceId => %@", deviceType, deviceId);
    
    [oCollectionView reloadData];
}

#pragma mark io delegate methods


#pragma mark -collectionView methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
       cell = [[UICollectionViewCell alloc] init];
    }
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor purpleColor];
    } else if (indexPath.row == 1) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}

#pragma mark -action methods
- (IBAction)submitText:(id)sender
{
    NSLog(@"submit");
}
@end
