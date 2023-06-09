#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция КонвертироватьПараметры(Параметры, Источник, Получатель, Словарь = Неопределено) Экспорт
    
    Если Источник = Перечисления.ТипыПараметровКластер1С.АгентКИП И Получатель = Перечисления.ТипыПараметровКластер1С.ЦКК Тогда
        Возврат ПараметрыАгентКИП_в_ЦКК(Параметры, Словарь);
    ИначеЕсли Источник = Перечисления.ТипыПараметровКластер1С.RAS И Получатель = Перечисления.ТипыПараметровКластер1С.ЦКК Тогда
        Возврат ПараметрыRAS_в_ЦКК(Параметры, Словарь);        
    КонецЕсли;    
    
КонецФункции

Функция Словарь(Источник, Получатель) Экспорт
    
    Если Источник = Перечисления.ТипыПараметровКластер1С.АгентКИП И Получатель = Перечисления.ТипыПараметровКластер1С.ЦКК Тогда
        Возврат СловарьАгентКИП_в_ЦКК();
    КонецЕсли;
        
КонецФункции

Функция УдалитьУстаревшиеДанные() Экспорт
    
    Запрос = Новый Запрос;
    
    Запрос.Текст = "
    |ВЫБРАТЬ РАЗЛИЧНЫЕ
    |   Время
    |ИЗ
    |   (ВЫБРАТЬ ПЕРВЫЕ 1000
    |       Время КАК Время
    |   ИЗ
    |       РегистрСведений.МониторингСеансов
    |   ГДЕ
    |       Кластер = &Кластер
    |       И База = &База
    |       И Время <= &ГраницаУдаления
    |   ) КАК Выборка
    |";
    
	НастройкиУдаления = РегистрыСведений.НастройкиКонтрольПамяти.НастройкиУдаления();
    
    ТекДата = ТекущаяДата();
    
    МаксимальныйСрокХранения = 0;
    
    Для Каждого ТекНастройка Из НастройкиУдаления Цикл
        
        Запрос.УстановитьПараметр("Кластер", ТекНастройка.Кластер);
        Запрос.УстановитьПараметр("База", ТекНастройка.ИнформационнаяБаза);
        Запрос.УстановитьПараметр("ГраницаУдаления", ТекДата - ТекНастройка.СрокХраненияДанных * 3600);
        
        Если ТекНастройка.СрокХраненияДанных > МаксимальныйСрокХранения Тогда
            МаксимальныйСрокХранения = ТекНастройка.СрокХраненияДанных;
        КонецЕсли;
                
        ЕстьУдаление = Истина;
        
        Пока ЕстьУдаление Цикл
            
            Результат = Запрос.Выполнить();
            
            Выборка = Результат.Выбрать();
            Пока Выборка.Следующий() Цикл
                
                НаборЗаписей = СоздатьНаборЗаписей();
                НаборЗаписей.Отбор.Кластер.Установить(ТекНастройка.Кластер);
                НаборЗаписей.Отбор.База.Установить(ТекНастройка.ИнформационнаяБаза);
                НаборЗаписей.Отбор.Время.Установить(Выборка.Время);
                НаборЗаписей.Записать(Истина);
                
            КонецЦикла;
                        
            ЕстьУдаление = НЕ Результат.Пустой();
            
        КонецЦикла;
        
    КонецЦикла;
    
    
    Если МаксимальныйСрокХранения > 0 Тогда
        
        Запрос = Новый Запрос;
        
        Запрос.Текст = "
        |ВЫБРАТЬ РАЗЛИЧНЫЕ
        |	Время КАК Время
        |ИЗ
        |	(ВЫБРАТЬ ПЕРВЫЕ 1000
        |		Время КАК Время
        |	ИЗ
        |		РегистрСведений.МониторингСеансов
        |	ГДЕ
        |		Время <= &КрайняяДатаЗаписи
        |	УПОРЯДОЧИТЬ ПО
        |		Время ВОЗР
        |	) КАК Выборка
        |";
        
        Запрос.УстановитьПараметр("КрайняяДатаЗаписи", ТекДата - МаксимальныйСрокХранения * 3600);
        
        ЕстьУдаление = Истина;
        
        Пока ЕстьУдаление Цикл
            
            Результат = Запрос.Выполнить();
            
            Если НЕ Результат.Пустой() Тогда
                ЕстьУдаление = Истина;
                
                НаборЗаписей = РегистрыСведений.МониторингСеансов.СоздатьНаборЗаписей();
                
                Выборка = Результат.Выбрать();
                Пока Выборка.Следующий() Цикл
                    НаборЗаписей.Отбор.Время.Установить(Выборка.Время);
                    НаборЗаписей.Записать(Истина);
                КонецЦикла;
                
            Иначе
                
                ЕстьУдаление = Ложь;
                
            КонецЕсли;
            
        КонецЦикла;
        
    КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СловарьАгентКИП_в_ЦКК()
    
    Словарь = Новый Соответствие;
    
    Словарь.Вставить("time", "Время");
    Словарь.Вставить("uuid", "ИдентификаторСеанса");
    Словарь.Вставить("server", "Сервер");
    Словарь.Вставить("pid", "Процесс");
    Словарь.Вставить("sessionId", "Сеанс");
    Словарь.Вставить("connId", "НомерСоединения");
    Словарь.Вставить("startedAt", "ДатаНачалаСеанса");
    Словарь.Вставить("lastActiveAt", "ДатаПоследнейАктивности");
    Словарь.Вставить("host", "Компьютер");
    Словарь.Вставить("userName", "Пользователь");
    Словарь.Вставить("appId", "Приложение");
    Словарь.Вставить("locale", "Язык");
    Словарь.Вставить("mainPort", "Порт");
    Словарь.Вставить("dbProcInfo", "СоединениеССУБД");
    Словарь.Вставить("blockedByDbms", "ЗаблокированоСУБД");
    Словарь.Вставить("blockedByLs", "ЗаблокированоУпр");
    Словарь.Вставить("durationCurrentDbms", "ВремяВызововСУБДТекущее");
    Словарь.Вставить("durationLast5MinDbms", "ВремяВызововСУБД5Мин");
    Словарь.Вставить("durationAllDbms", "ВремяВызововСУБДВсего");
    Словарь.Вставить("dbmsBytesLast5Min", "ДанныхСУБД5Мин");
    Словарь.Вставить("dbmsBytesAll", "ДанныхСУБДВсего");
    Словарь.Вставить("durationCurrent", "ВремяВызоваТекущее");
    Словарь.Вставить("durationLast5Min", "ВремяВызовов5Мин");
    Словарь.Вставить("durationAll", "ВремяВызововВсего");
    Словарь.Вставить("callsLast5Min", "КоличествоВызовов5Мин");
    Словарь.Вставить("callsAll", "КоличествоВызововВсего");
    Словарь.Вставить("bytesLast5Min", "ОбъемДанных5Мин");
    Словарь.Вставить("bytesAll", "ОбъемДанныхВсего");
    Словарь.Вставить("memoryCurrent", "ПамятьТекущая");
    Словарь.Вставить("memoryLast5Min", "Память5Мин");
    Словарь.Вставить("memoryTotal", "ПамятьВсего");
    Словарь.Вставить("readBytesCurrent", "ЧтениеТекущее");
    Словарь.Вставить("readBytesLast5Min", "Чтение5Мин");
    Словарь.Вставить("readBytesTotal", "ЧтениеВсего");
    Словарь.Вставить("writeBytesCurrent", "ЗаписьТекущая");
    Словарь.Вставить("writeBytesLast5Min", "Запись5Мин");
    Словарь.Вставить("writeBytesTotal", "ЗаписьВсего");
    Словарь.Вставить("license", "Лицензия");
    Словарь.Вставить("hibernate", "Спящий");
    Словарь.Вставить("passiveSessionHibernateTime", "ЗаснутьЧерез");
    Словарь.Вставить("hibernateSessionTerminateTime", "ЗавершитьЧерез");
    
    Словарь.Вставить("currentServiceName", "ИмяТекущегоСервиса");
    Словарь.Вставить("cpuTimeCurrent", "ПроцессорноеВремяТекущее");
    Словарь.Вставить("durationLast5MinService", "ДлительностьВызововСервисовЗа5Мин");
    Словарь.Вставить("durationCurrentService", "ДлительностьВызововСервисаТекущее");
    Словарь.Вставить("infoBaseId", "ИдентификаторИнформационнойБазы");
    Словарь.Вставить("connectionId", "ИдентификаторСоединения");
    Словарь.Вставить("cpuTimeAll", "ПроцессорноеВремяВсего");
    Словарь.Вставить("durationAllService", "ДлительностьВызововСервисовВсего");
    Словарь.Вставить("cpuTimeLast5Min", "ПроцессорноеВремяЗа5Мин");
    Словарь.Вставить("workingProcessId", "ИдентификаторПроцесса");
    
    Возврат Словарь;
    
КонецФункции

Функция СловарьRAS_в_ЦКК()
    
    Словарь = Новый Соответствие;
    
    Словарь.Вставить("Время", "Время");
    Словарь.Вставить("ИдентификатоСеанса", "ИдентификатоСеанса");
    Словарь.Вставить("Сервер", "Сервер");
    Словарь.Вставить("Процесс", "Процесс");
    Словарь.Вставить("НомерСеанса", "Сеанс");
    Словарь.Вставить("НомерСоединения", "НомерСоединения");
    Словарь.Вставить("ВремяНачала", "ДатаНачалаСеанса");
    Словарь.Вставить("ВремяПоследнейАктивности", "ДатаПоследнейАктивности");
    Словарь.Вставить("ИмяКомпьютера", "Компьютер");
    Словарь.Вставить("ИмяПользователя", "Пользователь");
    Словарь.Вставить("ИмяПриложения", "Приложение");
    Словарь.Вставить("КодЯзыка", "Язык");
    Словарь.Вставить("СоединениеСУБД", "СоединениеССУБД");
    Словарь.Вставить("НомерСеансаБлокирующегоСУБД", "ЗаблокированоСУБД");
    Словарь.Вставить("НомерСеансаВыполнившегоУправляемуюБлокировку", "ЗаблокированоУпр");
    Словарь.Вставить("ДлительностьВызововСУБДТекущее", "ВремяВызововСУБДТекущее");
    Словарь.Вставить("ДлительностьВызововСУБДЗа5Мин", "ВремяВызововСУБД5Мин");
    Словарь.Вставить("ДлительностьВызововСУБДВсего", "ВремяВызововСУБДВсего");
    Словарь.Вставить("ОбъемДанныхПереданныхПолученныхСУБДЗа5Мин", "ДанныхСУБД5Мин");
    Словарь.Вставить("ОбъемДанныхПереданныхПолученныхСУБДВсего", "ДанныхСУБДВсего");
    Словарь.Вставить("ДлительностьВызововТекущее", "ВремяВызоваТекущее");
    Словарь.Вставить("ДлительностьВызововЗа5Мин", "ВремяВызовов5Мин");
    Словарь.Вставить("ДлительностьВызововВсего", "ВремяВызововВсего");
    Словарь.Вставить("КоличествоВызововЗа5Мин", "КоличествоВызовов5Мин");
    Словарь.Вставить("КоличествоВызововВсего", "КоличествоВызововВсего");
    Словарь.Вставить("ОбъемДанныхПереданныхИПолученныхКлиентомЗа5Мин", "ОбъемДанных5Мин");
    Словарь.Вставить("ОбъемДанныхПереданныхИПолученныхКлиентом", "ОбъемДанныхВсего");
    Словарь.Вставить("ПотреблениеПамятиТекущее", "ПамятьТекущая");
    Словарь.Вставить("ПотреблениеПамятиЗа5Мин", "Память5Мин");
    Словарь.Вставить("ПотреблениеПамятиВсего", "ПамятьВсего");
    Словарь.Вставить("ОбъемДанныхСчитанныхСДискаТекущее", "ЧтениеТекущее");
    Словарь.Вставить("ОбъемДанныхСчитанныхСДискаЗа5Минут", "Чтение5Мин");
    Словарь.Вставить("ОбъемДанныхСчитанныхСДискаВсего", "ЧтениеВсего");
    Словарь.Вставить("ОбъемДанныхЗаписанныхНаДискТекущее", "ЗаписьТекущая");
    Словарь.Вставить("ОбъемДанныхЗаписанныхНаДискЗа5Мин", "Запись5Мин");
    Словарь.Вставить("ОбъемДанныхЗаписанныхНаДискВсего", "ЗаписьВсего");
    Словарь.Вставить("Лицензии", "Лицензия");
    Словарь.Вставить("СпящийСеанс", "Спящий");
    Словарь.Вставить("ВремяЗасыпанияПассивногоСеанса", "ЗаснутьЧерез");
    Словарь.Вставить("ВремяЗавершенияСпящегоСеанса", "ЗавершитьЧерез");
    
    Словарь.Вставить("ДлительностьВызововСервисаТекущее", "ДлительностьВызововСервисаТекущее");
    Словарь.Вставить("ДлительностьВызововСервисовВсего", "ДлительностьВызововСервисовВсего");
    Словарь.Вставить("ДлительностьВызововСервисовЗа5Мин", "ДлительностьВызововСервисовЗа5Мин");
    Словарь.Вставить("ИдентификаторИнформационнойБазы", "ИдентификаторИнформационнойБазы");
    Словарь.Вставить("ИдентификаторПроцесса", "ИдентификаторПроцесса");
    Словарь.Вставить("ИдентификаторСоединения", "ИдентификаторСоединения");
    Словарь.Вставить("ИдентификаторСеанса", "ИдентификаторСеанса");
    Словарь.Вставить("ИмяТекущегоСервиса", "ИмяТекущегоСервиса");
    Словарь.Вставить("ПроцессорноеВремяВсего", "ПроцессорноеВремяВсего");
    Словарь.Вставить("ПроцессорноеВремяЗа5Мин", "ПроцессорноеВремяЗа5Мин");
    Словарь.Вставить("ПроцессорноеВремяТекущее", "ПроцессорноеВремяТекущее");
    Словарь.Вставить("РазделениеДанных", "РазделениеДанных");
    
    Возврат Словарь;
    
КонецФункции

Функция ПараметрыАгентКИП_в_ЦКК(Параметры, Словарь)
    
    Если Словарь = Неопределено Тогда
        Словарь = СловарьАгентКИП_в_ЦКК();
    КонецЕсли;
    
    ПараметрыНовые = ПараметрыНовые(Параметры, Словарь);
    
    Возврат ПараметрыНовые;
    
КонецФункции

Функция ПараметрыRAS_в_ЦКК(Параметры, Словарь)
    
    Если Словарь = Неопределено Тогда
        Словарь = СловарьRAS_в_ЦКК();
    КонецЕсли;
    
    ПараметрыНовые = ПараметрыНовые(Параметры, Словарь);
    
    ПараметрыНовые["ИдентификаторИнформационнойБазы"] = Строка(ПараметрыНовые["ИдентификаторИнформационнойБазы"]);
    ПараметрыНовые["ИдентификаторПроцесса"] = Строка(ПараметрыНовые["ИдентификаторПроцесса"]);
    ПараметрыНовые["ИдентификаторСеанса"] = Строка(ПараметрыНовые["ИдентификаторСеанса"]);
    ПараметрыНовые["ИдентификаторСоединения"] = Строка(ПараметрыНовые["ИдентификаторСоединения"]);
    ПараметрыНовые["Лицензия"] = АдминистрированиеКластераRAS.ЛицензииКонвертировать(ПараметрыНовые["Лицензия"]);
            
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