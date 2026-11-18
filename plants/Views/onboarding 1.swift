//
//  onboarding 1.swift
//  plants
//
//  Created by jood on 29/05/1448 AH.
//

import SwiftUI

// MARK: - App colors
extension Color {
    static let plantGreen = Color(red: 0.25, green: 0.47, blue: 0.38)
}
// static let = شي ثابت ومشترك، أعرّفه مرة وحدة وأستخدمه بكل التطبيق
// MARK: - Onboarding screen
struct Onboarding_1_View: View {
    @State private var showReminderSheet = false
   
    var body: some View {
        // the page content: everything inside shows on screen
//MARK: start of stack
        ZStack {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()// covers the whole screen, even behind the clock & battery

            
//MARK: start of vstack inside of zstack
            VStack(alignment: .leading, spacing: 0) {
                Text("My Plants 🌱")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.primary)
                
        //the color of the text
                
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    .padding(.bottom, 12)
                // padding = empty space around a view
                // (like the foam inside a box that keeps things away from the walls)
                // it pushes the view away from the screen edges or from other views
              
                Spacer()  // flexible empty pushes content to the middle
                
                VStack(spacing: 0) {
                    Image("plant1")
                        .resizable() // allows the image to change size
                        .scaledToFit()// keeps its shape (doesn't stretch)
                        .frame(width: 150, height: 220)
                        .padding(.bottom, 48)
                    Text("Start your plant journey!")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(.primary) // أسود/أبيض حسب الوضع
                        .padding(.bottom, 24)

                    Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center) // يرتب الاسطر

                        .padding(.horizontal, 48)
                }
                .frame(maxWidth: .infinity)
                Spacer()
                Button {
                   
                    showReminderSheet = true
                    
                    // ACTION: turn the switch on → reminder sheet opens
                } label: {
                   
                    Text("Set Plant Reminder")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 280, height: 44)
                        .glassEffect(.regular.tint(.plantGreen.opacity(0.6)).interactive(), in: .capsule)
                    // background = put something BEHIND the text
                    
                        .overlay(
                            Capsule().stroke(.white.opacity(0.25), lineWidth: 1)
                            
                        ) // green color, Capsule = is the button pill shape
                      
                    
                   
                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
        }
     
       
        .sheet(isPresented: $showReminderSheet) {
            SetReminderView()
        }
    }
}

// MARK: - Previews
// Two previews so you can see both modes side by side in Xcode.
#Preview("Dark") {
    Onboarding_1_View()
        .environment(ReminderStore())
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    Onboarding_1_View()
        .environment(ReminderStore())
        .preferredColorScheme(.light)
}
