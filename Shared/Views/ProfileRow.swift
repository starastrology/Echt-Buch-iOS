//
//  ProfileRow.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 3/26/22.
//

import SwiftUI

struct ProfileRow: View {
    var profile: Individual
    @Binding var isLoggedIn : Bool
    var body: some View {
        VStack{
        HStack{
            AsyncImage(url: URL(string: "https://echtbuch.com\(profile.profilePic ?? "/static/blank-avatar.webp")")){ image in
                image.resizable().scaledToFit()
            } placeholder: {
                Color.white
            }
            .frame(width: 128, height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            Text(profile.firstName + " " + profile.lastName)
        }
            if isLoggedIn{
                ProgressView(value: (profile.compatibility ?? 100.0) / 100.0)
                if (profile.compatibility != nil){
                Text("\(String(format: "%.0f", profile.compatibility!))% compatibility")
                }
                else{
                    Text("100% compatibility")
                }
            }
        }
    }
}

struct ProfileRow_Previews: PreviewProvider {
    
    static var fetcher = UserFetcher(username: "admin")
    static var previews: some View {
        ProfileRow(profile: fetcher.profiles[0], isLoggedIn: .constant(false))
    
    }
}
