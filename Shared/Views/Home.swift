//
//  Home.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 3/26/22.
//

import SwiftUI

struct Home: View {
    @State var loggedIn = false
    @State var profile = [Individual]()
    @State var selfProfile = [Individual]()
    let backgroundGradient = LinearGradient(
        colors: [Color.green, Color.blue],
        startPoint: .top, endPoint: .bottom)
    var body: some View {
        if !loggedIn{
            NavigationView {
                VStack{
                    List{
                        NavigationLink("Sign Up", destination: SignUp(profile: $profile, loggedIn: $loggedIn))
                        NavigationLink("Login", destination: Login(isLoggedIn: $loggedIn, profile: $profile))
                        NavigationLink("Browse",
                                       destination:ProfileList(username: "", isLoggedIn: .constant(false)))
                    }.navigationTitle("Echt Buch")
                    CircleImage(image: Image("eb")).offset(y: -100)
                }.background(backgroundGradient)
            }
        }
        else{
            ProfileDetail(profile: profile[0], loggedIn: $loggedIn, isSelf: .constant(true), username: profile[0].user.username, selfProfile: profile[0])
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
