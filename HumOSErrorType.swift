//
//  HumOSError.swift
//  HumOSSDK
//
//  Created by Ratna.Saripalli on 3/29/16.
//  Copyright © 2016 Ratna.Saripalli. All rights reserved.
//

import Foundation

/**
 Defines all HumOS specific errors.
 */
public enum HumOSErrorType:Int, ErrorType {
    
    case SDKNotInitialized
    case SetupConfigFailed
    case PhoneNumberRequired
    case CountryCodeRequired
    case invalidEmail
    case invalidPhoneNumber
    case FirstNameRequired
    case LastNameRequired
    case UserAlreadyExists
    case CouldNotCreateUser
    case UserNotFound
    case IncorrectAppType
    case CouldNotLoginUser
    case UserNotActivated
    case UserDoesNotExist
    case CouldNotSendVerificationCode
    case IncorrectVerficationCode
    case RegistrationError
    case ErrorCodeExpired
    case CouldNotFetchUserDetails
    case SessionExpired
    case LogPathNotSet
    case NoChannelsFoundForMessage
    case UserNotLoggedIn
    case EmptyPassword
    case UserNotVerified

    case ServerError
    case ServerConnectionError
    
    
    func localizedUserInfo() -> [String: String] {
        var localizedDescription: String = ""
        var localizedFailureReasonError: String = ""
        var localizedRecoverySuggestionError: String = ""
        
        switch self {
        case SDKNotInitialized:
            localizedDescription = NSLocalizedString("Error.SDKNotInitialized", comment: "SDK has not been initialized")
            break
        case UserAlreadyExists:
            localizedDescription = NSLocalizedString("Error.UserAlreadyExists", comment: "User already exists")
            break
        case ErrorCodeExpired:
            localizedDescription = NSLocalizedString("Error.ErrorCodeExpired", comment: "Error code expired. Please generate a new code")
            break
        case IncorrectVerficationCode:
            localizedDescription = NSLocalizedString("Error.IncorrectVerficationCode", comment: "Incorrect Verification code. Please enter the correct code")
            break
        case RegistrationError:
            localizedDescription = NSLocalizedString("Error.RegistrationError", comment: "Unknown Registration error")
            break
        case CouldNotLoginUser:
            localizedDescription = NSLocalizedString("Error.CouldNotLoginUser", comment: "Login error")
            break
        case .NoChannelsFoundForMessage:
            localizedDescription = NSLocalizedString("could not build channels for messaging", comment: "Login error")
            break
        case .UserNotLoggedIn:
            localizedDescription = NSLocalizedString("User not logged in", comment: "Login error")
            break
        case .EmptyPassword:
            localizedDescription = NSLocalizedString("Password cannot be empty", comment: "Reset Password error")
            break
        case .UserNotVerified:
            localizedDescription = NSLocalizedString("User not verified. Please verify before resetting password", comment: "Reset Password error")
            break

        default:
            localizedDescription = NSLocalizedString("Error.Unknown", comment: "Unknown error")

        }
        return [
            NSLocalizedDescriptionKey: localizedDescription,
            NSLocalizedFailureReasonErrorKey: localizedFailureReasonError,
            NSLocalizedRecoverySuggestionErrorKey: localizedRecoverySuggestionError
        ]
    }
    
}
