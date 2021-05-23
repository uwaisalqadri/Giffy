#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MaterialAvailability.h"
#import "MDCAvailability.h"
#import "MaterialBottomSheet.h"
#import "MDCBottomSheetController.h"
#import "MDCBottomSheetControllerDelegate.h"
#import "MDCBottomSheetPresentationController.h"
#import "MDCBottomSheetPresentationControllerDelegate.h"
#import "MDCBottomSheetTransitionController.h"
#import "MDCSheetState.h"
#import "UIViewController+MaterialBottomSheet.h"
#import "MaterialElevation.h"
#import "MDCElevatable.h"
#import "MDCElevationOverriding.h"
#import "UIColor+MaterialElevation.h"
#import "UIView+MaterialElevationResponding.h"
#import "MaterialShadowElevations.h"
#import "MDCShadowElevations.h"
#import "MaterialShadowLayer.h"
#import "MDCShadowLayer.h"
#import "MaterialShapeLibrary.h"
#import "MDCCornerTreatment+CornerTypeInitalizer.h"
#import "MDCCurvedCornerTreatment.h"
#import "MDCCurvedRectShapeGenerator.h"
#import "MDCCutCornerTreatment.h"
#import "MDCPillShapeGenerator.h"
#import "MDCRoundedCornerTreatment.h"
#import "MDCSlantedRectShapeGenerator.h"
#import "MDCTriangleEdgeTreatment.h"
#import "MaterialShapes.h"
#import "MDCCornerTreatment.h"
#import "MDCEdgeTreatment.h"
#import "MDCPathGenerator.h"
#import "MDCRectangleShapeGenerator.h"
#import "MDCShapedShadowLayer.h"
#import "MDCShapedView.h"
#import "MDCShapeGenerating.h"
#import "MDCShapeMediator.h"
#import "MaterialApplication.h"
#import "UIApplication+MDCAppExtensions.h"
#import "MaterialColor.h"
#import "UIColor+MaterialBlending.h"
#import "UIColor+MaterialDynamic.h"
#import "MaterialKeyboardWatcher.h"
#import "MDCKeyboardWatcher.h"
#import "MaterialMath.h"
#import "MDCMath.h"

FOUNDATION_EXPORT double MaterialComponentsVersionNumber;
FOUNDATION_EXPORT const unsigned char MaterialComponentsVersionString[];

