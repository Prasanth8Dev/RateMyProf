//
//  Constants.swift
//  RateMyProf
//
//  Created by Admin - iMAC on 07/01/25.
//

import Foundation


class Constants {
    static var loginResponse: LoginResponse?
    static var professorLoginResponse: ProfessorLoginResponse?
    
}

class APIService {
//    static let baseURL = "http://localhost/RateMyProf/API/"
    static let baseURL = "http://14.139.187.229:8081/rate_my_prof/"
    static let fetchTopRatedProfessor = baseURL + "TopRatedProfessor.php"
    static let login = baseURL + "LoginStudent.php"
    static let professorlogin = baseURL + "Login.php"
    static let fetchCounts = baseURL + "TotalCounts.php"
    static let adminLogin = baseURL + "LoginAdmin.php"
    static let getProfessorList = baseURL + "StudentRatingList.php"
    static let fetchProfessorRating = baseURL + "FetchProfessorRatings.php"
    static let fetchProfessorFeedback = baseURL + "FetchProfessorFeedback.php"
    static let postReviewForProfessor = baseURL + "RatingPage1.php"
    static let sendFeedBackForProfessor = baseURL + "UpdateFeedBack.php"
    static let studentProfile = baseURL + "StudentMyProfile.php"
    static let fetchStudentProfile = baseURL + "FetchStudent.php"
    static let blockStudent = baseURL + "SignUpStudent.php?action=block&RegNo="
    static let unBlockStudent = baseURL + "SignUpStudent.php?action=unblock&RegNo="
    static let deleteStudent = baseURL + "SignUpStudent.php?action=delete&RegNo="
    static let createProfessor = baseURL + "SignUp.php"
    static let createStudent = baseURL + "SignUpStudent.php"
    static let fetchProfessorDetails = baseURL + "FetchProfessorProfile.php"
}



