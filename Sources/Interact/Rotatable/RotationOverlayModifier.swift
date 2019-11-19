//
//  RotationOverlayModifier.swift
//  
//
//  Created by Kieran Brown on 11/19/19.
//

import Foundation
import SwiftUI 


@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public struct RotationOverlay<Handle: View, R: RotationModel>: ViewModifier {
    @ObservedObject var model: R
    @ObservedObject var rotationGestureModel: RotationGestureModel
    
    public init(size: Binding<CGSize>,
                magnification: Binding<CGFloat>,
                topLeadingState: Binding<CGSize>,
                bottomLeadingState: Binding<CGSize>,
                topTrailingState: Binding<CGSize>,
                bottomTrailingState: Binding<CGSize>,
                angle: Binding<CGFloat>,
                rotation: Binding<CGFloat>,
                isSelected: Binding<Bool>,
                rotationModel: R) {
        
        
        self.model = rotationModel
        self.rotationGestureModel = RotationGestureModel(angle: angle, rotation: rotation)
        
    }
    
    var currentAngle: CGFloat {
        rotationGestureModel.angle + model.gestureState.deltaTheta + rotationGestureModel.rotationState
    }
    
    public func body(content: Content) -> some View  {
        content
            .rotationEffect(Angle(radians: Double(currentAngle)))
            .gesture(rotationGestureModel.rotationGesture)
            .overlay(self.model.overlay)
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.2)) {
                    self.model.isSelected.toggle()
                }
        }
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public extension View {
    
    func rotatable<RotationHandle: View>(initialSize: CGSize , rotationType: RotationType<RotationHandle>) -> some View  {
            switch rotationType {
                
            case .normal(let handle):
                return AnyView(
                    self.dependencyBuffer(initialSize: initialSize,
                                          modifier: { (offset, dragState, size, magnification, topLeadingState, bottomLeadingState, topTrailingState, bottomTrailingState, angle, rotation, isSelected)   in
                                            RotationOverlay<RotationHandle, RotationOverlayModel>(
                                                    size: size,
                                                    magnification: magnification,
                                                    topLeadingState: topLeadingState,
                                                    bottomLeadingState: bottomLeadingState,
                                                    topTrailingState: topTrailingState,
                                                    bottomTrailingState: bottomTrailingState,
                                                    angle: angle,
                                                    rotation: rotation,
                                                    isSelected: isSelected,
                                                    rotationModel: RotationOverlayModel(size: size,
                                                                                        magnification: magnification,
                                                                                        topLeadingState: topLeadingState,
                                                                                        bottomLeadingState: bottomLeadingState,
                                                                                        topTrailingState: topTrailingState,
                                                                                        bottomTrailingState: bottomTrailingState,
                                                                                        angle: angle,
                                                                                        rotation: rotation,
                                                                                        isSelected: isSelected,
                                                                                        handle: handle))
                    })
                )
                
            case .spinnable(let model, let threshold, let handle):
                return AnyView(
                    self.dependencyBuffer(initialSize: initialSize, modifier: { (offset, dragState, size, magnification, topLeadingState, bottomLeadingState, topTrailingState, bottomTrailingState, angle, rotation, isSelected)  in
                        RotationOverlay<RotationHandle, SpinnableModel>(
                              size: size,
                              magnification: magnification,
                              topLeadingState: topLeadingState,
                              bottomLeadingState: bottomLeadingState,
                              topTrailingState: topTrailingState,
                              bottomTrailingState: bottomTrailingState,
                              angle: angle,
                              rotation: rotation,
                              isSelected: isSelected,
                              rotationModel: SpinnableModel<RotationHandle>(size: size,
                                                                            magnification: magnification,
                                                                            topLeadingState: topLeadingState,
                                                                            bottomLeadingState: bottomLeadingState,
                                                                            topTrailingState: topTrailingState,
                                                                            bottomTrailingState: bottomTrailingState,
                                                                            angle: angle,
                                                                            rotation: rotation,
                                                                            isSelected: isSelected,
                                                                            model: model,
                                                                            threshold: threshold,
                                                                            handle: handle))
                    })
                )
            }
        }
    }


