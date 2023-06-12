#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ПредопределеннныеПроцедуры

Процедура ПередЗаписью(Отказ)
    
    ЭтотОбъект.ДополнительныеСвойства.Вставить("СсылкаПометкаУдаления", Ссылка.ПометкаУдаления);
    ЭтотОбъект.ДополнительныеСвойства.Вставить("СсылкаПлощадкаЭксплуатации", Ссылка.ПлощадкаЭксплуатации);
    
    Если ДополнительныеСвойства.Свойство("НеПроверять") И ДополнительныеСвойства.НеПроверять Тогда
        Возврат;
    КонецЕсли;
        
    ЗаписатьПериодЗаписи();
        
    ЭтотОбъект.ДополнительныеСвойства.Вставить("ЭтоНовый", НЕ ЗначениеЗаполнено(ЭтотОбъект.Ссылка));
    ЭтотОбъект.ДополнительныеСвойства.Вставить("СсылкаРолиОборудования", Ссылка.РолиОборудования);
    ЭтотОбъект.ДополнительныеСвойства.Вставить("СсылкаПлощадкаЭксплуатации", Ссылка.ПлощадкаЭксплуатации);
        
    ЭтотОбъект.ДополнительныеСвойства.Вставить("НастройкиАгентаМониторПроизводительностиБыли", Справочники.Оборудование.НастройкиАгентаМониторПроизводительности(Ссылка));
               	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
    
    Корзина = Справочники.ПлощадкиЭксплуатации.Корзина();
    
    Если ДополнительныеСвойства.Свойство("СсылкаПометкаУдаления") И ДополнительныеСвойства.СсылкаПометкаУдаления <> ЭтотОбъект.ПометкаУдаления Тогда
        
        Если ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации <> Справочники.ПлощадкиЭксплуатации.ПустаяСсылка() И ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации <> ЭтотОбъект.ПлощадкаЭксплуатации И ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации <> Корзина Тогда
            ИзменитьКонтрольПоступленияСчетчиков(ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации.Наименование, Ложь);
        КонецЕсли;
        
    ИначеЕсли ДополнительныеСвойства.Свойство("ИзменитьКонтрольПоступленияСчетчиков") И ДополнительныеСвойства.Свойство("ДопустимоеВремяОтсутствияДанных") Тогда
        
        Если ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации <> Справочники.ПлощадкиЭксплуатации.ПустаяСсылка() И ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации <> ЭтотОбъект.ПлощадкаЭксплуатации Тогда
            ИзменитьКонтрольПоступленияСчетчиков(ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации.Наименование, Ложь);
        КонецЕсли;
        ИзменитьКонтрольПоступленияСчетчиков(ЭтотОбъект.ПлощадкаЭксплуатации.Наименование, ДополнительныеСвойства.ИзменитьКонтрольПоступленияСчетчиков, ДополнительныеСвойства.ДопустимоеВремяОтсутствияДанных);
        
    Иначе
        
        Если ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации <> Справочники.ПлощадкиЭксплуатации.ПустаяСсылка() И ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации <> ЭтотОбъект.ПлощадкаЭксплуатации Тогда
            ИзменитьКонтрольПоступленияСчетчиков(ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации.Наименование, Ложь);
        КонецЕсли;
                
    КонецЕсли;
    
    Если ДополнительныеСвойства.Свойство("НеПроверять") И ДополнительныеСвойства.НеПроверять Тогда
        Возврат;
    КонецЕсли;
    
    #Область ПлощадкаЭксплуатации
    
    Если ЭтотОбъект.ДополнительныеСвойства.ЭтоНовый ИЛИ (ДополнительныеСвойства.Свойство("ОбновлениеИБ") И ДополнительныеСвойства.ОбновлениеИБ) Тогда
        
        ДобавитьВПлощадку(ЭтотОбъект.ПлощадкаЭксплуатации, Неопределено);
        
        Для Каждого ТекРоль Из ЭтотОбъект.РолиОборудования Цикл
            ДобавитьВПлощадку(ЭтотОбъект.ПлощадкаЭксплуатации, ТекРоль.Роль);
        КонецЦикла;
        
    Иначе
        
        // Площадка эксплуатации не менялась
        СсылкаПлощадкаЭксплуатации = ЭтотОбъект.ДополнительныеСвойства.СсылкаПлощадкаЭксплуатации;
        Если СсылкаПлощадкаЭксплуатации = ЭтотОбъект.ПлощадкаЭксплуатации Тогда
            
            ДобавитьВПлощадку(ЭтотОбъект.ПлощадкаЭксплуатации, Неопределено);
            
            // Ищем роли, которые были удалены из табличной части
            СсылкаРолиОборудования = ЭтотОбъект.ДополнительныеСвойства.СсылкаРолиОборудования;
            УдаленныеТипыПлощадок = Новый Массив;
            Для Каждого ТекРоль Из СсылкаРолиОборудования Цикл
                
                РолиНовые = НайтиСтрокиРоли(ТекРоль.Роль, ЭтотОбъект.РолиОборудования);
                Если РолиНовые.Количество() = 0 Тогда
                    ТипыПлощадки = ТипыПлощадкиПоРоли(ТекРоль.Роль);
                    Если ТипыПлощадки.ТипЭлемента <> Перечисления.ТипЭлементаПлощадки.Оборудование Тогда
                        УдаленныеТипыПлощадок.Добавить(ТипыПлощадки.ТипЭлемента);
                    КонецЕсли;
                КонецЕсли;
                
            КонецЦикла;
            
            Запрос = Новый Запрос;
            Запрос.Текст = "
            |ВЫБРАТЬ
            |   Ссылка
            |ИЗ
            |   Справочник.ПлощадкиЭксплуатации
            |ГДЕ
            |   ЕдиницаКонтроля = &ЕдиницаКонтроля
            |   И ТипЭлемента В (&ТипыЭлементов)
            |";
            Запрос.УстановитьПараметр("ЕдиницаКонтроля", ЭтотОбъект.Ссылка);
            Запрос.УстановитьПараметр("ТипыЭлементов", УдаленныеТипыПлощадок); 
            
            Результат = Запрос.Выполнить();
            Выборка = Результат.Выбрать();
            Пока Выборка.Следующий() Цикл
                СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
                СпрОбъект.ДополнительныеСвойства.Вставить("РазрешитьУдалять", Истина);
                СпрОбъект.Удалить();
            КонецЦикла;
            
            // Анализируем текущее состояние ролей
            Корзина = Справочники.ПлощадкиЭксплуатации.Корзина();
            ТекущаяПлощадка = Справочники.ПлощадкиЭксплуатации.НайтиЭлементПоЕдиницеКонтроля(ЭтотОбъект.Ссылка, Перечисления.ТипЭлементаПлощадки.Оборудование);
            Для Каждого ТекРоль Из ЭтотОбъект.РолиОборудования Цикл
                
                РолиСохраненные = НайтиСтрокиРоли(ТекРоль.Роль, СсылкаРолиОборудования);
                // Это новая роль, ее добавили в табличную часть
                Если РолиСохраненные.Количество() = 0 Тогда
                    ДобавитьВПлощадку(ЭтотОбъект.ПлощадкаЭксплуатации, ТекРоль.Роль);
                КонецЕсли;
                
            КонецЦикла;
            // Площадка эксплуатации изменилась    
        Иначе
            
            ПеренестиВПлощадку(ЭтотОбъект.ПлощадкаЭксплуатации, СсылкаПлощадкаЭксплуатации, Неопределено);
            // Ищем роли, которые были удалены из табличной части
            СсылкаРолиОборудования = ЭтотОбъект.ДополнительныеСвойства.СсылкаРолиОборудования;
            УдаленныеТипыПлощадок = Новый Массив;
            Для Каждого ТекРоль Из СсылкаРолиОборудования Цикл
                
                РолиНовые = НайтиСтрокиРоли(ТекРоль.Роль, ЭтотОбъект.РолиОборудования);
                Если РолиНовые.Количество() = 0 Тогда
                    ТипыПлощадки = ТипыПлощадкиПоРоли(ТекРоль.Роль);
                    УдаленныеТипыПлощадок.Добавить(ТипыПлощадки.ТипЭлемента);
                КонецЕсли;
                
            КонецЦикла;
            
            Запрос = Новый Запрос;
            Запрос.Текст = "
            |ВЫБРАТЬ
            |   Ссылка
            |ИЗ
            |   Справочник.ПлощадкиЭксплуатации
            |ГДЕ
            |   ЕдиницаКонтроля = &ЕдиницаКонтроля
            |   И ТипЭлемента В (&ТипыЭлементов)
            |";
            Запрос.УстановитьПараметр("ЕдиницаКонтроля", ЭтотОбъект.Ссылка);
            Запрос.УстановитьПараметр("ТипыЭлементов", УдаленныеТипыПлощадок); 
            
            Результат = Запрос.Выполнить();
            Выборка = Результат.Выбрать();
            Пока Выборка.Следующий() Цикл
                СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
                СпрОбъект.ДополнительныеСвойства.Вставить("РазрешитьУдалять", Истина);
                СпрОбъект.Удалить();
            КонецЦикла;
            
            // Анализируем текущее состояние ролей
            Для Каждого ТекРоль Из ЭтотОбъект.РолиОборудования Цикл
                
                РолиСохраненные = НайтиСтрокиРоли(ТекРоль.Роль, СсылкаРолиОборудования);
                // Это новая роль, ее добавили в табличную часть
                Если РолиСохраненные.Количество() = 0 Тогда
                    ДобавитьВПлощадку(ЭтотОбъект.ПлощадкаЭксплуатации, ТекРоль.Роль);
                    // Это роль была
                Иначе
                    Для Каждого РольСохраненная Из РолиСохраненные Цикл
                        ПеренестиВПлощадку(ЭтотОбъект.ПлощадкаЭксплуатации, СсылкаПлощадкаЭксплуатации, ТекРоль.Роль);
                    КонецЦикла;
                КонецЕсли;
                
            КонецЦикла;
            
        КонецЕсли;
        
    КонецЕсли;
    
    #КонецОбласти
    
    Если ЗначениеЗаполнено(ЭтотОбъект.АгентКИП) И ЭтотОбъект.ИспользоватьВнешнегоАгента Тогда
        НастройкиАгентаМониторПроизводительностиБыли = ДополнительныеСвойства.НастройкиАгентаМониторПроизводительностиБыли;
        НастройкиАгентаМониторПроизводительности = Справочники.Оборудование.НастройкиАгентаМониторПроизводительности(ЭтотОбъект.Ссылка);
        Если НЕ Справочники.Оборудование.НастройкиАгентаМониторПроизводительностиРавны(НастройкиАгентаМониторПроизводительностиБыли, НастройкиАгентаМониторПроизводительности) Тогда
	        РегистрыСведений.КомандыАгентаКИП.ДобавитьКоманду(ЭтотОбъект.АгентКИП, Перечисления.ТипыКомандАгентаКИП.PerformanceMonitor, НастройкиАгентаМониторПроизводительности); 
        КонецЕсли;
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ЭтотОбъект.АгентКИП) И ЭтотОбъект.ИспользоватьВнешнегоАгента Тогда
        Если НастройкиАгентаМониторПроизводительностиБыли["СобиратьДанныеЛицензий1С"] <> НастройкиАгентаМониторПроизводительности["СобиратьДанныеЛицензий1С"] Тогда
            Команда = Новый Соответствие;
            Команда.Вставить("enable", НастройкиАгентаМониторПроизводительности["СобиратьДанныеЛицензий1С"]);
            РегистрыСведений.КомандыАгентаКИП.ДобавитьКоманду(ЭтотОбъект.АгентКИП, Перечисления.ТипыКомандАгентаКИП.Ring, Команда);
        КонецЕсли;
    КонецЕсли;
           
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НайтиСтрокиРоли(Роль, ТабличнаяЧасть)
    
    ПараметрыОтбора = Новый Структура("Роль", Роль);
    Возврат ТабличнаяЧасть.НайтиСтроки(ПараметрыОтбора);
    
КонецФункции

Процедура ДобавитьВПлощадку(ПлощадкаДобавить, Роль, РодительДляВосстановления = Неопределено)
    
    ТипыПлощадки = ТипыПлощадкиПоРоли(Роль);
        
    Справочники.ПлощадкиЭксплуатации.ДобавитьВПлощадку(ПлощадкаДобавить, Ссылка, ТипыПлощадки.ТипГруппы, ТипыПлощадки.ТипЭлемента,, РодительДляВосстановления);
    
КонецПроцедуры

Процедура ПеренестиВПлощадку(ПлощадкаЭксплуатацииВ, ПлощадкаЭксплуатацииИз, Роль)
    
    ТипыПлощадки = ТипыПлощадкиПоРоли(Роль);
    Справочники.ПлощадкиЭксплуатации.ПеренестиВНовуюПлощадку(ЭтотОбъект.Ссылка, ПлощадкаЭксплуатацииВ, ПлощадкаЭксплуатацииИз, ТипыПлощадки.ТипГруппы, ТипыПлощадки.ТипЭлемента);      
    
КонецПроцедуры

Функция ТипыПлощадкиПоРоли(Роль)
    
    Если Роль = Справочники.РолиОборудования.Шлюз Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаШлюзы;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.Шлюз; 
    ИначеЕсли Роль = Справочники.РолиОборудования.Apache Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаВебСерверы;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.ВебСерверApache;
    ИначеЕсли Роль = Справочники.РолиОборудования.СерверIIS Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаВебСерверы;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.ВебСерверIIS;
    ИначеЕсли Роль = Справочники.РолиОборудования.СерверMSSQL Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаСУБД;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.MSSQL;
    ИначеЕсли Роль = Справочники.РолиОборудования.СерверPostgreSQL Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаСУБД;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.PostgreSQL;
    ИначеЕсли Роль = Справочники.РолиОборудования.РабочийСервер1С Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаРабочиеСерверы1С;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.РабочийСервер1С;
    ИначеЕсли Роль = Справочники.РолиОборудования.ТерминальныйСервер Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаТерминальныеСервера;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.ТерминальныйСервер;
    ИначеЕсли Роль = Справочники.РолиОборудования.ВиртуальнаяМашинаVMware Тогда
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаВиртуальныеМашины;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.VMware;
    Иначе
        ТипГруппы = Перечисления.ТипЭлементаПлощадки.ГруппаОборудования;
        ТипЭлемента = Перечисления.ТипЭлементаПлощадки.Оборудование;    
    КонецЕсли;
    
    Возврат Новый Структура("ТипГруппы, ТипЭлемента", ТипГруппы, ТипЭлемента);
    
КонецФункции

Процедура ЗаписатьПериодЗаписи()
	
	
    
    Если ДополнительныеСвойства.Свойство("ПериодПоЧислу") И ДополнительныеСвойства.ПериодПоЧислу Тогда
        
        Если ПериодЗаписи = 0 Тогда
            ПериодЗаписиПредставление = "Не записывать";
        ИначеЕсли ПериодЗаписи = 1 Тогда
            ПериодЗаписиПредставление = "1 сек";
        ИначеЕсли ПериодЗаписи > 1 И ПериодЗаписи < 10 Тогда
            ПериодЗаписиПредставление = "5 сек";
        ИначеЕсли ПериодЗаписи >= 10 И ПериодЗаписи < 30 Тогда
            ПериодЗаписиПредставление = "10 сек"
        ИначеЕсли ПериодЗаписи >= 30 И ПериодЗаписи < 60 Тогда
            ПериодЗаписиПредставление = "30 сек";
        Иначе
            ПериодЗаписиПредставление = "1 мин";
        КонецЕсли;
        
    Иначе
        
        Если НЕ ЗначениеЗаполнено(ПериодЗаписиПредставление) Тогда
            ПериодЗаписиПредставление = "10 сек";
        КонецЕсли;
        
        Если ПериодЗаписиПредставление = "Не записывать" Тогда
            ПериодЗаписи = 0;
        ИначеЕсли ПериодЗаписиПредставление = "1 сек" Тогда
            ПериодЗаписи = 1;
        ИначеЕсли ПериодЗаписиПредставление = "5 сек" Тогда
            ПериодЗаписи = 5;
        ИначеЕсли ПериодЗаписиПредставление = "10 сек" Тогда
            ПериодЗаписи = 10;
        ИначеЕсли ПериодЗаписиПредставление = "30 сек" Тогда
            ПериодЗаписи = 30;
        ИначеЕсли ПериодЗаписиПредставление = "1 мин" Тогда
            ПериодЗаписи = 60;
        КонецЕсли;
        
    КонецЕсли;
    
    
КонецПроцедуры

Процедура ИзменитьКонтрольПоступленияСчетчиков(ПлощадкаЭксплуатацииНаименование, КонтрольДанных = Неопределено, ДопустимоеВремяОтсутствияДанных = Неопределено)
    
    Для Каждого ТекСчетчик Из ЭтотОбъект.СчетчикиПроизводительности Цикл
        
        ПолныйКодДляПоиска = Новый Массив;
        ПолныйКодДляПоиска.Добавить("Производительность оборудования");
        ПолныйКодДляПоиска.Добавить(ПлощадкаЭксплуатацииНаименование);
        ПолныйКодДляПоиска.Добавить(ЭтотОбъект.Наименование);
        ПолныйКодДляПоиска.Добавить(ТекСчетчик.СчетчикПроизводительности);
        
        СчетчикСсылка = СтатистикаГруппыСчетчиков.СоздатьНовуюГруппуСчетчиков(ПолныйКодДляПоиска);
        
        Если ЗначениеЗаполнено(СчетчикСсылка) Тогда
            
            Если КонтрольДанных = Неопределено Тогда
                КонтрольДанных = НЕ ЭтотОбъект.ПометкаУдаления И ЭтотОбъект.СобиратьДанныеПроизводительности = 1 И ТекСчетчик.СобиратьДанные;
            КонецЕсли;
            
            Если СчетчикСсылка.КонтрольПоступленияДанных <> КонтрольДанных Тогда
                
                СчетчикОбъект = СчетчикСсылка.ПолучитьОбъект();
                СчетчикОбъект.КонтрольПоступленияДанных = КонтрольДанных;
                Если ДопустимоеВремяОтсутствияДанных <> Неопределено Тогда
                    СчетчикОбъект.ДопустимоеВремяОтсутствияДанных = ДопустимоеВремяОтсутствияДанных;
                КонецЕсли;
                СчетчикОбъект.Записать();
                
            КонецЕсли;
            
        КонецЕсли;
                
    КонецЦикла;
    
КонецПроцедуры

Процедура ПолучитьВсеСчетчикиWindows(ПараметрыЗапуска) Экспорт
    
    Хост = ПараметрыЗапуска["ДополнительныеПараметры"]["Хост"];
    ЯзыкОС = ПараметрыЗапуска["ДополнительныеПараметры"]["ЯзыкОС"];
    АдресХранилища = ПараметрыЗапуска["АдресХранилищаЗадания"];
        
    СисИнфо = Новый СистемнаяИнформация();
    Если (СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86) Или (СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64) Тогда
        
        ИмяФайлаПотокаВывода = ПолучитьИмяВременногоФайла("out");
        ИмяФайлаПотокаОшибок = ПолучитьИмяВременногоФайла("err");
        
        КоманднаяСтрока = "typeperf -qx -s " + Хост + " > """ + ИмяФайлаПотокаВывода + """ 2>""" + ИмяФайлаПотокаОшибок + """";
        
        Если ЯзыкОС = Перечисления.ЯзыкиСистемы.Русский Тогда
            КоманднаяСтрока = "cmd /c " +  """chcp 866&" + КоманднаяСтрока + """";
        ИначеЕсли ЯзыкОС = Перечисления.ЯзыкиСистемы.Английский Тогда
            КоманднаяСтрока = "cmd /c " +  """chcp 437&" + КоманднаяСтрока + """";
        КонецЕсли;
        
        Оболочка = Новый COMОбъект("Wscript.Shell");
        ДатаНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
        РезультатExec = Оболочка.Exec(КоманднаяСтрока);
        ProcessID = РезультатExec.ProcessID;
        
        Ожидать = Истина;
        МаксимальноеОжидание = 60;
        ДатаКрайнегоОжидания = ТекущаяУниверсальнаяДата() + МаксимальноеОжидание;
        Пока Ожидать Цикл
            Если РезультатExec.Status = 1 ИЛИ ТекущаяУниверсальнаяДата() > ДатаКрайнегоОжидания Тогда
                Ожидать = Ложь;
            Иначе
                КипВнешнийКомпонент.Пауза(100);
            КонецЕсли;
        КонецЦикла;
        
        Если РезультатExec.Status = 0 Тогда
            
            КомандаTaskKill = "taskkill /F /T /PID " + Формат(ProcessID, "ЧГ=0");
            РезультатExec = Оболочка.Exec(КомандаTaskKill);
            
            StdOut = РезультатExec.StdOut.ReadAll();
            StdErr = РезультатExec.StdErr.ReadAll();
            
            Если РезультатExec.ExitCode = -1 Тогда
                РезультатВыполнения  = StdErr;
            Иначе
                РезультатВыполнения = StdOut;
            КонецЕсли;
            
            РезультатВыполнения = ПерекодироватьСтроку(РезультатВыполнения, "windows-1251", "cp866");
            
        КонецЕсли;
        
        ФайлПотокаОшибок = Новый Файл(ИмяФайлаПотокаОшибок);
        Если ФайлПотокаОшибок.Существует() Тогда
            ЧтениеПотокаОшибок = Новый ЧтениеТекста(ИмяФайлаПотокаОшибок, АдминистрированиеКластераRAS.ПолучитьКодировкуСтандартныхПотоков());
            ПотокОшибок = ЧтениеПотокаОшибок.Прочитать();
            ЧтениеПотокаОшибок.Закрыть();
        КонецЕсли;
        
        Если ЗначениеЗаполнено(ПотокОшибок) Тогда
            
            УдалитьВременныеФайл(ИмяФайлаПотокаОшибок, ИмяФайлаПотокаВывода);
            РезультатВыполнения = ПотокОшибок;
            
        Иначе
            ФайлПотокаВывода = Новый Файл(ИмяФайлаПотокаВывода);
            Если ФайлПотокаВывода.Существует() Тогда
                ЧтениеПотокаВывода = Новый ЧтениеТекста(ИмяФайлаПотокаВывода, АдминистрированиеКластераRAS.ПолучитьКодировкуСтандартныхПотоков()); 
                ПотокВывода = ЧтениеПотокаВывода.Прочитать();
                Если ПотокВывода = Неопределено Тогда
                    ПотокВывода = "";
                КонецЕсли;
                ЧтениеПотокаВывода.Закрыть();
                
                УдалитьВременныеФайл(ИмяФайлаПотокаОшибок, ИмяФайлаПотокаВывода);
                РезультатВыполнения = ПотокВывода;
                
                РезультаВыполненияМассив = СтрРазделить(РезультатВыполнения, Символы.ПС);
                РезультаВыполненияМассивНовый = Новый Массив;
                ХостПолный = "\\" + Хост; 
                
                Для Каждого ТекЭлемент Из РезультаВыполненияМассив Цикл
                    
                    Если СтрНачинаетсяС(ТекЭлемент, ХостПолный) Тогда
                        РезультаВыполненияМассивНовый.Добавить(СтрЗаменить(ТекЭлемент, ХостПолный, ""));
                    КонецЕсли;
                    
                КонецЦикла;
                
                РезультатВыполнения = СтрСоединить(РезультаВыполненияМассивНовый, Символы.ПС);
                
            КонецЕсли;
            
        КонецЕсли;
        
    Иначе
        
        РезультатВыполнения = "Получение данных с помощью PDH возможно только на платформе Windows.
        |Получение данных запущено на " + СисИнфо.ТипПлатформы + ".";
        
    КонецЕсли;
    
    ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
    
КонецПроцедуры

Процедура ТестСчетчиковWindows(ПараметрыЗапуска) Экспорт
    
    Оборудование = ПараметрыЗапуска["ДополнительныеПараметры"]["Оборудование"];
    Хост = ПараметрыЗапуска["ДополнительныеПараметры"]["Хост"];
    ЯзыкОС = ПараметрыЗапуска["ДополнительныеПараметры"]["ЯзыкОС"];
    Счетчики = ПараметрыЗапуска["ДополнительныеПараметры"]["Счетчики"];
    
    ЯзыкОС_Определить = КипВнешнийКомпонент.ЯзыкПолученияСчетчиков(Хост);
    Если ЯзыкОС <> ЯзыкОС_Определить Тогда
        ЯзыкОС = ЯзыкОС_Определить;
    КонецЕсли;
        
    СчетчикиПредставление = Справочники.СчетчикиПроизводительности.ПолучитьНаименованияСчетчиков(Счетчики, ЯзыкОС);
    
    Настройки = РегистрыСведений.ОборудованиеОперативныеНастройки.ПрочитатьНастройки(Оборудование);
    Настройки.ЯзыкОС = ЯзыкОС;
    РегистрыСведений.ОборудованиеОперативныеНастройки.ЗаписатьНастройки(Оборудование, Настройки);
    
    Выполнять = Настройки.ОперативныйРежим И (Настройки.ДатаЗаписиUTC >= ТекущаяУниверсальнаяДата() - 300);
    
    СчетчикиРезультат = Новый Соответствие;
    НаборЗаписей = РегистрыСведений.ТекущиеЗначенияПроизводительности.СоздатьНаборЗаписей();
    НаборЗаписей.Отбор.Сервер.Установить(Оборудование);
    НаборЗаписей.Записать(Истина);
    
    СисИнфо = Новый СистемнаяИнформация();
    Если (СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86) Или (СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64) Тогда
        
        КипВнешнийКомпонент.ПолучитьИнструменты();
        СчетчикиКИП = КипВнешнийКомпонент.ПолучитьСчетчики();
        КипВнешнийКомпонент.ПодключитьСчетчики(СчетчикиКИП);
        
        ИндексОшибки = -1;
        Для Каждого ТекСчетчик Из СчетчикиПредставление Цикл
            СчетчикНаименованиеПолное = "\\" + Хост + ТекСчетчик.Значение;
            Попытка
                Индекс = КипВнешнийКомпонент.ДобавитьСчетчик(СчетчикиКИП, СчетчикНаименованиеПолное);
                СчетчикиРезультат.Вставить(Индекс, Новый Структура("Счетчик, Результат, ОписаниеОшибки", ТекСчетчик.Ключ, -1, ""));
            Исключение
                ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
                СчетчикиРезультат.Вставить(ИндексОшибки, Новый Структура("Счетчик, Результат, ОписаниеОшибки", ТекСчетчик.Ключ, -1, ОписаниеОшибки));
                ИндексОшибки = ИндексОшибки - 1;
            КонецПопытки;
            
        КонецЦикла;
        
        Попытка
            
            КипВнешнийКомпонент.СобратьЗначенияСчетчиков(СчетчикиКИП);
            
        Исключение
            
            Для Каждого ТекЭлемент Из СчетчикиРезультат Цикл
                ТекЭлемент.Значение.ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
            КонецЦикла;
            
        КонецПопытки;
        
        Пока Выполнять Цикл
            
            Попытка
                
                КипВнешнийКомпонент.СобратьЗначенияСчетчиков(СчетчикиКИП);
                
                Для Каждого ТекЭлемент Из СчетчикиРезультат Цикл
                    
                    Если ТекЭлемент.Ключ >= 0 Тогда
                        Попытка
                            Значение = КипВнешнийКомпонент.ЗначениеСчетчика(СчетчикиКИП, ТекЭлемент.Ключ);
                        Исключение
                            Значение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
                        КонецПопытки;
                    Иначе
                        Значение = ТекЭлемент.Значение.ОписаниеОшибки;
                    КонецЕсли;
                    
                    Если ТипЗнч(Значение) = Тип("Число") Тогда
                        ТекЭлемент.Значение.Результат = Значение;
                        ТекЭлемент.Значение.ОписаниеОшибки = "";
                    ИначеЕсли ТипЗнч(Значение) = Тип("Строка") Тогда
                        ТекЭлемент.Значение.Результат = -1;
                        ТекЭлемент.Значение.ОписаниеОшибки = Значение;
                    КонецЕсли;
                    
                КонецЦикла;
            Исключение
                
                Для Каждого ТекЭлемент Из СчетчикиРезультат Цикл
                    ТекЭлемент.Значение.ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
                КонецЦикла;
                
            КонецПопытки;
            
            ТекДата = ТекущаяДата();
            НаборЗаписей.Отбор.Сервер.Установить(Оборудование);
            Для Каждого ТекЗначение Из СчетчикиРезультат Цикл
                
                НовЗапись = НаборЗаписей.Добавить();
                НовЗапись.Сервер = Оборудование;
                НовЗапись.СчетчикПроизводительности = ТекЗначение.Значение.Счетчик;
                НовЗапись.Значение = ТекЗначение.Значение.Результат;
                НовЗапись.ДатаЗамера = ТекДата;
                НовЗапись.ОписаниеОшибки = ТекЗначение.Значение.ОписаниеОшибки;
                
                Если ТекЗначение.Значение.Счетчик.Применимо = Перечисления.СчетчикПроизводительностиПрименимо.Linux Тогда
                    НовЗапись.ОписаниеОшибки = "Данный счетчик недоступен на OC семейства Linux.";
                КонецЕсли;
                                
            КонецЦикла;
            
            НаборЗаписей.Записать(Истина);
            НаборЗаписей.Очистить();
            
            КипВнешнийКомпонент.Пауза(1000);
            
            Настройки = РегистрыСведений.ОборудованиеОперативныеНастройки.ПрочитатьНастройки(Оборудование);
            Выполнять = Настройки.ОперативныйРежим И (Настройки.ДатаЗаписиUTC >= ТекущаяУниверсальнаяДата() - 300);
            
        КонецЦикла;
        
    Иначе
        
        ТекДата = ТекущаяДата();
        НаборЗаписей.Отбор.Сервер.Установить(Оборудование);
        Для Каждого ТекСчетчик Из СчетчикиПредставление Цикл
            
            НовЗапись = НаборЗаписей.Добавить();
            НовЗапись.Сервер = Оборудование;
            НовЗапись.СчетчикПроизводительности = ТекСчетчик.Ключ;
            НовЗапись.Значение = -1;
            НовЗапись.ДатаЗамера = ТекДата;
            НовЗапись.ОписаниеОшибки = "Получение данных с помощью PDH возможно только на платформе Windows.
            |Получение данных запущено на " + СисИнфо.ТипПлатформы + ".";
            
        КонецЦикла;
        
        НаборЗаписей.Записать(Истина);
        НаборЗаписей.Очистить();    
        
        
    КонецЕсли;
    
КонецПроцедуры

Функция ПерекодироватьСтроку(Знач Данные, КодировкаДанных, КодировкаНовая)
	
	ФайлВременный = ПолучитьИмяВременногоФайла("tmp");
	ФайлЗапись = Новый ЗаписьТекста(ФайлВременный, КодировкаДанных);
	ФайлЗапись.Записать(Данные);
	ФайлЗапись.Закрыть();
				
	ФайлЧтение = Новый ЧтениеТекста(ФайлВременный, КодировкаНовая);
	Данные = ФайлЧтение.Прочитать();
	ФайлЧтение.Закрыть();		
	
	УдалитьФайлы(ФайлВременный);
	
	Возврат Данные;
    
КонецФункции

Процедура УдалитьВременныеФайл(ФайлПотокаОшибок, ФайлПотокаВывода)
	ФайлПО = Новый Файл(ФайлПотокаОшибок);
	Если ФайлПО.Существует() Тогда
		Попытка
			УдалитьФайлы(ФайлПотокаОшибок);
		Исключение
			// Ожидаемое поведение
		КонецПопытки;
	КонецЕсли;
	
	ФайлПВ = Новый Файл(ФайлПотокаВывода);
	Если ФайлПВ.Существует() Тогда
		Попытка
			УдалитьФайлы(ФайлПотокаВывода);
		Исключение
			// Ожидаемое исключение
		КонецПопытки;
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


