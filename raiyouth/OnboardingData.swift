//
//  OnboardingData.swift
//  raiyouth
//

import Foundation

struct OnboardingData {
    var intent: String? = "save money" // default intent
    var persona: String? = "explorer" // default persona
    var cardColor: String = "yellow"
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var dateOfBirth: String = ""
    var otpCode: String = ""
    var idNumber: String = ""
    var signupRewardAmount: Double = 0.0
    
    var fullName: String {
        if firstName.isEmpty && lastName.isEmpty {
            return ""
        }
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
