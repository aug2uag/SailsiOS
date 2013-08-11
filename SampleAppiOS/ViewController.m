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
    
    NSMutableData* mutableData;
    NSString *suggestedFilename;
    
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

    //from http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/#post
    
    NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"http://localhost:1337/messages"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"foo=bar&key=value"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    

}


#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    mutableData = [NSMutableData data];
    //suggestedFilename = response.suggestedFilename;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [mutableData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"mutableArray in finishedLoading => %@", [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding]);
    //NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *path = [documentsDir stringByAppendingPathComponent:suggestedFilename];
    //[mutableData writeToFile:path atomically:YES];

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Erro");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
