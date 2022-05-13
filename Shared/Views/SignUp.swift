//
//  SignUp.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 3/2/22.
//

import SwiftUI
import CoreLocation


struct SignUp: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    @State private var pob: String = ""
    @State private var lastName: String = ""
    @State private var firstName: String = ""
    @State private var birthDate = Date()
    @State private var gender = "Male"
    @Binding var profile : [Individual]
    @Binding var loggedIn : Bool
    @State private var errorMessage : String = ""
    @State private var allowAlert : Bool = false
    var body: some View {
            VStack {
                Form {
                    Section(header: Text("Sign Up")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        DatePicker(selection: $birthDate, label: { Text("Time of birth") })
                        TextField("Where you were born", text: $pob)
                        Picker(selection: $gender, label: Text("Gender")) {
                            Text("Male").tag(0)
                            Text("Female").tag(1)
                        }.pickerStyle(.segmented)
                        TextField("Username", text: $username)
                        SecureField("Password", text: $password)
                        SecureField("Password Confirmation", text: $passwordConfirmation)
                        Button("Sign Up") {
                            signup(username: username, password: password, passwordConfirmation: passwordConfirmation, firstName: firstName, lastName: lastName, birthDate: birthDate, gender: gender, pob: pob)
                        }
                        .disabled(username.isEmpty || password.isEmpty || pob.isEmpty || gender.isEmpty || passwordConfirmation.isEmpty || firstName.isEmpty || lastName.isEmpty)
                    }
                }.alert(isPresented: $allowAlert){
                    Alert(title: Text("Try Again"), message: Text(errorMessage), dismissButton: .default(Text("Got it!")))
                }
            }
    }
    
    func signup(username: String, password: String, passwordConfirmation: String, firstName: String, lastName: String, birthDate: Date, gender: String, pob: String){
        // GET LATITUDE AND LONGITUDE FROM POB
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(pob) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lng = placemark?.location?.coordinate.longitude
        
        let url = URL(string: "https://echtbuch.com/api/process_signup/")!
        var request = URLRequest(url: url)
            let params = ["username": username, "password": password, "password_confirmation": passwordConfirmation, "first_name": firstName, "last_name": lastName, "gender": gender, "lat": lat ?? 40.7 as Any, "lng": lng ?? -74.0 as Any, "pob": pob, "dob": birthDate] as [String : Any]
        
        let jsonString = params.reduce("") { "\($0)\($1.0)=\($1.1)&" }.dropLast()
        let jsonData = jsonString.data(using: .utf8, allowLossyConversion: false)!
        let payload = jsonData

        request.httpMethod = "POST"
        //request.addValue("your_api_key", forHTTPHeaderField: "x-api-key")
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = payload
            
        //request.addValue("Bearer " + access, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                if let d = data {
                    guard error == nil else {
                        print(error!.localizedDescription); return }
                    guard let data = data else { print("Empty data"); return }
                    let JSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    let parsedDictionary = JSON as! [String: Any]
                    guard parsedDictionary["error"] == nil else{
                        errorMessage = parsedDictionary["error"] as! String
                        allowAlert = true
                        return
                    }
                    let url2 = URL(string: "https://echtbuch.com/individuals/")!
                    let request2 = URLRequest(url: url2)
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
                                    loggedIn = true
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
                }
            }
        }.resume()
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(profile: .constant([Individual]()), loggedIn: .constant(false))
    }
}
