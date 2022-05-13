//
//  Friends.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 4/12/22.
//

import SwiftUI

struct Friends: View {
    @State var username : String
    @ObservedObject var fetcher = FriendFetcher(username: "")
    var selfProfile : Individual
    init(username : String, selfProfile: Individual){
        fetcher = FriendFetcher(username: username)
        self.username = username
        self.selfProfile = selfProfile
    }
    var body: some View {
        NavigationView{
        List{
            ForEach(fetcher.profiles, id: \.id) {profile in
                NavigationLink {
                    ProfileDetail(profile: profile, loggedIn: .constant(true), isSelf: .constant(false), username: profile.user.username, selfProfile: selfProfile)
                }
                label: {
                    ProfileRow(profile: profile, isLoggedIn: .constant(true))
                }
            }
        }.navigationTitle("Friends")
        }
    }
}

    public class FriendFetcher: ObservableObject {

        @Published var profiles = [Individual]()
        
        init(username: String){
            load(username: username)
        }

        func load(username: String) {
                    
                        let url2 = URL(string: "https://echtbuch.com/friends/?username=\(username)")!
                        let request = URLRequest(url: url2)
                        //request.addValue("Bearer " + access, forHTTPHeaderField: "Authorization")
                        URLSession.shared.dataTask(with: request) {(data,response,error) in
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
                                        self.profiles = decodedLists
                        
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

struct Friends_Previews: PreviewProvider {
    static var previews: some View {
        let fetcher = UserFetcher(username: "admin")
        Friends(username: "admin", selfProfile: fetcher.profiles[0])
    }
}
