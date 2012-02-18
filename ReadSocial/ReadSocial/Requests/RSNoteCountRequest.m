//
//  RSNoteCountRequest.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 1/30/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSNoteCountRequest.h"
#import "RSParagraph+Core.h"

@implementation RSNoteCountRequest
@synthesize paragraph=_paragraph, noteCount;

+ (RSNoteCountRequest *) retrieveNoteCountOnParagraph: (RSParagraph *) paragraph withDelegate: (id<RSAPIRequestDelegate>)delegate
{
    RSNoteCountRequest *request = [[RSNoteCountRequest alloc] initWithParagraph: paragraph];
    request.delegate = delegate;
    [request start];
    return request;
}
+ (RSNoteCountRequest *) retrieveNoteCountOnParagraph: (RSParagraph *) paragraph
{
    return [RSNoteCountRequest retrieveNoteCountOnParagraph: paragraph withDelegate:nil];
}
- (RSNoteCountRequest *) initWithParagraph: (RSParagraph *) paragraph
{
    self = [super init];
    if (self)
    {
        self.paragraph = paragraph;
    }
    return self;
}

# pragma mark - RSAPIRequest Overriden Methods
- (NSMutableURLRequest *) createRequest
{
    NSMutableURLRequest *request = [super createRequest];
    
    // Determine the URL
    NSString *url = [NSString stringWithFormat:@"%@/v1/%@/%@/notes/count?par_hash=%@", ReadSocialAPIURL, networkID, group, self.paragraph.par_hash];
    
    [request setURL:[NSURL URLWithString:url]];
    
    return request;
}

- (void) handleResponse:(id)json error:(NSError *__autoreleasing *)error
{
    [super handleResponse:json error:error];
    
    self.paragraph.noteCount = noteCount = [json valueForKey:@"count"];
}

@end