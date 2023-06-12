
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    Если ЭтотОбъект.Параметры.Свойство("Отбор") Тогда
        КопироватьОтбор(ЭтотОбъект.Список.Отбор, ЭтотОбъект.Параметры.Отбор);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
    
    ОповеститьОВыборе(ЭтотОбъект.Список.Отбор);
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура КопироватьОтбор(ОтборПолучатель, ОтборИсточник)
    
    ОтборПолучатель.Элементы.Очистить();
    
    Если ЗначениеЗаполнено(ОтборИсточник) Тогда
        Для Каждого ТекЭлемент Из ОтборИсточник.Элементы Цикл
            Если ТипЗнч(ТекЭлемент) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
                КопироватьЭлементОбора(ОтборПолучатель.Элементы, ТекЭлемент);
            ИначеЕсли ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
                КопироватьГруппуОбора(ОтборПолучатель.Элементы, ТекЭлемент);
            КонецЕсли;
        КонецЦикла;
    КонецЕсли;
        
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура КопироватьЭлементОбора(ЭлементыОтбора, Элемент)
    
    НовЭлемент = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    НовЭлемент.ЛевоеЗначение = Элемент.ЛевоеЗначение;
    НовЭлемент.Использование = Элемент.Использование;
    НовЭлемент.ВидСравнения = Элемент.ВидСравнения;
    НовЭлемент.ПравоеЗначение = Элемент.ПравоеЗначение;
    
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура КопироватьГруппуОбора(ЭлементыОтбора, ГруппаЭлементов)
    
    НовГруппа = ЭлементыОтбора.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
    НовГруппа.Использование = ГруппаЭлементов.Использование;
    НовГруппа.ТипГруппы = ГруппаЭлементов.ТипГруппы;
    
    Для Каждого ТекЭлемент Из ГруппаЭлементов.Элементы Цикл
        Если ТипЗнч(ТекЭлемент) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
            КопироватьЭлементОбора(НовГруппа.Элементы, ТекЭлемент);
        ИначеЕсли ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
            КопироватьГруппуОбора(НовГруппа.Элементы, ТекЭлемент);
        КонецЕсли;
    КонецЦикла;
        
КонецПроцедуры

#КонецОбласти
