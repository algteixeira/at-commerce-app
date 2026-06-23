//
//  TelaDeRegistro.swift
//  at-commerce-app
//
//  Created by Andre Luiz Goncalves Teixeira on 21/06/26.
//

import SwiftUI

struct RegisterRequest: Codable {
    let username: String
    let password: String
}

struct TelaDeRegistro: View {
    @State var usernameDigitado: String = ""
    @State var passwordDigitada: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Cadastre-se")
                .font(.title)
                .bold()
            Spacer()
            Image("sucuri_logo")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
            TextField("Digite seu usuário", text: $usernameDigitado)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .padding(.horizontal, 30)
            
            SecureField("Digite a senha", text: $passwordDigitada)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
            
            SecureField("Digite a senha novamente", text: $passwordDigitada)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 30)
            Spacer()
            
            
            Button(action: {
                registrar()
            }) {
                Text("Enviar")
                    .bold()
                    .frame(maxWidth: 150)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(75)
            }
            
            Spacer()
        }
    }
    
    func registrar() {
        guard let url = URL(string: "http://localhost:3000/register") else { return }
        let registerData = RegisterRequest(username: usernameDigitado, password: passwordDigitada)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(registerData)
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
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        dismiss()
                    }
                }
            }
            
            if let data = data, let stringResponse = String(data: data, encoding: .utf8) {
                print("Server response: \(stringResponse)")
            }
        }.resume()
    }
}

#Preview {
    TelaDeRegistro()
}
