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
    //  **Socket.io API** 
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
    
    //handshake
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:1337/"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
    //converts response to string (index.html)
    NSString* stringFromData = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    NSLog(@"data converted to string ==> string = %@", stringFromData);

    //init socket.io
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:1337];
    
}



#pragma mark -action methods
- (IBAction)submitText:(id)sender
{
    NSLog(@"submit");
    //make dummy object to post sails (localhost)
    NSDictionary* tempDictionary = [[NSDictionary alloc] initWithObjects:@[@"Hello world"] forKeys:@[@"text"]];
    //NSData* dataObject = [NSKeyedArchiver archivedDataWithRootObject:tempDictionary];
    

    // POST with SocketIO
    [socketIO connectToHost:@"localhost" onPort:3000 withParams:nil withNamespace:@"/messages"];
    [socketIO sendJSON:tempDictionary withAcknowledge:^(id argsData) {
        NSLog(@"callback %@", [[NSString alloc] initWithData:argsData encoding:NSUTF8StringEncoding]);
    }];
    
    
    
    
    /**     **NATIVE ASYNCHRONOUS POST**
     
     //create request natively
     //    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:1337/messages"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
     //    [request setHTTPMethod:@"POST"];
     //    [request setHTTPBody:dataObject];
     
     //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     //        //[NSJSONSerialization dataWithJSONObject:tempDictionary options:0 error:nil];
     //        //NSLog(@"response array => %@", array);
     //        NSString* responseFromData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     //        oTextView.text = responseFromData;
     //    }];
     
     **/
    
    
    
    /**     **NATIVE SYNCHRONOUS POST**
     
    NSData* responseFromRequest = [NSURLConnection sendSynchronousRequest:request returningResponse:0 error:nil];
    oTextView.text = [[NSString alloc] initWithData:responseFromRequest encoding:NSUTF8StringEncoding];
     
     **/

}



@end
