//
//  ViewController.m
//  iossample1
//
//  Created by tomatomb on 2016. 12. 11..
//  Copyright © 2016년 nmj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableData *_responseData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick1:(id)sender {
    NSLog(@"btnClick1");
    [self httpSyncCall];
}

- (IBAction)btnClick2:(id)sender {
    NSLog(@"btnClick2");
    [self httpAsyncCall];
}

- (IBAction)btnClick3:(id)sender {
    NSLog(@"btnClick3");
    [self httpAsyncCallUsingPost];
}

- (IBAction)btnClick4:(id)sender {
    NSLog(@"btnClick4");
}

- (IBAction)btnClick5:(id)sender {
    NSLog(@"btnClick5");
}


- (void) httpSyncCall
{
    // error message
    // App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.
    // http://rhammer.tistory.com/67
    // info.plist에 아래 항목 추가
    //    <key>NSAppTransportSecurity</key>
    //    <dict>
    //    <key>NSAllowsArbitraryLoads</key><true/>
    //    </dict>

    NSLog(@"httpSyncCall prev");
    // http://codewithchris.com/tutorial-how-to-use-ios-nsurlconnection-by-example/

    
    // Send a synchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    

    if (error == nil)
    {
        // Parse data here
//        const unsigned char* pstrResult = (const unsigned char*)[data bytes];
//        NSLog(@"http result : %s", pstrResult);
//        NSString *pstrResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // 안됨.
        NSString *pstrResult = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"http success result : %@", pstrResult);
        
    }
    else
    {
        
        NSLog(@"http fail");
        NSLog(@"http error:%@", error);
        
//            Error sample
//            Domain=NSURLErrorDomain
//            Code=-1003 "A server with the specified hostname could not be found."
//            UserInfo={
//                NSUnderlyingError=0x6000002491e0 {
//                    Error Domain=kCFErrorDomainCFNetwork
//                    Code=-1003 "A server with the specified hostname could not be found."
//                    UserInfo={
//                        NSErrorFailingURLStringKey=http://google2.com/,
//                        NSErrorFailingURLKey=http://google2.com/,
//                        _kCFStreamErrorCodeKey=0,
//                        _kCFStreamErrorDomainKey=0,
//                        NSLocalizedDescription=A server with the specified hostname could not be found.}
//                },
//                NSErrorFailingURLStringKey=http://google2.com,
//                NSErrorFailingURLKey=http://google2.com,
//                _kCFStreamErrorDomainKey=0,
//                _kCFStreamErrorCodeKey=0,
//                NSLocalizedDescription=A server with the specified hostname could not be found.
//            }
    }
    
    NSLog(@"httpSyncCall after");
    
}

//------------------------------------------------------------------------------
- (void) httpAsyncCall
{
    
    // Create the request.
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]; // 상동
    
    // Create url connection and fire request
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    
}


// delegate NSURLConnectionDataDelegate start
// 아래 코드는 복붙한것임.
// delegate 호출 순서는
//delegate didReceiveResponse
//delegate connection didReceiveData
//delegate connection didReceiveData
//delegate connection didReceiveData
//...
//delegate connection willCacheResponse
//delegate connectionDidFinishLoading

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
    NSLog(@"delegate didReceiveResponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSLog(@"delegate connection didReceiveData");
    // didReceiveData는 한번의 request 처리중에 여러 번 호출됨.
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    NSLog(@"delegate connection willCacheResponse");
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"delegate connectionDidFinishLoading");
    
    
    NSString *pstrResult = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    NSLog(@"http success result : %@", pstrResult);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"delegate connection didFailWithError");
}
// delegate NSURLConnectionDataDelegate end

//------------------------------------------------------------------------------
- (void)httpAsyncCallUsingPost
{
    // POST 호출시에는 request.HTTPMethod, request.HTTPBody 를 설정하는게 추가되고,
    // header도 세팅함.
    
    // Create the request.
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    
    // Specify that it will be a POST request
    urlRequest.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [urlRequest setValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Convert your data and set your request's HTTPBody property
    NSString *stringData = @"some data";
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = requestBodyData;

    // Create url connection and fire request
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
     
}




@end
