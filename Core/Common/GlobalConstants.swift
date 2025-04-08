//
//  GlobalConstants.swift
//  Core
//
//  Created by Konstantin Lyashenko on 21.03.2025.
//

import Foundation

public enum GlobalConstants: String {

    // Logger

    case logSubsystem = "KV.Lyashenko.AutodocNews"
    case logCategory = "news"

    // AuthVC

    case greeting = "Добро пожаловать"
    case authInfoSubtitle = "Введите почту и пароль для входа в приложение"
    case email = "Email"
    case emailHint = "Пожалуйста, введите корректный email-адресс"
    case pass = "Пароль"
    case passHint = "Пароль должен содержать не менее 7 символов"
    case forgetPass = "Забыли пароль?"
    case login = "Войти"
    case or = "или"
    case google = "Google"
    case apple = "Apple"
    case notAccaunt = "Нет аккаунта?"

    // Error

    case firebaseNotConfigured = "Firebase не настроен"
    case googleSignInFailed = "Не удалось выполнить вход через Google"
    case invalidAppleToken = "Ошибка авторизации через Apple"
}
