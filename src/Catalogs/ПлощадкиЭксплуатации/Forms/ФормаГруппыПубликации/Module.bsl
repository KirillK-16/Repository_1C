
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
        ЭтотОбъект.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Нет;
        ЭтотОбъект.Элементы.Наименование.Видимость = Ложь;
        ЭтотОбъект.Элементы.ГруппаКоманднаяПанельНастройкиПоУмолчанию.Видимость = Истина;
        ЭтотОбъект.Элементы.ЗаписатьИЗАкрытьМоя.КнопкаПоУмолчанию = Истина;
    КонецЕсли;
    
    ЗаполнитьНастройкиПоУмолчанию();
    
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
    
    ЗаписатьНастройкиПоУмолчанию();
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьМоя(Команда)
    
    ЗаписатьНастройкиПоУмолчанию();
    ЭтотОбъект.Закрыть();
    
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьМоя(Команда)
    ЗаписатьНастройкиПоУмолчанию();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНастройкиПоУмолчанию()
    
    Настройки = Справочники.Публикации.ПрочитатьНастройкиПоУмолчанию();
    
    ДобавитьПараметр("Логин", "Выполнять контроль", Настройки.Логин);
    ДобавитьПараметр("Пароль", "Выполнять контроль", Настройки.Пароль);
    ДобавитьПараметр("ВыполнятьКонтроль", "Выполнять контроль", Настройки.ВыполнятьКонтроль);
    ДобавитьПараметр("ЗапретитьПеренаправление", "Запретить перенаправление", Настройки.ЗапретитьПеренаправление);
    ДобавитьПараметр("Таймаут", "Таймаут, сек.", Настройки.Таймаут);
    ДобавитьПараметр("ПериодКонтроля", "Период контроля, сек.", Настройки.ПериодКонтроля);
    ДобавитьПараметр("МинимальныйПроцентДоступности", "Минимальная доступность, %", Настройки.МинимальныйПроцентДоступности);
    ДобавитьПараметр("ДопустимоНетДанных", "Допустимо нет данных, сек.", Настройки.ДопустимоНетДанных);
    ДобавитьПараметр("ПроверятьТелоОтвета", "Проверять тело ответа", Настройки.ПроверятьТелоОтвета);
            
КонецПроцедуры

&НаСервере
Процедура ДобавитьПараметр(Параметр, ПараметрПредставление, ПараметрЗначение)
    
    НовСтрока = ЭтотОбъект.ПараметрыПоУмолчанию.Добавить();
    НовСтрока.Параметр = Параметр;
    НовСтрока.ПараметрПредставление = ПараметрПредставление;
    НовСтрока.ПараметрЗначение = ПараметрЗначение;
        
КонецПроцедуры

Процедура ЗаписатьНастройкиПоУмолчанию()
    
    Настройки = Новый Структура;
    
    Для Каждого ТекПараметр Из ПараметрыПоУмолчанию Цикл
        
        Настройки.Вставить(ТекПараметр.Параметр, ТекПараметр.ПараметрЗначение);
            
    КонецЦикла;
    
    Справочники.Публикации.ЗаписатьНастройкиПоУмолчанию(Настройки);
        
КонецПроцедуры

#КонецОбласти
