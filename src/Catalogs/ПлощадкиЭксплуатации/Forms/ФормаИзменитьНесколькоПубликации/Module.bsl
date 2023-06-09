
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ЗаполнитьПараметрыЗаписи();
    
    Если ЭтотОбъект.Параметры.Свойство("ЭлементыПлощадки") Тогда
        
        МассивПубликации = ПолучитьПубликации(ЭтотОбъект.Параметры.ЭлементыПлощадки);
        Публикации = Новый СписокЗначений;
        Публикации.ЗагрузитьЗначения(МассивПубликации);
        
        НовЭлемент = Компоновщик.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
        НовЭлемент.Использование = Истина;
        НовЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Публикация");
        НовЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
        НовЭлемент.ПравоеЗначение = Публикации;
                            
    КонецЕсли;
    
    ИнициализироватьКомпоновщик();
    УстановитьОтбор();
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьВсе(Команда)
    
    Для Каждого ТекСтрока Из ЭтотОбъект.ПараметрыЗаписи Цикл
        ТекСтрока.Изменить = Истина;
        Элементы["Список" + ТекСтрока.Параметр].Видимость = Истина; 
    КонецЦикла;
    
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
    
    Для Каждого ТекСтрока Из ЭтотОбъект.ПараметрыЗаписи Цикл
        ТекСтрока.Изменить = Ложь;
        Элементы["Список" + ТекСтрока.Параметр].Видимость = Ложь; 
    КонецЦикла;
    
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
    
    ЗаписатьИзменения();
    ЭтотОбъект.Закрыть();
    
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
    ЗаписатьИзменения();
КонецПроцедуры

&НаКлиенте
Процедура НайтиОтличныеОт(Команда)
    
    ТекДанные = Элементы.ПараметрыЗаписи.ТекущиеДанные;
    ТекДанные.ЕстьОтбор = Истина;
    УстановитьОтборПоПараметру(ТекДанные.Параметр, ТекДанные.ПараметрЗначение);
    
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтличныеОт(Команда)
    
    ТекДанные = Элементы.ПараметрыЗаписи.ТекущиеДанные;
    ТекДанные.ЕстьОтбор = Ложь;
    СнятьОтборПоПараметру(ТекДанные.Параметр);
    
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПараметрыЗаписиПараметрЗначениеПриИзменении(Элемент)
    
    ТекДанные = Элементы.ПараметрыЗаписи.ТекущиеДанные; 
    ЭтотОбъект[ТекДанные.Параметр] = ТекДанные.ПараметрЗначение; 
    
    Если ТекДанные.ЕстьОтбор Тогда
        УстановитьОтборПоПараметру(ТекДанные.Параметр, ТекДанные.ПараметрЗначение);
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаписиПараметрЗначениеПарольПриИзменении(Элемент)
    
    ТекДанные = Элементы.ПараметрыЗаписи.ТекущиеДанные;
    
    Если ТекДанные.Параметр = "Пароль" Тогда
        
        ТекДанные.ПараметрЗначение = ТекДанные.ПараметрЗначениеПароль;
        ЭтотОбъект[ТекДанные.Параметр] = ТекДанные.ПараметрЗначение; 
        
        Если ТекДанные.ЕстьОтбор Тогда
            УстановитьОтборПоПараметру(ТекДанные.Параметр, ТекДанные.ПараметрЗначение);
        КонецЕсли;
    
    КонецЕсли;
        
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаписиИзменитьПриИзменении(Элемент)
    
    Элементы["Список" + Элемент.Родитель.ТекущиеДанные.Параметр].Видимость = Элемент.Родитель.ТекущиеДанные.Изменить; 
    
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастройкиОтборПриИзменении(Элемент)
    УстановитьОтбор();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаписиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
    
    ТекДанные = Элемент.ТекущиеДанные;
        
    Если Поле.Имя = "ПараметрыЗаписиЕстьОтбор" Тогда
        
        Если Элемент.ТекущиеДанные.ЕстьОтбор Тогда
            УстановитьОтборПоПараметру(ТекДанные.Параметр, ТекДанные.ПараметрЗначение);
        Иначе
            СнятьОтборПоПараметру(ТекДанные.Параметр);
        КонецЕсли;
        
        СтандартнаяОбработка = Ложь;
        
        Элементы.КомпоновщикНастройкиОтбор.ОбновитьТекстРедактирования();
        
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаписиПриАктивизацииСтроки(Элемент)
    
    ТекДанные = Элемент.ТекущиеДанные;
    
    Если ТекДанные.Параметр = "ТипПодключения" Тогда
        
        Элементы.ПараметрыЗаписиПараметрЗначение.РежимВыбораИзСписка = Истина;
        Элементы.ПараметрыЗаписиПараметрЗначение.СписокВыбора.Очистить();
        Элементы.ПараметрыЗаписиПараметрЗначение.СписокВыбора.Добавить("RAS");
        Элементы.ПараметрыЗаписиПараметрЗначение.СписокВыбора.Добавить("COM");
        Элементы.ПараметрыЗаписиПараметрЗначение.РедактированиеТекста = Ложь;
           
    Иначе
        
        Элементы.ПараметрыЗаписиПараметрЗначение.РежимВыбораИзСписка = Ложь;
        Элементы.ПараметрыЗаписиПараметрЗначение.СписокВыбора.Очистить();
        Элементы.ПараметрыЗаписиПараметрЗначение.РедактированиеТекста = Истина;
        
    КонецЕсли;
    
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗаписиЕстьОтборПриИзменении(Элемент)
    
    ТекДанные = Элементы.ПараметрыЗаписи.ТекущиеДанные;
    
    Если ТекДанные.ЕстьОтбор Тогда
        УстановитьОтборПоПараметру(ТекДанные.Параметр, ТекДанные.ПараметрЗначение);
    Иначе
        СнятьОтборПоПараметру(ТекДанные.Параметр);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПубликации(ЭлементыПлощадкиМассив)
    
    Запрос = Новый Запрос;
    
    Запрос.Текст = "
    |ВЫБРАТЬ РАЗЛИЧНЫЕ
    |   ВЫРАЗИТЬ(ЕдиницаКонтроля КАК Справочник.Публикации) КАК Публикация
    |ИЗ
    |   Справочник.ПлощадкиЭксплуатации
    |ГДЕ
    |   Ссылка В (&МассивСсылок)
    |   И ТипЭлемента = &ТипЭлемента
    |";
    
    Запрос.УстановитьПараметр("МассивСсылок", ЭлементыПлощадкиМассив);
    Запрос.УстановитьПараметр("ТипЭлемента", Перечисления.ТипЭлементаПлощадки.Публикация);
    
    Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Публикация");
    
КонецФункции

&НаСервере
Процедура ЗаполнитьПараметрыЗаписи()
    
    НастройкиПоУмолчанию = Справочники.Публикации.ПрочитатьНастройкиПоУмолчанию();
        
    ДобавитьПараметр("Логин", "Логин", НастройкиПоУмолчанию.Логин);
    ДобавитьПараметр("Пароль", "Пароль", НастройкиПоУмолчанию.Пароль);
    ДобавитьПараметр("ВыполнятьКонтроль", "Выполнять контроль", НастройкиПоУмолчанию.ВыполнятьКонтроль);
    ДобавитьПараметр("ЗапретитьПеренаправление", "Запретить перенаправление", НастройкиПоУмолчанию.ЗапретитьПеренаправление);
    ДобавитьПараметр("Таймаут", "Таймаут, сек.", НастройкиПоУмолчанию.Таймаут);
    ДобавитьПараметр("ПериодКонтроля", "Период контроля, сек.", НастройкиПоУмолчанию.ПериодКонтроля);
    ДобавитьПараметр("МинимальныйПроцентДоступности", "Минимальная доступность, %", НастройкиПоУмолчанию.МинимальныйПроцентДоступности);
    ДобавитьПараметр("ДопустимоНетДанных", "Допустимо нет данных, сек.", НастройкиПоУмолчанию.ДопустимоНетДанных);
    ДобавитьПараметр("ПроверятьТелоОтвета", "Проверять тело ответа", НастройкиПоУмолчанию.ПроверятьТелоОтвета);
    
КонецПроцедуры

&НаСервере
Процедура ДобавитьПараметр(Параметр, ПараметрПредставление, ПараметрЗначение)
    
    ЭтотОбъект[Параметр] = ПараметрЗначение;
    
    НовСтрока = ЭтотОбъект.ПараметрыЗаписи.Добавить();
    НовСтрока.Изменить = Истина;
    НовСтрока.Параметр = Параметр;
    НовСтрока.ПараметрПредставление = ПараметрПредставление;
    НовСтрока.ПараметрЗначение = ПараметрЗначение;
    НовСтрока.ПараметрЗначениеПароль = ПараметрЗначение;
    НовСтрока.ЕстьОтбор = Ложь;
    
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзменения()
    
    НастройкиДляЗаписи = Новый Структура;
    
    Для Каждого ТекСтрока Из ПараметрыЗаписи Цикл
        
        Если ТекСтрока.Изменить Тогда
            
            НастройкиДляЗаписи.Вставить(ТекСтрока.Параметр, ТекСтрока.ПараметрЗначение);
                        
        КонецЕсли;
        
    КонецЦикла;
    
    ПубликацииСписок = Новый СписокЗначений;
    Для Каждого ТекСтрока Из Список Цикл
        Справочники.Публикации.ЗаписатьНастройки(ТекСтрока.Публикация, НастройкиДляЗаписи);
        ПубликацииСписок.Добавить(ТекСтрока.Публикация);
    КонецЦикла;
    
    Компоновщик.Настройки.Отбор.Элементы.Очистить();
    
    Для Каждого ТекПараметр Из ПараметрыЗаписи Цикл
        ТекПараметр.ЕстьОтбор = Ложь;
    КонецЦикла;
    
    НовЭлемент = Компоновщик.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    НовЭлемент.Использование = Истина;
    НовЭлемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Публикация");
    НовЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
    НовЭлемент.ПравоеЗначение = ПубликацииСписок;
    
    УстановитьОтбор();
    
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьКомпоновщик()
    
    СКД = Новый СхемаКомпоновкиДанных();
	ИсточникСКД = СКД.ИсточникиДанных.Добавить();
	ИсточникСКД.Имя = "ИсточникДанных1";
	ИсточникСКД.ТипИсточникаДанных = "local";
    
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
    НаборДанных.ИсточникДанных = ИсточникСКД.Имя;
    НаборДанных.Имя = "НаборДанных1";
    НаборДанных.ИмяОбъекта = "НаборДанных1";
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "Публикация";
    Поле.ПутьКДанным = "Публикация";
    Поле.Заголовок = "Публикация";
    Поле.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Публикации");
    Поле.ОграничениеИспользованияРеквизитов.Условие = Истина;
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "Наименование";
    Поле.ПутьКДанным = "Наименование";
    Поле.Заголовок = "Наименование";
    Поле.ТипЗначения = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(150));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "АдресРесурса";
    Поле.ПутьКДанным = "АдресРесурса";
    Поле.Заголовок = "Адрес ресурса";
    Поле.ТипЗначения = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(500));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "Логин";
    Поле.ПутьКДанным = "Логин";
    Поле.Заголовок = "Логин";
    Поле.ТипЗначения = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(255));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "Пароль";
    Поле.ПутьКДанным = "Пароль";
    Поле.Заголовок = "Пароль";
    Поле.ТипЗначения = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(255));
        
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "ВыполнятьКонтроль";
    Поле.ПутьКДанным = "ВыполнятьКонтроль";
    Поле.Заголовок = "Выполнять контроль";
    Поле.ТипЗначения = Новый ОписаниеТипов("Булево");
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "ЗапретитьПеренаправление";
    Поле.ПутьКДанным = "ЗапретитьПеренаправление";
    Поле.Заголовок = "Запретить перенаправление";
    Поле.ТипЗначения = Новый ОписаниеТипов("Булево");
    
    Поле.Поле = "Таймаут";
    Поле.ПутьКДанным = "Таймаут";
    Поле.Заголовок = "Таймаут, сек.";
    Поле.ТипЗначения = Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(5,0));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "ПериодКонтроля";
    Поле.ПутьКДанным = "ПериодКонтроля";
    Поле.Заголовок = "Период контроля, сек.";
    Поле.ТипЗначения = Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(5,0));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "МинимальныйПроцентДоступности";
    Поле.ПутьКДанным = "МинимальныйПроцентДоступности";
    Поле.Заголовок = "Минимальная доступность, %";
    Поле.ТипЗначения = Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(3,0));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "ДопустимоНетДанных";
    Поле.ПутьКДанным = "ДопустимоНетДанных";
    Поле.Заголовок = "Допустимо нет данных, сек.";
    Поле.ТипЗначения = Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(5,0));
    
    Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
    Поле.Поле = "ПроверятьТелоОтвета";
    Поле.ПутьКДанным = "ПроверятьТелоОтвета";
    Поле.Заголовок = "Проверять тело ответа";
    Поле.ТипЗначения = Новый ОписаниеТипов("Булево");
                
    URLСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
    Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
    
    ГруппировкаНастроек = Компоновщик.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
        
    Поле = ГруппировкаНастроек.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле.Использование = Истина;
    ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Публикация");
    
    Поле = ГруппировкаНастроек.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле.Использование = Истина;
    ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Наименование");
    
    Поле = ГруппировкаНастроек.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле.Использование = Истина;
    ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("АдресРесурса");
    
    Для Каждого ТекПараметр Из ПараметрыЗаписи Цикл
        
        Поле = ГруппировкаНастроек.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
        ВыбранноеПоле = Компоновщик.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
        ВыбранноеПоле.Использование = Истина;
        ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных(ТекПараметр.Параметр);
                
    КонецЦикла;
    
КонецПроцедуры

&НаСервере
Процедура КомпоновщикНастройкиОтборПриИзмененииНаСервере()
    
    УстановитьОтбор();
    
КонецПроцедуры

&НаКлиенте
Функция ГруппаНайтиОтличныеОт(Создать = Истина)
    
    ГруппаНайтиОтличныеОт = Неопределено;
    
    Для Каждого ТекЭлемент Из Компоновщик.Настройки.Отбор.Элементы Цикл
        
        Если ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") И ТекЭлемент.ИдентификаторПользовательскойНастройки = "b1c27381-4a1c-4dc2-9aea-3dc9b02baa72" Тогда
            ГруппаНайтиОтличныеОт = ТекЭлемент;
            Прервать;
        КонецЕсли;
        
    КонецЦикла;
    
    Если ГруппаНайтиОтличныеОт = Неопределено И Создать Тогда
        
        ГруппаНайтиОтличныеОт = Компоновщик.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
        ГруппаНайтиОтличныеОт.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
        ГруппаНайтиОтличныеОт.Использование = Истина;
        ГруппаНайтиОтличныеОт.ИдентификаторПользовательскойНастройки = "b1c27381-4a1c-4dc2-9aea-3dc9b02baa72";
        
    КонецЕсли;
    
    Возврат ГруппаНайтиОтличныеОт;
    
КонецФункции

&НаКлиенте
Процедура УстановитьОтборПоПараметру(Параметр, ПараметрЗначение)
    
    ГруппаНайтиОтличныеОт = ГруппаНайтиОтличныеОт();
        
    ЭлементОтбора = Неопределено;
    
    Для Каждого ТекЭлемент Из ГруппаНайтиОтличныеОт.Элементы Цикл
        Если Строка(ТекЭлемент.ЛевоеЗначение) = Параметр Тогда
            ЭлементОтбора = ТекЭлемент;
            Прервать;
        КонецЕсли;
    КонецЦикла;
    
    Если ЭлементОтбора = Неопределено Тогда
        ЭлементОтбора = ГруппаНайтиОтличныеОт.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    КонецЕсли;
    
    ЭлементОтбора.Использование = Истина;
    ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Параметр);
    ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
    ЭлементОтбора.ПравоеЗначение = ПараметрЗначение;
    
    Элементы.КомпоновщикНастройкиОтбор.ОбновитьТекстРедактирования();
    
    КомпоновщикНастройкиОтборПриИзмененииНаСервере();
    
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтборПоПараметру(Параметр)
    
    ГруппаНайтиОтличныеОт = ГруппаНайтиОтличныеОт(Ложь);
    
    Если ГруппаНайтиОтличныеОт <> Неопределено Тогда
                
        ЭлементОтбора = Неопределено;
        
        Для Каждого ТекЭлемент Из ГруппаНайтиОтличныеОт.Элементы Цикл
            Если Строка(ТекЭлемент.ЛевоеЗначение) = Параметр Тогда
                ЭлементОтбора = ТекЭлемент;
                Прервать;
            КонецЕсли;
        КонецЦикла;
        
        Если ЭлементОтбора = Неопределено Тогда
            ЭлементОтбора = ГруппаНайтиОтличныеОт.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
        КонецЕсли;
        
        Если ЭлементОтбора <> Неопределено Тогда
            
            ГруппаНайтиОтличныеОт.Элементы.Удалить(ЭлементОтбора);
            Элементы.КомпоновщикНастройкиОтбор.ОбновитьТекстРедактирования();
            
            Если ГруппаНайтиОтличныеОт.Элементы.Количество() = 0 Тогда
                Компоновщик.Настройки.Отбор.Элементы.Удалить(ГруппаНайтиОтличныеОт);
            КонецЕсли;
            
            КомпоновщикНастройкиОтборПриИзмененииНаСервере();
            
        КонецЕсли;
        
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементОтбора(ГруппаЭлементов, ИмяЭлемента)
    
    ЭлементыУдалить = Новый Массив;
    
    Для Каждого ТекЭлемент Из ГруппаЭлементов.Элементы Цикл
        
        Если ТипЗнч(ТекЭлемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
            УдалитьЭлементОтбора(ТекЭлемент, ИмяЭлемента);
        Иначе
            Если Строка(ТекЭлемент.ЛевоеЗначение) = ИмяЭлемента Тогда
                ЭлементыУдалить.Добавить(ТекЭлемент);
            КонецЕсли;
        КонецЕсли;
                
    КонецЦикла;
    
    Для Каждого ТекЭлемент Из ЭлементыУдалить Цикл
        ГруппаЭлементов.Элементы.Удалить(ТекЭлемент);
    КонецЦикла;
            
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
    
    Если НЕ Компоновщик.ПолучитьНастройки().НаличиеОтбораУЭлемента(Компоновщик.ПолучитьНастройки()) Тогда
        Для Каждого ТекСтрока Из ПараметрыЗаписи Цикл
            ТекСтрока.ЕстьОтбор = Ложь;
        КонецЦикла;
    КонецЕсли;
        
    КомпоновщикЗапрос = Новый КомпоновщикНастроекКомпоновкиДанных();
    СКД = Новый СхемаКомпоновкиДанных();
    
    ИсточникСКД = СКД.ИсточникиДанных.Добавить();
    ИсточникСКД.Имя = "ИсточникДанных1";
    ИсточникСКД.ТипИсточникаДанных = "local";
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
    НаборДанных.Запрос = ТекстЗапроса(); 
    НаборДанных.ИсточникДанных = ИсточникСКД.Имя;
    НаборДанных.Имя = "НаборДанных1";
    URLСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
    КомпоновщикЗапрос.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
    КомпоновщикЗапрос.ЗагрузитьНастройки(Компоновщик.ПолучитьНастройки());
    УдалитьИзВременногоХранилища(URLСхемы);
    
    УдалитьЭлементОтбора(КомпоновщикЗапрос.Настройки.Отбор, "Логин");
    УдалитьЭлементОтбора(КомпоновщикЗапрос.Настройки.Отбор, "Пароль");
        
    ГруппировкаНастроек = КомпоновщикЗапрос.Настройки.Структура[0];
    
    Поле = ГруппировкаНастроек.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле = КомпоновщикЗапрос.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
    ВыбранноеПоле.Использование = Истина;
    ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("ДанныеХранилища");
    
    УстановитьПривилегированныйРежим(Истина);
    
    ТЗнБуфер = Новый ТаблицаЗначений;
   
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
    МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(
        СКД, 
        КомпоновщикЗапрос.Настройки,,,
        Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
    );
    
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных();
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
    ПроцессорВывода.УстановитьОбъект(ТЗнБуфер);
        
    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
    
    УстановитьПривилегированныйРежим(Ложь);
    
    Для Каждого ТекСтрока Из ТЗнБуфер Цикл
        
        Если ТекСтрока.ДанныеХранилища <> Неопределено Тогда
            ДанныеХранилища = ТекСтрока.ДанныеХранилища.Получить();
            Если ДанныеХранилища <> Неопределено Тогда
                ТекСтрока.Логин = ДанныеХранилища.Логин;
                ТекСтрока.Пароль = ДанныеХранилища.Пароль;
            Иначе
                ТекСтрока.Логин = "";
                ТекСтрока.Пароль = "";
            КонецЕсли;
        Иначе
            ТекСтрока.Логин = "";
            ТекСтрока.Пароль = "";
        КонецЕсли;
                
    КонецЦикла;
    
    СписокБуфер = Новый ТаблицаЗначений;
    
    СКД = Новый СхемаКомпоновкиДанных();
    ИсточникСКД = СКД.ИсточникиДанных.Добавить();
    ИсточникСКД.Имя = "ИсточникДанных1";
    ИсточникСКД.ТипИсточникаДанных = "local";
    
    НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
    НаборДанных.ИсточникДанных = ИсточникСКД.Имя;
    НаборДанных.Имя = "НаборДанных1";
    НаборДанных.ИмяОбъекта = "НаборДанных1";
    
    Для Каждого Колонка Из ТЗнБуфер.Колонки Цикл
        Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
        Поле.Поле = Колонка.Имя;
        Поле.ПутьКДанным = Колонка.Имя;
        Поле.Заголовок = Колонка.Заголовок;
        Поле.ТипЗначения = Колонка.ТипЗначения;
    КонецЦикла;
    
    URLСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
    
    КомпоновщикБуфер = Новый КомпоновщикНастроекКомпоновкиДанных;
    КомпоновщикБуфер.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
    КомпоновщикБуфер.ЗагрузитьНастройки(Компоновщик.ПолучитьНастройки());
    
    КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
    МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(
        СКД, 
        КомпоновщикБуфер.Настройки,,,
        Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений")
    );
    
    ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных();
    ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, Новый Структура("НаборДанных1", ТЗнБуфер));
    
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений();
    ПроцессорВывода.УстановитьОбъект(СписокБуфер);
    
    ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных, Истина);
    ЭтотОбъект.Список.Загрузить(СписокБуфер);
            
КонецПроцедуры

&НаСервере
Функция ТекстЗапроса()
    
    ТекстЗапроса = "
    |ВЫБРАТЬ
    |   Публикации.Ссылка КАК Публикация,
    |   Публикации.Наименование КАК Наименование,
    |   Публикации.АдресРесурса КАК АдресРесурса,
    |   ВЫРАЗИТЬ("""" КАК СТРОКА(100)) КАК Логин,
    |   ВЫРАЗИТЬ("""" КАК СТРОКА(100)) КАК Пароль,
    |   БезопасноеХранилище.ДанныеХранилища КАК ДанныеХранилища,
    |";
    
    Для Каждого ТекПараметр Из ПараметрыЗаписи Цикл
        
        Если
            ТекПараметр.Параметр <> "Логин"
            И ТекПараметр.Параметр <> "Пароль"
        Тогда
            ТекстЗапроса = ТекстЗапроса + " Публикации." + ТекПараметр.Параметр + ",";
        КонецЕсли;
        
    КонецЦикла;
    
    ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 1) + "
    |ИЗ
    |   Справочник.Публикации КАК Публикации
    |ЛЕВОЕ СОЕДИНЕНИЕ
    |   РегистрСведений.БезопасноеХранилище КАК БезопасноеХранилище
    |ПО
    |   БезопасноеХранилище.ВладелецХранилища = Публикации.Ссылка
    |";
           
    Возврат ТекстЗапроса;
    
КонецФункции

#КонецОбласти
