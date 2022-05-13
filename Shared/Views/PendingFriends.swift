//
//  PendingFriends.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 5/4/22.
//

import SwiftUI

struct PendingFriends: View {
    @State var username : String
    @ObservedObject var fetcher = PendingFriendFetcher(username: "")
    var selfProfile : Individual
    init(username : String, selfProfile: Individual){
        fetcher = PendingFriendFetcher(username: username)
        self.username = username
        self.selfProfile = selfProfile
    }
    var body: some View {
        NavigationView{
        List{
            ForEach(fetcher.pending, id: \.id) {profile in
                NavigationLink {
                    ProfileDetail(profile: profile, loggedIn: .constant(true), isSelf: .constant(false), username: profile.user.username, selfProfile: selfProfile)
                }
                label: {
                    HStack{
                        ProfileRow(profile: profile, isLoggedIn: .constant(true))
                        Button("Accept"){
                            
                        }
                        Button("Deny"){
                            
                        }
                    }
                }
            }
            }.navigationTitle("Pending Friend Requests")
        }
    }
}
    public class PendingFriendFetcher: ObservableObject {

        @Published var pending = [Individual]()
        
        init(username: String){
            load(username: username)
        }

        func load(username: String) {
                    
                       
            let url = URL(string: "https://echtbuch.com/friends_pending/?username=\(username)")!
            let request2 = URLRequest(url: url)
            //request.addValue("Bearer " + access, forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: request2) {(data,response,error) in
                do {
                    if let d = data {
                        if let json = try? JSONSerialization.jsonObject(with: d, options: .mutableContainers),
                           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                            print(String(decoding: jsonData, as: UTF8.self))
                        } else {
                            print("json data malformed")
                        }
                        let decodedLists = try JSONDecoder().decode([Individual].self, from: d)
                        DispatchQueue.main.async {
                            self.pending = decodedLists
            
                        }
                    }
                    else {
                        print("No Data")
                    }
                } catch {
                    print (error)
                }
            }.resume()
        }
    }

struct PendingFriends_Previews: PreviewProvider {
    static var previews: some View {
        let fetcher = UserFetcher(username: "admin")
        PendingFriends(username: "admin", selfProfile: fetcher.profiles[0])
    }
}
