
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПрограммныйИнтерфейс

// Функция - Инцидент
//
// Параметры:
//  Ссылка   - СправочникСсылка - Ссылка на любой справочник.
//  Инцидент - Структура - Представление инцидента.
// 
// Возвращаемое значение:
//  Ссылка - СправочникСсылка.Инциденты
//
Функция Инцидент(Ссылка, Инцидент) Экспорт
    
    ХешИнцидентаСсылка = Справочники.Инциденты.ХешИнцидента(Строка(Ссылка.УникальныйИдентификатор()) + Инцидент["type"]);
    Возврат Справочники.Инциденты.СоздатьЭлементПоХешу(ХешИнцидентаСсылка, Ссылка.Наименование, Ложь);
    
КонецФункции

Функция ДатаИнцидента(Инцидент) Экспорт
    
    ДатаОткрытия = Дата(Инцидент["date"]);
    Возврат МестноеВремя(ДатаОткрытия);
    
КонецФункции

Функция СоздатьЭлементПоНаименованию(Наименование) Экспорт
    
    РезультатСсылка = НайтиСсылкуПоНаименованию(Наименование);
    ПустаяСсылка = Справочники.Инциденты.ПустаяСсылка();
    
    Если РезультатСсылка = ПустаяСсылка Тогда
        НачатьТранзакцию();
        Попытка
            БлокировкаДанных = Новый БлокировкаДанных;
            ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.Инциденты");
            ЭлементБлокировки.УстановитьЗначение("Наименование", Наименование);
            ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
            БлокировкаДанных.Заблокировать();
            
            РезультатСсылка = НайтиСсылкуПоНаименованию(Наименование);
            Если РезультатСсылка = ПустаяСсылка Тогда
                НовыйЭлемент = Справочники.Инциденты.СоздатьЭлемент();
                НовыйЭлемент.Наименование = Наименование;
                НовыйЭлемент.ХешИнцидента = "";
                НовыйЭлемент.ДатаОткрытия = ТекущаяДата();
                НовыйЭлемент.Записать();
                РезультатСсылка = НовыйЭлемент.Ссылка;
            КонецЕсли;
            
            ЗафиксироватьТранзакцию();
        Исключение
            ОтменитьТранзакцию();
            ВызватьИсключение;
        КонецПопытки;
    КонецЕсли;
    
    Возврат РезультатСсылка;
    
КонецФункции

Функция СоздатьЭлементПоХешу(ХешИнцидента, Наименование, ИзменитьНаименование = Истина) Экспорт
    
    РезультатСсылка = НайтиСсылкуПоХешу(ХешИнцидента);
    ПустаяСсылка = Справочники.Инциденты.ПустаяСсылка();
    
    Если РезультатСсылка = ПустаяСсылка Тогда
        НачатьТранзакцию();
        Попытка
            БлокировкаДанных = Новый БлокировкаДанных;
            ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.Инциденты");
            ЭлементБлокировки.УстановитьЗначение("ХешИнцидента", ХешИнцидента);
            ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
            БлокировкаДанных.Заблокировать();
            
            РезультатСсылка = НайтиСсылкуПоХешу(ХешИнцидента);
            Если РезультатСсылка = ПустаяСсылка Тогда
                НовыйЭлемент = Справочники.Инциденты.СоздатьЭлемент();
                НовыйЭлемент.Наименование = Наименование;
                НовыйЭлемент.ХешИнцидента = ХешИнцидента;
                НовыйЭлемент.ДатаОткрытия = ТекущаяДата();
                НовыйЭлемент.Записать();
                РезультатСсылка = НовыйЭлемент.Ссылка;
            КонецЕсли;
            
            ЗафиксироватьТранзакцию();
        Исключение
            ОтменитьТранзакцию();
            ВызватьИсключение;
        КонецПопытки;
    Иначе
        
        Если ИзменитьНаименование И РезультатСсылка.Наименование <> Наименование Тогда
            
            НачатьТранзакцию();
            Попытка
                БлокировкаДанных = Новый БлокировкаДанных;
                ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.Инциденты");
                ЭлементБлокировки.УстановитьЗначение("ХешИнцидента", ХешИнцидента);
                ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
                БлокировкаДанных.Заблокировать();
                
                РезультатСсылка = НайтиСсылкуПоХешу(ХешИнцидента);
                Если РезультатСсылка.Наименование <> Наименование Тогда
                    СпрОбъект = РезультатСсылка.ПолучитьОбъект();
                    СпрОбъект.Наименование = Наименование;
                    СпрОбъект.Записать();
                КонецЕсли;
                
                ЗафиксироватьТранзакцию();
            Исключение
                ОтменитьТранзакцию();
                ВызватьИсключение;
            КонецПопытки;
            
        КонецЕсли;
        
    КонецЕсли;
    
    Возврат РезультатСсылка;
    
КонецФункции

Функция НайтиСсылкуПоНаименованию(Наименование) Экспорт
    
    РезультатСсылка = Справочники.Инциденты.ПустаяСсылка();
        
    Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Справочник.Инциденты
	|ГДЕ
	|	Наименование = &Наименование
	|";
	Запрос.УстановитьПараметр("Наименование", Наименование);
    
    Результат = Запрос.Выполнить();
    Если НЕ Результат.Пустой() Тогда
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        РезультатСсылка = Выборка.Ссылка;
    КонецЕсли;
    
	Возврат РезультатСсылка;
    
КонецФункции

Функция НайтиСсылкуПоХешу(ХешИнцидента) Экспорт
    
    РезультатСсылка = Справочники.Инциденты.ПустаяСсылка();
        
    Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Справочник.Инциденты
	|ГДЕ
	|	ХешИнцидента = &ХешИнцидента
	|";
	Запрос.УстановитьПараметр("ХешИнцидента", ХешИнцидента);
    
    Результат = Запрос.Выполнить();
    Если НЕ Результат.Пустой() Тогда
        Выборка = Результат.Выбрать();
        Выборка.Следующий();
        РезультатСсылка = Выборка.Ссылка;
    КонецЕсли;
    
	Возврат РезультатСсылка;
    
КонецФункции

Функция ХешИнцидента(Данные) Экспорт
    
    ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA256);
    ХешированиеДанных.Добавить(Данные);
    
    Возврат СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", "");
    
КонецФункции

#КонецОбласти

#КонецЕсли
