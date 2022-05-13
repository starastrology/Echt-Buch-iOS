//
//  ProfileDetail.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 3/26/22.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
}

struct ProfileDetail: View {
    @State private var image = UIImage()
    @State var isModal: Bool = false
    @State var isModal2: Bool = false
    @State var isModal3: Bool = false
    @State private var showingImagePicker = false
    var profile: Individual
    @Binding var isLoggedIn : Bool
    @Binding var isSelf : Bool
    var selfProfile : Individual
    var friendRequestDisabled = true
    var sunSign = Character("\u{24}")
    var moonSign = Character("\u{24}")
    var risingSign = Character("\u{24}")
    var mercurySign = Character("\u{24}")
    var venusSign = Character("\u{24}")
    var marsSign = Character("\u{24}")
    var jupiterSign = Character("\u{24}")
    var date = Date()
    var dob = ""
    let dateFormatter = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    let dateFormatter2 = DateFormatter()
    @State var postText : String = ""
    @ObservedObject var fetcher = PostFetcher(username: "")
    @ObservedObject var f = F()
    init(profile: Individual, loggedIn: Binding<Bool>, isSelf: Binding<Bool>, username: String, selfProfile : Individual){
        self._isSelf = isSelf
        self.profile = profile
        self.selfProfile = selfProfile
        self.sunSign = Int(profile.sunSign.unicodeValue, radix: 16).map{ Character(UnicodeScalar($0)!) }!
        self.moonSign = Int(profile.moonSign.unicodeValue, radix: 16).map{ Character(UnicodeScalar($0)!) }!
        self.risingSign = Int(profile.risingSign.unicodeValue, radix: 16).map{ Character(UnicodeScalar($0)!) }!
        self.mercurySign = Int(profile.mercurySign.unicodeValue, radix: 16).map{ Character(UnicodeScalar($0)!) }!
        self.venusSign = Int(profile.venusSign.unicodeValue, radix: 16).map{ Character(UnicodeScalar($0)!) }!
        self.marsSign = Int(profile.marsSign.unicodeValue, radix: 16).map{ Character(UnicodeScalar($0)!) }!
        self.jupiterSign = Int(profile.jupiterSign.unicodeValue, radix: 16).map{ Character(UnicodeScalar($0)!) }!
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        self.date = dateFormatter.date(from:profile.dob)!
        dateFormatterPrint.dateFormat = "MMMM d, yyyy HH:mm"
        self.dob = dateFormatterPrint.string(from: self.date)
        self._isLoggedIn = loggedIn
        self.fetcher = PostFetcher(username: username)
        self.postText = "Enter text here"
        self.f = F(selfProfile: self.profile, profile: self.selfProfile)
    }
    var body: some View {
        
        Section(header:
                    (
                        HStack{
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
                    ),
                footer: (
                    HStack{
                        if isLoggedIn{
                            NavigationLink(destination: ProfileList(username: profile.user.username, isLoggedIn: $isLoggedIn), label:{Text("Browse")})
                            
                            Divider()
                            Button("Logout"){
                                self.isLoggedIn = false
                            }
                        }
                    }.frame(height: 50)
                ))
        {
            VStack(alignment: .leading) {
                ScrollView{
                    Text(profile.firstName + " " + profile.lastName)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    if isSelf{
                        Button(action: {
                            showingImagePicker = true
                        }){
                            AsyncImage(url: URL(string: "https://echtbuch.com\(profile.profilePic ?? "/static/blank-avatar.webp")")){ image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.white
                            }
                            .padding(.horizontal)
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        }.sheet(isPresented: $showingImagePicker) {
                            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                        }
                    }
                    else{
                        AsyncImage(url: URL(string: "https://echtbuch.com\(profile.profilePic ?? "/static/blank-avatar.webp")")){ image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            Color.white
                        }
                        .padding(.horizontal)
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    Text("Born \(self.dob) in \(self.profile.placeOfBirth.name)")
                    List{
                        HStack{
                            Label("Gender", systemImage: "crown")
                            Spacer()
                            Text(profile.gender)
                        }
                        HStack{
                            Label("Sun", systemImage: "sun.max")
                            Spacer()
                            Text(profile.sunSign.sign)
                            Divider()
                            Text("\(sunSign)" as String)
                        }
                        HStack{
                            Label("Moon", systemImage: "moon")
                            Spacer()
                            Text(profile.moonSign.sign)
                            Divider()
                            Text("\(moonSign)" as String)
                        }
                        HStack{
                            Label("Ascendant", systemImage: "sunrise")
                            Spacer()
                            Text(profile.risingSign.sign)
                            Divider()
                            Text("\(risingSign)" as String)
                        }
                        HStack{
                            Label("Mercury", systemImage: "brain")
                            Spacer()
                            Text(profile.mercurySign.sign)
                            Divider()
                            Text("\(mercurySign)" as String)
                        }
                        HStack{
                            Label("Venus", systemImage: "heart")
                            Spacer()
                            Text(profile.venusSign.sign)
                            Divider()
                            Text("\(venusSign)" as String)
                        }
                        HStack{
                            Label("Mars", systemImage: "bolt")
                            Spacer()
                            Text(profile.marsSign.sign)
                            Divider()
                            Text("\(marsSign)" as String)
                        }
                        HStack{
                            Label("Jupiter", systemImage: "location")
                            Spacer()
                            Text(profile.jupiterSign.sign)
                            Divider()
                            Text("\(jupiterSign)" as String)
                        }
                    }.scaledToFill()
                    if isLoggedIn{
                        VStack{
                            if !isSelf{
                                Divider()
                                Button("Friend Request \(self.profile.firstName)"){
                                    
                                }.disabled(!self.f.friend.isEmpty)
                            }
                            if isSelf{
                                Divider()
                                Button("Check-in"){
                                    
                                }
                            }
                            if isLoggedIn{
                                Divider()
                                Button("Pending Friend Requests"){
                                    self.isModal = true
                                }.sheet(isPresented:$isModal, content:{
                                    PendingFriends(username: profile.user.username, selfProfile: selfProfile)})
                                Divider()
                                Button("Friends"){
                                    self.isModal3 = true
                                }.sheet(isPresented:$isModal3, content:{
                                    Friends(username: profile.user.username, selfProfile: selfProfile)})
                            }
                            Divider()
                            ZStack{
                                TextEditor(text: $postText)
                                Text(postText).opacity(0).padding(.all, 8)
                            }
                            Divider()
                            Button("Post"){
                                postOnWall()
                            }.disabled(postText.count == 0)
                        }
                    }
                    List{
                        ForEach(fetcher.posts, id: \.id) {post in
                            HStack{
                                VStack{
                                    Text(dateFormatterPrint.string(from: dateFormatter2.date(from: post.dateTime)!))
                                    NavigationLink( destination: ProfileDetail(profile: post.fromInd, loggedIn: $isLoggedIn, isSelf: $isSelf, username: post.fromInd.user.username, selfProfile: selfProfile),
                                                    label:{
                                        AsyncImage(url: URL(string: "https://echtbuch.com\(post.fromInd.profilePic ?? "/static/blank-avatar.webp")")){ image in
                                            image.resizable().scaledToFit()
                                        } placeholder: {
                                            Color.white
                                        }
                                        .frame(width: 128, height: 128)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                    })
                                }
                                Spacer()
                                Text(post.text)
                            }
                        }
                    }.scaledToFill()
                    //if self.profile.lastSeen{
                    //Text("Last seen in \(self.profile.lastSeen)")
                    //}
                }
            }
        }.navigationTitle(profile.firstName + " " + profile.lastName).navigationBarTitleDisplayMode(.inline)
    }
    
    func postOnWall(){
        
        let url = URL(string: "https://echtbuch.com/api/post_on_wall/")!
        var request = URLRequest(url: url)
        let params = ["to_ind": profile.id, "from_ind": selfProfile.id, "text": postText] as [String : Any]
        postText = ""
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
                    if let json = try? JSONSerialization.jsonObject(with: d, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        print(String(decoding: jsonData, as: UTF8.self))
                    } else {
                        print("json data malformed")
                    }
                    let decodedLists = try JSONDecoder().decode(Post.self, from: d)
                    DispatchQueue.main.async {
                        fetcher.posts.insert(decodedLists, at: 0)
                    }
                }
            }
            catch {
                print (error)
            }
        }.resume()
    }
}

public class F: ObservableObject {

    @Published var friend = [Friendship]()
    
    init(){
        
    }
    
    init(selfProfile : Individual, profile: Individual)
    {
        load(selfProfile: selfProfile, profile: profile)
    }

    func load(selfProfile: Individual, profile: Individual) {
            let url2 = URL(string: "https://echtbuch.com/friends/?username=\(selfProfile.user.username)&friend=\(profile.user.username)")!
            print(url2)
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
                        let decodedLists = try JSONDecoder().decode(Friendship.self, from: d)
                        DispatchQueue.main.async {
                            self.friend = [decodedLists]
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




public class PostFetcher: ObservableObject {
    @Published var posts = [Post]()
    init(username: String){
        load(username: username)
    }
    func load(username: String) {
        if username == ""{
            return
            
        }
        let url2 = URL(string: "https://echtbuch.com/posts/?username=\(username)")!
        let request = URLRequest(url: url2)
        //request.addValue("Bearer " + access, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {(data,response,error) in
            do {
                if let d = data {
                    if let json = try? JSONSerialization.jsonObject(with: d, options: .mutableContainers),
                       let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                        //print(String(decoding: jsonData, as: UTF8.self))
                        let decodedLists = try JSONDecoder().decode(Array<Post>.self, from: jsonData)
                        DispatchQueue.main.async {
                            self.posts = decodedLists
                        }
                    } else {
                        print("json data malformed")
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


struct ProfileDetail_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let fetcher = UserFetcher(username: "admin")
        ProfileDetail(profile: fetcher.profiles[0], loggedIn: .constant(false), isSelf: .constant(true), username: "admin", selfProfile: fetcher.profiles[0])
    }
}

