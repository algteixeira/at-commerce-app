//
//  ContentView.swift
//  at-commerce-app
//
//  Created by Andre Luiz Goncalves Teixeira on 21/06/26.
//

import SwiftUI

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct ContentView: View {
    @State var usernameDigitado: String = ""
    @State var passwordDigitada: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("sucuri_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Spacer().frame(height:20)
                TextField("Digite seu usuário", text: $usernameDigitado)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                SecureField("Digite sua senha", text: $passwordDigitada)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    fazerLogin()
                }) {
                    Text("Entrar")
                        .bold()
                        .frame(maxWidth: 150)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(75)
                }
                
                Spacer()
                
                NavigationLink(destination: TelaDeRegistro()) {
                    Text("Não possui conta? Clique aqui")
                        .font(.footnote)
                        .underline()
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
    
    func fazerLogin() {
        guard let url = URL(string: "http://localhost:3000/login") else { return }
        
        let loginData = LoginRequest(username: usernameDigitado, password: passwordDigitada)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(loginData)
            request.httpBody = jsonData
        } catch {
            print("Error parsing data to JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("REQUEST ERROR: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Backend status code: \(httpResponse.statusCode)")
            }
            
            if let data = data, let stringResponse = String(data: data, encoding: .utf8) {
                print("Server response: \(stringResponse)")
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
