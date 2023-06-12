
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

&НаКлиенте
Процедура РасписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    
    Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект.Расписание);
	Диалог.Показать(Новый ОписаниеОповещения("ОткрытьРасписаниеЗавершение", ЭтотОбъект));
    
    СтандартнаяОбработка = Ложь;
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьНастройкиПоУмолчанию()
    
    НастройкиПоУмолчанию = РегистрыСведений.НастройкиАнализВызововКластера1С.ПрочитатьНастройки(Справочники.ВидыКонтрольныхПроцедур.АнализВызововКластера1С());
    
    Для Каждого ТекНастройка Из НастройкиПоУмолчанию Цикл
        
        Если ТекНастройка.Ключ = "ДлительностьХраненияФайловТЖ" Тогда
            
            НовСтрока = ПараметрыПоУмолчанию.Добавить();
            
            НовСтрока.Параметр = ТекНастройка.Ключ;
            НовСтрока.ПараметрПредставление = "Длительность хранения файлов ТЖ, часов";
            НовСтрока.ПараметрЗначение = ТекНастройка.Значение;
            
        ИначеЕсли ТекНастройка.Ключ = "СрокХраненияТЖ" Тогда
            
            НовСтрока = ПараметрыПоУмолчанию.Добавить();
            
            НовСтрока.Параметр = ТекНастройка.Ключ;
            НовСтрока.ПараметрПредставление = "Срок хранения данных ТЖ в ЦКК, часов";
            НовСтрока.ПараметрЗначение = ТекНастройка.Значение;
            
        ИначеЕсли ТекНастройка.Ключ = "АвтоматическиУдалятьЗаписиТЖ" Тогда
            
            НовСтрока = ПараметрыПоУмолчанию.Добавить();
            
            НовСтрока.Параметр = ТекНастройка.Ключ;
            НовСтрока.ПараметрПредставление = "Автоматически удалять записи";
            НовСтрока.ПараметрЗначение = ТекНастройка.Значение;
            
        ИначеЕсли ТекНастройка.Ключ = "Расписание" Тогда
            
            ЭтотОбъект.Расписание = ТекНастройка.Значение;
            Если ЭтотОбъект.Расписание = Неопределено Тогда
                ЭтотОбъект.Расписание = Новый РасписаниеРегламентногоЗадания;
            КонецЕсли;
            
        КонецЕсли;
        
    КонецЦикла;
    
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиПоУмолчанию()
    
    НастройкиПоУмолчанию = Новый Структура;
    
    Для Каждого ТекНастройка Из ПараметрыПоУмолчанию Цикл
        НастройкиПоУмолчанию.Вставить(ТекНастройка.Параметр, ТекНастройка.ПараметрЗначение);
    КонецЦикла;
    
    НастройкиПоУмолчанию.Вставить("Расписание", ЭтотОбъект.Расписание);
    
    РегистрыСведений.НастройкиАнализВызововКластера1С.ЗаписатьНастройки(Справочники.ВидыКонтрольныхПроцедур.АнализВызововКластера1С(), НастройкиПоУмолчанию);
    
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРасписаниеЗавершение(НовоеРасписание, Неопределен) Экспорт
    
    Если НовоеРасписание <> Неопределено Тогда
		ЭтотОбъект.Расписание = НовоеРасписание;
    КонецЕсли;
    
КонецПроцедуры
    
#КонецОбласти
