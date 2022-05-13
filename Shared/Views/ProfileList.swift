//
//  ProfileList.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 3/26/22.
//

import SwiftUI

struct ProfileList: View {
    @State var search = ""
    @State var username : String
    @ObservedObject var fetcher = UserFetcher()
    @Binding var isLoggedIn : Bool
    init(username: String, isLoggedIn: Binding<Bool>){
        self.username = username
        self._isLoggedIn = isLoggedIn
        self.fetcher = UserFetcher(username: username)
        self.search = ""
    }
    var body: some View {
        HStack{
        Label("", systemImage: "magnifyingglass")
        TextField("Search", text: $search)
        Button("Search"){
        }
        }
            List{
                ForEach(fetcher.profiles, id: \.id) {profile in
                    NavigationLink {
                        ProfileDetail(profile: profile, loggedIn: $isLoggedIn, isSelf: .constant(false), username: profile.user.username, selfProfile: profile)
                    }
                    label: {
                        ProfileRow(profile: profile, isLoggedIn: $isLoggedIn)
                    }
            }
        }
    }
}

struct ProfileList_Previews: PreviewProvider {
    static var previews: some View {
        ProfileList(username: "admin", isLoggedIn: .constant(false))
    }
}

public class UserFetcher: ObservableObject {

    @Published var profiles = [Individual]()
    
    init()
    {
    
    }
    
    init(username: String){
        load(username: username)
    }

    func load(username: String) {
                /*guard let url = URL(string: "https://echtbuch.com/api/token/"),
                    let payload = "{\"username\": \"admin\", \"password\":\"bungals.1\"}".data(using: .utf8) else
                {
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                //request.addValue("your_api_key", forHTTPHeaderField: "x-api-key")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = payload*/

                //URLSession.shared.dataTask(with: request) { (data, response, error) in
                //    guard error == nil else { print(error!.localizedDescription); return }
                //    guard let data = data else { print("Empty data"); return }

                //    let JSON = try? JSONSerialization.jsonObject(with: data, options: [])
                //    let parsedDictionary = JSON as! [String: Any]
                //    let access = parsedDictionary["access"] as! String
                    var url2 = URL(string: "https://echtbuch.com/individuals/")!
                    if !username.isEmpty{
                        url2 = URL(string: "https://echtbuch.com/individuals/?username=\(username)")!
                    }
                    let request = URLRequest(url: url2)
               //     request.addValue("Bearer " + access, forHTTPHeaderField: "Authorization")
                    URLSession.shared.dataTask(with: request) {(data,response,error) in
                        do {
                            if let d = data {
                                if let json = try? JSONSerialization.jsonObject(with: d, options: .mutableContainers),
                                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                                    //print(String(decoding: jsonData, as: UTF8.self))
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
             //   }.resume()
    }
}

