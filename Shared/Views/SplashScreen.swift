//
//  SplashScreen.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 4/13/22.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        CircleImage(image: Image("eb"))
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
