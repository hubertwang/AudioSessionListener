//
//  AudioSessionListener.m
//  
//
//  Created by Hubert Jing Wei Wang on 12/12/3.
//
//

#import "AudioSessionListener.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioSessionListener

- (void)addAudioSessionListener
{
    UInt32 routeSize = sizeof (CFStringRef); CFStringRef route;
    AudioSessionGetProperty (kAudioSessionProperty_AudioRoute, &routeSize, &route);
    AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange, callbackHeadphone_func, (__bridge void *)(self));
    NSString* routeStr = (__bridge NSString*)route;
    NSLog(@"%@",routeStr);
}

- (void)removeAudioSessionListener
{
    UInt32 routeSize = sizeof (CFStringRef); CFStringRef route;
    AudioSessionGetProperty (kAudioSessionProperty_AudioRoute, &routeSize, &route);
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRoute, callbackHeadphone_func, (__bridge void *)(self));
}

void callbackHeadphone_func ( void *inClientData, AudioSessionPropertyID inID, UInt32 inDataSize, const void *inData ) {
    if ( inID == kAudioSessionProperty_AudioRouteChange )
    {
        NSDictionary *dic = (__bridge NSDictionary *)(inData);
        
        /* inData format:   dic:{   (string*)"ActiveAudioRouteDidChange_NewDetailedRoute"->(dic*)newDetailedRoute,
         (string*)"ActiveAudioRouteDidChange_OldDetailedRoute"->(dic*)oldDetailedRoute,
         
         (string*)"OutputDeviceDidChange_NewRoute"-> (string*)
         (string*)"OutputDeviceDidChange_OldRoute"-> (string*)
         (string*)"OutputDeviceDidChange_Reason"-> (string*)
         }
         DetailedRoute:{  "RouteDetailedDescription_Inputs"  ->
         "RouteDetailedDescription_Outputs" -> { "RouteDetailedDescription_PortType"
         -> (string*)"Headphones", "Speaker", ...}
         }
         */
        NSString *newPortType = [dic objectForKey:@"OutputDeviceDidChange_NewRoute"];
        
        
        /* Known values of route:
         "Headset"
         "Headphone"
         "Speaker"
         "SpeakerAndMicrophone"
         "HeadphonesAndMicrophone"
         "HeadsetInOut"
         "ReceiverAndMicrophone"
         "Lineout" 
         */
        if (newPortType.length>0)
        {
            if ([newPortType isEqualToString:@"Headset"]) {}
            else if ([newPortType isEqualToString:@"Headphone"]) {}
            else if ([newPortType isEqualToString:@"Speaker"])
            {
                //  When audio route change to "Speaker", the audio session will be paused
                //  Implement your code here to restart the movie player
                
            }
            else if ([newPortType isEqualToString:@"SpeakerAndMicrophone"]) {}
            else if ([newPortType isEqualToString:@"HeadphonesAndMicrophone"]) {}
            else if ([newPortType isEqualToString:@"HeadsetInOut"]) {}
            else if ([newPortType isEqualToString:@"ReceiverAndMicrophone"]) {}
            else if ([newPortType isEqualToString:@"Lineout"]) {}
        }
    }
}

@end
