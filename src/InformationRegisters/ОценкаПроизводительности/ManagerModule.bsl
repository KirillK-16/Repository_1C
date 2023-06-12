
Функция ЕстьЗаписи(Период, ИнформационнаяБаза, ПакетЦентраМониторинга) Экспорт
    
    Запрос = Новый Запрос;
    Запрос.Текст = "
    |ВЫБРАТЬ ПЕРВЫЕ 1
    |   ИнформационнаяБаза
    |ИЗ
    |   РегистрСведений.ОценкаПроизводительности
    |ГДЕ
    |   Период = &Период
    |   И ИнформационнаяБаза = &ИнформационнаяБаза
    |   И ПакетЦентраМониторинга = &ПакетЦентраМониторинга
    |";
    
    Запрос.УстановитьПараметр("Период", Период);
    Запрос.УстановитьПараметр("ИнформационнаяБаза", ИнформационнаяБаза);
    Запрос.УстановитьПараметр("ПакетЦентраМониторинга", ПакетЦентраМониторинга);
    
    Результат = Запрос.Выполнить();
    
    Возврат НЕ Результат.Пустой();
    
КонецФункции
