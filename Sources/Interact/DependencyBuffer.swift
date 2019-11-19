//
//  DependencyBuffer.swift
//  
//
//  Created by Kieran Brown on 11/18/19.
//

import Foundation
import SwiftUI



@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
public struct GestureDependencyBuffer<Modifier: ViewModifier>: ViewModifier {
    @State var offset: CGSize = .zero
    @State var dragState: TranslationState = DragGestureModel.DragState.inactive
    @State var size: CGSize = CGSize(width: 100, height: 100)
    @State var magnification: CGFloat = 1
    @State var topLeadingState: CGSize = .zero
    @State var bottomLeadingState: CGSize = .zero
    @State var topTrailingState: CGSize = .zero
    @State var bottomTrailingState: CGSize = .zero
    @State var angle: CGFloat = 0
    @State var rotation: CGFloat = 0
    @State var isSelected: Bool = false
    var initialSize: CGSize
    
    var modifier: (Binding<CGSize>, Binding<TranslationState>, Binding<CGSize>, Binding<CGFloat>, Binding<CGSize>, Binding<CGSize>, Binding<CGSize>, Binding<CGSize>,  Binding<CGFloat>, Binding<CGFloat>, Binding<Bool>) -> Modifier
    
    public init(initialSize: CGSize, modifier: @escaping (_ offset: Binding<CGSize>, _ dragState: Binding<TranslationState>, _ size: Binding<CGSize>, _ magnification: Binding<CGFloat>, _ topLeadingState: Binding<CGSize>, _ bottomLeadingState: Binding<CGSize>, _ topTrailingState: Binding<CGSize>, _ bottomTrailingState: Binding<CGSize>,  _ angle: Binding<CGFloat>, _ rotation: Binding<CGFloat>, _ isSelected: Binding<Bool>) -> Modifier) {
        
        self.modifier = modifier
        self.initialSize = initialSize
        
    }
    
    public func body(content: Content) -> some View {
         content
            .frame(width: size.width, height: size.height)
            .background(GeometryReader { proxy in
                Rectangle().foregroundColor(.clear)
                    .onAppear {
                        self.size = self.initialSize
                }
            })
        .modifier(modifier($offset,
                           $dragState,
                           $size,
                           $magnification,
                           $topLeadingState,
                           $bottomLeadingState,
                           $topTrailingState,
                           $bottomTrailingState,
                           $angle,
                           $rotation,
                           $isSelected))
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0 , tvOS 13.0, *)
extension View {
    func dependencyBuffer<Modifier: ViewModifier>(initialSize: CGSize, modifier: @escaping (Binding<CGSize>, Binding<TranslationState>, Binding<CGSize>, Binding<CGFloat>, Binding<CGSize>, Binding<CGSize>, Binding<CGSize>, Binding<CGSize>,  Binding<CGFloat>, Binding<CGFloat>, Binding<Bool>) -> Modifier) -> some View {
        self.modifier(GestureDependencyBuffer(initialSize: initialSize, modifier: modifier))
    }
}
