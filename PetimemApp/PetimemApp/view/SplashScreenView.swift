//
//  SplashScreenView.swift
//  PetimemApp
//
//  Created by Yan Deng on 2024-03-26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive{
            LoginView()
        }else{
            ZStack{
                Color("bgColor")
                    .ignoresSafeArea()
                VStack{
                    Image("logoText")
                        .resizable()
                        .frame(width: 280, height: 170)
                    Rectangle()
                        .frame(width: 300, height: 280)
                        .foregroundColor(.white.opacity(0.01))
                    Image("splashScreenText")
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
       
    }
}

#Preview {
    SplashScreenView()
}
