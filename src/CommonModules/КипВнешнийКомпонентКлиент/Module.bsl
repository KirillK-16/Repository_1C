
#Область ЭкспортныеПроцедурыИФункции

// Начать паузу на указанное количество миллисекунд
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после выполнения.
//  Длительность       - Число              - Количество миллисекунд, на которое приостановить поток.
//
&НаКлиенте
Процедура НачатьПаузу(ОписаниеОповещения, Длительность) Экспорт
    
    Параметры = Новый Структура("Длительность", Длительность);
    
    Если глИнструменты = Неопределено Тогда
        ДополнительныеПараметры = Новый Структура("Метод, ОписаниеОповещения, Параметры", "Пауза", ОписаниеОповещения, Параметры);
        КипВнешнийКомпонентКлиентСлужебный.НачатьПолучениеИнструментов(ДополнительныеПараметры);
    Иначе    
        КипВнешнийКомпонентКлиентСлужебный.ВыполнитьМетодАсинхронно("Пауза", ОписаниеОповещения, Параметры);    
    КонецЕсли;
        	
КонецПроцедуры

// Запустить указанную программу от имени указанного пользователя
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после выполнения.
//  СтрокаЗапуска - Строка - Путь и параметры запускаемого приложения.
//  Пользователь  - Строка - Имя пользователя в формате UPN, от имени которого запускать приложение.
//  Пароль        - Строка - Пароль пользователя, от имени которого запускать приложение.
//
Процедура НачатьЗапускПрограммы(ОписаниеОповещения, СтрокаЗапуска, Пользователь = "", Пароль = "") Экспорт
    
    ПарамПользователь = "";
    ПарамДомен = "";
    
    Если ЗначениеЗаполнено(Пользователь) Тогда
        
        Если СтрНайти(Пользователь, "/") > 0 Тогда
            
            ПользовательМассив = СтрРазделить(Пользователь, "/");
            ПарамПользователь = ПользовательМассив[0];
            ПарамДомен = ПользовательМассив[1];
            
        ИначеЕсли СтрНайти(Пользователь, "@") > 0 Тогда
            
            ПользовательМассив = СтрРазделить(Пользователь, "@");
            ПарамПользователь = ПользовательМассив[0];
            ПарамДомен = ПользовательМассив[1];
            
        Иначе
            ПарамПользователь = Пользователь;
            ПарамДомен = "";
        КонецЕсли;
                
    КонецЕсли;
    
            
	Параметры = Новый Структура("СтрокаЗапуска, Имя, Домен, Пароль", СтрокаЗапуска, ПарамПользователь, ПарамДомен, Пароль);
        
    Если глИнструменты = Неопределено Тогда
        ДополнительныеПараметры = Новый Структура("Метод, ОписаниеОповещения, Параметры", "Запустить", ОписаниеОповещения, Параметры);
        КипВнешнийКомпонентКлиентСлужебный.НачатьПолучениеИнструментов(ДополнительныеПараметры);
    Иначе    
        КипВнешнийКомпонентКлиентСлужебный.ВыполнитьМетодАсинхронно("Запустить", ОписаниеОповещения, Параметры);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

