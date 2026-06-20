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
    var aliasName: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var dateOfBirth: String = ""
    var otpCode: String = ""
    var idNumber: String = ""
    var signupRewardAmount: Double = 0.0
    
    var countryOfResidence: String = "Albania"
    var zipCode: String = ""
    var streetName: String = ""
    var floorUnit: String = ""
    var passcode: String = ""
    var isCitizen: Bool = true
    var verificationMethod: String = "" // "singpass" vs "documents"
    var selectedDocType: String = "" // "id" vs "passport"
    
    var fullName: String {
        if firstName.isEmpty && lastName.isEmpty {
            return ""
        }
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
