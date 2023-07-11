//
//  ContentView.swift
//  HackIllinoisSystemsDemo
//
//  Created by Dev Patel on 7/3/23.
//

import SwiftUI
import Foundation

//the entire object including all users
struct Profile: Codable {
    let profiles: [Attendee]
}
//each individual attendee
struct Attendee: Codable,Identifiable{
    let id: String
    let points: Int
    let discord: String
}

struct ContentView: View {
    @State var users: Profile =  Profile(profiles: [])//contains all of the users
    var  numRankings = [5, 10, 20, 50,100]//all options for the dropdown view
    @State private var selectedRanking = 100//currently selected option

    var body: some View {
        VStack {
            HStack{
                Text("LEADERBOARD")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(alignment: .leading)
                Spacer()
                Picker("", selection: $selectedRanking) {
                    ForEach(numRankings, id: \.self) {
                        Text("\($0)")

                    }
                }
                .frame(alignment: .trailing)
                .buttonStyle(.bordered)
                .accentColor(.white)

            }
            .padding()
            
            List {
                ForEach(Array(zip(1...selectedRanking, users.profiles)),id: \.1.id) {number, user in
                    HStack{
                        Text("\(number). \(user.discord)")
                            .font(.system(size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text("\(user.points)")
                            .frame(maxWidth: 65, alignment: .trailing)

                    }
                }
            }.cornerRadius(8)
            }
        .background(Image("Background"))
        .onAppear {
            apiCall().getUsers(selectedNum: selectedRanking) { (users) in
                self.users = users
            }
        }

        .padding()
    }
}

class apiCall{
    func getUsers(selectedNum:(Int),completion:@escaping (Profile) -> ()) {//sends the GET request to the HackIllinois API
        guard let url = URL(string:"https://api.hackillinois.org/profile/leaderboard/?limit=\(selectedNum)") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let users = try! JSONDecoder().decode(Profile.self, from: data!)
            
            DispatchQueue.main.async {
                completion(users)
            }
        }
        .resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
