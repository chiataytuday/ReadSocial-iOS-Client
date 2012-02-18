//
//  ReadSocialAPI.h
//  ReadSocial
//
//  This is the header that implementing apps will include.
//
//  Created by Daniel Pfeiffer on 2/18/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

// Models
#import "RSParagraph+Core.h"
#import "RSNote+Core.h"
#import "RSResponse+Core.h"
#import "RSUser+Core.h"
#import "RSPage.h"

// Handlers
#import "RSNoteHandler.h"
#import "RSResponseHandler.h"
#import "RSUserHandler.h"

// API Requests
#import "RSAPIRequest.h"
#import "RSParagraphNotesRequest.h"
#import "RSNoteResponsesRequest.h"
#import "RSCreateNoteRequest.h"
#import "RSCreateNoteResponseRequest.h"
#import "AuthStatusRequest.h"
#import "RSNoteCountRequest.h"

// Core methods
#import "ReadSocial.h"

// Context
// TODO: Determine if DataContext should be a public header--in theory, implementing apps shouldn't be directly accessing the data context.
#import "DataContext.h"