//
//  Login.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 3/26/22.
//

import SwiftUI
import CoreData

struct Login: View {
    @State var loggedIn = false
    @Binding var isLoggedIn : Bool
    @State private var password = ""
    @State private var username = ""
    @State private var donger = ""
    @Binding var profile : [Individual]
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Login")) {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    Button("Login") {
                        login(username: username, password: password)
                    }
                }
                Text(donger)
            }
        }
    }


    func login(username: String, password: String) {
        print("Logging in")
        guard let url = URL(string: "https://echtbuch.com/api/token/"),
              let payload = "{\"username\": \"\(username)\", \"password\":\"\(password)\"}".data(using: .utf8) else
        {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //request.addValue("your_api_key", forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                donger = "Incorrect username or password"
                print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
            let JSON = try? JSONSerialization.jsonObject(with: data, options: [])
            let parsedDictionary = JSON as! [String: Any]
            guard parsedDictionary["access"] != nil else{
                print("OOPS")
                donger = "Incorrect username or password"
                return
            }
            //let access = parsedDictionary["access"] as! String
            //print(access)
            //access = parsedDictionary["access"] as! String
            donger = "Successfully logged in, \(username)."
            let url2 = URL(string: "https://echtbuch.com/individuals/")!
            request = URLRequest(url: url2)
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
                            isLoggedIn = true
                            profile = decodedLists.filter{
                                $0.user.username == username
                            }
                        }
                    }
                    else {
                        print("No Data")
                    }
                } catch {
                    print (error)
                }
            }.resume()
            
        }.resume()
        
    }
}


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(isLoggedIn: .constant(false), profile: .constant([Individual]()))
    }
}

