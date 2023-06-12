
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс

// Функция - Конвертировать параметры
//
// Параметры:
//  Параметры  - Соответствие - Параметры, ключи которого будут преобразованы.
//  Источник   - Перечисление.ТипыПараметровКластер1С - Источник параметров.
//  Получатель - Перечисление.ТипыПараметровКластер1С - Получатель параметров.
// 
// Возвращаемое значение:
//   - Соответствие 
//
Функция КонвертироватьПараметры(Параметры, Источник, Получатель) Экспорт
    
    Если Источник = Перечисления.ТипыПараметровКластер1С.RAS И Получатель = Перечисления.ТипыПараметровКластер1С.ЦКК Тогда
        Возврат ПараметрыRAS_в_ЦКК(Параметры);
    КонецЕсли;
        
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыRAS_в_ЦКК(Параметры)
    
    Словарь = Новый Соответствие;
    Словарь.Вставить("Активен", "Активен");
    Словарь.Вставить("Включен", "Включен");
    Словарь.Вставить("ВремяЗапуска", "ВремяЗапуска");
    Словарь.Вставить("ВремяПревышенияПоПамяти", "ВремяПревышенияПоПамяти");
    Словарь.Вставить("ДоступнаяПроизводительность", "ДоступнаяПроизводительность");
    Словарь.Вставить("ИдентификаторПроцесса", "ИдентификаторПроцесса");
    Словарь.Вставить("ИдентификаторРабочегоПроцесса", "ИдентификаторРабочегоПроцесса");
    Словарь.Вставить("ИмяКомпьютера", "Компьютер");
    Словарь.Вставить("Лицензии", "Лицензии");
    Словарь.Вставить("ОтносительнаяПроизводительность", "ОтносительнаяПроизводительность");
    Словарь.Вставить("Порт", "Порт");
    Словарь.Вставить("СостояниеРабочегоПроцесса", "СостояниеРабочегоПроцесса");
    Словарь.Вставить("СреднееКоличествоПотоков", "СреднееКоличествоПотоков");
    Словарь.Вставить("СредняяДлительностьВызова", "СредняяДлительностьВызова");
    Словарь.Вставить("СредняяДлительностьВызововСУБД", "СредняяДлительностьВызововСУБД");
    Словарь.Вставить("СредняяДлительностьВызововСервисов", "СредняяДлительностьВызововСервисов");
    Словарь.Вставить("СредняяДлительностьОбработкиВызоваРабочимПроцессом", "СредняяДлительностьОбработкиВызоваРабочимПроцессом");
    Словарь.Вставить("ПотреблениеПамяти", "ПотреблениеПамяти");
       
    ПараметрыНовые = ПараметрыНовые(Параметры, Словарь);
    
    ПараметрыНовые["СостояниеРабочегоПроцесса"] = Строка(ПараметрыНовые["СостояниеРабочегоПроцесса"]);
    ПараметрыНовые["ИдентификаторРабочегоПроцесса"] = Строка(ПараметрыНовые["ИдентификаторРабочегоПроцесса"]);
    //ПараметрыНовые["Лицензии"] = АдминистрированиеКластераRAS.ЛицензииВСтроку(ПараметрыНовые["Лицензии"]);
    ПараметрыНовые["Лицензии"] = АдминистрированиеКластераRAS.ЛицензииКонвертировать(ПараметрыНовые["Лицензии"]);
                 
    Возврат ПараметрыНовые;
    
КонецФункции

Функция ПараметрыНовые(Параметры, Словарь)
    
    ПараметрыНовые = Новый Соответствие;
    Для Каждого ТекПараметр Из Параметры Цикл
        ПараметрыНовые.Вставить(Словарь[ТекПараметр.Ключ], ТекПараметр.Значение);
    КонецЦикла;
    
    Возврат ПараметрыНовые;
    
КонецФункции

#КонецОбласти
    
#КонецЕсли
