//
//  GlobalConstants.swift
//  Core
//
//  Created by Konstantin Lyashenko on 21.03.2025.
//

import Foundation

public enum GlobalConstants: String {

    // Common
    case cancel = "Отмена"
    case done = "Готово"

    // Logger

    case logSubsystem = "KV.Lyashenko.AutodocNews"
    case logCategory = "news"

    // Core

    case symbolRUB = "₽"
    case symbolUSD = "$"
    case symbolEUR = "€"

    // AuthVC

    case greeting = "Добро пожаловать"
    case authInfoSubtitle = "Введите почту и пароль для входа в приложение"
    case email = "Email"
    case emailHint = "Пожалуйста, введите корректный email-адресс"
    case pass = "Пароль"
    case passHint = "Пароль должен содержать не менее 7 символов"
    case forgetPass = "Забыли пароль?"
    case login = "Войти"
    case orLabel = "или"
    case google = "Google"
    case apple = "Apple"
    case notAccaunt = "Нет аккаунта?"

    // RegVC

    case register = "Регистрация"
    case regButton = "Зарегистрироваться"

    // RecPass
    case recPass = "Восстановить пароль"
    case recInfoSubtitle = "Введите почту, на которую отправим вам код"
    case confirm = "Подтвердить"

    // Added Expenses

    case addExpense = "Добавление расхода"
    case sum = "Сумма"
    case note = "Примечание (необязательно)"
    case add = "Добавить"

    // Creating Category

    case creatingCategory = "Создание категории"
    case categoryName = "Название категории"
    case create = "Создать"

    // Error

    case error = "Ошибка"
    case firebaseNotConfigured = "Firebase не настроен"
    case emailAuthFailed = "Ошибка авторизации"
    case googleSignInFailed = "Не удалось выполнить вход через Google"
    case invalidAppleToken = "Ошибка авторизации через Apple"
    case userNotFound = "Пользователь не найден"
    case wrongPassword = "Неверный пароль"
    case emailInUse = "Email уже используется"
    case invalidEmail = "Неверный формат email"

    // Alert

    case oups = "Упс..."
    case welcomeAlert = "Добро пожаловать!"
    case succesReg = "Регистрация прошла успешно"
    case mailSend = "Письмо для восстановления отправлено"
    case alertMessage = "Удалить запись?"
    case alertCancelButton = "Отменить"
    case deleteButton = "Удалить"
    case repeatAgain = "Попробойте снова"
    case okButton = "OK"
    case sendMessage = "Письмо отправлено"
    case checkMail = "Проверьте почту для сброса пароля"
    case alertPlaceholder = "Будем честны, будут деньги - будет фича!"

    // Calendar

    case yesterday = "Вчера"
    case today = "Сегодня"
    case tomorrow = "Завтра"

    // Analytics

    case analyticsTitle = "Аналитика"
    case analyticsTitleExpense = "Категории расходов"
    case analyticsTimePeriodDay = "День"
    case analyticsTimePeriodWeek = "Неделя"
    case analyticsTimePeriodMonth = "Месяц"
    case analyticsTimePeriodYear = "Год"
    case analyticsTimePeriodCustom = "Период"
    case analyticsCellCategoryOperation = "операция"
    case analyticsCellCategoryPercent = "%"

    case selectCategoryTitle = "Выберите категорию"
    case selectCategoryApply = "Выбрать"

    case categoryExpensesAddExpenses = "Добавить расход"
    case categoryExpensesCellNote = "Расход"
}
