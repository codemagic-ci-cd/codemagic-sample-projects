//
//  ContentView.swift
//  wand
//
//  Created by Kevin Suhajda on 2021. 03. 04..
//

import SwiftUI

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}



func getVal(val: String) -> String {
 
      guard let filePath = Bundle.main.path(forResource: "Strings", ofType: "plist") else {
        fatalError("Couldn't find file 'Strings.plist'.")
      }
      let plist = NSDictionary(contentsOfFile: filePath)
      guard let value = plist?.object(forKey: val) as? String else {
        fatalError("Couldn't find key in 'Strings.plist'.")
      }
      return value
    
}

struct ContentView: View {
    @State private var showingAlert = false
    var body: some View {

        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0, green: 0.6, blue: 1), Color(red: 0, green: 0, blue: 0.4)]), startPoint: .top, endPoint: .bottom)
               .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
            VStack {
                
                
                Text(getVal(val: "Heading"))
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets.init(top: 20, leading: 0, bottom: 0.25, trailing: 0))
                Text(getVal(val: "Subheading"))
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                Spacer()
                
                Image("hero").resizable().scaledToFit().frame(width: 300.0, height: 300.0)
                Spacer()

                
                Button(action: {
                    showingAlert = true
                }){
                    Text("View Details")

                        .font(.subheadline)
                        .padding()
                        .foregroundColor(.white)
     
                }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text(getVal(val: "Title")), message: Text(getVal(val: "Message")), dismissButton: .default(Text("OK")))}
                        }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
