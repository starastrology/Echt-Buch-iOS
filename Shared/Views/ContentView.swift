//
//  ContentView.swift
//  Shared
//
//  Created by Daniel Frecka on 3/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var splashScreen  = true
    var body: some View {
        /*ZStack{
                   Group{
                     if splashScreen {
                         SplashScreen()
                      }
                     else{*/
                         Home()
                          /* }
                       }
                      .onAppear {
                         DispatchQueue
                              .main
                              .asyncAfter(deadline:
                               .now() + 3) {
                          self.splashScreen = false
                         }
                       }
                   }*/
               }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
