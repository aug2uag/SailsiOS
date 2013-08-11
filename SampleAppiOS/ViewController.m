//
//  ViewController.m
//  SampleAppiOS
//
//  Created by Reza Fatahi on 8/8/13.
//  Copyright (c) 2013 Rex Fatahi. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <NSStreamDelegate>
{
    SocketIO* socketIO;

    __weak IBOutlet UITextField *oTextField;
    __weak IBOutlet UITextView *oTextView;
    
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
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
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:1337/"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
//    if (statusCode == 200) {
//        [oCollectionView reloadData];
//    }
    
    NSLog(@"synchronous for handshake-- => data = %@", response1);
    //NSInteger statusCode = [((NSHTTPURLResponse *)response1) statusCode];

    //NSLog(@"status code => %i", statusCode);
    
    NSString* stringFromData = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    NSLog(@"data converted to string ==> string = %@", stringFromData);

    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:1337];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    NSUUID *deviceUUID = [UIDevice currentDevice].identifierForVendor;
    NSString* deviceId = [deviceUUID UUIDString];
    NSLog(@"devicetype =>%@\ndeviceId => %@", deviceType, deviceId);
    
}



#pragma mark -action methods
- (IBAction)submitText:(id)sender
{
    NSLog(@"submit");
    //make object and post to sails
    NSDictionary* tempDictionary = [[NSDictionary alloc] initWithObjects:@[@"Hello world"] forKeys:@[@"text"]];
    NSData* dataObject = [NSKeyedArchiver archivedDataWithRootObject:tempDictionary];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/messages"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [request addValue:@"http://localhost:1337" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataObject];
    
    NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:0 error:nil];
    NSString* responseFromData = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    oTextView.text = responseFromData;

}



@end
