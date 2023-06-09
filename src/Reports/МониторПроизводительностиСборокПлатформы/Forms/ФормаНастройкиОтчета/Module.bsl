
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Отчет.Период = ЭтотОбъект.Параметры.Период;
    Отчет.ПрофилиКлючевыхОперацийXML = ЭтотОбъект.Параметры.ПрофилиКлючевыхОперацийXML;
    ПрофильИзXML(Отчет.ПрофилиКлючевыхОперацийXML);
    Отчет.ТипАнализа = ЭтотОбъект.Параметры.ТипАнализа;
    Отчет.ИспользоватьБазовоеЗначение = ЭтотОбъект.Параметры.ИспользоватьБазовоеЗначение;
    
    Если Отчет.ТипАнализа = "APDEX" Тогда
        ЭтотОбъект.Элементы.ИспользоватьБазовоеЗначение.Доступность = Истина;
    Иначе
        ЭтотОбъект.Элементы.ИспользоватьБазовоеЗначение.Доступность = Ложь;
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПрофилиКлючевыхОперацийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
    Отказ = Отчет.ПрофилиКлючевыхОпераций.Количество() >= 4;
КонецПроцедуры

&НаКлиенте
Процедура ТипАнализаПриИзменении(Элемент)
    
    Если Отчет.ТипАнализа = "APDEX" Тогда
        ЭтотОбъект.Элементы.ИспользоватьБазовоеЗначение.Доступность = Истина;
    Иначе
        ЭтотОбъект.Элементы.ИспользоватьБазовоеЗначение.Доступность = Ложь;
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
    
    ПараметрыЗакрытия = Новый Структура;
    ПараметрыЗакрытия.Вставить("Период", Отчет.Период);
    ПараметрыЗакрытия.Вставить("ПрофилиКлючевыхОперацийXML", ПрофильВXML());
    ПараметрыЗакрытия.Вставить("ТипАнализа", Отчет.ТипАнализа);
    ПараметрыЗакрытия.Вставить("ИспользоватьБазовоеЗначение", Отчет.ИспользоватьБазовоеЗначение);
    
    ЭтотОбъект.Закрыть(ПараметрыЗакрытия);
    
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
    ЭтотОбъект.Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПрофильВXML()
    
    ЗаписьXML = Новый ЗаписьXML;
    ЗаписьXML.УстановитьСтроку("UTF-8");
    СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Отчет.ПрофилиКлючевыхОпераций.Выгрузить(), НазначениеТипаXML.Явное);
    
    Возврат ЗаписьXML.Закрыть();
    
КонецФункции

&НаСервере
Функция ПрофильИзXML(XML)
    
    Чтение = Новый ЧтениеXML;
    Чтение.УстановитьСтроку(XML);
    
    Отчет.ПрофилиКлючевыхОпераций.Загрузить(СериализаторXDTO.ПрочитатьXML(Чтение));
        
КонецФункции

#КонецОбласти